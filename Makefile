.DELETE_ON_ERROR:
.DEFAULT_GOAL := all

BIN := .tmp/bin

export GOBIN := $(abspath $(BIN))

.PHONY: all
all: ## Format, lint
	$(MAKE) format
	$(MAKE) lint
	$(MAKE) generate

.PHONY: lint
lint: $(BIN)/buf ## Lint all
	buf lint
	buf format -d --exit-code

.PHONY: format
format: $(BIN)/buf ## Format proto files
	buf format -w

.PHONY: generate
generate: $(BIN)/buf ## Generate  code
	buf generate

$(BIN)/buf: Makefile
	@mkdir -p $(@D)
	@go install github.com/bufbuild/buf/cmd/buf@latest
