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
	@if ! ($(RACKET) -l $(COLLECTION) >/dev/null 2>&1); then \
		echo "Collection $(COLLECTION) not found" >&2; \
		exit 1; \
	fi


.PHONY: all run check build clean
.PHONY: run-requisites build-requisites collection
