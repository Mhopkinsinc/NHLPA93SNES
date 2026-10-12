faceoffinput:		;Pad input for a player taking a face off
	txa		; faceoff player only
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #afaceoffpl
	bne .rtl
	lda.w #fodir1
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w pfgoal,x
	beq .2
	lda.w #fodir2
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.2:
	lda.b d0
	sta.b [a0]
	lda.w pf2aip,x		; pf2aip set: already pulling
	bne .rtl
	lda.b d1
	bit.w #bbut
	beq .1
	lda.w #SPAfaceoff
	sta.b d1
	lda.w #$0001
	sta.w pf2aip,x
	jmp.w SetSPA
.1:
	lda.w #SPAfaceoffr
	sta.b d1
	jmp.w SetSPA
.rtl:
	rtl
