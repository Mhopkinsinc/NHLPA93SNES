; $80CEE7-$80DFFF  ROM $04EE7 (from src/bank80.asm; quick pass, TODO segment agents refine). Starts at checkgoal (boundary moved from $80D002)
org $80CEE7
	lda.w $099F,x		; $80CEE7: BD 9F 09
	sec		; $80CEEA: 38
	sbc.w #$000D		; $80CEEB: E9 0D 00
	beq CODE_80CEF9		; $80CEEE: F0 09
	bmi CODE_80CEF7		; $80CEF0: 30 05
	bvs CODE_80CEF9		; $80CEF2: 70 05
CODE_80CEF4:		; M=16 X=16
	jmp.w $D113		; $80CEF4: 4C 13 D1
CODE_80CEF7:		; M=16 X=16
	bvs CODE_80CEF4		; $80CEF7: 70 FB
CODE_80CEF9:		; M=16 X=16
	cpx.w #$001C		; $80CEF9: E0 1C 00
	beq CODE_80CF01		; $80CEFC: F0 03
	jmp.w $D3D3		; $80CEFE: 4C D3 D3
CODE_80CF01:		; M=16 X=16
	ldy.b $3B		; $80CF01: A4 3B
	lda.w #$0010		; $80CF03: A9 10 00
	clc		; $80CF06: 18
	adc.w $08E3		; $80CF07: 6D E3 08
	sta.b $63		; $80CF0A: 85 63
	lda.b $5B		; $80CF0C: A5 5B
	sec		; $80CF0E: 38
	sbc.w $08FF,y		; $80CF0F: F9 FF 08
	sta.b $5B		; $80CF12: 85 5B
	sec		; $80CF14: 38
	sbc.b $63		; $80CF15: E5 63
	beq CODE_80CF22		; $80CF17: F0 09
	bmi CODE_80CF20		; $80CF19: 30 05
	bvs CODE_80CF22		; $80CF1B: 70 05
CODE_80CF1D:		; M=16 X=16
	jmp.w $D113		; $80CF1D: 4C 13 D1
CODE_80CF20:		; M=16 X=16
	bvs CODE_80CF1D		; $80CF20: 70 FB
CODE_80CF22:		; M=16 X=16
	lda.b $63		; $80CF22: A5 63
	eor.w #$FFFF		; $80CF24: 49 FF FF
	inc a		; $80CF27: 1A
	sta.b $63		; $80CF28: 85 63
	lda.b $5B		; $80CF2A: A5 5B
	sec		; $80CF2C: 38
	sbc.b $63		; $80CF2D: E5 63
	bmi CODE_80CF36		; $80CF2F: 30 05
	bvc CODE_80CF38		; $80CF31: 50 05
CODE_80CF33:		; M=16 X=16
	jmp.w $D113		; $80CF33: 4C 13 D1
CODE_80CF36:		; M=16 X=16
	bvc CODE_80CF33		; $80CF36: 50 FB
CODE_80CF38:		; M=16 X=16
	lda.w #$0004		; $80CF38: A9 04 00
	clc		; $80CF3B: 18
	adc.w $08E5		; $80CF3C: 6D E5 08
	sta.b $67		; $80CF3F: 85 67
	lda.b $5F		; $80CF41: A5 5F
	sec		; $80CF43: 38
	sbc.w $095F,y		; $80CF44: F9 5F 09
	sta.b $5F		; $80CF47: 85 5F
	sec		; $80CF49: 38
	sbc.b $67		; $80CF4A: E5 67
	beq CODE_80CF57		; $80CF4C: F0 09
	bmi CODE_80CF55		; $80CF4E: 30 05
	bvs CODE_80CF57		; $80CF50: 70 05
CODE_80CF52:		; M=16 X=16
	jmp.w $D113		; $80CF52: 4C 13 D1
CODE_80CF55:		; M=16 X=16
	bvs CODE_80CF52		; $80CF55: 70 FB
CODE_80CF57:		; M=16 X=16
	lda.b $67		; $80CF57: A5 67
	eor.w #$FFFF		; $80CF59: 49 FF FF
	inc a		; $80CF5C: 1A
	sta.b $67		; $80CF5D: 85 67
	lda.b $5F		; $80CF5F: A5 5F
	sec		; $80CF61: 38
	sbc.b $67		; $80CF62: E5 67
	bmi CODE_80CF6B		; $80CF64: 30 05
	bvc CODE_80CF6D		; $80CF66: 50 05
CODE_80CF68:		; M=16 X=16
	jmp.w $D113		; $80CF68: 4C 13 D1
CODE_80CF6B:		; M=16 X=16
	bvc CODE_80CF68		; $80CF6B: 50 FB
CODE_80CF6D:		; M=16 X=16
	lda.w #$FFFF		; $80CF6D: A9 FF FF
	sta.b $D8		; $80CF70: 85 D8
	lda.w $0ABB		; $80CF72: AD BB 0A
	sec		; $80CF75: 38
	sbc.w #$000D		; $80CF76: E9 0D 00
	bmi CODE_80CF7F		; $80CF79: 30 04
	bvc CODE_80CF81		; $80CF7B: 50 04
	bra CODE_80CF8A		; $80CF7D: 80 0B
CODE_80CF7F:		; M=16 X=16
	bvc CODE_80CF8A		; $80CF7F: 50 09
CODE_80CF81:		; M=16 X=16
	lda.w $0ABB		; $80CF81: AD BB 0A
	sta.w $09BB		; $80CF84: 8D BB 09
	jmp.w $D104		; $80CF87: 4C 04 D1
CODE_80CF8A:		; M=16 X=16
	stz.w $115B		; $80CF8A: 9C 5B 11
	lda.w $0EBB		; $80CF8D: AD BB 0E
	bmi CODE_80CFBC		; $80CF90: 30 2A
	asl a		; $80CF92: 0A
	tay		; $80CF93: A8
	lda.w #$FFFF		; $80CF94: A9 FF FF
	sta.w $0EBB		; $80CF97: 8D BB 0E
	lda.w #$0008		; $80CF9A: A9 08 00
	sta.w $0E5F,y		; $80CF9D: 99 5F 0E
	lda.w $097B		; $80CFA0: AD 7B 09
	sta.b $57		; $80CFA3: 85 57
	lda.w $113F,y		; $80CFA5: B9 3F 11
	bne CODE_80CFB2		; $80CFA8: D0 08
	lda.b $57		; $80CFAA: A5 57
	eor.w #$FFFF		; $80CFAC: 49 FF FF
	inc a		; $80CFAF: 1A
	sta.b $57		; $80CFB0: 85 57
CODE_80CFB2:		; M=16 X=16
	lda.b $57		; $80CFB2: A5 57
	bpl CODE_80CFBC		; $80CFB4: 10 06
	lda.w #$0001		; $80CFB6: A9 01 00
	sta.w $115B		; $80CFB9: 8D 5B 11
CODE_80CFBC:		; M=16 X=16
	lda.w #$FF00		; $80CFBC: A9 00 FF
	sta.b $53		; $80CFBF: 85 53
	lda.w $097F,x		; $80CFC1: BD 7F 09
	sec		; $80CFC4: 38
	sbc.w $0A7F,x		; $80CFC5: FD 7F 0A
	sta.b $57		; $80CFC8: 85 57
	lda.w $095F,x		; $80CFCA: BD 5F 09
	sbc.w $0A5F,x		; $80CFCD: FD 5F 0A
	sta.b $59		; $80CFD0: 85 59
	lda.b $58		; $80CFD2: A5 58
	sta.b $57		; $80CFD4: 85 57
	bne CODE_80CFDB		; $80CFD6: D0 03
	jmp.w $D114		; $80CFD8: 4C 14 D1
CODE_80CFDB:		; M=16 X=16
	bmi CODE_80CFED		; $80CFDB: 30 10
	lda.b $53		; $80CFDD: A5 53
	eor.w #$FFFF		; $80CFDF: 49 FF FF
	inc a		; $80CFE2: 1A
	sta.b $53		; $80CFE3: 85 53
	lda.b $67		; $80CFE5: A5 67
	eor.w #$FFFF		; $80CFE7: 49 FF FF
	inc a		; $80CFEA: 1A
	sta.b $67		; $80CFEB: 85 67
CODE_80CFED:		; M=16 X=16
	lda.b $67		; $80CFED: A5 67
	clc		; $80CFEF: 18
	adc.b $5F		; $80CFF0: 65 5F
	sta.b $67		; $80CFF2: 85 67
	sta.b $83		; $80CFF4: 85 83
	lda.w $091F,x		; $80CFF6: BD 1F 09
	sec		; $80CFF9: 38
	sbc.w $0A3F,x		; $80CFFA: FD 3F 0A
	sta.b $5F		; $80CFFD: 85 5F
	lda.w $08FF,x		; $80CFFF: BD FF 08
	sbc.w $0A1F,x		; $80D002: FD 1F 0A
	sta.b $61		; $80D005: 85 61
	lda.b $60		; $80D007: A5 60
	sta.b $5F		; $80D009: 85 5F
	sta.b $7D		; $80D00B: 85 7D
	jsl.l $82FCDB		; $80D00D: 22 DB FC 82
	lda.b $57		; $80D011: A5 57
	bit.w #$8000		; $80D013: 89 00 80
	beq CODE_80D01C		; $80D016: F0 04
	eor.w #$FFFF		; $80D018: 49 FF FF
	inc a		; $80D01B: 1A
CODE_80D01C:		; M=16 X=16
	sta.b $7D		; $80D01C: 85 7D
	lda.b $95		; $80D01E: A5 95
	bit.w #$8000		; $80D020: 89 00 80
	beq CODE_80D029		; $80D023: F0 04
	eor.w #$FFFF		; $80D025: 49 FF FF
	inc a		; $80D028: 1A
CODE_80D029:		; M=16 X=16
	cmp.b $7D		; $80D029: C5 7D
	bcc CODE_80D030		; $80D02B: 90 03
	jmp.w $D114		; $80D02D: 4C 14 D1
CODE_80D030:		; M=16 X=16
	lda.b $57		; $80D030: A5 57
	sta.b $7D		; $80D032: 85 7D
	jsl.l $80996C		; $80D034: 22 6C 99 80
	sta.b $67		; $80D038: 85 67
	lda.b $5B		; $80D03A: A5 5B
	sec		; $80D03C: 38
	sbc.b $67		; $80D03D: E5 67
	sta.b $5B		; $80D03F: 85 5B
	sec		; $80D041: 38
	sbc.b $63		; $80D042: E5 63
	bmi CODE_80D04B		; $80D044: 30 05
	bvc CODE_80D04D		; $80D046: 50 05
CODE_80D048:		; M=16 X=16
	jmp.w $D114		; $80D048: 4C 14 D1
CODE_80D04B:		; M=16 X=16
	bvc CODE_80D048		; $80D04B: 50 FB
CODE_80D04D:		; M=16 X=16
	lda.b $63		; $80D04D: A5 63
	eor.w #$FFFF		; $80D04F: 49 FF FF
	inc a		; $80D052: 1A
	sta.b $63		; $80D053: 85 63
	lda.b $5B		; $80D055: A5 5B
	sec		; $80D057: 38
	sbc.b $63		; $80D058: E5 63
	beq CODE_80D065		; $80D05A: F0 09
	bmi CODE_80D063		; $80D05C: 30 05
	bvs CODE_80D065		; $80D05E: 70 05
CODE_80D060:		; M=16 X=16
	jmp.w $D114		; $80D060: 4C 14 D1
CODE_80D063:		; M=16 X=16
	bvs CODE_80D060		; $80D063: 70 FB
CODE_80D065:		; M=16 X=16
	stz.b $57		; $80D065: 64 57
	lda.w $097B		; $80D067: AD 7B 09
	eor.b $53		; $80D06A: 45 53
	bpl CODE_80D071		; $80D06C: 10 03
	jmp.w $CCDE		; $80D06E: 4C DE CC
CODE_80D071:		; M=16 X=16
	lda.b $53		; $80D071: A5 53
	eor.w #$FFFF		; $80D073: 49 FF FF
	inc a		; $80D076: 1A
	sta.b $53		; $80D077: 85 53
	lda.w $115B		; $80D079: AD 5B 11
	beq CODE_80D081		; $80D07C: F0 03
	jmp.w $CCDE		; $80D07E: 4C DE CC
CODE_80D081:		; M=16 X=16
	lda.w $09BB		; $80D081: AD BB 09
	cmp.w #$000D		; $80D084: C9 0D 00
	beq CODE_80D0B6		; $80D087: F0 2D
	lda.b $63		; $80D089: A5 63
	sec		; $80D08B: 38
	sbc.w #$0005		; $80D08C: E9 05 00
	sta.b $63		; $80D08F: 85 63
	lda.b $5B		; $80D091: A5 5B
	sec		; $80D093: 38
	sbc.b $63		; $80D094: E5 63
	beq CODE_80D0A0		; $80D096: F0 08
	bmi CODE_80D09E		; $80D098: 30 04
	bvs CODE_80D0A0		; $80D09A: 70 04
	bra CODE_80D0B6		; $80D09C: 80 18
CODE_80D09E:		; M=16 X=16
	bvs CODE_80D0B6		; $80D09E: 70 16
CODE_80D0A0:		; M=16 X=16
	lda.b $63		; $80D0A0: A5 63
	eor.w #$FFFF		; $80D0A2: 49 FF FF
	inc a		; $80D0A5: 1A
	sta.b $63		; $80D0A6: 85 63
	lda.b $5B		; $80D0A8: A5 5B
	sec		; $80D0AA: 38
	sbc.b $63		; $80D0AB: E5 63
	bmi CODE_80D0B4		; $80D0AD: 30 05
	bvs CODE_80D0B6		; $80D0AF: 70 05
CODE_80D0B1:		; M=16 X=16
	jmp.w $D182		; $80D0B1: 4C 82 D1
CODE_80D0B4:		; M=16 X=16
	bvs CODE_80D0B1		; $80D0B4: 70 FB
CODE_80D0B6:		; M=16 X=16
	jsl.l $80D12E		; $80D0B6: 22 2E D1 80
	lda.w #$0094		; $80D0BA: A9 94 00
	pha		; $80D0BD: 48
	jsl.l $80C28B		; $80D0BE: 22 8B C2 80
	lda.b $DE		; $80D0C2: A5 DE
	clc		; $80D0C4: 18
	adc.w #$012C		; $80D0C5: 69 2C 01
	sta.b $DE		; $80D0C8: 85 DE
	lda.w #$1000		; $80D0CA: A9 00 10
	jsl.l $80AE8B		; $80D0CD: 22 8B AE 80
	sta.b $53		; $80D0D1: 85 53
	lda.w $097B		; $80D0D3: AD 7B 09
	bmi CODE_80D0E0		; $80D0D6: 30 08
	lda.b $53		; $80D0D8: A5 53
	eor.w #$FFFF		; $80D0DA: 49 FF FF
	inc a		; $80D0DD: 1A
	sta.b $53		; $80D0DE: 85 53
