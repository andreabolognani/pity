RACKET=`which racket`
RLWRAP=`which rlwrap`
SEARCH_DIRS=`pwd`

all:
	@echo "Try \`make run' or \`make check'."

check-for-racket:
	@if [ "x$(RACKET)" = "x" ]; then \
		echo "You need Racket to run this program"; \
		exit 1; \
	fi

run: check-for-racket
	@$(RLWRAP) $(RACKET) -S $(SEARCH_DIRS) src/main.scm

check: check-for-racket
	@$(RACKET) -S $(SEARCH_DIRS) tests/tests.scm

.PHONY: all check-for-racket run check
