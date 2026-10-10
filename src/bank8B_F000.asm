; $8BF003-$8BFFFF  ROM $5F003-$5FFFF: the last SpriteSet5 tiles, printbig (middle93_2), asswingo (logic93_3, asstab 4), showref (video93_1),
; skatetopuckinit (logic93_5).
org $8BF003
	incbin "../data/Sprites/set05.chr":$6335..$7000		; $8BF003-$8BFCCD
SpriteSet5End:
	assert SpriteSet5End-SpriteSet5 == $8E0+896*32
printbig:		;auto: CODE_8BFCCE. 93G printbig (middle93_2): print string [a1] in the big font (2 x 2 tiles, narrow characters 1 column) at printx/printy; control codes as print
	phx		; $8BFCCE: DA
	stx.b xsave		; $8BFCCF: 86 0A
	ldx.w #$0000		; $8BFCD1: A2 00 00
.pushd:
	lda.b d0,x		; $8BFCD4: B5 53
	pha		; $8BFCD6: 48
	inx		; $8BFCD7: E8
	inx		; $8BFCD8: E8
	cpx.w #$000C		; $8BFCD9: E0 0C 00
	bne .pushd		; $8BFCDC: D0 F6
	ldx.b xsave		; $8BFCDE: A6 0A
	ldy.w #$0002		; $8BFCE0: A0 02 00  y = 2: after the length word
.top:
	tya		; $8BFCE3: 98
	cmp.b [a1]		; $8BFCE4: C7 37
	bne .ch		; $8BFCE6: D0 03
	jmp.w .done		; $8BFCE8: 4C 37 FE
.ch:
	lda.w printy		; $8BFCEB: AD 7D 04  d1 = textmap offset (printy * 32 + printx) * 2
	asl a		; $8BFCEE: 0A
	asl a		; $8BFCEF: 0A
	asl a		; $8BFCF0: 0A
	asl a		; $8BFCF1: 0A
	asl a		; $8BFCF2: 0A
	adc.w printx		; $8BFCF3: 6D 7B 04
	asl a		; $8BFCF6: 0A
	sta.b d1		; $8BFCF7: 85 57
	lda.b [a1],y		; $8BFCF9: B7 37
	bit.w #$0080		; $8BFCFB: 89 80 00
	beq .char		; $8BFCFE: F0 03
	jmp.w .code		; $8BFD00: 4C E6 FD
.char:
	and.w #$00FF		; $8BFD03: 29 FF 00
	bne .lc		; $8BFD06: D0 03
	jmp.w .skip		; $8BFD08: 4C B6 FD
.lc:
	cmp.w #'a'		; $8BFD0B: C9 61 00  lower case to upper case
	bcc .uc		; $8BFD0E: 90 08
	cmp.w #'z'+1		; $8BFD10: C9 7B 00
	bcs .uc		; $8BFD13: B0 03
	adc.w #-32		; $8BFD15: 69 E0 FF
.uc:
	sec		; $8BFD18: 38  space: blank
	sbc.w #' '		; $8BFD19: E9 20 00
	bne .wide		; $8BFD1C: D0 03
	jmp.w .blank		; $8BFD1E: 4C BA FD
.wide:
	stz.b d2		; $8BFD21: 64 5B
	inc.b d2		; $8BFD23: E6 5B
	tax		; $8BFD25: AA
	lda.l BigFontIndex,x		; $8BFD26: BF 69 82 8F  character width/tile table ($8F8269): negative = 1 column
	and.w #$00FF		; $8BFD2A: 29 FF 00
	bit.w #$0080		; $8BFD2D: 89 80 00
	beq .w0		; $8BFD30: F0 03
	ora.w #$FF00		; $8BFD32: 09 00 FF
.w0:
	cmp.w #$0000		; $8BFD35: C9 00 00
	bpl .w1		; $8BFD38: 10 06
	eor.w #$FFFF		; $8BFD3A: 49 FF FF
	inc a		; $8BFD3D: 1A
	stz.b d2		; $8BFD3E: 64 5B