CODE_80D0E0:		; M=16 X=16
	lda.b $53		; $80D0E0: A5 53
	sta.w $0B1B		; $80D0E2: 8D 1B 0B
	lda.w #$2000		; $80D0E5: A9 00 20
	jsl.l $80AE8B		; $80D0E8: 22 8B AE 80
	sec		; $80D0EC: 38
	sbc.w #$1000		; $80D0ED: E9 00 10
	sta.w $0AFB		; $80D0F0: 8D FB 0A
	lda.w #$2000		; $80D0F3: A9 00 20
	jsl.l $80AE8B		; $80D0F6: 22 8B AE 80
	sec		; $80D0FA: 38
	sbc.w #$1000		; $80D0FB: E9 00 10
	sta.w $0B3B		; $80D0FE: 8D 3B 0B
	jmp.w $CEC9		; $80D101: 4C C9 CE
CODE_80D104:		; M=16 X=16
	lda.w $0B3B		; $80D104: AD 3B 0B
	bit.w #$8000		; $80D107: 89 00 80
	beq CODE_80D110		; $80D10A: F0 04
	eor.w #$FFFF		; $80D10C: 49 FF FF
	inc a		; $80D10F: 1A
CODE_80D110:		; M=16 X=16
	sta.w $0B3B		; $80D110: 8D 3B 0B
CODE_80D113:		; M=16 X=16
	rtl		; $80D113: 6B
CODE_80D114:		; M=16 X=16
	stz.b $53		; $80D114: 64 53
	lda.w #$0100		; $80D116: A9 00 01
	sta.b $57		; $80D119: 85 57
	lda.w $091B		; $80D11B: AD 1B 09
	sec		; $80D11E: 38
	sbc.w $0A3B		; $80D11F: ED 3B 0A
	sta.b $5B		; $80D122: 85 5B
	bmi CODE_80D12B		; $80D124: 30 05
	lda.w #$FF00		; $80D126: A9 00 FF
	sta.b $57		; $80D129: 85 57
CODE_80D12B:		; M=16 X=16
	jmp.w $CCDE		; $80D12B: 4C DE CC
CODE_80D12E:		; M=16 X=16
	lda.w #$1000		; $80D12E: A9 00 10
	trb.w $128C		; $80D131: 1C 8C 12
	beq CODE_80D16E		; $80D134: F0 38
	stx.b $0A		; $80D136: 86 0A
	ldx.w #$0000		; $80D138: A2 00 00
CODE_80D13B:		; M=16 X=16
	lda.b $53,x		; $80D13B: B5 53
	pha		; $80D13D: 48
	inx		; $80D13E: E8
	inx		; $80D13F: E8
	cpx.w #$0008		; $80D140: E0 08 00
	bne CODE_80D13B		; $80D143: D0 F6
	ldx.b $0A		; $80D145: A6 0A
	phx		; $80D147: DA
	lda.w $04A5		; $80D148: AD A5 04
	asl a		; $80D14B: 0A
	tax		; $80D14C: AA
	stx.b $3F		; $80D14D: 86 3F
	lda.w #$0001		; $80D14F: A9 01 00
	sta.b $53		; $80D152: 85 53
	lda.w #$13B2		; $80D154: A9 B2 13
	sta.b $57		; $80D157: 85 57
	jsl.l $80D16F		; $80D159: 22 6F D1 80
	plx		; $80D15D: FA
	stx.b $3F		; $80D15E: 86 3F
	stx.b $0A		; $80D160: 86 0A
	ldx.w #$0006		; $80D162: A2 06 00
CODE_80D165:		; M=16 X=16
	pla		; $80D165: 68
	sta.b $53,x		; $80D166: 95 53
	dex		; $80D168: CA
	dex		; $80D169: CA
	bpl CODE_80D165		; $80D16A: 10 F9
	ldx.b $0A		; $80D16C: A6 0A
CODE_80D16E:		; M=16 X=16
	rtl		; $80D16E: 6B
CODE_80D16F:		; M=16 X=16
	ldy.b $57		; $80D16F: A4 57
	lda.w $119F,x		; $80D171: BD 9F 11
	beq CODE_80D178		; $80D174: F0 02
	iny		; $80D176: C8
	iny		; $80D177: C8
CODE_80D178:		; M=16 X=16
	lda.w $0000,y		; $80D178: B9 00 00
	clc		; $80D17B: 18
	adc.b $53		; $80D17C: 65 53
	sta.w $0000,y		; $80D17E: 99 00 00
	rtl		; $80D181: 6B
CODE_80D182:		; M=16 X=16
	lda.w $128A		; $80D182: AD 8A 12
	beq CODE_80D18A		; $80D185: F0 03
	jmp.w $D328		; $80D187: 4C 28 D3
CODE_80D18A:		; M=16 X=16
	lda.w $097B		; $80D18A: AD 7B 09
	eor.w $0B1B		; $80D18D: 4D 1B 0B
	bpl CODE_80D195		; $80D190: 10 03
	jmp.w $D328		; $80D192: 4C 28 D3
CODE_80D195:		; M=16 X=16
	jsl.l $80D12E		; $80D195: 22 2E D1 80
	jsl.l $82FA1A		; $80D199: 22 1A FA 82
	lda.w #$00A0		; $80D19D: A9 A0 00
	pha		; $80D1A0: 48
	jsl.l $80C28B		; $80D1A1: 22 8B C2 80
	lda.b $00		; $80D1A5: A5 00
	sta.w $04A7		; $80D1A7: 8D A7 04
	jsl.l $80C278		; $80D1AA: 22 78 C2 80
	lda.b $DE		; $80D1AE: A5 DE
	clc		; $80D1B0: 18
	adc.w #$01F4		; $80D1B1: 69 F4 01
	sta.b $DE		; $80D1B4: 85 DE
	stz.b $3B		; $80D1B6: 64 3B
	lda.w #$0002		; $80D1B8: A9 02 00
	sta.b $37		; $80D1BB: 85 37
	lda.w $095F,x		; $80D1BD: BD 5F 09
	bpl CODE_80D1C9		; $80D1C0: 10 07
	stz.b $37		; $80D1C2: 64 37
	lda.w #$0002		; $80D1C4: A9 02 00
	sta.b $3B		; $80D1C7: 85 3B
CODE_80D1C9:		; M=16 X=16
	lda.w $1288		; $80D1C9: AD 88 12
	bit.w #$0002		; $80D1CC: 89 02 00
	beq CODE_80D1DA		; $80D1CF: F0 09
	lda.b $37		; $80D1D1: A5 37
	sta.b $3B		; $80D1D3: 85 3B
	eor.w #$0002		; $80D1D5: 49 02 00
	sta.b $37		; $80D1D8: 85 37
CODE_80D1DA:		; M=16 X=16
	ldy.b $3B		; $80D1DA: A4 3B
	lda.w $13D6,y		; $80D1DC: B9 D6 13
	inc a		; $80D1DF: 1A
	sta.w $13D6,y		; $80D1E0: 99 D6 13
	lda.w $12FC		; $80D1E3: AD FC 12
	cmp.w #$00B4		; $80D1E6: C9 B4 00
	bne CODE_80D1F2		; $80D1E9: D0 07
	sec		; $80D1EB: 38
	sbc.w #$0006		; $80D1EC: E9 06 00
	sta.w $12FC		; $80D1EF: 8D FC 12
CODE_80D1F2:		; M=16 X=16
	lda.w #$0000		; $80D1F2: A9 00 00
	sta.b $35		; $80D1F5: 85 35
	lda.w #$12FE		; $80D1F7: A9 FE 12
	clc		; $80D1FA: 18
	adc.w $12FC		; $80D1FB: 6D FC 12
	sta.b $33		; $80D1FE: 85 33
	lda.w $12FC		; $80D200: AD FC 12
	adc.w #$0006		; $80D203: 69 06 00
	sta.w $12FC		; $80D206: 8D FC 12
	jsl.l $86FC8A		; $80D209: 22 8A FC 86
	lda.b $53		; $80D20D: A5 53
	sta.b [$33]		; $80D20F: 87 33
	inc.b $33		; $80D211: E6 33
	inc.b $33		; $80D213: E6 33
	lda.w #$0002		; $80D215: A9 02 00
	clc		; $80D218: 18
	ldy.b $3B		; $80D219: A4 3B
	adc.w $13EE,y		; $80D21B: 79 EE 13
	ldy.b $37		; $80D21E: A4 37
	sec		; $80D220: 38
	sbc.w $13EE,y		; $80D221: F9 EE 13
	ldy.b $3B		; $80D224: A4 3B
	beq CODE_80D22B		; $80D226: F0 03
	ora.w #$0080		; $80D228: 09 80 00
CODE_80D22B:		; M=16 X=16
	sta.b [$33]		; $80D22B: 87 33
	inc.b $33		; $80D22D: E6 33
	lda.w $13E2,y		; $80D22F: B9 E2 13
	sta.b $53		; $80D232: 85 53
	sta.b [$33]		; $80D234: 87 33
	inc.b $33		; $80D236: E6 33
	lda.w #$FFFF		; $80D238: A9 FF FF
	sta.b [$33]		; $80D23B: 87 33
	lda.b $3B		; $80D23D: A5 3B
	beq CODE_80D244		; $80D23F: F0 03
	lda.w #$001A		; $80D241: A9 1A 00
CODE_80D244:		; M=16 X=16
	clc		; $80D244: 18
	adc.b $53		; $80D245: 65 53
	tay		; $80D247: A8
	sep #$20		; $80D248: E2 20
	lda.w $1412,y		; $80D24A: B9 12 14
	inc a		; $80D24D: 1A
	sta.w $1412,y		; $80D24E: 99 12 14
	rep #$20		; $80D251: C2 20
	ldy.b $3B		; $80D253: A4 3B
	lda.w $13E6,y		; $80D255: B9 E6 13
	bmi CODE_80D26D		; $80D258: 30 13
	sep #$20		; $80D25A: E2 20
	sta.b [$33]		; $80D25C: 87 33
	rep #$20		; $80D25E: C2 20
	inc.b $33		; $80D260: E6 33
	lda.w $13EA,y		; $80D262: B9 EA 13
	bmi CODE_80D26D		; $80D265: 30 06
	sep #$20		; $80D267: E2 20
	sta.b [$33]		; $80D269: 87 33
	rep #$20		; $80D26B: C2 20
CODE_80D26D:		; M=16 X=16
	jsl.l $80D329		; $80D26D: 22 29 D3 80
	jsl.l $89E95D		; $80D271: 22 5D E9 89
	lda.w #$0007		; $80D275: A9 07 00
	sta.b $53		; $80D278: 85 53
	jsl.l $80D302		; $80D27A: 22 02 D3 80
	lda.b $3B		; $80D27E: A5 3B
	bne CODE_80D293		; $80D280: D0 11
	lda.w $13D8		; $80D282: AD D8 13
	sec		; $80D285: 38
	sbc.w $13D6		; $80D286: ED D6 13
	bmi CODE_80D293		; $80D289: 30 08
	cmp.w #$0003		; $80D28B: C9 03 00
	bcs CODE_80D293		; $80D28E: B0 03
	inc.w $0429		; $80D290: EE 29 04
CODE_80D293:		; M=16 X=16
	stz.b $D8		; $80D293: 64 D8
	stz.w $0AFB		; $80D295: 9C FB 0A
	stz.w $0B1B		; $80D298: 9C 1B 0B
	lda.w #$0006		; $80D29B: A9 06 00
	sta.b $53		; $80D29E: 85 53
	lda.w $091B		; $80D2A0: AD 1B 09
	bpl CODE_80D2AA		; $80D2A3: 10 05
	lda.w #$FFFA		; $80D2A5: A9 FA FF
	sta.b $53		; $80D2A8: 85 53
CODE_80D2AA:		; M=16 X=16
	lda.b $53		; $80D2AA: A5 53
	sta.w $091B		; $80D2AC: 8D 1B 09
	lda.w #$0110		; $80D2AF: A9 10 01
	sta.b $53		; $80D2B2: 85 53
	lda.w $097B		; $80D2B4: AD 7B 09
	bpl CODE_80D2BE		; $80D2B7: 10 05
	lda.w #$FEF0		; $80D2B9: A9 F0 FE
	sta.b $53		; $80D2BC: 85 53
CODE_80D2BE:		; M=16 X=16
	lda.b $53		; $80D2BE: A5 53
	sta.w $097B		; $80D2C0: 8D 7B 09
	lda.w #$0600		; $80D2C3: A9 00 06
	sta.w $0B3B		; $80D2C6: 8D 3B 0B
	stz.w $09BB		; $80D2C9: 9C BB 09
	lda.w #$FFFF		; $80D2CC: A9 FF FF
	sta.w $048B		; $80D2CF: 8D 8B 04
	sta.w $048F		; $80D2D2: 8D 8F 04
	sta.w $121B		; $80D2D5: 8D 1B 12
	lda.w #$001A		; $80D2D8: A9 1A 00
	sta.b $53		; $80D2DB: 85 53
	jsl.l $80B4A7		; $80D2DD: 22 A7 B4 80
	inx		; $80D2E1: E8
	inx		; $80D2E2: E8
	lda.w #$10DA		; $80D2E3: A9 DA 10
	sta.b $57		; $80D2E6: 85 57
	jsl.l $80B006		; $80D2E8: 22 06 B0 80
	ldy.b $3B		; $80D2EC: A4 3B
	ldx.w $13D2,y		; $80D2EE: BE D2 13
	stx.b $3F		; $80D2F1: 86 3F
	lda.w #$000E		; $80D2F3: A9 0E 00
	sta.b $53		; $80D2F6: 85 53
	jsl.l $80C1B0		; $80D2F8: 22 B0 C1 80
	ldx.w #$001C		; $80D2FC: A2 1C 00
	stx.b $3F		; $80D2FF: 86 3F
	rtl		; $80D301: 6B
CODE_80D302:		; M=16 X=16
	phx		; $80D302: DA
	ldy.b $3B		; $80D303: A4 3B
	lda.w $13D2,y		; $80D305: B9 D2 13
	tax		; $80D308: AA
	lda.w #$0005		; $80D309: A9 05 00
	sta.b $5F		; $80D30C: 85 5F
CODE_80D30E:		; M=16 X=16
	lda.w $0B9F,x		; $80D30E: BD 9F 0B
	bmi CODE_80D321		; $80D311: 30 0E
	beq CODE_80D321		; $80D313: F0 0C
	lda.w $115F,x		; $80D315: BD 5F 11
	bne CODE_80D321		; $80D318: D0 07
	stz.w $11FF,x		; $80D31A: 9E FF 11
	jsl.l $80B49D		; $80D31D: 22 9D B4 80
CODE_80D321:		; M=16 X=16
	inx		; $80D321: E8
	inx		; $80D322: E8
	dec.b $5F		; $80D323: C6 5F
	bpl CODE_80D30E		; $80D325: 10 E7
	plx		; $80D327: FA
CODE_80D328:		; M=16 X=16
	rtl		; $80D328: 6B
