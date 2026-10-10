; $82F93C-$82FFFF  ROM $1793C-$17FFF: code after the packed rink tiles. SetPA2, PrintPenaltyMessagesString (penalty93_1), UpdateScores
; (penalty93_2), the 92G password code (BitstoPW, PasstoText, PWtoBits, ClrPassBits, PushBits), asscentero (logic93_3), startpause2,
; and SNES helpers: the SPC700 uploads and the sound queue, muls32, textmap dirty marks, inline string far calls, trampolines.
; Starts after the packed rink tiles (boundary moved from $82F000). Ends with $FF fill.
org $82F93C
SetPA2:		;93G SetPA2 (penalty93_1): next frame/delay pair of the ref animation from the PenaltyList entry of RefPen. A negative pair is the last one (RefStep = -1). RefCnt =
		;   delay*8, then PushRef
	phx
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.w #$0040		; d0 = $40 (clear the ref window) when RefStep is negative
	sta.b d0
	lda.w RefStep
	bmi .pr
	sta.b d0
	inc.w RefStep
	inc.w RefStep
	lda.w RefPen		; PenaltyList entry of RefPen: its animation offset (+2), then the frame/delay word at RefStep
	sta.b d1
	tax
	lda.l PenaltyList,x
	inc a
	inc a
	tax
	clc
	adc.l PenaltyList,x
	adc.b d0
	tax
	lda.l PenaltyList,x
	sta.b d0
	bpl .zero
	eor.w #$FFFF		; negative: last pair, RefStep = -1
	inc a
	sta.b d0
	lda.w #$FFFF
	sta.w RefStep
.zero:		;93G .0
	lda.b d0		; RefCnt = delay * 8, d0 = frame
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d1
	sta.w RefCnt
	lda.b d0
	xba
	and.w #$00FF
	sta.b d0
.pr:
	jsl.l PushRef		; bank $8F: 93G PushRef
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	plx
	rtl
UpdateScores:		;93G UpdateScores (penalty93_2): update the ticker scores of the other playoff games (not gamenum, not over)
	jsl.l GetShifter		; GetShifter: d1 = games - 1
	lda.b d1
	sta.w TickerNum
	asl a
	sta.b a0
.top:
	lda.b d1
	cmp.w gamenum
	beq .next
	ldy.b a0
	lda.w gsflags,y		; clear gsfhl; game not over: SetScore
	and.w #~gsfhl&$FFFF
	sta.w gsflags,y
	bit.w #gsfso
	bne .next
	jsl.l SetScore		; bank $8A: 93G SetScore
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
	rtl
BitstoPW:		;92G BitstoPW: convert passbits into the 16 password characters (SuperDiv by PWrange)
	ldx.w #$000F
.zero:
	lda.w #PWrange		; PassWord[x] = passbits mod PWrange
	sta.b d0
	jsl.l SuperDiv
	sep #$20
	lda.b d0
	sta.w PassWord,x
	rep #$30
	dex
	bpl .zero
	rtl
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
PasstoText:		;92G PasstoText: characters used in the password text (PWrange = 30, the 31st is the blank)
	db "BCDFGHJKLMNPRSTVWXYZ0123456789-"
PWtoBits:		;92G PWtoBits: convert the password text into passbits (ClrPassBits, then SuperMult by PWrange and SuperAdd per character)
	jsl.l ClrPassBits
	ldx.w #$0000
.zero:
	lda.w #PWrange		; passbits = passbits * PWrange + PassWord[x]
	sta.b d0
	jsl.l SuperMult		; bank $88: 92G SuperMult (passbits *= d0)
	lda.w PassWord,x
	and.w #$00FF
	sta.b d0
	stz.b d0+2
	jsl.l SuperAdd		; bank $88: 92G SuperAdd (passbits += d0)
	inx
	cpx.w #pwlength
	bne .zero
	rtl
ClrPassBits:		;92G ClrPassBits: clear passbits
	stz.w passbits
	stz.w passbits+2
	stz.w passbits+4
	stz.w passbits+6
	stz.w passbits+8
	stz.w passbits+10
	stz.w passbits+12
	stz.w passbits+14
	rtl
PushBits:		;93G PushBits (hockey93_09, IDA EncodeValueToPassword): passbits = passbits * d1 + d0
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	lda.b d0		; d0 <-> d1
	ldx.b d1
	sta.b d1
	stx.b d0
	jsl.l SuperMult		; bank $88: 92G SuperMult (passbits *= d0)
	stz.b d0+2
	lda.b d1
	sta.b d0
	jsl.l SuperAdd		; bank $88: 92G SuperAdd (passbits += d0)
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
BitMaskTable:		;SNES: the 16 bit masks 1 << n (read by the playoff bit code in bank $8B)
	dw $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
	dw $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000
