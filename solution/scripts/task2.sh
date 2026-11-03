#!/usr/bin/env bash
source "$(dirname "$0")/env.sh"
"$OPT" --version > "$OUT/toolchain.txt"
"$OPT" "$ROOT/part1/named.mlir" -o "$OUT/named.mlir"
"$OPT" "$ROOT/part1/generic.mlir" -o "$OUT/generic.mlir"
"$OPT" "$ROOT/part1/named.mlir" --linalg-generalize-named-ops \
  -o "$OUT/named-generalized.mlir"
# Q3: record what the actual pinned verifier does, without assuming success.
python3 - "$ROOT/part1/generic.mlir" "$OUT/incorrect-parallel.mlir" <<'PYCODE'
import pathlib,sys
s=pathlib.Path(sys.argv[1]).read_text()
pathlib.Path(sys.argv[2]).write_text(s.replace('"reduction"', '"parallel"'))
PYCODE
if "$OPT" "$OUT/incorrect-parallel.mlir" -o /dev/null \
    > "$OUT/q3-verifier.log" 2>&1; then
  echo 'Verifier accepted the annotation; its semantics are still incorrect.' > "$OUT/q3-result.txt"
else
  echo 'Verifier rejected the annotation; see q3-verifier.log for the actual diagnostic.' > "$OUT/q3-result.txt"
fi
cat "$OUT/q3-result.txt"
