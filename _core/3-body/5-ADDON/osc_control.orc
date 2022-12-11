gicontrol_port		OSCinit 9750

gkp1			init 0
gkp2			init 0

	instr inosc1
kp		init 0
next:
kk		OSClisten gicontrol_port, "/p1", "f", kp
if (kk == 0) goto nothing
	gkp1	= kp
	kgoto next
nothing:
	endin
	alwayson("inosc1")

	instr inosc2
kp		init 0
next:
kk		OSClisten gicontrol_port, "/p2", "f", kp
if (kk == 0) goto nothing
	gkp2	= kp
	kgoto next
nothing:
	endin
	alwayson("inosc2")

;//

gkpjohann	init 0
gkpenrico	init 0
gkpmod		init 0

	instr inosc_enrico
kp		init 0
next:
kk		OSClisten gicontrol_port, "/penrico", "f", kp
if (kk == 0) goto nothing
	kp	limit kp, 0, 1
	gkpenrico	= kp
	kgoto next
nothing:
	endin
	alwayson("inosc_enrico")

	instr inosc_johann
kp		init 0
next:
kk		OSClisten gicontrol_port, "/pjohann", "f", kp
if (kk == 0) goto nothing
	kp	limit kp, 0, 1
	gkpjohann	= kp
	kgoto next
nothing:
	endin
	alwayson("inosc_johann")

	instr inosc_mod
kp		init 0
next:
kk		OSClisten gicontrol_port, "/pmod", "f", kp
if (kk == 0) goto nothing
	kp	limit kp, 0, 1
	gkpmod	= kp
	kgoto next
nothing:
	endin
	alwayson("inosc_mod")

;//

giosc_freq	init 5

gkpjacopo	init 0

	instr outosc_enrico
kwhen	metro giosc_freq
	OSCsend kwhen, "192.168.1.74", 9750, "/pjacopo", "f", gkpjacopo
	endin
	alwayson("outosc_enrico")


	instr outosc_johann
kwhen	metro giosc_freq
	OSCsend kwhen, "192.168.1.95", 9750, "/pjacopo", "f", gkpjacopo
	endin
	alwayson("outosc_johann")

