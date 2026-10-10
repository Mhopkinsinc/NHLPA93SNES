; $83F72B-$83FFFF  ROM $1F72B-$1FFFF: RinkPalette, Pausemode and its menu (92G hockey.asm Pausemode: .top, .gj, .jump, .rjoy;
; the SNES menu has a fifth item, Team Roster), Restart, RefsMap (the ref window frames), assgoalietopuck (logic93_3), $FF fill.
; Starts at the rink palette (boundary moved from $83F000).
org $83F72B
RinkPalette:		;the game palette: 128 colours (data/Pals/Rink.pal), copied to both halves of palbuffer by setupice
	incbin "../data/Pals/Rink.pal"		; $83F72B-$83F82A
Pausemode:		;auto: CODE_83F82B (called from $8E817B). 92G Pausemode: game is in pause mode now. Save textmap, stop the sound, horizontal screen, PAUSE title and frame, PauseMenu until it returns 0, then PauseExit ($8F8E0D)
	phx		; $83F82B: DA
	ldx.w #$07FE		; $83F82C: A2 FE 07
.save:		;textsave = textmap
	lda.l textmap,x		; $83F82F: BF 74 6E 7E
	sta.l textsave,x		; $83F833: 9F 00 F8 7F
	dex		; $83F837: CA
	dex		; $83F838: CA
	bpl .save		; $83F839: 10 F4
	plx		; $83F83B: FA
	jsl.l sndqreset		; $83F83C: 22 1A FA 82  sound off; keep sfhormode and sflags
	lda.w sfhormode		; $83F840: AD 8E 12
	pha		; $83F843: 48
	lda.w sflags		; $83F844: AD 8C 12
	pha		; $83F847: 48
	jsl.l $8FE404		; $83F848: 22 04 E4 8F  bank $8F: 93G forceblack
	lda.w #999		; $83F84C: A9 E7 03  Oldrow = 999, SetHor, setvideo
	sta.w Oldrow		; $83F84F: 8D 9B 04
	jsl.l $8F84B5		; $83F852: 22 B5 84 8F  bank $8F: 93G SetHor
	jsl.l setvideo		; $83F856: 22 5E E3 80
	jsl.l $8F87C0		; $83F85A: 22 C0 87 8F  bank $8F
.top:		;92G .top: draw the pause screen
	jsl.l printz8B		; $83F85E: 22 BF FD 82  big PAUSE title and the menu frame (22 x 7)
	dw $000A		; $83F862  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02,"PAUSE"
	jsl.l printz		; $83F86C: 22 0C B9 80
	dw $0005		; $83F870  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #$0016		; $83F875: A9 16 00
	sta.b d0		; $83F878: 85 53
	lda.w #$0007		; $83F87A: A9 07 00
	sta.b d1		; $83F87D: 85 57
	jsl.l $8FD69F		; $83F87F: 22 9F D6 8F  bank $8F: 93G Framer (d0 x d1)
	jsl.l $89E95D		; $83F883: 22 5D E9 89  bank $89: 93G printscores1
	jsl.l PauseMenu		; $83F887: 22 91 F8 83  nonzero: draw again
	bne .top		; $83F88B: D0 D1
	jml.l $8F8E0D		; $83F88D: 5C 0D 8E 8F  bank $8F: 92G PauseExit
PauseMenu:		;auto: CODE_83F891. 92G Pausemode .gj: draw the menu (.Pmenu $8FECAB), read the pad (.rjoy); up/down move psitem (5 items), Start leaves, else the .jump handler of the item. Returns A = 0 to leave, 1 to redraw
	stz.w psitem		; $83F891: 9C 85 04
.gj:
	jsl.l $8FECAB		; $83F894: 22 AB EC 8F  bank $8F: 92G Pausemode .Pmenu (menu text and goalie number)
	jsl.l PauseReadJoy		; $83F898: 22 32 FA 83
	lda.b d1		; $83F89C: A5 57  Start: leave
	bit.w #JOYSTART		; $83F89E: 89 00 10
	beq .one		; $83F8A1: F0 04
	jml.l PauseLeave		; $83F8A3: 5C 83 FA 83
