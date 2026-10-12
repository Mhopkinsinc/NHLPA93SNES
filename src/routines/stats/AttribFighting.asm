AttribFighting:		;Roster column: fighting
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
	jsl.l mulu		; mulres = mula*mulb
	lda.b d1
	sta.b mula
	jsl.l divu
	sta.b d0
AttribPrintPct:		;print d0 4 wide plus padding
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWidth
	jsl.l print
	jsl.l printz
	dw $0004		; printz inline string: length (counts itself), then control bytes / text
	db "  "
	rtl
