/* $Id$
 * $Log$
 * Revision 1.18  1994/06/30 18:47:06  mjl
 * Restructured, to make Tk driver more independent of plserver (tk.c no
 * longer includes this file).  Eventually it will be possible to link the
 * Tk driver with Tcl-DP only, and not X or Tk, and the function of the
 * header files must be well defined by then.
 *
 * Revision 1.17  1994/06/23  22:34:22  mjl
 * Now includes pltcl.h for all Tcl API stuff.
 *
 * Revision 1.16  1994/06/16  19:07:08  mjl
 * Include-guarded.  Now includes file tclMatrix.h, to pick up the new matrix
 * command support.  Prototype for plframe() moved here from plplot.h since
 * it shouldn't be necessary for the user to explicitly refer to it any more
 * (in lieu of using Pltk_Init()).
 *
 */

/* 
 * plserver.h
 * Maurice LeBrun
 * 6-May-93
 *
 * Declarations for plserver and associated files.  
 */

#ifndef __PLSERVER_H__
#define __PLSERVER_H__

#include <plplotP.h>
#include <pltcl.h>
#include <plplotTK.h>

/* State info for the rendering code */

typedef struct {
    char  *client;			/* Name of client main window */
    PDFstrm *pdfs;			/* PDF stream descriptor */
    PLiodev *iodev;			/* I/O info */
    int   nbytes;			/* data bytes waiting to be read */
    int   at_bop, at_eop;		/* bop/eop condition flags */

    short xmin, xmax, ymin, ymax;	/* Data minima and maxima */
    PLFLT xold, yold;			/* Endpoints of last line plotted */
} PLRDev;

/* External function prototypes. */
/* Note that tcl command functions are added during Pltk_Init and don't */
/* need to be called directly by the user */

/* From plframe.c */

int
plFrameCmd(ClientData clientData, Tcl_Interp *interp,
	   int argc, char **argv);

/* from plr.c */

/* Set default state parameters before anyone else has a chance to. */

void
plr_start(PLRDev *plr);

/* Read & process commands until "nbyte_max" bytes have been read. */

int
plr_process(PLRDev *plr);

#endif	/* __PLSERVER_H__ */
