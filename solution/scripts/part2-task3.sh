#!/usr/bin/env bash
source "$(dirname "$0")/part2-env.sh"
"$STENCIL_OPT" "$ROOT/part2/seidel.mlir" \
  --pass-pipeline='builtin.module(func.func(lower-stencil-sweep))' \
  -o "$P2/seidel.scf.mlir"
python3 "$ROOT/scripts/check-stencil-ir.py" sweep "$P2/seidel.scf.mlir"
