pucknorm:		;asstab $18. assignment for puck most of the time. a3 = puck, d7 = elapse frames since last call
		;   SNES: assignment for the puck most of the time. X = puck, d7 = elapsed frames
	lda.w #pfna
	trb.w pflags+puckobj		; pfna
	beq .nna
	stz.w temp1+puckobj		; temp1 = 0, temp2b = still puck timer 120
	stz.w temp2+puckobj
	lda.w #$0078
	sta.w temp2b+puckobj
.nna:
	lda.w puckcross+2		; puckcross times count down
	sec
	sbc.b d7
	sta.w puckcross+2
	lda.w puckcross+6
	sec
	sbc.b d7
	sta.w puckcross+6
	lda.w temp1+puckobj		; every 5 frames: findpc
	sec
	sbc.b d7
	sta.w temp1+puckobj
	bpl .0
	adc.w #$0005
	sta.w temp1+puckobj
	jsl.l findpc
.0:		;puck carried: pull it a quarter of the way to the carrier hot spot
	lda.w puckc		; puck carrier
	bmi .nothandled
	asl a
	sta.b a2
	jsl.l a2touchpuck
	lda.b a2
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	lsr a
	lsr a
	bit.w #$2000		; asr #2
	beq .x
	ora.w #$C000
.x:
	clc
	adc.w puckx
	sta.w puckx
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	lsr a
	lsr a
	bit.w #$2000
	beq .y
	ora.w #$C000
.y:
	clc
	adc.w pucky
	sta.w pucky
	lda.w Xvel,y		; puck velocity = carrier velocity
	sta.w puckvx
	lda.w Yvel,y
	sta.w puckvy
.nothandled:
	jsl.l puckIChk
	jsl.l ChkOffsides
	lda.w gmclock		; clock stopped
	bne .z
	lda.w puckc		; loose puck that has not moved for 120 calls: whistle
	bpl .mv
	lda.w puckx
	cmp.w OldXpos+puckobj
	bne .mv
	lda.w pucky
	cmp.w OldYpos+puckobj
	bne .mv
	lda.w #PenOOP		; PenOOP: whistle
	sta.b d0
	dec.w temp2b+puckobj
	bpl .np
	jsl.l AddPenalty2
.np:
	bra .z
.mv:		;reset the still puck timer
	lda.w #$0078
	sta.w temp2b+puckobj
.z:
	lda.w puckvz		; puck in the air: no unflip
	and.w #$FF00
	ora.w Zpos+puckobj
	beq .flat
	jmp.w checkpuckcoll
.flat:
	jsl.l pucknothing		; pucknothing: stop spinning
	jmp.w checkpuckcoll		; bra checkpuckcoll
