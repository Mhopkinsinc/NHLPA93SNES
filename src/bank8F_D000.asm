; $8FD005-$8FE009  ROM $7D005-$7E009: the last SpriteSet1 tiles, fightinput, holdcheck, PrintStringFromList, Framer, assnothing, GoalieCount,
; AdvanceStringPtr, the attribute menu tables, releasepl, assstanley, RemovePlayerFromList, asscenterd, loadTeamStruct, ScoutingReport,
; ScoutLabels, PuckcSpots. Ends before SetupTeamForIntermission (boundary moved from $8FE00D).
org $8FD005
	incbin "../data/Sprites/set01.chr":$3B0C..$4000		; $8FD005-$8FD4F8
SpriteSet1End:
	assert SpriteSet1End-SpriteSet1 == $474+512*32
fightinput:		;controller processing for fighting (93G logic93_1)
		;   SNES: pad input in a fight: dpad moves (playeracc), stay near the fight spot (xc1), B/A/Y punch (SPA $F82/$F50/$F0C)
	lda.w temp3,x
	ora.w Pencntdwn
	bpl .Pencntdwnpos
	jmp.w .rtl
.Pencntdwnpos:
	lda.w SPA,x
	cmp.w #$0EDA
	bne .SPAne
	jmp.w .rtl
.SPAne:
	lda.b d1
	pha
	lda.b d0
	sta.b d2
	bit.w #$0008
	bne .nonzero
	and.w #$0007
	sta.b d2
	jsl.l playeracc
.nonzero:
	lda.w xc1
	clc
	adc.w #$000C
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .facedirne
	lda.b d0
	sec
	sbc.w #$0018
	sta.b d0
.facedirne:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Xvel,x
	eor.b d0
	sta.b d1
	bpl .Xvelpos
	lda.b d0
	bit.w #$8000
	beq .nod0
	eor.w #$FFFF
	inc a
.nod0:
	sta.b d0
	lda.w Xvel,x
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lda.w #$0006
	sta.b mula
	jsl.l divs
	sta.b d0
	lda.w Xvel,x
	sec
	sbc.b d0
	sta.w Xvel,x
.Xvelpos:
	pla
	sta.b d1
	lda.w pf2aip,x
	bne .rtl
	lda.b d1
	sta.b d2
	lda.w #$0F50
	sta.b d1
	sta.w pf2aip,x
	lda.b d2
	bit.w #$0080
	beq .nod2
	jml.l SetSPA
.nod2:
	lda.w #$0F82
	sta.b d1
	lda.b d2
	bit.w #$8000
	beq .nod22
	jml.l SetSPA
.nod22:
	lda.w #$0F0C
	sta.b d1
	lda.b d2
	bit.w #$4000
	beq .nod23
	jml.l SetSPA
.nod23:
	stz.w pf2aip,x
.rtl:
	rtl
holdcheck:		;player a2 is in hold animation looking to hold opponent a3. Entered from checkcheck .cc for SPA $CB0 (92 SPAHold) or $12DC. 93 adds the facing test, the puck carrier sflags
		;   clear and the second hold anim, and rolls the penalty with checkagr (93G hockey93_03)
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
	bne .puckcne
	lda.w #$0008
	trb.w sflags
.puckcne:
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
	beq .SPAeq
	lda.w #$1386
	sta.b d1
.SPAeq:
	jsl.l SetSPA
	jsl.l checkagr
	lda.b d0
	cmp.w #$0007
	bcs .d0ge
	lda.w #$0024
	sta.b d0
	lda.w SPA,x
	cmp.w #$0C2E
	beq .SPAeq2
	lda.w #$001E
	sta.b d0
.SPAeq2:
	jsl.l AddPenalty
.d0ge:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$FFFF
	sta.b collflag
.rtl:
	rtl
PrintStringFromList:		;print string d0 of the String list a1 with printsmall (93G penalty93_2)
		;   SNES: print string d0 of the list [a1]
	lda.b d0
	bne .d0
	jml.l print
.d0:
	lda.b [a1]
	clc
	adc.b a1
	sta.b a1
	dec.b d0
	bra PrintStringFromList
