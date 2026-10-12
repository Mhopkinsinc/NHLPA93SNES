puckfaceoff2:		;Assignment: the face off and the setup for play
	lda.w pflags,x
	bit.w #pfna
	bne .first
	jmp.w .nna
.first:		;first time: set up the faceoff
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .savea
	ldx.b xsave
	lda.b crowdlevel		; limit crowd level
	cmp.w #$0258
	bcc .ntm
	lda.w #$0258
	sta.b crowdlevel
.ntm:
	lda.w #sfpz		; no pause, no lower lc box, no gloves, no icing, no refs, no goalie moves, puck invisible and loose
	trb.w sflags
	lda.w #sf3llcs
	trb.w sflags3
	stz.w glovecords
	stz.w iflags
	lda.w #$FFFF
	sta.w RefCnt
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w Zpos+puckobj
	sta.w puckc
	sta.w passReceiverPlayerNum
	lda.w #sf2refref		; clear sf2refref; faceoff on, replay record off
	trb.w sflags
	lda.w #sf2faceoff|sf2drec
	tsb.w sflags
	jsl.l ClrHor
	stz.w Vpos		; Vpos = Hpos = 0
	stz.w Hpos
	lda.w fox		; puck to the faceoff spot, stopped
	sta.w puckx
	lda.w foy
	sta.w pucky
	stz.w puckvx
	stz.w puckvy
	stz.w puckvz
	stz.w Xvel+$18		; goal nets (objects 12/13) at y +-268
	stz.w Yvel+$18
	stz.w Xpos+$18
	lda.w #$010C
	sta.w Ypos+$18
	stz.w Xvel+$1A
	stz.w Yvel+$1A
	stz.w Xpos+$1A
	lda.w #$FEF4
	sta.w Ypos+$1A
	lda.w #SPFpuck		; object 15 (puck shadow) = SPFpuck
	sta.w frame+$1E
	stz.w SPA+$1E
	stz.w attribute+$1E
	stz.w attribute+puckobj
	lda.w #sfslock		; clear sfslock: free up scrolling
	trb.w sflags
	lda.w #$0064
	sta.b d4
.cw:		;scroll to the faceoff spot
	jsl.l checkwindow
	dec.b d4
	bpl .cw
	lda.w #$003C		; yleader = 60
	sta.w yleader
	jsl.l ResetBench		; ResetBench
	stz.b a2
	jsl.l setpersonel
	jsl.l forcepldata
	inc.b a2
	inc.b a2
	jsl.l setpersonel
	jsl.l forcepldata
	jsl.l resetplstuff		; resetplstuff
	lda.b a3+2		; push a3
	pha
	lda.b a3
	pha
	stz.b a3
	lda.w #$000B
	sta.b d2
.l0:		;each player: assignment and faceoff position
	ldx.b a3
	lda.w #$FF10		; Xpos = -240, off the screen
	sta.w Xpos,x
	stz.w Ypos,x
	stz.w frame,x
	lda.w position,x
	sta.b d1
	bpl .pos
	jmp.w .next
.pos:
	beq .goalie1
	lda.w #afaceoff
	sta.b d0
	lda.b d1
	cmp.w #$0004
	bne .l1
	stz.b a2		; center: team touches = him only
	lda.w pfteam,x
	beq .tm
	inc.b a2
	inc.b a2
.tm:
	ldy.b a2
	lda.w pnum,x
	and.w #$00FF
	sta.w tmtouch1,y
	lda.w #$FFFF
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmflags,y
	and.w #~tmflast&$FFFF
	sta.w tmflags,y
	lda.w #afaceoffpl		; afaceoffpl
	sta.b d0
.l1:
	jsl.l assinsert
.goalie1:
	lda.w tmap		; d4 = (6-tmap)*8: .apl row
	sta.b d4
	ldx.b a3
	lda.w pfteam,x
	beq .t0
	lda.w tmap+2
	sta.b d4
.t0:
	lda.b d4
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0006
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #.apl>>16
	sta.b a1+2
	lda.w #.apl
	clc
	adc.b d4
	sta.b a1
	ldy.b d1
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	sta.b d4
	lda.w #.ptab
	sta.b a1
	lda.w #.ptab>>16
	sta.b a1+2
	ldy.b d4
	lda.b [a1],y
	sta.b d0
	iny
	iny
	lda.b [a1],y
	sta.b d1
	lda.w pfgoal,x
	bne .f0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.f0:
	lda.w position,x
	beq .goalie2
	lda.b d4		; defense (entry <= 2*4): shift by fox/foy
	sec
	sbc.w #$0008
	beq .def
	bmi .neg
	bvs .def
	bra .nodef
.neg:
	bvs .nodef
.def:
	lda.w fox
	eor.b d0
	bpl .notmid
	lda.w foy
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .mid
	ora.w #$E000
.mid:
	eor.w #$FFFF
	inc a
	clc
	adc.b d1
	sta.b d1
.notmid:
	lda.w fox
	lsr a
	lsr a
	bit.w #$2000
	beq .xadj
	ora.w #$C000
