; $8AF000-$8AFFFF  ROM $57000-$57FFF: the last SpriteSet12 tiles, PlayoffBracketMap (the playoff tree connectors), Credits (title screen text),
; lineinput and getlchoice (logic93_1), SetScore (penalty93_2), $FF fill.
org $8AF000
	incbin "../data/Sprites/set12.chr":$6780..$7000		; $8AF000-$8AF87F
SpriteSet12End:
	assert SpriteSet12End-SpriteSet12 == $880+896*32
PlayoffBracketMap:		;93G DrawPlayoffBracket graphics: 23 rows of 12 map words; PlayoffScreen copies column n (arrow graphics n) to the tree
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; $8AF880
	dw $0801,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$4801		; $8AF898
	dw $0802,$0803,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$4803,$4802		; $8AF8B0
	dw $0804,$8803,$0801,$0000,$0000,$0000,$0000,$0000,$0000,$4801,$C803,$4804		; $8AF8C8
	dw $0000,$0000,$0805,$0000,$0000,$0000,$0000,$0000,$0000,$0805,$0000,$0000		; $8AF8E0
	dw $0000,$0000,$0802,$0803,$0000,$0000,$0000,$0000,$4803,$4802,$0000,$0000		; $8AF8F8
	dw $0000,$0000,$8802,$8803,$0801,$0000,$0000,$4801,$C803,$C802,$0000,$0000		; $8AF910
	dw $0801,$0000,$0805,$0000,$0805,$0000,$0000,$0805,$0000,$0805,$0000,$4801		; $8AF928
	dw $0802,$0803,$8801,$0000,$0805,$0000,$0000,$0805,$0000,$C801,$4803,$4802		; $8AF940
	dw $0804,$8803,$0000,$0000,$0805,$0000,$0000,$0805,$0000,$0000,$C803,$4804		; $8AF958
	dw $0000,$0000,$0000,$0000,$0802,$0803,$4803,$4802,$0000,$0000,$0000,$0000		; $8AF970
	dw $0000,$0000,$0000,$0000,$8802,$8803,$C803,$C802,$0000,$0000,$0000,$0000		; $8AF988
	dw $0000,$0000,$0000,$0000,$0805,$0000,$0000,$0805,$0000,$0000,$0000,$0000		; $8AF9A0
	dw $8804,$0803,$0000,$0000,$0805,$0000,$0000,$0805,$0000,$0000,$4803,$C804		; $8AF9B8
	dw $8802,$8803,$0801,$0000,$0805,$0000,$0000,$0805,$0000,$4801,$C803,$C802		; $8AF9D0
	dw $8801,$0000,$0805,$0000,$0805,$0000,$0000,$0805,$0000,$0805,$0000,$C801		; $8AF9E8
	dw $0000,$0000,$0802,$0803,$8801,$0000,$0000,$C801,$4803,$4802,$0000,$0000		; $8AFA00
	dw $0000,$0000,$8802,$8803,$0000,$0000,$0000,$0000,$C803,$C802,$0000,$0000		; $8AFA18
	dw $0000,$0000,$0805,$0000,$0000,$0000,$0000,$0000,$0000,$0805,$0000,$0000		; $8AFA30
	dw $8804,$0803,$8801,$0000,$0000,$0000,$0000,$0000,$0000,$C801,$4803,$C804		; $8AFA48
	dw $8802,$8803,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$C803,$C802		; $8AFA60
	dw $8801,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$C801		; $8AFA78
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; $8AFA90
Credits:		;93G Credits: the title screen credit lines (length word, text); $FE ends the copyright page, $FF a page, an empty string the list
	dw 24		; $8AFAA8
	db "$ 1992 Electronic Arts"
	dw 22		; $8AFAC0
	db "Licensed by Nintendo"
	dw 3		; $8AFAD6
	db $FE
	dw 19		; $8AFAD9
	db "Design adapted by"
	dw 15		; $8AFAEC
	db "Michael Brook"
	dw 11		; $8AFAFB
	db "Scott Orr"
	dw 18		; $8AFB06
	db "Richard Hilleman"
	dw 3		; $8AFB18
	db $FF
	dw 21		; $8AFB1B
	db "Technical Design by"
	dw 13		; $8AFB30
	db "Jim Simmons"
	dw 3		; $8AFB3D
	db $FF
	dw 15		; $8AFB40
	db "Programmed by"
	dw 24		; $8AFB4F
	db "Park Place Productions"
	dw 18		; $8AFB67
	db "William Robinson"
	dw 3		; $8AFB79
	db $FF
	dw 13		; $8AFB7C
	db "Graphics by"
	dw 16		; $8AFB89
	db "George Simmons"
	dw 14		; $8AFB99
	db "Brian O'Hara"
	dw 16		; $8AFBA7
	db "Curt Toumanian"
	dw 3		; $8AFBB7
	db $FF
	dw 20		; $8AFBBA
	db "Music and Sound by"
	dw 13		; $8AFBCE
	db "Rob Hubbard"
	dw 3		; $8AFBDB
	db $FF
	dw 13		; $8AFBDE
	db "Produced by"
	dw 15		; $8AFBEB
	db "Michael Brook"
	dw 3		; $8AFBFA
	db $FF
	dw 20		; $8AFBFD
	db "Assistant Producer"
	dw 14		; $8AFC11
	db "Robert Zalot"
	dw 3		; $8AFC1F
	db $FF
	dw 21		; $8AFC22
	db "Technical Directors"
	dw 14		; $8AFC37
	db "Scott Cronce"
	dw 11		; $8AFC45
	db "Tom DeBry"
	dw 3		; $8AFC50
	db $FF
	dw 12		; $8AFC53
	db "Testing by"
	dw 10		; $8AFC5F
	db "Yun Shin"
	dw 15		; $8AFC69
	db "Steve Matulac"
	dw 16		; $8AFC78
	db "Mike Rubinelli"
	dw 3		; $8AFC88
	db $FF
	dw 19		; $8AFC8B
	db "Player Ratings by"
	dw 15		; $8AFC9E
	db "Igor Kuperman"
	dw 3		; $8AFCAD
	db $FF
	dw 19		; $8AFCB0
	db "Special Thanks to"
	dw 12		; $8AFCC3
	db "Bob Borgen"
	dw 12		; $8AFCCF
	db "Ted Saskin"
	dw 12		; $8AFCDB
	db "Ian Pulver"
	dw 11		; $8AFCE7
	db "Rob Blake"
	dw 15		; $8AFCF2
	db "John McIntyre"
	dw 3		; $8AFD01
	db $FF
	dw 2		; $8AFD04 empty: end of the credits
	dw 3		; $8AFD06
	db $FF
	dw 3		; $8AFD09
	db $FF
