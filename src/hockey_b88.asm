; The game, screens, menus, password, playoffs.
; Bank $88. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8884A9
WritePassBits:		;transfer game variables to the password bits at a3, without the checksum.
		;   SNES: playoff state into passbits (PushBits with each range), then the 9-bit checksum of the values (d7) with range 512
	jsl.l ClrPassBits
	stz.b d7
	lda.w postarts		; PushBits ranges: postarts 32, bosgames 8, gamelevel 4, potreeteam 16, pojoy 4, WinBits $4000
	sta.b d0
	lda.w #32
	sta.b d1
	jsl.l .pb
	lda.b bosgames
	sta.b d0
	lda.w #8
	sta.b d1
	jsl.l .pb
	lda.w gamelevel
	sta.b d0
	lda.w #4
	sta.b d1
	jsl.l .pb
	lda.w potreeteam
	sta.b d0
	lda.w #16
	sta.b d1
	jsl.l .pb
	lda.w pojoy
	sta.b d0
	lda.w #4
	sta.b d1
	jsl.l .pb
	lda.w WinBits
	sta.b d0
	lda.w #$4000
	sta.b d1
	jsl.l .pb
	lda.w #5
	sta.b d1
	lda.w #7
	sta.b d2
	stz.b a1
.0:		;the 8 series scores, range 5
	ldy.b a1
	lda.w gspotwins,y
	sta.b d0
	jsl.l .pb
	ldy.b a1
	lda.w gspobwins,y
	sta.b d0
	jsl.l .pb
	inc.b a1
	inc.b a1
	dec.b d2
	bpl .0
	lda.b d7		; checksum
	and.w #$01FF
	sta.b d0
	lda.w #512
	sta.b d1
	jsl.l PushBits
	rtl
.pb:		;d7 += d0, then PushBits
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	jml.l PushBits

org $8885F7
PWprint:		;print pass word
		;   SNES: print the 16 password characters (PassWord through PasstoText) at printx/printy, unless PassWord bit 7 hides it
	lda.w PassWord
	bit.w #$0080
	beq .show
	jmp.w .rtl
.show:
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .savea
	ldx.b xsave
	lda.w #PasstoText		; a2 = PasstoText
	sta.b a2
	lda.w #PasstoText>>16
	sta.b a2+2
	lda.w #mesarea		; a1 = mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #18		; length 18: 16 characters
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w #15
	sta.b d1
.top:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	tay
	lda.b [a2],y
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .top
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jsl.l print
	stx.b xsave
	ldx.w #$000A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
EncodePW:		;after playoff game compute winners and password if needed. Called from GameOver.
		;   SNES: after a playoff game, ResolveGames and maketree; then the new password, or new playoffs when the user won or went out
	lda.w OptPlayMode
	bne .po
	jmp.w .rtl
.po:
	lda.w #$0001
	sta.w OptPlayMode
	jsl.l ResolveGames
	jsl.l maketree
	lda.w gamelevel		; finished playoffs
	cmp.w #$0004
	beq .userwon
	lda.w gamenum		; gamenum >= 0: player 1 won
	bpl .nofail
	lda.w pojoy		; pojoy < 2: one player or teammates
	sec
	sbc.w #$0002
	bmi .lt
	bvc .two
	bra .userfailed
.lt:
	bvc .userfailed
.two:		;two players, first round: switch to the other team
	lda.w gamelevel
	cmp.w #$0001
	bne .userfailed
	lda.w potreeteam
	eor.w #$0001
	sta.w potreeteam
	lda.w pojoy
	eor.w #$0001
	sta.w pojoy
.nofail:
	jsl.l WritePassBits
	jsl.l BitstoPW
	lda.w sflags3		; sf3alttree: passbits before all games were resolved
	bit.w #sf3alttree
	beq .tree
	ldy.w #$000E
.cp:
	lda.w tpassbits,y
	sta.w passbits,y
	dey
	dey
	bpl .cp
	jsl.l ReadPassBits
