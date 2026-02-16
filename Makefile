PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin

.PHONY: install uninstall test

install:
	mkdir -p "$(BINDIR)"
	install -m 755 bin/up "$(BINDIR)/up"

uninstall:
	rm -f "$(BINDIR)/up"

test:
	tests/up_test.sh
