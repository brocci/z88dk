;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: sqrt.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

    SECTION smc_fp
    INCLUDE "cpcmath.inc"

    PUBLIC  sqrt
    PUBLIC  sqrtc

    EXTERN  get_para

.sqrt
    call    get_para
.sqrtc
    FPCALL(CPCFP_FLO_SQRT)
    ret