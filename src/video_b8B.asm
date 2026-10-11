; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $8B. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8BFFCC
showref:		;draw ref graphics. Called from setvideo.
		;   SNES only clears sf2refref (the ref window goes by DMA elsewhere)
	lda.w #sf2refref
	trb.w sflags
	rtl
