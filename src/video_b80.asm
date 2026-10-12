; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8080B2
BRKHalt:		;SNES: BRK vector: hang
	bra BRKHalt
VBjsr:		;Vertical blank interrupt, jumps through the vbint RAM vector
		;   SNES: NMI: ack RDNMI, skip if vbactive, else "rts" into the vbint handler
	rep #$30
	pha
	lda.w RDNMI
	bit.w #$0080
	beq .skip		; not a vblank NMI
	lda.b vbactive
	beq .dispatch
.skip:		;not a vblank NMI, or the last handler still runs
	pla
	rti
.dispatch:		;push vbint-1 and rts into it (A/X/Y stay on the stack for the handler to pull)
	inc.b vbactive
	phx
	phy
	lda.b vbint
	dec a
	pha
	rts
vb2_blank:		;vbint target: vb2 with the screen held in forced blank. Resets hbint to HBdefault
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	rep #$30
	lda.w #HBdefault
	sta.b hbint
	bra vb2_main
vb2:		;vblank used for palfades only no dmas (vbint target).
		;   SNES: vblank for fades only, no dma. INIDISP from brightness, then vb2_main
	sep #$20
	lda.b brightness
	sta.w INIDISP
vb2_main:		;common vblank tail: vcount, sound tick (p_music_vblank), brightness fades (cramfade), rti
	rep #$30
	inc.b vcount
	bne .tick
	inc.b vcount+2
.tick:
	jsl.l p_music_vblank		; bank $89 (sound tick)
	stz.b hcount		; clear the IRQ count every frame
	lda.b fadeout
	beq .fadein
	lda.b brightness
	beq .fadeoutdone
	lda.b vcount
	bit.w #$0003		; every 4th frame
	bne .fadein
	dec.b brightness
	bra .fadein
.fadeoutdone:
	stz.b fadeout
.fadein:
	lda.b fadein
	beq .exit
	cmp.w #$0001		; 1 = fading in, >1 = delay first
	bne .fadeindelay
	lda.b brightness
	cmp.w #$000F		; full brightness
	beq .fadeindone
	lda.b vcount
	bit.w #$0003
	bne .exit
	inc.b brightness
	bra .exit
.fadeindelay:
	dec.b fadein
	bra .exit
.fadeindone:
	stz.b fadein
.exit:
	ply
	plx
	pla
	stz.b vbactive		; vblank done
	rti
VBlank_long:		;vbint target (set by setvideo): jml into VBlank so it runs from the FastROM bank $80
	jml.l VBlank
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
VBlank_SprPal:		;vbint target (banks $88/$8F): VBlank, plus CGRAM colors $A0-$BF (sprite palettes 2-3) from palbuffer; one shot, then vb2
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
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
.next:
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
	lda.w #DMA_OAM
	sta.w DMAP7
	lda.w #Satt
	sta.w A1T7L
	lda.w #$0220
	sta.w DAS7L
	stz.w OAMADDL
	sep #$20
	lda.b #$00
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #DMA_CGRAM		; DMAP7=$00, BBAD7=$22 (CGDATA)
	sta.w DMAP7
	lda.w #(palbuffer+$140)&$FFFF		; color $A0
	sta.w A1T7L
	lda.w #$0040		; 32 colors
	sta.w DAS7L
	sep #$20
	lda.b #$A0		; sprite palettes 2-3
	sta.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
VBlank_List:		;vbint target (bank $8F): forced blank and DMAList only; one shot, then vb2
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
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
.next:
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
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
VBlank_VScroll:		;vbint target (bank $88): BG1VOFS = d0, then DMAList; one shot, then vb2
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	lda.b d0		; BG1VOFS = d0 (low, high)
	sta.w BG1VOFS
	lda.b d0+1
	sta.w BG1VOFS
	ldx.b DMAListend
	bra .next
