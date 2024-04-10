TOP_LEVEL := $(shell git rev-parse --show-toplevel)
TOOLSDIR := $(TOP_LEVEL)/.tools
ADDLICENSE := $(TOOLSDIR)/addlicense
FSOC := $(TOOLSDIR)/fsoc
FSOC_VERSION := 0.67.0
ADDLICENSE_VERSION := 1.1.1
FSOC_FILE := fsoc-linux-amd64

# Detect OS and Architecture
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_S),Darwin)
	ifeq ($(UNAME_M),arm64)
		# Apple Silicon Mac
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_macOS_arm64.tar.gz
		FSOC_BINARY := fsoc-darwin-arm64.tar.gz
		FSOC_FILE := fsoc-darwin-arm64
	else
		# Intel Mac
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_macOS_x86_64.tar.gz
		FSOC_BINARY := fsoc-darwin-amd64.tar.gz
		FSOC_FILE := fsoc-darwin-amd64
	endif
	MDLINT := brew list markdownlint-cli || brew install markdownlint-cli
else ifeq ($(UNAME_S),Linux)
	ifeq ($(UNAME_M),x86_64)
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_Linux_x86_64.tar.gz
		FSOC_BINARY := fsoc-linux-amd64.tar.gz
		FSOC_FILE := fsoc-linux-amd64
	else ifeq ($(UNAME_M),arm64)
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_Linux_arm64.tar.gz
		FSOC_BINARY := fsoc-linux-arm64.tar.gz
		FSOC_FILE := fsoc-linux-arm64
	endif
endif

$(ADDLICENSE):
	mkdir -p $(TOOLSDIR)
	wget https://github.com/google/addlicense/releases/download/v$(ADDLICENSE_VERSION)/$(ADDLICENSE_BINARY)
	tar -xvf $(ADDLICENSE_BINARY) -C $(TOOLSDIR) addlicense
	rm $(ADDLICENSE_BINARY)

$(FSOC):
	mkdir -p $(TOOLSDIR)
	wget https://github.com/cisco-open/fsoc/releases/download/v$(FSOC_VERSION)/$(FSOC_BINARY)
	tar -xvf $(FSOC_BINARY) -C $(TOOLSDIR) $(FSOC_FILE)
	rm $(FSOC_BINARY)
	mv $(TOOLSDIR)/$(FSOC_FILE) $(FSOC)

.PHONY: all
all: lint markdown-lint test check-license

.PHONY: check-license
check-license: $(ADDLICENSE)
	@echo "verifying license headers"
	$(ADDLICENSE) -v -check .

.PHONY: add-license
add-license: $(ADDLICENSE)
	@echo "adding license headers, please commit any modified files"
	$(ADDLICENSE) -s -v -c "Cisco Systems, Inc. and its affiliates" -l apache .

.PHONY: markdown-lint
markdown-lint:
	markdownlint *.md **/*.md .github/**/*.md

export PATH := $(TOOLSDIR):$(PATH)

# Define the folders you want to include as targets
FOLDERS :=  knowledge-store-investigation knowledge-store-secret

# Create a test target for each folder and run them in parallel
define create-folder-test-target
.PHONY: test-$(1)
test-$(1): $(FSOC)
	@echo "Testing $(1) folder"
	$(MAKE) -C $(1) test

endef

# Apply the test target creation for each folder
$(foreach folder,$(FOLDERS),$(eval $(call create-folder-test-target,$(folder))))

# Define the test-all target to run test targets for all folders in parallel
.PHONY: test
test: $(addprefix test-,$(FOLDERS))
	@echo "All tests completed"

# Create a lint target for each folder and run them in parallel
define create-folder-lint-target
.PHONY: lint-$(1)
lint-$(1): $(FSOC)
	@echo "Linting $(1) folder"
	$(MAKE) -C $(1) lint
endef

# Apply the lint target creation for each folder
$(foreach folder,$(FOLDERS),$(eval $(call create-folder-lint-target,$(folder))))

# Define the lint-all target to run lint targets for all folders in parallel
.PHONY: lint
lint: $(addprefix lint-,$(FOLDERS))
	@echo "All linting completed"


# Use the -j flag to run the test targets in parallel
.DEFAULT_GOAL := all

.PHONY: clean
clean:
	rm -rf $(TOOLSDIR)
