setplayer:		;Bring roster player d3 onto the ice as object X and set his stats
	phx
	phy
	lda.w pflags,x		; clear pf2inj
	and.w #~pf2inj&$FFFF
	sta.w pflags,x
	stz.b a0
	lda.w pfteam,x
	beq .0
	inc.b a0
	inc.b a0
.0:
	lda.b d3
	and.w #$00FF
	sta.w pnum,x		; pnum = d3
	asl a
	sta.b d3
	lda.w #aepen		; aepen: from the penalty box
	sta.b d0
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpdst,y
	sta.b d1
	bpl .da
	lda.w #aeben		; aeben: from the bench
	sta.b d0
	lda.b d1
	cmp.w #TMPDBENCH
	bne .nda
.da:
	jsl.l assinsert
	stz.w pfalock,x		; pfalock = 0, SPA = 0
	stz.w SPA,x
.nda:
	lda.b a0
	beq .nda1
	lda.w #$0034
.nda1:
	clc
	adc.b d3
	tay
	lda.w #TMPDICE		; tmpdst = TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	ldy.b a0		; a0 = team data
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	ldy.w #$0008		; team data + word at +8: bonus bytes
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.w PPBonus		; all four bonuses = 0
	stz.w PKBonus
	stz.b ThirdPBonus
	stz.w HmAwBonus
	lda.w position,x		; goalie: no modifiers
	bne .mods
	jmp.w .nomod
.mods:
	lda.w sflags
	bit.w #sf2pwrplay		; sf2pwrplay
	beq .nda3
	jsl.l chkpk2
	beq .nda2
	ldy.w #$0001		; power play: PPBonus = low nibble of byte 1
	lda.b [a0],y
	and.w #$000F
	sta.w PPBonus
	bra .nda3
.nda2:
	ldy.w #$0001		; short-handed: PKBonus = -high nibble of byte 1
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.w PKBonus
.nda3:
	ldy.w #$0002		; HmAwBonus: home = high nibble of byte 2, visitors = -low nibble
	lda.b [a0],y
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfteam,x
	bne .tm
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
.tm:
	lda.b d0
	sta.w HmAwBonus
	lda.w gsp		; 3rd period?
	sec
	sbc.w #$0002
	bmi .neg
	bvc .p3
	bra .nomod
.neg:
	bvc .nomod
.p3:
	beq .half
	bmi .neg1
	bvs .half
	bra .score
.neg1:
	bvs .score
.half:
	jsl.l GetPeriodTime		; GetPeriodTime
	lsr.b d0
	lda.b d0
	sec
	sbc.w gameclock
	beq .score
	bmi .neg2
	bvs .score
	bra .nomod
.neg2:
	bvs .nomod
.score:
	lda.w tmscore		; tied or trailing: ThirdPBonus = 2
	sec
	sbc.w tmscore+2
	sta.b tmp0
	beq .close
	lda.w pfteam,x
	beq .side
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.side:
	lda.b tmp0
	bpl .nomod
.close:
	lda.w #$0002
	sta.b ThirdPBonus
.nomod:
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	ldy.w #$0000		; a0 = roster records
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.find:		;skip the roster records before player d3
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	dec.b d3
	bpl .find
	lda.b a0
	sec
	sbc.w #$0008
	sta.b a0
	lda.b [a0]		; byte 0: rostnum
	and.w #$00FF
	sta.w rostnum,x
	ldy.w #$0001		; byte 1: weight (high nibble*8), legstr
	lda.b [a0],y
	and.w #$00F0
	lsr a
	sta.w weight,x
	lda.b [a0],y
	and.w #$000F
	sta.w legstr,x
	iny		; byte 2: legspd, aioff
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.w legspd,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	eor.w #$000F		; frames to skip: (15-n+15)/2
	clc
	adc.w #$000F
	lsr a
	sta.w aioff,x
	iny		; byte 3: aidef, shotspd
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	eor.w #$000F
	clc
	adc.w #$000F
	lsr a
	sta.w aidef,x
	lda.b [a0],y
	and.w #$000F
	sta.w shotspd,x
	lda.w attribute,x		; clear the x flip
	and.w #~attrxflip&$FFFF
	sta.w attribute,x
	iny		; byte 4: aggress, handed, fightagg
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	sta.w aggress,x
	lda.b [a0],y
	and.w #$0001		; bit 0 set: left handed
	sta.w handed,x
	bne .ha
	lda.w attribute,x
	ora.w #attrxflip
	sta.w attribute,x
.ha:
	lda.b [a0],y
	and.w #$000E
	sta.w fightagg,x
	iny		; byte 5: stickhand, shotacc
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w stickhand,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w shotacc,x
	iny		; byte 6: endurance, spodds
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.w endurance,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.b ThirdPBonus
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	sta.w spodds,x
	iny		; byte 7: passacc, GGSleft
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w passacc,x
	lda.b [a0],y
	and.w #$000F
	sta.w GGSleft,x
	ply
	plx
	rtl
