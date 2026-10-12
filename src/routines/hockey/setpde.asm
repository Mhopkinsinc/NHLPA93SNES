setpde:		;d1 = rostnum of player * 2, a2 = team struct
		;   SNES: tmpde of player d1 (team a2) = d0 (not below 0)
	lda.b a2
	beq .home
	lda.w #$0034
.home:
	clc
	adc.b d1
	tay
	lda.b d0
	bpl .store
	lda.w #$0000
	sta.b d0
.store:
	sta.w tmpde,y
	rtl
