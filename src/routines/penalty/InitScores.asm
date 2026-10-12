InitScores:		;initialize other games scores/period in playoffs. Called from StartGame
		;   SNES: playoff rounds 0-1: random scores so far for the other games of the round (SetScore 1-3 times)
	lda.w OptPlayMode
	beq .rtl
	lda.w gamelevel
	cmp.w #$0002
	bcs .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.top:
	lda.b d1
	cmp.w gamenum
	beq .next
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .next
	lda.w #$0000
	sta.w gsper,y
	lda.w #$0003
	sta.b d0
	jsl.l randomd0
	bra .1
.0:
	jsl.l SetScore
.1:
	dec.b d0
	bpl .0
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
.rtl:
	rtl