ContinuePlayoffs:		;SNES: after a game: EncodePW and PlayoffScreen; when the playoffs go on with a user game (OptPlayMode 1, gamenum set) DecodePW the new password and maketree
		;   (sf3alttree picks the path); else back to $83FA87
	jsl.l EncodePW		; bank $88
	jsl.l PlayoffScreen		; bank $88: 93G PlayoffScreen (font tile bases, the playoff tree)
	lda.w OptPlayMode		; not continuing playoffs, or no user game: $83FA87
	cmp.w #$0001
	beq .po
	jml.l Restart
.po:
	lda.w gamenum
	bpl .pw
	jml.l Restart
.pw:
	lda.w PassWord		; clear bit 7 (hidden) of the first two characters
	and.w #$7F7F
	sta.w PassWord
	jsl.l DecodePW
	jsl.l maketree		; bank $8D
	lda.w #sf3alttree		; sf3alttree: $8B8172 after the font bases
	trb.w sflags3
	beq .tree
	jml.l far8B8172
.tree:
	jml.l Opening4		; bank $8B
far8DF888:		;SNES: save d0-d7 and a0-a6 on the stack and go on at $8DF888 (it pulls them back)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pusha
	ldx.b xsave
	jml.l StartHL2		; bank $8D (pulls the saved registers)
PixelRemap8D:		;SNES: 4bpp pixel value remap for BigFontTiles (setupice via $8FE0E4): colour 0 -> 7, the rest unchanged
	db $07,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
marktextlo:		;SNES: textdirtylo = min(textdirtylo, A)
	cmp.b textdirtylo
	bcs .rtl
	sta.b textdirtylo
.rtl:
	rtl
PixelRemap83:		;SNES: 4bpp pixel value remap for SmallFontTiles (setupice, $83F990, PlayoffScreen via $8FE0E4). Only colours 0-6 occur: entries 7-15 would read the next bytes (muls32)
	db $04,$03,$04,$03,$02,$01,$04
muls32:		;68k muls.w with a 32-bit result: A/mulres = low word, mulres+2 = high word of mula*mulb (signs folded around mulu $888942)
	stz.b mulneg		; mulneg = number of negative operands
	lda.b mula
	bpl .b
	eor.w #$FFFF
	inc a
	sta.b mula
	inc.b mulneg
.b:
	lda.b mulb
	bpl .mul
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mulneg
.mul:
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lsr.b mulneg		; odd: negate the 32-bit result
	bcc .rtl
	lda.w #$0000
	sbc.b mulres
	sta.b mula
	sta.b mulb
	sta.b mulres
	lda.w #$0000
	sbc.b mulres+2
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.b mulres
	clc
.rtl:
	rtl
addframe_hi:		;SNES addframe path for sprframe >= $293: find the frame set in the table at $8FE67D (sprframe -= set size, sprsetofs += set offset) and draw it ($85FBB9); lower
		;   frames go to $87D1FE
	lda.b sprframe
	cmp.w #$0293
	bcs .hi
	jml.l addframe_end
.hi:
	dec.b sprframe
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.find:
	lda.l FrameSetTable,x		; skip empty table entries
	beq .find
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .next
	jml.l DrawFrameHi
.next:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .find
revplayeracc:		;SNES: playeracc with the direction d2 turned 180 degrees for a reversed player (pfrev)
	lda.w pfrev,x
	beq .acc
	lda.b d2
	eor.w #$0004
	sta.b d2
.acc:
	jml.l playeracc		; bank $8F: 93G playeracc
marktexthi:		;SNES: textdirtyhi = max(textdirtyhi, A)
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
ClearTeamStats:		;SNES: clear the team stats $13B2-$157D except tmgoalie, empty both penalty box lists, then on at $86FC29
	lda.w tmgoalie		; keep tmgoalie (2 words)
	pha
	lda.w tmgoalie+2
	pha
	ldx.w #$0000
.clr:
	stz.w tmshots,x
	inx
	inx
	cpx.w #$01CC
	bne .clr
	pla
	sta.w tmgoalie+2
	pla
	sta.w tmgoalie
	lda.w #$FFFF		; both penalty box lists empty
	sta.w tmboxlist
	sta.w tmboxlist+$1A
	jml.l setteams
