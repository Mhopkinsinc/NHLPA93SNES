; $80ED38-$80FFFF  ROM $06D38-$07FFF: the packed block at $80ED38, adda43 (hockey93_02), setlccords, startpause, ReadPads,
; asspuckc (logic93_3), SuperDiv, randomd0s, assgoalie, ClampYPosition, AdjustFacingDirection, GoalieSaveList (logic93_3),
; checkgoalp_CalcGoalShotDir, CalcAngleOffset (logic93_1), reenergizeteam (penalty93_2), the internal header and the vectors.
; Starts at the packed block (boundary moved from $80F008).
org $80ED38
PackedScreenData:		;packed data (1590 bytes, $80ED38-$80F36D) for the decompressor at $86FA3E: bank $8F ($8FDD22) unpacks it to $7F0000 and sends the colors from $7F0090 to CGRAM. Stream of control bytes: $00-$1F literal run, $2x zero fill, $3x byte fill, $40-$7F/$8x-$Bx/$C0-$DF/$Ex/$Fx copies from the output, $E0 $00 = end
	db $20,$09,$0C,$01,$0C,$02,$0C,$03,$0C,$04,$0C,$05,$DD,$0A,$06,$0C		; $80ED38
	db $07,$0C,$08,$0C,$09,$0C,$0A,$0C,$0B,$30,$0C,$02,$0D,$0C,$0E,$80		; $80ED48
	db $10,$0A,$0F,$0C,$10,$0C,$11,$0C,$12,$0C,$13,$0C,$14,$82,$10,$0A		; $80ED58
	db $15,$0C,$16,$0C,$17,$0C,$18,$0C,$19,$0C,$1A,$82,$10,$0A,$1B,$0C		; $80ED68
	db $1C,$0C,$1D,$0C,$1E,$0C,$1F,$0C,$20,$82,$10,$0A,$21,$0C,$22,$0C		; $80ED78
	db $23,$0C,$24,$0C,$25,$0C,$26,$80,$10,$1A,$27,$0C,$28,$0C,$29,$0C		; $80ED88
	db $2A,$0C,$2B,$0C,$2C,$0C,$2D,$0C,$2E,$0C,$2F,$0C,$30,$0C,$31,$0C		; $80ED98
	db $32,$0C,$33,$0C,$34,$DD,$0C,$35,$0C,$36,$0C,$37,$0C,$38,$0C,$39		; $80EDA8
	db $0C,$3A,$0C,$3B,$DD,$05,$3C,$0C,$F2,$7F,$E4,$7F,$21,$0F,$84,$10		; $80EDB8
	db $29,$25,$AD,$35,$52,$4A,$D6,$5A,$7B,$6F,$FF,$7F,$FF,$03,$20,$00		; $80EDC8
	db $7C,$20,$00,$6C,$20,$00,$58,$20,$00,$48,$20,$0E,$34,$F2,$7F,$7B		; $80EDD8
	db $6F,$52,$4A,$29,$25,$84,$10,$5B,$02,$B6,$01,$21,$00,$84,$80,$14		; $80EDE8
	db $02,$24,$01,$80,$20,$02,$36,$01,$0D,$20,$0D,$B6,$35,$2D,$11,$F2		; $80EDF8
	db $7F,$FF,$7F,$D6,$5A,$52,$4A,$AD,$35,$81,$24,$21,$01,$84,$34,$20		; $80EE08
	db $0A,$24,$80,$24,$4D,$5A,$CD,$6E,$6D,$7F,$3F,$25,$20,$01,$10,$F2		; $80EE18
	db $80,$5E,$81,$5C,$83,$5A,$02,$20,$49,$09,$20,$00,$0D,$20,$00,$12		; $80EE28
	db $20,$00,$96,$20,$08,$3B,$11,$5B,$36,$DF,$4A,$7F,$5B,$ED,$80,$20		; $80EE38
	db $9C,$80,$BB,$BF,$20,$06,$FF,$7F,$80,$40,$80,$5F,$9F,$4E,$00,$FF		; $80EE48
	db $20,$8B,$02,$50,$59,$61,$47,$9B,$1F,$05,$FE,$FC,$F8,$F0,$E2,$C1		; $80EE58
	db $87,$1A,$05,$FC,$01,$F0,$07,$C0,$1E,$84,$20,$07,$C0,$C0,$39,$38		; $80EE68
	db $FF,$8A,$8C,$38,$DD,$4A,$00,$C0,$21,$00,$06,$21,$01,$70,$03,$20		; $80EE78
	db $00,$3F,$84,$20,$05,$3F,$CF,$03,$BB,$03,$7F,$86,$3C,$E0,$17,$02		; $80EE88
	db $F0,$03,$C4,$20,$00,$80,$E4,$59,$86,$80,$01,$1F,$5F,$8B,$7E,$07		; $80EE98
	db $1F,$A0,$01,$FE,$FD,$02,$05,$06,$CC,$4E,$00,$FE,$20,$00,$FC,$20		; $80EEA8
	db $00,$F8,$88,$02,$87,$DA,$8F,$E0,$E6,$C8,$02,$FE,$FE,$FC,$4A,$03		; $80EEB8
	db $FF,$F8,$FF,$F0,$81,$14,$80,$44,$00,$01,$4A,$00,$F8,$20,$00,$F0		; $80EEC8
	db $20,$02,$C4,$83,$87,$20,$00,$07,$20,$00,$3E,$20,$09,$E5,$03,$C6		; $80EED8
	db $20,$BF,$20,$30,$4F,$80,$3C,$20,$00,$7F,$80,$57,$00,$C1,$20,$07		; $80EEE8
	db $1F,$1F,$3F,$1F,$7F,$3F,$FF,$EC,$20,$00,$5F,$20,$04,$82,$01,$98		; $80EEF8
	db $78,$07,$80,$38,$02,$F2,$3F,$63,$60,$00,$F3,$20,$00,$A0,$20,$01		; $80EF08
	db $7F,$07,$33,$FF,$03,$F3,$FF,$E3,$0E,$20,$04,$10,$09,$01,$01,$F4		; $80EF18
	db $20,$07,$FA,$04,$85,$7A,$05,$FA,$FB,$FC,$20,$02,$FF,$06,$FF,$E3		; $80EF28
	db $6F,$44,$1C,$9F,$07,$5F,$03,$07,$9B,$B7,$89,$1B,$45,$5B,$64,$9F		; $80EF38
	db $20,$AD,$22,$07,$60,$03,$A0,$03,$E0,$01,$C0,$81,$E0,$80,$E0,$C0		; $80EF48
	db $48,$00,$F0,$3C,$FF,$00,$7F,$8B,$BE,$00,$7F,$20,$87,$FA,$4C,$89		; $80EF58
	db $FC,$4A,$80,$D2,$8A,$02,$00,$F0,$80,$D4,$89,$02,$00,$3F,$20,$02		; $80EF68
	db $9F,$40,$5F,$80,$C4,$0A,$5E,$01,$1F,$40,$59,$46,$7C,$47,$7F,$FF		; $80EF78
	db $3F,$89,$02,$03,$FC,$C0,$FF,$80,$80,$74,$04,$FC,$03,$31,$CF,$8F		; $80EF88
	db $DC,$01,$7F,$FF,$E0,$0D,$3B,$FF,$0A,$F3,$FC,$8F,$70,$F8,$07,$02		; $80EF98
	db $FF,$E6,$FF,$0C,$E0,$D5,$00,$C0,$20,$36,$FF,$02,$E7,$FF,$0F,$72		; $80EFA8
	db $00,$DF,$20,$00,$D7,$49,$02,$57,$80,$97,$20,$02,$87,$10,$CF,$CC		; $80EFB8
	db $04,$08,$E0,$F0,$E0,$F8,$4E,$00,$F0,$49,$80,$D2,$8A,$73,$00,$7F		; $80EFC8
	db $80,$D4,$00,$3F,$88,$02,$85,$B8,$03,$F9,$FC,$F8,$FD,$C8,$40,$84		; $80EFD8
	db $B8,$01,$06,$FA,$48,$00,$07,$4A,$00,$B0,$20,$17,$A4,$08,$B6,$18		; $80EFE8
	db $ED,$86,$70,$04,$B0,$80,$7F,$C0,$BF,$CF,$7F,$FF,$70,$FF,$67,$FF		; $80EFF8
	db $78,$FE,$FA,$FD,$83,$57,$02,$7E,$60,$46,$20,$17,$25,$42,$F5,$02		; $80F008
	db $95,$02,$C5,$12,$95,$12,$F5,$12,$FF,$FF,$1F,$BF,$8F,$DF,$0F,$1F		; $80F018
	db $2F,$5D,$EF,$FD,$4A,$0A,$2F,$30,$E8,$C0,$55,$06,$5E,$21,$46,$31		; $80F028
	db $66,$20,$05,$32,$02,$8F,$30,$C0,$FF,$20,$09,$F7,$83,$EF,$80,$E1		; $80F038
	db $91,$EA,$DF,$FF,$FD,$30,$FF,$02,$1F,$08,$93,$20,$00,$63,$20,$11		; $80F048
	db $E0,$80,$22,$80,$60,$06,$A2,$46,$4A,$EE,$F0,$F8,$78,$FC,$B8,$FC		; $80F058
	db $79,$FF,$48,$00,$F9,$49,$01,$F1,$FF,$E5,$B6,$C0,$40,$01,$BF,$BF		; $80F068
	db $D9,$E3,$BA,$00,$80,$4A,$00,$3F,$E0,$90,$01,$FE,$FC,$48,$02,$FF		; $80F078
	db $FD,$FC,$C4,$30,$FE,$32,$FF,$00,$03,$4D,$01,$01,$FE,$C4,$20,$48		; $80F088
	db $11,$38,$4F,$90,$4F,$1C,$C7,$09,$C6,$2C,$62,$25,$61,$B2,$F3,$BB		; $80F098
	db $9B,$BF,$F8,$49,$19,$FC,$BF,$FF,$9F,$FF,$9E,$FF,$0C,$FF,$84,$7F		; $80F0A8
	db $64,$C3,$68,$C7,$B5,$8E,$C8,$98,$83,$08,$B5,$86,$A4,$99,$5F,$20		; $80F0B8
	db $0A,$FF,$7C,$FF,$7E,$FF,$FF,$27,$FF,$70,$FC,$78,$D9,$10,$BF,$FF		; $80F0C8
	db $86,$1F,$CC,$07,$E3,$07,$89,$DB,$59,$C4,$3C,$80,$A8,$90,$FA,$20		; $80F0D8
	db $03,$FF,$FE,$FF,$FC,$81,$20,$02,$3B,$FF,$7F,$49,$04,$FD,$FF,$E9		; $80F0E8
	db $CC,$AB,$49,$05,$6A,$8C,$49,$8C,$CB,$0F,$48,$03,$8F,$0B,$F3,$FF		; $80F0F8
	db $4C,$00,$F2,$58,$00,$FC,$4A,$80,$BA,$81,$BB,$47,$81,$B8,$81,$98		; $80F108
	db $4F,$38,$FF,$E0,$C3,$50,$88,$1C,$00,$FE,$20,$00,$FC,$20,$14,$BB		; $80F118
	db $9B,$ED,$CD,$CA,$CE,$C0,$C6,$E3,$E5,$B1,$E2,$40,$83,$D0,$11,$84		; $80F128
	db $7F,$C2,$3F,$C1,$49,$05,$C0,$1F,$80,$0F,$20,$1F,$C4,$07,$FF,$C0		; $80F138
	db $A7,$90,$80,$AF,$0E,$13,$20,$06,$0F,$CF,$0F,$E3,$03,$98,$40,$20		; $80F148
	db $07,$DF,$4F,$E0,$50,$FF,$EF,$FF,$F0,$49,$18,$7C,$FF,$3F,$FF,$FC		; $80F158
	db $30,$EC,$30,$3E,$88,$4E,$90,$1C,$E0,$80,$81,$05,$01,$54,$29,$03		; $80F168
	db $FB,$C3,$07,$77,$80,$20,$00,$1F,$80,$DE,$00,$FE,$49,$11,$17,$1B		; $80F178
	db $13,$1B,$6B,$73,$F3,$E3,$03,$E3,$2D,$C3,$16,$C1,$23,$94,$E3,$FC		; $80F188
	db $48,$02,$83,$FC,$03,$49,$01,$01,$F8,$20,$02,$F8,$08,$F8,$3B,$FF		; $80F198
	db $01,$DF,$3F,$8A,$BC,$20,$00,$1F,$20,$01,$5F,$9F,$4A,$07,$5E,$9F		; $80F1A8
	db $59,$9E,$47,$98,$5F,$80,$48,$85,$BA,$00,$F8,$20,$00,$E0,$4B,$05		; $80F1B8
	db $F7,$F8,$DF,$E0,$BF,$C0,$87,$F4,$00,$F0,$20,$00,$C0,$20,$00,$80		; $80F1C8
	db $2A,$13,$C0,$08,$E0,$3A,$E0,$3D,$C2,$35,$E2,$08,$F1,$1E,$F0,$05		; $80F1D8
	db $F8,$0E,$30,$0F,$10,$07,$48,$06,$18,$03,$1C,$03,$0C,$01,$0E,$20		; $80F1E8
	db $00,$07,$20,$0A,$90,$4F,$6C,$23,$90,$31,$35,$8F,$01,$40,$57,$20		; $80F1F8
	db $00,$8F,$20,$02,$40,$80,$3F,$80,$BA,$00,$0E,$83,$4B,$00,$F8,$59		; $80F208
	db $08,$7F,$F0,$F1,$D3,$E0,$05,$C0,$9A,$F1,$21,$00,$89,$20,$00,$E3		; $80F218
	db $20,$06,$02,$01,$FE,$FF,$FC,$FF,$38,$83,$20,$E1,$1C,$10,$FE,$53		; $80F228
	db $3C,$97,$74,$07,$FC,$43,$8C,$8F,$70,$0F,$D8,$0F,$A0,$1F,$70,$20		; $80F238
	db $01,$F0,$08,$48,$07,$E0,$38,$E0,$18,$C0,$30,$80,$70,$81,$A0,$02		; $80F248
	db $0F,$FD,$03,$89,$D2,$00,$07,$20,$00,$01,$2C,$01,$FD,$FE,$48,$07		; $80F258
	db $7D,$FE,$9D,$7E,$F5,$0E,$FD,$06,$4A,$00,$F8,$80,$77,$00,$78,$20		; $80F268
	db $00,$18,$28,$81,$F4,$89,$02,$83,$F6,$4F,$E9,$50,$4B,$2F,$03,$F0		; $80F278
	db $0F,$F8,$07,$49,$05,$03,$FC,$07,$FC,$01,$FE,$68,$01,$03,$07,$80		; $80F288
	db $82,$4A,$00,$03,$49,$00,$01,$49,$14,$38,$40,$18,$A0,$06,$E8,$0E		; $80F298
	db $F4,$1F,$E8,$3C,$D0,$7B,$A3,$FE,$42,$80,$3F,$C0,$1F,$F0,$80,$30		; $80F2A8
	db $00,$F0,$20,$0B,$E1,$03,$C0,$07,$81,$0F,$2C,$02,$02,$09,$60,$17		; $80F2B8
	db $20,$08,$5F,$C0,$5F,$E0,$8F,$D0,$C7,$58,$63,$E0,$45,$05,$F0,$0F		; $80F2C8
	db $E0,$3F,$80,$3F,$20,$01,$1F,$80,$78,$05,$87,$F0,$0F,$F0,$1F,$E0		; $80F2D8
	db $E0,$31,$58,$01,$A0,$7F,$68,$C4,$84,$A0,$00,$C0,$49,$00,$80,$4B		; $80F2E8
	db $83,$D6,$4F,$00,$06,$2F,$89,$DC,$01,$40,$BF,$85,$40,$85,$46,$00		; $80F2F8
	db $80,$8B,$DC,$00,$FF,$8F,$E0,$00,$FF,$20,$00,$FE,$58,$00,$01,$87		; $80F308
	db $20,$81,$D4,$2B,$0B,$EE,$82,$EA,$06,$CA,$06,$82,$26,$05,$F1,$10		; $80F318
	db $C3,$82,$20,$00,$1F,$49,$06,$3F,$01,$5F,$62,$0F,$60,$0F,$23,$0B		; $80F328
	db $26,$41,$04,$62,$4A,$C5,$5D,$CE,$20,$D1,$61,$8D,$81,$20,$03,$83		; $80F338
	db $F8,$81,$F8,$20,$00,$F0,$20,$04,$E0,$0E,$C0,$1E,$80,$83,$60,$00		; $80F348
	db $7F,$58,$01,$80,$7F,$C6,$80,$8D,$E1,$8E,$82,$17,$28,$89,$DC,$01		; $80F358
	db $01,$FE,$8F,$A0,$E0,$00		; $80F368
