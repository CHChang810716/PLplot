# Top-level CMakeLists.txt for PLplot
# Copyright (C) 2006-2018 Alan W. Irwin
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
# along with PLplot; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

# Note, that if you are using a platform that does not supply our
# designated minimum version of CMake for that platform, then your
# best bet is to build a recent version of CMake for yourself or even
# download a binary version of it from Kitware that is suitable for
# your platform.

# MAINTENANCE 2018-09-08
# We prefer to support only recent CMake versions and latest CMake
# policies to keep our build system as simple and as bug free as
# possible.  However, as a special concession for our modern (not
# enterprise or LTS) Linux distro users we allow them to use the
# system version of CMake which at this time is typically 3.7.2 (on
# Debian STABLE = Stretch which is more than a year old now) or later.
# So we adopt 3.7.2 for the minimum CMake version on Linux and also
# that version for CMake policies on all platforms for CMake policy
# uniformity.  The current status of official CMake packages on
# important non-Linux platforms is as follows:

# Cygwin: 3.6.2 from <https://cygwin.com/cgi-bin2/package-grep.cgi>
# MinGW-w64/MSYS2: 3.12.1 from <http://repo.msys2.org/mingw/x86_64/>
# Fink: 3.11.0 from <http://pdb.finkproject.org/pdb/index.php?phpLang=en>
# MacPorts: 3.12.2 from <https://www.macports.org/ports.php>
# HomeBrew:3.12.1 from <http://brewformulas.org/>

# From these results I adopt a CMake minimum version for non-Linux
# platforms of 3.11.0.  This accomodates all the above non-Linux platforms
# other than Cygwin which I believe to be a special case of an
# unmaintained Cygwin package for what is supposed to be a rolling
# release that keeps up with the latest/greatest software versions.
# Because of this change, Cygwin PLplot users will need to build their own
# version of cmake or agitate on the Cygwin list to upgrade the Cygwin CMake
# package to at least 3.11.0.

# Adapted method suggested by Brad King for using
# potentially different minimum versions for different platforms.

set(MINIMUM_LINUX_CMAKE_VERSION 3.7.2)
# Latest CMake version for all platforms other than Linux.
# Must be greater than or equal to MINIMUM_LINUX_CMAKE_VERSION
set(MINIMUM_NON_LINUX_CMAKE_VERSION 3.11.0)
cmake_minimum_required(VERSION ${MINIMUM_LINUX_CMAKE_VERSION} FATAL_ERROR)
cmake_policy(VERSION ${MINIMUM_LINUX_CMAKE_VERSION})
project(plplot NONE)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")
  cmake_minimum_required(VERSION ${MINIMUM_NON_LINUX_CMAKE_VERSION} FATAL_ERROR)
  # Keep policy consistent for all platforms.
  cmake_policy(VERSION ${MINIMUM_NON_LINUX_CMAKE_VERSION})
