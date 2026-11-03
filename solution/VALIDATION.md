# Validation

I built and tested the project on Ubuntu in WSL with LLVM/MLIR 23.1.3,
using a Release build with assertions enabled.

## Build and tests

- The modified starter compiled and linked successfully.
- The starter test passed: 1/1.
- Part 1 ran through all steps, from MLIR lowering to compiling and running
  the executable.
- I tested the original and interchanged matmul with 7 cases each.
  All results had zero error and were bit-identical to the reference.
- Changing the reduction iterator to parallel was accepted by the verifier,
  although the annotation is incorrect.
- All 7 negative tests for the stencil verifier passed.
- The structural checks for apply and sweep passed.
- Jacobi and Seidel each passed 20 test cases. The results were bit-identical,
  with zero error and unchanged boundaries. For Jacobi, both A and B were checked.
- The rounding example showed that division and multiplication by the
  reciprocal can give different results, using x = 7.

## C++ drivers

The drivers and reference calculations use C++17. They compiled with GCC
and gave the same output as the C versions when tested with the same host
model kernels.

The LLVM/MLIR execution results above were recorded with the C drivers
before converting them to C++.

## Code and IR checks

The checks also covered the dialect and passes, the handwritten and generated
generic matmul, and the structure of the lowered IR. The shell and Python
scripts passed syntax checks.

The annotated LLVM files contain the same IR as the generated files, with
comments added to explain the code.

The LLVM build script passed a shell syntax check. The equivalent build
configuration was used for the installed LLVM/MLIR toolchain.

## Test scope

These tests check the results for the selected inputs, boundary values,
invalid operations and the generated IR structure. They do not cover every
possible input.
