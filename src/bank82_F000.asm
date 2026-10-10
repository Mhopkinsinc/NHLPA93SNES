; $82F93C-$82FFFF  ROM $1793C-$17FFF: code after the packed rink tiles. SetPA2, PrintPenaltyMessagesString (penalty93_1), UpdateScores
; (penalty93_2), the 92G password code (BitstoPW, PasstoText, PWtoBits, ClrPassBits, PushBits), asscentero (logic93_3), startpause2,
; and SNES helpers: the SPC700 uploads and the sound queue, muls32, textmap dirty marks, inline string far calls, trampolines.
; Starts after the packed rink tiles (boundary moved from $82F000). Ends with $FF fill.
org $82F93C
SetPA2:		;auto: CODE_82F93C. 93G SetPA2 (penalty93_1): next frame/delay pair of the ref animation from the PenaltyList entry of RefPen. A negative pair is the last one (RefStep = -1). RefCnt =
		;   delay*8, then PushRef
	phx		; $82F93C: DA
	stx.b xsave		; $82F93D: 86 0A
	ldx.w #$0000		; $82F93F: A2 00 00
.pushd:
	lda.b d0,x		; $82F942: B5 53
	pha		; $82F944: 48
	inx		; $82F945: E8
	inx		; $82F946: E8
	cpx.w #$000C		; $82F947: E0 0C 00
	bne .pushd		; $82F94A: D0 F6
	ldx.b xsave		; $82F94C: A6 0A
	stx.b xsave		; $82F94E: 86 0A
	ldx.w #$0000		; $82F950: A2 00 00
.pusha:
	lda.b a0,x		; $82F953: B5 33
	pha		; $82F955: 48
	inx		; $82F956: E8
	inx		; $82F957: E8
	cpx.w #$0008		; $82F958: E0 08 00
	bne .pusha		; $82F95B: D0 F6
	ldx.b xsave		; $82F95D: A6 0A
	lda.w #$0040		; $82F95F: A9 40 00  d0 = $40 (clear the ref window) when RefStep is negative
	sta.b d0		; $82F962: 85 53
	lda.w RefStep		; $82F964: AD EC 12
	bmi .pr		; $82F967: 30 46
	sta.b d0		; $82F969: 85 53
	inc.w RefStep		; $82F96B: EE EC 12
	inc.w RefStep		; $82F96E: EE EC 12
	lda.w RefPen		; $82F971: AD EE 12  PenaltyList entry of RefPen: its animation offset (+2), then the frame/delay word at RefStep
	sta.b d1		; $82F974: 85 57
	tax		; $82F976: AA
	lda.l PenaltyList,x		; $82F977: BF 6A BF 80
	inc a		; $82F97B: 1A
	inc a		; $82F97C: 1A
	tax		; $82F97D: AA
	clc		; $82F97E: 18
	adc.l PenaltyList,x		; $82F97F: 7F 6A BF 80
	adc.b d0		; $82F983: 65 53
	tax		; $82F985: AA
	lda.l PenaltyList,x		; $82F986: BF 6A BF 80
	sta.b d0		; $82F98A: 85 53
	bpl .zero		; $82F98C: 10 0C
	eor.w #$FFFF		; $82F98E: 49 FF FF  negative: last pair, RefStep = -1
	inc a		; $82F991: 1A
	sta.b d0		; $82F992: 85 53
	lda.w #$FFFF		; $82F994: A9 FF FF
	sta.w RefStep		; $82F997: 8D EC 12
.zero:		;93G .0
	lda.b d0		; $82F99A: A5 53  RefCnt = delay * 8, d0 = frame
	and.w #$00FF		; $82F99C: 29 FF 00
	asl a		; $82F99F: 0A
	asl a		; $82F9A0: 0A
	asl a		; $82F9A1: 0A
	sta.b d1		; $82F9A2: 85 57
	sta.w RefCnt		; $82F9A4: 8D EA 12
	lda.b d0		; $82F9A7: A5 53
	xba		; $82F9A9: EB
	and.w #$00FF		; $82F9AA: 29 FF 00
	sta.b d0		; $82F9AD: 85 53
.pr:
	jsl.l $8F83A7		; $82F9AF: 22 A7 83 8F  bank $8F: 93G PushRef
	stx.b xsave		; $82F9B3: 86 0A
	ldx.w #$0006		; $82F9B5: A2 06 00
.popa:
	pla		; $82F9B8: 68
	sta.b a0,x		; $82F9B9: 95 33
	dex		; $82F9BB: CA
	dex		; $82F9BC: CA
	bpl .popa		; $82F9BD: 10 F9
	ldx.b xsave		; $82F9BF: A6 0A
	stx.b xsave		; $82F9C1: 86 0A
	ldx.w #$000A		; $82F9C3: A2 0A 00
.popd:
	pla		; $82F9C6: 68
	sta.b d0,x		; $82F9C7: 95 53
	dex		; $82F9C9: CA
	dex		; $82F9CA: CA
	bpl .popd		; $82F9CB: 10 F9
	ldx.b xsave		; $82F9CD: A6 0A
	plx		; $82F9CF: FA
	rtl		; $82F9D0: 6B
UpdateScores:		;auto: CODE_82F9D1. 93G UpdateScores (penalty93_2): update the ticker scores of the other playoff games (not gamenum, not over)
	jsl.l GetShifter		; $82F9D1: 22 A4 D5 85  GetShifter: d1 = games - 1
	lda.b d1		; $82F9D5: A5 57
	sta.w TickerNum		; $82F9D7: 8D D7 08
	asl a		; $82F9DA: 0A
	sta.b a0		; $82F9DB: 85 33
