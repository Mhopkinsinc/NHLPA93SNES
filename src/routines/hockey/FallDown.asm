FallDown:		;player a2 falls down, player a3 is the hitting player. Some players stumble instead of a fall; also counts check stats for the hitter, has a third fall anim, and injuries (setInjuryType) with a penalty. Called from checkint .ci, checkcheck .cc and Bcheck; also entered from setd0player
		;   SNES: player a2 falls, X is the hitter. Stumble for some players, check stats, fall back/forward/third fall, injuries with a penalty and crowd sounds
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
.s6:		;stumble when stickhand (byte $71) >= $C, nopuckb is 0 and impact < $10-$1F
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
	jsl.l setInjuryType		; setInjuryType
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
	bne .3
	lda.w #SFXcrowdboo
	sta.b $01,s
.3:
	jsl.l sfx
.rtl:
	rtl
