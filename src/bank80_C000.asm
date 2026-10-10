; $80C18F-$80CEE6  ROM $0418F-$04EE6: AddPenalty/AddPenalty2 (penalty93_1), freezewindow, sfx, updatereplay, demoread and the joypad
; readers (hockey93_01/middle93_1), updateplayers (hockey93_02), checkcoll, checkwallcoll, wallcollb, wallcoll (hockey93_03/04),
; sroot, divu, puckflip.
org $80C18F
AddPenalty:		;auto: CODE_80C18F. 93G AddPenalty (penalty93_1): add penalty d0 (PenaltyList offset) for player X. Ignored while the clock is stopped, when penalties are off, or offsides when offsides
		;   are off. Falls into AddPenalty2
	lda.w gmclock		; clock stopped
	bne .rtl
	lda.b d0
	cmp.w #PenIcing		; icing always counts
	beq AddPenalty2
	lda.w OptPen		; penalties off
	beq .rtl
	lda.w gmode
	bit.w #gmoffs		; offsides on: all count
	bne AddPenalty2
	lda.b d0
	cmp.w #PenOffsides		; offsides off: no offsides penalty
	bne AddPenalty2
.rtl:
	rtl
AddPenalty2:		;auto: CODE_80C1B0. 93G AddPenalty2 (penalty93_1): forced penalties like face off and game over. d0 = penalty, X = player or a player of the penalized team
	lda.w sfhormode		; horizontal rink: none
	beq .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.b d0
	sec
	sbc.w #$000E		; goal (93G $E) and up
	bmi .v1
	bvc .snd
	bra .nosnd
.v1:
	bvc .nosnd
.snd:		;goal and up: crowd and a sound
	lda.b crowdlevel		; crowd +200
	clc
	adc.w #$00C8
	sta.b crowdlevel
	lda.w #SFXcrowdboo		; home penalized: boo; visitors: cheer
	pha
	lda.w pfteam,x
	beq .sfx
	lda.w #SFXcrowdcheer
	sta.b $01,s
.sfx:
	jsl.l sfx
.nosnd:
	lda.w #PenBuf		; a1 = PenBuf, 32 slots
	sta.b a1
	lda.w #PenBuf>>16
	sta.b a1+2
	lda.w #$001F
	sta.b d1
.find:		;find a free PenBuf slot
	lda.b [a1]
	inc.b a1
	inc.b a1
	tay
	beq .put
	dec.b d1
	bpl .find
	bra .noplayer
.put:
	dec.b a1
	dec.b a1
	txa		; store (SCnum << 8) | penalty
	lsr a
	xba
	and.w #$FF00
	ora.b d0
	sta.b [a1]
	lda.w #PenaltyList>>16		; a0 = PenaltyList + [d0]
	sta.b a0+2
	lda.w #PenaltyList
	sta.b a0
	ldy.b d0
	clc
	adc.b [a0],y
	sta.b a0
	lda.b [a0]		; penalty minutes
	and.w #$00FF
	beq .noplayer
	lda.w pflags,x
	pha
	ora.w #pf2pen		; pf2pen; already set: drop this one
	sta.w pflags,x
	pla
	bit.w #pf2pen
	beq .noplayer
	lda.w #$0000
	sta.b [a1]
.noplayer:
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
	ldx.b xsave
.rtl:
	rtl
freezewindow:		;auto: CODE_80C278. 93G freezewindow (hockey93_02): lock scrolling at the current position
	lda.w Vpos		; yc1 = Vpos, xc1 = Hpos, sfslock
	sta.w yc1
	lda.w Hpos
	sta.w xc1
	lda.w #sfslock
	tsb.w sflags
	rtl
sfx:		;auto: CODE_80C28B. 93G sfx (middle93_1): play the sound number pushed before the jsl (it is pulled here). Dropped within 180 frames of sfxmutetime; remembered in lastsfx
	pla		; return address +1 into jmlvector
	inc a
	sta.w jmlvector+1
	sep #$20
	pla
	sta.w jmlvector+3
	rep #$20
	lda.b vcount		; sound effects muted?
	sec
	sbc.w sfxmutetime
	cmp.w #$00B4
	bcc .drop
	pla		; lastsfx = sound number
	sta.w lastsfx
	beq .ret
	jsl.l QueueSound		; queue it (bank $82)
