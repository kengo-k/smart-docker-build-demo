#!/usr/bin/env bats

# Load helper functions
load "$(dirname "$BATS_TEST_FILENAME")/helpers"

@test "push test with push-event-01.json" {
  
  # Run act command for push event test
  run act -s GITHUB_TOKEN=$(gh auth token) -e push-event-01.json -W .github/workflows/integration-test.yml
  
  # Assert that act command executed successfully
  assert_equal "act command should exit with code 0" "0" "$status"
  debug "${output}"
  
  changed_files_json=$(extract_json_from_info "$output" "changedFiles")
  if [[ -n "$changed_files_json" ]]; then
    assert_json_contains "changedFiles should contain Dockerfile.prod" "$changed_files_json" "Dockerfile.prod"
  fi
  
  dockerfiles_json=$(extract_json_from_info "$output" "dockerfiles")
  debug "dockerfiles_json: ${dockerfiles_json}"
  if [[ -n "$dockerfiles_json" ]]; then
    assert_json_length "dockerfiles array should have length 2" "$dockerfiles_json" "2"
    assert_json_contains "dockerfiles should contain Dockerfile" "$dockerfiles_json" "Dockerfile"
    assert_json_contains "dockerfiles should contain Dockerfile.prod" "$dockerfiles_json" "Dockerfile.prod"
  fi
}
