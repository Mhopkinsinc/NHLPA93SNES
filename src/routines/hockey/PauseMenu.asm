PauseMenu:		;draw the menu (Pmenu), read the pad (PauseReadJoy); up/down move psitem (5 items), Start leaves, else the .jump handler of the item.
		;   Returns A = 0 to leave, 1 to redraw
	stz.w psitem
.gj:
	jsl.l Pmenu
	jsl.l PauseReadJoy
	lda.b d1		; Start: leave
	bit.w #JOYSTART
	beq .down
	jml.l PauseLeave
.down:		;down
	bit.w #JOYDOWN
	beq .up
	inc.w psitem
	lda.w psitem
	cmp.w #$0005
	bne .gj
	dec.w psitem
	bra .gj
.up:		;up
	bit.w #JOYUP
	beq .item
	dec.w psitem
	bpl .gj
	stz.w psitem
	bra .gj
.item:		;go to .jump[psitem] through jmlvector
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
	jsl.l forceblack
	jsl.l sndqreset
	lda.b d7
	pha
	lda.b vcount+2
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l ReplayMode
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
	jsl.l StatsScreen
	jsl.l StatsReport
	bra .redraw
.ros:		;SNES Team Roster: show the roster, then rebuild the game screen (bg registers, palette, small font tiles, SetHor)
	lda.b d1
	bit.w #cbut
	bne .ros1
	jmp.w .gj
.ros1:
	jsl.l TeamRoster
	jsl.l sndqreset
	jsl.l forceblack
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
	jsl.l RemapTiles		; remap the 4bpp pixels of the unpacked tiles ([a0] data, [a1] table, d0 tiles)
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
	jsl.l RemapTiles		; remap the 4bpp pixels of the unpacked tiles ([a0] data, [a1] table, d0 tiles)
	lda.b sprclock
	adc.w #$003C
	sta.b sprclock
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	jsl.l SetHor
	jsl.l setvideo
	jmp.w .redraw
.go:		;Goalie: left/right change tmgoalie (0, 1, none), then Setpersonel
	jsl.l GetPadTeam
	jsl.l GoalieCount
	jsl.l GetPadTeam
	ldy.b a2		; A or right: next goalie; left: previous; d0 = number of goalies
	lda.b d1
	bit.w #cbut|JOYRIGHT
	bne .nextg
	bit.w #JOYLEFT
	bne .prevg
	jmp.w .gj
.prevg:
	lda.w tmgoalie,y
	bmi .lastg
.dec:
	dec a
.set:
	sta.w tmgoalie,y
	jsl.l setpersonel
	jmp.w .gj
.lastg:
	lda.b d0
	bra .dec
.nextg:
	lda.w tmgoalie,y
	bmi .firstg
	inc a
	cmp.b d0
	bcc .set
	lda.w #$FFFF
	bra .set
.firstg:
	lda.w #$0000
	bra .set
.jump:		;Resume Game, Instant Replay, Stats Report, Goalie, Team Roster
	dd PauseResume,.rm,.sr,.go,.ros
