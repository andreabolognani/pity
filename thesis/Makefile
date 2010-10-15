THESIS_OUT=thesis.pdf

THESIS_IN_MAIN=main.tex
THESIS_IN_OTHER=common.tex \
                pi-calcolo.tex \
                racket.tex \
                type-system.tex \
                implementazione/*
THESIS_IN_BIB=references.bib
BUILD_DIR=.build

PDFLATEX_OPTIONS=-halt-on-error \
                 -interaction nonstopmode \
                 -output-directory $(BUILD_DIR) \
                 -jobname $(THESIS_OUT:.pdf=)

$(THESIS_OUT): $(BUILD_DIR) $(THESIS_IN_MAIN) $(THESIS_IN_OTHER) $(THESIS_IN_BIB)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_IN_MAIN)
	@bibtex $(BUILD_DIR)/$(THESIS_OUT:.pdf=)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_IN_MAIN)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_IN_MAIN)
	@cp $(BUILD_DIR)/$(THESIS_OUT) $(THESIS_OUT)

$(BUILD_DIR):
	@mkdir $(BUILD_DIR) >/dev/null 2>&1

clean:
	@rm -f $(THESIS_OUT) >/dev/null 2>&1
	@rm -rf $(BUILD_DIR) >/dev/null 2>&1

.PHONY: clean
