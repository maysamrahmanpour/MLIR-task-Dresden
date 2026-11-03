# MLIR tasks — implementation and results

I used LLVM/MLIR 23.1.3 on Ubuntu under WSL, with a Release build and
assertions enabled.


## Part 1

### Q1. Indexing maps and iterator types

I used `(d0, d1, d2)` for `(i, j, k)`.

| Operand | Indexing map | Element |
|---|---|---|
| A | `(d0,d1,d2) -> (d0,d2)` | `A[i][k]` |
| B | `(d0,d1,d2) -> (d2,d1)` | `B[k][j]` |
| C | `(d0,d1,d2) -> (d0,d1)` | `C[i][j]` |

The iterator types are:

```mlir
["parallel", "parallel", "reduction"]
```

The first two iterators select different output elements. The third iterator
adds the products over k to the same output element.

The arguments are two-dimensional f64 memrefs with dynamic sizes.
Their dimensions must match the matrix multiplication, and C must not
overlap with A or B.

### Q2. Why C is an outs operand

C is an `outs` operand because the operation reads its current value and
writes the updated result. Its block argument holds the current value of
`C[i][j]`.

Neither version initializes C to zero. Both compute:

```cpp
C[i][j] += A[i][k] * B[k][j];
```

To calculate only `C = A * B`, the caller must initialize C to zero.

I used `--linalg-generalize-named-ops` to convert the named matmul to
`linalg.generic`. The generated version and the handwritten version have
the same indexing maps, iterator types and multiply/add/yield body.
Both add the product to the current value of C.


### Q3. Changing reduction to parallel

For Q3, I changed the reduction iterator to parallel. The verifier accepted
it, but the annotation is incorrect because different k iterations update
the same `C[i][j]`.

The verifier does not prove that the iterations are independent.
A later transformation relying on this annotation could produce an
incorrect result.

This version was only used for the verifier experiment. The numerical
tests use the correct reduction annotation.

### Q4. Lowering to loops

I used these upstream passes:

- `--convert-linalg-to-loops` for SCF loops.
- `--convert-linalg-to-affine-loops` for affine loops.

These passes are listed in the MLIR Passes documentation and worked with
the LLVM/MLIR version used for this task.

The input uses memrefs, so no tensor bufferization is needed.
Both passes produced the loop order i, j, k.

The saved IR includes comments identifying the loops, the loads from
A, B and C, and the store to C.

### Q5. Choosing the loop order

I chose i, k, j.

With the original i, j, k order, the inner loop accesses `B[k][j]`.
For row-major storage, moving to the next k means moving N elements
forward in memory.

With i, k, j:

- `A[i][k]` stays the same inside the j loop.
- `B[k][j]` accesses consecutive elements.
- `C[i][j]` also accesses consecutive elements.

This gives better access locality. I did not measure a performance speedup.

### Q6. Applying the interchange

I used `transform.structured.interchange` with permutation `[0,2,1]`.

The transform library is loaded with `--transform-preload-library` and
executed with `--transform-interpreter`.

After interchange, the maps are:

| Operand | Indexing map |
|---|---|
| A | `(d0,d1,d2) -> (d0,d1)` |
| B | `(d0,d1,d2) -> (d1,d2)` |
| C | `(d0,d1,d2) -> (d0,d2)` |

The iterator types become:

```mlir
["parallel", "reduction", "parallel"]
```

I gave the transformed function a different name so both versions could
be linked into the same test program.

This transform works on the generic operation. The named matmul must
first be converted to `linalg.generic`.

### Q7. Why the interchange is legal

Assuming C does not overlap with the inputs, each output element has its
own accumulation.

For any fixed `C[i][j]`, k still runs in the same increasing order after
interchange. The change affects when different output elements are
updated, but not the order of additions for one output element.

The transformation does not parallelize k or reassociate the additions.

### Q8. Compilation pipeline

The pipeline is in `solution/scripts/task5.sh`. It starts from the original
or interchanged SCF version.

1. `--lower-affine` lowers any remaining affine helper operations.
2. `--convert-scf-to-cf` converts structured loops to blocks and branches.
3. `--convert-arith-to-llvm` lowers arithmetic operations.
4. `--finalize-memref-to-llvm` lowers memref operations and descriptors.
5. `--convert-func-to-llvm` lowers functions and returns, and generates
   the requested C-interface wrappers.
6. `--convert-cf-to-llvm` lowers control-flow operations to LLVM operations.
7. `--reconcile-unrealized-casts` removes temporary conversion casts
   where the converted types can be reconciled.
8. `mlir-translate --mlir-to-llvmir` produces LLVM IR.
9. `clang -O0 -ffp-contract=off -c` compiles LLVM IR to object files.
10. `clang++` links the object files with the C++ driver to build the executable.

The higher-level operations must be lowered before LLVM IR translation.
Some conversions introduce temporary casts, so cast reconciliation runs
after the relevant conversions.

This is one valid pipeline, but it is not the only possible order.
Skipping a required conversion can leave operations or types that cannot
be translated to LLVM IR. For example, skipping SCF conversion leaves
structured loops. Skipping cast reconciliation can leave temporary casts.

