showclock:		;put the game clock in the dma list. Called from setvideo; returns unless dfclock is set.
		;   SNES: the game clock m:ss at x 3, y $18 (horizontal rink: x $D, y 4; not when gsp = 4); not in replay
	lda.w sflags
	bit.w #sf2replay
	beq .nosf2replay
	jmp.w .rtl
.nosf2replay:
	lda.w #$0007
	sta.w mesarea
	lda.w #$0020
	sta.w mesarea+2
	lda.w gameclock
	sta.b mulb
	lda.w #600
	sta.b mula
	jsl.l divu16
	beq .notens
	adc.w #$0030
	sta.w mesarea+2
.notens:
	lda.w #60
	sta.b mula
	lda.b mulres+2
	sta.b mulb
	jsl.l divu16
	adc.w #$0030
	sta.w mesarea+3
	lda.w #':'
	sta.w mesarea+4
	lda.w #10
	sta.b mula
	lda.b mulres+2
	sta.b mulb
	jsl.l divu16
	adc.w #$0030
	sta.w mesarea+5
	lda.b mulres+2
	adc.w #$0030
	sta.w mesarea+6
	lda.w #$2000
	sta.w printa
	lda.w #$0003
	sta.w printx
	lda.w #$0018
	sta.w printy
	lda.w sfhormode
	beq .nosfhormode
	lda.w #$000D
	sta.w printx
	lda.w #$0004
	sta.w printy
	lda.w gsp
	cmp.w #$0004
	beq .rtl
.nosfhormode:
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	jml.l print
.rtl:
	rtl
