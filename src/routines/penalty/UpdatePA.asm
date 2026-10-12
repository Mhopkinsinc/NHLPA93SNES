UpdatePA:		;Animate the referee, and reprint the penalty message line when its time runs out
	lda.w RefCnt		; RefCnt negative: idle
	bmi .rtl
	sec
	sbc.b d7
	sta.w RefCnt
	bpl .1
	jsl.l SetPA2
.1:
	lda.w penmsgtimer
	sec
	sbc.b d7
	sta.w penmsgtimer
	bpl .rtl
	lda.w #$7FFF
	sta.w penmsgtimer
	jsl.l ClearPenaltyMessage		; then the player name centered at row $B
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	jsl.l GetPlayerName		; a1 = name
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jmp.w print
.rtl:
	rtl