CODE_80D329:		; M=16 X=16
	stx.b $0A		; $80D329: 86 0A
	ldx.w #$0000		; $80D32B: A2 00 00
CODE_80D32E:		; M=16 X=16
	lda.b $53,x		; $80D32E: B5 53
	pha		; $80D330: 48
	inx		; $80D331: E8
	inx		; $80D332: E8
	cpx.w #$000C		; $80D333: E0 0C 00
	bne CODE_80D32E		; $80D336: D0 F6
	ldx.b $0A		; $80D338: A6 0A
	stx.b $0A		; $80D33A: 86 0A
	ldx.w #$0000		; $80D33C: A2 00 00
CODE_80D33F:		; M=16 X=16
	lda.b $33,x		; $80D33F: B5 33
	pha		; $80D341: 48
	inx		; $80D342: E8
	inx		; $80D343: E8
	cpx.w #$0004		; $80D344: E0 04 00
	bne CODE_80D33F		; $80D347: D0 F6
	ldx.b $0A		; $80D349: A6 0A
	jsl.l $8FE2F9		; $80D34B: 22 F9 E2 8F
	ldy.b $3B		; $80D34F: A4 3B
	lda.w $13EE,y		; $80D351: B9 EE 13
	ldy.b $37		; $80D354: A4 37
	sec		; $80D356: 38
	sbc.w $13EE,y		; $80D357: F9 EE 13
	beq CODE_80D3B6		; $80D35A: F0 5A
	bmi CODE_80D362		; $80D35C: 30 04
	bvc CODE_80D364		; $80D35E: 50 04
	bra CODE_80D3B6		; $80D360: 80 54
CODE_80D362:		; M=16 X=16
	bvc CODE_80D3B6		; $80D362: 50 52
CODE_80D364:		; M=16 X=16
	lda.b $37		; $80D364: A5 37
	beq CODE_80D36B		; $80D366: F0 03
	lda.w #$001A		; $80D368: A9 1A 00
CODE_80D36B:		; M=16 X=16
	sta.b $33		; $80D36B: 85 33
CODE_80D36D:		; M=16 X=16
	ldy.b $33		; $80D36D: A4 33
	lda.w $154A,y		; $80D36F: B9 4A 15
	inc.b $33		; $80D372: E6 33
	and.w #$00FF		; $80D374: 29 FF 00
	sta.b $5B		; $80D377: 85 5B
	bit.w #$0080		; $80D379: 89 80 00
	bne CODE_80D3B6		; $80D37C: D0 38
	lda.b $37		; $80D37E: A5 37
	beq CODE_80D385		; $80D380: F0 03
	lda.w #$0034		; $80D382: A9 34 00
CODE_80D385:		; M=16 X=16
	clc		; $80D385: 18
	adc.b $5B		; $80D386: 65 5B
	tay		; $80D388: A8
	lda.w $14E2,y		; $80D389: B9 E2 14
	bit.w #$4000		; $80D38C: 89 00 40
	bne CODE_80D36D		; $80D38F: D0 DC
	lda.w #$0000		; $80D391: A9 00 00
	sta.w $14E2,y		; $80D394: 99 E2 14
	jsl.l $8FDAFC		; $80D397: 22 FC DA 8F
	ldy.b $37		; $80D39B: A4 37
	lda.w $13EE,y		; $80D39D: B9 EE 13
	inc a		; $80D3A0: 1A
	sta.w $13EE,y		; $80D3A1: 99 EE 13
	ldy.b $3B		; $80D3A4: A4 3B
	lda.w $13B6,y		; $80D3A6: B9 B6 13
	inc a		; $80D3A9: 1A
	sta.w $13B6,y		; $80D3AA: 99 B6 13
	lda.w #$0001		; $80D3AD: A9 01 00
	tsb.w $140A		; $80D3B0: 0C 0A 14
	tsb.w $140C		; $80D3B3: 0C 0C 14
CODE_80D3B6:		; M=16 X=16
	stx.b $0A		; $80D3B6: 86 0A
	ldx.w #$0002		; $80D3B8: A2 02 00
CODE_80D3BB:		; M=16 X=16
	pla		; $80D3BB: 68
	sta.b $33,x		; $80D3BC: 95 33
	dex		; $80D3BE: CA
	dex		; $80D3BF: CA
	bpl CODE_80D3BB		; $80D3C0: 10 F9
	ldx.b $0A		; $80D3C2: A6 0A
	stx.b $0A		; $80D3C4: 86 0A
	ldx.w #$000A		; $80D3C6: A2 0A 00
CODE_80D3C9:		; M=16 X=16
	pla		; $80D3C9: 68
	sta.b $53,x		; $80D3CA: 95 53
	dex		; $80D3CC: CA
	dex		; $80D3CD: CA
	bpl CODE_80D3C9		; $80D3CE: 10 F9
	ldx.b $0A		; $80D3D0: A6 0A
	rtl		; $80D3D2: 6B
CODE_80D3D3:		; M=16 X=16
	lda.w $0EDF,x		; $80D3D3: BD DF 0E
	bit.w #$8000		; $80D3D6: 89 00 80
	beq CODE_80D3DE		; $80D3D9: F0 03
	jmp.w $D4C4		; $80D3DB: 4C C4 D4
CODE_80D3DE:		; M=16 X=16
	lda.w $099F,x		; $80D3DE: BD 9F 09
	sec		; $80D3E1: 38
	sbc.w #$000A		; $80D3E2: E9 0A 00
	beq CODE_80D3F0		; $80D3E5: F0 09
	bmi CODE_80D3EE		; $80D3E7: 30 05
	bvs CODE_80D3F0		; $80D3E9: 70 05
CODE_80D3EB:		; M=16 X=16
	jmp.w $D4C4		; $80D3EB: 4C C4 D4
CODE_80D3EE:		; M=16 X=16
	bvs CODE_80D3EB		; $80D3EE: 70 FB
CODE_80D3F0:		; M=16 X=16
	cpx.w #$0017		; $80D3F0: E0 17 00
	bcc CODE_80D3F8		; $80D3F3: 90 03
	jmp.w $D4C4		; $80D3F5: 4C C4 D4
CODE_80D3F8:		; M=16 X=16
	ldy.b $3B		; $80D3F8: A4 3B
	lda.b $5F		; $80D3FA: A5 5F
	pha		; $80D3FC: 48
	sec		; $80D3FD: 38
	sbc.w $095F,y		; $80D3FE: F9 5F 09
	sta.b $5F		; $80D401: 85 5F
	eor.w #$FFFF		; $80D403: 49 FF FF
	inc a		; $80D406: 1A
	sta.b $53		; $80D407: 85 53
	lda.b $5B		; $80D409: A5 5B
	pha		; $80D40B: 48
	sec		; $80D40C: 38
	sbc.w $08FF,y		; $80D40D: F9 FF 08
	sta.b $57		; $80D410: 85 57
	asl a		; $80D412: 0A
	asl a		; $80D413: 0A
	asl a		; $80D414: 0A
	asl a		; $80D415: 0A
	sta.b $7D		; $80D416: 85 7D
	sta.b $83		; $80D418: 85 83
	jsl.l $82FCDB		; $80D41A: 22 DB FC 82
	lda.w #$0400		; $80D41E: A9 00 04
	sta.b $7D		; $80D421: 85 7D
	jsl.l $80CBE5		; $80D423: 22 E5 CB 80
	cmp.w #$0101		; $80D427: C9 01 01
	bcc CODE_80D42F		; $80D42A: 90 03
	jmp.w $D4BE		; $80D42C: 4C BE D4
CODE_80D42F:		; M=16 X=16
	sta.b $5B		; $80D42F: 85 5B
	lda.b $5F		; $80D431: A5 5F
	asl a		; $80D433: 0A
	asl a		; $80D434: 0A
	asl a		; $80D435: 0A
	asl a		; $80D436: 0A
	sta.b $7D		; $80D437: 85 7D
	sta.b $83		; $80D439: 85 83
	jsl.l $82FCDB		; $80D43B: 22 DB FC 82
	lda.w #$0079		; $80D43F: A9 79 00
	sta.b $7D		; $80D442: 85 7D
	jsl.l $80CBE5		; $80D444: 22 E5 CB 80
	adc.b $5B		; $80D448: 65 5B
	cmp.w #$0101		; $80D44A: C9 01 01
	bcs CODE_80D4BE		; $80D44D: B0 6F
	pla		; $80D44F: 68
	sta.b $5B		; $80D450: 85 5B
	pla		; $80D452: 68
	sta.b $5F		; $80D453: 85 5F
	jsl.l $80D4C5		; $80D455: 22 C5 D4 80
	lda.b $5F		; $80D459: A5 5F
	pha		; $80D45B: 48
	lda.b $5B		; $80D45C: A5 5B
	pha		; $80D45E: 48
	lda.b $57		; $80D45F: A5 57
	pha		; $80D461: 48
	lda.b $53		; $80D462: A5 53
	pha		; $80D464: 48
	sta.b $7D		; $80D465: 85 7D
	sta.b $83		; $80D467: 85 83
	jsl.l $82FCDB		; $80D469: 22 DB FC 82
	sta.b $53		; $80D46D: 85 53
	lda.b $95		; $80D46F: A5 95
	sta.b $55		; $80D471: 85 55
	lda.b $57		; $80D473: A5 57
	sta.b $7D		; $80D475: 85 7D
	sta.b $83		; $80D477: 85 83
	jsl.l $82FCDB		; $80D479: 22 DB FC 82
	adc.b $53		; $80D47D: 65 53
	sta.b $53		; $80D47F: 85 53
	lda.b $55		; $80D481: A5 55
	adc.b $95		; $80D483: 65 95
	sta.b $55		; $80D485: 85 55
	jsl.l $80CBB1		; $80D487: 22 B1 CB 80
	inc a		; $80D48B: 1A
	sta.b $5B		; $80D48C: 85 5B
	sta.b $7D		; $80D48E: 85 7D
	pla		; $80D490: 68
	sta.b $53		; $80D491: 85 53
	pla		; $80D493: 68
	sta.b $57		; $80D494: 85 57
	stz.b $83		; $80D496: 64 83
	lda.b $53		; $80D498: A5 53
	sta.b $84		; $80D49A: 85 84
	lda.b $55		; $80D49C: A5 55
	sta.b $86		; $80D49E: 85 86
	jsl.l $80996C		; $80D4A0: 22 6C 99 80
	sta.b $53		; $80D4A4: 85 53
	lda.b $5B		; $80D4A6: A5 5B
	sta.b $7D		; $80D4A8: 85 7D
	stz.b $83		; $80D4AA: 64 83
	lda.b $57		; $80D4AC: A5 57
	sta.b $84		; $80D4AE: 85 84
	lda.b $59		; $80D4B0: A5 59
	sta.b $86		; $80D4B2: 85 86
	jsl.l $80996C		; $80D4B4: 22 6C 99 80
	sta.b $57		; $80D4B8: 85 57
	jsl.l $80CCDE		; $80D4BA: 22 DE CC 80
CODE_80D4BE:		; M=16 X=16
	pla		; $80D4BE: 68
	sta.b $5B		; $80D4BF: 85 5B
	pla		; $80D4C1: 68
	sta.b $5F		; $80D4C2: 85 5F
CODE_80D4C4:		; M=16 X=16
	rtl		; $80D4C4: 6B
CODE_80D4C5:		; M=16 X=16
	stx.b $0A		; $80D4C5: 86 0A
	ldx.w #$0000		; $80D4C7: A2 00 00
CODE_80D4CA:		; M=16 X=16
	lda.b $53,x		; $80D4CA: B5 53
	pha		; $80D4CC: 48
	inx		; $80D4CD: E8
	inx		; $80D4CE: E8
	cpx.w #$0008		; $80D4CF: E0 08 00
	bne CODE_80D4CA		; $80D4D2: D0 F6
	ldx.b $0A		; $80D4D4: A6 0A
	lda.w $04A1		; $80D4D6: AD A1 04
	and.w #$001F		; $80D4D9: 29 1F 00
	bne CODE_80D51D		; $80D4DC: D0 3F
	ldy.b $3B		; $80D4DE: A4 3B
	lda.w $097B		; $80D4E0: AD 7B 09
	sec		; $80D4E3: 38
	sbc.w $095F,y		; $80D4E4: F9 5F 09
	bit.w #$8000		; $80D4E7: 89 00 80
	beq CODE_80D4F0		; $80D4EA: F0 04
	eor.w #$FFFF		; $80D4EC: 49 FF FF
	inc a		; $80D4EF: 1A
CODE_80D4F0:		; M=16 X=16
	cmp.w #$0029		; $80D4F0: C9 29 00
	bcs CODE_80D51D		; $80D4F3: B0 28
	lda.w $0ADF,x		; $80D4F5: BD DF 0A
	sta.b $53		; $80D4F8: 85 53
	lda.w $0AFF,x		; $80D4FA: BD FF 0A
	sta.b $57		; $80D4FD: 85 57
	bit.w #$8000		; $80D4FF: 89 00 80
	beq CODE_80D508		; $80D502: F0 04
	eor.w #$FFFF		; $80D504: 49 FF FF
	inc a		; $80D507: 1A
CODE_80D508:		; M=16 X=16
	cmp.w #$2001		; $80D508: C9 01 20
	bcs CODE_80D52C		; $80D50B: B0 1F
	lda.b $53		; $80D50D: A5 53
	bit.w #$8000		; $80D50F: 89 00 80
	beq CODE_80D518		; $80D512: F0 04
	eor.w #$FFFF		; $80D514: 49 FF FF
	inc a		; $80D517: 1A
CODE_80D518:		; M=16 X=16
	cmp.w #$2001		; $80D518: C9 01 20
	bcs CODE_80D52C		; $80D51B: B0 0F
CODE_80D51D:		; M=16 X=16
	stx.b $0A		; $80D51D: 86 0A
	ldx.w #$0006		; $80D51F: A2 06 00
CODE_80D522:		; M=16 X=16
	pla		; $80D522: 68
	sta.b $53,x		; $80D523: 95 53
	dex		; $80D525: CA
	dex		; $80D526: CA
	bpl CODE_80D522		; $80D527: 10 F9
	ldx.b $0A		; $80D529: A6 0A
CODE_80D52B:		; M=16 X=16
	rtl		; $80D52B: 6B
CODE_80D52C:		; M=16 X=16
	pla		; $80D52C: 68
	pla		; $80D52D: 68
	pla		; $80D52E: 68
	pla		; $80D52F: 68
	pla		; $80D530: 68
	sep #$20		; $80D531: E2 20
	pla		; $80D533: 68
	rep #$30		; $80D534: C2 30
	lda.b $53		; $80D536: A5 53
	lsr a		; $80D538: 4A
	lsr a		; $80D539: 4A
	bit.w #$2000		; $80D53A: 89 00 20
	beq CODE_80D542		; $80D53D: F0 03
	ora.w #$C000		; $80D53F: 09 00 C0
