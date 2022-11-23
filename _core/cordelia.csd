<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
-m0
-D
-M0
;-+msg_color=1
--messagelevel=96
--m-amps=1


;-+id_artist=jacopo greco d'alceo
;-b 4096 ;mac 1024
;-B 8192 ;mac2048

;-+rtaudio=CoreAudio
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

;		INs
ginkick_ch	init 9	;a mono channel
ginsna_ch	init 10
gimic1		init 1

;#define hydraudiosync ##
;#define printscore ##
;#define midi  ##
;#define diskclavier  ##
;#define royaumont ##
#define MIDIin ##


#define JOIN(arg1'arg2) #$arg1/$arg2#



#includestr "$JOIN($CORDELIA_PATH'_core/1-character/0-PATH.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/1-character/1-MACRO.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/1-character/2-GLOBAL_VAR.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/1-character/3-MACRO_IFDEF.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/1-character/4-FORMAT.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/1-character/5-DYN.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/_wav.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/asaw.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/asine.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/asquare.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/atk.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/atri.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/bite.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/classic.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/classicr.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/eau.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/eclassic.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/eclassicr.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/emirror.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/fade.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/han.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/icsc1.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/icsc2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/icsc3.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/icsc4.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/isotrap.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/kazan.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/kazanr.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/likearev.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/likearevr.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/maigret.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/mirror.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/ropy.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/1-unipolar/spina.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/2-bipolar/_wav.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/2-bipolar/oddharm.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/2-bipolar/saw.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/2-bipolar/sine.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/2-bipolar/square.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/GEN/2-bipolar/tri.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/INSTR.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/SCALE-SCL.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/SCALE-SCL12.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/SCALE-SCL7.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/SCALE.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/2-head/SPACE.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/0-INIT.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/1-ORGAN.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/envgen.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/eva.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/evaMIDI.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/evad.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/getallout.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/getmech.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/getmeout.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/basic/start.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/cedonoi.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/edo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/fc.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/fc3.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/fch.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/step.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/freq/stepc.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/rhythm/eu.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/rhythm/eujo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/rhythm/hex.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/rhythm/jex.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/MIDI.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/accent.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/accenth.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/almost.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/lfh.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/metrout.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/morpheus.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/once.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/oncegen.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/one.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/op_circles.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/op_compression.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/op_externals.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/op_modulator.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/op_ramp.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/rprtab.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/schedulech.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/2-OP/util/tabj.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/3-OUT/_OUT-full.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/alghed.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/alghef.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/algo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/algo2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/amen.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/amor.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/arm1.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/arm2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/armagain.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/bd10.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/bee.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/bleu.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/bois.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/bois2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/capr1x.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/capr2x.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/capriccio1.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/capriccio2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/chime.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/chiseq.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/ciel.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/coeur.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/contempo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/crij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/cril.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/dance.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/drum.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/drumhigh.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/etag.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/etag2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/fragment.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gameld.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gamelf.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gesto1.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gesto1var.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gesto2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gesto3.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/gesto4.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/hh.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/junis.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/leo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/madcow.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/maison.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/mario1.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/mario2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/meer.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/meli.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/nasa.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/ninfa.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/november.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/ocean.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/planche.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/reg.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/search.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/shaku.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/shinji.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/shinobi.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/six.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/six2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/tape.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/tension.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/toy.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/valle.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/_sample/virgule.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/aaron.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/alone.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/alonefr.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/bass.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/bebois.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/beboo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/bebor.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/becapr.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/bee.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/begad.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/begaf.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/beme.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/between.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/betweenmore.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/burd.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/calin.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/calinin.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/careless.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/careless2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/cascade.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/cascadexp.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/click.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/corpia.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/curij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/curij2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/dmitri.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/dmitrif.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/euarm.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/euarm2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/fairest.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/fairest2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/fairest3.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/fairest4.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/fim.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/flij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/flou.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/fuji.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/grind.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/grind2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/grind3.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/inkick.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/inmic1.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/insna.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/ipercluster.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/ixland.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/kick.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/lucas.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/maij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/maij2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/meli2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/metal.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/mhon.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/mhon2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/mhon2q.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/mhonq.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/noij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/ohoh.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/orphans.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/orphans2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/orphans3.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/pij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/pijnor.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/puck.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/pucky.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/pur.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/qb.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/repuck.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/sfpiano.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/simki.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/skij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/sufij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/sufij2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/sunij.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/toomuchalone.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/trans.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/uni.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/ventre.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/wendi.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/wendj.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/wendy.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/witches.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/witches2.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/wutang.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/4-INSTR/xylo.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/5-ADDON/roy.orc)"
#includestr "$JOIN($CORDELIA_PATH'_core/3-body/6-SOUL.orc)"

</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>