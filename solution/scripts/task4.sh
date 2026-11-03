#!/usr/bin/env bash
source "$(dirname "$0")/env.sh"
# Perform the actual interchange with upstream MLIR, not a handwritten replacement.
"$OPT" "$ROOT/part1/generic.mlir" \
  --transform-preload-library="transform-library-paths=$ROOT/part1/interchange.mlir" \
  --transform-interpreter -o "$OUT/interchanged.same-symbol.mlir"
# Rename only the function symbol to link both versions into one executable.
sed 's/@matmul_generic(/@matmul_interchanged(/g' \
  "$OUT/interchanged.same-symbol.mlir" > "$OUT/interchanged.mlir"
for kind in scf affine; do
  pass=convert-linalg-to-loops
  [[ "$kind" == affine ]] && pass=convert-linalg-to-affine-loops
  "$OPT" "$OUT/interchanged.mlir" "--$pass" -o "$OUT/interchanged.$kind.raw.mlir"
  python3 "$ROOT/scripts/annotate.py" "$OUT/interchanged.$kind.raw.mlir" \
    "$OUT/interchanged.$kind.mlir" ikj
done
