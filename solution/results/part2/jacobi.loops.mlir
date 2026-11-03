module {
  func.func @kernel_jacobi_2d(%arg0: index, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %cst = arith.constant 2.000000e-01 : f64
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg0 step %c1 {
      %dim = memref.dim %arg1, %c0 : memref<?x?xf64>
      %0 = arith.cmpi sge, %dim, %c2 : index
      cf.assert %0, "stencil dimension must be at least two"
      %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf64>
      %1 = arith.cmpi sge, %dim_0, %c2 : index
      cf.assert %1, "stencil dimension must be at least two"
      %dim_1 = memref.dim %arg2, %c0 : memref<?x?xf64>
      %2 = arith.cmpi eq, %dim, %dim_1 : index
      cf.assert %2, "stencil.apply shape mismatch"
      %dim_2 = memref.dim %arg2, %c1 : memref<?x?xf64>
      %3 = arith.cmpi eq, %dim_0, %dim_2 : index
      cf.assert %3, "stencil.apply shape mismatch"
      %4 = arith.subi %dim, %c2 : index
      %5 = arith.subi %dim_0, %c2 : index
      %base_buffer, %offset, %sizes:2, %strides:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c1_3 = arith.constant 1 : index
      %6 = arith.addi %strides#0, %c1_3 : index
      %reinterpret_cast = memref.reinterpret_cast %base_buffer to offset: [%6], sizes: [%4, %5], strides: [%strides#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_4, %offset_5, %sizes_6:2, %strides_7:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %reinterpret_cast_8 = memref.reinterpret_cast %base_buffer_4 to offset: [%strides_7#0], sizes: [%4, %5], strides: [%strides_7#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_9, %offset_10, %sizes_11:2, %strides_12:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c2_13 = arith.constant 2 : index
      %7 = arith.addi %strides_12#0, %c2_13 : index
      %reinterpret_cast_14 = memref.reinterpret_cast %base_buffer_9 to offset: [%7], sizes: [%4, %5], strides: [%strides_12#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_15, %offset_16, %sizes_17:2, %strides_18:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c2_19 = arith.constant 2 : index
      %8 = arith.muli %strides_18#0, %c2_19 overflow<nsw> : index
      %c1_20 = arith.constant 1 : index
      %9 = arith.addi %8, %c1_20 : index
      %reinterpret_cast_21 = memref.reinterpret_cast %base_buffer_15 to offset: [%9], sizes: [%4, %5], strides: [%strides_18#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_22, %offset_23, %sizes_24:2, %strides_25:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %reinterpret_cast_26 = memref.reinterpret_cast %base_buffer_22 to offset: [1], sizes: [%4, %5], strides: [%strides_25#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
      %base_buffer_27, %offset_28, %sizes_29:2, %strides_30:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c1_31 = arith.constant 1 : index
      %10 = arith.addi %strides_30#0, %c1_31 : index
      %reinterpret_cast_32 = memref.reinterpret_cast %base_buffer_27 to offset: [%10], sizes: [%4, %5], strides: [%strides_30#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      scf.for %arg4 = %c0 to %4 step %c1 {
        scf.for %arg5 = %c0 to %5 step %c1 {
          %22 = memref.load %reinterpret_cast[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %23 = memref.load %reinterpret_cast_8[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %24 = memref.load %reinterpret_cast_14[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %25 = memref.load %reinterpret_cast_21[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %26 = memref.load %reinterpret_cast_26[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: 1>>
          %27 = arith.addf %22, %23 : f64
          %28 = arith.addf %27, %24 : f64
          %29 = arith.addf %28, %25 : f64
          %30 = arith.addf %29, %26 : f64
          %31 = arith.mulf %30, %cst : f64
          memref.store %31, %reinterpret_cast_32[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
        }
      }
      %dim_33 = memref.dim %arg2, %c0 : memref<?x?xf64>
      %11 = arith.cmpi sge, %dim_33, %c2 : index
      cf.assert %11, "stencil dimension must be at least two"
      %dim_34 = memref.dim %arg2, %c1 : memref<?x?xf64>
      %12 = arith.cmpi sge, %dim_34, %c2 : index
      cf.assert %12, "stencil dimension must be at least two"
      %dim_35 = memref.dim %arg1, %c0 : memref<?x?xf64>
      %13 = arith.cmpi eq, %dim_33, %dim_35 : index
      cf.assert %13, "stencil.apply shape mismatch"
      %dim_36 = memref.dim %arg1, %c1 : memref<?x?xf64>
      %14 = arith.cmpi eq, %dim_34, %dim_36 : index
      cf.assert %14, "stencil.apply shape mismatch"
      %15 = arith.subi %dim_33, %c2 : index
      %16 = arith.subi %dim_34, %c2 : index
      %base_buffer_37, %offset_38, %sizes_39:2, %strides_40:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c1_41 = arith.constant 1 : index
      %17 = arith.addi %strides_40#0, %c1_41 : index
      %reinterpret_cast_42 = memref.reinterpret_cast %base_buffer_37 to offset: [%17], sizes: [%15, %16], strides: [%strides_40#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_43, %offset_44, %sizes_45:2, %strides_46:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %reinterpret_cast_47 = memref.reinterpret_cast %base_buffer_43 to offset: [%strides_46#0], sizes: [%15, %16], strides: [%strides_46#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_48, %offset_49, %sizes_50:2, %strides_51:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c2_52 = arith.constant 2 : index
      %18 = arith.addi %strides_51#0, %c2_52 : index
      %reinterpret_cast_53 = memref.reinterpret_cast %base_buffer_48 to offset: [%18], sizes: [%15, %16], strides: [%strides_51#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_54, %offset_55, %sizes_56:2, %strides_57:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c2_58 = arith.constant 2 : index
      %19 = arith.muli %strides_57#0, %c2_58 overflow<nsw> : index
      %c1_59 = arith.constant 1 : index
      %20 = arith.addi %19, %c1_59 : index
      %reinterpret_cast_60 = memref.reinterpret_cast %base_buffer_54 to offset: [%20], sizes: [%15, %16], strides: [%strides_57#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      %base_buffer_61, %offset_62, %sizes_63:2, %strides_64:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %reinterpret_cast_65 = memref.reinterpret_cast %base_buffer_61 to offset: [1], sizes: [%15, %16], strides: [%strides_64#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
      %base_buffer_66, %offset_67, %sizes_68:2, %strides_69:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
      %c1_70 = arith.constant 1 : index
      %21 = arith.addi %strides_69#0, %c1_70 : index
      %reinterpret_cast_71 = memref.reinterpret_cast %base_buffer_66 to offset: [%21], sizes: [%15, %16], strides: [%strides_69#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
      scf.for %arg4 = %c0 to %15 step %c1 {
        scf.for %arg5 = %c0 to %16 step %c1 {
          %22 = memref.load %reinterpret_cast_42[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %23 = memref.load %reinterpret_cast_47[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %24 = memref.load %reinterpret_cast_53[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %25 = memref.load %reinterpret_cast_60[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
          %26 = memref.load %reinterpret_cast_65[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: 1>>
          %27 = arith.addf %22, %23 : f64
          %28 = arith.addf %27, %24 : f64
          %29 = arith.addf %28, %25 : f64
          %30 = arith.addf %29, %26 : f64
          %31 = arith.mulf %30, %cst : f64
          memref.store %31, %reinterpret_cast_71[%arg4, %arg5] : memref<?x?xf64, strided<[?, 1], offset: ?>>
        }
      }
    }
    return
  }
}

