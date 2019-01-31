include_guard(GLOBAL)

find_package(Sphinx)

function (target_sources_rst target visibility)
  set(interface PUBLIC;INTERFACE)
  set(private PRIVATE;PUBLIC)
  if (visibility IN_LIST interface)
    set_property(TARGET ${target} APPEND
      PROPERTY
        INTERFACE_SPHINX_SOURCES "${ARGN}")
  endif()
  if (visibility IN_LIST private)
    set_property(TARGET ${target} APPEND
      PROPERTY
        SPHINX_SOURCES "${ARGN}")
  endif()
endfunction()

#[[ TODO: Some verification of use is still needed ]]
function (add_documentation name type)
  set(possible HTML EPUB MAN LATEX JSON XML)
  if (NOT TARGET Python::Sphinx)
    error("Cannot create documentation target without Sphinx")
  endif()
  if (${type} NOT IN_LIST possible)
    error("add_documentation takes one of: ${possible}")
  endif()
  add_custom_target(${name}-documentation)
  set_target_properties(${name}
    PROPERTIES
      SPHINX_DOCTREES_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/doctrees/${type}
      SPHINX_BUILDER_TYPE ${type}
      BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/${type}
      SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  genex(COMPILE_DEFINITIONS $<
    $<BOOL:$<TARGET_PROPERTY:${name},INTERFACE_COMPILE_DEFINITIONS>>:
    -D$<JOIN:
        $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_DEFINITIONS>,
        $<SEMICOLON>-D
      >
  >)
  genex(COMPILE_OPTIONS $<
    $<BOOL:$<TARGET_PROPERTY:${name},COMPILE_OPTIONS>>:
    $<JOIN:$<TARGET_PROPERTY:${name},COMPILE_OPTIONS>,$<SEMICOLON>>
  >)
  genex(SOURCES $<
    $<BOOL:$<TARGET_PROPERTY:${name},SPHINX_SOURCES>>:
    $<TARGET_PROPERTY:${name}:SPHINX_SOURCES>
  >)
  set(SOURCEDIR $<TARGET_PROPERTY:${name},SOURCE_DIR>)
  set(BINARYDIR $<TARGET_PROPERTY:${name},BINARY_DIR>)
  set(OUTPUTS $<TARGET_PROPERTY:${name},SPHINX_${type}_OUTPUTS>)

  add_custom_command(
    COMMAND Python::Sphinx
      -b $<LOWER_CASE:${type}>
      -d $<TARGET_PROPERTY:${name},SPHINX_DOCTREES_DIR>
      ${COMPILE_DEFINITIONS}
      ${COMPILE_OPTIONS}
      ${SOURCEDIR}
      ${BINARYDIR}
      ${SOURCES}
    MAIN_DEPENDENCY $<TARGET_PROPERTY:${name},SPHINX_CONFIG>
    DEPENDS ${SOURCES}
    OUTPUT ${OUTPUTS}
    COMMAND_EXPAND_LISTS
    USES_TERMINAL
    VERBATIM)
  add_custom_target(${PROJECT_NAME}-sphinx-build-${name}
    DEPENDS $<TARGET_PROPERTY:${name},SPHINX_${type}_OUTPUTS>
    SOURCES $<TARGET_PROPERTY:${name},SOURCES>)
endfunction()