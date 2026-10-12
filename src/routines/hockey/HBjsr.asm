HBjsr:		;IRQ vector: jump through hbint when the timer fired
	rep #$30
	pha
	phx
	phy
	sep #$20
	lda.w TIMEUP
	bpl HBdefault		; not a timer IRQ
	rep #$30
	lda.b hbint
	dec a
	pha
	rts
