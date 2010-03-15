PACKAGES = -package pity -package oUnit -linkpkg
OCAMLADD = $(top_builddir)/pity/pity.cma

noinst_SCRIPTS = nametests
nametests_OCAMLSOURCES = nametests.ml

nametests: $(nametests_OCAMLSOURCES:.ml=.cmo) $(OCAMLADD)
	OCAMLPATH=$(top_builddir) $(OCAMLFIND) ocamlc $(PACKAGES) $^ -o $@

TESTS = $(noinst_SCRIPTS)

EXTRA_DIST = $(noinst_SCRIPTS:=.ml)
CLEANFILES = *.cmi *.cmo $(noinst_SCRIPTS)

include $(top_srcdir)/support/ocaml.make
