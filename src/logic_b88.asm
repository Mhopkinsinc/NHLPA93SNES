; Player logic and the assignments (asstab).
; Bank $88. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $888548
noturn0:		;doplayeracc when the wanted direction needs no turn (.ftab entry 0). d0 = direction minus facedir, times 2
		;   SNES: glide/stop/skate animation, then revplayeracc (noturn). d0 = direction - facedir
	lda.w #$0002		; d4 = 2, 6 skating backwards
	sta.b d4
	lda.w pfrev,x
	beq .0
	lda.w #$0006
	sta.b d4
	lda.b d0
	eor.w #$0008
	sta.b d0
.0:
	lda.b d0
	beq .nochg
	lda.w Xvel,x		; moving: stop if the direction is more than 90 degrees off
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa
	bit.w #$0008
	bne .nostop
	sec
	sbc.w facedir,x
	clc
	adc.b d4
	and.w #$0007
	sta.b d0
	cmp.w #$0004
	bcs .nostop
	jml.l dostop
.nostop:
	inc.w facedir,x		; turn one step
	lda.w attribute,x
	bit.w #$0800
	beq .nos0
	dec.w facedir,x
	dec.w facedir,x
.nos0:
	lda.w facedir,x
	and.w #$0007
	sta.w facedir,x
	lda.w #SPAglide
	sta.b d1
	lda.w pfrev,x
	bne .gback
	jml.l SetSPA
.gback:
	lda.w #SPAglideback
	sta.b d1
	jml.l SetSPA
.nochg:
	lda.w #SPAskateback		; no change: skate
	sta.b d1
	lda.w pfrev,x
	bne .ns
	lda.w #SPAskate
	sta.b d1
	lda.w pflags,x		; pflags $0004 (pflags2 bit 6): stumble
	bit.w #$0004
	beq .nb6
	lda.w #SPAstumble
	sta.b d1
.nb6:
	lda.w puckc		; carrier: skate with the puck
	sta.b d4
	cmp.w SCnum,x
	bne .ns
	lda.w #SPAskatewp
	sta.b d1
.ns:
	lda.w pf2aip,x
	beq .set
	jml.l revplayeracc
.set:
	jsl.l SetSPA
	jml.l revplayeracc

org $88FBA6
assdefd:		;asstab 2. player a3 is defensive player on defense
		;   SNES: defenseman on defense: stay between the furthest-up attacker and the goal, join the attack (adefo) when the puck is past the line
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing
.gm:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pfjoycon
	beq .chk
	jmp.w .rtl
.chk:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .new
	jmp.w .de3
.new:
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w pucky
	sta.b d1
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .sx
	ora.w #$FC00
.sx:
	sta.b d3
	lda.w pfgoal,x
	bne .de00
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
.de00:		;only lead when moving up ice
	lda.b d3
	bpl .v
	stz.b d3
.v:
	lda.b d3
	clc
	adc.b d1
	sta.b d3
	sec
	sbc.w #$58
	bmi .lt
	bvc .pastline
	bra .de0
.lt:
	bvc .de0
.pastline:
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .de0
	lda.w puckc
	sta.b d1
	bmi .de0
	jsl.l chkpk
	beq .de0
	lda.w #1
	sta.b d0
	lda.b d1
	sec
	sbc.w #6
	sta.b d1
	txa
	lsr a
	sec
	sbc.w #6
	sta.b d2
	eor.b d1
	sta.b d1
	bmi .de0
	jml.l assreplace
.de0:
	lda.w #65
	sta.w temp3,x
	lda.w position,x
	cmp.w #$0002
	beq .de1
	lda.w #-65
	sta.w temp3,x
.de1:
	stz.b a0
	cpx.w #12
	bcs .de2
	lda.w #12
	sta.b a0
.de2:		;find the furthest-up attacker
	lda.w #5
	sta.b d2
	lda.w #-1000
	sta.b d0
	lda.w pfgoal,x
	beq .gdwn
	lda.w #1000
	sta.b d0
.gup:
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .gu0
	lda.w position,y
	bmi .gu0
	lda.w Yvel,y
	bmi .gu2
	lda.w #$0000
.gu2:
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .gu2s
	ora.w #$F000
