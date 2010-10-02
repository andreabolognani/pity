THESIS_OUT=thesis.pdf
THESIS_IN=thesis.tex

$(THESIS_OUT): $(THESIS_IN)
	pdflatex thesis.tex
	pdflatex thesis.tex

clean:
	@rm -f *.aux
	@rm -f *.log
	@rm -f *.pdf
	@rm -f *.toc

.PHONY: clean