endif(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")

# N.B. As a result of the following two set commands and logic in the
# configure_library_build function, all internal writeable library
# targets should be referred to as
# ${WRITEABLE_TARGET}<original_target_name> and all corresponding
# internal read-only library targets should be referred to in our
# build system as PLPLOT::<original_target_name>.  The exception to
# these rules are the swig-generated modules case where the writeable
# target name (which is only available in the scope that calls the
# configure_library_build function) is
# ${SWIG_MODULE_<original_target_name>_REAL_NAME} instead of
# ${WRITEABLE_TARGET<original_target_name>.  For example, these
# target names are ${WRITEABLE_TARGET}plplot and PLPLOT::plplot
# for the libplplot.so library and ${SWIG_MODULE_plplotc_REAL_NAME}
# and PLPLOT::_plplotc for the _plplotc.so swig-generated Python
# extension module.

# This value used in configure_library_build function to provide the namespace
# for build-tree ALIAS libraries.  Otherwise, "PLPLOT::" is explicitly used as the
# prefix of read-only library and executable targets that occur in both the build and
# install trees.
set(PROJECT_NAMESPACE PLPLOT::)

option(USE_WRITEABLE_TARGET_TEST_PREFIX "Option to test library and executable targets which have both writeable and (ALIASed namespaced) read-only versions of their targets in the build tree and namespaced read-only targets in the install tree.  This test prepends a prefix to the writeable version of the target name so as a result any such target referred to in the build tree without a writeable (\"writeable_target_test_prefix_)\") or read-only (\"PLPLOT::\") prefix should be discovered by this test (N.B. unless the unprefixed target reference occurs in CMake logic branches that are unexecuted by the particular configuration options that are chosen which makes this test necessary but not sufficient)." OFF)
if(USE_WRITEABLE_TARGET_TEST_PREFIX)
  set(WRITEABLE_TARGET writeable_target_test_prefix_)
else(USE_WRITEABLE_TARGET_TEST_PREFIX)
  set(WRITEABLE_TARGET)
endif(USE_WRITEABLE_TARGET_TEST_PREFIX)

# It is a fatal error if no working C compiler is available to build
# the PLplot core C library and core C examples.  All other compilers
# required by our bindings are optional in that if no working compiler
# of the kind needed is available, the associated bindings and
# examples are disabled.
enable_language(C)

message(STATUS "CMAKE_SYSTEM_NAME = ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_COMMAND = ${CMAKE_COMMAND}")
message(STATUS "CMAKE_VERSION = ${CMAKE_VERSION}")
message(STATUS "CMAKE_GENERATOR = ${CMAKE_GENERATOR}")
message(STATUS "CMAKE_INCLUDE_PATH = ${CMAKE_INCLUDE_PATH}")
message(STATUS "Environment variable CMAKE_INCLUDE_PATH = $ENV{CMAKE_INCLUDE_PATH}")
message(STATUS "CMAKE_LIBRARY_PATH = ${CMAKE_LIBRARY_PATH}")
message(STATUS "Environment variable CMAKE_LIBRARY_PATH = $ENV{CMAKE_LIBRARY_PATH}")
# Location of configured language support files.
message(STATUS "CMAKE_PLATFORM_INFO_DIR = ${CMAKE_PLATFORM_INFO_DIR}")

# Set unambiguous names for these variables as a reminder.
set(WIN32_AND_NOT_CYGWIN ${WIN32})
if(WIN32 OR CYGWIN)
  set(WIN32_OR_CYGWIN ON)
else(WIN32 OR CYGWIN)
  set(WIN32_OR_CYGWIN OFF)
endif(WIN32 OR CYGWIN)

#foreach(policy RANGE 0 9)
#  cmake_policy(GET CMP000${policy} policy_result)
#  message(STATUS "Policy CMP000${policy} is ${policy_result}")
#endforeach(policy RANGE 0 9)

set(PACKAGE plplot)

# Locations where the PLplot build system first looks for cmake modules.
set(CMAKE_MODULE_PATH
  "${PROJECT_SOURCE_DIR}/cmake/modules"
  "${PROJECT_SOURCE_DIR}/cmake/modules/language_support/cmake"
  )

# We need the path to the MinGW/Borland compiler in order to find
# the import libraries for system libraries.
if(MINGW)
  get_filename_component(MINGWBINPATH ${CMAKE_C_COMPILER} PATH)
  set(MINGWLIBPATH ${MINGWBINPATH}/../lib
    CACHE FILEPATH
    "Path to MinGW import libraries")
endif(MINGW)
if(BORLAND)
  get_filename_component(BORLANDBINPATH ${CMAKE_C_COMPILER} PATH)
  set(BORLANDLIBPATH ${BORLANDBINPATH}/../Lib/PSDK
    CACHE FILEPATH
    "Path to Borland import libraries")
endif(BORLAND)

# Version data that need modification for each release.
include(plplot_version)
# parameters to control overall cmake behaviour.

# Configure PLplot component variables....
include(plplot)

# Use configured variables to process configurable top-level files.

# This CMake-configured template file is processed further by sed for
# abi-compliance-checker.
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/abi-compliance-checker.xml.template.in
  ${CMAKE_CURRENT_BINARY_DIR}/abi-compliance-checker.xml.template
  @ONLY
  )

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/plplot_config.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/plplot_config.h
  )
# Allow access to the generated plplot_config.h for this build.
add_definitions("-DPLPLOT_HAVE_CONFIG_H")
# Install top-level files