lineinput:		;auto: CODE_8AFD0C (from $80DF7C). 93G lineinput (logic93_1): line change input, d1 = new buttons: Y/B/A choose line choice 0-2 (lcfound); else skate with the dpad
	lda.b d1		; $8AFD0C: A5 57
	pha		; $8AFD0E: 48
	stz.b a2		; $8AFD0F: 64 3B
	lda.w pfteam,x		; $8AFD11: BD 9F 11
	beq .zero		; $8AFD14: F0 04
	inc.b a2		; $8AFD16: E6 3B
	inc.b a2		; $8AFD18: E6 3B
.zero:		;93G .0
	ldy.b a2		; $8AFD1A: A4 3B
	lda.w tmflags,y		; $8AFD1C: B9 0A 14
	bit.w #tmfstartlc		; $8AFD1F: 89 01 00
	beq .one		; $8AFD22: F0 0E
	and.w #~tmfstartlc&$FFFF		; $8AFD24: 29 FE FF
	sta.w tmflags,y		; $8AFD27: 99 0A 14
	jsl.l lcfound2		; $8AFD2A: 22 B7 FC 86
	jsl.l SetLCmode2		; $8AFD2E: 22 48 A7 80
.one:		;93G .1
	pla		; $8AFD32: 68
	sta.b d1		; $8AFD33: 85 57
	stz.b d2		; $8AFD35: 64 5B
	bit.w #abut		; $8AFD37: 89 00 40
	beq .b		; $8AFD3A: F0 04
	jml.l $8F8DC7		; $8AFD3C: 5C C7 8D 8F  bank $8F: 93G lcfound (d2 = choice)
