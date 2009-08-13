#
# CMakeD - CMake module for D Language
#
# Copyright (c) 2007, Selman Ulug <selman.ulug@gmail.com>
#                     Tim Burrell <tim.burrell@gmail.com>
#
# All rights reserved.
#
# See Copyright.txt for details.
#
# Modified from CMake 2.6.5 CMakeCInformation.cmake
# See http://www.cmake.org/HTML/Copyright.html for details
#

# This file sets the basic flags for the D language in CMake.
# It also loads the available platform file for the system-compiler
# if it exists.

GET_FILENAME_COMPONENT(CMAKE_BASE_NAME ${CMAKE_D_COMPILER} NAME_WE)
IF(CMAKE_COMPILER_IS_GDC)
  SET(CMAKE_BASE_NAME gdc)
ELSE(CMAKE_COMPILER_IS_GDC)
  SET(CMAKE_BASE_NAME dmd)
ENDIF(CMAKE_COMPILER_IS_GDC)
SET(CMAKE_SYSTEM_AND_D_COMPILER_INFO_FILE 
  ${CMAKE_ROOT}/Modules/Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME}.cmake)
INCLUDE(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME} OPTIONAL)

# This should be included before the _INIT variables are
# used to initialize the cache.  Since the rule variables 
# have if blocks on them, users can still define them here.
# But, it should still be after the platform file so changes can
# be made to those values.

IF(CMAKE_USER_MAKE_RULES_OVERRIDE)
   INCLUDE(${CMAKE_USER_MAKE_RULES_OVERRIDE})
ENDIF(CMAKE_USER_MAKE_RULES_OVERRIDE)

IF(CMAKE_USER_MAKE_RULES_OVERRIDE_D)
   INCLUDE(${CMAKE_USER_MAKE_RULES_OVERRIDE_D})
ENDIF(CMAKE_USER_MAKE_RULES_OVERRIDE_D)

# Create a set of shared library variable specific to D
# For 90% of the systems, these are the same flags as the C versions
# so if these are not set just copy the flags from the c version
IF(NOT CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS)

IF(NOT CMAKE_SHARED_LIBRARY_D_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_D_FLAGS ${CMAKE_SHARED_LIBRARY_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_LIBRARY_D_FLAGS)

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_D_FLAGS)
  SET(CMAKE_SHARED_LIBRARY_LINK_D_FLAGS ${CMAKE_SHARED_LIBRARY_LINK_C_FLAGS})
ENDIF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_D_FLAGS)

IF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG)
  SET(CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG}) 
ENDIF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG)

IF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG_SEP)
  SET(CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP})
ENDIF(NOT CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG_SEP)

IF(NOT CMAKE_SHARED_LIBRARY_RPATH_LINK_D_FLAG)
  SET(CMAKE_SHARED_LIBRARY_RPATH_LINK_D_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_C_FLAG})
ENDIF(NOT CMAKE_SHARED_LIBRARY_RPATH_LINK_D_FLAG)

# repeat for modules
IF(NOT CMAKE_SHARED_MODULE_CREATE_D_FLAGS)
  SET(CMAKE_SHARED_MODULE_CREATE_D_FLAGS ${CMAKE_SHARED_MODULE_CREATE_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_MODULE_CREATE_D_FLAGS)

IF(NOT CMAKE_SHARED_MODULE_D_FLAGS)
  SET(CMAKE_SHARED_MODULE_D_FLAGS ${CMAKE_SHARED_MODULE_C_FLAGS})
ENDIF(NOT CMAKE_SHARED_MODULE_D_FLAGS)

IF(NOT CMAKE_SHARED_MODULE_RUNTIME_D_FLAG)
  SET(CMAKE_SHARED_MODULE_RUNTIME_D_FLAG ${CMAKE_SHARED_MODULE_RUNTIME_C_FLAG}) 
ENDIF(NOT CMAKE_SHARED_MODULE_RUNTIME_D_FLAG)

IF(NOT CMAKE_SHARED_MODULE_RUNTIME_D_FLAG_SEP)
  SET(CMAKE_SHARED_MODULE_RUNTIME_D_FLAG_SEP ${CMAKE_SHARED_MODULE_RUNTIME_C_FLAG_SEP})
ENDIF(NOT CMAKE_SHARED_MODULE_RUNTIME_D_FLAG_SEP)

IF(NOT CMAKE_EXECUTABLE_RUNTIME_D_FLAG)
  SET(CMAKE_EXECUTABLE_RUNTIME_D_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG})
