!***********************************************************************
!  plplot_binding.f90
!
!  Copyright (C) 2005-2016  Arjen Markus
!  Copyright (C) 2006-2016 Alan W. Irwin
!
!  This file is part of PLplot.
!
!  PLplot is free software; you can redistribute it and/or modify
!  it under the terms of the GNU Library General Public License as published
!  by the Free Software Foundation; either version 2 of the License, or
!  (at your option) any later version.
!
!  PLplot is distributed in the hope that it will be useful,
!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!  GNU Library General Public License for more details.
!
!  You should have received a copy of the GNU Library General Public License
!  along with PLplot; if not, write to the Free Software
!  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
!
!
!  This file is a limited version of what should become the new style
!  Fortran bindings. It is geared to example x00f only.
!
!***********************************************************************

module plplot_types
  use iso_c_binding, only: c_ptr
  implicit none
  ! Specify Fortran types used by the various modules below.

  ! N.B. It is those modules' responsibility to keep these precision values
  ! private.

  ! These types are used along with function overloading so that
  ! applications do not need a specific real type at all (under the
  ! constraint that all real arguments must have consistent real type
  ! for a particular call to a routine in the Fortran binding of
  ! PLplot.)

  ! This include file only defines the private_plflt parameter at the
  ! moment which is configured to be either kind(1.0) or kind(1.0d0)
  ! to agree with the configured real precision (PLFLT) of the PLplot
  ! C library.
    include 'included_plplot_configured_types.f90'
    
  ! The idea here is to match the Fortran 4-byte integer with the
  ! corresponding C types for PLINT (normally int32_t), PLBOOL
  ! (currently typedefed to PLINT) and PLUNICODE (normally
  ! uint32_t).  According to websites I have read, Fortran has no
  ! unsigned integer types and using 4 here is safer than anything more
  ! complicated.
  integer, parameter :: private_plint  = 4
  integer, parameter :: private_plbool  = 4
  integer, parameter :: private_plunicode  = 4

  ! Define parameters for specific real precisions, so that we can
  ! specify equivalent interfaces for all precisions (kinds)
  integer, parameter :: private_single  = kind(1.0)
  integer, parameter :: private_double  = kind(1.0d0)

  private :: c_ptr

  ! The PLfGrid and PLcGrid types transfer information about a multidimensional
  ! array to the plcontour/plshade family of routines.

  type, bind(c) :: PLfGrid
     type(c_ptr) :: f
     integer(kind=private_plint) :: nx, ny, nz
  end type PLfGrid

  type, bind(c) :: PLcGrid
     type(c_ptr) :: xg, yg, zg
     integer(kind=private_plint) :: nx, ny, nz
  end type PLcGrid
end module plplot_types

module plplot_graphics
  use plplot_types, only: private_plint, private_plflt
  implicit none
  private :: private_plint, private_plflt

  ! This derived type is a direct equivalent of the C struct.
  ! There is no advantage in distinguishing different versions
  ! with different precision.
  type, bind(c) :: PLGraphicsIn
     integer(kind=private_plint) :: type           ! of event (CURRENTLY UNUSED)
     integer(kind=private_plint) :: state          ! key or button mask
     integer(kind=private_plint) :: keysym         ! key selected
     integer(kind=private_plint) :: button         ! mouse button selected
     integer(kind=private_plint) :: subwindow      ! subwindow (alias subpage, alias subplot) number
     character(len=16)           :: string         ! translated string
     integer(kind=private_plint) :: pX, pY         ! absolute device coordinates of pointer
     real(kind=private_plflt)    :: dX, dY         ! relative device coordinates of pointer
     real(kind=private_plflt)    :: wX, wY         ! world coordinates of pointer
  end type PLGraphicsIn

  interface
     subroutine plGetCursor( gin ) bind(c,name='plGetCursor')
       use iso_c_binding, only:  c_ptr
       import :: PLGraphicsIn
       implicit none
       type(PLGraphicsIn), intent(out) :: gin
     end subroutine plGetCursor
  end interface

end module plplot_graphics

! The bind(c) attribute exposes the pltr routine which ought to be private
module plplot_private_exposed
    use iso_c_binding, only: c_ptr
    use plplot_types, only: private_plflt
    implicit none
    private :: c_ptr, private_plflt
contains
subroutine plplot_private_pltr( x, y, tx, ty, tr ) bind(c)
   real(kind=private_plflt), value, intent(in) :: x, y
   real(kind=private_plflt), intent(out) :: tx, ty
   real(kind=private_plflt), dimension(*), intent(in) :: tr

   tx = tr(1) * x + tr(2) * y + tr(3)
   ty = tr(4) * x + tr(5) * y + tr(6)
end subroutine plplot_private_pltr

subroutine plplot_private_pltr0f( x, y, tx, ty, data ) bind(c)
   real(kind=private_plflt), value, intent(in) :: x, y
   real(kind=private_plflt), intent(out) :: tx, ty
   type(c_ptr), value, intent(in) :: data

   tx = x + 1.0_private_plflt
   ty = y + 1.0_private_plflt
end subroutine plplot_private_pltr0f
end module plplot_private_exposed

module plplot_single
    use iso_c_binding, only: c_ptr, c_char, c_null_char, c_null_ptr, c_loc,  c_funptr, c_null_funptr, c_funloc
    use iso_fortran_env, only: error_unit
    use plplot_types, only: private_plflt, private_plint, private_plbool, private_single, PLcGrid, PLfGrid
    use plplot_private_exposed
    implicit none

    integer, parameter :: wp = private_single
    private :: c_ptr, c_char, c_null_char, c_null_ptr, c_loc, c_funptr, c_null_funptr, c_funloc
    private :: error_unit
    private :: private_plflt, private_plint, private_plbool, private_single, PLcGrid, PLfGrid
    private :: wp

! Interfaces for single-precision callbacks

    abstract interface
        subroutine plmapform_proc_single( x, y )
            import :: wp
            real(kind=wp), dimension(:), intent(inout) :: x, y
        end subroutine plmapform_proc_single
    end interface
    procedure(plmapform_proc_single), pointer :: plmapform_single

    abstract interface
        subroutine pllabeler_proc_single( axis, value, label )
            import :: wp
            integer, intent(in) :: axis
            real(kind=wp), intent(in) :: value
            character(len=*), intent(out) :: label
        end subroutine pllabeler_proc_single
    end interface
    procedure(pllabeler_proc_single), pointer :: pllabeler_single

    abstract interface
        subroutine pllabeler_proc_data_single( axis, value, label, data )
            import :: wp, c_ptr
            integer, intent(in) :: axis
            real(kind=wp), intent(in) :: value
            character(len=*), intent(out) :: label
            type(c_ptr), intent(in) :: data
        end subroutine pllabeler_proc_data_single
    end interface
    procedure(pllabeler_proc_data_single), pointer :: pllabeler_data_single

    abstract interface
        subroutine pltransform_proc_single( x, y, tx, ty )
            import :: wp
            real(kind=wp), intent(in) :: x, y
            real(kind=wp), intent(out) :: tx, ty
        end subroutine pltransform_proc_single
    end interface
    procedure(pltransform_proc_single), pointer :: pltransform_single

    abstract interface
        subroutine pltransform_proc_data_single( x, y, tx, ty, data )
            import :: wp, c_ptr
            real(kind=wp), intent(in) :: x, y
            real(kind=wp), intent(out) :: tx, ty
            type(c_ptr), intent(in) :: data
        end subroutine pltransform_proc_data_single
    end interface
    procedure(pltransform_proc_data_single), pointer :: pltransform_data_single

    include 'included_plplot_real_interfaces.f90'

