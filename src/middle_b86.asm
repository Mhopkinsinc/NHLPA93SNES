; Utilities (print, joypads, math, decompression).
; Bank $86. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $86FA3E
DecompressGraphics:		;send tiles to vram. a2 = data: word count of tiles (0 = none, bit 15 set = compressed by DecompressBytecode), then the tiles. d4 = start char, returns d4 = end char +
		;   1. Uses remap with callbackPtr when it is set, else DoDMApro
		;   SNES: unpack the stream at [tmp0] to $7F0000 (output pointer tmp1+1..+3, copy distance tmp2+2). Control byte: $00-$1F copy n+1 bytes; $2x n+1 zeros; $3x n+3
		;   times the next byte; $40-$7F, $8x, $9x, $Ax, $Bx copy from earlier output going up; $C0-$DF, $Ex, $Fx going down; $E0 $00 ends
	stz.b tmp1+1		; output pointer = $7F0000
	lda.w #TestList>>16
	sta.b tmp1+3
.next:
	lda.b [tmp0]
	inc.b tmp0
	bit.w #$00E0
	bne .c20
	and.w #$001F
	tax
.lit:
	lda.b [tmp0]
	inc.b tmp0
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .lit
	bra .next
.c20:
	tay
	and.w #$00F0
	cmp.w #$0020
	bne .c30
	tya
	and.w #$000F
	tax
	lda.w #$0000
.zero:
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .zero
	bra .next
.c30:
	cmp.w #$0030
	bne .c40
	tya
	and.w #$000F
	tax
	inx
	inx
	lda.b [tmp0]
	inc.b tmp0
.fill:
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .fill
	bra .next
.c40:		;$40-$7F: distance bits 3-5 + 1, length bits 0-2 + 2
	and.w #$00C0
	cmp.w #$0040
	bne .c80
	tya
	lsr a
	lsr a
	lsr a
	and.w #$0007
	inc a
	sta.b tmp2+2
	tya
	and.w #$0007
	inc a
	inc a
	tay
.up:		;copy Y bytes from output - distance, going up
	lda.b tmp1+1
	sec
	sbc.b tmp2+2
	tax
.upl:
	lda.l TestList,x
	inx
	sta.b [tmp1+1]
	inc.b tmp1+1
	dey
	bne .upl
	bra .next
.c80:		;$8x: length n+3, distance = next byte
	tya
	and.w #$00F0
	cmp.w #$0080
	bne .c90
	tya
	and.w #$000F
	inc a
	inc a
	inc a
	tay
	lda.b [tmp0]
	inc.b tmp0
	and.w #$00FF
	sta.b tmp2+2
	bra .up
.c90:		;$9x: distance 7 bits, length 5 bits
	cmp.w #$0090
	bne .cA0
	lda.b [tmp0]
	inc.b tmp0
	and.w #$007F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	xba
	and.w #$001F
	inc a
	inc a
	inc a
	tay
	bra .up
.cA0:		;$Ax: distance 6 bits, length 6 bits
	cmp.w #$00A0
	bne .cB0
	lda.b [tmp0]
	inc.b tmp0
	and.w #$003F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	asl a
	xba
	and.w #$003F
	inc a
	inc a
	inc a
	tay
	bra .up
.cB0:		;$Bx: distance 5 bits, length 7 bits
	cmp.w #$00B0
	bne .cC0
	lda.b [tmp0]
	inc.b tmp0
	and.w #$001F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	asl a
	asl a
	xba
	and.w #$007F
	inc a
	inc a
	inc a
	tay
	jmp.w .up
.cC0:		;$C0-$DF: going down
	and.w #$00E0
	cmp.w #$00C0
	bne .cE0
	tya
	lsr a
	lsr a
	and.w #$0007
	inc a
	sta.b tmp2+2
	tya
	and.w #$0003
	inc a
	inc a
	tay
.down:		;copy Y bytes going down from output - distance
	lda.b tmp1+1
	sec
	sbc.b tmp2+2
	tax
.dnl:
	lda.l TestList,x
	dex
	sta.b [tmp1+1]
	inc.b tmp1+1
	dey
	bne .dnl
	jmp.w .next
.cE0:		;$Ex: length n+3, distance = next byte (0 = end)
	tya
	and.w #$00F0
	cmp.w #$00E0
	bne .cF0
	tya
	and.w #$000F
	inc a
	inc a
	inc a
	tay
	lda.b [tmp0]
	inc.b tmp0
	and.w #$00FF
	beq .end
	sta.b tmp2+2
	bra .down
.cF0:		;$Fx: going down, distance 7 bits, length 5 bits
	lda.b [tmp0]
	inc.b tmp0
	and.w #$007F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	xba
	and.w #$001F
	inc a
	inc a
	inc a
	tay
	bra .down
.end:
	rtl

org $86FC53
ProcessInputWithRepeat:		;nodiag, then key repeat on d1-d3 from Readjoy1/2. A change (d2) resets the delay to 15 frames; while the same buttons stay held, every 4 frames return d1 = held
		;   buttons (d3). Called from Pausemode, menus and IntermissionLoop
		;   SNES: nodiag (nullrtl85), then key repeat: a change (d2) resets the delay to 15 frames; while the same buttons stay
		;   held, every 4 frames d1 = held buttons (d3)
	jsl.l nullrtl85
	lda.b d3
	beq .rtl
	lda.b d2		; d2 = changed buttons
	bne .chg
	dec.w repeatdelay
	bpl .rtl
	lda.w #4
	sta.w repeatdelay
	lda.b d3
	sta.b d1
.rtl:
	rtl
.chg:
	lda.w #15
	sta.w repeatdelay
	rtl
