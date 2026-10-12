checkgoalp:		;check for player a3 collision with goal/net a2. Entered from checkgoal
		;   SNES: player X collision with the goal/net a2 (oval, radius x 32, y 11). CheckBump, then wallcoll with the normal
	lda.w pflags,x
	bit.w #pf2npc
	beq .npc
	jmp.w .rtl
.npc:
	lda.w Zpos,x
	sec
	sbc.w #$000A
	beq .pl
	bmi .v1
	bvs .pl
.ex1:
	jmp.w .rtl
.v1:
	bvs .ex1
.pl:		;players only (SCnum <= 11)
	cpx.w #$0017
	bcc .go
	jmp.w .rtl
.go:
	ldy.b a2		; d0 = -dy, d1 = dx
	lda.b d3
	pha
	sec
	sbc.w Ypos,y
	sta.b d3
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d2
	pha
	sec
	sbc.w Xpos,y
	sta.b d1
	asl a
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	lda.w #$0400
	sta.b mula
	jsl.l divu
	cmp.w #$0101
	bcc .inx
	jmp.w .exit
.inx:		;(dy*16)^2/$79 + (dx*16)^2/$400 <= $100?
	sta.b d2
	lda.b d3
	asl a
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	lda.w #$0079
	sta.b mula
	jsl.l divu
	adc.b d2
	cmp.w #$0101
	bcs .exit
	pla
	sta.b d2
	pla
	sta.b d3
	jsl.l CheckBump		; CheckBump, then wallcoll with the normal (d0,d1)/r
	lda.b d3
	pha
	lda.b d2
	pha
	lda.b d1
	pha
	lda.b d0
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	jsl.l sroot
	inc a
	sta.b d2
	sta.b mula
	pla
	sta.b d0
	pla
	sta.b d1
	stz.b mulb
	lda.b d0
	sta.b mulb+1
	lda.b d0+2
	sta.b mulb+3
	jsl.l divs
	sta.b d0
	lda.b d2
	sta.b mula
	stz.b mulb
	lda.b d1
	sta.b mulb+1
	lda.b d1+2
	sta.b mulb+3
	jsl.l divs
	sta.b d1
	jsl.l wallcoll
.exit:
	pla
	sta.b d2
	pla
	sta.b d3
.rtl:
	rtl
