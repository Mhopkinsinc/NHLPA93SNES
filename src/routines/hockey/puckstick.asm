puckstick:		;The puck hits player a2's stick
	ldy.b a2
	lda.w position,y
	bne .0
	lda.w gmode
	bit.w #gmhl		; gmhl: goalie ignores the puck
	beq .0
	jmp.w .rtl
.0:
	lda.w pflags,y
	and.w #~pfdoff&$FFFF		; clear pfdoff
	sta.w pflags,y
	lda.w puckc
	bpl .carried
	jmp.w .nosteal
.carried:
	asl a
	sta.b a0
	tay
	lda.w pfteam,y
	beq .t1
	lda.w #$0001
.t1:
	sta.b tmp0
	ldy.b a2
	lda.w pfteam,y
	beq .t2
	lda.w #$0001
.t2:
	eor.b tmp0
	bne .range
	jmp.w .rtl
.range:
	lda.b d0
	cmp.w #$0025		; 6*6: smaller range for stealing
	lda.b d0+2
	sbc.w #$0000
	bcc .roll
	jmp.w .rtl
.roll:		;steal roll: carrier stickhand - stealer stickhand + 36
	lda.w position,y
	beq .steal		; goalie always steals
	ldy.b a0
	lda.w position,y
	bne .rnd
	jmp.w .rtl
.rnd:
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	pha
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	pla
	sec
	sbc.b d0
	clc
	adc.w #$0024
	jsl.l randoma
	cmp.w #$0003		; steal fails
	bcs .rtl
.steal:
	ldy.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	clc
	adc.w #$0014		; nopuck = makepde(stickhand) + 20 for both
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	clc
	adc.w #$0014
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	tya
	lsr a
	sta.w lastplayer		; lastplayer = the old carrier
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
.stdef:		;stick deflect sound, touch, deflect
	lda.w seed+1		; stick deflect sound (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	jsl.l a2touchpuck
	jmp.w deflect		; deflect
.rtl:
	rtl
.nosteal:
	ldy.b a2
	lda.w position,y
	bne .spd
	lda.b d0
	cmp.w #$0041		; goalie: loose puck within 8
	lda.b d0+2
	sbc.w #$0000
	bcs .rtl
.spd:		;catch if the puck speed^2 <= (13000+700*stickhand)^2
	lda.w puckvx
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w puckvy
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	stz.b d1
	lda.w sflags		; sf2shot: no stickhand bonus
	bit.w #sf2shot
	bne .nohand
	ldy.b a2
	lda.w stickhand,y
	sta.b mulb
	lda.w #$02BC		; * 700
	sta.b mula
	jsl.l mulu16		; mulu, mulres = mula*mulb
	sta.b d1
.nohand:
	lda.b d1
	clc
	adc.w #$32C8		; + 13000
	sta.b mula
	sta.b mulb
	jsl.l mulu		; mulres = mula*mulb
	cmp.b d0
	lda.b mulres+2
	sbc.b d0+2
	bcs puckglue
	ldy.b a2
	lda.w #$0008		; too fast: nopuck 8, deflect
	sta.w nopuck,y
	jmp.w .stdef
