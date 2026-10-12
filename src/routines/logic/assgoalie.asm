assgoalie:		;asstab $E. Player a3 is goalie. Also entered from assnearest
		;   SNES: goalie X. Skate back to the crease, hold/pass the puck, cover a loose puck, follow the puck and lead it, saves
		;   (GoalieSaveList), hug the post, rush a loose puck (agoalietopuck)
	lda.w pfalock,x		; anim locked: nothing
	beq .go
	jmp.w .rtl
.go:
	jsl.l check4bench
	lda.w pflags,x		; new assignment: temp1/temp2 = 0, temp2b = 8, temp4 = -1
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #$FFFF
	sta.w temp4,x
.nna:
	lda.w Xpos,x		; outside the crease area: skate back
	bit.w #$8000
	beq .crx
	eor.w #$FFFF
	inc a
.crx:
	cmp.w #$0035
	bcs .skate
	lda.w Ypos,x
	bit.w #$8000
	beq .cry
	eor.w #$FFFF
	inc a
.cry:
	cmp.w #$010F
	bcs .skate
	cmp.w #$00D3
	bcs .noskate
.skate:		;skate back to the net (callback rtss)
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #$0004
	sta.b d0
	lda.w Xpos,x
	bpl .0
	lda.w #$FFFC
	sta.b d0
.0:
	lda.w #$00E4
	sta.b d1
	lda.w pfgoal,x
	beq .sk
	lda.w #$FF1C
	sta.b d1
.sk:
	jml.l skateto		; d0/d1 = target, a0 = callback
.noskate:
	lda.w pf2aip,x		; pf2aip: nothing
	beq .gready
	jmp.w .rtl
.gready:
	lda.w #SPAgready
	sta.b d1
	jsl.l SetSPA
	lda.w gmclock		; clock stopped: nothing
	beq .clk
	jmp.w .rtl
.clk:
	lda.w temp5,x		; temp5 = holding time
	bmi .nofo
	lda.w SCnum,x
	sta.b d0
	cmp.w puckc
	beq .mbfo
	lda.w #$FFFF
	sta.w temp5,x
	bra .nofo
.mbfo:		;holding the puck: PenGhold when temp5 runs out
	lda.w temp5,x
	sec
	sbc.b d7
	sta.w temp5,x
	bpl .nofo
	lda.w #PenGhold
	sta.b d0
	jsl.l AddPenalty2
.nofo:
	lda.w temp1,x		; every aidef/4 frames
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	lda.w aidef,x
	lsr a
	lsr a
	clc
	adc.w temp1,x
	bpl .st1
	lda.w #$0000
.st1:
	sta.w temp1,x
	lda.w pflags,x		; joystick goalie: only .cover
	bit.w #pfjoycon
	beq .half
	jmp.w .cover
.half:
	lda.w pucky		; puck in the other half: stay at the top of the crease (y +-$F4)
	sta.b d0
	lda.w Ypos,x
	eor.b d0
	sta.b d1
	bpl .cnt
	stz.b d0
	lda.w #$00F4
	sta.b d2
	lda.w pfgoal,x
	bne .other
	jmp.w .de5
.other:
	lda.w #$FF0C
	sta.b d2
	jmp.w .de5
.cnt:		;puck in my half
	dec.w temp4,x
	bpl .pc
	lda.w #$FFFF
	sta.w temp4,x
.pc:
	lda.w SCnum,x
	cmp.w puckc
	beq .hold0
	jmp.w .cover
.hold0:
	lda.w temp5,x		; 90 frames before the holding penalty
	bpl .hold
	lda.w #$005A
	sta.w temp5,x
.hold:
	lda.w #$FFFF
	sta.w temp4,x
	lda.w temp5,x
	sec
	sbc.w #$005A
	beq .roll
	bmi .v1
	bvs .roll
.de1j:
	jmp.w .de1
.v1:
	bvs .de1j
.roll:
	lda.w #$0064		; 1 in 4: pass
	jsl.l randoma
	cmp.w #$004B
	bcs .pass
	jmp.w .de1
.pass:
	lda.w #$0005
	sta.b d0
	stz.b a0
	lda.w pfteam,x
	bne .tl
	lda.w #$000C
	sta.b a0
.tl:		;pass only if no opponent is near the puck
	ldy.b a0
	lda.w pflags,y
	bit.w #pf2unav
	bne .tn
	lda.w pucky
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .tly
	eor.w #$FFFF
	inc a
.tly:
	cmp.w #$001D
	bcs .tn
	lda.w puckx
	sec
	sbc.w Xpos,y
	bit.w #$8000
	beq .tlx
	eor.w #$FFFF
	inc a
.tlx:
	cmp.w #$001A
	bcs .tn
	jmp.w .de1
.tn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .tl
	lda.w #$0001		; threat = 1, chk4pass
	sta.w threat
	jsl.l chk4pass
	bra .de1
.cover:		;cover a loose puck at the crease
	lda.w temp4,x
	bne .de1
	lda.w puckc
	bpl .de1
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	bit.w #$8000
	beq .cvx
	eor.w #$FFFF
	inc a
