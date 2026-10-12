SetPlList:		;Make the list of the players team a2 wants on the ice now
	lda.w #PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #$0000
	sta.b [a4]
	ldy.w #$0002
	sta.b [a4],y
	ldy.w #$0004
	sta.b [a4],y
	lda.w #priolist		; priolist
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmgoalie,y
	bpl .gin		; no goalie: skip the priolist goalie entry
	inc.b a0
.gin:
	lda.w tmdata,y		; line sets: team data + word at +6, + tmline*8
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #LineSets
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.b a2
	lda.w tmline,y
	asl a
	asl a
	asl a
	sta.b d0
	adc.b a1
	sta.b a1
	lda.w tmap,y		; tmap: players on ice
	sta.b d4
	bra .next
.0:
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	sta.b d5
	tay
	sep #$20
	lda.b [a1],y
	ldy.b d4
	sta.b [a4],y
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b d5
	sta.b [a4],y
	rep #$20
	lda.b d5
	bne .next
	ldy.b a2		; goalie: 1 + tmgoalie
	lda.w tmgoalie,y
	inc a
	sta.b d3
	ldy.b d4
	sep #$20
	lda.b d3
	sta.b [a4],y
	rep #$20
.next:
	dec.b d4
	bpl .0
	lda.w #$0005
	sta.b d4
.1:		;is each wanted player available?
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d3
	beq .next1
	and.w #$00FF
	bit.w #$0080
	beq .p
	ora.w #$FF00
.p:
	dec a
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	clc
	adc.b d3
	tay
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT: substitute
	beq .sub
	lda.w tmpdst,y
	bmi .next1		; bench or ice: ok
	beq .next1
.sub:		;not available: find a player of a similar position (sublist)
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #LineSets
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	asl a
	sta.b d0
	lda.w #sublist		; sublist (word offsets)
	sta.b a0
	lda.w #sublist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.s1:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .all
	ldy.b d0
	lda.b [a1],y
	and.w #$00FF
	sta.b d0
	jsl.l TryAddPlayerToList
	beq .s1
.next1:
	dec.b d4
	bmi .rtl
	jmp.w .1
.rtl:
	rtl
.all:		;try every roster player, last first
	jsl.l GetPlayerCount		; GetPlayerCount
	lda.b d0
	sta.b d3
.try:
	lda.b d3
	sta.b d0
	dec.b d3
	bmi .next1
	jsl.l TryAddPlayerToList
	beq .try
	bra .next1
