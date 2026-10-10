; $8FD005-$8FE009  ROM $7D005-$7E009: the last SpriteSet1 tiles, fightinput, holdcheck, PrintStringFromList, Framer, assnothing, GoalieCount,
; AdvanceStringPtr, the attribute menu tables, releasepl, assstanley, RemovePlayerFromList, asscenterd, loadTeamStruct, ScoutingReport,
; ScoutLabels, PuckcSpots. Ends before SetupTeamForIntermission (boundary moved from $8FE00D).
org $8FD005
	incbin "../data/Sprites/set01.chr":$3B0C..$4000		; $8FD005-$8FD4F8
SpriteSet1End:
	assert SpriteSet1End-SpriteSet1 == $474+512*32
fightinput:		;auto: CODE_8FD4F9 (from joyplayer). 93G fightinput: pad input in a fight: dpad moves (playeracc), stay near the fight spot (xc1), B/A/Y punch (SPA $F82/$F50/$F0C)
	lda.w temp3,x
	ora.w Pencntdwn
	bpl .l1
	jmp.w .l10
.l1:
	lda.w SPA,x
	cmp.w #$0EDA
	bne .l2
	jmp.w .l10
.l2:
	lda.b d1
	pha
	lda.b d0
	sta.b d2
	bit.w #$0008
	bne .l3
	and.w #$0007
	sta.b d2
	jsl.l playeracc
.l3:
	lda.w xc1
	clc
	adc.w #$000C
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .l4
	lda.b d0
	sec
	sbc.w #$0018
	sta.b d0
.l4:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Xvel,x
	eor.b d0
	sta.b d1
	bpl .l6
	lda.b d0
	bit.w #$8000
	beq .l5
	eor.w #$FFFF
	inc a
.l5:
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
.l6:
	pla
	sta.b d1
	lda.w pf2aip,x
	bne .l10
	lda.b d1
	sta.b d2
	lda.w #$0F50
	sta.b d1
	sta.w pf2aip,x
	lda.b d2
	bit.w #$0080
	beq .l7
	jml.l SetSPA
.l7:
	lda.w #$0F82
	sta.b d1
	lda.b d2
	bit.w #$8000
	beq .l8
	jml.l SetSPA
.l8:
	lda.w #$0F0C
	sta.b d1
	lda.b d2
	bit.w #$4000
	beq .l9
	jml.l SetSPA
.l9:
	stz.w pf2aip,x
.l10:
	rtl
holdcheck:		;auto: CODE_8FD5BF (from checkcheck). 93G holdcheck: player X holds a2 (SPAHold/SPAhook), both slow to the average speed; checkagr may call a holding/hooking penalty
	lda.w pfalock,x
	ora.w pf2fight,x
	beq .l1
	jmp.w .l8
.l1:
	lda.w position,x
	bne .l2
	jmp.w .l8
.l2:
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
	bcc .l3
	jmp.w .l8
.l3:
	lda.w puckc
	asl a
	cmp.b a3
	bne .l4
	lda.w #$0008
	trb.w sflags
.l4:
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
	beq .l5
	lda.w #$1386
	sta.b d1
.l5:
	jsl.l SetSPA
	jsl.l checkagr
	lda.b d0
	cmp.w #$0007
	bcs .l7
	lda.w #$0024
	sta.b d0
	lda.w SPA,x
	cmp.w #$0C2E
	beq .l6
	lda.w #$001E
	sta.b d0
.l6:
	jsl.l AddPenalty
.l7:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$FFFF
	sta.b collflag
.l8:
	rtl
PrintStringFromList:		;auto: CODE_8FD68C. 93G PrintStringFromList: print string d0 of the list [a1]
	lda.b d0
	bne .l1
	jml.l print
.l1:
	lda.b [a1]
	clc
	adc.b a1
	sta.b a1
	dec.b d0
	bra PrintStringFromList
Framer:		;auto: CODE_8FD69F. 93G Framer: a d0 x d1 box of FramerMap pieces at printx/printy
	phx
	lda.w printx
	sta.b tmp0
	lda.b d0
	sta.b tmp2
	ldx.w #$0000
	jsl.l .piece
	dec.b tmp2
	dec.b tmp2
.l1:
	ldx.w #$0002
	jsl.l .piece
	dec.b tmp2
	bne .l1
	ldx.w #$0004
	jsl.l .piece
	dec.b d1
	dec.b d1
.l2:
	lda.b tmp0
	sta.w printx
	inc.w printy
	lda.b d0
	dec a
	dec a
	sta.b tmp2
	ldx.w #$0006
	jsl.l .piece
