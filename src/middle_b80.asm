; middle_b80: 93G middle93_1/middle93_2: utilities (print, joypads, math, decompression).
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $808496
muls16:		;68k muls.w: A = mula*mulb (signed 16-bit result, also in mula/mulb/mulres); C clear. Signs folded around the unsigned mulu (bank $8D)
	stz.b mula+2		; count the negative operands in mula+2
	lda.b mula
	bpl .bpos
	eor.w #$FFFF
	inc a
	sta.b mula
	inc.b mula+2
.bpos:
	lda.b mulb
	bpl .mul
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mula+2
.mul:
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lsr.b mula+2		; odd count: negate the result
	bcc .rtl
	eor.w #$FFFF
	inc a
	sta.b mula
	sta.b mulb
	sta.b mulres
	clc
.rtl:
	rtl

org $8097A3
randomd0:		;d0 = range. Return random number in d0 (0 <= d0 < range) (93G middle93_1)
		;   SNES: d0 = random 0..d0-1 (via randoma)
	lda.b d0
	jsl.l randoma
	sta.b d0
	rtl

org $80996C
divs:		;68k divs: A = mulres = mulb (32-bit) / mula, signed 16-bit quotient. C clear
	stz.b mulsign		; mulsign = number of negative operands
	lda.b mula
	bpl .apos
	eor.w #$FFFF
	inc a
	inc.b mulsign
.apos:
	sta.b mula+2
	stz.b mula
	lda.w #$0010		; 16 quotient bits
	sta.b mulcnt
	lda.b mulb+2
	bpl .loop
	lda.w #$0000
	sec
	sbc.b mulb
	sta.b mulb
	lda.w #$0000
	sbc.b mulb+2
	sta.b mulb+2
	inc.b mulsign
.loop:
	lsr.b mula+2
	ror.b mula
	asl.b mulres
	lda.b mulb
	cmp.b mula
	lda.b mulb+2
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	lda.b mulb+2
	sbc.b mula+2
	sta.b mulb+2
	inc.b mulres
.next:
	dec.b mulcnt
	bne .loop
	lsr.b mulsign
	bcc .rtl
	lda.w #$0000
	sbc.b mulres
	sta.b mulres
.rtl:
	lda.b mulres
	clc
	rtl

org $80AE56
random:		;93G randomd0 seed step: seed = seed*$BB40E62D+1 (32-bit LCG); returns A = seed+1 (middle bytes), rndb1/rndb2 set
	lda.w seed		; mula = seed (32-bit)
	sta.b mula
	lda.w seed+2
	sta.b mula+2
	lda.w #$E62D		; mulb = $BB40E62D
	sta.b mulb
	lda.w #$BB40
	sta.b mulb+2
	jsl.l mulu32		; bank $88: mulu 32-bit
	adc.w #$0001
	sta.w seed
	lda.b mulres+2
	adc.w #$0000
	sta.w seed+2
	xba		; seed bytes 2/1 for the 8-bit users ($0493/$0491)
	and.w #$00FF
	sta.w rndb2
	lda.w seed+1
	sta.w rndb1
	clc
	rtl
randoma:		;93G randomd0 with A = range: returns A = random 0..range-1 (high word of random*range). C clear
	pha
	jsl.l random
	sta.b mula
	pla
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2
	clc
	rtl

org $80B8D8
divu16:		;68k divu.w: mulres = mulb / mula (16-bit), mulres+2 = remainder; A = mula = mulb = quotient. C clear
	lda.b mula
	sta.b mula+2
	stz.b mula
	lda.w #$0010		; 16 quotient bits
	sta.b mulb+2
.loop:
	asl.b mulres
	lsr.b mula+2
	ror.b mula
	lda.b mulb
	cmp.b mula
	lda.w #$0000
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	inc.b mulres
.next:
	dec.b mulb+2
	bne .loop
	lda.b mulb
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
printz:		;see print. String macro should follow the bsr/jsr to this routine. 93 keeps a1 (92 popped the return into a1) (93G middle93_2)
		;   SNES: print the string that follows the jsl (length word counting itself, then control bytes / text), return after it. Keeps a1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.b $07,s		; a1 = return address+1: the string
	sta.b a1+2
	lda.b $05,s
	inc a
	sta.b a1
	lda.b [a1]		; return past the string
	clc
	adc.b $05,s
	sta.b $05,s
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
print:		;a1 = string macro, printx/y = x/y cordinate on map for printing, printm = map to print on, printa = attribute for characters. string \-$ab,$xx,$yy,'Sample!'\ : a = map number (1-3),
		;   b = color/priority (0-3 = color fam, prio off),(4-7 = color fam, prio on), xx/yy = x/y cord to print at. 93: '@' = char $7FF, '^' = skip a column (93G middle93_2)
		;   SNES: [a1] = string (length word, control bytes / text) into textmap at printx/printy; marks textdirtylo/hi. "@" = blank tile
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
	lda.l SmallFontMap,x		; char -> tile (bank $88 table) + font + printa
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

org $80C28B
sfx:		;play sound effect number. One word passed on stack (93G middle93_1)
		;   SNES: play the sound number pushed before the jsl (it is pulled here). Dropped within 180 frames of sfxmutetime; remembered in lastsfx
	pla		; return address +1 into jmlvector
	inc a
	sta.w jmlvector+1
	sep #$20
	pla
	sta.w jmlvector+3
	rep #$20
	lda.b vcount		; sound effects muted?
	sec
	sbc.w sfxmutetime
	cmp.w #$00B4
	bcc .drop
	pla		; lastsfx = sound number
	sta.w lastsfx
	beq .ret
	jsl.l QueueSound		; queue it (bank $82)
