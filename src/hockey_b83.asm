; The game, screens, menus, password, playoffs.
; Bank $83. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $83CC0C
PlayerNumName:		;SNES: mesarea = "<uniform number> <name>" of the roster player d0 (team a2), like the Pausemode .gnum digits. Returns X = mesarea
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
.pushb:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushb
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	jsl.l GetPlayerRecord		; a0 = the player entry, bank $89: a0 = roster entry of player d0
	stx.b xsave
	ldx.w #$0000
.push2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .push2
	ldx.b xsave
	lda.w #mesarea		; a3 = mesarea (length 4), a1 = mesarea+2
	sta.b a3
	inc a
	inc a
	sta.b a1
	lda.w #$0000
	sta.b a3+2
	sta.b a1+2
	lda.w #$0004
	sta.b [a3]
	lda.b a0		; skip the name: the uniform number byte
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2		; two digits, then a blank and the name
	jsl.l appendz
	dw $0003		; printz inline string: length (counts itself), then control bytes / text
	db " "
	stx.b xsave
	ldx.w #$0002
.pop1:
	pla
	sta.b a1,x
	dex
	dex
	bpl .pop1
	ldx.b xsave
	jsl.l appstring		; bank $8F
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stx.b xsave
	ldx.w #$0002
.pop2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .pop2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.pop3:
	pla
	sta.b a2,x
	dex
	dex
	bpl .pop3
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
	ldx.b a3
	rtl

org $83F82B
Pausemode:		;game is in pause mode now. Save textmap, stop the sound, horizontal screen, PAUSE title and frame, PauseMenu until it returns 0
		;   then PauseExit (PauseExit)
	phx
	ldx.w #$07FE
.save:		;textsave = textmap
	lda.l textmap,x
	sta.l textsave,x
	dex
	dex
	bpl .save
	plx
	jsl.l sndqreset		; sound off; keep sfhormode and sflags
	lda.w sfhormode
	pha
	lda.w sflags
	pha
	jsl.l forceblack		; bank $8F
	lda.w #999		; Oldrow = 999, SetHor, setvideo
	sta.w Oldrow
	jsl.l SetHor		; bank $8F
	jsl.l setvideo
	jsl.l KillCrowd		; bank $8F
.top:		;draw the pause screen
	jsl.l printbigz		; big PAUSE title and the menu frame (22 x 7)
	dw $000A		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02,"PAUSE"
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer		; bank $8F (d0 x d1)
	jsl.l printscores1		; bank $89
	jsl.l PauseMenu		; nonzero: draw again
	bne .top
	jml.l PauseExit		; bank $8F
PauseMenu:		;draw the menu (.Pmenu Pmenu), read the pad (.rjoy); up/down move psitem (5 items), Start leaves, else the .jump handler of the item. Returns A =
		;   0 to leave, 1 to redraw
	stz.w psitem
.gj:
	jsl.l Pmenu		; bank $8F: Pausemode .Pmenu (menu text and goalie number)
	jsl.l PauseReadJoy
	lda.b d1		; Start: leave
	bit.w #JOYSTART
	beq .one
	jml.l PauseLeave
.one:		;down
	bit.w #JOYDOWN
	beq .two
	inc.w psitem
	lda.w psitem
	cmp.w #$0005
	bne .gj
	dec.w psitem
	bra .gj
.two:		;up
	bit.w #JOYUP
	beq .three
	dec.w psitem
	bpl .gj
	stz.w psitem
	bra .gj
.three:		;go to .jump[psitem] through jmlvector
	lda.w psitem		; jmlvector = .jump[psitem]
	asl a
	asl a
	sta.b d0
	tay
	lda.w #.jump
	sta.b a0
	lda.w #.jump>>16
	sta.b a0+2
	lda.b [a0],y
	sta.w jmlvector+1
	iny
	lda.b [a0],y
	sta.w jmlvector+2
	jml.l jmlvector
.rm:		;Instant Replay (A = ReplayMode)
	lda.b d1
	bit.w #cbut
	beq .gj
	jsl.l forceblack		; ReplayMode with vcountmark+2 = vcount-2, bank $8F
	jsl.l sndqreset
	lda.b d7
	pha
	lda.b vcount+2
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l ReplayMode		; bank $89
	pla
	sta.b d7
.redraw:		;return 1: draw the pause screen again
	lda.w #$0001
	rtl
.sr:		;Stats Report
	lda.b d1
	bit.w #cbut
	bne .sr1
	jmp.w .gj
.sr1:
	jsl.l StatsScreen		; stats report screen, then back, bank $8F
	jsl.l StatsReport		; bank $8F
	bra .redraw
.ros:		;SNES Team Roster: show the roster, then rebuild the game screen (bg registers, palette, small font tiles, SetHor)
	lda.b d1
	bit.w #cbut
	bne .ros1
	jmp.w .gj
