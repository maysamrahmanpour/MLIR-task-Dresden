# needed for generating C++ operation and dialect definitions from TableGen.
add_mlir_dialect(StencilOps stencil)

# needed for generating the Stencil dialect documentation.
add_mlir_doc(StencilDialect StencilDialect Stencil/ -gen-dialect-doc)

# needed for generating documentation for the Stencil operations.
add_mlir_doc(StencilOps StencilOps Stencil/ -gen-op-doc)