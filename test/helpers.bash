#!/usr/bin/env bash

# Helper function to extract JSON from [info] lines
extract_json_from_info() {
  local output="$1"
  local message_pattern="$2"
  
  echo "$output" | while IFS= read -r line; do
    # Handle lines with prefix like "[Integration Tests/test-smart-docker-build]   | [info]"
    if [[ "$line" =~ \[info\] ]]; then
      # Check if the line contains the specific message pattern
      if [[ "$line" =~ $message_pattern ]]; then
        # Extract the part after ": " (JSON part)
        json_part=$(echo "$line" | sed 's/.*\[info\][^:]*: //')
        echo "$json_part"
        return 0
      fi
    fi
  done
}

# Debug output function (redirects to stderr for BATS visibility)
debug() {
  echo "$1" >&3
}

# Simple assert function
assert_equal() {
  local message="$1"
  local expected="$2"
  local actual="$3"
  
  if [[ "$expected" == "$actual" ]]; then
    echo "✓ PASS: $message"
    return 0
  else
    echo "✗ FAIL: $message (expected: '$expected', actual: '$actual')" >&2
    return 1
  fi
}

# Helper function to test JSON with jq using BATS assertions
test_json_with_jq() {
  local json="$1"
  local jq_query="$2"
  local expected_value="$3"
  
  local result=$(echo "$json" | jq -r "$jq_query")
  assert_equal "jq query '$jq_query' should return '$expected_value'" "$expected_value" "$result"
}

# Helper function to check if JSON array contains a value
assert_json_contains() {
  local message="$1"
  local json="$2"
  local expected_value="$3"
  
  local result=$(echo "$json" | jq -r "any(. == \"$expected_value\")")
  assert_equal "$message" "true" "$result"
}

# Helper function to check JSON array length
assert_json_length() {
  local message="$1"
  local json="$2"
  local expected_length="$3"
  
  local result=$(echo "$json" | jq -r "length")
  assert_equal "$message" "$expected_length" "$result"
}

# Helper function to check if a value matches a pattern
assert_matches_pattern() {
  local message="$1"
  local value="$2"
  local pattern="$3"
  
  if [[ "$value" =~ $pattern ]]; then
    echo "✓ PASS: $message"
    return 0
  else
    echo "✗ FAIL: $message (value: '$value', pattern: '$pattern')" >&2
    return 1
  fi
} 