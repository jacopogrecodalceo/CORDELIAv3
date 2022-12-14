<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
-m0
-D
;-M0
;-+msg_color=1
--messagelevel=96
--m-amps=1


;-+id_artist=jacopo greco d'alceo
;-b 512 ;mac 1024
;-B 1024 ;mac 2048

-b 1024
-B 2048
;-+rtaudio=CoreAudio

;-b 1024
;-B 4096
;-+rtaudio=auhal

;--realtime
;--num-threads=8
;--m-colours=1
;--udp-echo

;--midioutfile=FILENAME
;--nosound

;-v		;verbose orch translation
;-N		;notify (ring the bell) when score or miditrack is done
;--postscriptdisplay     ;suppress graphics, use Postscript displays
;--env:SSDIR=/Users/j/Documents/PROJECTs/IDRA/samples ;/Users/j/Documents/my_livecode/_samples
;--env:OPCODE6DIR64=/Library/Frameworks/CsoundLib64.framework/Versions/6.0/Resources/Opcodes64
;--opcode-lib=/Users/j/Documents/PROJECTs/__INSTRUMENTs__/hypercurve/git/build/csound_opcode/libcsound_hypercurve.dylib
</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000

ksmps		=	64	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	2
0dbfs		=	1
;A4		=	438	;only for ancient music	

ginchnls	init nchnls	;e.g. click track
gioffch		init 0		;e.g. I want to go out in 3, 4

;#define hydraudiosync ##
;#define printscore ##
;#define midi  ##
;#define diskclavier  ##
;#define royaumont ##
#define MIDIin ##


#define JOIN(arg1'arg2) #$arg1/$arg2#



