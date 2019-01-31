include_guard(GLOBAL)

include(CheckIncludeFiles)

function (ixm_check_common_symbol variable name)
  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  get_property(arghash CACHE ${variable}_ARGHASH PROPERTY VALUE)

  string(SHA1 current-arghash "${variable} ${name} ${ARGN}")

  if (arghash STREQUAL current-arghash AND is-found)
    return()
  endif()

  unset(${variable} CACHE)
  set(${variable}_ARGHASH ${current-arghash} CACHE INTERNAL "${variable} hash")

  list(APPEND args INCLUDE_DIRECTORIES)
  list(APPEND args COMPILE_DEFINITIONS)
  list(APPEND args COMPILE_FEATURES)
  list(APPEND args COMPILE_OPTIONS)
  list(APPEND args LINK_DIRECTORIES)
  list(APPEND args LINK_LIBRARIES)
  list(APPEND args LINK_OPTIONS)

  parse(${ARGN}
    @FLAGS QUIET REQUIRED
    @ARGS=? LANGUAGE TARGET_TYPE
    @ARGS=* CONTENT EXTRA_CMAKE_FLAGS INCLUDE_HEADERS ${args})

  # If no LANGUAGE is given, we assume CXX
  var(TARGET_TYPE TARGET_TYPE STATIC)
  var(LANGUAGE LANGUAGE CXX)

  string(TOLOWER ${variable} project)
  string(REPLACE "_" "-" project ${project})
  set(BUILD_ROOT "${CMAKE_BINARY_DIR}/IXM/Check/Symbols/${project}")

  list(INSERT EXTRA_CMAKE_FLAGS 0
    "CMAKE_${LANGUAGE}_COMPILER:FILEPATH=${CMAKE_${LANGUAGE}_COMPILER}"
    "TARGET_TYPE:STRING=${TARGET_TYPE}"
    "VERSION:STRING=${CMAKE_VERSION}"
    "LANGUAGE:STRING=${LANGUAGE}"
    "NAME:STRING=${project}")

  list(TRANSFORM EXTRA_CMAKE_FLAGS PREPEND "-D")
  list(APPEND cmake-flags ${EXTRA_CMAKE_FLAGS})

  foreach (arg IN LISTS args ITEMS CMAKE_${LANGUAGE}_COMPILER_LAUNCHER)
    if (DEFINED ${arg})
      list(APPEND cmake-flags "-D${arg}:STRING=${${arg}}")
    endif()
  endforeach()

  # Configure content for headers
  # TODO: Use our *own* check(INCLUDE) when it's available
  if (INCLUDE_HEADERS)
    cmake_push_check_state()
    set(CMAKE_REQUIRED_DEFINITIONS ${COMPILE_DEFINITIONS})
    set(CMAKE_REQUIRED_INCLUDES ${INCLUDE_DIRECTORIES})
    set(CMAKE_REQUIRED_FLAGS ${COMPILE_OPTIONS})
    set(CMAKE_REQUIRED_QUIET ${QUIET})
    check_include_files("${INCLUDE_HEADERS}"
      ${variable}_INCLUDE_HEADERS
      LANGUAGE ${LANGUAGE})
    cmake_pop_check_state()
  endif()


  list(TRANSFORM INCLUDE_HEADERS REPLACE "(.+)" "#include <\\1>")
  list(JOIN INCLUDE_HEADERS "\n" IXM_CHECK_PREAMBLE)
  string(CONFIGURE "${CONTENT}" IXM_CHECK_CONTENT @ONLY)

  configure_file(
    "${IXM_ROOT}/Templates/Check/CMakeLists.txt"
    "${BUILD_ROOT}/CMakeLists.txt"
    COPYONLY)
  configure_file(
    "${IXM_ROOT}/Templates/Check/main.cxx.in"
    "${BUILD_ROOT}/main.cxx"
    @ONLY)

  if (NOT QUIET)
    info("Looking for ${name}")
  endif()

  try_compile(${variable}
    "${BUILD_ROOT}/build"
    "${BUILD_ROOT}"
    "${project}"
    CMAKE_FLAGS ${cmake-flags}
    OUTPUT_VARIABLE output)

  set(logfile "CMakeOutput.log")
  set(status "passed")
  set(found "found")

  if (NOT ${variable})
    set(logfile "CMakeError.log")
    set(status "failed")
    set(found "not found")
  endif()

  set(${variable} ${${variable}} CACHE INTERNAL "Have ${name}")
  file(APPEND "${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/${logfile}"
    "Determining if '${name}' exists ${status} with the following output:\n"
    "${output}")

  set(result "Looking for ${name} - ${found}")
  if (REQUIRED AND NOT ${variable})
    error("${result}")
  elseif(NOT QUIET AND ${variable})
    info("${result}")
  endif()
endfunction()
