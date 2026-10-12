setd0player:		;give control of player d0 to a controller if his team is controlled
		;   SNES: give player d0 to the controller of his team (setc1player/setc2player) unless a controller has him already
	lda.b d0
	cmp.w c1playernum
	beq .rtl
	cmp.w c2playernum
	beq .rtl
	stz.b d1
	cmp.w #$0006
	bcs .away
	dec.b d1
.away:
	inc.b d1
	inc.b d1
	lda.w lastplayer
	cmp.w c2playernum
	beq .c2
	lda.b d1
	cmp.w cont1team
	bne .c2
	jml.l setc1player
.c2:
	lda.b d1
	cmp.w cont2team
	bne .c1
	jml.l setc2player
.c1:
	cmp.w cont1team
	bne .rtl
	jml.l setc1player
.rtl:
	rtl
