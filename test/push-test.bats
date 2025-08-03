#!/usr/bin/env bats

# Load helper functions
load "$(dirname "$BATS_TEST_FILENAME")/helpers"

@test "push test with push-event-01.json" {
  echo "Starting test..." >&3
  
  # Run act command for push event test
  run act -s GITHUB_TOKEN=$(gh auth token) -e push-event-01.json -W .github/workflows/integration-test.yml
  
  echo "Command executed with exit code: $status" >&3
  echo "Output length: ${#output}" >&3
  echo "First 200 characters of output: ${output:0:200}" >&3
  
  # Extract JSON from specific [info] lines and test with jq
  # Example: Extract changedFiles JSON
  changed_files_json=$(extract_json_from_info "$output" "changedFiles")
  echo "changed_files_json: ${changed_files_json}" >&3
  if [[ -n "$changed_files_json" ]]; then
    echo "Found changedFiles JSON: $changed_files_json" >&3
    
    # Check if "Dockerfile.prod" is included in changedFiles
    test_json_with_jq "$changed_files_json" 'any(.changedFiles[] == "Dockerfile.prodd")' "true"
  fi
  
  # Example: Extract other info JSON
  # other_json=$(extract_json_from_info "$output" "other_message")
  # if [[ -n "$other_json" ]]; then
  #   test_json_with_jq "$other_json" ".some_field" "expected_value"
  # fi
}
