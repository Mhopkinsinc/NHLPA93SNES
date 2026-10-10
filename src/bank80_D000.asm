; $80CEE7-$80E0E0  ROM $04EE7-$060E0: checkgoal, Goal, checkgoalp, CheckBump (hockey93_04), ChkShotStat (penalty93_2), PenGoalStuff
; (penalty93_1), checkplcoll, checkcx, newcheck, checkint, FallDown, checkcheck (hockey93_03), checkfight, SetInst (hockey93_04),
; doinput, faceoffinput, holdplayer (logic93_1). Starts at checkgoal (boundary moved from $80D002), ends before setpads.
org $80CEE7
checkgoal:		;look for coll with goal/net. a2 = goal struct, a3 = object, d2/d3 = x/y. Called from checkwallcoll (93G hockey93_04)
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
	bmi .dy0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
.dy0:		;d5 = dy at entry; d2 -= dx*dy/vy: x where the puck crossed the goal line
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
	lda.w #SFXpost
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
ChkShotStat:		;add to shot stat if a shot was taken. 93 also raises the crowd and counts the shot for the shooter and against the other team's goalie (93G penalty93_2)
		;   SNES: if a shot was taken (sf2shot, cleared here), add 1 to the shooting team tmshots
	lda.w #sf2shot
	trb.w sflags
	beq .rtl
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	phx
	lda.w shotplayer
	asl a
	tax
	stx.b a3		; a3 = the shooter
	lda.w #$0001
	sta.b d0
	lda.w #tmshots
	sta.b d1
	jsl.l addteamstat
	plx
	stx.b a3
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
.rtl:
	rtl
addteamstat:		;add d0 to the team word stat at d1 (+2 for team 2, pfteam of X). 93G inline in ChkShotStat
	ldy.b d1		; pfteam: team 2 word
	lda.w pfteam,x
	beq .add
	iny
	iny
.add:
	lda.w $0000,y		; absolute stat address in d1 (+$0000,y)
	clc
	adc.b d0
	sta.w $0000,y
	rtl
Goal:		;puck in goal. a3 = puck. Entered from checkgoal (93G hockey93_04)
		;   SNES: puck in the goal. Score +1 for the scoring team (a2, a1 = the other team), siren, ScoreSum entry, goal counts, PenGoalStuff, printscores1, ascore
		;   for the scorers, puck into the net, siren SPA and PenGoal
	lda.w gmclock		; clock stopped: no goal
	beq .go
	jmp.w .rtl
.go:		;puck must be moving into the net
	lda.w pucky
	eor.w puckvy
	bpl .in
	jmp.w .rtl
.in:
	jsl.l ChkShotStat		; sound reset, siren, mute other sfx
	jsl.l sndqreset
	lda.w #SFXsiren
	pha
	jsl.l sfx
	lda.b vcount
	sta.w sfxmutetime
	jsl.l freezewindow
	lda.b crowdlevel		; crowd +500
	clc
	adc.w #$01F4
	sta.b crowdlevel
	stz.b a2		; a2 = scoring team (0/2), a1 = other
	lda.w #$0002
	sta.b a1
	lda.w Ypos,x
	bpl .g0
	stz.b a1
	lda.w #$0002
	sta.b a2
.g0:
	lda.w gmode		; gmdir: swap
	bit.w #gmdir
	beq .g1
	lda.b a1
	sta.b a2
	eor.w #$0002
	sta.b a1
.g1:
	ldy.b a2
	lda.w tmscore,y
	inc a
	sta.w tmscore,y
	lda.w ScoreSumbytes		; ScoreSum full (30 entries): overwrite the last
	cmp.w #$00B4
	bne .sum
	sec
	sbc.w #$0006
	sta.w ScoreSumbytes
.sum:
	lda.w #$0000
	sta.b a0+2
	lda.w #ScoreSum
	clc
	adc.w ScoreSumbytes
	sta.b a0
	lda.w ScoreSumbytes
	adc.w #$0006
	sta.w ScoreSumbytes
	jsl.l GetPeriodTimeRemaining		; entry word 0 = time
	lda.b d0
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$0002		; byte 2 = 2 + tmap(a2) - tmap(a1), bit 7 = away team scored
	clc
	ldy.b a2
	adc.w tmap,y
	ldy.b a1
	sec
	sbc.w tmap,y
	ldy.b a2
	beq .home
	ora.w #$0080
.home:
	sta.b [a0]
	inc.b a0
	lda.w tmtouch1,y		; byte 3 = scorer; no assists yet
	sta.b d0
	sta.b [a0]
	inc.b a0
	lda.w #$FFFF
	sta.b [a0]
	lda.b a2		; goals +1 for the scorer
	beq .h1
	lda.w #$001A
.h1:
	clc
	adc.b d0
	tay
	sep #$20
	lda.w tmgoals,y
	inc a
	sta.w tmgoals,y
	rep #$20
	ldy.b a2		; assists
	lda.w tmtouch2,y
	bmi .noast
	sep #$20
	sta.b [a0]
	rep #$20
	inc.b a0
	lda.w tmtouch3,y
	bmi .noast
	sep #$20
	sta.b [a0]
	rep #$20
.noast:
	jsl.l PenGoalStuff		; PenGoalStuff, printscores1, ascore for the scoring team
	jsl.l printscores1		; bank $89: 93G printscores1
	lda.w #ascore
	sta.b d0
	jsl.l .setass
	lda.b a2		; home team within 3 after scoring: goal cue
	bne .nocue
	lda.w tmscore+2
	sec
	sbc.w tmscore
	bmi .nocue
	cmp.w #$0003
	bcs .nocue
	inc.w goalcue