.top:
	lda.b d1		; $82F9DD: A5 57
	cmp.w gamenum		; $82F9DF: CD 4C 01
	beq .next		; $82F9E2: F0 14
	ldy.b a0		; $82F9E4: A4 33
	lda.w gsflags,y		; $82F9E6: B9 EF 15  clear gsfhl; game not over: SetScore
	and.w #~gsfhl&$FFFF		; $82F9E9: 29 FD FF
	sta.w gsflags,y		; $82F9EC: 99 EF 15
	bit.w #gsfso		; $82F9EF: 89 04 00
	bne .next		; $82F9F2: D0 04
	jsl.l $8AFE21		; $82F9F4: 22 21 FE 8A  bank $8A: 93G SetScore
.next:
	dec.b a0		; $82F9F8: C6 33
	dec.b a0		; $82F9FA: C6 33
	dec.b d1		; $82F9FC: C6 57
	bpl .top		; $82F9FE: 10 DD
	rtl		; $82FA00: 6B
BitstoPW:		;auto: CODE_82FA01. 92G BitstoPW: convert passbits into the 16 password characters (SuperDiv by PWrange)
	ldx.w #$000F		; $82FA01: A2 0F 00
.zero:
	lda.w #PWrange		; $82FA04: A9 1E 00  PassWord[x] = passbits mod PWrange
	sta.b d0		; $82FA07: 85 53
	jsl.l SuperDiv		; $82FA09: 22 FA F5 80
	sep #$20		; $82FA0D: E2 20
	lda.b d0		; $82FA0F: A5 53
	sta.w PassWord,x		; $82FA11: 9D 10 16
	rep #$30		; $82FA14: C2 30
	dex		; $82FA16: CA
	bpl .zero		; $82FA17: 10 EB
	rtl		; $82FA19: 6B
sndqreset:		;auto: CODE_82FA1A. SNES: empty the sound command queue and the music cue
	lda.w #$0001		; $82FA1A: A9 01 00  sndlock while the queue is reset; cuetimer = 0
	sta.b sndlock		; $82FA1D: 85 21
	stz.w cursong		; $82FA1F: 9C 51 16
	stz.w cuetimer		; $82FA22: 9C A9 04
	stz.b sndqueue		; $82FA25: 64 23
	stz.b sndqout		; $82FA27: 64 1F
	lda.w #$0002		; $82FA29: A9 02 00
	sta.b sndqin		; $82FA2C: 85 1D
	stz.b sndlock		; $82FA2E: 64 21
	rtl		; $82FA30: 6B
SPCBootUpload:		;auto: CODE_82FA31. SNES: wait for the queue and a vblank, then send the boot stream at $868000 (driver and its samples, sndbank 2)
	phy		; $82FA31: 5A
	phx		; $82FA32: DA
	pha		; $82FA33: 48
.wait:		;brightness: keep the screen dark unless fully on
	lda.b brightness		; $82FA34: A5 04
	cmp.w #$000F		; $82FA36: C9 0F 00
	beq .wq		; $82FA39: F0 02
	stz.b brightness		; $82FA3B: 64 04
.wq:
	lda.b sndqin		; $82FA3D: A5 1D
	cmp.b sndqout		; $82FA3F: C5 1F
	bne .wait		; $82FA41: D0 F1
	lda.b vcount		; $82FA43: A5 00
.vb:
	cmp.b vcount		; $82FA45: C5 00
	beq .vb		; $82FA47: F0 FC
	lda.w #$0001		; $82FA49: A9 01 00  sndbank 2, no song
	sta.b sndlock		; $82FA4C: 85 21
	lda.w #$0002		; $82FA4E: A9 02 00
	sta.w sndbank		; $82FA51: 8D 4F 16
	stz.w cursong		; $82FA54: 9C 51 16
	lda.w #$8000		; $82FA57: A9 00 80  sndptr = $868000
	sta.b sndptr		; $82FA5A: 85 1A
	lda.w #$8680		; $82FA5C: A9 80 86
	sta.b sndptr+1		; $82FA5F: 85 1B
	jsl.l SPCUpload		; $82FA61: 22 B9 FA 82
	sep #$20		; $82FA65: E2 20
	lda.b #$81		; $82FA67: A9 81  NMI and auto joypad read back on
	sta.w NMITIMEN		; $82FA69: 8D 00 42
	rep #$30		; $82FA6C: C2 30
	lda.b vcount		; $82FA6E: A5 00
	inc a		; $82FA70: 1A
	inc a		; $82FA71: 1A
.vb2:		;wait 2 frames
	cmp.b vcount		; $82FA72: C5 00
	bne .vb2		; $82FA74: D0 FC
	pla		; $82FA76: 68
	plx		; $82FA77: FA
	ply		; $82FA78: 7A
	rtl		; $82FA79: 6B
SPCGameUpload:		;auto: CODE_82FA7A. SNES: wait for the queue and 6 frames, then send the in-game sample set GameSoundUpload ($818000, sndbank 1)
	phy		; $82FA7A: 5A
	phx		; $82FA7B: DA
	pha		; $82FA7C: 48
.wq:
	lda.b sndqin		; $82FA7D: A5 1D
	cmp.b sndqout		; $82FA7F: C5 1F
	bne .wq		; $82FA81: D0 FA
	lda.b vcount		; $82FA83: A5 00
	clc		; $82FA85: 18
	adc.w #$0006		; $82FA86: 69 06 00