.dmaloop:
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
.next:
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
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
VBlank_Cram:		;vbint target (bank $88): DMAList, BG1 fine h-scroll Hscroll&7, BG1VOFS 0, CGRAM 0-127 from palbuffer; then VBlank_CramOnly every frame
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
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
.next:
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
	sep #$20
	lda.w Hscroll
	and.b #$07
	sta.w BG1HOFS		; BG1HOFS = Hscroll&7
	stz.w BG1HOFS
	stz.w BG1VOFS
	stz.w BG1VOFS
	rep #$30
	lda.w #DMA_CGRAM
	sta.w DMAP7
	lda.w #palbuffer&$FFFF		; colors 0-127
	sta.w A1T7L
	lda.w #$0100
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #VBlank_CramOnly		; from now on: CGRAM every frame
	sta.b vbint
	ldx.w #$0012
.wait:		;short delay before leaving the handler
	dex
	bne .wait
	jmp.w vb2
VBlank_CramOnly:		;vbint target (stays installed): forced blank, CGRAM 0-127 from palbuffer each frame, then vb2_main
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	rep #$30
	lda.w #DMA_CGRAM
	sta.w DMAP7
	lda.w #palbuffer&$FFFF
	sta.w A1T7L
	lda.w #$0100
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	jmp.w vb2
HBjsr:		;SNES: IRQ vector: if TIMEUP set, "rts" into hbint; else HBdefault
	rep #$30
	pha
	phx
	phy
	sep #$20
	lda.w TIMEUP
	bpl HBdefault		; not a timer IRQ
	rep #$30
	lda.b hbint
	dec a
	pha
	rts
HBdefault:		;default hbint: count hcount, restore regs, rti
	rep #$30
	inc.b hcount
	ply
	plx
	pla
	rti

org $80E35E
setvideo:		;this is not vblank code but sets up ram for vblank transfers.
		;   SNES: once per game frame, if vblank is idle (vb2 / vb2_blank): build the sprite table and the dma list, then hand VBlank_long to vbint
	lda.b vbint		; vblank busy with a list: skip this frame
	cmp.w #vb2
	beq .go
	cmp.w #vb2_blank
	bne .rtl
	lda.b fadein		; first time after vb2_blank: fade in
	bne .go
	stz.b brightness
	inc.b fadein
.go:		;clear the sprite table
	jsl.l ClearSprites		; bank $8F: clear the sprite table (all sprites off screen)
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$003C
	bne .savea
	ldx.b xsave
	jsl.l show_rink
	jsl.l checkfo
	jsl.l checksso		; bank $8C
	jsl.l setsortcords
	jsl.l setffo
	jsl.l showclock		; bank $8F
	jsl.l showzam		; bank $8F (elapsed time from vcountmark)
	jsl.l showcrowd		; bank $88
	jsl.l showref		; bank $8B (clears sf2refref)
	jsl.l ShowRinkRows		; bank $8F: queue the rink map rows for Vscroll
	jsl.l QueueTextDMA		; bank $8F: queue the changed textmap words (textdirtylo/hi)
	lda.w #VBlank_long		; VBlank sends it all next vblank
	sta.b vbint
	stx.b xsave
	ldx.w #$003A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
show_rink:		;using hpos and vpos set scroll cords; queue rink map rows on the dma list (a5)
		;   SNES: vertical rink: Hscroll = Hpos - 128, Vscroll = -Vpos - 112 (the rows are sent elsewhere)
	lda.w sfhormode
	bne .rtl
	lda.w Hpos
	sec
	sbc.w #$0080
	sta.w Hscroll
	lda.w Vpos
	eor.w #$FFFF
	inc a
	sec
	sbc.w #$0070
	sta.w Vscroll
.rtl:
	rtl
checkfo:		;check for face off sprites. Called from setvideo. Falls into checkfo2
		;   SNES: face off sprites: the three fofdata2 entries (frame, flags) at fodropx/fodropy, priority $30
	lda.w sflags		; not in pause, face off only
	bit.w #sfpz
	bne .rtl
	lda.w sflags
	bit.w #sf2faceoff
	beq .rtl
	lda.w #$0030		; faceoff sprites above the players
	sta.b sprpriority
	ldx.w #$0000
.top:
	lda.w fodropx
	sta.b sprx
	lda.w fodropy
	sta.b spry
	lda.w fofdata2,x		; frame + faceoff sprite base $213
	clc
	adc.w #$0213
	sta.b sprframe
	lda.w fofdata2+2,x
	and.w #$0800
	sta.b sprhflip
	cpx.w #$0004		; third entry (the ref): sprflag
	bne .add
	lda.w #$8000
	sta.b sprflag
