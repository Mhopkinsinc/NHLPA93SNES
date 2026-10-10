; $83CC0C-$83DFFF  ROM $1CC0C-$1DFFF: PlayerNumName, then the start of IceRinkMap (vertical rink tile map, data/IceRink.snesmap,
; continued in bank83_E000). Starts after the packed big font tiles (boundary moved from $83D000).
org $83CC0C
PlayerNumName:		;auto: CODE_83CC0C. SNES: mesarea = "<uniform number> <name>" of the roster player d0 (team a2), like the 92G Pausemode .gnum digits. Returns X = mesarea
	stx.b xsave		; $83CC0C: 86 0A
	ldx.w #$0000		; $83CC0E: A2 00 00
.pushd:
	lda.b d0,x		; $83CC11: B5 53
	pha		; $83CC13: 48
	inx		; $83CC14: E8
	inx		; $83CC15: E8
	cpx.w #$0010		; $83CC16: E0 10 00
	bne .pushd		; $83CC19: D0 F6
	ldx.b xsave		; $83CC1B: A6 0A
	stx.b xsave		; $83CC1D: 86 0A
	ldx.w #$0000		; $83CC1F: A2 00 00
.pushb:
	lda.b a2,x		; $83CC22: B5 3B
	pha		; $83CC24: 48
	inx		; $83CC25: E8
	inx		; $83CC26: E8
	cpx.w #$0008		; $83CC27: E0 08 00
	bne .pushb		; $83CC2A: D0 F6
	ldx.b xsave		; $83CC2C: A6 0A
	stx.b xsave		; $83CC2E: 86 0A
	ldx.w #$0000		; $83CC30: A2 00 00
.pusha:
	lda.b a0,x		; $83CC33: B5 33
	pha		; $83CC35: 48
	inx		; $83CC36: E8
	inx		; $83CC37: E8
	cpx.w #$0004		; $83CC38: E0 04 00
	bne .pusha		; $83CC3B: D0 F6
	ldx.b xsave		; $83CC3D: A6 0A
	jsl.l $89FCD8		; $83CC3F: 22 D8 FC 89  a0 = the player entry, bank $89: a0 = roster entry of player d0
	stx.b xsave		; $83CC43: 86 0A
	ldx.w #$0000		; $83CC45: A2 00 00
.push2:
	lda.b a0,x		; $83CC48: B5 33
	pha		; $83CC4A: 48
	inx		; $83CC4B: E8
	inx		; $83CC4C: E8
	cpx.w #$0004		; $83CC4D: E0 04 00
	bne .push2		; $83CC50: D0 F6
	ldx.b xsave		; $83CC52: A6 0A
	lda.w #mesarea		; $83CC54: A9 91 01  a3 = mesarea (length 4), a1 = mesarea+2
	sta.b a3		; $83CC57: 85 3F
	inc a		; $83CC59: 1A
	inc a		; $83CC5A: 1A
	sta.b a1		; $83CC5B: 85 37
	lda.w #$0000		; $83CC5D: A9 00 00
	sta.b a3+2		; $83CC60: 85 41
	sta.b a1+2		; $83CC62: 85 39
	lda.w #$0004		; $83CC64: A9 04 00
	sta.b [a3]		; $83CC67: 87 3F
	lda.b a0		; $83CC69: A5 33  skip the name: the uniform number byte
	clc		; $83CC6B: 18
	adc.b [a0]		; $83CC6C: 67 33
	sta.b a0		; $83CC6E: 85 33
	lda.b [a0]		; $83CC70: A7 33
	and.w #$00FF		; $83CC72: 29 FF 00
	sta.b d0		; $83CC75: 85 53
	jsl.l PutDigits2		; $83CC77: 22 39 EA 84  two digits, then a blank and the name
	jsl.l appendz		; $83CC7B: 22 D3 FD 82
	dw $0003		; $83CC7F  printz inline string: length (counts itself), then control bytes / text
	db " "
	stx.b xsave		; $83CC82: 86 0A
	ldx.w #$0002		; $83CC84: A2 02 00
.pop1:
	pla		; $83CC87: 68
	sta.b a1,x		; $83CC88: 95 37
	dex		; $83CC8A: CA
	dex		; $83CC8B: CA
	bpl .pop1		; $83CC8C: 10 F9
	ldx.b xsave		; $83CC8E: A6 0A
	jsl.l $8F87C9		; $83CC90: 22 C9 87 8F  bank $8F: appstring
	lda.w #mesarea		; $83CC94: A9 91 01
	sta.b a1		; $83CC97: 85 37
	lda.w #$0000		; $83CC99: A9 00 00
	sta.b a1+2		; $83CC9C: 85 39
	stx.b xsave		; $83CC9E: 86 0A
	ldx.w #$0002		; $83CCA0: A2 02 00
.pop2:
	pla		; $83CCA3: 68
	sta.b a0,x		; $83CCA4: 95 33
	dex		; $83CCA6: CA
	dex		; $83CCA7: CA
	bpl .pop2		; $83CCA8: 10 F9
	ldx.b xsave		; $83CCAA: A6 0A
	stx.b xsave		; $83CCAC: 86 0A
	ldx.w #$0006		; $83CCAE: A2 06 00
.pop3:
	pla		; $83CCB1: 68
	sta.b a2,x		; $83CCB2: 95 3B
	dex		; $83CCB4: CA
	dex		; $83CCB5: CA
	bpl .pop3		; $83CCB6: 10 F9
	ldx.b xsave		; $83CCB8: A6 0A
	stx.b xsave		; $83CCBA: 86 0A
	ldx.w #$000E		; $83CCBC: A2 0E 00
.popd:
	pla		; $83CCBF: 68
	sta.b d0,x		; $83CCC0: 95 53
	dex		; $83CCC2: CA
	dex		; $83CCC3: CA
	bpl .popd		; $83CCC4: 10 F9
	ldx.b xsave		; $83CCC6: A6 0A
	ldx.b a3		; $83CCC8: A6 3F
	rtl		; $83CCCA: 6B
IceRinkMap:		;the vertical rink tile map: 48 x 85 words (8160 bytes, data/IceRink.snesmap). Rows go to vram as Vpos scrolls; 93G IceRinkMap
	incbin "../data/IceRink.snesmap":0..$1335		; $83CCCB-$83DFFF
