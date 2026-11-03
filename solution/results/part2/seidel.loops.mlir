module {
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 9.000000e+00 : f64
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      %dim = memref.dim %arg1, %c0 : memref<?x?xf64>
      %0 = arith.cmpi sge, %dim, %c2 : index
      cf.assert %0, "stencil dimension must be at least two"
      %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf64>
      %1 = arith.cmpi sge, %dim_0, %c2 : index
      cf.assert %1, "stencil dimension must be at least two"
      %2 = arith.subi %dim, %c1 : index
      %3 = arith.subi %dim_0, %c1 : index
      scf.for %arg3 = %c1 to %2 step %c1 {
        scf.for %arg4 = %c1 to %3 step %c1 {
          %4 = arith.addi %arg3, %c-1 : index
          %5 = arith.addi %arg4, %c-1 : index
          %6 = memref.load %arg1[%4, %5] : memref<?x?xf64>
          %7 = arith.addi %arg3, %c-1 : index
          %8 = memref.load %arg1[%7, %arg4] : memref<?x?xf64>
          %9 = arith.addf %6, %8 : f64
          %10 = arith.addi %arg3, %c-1 : index
          %11 = arith.addi %arg4, %c1 : index
          %12 = memref.load %arg1[%10, %11] : memref<?x?xf64>
          %13 = arith.addf %9, %12 : f64
          %14 = arith.addi %arg4, %c-1 : index
          %15 = memref.load %arg1[%arg3, %14] : memref<?x?xf64>
          %16 = arith.addf %13, %15 : f64
          %17 = memref.load %arg1[%arg3, %arg4] : memref<?x?xf64>
          %18 = arith.addf %16, %17 : f64
          %19 = arith.addi %arg4, %c1 : index
          %20 = memref.load %arg1[%arg3, %19] : memref<?x?xf64>
          %21 = arith.addf %18, %20 : f64
          %22 = arith.addi %arg3, %c1 : index
          %23 = arith.addi %arg4, %c-1 : index
          %24 = memref.load %arg1[%22, %23] : memref<?x?xf64>
          %25 = arith.addf %21, %24 : f64
          %26 = arith.addi %arg3, %c1 : index
          %27 = memref.load %arg1[%26, %arg4] : memref<?x?xf64>
          %28 = arith.addf %25, %27 : f64
          %29 = arith.addi %arg3, %c1 : index
          %30 = arith.addi %arg4, %c1 : index
          %31 = memref.load %arg1[%29, %30] : memref<?x?xf64>
          %32 = arith.addf %28, %31 : f64
          %33 = arith.divf %32, %cst : f64
          memref.store %33, %arg1[%arg3, %arg4] : memref<?x?xf64>
        }
      }
    }
    return
  }
}

