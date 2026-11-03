#!/usr/bin/env bash
source "$(dirname "$0")/part2-env.sh"
for kernel in jacobi seidel; do
  input="$P2/seidel.scf.mlir"
  [[ "$kernel" == jacobi ]] && input="$P2/jacobi.linalg.mlir"
  "$OPT" "$input" --convert-linalg-to-loops --expand-strided-metadata \
    --lower-affine -o "$P2/$kernel.loops.mlir"
  "$OPT" "$P2/$kernel.loops.mlir" --convert-scf-to-cf -o "$P2/$kernel.cf.mlir"
  "$OPT" "$P2/$kernel.cf.mlir" --convert-arith-to-llvm \
    --finalize-memref-to-llvm --convert-func-to-llvm --convert-cf-to-llvm \
    --reconcile-unrealized-casts -o "$P2/$kernel.llvm.mlir"
  "$TRANSLATE" --mlir-to-llvmir "$P2/$kernel.llvm.mlir" > "$P2/$kernel.ll"
  "$CC" -O0 -ffp-contract=off -c "$P2/$kernel.ll" -o "$P2/$kernel.o"
  defines=()
  [[ "$kernel" == jacobi ]] && defines=(-DJACOBI)
  "$CXX" -std=c++17 -O0 -ffp-contract=off -Wall -Wextra -Werror "${defines[@]}" \
    "$ROOT/part2/driver.cpp" "$P2/$kernel.o" -lm -o "$P2/test_$kernel"
  "$P2/test_$kernel" | tee "$P2/$kernel.correctness.txt"
done
"$CXX" -std=c++17 -O0 -ffp-contract=off "$ROOT/part2/rounding.cpp" -o "$P2/rounding"
"$P2/rounding" | tee "$P2/rounding.txt"
