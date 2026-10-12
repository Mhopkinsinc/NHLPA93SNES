vtoa:		;d0/d1 are x/y distances which are converted into direction 0-7 and returned in d0 (8 = no direction)
		;   SNES: d0/d1 are x/y distances, returned in d0 as a direction 0-7 (8 = no direction)
	lda.b d0
	ora.b d1
	beq .nodir		; no direction
	stz.b d0+2
	lda.b d0
	bpl .0
	eor.w #$FFFF
	inc a
	sta.b d0
	inc.b d0+2
.0:
	lda.b d1
	bpl .1
	eor.w #$FFFF
	inc a
	sta.b d1
	inc.b d0+2
	inc.b d0+2
.1:
	lda.b d1		; bit 2: |dx| <= 2|dy|
	asl a
	cmp.b d0
	bcc .2
	lda.w #$0004
	tsb.b d0+2
.2:
	lda.b d0		; bit 3: |dy| <= 2|dx|
	asl a
	cmp.b d1
	bcc .3
	lda.w #$0008
	tsb.b d0+2
.3:
	phx
	ldx.b d0+2
	lda.l .dt,x
	plx
	and.w #$00FF
	sta.b d0
	rtl
.nodir:
	lda.w #$0008
	sta.b d0
	rtl
.dt:		;direction for each sign/ratio combination
	db 1,7,3,5,0,0,4,4,2,6,2,6,1,7,3,5
