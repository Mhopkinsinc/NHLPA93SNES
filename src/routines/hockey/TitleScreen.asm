TitleScreen:		;bring up title screen and credits
		;   SNES: Title1Map backdrop, StartSong6, then the Credits scroll up 6 rows at a time; Start leaves
	lda.w #$0198		; the blank tile and the small font above the title tiles
	sta.w blankchar
	inc a
	sta.w smallfontchars
	stz.w charofs
	stz.w charofs2
	jsl.l forceblack
	jsl.l InitPPU		; PPU registers off/clear
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	lda.b #$03
	sta.w OBSEL
	lda.b #BGMODE_1
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$04
	sta.w BG2SC
	lda.b #$11
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2
	sta.w TM
	rep #$30
	lda.w blankchar
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #Title1Map		; Title1Map (packed): map $700, palette $700, tiles $800
	sta.b tmp0
	lda.w #Title1Map>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.l TestList		; first map word fills backmap
	ldx.w #$07FE
.fill:
	sta.l backmap,x
	dex
	dex
	bpl .fill
	ldx.w #$06FE
.map:
	lda.l TestList,x
	sta.l backmap,x
	dex
	dex
	bpl .map
	ldx.w #$057E		; rows 0-21: priority
.prio:
	lda.l backmap,x
	ora.w #$2000
	sta.l backmap,x
	dex
	dex
	bpl .prio
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.tiles:
	lda.l TestList+$800,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$3300
	bne .tiles
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.pal:
	lda.l TestList+$700,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .pal
	rep #$30
	ldx.w #$0010
.zero:
	stz.w VMDATAL
	dex
	bne .zero
	lda.w #SmallFontTiles		; remapped with PixelRemap8F
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
	jsl.l StartSong6
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $CF,$00,$1C
	stz.b d0
	lda.w #Credits		; a0 = the credits text
	sta.b a0
	lda.w #Credits>>16
	sta.b a0+2
	lda.w #textmap		; DMAList: textmap $1000 bytes to vram 0 each frame
	sta.w DMAList
	lda.w #textmap>>16
	sta.w DMAList+dmabank
	lda.w #$1000
	sta.w DMAList+dmalen
	stz.w DMAList+dmavram
	lda.w #dmasize
	sta.b DMAListend
	lda.w #VBlank_VScroll		; title vblank handler
	sta.b vbint
	lda.w #$0001
	sta.b fadein
.wait1:
	cmp.b vbint
	beq .wait1
.top2:		;next credits page
	ldy.w #$0002
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$00FF		; end of the credits
	bne .top4
	jmp.w .exit
.top4:		;blank the 6 rows below the screen
	lda.w printy
	pha
	ldx.w #$0006
.erase:
	stz.w printx
	txa
	clc
	adc.b $01,s
	and.w #$001F
	sta.w printy
	lda.w #CreditsBlank
	sta.b a1
	lda.w #CreditsBlank>>16
	sta.b a1+2
	jsl.l print
	dex
	bpl .erase
	lda.b $01,s
	sta.w printy
.top4x:		;print the page lines centred
	lda.w #34		; printx = (34 - length) / 2
	sec
	sbc.b [a0]
	lsr a
	sta.w printx
	lda.b a0
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	jsl.l print
	lda.w printy
	inc a
	and.w #$001F
	sta.w printy
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	ldy.w #$0002
	lda.b [a0],y
	and.w #$00FF
	sta.b d3
	cmp.w #$00FE		; $FE: last page, $FF: end
	beq .scroll
	cmp.w #$00FF
	bne .top4x
.scroll:
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	pla
	clc
	adc.w #6
	and.w #$001F
	sta.w printy
	sec		; scroll target
	sbc.w #28
	and.w #$001F
	asl a
	asl a
	asl a
	sta.b d1
	jsl.l QueueTextDMA		; queue the changed textmap words
.top5:		;scroll 6*8 lines
	lda.b d0
	inc a
	and.w #$00FF
	sta.b d0
	lda.w #VBlank_VScroll
	sta.b vbint
.wait:
	cmp.b vbint
	beq .wait
	jsl.l ReadPads
	lda.b d3
	cmp.w #$00FE		; $FE: no Start (copyright page)
	bne .nopause
	stz.w padnew1
	stz.w padnew1+2
.nopause:
	lda.w padnew1
	ora.w padnew1+2
	bit.w #JOYSTART
	bne .exit
	lda.b d0
	cmp.b d1
	bne .top5
	lda.b vcount		; 90 frames
	clc
	adc.w #90
	sta.b d2
	lda.b d3
	cmp.w #$00FE
	bne .top6s
	lda.b vcount		; 180 frames for the copyright page
	clc
	adc.w #180
	sta.b d2
.top6:
	jsl.l ReadPads
	lda.b d3
	cmp.w #$00FE
	bne .top6s
	stz.w padnew1
	stz.w padnew1+2
.top6s:
	lda.w padnew1
	ora.w padnew1+2
	bit.w #JOYSTART
	bne .exit
	lda.b vcount
	cmp.b d2
	bne .top6
	jmp.w .top2
.exit:		;wait for the default vblank handler, return
	lda.b vbint
	cmp.w #vb2		; the default vblank handler
	bne .exit
	rtl