.tree:
	jml.l maketree
.userwon:
	jsl.l ResetPassWord
.userfailed:
	lda.w #$0080		; PassWord bit 7: no password
	tsb.w PassWord
	lda.w #$0002
	sta.w OptPlayMode
	lda.b bosgames
	cmp.w #$0007
	beq .rtl
	lda.w #$0003
	sta.w OptPlayMode
.rtl:
	rtl

org $888853
SuperMult:		;1 word (d0) multiplied by the 5 words at a3.
		;   SNES: passbits (8 words) *= d0, by shift and add (mulres..mulres+15 hold the shifted copy)
	phx
	ldx.w #$000E
.copy:
	lda.w passbits,x		; copy passbits, clear passbits
	sta.b mulres,x
	stz.w passbits,x
	dex
	dex
	bpl .copy
	lda.b d0
	sta.b mula
.loop:
	lsr.b mula
	bcc .noadd
	lda.w passbits
	clc
	adc.b mulres
	sta.w passbits
	lda.w passbits+2
	adc.b mulres+2
	sta.w passbits+2
	lda.w passbits+4
	adc.b mulres+4
	sta.w passbits+4
	lda.w passbits+6
	adc.b mulres+6
	sta.w passbits+6
	lda.w passbits+8
	adc.b mulres+8
	sta.w passbits+8
	lda.w passbits+10
	adc.b mulres+10
	sta.w passbits+10
	lda.w passbits+12
	adc.b mulres+12
	sta.w passbits+12
	lda.w passbits+14
	adc.b mulres+14
	sta.w passbits+14
.noadd:
	asl.b mulres
	rol.b mulres+2
	rol.b mulres+4
	rol.b mulres+6
	rol.b mulres+8
	rol.b mulres+10
	rol.b mulres+12
	rol.b mulres+14
	lda.b mula
	bne .loop
	plx
	clc
	rtl
DrawGameSetupBack:		;SNES: game setup screen backdrop: textmap blank, GameSetupMap to backmap (priority off), the NHLPA logo map (NHLPALogo, 8 x 10) into textmap at x 12-19, y 0-9
	lda.w blankchar
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #GameSetupMap
	sta.b tmp0
	lda.w #GameSetupMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$07FE
.map:
	lda.l TestList,x
	and.w #$DFFF		; priority bit off
	sta.l backmap,x
	dex
	dex
	bpl .map
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	lda.w #NHLPALogo		; the NHLPA logo (packed)
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #$0009
	sta.b tmp1
.row:
	lda.w #$0007
	sta.b tmp0
.col:
	lda.b tmp1
	sta.b mula
	lda.w #$0008
	sta.b mulb
	jsl.l mulu16		; 16-bit multiply
	adc.b tmp0
	asl a		; logo map word + logochars
	tax
	lda.l TestList,x
	adc.w logochars
	pha
	lda.b tmp1
	asl a
	asl a
	asl a
	asl a
	asl a		; textmap row y * 32 + x + 12
	adc.b tmp0
	asl a
	tax
	pla
	sta.l textmap+$18,x
	dec.b tmp0
	bpl .col
	dec.b tmp1
	bpl .row
	rtl

org $88EF9C
GetPassWord:		;bring up password screen and get input
		;   SNES: the password screen on the game setup backdrop: pick characters from the PasstoText grid; Start decodes it (DecodePW), a bad one
		;   offers retry or the setup screen
	lda.w #$0080		; show the password again
	trb.w PassWord
	jsl.l Readjoy12
	jsl.l DrawGameSetupBack
	jsl.l ReadPads
	jsl.l Readjoy12
	jsl.l ClearSprites		; clear the sprite table
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$12
	lda.w #17
	sta.b d0
	lda.w #5
	sta.b d1
	jsl.l Framer		; d0 x d1
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
	jsl.l Framer		; d0 x d1
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
	jsl.l QueueTextDMA		; queue the changed textmap words
	jsl.l QueueBackmapDMA
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
	jsl.l Framer		; d0 x d1
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
	jsl.l QueueTextDMA		; queue the changed textmap words
	jsl.l QueueBackmapDMA
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
	jsl.l eraser		; erase the message box, bank $8D (d0 x d1, tile d2)
	jmp.w .topx
