; $83CC0C-$83DFFF  ROM $1CC0C-$1DFFF: PlayerNumName, then the start of IceRinkMap (vertical rink tile map, data/IceRink.snesmap,
; continued in bank83_E000). Starts after the packed small font tiles (boundary moved from $83D000).
org $83CC0C
PlayerNumName:		;auto: CODE_83CC0C. SNES: mesarea = "<uniform number> <name>" of the roster player d0 (team a2), like the 92G Pausemode .gnum digits. Returns X = mesarea
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pushb:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushb
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	jsl.l GetPlayerRecord		; a0 = the player entry, bank $89: a0 = roster entry of player d0
	stx.b xsave
	ldx.w #$0000
.push2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .push2
	ldx.b xsave
	lda.w #mesarea		; a3 = mesarea (length 4), a1 = mesarea+2
	sta.b a3
	inc a
	inc a
	sta.b a1
	lda.w #$0000
	sta.b a3+2
	sta.b a1+2
	lda.w #$0004
	sta.b [a3]
	lda.b a0		; skip the name: the uniform number byte
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2		; two digits, then a blank and the name
	jsl.l appendz
	dw $0003		; printz inline string: length (counts itself), then control bytes / text
	db " "
	stx.b xsave
	ldx.w #$0002
.pop1:
	pla
	sta.b a1,x
	dex
	dex
	bpl .pop1
	ldx.b xsave
	jsl.l appstring		; bank $8F: appstring
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stx.b xsave
	ldx.w #$0002
.pop2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .pop2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.pop3:
	pla
	sta.b a2,x
	dex
	dex
	bpl .pop3
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
IceRinkMap:		;the vertical rink tile map: 48 x 85 words (8160 bytes, data/IceRink.snesmap). Rows go to vram as Vpos scrolls; 93G IceRinkMap
	incbin "../data/IceRink.snesmap":0..$1335		; $83CCCB-$83DFFF
