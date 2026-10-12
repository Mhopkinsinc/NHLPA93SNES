asspassrec:		;asstab $13. assignment for catching pass. Assignment apassrec ($13)
		;   SNES: assignment for catching a pass
	lda.w pfalock,x
	bne .rts		; locked
	lda.w gmclock		; clock stopped
	beq .joy
	jml.l assnothing
.joy:
	lda.w pflags,x
	bit.w #pfjoycon		; joystick controlled
	beq .na
	jmp.w assexit
.na:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF		; clear pfna, set pfdoff
	ora.w #pfdoff
	sta.w pflags,x
	stz.w temp2,x		; temp2 = 8
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w puckc		; puck loose: wait temp1 frames
	bpl .ex
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .rts
.ex:
	lda.w pflags,x		; clear pfdoff
	and.w #~pfdoff&$FFFF
	sta.w pflags,x
	jmp.w assexit
.rts:
	rtl