.ret:		;return through jmlvector
	jml.l jmlvector
.drop:
	pla
	bra .ret

org $80C40B
Readjoy1:		;read controller 1. Return d0 = direction (bit 0-3) and new button (bit 4-7) presses, d1 = new presses (all 8 bits), d2 = changed buttons (all 8), d3 = current held buttons (all
		;   8) (93G middle93_1)
		;   SNES: d0 = direction, d1 = new presses, d2 = changed, d3 = held
	phx
	ldx.w #$0000
	jsl.l ReadJoy
	plx
	lda.w lj1		; d2 = changed, d3 = held, d1 = new presses
	sta.b d2
	lda.b d1
	sta.w lj1
	sta.b d3
	eor.b d2
	sta.b d2
	and.b d1
	sta.b d1
	rtl
Readjoy2:		;read controller 2. Return d0 = direction (bit 0-3) and new button (bit 4-7) presses, d1 = new presses (all 8 bits), d2 = changed buttons (all 8), d3 = current held buttons (all
		;   8) (93G middle93_1)
	phx
	ldx.w #$0002
	jsl.l ReadJoy
	plx
	lda.w lj2
	sta.b d2
	lda.b d1
	sta.w lj2
	sta.b d3
	eor.b d2
	sta.b d2
	and.b d1
	sta.b d1
	rtl
ReadJoy:		;read controller a0. Return d0 = direction (bit 0-3) and new button (bit 4-7) presses, d1 = buttons down (all 8 bits) (93G middle93_1)
		;   SNES: X = 0/2: d1 = buttons held, d0 = direction from jdtab
	lda.w joypad1,x		; buttons
	sta.b d0+2
	sta.b d1
	xba		; r/l/d/u bits
	and.w #$000F
	tax
	lda.l jdtab,x
	and.w #$00FF
	sta.b d0
	rtl
jdtab:		;93G jdtab (middle93_1): convert buttons r,l,d,u into directions 0-7, 8
	db 8,2,6,8,4,3,5,8,0,1,7,8,8,8,8,8

org $80CBB1
sroot:		;Square Root, this returns (d0.L)^.5 in d0. 93: values above $F00000 use a binary search (93G middle93_1)
		;   SNES: d0 = sqrt(d0, 32-bit) by binary search on the square
	stz.b tmp0
	lda.w #$1000
	sta.b tmp1
.loop:
	lda.b tmp0
	clc
	adc.b tmp1
	ror a
	cmp.b tmp0
	beq .done
	sta.b tmp2
	sta.b mula
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b d0
	cmp.b mulres
	lda.b d0+2
	sbc.b mulres+2
	bcs .low
	lda.b tmp2
	sta.b tmp1
	bra .loop
.low:
	lda.b tmp2
	sta.b tmp0
	bra .loop
.done:
	sta.b d0
	rtl
divu:		;68k divu: A = mulres = mulb (32-bit) / mula; mulres+2 = remainder. C clear
	lda.b mula
	sta.b mula+2
	stz.b mula
	lda.w #$0010
	sta.b mulres+2
.loop:
	asl.b mulres
	lsr.b mula+2
	ror.b mula
	lda.b mulb
	cmp.b mula
	lda.b mulb+2
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	lda.b mulb+2
	sbc.b mula+2
	sta.b mulb+2
	inc.b mulres
.next:
	dec.b mulres+2
	bne .loop
	lda.b mulb
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl

org $80F3E8
ReadPads:		;SNES: once per frame (padvcount) read the 4 auto-read pads into joypad1-4, padnew1-4 = new presses, padlast1-4 = buttons
	lda.b vcount		; once per frame
	cmp.w padvcount
	beq .new
	sta.w padvcount
	lda.w #$0001
.wait:		;auto-joypad read busy
	bit.w HVBJOY
	bne .wait
	lda.w JOY1L
	sta.w joypad1
	lda.w JOY2L
	sta.w joypad2
	lda.w JOY3L
	sta.w joypad3
	lda.w JOY4L
	sta.w joypad4
.new:
	lda.w joypad1		; new presses = changed and down
	eor.w padlast1
	and.w joypad1
	sta.w padnew1
	lda.w joypad2
	eor.w padlast1+2
	and.w joypad2
	sta.w padnew1+2
	lda.w joypad3
	eor.w padlast1+4
	and.w joypad3
	sta.w padnew1+4
	lda.w joypad4
	eor.w padlast1+6
	and.w joypad4
	sta.w padnew1+6
	lda.w joypad1
	sta.w padlast1
	lda.w joypad2
	sta.w padlast1+2
	lda.w joypad3
	sta.w padlast1+4
	lda.w joypad4
	sta.w padlast1+6
	rtl

org $80F6A1
randomd0s:		;IDA: sub_D7B2 (Rev A lst). d0 = range. Return d0 = random number (-range < d0 < range) (93G middle93_1)
		;   SNES: A = random -A..A (randoma of 2A, minus A)
	sta.b tmp0
	asl a
	jsl.l randoma
	sec
	sbc.b tmp0
	clc
	rtl
