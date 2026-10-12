FightFall:		;X lost the fight: the a0 player gets PenFighting, maybe X is injured
	lda.b a1+2		; push a1
	pha
	lda.b a1
	pha
	lda.w #PenaltyBufferEnd		; a1 = penalty list
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.loop:		;find the fight penalty of the a0 player
	inc.b a1
	inc.b a1
	lda.b [a1]
	and.w #$00FF
	cmp.w #PenFight
	bne .loop
	lda.b [a1]
	xba
	and.w #$000F
	sta.b d0
	ldy.b a0
	cmp.w SCnum,y		; penalty of the a0 player?
	bne .loop
	sep #$20
	lda.b #PenFighting		; it becomes PenFighting
	sta.b [a1]
	rep #$20
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$003C		; 60
	sta.w Pencntdwn
	lda.w #$FFFF		; temp3(a0) = -1: fight over for him
	sta.w temp3,y
	lda.b crowdlevel
	clc
	adc.w #$0258		; +600
	sta.b crowdlevel
	lda.w #$003C
	sta.b d0
	jsl.l randomd0
	ldy.b a0
	lda.b d0
	sec
	sbc.w aggress,y		; random 60 vs the winner aggress: injury?
	beq .inj
	bmi .neg
	bvs .inj
	bra .noinj
.neg:
	bvs .noinj
.inj:		;player X is injured
	lda.w #$00B4		; 180: player is injured
	sta.w Pencntdwn
	lda.w pflags,x
	ora.w #pf2inj
	sta.w pflags,x
	lda.w #SPAfinjury
	sta.b d1
	jsl.l SetSPA
	stx.b a2
	jsl.l setInjuryType		; setInjuryType (bank $8F): d1 = roster offset, bank $8F
	lda.b a0
	beq .team
	lda.w #$0034
.team:
	clc
	adc.b d1
	tay
	lda.w #INJfight		; tmpdst of the injured player = INJfight
	sta.w tmpdst,y
	lda.w #$0003
	sta.w InjCntDown		; InjCntDown = 3
	stz.w Xvel,x
	jmp.w chkhit_ex
.noinj:
	lda.w #SPAffall
	sta.b d1
	jsl.l SetSPA
	stz.b a2
	lda.w #SFXcrowdcheer		; home won: cheer
	pha
	lda.w pfteam,x
	bne .snd
	lda.w #$0002
	sta.b a2
	lda.w #SFXcrowdboo
	sta.b $01,s
.snd:
	jsl.l sfx
	jmp.w chkhit_ex
