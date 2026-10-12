print:		;Print string [a1] into the text map at printx / printy. The string starts with its length word and may hold
		;   control codes for position and color
	lda.b [a1]
	cmp.w #$0100
.hang:		;string longer than 255: hang
	bcs .hang
	phx
	ldy.w #$0002		; Y = 2: skip the length word
.pos:
	lda.w printy		; X = (printy*32+printx)*2 + printm
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
.char:
	tya
	cmp.b [a1]
	bne .ctl
	jmp.w .done
.ctl:
	lda.b [a1],y
	bit.w #$0080		; bit 7: control code
	bne .code
	and.w #$00FF
	cmp.w #$0040		; "@" = blank tile
	bne .font
	jmp.w .blank
.font:
	phx
	asl a
	tax
	lda.l SmallFontMap,x		; char -> tile + font + printa
	adc.w smallfontchars
	adc.w printfontset
	ora.w printa
	plx
.put:
	cmp.l textmap,x
	beq .nextc
	sta.l textmap,x
	txa
	lsr a
	cmp.b textdirtylo		; textdirtylo/hi
	bcs .hi
	sta.b textdirtylo
.hi:
	cmp.b textdirtyhi
	bcc .nextc
	sta.b textdirtyhi
.nextc:
	inc.w printx
	inx
	inx
	iny
	bra .char
.code:		;control code -n: palette/priority bits, font number, map; then x, y
	eor.w #$FFFF
	inc a
	pha
	and.w #$0030		; bits 4-5: palette (printa bits 10-12)
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.w printa
	lda.b $01,s
	and.w #$0040		; bit 6: priority
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	tsb.w printa
	pla
	and.w #$0003		; bits 0-1: font, printfontset = font table entry
	sta.w printfont
	pha
	asl a
	tax
	lda.w printfontset,x
	sta.w printfontset
	pla
	dec a		; map (font-1) * $800 bytes
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	sta.b printm
	iny
	lda.b [a1],y
	and.w #$007F
	sta.w printx
	iny
	lda.b [a1],y
	and.w #$007F
	sta.w printy
	iny
	jmp.w .pos
.done:
	clc
	adc.b a1
	sta.b a1
	plx
	rtl
.blank:
	lda.w blankchar
	clc
	adc.w printfontset
	jmp.w .put
