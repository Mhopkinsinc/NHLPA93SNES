; $88F002-$88FFFF  ROM $47002  (from src/bank88.asm; quick pass, TODO segment agents refine)
org $88F002
	sta.b $37		; $88F002: 85 37
	lda.w #$0000		; $88F004: A9 00 00
	sta.b $39		; $88F007: 85 39
	lda.w #$000D		; $88F009: A9 0D 00
	sta.b [$37]		; $88F00C: 87 37
	inc.b $37		; $88F00E: E6 37
	inc.b $37		; $88F010: E6 37
CODE_88F012:		; M=16 X=16
	lda.b [$33]		; $88F012: A7 33
	sta.b [$37]		; $88F014: 87 37
	inc.b $33		; $88F016: E6 33
	inc.b $37		; $88F018: E6 37
	lda.w #$0020		; $88F01A: A9 20 00
	sta.b [$37]		; $88F01D: 87 37
	inc.b $37		; $88F01F: E6 37
	dec.b $57		; $88F021: C6 57
	bpl CODE_88F012		; $88F023: 10 ED
	lda.w #$0191		; $88F025: A9 91 01
	sta.b $37		; $88F028: 85 37
	lda.w #$0000		; $88F02A: A9 00 00
	sta.b $39		; $88F02D: 85 39
	jsl.l $80B92D		; $88F02F: 22 2D B9 80
	inc.w $047D		; $88F033: EE 7D 04
	inc.w $047D		; $88F036: EE 7D 04
	lda.w $047B		; $88F039: AD 7B 04
	sec		; $88F03C: 38
	sbc.w #$000B		; $88F03D: E9 0B 00
	sta.w $047B		; $88F040: 8D 7B 04
	dec.b $53		; $88F043: C6 53
	bpl CODE_88EFFA		; $88F045: 10 B3
	stz.b $63		; $88F047: 64 63
	stz.b $67		; $88F049: 64 67
	jsl.l $88F19F		; $88F04B: 22 9F F1 88
	jsl.l $88F1BB		; $88F04F: 22 BB F1 88
	jsl.l $8FD69F		; $88F053: 22 9F D6 8F
CODE_88F057:		; M=16 X=16
	jsl.l $80B90C		; $88F057: 22 0C B9 80
	ora.b ($00,s),y		; $88F05B: 13 00
	sbc.l $441302,x		; $88F05D: FF 02 13 44
	jsr.w $6150		; $88F061: 20 50 61
	stz.b $20		; $88F064: 64 20
	and.w $5320		; $88F066: 2D 20 53
	adc.b $6C		; $88F069: 65 6C
	adc.b $63		; $88F06B: 65 63
	stz.b $22,x		; $88F06D: 74 22
	tsb.w $80B9		; $88F06F: 0C B9 80
	ora.b ($00),y		; $88F072: 11 00
	sbc.l $201402,x		; $88F074: FF 02 14 20
	jsr.w $2020		; $88F078: 20 20 20
	eor.b ($20,x)		; $88F07B: 41 20
	and.w $4E20		; $88F07D: 2D 20 4E
	adc.b $78		; $88F080: 65 78
	stz.b $22,x		; $88F082: 74 22
	tsb.w $80B9		; $88F084: 0C B9 80
	ora.b ($00),y		; $88F087: 11 00
	sbc.l $201502,x		; $88F089: FF 02 15 20
	jsr.w $2020		; $88F08D: 20 20 20
	eor.w $2D20,y		; $88F090: 59 20 2D
	jsr.w $6142		; $88F093: 20 42 61
	adc.b $6B,s		; $88F096: 63 6B
CODE_88F098:		; M=16 X=16
	jsl.l $80B90C		; $88F098: 22 0C B9 80
	ora.b $00		; $88F09C: 05 00
	sbc.l $221002,x		; $88F09E: FF 02 10 22
	sbc.b [$85],y		; $88F0A2: F7 85
	dey		; $88F0A4: 88
	lda.w #$81C5		; $88F0A5: A9 C5 81
CODE_88F0A8:		; M=16 X=16
	cmp.b $14		; $88F0A8: C5 14
	beq CODE_88F0A8		; $88F0AA: F0 FC
	jsl.l $8F8EF7		; $88F0AC: 22 F7 8E 8F
	jsl.l $8F8F28		; $88F0B0: 22 28 8F 8F
	lda.w #$81C5		; $88F0B4: A9 C5 81
	sta.b $14		; $88F0B7: 85 14
CODE_88F0B9:		; M=16 X=16
	jsl.l $80F3E8		; $88F0B9: 22 E8 F3 80
	lda.w $016E		; $88F0BD: AD 6E 01
	ora.w $0170		; $88F0C0: 0D 70 01
	beq CODE_88F0B9		; $88F0C3: F0 F4
	sta.b $57		; $88F0C5: 85 57
	bit.w #$1000		; $88F0C7: 89 00 10
	beq CODE_88F0CF		; $88F0CA: F0 03
	jmp.w $F1EB		; $88F0CC: 4C EB F1
CODE_88F0CF:		; M=16 X=16
	stz.b $53		; $88F0CF: 64 53
	dec.b $53		; $88F0D1: C6 53
	bit.w #$4000		; $88F0D3: 89 00 40
	bne CODE_88F105		; $88F0D6: D0 2D
	stz.b $53		; $88F0D8: 64 53
	inc.b $53		; $88F0DA: E6 53
	bit.w #$0080		; $88F0DC: 89 80 00
	bne CODE_88F105		; $88F0DF: D0 24
	bit.w #$0100		; $88F0E1: 89 00 01
	bne CODE_88F132		; $88F0E4: D0 4C
	stz.b $53		; $88F0E6: 64 53
	dec.b $53		; $88F0E8: C6 53
	bit.w #$0200		; $88F0EA: 89 00 02
	bne CODE_88F132		; $88F0ED: D0 43
	ldy.w #$0006		; $88F0EF: A0 06 00
	sty.b $53		; $88F0F2: 84 53
	bit.w #$0400		; $88F0F4: 89 00 04
	bne CODE_88F132		; $88F0F7: D0 39
	ldy.w #$FFFA		; $88F0F9: A0 FA FF
	sty.b $53		; $88F0FC: 84 53
	bit.w #$0800		; $88F0FE: 89 00 08
	bne CODE_88F132		; $88F101: D0 2F
	bra CODE_88F098		; $88F103: 80 93
CODE_88F105:		; M=16 X=16
	lda.b $63		; $88F105: A5 63
	clc		; $88F107: 18
	adc.b $53		; $88F108: 65 53
	cmp.w #$0010		; $88F10A: C9 10 00
	bcs CODE_88F098		; $88F10D: B0 89
	sta.b $63		; $88F10F: 85 63
	jsl.l $88F19F		; $88F111: 22 9F F1 88
	lda.w #$1610		; $88F115: A9 10 16
	sta.b $33		; $88F118: 85 33
	lda.w #$0000		; $88F11A: A9 00 00
	sta.b $35		; $88F11D: 85 35
	stz.b $53		; $88F11F: 64 53
	ldy.b $63		; $88F121: A4 63
	lda.b [$33],y		; $88F123: B7 33
	and.w #$00FF		; $88F125: 29 FF 00
	cmp.w #$001E		; $88F128: C9 1E 00
	bcs CODE_88F132		; $88F12B: B0 05
	sec		; $88F12D: 38
	sbc.b $67		; $88F12E: E5 67
	sta.b $53		; $88F130: 85 53
CODE_88F132:		; M=16 X=16
	lda.b $67		; $88F132: A5 67
	clc		; $88F134: 18
	adc.b $53		; $88F135: 65 53
	cmp.w #$001E		; $88F137: C9 1E 00
	bcc CODE_88F13F		; $88F13A: 90 03
	jmp.w $F098		; $88F13C: 4C 98 F0
CODE_88F13F:		; M=16 X=16
	pha		; $88F13F: 48
	jsl.l $88F1BB		; $88F140: 22 BB F1 88
	phx		; $88F144: DA
	lda.w $047D		; $88F145: AD 7D 04
	asl a		; $88F148: 0A
	asl a		; $88F149: 0A
	asl a		; $88F14A: 0A
	asl a		; $88F14B: 0A
	asl a		; $88F14C: 0A
	asl a		; $88F14D: 0A
	adc.w $047B		; $88F14E: 6D 7B 04
	adc.w $047B		; $88F151: 6D 7B 04
	tax		; $88F154: AA
	lda.w $1BE7		; $88F155: AD E7 1B
	sta.l $7E7674,x		; $88F158: 9F 74 76 7E
	sta.l $7E7676,x		; $88F15C: 9F 76 76 7E
	sta.l $7E7678,x		; $88F160: 9F 78 76 7E
	sta.l $7E76B4,x		; $88F164: 9F B4 76 7E
	sta.l $7E76B6,x		; $88F168: 9F B6 76 7E
	sta.l $7E76B8,x		; $88F16C: 9F B8 76 7E
	sta.l $7E76F4,x		; $88F170: 9F F4 76 7E
	sta.l $7E76F6,x		; $88F174: 9F F6 76 7E
	sta.l $7E76F8,x		; $88F178: 9F F8 76 7E
	plx		; $88F17C: FA
	pla		; $88F17D: 68
	sta.b $67		; $88F17E: 85 67
	jsl.l $88F1BB		; $88F180: 22 BB F1 88
	jsl.l $8FD69F		; $88F184: 22 9F D6 8F
	lda.w #$1610		; $88F188: A9 10 16
	sta.b $33		; $88F18B: 85 33
	lda.w #$0000		; $88F18D: A9 00 00
	sta.b $35		; $88F190: 85 35
	ldy.b $63		; $88F192: A4 63
	sep #$20		; $88F194: E2 20
	lda.b $67		; $88F196: A5 67
	sta.b [$33],y		; $88F198: 97 33
	rep #$30		; $88F19A: C2 30
	jmp.w $F098		; $88F19C: 4C 98 F0