.cvx:
	cmp.w #$0015
	bcs .de1
	lda.w pucky
	sta.b d1
	bit.w #$8000
	beq .cvy
	eor.w #$FFFF
	inc a
.cvy:
	cmp.w #$0109
	bcs .de1
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .cvd
	eor.w #$FFFF
	inc a
.cvd:
	cmp.w #$001F
	bcs .de1
	jsl.l vtoa
	lda.b d0
	sta.w facedir,x		; facedir to the puck, nopuck 8, cover anim, pf2aip, crowd +150
	lda.w #$0008
	sta.w nopuck,x
	lda.w #SPAgdive
	sta.b d1
	jsl.l SetSPA
	lda.w #$0096
	sta.w pf2aip,x
	clc
	adc.b crowdlevel
	sta.b crowdlevel
.rtl:
	rtl
.de1:		;a0 = puckcross entry of my goal, d3 = goal line
	lda.w #puckcross
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #$0104
	sta.b d3
	lda.w pfgoal,x
	beq .de2
	lda.w #puckcross+4
	sta.b a0
	lda.w #$FEFC
	sta.b d3
.de2:
	lda.w Ypos,x		; out of the crease in y: behind the goal line
	bit.w #$8000
	beq .de2y
	eor.w #$FFFF
	inc a
.de2y:
	cmp.w #$0105
	bcs .out
	lda.w puckx		; face the puck: ClampYPosition, vtoa, AdjustFacingDirection
	sta.b d0
	lda.w pucky
	sta.b d1
	jsl.l ClampYPosition
	lda.b d1
	bit.w #$8000
	beq .near
	eor.w #$FFFF
	inc a
.near:
	cmp.w #$002E
	bcs .in
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	lda.b $01,s
	sta.b d0
	lda.b $03,s
	sta.b d1
	jmp.w .sq
.out:		;behind the goal line
	stz.b d2
	stz.b d0
	lda.w Xpos,x
	bit.w #$8000
	beq .outx
	eor.w #$FFFF
	inc a
.outx:
	cmp.w #$002D
	bcc .out2
	jmp.w .de5
.out2:
	lda.w #$0088
	sta.b d0
	lda.w Xpos,x
	bmi .outn
	jmp.w .de5
.outn:
	lda.w #$FF78
	sta.b d0
	jmp.w .de5
.in:		;face the puck, lead it by its velocity
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	lda.w puckvy		; lead the puck by its velocity (/2 near the ends)
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .iy
	ora.w #$FF80
.iy:
	clc
	adc.w pucky
	sta.b d1
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ix
	ora.w #$FF00
.ix:
	sta.b d0
	lda.b d1
	sec
	sbc.w #$00E0
	beq .lo
	bmi .v2
	bvs .lo
	bra .lead2
.v2:
	bvs .lead2
.lo:
	lda.b d1
	sec
	sbc.w #$FF20
	beq .lead2
	bmi .v3
	bvs .lead2
	bra .lead
.v3:
	bvs .lead
.lead2:
	lda.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0
.lead:
	lda.b d0
	clc
	adc.w puckx
	sta.b d0
	jsl.l ClampYPosition
	lda.b d1
	pha
	lda.b d0
	pha
.sq:
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d0
	adc.b d1
	sta.b d0
	lda.b d0+2
	adc.b d1+2
	sta.b d0+2
	lda.b d0		; distance^2 < 30*30: stay
	cmp.w #$0385
	lda.b d0+2
	sbc.w #$0000
	bcs .far
	pla
	sta.b d0
	pla
	sta.b d1
	bra .de4
.far:		;scale to a 20 (28 if shooting) pixel arc
	jsl.l sroot
	lda.b d0
	inc a
	sta.b d2
	lda.w #$0014
	sta.b d4
	lda.w sflags
	bit.w #sfssdir
	beq .f0
	lda.w #$001C
	sta.b d4
.f0:
	pla
	sta.b d0
	pla
	sta.b d1
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d1
	lda.b d4
	adc.w #$0006
	sta.b d4
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d0
.de4:
	lda.b d1
	clc
	adc.b d3
	sta.b d1
	sta.b d2
	ldy.w #$0002		; puckcross frames til crossing < $14?
	lda.b [a0],y
	cmp.w #$0014
	bcc .cross
	jmp.w .de5
.cross:		;puck crossing the goal line soon?
	lda.b [a0]
	bit.w #$8000
	beq .cx
	eor.w #$FFFF
	inc a
.cx:
	cmp.w #$0019
	bcc .cz
	jmp.w .rush
.cz:
	lda.b [a0],y
	cmp.w #$000C
	bcc .cy
	jmp.w .de8
.cy:
	lda.w pucky
	bit.w #$8000
	beq .cy2
	eor.w #$FFFF
	inc a
.cy2:
	cmp.w #$0109
	bcc .aip
	jmp.w .de8
.aip:
	lda.w pf2aip,x
	beq .saveanim
	jmp.w .de8
