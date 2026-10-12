updatecrowdf:		;Every game loop: let the crowd level fade and step the crowd animation
	lda.b crowdlevel
	sec
	sbc.w #$015E		; 350
	bmi .neg
	bvc .loud
	bra .dec
.neg:
	bvc .dec
.loud:
	dec.b crowdlevel		; loud crowd calms down faster
	dec.b crowdlevel
	dec.b crowdlevel
.dec:
	lda.b crowdlevel
	sec
	sbc.b d7
	sta.b crowdlevel
	bpl .0
	stz.b crowdlevel
.0:
	lda.b crowdcnt
	sec
	sbc.b d7
	sta.b crowdcnt
	bpl .cf
	lda.b crowdlevel
	lsr a
	sta.b d0
	cmp.w #$0080
	bcc .1
	lda.w #$007F
	sta.b d0
.1:
	lda.b d0
	and.w #$0060		; %01100000
	sta.b d0
	lda.b crowdstep
	inc a
	inc a
	and.w #$001E		; %00011110
	sta.b crowdstep
	clc
	adc.b d0
	sta.b d0
	tay
	lda.w #cd0		; cd0: frame high byte, time low byte
	sta.b a0
	lda.w #cd0>>16
	sta.b a0+2
	lda.b [a0],y
	xba
	sep #$20
	sta.b crowdframe+1
	rep #$20
	lda.b [a0],y
	and.w #$00FF
	sta.b d1
	lda.w seed		; random 0..time
	and.b d1
	sta.b d2
	clc
	adc.b d1
	sta.b d1
	sta.b crowdcnt
.cf:		;random extra frame 19-25 when the crowd is loud
	sep #$20
	stz.b crowdframe
	rep #$30
	lda.b crowdlevel
	cmp.w #$0119		; 280
	bcc .rtl
	lda.w seed
	and.w #$007F
	cmp.w #$0013
	bcc .rtl
	cmp.w #$001A
	bcs .rtl
	sep #$20
	sta.b crowdframe
	rep #$30
.rtl:
	rtl
