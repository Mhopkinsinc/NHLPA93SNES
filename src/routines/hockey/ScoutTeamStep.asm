ScoutTeamStep:		;Step team a2's player on the scouting report through his animation, then print his number and name
	ldy.b a2
	lda.w tmteam,y		; team changed?
	sta.b d0
	cmp.w tmshots,y
	beq .cur
	sta.w tmshots,y
	jsl.l PickStartingGoalie
	ldy.b a2
	lda.w #$0000
	sta.w tmPwrGoals,y
	jsl.l ScoutPlayerExit
.cur:
	ldy.b a2
	lda.w tmsort,y		; X = a3 = first object of the team
	sta.b a3
	tax
	lda.w tmflags,y
	bit.w #$0002
	beq .in
	inc.w OldZpos,x		; skating out: x += 3
	inc.w OldZpos,x
	inc.w OldZpos,x
	inc.w OldXpos,x
	inc.w OldXpos,x
	inc.w OldXpos,x
	lda.w OldXpos,x
	sec
	sbc.w #40
	beq .rtl
	bmi .neg
	bvs .rtl
.next1:
	jmp.w ScoutNextPlayer
.neg:
	bvs .next1
.rtl:
	rtl
.in:		;skating in from the left
	lda.w OldXpos,x		; skating in: x += 1 while negative
	bpl .anim
	inc.w OldZpos,x
	inc.w OldXpos,x
.anim:
	jsl.l updateanim
	lda.w pf2aip,x		; pf2aip: wait for the step delay
	beq .step
	jmp.w ScoutPlayerExit_rtl
.step:		;next script step
	ldy.b a2
	lda.w tmPenmin,y		; a0 = ScoutScripts + offset of the script + step; step += 4
	asl a
	sta.b d0
	tay
	lda.w #ScoutScripts>>16
	sta.b a0+2
	lda.w #ScoutScripts
	sta.b a0
	clc
	adc.b [a0],y
	ldy.b a2
	adc.w tmATOP,y
	sta.b a0
	lda.w tmATOP,y
	adc.w #$0004
	sta.w tmATOP,y
	lda.b [a0]
	sta.b d1
	bne .set
	jmp.w ScoutPlayerExit
.set:
	jsl.l SetSPA		; SetSPA d1, 9 frames per step, facedir
	lda.w #$0009
	sta.w pf2aip,x
	ldy.w #$0002
	lda.b [a0],y
	sta.w facedir,x
	bmi .flip
	jmp.w ScoutPlayerExit_rtl
.flip:		;negative facedir: first step of a new player, print the name
	eor.w #$FFFF
	inc a
	sta.w facedir,x
	ldy.b a2
	lda.w tmPwrPlays,y
	sta.b d0
	jsl.l GetRosterEntry		; mesarea = number and the first name, centered in 11 columns
	jsl.l ScoutNamePos
	lda.w printx
	pha
	lda.w #mesarea+2
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b [a0]
	tay
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	beq .lo
	clc
	adc.w #$0030
	sta.b [a1]
	inc.b a1
.lo:
	lda.b d0
	and.w #$000F
	clc
	adc.w #$0030
	sta.b [a1]
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	ldy.w #$0001
.first:
	iny
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$0020
	beq .pr1
	sta.b [a1]
	inc.b a1
	bra .first
.pr1:
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	dec a
	dec a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000B
	lsr a
	clc
	adc.w printx
	sta.w printx
	lda.w #mesarea
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	lda.b [a0]		; then the last name on the next line
	sta.b tmp0
	ldy.w #$0001
.skip:
	iny
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$0020
	bne .skip
	lda.w #mesarea+2
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.last:
	iny
	cpy.b tmp0
	beq .pr2
	lda.b [a0],y
	sta.b [a1]
	inc.b a1
	bra .last
.pr2:
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	dec a
	dec a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000B
	lsr a
	clc
	adc.w printx
	sta.w printx
	lda.w #mesarea
	sta.b a1
	jml.l print
