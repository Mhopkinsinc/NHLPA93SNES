SetPA:		;start ref animation. d0 = animation (penalty number)
		;   SNES: start the ref animation for penalty d0: prefmes, ShowGoalBox for a goal, penmsgtimer (60 in horizontal mode), then SetPA2
	lda.b d0		; RefPen = d0, RefStep = 0, prefmes
	sta.w RefPen
	stz.w RefStep
	jsl.l prefmes
	lda.b d0
	cmp.w #PenGoal		; goal: the goal box
	bne .0
	jsl.l ShowGoalBox
.0:
	lda.w #$7FFF
	sta.w penmsgtimer
	lda.w sfhormode
	beq .pa2
	lda.w #$003C
	sta.w penmsgtimer
.pa2:
	jml.l SetPA2
