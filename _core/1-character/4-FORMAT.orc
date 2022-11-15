	instr	abstime

gkabstime	times
	
	endin
	alwayson("abstime")

	instr key_listen

iesc	init 27
kascii, kpress sensekey

if kascii == iesc && kpress == 1 then
	printks "\n🌊 GOOOOODBYE! 🌊\n", 1
	event "e", 0, .5
	turnoff
endif

	endin
	alwayson("key_listen")

#ifdef $out_wav
gSout_wav	init $out_wav
#else
gSout_wav	init "../_score/cor-1.wav"
#end

#ifdef $out_orc
gSout_orc	init $out_orc
#else
gSout_orc	init "../_score/cor-1.orc"
#end
