VBlank:		;main vblank code for game play (vbint target, set by setupice).
		;   SNES: forced blank, run DMAList (ch7), BG2 scroll from Hscroll/vramrow/Vscroll, OAM dma from Satt; one shot: sets vbint back to vb2
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:		;one DMAList entry: VRAM address, length, source, bank, then start ch7 (word writes to VMDATA)
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #DMA_VRAMWORD
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
.next:		;step back one 7-byte entry; done when below 0
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	lda.w Hscroll
	clc
	adc.w #$00C0		; BG2 h-scroll = Hscroll + 192
	sep #$20
	sta.w BG2HOFS
	xba
	sta.w BG2HOFS
	lda.w Vscroll
	and.b #$07		; fine row
	pha
	rep #$30
	lda.w vramrow
	asl a
	asl a
	asl a		; vramrow*8 | (Vscroll&7)
	sep #$20
	ora.b $01,s
	sta.w BG2VOFS
	xba
	sta.w BG2VOFS
	pla
	rep #$30
	lda.w #DMA_OAM		; DMAP7=$00 (A->B, increment), BBAD7=$04 (OAMDATA)
	sta.w DMAP7
	lda.w #Satt
	sta.w A1T7L
	lda.w #$0220		; $220 bytes: 128 sprites + high table
	sta.w DAS7L
	stz.w OAMADDL
	sep #$20
	lda.b #$00
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #vb2		; one shot: back to vb2 next frame
	sta.b vbint
	jmp.w vb2
