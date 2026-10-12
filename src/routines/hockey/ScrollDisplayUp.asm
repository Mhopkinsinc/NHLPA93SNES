ScrollDisplayUp:		;The next line of the scouting report text; scroll the text box up when it is full
	stz.w DispAttribCtr
	inc.w VertLineScrolling
	lda.w VertLineScrolling
	sec
	sbc.w #$0007
	bmi .neg
	bvc .up
.ex1:
	jmp.w UpdateScoutingDisplay_rtl
.neg:
	bvc .ex1
.up:
	dec.w VertLineScrolling
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .save
	ldx.b xsave
	lda.w #$0007
	sta.b d3
	lda.w #textmap+$114		; textmap+$114: the text box
	sta.b d1
	lda.w #textmap>>16
	sta.b d1+2
.loop:
	lda.w #$0028
	sta.b d0
	lda.b d1
	clc
	adc.w #$0040
	sta.b d2
	lda.b d1+2
	sta.b d2+2
	jsl.l CopyWords		; copy a textmap row
	lda.b d2
	sta.b d1
	lda.b d2+2
	sta.b d1+2
	dec.b d3
	bpl .loop
	stx.b xsave
	ldx.w #$000E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