.w1:
	asl a		; $8BFD40: 0A
	sta.b d0		; $8BFD41: 85 53
	tax		; $8BFD43: AA
	lda.l BigFontMap,x		; $8BFD44: BF 00 80 8F  big font map ($8F8000): top left
	clc		; $8BFD48: 18
	adc.w BigFontChars		; $8BFD49: 6D D1 1B
	adc.w printfontset		; $8BFD4C: 6D CB 1B
	ora.w printa		; $8BFD4F: 0D 77 04
	ldx.b d1		; $8BFD52: A6 57
	sta.l textmap,x		; $8BFD54: 9F 74 6E 7E
	txa		; $8BFD58: 8A
	lsr a		; $8BFD59: 4A
	cmp.b textdirtylo		; $8BFD5A: C5 D0
	bcs .lo		; $8BFD5C: B0 02
	sta.b textdirtylo		; $8BFD5E: 85 D0
.lo:
	clc		; $8BFD60: 18
	adc.w #$0021		; $8BFD61: 69 21 00
	cmp.b textdirtyhi		; $8BFD64: C5 D2
	bcc .bot		; $8BFD66: 90 02
	sta.b textdirtyhi		; $8BFD68: 85 D2
.bot:
	ldx.b d0		; $8BFD6A: A6 53
	lda.l BigFontMap+$98,x		; $8BFD6C: BF 98 80 8F  bottom left (+$98)
	clc		; $8BFD70: 18
	adc.w BigFontChars		; $8BFD71: 6D D1 1B
	adc.w printfontset		; $8BFD74: 6D CB 1B
	ora.w printa		; $8BFD77: 0D 77 04
	ldx.b d1		; $8BFD7A: A6 57
	sta.l textmap+$40,x		; $8BFD7C: 9F B4 6E 7E
	lda.b d2		; $8BFD80: A5 5B
	beq .next		; $8BFD82: F0 2F
	ldx.b d0		; $8BFD84: A6 53
	lda.l BigFontMap+2,x		; $8BFD86: BF 02 80 8F  top right
	clc		; $8BFD8A: 18
	adc.w BigFontChars		; $8BFD8B: 6D D1 1B
	adc.w printfontset		; $8BFD8E: 6D CB 1B
	ora.w printa		; $8BFD91: 0D 77 04
	ldx.b d1		; $8BFD94: A6 57
	sta.l textmap+2,x		; $8BFD96: 9F 76 6E 7E
	ldx.b d0		; $8BFD9A: A6 53
	lda.l BigFontMap+$9A,x		; $8BFD9C: BF 9A 80 8F  bottom right
	clc		; $8BFDA0: 18
	adc.w BigFontChars		; $8BFDA1: 6D D1 1B
	adc.w printfontset		; $8BFDA4: 6D CB 1B
	ora.w printa		; $8BFDA7: 0D 77 04
	ldx.b d1		; $8BFDAA: A6 57
	sta.l textmap+$42,x		; $8BFDAC: 9F B6 6E 7E
	inc.w printx		; $8BFDB0: EE 7B 04
.next:
	inc.w printx		; $8BFDB3: EE 7B 04
.skip:
	iny		; $8BFDB6: C8
	jmp.w .top		; $8BFDB7: 4C E3 FC
.blank:
	lda.l BigFontMap+$2C		; $8BFDBA: AF 2C 80 8F  blank: big font entry $2C on both rows
	clc		; $8BFDBE: 18
	adc.w BigFontChars		; $8BFDBF: 6D D1 1B
	adc.w printfontset		; $8BFDC2: 6D CB 1B
	ora.w printa		; $8BFDC5: 0D 77 04
	ldx.b d1		; $8BFDC8: A6 57
	sta.l textmap,x		; $8BFDCA: 9F 74 6E 7E
	sta.l textmap+$40,x		; $8BFDCE: 9F B4 6E 7E
	txa		; $8BFDD2: 8A
	lsr a		; $8BFDD3: 4A
	cmp.b textdirtylo		; $8BFDD4: C5 D0
	bcs .bl1		; $8BFDD6: B0 02
	sta.b textdirtylo		; $8BFDD8: 85 D0
