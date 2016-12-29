find_program(XMLLINT_EXECUTABLE xmllint DOC "XML validation tool")
mark_as_advanced(XMLLINT_EXECUTABLE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    XMLLINT 
    DEFAULT_MSG 
    XMLLINT_EXECUTABLE
)
