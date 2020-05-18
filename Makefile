CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

WGET = wget -c --no-check-certificate

.PHONY: all
all: install

GRAAL_VER = 20.0.0

.PHONY: install
install: gz/graalvm-ce-java11-linux-amd64-$(GRAAL_VER).tar.gz
gz/graalvm-ce-java11-linux-amd64-$(GRAAL_VER).tar.gz:
	$(WGET) -O $@ https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$(GRAAL_VER)/graalvm-ce-java11-linux-amd64-$(GRAAL_VER).tar.gz
