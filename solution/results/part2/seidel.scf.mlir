module {
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      %c2 = arith.constant 2 : index
      %c0_0 = arith.constant 0 : index
      %dim = memref.dim %arg1, %c0_0 : memref<?x?xf64>
      %0 = arith.cmpi sge, %dim, %c2 : index
      cf.assert %0, "stencil dimension must be at least two"
      %c1_1 = arith.constant 1 : index
      %dim_2 = memref.dim %arg1, %c1_1 : memref<?x?xf64>
      %1 = arith.cmpi sge, %dim_2, %c2 : index
      cf.assert %1, "stencil dimension must be at least two"
      %c1_3 = arith.constant 1 : index
      %2 = arith.subi %dim, %c1_3 : index
      %3 = arith.subi %dim_2, %c1_3 : index
      %cst = arith.constant 9.000000e+00 : f64
      scf.for %arg3 = %c1_3 to %2 step %c1_3 {
        scf.for %arg4 = %c1_3 to %3 step %c1_3 {
          %c-1 = arith.constant -1 : index
          %c-1_4 = arith.constant -1 : index
          %4 = arith.addi %arg3, %c-1 : index
          %5 = arith.addi %arg4, %c-1_4 : index
          %6 = memref.load %arg1[%4, %5] : memref<?x?xf64>
          %c-1_5 = arith.constant -1 : index
          %c0_6 = arith.constant 0 : index
          %7 = arith.addi %arg3, %c-1_5 : index
          %8 = arith.addi %arg4, %c0_6 : index
          %9 = memref.load %arg1[%7, %8] : memref<?x?xf64>
          %10 = arith.addf %6, %9 : f64
          %c-1_7 = arith.constant -1 : index
          %c1_8 = arith.constant 1 : index
          %11 = arith.addi %arg3, %c-1_7 : index
          %12 = arith.addi %arg4, %c1_8 : index
          %13 = memref.load %arg1[%11, %12] : memref<?x?xf64>
          %14 = arith.addf %10, %13 : f64
          %c0_9 = arith.constant 0 : index
          %c-1_10 = arith.constant -1 : index
          %15 = arith.addi %arg3, %c0_9 : index
          %16 = arith.addi %arg4, %c-1_10 : index
          %17 = memref.load %arg1[%15, %16] : memref<?x?xf64>
          %18 = arith.addf %14, %17 : f64
          %c0_11 = arith.constant 0 : index
          %c0_12 = arith.constant 0 : index
          %19 = arith.addi %arg3, %c0_11 : index
          %20 = arith.addi %arg4, %c0_12 : index
          %21 = memref.load %arg1[%19, %20] : memref<?x?xf64>
          %22 = arith.addf %18, %21 : f64
          %c0_13 = arith.constant 0 : index
          %c1_14 = arith.constant 1 : index
          %23 = arith.addi %arg3, %c0_13 : index
          %24 = arith.addi %arg4, %c1_14 : index
          %25 = memref.load %arg1[%23, %24] : memref<?x?xf64>
          %26 = arith.addf %22, %25 : f64
          %c1_15 = arith.constant 1 : index
          %c-1_16 = arith.constant -1 : index
          %27 = arith.addi %arg3, %c1_15 : index
          %28 = arith.addi %arg4, %c-1_16 : index
          %29 = memref.load %arg1[%27, %28] : memref<?x?xf64>
          %30 = arith.addf %26, %29 : f64
          %c1_17 = arith.constant 1 : index
          %c0_18 = arith.constant 0 : index
          %31 = arith.addi %arg3, %c1_17 : index
          %32 = arith.addi %arg4, %c0_18 : index
          %33 = memref.load %arg1[%31, %32] : memref<?x?xf64>
          %34 = arith.addf %30, %33 : f64
          %c1_19 = arith.constant 1 : index
          %c1_20 = arith.constant 1 : index
          %35 = arith.addi %arg3, %c1_19 : index
          %36 = arith.addi %arg4, %c1_20 : index
          %37 = memref.load %arg1[%35, %36] : memref<?x?xf64>
          %38 = arith.addf %34, %37 : f64
          %39 = arith.divf %38, %cst : f64
          memref.store %39, %arg1[%arg3, %arg4] : memref<?x?xf64>
        }
      }
    }
    return
  }
}

