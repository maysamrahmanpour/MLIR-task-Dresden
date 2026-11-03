#include "Stencil/StencilOps.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/APFloat.h"
using namespace mlir;
using namespace mlir::stencil;
#define GET_OP_CLASSES
#include "Stencil/StencilOps.cpp.inc"
// needed for checking rank-two f64 memrefs and rejecting static dimensions smaller than two.
static LogicalResult verifyGrid(Operation *op, Value value) {
  auto type = dyn_cast<MemRefType>(value.getType());
  if (!type || type.getRank() != 2 || !type.getElementType().isF64())
    return op->emitOpError("requires rank-two f64 memrefs");
  for (int64_t size : type.getShape())
    if (!ShapedType::isDynamic(size) && size < 2)
      return op->emitOpError("requires dimensions of at least two");
  return success();
}
// needed for checking nonempty offsets containing pairs of i64 components in the range [-1, 1].
static LogicalResult verifyOffsets(Operation *op, ArrayAttr offsets) {
  if (offsets.empty())
    return op->emitOpError("requires at least one offset");
  for (Attribute entry : offsets) {
    auto pair = dyn_cast<ArrayAttr>(entry);
    if (!pair || pair.size() != 2)
      return op->emitOpError("requires two integer components per offset");
    for (Attribute value : pair) {
      auto integer = dyn_cast<IntegerAttr>(value);
      if (!integer || !integer.getType().isInteger(64))
        return op->emitOpError("requires i64 offset components");
      int64_t offset = integer.getInt();
      if (offset < -1 || offset > 1)
        return op->emitOpError("supports only radius-one offsets [-1,1]");
    }
  }
  return success();
}
// needed for validating apply operands, offsets, compatible static shapes and finite scale, and rejecting identical input/output SSA values.
LogicalResult ApplyOp::verify() {
  if (failed(verifyGrid(*this, getInput())) ||
      failed(verifyGrid(*this, getOutput())) ||
      failed(verifyOffsets(*this, getOffsets()))) return failure();
  auto a = cast<MemRefType>(getInput().getType());
  auto b = cast<MemRefType>(getOutput().getType());
  for (unsigned d = 0; d < 2; ++d)
    if (!a.isDynamicDim(d) && !b.isDynamicDim(d) &&
        a.getDimSize(d) != b.getDimSize(d))
      return emitOpError("requires matching input and output shapes");
  if (getInput() == getOutput())
    return emitOpError("requires non-overlapping input and output");
  // Other aliasing cannot generally be detected by this local verifier.
  const auto &scale = getScaleAttr().getValue();
  if (scale.isNaN() || scale.isInfinity())
    return emitOpError("requires a finite scale");
  return success();
}
// needed for validating the sweep grid, offsets and finite nonzero divisor.
LogicalResult SweepOp::verify() {
  if (failed(verifyGrid(*this, getGrid())) ||
      failed(verifyOffsets(*this, getOffsets()))) return failure();
  const auto &divisor = getDivisorAttr().getValue();
  if (divisor.isNaN() || divisor.isInfinity() || divisor.isZero())
    return emitOpError("requires a finite nonzero divisor");
  return success();
}