CODE_88F19F:		; M=16 X=16
	jsl.l $80B90C		; $88F19F: 22 0C B9 80
	ora.b $00		; $88F1A3: 05 00
	inc.w $1101,x		; $88F1A5: FE 01 11
	lda.w $047B		; $88F1A8: AD 7B 04
	clc		; $88F1AB: 18
	adc.b $63		; $88F1AC: 65 63
	sta.w $047B		; $88F1AE: 8D 7B 04
	jsl.l $80B90C		; $88F1B1: 22 0C B9 80
	ora.b $00		; $88F1B5: 05 00
	jsr.w $203C		; $88F1B7: 20 3C 20
	rtl		; $88F1BA: 6B
CODE_88F1BB:		; M=16 X=16
	jsl.l $80B90C		; $88F1BB: 22 0C B9 80
	ora.b $00		; $88F1BF: 05 00
	inc.w $0D14,x		; $88F1C1: FE 14 0D
	lda.b $67		; $88F1C4: A5 67
	sta.b $83		; $88F1C6: 85 83
	lda.w #$0006		; $88F1C8: A9 06 00
	sta.b $7D		; $88F1CB: 85 7D
	jsl.l $80B8D8		; $88F1CD: 22 D8 B8 80
	asl a		; $88F1D1: 0A
	adc.w $047D		; $88F1D2: 6D 7D 04
	sta.w $047D		; $88F1D5: 8D 7D 04
	lda.b $95		; $88F1D8: A5 95
	asl a		; $88F1DA: 0A
	adc.w $047B		; $88F1DB: 6D 7B 04
	dec a		; $88F1DE: 3A
	dec a		; $88F1DF: 3A
	sta.w $047B		; $88F1E0: 8D 7B 04
	lda.w #$0003		; $88F1E3: A9 03 00
	sta.b $53		; $88F1E6: 85 53
	sta.b $57		; $88F1E8: 85 57
CODE_88F1EA:		; M=16 X=16
	rtl		; $88F1EA: 6B
CODE_88F1EB:		; M=16 X=16
	jsl.l $80F5EA		; $88F1EB: 22 EA F5 80
	lda.w $0451		; $88F1EF: AD 51 04
	bpl CODE_88F1EA		; $88F1F2: 10 F6
	jsl.l $80B90C		; $88F1F4: 22 0C B9 80
	ora.b ($00,s),y		; $88F1F8: 13 00
	sbc.l $421302,x		; $88F1FA: FF 02 13 42
	adc.b ($64,x)		; $88F1FE: 61 64
	jsr.w $6150		; $88F200: 20 50 61
	adc.b ($73,s),y		; $88F203: 73 73
	adc.b [$6F],y		; $88F205: 77 6F
	adc.b ($64)		; $88F207: 72 64
	jsr.w $2220		; $88F209: 20 20 22
	tsb.w $80B9		; $88F20C: 0C B9 80
	ora.b ($00,s),y		; $88F20F: 13 00
	sbc.l $411402,x		; $88F211: FF 02 14 41
	jsr.w $202D		; $88F215: 20 2D 20
	eor.b ($65)		; $88F218: 52 65
	stz.b $72,x		; $88F21A: 74 72
	adc.w $2020,y		; $88F21C: 79 20 20
	jsr.w $2020		; $88F21F: 20 20 20
	jsl.l $80B90C		; $88F222: 22 0C B9 80
	trb.b $00		; $88F226: 14 00
	sbc.l $591502,x		; $88F228: FF 02 15 59
	jsr.w $202D		; $88F22C: 20 2D 20
	eor.b $78		; $88F22F: 45 78
	adc.w #$2074		; $88F231: 69 74 20
	eor.b ($63,s),y		; $88F234: 53 63
	adc.b ($65)		; $88F236: 72 65
	adc.b $6E		; $88F238: 65 6E
	lda.w #$81C5		; $88F23A: A9 C5 81
CODE_88F23D:		; M=16 X=16
	cmp.b $14		; $88F23D: C5 14
	beq CODE_88F23D		; $88F23F: F0 FC
	jsl.l $8F8EF7		; $88F241: 22 F7 8E 8F
	jsl.l $8F8F28		; $88F245: 22 28 8F 8F
	lda.w #$81C5		; $88F249: A9 C5 81
	sta.b $14		; $88F24C: 85 14
CODE_88F24E:		; M=16 X=16
	jsl.l $80F3E8		; $88F24E: 22 E8 F3 80
	lda.w $016E		; $88F252: AD 6E 01
	ora.w $0170		; $88F255: 0D 70 01
	beq CODE_88F24E		; $88F258: F0 F4
	sta.b $57		; $88F25A: 85 57
	bit.w #$4000		; $88F25C: 89 00 40
	bne CODE_88F285		; $88F25F: D0 24
	bit.w #$0080		; $88F261: 89 80 00
	beq CODE_88F24E		; $88F264: F0 E8
	jsl.l $80B90C		; $88F266: 22 0C B9 80
	ora.b $00		; $88F26A: 05 00
	sbc.l $A91201,x		; $88F26C: FF 01 12 A9
	ora.b ($00),y		; $88F270: 11 00
	sta.b $53		; $88F272: 85 53
	lda.w #$0005		; $88F274: A9 05 00
	sta.b $57		; $88F277: 85 57
	lda.w $1BE7		; $88F279: AD E7 1B
	sta.b $5B		; $88F27C: 85 5B
	jsl.l $8D847C		; $88F27E: 22 7C 84 8D
	jmp.w $F057		; $88F282: 4C 57 F0
CODE_88F285:		; M=16 X=16
	lda.w #$0002		; $88F285: A9 02 00
	sta.w $1600		; $88F288: 8D 00 16
	jml.l $83FA87		; $88F28B: 5C 87 FA 83
	db $1E,$00,$FF,$02,$0E,$50,$61,$73,$73,$77,$6F,$72,$64,$FF,$0A,$18	; $88F28F
	db $50,$72,$65,$73,$73,$20,$53,$74,$61,$72,$74,$FF,$15,$0E,$03,$00	; $88F29F
	db $00	; $88F2AF
CODE_88F2B0:		; M=16 X=16
	lda.w #$0198		; $88F2B0: A9 98 01
	sta.w $1BE7		; $88F2B3: 8D E7 1B
	inc a		; $88F2B6: 1A
	sta.w $1BD7		; $88F2B7: 8D D7 1B
	stz.w $1BCD		; $88F2BA: 9C CD 1B
	stz.w $1BCF		; $88F2BD: 9C CF 1B
	jsl.l $8FE404		; $88F2C0: 22 04 E4 8F
	jsl.l $8D8120		; $88F2C4: 22 20 81 8D
	sep #$20		; $88F2C8: E2 20
	cli		; $88F2CA: 58
	lda.w $4210		; $88F2CB: AD 10 42
	lda.b #$81		; $88F2CE: A9 81
	sta.w $4200		; $88F2D0: 8D 00 42
	lda.b #$03		; $88F2D3: A9 03
	sta.w $2101		; $88F2D5: 8D 01 21
	lda.b #$01		; $88F2D8: A9 01
	sta.w $2105		; $88F2DA: 8D 05 21
	lda.b #$00		; $88F2DD: A9 00
	sta.w $2107		; $88F2DF: 8D 07 21
	lda.b #$04		; $88F2E2: A9 04
	sta.w $2108		; $88F2E4: 8D 08 21
	lda.b #$11		; $88F2E7: A9 11
	sta.w $210B		; $88F2E9: 8D 0B 21
	lda.b #$03		; $88F2EC: A9 03
	sta.w $212C		; $88F2EE: 8D 2C 21
	rep #$30		; $88F2F1: C2 30
	lda.w $1BE7		; $88F2F3: AD E7 1B
	ldx.w #$07FE		; $88F2F6: A2 FE 07
CODE_88F2F9:		; M=16 X=16
	sta.l $7E6E74,x		; $88F2F9: 9F 74 6E 7E
	dex		; $88F2FD: CA
	dex		; $88F2FE: CA
	bpl CODE_88F2F9		; $88F2FF: 10 F8
	lda.w #$D5C0		; $88F301: A9 C0 D5
	sta.b $73		; $88F304: 85 73
	lda.w #$0085		; $88F306: A9 85 00
	sta.b $75		; $88F309: 85 75
	jsl.l $86FA3E		; $88F30B: 22 3E FA 86
	lda.l $7F0000		; $88F30F: AF 00 00 7F
	ldx.w #$07FE		; $88F313: A2 FE 07
CODE_88F316:		; M=16 X=16
	sta.l $7E7674,x		; $88F316: 9F 74 76 7E
	dex		; $88F31A: CA
	dex		; $88F31B: CA
	bpl CODE_88F316		; $88F31C: 10 F8
	ldx.w #$06FE		; $88F31E: A2 FE 06
CODE_88F321:		; M=16 X=16
	lda.l $7F0000,x		; $88F321: BF 00 00 7F
	sta.l $7E7674,x		; $88F325: 9F 74 76 7E
	dex		; $88F329: CA
	dex		; $88F32A: CA
	bpl CODE_88F321		; $88F32B: 10 F4
	ldx.w #$057E		; $88F32D: A2 7E 05
