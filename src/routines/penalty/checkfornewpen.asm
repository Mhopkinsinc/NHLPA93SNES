checkfornewpen:		;look for new penalty (entered thru addpenalty(2)). Stops play at once for penalties without minutes or when the guilty team has the puck, otherwise starts a
		;   delayed penalty call
	lda.w sfhormode		; not in horizontal mode
	beq .go
	jmp.w .rtl
.go:
	lda.w #PenBuf
	sta.b a0
.next:
	lda.b (a0)
	inc.b a0
	inc.b a0
	tay
	bne .notcalled
	jmp.w .rtl
.notcalled:
	lda.w gmode		; already called: mark it
	bit.w #gmpen
	bne .iscalled
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList		; a1 = PenaltyList entry; minutes?
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	beq .callit
	lda.w puckc		; no carrier, or the guilty team has the puck... else delayed call
	bmi .dc
	sec
	sbc.w #$0006
	sta.b d0
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pl
	ora.w #$FF00
.pl:
	sec
	sbc.w #$0006
	eor.b d0
	bmi .dc
.callit:
	jsl.l Stop4Pen
.iscalled:		;mark it called (bit 7 of the player byte)
	dec.b a0
	lda.b (a0)
	tay
	ora.w #$0080
	sta.b (a0)
	inc.b a0
	tya
	bit.w #$0080
	bne .next
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList		; delay byte (+1) * 32
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.w #$0001
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	sec
	sbc.w Pencntdwn
	beq .nx
	bmi .neg
	bvc .longer
.nx:
	jmp.w .next
.neg:
	bvc .nx
.longer:		;Pencntdwn = delay*32 if longer
	lda.b d1
	sta.w Pencntdwn
	jmp.w .next
.rtl:
	rtl
.dc:		;delayed call: PenDelay ref once
	lda.w #gmpendel		; first delayed call: SetPA PenDelay
	tsb.w gmode
	beq .dc2
	jmp.w .next
.dc2:
	lda.w #PenDelay
	sta.b d0
	jsl.l SetPA
	jmp.w .next