.add:
	phx
	jsl.l addframe		; bank $8F (sprframe at sprx/spry)
	plx
	inx
	inx
	inx
	inx
	cpx.w #$000C
	bne .top
	lda.w #$0020
	sta.b sprpriority
.rtl:
	rtl
setsortcords:		;setup sort cord graphics: addframe for the 16 objects in OOlist order.
		;   SNES: addframe for the 16 objects in OOlist order (hidden when Zpos < 0 or off the screen)
	lda.w #OOlist		; a4 = OOlist
	sta.b a4
.top:
	lda.b (a4)
	and.w #$00FF
	tax
	lda.w Zpos,x
	bmi .next
	sta.b d2
	lda.w Xpos,x
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	jsl.l projxy
	cmp.w #OFFSCREEN		; off the screen
	beq .next
	sta.b spry
	lda.b d0
	sta.b sprx
	lda.w frame,x		; oldframe = frame
	sta.w oldframe,x
	sta.b sprframe
	lda.w attribute,x
	and.w #$0800
	sta.b sprhflip
	lda.w attribute,x
	and.w #$1000
	sta.b sprvflip
	lda.w attribute,x		; attribute bit 0: sprflag
	lsr a
	bcc .add
	lda.w #$8000
	sta.b sprflag
.add:
	jsl.l addframe		; bank $8F (sprframe at sprx/spry)
.next:
	inc.b a4
	lda.b a4
	cmp.w #OOlist+$10
	bne .top
	rtl
projxy:		;SNES (addframe position math): rink d0/d1/d2 = x/y/z to screen: d0 = x - Hpos + 128, d1 = 112 - (y - Vpos + 1.5*z); d1 = OFFSCREEN when |x| or |y| > 144. Horizontal
		;   rink: x = -y, y = x - 197
	lda.w sfhormode
	beq .nhor
	lda.b d0
	pha
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d0
	pla
	sec
	sbc.w #$00C5
	sta.b d1
	bra .cx
.nhor:
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.cx:
	lda.b d0
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0091		; |x| > 144: off
	bcs .off
	lda.b d0
	adc.w #$0080
	sta.b d0
	lda.b d2		; d1 += 1.5 * z
	asl a
	clc
	adc.b d2
	pha
	asl a
	pla
	ror a
	clc
	adc.b d1
	sta.b d1
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$0091
	bcs .off
	lda.w #$0070
	sec
	sbc.b d1
	sta.b d1
	rtl
.off:
	lda.w #OFFSCREEN
	sta.b d1
	rtl
setffo:		;draw the 5 objects tied to icerink scrolling (pads ...). Called from setvideo.
		;   SNES: uppads, then draw the 5 objects tied to rink scrolling (pads 0-2 with their 3 character label, gloves; pad 3 skipped)
	jsl.l uppads
	ldx.w #$0000
.top:
	cpx.w #$0006
	bne .obj
	jmp.w .next		; pad 3: not drawn
.obj:
	lda.w ffox,x
	sta.b d0
	lda.w ffoy,x
	sta.b d1
	lda.w ffoz,x		; hidden
	bpl .shown
	jmp.w .next
.shown:
	sta.b d2
	jsl.l projxy
	cmp.w #OFFSCREEN
	bne .add
	jmp.w .next
.add:
	sta.b spry
	lda.b d0
	sta.b sprx
	lda.w ffoframe,x		; frame, flip bits from ffoattr
	sta.b sprframe
	lda.b ffoattr,x
	and.w #$0800
	sta.b sprhflip
	lda.b ffoattr,x
	and.w #$1000
	sta.b sprvflip
	phx
	jsl.l addframe		; bank $8F (sprframe at sprx/spry)
	plx
	cpx.w #$0006		; gloves: no label
	bcc .label
	jmp.w .next
.label:		;label: two digits (rostnum, $A+ = blank) and a position letter
	ldy.w #$0000		; mesarea+2 = label tiles, mesarea = count; d0 moves left 4 per digit
	lda.w padcont,x
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	beq .lo
	cmp.w #$000A
	bcc .hi
	jmp.w .next
