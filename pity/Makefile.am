noinst_OCAMLPACKAGES = pity.cma
pity_cma_OCAMLSOURCES = name.ml term.ml

pity.cma: $(pity_cma_OCAMLSOURCES:.ml=.cmo)
	OCAMPATH=$(top_srcdir) $(OCAMLFIND) ocamlc -a $(PACKAGES) $^ -o $@

all-am: $(noinst_OCAMLPACKAGES)

EXTRA_DIST = META.in $(pity_cma_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo $(noinst_OCAMLPACKAGES)

include $(top_srcdir)/support/ocaml.make