adda43:		;auto: CODE_80F36E. 93G adda43 (hockey93_02): a4 += replaysize, wrapping from ReplayBufferEnd to ReplayBufferStart
	lda.b a4		; $80F36E: A5 43
	clc		; $80F370: 18
	adc.w #replaysize		; $80F371: 69 71 00
	sta.b a4		; $80F374: 85 43
	bcc .nc		; $80F376: 90 02
	inc.b a4+2		; $80F378: E6 45
.nc:
	cmp.w #ReplayBufferEnd&$FFFF		; $80F37A: C9 41 FF  past the end of the buffer: wrap
	bne .rtl		; $80F37D: D0 11
	lda.b a4+2		; $80F37F: A5 45
	cmp.w #ReplayBufferEnd>>16		; $80F381: C9 7E 00
	bne .rtl		; $80F384: D0 0A
	lda.w #ReplayBufferStart&$FFFF		; $80F386: A9 74 81
	sta.b a4		; $80F389: 85 43
	lda.w #ReplayBufferStart>>16		; $80F38B: A9 7E 00
	sta.b a4+2		; $80F38E: 85 45
.rtl:
	rtl		; $80F390: 6B
setlccords:		;auto: CODE_80F391. 93G setlccords (logic93_1): printx/printy for the line change box of team a2 (21 rows lower for the home team, flipped by gmdir); d0/d1 = Framer box size
	stz.b d0		; $80F391: 64 53
	lda.b a2		; $80F393: A5 3B
	bne .pr		; $80F395: D0 02
	inc.b d0		; $80F397: E6 53
.pr:
	jsl.l printz		; $80F399: 22 0C B9 80
	dw $0005		; $80F39D  printz inline string: length (counts itself), then control bytes / text
	db $BF,$13,$01
	lda.w gmode		; $80F3A2: AD 88 12  gmdir flips it
	bit.w #gmdir		; $80F3A5: 89 02 00
	beq .noflip		; $80F3A8: F0 07
	lda.b d0		; $80F3AA: A5 53
	eor.w #$0001		; $80F3AC: 49 01 00
	sta.b d0		; $80F3AF: 85 53
.noflip:
	lda.w #$0015		; $80F3B1: A9 15 00  printy += 21 * d0
	sta.b mula		; $80F3B4: 85 7D
	lda.b d0		; $80F3B6: A5 53
	sta.b mulb		; $80F3B8: 85 83
	jsl.l $8D871C		; $80F3BA: 22 1C 87 8D  bank $8D: mulu, A = mula*mulb
	adc.w printy		; $80F3BE: 6D 7D 04
	sta.w printy		; $80F3C1: 8D 7D 04
	lda.w #$0002		; $80F3C4: A9 02 00  getlchoice 2: no third choice: 2 rows
	sta.b d0		; $80F3C7: 85 53
	jsl.l $8AFD6D		; $80F3C9: 22 6D FD 8A  bank $8A: 93G getlchoice (d0 = possible line, -1 = none)
	lda.w #$0006		; $80F3CD: A9 06 00
	sta.b d1		; $80F3D0: 85 57
	lda.b d0		; $80F3D2: A5 53
	bpl .ex		; $80F3D4: 10 05
	dec.b d1		; $80F3D6: C6 57
	inc.w printy		; $80F3D8: EE 7D 04
.ex:
	lda.w #$000C		; $80F3DB: A9 0C 00
	sta.b d0		; $80F3DE: 85 53
	rtl		; $80F3E0: 6B
startpause:		;auto: CODE_80F3E1. 93G startpause (hockey93_01): set sfpz (startpause1 and startpause2 jump here)
	lda.w #sfpz		; $80F3E1: A9 01 00
	tsb.w sflags		; $80F3E4: 0C 8C 12
	rtl		; $80F3E7: 6B
ReadPads:		;auto: CODE_80F3E8. SNES: once per frame (padvcount) read the 4 auto-read pads into joypad1-4, padnew1-4 = new presses, padlast1-4 = buttons
	lda.b vcount		; $80F3E8: A5 00  once per frame
	cmp.w padvcount		; $80F3EA: CD 76 01
	beq .new		; $80F3ED: F0 23
	sta.w padvcount		; $80F3EF: 8D 76 01
	lda.w #$0001		; $80F3F2: A9 01 00
.wait:		;auto-joypad read busy
	bit.w HVBJOY		; $80F3F5: 2C 12 42
	bne .wait		; $80F3F8: D0 FB
	lda.w JOY1L		; $80F3FA: AD 18 42
	sta.w joypad1		; $80F3FD: 8D 5E 01
	lda.w JOY2L		; $80F400: AD 1A 42
	sta.w joypad2		; $80F403: 8D 60 01
	lda.w JOY3L		; $80F406: AD 1C 42
	sta.w joypad3		; $80F409: 8D 62 01
	lda.w JOY4L		; $80F40C: AD 1E 42
	sta.w joypad4		; $80F40F: 8D 64 01
.new:
	lda.w joypad1		; $80F412: AD 5E 01  new presses = changed and down
	eor.w padlast1		; $80F415: 4D 66 01
	and.w joypad1		; $80F418: 2D 5E 01
	sta.w padnew1		; $80F41B: 8D 6E 01
	lda.w joypad2		; $80F41E: AD 60 01
	eor.w padlast1+2		; $80F421: 4D 68 01
	and.w joypad2		; $80F424: 2D 60 01
	sta.w padnew1+2		; $80F427: 8D 70 01
	lda.w joypad3		; $80F42A: AD 62 01
	eor.w padlast1+4		; $80F42D: 4D 6A 01
	and.w joypad3		; $80F430: 2D 62 01
	sta.w padnew1+4		; $80F433: 8D 72 01
	lda.w joypad4		; $80F436: AD 64 01
	eor.w padlast1+6		; $80F439: 4D 6C 01
	and.w joypad4		; $80F43C: 2D 64 01
	sta.w padnew1+6		; $80F43F: 8D 74 01
	lda.w joypad1		; $80F442: AD 5E 01
	sta.w padlast1		; $80F445: 8D 66 01
	lda.w joypad2		; $80F448: AD 60 01
	sta.w padlast1+2		; $80F44B: 8D 68 01
	lda.w joypad3		; $80F44E: AD 62 01
	sta.w padlast1+4		; $80F451: 8D 6A 01
	lda.w joypad4		; $80F454: AD 64 01
	sta.w padlast1+6		; $80F457: 8D 6C 01
	rtl		; $80F45A: 6B
asspuckc:		;auto: CODE_80F45B (asstab $10). 93G asspuckc (logic93_3): player X is the puck carrier: every aioff frames checkob, chk4lc, chk4shot, chk4pass; skate to a postab spot (bank $8F) with .chkdir
	txa		; $80F45B: 8A  not the carrier: assexit
	lsr a		; $80F45C: 4A
	cmp.w puckc		; $80F45D: CD BB 0E
	beq .nl		; $80F460: F0 03
	jmp.w assexit		; $80F462: 4C F9 96
.nl:
	lda.w pfalock,x		; $80F465: BD 7F 11  anim locked
	beq .clk		; $80F468: F0 03
	jmp.w .rtl		; $80F46A: 4C 19 F5
.clk:
	lda.w gmclock		; $80F46D: AD 8A 12  clock stopped: assnothing
	beq .go		; $80F470: F0 04
	jml.l $8FD75A		; $80F472: 5C 5A D7 8F  bank $8F: 93G assnothing
