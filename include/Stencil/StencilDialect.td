#ifndef STENCIL_DIALECT_TD
#define STENCIL_DIALECT_TD
include "mlir/IR/OpBase.td"
def Stencil_Dialect : Dialect {
  let name = "stencil";
  let cppNamespace = "::mlir::stencil";
  let summary = "Ordered radius-one rank-two f64 stencils";
}
class Stencil_Op<string mnemonic, list<Trait> traits = []> :
    Op<Stencil_Dialect, mnemonic, traits>;
#endif
