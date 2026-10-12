setupice:		;set all variables, send non purgeable graphics, build sprite frame lists for ice rink.
		;   SNES: set all variables, send the rink and text graphics to vram, palettes, video mode, team colors
	jsl.l forceblack		; setvram role
	lda.w #$0207		; vram tile bases of the text layer
	sta.w faceoffvrcset
	clc
	adc.w #$0037
	sta.w unusedchars
	adc.w #$000E
	sta.w refcharshor
	adc.w #$0068
	sta.w refchars
	adc.w #$0075
	sta.w blankchar
	inc a
	sta.w smallfontchars
	adc.w #$0064
	sta.w Framercset
	adc.w #$0004
	sta.w BigFontChars
	adc.w #$0090
	sta.w scorechars
	adc.w #$0195
	sta.w ExtraChars
	lda.w #$FF00		; charofs = $FF00
	sta.w charofs
	stz.w charofs+2
	jsl.l InitPPU		; PPU init: PPU registers off/clear, sound driver start
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY		; NMI on, auto joypad read
	sta.w NMITIMEN
	lda.b #$03		; OBSEL: 8x8/16x16 sprites at $6000
	sta.w OBSEL
	lda.b #BGMODE_1		; BGMODE 1
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$05		; BG2 map at $0400, 64x32
	sta.w BG2SC
	lda.b #$12		; BG1 tiles $2000, BG2 tiles $1000
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2|TM_OBJ		; TM: BG1, BG2, sprites
	sta.w TM
	rep #$30
	ldx.w #$00FE
.pal:		;rink palette to both halves of palbuffer
	lda.l RinkPalette,x
	sta.l palbuffer,x
	sta.l palbuffer+$100,x
	dex
	dex
	bpl .pal
	jsl.l sndqreset		; sound queue reset
	lda.w sndbank		; in-game sound set not loaded yet: load it
	cmp.w #$0001
	beq .gfx
	jsl.l SPCGameUpload
.gfx:		;decompress each tile set to $7F0000 and send it to vram
	lda.w #IceRinkTiles		; packed rink tiles
	sta.b tmp0
	lda.w #IceRinkTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #$1000		; vram $1000
	sta.w VMADDL
	ldx.w #$0000
.up1:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$40E0
	bne .up1
	lda.w #FaceOffTiles		; packed faceoff box tiles
	sta.b tmp0
	lda.w #FaceOffTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up2:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06E0
	bne .up2
	lda.w #RinkLogoTiles		; packed rink logo tiles
	sta.b tmp0
	lda.w #RinkLogoTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up3:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$01C0
	bne .up3
	lda.w #RefTilesHor		; packed ref window tiles, horizontal rink
	sta.b tmp0
	lda.w #RefTilesHor>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up4:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0D00
	bne .up4
	lda.w #RefTiles		; packed ref window tiles, vertical rink
	sta.b tmp0
	lda.w #RefTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up5:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0EA0
	bne .up5
	ldx.w #$0010
.blank:		;blank tile
	stz.w VMDATAL
	dex
	bne .blank
	lda.w #SmallFontTiles		; packed small font tiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	stz.b a0		; sprite frame list from the $7F0000 data
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap83
	sta.b a1
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles		; build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #FramerTiles
	sta.b a0
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #$0004
	sta.b d0
	jsl.l RemapTiles		; build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #BigFontTiles		; packed big font tiles
	sta.b tmp0
	lda.w #BigFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	stz.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap8D
	sta.b a1
	lda.w #PixelRemap8D>>16
	sta.b a1+2
	lda.w #$0090
	sta.b d0
	jsl.l RemapTiles		; build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #999		; Oldrow = 999, no pause, Hpos = Vpos = 0
	sta.w Oldrow
	lda.w #$0001
	trb.w sflags
	stz.w Hpos
	stz.w Vpos
	lda.b vcount+2		; vcountmark well in the past
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l InitSortObjects
	stz.w zamx
	jsl.l nullrtl
	lda.w gmode
	bit.w #gmdir		; gmdir
	beq .gok
	ldx.w #$0016
.l01:		;gmdir: flip pfgoal of the 12 players
	lda.w pfgoal,x
	eor.w #$0001
	sta.w pfgoal,x
	dex
	dex
	bpl .l01
.gok:
	jsl.l setplayercolors
	lda.w #$FFFF		; PadControlBits = $FFFF, padcont = 0
	sta.w PadControlBits
	stz.w padcont
	stz.w padcont+2
	stz.w padcont+4
	stz.w padcont+6
	lda.w #$FFFF		; c1playernum = c2playernum = -1
	sta.w c1playernum
	sta.w c2playernum
	stz.b brightness		; brightness 0, fade in after 10 frames
	lda.w #$000A
	sta.b fadein
	rtl