.saveanim:		;pick the save anim: glove side by the direction, stick when low and slow, stack
	inc.w pf2aip,x
	lda.b [a0]
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d3
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d3
	lsr a
	lsr a
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .noflip
	lda.b d0
	eor.w #$0001
	sta.b d0
.noflip:
	lda.w Zpos+puckobj		; puck low (Zpos <= 8) and slow: stick (+4)
	sec
	sbc.w #$0008
	beq .pz
	bmi .v4
	bvs .pz
	bra .de7
.v4:
	bvs .de7
.pz:
	lda.w puckvz
	sec
	sbc.w #$0800
	beq .stick
	bmi .v5
	bvs .stick
	bra .de7
.v5:
	bvs .de7
.stick:
	lda.b d0
	clc
	adc.w #$0004
	sta.b d0
	ldy.w #$0002		; more than 8 frames, facing up/down, puck carried: stack (-2)
	lda.b [a0],y
	cmp.w #$0009
	bcc .de7
	lda.w facedir,x
	cmp.w #$0002
	beq .de7
	cmp.w #$0006
	beq .de7
	lda.w puckc
	bmi .de7
	dec.b d0
	dec.b d0
.de7:
	asl.b d0
	lda.w #GoalieSaveList
	sta.b a1
	lda.w #GoalieSaveList>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b d1
	jsl.l SetSPA
	lda.b crowdlevel		; crowd +150
	clc
	adc.w #$0096
	sta.b crowdlevel
.de8:
	lda.b [a0]
	sta.b d0
	lda.w pucky		; puck near the goal line: hug the post (+-$18)
	sec
	sbc.w #$00FC
	beq .p2
	bmi .v6
	bvs .p2
	bra .post
.v6:
	bvs .post
.p2:
	lda.w pucky
	sec
	sbc.w #$FF04
	beq .post
	bmi .v7
	bvs .post
	bra .de5
.v7:
	bvs .de5
.post:		;hug the post
	lda.w #$0018
	sta.b d0
	lda.w puckx
	bpl .de5
	lda.w #$FFE8
	sta.b d0
.de5:		;skate toward d0/d2 minus the velocity
	lda.b d2
	sta.b d1
	pha
	lda.b d0
	pha
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx
	ora.w #$FF00
.vx:
	eor.w #$FFFF
	inc a
	sta.b d0
	pla
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vy
	ora.w #$FF00
.vy:
	eor.w #$FFFF
	inc a
	sta.b d1
	pla
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.w #$0005		; within 5 (10 with the puck): stop
	sta.b tmp0
	txa
	lsr a
	cmp.w puckc
	bne .near2
	asl.b tmp0
.near2:
	lda.b d0
	bit.w #$8000
	beq .nx
	eor.w #$FFFF
	inc a
.nx:
	cmp.b tmp0
	bcs .vt
	lda.b d1
	bit.w #$8000
	beq .ny
	eor.w #$FFFF
	inc a
.ny:
	cmp.b tmp0
	bcs .vt
	stz.b d0
	stz.b d1
.vt:
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x
.nodec:
	lda.w temp2b,x		; direction > 7: StopNA, else playeracc
	sta.b d2
	sec
	sbc.w #$0007
	beq .acc
	bmi .v8
	bvc .stop
.acc:
	jml.l playeracc
.v8:
	bvc .acc
.stop:
	jmp.w StopNA
.rush:		;rush a loose puck when the tmnear stats say so
	lda.w puckc
	bmi .r1
	jmp.w .de5
.r1:
	lda.w iflags		; icing possible: no rush
	bit.w #ifok
	beq .r2
	jmp.w .de5
.r2:
	stz.b a1
	lda.w #$0002
	sta.b a2
	lda.w pfteam,x
	beq .t0
	stz.b a2
	lda.w #$0002
	sta.b a1
.t0:
	ldy.b a1		; tmnear of my team >= $1324 and of the other >= $9C4
	lda.w tmnear,y
	cmp.w #$1324
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .t1
	jmp.w .de5
.t1:
	ldy.b a2
	lda.w tmnear,y
	cmp.w #$09C4
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .r3
	jmp.w .de5
.r3:
	lda.w pucky		; puck near my end, moving toward me, mostly in y
	sbc.w #$00E0
	beq .r4
	bmi .v9
	bvs .r4
	bra .dir
.v9:
	bvs .dir
.r4:
	lda.w pucky
	sec
	sbc.w #$FF20
	beq .dir
	bmi .v10
	bvs .dir
.de5j:
	jmp.w .de5
.v10:
	bvs .de5j
.dir:
	lda.w puckvy
	sta.b tmp0
	lda.w pfgoal,x
	beq .dir2
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.dir2:
	lda.b tmp0
	bpl .toward
	jmp.w .de5
.toward:
	lda.w puckvx
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	sta.b d0
	lda.w puckvy
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	sta.b d1
	lda.b d1
	cmp.b d0
	bcs .ins
	jmp.w .de5
.ins:
	lda.w #agoalietopuck		; agoalietopuck
	sta.b d0
	jmp.w assinsert
