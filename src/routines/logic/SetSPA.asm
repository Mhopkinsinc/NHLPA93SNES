SetSPA:		;set sprite animation on struct a3. d1 = new animation
		;   SNES: set sprite animation d1 on object X (restart at frame 0)
	lda.b d1
	cmp.w SPA,x		; same animation: keep going
	beq .rtl
	sta.w SPA,x
	stz.w SPAnum,x		; SPAnum = 0, SPAcnt = -1
	lda.w #$FFFF
	sta.w SPAcnt,x
.rtl:
	rtl
