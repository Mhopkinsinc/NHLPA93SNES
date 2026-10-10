; $8AF000-$8AFFFF  ROM $57000-$57FFF: the last SpriteSet12 tiles, PlayoffBracketMap (the playoff tree connectors), Credits (title screen text),
; lineinput and getlchoice (logic93_1), SetScore (penalty93_2), $FF fill.
org $8AF000
	incbin "../data/Sprites/set12.chr":$6780..$7000		; $8AF000-$8AF87F
SpriteSet12End:
	assert SpriteSet12End-SpriteSet12 == $880+896*32
PlayoffBracketMap:		;93G DrawPlayoffBracket graphics: 23 rows of 12 map words; PlayoffScreen copies column n (arrow graphics n) to the tree
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0801,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$4801
	dw $0802,$0803,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$4803,$4802
	dw $0804,$8803,$0801,$0000,$0000,$0000,$0000,$0000,$0000,$4801,$C803,$4804
	dw $0000,$0000,$0805,$0000,$0000,$0000,$0000,$0000,$0000,$0805,$0000,$0000
	dw $0000,$0000,$0802,$0803,$0000,$0000,$0000,$0000,$4803,$4802,$0000,$0000
	dw $0000,$0000,$8802,$8803,$0801,$0000,$0000,$4801,$C803,$C802,$0000,$0000
	dw $0801,$0000,$0805,$0000,$0805,$0000,$0000,$0805,$0000,$0805,$0000,$4801
	dw $0802,$0803,$8801,$0000,$0805,$0000,$0000,$0805,$0000,$C801,$4803,$4802
	dw $0804,$8803,$0000,$0000,$0805,$0000,$0000,$0805,$0000,$0000,$C803,$4804
	dw $0000,$0000,$0000,$0000,$0802,$0803,$4803,$4802,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$8802,$8803,$C803,$C802,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0805,$0000,$0000,$0805,$0000,$0000,$0000,$0000
	dw $8804,$0803,$0000,$0000,$0805,$0000,$0000,$0805,$0000,$0000,$4803,$C804
	dw $8802,$8803,$0801,$0000,$0805,$0000,$0000,$0805,$0000,$4801,$C803,$C802
	dw $8801,$0000,$0805,$0000,$0805,$0000,$0000,$0805,$0000,$0805,$0000,$C801
	dw $0000,$0000,$0802,$0803,$8801,$0000,$0000,$C801,$4803,$4802,$0000,$0000
	dw $0000,$0000,$8802,$8803,$0000,$0000,$0000,$0000,$C803,$C802,$0000,$0000
	dw $0000,$0000,$0805,$0000,$0000,$0000,$0000,$0000,$0000,$0805,$0000,$0000
	dw $8804,$0803,$8801,$0000,$0000,$0000,$0000,$0000,$0000,$C801,$4803,$C804
	dw $8802,$8803,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$C803,$C802
	dw $8801,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$C801
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
Credits:		;93G Credits: the title screen credit lines (length word, text); $FE ends the copyright page, $FF a page, an empty string the list
	dw 24
	db "$ 1992 Electronic Arts"
	dw 22
	db "Licensed by Nintendo"
	dw 3
	db $FE
	dw 19
	db "Design adapted by"
	dw 15
	db "Michael Brook"
	dw 11
	db "Scott Orr"
	dw 18
	db "Richard Hilleman"
	dw 3
	db $FF
	dw 21
	db "Technical Design by"
	dw 13
	db "Jim Simmons"
	dw 3
	db $FF
	dw 15
	db "Programmed by"
	dw 24
	db "Park Place Productions"
	dw 18
	db "William Robinson"
	dw 3
	db $FF
	dw 13
	db "Graphics by"
	dw 16
	db "George Simmons"
	dw 14
	db "Brian O'Hara"
	dw 16
	db "Curt Toumanian"
	dw 3
	db $FF
	dw 20
	db "Music and Sound by"
	dw 13
	db "Rob Hubbard"
	dw 3
	db $FF
	dw 13
	db "Produced by"
	dw 15
	db "Michael Brook"
	dw 3
	db $FF
	dw 20
	db "Assistant Producer"
	dw 14
	db "Robert Zalot"
	dw 3
	db $FF
	dw 21
	db "Technical Directors"
	dw 14
	db "Scott Cronce"
	dw 11
	db "Tom DeBry"
	dw 3
	db $FF
	dw 12
	db "Testing by"
	dw 10
	db "Yun Shin"
	dw 15
	db "Steve Matulac"
	dw 16
	db "Mike Rubinelli"
	dw 3
	db $FF
	dw 19
	db "Player Ratings by"
	dw 15
	db "Igor Kuperman"
	dw 3
	db $FF
	dw 19
	db "Special Thanks to"
	dw 12
	db "Bob Borgen"
	dw 12
	db "Ted Saskin"
	dw 12
	db "Ian Pulver"
	dw 11
	db "Rob Blake"
	dw 15
	db "John McIntyre"
	dw 3
	db $FF
	dw 2		; empty: end of the credits
	dw 3
	db $FF
	dw 3
	db $FF