.nocue:
	stz.b collflag		; puck into the net at (+-6, +-$110), Zvel $600
	stz.w puckvx
	stz.w puckvy
	lda.w #$0006
	sta.b d0
	lda.w puckx
	bpl .px
	lda.w #$FFFA
	sta.b d0
.px:
	lda.b d0
	sta.w puckx
	lda.w #$0110
	sta.b d0
	lda.w pucky
	bpl .py
	lda.w #$FEF0
	sta.b d0
.py:
	lda.b d0
	sta.w pucky
	lda.w #$0600
	sta.w puckvz
	stz.w Zpos+puckobj
	lda.w #$FFFF		; puckcross never; pfnc
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w pfnc+puckobj
	lda.w #pnothing
	sta.b d0
	jsl.l assreplace
	inx		; shadow: siren anim
	inx
	lda.w #SPAsiren
	sta.b d1
	jsl.l SetSPA
	ldy.b a2		; PenGoal for the first object of team a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #PenGoal
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #puckobj
	stx.b a3
	rtl
.setass:		;IDA ResetTeamPlayerAssignments: give each skater of team a2 that is not fighting assignment d0, clear pfnc
	phx
	ldy.b a2
	lda.w tmsort,y
	tax
	lda.w #$0005
	sta.b d3
.loop:
	lda.w position,x
	bmi .nl
	beq .nl
	lda.w pf2fight,x
	bne .nl
	stz.w pfnc,x
	jsl.l assinsert
.nl:
	inx
	inx
	dec.b d3
	bpl .loop
	plx
.rtl:
	rtl
PenGoalStuff:		;do this stuff after a goal. a1 = scored on team, a2 = scoring team. If the scoring team had more players on ice, the first scored on player in the box without a coincidental
		;   penalty is released (93G penalty93_1)
		;   SNES: a1 = scored on team, a2 = scoring team. If the scoring team had more players on the ice, release the first scored on
		;   player in the box without a coincidental penalty
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	jsl.l ClearPenaltyBuffer		; ClearPenaltyBuffer, bank $8F: 93G ClearPenaltyBuffer
	ldy.b a2
	lda.w tmap,y		; tmap(a2) - tmap(a1) > 0?
	ldy.b a1
	sec
	sbc.w tmap,y
	beq .ex
	bmi .v1
	bvc .more
	bra .ex
.v1:
	bvc .ex
.more:		;scoring team had more players on the ice
	lda.b a1
	beq .lst
	lda.w #$001A
.lst:
	sta.b a0
.loop:		;next player in the box list (negative = end)
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .ex
	lda.b a1
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y		; coincidental penalty: skip
	bit.w #$4000
	bne .loop
	lda.w #$0000		; out of the box, one more on the ice, power play goal
	sta.w tmpdst,y
	jsl.l RemovePlayerFromList		; bank $8F: 93G RemovePlayerFromList
	ldy.b a1
	lda.w tmap,y
	inc a
	sta.w tmap,y
	ldy.b a2
	lda.w tmPwrGoals,y
	inc a
	sta.w tmPwrGoals,y
	lda.w #tmflcc
	tsb.w tmflags		; line change box redraw
	tsb.w tmflags+2
.ex:
	stx.b xsave
	ldx.w #$0002
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
checkgoalp:		;check for player a3 collision with goal/net a2. Entered from checkgoal (93G hockey93_04)
		;   SNES: player X collision with the goal/net a2 (oval, radius x 32, y 11). CheckBump, then wallcoll with the normal
	lda.w pflags,x
	bit.w #pf2npc
	beq .npc
	jmp.w .rtl
.npc:
	lda.w Zpos,x
	sec
	sbc.w #$000A
	beq .pl
	bmi .v1
	bvs .pl
.ex1:
	jmp.w .rtl
.v1:
	bvs .ex1
.pl:		;players only (SCnum <= 11)
	cpx.w #$0017
	bcc .go
	jmp.w .rtl
.go:
	ldy.b a2		; d0 = -dy, d1 = dx
	lda.b d3
	pha
	sec
	sbc.w Ypos,y
	sta.b d3
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d2
	pha
	sec
	sbc.w Xpos,y
	sta.b d1
	asl a
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	lda.w #$0400
	sta.b mula
	jsl.l divu
	cmp.w #$0101
	bcc .inx
	jmp.w .exit
.inx:		;(dy*16)^2/$79 + (dx*16)^2/$400 <= $100?
	sta.b d2
	lda.b d3
	asl a
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	lda.w #$0079
	sta.b mula
	jsl.l divu
	adc.b d2
	cmp.w #$0101
	bcs .exit
	pla
	sta.b d2
	pla
	sta.b d3
	jsl.l CheckBump		; CheckBump, then wallcoll with the normal (d0,d1)/r
	lda.b d3
	pha
	lda.b d2
	pha
	lda.b d1
	pha
	lda.b d0
	pha
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
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	jsl.l sroot
	inc a
	sta.b d2
	sta.b mula
	pla
	sta.b d0
	pla
	sta.b d1
	stz.b mulb
	lda.b d0
	sta.b mulb+1
	lda.b d0+2
	sta.b mulb+3
	jsl.l divs
	sta.b d0
	lda.b d2
	sta.b mula
	stz.b mulb
	lda.b d1
	sta.b mulb+1
	lda.b d1+2
	sta.b mulb+3
	jsl.l divs
	sta.b d1
	jsl.l wallcoll
