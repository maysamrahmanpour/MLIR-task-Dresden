# MLIR assignment solution

This repository contains my solution for both parts of the MLIR assignment.
The answers to Q1–Q12 are in `solution/REPORT.md`. Test results and remaining
checks are described in `solution/VALIDATION.md`.

The drivers, reference calculations and rounding example use C++17.
The scripts use clang++ to compile and link the C++ code, and clang to
compile LLVM IR into object files. The stencil dialect and its lowering
passes are also written in C++.

The C++ update changes the drivers and their build commands. The MLIR
kernels and stencil passes are unchanged.

## Build and run

On Ubuntu, install the required packages:

```bash
sudo apt install build-essential git cmake ninja-build clang lld python3 \
  libffi-dev libzstd-dev zlib1g-dev libedit-dev
```

The project uses LLVM/MLIR 23.1.3. Run these commands from the repository root:

```bash
export LLVM_PREFIX="$HOME/opt/llvm-23.1.3"
export LLVM_BUILD="$HOME/projects/llvm-build"

# needed for building LLVM/MLIR if it is not already installed.
bash solution/scripts/build-llvm.sh

# needed for building the starter project with the stencil dialect and passes.
bash solution/scripts/build-starter.sh

# needed for running the Part 1 tasks and tests.
bash solution/scripts/run-part1.sh

# needed for running the Part 2 tasks and tests.
bash solution/scripts/run-part2.sh
```

If LLVM/MLIR is already installed, skip `build-llvm.sh`.

Each task has a script in `solution/scripts/`. Generated IR and test results
are saved in `solution/results/part1/` and `solution/results/part2/`.

The annotated LLVM files are separate from the raw generated files.
Running the scripts again updates the raw files, but not these annotations.
If the source or compiler changes, check that the annotations still match.