.vb:
	cmp.b vcount		; $82FA89: C5 00
	bne .vb		; $82FA8B: D0 FC
	lda.w #$0001		; $82FA8D: A9 01 00  sndbank 1, no song
	sta.b sndlock		; $82FA90: 85 21
	sta.w sndbank		; $82FA92: 8D 4F 16
	stz.w cursong		; $82FA95: 9C 51 16
	lda.w #GameSoundUpload&$FFFF		; $82FA98: A9 00 80  sndptr = GameSoundUpload
	sta.b sndptr		; $82FA9B: 85 1A
	lda.w #(GameSoundUpload>>8)&$FFFF		; $82FA9D: A9 80 81
	sta.b sndptr+1		; $82FAA0: 85 1B
	jsl.l SPCUpload		; $82FAA2: 22 B9 FA 82
	sep #$20		; $82FAA6: E2 20
	lda.b #$81		; $82FAA8: A9 81
	sta.w NMITIMEN		; $82FAAA: 8D 00 42
	rep #$30		; $82FAAD: C2 30
	lda.w #$000A		; $82FAAF: A9 0A 00
	sta.w sndsettle		; $82FAB2: 8D 9F 04
	pla		; $82FAB5: 68
	plx		; $82FAB6: FA
	ply		; $82FAB7: 7A
	rtl		; $82FAB8: 6B
SPCUpload:		;auto: CODE_82FAB9. SNES: send the upload stream at [sndptr] to the SPC700 boot ROM (IPL protocol on APUIO0-3): blocks of length, APU address, data; NMI off while it runs
	stz.w cursong		; $82FAB9: 9C 51 16
	sep #$20		; $82FABC: E2 20
	stz.w NMITIMEN		; $82FABE: 9C 00 42  NMI off; vbactive; queue empty; APUIO0 = $F8
	lda.b #$01		; $82FAC1: A9 01
	sta.b vbactive		; $82FAC3: 85 12
	sta.b sndlock		; $82FAC5: 85 21
	stz.b sndqin		; $82FAC7: 64 1D
	stz.b sndqout		; $82FAC9: 64 1F
	lda.b #$F8		; $82FACB: A9 F8
	sta.w APUIO0		; $82FACD: 8D 40 21
	rep #$30		; $82FAD0: C2 30
	ldy.w #$0000		; $82FAD2: A0 00 00
	lda.w #$BBAA		; $82FAD5: A9 AA BB
	jmp.w .ready		; $82FAD8: 4C DB FA
.ready:		;wait for $BBAA from the IPL
	cmp.w APUIO0		; $82FADB: CD 40 21
	bne .ready		; $82FADE: D0 FB
	lda.w #$00CC		; $82FAE0: A9 CC 00
	bra .header		; $82FAE3: 80 4B
.next:		;next block: first data byte
	sep #$20		; $82FAE5: E2 20
	lda.b [sndptr],y		; $82FAE7: B7 1A
	iny		; $82FAE9: C8
	bpl .first		; $82FAEA: 10 08
	ldy.w #$0000		; $82FAEC: A0 00 00
	inc.b sndptr+2		; $82FAEF: E6 1C
	jmp.w .first		; $82FAF1: 4C F4 FA
.first:
	xba		; $82FAF4: EB
	lda.b #$00		; $82FAF5: A9 00
	bra .send		; $82FAF7: 80 1B
.byte:
	xba		; $82FAF9: EB
	lda.b [sndptr],y		; $82FAFA: B7 1A
	iny		; $82FAFC: C8
	bpl .b2		; $82FAFD: 10 08
	ldy.w #$0000		; $82FAFF: A0 00 00
	inc.b sndptr+2		; $82FB02: E6 1C
	jmp.w .b2		; $82FB04: 4C 07 FB
.b2:
	xba		; $82FB07: EB
	jmp.w .ack		; $82FB08: 4C 0B FB
.ack:
	cmp.w APUIO0		; $82FB0B: CD 40 21
	bne .ack		; $82FB0E: D0 FB
	inc a		; $82FB10: 1A
	jmp.w .send		; $82FB11: 4C 14 FB
.send:		;APUIO0 = index, APUIO1 = data byte
	rep #$30		; $82FB14: C2 30
	sta.w APUIO0		; $82FB16: 8D 40 21
	sep #$20		; $82FB19: E2 20
	dex		; $82FB1B: CA
	bne .byte		; $82FB1C: D0 DB
	jmp.w .endblk		; $82FB1E: 4C 21 FB
.endblk:
	cmp.w APUIO0		; $82FB21: CD 40 21
	bne .endblk		; $82FB24: D0 FB
	jmp.w .inc3		; $82FB26: 4C 29 FB
.inc3:		;next index: +3 (never 0)
	adc.b #$03		; $82FB29: 69 03
	beq .inc3		; $82FB2B: F0 FC
	jmp.w .header		; $82FB2D: 4C 30 FB
.header:		;block header: X = length, APUIO2/3 = APU address; APUIO1 = 1 for a data block, 0 to jump
	sep #$20		; $82FB30: E2 20
	pha		; $82FB32: 48
	rep #$30		; $82FB33: C2 30
	lda.b [sndptr],y		; $82FB35: B7 1A
	tax		; $82FB37: AA
	iny		; $82FB38: C8
	iny		; $82FB39: C8
	bpl .dest		; $82FB3A: 10 07
	tya		; $82FB3C: 98
	and.w #$7FFF		; $82FB3D: 29 FF 7F
	tay		; $82FB40: A8
	inc.b sndptr+2		; $82FB41: E6 1C
.dest:
	lda.b [sndptr],y		; $82FB43: B7 1A
	sta.w APUIO2		; $82FB45: 8D 42 21
	iny		; $82FB48: C8
	iny		; $82FB49: C8
	bpl .go		; $82FB4A: 10 07
	tya		; $82FB4C: 98
	and.w #$7FFF		; $82FB4D: 29 FF 7F
	tay		; $82FB50: A8
	inc.b sndptr+2		; $82FB51: E6 1C