.exit:
	pla
	sta.b d2
	pla
	sta.b d3
.rtl:
	rtl
CheckBump:		;supply minimum separation velocity for coll with walls/goal/net. a2 = goal, a3 = player. Called from checkgoalp (93G hockey93_04)
		;   SNES: goalie X against the net a2 with the puck near (1 in 32): if moving faster than $2000, bump the net (Xvel/Yvel / 4), stop and call
		;   PenGhold
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	lda.w seed		; 1 in 32 frames
	and.w #$001F
	bne .exit
	ldy.b a2
	lda.w pucky		; puck within 41 of the net in y
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$0029
	bcs .exit
	lda.w Xvel,x
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	cmp.w #$2001
	bcs .bb
	lda.b d0
	bit.w #$8000
	beq .vx
	eor.w #$FFFF
	inc a
.vx:
	cmp.w #$2001
	bcs .bb
.exit:
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
.rtl:
	rtl
.bb:		;drop the saved d0-d3 and the jsl return: return to the caller of checkgoalp
	pla
	pla
	pla
	pla
	pla
	sep #$20
	pla
	rep #$30
	lda.b d0		; net Xvel/Yvel = speed / 4; player stops
	lsr a
	lsr a
	bit.w #$2000
	beq .sx
	ora.w #$C000
.sx:
	sta.b d0
	ldy.b a2
	sta.w Xvel,y
	lda.b d1
	lsr a
	lsr a
	bit.w #$2000
	beq .sy
	ora.w #$C000
.sy:
	sta.b d1
	sta.w Yvel,y
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #sfslock
	tsb.w sflags
	lda.w gmclock
	bne .rtl
	lda.w #PenGhold
	sta.b d0
	jmp.w AddPenalty2
checkplcoll:		;d2/d3 = x/y cords, a3 = struct. Walk up and down the OOlist from a3 and call checkcx for each object within $10 in y (92 collrad*2). Called from checkcoll (93G hockey93_03)
		;   SNES: d2/d3 = x/y, X = object. Walk up and down the OOlist from X and call checkcx for each object within 14 in y
	lda.w pflags,x
	bit.w #pf2npc
	beq .pl
	jmp.w .ex
.pl:
	cpx.w #$0018
	bcc .go
	jmp.w .ex
.go:
	lda.w OOlistpos,x		; d1 = position of X in OOlist
	sta.b d1
.up:		;objects higher in the list
	ldy.b d1
	cpy.w #$000F		; top of the list
	beq .cl
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w Ylist,y
	sec
	sbc.b d3
	sta.b d5
	sec
	sbc.w #$000E
	beq .uy
	bmi .v1
	bvs .uy
	bra .cl
.v1:
	bvs .cl
.uy:
	lda.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .ux
	eor.w #$FFFF
	inc a
.ux:
	cmp.w #$000F
	bcs .unext
	lda.w pflags,y		; not npc, nc, players only
	and.w #pf2npc
	ora.w pfnc,y
	bne .unext
	cpy.w #$0018
	bcs .unext
	jsl.l checkcx
.unext:
	inc.b d1
	bra .up
.cl:		;objects lower in the list
	lda.w OOlistpos,x
	beq .ex
	sta.b d1
.down:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	sta.b d5
	sec
	sbc.w #$000E
	beq .dy
	bmi .v2
	bvs .dy
	bra .ex
.v2:
	bvs .ex
.dy:
	lda.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$000F
	bcs .dnext
	lda.w pflags,y
	and.w #pf2npc
	ora.w pfnc,y
	bne .dnext
	cpy.w #$0018
	bcs .dnext
	jsl.l checkcx
.dnext:
	dec.b d1
	bne .down
.ex:
	rtl
checkcx:		;d4 = obj. # * 2 for possible coll so check x range and distance for coll. d2 = x, d5 = delta y, a3 = moving object. Opposing players add impact and run newcheck, checkint,
		;   checkcheck and checkfight; then momentum moves from a3 to a2. Called from checkplcoll (93G hockey93_03)
		;   SNES: Y = object near X. Opposing players add impact and run newcheck, checkint, checkcheck and checkfight; then momentum moves from X to a2
		;   (weights + 140, elasticity evalue)
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .push
	ldx.b xsave
	sty.b a2		; a2 = Y; d0/d1 = relative velocity, d2/d3 = relative position
	stz.b evalue
	lda.w Xvel,x
	sec
	sbc.w Xvel,y
	sta.b d0
	lda.w Yvel,x
	sec
	sbc.w Yvel,y
	sta.b d1
	sta.b mulb
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d2
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d3
	sta.b mula
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d2
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	adc.b d1
	sta.b d1
	lda.b d1+2
	adc.b mulres+2
	bpl .v1n		; v1n < 0: no collision
	jmp.w .exit4
.v1n:		;V1n = (Vy*Dy + Vx*Dx) / 16
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lda.w pfteam,x		; same team: no impact
	cmp.w pfteam,y
	beq .not
	lda.b d1+1
	and.w #$00FF
	sta.b d4
	cmp.w #$0006
	bcs .g40
	lda.w #$0005
	sta.b d4