.bl1:
	clc		; $8BFDDA: 18
	adc.w #$0020		; $8BFDDB: 69 20 00
	cmp.b textdirtyhi		; $8BFDDE: C5 D2
	bcc .next		; $8BFDE0: 90 D1
	sta.b textdirtyhi		; $8BFDE2: 85 D2
	bra .next		; $8BFDE4: 80 CD
.code:		;control byte -$ab, x, y: attribute b, map a
	eor.w #$FFFF		; $8BFDE6: 49 FF FF
	inc a		; $8BFDE9: 1A
	pha		; $8BFDEA: 48
	and.w #$0030		; $8BFDEB: 29 30 00  palette bits
	asl a		; $8BFDEE: 0A
	asl a		; $8BFDEF: 0A
	asl a		; $8BFDF0: 0A
	asl a		; $8BFDF1: 0A
	asl a		; $8BFDF2: 0A
	asl a		; $8BFDF3: 0A
	sta.w printa		; $8BFDF4: 8D 77 04
	lda.b $01,s		; $8BFDF7: A3 01
	and.w #$0040		; $8BFDF9: 29 40 00  priority bit
	asl a		; $8BFDFC: 0A
	asl a		; $8BFDFD: 0A
	asl a		; $8BFDFE: 0A
	asl a		; $8BFDFF: 0A
	asl a		; $8BFE00: 0A
	asl a		; $8BFE01: 0A
	asl a		; $8BFE02: 0A
	tsb.w printa		; $8BFE03: 0C 77 04
	pla		; $8BFE06: 68
	and.w #$0003		; $8BFE07: 29 03 00  font number: printfontset from the table at printfontset+2*n
	sta.w printfont		; $8BFE0A: 8D 79 04
	pha		; $8BFE0D: 48
	asl a		; $8BFE0E: 0A
	tax		; $8BFE0F: AA
	lda.w printfontset,x		; $8BFE10: BD CB 1B
	sta.w printfontset		; $8BFE13: 8D CB 1B
	pla		; $8BFE16: 68  printm = (map - 1) * $800
	dec a		; $8BFE17: 3A
	xba		; $8BFE18: EB
	and.w #$FF00		; $8BFE19: 29 00 FF
	asl a		; $8BFE1C: 0A
	asl a		; $8BFE1D: 0A
	asl a		; $8BFE1E: 0A
	sta.b printm		; $8BFE1F: 85 D4
	iny		; $8BFE21: C8
	lda.b [a1],y		; $8BFE22: B7 37
	and.w #$001F		; $8BFE24: 29 1F 00
	sta.w printx		; $8BFE27: 8D 7B 04
	iny		; $8BFE2A: C8
	lda.b [a1],y		; $8BFE2B: B7 37
	and.w #$001F		; $8BFE2D: 29 1F 00
	sta.w printy		; $8BFE30: 8D 7D 04
	iny		; $8BFE33: C8
	jmp.w .top		; $8BFE34: 4C E3 FC
.done:
	stx.b xsave		; $8BFE37: 86 0A
	ldx.w #$000A		; $8BFE39: A2 0A 00
.popd:
	pla		; $8BFE3C: 68
	sta.b d0,x		; $8BFE3D: 95 53
	dex		; $8BFE3F: CA
	dex		; $8BFE40: CA
	bpl .popd		; $8BFE41: 10 F9
	ldx.b xsave		; $8BFE43: A6 0A
	plx		; $8BFE45: FA
	rtl		; $8BFE46: 6B
asswingo:		;auto: CODE_8BFE47 (asstab 4). 93G asswingo (logic93_3): wing on offence: pick a spot in the zone the puck is in (.dedata + random), awingd when the other team has the puck
	lda.w pfalock,x		; $8BFE47: BD 7F 11
	beq .go		; $8BFE4A: F0 03
	jmp.w .rtl		; $8BFE4C: 4C AB FF