CODE_88F330:		; M=16 X=16
	lda.l $7E7674,x		; $88F330: BF 74 76 7E
	ora.w #$2000		; $88F334: 09 00 20
	sta.l $7E7674,x		; $88F337: 9F 74 76 7E
	dex		; $88F33B: CA
	dex		; $88F33C: CA
	bpl CODE_88F330		; $88F33D: 10 F1
	lda.w #$1000		; $88F33F: A9 00 10
	sta.w $2116		; $88F342: 8D 16 21
	ldx.w #$0000		; $88F345: A2 00 00
CODE_88F348:		; M=16 X=16
	lda.l $7F0800,x		; $88F348: BF 00 08 7F
	sta.w $2118		; $88F34C: 8D 18 21
	inx		; $88F34F: E8
	inx		; $88F350: E8
	cpx.w #$3300		; $88F351: E0 00 33
	bne CODE_88F348		; $88F354: D0 F2
	sep #$20		; $88F356: E2 20
	stz.w $2121		; $88F358: 9C 21 21
	ldx.w #$0000		; $88F35B: A2 00 00
CODE_88F35E:		; M=8 X=16
	lda.l $7F0700,x		; $88F35E: BF 00 07 7F
	sta.w $2122		; $88F362: 8D 22 21
	inx		; $88F365: E8
	cpx.w #$0100		; $88F366: E0 00 01
	bne CODE_88F35E		; $88F369: D0 F3
	rep #$30		; $88F36B: C2 30
	ldx.w #$0010		; $88F36D: A2 10 00
CODE_88F370:		; M=16 X=16
	stz.w $2118		; $88F370: 9C 18 21
	dex		; $88F373: CA
	bne CODE_88F370		; $88F374: D0 FA
	lda.w #$C6D8		; $88F376: A9 D8 C6
	sta.b $73		; $88F379: 85 73
	lda.w #$0083		; $88F37B: A9 83 00
	sta.b $75		; $88F37E: 85 75
	jsl.l $86FA3E		; $88F380: 22 3E FA 86
	lda.w #$0000		; $88F384: A9 00 00
	sta.b $33		; $88F387: 85 33
	lda.w #$007F		; $88F389: A9 7F 00
	sta.b $35		; $88F38C: 85 35
	lda.w #$E154		; $88F38E: A9 54 E1
	sta.b $37		; $88F391: 85 37
	lda.w #$008F		; $88F393: A9 8F 00
	sta.b $39		; $88F396: 85 39
	lda.w #$0064		; $88F398: A9 64 00
	sta.b $53		; $88F39B: 85 53
	jsl.l $8FE0E4		; $88F39D: 22 E4 E0 8F
	jsl.l $86FBE1		; $88F3A1: 22 E1 FB 86
	jsl.l $80B90C		; $88F3A5: 22 0C B9 80
	ora.b $00		; $88F3A9: 05 00
	cmp.l $641C00		; $88F3AB: CF 00 1C 64
	eor.b ($A9,s),y		; $88F3AF: 53 A9
	tay		; $88F3B1: A8
	plx		; $88F3B2: FA
	sta.b $33		; $88F3B3: 85 33
	lda.w #$008A		; $88F3B5: A9 8A 00
	sta.b $35		; $88F3B8: 85 35
	lda.w #$6E74		; $88F3BA: A9 74 6E
	sta.w $1653		; $88F3BD: 8D 53 16
	lda.w #$007E		; $88F3C0: A9 7E 00
	sta.w $1655		; $88F3C3: 8D 55 16
	lda.w #$1000		; $88F3C6: A9 00 10
	sta.w $1656		; $88F3C9: 8D 56 16
	stz.w $1658		; $88F3CC: 9C 58 16
	lda.w #$0007		; $88F3CF: A9 07 00
	sta.b $A3		; $88F3D2: 85 A3
	lda.w #$8293		; $88F3D4: A9 93 82
	sta.b $14		; $88F3D7: 85 14
	lda.w #$0001		; $88F3D9: A9 01 00
	sta.b $08		; $88F3DC: 85 08
CODE_88F3DE:		; M=16 X=16
	cmp.b $14		; $88F3DE: C5 14
	beq CODE_88F3DE		; $88F3E0: F0 FC
CODE_88F3E2:		; M=16 X=16
	ldy.w #$0002		; $88F3E2: A0 02 00
	lda.b [$33],y		; $88F3E5: B7 33
	and.w #$00FF		; $88F3E7: 29 FF 00
	cmp.w #$00FF		; $88F3EA: C9 FF 00
	bne CODE_88F3F2		; $88F3ED: D0 03
	jmp.w $F4E8		; $88F3EF: 4C E8 F4
CODE_88F3F2:		; M=16 X=16
	lda.w $047D		; $88F3F2: AD 7D 04
	pha		; $88F3F5: 48
	ldx.w #$0006		; $88F3F6: A2 06 00
CODE_88F3F9:		; M=16 X=16
	stz.w $047B		; $88F3F9: 9C 7B 04
	txa		; $88F3FC: 8A
	clc		; $88F3FD: 18
	adc.b $01,s		; $88F3FE: 63 01
	and.w #$001F		; $88F400: 29 1F 00
	sta.w $047D		; $88F403: 8D 7D 04
	lda.w #$F4F0		; $88F406: A9 F0 F4
	sta.b $37		; $88F409: 85 37
	lda.w #$0088		; $88F40B: A9 88 00
	sta.b $39		; $88F40E: 85 39
	jsl.l $80B92D		; $88F410: 22 2D B9 80
	dex		; $88F414: CA
	bpl CODE_88F3F9		; $88F415: 10 E2
	lda.b $01,s		; $88F417: A3 01
	sta.w $047D		; $88F419: 8D 7D 04
CODE_88F41C:		; M=16 X=16
	lda.w #$0022		; $88F41C: A9 22 00
	sec		; $88F41F: 38
	sbc.b [$33]		; $88F420: E7 33
	lsr a		; $88F422: 4A
	sta.w $047B		; $88F423: 8D 7B 04
	lda.b $33		; $88F426: A5 33
	sta.b $37		; $88F428: 85 37
	lda.b $35		; $88F42A: A5 35
	sta.b $39		; $88F42C: 85 39
	jsl.l $80B92D		; $88F42E: 22 2D B9 80
	lda.w $047D		; $88F432: AD 7D 04
	inc a		; $88F435: 1A
	and.w #$001F		; $88F436: 29 1F 00
	sta.w $047D		; $88F439: 8D 7D 04
	lda.b [$33]		; $88F43C: A7 33
	clc		; $88F43E: 18
	adc.b $33		; $88F43F: 65 33
	sta.b $33		; $88F441: 85 33
	ldy.w #$0002		; $88F443: A0 02 00
	lda.b [$33],y		; $88F446: B7 33
	and.w #$00FF		; $88F448: 29 FF 00
	sta.b $5F		; $88F44B: 85 5F
	cmp.w #$00FE		; $88F44D: C9 FE 00
	beq CODE_88F457		; $88F450: F0 05
	cmp.w #$00FF		; $88F452: C9 FF 00
	bne CODE_88F41C		; $88F455: D0 C5
CODE_88F457:		; M=16 X=16
	lda.b [$33]		; $88F457: A7 33
	clc		; $88F459: 18
	adc.b $33		; $88F45A: 65 33
	sta.b $33		; $88F45C: 85 33
	pla		; $88F45E: 68
	clc		; $88F45F: 18
	adc.w #$0006		; $88F460: 69 06 00
	and.w #$001F		; $88F463: 29 1F 00
	sta.w $047D		; $88F466: 8D 7D 04
	sec		; $88F469: 38
	sbc.w #$001C		; $88F46A: E9 1C 00
	and.w #$001F		; $88F46D: 29 1F 00
	asl a		; $88F470: 0A
	asl a		; $88F471: 0A
	asl a		; $88F472: 0A
	sta.b $57		; $88F473: 85 57
	jsl.l $8F8EF7		; $88F475: 22 F7 8E 8F
CODE_88F479:		; M=16 X=16
	lda.b $53		; $88F479: A5 53
	inc a		; $88F47B: 1A
	and.w #$00FF		; $88F47C: 29 FF 00
	sta.b $53		; $88F47F: 85 53
	lda.w #$8293		; $88F481: A9 93 82
	sta.b $14		; $88F484: 85 14
CODE_88F486:		; M=16 X=16
	cmp.b $14		; $88F486: C5 14
	beq CODE_88F486		; $88F488: F0 FC
	jsl.l $80F3E8		; $88F48A: 22 E8 F3 80
	lda.b $5F		; $88F48E: A5 5F
	cmp.w #$00FE		; $88F490: C9 FE 00
	bne CODE_88F49B		; $88F493: D0 06
	stz.w $016E		; $88F495: 9C 6E 01
	stz.w $0170		; $88F498: 9C 70 01
