updateanim:		;frame switch control on struct a3. Also called from ScoutTeamStep
		;   SNES: SPA = offset in SPAList; next frame when SPAcnt runs out (d7), loops or ends the animation
	lda.w SPA,x		; no animation: clear pfalock, pf2aip
	bne .ia
	stz.w pf2aip,x
	stz.w pfalock,x
	rtl
.ia:
	clc		; a0 = SPAList + SPA; d1 = attributes (+$10)
	adc.w #SPAList&$FFFF
	sta.b a0
	lda.w #SPAList>>16
	sta.b a0+2
	ldy.w #$0010
	lda.b [a0],y
	sta.b d1
	lda.w facedir,x
	sta.b d0
	lda.w sfhormode		; horizontal rink: players turn 90 degrees
	beq .nhor
	cpx.w #$0018
	bcs .nhor
	lda.b d0
	dec a
	dec a
	and.w #$0007
	sta.b d0
.nhor:
	lda.w attribute,x		; x flip: mirror the direction
	bit.w #$0800
	beq .nox
	lda.b d0
	eor.w #$FFFF
	inc a
	and.w #$0007
	sta.b d0
.nox:
	lda.b d0		; a0 += direction table entry; d2 = new frame
	asl a
	tay
	lda.b [a0],y
	adc.b a0
	sta.b a0
	ldy.w SPAnum,x
	sty.b d0
	lda.b [a0],y
	sta.b d2
	lda.w SPAcnt,x		; SPAcnt negative: hold the frame
	bmi .1
	sec
	sbc.b d7
	sta.w SPAcnt,x
	bpl .cframe
	lda.w SPAnum,x		; next frame (4 bytes); a negative frame ends the list
	clc
	adc.w #$0004
	sta.w SPAnum,x
	iny
	iny
	iny
	iny
	sty.b d0
	dey
	dey
	lda.b [a0],y
	bpl .1
	stz.b d0		; end: restart, clear pfalock/pf2aip; d1 bit 0 = looper, else SPA = 0
	stz.w SPAnum,x
	stz.w pf2aip,x
	stz.w pfalock,x
	lda.b d1
	lsr a
	bcs .1
	stz.w SPA,x
.1:		;SPAcnt = |delay|
	ldy.b d0
	iny
	iny
	lda.b [a0],y
	bit.w #$8000
	beq .0
	eor.w #$FFFF
	inc a
.0:
	sta.w SPAcnt,x
.cframe:		;frame = new frame
	lda.b d2
	sta.w frame,x
	rtl