.g40:		;minimum impact 5
	clc
	adc.w impact,x
	sta.w impact,x
	lda.w impact,y
	clc
	adc.b d4
	sta.w impact,y
	lda.w pf2fight,y		; impactp = the other (not while fighting)
	bne .if
	txa
	lsr a
	sta.w impactp,y
.if:
	lda.w pf2fight,x
	bne .if2
	tya
	lsr a
	sta.w impactp,x
.if2:		;impact under 20: no check sound
	lda.b d4
	cmp.w #$0014
	bcc .n1
	lda.w puckc		; check sound only if one of them has the puck
	cmp.w SCnum,x
	beq .nc
	cmp.w SCnum,y
	bne .n1
.nc:
	jsl.l newcheck
.n1:
	jsl.l checkint
	jsl.l checkcheck
	jsl.l checkfight
.not:		;same team: no check events
	lda.b d1
	sta.b d4
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b collflag		; collflag set by holdcheck / Bcheck: no transfer
	bpl .tr
	jmp.w .exit
.tr:		;V1t = (Vx*Dy - Vy*Dx) / 16
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d3
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b d1
	sta.b d0
	lda.b mulres+2
	sbc.b d1+2
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lda.b d0
	sta.b d5
	lda.w weight,x		; weights + 140
	clc
	adc.w #$008C
	sta.b d0
	ldy.b a2
	lda.w weight,y
	clc
	adc.w #$008C
	sta.b d1
	sta.b mula
	lda.b evalue
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, A = mula*mulb
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d7+2
	lda.b d1
	clc
	adc.b d0
	sta.b d1
	lda.b d0
	sec
	sbc.b d7+2
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls32
	lda.b d1
	sta.b mula
	jsl.l divs
	sta.b d0
	lda.b evalue
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls16
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .v2n
	ora.w #$F000
.v2n:		;V2n = V1n + V1n*e
	clc
	adc.b d0
	sta.b d1
	lda.b d5
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d0
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	adc.b tmp0
	sta.b tmp0
	lda.b tmp1
	adc.b mulres+2
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lda.w Xvel,y
	clc
	adc.b tmp0
	sta.w Xvel,x
	lda.b d5
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d0
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b tmp0
	sta.b tmp0
	lda.b mulres+2
	sbc.b tmp1
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lda.w Yvel,y
	clc
	adc.b tmp0
	sta.w Yvel,x
	lda.b d1
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	clc
	adc.w Xvel,y
	sta.w Xvel,y
	lda.b d1
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	clc
	adc.w Yvel,y
	sta.w Yvel,y
	lda.w #$FFFF		; collflag
	sta.b collflag
.exit:
	stx.b xsave
	ldx.w #$0016
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
.exit4:		;drop the saved Vx/Vy
	pla
	pla
	bra .exit
newcheck:		;start a new check sound. 93: one of 4 sounds $1C-$1F (92: one of 5 from SFXcheck = 18), never the last one again. Called from checkcx; FallDown branches here when the player who
		;   fell did not have the puck (93G hockey93_03)
		;   SNES: check sound SFXcheck + random 0/1
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXcheck
	pha
	jsl.l sfx
	rtl
checkint:		;check for interference penalty. player a2 interferes with a3 or vice-versa; goalie is only player who cause an interference call. Called from checkcx (93G hockey93_03)
		;   SNES: goalie a2 against a3 and the other way round
	lda.b d0+2		; a2 and a3 swapped for the second call
	pha
	lda.b d0
	pha
	jsl.l .ci
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .ci
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	pla
	sta.b d0
	pla
	sta.b d0+2
.rtl:
	rtl
.ci:		;IDA checkint_ci: a2 must be a goalie, clock running
	ldy.b a2
	lda.w position,y
	bne .rtl
	lda.w gmclock
	bne .rtl
	lda.w puckc		; a3 has the puck: skip the impact 26 test
	asl a
	cmp.b a3
	beq .pc
	lda.w impact,x
	sec
	sbc.w #$001A
	beq .rtl
	bmi .v1
	bvc .pc
	bra .rtl
.v1:
	bvc .rtl
.pc:		;impact of X > 2
	lda.w impact,x
	sec
	sbc.w #$0003
	beq .rtl
	bmi .v2
	bvc .fall
	bra .rtl
.v2:
	bvc .rtl
.fall:		;X falls
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l FallDown
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w impact,y		; impact of a2 > 31
	sec
	sbc.w #$001F
	beq .rtl
	bmi .v3
	bvc .pen
	bra .rtl
.v3:
	bvc .rtl
.pen:		;no double minor; penalty 3 times in (20 - GGSleft)
	lda.w pflags,x
	bit.w #pf2pen
	bne .rtl
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	jsl.l randoma
	cmp.w #$0003
	bcs .rtl
	lda.w gmode		; not in highlights
	bit.w #gmhl
	bne .rtl
	lda.w #PenInt
	sta.b d0
	jmp.w AddPenalty
FallDown:		;player a2 falls down, player a3 is the hitting player. 93 adds anim $13A0 in place of a fall for some players, check stats for the hitter, a third fall anim ($1524), and injuries
		;   (setInjuryType) with a penalty. Called from checkint .ci, checkcheck .cc and Bcheck; also entered from setd0player (hockey93_05) (93G hockey93_03)
		;   SNES: player a2 falls, X is the hitter. Stumble for some players, check stats, fall back/forward/third fall, injuries with a penalty and crowd
		;   sounds
	ldy.b a2		; players only, not fighting
	cpy.w #$0018
	bcc .f1
	jmp.w .rtl
