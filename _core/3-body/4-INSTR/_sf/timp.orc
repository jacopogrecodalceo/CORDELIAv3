gitimp	sfload	"/Users/j/Documents/PROJECTs/CORDELIA/soundfont/timpani.sf2"
		sfplist	gitimp
		sfpassign 2, gitimp    ;assign the preset to number 00 

	instr timp

	$params

aout	sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 2, 1	   ;preset index = 0, set flag to frequency instead of midi pitch

ienvvar		init idur/10

	$death

	endin