.go:
	lda.w gmclock		; $8BFE4F: AD 8A 12
	beq .gm		; $8BFE52: F0 04
	jml.l assnothing		; $8BFE54: 5C 5A D7 8F  bank $8F: assnothing
.gm:
	jsl.l check4bench		; $8BFE58: 22 27 85 80
	lda.w pflags,x		; $8BFE5C: BD DF 0E
	bit.w #$0008		; $8BFE5F: 89 08 00
	beq .chk		; $8BFE62: F0 03
	jmp.w .rtl		; $8BFE64: 4C AB FF
.chk:
	bit.w #$0002		; $8BFE67: 89 02 00
	beq .nna		; $8BFE6A: F0 18
	and.w #$FFFD		; $8BFE6C: 29 FD FF
	sta.w pflags,x		; $8BFE6F: 9D DF 0E
	lda.w #$FFFF		; $8BFE72: A9 FF FF  temp5 = -1: no zone yet
	sta.w temp5,x		; $8BFE75: 9D DF 0C
	stz.w temp1,x		; $8BFE78: 9E 5F 0C
	stz.w temp2,x		; $8BFE7B: 9E 7F 0C
	lda.w #$0008		; $8BFE7E: A9 08 00
	sta.w temp2b,x		; $8BFE81: 9D FF 0C
.nna:
	lda.w temp1,x		; $8BFE84: BD 5F 0C
	sec		; $8BFE87: 38
	sbc.b d7		; $8BFE88: E5 6F
	sta.w temp1,x		; $8BFE8A: 9D 5F 0C
	bmi .new		; $8BFE8D: 30 03
	jmp.w .nodec		; $8BFE8F: 4C 6E FF
.new:
	clc		; $8BFE92: 18
	adc.w aidef,x		; $8BFE93: 7D BF 0F
	bpl .t1		; $8BFE96: 10 03
	lda.w #$0000		; $8BFE98: A9 00 00
.t1:
	sta.w temp1,x		; $8BFE9B: 9D 5F 0C
	lda.w #3		; $8BFE9E: A9 03 00  awingd
	sta.b d0		; $8BFEA1: 85 53
	lda.w puckc		; $8BFEA3: AD BB 0E  the other team has the puck
	bmi .de0		; $8BFEA6: 30 13
	sec		; $8BFEA8: 38
	sbc.w #6		; $8BFEA9: E9 06 00
	sta.b d1		; $8BFEAC: 85 57
	txa		; $8BFEAE: 8A
	sec		; $8BFEAF: 38
	sbc.w #12		; $8BFEB0: E9 0C 00
	eor.b d1		; $8BFEB3: 45 57
	bpl .de0		; $8BFEB5: 10 04
	jml.l assreplace		; $8BFEB7: 5C A7 B4 80
.de0:
	lda.w pucky		; $8BFEBB: AD 7B 09  d3 = pucky + puckvy / 64
	sta.b d0		; $8BFEBE: 85 53
	lda.w puckvy		; $8BFEC0: AD 1B 0B
	lsr a		; $8BFEC3: 4A
	lsr a		; $8BFEC4: 4A
	lsr a		; $8BFEC5: 4A
	lsr a		; $8BFEC6: 4A
	lsr a		; $8BFEC7: 4A
	lsr a		; $8BFEC8: 4A
	bit.w #$0200		; $8BFEC9: 89 00 02
	beq .v		; $8BFECC: F0 03
	ora.w #$FC00		; $8BFECE: 09 00 FC
.v:
	clc		; $8BFED1: 18
	adc.b d0		; $8BFED2: 65 53
	sta.b d3		; $8BFED4: 85 5F
	lda.w pfgoal,x		; $8BFED6: BD 3F 11
	bne .de1		; $8BFED9: D0 10
	lda.b d0		; $8BFEDB: A5 53
	eor.w #$FFFF		; $8BFEDD: 49 FF FF
	inc a		; $8BFEE0: 1A
	sta.b d0		; $8BFEE1: 85 53
	lda.b d3		; $8BFEE3: A5 5F
	eor.w #$FFFF		; $8BFEE5: 49 FF FF
	inc a		; $8BFEE8: 1A
	sta.b d3		; $8BFEE9: 85 5F