ENDIF(NOT CMAKE_EXECUTABLE_RUNTIME_D_FLAG)

IF(NOT CMAKE_EXECUTABLE_RUNTIME_D_FLAG_SEP)
  SET(CMAKE_EXECUTABLE_RUNTIME_D_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_D_FLAG_SEP})
ENDIF(NOT CMAKE_EXECUTABLE_RUNTIME_D_FLAG_SEP)

IF(NOT CMAKE_EXECUTABLE_RPATH_LINK_D_FLAG)
  SET(CMAKE_EXECUTABLE_RPATH_LINK_D_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_D_FLAG})
ENDIF(NOT CMAKE_EXECUTABLE_RPATH_LINK_D_FLAG)

IF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_D_WITH_RUNTIME_PATH)
  SET(CMAKE_SHARED_LIBRARY_LINK_D_WITH_RUNTIME_PATH ${CMAKE_SHARED_LIBRARY_LINK_C_WITH_RUNTIME_PATH})
ENDIF(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_D_WITH_RUNTIME_PATH)

IF(NOT CMAKE_INCLUDE_FLAG_D)
  SET(CMAKE_INCLUDE_FLAG_D ${CMAKE_INCLUDE_FLAG_C})
ENDIF(NOT CMAKE_INCLUDE_FLAG_D)

IF(NOT CMAKE_INCLUDE_FLAG_SEP_D)
  SET(CMAKE_INCLUDE_FLAG_SEP_D ${CMAKE_INCLUDE_FLAG_SEP_C})
ENDIF(NOT CMAKE_INCLUDE_FLAG_SEP_D)

SET (CMAKE_D_FLAGS "$ENV{CFLAGS} ${CMAKE_D_FLAGS_INIT}" CACHE STRING
     "Flags for D compiler.")

IF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)
# default build type is none
  IF(NOT CMAKE_NO_BUILD_TYPE)
    SET (CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE_INIT} CACHE STRING 
      "Choose the type of build, options are: None(CMAKE_D_FLAGS used) Debug Release RelWithDebInfo MinSizeRel.")
  ENDIF(NOT CMAKE_NO_BUILD_TYPE)
  SET (CMAKE_D_FLAGS_DEBUG "${CMAKE_D_FLAGS_DEBUG_INIT}" CACHE STRING
    "Flags used by the compiler during debug builds.")
  SET (CMAKE_D_FLAGS_MINSIZEREL "${CMAKE_D_FLAGS_MINSIZEREL_INIT}" CACHE STRING
    "Flags used by the compiler during release minsize builds.")
  SET (CMAKE_D_FLAGS_RELEASE "${CMAKE_D_FLAGS_RELEASE_INIT}" CACHE STRING
    "Flags used by the compiler during release builds (/MD /Ob1 /Oi /Ot /Oy /Gs will produce slightly less optimized but smaller files).")
  SET (CMAKE_D_FLAGS_RELWITHDEBINFO "${CMAKE_D_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING
    "Flags used by the compiler during Release with Debug Info builds.")
ENDIF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)

IF(CMAKE_D_STANDARD_LIBRARIES_INIT)
  SET(CMAKE_D_STANDARD_LIBRARIES "${CMAKE_D_STANDARD_LIBRARIES_INIT}"
    CACHE STRING "Libraries linked by default with all D applications.")
  MARK_AS_ADVANCED(CMAKE_D_STANDARD_LIBRARIES)
ENDIF(CMAKE_D_STANDARD_LIBRARIES_INIT)

INCLUDE(CMakeCommonLanguageInclude)

# now define the following rule variables

# CMAKE_D_CREATE_SHARED_LIBRARY
# CMAKE_D_CREATE_SHARED_MODULE
# CMAKE_D_CREATE_STATIC_LIBRARY
# CMAKE_D_COMPILE_OBJECT
# CMAKE_D_LINK_EXECUTABLE

# variables supplied by the generator at use time
# <TARGET>
# <TARGET_BASE> the target without the suffix
# <OBJECTS>
# <OBJECT>
# <LINK_LIBRARIES>
# <FLAGS>
# <LINK_FLAGS>

# D compiler information
# <CMAKE_D_COMPILER>  
# <CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS>
# <CMAKE_SHARED_MODULE_CREATE_D_FLAGS>
# <CMAKE_D_LINK_FLAGS>

