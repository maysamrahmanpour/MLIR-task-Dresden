module {
  func.func @kernel_jacobi_2d(%arg0: index, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) attributes {llvm.emit_c_interface} {
    %cst = arith.constant 2.000000e-01 : f64
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    cf.br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb14
    %1 = arith.cmpi slt, %0, %arg0 : index
    cf.cond_br %1, ^bb2, ^bb15
  ^bb2:  // pred: ^bb1
    %dim = memref.dim %arg1, %c0 : memref<?x?xf64>
    %2 = arith.cmpi sge, %dim, %c2 : index
    cf.assert %2, "stencil dimension must be at least two"
    %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf64>
    %3 = arith.cmpi sge, %dim_0, %c2 : index
    cf.assert %3, "stencil dimension must be at least two"
    %dim_1 = memref.dim %arg2, %c0 : memref<?x?xf64>
    %4 = arith.cmpi eq, %dim, %dim_1 : index
    cf.assert %4, "stencil.apply shape mismatch"
    %dim_2 = memref.dim %arg2, %c1 : memref<?x?xf64>
    %5 = arith.cmpi eq, %dim_0, %dim_2 : index
    cf.assert %5, "stencil.apply shape mismatch"
    %6 = arith.subi %dim, %c2 : index
    %7 = arith.subi %dim_0, %c2 : index
    %base_buffer, %offset, %sizes:2, %strides:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c1_3 = arith.constant 1 : index
    %8 = arith.addi %strides#0, %c1_3 : index
    %reinterpret_cast = memref.reinterpret_cast %base_buffer to offset: [%8], sizes: [%6, %7], strides: [%strides#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_4, %offset_5, %sizes_6:2, %strides_7:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %reinterpret_cast_8 = memref.reinterpret_cast %base_buffer_4 to offset: [%strides_7#0], sizes: [%6, %7], strides: [%strides_7#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_9, %offset_10, %sizes_11:2, %strides_12:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c2_13 = arith.constant 2 : index
    %9 = arith.addi %strides_12#0, %c2_13 : index
    %reinterpret_cast_14 = memref.reinterpret_cast %base_buffer_9 to offset: [%9], sizes: [%6, %7], strides: [%strides_12#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_15, %offset_16, %sizes_17:2, %strides_18:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c2_19 = arith.constant 2 : index
    %10 = arith.muli %strides_18#0, %c2_19 overflow<nsw> : index
    %c1_20 = arith.constant 1 : index
    %11 = arith.addi %10, %c1_20 : index
    %reinterpret_cast_21 = memref.reinterpret_cast %base_buffer_15 to offset: [%11], sizes: [%6, %7], strides: [%strides_18#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_22, %offset_23, %sizes_24:2, %strides_25:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %reinterpret_cast_26 = memref.reinterpret_cast %base_buffer_22 to offset: [1], sizes: [%6, %7], strides: [%strides_25#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
    %base_buffer_27, %offset_28, %sizes_29:2, %strides_30:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c1_31 = arith.constant 1 : index
    %12 = arith.addi %strides_30#0, %c1_31 : index
    %reinterpret_cast_32 = memref.reinterpret_cast %base_buffer_27 to offset: [%12], sizes: [%6, %7], strides: [%strides_30#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    cf.br ^bb3(%c0 : index)
  ^bb3(%13: index):  // 2 preds: ^bb2, ^bb7
    %14 = arith.cmpi slt, %13, %6 : index
    cf.cond_br %14, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    cf.br ^bb5(%c0 : index)
  ^bb5(%15: index):  // 2 preds: ^bb4, ^bb6
    %16 = arith.cmpi slt, %15, %7 : index
    cf.cond_br %16, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %17 = memref.load %reinterpret_cast[%13, %15] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %18 = memref.load %reinterpret_cast_8[%13, %15] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %19 = memref.load %reinterpret_cast_14[%13, %15] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %20 = memref.load %reinterpret_cast_21[%13, %15] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %21 = memref.load %reinterpret_cast_26[%13, %15] : memref<?x?xf64, strided<[?, 1], offset: 1>>
    %22 = arith.addf %17, %18 : f64
    %23 = arith.addf %22, %19 : f64
    %24 = arith.addf %23, %20 : f64
    %25 = arith.addf %24, %21 : f64
    %26 = arith.mulf %25, %cst : f64
    memref.store %26, %reinterpret_cast_32[%13, %15] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %27 = arith.addi %15, %c1 : index
    cf.br ^bb5(%27 : index)
  ^bb7:  // pred: ^bb5
    %28 = arith.addi %13, %c1 : index
    cf.br ^bb3(%28 : index)
  ^bb8:  // pred: ^bb3
    %dim_33 = memref.dim %arg2, %c0 : memref<?x?xf64>
    %29 = arith.cmpi sge, %dim_33, %c2 : index
    cf.assert %29, "stencil dimension must be at least two"
    %dim_34 = memref.dim %arg2, %c1 : memref<?x?xf64>
    %30 = arith.cmpi sge, %dim_34, %c2 : index
    cf.assert %30, "stencil dimension must be at least two"
    %dim_35 = memref.dim %arg1, %c0 : memref<?x?xf64>
    %31 = arith.cmpi eq, %dim_33, %dim_35 : index
    cf.assert %31, "stencil.apply shape mismatch"
    %dim_36 = memref.dim %arg1, %c1 : memref<?x?xf64>
    %32 = arith.cmpi eq, %dim_34, %dim_36 : index
    cf.assert %32, "stencil.apply shape mismatch"
    %33 = arith.subi %dim_33, %c2 : index
    %34 = arith.subi %dim_34, %c2 : index
    %base_buffer_37, %offset_38, %sizes_39:2, %strides_40:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c1_41 = arith.constant 1 : index
    %35 = arith.addi %strides_40#0, %c1_41 : index
    %reinterpret_cast_42 = memref.reinterpret_cast %base_buffer_37 to offset: [%35], sizes: [%33, %34], strides: [%strides_40#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_43, %offset_44, %sizes_45:2, %strides_46:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %reinterpret_cast_47 = memref.reinterpret_cast %base_buffer_43 to offset: [%strides_46#0], sizes: [%33, %34], strides: [%strides_46#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_48, %offset_49, %sizes_50:2, %strides_51:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c2_52 = arith.constant 2 : index
    %36 = arith.addi %strides_51#0, %c2_52 : index
    %reinterpret_cast_53 = memref.reinterpret_cast %base_buffer_48 to offset: [%36], sizes: [%33, %34], strides: [%strides_51#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_54, %offset_55, %sizes_56:2, %strides_57:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c2_58 = arith.constant 2 : index
    %37 = arith.muli %strides_57#0, %c2_58 overflow<nsw> : index
    %c1_59 = arith.constant 1 : index
    %38 = arith.addi %37, %c1_59 : index
    %reinterpret_cast_60 = memref.reinterpret_cast %base_buffer_54 to offset: [%38], sizes: [%33, %34], strides: [%strides_57#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    %base_buffer_61, %offset_62, %sizes_63:2, %strides_64:2 = memref.extract_strided_metadata %arg2 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %reinterpret_cast_65 = memref.reinterpret_cast %base_buffer_61 to offset: [1], sizes: [%33, %34], strides: [%strides_64#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
    %base_buffer_66, %offset_67, %sizes_68:2, %strides_69:2 = memref.extract_strided_metadata %arg1 : memref<?x?xf64> -> memref<f64>, index, index, index, index, index
    %c1_70 = arith.constant 1 : index
    %39 = arith.addi %strides_69#0, %c1_70 : index
    %reinterpret_cast_71 = memref.reinterpret_cast %base_buffer_66 to offset: [%39], sizes: [%33, %34], strides: [%strides_69#0, 1] : memref<f64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
    cf.br ^bb9(%c0 : index)
  ^bb9(%40: index):  // 2 preds: ^bb8, ^bb13
    %41 = arith.cmpi slt, %40, %33 : index
    cf.cond_br %41, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    cf.br ^bb11(%c0 : index)
  ^bb11(%42: index):  // 2 preds: ^bb10, ^bb12
    %43 = arith.cmpi slt, %42, %34 : index
    cf.cond_br %43, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %44 = memref.load %reinterpret_cast_42[%40, %42] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %45 = memref.load %reinterpret_cast_47[%40, %42] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %46 = memref.load %reinterpret_cast_53[%40, %42] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %47 = memref.load %reinterpret_cast_60[%40, %42] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %48 = memref.load %reinterpret_cast_65[%40, %42] : memref<?x?xf64, strided<[?, 1], offset: 1>>
    %49 = arith.addf %44, %45 : f64
    %50 = arith.addf %49, %46 : f64
    %51 = arith.addf %50, %47 : f64
    %52 = arith.addf %51, %48 : f64
    %53 = arith.mulf %52, %cst : f64
    memref.store %53, %reinterpret_cast_71[%40, %42] : memref<?x?xf64, strided<[?, 1], offset: ?>>
    %54 = arith.addi %42, %c1 : index
    cf.br ^bb11(%54 : index)
  ^bb13:  // pred: ^bb11
    %55 = arith.addi %40, %c1 : index
    cf.br ^bb9(%55 : index)
  ^bb14:  // pred: ^bb9
    %56 = arith.addi %0, %c1 : index
    cf.br ^bb1(%56 : index)
  ^bb15:  // pred: ^bb1
    return
  }
}

