# cmake/modules/plplot.cmake
#
# Copyright (C) 2006  Alan W. Irwin
#
# This file is part of PLplot.
#
# PLplot is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; version 2 of the License.
#
# PLplot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public License
# along with the file PLplot; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

# Module for determining all configuration variables for PLplot.

# libraries are all shared by default
option(BUILD_SHARED_LIBS "Build shared libraries" ON)

# Color maps (discrete and continuous) to use by default
if(NOT DEFAULT_CMAP0_FILE)
  set(DEFAULT_CMAP0_FILE "cmap0_default.pal")
endif(NOT DEFAULT_CMAP0_FILE)

if(NOT DEFAULT_CMAP1_FILE)
  set(DEFAULT_CMAP1_FILE "cmap1_default.pal")
endif(NOT DEFAULT_CMAP1_FILE)

# Need these modules to do subsequent checks.
include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckPrototypeExists)

# Useful functions go here.

function(TRANSFORM_VERSION numerical_result version)
  # internal_version ignores everything in version after any character that
  # is not 0-9 or ".".  This should take care of the case when there is
  # some non-numerical data in the patch version.
  #message(STATUS "DEBUG: version = ${version}")
  string(REGEX REPLACE "^([0-9.]+).*$" "\\1" internal_version ${version})

  # internal_version is normally a period-delimited triplet string of the form
  # "major.minor.patch", but patch and/or minor could be missing.
  # Transform internal_version into a numerical result that can be compared.
  string(REGEX REPLACE "^([0-9]*).+$" "\\1" major ${internal_version})
  string(REGEX REPLACE "^[0-9]*\\.([0-9]*).*$" "\\1" minor ${internal_version})
  string(REGEX REPLACE "^[0-9]*\\.[0-9]*\\.([0-9]*)$" "\\1" patch ${internal_version})

  if(NOT patch MATCHES "[0-9]+")
    set(patch 0)
  endif(NOT patch MATCHES "[0-9]+")
  
  if(NOT minor MATCHES "[0-9]+")
    set(minor 0)
  endif(NOT minor MATCHES "[0-9]+")
  
  if(NOT major MATCHES "[0-9]+")
    set(major 0)
  endif(NOT major MATCHES "[0-9]+")
  #message(STATUS "DEBUG: internal_version = ${internal_version}")
  #message(STATUS "DEBUG: major = ${major}")
  #message(STATUS "DEBUG: minor= ${minor}")
  #message(STATUS "DEBUG: patch = ${patch}")
  math(EXPR internal_numerical_result
    "${major}*1000000 + ${minor}*1000 + ${patch}"
    )
  #message(STATUS "DEBUG: ${numerical_result} = ${internal_numerical_result}")
  set(${numerical_result} ${internal_numerical_result} PARENT_SCOPE)
endfunction(TRANSFORM_VERSION)

# =======================================================================
# Compilation and build options (PLFLT, install locations, and rpath)
# Note, must come before java since that depends on, e.g., LIB_DIR.
# =======================================================================

# WIN32 covers CYGWIN as well (and possibly MINGW, but we will make sure).
if(WIN32 OR MINGW)
  set(EXEEXT .exe)
endif(WIN32 OR MINGW)

include(double)
include(instdirs)
include(rpath)

# Common CMakeLists.txt files are used to build the examples in the build
# tree and also to build the installed examples by the new CMake-based build
# system devoted to that purpose. Set this fundamental identification to
# distinguish the two cases.
set(CORE_BUILD ON)

option(BUILD_TEST "Compile examples in the build tree and enable ctest" OFF)

# Use bash when available for ctest and install tree test support
find_program(SH_EXECUTABLE bash)
find_program(SH_EXECUTABLE win-bash)
if(SH_EXECUTABLE)
  set(HAVE_BASH ON)
else(SH_EXECUTABLE)
  find_program(SH_EXECUTABLE sh)
endif(SH_EXECUTABLE)

if(NOT SH_EXECUTABLE)
   message(STATUS
   "WARNING: bash shell not found, ctest will not work properly"
   )
