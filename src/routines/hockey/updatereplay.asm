updatereplay:		;Save this frame into the replay buffer
	lda.w gmode
	bit.w #gmhl		; gmhl: no recording
	beq .rec
	jmp.w .rtl
.rec:
	lda.w sflags
	bit.w #sf2drec		; sf2drec: keep overwriting the same frame
	bne .frame
	lda.w ReplayBufferPtr		; next record (113 bytes)
	clc
	adc.w #$0071
	sta.w ReplayBufferPtr
	bcc .wrap
	inc.w ReplayBufferPtr+2
.wrap:
	cmp.w #ReplayBufferEnd&$FFFF
	bne .frame
	lda.w ReplayBufferPtr+2
	cmp.w #ReplayBufferEnd>>16
	bne .frame
	lda.w #sfwrap		; wrapped: sfwrap, back to the start
	tsb.w sflags
	lda.w #ReplayBufferStart&$FFFF
	sta.w ReplayBufferPtr
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
.frame:
	lda.w ReplayBufferPtr
	sta.b a0
	lda.w ReplayBufferPtr+2
	sta.b a0+2
	lda.w #$000F
	sta.b d2
	ldx.w #$0000
	ldy.w #$0001
.top:		;16 objects: x (12 bits) and y (12 bits), frame and flip bits
	lda.w #$0000
	sta.b [a0]
	sta.b [a0],y
	lda.w Xpos,x
	and.w #$0FFF
	sta.b [a0]
	inc.b a0
	lda.w Ypos,x
	asl a
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w frame,x
	and.w #$3FFF
	sta.b [a0]
	lda.w attribute,x
	and.w #$1800
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inc.b a0
	inx
	inx
	dec.b d2
	bpl .top
	lda.w #$0005
	sta.b d2
	ldx.w #$0000
.pl:		;6 pairs: rostnum, positions
	lda.w rostnum,x
	sta.b [a0]
	inc.b a0
	lda.w rostnum+2,x
	sta.b [a0]
	inc.b a0
	lda.w position,x
	bpl .n0
	lda.w #$FFFF
.n0:
	and.w #$000F
	sta.b [a0]
	lda.w position+2,x
	bpl .n1
	lda.w #$FFFF
.n1:
	asl a
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inx
	inx
	inx
	inx
	dec.b d2
	bpl .pl
	lda.w Zpos+puckobj		; puck and shadow height, lastsfx, d7, PadControlBits, crowdframe, glovecords, PBnum, Hpos, Vpos
	sta.b [a0]
	inc.b a0
	lda.w Zpos+$1E
	sta.b [a0]
	inc.b a0
	lda.w lastsfx
	sta.b [a0]
	inc.b a0
	stz.w lastsfx
	lda.b d7
	sta.b [a0]
	inc.b a0
	lda.w PadControlBits
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.b crowdframe
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w glovecords
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w PBnum
	sta.b [a0]
	inc.b a0
	lda.w Hpos
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w Vpos
	sta.b [a0]
.rtl:
	rtl
