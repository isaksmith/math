#!/usr/bin/env bash
# Usage:
#   run-challenge setup [repo-url] [commit]   # needs network: clone, deps, Mathlib cache
#   run-challenge check <ChallengeName>       # run with --network none
set -euo pipefail

work=/work/math

case "${1:-}" in
  setup)
    repo=${2:-https://github.com/openai/math.git}
    commit=${3:-adc7f1241}
    if [ ! -d "$work/.git" ]; then
      git clone --filter=blob:none --no-checkout "$repo" "$work"
      git -C "$work" sparse-checkout set lean
      git -C "$work" checkout "$commit"
    fi
    cd "$work/lean"
    echo "== commit $(git rev-parse HEAD)"
    lake update
    lake exe cache get
    ;;
  check)
    challenge=${2:?challenge name, e.g. QuasiRiemannHypothesis}
    cd "$work/lean"
    echo "== commit $(git rev-parse HEAD)  challenge $challenge"
    time lake env comparator "ComparatorChallenges/$challenge.json"
    ;;
  *)
    echo "usage: run-challenge setup [repo] [commit] | check <ChallengeName>" >&2
    exit 2
    ;;
esac
