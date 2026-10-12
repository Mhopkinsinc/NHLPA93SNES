restoreteams:		;Put both teams' rosters on the bench
		;   SNES: both rosters to the bench: tmap 6, every tmpdst -2
	stz.b a2
	jsl.l .r
	lda.w #$0002
	sta.b a2
.r:		;one team (a2)
	ldy.b a2
	lda.w #6
	sta.w tmap,y
	lda.w #$32
	sta.b d0
.0:
	lda.b a2
	beq .home
	lda.w #$34
.home:
	clc
	adc.b d0
	tay
	lda.w #TMPDBENCH		; TMPDBENCH
	sta.w tmpdst,y
	dec.b d0
	dec.b d0
	bpl .0
	rtl
