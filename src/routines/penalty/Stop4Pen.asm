Stop4Pen:		;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from the penalty type, blow the whistle. Also entered from puckfaceoff+38
		;   SNES: a0 = PenBuf entry +2. Stop the clock, set the face off spot from the penalty type, blow the whistle
	lda.w #$FFFF		; clock already stopped: skip the face off spot
	tsb.w gmclock
	beq .spot
	jmp.w .skipfo
.spot:		;goal: center; OOP: last touch; icing: the end of the icing team (+-600); else the puck
	stz.b d0
	stz.b d1
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #PenGoal		; goal: center ice
	beq .noticing
	ldy.w ltx
	sty.b d0
	ldy.w lty
	sty.b d1
	cmp.w #PenOOP		; OOP: last touch
	beq .noticing
	ldy.w puckx
	sty.b d0
	ldy.w pucky
	sty.b d1
	cmp.w #PenIcing		; icing: +-600 by pfgoal of the icing player
	bne .noticing
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	asl a
	tay
	lda.w #$0258
	sta.b d1
	lda.w pfgoal,y
	beq .noticing
	lda.w #$FDA8
	sta.b d1
.noticing:
	lda.b d0		; x within +-70; y near the ends: end face off spots (+-206, x +-70)
	sta.b tmp0
	sec
	sbc.w #$0046
	bmi .neg
	bvc .x0
	bra .0
.neg:
	bvc .0
.x0:
	lda.w #$0046
	sta.b d0
.0:
	lda.b d0
	sec
	sbc.w #$FFBA
	beq .x1
	bmi .neg1
	bvs .x1
	bra .1
.neg1:
	bvs .1
.x1:
	lda.w #$FFBA
	sta.b d0
.1:
	lda.b d1
	sec
	sbc.w #$00A6
	bmi .neg2
	bvc .yhi
	bra .2
.neg2:
	bvc .2
.yhi:
	lda.w #$00CE
	sta.b d1
	lda.w #$0046
	sta.b d0
	lda.b tmp0
	bpl .2
	lda.w #$FFBA
	sta.b d0
.2:
	lda.b d1
	sec
	sbc.w #$FF5A
	beq .ylo
	bmi .neg3
	bvs .ylo
	bra .3
.neg3:
	bvs .3
.ylo:
	lda.w #$FF32
	sta.b d1
	lda.w #$0046
	sta.b d0
	lda.b tmp0
	bpl .3
	lda.w #$FFBA
	sta.b d0
.3:
	lda.b d0
	sta.w fox
	lda.b d1
	sta.w foy
	jsl.l limitfo
.skipfo:
	lda.b vcount		; sound cut off within 60 frames: reset the queue
	sec
	sbc.w sfxmutetime
	cmp.w #$003C
	bcc .snd
	jsl.l sndqreset
.snd:
	lda.w #SFXwhistle		; whistle, Pencntdwn = 0, gmpen, SetPA PenWhistle
	pha
	jsl.l sfx
	stz.w Pencntdwn
	lda.w #gmpen
	tsb.w gmode
	lda.w #PenWhistle
	sta.b d0
	jmp.w SetPA
