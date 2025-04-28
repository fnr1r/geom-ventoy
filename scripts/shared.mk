CURRENT_OS := $(shell uname -s)
ifeq ($(CURRENT_OS),FreeBSD)
IS_FREEBSD := yes
else
IS_FREEBSD := no
endif
