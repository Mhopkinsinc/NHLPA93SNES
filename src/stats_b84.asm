; Roster attribute columns.
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84FC44
GetNameandAttrib:		;print player d0's name, then at x $1E the column picked by
		;   SNES: print player d0 (number and name), then at x 26 the column d4 (attribjmp); columns above 2 average the rating nibbles masked by
		;   d4 high word
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	jsl.l PlayerNumName
	jsl.l print
	lda.w #$001A
	sta.w printx
	lda.b d4		; status, energy, handed: no ratings
	cmp.w #$0003
	bcs .rate
	jmp.w .jump
.rate:
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmdata,y
	sta.b a0
	clc
	ldy.w #Playerdata
	adc.b [a0],y
	sta.b a0
.pl:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
	dec.b d0
	bpl .pl
	stz.b d0
	stz.b d1
	lda.w #$000F
	sta.b d2
	lda.b d4
	ldy.b d4+2
	sta.b d4+2
	sty.b d4
.one:
	lda.b d4
	sta.b tmp0
	lda.b d4+2
	sta.b tmp1
	lda.b d2
	sta.b tmp2
.sh:
	dec.b tmp2
	bmi .bit
	lsr.b tmp1
	ror.b tmp0
	bra .sh
.bit:
	lsr.b tmp0
	bcc .three
	lda.b d2
	lsr a
	eor.w #$FFFF
	inc a
	dec a
	clc
	adc.b a0
	sta.b tmp0
	lda.b a0+2
	sta.b tmp1
	lda.b [tmp0]
	sta.b d3
	lda.b d2
	lsr a
	bcc .lo
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
.lo:
	lda.b d3
	and.w #$000F
	sta.b d3
	clc
	adc.b d0
	sta.b d0
	lda.b d1
	clc
	adc.w #$000F
	sta.b d1
.three:
	dec.b d2
	bpl .one
	lda.b d4
	ldy.b d4+2
	sta.b d4+2
	sty.b d4
.jump:		;go to attribjmp[d4] through jmlvector
	lda.w #attribjmp
	sta.b a0
	lda.w #attribjmp>>16
	sta.b a0+2
	ldy.b d4
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
attribjmp:		;GetNameandAttrib column handlers, offsets from attribjmp
	dw AttribStatus-attribjmp,AttribEnergy-attribjmp,AttribHanded-attribjmp,AttribWeight-attribjmp,AttribFighting-attribjmp,AttribRating-attribjmp
AttribStatus:		;Player d0's word at $66(a2):
		;   SNES: tmpdst of player d0: Ice/Bench/Injury, or the penalty time (injured: Inj G, $4000: C)
	asl.b d0
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
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
	jml.l PrintStringFromList		; bank $8F (d0 = index, [a1] = list)
.pen:
	lda.b d0
	bit.w #TMPDINJ
	bne .inj
	dec.w printx
	lda.b d0
	sta.b d1
	and.w #$0FFF
	sta.b d0
	jsl.l PushTime		; bank $8F (d0 = time)
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
	jml.l PrintStringFromList		; bank $8F (d0 = index, [a1] = list)
StatusTextTbl:		;AttribStatus strings
	%String("Ice   ")
	%String("Bench ")
	%String("Inj P ")
	%String("Inj G ")
	%String("  ")
	%String(" C")
AttribEnergy:		;$32(a2) word / 40, max 100
		;   SNES: tmpde of player d0 / 40, max 100
	asl.b d0
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	adc.b d0
	tay
	lda.w tmpde,y		; divu16 by 40
	sta.b mulb
	lda.w #$0028
	sta.b mula
	jsl.l divu16
	cmp.w #$0065
	bcc .pr
	lda.w #$0064
.pr:
	sta.b d0
	bra AttribPrintPct
AttribFighting:		;Bit 0 of the nibble is
		;   SNES: bit 0 of the nibble is handedness, only bits 1-3 count
	lda.b d0
	and.w #$000E
	sta.b d0
	dec.b d1
AttribRating:		;Sum d0 of d1/15 ratings as a percentage
	lda.w #$0064
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu		; bank $88, mulres = mula*mulb
	lda.b d1
	sta.b mula
	jsl.l divu
	sta.b d0
AttribPrintPct:		;print d0 4 wide plus padding
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWidth		; bank $8F
	jsl.l print
	jsl.l printz
	dw $0004		; printz inline string: length (counts itself), then control bytes / text
	db "  "
	rtl
AttribHanded:		;Bit 0 of the sum
	lda.b d0
	and.w #$0001
	sta.b d0
	lda.w #HandedTextTbl>>16
	sta.b a1+2
	lda.w #HandedTextTbl
	sta.b a1
	jml.l PrintStringFromList		; bank $8F (d0 = index, [a1] = list)
HandedTextTbl:		;AttribHanded strings
	%String("Right ")
	%String("Left  ")
AttribWeight:		;140 + 8 * rating lb
	lda.b d0
	asl a
	asl a
	asl a
	adc.w #140
	sta.b d0
	jsl.l pushnumber		; bank $8F
	jsl.l print
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db "   "
	rtl
unusedFF84:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF
