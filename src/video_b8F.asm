; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8F82A4
showclock:		;put the game clock in the dma list. Called from setvideo; returns unless dfclock is set.
		;   SNES: the game clock m:ss at x 3, y $18 (horizontal rink: x $D, y 4; not when gsp = 4); not in replay
	lda.w sflags
	bit.w #sf2replay
	beq .nosf2replay
	jmp.w .rtl
.nosf2replay:
	lda.w #$0007
	sta.w mesarea
	lda.w #$0020
	sta.w mesarea+2
	lda.w gameclock
	sta.b mulb
	lda.w #600
	sta.b mula
	jsl.l divu16
	beq .notens
	adc.w #$0030
	sta.w mesarea+2
.notens:
	lda.w #60
	sta.b mula
	lda.b mulres+2
	sta.b mulb
	jsl.l divu16
	adc.w #$0030
	sta.w mesarea+3
	lda.w #':'
	sta.w mesarea+4
	lda.w #10
	sta.b mula
	lda.b mulres+2
	sta.b mulb
	jsl.l divu16
	adc.w #$0030
	sta.w mesarea+5
	lda.b mulres+2
	adc.w #$0030
	sta.w mesarea+6
	lda.w #$2000
	sta.w printa
	lda.w #$0003
	sta.w printx
	lda.w #$0018
	sta.w printy
	lda.w sfhormode
	beq .nosfhormode
	lda.w #$000D
	sta.w printx
	lda.w #$0004
	sta.w printy
	lda.w gsp
	cmp.w #$0004
	beq .rtl
.nosfhormode:
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	jml.l print
.rtl:
	rtl

org $8F87C0
KillCrowd:		;silence the crowd noise (psg). Called from Reset, SetupPauseScreen, ...
		;   SNES: crowd volume $88 (silence) to the sound driver
	lda.w #$0088
	pha
	jsl.l sfx8F
	rtl

org $8F8ABC
showzam:		;zamboni. Called from setvideo.
		;   SNES: on the horizontal rink the zamboni sprite ($22D) moves with the time since vcountmark
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne showzam
	sbc.w vcountmark
	sta.b tmp0
	tya
	sbc.w vcountmark+2
	bne .rtl
	lda.w sfhormode
	beq .rtl
	lda.b tmp0
	lsr a
	lsr a
	sta.b sprx
	lda.w #$00C8
	sta.b spry
	lda.w #$022D
	sta.b sprframe
	jsl.l addframe
.rtl:
	rtl

org $8F8EF7
QueueTextDMA:		;SNES: DMAList entry for the changed textmap words (textdirtylo..textdirtyhi) to vram
	lda.b textdirtylo
	bmi .rtl
	ldy.b DMAListend
	sta.w DMAList+dmavram,y
	asl a
	adc.w #textmap
	sta.w DMAList,y
	lda.w #textmap>>16
	sta.w DMAList+dmabank,y
	lda.b textdirtyhi
	beq .rtl
	sec
	sbc.b textdirtylo
	inc a
	asl a
	sta.w DMAList+dmalen,y
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	tya
	clc
	adc.w #dmasize
	sta.b DMAListend
.rtl:
	rtl
QueueBackmapDMA:		;SNES: DMAList entry for backmap ($800 bytes) to vram $400
	ldy.b DMAListend
	lda.w #backmap
	sta.w DMAList,y
	lda.w #backmap>>16
	sta.w DMAList+dmabank,y
	lda.w #$0800
	sta.w DMAList+dmalen,y
	lda.w #$0400
	sta.w DMAList+dmavram,y
	tya
	clc
	adc.w #dmasize
	sta.b DMAListend
	rtl
ShowRinkRows:		;show_rink part: DMAList entries for the IceRinkMap rows that Vscroll brought on screen (Oldrow, vramrow)
	ldy.b DMAListend
	lda.w Vscroll
	clc
	adc.w #$0170
	lsr a
	lsr a
	lsr a
	tax
	sec
	sbc.w Oldrow
	bne .moved
	jmp.w .done
.moved:
	bpl .down
	stx.w Oldrow
	eor.w #$FFFF
	inc a
	cmp.w #$0019
	bcs .redraw
	sta.b tmp1
	lda.w vramrow
	sec
	sbc.b tmp1
	and.w #$001F
	sta.w vramrow
	sta.b tmp2
	bra .rows
.redraw:
	lda.w #$001D
	sta.b tmp1
	stz.w vramrow
	stz.b tmp2
	bra .rows
.down:
	stx.w Oldrow
	cmp.w #$0019
	bcs .redraw
	sta.b tmp1
	adc.w vramrow
	and.w #$001F
	sta.w vramrow
	adc.w #$001D
	sec
	sbc.b tmp1
	and.w #$001F
	sta.b tmp2
	txa
	clc
	adc.w #$001D
	sec
	sbc.b tmp1
	tax
.rows:
	txa
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b tmp0
	asl a
	adc.b tmp0
	adc.w #IceRinkMap
	sta.b tmp0
	lda.b tmp2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w #$0400
	sta.b tmp2
	ldx.b tmp1
