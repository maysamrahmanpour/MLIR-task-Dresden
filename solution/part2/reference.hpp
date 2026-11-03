#ifndef STENCIL_REFERENCE_HPP
#define STENCIL_REFERENCE_HPP
#include <cstdint>
// Direct C++ transcription of the kernels printed in the assignment, with
// rectangular-grid extension. Square grids are the PolyBench/C kernel case.
#if defined(JACOBI) || defined(REFERENCE_BOTH)
static void reference_jacobi(int64_t tsteps, int64_t rows, int64_t cols,
                             double *a, double *b) {
  for (int64_t t=0; t<tsteps; ++t) {
    for (int64_t i=1; i<rows-1; ++i)
      for (int64_t j=1; j<cols-1; ++j)
        b[i*cols+j] = 0.2 * (a[i*cols+j] + a[i*cols+j-1]
                         + a[i*cols+j+1] + a[(i+1)*cols+j] + a[(i-1)*cols+j]);
    for (int64_t i=1; i<rows-1; ++i)
      for (int64_t j=1; j<cols-1; ++j)
        a[i*cols+j] = 0.2 * (b[i*cols+j] + b[i*cols+j-1]
                         + b[i*cols+j+1] + b[(i+1)*cols+j] + b[(i-1)*cols+j]);
  }
}
#endif
#if !defined(JACOBI) || defined(REFERENCE_BOTH)
static void reference_seidel(int64_t tsteps, int64_t rows, int64_t cols, double *a) {
  for (int64_t t=0; t<tsteps; ++t)
    for (int64_t i=1; i<rows-1; ++i)
      for (int64_t j=1; j<cols-1; ++j)
        a[i*cols+j] = (a[(i-1)*cols+j-1] + a[(i-1)*cols+j] + a[(i-1)*cols+j+1]
                     + a[i*cols+j-1] + a[i*cols+j] + a[i*cols+j+1]
                     + a[(i+1)*cols+j-1] + a[(i+1)*cols+j] + a[(i+1)*cols+j+1]) / 9.0;
}
#endif
#endif