CODE_88F49B:		; M=16 X=16
	lda.w $016E		; $88F49B: AD 6E 01
	ora.w $0170		; $88F49E: 0D 70 01
	bit.w #$1000		; $88F4A1: 89 00 10
	bne CODE_88F4E8		; $88F4A4: D0 42
	lda.b $53		; $88F4A6: A5 53
	cmp.b $57		; $88F4A8: C5 57
	bne CODE_88F479		; $88F4AA: D0 CD
	lda.b $00		; $88F4AC: A5 00
	clc		; $88F4AE: 18
	adc.w #$005A		; $88F4AF: 69 5A 00
	sta.b $5B		; $88F4B2: 85 5B
	lda.b $5F		; $88F4B4: A5 5F
	cmp.w #$00FE		; $88F4B6: C9 FE 00
	bne CODE_88F4D4		; $88F4B9: D0 19
	lda.b $00		; $88F4BB: A5 00
	clc		; $88F4BD: 18
	adc.w #$00B4		; $88F4BE: 69 B4 00
	sta.b $5B		; $88F4C1: 85 5B
CODE_88F4C3:		; M=16 X=16
	jsl.l $80F3E8		; $88F4C3: 22 E8 F3 80
	lda.b $5F		; $88F4C7: A5 5F
	cmp.w #$00FE		; $88F4C9: C9 FE 00
	bne CODE_88F4D4		; $88F4CC: D0 06
	stz.w $016E		; $88F4CE: 9C 6E 01
	stz.w $0170		; $88F4D1: 9C 70 01
CODE_88F4D4:		; M=16 X=16
	lda.w $016E		; $88F4D4: AD 6E 01
	ora.w $0170		; $88F4D7: 0D 70 01
	bit.w #$1000		; $88F4DA: 89 00 10
	bne CODE_88F4E8		; $88F4DD: D0 09
	lda.b $00		; $88F4DF: A5 00
	cmp.b $5B		; $88F4E1: C5 5B
	bne CODE_88F4C3		; $88F4E3: D0 DE
	jmp.w $F3E2		; $88F4E5: 4C E2 F3
CODE_88F4E8:		; M=16 X=16
	lda.b $14		; $88F4E8: A5 14
	cmp.w #$80DE		; $88F4EA: C9 DE 80
	bne CODE_88F4E8		; $88F4ED: D0 F9
	rtl		; $88F4EF: 6B
	db $22,$00,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; $88F4F0
	db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; $88F500
	db $20,$20	; $88F510
CODE_88F512:		; M=16 X=16
	lda.w #$0006		; $88F512: A9 06 00
	sta.w $1BD7		; $88F515: 8D D7 1B
	clc		; $88F518: 18
	adc.w #$0064		; $88F519: 69 64 00
	sta.w $1BD1		; $88F51C: 8D D1 1B
	adc.w #$0064		; $88F51F: 69 64 00
	sta.w $1BE5		; $88F522: 8D E5 1B
	adc.w #$0195		; $88F525: 69 95 01
	sta.w $1BDD		; $88F528: 8D DD 1B
	stz.w $1BCD		; $88F52B: 9C CD 1B
	stz.w $1BCF		; $88F52E: 9C CF 1B
	lda.w $1600		; $88F531: AD 00 16
	bne CODE_88F539		; $88F534: D0 03
	jmp.w $F704		; $88F536: 4C 04 F7
CODE_88F539:		; M=16 X=16
	jsl.l $8FE404		; $88F539: 22 04 E4 8F
	sep #$20		; $88F53D: E2 20
	lda.b #$01		; $88F53F: A9 01
	sta.w $2105		; $88F541: 8D 05 21
	lda.b #$01		; $88F544: A9 01
	sta.w $2107		; $88F546: 8D 07 21
	lda.b #$01		; $88F549: A9 01
	sta.w $210B		; $88F54B: 8D 0B 21
	lda.b #$01		; $88F54E: A9 01
	sta.w $212C		; $88F550: 8D 2C 21
	rep #$30		; $88F553: C2 30
	lda.w #$1000		; $88F555: A9 00 10
	sta.w $2116		; $88F558: 8D 16 21
	lda.w #$F79D		; $88F55B: A9 9D F7
	sta.b $73		; $88F55E: 85 73
	lda.w #$0084		; $88F560: A9 84 00
	sta.b $75		; $88F563: 85 75
	jsl.l $86FA3E		; $88F565: 22 3E FA 86
	ldx.w #$0000		; $88F569: A2 00 00
CODE_88F56C:		; M=16 X=16
	lda.l $7F0100,x		; $88F56C: BF 00 01 7F
	sta.w $2118		; $88F570: 8D 18 21
	inx		; $88F573: E8
	inx		; $88F574: E8
	cpx.w #$00C0		; $88F575: E0 C0 00
	bne CODE_88F56C		; $88F578: D0 F2
	ldx.w #$0000		; $88F57A: A2 00 00
CODE_88F57D:		; M=16 X=16
	lda.l $7F0000,x		; $88F57D: BF 00 00 7F
	sta.l $7E6C74,x		; $88F581: 9F 74 6C 7E
	inx		; $88F585: E8
	inx		; $88F586: E8
	cpx.w #$0100		; $88F587: E0 00 01
	bne CODE_88F57D		; $88F58A: D0 F1
	lda.w #$C6D8		; $88F58C: A9 D8 C6
	sta.b $73		; $88F58F: 85 73
	lda.w #$0083		; $88F591: A9 83 00
	sta.b $75		; $88F594: 85 75
	jsl.l $86FA3E		; $88F596: 22 3E FA 86
	lda.w #$0000		; $88F59A: A9 00 00
	sta.b $33		; $88F59D: 85 33
	lda.w #$007F		; $88F59F: A9 7F 00
	sta.b $35		; $88F5A2: 85 35
	lda.w #$E154		; $88F5A4: A9 54 E1
	sta.b $37		; $88F5A7: 85 37
	lda.w #$008F		; $88F5A9: A9 8F 00
	sta.b $39		; $88F5AC: 85 39
	lda.w #$0064		; $88F5AE: A9 64 00
	sta.b $53		; $88F5B1: 85 53
	jsl.l $8FE0E4		; $88F5B3: 22 E4 E0 8F
	lda.w #$C6D8		; $88F5B7: A9 D8 C6
	sta.b $73		; $88F5BA: 85 73
	lda.w #$0083		; $88F5BC: A9 83 00
	sta.b $75		; $88F5BF: 85 75
	jsl.l $86FA3E		; $88F5C1: 22 3E FA 86
	lda.w #$0000		; $88F5C5: A9 00 00
	sta.b $33		; $88F5C8: 85 33
	lda.w #$007F		; $88F5CA: A9 7F 00
	sta.b $35		; $88F5CD: 85 35
	lda.w #$FCD4		; $88F5CF: A9 D4 FC
	sta.b $37		; $88F5D2: 85 37
	lda.w #$0082		; $88F5D4: A9 82 00
	sta.b $39		; $88F5D7: 85 39
	lda.w #$0064		; $88F5D9: A9 64 00
	sta.b $53		; $88F5DC: 85 53
	jsl.l $8FE0E4		; $88F5DE: 22 E4 E0 8F
	lda.w #$9B73		; $88F5E2: A9 73 9B
	sta.b $73		; $88F5E5: 85 73
	lda.w #$0088		; $88F5E7: A9 88 00
	sta.b $75		; $88F5EA: 85 75
	jsl.l $86FA3E		; $88F5EC: 22 3E FA 86
	ldx.w #$0000		; $88F5F0: A2 00 00
CODE_88F5F3:		; M=16 X=16
	lda.l $7F0000,x		; $88F5F3: BF 00 00 7F
	sta.w $2118		; $88F5F7: 8D 18 21
	inx		; $88F5FA: E8
	inx		; $88F5FB: E8
	cpx.w #$32A0		; $88F5FC: E0 A0 32
	bne CODE_88F5F3		; $88F5FF: D0 F2
	lda.w #$0000		; $88F601: A9 00 00
	ldx.w #$1FFE		; $88F604: A2 FE 1F
CODE_88F607:		; M=16 X=16
	sta.l $7E6E74,x		; $88F607: 9F 74 6E 7E
	dex		; $88F60B: CA
	dex		; $88F60C: CA
	bpl CODE_88F607		; $88F60D: 10 F8
	lda.w #$0453		; $88F60F: A9 53 04
	sta.b $37		; $88F612: 85 37
	lda.w #$0000		; $88F614: A9 00 00
	sta.b $39		; $88F617: 85 39
	lda.w #$F9FB		; $88F619: A9 FB F9
	sta.b $33		; $88F61C: 85 33
	lda.w #$0088		; $88F61E: A9 88 00
	sta.b $35		; $88F621: 85 35
	lda.w $014A		; $88F623: AD 4A 01
	asl a		; $88F626: 0A
	tay		; $88F627: A8
	lda.b [$33],y		; $88F628: B7 33
	adc.b $33		; $88F62A: 65 33
	sta.b $33		; $88F62C: 85 33
	lda.b [$33]		; $88F62E: A7 33
	inc.b $33		; $88F630: E6 33
	and.w #$00FF		; $88F632: 29 FF 00
	sta.b $63		; $88F635: 85 63
CODE_88F637:		; M=16 X=16
	lda.b [$33]		; $88F637: A7 33
	inc.b $33		; $88F639: E6 33
	and.w #$00FF		; $88F63B: 29 FF 00
	sta.w $047B		; $88F63E: 8D 7B 04
	stz.w $0477		; $88F641: 9C 77 04
	lda.b [$33]		; $88F644: A7 33
	inc.b $33		; $88F646: E6 33
	and.w #$00FF		; $88F648: 29 FF 00
	sta.w $047D		; $88F64B: 8D 7D 04
	lda.b [$37]		; $88F64E: A7 37
	inc.b $37		; $88F650: E6 37
	and.w #$00FF		; $88F652: 29 FF 00
	sta.b $7D		; $88F655: 85 7D
	ldy.w $0473		; $88F657: AC 73 04
	eor.w $0453,y		; $88F65A: 59 53 04
	and.w #$00FF		; $88F65D: 29 FF 00
	bne CODE_88F668		; $88F660: D0 06
	lda.w #$1C00		; $88F662: A9 00 1C
	sta.w $0477		; $88F665: 8D 77 04
