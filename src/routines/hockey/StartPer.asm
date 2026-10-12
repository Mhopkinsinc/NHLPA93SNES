StartPer:		;Start a period: reset the rink and clock, face off at center ice, then the game loop
	lda.w #$1FFF		; reset the stack
	tcs
	jsl.l Readjoy1
	jsl.l Readjoy2
	jsl.l Readjoy1
	jsl.l Readjoy2
	jsl.l Readjoy1
	jsl.l Readjoy2
	jsl.l Readjoy1
	jsl.l Readjoy2
	stz.b a2
	jsl.l reenergizeteam
	lda.w #$0002
	sta.b a2
	jsl.l reenergizeteam
	jsl.l sndqreset
	stz.b sprclock		; sprite VRAM slots
	jsl.l setupice
	jsl.l ResetClock
	lda.w #$F000
	tsb.w PadControlBits
	lda.w #$FFFF		; no controlled players
	sta.w c1playernum
	sta.w c2playernum
	sta.w lcplayer
	ldx.w #puckobj		; puck: puckfaceoff at centre ice
	stx.b a3
	stz.w fox
	stz.w foy
	lda.w #$1B
	sta.b d0
	jsl.l assreplace
	lda.w gsp		; third period: p3cue = random time
	cmp.w #$0002
	bne .p3
	lda.w gameclock
	sta.b mula
	lda.w #12
	sta.b mulb
	jsl.l mulu16
	jsl.l randoma
	inc a
	sta.w p3cue
.p3:
	lda.w gsp		; periods 1 and 2: mid-period cue at half time
	cmp.w #$0002
	bcs .blank
	lda.w gameclock
	lsr a
	sta.w midpercue
.blank:
	lda.w blankchar
	clc
	adc.w charofs
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #sf2drec		; sf2drec: no replay record
	tsb.w sflags
	lda.w #sfwrap		; sfwrap off
	trb.w sflags
	stz.w lastsfx
	lda.w #ReplayBufferStart		; replay buffer start
	sta.w ReplayBufferPtr
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	inc.w percue		; period start music cue
	stz.b vcount
	stz.b vcount+2
	stz.w lastframevc
	stz.w oldvcount
	jml.l Gameloop		; the game loop (bank $8E)