.f1:
	lda.w pf2fight,y
	beq .spa
	jmp.w .rtl
.spa:		;already in one of the fall anims?
	lda.w SPA,y
	cmp.w #SPAinjury1
	bne .s2
	jmp.w .rtl
.s2:
	cmp.w #SPAstumble
	bne .s3
	jmp.w .rtl
.s3:
	cmp.w #SPAfallfwd
	bne .s4
	jmp.w .rtl
.s4:
	cmp.w #SPAfallback
	bne .s5
	jmp.w .rtl
.s5:
	cmp.w #SPAflip
	bne .s6
	jmp.w .rtl
.s6:		;stumble when stickhand (93G byte $71) >= $C, nopuckb is 0 and impact < $10-$1F
	lda.w #SPAstumble
	sta.b d1
	lda.w stickhand,y
	cmp.w #$000C
	bcc .fall
	lda.w nopuckb,y
	bne .fall
	lda.w seed
	and.w #$000F
	ora.w #$0010
	sta.b d0
	sec
	sbc.w impact,y
	beq .fall
	bmi .v1
	bvc .stumble
	bra .fall
.v1:
	bvc .fall
.stumble:		;no second stumble for $3C
	lda.w #$003C
	sta.w nopuckb,y
	jmp.w .set
.fall:		;no check stats for a goalie hitter
	lda.w position,x
	beq .nostat
	stz.b a0		; team checks, player checks, ChkCnt (+3 when fightagg is 0)
	lda.w pfteam,x
	beq .tm
	lda.w #$0002
	sta.b a0
.tm:
	ldy.b a0
	lda.w tmchecks,y
	inc a
	sta.w tmchecks,y
	inc.w ChkCnt
	lda.w pnum,x
	sta.b d0
	lda.w pfteam,x
	beq .pl
	lda.w #$001A
.pl:
	clc
	adc.b d0
	tay
	sep #$20
	lda.w pchecks,y
	inc a
	sta.w pchecks,y
	rep #$20
	lda.w fightagg,x
	bne .nostat
	inc.w ChkCnt
	inc.w ChkCnt
.nostat:
	ldy.b a2		; nopuck 120 for a2
	lda.w #$0078
	sta.w nopuck,y
	lda.w Xpos,x		; direction from a2 to the hitter
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w #SPAfallback
	sta.b d1
	ldy.b a2		; hit from the front: fall back
	lda.b d0
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcc .set
	lda.w #SPAfallfwd
	sta.b d1
	lda.w facedir,y		; facedir 0 or 4 and hitter aggress >= 10: third fall
	and.w #$0003
	bne .set
	lda.w aggress,x
	sec
	sbc.w #$000A
	bmi .v2
	bvc .f3
	bra .set
.v2:
	bvc .set
.f3:
	cpx.w #$0018
	bcs .set
	lda.w #SPAflip
	sta.b d1
.set:		;SetSPA d1 for a2
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$0001		; pfalock
	sta.w pfalock,x
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.b crowdlevel		; crowd +300
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w puckc		; a2 did not have the puck: check sound only
	sta.b d0
	bpl .pc
	jmp.w newcheck
.pc:
	tya
	lsr a
	cmp.b d0
	beq .drop
	jmp.w newcheck
.drop:		;a2 had the puck: lose it, maybe an injury
	lda.w #$FFFF
	sta.w puckc
	lda.w gmode		; injury: no highlight, fall back, facedir 0/4, no penalty, random(160) <= impact, clock running
	bit.w #gmhl
	bne .snd
	lda.w SPA,y
	cmp.w #SPAfallback
	bne .snd
	lda.w facedir,y
	and.w #$0003
	bne .snd
	lda.w pflags,y
	bit.w #pf2pen
	bne .snd
	lda.w #$00A0
	jsl.l randoma
	ldy.b a2
	sec
	sbc.w impact,y
	beq .inj
	bmi .v3
	bvs .inj
	bra .snd
.v3:
	bvs .snd
.inj:
	lda.w gmclock
	bne .snd
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #SPAinjury1
	sta.b d1
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l setInjuryType		; setInjuryType, bank $8F: 93G setInjuryType
	lda.w #$0004
	sta.w InjCntDown
	lda.w #PenInjury		; PenInjury if the hitter is a goalie or penalties are off, else PenRough2 and Stop4Pen
	sta.b d0
	lda.w position,x
	bne .g
	jmp.w AddPenalty2
.g:
	lda.w OptPen
	bne .rough
	jmp.w AddPenalty2
.rough:
	lda.w #PenRough2
	sta.b d0
	jsl.l AddPenalty2
	jmp.w Stop4Pen
.snd:
	ldy.b a2		; home player fell: boo, else cheer
	lda.w #SFXcrowdcheer
	pha
	lda.w pfteam,y
	bne .play
	lda.w #SFXcrowdboo
	sta.b $01,s
.play:
	jsl.l sfx
.rtl:
	rtl
checkcheck:		;player is in contact look for various contact events. Runs .cc for a3 on a2, then for a2 on a3. d4 = impact. Called from checkcx (93G hockey93_03)
		;   SNES: players in contact: .cc for X on a2, then for a2 on X. d4 = impact
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	jsl.l .cc
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .cc
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.cc:		;IDA CC: X is checking a2
	ldy.b a2		; a2 holding: holdcheck
	lda.w SPA,y
	cmp.w #SPAHold
	bne .h2
	jml.l holdcheck		; bank $8F: 93G holdcheck
