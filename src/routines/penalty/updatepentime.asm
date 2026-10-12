updatepentime:		;update the time remaining on all penalized players, once a second
		;   SNES: once a second count down the penalty box times of both teams; release players whose time is up
	lda.w #$0020
	trb.w sflags3
	lda.w gmclock
	bne .rtl
	lda.w pentimer
	sec
	sbc.b d7
	sta.w pentimer
	bpl .rtl
	adc.w #$0018
	sta.w pentimer
	lda.w #$0020
	tsb.w sflags3
	jsl.l chkatop
	stz.b a2
	jsl.l .team
	lda.w #$0002
	sta.b a2
.team:		;team a2
	lda.b a2
	beq .noa2
	lda.w #$001A
.noa2:
	sta.b a0
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #$0002
	sta.b d1
	sta.b d3
.next:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .done
	lda.b a2
	beq .noa22
	lda.w #$0034
.noa22:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .coinpen
	dec.b d1
	bmi .next
	lda.b d0
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w tmpdst,y
	dec a
	sta.w tmpdst,y
	bne .cont
	jsl.l RemovePlayerFromList
.cont:
	bra .next
.rtl:
	rtl
.done:
	lda.w mesarea
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .chk
	lda.b d1
	bne .n1
	jsl.l .chk
	bra .two
.n1:
	lda.b d1
	cmp.w #$FFFF
	bne .rtl
.two:
	lda.w mesarea+2
	sta.b d0
.chk:		;release player d0 when his time is <= 5 (RemovePlayerFromList)
	lda.b a2
	beq .noa23
	lda.w #$0034
.noa23:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0005
	beq .le5
	bmi .lt
	bvs .le5
	bra .rtl
.lt:
	bvs .rtl
.le5:
	lda.w tmpdst,y
	bne .rtl2
	jsl.l releasepl
.rtl2:
	rtl
.coinpen:
	dec a
	sta.w tmpdst,y
	bit.w #$0800
	bne .coindone
	jmp.w .next
.coindone:
	bit.w #$1000
	bne .clr
	lda.w #$1000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
.clr:
	lda.w #$0000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
