noinst_OCAMLPACKAGES = pity.cma
pity_cma_OCAMLSOURCES = name.ml term.ml $(BUILT_SOURCES)
pity_cma_OCAMLOBJECTS = name.cmo term.cmo parser.cmi parser.cmo lexer.cmo

pity.cma: $(pity_cma_OCAMLOBJECTS)
	OCAMPATH=$(top_builddir) $(OCAMLFIND) ocamlc -a $(PACKAGES) $(filter %.cmo, $^) -o $@

META: $(top_builddir)/pity/META.pity
	$(INSTALL_DATA) $< $@

all-am: $(noinst_OCAMLPACKAGES) META

BUILT_SOURCES = parser.mli parser.ml lexer.ml
EXTRA_DIST = $(pity_cma_OCAMLSOURCES)
CLEANFILES = *.cmi *.cmo *.mli META $(noinst_OCAMLPACKAGES) $(BUILT_SOURCES)

include $(top_srcdir)/support/ocaml.make
