setpde:		;Set the energy of player d1 of team a2 to d0
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
