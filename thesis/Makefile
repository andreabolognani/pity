THESIS_OUT=thesis.pdf
THESIS_IN=thesis.tex
BUILD_DIR=.build

PDFLATEX_OPTIONS=-halt-on-error \
                 -interaction=nonstopmode \
                 -output-directory=$(BUILD_DIR)

$(THESIS_OUT): $(BUILD_DIR) $(THESIS_IN)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_IN)
	@pdflatex $(PDFLATEX_OPTIONS) $(THESIS_IN)
	@cp $(BUILD_DIR)/$(THESIS_OUT) $(THESIS_OUT)

$(BUILD_DIR):
	@mkdir $(BUILD_DIR) >/dev/null 2>&1

clean:
	@rm -f $(THESIS_OUT) >/dev/null 2>&1
	@rm -rf $(BUILD_DIR) >/dev/null 2>&1

.PHONY: clean