endif(NOT SH_EXECUTABLE)

# Find diff, tail and tee which are used to compare results from different
# bindings.
find_program(DIFF_EXECUTABLE diff)
find_program(TAIL_EXECUTABLE tail)


option(PREBUILD_DIST "Pre-build all components required for distribution" OFF)
if(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(
  PREBUILD_DIST OFF CACHE INTERNAL
  "Pre-build all components required for distribution"
  )
endif(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")

# create a devpackage file
option(DEVPAK "Create DevPackage" NO)
if(DEVPAK AND NOT WIN32)
  message( STATUS "DevPackage only available for Win32. Set DEVPAK to OFF." )
  set(DEVPAK OFF)
endif(DEVPAK AND NOT WIN32)
if(DEVPAK AND BUILD_TEST)
  message( STATUS "Examples are not build for DevPackage. Set BUILD_TEST to OFF." )
  set(BUILD_TEST OFF)
endif(DEVPAK AND BUILD_TEST)


# =======================================================================
# Headers
# =======================================================================

# AC_HEADER_STDC is gross overkill since the current PLplot code only uses
# this for whether or not atexit can be used.  But implement the full suite
# of AC_HEADER_STDC checks to keep the cmake version in synch with autotools
# and just in case some PLplot developer assumes the complete check for
# standard headers is done for a future programming change.
#
# From info autoconf....
# Define STDC_HEADERS if the system has ANSI C header files.
# Specifically, this macro checks for stdlib.h', stdarg.h',
# string.h', and float.h'; if the system has those, it probably
# has the rest of the ANSI C header files.  This macro also checks
# whether string.h' declares memchr' (and thus presumably the
# other mem' functions), whether stdlib.h' declare free' (and
# thus presumably malloc' and other related functions), and whether
# the ctype.h' macros work on characters with the high bit set, as
# ANSI C requires.

message(STATUS "Checking whether system has ANSI C header files")
check_include_files("stdlib.h;stdarg.h;string.h;float.h" StandardHeadersExist)
if(StandardHeadersExist)
  check_prototype_exists(memchr string.h memchrExists)
  if(memchrExists)
    check_prototype_exists(free stdlib.h freeExists)
    if(freeExists)
      include(TestForHighBitCharacters)
      if(CMAKE_HIGH_BIT_CHARACTERS)
        message(STATUS "ANSI C header files - found")
        set(STDC_HEADERS 1 CACHE INTERNAL "System has ANSI C header files")
      endif(CMAKE_HIGH_BIT_CHARACTERS)
    endif(freeExists)
  endif(memchrExists)
endif(StandardHeadersExist)
if(NOT STDC_HEADERS)
  message(STATUS "ANSI C header files - not found")
  set(STDC_HEADERS 0 CACHE INTERNAL "System has ANSI C header files")
endif(NOT STDC_HEADERS)

# AC_CHECK_HEADERS(unistd.h termios.h stdint.h)
check_include_files(unistd.h PL_HAVE_UNISTD_H)
check_include_files(termios.h HAVE_TERMIOS_H)
check_include_files(stdint.h PL_HAVE_STDINT_H)

# AC_HEADER_SYS_WAIT
include(TestForStandardHeaderwait)

# Reasonable approximation to AC_HEADER_DIRENT without the SCO stuff.
include(CheckDIRSymbolExists)
check_dirsymbol_exists("sys/types.h;dirent.h" HAVE_DIRENT_H)
if(NOT HAVE_DIRENT_H)
  check_dirsymbol_exists("sys/types.h;sys/ndir.h" HAVE_SYS_NDIR_H)
  if(NOT HAVE_SYS_NDIR_H)
    check_dirsymbol_exists("sys/types.h;sys/dir.h" HAVE_SYS_DIR_H)
    if(NOT HAVE_SYS_DIR_H)
      check_dirsymbol_exists("sys/types.h;ndir.h" HAVE_NDIR_H)
      if(NOT HAVE_NDIR_H AND UNIX)
        message(FATAL_ERROR
        "FATAL_ERROR for plplot.cmake: "
        "DIR symbol must be defined by Unix system headers."
        )
      endif(NOT HAVE_NDIR_H AND UNIX)
    endif(NOT HAVE_SYS_DIR_H)
  endif(NOT HAVE_SYS_NDIR_H)
endif(NOT HAVE_DIRENT_H)
# Note the above tests #include <sys/types.h> to follow how
# AC_HEADER_DIRENT does its testing.  Therefore, always do our
# own #defines that way for the cmake build system.  Note, this
# sys/types.h requirement occurs for Mac OS X and possibly other systems.
# It is possible it will go away in the future, but we will follow whatever
# is done by AC_HEADER_DIRENT here until that changes.
set(NEED_SYS_TYPE_H ON)

#=======================================================================
# Typedefs
#=======================================================================

# In the past, some X11 headers required "caddr_t" even on systems that
# claimed POSIX.1 compliance, which was illegal.  This made it impossible
# to compile programs that included X11 headers if _POSIX_SOURCE was
# defined.  We used to work around this potential problem by just defining
# caddr_t to 'char *' on all systems (unless it is set already), whether
# it was needed or not. Now we ignore the issue because we don't expect
# such broken X behaviour any more and because this kind of argument list
# for AC_CHECK_TYPE is now deprecated in the autoconf documentation.

# Do not implement the equivalent of this since commented out in the ABS
# system.
# AC_CHECK_TYPE(caddr_t, char *)

# Test signal handler return type (mimics AC_TYPE_SIGNAL)
include(TestSignalType)

include(CheckFunctionExists)
check_function_exists(popen HAVE_POPEN)
check_function_exists(usleep PL_HAVE_USLEEP)

# Check for FP functions, including underscored version which 
# are sometimes all that is available on windows

check_symbol_exists(finite "math.h" HAVE_FINITE_SYMBOL)
if(HAVE_FINITE_SYMBOL)
  set(PL_HAVE_FINITE ON)
else(HAVE_FINITE_SYMBOL)
  check_function_exists(finite HAVE_FINITE_FUNCTION)
  if(HAVE_FINITE_FUNCTION)
    set(PL_HAVE_FINITE ON)
  else(HAVE_FINITE_FUNCTION)
    check_symbol_exists(_finite "math.h" HAVE__FINITE_SYMBOL)
    if(HAVE__FINITE_SYMBOL)
      set(PL__HAVE_FINITE ON)
    else(HAVE__FINITE_SYMBOL)
      check_function_exists(_finite HAVE__FINITE_FUNCTION)
      if(HAVE__FINITE_FUNCTION)
        set(PL__HAVE_FINITE ON)
      endif(HAVE__FINITE_FUNCTION)
    endif(HAVE__FINITE_SYMBOL)
  endif(HAVE_FINITE_FUNCTION)
endif(HAVE_FINITE_SYMBOL)
if(PL__HAVE_FINITE)
  set(PL_HAVE_FINITE ON)
endif(PL__HAVE_FINITE)

check_symbol_exists(isnan "math.h" HAVE_ISNAN_SYMBOL)
if(HAVE_ISNAN_SYMBOL)
  set(PL_HAVE_ISNAN ON)
else(HAVE_ISNAN_SYMBOL)
  check_function_exists(isnan HAVE_ISNAN_FUNCTION)
  if(HAVE_ISNAN_FUNCTION)
    set(PL_HAVE_ISNAN ON)
  else(HAVE_ISNAN_FUNCTION)
    check_symbol_exists(_isnan "math.h" HAVE__ISNAN_SYMBOL)
    if(HAVE__ISNAN_SYMBOL)
      set(PL__HAVE_ISNAN ON)
    else(HAVE__ISNAN_SYMBOL)
      check_function_exists(_isnan HAVE__ISNAN_FUNCTION)
      if(HAVE__ISNAN_FUNCTION)
        set(PL__HAVE_ISNAN ON)
      endif(HAVE__ISNAN_FUNCTION)
    endif(HAVE__ISNAN_SYMBOL)
  endif(HAVE_ISNAN_FUNCTION)
endif(HAVE_ISNAN_SYMBOL)
if(PL__HAVE_ISNAN)
  set(PL_HAVE_ISNAN ON)
endif(PL__HAVE_ISNAN)

check_symbol_exists(isinf "math.h" HAVE_ISINF_SYMBOL)
if(HAVE_ISINF_SYMBOL)
  set(PL_HAVE_ISINF ON)
else(HAVE_ISINF_SYMBOL)
  check_function_exists(isinf HAVE_ISINF_FUNCTION)
  if(HAVE_ISINF_FUNCTION)
    set(PL_HAVE_ISINF ON)
  else(HAVE_ISINF_FUNCTION)
    check_symbol_exists(_isinf "math.h" HAVE__ISINF_SYMBOL)
    if(HAVE__ISINF_SYMBOL)
      set(PL__HAVE_ISINF ON)
    else(HAVE__ISINF_SYMBOL)
      check_function_exists(_isinf HAVE__ISINF_FUNCTION)
      if(HAVE__ISINF_FUNCTION)
        set(PL__HAVE_ISINF ON)
      endif(HAVE__ISINF_FUNCTION)
    endif(HAVE__ISINF_SYMBOL)
  endif(HAVE_ISINF_FUNCTION)
endif(HAVE_ISINF_SYMBOL)
if(PL__HAVE_ISINF)
  set(PL_HAVE_ISINF ON)
endif(PL__HAVE_ISINF)


check_function_exists(snprintf PL_HAVE_SNPRINTF)
if(NOT PL_HAVE_SNPRINTF)
  check_function_exists(_snprintf _PL_HAVE_SNPRINTF)
  set(PL_HAVE_SNPRINTF ${_PL_HAVE_SNPRINTF} CACHE INTERNAL "Have function _sprintf")
endif(NOT PL_HAVE_SNPRINTF)

# =======================================================================
# Language bindings
# =======================================================================

# Find swig.  Required for python, java and Lua bindings.
# N.B. all version tests done below need experimental FindSWIG.cmake which
# is currently carried in this directory by PLplot, but which eventually
# should get into CMake.
find_package(SWIG)
if(SWIG_FOUND)
  message(STATUS "SWIG_VERSION = ${SWIG_VERSION}")
  # Logic that depends on swig version
  transform_version(NUMERICAL_SWIG_MINIMUM_VERSION "1.3.22")
  transform_version(NUMERICAL_SWIG_VERSION "${SWIG_VERSION}")
  if(NUMERICAL_SWIG_VERSION LESS "${NUMERICAL_SWIG_MINIMUM_VERSION}")
    message(STATUS "WARNING: swig version too old.  SWIG_FOUND set to OFF")
    set(SWIG_FOUND OFF)
  endif(NUMERICAL_SWIG_VERSION LESS "${NUMERICAL_SWIG_MINIMUM_VERSION}")
endif(SWIG_FOUND)

if(SWIG_FOUND)
  transform_version(NUMERICAL_NOPGCPP_MINIMUM_VERSION "1.3.30")
  if(NUMERICAL_SWIG_VERSION LESS "${NUMERICAL_NOPGCPP_MINIMUM_VERSION}")
    set(SWIG_JAVA_NOPGCPP OFF)
  else(NUMERICAL_SWIG_VERSION LESS "${NUMERICAL_NOPGCPP_MINIMUM_VERSION}")
    set(SWIG_JAVA_NOPGCPP ON)
  endif(NUMERICAL_SWIG_VERSION LESS "${NUMERICAL_NOPGCPP_MINIMUM_VERSION}")
endif(SWIG_FOUND)

if(SWIG_FOUND)
  # Do not use "include(${SWIG_USE_FILE})" here since we want the option of
  # using a locally modified version of UseSWIG.cmake if that exists rather
  # than the official system version of that file.
  include(UseSWIG)
endif(SWIG_FOUND)

# Find Perl.  Required in several places in the build system (e.g.,
# tcl and docbook).
find_package(Perl)
if(PERL_FOUND)
    include(CheckPerlModules)
endif(PERL_FOUND)

# =======================================================================
# pkg-config support as well as macros to put link flags in standard
# *.pc (pkg-config) form as well as standard fullpath form used by cmake.
# =======================================================================
include(pkg-config)

# Find X headers, libraries, and library directory (required by xwin and
# cairo device drivers and also everything that is Tk related).
find_package(X11)

# Convert X11_LIBRARIES to full pathname in all cases (2.4 and 2.6).
cmake_link_flags(X11_LIBRARIES "${X11_LIBRARIES}")

if(X11_INCLUDE_DIR)
  # remove duplicates in the X11_INCLUDE_DIR list since those screw up
  # certain of our modules and also slow down compilation if any of
  # those duplicates leak through to the compile -I options.
  list(SORT X11_INCLUDE_DIR)
  set(copy_X11_INCLUDE_DIR ${X11_INCLUDE_DIR})
  set(listindex 0)
  set(listindexplus 1)
  foreach(copy_listelement ${copy_X11_INCLUDE_DIR})
    # need to get list elements corresponding to list indices.
    list(LENGTH X11_INCLUDE_DIR listlength)
    if(listindexplus LESS ${listlength})
      list(GET X11_INCLUDE_DIR ${listindex} listelement)
      list(GET X11_INCLUDE_DIR ${listindexplus} listelementplus)
    else(listindexplus LESS ${listlength})
      set(listelement)
      set(listelementplus)
    endif(listindexplus LESS ${listlength})
    if(copy_listelement STREQUAL "${listelement}" AND
    copy_listelement STREQUAL "${listelementplus}"
    )
      list(REMOVE_AT X11_INCLUDE_DIR ${listindex})
    else(copy_listelement STREQUAL "${listelement}" AND
    copy_listelement STREQUAL "${listelementplus}"
    )
      # update list indices
      math(EXPR listindex "${listindex} + 1")
      math(EXPR listindexplus "${listindex} + 1")
    endif(copy_listelement STREQUAL "${listelement}" AND
    copy_listelement STREQUAL "${listelementplus}"
    )
  endforeach(copy_listelement ${copy_X11_INCLUDE_DIR})
  string(REGEX REPLACE ";" " -I" X11_COMPILE_FLAGS "-I${X11_INCLUDE_DIR}")
endif(X11_INCLUDE_DIR)
message(STATUS "X11_FOUND = ${X11_FOUND}")
message(STATUS "X11_INCLUDE_DIR = ${X11_INCLUDE_DIR}")
message(STATUS "X11_COMPILE_FLAGS = ${X11_COMPILE_FLAGS}")
message(STATUS "X11_LIBRARIES = ${X11_LIBRARIES}")

option(DEFAULT_NO_BINDINGS
"All language bindings are disabled by default"
OFF
)
# Temporary workaround for language support that is required.
include(language_support)

# Individual language support.
include(c++)
include(fortran)
include(java)
include(python)
include(octave)
include(tcl-related)
include(pdl)
include(ada)
include(ocaml)
include(lua)
include(d)

# =======================================================================
# additional library support
# =======================================================================
include(freetype)
# On windows systems the math library is not separated so do not specify
# it unless you are on a non-windows system.
if(NOT WIN32)
  find_library(MATH_LIB NAMES m PATHS /usr/local/lib /usr/lib)
  if(NOT MATH_LIB)
    message(FATAL_ERROR "Cannot find required math library")
  endif(NOT MATH_LIB)
endif(NOT WIN32)
# Must come after MATH_LIB is defined (or not).
include(csiro)


# =======================================================================
# libpango support
# =======================================================================
include(pango)

# =======================================================================
# Device drivers
# =======================================================================
include(drivers)

# =======================================================================
# Miscellaneous other features - including docbook documentation
# =======================================================================
include(docbook)
include(doxygen)
include(summary)


