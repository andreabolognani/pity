noinst_OCAMLPACKAGES = pity.cma
pity_cma_OCAMLSOURCES = name.ml term.ml

pity.cma: $(pity_cma_OCAMLSOURCES:.ml=.cmo)
	OCAMPATH=$(top_builddir) $(OCAMLFIND) ocamlc -a $(PACKAGES) $^ -o $@

META: $(top_builddir)/META
	$(INSTALL_DATA) $< $@

all-am: $(noinst_OCAMLPACKAGES) META

EXTRA_DIST = $(pity_cma_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo META $(noinst_OCAMLPACKAGES)

include $(top_srcdir)/support/ocaml.make