.ros1:
	jsl.l TeamRoster		; roster screen; then BG mode/maps, palbuffer to CGRAM, the big font, sprites, bank $8F: team roster screen
	jsl.l sndqreset
	jsl.l forceblack		; bank $8F
	sep #$20
	lda.b #$00
	sta.w BG1SC
	lda.b #$05
	sta.w BG2SC
	lda.b #$12
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2|TM_OBJ
	sta.w TM
	stz.w CGADD
	ldx.w #$0000
.pal:
	lda.l palbuffer,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .pal
	rep #$30
	lda.w #$FF00
	sta.w charofs
	stz.w charofs+2
	lda.w smallfontchars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	stz.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap83
	sta.b a1
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles		; bank $8F: remap the 4bpp pixels of the unpacked tiles ([a0] data, [a1] table, d0 tiles)
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
	jsl.l RemapTiles		; bank $8F: remap the 4bpp pixels of the unpacked tiles ([a0] data, [a1] table, d0 tiles)
	lda.b sprclock
	adc.w #$003C
	sta.b sprclock
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	jsl.l SetHor		; bank $8F
	jsl.l setvideo
	jmp.w .redraw
.go:		;Goalie: left/right change tmgoalie (0, 1, none), then Setpersonel
	jsl.l GetPadTeam		; bank $8F
	jsl.l GoalieCount		; bank $8F
	jsl.l GetPadTeam		; bank $8F
	ldy.b a2		; A or right: next goalie; left: previous; d0 = number of goalies
	lda.b d1
	bit.w #cbut|JOYRIGHT
	bne .up
	bit.w #JOYLEFT
	bne .dn
	jmp.w .gj
.dn:
	lda.w tmgoalie,y
	bmi .wrap
.dec:
	dec a
.set:
	sta.w tmgoalie,y
	jsl.l setpersonel
	jmp.w .gj
.wrap:
	lda.b d0
	bra .dec
.up:
	lda.w tmgoalie,y
	bmi .z
	inc a
	cmp.b d0
	bcc .set
	lda.w #$FFFF
	bra .set
.z:
	lda.w #$0000
	bra .set
.jump:		;Resume Game, Instant Replay, Stats Report, Goalie, Team Roster
	dd PauseResume,.rm,.sr,.go,.ros
PauseReadJoy:		;wait for a vblank and a new button (not L/R); in demo mode with no controller team the pause ends after pausetimer frames (sets Start)
	jsl.l IntermissionTick		; bank $8F
	bne .force
	jsl.l setvideo
	lda.b vcount
.vb:
	cmp.b vcount
	beq .vb
	jsl.l ReadPads		; ReadPads; ignore L/R
	lda.w joypad1
	ora.w joypad2
	bit.w #JOYR|JOYL
	bne PauseReadJoy
	jsl.l getpzjoy		; menu sounds and ticker
	jsl.l nullrtl85
	lda.w demoflag		; demo with no controller teams: count down pausetimer
	beq .chk
	lda.w cont1team
	ora.w cont2team
	bne .chk
	dec.b pausetimer
	bne .chk
.force:
	lda.w #JOYSTART
	tsb.b d1
.chk:
	lda.b d1
	beq PauseReadJoy
	lda.w #60000
	sta.b pausetimer
	rtl
PauseResume:		;pause menu item 0, Resume Game: A or Start leaves
	lda.b d1
	bit.w #JOYSTART|cbut
	bne PauseLeave
	jmp.w PauseMenu_gj
PauseLeave:		;return 0: leave the pause menu
	lda.w #$0000
	rtl
Restart:		;SNES: restart the game from scratch (Begin role): native mode, stack, DP and DB 0, clear RAM $0000-$15FE, the sprite VRAM cache, vbint vb2, hbint HBdefault, then
		; and PlayoffScreenOpening4
	sei		; interrupts off, native mode
	clc
	xce
	rep #$30
	lda.w #$1FFF
	tcs
	lda.w #$0000
	tcd
	sep #$20
	pha
	plb
	rep #$30
	jsl.l InitPPU		; bank $8D
	ldx.w #$0000
.clr:
	stz.b vcount,x
	inx
	cpx.w #$15FF
	bne .clr
	lda.w #$005C		; jmlvector opcode, sprite slot life 18
	sta.w jmlvector
	lda.w #$0012
	sta.b sprslotlife
	lda.b sprclock		; free all sprite VRAM slots
	sec
	sbc.w #$003C
	ldx.w #$0000
.cache:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .cache
	ldx.w #$0000
.cache2:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .cache2
	lda.w #$0020
	sta.b sprpriority
	lda.w #vb2
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	jsl.l setoptions		; bank $8F
	jml.l PlayoffScreenOpening4
