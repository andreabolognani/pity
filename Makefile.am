ACLOCAL_AMFLAGS = -I m4

bin_SCRIPTS = hello$(EXEEXT)

PACKAGES =
LIBS =

hello$(EXEEXT): hello.cmo
		$(OCAMLFIND) ocamlc $(PACKAGES) $(LIBS) $^ -o $@

.ml.cmo:
	$(OCAMLFIND) ocamlc $(PACKAGES) -c $< -o $@

EXTRA_DIST = hello.ml

CLEANFILES = *.cmi *.cmo $(bin_SCRIPTS)