lineinput:		;auto: CODE_8AFD0C (from $80DF7C). 93G lineinput (logic93_1): line change input, d1 = new buttons: Y/B/A choose line choice 0-2 (lcfound); else skate with the dpad
	lda.b d1
	pha
	stz.b a2
	lda.w pfteam,x		; a2 = the team of player X
	beq .zero
	inc.b a2
	inc.b a2
.zero:		;93G .0
	ldy.b a2
	lda.w tmflags,y		; tmflags bit 0: start line change mode
	bit.w #tmflcc
	beq .one
	and.w #~tmflcc&$FFFF
	sta.w tmflags,y
	jsl.l lcfound2
	jsl.l SetLCmode2
.one:		;93G .1
	pla
	sta.b d1
	stz.b d2
	bit.w #abut		; Y: choice 0
	beq .b
	jml.l lcfound		; bank $8F: 93G lcfound (d2 = choice)
.b:
	inc.b d2
	bit.w #bbut		; B: choice 1
	beq .a
	jml.l lcfound		; bank $8F: 93G lcfound (d2 = choice)
.a:
	inc.b d2
	bit.w #JOYA		; A: choice 2
	beq .dpad
	jml.l lcfound		; bank $8F: 93G lcfound (d2 = choice)
.dpad:
	lda.w pflags,x		; joystick controlled, not locked or fighting: skate
	bit.w #pfjoycon
	beq .x
	lda.w pfalock,x
	bne .x
	lda.w pf2fight,x
	bne .x
	jml.l doplayeracc		; bank $8F: doplayeracc
.x:
	rtl
getlchoice:		;auto: CODE_8AFD6D. 93G getlchoice (logic93_1): d0 = choice 0-2 of team a2 -> d0 = line 0-6 by the man advantage and tmline (.tab), -1 = none
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushd
	ldx.b xsave
	lda.b a2		; d2 = other tmap - our tmap: players short
	eor.w #2
	tay
	lda.w tmap,y
	ldy.b a2
	sec
	sbc.w tmap,y
	sta.b d2
	beq .one
	lda.b d0		; penalty killing: +21
	clc
	adc.w #21
	sta.b d0
	lda.b d2
	bmi .one
	lda.b d0		; power play: +21 more
	clc
	adc.w #21
	sta.b d0
.one:		;93G .1
	ldy.b a2		; + 3 * tmline
	lda.w tmline,y
	sta.b d1
	lda.b d0
	clc
	adc.b d1
	clc
	adc.b d1
	clc
	adc.b d1
	sta.b d0
	tay
	lda.w #.tab
	sta.b a0
	lda.w #.tab>>16
	sta.b a0+2
	lda.b [a0],y
	and.w #$00FF
	bit.w #$0080
	beq .pos
	ora.w #$FF00
