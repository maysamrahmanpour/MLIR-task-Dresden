// x86-64 default MLIR ranked-memref C wrapper ABI, index lowered to i64.
#include <cinttypes>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <algorithm>

struct MemRef2D {
  double *allocated;
  double *aligned;
  int64_t offset;
  int64_t sizes[2];
  int64_t strides[2];
};

// needed for calling the original MLIR-generated matmul wrapper with C linkage.
extern "C" void _mlir_ciface_matmul_generic(MemRef2D *, MemRef2D *, MemRef2D *);

// needed for calling the loop-interchanged MLIR-generated matmul wrapper with C linkage.
extern "C" void _mlir_ciface_matmul_interchanged(MemRef2D *, MemRef2D *, MemRef2D *);

// needed for storing and calling either matmul kernel through a common function pointer type.
using Kernel = void (*)(MemRef2D *, MemRef2D *, MemRef2D *);


// needed for describing a contiguous row-major matrix using the MLIR memref interface.
static MemRef2D descriptor(double *p, int64_t rows, int64_t cols) {
  MemRef2D m = {p, p, 0, {rows, cols}, {cols, 1}};
  return m;
}

// needed for computing the expected C += A * B result to validate the compiled MLIR kernels.
static void reference(int64_t m, int64_t n, int64_t k,
                      const double *a, const double *b, double *c) {
  for (int64_t i = 0; i < m; ++i)
    for (int64_t j = 0; j < n; ++j)
      for (int64_t q = 0; q < k; ++q)
        c[i*n+j] += a[i*k+q] * b[q*n+j];
}

// needed for testing both compiled MLIR kernels against the reference for given matrix dimensions.
static int check_case(int64_t m, int64_t n, int64_t k) {
  // Keep one element even for empty matrices so descriptors have valid pointers.
  const auto count = [](int64_t n) { return static_cast<std::size_t>(std::max<int64_t>(n, 1)); };
  std::vector<double> a(count(m*k)), b(count(k*n));
  std::vector<double> initial(count(m*n)), expected(count(m*n)), actual(count(m*n));
  for (int64_t q=0; q<m*k; ++q) a[q] = ((q*7)%23-11) / 7.0;
  for (int64_t q=0; q<k*n; ++q) b[q] = ((q*5)%19-9) / 11.0;
  // Nonzero C detects accidental overwrite/initialization instead of accumulation.
  for (int64_t q=0; q<m*n; ++q) initial[q] = 0.25 + (q%13)/17.0;
  expected = initial;
  reference(m,n,k,a.data(),b.data(),expected.data());
  MemRef2D A=descriptor(a.data(),m,k), B=descriptor(b.data(),k,n), C=descriptor(actual.data(),m,n);
  Kernel kernels[] = {_mlir_ciface_matmul_generic, _mlir_ciface_matmul_interchanged};
  const char *names[] = {"original", "interchanged"};
  int failed=0;
  for (int v=0; v<2; ++v) {
    std::copy(initial.begin(), initial.end(), actual.begin());
    kernels[v](&A,&B,&C);
    double max_error=0;
    int bad=0;
    for (int64_t q=0; q<m*n; ++q) {
      double err=std::fabs(actual[q]-expected[q]);
      if (err>max_error) max_error=err;
      if (!std::isfinite(actual[q]) || err>1e-12*(1+std::fabs(expected[q]))) bad=1;
    }
    int bits_equal=std::memcmp(actual.data(),expected.data(),(size_t)(m*n)*sizeof(double))==0;
    std::printf("%s M=%" PRId64 " N=%" PRId64 " K=%" PRId64
           " : %s max_error=%.3g bit_identical=%s\n",
           names[v],m,n,k,bad?"FAIL":"PASS",max_error,bits_equal?"yes":"no");
    failed |= bad;
  }
  return failed;
}
int main(void) {
  const int64_t cases[][3]={{1,1,1},{2,3,4},{7,5,9},{16,17,13},
                            {3,4,0},{0,4,3},{3,0,4}};
  int failed=0;
  for (size_t q=0; q<sizeof(cases)/sizeof(cases[0]); ++q)
    failed |= check_case(cases[q][0],cases[q][1],cases[q][2]);
  return failed ? EXIT_FAILURE : EXIT_SUCCESS;
}
