; The game, screens, menus, password, playoffs.
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8F8213
linelist:		;the line choice names (PrintStringFromList in bank $80): Sc1, Sc2, Chk, Pw1, Pw2, PK1, PK2
	dw 5
	db "Sc1"
	dw 5
	db "Sc2"
	dw 5
	db "Chk"
	dw 5
	db "Pw1"
	dw 5
	db "Pw2"
	dw 5
	db "PK1"
	dw 5
	db "PK2"
PerLabels:		;period names (gsp 0-4); $12-$14 are the "st", "nd", "rd" small font tiles
	dw 4
	db "1",$12
	dw 4
	db "2",$13
	dw 4
	db "3",$14
	dw 4
	db "OT"
	dw 7
	db "Final"

org $8F8B11
clockcont:		;monitor period clock and initiate various clock activated events
		;   SNES: clock at 0: freezewindow, then clockcont_0
	lda.w gmclock
	ora.w gameclock
	bne .rtl
	jsl.l freezewindow
	jmp.w clockcont_0
.rtl:
	rtl
clockcont_0:		;end of period. Also entered from puckfaceoff+2E
		;   SNES: puck pucknorm; third period winners celebrate (assscore, the Stanley Cup in the final), the game clock stops
	ldx.w #$001C
	stx.b a3
	lda.w #$18
	sta.b d0
	jsl.l assinsert
	lda.w gsp
	cmp.w #$0002
	bcs .p3
	jmp.w .notp3
.p3:
	lda.w #$0007
	sta.b d0
	ldx.w #$0000
	stx.b a3
	lda.w gamelevel
	cmp.w #$0003
	bne .winners
	lda.b bosgames
	cmp.w #$0007
	beq .cup
	lda.w gamenum
	asl a
	sta.b a0
	tay
	stz.b d3
	lda.w gsflags,y
	bit.w #$0001
	beq .nf
	lda.w #$0010
	sta.b d3
.nf:
	lda.w tmscore
	cmp.w tmscore+2
	bpl .ns1
	lda.b d3
	eor.w #$0010
	sta.b d3
.ns1:
	lda.b a0
	clc
	adc.b d3
	tay
	lda.w gspotwins,y
	cmp.w #$0003
	bne .winners
.cup:
	lda.w #$0008
	sta.b d0
	lda.w #$000B
	sta.b d2
.cpu:
	lda.w pflags,x
	and.w #$FFF7
	sta.w pflags,x
	inx
	inx
	dec.b d2
	bpl .cpu
	ldx.w #$0000
	stx.b a3
.winners:
	lda.w #$0005
	sta.b d2
	lda.w tmscore
	cmp.w tmscore+2
	beq .notp3
	bpl .celeb
	ldx.w #$000C
	stx.b a3
.celeb:
	lda.w position,x
	beq .next
	jsl.l assinsert
	lda.w #$0007
	sta.b d0
.next:
	inx
	inx
	stx.b a3
	dec.b d2
	bpl .celeb
.gameover:
	jsl.l ClearPenaltyBuffer
	lda.b crowdlevel
	clc
	adc.w #$03E8
	sta.b crowdlevel
	lda.w #$0040
	sta.w gmclock
	tsb.w gmode
	lda.w tmscore
	cmp.w tmscore+2
	bmi .awaywon
	stz.b crowdlevel
	lda.w #$0003
	sta.w cheercnt
	lda.b vcount
	sec
	sbc.w #$0096
	sta.w cheervc
.awaywon:
	lda.w #$0004
	sta.b d0
	jml.l AddPenalty2
.notp3:
	lda.w gsp
	cmp.w #$0003
	bne .perover
	lda.w OptPlayMode
	beq .gameover
.perover:
	lda.w #$0002
	sta.b d0
	jml.l AddPenalty2

org $8F8E03
startpause1:		;pause intiated by cont 1
		;   SNES: pause started by controller 1 (sfpj off), startpause
	lda.w #$0002
	trb.w sflags
	jml.l startpause
PauseExit:		;restore graphics and return from pause mode
		;   SNES: restore textmap (textsave), sflags and the rink, printscores1, setvideo
	stz.w cuetimer
	stz.w crowdvol
	jsl.l forceblack
	phx
	ldx.w #$07FE
.loop:
	lda.l textsave,x
	sta.l textmap,x
	dex
	dex
	bpl .loop
	plx
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	pla
	sta.w sflags
	pla
	sta.w sfhormode
	bne .nonzero
	jsl.l ClrHor
.nonzero:
	lda.w #$0001
	trb.w sflags
	jsl.l printscores1
	jsl.l setvideo
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	rtl
suba4:		;a4 = address in replay buffer of current
		;   SNES: replay a4 one frame back (wrap at ReplayBufferStart unless sfwrap), RestoreReplayFrame; d7 = 0 at the end
	lda.b a4
	cmp.w #ReplayBufferStart
	bne .a4ne
	lda.b a4+2
	cmp.w #ReplayBufferStart>>16
	bne .a4ne
	lda.w sflags
	bit.w #sfwrap
	beq .end
	lda.w #ReplayBufferEnd
	sta.b a4
	lda.w #ReplayBufferEnd>>16
	sta.b a4+2
.a4ne:
	lda.b a4
	sec
	sbc.w #replaysize
	sta.b a4
	lda.b a4+2
	sbc.w #$0000
	sta.b a4+2
	lda.b a4
	cmp.w ReplayBufferPtr
	beq .a4eq
	jml.l RestoreReplayFrame
.a4eq:
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	beq .a4eq2
	jml.l RestoreReplayFrame
.a4eq2:
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	lda.b a4+2
	adc.w #$0000
	sta.b a4+2
.end:
	jsl.l RestoreReplayFrame
	stz.b d7
	rtl
adda4:		;a4 = address in replay buffer of current
		;   SNES: replay a4 one frame on unless it reaches ReplayBufferPtr; d7 = 0 at the end
	stz.b d7
	lda.w sflags
	bit.w #sf2drec
	beq .nosf2drec
	lda.b a4+2
	pha
	lda.b a4
	pha
	jsl.l adda43
	lda.b a4
	sta.b tmp0
	lda.b a4+2
	sta.b tmp1
	pla
	sta.b a4
	pla
	sta.b a4+2
	lda.b tmp0
	cmp.w ReplayBufferPtr
	bne .nosf2drec
	lda.b tmp1
	cmp.w ReplayBufferPtr+2
	bne .nosf2drec
	rtl
