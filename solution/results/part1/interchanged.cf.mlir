module {
  func.func @matmul_interchanged(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %dim = memref.dim %arg0, %c0 : memref<?x?xf64>
    %dim_0 = memref.dim %arg0, %c1 : memref<?x?xf64>
    %dim_1 = memref.dim %arg1, %c1 : memref<?x?xf64>
    cf.br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb8
    %1 = arith.cmpi slt, %0, %dim : index
    cf.cond_br %1, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    cf.br ^bb3(%c0 : index)
  ^bb3(%2: index):  // 2 preds: ^bb2, ^bb7
    %3 = arith.cmpi slt, %2, %dim_0 : index
    cf.cond_br %3, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    cf.br ^bb5(%c0 : index)
  ^bb5(%4: index):  // 2 preds: ^bb4, ^bb6
    %5 = arith.cmpi slt, %4, %dim_1 : index
    cf.cond_br %5, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %6 = memref.load %arg0[%0, %2] : memref<?x?xf64>
    %7 = memref.load %arg1[%2, %4] : memref<?x?xf64>
    %8 = memref.load %arg2[%0, %4] : memref<?x?xf64>
    %9 = arith.mulf %6, %7 : f64
    %10 = arith.addf %8, %9 : f64
    memref.store %10, %arg2[%0, %4] : memref<?x?xf64>
    %11 = arith.addi %4, %c1 : index
    cf.br ^bb5(%11 : index)
  ^bb7:  // pred: ^bb5
    %12 = arith.addi %2, %c1 : index
    cf.br ^bb3(%12 : index)
  ^bb8:  // pred: ^bb3
    %13 = arith.addi %0, %c1 : index
    cf.br ^bb1(%13 : index)
  ^bb9:  // pred: ^bb1
    return
  }
}

