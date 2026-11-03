; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

@assert_msg_6 = private constant [29 x i8] c"stencil.apply shape mismatch\00"
@assert_msg_5 = private constant [29 x i8] c"stencil.apply shape mismatch\00"
@assert_msg_4 = private constant [39 x i8] c"stencil dimension must be at least two\00"
@assert_msg_3 = private constant [39 x i8] c"stencil dimension must be at least two\00"
@assert_msg_2 = private constant [29 x i8] c"stencil.apply shape mismatch\00"
@assert_msg_1 = private constant [29 x i8] c"stencil.apply shape mismatch\00"
@assert_msg_0 = private constant [39 x i8] c"stencil dimension must be at least two\00"
@assert_msg = private constant [39 x i8] c"stencil dimension must be at least two\00"

declare void @abort()

declare void @puts(ptr)

define void @kernel_jacobi_2d(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, ptr %8, ptr %9, i64 %10, i64 %11, i64 %12, i64 %13, i64 %14) {
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %8, 0
  %17 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, ptr %9, 1
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %17, i64 %10, 2
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, i64 %11, 3, 0
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 %13, 4, 0
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 %12, 3, 1
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 %14, 4, 1
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %1, 0
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, ptr %2, 1
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %3, 2
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %4, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %6, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 %5, 3, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, i64 %7, 4, 1
  br label %30

30:                                               ; preds = %449, %15
  %31 = phi i64 [ %450, %449 ], [ 0, %15 ]
  %32 = icmp slt i64 %31, %0
  br i1 %32, label %33, label %451

33:                                               ; preds = %30
  %34 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %35 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %34, ptr %35, align 4
  %36 = getelementptr [2 x i64], ptr %35, i32 0, i64 0
  %37 = load i64, ptr %36, align 4
  %38 = icmp sge i64 %37, 2
  br i1 %38, label %39, label %452

39:                                               ; preds = %33
  %40 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %41 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %40, ptr %41, align 4
  %42 = getelementptr [2 x i64], ptr %41, i32 0, i64 1
  %43 = load i64, ptr %42, align 4
  %44 = icmp sge i64 %43, 2
  br i1 %44, label %45, label %453

45:                                               ; preds = %39
  %46 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %47 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %46, ptr %47, align 4
  %48 = getelementptr [2 x i64], ptr %47, i32 0, i64 0
  %49 = load i64, ptr %48, align 4
  %50 = icmp eq i64 %37, %49
  br i1 %50, label %51, label %454

51:                                               ; preds = %45
  %52 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %53 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %52, ptr %53, align 4
  %54 = getelementptr [2 x i64], ptr %53, i32 0, i64 1
  %55 = load i64, ptr %54, align 4
  %56 = icmp eq i64 %43, %55
  br i1 %56, label %57, label %455

57:                                               ; preds = %51
  %58 = sub i64 %37, 2
  %59 = sub i64 %43, 2
  %60 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %61 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %62 = insertvalue { ptr, ptr, i64 } poison, ptr %60, 0
  %63 = insertvalue { ptr, ptr, i64 } %62, ptr %61, 1
  %64 = insertvalue { ptr, ptr, i64 } %63, i64 0, 2
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %66 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %67 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %70 = add i64 %68, 1
  %71 = extractvalue { ptr, ptr, i64 } %64, 0
  %72 = extractvalue { ptr, ptr, i64 } %64, 1
  %73 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %71, 0
  %74 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %73, ptr %72, 1
  %75 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %74, i64 %70, 2
  %76 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %75, i64 %58, 3, 0
  %77 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %76, i64 %68, 4, 0
  %78 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %77, i64 %59, 3, 1
  %79 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %78, i64 1, 4, 1
  %80 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %81 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %82 = insertvalue { ptr, ptr, i64 } poison, ptr %80, 0
  %83 = insertvalue { ptr, ptr, i64 } %82, ptr %81, 1
  %84 = insertvalue { ptr, ptr, i64 } %83, i64 0, 2
  %85 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %86 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %87 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %88 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %89 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %90 = extractvalue { ptr, ptr, i64 } %84, 0
  %91 = extractvalue { ptr, ptr, i64 } %84, 1
  %92 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %90, 0
  %93 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %92, ptr %91, 1
  %94 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %93, i64 %88, 2
  %95 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %94, i64 %58, 3, 0
  %96 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %95, i64 %88, 4, 0
  %97 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %96, i64 %59, 3, 1
  %98 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %97, i64 1, 4, 1
  %99 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %100 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %101 = insertvalue { ptr, ptr, i64 } poison, ptr %99, 0
  %102 = insertvalue { ptr, ptr, i64 } %101, ptr %100, 1
  %103 = insertvalue { ptr, ptr, i64 } %102, i64 0, 2
  %104 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %105 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %106 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %107 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %108 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %109 = add i64 %107, 2
  %110 = extractvalue { ptr, ptr, i64 } %103, 0
  %111 = extractvalue { ptr, ptr, i64 } %103, 1
  %112 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %110, 0
  %113 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %112, ptr %111, 1
  %114 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %113, i64 %109, 2
  %115 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %114, i64 %58, 3, 0
  %116 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %115, i64 %107, 4, 0
  %117 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %116, i64 %59, 3, 1
  %118 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %117, i64 1, 4, 1
  %119 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %120 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %121 = insertvalue { ptr, ptr, i64 } poison, ptr %119, 0
  %122 = insertvalue { ptr, ptr, i64 } %121, ptr %120, 1
  %123 = insertvalue { ptr, ptr, i64 } %122, i64 0, 2
  %124 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %125 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %126 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %127 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %128 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %129 = mul nsw i64 %127, 2
  %130 = add i64 %129, 1
  %131 = extractvalue { ptr, ptr, i64 } %123, 0
  %132 = extractvalue { ptr, ptr, i64 } %123, 1
  %133 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %131, 0
  %134 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %133, ptr %132, 1
  %135 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %134, i64 %130, 2
  %136 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %135, i64 %58, 3, 0
  %137 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %136, i64 %127, 4, 0
  %138 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %137, i64 %59, 3, 1
  %139 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %138, i64 1, 4, 1
  %140 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %141 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %142 = insertvalue { ptr, ptr, i64 } poison, ptr %140, 0
  %143 = insertvalue { ptr, ptr, i64 } %142, ptr %141, 1
  %144 = insertvalue { ptr, ptr, i64 } %143, i64 0, 2
  %145 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %146 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %147 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %148 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %149 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %150 = extractvalue { ptr, ptr, i64 } %144, 0
  %151 = extractvalue { ptr, ptr, i64 } %144, 1
  %152 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %150, 0
  %153 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %152, ptr %151, 1
  %154 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %153, i64 1, 2
  %155 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %154, i64 %58, 3, 0
  %156 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %155, i64 %148, 4, 0
  %157 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %156, i64 %59, 3, 1
  %158 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %157, i64 1, 4, 1
  %159 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %160 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %161 = insertvalue { ptr, ptr, i64 } poison, ptr %159, 0
  %162 = insertvalue { ptr, ptr, i64 } %161, ptr %160, 1
  %163 = insertvalue { ptr, ptr, i64 } %162, i64 0, 2
  %164 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %165 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %166 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %167 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %168 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %169 = add i64 %167, 1
  %170 = extractvalue { ptr, ptr, i64 } %163, 0
  %171 = extractvalue { ptr, ptr, i64 } %163, 1
  %172 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %170, 0
  %173 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %172, ptr %171, 1
  %174 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %173, i64 %169, 2
  %175 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %174, i64 %58, 3, 0
  %176 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %175, i64 %167, 4, 0
  %177 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %176, i64 %59, 3, 1
  %178 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %177, i64 1, 4, 1
  br label %179

179:                                              ; preds = %239, %57
  %180 = phi i64 [ %240, %239 ], [ 0, %57 ]
  %181 = icmp slt i64 %180, %58
  br i1 %181, label %182, label %241

182:                                              ; preds = %179
  br label %183

183:                                              ; preds = %186, %182
  %184 = phi i64 [ %238, %186 ], [ 0, %182 ]
  %185 = icmp slt i64 %184, %59
  br i1 %185, label %186, label %239

186:                                              ; preds = %183
  %187 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %79, 1
  %188 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %79, 2
  %189 = getelementptr double, ptr %187, i64 %188
  %190 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %79, 4, 0
  %191 = mul nsw i64 %180, %190
  %192 = add nsw i64 %191, %184
  %193 = getelementptr inbounds double, ptr %189, i64 %192
  %194 = load double, ptr %193, align 8
  %195 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %98, 1
  %196 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %98, 2
  %197 = getelementptr double, ptr %195, i64 %196
  %198 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %98, 4, 0
  %199 = mul nsw i64 %180, %198
  %200 = add nsw i64 %199, %184
  %201 = getelementptr inbounds double, ptr %197, i64 %200
  %202 = load double, ptr %201, align 8
  %203 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %118, 1
  %204 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %118, 2
  %205 = getelementptr double, ptr %203, i64 %204
  %206 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %118, 4, 0
  %207 = mul nsw i64 %180, %206
  %208 = add nsw i64 %207, %184
  %209 = getelementptr inbounds double, ptr %205, i64 %208
  %210 = load double, ptr %209, align 8
  %211 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %139, 1
  %212 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %139, 2
  %213 = getelementptr double, ptr %211, i64 %212
  %214 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %139, 4, 0
  %215 = mul nsw i64 %180, %214
  %216 = add nsw i64 %215, %184
  %217 = getelementptr inbounds double, ptr %213, i64 %216
  %218 = load double, ptr %217, align 8
  %219 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %158, 1
  %220 = getelementptr double, ptr %219, i64 1
  %221 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %158, 4, 0
  %222 = mul nsw i64 %180, %221
  %223 = add nsw i64 %222, %184
  %224 = getelementptr inbounds double, ptr %220, i64 %223
  %225 = load double, ptr %224, align 8
  %226 = fadd double %194, %202
  %227 = fadd double %226, %210
  %228 = fadd double %227, %218
  %229 = fadd double %228, %225
  %230 = fmul double %229, 2.000000e-01
  %231 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %178, 1
  %232 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %178, 2
  %233 = getelementptr double, ptr %231, i64 %232
  %234 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %178, 4, 0
  %235 = mul nsw i64 %180, %234
  %236 = add nsw i64 %235, %184
  %237 = getelementptr inbounds double, ptr %233, i64 %236
  store double %230, ptr %237, align 8
  %238 = add i64 %184, 1
  br label %183

239:                                              ; preds = %183
  %240 = add i64 %180, 1
  br label %179

241:                                              ; preds = %179
  %242 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %243 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %242, ptr %243, align 4
  %244 = getelementptr [2 x i64], ptr %243, i32 0, i64 0
  %245 = load i64, ptr %244, align 4
  %246 = icmp sge i64 %245, 2
  br i1 %246, label %247, label %456

247:                                              ; preds = %241
  %248 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %249 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %248, ptr %249, align 4
  %250 = getelementptr [2 x i64], ptr %249, i32 0, i64 1
  %251 = load i64, ptr %250, align 4
  %252 = icmp sge i64 %251, 2
  br i1 %252, label %253, label %457

253:                                              ; preds = %247
  %254 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %255 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %254, ptr %255, align 4
  %256 = getelementptr [2 x i64], ptr %255, i32 0, i64 0
  %257 = load i64, ptr %256, align 4
  %258 = icmp eq i64 %245, %257
  br i1 %258, label %259, label %458

259:                                              ; preds = %253
  %260 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %261 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %260, ptr %261, align 4
  %262 = getelementptr [2 x i64], ptr %261, i32 0, i64 1
  %263 = load i64, ptr %262, align 4
  %264 = icmp eq i64 %251, %263
  br i1 %264, label %265, label %459

265:                                              ; preds = %259
  %266 = sub i64 %245, 2
  %267 = sub i64 %251, 2
  %268 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %269 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %270 = insertvalue { ptr, ptr, i64 } poison, ptr %268, 0
  %271 = insertvalue { ptr, ptr, i64 } %270, ptr %269, 1
  %272 = insertvalue { ptr, ptr, i64 } %271, i64 0, 2
  %273 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %274 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %275 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %276 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %277 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %278 = add i64 %276, 1
  %279 = extractvalue { ptr, ptr, i64 } %272, 0
  %280 = extractvalue { ptr, ptr, i64 } %272, 1
  %281 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %279, 0
  %282 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %281, ptr %280, 1
  %283 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %282, i64 %278, 2
  %284 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %283, i64 %266, 3, 0
  %285 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %284, i64 %276, 4, 0
  %286 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %285, i64 %267, 3, 1
  %287 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %286, i64 1, 4, 1
  %288 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %289 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %290 = insertvalue { ptr, ptr, i64 } poison, ptr %288, 0
  %291 = insertvalue { ptr, ptr, i64 } %290, ptr %289, 1
  %292 = insertvalue { ptr, ptr, i64 } %291, i64 0, 2
  %293 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %294 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %295 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %296 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %297 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %298 = extractvalue { ptr, ptr, i64 } %292, 0
  %299 = extractvalue { ptr, ptr, i64 } %292, 1
  %300 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %298, 0
  %301 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %300, ptr %299, 1
  %302 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %301, i64 %296, 2
  %303 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %302, i64 %266, 3, 0
  %304 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %303, i64 %296, 4, 0
  %305 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %304, i64 %267, 3, 1
  %306 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %305, i64 1, 4, 1
  %307 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %308 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %309 = insertvalue { ptr, ptr, i64 } poison, ptr %307, 0
  %310 = insertvalue { ptr, ptr, i64 } %309, ptr %308, 1
  %311 = insertvalue { ptr, ptr, i64 } %310, i64 0, 2
  %312 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %313 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %314 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %315 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %316 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %317 = add i64 %315, 2
  %318 = extractvalue { ptr, ptr, i64 } %311, 0
  %319 = extractvalue { ptr, ptr, i64 } %311, 1
  %320 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %318, 0
  %321 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %320, ptr %319, 1
  %322 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %321, i64 %317, 2
  %323 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %322, i64 %266, 3, 0
  %324 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %323, i64 %315, 4, 0
  %325 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %324, i64 %267, 3, 1
  %326 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %325, i64 1, 4, 1
  %327 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %328 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %329 = insertvalue { ptr, ptr, i64 } poison, ptr %327, 0
  %330 = insertvalue { ptr, ptr, i64 } %329, ptr %328, 1
  %331 = insertvalue { ptr, ptr, i64 } %330, i64 0, 2
  %332 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %333 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %334 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %335 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %336 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %337 = mul nsw i64 %335, 2
  %338 = add i64 %337, 1
  %339 = extractvalue { ptr, ptr, i64 } %331, 0
  %340 = extractvalue { ptr, ptr, i64 } %331, 1
  %341 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %339, 0
  %342 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %341, ptr %340, 1
  %343 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %342, i64 %338, 2
  %344 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %343, i64 %266, 3, 0
  %345 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %344, i64 %335, 4, 0
  %346 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %345, i64 %267, 3, 1
  %347 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %346, i64 1, 4, 1
  %348 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %349 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %350 = insertvalue { ptr, ptr, i64 } poison, ptr %348, 0
  %351 = insertvalue { ptr, ptr, i64 } %350, ptr %349, 1
  %352 = insertvalue { ptr, ptr, i64 } %351, i64 0, 2
  %353 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %354 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %355 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %356 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %357 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %358 = extractvalue { ptr, ptr, i64 } %352, 0
  %359 = extractvalue { ptr, ptr, i64 } %352, 1
  %360 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %358, 0
  %361 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %360, ptr %359, 1
  %362 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %361, i64 1, 2
  %363 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %362, i64 %266, 3, 0
  %364 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %363, i64 %356, 4, 0
  %365 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %364, i64 %267, 3, 1
  %366 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %365, i64 1, 4, 1
  %367 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %368 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %369 = insertvalue { ptr, ptr, i64 } poison, ptr %367, 0
  %370 = insertvalue { ptr, ptr, i64 } %369, ptr %368, 1
  %371 = insertvalue { ptr, ptr, i64 } %370, i64 0, 2
  %372 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %373 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %374 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %375 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %376 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %377 = add i64 %375, 1
  %378 = extractvalue { ptr, ptr, i64 } %371, 0
  %379 = extractvalue { ptr, ptr, i64 } %371, 1
  %380 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %378, 0
  %381 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %380, ptr %379, 1
  %382 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %381, i64 %377, 2
  %383 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %382, i64 %266, 3, 0
  %384 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %383, i64 %375, 4, 0
  %385 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %384, i64 %267, 3, 1
  %386 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %385, i64 1, 4, 1
  br label %387

387:                                              ; preds = %447, %265
  %388 = phi i64 [ %448, %447 ], [ 0, %265 ]
  %389 = icmp slt i64 %388, %266
  br i1 %389, label %390, label %449

390:                                              ; preds = %387
  br label %391

391:                                              ; preds = %394, %390
  %392 = phi i64 [ %446, %394 ], [ 0, %390 ]
  %393 = icmp slt i64 %392, %267
  br i1 %393, label %394, label %447

394:                                              ; preds = %391
  %395 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %287, 1
  %396 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %287, 2
  %397 = getelementptr double, ptr %395, i64 %396
  %398 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %287, 4, 0
  %399 = mul nsw i64 %388, %398
  %400 = add nsw i64 %399, %392
  %401 = getelementptr inbounds double, ptr %397, i64 %400
  %402 = load double, ptr %401, align 8
  %403 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %306, 1
  %404 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %306, 2
  %405 = getelementptr double, ptr %403, i64 %404
  %406 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %306, 4, 0
  %407 = mul nsw i64 %388, %406
  %408 = add nsw i64 %407, %392
  %409 = getelementptr inbounds double, ptr %405, i64 %408
  %410 = load double, ptr %409, align 8
  %411 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %326, 1
  %412 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %326, 2
  %413 = getelementptr double, ptr %411, i64 %412
  %414 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %326, 4, 0
  %415 = mul nsw i64 %388, %414
  %416 = add nsw i64 %415, %392
  %417 = getelementptr inbounds double, ptr %413, i64 %416
  %418 = load double, ptr %417, align 8
  %419 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %347, 1
  %420 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %347, 2
  %421 = getelementptr double, ptr %419, i64 %420
  %422 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %347, 4, 0
  %423 = mul nsw i64 %388, %422
  %424 = add nsw i64 %423, %392
  %425 = getelementptr inbounds double, ptr %421, i64 %424
  %426 = load double, ptr %425, align 8
  %427 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %366, 1
  %428 = getelementptr double, ptr %427, i64 1
  %429 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %366, 4, 0
  %430 = mul nsw i64 %388, %429
  %431 = add nsw i64 %430, %392
  %432 = getelementptr inbounds double, ptr %428, i64 %431
  %433 = load double, ptr %432, align 8
  %434 = fadd double %402, %410
  %435 = fadd double %434, %418
  %436 = fadd double %435, %426
  %437 = fadd double %436, %433
  %438 = fmul double %437, 2.000000e-01
  %439 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %386, 1
  %440 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %386, 2
  %441 = getelementptr double, ptr %439, i64 %440
  %442 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %386, 4, 0
  %443 = mul nsw i64 %388, %442
  %444 = add nsw i64 %443, %392
  %445 = getelementptr inbounds double, ptr %441, i64 %444
  store double %438, ptr %445, align 8
  %446 = add i64 %392, 1
  br label %391

447:                                              ; preds = %391
  %448 = add i64 %388, 1
  br label %387

449:                                              ; preds = %387
  %450 = add i64 %31, 1
  br label %30

451:                                              ; preds = %30
  ret void

452:                                              ; preds = %33
  call void @puts(ptr @assert_msg)
  call void @abort()
  unreachable

453:                                              ; preds = %39
  call void @puts(ptr @assert_msg_0)
  call void @abort()
  unreachable

454:                                              ; preds = %45
  call void @puts(ptr @assert_msg_1)
  call void @abort()
  unreachable

455:                                              ; preds = %51
  call void @puts(ptr @assert_msg_2)
  call void @abort()
  unreachable

456:                                              ; preds = %241
  call void @puts(ptr @assert_msg_3)
  call void @abort()
  unreachable

457:                                              ; preds = %247
  call void @puts(ptr @assert_msg_4)
  call void @abort()
  unreachable

458:                                              ; preds = %253
  call void @puts(ptr @assert_msg_5)
  call void @abort()
  unreachable

459:                                              ; preds = %259
  call void @puts(ptr @assert_msg_6)
  call void @abort()
  unreachable
}

define void @_mlir_ciface_kernel_jacobi_2d(i64 %0, ptr %1, ptr %2) {
  %4 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 0
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 1
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 2
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 0
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 1
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 0
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 1
  %12 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %2, align 8
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 0
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 2
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 0
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 1
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 0
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 1
  call void @kernel_jacobi_2d(i64 %0, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, ptr %13, ptr %14, i64 %15, i64 %16, i64 %17, i64 %18, i64 %19)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
