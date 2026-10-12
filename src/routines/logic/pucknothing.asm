pucknothing:		;Assignment: the puck just slides and stops spinning
	lda.w SPAnum+puckobj
	cmp.w #$0008		; SPAnum 2*4..6*4: flip the face
	bcc .k
	cmp.w #$0018
	bcs .k
	lda.w facedir+puckobj
	eor.w #$0002
	sta.w facedir+puckobj
.k:
	lda.w #$0004		; facedir |= 4
	tsb.w facedir+puckobj
	stz.w SPAnum+puckobj		; SPAnum = 0, SPAcnt = -1 (restart)
	lda.w #$FFFF
	sta.w SPAcnt+puckobj
	rtl
