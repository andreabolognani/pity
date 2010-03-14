.ml.cmo:
	OCAMLPATH=$(top_srcdir) $(OCAMLFIND) ocamlc $(PACKAGES) -c $< -o $@