Framer:		;frame and fill (uses framer.map graphics and assums tiles are already located at framercset). d0/d1 = x/y size of rectangle, printx/y/m define top left corner to start at (93G
		;   middle93_2)
		;   SNES: a d0 x d1 box of FramerMap pieces at printx/printy
	phx
	lda.w printx
	sta.b tmp0
	lda.b d0
	sta.b tmp2
	ldx.w #$0000
	jsl.l .piece
	dec.b tmp2
	dec.b tmp2
.loop:
	ldx.w #$0002
	jsl.l .piece
	dec.b tmp2
	bne .loop
	ldx.w #$0004
	jsl.l .piece
	dec.b d1
	dec.b d1
.loop2:
	lda.b tmp0
	sta.w printx
	inc.w printy
	lda.b d0
	dec a
	dec a
	sta.b tmp2
	ldx.w #$0006
	jsl.l .piece
.loop3:
	ldx.w #$0008
	jsl.l .piece
	dec.b tmp2
	bne .loop3
	ldx.w #$000A
	jsl.l .piece
	dec.b d1
	bne .loop2
	lda.b tmp0
	sta.w printx
	inc.w printy
	dec.b d0
	dec.b d0
	ldx.w #$000C
	jsl.l .piece
.loop4:
	ldx.w #$000E
	jsl.l .piece
	dec.b d0
	bne .loop4
	ldx.w #$0010
	jsl.l .piece
	lda.b tmp0
	sta.w printx
	inc.w printy
	plx
	rtl
.piece:		;one FramerMap piece (X = piece * 2) at printx/printy, printx + 1
	lda.l FramerMap,x
	clc
	adc.w Framercset
	clc
	adc.w printfontset
	pha
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	pla
	ora.w printa
	sta.l textmap,x
	inc.w printx
	txa
	lsr a
	cmp.b textdirtylo
	bcs .ge
	sta.b textdirtylo
.ge:
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
assnothing:		;player should do nothing (93G logic93_2)
		;   SNES: a computer player stands (doplayeracc 8)
	lda.w pflags,x
	bit.w #$0008
	bne .rtl
	lda.w #$0008
	sta.b d0
	jmp.w doplayeracc
.rtl:
	rtl
GoalieCount:		;SNES: d0 = goalies of team a2 (nibbles of its goalie weights word, team record +$A, until 0); hangs if a2 is not 0 or 2
	lda.b a2
	tay
	and.w #$FFFD
.loop:
	bne .loop
	lda.w #TeamList>>16
	sta.b tmp1
	lda.w tmdata,y
	sta.b tmp0
	ldy.w #ScoreOdds
	clc
	adc.b [tmp0],y
	sta.b tmp0
	stz.b d0
	lda.b [tmp0]
	xba
.loop2:
	inc.b d0
	asl a
	asl a
	asl a
	asl a
	bne .loop2
	rtl
AdvanceStringPtr:		;92 Fprint without the print. Return a1 = string d0 of the String list a1 (93G penalty93_2)
		;   SNES: a1 = string d0 of the list [a1]
	bra .join
.loop:
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.join:
	dec.b d0
	bpl .loop
	rtl
AttribMenuSkater:		;SNES: player attribute menu (DisplayPlayerAttributeMenu): 15-byte item strings, the rating bit mask and column, $FFFF ends
	dw 15
	db "   Status   ]"
	dw $0000,$0000		; bit mask, rating column
	dw 15
	db "[  Overall  ]"
	dw $1F3A,$000A		; bit mask, rating column
	dw 15
	db "[  Energy   ]"
	dw $0000,$0002		; bit mask, rating column
	dw 15
	db "[  Agility  ]"
	dw $1000,$000A		; bit mask, rating column
	dw 15
	db "[   Speed   ]"
	dw $0800,$000A		; bit mask, rating column
	dw 15
	db "[  Handed   ]"
	dw $0040,$0004		; bit mask, rating column
	dw 15
	db "[Off. Aware.]"
	dw $0400,$000A		; bit mask, rating column
	dw 15
	db "[Def. Aware.]"
	dw $0200,$000A		; bit mask, rating column
	dw 15
	db "[Shot Power ]"
	dw $0100,$000A		; bit mask, rating column
	dw 15
	db "[Shot  Accur]"
	dw $0010,$000A		; bit mask, rating column
	dw 15
	db "[Pass  Accur]"
	dw $0002,$000A		; bit mask, rating column
	dw 15
	db "[Stick Handl]"
	dw $0020,$000A		; bit mask, rating column
	dw 15
	db "[  Weight   ]"
	dw $2000,$0006		; bit mask, rating column
	dw 15
	db "[ Endurance ]"
	dw $0008,$000A		; bit mask, rating column
	dw 15
	db "[Aggression ]"
	dw $0001,$000A		; bit mask, rating column
	dw 15
	db "[ Checking  ]"
	dw $0080,$000A		; bit mask, rating column
	dw 15
	db "[  Fighting  "
	dw $0040,$0008		; bit mask, rating column
	dw $FFFF		; end
