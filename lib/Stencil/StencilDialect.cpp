#include "Stencil/StencilDialect.h"
#include "Stencil/StencilOps.h"
#include "Stencil/StencilOpsDialect.cpp.inc"
using namespace mlir;
using namespace mlir::stencil;
void StencilDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Stencil/StencilOps.cpp.inc"
  >();
}