.l3:
	ldx.w #$0008
	jsl.l .piece
	dec.b tmp2
	bne .l3
	ldx.w #$000A
	jsl.l .piece
	dec.b d1
	bne .l2
	lda.b tmp0
	sta.w printx
	inc.w printy
	dec.b d0
	dec.b d0
	ldx.w #$000C
	jsl.l .piece
.l4:
	ldx.w #$000E
	jsl.l .piece
	dec.b d0
	bne .l4
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
	bcs .l5
	sta.b textdirtylo
.l5:
	cmp.b textdirtyhi
	bcc .l6
	sta.b textdirtyhi
.l6:
	rtl
assnothing:		;auto: CODE_8FD75A. 93G assnothing: a computer player stands (doplayeracc 8)
	lda.w pflags,x
	bit.w #$0008
	bne .l1
	lda.w #$0008
	sta.b d0
	jmp.w doplayeracc
.l1:
	rtl
GoalieCount:		;auto: CODE_8FD76B. SNES: d0 = goalies of team a2 (nibbles of its goalie weights word, team record +$A, until 0); hangs if a2 is not 0 or 2
	lda.b a2
	tay
	and.w #$FFFD
.l1:
	bne .l1
	lda.w #$0083
	sta.b tmp1
	lda.w tmdata,y
	sta.b tmp0
	ldy.w #$000A
	clc
	adc.b [tmp0],y
	sta.b tmp0
	stz.b d0
	lda.b [tmp0]
	xba
.l2:
	inc.b d0
	asl a
	asl a
	asl a
	asl a
	bne .l2
	rtl
AdvanceStringPtr:		;auto: CODE_8FD793. 93G AdvanceStringPtr: a1 = string d0 of the list [a1]
	bra .l2
.l1:
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.l2:
	dec.b d0
	bpl .l1
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
releasepl:		;auto: CODE_8FD9DF. 93G releasepl (penalty93_1): player d0 leaves the penalty box: the next free object of team a2 comes on (tmap+1, priolist position), setplayer
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .l2
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.l3:
	inx
	inx
	lda.w position,x
	bpl .l3
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
	lda.w #$008F
	sta.b a0+2
	lda.w tmgoalie,y
	bpl .l4
	inc.b a0
.l4:
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
.l5:
	pla
	sta.b a0,x
	dex
	dex
	bpl .l5
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.l6:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l6
	ldx.b xsave
	ldx.b a3
	rtl
InitScoutDisplay:		;auto: CODE_8FDA75. SNES: scouting report scroll state reset; a0 = $7F0000 (the text buffer)
	lda.w #$FFFF
	sta.w VertLineScrolling
	sta.w PlayerScrollCtr
	stz.w SelectedPlayerIdx
	stz.w ScoutingReportTimer
	lda.w #$0000
	sta.b a0
	lda.w #$007F
	sta.b a0+2
	rtl
assstanley:		;auto: CODE_8FDA8F (asstab 8). 93G assstanley: skate to the side of the screen holding the Stanley Cup (SPAcup)
	lda.w pfalock,x
	bne .l5
	lda.w pflags,x
	bit.w #$0002
	beq .l2
	and.w #$FFFD
	sta.w pflags,x
	lda.w #$005A
	sta.w temp3,x
	lda.w Hpos
	bpl .l1
	lda.w #$FFA6
	sta.w temp3,x
.l1:
	lda.w Vpos
	sta.w temp4,x
	lda.w #$1124
	sta.b d1
	jsl.l SetSPA
.l2:
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
	beq .l4
	bmi .l3
	bvs .l4
	bra .l5
.l3:
	bvs .l5
.l4:
	lda.b d0
	sta.b d2
	sta.w facedir,x
	jmp.w playeracc
.l5:
	rtl
addframe_full:		;auto: CODE_8FDAF3. SNES: sprite VRAM cache full: sprnodraw, addframe_end
	lda.w #$0001
	sta.b sprnodraw
	jml.l addframe_end
RemovePlayerFromList:		;auto: CODE_8FDAFC. 93G RemovePlayerFromList: remove entry a0 from the penalty box list (tmboxlist) by shifting the rest down
	lda.w #$FFFF
	sta.b d2
.l1:
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
	beq .l1
	dec.b a0
	rtl
asscenterd:		;auto: CODE_8FDB1B (asstab 5). 93G asscenterd (logic93_2): centre on defence: halfway between the puck and his goal; acentero when the team gets the puck
	lda.w gmclock
	beq .l1
	jml.l assnothing
.l1:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .l2
	jmp.w .l7
.l2:
	bit.w #$0002
	beq .l3
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.l3:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .l4
	lda.w aidef,x
	sta.w temp1,x
	lda.w puckc
	bmi .l4
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
	bmi .l4
	jml.l assreplace
