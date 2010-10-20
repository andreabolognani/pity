# Pity: Pi-Calculus Type Inference
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
RUN_FILE=

RUN_ENTRY_POINT=src/main.rkt
CHECK_ENTRY_POINT=tests/tests.rkt

RACKET=`which racket`
RACO=`which raco`
RLWRAP=`which rlwrap`


all: help

help:
	@echo "TARGET   DESCRIPTION"
	@echo "  run      Run the Pity toplevel in interactive mode. rlwrap"
	@echo "           is used, if available, to provide line-editing"
	@echo "           capabilities. If the RUN_FILE make variable is"
	@echo "           defined, the contents of that file will be evaluated"
	@echo "  check    Run the test suite"
	@echo "  build    Compile all the source files to bytecode for"
	@echo "           faster execution and build documentation"
	@echo "  clean    Remove all compiled files (including documentation)"
	@echo "  help     Show this message"
	@echo ""
	@echo "Before performing any action, a check is performed to make sure"
	@echo "Racket is available and the Pity collection can be loaded."
	@echo ""
	@echo "If the collection is not found, try copying the pity directory"
	@echo "to either the system or user collection directory."


run: run-requisites collection
	@$(RLWRAP) $(RACKET) $(RUN_ENTRY_POINT) $(RUN_FILE)

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
	@if $(RACKET) -e "(collection-path \"$(COLLECTION)\")" 2>&1 | grep 'not found' >/dev/null; then \
		echo "Collection $(COLLECTION) not found" >&2; \
		exit 1; \
	fi


.PHONY: all help run check build clean
.PHONY: run-requisites build-requisites collection
