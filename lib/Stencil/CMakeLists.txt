add_mlir_dialect_library(MLIRStencil
  StencilDialect.cpp
  StencilOps.cpp
  StencilPasses.cpp
  ADDITIONAL_HEADER_DIRS ${PROJECT_SOURCE_DIR}/include/Stencil
  DEPENDS MLIRStencilOpsIncGen
  LINK_LIBS PUBLIC
  MLIRIR MLIRPass MLIRTransformUtils
  MLIRArithDialect MLIRControlFlowDialect MLIRFuncDialect
  MLIRLinalgDialect MLIRMemRefDialect MLIRSCFDialect
)
