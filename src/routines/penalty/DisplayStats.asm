DisplayStats:		;the STATS page of the pause menu: Shots, Power Play, Penalties, Body Checks, AttackZone for both teams
	jsl.l printbigz
	dw $000A		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02,"STATS"
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$07
	lda.w #$0016
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.w smallfontchars
	sta.b d2
	jsl.l eraser
	jsl.l printz
	dw $000B		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0D,$06,"      "
	jsl.l printz
	dw $000A		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0D,$07,"Shots"
	jsl.l printz
	dw $000F		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$08,"Power Play"
	jsl.l printz
	dw $000E		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$09,"Penalties"
	jsl.l printz
	dw $0010		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$0A,"Body Checks"
	jsl.l printz
	dw $000F		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$0B,"AttackZone"
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$1A,$07
	stz.b a2		; home stats at x 26, then the away stats at x 9
	jsl.l .ss
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$09,$07
	inc.b a2
	inc.b a2
.ss:		;the .sslist stats of team a2 at printx
	lda.w #DisplayStats_sslist
	sta.b a0
	lda.w #DisplayStats_sslist>>16
	sta.b a0+2
.sstop:
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	bmi .atz
	ldy.w printx
	phy
	clc
	adc.b a2
	tay
	lda.w $0000,y		; stat word of team a2 (absolute address +$0000,y)
	sta.b d0
	jsl.l PushNumber
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	bmi .nextss
	sta.b d1
	lda.w #mesarea
	sta.b a3
	lda.w #$0000
	sta.b a3+2
	lda.w #$0002
	sta.b [a3]
	jsl.l appstring
	jsl.l appendz
	dw $0003		; printz inline string: length (counts itself), then control bytes / text
	db "/"
	lda.b a2
	clc
	adc.b d1
	tay
	lda.w $0000,y
	sta.b d0
	jsl.l PushNumber
	jsl.l appstring
	lda.b a3
	sta.b a1
	lda.b a3+2
	sta.b a1+2
.nextss:
	lda.b [a1]
	inc a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w printx
	sta.w printx
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	bra .sstop
.atz:		;tmATOP as a time
	ldy.b a2
	lda.w tmATOP,y
	sta.b d0
	jsl.l PushTime		; d0 = time
	lda.b [a1]
	inc a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w printx
	sta.w printx
	jml.l print
