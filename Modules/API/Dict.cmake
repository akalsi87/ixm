include_guard(GLOBAL)

import(IXM::Dict::*)

function (dict subcommand name)
  if (subcommand STREQUAL "LOAD")
    ixm_dict_load(${name} ${ARGN})
  elseif (subcommand STREQUAL "SAVE")
    ixm_dict_save(${name} ${ARGN})
  elseif (subcommand STREQUAL "JSON")
    ixm_dict_json(${name} ${ARGN})
  elseif (subcommand STREQUAL "TRANSFORM")
    ixm_dict_transform(${name} ${ARGN})
    # A bit hackish, but we don't want to waste calling `parse()`
    cmake_parse_arguments("" "" "OUTPUT_VARIABLE" "" ${ARGN})
    if (_OUTPUT_VARIABLE)
      set(${_OUTPUT_VARIABLE} ${${_OUTPUT_VARIABLE}} PARENT_SCOPE)
    endif()
  elseif (subcommand STREQUAL "APPEND")
    ixm_dict_append(${name} ${ARGN})
  elseif (subcommand STREQUAL "ASSIGN")
    ixm_dict_assign(${name} ${ARGN})
  elseif (subcommand STREQUAL "CONCAT")
    ixm_dict_concat(${name} ${ARGN})
  elseif (subcommand STREQUAL "REMOVE")
    ixm_dict_remove(${name} ${ARGN})
  elseif (subcommand STREQUAL "CLEAR")
    ixm_dict_clear(${name} ${ARGN})
  elseif (subcommand STREQUAL "KEYS")
    ixm_dict_keys(${name} ${ARGN})
  elseif (subcommand STREQUAL "GET")
    ixm_dict_get(${name} ${ARGN})
  else()
    log(FATAL "dict(${subcommand}) is an invalid operation")
  endif()
  if (subcommand STREQUAL "KEYS" OR subcommand STREQUAL "GET")
    list(GET ARGN -1 @result)
    set(${\@result} ${${\@result}} PARENT_SCOPE)
  endif()
endfunction()