CODE_88F668:		; M=16 X=16
	lda.w #$0024		; $88F668: A9 24 00
	sta.b $83		; $88F66B: 85 83
	jsl.l $8D871C		; $88F66D: 22 1C 87 8D
	tay		; $88F671: A8
	lda.w #$CABA		; $88F672: A9 BA CA
	sta.b $3B		; $88F675: 85 3B
	lda.w #$0087		; $88F677: A9 87 00
	sta.b $3D		; $88F67A: 85 3D
	lda.w $047D		; $88F67C: AD 7D 04
	asl a		; $88F67F: 0A
	asl a		; $88F680: 0A
	asl a		; $88F681: 0A
	asl a		; $88F682: 0A
	asl a		; $88F683: 0A
	asl a		; $88F684: 0A
	asl a		; $88F685: 0A
	adc.w $047B		; $88F686: 6D 7B 04
	asl a		; $88F689: 0A
	tax		; $88F68A: AA
	lda.w #$0009		; $88F68B: A9 09 00
	sta.b $73		; $88F68E: 85 73
	sta.b $75		; $88F690: 85 75
CODE_88F692:		; M=16 X=16
	lda.b [$3B],y		; $88F692: B7 3B
	clc		; $88F694: 18
	adc.w $1BE5		; $88F695: 6D E5 1B
	adc.w $1BCD		; $88F698: 6D CD 1B
	ora.w $0477		; $88F69B: 0D 77 04
	sta.l $7E6E74,x		; $88F69E: 9F 74 6E 7E
	iny		; $88F6A2: C8
	iny		; $88F6A3: C8
	inx		; $88F6A4: E8
	inx		; $88F6A5: E8
	dec.b $73		; $88F6A6: C6 73
	bne CODE_88F692		; $88F6A8: D0 E8
CODE_88F6AA:		; M=16 X=16
	lda.b [$3B],y		; $88F6AA: B7 3B
	clc		; $88F6AC: 18
	adc.w $1BE5		; $88F6AD: 6D E5 1B
	adc.w $1BCD		; $88F6B0: 6D CD 1B
	ora.w $0477		; $88F6B3: 0D 77 04
	sta.l $7E6F62,x		; $88F6B6: 9F 62 6F 7E
	iny		; $88F6BA: C8
	iny		; $88F6BB: C8
	inx		; $88F6BC: E8
	inx		; $88F6BD: E8
	dec.b $75		; $88F6BE: C6 75
	bne CODE_88F6AA		; $88F6C0: D0 E8
	dec.b $63		; $88F6C2: C6 63
	beq CODE_88F6C9		; $88F6C4: F0 03
	jmp.w $F637		; $88F6C6: 4C 37 F6
CODE_88F6C9:		; M=16 X=16
	lda.b [$33]		; $88F6C9: A7 33
	inc.b $33		; $88F6CB: E6 33
	and.w #$00FF		; $88F6CD: 29 FF 00
	cmp.w #$00FF		; $88F6D0: C9 FF 00
	beq CODE_88F705		; $88F6D3: F0 30
	asl a		; $88F6D5: 0A
	adc.w #$F880		; $88F6D6: 69 80 F8
	sta.b $73		; $88F6D9: 85 73
	lda.w #$008A		; $88F6DB: A9 8A 00
	sta.b $75		; $88F6DE: 85 75
	lda.b [$33]		; $88F6E0: A7 33
	inc.b $33		; $88F6E2: E6 33
	and.w #$00FF		; $88F6E4: 29 FF 00
	asl a		; $88F6E7: 0A
	tax		; $88F6E8: AA
	ldy.w #$0017		; $88F6E9: A0 17 00
CODE_88F6EC:		; M=16 X=16
	lda.b [$73]		; $88F6EC: A7 73
	sta.l $7E7074,x		; $88F6EE: 9F 74 70 7E
	lda.b $73		; $88F6F2: A5 73
	clc		; $88F6F4: 18
	adc.w #$0018		; $88F6F5: 69 18 00
	sta.b $73		; $88F6F8: 85 73
	txa		; $88F6FA: 8A
	adc.w #$0100		; $88F6FB: 69 00 01
	tax		; $88F6FE: AA
	dey		; $88F6FF: 88
	bne CODE_88F6EC		; $88F700: D0 EA
	bra CODE_88F6C9		; $88F702: 80 C5
CODE_88F704:		; M=16 X=16
	rtl		; $88F704: 6B
CODE_88F705:		; M=16 X=16
	lda.b [$33]		; $88F705: A7 33
	inc.b $33		; $88F707: E6 33
	and.w #$00FF		; $88F709: 29 FF 00
	asl a		; $88F70C: 0A
	asl a		; $88F70D: 0A
	asl a		; $88F70E: 0A
	sta.b $5D		; $88F70F: 85 5D
	lda.b [$33]		; $88F711: A7 33
	inc.b $33		; $88F713: E6 33
	and.w #$00FF		; $88F715: 29 FF 00
	asl a		; $88F718: 0A
	asl a		; $88F719: 0A
	asl a		; $88F71A: 0A
	sta.b $55		; $88F71B: 85 55
	stz.b $61		; $88F71D: 64 61
	jsl.l $80B90C		; $88F71F: 22 0C B9 80
	ora.b $00		; $88F723: 05 00
	sbc.l $A50000		; $88F725: EF 00 00 A5
	dec.b $C9,x		; $88F729: D6 C9
	ora.b [$00]		; $88F72B: 07 00
	beq CODE_88F788		; $88F72D: F0 59
	lda.b [$33]		; $88F72F: A7 33
	inc.b $33		; $88F731: E6 33
	and.w #$00FF		; $88F733: 29 FF 00
	sta.b $63		; $88F736: 85 63
	beq CODE_88F788		; $88F738: F0 4E
	stz.b $3B		; $88F73A: 64 3B
CODE_88F73C:		; M=16 X=16
	lda.b [$33]		; $88F73C: A7 33
	inc.b $33		; $88F73E: E6 33
	and.w #$00FF		; $88F740: 29 FF 00
	sta.w $047B		; $88F743: 8D 7B 04
	lda.b [$33]		; $88F746: A7 33
	inc.b $33		; $88F748: E6 33
	and.w #$00FF		; $88F74A: 29 FF 00
	asl a		; $88F74D: 0A
	asl a		; $88F74E: 0A
	sta.w $047D		; $88F74F: 8D 7D 04
	lda.w #$0191		; $88F752: A9 91 01
	sta.b $37		; $88F755: 85 37
	lda.w #$0000		; $88F757: A9 00 00
	sta.b $39		; $88F75A: 85 39
	lda.w #$0005		; $88F75C: A9 05 00
	sta.w $0191		; $88F75F: 8D 91 01
	ldx.b $3B		; $88F762: A6 3B
	lda.w $159F,x		; $88F764: BD 9F 15
	adc.w #$0030		; $88F767: 69 30 00
	sta.w $0193		; $88F76A: 8D 93 01
	lda.w #$002D		; $88F76D: A9 2D 00
	sta.w $0194		; $88F770: 8D 94 01
	lda.w $15AF,x		; $88F773: BD AF 15
	adc.w #$0030		; $88F776: 69 30 00
	sta.w $0195		; $88F779: 8D 95 01
	jsl.l $80B92D		; $88F77C: 22 2D B9 80
	inc.b $3B		; $88F780: E6 3B
	inc.b $3B		; $88F782: E6 3B
	dec.b $63		; $88F784: C6 63
	bne CODE_88F73C		; $88F786: D0 B4
CODE_88F788:		; M=16 X=16
	lda.w #$8000		; $88F788: A9 00 80
	sta.b $73		; $88F78B: 85 73
	lda.w #$008C		; $88F78D: A9 8C 00
	sta.b $75		; $88F790: 85 75
	jsl.l $86FA3E		; $88F792: 22 3E FA 86
	ldx.w #$001E		; $88F796: A2 1E 00
CODE_88F799:		; M=16 X=16
	lda.l $7F00A0,x		; $88F799: BF A0 00 7F
	sta.l $7E6D34,x		; $88F79D: 9F 34 6D 7E
	dex		; $88F7A1: CA
	dex		; $88F7A2: CA
	bpl CODE_88F799		; $88F7A3: 10 F4
	lda.w $1BDD		; $88F7A5: AD DD 1B
	asl a		; $88F7A8: 0A
	asl a		; $88F7A9: 0A
	asl a		; $88F7AA: 0A
	asl a		; $88F7AB: 0A
	adc.w #$1000		; $88F7AC: 69 00 10
	sta.w $2116		; $88F7AF: 8D 16 21
	ldx.w #$0000		; $88F7B2: A2 00 00
CODE_88F7B5:		; M=16 X=16
	lda.l $7F01A0,x		; $88F7B5: BF A0 01 7F
	sta.w $2118		; $88F7B9: 8D 18 21
	inx		; $88F7BC: E8
	inx		; $88F7BD: E8
	cpx.w #$06A0		; $88F7BE: E0 A0 06
	bne CODE_88F7B5		; $88F7C1: D0 F2
	stz.b $75		; $88F7C3: 64 75