.hi:
	sta.w mesarea+2,y
	iny
	dec.b d0
	dec.b d0
	dec.b d0
	dec.b d0
.lo:
	lda.w padcont,x
	and.w #$000F
	cmp.w #$000A
	bcs .next
	sta.w mesarea+2,y
	iny
	dec.b d0
	dec.b d0
	dec.b d0
	dec.b d0
	lda.w padcont+1,x		; position letter from ButtonLabelCharTable, after a blank
	and.w #$0007
	beq .draw
	adc.w #ButtonLabelCharTable-1
	sta.b a4
	lda.w #ButtonLabelCharTable>>16
	sta.b a4+2
	lda.b d0
	sec
	sbc.w #$0006
	sta.b d0
	lda.w #$FFFF
	sta.w mesarea+2,y
	iny
	lda.b [a4]
	sta.w mesarea+2,y
	iny
.draw:
	sty.w mesarea
	stz.b d0+2
.ch:
	ldy.b d0+2
	cpy.w mesarea
	beq .next
	lda.w mesarea+2,y
	and.w #$00FF
	cmp.w #$00FF
	beq .sp
	adc.w #$021E		; small font sprite base $21E
	sta.b sprframe
	lda.b d0
	sta.b sprx
	lda.b d1
	clc
	adc.w #$000A
	sta.b spry
	phx
	jsl.l addframe		; bank $8F (sprframe at sprx/spry)
	plx
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0
.sp:		;blank: 4 pixels
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0+2
	bra .ch
.next:
	inx
	inx
	cpx.w #$000A
	beq .rtl
	jmp.w .top
.rtl:
	rtl
ButtonLabelCharTable:		;tile of the position letter in the pad label, by position 1-6
	db $0B,$0B,$0C,$0A,$0D,$0E		; tiles by position (index 1-6)
uppads:		;update the gloves object and the 4 pad objects, and queue new pad labels.
		;   SNES: gloves object from glovecords, and the 4 pad objects from the PadControlBits nibbles ($E = stays, $F = hidden); padcont = label code (position <<
		;   8 | rostnum)
	ldy.w #$0008		; gloves (ffo 4): hidden unless glovecords
	lda.w #$FFFF
	sta.w ffoz,y
	lda.w glovecords
	and.w #$00FF
	beq .nogloves
	and.w #$00FF
	bit.w #$0080
	beq .gx
	ora.w #$FF00
.gx:
	asl a
	asl a
	sta.w ffox,y
	lda.w glovecords+1
	and.w #$00FF
	bit.w #$0080
	beq .gy
	ora.w #$FF00
.gy:
	asl a
	asl a
	sta.w ffoy,y
	lda.w #$0000
	sta.w ffoz,y
.nogloves:
	lda.w #$0003		; 4 pads: a0 = ffo index, a1 = padcont, d3 = PadControlBits
	sta.b d4
	stz.b a0
	lda.w #padcont
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b a2
	lda.w PadControlBits
	sta.b d3
.top:
	lda.b d3
	and.w #$000F
	sta.b d0
	lda.w #$000F		; label code for $E
	sta.b d1
	lda.b d0
	cmp.w #$000E
	beq .chg
	ldy.b a0		; hidden
	lda.w #$FFFF
	sta.w ffoz,y
	lda.b d0
	cmp.w #$000F
	beq .next
	asl.b d0		; pad at the player
	ldy.b d0
	lda.w Xpos,y
	ldy.b a0
	sta.w ffox,y
	ldy.b d0
	lda.w Ypos,y
	ldy.b a0
	sta.w ffoy,y
	lda.w #$0000
	sta.w ffoz,y
	ldy.b d0
	lda.w position,y
	xba
	and.w #$FF00
	sta.b d1
	lda.w rostnum,y
	and.w #$00FF
	tsb.b d1
.chg:
	lda.b d1
	sta.b [a1]
.next:
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
	inc.b a0
	inc.b a0
	inc.b a1
	inc.b a1
	dec.b d4
	bpl .top
	rtl
