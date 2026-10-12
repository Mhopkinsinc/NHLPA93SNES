; Penalties, scoreboard, ticker, intermission.
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82F93C
SetPA2:		;update animation for ref. Next frame/delay pair from the PenaltyList animation of RefPen. Also called from UpdatePA
		;   SNES: a negative pair is the last one (RefStep = -1). RefCnt = delay*8, then PushRef
	phx
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	lda.w #$0040		; d0 = $40 (clear the ref window) when RefStep is negative
	sta.b d0
	lda.w RefStep
	bmi .pr
	sta.b d0
	inc.w RefStep
	inc.w RefStep
	lda.w RefPen		; PenaltyList entry of RefPen: its animation offset (+2), then the frame/delay word at RefStep
	sta.b d1
	tax
	lda.l PenaltyList,x
	inc a
	inc a
	tax
	clc
	adc.l PenaltyList,x
	adc.b d0
	tax
	lda.l PenaltyList,x
	sta.b d0
	bpl .0
	eor.w #$FFFF		; negative: last pair, RefStep = -1
	inc a
	sta.b d0
	lda.w #$FFFF
	sta.w RefStep
.0:
	lda.b d0		; RefCnt = delay * 8, d0 = frame
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d1
	sta.w RefCnt
	lda.b d0
	xba
	and.w #$00FF
	sta.b d0
.pr:
	jsl.l PushRef		; bank $8F
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	plx
	rtl
UpdateScores:		;update ticker score values. Called from PeriodOver
		;   SNES: update the ticker scores of the other playoff games (not gamenum, not over)
	jsl.l GetShifter		; GetShifter: d1 = games - 1
	lda.b d1
	sta.w TickerNum
	asl a
	sta.b a0
.top:
	lda.b d1
	cmp.w gamenum
	beq .next
	ldy.b a0
	lda.w gsflags,y		; clear gsfhl; game not over: SetScore
	and.w #~gsfhl&$FFFF
	sta.w gsflags,y
	bit.w #gsfso
	bne .next
	jsl.l SetScore		; bank $8A
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
	rtl

org $82FD95
ClearPenaltyMessage:		;blank the horizontal mode penalty message line (22 spaces at x 5, y $B)
	jsl.l printz
	dw $001B		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0B,"                      "
	rtl
