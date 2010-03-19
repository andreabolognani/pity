.mli.cmi:
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) -c $< -o $@

.ml.cmo:
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) -c $< -o $@

.mly.ml:
	OCAMLPATH=$(top_builddir) ocamlyacc $<
.mly.mli:
	OCAMLPATH=$(top_builddir) ocamlyacc $<

.mll.ml:
	OCAMLPATH=$(top_builddir) ocamllex -o $@ $<
