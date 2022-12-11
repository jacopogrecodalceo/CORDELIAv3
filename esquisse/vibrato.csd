<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
-m0
-D
;-+msg_color=1
--messagelevel=96
--m-amps=1
--env:SSDIR+=../

-+rtaudio=CoreAudio

</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000

ksmps		=	1	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	8
0dbfs		=	1
;A4		=	438	;only for ancient music	

#include "../_core/2-head/SCALE-SCL12.orc"
#include "../_core/2-head/SCALE-SCL.orc"

    instr 1

ift     init gi11_10ET
iamp    init p8

aenv    cosseg 0, .5, 1, p3-.5, 0

icps    cpstuni p4, ift
        print icps

icps_vib cpstuni p4+p5, ift   
aamp    = (icps_vib-icps)*aenv

afreq   cosseg p6, p3, p7

aout    poscil iamp/8, icps+oscili(aamp, afreq*aenv), 3
aout    *= aenv
        outall aout

    endin

</CsInstruments>
<CsScore>

f 3 0 16384 10 1 0 0.3 0 0.2 0 0.14 0 .111

                ;4          5               6               7           8
                ;note       ;note vib       ;from           ;to         ;amp
i 1 0 125       70          1               0               15           .125
i 1 0 .         69          1               5               0           .125

i 1 0 .         69          3               15.5           .25          .0125
e

</CsScore>
</CsoundSynthesizer>