.l4:
	lda.w puckx
	pha
	asl a
	pla
	ror a
	sta.b d0
	lda.w #$0080
	sta.b d1
	lda.w pfgoal,x
	beq .l8
	lda.w #$FF80
	sta.b d1
	lda.w #$FFA8
	sec
	sbc.w pucky
	beq .l6
	bmi .l5
	bvs .l6
	bra .l11
.l5:
	bvs .l11
.l6:
	lda.w #$FF80
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
	bra .l11
.l7:
	rtl
.l8:
	lda.w #$0058
	sec
	sbc.w pucky
	bmi .l9
	bvc .l10
	bra .l11
.l9:
	bvc .l11
.l10:
	lda.b d1
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
.l11:
	lda.w #$84E6
	sta.b a0
	lda.w #$0080
	sta.b a0+2
	jml.l skateto
box:		;auto: CODE_8FDBDB. SNES: erase the 19 x 9 box at x 11, y 2 (93G box role)
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
UpdateCwdExcite:		;auto: CODE_8FDBF7. 93G UpdateCwdExcite: nothing on the SNES
	rtl
CheckPeriodEnd:		;auto: CODE_8FDBF8. 93G CheckPeriodEnd: nothing on the SNES
	rtl
loadTeamStruct:		;auto: CODE_8FDBF9. 93G loadTeamStruct: a2 = team of player X, a1 = the other team
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .l1
	stz.b a1
	lda.w #$0002
	sta.b a2
.l1:
	rtl
ScoutingReport:		;auto: CODE_8FDC0D (from Opening4). 93G ScoutingReport (hockey93_07): the scouting report screen: EASN backdrop, both team blocks, ScoutLabels with both teams' ratings, Ron Barr and
		;   the scrolling text until Start
	jsl.l ClearTeamStats
	jsl.l forceblack
	jsl.l InitPPU
	sep #$20
	cli
	lda.w RDNMI
	lda.b #$81
	sta.w NMITIMEN
	lda.b #$03
	sta.w OBSEL
	lda.b #$01
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$04
	sta.w BG2SC
	lda.b #$11
	sta.w BG12NBA
	lda.b #$03
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
.l1:
	sta.l textmap,x
	dex
	dex
	bpl .l1
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$03FE
.l2:
	lda.l TestList,x
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .l2
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.l3:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .l3
	ldx.w #$0010
.l4:
	stz.w VMDATAL
	dex
	bne .l4
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.l5:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .l5
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.l6:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0C80
	bne .l6
	ldx.w #$0000
.l7:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .l7
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
.l8:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .l8
	rep #$30
	ldx.w #$0000
.l9:
	lda.l TestList+$190,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$07A0
	bne .l9
	stz.b tmp1
.l10:
	stz.b tmp0
.l11:
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
	bne .l11
	inc.b tmp1
	lda.b tmp1
	cmp.w #$0009
	bne .l10
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
.l12:
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
	beq .l12
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$19,$0F
	lda.w tmdata
	sta.b a0
	lda.w #$0083
	sta.b a0+2
	sta.b a2+2
	lda.w tmdata+2
	sta.b a2
	ldy.w #$0008
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
	beq .l13
	sta.b [a0]
	inc.b a0
	inc.b a0
.l13:
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
.l14:
	lda.w #textmap
	sta.w DMAList
	lda.w #textmap>>16
	sta.w DMAList+dmabank
	lda.w #$1000
	sta.w DMAList+dmalen
	stz.w DMAList+dmavram
	lda.w #$0007
	sta.b DMAListend
	lda.w #$8250
	sta.b vbint
.l15:
	cmp.b vbint
	beq .l15
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	bit.w #$1000
	bne .l17
	bit.w #$0400
	beq .l16
	lda.w #$FFFF
	sta.w asv
.l16:
	jsl.l UpdateScoutingDisplay
	dec.w screentimer
	bpl .l14
.l17:
	rtl
ScoutCompare:		;auto: CODE_8FDED2. SNES: print the scouting ratings of team [a0] (nibbles of .sr, against [a2] for the advantages) down the screen
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
.l1:
	ldy.w #$0004
.l2:
	asl.b d5
	rol.b d5+2
	lda.b d5
	adc.w #$0000
	sta.b d5
	dey
	bne .l2
	lda.b d5
	and.w #$000F
	sta.b d0
	jsl.l .l5
	lda.b d6
	cmp.w #$0001
	bne .l3
	jsl.l .l4
.l3:
	dec.b d6
	bpl .l1
	rtl
.l4:
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
	jsl.l .l5
	lda.w printx
	cmp.w #$0010
	bcc .l6
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
.l5:
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWidth
	lda.w printx
	pha
	jsl.l print
	pla
	sta.w printx
.l6:
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