.go:
	sep #$20		; $82FB53: E2 20
	cpx.w #$0001		; $82FB55: E0 01 00  APUIO1 = 1 if more data (length > 0)
	lda.b #$00		; $82FB58: A9 00
	rol a		; $82FB5A: 2A
	sta.w APUIO1		; $82FB5B: 8D 41 21
	adc.b #$7F		; $82FB5E: 69 7F
	pla		; $82FB60: 68
	sta.w APUIO0		; $82FB61: 8D 40 21
	jmp.w .wait		; $82FB64: 4C 67 FB
.wait:
	cmp.w APUIO0		; $82FB67: CD 40 21
	bne .wait		; $82FB6A: D0 FB
	bvc .done		; $82FB6C: 50 03  V set: more blocks
	jmp.w .next		; $82FB6E: 4C E5 FA
.done:		;last block (length 0): the driver runs
	rep #$30		; $82FB71: C2 30
	stz.w APUIO0		; $82FB73: 9C 40 21
	stz.b vbactive		; $82FB76: 64 12
	rtl		; $82FB78: 6B
QueueSound:		;auto: CODE_82FB79. SNES: queue sound command A (sfx/song number) for the SPC. Dropped while a music cue runs; sounds below $A2 need the in-game set (SPCGameUpload first)
	phx		; $82FB79: DA  cuetimer running: drop it
	ldx.w cuetimer		; $82FB7A: AE A9 04
	bne .ex		; $82FB7D: D0 25
	phy		; $82FB7F: 5A
	pha		; $82FB80: 48
	ldx.w #$0001		; $82FB81: A2 01 00
	stx.b sndlock		; $82FB84: 86 21
	cpx.w sndbank		; $82FB86: EC 4F 16  game set not loaded and a game sound: upload it first
	beq .put		; $82FB89: F0 09
	cmp.w #$00A2		; $82FB8B: C9 A2 00
	bcs .put		; $82FB8E: B0 04
	jsl.l SPCGameUpload		; $82FB90: 22 7A FA 82
.put:
	ldx.b sndqin		; $82FB94: A6 1D  sndqueue[sndqin] = A, sndqin = (sndqin + 2) & 15
	pla		; $82FB96: 68
	sta.b sndqueue,x		; $82FB97: 95 23
	txa		; $82FB99: 8A
	inc a		; $82FB9A: 1A
	inc a		; $82FB9B: 1A
	and.w #$000F		; $82FB9C: 29 0F 00
	sta.b sndqin		; $82FB9F: 85 1D
	stz.b sndlock		; $82FBA1: 64 21
	ply		; $82FBA3: 7A
.ex:
	plx		; $82FBA4: FA
	rtl		; $82FBA5: 6B
PasstoText:		;92G PasstoText: characters used in the password text (PWrange = 30, the 31st is the blank)
	db "BCDFGHJKLMNPRSTVWXYZ0123456789-"		; $82FBA6
PWtoBits:		;auto: CODE_82FBC5. 92G PWtoBits: convert the password text into passbits (ClrPassBits, then SuperMult by PWrange and SuperAdd per character)
	jsl.l ClrPassBits		; $82FBC5: 22 EA FB 82
	ldx.w #$0000		; $82FBC9: A2 00 00
.zero:
	lda.w #PWrange		; $82FBCC: A9 1E 00  passbits = passbits * PWrange + PassWord[x]
	sta.b d0		; $82FBCF: 85 53
	jsl.l SuperMult		; $82FBD1: 22 53 88 88  bank $88: 92G SuperMult (passbits *= d0)
	lda.w PassWord,x		; $82FBD5: BD 10 16
	and.w #$00FF		; $82FBD8: 29 FF 00
	sta.b d0		; $82FBDB: 85 53
	stz.b d0+2		; $82FBDD: 64 55
	jsl.l SuperAdd		; $82FBDF: 22 B2 FD 88  bank $88: 92G SuperAdd (passbits += d0)
	inx		; $82FBE3: E8
	cpx.w #pwlength		; $82FBE4: E0 10 00
	bne .zero		; $82FBE7: D0 E3
	rtl		; $82FBE9: 6B
ClrPassBits:		;auto: CODE_82FBEA. 92G ClrPassBits: clear passbits
	stz.w passbits		; $82FBEA: 9C 24 16
	stz.w passbits+2		; $82FBED: 9C 26 16
	stz.w passbits+4		; $82FBF0: 9C 28 16
	stz.w passbits+6		; $82FBF3: 9C 2A 16
	stz.w passbits+8		; $82FBF6: 9C 2C 16
	stz.w passbits+10		; $82FBF9: 9C 2E 16
	stz.w passbits+12		; $82FBFC: 9C 30 16
	stz.w passbits+14		; $82FBFF: 9C 32 16
	rtl		; $82FC02: 6B
PushBits:		;auto: CODE_82FC03. 93G PushBits (hockey93_09, IDA EncodeValueToPassword): passbits = passbits * d1 + d0
	stx.b xsave		; $82FC03: 86 0A
	ldx.w #$0000		; $82FC05: A2 00 00
