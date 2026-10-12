assfaceoffpl:		;asstab $17. assignment for players actually participating in faceoff
		;   SNES: assignment for the players taking the faceoff
	lda.w pfalock,x
	beq .go
	jmp.w .rts
.go:
	lda.w sflags
	bit.w #sf2faceoff		; faceoff over
	beq .exit
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w #fofdata2		; a0 = fofdata2, +4 for the visitors
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w pfteam,x
	beq .0
	lda.w #fofdata2+4
	sta.b a0
.0:
	lda.w SPAnum,x		; frame = SPAnum/4 + 1, +3 for a righty
	lsr a
	lsr a
	inc a
	sta.b d0
	lda.w handed,x
	bne .lefty
	inc.b d0
	inc.b d0
	inc.b d0
.lefty:
	lda.b d0
	sta.b [a0]
	lda.w pflags,x
	bit.w #pfjoycon		; joystick: the player pulls
	bne .rts
	lda.w pf2aip,x		; set pf2aip, test the old value
	pha
	lda.w #$0001
	sta.w pf2aip,x
	pla
	cmp.w #$0000
	bne .rts
	lda.w #SPAfaceoff
	sta.b d1
	lda.w temp1+puckobj		; puck temp1 > $10: 7 in 8 reverse pull
	cmp.w #$0011
	bcc .d
	lda.w #$0008
	sta.b d0
	jsl.l randomd0
	lda.b d0
	beq .d
	lda.w #SPAfaceoffr
	sta.b d1
.d:
	lda.w #$0001
	sta.w pf2aip,x
	jmp.w SetSPA
.rts:
	rtl
.exit:
	lda.w #$0014		; nopuck = 20
	sta.w nopuck,x
	jmp.w assexit
