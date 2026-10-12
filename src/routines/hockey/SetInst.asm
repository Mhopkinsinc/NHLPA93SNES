SetInst:		;Start a fight between X and a2 when both are aggressive enough; if X was shoulder checking, an
		;   instigator penalty goes to one of his teammates
	lda.w fightagg,x
	cmp.b d0
	bcc checkfight_rtl
	ldy.b a2		; tmp0 = fightagg of a2 >= 2
	lda.w fightagg,y
	sta.b tmp0
	sec
	sbc.w #$0002
	bmi .neg
	bvc .r2
.ex1:
	jmp.w checkfight_rtl
.neg:
	bvc .ex1
.r2:
	lda.w pnum,y		; d1 = $10 - 2 * a2 checks
	sta.b d1
	lda.w pfteam,y
	beq .tm
	lda.w #$001A
.tm:
	clc
	adc.w pnum,y
	tay
	lda.w pchecks,y
	and.w #$00FF
	bit.w #$0080
	beq .cnt
	ora.w #$FF00
.cnt:
	asl a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.b d1
	ldy.b a2
	sec
	sbc.b tmp0
	beq .set
	bmi .neg1
	bvs .set
.ex2:
	jmp.w checkfight_rtl
.neg1:
	bvs .ex2
.set:
	lda.w #$0001
	sta.w pf2fight,x
	sta.w pf2fight,y
	jmp.w .inst
.inst:		;X in a shoulder check: PenInst for the first teammate on the ice without a penalty
	jsl.l sndqreset		; sound reset
	lda.w SPA,x
	cmp.w #SPAshoulderchkl
	beq .chk
	cmp.w #SPAshoulderchkr
	bne .rtl
.chk:
	stx.b a4
	lda.w #$0005
	sta.b d0
	stz.b a3
	lda.w pfteam,x
	beq .1
	lda.w #$000C
	sta.b a3
.1:
	ldx.b a3
	cpx.b a4
	beq .next
	lda.w position,x
	bmi .next
	beq .next
	lda.w pflags,x
	bit.w #pf2pen|pf2unav
	bne .next
	lda.w #PenInst
	sta.b d0
	jsl.l AddPenalty2
	ldx.b a4
	stx.b a3
.rtl:
	rtl
.next:
	inc.b a3
	inc.b a3
	dec.b d0
	bpl .1
	ldx.b a4
	stx.b a3
	rtl
