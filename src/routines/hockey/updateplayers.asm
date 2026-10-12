updateplayers:		;animation, velocity, position, input and the assignment for every sort object
	ldx.w #$0016		; 12 players
.spd:		;pspeed = max($1000, (|Xvel|+|Yvel|)*5/4) for the 12 players
	lda.w Xvel,x
	bit.w #$8000
	beq .vx
	eor.w #$FFFF
	inc a
.vx:
	sta.b tmp0
	lda.w Yvel,x
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	clc
	adc.b tmp0
	sta.b tmp0
	lsr a
	lsr a
	adc.b tmp0
	cmp.w #$1000
	bcs .setspd
	lda.w #$1000
.setspd:
	sta.w pspeed,x
	dex
	dex
	bpl .spd
	lda.w sfhormode		; vertical rink: PadControlBits |= $F
	bne .scload
	lda.w #$000F
	tsb.w PadControlBits
.scload:
	ldx.w #$0000
	stx.b a3
.top:		;each object: old position = position
	lda.w Xpos,x
	sta.w OldXpos,x
	lda.w Xfrac,x
	sta.w OldXfrac,x
	lda.w Ypos,x
	sta.w OldYpos,x
	lda.w Yfrac,x
	sta.w OldYfrac,x
	lda.w Zpos,x
	sta.w OldZpos,x
	lda.w Zfrac,x
	sta.w OldZfrac,x
	lda.w position,x		; not on the ice
	bpl .onice
	jmp.w .nf1
.onice:
	jsl.l updateanim		; updateanim
	lda.w nopuck,x		; nopuck, nopuckb count down
	sec
	sbc.b d7
	bpl .np
	lda.w #$0000
.np:
	sta.w nopuck,x
	lda.w nopuckb,x
	sec
	sbc.b d7
	bpl .np2
	lda.w #$0000
.np2:
	sta.w nopuckb,x
	lda.w sflags3		; sflags3 bit 5: count frames on ice (loadTeamStruct)
	bit.w #sf3icetime
	beq .vel
	lda.w pnum,x
	and.w #$00FF
	bit.w #$0080
	beq .pn
	ora.w #$FF00
.pn:
	sta.b d0
	cmp.w #$0000
	bmi .vel
	asl.b d0
	jsl.l loadTeamStruct
.vel:
	lda.w SPA,x
	cmp.w #SPAinjury1		; SPAinjury1: no movement
	bne .slow
	jmp.w .done
.slow:
	lda.w Zpos,x		; on the ice: decelerate
	bne .x2
	ldx.b d7
.hang:		;d7 >= 10: hang
	cpx.w #$000A
	bcs .hang
	lda.l .decel-1,x		; per-frame factor
	and.w #$00FF
	sta.b d2
	lda.l .decel2-1,x
	sta.b d2+2
	ldx.b a3
	lda.w pflags,x
	bit.w #pfdoff		; pfdoff: less deceleration
	beq .off
	lda.b d2+2
	and.w #$00FF
	sta.b d2
.off:
	lda.w Xvel,x
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1		; velocity = velocity * factor / 256
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1
	sta.w Yvel,x
.x2:		;Xpos += Xvel*velstep (/4 in horizontal mode except in the penalty box)
	lda.w Xvel,x
	beq .y2
	sta.b mula
	lda.b velstep
	sta.b mulb
	lda.w sfhormode
	beq .x3
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #apenalty		; apenalty: full speed
	beq .x3
	lsr.b mulb
	lsr.b mulb
.x3:
	jsl.l muls32
	adc.w Xfrac,x
	sta.w Xfrac,x
	lda.w Xpos,x
	adc.b mulres+2
	sta.w Xpos,x
.y2:
	lda.w Yvel,x
	beq .z
	sta.b mula
	lda.b velstep
	sta.b mulb
	lda.w sfhormode
	beq .y3
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #apenalty
	beq .y3
	lsr.b mulb
	lsr.b mulb
.y3:
	jsl.l muls32
	adc.w Yfrac,x
	sta.w Yfrac,x
	lda.w Ypos,x
	adc.b mulres+2
	sta.w Ypos,x
.z:		;height: gravity and the bounce off the ice
	lda.w Zpos,x
	bmi .done
	bne .z1
	lda.w Zvel,x
	beq .done
.z1:
	lda.b velstep
	sta.b mula
	lda.w Zvel,x		; Zvel -= gravstep
	sec
	sbc.b gravstep
	sta.w Zvel,x
	sta.b mulb
	jsl.l muls32
	adc.w Zfrac,x
	sta.w Zfrac,x
	lda.w Zpos,x
	adc.b mulres+2
	sta.w Zpos,x
	bpl .done
	stz.w Zpos,x		; bounce off the ice: Zvel = -Zvel/2
	stz.w Zfrac,x
	lda.w Zvel,x
	eor.w #$FFFF
	inc a
	lsr a
	sta.w Zvel,x
	sec
	sbc.w #$0200		; bounce sound when Zvel >= $200
	bmi .neg
	bvc .bsnd
	bra .done
.neg:
	bvc .done
.bsnd:
	lda.w seed
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
.done:
	txa
	lsr a
	sta.b d6
	cmp.w puckc		; puck carrier (not fighting, vertical): setpads
	bne .tp
	lda.w pf2fight,x
	bne .tp
	lda.w sfhormode
	bne .tp
	lda.w #-2		; d4 = -2: pad index of the puck carrier
	sta.b d4
	jsl.l setpads
.tp:
	lda.b d6
	cmp.w c1playernum		; controller 1 player: doinput
	bne .t0
	jsl.l Readjoy1
	stz.b d4
	jsl.l doinput
	bra .t1
.decel:		;deceleration factor /256 per d7 (1-10): normal
	db $F7,$F5,$F2,$EF,$EC,$E9,$E6,$E3,$E1,$DE
