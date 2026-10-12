; Penalties, scoreboard, ticker, intermission.
; Bank $8A. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8AFE21
SetScore:		;add to score for game in a0. After period 3 a game within one goal goes to OT (gsper 3) and asks for a highlight
		;   SNES: one period of playoff game a0: random goals by ScoreOdds (.getscore); after period 3 a game within one
		;   goal goes to overtime and asks for a highlight
	ldy.b a0
	lda.w gsper,y
	cmp.w #4
	bcc .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
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
	ldy.b a0
	lda.w gsper,y
	cmp.w #3		; after period 3
	bne .0
	lda.w #5		; final
	sta.w gsper,y
	lda.w gss1,y
	sec
	sbc.w gss2,y
	bit.w #$8000
	beq .diff
	eor.w #$FFFF
	inc a
.diff:
	cmp.w #2
	bcs .ex
	lda.w #3		; within one goal: overtime
	sta.w gsper,y
	lda.w gsflags,y
	ora.w #gsfhl		; gsfhl: show it in the ticker
	sta.w gsflags,y
	bra .ex
.0:
	lda.w gsper,y
	inc a
	sta.w gsper,y
	lda.w gst1,y
	sta.b d0
	lda.w gst2,y
	sta.b d1
	jsl.l .getscore
	ldy.b a0
	lda.w gss1,y
	clc
	adc.b d0
	sta.w gss1,y
	lda.w gst2,y
	sta.b d0
	lda.w gst1,y
	sta.b d1
	jsl.l .getscore
	ldy.b a0
	lda.w gss2,y
	clc
	adc.b d0
	sta.w gss2,y
.ex:
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
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
.getscore:		;d0 = scoring team, d1 = other team; nibblebuffer = the .sctab rows of both ScoreOdds nibbles; returns d0 = goals 0-3
	asl.b d0
	asl.b d0
	lda.w #TeamList		; TeamList entry of team d0
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b a1
	ldy.w #ScoutReport		; 8(a1): the ScoreOdds offset, ScoutReport in the record
	adc.b [a1],y
	sta.b a1
	lda.b [a1]
	and.w #$0070		; bits 4-6: row of the scoring team
	lsr a
	adc.w #.sctab
	sta.b a1
	lda.w #.sctab>>16
	sta.b a1+2
	lda.b [a1]
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	sta.w nibblebuffer+6
	asl.b d1
	asl.b d1
	lda.w #TeamList
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.b d1
	lda.b [a1],y
	sta.b a1
	ldy.w #ScoutReport
	adc.b [a1],y
	sta.b a1
	lda.b [a1]
	and.w #$0007		; bits 0-2: row of the other team
	asl a
	asl a
	asl a
	adc.w #.sctab
	sta.b a1
	lda.w #.sctab>>16
	sta.b a1+2
	lda.b [a1]
	adc.w nibblebuffer
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	adc.w nibblebuffer+2
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	adc.w nibblebuffer+4
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	adc.w nibblebuffer+6
	sta.w nibblebuffer+6
	lda.w #4		; 4 weights
	sta.b d0
	jml.l WeightedRandomSelect		; d0 weights in nibblebuffer
.sctab:		;weights for 0, 1, 2, 3 goals by ScoreOdds row
	dw $2B,$1E,$17,$04
	dw $27,$20,$18,$05
	dw $23,$21,$1A,$06
	dw $1E,$22,$1E,$06
	dw $1A,$24,$1E,$08
	dw $16,$25,$1F,$0A
	dw $13,$26,$1F,$0C
	dw $0F,$26,$20,$0F
unusedFF8A:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
