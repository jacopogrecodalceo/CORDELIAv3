	instr score

gkpulse	= 130

gkfim_detune	= 2
gkfim_var	= 0 

k1	pump 4, fillarray(0, -5)
k2	= 8

k3	= .15
k4	= 64

$if	eu(3, 8, 32, "heart") $then
	e(oncegen(giline), "burd",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 4*k3)),
	accent(3, $mf),
	gieclassic,
	step("3G", gimajor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("4E", giminor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(3, 8, 32, "heart", 2) $then
	ed(oncegen(gidist), "fim",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 4*k3))*2,
	accent(3, $ff, $ppp),
	gieclassic,
	step("4G", gimajor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", giminor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(3, 8, 32, "heart", 1) $then
	e(oncegen(girot), "fim",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 4*k3))*2,
	accent(3, $ff, $ppp),
	gieclassic,
	step("4G", gimajor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", giminor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(3, 8, 32, "heart") $then
	ed(oncegen(gidist), "fim",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 4*k3))*2,
	accent(3, $ff),
	gieclassic,
	step("4G", gimajor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", giminor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif


	endin
	start("score")

	
	instr route
getmeout("burd")
getmeout("fim")
getmeout("wendj")
	endin
	start("route")