# Static library tools
# <CMAKE_AR> 
# <CMAKE_RANLIB>

IF("$ENV{D_PATH}" STREQUAL "")
	STRING(LENGTH ${CMAKE_D_COMPILER} CMAKE_D_COMPILER_LENGTH)
	IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
		MATH(EXPR CMAKE_D_COMPILER_LENGTH "${CMAKE_D_COMPILER_LENGTH} - 12")
	ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
		MATH(EXPR CMAKE_D_COMPILER_LENGTH "${CMAKE_D_COMPILER_LENGTH} - 8")
	ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	STRING(SUBSTRING ${CMAKE_D_COMPILER} 0 ${CMAKE_D_COMPILER_LENGTH} D_PATH)
ELSE("$ENV{D_PATH}" STREQUAL "")
	SET(D_PATH "$ENV{D_PATH}")
ENDIF("$ENV{D_PATH}" STREQUAL "")
MESSAGE(STATUS "D Compiler Install Prefix (use D_PATH env var to override): ${D_PATH}")

IF(CMAKE_COMPILER_IS_GDC)
  SET(CMAKE_OUTPUT_D_FLAG "-o ")
  SET(CMAKE_SHARED_LIBRARY_D_FLAGS "-fPIC")
  SET(CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS "-shared")
  SET(CMAKE_INCLUDE_FLAG_D "-I")       # -I
  SET(CMAKE_INCLUDE_FLAG_D_SEP "")     # , or empty
  SET(CMAKE_LIBRARY_PATH_FLAG "-L")
  SET(CMAKE_LINK_LIBRARY_FLAG "-l")
  SET(CMAKE_D_VERSION_FLAG "-fversion=")
ELSE(CMAKE_COMPILER_IS_GDC)
  SET(CMAKE_OUTPUT_D_FLAG "-of")
  SET(CMAKE_D_VERSION_FLAG "-version=")
  IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    SET(CMAKE_INCLUDE_FLAG_D "-I")       # -I
    SET(CMAKE_INCLUDE_FLAG_D_SEP "")     # , or empty
    SET(CMAKE_LINK_LIBRARY_FLAG "-L+")
    SET(CMAKE_LIBRARY_PATH_FLAG "-L+")
    SET(CMAKE_LIBRARY_PATH_TERMINATOR "\\")
    FIND_PROGRAM(DMD_LIBRARIAN "lib.exe")
  ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    SET(CMAKE_SHARED_LIBRARY_D_FLAGS "-fPIC")
    SET(CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS "-shared")
    SET(CMAKE_INCLUDE_FLAG_D "-I")       # -I
    SET(CMAKE_INCLUDE_FLAG_D_SEP "")     # , or empty
    SET(CMAKE_LIBRARY_PATH_FLAG "-L")
  ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
ENDIF(CMAKE_COMPILER_IS_GDC)

IF(CMAKE_D_USE_TANGO)
	IF(CMAKE_COMPILER_IS_GDC)
		SET(DSTDLIB_TYPE "-fversion=Tango")
		SET(DSTDLIB_FLAGS "-lgtango")
	ELSE(CMAKE_COMPILER_IS_GDC)
		SET(DSTDLIB_TYPE "-version=Tango")
		SET(DSTDLIB_FLAGS "-L${D_PATH}/lib -ltango -lphobos")
	ENDIF(CMAKE_COMPILER_IS_GDC)
ENDIF(CMAKE_D_USE_TANGO)
IF(CMAKE_D_USE_PHOBOS)
	IF(CMAKE_COMPILER_IS_GDC)
		SET(DSTDLIB_TYPE "-fversion=Phobos")
		SET(DSTDLIB_FLAGS "-lgphobos")
	ELSE(CMAKE_COMPILER_IS_GDC)
		SET(DSTDLIB_TYPE "-version=Phobos")
		SET(DSTDLIB_FLAGS "-L${D_PATH}/lib -lphobos")
	ENDIF(CMAKE_COMPILER_IS_GDC)
ENDIF(CMAKE_D_USE_PHOBOS)

