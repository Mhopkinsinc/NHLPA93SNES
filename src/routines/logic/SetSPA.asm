SetSPA:		;Start sprite animation d1 on object X
	lda.b d1
	cmp.w SPA,x		; same animation: keep going
	beq .rtl
	sta.w SPA,x
	stz.w SPAnum,x		; SPAnum = 0, SPAcnt = -1
	lda.w #$FFFF
	sta.w SPAcnt,x
.rtl:
	rtl