CODE_88F7C5:		; M=16 X=16
	stz.b $73		; $88F7C5: 64 73
CODE_88F7C7:		; M=16 X=16
	lda.b $75		; $88F7C7: A5 75
	sta.b $7D		; $88F7C9: 85 7D
	lda.w #$0008		; $88F7CB: A9 08 00
	sta.b $83		; $88F7CE: 85 83
	jsl.l $8D871C		; $88F7D0: 22 1C 87 8D
	adc.b $73		; $88F7D4: 65 73
	asl a		; $88F7D6: 0A
	tax		; $88F7D7: AA
	lda.l $7F0000,x		; $88F7D8: BF 00 00 7F
	adc.w $1BDD		; $88F7DC: 6D DD 1B
	ora.w #$1800		; $88F7DF: 09 00 18
	pha		; $88F7E2: 48
	lda.b $75		; $88F7E3: A5 75
	asl a		; $88F7E5: 0A
	asl a		; $88F7E6: 0A
	asl a		; $88F7E7: 0A
	asl a		; $88F7E8: 0A
	asl a		; $88F7E9: 0A
	asl a		; $88F7EA: 0A
	asl a		; $88F7EB: 0A
	adc.b $73		; $88F7EC: 65 73
	asl a		; $88F7EE: 0A
	tax		; $88F7EF: AA
	pla		; $88F7F0: 68
	sta.l $7E78EC,x		; $88F7F1: 9F EC 78 7E
	inc.b $73		; $88F7F5: E6 73
	lda.b $73		; $88F7F7: A5 73
	cmp.w #$0008		; $88F7F9: C9 08 00
	bne CODE_88F7C7		; $88F7FC: D0 C9
	inc.b $75		; $88F7FE: E6 75
	lda.b $75		; $88F800: A5 75
	cmp.w #$000A		; $88F802: C9 0A 00
	bne CODE_88F7C5		; $88F805: D0 BE
	jsl.l $8FE04C		; $88F807: 22 4C E0 8F
	jsl.l $80B90C		; $88F80B: 22 0C B9 80
	ora.b $00		; $88F80F: 05 00
	sbc.l $226438		; $88F811: EF 38 64 22
	sbc.b [$85],y		; $88F815: F7 85
	dey		; $88F817: 88
	lda.w #$0180		; $88F818: A9 80 01
	sta.w $0156		; $88F81B: 8D 56 01
	stz.w $047B		; $88F81E: 9C 7B 04
	stz.w $047D		; $88F821: 9C 7D 04
	lda.w #$0020		; $88F824: A9 20 00
	sta.b $53		; $88F827: 85 53
	lda.w #$0004		; $88F829: A9 04 00
	sta.b $57		; $88F82C: 85 57
	lda.w $1BD1		; $88F82E: AD D1 1B
	ora.w #$1000		; $88F831: 09 00 10
	sta.b $5B		; $88F834: 85 5B
	jsl.l $8D847C		; $88F836: 22 7C 84 8D
	stz.w $047B		; $88F83A: 9C 7B 04
	lda.w #$0068		; $88F83D: A9 68 00
	sta.w $047D		; $88F840: 8D 7D 04
	lda.w #$0020		; $88F843: A9 20 00
	sta.b $53		; $88F846: 85 53
	lda.w #$0018		; $88F848: A9 18 00
	sta.b $57		; $88F84B: 85 57
	lda.w $1BD1		; $88F84D: AD D1 1B
	ora.w #$1000		; $88F850: 09 00 10
	sta.b $5B		; $88F853: 85 5B
	jsl.l $8D847C		; $88F855: 22 7C 84 8D
	jsl.l $89FB8F		; $88F859: 22 8F FB 89
CODE_88F85D:		; M=16 X=16
	lda.w $0156		; $88F85D: AD 56 01
	cmp.b $5D		; $88F860: C5 5D
	bcs CODE_88F866		; $88F862: B0 02
	lda.b $5D		; $88F864: A5 5D
CODE_88F866:		; M=16 X=16
	cmp.b $55		; $88F866: C5 55
	bcc CODE_88F86C		; $88F868: 90 02
	lda.b $55		; $88F86A: A5 55
CODE_88F86C:		; M=16 X=16
	sta.w $0156		; $88F86C: 8D 56 01
	lsr a		; $88F86F: 4A
	lsr a		; $88F870: 4A
	lsr a		; $88F871: 4A
	asl a		; $88F872: 0A
	adc.w #$6E74		; $88F873: 69 74 6E
	sta.b $73		; $88F876: 85 73
	stz.b $75		; $88F878: 64 75
	ldy.w #$0000		; $88F87A: A0 00 00
CODE_88F87D:		; M=16 X=16
	lda.b $75		; $88F87D: A5 75
	sta.w $1658,y		; $88F87F: 99 58 16
	clc		; $88F882: 18
	adc.w #$0020		; $88F883: 69 20 00
	sta.b $75		; $88F886: 85 75
	adc.w #$03E0		; $88F888: 69 E0 03
	sta.w $165F,y		; $88F88B: 99 5F 16
	lda.b $73		; $88F88E: A5 73
	sta.w $1653,y		; $88F890: 99 53 16
	adc.w #$0040		; $88F893: 69 40 00
	sta.w $165A,y		; $88F896: 99 5A 16
	adc.w #$00C0		; $88F899: 69 C0 00
	sta.b $73		; $88F89C: 85 73
	lda.w #$007E		; $88F89E: A9 7E 00
	sta.w $1655,y		; $88F8A1: 99 55 16
	sta.w $165C,y		; $88F8A4: 99 5C 16
	lda.w #$0040		; $88F8A7: A9 40 00
	sta.w $1656,y		; $88F8AA: 99 56 16
	lda.w #$000A		; $88F8AD: A9 0A 00
	sta.w $165D,y		; $88F8B0: 99 5D 16
	tya		; $88F8B3: 98
	adc.w #$000E		; $88F8B4: 69 0E 00
	tay		; $88F8B7: A8
	cpy.w #$01C0		; $88F8B8: C0 C0 01
	bne CODE_88F87D		; $88F8BB: D0 C0
	sty.b $A3		; $88F8BD: 84 A3
	lda.w #$82E0		; $88F8BF: A9 E0 82
	sta.b $14		; $88F8C2: 85 14
CODE_88F8C4:		; M=16 X=16
	cmp.b $14		; $88F8C4: C5 14
	beq CODE_88F8C4		; $88F8C6: F0 FC
CODE_88F8C8:		; M=16 X=16
	jsl.l $80F3E8		; $88F8C8: 22 E8 F3 80
	lda.w $016E		; $88F8CC: AD 6E 01
	ora.w $0170		; $88F8CF: 0D 70 01
	cmp.w #$1000		; $88F8D2: C9 00 10
	bne CODE_88F8DA		; $88F8D5: D0 03
	jmp.w $F704		; $88F8D7: 4C 04 F7
