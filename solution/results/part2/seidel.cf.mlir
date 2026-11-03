module {
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 9.000000e+00 : f64
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    cf.br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb8
    %1 = arith.cmpi slt, %0, %arg0 : index
    cf.cond_br %1, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    %dim = memref.dim %arg1, %c0 : memref<?x?xf64>
    %2 = arith.cmpi sge, %dim, %c2 : index
    cf.assert %2, "stencil dimension must be at least two"
    %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf64>
    %3 = arith.cmpi sge, %dim_0, %c2 : index
    cf.assert %3, "stencil dimension must be at least two"
    %4 = arith.subi %dim, %c1 : index
    %5 = arith.subi %dim_0, %c1 : index
    cf.br ^bb3(%c1 : index)
  ^bb3(%6: index):  // 2 preds: ^bb2, ^bb7
    %7 = arith.cmpi slt, %6, %4 : index
    cf.cond_br %7, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    cf.br ^bb5(%c1 : index)
  ^bb5(%8: index):  // 2 preds: ^bb4, ^bb6
    %9 = arith.cmpi slt, %8, %5 : index
    cf.cond_br %9, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %10 = arith.addi %6, %c-1 : index
    %11 = arith.addi %8, %c-1 : index
    %12 = memref.load %arg1[%10, %11] : memref<?x?xf64>
    %13 = arith.addi %6, %c-1 : index
    %14 = memref.load %arg1[%13, %8] : memref<?x?xf64>
    %15 = arith.addf %12, %14 : f64
    %16 = arith.addi %6, %c-1 : index
    %17 = arith.addi %8, %c1 : index
    %18 = memref.load %arg1[%16, %17] : memref<?x?xf64>
    %19 = arith.addf %15, %18 : f64
    %20 = arith.addi %8, %c-1 : index
    %21 = memref.load %arg1[%6, %20] : memref<?x?xf64>
    %22 = arith.addf %19, %21 : f64
    %23 = memref.load %arg1[%6, %8] : memref<?x?xf64>
    %24 = arith.addf %22, %23 : f64
    %25 = arith.addi %8, %c1 : index
    %26 = memref.load %arg1[%6, %25] : memref<?x?xf64>
    %27 = arith.addf %24, %26 : f64
    %28 = arith.addi %6, %c1 : index
    %29 = arith.addi %8, %c-1 : index
    %30 = memref.load %arg1[%28, %29] : memref<?x?xf64>
    %31 = arith.addf %27, %30 : f64
    %32 = arith.addi %6, %c1 : index
    %33 = memref.load %arg1[%32, %8] : memref<?x?xf64>
    %34 = arith.addf %31, %33 : f64
    %35 = arith.addi %6, %c1 : index
    %36 = arith.addi %8, %c1 : index
    %37 = memref.load %arg1[%35, %36] : memref<?x?xf64>
    %38 = arith.addf %34, %37 : f64
    %39 = arith.divf %38, %cst : f64
    memref.store %39, %arg1[%6, %8] : memref<?x?xf64>
    %40 = arith.addi %8, %c1 : index
    cf.br ^bb5(%40 : index)
  ^bb7:  // pred: ^bb5
    %41 = arith.addi %6, %c1 : index
    cf.br ^bb3(%41 : index)
  ^bb8:  // pred: ^bb3
    %42 = arith.addi %0, %c1 : index
    cf.br ^bb1(%42 : index)
  ^bb9:  // pred: ^bb1
    return
  }
}

