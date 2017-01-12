project(libgtkmusic)
cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

# =============================================================================
# Modules
# =============================================================================

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(FeatureSummary)
include(FindGit)
include(FindGObjectIntrospection)
include(FindVala)
include(FindGladeUI)
include(FindXMLLint)
include(UseVala)

# =============================================================================
# Common Configurations and Values
# =============================================================================

set(AUTHOR_NAME "Leandro Resende Mattioli")
set(AUTHOR_EMAIL "leandro.mattioli@gmail.com")
set(AUTHOR_CONTACT ${AUTHOR_NAME} <${AUTHOR_EMAIL}>)

set(PROJECT_URL "https://wiki.gnome.org/Projects/libgtkmusic")

set(VERSION_MAJOR "0")
set(VERSION_MINOR "4")
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}) # Build Version
set(SOVERSION ${VERSION_MAJOR})                # API Version

include_directories(src)

set(GIR_FILE GtkMusic-${VERSION}.gir)
set(TYPELIB_FILE GtkMusic-${VERSION}.typelib)
set(VAPI_FILE gtkmusic-${VERSION}.vapi)

# =============================================================================
# Dependencies
# =============================================================================

find_package(PkgConfig REQUIRED)
find_package(Vala REQUIRED)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
pkg_check_modules(GEE REQUIRED gee-0.8)

if(${VALA_VERSION} VERSION_LESS "0.30")
message(ERROR "This project requires Vala 0.30 or newer!")
endif(${VALA_VERSION} VERSION_LESS "0.30")

# =============================================================================
# Main Library, Header and Pkg-Config
# =============================================================================

vala_precompile(
    VALA_C_LIBGTKMUSIC src/GuitarWidget.vala  
                       src/MusicalNotes.vala
                       src/PianoWidget.vala
    PACKAGES gtk+-3.0
             gee-0.8
             posix

    OPTIONS	-h gtkmusic-internals.h 
	        --internal-vapi gtkmusic-internals-${VERSION}.vapi
            --shared-library libgtkmusic.so.${SOVERSION}
	        --library gtkmusic-${VERSION} --gir ${GIR_FILE}

    GENERATE_VAPI gtkmusic-${VERSION}
    GENERATE_HEADER gtkmusic
)

configure_file(${CMAKE_SOURCE_DIR}/gtkmusic.pc.in 
               ${CMAKE_BINARY_DIR}/gtkmusic.pc @ONLY)

set(DEPS_LIBRARIES    ${GTK3_LIBRARIES} ${GEE_LIBRARIES})
set(DEPS_INCLUDE_DIRS ${GTK3_INCLUDE_DIRS} ${GEE_INCLUDE_DIRS})
set(DEPS_CFLAGS_OTHER ${GTK3_CFLAGS_OTHER} ${GEE_CFLAGS_OTHER})

add_library(gtkmusic SHARED ${VALA_C_LIBGTKMUSIC})
set_target_properties(gtkmusic PROPERTIES SOVERSION ${SOVERSION})
set_target_properties(gtkmusic PROPERTIES VERSION ${VERSION})
target_link_libraries(gtkmusic ${DEPS_LIBRARIES})
target_include_directories(gtkmusic PUBLIC ${DEPS_INCLUDE_DIRS})
target_compile_options(gtkmusic PUBLIC ${DEPS_CFLAGS_OTHER})

add_library(gtkmusic_static STATIC ${VALA_C_LIBGTKMUSIC})
target_link_libraries(gtkmusic_static ${DEPS_LIBRARIES})
target_include_directories(gtkmusic_static PUBLIC ${DEPS_INCLUDE_DIRS})
target_compile_options(gtkmusic_static PUBLIC ${DEPS_CFLAGS_OTHER})

install(FILES ${CMAKE_BINARY_DIR}/gtkmusic.pc
        DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig)
install(TARGETS gtkmusic gtkmusic_static 
        LIBRARY DESTINATION lib 
                PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE 
                            GROUP_READ GROUP_EXECUTE
                            WORLD_READ WORLD_EXECUTE
        ARCHIVE DESTINATION lib/static)
install(FILES ${CMAKE_BINARY_DIR}/gtkmusic.h
        DESTINATION include/gtkmusic-${VERSION})


# =============================================================================
# GObject Introspection
# =============================================================================

option(CREATE_GIR "Whether to create GObject Introspection Files" 
       ${INTROSPECTION_FOUND})

if(CREATE_GIR)

if(INTROSPECTION_FOUND)
    add_custom_command(
        TARGET gtkmusic
        POST_BUILD
        COMMAND ${INTROSPECTION_COMPILER} 
                -o ${TYPELIB_FILE} ${GIR_FILE}
        COMMENT "Creating GObject Introspection files"
    )
    
    install(FILES ${CMAKE_BINARY_DIR}/${GIR_FILE} 
            DESTINATION ${INTROSPECTION_GIRDIR})
    install(FILES ${CMAKE_BINARY_DIR}/${TYPELIB_FILE} 
            DESTINATION ${INTROSPECTION_TYPELIBDIR})
    
