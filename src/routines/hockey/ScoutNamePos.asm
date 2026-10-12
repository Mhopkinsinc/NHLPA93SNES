ScoutNamePos:		;SNES: print position of a showcased player name: x 1, y 10; the home team (a2 = 0) at x 20
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$0A
	lda.b a2
	bne .rtl
	lda.w #20
	sta.w printx
.rtl:
	rtl
