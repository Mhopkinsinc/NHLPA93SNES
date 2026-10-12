addframe:		;a3 = cords.l frame/oldframe VRsize VRchar. Project the object with find3d, then addframe2.
		;   SNES: sprite frame sprframe at sprx/spry: find its frame set in FrameSetTable (sprsetofs), then DrawFrame; frames $293 and up (addframe_hi) and frame 0 are skipped
	lda.b sprframe
	cmp.w #$0293
	bcc .sprframelt
	jml.l addframe_end
.sprframelt:
	dec.b sprframe
	bpl .sprframepos
	jml.l addframe_end
.sprframepos:
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.loop:
	lda.l FrameSetTable,x
	beq .loop
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .sprframege
	jml.l DrawFrame
.sprframege:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .loop
