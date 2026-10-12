puckfaceoff:		;asstab $1B. puckfaceoff : this is where the action starts: period end checks, goalies, line change boxes, then pfaceoff2
	lda.w pflags,x
	bit.w #pfna
	bne .first
	jmp.w .nna
.first:
	and.w #~pfna&$FFFF
	sta.w pflags,x
	lda.w gameclock		; clock out: PeriodOver
	bne .endper
	jml.l PeriodOver
.endper:
	lda.w gmode
	bit.w #gmendper
	beq .ot
	jml.l PeriodOver
.ot:
	lda.w gsp		; overtime and not tied: clockcont_0
	cmp.w #$0003
	bne .npo
	lda.w tmscore
	cmp.w tmscore+2
	beq .npo
	jml.l clockcont_0
.npo:
	lda.w gmode
	bit.w #gmpendel		; gmpendel: Stop4Pen
	beq .rg
	jmp.w Stop4Pen
.rg:
	jsl.l ReturnGoalies		; ReturnGoalies
	lda.w #$FFFF		; temp1/temp2 = -1: no lc box timers
	sta.w temp1,x
	sta.w temp2,x
	lda.w OptLine		; line changes off
	beq .lines
	jmp.w .nna
.lines:		;line changes on: no team in lc mode, clear pf2lcm on all 12 players
	lda.w #tmflc
	trb.w tmflags
	trb.w tmflags+2
	ldy.w #$0016
.lcm:
	lda.w pflags,y
	and.w #~pf2lcm&$FFFF
	sta.w pflags,y
	dey
	dey
	bpl .lcm
	lda.w cont1team		; a controlled team in horizontal mode: back to vertical
	ora.w cont2team
	beq .nohor
	lda.w sfhormode
	beq .nohor
	lda.w #sfslock
	tsb.w sflags
	jsl.l ClrHor
.nohor:
	lda.w c1playernum		; controller players get the lc box
	sta.b d0
	bmi .nlp
	jsl.l .slc
.nlp:
	lda.w c2playernum
	sta.b d0
	bmi .nlp2
	jsl.l .slc
.nlp2:
	stz.b a1		; a1 = home, a2 = away
	lda.w #$0002
	sta.b a2
	sta.b d0
	jsl.l .sclc
	bra .nna
.sclc:		;d0 = team (1/2), a2/a1 = team/other: computer line change unless that team is on a controller
	lda.w OptLine
	bne .rtl
	lda.b d0
	cmp.w cont1team
	beq .rtl
	cmp.w cont2team
	beq .rtl
	jsl.l CompLine
	jsl.l setpersonel
	jml.l printscores1
.slc:		;controlled player d0 gets the line change box
	ldy.b a3
	sty.b a2
	lda.b d0
	asl a		; exg a2,a3: X = the controlled player
	sta.b d0
	sta.b a3
	tax
	lda.w pflags,x
	and.w #~pf2lcm&$FFFF
	sta.w pflags,x
	phy
	lda.w #$FFFF		; lcplayer = -1
	sta.w lcplayer
	jsl.l SetLCmode
	ply
	sty.b a2
	ldx.b a3
	lda.w pflags,x
	bit.w #pf2lcm		; pf2lcm: the box opened
	beq .slcex
	lda.w pfteam,x
	beq .t1
	lda.w #$0168		; visitors: temp2 = 6*60, temp4 = SCnum
	sta.w temp2,y
	txa
	lsr a
	sta.w temp4,y
	bra .slcex
.t1:
	lda.w #$0258		; home: temp1 = 10*60, temp3 = SCnum
	sta.w temp1,y
	txa
	lsr a
	sta.w temp3,y
.slcex:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
.rtl:
	rtl
.nna:		;count down the two lc box timers (temp1/temp2); both done: pfaceoff2
	stz.b d0
	jsl.l .clc
	lda.w #$0020		; temp2/temp4
	sta.b d0
	jsl.l .clc
	ldx.b a3
	lda.w temp1,x
	bpl .rtl
	lda.w temp2,x
	bpl .rtl
	stz.b a2		; a2 = home, a1 = away
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l .sclc
	lda.w #pfaceoff2		; pfaceoff2
	sta.b d0
	ldx.b a3
	jmp.w assreplace
.clc:		;d0 = 0 (temp1/temp3) or $20 (temp2/temp4): update one lc box timer
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	bmi .rtl
	lda.w temp3,y		; temp3/temp4 = SCnum of the box owner
	asl a
	sta.b d1
	tay
	stz.b a0
	stz.b a2
	lda.w pfteam,y
	beq .clh
	lda.w #$0002
	sta.b a2
.clh:
	lda.w pflags,y
	bit.w #pf2lcm		; pf2lcm still on?
	bne .clnd
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	ora.w #$FF00		; timer negative: box closed
	sta.w temp1,y
	ldx.b a3
	jmp.w SetLCmode2
.clnd:
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	sec
	sbc.b d7		; count down
	sta.w temp1,y
	bmi .clcex
	jmp.w .rtl
.clcex:
	ldx.b a3
	phx
	ldx.b d1
	stx.b a3
	lda.w pflags,x
	bit.w #pf2lcm		; still in lc mode: lcfound with choice 0
	beq .pop
	stz.b d2
	jsl.l lcfound
	jsl.l SetLCmode2
.pop:
	plx
	stx.b a3
	rtl
