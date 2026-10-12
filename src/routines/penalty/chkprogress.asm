chkprogress:		;Move the referee and the game through a penalty: when the stop delay runs out, switch to the horizontal rink
		;   for the player to go to the box
	lda.w gmode		; gmpen: ref in progress
	bit.w #gmpen
	bne .pen
	jmp.w .rtl
.pen:
	lda.w Pencntdwn		; Pencntdwn negative: InProgress
	bpl .cnt
	jmp.w InProgress
.cnt:
	sec
	sbc.b d7
	sta.w Pencntdwn
	bmi .out
	jmp.w .rtl
.out:
	lda.w #gmpendel		; stop delay over: clear gmpendel
	trb.w gmode
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.find:
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	beq .rtl
	dec.b a0
	dec.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.w #PenaltyList
	sta.b a1
	clc
	adc.b [a1],y
	sta.b a1
	lda.b [a1]		; penalty with minutes?
	and.w #$00FF
	beq .find
	lda.w #sf2drec		; sf2drec, SetHor, load the horizontal ref; the puck does nothing for 120 s
	tsb.w sflags
	jsl.l SetHor
	jsl.l NewTicker		; horizontal ref
	lda.w #$FF00
	tsb.w puckc
	ldx.w #puckobj
	stx.b a3
	lda.w #pnothing
	sta.b d0
	jsl.l assinsert
	lda.w #$1C20
	ldx.b a3
	sta.w temp1,x
	lda.w #$FF00		; RefStep negative, RefCnt 0; UpdatePA; RefCnt 50; PushRef 0
	tsb.w RefStep
	stz.w RefCnt
	jsl.l UpdatePA
	lda.w #$0032
	sta.w RefCnt
	stz.b d0
	jsl.l PushRef
.rtl:
	rtl