.pos:
	sta.b d0
	stx.b xsave
	ldx.w #$0006
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
.tab:		;93G .tab: line for choice 0-2 by tmline, 3 entries per line (-1 = none)
	db 0,1,2, 1,2,0, 2,0,1, 0,1,2, 0,1,2, 0,1,2, 0,1,2		; no power play: lines 0-6
	db 3,4,-1, 3,4,-1, 3,4,-1, 3,4,-1, 4,3,-1, 3,4,-1, 3,4,-1		; penalty killing: lines 0-6
	db 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 6,5,-1		; power play: lines 0-6
SetScore:		;auto: CODE_8AFE21 (from UpdateScores $82F9F4, $8F9062). 93G SetScore (penalty93_2): one period of playoff game a0: random goals by ScoreOdds (.getscore); after period 3 a game within one
		;   goal goes to overtime and asks for a highlight
	ldy.b a0
	lda.w gsper,y
	cmp.w #4
	bcc .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	ldy.b a0
	lda.w gsper,y
	cmp.w #3		; after period 3
	bne .zero
	lda.w #5		; final
	sta.w gsper,y
	lda.w gss1,y
	sec
	sbc.w gss2,y
	bit.w #$8000
	beq .diff
	eor.w #$FFFF
	inc a
.diff:
	cmp.w #2
	bcs .ex
	lda.w #3		; within one goal: overtime
	sta.w gsper,y
	lda.w gsflags,y
	ora.w #gsfhl		; gsfhl: show it in the ticker
	sta.w gsflags,y
	bra .ex
.zero:		;93G .0
	lda.w gsper,y
	inc a
	sta.w gsper,y
	lda.w gst1,y
	sta.b d0
	lda.w gst2,y
	sta.b d1
	jsl.l .getscore
	ldy.b a0
	lda.w gss1,y
	clc
	adc.b d0
	sta.w gss1,y
	lda.w gst2,y
	sta.b d0
	lda.w gst1,y
	sta.b d1
	jsl.l .getscore
	ldy.b a0
	lda.w gss2,y
	clc
	adc.b d0
	sta.w gss2,y
.ex:
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
.rtl:
	rtl
.getscore:		;93G .getscore: d0 = scoring team, d1 = other team; nibblebuffer = the .sctab rows of both ScoreOdds nibbles; returns d0 = goals 0-3
	asl.b d0
	asl.b d0
	lda.w #TeamList		; TeamList entry of team d0
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b a1
	ldy.w #ScoutReport		; 93G 8(a1): the 92G ScoreOdds offset, ScoutReport in the 93G record
	adc.b [a1],y
	sta.b a1
	lda.b [a1]
	and.w #$0070		; bits 4-6: row of the scoring team
	lsr a
	adc.w #.sctab
	sta.b a1
	lda.w #.sctab>>16
	sta.b a1+2
	lda.b [a1]
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	sta.w nibblebuffer+6
	asl.b d1
	asl.b d1
	lda.w #TeamList
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.b d1
	lda.b [a1],y
	sta.b a1
	ldy.w #ScoutReport
	adc.b [a1],y
	sta.b a1
	lda.b [a1]
	and.w #$0007		; bits 0-2: row of the other team
	asl a
	asl a
	asl a
	adc.w #.sctab
	sta.b a1
	lda.w #.sctab>>16
	sta.b a1+2
	lda.b [a1]
	adc.w nibblebuffer
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	adc.w nibblebuffer+2
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	adc.w nibblebuffer+4
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	adc.w nibblebuffer+6
	sta.w nibblebuffer+6
	lda.w #4		; 4 weights
	sta.b d0
	jml.l WeightedRandomSelect		; bank $8F: 93G WeightedRandomSelect (d0 weights in nibblebuffer)
.sctab:		;93G .sctab: weights for 0, 1, 2, 3 goals by ScoreOdds row
	dw $2B,$1E,$17,$04
	dw $27,$20,$18,$05
	dw $23,$21,$1A,$06
	dw $1E,$22,$1E,$06
	dw $1A,$24,$1E,$08
	dw $16,$25,$1F,$0A
	dw $13,$26,$1F,$0C
	dw $0F,$26,$20,$0F
unusedFF8A:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
