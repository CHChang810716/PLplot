/* $Id$

	Contains all prototypes for driver functions.
*/

#ifndef __DRIVERS_H__
#define __DRIVERS_H__

#include "plplot/pdf.h"
#include "plplot/plstrm.h"

#ifdef __cplusplus
extern "C" {
#endif

void plD_dispatch_init_mac8	( PLDispatchTable *pdt );
void plD_dispatch_init_mac1	( PLDispatchTable *pdt );
void plD_dispatch_init_nx	( PLDispatchTable *pdt );
void plD_dispatch_init_os2	( PLDispatchTable *pdt );
void plD_dispatch_init_xw	( PLDispatchTable *pdt );
void plD_dispatch_init_gnome	( PLDispatchTable *pdt );
void plD_dispatch_init_tk	( PLDispatchTable *pdt );
void plD_dispatch_init_vga	( PLDispatchTable *pdt );
void plD_dispatch_init_mgr	( PLDispatchTable *pdt );
void plD_dispatch_init_win3	( PLDispatchTable *pdt );
void plD_dispatch_init_vga	( PLDispatchTable *pdt );
void plD_dispatch_init_vga	( PLDispatchTable *pdt );
void plD_dispatch_init_vga	( PLDispatchTable *pdt );
void plD_dispatch_init_tiff	( PLDispatchTable *pdt );
void plD_dispatch_init_jpg	( PLDispatchTable *pdt );
void plD_dispatch_init_bmp	( PLDispatchTable *pdt );
void plD_dispatch_init_vga	( PLDispatchTable *pdt );
void plD_dispatch_init_xterm	( PLDispatchTable *pdt );
void plD_dispatch_init_tekt	( PLDispatchTable *pdt );
void plD_dispatch_init_tek4107t	( PLDispatchTable *pdt );
void plD_dispatch_init_mskermit	( PLDispatchTable *pdt );
void plD_dispatch_init_versaterm( PLDispatchTable *pdt );
void plD_dispatch_init_vlt	( PLDispatchTable *pdt );
void plD_dispatch_init_conex	( PLDispatchTable *pdt );
void plD_dispatch_init_dg	( PLDispatchTable *pdt );
void plD_dispatch_init_plm	( PLDispatchTable *pdt );
void plD_dispatch_init_tekf	( PLDispatchTable *pdt );
void plD_dispatch_init_tek4107f	( PLDispatchTable *pdt );
void plD_dispatch_init_psm	( PLDispatchTable *pdt );
void plD_dispatch_init_psc	( PLDispatchTable *pdt );
void plD_dispatch_init_xfig	( PLDispatchTable *pdt );
void plD_dispatch_init_ljiip	( PLDispatchTable *pdt );
void plD_dispatch_init_ljii	( PLDispatchTable *pdt );
void plD_dispatch_init_hp7470	( PLDispatchTable *pdt );
void plD_dispatch_init_hp7580	( PLDispatchTable *pdt );
void plD_dispatch_init_hpgl	( PLDispatchTable *pdt );
void plD_dispatch_init_imp	( PLDispatchTable *pdt );
void plD_dispatch_init_pbm	( PLDispatchTable *pdt );
void plD_dispatch_init_png	( PLDispatchTable *pdt );
void plD_dispatch_init_png	( PLDispatchTable *pdt );
void plD_dispatch_init_null	( PLDispatchTable *pdt );

#if 0
void plD_init_tk		(PLStream *);
void plD_init_dp		(PLStream *);
void plD_line_tk		(PLStream *, short, short, short, short);
void plD_polyline_tk		(PLStream *, short *, short *, PLINT);
void plD_eop_tk			(PLStream *);
void plD_bop_tk			(PLStream *);
void plD_tidy_tk		(PLStream *);
void plD_state_tk		(PLStream *, PLINT);
void plD_esc_tk			(PLStream *, PLINT, void *);

void plD_init_xw		(PLStream *);
void plD_line_xw		(PLStream *, short, short, short, short);
void plD_polyline_xw		(PLStream *, short *, short *, PLINT);
void plD_eop_xw			(PLStream *);
void plD_bop_xw			(PLStream *);
void plD_tidy_xw		(PLStream *);
void plD_state_xw		(PLStream *, PLINT);
void plD_esc_xw			(PLStream *, PLINT, void *);

void plD_init_gnome		(PLStream *);
void plD_line_gnome		(PLStream *, short, short, short, short);
void plD_polyline_gnome		(PLStream *, short *, short *, PLINT);
void plD_eop_gnome		(PLStream *);
void plD_bop_gnome		(PLStream *);
void plD_tidy_gnome		(PLStream *);
void plD_state_gnome		(PLStream *, PLINT);
void plD_esc_gnome		(PLStream *, PLINT, void *);

void plD_init_mgr		(PLStream *);
void plD_line_mgr		(PLStream *, short, short, short, short);
void plD_polyline_mgr		(PLStream *, short *, short *, PLINT);
void plD_eop_mgr		(PLStream *);
void plD_bop_mgr		(PLStream *);
void plD_tidy_mgr		(PLStream *);
void plD_state_mgr		(PLStream *, PLINT);
void plD_esc_mgr		(PLStream *, PLINT, void *);

void plD_init_nx		(PLStream *);
void plD_line_nx		(PLStream *, short, short, short, short);
void plD_polyline_nx		(PLStream *, short *, short *, PLINT);
void plD_eop_nx			(PLStream *);
void plD_bop_nx			(PLStream *);
void plD_tidy_nx		(PLStream *);
void plD_state_nx		(PLStream *, PLINT);
void plD_esc_nx			(PLStream *, PLINT, void *);

void plD_init_vga		(PLStream *);
void plD_line_vga		(PLStream *, short, short, short, short);
void plD_polyline_vga		(PLStream *, short *, short *, PLINT);
void plD_eop_vga		(PLStream *);
void plD_bop_vga		(PLStream *);
void plD_tidy_vga		(PLStream *);
void plD_state_vga		(PLStream *, PLINT);
void plD_esc_vga		(PLStream *, PLINT, void *);

void plD_init_tiff		(PLStream *);
void plD_eop_tiff		(PLStream *);
void plD_bop_tiff		(PLStream *);
void plD_tidy_tiff		(PLStream *);
void plD_esc_tiff		(PLStream *, PLINT, void *);

void plD_init_bmp		(PLStream *);
void plD_eop_bmp		(PLStream *);
void plD_bop_bmp		(PLStream *);
void plD_tidy_bmp		(PLStream *);
void plD_esc_bmp		(PLStream *, PLINT, void *);

/*These are for the GRX20-based jpeg driver in the djgpp area*/
void plD_init_jpg		(PLStream *);
void plD_eop_jpg		(PLStream *);
void plD_bop_jpg		(PLStream *);
void plD_tidy_jpg		(PLStream *);
void plD_esc_jpg		(PLStream *, PLINT, void *);


void plD_init_mac1		(PLStream *);
void plD_init_mac8		(PLStream *);
void plD_line_mac		(PLStream *, short, short, short, short);
void plD_polyline_mac		(PLStream *, short *, short *, PLINT);
void plD_eop_mac		(PLStream *);
void plD_bop_mac		(PLStream *);
void plD_tidy_mac		(PLStream *);
void plD_state_mac		(PLStream *, PLINT);
void plD_esc_mac		(PLStream *, PLINT, void *);

void plD_init_win3		(PLStream *);
void plD_line_win3		(PLStream *, short, short, short, short);
void plD_polyline_win3		(PLStream *, short *, short *, PLINT);
void plD_eop_win3		(PLStream *);
void plD_bop_win3		(PLStream *);
void plD_tidy_win3		(PLStream *);
void plD_state_win3		(PLStream *, PLINT);
void plD_esc_win3		(PLStream *, PLINT, void *);

void plD_init_os2		(PLStream *);				 
void plD_line_os2		(PLStream *, short, short, short, short);
void plD_polyline_os2		(PLStream *, short *, short *, PLINT);
void plD_eop_os2		(PLStream *);				 
void plD_bop_os2		(PLStream *);				 
void plD_tidy_os2		(PLStream *);				 
void plD_state_os2		(PLStream *, PLINT);
void plD_esc_os2		(PLStream *, PLINT, void *);		 

/* These are for the general PNG and JPEG drivers based on libgd */
void plD_init_png               (PLStream *);
void plD_line_png               (PLStream *, short, short, short, short);
void plD_polyline_png           (PLStream *, short *, short *, PLINT);
void plD_eop_png                (PLStream *);
void plD_bop_png                (PLStream *);
void plD_tidy_png               (PLStream *);
void plD_state_png              (PLStream *, PLINT);
void plD_esc_png                (PLStream *, PLINT, void *);
void plD_eop_jpeg                (PLStream *);
#endif

/* Prototypes for plot buffer calls. */

void plbuf_init		(PLStream *);
void plbuf_line		(PLStream *, short, short, short, short);
void plbuf_polyline	(PLStream *, short *, short *, PLINT);
void plbuf_eop		(PLStream *);
void plbuf_bop		(PLStream *);
void plbuf_tidy		(PLStream *);
void plbuf_state	(PLStream *, PLINT);
void plbuf_esc		(PLStream *, PLINT, void *);

void plRemakePlot	(PLStream *);

#ifdef __cplusplus
}
#endif

#endif	/* __DRIVERS_H__ */
