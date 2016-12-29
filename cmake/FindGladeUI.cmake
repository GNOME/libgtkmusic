# Module FindGladeUI - Try to find gladeui
#
# Output variables
#  GLADEUI_FOUND - system has gladeui
#  GLADEUI_CATALOGDIR
#  GLADEUI_PIXMAPDIR
#  GLADEUI_MODULEDIR
#
# Based on webkit's FindGObjectIntrospection.cmake
# Copyright (C) 2010, Pino Toscano, <pino@kde.org>
# Copyright (C) 2014 Igalia S.L.
#
# Copyright (C) 2016, Leandro Resende Mattioli, <leandro.mattioli@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.

macro(_GET_PKGCONFIG_VAR _outvar _varname _pkg)
    execute_process(
        COMMAND ${PKG_CONFIG_EXECUTABLE} 
                --variable=${_varname} ${_extra_args} ${_pkg}
        OUTPUT_VARIABLE _result
        RESULT_VARIABLE _null
    )
    if (_null)
    else ()
        string(REGEX REPLACE "[\r\n]" " " _result "${_result}")
        string(REGEX REPLACE " +$" ""  _result "${_result}")
        separate_arguments(_result)
        set(${_outvar} ${_result} CACHE INTERNAL "")
    endif ()
endmacro(_GET_PKGCONFIG_VAR)

find_package(PkgConfig)
if (PKG_CONFIG_FOUND)
    pkg_check_modules(_pc_gladeui gladeui-2.0)
    if (_pc_gladeui_FOUND)
        set(GLADEUI_FOUND TRUE)
        _get_pkgconfig_var(GLADEUI_CATALOGDIR "catalogdir" "gladeui-2.0")
        _get_pkgconfig_var(GLADEUI_PIXMAPDIR "pixmapdir" "gladeui-2.0")
        _get_pkgconfig_var(GLADEUI_MODULEDIR "moduledir" "gladeui-2.0")
    endif ()
endif ()

mark_as_advanced(
    GLADEUI_CATALOGDIR
    GLADEUI_PIXMAPDIR
    GLADEUI_MODULEDIR
)
