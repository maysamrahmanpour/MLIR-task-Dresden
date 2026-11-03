func.func @kernel_jacobi_2d(%tsteps: index, %A: memref<?x?xf64>,
                            %B: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  scf.for %t = %c0 to %tsteps step %c1 {
    stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
      offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)
    stencil.apply ins(%B : memref<?x?xf64>) outs(%A : memref<?x?xf64>)
      offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)
  }
  return
}