CODE_88F8DA:		; M=16 X=16
	lda.b $00		; $88F8DA: A5 00
	cmp.b $6F		; $88F8DC: C5 6F
	beq CODE_88F8C8		; $88F8DE: F0 E8
	sta.b $6F		; $88F8E0: 85 6F
	sta.b $83		; $88F8E2: 85 83
	lda.w #$001E		; $88F8E4: A9 1E 00
	sta.b $7D		; $88F8E7: 85 7D
	jsl.l $80B8D8		; $88F8E9: 22 D8 B8 80
	lda.b $95		; $88F8ED: A5 95
	sta.b $73		; $88F8EF: 85 73
	lda.w #$0002		; $88F8F1: A9 02 00
	sta.b $7D		; $88F8F4: 85 7D
	jsl.l $80B8D8		; $88F8F6: 22 D8 B8 80
	lda.b $95		; $88F8FA: A5 95
	asl a		; $88F8FC: 0A
	tax		; $88F8FD: AA
	lda.l $88F9E5,x		; $88F8FE: BF E5 F9 88
	xba		; $88F902: EB
	and.w #$00FF		; $88F903: 29 FF 00
	lsr a		; $88F906: 4A
	lsr a		; $88F907: 4A
	sta.b $75		; $88F908: 85 75
	lda.l $88F9E7,x		; $88F90A: BF E7 F9 88
	xba		; $88F90E: EB
	and.w #$00FF		; $88F90F: 29 FF 00
	lsr a		; $88F912: 4A
	lsr a		; $88F913: 4A
	sec		; $88F914: 38
	sbc.b $75		; $88F915: E5 75
	sta.b $7D		; $88F917: 85 7D
	lda.b $73		; $88F919: A5 73
	sta.b $83		; $88F91B: 85 83
	jsl.l $82FCDB		; $88F91D: 22 DB FC 82
	lda.w #$001E		; $88F921: A9 1E 00
	sta.b $7D		; $88F924: 85 7D
	jsl.l $80996C		; $88F926: 22 6C 99 80
	adc.b $75		; $88F92A: 65 75
	and.w #$001F		; $88F92C: 29 1F 00
	xba		; $88F92F: EB
	and.w #$FF00		; $88F930: 29 00 FF
	asl a		; $88F933: 0A
	asl a		; $88F934: 0A
	sta.b $77		; $88F935: 85 77
	lda.l $88F9E5,x		; $88F937: BF E5 F9 88
	lsr a		; $88F93B: 4A
	lsr a		; $88F93C: 4A
	lsr a		; $88F93D: 4A
	lsr a		; $88F93E: 4A
	lsr a		; $88F93F: 4A
	and.w #$001F		; $88F940: 29 1F 00
	sta.b $75		; $88F943: 85 75
	lda.l $88F9E7,x		; $88F945: BF E7 F9 88
	lsr a		; $88F949: 4A
	lsr a		; $88F94A: 4A
	lsr a		; $88F94B: 4A
	lsr a		; $88F94C: 4A
	lsr a		; $88F94D: 4A
	and.w #$001F		; $88F94E: 29 1F 00
	sec		; $88F951: 38
	sbc.b $75		; $88F952: E5 75
	sta.b $7D		; $88F954: 85 7D
	lda.b $73		; $88F956: A5 73
	sta.b $83		; $88F958: 85 83
	jsl.l $82FCDB		; $88F95A: 22 DB FC 82
	lda.w #$001E		; $88F95E: A9 1E 00
	sta.b $7D		; $88F961: 85 7D
	jsl.l $80996C		; $88F963: 22 6C 99 80
	adc.b $75		; $88F967: 65 75
	and.w #$001F		; $88F969: 29 1F 00
	asl a		; $88F96C: 0A
	asl a		; $88F96D: 0A
	asl a		; $88F96E: 0A
	asl a		; $88F96F: 0A
	asl a		; $88F970: 0A
	tsb.b $77		; $88F971: 04 77
	lda.l $88F9E5,x		; $88F973: BF E5 F9 88
	and.w #$001F		; $88F977: 29 1F 00
	sta.b $75		; $88F97A: 85 75
	lda.l $88F9E7,x		; $88F97C: BF E7 F9 88
	and.w #$001F		; $88F980: 29 1F 00
	sec		; $88F983: 38
	sbc.b $75		; $88F984: E5 75
	sta.b $7D		; $88F986: 85 7D
	lda.b $73		; $88F988: A5 73
	sta.b $83		; $88F98A: 85 83
	jsl.l $82FCDB		; $88F98C: 22 DB FC 82
	lda.w #$001E		; $88F990: A9 1E 00
	sta.b $7D		; $88F993: 85 7D
	jsl.l $80996C		; $88F995: 22 6C 99 80
	adc.b $75		; $88F999: 65 75
	and.w #$001F		; $88F99B: 29 1F 00
	ora.b $77		; $88F99E: 05 77
	sta.l $7E6D56		; $88F9A0: 8F 56 6D 7E
	lda.w $015E		; $88F9A4: AD 5E 01
	ora.w $0160		; $88F9A7: 0D 60 01
	cmp.w #$0200		; $88F9AA: C9 00 02
	beq CODE_88F9EB		; $88F9AD: F0 3C
	cmp.w #$0100		; $88F9AF: C9 00 01
	beq CODE_88F9F3		; $88F9B2: F0 3F
CODE_88F9B4:		; M=16 X=16
	lda.w $0156		; $88F9B4: AD 56 01
	clc		; $88F9B7: 18
	adc.b $61		; $88F9B8: 65 61
	sta.w $0156		; $88F9BA: 8D 56 01
	cmp.w #$0058		; $88F9BD: C9 58 00
	beq CODE_88F9E0		; $88F9C0: F0 1E
	cmp.w #$00B0		; $88F9C2: C9 B0 00
	beq CODE_88F9E0		; $88F9C5: F0 19
	cmp.w #$0108		; $88F9C7: C9 08 01
	beq CODE_88F9E0		; $88F9CA: F0 14
	cmp.w #$0180		; $88F9CC: C9 80 01
	beq CODE_88F9E0		; $88F9CF: F0 0F
	cmp.w #$01F8		; $88F9D1: C9 F8 01
	beq CODE_88F9E0		; $88F9D4: F0 0A
	cmp.w #$0250		; $88F9D6: C9 50 02
	beq CODE_88F9E0		; $88F9D9: F0 05
	cmp.w #$02A8		; $88F9DB: C9 A8 02
	bne CODE_88F9E2		; $88F9DE: D0 02
CODE_88F9E0:		; M=16 X=16
	stz.b $61		; $88F9E0: 64 61
CODE_88F9E2:		; M=16 X=16
	jmp.w $F85D		; $88F9E2: 4C 5D F8
	db $FF,$7F,$10,$7E,$FF,$7F	; $88F9E5
CODE_88F9EB:		; M=16 X=16
	lda.w #$FFFF		; $88F9EB: A9 FF FF
	sta.b $61		; $88F9EE: 85 61
	jmp.w $F9B4		; $88F9F0: 4C B4 F9
CODE_88F9F3:		; M=16 X=16
	lda.w #$0001		; $88F9F3: A9 01 00
	sta.b $61		; $88F9F6: 85 61
	jmp.w $F9B4		; $88F9F8: 4C B4 F9
	db $0A,$00,$47,$00,$94,$00,$ED,$00,$4C,$01,$10,$31,$02,$31,$05,$31	; $88F9FB
	db $08,$31,$0B,$31,$0E,$31,$11,$31,$14,$31,$17,$46,$02,$46,$05,$46	; $88FA0B
	db $08,$46,$0B,$46,$0E,$46,$11,$46,$14,$46,$17,$00,$3A,$01,$3B,$0A	; $88FA1B
	db $44,$0B,$45,$FF,$30,$30,$08,$34,$04,$34,$0A,$34,$10,$34,$16,$49	; $88FA2B
	db $04,$49,$0A,$49,$10,$49,$16,$18,$26,$02,$26,$05,$26,$08,$26,$0B	; $88FA3B
	db $26,$0E,$26,$11,$26,$14,$26,$17,$51,$02,$51,$05,$51,$08,$51,$0B	; $88FA4B
	db $51,$0E,$51,$11,$51,$14,$51,$17,$31,$04,$31,$0A,$31,$0F,$31,$15	; $88FA5B
	db $46,$04,$46,$0A,$46,$0F,$46,$15,$00,$2F,$01,$30,$02,$3A,$03,$3B	; $88FA6B
	db $08,$44,$09,$45,$0A,$4F,$0B,$50,$FF,$21,$3F,$04,$34,$08,$34,$12	; $88FA7B
	db $49,$08,$49,$12,$1C,$1B,$02,$1B,$05,$1B,$08,$1B,$0B,$1B,$0E,$1B	; $88FA8B
	db $11,$1B,$14,$1B,$17,$5C,$02,$5C,$05,$5C,$08,$5C,$0B,$5C,$0E,$5C	; $88FA9B
	db $11,$5C,$14,$5C,$17,$26,$04,$26,$0A,$26,$0F,$26,$15,$51,$04,$51	; $88FAAB
	db $0A,$51,$0F,$51,$15,$31,$07,$31,$12,$46,$07,$46,$12,$00,$24,$01	; $88FABB
	db $25,$02,$2F,$03,$30,$04,$3A,$05,$3B,$06,$44,$07,$45,$08,$4F,$09	; $88FACB
	db $50,$0A,$5A,$0B,$5B,$FF,$16,$4A,$02,$34,$0D,$49,$0D,$1E,$10,$02	; $88FADB
	db $10,$05,$10,$08,$10,$0B,$10,$0E,$10,$11,$10,$14,$10,$17,$67,$02	; $88FAEB
	db $67,$05,$67,$08,$67,$0B,$67,$0E,$67,$11,$67,$14,$67,$17,$1B,$04	; $88FAFB
	db $1B,$0A,$1B,$0F,$1B,$15,$5C,$04,$5C,$0A,$5C,$0F,$5C,$15,$26,$07	; $88FB0B
	db $26,$12,$51,$07,$51,$12,$31,$0C,$46,$0C,$00,$19,$01,$1A,$02,$24	; $88FB1B
	db $03,$25,$04,$2F,$05,$30,$05,$3A,$06,$45,$06,$4F,$07,$50,$08,$5A	; $88FB2B
	db $09,$5B,$0A,$65,$0B,$66,$FF,$0B,$55,$01,$3E,$17,$1F,$10,$02,$10	; $88FB3B
	db $05,$10,$08,$10,$0B,$10,$0E,$10,$11,$10,$14,$10,$17,$67,$02,$67	; $88FB4B
	db $05,$67,$08,$67,$0B,$67,$0E,$67,$11,$67,$14,$67,$17,$1B,$04,$1B	; $88FB5B
	db $0A,$1B,$0F,$1B,$15,$5C,$04,$5C,$0A,$5C,$0F,$5C,$15,$26,$07,$26	; $88FB6B
	db $12,$51,$07,$51,$12,$31,$0C,$46,$0C,$3B,$17,$00,$19,$01,$1A,$02	; $88FB7B
	db $24,$03,$25,$04,$2F,$05,$30,$05,$3A,$06,$45,$06,$4F,$07,$50,$08	; $88FB8B
	db $5A,$09,$5B,$0A,$65,$0B,$66,$FF,$0B,$55,$00,$BD,$7F,$11,$F0,$03	; $88FB9B
	db $4C,$1C,$FD,$AD,$8A,$12,$F0,$04,$5C,$5A,$D7,$8F,$22,$27,$85,$80	; $88FBAB
	db $BD,$DF,$0E,$89,$08,$00,$F0,$03,$4C,$1C,$FD,$89,$02,$00,$F0,$12	; $88FBBB
	db $29,$FD,$FF,$9D,$DF,$0E,$9E,$5F,$0C,$9E,$7F,$0C,$A9,$08,$00,$9D	; $88FBCB
	db $FF,$0C,$BD,$5F,$0C,$38,$E5,$6F,$9D,$5F,$0C,$30,$03,$4C,$96,$FD	; $88FBDB
	db $18,$7D,$BF,$0F,$10,$03,$A9,$00,$00,$9D,$5F,$0C,$AD,$7B,$09,$85	; $88FBEB
	db $57,$AD,$1B,$0B,$4A,$4A,$4A,$4A,$4A,$4A,$89,$00,$02,$F0,$03,$09	; $88FBFB
	db $00,$FC,$85,$5F,$BD,$3F,$11,$D0,$10,$A5,$57,$49,$FF,$FF,$1A,$85	; $88FC0B
	db $57,$A5,$5F,$49,$FF,$FF,$1A,$85,$5F,$A5,$5F,$10,$02,$64,$5F,$A5	; $88FC1B
	db $5F,$18,$65,$57,$85,$5F,$38,$E9,$58,$00,$30,$04,$50,$04,$80,$38	; $88FC2B
	db $50,$36,$A4,$3B,$B9,$0A,$14,$89,$10,$00,$D0,$2C,$AD,$BB,$0E,$85	; $88FC3B
	db $57,$30,$25,$22,$95,$8D,$80,$F0,$1F,$A9,$01,$00,$85,$53,$A5,$57	; $88FC4B
	db $38,$E9,$06,$00,$85,$57,$8A,$4A,$38,$E9,$06,$00,$85,$5B,$45,$57	; $88FC5B
	db $85,$57,$30,$04,$5C,$A7,$B4,$80,$A9,$41,$00,$9D,$9F,$0C,$BD,$9F	; $88FC6B
	db $0B,$C9,$02,$00,$F0,$06,$A9,$BF,$FF,$9D,$9F,$0C,$64,$33,$E0,$0C	; $88FC7B
	db $00,$B0,$05,$A9,$0C,$00,$85,$33,$A9,$05,$00,$85,$5B,$A9,$18,$FC	; $88FC8B
	db $85,$53,$BD,$3F,$11,$F0,$7B,$A9,$E8,$03,$85,$53,$A4,$33,$B9,$DF	; $88FC9B
	db $0E,$89,$00,$10,$D0,$30,$B9,$9F,$0B,$30,$2B,$B9,$FF,$0A,$30,$03	; $88FCAB
	db $A9,$00,$00,$4A,$4A,$4A,$4A,$89,$00,$08,$F0,$03,$09,$00,$F0,$18	; $88FCBB
	db $79,$5F,$09,$85,$57,$38,$E5,$53,$F0,$08,$30,$04,$70,$04,$80,$06	; $88FCCB
	db $70,$04,$A5,$57,$85,$53,$E6,$33,$E6,$33,$C6,$5B,$10,$BE,$A5,$53	; $88FCDB
	db $38,$E9,$32,$00,$85,$53,$38,$E9,$42,$FF,$F0,$08,$30,$04,$70,$04	; $88FCEB
	db $80,$07,$70,$05,$A9,$24,$FF,$85,$53,$A5,$53,$9D,$BF,$0C,$AD,$1B	; $88FCFB
	db $09,$85,$53,$BD,$9F,$0C,$45,$53,$85,$57,$10,$7F,$9E,$9F,$0C,$80	; $88FD0B
	db $7A,$6B,$A4,$33,$B9,$DF,$0E,$89,$00,$10,$D0,$2E,$B9,$9F,$0B,$30	; $88FD1B
	db $29,$B9,$FF,$0A,$10,$03,$A9,$00,$00,$4A,$4A,$4A,$4A,$89,$00,$08	; $88FD2B
	db $F0,$03,$09,$00,$F0,$18,$79,$5F,$09,$85,$57,$38,$E5,$53,$30,$04	; $88FD3B
	db $50,$04,$80,$06,$50,$04,$A5,$57,$85,$53,$E6,$33,$E6,$33,$C6,$5B	; $88FD4B
	db $10,$C0,$A5,$53,$18,$69,$32,$00,$85,$53,$38,$E9,$BE,$00,$30,$04	; $88FD5B
	db $50,$04,$80,$07,$50,$05,$A9,$DC,$00,$85,$53,$A5,$53,$9D,$BF,$0C	; $88FD6B
	db $BD,$9F,$0C,$49,$FF,$FF,$1A,$9D,$9F,$0C,$AD,$1B,$09,$85,$53,$BD	; $88FD7B
	db $9F,$0C,$45,$53,$85,$57,$10,$03,$9E,$9F,$0C,$BD,$9F,$0C,$85,$53	; $88FD8B
	db $BD,$BF,$0C,$85,$57,$A9,$6A,$FD,$85,$33,$A9,$89,$00,$85,$35,$22	; $88FD9B
	db $D0,$FD,$88,$5C,$15,$8B,$80	; $88FDAB
