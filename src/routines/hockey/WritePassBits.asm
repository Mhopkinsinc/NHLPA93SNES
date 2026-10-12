WritePassBits:		;transfer game variables to the password bits at a3, without the checksum.
		;   SNES: playoff state into passbits (PushBits with each range), then the 9-bit checksum of the values (d7) with range 512
	jsl.l ClrPassBits
	stz.b d7
	lda.w postarts		; PushBits ranges: postarts 32, bosgames 8, gamelevel 4, potreeteam 16, pojoy 4, WinBits $4000
	sta.b d0
	lda.w #32
	sta.b d1
	jsl.l .pb
	lda.b bosgames
	sta.b d0
	lda.w #8
	sta.b d1
	jsl.l .pb
	lda.w gamelevel
	sta.b d0
	lda.w #4
	sta.b d1
	jsl.l .pb
	lda.w potreeteam
	sta.b d0
	lda.w #16
	sta.b d1
	jsl.l .pb
	lda.w pojoy
	sta.b d0
	lda.w #4
	sta.b d1
	jsl.l .pb
	lda.w WinBits
	sta.b d0
	lda.w #$4000
	sta.b d1
	jsl.l .pb
	lda.w #5
	sta.b d1
	lda.w #7
	sta.b d2
	stz.b a1
.0:		;the 8 series scores, range 5
	ldy.b a1
	lda.w gspotwins,y
	sta.b d0
	jsl.l .pb
	ldy.b a1
	lda.w gspobwins,y
	sta.b d0
	jsl.l .pb
	inc.b a1
	inc.b a1
	dec.b d2
	bpl .0
	lda.b d7		; checksum
	and.w #$01FF
	sta.b d0
	lda.w #512
	sta.b d1
	jsl.l PushBits
	rtl
.pb:		;d7 += d0, then PushBits
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	jml.l PushBits
