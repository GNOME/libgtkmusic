###############################################################################
#autoconf and automake init
###############################################################################
AC_INIT([libgtkmusic], [0.2], [leandro.mattioli@gmail.com])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall -Werror])

###############################################################################
#Checking for programs
###############################################################################
AM_PROG_VALAC
AC_PROG_INSTALL
AM_PROG_LIBTOOL
AM_PROG_CC_C_O
PKG_PROG_PKG_CONFIG

###############################################################################
#Checking libraries
###############################################################################
PKG_CHECK_MODULES(LIBGTKMUSICDEPS, 
	glib-2.0 > 2.28.0
	gobject-2.0 > 2.28.0
	gtk+-3.0 > 3.0.0
	gee-1.0
)
PKG_CHECK_MODULES(LIBGTKMUSIC,
    gtkmusic-0.2
)
GOBJECT_INTROSPECTION_CHECK([0.9.0])

###############################################################################
##Variables substitutions
###############################################################################
LIBGTKMUSIC_LT_VERSION="0:0:0"
AC_SUBST(LIBGTKMUSIC_LT_VERSION)
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

###############################################################################
##DoxyGen
###############################################################################
DX_HTML_FEATURE(ON)
DX_CHM_FEATURE(OFF)
DX_CHI_FEATURE(OFF)
DX_MAN_FEATURE(OFF)
DX_RTF_FEATURE(OFF)
DX_XML_FEATURE(OFF)
DX_PDF_FEATURE(OFF)
DX_PS_FEATURE(OFF)
DX_INIT_DOXYGEN(libgtkmusic, Doxyfile, doc/api)

###############################################################################
#Glade catalog
###############################################################################
AC_MSG_CHECKING([whether to install the glade catalog])
AC_ARG_ENABLE([glade], 
  [AS_HELP_STRING([--disable-glade],[Disable installing the glade catalog])],
  [enable_glade_catalog=no],[enable_glade_catalog=yes])
AC_MSG_RESULT([$enable_glade_catalog])

if test "$enable_glade_catalog" = "yes"; then
    GLADE_CATALOG_DIR="$($PKG_CONFIG --variable=catalogdir gladeui-2.0)"
    GLADE_ICON_DIR="$($PKG_CONFIG --variable=pixmapdir gladeui-2.0)"
    GLADE_MODULE_DIR="$($PKG_CONFIG --variable=moduledir gladeui-2.0)"
    if test -z "$GLADE_CATALOG_DIR" -o -z "$GLADE_MODULE_DIR"; then
        AC_MSG_ERROR([gladeui-2.0 not found])
    fi
    AC_SUBST([GLADE_CATALOG_DIR])
    AC_SUBST([GLADE_ICON_DIR])
    AC_SUBST([GLADE_MODULE_DIR])
fi
AM_CONDITIONAL([ENABLE_GLADE_CATALOG],[test "$enable_glade_catalog" = "yes"])

###############################################################################
#Main
###############################################################################
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([
	Makefile
	src/Makefile
	glade/Makefile
	gtkmusic-0.2.pc
])
AC_OUTPUT