.one:		;92G .1: down
	bit.w #JOYDOWN		; $83F8A7: 89 00 04
	beq .two		; $83F8AA: F0 10
	inc.w psitem		; $83F8AC: EE 85 04
	lda.w psitem		; $83F8AF: AD 85 04
	cmp.w #$0005		; $83F8B2: C9 05 00
	bne .gj		; $83F8B5: D0 DD
	dec.w psitem		; $83F8B7: CE 85 04
	bra .gj		; $83F8BA: 80 D8
.two:		;92G .2: up
	bit.w #JOYUP		; $83F8BC: 89 00 08
	beq .three		; $83F8BF: F0 0A
	dec.w psitem		; $83F8C1: CE 85 04
	bpl .gj		; $83F8C4: 10 CE
	stz.w psitem		; $83F8C6: 9C 85 04
	bra .gj		; $83F8C9: 80 C9
.three:		;go to .jump[psitem] through jmlvector
	lda.w psitem		; $83F8CB: AD 85 04  jmlvector = .jump[psitem]
	asl a		; $83F8CE: 0A
	asl a		; $83F8CF: 0A
	sta.b d0		; $83F8D0: 85 53
	tay		; $83F8D2: A8
	lda.w #.jump		; $83F8D3: A9 1E FA
	sta.b a0		; $83F8D6: 85 33
	lda.w #.jump>>16		; $83F8D8: A9 83 00
	sta.b a0+2		; $83F8DB: 85 35
	lda.b [a0],y		; $83F8DD: B7 33
	sta.w jmlvector+1		; $83F8DF: 8D 79 01
	iny		; $83F8E2: C8
	lda.b [a0],y		; $83F8E3: B7 33
	sta.w jmlvector+2		; $83F8E5: 8D 7A 01
	jml.l $000178		; $83F8E8: 5C 78 01 00  jmlvector
.rm:		;92G .rm: Instant Replay (A = ReplayMode)
	lda.b d1		; $83F8EC: A5 57
	bit.w #cbut		; $83F8EE: 89 80 00
	beq .gj		; $83F8F1: F0 A1
	jsl.l $8FE404		; $83F8F3: 22 04 E4 8F  ReplayMode with vcountmark+2 = vcount-2, bank $8F: 93G forceblack
	jsl.l sndqreset		; $83F8F7: 22 1A FA 82
	lda.b d7		; $83F8FB: A5 6F
	pha		; $83F8FD: 48
	lda.b vcount+2		; $83F8FE: A5 02
	dec a		; $83F900: 3A
	dec a		; $83F901: 3A
	sta.w vcountmark+2		; $83F902: 8D FD 08
	jsl.l $8990F0		; $83F905: 22 F0 90 89  bank $89: 93G ReplayMode
	pla		; $83F909: 68
	sta.b d7		; $83F90A: 85 6F
.redraw:		;return 1: draw the pause screen again
	lda.w #$0001		; $83F90C: A9 01 00
	rtl		; $83F90F: 6B
.sr:		;92G .sr: Stats Report
	lda.b d1		; $83F910: A5 57
	bit.w #cbut		; $83F912: 89 80 00
	bne .sr1		; $83F915: D0 03
	jmp.w .gj		; $83F917: 4C 94 F8
.sr1:
	jsl.l $8F8757		; $83F91A: 22 57 87 8F  stats report screen, then back, bank $8F
	jsl.l $8FF58D		; $83F91E: 22 8D F5 8F  bank $8F: 92G StatsReport
	bra .redraw		; $83F922: 80 E8
.ros:		;SNES Team Roster: show the roster, then rebuild the game screen (bg registers, palette, big font tiles, SetHor)
	lda.b d1		; $83F924: A5 57
	bit.w #cbut		; $83F926: 89 80 00
	bne .ros1		; $83F929: D0 03
	jmp.w .gj		; $83F92B: 4C 94 F8
