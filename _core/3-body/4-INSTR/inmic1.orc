	instr inmic1

Sinstr		init "inmic1"
ich		init p4

aout		inch gimic1

	$mix	

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("inmic1")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od

