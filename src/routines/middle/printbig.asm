printbig:		;print with the big font (2 by 2 tiles per character)
	phx
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	ldy.w #$0002		; y = 2: after the length word
.top:
	tya
	cmp.b [a1]
	bne .ch
	jmp.w .done
.ch:
	lda.w printy		; d1 = textmap offset (printy * 32 + printx) * 2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	sta.b d1
	lda.b [a1],y
	bit.w #$0080
	beq .dochar
	jmp.w .code
.dochar:
	and.w #$00FF
	bne .lc
	jmp.w .skip
.lc:
	cmp.w #'a'		; lower case to upper case
	bcc .uc
	cmp.w #'z'+1
	bcs .uc
	adc.w #-32
.uc:
	sec		; space: blank
	sbc.w #' '
	bne .wide
	jmp.w .blank
.wide:
	stz.b d2
	inc.b d2
	tax
	lda.l BigFontIndex,x		; character width/tile table (BigFontIndex): negative = 1 column
	and.w #$00FF
	bit.w #$0080
	beq .w0
	ora.w #$FF00
.w0:
	cmp.w #$0000
	bpl .w1
	eor.w #$FFFF
	inc a
	stz.b d2
.w1:
	asl a
	sta.b d0
	tax
	lda.l BigFontMap,x		; big font map (BigFontMap): top left
	clc
	adc.w BigFontChars
	adc.w printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap,x
	txa
	lsr a
	cmp.b textdirtylo
	bcs .lo
	sta.b textdirtylo
.lo:
	clc
	adc.w #$0021
	cmp.b textdirtyhi
	bcc .bot
	sta.b textdirtyhi
.bot:
	ldx.b d0
	lda.l BigFontMap+$98,x		; bottom left (+$98)
	clc
	adc.w BigFontChars
	adc.w printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+$40,x
	lda.b d2
	beq .next
	ldx.b d0
	lda.l BigFontMap+2,x		; top right
	clc
	adc.w BigFontChars
	adc.w printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+2,x
	ldx.b d0
	lda.l BigFontMap+$9A,x		; bottom right
	clc
	adc.w BigFontChars
	adc.w printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+$42,x
	inc.w printx
.next:
	inc.w printx
.skip:
	iny
	jmp.w .top
.blank:
	lda.l BigFontMap+$2C		; blank: big font entry $2C on both rows
	clc
	adc.w BigFontChars
	adc.w printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap,x
	sta.l textmap+$40,x
	txa
	lsr a
	cmp.b textdirtylo
	bcs .bl1
	sta.b textdirtylo
.bl1:
	clc
	adc.w #$0020
	cmp.b textdirtyhi
	bcc .next
	sta.b textdirtyhi
	bra .next
.code:		;control byte -$ab, x, y: attribute b, map a
	eor.w #$FFFF
	inc a
	pha
	and.w #$0030		; palette bits
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.w printa
	lda.b $01,s
	and.w #$0040		; priority bit
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	tsb.w printa
	pla
	and.w #$0003		; font number: printfontset from the table at printfontset+2*n
	sta.w printfont
	pha
	asl a
	tax
	lda.w printfontset,x
	sta.w printfontset
	pla		; printm = (map - 1) * $800
	dec a
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	sta.b printm
	iny
	lda.b [a1],y
	and.w #$001F
	sta.w printx
	iny
	lda.b [a1],y
	and.w #$001F
	sta.w printy
	iny
	jmp.w .top
.done:
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	plx
	rtl
