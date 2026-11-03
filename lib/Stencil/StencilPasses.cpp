#include "Stencil/StencilOps.h"
#include "Stencil/StencilPasses.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/AffineMap.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/ADT/SmallVector.h"
using namespace mlir;
using namespace mlir::stencil;

namespace {
// Runtime guards precede creation of subviews or any access. N=2 has empty
// interior and is valid; N<2 would create invalid negative subview extents.
// needed for generating grid dimensions and runtime checks that each dimension is at least two.
static SmallVector<Value> dimensions(OpBuilder &b, Location loc, Value grid) {
  Value two = b.create<arith::ConstantIndexOp>(loc, 2);
  SmallVector<Value> dims;
  for (int64_t d = 0; d < 2; ++d) {
    Value n = b.create<memref::DimOp>(loc, grid, d);
    Value ok = b.create<arith::CmpIOp>(loc, arith::CmpIPredicate::sge, n, two);
    b.create<cf::AssertOp>(loc, ok, "stencil dimension must be at least two");
    dims.push_back(n);
  }
  return dims;
}
// needed for extracting the row and column offsets from a verified offset attribute.
static SmallVector<int64_t, 2> readOffset(Attribute attr) {
  auto pair = cast<ArrayAttr>(attr);
  return {cast<IntegerAttr>(pair[0]).getInt(),
          cast<IntegerAttr>(pair[1]).getInt()};
}
// needed for lowering stencil.apply to shifted subviews and parallel Linalg computation while preserving summation order and boundaries.
struct LowerApply : OpRewritePattern<ApplyOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(ApplyOp op, PatternRewriter &r) const override {
    Location loc = op.getLoc();
    auto dims = dimensions(r, loc, op.getInput());
    for (int64_t d = 0; d < 2; ++d) {
      Value n = r.create<memref::DimOp>(loc, op.getOutput(), d);
      Value equal = r.create<arith::CmpIOp>(loc, arith::CmpIPredicate::eq, dims[d], n);
      r.create<cf::AssertOp>(loc, equal, "stencil.apply shape mismatch");
    }
    Value two = r.create<arith::ConstantIndexOp>(loc, 2);
    SmallVector<OpFoldResult> sizes;
    for (Value n : dims) {
      Value extent = r.create<arith::SubIOp>(loc, n, two);
      sizes.push_back(extent);
    }
    SmallVector<OpFoldResult> strides{r.getIndexAttr(1), r.getIndexAttr(1)};
    SmallVector<Value> inputs;
    for (Attribute attr : op.getOffsets()) {
      auto offset = readOffset(attr);
      SmallVector<OpFoldResult> starts{r.getIndexAttr(1 + offset[0]),
                                      r.getIndexAttr(1 + offset[1])};
      // Infer the strided result type: do not incorrectly force identity layout.
      inputs.push_back(r.create<memref::SubViewOp>(
          loc, op.getInput(), starts, sizes, strides).getResult());
    }
    SmallVector<OpFoldResult> starts{r.getIndexAttr(1), r.getIndexAttr(1)};
    Value out = r.create<memref::SubViewOp>(loc, op.getOutput(), starts, sizes, strides);
    Value factor = r.create<arith::ConstantOp>(loc, op.getScaleAttr());
    SmallVector<AffineMap> maps(inputs.size() + 1,
                                AffineMap::getMultiDimIdentityMap(2, r.getContext()));
    SmallVector<utils::IteratorType> iterators(2, utils::IteratorType::parallel);
    unsigned count = inputs.size();
    r.create<linalg::GenericOp>(loc, TypeRange{}, inputs, ValueRange{out}, maps,
        iterators, [&](OpBuilder &b, Location bodyLoc, ValueRange args) {
          // Start with first neighbour, not +0.0: preserve exact summation order.
          Value sum = args[0];
          for (unsigned i = 1; i < count; ++i)
            sum = b.create<arith::AddFOp>(bodyLoc, sum, args[i]);
          Value result = b.create<arith::MulFOp>(bodyLoc, sum, factor);
          b.create<linalg::YieldOp>(bodyLoc, result);
        });
    r.eraseOp(op);
    return success();
  }
};
// needed for lowering stencil.sweep to sequential row-major SCF loops while preserving in-place updates, summation order and boundaries.
struct LowerSweep : OpRewritePattern<SweepOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(SweepOp op, PatternRewriter &r) const override {
    Location loc = op.getLoc();
    auto dims = dimensions(r, loc, op.getGrid());
    Value one = r.create<arith::ConstantIndexOp>(loc, 1);
    Value rowEnd = r.create<arith::SubIOp>(loc, dims[0], one);
    Value colEnd = r.create<arith::SubIOp>(loc, dims[1], one);
    Value divisor = r.create<arith::ConstantOp>(loc, op.getDivisorAttr());
    r.create<scf::ForOp>(loc, one, rowEnd, one, ValueRange{},
      [&](OpBuilder &outer, Location outerLoc, Value i, ValueRange) {
        outer.create<scf::ForOp>(outerLoc, one, colEnd, one, ValueRange{},
          [&](OpBuilder &inner, Location innerLoc, Value j, ValueRange) {
            Value sum;
            for (Attribute attr : op.getOffsets()) {
              auto offset = readOffset(attr);
              Value di = inner.create<arith::ConstantIndexOp>(innerLoc, offset[0]);
              Value dj = inner.create<arith::ConstantIndexOp>(innerLoc, offset[1]);
              Value row = inner.create<arith::AddIOp>(innerLoc, i, di);
              Value col = inner.create<arith::AddIOp>(innerLoc, j, dj);
              Value v = inner.create<memref::LoadOp>(innerLoc, op.getGrid(), ValueRange{row, col});
              sum = sum ? inner.create<arith::AddFOp>(innerLoc, sum, v).getResult() : v;
            }
            Value result = inner.create<arith::DivFOp>(innerLoc, sum, divisor);
            inner.create<memref::StoreOp>(innerLoc, result, op.getGrid(), ValueRange{i,j});
            inner.create<scf::YieldOp>(innerLoc);
          });
        outer.create<scf::YieldOp>(outerLoc);
      });
    r.eraseOp(op);
    return success();
  }
};
// needed for applying the stencil.apply rewrite within each function and reporting failure if any apply operation remains.
struct LowerApplyPass : PassWrapper<LowerApplyPass, OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(LowerApplyPass)
  StringRef getArgument() const final { return "lower-stencil-apply"; }
  StringRef getDescription() const final { return "Lower stencil.apply to shifted subviews and Linalg"; }
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, cf::ControlFlowDialect,
                    memref::MemRefDialect, linalg::LinalgDialect>();
  }
  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<LowerApply>(&getContext());
    ConversionTarget target(getContext());
    target.addIllegalOp<ApplyOp>();
    target.markUnknownOpDynamicallyLegal([](Operation *) { return true; });
    if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
      signalPassFailure();
  }
};
// needed for applying the stencil.sweep rewrite within each function and reporting failure if any sweep operation remains.
struct LowerSweepPass : PassWrapper<LowerSweepPass, OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(LowerSweepPass)
  StringRef getArgument() const final { return "lower-stencil-sweep"; }
  StringRef getDescription() const final { return "Lower stencil.sweep to lexicographic SCF loops"; }
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, cf::ControlFlowDialect,
                    memref::MemRefDialect, scf::SCFDialect>();
  }
  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<LowerSweep>(&getContext());
    ConversionTarget target(getContext());
    target.addIllegalOp<SweepOp>();
    target.markUnknownOpDynamicallyLegal([](Operation *) { return true; });
    if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
      signalPassFailure();
  }
};
} // namespace
// needed for registering both stencil lowering passes so they can be selected by name.

void mlir::stencil::registerStencilPasses() {
  PassRegistration<LowerApplyPass>();
  PassRegistration<LowerSweepPass>();
}
