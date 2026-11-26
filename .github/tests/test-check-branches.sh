#!/usr/bin/env bash
set -euo pipefail

workflow_file="${1:-.github/workflows/check-branches.yml}"
fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[[ -f "$workflow_file" ]] || fail "workflow not found: $workflow_file"
grep -Fq 'permissions: {}' "$workflow_file" || fail 'workflow must declare permissions: {}'
grep -Fq 'PR_HEAD_REF: ${{ github.head_ref }}' "$workflow_file" || fail 'head ref must be passed through the environment'
grep -Fq 'PR_BASE_REF: ${{ github.base_ref }}' "$workflow_file" || fail 'base ref must be passed through the environment'

condition="$(sed -nE 's/^[[:space:]]*if[[:space:]]+(\[\[.*\]\]);[[:space:]]*then[[:space:]]*$/\1/p' "$workflow_file" | head -n 1)"
[[ -n "$condition" ]] || fail 'could not extract the branch policy condition'

run_case() {
  local expected="$1" head_ref="$2" base_ref="$3" description="$4"
  local status=0
  PR_HEAD_REF="$head_ref" PR_BASE_REF="$base_ref" bash -c "if $condition; then exit 1; fi" || status=$?
  if [[ "$expected" == reject && "$status" -ne 1 ]]; then
    fail "$description: expected rejection, got exit $status"
  fi
  if [[ "$expected" == allow && "$status" -ne 0 ]]; then
    fail "$description: expected allowance, got exit $status"
  fi
  printf 'PASS: %s\n' "$description"
}

run_case reject feature master 'non-devel branch cannot target master'
run_case allow devel master 'devel may target master'
run_case allow feature devel 'feature branch may target devel'
run_case allow devel devel 'devel may target devel'

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
marker="$tmpdir/injected"
malicious_head='$(touch '"$marker"')'
run_case reject "$malicious_head" master 'shell metacharacters remain data'
[[ ! -e "$marker" ]] || fail 'branch ref was evaluated as shell code'
printf 'PASS: branch refs are not evaluated as shell code\n'
