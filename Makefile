
# SPDX-License-Identifier: CC0-1.0
# Copyright © 2024, Badge.team

PORT ?= /dev/ttyACM0
BUILDDIR ?= build
MAKEFLAGS += --silent

IDF_PATH ?= $(shell cat .IDF_PATH 2>/dev/null || echo `pwd`/esp-idf)
IDF_TOOLS_PATH ?= $(shell cat .IDF_TOOLS_PATH 2>/dev/null || echo `pwd`/esp-idf-tools)
IDF_BRANCH ?= release/v5.3
#IDF_COMMIT ?= c57b352725ab36f007850d42578d2c7bc858ed47
IDF_EXPORT_QUIET ?= 1
IDF_GITHUB_ASSETS ?= dl.espressif.com/github_assets
LINKAGE ?= $(shell cat .LINKAGE_TYPE 2>/dev/null || echo flash_app)

SHELL := /usr/bin/env bash

export IDF_TOOLS_PATH
export IDF_GITHUB_ASSETS

# General targets

.PHONY: all
all: build

# .PHONY: install
# install: flash

# Preparation

.PHONY: prepare
prepare: submodules sdk

.PHONY: submodules
submodules:
	git submodule update --init --recursive

.PHONY: sdk
sdk:
	rm -rf "$(IDF_PATH)"
	rm -rf "$(IDF_TOOLS_PATH)"
	git clone --recursive --branch "$(IDF_BRANCH)" https://github.com/espressif/esp-idf.git "$(IDF_PATH)"
	#cd "$(IDF_PATH)"; git checkout "$(IDF_COMMIT)"
	cd "$(IDF_PATH)"; git submodule update --init --recursive
	cd "$(IDF_PATH)"; bash install.sh all
	source "$(IDF_PATH)/export.sh" && idf.py --preview set-target esp32p4
	git checkout sdkconfig

# Cleaning

.PHONY: clean
clean:
	rm -rf "$(BUILDDIR)"

# Building

.PHONY: build
build:
	source "$(IDF_PATH)/export.sh" >/dev/null && \
		cmake -Dlinkage=$(LINKAGE) -B $(BUILDDIR) && \
		cmake --build $(BUILDDIR)

# Hardware

# .PHONY: flash
# flash: build
# 	source "$(IDF_PATH)/export.sh" && idf.py flash -p $(PORT)

# .PHONY: erase
# erase:
# 	source "$(IDF_PATH)/export.sh" && idf.py erase-flash -p $(PORT)

# .PHONY: monitor
# monitor:
# 	source "$(IDF_PATH)/export.sh" && idf.py monitor -p $(PORT)

# .PHONY: openocd
# openocd:
# 	source "$(IDF_PATH)/export.sh" && idf.py openocd

# .PHONY: gdb
# gdb:
# 	source "$(IDF_PATH)/export.sh" && idf.py gdb

# Formatting

.PHONY: format
format:
	find main/ -iname '*.h' -o -iname '*.c' -o -iname '*.cpp' | xargs clang-format -i
