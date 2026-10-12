ShotMode:		;Pad input while shooting: aim with the pad and build shot power during the windup; releasing the button
		;   swings through. Shoots at the end of the animation
	lda.w SPAnum,x
	cmp.w #$0018		; 7*4: end of the animation
	bcs doshot
	lda.b d0
	bit.w #$0008
	bne .ss0
	and.w #$0007
	sta.w passdir
.ss0:
	lda.w SPAnum,x
	cmp.w #$0010		; 4*4: past full windup
	bcs .rts
	lda.w passspeed
	clc
	adc.b d7
	sta.w passspeed
	lda.b d2
	bit.w #cbut		; button released
	beq .rts
	lda.w #$001C		; end the windup and swing through
	sec
	sbc.w SPAnum,x
	sta.w SPAnum,x
	cmp.w #$0018
	bcc .rts
	lda.w #$0018
	sta.w SPAnum,x
	bra doshot
.rts:
	rtl
