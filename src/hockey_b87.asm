; The game, screens, menus, password, playoffs.
; Bank $87. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $87F3E9
RestoreReplayFrame:		;a4 = current replay frame address to convert into normal
		;   SNES: replay frame record [a4] back into the objects (x, y 12 bits, frame, flip bits), rostnum/position pairs, puck and
		;   shadow z, lastsfx, d7 = frame delay, PadControlBits, crowdframe, glovecords, PBnum, Hpos/Vpos (not when sfscrl)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	lda.b a4		; a0 = a4 (the record)
	sta.b a0
	lda.b a4+2
	sta.b a0+2
	lda.w #$000F
	sta.b d1
	ldx.w #$0000
.top:		;16 objects
	lda.b [a0]
	and.w #$0FFF
	bit.w #$0800
	beq .p
	ora.w #$F000
.p:
	sta.w Xpos,x
	inc.b a0
	lda.b [a0]
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .p1
	ora.w #$F000
.p1:
	sta.w Ypos,x
	inc.b a0
	inc.b a0
	lda.b [a0]
	and.w #$3FFF
	sta.w frame,x
	lda.w attribute,x
	and.w #$E7FF
	sta.w attribute,x
	lda.b [a0]
	lsr a
	lsr a
	lsr a
	and.w #$1800
	ora.w attribute,x
	sta.w attribute,x
	inc.b a0
	inc.b a0
	inx
	inx
	dec.b d1
	bpl .top
	lda.w #$0005
	sta.b d2
	ldx.w #$0000
.pl:		;6 pairs of players
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w rostnum,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w rostnum+2,x
	lda.b [a0]
	and.w #$000F
	cmp.w #$000F
	bne .n0
	lda.w #$FFFF
.n0:
	sta.w position,x
	lda.b [a0]
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	cmp.w #$000F
	bne .n1
	lda.w #$FFFF
.n1:
	sta.w position+2,x
	inc.b a0
	inx
	inx
	inx
	inx
	dec.b d2
	bpl .pl
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pz
	ora.w #$FF00
.pz:
	sta.w Zpos+puckobj
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .sz
	ora.w #$FF00
.sz:
	sta.w Zpos+$1E
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w lastsfx
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d7
	lda.w PadControlBits		; PadControlBits low 12 bits
	and.w #$F000
	sta.w PadControlBits
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$0FFF
	ora.w PadControlBits
	sta.w PadControlBits
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.b crowdframe
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.w glovecords
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pb
	ora.w #$FF00
.pb:
	sta.w PBnum
	lda.w sflags		; sfscrl: keep Hpos/Vpos
	bit.w #sfscrl
	bne .x
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.w Hpos
	lda.b [a0]
	sta.w Vpos
.x:
	stx.b xsave
	ldx.w #$0002
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
