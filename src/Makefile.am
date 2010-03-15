PACKAGES = -package pity -linkpkg

bin_SCRIPTS = pity
pity_OCAMLSOURCES = main.ml
pity_OCAMLADD = $(top_builddir)/pity/pity.cma

pity: $(pity_OCAMLSOURCES:.ml=.cmo) $(pity_OCAMLADD)
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) $^ -o $@

EXTRA_DIST = $(pity_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo $(bin_SCRIPTS)

include $(top_srcdir)/support/ocaml.make
