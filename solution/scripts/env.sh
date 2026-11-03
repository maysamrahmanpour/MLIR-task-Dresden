#!/usr/bin/env bash
# Source this file from the task scripts.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
LLVM_PREFIX=${LLVM_PREFIX:-"$HOME/opt/llvm-23.1.3"}
OPT="$LLVM_PREFIX/bin/mlir-opt"
TRANSLATE="$LLVM_PREFIX/bin/mlir-translate"
CC="$LLVM_PREFIX/bin/clang"
CXX="$LLVM_PREFIX/bin/clang++"
OUT="$ROOT/results/part1"
mkdir -p "$OUT"
if [[ ! -x "$OPT" ]]; then
  echo "Missing $OPT. Finish the LLVM install or set LLVM_PREFIX." >&2
  exit 1
fi
