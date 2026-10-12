ReadJoy:		;read controller a0. Return d0 = direction (bit 0-3) and new button (bit 4-7) presses, d1 = buttons down (all 8 bits)
		;   SNES: X = 0/2: d1 = buttons held, d0 = direction from jdtab
	lda.w joypad1,x		; buttons
	sta.b d0+2
	sta.b d1
	xba		; r/l/d/u bits
	and.w #$000F
	tax
	lda.l jdtab,x
	and.w #$00FF
	sta.b d0
	rtl