.nosf2drec:
	lda.b a4
	cmp.w ReplayBufferPtr
	bne .a4ne
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	bne .a4ne
	rtl
.a4ne:
	jsl.l RestoreReplayFrame
	jml.l adda43

org $8F9073
ResetPassWord:		;copy '-' char into password
		;   SNES: PassWord = 16 blanks ($1E) with bit 7 clear
	sep #$30
	stz.w PassWord
	ldy.b #$0F
	lda.b #$1E
.loop:
	sta.w PassWord,y
	dey
	bne .loop
	rep #$30
	rtl

org $8FD5BF
holdcheck:		;player a2 is in hold animation looking to hold opponent a3. Entered from checkcheck .cc for SPA $CB0 or $12DC
		;   SNES: player X holds a2 (SPAHold/SPAhook), both slow to the average speed; checkagr may call a holding/hooking penalty
	lda.w pfalock,x
	ora.w pf2fight,x
	beq .nopf2fight
	jmp.w .rtl
.nopf2fight:
	lda.w position,x
	bne .position
	jmp.w .rtl
.position:
	ldy.b a2
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcc .lt
	jmp.w .rtl
.lt:
	lda.w puckc
	asl a
	cmp.b a3
	bne .nopc
	lda.w #$0008
	trb.w sflags
.nopc:
	ldy.b a2
	lda.w Xvel,x
	clc
	adc.w Xvel,y
	pha
	asl a
	pla
	ror a
	sta.w Xvel,x
	sta.w Xvel,y
	lda.w Yvel,x
	clc
	adc.w Yvel,y
	pha
	asl a
	pla
	ror a
	sta.w Yvel,x
	sta.w Yvel,y
	lda.w #$0C60
	sta.b d1
	sta.w pfalock,x
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$0C2E
	sta.b d1
	sta.w pfalock,x
	lda.w SPA,x
	cmp.w #$0BFC
	beq .h2
	lda.w #$1386
	sta.b d1
.h2:
	jsl.l SetSPA
	jsl.l checkagr
	lda.b d0
	cmp.w #$0007
	bcs .ex
	lda.w #$0024
	sta.b d0
	lda.w SPA,x
	cmp.w #$0C2E
	beq .pen
	lda.w #$001E
	sta.b d0
.pen:
	jsl.l AddPenalty
.ex:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$FFFF
	sta.b collflag
.rtl:
	rtl

org $8FDA75
InitScoutDisplay:		;SNES: scouting report scroll state reset; a0 = TestList (the text buffer)
	lda.w #$FFFF
	sta.w VertLineScrolling
	sta.w PlayerScrollCtr
	stz.w SelectedPlayerIdx
	stz.w ScoutingReportTimer
	lda.w #TestList&$FFFF
	sta.b a0
	lda.w #TestList>>16
	sta.b a0+2
	rtl

org $8FDBDB
box:		;fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser).
		;   SNES: erase the 19 x 9 box at x 11, y 2
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$0B,$02
	lda.w #$0013
	sta.b d0
	lda.w #$0009
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser
UpdateCwdExcite:		;called once per second. Track peak and running total of crowd
		;   SNES: nothing on the SNES
	rtl
CheckLateGameSong:		;called once per second. 3rd period: play tune $32 once at the random
		;   SNES: nothing on the SNES
	rtl

org $8FDC0D
ScoutingReport:		;pregame scouting report
		;   SNES: the scouting report screen: EASN backdrop, both team blocks, ScoutLabels with both teams' ratings, Ron Barr and
		;   the scrolling text until Start
	jsl.l ClearTeamStats
	jsl.l forceblack
	jsl.l InitPPU
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
	stz.w tmgoalie
	stz.w tmgoalie+2
	lda.w #$0025
	sta.w blankchar
	inc a
	sta.w scorechars
	clc
	adc.w #$0195
	sta.w smallfontchars
	adc.w #$0064
	sta.w Framercset
	adc.w #$0004
	sta.w ronbarrchars
	stz.w charofs
	stz.w charofs2
	lda.w blankchar
	ldx.w #$07FE
.loop:
	sta.l textmap,x
	dex
	dex
	bpl .loop
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$03FE
.loop2:
	lda.l TestList,x
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .loop2
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.loop3:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .loop3
	ldx.w #$0010
.loop4:
	stz.w VMDATAL
	dex
	bne .loop4
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.loop5:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .loop5
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.loop6:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0C80
	bne .loop6
	ldx.w #$0000
.loop7:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .loop7
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$06,$03
	lda.w #$0019
	sta.b d0
	lda.w #$0009
	sta.b d1
	jsl.l Framer
	lda.w #RonBarrMap
	sta.b tmp0
	lda.w #RonBarrMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.loop8:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .loop8
	rep #$30
	ldx.w #$0000
.loop9:
	lda.l TestList+$190,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$07A0
	bne .loop9
	stz.b tmp1
.loop10:
	stz.b tmp0
.loop11:
	lda.b tmp1
	sta.b mula
	lda.w #$0008
	sta.b mulb
	jsl.l mulu16
	adc.b tmp0
	asl a
	tax
	lda.l TestList,x
	adc.w ronbarrchars
	pha
	lda.b tmp1
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.b tmp0
	asl a
	tax
	pla
	sta.l backmap+$44,x
	inc.b tmp0
	lda.b tmp0
	cmp.w #$0008
	bne .loop11
	inc.b tmp1
	lda.b tmp1
	cmp.w #$0009
	bne .loop10
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$0D
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$15,$0D
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$11,$0F
	lda.w #ScoutLabels
	sta.b a1
	lda.w #ScoutLabels>>16
	sta.b a1+2
