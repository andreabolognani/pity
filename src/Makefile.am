PACKAGES = -package pity -linkpkg

bin_SCRIPTS = pity
pity_OCAMLSOURCES = main.ml

pity: $(pity_OCAMLSOURCES:.ml=.cmo)
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) $^ -o $@

EXTRA_DIST = $(pity_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo $(bin_SCRIPTS)

include $(top_srcdir)/support/ocaml.make
