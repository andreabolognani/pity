THESIS_OUT=thesis.pdf

THESIS_MAIN=main.tex
THESIS_CHAPTERS=abstract/*.tex \
                introduzione/*.tex \
                implementazione/*.tex \
                implementazione/nomi/*.tex \
                implementazione/processi/*.tex \
                implementazione/sort/*.tex \
                implementazione/sorting/*.tex \
                implementazione/ambienti/*.tex \
                type-inference/*.tex \
                toplevel/*.tex \
                conclusioni/*.tex
THESIS_OTHER=common.tex
THESIS_BIB=references.bib
THESIS_IN=$(THESIS_MAIN) \
          $(THESIS_CHAPTERS) \
          $(THESIS_OTHER) \
          $(THESIS_BIB)
BUILD_DIR=.build

PDFLATEX_OPTIONS=-halt-on-error \
                 -interaction nonstopmode \
                 -output-directory $(BUILD_DIR) \
                 -jobname $(THESIS_OUT:.pdf=)

$(THESIS_OUT): $(BUILD_DIR) $(THESIS_IN)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_MAIN)
	@bibtex $(BUILD_DIR)/$(THESIS_OUT:.pdf=)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_MAIN)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_MAIN)
	@cp $(BUILD_DIR)/$(THESIS_OUT) $(THESIS_OUT)

$(BUILD_DIR):
	@mkdir $(BUILD_DIR) >/dev/null 2>&1

check:
	@for file in $(THESIS_CHAPTERS); do \
		aspell -l it -t -p ./thesis.dict -c $$file; \
	done

clean:
	@rm -f $(THESIS_OUT) >/dev/null 2>&1
	@rm -rf $(BUILD_DIR) >/dev/null 2>&1

.PHONY: clean check
