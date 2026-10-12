lcfound2:		;Close the line change box and redraw the scoreboard
	jsl.l setlccords
	lda.w printy
	sec
	sbc.w #15
	bmi .neg
	bvc .low
	bra .nollcm
.neg:
	bvc .nollcm
.low:
	lda.w #sf3llcs
	trb.w sflags3
.nollcm:
	inc.b d1
	lda.w blankchar
	sta.b d2
	lda.b fobox
	bne .print
	jsl.l eraser
.print:
	jml.l printscores1
