TOP_LEVEL := $(shell git rev-parse --show-toplevel)
TOOLSDIR := $(TOP_LEVEL)/.tools
ADDLICENSE := $(TOOLSDIR)/addlicense
FSOC := $(TOOLSDIR)/fsoc
FSOC_VERSION := 0.67.0
ADDLICENSE_VERSION := 1.1.1

# Detect OS and Architecture
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_S),Darwin)
	ifeq ($(UNAME_M),arm64)
		# Apple Silicon Mac
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_macOS_arm64.tar.gz
		FSOC_BINARY := fsoc-darwin-arm64.tar.gz
	else
		# Intel Mac
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_macOS_x86_64.tar.gz
		FSOC_BINARY := fsoc-darwin-amd64.tar.gz
	endif
	MDLINT := brew list markdownlint-cli || brew install markdownlint-cli
else ifeq ($(UNAME_S),Linux)
	ifeq ($(UNAME_M),x86_64)
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_Linux_x86_64.tar.gz
		FSOC_BINARY := fsoc-linux-amd64.tar.gz
	else ifeq ($(UNAME_M),arm64)
		ADDLICENSE_BINARY := addlicense_$(ADDLICENSE_VERSION)_Linux_arm64.tar.gz
		FSOC_BINARY := fsoc-linux-arm64.tar.gz
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
	tar -xvf $(FSOC_BINARY) -C $(TOOLSDIR) fsoc
	rm $(FSOC_BINARY)

.PHONY: all
all: lint test check-license

.PHONY: check-license
check-license: $(ADDLICENSE)
	@echo "verifying license headers"
	$(ADDLICENSE) -ignore .git --ignore .idea -check .

.PHONY: add-license
add-license: $(ADDLICENSE)
	@echo "adding license headers, please commit any modified files"
	$(ADDLICENSE) -s -v -c "Cisco Systems, Inc. and its affiliates" -l apache .

.PHONY: lint
lint: markdown-lint

.PHONY: markdown-lint
markdown-lint:
	markdownlint $(TOP_LEVEL)/**/*.md

.PHONY: test
test:
	@echo "testing placeholder"

.PHONY: clean
clean:
	rm -rf $(TOOLSDIR)