.ros1:
	jsl.l $8FE825		; $83F92E: 22 25 E8 8F  roster screen; then BG mode/maps, palbuffer to CGRAM, the big font, sprites, bank $8F: team roster screen
	jsl.l sndqreset		; $83F932: 22 1A FA 82
	jsl.l $8FE404		; $83F936: 22 04 E4 8F  bank $8F: 93G forceblack
	sep #$20		; $83F93A: E2 20
	lda.b #$00		; $83F93C: A9 00
	sta.w BG1SC		; $83F93E: 8D 07 21
	lda.b #$05		; $83F941: A9 05
	sta.w BG2SC		; $83F943: 8D 08 21
	lda.b #$12		; $83F946: A9 12
	sta.w BG12NBA		; $83F948: 8D 0B 21
	lda.b #$13		; $83F94B: A9 13
	sta.w TM		; $83F94D: 8D 2C 21
	stz.w CGADD		; $83F950: 9C 21 21
	ldx.w #$0000		; $83F953: A2 00 00
.pal:
	lda.l palbuffer,x		; $83F956: BF 74 6C 7E
	sta.w CGDATA		; $83F95A: 8D 22 21
	inx		; $83F95D: E8
	cpx.w #$0080		; $83F95E: E0 80 00
	bne .pal		; $83F961: D0 F3
	rep #$30		; $83F963: C2 30
	lda.w #$FF00		; $83F965: A9 00 FF
	sta.w charofs		; $83F968: 8D CD 1B
	stz.w charofs+2		; $83F96B: 9C CF 1B
	lda.w smallfontchars		; $83F96E: AD D7 1B
	asl a		; $83F971: 0A
	asl a		; $83F972: 0A
	asl a		; $83F973: 0A
	asl a		; $83F974: 0A
	adc.w #$1000		; $83F975: 69 00 10
	sta.w VMADDL		; $83F978: 8D 16 21
	lda.w #BigFontTiles		; $83F97B: A9 D8 C6
	sta.b tmp0		; $83F97E: 85 73
	lda.w #BigFontTiles>>16		; $83F980: A9 83 00
	sta.b tmp1		; $83F983: 85 75
	jsl.l $86FA3E		; $83F985: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	stz.b a0		; $83F989: 64 33
	lda.w #$007F		; $83F98B: A9 7F 00
	sta.b a0+2		; $83F98E: 85 35
	lda.w #PixelRemap83		; $83F990: A9 D4 FC
	sta.b a1		; $83F993: 85 37
	lda.w #PixelRemap83>>16		; $83F995: A9 82 00
	sta.b a1+2		; $83F998: 85 39
	lda.w #$0064		; $83F99A: A9 64 00
	sta.b d0		; $83F99D: 85 53
	jsl.l $8FE0E4		; $83F99F: 22 E4 E0 8F  bank $8F: remap the 4bpp pixels of the unpacked tiles ([a0] data, [a1] table, d0 tiles)
	lda.w #$872E		; $83F9A3: A9 2E 87
	sta.b a0		; $83F9A6: 85 33
	lda.w #$0088		; $83F9A8: A9 88 00
	sta.b a0+2		; $83F9AB: 85 35
	lda.w #$F55A		; $83F9AD: A9 5A F5
	sta.b a1		; $83F9B0: 85 37
	lda.w #$0087		; $83F9B2: A9 87 00
	sta.b a1+2		; $83F9B5: 85 39
	lda.w #$0004		; $83F9B7: A9 04 00
	sta.b d0		; $83F9BA: 85 53
	jsl.l $8FE0E4		; $83F9BC: 22 E4 E0 8F  bank $8F: remap the 4bpp pixels of the unpacked tiles ([a0] data, [a1] table, d0 tiles)
	lda.b sprclock		; $83F9C0: A5 A7
	adc.w #$003C		; $83F9C2: 69 3C 00
	sta.b sprclock		; $83F9C5: 85 A7
	lda.w #$FFFF		; $83F9C7: A9 FF FF
	sta.b textdirtylo		; $83F9CA: 85 D0
	stz.b textdirtyhi		; $83F9CC: 64 D2
	jsl.l $8F84B5		; $83F9CE: 22 B5 84 8F  bank $8F: 93G SetHor
	jsl.l setvideo		; $83F9D2: 22 5E E3 80
	jmp.w .redraw		; $83F9D6: 4C 0C F9
