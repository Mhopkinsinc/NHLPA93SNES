clrplayer:		;take the joystick off player a3
		;   SNES: take the joystick off player X (changeplayer)
	lda.w pflags,x
	bit.w #pfjoycon
	beq asspenalty_rtl
	stz.b d4
	txa
	lsr a
	sta.b d0
	cmp.w c1playernum
	beq .ch
	inc.b d4
	inc.b d4
.ch:
	jml.l changeplayer
