#!/usr/bin/env bats

# Load helper functions
load "$(dirname "$BATS_TEST_FILENAME")/helpers"

@test "push test with push-event-01.json" {
  
  # Run act command for push event test
  run act -s GHCR_TOKEN=$(gh auth token) -e push-event-01.json -W .github/workflows/demo-build.yml
  
  debug "${output}"
  assert_equal "act command should exit with code 0" "0" "$status"
  
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
  
  build_args_json=$(extract_json_from_info "$output" "generated build arguments")
  debug "build_args_json: ${build_args_json}"
  if [[ -n "$build_args_json" ]]; then
    assert_json_length "generated build arguments array should have length 2" "$build_args_json" "2"
    
    dockerfile_image_name=$(echo "$build_args_json" | jq -r '.[] | select(.dockerfilePath == "Dockerfile") | .imageName')
    assert_equal "Dockerfile element should have imageName 'my-image'" "my-image" "$dockerfile_image_name"
    
    dockerfile_image_tags=$(echo "$build_args_json" | jq -r '.[] | select(.dockerfilePath == "Dockerfile") | .imageTags')
    assert_json_length "Dockerfile element should have 2 imageTags" "$dockerfile_image_tags" "2"
    
    first_image_tag=$(echo "$dockerfile_image_tags" | jq -r '.[0]')
    assert_matches_pattern "First imageTag should match main-<timestamp>-<sha> pattern" "$first_image_tag" "^main-[0-9]{12}-[a-f0-9]{7}$"
    
    second_image_tag=$(echo "$dockerfile_image_tags" | jq -r '.[1]')
    assert_equal "Second imageTag should be 'latest'" "latest" "$second_image_tag"
  fi
}
