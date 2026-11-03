#!/usr/bin/env bash
set -euo pipefail
HERE=$(cd -- "$(dirname -- "$0")" && pwd)
for task in 2 3 4 5; do
  echo "=== Part 1, task $task ==="
  bash "$HERE/task$task.sh"
done