.go:
	lda.w pflags,x		; $80F476: BD DF 0E  joystick controlled: assexit
	bit.w #pfjoycon		; $80F479: 89 08 00
	beq .na		; $80F47C: F0 03
	jmp.w assexit		; $80F47E: 4C F9 96
.na:
	bit.w #pfna		; $80F481: 89 02 00  new assignment: temp1 = 0, temp2b = 8, temp3 = random 0-3
	beq .nna		; $80F484: F0 1B
	and.w #~pfna&$FFFF		; $80F486: 29 FD FF
	sta.w pflags,x		; $80F489: 9D DF 0E
	stz.w temp1,x		; $80F48C: 9E 5F 0C
	stz.w temp2,x		; $80F48F: 9E 7F 0C
	lda.w #$0008		; $80F492: A9 08 00
	sta.w temp2b,x		; $80F495: 9D FF 0C
	lda.w seed		; $80F498: AD A1 04
	and.w #$0003		; $80F49B: 29 03 00
	sta.w temp3,x		; $80F49E: 9D 9F 0C
.nna:
	lda.w temp1,x		; $80F4A1: BD 5F 0C  every aioff frames: checkob, chk4lc, chk4shot, chk4pass
	sec		; $80F4A4: 38
	sbc.b d7		; $80F4A5: E5 6F
	sta.w temp1,x		; $80F4A7: 9D 5F 0C
	bpl .nodec		; $80F4AA: 10 1B
	adc.w aioff,x		; $80F4AC: 7D 9F 0F
	bpl .set		; $80F4AF: 10 03
	lda.w #$0000		; $80F4B1: A9 00 00
.set:
	sta.w temp1,x		; $80F4B4: 9D 5F 0C
	jsl.l checkob		; $80F4B7: 22 98 85 80
	jsl.l chk4lc		; $80F4BB: 22 81 86 80
	jsl.l chk4shot		; $80F4BF: 22 E3 86 80
	jsl.l $8CFD83		; $80F4C3: 22 83 FD 8C  bank $8C: 93G chk4pass
.nodec:		;IDA asspuckc_onside: d0 = 6 + temp3 (random spot), or position when offsides
	lda.w #$0006		; $80F4C7: A9 06 00
	clc		; $80F4CA: 18
	adc.w temp3,x		; $80F4CB: 7D 9F 0C
	sta.b d0		; $80F4CE: 85 53
	lda.w #$DFE2		; $80F4D0: A9 E2 DF
	sta.b a0		; $80F4D3: 85 33
	lda.w #$008F		; $80F4D5: A9 8F 00
	sta.b a0+2		; $80F4D8: 85 35
	lda.w sflags		; $80F4DA: AD 8C 12  sf2offsig: spot by position
	bit.w #sf2offsig		; $80F4DD: 89 00 80
	beq .nd1		; $80F4E0: F0 05
	lda.w position,x		; $80F4E2: BD 9F 0B
	sta.b d0		; $80F4E5: 85 53
.nd1:
	lda.b d0		; $80F4E7: A5 53  d0/d1 = spot x/y, negated for pfgoal clear
	asl a		; $80F4E9: 0A
	asl a		; $80F4EA: 0A
	tay		; $80F4EB: A8
	lda.b [a0],y		; $80F4EC: B7 33
	sta.b d0		; $80F4EE: 85 53
	iny		; $80F4F0: C8
	iny		; $80F4F1: C8
	lda.b [a0],y		; $80F4F2: B7 33
	sta.b d1		; $80F4F4: 85 57
	lda.w pfgoal,x		; $80F4F6: BD 3F 11
	bne .nd0		; $80F4F9: D0 10
	lda.b d0		; $80F4FB: A5 53
	eor.w #$FFFF		; $80F4FD: 49 FF FF
	inc a		; $80F500: 1A
	sta.b d0		; $80F501: 85 53
	lda.b d1		; $80F503: A5 57
	eor.w #$FFFF		; $80F505: 49 FF FF
	inc a		; $80F508: 1A
	sta.b d1		; $80F509: 85 57
.nd0:
	lda.w #.chkdir		; $80F50B: A9 1A F5  skateto with the .chkdir callback
	sta.b a0		; $80F50E: 85 33
	lda.w #.chkdir>>16		; $80F510: A9 80 00
	sta.b a0+2		; $80F513: 85 35
	jml.l $88FDD0		; $80F515: 5C D0 FD 88  bank $88: 93G skateto (d0/d1 = target, a0 = callback)
.rtl:
	rtl		; $80F519: 6B
.chkdir:		;IDA asspuckc_chkdir: skateto callback. d0 = direction; turn away from an opponent within 20 of where the puck will be (threat = count)
	lda.b d0		; $80F51A: A5 53
	and.w #$00FF		; $80F51C: 29 FF 00
	bit.w #$0080		; $80F51F: 89 80 00
	beq .cd		; $80F522: F0 03
	ora.w #$FF00		; $80F524: 09 00 FF
.cd:
	sta.b d0		; $80F527: 85 53  d2/d3 = puck + velocity
	lda.w Xvel+1,x		; $80F529: BD E0 0A
	and.w #$00FF		; $80F52C: 29 FF 00
	bit.w #$0080		; $80F52F: 89 80 00
	beq .x2		; $80F532: F0 03
	ora.w #$FF00		; $80F534: 09 00 FF
.x2:
	clc		; $80F537: 18
	adc.w puckx		; $80F538: 6D 1B 09
	sta.b d2		; $80F53B: 85 5B
	lda.w Yvel+1,x		; $80F53D: BD 00 0B
	and.w #$00FF		; $80F540: 29 FF 00
	bit.w #$0080		; $80F543: 89 80 00
	beq .y2		; $80F546: F0 03
	ora.w #$FF00		; $80F548: 09 00 FF
.y2:
	clc		; $80F54B: 18
	adc.w pucky		; $80F54C: 6D 7B 09
	sta.b d3		; $80F54F: 85 5F
	stz.w threat		; $80F551: 9C D3 08
	lda.w #$0005		; $80F554: A9 05 00
	sta.b d4		; $80F557: 85 63
	stz.b a0		; $80F559: 64 33  the 6 opponents
	cpx.w #$000C		; $80F55B: E0 0C 00
	bcs .cd0		; $80F55E: B0 05
	lda.w #$000C		; $80F560: A9 0C 00
	sta.b a0		; $80F563: 85 33
.cd0:
	ldy.b a0		; $80F565: A4 33
	lda.w Xvel+1,y		; $80F567: B9 E0 0A
	and.w #$00FF		; $80F56A: 29 FF 00
	bit.w #$0080		; $80F56D: 89 80 00
	beq .cx		; $80F570: F0 03
	ora.w #$FF00		; $80F572: 09 00 FF
.cx:
	clc		; $80F575: 18
	adc.w Xpos,y		; $80F576: 79 FF 08
	sec		; $80F579: 38
	sbc.b d2		; $80F57A: E5 5B
	bit.w #$8000		; $80F57C: 89 00 80
	beq .ax		; $80F57F: F0 04
	eor.w #$FFFF		; $80F581: 49 FF FF
	inc a		; $80F584: 1A
.ax:
	cmp.w #$0015		; $80F585: C9 15 00
	bcs .next		; $80F588: B0 54
	lda.w Yvel+1,y		; $80F58A: B9 00 0B
	and.w #$00FF		; $80F58D: 29 FF 00
	bit.w #$0080		; $80F590: 89 80 00
	beq .cy		; $80F593: F0 03
	ora.w #$FF00		; $80F595: 09 00 FF
.cy:
	clc		; $80F598: 18
	adc.w Ypos,y		; $80F599: 79 5F 09
	sec		; $80F59C: 38
	sbc.b d3		; $80F59D: E5 5F
	bit.w #$8000		; $80F59F: 89 00 80
	beq .ay		; $80F5A2: F0 04
	eor.w #$FFFF		; $80F5A4: 49 FF FF
	inc a		; $80F5A7: 1A
.ay:
	cmp.w #$0015		; $80F5A8: C9 15 00
	bcs .next		; $80F5AB: B0 31
	inc.w threat		; $80F5AD: EE D3 08  threat +1; facing straight at it: turn one step either way
	lda.w Xpos,x		; $80F5B0: BD FF 08
	sec		; $80F5B3: 38
	sbc.w Xpos,y		; $80F5B4: F9 FF 08
	sta.b d0		; $80F5B7: 85 53
	lda.w Ypos,x		; $80F5B9: BD 5F 09
	sec		; $80F5BC: 38
	sbc.w Ypos,y		; $80F5BD: F9 5F 09
	sta.b d1		; $80F5C0: 85 57
	jsl.l vtoa		; $80F5C2: 22 A8 AF 80
	lda.w facedir,x		; $80F5C6: BD BF 0D
	eor.w #$0004		; $80F5C9: 49 04 00
	cmp.b d0		; $80F5CC: C5 53
	bne .next		; $80F5CE: D0 0E
	lda.w seed+2		; $80F5D0: AD A3 04
	and.w #$0001		; $80F5D3: 29 01 00
	clc		; $80F5D6: 18
	adc.b d0		; $80F5D7: 65 53
	and.w #$0007		; $80F5D9: 29 07 00
	sta.b d0		; $80F5DC: 85 53
.next:
	inc.b a0		; $80F5DE: E6 33
	inc.b a0		; $80F5E0: E6 33
	dec.b d4		; $80F5E2: C6 63
	bmi .rtl2		; $80F5E4: 30 03
	jmp.w .cd0		; $80F5E6: 4C 65 F5
.rtl2:
	rtl		; $80F5E9: 6B
DecodePW:		;auto: CODE_80F5EA. 92G DecodePW: translate the password in PassWord to game variables: PWtoBits, then ReadPassBits ($8B817A)
	jsl.l PWtoBits		; $80F5EA: 22 C5 FB 82
	jml.l $8B817A		; $80F5EE: 5C 7A 81 8B  bank $8B
far8B8172:		;auto: CODE_80F5F2. far trampoline: $88F512 (font tile bases), then on at $8B8172
	jsl.l $88F512		; $80F5F2: 22 12 F5 88  bank $88: font tile bases
	jml.l $8B8172		; $80F5F6: 5C 72 81 8B  bank $8B
SuperDiv:		;auto: CODE_80F5FA. 92G SuperDiv: passbits (128 bits) / d0: quotient in passbits, remainder in d0. Shift-subtract over 128 bits with the divisor in mula+0..+16 and the remainder in mulres+0..+14
	phx		; $80F5FA: DA  remainder = passbits, divisor = d0 << 128
	ldx.w #$000E		; $80F5FB: A2 0E 00
.init:
	lda.w passbits,x		; $80F5FE: BD 24 16
	sta.b mulres,x		; $80F601: 95 93
	stz.b mula,x		; $80F603: 74 7D
	dex		; $80F605: CA
	dex		; $80F606: CA
	bpl .init		; $80F607: 10 F5
	lda.b d0		; $80F609: A5 53
	sta.b mula+16		; $80F60B: 85 8D
	ldx.w #$0080		; $80F60D: A2 80 00