AttribMenuGoalie:		;SNES: goalie attribute menu
	dw 15
	db "   Status   ]"
	dw $0000,$0000		; bit mask, rating column
	dw 15
	db "[  Overall  ]"
	dw $1B0F,$000A		; bit mask, rating column
	dw 15
	db "[  Agility  ]"
	dw $1000,$000A		; bit mask, rating column
	dw 15
	db "[   Speed   ]"
	dw $0800,$000A		; bit mask, rating column
	dw 15
	db "[Glove Hand ]"
	dw $0040,$0004		; bit mask, rating column
	dw 15
	db "[Def. Aware.]"
	dw $0200,$000A		; bit mask, rating column
	dw 15
	db "[Puck Cont. ]"
	dw $0100,$000A		; bit mask, rating column
	dw 15
	db "[Stick Right]"
	dw $0008,$000A		; bit mask, rating column
	dw 15
	db "[Stick Left ]"
	dw $0004,$000A		; bit mask, rating column
	dw 15
	db "[Glove Right]"
	dw $0002,$000A		; bit mask, rating column
	dw 15
	db "[Glove Left ]"
	dw $0001,$000A		; bit mask, rating column
	dw 15
	db "[   Weight   "
	dw $2000,$0006		; bit mask, rating column
	dw $FFFF		; end
PositionNames:		;SNES: position names LD, RD, LW, C, RW
	dw 4
	db "LD"
	dw 4
	db "RD"
	dw 4
	db "LW"
	dw 3
	db "C"
	dw 4
	db "RW"
releasepl:		;player's penalty time is up so let him out (if appropriate). a2 = team, d0 = player*2. Called from ProcessPenaltyList (93G penalty93_1)
		;   SNES: player d0 leaves the penalty box: the next free object of team a2 comes on (tmap+1, priolist position), setplayer
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
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.loop:
	inx
	inx
	lda.w position,x
	bpl .loop
	lda.b d0
	lsr a
	sta.b d3
	ldy.b a2
	lda.w tmap,y
	sta.b d1
	inc a
	sta.w tmap,y
	lda.w #$0001
	tsb.w tmflags
	tsb.w tmflags+2
	lda.w #priolist
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	lda.w tmgoalie,y
	bpl .tmgoaliepos
	inc.b a0
.tmgoaliepos:
	ldy.b d1
	lda.b [a0],y
	and.w #$00FF
	sta.w position,x
	stx.b a3
	jsl.l Setplass
	jsl.l setplayer
	lda.w pflags,x
	ora.w #$1000
	sta.w pflags,x
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
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
InitScoutDisplay:		;SNES: scouting report scroll state reset; a0 = $7F0000 (the text buffer)
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
assstanley:		;asstab 8. player a3 skates with stanley cup overhead (93G logic93_2)
		;   SNES: skate to the side of the screen holding the Stanley Cup (SPAcup)
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #$0002
	beq .nopflags
	and.w #$FFFD
	sta.w pflags,x
	lda.w #$005A
	sta.w temp3,x
	lda.w Hpos
	bpl .Hpospos
	lda.w #$FFA6
	sta.w temp3,x