.ret:		;return through jmlvector
	jml.l jmlvector
.drop:
	pla
	bra .ret
updatereplay:		;auto: CODE_80C2B4. 93G updatereplay (hockey93_02): save this frame into the replay buffer (positions, frames, players, puck, sound, pads, crowd, gloves, box, scroll)
	lda.w gmode
	bit.w #gmhl		; gmhl: no recording
	beq .rec
	jmp.w .rtl
.rec:
	lda.w sflags
	bit.w #sf2drec		; sf2drec: keep overwriting the same frame
	bne .save
	lda.w ReplayBufferPtr		; next record (113 bytes)
	clc
	adc.w #$0071
	sta.w ReplayBufferPtr
	bcc .wrap
	inc.w ReplayBufferPtr+2
.wrap:
	cmp.w #ReplayBufferEnd&$FFFF
	bne .save
	lda.w ReplayBufferPtr+2
	cmp.w #ReplayBufferEnd>>16
	bne .save
	lda.w #sfwrap		; wrapped: sfwrap, back to the start
	tsb.w sflags
	lda.w #ReplayBufferStart&$FFFF
	sta.w ReplayBufferPtr
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
.save:
	lda.w ReplayBufferPtr
	sta.b a0
	lda.w ReplayBufferPtr+2
	sta.b a0+2
	lda.w #$000F
	sta.b d2
	ldx.w #$0000
	ldy.w #$0001
.obj:		;16 objects: x (12 bits) and y (12 bits), frame and flip bits
	lda.w #$0000
	sta.b [a0]
	sta.b [a0],y
	lda.w Xpos,x
	and.w #$0FFF
	sta.b [a0]
	inc.b a0
	lda.w Ypos,x
	asl a
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w frame,x
	and.w #$3FFF
	sta.b [a0]
	lda.w attribute,x
	and.w #$1800
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inc.b a0
	inx
	inx
	dec.b d2
	bpl .obj
	lda.w #$0005
	sta.b d2
	ldx.w #$0000
.pl:		;6 pairs: rostnum, positions
	lda.w rostnum,x
	sta.b [a0]
	inc.b a0
	lda.w rostnum+2,x
	sta.b [a0]
	inc.b a0
	lda.w position,x
	bpl .p1
	lda.w #$FFFF
.p1:
	and.w #$000F
	sta.b [a0]
	lda.w position+2,x
	bpl .p2
	lda.w #$FFFF
.p2:
	asl a
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inx
	inx
	inx
	inx
	dec.b d2
	bpl .pl
	lda.w Zpos+puckobj		; puck and shadow height, lastsfx, d7, PadControlBits, crowdframe, glovecords, PBnum, Hpos, Vpos
	sta.b [a0]
	inc.b a0
	lda.w Zpos+$1E
	sta.b [a0]
	inc.b a0
	lda.w lastsfx
	sta.b [a0]
	inc.b a0
	stz.w lastsfx
	lda.b d7
	sta.b [a0]
	inc.b a0
	lda.w PadControlBits
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.b crowdframe
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w glovecords
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w PBnum
	sta.b [a0]
	inc.b a0
	lda.w Hpos
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w Vpos
	sta.b [a0]
.rtl:
	rtl
demoread:		;auto: CODE_80C3D4. 93G demoread (hockey93_01): in demo mode (no controller team), Start pauses and any other button ends the demo
	lda.w cont1team		; a controller team: not a demo
	ora.w cont2team
	bne .rtl
	jsl.l Readjoy1
	lda.b d1
	bit.w #JOYSTART		; Start on pad 1: startpause1
	beq .any1
	jml.l startpause1		; bank $8F: 93G startpause1
.any1:
	lda.b d1
	bne .exit
	jsl.l Readjoy2
	lda.b d1
	bit.w #JOYSTART		; Start on pad 2: startpause2
	beq .any2
	jml.l startpause2
.any2:
	lda.b d1
	bne .exit
