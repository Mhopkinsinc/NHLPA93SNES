puckflip:		;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal, wallcoll and others
		;   SNES: start the puck spinning. d0 bit 0 = flip
	lda.b d0
	and.w #$0001		; facedir of the puck ^= d0 bit 0, & 3
	sta.b d0
	eor.w facedir+puckobj
	and.w #$0003
	sta.w facedir+puckobj
	lda.w #$FFFF		; SPAcnt = -1
	sta.w SPAcnt+puckobj
	lda.w #SPApflip
	sta.b d1
	jmp.w SetSPA
