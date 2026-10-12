DecompressBytecode:		;Unpack a compressed stream to unpackbuf. Each control byte picks a literal copy, a run of zeros or of one byte,
		;   or a copy from earlier output
	stz.b tmp1+1		; output pointer = $7F0000
	lda.w #TestList>>16
	sta.b tmp1+3
.next:
	lda.b [tmp0]
	inc.b tmp0
	bit.w #$00E0
	bne .clear
	and.w #$001F
	tax
.litloop:
	lda.b [tmp0]
	inc.b tmp0
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .litloop
	bra .next
.clear:
	tay
	and.w #$00F0
	cmp.w #$0020
	bne .fillop
	tya
	and.w #$000F
	tax
	lda.w #$0000
.clrloop:
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .clrloop
	bra .next
.fillop:
	cmp.w #$0030
	bne .backshort
	tya
	and.w #$000F
	tax
	inx
	inx
	lda.b [tmp0]
	inc.b tmp0
.fillloop:
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .fillloop
	bra .next
.backshort:		;$40-$7F: distance bits 3-5 + 1, length bits 0-2 + 2
	and.w #$00C0
	cmp.w #$0040
	bne .backmed
	tya
	lsr a
	lsr a
	lsr a
	and.w #$0007
	inc a
	sta.b tmp2+2
	tya
	and.w #$0007
	inc a
	inc a
	tay
.backrun:		;copy Y bytes from output - distance, going up
	lda.b tmp1+1
	sec
	sbc.b tmp2+2
	tax
.backloop:
	lda.l TestList,x
	inx
	sta.b [tmp1+1]
	inc.b tmp1+1
	dey
	bne .backloop
	bra .next
.backmed:		;$8x: length n+3, distance = next byte
	tya
	and.w #$00F0
	cmp.w #$0080
	bne .backlong
	tya
	and.w #$000F
	inc a
	inc a
	inc a
	tay
	lda.b [tmp0]
	inc.b tmp0
	and.w #$00FF
	sta.b tmp2+2
	bra .backrun
.backlong:		;$9x: distance 7 bits, length 5 bits
	cmp.w #$0090
	bne .backext1
	lda.b [tmp0]
	inc.b tmp0
	and.w #$007F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	xba
	and.w #$001F
	inc a
	inc a
	inc a
	tay
	bra .backrun
.backext1:		;$Ax: distance 6 bits, length 6 bits
	cmp.w #$00A0
	bne .backext2
	lda.b [tmp0]
	inc.b tmp0
	and.w #$003F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	asl a
	xba
	and.w #$003F
	inc a
	inc a
	inc a
	tay
	bra .backrun
.backext2:		;$Bx: distance 5 bits, length 7 bits
	cmp.w #$00B0
	bne .revshort
	lda.b [tmp0]
	inc.b tmp0
	and.w #$001F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	asl a
	asl a
	xba
	and.w #$007F
	inc a
	inc a
	inc a
	tay
	jmp.w .backrun
.revshort:		;$C0-$DF: going down
	and.w #$00E0
	cmp.w #$00C0
	bne .revmed
	tya
	lsr a
	lsr a
	and.w #$0007
	inc a
	sta.b tmp2+2
	tya
	and.w #$0003
	inc a
	inc a
	tay
.revrun:		;copy Y bytes going down from output - distance
	lda.b tmp1+1
	sec
	sbc.b tmp2+2
	tax
.revloop:
	lda.l TestList,x
	dex
	sta.b [tmp1+1]
	inc.b tmp1+1
	dey
	bne .revloop
	jmp.w .next
.revmed:		;$Ex: length n+3, distance = next byte (0 = end)
	tya
	and.w #$00F0
	cmp.w #$00E0
	bne .revlong
	tya
	and.w #$000F
	inc a
	inc a
	inc a
	tay
	lda.b [tmp0]
	inc.b tmp0
	and.w #$00FF
	beq .end
	sta.b tmp2+2
	bra .revrun
.revlong:		;$Fx: going down, distance 7 bits, length 5 bits
	lda.b [tmp0]
	inc.b tmp0
	and.w #$007F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	xba
	and.w #$001F
	inc a
	inc a
	inc a
	tay
	bra .revrun
.end:
	rtl
