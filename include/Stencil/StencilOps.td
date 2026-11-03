#ifndef STENCIL_OPS_TD
#define STENCIL_OPS_TD
include "StencilDialect.td"
// Intentionally no Pure/NoMemoryEffect trait: both operations mutate memory.
def Stencil_ApplyOp : Stencil_Op<"apply"> {
  let summary = "Out-of-place ordered neighbourhood sum times scale";
  let description = [{
    Updates only [1,rows-1) x [1,cols-1). Source and destination must not
    overlap, shapes must match, and both dimensions must be at least two.
    Offsets are a nonempty ordered list of two integer components in [-1,1].
    Adds from the first neighbour in listed order, then multiplies by scale.
    The output's previous interior values do not contribute to the result.
  }];
  let arguments = (ins AnyMemRef:$input, AnyMemRef:$output,
                       ArrayAttr:$offsets, F64Attr:$scale);
  let hasVerifier = 1;
  let assemblyFormat = [{
    `ins` `(` $input `:` type($input) `)`
    `outs` `(` $output `:` type($output) `)`
    `offsets` $offsets `scale` `(` $scale `)` attr-dict
  }];
}
def Stencil_SweepOp : Stencil_Op<"sweep"> {
  let summary = "In-place lexicographic ordered neighbourhood sum divided by divisor";
  let description = [{
    Updates the same radius-one interior as apply, first dimension outermost.
    Each point reads the current array, sums in listed order, divides and stores
    immediately. Earlier stores are visible to later points. Both dimensions
    must be at least two. The finite divisor must be nonzero.
  }];
  let arguments = (ins AnyMemRef:$grid, ArrayAttr:$offsets, F64Attr:$divisor);
  let hasVerifier = 1;
  let assemblyFormat = [{
    $grid `offsets` $offsets `divisor` `(` $divisor `)`
    attr-dict `:` type($grid)
  }];
}
#endif
