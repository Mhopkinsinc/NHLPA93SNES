ScoutNextPlayer:		;The next player of team a2 to show on the scouting report, with an animation picked from his ratings
	jsl.l SetTeamColors
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFFD
	sta.w tmflags,y
	lda.w tmsort,y
	sta.b a3
	tax
	lda.w #-40
	sta.w OldXpos,x
	stz.w SPA,x
.order:
	ldy.b a2
	lda.w tmPwrGoals,y
	sta.b d0
	tay
	lda.w #ScoutLineOrder		; ScoutLineOrder[tmPwrGoals]: $FF restarts the list
	sta.b a0
	lda.w #ScoutLineOrder>>16
	sta.b a0+2
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	beq .got
	ldy.b a2
	lda.w #$0000
	sta.w tmPwrGoals,y
	bra .order
.got:
	ldy.b a2
	lda.b d0
	sta.w tmPenalties,y
	lda.w tmPwrGoals,y
	inc a
	sta.w tmPwrGoals,y
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmdata,y		; roster player = LineSets byte - 1 (goalie slot: tmgoalie)
	sta.b a0
	clc
	ldy.w #LineSets
	adc.b [a0],y
	sta.b a0
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	dec a
	sta.b d0
	ldy.b a2
	lda.w tmPenalties,y
	bne .pl
	lda.w tmgoalie,y
	sta.b d0
.pl:
	lda.b d0
	ldy.b a2
	sta.w tmPwrPlays,y
	jsl.l GetRosterEntry
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.w attribute,x		; handedness bit: flip
	and.w #$F7FF
	sta.w attribute,x
	ldy.w #Playerdata+4
	lda.b [a0],y
	lsr a
	bcs .rate
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
.rate:		;ScoutPickScript for each of the 14 rating nibbles (ScoutScriptPick, goalies ScoutScriptPickG)
	inc.b a0
	lda.w #$0006
	sta.b d0
	stz.b d2
	lda.w #ScoutScriptPick
	sta.b a1
	lda.w #ScoutScriptPick>>16
	sta.b a1+2
	ldy.b a2
	lda.w tmPenalties,y
	and.w #$0007
	sta.b d3
	bne .nib
	lda.w #ScoutScriptPickG
	sta.b a1
.nib:
	lda.b [a0]
	and.w #$00FF
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
	jsl.l ScoutPickScript
	lda.b [a0]
	inc.b a0
	and.w #$000F
	sta.b d1
	jsl.l ScoutPickScript
	dec.b d0
	bpl .nib
	ldy.b a2
	lda.w #$0000
	sta.w tmATOP,y
	rtl
