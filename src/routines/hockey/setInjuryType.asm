setInjuryType:		;sets period injury. a2 = player injured, a3 = player checking. Marks a2 unavailable, pumps up the crowd, plays sfx $D, locks the scroll on a2, sets TempPlOffset (pnum, bit
		;   15 set for the away team) and puts $FFFD (injured for the period) in a2's tmpdst. Called from FallDown and from chkhit .fall
		;   SNES: player a2 is injured: pflags bit $1000, crowdlevel + $12C, sfx $8C, the scroll locked on him (xc1/yc1, sflags $40), TempPlOffset
		;   = pnum (| $8000 for the visitors), his tmpdst = $FFFD (out for the period)
	ldy.b a2
	lda.w pflags,y
	ora.w #$1000
	sta.w pflags,y
	lda.b crowdlevel
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w #$008C
	pha
	jsl.l sfx
	ldy.b a2
	lda.w Xpos,y
	sta.w xc1
	lda.w Ypos,y
	sta.w yc1
	lda.w #$0040
	tsb.w sflags
	stz.b d1
	stz.b a0
	lda.w pfteam,y
	beq .home
	lda.w #$8000
	sta.b d1
	lda.w #$0002
	sta.b a0
.home:
	lda.w pnum,y
	and.w #$00FF
	ora.b d1
	sta.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .pos
	ora.w #$FF00
.pos:
	asl a
	sta.b d1
	lda.b a0
	beq .tmofs
	lda.w #$0034
.tmofs:
	adc.b d1
	tay
	lda.w #$FFFD
	sta.w tmpdst,y
	rtl
