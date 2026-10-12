QueueTextDMA:		;Queue the changed part of the text map for transfer to video memory
	lda.b textdirtylo
	bmi .rtl
	ldy.b DMAListend
	sta.w DMAList+dmavram,y
	asl a
	adc.w #textmap
	sta.w DMAList,y
	lda.w #textmap>>16
	sta.w DMAList+dmabank,y
	lda.b textdirtyhi
	beq .rtl
	sec
	sbc.b textdirtylo
	inc a
	asl a
	sta.w DMAList+dmalen,y
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	tya
	clc
	adc.w #dmasize
	sta.b DMAListend
.rtl:
	rtl
