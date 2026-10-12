QueueBackmapDMA:		;SNES: DMAList entry for backmap ($800 bytes) to vram $400
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