.loop:
	lsr.b mula+16		; $80F610: 46 8D
	ror.b mula+14		; $80F612: 66 8B
	ror.b mula+12		; $80F614: 66 89
	ror.b mula+10		; $80F616: 66 87
	ror.b mula+8		; $80F618: 66 85
	ror.b mula+6		; $80F61A: 66 83
	ror.b mula+4		; $80F61C: 66 81
	ror.b mula+2		; $80F61E: 66 7F
	ror.b mula		; $80F620: 66 7D
	asl.w passbits		; $80F622: 0E 24 16  shift the dividend left
	rol.w passbits+2		; $80F625: 2E 26 16
	rol.w passbits+4		; $80F628: 2E 28 16
	rol.w passbits+6		; $80F62B: 2E 2A 16
	rol.w passbits+8		; $80F62E: 2E 2C 16
	rol.w passbits+10		; $80F631: 2E 2E 16
	rol.w passbits+12		; $80F634: 2E 30 16
	rol.w passbits+14		; $80F637: 2E 32 16
	lda.b mulres		; $80F63A: A5 93  remainder >= divisor: subtract, quotient bit 1
	cmp.b mula		; $80F63C: C5 7D
	lda.b mulres+2		; $80F63E: A5 95
	sbc.b mula+2		; $80F640: E5 7F
	lda.b mulres+4		; $80F642: A5 97
	sbc.b mula+4		; $80F644: E5 81
	lda.b mulres+6		; $80F646: A5 99
	sbc.b mula+6		; $80F648: E5 83
	lda.b mulres+8		; $80F64A: A5 9B
	sbc.b mula+8		; $80F64C: E5 85
	lda.b mulres+10		; $80F64E: A5 9D
	sbc.b mula+10		; $80F650: E5 87
	lda.b mulres+12		; $80F652: A5 9F
	sbc.b mula+12		; $80F654: E5 89
	lda.b mulres+14		; $80F656: A5 A1
	sbc.b mula+14		; $80F658: E5 8B
	lda.w #$0000		; $80F65A: A9 00 00
	sbc.b mula+16		; $80F65D: E5 8D
	bcc .next		; $80F65F: 90 33
	lda.b mulres		; $80F661: A5 93
	sbc.b mula		; $80F663: E5 7D
	sta.b mulres		; $80F665: 85 93
	lda.b mulres+2		; $80F667: A5 95
	sbc.b mula+2		; $80F669: E5 7F
	sta.b mulres+2		; $80F66B: 85 95
	lda.b mulres+4		; $80F66D: A5 97
	sbc.b mula+4		; $80F66F: E5 81
	sta.b mulres+4		; $80F671: 85 97
	lda.b mulres+6		; $80F673: A5 99
	sbc.b mula+6		; $80F675: E5 83
	sta.b mulres+6		; $80F677: 85 99
	lda.b mulres+8		; $80F679: A5 9B
	sbc.b mula+8		; $80F67B: E5 85
	sta.b mulres+8		; $80F67D: 85 9B
	lda.b mulres+10		; $80F67F: A5 9D
	sbc.b mula+10		; $80F681: E5 87
	sta.b mulres+10		; $80F683: 85 9D
	lda.b mulres+12		; $80F685: A5 9F
	sbc.b mula+12		; $80F687: E5 89
	sta.b mulres+12		; $80F689: 85 9F
	lda.b mulres+14		; $80F68B: A5 A1
	sbc.b mula+14		; $80F68D: E5 8B
	sta.b mulres+14		; $80F68F: 85 A1
	inc.w passbits		; $80F691: EE 24 16
.next:
	dex		; $80F694: CA
	beq .done		; $80F695: F0 03
	jmp.w .loop		; $80F697: 4C 10 F6
.done:
	plx		; $80F69A: FA
	lda.b mulres		; $80F69B: A5 93
	sta.b d0		; $80F69D: 85 53
	clc		; $80F69F: 18
	rtl		; $80F6A0: 6B
randomd0s:		;auto: CODE_80F6A1. 93G randomd0s: A = random -A..A (randoma of 2A, minus A)
	sta.b tmp0		; $80F6A1: 85 73
	asl a		; $80F6A3: 0A
	jsl.l randoma		; $80F6A4: 22 8B AE 80
	sec		; $80F6A8: 38
	sbc.b tmp0		; $80F6A9: E5 73
	clc		; $80F6AB: 18
	rtl		; $80F6AC: 6B
assgoalie:		;auto: CODE_80F6AD (asstab $E). 93G assgoalie (logic93_3): goalie X. Skate back to the crease, hold/pass the puck, cover a loose puck, follow the puck and lead it, saves (GoalieSaveList), hug the post, rush a loose puck (agoalietopuck)
	lda.w pfalock,x		; $80F6AD: BD 7F 11  anim locked: nothing
	beq .go		; $80F6B0: F0 03
	jmp.w .rtl		; $80F6B2: 4C D0 F8
.go:
	jsl.l check4bench		; $80F6B5: 22 27 85 80
	lda.w pflags,x		; $80F6B9: BD DF 0E  new assignment: temp1/temp2 = 0, temp2b = 8, temp4 = -1
	bit.w #pfna		; $80F6BC: 89 02 00
	beq .nna		; $80F6BF: F0 18
	and.w #~pfna&$FFFF		; $80F6C1: 29 FD FF
	sta.w pflags,x		; $80F6C4: 9D DF 0E
	stz.w temp1,x		; $80F6C7: 9E 5F 0C
	stz.w temp2,x		; $80F6CA: 9E 7F 0C
	lda.w #$0008		; $80F6CD: A9 08 00
	sta.w temp2b,x		; $80F6D0: 9D FF 0C
	lda.w #$FFFF		; $80F6D3: A9 FF FF
	sta.w temp4,x		; $80F6D6: 9D BF 0C
.nna:
	lda.w Xpos,x		; $80F6D9: BD FF 08  outside the crease area: skate back
	bit.w #$8000		; $80F6DC: 89 00 80
	beq .ax		; $80F6DF: F0 04
	eor.w #$FFFF		; $80F6E1: 49 FF FF
	inc a		; $80F6E4: 1A
.ax:
	cmp.w #$0035		; $80F6E5: C9 35 00
	bcs .skate		; $80F6E8: B0 16
	lda.w Ypos,x		; $80F6EA: BD 5F 09
	bit.w #$8000		; $80F6ED: 89 00 80
	beq .ay		; $80F6F0: F0 04
	eor.w #$FFFF		; $80F6F2: 49 FF FF
	inc a		; $80F6F5: 1A
.ay:
	cmp.w #$010F		; $80F6F6: C9 0F 01
	bcs .skate		; $80F6F9: B0 05
	cmp.w #$00D3		; $80F6FB: C9 D3 00
	bcs .noskate		; $80F6FE: B0 2C
.skate:		;skate back to the net (callback rtss)
	lda.w #rtss		; $80F700: A9 E6 84
	sta.b a0		; $80F703: 85 33
	lda.w #rtss>>16		; $80F705: A9 80 00
	sta.b a0+2		; $80F708: 85 35
	lda.w #$0004		; $80F70A: A9 04 00
	sta.b d0		; $80F70D: 85 53
	lda.w Xpos,x		; $80F70F: BD FF 08
	bpl .zero		; $80F712: 10 05
	lda.w #$FFFC		; $80F714: A9 FC FF
	sta.b d0		; $80F717: 85 53
.zero:
	lda.w #$00E4		; $80F719: A9 E4 00
	sta.b d1		; $80F71C: 85 57
	lda.w pfgoal,x		; $80F71E: BD 3F 11
	beq .sk		; $80F721: F0 05
	lda.w #$FF1C		; $80F723: A9 1C FF
	sta.b d1		; $80F726: 85 57
.sk:
	jml.l $88FDD0		; $80F728: 5C D0 FD 88  bank $88: 93G skateto (d0/d1 = target, a0 = callback)
.noskate:
	lda.w pf2aip,x		; $80F72C: BD DF 11  pf2aip: nothing
	beq .gready		; $80F72F: F0 03
	jmp.w .rtl		; $80F731: 4C D0 F8
.gready:
	lda.w #SPAgready		; $80F734: A9 02 00
	sta.b d1		; $80F737: 85 57
	jsl.l SetSPA		; $80F739: 22 06 B0 80
	lda.w gmclock		; $80F73D: AD 8A 12  clock stopped: nothing
	beq .clk		; $80F740: F0 03
	jmp.w .rtl		; $80F742: 4C D0 F8
.clk:
	lda.w temp5,x		; $80F745: BD DF 0C  temp5 = holding time
	bmi .nofo		; $80F748: 30 26
	lda.w SCnum,x		; $80F74A: BD 9F 0D
	sta.b d0		; $80F74D: 85 53
	cmp.w puckc		; $80F74F: CD BB 0E
	beq .mbfo		; $80F752: F0 08
	lda.w #$FFFF		; $80F754: A9 FF FF
	sta.w temp5,x		; $80F757: 9D DF 0C
	bra .nofo		; $80F75A: 80 14
.mbfo:		;holding the puck: PenGhold when temp5 runs out
	lda.w temp5,x		; $80F75C: BD DF 0C
	sec		; $80F75F: 38
	sbc.b d7		; $80F760: E5 6F
	sta.w temp5,x		; $80F762: 9D DF 0C
	bpl .nofo		; $80F765: 10 09
	lda.w #PenGhold		; $80F767: A9 08 00
	sta.b d0		; $80F76A: 85 53
	jsl.l AddPenalty2		; $80F76C: 22 B0 C1 80
.nofo:
	lda.w temp1,x		; $80F770: BD 5F 0C  every aidef/4 frames
	sec		; $80F773: 38
	sbc.b d7		; $80F774: E5 6F
	sta.w temp1,x		; $80F776: 9D 5F 0C
	bmi .dec		; $80F779: 30 03
	jmp.w .nodec		; $80F77B: 4C FD FB
.dec:
	lda.w aidef,x		; $80F77E: BD BF 0F
	lsr a		; $80F781: 4A
	lsr a		; $80F782: 4A
	clc		; $80F783: 18
	adc.w temp1,x		; $80F784: 7D 5F 0C
	bpl .st1		; $80F787: 10 03
	lda.w #$0000		; $80F789: A9 00 00
.st1:
	sta.w temp1,x		; $80F78C: 9D 5F 0C
	lda.w pflags,x		; $80F78F: BD DF 0E  joystick goalie: only .cover
	bit.w #pfjoycon		; $80F792: 89 08 00
	beq .half		; $80F795: F0 03
	jmp.w .cover		; $80F797: 4C 63 F8
.half:
	lda.w pucky		; $80F79A: AD 7B 09  puck in the other half: stay at the top of the crease (y +-$F4)
	sta.b d0		; $80F79D: 85 53
	lda.w Ypos,x		; $80F79F: BD 5F 09
	eor.b d0		; $80F7A2: 45 53
	sta.b d1		; $80F7A4: 85 57
	bpl .cnt		; $80F7A6: 10 17
	stz.b d0		; $80F7A8: 64 53
	lda.w #$00F4		; $80F7AA: A9 F4 00
	sta.b d2		; $80F7AD: 85 5B
	lda.w pfgoal,x		; $80F7AF: BD 3F 11
	bne .other		; $80F7B2: D0 03
	jmp.w .de5		; $80F7B4: 4C 7E FB
.other:
	lda.w #$FF0C		; $80F7B7: A9 0C FF
	sta.b d2		; $80F7BA: 85 5B
	jmp.w .de5		; $80F7BC: 4C 7E FB
.cnt:		;puck in my half
	dec.w temp4,x		; $80F7BF: DE BF 0C
	bpl .pc		; $80F7C2: 10 06
	lda.w #$FFFF		; $80F7C4: A9 FF FF
	sta.w temp4,x		; $80F7C7: 9D BF 0C
.pc:
	lda.w SCnum,x		; $80F7CA: BD 9F 0D
	cmp.w puckc		; $80F7CD: CD BB 0E
	beq .hold0		; $80F7D0: F0 03
	jmp.w .cover		; $80F7D2: 4C 63 F8
.hold0:
	lda.w temp5,x		; $80F7D5: BD DF 0C  90 frames before the holding penalty
	bpl .hold		; $80F7D8: 10 06
	lda.w #$005A		; $80F7DA: A9 5A 00
	sta.w temp5,x		; $80F7DD: 9D DF 0C
.hold:
	lda.w #$FFFF		; $80F7E0: A9 FF FF
	sta.w temp4,x		; $80F7E3: 9D BF 0C
	lda.w temp5,x		; $80F7E6: BD DF 0C
	sec		; $80F7E9: 38
	sbc.w #$005A		; $80F7EA: E9 5A 00
	beq .roll		; $80F7ED: F0 09
	bmi .v1		; $80F7EF: 30 05
	bvs .roll		; $80F7F1: 70 05
.de1j:
	jmp.w .de1		; $80F7F3: 4C D1 F8
.v1:
	bvs .de1j		; $80F7F6: 70 FB
.roll:
	lda.w #$0064		; $80F7F8: A9 64 00  1 in 4: pass
	jsl.l randoma		; $80F7FB: 22 8B AE 80
	cmp.w #$004B		; $80F7FF: C9 4B 00
	bcs .pass		; $80F802: B0 03
	jmp.w .de1		; $80F804: 4C D1 F8