# create a D shared library
IF(NOT CMAKE_D_CREATE_SHARED_LIBRARY)
  IF(CMAKE_COMPILER_IS_GDC)
  	  SET(CMAKE_D_CREATE_SHARED_LIBRARY
  	    "<CMAKE_D_COMPILER> <CMAKE_SHARED_LIBRARY_D_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS> <CMAKE_SHARED_LIBRARY_SONAME_D_FLAG><TARGET_SONAME> ${CMAKE_OUTPUT_D_FLAG}<TARGET> <OBJECTS> <LINK_LIBRARIES>")
  ELSE(CMAKE_COMPILER_IS_GDC)
  	  SET(CMAKE_D_CREATE_SHARED_LIBRARY
  	    "<CMAKE_D_COMPILER> <CMAKE_SHARED_LIBRARY_D_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_D_FLAGS> <CMAKE_SHARED_LIBRARY_SONAME_D_FLAG><TARGET_SONAME> ${CMAKE_OUTPUT_D_FLAG}<TARGET> <OBJECTS> <LINK_LIBRARIES> ${DSTDLIB_FLAGS}")
  ENDIF(CMAKE_COMPILER_IS_GDC)
ENDIF(NOT CMAKE_D_CREATE_SHARED_LIBRARY)

# create a D shared module just copy the shared library rule
IF(NOT CMAKE_D_CREATE_SHARED_MODULE)
  SET(CMAKE_D_CREATE_SHARED_MODULE ${CMAKE_D_CREATE_SHARED_LIBRARY})
ENDIF(NOT CMAKE_D_CREATE_SHARED_MODULE)

# create a D static library
IF(NOT CMAKE_D_CREATE_STATIC_LIBRARY)
  IF(CMAKE_COMPILER_IS_GDC)
	IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    		SET(CMAKE_D_CREATE_STATIC_LIBRARY
	      	"<CMAKE_AR> cr <TARGET>.lib <LINK_FLAGS> <OBJECTS> "
	      	"<CMAKE_RANLIB> <TARGET>.lib "
      		"<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS> "
		      "<CMAKE_RANLIB> <TARGET> "
	      )
	ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    		SET(CMAKE_D_CREATE_STATIC_LIBRARY
      		"<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS> "
		      "<CMAKE_RANLIB> <TARGET> "
	      )
	ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  ELSE(CMAKE_COMPILER_IS_GDC)
    IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
      SET(CMAKE_D_CREATE_STATIC_LIBRARY
	"${DMD_LIBRARIAN} -c -p256 <TARGET> <OBJECTS>")
    ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
      SET(CMAKE_D_CREATE_STATIC_LIBRARY
	"<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS>"
	"<CMAKE_RANLIB> <TARGET>")
    ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  ENDIF(CMAKE_COMPILER_IS_GDC)  
ENDIF(NOT CMAKE_D_CREATE_STATIC_LIBRARY)

# compile a D file into an object file
IF(NOT CMAKE_D_COMPILE_OBJECT)
    SET(CMAKE_D_COMPILE_OBJECT
      "<CMAKE_D_COMPILER> <FLAGS> ${CMAKE_OUTPUT_D_FLAG}<OBJECT> -c <SOURCE>")
ENDIF(NOT CMAKE_D_COMPILE_OBJECT)

IF(NOT CMAKE_D_LINK_EXECUTABLE)
  IF(CMAKE_COMPILER_IS_GDC)
    SET(CMAKE_D_LINK_EXECUTABLE
      "<CMAKE_D_COMPILER> <FLAGS> <CMAKE_D_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> ${CMAKE_OUTPUT_D_FLAG}<TARGET> <LINK_LIBRARIES> ${DSTDLIB_FLAGS} ${DSTDLIB_TYPE}")
  ELSE(CMAKE_COMPILER_IS_GDC)
    IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
      SET(CMAKE_D_LINK_EXECUTABLE
	"<CMAKE_D_COMPILER> <FLAGS> <CMAKE_D_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> ${CMAKE_OUTPUT_D_FLAG}<TARGET> <LINK_LIBRARIES>")
    ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
      SET(CMAKE_D_LINK_EXECUTABLE
	"gcc ${DLINK_FLAGS} <CMAKE_D_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -lpthread -lm ${DSTDLIB_FLAGS}")
    ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  ENDIF(CMAKE_COMPILER_IS_GDC)
ENDIF(NOT CMAKE_D_LINK_EXECUTABLE)

MARK_AS_ADVANCED(
CMAKE_D_FLAGS
CMAKE_D_FLAGS_DEBUG
CMAKE_D_FLAGS_MINSIZEREL
CMAKE_D_FLAGS_RELEASE
CMAKE_D_FLAGS_RELWITHDEBINFO
)
SET(CMAKE_D_INFORMATION_LOADED 1)
