ScoutNamePos:		;Where the name of a player shown on the scouting report is printed
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$0A
	lda.b a2
	bne .rtl
	lda.w #20
	sta.w printx
.rtl:
	rtl
