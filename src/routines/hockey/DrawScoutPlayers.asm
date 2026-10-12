DrawScoutPlayers:		;Draw the two players shown on the scouting report
	ldx.w #$0000
	stx.b a3
	jsl.l DrawScoutPlayer
	ldx.w #$000C
	stx.b a3
DrawScoutPlayer:		;SNES: addframe for object X at (Xpos + OldXpos - 144, Ypos - 128)
	lda.w Xpos,x
	clc
	adc.w OldXpos,x
	sec
	sbc.w #$0090
	sta.b sprx
	lda.w Ypos,x
	sec
	sbc.w #$0080
	sta.b spry
	lda.w frame,x
	sta.b sprframe
	lda.w attribute,x
	and.w #$0800
	sta.b sprhflip
	lda.w attribute,x
	and.w #$1000
	sta.b sprvflip
	lda.w attribute,x
	lsr a
	bcc .add
	lda.w #$8000
	sta.b sprflag
.add:
	jml.l addframe