CODE_80D542:		; M=16 X=16
	sta.b $53		; $80D542: 85 53
	ldy.b $3B		; $80D544: A4 3B
	sta.w $0ADF,y		; $80D546: 99 DF 0A
	lda.b $57		; $80D549: A5 57
	lsr a		; $80D54B: 4A
	lsr a		; $80D54C: 4A
	bit.w #$2000		; $80D54D: 89 00 20
	beq CODE_80D555		; $80D550: F0 03
	ora.w #$C000		; $80D552: 09 00 C0
CODE_80D555:		; M=16 X=16
	sta.b $57		; $80D555: 85 57
	sta.w $0AFF,y		; $80D557: 99 FF 0A
	stz.w $0ADF,x		; $80D55A: 9E DF 0A
	stz.w $0AFF,x		; $80D55D: 9E FF 0A
	lda.w #$0040		; $80D560: A9 40 00
	tsb.w $128C		; $80D563: 0C 8C 12
	lda.w $128A		; $80D566: AD 8A 12
	bne CODE_80D52B		; $80D569: D0 C0
	lda.w #$0008		; $80D56B: A9 08 00
	sta.b $53		; $80D56E: 85 53
	jmp.w $C1B0		; $80D570: 4C B0 C1
CODE_80D573:		; M=16 X=16
	lda.w $0EDF,x		; $80D573: BD DF 0E
	bit.w #$8000		; $80D576: 89 00 80
	beq CODE_80D57E		; $80D579: F0 03
	jmp.w $D631		; $80D57B: 4C 31 D6
CODE_80D57E:		; M=16 X=16
	cpx.w #$0018		; $80D57E: E0 18 00
	bcc CODE_80D586		; $80D581: 90 03
	jmp.w $D631		; $80D583: 4C 31 D6
CODE_80D586:		; M=16 X=16
	lda.w $123F,x		; $80D586: BD 3F 12
	sta.b $57		; $80D589: 85 57
CODE_80D58B:		; M=16 X=16
	ldy.b $57		; $80D58B: A4 57
	cpy.w #$000F		; $80D58D: C0 0F 00
	beq CODE_80D5DD		; $80D590: F0 4B
	lda.w $1260,y		; $80D592: B9 60 12
	and.w #$00FF		; $80D595: 29 FF 00
	sta.b $63		; $80D598: 85 63
	tay		; $80D59A: A8
	lda.w $121F,y		; $80D59B: B9 1F 12
	sec		; $80D59E: 38
	sbc.b $5F		; $80D59F: E5 5F
	sta.b $67		; $80D5A1: 85 67
	sec		; $80D5A3: 38
	sbc.w #$000E		; $80D5A4: E9 0E 00
	beq CODE_80D5B1		; $80D5A7: F0 08
	bmi CODE_80D5AF		; $80D5A9: 30 04
	bvs CODE_80D5B1		; $80D5AB: 70 04
	bra CODE_80D5DD		; $80D5AD: 80 2E
CODE_80D5AF:		; M=16 X=16
	bvs CODE_80D5DD		; $80D5AF: 70 2C
CODE_80D5B1:		; M=16 X=16
	lda.w $08FF,y		; $80D5B1: B9 FF 08
	sec		; $80D5B4: 38
	sbc.b $5B		; $80D5B5: E5 5B
	bit.w #$8000		; $80D5B7: 89 00 80
	beq CODE_80D5C0		; $80D5BA: F0 04
	eor.w #$FFFF		; $80D5BC: 49 FF FF
	inc a		; $80D5BF: 1A
CODE_80D5C0:		; M=16 X=16
	cmp.w #$000F		; $80D5C0: C9 0F 00
	bcs CODE_80D5D9		; $80D5C3: B0 14
	lda.w $0EDF,y		; $80D5C5: B9 DF 0E
	and.w #$8000		; $80D5C8: 29 00 80
	ora.w $11FF,y		; $80D5CB: 19 FF 11
	bne CODE_80D5D9		; $80D5CE: D0 09
	cpy.w #$0018		; $80D5D0: C0 18 00
	bcs CODE_80D5D9		; $80D5D3: B0 04
	jsl.l $80D632		; $80D5D5: 22 32 D6 80
CODE_80D5D9:		; M=16 X=16
	inc.b $57		; $80D5D9: E6 57
	bra CODE_80D58B		; $80D5DB: 80 AE
CODE_80D5DD:		; M=16 X=16
	lda.w $123F,x		; $80D5DD: BD 3F 12
	beq CODE_80D631		; $80D5E0: F0 4F
	sta.b $57		; $80D5E2: 85 57
CODE_80D5E4:		; M=16 X=16
	ldy.b $57		; $80D5E4: A4 57
	lda.w $125E,y		; $80D5E6: B9 5E 12
	and.w #$00FF		; $80D5E9: 29 FF 00
	sta.b $63		; $80D5EC: 85 63
	tay		; $80D5EE: A8
	lda.b $5F		; $80D5EF: A5 5F
	sec		; $80D5F1: 38
	sbc.w $121F,y		; $80D5F2: F9 1F 12
	sta.b $67		; $80D5F5: 85 67
	sec		; $80D5F7: 38
	sbc.w #$000E		; $80D5F8: E9 0E 00
	beq CODE_80D605		; $80D5FB: F0 08
	bmi CODE_80D603		; $80D5FD: 30 04
	bvs CODE_80D605		; $80D5FF: 70 04
	bra CODE_80D631		; $80D601: 80 2E
CODE_80D603:		; M=16 X=16
	bvs CODE_80D631		; $80D603: 70 2C
CODE_80D605:		; M=16 X=16
	lda.w $08FF,y		; $80D605: B9 FF 08
	sec		; $80D608: 38
	sbc.b $5B		; $80D609: E5 5B
	bit.w #$8000		; $80D60B: 89 00 80
	beq CODE_80D614		; $80D60E: F0 04
	eor.w #$FFFF		; $80D610: 49 FF FF
	inc a		; $80D613: 1A
CODE_80D614:		; M=16 X=16
	cmp.w #$000F		; $80D614: C9 0F 00
	bcs CODE_80D62D		; $80D617: B0 14
	lda.w $0EDF,y		; $80D619: B9 DF 0E
	and.w #$8000		; $80D61C: 29 00 80
	ora.w $11FF,y		; $80D61F: 19 FF 11
	bne CODE_80D62D		; $80D622: D0 09
	cpy.w #$0018		; $80D624: C0 18 00
	bcs CODE_80D62D		; $80D627: B0 04
	jsl.l $80D632		; $80D629: 22 32 D6 80
CODE_80D62D:		; M=16 X=16
	dec.b $57		; $80D62D: C6 57
	bne CODE_80D5E4		; $80D62F: D0 B3
CODE_80D631:		; M=16 X=16
	rtl		; $80D631: 6B
CODE_80D632:		; M=16 X=16
	stx.b $0A		; $80D632: 86 0A
	ldx.w #$0000		; $80D634: A2 00 00
CODE_80D637:		; M=16 X=16
	lda.b $53,x		; $80D637: B5 53
	pha		; $80D639: 48
	inx		; $80D63A: E8
	inx		; $80D63B: E8
	cpx.w #$0018		; $80D63C: E0 18 00
	bne CODE_80D637		; $80D63F: D0 F6
	ldx.b $0A		; $80D641: A6 0A
	sty.b $3B		; $80D643: 84 3B
	stz.b $F2		; $80D645: 64 F2
	lda.w $0ADF,x		; $80D647: BD DF 0A
	sec		; $80D64A: 38
	sbc.w $0ADF,y		; $80D64B: F9 DF 0A
	sta.b $53		; $80D64E: 85 53
	lda.w $0AFF,x		; $80D650: BD FF 0A
	sec		; $80D653: 38
	sbc.w $0AFF,y		; $80D654: F9 FF 0A
	sta.b $57		; $80D657: 85 57
	sta.b $83		; $80D659: 85 83
	lda.w $08FF,y		; $80D65B: B9 FF 08
	sec		; $80D65E: 38
	sbc.w $08FF,x		; $80D65F: FD FF 08
	sta.b $5B		; $80D662: 85 5B
	lda.w $095F,y		; $80D664: B9 5F 09
	sec		; $80D667: 38
	sbc.w $095F,x		; $80D668: FD 5F 09
	sta.b $5F		; $80D66B: 85 5F
	sta.b $7D		; $80D66D: 85 7D
	lda.b $57		; $80D66F: A5 57
	pha		; $80D671: 48
	lda.b $53		; $80D672: A5 53
	pha		; $80D674: 48
	jsl.l $82FCDB		; $80D675: 22 DB FC 82
	sta.b $57		; $80D679: 85 57
	lda.b $95		; $80D67B: A5 95
	sta.b $59		; $80D67D: 85 59
	lda.b $5B		; $80D67F: A5 5B
	sta.b $7D		; $80D681: 85 7D
	lda.b $53		; $80D683: A5 53
	sta.b $83		; $80D685: 85 83
	jsl.l $82FCDB		; $80D687: 22 DB FC 82
	adc.b $57		; $80D68B: 65 57
	sta.b $57		; $80D68D: 85 57
	lda.b $59		; $80D68F: A5 59
	adc.b $95		; $80D691: 65 95
	bpl CODE_80D698		; $80D693: 10 03
	jmp.w $D877		; $80D695: 4C 77 D8
CODE_80D698:		; M=16 X=16
	lsr a		; $80D698: 4A
	ror.b $57		; $80D699: 66 57
	lsr a		; $80D69B: 4A
	ror.b $57		; $80D69C: 66 57
	lsr a		; $80D69E: 4A
	ror.b $57		; $80D69F: 66 57
	lsr a		; $80D6A1: 4A
	ror.b $57		; $80D6A2: 66 57
	lda.w $119F,x		; $80D6A4: BD 9F 11
	cmp.w $119F,y		; $80D6A7: D9 9F 11
	beq CODE_80D705		; $80D6AA: F0 59
	lda.b $58		; $80D6AC: A5 58
	and.w #$00FF		; $80D6AE: 29 FF 00
	sta.b $63		; $80D6B1: 85 63
	cmp.w #$0006		; $80D6B3: C9 06 00
	bcs CODE_80D6BD		; $80D6B6: B0 05
	lda.w #$0005		; $80D6B8: A9 05 00
	sta.b $63		; $80D6BB: 85 63
CODE_80D6BD:		; M=16 X=16
	clc		; $80D6BD: 18
	adc.w $0B7F,x		; $80D6BE: 7D 7F 0B
	sta.w $0B7F,x		; $80D6C1: 9D 7F 0B
	lda.w $0B7F,y		; $80D6C4: B9 7F 0B
	clc		; $80D6C7: 18
	adc.b $63		; $80D6C8: 65 63
	sta.w $0B7F,y		; $80D6CA: 99 7F 0B
	lda.w $115F,y		; $80D6CD: B9 5F 11
	bne CODE_80D6D7		; $80D6D0: D0 05
	txa		; $80D6D2: 8A
	lsr a		; $80D6D3: 4A
	sta.w $0B3F,y		; $80D6D4: 99 3F 0B
CODE_80D6D7:		; M=16 X=16
	lda.w $115F,x		; $80D6D7: BD 5F 11
	bne CODE_80D6E1		; $80D6DA: D0 05
	tya		; $80D6DC: 98
	lsr a		; $80D6DD: 4A
	sta.w $0B3F,x		; $80D6DE: 9D 3F 0B
CODE_80D6E1:		; M=16 X=16
	lda.b $63		; $80D6E1: A5 63
	cmp.w #$0014		; $80D6E3: C9 14 00
	bcc CODE_80D6F9		; $80D6E6: 90 11
	lda.w $0EBB		; $80D6E8: AD BB 0E
	cmp.w $0D9F,x		; $80D6EB: DD 9F 0D
	beq CODE_80D6F5		; $80D6EE: F0 05
	cmp.w $0D9F,y		; $80D6F0: D9 9F 0D
	bne CODE_80D6F9		; $80D6F3: D0 04
CODE_80D6F5:		; M=16 X=16
	jsl.l $80D87B		; $80D6F5: 22 7B D8 80
CODE_80D6F9:		; M=16 X=16
	jsl.l $80D88B		; $80D6F9: 22 8B D8 80
	jsl.l $80DB12		; $80D6FD: 22 12 DB 80
	jsl.l $80DC95		; $80D701: 22 95 DC 80
CODE_80D705:		; M=16 X=16
	lda.b $57		; $80D705: A5 57
	sta.b $63		; $80D707: 85 63
	pla		; $80D709: 68
	sta.b $53		; $80D70A: 85 53
	pla		; $80D70C: 68
	sta.b $57		; $80D70D: 85 57
	lda.b $D8		; $80D70F: A5 D8
	bpl CODE_80D716		; $80D711: 10 03
	jmp.w $D868		; $80D713: 4C 68 D8
CODE_80D716:		; M=16 X=16
	lda.b $5B		; $80D716: A5 5B
	sta.b $7D		; $80D718: 85 7D
	lda.b $57		; $80D71A: A5 57
	sta.b $83		; $80D71C: 85 83
	jsl.l $82FCDB		; $80D71E: 22 DB FC 82
	sta.b $57		; $80D722: 85 57
	lda.b $95		; $80D724: A5 95
	sta.b $59		; $80D726: 85 59
	lda.b $5F		; $80D728: A5 5F
	sta.b $7D		; $80D72A: 85 7D
	lda.b $53		; $80D72C: A5 53
	sta.b $83		; $80D72E: 85 83
	jsl.l $82FCDB		; $80D730: 22 DB FC 82
	sec		; $80D734: 38
	sbc.b $57		; $80D735: E5 57
	sta.b $53		; $80D737: 85 53
	lda.b $95		; $80D739: A5 95
	sbc.b $59		; $80D73B: E5 59
	lsr a		; $80D73D: 4A
	ror.b $53		; $80D73E: 66 53
	lsr a		; $80D740: 4A
	ror.b $53		; $80D741: 66 53
	lsr a		; $80D743: 4A
	ror.b $53		; $80D744: 66 53
	lsr a		; $80D746: 4A
	ror.b $53		; $80D747: 66 53
	lda.b $53		; $80D749: A5 53
	sta.b $67		; $80D74B: 85 67
	lda.w $0F3F,x		; $80D74D: BD 3F 0F
	clc		; $80D750: 18
	adc.w #$008C		; $80D751: 69 8C 00
	sta.b $53		; $80D754: 85 53
	ldy.b $3B		; $80D756: A4 3B
	lda.w $0F3F,y		; $80D758: B9 3F 0F
	clc		; $80D75B: 18
	adc.w #$008C		; $80D75C: 69 8C 00
	sta.b $57		; $80D75F: 85 57
	sta.b $7D		; $80D761: 85 7D
	lda.b $F2		; $80D763: A5 F2
	sta.b $83		; $80D765: 85 83
	jsl.l $8D871C		; $80D767: 22 1C 87 8D
	lsr a		; $80D76B: 4A
	lsr a		; $80D76C: 4A
	lsr a		; $80D76D: 4A
	lsr a		; $80D76E: 4A
	sta.b $71		; $80D76F: 85 71
	lda.b $57		; $80D771: A5 57
	clc		; $80D773: 18
	adc.b $53		; $80D774: 65 53
	sta.b $57		; $80D776: 85 57
	lda.b $53		; $80D778: A5 53
	sec		; $80D77A: 38
	sbc.b $71		; $80D77B: E5 71
	sta.b $83		; $80D77D: 85 83
	lda.b $63		; $80D77F: A5 63
	sta.b $7D		; $80D781: 85 7D
	jsl.l $82FCDB		; $80D783: 22 DB FC 82
	lda.b $57		; $80D787: A5 57
	sta.b $7D		; $80D789: 85 7D
	jsl.l $80996C		; $80D78B: 22 6C 99 80
	sta.b $53		; $80D78F: 85 53
	lda.b $F2		; $80D791: A5 F2
	sta.b $83		; $80D793: 85 83
	lda.b $63		; $80D795: A5 63
	sta.b $7D		; $80D797: 85 7D
	jsl.l $808496		; $80D799: 22 96 84 80
	lsr a		; $80D79D: 4A
	lsr a		; $80D79E: 4A
	lsr a		; $80D79F: 4A
	lsr a		; $80D7A0: 4A
	bit.w #$0800		; $80D7A1: 89 00 08
	beq CODE_80D7A9		; $80D7A4: F0 03
	ora.w #$F000		; $80D7A6: 09 00 F0