else(INTROSPECTION_FOUND)
message(WARNING "\
pkg-config cannot find gobject-introspection. \
If you're running a Debian based distribution, please install packages \
libgirepository1.0-dev and gobject-instrospection")
endif(INTROSPECTION_FOUND)

endif(CREATE_GIR)

# =============================================================================
# Glade Catalog
# =============================================================================

option(CREATE_GLADE_CATALOG "Whether to add widgets to Glade designer"
       ${GLADEUI_FOUND})
if(CREATE_GLADE_CATALOG)
    install(FILES ${CMAKE_SOURCE_DIR}/glade/gtkmusic-catalog.xml 
            DESTINATION ${GLADEUI_CATALOGDIR} )
    install(DIRECTORY ${CMAKE_SOURCE_DIR}/glade/icons/ 
            DESTINATION ${GLADEUI_PIXMAPDIR} )
    if(XMLLINT_FOUND)
    add_custom_target(validate_catalog
                      COMMAND ${XMLLINT_EXECUTABLE} --dtdvalid 
                      ${GLADEUI_CATALOGDIR}/glade-catalog.dtd 
                      --noout ${CMAKE_SOURCE_DIR}/glade/gtkmusic-catalog.xml)
    endif(XMLLINT_FOUND)
endif(CREATE_GLADE_CATALOG)


# =============================================================================
# Test utilities
# =============================================================================

option(BUILD_TESTS "Whether to build test applications" YES)
if(BUILD_TESTS)
vala_precompile(VALA_C_GUITAR_TEST test/TestsGuitar.vala
                PACKAGES           gtk+-3.0 gee-0.8 posix
                CUSTOM_VAPIS       ${CMAKE_BINARY_DIR}/${VAPI_FILE})

add_executable(tests_guitar ${VALA_C_GUITAR_TEST})
target_link_libraries(tests_guitar gtkmusic)
target_link_libraries(tests_guitar ${GTK3_LIBRARIES} ${GEE_LIBRARIES})
target_include_directories(tests_guitar PUBLIC ${GTK3_INCLUDE_DIRS} ${GEE_INCLUDE_DIRS})
target_compile_options(tests_guitar PUBLIC ${GTK3_CFLAGS_OTHER} ${GEE_CFLAGS_OTHER})


vala_precompile(VALA_C_PIANO_TEST test/TestsPiano.vala
                PACKAGES           gtk+-3.0 gee-0.8 posix
                CUSTOM_VAPIS       ${CMAKE_BINARY_DIR}/${VAPI_FILE})

add_executable(tests_piano ${VALA_C_PIANO_TEST})
target_link_libraries(tests_piano gtkmusic)
target_link_libraries(tests_piano ${GTK3_LIBRARIES} ${GEE_LIBRARIES})
target_include_directories(tests_piano PUBLIC ${GTK3_INCLUDE_DIRS} ${GEE_INCLUDE_DIRS})
target_compile_options(tests_piano PUBLIC ${GTK3_CFLAGS_OTHER} ${GEE_CFLAGS_OTHER})

vala_precompile(VALA_C_NOTES_TEST test/TestsMusicalNotes.vala
                PACKAGES           gtk+-3.0 gee-0.8 posix
                CUSTOM_VAPIS       ${CMAKE_BINARY_DIR}/${VAPI_FILE})

add_executable(tests_notes ${VALA_C_NOTES_TEST})
target_link_libraries(tests_notes gtkmusic)
target_link_libraries(tests_notes ${GTK3_LIBRARIES} ${GEE_LIBRARIES})
target_include_directories(tests_notes PUBLIC ${GTK3_INCLUDE_DIRS} ${GEE_INCLUDE_DIRS})
target_compile_options(tests_notes PUBLIC ${GTK3_CFLAGS_OTHER} ${GEE_CFLAGS_OTHER})

endif(BUILD_TESTS)

# =============================================================================
# GIT Integration
# =============================================================================

if(GIT_FOUND AND EXISTS ${CMAKE_SOURCE_DIR}/.git)
exec_program(${GIT_EXECUTABLE} ARGS "rev-list HEAD --count" 
             OUTPUT_VARIABLE GIT_COMMAND)
string(STRIP ${GIT_COMMAND} GIT_REVISION)             
endif(GIT_FOUND AND EXISTS ${CMAKE_SOURCE_DIR}/.git)

# =============================================================================
# Build Configuration Overview
# =============================================================================

FEATURE_SUMMARY(WHAT ALL) 

message("")
message("------------------------------------------------------------------")
message("Features:")
message("------------------------------------------------------------------")
message("Main Library        ON (always)")
message("GI Typelib          ${CREATE_GIR}")
message("Glade Catalog       ${CREATE_GLADE_CATALOG}")
message("Executables (Tests) ${BUILD_TESTS}")
message("Documentation       OFF")
message("------------------------------------------------------------------")
message("")
