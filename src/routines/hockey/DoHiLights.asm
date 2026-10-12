DoHiLights:		;Playoffs: play the highlight of each game of the round that has one
	lda.w OptPlayMode
	beq .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.top:
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .next
	bit.w #$0002
	beq .next
	and.w #$FFFD
	sta.w gsflags,y
	jsl.l SaveRegsStartHL2
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
.rtl:
	rtl
