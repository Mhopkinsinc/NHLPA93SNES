uppads:		;update the gloves object and the 4 pad objects, and queue new pad labels.
		;   SNES: gloves object from glovecords, and the 4 pad objects from the PadControlBits nibbles ($E = stays, $F = hidden); padcont = label code (position <<
		;   8 | rostnum)
	ldy.w #$0008		; gloves (ffo 4): hidden unless glovecords
	lda.w #$FFFF
	sta.w ffoz,y
	lda.w glovecords
	and.w #$00FF
	beq .nogloves
	and.w #$00FF
	bit.w #$0080
	beq .gx
	ora.w #$FF00
.gx:
	asl a
	asl a
	sta.w ffox,y
	lda.w glovecords+1
	and.w #$00FF
	bit.w #$0080
	beq .gy
	ora.w #$FF00
.gy:
	asl a
	asl a
	sta.w ffoy,y
	lda.w #$0000
	sta.w ffoz,y
.nogloves:
	lda.w #$0003		; 4 pads: a0 = ffo index, a1 = padcont, d3 = PadControlBits
	sta.b d4
	stz.b a0
	lda.w #padcont
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b a2
	lda.w PadControlBits
	sta.b d3
.top:
	lda.b d3
	and.w #$000F
	sta.b d0
	lda.w #$000F		; label code for $E
	sta.b d1
	lda.b d0
	cmp.w #$000E
	beq .chg
	ldy.b a0		; hidden
	lda.w #$FFFF
	sta.w ffoz,y
	lda.b d0
	cmp.w #$000F
	beq .next
	asl.b d0		; pad at the player
	ldy.b d0
	lda.w Xpos,y
	ldy.b a0
	sta.w ffox,y
	ldy.b d0
	lda.w Ypos,y
	ldy.b a0
	sta.w ffoy,y
	lda.w #$0000
	sta.w ffoz,y
	ldy.b d0
	lda.w position,y
	xba
	and.w #$FF00
	sta.b d1
	lda.w rostnum,y
	and.w #$00FF
	tsb.b d1
.chg:
	lda.b d1
	sta.b [a1]
.next:
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
	inc.b a0
	inc.b a0
	inc.b a1
	inc.b a1
	dec.b d4
	bpl .top
	rtl