PrintPenaltyMessagesString:		;93G PrintPenaltyMessagesString (penalty93_1): blank the horizontal mode penalty message line (22 spaces at x 5, y $B)
	jsl.l printz
	dw $001B		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0B,"                      "
	rtl
startpause2:		;93G startpause2 (hockey93_01): pause started by controller 2 (sflags bit 1), then startpause
	lda.w #sfpj
	tsb.w sflags
	jml.l startpause
printz8B:		;SNES: printz-style call with an inline string (length word counting itself): step the return address past it and go to the bank $8B printer $8BFCCE
	lda.b $03,s		; farptr-style: a1 = the inline string after the caller
	sta.b a1+2
	lda.b $01,s
	inc a
	sta.b a1
	lda.b [a1]
	clc
	adc.b $01,s
	sta.b $01,s
	jml.l printbig		; bank $8B: print the inline string
appendz:		;SNES: like printz8B, for appstring $8F87C9 (append an inline string)
	lda.b $03,s
	sta.b a1+2
	lda.b $01,s
	inc a
	sta.b a1
	lda.b [a1]
	clc
	adc.b $01,s
	sta.b $01,s
	jml.l appstring		; bank $8F: appstring
asscentero:		;asstab 6. 93G asscentero (logic93_3): player X is the center on offense. Every aidef frames: acenterd when the other team has the puck, else a random spot in the
		;   zone of the puck (.dedata), skateto with EvadePC
	lda.w pfalock,x		; anim locked: nothing
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock		; clock stopped: assnothing
	beq .go
	jml.l assnothing		; bank $8F: 93G assnothing
.go:
	jsl.l check4bench
	lda.w pflags,x		; joystick controlled: nothing
	bit.w #pfjoycon
	beq .na
	jmp.w .rtl
.na:
	bit.w #pfna		; new assignment: temp5 = -1 (old zone), temp1 = 0, temp2 = 8
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	lda.w #$FFFF
	sta.w temp5,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w temp1,x		; every aidef frames
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	clc
	adc.w aidef,x
	bpl .st
	lda.w #$0000
.st:
	sta.w temp1,x
	lda.w puckc		; other team has the puck: acenterd
	bmi .de0
	sec
	sbc.w #$0006
	sta.b d1
	lda.w #acenterd
	sta.b d0
	txa
	sec
	sbc.w #$000C
	eor.b d1
	bpl .de0
	jml.l assreplace
.de0:
	lda.w pucky		; d0 = pucky toward the attacking end
	sta.b d0
	lda.w pfgoal,x
	bne .de1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.de1:		;zone number
	stz.b d2
	lda.b d0
	sec
	sbc.w #$FFA8
	bmi .v1
	bvc .z1
	bra .de2
.v1:
	bvc .de2
.z1:
	lda.w #$0008
	sta.b d2
	lda.b d0
	sec
	sbc.w #$0058
	bmi .v2
	bvc .z2
	bra .de2
.v2:
	bvc .de2
.z2:
	ldy.b a2		; tmflags bit 4: stay in the middle zone
	lda.w tmflags,y
	bit.w #$0010
	bne .de2
	asl.b d2
	lda.b d0
	sec
	sbc.w #$0108
	bmi .v3
	bvc .z3
	bra .de2
.v3:
	bvc .de2
.z3:
	lda.w #$0018
	sta.b d2
.de2:
	lda.b d2		; same zone: new spot only 1 in 128
	cmp.w temp5,x
	bne .de3
	lda.w seed+2
	cmp.w #$0200
	bcs .nodec
.de3:
	lda.b d2
	sta.w temp5,x
	tay
	lda.w #.dedata		; temp3/temp4 = .dedata spot + randomd0s of the range
	sta.b a0
	lda.w #.dedata>>16
	sta.b a0+2
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp3,x
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp4,x
.nodec:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w pfgoal,x
	bne .zero
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.zero:		;93G .0
	lda.w #EvadePC		; skateto with the EvadePC callback
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jml.l skateto		; bank $88: 93G skateto (d0/d1 = target, a0 = callback; $89FD6A = 93G EvadePC)
.rtl:
	rtl
.dedata:		;IDA unk_B14E: per zone (x, random x range, y, random y range)
	dw 0,60,-70,10		; zone 0
	dw 0,60,60,10		; zone 1
	dw 0,40,170,30		; zone 2
	dw 0,80,170,20		; zone 3
unusedFF82:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
