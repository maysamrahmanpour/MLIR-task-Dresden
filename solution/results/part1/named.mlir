module {
  func.func @matmul_named(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    linalg.matmul ins(%arg0, %arg1 : memref<?x?xf64>, memref<?x?xf64>) outs(%arg2 : memref<?x?xf64>)
    return
  }
}

