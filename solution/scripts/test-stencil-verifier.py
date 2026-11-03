#!/usr/bin/env python3
import subprocess,sys
opt=sys.argv[1]
apply='''func.func @test(%a: memref<?x?xf64>, %b: memref<?x?xf64>) {
  stencil.apply ins(%a : memref<?x?xf64>) outs(%b : memref<?x?xf64>)
    offsets [[0, 0]] scale(0.2)
  return
}'''
sweep='''func.func @test(%a: memref<?x?xf64>) {
  stencil.sweep %a offsets [[0, 0]] divisor(9.0) : memref<?x?xf64>
  return
}'''
cases=[('empty offsets',apply.replace('[[0, 0]]','[]'),'requires at least one offset'),
       ('offset rank',apply.replace('[[0, 0]]','[[0]]'),'requires two integer components'),
       ('offset range',apply.replace('[[0, 0]]','[[2, 0]]'),'supports only radius-one offsets'),
       ('zero divisor',sweep.replace('9.0','0.0'),'requires a finite nonzero divisor'),
       ('wrong element type',sweep.replace('xf64','xf32'),'requires rank-two f64 memrefs'),
       ('small static grid',sweep.replace('?x?','1x4'),'requires dimensions of at least two'),
       ('same SSA alias',apply.replace('outs(%b','outs(%a'),'requires non-overlapping')]
for source in [apply,sweep]:
    p=subprocess.run([opt,'-o','/dev/null'],input=source,text=True,capture_output=True)
    if p.returncode: raise SystemExit('Valid operation failed:\n'+p.stderr)
for name,source,expected in cases:
    p=subprocess.run([opt,'-o','/dev/null'],input=source,text=True,capture_output=True)
    if p.returncode==0 or expected not in p.stderr:
        raise SystemExit(f'{name}: expected verifier diagnostic {expected!r}; got:\n{p.stderr}')
    print('PASS:',name)
