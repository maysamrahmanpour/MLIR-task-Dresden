#!/usr/bin/env python3
# Structural smoke checks complement (not replace) execution/reference tests.
from pathlib import Path
import re,sys
mode,path=sys.argv[1:]
s=Path(path).read_text()
def count(op): return len(re.findall(r'(?<![\w.])'+re.escape(op)+r'\b',s))
# Use literal operation matches, excluding names appearing in assert strings.
if mode=='apply':
    assert 'stencil.apply ins' not in s
    assert s.count('memref.subview')==12, 'expected 6 subviews in each of two passes'
    assert s.count('linalg.generic')==2
    assert s.count('"parallel", "parallel"')==2
    assert s.count('arith.addf')==8
    assert s.count('arith.mulf')==2
else:
    assert 'stencil.sweep %' not in s
    assert s.count('scf.for')==3, 'time loop plus row and column loops'
    assert s.count('memref.load')==9
    assert s.count('arith.addf')==8
    assert s.count('arith.divf')==1
    assert s.count('memref.store')==1
print('PASS: structural',mode,'checks')
