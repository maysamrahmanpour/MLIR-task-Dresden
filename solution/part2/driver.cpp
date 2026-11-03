#include <cinttypes>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <algorithm>
#include "reference.hpp"

struct MemRef2D {
  double *allocated, *aligned;
  int64_t offset, sizes[2], strides[2];
};
#ifdef JACOBI
extern "C" void _mlir_ciface_kernel_jacobi_2d(int64_t, MemRef2D *, MemRef2D *);
#define NAME "jacobi"
#else
extern "C" void _mlir_ciface_kernel_seidel_2d(int64_t, MemRef2D *);
#define NAME "seidel"
#endif
static MemRef2D descriptor(double *p, int64_t rows, int64_t cols) {
  MemRef2D d={p,p,0,{rows,cols},{cols,1}};return d;
}

static int compare(const char *label, const double *got, const double *expected,
                   const double *initial, int64_t rows, int64_t cols) {
  int bad=0, boundary_bad=0;double max_error=0;
  for(int64_t i=0;i<rows;++i) for(int64_t j=0;j<cols;++j) {
    int64_t q=i*cols+j;
    double err=std::fabs(got[q]-expected[q]);
    if(err>max_error) max_error=err;
    if(!std::isfinite(got[q]) || err>1e-12*(1+std::fabs(expected[q]))) bad=1;
    if((i==0 || j==0 || i==rows-1 || j==cols-1) &&
       std::memcmp(&got[q],&initial[q],sizeof(double))) boundary_bad=1;
  }
  int bits=std::memcmp(got,expected,(size_t)(rows*cols)*sizeof(double))==0;
  std::printf("  %s %s max_error=%.17g bit_identical=%s boundaries=%s\n",
    label,(bad||boundary_bad)?"FAIL":"PASS",max_error,bits?"yes":"no",
    boundary_bad?"CHANGED":"unchanged");
  // Enforce strict baseline bit equality as well as reporting numerical error.
  return bad || boundary_bad || !bits;
}
static int run_case(int64_t rows,int64_t cols,int64_t tsteps,int mixed) {
  const auto count=static_cast<std::size_t>(rows*cols);
  std::vector<double> a(count), initial_a(count), ref_a(count);
#ifdef JACOBI
  std::vector<double> b(count), initial_b(count), ref_b(count);
#endif
  for(int64_t i=0;i<rows;++i) for(int64_t j=0;j<cols;++j) {
    int64_t q=i*cols+j;
    a[q]=mixed ? ((q*13)%29-14)/7.0 : (double)(i*(j+2)+2)/cols;
#ifdef JACOBI
    b[q]=mixed ? ((q*11)%31-15)/9.0 : (double)(i*(j+3)+3)/cols;
#endif
  }
  initial_a=a; ref_a=a;
  MemRef2D A=descriptor(a.data(),rows,cols);
#ifdef JACOBI
  initial_b=b; ref_b=b;
  MemRef2D B=descriptor(b.data(),rows,cols);
  reference_jacobi(tsteps,rows,cols,ref_a.data(),ref_b.data());
  _mlir_ciface_kernel_jacobi_2d(tsteps,&A,&B);
#else
  reference_seidel(tsteps,rows,cols,ref_a.data());
  _mlir_ciface_kernel_seidel_2d(tsteps,&A);
#endif
  std::printf("%s rows=%" PRId64 " cols=%" PRId64 " tsteps=%" PRId64 " init=%s\n",
    NAME,rows,cols,tsteps,mixed?"mixed-sign":"polybench-style");
  int failed=compare("A",a.data(),ref_a.data(),initial_a.data(),rows,cols);
#ifdef JACOBI
  failed |= compare("B",b.data(),ref_b.data(),initial_b.data(),rows,cols);
  
#endif
  return failed;
}
int main(void) {
  const int64_t cases[][3]={{2,2,0},{2,5,3},{5,2,3},{3,3,1},{5,5,0},
                            {5,5,1},{5,5,3},{8,11,4},{16,16,5},{30,30,20}};
  int failed=0;
  for(size_t c=0;c<sizeof(cases)/sizeof(cases[0]);++c)
    for(int mixed=0;mixed<2;++mixed)
      failed |= run_case(cases[c][0],cases[c][1],cases[c][2],mixed);
  return failed?EXIT_FAILURE:EXIT_SUCCESS;
}
