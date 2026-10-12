chk4lc:		;see if computer should call line change
		;   SNES: should the computer call a line change? Then shoot the puck in (CompShoot)
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .gu
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.gu:
	lda.b d0
	bmi .rts
	sec
	sbc.w #blueline		; blueline
	beq .inzone
	bmi .v1
	bvs .inzone
	bra .rts
.v1:
	bvs .rts
.inzone:		;in own half, inside the blue line
	lda.w seed
	and.w #$0003		; one time in four
	bne .rts
	lda.w pflags,x
	bit.w #pf2lcm		; pf2lcm
	bne .rts
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .0
	stz.b a1
	lda.w #$0002
	sta.b a2
.0:		;a2 = own team, a1 = other team
	jsl.l AvgCline
	lda.b d0
	cmp.w #$0C01		; average energy of the line still above $C00: no change
	bcs .rts
	jsl.l CompLine
	jsl.l setpersonel
	jsl.l printscores1
	jmp.w CompShoot
.rts:
	rtl
