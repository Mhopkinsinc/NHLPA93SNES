ClearOffsidesIfAllPlayers:		;a2 = team struct. Clears the team offsides flag (tmflags bit 4) once no skater on ice is past the blue line ($58, sign by pfgoal). Called twice from ChkOffsides
		;   SNES: clear tmfoffside once no skater is past the blue line
	ldy.b a2
	lda.w tmflags,y		; tmfoffside
	bit.w #tmfoffside
	bne .go
	jmp.w ChkOffsides_rtl
.go:
	lda.w tmsort,y
	sta.b a0
	lda.w #$0005
	sta.b d1
.top:
	ldy.b a0
	lda.w position,y
	bmi .next
	lda.w Ypos,y
	sta.b d0
	lda.w pfgoal,y
	bne .next
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.next:
	inc.b a0
	inc.b a0
	lda.b d0
	sec
	sbc.w #blueline
	beq .more
	bmi .neg
	bvs .more
.rtl:
	jmp.w ChkOffsides_rtl
.neg:
	bvs .rtl
.more:
	dec.b d1
	bpl .top
	ldy.b a2
	lda.w tmflags,y
	and.w #~tmfoffside&$FFFF		; clear tmfoffside
	sta.w tmflags,y
	rtl
