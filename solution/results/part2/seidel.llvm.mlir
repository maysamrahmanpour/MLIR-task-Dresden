module {
  llvm.mlir.global private constant @assert_msg_0(dense<[115, 116, 101, 110, 99, 105, 108, 32, 100, 105, 109, 101, 110, 115, 105, 111, 110, 32, 109, 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 108, 101, 97, 115, 116, 32, 116, 119, 111, 0]> : tensor<39xi8>) {addr_space = 0 : i32} : !llvm.array<39 x i8>
  llvm.func @abort()
  llvm.func @puts(!llvm.ptr)
  llvm.mlir.global private constant @assert_msg(dense<[115, 116, 101, 110, 99, 105, 108, 32, 100, 105, 109, 101, 110, 115, 105, 111, 110, 32, 109, 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 108, 101, 97, 115, 116, 32, 116, 119, 111, 0]> : tensor<39xi8>) {addr_space = 0 : i32} : !llvm.array<39 x i8>
  llvm.func @kernel_seidel_2d(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64) attributes {llvm.emit_c_interface} {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg1, %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg2, %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg3, %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg4, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg6, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg5, %5[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg7, %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.constant(-1 : index) : i64
    %9 = llvm.mlir.constant(9.000000e+00 : f64) : f64
    %10 = llvm.mlir.constant(2 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%11 : i64)
  ^bb1(%13: i64):  // 2 preds: ^bb0, ^bb10
    %14 = llvm.icmp "slt" %13, %arg0 : i64
    llvm.cond_br %14, ^bb2, ^bb11
  ^bb2:  // pred: ^bb1
    %15 = llvm.mlir.constant(1 : index) : i64
    %16 = llvm.extractvalue %7[3] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.alloca %15 x !llvm.array<2 x i64> : (i64) -> !llvm.ptr
    llvm.store %16, %17 : !llvm.array<2 x i64>, !llvm.ptr
    %18 = llvm.getelementptr %17[0, %11] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.array<2 x i64>
    %19 = llvm.load %18 : !llvm.ptr -> i64
    %20 = llvm.icmp "sge" %19, %10 : i64
    llvm.cond_br %20, ^bb3, ^bb12
  ^bb3:  // pred: ^bb2
    %21 = llvm.mlir.constant(1 : index) : i64
    %22 = llvm.extractvalue %7[3] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.alloca %21 x !llvm.array<2 x i64> : (i64) -> !llvm.ptr
    llvm.store %22, %23 : !llvm.array<2 x i64>, !llvm.ptr
    %24 = llvm.getelementptr %23[0, %12] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.array<2 x i64>
    %25 = llvm.load %24 : !llvm.ptr -> i64
    %26 = llvm.icmp "sge" %25, %10 : i64
    llvm.cond_br %26, ^bb4, ^bb13
  ^bb4:  // pred: ^bb3
    %27 = llvm.sub %19, %12 : i64
    %28 = llvm.sub %25, %12 : i64
    llvm.br ^bb5(%12 : i64)
  ^bb5(%29: i64):  // 2 preds: ^bb4, ^bb9
    %30 = llvm.icmp "slt" %29, %27 : i64
    llvm.cond_br %30, ^bb6, ^bb10
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%12 : i64)
  ^bb7(%31: i64):  // 2 preds: ^bb6, ^bb8
    %32 = llvm.icmp "slt" %31, %28 : i64
    llvm.cond_br %32, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %33 = llvm.add %29, %8 : i64
    %34 = llvm.add %31, %8 : i64
    %35 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.mul %33, %36 overflow<nsw> : i64
    %38 = llvm.add %37, %34 overflow<nsw> : i64
    %39 = llvm.getelementptr inbounds %35[%38] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %40 = llvm.load %39 : !llvm.ptr -> f64
    %41 = llvm.add %29, %8 : i64
    %42 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.mul %41, %43 overflow<nsw> : i64
    %45 = llvm.add %44, %31 overflow<nsw> : i64
    %46 = llvm.getelementptr inbounds %42[%45] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %47 = llvm.load %46 : !llvm.ptr -> f64
    %48 = llvm.fadd %40, %47 : f64
    %49 = llvm.add %29, %8 : i64
    %50 = llvm.add %31, %12 : i64
    %51 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.mul %49, %52 overflow<nsw> : i64
    %54 = llvm.add %53, %50 overflow<nsw> : i64
    %55 = llvm.getelementptr inbounds %51[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %56 = llvm.load %55 : !llvm.ptr -> f64
    %57 = llvm.fadd %48, %56 : f64
    %58 = llvm.add %31, %8 : i64
    %59 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %61 = llvm.mul %29, %60 overflow<nsw> : i64
    %62 = llvm.add %61, %58 overflow<nsw> : i64
    %63 = llvm.getelementptr inbounds %59[%62] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %64 = llvm.load %63 : !llvm.ptr -> f64
    %65 = llvm.fadd %57, %64 : f64
    %66 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.mul %29, %67 overflow<nsw> : i64
    %69 = llvm.add %68, %31 overflow<nsw> : i64
    %70 = llvm.getelementptr inbounds %66[%69] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %71 = llvm.load %70 : !llvm.ptr -> f64
    %72 = llvm.fadd %65, %71 : f64
    %73 = llvm.add %31, %12 : i64
    %74 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %76 = llvm.mul %29, %75 overflow<nsw> : i64
    %77 = llvm.add %76, %73 overflow<nsw> : i64
    %78 = llvm.getelementptr inbounds %74[%77] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %79 = llvm.load %78 : !llvm.ptr -> f64
    %80 = llvm.fadd %72, %79 : f64
    %81 = llvm.add %29, %12 : i64
    %82 = llvm.add %31, %8 : i64
    %83 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %84 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %85 = llvm.mul %81, %84 overflow<nsw> : i64
    %86 = llvm.add %85, %82 overflow<nsw> : i64
    %87 = llvm.getelementptr inbounds %83[%86] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %88 = llvm.load %87 : !llvm.ptr -> f64
    %89 = llvm.fadd %80, %88 : f64
    %90 = llvm.add %29, %12 : i64
    %91 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %93 = llvm.mul %90, %92 overflow<nsw> : i64
    %94 = llvm.add %93, %31 overflow<nsw> : i64
    %95 = llvm.getelementptr inbounds %91[%94] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %96 = llvm.load %95 : !llvm.ptr -> f64
    %97 = llvm.fadd %89, %96 : f64
    %98 = llvm.add %29, %12 : i64
    %99 = llvm.add %31, %12 : i64
    %100 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %101 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %102 = llvm.mul %98, %101 overflow<nsw> : i64
    %103 = llvm.add %102, %99 overflow<nsw> : i64
    %104 = llvm.getelementptr inbounds %100[%103] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %105 = llvm.load %104 : !llvm.ptr -> f64
    %106 = llvm.fadd %97, %105 : f64
    %107 = llvm.fdiv %106, %9 : f64
    %108 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %109 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %110 = llvm.mul %29, %109 overflow<nsw> : i64
    %111 = llvm.add %110, %31 overflow<nsw> : i64
    %112 = llvm.getelementptr inbounds %108[%111] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %107, %112 : f64, !llvm.ptr
    %113 = llvm.add %31, %12 : i64
    llvm.br ^bb7(%113 : i64)
  ^bb9:  // pred: ^bb7
    %114 = llvm.add %29, %12 : i64
    llvm.br ^bb5(%114 : i64)
  ^bb10:  // pred: ^bb5
    %115 = llvm.add %13, %12 : i64
    llvm.br ^bb1(%115 : i64)
  ^bb11:  // pred: ^bb1
    llvm.return
  ^bb12:  // pred: ^bb2
    %116 = llvm.mlir.addressof @assert_msg : !llvm.ptr
    %117 = llvm.getelementptr %116[0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<39 x i8>
    llvm.call @puts(%117) : (!llvm.ptr) -> ()
    llvm.call @abort() : () -> ()
    llvm.unreachable
  ^bb13:  // pred: ^bb3
    %118 = llvm.mlir.addressof @assert_msg_0 : !llvm.ptr
    %119 = llvm.getelementptr %118[0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<39 x i8>
    llvm.call @puts(%119) : (!llvm.ptr) -> ()
    llvm.call @abort() : () -> ()
    llvm.unreachable
  }
  llvm.func @_mlir_ciface_kernel_seidel_2d(%arg0: i64, %arg1: !llvm.ptr) attributes {llvm.emit_c_interface} {
    %0 = llvm.load %arg1 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.extractvalue %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.extractvalue %0[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.extractvalue %0[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.extractvalue %0[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.extractvalue %0[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.extractvalue %0[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.extractvalue %0[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @kernel_seidel_2d(%arg0, %1, %2, %3, %4, %5, %6, %7) : (i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) -> ()
    llvm.return
  }
}

