TryAddPlayerToList:		;used by SetPlList. d0 = player number (1 based), d4 = PlList slot
		;   SNES: d0 = roster player (1 based), d4 = PlList slot. A = d1 = player if added, 0 (Z set) if not available
	lda.b d0
	sta.b d1
	dec.b d0
	asl.b d0
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0000
	beq .chk
	bmi .v1
	bvs .chk
	bra .no
.v1:
	bvs .no
.chk:
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT: not available
	beq .no
	lda.w #$0005
	sta.b d0
.s2:
	ldy.b d0
	lda.b [a4],y
	and.w #$00FF
	sta.b tmp0
	lda.b d1
	and.w #$00FF
	cmp.b tmp0
	beq .no		; already in PlList
	dec.b d0
	bpl .s2
	ldy.b d4
	sep #$20
	lda.b d1
	sta.b [a4],y
	rep #$20
	lda.b d1
	and.w #$00FF
	rtl
.no:
	lda.w #$0000
	sta.b d1
	rtl