CODE_80D7A9:		; M=16 X=16
	clc		; $80D7A9: 18
	adc.b $53		; $80D7AA: 65 53
	sta.b $57		; $80D7AC: 85 57
	lda.b $67		; $80D7AE: A5 67
	sta.b $7D		; $80D7B0: 85 7D
	lda.b $5F		; $80D7B2: A5 5F
	sta.b $83		; $80D7B4: 85 83
	jsl.l $82FCDB		; $80D7B6: 22 DB FC 82
	sta.b $73		; $80D7BA: 85 73
	lda.b $95		; $80D7BC: A5 95
	sta.b $75		; $80D7BE: 85 75
	lda.b $53		; $80D7C0: A5 53
	sta.b $7D		; $80D7C2: 85 7D
	lda.b $5B		; $80D7C4: A5 5B
	sta.b $83		; $80D7C6: 85 83
	jsl.l $82FCDB		; $80D7C8: 22 DB FC 82
	adc.b $73		; $80D7CC: 65 73
	sta.b $73		; $80D7CE: 85 73
	lda.b $75		; $80D7D0: A5 75
	adc.b $95		; $80D7D2: 65 95
	lsr a		; $80D7D4: 4A
	ror.b $73		; $80D7D5: 66 73
	lsr a		; $80D7D7: 4A
	ror.b $73		; $80D7D8: 66 73
	lsr a		; $80D7DA: 4A
	ror.b $73		; $80D7DB: 66 73
	lsr a		; $80D7DD: 4A
	ror.b $73		; $80D7DE: 66 73
	lda.w $0ADF,y		; $80D7E0: B9 DF 0A
	clc		; $80D7E3: 18
	adc.b $73		; $80D7E4: 65 73
	sta.w $0ADF,x		; $80D7E6: 9D DF 0A
	lda.b $67		; $80D7E9: A5 67
	sta.b $7D		; $80D7EB: 85 7D
	lda.b $5B		; $80D7ED: A5 5B
	sta.b $83		; $80D7EF: 85 83
	jsl.l $82FCDB		; $80D7F1: 22 DB FC 82
	sta.b $73		; $80D7F5: 85 73
	lda.b $95		; $80D7F7: A5 95
	sta.b $75		; $80D7F9: 85 75
	lda.b $53		; $80D7FB: A5 53
	sta.b $7D		; $80D7FD: 85 7D
	lda.b $5F		; $80D7FF: A5 5F
	sta.b $83		; $80D801: 85 83
	jsl.l $82FCDB		; $80D803: 22 DB FC 82
	sec		; $80D807: 38
	sbc.b $73		; $80D808: E5 73
	sta.b $73		; $80D80A: 85 73
	lda.b $95		; $80D80C: A5 95
	sbc.b $75		; $80D80E: E5 75
	lsr a		; $80D810: 4A
	ror.b $73		; $80D811: 66 73
	lsr a		; $80D813: 4A
	ror.b $73		; $80D814: 66 73
	lsr a		; $80D816: 4A
	ror.b $73		; $80D817: 66 73
	lsr a		; $80D819: 4A
	ror.b $73		; $80D81A: 66 73
	lda.w $0AFF,y		; $80D81C: B9 FF 0A
	clc		; $80D81F: 18
	adc.b $73		; $80D820: 65 73
	sta.w $0AFF,x		; $80D822: 9D FF 0A
	lda.b $57		; $80D825: A5 57
	sta.b $7D		; $80D827: 85 7D
	lda.b $5B		; $80D829: A5 5B
	sta.b $83		; $80D82B: 85 83
	jsl.l $82FCDB		; $80D82D: 22 DB FC 82
	lsr.b $95		; $80D831: 46 95
	ror a		; $80D833: 6A
	lsr.b $95		; $80D834: 46 95
	ror a		; $80D836: 6A
	lsr.b $95		; $80D837: 46 95
	ror a		; $80D839: 6A
	lsr.b $95		; $80D83A: 46 95
	ror a		; $80D83C: 6A
	clc		; $80D83D: 18
	adc.w $0ADF,y		; $80D83E: 79 DF 0A
	sta.w $0ADF,y		; $80D841: 99 DF 0A
	lda.b $57		; $80D844: A5 57
	sta.b $7D		; $80D846: 85 7D
	lda.b $5F		; $80D848: A5 5F
	sta.b $83		; $80D84A: 85 83
	jsl.l $82FCDB		; $80D84C: 22 DB FC 82
	lsr.b $95		; $80D850: 46 95
	ror a		; $80D852: 6A
	lsr.b $95		; $80D853: 46 95
	ror a		; $80D855: 6A
	lsr.b $95		; $80D856: 46 95
	ror a		; $80D858: 6A
	lsr.b $95		; $80D859: 46 95
	ror a		; $80D85B: 6A
	clc		; $80D85C: 18
	adc.w $0AFF,y		; $80D85D: 79 FF 0A
	sta.w $0AFF,y		; $80D860: 99 FF 0A
	lda.w #$FFFF		; $80D863: A9 FF FF
	sta.b $D8		; $80D866: 85 D8
CODE_80D868:		; M=16 X=16
	stx.b $0A		; $80D868: 86 0A
	ldx.w #$0016		; $80D86A: A2 16 00
CODE_80D86D:		; M=16 X=16
	pla		; $80D86D: 68
	sta.b $53,x		; $80D86E: 95 53
	dex		; $80D870: CA
	dex		; $80D871: CA
	bpl CODE_80D86D		; $80D872: 10 F9
	ldx.b $0A		; $80D874: A6 0A
	rtl		; $80D876: 6B
CODE_80D877:		; M=16 X=16
	pla		; $80D877: 68
	pla		; $80D878: 68
	bra CODE_80D868		; $80D879: 80 ED
CODE_80D87B:		; M=16 X=16
	lda.w $04A2		; $80D87B: AD A2 04
	and.w #$0001		; $80D87E: 29 01 00
	clc		; $80D881: 18
	adc.w #$0090		; $80D882: 69 90 00
	pha		; $80D885: 48
	jsl.l $80C28B		; $80D886: 22 8B C2 80
	rtl		; $80D88A: 6B
CODE_80D88B:		; M=16 X=16
	lda.b $55		; $80D88B: A5 55
	pha		; $80D88D: 48
	lda.b $53		; $80D88E: A5 53
	pha		; $80D890: 48
	jsl.l $80D8B0		; $80D891: 22 B0 D8 80
	ldx.b $3B		; $80D895: A6 3B
	ldy.b $3F		; $80D897: A4 3F
	stx.b $3F		; $80D899: 86 3F
	sty.b $3B		; $80D89B: 84 3B
	jsl.l $80D8B0		; $80D89D: 22 B0 D8 80
	ldx.b $3B		; $80D8A1: A6 3B
	ldy.b $3F		; $80D8A3: A4 3F
	stx.b $3F		; $80D8A5: 86 3F
	sty.b $3B		; $80D8A7: 84 3B
	pla		; $80D8A9: 68
	sta.b $53		; $80D8AA: 85 53
	pla		; $80D8AC: 68
	sta.b $55		; $80D8AD: 85 55
CODE_80D8AF:		; M=16 X=16
	rtl		; $80D8AF: 6B
CODE_80D8B0:		; M=16 X=16
	ldy.b $3B		; $80D8B0: A4 3B
	lda.w $0B9F,y		; $80D8B2: B9 9F 0B
	bne CODE_80D8AF		; $80D8B5: D0 F8
	lda.w $128A		; $80D8B7: AD 8A 12
	bne CODE_80D8AF		; $80D8BA: D0 F3
	lda.w $0EBB		; $80D8BC: AD BB 0E
	asl a		; $80D8BF: 0A
	cmp.b $3F		; $80D8C0: C5 3F
	beq CODE_80D8D5		; $80D8C2: F0 11
	lda.w $0B7F,x		; $80D8C4: BD 7F 0B
	sec		; $80D8C7: 38
	sbc.w #$001A		; $80D8C8: E9 1A 00
	beq CODE_80D8AF		; $80D8CB: F0 E2
	bmi CODE_80D8D3		; $80D8CD: 30 04
	bvc CODE_80D8D5		; $80D8CF: 50 04
	bra CODE_80D8AF		; $80D8D1: 80 DC
CODE_80D8D3:		; M=16 X=16
	bvc CODE_80D8AF		; $80D8D3: 50 DA
CODE_80D8D5:		; M=16 X=16
	lda.w $0B7F,x		; $80D8D5: BD 7F 0B
	sec		; $80D8D8: 38
	sbc.w #$0003		; $80D8D9: E9 03 00
	beq CODE_80D8AF		; $80D8DC: F0 D1
	bmi CODE_80D8E4		; $80D8DE: 30 04
	bvc CODE_80D8E6		; $80D8E0: 50 04
	bra CODE_80D8AF		; $80D8E2: 80 CB
CODE_80D8E4:		; M=16 X=16
	bvc CODE_80D8AF		; $80D8E4: 50 C9
CODE_80D8E6:		; M=16 X=16
	ldx.b $3B		; $80D8E6: A6 3B
	ldy.b $3F		; $80D8E8: A4 3F
	stx.b $3F		; $80D8EA: 86 3F
	sty.b $3B		; $80D8EC: 84 3B
	jsl.l $80D933		; $80D8EE: 22 33 D9 80
	ldx.b $3B		; $80D8F2: A6 3B
	ldy.b $3F		; $80D8F4: A4 3F
	stx.b $3F		; $80D8F6: 86 3F
	sty.b $3B		; $80D8F8: 84 3B
	lda.w $0B7F,y		; $80D8FA: B9 7F 0B
	sec		; $80D8FD: 38
	sbc.w #$001F		; $80D8FE: E9 1F 00
	beq CODE_80D8AF		; $80D901: F0 AC
	bmi CODE_80D909		; $80D903: 30 04
	bvc CODE_80D90B		; $80D905: 50 04
	bra CODE_80D8AF		; $80D907: 80 A6
CODE_80D909:		; M=16 X=16
	bvc CODE_80D8AF		; $80D909: 50 A4
CODE_80D90B:		; M=16 X=16
	lda.w $0EDF,x		; $80D90B: BD DF 0E
	bit.w #$4000		; $80D90E: 89 00 40
	bne CODE_80D8AF		; $80D911: D0 9C
	lda.w #$0014		; $80D913: A9 14 00
	sec		; $80D916: 38
	sbc.w $10BF,x		; $80D917: FD BF 10
	jsl.l $80AE8B		; $80D91A: 22 8B AE 80
	cmp.w #$0003		; $80D91E: C9 03 00
	bcs CODE_80D8AF		; $80D921: B0 8C
	lda.w $1288		; $80D923: AD 88 12
	bit.w #$0010		; $80D926: 89 10 00
	bne CODE_80D8AF		; $80D929: D0 84
	lda.w #$0022		; $80D92B: A9 22 00
	sta.b $53		; $80D92E: 85 53
	jmp.w $C18F		; $80D930: 4C 8F C1
CODE_80D933:		; M=16 X=16
	ldy.b $3B		; $80D933: A4 3B
	cpy.w #$0018		; $80D935: C0 18 00
	bcc CODE_80D93D		; $80D938: 90 03
	jmp.w $DB11		; $80D93A: 4C 11 DB
CODE_80D93D:		; M=16 X=16
	lda.w $115F,y		; $80D93D: B9 5F 11
	beq CODE_80D945		; $80D940: F0 03
	jmp.w $DB11		; $80D942: 4C 11 DB
CODE_80D945:		; M=16 X=16
	lda.w $0DFF,y		; $80D945: B9 FF 0D
	cmp.w #$1502		; $80D948: C9 02 15
	bne CODE_80D950		; $80D94B: D0 03
	jmp.w $DB11		; $80D94D: 4C 11 DB
CODE_80D950:		; M=16 X=16
	cmp.w #$12A2		; $80D950: C9 A2 12
	bne CODE_80D958		; $80D953: D0 03
	jmp.w $DB11		; $80D955: 4C 11 DB
CODE_80D958:		; M=16 X=16
	cmp.w #$0C92		; $80D958: C9 92 0C
	bne CODE_80D960		; $80D95B: D0 03
	jmp.w $DB11		; $80D95D: 4C 11 DB
CODE_80D960:		; M=16 X=16
	cmp.w #$0D44		; $80D960: C9 44 0D
	bne CODE_80D968		; $80D963: D0 03
	jmp.w $DB11		; $80D965: 4C 11 DB
CODE_80D968:		; M=16 X=16
	cmp.w #$11B0		; $80D968: C9 B0 11
	bne CODE_80D970		; $80D96B: D0 03
	jmp.w $DB11		; $80D96D: 4C 11 DB
CODE_80D970:		; M=16 X=16
	lda.w #$12A2		; $80D970: A9 A2 12
	sta.b $57		; $80D973: 85 57
	lda.w $107F,y		; $80D975: B9 7F 10
	cmp.w #$000C		; $80D978: C9 0C 00
	bcc CODE_80D9A4		; $80D97B: 90 27
	lda.w $0E7F,y		; $80D97D: B9 7F 0E
	bne CODE_80D9A4		; $80D980: D0 22
	lda.w $04A1		; $80D982: AD A1 04
	and.w #$000F		; $80D985: 29 0F 00
	ora.w #$0010		; $80D988: 09 10 00
	sta.b $53		; $80D98B: 85 53
	sec		; $80D98D: 38
	sbc.w $0B7F,y		; $80D98E: F9 7F 0B
	beq CODE_80D9A4		; $80D991: F0 11
	bmi CODE_80D999		; $80D993: 30 04
	bvc CODE_80D99B		; $80D995: 50 04
	bra CODE_80D9A4		; $80D997: 80 0B
CODE_80D999:		; M=16 X=16
	bvc CODE_80D9A4		; $80D999: 50 09