.rtl:
	rtl
.exit:		;end the demo: back to the title screen (93G ExitToOpening)
	jsl.l sndqreset		; sound queue reset; on to the title screen
	jml.l Opening		; bank $8B: on to the title screen (93G Opening)
Readjoy1:		;auto: CODE_80C40B. 93G Readjoy1 (middle93_1): read controller 1. d0 = direction, d1 = new presses, d2 = changed, d3 = held
	phx
	ldx.w #$0000
	jsl.l ReadJoy
	plx
	lda.w lj1		; d2 = changed, d3 = held, d1 = new presses
	sta.b d2
	lda.b d1
	sta.w lj1
	sta.b d3
	eor.b d2
	sta.b d2
	and.b d1
	sta.b d1
	rtl
Readjoy2:		;auto: CODE_80C429. 93G Readjoy2 (middle93_1): read controller 2
	phx
	ldx.w #$0002
	jsl.l ReadJoy
	plx
	lda.w lj2
	sta.b d2
	lda.b d1
	sta.w lj2
	sta.b d3
	eor.b d2
	sta.b d2
	and.b d1
	sta.b d1
	rtl
ReadJoy:		;auto: CODE_80C447. 93G ReadJoy (middle93_1): X = 0/2: d1 = buttons held, d0 = direction from jdtab
	lda.w joypad1,x		; buttons
	sta.b d0+2
	sta.b d1
	xba		; r/l/d/u bits
	and.w #$000F
	tax
	lda.l jdtab,x
	and.w #$00FF
	sta.b d0
	rtl
jdtab:		;93G jdtab (middle93_1): convert buttons r,l,d,u into directions 0-7, 8
	db 8,2,6,8,4,3,5,8,0,1,7,8,8,8,8,8
updateplayers:		;auto: CODE_80C46D. 93G updateplayers (hockey93_02): animation, velocity, position, input and the assignment for every sort object
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
	jsl.l loadTeamStruct		; bank $8F: 93G loadTeamStruct
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
	bmi .v1
	bvc .bsnd
	bra .done
.v1:
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
	lda.l asstab,x		; asstab (bank $8D) entry into jmlvector
	sta.w jmlvector+1
	lda.l asstab+1,x
	sta.w jmlvector+2
	ldx.b a3
	jsl.l loadTeamStruct		; loadTeamStruct, then the assignment, bank $8F: 93G loadTeamStruct
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
	bmi .v2
	bvs .cl1
	bra .cx
.v2:
	bvs .cx
.cl1:
	lda.w #$FFA0
	sta.w Xpos,x
.cx:
	lda.w Xpos,x
	sec
	sbc.w #$0060
	bmi .v3
	bvc .cl2
	bra .next
.v3:
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
	bmi .v4
	bvs .px1
	bra .px2
.v4:
	bvs .px2
.px1:
	lda.w #$FF78
	sta.w puckx
.px2:
	lda.w puckx
	sec
	sbc.w #$0088		; x <= $88
	beq .py
	bmi .v5
	bvc .px3
	bra .py
.v5:
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
	bmi .v6
	bvs .py2
	bra .py3
.v6:
	bvs .py3
.py2:
	lda.w #$FEDB
	sta.w pucky
.py3:
	lda.w pucky
	sec
	sbc.w #$012A		; y <= $12A
	beq .cy
	bmi .v7
	bvc .py4
	bra .cy
.v7:
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
checkcoll:		;auto: CODE_80C894. 93G checkcoll (hockey93_03): d2/d3 = new x/y of object X. Wall collision (hot spot, end of the stick), player collision, then keep OOlist sorted
	stz.b collflag		; collflag = 0
	lda.w sfhormode		; horizontal: exg d2,d3
	beq .nhor1
	lda.b d2
	ldy.b d3
	sta.b d3
	sty.b d2
.nhor1:
	lda.w pfnc,x		; pfnc: no collision
	beq .go
	jmp.w .ex
