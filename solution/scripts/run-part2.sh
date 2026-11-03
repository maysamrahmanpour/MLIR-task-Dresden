#!/usr/bin/env bash
set -euo pipefail
HERE=$(cd -- "$(dirname -- "$0")" && pwd)
for task in 1 2 3 4; do
  echo "=== Part 2, task $task ==="
  bash "$HERE/part2-task$task.sh"
done
