#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel_jacobi_2d(%arg0: index, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg0 step %c1 {
      %c2 = arith.constant 2 : index
      %c0_0 = arith.constant 0 : index
      %dim = memref.dim %arg1, %c0_0 : memref<?x?xf64>
      %0 = arith.cmpi sge, %dim, %c2 : index
      cf.assert %0, "stencil dimension must be at least two"
      %c1_1 = arith.constant 1 : index
      %dim_2 = memref.dim %arg1, %c1_1 : memref<?x?xf64>
      %1 = arith.cmpi sge, %dim_2, %c2 : index
      cf.assert %1, "stencil dimension must be at least two"
      %c0_3 = arith.constant 0 : index
      %dim_4 = memref.dim %arg2, %c0_3 : memref<?x?xf64>
      %2 = arith.cmpi eq, %dim, %dim_4 : index
      cf.assert %2, "stencil.apply shape mismatch"
      %c1_5 = arith.constant 1 : index
      %dim_6 = memref.dim %arg2, %c1_5 : memref<?x?xf64>
      %3 = arith.cmpi eq, %dim_2, %dim_6 : index
      cf.assert %3, "stencil.apply shape mismatch"
      %c2_7 = arith.constant 2 : index
      %4 = arith.subi %dim, %c2_7 : index
      %5 = arith.subi %dim_2, %c2_7 : index
      %subview = memref.subview %arg1[1, 1] [%4, %5] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_8 = memref.subview %arg1[1, 0] [%4, %5] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_9 = memref.subview %arg1[1, 2] [%4, %5] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_10 = memref.subview %arg1[2, 1] [%4, %5] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_11 = memref.subview %arg1[0, 1] [%4, %5] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
      %subview_12 = memref.subview %arg2[1, 1] [%4, %5] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %cst = arith.constant 2.000000e-01 : f64
      linalg.generic {indexing_maps = [#map, #map, #map, #map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%subview, %subview_8, %subview_9, %subview_10, %subview_11 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%subview_12 : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
      ^bb0(%in: f64, %in_30: f64, %in_31: f64, %in_32: f64, %in_33: f64, %out: f64):
        %12 = arith.addf %in, %in_30 : f64
        %13 = arith.addf %12, %in_31 : f64
        %14 = arith.addf %13, %in_32 : f64
        %15 = arith.addf %14, %in_33 : f64
        %16 = arith.mulf %15, %cst : f64
        linalg.yield %16 : f64
      }
      %c2_13 = arith.constant 2 : index
      %c0_14 = arith.constant 0 : index
      %dim_15 = memref.dim %arg2, %c0_14 : memref<?x?xf64>
      %6 = arith.cmpi sge, %dim_15, %c2_13 : index
      cf.assert %6, "stencil dimension must be at least two"
      %c1_16 = arith.constant 1 : index
      %dim_17 = memref.dim %arg2, %c1_16 : memref<?x?xf64>
      %7 = arith.cmpi sge, %dim_17, %c2_13 : index
      cf.assert %7, "stencil dimension must be at least two"
      %c0_18 = arith.constant 0 : index
      %dim_19 = memref.dim %arg1, %c0_18 : memref<?x?xf64>
      %8 = arith.cmpi eq, %dim_15, %dim_19 : index
      cf.assert %8, "stencil.apply shape mismatch"
      %c1_20 = arith.constant 1 : index
      %dim_21 = memref.dim %arg1, %c1_20 : memref<?x?xf64>
      %9 = arith.cmpi eq, %dim_17, %dim_21 : index
      cf.assert %9, "stencil.apply shape mismatch"
      %c2_22 = arith.constant 2 : index
      %10 = arith.subi %dim_15, %c2_22 : index
      %11 = arith.subi %dim_17, %c2_22 : index
      %subview_23 = memref.subview %arg2[1, 1] [%10, %11] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_24 = memref.subview %arg2[1, 0] [%10, %11] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_25 = memref.subview %arg2[1, 2] [%10, %11] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_26 = memref.subview %arg2[2, 1] [%10, %11] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %subview_27 = memref.subview %arg2[0, 1] [%10, %11] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
      %subview_28 = memref.subview %arg1[1, 1] [%10, %11] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %cst_29 = arith.constant 2.000000e-01 : f64
      linalg.generic {indexing_maps = [#map, #map, #map, #map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%subview_23, %subview_24, %subview_25, %subview_26, %subview_27 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%subview_28 : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
      ^bb0(%in: f64, %in_30: f64, %in_31: f64, %in_32: f64, %in_33: f64, %out: f64):
        %12 = arith.addf %in, %in_30 : f64
        %13 = arith.addf %12, %in_31 : f64
        %14 = arith.addf %13, %in_32 : f64
        %15 = arith.addf %14, %in_33 : f64
        %16 = arith.mulf %15, %cst_29 : f64
        linalg.yield %16 : f64
      }
    }
    return
  }
}

