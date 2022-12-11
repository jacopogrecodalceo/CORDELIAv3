gisfpiano	sfload	"/Users/j/Documents/PROJECTs/CORDELIA/soundfont/steinway.sf2"
		sfplist	gisfpiano
		sfpassign 1, gisfpiano    ;assign the preset to number 00 

	instr sfpiano

	$params

aout	sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 1, 1	   ;preset index = 0, set flag to frequency instead of midi pitch

ienvvar		init idur/10

	$death

	endin