.h2:
	cmp.w #SPAhook
	bne .b
	jml.l holdcheck		; bank $8F: 93G holdcheck
.b:
	cmp.w #SPAsweepchk
	bne .burst
	jml.l Bcheck		; bank $8D: 93G Bcheck
.burst:		;X must be in the burst anim
	lda.w SPA,x
	cmp.w #SPAburst
	bne .rtl
	lda.w gmclock		; clock stopped: fight chance up
	beq .nofight
	lda.w #$0100
	sta.w impact,x
	sta.w impact,y
.nofight:
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d0
	lda.w attribute,x		; xflip: mirror the direction
	bit.w #$0800
	beq .n0
	lda.b d0
	eor.w #$FFFF
	inc a
	and.w #$0007
	sta.b d0
.n0:		;check anim from .list by the direction to a2
	asl.b d0
	lda.w #.list
	sta.b a0
	sta.w pfalock,x		; pfalock
	lda.w #.list>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	sta.b d1
	jsl.l SetSPA
	ldy.b a2
	lda.w position,y
	bne .pos
	jmp.w .rtl
.pos:		;goalie does not fall
	lda.b d4		; impact under 20: no fall
	sec
	sbc.w #$0014
	bmi .v1
	bvc .fall
.ex1:
	jmp.w .rtl
.v1:
	bvc .ex1
.fall:		;d0 = (120 (*2 joystick) - weight + weight of a2) / 2 - impact of a2
	lda.w #$0078
	sta.b d0
	lda.w pflags,x
	bit.w #pfjoycon
	beq .n00
	asl.b d0
.n00:
	lda.b d0
	sec
	sbc.w weight,x
	clc
	adc.w weight,y
	lsr a
	sec
	sbc.w impact,y
	sta.b d0
	beq .down
	bmi .down
	jsl.l randomd0		; random < aggress: down
	lda.b d0
	sec
	sbc.w aggress,x
	beq .down
	bmi .v2
	bvc .pen
	bra .down
.v2:
	bvc .down
.pen:
	jsl.l checkagr		; checkagr <= 4 and no highlight: PenCharge or PenSlash, bank $8F: 93G checkagr (d0 = penalty roll)
	lda.b d0
	cmp.w #$0005
	bcc .nohl
	jmp.w .rtl
.nohl:
	lda.w gmode
	bit.w #gmhl
	beq .roll
	jmp.w .rtl
.roll:
	lda.w seed+1
	and.w #$0002
	clc
	adc.w #PenCharge
	sta.b d0
	jmp.w AddPenalty
.down:
	jsl.l checkagr		; checkagr <= 3 and no highlight: PenRough or PenCross, bank $8F: 93G checkagr (d0 = penalty roll)
	lda.b d0
	cmp.w #$0004
	bcs .dn2
	lda.w gmode
	bit.w #gmhl
	bne .dn2
	lda.w seed+3
	and.w #$0002
	clc
	adc.w #PenRough
	sta.b d0
	jsl.l AddPenalty
.dn2:
	jmp.w FallDown
.list:		;check anim by direction
	dw SPAshoulderchkl,SPAshoulderchkr,SPAhipchkr,SPAhipchkr,SPAhipchkr,SPAhipchkl,SPAhipchkl,SPAshoulderchkl
checkfight:		;look for start of fight between players a2 & a3. Called from checkcx (hockey93_03) (93G hockey93_04)
		;   SNES: start of a fight between a2 and X. Both impact >= 10, no anim lock, no penalty, no goalie, clock running, no highlight, the puck not
		;   fighting or on a faceoff. SetInst both ways with d0 = 10 + max(0, 40 - ChkCnt)/4
	ldy.b a2
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .v1
	bvc .i2
.ex1:
	jmp.w .rtl
.v1:
	bvc .ex1
.i2:
	lda.w impact,y
	sec
	sbc.w #$000A
	bmi .v2
	bvc .lock
.ex2:
	jmp.w .rtl
.v2:
	bvc .ex2
.lock:
	lda.w pfalock,y
	ora.w pfalock,x
	beq .pen
	jmp.w .rtl
.pen:
	lda.w pflags,x
	ora.w pflags,y
	bit.w #pf2pen
	beq .pos1
	jmp.w .rtl
.pos1:
	lda.w position,x
	bne .pos2
	jmp.w .rtl
.pos2:
	lda.w position,y
	bne .clk
	jmp.w .rtl
.clk:
	lda.w gmode		; highlight, clock stopped, the puck fighting
	and.w #gmhl
	ora.w gmclock
	ora.w pf2fight+puckobj
	beq .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	ldy.w assnum+puckobj		; puck assignment pfaceoff: no fight
	lda.w asslist+puckobj*4,y
	and.w #$00FF
	cmp.w #pfaceoff
	bne .nofo
	jmp.w .ex
.nofo:
	lda.w #$0028		; d0 = 10 + max(0, 40 - ChkCnt)/4
	sec
	sbc.w ChkCnt
	bpl .pos
	lda.w #$0000
.pos:
	lsr a
	lsr a
	clc
	adc.w #$000A
	sta.b d0
	jsl.l SetInst
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l SetInst
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w pf2fight,x
	bne .fight
	jmp.w .ex
.fight:		;clear ChkCnt and the check counts of both teams
	stz.w ChkCnt
	lda.w #$0000
	ldy.w #$0032
