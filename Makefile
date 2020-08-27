SHELL := /usr/bin/env bash -o pipefail
PROJECT := blog
HUGO_VER := 0.74.3

### curl -L -s https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_macOS-64bit.tar.gz | tar xvf - -C tmp
### Everything below this line is meant to be static, i.e. only adjust the above variables. ###
UNAME_OS := $(shell uname -s)
BIT := $(shell getconf LONG_BIT)

ifeq ($(UNAME_OS),Darwin)
	OS=macOS
endif
ifeq ($(UNAME_OS),Linux)
	OS=Linux
endif

HUGO_RELEASE_URL := https://github.com/gohugoio/hugo/releases/download
REALASE_FILE_URL := $(HUGO_RELEASE_URL)/v$(HUGO_VER)/hugo_$(HUGO_VER)_$(OS)-$(BIT)bit.tar.gz

# hugo will be cached to ~/.cache/blog.
CACHE := $(HOME)/.cache/$(PROJECT)
CACHE_BIN := $(CACHE)/bin
CACHE_VERSIONS := $(CACHE)/versions

export PATH := $(abspath $(CACHE_BIN)):$(PATH)

# If HUGO_VER is changed, the binary will be re-downloaded.
HUGO := $(CACHE_VERSIONS)/hugo/$(HUGO_VER)
$(HUGO):
	@rm -f $(CACHE_BIN)/hugo
	@mkdir -p $(CACHE_BIN)
	curl -sL $(REALASE_FILE_URL) | tar xvfz - -C $(CACHE_BIN)
	@chmod +x $(CACHE_BIN)/hugo
	@rm -rf $(dir $(HUGO))
	@mkdir -p $(dir $(HUGO))
	@touch $(HUGO)


version: $(HUGO)
	@hugo version

run: $(HUGO)
	@hugo server -D --minify -e production

build: $(HUGO)
	hugo --minify -e production