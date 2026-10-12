PlayoffScreen:		;bring up playoff screen if in playoff mode. Called from GameOver and Opening2.
		;   SNES: set the font tile bases; in playoff mode draw the tree (PlayoffTreeSetup by gamelevel: team
		;   blocks, arrows, series scores) with the NHLPA logo, PWprint; scroll with left/right until Start
	lda.w #6		; tile bases: small font 6, big font +100, score/team blocks +100, NHLPA logo +405
	sta.w smallfontchars
	clc
	adc.w #100
	sta.w BigFontChars
	adc.w #100
	sta.w scorechars
	adc.w #405
	sta.w logochars
	stz.w charofs
	stz.w charofs2
	lda.w OptPlayMode		; not in playoff mode: done
	bne .po
	jmp.w .rtl
.po:
	jsl.l forceblack
	sep #$20
	lda.b #BGMODE_1
	sta.w BGMODE
	lda.b #$01
	sta.w BG1SC
	lda.b #$01
	sta.w BG12NBA
	lda.b #TM_BG1
	sta.w TM
	rep #$30
	lda.w #$1000
	sta.w VMADDL
	lda.w #PlayoffTiles		; PlayoffTiles: 128 colours, then 6 tiles
	sta.b tmp0
	lda.w #PlayoffTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.treetiles:
	lda.l TestList+$100,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$00C0
	bne .treetiles
	ldx.w #$0000
.treepal:
	lda.l TestList,x
	sta.l palbuffer,x
	inx
	inx
	cpx.w #$0100
	bne .treepal
	lda.w #SmallFontTiles		; SmallFontTiles twice: remapped with PixelRemap8F, then with PixelRemap83
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #unpackbuf&$FFFF
	sta.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap8F
	sta.b a1
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles		; remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #unpackbuf&$FFFF
	sta.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap83
	sta.b a1
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles		; remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.blocktiles:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .blocktiles
	lda.w #$0000		; clear textmap and backmap (128 x 32 map)
	ldx.w #$1FFE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #potree		; a1 = potree
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #PlayoffTreeSetup		; a0 = PlayoffTreeSetup level gamelevel
	sta.b a0
	lda.w #PlayoffTreeSetup>>16
	sta.b a0+2
	lda.w gamelevel
	asl a
	tay
	lda.b [a0],y
	adc.b a0
	sta.b a0
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d4
.team:		;DrawTeamBlocks: team block of tree slot d4 at x, y
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w printx
	stz.w printa
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w printy
	lda.b [a1]		; team of the slot
	inc.b a1
	and.w #$00FF
	sta.b mula
	ldy.w potreeteam		; the user's team: palette 7
	eor.w potree,y
	and.w #$00FF
	bne .other
	lda.w #$1C00
	sta.w printa
.other:
	lda.w #36		; 36 bytes per TeamBlocksMap entry
	sta.b mulb
	jsl.l mulu16		; 16-bit multiply
	tay
	lda.w #TeamBlocksMap
	sta.b a2
	lda.w #TeamBlocksMap>>16
	sta.b a2+2
	lda.w printy		; textmap offset (y * 128 + x) * 2
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	lda.w #9
	sta.b tmp0
	sta.b tmp1
.row1:
	lda.b [a2],y
	clc
	adc.w scorechars
	adc.w charofs
	ora.w printa
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp0
	bne .row1
.row2:
	lda.b [a2],y
	clc
	adc.w scorechars
	adc.w charofs
	ora.w printa
	sta.l textmap+$EE,x
	iny
	iny
	inx
	inx
	dec.b tmp1
	bne .row2
	dec.b d4
	beq .arrow
	jmp.w .team
.arrow:		;DrawTreeArrow: arrow column (23 rows of PlayoffBracketMap) at x; $FF ends
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	cmp.w #$00FF
	beq .scores
	asl a		; column n of PlayoffBracketMap (23 rows of 12 words)
	adc.w #PlayoffBracketMap
	sta.b tmp0
	lda.w #PlayoffBracketMap>>16
	sta.b tmp1
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	tax
	ldy.w #23
.arrowrow:
	lda.b [tmp0]
	sta.l textmap+$200,x
	lda.b tmp0
	clc
	adc.w #24
	sta.b tmp0
	txa
	adc.w #$0100
	tax
	dey
	bne .arrowrow
	bra .arrow
.rtl:
	rtl
.scores:		;scroll limits, then the series scores (not for single games)
	lda.b [a0]		; Hscroll limits (x8)
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d2+2
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d0+2
	stz.b d3+2
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $EF,$00,$00
	lda.b bosgames		; single games: no scores
	cmp.w #7
	beq .logo
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d4
	beq .logo
	stz.b a2
.score:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w printx
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	sta.w printy
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #5		; mesarea "<top team wins>-<bottom team wins>"
	sta.w mesarea
	ldx.b a2
	lda.w gspotwins,x
	adc.w #'0'
	sta.w mesarea+2
	lda.w #'-'
	sta.w mesarea+3
	lda.w gspobwins,x
	adc.w #'0'
	sta.w mesarea+4
	jsl.l print
	inc.b a2
	inc.b a2
	dec.b d4
	bne .score
.logo:		;the NHLPA logo: palette row 2, tiles at logochars, map at x 60, y 2
	lda.w #NHLPALogo
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$001E		; logo palette to palette row 2
.logopal:
	lda.l TestList+$A0,x
	sta.l palbuffer+$C0,x
	dex
	dex
	bpl .logopal
	lda.w logochars		; logo tiles to vram logochars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.logotiles:
	lda.l TestList+$1A0,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06A0
	bne .logotiles
	stz.b tmp1
.logorow:
	stz.b tmp0
