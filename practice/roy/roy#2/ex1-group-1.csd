	instr score

gkpulse = 80-(k(follow2(limit(a(gkmo_top4), 0, 1), 1, .05))*35)

$when(eujo(3, 8, 4))
	eva("fairest",
	gkbeats*24,
	accent(3, $ff),
	$once(giatri, gidiocle),
	step("3D", gimixolydian, random:k(1, 12)))
endif
gkfairest_harm = 1+k(follow2(limit(a(gkmo_top1), 0, 1), .025, .95))*2

$when(gkroy_top3)
	$when(eujo(5, 8, 32))
		eva("planche", "tension",
		gkbeats/$once(2, 4, 8, 4, 8)*12,
		accent(3, $ff),
		giclassic,
		$once(2, 4, 8, 4, 8))
	endif
	gkroy_top3 = 0
endif


$when(gkroy_top4)
	eva("arm2",
	gkbeats/$once(2, 4, 8, 4, 8)*2,
	accent(3, $mp),
	giclassic,
	$once(2, 4, 8)/4)
	gkroy_top4 = 0
endif
	endin
	start("score")

	
	instr route

getmeout("fairest", follow2(limit(a(gkmo_top1), 0, 1), .025, 5))
flingj2("planche", 25*portk(limit(gkmo_top3, 0, 1), 3), .5*k(follow2(limit(a(gkmo_top3), 0, 1), 3, .05)), 1/12*k(follow2(limit(a(gkmo_top3), 0, 1), 1, .15)))
getmeout("tension", 4)

flingj3("arm2", gkbeatms*k(follow2(limit(a(gkmo_top4), 0, 1), .5, .05)), .5+.15*k(follow2(limit(a(gkmo_top4), 0, 1), 3, .05)), k(follow2(limit(a(gkmo_top4), 0, 1), .025, .025)))

	endin
	start("route")

