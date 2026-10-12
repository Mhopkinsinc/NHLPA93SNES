ClrHor:		;revert the graphics back to vertical ice rink mode. Does not remap the fonts
		;   SNES: revert to the vertical ice rink: clear sfhormode, Oldrow, SprSort, clear the text map, printscores1
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$003C
	bne .savea
	ldx.b xsave
	stz.w sfhormode		; vertical
	lda.w #999		; Oldrow = 999: redraw the rink rows
	sta.w Oldrow
	jsl.l SprSort
	lda.w sflags
	bit.w #sfpz		; paused: keep the text
	bne .ex
	lda.w blankchar		; clear the text map
	clc
	adc.w charofs
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	stz.b textdirtylo		; whole text map dirty
	lda.w #$03FF
	sta.b textdirtyhi
	jsl.l printscores1
.ex:
	stx.b xsave
	ldx.w #$003A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	ldx.b a3
	rtl