.de1:		;zone number
	stz.b d2		; $8BFEEB: 64 5B  zone 0: own zone
	lda.b d3		; $8BFEED: A5 5F
	sec		; $8BFEEF: 38
	sbc.w #-88		; $8BFEF0: E9 A8 FF
	bmi .lt1		; $8BFEF3: 30 04
	bvc .z1		; $8BFEF5: 50 04
	bra .de2		; $8BFEF7: 80 34
.lt1:
	bvc .de2		; $8BFEF9: 50 32
.z1:
	lda.w #8		; $8BFEFB: A9 08 00  zone 8: centre
	sta.b d2		; $8BFEFE: 85 5B
	lda.b d0		; $8BFF00: A5 53
	sec		; $8BFF02: 38
	sbc.w #88		; $8BFF03: E9 58 00
	bmi .lt2		; $8BFF06: 30 04
	bvc .z2		; $8BFF08: 50 04
	bra .de2		; $8BFF0A: 80 21
.lt2:
	bvc .de2		; $8BFF0C: 50 1F
.z2:
	ldy.b a2		; $8BFF0E: A4 3B
	lda.w tmflags,y		; $8BFF10: B9 0A 14
	bit.w #tmfoffside		; $8BFF13: 89 10 00  offsides: stay back
	bne .de2		; $8BFF16: D0 15
	asl.b d2		; $8BFF18: 06 5B  zone 16: their zone
	lda.b d3		; $8BFF1A: A5 5F
	sec		; $8BFF1C: 38
	sbc.w #264		; $8BFF1D: E9 08 01
	bmi .lt3		; $8BFF20: 30 04
	bvc .z3		; $8BFF22: 50 04
	bra .de2		; $8BFF24: 80 07
.lt3:
	bvc .de2		; $8BFF26: 50 05
.z3:
	lda.w #24		; $8BFF28: A9 18 00  zone 24: past the goal line
	sta.b d2		; $8BFF2B: 85 5B
.de2:
	lda.b d2		; $8BFF2D: A5 5B
	cmp.w temp5,x		; $8BFF2F: DD DF 0C
	bne .de3		; $8BFF32: D0 08
	lda.w seed		; $8BFF34: AD A1 04  same zone: new spot only now and then (93G HV counter, here seed)
	cmp.w #$0200		; $8BFF37: C9 00 02
	bcs .nodec		; $8BFF3A: B0 32
.de3:
	lda.b d2		; $8BFF3C: A5 5B
	sta.w temp5,x		; $8BFF3E: 9D DF 0C
	tay		; $8BFF41: A8
	lda.w #.dedata		; $8BFF42: A9 AC FF  temp3 = x + random, temp4 = y + random
	sta.b a0		; $8BFF45: 85 33
	lda.w #.dedata>>16		; $8BFF47: A9 8B 00
	sta.b a0+2		; $8BFF4A: 85 35
	iny		; $8BFF4C: C8
	iny		; $8BFF4D: C8
	lda.b [a0],y		; $8BFF4E: B7 33
	dey		; $8BFF50: 88
	dey		; $8BFF51: 88
	jsl.l randomd0s		; $8BFF52: 22 A1 F6 80
	adc.b [a0],y		; $8BFF56: 77 33
	sta.w temp3,x		; $8BFF58: 9D 9F 0C
	iny		; $8BFF5B: C8
	iny		; $8BFF5C: C8
	iny		; $8BFF5D: C8
	iny		; $8BFF5E: C8
	iny		; $8BFF5F: C8
	iny		; $8BFF60: C8
	lda.b [a0],y		; $8BFF61: B7 33
	dey		; $8BFF63: 88
	dey		; $8BFF64: 88
	jsl.l randomd0s		; $8BFF65: 22 A1 F6 80
	adc.b [a0],y		; $8BFF69: 77 33
	sta.w temp4,x		; $8BFF6B: 9D BF 0C
