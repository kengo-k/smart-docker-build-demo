#!/usr/bin/env bats

# Load helper functions
load "$(dirname "$BATS_TEST_FILENAME")/helpers"

@test "integration tag test" {
  # Run the same command as make integration-tag-test
  run act -s GITHUB_TOKEN=$(gh auth token) -e test-tag-event-01.json -W .github/workflows/integration-test.yml
  
  # For now, just run the command without any assertions
  echo "Command executed with exit code: $status"
  echo "Output: $output"
  
  # Extract JSON from specific [info] lines and test with jq
  # Example: Extract changedFiles JSON
  changed_files_json=$(extract_json_from_info "$output" "changedFiles")
  if [[ -n "$changed_files_json" ]]; then
    echo "Found changedFiles JSON: $changed_files_json"
    
    # Example tests using the helper function
    # test_json_with_jq "$changed_files_json" ".changedFiles[0]" "expected_file.txt"
    # test_json_with_jq "$changed_files_json" "length(.changedFiles)" "5"
  fi
} 