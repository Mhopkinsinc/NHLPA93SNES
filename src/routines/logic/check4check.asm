check4check:		;look for good opportunity for checking opponent. Falls in from assnearest; also entered from assfwatch and asswingd
		;   SNES: look for a good chance to check an opponent. Falls in from assnearest; also entered from assfwatch and asswingd
	lda.w #$0014
	sec
	sbc.w aggress,x
	sta.b d0
	lda.w OptPen		; penalties on: half the chance
	beq .nopen
	asl.b d0
.nopen:
	lda.b d0
	jsl.l randoma
	cmp.w #$0004
	bcc .go
	lda.b d0
	jsl.l randoma
	cmp.w #$0004
	bcs .rts
.go:
	lda.w #$0005
	sta.b d2
	stz.b a0
	cpx.w #$000C
	bcs .0
	lda.w #$000C
	sta.b a0
.0:		;each opponent within 30 pixels in the facing direction
	ldy.b a0
	lda.w position,y
	beq .next
	lda.w pfalock,y
	bne .next
	lda.w pf2fight,y
	bne .next
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$001F
	bcs .next
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$001F
	bcs .next
	jsl.l vtoa
	lda.b d0
	cmp.w facedir,x		; opponent in the facing direction
	bne .next
	lda.w seed+3		; random: 1 in 4 hold, else check
	and.w #$0003
	sta.b d0
	bne burst
	jml.l Acheck
.next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .0
.rts:
	rtl
