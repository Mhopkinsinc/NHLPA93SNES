periodicevents:		;called every time thru game loop with d7 = elapsed frames
		;   SNES: every game loop; once a second (lldisp) the slower checks
	jsl.l PenaltyManager		; PenaltyManager
	jsl.l updatecrowdf		; updatecrowdf
	jsl.l updatesound		; updatesound
	jsl.l clockcont		; clockcont
	lda.w sfhormode		; horizontal: no screen updates
	bne .rtl
	lda.w lldisp
	sec
	sbc.b d7
	sta.w lldisp
	bpl .rtl
	clc
	adc.w #$0018		; +$18 frames
	sta.w lldisp
	jsl.l ChkGoalies		; ChkGoalies
	jsl.l UpdateCwdExcite		; UpdateCwdExcite
	jsl.l CheckLateGameSong		; CheckLateGameSong
	jsl.l RestoreBenchEnergy		; RestoreBenchEnergy
	jsl.l CheckInjury		; CheckInjury
	jmp.w updatepwrplay
.rtl:
	rtl
