.PHONY: integration-push-test integration-tag-test

# Run integration tests with act (branch push)
integration-push-test:
	act -s GITHUB_TOKEN=$$(gh auth token) -e test-push-event-01.json -W .github/workflows/integration-test.yml

# Run integration tests with act (tag push)
integration-tag-test:
	act -s GITHUB_TOKEN=$$(gh auth token) -e test-tag-event-01.json -W .github/workflows/integration-test.yml

# Help
help:
	@echo "Available targets:"
	@echo "  integration-push-test - Build and run integration tests with act (branch push)"
	@echo "  integration-tag-test - Build and run integration tests with act (tag push)"
