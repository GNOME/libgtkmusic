# ============================================================================
# General
# ============================================================================
project('libgtkmusic', ['vala', 'c'],
         version: '0.6',
         meson_version: '>= 0.44.0')

author_name = 'Leandro Resende Mattioli'
author_email = 'leandro.mattioli@gmail.com'
version = meson.project_version()
version_major = version.split('.')[0]
version_minor = version.split('.')[1]
source_dir = meson.source_root()
build_dir = meson.current_build_dir()

# =============================================================================
# GIT Integration
# =============================================================================
git = find_program('git')
if git.found()
    git_version = run_command([git, 'rev-list', 'HEAD', '--count'])
    if git_version.stderr().strip() == ''
        git_version = git_version.stdout().strip()
        message('Git version: ' + git_version)
    endif
endif

# ============================================================================
# Configuration
# ============================================================================
conf_data = configuration_data()
conf_data.set('author_name', author_name)
conf_data.set('author_email', author_email)
conf_data.set('author_contact', author_name + '<' + author_email + '>')
conf_data.set('project_url', 'https://gitlab.gnome.org/GNOME/libgtkmusic')
conf_data.set('version_major', version_major)
conf_data.set('version_minor', version_minor)
conf_data.set('version', version)         # Build Version
conf_data.set('soversion', version_major) # API Version
conf_data.set('gitversion', git_version)  # Git version
conf_data.set('install_prefix', get_option('prefix'))

configure_file(input : 'gtkmusic.pc.in',
               output : 'gtkmusic.pc',
               configuration : conf_data,
               install_dir : join_paths(get_option('libdir'), 'pkgconfig'))


# ============================================================================
# Filenames
# ============================================================================
asset_template = 'GtkMusic-@0@.@1@'
gir_file = asset_template.format(version,'gir')
typelib_file = asset_template.format(version, 'typelib')
vapi_file = asset_template.format(version, 'vapi').to_lower()
glade_catalog_file = 'gtkmusic-catalog.xml'


# ============================================================================
# Math
# ============================================================================
cc = meson.get_compiler('c')
m_dep = cc.find_library('m', required : true)


# ============================================================================
# Library
# ============================================================================
deps = [
    dependency('gtk+-3.0'),
    dependency('gee-0.8'),
    meson.get_compiler('vala').find_library('posix'),
    m_dep
]
sources = [
    'src/GuitarWidget.vala', 
    'src/MusicalNotes.vala', 
    'src/PianoWidget.vala'
]
header_dir = 'include/gtkmusic-'+version
libgtkmusic = library('gtkmusic', sources,
                        vala_gir: gir_file,
                        vala_vapi: vapi_file,
                        dependencies: deps,
                        version: version,
                        install: true,
                        install_dir: [true, header_dir, true, true]
)


# ============================================================================
# GObject Introspection: Typelib
# ============================================================================
if get_option('typelib')
    g_ir_compiler = find_program('g-ir-compiler', required: false)
    if g_ir_compiler.found()
        enable_typelib = true
        custom_target('gtkmusic typelib', 
            command: [
                g_ir_compiler, '--shared-library', 'libgtkmusic.so', # small hack
                '--output', '@OUTPUT@', join_paths(build_dir, gir_file)],
            output: typelib_file,
            depends: libgtkmusic,
            install: true,
            install_dir: join_paths(get_option('libdir'), 'girepository-1.0'))
    else
        enable_typelib = false
        warning('GIR Compiler not found! Skipping Typelib creation.')
    endif
else
    enable_typelib = false
endif


# ============================================================================
# Glade Catalog
# ============================================================================
if get_option('glade') # and libgladeui found
    glade_dep = dependency('gladeui-2.0', required: false)
    query_template = 'pkg-config --variable=@0@ gladeui-2.0'
    cmd_catalog_dir = query_template.format('catalogdir')
    cmd_pixmap_dir = query_template.format('pixmapdir')
    glade_catalog_dir = run_command(cmd_catalog_dir.split()).stdout().strip()
    glade_pixmap_dir = run_command(cmd_pixmap_dir.split()).stdout().strip()
    dtd_path = join_paths(glade_catalog_dir, 'glade-catalog.dtd')
    xml_path = join_paths(source_dir, 'glade', glade_catalog_file) 
    pixmaps_path = join_paths(source_dir, 'glade', 'icons')
    if glade_dep.found()
        enable_glade = true
        xmllint = find_program('xmllint', required: false)
        if xmllint.found()
            message('Validating catalog XML with XML Lint.')
            validation = run_command([xmllint, 
                '--dtdvalid', dtd_path, 
                '--noout', xml_path])
            if validation.stderr().strip() != ''
                error('Invalid XML file found!')
            endif
        else
            warning('XMLLint not found. Skipping Glade catalog validation.')
        endif
        install_data(xml_path, install_dir: glade_catalog_dir)
        install_subdir(pixmaps_path, install_dir: glade_pixmap_dir,
                       strip_directory: true)
    else
        enable_glade = false
        warning('GladeUI not found. Skipping Glade Catalog creation.')
    endif
else
    enable_glade = false
endif

# ============================================================================
# Tests
# ============================================================================
if get_option('tests')
    tests_guitar = executable('tests_guitar', 'test/TestsGuitar.vala',
        link_with: libgtkmusic,
        dependencies: deps,
        install: false
    )
    tests_piano = executable('tests_piano', 'test/TestsPiano.vala',
        link_with: libgtkmusic,
        dependencies: deps,
        install: false
    )
    tests_notes = executable('tests_notes', 'test/TestsMusicalNotes.vala',
        link_with: libgtkmusic,
        dependencies: deps,
        install: false
    )
endif


# ============================================================================
# Valadoc
# ============================================================================
if get_option('doc')
    valadoc = find_program('valadoc', required: false)
    if valadoc.found()
        enable_doc = true
        base_dir = join_paths(source_dir, 'src')
        output_dir = join_paths(build_dir, 'doc')
        vala_files = []
        foreach src : sources
            vala_files += [join_paths(source_dir, src)]
        endforeach
        custom_target('doc', 
            command: [
                valadoc, '--force', '--doclet=devhelp', 
                '--package-name=gtkmusic', '--package-version='+version,
                '-b', base_dir, '-o', output_dir,
                '--pkg', 'gee-0.8', '--pkg', 'gtk+-3.0', '--pkg', 'cairo',
                '--pkg', 'gdk-3.0'] + vala_files,
            output: 'doc',
            build_by_default: true
        )
        doc_source_dir = join_paths(build_dir, 'doc', 'gtkmusic')
        doc_target_dir = join_paths('share', 'gtk-doc', 'html', 'gtkmusic')
        install_subdir(doc_source_dir, 
            install_dir: doc_target_dir, 
            strip_directory: true)
    else
        enable_doc = false
        warning('Valadoc not found. Skipping HTML API reference creation.')
    endif
else
    enable_doc = false
endif


# ============================================================================
# Console Summary
# ============================================================================
output_template = '''
------------------------------------------------------------------
Features:
------------------------------------------------------------------
Main Library        ON (always)
GI Typelib          @0@
Glade Catalog       @1@
Executables (Tests) @2@
Documentation       @3@
------------------------------------------------------------------
'''
output = output_template.format(
    enable_typelib, 
    enable_glade, 
    get_option('tests'), 
    enable_doc
)
message(output)