.loop12:
	lda.b [a1]
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0011
	sta.w printx
	jsl.l print
	inc.w printy
	ldy.w #$0002
	lda.b [a1],y
	bit.w #$0080
	beq .loop12
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$19,$0F
	lda.w tmdata
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	sta.b a2+2
	lda.w tmdata+2
	sta.b a2
	ldy.w #ScoutReport
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	lda.b [a2],y
	adc.b a2
	sta.b a2
	jsl.l ScoutCompare
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$04,$0F
	lda.b a0
	ldx.b a2
	sta.b a2
	stx.b a0
	jsl.l ScoutCompare
	jsl.l InitScoutDisplay
	lda.w #$001A
	sta.b [a0]
	inc.b a0
	inc.b a0
	inc a
	sta.b [a0]
	inc.b a0
	inc.b a0
	inc a
	inc a
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w HomeTeam
	sta.b d0
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$001D
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w VisTeam
	cmp.b d0
	beq .VisTeameq
	sta.b [a0]
	inc.b a0
	inc.b a0
.VisTeameq:
	lda.w #$001D
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec a
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$FFFF
	sta.b [a0]
	stz.w asv
	lda.w #$7FFF
	sta.w screentimer
.loop13:
	lda.w #textmap
	sta.w DMAList
	lda.w #textmap>>16
	sta.w DMAList+dmabank
	lda.w #$1000
	sta.w DMAList+dmalen
	stz.w DMAList+dmavram
	lda.w #$0007
	sta.b DMAListend
	lda.w #VBlank_List
	sta.b vbint
.loop14:
	cmp.b vbint
	beq .loop14
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	bit.w #$1000
	bne .rtl
	bit.w #$0400
	beq .zero
	lda.w #$FFFF
	sta.w asv
.zero:
	jsl.l UpdateScoutingDisplay
	dec.w screentimer
	bpl .loop13
.rtl:
	rtl
ScoutCompare:		;SNES: print the scouting ratings of team [a0] (nibbles of .sr, against [a2] for the advantages) down the screen
	ldy.w #$0004
	lda.b [a0],y
	xba
	sta.b d5+2
	iny
	iny
	lda.b [a0],y
	xba
	sta.b d5
	lda.w #$0007
	sta.b d6
.loop:
	ldy.w #$0004
.loop2:
	asl.b d5
	rol.b d5+2
	lda.b d5
	adc.w #$0000
	sta.b d5
	dey
	bne .loop2
	lda.b d5
	and.w #$000F
	sta.b d0
	jsl.l .skip2
	lda.b d6
	cmp.w #$0001
	bne .d6ne
	jsl.l .skip
.d6ne:
	dec.b d6
	bpl .loop
	rtl
.skip:
	lda.b [a0]
	xba
	and.w #$000F
	sta.b d0
	lda.b [a2]
	xba
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.b d0
	sta.b d0
	jsl.l .skip2
	lda.w printx
	cmp.w #$0010
	bcc .printxlt
	ldy.w #$0002
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
	lda.b [a2],y
	and.w #$000F
	clc
	adc.b d0
	sta.b d0
.skip2:
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWidth
	lda.w printx
	pha
	jsl.l print
	pla
	sta.w printx
.printxlt:
	inc.w printy
	rtl
ScoutLabels:		;scouting labels: the rating names of the scouting report; a $FF string ends the list
	dw 10
	db "Shooting"
	dw 9
	db "Skating"
	dw 9
	db "Passing"
	dw 9
	db "Defense"
	dw 10
	db "Checking"
	dw 10
	db "Fighting"
	dw 13
	db "Goalkeeping"
	dw 17
	db "Power Play Adv."
	dw 25
	db "-    Home Team Adv.    "
	dw 9
	db "Overall"
	dw 3
	db $FF
PuckcSpots:		;asspuckc spots: x, y of spot d0 (6 + temp3, or position when offsides)
	dw -100,-20
	dw 100,-20
	dw -120,40
	dw 20,40
	dw 120,40
	dw -20,40
	dw -40,240
	dw 0,220
	dw 20,230
	dw 30,230

org $8FE32B
DefaultMenus:		;set default menu choices for beginning of game. Called once from Begin.
		;   SNES: the 7 options at $1600 from .tab; notdemo set
	lda.w #$FFFF
	sta.w notdemo
	lda.w #OptPlayMode
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #.tab
	sta.b a1
	lda.w #.tab>>16
	sta.b a1+2
	lda.w #$0006
	sta.b d0
.loop:
	lda.b [a1]
	inc.b a1
	inc.b a1
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .loop
	rtl
.tab:		;OptPlayMode, OptPlayers, OptTeam1, OptTeam2, OptPerlen, OptPen, OptLine
	dw $0000,$0001,$000F,$0003,$0001,$0000,$0001
checkagr:		;penalty roll for player a3. Range = (20 - byte $73) * 13, doubled for a joystick player, halved within $28 of the puck in x and y. Return d0 = randomd0 of that range; the callers
		;   call a penalty when it is small. Called from checkcheck .cc, holdcheck and Bcheck
		;   SNES: d0 = random value by the GGSleft rating of player X (x2 joystick controlled, /2 near the puck): small values call a penalty
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	asl a
	asl a
	asl a
	asl a
	sta.b d0
	lda.w pflags,x
	bit.w #$0008
	beq .nopflags
	asl.b d0
.nopflags:
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .zero
	eor.w #$FFFF
	inc a
.zero:
	cmp.w #$0029
	bcs .gorandomd0
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .zero2
	eor.w #$FFFF
	inc a
.zero2:
	cmp.w #$0029
	bcs .gorandomd0
	lsr.b d0
.gorandomd0:
	jml.l randomd0

org $8FE825
TeamRoster:		;SNES Team Roster screen: the team block, each line's players and an attribute; dpad moves, Y switches team, Start leaves
	jsl.l forceblack
	sep #$20
	stz.w BG1HOFS
	stz.w BG1HOFS
	stz.w BG1VOFS
	stz.w BG1VOFS
	stz.w BG2HOFS
	stz.w BG2HOFS
	stz.w BG2VOFS
	stz.w BG2VOFS
	lda.b #$00
	sta.w BG1SC
	lda.b #$04
	sta.w BG2SC
	lda.b #$44
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2
	sta.w TM
	rep #$30
	lda.w #$FD00
	sta.w charofs
	sta.w charofs2
	sta.w printfontset
	stz.b printm
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
	lda.w #PixelRemap8F
	sta.b a1
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles
	ldx.w #$0000
.loop:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .loop
	lda.w scorechars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.loop2:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .loop2
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.loop3:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .loop3
	ldx.w #$03FE
