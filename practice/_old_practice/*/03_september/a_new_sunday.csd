	instr Score

ktime	= 21 + randomh(-15, 3, gkbeatf)

if (eu(6, 6, pump(5, fillarray(16, ktime)), "heart") == 1) then
	e("puck",
	gkbeats*2,
	lfse($mf, $p, gkbeatf*32),
	step("2B", gkkumoi, pump(2, fillarray(1, 1, -1, 1))),
	step("2B", gkkumoi, pump(2, fillarray(3, 4, 2, 2))),
	step("2B", gkkumoi, pump(2, fillarray(5, 5, 6, 7))))
endif

if (eu(6, 7, pump(5, fillarray(16, ktime-1)), "heart") == 1) then
	e("repuck",
	gkbeats*3,
	lfse($mp, $pp, gkbeatf*32),
	step("4B", gkkumoi, pump(2, fillarray(1, 1, -1, 1))),
	step("4B", gkkumoi, pump(2, fillarray(3, 4, 2, 2))),
	step("4B", gkkumoi, pump(4, fillarray(5, 5, 6, 7))))
endif

if (eu(18, 32, 16, "heart") == 1) then
	e("snug",
	gkbeats/lfse(2, 3, gkbeatf*8),
	heartmurmur(4, $ff),
	step("3B", gkkumoi, pump(2, fillarray(1, 1, -1, 1))),
	step("3B", gkkumoi, pump(2, fillarray(3, 4, 2, 2))),
	step("5B", gkkumoi, pump(2, fillarray(5, 5, 6, 7))))
endif

if (eu(1, 6, pump(4, fillarray(16, 18)), "heart") == 1) then
	e("fairest",
	gkbeats*4,
	lfse($fff, $f, gkbeatf*32),
	step("1B", gkkumoi, pump(2, fillarray(1, 1, -1, 1))))
endif
	endin
	start("Score")



	instr Route

getmeout("puck")
getmeout("repuck")

chnset(lfse(.25, .75, gkbeatf/8, 4), "moog.freq")
chnset(lfse(5$c, 5$k, gkbeatf/8, 4), "moog.freq")
routemeout("snug", "moog")
routemeout("fairest", "moog", 2)

	endin
	start("Route")
