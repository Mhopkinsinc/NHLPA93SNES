addframe_hi:		;SNES addframe path for sprframe >= $293: find the frame set in the table at FrameSetTable (sprframe -= set size, sprsetofs += set offset) and draw it (DrawFrameHi); lower
		;   frames go to addframe_end
	lda.b sprframe
	cmp.w #$0293
	bcs .hi
	jml.l addframe_end
.hi:
	dec.b sprframe
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.find:
	lda.l FrameSetTable,x		; skip empty table entries
	beq .find
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .next
	jml.l DrawFrameHi
.next:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .find