.xadj:
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
.nodef:
	lda.b d0
	clc
	adc.w fox
	sta.b d0
	lda.b d1
	clc
	adc.w foy
	sta.b d1
.goalie2:
	lda.b d0
	sta.w Xpos,x
	sec
	sbc.w puckx
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	sta.w Ypos,x
	sec
	sbc.w pucky
	eor.w #$FFFF
	inc a
	sta.b d1
	stz.w Xvel,x
	stz.w Yvel,x
	jsl.l vtoa		; face the puck
	lda.b d0
	sta.w facedir,x
	lda.w pflags,x
	and.w #~pf2unav&$FFFF		; clear pf2unav, pfalock, SPA
	sta.w pflags,x
	stz.w pfalock,x
	stz.w SPA,x
	lda.w #SPAglide
	sta.b d1
	jsl.l SetSPA
.next:
	inc.b a3
	inc.b a3
	dec.b d2
	bmi .done
	jmp.w .l0
.done:
	jsl.l SprSort		; SprSort
	pla
	sta.b a3
	pla
	sta.b a3+2
	ldx.b a3
	jsl.l ResetAndSelectPlayers
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w #$0036		; 8+46
	sta.b d0
	lda.w fox
	bpl .fok
	lda.w #$00BE		; (18*8)+46
	sta.b d0
.fok:
	lda.b d0
	sta.w fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	sta.w printx
	lda.w #$005C		; (3*8)+68
	sta.w fodropy
	lda.w #$0003
	sta.w printy
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	jsl.l marktextlo		; mark the box rows dirty
	lda.w printy
	clc
	adc.w #$0009
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.w #$000B
	jsl.l marktexthi
	lda.w #FaceOffMap		; fobox nonzero
	sta.b fobox
	sta.b tmp0
	lda.w #FaceOffMap>>16
	sta.b tmp1
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	ldy.w #$0000
	lda.w #$000A
	sta.b tmp1+1
	clc
.row:		;copy the 12x10 FaceOffMap into the text map
	lda.w #$000C
	sta.b tmp2+1
.col:
	lda.b [tmp0],y
	clc
	adc.w faceoffvrcset
	adc.w charofs
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp2+1
	bne .col
	txa
	clc
	adc.w #$0028
	tax
	dec.b tmp1+1
	bne .row
	ldx.b a3
	lda.w OptLine		; line changes on: line names box
	bne .nol
	lda.w printy
	clc
	adc.w #$000A
	sta.w printy
	lda.w #$000C
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer		; d0/d1 size
	lda.w tmline
	sta.b d0
	lda.w tmline+2
	sta.b d1
	lda.w gmode		; gmdir
	bit.w #gmdir
	bne .nx
	lda.w tmline
	sta.b d1
	lda.w tmline+2
	sta.b d0
.nx:
	inc.w printx
	dec.w printy
	dec.w printy
	lda.w #linelist		; linelist
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	inc.w printx
	inc.w printx
	inc.w printx
	inc.w printx
	lda.b d1
	sta.b d0
	lda.w #linelist
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList
.nol:		;time for the puck drop: 180-299 frames
	lda.w #$0078
	jsl.l randoma
	adc.w #$00B4
	sta.b d0
	ldx.b a3
	sta.w temp1,x
	lda.w #$0001		; fofdata2: home pull frame 1, away 4, ref 7
	sta.w fofdata2
	lda.w #$8000
	sta.w fofdata2+2
	sta.w fofdata+2
	lda.w #$0004
	sta.w fofdata2+4
	lda.w #$A800
	sta.w fofdata2+6
	lda.w #$0007
	sta.w fofdata
	lda.w gmode
	bit.w #gmdir		; gmdir: flip the attributes
	bne .nfl
	lda.w #$8800
	sta.w fofdata2+2
	lda.w #$A000
	sta.w fofdata2+6
.nfl:
	lda.w #$FFFF		; fodir1/fodir2 = none
	sta.w fodir1
	sta.w fodir2
	stx.b xsave
	ldx.w #$001A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
.nna:		;count down to the drop; then Endfaceoff
	lda.b d7		; temp1 -= min(d7, temp1)
	sta.b tmp0
	sec
	sbc.w temp1,x
	bmi .neg1
	bvc .one
	bra .sub
.neg1:
	bvc .sub
.one:
	lda.w #$0001
	sta.b tmp0
.sub:
	lda.w temp1,x
	sec
	sbc.b tmp0
	sta.w temp1,x
	bpl updatefaceoff
	jmp.w Endfaceoff
.apl:		;.ptab entry for each position, by players on ice (6, 5, 4)
	db 0,1,2,3,4,5,6,0		; 6 on ice
	db 0,1,5,3,4,2,0,0		; 5 on ice
	db 0,3,5,1,4,0,0,0		; 4 on ice
.ptab:		;faceoff x/y offsets
	dw 0,-250, -35,-50, 35,-50, -50,-10
	dw 0,-15, 50,-10, 0,-60