.go:		;movem d0-d6
	lda.b d6+2
	pha
	lda.b d6
	pha
	lda.b d5+2
	pha
	lda.b d5
	pha
	lda.b d4+2
	pha
	lda.b d4
	pha
	lda.b d3+2
	pha
	lda.b d3
	pha
	lda.b d2+2
	pha
	lda.b d2
	pha
	lda.b d1+2
	pha
	lda.b d1
	pha
	lda.b d0+2
	pha
	lda.b d0
	pha
	lda.w Xpos,x		; around the hot spot with the wall
	sta.b d2
	lda.w Ypos,x
	sta.b d3
	lda.w radiusx,x
	sta.w wcradiusx
	lda.w radiusy,x
	sta.w wcradiusy
	jsl.l checkwallcoll
	lda.w Wallcos,x		; wall hit: done
	ora.w Wallsin,x
	bne .xx
	cpx.w #$0018		; only players: the end of the stick
	bcs .xx
	lda.b $01,s
	sta.b d0
	lda.b $03,s
	sta.b d0+2
	lda.b $05,s
	sta.b d1
	lda.b $07,s
	sta.b d1+2
	lda.b $09,s
	sta.b d2
	lda.b $0B,s
	sta.b d2+2
	lda.b $0D,s
	sta.b d3
	lda.b $0F,s
	sta.b d3+2
	lda.b $11,s
	sta.b d4
	lda.b $13,s
	sta.b d4+2
	lda.b $15,s
	sta.b d5
	lda.b $17,s
	sta.b d5+2
	lda.b $19,s
	sta.b d6
	lda.b $1B,s
	sta.b d6+2
	txa
	jsl.l GetHot		; GetHot
	lda.w Xpos,x
	clc
	adc.b d0
	sta.b d2
	lda.w Ypos,x
	clc
	adc.b d1
	sta.b d3
	lda.w #$0001		; radius 1
	sta.w wcradiusx
	sta.w wcradiusy
	jsl.l checkwallcoll
.xx:
	pla
	sta.b d0
	pla
	sta.b d0+2
	pla
	sta.b d1
	pla
	sta.b d1+2
	pla
	sta.b d2
	pla
	sta.b d2+2
	pla
	sta.b d3
	pla
	sta.b d3+2
	pla
	sta.b d4
	pla
	sta.b d4+2
	pla
	sta.b d5
	pla
	sta.b d5+2
	pla
	sta.b d6
	pla
	sta.b d6+2
	jsl.l checkplcoll		; checkplcoll
.ex:
	lda.b collflag		; collflag: restore the old position
	beq .sort
	jmp.w .restoreold
.sort:
	lda.w OOlistpos,x		; move up/down OOlist by y
	sta.b d1
.up:
	ldy.b d1
	cpy.w #$000F
	beq .cl2
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	beq .cl2
	bmi .v1
	bvc .swapup
	bra .cl2
.v1:
	bvc .cl2
.swapup:
	inc.w OOlistpos,x
	lda.w OOlistpos,y
	dec a
	sta.w OOlistpos,y
	sep #$30
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist+1,y
	rep #$30
	inc.b d1
	bra .up
.cl2:
	lda.w OOlistpos,x
	beq .ex2
	sta.b d1
.dn:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	bmi .v2
	bvs .swapdn
	bra .ex2
.v2:
	bvs .ex2
.swapdn:
	dec.w OOlistpos,x
	lda.w OOlistpos,y
	inc a
	sta.w OOlistpos,y
	sep #$30
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist-1,y
	rep #$30
	dec.b d1
	bne .dn
.ex2:
	lda.b d3
	sta.w Ylist,x
	rtl
.restoreold:
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
	rtl
checkwallcoll:		;auto: CODE_80CA1D. 93G checkwallcoll (hockey93_04): d2/d3 = x/y, object X, wcradiusx/y. Corner circles, goals, then side and end boards
	lda.w #$012A		; d3 = $12A - wcradiusy, d2 = $88 - wcradiusx; corner centers 64 in
	sec
	sbc.w wcradiusy
	pha
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	sta.b d5
	lda.w #$0088
	sec
	sbc.w wcradiusx
	pha
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	sta.b d4
	lda.b d3
	pha
	ldy.b d2
	phy
	sec
	sbc.b d5
	beq .negy
	bmi .v1
	bvs .negy
	bra .ctc
