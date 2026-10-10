; $8BF003-$8BFFFF  ROM $5F003-$5FFFF: the last SpriteSet5 tiles, printbig (middle93_2), asswingo (logic93_3, asstab 4), showref (video93_1),
; skatetopuckinit (logic93_5).
org $8BF003
	incbin "../data/Sprites/set05.chr":$6335..$7000		; $8BF003-$8BFCCD
SpriteSet5End:
	assert SpriteSet5End-SpriteSet5 == $8E0+896*32
printbig:		;auto: CODE_8BFCCE. 93G printbig (middle93_2): print string [a1] in the big font (2 x 2 tiles, narrow characters 1 column) at printx/printy; control codes as print
	phx
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
	beq .char
	jmp.w .code
.char:
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
	lda.l BigFontIndex,x		; character width/tile table ($8F8269): negative = 1 column
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
	lda.l BigFontMap,x		; big font map ($8F8000): top left
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
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	plx
	rtl
asswingo:		;auto: CODE_8BFE47 (asstab 4). 93G asswingo (logic93_3): wing on offence: pick a spot in the zone the puck is in (.dedata + random), awingd when the other team has the puck
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing		; bank $8F: assnothing
.gm:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .chk
	jmp.w .rtl
.chk:
	bit.w #$0002
	beq .nna
	and.w #$FFFD
	sta.w pflags,x
	lda.w #$FFFF		; temp5 = -1: no zone yet
	sta.w temp5,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .new
	jmp.w .nodec
.new:
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w #3		; awingd
	sta.b d0
	lda.w puckc		; the other team has the puck
	bmi .de0
	sec
	sbc.w #6
	sta.b d1
	txa
	sec
	sbc.w #12
	eor.b d1
	bpl .de0
	jml.l assreplace
.de0:
	lda.w pucky		; d3 = pucky + puckvy / 64
	sta.b d0
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .v
	ora.w #$FC00
.v:
	clc
	adc.b d0
	sta.b d3
	lda.w pfgoal,x
	bne .de1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
.de1:		;zone number
	stz.b d2		; zone 0: own zone
	lda.b d3
	sec
	sbc.w #-88
	bmi .lt1
	bvc .z1
	bra .de2
.lt1:
	bvc .de2
.z1:
	lda.w #8		; zone 8: centre
	sta.b d2
	lda.b d0
	sec
	sbc.w #88
	bmi .lt2
	bvc .z2
	bra .de2
.lt2:
	bvc .de2
.z2:
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside		; offsides: stay back
	bne .de2
	asl.b d2		; zone 16: their zone
	lda.b d3
	sec
	sbc.w #264
	bmi .lt3
	bvc .z3
	bra .de2
.lt3:
	bvc .de2
.z3:
	lda.w #24		; zone 24: past the goal line
	sta.b d2
.de2:
	lda.b d2
	cmp.w temp5,x
	bne .de3
	lda.w seed		; same zone: new spot only now and then (93G HV counter, here seed)
	cmp.w #$0200
	bcs .nodec
.de3:
	lda.b d2
	sta.w temp5,x
	tay
	lda.w #.dedata		; temp3 = x + random, temp4 = y + random
	sta.b a0
	lda.w #.dedata>>16
	sta.b a0+2
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp3,x
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp4,x
.nodec:
	lda.w temp3,x
	sta.b d0
	lda.w position,x
	cmp.w #5
	beq .one
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.one:		;93G .1
	lda.w temp4,x
	sta.b d1
	lda.w pfgoal,x
	bne .up
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.up:
	lda.w #EvadePC		; avoid the puck carrier (EvadePC)
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jml.l skateto
.rtl:
	rtl
.dedata:		;93G .dedata: x, x random, y, y random per zone
	dw 80,20,-70,10		; own zone
	dw 100,20,60,10		; centre
	dw 60,50,230,20		; their zone
	dw 80,30,250,20		; past the goal line
showref:		;auto: CODE_8BFFCC (from setvideo). 93G showref (video93_1): SNES only clears sf2refref (the ref window goes by DMA elsewhere)
	lda.w #sf2refref
	trb.w sflags
	rtl
skatetopuckinit:		;auto: CODE_8BFFD3. 93G skatetopuckinit (logic93_5): d0/d1 = puck x/y plus half the high byte of its velocity
	lda.w puckvx		; puckvx high byte / 2
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .x
	ora.w #$FF80
.x:
	clc
	adc.w puckx
	sta.b d0
	lda.w puckvy
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .y
	ora.w #$FF80
.y:
	clc
	adc.w pucky
	sta.b d1
	rtl
