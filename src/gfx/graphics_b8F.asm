; gfx/graphics_b8F: 93G graphics93: packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8F8000
BigFontMap:		;93G bigfont.map: big font tiles of each character: 76 top-row words, then the 76 bottom-row words (+$98); printbig uses BigFontIndex
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
unusedEnergyBar:		;SNES: no caller found: a 4-character energy bar of d0 (8 levels per character) printed at printx-11, palette by d1
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .loop
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
	bcc .lt
	lda.w #$001F
.lt:
	sta.b d0
	ldy.w #$0002
	lda.w #$0006
	sta.w mesarea
	lda.w #$0003
	sta.b d3
.loop2:
	lda.w #$FFFF
	sta.b d2
	lda.b d0
	bmi .d0neg
	sta.b d2
	cmp.w #$0008
	bcc .d0neg
	lda.w #$0007
	sta.b d2
.d0neg:
	lda.b d2
	sec
	adc.b d1
	and.w #$00FF
	bne .nonzero
	lda.w #$0020
.nonzero:
	sta.w mesarea,y
	iny
	lda.b d0
	sec
	sbc.w #$0008
	sta.b d0
	dec.b d3
	bpl .loop2
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
.loop3:
	pla
	sta.b a1,x
	dex
	dex
	bpl .loop3
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl

org $8F824D
EASNLogoMap:		;93G easn.map (small): the 7 x 2 EASN logo tile words for EASNLogo (unusedchars + n)
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406
	dw $0407,$0408,$0409,$040A,$040B,$040C,$040D
BigFontIndex:		;SNES: big font index of each character $20-$5A (*2 into BigFontMap); negative = one column wide
	db $00,$B7,$00,$00,$00,$00,$00,$BA,$00,$00,$00,$00,$00,$00,$C2,$00
	db $33,$CB,$36,$38,$3A,$3C,$3E,$40,$42,$44,$BB,$00,$00,$00,$00,$48
	db $4A,$00,$02,$04,$06,$08,$0A,$0C,$0E,$F0,$11,$13,$15,$17,$19,$1B
	db $1D,$1F,$21,$23,$25,$27,$29,$2B,$2D,$2F,$31

org $8FE154
PixelRemap8F:		;SNES: 4bpp pixel value remap for RemapTiles: colour 1 stays, the rest 0
	db $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

org $8FE67D
FrameSetTable:		;SNES: long pointers to the 15 sprite frame sets (addframe), then a 0 entry
	dd SpriteSet0
	dd SpriteSet1
	dd SpriteSet2
	dd SpriteSet3
	dd SpriteSet4
	dd SpriteSet5
	dd SpriteSet6
	dd SpriteSet7
	dd SpriteSet8
	dd SpriteSet9
	dd SpriteSet10
	dd SpriteSet11
	dd SpriteSet12
	dd SpriteSet13
	dd SpriteSet14
	dd 0		; end

org $8FF4B8
PixelRemapFramer:		;SNES: RemapTiles table for the Framer tiles (setoptions)
	db $00,$01,$0A,$03,$04,$05,$06,$02,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
PixelRemapFont:		;SNES: RemapTiles table for the small font (setoptions)
	db $00,$0F,$00,$00,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