.rowloop:
	lda.w #IceRinkMap>>16
	sta.w DMAList+dmabank,y
	sta.w DMAList+dmasize+dmabank,y
	lda.b tmp2
	sta.w DMAList+dmavram,y
	clc
	adc.w #$0400
	sta.w DMAList+dmasize+dmavram,y
	sec
	sbc.w #$03E0
	cmp.w #$0800
	bne .nowrap
	lda.w #$0400
.nowrap:
	sta.b tmp2
	lda.b tmp0
	sta.w DMAList,y
	clc
	adc.w #$0040
	sta.w DMAList+dmasize+dmasrc,y
	adc.w #$0020
	sta.b tmp0
	lda.w #$0040
	sta.w DMAList+dmalen,y
	lsr a
	sta.w DMAList+dmasize+dmalen,y
	tya
	adc.w #$000E
	tay
	dex
	bne .rowloop
.done:
	sty.b DMAListend
	rtl

org $8FDAF3
addframe_full:		;SNES: sprite VRAM cache full: sprnodraw, addframe_end
	lda.w #$0001
	sta.b sprnodraw
	jml.l addframe_end

org $8FE04C
ClearSprites:		;SNES: all 128 OAM entries off screen (y $E0), the high table clear; new sprite frame (sprclock), VRAM slot rotors restart
	clc
	ldx.w #$0000
	ldy.w #$0008
.loop:
	lda.w #$E0E0
	sta.w Satt,x
	stz.w Satt+2,x
	sta.w Satt+$4,x
	stz.w Satt+$6,x
	sta.w Satt+$8,x
	stz.w Satt+$A,x
	sta.w Satt+$C,x
	stz.w Satt+$E,x
	sta.w Satt+$10,x
	stz.w Satt+$12,x
	sta.w Satt+$14,x
	stz.w Satt+$16,x
	sta.w Satt+$18,x
	stz.w Satt+$1A,x
	sta.w Satt+$1C,x
	stz.w Satt+$1E,x
	sta.w Satt+$20,x
	stz.w Satt+$22,x
	sta.w Satt+$24,x
	stz.w Satt+$26,x
	sta.w Satt+$28,x
	stz.w Satt+$2A,x
	sta.w Satt+$2C,x
	stz.w Satt+$2E,x
	sta.w Satt+$30,x
	stz.w Satt+$32,x
	sta.w Satt+$34,x
	stz.w Satt+$36,x
	sta.w Satt+$38,x
	stz.w Satt+$3A,x
	sta.w Satt+$3C,x
	stz.w Satt+$3E,x
	txa
	adc.w #$0040
	tax
	dey
	bne .loop
.hiclear:
	stz.w Satt,x
	inx
	inx
	cpx.w #$0220
	bne .hiclear
	stz.b sprcount
	inc.b sprclock
	lda.b sprnodraw
	beq .nosprnodraw
	stz.b sprnodraw
	lda.b sprslotlife
	cmp.w #$0003
	bcc .nosprnodraw
	dec.b sprslotlife
.nosprnodraw:
	lda.b sprbigslot
	sta.b sprbigslotend
	lda.b sprslot
	sta.b sprslotend
	rtl
RemapTiles:		;SNES: d0 4bpp tiles at [a0] to vram with each pixel value remapped through the 16-byte table [a1]
	lda.w #$000E
	sta.b tmp2+1
.tile:
	rep #$30
	ldy.b tmp2+1
	lda.b [a0],y
	sta.b tmp0
	tya
	clc
	adc.w #$0010
	tay
	lda.b [a0],y
	sta.b tmp1
	sep #$30
	ldx.b tmp2+1
	lda.b #$07
	sta.b tmp2
.pixel:
	ldy.b #$00
	asl.b tmp1+1
	bcc .lt
	ldy.b #$08
.lt:
	asl.b tmp1
	bcc .lt2
	iny
	iny
	iny
	iny
.lt2:
	asl.b tmp0+1
	bcc .lt3
	iny
	iny
.lt3:
	asl.b tmp0
	bcc .lt4
	iny
.lt4:
	lda.b [a1],y
	lsr a
	rol.b mula,x
	lsr a
	rol.b mula+1,x
	lsr a
	rol.b mula+16,x
	lsr a
	rol.b mula+17,x
	dec.b tmp2
	bpl .pixel
	dec.b tmp2+1
	dec.b tmp2+1
	bpl .tile
	rep #$30
	ldx.w #$0000
.out:
	lda.b mula,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0020
	bne .out
	lda.b a0
	clc
	adc.w #$0020
	sta.b a0
	dec.b d0
	bne RemapTiles
	rtl

org $8FEC68
addframe:		;a3 = cords.l frame/oldframe VRsize VRchar. Project the object with find3d, then addframe2.
		;   SNES: sprite frame sprframe at sprx/spry: find its frame set in FrameSetTable (sprsetofs), then DrawFrame; frames $293 and up (addframe_hi) and frame 0 are skipped
	lda.b sprframe
	cmp.w #$0293
	bcc .sprframelt
	jml.l addframe_end
.sprframelt:
	dec.b sprframe
	bpl .sprframepos
	jml.l addframe_end
.sprframepos:
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.loop:
	lda.l FrameSetTable,x
	beq .loop
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .sprframege
	jml.l DrawFrame
.sprframege:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .loop
