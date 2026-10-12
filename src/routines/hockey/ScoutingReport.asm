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
.clrtext:
	sta.l textmap,x
	dex
	dex
	bpl .clrtext
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$03FE
.copymap:
	lda.l TestList,x
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .copymap
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.easntiles:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .easntiles
	ldx.w #$0010
.padvram:
	stz.w VMDATAL
	dex
	bne .padvram
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
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.fonttiles:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0C80
	bne .fonttiles
	ldx.w #$0000
.framertiles:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .framertiles
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
.ronpal:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .ronpal
	rep #$30
	ldx.w #$0000
.rontiles:
	lda.l TestList+$190,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$07A0
	bne .rontiles
	stz.b tmp1
.ronrow:
	stz.b tmp0
.roncol:
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
	bne .roncol
	inc.b tmp1
	lda.b tmp1
	cmp.w #$0009
	bne .ronrow
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
.pl:
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
	beq .pl
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
	beq .same
	sta.b [a0]
	inc.b a0
	inc.b a0
.same:
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
.top:
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
	lda.w padnew1
	ora.w padnew1+2
	bit.w #$1000
	bne .rtl
	bit.w #$0400
	beq .upd
	lda.w #$FFFF
	sta.w asv
.upd:
	jsl.l UpdateScoutingDisplay
	dec.w screentimer
	bpl .top
.rtl:
	rtl
