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

# Simple assert function
assert_equal() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Values should be equal}"
  
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
  assert_equal "$expected_value" "$result" "jq query '$jq_query' should return '$expected_value'"
}

# Helper function to check if JSON array contains a value
assert_json_contains() {
  local json="$1"
  local expected_value="$2"
  local message="${3:-JSON should contain '$expected_value'}"
  
  local result=$(echo "$json" | jq -r "any(. == \"$expected_value\")")
  assert_equal "true" "$result" "$message"
}

# Helper function to check JSON array length
assert_json_length() {
  local json="$1"
  local expected_length="$2"
  local message="${3:-JSON array should have length $expected_length}"
  
  local result=$(echo "$json" | jq -r "length")
  assert_equal "$expected_length" "$result" "$message"
} 