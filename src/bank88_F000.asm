; $88EF9C-$88FFFF  ROM $46F9C-$47FFF: GetPassWord (92G, the password screen), TitleScreen (93G hockey93_07: title backdrop and scrolling credits),
; PlayoffScreen (93G hockey93_06: the playoff tree) with PlayoffTreeSetup, assdefd (logic93_2, asstab 2), SuperAdd (92G), skateto (logic93_5),
; $FF fill. Starts after SpriteSet7 (boundary moved from $88F002).
org $88EF9C
GetPassWord:		;92G GetPassWord: the password screen on the game setup backdrop: pick characters from the PasstoText grid; Start decodes it (DecodePW), a bad one
		;   offers retry or the setup screen
	lda.w #$0080		; show the password again
	trb.w PassWord
	jsl.l Readjoy12
	jsl.l DrawGameSetupBack
	jsl.l ReadPads
	jsl.l Readjoy12
	jsl.l ClearSprites		; bank $8F: clear the sprite table
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$12
	lda.w #17
	sta.b d0
	lda.w #5
	sta.b d1
	jsl.l Framer		; Framer 17 x 5, bank $8F: 93G Framer (d0 x d1)
	lda.w #PasswordText
	sta.b a1
	lda.w #PasswordText>>16
	sta.b a1+2
.textlp:
	jsl.l print
	ldy.w #$0002
	lda.b [a1],y
	and.w #$00FF
	bne .textlp
	dec.w printx		; cursor back over the blanks
	dec.w printx
	lda.w #PasstoText		; a0 = PasstoText
	sta.b a0
	lda.w #PasstoText>>16
	sta.b a0+2
	lda.w #4
	sta.b d0
.top2:		;5 rows
	lda.w #5
	sta.b d1
	lda.w #mesarea		; a1 = mesarea, length 13
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #13
	sta.b [a1]
	inc.b a1
	inc.b a1
.top1:		;6 columns: character, blank
	lda.b [a0]
	sta.b [a1]
	inc.b a0
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .top1
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jsl.l print
	inc.w printy
	inc.w printy
	lda.w printx
	sec
	sbc.w #11
	sta.w printx
	dec.b d0
	bpl .top2
	stz.b d4
	stz.b d5
	jsl.l .setd4		; cursor at character 0, frame around grid character 0
	jsl.l .setd5
	jsl.l Framer		; bank $8F: 93G Framer (d0 x d1)
.topx:
	jsl.l printz
	dw $0013		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$13,"D Pad - Select"
	jsl.l printz
	dw $0011		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$14,"    A - Next"
	jsl.l printz
	dw $0011		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$15,"    Y - Back"
.input:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$10
	jsl.l PWprint
	lda.w #VBlank_SprPal
.wait:		;wait for the next vblank
	cmp.b vbint
	beq .wait
	jsl.l QueueTextDMA		; bank $8F: queue the changed textmap words
	jsl.l QueueBackmapDMA		; bank $8F
	lda.w #VBlank_SprPal
	sta.b vbint
.pad:
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	beq .pad
	sta.b d1
	bit.w #JOYSTART		; Start: done
	beq .keys
	jmp.w .exit
.keys:
	stz.b d0
	dec.b d0
	bit.w #abut		; Y: left
	bne .pwl
	stz.b d0
	inc.b d0
	bit.w #JOYA		; A: right
	bne .pwl
	bit.w #JOYRIGHT		; right: next character
	bne .pws
	stz.b d0
	dec.b d0
	bit.w #JOYLEFT		; left
	bne .pws
	ldy.w #6
	sty.b d0
	bit.w #JOYDOWN		; down: 6 on
	bne .pws
	ldy.w #-6
	sty.b d0
	bit.w #JOYUP		; up: 6 back
	bne .pws
	bra .input
.pwl:		;Y/A: cursor d4 left/right
	lda.b d4
	clc
	adc.b d0
	cmp.w #16		; PWlength-1
	bcs .input
	sta.b d4
	jsl.l .setd4
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	stz.b d0
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	cmp.w #PWrange		; pwrange: a set character
	bcs .pws
	sec
	sbc.b d5
	sta.b d0
