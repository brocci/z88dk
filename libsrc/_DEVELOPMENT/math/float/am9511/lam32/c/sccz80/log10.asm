
	SECTION	code_fp_am9511
	PUBLIC	log10
	EXTERN	asm_am9511_log10_fastcall

	defc	log10 = asm_am9511_log10_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10
EXTERN cam32_sdcc_log10
defc _log10 = cam32_sdcc_log10
ENDIF