.loop4:
	lda.l TestList,x
	clc
	adc.w ExtraChars
	clc
	adc.w charofs2
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .loop4
	lda.w #RonBarrMap
	sta.b tmp0
	lda.w #RonBarrMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.loop5:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .loop5
	rep #$30
	stz.b a2
	lda.w cont1team
	sta.b tmp0
	lda.w sflags
	bit.w #$0002
	beq .nosflags
	lda.w cont2team
	sta.b tmp0
.nosflags:
	lda.b tmp0
	cmp.w #$0002
	bne .tmp0ne
	lda.w #$0002
	sta.b a2
.tmp0ne:
	ldy.b a2
	lda.w tmline,y
	inc a
	sta.b d0
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
.loop6:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$03,$01
	lda.w #$001A
	sta.b d0
	lda.w #$0006
	sta.b d1
	jsl.l Framer
	lda.w blankchar
	clc
	adc.w charofs
	ldx.w #$07FE
.loop7:
	sta.l textmap,x
	dex
	dex
	bpl .loop7
	jsl.l printbigz
	dw $0014		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$04,"Team  Roster",$BF,$0B,$01
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .noa2
	lda.w VisTeam
	sta.b d1
	lda.w #$0030
.noa2:
	sta.b d0
	jsl.l DrawTeamBlocks
	jsl.l printz
	dw $0017		; printz inline string: length (counts itself), then control bytes / text
	db $9F,$08,$0C,"Player",$9F,$18,$0C,"Rating",$BE,$01,$08
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$10,$08
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	jsl.l .show
.loop8:
	lda.w #textmap
	sta.w DMAList
	lda.w #textmap>>16
	sta.w DMAList+dmabank
	lda.w #$1000
	sta.w DMAList+dmalen
	stz.w DMAList+dmavram
	lda.w #$0007
	sta.b DMAListend
	lda.w #VBlank_List
	sta.b vbint
.loop9:
	cmp.b vbint
	beq .loop9
	jsl.l ReadPads
	jsl.l getpzjoy
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	beq .nod1
	jmp.w .rtl
.nod1:
	bit.w #$4000
	bne .nonzero3
	stz.b d0
	inc.b d0
	bit.w #$0100
	bne .nonzero2
	dec.b d0
	dec.b d0
	bit.w #$0200
	bne .nonzero2
	bit.w #$0800
	bne .nonzero
	inc.b d0
	inc.b d0
	bit.w #$0400
	beq .loop10
.nonzero:
	lda.b d0
	clc
	adc.w SelectedPlayerIdx
	sta.b d0
	bmi .loop10
	cmp.w #$0008
	bcs .loop10
	sta.w SelectedPlayerIdx
	jsl.l .show
.loop10:
	jmp.w .loop8
.nonzero2:
	lda.b d0
	clc
	adc.w DispAttribCtr
	sta.b d0
	bmi .loop10
	sta.w DispAttribCtr
	jsl.l .show
	bra .loop10
.nonzero3:
	lda.b a2
	eor.w #$0002
	sta.b a2
	jmp.w .loop6
.show:		;print the selected line and attribute column
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $9F,$02,$09
	lda.w SelectedPlayerIdx
	sta.b d0
	lda.w #RosterLineNames
	sta.b a1
	lda.w #RosterLineNames>>16
	sta.b a1+2
	jsl.l AdvanceStringPtr
	jsl.l print
	lda.w #$0011
	sta.w printx
	lda.w #$0009
	sta.w printy
.loop11:
	lda.w #AttribMenuSkater
	sta.b a1
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w DispAttribCtr
	sta.b d0
	lda.w SelectedPlayerIdx
	bne .SelectedPlayerIdx
	lda.w #AttribMenuGoalie
	sta.b a1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	bra .SelectedPlayerIdx
.loop12:
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.SelectedPlayerIdx:
	lda.b [a1]
	bmi .neg
	dec.b d0
	bpl .loop12
.neg:
	lda.b [a1]
	bpl .pos
	dec.w DispAttribCtr
	bra .loop11
.pos:
	jsl.l print
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
	lda.b [a1],y
	sta.b d4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0D
	lda.w #$0020
	sta.b d0
	lda.w #$0013
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jsl.l printz
	dw $0018		; printz inline string: length (counts itself), then control bytes / text
	db $9F,$08,$1A,"Y - Switch Teams",$BF,$00,$0E
	jsl.l GoalieCount
	lda.b d0
	dec a
	sta.b d1
	lda.w #RosterG
	sta.b a4+4
	lda.w #RosterG>>16
	sta.b a4+6
	lda.w #RosterGoalies
	sta.b a3
	lda.w #RosterGoalies>>16
	sta.b a3+2
	lda.w SelectedPlayerIdx
	dec a
	sta.b d0
	bmi .loop13
	asl a
	asl a
	asl a
	sta.b d0
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #LineSets
	clc
	adc.b [a3],y
	sec
	adc.b d0
	sta.b a3
	lda.w #PositionNames
	sta.b a4+4
	lda.w #PositionNames>>16
	sta.b a4+6
	lda.w #$0004
	sta.b d1
	lda.w SelectedPlayerIdx
	sec
	sbc.w #$0005
	beq .loop13
	bmi .neg2
	bvc .vc
	bra .loop13
.neg2:
	bvc .loop13
.vc:
	dec.b d1
.loop13:
	lda.w #$0002
	sta.w printx
	lda.b a4+4
	sta.b a1
	lda.b a4+6
	sta.b a1+2
	jsl.l print
	lda.b a1
	sta.b a4+4
	lda.b a1+2
	sta.b a4+6
	lda.w #$0005
	sta.w printx
	lda.b [a3]
	inc.b a3
	and.w #$00FF
	dec a
	sta.b d0
	jsl.l GetNameandAttrib
	inc.w printy
	inc.w printy
	dec.b d1
	bpl .loop13
.rtl:
	rtl
RosterGoalies:		;SNES: the goalie row numbers of the Team Roster screen
	db 1,2,3,4
RosterG:		;SNES: the "G" position label of the goalie rows
	dw 3
	db "G"
	dw 3
	db "G"
	dw 3
	db "G"
	dw 3
	db "G"
