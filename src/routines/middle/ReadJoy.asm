ReadJoy:		;Read one pad: d1 = buttons held, d0 = its direction
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