.pass:
	lda.w #$0005		; $80F807: A9 05 00
	sta.b d0		; $80F80A: 85 53
	stz.b a0		; $80F80C: 64 33
	lda.w pfteam,x		; $80F80E: BD 9F 11
	bne .tl		; $80F811: D0 05
	lda.w #$000C		; $80F813: A9 0C 00
	sta.b a0		; $80F816: 85 33
.tl:		;pass only if no opponent is near the puck
	ldy.b a0		; $80F818: A4 33
	lda.w pflags,y		; $80F81A: B9 DF 0E
	bit.w #pf2unav		; $80F81D: 89 00 10
	bne .tn		; $80F820: D0 2D
	lda.w pucky		; $80F822: AD 7B 09
	sec		; $80F825: 38
	sbc.w Ypos,y		; $80F826: F9 5F 09
	bit.w #$8000		; $80F829: 89 00 80
	beq .tly		; $80F82C: F0 04
	eor.w #$FFFF		; $80F82E: 49 FF FF
	inc a		; $80F831: 1A
.tly:
	cmp.w #$001D		; $80F832: C9 1D 00
	bcs .tn		; $80F835: B0 18
	lda.w puckx		; $80F837: AD 1B 09
	sec		; $80F83A: 38
	sbc.w Xpos,y		; $80F83B: F9 FF 08
	bit.w #$8000		; $80F83E: 89 00 80
	beq .tlx		; $80F841: F0 04
	eor.w #$FFFF		; $80F843: 49 FF FF
	inc a		; $80F846: 1A
.tlx:
	cmp.w #$001A		; $80F847: C9 1A 00
	bcs .tn		; $80F84A: B0 03
	jmp.w .de1		; $80F84C: 4C D1 F8
.tn:
	inc.b a0		; $80F84F: E6 33
	inc.b a0		; $80F851: E6 33
	dec.b d0		; $80F853: C6 53
	bpl .tl		; $80F855: 10 C1
	lda.w #$0001		; $80F857: A9 01 00  threat = 1, chk4pass
	sta.w threat		; $80F85A: 8D D3 08
	jsl.l $8CFD83		; $80F85D: 22 83 FD 8C  bank $8C: 93G chk4pass
	bra .de1		; $80F861: 80 6E
.cover:		;cover a loose puck at the crease
	lda.w temp4,x		; $80F863: BD BF 0C
	bne .de1		; $80F866: D0 69
	lda.w puckc		; $80F868: AD BB 0E
	bpl .de1		; $80F86B: 10 64
	lda.w puckx		; $80F86D: AD 1B 09
	sec		; $80F870: 38
	sbc.w Xpos,x		; $80F871: FD FF 08
	sta.b d0		; $80F874: 85 53
	bit.w #$8000		; $80F876: 89 00 80
	beq .cvx		; $80F879: F0 04
	eor.w #$FFFF		; $80F87B: 49 FF FF
	inc a		; $80F87E: 1A
.cvx:
	cmp.w #$0015		; $80F87F: C9 15 00
	bcs .de1		; $80F882: B0 4D
	lda.w pucky		; $80F884: AD 7B 09
	sta.b d1		; $80F887: 85 57
	bit.w #$8000		; $80F889: 89 00 80
	beq .cvy		; $80F88C: F0 04
	eor.w #$FFFF		; $80F88E: 49 FF FF
	inc a		; $80F891: 1A
.cvy:
	cmp.w #$0109		; $80F892: C9 09 01
	bcs .de1		; $80F895: B0 3A
	lda.b d1		; $80F897: A5 57
	sec		; $80F899: 38
	sbc.w Ypos,x		; $80F89A: FD 5F 09
	sta.b d1		; $80F89D: 85 57
	bit.w #$8000		; $80F89F: 89 00 80
	beq .cvd		; $80F8A2: F0 04
	eor.w #$FFFF		; $80F8A4: 49 FF FF
	inc a		; $80F8A7: 1A
.cvd:
	cmp.w #$001F		; $80F8A8: C9 1F 00
	bcs .de1		; $80F8AB: B0 24
	jsl.l vtoa		; $80F8AD: 22 A8 AF 80
	lda.b d0		; $80F8B1: A5 53
	sta.w facedir,x		; $80F8B3: 9D BF 0D  facedir to the puck, nopuck 8, cover anim, pf2aip, crowd +150
	lda.w #$0008		; $80F8B6: A9 08 00
	sta.w nopuck,x		; $80F8B9: 9D 5F 0E
	lda.w #SPAgdive		; $80F8BC: A9 90 14
	sta.b d1		; $80F8BF: 85 57
	jsl.l SetSPA		; $80F8C1: 22 06 B0 80
	lda.w #$0096		; $80F8C5: A9 96 00
	sta.w pf2aip,x		; $80F8C8: 9D DF 11
	clc		; $80F8CB: 18
	adc.b crowdlevel		; $80F8CC: 65 DE
	sta.b crowdlevel		; $80F8CE: 85 DE
.rtl:
	rtl		; $80F8D0: 6B
.de1:		;a0 = puckcross entry of my goal, d3 = goal line
	lda.w #puckcross		; $80F8D1: A9 89 04
	sta.b a0		; $80F8D4: 85 33
	lda.w #$0000		; $80F8D6: A9 00 00
	sta.b a0+2		; $80F8D9: 85 35
	lda.w #$0104		; $80F8DB: A9 04 01
	sta.b d3		; $80F8DE: 85 5F
	lda.w pfgoal,x		; $80F8E0: BD 3F 11
	beq .de2		; $80F8E3: F0 0A
	lda.w #puckcross+4		; $80F8E5: A9 8D 04
	sta.b a0		; $80F8E8: 85 33
	lda.w #$FEFC		; $80F8EA: A9 FC FE
	sta.b d3		; $80F8ED: 85 5F
.de2:
	lda.w Ypos,x		; $80F8EF: BD 5F 09  out of the crease in y: behind the goal line
	bit.w #$8000		; $80F8F2: 89 00 80
	beq .de2y		; $80F8F5: F0 04
	eor.w #$FFFF		; $80F8F7: 49 FF FF
	inc a		; $80F8FA: 1A
.de2y:
	cmp.w #$0105		; $80F8FB: C9 05 01
	bcs .out		; $80F8FE: B0 37
	lda.w puckx		; $80F900: AD 1B 09  face the puck: ClampYPosition, vtoa, AdjustFacingDirection
	sta.b d0		; $80F903: 85 53
	lda.w pucky		; $80F905: AD 7B 09
	sta.b d1		; $80F908: 85 57
	jsl.l ClampYPosition		; $80F90A: 22 C9 FC 80
	lda.b d1		; $80F90E: A5 57
	bit.w #$8000		; $80F910: 89 00 80
	beq .near		; $80F913: F0 04
	eor.w #$FFFF		; $80F915: 49 FF FF
	inc a		; $80F918: 1A
.near:
	cmp.w #$002E		; $80F919: C9 2E 00
	bcs .in		; $80F91C: B0 46
	lda.b d1		; $80F91E: A5 57
	pha		; $80F920: 48
	lda.b d0		; $80F921: A5 53
	pha		; $80F923: 48
	jsl.l vtoa		; $80F924: 22 A8 AF 80
	jsl.l AdjustFacingDirection		; $80F928: 22 05 FD 80
	lda.b $01,s		; $80F92C: A3 01
	sta.b d0		; $80F92E: 85 53
	lda.b $03,s		; $80F930: A3 03
	sta.b d1		; $80F932: 85 57
	jmp.w .sq		; $80F934: 4C CD F9
.out:		;behind the goal line
	stz.b d2		; $80F937: 64 5B
	stz.b d0		; $80F939: 64 53
	lda.w Xpos,x		; $80F93B: BD FF 08
	bit.w #$8000		; $80F93E: 89 00 80
	beq .outx		; $80F941: F0 04
	eor.w #$FFFF		; $80F943: 49 FF FF
	inc a		; $80F946: 1A
.outx:
	cmp.w #$002D		; $80F947: C9 2D 00
	bcc .out2		; $80F94A: 90 03
	jmp.w .de5		; $80F94C: 4C 7E FB
.out2:
	lda.w #$0088		; $80F94F: A9 88 00
	sta.b d0		; $80F952: 85 53
	lda.w Xpos,x		; $80F954: BD FF 08
	bmi .outn		; $80F957: 30 03
	jmp.w .de5		; $80F959: 4C 7E FB
.outn:
	lda.w #$FF78		; $80F95C: A9 78 FF
	sta.b d0		; $80F95F: 85 53
	jmp.w .de5		; $80F961: 4C 7E FB
.in:		;face the puck, lead it by its velocity
	jsl.l vtoa		; $80F964: 22 A8 AF 80
	jsl.l AdjustFacingDirection		; $80F968: 22 05 FD 80
	lda.w puckvy		; $80F96C: AD 1B 0B  lead the puck by its velocity (/2 near the ends)
	xba		; $80F96F: EB
	lsr a		; $80F970: 4A
	and.w #$007F		; $80F971: 29 7F 00
	bit.w #$0040		; $80F974: 89 40 00
	beq .iy		; $80F977: F0 03
	ora.w #$FF80		; $80F979: 09 80 FF
.iy:
	clc		; $80F97C: 18
	adc.w pucky		; $80F97D: 6D 7B 09
	sta.b d1		; $80F980: 85 57
	lda.w puckvx		; $80F982: AD FB 0A
	xba		; $80F985: EB
	and.w #$00FF		; $80F986: 29 FF 00
	bit.w #$0080		; $80F989: 89 80 00
	beq .ix		; $80F98C: F0 03
	ora.w #$FF00		; $80F98E: 09 00 FF
.ix:
	sta.b d0		; $80F991: 85 53
	lda.b d1		; $80F993: A5 57
	sec		; $80F995: 38
	sbc.w #$00E0		; $80F996: E9 E0 00
	beq .lo		; $80F999: F0 08
	bmi .v2		; $80F99B: 30 04
	bvs .lo		; $80F99D: 70 04
	bra .lead2		; $80F99F: 80 12
.v2:
	bvs .lead2		; $80F9A1: 70 10
.lo:
	lda.b d1		; $80F9A3: A5 57
	sec		; $80F9A5: 38
	sbc.w #$FF20		; $80F9A6: E9 20 FF
	beq .lead2		; $80F9A9: F0 08
	bmi .v3		; $80F9AB: 30 04
	bvs .lead2		; $80F9AD: 70 04
	bra .lead		; $80F9AF: 80 0A
.v3:
	bvs .lead		; $80F9B1: 70 08
.lead2:
	lda.b d0		; $80F9B3: A5 53
	pha		; $80F9B5: 48
	asl a		; $80F9B6: 0A
	pla		; $80F9B7: 68
	ror a		; $80F9B8: 6A
	sta.b d0		; $80F9B9: 85 53
.lead:
	lda.b d0		; $80F9BB: A5 53
	clc		; $80F9BD: 18
	adc.w puckx		; $80F9BE: 6D 1B 09
	sta.b d0		; $80F9C1: 85 53
	jsl.l ClampYPosition		; $80F9C3: 22 C9 FC 80
	lda.b d1		; $80F9C7: A5 57
	pha		; $80F9C9: 48
	lda.b d0		; $80F9CA: A5 53
	pha		; $80F9CC: 48
