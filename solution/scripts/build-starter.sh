#!/usr/bin/env bash
source "$(dirname "$0")/env.sh"
# This solution directory belongs directly under the starter repository root.
REPO=$(cd "$ROOT/.." && pwd)
LLVM_BUILD=${LLVM_BUILD:-"$HOME/projects/llvm-build"}
cmake -S "$REPO" -B "$REPO/build" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR="$LLVM_PREFIX/lib/cmake/mlir" \
  -DLLVM_EXTERNAL_LIT="$LLVM_BUILD/bin/llvm-lit"
cmake --build "$REPO/build" --parallel 4
cmake --build "$REPO/build" --target check-standalone-opt
