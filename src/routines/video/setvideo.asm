setvideo:		;Once per game frame, when vblank is idle: build the sprite table and the transfer list for the next vblank.
		;   Not vblank code itself
	lda.b vbint		; vblank busy with a list: skip this frame
	cmp.w #vb2
	beq .go
	cmp.w #vb2_blank
	bne .rtl
	lda.b fadein		; first time after vb2_blank: fade in
	bne .go
	stz.b brightness
	inc.b fadein
.go:		;clear the sprite table
	jsl.l ClearSprites		; clear the sprite table (all sprites off screen)
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
	jsl.l show_rink
	jsl.l checkfo
	jsl.l checksso
	jsl.l setsortcords
	jsl.l setffo
	jsl.l showclock
	jsl.l showzam		; elapsed time from vcountmark
	jsl.l showcrowd
	jsl.l showref		; clears sf2refref
	jsl.l ShowRinkRows		; queue the rink map rows for Vscroll
	jsl.l QueueTextDMA		; queue the changed textmap words (textdirtylo/hi)
	lda.w #VBlank_long		; VBlank sends it all next vblank
	sta.b vbint
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
.rtl:
	rtl