.sq:
	lda.b d0		; $80F9CD: A5 53
	sta.b mula		; $80F9CF: 85 7D
	sta.b mulb		; $80F9D1: 85 83
	jsl.l muls32		; $80F9D3: 22 DB FC 82
	sta.b d0		; $80F9D7: 85 53
	lda.b mulres+2		; $80F9D9: A5 95
	sta.b d0+2		; $80F9DB: 85 55
	lda.b d1		; $80F9DD: A5 57
	sta.b mula		; $80F9DF: 85 7D
	sta.b mulb		; $80F9E1: 85 83
	jsl.l muls32		; $80F9E3: 22 DB FC 82
	sta.b d1		; $80F9E7: 85 57
	lda.b mulres+2		; $80F9E9: A5 95
	sta.b d1+2		; $80F9EB: 85 59
	lda.b d0		; $80F9ED: A5 53
	adc.b d1		; $80F9EF: 65 57
	sta.b d0		; $80F9F1: 85 53
	lda.b d0+2		; $80F9F3: A5 55
	adc.b d1+2		; $80F9F5: 65 59
	sta.b d0+2		; $80F9F7: 85 55
	lda.b d0		; $80F9F9: A5 53  distance^2 < 30*30: stay
	cmp.w #$0385		; $80F9FB: C9 85 03
	lda.b d0+2		; $80F9FE: A5 55
	sbc.w #$0000		; $80FA00: E9 00 00
	bcs .far		; $80FA03: B0 08
	pla		; $80FA05: 68
	sta.b d0		; $80FA06: 85 53
	pla		; $80FA08: 68
	sta.b d1		; $80FA09: 85 57
	bra .de4		; $80FA0B: 80 50
.far:		;scale to a 20 (28 if shooting) pixel arc
	jsl.l sroot		; $80FA0D: 22 B1 CB 80
	lda.b d0		; $80FA11: A5 53
	inc a		; $80FA13: 1A
	sta.b d2		; $80FA14: 85 5B
	lda.w #$0014		; $80FA16: A9 14 00
	sta.b d4		; $80FA19: 85 63
	lda.w sflags		; $80FA1B: AD 8C 12
	bit.w #sfssdir		; $80FA1E: 89 08 00
	beq .f0		; $80FA21: F0 05
	lda.w #$001C		; $80FA23: A9 1C 00
	sta.b d4		; $80FA26: 85 63
.f0:
	pla		; $80FA28: 68
	sta.b d0		; $80FA29: 85 53
	pla		; $80FA2B: 68
	sta.b d1		; $80FA2C: 85 57
	sta.b mulb		; $80FA2E: 85 83
	lda.b d4		; $80FA30: A5 63
	sta.b mula		; $80FA32: 85 7D
	jsl.l muls32		; $80FA34: 22 DB FC 82
	lda.b d2		; $80FA38: A5 5B
	sta.b mula		; $80FA3A: 85 7D
	jsl.l divs		; $80FA3C: 22 6C 99 80
	sta.b d1		; $80FA40: 85 57
	lda.b d4		; $80FA42: A5 63
	adc.w #$0006		; $80FA44: 69 06 00
	sta.b d4		; $80FA47: 85 63
	sta.b mula		; $80FA49: 85 7D
	lda.b d0		; $80FA4B: A5 53
	sta.b mulb		; $80FA4D: 85 83
	jsl.l muls32		; $80FA4F: 22 DB FC 82
	lda.b d2		; $80FA53: A5 5B
	sta.b mula		; $80FA55: 85 7D
	jsl.l divs		; $80FA57: 22 6C 99 80
	sta.b d0		; $80FA5B: 85 53
.de4:
	lda.b d1		; $80FA5D: A5 57
	clc		; $80FA5F: 18
	adc.b d3		; $80FA60: 65 5F
	sta.b d1		; $80FA62: 85 57
	sta.b d2		; $80FA64: 85 5B
	ldy.w #$0002		; $80FA66: A0 02 00  puckcross frames til crossing < $14?
	lda.b [a0],y		; $80FA69: B7 33
	cmp.w #$0014		; $80FA6B: C9 14 00
	bcc .cross		; $80FA6E: 90 03
	jmp.w .de5		; $80FA70: 4C 7E FB
.cross:		;puck crossing the goal line soon?
	lda.b [a0]		; $80FA73: A7 33
	bit.w #$8000		; $80FA75: 89 00 80
	beq .cx		; $80FA78: F0 04
	eor.w #$FFFF		; $80FA7A: 49 FF FF
	inc a		; $80FA7D: 1A
.cx:
	cmp.w #$0019		; $80FA7E: C9 19 00
	bcc .cz		; $80FA81: 90 03
	jmp.w .rush		; $80FA83: 4C 15 FC
.cz:
	lda.b [a0],y		; $80FA86: B7 33
	cmp.w #$000C		; $80FA88: C9 0C 00
	bcc .cy		; $80FA8B: 90 03
	jmp.w .de8		; $80FA8D: 4C 49 FB
.cy:
	lda.w pucky		; $80FA90: AD 7B 09
	bit.w #$8000		; $80FA93: 89 00 80
	beq .cy2		; $80FA96: F0 04
	eor.w #$FFFF		; $80FA98: 49 FF FF
	inc a		; $80FA9B: 1A
.cy2:
	cmp.w #$0109		; $80FA9C: C9 09 01
	bcc .aip		; $80FA9F: 90 03
	jmp.w .de8		; $80FAA1: 4C 49 FB
.aip:
	lda.w pf2aip,x		; $80FAA4: BD DF 11
	beq .save		; $80FAA7: F0 03
	jmp.w .de8		; $80FAA9: 4C 49 FB
.save:		;pick the save anim: glove side by the direction, stick when low and slow, stack
	inc.w pf2aip,x		; $80FAAC: FE DF 11
	lda.b [a0]		; $80FAAF: A7 33
	sec		; $80FAB1: 38
	sbc.w Xpos,x		; $80FAB2: FD FF 08
	sta.b d0		; $80FAB5: 85 53
	lda.b d3		; $80FAB7: A5 5F
	sec		; $80FAB9: 38
	sbc.w Ypos,x		; $80FABA: FD 5F 09
	sta.b d1		; $80FABD: 85 57
	jsl.l vtoa		; $80FABF: 22 A8 AF 80
	lda.b d0		; $80FAC3: A5 53
	sec		; $80FAC5: 38
	sbc.w facedir,x		; $80FAC6: FD BF 0D
	and.w #$0007		; $80FAC9: 29 07 00
	sta.b d3		; $80FACC: 85 5F
	lsr a		; $80FACE: 4A
	lsr a		; $80FACF: 4A
	sta.b d0		; $80FAD0: 85 53
	lda.w attribute,x		; $80FAD2: BD DF 09
	bit.w #$0800		; $80FAD5: 89 00 08
	beq .noflip		; $80FAD8: F0 07
	lda.b d0		; $80FADA: A5 53
	eor.w #$0001		; $80FADC: 49 01 00
	sta.b d0		; $80FADF: 85 53
.noflip:
	lda.w Zpos+puckobj		; $80FAE1: AD BB 09  puck low (Zpos <= 8) and slow: stick (+4)
	sec		; $80FAE4: 38
	sbc.w #$0008		; $80FAE5: E9 08 00
	beq .pz		; $80FAE8: F0 08
	bmi .v4		; $80FAEA: 30 04
	bvs .pz		; $80FAEC: 70 04
	bra .de7		; $80FAEE: 80 3B
.v4:
	bvs .de7		; $80FAF0: 70 39
.pz:
	lda.w puckvz		; $80FAF2: AD 3B 0B
	sec		; $80FAF5: 38
	sbc.w #$0800		; $80FAF6: E9 00 08
	beq .stick		; $80FAF9: F0 08
	bmi .v5		; $80FAFB: 30 04
	bvs .stick		; $80FAFD: 70 04
	bra .de7		; $80FAFF: 80 2A
.v5:
	bvs .de7		; $80FB01: 70 28
.stick:
	lda.b d0		; $80FB03: A5 53
	clc		; $80FB05: 18
	adc.w #$0004		; $80FB06: 69 04 00
	sta.b d0		; $80FB09: 85 53
	ldy.w #$0002		; $80FB0B: A0 02 00  more than 8 frames, facing up/down, puck carried: stack (-2)
	lda.b [a0],y		; $80FB0E: B7 33
	cmp.w #$0009		; $80FB10: C9 09 00
	bcc .de7		; $80FB13: 90 16
	lda.w facedir,x		; $80FB15: BD BF 0D
	cmp.w #$0002		; $80FB18: C9 02 00
	beq .de7		; $80FB1B: F0 0E
	cmp.w #$0006		; $80FB1D: C9 06 00
	beq .de7		; $80FB20: F0 09
	lda.w puckc		; $80FB22: AD BB 0E
	bmi .de7		; $80FB25: 30 04
	dec.b d0		; $80FB27: C6 53
	dec.b d0		; $80FB29: C6 53
.de7:
	asl.b d0		; $80FB2B: 06 53
	lda.w #GoalieSaveList		; $80FB2D: A9 70 FD
	sta.b a1		; $80FB30: 85 37
	lda.w #GoalieSaveList>>16		; $80FB32: A9 80 00
	sta.b a1+2		; $80FB35: 85 39
	ldy.b d0		; $80FB37: A4 53
	lda.b [a1],y		; $80FB39: B7 37
	sta.b d1		; $80FB3B: 85 57
	jsl.l SetSPA		; $80FB3D: 22 06 B0 80
	lda.b crowdlevel		; $80FB41: A5 DE  crowd +150
	clc		; $80FB43: 18
	adc.w #$0096		; $80FB44: 69 96 00
	sta.b crowdlevel		; $80FB47: 85 DE
.de8:
	lda.b [a0]		; $80FB49: A7 33
	sta.b d0		; $80FB4B: 85 53
	lda.w pucky		; $80FB4D: AD 7B 09  puck near the goal line: hug the post (+-$18)
	sec		; $80FB50: 38
	sbc.w #$00FC		; $80FB51: E9 FC 00
	beq .p2		; $80FB54: F0 08
	bmi .v6		; $80FB56: 30 04
	bvs .p2		; $80FB58: 70 04
	bra .post		; $80FB5A: 80 13
.v6:
	bvs .post		; $80FB5C: 70 11
.p2:
	lda.w pucky		; $80FB5E: AD 7B 09
	sec		; $80FB61: 38
	sbc.w #$FF04		; $80FB62: E9 04 FF
	beq .post		; $80FB65: F0 08
	bmi .v7		; $80FB67: 30 04
	bvs .post		; $80FB69: 70 04
	bra .de5		; $80FB6B: 80 11
.v7:
	bvs .de5		; $80FB6D: 70 0F
.post:		;hug the post
	lda.w #$0018		; $80FB6F: A9 18 00
	sta.b d0		; $80FB72: 85 53
	lda.w puckx		; $80FB74: AD 1B 09
	bpl .de5		; $80FB77: 10 05
	lda.w #$FFE8		; $80FB79: A9 E8 FF
	sta.b d0		; $80FB7C: 85 53
.de5:		;skate toward d0/d2 minus the velocity
	lda.b d2		; $80FB7E: A5 5B
	sta.b d1		; $80FB80: 85 57
	pha		; $80FB82: 48
	lda.b d0		; $80FB83: A5 53
	pha		; $80FB85: 48
	lda.w Xvel,x		; $80FB86: BD DF 0A
	xba		; $80FB89: EB
	and.w #$00FF		; $80FB8A: 29 FF 00
	bit.w #$0080		; $80FB8D: 89 80 00
	beq .vx		; $80FB90: F0 03
	ora.w #$FF00		; $80FB92: 09 00 FF
.vx:
	eor.w #$FFFF		; $80FB95: 49 FF FF
	inc a		; $80FB98: 1A
	sta.b d0		; $80FB99: 85 53
	pla		; $80FB9B: 68
	clc		; $80FB9C: 18
	adc.b d0		; $80FB9D: 65 53
	sec		; $80FB9F: 38
	sbc.w Xpos,x		; $80FBA0: FD FF 08
	sta.b d0		; $80FBA3: 85 53
	lda.w Yvel,x		; $80FBA5: BD FF 0A
	xba		; $80FBA8: EB
	and.w #$00FF		; $80FBA9: 29 FF 00
	bit.w #$0080		; $80FBAC: 89 80 00
	beq .vy		; $80FBAF: F0 03
	ora.w #$FF00		; $80FBB1: 09 00 FF
