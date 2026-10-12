SetTeamColors_team:		;Convert one team's colors into the palette buffer
	ldy.w #$0002		; team data + word at +2: palette
	lda.b [tmp0],y
	clc
	adc.b tmp2+1
	tay
	lda.w #$0010
	sta.b tmp2+1
.col:		;0BGR (4 bits) -> 0BBBBBGGGGGRRRRR
	lda.b [tmp0],y
	xba
	and.w #$000F
	asl a
	sta.b tmp1+1
	lda.b [tmp0],y
	xba
	and.w #$00F0
	asl a
	asl a
	ora.b tmp1+1
	sta.b tmp1+1
	lda.b [tmp0],y
	xba
	and.w #$0F00
	asl a
	asl a
	asl a
	ora.b tmp1+1
	sta.l palbuffer+$40,x
	sta.l palbuffer+$140,x
	inx
	inx
	iny
	iny
	dec.b tmp2+1
	bne .col
	rtl