RosterLineNames:		;SNES: the Team Roster line names (15-byte strings)
	dw 15
	db "  Goalies   }"
	dw 15
	db "{Scoring  1 }"
	dw 15
	db "{Scoring  2 }"
	dw 15
	db "{ Checking  }"
	dw 15
	db "{Pwr. Play 1}"
	dw 15
	db "{Pwr. Play 2}"
	dw 15
	db "{Pen. Kill 1}"
	dw 15
	db "{Pen. Kill 2 "

org $8FECAB
Pmenu:		;the 5 pause menu items (.mlist, game-over list when gsp = 4), item psitem highlighted
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$06,$0D
	stz.b d0
	lda.w #.mlist
	sta.b a0
	lda.w #.mlist>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0004
	bne .loop
	lda.w #.mlist2
	sta.b a0
.loop:
	lda.w #$2400
	sta.w printa
	lda.b d0
	cmp.w psitem
	bne .d0ne
	lda.w #$2000
	sta.w printa
.d0ne:
	lda.w #$0006
	sta.w printx
	jsl.l printz
	dw $0016		; printz inline string: length (counts itself), then control bytes / text
	db "                    "
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	ldy.w #$001E
.loop2:
	lda.b [a0],y
	sta.b [a1],y
	dey
	dey
	bpl .loop2
	jsl.l .goalie
	lda.b [a1]
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0011
	sta.w printx
	jsl.l print
	inc.w printy
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	inc.b d0
	lda.b d0
	cmp.w #$0005
	bne .loop
	rtl
.goalie:		;item 3: append the name of the goalie on the ice (or NONE)
	lda.b d0
	cmp.w #$0003
	beq .d0eq
	jmp.w .rtl
.d0eq:
	jsl.l GetPadTeam
	ldy.b a2
	lda.w tmgoalie,y
	bmi .tmgoalieneg
	sta.b tmp0
	lda.w tmdata,y
	sta.b a4
	lda.w #TeamList>>16
	sta.b a4+2
	ldy.w #Playerdata
	lda.b [a4],y
	clc
	adc.b a4
	sta.b a4
.loop3:
	dec.b tmp0
	bmi .tmp0neg
	lda.b [a4]
	clc
	adc.b a4
	adc.w #$0008
	sta.b a4
	bra .loop3
.tmp0neg:
	ldy.w #$0001
.loop4:
	iny
	lda.b [a4],y
	and.w #$00FF
	cmp.w #$0020
	bne .loop4
.loop5:
	iny
	tya
	cmp.b [a4]
	beq .rtl
	lda.b [a4],y
	phy
	ldy.w mesarea
	sta.w mesarea,y
	inc.w mesarea
	ply
	bra .loop5
.rtl:
	rtl
.tmgoalieneg:
	ldy.w mesarea
	lda.w #$004E
	sta.w mesarea,y
	lda.w #$004F
	sta.w mesarea+1,y
	lda.w #$004E
	sta.w mesarea+2,y
	lda.w #$0045
	sta.w mesarea+3,y
	inc.w mesarea
	inc.w mesarea
	inc.w mesarea
	inc.w mesarea
	rtl
.mlist:		;the pause menu items
	dw 13
	db "Resume Game"
	dw 16
	db "Instant Replay"
	dw 14
	db "Stats Report"
	dw 11
	db "Goalie - "
	dw 13
	db "Team Roster"
.mlist2:		;SNES: the menu items after the game (Exit Game first)
	dw 11
	db "Exit Game"
	dw 16
	db "Instant Replay"
	dw 14
	db "Stats Report"
	dw 11
	db "Goalie - "
	dw 13
	db "Team Roster"
GetPadTeam:		;SNES: a2 = team of the controller that paused (cont1team/cont2team by sfpj)
	stz.b a2
	lda.w cont1team
	beq .rtl
	lda.w sflags
	bit.w #$0002
	beq .nosflags
	lda.w cont2team
	bra .join
.nosflags:
	lda.w cont1team
.join:
	cmp.w #$0001
	beq .rtl
	inc.b a2
	inc.b a2
.rtl:
	rtl
setpde:		;d1 = rostnum of player * 2, a2 = team struct
		;   SNES: tmpde of player d1 (team a2) = d0 (not below 0)
	lda.b a2
	beq .noa2
	lda.w #$0034
.noa2:
	clc
	adc.b d1
	tay
	lda.b d0
	bpl .d0pos
	lda.w #$0000
	sta.b d0
.d0pos:
	sta.w tmpde,y
	rtl
setoptions:		;options screen display and input. Called from PeriodOver.
		;   SNES: the options screen: GameSetupMap backdrop, small font and Framer tiles (remapped), NHLPA logo, team blocks; Up/Down
		;   picks a line (.nms), Left/Right changes it (.IncItem), Start goes to maketree; after $12C0 idle frames a demo with random teams
	lda.w #vb2_blank
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	lda.b sprclock
	sec
	sbc.w #$003C
	ldx.w #$0000
.loop:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .loop
	ldx.w #$0000
.loop2:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .loop2
	stz.b DMAListend
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	rep #$30
	lda.b vcount
.loop3:
	cmp.b vcount
	beq .loop3
	jsl.l InitPPU
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
	lda.b #TM_BG1|TM_BG2|TM_OBJ
	sta.w TM
	rep #$30
	stz.w printfontset
	stz.w charofs
	stz.w charofs2
	lda.w #$0012
	sta.w blankchar
	inc a
	sta.w smallfontchars
	clc
	adc.w #$0064
	sta.w Framercset
	adc.w #$0004
	sta.w logochars
	adc.w #$0035
	sta.w scorechars
	jsl.l DrawGameSetupBack
	lda.w #GameSetupMap
	sta.b tmp0
	lda.w #GameSetupMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.loop4:
	lda.l TestList+$800,x
	sta.l palbuffer,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .loop4
	ldx.w #$0000
.loop5:
	lda.l RinkPalette,x
	sta.l palbuffer+$100,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .loop5
	rep #$30
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.loop6:
	lda.l TestList+$900,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0240
	bne .loop6
	ldx.w #$0010
