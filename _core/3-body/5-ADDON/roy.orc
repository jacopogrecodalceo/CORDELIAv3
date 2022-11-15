#ifdef royaumont

	gkroy1 init 0
	gkroy2 init 0
	gkroy3 init 0
	gkroy4 init 0
	gkroy5 init 0
	gkroy6 init 0
	gkroy7 init 0
	gkroy8 init 0

		instr 3005

	kdata[] init 16
	iport OSCinit 3000

	kans, kdata OSClisten iport, "/imss", "ffffffffffffffff"

	kgate init 1
	kndx init 0
	ktime = gkbeatms/4

	if kgate == 0 then
		kndx += 1
		if kndx > ((sr/1000) / ksmps)*ktime then
			kgate = 1
			kndx = 0	
		endif
	endif 

	kmo1 = kdata[0]
	kmo2 = kdata[2]
	kmo3 = kdata[4]
	kmo4 = kdata[6]
	kmo5 = kdata[8]
	kmo6 = kdata[10]
	kmo7 = kdata[12]
	kmo8 = kdata[14]

	if kgate == 1 then

		if kmo1 > .5 then
			gkroy1 = 1
			kgate = 0
		endif

		if kmo2 > .5 then
			gkroy2 = 1
			kgate = 0
		endif

		if kmo3 > .5 then
			gkroy3 = 1
			kgate = 0
		endif

		if kmo4 > .5 then
			gkroy4 = 1
			kgate = 0
		endif

		if kmo5 > .5 then
			gkroy5 = 1
			kgate = 0
		endif

		if kmo6 > .5 then
			gkroy6 = 1
			kgate = 0
		endif

		if kmo7 > .5 then
			gkroy7 = 1
			kgate = 0
		endif

		if kmo8 > .5 then
			gkroy8 = 1
			kgate = 0
		endif

	endif

		prints "royOSClisten is listening\n"

		endin
		alwayson(3005)



	gkroy_top1 init 0
	gkroy_top2 init 0
	gkroy_top3 init 0
	gkroy_top4 init 0
	gkroy_top5 init 0
	gkroy_top6 init 0
	gkroy_top7 init 0
	gkroy_top8 init 0

		instr 3015

	kdata[] init 16
	iport OSCinit 4000

	kans, kdata OSClisten iport, "/imss", "ffffffffffffffff"

	kgate init 1
	kndx init 0
	ktime = gkbeatms/4

	if kgate == 0 then
		kndx += 1
		if kndx > ((sr/1000) / ksmps)*ktime then
			kgate = 1
			kndx = 0	
		endif
	endif 

	gkmo_top1 = kdata[0]
	gksum_top1 = kdata[1]

	gkmo_top2 = kdata[2]
	gksum_top2 = kdata[3]

	gkmo_top3 = kdata[4]
	gksum_top3 = kdata[5]

	gkmo_top4 = kdata[6]
	gksum_top4 = kdata[7]

	gkmo_top5 = kdata[8]
	gksum_top5 = kdata[9]

	gkmo_top6 = kdata[10]
	gksum_top6 = kdata[11]

	gkmo_top7 = kdata[12]
	gksum_top7 = kdata[13]

	gkmo_top8 = kdata[14]
	gksum_top8 = kdata[15]


	if kgate == 1 then

		if gkmo_top1 > .5 then
			gkroy_top1 = 1
			kgate = 0
		endif

		if gkmo_top2 > .5 then
			gkroy_top2 = 1
			kgate = 0
		endif

		if gkmo_top3 > .5 then
			gkroy_top3 = 1
			kgate = 0
		endif

		if gkmo_top4 > .5 then
			gkroy_top4 = 1
			kgate = 0
		endif

		if gkmo_top5 > .5 then
			gkroy_top5 = 1
			kgate = 0
		endif

		if gkmo_top6 > .5 then
			gkroy_top6 = 1
			kgate = 0
		endif

		if gkmo_top7 > .5 then
			gkroy_top7 = 1
			kgate = 0
		endif

		if gkmo_top8 > .5 then
			gkroy_top8 = 1
			kgate = 0
		endif

	endif

		prints "roytopOSClisten is listening\n"

	gkmo_topsum = gkmo_top1 + gkmo_top2 + gkmo_top3 + gkmo_top4 + gkmo_top5 + gkmo_top6 + gkmo_top7 + gkmo_top8
	gksum_topsum = gksum_top1 + gksum_top2 + gksum_top3 + gksum_top4 + gksum_top5 + gksum_top6 + gksum_top7 + gksum_top8

		endin
		alwayson(3015)

#end


