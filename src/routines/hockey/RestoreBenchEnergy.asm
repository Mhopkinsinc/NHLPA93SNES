RestoreBenchEnergy:		;called once per second. Restore energy for players on the bench
		;   SNES: once a second with line changes on, players on the bench (TMPDBENCH) regain 10 energy up to $1000, both teams
	lda.w OptLine
	bne .x
	stz.b a2		; home team, then the away team
	jsl.l .team
	lda.w #$0002
	sta.b a2
.team:
	lda.w #$0032
	sta.b d0
.b0:
	lda.b a2
	beq .away
	lda.w #$0034
.away:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y		; on the bench?
	cmp.w #TMPDBENCH
	bne .next
	lda.w tmpde,y
	clc
	adc.w #10
	sta.w tmpde,y
	sec
	sbc.w #$1000
	bmi .neg
	bvc .max
	bra .next
.neg:
	bvc .next
.max:
	lda.w #$1000
	sta.w tmpde,y
.next:
	dec.b d0
	dec.b d0
	bpl .b0
.x:
	rtl
