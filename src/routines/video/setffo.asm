setffo:		;draw the 5 objects tied to icerink scrolling (pads ...). Called from setvideo.
		;   SNES: uppads, then draw the 5 objects tied to rink scrolling (pads 0-2 with their 3 character label, gloves; pad 3 skipped)
	jsl.l uppads
	ldx.w #$0000
.top:
	cpx.w #$0006
	bne .obj
	jmp.w .next		; pad 3: not drawn
.obj:
	lda.w ffox,x
	sta.b d0
	lda.w ffoy,x
	sta.b d1
	lda.w ffoz,x		; hidden
	bpl .shown
	jmp.w .next
.shown:
	sta.b d2
	jsl.l projxy
	cmp.w #OFFSCREEN
	bne .add
	jmp.w .next
.add:
	sta.b spry
	lda.b d0
	sta.b sprx
	lda.w ffoframe,x		; frame, flip bits from ffoattr
	sta.b sprframe
	lda.b ffoattr,x
	and.w #$0800
	sta.b sprhflip
	lda.b ffoattr,x
	and.w #$1000
	sta.b sprvflip
	phx
	jsl.l addframe		; sprframe at sprx/spry
	plx
	cpx.w #$0006		; gloves: no label
	bcc .label
	jmp.w .next
.label:		;label: two digits (rostnum, $A+ = blank) and a position letter
	ldy.w #$0000		; mesarea+2 = label tiles, mesarea = count; d0 moves left 4 per digit
	lda.w padcont,x
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	beq .lo
	cmp.w #$000A
	bcc .hi
	jmp.w .next
.hi:
	sta.w mesarea+2,y
	iny
	dec.b d0
	dec.b d0
	dec.b d0
	dec.b d0
.lo:
	lda.w padcont,x
	and.w #$000F
	cmp.w #$000A
	bcs .next
	sta.w mesarea+2,y
	iny
	dec.b d0
	dec.b d0
	dec.b d0
	dec.b d0
	lda.w padcont+1,x		; position letter from ButtonLabelCharTable, after a blank
	and.w #$0007
	beq .draw
	adc.w #ButtonLabelCharTable-1
	sta.b a4
	lda.w #ButtonLabelCharTable>>16
	sta.b a4+2
	lda.b d0
	sec
	sbc.w #$0006
	sta.b d0
	lda.w #$FFFF
	sta.w mesarea+2,y
	iny
	lda.b [a4]
	sta.w mesarea+2,y
	iny
.draw:
	sty.w mesarea
	stz.b d0+2
.ch:
	ldy.b d0+2
	cpy.w mesarea
	beq .next
	lda.w mesarea+2,y
	and.w #$00FF
	cmp.w #$00FF
	beq .sp
	adc.w #$021E		; small font sprite base $21E
	sta.b sprframe
	lda.b d0
	sta.b sprx
	lda.b d1
	clc
	adc.w #$000A
	sta.b spry
	phx
	jsl.l addframe		; sprframe at sprx/spry
	plx
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0
.sp:		;blank: 4 pixels
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0+2
	bra .ch
.next:
	inx
	inx
	cpx.w #$000A
	beq .rtl
	jmp.w .top
.rtl:
	rtl
