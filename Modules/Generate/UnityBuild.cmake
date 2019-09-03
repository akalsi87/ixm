include_guard(GLOBAL)

function (ixm_generate_unity_source target)
  parse(${ARGN} @ARGS=? LANGUAGE)
  assign(LANGUAGE ? LANGUAGE : CXX)

  genexp(ifc-unity-sources $<TARGET_PROPERTY:${target},INTERFACE_UNITY_SOURCES>)
  genexp(unity-sources $<TARGET_PROPERTY:${target},UNITY_SOURCES>)

  genexp(ifc-unity-sources $<
    $<BOOL:${ifc-unity-sources}>:
    "#include <"
    $<JOIN:${ifc-unity-sources},
      "$<ANGLE-R>\n#include<>"
    >
  >)

  genexp(unity-sources $<
    $<BOOL:${unity-sources}>:
    "#include <"
    $<JOIN:${unity-sources},
      "$<ANGLE-R>\n#include<>"
    >
  >)

  genexp(sources $<IF:
    $<STREQUAL:$<TARGET_PROPERTY:${target},TYPE>,INTERFACE_LIBRARY>,
    ${ifc-unity-sources},
    ${unity-sources}
  >)

  genexp(ifc-unity-build $<IF:
    $<BOOL:$<TARGET_PROPERTY:${target},INTERFACE_UNITY_BUILD_FILE>>,
    $<TARGET_PROPERTY:${target},INTERFACE_UNITY_BUILD_FILE>,
    "${CMAKE_CURRENT_BINARY_DIR}/IXM/Unity/${target}.$<LOWER_CASE:${LANGUAGE}>"
  >)

  genexp(unity-build $<IF:
    $<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD_FILE>>,
    $<TARGET_PROPERTY:${target},UNITY_BUILD_FILE>,
    "${CMAKE_CURRENT_BINARY_DIR}/IXM/Unity/${target}.$<LOWER_CASE:${LANGUAGE}>"
  >)

  genexp(unity-build $<IF:
    $<STREQUAL:$<TARGET_PROPERTY:${target},TYPE>,INTERFACE_LIBRARY>,
    ${ifc-unity-build},
    ${unity-build}
  >)

  string(JOIN "\n" content
    "/* GENERATED BY IXM. DO NOT EDIT */"
    ${unity-sources})

  file(GENERATE
    OUTPUT "${unity-file}"
    CONTENT "${content}"
    CONDITION $<BOOL:$<TARGET_PROPERTY:${target},UNITY_BUILD>>)
endfunction()