.pws:		;dpad: character d5 by d0
	lda.b d5
	clc
	adc.b d0
	cmp.w #PWrange		; PWrange
	bcc .pwset
	jmp.w .input
.pwset:
	pha
	jsl.l .setd5
	phx
	lda.w printy		; erase the old frame (3 x 3 blanks in backmap)
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.w printx
	tax
	lda.w blankchar
	sta.l backmap,x
	sta.l backmap+2,x
	sta.l backmap+4,x
	sta.l backmap+$40,x
	sta.l backmap+$42,x
	sta.l backmap+$44,x
	sta.l backmap+$80,x
	sta.l backmap+$82,x
	sta.l backmap+$84,x
	plx
	pla
	sta.b d5
	jsl.l .setd5
	jsl.l Framer		; bank $8F: 93G Framer (d0 x d1)
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	ldy.b d4
	sep #$20		; PassWord[d4] = d5
	lda.b d5
	sta.b [a0],y
	rep #$30
	jmp.w .input
.setd4:		;print the " < " cursor under password character d4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$11
	lda.w printx
	clc
	adc.b d4
	sta.w printx
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db " < "
	rtl
.setd5:		;printx/printy and d0 = d1 = 3: frame around grid character d5
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$14,$0D
	lda.b d5
	sta.b mulb
	lda.w #6
	sta.b mula
	jsl.l divu16		; grid row/column of d5 (6 per row)
	asl a
	adc.w printy
	sta.w printy
	lda.b mulres+2
	asl a
	adc.w printx
	dec a
	dec a
	sta.w printx
	lda.w #3
	sta.b d0
	sta.b d1
.rtl:
	rtl
.exit:		;Start
	jsl.l DecodePW
	lda.w postarts		; no error: exit
	bpl .rtl
	jsl.l printz
	dw $0013		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$13,"Bad Password  "
	jsl.l printz
	dw $0013		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$14,"A - Retry     "
	jsl.l printz
	dw $0014		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$15,"Y - Exit Screen"
	lda.w #VBlank_SprPal
.wait2:
	cmp.b vbint
	beq .wait2
	jsl.l QueueTextDMA		; bank $8F: queue the changed textmap words
	jsl.l QueueBackmapDMA		; bank $8F
	lda.w #VBlank_SprPal
	sta.b vbint
.notok:
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	beq .notok
	sta.b d1
	bit.w #abut		; Y: setup screen
	bne .setup
	bit.w #JOYA		; A: retry
	beq .notok
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$01,$12
	lda.w #17
	sta.b d0
	lda.w #5
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser		; erase the message box, bank $8D: 93G eraser (d0 x d1, tile d2)
	jmp.w .topx
.setup:		;Y: back to the setup screen (new playoffs)
	lda.w #2
	sta.w OptPlayMode
	jml.l Restart		; bank $83: the setup screens
PasswordText:		;92G GetPassWord .text: "Password" at 2, 14, "Press Start" at 10, 24, then print at 21, 14; then an empty string ends it
	dw 30
	db $FF,2,14,"Password",$FF,10,24,"Press Start",$FF,21,14
	dw 3
	db 0
TitleScreen:		;93G TitleScreen (hockey93_07): Title1Map backdrop, StartSong6, then the Credits scroll up 6 rows at a time; Start leaves
	lda.w #$0198		; the blank tile and the small font above the title tiles
	sta.w blankchar
	inc a
	sta.w smallfontchars
	stz.w charofs
	stz.w charofs2
	jsl.l forceblack		; bank $8F: 93G forceblack
	jsl.l InitPPU		; bank $8D: PPU registers off/clear
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
	jsl.l DecompressGraphics
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
	lda.w #SmallFontTiles		; SmallFontTiles, remapped with the table at $8FE154
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
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
	jsl.l RemapTiles		; bank $8F: remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	jsl.l StartSong6
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $CF,$00,$1C
	stz.b d0
	lda.w #Credits		; a0 = the credits text ($8AFAA8)
	sta.b a0
	lda.w #Credits>>16
	sta.b a0+2
	lda.w #textmap		; DMAList: textmap ($7E6E74) $1000 bytes to vram 0 each frame
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
.top4:		;93G .top4: blank the 6 rows below the screen
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
	jsl.l QueueTextDMA		; bank $8F: queue the changed textmap words
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
CreditsBlank:		;print string of 32 blanks: TitleScreen erases the rows below the credits with it
	dw 34
	db "                                "