.vy:
	eor.w #$FFFF		; $80FBB4: 49 FF FF
	inc a		; $80FBB7: 1A
	sta.b d1		; $80FBB8: 85 57
	pla		; $80FBBA: 68
	clc		; $80FBBB: 18
	adc.b d1		; $80FBBC: 65 57
	sec		; $80FBBE: 38
	sbc.w Ypos,x		; $80FBBF: FD 5F 09
	sta.b d1		; $80FBC2: 85 57
	lda.w #$0005		; $80FBC4: A9 05 00  within 5 (10 with the puck): stop
	sta.b tmp0		; $80FBC7: 85 73
	txa		; $80FBC9: 8A
	lsr a		; $80FBCA: 4A
	cmp.w puckc		; $80FBCB: CD BB 0E
	bne .near2		; $80FBCE: D0 02
	asl.b tmp0		; $80FBD0: 06 73
.near2:
	lda.b d0		; $80FBD2: A5 53
	bit.w #$8000		; $80FBD4: 89 00 80
	beq .nx		; $80FBD7: F0 04
	eor.w #$FFFF		; $80FBD9: 49 FF FF
	inc a		; $80FBDC: 1A
.nx:
	cmp.b tmp0		; $80FBDD: C5 73
	bcs .vt		; $80FBDF: B0 13
	lda.b d1		; $80FBE1: A5 57
	bit.w #$8000		; $80FBE3: 89 00 80
	beq .ny		; $80FBE6: F0 04
	eor.w #$FFFF		; $80FBE8: 49 FF FF
	inc a		; $80FBEB: 1A
.ny:
	cmp.b tmp0		; $80FBEC: C5 73
	bcs .vt		; $80FBEE: B0 04
	stz.b d0		; $80FBF0: 64 53
	stz.b d1		; $80FBF2: 64 57
.vt:
	jsl.l vtoa		; $80FBF4: 22 A8 AF 80
	lda.b d0		; $80FBF8: A5 53
	sta.w temp2b,x		; $80FBFA: 9D FF 0C
.nodec:
	lda.w temp2b,x		; $80FBFD: BD FF 0C  direction > 7: StopNA, else playeracc
	sta.b d2		; $80FC00: 85 5B
	sec		; $80FC02: 38
	sbc.w #$0007		; $80FC03: E9 07 00
	beq .acc		; $80FC06: F0 04
	bmi .v8		; $80FC08: 30 06
	bvc .stop		; $80FC0A: 50 06
.acc:
	jml.l $8FE164		; $80FC0C: 5C 64 E1 8F  bank $8F: 93G playeracc
.v8:
	bvc .acc		; $80FC10: 50 FA
.stop:
	jmp.w StopNA		; $80FC12: 4C 52 84
.rush:		;rush a loose puck when the tmnear stats say so
	lda.w puckc		; $80FC15: AD BB 0E
	bmi .r1		; $80FC18: 30 03
	jmp.w .de5		; $80FC1A: 4C 7E FB
.r1:
	lda.w iflags		; $80FC1D: AD 5C 01  icing possible: no rush
	bit.w #ifok		; $80FC20: 89 04 00
	beq .r2		; $80FC23: F0 03
	jmp.w .de5		; $80FC25: 4C 7E FB
.r2:
	stz.b a1		; $80FC28: 64 37
	lda.w #$0002		; $80FC2A: A9 02 00
	sta.b a2		; $80FC2D: 85 3B
	lda.w pfteam,x		; $80FC2F: BD 9F 11
	beq .t0		; $80FC32: F0 07
	stz.b a2		; $80FC34: 64 3B
	lda.w #$0002		; $80FC36: A9 02 00
	sta.b a1		; $80FC39: 85 37
.t0:
	ldy.b a1		; $80FC3B: A4 37  tmnear of my team >= $1324 and of the other >= $9C4
	lda.w tmnear,y		; $80FC3D: B9 FA 13
	cmp.w #$1324		; $80FC40: C9 24 13
	lda.w tmnear+4,y		; $80FC43: B9 FE 13
	sbc.w #$0000		; $80FC46: E9 00 00
	bcs .t1		; $80FC49: B0 03
	jmp.w .de5		; $80FC4B: 4C 7E FB
.t1:
	ldy.b a2		; $80FC4E: A4 3B
	lda.w tmnear,y		; $80FC50: B9 FA 13
	cmp.w #$09C4		; $80FC53: C9 C4 09
	lda.w tmnear+4,y		; $80FC56: B9 FE 13
	sbc.w #$0000		; $80FC59: E9 00 00
	bcs .r3		; $80FC5C: B0 03
	jmp.w .de5		; $80FC5E: 4C 7E FB
.r3:
	lda.w pucky		; $80FC61: AD 7B 09  puck near my end, moving toward me, mostly in y
	sbc.w #$00E0		; $80FC64: E9 E0 00
	beq .r4		; $80FC67: F0 08
	bmi .v9		; $80FC69: 30 04
	bvs .r4		; $80FC6B: 70 04
	bra .dir		; $80FC6D: 80 14
.v9:
	bvs .dir		; $80FC6F: 70 12
.r4:
	lda.w pucky		; $80FC71: AD 7B 09
	sec		; $80FC74: 38
	sbc.w #$FF20		; $80FC75: E9 20 FF
	beq .dir		; $80FC78: F0 09
	bmi .v10		; $80FC7A: 30 05
	bvs .dir		; $80FC7C: 70 05
.de5j:
	jmp.w .de5		; $80FC7E: 4C 7E FB
.v10:
	bvs .de5j		; $80FC81: 70 FB
.dir:
	lda.w puckvy		; $80FC83: AD 1B 0B
	sta.b tmp0		; $80FC86: 85 73
	lda.w pfgoal,x		; $80FC88: BD 3F 11
	beq .dir2		; $80FC8B: F0 08
	lda.b tmp0		; $80FC8D: A5 73
	eor.w #$FFFF		; $80FC8F: 49 FF FF
	inc a		; $80FC92: 1A
	sta.b tmp0		; $80FC93: 85 73
.dir2:
	lda.b tmp0		; $80FC95: A5 73
	bpl .ax2		; $80FC97: 10 03
	jmp.w .de5		; $80FC99: 4C 7E FB
.ax2:
	lda.w puckvx		; $80FC9C: AD FB 0A
	bit.w #$8000		; $80FC9F: 89 00 80
	beq .axs		; $80FCA2: F0 04
	eor.w #$FFFF		; $80FCA4: 49 FF FF
	inc a		; $80FCA7: 1A
.axs:
	sta.b d0		; $80FCA8: 85 53
	lda.w puckvy		; $80FCAA: AD 1B 0B
	bit.w #$8000		; $80FCAD: 89 00 80
	beq .ay2		; $80FCB0: F0 04
	eor.w #$FFFF		; $80FCB2: 49 FF FF
	inc a		; $80FCB5: 1A
.ay2:
	sta.b d1		; $80FCB6: 85 57
	lda.b d1		; $80FCB8: A5 57
	cmp.b d0		; $80FCBA: C5 53
	bcs .ins		; $80FCBC: B0 03
	jmp.w .de5		; $80FCBE: 4C 7E FB
.ins:
	lda.w #agoalietopuck		; $80FCC1: A9 0F 00  agoalietopuck
	sta.b d0		; $80FCC4: 85 53
	jmp.w assinsert		; $80FCC6: 4C 9D B4
ClampYPosition:		;auto: CODE_80FCC9. 93G ClampYPosition (logic93_3): d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if X has the puck
	lda.w puckc		; $80FCC9: AD BB 0E
	sta.b d2		; $80FCCC: 85 5B
	cmp.w SCnum,x		; $80FCCE: DD 9F 0D
	bne .zero		; $80FCD1: D0 02
	stz.b d0		; $80FCD3: 64 53
.zero:
	lda.b d1		; $80FCD5: A5 57
	sec		; $80FCD7: 38
	sbc.w #$0103		; $80FCD8: E9 03 01
	bmi .v1		; $80FCDB: 30 04
	bvc .hi		; $80FCDD: 50 04
	bra .one		; $80FCDF: 80 07
.v1:
	bvc .one		; $80FCE1: 50 05
.hi:
	lda.w #$0103		; $80FCE3: A9 03 01
	sta.b d1		; $80FCE6: 85 57
.one:
	lda.b d1		; $80FCE8: A5 57
	sec		; $80FCEA: 38
	sbc.w #$FEFD		; $80FCEB: E9 FD FE
	beq .lo		; $80FCEE: F0 08
	bmi .v2		; $80FCF0: 30 04
	bvs .lo		; $80FCF2: 70 04
	bra .two		; $80FCF4: 80 07
.v2:
	bvs .two		; $80FCF6: 70 05
.lo:
	lda.w #$FEFD		; $80FCF8: A9 FD FE
	sta.b d1		; $80FCFB: 85 57
.two:
	lda.b d1		; $80FCFD: A5 57
	sec		; $80FCFF: 38
	sbc.b d3		; $80FD00: E5 5F
	sta.b d1		; $80FD02: 85 57
	rtl		; $80FD04: 6B
AdjustFacingDirection:		;auto: CODE_80FD05. 93G AdjustFacingDirection (logic93_3): turn facedir of goalie X one step toward d0, not past the sides of the net
	lda.w facedir,x		; $80FD05: BD BF 0D
	sta.b d1		; $80FD08: 85 57
	lda.b d0		; $80FD0A: A5 53
	sec		; $80FD0C: 38
	sbc.b d1		; $80FD0D: E5 57
	sta.b d0		; $80FD0F: 85 53
	bne .turn		; $80FD11: D0 03
	jmp.w assgoalie_rtl		; $80FD13: 4C D0 F8
.turn:
	eor.w #$FFFF		; $80FD16: 49 FF FF
	inc a		; $80FD19: 1A
	and.w #$0004		; $80FD1A: 29 04 00
	lsr a		; $80FD1D: 4A
	dec a		; $80FD1E: 3A
	sta.b d0		; $80FD1F: 85 53
	lda.b d1		; $80FD21: A5 57
	cmp.w #$0001		; $80FD23: C9 01 00
	beq .add		; $80FD26: F0 05
	cmp.w #$0006		; $80FD28: C9 06 00
	bne .dn		; $80FD2B: D0 31
.add:
	clc		; $80FD2D: 18
	adc.b d0		; $80FD2E: 65 53
	sta.b d1		; $80FD30: 85 57
	lda.w pfgoal,x		; $80FD32: BD 3F 11
	bne .other		; $80FD35: D0 0E
	lda.b d1		; $80FD37: A5 57
	cmp.w #$0002		; $80FD39: C9 02 00
	bcc .neg		; $80FD3C: 90 13
	cmp.w #$0007		; $80FD3E: C9 07 00
	beq .neg		; $80FD41: F0 0E
	bra .set		; $80FD43: 80 20
.other:
	lda.b d1		; $80FD45: A5 57
	cmp.w #$0003		; $80FD47: C9 03 00
	bcc .set		; $80FD4A: 90 19
	cmp.w #$0006		; $80FD4C: C9 06 00
	bcs .set		; $80FD4F: B0 14
.neg:
	lda.b d0		; $80FD51: A5 53
	eor.w #$FFFF		; $80FD53: 49 FF FF
	inc a		; $80FD56: 1A
	sta.b d0		; $80FD57: 85 53
	clc		; $80FD59: 18
	adc.b d1		; $80FD5A: 65 57
	sta.b d1		; $80FD5C: 85 57
.dn:
	lda.b d1		; $80FD5E: A5 57
	clc		; $80FD60: 18
	adc.b d0		; $80FD61: 65 53
	sta.b d1		; $80FD63: 85 57
.set:
	lda.b d1		; $80FD65: A5 57
	and.w #$0007		; $80FD67: 29 07 00
	sta.b d1		; $80FD6A: 85 57
	sta.w facedir,x		; $80FD6C: 9D BF 0D
	rtl		; $80FD6F: 6B
GoalieSaveList:		;93G GoalieSaveList (logic93_3): save anims by index: glove 0/1, stack 2/3, stick 4/5
	dw SPAgglover,SPAgglovel,SPAgstackr,SPAgstackl,SPAgstickr,SPAgstickl		; $80FD70
checkgoalp_CalcGoalShotDir:		;auto: CODE_80FD7C. 93G checkgoalp_CalcGoalShotDir (logic93_1): if the opposing goalie covers the middle of the net, passdir 2 or 6 to shoot at the open side, else 0. Skipped for joystick players
	lda.w pflags,x		; $80FD7C: BD DF 0E  joystick player: skip
	bit.w #pfjoycon		; $80FD7F: 89 08 00
	beq .go		; $80FD82: F0 03
	jmp.w .rtl		; $80FD84: 4C 88 FE
