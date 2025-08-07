# Makefile for running BATS tests

.PHONY: test
test:
	bats test/

.PHONY: test-push
test-push:
	bats test/push-test.bats

.PHONY: test-verbose
test-verbose:
	bats --tap test/

.PHONY: test-push-verbose
test-push-verbose:
	bats --tap test/push-test.bats

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  test                     - Run all BATS tests in test/ directory"
	@echo "  test-push                - Run push test specifically"
	@echo "  test-verbose             - Run all tests with verbose output"
	@echo "  test-push-verbose        - Run push test with verbose output"
	@echo "  help                     - Show this help message"