# Enable testing framework for examples
if(BUILD_TEST)

  # Use same BUILDNAME logic as the CTest module except
  # we allow a BUILDNAME suffix whose value is specified
  # by the user as PLPLOT_BUILDNAME_SUFFIX.  In order
  # for this logic to work it must precede including the
  # CTest module which configures DartConfiguration.tcl
  # with BUILDNAME as determined here.

  if(NOT BUILDNAME)
    set(DART_COMPILER "${CMAKE_CXX_COMPILER}")
    if(NOT DART_COMPILER)
      set(DART_COMPILER "${CMAKE_C_COMPILER}")
    endif()
    if(NOT DART_COMPILER)
      set(DART_COMPILER "unknown")
    endif()
    if(WIN32)
      set(DART_NAME_COMPONENT "NAME_WE")
    else()
      set(DART_NAME_COMPONENT "NAME")
    endif()
    if(NOT BUILD_NAME_SYSTEM_NAME)
      set(BUILD_NAME_SYSTEM_NAME "${CMAKE_SYSTEM_NAME}")
    endif()
    if(WIN32)
      set(BUILD_NAME_SYSTEM_NAME "Win32")
    endif()
    if(UNIX OR BORLAND)
      get_filename_component(DART_COMPILER_NAME
        "${DART_COMPILER}" ${DART_NAME_COMPONENT})
    else()
      get_filename_component(DART_COMPILER_NAME
        "${CMAKE_MAKE_PROGRAM}" ${DART_NAME_COMPONENT})
    endif()
    if(DART_COMPILER_NAME MATCHES "devenv")
      GET_VS_VERSION_STRING("${CMAKE_GENERATOR}" DART_COMPILER_NAME)
    endif()
    set(BUILDNAME "${BUILD_NAME_SYSTEM_NAME}-${DART_COMPILER_NAME}")
  endif()

  # This is only BUILDNAME logic that is different.
  set(BUILDNAME "${BUILDNAME}${PLPLOT_BUILDNAME_SUFFIX}")

  # Change the default ctest timeout from 1500 to 15000 to accommodate
  # our users who happen to have extraordinarily slow computers (such
  # as the Raspberry Pi) or our users with anomalous platform issues
  # where some tests are extraordinarily slow (such as test_c_epsqt
  # and test_c_pdfqt for the static library build on MinGW-w64/MSYS2
  # [as of 2017-08]).

  # (This change must also be done before the following include)
  set(DART_TESTING_TIMEOUT 15000 CACHE STRING
    "Maximum time allowed before CTest will kill the test.")

  # According to
  # <https://cmake.org/Wiki/CMake_Testing_With_CTest>
  # the following command executes the required "enable_testing()"
  # command and also enable the creation and submission of a dashboard
  # (which is defined as the result of a test run, reformatted for easy review)
  # to our dashboard server (the PLplot_git "project" at my.cdash.org whose
  # details are given by CTestConfig.cmake and whose dashboard viewer
  # URL is <http://my.cdash.org/index.php?project=PLplot_git>).
  include(CTest)

  # Customize default values set by include(CTest).  Result must be in
  # build tree so copy it there.
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.ctest.in
    ${CMAKE_CURRENT_BINARY_DIR}/CTestCustom.ctest
    COPYONLY
    )
  # N.B. we execute add_test(...) in the plplot_test
  # subdirectory to implement the various tests that are
  # run by ctest.
endif(BUILD_TEST)

# Disable warnings about deprecated functions (Visual C++ 2005)
if(MSVC_VERSION GREATER 1399)
  add_definitions("/D_CRT_SECURE_NO_DEPRECATE")
endif(MSVC_VERSION GREATER 1399)

# Borland Compiler must compile in ANSII mode
if(BORLAND)
  add_definitions(-A)
endif(BORLAND)

set(top_level_DOCFILES
  ABOUT
  AUTHORS
  COPYING.LIB
  ChangeLog.release
  Copyright
  FAQ
  NEWS
  PROBLEMS
  README
  README.release
  README.cumulated_release
  README.testing
  )
install(FILES ${top_level_DOCFILES} DESTINATION ${DOC_DIR})

if(BUILD_SHARED_LIBS AND WIN32_OR_CYGWIN)
  # For platforms (currently WIN32 or Cygwin, although the Cygwin version
  # of CMake may support this in future since -rpath apparently does work
  # on that platform) where CMake does not use -rpath, use a workaround
  # where all dll's are collected in the dll subdirectory of the build tree.
  set(USE_DLL_SUBDIRECTORY ON)
else(BUILD_SHARED_LIBS AND WIN32_OR_CYGWIN)
  set(USE_DLL_SUBDIRECTORY OFF)
endif(BUILD_SHARED_LIBS AND WIN32_OR_CYGWIN)

# in windows all created dlls are gathered in the dll directory
# if you add this directory to your PATH all shared libraries are available
if(USE_DLL_SUBDIRECTORY)
  set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/dll)
endif(USE_DLL_SUBDIRECTORY)