.v1:
	bvs .ctc
.negy:
	lda.b d2
	sec
	sbc.b d4
	bmi .v2
	bvc .gl1
	bra .circle
.v2:
	bvc .circle
.gl1:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .v3
	bvc .goal13
	bra .circle
.v3:
	bvc .circle
.goal13:		;goal at the -y end (object 13)
	lda.w #$001A
	sta.b a2
	jsl.l checkgoal
	jmp.w .exit
.ctc:
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	sec
	sbc.b d3
	beq .c2
	bmi .v4
	bvs .c2
.exit1:
	jmp.w .exit
.v4:
	bvs .exit1
.c2:
	lda.b d2
	sec
	sbc.b d4
	bmi .v5
	bvc .c3
	bra .circle
.v5:
	bvc .circle
.c3:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .v6
	bvc .goal12
	bra .circle
.v6:
	bvc .circle
.goal12:		;goal at the +y end (object 12)
	lda.w #$0018
	sta.b a2
	jsl.l checkgoal
	jmp.w .exit
.circle:		;distance from the corner center (max+min/4)
	lda.b d2
	sec
	sbc.b d4
	sta.b d2
	eor.w #$FFFF
	inc a
	sta.b d1
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b mula
	lda.b d3
	sec
	sbc.b d5
	sta.b d0
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	sta.b mulb
	cmp.b mula
	bcc .m2
	lda.b mula
	lsr a
	lsr a
	adc.b mulb
	bra .dist
.m2:
	lsr a
	lsr a
	adc.b mula
.dist:
	cmp.w #$0041		; inside the radius 64 circle: no hit
	bcc .exit
	sta.b d3		; cos = dy*256/r, sin = dx*256/r
	sta.b mula
	stz.b mulb
	stz.b mulb+2
	lda.b d0
	sta.b mulb+1
	bpl .cos
	lda.w #$FFFF
	sta.b mulb+3
.cos:
	jsl.l divs
	sta.b d0
	lda.b d3
	sta.b mula
	stz.b mulb
	stz.b mulb+2
	lda.b d1
	sta.b mulb+1
	bpl .sin
	lda.w #$FFFF
	sta.b mulb+3
.sin:
	jsl.l divs
	sta.b d1
	jsl.l wallcollb
.exit:		;no corner hit: the side and end boards
	pla
	sta.b d2
	pla
	sta.b d3
	pla
	sta.b d4
	pla
	sta.b d5
	lda.w Wallcos,x		; corner hit: done
	ora.w Wallsin,x
	bne .rtl
	lda.w #$0100		; side walls: cos $100, sin 0
	sta.b d0
	stz.b d1
	lda.b d3
	sec
	sbc.b d5
	bmi .v7
	bvs .s1
.b1:
	jmp.w wallcollb
.v7:
	bvs .b1
.s1:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	sec
	sbc.b d3
	bmi .v8
	bvs .s2
.b2:
	jmp.w wallcollb
.v8:
	bvs .b2
.s2:
	lda.b d0
	pha
	lda.b d1
	sta.b d0
	pla
	sta.b d1
	lda.b d2
	sec
	sbc.b d4
	bmi .v9
	bvs .s3
.b3:
	jmp.w wallcollb
.v9:
	bvs .b3
.s3:
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .v10
	bvs .rtl
.b4:
	jmp.w wallcollb
.v10:
	bvs .b4
.rtl:
	rtl
sroot:		;auto: CODE_80CBB1. 93G sroot (middle93_1): d0 = sqrt(d0, 32-bit) by binary search on the square
	stz.b tmp0
	lda.w #$1000
	sta.b tmp1
.loop:
	lda.b tmp0
	clc
	adc.b tmp1
	ror a
	cmp.b tmp0
	beq .done
	sta.b tmp2
	sta.b mula
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b d0
	cmp.b mulres
	lda.b d0+2
	sbc.b mulres+2
	bcs .low
	lda.b tmp2
	sta.b tmp1
	bra .loop
.low:
	lda.b tmp2
	sta.b tmp0
	bra .loop
.done:
	sta.b d0
	rtl
