updatefaceoff:		;Step the puck drop animation; at its end erase the face off box
	lda.w temp1,x
	beq .erase
	clc		; (temp1+6)/8 <= 2: drop frame 10-d0
	adc.w #$0006
	lsr a
	lsr a
	lsr a
	sta.b d0
	sec
	sbc.w #$0002
	beq .set
	bmi .neg
	bvs .set
	bra .rtl
.neg:
	bvs .rtl
.set:
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000A
	sta.b d0
	sta.w fofdata
.rtl:
	rtl
.erase:
	jsl.l printz		; erase the faceoff box
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .x
	ora.w #$E000
.x:
	sta.w printx
	lda.w fodropy
	sec
	sbc.w #$0044
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .y
	ora.w #$E000
.y:
	sta.w printy
	lda.w #$000C
	sta.b d0
	inc a
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser		; d0/d1 size, d2 tile
