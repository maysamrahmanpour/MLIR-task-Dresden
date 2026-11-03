; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

@assert_msg_0 = private constant [39 x i8] c"stencil dimension must be at least two\00"
@assert_msg = private constant [39 x i8] c"stencil dimension must be at least two\00"

declare void @abort()

declare void @puts(ptr)

define void @kernel_seidel_2d(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) {
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %1, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, ptr %2, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 %3, 2
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %4, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %6, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %5, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %7, 4, 1
  br label %16

16:                                               ; preds = %125, %8
  %17 = phi i64 [ %126, %125 ], [ 0, %8 ]
  %18 = icmp slt i64 %17, %0
  br i1 %18, label %19, label %127

19:                                               ; preds = %16
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3
  %21 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %20, ptr %21, align 4
  %22 = getelementptr [2 x i64], ptr %21, i32 0, i64 0
  %23 = load i64, ptr %22, align 4
  %24 = icmp sge i64 %23, 2
  br i1 %24, label %25, label %128

25:                                               ; preds = %19
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3
  %27 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %26, ptr %27, align 4
  %28 = getelementptr [2 x i64], ptr %27, i32 0, i64 1
  %29 = load i64, ptr %28, align 4
  %30 = icmp sge i64 %29, 2
  br i1 %30, label %31, label %129

31:                                               ; preds = %25
  %32 = sub i64 %23, 1
  %33 = sub i64 %29, 1
  br label %34

34:                                               ; preds = %123, %31
  %35 = phi i64 [ %124, %123 ], [ 1, %31 ]
  %36 = icmp slt i64 %35, %32
  br i1 %36, label %37, label %125

37:                                               ; preds = %34
  br label %38

38:                                               ; preds = %41, %37
  %39 = phi i64 [ %122, %41 ], [ 1, %37 ]
  %40 = icmp slt i64 %39, %33
  br i1 %40, label %41, label %123

41:                                               ; preds = %38
  %42 = add i64 %35, -1
  %43 = add i64 %39, -1
  %44 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %45 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %46 = mul nsw i64 %42, %45
  %47 = add nsw i64 %46, %43
  %48 = getelementptr inbounds double, ptr %44, i64 %47
  %49 = load double, ptr %48, align 8
  %50 = add i64 %35, -1
  %51 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %52 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %53 = mul nsw i64 %50, %52
  %54 = add nsw i64 %53, %39
  %55 = getelementptr inbounds double, ptr %51, i64 %54
  %56 = load double, ptr %55, align 8
  %57 = fadd double %49, %56
  %58 = add i64 %35, -1
  %59 = add i64 %39, 1
  %60 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %61 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %62 = mul nsw i64 %58, %61
  %63 = add nsw i64 %62, %59
  %64 = getelementptr inbounds double, ptr %60, i64 %63
  %65 = load double, ptr %64, align 8
  %66 = fadd double %57, %65
  %67 = add i64 %39, -1
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %70 = mul nsw i64 %35, %69
  %71 = add nsw i64 %70, %67
  %72 = getelementptr inbounds double, ptr %68, i64 %71
  %73 = load double, ptr %72, align 8
  %74 = fadd double %66, %73
  %75 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %76 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %77 = mul nsw i64 %35, %76
  %78 = add nsw i64 %77, %39
  %79 = getelementptr inbounds double, ptr %75, i64 %78
  %80 = load double, ptr %79, align 8
  %81 = fadd double %74, %80
  %82 = add i64 %39, 1
  %83 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %84 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %85 = mul nsw i64 %35, %84
  %86 = add nsw i64 %85, %82
  %87 = getelementptr inbounds double, ptr %83, i64 %86
  %88 = load double, ptr %87, align 8
  %89 = fadd double %81, %88
  %90 = add i64 %35, 1
  %91 = add i64 %39, -1
  %92 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %93 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %94 = mul nsw i64 %90, %93
  %95 = add nsw i64 %94, %91
  %96 = getelementptr inbounds double, ptr %92, i64 %95
  %97 = load double, ptr %96, align 8
  %98 = fadd double %89, %97
  %99 = add i64 %35, 1
  %100 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %101 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %102 = mul nsw i64 %99, %101
  %103 = add nsw i64 %102, %39
  %104 = getelementptr inbounds double, ptr %100, i64 %103
  %105 = load double, ptr %104, align 8
  %106 = fadd double %98, %105
  %107 = add i64 %35, 1
  %108 = add i64 %39, 1
  %109 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %110 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %111 = mul nsw i64 %107, %110
  %112 = add nsw i64 %111, %108
  %113 = getelementptr inbounds double, ptr %109, i64 %112
  %114 = load double, ptr %113, align 8
  %115 = fadd double %106, %114
  %116 = fdiv double %115, 9.000000e+00
  %117 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %118 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %119 = mul nsw i64 %35, %118
  %120 = add nsw i64 %119, %39
  %121 = getelementptr inbounds double, ptr %117, i64 %120
  store double %116, ptr %121, align 8
  %122 = add i64 %39, 1
  br label %38

123:                                              ; preds = %38
  %124 = add i64 %35, 1
  br label %34

125:                                              ; preds = %34
  %126 = add i64 %17, 1
  br label %16

127:                                              ; preds = %16
  ret void

128:                                              ; preds = %19
  call void @puts(ptr @assert_msg)
  call void @abort()
  unreachable

129:                                              ; preds = %25
  call void @puts(ptr @assert_msg_0)
  call void @abort()
  unreachable
}

define void @_mlir_ciface_kernel_seidel_2d(i64 %0, ptr %1) {
  %3 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %4 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 1
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 2
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 0
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 1
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 0
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 1
  call void @kernel_seidel_2d(i64 %0, ptr %4, ptr %5, i64 %6, i64 %7, i64 %8, i64 %9, i64 %10)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
