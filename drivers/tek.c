/* $Id$
   $Log$
   Revision 1.5  1993/01/23 05:41:53  mjl
   Changes to support new color model, polylines, and event handler support
   (interactive devices only).

 * Revision 1.4  1992/11/07  07:48:48  mjl
 * Fixed orientation operation in several files and standardized certain startup
 * operations. Fixed bugs in various drivers.
 *
 * Revision 1.3  1992/10/22  17:04:58  mjl
 * Fixed warnings, errors generated when compling with HP C++.
 *
 * Revision 1.2  1992/09/29  04:44:50  furnish
 * Massive clean up effort to remove support for garbage compilers (K&R).
 *
 * Revision 1.1  1992/05/20  21:32:43  furnish
 * Initial checkin of the whole PLPLOT project.
 *
*/

/*	tek.c

	PLPLOT tektronix device driver.
*/
#ifdef TEK

#include <stdio.h>
#include "plplot.h"
#include "drivers.h"

/* Function prototypes */
/* INDENT OFF */

void tek_init(PLStream *);

/* top level declarations */

#define TEKX   1023
#define TEKY    779

/* Graphics control characters. */

#define FF   12
#define CAN  24
#define ESC  27
#define GS   29
#define US   31

/* (dev) will get passed in eventually, so this looks weird right now */

static PLDev device;
static PLDev *dev = &device;

/* INDENT ON */
/*----------------------------------------------------------------------*\
* tekt_init()
*
* Initialize device (terminal).
\*----------------------------------------------------------------------*/

void
tekt_init(PLStream *pls)
{
    pls->termin = 1;		/* an interactive device */

    pls->OutFile = stdout;
    pls->orient = 0;
    tek_init(pls);
    fprintf(pls->OutFile, "%c%c", ESC, FF);	/* mgg 07/23/91 via rmr */
}

/*----------------------------------------------------------------------*\
* tekf_init()
*
* Initialize device (file).
\*----------------------------------------------------------------------*/

void
tekf_init(PLStream *pls)
{
    pls->termin = 0;		/* not an interactive terminal */

/* Initialize family file info */

    plFamInit(pls);

/* Prompt for a file name if not already set */

    plOpenFile(pls);

/* Set up device parameters */

    tek_init(pls);
}

/*----------------------------------------------------------------------*\
* tek_init()
*
* Generic device initialization.
\*----------------------------------------------------------------------*/

void
tek_init(PLStream *pls)
{
    pls->icol0 = 1;
    pls->color = 0;
    pls->width = 1;
    pls->bytecnt = 0;
    pls->page = 0;

    dev->xold = UNDEFINED;
    dev->yold = UNDEFINED;
    dev->xmin = 0;
    dev->ymin = 0;

    switch (pls->orient) {

      case 1:
      case -1:
	dev->xmax = TEKY * 16;
	dev->ymax = TEKX * 16;
	setpxl((PLFLT) (4.653 * 16), (PLFLT) (4.771 * 16));
	break;

      default:
	dev->xmax = TEKX * 16;
	dev->ymax = TEKY * 16;
	setpxl((PLFLT) (4.771 * 16), (PLFLT) (4.653 * 16));
	break;
    }

    dev->xlen = dev->xmax - dev->xmin;
    dev->ylen = dev->ymax - dev->ymin;

    setphy(dev->xmin, dev->xmax, dev->ymin, dev->ymax);

    fprintf(pls->OutFile, "%c", GS);
}

/*----------------------------------------------------------------------*\
* tek_line()
*
* Draw a line in the current color from (x1,y1) to (x2,y2).
\*----------------------------------------------------------------------*/