.clr:
	sta.w pchecks,y
	dey
	dey
	bpl .clr
	lda.b crowdlevel		; crowd +1000; no pass/shot dir; puckc = X; yc1 = middle; sfslock
	clc
	adc.w #$03E8
	sta.b crowdlevel
	lda.w #sfspdir|sfssdir
	trb.w sflags
	ldy.b a2
	txa
	lsr a
	sta.w puckc
	lda.w Ypos,x
	clc
	adc.w Ypos,y
	pha
	asl a
	pla
	ror a
	sta.w yc1
	lda.w #sfslock
	tsb.w sflags
	lda.w #$0002
	sta.b d1
	lda.w Xpos,x
	sta.b d0
	sec
	sbc.w Xpos,y
	bmi .v3
	bvc .flip
	bra .o1
.v3:
	bvc .o1
.flip:
	lda.b d1
	eor.w #$0007
	sta.b d1
.o1:		;face each other
	lda.b d1
	sta.w facedir,x
	eor.w #$0007
	sta.b d1
	sta.w facedir,y
	jsl.l .sf
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .sf
	ldx.w #$0000		; others: afwatch (not unavailable, not fighting, not goalies)
	lda.w #afwatch
	sta.b d0
	lda.w #$000B
	sta.b d1
.watch:		;the others watch the fight
	lda.w pflags,x
	and.w #pf2unav
	ora.w pf2fight,x
	bne .next
	lda.w position,x
	beq .next
	jsl.l assinsert
.next:
	inx
	inx
	dec.b d1
	bpl .watch
	ldx.w #puckobj		; the puck: pf2fight, pnothing
	lda.w #$0001
	sta.w pf2fight+puckobj
	lda.w #pnothing
	sta.b d0
	jsl.l assinsert
	lda.w #$FFFF
	sta.b collflag
.ex:
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.sf:		;IDA checkfight_sf: start the fight for X against a2
	ldy.b a2		; impactp = a2
	tya
	lsr a
	sta.w impactp,x
	lda.w #PenFight
	sta.b d0
	jsl.l AddPenalty2
	txa		; setd0player
	lsr a
	sta.b d0
	jsl.l setd0player		; bank $8D: 93G setd0player
	lda.w #afight
	sta.b d0
	jsl.l assinsert
	lda.w attribute,x		; Xvel -$400 facing 2, else flipped and +$400
	and.w #$F7FF
	sta.w attribute,x
	lda.w #$FC00
	sta.b d1
	lda.w facedir,x
	cmp.w #$0002
	beq .sf2
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
	lda.w #$0400
	sta.b d1
.sf2:
	lda.b d1
	sta.w Xvel,x
	lda.w pflags,x		; unavailable, no player coll; pf2aip; SPAfight
	ora.w #pf2npc|pf2unav
	sta.w pflags,x
	stz.w pfalock,x
	lda.w #SPAfight
	sta.b d1
	sta.w pf2aip,x
	jmp.w SetSPA
SetInst:		;d0 = fight rating a3 needs. Called twice from checkfight (a2/a3 swapped) (93G hockey93_04)
		;   SNES: If fightagg of X >= d0, of a2 >= 2 and >= $10 - 2 * a2 checks, set pf2fight on both. Then 92 style: an instigator
		;   penalty for a shoulder check
	lda.w fightagg,x
	cmp.b d0
	bcc checkfight_rtl
	ldy.b a2		; tmp0 = fightagg of a2 >= 2
	lda.w fightagg,y
	sta.b tmp0
	sec
	sbc.w #$0002
	bmi .v1
	bvc .r2
.ex1:
	jmp.w checkfight_rtl
.v1:
	bvc .ex1
.r2:
	lda.w pnum,y		; d1 = $10 - 2 * a2 checks
	sta.b d1
	lda.w pfteam,y
	beq .tm
	lda.w #$001A
.tm:
	clc
	adc.w pnum,y
	tay
	lda.w pchecks,y
	and.w #$00FF
	bit.w #$0080
	beq .cnt
	ora.w #$FF00
.cnt:
	asl a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.b d1
	ldy.b a2
	sec
	sbc.b tmp0
	beq .set
	bmi .v2
	bvs .set
.ex2:
	jmp.w checkfight_rtl
.v2:
	bvs .ex2
.set:
	lda.w #$0001
	sta.w pf2fight,x
	sta.w pf2fight,y
	jmp.w .inst
.inst:		;X in a shoulder check: PenInst for the first teammate on the ice without a penalty
	jsl.l sndqreset		; sound reset
	lda.w SPA,x
	cmp.w #SPAshoulderchkl
	beq .chk
	cmp.w #SPAshoulderchkr
	bne .rtl
.chk:
	stx.b a4
	lda.w #$0005
	sta.b d0
	stz.b a3
	lda.w pfteam,x
	beq .loop
	lda.w #$000C
	sta.b a3
.loop:
	ldx.b a3
	cpx.b a4
	beq .next
	lda.w position,x
	bmi .next
	beq .next
	lda.w pflags,x
	bit.w #pf2pen|pf2unav
	bne .next
	lda.w #PenInst
	sta.b d0
	jsl.l AddPenalty2
	ldx.b a4
	stx.b a3
.rtl:
	rtl
.next:
	inc.b a3
	inc.b a3
	dec.b d0
	bpl .loop
	ldx.b a4
	stx.b a3
	rtl
