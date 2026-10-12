deflect:		;Send the puck off in a random direction after a deflection
	lda.w #$FFFF		; puck loose
	sta.w puckc
	lda.w #$1000		; random velocity +-$1000 in y and x, 0..$1000 up
	jsl.l randomd0s
	sta.w puckvy
	lda.w #$1000
	jsl.l randomd0s
	sta.w puckvx
	lda.w #$1000
	jsl.l randoma
	sta.w puckvz
	jmp.w puckflip		; puckflip
