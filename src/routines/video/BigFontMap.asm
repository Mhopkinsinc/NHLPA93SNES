BigFontMap:		;bigfont.map: big font tiles of each character: 76 top-row words, then the 76 bottom-row words (+$98); printbig uses BigFontIndex
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406,$0407
	dw $0408,$0409,$0408,$0409,$040A,$040B,$040C,$040D
	dw $040E,$040F,$0410,$0411,$0412,$0413,$0414,$0415
	dw $0416,$0417,$0418,$0419,$041A,$041B,$041C,$041D
	dw $041E,$041B,$041F,$0420,$0421,$0422,$0423,$0424
	dw $0425,$0424,$0426,$0427,$0428,$0429,$042A,$042B
	dw $042C,$042D,$042E,$042F,$0430,$0431,$0432,$0433
	dw $0434,$0435,$0436,$0437,$0438,$0439,$043A,$043B
	dw $043C,$043D,$043E,$043F,$0440,$0441,$0442,$0443
	dw $0414,$0444,$0445,$0446,$0447,$0448,$0449,$044A
	dw $044B,$044C,$044D,$044E,$044F,$0450,$0451,$0452
	dw $0453,$0454,$0455,$0456,$0457,$0458,$0459,$045A
	dw $045B,$0458,$045C,$045D,$045E,$045F,$0460,$0461
	dw $0462,$0463,$0464,$0465,$0466,$0467,$0468,$0469
	dw $046A,$046B,$046C,$046D,$0459,$046E,$046F,$0470
	dw $0471,$0472,$0473,$0474,$0475,$0476,$0477,$0478
	dw $0479,$047A,$047B,$047C,$047D,$047E,$047F,$0480
	dw $0481,$0482,$0483,$0484,$0485,$0486,$0487,$0488
	dw $0489,$048A,$048B,$048C,$0442,$048D,$048E,$048F
unusedEnergyBar:		;SNES: no caller found: builds a 4-character energy bar of d0 (8 levels per character, tile base d1) in mesarea and moves printx back 11; does not print it
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	lda.w #$2000
	sta.w printa
	lda.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0020
	bcc .cap
	lda.w #$001F
.cap:
	sta.b d0
	ldy.w #$0002
	lda.w #$0006
	sta.w mesarea
	lda.w #$0003
	sta.b d3
.char:
	lda.w #$FFFF
	sta.b d2
	lda.b d0
	bmi .level
	sta.b d2
	cmp.w #$0008
	bcc .level
	lda.w #$0007
	sta.b d2
.level:
	lda.b d2
	sec
	adc.b d1
	and.w #$00FF
	bne .tile
	lda.w #$0020
.tile:
	sta.w mesarea,y
	iny
	lda.b d0
	sec
	sbc.w #$0008
	sta.b d0
	dec.b d3
	bpl .char
	lda.b d1
	beq .nod1
	lda.w #$0C00
	tsb.w printa
.nod1:
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w printx
	sec
	sbc.w #$000B
	sta.w printx
	lda.w #$4000
	tsb.w printa
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	sep #$20
	lda.w mesarea+5
	ldy.w mesarea+2
	sta.w mesarea+2
	sty.w mesarea+5
	rep #$30
	lda.w mesarea+3
	xba
	sta.w mesarea+3
	lda.w #$4000
	trb.w printa
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a1,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