.gu2s:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	beq .gu3
	bmi .gt
	bvs .gu3
	bra .gu0
.gt:
	bvs .gu0
.gu3:
	lda.b d1
	sta.b d0
.gu0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .gup
	lda.b d0
	sec
	sbc.w #50
	sta.b d0
	sec
	sbc.w #-190
	beq .cl1
	bmi .gt1
	bvs .cl1
	bra .gu1
.gt1:
	bvs .gu1
.cl1:
	lda.w #-220
	sta.b d0
.gu1:
	lda.b d0
	sta.w temp4,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .de3
	stz.w temp3,x
	bra .de3
.rtl:
	rtl
.gdwn:
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .gd0
	lda.w position,y
	bmi .gd0
	lda.w Yvel,y
	bpl .gd2
	lda.w #$0000
.gd2:
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .gd2s
	ora.w #$F000
.gd2s:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	bmi .lt2
	bvc .gd3
	bra .gd0
.lt2:
	bvc .gd0
.gd3:
	lda.b d1
	sta.b d0
.gd0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .gdwn
	lda.b d0
	clc
	adc.w #50
	sta.b d0
	sec
	sbc.w #190
	bmi .lt3
	bvc .cl2
	bra .gd1
.lt3:
	bvc .gd1
.cl2:
	lda.w #220
	sta.b d0
.gd1:
	lda.b d0
	sta.w temp4,x
	lda.w temp3,x
	eor.w #$FFFF
	inc a
	sta.w temp3,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .de3
	stz.w temp3,x
.de3:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #EvadePC
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jsl.l skateto
	jml.l check4check

org $88FDD0
skateto:		;a0 = extra routine for collision avoidance, d0/d1 = x/y cord to skate to, d7 = elapse frames
		;   SNES: a skater near the target (sum of distances < 55) slows to 7/8
	lda.w position,x
	beq .tick
	lda.w pflags,x
	and.w #$8000
	ora.w sfhormode
	bne .tick
	lda.b d0
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0088
	bcs .tick
	lda.w Xpos,x
	sec
	sbc.b d0
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b tmp0
	lda.w Ypos,x
	sec
	sbc.b d1
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	clc
	adc.b tmp0
	cmp.w #55
	bcs .tick
	lda.w Xvel,x
	sta.b mula
	lda.w #7
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #7
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Yvel,x
.tick:		;every 12/60 second
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .go
	jmp.w .ex
.go:
	adc.w #11
	sta.w temp2,x
	jsl.l avdgoal
	lda.w #13
	sta.b d0+2
	lda.b d0
	bit.w #$8000
	beq .near
	eor.w #$FFFF
	inc a
.near:
	cmp.w #$0088
	bcs .av
	lda.w #18
	sta.b d0+2
.av:
	lda.b deltax
	ora.b deltay
	beq .lead
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	bra .vt
.lead:		;aim ahead of the velocity
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .lx
	ora.w #$FF00
.lx:
	eor.w #$FFFF
	inc a
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ly
	ora.w #$FF00
.ly:
	eor.w #$FFFF
	inc a
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.b d0
	bit.w #$8000
	beq .cx
	eor.w #$FFFF
	inc a
.cx:
	cmp.b d0+2
	bcs .vt
	lda.b d1
	bit.w #$8000
	beq .cy
	eor.w #$FFFF
	inc a
.cy:
	cmp.b d0+2
	bcs .vt
	lda.w #9
	sta.b d0
	bra .nvt
.vt:
	jsl.l vtoa
.nvt:		;jsr (a0) through jmlvector
	lda.b a0
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector
	lda.b d0
	sta.w temp2b,x
	cmp.w #8
	bcc .ex
	lda.w Xvel,x
	ora.w Yvel,x
	bne .ex
	lda.w puckx
	sta.b d0
	lda.w pucky
	sta.b d1
	lda.w pf2fight+puckobj
	beq .nf
	lda.w xc1
	sta.b d0
	lda.w yc1
	sta.b d1
.nf:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	sec
	sbc.w facedir,x
	beq .ex
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.w facedir,x
.ex:
	lda.w temp2b,x
	sta.b d0
	jml.l doplayeracc
unusedFF88:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