CODE_88FDB2:		; M=16 X=16
	phx		; $88FDB2: DA
	lda.w $1624		; $88FDB3: AD 24 16
	clc		; $88FDB6: 18
	adc.b $53		; $88FDB7: 65 53
	sta.w $1624		; $88FDB9: 8D 24 16
	bcc CODE_88FDCD		; $88FDBC: 90 0F
	ldx.w #$0002		; $88FDBE: A2 02 00
CODE_88FDC1:		; M=16 X=16
	inc.w $1624,x		; $88FDC1: FE 24 16
	bne CODE_88FDCD		; $88FDC4: D0 07
	inx		; $88FDC6: E8
	inx		; $88FDC7: E8
	cpx.w #$0010		; $88FDC8: E0 10 00
	bne CODE_88FDC1		; $88FDCB: D0 F4
CODE_88FDCD:		; M=16 X=16
	plx		; $88FDCD: FA
	clc		; $88FDCE: 18
	rtl		; $88FDCF: 6B
	db $BD,$9F,$0B,$F0,$77,$BD,$DF,$0E,$29,$00,$80,$0D,$8E,$12,$D0,$6C	; $88FDD0
	db $A5,$53,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$88,$00,$B0,$5C	; $88FDE0
	db $BD,$FF,$08,$38,$E5,$53,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$85	; $88FDF0
	db $73,$BD,$5F,$09,$38,$E5,$57,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A	; $88FE00
	db $18,$65,$73,$C9,$37,$00,$B0,$34,$BD,$DF,$0A,$85,$7D,$A9,$07,$00	; $88FE10
	db $85,$83,$22,$DB,$FC,$82,$46,$95,$6A,$46,$95,$6A,$46,$95,$6A,$9D	; $88FE20
	db $DF,$0A,$BD,$FF,$0A,$85,$7D,$A9,$07,$00,$85,$83,$22,$DB,$FC,$82	; $88FE30
	db $46,$95,$6A,$46,$95,$6A,$46,$95,$6A,$9D,$FF,$0A,$BD,$7F,$0C,$38	; $88FE40
	db $E5,$6F,$9D,$7F,$0C,$30,$03,$4C,$5D,$FF,$69,$0B,$00,$9D,$7F,$0C	; $88FE50
	db $22,$36,$FE,$8D,$A9,$0D,$00,$85,$55,$A5,$53,$89,$00,$80,$F0,$04	; $88FE60
	db $49,$FF,$FF,$1A,$C9,$88,$00,$B0,$05,$A9,$12,$00,$85,$55,$A5,$EA	; $88FE70
	db $05,$EC,$F0,$12,$A5,$53,$38,$FD,$FF,$08,$85,$53,$A5,$57,$38,$FD	; $88FE80
	db $5F,$09,$85,$57,$80,$5D,$BD,$DF,$0A,$EB,$29,$FF,$00,$89,$80,$00	; $88FE90
	db $F0,$03,$09,$00,$FF,$49,$FF,$FF,$1A,$18,$65,$53,$38,$FD,$FF,$08	; $88FEA0
	db $85,$53,$BD,$FF,$0A,$EB,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00	; $88FEB0
	db $FF,$49,$FF,$FF,$1A,$18,$65,$57,$38,$FD,$5F,$09,$85,$57,$A5,$53	; $88FEC0
	db $89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C5,$55,$B0,$16,$A5,$57,$89	; $88FED0
	db $00,$80,$F0,$04,$49,$FF,$FF,$1A,$C5,$55,$B0,$07,$A9,$09,$00,$85	; $88FEE0
	db $53,$80,$04,$22,$A8,$AF,$80,$A5,$33,$8D,$79,$01,$A5,$34,$8D,$7A	; $88FEF0
	db $01,$22,$78,$01,$00,$A5,$53,$9D,$FF,$0C,$C9,$08,$00,$90,$4E,$BD	; $88FF00
	db $DF,$0A,$1D,$FF,$0A,$D0,$46,$AD,$1B,$09,$85,$53,$AD,$7B,$09,$85	; $88FF10
	db $57,$AD,$7B,$11,$F0,$0A,$AD,$F5,$08,$85,$53,$AD,$F7,$08,$85,$57	; $88FF20
	db $A5,$53,$38,$FD,$FF,$08,$85,$53,$A5,$57,$38,$FD,$5F,$09,$85,$57	; $88FF30
	db $22,$A8,$AF,$80,$38,$FD,$BF,$0D,$F0,$13,$49,$FF,$FF,$1A,$29,$04	; $88FF40
	db $00,$4A,$3A,$18,$7D,$BF,$0D,$29,$07,$00,$9D,$BF,$0D,$BD,$FF,$0C	; $88FF50
	db $85,$53,$5C,$DC,$FB,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FF60
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FF70
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FF80
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FF90
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FFA0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FFB0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FFC0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FFD0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FFE0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $88FFF0