PlayoffScreen:		;93G PlayoffScreen (hockey93_06): set the font tile bases; in playoff mode draw the tree (PlayoffTreeSetup by gamelevel: team
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
	jsl.l forceblack		; bank $8F: 93G forceblack
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
	lda.w #PlayoffTiles		; PlayoffTiles ($84F79D): 128 colours, then 6 tiles
	sta.b tmp0
	lda.w #PlayoffTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.tl:
	lda.l TestList+$100,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$00C0
	bne .tl
	ldx.w #$0000
.pl:
	lda.l TestList,x
	sta.l palbuffer,x
	inx
	inx
	cpx.w #$0100
	bne .pl
	lda.w #SmallFontTiles		; SmallFontTiles twice: remapped with $8FE154, then with PixelRemap83
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
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
	jsl.l RemapTiles		; bank $8F: remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
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
	jsl.l RemapTiles		; bank $8F: remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	lda.w #TeamBlocksTiles		; TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.tb:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .tb
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
	jsl.l mulu16		; bank $8D: 16-bit multiply
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
.arrow:		;DrawPlayoffBracket: arrow column (23 rows of PlayoffBracketMap) at x; $FF ends
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
.al:
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
	bne .al
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
.sc:
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
	lda.w #5		; mesarea "<home wins>-<away wins>"
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
	bne .sc
.logo:		;the NHLPA logo ($8C8000): palette row 2, tiles at logochars, map at x 60, y 2
	lda.w #NHLPALogo
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$001E		; logo palette to palette row 2
.lp:
	lda.l TestList+$A0,x
	sta.l palbuffer+$C0,x
	dex
	dex
	bpl .lp
	lda.w logochars		; logo tiles to vram logochars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.lt:
	lda.l TestList+$1A0,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06A0
	bne .lt
	stz.b tmp1
.lr:
	stz.b tmp0
.lc:
	lda.b tmp1
	sta.b mula
	lda.w #8
	sta.b mulb
	jsl.l mulu16		; bank $8D: 16-bit multiply
	adc.b tmp0
	asl a
	tax
	lda.l TestList,x
	adc.w logochars
	ora.w #$1800		; palette 6, priority
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
	bne .lc
	inc.b tmp1
	lda.b tmp1
	cmp.w #10
	bne .lr
	jsl.l ClearSprites		; bank $8F: clear the sprite table
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
	jsl.l eraser		; bank $8D: 93G eraser (d0 x d1, tile d2)
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
	jsl.l eraser		; bank $8D: 93G eraser (d0 x d1, tile d2)
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
	bne .loop
.stop:		;stop at the round columns
	stz.b d3+2
.loop:
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
PlayoffTreeSetup:		;93G PlayoffTreeSetup: playoff tree layout by gamelevel (offsets, then per level: slots, arrows, scroll limits, scores)
	dw .l0-PlayoffTreeSetup,.l1-PlayoffTreeSetup,.l2-PlayoffTreeSetup,.l3-PlayoffTreeSetup,.l4-PlayoffTreeSetup
.l0:		;gamelevel 0: 16 team slots (x, y)
	db 16
	db 49,2,49,5,49,8,49,11,49,14,49,17,49,20,49,23
	db 70,2,70,5,70,8,70,11,70,14,70,17,70,20,70,23
	db 0,58,1,59,10,68,11,69,$FF		; arrows (graphics, x), $FF
	db 48,48		; Hscroll min, max (x8)
	db 8,52,4,52,10,52,16,52,22,73,4,73,10,73,16,73,22		; series scores (x, y)
.l1:		;gamelevel 1: 24 team slots (x, y)
	db 24
	db 38,2,38,5,38,8,38,11,38,14,38,17,38,20,38,23
	db 81,2,81,5,81,8,81,11,81,14,81,17,81,20,81,23
	db 49,4,49,10,49,15,49,21,70,4,70,10,70,15,70,21
	db 0,47,1,48,2,58,3,59,8,68,9,69,10,79,11,80,$FF		; arrows (graphics, x), $FF
	db 33,63		; Hscroll min, max (x8)
	db 4,52,8,52,18,73,8,73,18		; series scores (x, y)
.l2:		;gamelevel 2: 28 team slots (x, y)
	db 28
	db 27,2,27,5,27,8,27,11,27,14,27,17,27,20,27,23
	db 92,2,92,5,92,8,92,11,92,14,92,17,92,20,92,23
	db 38,4,38,10,38,15,38,21,81,4,81,10,81,15,81,21
	db 49,7,49,18,70,7,70,18
	db 0,36,1,37,2,47,3,48,4,58,5,59,6,68,7,69,8,79,9,80,10,90,11,91,$FF		; arrows (graphics, x), $FF
	db 22,74		; Hscroll min, max (x8)
	db 2,52,13,73,13		; series scores (x, y)
.l3:		;gamelevel 3: 30 team slots (x, y)
	db 30
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21
	db 38,7,38,18,81,7,81,18,49,12,70,12
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; arrows (graphics, x), $FF
	db 11,85		; Hscroll min, max (x8)
	db 1,62,23		; series scores (x, y)
.l4:		;gamelevel 4: 31 team slots (x, y)
	db 31
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21
	db 38,7,38,18,81,7,81,18,49,12,70,12,59,23
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; arrows (graphics, x), $FF
	db 11,85		; Hscroll min, max (x8)
	db 0		; series scores (x, y)
assdefd:		;asstab 2. 93G assdefd (logic93_2): defenceman on defence: stay between the furthest-up attacker and the goal, join the attack (adefo) when the puck is past the line
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing		; bank $8F: assnothing
.gm:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pfjoycon
	beq .chk
	jmp.w .rtl
.chk:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .new
	jmp.w .de3
.new:
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w pucky
	sta.b d1
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .sx
	ora.w #$FC00
.sx:
	sta.b d3
	lda.w pfgoal,x
	bne .de00
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
.de00:		;only lead when moving up ice
	lda.b d3
	bpl .v
	stz.b d3
.v:
	lda.b d3
	clc
	adc.b d1
	sta.b d3
	sec
	sbc.w #$58
	bmi .lt
	bvc .ge
	bra .de0
.lt:
	bvc .de0
.ge:
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .de0
	lda.w puckc
	sta.b d1
	bmi .de0
	jsl.l chkpk
	beq .de0
	lda.w #1
	sta.b d0
	lda.b d1
	sec
	sbc.w #6
	sta.b d1
	txa
	lsr a
	sec
	sbc.w #6
	sta.b d2
	eor.b d1
	sta.b d1
	bmi .de0
	jml.l assreplace
.de0:
	lda.w #65
	sta.w temp3,x
	lda.w position,x
	cmp.w #$0002
	beq .de1
	lda.w #-65
	sta.w temp3,x
.de1:
	stz.b a0
	cpx.w #12
	bcs .de2
	lda.w #12
	sta.b a0
.de2:		;find the furthest-up attacker
	lda.w #5
	sta.b d2
	lda.w #-1000
	sta.b d0
	lda.w pfgoal,x
	beq .gdwn
	lda.w #1000
	sta.b d0
.gup:
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .gu0
	lda.w position,y
	bmi .gu0
	lda.w Yvel,y
	bmi .gu2
	lda.w #$0000
.gu2:
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .gu2s
	ora.w #$F000
.gu2s:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	beq .gu3
	bmi .gt
	bvs .gu3
	bra .gu0
.gt:
	bvs .gu0
.gu3:
	lda.b d1
	sta.b d0
.gu0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .gup
	lda.b d0
	sec
	sbc.w #50
	sta.b d0
	sec
	sbc.w #-190
	beq .cl1
	bmi .gt1
	bvs .cl1
	bra .gu1
.gt1:
	bvs .gu1
.cl1:
	lda.w #-220
	sta.b d0
.gu1:
	lda.b d0
	sta.w temp4,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .de3
	stz.w temp3,x
	bra .de3
.rtl:
	rtl
.gdwn:
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .gd0
	lda.w position,y
	bmi .gd0
	lda.w Yvel,y
	bpl .gd2
	lda.w #$0000
.gd2:
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .gd2s
	ora.w #$F000
.gd2s:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	bmi .lt2
	bvc .gd3
	bra .gd0
.lt2:
	bvc .gd0
.gd3:
	lda.b d1
	sta.b d0
.gd0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .gdwn
	lda.b d0
	clc
	adc.w #50
	sta.b d0
	sec
	sbc.w #190
	bmi .lt3
	bvc .cl2
	bra .gd1
.lt3:
	bvc .gd1
.cl2:
	lda.w #220
	sta.b d0
.gd1:
	lda.b d0
	sta.w temp4,x
	lda.w temp3,x
	eor.w #$FFFF
	inc a
	sta.w temp3,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .de3
	stz.w temp3,x
.de3:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #EvadePC
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jsl.l skateto
	jml.l check4check
SuperAdd:		;92G SuperAdd: passbits (8 words) += d0
	phx
	lda.w passbits
	clc
	adc.b d0
	sta.w passbits
	bcc .ex
	ldx.w #$0002
.carry:
	inc.w passbits,x
	bne .ex
	inx
	inx
	cpx.w #16
	bne .carry
.ex:
	plx
	clc
	rtl
skateto:		;93G skateto (logic93_5): a0 = collision avoidance routine, d0/d1 = x/y to skate to, d7 = frames. SNES: a skater near the target (sum of distances < 55) slows to 7/8
	lda.w position,x
	beq .t2
	lda.w pflags,x
	and.w #$8000
	ora.w sfhormode
	bne .t2
	lda.b d0
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0088
	bcs .t2
	lda.w Xpos,x
	sec
	sbc.b d0
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b tmp0
	lda.w Ypos,x
	sec
	sbc.b d1
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	clc
	adc.b tmp0
	cmp.w #55
	bcs .t2
	lda.w Xvel,x
	sta.b mula
	lda.w #7
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #7
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Yvel,x
.t2:		;every 12/60 second
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .go
	jmp.w .ex
.go:
	adc.w #11
	sta.w temp2,x
	jsl.l avdgoal		; bank $8D: avdgoal
	lda.w #13
	sta.b d0+2
	lda.b d0
	bit.w #$8000
	beq .near
	eor.w #$FFFF
	inc a
.near:
	cmp.w #$0088
	bcs .av
	lda.w #18
	sta.b d0+2
.av:
	lda.b deltax
	ora.b deltay
	beq .lead
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	bra .vt
.lead:		;aim ahead of the velocity
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .lx
	ora.w #$FF00
.lx:
	eor.w #$FFFF
	inc a
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ly
	ora.w #$FF00
.ly:
	eor.w #$FFFF
	inc a
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.b d0
	bit.w #$8000
	beq .cx
	eor.w #$FFFF
	inc a
.cx:
	cmp.b d0+2
	bcs .vt
	lda.b d1
	bit.w #$8000
	beq .cy
	eor.w #$FFFF
	inc a
.cy:
	cmp.b d0+2
	bcs .vt
	lda.w #9
	sta.b d0
	bra .nvt
.vt:
	jsl.l vtoa
.nvt:		;jsr (a0) through jmlvector
	lda.b a0
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector
	lda.b d0
	sta.w temp2b,x
	cmp.w #8
	bcc .ex
	lda.w Xvel,x
	ora.w Yvel,x
	bne .ex
	lda.w puckx
	sta.b d0
	lda.w pucky
	sta.b d1
	lda.w pf2fight+puckobj
	beq .nf
	lda.w xc1
	sta.b d0
	lda.w yc1
	sta.b d1
.nf:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	sec
	sbc.w facedir,x
	beq .ex
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.w facedir,x
.ex:
	lda.w temp2b,x
	sta.b d0
	jml.l doplayeracc		; bank $8F: doplayeracc
unusedFF88:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