divu:		;auto: CODE_80CBE5. 68k divu: A = mulres = mulb (32-bit) / mula; mulres+2 = remainder. C clear
	lda.b mula
	sta.b mula+2
	stz.b mula
	lda.w #$0010
	sta.b mulres+2
.loop:
	asl.b mulres
	lsr.b mula+2
	ror.b mula
	lda.b mulb
	cmp.b mula
	lda.b mulb+2
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	lda.b mulb+2
	sbc.b mula+2
	sta.b mulb+2
	inc.b mulres
.next:
	dec.b mulres+2
	bne .loop
	lda.b mulb
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
wallcollb:		;auto: CODE_80CC1E. 93G wallcollb (hockey93_04): object X hits a wall (d0/d1 = cos/sin). The puck may go over the glass; otherwise wallcoll
	cpx.w #$001C		; not the puck: wallcoll
	beq .puck
	jmp.w wallcoll
.puck:
	lda.w Zpos+puckobj
	sec
	sbc.w #$0020		; Zpos > 32: over
	beq .z1
	bmi .v1
	bvs .z1
	bra .over
.v1:
	bvs .over
.z1:
	lda.w Zpos+puckobj
	cmp.w #$0016		; Zpos <= 21: wallcoll
	bcs .y280
	jmp.w wallcoll
.y280:
	lda.w pucky
	sec
	sbc.w #$0112		; y >= 274
	bmi .v2
	bvc .x13
	bra .over
.v2:
	bvc .over
.x13:
	lda.w puckx
	sec
	sbc.w #$000D		; x 13-15 (the goal mouth)
	bmi .v3
	bvc .x15
.wc1:
	jmp.w wallcoll
.v3:
	bvc .wc1
.x15:
	lda.w puckx
	sec
	sbc.w #$000F
	beq .vy
	bmi .v4
	bvs .vy
	bra wallcoll
.v4:
	bvs wallcoll
.vy:
	lda.w puckvy
	sec
	sbc.w #$0FA0		; Yvel >= $FA0
	bmi .v5
	bvc .glass
	bra wallcoll
.v5:
	bvc wallcoll
.glass:		;over the glass at the goal: shadow animation, sound, crowd
	phx
	lda.w puckvy		; halve puckvy
	pha
	asl a
	pla
	ror a
	sta.w puckvy
	inx
	inx
	stx.b a3
	lda.w #SPAbglass		; object 15 (shadow): SPAbglass
	sta.b d1
	jsl.l SetSPA
	plx
	stx.b a3
	lda.w #SFXoverglass		; over the glass sound
	pha
	jsl.l sfx
	lda.b crowdlevel		; crowd +600
	clc
	adc.w #$0258
	sta.b crowdlevel
.over:		;puck out of play
	lda.w #sfslock		; sfslock; puck pfnc
	tsb.w sflags
	sta.w pfnc+puckobj
	lda.w pucky		; bottom: y flip
	bpl .n1
	lda.w #$8000
	tsb.w attribute+puckobj
.n1:
	stz.w frame+$1E		; shadow frame 0
	lda.w gmclock		; clock stopped
	bne .rtl
	lda.w ltplayer		; penalty 6 for the last touch player
	asl a
	sta.b a3
	tax
	lda.w #PenOOP
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #$001C
	stx.b a3
.rtl:
	rtl
wallcoll:		;auto: CODE_80CCDE. 93G wallcoll (hockey93_04): d0/d1 = cos/sin of the wall; bounce object X: puck loses speed, flips, sound; players sound on a hard hit
	lda.b d0		; Wallcos/Wallsin
	sta.w Wallcos,x
	lda.b d1
	sta.w Wallsin,x
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	lda.b d1		; v1n = (Yvel*cos - Xvel*sin)/256, negated; v1t = (Xvel*cos + Yvel*sin)/256
	pha
	lda.b d0
	pha
	sta.b mulb
	lda.w Yvel,x
	sta.b mula
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w Xvel,x
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b d0
	sec
	sbc.b mulres
	sta.b d0
	lda.b d0+2
	sbc.b mulres+2
	sta.b d0+2
	lda.b d0+1
	eor.w #$FFFF
	inc a
	sta.b d2
	lda.w Xvel,x
	sta.b mula
	lda.b $01,s
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w Yvel,x
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0+1
	sta.b d3
	cpx.w #$001C
	beq .puck
	jmp.w .player
