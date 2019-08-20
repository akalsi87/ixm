include_guard(GLOBAL)

function (ixm_fetch_common_preacquire)
endfunction()

#[[ Sets all options in a key-value pair system ]]
function (ixm_fetch_common_options)
  set(options ${ARGN})
  if (NOT options)
    return()
  endif()
  list(LENGTH options length)
  math(EXPR length "${length} - 1")
  foreach (begin RANGE 0 ${length} 2)
    list(SUBLIST options ${begin} 2 kv)
    list(GET kv 0 key)
    list(GET kv 1 val)
    set(${key} ${val} PARENT_SCOPE)
  endforeach()
endfunction()

#[[ Status Print ]]
function (ixm_fetch_common_status recipe)
  if (NOT QUIET OR NOT IXM_FETCH_QUIET)
    log(INFO "${recipe}")
    if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16 AND NOT IXM_FETCH_NO_INDENT)
      set(CMAKE_MESSAGE_INDENT "${recipe}: ")
    endif()
  endif()
endfunction()

#[[ Argument Conflict Check ]]
function (ixm_fetch_common_check_target)
  if (DEFINED TARGETS AND DEFINED TARGET)
    log(FATAL "Cannot pass both TARGET and TARGETS")
  endif()
endfunction()

function (ixm_fetch_common_exclude)
  set(EXCLUDE EXCLUDE_FROM_ALL PARENT_SCOPE)
  if (NOEXCLUDE)
    unset(EXCLUDE PARENT_SCOPE)
  endif()
  set(EXCLUDE_FROM_ALL EXCLUDE_FROM_ALL PARENT_SCOPE)
endfunction()

function (ixm_fetch_common_download alias)
  FetchContent_Declare(${alias} ${ARGN})
  FetchContent_GetProperties(${alias})
  if (NOT ${alias}_POPULATED)
    FetchContent_Populate(${alias})
  endif()
  set(${alias}_SOURCE_DIR ${${alias}_SOURCE_DIR} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${${alias}_BINARY_DIR} PARENT_SCOPE)
endfunction()

#[[ Copies possible patch files for overrides ]]
function (ixm_fetch_common_patch alias)
  set(src "${${alias}_SOURCE_DIR}/CMakeLists.txt")
  list(APPEND patches "${PATCH}")
  list(APPEND patches "${PROJECT_SOURCE_DIR}/.cmake/patch/${alias}.cmake")
  list(APPEND patches "${PROJECT_SOURCE_DIR}/.cmake/${alias}.cmake")
  list(APPEND patches "${PROJECT_SOURCE_DIR}/cmake/patch/${alias}.cmake")
  list(APPEND patches "${PROJECT_SOURCE_DIR}/cmake/${alias}.cmake")
  list(APPEND patches "${CMAKE_SOURCE_DIR}/.cmake/patch/${alias}.cmake")
  list(APPEND patches "${CMAKE_SOURCE_DIR}/.cmake/${alias}.cmake")
  list(APPEND patches "${CMAKE_SOURCE_DIR}/cmake/patch/${alias}.cmake")
  list(APPEND patches "${CMAKE_SOURCE_DIR}/cmake/${alias}.cmake")
  if (EXISTS ${src} AND NOT DEFINED PATCH)
    return()
  endif()
  foreach (file IN LISTS patches)
    if (EXISTS ${file})
      set(patch ${file})
      break()
    endif()
  endforeach()
  if (NOT DEFINED patch)
    log(FATAL "Could not locate patch file for '${alias}'")
  endif()
  log(INFO "PATCH: ${alias} with ${patch}")
  configure_file(${patch} ${src} COPYONLY)
endfunction()

#[[ Create target aliases if necessary ]]
function(ixm_fetch_common_target target alias)
  if (DEFINED TARGETS)
    add_library(${target} INTERFACE)
    target_link_libraries(${target} INTERFACE ${TARGETS})
  endif()
  if (NOT TARGET ${target})
    log(FATAL "'${target}' is not a valid TARGET")
  endif()
  if (NOT TARGET ${alias}::${alias})
    add_library(${alias}::${alias} ALIAS ${target})
  endif()
  # Used for bookkeeping
  foreach (target IN LISTS TARGETS)
    if (NOT TARGET ${alias}::${target})
      add_library(${alias}::${target} ALIAS ${target})
    endif()
  endforeach()
endfunction()

#[[ Sets all policies in a key-value pair system ]]
function (ixm_fetch_common_policies)
  set(policies ${ARGN})
  if (NOT policies)
    return()
  endif()
  list(LENGTH settings length)
  math(EXPR length "${length} - 1")
  foreach(begin RANGE 0 ${length} 2)
    list(SUBLIST policies ${begin} 2 kv)
    list(GET kv 0 key)
    list(GET kv 1 value)
  endforeach()
endfunction()