.go:		;92G .go: Goalie: left/right change tmgoalie (0, 1, none), then Setpersonel
	jsl.l $8FEE4A		; $83F9D9: 22 4A EE 8F  bank $8F
	jsl.l $8FD76B		; $83F9DD: 22 6B D7 8F  bank $8F
	jsl.l $8FEE4A		; $83F9E1: 22 4A EE 8F  bank $8F
	ldy.b a2		; $83F9E5: A4 3B  A or right: next goalie; left: previous; d0 = number of goalies
	lda.b d1		; $83F9E7: A5 57
	bit.w #cbut|JOYRIGHT		; $83F9E9: 89 80 01
	bne .up		; $83F9EC: D0 1C
	bit.w #JOYLEFT		; $83F9EE: 89 00 02
	bne .dn		; $83F9F1: D0 03
	jmp.w .gj		; $83F9F3: 4C 94 F8
.dn:
	lda.w tmgoalie,y		; $83F9F6: B9 F2 13
	bmi .wrap		; $83F9F9: 30 0B
.dec:
	dec a		; $83F9FB: 3A
.set:
	sta.w tmgoalie,y		; $83F9FC: 99 F2 13
	jsl.l setpersonel		; $83F9FF: 22 5A BB 80
	jmp.w .gj		; $83FA03: 4C 94 F8
.wrap:
	lda.b d0		; $83FA06: A5 53
	bra .dec		; $83FA08: 80 F1
.up:
	lda.w tmgoalie,y		; $83FA0A: B9 F2 13
	bmi .z		; $83FA0D: 30 0A
	inc a		; $83FA0F: 1A
	cmp.b d0		; $83FA10: C5 53
	bcc .set		; $83FA12: 90 E8
	lda.w #$FFFF		; $83FA14: A9 FF FF
	bra .set		; $83FA17: 80 E3
.z:
	lda.w #$0000		; $83FA19: A9 00 00
	bra .set		; $83FA1C: 80 DE
.jump:		;92G .jump: Resume Game, Instant Replay, Stats Report, Goalie, Team Roster
	dd PauseResume,.rm,.sr,.go,.ros		; $83FA1E
PauseReadJoy:		;auto: CODE_83FA32. 92G Pausemode .rjoy: wait for a vblank and a new button (not L/R); in demo mode with no controller team the pause ends after pausetimer frames (sets Start)
	jsl.l $8F877D		; $83FA32: 22 7D 87 8F  bank $8F
	bne .force		; $83FA36: D0 32
	jsl.l setvideo		; $83FA38: 22 5E E3 80
	lda.b vcount		; $83FA3C: A5 00
.vb:
	cmp.b vcount		; $83FA3E: C5 00
	beq .vb		; $83FA40: F0 FC
	jsl.l ReadPads		; $83FA42: 22 E8 F3 80  ReadPads; ignore L/R
	lda.w joypad1		; $83FA46: AD 5E 01
	ora.w joypad2		; $83FA49: 0D 60 01
	bit.w #JOYR|JOYL		; $83FA4C: 89 30 00
	bne PauseReadJoy		; $83FA4F: D0 E1
	jsl.l getpzjoy		; $83FA51: 22 0E FF 85  menu sounds and ticker
	jsl.l nullrtl85		; $83FA55: 22 96 FF 85
	lda.w demoflag		; $83FA59: AD D5 08  demo with no controller teams: count down pausetimer
	beq .chk		; $83FA5C: F0 11
	lda.w cont1team		; $83FA5E: AD 96 12
	ora.w cont2team		; $83FA61: 0D 98 12
	bne .chk		; $83FA64: D0 09
	dec.b pausetimer		; $83FA66: C6 EE
	bne .chk		; $83FA68: D0 05
.force:
	lda.w #JOYSTART		; $83FA6A: A9 00 10
	tsb.b d1		; $83FA6D: 04 57
.chk:
	lda.b d1		; $83FA6F: A5 57
	beq PauseReadJoy		; $83FA71: F0 BF
	lda.w #60000		; $83FA73: A9 60 EA
	sta.b pausetimer		; $83FA76: 85 EE
	rtl		; $83FA78: 6B