.b:
	inc.b d2		; $8AFD40: E6 5B
	bit.w #bbut		; $8AFD42: 89 00 80
	beq .a		; $8AFD45: F0 04
	jml.l $8F8DC7		; $8AFD47: 5C C7 8D 8F  bank $8F: 93G lcfound (d2 = choice)
.a:
	inc.b d2		; $8AFD4B: E6 5B
	bit.w #JOYA		; $8AFD4D: 89 80 00
	beq .dpad		; $8AFD50: F0 04
	jml.l $8F8DC7		; $8AFD52: 5C C7 8D 8F  bank $8F: 93G lcfound (d2 = choice)
.dpad:
	lda.w pflags,x		; $8AFD56: BD DF 0E
	bit.w #pfjoycon		; $8AFD59: 89 08 00
	beq .x		; $8AFD5C: F0 0E
	lda.w pfalock,x		; $8AFD5E: BD 7F 11
	bne .x		; $8AFD61: D0 09
	lda.w pf2fight,x		; $8AFD63: BD 5F 11
	bne .x		; $8AFD66: D0 04
	jml.l $8FFBDC		; $8AFD68: 5C DC FB 8F  bank $8F: doplayeracc
.x:
	rtl		; $8AFD6C: 6B
getlchoice:		;auto: CODE_8AFD6D. 93G getlchoice (logic93_1): d0 = choice 0-2 of team a2 -> d0 = line 0-6 by the man advantage and tmline (.tab), -1 = none
	stx.b xsave		; $8AFD6D: 86 0A
	ldx.w #$0000		; $8AFD6F: A2 00 00
.pushd:
	lda.b d1,x		; $8AFD72: B5 57
	pha		; $8AFD74: 48
	inx		; $8AFD75: E8
	inx		; $8AFD76: E8
	cpx.w #$0008		; $8AFD77: E0 08 00
	bne .pushd		; $8AFD7A: D0 F6
	ldx.b xsave		; $8AFD7C: A6 0A
	lda.b a2		; $8AFD7E: A5 3B
	eor.w #2		; $8AFD80: 49 02 00
	tay		; $8AFD83: A8
	lda.w tmap,y		; $8AFD84: B9 EE 13
	ldy.b a2		; $8AFD87: A4 3B
	sec		; $8AFD89: 38
	sbc.w tmap,y		; $8AFD8A: F9 EE 13
	sta.b d2		; $8AFD8D: 85 5B
	beq .one		; $8AFD8F: F0 14
	lda.b d0		; $8AFD91: A5 53
	clc		; $8AFD93: 18
	adc.w #21		; $8AFD94: 69 15 00
	sta.b d0		; $8AFD97: 85 53
	lda.b d2		; $8AFD99: A5 5B
	bmi .one		; $8AFD9B: 30 08
	lda.b d0		; $8AFD9D: A5 53
	clc		; $8AFD9F: 18
	adc.w #21		; $8AFDA0: 69 15 00
	sta.b d0		; $8AFDA3: 85 53
.one:		;93G .1
	ldy.b a2		; $8AFDA5: A4 3B
	lda.w tmline,y		; $8AFDA7: B9 DE 13
	sta.b d1		; $8AFDAA: 85 57
	lda.b d0		; $8AFDAC: A5 53
	clc		; $8AFDAE: 18
	adc.b d1		; $8AFDAF: 65 57
	clc		; $8AFDB1: 18
	adc.b d1		; $8AFDB2: 65 57
	clc		; $8AFDB4: 18
	adc.b d1		; $8AFDB5: 65 57
	sta.b d0		; $8AFDB7: 85 53
	tay		; $8AFDB9: A8
	lda.w #.tab		; $8AFDBA: A9 E2 FD
	sta.b a0		; $8AFDBD: 85 33
	lda.w #.tab>>16		; $8AFDBF: A9 8A 00
	sta.b a0+2		; $8AFDC2: 85 35
	lda.b [a0],y		; $8AFDC4: B7 33
	and.w #$00FF		; $8AFDC6: 29 FF 00
	bit.w #$0080		; $8AFDC9: 89 80 00
	beq .pos		; $8AFDCC: F0 03
	ora.w #$FF00		; $8AFDCE: 09 00 FF
