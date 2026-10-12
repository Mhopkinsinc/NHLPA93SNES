GetPassWord:		;The password screen: pick characters from the grid, Start checks the password; a bad one offers a retry
	lda.w #$0080		; show the password again
	trb.w PassWord
	jsl.l Readjoy12
	jsl.l DrawGameSetupBack
	jsl.l ReadPads
	jsl.l Readjoy12
	jsl.l ClearSprites		; clear the sprite table
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$12
	lda.w #17
	sta.b d0
	lda.w #5
	sta.b d1
	jsl.l Framer		; d0 x d1
	lda.w #PasswordText
	sta.b a1
	lda.w #PasswordText>>16
	sta.b a1+2
.textlp:
	jsl.l print
	ldy.w #$0002
	lda.b [a1],y
	and.w #$00FF
	bne .textlp
	dec.w printx		; cursor back over the blanks
	dec.w printx
	lda.w #PasstoText		; a0 = PasstoText
	sta.b a0
	lda.w #PasstoText>>16
	sta.b a0+2
	lda.w #4
	sta.b d0
.top2:		;5 rows
	lda.w #5
	sta.b d1
	lda.w #mesarea		; a1 = mesarea, length 13
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #13
	sta.b [a1]
	inc.b a1
	inc.b a1
.top1:		;6 columns: character, blank
	lda.b [a0]
	sta.b [a1]
	inc.b a0
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .top1
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jsl.l print
	inc.w printy
	inc.w printy
	lda.w printx
	sec
	sbc.w #11
	sta.w printx
	dec.b d0
	bpl .top2
	stz.b d4
	stz.b d5
	jsl.l .setd4		; cursor at character 0, frame around grid character 0
	jsl.l .setd5
	jsl.l Framer		; d0 x d1
.topx:
	jsl.l printz
	dw $0013		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$13,"D Pad - Select"
	jsl.l printz
	dw $0011		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$14,"    A - Next"
	jsl.l printz
	dw $0011		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$15,"    Y - Back"
.input:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$10
	jsl.l PWprint
	lda.w #VBlank_SprPal
.wait:		;wait for the next vblank
	cmp.b vbint
	beq .wait
	jsl.l QueueTextDMA		; queue the changed textmap words
	jsl.l QueueBackmapDMA
	lda.w #VBlank_SprPal
	sta.b vbint
.pad:
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	beq .pad
	sta.b d1
	bit.w #JOYSTART		; Start: done
	beq .keys
	jmp.w .exit
.keys:
	stz.b d0
	dec.b d0
	bit.w #abut		; Y: left
	bne .pwl
	stz.b d0
	inc.b d0
	bit.w #JOYA		; A: right
	bne .pwl
	bit.w #JOYRIGHT		; right: next character
	bne .pws
	stz.b d0
	dec.b d0
	bit.w #JOYLEFT		; left
	bne .pws
	ldy.w #6
	sty.b d0
	bit.w #JOYDOWN		; down: 6 on
	bne .pws
	ldy.w #-6
	sty.b d0
	bit.w #JOYUP		; up: 6 back
	bne .pws
	bra .input
.pwl:		;Y/A: cursor d4 left/right
	lda.b d4
	clc
	adc.b d0
	cmp.w #16		; PWlength-1
	bcs .input
	sta.b d4
	jsl.l .setd4
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	stz.b d0
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	cmp.w #PWrange		; pwrange: a set character
	bcs .pws
	sec
	sbc.b d5
	sta.b d0
.pws:		;dpad: character d5 by d0
	lda.b d5
	clc
	adc.b d0
	cmp.w #PWrange		; PWrange
	bcc .pwset
	jmp.w .input
.pwset:
	pha
	jsl.l .setd5
	phx
	lda.w printy		; erase the old frame (3 x 3 blanks in backmap)
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.w printx
	tax
	lda.w blankchar
	sta.l backmap,x
	sta.l backmap+2,x
	sta.l backmap+4,x
	sta.l backmap+$40,x
	sta.l backmap+$42,x
	sta.l backmap+$44,x
	sta.l backmap+$80,x
	sta.l backmap+$82,x
	sta.l backmap+$84,x
	plx
	pla
	sta.b d5
	jsl.l .setd5
	jsl.l Framer		; d0 x d1
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	ldy.b d4
	sep #$20		; PassWord[d4] = d5
	lda.b d5
	sta.b [a0],y
	rep #$30
	jmp.w .input
.setd4:		;print the " < " cursor under password character d4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$11
	lda.w printx
	clc
	adc.b d4
	sta.w printx
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db " < "
	rtl
.setd5:		;printx/printy and d0 = d1 = 3: frame around grid character d5
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$14,$0D
	lda.b d5
	sta.b mulb
	lda.w #6
	sta.b mula
	jsl.l divu16		; grid row/column of d5 (6 per row)
	asl a
	adc.w printy
	sta.w printy
	lda.b mulres+2
	asl a
	adc.w printx
	dec a
	dec a
	sta.w printx
	lda.w #3
	sta.b d0
	sta.b d1
.rtl:
	rtl
.exit:		;Start
	jsl.l DecodePW
	lda.w postarts		; no error: exit
	bpl .rtl
	jsl.l printz
	dw $0013		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$13,"Bad Password  "
	jsl.l printz
	dw $0013		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$14,"A - Retry     "
	jsl.l printz
	dw $0014		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$15,"Y - Exit Screen"
	lda.w #VBlank_SprPal
.wait2:
	cmp.b vbint
	beq .wait2
	jsl.l QueueTextDMA		; queue the changed textmap words
	jsl.l QueueBackmapDMA
	lda.w #VBlank_SprPal
	sta.b vbint
.notok:
	jsl.l ReadPads
	lda.w padnew1
	ora.w padnew1+2
	beq .notok
	sta.b d1
	bit.w #abut		; Y: setup screen
	bne .setup
	bit.w #JOYA		; A: retry
	beq .notok
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$01,$12
	lda.w #17
	sta.b d0
	lda.w #5
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser		; erase the message box, bank $8D (d0 x d1, tile d2)
	jmp.w .topx
.setup:		;Y: back to the setup screen (new playoffs)
	lda.w #2
	sta.w OptPlayMode
	jml.l Restart		; the setup screens