.logocol:
	lda.b tmp1
	sta.b mula
	lda.w #8
	sta.b mulb
	jsl.l mulu16		; 16-bit multiply
	adc.b tmp0
	asl a
	tax
	lda.l TestList,x
	adc.w logochars
	ora.w #$1800		; palette 6
	pha
	lda.b tmp1
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.b tmp0
	asl a
	tax
	pla
	sta.l textmap+$A78,x
	inc.b tmp0
	lda.b tmp0
	cmp.w #8
	bne .logocol
	inc.b tmp1
	lda.b tmp1
	cmp.w #10
	bne .logorow
	jsl.l ClearSprites		; clear the sprite table
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $EF,"8d"
	jsl.l PWprint
	lda.w #$0180		; start in the middle
	sta.w Hscroll
	stz.w printx
	stz.w printy
	lda.w #32
	sta.b d0
	lda.w #4
	sta.b d1
	lda.w BigFontChars		; blank the top and bottom rows with big font tile 0
	ora.w #$1000
	sta.b d2
	jsl.l eraser		; d0 x d1, tile d2
	stz.w printx
	lda.w #104
	sta.w printy
	lda.w #32
	sta.b d0
	lda.w #24
	sta.b d1
	lda.w BigFontChars
	ora.w #$1000
	sta.b d2
	jsl.l eraser		; d0 x d1, tile d2
	jsl.l StartSong9		; keep the music going
.scroll:		;clamp Hscroll, queue the 128-column map window, wait a frame
	lda.w Hscroll
	cmp.b d2+2
	bcs .min
	lda.b d2+2
.min:
	cmp.b d0+2
	bcc .max
	lda.b d0+2
.max:
	sta.w Hscroll
	lsr a
	lsr a
	lsr a
	asl a
	adc.w #textmap		; source column in textmap
	sta.b tmp0
	stz.b tmp1
	ldy.w #$0000
.dma:
	lda.b tmp1
	sta.w DMAList+dmavram,y
	clc
	adc.w #$0020
	sta.b tmp1
	adc.w #$03E0
	sta.w DMAList+dmasize+dmavram,y
	lda.b tmp0
	sta.w DMAList,y
	adc.w #$0040
	sta.w DMAList+dmasize+dmasrc,y
	adc.w #$00C0
	sta.b tmp0
	lda.w #textmap>>16
	sta.w DMAList+dmabank,y
	sta.w DMAList+dmasize+dmabank,y
	lda.w #$0040
	sta.w DMAList+dmalen,y
	lda.w #$000A
	sta.w DMAList+dmasize+dmalen,y
	tya
	adc.w #2*dmasize
	tay
	cpy.w #32*2*dmasize		; 32 rows: 2 dma entries each
	bne .dma
	sty.b DMAListend
	lda.w #VBlank_Cram		; playoff vblank handler
	sta.b vbint
.wait:
	cmp.b vbint
	beq .wait
.pad:
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	cmp.w #JOYSTART
	bne .frame
	jmp.w .rtl
.frame:		;colour 1 of palette 7 blends between the .blink colours (30 frame cycle)
	lda.b vcount
	cmp.b d7
	beq .pad
	sta.b d7
	sta.b mulb		; vcount mod 30, then the half
	lda.w #30
	sta.b mula
	jsl.l divu16
	lda.b mulres+2
	sta.b tmp0
	lda.w #2
	sta.b mula
	jsl.l divu16
	lda.b mulres+2
	asl a
	tax
	lda.l .blink,x
	xba
	and.w #$00FF
	lsr a
	lsr a
	sta.b tmp1
	lda.l .blink+2,x
	xba
	and.w #$00FF
	lsr a
	lsr a
	sec
	sbc.b tmp1
	sta.b mula
	lda.b tmp0
	sta.b mulb
	jsl.l muls32
	lda.w #30
	sta.b mula
	jsl.l divs
	adc.b tmp1
	and.w #$001F
	xba
	and.w #$FF00
	asl a
	asl a
	sta.b tmp2
	lda.l .blink,x
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$001F
	sta.b tmp1
	lda.l .blink+2,x
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$001F
	sec
	sbc.b tmp1
	sta.b mula
	lda.b tmp0
	sta.b mulb
	jsl.l muls32
	lda.w #30
	sta.b mula
	jsl.l divs
	adc.b tmp1
	and.w #$001F
	asl a
	asl a
	asl a
	asl a
	asl a
	tsb.b tmp2
	lda.l .blink,x
	and.w #$001F
	sta.b tmp1
	lda.l .blink+2,x
	and.w #$001F
	sec
	sbc.b tmp1
	sta.b mula
	lda.b tmp0
	sta.b mulb
	jsl.l muls32
	lda.w #30
	sta.b mula
	jsl.l divs
	adc.b tmp1
	and.w #$001F
	ora.b tmp2
	sta.l palbuffer+$E2
	lda.w joypad1		; held: left/right scroll
	ora.w joypad2
	cmp.w #JOYLEFT
	beq .left
	cmp.w #JOYRIGHT
	beq .right
.move:
	lda.w Hscroll
	clc
	adc.b d3+2
	sta.w Hscroll
	cmp.w #$0058
	beq .stop
	cmp.w #$00B0
	beq .stop
	cmp.w #$0108
	beq .stop
	cmp.w #$0180
	beq .stop
	cmp.w #$01F8
	beq .stop
	cmp.w #$0250
	beq .stop
	cmp.w #$02A8
	bne .again
.stop:		;stop at the round columns
	stz.b d3+2
.again:
	jmp.w .scroll
.blink:		;BGR555 colours the user's team block blinks between (white, blue, white)
	dw $7FFF,$7E10,$7FFF
.left:
	lda.w #$FFFF
	sta.b d3+2
	jmp.w .move
.right:
	lda.w #$0001
	sta.b d3+2
	jmp.w .move