.pos:
	sta.b d0		; $8AFDD1: 85 53
	stx.b xsave		; $8AFDD3: 86 0A
	ldx.w #$0006		; $8AFDD5: A2 06 00
.popd:
	pla		; $8AFDD8: 68
	sta.b d1,x		; $8AFDD9: 95 57
	dex		; $8AFDDB: CA
	dex		; $8AFDDC: CA
	bpl .popd		; $8AFDDD: 10 F9
	ldx.b xsave		; $8AFDDF: A6 0A
	rtl		; $8AFDE1: 6B
.tab:		;93G .tab: line for choice 0-2 by tmline, 3 entries per line (-1 = none)
	db 0,1,2, 1,2,0, 2,0,1, 0,1,2, 0,1,2, 0,1,2, 0,1,2		; $8AFDE2 no power play: lines 0-6
	db 3,4,-1, 3,4,-1, 3,4,-1, 3,4,-1, 4,3,-1, 3,4,-1, 3,4,-1		; $8AFDF7 penalty killing: lines 0-6
	db 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 6,5,-1		; $8AFE0C power play: lines 0-6
SetScore:		;auto: CODE_8AFE21 (from UpdateScores $82F9F4, $8F9062). 93G SetScore (penalty93_2): one period of playoff game a0: random goals by ScoreOdds (.getscore); after period 3 a game within one
		;   goal goes to overtime and asks for a highlight
	ldy.b a0		; $8AFE21: A4 33
	lda.w gsper,y		; $8AFE23: B9 BF 15
	cmp.w #4		; $8AFE26: C9 04 00
	bcc .go		; $8AFE29: 90 03
	jmp.w .rtl		; $8AFE2B: 4C DB FE
.go:
	stx.b xsave		; $8AFE2E: 86 0A
	ldx.w #$0000		; $8AFE30: A2 00 00
.pushd:
	lda.b d0,x		; $8AFE33: B5 53
	pha		; $8AFE35: 48
	inx		; $8AFE36: E8
	inx		; $8AFE37: E8
	cpx.w #$0008		; $8AFE38: E0 08 00
	bne .pushd		; $8AFE3B: D0 F6
	ldx.b xsave		; $8AFE3D: A6 0A
	stx.b xsave		; $8AFE3F: 86 0A
	ldx.w #$0000		; $8AFE41: A2 00 00
.pusha:
	lda.b a0,x		; $8AFE44: B5 33
	pha		; $8AFE46: 48
	inx		; $8AFE47: E8
	inx		; $8AFE48: E8
	cpx.w #$0008		; $8AFE49: E0 08 00
	bne .pusha		; $8AFE4C: D0 F6
	ldx.b xsave		; $8AFE4E: A6 0A
	ldy.b a0		; $8AFE50: A4 33
	lda.w gsper,y		; $8AFE52: B9 BF 15
	cmp.w #3		; $8AFE55: C9 03 00
	bne .zero		; $8AFE58: D0 2C
	lda.w #5		; $8AFE5A: A9 05 00
	sta.w gsper,y		; $8AFE5D: 99 BF 15
	lda.w gss1,y		; $8AFE60: B9 CF 15
	sec		; $8AFE63: 38
	sbc.w gss2,y		; $8AFE64: F9 DF 15
	bit.w #$8000		; $8AFE67: 89 00 80
	beq .diff		; $8AFE6A: F0 04
	eor.w #$FFFF		; $8AFE6C: 49 FF FF
	inc a		; $8AFE6F: 1A
