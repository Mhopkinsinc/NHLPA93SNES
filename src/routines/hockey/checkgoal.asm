checkgoal:		;look for coll with goal/net. a2 = goal struct, a3 = object, d2/d3 = x/y. Called from checkwallcoll
		;   SNES: collision with the goal/net. a2 = goal object, X = object, d2/d3 = x/y. Not the puck: checkgoalp. Puck in the goal area: over the top
		;   (Zvel), through the mouth (Goal), off a post (deflect) or off the side/back (wallcoll)
	lda.w Zpos,x		; Zpos > 13 (goal height): over the goal
	sec
	sbc.w #$000D
	beq .z
	bmi .v1
	bvs .z
.ex1:
	jmp.w .rtl
.v1:
	bvs .ex1
.z:
	cpx.w #puckobj		; not the puck: checkgoalp
	beq .puck
	jmp.w checkgoalp
.puck:		;puck: inside |dx| <= 16+wcradiusx and |dy| <= 4+wcradiusy?
	ldy.b a2		; d2 = x - goal x
	lda.w #$0010
	clc
	adc.w wcradiusx
	sta.b d4
	lda.b d2
	sec
	sbc.w Xpos,y
	sta.b d2
	sec
	sbc.b d4
	beq .xl
	bmi .v2
	bvs .xl
.ex2:
	jmp.w .rtl
.v2:
	bvs .ex2
.xl:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	bmi .v3
	bvc .yh
.ex3:
	jmp.w .rtl
.v3:
	bvc .ex3
.yh:
	lda.w #$0004
	clc
	adc.w wcradiusy
	sta.b d5
	lda.b d3
	sec
	sbc.w Ypos,y
	sta.b d3
	sec
	sbc.b d5
	beq .yl
	bmi .v4
	bvs .yl
.ex4:
	jmp.w .rtl
.v4:
	bvs .ex4
.yl:
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	lda.b d3
	sec
	sbc.b d5
	bmi .v5
	bvc .inside
.ex5:
	jmp.w .rtl
.v5:
	bvc .ex5
.inside:		;inside the goal area now
	lda.w #$FFFF		; collflag
	sta.b collflag
	lda.w OldZpos+puckobj
	sec
	sbc.w #$000D
	bmi .v6
	bvc .over
	bra .nod
.v6:
	bvc .nod
.over:		;OldZpos >= 13: came over the top
	lda.w OldZpos+puckobj
	sta.w Zpos+puckobj
	jmp.w .deflectz
.nod:		;pfgoal of the puck = the carrier shot into his own goal
	stz.w pfgoal+puckobj
	lda.w puckc		; carrier: loses the puck, nopuck 8
	bmi .nocon
	asl a
	tay
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0008
	sta.w nopuck,y
	lda.w pucky
	sta.b d1
	lda.w pfgoal,y
	bne .an
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.an:
	lda.b d1
	bpl .nocon
	lda.w #$0001
	sta.w pfgoal+puckobj
.nocon:		;d0 = -256 (top entry: +256)
	lda.w #$FF00		; d1 = (Ypos - OldYpos) >> 8
	sta.b d0
	lda.w Yfrac,x
	sec
	sbc.w OldYfrac,x
	sta.b d1
	lda.w Ypos,x
	sbc.w OldYpos,x
	sta.b d1+2
	lda.b d1+1
	sta.b d1
	bne .dy
	jmp.w .sideentry
.dy:
	bmi .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
.0:		;d5 = dy at entry; d2 -= dx*dy/vy: x where the puck crossed the goal line
	lda.b d5
	clc
	adc.b d3
	sta.b d5
	sta.b mulb
	lda.w Xfrac,x		; d3 = (Xpos - OldXpos) >> 8; d5*d3
	sec
	sbc.w OldXfrac,x
	sta.b d3
	lda.w Xpos,x
	sbc.w OldXpos,x
	sta.b d3+2
	lda.b d3+1
	sta.b d3
	sta.b mula
	jsl.l muls32
	lda.b d1		; |d5*d3| < |d1|? else side entry
	bit.w #$8000
	beq .m1
	eor.w #$FFFF
	inc a
.m1:
	sta.b mula
	lda.b mulres+2
	bit.w #$8000
	beq .m2
	eor.w #$FFFF
	inc a
.m2:
	cmp.b mula
	bcc .dv
	jmp.w .sideentry
.dv:
	lda.b d1
	sta.b mula
	jsl.l divs		; d5 = d5*d3 / d1
	sta.b d5
	lda.b d2
	sec
	sbc.b d5
	sta.b d2
	sec
	sbc.b d4
	bmi .v7
	bvc .xl2
.se1:
	jmp.w .sideentry
.v7:
	bvc .se1
.xl2:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	beq .mouth
	bmi .v8
	bvs .mouth
.se2:
	jmp.w .sideentry
.v8:
	bvs .se2
.mouth:		;crossed between the posts
	stz.b d1
	lda.w pucky		; puck on the back side: wallcoll
	eor.b d0
	bpl .pf
	jmp.w wallcoll
.pf:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfgoal+puckobj		; own goal by the carrier: wallcoll
	beq .z13
	jmp.w wallcoll
.z13:		;at the crossbar height: off the post
	lda.w Zpos+puckobj
	cmp.w #$000D
	beq .deflectsf
	lda.b d4		; mouth = half width - 5
	sec
	sbc.w #$0005
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	beq .ml
	bmi .v9
	bvs .ml
	bra .deflectsf
.v9:
	bvs .deflectsf
.ml:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	bmi .v10
	bvs .deflectsf
.goal:
	jmp.w Goal
.v10:
	bvs .goal
.deflectsf:		;off the post
	jsl.l ChkShotStat		; off the post: sfx and crowd +300
	lda.w #SFXpuckpost
	pha
	jsl.l sfx
	lda.b crowdlevel
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w #$1000		; random Yvel away from the goal, Xvel/Zvel +-$1000
	jsl.l randoma
	sta.b d0
	lda.w pucky
	bmi .df0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.df0:
	lda.b d0
	sta.w puckvy
	lda.w #$2000
	jsl.l randoma
	sec
	sbc.w #$1000
	sta.w puckvx
	lda.w #$2000
	jsl.l randoma
	sec
	sbc.w #$1000
	sta.w puckvz
	jmp.w puckflip
.deflectz:		;Zvel = |Zvel|
	lda.w puckvz
	bit.w #$8000
	beq .dz
	eor.w #$FFFF
	inc a
.dz:
	sta.w puckvz
.rtl:
	rtl
.sideentry:		;off the side: wallcoll with normal (0, +-256)
	stz.b d0
	lda.w #$0100		; d1 = +-256 by the x movement
	sta.b d1
	lda.w puckx
	sec
	sbc.w OldXpos+puckobj
	sta.b d2
	bmi .wc
	lda.w #$FF00
	sta.b d1
.wc:
	jmp.w wallcoll
