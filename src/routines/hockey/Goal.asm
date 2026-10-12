Goal:		;puck in goal. a3 = puck. Entered from checkgoal
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
	jsl.l printscores1
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
	bpl .1
	lda.w #$FFFA
	sta.b d0
.1:
	lda.b d0
	sta.w puckx
	lda.w #$0110
	sta.b d0
	lda.w pucky
	bpl .0
	lda.w #$FEF0
	sta.b d0
.0:
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
.setass:		;give each skater of team a2 that is not fighting assignment d0, clear pfnc
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
