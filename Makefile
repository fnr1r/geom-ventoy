HERE := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

include $(HERE)/scripts/here.mk
include $(SCRIPTS_DIR)/shared.mk

DIST_DIR := $(REPO_DIR)/dist
BUILD_DIR := $(REPO_DIR)/build
SRC_DIR := $(REPO_DIR)/src

SOURCES := $(shell find $(SRC_DIR))

TGTS := build/geom_ventoy.ko build/geom_ventoy.ko.nm

.PHONY: all build clean
all: build
build: $(TGTS)
clean:
	-rm -r build dist

.PHONY: diff
diff: build/geom_ventoy.ko.nm
	@diff --color=always -u build/geom_ventoy.ko.nm no_upload/prebuilts/14.x/64/geom_ventoy.ko.nm || :

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

# for debugging
build/geom_ventoy.ko.nm: build/geom_ventoy.ko
	nm $< > $@