! Single-precision callback routines:

    subroutine pllabelerf2c_single( axis, value, label, length, data ) bind(c, name = 'plplot_private_pllabeler2c_single')
      integer(kind=private_plint), value, intent(in) :: axis, length
      real(kind=private_plflt), value, intent(in) :: value
      character(len=1), dimension(*), intent(out) :: label
      type(c_ptr), intent(in) :: data

      character(len=:), allocatable :: label_out
      allocate(character(length) :: label_out)

      call pllabeler_single( int(axis), real(value,kind=wp), label_out )
      label(1:length) = trim(label_out)//c_null_char

      deallocate(label_out)
    end subroutine pllabelerf2c_single

    subroutine pllabelerf2c_data_single( axis, value, label, length, data ) bind(c, name = 'plplot_private_pllabeler2c_data_single')
      integer(kind=private_plint), value, intent(in) :: axis, length
      real(kind=private_plflt), value, intent(in) :: value
      character(len=1), dimension(*), intent(out) :: label
      type(c_ptr), intent(in) :: data

      character(len=:), allocatable :: label_out
      allocate(character(length) :: label_out)

      call pllabeler_data_single( int(axis), real(value,kind=wp), label_out, data )
      label(1:length) = trim(label_out)//c_null_char

      deallocate(label_out)
    end subroutine pllabelerf2c_data_single

    subroutine pltransformf2c_single( x, y, tx, ty, data ) bind(c, name = 'plplot_private_pltransform2c_single')
        real(kind=private_plflt), value, intent(in) :: x, y
        real(kind=private_plflt), intent(out) :: tx, ty
        type(c_ptr), value, intent(in) :: data

        real(kind=wp) :: tx_out, ty_out

        call pltransform_single( real(x,kind=wp), real(y,kind=wp), tx_out, ty_out )
        tx = tx_out
        ty = ty_out
    end subroutine pltransformf2c_single

    subroutine pltransformf2c_data_single( x, y, tx, ty, data ) bind(c, name = 'plplot_private_pltransform2c_data_single')
        real(kind=private_plflt), value, intent(in) :: x, y
        real(kind=private_plflt), intent(out) :: tx, ty
        type(c_ptr), value, intent(in) :: data

        real(kind=wp) :: tx_out, ty_out

        call pltransform_data_single( real(x,kind=wp), real(y,kind=wp), tx_out, ty_out, data )
        tx = tx_out
        ty = ty_out
    end subroutine pltransformf2c_data_single

end module plplot_single

module plplot_double
    use iso_c_binding, only: c_ptr, c_char, c_null_char, c_null_ptr, c_loc, c_funptr, c_null_funptr, c_funloc
    use iso_fortran_env, only: error_unit
    use plplot_types, only: private_plflt, private_plint, private_plbool, private_double, PLcGrid, PLfGrid
    use plplot_private_exposed
    implicit none

    integer, parameter :: wp = private_double
    private :: c_ptr, c_char, c_null_char, c_null_ptr, c_loc, c_funptr, c_null_funptr, c_funloc
    private :: error_unit
    private :: private_plflt, private_plint, private_plbool, private_double, PLcGrid, PLfGrid
    private :: wp

! Interfaces for double-precision callbacks

    abstract interface
        subroutine plmapform_proc_double( x, y )
            import :: wp
            real(kind=wp), dimension(:), intent(inout) :: x, y
        end subroutine plmapform_proc_double
    end interface
    procedure(plmapform_proc_double), pointer :: plmapform_double

    abstract interface
        subroutine pllabeler_proc_double( axis, value, label )
            import :: wp
            integer, intent(in) :: axis
            real(kind=wp), intent(in) :: value
            character(len=*), intent(out) :: label
        end subroutine pllabeler_proc_double
    end interface
    procedure(pllabeler_proc_double), pointer :: pllabeler_double

    abstract interface
        subroutine pllabeler_proc_data_double( axis, value, label, data )
            import :: wp, c_ptr
            integer, intent(in) :: axis
            real(kind=wp), intent(in) :: value
            character(len=*), intent(out) :: label
            type(c_ptr), intent(in) :: data
        end subroutine pllabeler_proc_data_double
    end interface
    procedure(pllabeler_proc_data_double), pointer :: pllabeler_data_double

    abstract interface
        subroutine pltransform_proc_double( x, y, tx, ty )
            import :: wp
            real(kind=wp), intent(in) :: x, y
            real(kind=wp), intent(out) :: tx, ty
        end subroutine pltransform_proc_double
    end interface
    procedure(pltransform_proc_double), pointer :: pltransform_double

    abstract interface
        subroutine pltransform_proc_data_double( x, y, tx, ty, data )
            import :: wp, c_ptr
            real(kind=wp), intent(in) :: x, y
            real(kind=wp), intent(out) :: tx, ty
            type(c_ptr), intent(in) :: data
        end subroutine pltransform_proc_data_double
    end interface
    procedure(pltransform_proc_data_double), pointer :: pltransform_data_double

    include 'included_plplot_real_interfaces.f90'

