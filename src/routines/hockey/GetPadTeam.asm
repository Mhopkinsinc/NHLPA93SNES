GetPadTeam:		;SNES: a2 = team of the controller that paused (cont1team/cont2team by sfpj)
	stz.b a2
	lda.w cont1team
	beq .rtl
	lda.w sflags
	bit.w #$0002
	beq .cont1
	lda.w cont2team
	bra .gotteam
.cont1:
	lda.w cont1team
.gotteam:
	cmp.w #$0001
	beq .rtl
	inc.b a2
	inc.b a2
.rtl:
	rtl
