# SPDX-License-Identifier: GPL-2.0
#
# tools/ — imported userspace tool build chain

SHELL := /bin/sh

TOOLS := pcopy

.PHONY: all pcopy install uninstall clean

all: $(TOOLS)

pcopy:
	$(MAKE) -C pcopy all

install: all
	$(MAKE) -C pcopy install

uninstall:
	$(MAKE) -C pcopy uninstall

clean:
	$(MAKE) -C pcopy clean
