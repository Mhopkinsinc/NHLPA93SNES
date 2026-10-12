Endfaceoff:		;Drop the puck: pick the face off winner and send the puck off
	lda.w seed+2		; puck on the ice sound
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	lda.w #sf2faceoff		; faceoff over, fobox off, replay record on, clock running
	trb.w sflags
	stz.b fobox
	lda.w #sf2drec
	trb.w sflags
	stz.w gmclock
	stz.w pf2fight,x
	lda.w #sf3fo		; sf3fo
	tsb.w sflags3
	lda.w fodir1		; d3 = fodir1, d4 = $800 (toward the top), a1 = home
	sta.b d3
	lda.w #$0800
	sta.b d4
	stz.b a1
	lda.w #$0010
	sta.b d2
	ldx.w fofdata2
	lda.l .ftab-1,x
	and.w #$00FF
	bit.w #$0080
	beq .f1
	ora.w #$FF00
.f1:
	eor.w #$FFFF
	inc a
	clc
	adc.b d2
	sta.b d2
	ldx.w fofdata2+4
	lda.l .ftab-1,x
	and.w #$00FF
	bit.w #$0080
	beq .f2
	ora.w #$FF00
.f2:
	clc
	adc.b d2
	sta.b d2
	lda.w #$0021		; random(33) vs the pull frames: who won
	jsl.l randoma
	cmp.b d2
	bcs .p1won
	lda.w #$0004		; visitors won
	sta.b a1
.p1won:
	ldx.b a1
	lda.w fofdata2+2,x
	bit.w #$0800		; winner faces down: fodir2, -$800
	beq .pos
	lda.w fodir2
	sta.b d3
	lda.w #$F800
	sta.b d4
.pos:
	lda.b d3
	bit.w #$0008
	bne .nojoy
	and.w #$0007
	sta.b d0
	lda.w seed		; joystick direction 3 in 4
	and.w #$0003
	bne .nj2
.nojoy:
	lda.w #$0005		; random direction -2..2
	jsl.l randoma
	dec a
	dec a
	and.w #$0007
	sta.b d0
	lda.b d4
	bmi .nj2
	lda.b d0
	eor.w #$0004
	sta.b d0
.nj2:
	asl.b d0
	asl.b d0
	ldx.b d0
	lda.l dirtab,x		; Xvel = dirtab x * 32
	asl a
	asl a
	asl a
	asl a
	asl a
	ldx.b a3
	sta.w Xvel,x
	ldx.b d0
	lda.l dirtab+2,x		; Yvel = dirtab y * 32 + d4
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.b d4
	ldx.b a3
	sta.w Yvel,x
	lda.w #$0800		; Zvel = random(0..$800)
	jsl.l randoma
	sta.w Zvel,x
	stz.w Zpos+puckobj
	stz.w pfnc,x
	lda.w #pnorm		; pnorm
	sta.b d0
	jmp.w assreplace
.ftab:		;faceoff strength by pull frame
	db 0,8,16,0,8,16
