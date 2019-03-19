include_guard(GLOBAL)

function (ixm_fetch_recipe_basic recipe default)
  string(REPLACE "@" ";" recipe "${recipe}")
  list(APPEND recipe "${default}")
  list(GET recipe 0 name)
  list(GET recipe 1 tag)
  upvar(name tag)
endfunction()

function (ixm_fetch_recipe_advanced recipe)
  string(REGEX MATCH "([^/]+)[/]([^@/]+)(@.+)?" matched ${recipe})
  if (NOT matched)
    error("Could not understand package recipe: '${package}'")
  endif()
  set(root "${CMAKE_MATCH_1}" PARENT_SCOPE)
  set(name "${CMAKE_MATCH_2}" PARENT_SCOPE)
  var(tag CMAKE_MATCH_3 "${ARGN}") 
  string(REPLACE "@" "" tag ${tag})
  upvar(tag)
endfunction()
