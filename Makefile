# Pity: Pi-Calculus Type Checking
# Copyright (C) 2010  Andrea Bolognani <andrea.bolognani@roundhousecode.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


COLLECTION=pity

BUILD_OPTIONS=-xiId

RUN_ENTRY_POINT=src/main.rkt
CHECK_ENTRY_POINT=tests/tests.rkt

RACKET=`which racket`
RACO=`which raco`
RLWRAP=`which rlwrap`


all:
	@echo "Try \`make run' or \`make check'."


run: run-requisites collection
	@$(RLWRAP) $(RACKET) $(RUN_ENTRY_POINT)

check: run-requisites collection
	@$(RACKET) $(CHECK_ENTRY_POINT)


build: build-requisites collection
	@$(RACO) setup $(BUILD_OPTIONS) -l $(COLLECTION)
	@$(RACO) make $(RUN_ENTRY_POINT)
	@$(RACO) make $(CHECK_ENTRY_POINT)

clean:
	@rm -rf `find . -name 'compiled'`
	@rm -rf $(COLLECTION)/doc


run-requisites:
	@if (test "x$(RACKET)" = "x" || test ! -x "$(RACKET)"); then \
		echo "You need Racket to run this program" >&2; \
		exit 1; \
	fi

build-requisites: run-requisites
	@if (test "x$(RACO)" = "x" || test ! -x "$(RACO)"); then \
		echo "You need raco to build this program" >&2; \
		exit 1; \
	fi

collection: run-requisites
	@if $(RACKET) -l $(COLLECTION) 2>&1 | grep 'not found' >/dev/null; then \
		echo "Collection $(COLLECTION) not found" >&2; \
		exit 1; \
	fi


.PHONY: all run check build clean
.PHONY: run-requisites build-requisites collection
