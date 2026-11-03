#!/usr/bin/env bash
source "$(dirname "$0")/env.sh"
for kind in scf affine; do
  pass=convert-linalg-to-loops
  [[ "$kind" == affine ]] && pass=convert-linalg-to-affine-loops
  "$OPT" "$ROOT/part1/generic.mlir" "--$pass" -o "$OUT/original.$kind.raw.mlir"
  python3 "$ROOT/scripts/annotate.py" "$OUT/original.$kind.raw.mlir" \
    "$OUT/original.$kind.mlir" ijk
done
