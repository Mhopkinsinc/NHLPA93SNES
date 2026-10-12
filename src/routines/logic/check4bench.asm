check4bench:		;If a line change wants player X off, send him to the bench (or just change his position when he stays on)
	lda.w pflags,x
	bit.w #pfjoycon|pf2pen		; joystick controlled, or penalty
	bne .rts
	lda.w newpos,x
	bpl .b		; newpos negative: only a new roster player counts
	lda.w newpnum,x
	bmi .rts
.b:		;newpos or newpnum requested
	lda.w newpnum,x
	cmp.w pnum,x		; same roster player: just a position change
	beq .samepl
	txa		; current assignment: asslist+X*4+assnum
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #abench		; already going to the bench
	beq .rts
	txa
	lsr a
	cmp.w puckc		; puck carrier stays
	beq .rts
	sep #$20		; pop the jsl return address
	pla
	rep #$30
	pla
	lda.w pflags,x
	ora.w #pf2unav		; pf2unav
	sta.w pflags,x
	stz.w temp1,x
	lda.w #abench		; abench
	sta.b d0
	jmp.w assreplace
.rts:
	rtl
.samepl:		;same roster player: just change position
	sep #$20		; pop the jsl return address
	pla
	rep #$30
	pla
	lda.w pflags,x
	and.w #~pf2unav&$FFFF		; clear pf2unav
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w position,x		; d0 = position (newpos is negative here)
	sta.b d0
	jmp.w Setplass
