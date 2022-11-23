gisfpiano	sfload	"/Users/j/Documents/PROJECTs/CORDELIA/soundfont/steinway.sf2"
		sfplist	gisfpiano
		sfpassign 0, gisfpiano    ;assign the preset to number 00 

	instr sfpiano

	$params

aout	sfplay3m $ampvar*127, ftom:i(A4), gizero/127*$ampvar/2, icps, 0, 1	   ;preset index = 0, set flag to frequency instead of midi pitch

ienvvar		init idur/10

	$death

	endin


