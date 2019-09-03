include_guard(GLOBAL)

macro (ixm_dict_noop name)
  if (NOT TARGET ${name})
    return()
  endif()
endmacro()

function (ixm_dict_create name)
  if (NOT TARGET ${name})
    add_library(${name} INTERFACE IMPORTED)
  endif()
endfunction()

function (ixm_dict_filepath out path ext)
  if (NOT path MATCHES ".+[.]${ext}$")
    set(path "${path}.${ext}")
  endif()
  if (NOT IS_ABSOLUTE "${path}")
    # TODO: This needs to be made "safer" with get_filename_component(ABSOLUTE)
    set(path "${CMAKE_CURRENT_BINARY_DIR}/${path}")
  endif()
  set(${out} "${path}" PARENT_SCOPE)
endfunction()

function (ixm_dict_how var message)
  list(LENGTH ARGN length)
  if (NOT length)
    log(FATAL "${message}")
  endif()
  set(valid APPEND ASSIGN CONCAT)
  list(GET ARGN 0 possible)
  if (NOT possible IN_LIST valid)
    unset(${var} PARENT_SCOPE)
    return()
  endif()
  list(REMOVE_AT ARGN 0)
  set(ARGN ${ARGN} PARENT_SCOPE)
  # The logic for this is HELLA messed up.
  # If the order for this is changed, be
  # prepared for things to *randomly* break...
  # (As much of a CMake witch I am, I do not understand why
  # it acts this way...)
  if (possible STREQUAL "CONCAT")
    set(possible APPEND_STRING)
  elseif (possible STREQUAL "ASSIGN")
    set(possible)
  elseif (possible STREQUAL "APPEND")
    # This clause needs to be empty
  else ()
    set(possible)
  endif()
  set(${var} ${possible} PARENT_SCOPE)
endfunction()

# XXX: The file format needs to be adjusted.
function (ixm_dict_load name)
  parse(${ARGN} @ARGS=1 FROM)
  ixm_dict_create(${name})
  if (NOT FROM)
    log(FATAL "dict(LOAD) missing 'FROM' parameter")
  endif()
  ixm_dict_filepath(FROM "${FROM}" "ixm")
  if (NOT EXISTS "${FROM}")
    return()
  endif()
  file(READ "${FROM}" data)
  string(ASCII 2 STX)
  string(ASCII 3 ETX)
  string(ASCII 25 EM)
  set(HEADER "${STX}IXM${ETX}${STX}([^${ETX}]+)${ETX}${EM}")
  string(REGEX MATCH "^${HEADER}\n(.*)$" matched "${data}")
  if (NOT matched)
    log(FATAL "Could not read IXM file format from ${FROM}")
  endif()
  set(data "${CMAKE_MATCH_2}")
  string(ASCII 29 group)
  string(ASCII 30 record)
  string(ASCII 31 unit)
  string(REPLACE "${group}" ";" data "${data}")
  foreach (entry IN LISTS data)
    string(REPLACE "${record}" ";" entry "${entry}")
    list(GET entry 0 key)
    list(GET entry 1 val)
    string(REPLACE "${unit}" ";" val "${val}")
    dict(INSERT ${name} ${key} ${val})
  endforeach()
endfunction()

# XXX: The file format needs to be adjusted.
function (ixm_dict_save name)
  parse(${ARGN} @ARGS=1 INTO)
  if (NOT INTO)
    log(FATAL "dict(SAVE) missing 'INTO' parameter")
  endif()
  ixm_dict_noop(${name})
  dict(KEYS ${name} keys)
  string(ASCII 29 group)
  string(ASCII 30 record)
  string(ASCII 31 unit)
  foreach (key IN LISTS keys)
    dict(GET ${name} ${key} value)
    if (value)
      string(REPLACE ";" "${unit}" value "${value}")
      list(APPEND output "${key}${record}${value}")
    endif()
  endforeach()
  list(JOIN output "${group}" output)
  ixm_dict_filepath(INTO "${INTO}" "ixm")
  string(ASCII 2 STX)
  string(ASCII 3 ETX)
  string(ASCII 25 EM)
  file(WRITE "${INTO}" "${STX}IXM${ETX}${STX}v1${ETX}${EM}\n${output}")
endfunction()

function (ixm_dict_json name)
  parse(${ARGN} @ARGS=1 INTO)
  if (NOT INTO)
    log(FATAL "dict(JSON) missing 'INTO' parameter")
  endif()
  ixm_dict_noop(${name})
  dict(KEYS ${name} keys)
  foreach (key IN LISTS keys)
    dict(GET ${name} ${key} value)
    list(LENGTH value length)
    if (NOT DEFINED value)
      set(text null)
    elseif (length GREATER 1)
      ixm_dict_json_array(text ${value})
    else ()
      ixm_dict_json_value(text ${value})
    endif()
    list(APPEND elements "\"${key}\":${text}")
  endforeach()
  list(JOIN elements "," object)
  ixm_dict_filepath(INTO "${INTO}" "json")
  file(WRITE "${INTO}" "{${object}}")
endfunction()