.puck:
	lda.w #sf2shot		; puck: clear sf2shot
	trb.w sflags
	lda.b d2		; moving away from the wall
	bmi .pn
	jmp.w .nocoll
.pn:
	lsr a		; normal speed /4
	lsr a
	bit.w #$2000
	beq .pn1
	ora.w #$C000
.pn1:
	sta.b d2
	sec
	sbc.w #$FC00		; hard hit (v1n <= -$400): pop up, flip, sound by speed
	beq .hard
	bmi .v1
	bvs .hard
	bra .pok
.v1:
	bvs .pok
.hard:
	lda.w #$0800
	jsl.l randoma
	eor.w #$FFFF
	inc a
	sta.w puckvz
	sta.b d0
	jsl.l puckflip
	lda.w #SFXpuckwall
	pha
	lda.b d2
	sec
	sbc.w #$EE00
	bmi .v2
	bvc .s2
	bra .snd
.v2:
	bvc .snd
.s2:
	pla
	lda.w #SFXpuckwall+1
	pha
	lda.b d2
	sec
	sbc.w #$F800
	bmi .v3
	bvc .s3
	bra .snd
.v3:
	bvc .snd
.s3:
	pla
	lda.w #SFXpuckwall+2
	pha
.snd:
	jsl.l sfx
.pok:		;reduce the tangent speed of the puck
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .t1
	ora.w #$FC00
.t1:
	sta.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0+2
	lda.b d3
	sec
	sbc.b d0
	sec
	sbc.b d0+2
	sta.b d3
	bra .noadd
.player:
	lda.b d2
	sec
	sbc.w #$03E8		; player: v1n > 1000: no collision
	beq .p1
	bmi .v4
	bvs .p1
.nocoll1:
	jmp.w .nocoll
.v4:
	bvs .nocoll1
.p1:
	lda.b d2
	sec
	sbc.w #$F000		; v1n <= -$1000 and impact >= 10: board sound
	beq .imp
	bmi .v5
	bvs .imp
	bra .nosfx
.v5:
	bvs .nosfx
.imp:
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .v6
	bvc .psnd
	bra .nosfx
.v6:
	bvc .nosfx
.psnd:
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXplayerwall
	pha
	jsl.l sfx
.nosfx:
	lda.b d2
	lsr a
	lsr a
	bit.w #$2000
	beq .n1
	ora.w #$C000
.n1:
	sta.b d2
	sec
	sbc.w #$FC7C		; v1n >= -900: -1000
	bmi .v7
	bvc .min
	bra .noadd
.v7:
	bvc .noadd
.min:
	lda.w #$FC18
	sta.b d2
.noadd:		;rotate back: new Xvel/Yvel
	lda.b $01,s
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b $03,s
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sec
	sbc.b mulres
	sta.b tmp0
	lda.b tmp1
	sbc.b mulres+2
	sta.b tmp1
	lda.b tmp0+1
	sta.w Xvel,x
	lda.b $03,s
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	lda.b $01,s
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	adc.b d3
	sta.b d3
	lda.b d3+2
	adc.b mulres+2
	sta.b d3+2
	lda.b d3+1
	sta.w Yvel,x
	lda.w Zvel,x		; moving up: Zvel = 0
	bmi .nocoll
	stz.w Zvel,x
.nocoll:
	pla
	pla
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d2,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
puckflip:		;auto: CODE_80CEC9. 93G puckflip (logic93_5): start the puck spinning. d0 bit 0 = flip
	lda.b d0
	and.w #$0001		; facedir of the puck ^= d0 bit 0, & 3
	sta.b d0
	eor.w facedir+puckobj
	and.w #$0003
	sta.w facedir+puckobj
	lda.w #$FFFF		; SPAcnt = -1
	sta.w SPAcnt+puckobj
	lda.w #SPApflip
	sta.b d1
	jmp.w SetSPA
