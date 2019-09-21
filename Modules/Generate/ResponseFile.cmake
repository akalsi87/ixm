include_guard(GLOBAL)

function (ixm_generate_response_file target)
  parse(${ARGN} @ARGS=? LANGUAGE)
  assign(LANGUAGE ? LANGUAGE : CXX)

  ixm_generate_response_file_genexp(include-directories ${target}
    PROPERTY INCLUDE_DIRECTORIES
    PREFIX -I)
  ixm_generate_response_file_genexp(compile-definitions ${target}
    PROPERTY COMPILE_DEFINITIONS
    PREFIX -D)
  ixm_generate_response_file_genexp(compile-options ${target}
    PROPERTY COMPILE_OPTIONS)

  list(APPEND compile-flags ${include-directories})
  list(APPEND compile-flags ${compile-definitions})
  list(APPEND compile-flags ${compile-options})

  genexp(release-flags $<$<CONFIG:Release>:${CMAKE_${LANGUAGE}_FLAGS_RELEASE}>)
  genexp(debug-flags $<$<CONFIG:Debug>:${CMAKE_${LANGUAGE}_FLAGS_DEBUG}>)
  genexp(flags $<$<COMPILE_LANGUAGE:${LANGUAGE}>:${CMAKE_${LANGUAGE}_FLAGS}>)

  list(APPEND compile-flags ${release-flags})
  list(APPEND compile-flags ${debug-flags})
  list(APPEND compile-flags ${flags})

  genexp(content $<JOIN:${compile-flags},\\n>)
  #TODO: See if this can be pushed into the genexp part as well
  #string(JOIN "\n" content
  #  ${compile-flags}
  #  ${release-flags}
  #  ${debug-flags}
  #  ${flags})

  ixm_generate_response_file_path(response-file ${target})

  file(GENERATE OUTPUT ${response-file} CONTENT ${content})
endfunction()

function (ixm_generate_response_file_path out-var target)
  aspect(GET path:generate AS directory)
  set(default-path "${directory}/${target}.rsp")

  genexp(ifc-response-file $<IF:
    $<BOOL:$<TARGET_PROPERTY:${target},INTERFACE_RESPONSE_FILE>>,
    $<TARGET_PROPERTY:${target},INTERFACE_RESPONSE_FILE>,
    "${default-path}"
  >)
  genexp(response-file $<IF:
    $<BOOL:$<TARGET_PROPERTY:${target},RESPONSE_FILE>>,
    $<TARGET_PROPERTY:${target},RESPONSE_FILE>,
    "${default-path}"
  >)

  genexp(path $<IF:
    $<STREQUAL:$<TARGET_PROPERTY:${target},TYPE>,INTERFACE_LIBRARY>,
    ${ifc-response-file},
    ${response-file}
  >)

  set(${out-var} ${path} PARENT_SCOPE)
endfunction()

function (ixm_generate_response_file_genexp out-var target)
  parse(${ARGN}
    @ARGS=1 PROPERTY
    @ARGS=? PREFIX)

  assign(PREFIX ? PREFIX : "")

  set(ifc $<TARGET_PROPERTY:${target},INTERFACE_${PROPERTY}>)
  set(val $<TARGET_PROPERTY:${target},${PROPERTY}>)

  genexp(ifc $<$<BOOL:${ifc}>:${PREFIX}$<JOIN:${ifc},\n${PREFIX}>\n>)
  genexp(val $<$<BOOL:${val}>:${PREFIX}$<JOIN:${val},\n${PREFIX}>\n>)

  genexp(expression $<IF:
    $<STREQUAL:$<TARGET_PROPERTY:${target},TYPE>,INTERFACE_LIBRARY>,
    ${ifc},
    ${val}
  >)
  set(${out-var} "${expression}" PARENT_SCOPE)
endfunction()
