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
gigatems init .25;in seconds
gilast init gigatems

    instr 1

idiff = times:i() - gilast

if idiff >= gigatems then

    Sfile           init p4
    istart          init p5/1000
    iloop           init p6
    igain           init p7
    ifin_dur        init p8/1000
    ifin_mode       init p9
    ifout_dur       init p10/1000
    ifout_mode      init p11
        
        prints "\n---\n"
        prints "INSTANCE: %.003f\n", p1
        prints "I'm reading the file: %s\n", Sfile
        prints "with a fadein of %ims\n", ifin_dur*1000
        prints "and a fadeout of %ims\n", ifout_dur*1000
        prints "---\n"

    kindex init 0
    if metro:k(1/5) == 1 then
        kindex += 5
        printsk "%s", Sfile
    endif

        printks2 "---%ds\n", kindex 

    aout_file[]     diskin Sfile, 1, istart, iloop
    ich_file        lenarray aout_file
    ilen            filelen Sfile
    idur            init ilen

    if iloop == 0 then
        p3              init idur
    elseif iloop == 1 then
        p3              init -1
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

        aout_file       *= linseg(1, ifout_dur, 0)
        
        printks2 "\n---\n%.03f is starting releasing phase\n", p1
        printks2 "with a fadeout of %.02fs\n---\n", ifout_dur*1000
    endif

        out aout_file*igain
        gilast = times:i()
endif
    endin

</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>
