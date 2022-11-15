	instr Score

gkpulse	= 120 +lfo(1, gkbeatf/32)

kch	= pump(1, fillarray(0, 1, 3, 2))

if (eu(16, 16, 16, "heart") == 1) then
	e("puck",
	gkbeats/2,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	step("4C", gkmajor, -2),
	step("4C", gkmajor, 1),
	step("4C", gkmajor, 2+kch))
endif

if (eu(16, 16, 8, "heart") == 1) then
	e("repuck",
	gkbeats,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	step("5C", gkmajor, -2),
	step("5C", gkmajor, 1),
	step("5C", gkmajor, 2+kch+7))
endif


givemednb(16, "heart")

	endin
	start("Score")

	instr Route
;chnset(.95, "delirium.fb")
;chnset(gkbeats/randomi:k(1, .25, gkbeatf/64), "delirium.time")
routemeout("puck", "delirium")
routemeout("repuck", "twinkle")
routemeout("repuck", "bribes")

getmeout("deliriumson", 2)
getmeout("deliriumdaughter", 3)

;followdrum("puck")

getmeout("puck")
getmeout("repuck")
getmeout("drum")
	endin
	start("Route")

