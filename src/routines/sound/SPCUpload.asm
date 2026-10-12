SPCUpload:		;SNES: send the upload stream at [sndptr] to the SPC700 boot ROM (IPL protocol on APUIO0-3): blocks of length, APU address, data; NMI off while it runs
	stz.w cursong
	sep #$20
	stz.w NMITIMEN		; NMI off; vbactive; queue empty; APUIO0 = $F8
	lda.b #$01
	sta.b vbactive
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	lda.b #$F8
	sta.w APUIO0
	rep #$30
	ldy.w #$0000
	lda.w #$BBAA
	jmp.w .ready
.ready:		;wait for $BBAA from the IPL
	cmp.w APUIO0
	bne .ready
	lda.w #$00CC
	bra .header
.next:		;next block: first data byte
	sep #$20
	lda.b [sndptr],y
	iny
	bpl .first
	ldy.w #$0000
	inc.b sndptr+2
	jmp.w .first
.first:
	xba
	lda.b #$00
	bra .send
.byte:
	xba
	lda.b [sndptr],y
	iny
	bpl .byte2
	ldy.w #$0000
	inc.b sndptr+2
	jmp.w .byte2
.byte2:
	xba
	jmp.w .ack
.ack:
	cmp.w APUIO0
	bne .ack
	inc a
	jmp.w .send
.send:		;APUIO0 = index, APUIO1 = data byte
	rep #$30
	sta.w APUIO0
	sep #$20
	dex
	bne .byte
	jmp.w .endblk
.endblk:
	cmp.w APUIO0
	bne .endblk
	jmp.w .inc3
.inc3:		;next index: +3 (never 0)
	adc.b #$03
	beq .inc3
	jmp.w .header
.header:		;block header: X = length, APUIO2/3 = APU address; APUIO1 = 1 for a data block, 0 to jump
	sep #$20
	pha
	rep #$30
	lda.b [sndptr],y
	tax
	iny
	iny
	bpl .dest
	tya
	and.w #$7FFF
	tay
	inc.b sndptr+2
.dest:
	lda.b [sndptr],y
	sta.w APUIO2
	iny
	iny
	bpl .more
	tya
	and.w #$7FFF
	tay
	inc.b sndptr+2
.more:
	sep #$20
	cpx.w #$0001		; APUIO1 = 1 if more data (length > 0)
	lda.b #$00
	rol a
	sta.w APUIO1
	adc.b #$7F
	pla
	sta.w APUIO0
	jmp.w .blkack
.blkack:
	cmp.w APUIO0
	bne .blkack
	bvc .done		; V set: more blocks
	jmp.w .next
.done:		;last block (length 0): the driver runs
	rep #$30
	stz.w APUIO0
	stz.b vbactive
	rtl