PauseResume:		;auto: CODE_83FA79. pause menu item 0, Resume Game: A or Start leaves
	lda.b d1		; $83FA79: A5 57
	bit.w #JOYSTART|cbut		; $83FA7B: 89 80 10
	bne PauseLeave		; $83FA7E: D0 03
	jmp.w PauseMenu_gj		; $83FA80: 4C 94 F8
PauseLeave:		;auto: CODE_83FA83. return 0: leave the pause menu
	lda.w #$0000		; $83FA83: A9 00 00
	rtl		; $83FA86: 6B
Restart:		;auto: CODE_83FA87. SNES: restart the game from scratch (93G Begin role): native mode, stack, DP and DB 0, clear RAM $0000-$15FE, the sprite VRAM cache, vbint vb2, hbint HBdefault, then $8FEE83 and far8B8172
	sei		; $83FA87: 78  interrupts off, native mode
	clc		; $83FA88: 18
	xce		; $83FA89: FB
	rep #$30		; $83FA8A: C2 30
	lda.w #$1FFF		; $83FA8C: A9 FF 1F
	tcs		; $83FA8F: 1B
	lda.w #$0000		; $83FA90: A9 00 00
	tcd		; $83FA93: 5B
	sep #$20		; $83FA94: E2 20
	pha		; $83FA96: 48
	plb		; $83FA97: AB
	rep #$30		; $83FA98: C2 30
	jsl.l $8D8120		; $83FA9A: 22 20 81 8D  bank $8D
	ldx.w #$0000		; $83FA9E: A2 00 00
.clr:
	stz.b vcount,x		; $83FAA1: 74 00
	inx		; $83FAA3: E8
	cpx.w #$15FF		; $83FAA4: E0 FF 15
	bne .clr		; $83FAA7: D0 F8
	lda.w #$005C		; $83FAA9: A9 5C 00  jmlvector opcode, sprite slot life 18
	sta.w jmlvector		; $83FAAC: 8D 78 01
	lda.w #$0012		; $83FAAF: A9 12 00
	sta.b sprslotlife		; $83FAB2: 85 C1
	lda.b sprclock		; $83FAB4: A5 A7  free all sprite VRAM slots
	sec		; $83FAB6: 38
	sbc.w #$003C		; $83FAB7: E9 3C 00
	ldx.w #$0000		; $83FABA: A2 00 00
.cache:
	sta.l sprframetime,x		; $83FABD: 9F 00 20 7E
	inx		; $83FAC1: E8
	inx		; $83FAC2: E8
	cpx.w #$4C74		; $83FAC3: E0 74 4C
	bne .cache		; $83FAC6: D0 F5
	ldx.w #$0000		; $83FAC8: A2 00 00
.cache2:
	sta.w sprslottime,x		; $83FACB: 9D AB 04
	inx		; $83FACE: E8
	inx		; $83FACF: E8
	cpx.w #$0400		; $83FAD0: E0 00 04
	bne .cache2		; $83FAD3: D0 F6
	lda.w #$0020		; $83FAD5: A9 20 00
	sta.b sprpriority		; $83FAD8: 85 BB
	lda.w #vb2		; $83FADA: A9 DE 80
	sta.b vbint		; $83FADD: 85 14
	lda.w #HBdefault		; $83FADF: A9 A3 83
	sta.b hbint		; $83FAE2: 85 16
	jsl.l $8FEE83		; $83FAE4: 22 83 EE 8F  bank $8F
	jml.l far8B8172		; $83FAE8: 5C F2 F5 80
RefsMap:		;93G RefsMap: the ref window frames, 7 frames of 8 x 7 words (data/Refs.map); PushRef copies frame d0 (+$70 each)
	incbin "../data/Refs.map"		; $83FAEC-$83FDFB
RefsMapEnd:
	assert RefsMapEnd-RefsMap == 7*$70
assgoalietopuck:		;auto: CODE_83FDFC (asstab $F). 93G assgoalietopuck (logic93_3): goalie skates out to a loose puck (inserted by assgoalie) while the puck moves toward him and the tmnear stats allow it, else assexit
	lda.w pflags,x		; $83FDFC: BD DF 0E  joystick controlled or clock stopped: assexit
	and.w #pfjoycon		; $83FDFF: 29 08 00
	ora.w gmclock		; $83FE02: 0D 8A 12
	beq .chk		; $83FE05: F0 04
	jml.l assexit		; $83FE07: 5C F9 96 80
