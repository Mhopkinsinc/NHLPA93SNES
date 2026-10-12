revplayeracc:		;SNES: playeracc with the direction d2 turned 180 degrees for a reversed player (pfrev)
	lda.w pfrev,x
	beq .acc
	lda.b d2
	eor.w #$0004
	sta.b d2
.acc:
	jml.l playeracc
