AdvanceStringPtr:		;Return a1 = string d0 of the String list a1
		;   SNES: a1 = string d0 of the list [a1]
	bra .cnt
.next:
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.cnt:
	dec.b d0
	bpl .next
	rtl