.setup:		;Y: back to the setup screen (new playoffs)
	lda.w #2
	sta.w OptPlayMode
	jml.l Restart		; the setup screens
PasswordText:		;"Password" at 2, 14, "Press Start" at 10, 24, then print at 21, 14; then an empty string ends it
	dw 30
	db $FF,2,14,"Password",$FF,10,24,"Press Start",$FF,21,14
	dw 3
	db 0
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
CreditsBlank:		;print string of 32 blanks: TitleScreen erases the rows below the credits with it
	dw 34
	db "                                "
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
PlayoffTreeSetup:		;playoff tree layout by gamelevel (offsets, then per level: slots, arrows, scroll limits, scores)
	dw .lvl0-PlayoffTreeSetup,.lvl1-PlayoffTreeSetup,.lvl2-PlayoffTreeSetup,.lvl3-PlayoffTreeSetup,.lvl4-PlayoffTreeSetup
.lvl0:		;gamelevel 0: 16 team slots (x, y)
	db 16
	db 49,2,49,5,49,8,49,11,49,14,49,17,49,20,49,23
	db 70,2,70,5,70,8,70,11,70,14,70,17,70,20,70,23
	db 0,58,1,59,10,68,11,69,$FF		; arrows (graphics, x), $FF
	db 48,48		; Hscroll min, max (x8)
	db 8,52,4,52,10,52,16,52,22,73,4,73,10,73,16,73,22		; series scores (x, y)
.lvl1:		;gamelevel 1: 24 team slots (x, y)
	db 24
	db 38,2,38,5,38,8,38,11,38,14,38,17,38,20,38,23
	db 81,2,81,5,81,8,81,11,81,14,81,17,81,20,81,23
	db 49,4,49,10,49,15,49,21,70,4,70,10,70,15,70,21
	db 0,47,1,48,2,58,3,59,8,68,9,69,10,79,11,80,$FF		; arrows (graphics, x), $FF
	db 33,63		; Hscroll min, max (x8)
	db 4,52,8,52,18,73,8,73,18		; series scores (x, y)
.lvl2:		;gamelevel 2: 28 team slots (x, y)
	db 28
	db 27,2,27,5,27,8,27,11,27,14,27,17,27,20,27,23
	db 92,2,92,5,92,8,92,11,92,14,92,17,92,20,92,23
	db 38,4,38,10,38,15,38,21,81,4,81,10,81,15,81,21
	db 49,7,49,18,70,7,70,18
	db 0,36,1,37,2,47,3,48,4,58,5,59,6,68,7,69,8,79,9,80,10,90,11,91,$FF		; arrows (graphics, x), $FF
	db 22,74		; Hscroll min, max (x8)
	db 2,52,13,73,13		; series scores (x, y)
.lvl3:		;gamelevel 3: 30 team slots (x, y)
	db 30
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21
	db 38,7,38,18,81,7,81,18,49,12,70,12
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; arrows (graphics, x), $FF
	db 11,85		; Hscroll min, max (x8)
	db 1,62,23		; series scores (x, y)
.lvl4:		;gamelevel 4: 31 team slots (x, y)
	db 31
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21
	db 38,7,38,18,81,7,81,18,49,12,70,12,59,23
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; arrows (graphics, x), $FF
	db 11,85		; Hscroll min, max (x8)
	db 0		; series scores (x, y)

org $88FDB2
SuperAdd:		;1 long (d0.L) added to the 5 words at a3.
		;   SNES: passbits (8 words) += d0 (one word), the carry rippled up
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