function (ixm_dict_json_value out-var value)
  set(boolean-false OFF NO FALSE N IGNORE NOTFOUND)
  set(boolean-true ON TRUE YES Y)
  if (value IN_LIST boolean-true)
    set(${out-var} true PARENT_SCOPE)
  elseif (value IN_LIST boolean-false)
    set(${out-var} false PARENT_SCOPE)
  elseif (value MATCHES ".*-NOTFOUND")
    set(${out-var} false PARENT_SCOPE)
  elseif (value MATCHES "^-?[0-9]+$")
    set(${out-var} "${value}" PARENT_SCOPE)
  elseif (value MATCHES "^-?(0|[1-9][0-9]+)([.][0-9]+)?$")
    set(${out-var} "${value}" PARENT_SCOPE)
  else()
    set(${out-var} "\"${value}\"" PARENT_SCOPE)
  endif()
endfunction()

function(ixm_dict_json_array out-var)
  foreach (arg IN LISTS ARGN)
    ixm_dict_json_value(text ${arg})
    list(APPEND args "${text}")
  endforeach()
  list(JOIN args "," text)
  set(${out-var} "[${text}]" PARENT_SCOPE)
endfunction()

# Like list(TRANSFORM), but on a key
# TODO: Add parent-scope to dict() for transform command
function (ixm_dict_transform name key)
  if (NOT TARGET ${name})
    return()
  endif()
  dict(GET ${name} ${key} values)
  if (NOT values)
    return()
  endif()
  list(TRANSFORM values ${ARGN})
  dict(INSERT ${name} ${key} ASSIGN ${values})
  parse(${ARGN} @ARGS=? OUTPUT_VARIABLE)
  if (OUTPUT_VARIABLE)
    set(${OUTPUT_VARIABLE} ${${OUTPUT_VARIABLE}} PARENT_SCOPE)
  endif()
endfunction()

#dict(INSERT <dict> key [CONCAT|APPEND|ASSIGN] <value> [<value>...])
function (ixm_dict_insert @insert:name key)
  set(message "dict(INSERT) requires at least one value to be inserted")
  ixm_dict_how(action "${message}" ${ARGN})
  ixm_dict_create(${\@insert\:name})
  set_property(TARGET ${\@insert\:name} ${action} PROPERTY "INTERFACE_${key}" ${ARGN})
  # This is for some basic bookkeeping.
  dict(KEYS ${\@insert\:name} keys)
  list(FIND keys ${key} index)
  if (index EQUAL -1)
    string(ASCII 192 c0)
    set_property(TARGET ${\@insert\:name} APPEND PROPERTY "INTERFACE_${c0}" "${key}")
  endif()
endfunction()

# dict(SET <dict> [CONCAT|APPEND|ASSIGN] <key> <value> <key> <value>)
function (ixm_dict_set @set:name)
  set(message "dict(SET) requires at least one key-value pair to be set")
  ixm_dict_how(action "${message}" ${ARGN})
  ixm_dict_create(${\@set\:name})
  list(LENGTH ARGN length)
  math(EXPR length "${length} - 1")
  foreach (begin RANGE 0 ${length} 2)
    list(SUBLIST ARGN ${begin} 2 kv)
    list(GET kv 0 key)
    list(GET kv 1 val)
    dict(INSERT ${\@set\:name} ${key} ${action} ${val})
  endforeach()
endfunction()

#dict(REMOVE <dict> <key> [<key>...])
function (ixm_dict_remove name)
  if (NOT ARGN)
    log(FATAL "dict(REMOVE) requires at least one key to be removed")
  endif()
  ixm_dict_noop(${name})
  dict(KEYS ${name} keys)
  list(REMOVE_ITEM keys ${ARGN})
  set_property(TARGET ${name} PROPERTY "INTERFACE_${c0}" ${keys})
  foreach (key IN LISTS ARGN)
    set_property(TARGET ${name} PROPERTY "INTERFACE_${key}")
  endforeach()
endfunction()

#dict(CLEAR <dict>)
function (ixm_dict_clear @clear:name)
  dict(KEYS ${\@clear\:name} keys)
  dict(REMOVE ${\@clear\:name} ${keys})
endfunction()

function (ixm_dict_merge name)
  set(message "dict(MERGE) requires at least one existing to be merged in")
  ixm_dict_how(action "${message}" ${ARGN})
  ixm_dict_create(${name})
  foreach (target IN LISTS ARGN)
    dict(KEYS ${target} keys)
    foreach (key IN LISTS keys)
      dict(GET ${target} ${key} value)
      dict(INSERT ${name} "${key}" ${action} "${value}")
    endforeach()
  endforeach()
endfunction()

function (ixm_dict_keys @keys:name @keys:var)
  ixm_dict_noop(${\@keys\:name})
  # This is a valid *byte* but is an invalid utf-8 character :)
  string(ASCII 192 c0)
  dict(GET ${\@keys\:name} ${c0} value)
  set(${\@keys\:var} ${value} PARENT_SCOPE)
endfunction()

function (ixm_dict_get @get:name @get:key @get:var)
  ixm_dict_noop(${\@get\:name})
  get_property(@get:value TARGET ${\@get\:name} PROPERTY "INTERFACE_${\@get\:key}")
  set(${\@get\:var} ${\@get\:value} PARENT_SCOPE)
endfunction()