! Double-precision callback routines:

    subroutine pllabelerf2c_double( axis, value, label, length, data ) bind(c, name = 'plplot_private_pllabeler2c_double')
      integer(kind=private_plint), value, intent(in) :: axis, length
      real(kind=private_plflt), value, intent(in) :: value
      character(len=1), dimension(*), intent(out) :: label
      type(c_ptr), intent(in) :: data

      character(len=:), allocatable :: label_out
      integer :: trimmed_length

      allocate(character(length) :: label_out)
      call pllabeler_double( int(axis), real(value,kind=wp), label_out )
      trimmed_length = min(length,len_trim(label_out) + 1)
      label(1:trimmed_length) = transfer(trim(label_out(1:length))//c_null_char, " ", trimmed_length)
      deallocate(label_out)
    end subroutine pllabelerf2c_double

    subroutine pllabelerf2c_data_double( axis, value, label, length, data ) bind(c, name = 'plplot_private_pllabeler2c_data_double')
      integer(kind=private_plint), value, intent(in) :: axis, length
      real(kind=private_plflt), value, intent(in) :: value
      character(len=1), dimension(*), intent(out) :: label
      type(c_ptr), intent(in) :: data

      character(len=:), allocatable :: label_out
      allocate(character(length) :: label_out)

      call pllabeler_data_double( int(axis), real(value,kind=wp), label_out, data )
      label(1:length) = trim(label_out)//c_null_char

      deallocate(label_out)
    end subroutine pllabelerf2c_data_double

  subroutine pltransformf2c_double( x, y, tx, ty, data ) bind(c, name = 'plplot_private_pltransform2c_double')
        real(kind=private_plflt), value, intent(in) :: x, y
        real(kind=private_plflt), intent(out) :: tx, ty
        type(c_ptr), value, intent(in) :: data

        real(kind=wp) :: tx_out, ty_out

        call pltransform_double( real(x,kind=wp), real(y,kind=wp), tx_out, ty_out )
        tx = tx_out
        ty = ty_out
    end subroutine pltransformf2c_double

  subroutine pltransformf2c_data_double( x, y, tx, ty, data ) bind(c, name = 'plplot_private_pltransform2c_data_double')
        real(kind=private_plflt), value, intent(in) :: x, y
        real(kind=private_plflt), intent(out) :: tx, ty
        type(c_ptr), value, intent(in) :: data

        real(kind=wp) :: tx_out, ty_out

        call pltransform_data_double( real(x,kind=wp), real(y,kind=wp), tx_out, ty_out, data )
        tx = tx_out
        ty = ty_out
    end subroutine pltransformf2c_data_double

end module plplot_double

module plplot
    use plplot_single
    use plplot_double
    use plplot_types, only: private_plflt, private_plint, private_plbool, private_plunicode, private_single, private_double
    use plplot_graphics
    use iso_c_binding, only: c_ptr, c_char, c_loc, c_funloc, c_funptr, c_null_char, c_null_ptr, c_null_funptr
    implicit none
    ! For backwards compatibility define plflt, but use of this
    ! parameter is deprecated since any real precision should work
    ! for users so long as the precision of the real arguments
    ! of a given call to a PLplot routine are identical.
    integer, parameter :: plflt = private_plflt
    integer(kind=private_plint), parameter :: maxlen = 320
    character(len=1), parameter :: PL_END_OF_STRING = achar(0)
    include 'included_plplot_parameters.f90'
    private :: private_plflt, private_plint, private_plbool, private_plunicode, private_single, private_double
    private :: c_ptr, c_char, c_loc, c_funloc, c_funptr, c_null_char, c_null_ptr, c_null_funptr
    private :: copystring2f, maxlen
    private :: pltransform_single
    private :: pltransform_double
!
    ! Interfaces that do not depend on the real kind or which
    ! have optional real components (e.g., plsvect) that generate
    ! an ambiguous interface if implemented with plplot_single and plplot_double
!
    interface pl_setcontlabelformat
        module procedure pl_setcontlabelformat_impl
    end interface pl_setcontlabelformat
    private :: pl_setcontlabelformat_impl

    interface plgfci
        module procedure plgfci_impl
    end interface plgfci
    private :: plgfci_impl

    interface plscmap1
       module procedure plscmap1_impl
    end interface plscmap1
    private :: plscmap1_impl

    interface plsetopt
        module procedure plsetopt_impl
    end interface plsetopt
    private :: plsetopt_impl

    interface plsfci
        module procedure plsfci_impl
    end interface plsfci
    private :: plsfci_impl

    interface plslabelfunc
        module procedure plslabelfunc_null
        ! Only provide double-precison versions because of
        ! disambiguation problems with the corresponding
        ! single-precision versions.
        module procedure plslabelfunc_double
        module procedure plslabelfunc_data_double
    end interface plslabelfunc
    private :: plslabelfunc_null
    private :: plslabelfunc_double
    private :: plslabelfunc_data_double

    interface plstyl
        module procedure plstyl_scalar
        module procedure plstyl_n_array
        module procedure plstyl_array
    end interface plstyl
    private :: plstyl_scalar, plstyl_n_array, plstyl_array

    interface plstransform
        module procedure plstransform_null
        ! Only provide double-precison versions because of
        ! disambiguation problems with the corresponding
        ! single-precision versions.
        module procedure plstransform_double
        module procedure plstransform_data_double
    end interface plstransform
    private :: plstransform_null
    private :: plstransform_double
    private :: plstransform_data_double

    interface plsvect
       module procedure plsvect_none
       module procedure plsvect_single
       module procedure plsvect_double
    end interface plsvect
    private :: plsvect_none, plsvect_single, plsvect_double

    interface pltimefmt
        module procedure pltimefmt_impl
    end interface pltimefmt
    private :: pltimefmt_impl

    interface plxormod
        module procedure plxormod_impl
    end interface plxormod
    private :: plxormod_impl

contains

!
! Private utilities
!
subroutine copystring2f( fstring, cstring )
    character(len=*), intent(out) :: fstring
    character(len=1), dimension(:), intent(in) :: cstring

    integer :: i_local

    fstring = ' '
    do i_local = 1,min(len(fstring),size(cstring))
        if ( cstring(i_local) /= c_null_char ) then
            fstring(i_local:i_local) = cstring(i_local)
        else
            exit
        endif
    enddo

end subroutine copystring2f

!
! Interface routines
!
subroutine pl_setcontlabelformat_impl( lexp, sigdig )
   integer, intent(in) :: lexp, sigdig

   interface
       subroutine interface_pl_setcontlabelformat( lexp, sigdig ) bind(c,name='c_pl_setcontlabelformat')
           import :: private_plint
           implicit none
           integer(kind=private_plint), value, intent(in) :: lexp, sigdig
       end subroutine interface_pl_setcontlabelformat
   end interface

   call interface_pl_setcontlabelformat( int(lexp,kind=private_plint), int(sigdig,kind=private_plint) )
end subroutine pl_setcontlabelformat_impl

subroutine pladv( sub )
    integer, intent(in) :: sub
    interface
        subroutine interface_pladv( sub ) bind( c, name = 'c_pladv' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: sub
        end subroutine interface_pladv
    end interface

    call interface_pladv( int(sub,kind=private_plint) )
end subroutine pladv

subroutine plbop()
    interface
        subroutine interface_plbop() bind(c,name='c_plbop')
        end subroutine interface_plbop
     end interface
     call interface_plbop()
end subroutine plbop

subroutine plclear()
    interface
        subroutine interface_plclear() bind(c,name='c_plclear')
        end subroutine interface_plclear
     end interface
     call interface_plclear()
end subroutine plclear

subroutine plcol0( icol )
    integer, intent(in) :: icol
    interface
        subroutine interface_plcol0( icol ) bind(c, name = 'c_plcol0' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: icol
        end subroutine interface_plcol0
    end interface

    call interface_plcol0( int(icol,kind=private_plint) )
end subroutine plcol0

subroutine plcpstrm( iplsr, flags )
  integer, intent(in) :: iplsr
  logical, intent(in) :: flags
    interface
        subroutine interface_plcpstrm( iplsr, flags ) bind(c, name = 'c_plcpstrm' )
            import :: private_plint, private_plbool
            implicit none
            integer(kind=private_plint), value, intent(in) :: iplsr
            integer(kind=private_plbool), value, intent(in) :: flags
        end subroutine interface_plcpstrm
    end interface

    call interface_plcpstrm( int(iplsr,kind=private_plint), int(merge(1,0,flags),kind=private_plbool) )
end subroutine plcpstrm

subroutine plend()
    interface
        subroutine interface_plend() bind( c, name = 'c_plend' )
        end subroutine interface_plend
     end interface
     call interface_plend()
   end subroutine plend

subroutine plend1()
    interface
        subroutine interface_plend1() bind( c, name = 'c_plend1' )
        end subroutine interface_plend1
     end interface
     call interface_plend1()
end subroutine plend1

subroutine pleop()
    interface
        subroutine interface_pleop() bind( c, name = 'c_pleop' )
        end subroutine interface_pleop
     end interface
     call interface_pleop()
end subroutine pleop

subroutine plfamadv()
    interface
        subroutine interface_plfamadv() bind( c, name = 'c_plfamadv' )
        end subroutine interface_plfamadv
     end interface
     call interface_plfamadv()
end subroutine plfamadv

subroutine plflush()
    interface
        subroutine interface_plflush() bind( c, name = 'c_plflush' )
        end subroutine interface_plflush
     end interface
     call interface_plflush()
end subroutine plflush

subroutine plfont( font )
    integer, intent(in) :: font
    interface
        subroutine interface_plfont( font ) bind( c, name = 'c_plfont' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: font
        end subroutine interface_plfont
    end interface

    call interface_plfont( int(font,kind=private_plint) )
end subroutine plfont

subroutine plfontld( charset )
    integer, intent(in) :: charset
    interface
        subroutine interface_plfontld( charset ) bind( c, name = 'c_plfontld' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: charset
        end subroutine interface_plfontld
    end interface

    call interface_plfontld( int(charset,kind=private_plint) )
end subroutine plfontld

subroutine plgcol0( icol, r, g, b )
    integer, intent(in) :: icol
    integer, intent(out) :: r, g, b

    integer(kind=private_plint) :: r_out, g_out, b_out

    interface
        subroutine interface_plgcol0( icol, r, g, b ) bind( c, name = 'c_plgcol0' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: icol
            integer(kind=private_plint), intent(out) :: r, g, b
        end subroutine interface_plgcol0
    end interface

    call interface_plgcol0( int(icol,kind=private_plint), r_out, g_out, b_out )
    r = int(r_out)
    g = int(g_out)
    b = int(b_out)
end subroutine plgcol0

subroutine plgcolbg( r, g, b )
    integer, intent(out) :: r, g, b

    integer(kind=private_plint) :: r_out, g_out, b_out

    interface
        subroutine interface_plgcolbg( r, g, b ) bind( c, name = 'c_plgcolbg' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: r, g, b
        end subroutine interface_plgcolbg
    end interface

    call interface_plgcolbg( r_out, g_out, b_out )
    r = int(r_out)
    g = int(g_out)
    b = int(b_out)
end subroutine plgcolbg

subroutine plgcompression( compression )
    integer, intent(out) :: compression

    integer(kind=private_plint) :: compression_out

    interface
        subroutine interface_plgcompression( compression ) bind( c, name = 'c_plgcompression' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: compression
        end subroutine interface_plgcompression
    end interface

    call interface_plgcompression( compression_out )
    compression = int(compression_out)
end subroutine plgcompression

subroutine plgdev(dev)
    character*(*), intent(out) :: dev

    character(len=1), dimension(100) :: dev_out

    interface
        subroutine interface_plgdev( dev ) bind(c,name='c_plgdev')
            implicit none
            character(len=1), dimension(*), intent(out) :: dev
        end subroutine interface_plgdev
    end interface

    call interface_plgdev( dev_out )
    call copystring2f( dev, dev_out )
end subroutine plgdev

function plgdrawmode()

    integer :: plgdrawmode !function type

    interface
        function interface_plgdrawmode() bind(c,name='c_plgdrawmode')
            import :: private_plint
            implicit none
            integer(kind=private_plint) :: interface_plgdrawmode !function type
        end function interface_plgdrawmode
    end interface

    plgdrawmode = int(interface_plgdrawmode())
end function plgdrawmode

subroutine plgfam( fam, num, bmax )
    integer, intent(out) :: fam, num, bmax

    integer(kind=private_plint) :: fam_out, num_out, bmax_out

    interface
        subroutine interface_plgfam( fam, num, bmax ) bind( c, name = 'c_plgfam' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: fam, num, bmax
        end subroutine interface_plgfam
    end interface

    call interface_plgfam( fam_out, num_out, bmax_out )
    fam  = int(fam_out)
    num  = int(num_out)
    bmax = int(bmax_out)
end subroutine plgfam

subroutine plgfci_impl( fci )
    integer, intent(out) :: fci

    integer(kind=private_plunicode) :: fci_out

    interface
        subroutine interface_plgfci( fci ) bind( c, name = 'c_plgfci' )
            import :: private_plunicode
            implicit none
            integer(kind=private_plunicode), intent(out) :: fci
        end subroutine interface_plgfci
    end interface

    call interface_plgfci( fci_out )
    fci  = int(fci_out)
end subroutine plgfci_impl

subroutine plgfnam( fnam )
    character*(*), intent(out) :: fnam

    character(len=1), dimension(100) :: fnam_out

    interface
        subroutine interface_plgfnam( fnam ) bind(c,name='c_plgfnam')
            implicit none
            character(len=1), dimension(*), intent(out) :: fnam
        end subroutine interface_plgfnam
    end interface

    call interface_plgfnam( fnam_out )
    call copystring2f( fnam, fnam_out )
end subroutine plgfnam

subroutine plgfont( family, style, weight )
    integer, intent(out) :: family, style, weight

    integer(kind=private_plint) :: family_out, style_out, weight_out

    interface
        subroutine interface_plgfont( family, style, weight ) bind( c, name = 'c_plgfont' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: family, style, weight
        end subroutine interface_plgfont
    end interface

    call interface_plgfont( family_out, style_out, weight_out )
    family = int(family_out)
    style  = int(style_out)
    weight = int(weight_out)
end subroutine plgfont

subroutine plglevel( level )
    integer, intent(out) :: level

    integer(kind=private_plint) :: level_out

    interface
        subroutine interface_plglevel( level ) bind( c, name = 'c_plglevel' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: level
        end subroutine interface_plglevel
    end interface

    call interface_plglevel( level_out )
    level = int(level_out)
end subroutine plglevel

subroutine plgra()
    interface
        subroutine interface_plgra() bind( c, name = 'c_plgra' )
        end subroutine interface_plgra
     end interface
     call interface_plgra()
end subroutine plgra

subroutine plgstrm( strm )
    integer, intent(out) :: strm

    integer(kind=private_plint) :: strm_out

    interface
        subroutine interface_plgstrm( strm ) bind( c, name = 'c_plgstrm' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: strm
        end subroutine interface_plgstrm
    end interface

    call interface_plgstrm( strm_out )
    strm = int(strm_out)
end subroutine plgstrm

subroutine plgver(ver)
    character*(*), intent(out) :: ver

    character(len=1), dimension(100) :: ver_out

    interface
        subroutine interface_plgver( ver ) bind(c,name='c_plgver')
            implicit none
            character(len=1), dimension(*), intent(out) :: ver
        end subroutine interface_plgver
    end interface

    call interface_plgver( ver_out )
    call copystring2f( ver, ver_out )
end subroutine plgver

subroutine plgxax( digmax, digits )
    integer, intent(out) :: digmax, digits

    integer(kind=private_plint) :: digmax_out, digits_out

    interface
        subroutine interface_plgxax( digmax, digits ) bind( c, name = 'c_plgxax' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: digmax, digits
        end subroutine interface_plgxax
    end interface

    call interface_plgxax( digmax_out, digits_out )
    digmax = int(digmax_out)
    digits = int(digits_out)
end subroutine plgxax

subroutine plgyax( digmax, digits )
    integer, intent(out) :: digmax, digits

    integer(kind=private_plint) :: digmax_out, digits_out

    interface
        subroutine interface_plgyax( digmax, digits ) bind( c, name = 'c_plgyax' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: digmax, digits
        end subroutine interface_plgyax
    end interface

    call interface_plgyax( digmax_out, digits_out )
    digmax = int(digmax_out)
    digits = int(digits_out)
end subroutine plgyax

subroutine plgzax( digmax, digits )
    integer, intent(out) :: digmax, digits

    integer(kind=private_plint) :: digmax_out, digits_out

    interface
        subroutine interface_plgzax( digmax, digits ) bind( c, name = 'c_plgzax' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), intent(out) :: digmax, digits
        end subroutine interface_plgzax
    end interface

    call interface_plgzax( digmax_out, digits_out )
    digmax = int(digmax_out)
    digits = int(digits_out)
end subroutine plgzax

subroutine plinit()
    interface
        subroutine interface_plinit() bind( c, name = 'c_plinit' )
        end subroutine interface_plinit
     end interface
     call interface_plinit()
end subroutine plinit

subroutine pllab( xlab, ylab, title )
   character(len=*), intent(in) :: xlab, ylab, title

   interface
       subroutine interface_pllab( xlab, ylab, title ) bind(c,name='c_pllab')
           implicit none
           character(len=1), dimension(*), intent(in) :: xlab, ylab, title
       end subroutine interface_pllab
   end interface

   call interface_pllab( trim(xlab)//c_null_char, trim(ylab)//c_null_char, trim(title)//c_null_char )

end subroutine pllab

subroutine pllsty( lin )
    integer, intent(in) :: lin
    interface
        subroutine interface_pllsty( lin ) bind( c, name = 'c_pllsty' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: lin
        end subroutine interface_pllsty
    end interface

    call interface_pllsty( int(lin,kind=private_plint) )
end subroutine pllsty

subroutine plmkstrm( strm )
    integer, intent(in) :: strm
    interface
        subroutine interface_plmkstrm( strm ) bind( c, name = 'c_plmkstrm' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: strm
        end subroutine interface_plmkstrm
    end interface

    call interface_plmkstrm( int(strm,kind=private_plint) )
end subroutine plmkstrm

subroutine plparseopts(mode)
  integer, intent(in) :: mode

  integer :: iargs_local, numargs_local

  integer, parameter :: maxargs_local = 100
  character (len=maxlen), dimension(0:maxargs_local) :: arg_local

  interface
     subroutine interface_plparseopts( length, nargs, arg, mode ) bind(c,name='fc_plparseopts')
       import :: c_char
       import :: private_plint
       implicit none
       integer(kind=private_plint), value, intent(in) :: length, nargs, mode
       ! This Fortran argument requires special processing done
       ! in fc_plparseopts at the C level to interoperate properly
       ! with the C version of plparseopts.
       character(c_char) arg(length, nargs)
     end subroutine interface_plparseopts
  end interface

  numargs_local = command_argument_count()
  if (numargs_local < 0) then
     !       This actually happened historically on a badly linked Cygwin platform.
     write(0,'(a)') 'f95 plparseopts ERROR: negative number of arguments'
     return
  endif
  if(numargs_local > maxargs_local) then
     write(0,'(a)') 'f95 plparseopts ERROR: too many arguments'
     return
  endif
  do iargs_local = 0, numargs_local
     call get_command_argument(iargs_local, arg_local(iargs_local))
  enddo
  call interface_plparseopts(len(arg_local(0), kind=private_plint), int(numargs_local+1, kind=private_plint), &
       arg_local, int(mode, kind=private_plint))
end subroutine plparseopts

subroutine plpat( inc, del )
    integer, dimension(:), intent(in) :: inc, del

    integer(kind=private_plint) :: nlin_local

    interface
        subroutine interface_plpat( nlin, inc, del ) bind( c, name = 'c_plpat' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: nlin
            integer(kind=private_plint), dimension(*), intent(in) :: inc, del
        end subroutine interface_plpat
     end interface

     nlin_local = size(inc, kind=private_plint)
     if(nlin_local /= size(del, kind=private_plint) ) then
        write(0,*) "f95 plpat ERROR: sizes of inc and del are not consistent"
        return
     endif

    call interface_plpat( nlin_local, int(inc,kind=private_plint), int(del,kind=private_plint) )

end subroutine plpat

subroutine plprec( setp, prec )
    integer, intent(in) :: setp, prec
    interface
        subroutine interface_plprec( setp, prec ) bind( c, name = 'c_plprec' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: setp, prec
        end subroutine interface_plprec
    end interface

    call interface_plprec( int(setp,kind=private_plint), int(prec,kind=private_plint) )
end subroutine plprec

subroutine plpsty( patt )
    integer, intent(in) :: patt
    interface
        subroutine interface_plpsty( patt ) bind( c, name = 'c_plpsty' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: patt
        end subroutine interface_plpsty
    end interface

    call interface_plpsty( int(patt,kind=private_plint) )
end subroutine plpsty

! Return type is not part of the disambiguation so must provide two
! explicitly named versions where we use the convention that the
! double-precision version has no name suffix (which ~99 per cent of
! users will use) and the single-precision version has a "_single"
! suffix for those who are strict (for some strange reason) about
! keeping all double precision values out of their Fortran code.
function plrandd()

  real(kind=private_double) :: plrandd !function type

    interface
        function interface_plrandd() bind(c,name='c_plrandd')
            import :: private_plflt
            implicit none
            real(kind=private_plflt) :: interface_plrandd !function type
        end function interface_plrandd
    end interface

    plrandd = real(interface_plrandd(), kind=private_double)
end function plrandd

function plrandd_single()

  real(kind=private_single) :: plrandd_single !function type

    interface
        function interface_plrandd() bind(c,name='c_plrandd')
            import :: private_plflt
            implicit none
            real(kind=private_plflt) :: interface_plrandd !function type
        end function interface_plrandd
    end interface

    plrandd_single = real(interface_plrandd(), kind=private_single)
end function plrandd_single

subroutine plreplot()
    interface
        subroutine interface_plreplot() bind(c,name='c_plreplot')
        end subroutine interface_plreplot
     end interface
     call interface_plreplot()
end subroutine plreplot

subroutine plscmap0( r, g, b )
    integer, dimension(:), intent(in) :: r, g, b

    interface
        subroutine interface_plscmap0( r, g, b, n ) bind(c,name='c_plscmap0')
            import :: private_plint
            implicit none
            integer(kind=private_plint), dimension(*), intent(in) :: r, g, b
            integer(kind=private_plint), value, intent(in) :: n
        end subroutine interface_plscmap0
    end interface

    call interface_plscmap0( int(r,kind=private_plint), int(g,kind=private_plint), int(b,kind=private_plint), &
                     size(r,kind=private_plint) )
end subroutine plscmap0

subroutine plscmap0n( n )
    integer, intent(in) :: n
    interface
        subroutine interface_plscmap0n( n ) bind( c, name = 'c_plscmap0n' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: n
        end subroutine interface_plscmap0n
    end interface

    call interface_plscmap0n( int(n,kind=private_plint) )
end subroutine plscmap0n

subroutine plscmap1_impl( r, g, b )
    integer, dimension(:), intent(in) :: r, g, b

    interface
        subroutine interface_plscmap1( r, g, b,  n ) bind(c,name='c_plscmap1')
            import :: private_plint
            implicit none
            integer(kind=private_plint), dimension(*), intent(in) :: r, g, b
            integer(kind=private_plint), value, intent(in) :: n
        end subroutine interface_plscmap1
    end interface

    call interface_plscmap1( int(r,kind=private_plint), int(g,kind=private_plint), int(b,kind=private_plint), &
         size(r,kind=private_plint) )
end subroutine plscmap1_impl

subroutine plscmap1n( n )
    integer, intent(in) :: n
    interface
        subroutine interface_plscmap1n( n ) bind( c, name = 'c_plscmap1n' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: n
        end subroutine interface_plscmap1n
    end interface

    call interface_plscmap1n( int(n,kind=private_plint) )
end subroutine plscmap1n

subroutine plscol0( icol, r, g, b )
    integer, intent(in) :: icol, r, g, b
    interface
        subroutine interface_plscol0( icol, r, g, b ) bind( c, name = 'c_plscol0' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: icol, r, g, b
        end subroutine interface_plscol0
    end interface

    call interface_plscol0( int(icol,kind=private_plint), &
                    int(r,kind=private_plint), int(g,kind=private_plint), int(b,kind=private_plint) )
end subroutine plscol0

subroutine plscolbg( r, g, b )
    integer, intent(in) :: r, g, b
    interface
        subroutine interface_plscolbg( r, g, b ) bind( c, name = 'c_plscolbg' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: r, g, b
        end subroutine interface_plscolbg
    end interface

    call interface_plscolbg( int(r,kind=private_plint), int(g,kind=private_plint), int(b,kind=private_plint) )
end subroutine plscolbg


subroutine plscolor( color )
    integer, intent(in) :: color
    interface
        subroutine interface_plscolor( color ) bind( c, name = 'c_plscolor' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: color
        end subroutine interface_plscolor
    end interface

    call interface_plscolor( int(color,kind=private_plint) )
end subroutine plscolor

subroutine plscompression( compression )
    integer, intent(in) :: compression
    interface
        subroutine interface_plscompression( compression ) bind( c, name = 'c_plscompression' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: compression
        end subroutine interface_plscompression
    end interface

    call interface_plscompression( int(compression,kind=private_plint) )
end subroutine plscompression

subroutine plsdev( devname )
   character(len=*), intent(in) :: devname

   interface
       subroutine interface_plsdev( devname ) bind(c,name='c_plsdev')
           implicit none
           character(len=1), dimension(*), intent(in) :: devname
       end subroutine interface_plsdev
   end interface

   call interface_plsdev( trim(devname)//c_null_char )

end subroutine plsdev

subroutine plsdrawmode( mode )
    integer, intent(in) :: mode
    interface
        subroutine interface_plsdrawmode( mode ) bind( c, name = 'c_plsdrawmode' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: mode
        end subroutine interface_plsdrawmode
    end interface

    call interface_plsdrawmode( int(mode,kind=private_plint) )
end subroutine plsdrawmode

subroutine plseed( s )
    integer, intent(in) :: s
    interface
        subroutine interface_plseed( s ) bind( c, name = 'c_plseed' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: s
        end subroutine interface_plseed
    end interface

    call interface_plseed( int(s,kind=private_plint) )
end subroutine plseed

! TODO: character-version
subroutine plsesc( esc )
    integer, intent(in) :: esc
    interface
        subroutine interface_plsesc( esc ) bind( c, name = 'c_plsesc' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: esc
        end subroutine interface_plsesc
    end interface

    call interface_plsesc( int(esc,kind=private_plint) )
end subroutine plsesc

subroutine plsetopt_impl( opt, optarg )
   character(len=*), intent(in) :: opt, optarg

   interface
       subroutine interface_plsetopt( opt, optarg ) bind(c,name='c_plsetopt')
           implicit none
           character(len=1), dimension(*), intent(in) :: opt, optarg
       end subroutine interface_plsetopt
   end interface

   call interface_plsetopt( trim(opt)//c_null_char, trim(optarg)//c_null_char )

end subroutine plsetopt_impl

subroutine plsfam( fam, num, bmax )
    integer, intent(in) :: fam, num, bmax
    interface
        subroutine interface_plsfam( fam, num, bmax ) bind( c, name = 'c_plsfam' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: fam, num, bmax
        end subroutine interface_plsfam
    end interface

    call interface_plsfam( int(fam,kind=private_plint), int(num,kind=private_plint), int(bmax,kind=private_plint) )
end subroutine plsfam

subroutine plsfci_impl( fci )
    integer, intent(in) :: fci

    interface
        subroutine interface_plsfci( fci ) bind( c, name = 'c_plsfci' )
            import :: private_plunicode
            implicit none
            integer(kind=private_plunicode), value, intent(in) :: fci
        end subroutine interface_plsfci
    end interface

    call interface_plsfci( int(fci,kind=private_plunicode) )

end subroutine plsfci_impl

subroutine plsfnam( fnam )
   character(len=*), intent(in) :: fnam

   interface
       subroutine interface_plsfnam( fnam ) bind(c,name='c_plsfnam')
           implicit none
           character(len=1), dimension(*), intent(in) :: fnam
       end subroutine interface_plsfnam
   end interface

   call interface_plsfnam( trim(fnam)//c_null_char )

end subroutine plsfnam

subroutine plsfont( family, style, weight )
    integer, intent(in) :: family, style, weight
    interface
        subroutine interface_plsfont( family, style, weight ) bind( c, name = 'c_plsfont' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: family, style, weight
        end subroutine interface_plsfont
    end interface

    call interface_plsfont( int(family,kind=private_plint), int(style,kind=private_plint), int(weight,kind=private_plint) )
end subroutine plsfont

subroutine plslabelfunc_null

    interface
        subroutine interface_plslabelfunc( proc, data ) bind(c, name = 'c_plslabelfunc' )
            import :: c_funptr, c_ptr
            type(c_funptr), value, intent(in) :: proc
            type(c_ptr), value, intent(in) :: data
        end subroutine interface_plslabelfunc
    end interface

    call interface_plslabelfunc( c_null_funptr, c_null_ptr )
end subroutine plslabelfunc_null

! Only provide double-precison version because of disambiguation
! problems with the corresponding single-precision version.
subroutine plslabelfunc_double( proc )
    procedure(pllabeler_proc_double) :: proc
    interface
        subroutine interface_plslabelfunc( proc, data ) bind(c, name = 'c_plslabelfunc' )
            import :: c_funptr, c_ptr
            type(c_funptr), value, intent(in) :: proc
            type(c_ptr), value, intent(in) :: data
        end subroutine interface_plslabelfunc
    end interface

    pllabeler_double => proc
    call interface_plslabelfunc( c_funloc(pllabelerf2c_double), c_null_ptr )
end subroutine plslabelfunc_double

! Only provide double-precison version because of disambiguation
! problems with the corresponding single-precision version.
subroutine plslabelfunc_data_double( proc, data )
    procedure(pllabeler_proc_data_double) :: proc
    type(c_ptr), intent(in) :: data
    interface
        subroutine interface_plslabelfunc( proc, data ) bind(c, name = 'c_plslabelfunc' )
            import :: c_funptr, c_ptr
            type(c_funptr), value, intent(in) :: proc
            type(c_ptr), value, intent(in) :: data
        end subroutine interface_plslabelfunc
    end interface

    pllabeler_data_double => proc
    call interface_plslabelfunc( c_funloc(pllabelerf2c_data_double), data )
end subroutine plslabelfunc_data_double

! Probably would be better to define this in redacted form, but it is not documented that
! way, and the python interface also does not use redacted form.  So leave it for now.
! I (AWI) followed advice in <http://stackoverflow.com/questions/10755896/fortran-how-to-store-value-255-into-one-byte>
! for the type statement for plotmem
subroutine plsmem( maxx, maxy, plotmem )
    integer, intent(in) :: maxx, maxy
    character(kind=c_char), dimension(:, :, :), target, intent(in) :: plotmem
    interface
        subroutine interface_plsmem( maxx, maxy, plotmem ) bind( c, name = 'c_plsmem' )
            import :: c_ptr
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: maxx, maxy
            type(c_ptr), value, intent(in) :: plotmem
        end subroutine interface_plsmem
     end interface

     ! We need a first dimension of 3 to have space for RGB
     if( 3 /= size(plotmem,1) ) then
        write(0,*) "f95 plsmem ERROR: first dimension of plotmem is not 3"
        return
     endif

     ! Since not defined in redacted form, we at least check that
     ! maxx, and maxy are consistent with the second and third dimensions of plotmem.
     if( maxx /= size(plotmem,2) .or. maxy /= size(plotmem,3) ) then
        write(0,*) "f95 plsmem ERROR: maxx and/or maxy not consistent with second and third plotmem dimensions"
        return
     endif
    call interface_plsmem( int(maxx,kind=private_plint), int(maxy,kind=private_plint),  c_loc(plotmem))
end subroutine plsmem

! Probably would be better to define this in redacted form, but it is not documented that
! way, and the python interface also does not use redacted form.  So leave it for now.
! I (AWI) followed advice in <http://stackoverflow.com/questions/10755896/fortran-how-to-store-value-255-into-one-byte>
! for the type statement for plotmem
subroutine plsmema( maxx, maxy, plotmem )
    integer, intent(in) :: maxx, maxy
    character(kind=c_char), dimension(:, :, :), target, intent(in) :: plotmem
    interface
        subroutine interface_plsmema( maxx, maxy, plotmem ) bind( c, name = 'c_plsmema' )
            import :: c_ptr
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: maxx, maxy
            type(c_ptr), value, intent(in) :: plotmem
        end subroutine interface_plsmema
     end interface

     ! We need a first dimension of 4 to have space for RGBa
     if( 4 /= size(plotmem,1) ) then
        write(0,*) "f95 plsmema ERROR: first dimension of plotmem is not 4"
        return
     endif

     ! Since not defined in redacted form, we at least check that
     ! maxx, and maxy are consistent with the second and third dimensions of plotmem.
     if( maxx /= size(plotmem,2) .or. maxy /= size(plotmem,3) ) then
        write(0,*) "f95 plsmema ERROR: maxx and/or maxy not consistent with second and third plotmem dimensions"
        return
     endif
    call interface_plsmema( int(maxx,kind=private_plint), int(maxy,kind=private_plint),  c_loc(plotmem))
end subroutine plsmema

subroutine plsori( rot )
    integer, intent(in) :: rot
    interface
        subroutine interface_plsori( rot ) bind( c, name = 'c_plsori' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: rot
        end subroutine interface_plsori
    end interface

    call interface_plsori( int(rot,kind=private_plint) )
end subroutine plsori

subroutine plspal0( filename )
  character(len=*), intent(in) :: filename

   interface
       subroutine interface_plspal0( filename ) bind(c,name='c_plspal0')
           implicit none
           character(len=1), dimension(*), intent(in) :: filename
       end subroutine interface_plspal0
   end interface

   call interface_plspal0( trim(filename)//c_null_char )

end subroutine plspal0

subroutine plspal1( filename, interpolate )
  character(len=*), intent(in) :: filename
  logical, intent(in) :: interpolate

   interface
       subroutine interface_plspal1( filename, interpolate ) bind(c,name='c_plspal1')
           import :: private_plbool
           implicit none
           integer(kind=private_plbool), value, intent(in) :: interpolate
           character(len=1), dimension(*), intent(in) :: filename
       end subroutine interface_plspal1
   end interface

   call interface_plspal1( trim(filename)//c_null_char, int( merge(1,0,interpolate),kind=private_plbool) )

end subroutine plspal1

subroutine plspause( pause )
    logical, intent(in) :: pause

    interface
        subroutine interface_plspause( pause ) bind(c,name='c_plspause')
            import :: private_plbool
            implicit none
            integer(kind=private_plbool), value, intent(in) :: pause
        end subroutine interface_plspause
    end interface

   call interface_plspause( int( merge(1,0,pause),kind=private_plbool) )
end subroutine plspause

subroutine plsstrm( strm )
    integer, intent(in) :: strm
    interface
        subroutine interface_plsstrm( strm ) bind( c, name = 'c_plsstrm' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: strm
        end subroutine interface_plsstrm
    end interface

    call interface_plsstrm( int(strm,kind=private_plint) )
end subroutine plsstrm

subroutine plssub( nx, ny )
    integer, intent(in) :: nx, ny
    interface
        subroutine interface_plssub( nx, ny ) bind( c, name = 'c_plssub' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: nx, ny
        end subroutine interface_plssub
    end interface

    call interface_plssub( int(nx,kind=private_plint), int(ny,kind=private_plint) )
end subroutine plssub

subroutine plstar( nx, ny )
    integer, intent(in) :: nx, ny
    interface
        subroutine interface_plstar( nx, ny ) bind( c, name = 'c_plstar' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: nx, ny
        end subroutine interface_plstar
    end interface

    call interface_plstar( int(nx,kind=private_plint), int(ny,kind=private_plint) )
end subroutine plstar

subroutine plstart( devname, nx, ny )
    integer, intent(in) :: nx, ny
    character(len=*), intent(in) :: devname
    interface
        subroutine interface_plstart( devname, nx, ny ) bind( c, name = 'c_plstart' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: nx, ny
            character(len=1), dimension(*), intent(in) :: devname
        end subroutine interface_plstart
    end interface

    call interface_plstart( trim(devname)//c_null_char, int(nx,kind=private_plint), int(ny,kind=private_plint) )
end subroutine plstart

subroutine plstransform_null

    interface
        subroutine interface_plstransform( proc, data ) bind(c, name = 'c_plstransform' )
            import :: c_funptr, c_ptr
            type(c_funptr), value, intent(in) :: proc
            type(c_ptr), value, intent(in) :: data
        end subroutine interface_plstransform
    end interface

    call interface_plstransform( c_null_funptr, c_null_ptr )
end subroutine plstransform_null

! Only provide double-precison version because of disambiguation
! problems with the corresponding single-precision version.
subroutine plstransform_double( proc )
    procedure(pltransform_proc_double) :: proc
    interface
        subroutine interface_plstransform( proc, data ) bind(c, name = 'c_plstransform' )
            import :: c_funptr, c_ptr
            type(c_funptr), value, intent(in) :: proc
            type(c_ptr), value, intent(in) :: data
        end subroutine interface_plstransform
    end interface

    pltransform_double => proc
    call interface_plstransform( c_funloc(pltransformf2c_double), c_null_ptr )
end subroutine plstransform_double

! Only provide double-precison version because of disambiguation
! problems with the corresponding single-precision version.
subroutine plstransform_data_double( proc, data )
    procedure(pltransform_proc_data_double) :: proc
    type(c_ptr), intent(in) :: data
    interface
        subroutine interface_plstransform( proc, data ) bind(c, name = 'c_plstransform' )
            import :: c_funptr, c_ptr
            type(c_funptr), value, intent(in) :: proc
            type(c_ptr), value, intent(in) :: data
        end subroutine interface_plstransform
    end interface

    pltransform_data_double => proc
    call interface_plstransform( c_funloc(pltransformf2c_data_double), data )
end subroutine plstransform_data_double

subroutine plstripd( id )
    integer, intent(in) :: id
    interface
        subroutine interface_plstripd( id ) bind( c, name = 'c_plstripd' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: id
        end subroutine interface_plstripd
    end interface

    call interface_plstripd( int(id,kind=private_plint) )
end subroutine plstripd

subroutine plstyl_scalar( n, mark, space )
    integer, intent(in) :: n, mark, space

    call plstyl_n_array( n, (/ mark /), (/ space /) )
end subroutine plstyl_scalar

subroutine plstyl_array( mark, space )
    integer, dimension(:), intent(in) :: mark, space

    call plstyl_n_array( size(mark), mark, space )
end subroutine plstyl_array

subroutine plstyl_n_array( n, mark, space )
    integer, intent(in) :: n
    integer, dimension(:), intent(in) :: mark, space
    interface
        subroutine interface_plstyl( n, mark, space ) bind( c, name = 'c_plstyl' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: n
            integer(kind=private_plint), dimension(*), intent(in) :: mark, space
        end subroutine interface_plstyl
    end interface

    call interface_plstyl( int(n,kind=private_plint), int(mark,kind=private_plint), int(space,kind=private_plint) )
end subroutine plstyl_n_array

subroutine plsvect_double( arrowx, arrowy, fill )
  logical, intent(in) :: fill
  real(kind=private_double), dimension(:), intent(in) :: arrowx, arrowy

  integer(kind=private_plint) :: npts_local

    interface
        subroutine interface_plsvect( arrowx, arrowy, npts,  fill ) bind(c,name='c_plsvect')
            import :: private_plint, private_plbool, private_plflt
            implicit none
            integer(kind=private_plint), value, intent(in) :: npts
            integer(kind=private_plbool), value, intent(in) :: fill
            real(kind=private_plflt), dimension(*), intent(in) :: arrowx, arrowy
        end subroutine interface_plsvect
     end interface

     npts_local = size(arrowx, kind=private_plint)
     if(npts_local /= size(arrowy, kind=private_plint) ) then
        write(0,*) "f95 plsvect ERROR: sizes of arrowx and arrowy are not consistent"
        return
     end if

     call interface_plsvect( real(arrowx, kind=private_plflt), real(arrowy, kind=private_plflt),  &
          npts_local, int(merge(1,0,fill), kind=private_plbool) )
end subroutine plsvect_double

subroutine plsvect_none( fill )
  logical, optional, intent(in) :: fill

    interface
        subroutine interface_plsvect( arrowx, arrowy, npts,  fill ) bind(c,name='c_plsvect')
            import :: c_ptr
            import :: private_plint, private_plbool
            implicit none
            integer(kind=private_plint), value, intent(in) :: npts
            integer(kind=private_plbool), value, intent(in) :: fill
            type(c_ptr), value, intent(in) :: arrowx, arrowy
        end subroutine interface_plsvect
     end interface

     call interface_plsvect( c_null_ptr, c_null_ptr, 0_private_plint, 0_private_plbool )
end subroutine plsvect_none

subroutine plsvect_single( arrowx, arrowy, fill )
  logical, intent(in) :: fill
  real(kind=private_single), dimension(:), intent(in) :: arrowx, arrowy

  integer(kind=private_plint) :: npts_local

    interface
        subroutine interface_plsvect( arrowx, arrowy, npts,  fill ) bind(c,name='c_plsvect')
            import :: private_plint, private_plbool, private_plflt
            implicit none
            integer(kind=private_plint), value, intent(in) :: npts
            integer(kind=private_plbool), value, intent(in) :: fill
            real(kind=private_plflt), dimension(*), intent(in) :: arrowx, arrowy
        end subroutine interface_plsvect
     end interface

     npts_local = size(arrowx, kind=private_plint)
     if(npts_local /= size(arrowy, kind=private_plint) ) then
        write(0,*) "f95 plsvect ERROR: sizes of arrowx and arrowy are not consistent"
        return
     end if

     call interface_plsvect( real(arrowx, kind=private_plflt), real(arrowy, kind=private_plflt),  &
          npts_local, int(merge(1,0,fill), kind=private_plbool) )
end subroutine plsvect_single

subroutine plsxax( digmax, digits )
    integer, intent(in) :: digmax, digits
    interface
        subroutine interface_plsxax( digmax, digits ) bind( c, name = 'c_plsxax' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: digmax, digits
        end subroutine interface_plsxax
    end interface

    call interface_plsxax( int(digmax,kind=private_plint), int(digits,kind=private_plint) )
end subroutine plsxax

subroutine plsyax( digmax, digits )
    integer, intent(in) :: digmax, digits
    interface
        subroutine interface_plsyax( digmax, digits ) bind( c, name = 'c_plsyax' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: digmax, digits
        end subroutine interface_plsyax
    end interface

    call interface_plsyax( int(digmax,kind=private_plint), int(digits,kind=private_plint) )
end subroutine plsyax

subroutine plszax( digmax, digits )
    integer, intent(in) :: digmax, digits
    interface
        subroutine interface_plszax( digmax, digits ) bind( c, name = 'c_plszax' )
            import :: private_plint
            implicit none
            integer(kind=private_plint), value, intent(in) :: digmax, digits
        end subroutine interface_plszax
    end interface

    call interface_plszax( int(digmax,kind=private_plint), int(digits,kind=private_plint) )
end subroutine plszax

subroutine pltext()
    interface
        subroutine interface_pltext() bind(c,name='c_pltext')
        end subroutine interface_pltext
     end interface
     call interface_pltext()
end subroutine pltext

subroutine pltimefmt_impl( fmt )
   character(len=*), intent(in) :: fmt

   interface
       subroutine interface_pltimefmt( fmt ) bind(c,name='c_pltimefmt')
           implicit none
           character(len=1), dimension(*), intent(in) :: fmt
       end subroutine interface_pltimefmt
   end interface

   call interface_pltimefmt( trim(fmt)//c_null_char )

end subroutine pltimefmt_impl

subroutine plvsta()
    interface
        subroutine interface_plvsta() bind(c,name='c_plvsta')
        end subroutine interface_plvsta
     end interface
     call interface_plvsta()
end subroutine plvsta

subroutine plxormod_impl( mode, status )
  logical, intent(in) :: mode
  logical, intent(out) :: status

  integer(kind=private_plbool) :: status_out

  interface
     subroutine interface_plxormod( mode, status ) bind(c,name='c_plxormod')
       import :: private_plbool
       implicit none
       integer(kind=private_plbool), value, intent(in) :: mode
       integer(kind=private_plbool), intent(out) :: status
     end subroutine interface_plxormod
  end interface

  call interface_plxormod( int( merge(1,0,mode),kind=private_plbool), status_out )
  status = status_out /= 0_private_plbool

end subroutine plxormod_impl

end module plplot
