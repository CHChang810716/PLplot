dnl $Id$ --*-Autoconf-*--
dnl
dnl Local autoconf extensions.  These are based on the autoconf builtin
dnl macros, and you can do what you want with them.
dnl
dnl Maurice LeBrun
dnl IFS, University of Texas at Austin
dnl 14-Jul-1994
dnl
dnl Copyright (C) 2003, 2004  Rafael Laboissiere
dnl Copyright (C) 2004  Alan W. Irwin
dnl
dnl This file is part of PLplot.
dnl
dnl PLplot is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Library Public License as published
dnl by the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl PLplot is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU Library General Public License for more details.
dnl
dnl You should have received a copy of the GNU Library General Public License
dnl along with PLplot; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
dnl
dnl ------------------------------------------------------------------------
dnl It's kind of nice to have an include macro.
dnl
define([PL_INCLUDE],[builtin([include],$*)])dnl
dnl
dnl ------------------------------------------------------------------------
dnl This quicky is good during development, e.g. PL_IGNORE([ ... ]) to
dnl ignore everything inside the brackets.
dnl
define([PL_IGNORE],)dnl
dnl
dnl ------------------------------------------------------------------------
dnl The following macros search a list of directories for the given
dnl include file and takes appropriate actions if found or not.
dnl Arguments:
dnl 	$1 - the include file name, the part before the .h
dnl	$2 - a variable that holds the matched directory name
dnl	$3 - a variable indicating if the search succeeded ("yes"/"no")
dnl	     (if missing, we exit)
dnl Use just FIND_INC, or the FIND_INC_<...> set for more control.
dnl
define(FIND_INC_BEGIN, [
    AC_MSG_CHECKING(for $1.h)
    $2=""
])
define(FIND_INC_SET, [
    for dir in $incdirs; do
	if test -r "$dir/$1.h"; then
	    $2="$dir"
	    AC_MSG_RESULT($dir/$1.h)
	    break
	fi
    done
])
define(FIND_INC_END, [
    if test -z "$$2"; then
	ifelse($3,,[
	    AC_MSG_RESULT(not found -- exiting)
	    exit 1
	],[
	    AC_MSG_RESULT(no)
	    AC_MSG_RESULT([warning: can't find $1.h, setting $3 to no])
	    $3="no"
	])
    fi
    if test "$$2" = "/usr/include"; then
	$2="default"
    fi
])
define(FIND_INC, [
    FIND_INC_BEGIN($*)
    FIND_INC_SET($*)
    FIND_INC_END($*)
])
dnl ------------------------------------------------------------------------
dnl The following macro searches a list of directories for the given
dnl library file and takes appropriate actions if found or not.
dnl Use just FIND_LIB, or the FIND_LIB_<...> set for more control.
dnl
dnl Arguments:
dnl 	$1 - the library name, the part after the -l and before the "."
dnl	$2 - a variable that holds the matched directory name
dnl
dnl FIND_LIB_SET takes:
dnl	$3 - a variable that holds the matched library name in a form
dnl	     suitable for input to the linker (without the suffix, so that
dnl	     any shared library form is given preference).
dnl
dnl FIND_LIB_END takes:
dnl	$3 - a variable indicating if the search succeeded ("yes"/"no")
dnl	     (if missing, we exit)
dnl
dnl FIND_LIB takes these as $3 and $4, respectively.
dnl
define(FIND_LIB_BEGIN, [
    AC_MSG_CHECKING(for lib$1)
    $2=""
])
define(FIND_LIB_SET, [
    for dir in $libdirs; do
	if test -z "$LIBEXTNS"; then
	    LIBEXTNS="so a"
	fi
	for suffix in $LIBEXTNS; do
	    if test -f "$dir/lib$1.$suffix"; then
		$2="$dir"
		$3="-l$1"
		AC_MSG_RESULT($dir/lib$1.$suffix)
		break 2
	    fi
	done
    done
])
define(FIND_LIB_END, [
    if test -z "$$2"; then
	ifelse($3,,[
	    AC_MSG_ERROR(not found -- exiting)
	],[
	    AC_MSG_RESULT(no)
	    AC_MSG_WARN([can't find lib$1, setting $3 to no])
	    $3="no"
	])
    fi
    if test "$$2" = "/usr/lib"; then
	$2="default"
    fi
])
define(FIND_LIB, [
    FIND_LIB_BEGIN($1, $2)
    FIND_LIB_SET($1, $2, $3)
    FIND_LIB_END($1, $2, $4)
])
dnl ------------------------------------------------------------------------
dnl The following macro makes it easier to add includes without adding
dnl redundant -I specifications (to keep the build line concise).
dnl Arguments:
dnl 	$1 - the searched directory name
dnl	$2 - a variable that holds the include specification
dnl	$3 - a variable that holds all the directories searched so far
dnl
define([ADD_TO_INCS],[
    INCSW=""
    if test "$1" != "default"; then
	INCSW="-I$1"
    fi
    for dir in $$3; do
	if test "$1" = "$dir"; then
	    INCSW=""
	    break
	fi
    done
    if test -n "$INCSW"; then
	$2="$$2 $INCSW"
    fi
    $3="$$3 $1"
])
dnl ------------------------------------------------------------------------
dnl The following macro makes it easier to add libs without adding
dnl redundant -L and -l specifications (to keep the build line concise).
dnl Arguments:
dnl 	$1 - the searched directory name
dnl	$2 - the command line option to give to the linker (e.g. -lfoo)
dnl	$3 - a variable that holds the library specification
dnl	$4 - a variable that holds all the directories searched so far
dnl
define([ADD_TO_LIBS],[
    LIBSW=""
    if test "$1" != "default"; then
	LIBSW="-L$1"
    fi
    for dir in $$4; do
	if test "$1" = "$dir"; then
	    LIBSW=""
	    break
	fi
    done
    LIBL="$2"
    for lib in $$3; do
	if test "$2" = "$lib"; then
	    LIBL=""
	    break
	fi
    done
    if test -n "$LIBSW"; then
	$3="$$3 $LIBSW $LIBL"
    else
	$3="$$3 $LIBL"
    fi
    $4="$$4 $1"
])
dnl ------------------------------------------------------------------------
dnl Front-end macros to the above, which when:
dnl  - a with-<opt> is registered, the corresponding enable-<opt> is
dnl	registered as bogus
dnl  - an enable-<opt> is registered, the corresponding with-<opt> is
dnl	registered as bogus
dnl
AC_DEFUN([MY_ARG_WITH],
[AC_ARG_WITH($@)dnl
AC_ARG_ENABLE([$1],[],[AC_MSG_ERROR([unrecognized variable: enable_$1])])])
dnl
AC_DEFUN([MY_ARG_ENABLE],
[AC_ARG_ENABLE($@)dnl
AC_ARG_WITH([$1],[],[AC_MSG_ERROR([unrecognized variable: with_$1])])])
dnl ------------------------------------------------------------------------
dnl Get rid of caching since it doesn't always work.  I.e. changing the
dnl compiler from the vendor's to gcc can change all sorts of settings,
dnl but the autoconf logic isn't set up to handle that.  I'll opt for
dnl stability over speed any day.
dnl
define([AC_CACHE_LOAD],)
define([AC_CACHE_SAVE],)
dnl ------------------------------------------------------------------------
dnl Define the package version
AC_DEFUN([PLPLOT_PACKAGE_VERSION],
[builtin(include, version.in)
PLPLOT_VERSION=$MAJOR_VERSION.$MINOR_VERSION.$RELEASE_VERSION
AC_SUBST(MAJOR_VERSION)
AC_SUBST(MINOR_VERSION)
AC_SUBST(RELEASE_VERSION)
AC_SUBST(PLPLOT_VERSION)
AC_DEFINE_UNQUOTED(PLPLOT_VERSION, "$PLPLOT_VERSION")])
dnl ------------------------------------------------------------------------
dnl GTK configuration function.
dnl Adapted from that distributed by the GTK Project
dnl Added by Rafael Laboissiere on Fri Feb 23 21:26:56 CET 2001
dnl
# Configure paths for GTK+
# Owen Taylor     97-11-3

dnl AM_PATH_GTK([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND [, MODULES]]]])
dnl Test for GTK, and define GTK_CFLAGS and GTK_LIBS
dnl
AC_DEFUN(AM_PATH_GTK,
[dnl
dnl Get the cflags and libraries from the gtk-config script
dnl
AC_ARG_WITH(gtk-prefix,[  --with-gtk-prefix=PFX   Prefix where GTK is installed (optional)],
            gtk_config_prefix="$withval", gtk_config_prefix="")
AC_ARG_WITH(gtk-exec-prefix,[  --with-gtk-exec-prefix=PFX Exec prefix where GTK is installed (optional)],
            gtk_config_exec_prefix="$withval", gtk_config_exec_prefix="")
AC_ARG_ENABLE(gtktest, [  --disable-gtktest       Do not try to compile and run a test GTK program],
		    , enable_gtktest=yes)

  for module in . $4
  do
      case "$module" in
         gthread)
             gtk_config_args="$gtk_config_args gthread"
         ;;
      esac
  done

  if test x$gtk_config_exec_prefix != x ; then
     gtk_config_args="$gtk_config_args --exec-prefix=$gtk_config_exec_prefix"
     if test x${GTK_CONFIG+set} != xset ; then
        GTK_CONFIG=$gtk_config_exec_prefix/bin/gtk-config
     fi
  fi
  if test x$gtk_config_prefix != x ; then
     gtk_config_args="$gtk_config_args --prefix=$gtk_config_prefix"
     if test x${GTK_CONFIG+set} != xset ; then
        GTK_CONFIG=$gtk_config_prefix/bin/gtk-config
     fi
  fi

  AC_PATH_PROG(GTK_CONFIG, gtk-config, no)
  min_gtk_version=ifelse([$1], ,0.99.7,$1)
  AC_MSG_CHECKING(for GTK - version >= $min_gtk_version)
  no_gtk=""
  if test "$GTK_CONFIG" = "no" ; then
    no_gtk=yes
  else
    GTK_CFLAGS=`$GTK_CONFIG $gtk_config_args --cflags`
    GTK_LIBS=`$GTK_CONFIG $gtk_config_args --libs`
    gtk_config_major_version=`$GTK_CONFIG $gtk_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
    gtk_config_minor_version=`$GTK_CONFIG $gtk_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
    gtk_config_micro_version=`$GTK_CONFIG $gtk_config_args --version | \
           sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`
    if test "x$enable_gtktest" = "xyes" ; then
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $GTK_CFLAGS"
      LIBS="$GTK_LIBS $LIBS"
dnl
dnl Now check if the installed GTK is sufficiently new. (Also sanity
dnl checks the results of gtk-config to some extent
dnl
      rm -f conf.gtktest
      AC_TRY_RUN([
#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>

int
main ()
{
  int major, minor, micro;
  char *tmp_version;

  system ("touch conf.gtktest");

  /* HP/UX 9 (%@#!) writes to sscanf strings */
  tmp_version = g_strdup("$min_gtk_version");
  if (sscanf(tmp_version, "%d.%d.%d", &major, &minor, &micro) != 3) {
     printf("%s, bad version string\n", "$min_gtk_version");
     exit(1);
   }

  if ((gtk_major_version != $gtk_config_major_version) ||
      (gtk_minor_version != $gtk_config_minor_version) ||
      (gtk_micro_version != $gtk_config_micro_version))
    {
      printf("\n*** 'gtk-config --version' returned %d.%d.%d, but GTK+ (%d.%d.%d)\n",
             $gtk_config_major_version, $gtk_config_minor_version, $gtk_config_micro_version,
             gtk_major_version, gtk_minor_version, gtk_micro_version);
      printf ("*** was found! If gtk-config was correct, then it is best\n");
      printf ("*** to remove the old version of GTK+. You may also be able to fix the error\n");
      printf("*** by modifying your LD_LIBRARY_PATH enviroment variable, or by editing\n");
      printf("*** /etc/ld.so.conf. Make sure you have run ldconfig if that is\n");
      printf("*** required on your system.\n");
      printf("*** If gtk-config was wrong, set the environment variable GTK_CONFIG\n");
      printf("*** to point to the correct copy of gtk-config, and remove the file config.cache\n");
      printf("*** before re-running configure\n");
    }
#if defined (GTK_MAJOR_VERSION) && defined (GTK_MINOR_VERSION) && defined (GTK_MICRO_VERSION)
  else if ((gtk_major_version != GTK_MAJOR_VERSION) ||
	   (gtk_minor_version != GTK_MINOR_VERSION) ||
           (gtk_micro_version != GTK_MICRO_VERSION))
    {
      printf("*** GTK+ header files (version %d.%d.%d) do not match\n",
	     GTK_MAJOR_VERSION, GTK_MINOR_VERSION, GTK_MICRO_VERSION);
      printf("*** library (version %d.%d.%d)\n",
	     gtk_major_version, gtk_minor_version, gtk_micro_version);
    }
#endif /* defined (GTK_MAJOR_VERSION) ... */
  else
    {
      if ((gtk_major_version > major) ||
        ((gtk_major_version == major) && (gtk_minor_version > minor)) ||
        ((gtk_major_version == major) && (gtk_minor_version == minor) && (gtk_micro_version >= micro)))
      {
        return 0;
       }
     else
      {
        printf("\n*** An old version of GTK+ (%d.%d.%d) was found.\n",
               gtk_major_version, gtk_minor_version, gtk_micro_version);
        printf("*** You need a version of GTK+ newer than %d.%d.%d. The latest version of\n",
	       major, minor, micro);
        printf("*** GTK+ is always available from ftp://ftp.gtk.org.\n");
        printf("***\n");
        printf("*** If you have already installed a sufficiently new version, this error\n");
        printf("*** probably means that the wrong copy of the gtk-config shell script is\n");
        printf("*** being found. The easiest way to fix this is to remove the old version\n");
        printf("*** of GTK+, but you can also set the GTK_CONFIG environment to point to the\n");
        printf("*** correct copy of gtk-config. (In this case, you will have to\n");
        printf("*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n");
        printf("*** so that the correct libraries are found at run-time))\n");
      }
    }
  return 1;
}
],, no_gtk=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
       CFLAGS="$ac_save_CFLAGS"
       LIBS="$ac_save_LIBS"
     fi
  fi
  if test "x$no_gtk" = x ; then
     AC_MSG_RESULT(yes)
     ifelse([$2], , :, [$2])
  else
     AC_MSG_RESULT(no)
     if test "$GTK_CONFIG" = "no" ; then
       echo "*** The gtk-config script installed by GTK could not be found"
       echo "*** If GTK was installed in PREFIX, make sure PREFIX/bin is in"
       echo "*** your path, or set the GTK_CONFIG environment variable to the"
       echo "*** full path to gtk-config."
     else
       if test -f conf.gtktest ; then
        :
       else
          echo "*** Could not run GTK test program, checking why..."
          CFLAGS="$CFLAGS $GTK_CFLAGS"
          LIBS="$LIBS $GTK_LIBS"
          AC_TRY_LINK([
#include <gtk/gtk.h>
#include <stdio.h>
],      [ return ((gtk_major_version) || (gtk_minor_version) || (gtk_micro_version)); ],
        [ echo "*** The test program compiled, but did not run. This usually means"
          echo "*** that the run-time linker is not finding GTK or finding the wrong"
          echo "*** version of GTK. If it is not finding GTK, you'll need to set your"
          echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point"
          echo "*** to the installed location  Also, make sure you have run ldconfig if that"
          echo "*** is required on your system"
	  echo "***"
          echo "*** If you have an old version installed, it is best to remove it, although"
          echo "*** you may also be able to get things to work by modifying LD_LIBRARY_PATH"
          echo "***"
          echo "*** If you have a RedHat 5.0 system, you should remove the GTK package that"
          echo "*** came with the system with the command"
          echo "***"
          echo "***    rpm --erase --nodeps gtk gtk-devel" ],
        [ echo "*** The test program failed to compile or link. See the file config.log for the"
          echo "*** exact error that occured. This usually means GTK was incorrectly installed"
          echo "*** or that you have moved GTK since it was installed. In the latter case, you"
          echo "*** may want to edit the gtk-config script: $GTK_CONFIG" ])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
       fi
     fi
     GTK_CFLAGS=""
     GTK_LIBS=""
     ifelse([$3], , :, [$3])
  fi
  AC_SUBST(GTK_CFLAGS)
  AC_SUBST(GTK_LIBS)
  rm -f conf.gtktest

])

dnl ------------------------------------------------------------------------
dnl Gnome configuration function.
dnl Adapted from that distributed by the Gnome Project
dnl Added by Rafael Laboissiere on Fri Feb 23 21:26:56 CET 2001
dnl
dnl GNOME_INIT_HOOK (script-if-gnome-enabled, [failflag], [additional-inits])
dnl
dnl if failflag is "fail" then GNOME_INIT_HOOK will abort if gnomeConf.sh
dnl is not found.
dnl

AC_DEFUN([GNOME_INIT_HOOK],[
	AC_SUBST(GNOME_LIBS)
	AC_SUBST(GNOMEUI_LIBS)
dnl	AC_SUBST(GNOMEGNORBA_LIBS)
dnl	AC_SUBST(GTKXMHTML_LIBS)
dnl	AC_SUBST(ZVT_LIBS)
	AC_SUBST(GNOME_LIBDIR)
	AC_SUBST(GNOME_INCLUDEDIR)

	AC_ARG_WITH(gnome-includes,
	[  --with-gnome-includes   Specify location of GNOME headers],[
	CFLAGS="$CFLAGS -I$withval"
	])

	AC_ARG_WITH(gnome-libs,
	[  --with-gnome-libs       Specify location of GNOME libs],[
	LDFLAGS="$LDFLAGS -L$withval"
	gnome_prefix=$withval
	])

	AC_ARG_WITH(gnome,
	[  --with-gnome            Specify prefix for GNOME files],
		if test x$withval = xyes; then
	    		want_gnome=yes
	    		dnl Note that an empty true branch is not
			dnl valid sh syntax.
	    		ifelse([$1], [], :, [$1])
        	else
	    		if test "x$withval" = xno; then
	        		want_gnome=no
	    		else
	        		want_gnome=yes
	    			LDFLAGS="$LDFLAGS -L$withval/lib"
	    			CFLAGS="$CFLAGS -I$withval/include"
	    			gnome_prefix=$withval/lib
	    		fi
  		fi,
		want_gnome=yes)

	if test "x$want_gnome" = xyes; then

	    AC_PATH_PROG(GNOME_CONFIG,gnome-config,no)
	    if test "$GNOME_CONFIG" = "no"; then
	      no_gnome_config="yes"
	    else
	      AC_MSG_CHECKING(if $GNOME_CONFIG works)
	      if $GNOME_CONFIG --libs-only-l gnome >/dev/null 2>&1; then
	        AC_MSG_RESULT(yes)
dnl	        GNOME_GNORBA_HOOK([],$2)
	        GNOME_LIBS="`$GNOME_CONFIG --libs-only-l gnome`"
	        GNOMEUI_LIBS="`$GNOME_CONFIG --libs-only-l gnomeui`"
dnl	        GNOMEGNORBA_LIBS="`$GNOME_CONFIG --libs-only-l gnorba gnomeui`"
dnl	        GTKXMHTML_LIBS="`$GNOME_CONFIG --libs-only-l gtkxmhtml`"
dnl		ZVT_LIBS="`$GNOME_CONFIG --libs-only-l zvt`"
	        GNOME_LIBDIR="`$GNOME_CONFIG --libs-only-L gnorba gnomeui`"
	        GNOME_INCLUDEDIR="`$GNOME_CONFIG --cflags gnorba gnomeui`"
                $1
	      else
	        AC_MSG_RESULT(no)
	        no_gnome_config="yes"
              fi
            fi

	    if test x$exec_prefix = xNONE; then
	        if test x$prefix = xNONE; then
		    gnome_prefix=$ac_default_prefix/lib
	        else
 		    gnome_prefix=$prefix/lib
	        fi
	    else
	        gnome_prefix=`eval echo \`echo $libdir\``
	    fi

	    if test "$no_gnome_config" = "yes"; then
              AC_MSG_CHECKING(for gnomeConf.sh file in $gnome_prefix)
	      if test -f $gnome_prefix/gnomeConf.sh; then
	        AC_MSG_RESULT(found)
	        echo "loading gnome configuration from" \
		     "$gnome_prefix/gnomeConf.sh"
	        . $gnome_prefix/gnomeConf.sh
	        $1
	      else
	        AC_MSG_RESULT(not found)
 	        if test x$2 = xfail; then
	          AC_MSG_ERROR(Could not find the gnomeConf.sh file that is generated by gnome-libs install)
 	        fi
	      fi
            fi
	fi

	if test -n "$3"; then
	  n="$3"
	  for i in $n; do
	    AC_MSG_CHECKING(extra library \"$i\")
	    case $i in
	      applets)
		AC_SUBST(GNOME_APPLETS_LIBS)
		GNOME_APPLETS_LIBS=`$GNOME_CONFIG --libs-only-l applets`
		AC_MSG_RESULT($GNOME_APPLETS_LIBS);;
	      capplet)
		AC_SUBST(GNOME_CAPPLET_LIBS)
		GNOME_CAPPLET_LIBS=`$GNOME_CONFIG --libs-only-l capplet`
		AC_MSG_RESULT($GNOME_CAPPLET_LIBS);;
	      *)
		AC_MSG_RESULT(unknown library)
	    esac
	  done
	fi
])

dnl
dnl GNOME_INIT ([additional-inits])
dnl

AC_DEFUN([GNOME_INIT],[
	GNOME_INIT_HOOK([],fail,$1)
])
dnl ------------------------------------------------------------------------
dnl AC substitution of stripped paths
dnl     AC_SUBST_STRIP(PATH,PREFIX)
dnl Essentially, do an AC_SUBST of PATH variable, but previously suppress
dnl the leading PREFIX.
dnl This is needed for relocatability, i.e. installing the package in a
dnl different prefix from that used at build time.
dnl Added by Rafael Laboissiere on Wed Mar 21 22:57:57 CET 2001
AC_DEFUN([AC_SUBST_STRIP],[
  $1=`echo $]$1[ | sed s%$]$2[/%%`
  AC_SUBST($1)
])
dnl Available from the GNU Autoconf Macro Archive at:
dnl http://www.gnu.org/software/ac-archive/htmldoc/check_gnu_make.html
dnl
AC_DEFUN(
        [CHECK_GNU_MAKE], [ AC_CACHE_CHECK( for GNU make,_cv_gnu_make_command,
                _cv_gnu_make_command='' ;
dnl Search all the common names for GNU make
                for a in "$MAKE" make gmake gnumake ; do
                        if test -z "$a" ; then continue ; fi ;
                        if  ( sh -c "$a --version" 2> /dev/null | grep GNU  2>&1 > /dev/null ) ;  then
                                _cv_gnu_make_command=$a ;
                                break;
                        fi
                done ;
        ) ;
dnl If there was a GNU version, then set @ifGNUmake@ to the empty string, '#' otherwise
        if test  "x$_cv_gnu_make_command" != "x"  ; then
                ifGNUmake='' ;
        else
                ifGNUmake='#' ;
                AC_MSG_RESULT("Not found");
        fi
        AC_SUBST(ifGNUmake)
] )
dnl ------------------------------------------------------------------------
dnl Determine the dlname of a library to be installed by libtool
dnl     PL_GET_DLNAME(STEM,VERSION_INFO,VARIABLE)
dnl For a given library STEM and a given VERSION_INFO (a la
dnl -version-info option of libtool), determine the dlname of the
dnl library in the form lib$STEM.<so_ext>.<so_number>.  Set the
dnl variable VARIABLE with the resulting value.  This macro should be used
dnl only after the call to AM_PROG_LIBTOOL.
AC_DEFUN([PL_GET_DLNAME],[
  if test -z "$LIBTOOL" -a -z "$CC" ; then
    AC_MSG_ERROR([Dlname guessings can be done only after libtool is initialized])
  else
    TMP_DIR=./tmp-cfg
    rm -rf $TMP_DIR
    mkdir -p $TMP_DIR
    cd $TMP_DIR
    ../libtool --mode=link $CC -rpath /usr/lib -version-info $2 \
        -o lib$1.la > /dev/null
    $3=`grep ^dlname= lib$1.la | sed "s/dlname='\(.*\)'/\1/"`
    cd ..
    rm -rf $TMP_DIR
  fi
])
dnl ------------------------------------------------------------------------
dnl Determine the dlname of a DLL to be installed by libtool
dnl This is a usefule variation of GET_DLNAME above for dynamically loaded
dnd libraries (DLL's).
dnl     PL_GET_DLLNAME(STEM,VARIABLE)
dnl For a given DLL STEM determine the dlname of the
dnl library in the form $STEM.<so_ext>.  Set the
dnl variable VARIABLE with the resulting value.  This macro should be used
dnl only after the call to AM_PROG_LIBTOOL.
AC_DEFUN([PL_GET_DLLNAME],[
  if test -z "$LIBTOOL" -a -z "$CC" ; then
    AC_MSG_ERROR([Dlname guessings can be done only after libtool is initialized])
  else
    TMP_DIR=./tmp-cfg
    rm -rf $TMP_DIR
    mkdir -p $TMP_DIR
    cd $TMP_DIR
    ../libtool --mode=link $CC -rpath /usr/lib -avoid-version -module \
        -o $1.la > /dev/null
    $2=`grep ^dlname= $1.la | sed "s/dlname='\(.*\)'/\1/"`
    cd ..
    rm -rf $TMP_DIR
  fi
])
dnl ------------------------------------------------------------------------
dnl PL_EXPAND_EXPRESSION(VARIABLE,EXPRESSION)
dnl
dnl Expand recursively a given EXPRESSION, until no variable expansion is
dnl possible.  Put the result in VARIABLE.
AC_DEFUN([PL_EXPAND_EXPRESSION],[
  str1="$2"
  while true ; do
   str2=`eval echo $str1`
     test "$str1" = "$str2" && break
     str1="$str2"
   done
   $1="$str2"])