doinput:		;process controller input (93G logic93_1)
		;   SNES: controller input for player X. d0 = dpad, d1 = new buttons, d4 = controller 0/2
	jsl.l setpads		; setpads; Start: pause
	lda.b d1
	bit.w #JOYSTART
	beq .nostart
	lda.b d4
	bne .pause2
	jml.l startpause1		; bank $8F: 93G startpause1
.pause2:
	jml.l startpause2
.nostart:
	lda.w sfhormode		; horizontal mode: dpad +90 degrees
	beq .nhor
	lda.b d0
	bit.w #$0008
	bne .nhor
	inc a
	inc a
	and.w #$0007
	sta.b d0
.nhor:
	lda.w sflags		; faceoff in progress
	bit.w #sf2faceoff
	beq .nofo
	jmp.w faceoffinput
.nofo:
	lda.w pflags,x		; line change interface
	bit.w #pf2lcm
	beq .nolcm
	jml.l lineinput		; bank $8A: 93G lineinput
.nolcm:
	bit.w #pfjoycon		; not joystick controlled: exit
	bne .joy
	jmp.w .rtl
.joy:
	lda.w pfalock,x
	beq .nolock
	jmp.w .islocked
.nolock:
	lda.w pf2fight,x
	beq .nofight
	jml.l fightinput		; bank $8F: 93G fightinput
.nofight:
	lda.w puckc		; carrier?
	sta.b d5
	txa
	lsr a
	cmp.b d5
	beq .ispc
	lda.b d1
	bit.w #abut
	beq .nohold
	jmp.w holdplayer
.nohold:
	bit.w #bbut
	beq .nob
	jmp.w changeplayer
.nob:		;goalie cannot check
	lda.w position,x
	beq .rtl
	lda.b d1
	bit.w #cbut
	beq .acc
	jmp.w burst
.acc:
	jml.l doplayeracc		; bank $8F: 93G doplayeracc
.ispc:		;player is the puck carrier
	jsl.l checkob		; goalie with pf2aip: exit
	lda.w position,x
	bne .pc1
	lda.w pf2aip,x
	bne .rtl
.pc1:
	lda.w sflags
	bit.w #sfspdir
	beq .nopass
	jml.l passmode		; bank $8F: 93G passmode
.nopass:
	bit.w #sfssdir
	beq .noshot
	jmp.w ShotMode
.noshot:
	lda.b d1
	bit.w #bbut
	bne .setpassmode
	lda.w sflags		; Y without a faceoff: line change mode
	bit.w #sf2faceoff
	bne .shoot
	lda.b d1
	bit.w #abut
	bne .lc
.shoot:
	lda.w position,x
	beq .rtl
	lda.b d1
	bit.w #cbut
	beq .acc2
	jmp.w SetShotMode
.acc2:
	jml.l doplayeracc		; bank $8F: 93G doplayeracc
.lc:
	lda.w lcplayer		; lcplayer $FFFF -> $FFFE
	cmp.w #$FFFF
	bne .setlc
	lda.w #$FFFE
	sta.w lcplayer
.setlc:
	jmp.w SetLCmode
.islocked:		;anim locked: only B (switch player) when not the carrier
	txa
	lsr a
	cmp.w puckc
	beq .rtl
	lda.b d1
	bit.w #$8000
	beq .rtl
	jmp.w changeplayer
.rtl:
	rtl
.setpassmode:		;93G setpassmode: the goalie keeps the puck behind the net (|x| < 16, |y| $108-$10F)
	lda.w position,x
	bne .set
	lda.w puckx
	bit.w #$8000
	beq .px
	eor.w #$FFFF
	inc a
.px:
	cmp.w #$0010
	bcs .set
	lda.w pucky
	bit.w #$8000
	beq .py
	eor.w #$FFFF
	inc a
.py:
	cmp.w #$0108
	bcc .set
	cmp.w #$0110
	bcc .rtl2
.set:
	lda.w facedir,x		; passdir = facedir; sfspdir
	and.w #$0007
	sta.w passdir
	lda.w #sfspdir
	tsb.w sflags
.rtl2:
	rtl
faceoffinput:		;controller processing for faceoff (93G logic93_1)
		;   SNES: faceoff player X: dpad into fodir1/fodir2, B pulls (SPAfaceoff)
	txa		; faceoff player only
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #afaceoffpl
	bne .rtl
	lda.w #fodir1
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w pfgoal,x
	beq .store
	lda.w #fodir2
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.store:
	lda.b d0
	sta.b [a0]
	lda.w pf2aip,x		; pf2aip set: already pulling
	bne .rtl
	lda.b d1
	bit.w #bbut
	beq .nob
	lda.w #SPAfaceoff
	sta.b d1
	lda.w #$0001
	sta.w pf2aip,x
	jmp.w SetSPA
.nob:
	lda.w #SPAfaceoffr
	sta.b d1
	jmp.w SetSPA
.rtl:
	rtl
holdplayer:		;abut press hold (92 Holdplayer). a0 = the player this one is (93G logic93_1)
		;   SNES: Y pressed: hold. With impact, hold the last player who hit X (Acheck)
	lda.w #SPAhook		; pfalock
	sta.b d1
	sta.w pfalock,x
	lda.w impact,x
	bne .imp
	jmp.w SetSPA
.imp:
	lda.w impactp,x		; a0 = d0 = impactp*2
	asl a
	sta.b d0
	sta.b a0
	jml.l Acheck		; bank $8F: 93G Acheck