# Process other directories including using configured variables to
# process configurable files in those directories.  N.B. Order is
# important here at the cmake stage because targets must be processed
# by cmake in a specific order e.g., due to get_target_property
# invocations or if(TARGET...) commands.  Note, this order has nothing
# to do with the order which make processes these subdirectories at
# build time.  That build-time order is determined by the dependencies
# between targets and also by file dependencies that are established
# by the cmake configuration files.

add_subdirectory(fonts)
add_subdirectory(lib)
add_subdirectory(include)
add_subdirectory(src)
add_subdirectory(data)
add_subdirectory(bindings)
add_subdirectory(drivers)
add_subdirectory(utils)
add_subdirectory(plplot_test)
add_subdirectory(examples)
add_subdirectory(scripts)
add_subdirectory(doc)
add_subdirectory(www)
add_subdirectory(pkgcfg)
summary()

if(PREBUILD_DIST)
  # Pre-build everything required for a distribution tarball and copy it to
  # the source tree (if build tree is different from source tree).

  # List of targets that must be (pre-)built.
  set(DIST_TARGETS)

  if(BUILD_PRINT)
    list(APPEND DIST_TARGETS print)
  endif(BUILD_PRINT)

  if(BUILD_INFO)
    list(APPEND DIST_TARGETS info)
  endif(BUILD_INFO)

  if(BUILD_MAN)
    list(APPEND DIST_TARGETS man)
  endif(BUILD_MAN)

  if(BUILD_HTML)
    list(APPEND DIST_TARGETS html)
  endif(BUILD_HTML)

  if(BUILD_DOX_DOC)
    list(APPEND DIST_TARGETS build_doxygen)
  endif(BUILD_DOX_DOC)

  if(CMAKE_BINARY_DIR STREQUAL "${CMAKE_SOURCE_DIR}")
    add_custom_target(prebuild_dist)
  else(CMAKE_BINARY_DIR STREQUAL "${CMAKE_SOURCE_DIR}")
    # copy prebuilds back to source tree.
    # N.B. copy_directory quietly creates an empty directory with no
    # error condition if the source directory does not exist.
    add_custom_target(
      prebuild_dist
      COMMAND ${CMAKE_COMMAND} -E remove_directory
      ${CMAKE_SOURCE_DIR}/doc/doxygen
      COMMAND ${CMAKE_COMMAND} -E copy_directory
      ${CMAKE_BINARY_DIR}/doc/doxygen
      ${CMAKE_SOURCE_DIR}/doc/doxygen
      COMMAND cp
      `cat static_built_files ${INFO_MANIFEST} ${MAN_MANIFEST} ${HTML_MANIFEST}`
      ${CMAKE_SOURCE_DIR}/doc/docbook/src
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/doc/docbook/src
      )
  endif(CMAKE_BINARY_DIR STREQUAL "${CMAKE_SOURCE_DIR}")
  add_dependencies(prebuild_dist ${DIST_TARGETS})
endif(PREBUILD_DIST)

#
# Packing stuff
#
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "The Scientific Plotting Library PLplot")
set(CPACK_PACKAGE_VENDOR "PLplot development team")
set(CPACK_PACKAGE_DESCRIPTION_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README)
set(CPACK_SET_DESTDIR ON)
if(WIN32_AND_NOT_CYGWIN)
  set(CPACK_GENERATOR ZIP)
else(WIN32_AND_NOT_CYGWIN)
  set(CPACK_GENERATOR TGZ)
endif(WIN32_AND_NOT_CYGWIN)
set(
  CPACK_SOURCE_PACKAGE_FILE_NAME
  "plplot-${PLPLOT_VERSION}"
  CACHE INTERNAL "tarball basename"
  )
set(CPACK_SOURCE_GENERATOR TGZ)
# The following components are regex's to match anywhere (unless anchored)
# in absolute path + filename to find files or directories to be excluded
# from source tarball.
set(CPACK_SOURCE_IGNORE_FILES
  "\\\\#.*$"
  "~$"
  # Ignore Mac OS X generated file/directory attribute storage files.
  "\\\\.DS_Store"
  "\\\\._\\\\.DS_Store"
  "^${PROJECT_SOURCE_DIR}.*/\\\\.git/"
  )
#message("CPACK_SOURCE_IGNORE_FILES = ${CPACK_SOURCE_IGNORE_FILES}")
include(CPack)

# Path to native build for executables required in the build process.
# This is only required for cross compiling
if(CMAKE_CROSSCOMPILING)
  set(CMAKE_NATIVE_BINARY_DIR NATIVEDIR-NOTFOUND CACHE FILEPATH "Point to the native build directory")
endif(CMAKE_CROSSCOMPILING)
