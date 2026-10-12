TeamRoster:		;Team Roster screen: each line's players and one attribute column. The pad moves, Y switches team,
		;   Start leaves
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
.framertiles:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .framertiles
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
.blocktiles:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .blocktiles
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.easntiles:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .easntiles
	ldx.w #$03FE
.copymap:
	lda.l TestList,x
	clc
	adc.w ExtraChars
	clc
	adc.w charofs2
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .copymap
	lda.w #RonBarrMap
	sta.b tmp0
	lda.w #RonBarrMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.ronpal:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .ronpal
	rep #$30
	stz.b a2
	lda.w cont1team
	sta.b tmp0
	lda.w sflags
	bit.w #$0002
	beq .cont1
	lda.w cont2team
	sta.b tmp0
.cont1:
	lda.b tmp0
	cmp.w #$0002
	bne .gotteam
	lda.w #$0002
	sta.b a2
.gotteam:
	ldy.b a2
	lda.w tmline,y
	inc a
	sta.b d0
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
.redraw:
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
.clrtext:
	sta.l textmap,x
	dex
	dex
	bpl .clrtext
	jsl.l printbigz
	dw $0014		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$04,"Team  Roster",$BF,$0B,$01
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .home
	lda.w VisTeam
	sta.b d1
	lda.w #$0030
.home:
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
.loop:
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
.vbwait:
	cmp.b vbint
	beq .vbwait
	jsl.l ReadPads
	jsl.l getpzjoy
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	beq .nostart
	jmp.w .rtl
.nostart:
	bit.w #$4000
	bne .team
	stz.b d0
	inc.b d0
	bit.w #$0100
	bne .col
	dec.b d0
	dec.b d0
	bit.w #$0200
	bne .col
	bit.w #$0800
	bne .line
	inc.b d0
	inc.b d0
	bit.w #$0400
	beq .again
.line:
	lda.b d0
	clc
	adc.w SelectedPlayerIdx
	sta.b d0
	bmi .again
	cmp.w #$0008
	bcs .again
	sta.w SelectedPlayerIdx
	jsl.l .show
.again:
	jmp.w .loop
.col:
	lda.b d0
	clc
	adc.w DispAttribCtr
	sta.b d0
	bmi .again
	sta.w DispAttribCtr
	jsl.l .show
	bra .again
.team:
	lda.b a2
	eor.w #$0002
	sta.b a2
	jmp.w .redraw
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
.top:
	lda.w #AttribMenuSkater
	sta.b a1
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w DispAttribCtr
	sta.b d0
	lda.w SelectedPlayerIdx
	bne .2
	lda.w #AttribMenuGoalie
	sta.b a1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	bra .2
.next:
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.2:
	lda.b [a1]
	bmi .check
	dec.b d0
	bpl .next
.check:
	lda.b [a1]
	bpl .found
	dec.w DispAttribCtr
	bra .top
.found:
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
	bmi .row
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
	beq .row
	bmi .lt5
	bvc .fewer
	bra .row
.lt5:
	bvc .row
.fewer:
	dec.b d1
.row:
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
	bpl .row
.rtl:
	rtl
