CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

WGET = wget -c --no-check-certificate

PIP = $(CWD)/bin/pip3
PY  = $(CWD)/bin/python3


GRAAL_VER	= 20.0.0
GRAAL		= graalvm-ce-java11-$(GRAAL_VER)
GRAAL_HOME	= $(CWD)/$(GRAAL)

JAVA		= $(GRAAL_HOME)/bin/java
JAVAC		= $(GRAAL_HOME)/bin/javac

XPATH		= PATH=$(GRAAL_HOME)/bin:$(PATH) JAVA_HOME=$(GRAAL_HOME)

.PHONY: all
all:
	$(PY) metaL.py metaL.ini
	$(XPATH) graalpython metaL.py metaL.ini

.PHONY: install
install: debian $(PIP) $(GRAAL)/release
	$(PIP) install    -r requirements.txt
	$(MAKE) requirements.txt
	$(XPATH) gu install python
$(GRAAL)/release: gz/graalvm-ce-java11-linux-amd64-$(GRAAL_VER).tar.gz
	tar zx < $< && touch $@
gz/graalvm-ce-java11-linux-amd64-$(GRAAL_VER).tar.gz:
	$(WGET) -O $@ https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$(GRAAL_VER)/graalvm-ce-java11-linux-amd64-$(GRAAL_VER).tar.gz

.PHONY: update
update: debian $(PIP)
	$(PIP) install -U    pip
	$(PIP) install -U -r requirements.txt
	$(MAKE) requirements.txt

$(PIP) $(PY):
	python3 -m venv .
	$(PIP) install -U pip pylint autopep8

.PHONY: requirements.txt
requirements.txt: $(PIP)
	$< freeze | grep -v 0.0.0 > $@

.PHONY: debian
debian:
	sudo apt update
	sudo apt install -u `cat apt.txt`



.PHONY: master shadow release zip

MERGE  = Makefile README.md gz .gitignore .vscode
MERGE += apt.txt requirements.txt metaL.py metaL.ini

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