.diff:
	cmp.w #2		; $8AFE70: C9 02 00
	bcs .ex		; $8AFE73: B0 4A
	lda.w #3		; $8AFE75: A9 03 00
	sta.w gsper,y		; $8AFE78: 99 BF 15
	lda.w gsflags,y		; $8AFE7B: B9 EF 15
	ora.w #gsfhl		; $8AFE7E: 09 02 00
	sta.w gsflags,y		; $8AFE81: 99 EF 15
	bra .ex		; $8AFE84: 80 39
.zero:		;93G .0
	lda.w gsper,y		; $8AFE86: B9 BF 15
	inc a		; $8AFE89: 1A
	sta.w gsper,y		; $8AFE8A: 99 BF 15
	lda.w gst1,y		; $8AFE8D: B9 7F 15
	sta.b d0		; $8AFE90: 85 53
	lda.w gst2,y		; $8AFE92: B9 8F 15
	sta.b d1		; $8AFE95: 85 57
	jsl.l .getscore		; $8AFE97: 22 DC FE 8A
	ldy.b a0		; $8AFE9B: A4 33
	lda.w gss1,y		; $8AFE9D: B9 CF 15
	clc		; $8AFEA0: 18
	adc.b d0		; $8AFEA1: 65 53
	sta.w gss1,y		; $8AFEA3: 99 CF 15
	lda.w gst2,y		; $8AFEA6: B9 8F 15
	sta.b d0		; $8AFEA9: 85 53
	lda.w gst1,y		; $8AFEAB: B9 7F 15
	sta.b d1		; $8AFEAE: 85 57
	jsl.l .getscore		; $8AFEB0: 22 DC FE 8A
	ldy.b a0		; $8AFEB4: A4 33
	lda.w gss2,y		; $8AFEB6: B9 DF 15
	clc		; $8AFEB9: 18
	adc.b d0		; $8AFEBA: 65 53
	sta.w gss2,y		; $8AFEBC: 99 DF 15
.ex:
	stx.b xsave		; $8AFEBF: 86 0A
	ldx.w #$0006		; $8AFEC1: A2 06 00
.popa:
	pla		; $8AFEC4: 68
	sta.b a0,x		; $8AFEC5: 95 33
	dex		; $8AFEC7: CA
	dex		; $8AFEC8: CA
	bpl .popa		; $8AFEC9: 10 F9
	ldx.b xsave		; $8AFECB: A6 0A
	stx.b xsave		; $8AFECD: 86 0A
	ldx.w #$0006		; $8AFECF: A2 06 00
.popd:
	pla		; $8AFED2: 68
	sta.b d0,x		; $8AFED3: 95 53
	dex		; $8AFED5: CA
	dex		; $8AFED6: CA
	bpl .popd		; $8AFED7: 10 F9
	ldx.b xsave		; $8AFED9: A6 0A
.rtl:
	rtl		; $8AFEDB: 6B
