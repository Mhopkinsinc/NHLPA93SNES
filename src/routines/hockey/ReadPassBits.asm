ReadPassBits:		;Turn the password bits back into the playoff state; a bad checksum marks the password invalid
	lda.w #512		; checksum first (range 512)
	sta.b d0
	jsl.l SuperDiv
	lda.b d0
	pha
	stz.b d7
	lda.w #7
	sta.b d2
	lda.w #14
	sta.b a1
.0:		;the 8 series scores, range 5
	ldy.b a1
	lda.w gsflags,y		; gsftf off
	and.w #$FFFB
	sta.w gsflags,y
	lda.w #5
	sta.b d0
	jsl.l .sd
	lda.b d0
	ldy.b a1
	sta.w gspobwins,y
	cmp.w #4		; 4 wins: gsftf (series over)
	bne .nsf0
	lda.w gsflags,y
	ora.w #$0004
	sta.w gsflags,y
.nsf0:
	lda.w #5
	sta.b d0
	jsl.l .sd
	ldy.b a1
	lda.b d0
	sta.w gspotwins,y
	cmp.w #4
	bne .nsf1
	lda.w gsflags,y
	ora.w #$0004
	sta.w gsflags,y
.nsf1:
	dec.b a1
	dec.b a1
	dec.b d2
	bpl .0
	lda.w #$4000
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w WinBits
	lda.w #4
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w pojoy
	lda.w #16
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w potreeteam
	lda.w #4
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w gamelevel
	lda.w #8
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.b bosgames
	lda.w #32
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w postarts
	lda.b d7
	and.w #$01FF
	sta.b tmp0
	pla
	cmp.b tmp0
	beq .rtl
	lda.w #$FFFF		; bad password
	sta.w postarts
.rtl:
	rtl
.sd:		;d0 = passbits mod d0 (SuperDiv), added to the checksum d7
	jsl.l SuperDiv
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	rtl
