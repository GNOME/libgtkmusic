dist_doc_DATA = README

ACLOCAL_AMFLAGS = -I m4

#if ENABLE_DOC
#DOC_SUBDIR = doc
#endif

#if ENABLE_BENCHMARK
#BENCHMARK_SUBDIR = benchmark
#endif

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = gtkmusic-0.2.pc

EXTRA_DIST = gtkmusic-0.2.pc.in
SUBDIRS = src $(DOC_SUBDIR) $(BENCHMARK_SUBDIR)

if ENABLE_GLADE_CATALOG
SUBDIRS += glade
endif

DISTCHECK_CONFIGURE_FLAGS = --enable-introspection
