module {
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      stencil.sweep %arg1 offsets [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]] divisor(9.000000e+00) : memref<?x?xf64>
    }
    return
  }
}

