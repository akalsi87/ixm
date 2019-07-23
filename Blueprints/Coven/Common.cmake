include_guard(GLOBAL)

function (coven_common_check_main out-var directory)
  foreach (extension IN LISTS IXM_SOURCE_EXTENSIONS)
    if (EXISTS "${directory}/main.${extension}")
      set(${out-var} ON PARENT_SCOPE)
      return()
    endif()
  endforeach()
endfunction()