A pass can be unnecessary if there are no matching operations.
For example, `--lower-affine` is unnecessary when no affine operations remain.
These points explain the dependencies; they are not results from testing
every possible omitted pass.

The `llvm.emit_c_interface` attribute generates wrappers that accept
pointers to memref descriptors. Each descriptor contains:

- An allocated pointer and an aligned pointer.
- An offset.
- Two dimensions.
- Two strides.

The target uses 64-bit indices. The driver supplies contiguous row-major
arrays with zero offset and an inner stride of one.

The annotated LLVM files explain the descriptors, loop blocks, memory
accesses and wrapper functions. Only comments were added to these dumps.

I tested 7 cases for each loop order, including rectangular matrices,
nonzero initial C, zero K and empty outputs. All 14 comparisons passed
with zero error and bit-identical results against the reference.

The runtime tests cover the handwritten generic version and its
interchanged version. The named matmul was parsed and generalized.

## Part 2

### Stencil operations

The dialect supports two-dimensional f64 memrefs and a nonempty list of
offsets. Each offset has two integer components in the range [-1,1].

Both operations update the grid interior:

```text
[1, rows-1) × [1, cols-1)
```

The boundary values stay unchanged. Each dimension must be at least two.
A dimension of two gives an empty interior.

This supports the radius-one kernels in the assignment.

For `stencil.apply`, the input and output must have matching shapes and
must not overlap. The verifier checks static dimensions and rejects the
same SSA value used as both input and output. Different views can still
overlap, so avoiding that overlap is the caller's responsibility.

The generated code checks dynamic dimensions and shape agreement at runtime.

The scale must be finite. The divisor must be finite and nonzero.
The operations are not marked Pure, since they access and modify memory.

### Q9. Why apply can use parallel iterators

Each apply iteration reads from the input and writes to a different
output element. Neighbourhoods can overlap in the input, but these are
only reads.

The iterations are independent as long as the input and output buffers
do not overlap.

For each Jacobi pass, the lowering creates five shifted input subviews
and one output-interior subview. It uses identity indexing maps and two
parallel iterators.

The values are added in the listed order, starting with the first
neighbour. The sum is then multiplied by the scale.
The previous output value is not used.

The two Jacobi passes and the time steps remain sequential.
The parallel iterator annotation does not itself create threads.

### Q10. Why sweep needs sequential loops

Seidel reads and writes the same array. A later point must see the changes
made to earlier points.

The lowering uses sequential SCF loops, with i as the outer loop and j
as the inner loop. It reads and adds the neighbours in the listed order,
divides by the divisor, and immediately stores the result.

Using the independent-output lowering from apply would not preserve
these dependencies. Changing the traversal order or running the
iterations in parallel can change the result.

### Q11. Compilation and results

After the custom lowering, the upstream passes convert Linalg to loops,
expand strided metadata for the subviews, lower affine and SCF operations,
and then lower the remaining operations to LLVM.

The LLVM dialect is translated to LLVM IR, compiled and linked with
the driver. The compilation uses `-O0`, disables floating-point contraction
and does not enable fast-math.

The reference calculations follow the PolyBench/C kernel bodies in the
assignment. They do not use the full PolyBench timing harness.
The submitted reference code is a C++ transcription of these calculations.

The tests include PolyBench-style initialization and mixed-sign values,
with both square and rectangular grids. Jacobi checks both A and B;
Seidel checks A.

There are 20 cases for each kernel. All recorded comparisons were
bit-identical, with zero maximum error and unchanged boundaries.

The cases include:

- Zero time steps.
- Empty interiors.
- A single-point interior.
- Multiple time steps.
- A 30 × 30 grid with 20 time steps.

All 7 negative verifier tests and both structural checks also passed.

These results show agreement for the tested inputs and compiler settings.
They do not prove agreement for all floating-point values or other
compiler options.

If results differ under other settings, relevant points to check include
initialization, traversal order, addition order, fused multiply-add,
reassociation and precision.

### Q12. Division and reciprocal multiplication

Division by a constant cannot always be replaced by multiplication by
its reciprocal without changing the result.

For example:

```text
round(x / 9)
```

can differ from:

```text
round(x * round(1 / 9))
```

The reciprocal is rounded before the multiplication, which can change
the final result.

The rounding test produced:

| x | Division | Reciprocal multiplication |
|---|---|---|
| 9 | `0x1p+0` | `0x1p+0` |
| 7 | `0x1.8e38e38e38e39p-1` | `0x1.8e38e38e38e38p-1` |

Fast-math flags can allow transformations that change strict
floating-point results. For example, `arcp` allows reciprocal-based
transformations and `reassoc` allows reassociation.
Contraction can also change rounding by combining multiplication
and addition.

These permissions do not guarantee bit-identical results.
The implementation keeps the division and the listed addition order,
without fast-math flags.

## Results

- `solution/results/part1/`: toolchain information, generalized matmul,
  verifier result, IR dumps and correctness results.
- `solution/results/part2/`: stencil lowering dumps, LLVM IR,
  verifier results, correctness results and the rounding example.
- `build-starter.log`, `part1.log` and `part2.log`: execution logs.

