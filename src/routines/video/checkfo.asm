checkfo:		;Draw the face off sprites
	lda.w sflags		; not in pause, face off only
	bit.w #sfpz
	bne .rtl
	lda.w sflags
	bit.w #sf2faceoff
	beq .rtl
	lda.w #$0030		; faceoff sprites above the players
	sta.b sprpriority
	ldx.w #$0000
.top:
	lda.w fodropx
	sta.b sprx
	lda.w fodropy
	sta.b spry
	lda.w fofdata2,x		; frame + faceoff sprite base $213
	clc
	adc.w #$0213
	sta.b sprframe
	lda.w fofdata2+2,x
	and.w #$0800
	sta.b sprhflip
	cpx.w #$0004		; third entry (the ref): sprflag
	bne .add
	lda.w #$8000
	sta.b sprflag
.add:
	phx
	jsl.l addframe		; sprframe at sprx/spry
	plx
	inx
	inx
	inx
	inx
	cpx.w #$000C
	bne .top
	lda.w #$0020
	sta.b sprpriority
.rtl:
	rtl
