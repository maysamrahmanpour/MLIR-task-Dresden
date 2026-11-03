// C += A * B. Shapes must agree; C must not alias A or B.
func.func @matmul_named(%A: memref<?x?xf64>, %B: memref<?x?xf64>,
                        %C: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
  linalg.matmul ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>)
                outs(%C : memref<?x?xf64>)
  return
}
