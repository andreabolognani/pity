PACKAGES = -package pity -linkpkg
OCAMLADD = $(top_builddir)/pity/pity.cma

noinst_SCRIPTS = pity
pity_OCAMLSOURCES = main.ml

pity: $(pity_OCAMLSOURCES:.ml=.cmo) $(OCAMLADD)
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) $^ -o $@

EXTRA_DIST = $(pity_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo $(noinst_SCRIPTS)

include $(top_srcdir)/support/ocaml.make
