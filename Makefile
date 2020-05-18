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

.PHONY: master shadow release zip

MERGE  = Makefile README.md gz .vscode

master:
	git checkout $@
	git checkout shadow -- $(MERGE)

shadow:
	git checkout $@

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

zip:
	git archive --format zip --output $(MODULE)_src_$(NOW)_$(REL).zip HEAD
