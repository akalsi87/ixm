include_guard(GLOBAL)

function (ixm_target_library name)
  void(ALIAS)
  parse(${ARGN} @ARGS=? ALIAS)
  add_library(${name} SHARED)
  if (ALIAS)
    add_library(${ALIAS} ALIAS ${name})
  endif()
  event(EMIT target:library ${name})
endfunction ()