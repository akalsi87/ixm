cmake_minimum_required(VERSION ${VERSION})
project(${NAME} LANGUAGES ${LANGUAGE})

string(TOLOWER ${LANGUAGE} extension)

if (NOT TARGET_TYPE STREQUAL "PROGRAM")
  add_library(${NAME} ${TARGET_TYPE})
else()
  add_executable(${NAME})
endif()

target_sources(${NAME} PRIVATE main.${extension})

target_include_directories(${NAME} PRIVATE ${INCLUDE_DIRECTORIES})
target_compile_definitions(${NAME} PRIVATE ${COMPILE_DEFINITIONS})
target_compile_options(${NAME} PRIVATE ${COMPILE_OPTIONS})
target_compile_features(${NAME} PRIVATE ${COMPILE_FEATURES})
target_link_directories(${NAME} PRIVATE ${LINK_DIRECTORIES})
target_link_libraries(${NAME} PRIVATE ${LINK_LIBRARIES})
target_link_options(${NAME} PRIVATE ${LINK_OPTIONS})
