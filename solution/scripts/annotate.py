#!/usr/bin/env python3
"""Annotate this task's simple unoptimized loop nests; preserve raw dumps separately."""
import re,sys
from pathlib import Path
src,dst,order=sys.argv[1:]
text=Path(src).read_text()
lines=[]; depth=0
for line in text.splitlines():
    note=None
    if re.search(r"(?:scf|affine)\.for\s",line):
        if depth>=3: raise SystemExit("Unexpected loop structure: inspect raw IR")
        note=f"{order[depth]} loop ({['outermost','middle','innermost'][depth]})"
        depth+=1
    m=re.search(r"(?:memref|affine)\.load\s+(%[A-Za-z0-9_]+)\[",line)
    if m:
        matrix={'%arg0':'A','%arg1':'B','%arg2':'C','%A':'A','%B':'B','%C':'C'}.get(m[1])
        if matrix: note=f"Load {matrix}: "+{'A':'A[i,k]','B':'B[k,j]','C':'current accumulator C[i,j]'}[matrix]
    if re.search(r"(?:memref|affine)\.store\s",line):
        note="Store updated accumulator to C[i,j]"
    if note: lines.append(' '*(len(line)-len(line.lstrip()))+'// '+note)
    lines.append(line)
if depth!=3: raise SystemExit(f"Expected 3 loops, saw {depth}; inspect raw IR")
Path(dst).write_text('\n'.join(lines)+'\n')