.getscore:		;93G .getscore: d0 = scoring team, d1 = other team; nibblebuffer = the .sctab rows of both ScoreOdds nibbles; returns d0 = goals 0-3
	asl.b d0		; $8AFEDC: 06 53
	asl.b d0		; $8AFEDE: 06 53
	lda.w #TeamList		; $8AFEE0: A9 00 80
	sta.b a1		; $8AFEE3: 85 37
	lda.w #TeamList>>16		; $8AFEE5: A9 83 00
	sta.b a1+2		; $8AFEE8: 85 39
	ldy.b d0		; $8AFEEA: A4 53
	lda.b [a1],y		; $8AFEEC: B7 37
	sta.b a1		; $8AFEEE: 85 37
	ldy.w #8		; $8AFEF0: A0 08 00
	adc.b [a1],y		; $8AFEF3: 77 37
	sta.b a1		; $8AFEF5: 85 37
	lda.b [a1]		; $8AFEF7: A7 37
	and.w #$0070		; $8AFEF9: 29 70 00
	lsr a		; $8AFEFC: 4A
	adc.w #.sctab		; $8AFEFD: 69 83 FF
	sta.b a1		; $8AFF00: 85 37
	lda.w #.sctab>>16		; $8AFF02: A9 8A 00
	sta.b a1+2		; $8AFF05: 85 39
	lda.b [a1]		; $8AFF07: A7 37
	sta.w nibblebuffer		; $8AFF09: 8D 1F 04
	ldy.w #$0002		; $8AFF0C: A0 02 00
	lda.b [a1],y		; $8AFF0F: B7 37
	sta.w nibblebuffer+2		; $8AFF11: 8D 21 04
	ldy.w #$0004		; $8AFF14: A0 04 00
	lda.b [a1],y		; $8AFF17: B7 37
	sta.w nibblebuffer+4		; $8AFF19: 8D 23 04
	ldy.w #$0006		; $8AFF1C: A0 06 00
	lda.b [a1],y		; $8AFF1F: B7 37
	sta.w nibblebuffer+6		; $8AFF21: 8D 25 04
	asl.b d1		; $8AFF24: 06 57
	asl.b d1		; $8AFF26: 06 57
	lda.w #TeamList		; $8AFF28: A9 00 80
	sta.b a1		; $8AFF2B: 85 37
	lda.w #TeamList>>16		; $8AFF2D: A9 83 00
	sta.b a1+2		; $8AFF30: 85 39
	ldy.b d1		; $8AFF32: A4 57
	lda.b [a1],y		; $8AFF34: B7 37
	sta.b a1		; $8AFF36: 85 37
	ldy.w #8		; $8AFF38: A0 08 00
	adc.b [a1],y		; $8AFF3B: 77 37
	sta.b a1		; $8AFF3D: 85 37
	lda.b [a1]		; $8AFF3F: A7 37
	and.w #$0007		; $8AFF41: 29 07 00
	asl a		; $8AFF44: 0A
	asl a		; $8AFF45: 0A
	asl a		; $8AFF46: 0A
	adc.w #.sctab		; $8AFF47: 69 83 FF
	sta.b a1		; $8AFF4A: 85 37
	lda.w #.sctab>>16		; $8AFF4C: A9 8A 00
	sta.b a1+2		; $8AFF4F: 85 39
	lda.b [a1]		; $8AFF51: A7 37
	adc.w nibblebuffer		; $8AFF53: 6D 1F 04
	sta.w nibblebuffer		; $8AFF56: 8D 1F 04
	ldy.w #$0002		; $8AFF59: A0 02 00
	lda.b [a1],y		; $8AFF5C: B7 37
	adc.w nibblebuffer+2		; $8AFF5E: 6D 21 04
	sta.w nibblebuffer+2		; $8AFF61: 8D 21 04
	ldy.w #$0004		; $8AFF64: A0 04 00
	lda.b [a1],y		; $8AFF67: B7 37
	adc.w nibblebuffer+4		; $8AFF69: 6D 23 04
	sta.w nibblebuffer+4		; $8AFF6C: 8D 23 04
	ldy.w #$0006		; $8AFF6F: A0 06 00
	lda.b [a1],y		; $8AFF72: B7 37
	adc.w nibblebuffer+6		; $8AFF74: 6D 25 04
	sta.w nibblebuffer+6		; $8AFF77: 8D 25 04
	lda.w #4		; $8AFF7A: A9 04 00
	sta.b d0		; $8AFF7D: 85 53
	jml.l $8FE3B0		; $8AFF7F: 5C B0 E3 8F  bank $8F: 93G WeightedRandomSelect (d0 weights in nibblebuffer)
.sctab:		;93G .sctab: weights for 0, 1, 2, 3 goals by ScoreOdds row
	dw $2B,$1E,$17,$04		; $8AFF83
	dw $27,$20,$18,$05		; $8AFF8B
	dw $23,$21,$1A,$06		; $8AFF93
	dw $1E,$22,$1E,$06		; $8AFF9B
	dw $1A,$24,$1E,$08		; $8AFFA3
	dw $16,$25,$1F,$0A		; $8AFFAB
	dw $13,$26,$1F,$0C		; $8AFFB3
	dw $0F,$26,$20,$0F		; $8AFFBB
unusedFF8A:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8AFFC3
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8AFFD3
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8AFFE3
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8AFFF3