.push:
	lda.b d0,x		; $82FC08: B5 53
	pha		; $82FC0A: 48
	inx		; $82FC0B: E8
	inx		; $82FC0C: E8
	cpx.w #$0008		; $82FC0D: E0 08 00
	bne .push		; $82FC10: D0 F6
	ldx.b xsave		; $82FC12: A6 0A
	lda.b d0		; $82FC14: A5 53  d0 <-> d1
	ldx.b d1		; $82FC16: A6 57
	sta.b d1		; $82FC18: 85 57
	stx.b d0		; $82FC1A: 86 53
	jsl.l SuperMult		; $82FC1C: 22 53 88 88  bank $88: 92G SuperMult (passbits *= d0)
	stz.b d0+2		; $82FC20: 64 55
	lda.b d1		; $82FC22: A5 57
	sta.b d0		; $82FC24: 85 53
	jsl.l SuperAdd		; $82FC26: 22 B2 FD 88  bank $88: 92G SuperAdd (passbits += d0)
	stx.b xsave		; $82FC2A: 86 0A
	ldx.w #$0006		; $82FC2C: A2 06 00
.pop:
	pla		; $82FC2F: 68
	sta.b d0,x		; $82FC30: 95 53
	dex		; $82FC32: CA
	dex		; $82FC33: CA
	bpl .pop		; $82FC34: 10 F9
	ldx.b xsave		; $82FC36: A6 0A
	rtl		; $82FC38: 6B
BitMaskTable:		;SNES: the 16 bit masks 1 << n (read by the playoff bit code in bank $8B)
	dw $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080		; $82FC39
	dw $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000		; $82FC49
ContinuePlayoffs:		;auto: CODE_82FC59. SNES: after a game: EncodePW and PlayoffScreen; when the playoffs go on with a user game (OptPlayMode 1, gamenum set) DecodePW the new password and maketree
		;   (sf3alttree picks the path); else back to $83FA87
	jsl.l EncodePW		; $82FC59: 22 8D 86 88  bank $88
	jsl.l PlayoffScreen		; $82FC5D: 22 12 F5 88  bank $88: 93G PlayoffScreen (font tile bases, the playoff tree)
	lda.w OptPlayMode		; $82FC61: AD 00 16  not continuing playoffs, or no user game: $83FA87
	cmp.w #$0001		; $82FC64: C9 01 00
	beq .po		; $82FC67: F0 04
	jml.l Restart		; $82FC69: 5C 87 FA 83
.po:
	lda.w gamenum		; $82FC6D: AD 4C 01
	bpl .pw		; $82FC70: 10 04
	jml.l Restart		; $82FC72: 5C 87 FA 83
.pw:
	lda.w PassWord		; $82FC76: AD 10 16  clear bit 7 (hidden) of the first two characters
	and.w #$7F7F		; $82FC79: 29 7F 7F
	sta.w PassWord		; $82FC7C: 8D 10 16
	jsl.l DecodePW		; $82FC7F: 22 EA F5 80
	jsl.l $8D8000		; $82FC83: 22 00 80 8D  bank $8D
	lda.w #sf3alttree		; $82FC87: A9 04 00  sf3alttree: $8B8172 after the font bases
	trb.w sflags3		; $82FC8A: 1C 90 12
	beq .tree		; $82FC8D: F0 04
	jml.l far8B8172		; $82FC8F: 5C F2 F5 80
.tree:
	jml.l $8B8172		; $82FC93: 5C 72 81 8B  bank $8B
far8DF888:		;auto: CODE_82FC97. SNES: save d0-d7 and a0-a6 on the stack and go on at $8DF888 (it pulls them back)
	stx.b xsave		; $82FC97: 86 0A
	ldx.w #$0000		; $82FC99: A2 00 00
.pushd:
	lda.b d0,x		; $82FC9C: B5 53
	pha		; $82FC9E: 48
	inx		; $82FC9F: E8
	inx		; $82FCA0: E8
	cpx.w #$0020		; $82FCA1: E0 20 00
	bne .pushd		; $82FCA4: D0 F6
	ldx.b xsave		; $82FCA6: A6 0A
	stx.b xsave		; $82FCA8: 86 0A
	ldx.w #$0000		; $82FCAA: A2 00 00
.pusha:
	lda.b a0,x		; $82FCAD: B5 33
	pha		; $82FCAF: 48
	inx		; $82FCB0: E8
	inx		; $82FCB1: E8
	cpx.w #$001C		; $82FCB2: E0 1C 00
	bne .pusha		; $82FCB5: D0 F6
	ldx.b xsave		; $82FCB7: A6 0A
	jml.l $8DF888		; $82FCB9: 5C 88 F8 8D  bank $8D (pulls the saved registers)
PixelRemap8D:		;SNES: 4bpp pixel value remap for the $8DEEC8 tiles (setupice via $8FE0E4): colour 0 -> 7, the rest unchanged
	db $07,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F		; $82FCBD
marktextlo:		;auto: CODE_82FCCD. SNES: textdirtylo = min(textdirtylo, A)
	cmp.b textdirtylo		; $82FCCD: C5 D0
	bcs .rtl		; $82FCCF: B0 02
	sta.b textdirtylo		; $82FCD1: 85 D0
.rtl:
	rtl		; $82FCD3: 6B
PixelRemap83:		;SNES: 4bpp pixel value remap for the $83C6D8 tiles (setupice, $83F990, $88F5CF via $8FE0E4). Only colours 0-6 occur: entries 7-15 would read the next bytes (muls32)
	db $04,$03,$04,$03,$02,$01,$04		; $82FCD4
muls32:		;auto: CODE_82FCDB. 68k muls.w with a 32-bit result: A/mulres = low word, mulres+2 = high word of mula*mulb (signs folded around mulu $888942)
	stz.b mulneg		; $82FCDB: 64 98  mulneg = number of negative operands
	lda.b mula		; $82FCDD: A5 7D
	bpl .b		; $82FCDF: 10 08
	eor.w #$FFFF		; $82FCE1: 49 FF FF
	inc a		; $82FCE4: 1A
	sta.b mula		; $82FCE5: 85 7D
	inc.b mulneg		; $82FCE7: E6 98
