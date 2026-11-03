// d0=i, d1=j, d2=k. C += A * B, with no implicit initialization.
// Shapes must agree. Output C must not alias either input.
#A = affine_map<(d0, d1, d2) -> (d0, d2)>
#B = affine_map<(d0, d1, d2) -> (d2, d1)>
#C = affine_map<(d0, d1, d2) -> (d0, d1)>
func.func @matmul_generic(%A: memref<?x?xf64>, %B: memref<?x?xf64>,
                          %C: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
  linalg.generic {
    indexing_maps = [#A, #B, #C],
    iterator_types = ["parallel", "parallel", "parallel"]
  } ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>)
    outs(%C : memref<?x?xf64>) {
  ^bb0(%a: f64, %b: f64, %c: f64):
    %product = arith.mulf %a, %b : f64
    %sum = arith.addf %c, %product : f64
    linalg.yield %sum : f64
  }
  return
}
