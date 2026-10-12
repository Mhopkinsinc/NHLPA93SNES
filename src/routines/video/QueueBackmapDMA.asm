QueueBackmapDMA:		;Queue the background map for transfer to video memory
	ldy.b DMAListend
	lda.w #backmap
	sta.w DMAList,y
	lda.w #backmap>>16
	sta.w DMAList+dmabank,y
	lda.w #$0800
	sta.w DMAList+dmalen,y
	lda.w #$0400
	sta.w DMAList+dmavram,y
	tya
	clc
	adc.w #dmasize
	sta.b DMAListend
	rtl