.b:
	lda.b mulb		; $82FCE9: A5 83
	bpl .mul		; $82FCEB: 10 08
	eor.w #$FFFF		; $82FCED: 49 FF FF
	inc a		; $82FCF0: 1A
	sta.b mulb		; $82FCF1: 85 83
	inc.b mulneg		; $82FCF3: E6 98
.mul:
	jsl.l mulu		; $82FCF5: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lsr.b mulneg		; $82FCF9: 46 98  odd: negate the 32-bit result
	bcc .rtl		; $82FCFB: 90 19
	lda.w #$0000		; $82FCFD: A9 00 00
	sbc.b mulres		; $82FD00: E5 93
	sta.b mula		; $82FD02: 85 7D
	sta.b mulb		; $82FD04: 85 83
	sta.b mulres		; $82FD06: 85 93
	lda.w #$0000		; $82FD08: A9 00 00
	sbc.b mulres+2		; $82FD0B: E5 95
	sta.b mula+2		; $82FD0D: 85 7F
	sta.b mulb+2		; $82FD0F: 85 85
	sta.b mulres+2		; $82FD11: 85 95
	lda.b mulres		; $82FD13: A5 93
	clc		; $82FD15: 18
.rtl:
	rtl		; $82FD16: 6B
addframe_hi:		;auto: CODE_82FD17. SNES addframe path for sprframe >= $293: find the frame set in the table at $8FE67D (sprframe -= set size, sprsetofs += set offset) and draw it ($85FBB9); lower
		;   frames go to $87D1FE
	lda.b sprframe		; $82FD17: A5 C3
	cmp.w #$0293		; $82FD19: C9 93 02
	bcs .hi		; $82FD1C: B0 04
	jml.l addframe_end		; $82FD1E: 5C FE D1 87
.hi:
	dec.b sprframe		; $82FD22: C6 C3
	stz.b sprsetofs		; $82FD24: 64 C5
	ldx.w #$0000		; $82FD26: A2 00 00
	ldy.w #$0002		; $82FD29: A0 02 00
.find:
	lda.l $8FE67D,x		; $82FD2C: BF 7D E6 8F  skip empty table entries
	beq .find		; $82FD30: F0 FA
	sta.b farptr		; $82FD32: 85 0C
	lda.l $8FE67E,x		; $82FD34: BF 7E E6 8F
	sta.b farptr+1		; $82FD38: 85 0D
	lda.b sprframe		; $82FD3A: A5 C3
	sec		; $82FD3C: 38
	sbc.b [farptr]		; $82FD3D: E7 0C
	bcs .next		; $82FD3F: B0 04
	jml.l DrawFrameHi		; $82FD41: 5C B9 FB 85
.next:
	sta.b sprframe		; $82FD45: 85 C3
	lda.b sprsetofs		; $82FD47: A5 C5
	clc		; $82FD49: 18
	adc.b [farptr],y		; $82FD4A: 77 0C
	sta.b sprsetofs		; $82FD4C: 85 C5
	inx		; $82FD4E: E8
	inx		; $82FD4F: E8
	inx		; $82FD50: E8
	inx		; $82FD51: E8
	bra .find		; $82FD52: 80 D8
revplayeracc:		;auto: CODE_82FD54. SNES: playeracc with the direction d2 turned 180 degrees for a reversed player (pfrev)
	lda.w pfrev,x		; $82FD54: BD BF 11
	beq .acc		; $82FD57: F0 07
	lda.b d2		; $82FD59: A5 5B
	eor.w #$0004		; $82FD5B: 49 04 00
	sta.b d2		; $82FD5E: 85 5B
.acc:
	jml.l $8FE164		; $82FD60: 5C 64 E1 8F  bank $8F: 93G playeracc
marktexthi:		;auto: CODE_82FD64. SNES: textdirtyhi = max(textdirtyhi, A)
	cmp.b textdirtyhi		; $82FD64: C5 D2
	bcc .rtl		; $82FD66: 90 02
	sta.b textdirtyhi		; $82FD68: 85 D2
.rtl:
	rtl		; $82FD6A: 6B
ClearTeamStats:		;auto: CODE_82FD6B. SNES: clear the team stats $13B2-$157D except tmgoalie, empty both penalty box lists, then on at $86FC29
	lda.w tmgoalie		; $82FD6B: AD F2 13  keep tmgoalie (2 words)
	pha		; $82FD6E: 48
	lda.w tmgoalie+2		; $82FD6F: AD F4 13
	pha		; $82FD72: 48
	ldx.w #$0000		; $82FD73: A2 00 00
.clr:
	stz.w tmshots,x		; $82FD76: 9E B2 13
	inx		; $82FD79: E8
	inx		; $82FD7A: E8
	cpx.w #$01CC		; $82FD7B: E0 CC 01
	bne .clr		; $82FD7E: D0 F6
	pla		; $82FD80: 68
	sta.w tmgoalie+2		; $82FD81: 8D F4 13
	pla		; $82FD84: 68
	sta.w tmgoalie		; $82FD85: 8D F2 13
	lda.w #$FFFF		; $82FD88: A9 FF FF  both penalty box lists empty
	sta.w tmboxlist		; $82FD8B: 8D 4A 15
	sta.w tmboxlist+$1A		; $82FD8E: 8D 64 15
	jml.l setteams		; $82FD91: 5C 29 FC 86