.chk:
	jsl.l check4bench		; $83FE0B: 22 27 85 80
	lda.w pflags,x		; $83FE0F: BD DF 0E
	bit.w #pfna		; $83FE12: 89 02 00
	beq .nna		; $83FE15: F0 09
	and.w #~pfna&$FFFF		; $83FE17: 29 FD FF
	sta.w pflags,x		; $83FE1A: 9D DF 0E
	stz.w temp1,x		; $83FE1D: 9E 5F 0C
.nna:
	lda.w temp1,x		; $83FE20: BD 5F 0C
	sec		; $83FE23: 38
	sbc.b d7		; $83FE24: E5 6F
	sta.w temp1,x		; $83FE26: 9D 5F 0C
	bpl .go		; $83FE29: 10 6F
	lda.w aidef,x		; $83FE2B: BD BF 0F
	lsr a		; $83FE2E: 4A
	lsr a		; $83FE2F: 4A
	clc		; $83FE30: 18
	adc.w temp1,x		; $83FE31: 7D 5F 0C
	bpl .st		; $83FE34: 10 03
	lda.w #$0000		; $83FE36: A9 00 00
.st:
	sta.w temp1,x		; $83FE39: 9D 5F 0C
	lda.w puckc		; $83FE3C: AD BB 0E  carried puck: assexit
	bmi .pc		; $83FE3F: 30 04
	jml.l assexit		; $83FE41: 5C F9 96 80
.pc:
	lda.w puckvy		; $83FE45: AD 1B 0B  puck moving away from my goal: assexit
	sta.b tmp0		; $83FE48: 85 73
	lda.w pfgoal,x		; $83FE4A: BD 3F 11
	beq .dir		; $83FE4D: F0 08
	lda.b tmp0		; $83FE4F: A5 73
	eor.w #$FFFF		; $83FE51: 49 FF FF
	inc a		; $83FE54: 1A
	sta.b tmp0		; $83FE55: 85 73
.dir:
	lda.b tmp0		; $83FE57: A5 73
	bpl .tm		; $83FE59: 10 04
	jml.l assexit		; $83FE5B: 5C F9 96 80
.tm:
	stz.b a1		; $83FE5F: 64 37  tmnear of my team >= $E10 and of the other >= $640
	lda.w #$0002		; $83FE61: A9 02 00
	sta.b a2		; $83FE64: 85 3B
	lda.w pfteam,x		; $83FE66: BD 9F 11
	beq .t0		; $83FE69: F0 07
	stz.b a2		; $83FE6B: 64 3B
	lda.w #$0002		; $83FE6D: A9 02 00
	sta.b a1		; $83FE70: 85 37
.t0:
	ldy.b a1		; $83FE72: A4 37
	lda.w tmnear,y		; $83FE74: B9 FA 13
	cmp.w #$0E10		; $83FE77: C9 10 0E
	lda.w tmnear+4,y		; $83FE7A: B9 FE 13
	sbc.w #$0000		; $83FE7D: E9 00 00
	bcs .t1		; $83FE80: B0 04
	jml.l assexit		; $83FE82: 5C F9 96 80
.t1:
	ldy.b a2		; $83FE86: A4 3B
	lda.w tmnear,y		; $83FE88: B9 FA 13
	cmp.w #$0640		; $83FE8B: C9 40 06
	lda.w tmnear+4,y		; $83FE8E: B9 FE 13
	sbc.w #$0000		; $83FE91: E9 00 00
	bcs .go		; $83FE94: B0 04
	jml.l assexit		; $83FE96: 5C F9 96 80
.go:		;skatetopuck
	jml.l skatetopuck		; $83FE9A: 5C 2D 8C 80
unusedFF83:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FE9E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FEAE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FEBE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FECE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FEDE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FEEE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FEFE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF0E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF1E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF2E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF3E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF4E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF5E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF6E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF7E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF8E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FF9E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FFAE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FFBE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FFCE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FFDE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $83FFEE
	db $FF,$FF		; $83FFFE
