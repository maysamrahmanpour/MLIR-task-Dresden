#!/usr/bin/env bash
# Part 1 Task 1 toolchain recipe. Existing build caches retain their source path.
set -euo pipefail
LLVM_BUILD=${LLVM_BUILD:-"$HOME/projects/llvm-build"}
LLVM_PREFIX=${LLVM_PREFIX:-"$HOME/opt/llvm-23.1.3"}
if [[ -z "${LLVM_SOURCE:-}" && -f "$LLVM_BUILD/CMakeCache.txt" ]]; then
  LLVM_SOURCE=$(sed -n 's/^CMAKE_HOME_DIRECTORY:INTERNAL=//p' "$LLVM_BUILD/CMakeCache.txt")
  LLVM_SOURCE=${LLVM_SOURCE%/llvm}
fi
LLVM_SOURCE=${LLVM_SOURCE:-"$HOME/projects/llvm-project"}
if [[ ! -e "$LLVM_SOURCE" ]]; then
  mkdir -p "$(dirname "$LLVM_SOURCE")"
  git clone --depth 1 --branch llvmorg-23.1.3 \
    https://github.com/llvm/llvm-project.git "$LLVM_SOURCE"
fi
actual=$(git -C "$LLVM_SOURCE" rev-parse HEAD)
expected=$(git -C "$LLVM_SOURCE" rev-parse 'llvmorg-23.1.3^{commit}')
[[ "$actual" == "$expected" ]] || { echo 'LLVM source is not at llvmorg-23.1.3; refusing to change it.' >&2; exit 1; }
cmake -S "$LLVM_SOURCE/llvm" -B "$LLVM_BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$LLVM_PREFIX" \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_ENABLE_PROJECTS='mlir;clang' -DLLVM_TARGETS_TO_BUILD=Native \
  -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_LLD=ON \
  -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_INSTALL_UTILS=ON
cmake --build "$LLVM_BUILD" --parallel "${BUILD_JOBS:-4}"
cmake --install "$LLVM_BUILD"