PrintPenaltyMessagesString:		;auto: CODE_82FD95. 93G PrintPenaltyMessagesString (penalty93_1): blank the horizontal mode penalty message line (22 spaces at x 5, y $B)
	jsl.l printz		; $82FD95: 22 0C B9 80
	dw $001B		; $82FD99  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0B,"                      "
	rtl		; $82FDB4: 6B
startpause2:		;auto: CODE_82FDB5. 93G startpause2 (hockey93_01): pause started by controller 2 (sflags bit 1), then startpause
	lda.w #sfpj		; $82FDB5: A9 02 00
	tsb.w sflags		; $82FDB8: 0C 8C 12
	jml.l startpause		; $82FDBB: 5C E1 F3 80
printz8B:		;auto: CODE_82FDBF. SNES: printz-style call with an inline string (length word counting itself): step the return address past it and go to the bank $8B printer $8BFCCE
	lda.b $03,s		; $82FDBF: A3 03  farptr-style: a1 = the inline string after the caller
	sta.b a1+2		; $82FDC1: 85 39
	lda.b $01,s		; $82FDC3: A3 01
	inc a		; $82FDC5: 1A
	sta.b a1		; $82FDC6: 85 37
	lda.b [a1]		; $82FDC8: A7 37
	clc		; $82FDCA: 18
	adc.b $01,s		; $82FDCB: 63 01
	sta.b $01,s		; $82FDCD: 83 01
	jml.l $8BFCCE		; $82FDCF: 5C CE FC 8B  bank $8B: print the inline string
appendz:		;auto: CODE_82FDD3. SNES: like printz8B, for appstring $8F87C9 (append an inline string)
	lda.b $03,s		; $82FDD3: A3 03
	sta.b a1+2		; $82FDD5: 85 39
	lda.b $01,s		; $82FDD7: A3 01
	inc a		; $82FDD9: 1A
	sta.b a1		; $82FDDA: 85 37
	lda.b [a1]		; $82FDDC: A7 37
	clc		; $82FDDE: 18
	adc.b $01,s		; $82FDDF: 63 01
	sta.b $01,s		; $82FDE1: 83 01
	jml.l $8F87C9		; $82FDE3: 5C C9 87 8F  bank $8F: appstring
asscentero:		;auto: CODE_82FDE7 (asstab 6). 93G asscentero (logic93_3): player X is the center on offense. Every aidef frames: acenterd when the other team has the puck, else a random spot in the
		;   zone of the puck (.dedata), skateto with EvadePC
	lda.w pfalock,x		; $82FDE7: BD 7F 11  anim locked: nothing
	beq .clk		; $82FDEA: F0 03
	jmp.w .rtl		; $82FDEC: 4C 15 FF
.clk:
	lda.w gmclock		; $82FDEF: AD 8A 12  clock stopped: assnothing
	beq .go		; $82FDF2: F0 04
	jml.l $8FD75A		; $82FDF4: 5C 5A D7 8F  bank $8F: 93G assnothing
.go:
	jsl.l check4bench		; $82FDF8: 22 27 85 80
	lda.w pflags,x		; $82FDFC: BD DF 0E  joystick controlled: nothing
	bit.w #pfjoycon		; $82FDFF: 89 08 00
	beq .na		; $82FE02: F0 03
	jmp.w .rtl		; $82FE04: 4C 15 FF
.na:
	bit.w #pfna		; $82FE07: 89 02 00  new assignment: temp5 = -1 (old zone), temp1 = 0, temp2 = 8
	beq .nna		; $82FE0A: F0 18
	and.w #~pfna&$FFFF		; $82FE0C: 29 FD FF
	sta.w pflags,x		; $82FE0F: 9D DF 0E
	lda.w #$FFFF		; $82FE12: A9 FF FF
	sta.w temp5,x		; $82FE15: 9D DF 0C
	stz.w temp1,x		; $82FE18: 9E 5F 0C
	stz.w temp2,x		; $82FE1B: 9E 7F 0C
	lda.w #$0008		; $82FE1E: A9 08 00
	sta.w temp2b,x		; $82FE21: 9D FF 0C
.nna:
	lda.w temp1,x		; $82FE24: BD 5F 0C  every aidef frames
	sec		; $82FE27: 38
	sbc.b d7		; $82FE28: E5 6F
	sta.w temp1,x		; $82FE2A: 9D 5F 0C
	bmi .dec		; $82FE2D: 30 03
	jmp.w .nodec		; $82FE2F: 4C F0 FE
.dec:
	clc		; $82FE32: 18
	adc.w aidef,x		; $82FE33: 7D BF 0F
	bpl .st		; $82FE36: 10 03
	lda.w #$0000		; $82FE38: A9 00 00
.st:
	sta.w temp1,x		; $82FE3B: 9D 5F 0C
	lda.w puckc		; $82FE3E: AD BB 0E  other team has the puck: acenterd
	bmi .de0		; $82FE41: 30 18
	sec		; $82FE43: 38
	sbc.w #$0006		; $82FE44: E9 06 00
	sta.b d1		; $82FE47: 85 57
	lda.w #acenterd		; $82FE49: A9 05 00
	sta.b d0		; $82FE4C: 85 53
	txa		; $82FE4E: 8A
	sec		; $82FE4F: 38
	sbc.w #$000C		; $82FE50: E9 0C 00
	eor.b d1		; $82FE53: 45 57
	bpl .de0		; $82FE55: 10 04
	jml.l assreplace		; $82FE57: 5C A7 B4 80