CODE_80D99B:		; M=16 X=16
	lda.w #$003C		; $80D99B: A9 3C 00
	sta.w $0E7F,y		; $80D99E: 99 7F 0E
	jmp.w $DA42		; $80D9A1: 4C 42 DA
CODE_80D9A4:		; M=16 X=16
	lda.w $0B9F,x		; $80D9A4: BD 9F 0B
	beq CODE_80D9E8		; $80D9A7: F0 3F
	stz.b $33		; $80D9A9: 64 33
	lda.w $119F,x		; $80D9AB: BD 9F 11
	beq CODE_80D9B5		; $80D9AE: F0 05
	lda.w #$0002		; $80D9B0: A9 02 00
	sta.b $33		; $80D9B3: 85 33
CODE_80D9B5:		; M=16 X=16
	ldy.b $33		; $80D9B5: A4 33
	lda.w $1402,y		; $80D9B7: B9 02 14
	inc a		; $80D9BA: 1A
	sta.w $1402,y		; $80D9BB: 99 02 14
	inc.w $12F8		; $80D9BE: EE F8 12
	lda.w $0F1F,x		; $80D9C1: BD 1F 0F
	sta.b $53		; $80D9C4: 85 53
	lda.w $119F,x		; $80D9C6: BD 9F 11
	beq CODE_80D9CE		; $80D9C9: F0 03
	lda.w #$001A		; $80D9CB: A9 1A 00
CODE_80D9CE:		; M=16 X=16
	clc		; $80D9CE: 18
	adc.b $53		; $80D9CF: 65 53
	tay		; $80D9D1: A8
	sep #$20		; $80D9D2: E2 20
	lda.w $1446,y		; $80D9D4: B9 46 14
	inc a		; $80D9D7: 1A
	sta.w $1446,y		; $80D9D8: 99 46 14
	rep #$20		; $80D9DB: C2 20
	lda.w $10DF,x		; $80D9DD: BD DF 10
	bne CODE_80D9E8		; $80D9E0: D0 06
	inc.w $12F8		; $80D9E2: EE F8 12
	inc.w $12F8		; $80D9E5: EE F8 12
CODE_80D9E8:		; M=16 X=16
	ldy.b $3B		; $80D9E8: A4 3B
	lda.w #$0078		; $80D9EA: A9 78 00
	sta.w $0E5F,y		; $80D9ED: 99 5F 0E
	lda.w $08FF,x		; $80D9F0: BD FF 08
	sec		; $80D9F3: 38
	sbc.w $08FF,y		; $80D9F4: F9 FF 08
	sta.b $53		; $80D9F7: 85 53
	lda.w $095F,x		; $80D9F9: BD 5F 09
	sec		; $80D9FC: 38
	sbc.w $095F,y		; $80D9FD: F9 5F 09
	sta.b $57		; $80DA00: 85 57
	jsl.l $80AFA8		; $80DA02: 22 A8 AF 80
	lda.w #$0D44		; $80DA06: A9 44 0D
	sta.b $57		; $80DA09: 85 57
	ldy.b $3B		; $80DA0B: A4 3B
	lda.b $53		; $80DA0D: A5 53
	sec		; $80DA0F: 38
	sbc.w $0DBF,y		; $80DA10: F9 BF 0D
	inc a		; $80DA13: 1A
	and.w #$0007		; $80DA14: 29 07 00
	cmp.w #$0003		; $80DA17: C9 03 00
	bcc CODE_80DA42		; $80DA1A: 90 26
	lda.w #$0C92		; $80DA1C: A9 92 0C
	sta.b $57		; $80DA1F: 85 57
	lda.w $0DBF,y		; $80DA21: B9 BF 0D
	and.w #$0003		; $80DA24: 29 03 00
	bne CODE_80DA42		; $80DA27: D0 19
	lda.w $10FF,x		; $80DA29: BD FF 10
	sec		; $80DA2C: 38
	sbc.w #$000A		; $80DA2D: E9 0A 00
	bmi CODE_80DA36		; $80DA30: 30 04
	bvc CODE_80DA38		; $80DA32: 50 04
	bra CODE_80DA42		; $80DA34: 80 0C
CODE_80DA36:		; M=16 X=16
	bvc CODE_80DA42		; $80DA36: 50 0A
CODE_80DA38:		; M=16 X=16
	cpx.w #$0018		; $80DA38: E0 18 00
	bcs CODE_80DA42		; $80DA3B: B0 05
	lda.w #$11B0		; $80DA3D: A9 B0 11
	sta.b $57		; $80DA40: 85 57
CODE_80DA42:		; M=16 X=16
	ldx.b $3B		; $80DA42: A6 3B
	ldy.b $3F		; $80DA44: A4 3F
	stx.b $3F		; $80DA46: 86 3F
	sty.b $3B		; $80DA48: 84 3B
	lda.w #$0001		; $80DA4A: A9 01 00
	sta.w $117F,x		; $80DA4D: 9D 7F 11
	jsl.l $80B006		; $80DA50: 22 06 B0 80
	ldx.b $3B		; $80DA54: A6 3B
	ldy.b $3F		; $80DA56: A4 3F
	stx.b $3F		; $80DA58: 86 3F
	sty.b $3B		; $80DA5A: 84 3B
	lda.b $DE		; $80DA5C: A5 DE
	clc		; $80DA5E: 18
	adc.w #$012C		; $80DA5F: 69 2C 01
	sta.b $DE		; $80DA62: 85 DE
	lda.w $0EBB		; $80DA64: AD BB 0E
	sta.b $53		; $80DA67: 85 53
	bpl CODE_80DA6E		; $80DA69: 10 03
	jmp.w $D87B		; $80DA6B: 4C 7B D8
CODE_80DA6E:		; M=16 X=16
	tya		; $80DA6E: 98
	lsr a		; $80DA6F: 4A
	cmp.b $53		; $80DA70: C5 53
	beq CODE_80DA77		; $80DA72: F0 03
	jmp.w $D87B		; $80DA74: 4C 7B D8
CODE_80DA77:		; M=16 X=16
	lda.w #$FFFF		; $80DA77: A9 FF FF
	sta.w $0EBB		; $80DA7A: 8D BB 0E
	lda.w $1288		; $80DA7D: AD 88 12
	bit.w #$0010		; $80DA80: 89 10 00
	bne CODE_80DAFD		; $80DA83: D0 78
	lda.w $0DFF,y		; $80DA85: B9 FF 0D
	cmp.w #$0D44		; $80DA88: C9 44 0D
	bne CODE_80DAFD		; $80DA8B: D0 70
	lda.w $0DBF,y		; $80DA8D: B9 BF 0D
	and.w #$0003		; $80DA90: 29 03 00
	bne CODE_80DAFD		; $80DA93: D0 68
	lda.w $0EDF,y		; $80DA95: B9 DF 0E
	bit.w #$4000		; $80DA98: 89 00 40
	bne CODE_80DAFD		; $80DA9B: D0 60
	lda.w #$00A0		; $80DA9D: A9 A0 00
	jsl.l $80AE8B		; $80DAA0: 22 8B AE 80
	ldy.b $3B		; $80DAA4: A4 3B
	sec		; $80DAA6: 38
	sbc.w $0B7F,y		; $80DAA7: F9 7F 0B
	beq CODE_80DAB4		; $80DAAA: F0 08
	bmi CODE_80DAB2		; $80DAAC: 30 04
	bvs CODE_80DAB4		; $80DAAE: 70 04
	bra CODE_80DAFD		; $80DAB0: 80 4B
CODE_80DAB2:		; M=16 X=16
	bvs CODE_80DAFD		; $80DAB2: 70 49
CODE_80DAB4:		; M=16 X=16
	lda.w $128A		; $80DAB4: AD 8A 12
	bne CODE_80DAFD		; $80DAB7: D0 44
	ldx.b $3B		; $80DAB9: A6 3B
	ldy.b $3F		; $80DABB: A4 3F
	stx.b $3F		; $80DABD: 86 3F
	sty.b $3B		; $80DABF: 84 3B
	lda.w #$1502		; $80DAC1: A9 02 15
	sta.b $57		; $80DAC4: 85 57
	jsl.l $80B006		; $80DAC6: 22 06 B0 80
	ldx.b $3B		; $80DACA: A6 3B
	ldy.b $3F		; $80DACC: A4 3F
	stx.b $3F		; $80DACE: 86 3F
	sty.b $3B		; $80DAD0: 84 3B
	jsl.l $8FF74A		; $80DAD2: 22 4A F7 8F
	lda.w #$0004		; $80DAD6: A9 04 00
	sta.w $12E6		; $80DAD9: 8D E6 12
	lda.w #$0014		; $80DADC: A9 14 00
	sta.b $53		; $80DADF: 85 53
	lda.w $0B9F,x		; $80DAE1: BD 9F 0B
	bne CODE_80DAE9		; $80DAE4: D0 03
	jmp.w $C1B0		; $80DAE6: 4C B0 C1
CODE_80DAE9:		; M=16 X=16
	lda.w $160A		; $80DAE9: AD 0A 16
	bne CODE_80DAF1		; $80DAEC: D0 03
	jmp.w $C1B0		; $80DAEE: 4C B0 C1
CODE_80DAF1:		; M=16 X=16
	lda.w #$0012		; $80DAF1: A9 12 00
	sta.b $53		; $80DAF4: 85 53
	jsl.l $80C1B0		; $80DAF6: 22 B0 C1 80
	jmp.w $E7F7		; $80DAFA: 4C F7 E7
CODE_80DAFD:		; M=16 X=16
	ldy.b $3B		; $80DAFD: A4 3B
	lda.w #$008A		; $80DAFF: A9 8A 00
	pha		; $80DB02: 48
	lda.w $119F,y		; $80DB03: B9 9F 11
	bne CODE_80DB0D		; $80DB06: D0 05
	lda.w #$008B		; $80DB08: A9 8B 00
	sta.b $01,s		; $80DB0B: 83 01
CODE_80DB0D:		; M=16 X=16
	jsl.l $80C28B		; $80DB0D: 22 8B C2 80
CODE_80DB11:		; M=16 X=16
	rtl		; $80DB11: 6B
CODE_80DB12:		; M=16 X=16
	stx.b $0A		; $80DB12: 86 0A
	ldx.w #$0000		; $80DB14: A2 00 00
CODE_80DB17:		; M=16 X=16
	lda.b $53,x		; $80DB17: B5 53
	pha		; $80DB19: 48
	inx		; $80DB1A: E8
	inx		; $80DB1B: E8
	cpx.w #$0014		; $80DB1C: E0 14 00
	bne CODE_80DB17		; $80DB1F: D0 F6
	ldx.b $0A		; $80DB21: A6 0A
	stx.b $0A		; $80DB23: 86 0A
	ldx.w #$0000		; $80DB25: A2 00 00
CODE_80DB28:		; M=16 X=16
	lda.b $33,x		; $80DB28: B5 33
	pha		; $80DB2A: 48
	inx		; $80DB2B: E8
	inx		; $80DB2C: E8
	cpx.w #$0010		; $80DB2D: E0 10 00
	bne CODE_80DB28		; $80DB30: D0 F6
	ldx.b $0A		; $80DB32: A6 0A
	jsl.l $80DB63		; $80DB34: 22 63 DB 80
	ldx.b $3B		; $80DB38: A6 3B
	ldy.b $3F		; $80DB3A: A4 3F
	stx.b $3F		; $80DB3C: 86 3F
	sty.b $3B		; $80DB3E: 84 3B
	jsl.l $80DB63		; $80DB40: 22 63 DB 80
	stx.b $0A		; $80DB44: 86 0A
	ldx.w #$000E		; $80DB46: A2 0E 00
CODE_80DB49:		; M=16 X=16
	pla		; $80DB49: 68
	sta.b $33,x		; $80DB4A: 95 33
	dex		; $80DB4C: CA
	dex		; $80DB4D: CA
	bpl CODE_80DB49		; $80DB4E: 10 F9
	ldx.b $0A		; $80DB50: A6 0A
	stx.b $0A		; $80DB52: 86 0A
	ldx.w #$0012		; $80DB54: A2 12 00
CODE_80DB57:		; M=16 X=16
	pla		; $80DB57: 68
	sta.b $53,x		; $80DB58: 95 53
	dex		; $80DB5A: CA
	dex		; $80DB5B: CA
	bpl CODE_80DB57		; $80DB5C: 10 F9
	ldx.b $0A		; $80DB5E: A6 0A
	ldx.b $3F		; $80DB60: A6 3F
CODE_80DB62:		; M=16 X=16
	rtl		; $80DB62: 6B
CODE_80DB63:		; M=16 X=16
	ldy.b $3B		; $80DB63: A4 3B
	lda.w $0DFF,y		; $80DB65: B9 FF 0D
	cmp.w #$0BFC		; $80DB68: C9 FC 0B
	bne CODE_80DB71		; $80DB6B: D0 04
	jml.l $8FD5BF		; $80DB6D: 5C BF D5 8F
CODE_80DB71:		; M=16 X=16
	cmp.w #$1354		; $80DB71: C9 54 13
	bne CODE_80DB7A		; $80DB74: D0 04
	jml.l $8FD5BF		; $80DB76: 5C BF D5 8F
CODE_80DB7A:		; M=16 X=16
	cmp.w #$0A90		; $80DB7A: C9 90 0A
	bne CODE_80DB83		; $80DB7D: D0 04
	jml.l $8D8389		; $80DB7F: 5C 89 83 8D
CODE_80DB83:		; M=16 X=16
	lda.w $0DFF,x		; $80DB83: BD FF 0D
	cmp.w #$0BCA		; $80DB86: C9 CA 0B
	bne CODE_80DB62		; $80DB89: D0 D7
	lda.w $128A		; $80DB8B: AD 8A 12
	beq CODE_80DB99		; $80DB8E: F0 09
	lda.w #$0100		; $80DB90: A9 00 01
	sta.w $0B7F,x		; $80DB93: 9D 7F 0B
	sta.w $0B7F,y		; $80DB96: 99 7F 0B
CODE_80DB99:		; M=16 X=16
	lda.w $08FF,y		; $80DB99: B9 FF 08
	sec		; $80DB9C: 38
	sbc.w $08FF,x		; $80DB9D: FD FF 08
	sta.b $53		; $80DBA0: 85 53
	lda.w $095F,y		; $80DBA2: B9 5F 09
	sec		; $80DBA5: 38
	sbc.w $095F,x		; $80DBA6: FD 5F 09
	sta.b $57		; $80DBA9: 85 57
	jsl.l $80AFA8		; $80DBAB: 22 A8 AF 80
	lda.b $53		; $80DBAF: A5 53
	sec		; $80DBB1: 38
	sbc.w $0DBF,x		; $80DBB2: FD BF 0D
	and.w #$0007		; $80DBB5: 29 07 00
	sta.b $53		; $80DBB8: 85 53
	lda.w $09DF,x		; $80DBBA: BD DF 09
	bit.w #$0800		; $80DBBD: 89 00 08
	beq CODE_80DBCD		; $80DBC0: F0 0B
	lda.b $53		; $80DBC2: A5 53
	eor.w #$FFFF		; $80DBC4: 49 FF FF
	inc a		; $80DBC7: 1A
	and.w #$0007		; $80DBC8: 29 07 00
	sta.b $53		; $80DBCB: 85 53
