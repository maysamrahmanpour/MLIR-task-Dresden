module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %target = transform.structured.match ops{["linalg.generic"]} in %root
      : (!transform.any_op) -> !transform.any_op
    %changed = transform.structured.interchange %target
      iterator_interchange = [0, 2, 1]
      : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}
