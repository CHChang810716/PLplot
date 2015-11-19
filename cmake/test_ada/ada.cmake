# Find and check Ada compiler
enable_language(Ada)
if(NOT CMAKE_Ada_COMPILER_WORKS)
  message(FATAL_ERROR "Required working Ada compiler not found.")
endif(NOT CMAKE_Ada_COMPILER_WORKS)

# Find the gnat version used in order to search for the right version of libgnat
message(STATUS "CMAKE_Ada_COMPILER = ${CMAKE_Ada_COMPILER}")
execute_process(COMMAND ${CMAKE_Ada_COMPILER} --version OUTPUT_VARIABLE ADA_OUTPUT)
string(REGEX MATCH "([0-9]*)([.][0-9]*)[.][0-9]" ADA_OUTPUT_TRIM ${ADA_OUTPUT})
set(GNAT_MAJOR_VERSION ${CMAKE_MATCH_1})
set(GNAT_VERSION ${CMAKE_MATCH_1}${CMAKE_MATCH_2})
message(STATUS "GNAT_MAJOR_VERSION = ${GNAT_MAJOR_VERSION}")
message(STATUS "GNAT_VERSION = ${GNAT_VERSION}")
find_library(GNAT_LIB NAMES gnat gnat-${GNAT_VERSION} gnat-${GNAT_MAJOR_VERSION})
if(NOT GNAT_LIB)
  message(FATAL_ERROR "Required gnat library not found.")
endif(NOT GNAT_LIB)
