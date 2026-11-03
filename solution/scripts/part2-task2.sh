#!/usr/bin/env bash
source "$(dirname "$0")/part2-env.sh"
"$STENCIL_OPT" "$ROOT/part2/jacobi.mlir" \
  --pass-pipeline='builtin.module(func.func(lower-stencil-apply))' \
  -o "$P2/jacobi.linalg.mlir"
python3 "$ROOT/scripts/check-stencil-ir.py" apply "$P2/jacobi.linalg.mlir"
