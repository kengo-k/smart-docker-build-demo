#!/usr/bin/env bash

# Helper function to extract JSON from [info] lines
extract_json_from_info() {
  local output="$1"
  local message_pattern="$2"
  
  echo "$output" | while IFS= read -r line; do
    if [[ "$line" =~ ^\[info\] ]]; then
      # Check if the line contains the specific message pattern
      if [[ "$line" =~ $message_pattern ]]; then
        # Extract the part after ": " (JSON part)
        json_part=$(echo "$line" | sed 's/^\[info\][^:]*: //')
        echo "$json_part"
        return 0
      fi
    fi
  done
}

# Helper function to test JSON with jq
test_json_with_jq() {
  local json="$1"
  local jq_query="$2"
  local expected_value="$3"
  
  local result=$(echo "$json" | jq -r "$jq_query")
  if [[ "$result" == "$expected_value" ]]; then
    echo "✓ PASS: $jq_query = $expected_value"
    return 0
  else
    echo "✗ FAIL: $jq_query expected '$expected_value' but got '$result'"
    return 1
  fi
} 