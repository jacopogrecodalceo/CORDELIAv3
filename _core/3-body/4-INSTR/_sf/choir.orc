gichoir		sfload	"/Users/j/Documents/PROJECTs/CORDELIA/soundfont/phantom.sf2"
		sfplist	gichoir
		sfpassign 0, gichoir    ;assign the preset to number 00 

;ir		sfpreset iprog, ibank, ifilhandle, ipreindex

	instr choir

	$params

aout	sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 0, 1	   ;preset index = 0, set flag to frequency instead of midi pitch

ienvvar		init idur/10

	$death

	endin