.de0:
	lda.w pucky		; $82FE5B: AD 7B 09  d0 = pucky toward the attacking end
	sta.b d0		; $82FE5E: 85 53
	lda.w pfgoal,x		; $82FE60: BD 3F 11
	bne .de1		; $82FE63: D0 08
	lda.b d0		; $82FE65: A5 53
	eor.w #$FFFF		; $82FE67: 49 FF FF
	inc a		; $82FE6A: 1A
	sta.b d0		; $82FE6B: 85 53
.de1:		;zone number
	stz.b d2		; $82FE6D: 64 5B
	lda.b d0		; $82FE6F: A5 53
	sec		; $82FE71: 38
	sbc.w #$FFA8		; $82FE72: E9 A8 FF
	bmi .v1		; $82FE75: 30 04
	bvc .z1		; $82FE77: 50 04
	bra .de2		; $82FE79: 80 34
.v1:
	bvc .de2		; $82FE7B: 50 32
.z1:
	lda.w #$0008		; $82FE7D: A9 08 00
	sta.b d2		; $82FE80: 85 5B
	lda.b d0		; $82FE82: A5 53
	sec		; $82FE84: 38
	sbc.w #$0058		; $82FE85: E9 58 00
	bmi .v2		; $82FE88: 30 04
	bvc .z2		; $82FE8A: 50 04
	bra .de2		; $82FE8C: 80 21
.v2:
	bvc .de2		; $82FE8E: 50 1F
.z2:
	ldy.b a2		; $82FE90: A4 3B  tmflags bit 4: stay in the middle zone
	lda.w tmflags,y		; $82FE92: B9 0A 14
	bit.w #$0010		; $82FE95: 89 10 00
	bne .de2		; $82FE98: D0 15
	asl.b d2		; $82FE9A: 06 5B
	lda.b d0		; $82FE9C: A5 53
	sec		; $82FE9E: 38
	sbc.w #$0108		; $82FE9F: E9 08 01
	bmi .v3		; $82FEA2: 30 04
	bvc .z3		; $82FEA4: 50 04
	bra .de2		; $82FEA6: 80 07
.v3:
	bvc .de2		; $82FEA8: 50 05
.z3:
	lda.w #$0018		; $82FEAA: A9 18 00
	sta.b d2		; $82FEAD: 85 5B
.de2:
	lda.b d2		; $82FEAF: A5 5B  same zone: new spot only 1 in 128
	cmp.w temp5,x		; $82FEB1: DD DF 0C
	bne .de3		; $82FEB4: D0 08
	lda.w seed+2		; $82FEB6: AD A3 04
	cmp.w #$0200		; $82FEB9: C9 00 02
	bcs .nodec		; $82FEBC: B0 32
.de3:
	lda.b d2		; $82FEBE: A5 5B
	sta.w temp5,x		; $82FEC0: 9D DF 0C
	tay		; $82FEC3: A8
	lda.w #.dedata		; $82FEC4: A9 16 FF  temp3/temp4 = .dedata spot + randomd0s of the range
	sta.b a0		; $82FEC7: 85 33
	lda.w #.dedata>>16		; $82FEC9: A9 82 00
	sta.b a0+2		; $82FECC: 85 35
	iny		; $82FECE: C8
	iny		; $82FECF: C8
	lda.b [a0],y		; $82FED0: B7 33
	dey		; $82FED2: 88
	dey		; $82FED3: 88
	jsl.l randomd0s		; $82FED4: 22 A1 F6 80
	adc.b [a0],y		; $82FED8: 77 33
	sta.w temp3,x		; $82FEDA: 9D 9F 0C
	iny		; $82FEDD: C8
	iny		; $82FEDE: C8
	iny		; $82FEDF: C8
	iny		; $82FEE0: C8
	iny		; $82FEE1: C8
	iny		; $82FEE2: C8
	lda.b [a0],y		; $82FEE3: B7 33
	dey		; $82FEE5: 88
	dey		; $82FEE6: 88
	jsl.l randomd0s		; $82FEE7: 22 A1 F6 80
	adc.b [a0],y		; $82FEEB: 77 33
	sta.w temp4,x		; $82FEED: 9D BF 0C
.nodec:
	lda.w temp3,x		; $82FEF0: BD 9F 0C
	sta.b d0		; $82FEF3: 85 53
	lda.w temp4,x		; $82FEF5: BD BF 0C
	sta.b d1		; $82FEF8: 85 57
	lda.w pfgoal,x		; $82FEFA: BD 3F 11
	bne .zero		; $82FEFD: D0 08
	lda.b d1		; $82FEFF: A5 57
	eor.w #$FFFF		; $82FF01: 49 FF FF
	inc a		; $82FF04: 1A
	sta.b d1		; $82FF05: 85 57
.zero:		;93G .0
	lda.w #EvadePC		; $82FF07: A9 6A FD  skateto with the EvadePC callback
	sta.b a0		; $82FF0A: 85 33
	lda.w #EvadePC>>16		; $82FF0C: A9 89 00
	sta.b a0+2		; $82FF0F: 85 35
	jml.l skateto		; $82FF11: 5C D0 FD 88  bank $88: 93G skateto (d0/d1 = target, a0 = callback; $89FD6A = 93G EvadePC)
.rtl:
	rtl		; $82FF15: 6B
.dedata:		;IDA unk_B14E: per zone (x, random x range, y, random y range)
	dw 0,60,-70,10		; $82FF16 zone 0
	dw 0,60,60,10		; $82FF1E zone 1
	dw 0,40,170,30		; $82FF26 zone 2
	dw 0,80,170,20		; $82FF2E zone 3
unusedFF82:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF36
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF46
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF56
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF66
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF76
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF86
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FF96
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FFA6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FFB6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FFC6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FFD6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FFE6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $82FFF6
