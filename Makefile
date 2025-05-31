SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-print-directory
BIN := .tmp/bin
export PATH := $(BIN):$(PATH)
export GOBIN := $(abspath $(BIN))

.PHONY: help
help: ## Describe useful make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: lint
lint: $(BIN)/buf ## Lint all APIs
	buf lint
	buf format -d --exit-code

.PHONY: update
update: $(BIN)/buf ## Update dependencies
	buf dep update

$(BIN)/buf: Makefile
	@mkdir -p $(@D)
	@go install github.com/bufbuild/buf/cmd/buf@latest
