revplayeracc:		;playeracc for a player skating backwards
	lda.w pfrev,x
	beq .acc
	lda.b d2
	eor.w #$0004
	sta.b d2
.acc:
	jml.l playeracc
