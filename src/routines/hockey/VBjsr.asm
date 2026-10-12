VBjsr:		;NMI: jump through the vblank handler vector
	rep #$30
	pha
	lda.w RDNMI
	bit.w #$0080
	beq .skip		; not a vblank NMI
	lda.b vbactive
	beq .dispatch
.skip:		;not a vblank NMI, or the last handler still runs
	pla
	rti
.dispatch:		;push vbint-1 and rts into it (A/X/Y stay on the stack for the handler to pull)
	inc.b vbactive
	phx
	phy
	lda.b vbint
	dec a
	pha
	rts
