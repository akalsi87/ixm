include_guard(GLOBAL)

# TODO: Have each of these be available for enabled languages...
# TODO: God this is a lot of properties :/
# define_property(TARGET PROPERTY <LANG>_CLANG_FORMAT)
# define_property(TARGET PROPERTY <LANG>_CLANG_FORMAT_ACCESS_MODIFIER_OFFSET)

function (add_executable target)
  _add_executable(${target} ${ARGN})
  foreach (property IN LISTS IXM_TARGET_PROPERTIES)
    if (NOT DEFINED CMAKE_${property})
      continue()
    endif()
    # if ${target} is an INTERFACE we need to add these as interface properties..
    set_target_properties(${target}
      PROPERTIES
        CXX_${property} ${CMAKE_${property}}
        C_${property} ${CMAKE_${property}})
    endif()
  endforeach()
endfunction()

define_property(TARGET PROPERTY CLANG_FORMAT_LANGUAGE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ACCESS_MODIFIER_OFFSET BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALIGN_AFTER_OPEN_BRACKET BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALIGN_CONSECUTIVE_ASSIGNMENTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALIGN_CONSECUTIVE_DECLARATIONS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALIGN_ESCAPED_NEWLINES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALIGN_OPERANDS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALIGN_TRAILING_COMMENTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALLOW_ALL_PARAMETERS_OF_DECLARATION_ON_NEXT_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALLOW_SHORT_BLOCKS_ON_A_SINGLE_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALLOW_SHORT_CASE_LABEL_ON_A_SINGLE_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALLOW_SHORT_IF_STATEMENT_ON_A_SINGLE_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALLOW_SHORT_LOOPS_ON_A_SINGLE_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALWAYS_BREAK_AFTER_DEFINITION_RETURN_TYPE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALWAYS_BREAK_AFTER_RETURN_TYPE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALWAYS_BREAK_BEFORE_MULTILINE_STRINGS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_ALWAYS_BREAK_TEMPLATE_DECLARATIONS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BIN_PACK_ARGUMENTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BIN_PACK_PARAMETERS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_CLASS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_CONTROL_STATEMENT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_ENUM BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_FUNCTION BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_NAMESPACE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_OBJC_DECLARATION BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_STRUCT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_UNION BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_AFTER_EXTERN_BLOCK BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_BEFORE_CATCH BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_BEFORE_ELSE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_INDENT_BRACES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_SPLIT_EMPTY_FUNCTION BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_SPLIT_EMPTY_RECORD BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BRACE_WRAPPING_SPLIT_EMPTY_NAMESPACE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_BINARY_OPERATORS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_BEFORE_BRACES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_BEFORE_INHERITANCE_COMMA BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_INHERITANCE_LIST BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_BEFORE_TERNARY_OPERATORS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_CONSTRUCTOR_INITIALIZERS_BEFORE_COMMA BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_CONSTRUCTOR_INITIALIZERS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_AFTER_JAVA_FIELD_ANNOTATIONS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_BREAK_STRING_LITERALS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_COLUMN_LIMIT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_COMMENT_PRAGMAS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_COMPACT_NAMESPACES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_CONSTRUCTOR_INITIALIZER_ALL_ON_ONE_LINE_OR_PER_ONE_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_CONSTRUCTOR_INITIALIZER_INDENT_WIDTH BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_CONTINUATION_INDENT_WIDTH BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_CPP11_BRACED_LIST_STYLE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_DERIVE_POINTER_ALIGNMENT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_DISABLE_FORMAT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_EXPERIMENTAL_AUTO_DETECT_BIN_PACKING BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_FIX_NAMESPACE_COMMENTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_FOREACH_MACROS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INCLUDE_BLOCKS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INCLUDE_CATEGORIES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INCLUDE_IS_MAIN_REGEX BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INDENT_CASE_LABELS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INDENT_PP_DIRECTIVES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INDENT_WIDTH BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_INDENT_WRAPPED_FUNCTION_NAMES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_JAVASCRIPT_QUOTES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_JAVASCRIPT_WRAP_IMPORTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_KEEP_EMPTY_LINES_AT_THE_START_OF_BLOCKS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_MACRO_BLOCK_BEGIN BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_MACRO_BLOCK_END BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_MAX_EMPTY_LINES_TO_KEEP BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_NAMESPACE_INDENTATION BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_OBJC_BIN_PACK_PROTOCOL_LIST BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_OBJC_BLOCK_INDENT_WIDTH BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_OBJC_SPACE_AFTER_PROPERTY BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_OBJC_SPACE_BEFORE_PROTOCOL_LIST BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_BREAK_ASSIGNMENT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_BREAK_BEFORE_FIRST_CALL_PARAMETER BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_BREAK_COMMENT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_BREAK_FIRST_LESS_LESS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_BREAK_STRING BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_BREAK_TEMPLATE_DECLARATION BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_EXCESS_CHARACTER BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_PENALTY_RETURN_TYPE_ON_ITS_OWN_LINE BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_POINTER_ALIGNMENT BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_REFLOW_COMMENTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SORT_INCLUDES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SORT_USING_DECLARATIONS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_AFTER_C_STYLE_CAST BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_AFTER_TEMPLATE_KEYWORD BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_BEFORE_ASSIGNMENT_OPERATORS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_BEFORE_CPP11_BRACED_LIST BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_BEFORE_CTOR_INITIALIZER_COLON BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_BEFORE_INHERITANCE_COLON BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_BEFORE_PARENS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_BEFORE_RANGE_BASED_FOR_LOOP_COLON BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACE_IN_EMPTY_PARENTHESES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACES_BEFORE_TRAILING_COMMENTS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACES_IN_ANGLES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACES_IN_CONTAINER_LITERALS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACES_IN_C_STYLE_CAST_PARENTHESES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACES_IN_PARENTHESES BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_SPACES_IN_SQUARE_BRACKETS BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_STANDARD BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_TAB_WIDTH BRIEF_DOCS "" FULL_DOCS "")
define_property(TARGET PROPERTY CLANG_FORMAT_USE_TAB BRIEF_DOCS "" FULL_DOCS "")
