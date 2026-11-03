#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/env.sh"
REPO=$(cd "$ROOT/.." && pwd)
STENCIL_OPT=${STENCIL_OPT:-"$REPO/build/bin/standalone-opt"}
P2="$ROOT/results/part2"
mkdir -p "$P2"
[[ -x "$STENCIL_OPT" ]] || { echo "Build the updated starter first: bash solution/scripts/build-starter.sh" >&2; exit 1; }