.Hpospos:
	lda.w Vpos
	sta.w temp4,x
	lda.w #$1124
	sta.b d1
	jsl.l SetSPA
.nopflags:
	lda.w temp3,x
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w temp4,x
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w #$0007
	beq .nod0
	bmi .neg
	bvs .nod0
	bra .rtl
.neg:
	bvs .rtl
.nod0:
	lda.b d0
	sta.b d2
	sta.w facedir,x
	jmp.w playeracc
.rtl:
	rtl
addframe_full:		;SNES: sprite VRAM cache full: sprnodraw, addframe_end
	lda.w #$0001
	sta.b sprnodraw
	jml.l addframe_end
RemovePlayerFromList:		;remove the entry before a0 from a penalty box list by shifting the rest down (list ends with a negative byte). Return a0 = removed slot. Called from PenGoalStuff,
		;   ProcessPenaltyList (93G penalty93_1)
		;   SNES: remove entry a0 from the penalty box list (tmboxlist) by shifting the rest down
	lda.w #$FFFF
	sta.b d2
.loop:
	inc.b d2
	lda.b a0
	clc
	adc.b d2
	tay
	sep #$20
	lda.w tmboxlist,y
	sta.w tmboxlist-1,y
	rep #$30
	bit.w #$0080
	beq .loop
	dec.b a0
	rtl
asscenterd:		;asstab 5. player a3 is center on defense (93G logic93_3)
		;   SNES: centre on defence: halfway between the puck and his goal; acentero when the team gets the puck
	lda.w gmclock
	beq .nogmclock
	jml.l assnothing
.nogmclock:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .nopflags
	jmp.w .rtl
.nopflags:
	bit.w #$0002
	beq .zero
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.zero:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .pos
	lda.w aidef,x
	sta.w temp1,x
	lda.w puckc
	bmi .pos
	sec
	sbc.w #$0006
	sta.b d1
	lda.w #$0006
	sta.b d0
	txa
	lsr a
	sec
	sbc.w #$0006
	eor.b d1
	bmi .pos
	jml.l assreplace
.pos:
	lda.w puckx
	pha
	asl a
	pla
	ror a
	sta.b d0
	lda.w #$0080
	sta.b d1
	lda.w pfgoal,x
	beq .nopfgoal
	lda.w #$FF80
	sta.b d1
	lda.w #$FFA8
	sec
	sbc.w pucky
	beq .zero2
	bmi .neg
	bvs .zero2
	bra .join
.neg:
	bvs .join
.zero2:
	lda.w #$FF80
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
	bra .join
.rtl:
	rtl
.nopfgoal:
	lda.w #$0058
	sec
	sbc.w pucky
	bmi .neg2
	bvc .vc
	bra .join
.neg2:
	bvc .join
.vc:
	lda.b d1
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
.join:
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jml.l skateto
box:		;93 only: fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser). (93G hockey93_10)
		;   SNES: erase the 19 x 9 box at x 11, y 2 (93G box role)
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
UpdateCwdExcite:		;called once per second. Track peak and running total of crowd (93G hockey93_01)
		;   SNES: nothing on the SNES
	rtl
CheckPeriodEnd:		;called once per second. 3rd period: play tune $32 once at the random (93G hockey93_01)
		;   SNES: nothing on the SNES
	rtl
loadTeamStruct:		;return a2 = team struct of player a3, a1 = the other team's struct. Called from ChkShotStat and updateplayers (93G penalty93_2)
		;   SNES: a2 = team of player X, a1 = the other team
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .rtl
	stz.b a1
	lda.w #$0002
	sta.b a2
.rtl:
	rtl
ScoutingReport:		;93 pregame scouting report (92 drew ScoutMap and position check marks). Called from PeriodOver. (93G hockey93_07)
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
	jsl.l DecompressGraphics
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
	jsl.l DecompressGraphics
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
	jsl.l DecompressGraphics
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
	jsl.l DecompressGraphics
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
ScoutLabels:		;93G scouting labels: the rating names of the scouting report; a $FF string ends the list
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
PuckcSpots:		;93G asspuckc spots: x, y of spot d0 (6 + temp3, or position when offsides)
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
