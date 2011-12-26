lib_LTLIBRARIES = libgtkmusic-0.2.la

libgtkmusic_0_2_la_SOURCES = \
	GuitarWidget.vala \
	PianoWidget.vala \
	MusicalNotes.vala

libgtkmusic_0_2_la_VALAFLAGS = \
	-H gtkmusic.h --vapi gtkmusic-0.2.vapi \
	-h gtkmusic-internals.h \
	--internal-vapi gtkmusic-internals-0.2.vapi \
	--library gtkmusic-0.2 --gir GtkMusic-0.2.gir \
	--pkg gtk+-3.0 --pkg gee-1.0 \
	$(VALAFLAGS)

libgtkmusic_0_2_la_CPPFLAGS=$(LIBGTKMUSICDEPS_CFLAGS)

libgtkmusic_0_2_la_LIBADD=$(LIBGTKMUSICDEPS_LIBS)

libgtkmusic_0_2_la_LDFLAGS = \
	-version-info $(LIBGTKMUSIC_LT_VERSION) \
	-no-undefined

gtkmusicincludedir = $(includedir)/gtkmusic-0.2
gtkmusicinclude_HEADERS = gtkmusic.h

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = gtkmusic-0.2.vapi

if HAVE_INTROSPECTION

girdir = @INTROSPECTION_GIRDIR@
gir_DATA = GtkMusic-0.2.gir

typelibdir = @INTROSPECTION_TYPELIBDIR@
typelib_DATA = GtkMusic-0.2.typelib

GtkMusic-0.2.typelib: GtkMusic-0.2.gir
	@INTROSPECTION_COMPILER@ --shared-library=libgtkmusic-0.2 -o $@ $^
endif

GtkMusic-0.2.gir gtkmusic-internals-0.2.vapi gtkmusic-0.2.vapi: libgtkmusic-0.2.la

#TODO Find a more elegant way of doing this
bin_PROGRAMS = tests_notes tests_piano tests_guitar
COMMON_VALAFLAGS = --pkg gee-1.0 --pkg gtkmusic-0.2 --pkg gtk+-3.0
tests_notes_SOURCES = TestsMusicalNotes.vala
tests_notes_VALAFLAGS = $(COMMON_VALAFLAGS)
tests_notes_CPPFLAGS=$(LIBGTKMUSIC_CFLAGS)
tests_notes_LDADD=$(LIBGTKMUSIC_LIBS)
tests_piano_SOURCES = TestsPiano.vala
tests_piano_VALAFLAGS = $(COMMON_VALAFLAGS)
tests_piano_CPPFLAGS=$(LIBGTKMUSIC_CFLAGS)
tests_piano_LDADD=$(LIBGTKMUSIC_LIBS)
tests_guitar_SOURCES = TestsGuitar.vala
tests_guitar_VALAFLAGS = $(COMMON_VALAFLAGS)
tests_guitar_CPPFLAGS=$(LIBGTKMUSIC_CFLAGS)
tests_guitar_LDADD=$(LIBGTKMUSIC_LIBS)

CLEANFILES = \
	gtkmusic-0.2.vapi \
	gtkmusic-internals-0.2.vapi \
	GtkMusic-0.2.gir \
	GtkMusic-0.2.typelib \
	gtkmusic.h \
	gtkmusic-internals.h
