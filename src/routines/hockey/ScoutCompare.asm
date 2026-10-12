ScoutCompare:		;Print the scouting ratings of team [a0], marking where it has the edge over [a2]
	ldy.w #$0004
	lda.b [a0],y
	xba
	sta.b d5+2
	iny
	iny
	lda.b [a0],y
	xba
	sta.b d5
	lda.w #$0007
	sta.b d6
.rating:
	ldy.w #$0004
.shift:
	asl.b d5
	rol.b d5+2
	lda.b d5
	adc.w #$0000
	sta.b d5
	dey
	bne .shift
	lda.b d5
	and.w #$000F
	sta.b d0
	jsl.l .printrating
	lda.b d6
	cmp.w #$0001
	bne .next
	jsl.l .advantages
.next:
	dec.b d6
	bpl .rating
	rtl
.advantages:
	lda.b [a0]
	xba
	and.w #$000F
	sta.b d0
	lda.b [a2]
	xba
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.b d0
	sta.b d0
	jsl.l .printrating
	lda.w printx
	cmp.w #$0010
	bcc .nexty
	ldy.w #$0002
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
	lda.b [a2],y
	and.w #$000F
	clc
	adc.b d0
	sta.b d0
.printrating:
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWidth
	lda.w printx
	pha
	jsl.l print
	pla
	sta.w printx
.nexty:
	inc.w printy
	rtl