CODE_80DBCD:		; M=16 X=16
	asl.b $53		; $80DBCD: 06 53
	lda.w #$DC85		; $80DBCF: A9 85 DC
	sta.b $33		; $80DBD2: 85 33
	sta.w $117F,x		; $80DBD4: 9D 7F 11
	lda.w #$0080		; $80DBD7: A9 80 00
	sta.b $35		; $80DBDA: 85 35
	ldy.b $53		; $80DBDC: A4 53
	lda.b [$33],y		; $80DBDE: B7 33
	sta.b $57		; $80DBE0: 85 57
	jsl.l $80B006		; $80DBE2: 22 06 B0 80
	ldy.b $3B		; $80DBE6: A4 3B
	lda.w $0B9F,y		; $80DBE8: B9 9F 0B
	bne CODE_80DBF0		; $80DBEB: D0 03
	jmp.w $DB62		; $80DBED: 4C 62 DB
CODE_80DBF0:		; M=16 X=16
	lda.b $63		; $80DBF0: A5 63
	sec		; $80DBF2: 38
	sbc.w #$0014		; $80DBF3: E9 14 00
	bmi CODE_80DBFD		; $80DBF6: 30 05
	bvc CODE_80DBFF		; $80DBF8: 50 05
CODE_80DBFA:		; M=16 X=16
	jmp.w $DB62		; $80DBFA: 4C 62 DB
CODE_80DBFD:		; M=16 X=16
	bvc CODE_80DBFA		; $80DBFD: 50 FB
CODE_80DBFF:		; M=16 X=16
	lda.w #$0078		; $80DBFF: A9 78 00
	sta.b $53		; $80DC02: 85 53
	lda.w $0EDF,x		; $80DC04: BD DF 0E
	bit.w #$0008		; $80DC07: 89 08 00
	beq CODE_80DC0E		; $80DC0A: F0 02
	asl.b $53		; $80DC0C: 06 53
CODE_80DC0E:		; M=16 X=16
	lda.b $53		; $80DC0E: A5 53
	sec		; $80DC10: 38
	sbc.w $0F3F,x		; $80DC11: FD 3F 0F
	clc		; $80DC14: 18
	adc.w $0F3F,y		; $80DC15: 79 3F 0F
	lsr a		; $80DC18: 4A
	sec		; $80DC19: 38
	sbc.w $0B7F,y		; $80DC1A: F9 7F 0B
	sta.b $53		; $80DC1D: 85 53
	beq CODE_80DC5F		; $80DC1F: F0 3E
	bmi CODE_80DC5F		; $80DC21: 30 3C
	jsl.l $8097A3		; $80DC23: 22 A3 97 80
	lda.b $53		; $80DC27: A5 53
	sec		; $80DC29: 38
	sbc.w $10FF,x		; $80DC2A: FD FF 10
	beq CODE_80DC5F		; $80DC2D: F0 30
	bmi CODE_80DC35		; $80DC2F: 30 04
	bvc CODE_80DC37		; $80DC31: 50 04
	bra CODE_80DC5F		; $80DC33: 80 2A
CODE_80DC35:		; M=16 X=16
	bvc CODE_80DC5F		; $80DC35: 50 28
CODE_80DC37:		; M=16 X=16
	jsl.l $8FE369		; $80DC37: 22 69 E3 8F
	lda.b $53		; $80DC3B: A5 53
	cmp.w #$0005		; $80DC3D: C9 05 00
	bcc CODE_80DC45		; $80DC40: 90 03
	jmp.w $DB62		; $80DC42: 4C 62 DB
CODE_80DC45:		; M=16 X=16
	lda.w $1288		; $80DC45: AD 88 12
	bit.w #$0010		; $80DC48: 89 10 00
	beq CODE_80DC50		; $80DC4B: F0 03
	jmp.w $DB62		; $80DC4D: 4C 62 DB
CODE_80DC50:		; M=16 X=16
	lda.w $04A2		; $80DC50: AD A2 04
	and.w #$0002		; $80DC53: 29 02 00
	clc		; $80DC56: 18
	adc.w #$0016		; $80DC57: 69 16 00
	sta.b $53		; $80DC5A: 85 53
	jmp.w $C18F		; $80DC5C: 4C 8F C1
CODE_80DC5F:		; M=16 X=16
	jsl.l $8FE369		; $80DC5F: 22 69 E3 8F
	lda.b $53		; $80DC63: A5 53
	cmp.w #$0004		; $80DC65: C9 04 00
	bcs CODE_80DC82		; $80DC68: B0 18
	lda.w $1288		; $80DC6A: AD 88 12
	bit.w #$0010		; $80DC6D: 89 10 00
	bne CODE_80DC82		; $80DC70: D0 10
	lda.w $04A4		; $80DC72: AD A4 04
	and.w #$0002		; $80DC75: 29 02 00
	clc		; $80DC78: 18
	adc.w #$001A		; $80DC79: 69 1A 00
	sta.b $53		; $80DC7C: 85 53
	jsl.l $80C18F		; $80DC7E: 22 8F C1 80
CODE_80DC82:		; M=16 X=16
	jmp.w $D933		; $80DC82: 4C 33 D9
	db $02,$0B,$34,$0B,$98,$0B,$98,$0B,$98,$0B,$66,$0B,$66,$0B,$02,$0B	; $80DC85
CODE_80DC95:		; M=16 X=16
	ldy.b $3B		; $80DC95: A4 3B
	lda.w $0B7F,x		; $80DC97: BD 7F 0B
	sec		; $80DC9A: 38
	sbc.w #$000A		; $80DC9B: E9 0A 00
	bmi CODE_80DCA5		; $80DC9E: 30 05
	bvc CODE_80DCA7		; $80DCA0: 50 05
CODE_80DCA2:		; M=16 X=16
	jmp.w $DE27		; $80DCA2: 4C 27 DE
CODE_80DCA5:		; M=16 X=16
	bvc CODE_80DCA2		; $80DCA5: 50 FB
CODE_80DCA7:		; M=16 X=16
	lda.w $0B7F,y		; $80DCA7: B9 7F 0B
	sec		; $80DCAA: 38
	sbc.w #$000A		; $80DCAB: E9 0A 00
	bmi CODE_80DCB5		; $80DCAE: 30 05
	bvc CODE_80DCB7		; $80DCB0: 50 05
CODE_80DCB2:		; M=16 X=16
	jmp.w $DE27		; $80DCB2: 4C 27 DE
CODE_80DCB5:		; M=16 X=16
	bvc CODE_80DCB2		; $80DCB5: 50 FB
CODE_80DCB7:		; M=16 X=16
	lda.w $117F,y		; $80DCB7: B9 7F 11
	ora.w $117F,x		; $80DCBA: 1D 7F 11
	beq CODE_80DCC2		; $80DCBD: F0 03
	jmp.w $DE27		; $80DCBF: 4C 27 DE
CODE_80DCC2:		; M=16 X=16
	lda.w $0EDF,x		; $80DCC2: BD DF 0E
	ora.w $0EDF,y		; $80DCC5: 19 DF 0E
	bit.w #$4000		; $80DCC8: 89 00 40
	beq CODE_80DCD0		; $80DCCB: F0 03
	jmp.w $DE27		; $80DCCD: 4C 27 DE
CODE_80DCD0:		; M=16 X=16
	lda.w $0B9F,x		; $80DCD0: BD 9F 0B
	bne CODE_80DCD8		; $80DCD3: D0 03
	jmp.w $DE27		; $80DCD5: 4C 27 DE
CODE_80DCD8:		; M=16 X=16
	lda.w $0B9F,y		; $80DCD8: B9 9F 0B
	bne CODE_80DCE0		; $80DCDB: D0 03
	jmp.w $DE27		; $80DCDD: 4C 27 DE
CODE_80DCE0:		; M=16 X=16
	lda.w $1288		; $80DCE0: AD 88 12
	and.w #$0010		; $80DCE3: 29 10 00
	ora.w $128A		; $80DCE6: 0D 8A 12
	ora.w $117B		; $80DCE9: 0D 7B 11
	beq CODE_80DCF1		; $80DCEC: F0 03
	jmp.w $DE27		; $80DCEE: 4C 27 DE
CODE_80DCF1:		; M=16 X=16
	stx.b $0A		; $80DCF1: 86 0A
	ldx.w #$0000		; $80DCF3: A2 00 00
CODE_80DCF6:		; M=16 X=16
	lda.b $53,x		; $80DCF6: B5 53
	pha		; $80DCF8: 48
	inx		; $80DCF9: E8
	inx		; $80DCFA: E8
	cpx.w #$0014		; $80DCFB: E0 14 00
	bne CODE_80DCF6		; $80DCFE: D0 F6
	ldx.b $0A		; $80DD00: A6 0A
	stx.b $0A		; $80DD02: 86 0A
	ldx.w #$0000		; $80DD04: A2 00 00
CODE_80DD07:		; M=16 X=16
	lda.b $33,x		; $80DD07: B5 33
	pha		; $80DD09: 48
	inx		; $80DD0A: E8
	inx		; $80DD0B: E8
	cpx.w #$0010		; $80DD0C: E0 10 00
	bne CODE_80DD07		; $80DD0F: D0 F6
	ldx.b $0A		; $80DD11: A6 0A
	ldy.w $0BDB		; $80DD13: AC DB 0B
	lda.w $0C4F,y		; $80DD16: B9 4F 0C
	and.w #$00FF		; $80DD19: 29 FF 00
	cmp.w #$001B		; $80DD1C: C9 1B 00
	bne CODE_80DD24		; $80DD1F: D0 03
	jmp.w $DE09		; $80DD21: 4C 09 DE
CODE_80DD24:		; M=16 X=16
	lda.w #$0028		; $80DD24: A9 28 00
	sec		; $80DD27: 38
	sbc.w $12F8		; $80DD28: ED F8 12
	bpl CODE_80DD30		; $80DD2B: 10 03
	lda.w #$0000		; $80DD2D: A9 00 00
CODE_80DD30:		; M=16 X=16
	lsr a		; $80DD30: 4A
	lsr a		; $80DD31: 4A
	clc		; $80DD32: 18
	adc.w #$000A		; $80DD33: 69 0A 00
	sta.b $53		; $80DD36: 85 53
	jsl.l $80DE89		; $80DD38: 22 89 DE 80
	ldx.b $3B		; $80DD3C: A6 3B
	ldy.b $3F		; $80DD3E: A4 3F
	stx.b $3F		; $80DD40: 86 3F
	sty.b $3B		; $80DD42: 84 3B
	jsl.l $80DE89		; $80DD44: 22 89 DE 80
	ldx.b $3B		; $80DD48: A6 3B
	ldy.b $3F		; $80DD4A: A4 3F
	stx.b $3F		; $80DD4C: 86 3F
	sty.b $3B		; $80DD4E: 84 3B
	lda.w $115F,x		; $80DD50: BD 5F 11
	bne CODE_80DD58		; $80DD53: D0 03
	jmp.w $DE09		; $80DD55: 4C 09 DE
CODE_80DD58:		; M=16 X=16
	stz.w $12F8		; $80DD58: 9C F8 12
	lda.w #$0000		; $80DD5B: A9 00 00
	ldy.w #$0032		; $80DD5E: A0 32 00
CODE_80DD61:		; M=16 X=16
	sta.w $1446,y		; $80DD61: 99 46 14
	dey		; $80DD64: 88
	dey		; $80DD65: 88
	bpl CODE_80DD61		; $80DD66: 10 F9
	lda.b $DE		; $80DD68: A5 DE
	clc		; $80DD6A: 18
	adc.w #$03E8		; $80DD6B: 69 E8 03
	sta.b $DE		; $80DD6E: 85 DE
	lda.w #$000C		; $80DD70: A9 0C 00
	trb.w $128C		; $80DD73: 1C 8C 12
	ldy.b $3B		; $80DD76: A4 3B
	txa		; $80DD78: 8A
	lsr a		; $80DD79: 4A
	sta.w $0EBB		; $80DD7A: 8D BB 0E
	lda.w $095F,x		; $80DD7D: BD 5F 09
	clc		; $80DD80: 18
	adc.w $095F,y		; $80DD81: 79 5F 09
	pha		; $80DD84: 48
	asl a		; $80DD85: 0A
	pla		; $80DD86: 68
	ror a		; $80DD87: 6A
	sta.w $08F7		; $80DD88: 8D F7 08
	lda.w #$0040		; $80DD8B: A9 40 00
	tsb.w $128C		; $80DD8E: 0C 8C 12
	lda.w #$0002		; $80DD91: A9 02 00
	sta.b $57		; $80DD94: 85 57
	lda.w $08FF,x		; $80DD96: BD FF 08
	sta.b $53		; $80DD99: 85 53
	sec		; $80DD9B: 38
	sbc.w $08FF,y		; $80DD9C: F9 FF 08
	bmi CODE_80DDA5		; $80DD9F: 30 04
	bvc CODE_80DDA7		; $80DDA1: 50 04
	bra CODE_80DDAE		; $80DDA3: 80 09
CODE_80DDA5:		; M=16 X=16
	bvc CODE_80DDAE		; $80DDA5: 50 07
CODE_80DDA7:		; M=16 X=16
	lda.b $57		; $80DDA7: A5 57
	eor.w #$0007		; $80DDA9: 49 07 00
	sta.b $57		; $80DDAC: 85 57
CODE_80DDAE:		; M=16 X=16
	lda.b $57		; $80DDAE: A5 57
	sta.w $0DBF,x		; $80DDB0: 9D BF 0D
	eor.w #$0007		; $80DDB3: 49 07 00
	sta.b $57		; $80DDB6: 85 57
	sta.w $0DBF,y		; $80DDB8: 99 BF 0D
	jsl.l $80DE28		; $80DDBB: 22 28 DE 80
	ldx.b $3B		; $80DDBF: A6 3B
	ldy.b $3F		; $80DDC1: A4 3F
	stx.b $3F		; $80DDC3: 86 3F
	sty.b $3B		; $80DDC5: 84 3B
	jsl.l $80DE28		; $80DDC7: 22 28 DE 80
	ldx.w #$0000		; $80DDCB: A2 00 00
	lda.w #$0015		; $80DDCE: A9 15 00
	sta.b $53		; $80DDD1: 85 53
	lda.w #$000B		; $80DDD3: A9 0B 00
	sta.b $57		; $80DDD6: 85 57
CODE_80DDD8:		; M=16 X=16
	lda.w $0EDF,x		; $80DDD8: BD DF 0E
	and.w #$1000		; $80DDDB: 29 00 10
	ora.w $115F,x		; $80DDDE: 1D 5F 11
	bne CODE_80DDEC		; $80DDE1: D0 09
	lda.w $0B9F,x		; $80DDE3: BD 9F 0B
	beq CODE_80DDEC		; $80DDE6: F0 04
	jsl.l $80B49D		; $80DDE8: 22 9D B4 80
