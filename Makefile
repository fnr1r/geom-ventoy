HERE := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

include $(HERE)/scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

DIST_DIR := $(REPO_DIR)/dist
BUILD_DIR := $(REPO_DIR)/build
SRC_DIR := $(REPO_DIR)/src

SOURCES := $(shell find $(SRC_DIR))

.PHONY: all build clean
all: build
build: build/geom_ventoy.ko
clean:
	-rm -r build dist

ifdef SYSDIR
SYSDIR := $(realpath $(SYSDIR))
export SYSDIR
endif

build/geom_ventoy.ko: $(SOURCES)

ifeq ($(IS_FREEBSD),yes)
# NOTE: we are explicitly using BSD Make here
build/geom_ventoy.ko:
	@mkdir -p build
	+make -C build -f "$(SRC_DIR)/Makefile" VTOY_SRCTOP="$(SRC_DIR)"
else
build/geom_ventoy.ko:
	$(error can't build $@ on non-FreeBSD)
endif
