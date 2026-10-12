getpde:		;d0 = the energy of player X
	lda.w pfteam,x
	beq .0
	lda.w #$0002		; a2 = 2: away team
.0:
	sta.b a2
	lda.w pnum,x
	and.w #$00FF		; pnum low byte
	asl a
	sta.b d1
	lda.b a2
	beq .idx
	lda.w #$0034		; away team entries start $34 bytes in
.idx:
	adc.b d1
	tay
	lda.w tmpde,y
	sta.b d0
rtss:		;the rtl that ends getpde, also used as a do-nothing callback (lda #rtss for skateto)
	rtl