CODE_80DDEC:		; M=16 X=16
	inx		; $80DDEC: E8
	inx		; $80DDED: E8
	dec.b $57		; $80DDEE: C6 57
	bpl CODE_80DDD8		; $80DDF0: 10 E6
	ldx.w #$001C		; $80DDF2: A2 1C 00
	lda.w #$0001		; $80DDF5: A9 01 00
	sta.w $117B		; $80DDF8: 8D 7B 11
	lda.w #$001A		; $80DDFB: A9 1A 00
	sta.b $53		; $80DDFE: 85 53
	jsl.l $80B49D		; $80DE00: 22 9D B4 80
	lda.w #$FFFF		; $80DE04: A9 FF FF
	sta.b $D8		; $80DE07: 85 D8
CODE_80DE09:		; M=16 X=16
	stx.b $0A		; $80DE09: 86 0A
	ldx.w #$000E		; $80DE0B: A2 0E 00
CODE_80DE0E:		; M=16 X=16
	pla		; $80DE0E: 68
	sta.b $33,x		; $80DE0F: 95 33
	dex		; $80DE11: CA
	dex		; $80DE12: CA
	bpl CODE_80DE0E		; $80DE13: 10 F9
	ldx.b $0A		; $80DE15: A6 0A
	stx.b $0A		; $80DE17: 86 0A
	ldx.w #$0012		; $80DE19: A2 12 00
CODE_80DE1C:		; M=16 X=16
	pla		; $80DE1C: 68
	sta.b $53,x		; $80DE1D: 95 53
	dex		; $80DE1F: CA
	dex		; $80DE20: CA
	bpl CODE_80DE1C		; $80DE21: 10 F9
	ldx.b $0A		; $80DE23: A6 0A
	ldx.b $3F		; $80DE25: A6 3F
CODE_80DE27:		; M=16 X=16
	rtl		; $80DE27: 6B
CODE_80DE28:		; M=16 X=16
	ldy.b $3B		; $80DE28: A4 3B
	tya		; $80DE2A: 98
	lsr a		; $80DE2B: 4A
	sta.w $0B3F,x		; $80DE2C: 9D 3F 0B
	lda.w #$0026		; $80DE2F: A9 26 00
	sta.b $53		; $80DE32: 85 53
	jsl.l $80C1B0		; $80DE34: 22 B0 C1 80
	txa		; $80DE38: 8A
	lsr a		; $80DE39: 4A
	sta.b $53		; $80DE3A: 85 53
	jsl.l $8D87FB		; $80DE3C: 22 FB 87 8D
	lda.w #$0014		; $80DE40: A9 14 00
	sta.b $53		; $80DE43: 85 53
	jsl.l $80B49D		; $80DE45: 22 9D B4 80
	lda.w $09DF,x		; $80DE49: BD DF 09
	and.w #$F7FF		; $80DE4C: 29 FF F7
	sta.w $09DF,x		; $80DE4F: 9D DF 09
	lda.w #$FC00		; $80DE52: A9 00 FC
	sta.b $57		; $80DE55: 85 57
	lda.w $0DBF,x		; $80DE57: BD BF 0D
	cmp.w #$0002		; $80DE5A: C9 02 00
	beq CODE_80DE6D		; $80DE5D: F0 0E
	lda.w $09DF,x		; $80DE5F: BD DF 09
	ora.w #$0800		; $80DE62: 09 00 08
	sta.w $09DF,x		; $80DE65: 9D DF 09
	lda.w #$0400		; $80DE68: A9 00 04
	sta.b $57		; $80DE6B: 85 57
CODE_80DE6D:		; M=16 X=16
	lda.b $57		; $80DE6D: A5 57
	sta.w $0ADF,x		; $80DE6F: 9D DF 0A
	lda.w $0EDF,x		; $80DE72: BD DF 0E
	ora.w #$9000		; $80DE75: 09 00 90
	sta.w $0EDF,x		; $80DE78: 9D DF 0E
	stz.w $117F,x		; $80DE7B: 9E 7F 11
	lda.w #$0EDA		; $80DE7E: A9 DA 0E
	sta.b $57		; $80DE81: 85 57
	sta.w $11DF,x		; $80DE83: 9D DF 11
	jmp.w $B006		; $80DE86: 4C 06 B0
CODE_80DE89:		; M=16 X=16
	lda.w $10DF,x		; $80DE89: BD DF 10
	cmp.b $53		; $80DE8C: C5 53
	bcc CODE_80DE27		; $80DE8E: 90 97
	ldy.b $3B		; $80DE90: A4 3B
	lda.w $10DF,y		; $80DE92: B9 DF 10
	sta.b $73		; $80DE95: 85 73
	sec		; $80DE97: 38
	sbc.w #$0002		; $80DE98: E9 02 00
	bmi CODE_80DEA2		; $80DE9B: 30 05
	bvc CODE_80DEA4		; $80DE9D: 50 05
CODE_80DE9F:		; M=16 X=16
	jmp.w $DE27		; $80DE9F: 4C 27 DE
CODE_80DEA2:		; M=16 X=16
	bvc CODE_80DE9F		; $80DEA2: 50 FB
CODE_80DEA4:		; M=16 X=16
	lda.w $0F1F,y		; $80DEA4: B9 1F 0F
	sta.b $57		; $80DEA7: 85 57
	lda.w $119F,y		; $80DEA9: B9 9F 11
	beq CODE_80DEB1		; $80DEAC: F0 03
	lda.w #$001A		; $80DEAE: A9 1A 00
CODE_80DEB1:		; M=16 X=16
	clc		; $80DEB1: 18
	adc.w $0F1F,y		; $80DEB2: 79 1F 0F
	tay		; $80DEB5: A8
	lda.w $1446,y		; $80DEB6: B9 46 14
	and.w #$00FF		; $80DEB9: 29 FF 00
	bit.w #$0080		; $80DEBC: 89 80 00
	beq CODE_80DEC4		; $80DEBF: F0 03
	ora.w #$FF00		; $80DEC1: 09 00 FF
CODE_80DEC4:		; M=16 X=16
	asl a		; $80DEC4: 0A
	eor.w #$FFFF		; $80DEC5: 49 FF FF
	inc a		; $80DEC8: 1A
	clc		; $80DEC9: 18
	adc.w #$0010		; $80DECA: 69 10 00
	sta.b $57		; $80DECD: 85 57
	ldy.b $3B		; $80DECF: A4 3B
	sec		; $80DED1: 38
	sbc.b $73		; $80DED2: E5 73
	beq CODE_80DEDF		; $80DED4: F0 09
	bmi CODE_80DEDD		; $80DED6: 30 05
	bvs CODE_80DEDF		; $80DED8: 70 05
CODE_80DEDA:		; M=16 X=16
	jmp.w $DE27		; $80DEDA: 4C 27 DE
CODE_80DEDD:		; M=16 X=16
	bvs CODE_80DEDA		; $80DEDD: 70 FB
CODE_80DEDF:		; M=16 X=16
	lda.w #$0001		; $80DEDF: A9 01 00
	sta.w $115F,x		; $80DEE2: 9D 5F 11
	sta.w $115F,y		; $80DEE5: 99 5F 11
	jmp.w $DEEB		; $80DEE8: 4C EB DE
CODE_80DEEB:		; M=16 X=16
	jsl.l $82FA1A		; $80DEEB: 22 1A FA 82
	lda.w $0DFF,x		; $80DEEF: BD FF 0D
	cmp.w #$0B02		; $80DEF2: C9 02 0B
	beq CODE_80DEFC		; $80DEF5: F0 05
	cmp.w #$0B34		; $80DEF7: C9 34 0B
	bne CODE_80DF31		; $80DEFA: D0 35
CODE_80DEFC:		; M=16 X=16
	stx.b $43		; $80DEFC: 86 43
	lda.w #$0005		; $80DEFE: A9 05 00
	sta.b $53		; $80DF01: 85 53
	stz.b $3F		; $80DF03: 64 3F
	lda.w $119F,x		; $80DF05: BD 9F 11
	beq CODE_80DF0F		; $80DF08: F0 05
	lda.w #$000C		; $80DF0A: A9 0C 00
	sta.b $3F		; $80DF0D: 85 3F
CODE_80DF0F:		; M=16 X=16
	ldx.b $3F		; $80DF0F: A6 3F
	cpx.b $43		; $80DF11: E4 43
	beq CODE_80DF32		; $80DF13: F0 1D
	lda.w $0B9F,x		; $80DF15: BD 9F 0B
	bmi CODE_80DF32		; $80DF18: 30 18
	beq CODE_80DF32		; $80DF1A: F0 16
	lda.w $0EDF,x		; $80DF1C: BD DF 0E
	bit.w #$5000		; $80DF1F: 89 00 50
	bne CODE_80DF32		; $80DF22: D0 0E
	lda.w #$002A		; $80DF24: A9 2A 00
	sta.b $53		; $80DF27: 85 53
	jsl.l $80C1B0		; $80DF29: 22 B0 C1 80
	ldx.b $43		; $80DF2D: A6 43
	stx.b $3F		; $80DF2F: 86 3F
CODE_80DF31:		; M=16 X=16
	rtl		; $80DF31: 6B
CODE_80DF32:		; M=16 X=16
	inc.b $3F		; $80DF32: E6 3F
	inc.b $3F		; $80DF34: E6 3F
	dec.b $53		; $80DF36: C6 53
	bpl CODE_80DF0F		; $80DF38: 10 D5
	ldx.b $43		; $80DF3A: A6 43
	stx.b $3F		; $80DF3C: 86 3F
	rtl		; $80DF3E: 6B
CODE_80DF3F:		; M=16 X=16
	jsl.l $80E0E1		; $80DF3F: 22 E1 E0 80
	lda.b $57		; $80DF43: A5 57
	bit.w #$1000		; $80DF45: 89 00 10
	beq CODE_80DF56		; $80DF48: F0 0C
	lda.b $63		; $80DF4A: A5 63
	bne CODE_80DF52		; $80DF4C: D0 04
	jml.l $8F8E03		; $80DF4E: 5C 03 8E 8F
CODE_80DF52:		; M=16 X=16
	jml.l $82FDB5		; $80DF52: 5C B5 FD 82
CODE_80DF56:		; M=16 X=16
	lda.w $128E		; $80DF56: AD 8E 12
	beq CODE_80DF69		; $80DF59: F0 0E
	lda.b $53		; $80DF5B: A5 53
	bit.w #$0008		; $80DF5D: 89 08 00
	bne CODE_80DF69		; $80DF60: D0 07
	inc a		; $80DF62: 1A
	inc a		; $80DF63: 1A
	and.w #$0007		; $80DF64: 29 07 00
	sta.b $53		; $80DF67: 85 53
CODE_80DF69:		; M=16 X=16
	lda.w $128C		; $80DF69: AD 8C 12
	bit.w #$0100		; $80DF6C: 89 00 01
	beq CODE_80DF74		; $80DF6F: F0 03
	jmp.w $E073		; $80DF71: 4C 73 E0
CODE_80DF74:		; M=16 X=16
	lda.w $0EDF,x		; $80DF74: BD DF 0E
	bit.w #$2000		; $80DF77: 89 00 20
	beq CODE_80DF80		; $80DF7A: F0 04
	jml.l $8AFD0C		; $80DF7C: 5C 0C FD 8A
CODE_80DF80:		; M=16 X=16
	bit.w #$0008		; $80DF80: 89 08 00
	bne CODE_80DF88		; $80DF83: D0 03
	jmp.w $E036		; $80DF85: 4C 36 E0
CODE_80DF88:		; M=16 X=16
	lda.w $117F,x		; $80DF88: BD 7F 11
	beq CODE_80DF90		; $80DF8B: F0 03
	jmp.w $E025		; $80DF8D: 4C 25 E0
CODE_80DF90:		; M=16 X=16
	lda.w $115F,x		; $80DF90: BD 5F 11
	beq CODE_80DF99		; $80DF93: F0 04
	jml.l $8FD4F9		; $80DF95: 5C F9 D4 8F
CODE_80DF99:		; M=16 X=16
	lda.w $0EBB		; $80DF99: AD BB 0E
	sta.b $67		; $80DF9C: 85 67
	txa		; $80DF9E: 8A
	lsr a		; $80DF9F: 4A
	cmp.b $67		; $80DFA0: C5 67
	beq CODE_80DFC9		; $80DFA2: F0 25
	lda.b $57		; $80DFA4: A5 57
	bit.w #$4000		; $80DFA6: 89 00 40
	beq CODE_80DFAE		; $80DFA9: F0 03
	jmp.w $E0C5		; $80DFAB: 4C C5 E0
CODE_80DFAE:		; M=16 X=16
	bit.w #$8000		; $80DFAE: 89 00 80
	beq CODE_80DFB6		; $80DFB1: F0 03
	jmp.w $AE9D		; $80DFB3: 4C 9D AE
CODE_80DFB6:		; M=16 X=16
	lda.w $0B9F,x		; $80DFB6: BD 9F 0B
	beq CODE_80E036		; $80DFB9: F0 7B
	lda.b $57		; $80DFBB: A5 57
	bit.w #$0080		; $80DFBD: 89 80 00
	beq CODE_80DFC5		; $80DFC0: F0 03
	jmp.w $8BAD		; $80DFC2: 4C AD 8B
CODE_80DFC5:		; M=16 X=16
	jml.l $8FFBDC		; $80DFC5: 5C DC FB 8F
CODE_80DFC9:		; M=16 X=16
	jsl.l $808598		; $80DFC9: 22 98 85 80
	lda.w $0B9F,x		; $80DFCD: BD 9F 0B
	bne CODE_80DFD7		; $80DFD0: D0 05
	lda.w $11DF,x		; $80DFD2: BD DF 11
	bne CODE_80E036		; $80DFD5: D0 5F
CODE_80DFD7:		; M=16 X=16
	lda.w $128C		; $80DFD7: AD 8C 12
	bit.w #$0004		; $80DFDA: 89 04 00
	beq CODE_80DFE3		; $80DFDD: F0 04
	jml.l $8FE43C		; $80DFDF: 5C 3C E4 8F
CODE_80DFE3:		; M=16 X=16
	bit.w #$0008		; $80DFE3: 89 08 00
	beq CODE_80DFEB		; $80DFE6: F0 03
	jmp.w $8E33		; $80DFE8: 4C 33 8E
CODE_80DFEB:		; M=16 X=16
	lda.b $57		; $80DFEB: A5 57
	bit.w #$8000		; $80DFED: 89 00 80
	bne CODE_80E037		; $80DFF0: D0 45
	lda.w $128C		; $80DFF2: AD 8C 12
	bit.w #$0100		; $80DFF5: 89 00 01
	bne CODE_80E001		; $80DFF8: D0 07
	lda.b $57		; $80DFFA: A5 57
	bit.w #$4000		; $80DFFC: 89 00 40
	bne CODE_80E014		; $80DFFF: D0 13