.loop7:
	stz.w VMDATAL
	dex
	bne .loop7
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #unpackbuf&$FFFF
	sta.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemapFont
	sta.b a1
	lda.w #PixelRemapFont>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles
	lda.w #FramerTiles
	sta.b a0
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #PixelRemapFramer
	sta.b a1
	lda.w #PixelRemapFramer>>16
	sta.b a1+2
	lda.w #$0004
	sta.b d0
	jsl.l RemapTiles
	lda.w #NHLPALogo
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.loop8:
	lda.l TestList+$1A0,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06A0
	bne .loop8
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.loop9:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .loop9
	jsl.l ReadPads
	jsl.l Readjoy12
	lda.w #$0000
	sta.b sprpriority
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$00,$00
	jsl.l InitSortObjects
	lda.w #$0028
	sta.w OldXpos
	sta.w OldXpos+$C
	lda.w #.text
	sta.b a1
	lda.w #.text>>16
	sta.b a1+2
.textlp:		;print the .text lines until a 0 byte
	jsl.l print
	ldy.w #$0002
	lda.b [a1],y
	and.w #$00FF
	bne .textlp
	lda.w #$FFFF
	sta.w notdemo
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .OptPlayModelt
	jsl.l NewPO
.OptPlayModelt:
	stz.b d7
	stz.b d0
	jsl.l .nms
	jsl.l .ps
	jsl.l ReadPads
	jsl.l StartSong6
	lda.w #$0001
	sta.b fadein
.idle:		;restart the idle count (d6 = $12C0 frames until the demo)
	lda.w #$12C0
	sta.b d6
.frame:		;one frame: seed counts up while waiting for VBlank_SprPal to run
	inc.w seed
	bne .seed
	inc.w seed+2
.seed:
	lda.b vbint
	cmp.w #VBlank_SprPal		; VBlank_SprPal not run yet?
	beq .frame
	jsl.l ReadPads
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	jsl.l ClearSprites
	jsl.l ScoutPlayersRun
	jsl.l Readjoy1
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bne .input
	jsl.l Readjoy2
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bne .input
	jsl.l QueueTextDMA
	lda.b DMAListend
	bne .DMAListend
	jsl.l QueueBackmapDMA
.DMAListend:
	lda.w #VBlank_SprPal
	sta.b vbint
	dec.b d6
	bpl .frame
	lda.w #$001A		; demo: random teams, both computer
	jsl.l randoma
	sta.w OptTeam1
	sta.w HomeTeam
.loop10:
	lda.w #$001A
	jsl.l randoma
	cmp.w OptTeam1
	beq .loop10
	sta.w OptTeam2
	sta.w VisTeam
	stz.w notdemo
	stz.w OptPlayMode
	stz.w OptPlayers
.start:		;Start, or the demo: pojoy from OptPlayers, the password in Cont. Playoffs, then maketree
	lda.w OptPlayers
	sec
	sbc.w #$0005
	sta.w pojoy
	lda.w OptPlayMode
	cmp.w #$0001
	bne .OptPlayModene
	jsl.l GetPassWord
.OptPlayModene:
	lda.w #$0080
	tsb.w PassWord
	jml.l maketree
.input:		;a pad pressed (d1): Start, Up/Down (.nms by 2), Left/Right (.IncItem by 1)
	lda.b d1
	bit.w #$1000
	bne .start
	bit.w #$0400
	beq .zero
	lda.w #$0002
	sta.b d0
	jsl.l .nms
	jsl.l .ps
	jmp.w .idle
.zero:
	bit.w #$0800
	beq .zero2
	lda.w #$FFFE
	sta.b d0
	jsl.l .nms
	jsl.l .ps
.loop11:
	jmp.w .idle
.zero2:
	lda.w #$0001
	sta.b d2
	lda.b d1
	bit.w #$0100
	bne .d1
	bit.w #$0200
	beq .loop11
	lda.w #$FFFF
	sta.b d2
.d1:
	jsl.l .IncItem
	jsl.l .ps
	jmp.w .idle
.IncItem:		;add d2 to option d7 (OptPlayMode + d7) within .pslim (d2 = 0: just limit it). Players is fixed to One outside Regular Season; Team 1 has $18 choices in the playoffs; a new
		;   mode or Team 1 in the playoffs restarts them (NewPO)
	lda.w #OptPlayMode
	sta.b a2
	lda.w #$0000
	sta.b a2+2
	lda.w #.pslim
	sta.b a3
	lda.w #.pslim>>16
	sta.b a3+2
	stz.b d5
	ldy.b d7
	lda.b [a3],y
	sta.b d4
	lda.b [a2],y
	sta.b d3
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .OptPlayModelt2
	cpy.w #$0004
	bne .OptPlayModelt2
	lda.w #$0018
	sta.b d4
.OptPlayModelt2:
	cpy.w #$0002
	bne .ne
	lda.w #$0005
	sta.b d5
	lda.w OptPlayMode
	bne .ne
	stz.b d5
	lda.w #$0005
	sta.b d4
.ne:
	jsl.l .iilimit		; d3 = the new value
	lda.b d3
	sta.b [a2],y
	lda.b d2
	beq .rts
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .rts
	tya
	bne .nonzero
	jml.l NewPO
.nonzero:
	cpy.w #$0004
	bne .rts
	jml.l NewPO
.rts:
	rtl
.iilimit:		;d3 + d2, wrapped into d5 ... d4-1
	lda.b d3
	clc
	adc.b d2
	sta.b d3
	sec
	sbc.b d5
	bmi .neg
	bvs .vs
	bra .join
.neg:
	bvs .join
.vs:
	lda.b d4
	dec a
	sta.b d3
.join:
	lda.b d3
	sec
	sbc.b d4
	bmi .d3neg
	bvc .vc
	bra .rts
.d3neg:
	bvc .rts
.vc:
	lda.b d5
	sta.b d3
	rtl
.ps:		;print the choices of all 7 lines (.psd), then PrintTeamNames
	lda.b d7
	sta.b d6
	lda.w #$FFFE
	sta.b d7
.psloop:
	inc.b d7
	inc.b d7
	stz.b d2
	jsl.l .IncItem
	jsl.l .psd
	lda.b d7
	cmp.w #$000C
	bne .psloop
	lda.b d6
	sta.b d7
	jml.l PrintTeamNames