.nodec:
	lda.w temp3,x		; $8BFF6E: BD 9F 0C
	sta.b d0		; $8BFF71: 85 53
	lda.w position,x		; $8BFF73: BD 9F 0B
	cmp.w #5		; $8BFF76: C9 05 00
	beq .one		; $8BFF79: F0 08
	lda.b d0		; $8BFF7B: A5 53
	eor.w #$FFFF		; $8BFF7D: 49 FF FF
	inc a		; $8BFF80: 1A
	sta.b d0		; $8BFF81: 85 53
.one:		;93G .1
	lda.w temp4,x		; $8BFF83: BD BF 0C
	sta.b d1		; $8BFF86: 85 57
	lda.w pfgoal,x		; $8BFF88: BD 3F 11
	bne .up		; $8BFF8B: D0 10
	lda.b d0		; $8BFF8D: A5 53
	eor.w #$FFFF		; $8BFF8F: 49 FF FF
	inc a		; $8BFF92: 1A
	sta.b d0		; $8BFF93: 85 53
	lda.b d1		; $8BFF95: A5 57
	eor.w #$FFFF		; $8BFF97: 49 FF FF
	inc a		; $8BFF9A: 1A
	sta.b d1		; $8BFF9B: 85 57
.up:
	lda.w #EvadePC		; $8BFF9D: A9 6A FD  avoid the puck carrier (EvadePC)
	sta.b a0		; $8BFFA0: 85 33
	lda.w #EvadePC>>16		; $8BFFA2: A9 89 00
	sta.b a0+2		; $8BFFA5: 85 35
	jml.l skateto		; $8BFFA7: 5C D0 FD 88
.rtl:
	rtl		; $8BFFAB: 6B
.dedata:		;93G .dedata: x, x random, y, y random per zone
	dw 80,20,-70,10		; $8BFFAC own zone
	dw 100,20,60,10		; $8BFFB4 centre
	dw 60,50,230,20		; $8BFFBC their zone
	dw 80,30,250,20		; $8BFFC4 past the goal line
showref:		;auto: CODE_8BFFCC (from setvideo). 93G showref (video93_1): SNES only clears sf2refref (the ref window goes by DMA elsewhere)
	lda.w #sf2refref		; $8BFFCC: A9 00 02
	trb.w sflags		; $8BFFCF: 1C 8C 12
	rtl		; $8BFFD2: 6B
skatetopuckinit:		;auto: CODE_8BFFD3. 93G skatetopuckinit (logic93_5): d0/d1 = puck x/y plus half the high byte of its velocity
	lda.w puckvx		; $8BFFD3: AD FB 0A  puckvx high byte / 2
	xba		; $8BFFD6: EB
	lsr a		; $8BFFD7: 4A
	and.w #$007F		; $8BFFD8: 29 7F 00
	bit.w #$0040		; $8BFFDB: 89 40 00
	beq .x		; $8BFFDE: F0 03
	ora.w #$FF80		; $8BFFE0: 09 80 FF
.x:
	clc		; $8BFFE3: 18
	adc.w puckx		; $8BFFE4: 6D 1B 09
	sta.b d0		; $8BFFE7: 85 53
	lda.w puckvy		; $8BFFE9: AD 1B 0B
	xba		; $8BFFEC: EB
	lsr a		; $8BFFED: 4A
	and.w #$007F		; $8BFFEE: 29 7F 00
	bit.w #$0040		; $8BFFF1: 89 40 00
	beq .y		; $8BFFF4: F0 03
	ora.w #$FF80		; $8BFFF6: 09 80 FF
.y:
	clc		; $8BFFF9: 18
	adc.w pucky		; $8BFFFA: 6D 7B 09
	sta.b d1		; $8BFFFD: 85 57
	rtl		; $8BFFFF: 6B
