ResetAndSelectPlayers:		;c1playernum/c2playernum = -1, then changeplayer for each human team. Called from puckfaceoff2
		;   SNES: c1playernum/c2playernum = -1, then changeplayer for each human team (d4 = 0, 2)
	lda.w #$FFFF
	sta.w c1playernum
	sta.w c2playernum
	lda.w cont1team
	beq .nt1
	stz.b d4
	jsl.l changeplayer
.nt1:
	lda.w cont2team
	beq .rtl
	lda.w #$0002
	sta.b d4
	jsl.l changeplayer
.rtl:
	rtl
