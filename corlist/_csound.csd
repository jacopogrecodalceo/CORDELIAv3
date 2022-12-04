<CsoundSynthesizer>
<CsOptions>
--port=10000
--udp-echo
-odac
--env:SSDIR+=../
--messagelevel=96
--m-amps=1
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs  = 1

prints "I'm ready!\n"

    instr 1

Sfile           init p4
istart          init p5/1000
iloop           init p6
igain           init p7
ifin_dur        init p8/1000
ifin_mode       init p9
ifout_dur       init p10/1000
ifout_mode      init p11

if istart > idur igoto ERROR

prints "\n---\n"
prints "INSTANCE:\t%.003f\n", p1
prints "FILE:\t%s\n", Sfile
prints "FADEIN\t%ims\n", ifin_dur*1000
prints "FADEOUT\t%ims\n", ifout_dur*1000
prints "---\n"

if iloop == 0 then
    p3              init idur
    printks2 ":	%ds left // ", ksec
    printks2 "%.02f%%\n", (ksec*100)/idur 
elseif iloop == 1 then
    p3              init -1
    printks2 ":	in loop\n", ksec
endif

aout_file[]     diskin Sfile, 1, istart, iloop
ich_file        lenarray aout_file
ilen            filelen Sfile
idur            init ilen

ksec init idur
if metro:k(1) == 1 then
    ksec -= 1
    printsk "%s", Sfile
endif



if ifin_mode == 0 then
    aout_file       *= cosseg(0, ifin_dur, 1)
elseif ifin_mode == 1 then
    aout_file       *= linseg(0, ifin_dur, 1)
endif

            xtratim ifout_dur
krel		init 0
krel		release

if krel == 1 then

    if ifout_mode == 0 then
        aout_file       *= cosseg(1, ifout_dur, 0)
    elseif ifout_mode == 1 then
        aout_file       *= linseg(1, ifout_dur, 0)
    endif

    printks2 "\n---\n%.03f is starting releasing phase\n", p1
    printks2 "with a fadeout of %.02fs\n---\n", ifout_dur*1000

endif

            out aout_file*igain
    gilast = times:i()

ERROR:
    prints "☢️WARNING☢️: starting point is greter than duration"
    turnoff
    endin

	instr MNEMOSINE

gSout	init p4
aouts[]	init nchnls
aouts	monitor

	fout gSout, -1, aouts

	endin

</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>
