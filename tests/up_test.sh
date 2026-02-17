#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UP_BIN="$ROOT_DIR/bin/up"

pass_count=0
fail_count=0

pass() {
  printf 'PASS %s\n' "$1"
  pass_count=$((pass_count + 1))
}

fail() {
  printf 'FAIL %s\n' "$1" >&2
  fail_count=$((fail_count + 1))
}

assert_eq() {
  local name="$1"
  local expected="$2"
  local actual="$3"
  if [[ "$expected" == "$actual" ]]; then
    pass "$name"
  else
    printf '  expected: %s\n' "$expected" >&2
    printf '  actual:   %s\n' "$actual" >&2
    fail "$name"
  fi
}

assert_contains() {
  local name="$1"
  local text="$2"
  local needle="$3"
  if [[ "$text" == *"$needle"* ]]; then
    pass "$name"
  else
    printf '  expected to contain: %s\n' "$needle" >&2
    printf '  actual: %s\n' "$text" >&2
    fail "$name"
  fi
}

assert_status() {
  local name="$1"
  local expected_status="$2"
  local actual_status="$3"
  if [[ "$expected_status" -eq "$actual_status" ]]; then
    pass "$name"
  else
    printf '  expected status: %s\n' "$expected_status" >&2
    printf '  actual status:   %s\n' "$actual_status" >&2
    fail "$name"
  fi
}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
TMP_DIR_REAL="$(cd "$TMP_DIR" && pwd -P)"

mkdir -p "$TMP_DIR/home/user/dev/repos/mycoolrepo"
mkdir -p "$TMP_DIR/home/user/folder/folder/folder"

test_unique_match() {
  local actual
  actual="$(
    cd "$TMP_DIR/home/user/dev/repos/mycoolrepo"
    "$UP_BIN" dev
  )"
  assert_eq "unique match returns ancestor path" "$TMP_DIR_REAL/home/user/dev" "$actual"
}

test_parent_default() {
  local actual
  actual="$(
    cd "$TMP_DIR/home/user/dev/repos/mycoolrepo"
    "$UP_BIN"
  )"
  assert_eq "default returns parent" "$TMP_DIR_REAL/home/user/dev/repos" "$actual"
}

test_case_insensitive_match() {
  local actual
  actual="$(
    cd "$TMP_DIR/home/user/dev/repos/mycoolrepo"
    "$UP_BIN" DeV
  )"
  assert_eq "match is case insensitive" "$TMP_DIR_REAL/home/user/dev" "$actual"
}

test_fuzzy_subsequence_match() {
  local actual
  actual="$(
    cd "$TMP_DIR/home/user/dev/repos/mycoolrepo"
    "$UP_BIN" dv
  )"
  assert_eq "fuzzy subsequence resolves unique ancestor" "$TMP_DIR_REAL/home/user/dev" "$actual"
}

test_no_match() {
  local output
  local status
  set +e
  output="$(
    cd "$TMP_DIR/home/user/dev/repos/mycoolrepo"
    "$UP_BIN" nope 2>&1
  )"
  status=$?
  set -e

  assert_status "no match exits with code 2" 2 "$status"
  assert_contains "no match prints useful message" "$output" "no ancestor matches"
}

test_ambiguous_match() {
  local output
  local status
  set +e
  output="$(
    cd "$TMP_DIR/home/user/folder/folder/folder"
    "$UP_BIN" fol 2>&1
  )"
  status=$?
  set -e

  assert_status "ambiguous match exits with code 3" 3 "$status"
  assert_contains "ambiguous match prints candidates" "$output" "multiple ancestors match"
}

test_completion_command() {
  local output
  output="$("$UP_BIN" completion zsh)"
  assert_contains "zsh completion prints function" "$output" "compdef _up_completion up"
  assert_contains "zsh completion forwards help/version to binary" "$output" "-h|--help|-V|--version|completion|__query|__complete)"
}

test_bash_completion_command() {
  local output
  output="$("$UP_BIN" completion bash)"
  assert_contains "bash completion prints function" "$output" "complete -F _up_completion up"
  assert_contains "bash completion forwards help/version to binary" "$output" "-h|--help|-V|--version|completion|__query|__complete)"
}

test_internal_complete() {
  local output
  output="$(
    cd "$TMP_DIR/home/user/dev/repos/mycoolrepo"
    "$UP_BIN" __complete dv
  )"
  assert_contains "internal completion includes ancestor name" "$output" $'dev\t'
}

test_unique_match
test_parent_default
test_case_insensitive_match
test_fuzzy_subsequence_match
test_no_match
test_ambiguous_match
test_completion_command
test_bash_completion_command
test_internal_complete

printf '\nSummary: %d passed, %d failed\n' "$pass_count" "$fail_count"

if [[ "$fail_count" -ne 0 ]]; then
  exit 1
fi
