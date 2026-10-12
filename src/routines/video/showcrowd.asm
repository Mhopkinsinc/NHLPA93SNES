showcrowd:		;draw crowd sprites: up to 3 frames per PBnum nibble, then the two crowdframe frames.
		;   SNES: up to 3 frames per PBnum nibble (penalty box), then the two crowdframe frames (not on the horizontal rink)
	stz.b a1
	lda.w Hpos
	sta.b d4
	lda.w Vpos
	sta.b d5
	lda.w sfhormode
	beq .v
	lda.w #$FFC0
	sta.b d4
	lda.w #$0100
	sta.b d5
.v:
	stz.b d0
	lda.w PBnum
	sta.b d2
	lda.w #$001A		; frames 26+
	sta.b d3
	jsl.l .pb
	lda.w PBnum
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d2
	lda.w #$001D		; frames 29+
	sta.b d3
	jsl.l .pb
	lda.w sfhormode
	bne .rtl
	lda.b crowdframe
	sta.b d0
	jsl.l .sc
	lda.b crowdframe+1
	sta.b d0
	bra .sc
.pb:		;d2 = count, d3 = first frame
	lda.b d2
	and.w #$000F
	sta.b d2
	cmp.w #$0004
	bcc .pb0
	lda.w #$0003
	sta.b d2
.pb0:
	bra .nextpb
.pbt:
	lda.b d3
	clc
	adc.b d2
	sta.b d0
	jsl.l .sc
.nextpb:
	dec.b d2
	bpl .pbt
.rtl:
	rtl
.sc:		;d0 = frame (0 = none): sprite frame $292 + d0 (+31 horizontal) at the rink scroll position
	lda.b d0		; frame byte
	and.w #$00FF
	sta.b d0
	beq .rtl
	lda.w sfhormode
	beq .chk
	lda.b d0
	clc
	adc.w #31
	sta.b d0
.chk:
	lda.b d0
	clc
	adc.w #$0292		; crowd frames start at $293
	sta.b sprframe
	lda.w #$FFC0		; x = $FFC0 - Hpos
	sec
	sbc.b d4
	sta.b sprx
	lda.w #$FEFF		; y = Vpos - $101
	clc
	adc.b d5
	sta.b spry
	jml.l addframe_hi
