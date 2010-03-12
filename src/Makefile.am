bin_SCRIPTS = pity
pity_OCAMLSOURCES = name.ml term.ml main.ml

PACKAGES =
LIBS =

pity: $(pity_OCAMLSOURCES:.ml=.cmo)
		$(OCAMLFIND) ocamlc $(PACKAGES) $(LIBS) $^ -o $@

EXTRA_DIST = $(pity_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo $(bin_SCRIPTS)

include $(top_srcdir)/ocaml.make
