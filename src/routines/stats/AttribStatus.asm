AttribStatus:		;Roster column: where the player is (ice, bench, injured) or his penalty time
	asl.b d0
	lda.b a2
	beq .team
	lda.w #$0034
.team:
	adc.b d0
	tay
	lda.w tmpdst,y		; tmpdst: negative = not of the status
	sta.b d0
	bpl .pen
	eor.w #$FFFF
	sta.b d0
	cmp.w #$0003
	bcc .st
	lda.w #$0001
	sta.b d0
	bra .st
.inj:
	lda.w #$0003
	sta.b d0
.st:
	lda.w #StatusTextTbl>>16
	sta.b a1+2
	lda.w #StatusTextTbl
	sta.b a1
	jml.l PrintStringFromList		; d0 = index, [a1] = list
.pen:
	lda.b d0
	bit.w #TMPDINJ
	bne .inj
	dec.w printx
	lda.b d0
	sta.b d1
	and.w #$0FFF
	sta.b d0
	jsl.l PushTime		; d0 = time
	jsl.l print
	lda.w #$0004
	sta.b d0
	lda.w #$4000
	trb.b d1
	beq .t
	lda.w #$0005
	sta.b d0
.t:
	lda.w #StatusTextTbl>>16
	sta.b a1+2
	lda.w #StatusTextTbl
	sta.b a1
	jml.l PrintStringFromList		; d0 = index, [a1] = list