.go:
	lda.w #$0008		; $80FD87: A9 08 00
	sta.b d0		; $80FD8A: 85 53
	lda.w #$0005		; $80FD8C: A9 05 00
	sta.b d1		; $80FD8F: 85 57
	lda.w #$FFFE		; $80FD91: A9 FE FF
	sta.b a0		; $80FD94: 85 33
	lda.w pfteam,x		; $80FD96: BD 9F 11
	bne .g		; $80FD99: D0 05
	lda.w #$000A		; $80FD9B: A9 0A 00
	sta.b a0		; $80FD9E: 85 33
.g:		;IDA CheckOpponentGoalie: find position 0 on the other team
	inc.b a0		; $80FDA0: E6 33
	inc.b a0		; $80FDA2: E6 33
	ldy.b a0		; $80FDA4: A4 33
	lda.w position,y		; $80FDA6: B9 9F 0B
	beq .found		; $80FDA9: F0 07
	dec.b d1		; $80FDAB: C6 57
	bpl .g		; $80FDAD: 10 F1
	jmp.w .x		; $80FDAF: 4C 83 FE
.found:		;goalie x/y + half his velocity - puck; d2 = distance
	lda.w Xvel+1,y		; $80FDB2: B9 E0 0A
	and.w #$00FF		; $80FDB5: 29 FF 00
	bit.w #$0080		; $80FDB8: 89 80 00
	beq .gx		; $80FDBB: F0 03
	ora.w #$FF00		; $80FDBD: 09 00 FF
.gx:
	pha		; $80FDC0: 48
	asl a		; $80FDC1: 0A
	pla		; $80FDC2: 68
	ror a		; $80FDC3: 6A
	clc		; $80FDC4: 18
	adc.w Xpos,y		; $80FDC5: 79 FF 08
	sec		; $80FDC8: 38
	sbc.w puckx		; $80FDC9: ED 1B 09
	sta.b d0		; $80FDCC: 85 53
	lda.w Yvel+1,y		; $80FDCE: B9 00 0B
	and.w #$00FF		; $80FDD1: 29 FF 00
	bit.w #$0080		; $80FDD4: 89 80 00
	beq .gy		; $80FDD7: F0 03
	ora.w #$FF00		; $80FDD9: 09 00 FF
.gy:
	pha		; $80FDDC: 48
	asl a		; $80FDDD: 0A
	pla		; $80FDDE: 68
	ror a		; $80FDDF: 6A
	clc		; $80FDE0: 18
	adc.w Ypos,y		; $80FDE1: 79 5F 09
	sec		; $80FDE4: 38
	sbc.w pucky		; $80FDE5: ED 7B 09
	sta.b d1		; $80FDE8: 85 57
	pha		; $80FDEA: 48
	lda.b d0		; $80FDEB: A5 53
	pha		; $80FDED: 48
	sta.b mula		; $80FDEE: 85 7D
	sta.b mulb		; $80FDF0: 85 83
	jsl.l muls32		; $80FDF2: 22 DB FC 82
	sta.b d0		; $80FDF6: 85 53
	lda.b mulres+2		; $80FDF8: A5 95
	sta.b d0+2		; $80FDFA: 85 55
	lda.b d1		; $80FDFC: A5 57
	sta.b mula		; $80FDFE: 85 7D
	sta.b mulb		; $80FE00: 85 83
	jsl.l muls32		; $80FE02: 22 DB FC 82
	sec		; $80FE06: 38
	adc.b d0		; $80FE07: 65 53
	sta.b d0		; $80FE09: 85 53
	lda.b mulres+2		; $80FE0B: A5 95
	adc.b d0+2		; $80FE0D: 65 55
	sta.b d0+2		; $80FE0F: 85 55
	jsl.l sroot		; $80FE11: 22 B1 CB 80
	lda.b d0		; $80FE15: A5 53
	sta.b d2		; $80FE17: 85 5B
	pla		; $80FE19: 68
	sta.b d0		; $80FE1A: 85 53
	pla		; $80FE1C: 68
	sta.b d1		; $80FE1D: 85 57
	lda.w #$0012		; $80FE1F: A9 12 00  d3/d4 = post x/goal y
	sta.b d3		; $80FE22: 85 5F
	lda.w #$0108		; $80FE24: A9 08 01
	sta.b d4		; $80FE27: 85 63
	lda.w pfgoal,x		; $80FE29: BD 3F 11
	bne .l		; $80FE2C: D0 05
	lda.w #$FEF8		; $80FE2E: A9 F8 FE
	sta.b d4		; $80FE31: 85 63
.l:		;IDA CalcLeftAngle: posts at x +-18, y +-$108
	lda.b d4		; $80FE33: A5 63
	pha		; $80FE35: 48
	lda.b d3		; $80FE36: A5 5F
	pha		; $80FE38: 48
	jsl.l CalcAngleOffset		; $80FE39: 22 89 FE 80
	lda.b d4		; $80FE3D: A5 63
	sta.b d5		; $80FE3F: 85 67
	pla		; $80FE41: 68
	eor.w #$FFFF		; $80FE42: 49 FF FF
	inc a		; $80FE45: 1A
	sta.b d3		; $80FE46: 85 5F
	pla		; $80FE48: 68
	sta.b d4		; $80FE49: 85 63
	jsl.l CalcAngleOffset		; $80FE4B: 22 89 FE 80
	lda.b d4		; $80FE4F: A5 63
	clc		; $80FE51: 18
	adc.b d5		; $80FE52: 65 67
	sta.b d4		; $80FE54: 85 63
	stz.b d0		; $80FE56: 64 53
	lda.b d4		; $80FE58: A5 63
	bit.w #$8000		; $80FE5A: 89 00 80
	beq .abs		; $80FE5D: F0 04
	eor.w #$FFFF		; $80FE5F: 49 FF FF
	inc a		; $80FE62: 1A
.abs:
	cmp.w #$002D		; $80FE63: C9 2D 00  |angle| < 45: shoot at the open side
	bcs .x		; $80FE66: B0 1B
	lda.w pfgoal,x		; $80FE68: BD 3F 11
	beq .s		; $80FE6B: F0 08
	lda.b d4		; $80FE6D: A5 63
	eor.w #$FFFF		; $80FE6F: 49 FF FF
	inc a		; $80FE72: 1A
	sta.b d4		; $80FE73: 85 63
.s:		;IDA SetShotDirection
	lda.w #$0002		; $80FE75: A9 02 00
	sta.b d0		; $80FE78: 85 53
	lda.b d4		; $80FE7A: A5 63
	bpl .x		; $80FE7C: 10 05
	lda.w #$0006		; $80FE7E: A9 06 00
	sta.b d0		; $80FE81: 85 53
.x:		;IDA ReturnDefaultDir
	lda.b d0		; $80FE83: A5 53
	sta.w passdir		; $80FE85: 8D 3B 04
.rtl:
	rtl		; $80FE88: 6B
CalcAngleOffset:		;auto: CODE_80FE89. 93G CalcAngleOffset (logic93_1): d4 = (goalie vector d0/d1 x post vector d3/d4 from the puck) / d2
	lda.b d3		; $80FE89: A5 5F
	sec		; $80FE8B: 38
	sbc.w puckx		; $80FE8C: ED 1B 09
	sta.b d3		; $80FE8F: 85 5F
	lda.b d4		; $80FE91: A5 63
	sec		; $80FE93: 38
	sbc.w pucky		; $80FE94: ED 7B 09
	sta.b mulb		; $80FE97: 85 83
	lda.b d0		; $80FE99: A5 53
	sta.b mula		; $80FE9B: 85 7D
	jsl.l muls32		; $80FE9D: 22 DB FC 82
	sta.b d4		; $80FEA1: 85 63
	lda.b mulres+2		; $80FEA3: A5 95
	sta.b d4+2		; $80FEA5: 85 65
	lda.b d1		; $80FEA7: A5 57
	sta.b mula		; $80FEA9: 85 7D
	lda.b d3		; $80FEAB: A5 5F
	sta.b mulb		; $80FEAD: 85 83
	jsl.l muls32		; $80FEAF: 22 DB FC 82
	sta.b d3		; $80FEB3: 85 5F
	lda.b mulres+2		; $80FEB5: A5 95
	sta.b d3+2		; $80FEB7: 85 61
	lda.b d4		; $80FEB9: A5 63
	sec		; $80FEBB: 38
	sbc.b d3		; $80FEBC: E5 5F
	sta.b mulb		; $80FEBE: 85 83
	lda.b d4+2		; $80FEC0: A5 65
	sbc.b d3+2		; $80FEC2: E5 61
	sta.b mulb+2		; $80FEC4: 85 85
	lda.b d2		; $80FEC6: A5 5B
	sta.b mula		; $80FEC8: 85 7D
	jsl.l divs		; $80FECA: 22 6C 99 80
	sta.b d4		; $80FECE: 85 63
	rtl		; $80FED0: 6B
reenergizeteam:		;auto: CODE_80FED1. 93G reenergizeteam (penalty93_2): max energy for every player of team a2; TMPDOUT players go to the bench
	lda.w #$0032		; $80FED1: A9 32 00
	sta.b d0		; $80FED4: 85 53
.top:
	lda.b a2		; $80FED6: A5 3B
	beq .tm		; $80FED8: F0 03
	lda.w #$0034		; $80FEDA: A9 34 00
.tm:
	clc		; $80FEDD: 18
	adc.b d0		; $80FEDE: 65 53
	tay		; $80FEE0: A8
	lda.w #$1000		; $80FEE1: A9 00 10  max energy
	sta.w tmpde,y		; $80FEE4: 99 7A 14
	lda.w tmpdst,y		; $80FEE7: B9 E2 14  out: back to the bench
	cmp.w #TMPDOUT		; $80FEEA: C9 FD FF
	bne .nb		; $80FEED: D0 06
	lda.w #TMPDBENCH		; $80FEEF: A9 FE FF
	sta.w tmpdst,y		; $80FEF2: 99 E2 14
.nb:
	dec.b d0		; $80FEF5: C6 53
	dec.b d0		; $80FEF7: C6 53
	bpl .top		; $80FEF9: 10 DB
	rtl		; $80FEFB: 6B
unusedFF:		;unused, $FF fill up to the internal header
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FEFC
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF0C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF1C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF2C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF3C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF4C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF5C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF6C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF7C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF8C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FF9C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $80FFAC
	db $FF,$FF,$FF,$FF		; $80FFBC
	db "NHLPA Hockey '93     "		; $80FFC0 title (21 bytes)
	db $30		; $80FFD5 map mode: LoROM, FastROM
	db $00		; $80FFD6 cartridge type: ROM only
	db $09		; $80FFD7 ROM size: 512 KB
	db $00		; $80FFD8 SRAM size: none
	db $01		; $80FFD9 country: USA
	db $69		; $80FFDA licensee: Electronic Arts
	db $00		; $80FFDB version
	dw $B75A		; $80FFDC checksum complement
	dw $48A5		; $80FFDE checksum
	db $FF,$FF,$FF,$FF		; $80FFE0 native mode vectors:
	dw VBjsr&$FFFF		; $80FFE4 COP
	dw BRKHalt&$FFFF		; $80FFE6 BRK
	dw VBjsr&$FFFF		; $80FFE8 ABORT
	dw VBjsr&$FFFF		; $80FFEA NMI
	dw Start&$FFFF		; $80FFEC (unused)
	dw HBjsr&$FFFF		; $80FFEE IRQ
	db $FF,$FF,$FF,$FF		; $80FFF0 emulation mode vectors:
	dw VBjsr&$FFFF		; $80FFF4 COP
	dw VBjsr&$FFFF		; $80FFF6 (unused)
	dw VBjsr&$FFFF		; $80FFF8 ABORT
	dw VBjsr&$FFFF		; $80FFFA NMI
	dw Start&$FFFF		; $80FFFC RESET
	dw HBjsr&$FFFF		; $80FFFE IRQ/BRK