.psd:		;print the choice of line d7 at x $11 (14 chars erased first): string d3 of its .pl list; the team lines print the team name (.psdtp)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$11,$0D
	lda.w printy
	clc
	adc.b d7
	sta.w printy
	lda.w #$000E
	sta.b d0
	lda.w #$0001
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	dec.w printy
	lda.w #$0011
	sta.w printx
	ldy.b d7
	cpy.w #$0004
	beq .psdtp
	cpy.w #$0006
	beq .psdtp
	lda.w #OptPlayMode
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.b [a0],y
	sta.b d3
	lda.w #.pl>>16
	sta.b a0+2
	lda.w #.pl
	sta.b a0
	clc
	adc.b [a0],y
	sta.b a0
.psd3:		;step to string d3
	lda.b a0+2
	sta.b a1+2
	lda.b a0
	sta.b a1
	clc
	adc.b [a0]
	sta.b a0
	dec.b d3
	bpl .psd3
	jml.l print
.psdtp:		;team line: the name of team d3 from its bank $83 team record, or .playoffs in Cont. Playoffs
	ldy.b d7
	lda.w #OptPlayMode
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b [a1],y
	sta.b d3
	asl a
	asl a
	tay
	lda.w #TeamList
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b [a1],y
	sta.b a1
	ldy.w #Teamname
	clc
	adc.b [a1],y
	sta.b a1
	lda.w OptPlayMode
	cmp.w #$0001
	bne .goprint
	lda.w #.playoffs
	sta.b a1
	lda.w #.playoffs>>16
	sta.b a1+2
.goprint:
	jml.l print
.playoffs:		;the Team 1 / Team 2 choice in Cont. Playoffs
	dw 10
	db "Playoffs"
.nms:		;move to line d7 + d0 (0..$C), skipping the lines fixed in this mode (Players in the playoffs, lines 1-3 in Cont. Playoffs, Team 2 in the playoffs), then move the frame from line d3
		;   to d7
	lda.b d7
	sta.b d3
.nms0:
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	bpl .nms1
	stz.b d7
.nms1:
	lda.b d7
	cmp.w #$000E
	bcc .nms2
	lda.b d7
	sbc.b d0
	sta.b d7
.nms2:
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .OptPlayModelt3
	cmp.w #$0004
	bcs .OptPlayModelt3
	lda.b d7
	cmp.w #$0002
	beq .nms0
.OptPlayModelt3:
	lda.w OptPlayMode
	cmp.w #$0001
	bne .OptPlayModene2
	lda.b d7
	beq .OptPlayModene2
	cmp.w #$0007
	bcc .nms0
.OptPlayModene2:
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .nms4
	lda.b d7
	cmp.w #$0006
	beq .nms0
.nms4:		;erase the old frame, draw the new one
	jsl.l .setrect
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	lda.b d7
	sta.b d3
	jsl.l .setrect
	jml.l Framer
.setrect:		;printx $10, printy $C + d3, frame size d0 x d1 = $10 x 3 (5 tall for Team 1 in the new playoffs)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$10,$0C
	lda.w printy
	clc
	adc.b d3
	sta.w printy
	lda.w #$0010
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.w OptPlayMode
	cmp.w #$0002
	bcs .OptPlayModege
	jmp.w .rts
.OptPlayModege:
	lda.b d3
	cmp.w #$0004
	beq .d3eq
	jmp.w .rts
.d3eq:
	lda.w #$0005
	sta.b d1
	rtl
	dw 0
.pslim:		;choices of each line (Play Mode, Players, Team 1, Team 2, Per. Length, Penalties, Line Changes)
	dw $4,$6,$1A,$1A,$3,$3,$2
.pl:		;offsets from .pl of the choice strings of each line
	dw .pl0-.pl
	dw .pl1-.pl
	dw .pl2-.pl
	dw .pl3-.pl
	dw .pl4-.pl
	dw .pl5-.pl
	dw .pl6-.pl
.pl0:		;Play Mode
	dw 16
	db "Regular Season"
	dw 16
	db "Cont. Playoffs"
	dw 14
	db "New Playoffs"
	dw 11
	db "Best of 7"
.pl1:		;Players (the last, One, is the only choice in the playoffs)
	dw 6
	db "Demo"
	dw 12
	db "One - Home"
	dw 15
	db "One - Visitor"
	dw 11
	db "Teammates"
	dw 14
	db "Head to Head"
	dw 5
	db "One"
.pl2:		;Team 1 and Team 2 (not used: .psdtp prints team names), Per. Length (30 Seconds is beyond .pslim)
.pl3:
.pl4:
	dw 11
	db "5 Minutes"
	dw 12
	db "10 Minutes"
	dw 12
	db "20 Minutes"
	dw 12
	db "30 Seconds"
.pl5:		;Penalties
	dw 15
	db "Only Fighting"
	dw 4
	db "On"
	dw 16
	db "On, No Offside"
.pl6:		;Line Changes
	dw 4
	db "On"
	dw 5
	db "Off"
.text:		;the line names
	dw 14
	db $FE,$03,$0D,"Play Mode"
	dw 12
	db $FE,$03,$0F,"Players"
	dw 11
	db $FE,$03,$11,"Team 1"
	dw 11
	db $FE,$03,$13,"Team 2"
	dw 16
	db $FE,$03,$15,"Per. Length"
	dw 14
	db $FE,$03,$17,"Penalties"
	dw 17
	db $FE,$03,$19,"Line Changes"
	dw 3		; end (a 0 byte)
	db 0

org $8FF741
CheckInjury:		;called once per second. Count down InjCntDown, act on it at zero
		;   SNES: once a second: count InjCntDown down; at zero ShowInjuryBox
	dec.w InjCntDown
	bne .rtl
	jmp.w ShowInjuryBox
.rtl:
	rtl
setInjuryType:		;sets period injury. a2 = player injured, a3 = player checking. Marks a2 unavailable, pumps up the crowd, plays sfx $D, locks the scroll on a2, sets TempPlOffset (pnum, bit
		;   15 set for the away team) and puts $FFFD (injured for the period) in a2's tmpdst. Called from FallDown and from chkhit .fall
		;   SNES: player a2 is injured: pflags bit $1000, crowdlevel + $12C, sfx $8C, the scroll locked on him (xc1/yc1, sflags $40), TempPlOffset
		;   = pnum (| $8000 for the visitors), his tmpdst = $FFFD (out for the period)
	ldy.b a2
	lda.w pflags,y
	ora.w #$1000
	sta.w pflags,y
	lda.b crowdlevel
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w #$008C
	pha
	jsl.l sfx
	ldy.b a2
	lda.w Xpos,y
	sta.w xc1
	lda.w Ypos,y
	sta.w yc1
	lda.w #$0040
	tsb.w sflags
	stz.b d1
	stz.b a0
	lda.w pfteam,y
	beq .nopfteam
	lda.w #$8000
	sta.b d1
	lda.w #$0002
	sta.b a0
