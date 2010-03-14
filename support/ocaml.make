.ml.cmo:
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) -c $< -o $@
