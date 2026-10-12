setInjuryType:		;Player a2 is injured for the period: the crowd reacts, the view locks on him and the injury box gets his name
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
