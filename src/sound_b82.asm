; sound_b82: 93G sound93: SPC700 uploads, the sound queue, music cues (93G keeps ScoutingReportText here too).
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82B86C
SPAList:		;93G SPAList
	dw 0		; (SPA 0 = no animation)

org $82FA1A
sndqreset:		;SNES: empty the sound command queue and the music cue
	lda.w #$0001		; sndlock while the queue is reset; cuetimer = 0
	sta.b sndlock
	stz.w cursong
	stz.w cuetimer
	stz.b sndqueue
	stz.b sndqout
	lda.w #$0002
	sta.b sndqin
	stz.b sndlock
	rtl
SPCBootUpload:		;SNES: wait for the queue and a vblank, then send the boot stream at $868000 (driver and its samples, sndbank 2)
	phy
	phx
	pha
.wait:		;brightness: keep the screen dark unless fully on
	lda.b brightness
	cmp.w #$000F
	beq .wq
	stz.b brightness
.wq:
	lda.b sndqin
	cmp.b sndqout
	bne .wait
	lda.b vcount
.vb:
	cmp.b vcount
	beq .vb
	lda.w #$0001		; sndbank 2, no song
	sta.b sndlock
	lda.w #$0002
	sta.w sndbank
	stz.w cursong
	lda.w #BootSoundUpload&$FFFF		; sndptr = BootSoundUpload
	sta.b sndptr
	lda.w #(BootSoundUpload>>8)&$FFFF
	sta.b sndptr+1
	jsl.l SPCUpload
	sep #$20
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY		; NMI and auto joypad read back on
	sta.w NMITIMEN
	rep #$30
	lda.b vcount
	inc a
	inc a
.vb2:		;wait 2 frames
	cmp.b vcount
	bne .vb2
	pla
	plx
	ply
	rtl
SPCGameUpload:		;SNES: wait for the queue and 6 frames, then send the in-game sample set GameSoundUpload ($818000, sndbank 1)
	phy
	phx
	pha
.wq:
	lda.b sndqin
	cmp.b sndqout
	bne .wq
	lda.b vcount
	clc
	adc.w #$0006
.vb:
	cmp.b vcount
	bne .vb
	lda.w #$0001		; sndbank 1, no song
	sta.b sndlock
	sta.w sndbank
	stz.w cursong
	lda.w #GameSoundUpload&$FFFF		; sndptr = GameSoundUpload
	sta.b sndptr
	lda.w #(GameSoundUpload>>8)&$FFFF
	sta.b sndptr+1
	jsl.l SPCUpload
	sep #$20
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	rep #$30
	lda.w #$000A
	sta.w sndsettle
	pla
	plx
	ply
	rtl
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
	bpl .b2
	ldy.w #$0000
	inc.b sndptr+2
	jmp.w .b2
.b2:
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
	bpl .go
	tya
	and.w #$7FFF
	tay
	inc.b sndptr+2
.go:
	sep #$20
	cpx.w #$0001		; APUIO1 = 1 if more data (length > 0)
	lda.b #$00
	rol a
	sta.w APUIO1
	adc.b #$7F
	pla
	sta.w APUIO0
	jmp.w .wait
.wait:
	cmp.w APUIO0
	bne .wait
	bvc .done		; V set: more blocks
	jmp.w .next
.done:		;last block (length 0): the driver runs
	rep #$30
	stz.w APUIO0
	stz.b vbactive
	rtl
QueueSound:		;SNES: queue sound command A (sfx/song number) for the SPC. Dropped while a music cue runs; sounds below $A2 need the in-game set (SPCGameUpload first)
	phx		; cuetimer running: drop it
	ldx.w cuetimer
	bne .ex
	phy
	pha
	ldx.w #$0001
	stx.b sndlock
	cpx.w sndbank		; game set not loaded and a game sound: upload it first
	beq .put
	cmp.w #$00A2
	bcs .put
	jsl.l SPCGameUpload
.put:
	ldx.b sndqin		; sndqueue[sndqin] = A, sndqin = (sndqin + 2) & 15
	pla
	sta.b sndqueue,x
	txa
	inc a
	inc a
	and.w #$000F
	sta.b sndqin
	stz.b sndlock
	ply
.ex:
	plx
	rtl
