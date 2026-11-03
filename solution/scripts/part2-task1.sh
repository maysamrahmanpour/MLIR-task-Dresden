#!/usr/bin/env bash
source "$(dirname "$0")/part2-env.sh"
for kernel in jacobi seidel; do
  "$STENCIL_OPT" "$ROOT/part2/$kernel.mlir" -o "$P2/$kernel.parsed.mlir"
  "$STENCIL_OPT" "$P2/$kernel.parsed.mlir" -o /dev/null
done
python3 "$ROOT/scripts/test-stencil-verifier.py" "$STENCIL_OPT" | tee "$P2/verifier-tests.txt"