.decel2:		;with pfdoff
	db $FF,$FF,$FE,$FE,$FE,$FD,$FD,$FD,$FC,$FC
.t0:
	cmp.w c2playernum
	bne .t1
	jsl.l Readjoy2
	lda.w #$0002
	sta.b d4
	jsl.l doinput
.t1:		;call the assignment through asstab and jmlvector
	lda.w pfalock,x
	bne .cc
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y		; current assignment
	and.w #$00FF
.hang2:
	cmp.w #$001D		; bad assignment: hang
	bcs .hang2
	asl a
	asl a
	tax
	lda.l asstab,x		; asstab entry into jmlvector
	sta.w jmlvector+1
	lda.l asstab+1,x
	sta.w jmlvector+2
	ldx.b a3
	jsl.l loadTeamStruct		; loadTeamStruct, then the assignment
	jsl.l jmlvector
.cc:
	lda.w Ypos,x
	sta.b d3
	stz.w Wallcos,x		; Wallcos = Wallsin = 0
	stz.w Wallsin,x
	lda.w Xpos,x
	sta.b d2
	cmp.w OldXpos,x
	bne .moved
	lda.b d3
	cmp.w OldYpos,x
	bne .moved
	jmp.w .nf
.moved:		;moved at least 1 pixel: checkcoll
	jsl.l checkcoll
	cpx.w #$0018		; only players
	bcs .nf
	lda.w position,x
	beq .nf
	lda.w pflags,x
	and.w #pf2npc		; pf2npc or horizontal: no goal check
	ora.w sfhormode
	bne .nf
	lda.w Xpos,x
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0019		; |x| < 25
	bcs .nf
	lda.w Ypos,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	sec
	sbc.w #$010D		; crossing y = +-269 (the goal line)?
	sta.b tmp0
	lda.w OldYpos,x
	bit.w #$8000
	beq .oy
	eor.w #$FFFF
	inc a
.oy:
	sec
	sbc.w #$010D
	eor.b tmp0
	bmi .back
	lda.w Ypos,x
	bit.w #$8000
	beq .gl
	eor.w #$FFFF
	inc a
.gl:
	cmp.w #$0103		; 259 <= |y| < 279
	bcc .nf
	cmp.w #$0117
	bcs .nf
.back:		;do not skate into the goal: old position
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
.nf:		;impact decays; limpact = impact
	lda.w impact,x
	sec
	sbc.b impactstep
	bpl .nf1
	lda.w #$0000
.nf1:
	sta.w impact,x
	sta.w limpact,x
	lda.w frame,x		; frames $173-$178: x kept within +-$60
	cmp.w #$0173
	bcc .next
	cmp.w #$0179
	bcs .next
	lda.w Xpos,x
	sec
	sbc.w #$FFA0
	beq .cl1
	bmi .neg1
	bvs .cl1
	bra .cx
.neg1:
	bvs .cx
.cl1:
	lda.w #$FFA0
	sta.w Xpos,x
.cx:
	lda.w Xpos,x
	sec
	sbc.w #$0060
	bmi .neg2
	bvc .cl2
	bra .next
.neg2:
	bvc .next
.cl2:
	lda.w #$0060
	sta.w Xpos,x
.next:
	inx
	inx
	stx.b a3
	cpx.w #$0020		; all 16 objects
	beq .lim
	jmp.w .top
.lim:		;players faster than pspeed are slowed to it
	ldx.w #$0016
.lim1:
	lda.w Xvel,x
	bit.w #$8000
	beq .lvx
	eor.w #$FFFF
	inc a
.lvx:
	sta.b tmp0
	lda.w Yvel,x
	bit.w #$8000
	beq .lvy
	eor.w #$FFFF
	inc a
.lvy:
	clc
	adc.b tmp0
	cmp.w pspeed,x
	bcc .lnext
	sta.b tmp0
	lda.w Xvel,x
	sta.b mula
	lda.w pspeed,x
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sta.b mula
	jsl.l divs
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w pspeed,x
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sta.b mula
	jsl.l divs
	sta.w Yvel,x
.lnext:
	dex
	dex
	bpl .lim1
	lda.w Zpos+puckobj		; puck below 24: keep it inside the boards
	cmp.w #$0018
	bcs .py
	lda.w puckx
	sec
	sbc.w #$FF78		; x >= -$88
	bmi .neg3
	bvs .px1
	bra .px2
.neg3:
	bvs .px2
.px1:
	lda.w #$FF78
	sta.w puckx
.px2:
	lda.w puckx
	sec
	sbc.w #$0088		; x <= $88
	beq .py
	bmi .neg4
	bvc .px3
	bra .py
.neg4:
	bvc .py
.px3:
	lda.w #$0088
	sta.w puckx
.py:		;puck on the ice within |y| < 318: keep it inside the boards
	lda.w Zpos+puckobj
	bne .cy
	lda.w pucky
	bit.w #$8000
	beq .py1
	eor.w #$FFFF
	inc a
.py1:
	cmp.w #$013E
	bcs .cy
	lda.w pucky
	sec
	sbc.w #$FEDB		; y >= -$125
	bmi .neg5
	bvs .py2
	bra .py3
.neg5:
	bvs .py3
.py2:
	lda.w #$FEDB
	sta.w pucky
.py3:
	lda.w pucky
	sec
	sbc.w #$012A		; y <= $12A
	beq .cy
	bmi .neg6
	bvc .py4
	bra .cy
.neg6:
	bvc .cy
.py4:
	lda.w #$012A
	sta.w pucky
.cy:		;carried: carriedy = pucky
	lda.w puckc
	bmi .rtl
	lda.w pucky
	sta.w carriedy
.rtl:
	rtl