void
tek_line(PLStream *pls, PLSHORT x1a, PLSHORT y1a, PLSHORT x2a, PLSHORT y2a)
{
    int x1 = x1a, y1 = y1a, x2 = x2a, y2 = y2a;
    int hy, ly, hx, lx;

    plRotPhy(pls->orient, dev, &x1, &y1, &x2, &y2);
    if (pls->pscale)
	plSclPhy(pls, dev, &x1, &y1, &x2, &y2);

    x1 >>= 4;
    y1 >>= 4;
    x2 >>= 4;
    y2 >>= 4;

/* If continuation of previous line just send new point */

    if (x1 == dev->xold && y1 == dev->yold) {
	hy = y2 / 32 + 32;
	ly = y2 - (y2 / 32) * 32 + 96;
	hx = x2 / 32 + 32;
	lx = x2 - (x2 / 32) * 32 + 64;
	fprintf(pls->OutFile, "%c%c%c%c", hy, ly, hx, lx);
	pls->bytecnt += 4;
    }
    else {
	fprintf(pls->OutFile, "%c", GS);
	hy = y1 / 32 + 32;
	ly = y1 - (y1 / 32) * 32 + 96;
	hx = x1 / 32 + 32;
	lx = x1 - (x1 / 32) * 32 + 64;
	fprintf(pls->OutFile, "%c%c%c%c", hy, ly, hx, lx);
	hy = y2 / 32 + 32;
	ly = y2 - (y2 / 32) * 32 + 96;
	hx = x2 / 32 + 32;
	lx = x2 - (x2 / 32) * 32 + 64;
	fprintf(pls->OutFile, "%c%c%c%c", hy, ly, hx, lx);
	pls->bytecnt += 9;
    }
    dev->xold = x2;
    dev->yold = y2;
}

/*----------------------------------------------------------------------*\
* tek_polyline()
*
* Draw a polyline in the current color.
\*----------------------------------------------------------------------*/

void
tek_polyline(PLStream *pls, PLSHORT *xa, PLSHORT *ya, PLINT npts)
{
    PLINT i;

    for (i = 0; i < npts - 1; i++)
	tek_line(pls, xa[i], ya[i], xa[i + 1], ya[i + 1]);
}

/*----------------------------------------------------------------------*\
* tek_clear()
*
* Clear page.  User must hit a <CR> to continue (terminal output).
\*----------------------------------------------------------------------*/

void
tek_clear(PLStream *pls)
{
    if (pls->termin) {
	putchar('\007');
	fflush(stdout);
	while (getchar() != '\n');
    }
    fprintf(pls->OutFile, "%c%c", ESC, FF);
}

/*----------------------------------------------------------------------*\
* tek_page()
*
* Set up for the next page.
* Advance to next family file if necessary (file output).
\*----------------------------------------------------------------------*/

void
tek_page(PLStream *pls)
{
    dev->xold = UNDEFINED;
    dev->yold = UNDEFINED;

    if (!pls->termin)
	plGetFam(pls);

    pls->page++;
}

/*----------------------------------------------------------------------*\
* tek_adv()
*
* Advance to the next page.
\*----------------------------------------------------------------------*/

void
tek_adv(PLStream *pls)
{
    tek_clear(pls);
    tek_page(pls);
}

/*----------------------------------------------------------------------*\
* tek_tidy()
*
* Close graphics file or otherwise clean up.
\*----------------------------------------------------------------------*/

void
tek_tidy(PLStream *pls)
{
    if (!pls->termin) {
	fclose(pls->OutFile);
    }
    else {
	tek_clear(pls);
	fprintf(pls->OutFile, "%c%c", US, CAN);
	fflush(pls->OutFile);
    }
    pls->fileset = 0;
    pls->page = 0;
    pls->OutFile = NULL;
}

/*----------------------------------------------------------------------*\
* tek_color()
*
* Set pen color.
\*----------------------------------------------------------------------*/

void
tek_color(PLStream *pls)
{
}

/*----------------------------------------------------------------------*\
* tek_text()
*
* Switch to text mode.
\*----------------------------------------------------------------------*/

void
tek_text(PLStream *pls)
{
    fprintf(pls->OutFile, "%c", US);
}

/*----------------------------------------------------------------------*\
* tek_graph()
*
* Switch to graphics mode.
\*----------------------------------------------------------------------*/

void
tek_graph(PLStream *pls)
{
}

/*----------------------------------------------------------------------*\
* tek_width()
*
* Set pen width.
\*----------------------------------------------------------------------*/

void
tek_width(PLStream *pls)
{
}

/*----------------------------------------------------------------------*\
* tek_esc()
*
* Escape function.
\*----------------------------------------------------------------------*/

void
tek_esc(PLStream *pls, PLINT op, char *ptr)
{
}

#else
int 
pldummy_tek()
{
    return 0;
}

#endif				/* TEK */
