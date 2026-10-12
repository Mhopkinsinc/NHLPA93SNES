SetShotMode:		;initiate shot by player a3
		;   SNES: start a shot by player X: shot mode, direction to goal, shot animation
	lda.w #$0008		; default shot direction: none
	sta.w passdir
	lda.w #sfssdir
	tsb.w sflags
	stz.b d0
	lda.w #$0128		; $128: goal y + 40
	sta.b d1
	lda.w pfgoal,x
	bne .ck0
	lda.w #$FED8
	sta.b d1
.ck0:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.w #$000F		; minimum shot speed
	sta.w passspeed
	lda.w #SPAshotf		; SPAshotf $81C
	sta.b d1
	jsl.l Findhittype		; Z = forehand
	beq .ck1
	lda.w #SPAshotb		; SPAshotb $94E
	sta.b d1
.ck1:
	jmp.w SetSPA
