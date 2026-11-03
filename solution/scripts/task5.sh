#!/usr/bin/env bash
source "$(dirname "$0")/env.sh"
for variant in original interchanged; do
  input="$OUT/$variant.scf.raw.mlir"
  [[ -f "$input" ]] || { echo "Run task3.sh and task4.sh first" >&2; exit 1; }
  "$OPT" "$input" --lower-affine --convert-scf-to-cf -o "$OUT/$variant.cf.mlir"
  "$OPT" "$OUT/$variant.cf.mlir" \
    --convert-arith-to-llvm \
    --finalize-memref-to-llvm \
    --convert-func-to-llvm \
    --convert-cf-to-llvm \
    --reconcile-unrealized-casts -o "$OUT/$variant.llvm.mlir"
  "$TRANSLATE" --mlir-to-llvmir "$OUT/$variant.llvm.mlir" > "$OUT/$variant.ll"
  "$CC" -O0 -ffp-contract=off -c "$OUT/$variant.ll" -o "$OUT/$variant.o"
done
"$CXX" -std=c++17 -O0 -ffp-contract=off -Wall -Wextra -Werror \
  "$ROOT/part1/driver.cpp" "$OUT/original.o" "$OUT/interchanged.o" \
  -lm -o "$OUT/test_matmul"
"$OUT/test_matmul" | tee "$OUT/correctness.txt"