.nopfteam:
	lda.w pnum,y
	and.w #$00FF
	ora.b d1
	sta.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .zero
	ora.w #$FF00
.zero:
	asl a
	sta.b d1
	lda.b a0
	beq .noa0
	lda.w #$0034
.noa0:
	adc.b d1
	tay
	lda.w #$FFFD
	sta.w tmpdst,y
	rtl
sublist:		;substitution lists by position: word offsets from sublist, then roster slots (line * 8 + position); -1 ends
	dw .defl-sublist		; goalie
	dw .defl-sublist		; LD
	dw .defr-sublist		; RD
	dw .wingl-sublist		; LW
	dw .center-sublist		; C
	dw .wingr-sublist		; RW
	dw .center-sublist		; extra attacker
.defl:	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1
	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2
.defr:	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2
	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1
.wingl:	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
.wingr:	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
.center:	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db -1
priolist:		;positions in order of importance (SetPlList, releasepl, getlinee); no pad byte on the SNES
	db 0,1,2,4,3,5,6
ShowInjuryBox:		;injury box "Injury to:" player TempPlOffset (set by setInjuryType)
		;   SNES: "Injury to:" the player TempPlOffset (GetPlayerNumInitial), "Out for period", or "the game" when pf2fight of the puck is set.
		;   Jumped to by CheckInjury; saves d0-d2, a0-a4, ends with X = a3
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pusha
	ldx.b xsave
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$03
	lda.w #$0012
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
	jsl.l printz
	dw $0023		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$04,"Injury to:",$BF,$0C,$06,"Out for period",$BF,$0C,$05
	jsl.l GetPlayerNumInitial
	jsl.l print
	lda.w pf2fight+puckobj
	beq .nopf2fight
	jsl.l printz
	dw $000D		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$06,"the game"
.nopf2fight:
	stx.b xsave
	ldx.w #$0012
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl

org $8FFB2B
GetPlayerNumInitial:		;a1 = mesarea "NN F. Last" (FormatPlayerNumInitial) for player
		;   SNES: a1 = the name of player TempPlOffset (PlayerShortName; bit 15 = the visitors); saves d0, a2
	lda.b d0+2
	pha
	lda.b d0
	pha
	lda.b a2+2
	pha
	lda.b a2
	pha
	stz.b a2
	lda.w TempPlOffset
	sta.b d0
	bpl .TempPlOffsetpos
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b a2
.TempPlOffsetpos:
	jsl.l PlayerShortName
	pla
	sta.b a2
	pla
	sta.b a2+2
	pla
	sta.b d0
	pla
	sta.b d0+2
	rtl

org $8FFDFB
cd0:		;$fftt = frame/time for the levels of crowd excitement (updatecrowdf: crowd level, crowdstep); 4 levels of 16
	dw $010C,$020C,$030C,$040C,$050C,$0A0C,$090C,$080C
	dw $060C,$070C,$080C,$090C,$0A0C,$050C,$040C,$030C
	dw $0107,$0207,$0307,$0407,$0507,$0B07,$0C07,$0D07
	dw $0607,$0707,$0807,$0907,$0A07,$0B07,$0C07,$0D07
	dw $0E07,$0F07,$1007,$1107,$1207,$0B07,$0C07,$0D07
	dw $1207,$1107,$1007,$0F07,$0E07,$0D07,$0C07,$0B07
	dw $0E03,$0F03,$1003,$1103,$1203,$0B03,$0C03,$0D03
	dw $1203,$1103,$1003,$0F03,$0E03,$0D03,$0C03,$0B03

org $8FFEB4
ShowGoalBox:		;goal box. Closes both line change boxes, then printbig "GOAL!" (or "HAT
		;   SNES: , really the goal box: close both line change boxes (lcfound2), Framer at x $B, y 2 (5-8 tall by the
		;   assists), printbig "GOAL!" or "HAT TRICK!" (the scorer's third goal, tmgoals), the scorer and "Assist by:" names from the last ScoreSum entry; saves d0-d2, a0-a4, ends with X = a3
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pusha
	ldx.b xsave
	stz.b a2
	jsl.l lcfound2
	inc.b a2
	inc.b a2
	jsl.l lcfound2
	lda.w #$0000
	sta.b a4+2
	lda.w #ScoreSum-6
	clc
	adc.w ScoreSumbytes
	sta.b a4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02
	lda.w #$0013
	sta.b d0
	lda.w #$0005
	sta.b d1
	ldy.w #$0004
	lda.b [a4],y
	bit.w #$0080
	bne .nonzero
	inc.b d1
	inc.b d1
	lda.b [a4],y
	bmi .nonzero
	inc.b d1
.nonzero:
	jsl.l Framer
	stz.b a2
	ldy.w #$0002
	lda.b [a4],y
	bit.w #$0080
	beq .zero
	inc.b a2
	inc.b a2
.zero:
	lda.w #GoalBoxText
	sta.b a1
	lda.w #GoalBoxText>>16
	sta.b a1+2
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	ldy.b a2
	beq .noa2
	clc
	adc.w #$001A
.noa2:
	tay
	lda.w tmgoals,y		; goals of the scorer
	and.w #$00FF
	cmp.w #$0003
	bne .tmgoalsne
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.tmgoalsne:
	jsl.l printbig
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0004
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .ex
	jsl.l printz
	dw $0012		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0E,$06,"Assist by:",$BF,$0C,$07
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0005
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .ex
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$08
	jsl.l PlayerShortName
	jsl.l print
.ex:
	stx.b xsave
	ldx.w #$0012
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
GoalBoxText:		;printbig strings of ShowGoalBox: GOAL!, then HAT TRICK!
	dw 13
	db $BF,$0F,$03,"GOAL!",$BF,$0C,$05
	dw 18
	db $BF,$0C,$03,"HAT TRICK!",$BF,$0C,$05
unusedFF8F:		;the end of the ROM: zero fill
	db 0,0,0,0,0
