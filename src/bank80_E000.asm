; $80E001-$80EFFF  ROM $06001  (from src/bank80.asm; quick pass, TODO segment agents refine)
org $80E001
CODE_80E001:		; M=16 X=16
	lda.w $0B9F,x		; $80E001: BD 9F 0B
	beq CODE_80E036		; $80E004: F0 30
	lda.b $57		; $80E006: A5 57
	bit.w #$0080		; $80E008: 89 80 00
	beq CODE_80E010		; $80E00B: F0 03
	jmp.w $8DE9		; $80E00D: 4C E9 8D
CODE_80E010:		; M=16 X=16
	jml.l $8FFBDC		; $80E010: 5C DC FB 8F
CODE_80E014:		; M=16 X=16
	lda.w $0183		; $80E014: AD 83 01
	cmp.w #$FFFF		; $80E017: C9 FF FF
	bne CODE_80E022		; $80E01A: D0 06
	lda.w #$FFFE		; $80E01C: A9 FE FF
	sta.w $0183		; $80E01F: 8D 83 01
CODE_80E022:		; M=16 X=16
	jmp.w $A70F		; $80E022: 4C 0F A7
CODE_80E025:		; M=16 X=16
	txa		; $80E025: 8A
	lsr a		; $80E026: 4A
	cmp.w $0EBB		; $80E027: CD BB 0E
	beq CODE_80E036		; $80E02A: F0 0A
	lda.b $57		; $80E02C: A5 57
	bit.w #$8000		; $80E02E: 89 00 80
	beq CODE_80E036		; $80E031: F0 03
	jmp.w $AE9D		; $80E033: 4C 9D AE
CODE_80E036:		; M=16 X=16
	rtl		; $80E036: 6B
CODE_80E037:		; M=16 X=16
	lda.w $0B9F,x		; $80E037: BD 9F 0B
	bne CODE_80E063		; $80E03A: D0 27
	lda.w $091B		; $80E03C: AD 1B 09
	bit.w #$8000		; $80E03F: 89 00 80
	beq CODE_80E048		; $80E042: F0 04
	eor.w #$FFFF		; $80E044: 49 FF FF
	inc a		; $80E047: 1A
CODE_80E048:		; M=16 X=16
	cmp.w #$0010		; $80E048: C9 10 00
	bcs CODE_80E063		; $80E04B: B0 16
	lda.w $097B		; $80E04D: AD 7B 09
	bit.w #$8000		; $80E050: 89 00 80
	beq CODE_80E059		; $80E053: F0 04
	eor.w #$FFFF		; $80E055: 49 FF FF
	inc a		; $80E058: 1A
CODE_80E059:		; M=16 X=16
	cmp.w #$0108		; $80E059: C9 08 01
	bcc CODE_80E063		; $80E05C: 90 05
	cmp.w #$0110		; $80E05E: C9 10 01
	bcc CODE_80E072		; $80E061: 90 0F
CODE_80E063:		; M=16 X=16
	lda.w $0DBF,x		; $80E063: BD BF 0D
	and.w #$0007		; $80E066: 29 07 00
	sta.w $043B		; $80E069: 8D 3B 04
	lda.w #$0004		; $80E06C: A9 04 00
	tsb.w $128C		; $80E06F: 0C 8C 12
CODE_80E072:		; M=16 X=16
	rtl		; $80E072: 6B
CODE_80E073:		; M=16 X=16
	txa		; $80E073: 8A
	asl a		; $80E074: 0A
	asl a		; $80E075: 0A
	adc.w $0BBF,x		; $80E076: 7D BF 0B
	tay		; $80E079: A8
	lda.w $0BDF,y		; $80E07A: B9 DF 0B
	and.w #$00FF		; $80E07D: 29 FF 00
	cmp.w #$0017		; $80E080: C9 17 00
	bne CODE_80E0C4		; $80E083: D0 3F
	lda.w #$0132		; $80E085: A9 32 01
	sta.b $33		; $80E088: 85 33
	lda.w #$0000		; $80E08A: A9 00 00
	sta.b $35		; $80E08D: 85 35
	lda.w $113F,x		; $80E08F: BD 3F 11
	beq CODE_80E09E		; $80E092: F0 0A
	lda.w #$0134		; $80E094: A9 34 01
	sta.b $33		; $80E097: 85 33
	lda.w #$0000		; $80E099: A9 00 00
	sta.b $35		; $80E09C: 85 35
CODE_80E09E:		; M=16 X=16
	lda.b $53		; $80E09E: A5 53
	sta.b [$33]		; $80E0A0: 87 33
	lda.w $11DF,x		; $80E0A2: BD DF 11
	bne CODE_80E0C4		; $80E0A5: D0 1D
	lda.b $57		; $80E0A7: A5 57
	bit.w #$8000		; $80E0A9: 89 00 80
	beq CODE_80E0BC		; $80E0AC: F0 0E
	lda.w #$1096		; $80E0AE: A9 96 10
	sta.b $57		; $80E0B1: 85 57
	lda.w #$0001		; $80E0B3: A9 01 00
	sta.w $11DF,x		; $80E0B6: 9D DF 11
	jmp.w $B006		; $80E0B9: 4C 06 B0
CODE_80E0BC:		; M=16 X=16
	lda.w #$10C0		; $80E0BC: A9 C0 10
	sta.b $57		; $80E0BF: 85 57
	jmp.w $B006		; $80E0C1: 4C 06 B0
CODE_80E0C4:		; M=16 X=16
	rtl		; $80E0C4: 6B
CODE_80E0C5:		; M=16 X=16
	lda.w #$1354		; $80E0C5: A9 54 13
	sta.b $57		; $80E0C8: 85 57
	sta.w $117F,x		; $80E0CA: 9D 7F 11
	lda.w $0B7F,x		; $80E0CD: BD 7F 0B
	bne CODE_80E0D5		; $80E0D0: D0 03
	jmp.w $B006		; $80E0D2: 4C 06 B0
CODE_80E0D5:		; M=16 X=16
	lda.w $0B3F,x		; $80E0D5: BD 3F 0B
	asl a		; $80E0D8: 0A
	sta.b $53		; $80E0D9: 85 53
	sta.b $33		; $80E0DB: 85 33
	jml.l $8FFB5B		; $80E0DD: 5C 5B FB 8F
CODE_80E0E1:		; M=16 X=16
	stx.b $0A		; $80E0E1: 86 0A
	ldx.w #$0000		; $80E0E3: A2 00 00
CODE_80E0E6:		; M=16 X=16
	lda.b $53,x		; $80E0E6: B5 53
	pha		; $80E0E8: 48
	inx		; $80E0E9: E8
	inx		; $80E0EA: E8
	cpx.w #$0008		; $80E0EB: E0 08 00
	bne CODE_80E0E6		; $80E0EE: D0 F6
	ldx.b $0A		; $80E0F0: A6 0A
	lda.w #$0002		; $80E0F2: A9 02 00
	clc		; $80E0F5: 18
	adc.b $63		; $80E0F6: 65 63
	asl a		; $80E0F8: 0A
	sta.b $53		; $80E0F9: 85 53
	sta.b $73		; $80E0FB: 85 73
	lda.w #$FFF0		; $80E0FD: A9 F0 FF
	sta.b $57		; $80E100: 85 57
CODE_80E102:		; M=16 X=16
	lda.b $73		; $80E102: A5 73
	beq CODE_80E110		; $80E104: F0 0A
	dec.b $73		; $80E106: C6 73
	asl.b $57		; $80E108: 06 57
	bcc CODE_80E10E		; $80E10A: 90 02
	inc.b $57		; $80E10C: E6 57
CODE_80E10E:		; M=16 X=16
	bra CODE_80E102		; $80E10E: 80 F2
CODE_80E110:		; M=16 X=16
	lda.w $0431		; $80E110: AD 31 04
	and.b $57		; $80E113: 25 57
	sta.w $0431		; $80E115: 8D 31 04
	lda.w $0D9F,x		; $80E118: BD 9F 0D
	sta.b $57		; $80E11B: 85 57
CODE_80E11D:		; M=16 X=16
	lda.b $53		; $80E11D: A5 53
	beq CODE_80E127		; $80E11F: F0 06
	dec.b $53		; $80E121: C6 53
	asl.b $57		; $80E123: 06 57
	bra CODE_80E11D		; $80E125: 80 F6
CODE_80E127:		; M=16 X=16
	lda.w $0431		; $80E127: AD 31 04
	ora.b $57		; $80E12A: 05 57
	sta.w $0431		; $80E12C: 8D 31 04
	stx.b $0A		; $80E12F: 86 0A
	ldx.w #$0006		; $80E131: A2 06 00
CODE_80E134:		; M=16 X=16
	pla		; $80E134: 68
	sta.b $53,x		; $80E135: 95 53
	dex		; $80E137: CA
	dex		; $80E138: CA
	bpl CODE_80E134		; $80E139: 10 F9
	ldx.b $0A		; $80E13B: A6 0A
	rtl		; $80E13D: 6B
CODE_80E13E:		; M=16 X=16
	lda.w $0DFF,x		; $80E13E: BD FF 0D
	bne CODE_80E14A		; $80E141: D0 07
	stz.w $11DF,x		; $80E143: 9E DF 11
	stz.w $117F,x		; $80E146: 9E 7F 11
	rtl		; $80E149: 6B
CODE_80E14A:		; M=16 X=16
	clc		; $80E14A: 18
	adc.w #$B86C		; $80E14B: 69 6C B8
	sta.b $33		; $80E14E: 85 33
	lda.w #$0082		; $80E150: A9 82 00
	sta.b $35		; $80E153: 85 35
	ldy.w #$0010		; $80E155: A0 10 00
	lda.b [$33],y		; $80E158: B7 33
	sta.b $57		; $80E15A: 85 57
	lda.w $0DBF,x		; $80E15C: BD BF 0D
	sta.b $53		; $80E15F: 85 53
	lda.w $128E		; $80E161: AD 8E 12
	beq CODE_80E174		; $80E164: F0 0E
	cpx.w #$0018		; $80E166: E0 18 00
	bcs CODE_80E174		; $80E169: B0 09
	lda.b $53		; $80E16B: A5 53
	dec a		; $80E16D: 3A
	dec a		; $80E16E: 3A
	and.w #$0007		; $80E16F: 29 07 00
	sta.b $53		; $80E172: 85 53
CODE_80E174:		; M=16 X=16
	lda.w $09DF,x		; $80E174: BD DF 09
	bit.w #$0800		; $80E177: 89 00 08
	beq CODE_80E187		; $80E17A: F0 0B
	lda.b $53		; $80E17C: A5 53
	eor.w #$FFFF		; $80E17E: 49 FF FF
	inc a		; $80E181: 1A
	and.w #$0007		; $80E182: 29 07 00
	sta.b $53		; $80E185: 85 53
CODE_80E187:		; M=16 X=16
	lda.b $53		; $80E187: A5 53
	asl a		; $80E189: 0A
	tay		; $80E18A: A8
	lda.b [$33],y		; $80E18B: B7 33
	adc.b $33		; $80E18D: 65 33
	sta.b $33		; $80E18F: 85 33
	ldy.w $0E1F,x		; $80E191: BC 1F 0E
	sty.b $53		; $80E194: 84 53
	lda.b [$33],y		; $80E196: B7 33
	sta.b $5B		; $80E198: 85 5B
	lda.w $0E3F,x		; $80E19A: BD 3F 0E
	bmi CODE_80E1D0		; $80E19D: 30 31
	sec		; $80E19F: 38
	sbc.b $6F		; $80E1A0: E5 6F
	sta.w $0E3F,x		; $80E1A2: 9D 3F 0E
	bpl CODE_80E1E2		; $80E1A5: 10 3B
	lda.w $0E1F,x		; $80E1A7: BD 1F 0E
	clc		; $80E1AA: 18
	adc.w #$0004		; $80E1AB: 69 04 00
	sta.w $0E1F,x		; $80E1AE: 9D 1F 0E
	iny		; $80E1B1: C8
	iny		; $80E1B2: C8
	iny		; $80E1B3: C8
	iny		; $80E1B4: C8
	sty.b $53		; $80E1B5: 84 53
	dey		; $80E1B7: 88
	dey		; $80E1B8: 88
	lda.b [$33],y		; $80E1B9: B7 33
	bpl CODE_80E1D0		; $80E1BB: 10 13
	stz.b $53		; $80E1BD: 64 53
	stz.w $0E1F,x		; $80E1BF: 9E 1F 0E
	stz.w $11DF,x		; $80E1C2: 9E DF 11
	stz.w $117F,x		; $80E1C5: 9E 7F 11
	lda.b $57		; $80E1C8: A5 57
	lsr a		; $80E1CA: 4A
	bcs CODE_80E1D0		; $80E1CB: B0 03
	stz.w $0DFF,x		; $80E1CD: 9E FF 0D
CODE_80E1D0:		; M=16 X=16
	ldy.b $53		; $80E1D0: A4 53
	iny		; $80E1D2: C8
	iny		; $80E1D3: C8
	lda.b [$33],y		; $80E1D4: B7 33
	bit.w #$8000		; $80E1D6: 89 00 80
	beq CODE_80E1DF		; $80E1D9: F0 04
	eor.w #$FFFF		; $80E1DB: 49 FF FF
	inc a		; $80E1DE: 1A
CODE_80E1DF:		; M=16 X=16
	sta.w $0E3F,x		; $80E1DF: 9D 3F 0E
CODE_80E1E2:		; M=16 X=16
	lda.b $5B		; $80E1E2: A5 5B
	sta.w $093F,x		; $80E1E4: 9D 3F 09
	rtl		; $80E1E7: 6B
CODE_80E1E8:		; M=16 X=16
	lda.w $08F7		; $80E1E8: AD F7 08
	sta.b $5B		; $80E1EB: 85 5B
	lda.w $08F5		; $80E1ED: AD F5 08
	sta.b $5F		; $80E1F0: 85 5F
	lda.w $128C		; $80E1F2: AD 8C 12
	bit.w #$0040		; $80E1F5: 89 40 00
	bne CODE_80E269		; $80E1F8: D0 6F
	ldx.w #$001C		; $80E1FA: A2 1C 00
	lda.w $0EBB		; $80E1FD: AD BB 0E
	bmi CODE_80E242		; $80E200: 30 40
	asl a		; $80E202: 0A
	tax		; $80E203: AA
	lda.w $113F,x		; $80E204: BD 3F 11
	beq CODE_80E225		; $80E207: F0 1C
	lda.w $08F9		; $80E209: AD F9 08
	adc.b $E2		; $80E20C: 65 E2
	sta.w $08F9		; $80E20E: 8D F9 08
	sec		; $80E211: 38
	sbc.w #$0032		; $80E212: E9 32 00
	bmi CODE_80E21B		; $80E215: 30 04
	bvc CODE_80E21D		; $80E217: 50 04
	bra CODE_80E242		; $80E219: 80 27
CODE_80E21B:		; M=16 X=16
	bvc CODE_80E242		; $80E21B: 50 25
CODE_80E21D:		; M=16 X=16
	lda.w #$0032		; $80E21D: A9 32 00
	sta.w $08F9		; $80E220: 8D F9 08
	bra CODE_80E242		; $80E223: 80 1D
CODE_80E225:		; M=16 X=16
	lda.w $08F9		; $80E225: AD F9 08
	sec		; $80E228: 38
	sbc.b $E2		; $80E229: E5 E2
	sta.w $08F9		; $80E22B: 8D F9 08
	sec		; $80E22E: 38
	sbc.w #$FFCE		; $80E22F: E9 CE FF
	beq CODE_80E23C		; $80E232: F0 08
	bmi CODE_80E23A		; $80E234: 30 04
	bvs CODE_80E23C		; $80E236: 70 04
	bra CODE_80E242		; $80E238: 80 08
CODE_80E23A:		; M=16 X=16
	bvs CODE_80E242		; $80E23A: 70 06
CODE_80E23C:		; M=16 X=16
	lda.w #$FFCE		; $80E23C: A9 CE FF
	sta.w $08F9		; $80E23F: 8D F9 08
CODE_80E242:		; M=16 X=16
	lda.w $0AFF,x		; $80E242: BD FF 0A
	lsr a		; $80E245: 4A
	lsr a		; $80E246: 4A
	lsr a		; $80E247: 4A
	lsr a		; $80E248: 4A
	lsr a		; $80E249: 4A
	lsr a		; $80E24A: 4A
	lsr a		; $80E24B: 4A
	bit.w #$0100		; $80E24C: 89 00 01
	beq CODE_80E254		; $80E24F: F0 03
	ora.w #$FE00		; $80E251: 09 00 FE
CODE_80E254:		; M=16 X=16
	clc		; $80E254: 18
	adc.w $095F,x		; $80E255: 7D 5F 09
	clc		; $80E258: 18
	adc.w $08F9		; $80E259: 6D F9 08
	sta.b $5B		; $80E25C: 85 5B
	sta.w $08F7		; $80E25E: 8D F7 08
	lda.w $08FF,x		; $80E261: BD FF 08
	sta.b $5F		; $80E264: 85 5F
	sta.w $08F5		; $80E266: 8D F5 08
CODE_80E269:		; M=16 X=16
	lda.b $5B		; $80E269: A5 5B
	sec		; $80E26B: 38
	sbc.w $08DF		; $80E26C: ED DF 08
	sta.b $53		; $80E26F: 85 53
	sec		; $80E271: 38
	sbc.w #$FFF6		; $80E272: E9 F6 FF
	bmi CODE_80E27B		; $80E275: 30 04
	bvs CODE_80E27D		; $80E277: 70 04
	bra CODE_80E29A		; $80E279: 80 1F
CODE_80E27B:		; M=16 X=16
	bvs CODE_80E29A		; $80E27B: 70 1D
CODE_80E27D:		; M=16 X=16
	lda.b $5B		; $80E27D: A5 5B
	sec		; $80E27F: 38
	sbc.w #$FFF6		; $80E280: E9 F6 FF
	sta.b $57		; $80E283: 85 57
	sec		; $80E285: 38
	sbc.w #$FF39		; $80E286: E9 39 FF
	beq CODE_80E293		; $80E289: F0 08
	bmi CODE_80E291		; $80E28B: 30 04
	bvs CODE_80E293		; $80E28D: 70 04
	bra CODE_80E2C3		; $80E28F: 80 32
CODE_80E291:		; M=16 X=16
	bvs CODE_80E2C3		; $80E291: 70 30
CODE_80E293:		; M=16 X=16
	lda.w #$FF39		; $80E293: A9 39 FF
	sta.b $57		; $80E296: 85 57
	bra CODE_80E2C3		; $80E298: 80 29
CODE_80E29A:		; M=16 X=16
	lda.b $53		; $80E29A: A5 53
	sec		; $80E29C: 38
	sbc.w #$000A		; $80E29D: E9 0A 00
	beq CODE_80E2E3		; $80E2A0: F0 41
	bmi CODE_80E2A8		; $80E2A2: 30 04
	bvc CODE_80E2AA		; $80E2A4: 50 04
	bra CODE_80E2E3		; $80E2A6: 80 3B
CODE_80E2A8:		; M=16 X=16
	bvc CODE_80E2E3		; $80E2A8: 50 39
CODE_80E2AA:		; M=16 X=16
	lda.b $5B		; $80E2AA: A5 5B
	sec		; $80E2AC: 38
	sbc.w #$000A		; $80E2AD: E9 0A 00
	sta.b $57		; $80E2B0: 85 57
	sec		; $80E2B2: 38
	sbc.w #$0100		; $80E2B3: E9 00 01
	bmi CODE_80E2BC		; $80E2B6: 30 04
	bvc CODE_80E2BE		; $80E2B8: 50 04
	bra CODE_80E2C3		; $80E2BA: 80 07
CODE_80E2BC:		; M=16 X=16
	bvc CODE_80E2C3		; $80E2BC: 50 05
CODE_80E2BE:		; M=16 X=16
	lda.w #$0100		; $80E2BE: A9 00 01
	sta.b $57		; $80E2C1: 85 57
CODE_80E2C3:		; M=16 X=16
	lda.b $57		; $80E2C3: A5 57
	sec		; $80E2C5: 38
	sbc.w $08DF		; $80E2C6: ED DF 08
	beq CODE_80E2E3		; $80E2C9: F0 18
	lsr a		; $80E2CB: 4A
	lsr a		; $80E2CC: 4A
	lsr a		; $80E2CD: 4A
	bit.w #$1000		; $80E2CE: 89 00 10
	beq CODE_80E2D6		; $80E2D1: F0 03
	ora.w #$E000		; $80E2D3: 09 00 E0
CODE_80E2D6:		; M=16 X=16
	cmp.w #$0000		; $80E2D6: C9 00 00
	bne CODE_80E2DC		; $80E2D9: D0 01
	inc a		; $80E2DB: 1A
CODE_80E2DC:		; M=16 X=16
	clc		; $80E2DC: 18
	adc.w $08DF		; $80E2DD: 6D DF 08
	sta.w $08DF		; $80E2E0: 8D DF 08
CODE_80E2E3:		; M=16 X=16
	lda.b $5F		; $80E2E3: A5 5F
	sec		; $80E2E5: 38
	sbc.w $0154		; $80E2E6: ED 54 01
	sta.b $53		; $80E2E9: 85 53
	sec		; $80E2EB: 38
	sbc.w #$FFD8		; $80E2EC: E9 D8 FF
	bmi CODE_80E2F5		; $80E2EF: 30 04
	bvs CODE_80E2F7		; $80E2F1: 70 04
	bra CODE_80E312		; $80E2F3: 80 1D
CODE_80E2F5:		; M=16 X=16
	bvs CODE_80E312		; $80E2F5: 70 1B
CODE_80E2F7:		; M=16 X=16
	lda.b $5F		; $80E2F7: A5 5F
	sec		; $80E2F9: 38
	sbc.w #$FFD8		; $80E2FA: E9 D8 FF
	sta.b $57		; $80E2FD: 85 57
	sec		; $80E2FF: 38
	sbc.w #$FFC4		; $80E300: E9 C4 FF
	bmi CODE_80E309		; $80E303: 30 04
	bvs CODE_80E30B		; $80E305: 70 04
	bra CODE_80E33D		; $80E307: 80 34
CODE_80E309:		; M=16 X=16
	bvs CODE_80E33D		; $80E309: 70 32
CODE_80E30B:		; M=16 X=16
	lda.w #$FFC4		; $80E30B: A9 C4 FF
	sta.b $57		; $80E30E: 85 57
	bra CODE_80E33D		; $80E310: 80 2B
CODE_80E312:		; M=16 X=16
	lda.b $53		; $80E312: A5 53
	sec		; $80E314: 38
	sbc.w #$0028		; $80E315: E9 28 00
	beq CODE_80E35D		; $80E318: F0 43
	bmi CODE_80E320		; $80E31A: 30 04
	bvc CODE_80E322		; $80E31C: 50 04
	bra CODE_80E35D		; $80E31E: 80 3D
CODE_80E320:		; M=16 X=16
	bvc CODE_80E35D		; $80E320: 50 3B
CODE_80E322:		; M=16 X=16
	lda.b $5F		; $80E322: A5 5F
	sec		; $80E324: 38
	sbc.w #$0028		; $80E325: E9 28 00
	sta.b $57		; $80E328: 85 57
	sec		; $80E32A: 38
	sbc.w #$003C		; $80E32B: E9 3C 00
	beq CODE_80E33D		; $80E32E: F0 0D
	bmi CODE_80E336		; $80E330: 30 04
	bvc CODE_80E338		; $80E332: 50 04
	bra CODE_80E33D		; $80E334: 80 07
CODE_80E336:		; M=16 X=16
	bvc CODE_80E33D		; $80E336: 50 05
CODE_80E338:		; M=16 X=16
	lda.w #$003C		; $80E338: A9 3C 00
	sta.b $57		; $80E33B: 85 57
CODE_80E33D:		; M=16 X=16
	lda.b $57		; $80E33D: A5 57
	sec		; $80E33F: 38
	sbc.w $0154		; $80E340: ED 54 01
	beq CODE_80E35D		; $80E343: F0 18
	lsr a		; $80E345: 4A
	lsr a		; $80E346: 4A
	lsr a		; $80E347: 4A
	bit.w #$1000		; $80E348: 89 00 10
	beq CODE_80E350		; $80E34B: F0 03
	ora.w #$E000		; $80E34D: 09 00 E0
CODE_80E350:		; M=16 X=16
	cmp.w #$0000		; $80E350: C9 00 00
	bne CODE_80E356		; $80E353: D0 01
	inc a		; $80E355: 1A
CODE_80E356:		; M=16 X=16
	clc		; $80E356: 18
	adc.w $0154		; $80E357: 6D 54 01
	sta.w $0154		; $80E35A: 8D 54 01
CODE_80E35D:		; M=16 X=16
	rtl		; $80E35D: 6B
CODE_80E35E:		; M=16 X=16
	lda.b $14		; $80E35E: A5 14
	cmp.w #$80DE		; $80E360: C9 DE 80
	beq CODE_80E372		; $80E363: F0 0D
	cmp.w #$80CE		; $80E365: C9 CE 80
	bne CODE_80E3C8		; $80E368: D0 5E
	lda.b $08		; $80E36A: A5 08
	bne CODE_80E372		; $80E36C: D0 04
	stz.b $04		; $80E36E: 64 04
	inc.b $08		; $80E370: E6 08
CODE_80E372:		; M=16 X=16
	jsl.l $8FE04C		; $80E372: 22 4C E0 8F
	stx.b $0A		; $80E376: 86 0A
	ldx.w #$0000		; $80E378: A2 00 00
CODE_80E37B:		; M=16 X=16
	lda.b $33,x		; $80E37B: B5 33
	pha		; $80E37D: 48
	inx		; $80E37E: E8
	inx		; $80E37F: E8
	cpx.w #$003C		; $80E380: E0 3C 00
	bne CODE_80E37B		; $80E383: D0 F6
	ldx.b $0A		; $80E385: A6 0A
	jsl.l $80E3C9		; $80E387: 22 C9 E3 80
	jsl.l $80E3E7		; $80E38B: 22 E7 E3 80
	jsl.l $8CFC1A		; $80E38F: 22 1A FC 8C
	jsl.l $80E439		; $80E393: 22 39 E4 80
	jsl.l $80E501		; $80E397: 22 01 E5 80
	jsl.l $8F82A4		; $80E39B: 22 A4 82 8F
	jsl.l $8F8ABC		; $80E39F: 22 BC 8A 8F
	jsl.l $8887AE		; $80E3A3: 22 AE 87 88
	jsl.l $8BFFCC		; $80E3A7: 22 CC FF 8B
	jsl.l $8F8F4A		; $80E3AB: 22 4A 8F 8F
	jsl.l $8F8EF7		; $80E3AF: 22 F7 8E 8F
	lda.w #$812F		; $80E3B3: A9 2F 81
	sta.b $14		; $80E3B6: 85 14
	stx.b $0A		; $80E3B8: 86 0A
	ldx.w #$003A		; $80E3BA: A2 3A 00
CODE_80E3BD:		; M=16 X=16
	pla		; $80E3BD: 68
	sta.b $33,x		; $80E3BE: 95 33
	dex		; $80E3C0: CA
	dex		; $80E3C1: CA
	bpl CODE_80E3BD		; $80E3C2: 10 F9
	ldx.b $0A		; $80E3C4: A6 0A
	ldx.b $3F		; $80E3C6: A6 3F
CODE_80E3C8:		; M=16 X=16
	rtl		; $80E3C8: 6B
CODE_80E3C9:		; M=16 X=16
	lda.w $128E		; $80E3C9: AD 8E 12
	bne CODE_80E3E6		; $80E3CC: D0 18
	lda.w $0154		; $80E3CE: AD 54 01
	sec		; $80E3D1: 38
	sbc.w #$0080		; $80E3D2: E9 80 00
	sta.w $0156		; $80E3D5: 8D 56 01
	lda.w $08DF		; $80E3D8: AD DF 08
	eor.w #$FFFF		; $80E3DB: 49 FF FF
	inc a		; $80E3DE: 1A
	sec		; $80E3DF: 38
	sbc.w #$0070		; $80E3E0: E9 70 00
	sta.w $08E1		; $80E3E3: 8D E1 08
CODE_80E3E6:		; M=16 X=16
	rtl		; $80E3E6: 6B
CODE_80E3E7:		; M=16 X=16
	lda.w $128C		; $80E3E7: AD 8C 12
	bit.w #$0001		; $80E3EA: 89 01 00
	bne CODE_80E438		; $80E3ED: D0 49
	lda.w $128C		; $80E3EF: AD 8C 12
	bit.w #$0100		; $80E3F2: 89 00 01
	beq CODE_80E438		; $80E3F5: F0 41
	lda.w #$0030		; $80E3F7: A9 30 00
	sta.b $BB		; $80E3FA: 85 BB
	ldx.w #$0000		; $80E3FC: A2 00 00
CODE_80E3FF:		; M=16 X=16
	lda.w $0136		; $80E3FF: AD 36 01
	sta.b $C9		; $80E402: 85 C9
	lda.w $0138		; $80E404: AD 38 01
	sta.b $CB		; $80E407: 85 CB
	lda.w $013A,x		; $80E409: BD 3A 01
	clc		; $80E40C: 18
	adc.w #$0213		; $80E40D: 69 13 02
	sta.b $C3		; $80E410: 85 C3
	lda.w $013C,x		; $80E412: BD 3C 01
	and.w #$0800		; $80E415: 29 00 08
	sta.b $A5		; $80E418: 85 A5
	cpx.w #$0004		; $80E41A: E0 04 00
	bne CODE_80E424		; $80E41D: D0 05
	lda.w #$8000		; $80E41F: A9 00 80
	sta.b $AB		; $80E422: 85 AB
CODE_80E424:		; M=16 X=16
	phx		; $80E424: DA
	jsl.l $8FEC68		; $80E425: 22 68 EC 8F
	plx		; $80E429: FA
	inx		; $80E42A: E8
	inx		; $80E42B: E8
	inx		; $80E42C: E8
	inx		; $80E42D: E8
	cpx.w #$000C		; $80E42E: E0 0C 00
	bne CODE_80E3FF		; $80E431: D0 CC
	lda.w #$0020		; $80E433: A9 20 00
	sta.b $BB		; $80E436: 85 BB
CODE_80E438:		; M=16 X=16
	rtl		; $80E438: 6B
CODE_80E439:		; M=16 X=16
	lda.w #$125F		; $80E439: A9 5F 12
	sta.b $43		; $80E43C: 85 43
CODE_80E43E:		; M=16 X=16
	lda.b ($43)		; $80E43E: B2 43
	and.w #$00FF		; $80E440: 29 FF 00
	tax		; $80E443: AA
	lda.w $099F,x		; $80E444: BD 9F 09
	bmi CODE_80E48B		; $80E447: 30 42
	sta.b $5B		; $80E449: 85 5B
	lda.w $08FF,x		; $80E44B: BD FF 08
	sta.b $53		; $80E44E: 85 53
	lda.w $095F,x		; $80E450: BD 5F 09
	sta.b $57		; $80E453: 85 57
	jsl.l $80E495		; $80E455: 22 95 E4 80
	cmp.w #$4E20		; $80E459: C9 20 4E
	beq CODE_80E48B		; $80E45C: F0 2D
	sta.b $CB		; $80E45E: 85 CB
	lda.b $53		; $80E460: A5 53
	sta.b $C9		; $80E462: 85 C9
	lda.w $093F,x		; $80E464: BD 3F 09
	sta.w $09FF,x		; $80E467: 9D FF 09
	sta.b $C3		; $80E46A: 85 C3
	lda.w $09DF,x		; $80E46C: BD DF 09
	and.w #$0800		; $80E46F: 29 00 08
	sta.b $A5		; $80E472: 85 A5
	lda.w $09DF,x		; $80E474: BD DF 09
	and.w #$1000		; $80E477: 29 00 10
	sta.b $CD		; $80E47A: 85 CD
	lda.w $09DF,x		; $80E47C: BD DF 09
	lsr a		; $80E47F: 4A
	bcc CODE_80E487		; $80E480: 90 05
	lda.w #$8000		; $80E482: A9 00 80
	sta.b $AB		; $80E485: 85 AB
CODE_80E487:		; M=16 X=16
	jsl.l $8FEC68		; $80E487: 22 68 EC 8F
CODE_80E48B:		; M=16 X=16
	inc.b $43		; $80E48B: E6 43
	lda.b $43		; $80E48D: A5 43
	cmp.w #$126F		; $80E48F: C9 6F 12
	bne CODE_80E43E		; $80E492: D0 AA
	rtl		; $80E494: 6B
CODE_80E495:		; M=16 X=16
	lda.w $128E		; $80E495: AD 8E 12
	beq CODE_80E4AE		; $80E498: F0 14
	lda.b $53		; $80E49A: A5 53
	pha		; $80E49C: 48
	lda.b $57		; $80E49D: A5 57
	eor.w #$FFFF		; $80E49F: 49 FF FF
	inc a		; $80E4A2: 1A
	sta.b $53		; $80E4A3: 85 53
	pla		; $80E4A5: 68
	sec		; $80E4A6: 38
	sbc.w #$00C5		; $80E4A7: E9 C5 00
	sta.b $57		; $80E4AA: 85 57
	bra CODE_80E4BE		; $80E4AC: 80 10
CODE_80E4AE:		; M=16 X=16
	lda.b $53		; $80E4AE: A5 53
	sec		; $80E4B0: 38
	sbc.w $0154		; $80E4B1: ED 54 01
	sta.b $53		; $80E4B4: 85 53
	lda.b $57		; $80E4B6: A5 57
	sec		; $80E4B8: 38
	sbc.w $08DF		; $80E4B9: ED DF 08
	sta.b $57		; $80E4BC: 85 57
CODE_80E4BE:		; M=16 X=16
	lda.b $53		; $80E4BE: A5 53
	bit.w #$8000		; $80E4C0: 89 00 80
	beq CODE_80E4C9		; $80E4C3: F0 04
	eor.w #$FFFF		; $80E4C5: 49 FF FF
	inc a		; $80E4C8: 1A
CODE_80E4C9:		; M=16 X=16
	cmp.w #$0091		; $80E4C9: C9 91 00
	bcs CODE_80E4FB		; $80E4CC: B0 2D
	lda.b $53		; $80E4CE: A5 53
	adc.w #$0080		; $80E4D0: 69 80 00
	sta.b $53		; $80E4D3: 85 53
	lda.b $5B		; $80E4D5: A5 5B
	asl a		; $80E4D7: 0A
	clc		; $80E4D8: 18
	adc.b $5B		; $80E4D9: 65 5B
	pha		; $80E4DB: 48
	asl a		; $80E4DC: 0A
	pla		; $80E4DD: 68
	ror a		; $80E4DE: 6A
	clc		; $80E4DF: 18
	adc.b $57		; $80E4E0: 65 57
	sta.b $57		; $80E4E2: 85 57
	bit.w #$8000		; $80E4E4: 89 00 80
	beq CODE_80E4ED		; $80E4E7: F0 04
	eor.w #$FFFF		; $80E4E9: 49 FF FF
	inc a		; $80E4EC: 1A
CODE_80E4ED:		; M=16 X=16
	cmp.w #$0091		; $80E4ED: C9 91 00
	bcs CODE_80E4FB		; $80E4F0: B0 09
	lda.w #$0070		; $80E4F2: A9 70 00
	sec		; $80E4F5: 38
	sbc.b $57		; $80E4F6: E5 57
	sta.b $57		; $80E4F8: 85 57
	rtl		; $80E4FA: 6B
CODE_80E4FB:		; M=16 X=16
	lda.w #$4E20		; $80E4FB: A9 20 4E
	sta.b $57		; $80E4FE: 85 57
	rtl		; $80E500: 6B
CODE_80E501:		; M=16 X=16
	jsl.l $80E60B		; $80E501: 22 0B E6 80
	ldx.w #$0000		; $80E505: A2 00 00
CODE_80E508:		; M=16 X=16
	cpx.w #$0006		; $80E508: E0 06 00
	bne CODE_80E510		; $80E50B: D0 03
	jmp.w $E5FA		; $80E50D: 4C FA E5
CODE_80E510:		; M=16 X=16
	lda.w $0114,x		; $80E510: BD 14 01
	sta.b $53		; $80E513: 85 53
	lda.w $011E,x		; $80E515: BD 1E 01
	sta.b $57		; $80E518: 85 57
	lda.w $0128,x		; $80E51A: BD 28 01
	bpl CODE_80E522		; $80E51D: 10 03
	jmp.w $E5FA		; $80E51F: 4C FA E5
CODE_80E522:		; M=16 X=16
	sta.b $5B		; $80E522: 85 5B
	jsl.l $80E495		; $80E524: 22 95 E4 80
	cmp.w #$4E20		; $80E528: C9 20 4E
	bne CODE_80E530		; $80E52B: D0 03
	jmp.w $E5FA		; $80E52D: 4C FA E5
CODE_80E530:		; M=16 X=16
	sta.b $CB		; $80E530: 85 CB
	lda.b $53		; $80E532: A5 53
	sta.b $C9		; $80E534: 85 C9
	lda.w $0100,x		; $80E536: BD 00 01
	sta.b $C3		; $80E539: 85 C3
	lda.b $F6,x		; $80E53B: B5 F6
	and.w #$0800		; $80E53D: 29 00 08
	sta.b $A5		; $80E540: 85 A5
	lda.b $F6,x		; $80E542: B5 F6
	and.w #$1000		; $80E544: 29 00 10
	sta.b $CD		; $80E547: 85 CD
	phx		; $80E549: DA
	jsl.l $8FEC68		; $80E54A: 22 68 EC 8F
	plx		; $80E54E: FA
	cpx.w #$0006		; $80E54F: E0 06 00
	bcc CODE_80E557		; $80E552: 90 03
	jmp.w $E5FA		; $80E554: 4C FA E5
CODE_80E557:		; M=16 X=16
	ldy.w #$0000		; $80E557: A0 00 00
	lda.w $0433,x		; $80E55A: BD 33 04
	lsr a		; $80E55D: 4A
	lsr a		; $80E55E: 4A
	lsr a		; $80E55F: 4A
	lsr a		; $80E560: 4A
	and.w #$000F		; $80E561: 29 0F 00
	beq CODE_80E57A		; $80E564: F0 14
	cmp.w #$000A		; $80E566: C9 0A 00
	bcc CODE_80E56E		; $80E569: 90 03
	jmp.w $E5FA		; $80E56B: 4C FA E5
CODE_80E56E:		; M=16 X=16
	sta.w $0193,y		; $80E56E: 99 93 01
	iny		; $80E571: C8
	dec.b $53		; $80E572: C6 53
	dec.b $53		; $80E574: C6 53
	dec.b $53		; $80E576: C6 53
	dec.b $53		; $80E578: C6 53
CODE_80E57A:		; M=16 X=16
	lda.w $0433,x		; $80E57A: BD 33 04
	and.w #$000F		; $80E57D: 29 0F 00
	cmp.w #$000A		; $80E580: C9 0A 00
	bcs CODE_80E5FA		; $80E583: B0 75
	sta.w $0193,y		; $80E585: 99 93 01
	iny		; $80E588: C8
	dec.b $53		; $80E589: C6 53
	dec.b $53		; $80E58B: C6 53
	dec.b $53		; $80E58D: C6 53
	dec.b $53		; $80E58F: C6 53
	lda.w $0434,x		; $80E591: BD 34 04
	and.w #$0007		; $80E594: 29 07 00
	beq CODE_80E5B8		; $80E597: F0 1F
	adc.w #$E604		; $80E599: 69 04 E6
	sta.b $43		; $80E59C: 85 43
	lda.w #$0080		; $80E59E: A9 80 00
	sta.b $45		; $80E5A1: 85 45
	lda.b $53		; $80E5A3: A5 53
	sec		; $80E5A5: 38
	sbc.w #$0006		; $80E5A6: E9 06 00
	sta.b $53		; $80E5A9: 85 53
	lda.w #$FFFF		; $80E5AB: A9 FF FF
	sta.w $0193,y		; $80E5AE: 99 93 01
	iny		; $80E5B1: C8
	lda.b [$43]		; $80E5B2: A7 43
	sta.w $0193,y		; $80E5B4: 99 93 01
	iny		; $80E5B7: C8
CODE_80E5B8:		; M=16 X=16
	sty.w $0191		; $80E5B8: 8C 91 01
	stz.b $55		; $80E5BB: 64 55
CODE_80E5BD:		; M=16 X=16
	ldy.b $55		; $80E5BD: A4 55
	cpy.w $0191		; $80E5BF: CC 91 01
	beq CODE_80E5FA		; $80E5C2: F0 36
	lda.w $0193,y		; $80E5C4: B9 93 01
	and.w #$00FF		; $80E5C7: 29 FF 00
	cmp.w #$00FF		; $80E5CA: C9 FF 00
	beq CODE_80E5EE		; $80E5CD: F0 1F
	adc.w #$021E		; $80E5CF: 69 1E 02
	sta.b $C3		; $80E5D2: 85 C3
	lda.b $53		; $80E5D4: A5 53
	sta.b $C9		; $80E5D6: 85 C9
	lda.b $57		; $80E5D8: A5 57
	clc		; $80E5DA: 18
	adc.w #$000A		; $80E5DB: 69 0A 00
	sta.b $CB		; $80E5DE: 85 CB
	phx		; $80E5E0: DA
	jsl.l $8FEC68		; $80E5E1: 22 68 EC 8F
	plx		; $80E5E5: FA
	inc.b $53		; $80E5E6: E6 53
	inc.b $53		; $80E5E8: E6 53
	inc.b $53		; $80E5EA: E6 53
	inc.b $53		; $80E5EC: E6 53
CODE_80E5EE:		; M=16 X=16
	inc.b $53		; $80E5EE: E6 53
	inc.b $53		; $80E5F0: E6 53
	inc.b $53		; $80E5F2: E6 53
	inc.b $53		; $80E5F4: E6 53
	inc.b $55		; $80E5F6: E6 55
	bra CODE_80E5BD		; $80E5F8: 80 C3
CODE_80E5FA:		; M=16 X=16
	inx		; $80E5FA: E8
	inx		; $80E5FB: E8
	cpx.w #$000A		; $80E5FC: E0 0A 00
	beq CODE_80E604		; $80E5FF: F0 03
	jmp.w $E508		; $80E601: 4C 08 E5
CODE_80E604:		; M=16 X=16
	rtl		; $80E604: 6B
	db $0B,$0B,$0C,$0A,$0D,$0E	; $80E605
CODE_80E60B:		; M=16 X=16
	ldy.w #$0008		; $80E60B: A0 08 00
	lda.w #$FFFF		; $80E60E: A9 FF FF
	sta.w $0128,y		; $80E611: 99 28 01
	lda.w $014E		; $80E614: AD 4E 01
	and.w #$00FF		; $80E617: 29 FF 00
	beq CODE_80E645		; $80E61A: F0 29
	and.w #$00FF		; $80E61C: 29 FF 00
	bit.w #$0080		; $80E61F: 89 80 00
	beq CODE_80E627		; $80E622: F0 03
	ora.w #$FF00		; $80E624: 09 00 FF
CODE_80E627:		; M=16 X=16
	asl a		; $80E627: 0A
	asl a		; $80E628: 0A
	sta.w $0114,y		; $80E629: 99 14 01
	lda.w $014F		; $80E62C: AD 4F 01
	and.w #$00FF		; $80E62F: 29 FF 00
	bit.w #$0080		; $80E632: 89 80 00
	beq CODE_80E63A		; $80E635: F0 03
	ora.w #$FF00		; $80E637: 09 00 FF
CODE_80E63A:		; M=16 X=16
	asl a		; $80E63A: 0A
	asl a		; $80E63B: 0A
	sta.w $011E,y		; $80E63C: 99 1E 01
	lda.w #$0000		; $80E63F: A9 00 00
	sta.w $0128,y		; $80E642: 99 28 01
CODE_80E645:		; M=16 X=16
	lda.w #$0003		; $80E645: A9 03 00
	sta.b $63		; $80E648: 85 63
	stz.b $33		; $80E64A: 64 33
	lda.w #$0433		; $80E64C: A9 33 04
	sta.b $37		; $80E64F: 85 37
	lda.w #$0000		; $80E651: A9 00 00
	sta.b $39		; $80E654: 85 39
	stz.b $3B		; $80E656: 64 3B
	lda.w $0431		; $80E658: AD 31 04
	sta.b $5F		; $80E65B: 85 5F
CODE_80E65D:		; M=16 X=16
	lda.b $5F		; $80E65D: A5 5F
	and.w #$000F		; $80E65F: 29 0F 00
	sta.b $53		; $80E662: 85 53
	lda.w #$000F		; $80E664: A9 0F 00
	sta.b $57		; $80E667: 85 57
	lda.b $53		; $80E669: A5 53
	cmp.w #$000E		; $80E66B: C9 0E 00
	beq CODE_80E6AE		; $80E66E: F0 3E
	ldy.b $33		; $80E670: A4 33
	lda.w #$FFFF		; $80E672: A9 FF FF
	sta.w $0128,y		; $80E675: 99 28 01
	lda.b $53		; $80E678: A5 53
	cmp.w #$000F		; $80E67A: C9 0F 00
	beq CODE_80E6B2		; $80E67D: F0 33
	asl.b $53		; $80E67F: 06 53
	ldy.b $53		; $80E681: A4 53
	lda.w $08FF,y		; $80E683: B9 FF 08
	ldy.b $33		; $80E686: A4 33
	sta.w $0114,y		; $80E688: 99 14 01
	ldy.b $53		; $80E68B: A4 53
	lda.w $095F,y		; $80E68D: B9 5F 09
	ldy.b $33		; $80E690: A4 33
	sta.w $011E,y		; $80E692: 99 1E 01
	lda.w #$0000		; $80E695: A9 00 00
	sta.w $0128,y		; $80E698: 99 28 01
	ldy.b $53		; $80E69B: A4 53
	lda.w $0B9F,y		; $80E69D: B9 9F 0B
	xba		; $80E6A0: EB
	and.w #$FF00		; $80E6A1: 29 00 FF
	sta.b $57		; $80E6A4: 85 57
	lda.w $103F,y		; $80E6A6: B9 3F 10
	and.w #$00FF		; $80E6A9: 29 FF 00
	tsb.b $57		; $80E6AC: 04 57
CODE_80E6AE:		; M=16 X=16
	lda.b $57		; $80E6AE: A5 57
	sta.b [$37]		; $80E6B0: 87 37
CODE_80E6B2:		; M=16 X=16
	lda.b $5F		; $80E6B2: A5 5F
	lsr a		; $80E6B4: 4A
	lsr a		; $80E6B5: 4A
	lsr a		; $80E6B6: 4A
	lsr a		; $80E6B7: 4A
	sta.b $5F		; $80E6B8: 85 5F
	inc.b $33		; $80E6BA: E6 33
	inc.b $33		; $80E6BC: E6 33
	inc.b $37		; $80E6BE: E6 37
	inc.b $37		; $80E6C0: E6 37
	dec.b $63		; $80E6C2: C6 63
	bpl CODE_80E65D		; $80E6C4: 10 97
	rtl		; $80E6C6: 6B
CODE_80E6C7:		; M=16 X=16
	jsl.l $8F8C72		; $80E6C7: 22 72 8C 8F
	jsl.l $80E715		; $80E6CB: 22 15 E7 80
	jsl.l $80E99F		; $80E6CF: 22 9F E9 80
	jmp.w $ECC7		; $80E6D3: 4C C7 EC
CODE_80E6D6:		; M=16 X=16
	stz.b $57		; $80E6D6: 64 57
	lda.w $097B		; $80E6D8: AD 7B 09
	sec		; $80E6DB: 38
	sbc.w #$0058		; $80E6DC: E9 58 00
	beq CODE_80E6E9		; $80E6DF: F0 08
	bmi CODE_80E6E7		; $80E6E1: 30 04
	bvs CODE_80E6E9		; $80E6E3: 70 04
	bra CODE_80E6FC		; $80E6E5: 80 15
CODE_80E6E7:		; M=16 X=16
	bvs CODE_80E6FC		; $80E6E7: 70 13
CODE_80E6E9:		; M=16 X=16
	inc.b $57		; $80E6E9: E6 57
	inc.b $57		; $80E6EB: E6 57
	lda.w $097B		; $80E6ED: AD 7B 09
	sec		; $80E6F0: 38
	sbc.w #$FFA8		; $80E6F1: E9 A8 FF
	bmi CODE_80E6FA		; $80E6F4: 30 04
	bvs CODE_80E6FC		; $80E6F6: 70 04
	bra CODE_80E714		; $80E6F8: 80 1A
CODE_80E6FA:		; M=16 X=16
	bvs CODE_80E714		; $80E6FA: 70 18
CODE_80E6FC:		; M=16 X=16
	lda.w $1288		; $80E6FC: AD 88 12
	bit.w #$0002		; $80E6FF: 89 02 00
	beq CODE_80E70B		; $80E702: F0 07
	lda.b $57		; $80E704: A5 57
	eor.w #$0002		; $80E706: 49 02 00
	sta.b $57		; $80E709: 85 57
CODE_80E70B:		; M=16 X=16
	ldy.b $57		; $80E70B: A4 57
	lda.w $13CA,y		; $80E70D: B9 CA 13
	inc a		; $80E710: 1A
	sta.w $13CA,y		; $80E711: 99 CA 13
CODE_80E714:		; M=16 X=16
	rtl		; $80E714: 6B
CODE_80E715:		; M=16 X=16
	lda.w $128E		; $80E715: AD 8E 12
	beq CODE_80E71D		; $80E718: F0 03
	jmp.w $E7DF		; $80E71A: 4C DF E7
CODE_80E71D:		; M=16 X=16
	lda.w #$129E		; $80E71D: A9 9E 12
	sta.b $33		; $80E720: 85 33
CODE_80E722:		; M=16 X=16
	lda.b ($33)		; $80E722: B2 33
	inc.b $33		; $80E724: E6 33
	inc.b $33		; $80E726: E6 33
	tay		; $80E728: A8
	bne CODE_80E72E		; $80E729: D0 03
	jmp.w $E7DF		; $80E72B: 4C DF E7
CODE_80E72E:		; M=16 X=16
	lda.w $1288		; $80E72E: AD 88 12
	bit.w #$0004		; $80E731: 89 04 00
	bne CODE_80E786		; $80E734: D0 50
	dec.b $33		; $80E736: C6 33
	dec.b $33		; $80E738: C6 33
	lda.b ($33)		; $80E73A: B2 33
	inc.b $33		; $80E73C: E6 33
	inc.b $33		; $80E73E: E6 33
	and.w #$00FF		; $80E740: 29 FF 00
	sta.b $53		; $80E743: 85 53
	tay		; $80E745: A8
	lda.w #$BF6A		; $80E746: A9 6A BF
	sta.b $37		; $80E749: 85 37
	lda.w #$0080		; $80E74B: A9 80 00
	sta.b $39		; $80E74E: 85 39
	lda.b [$37],y		; $80E750: B7 37
	clc		; $80E752: 18
	adc.b $37		; $80E753: 65 37
	sta.b $37		; $80E755: 85 37
	lda.b [$37]		; $80E757: A7 37
	and.w #$00FF		; $80E759: 29 FF 00
	beq CODE_80E782		; $80E75C: F0 24
	lda.w $0EBB		; $80E75E: AD BB 0E
	bmi CODE_80E7E0		; $80E761: 30 7D
	sec		; $80E763: 38
	sbc.w #$0006		; $80E764: E9 06 00
	sta.b $53		; $80E767: 85 53
	dec.b $33		; $80E769: C6 33
	lda.b ($33)		; $80E76B: B2 33
	inc.b $33		; $80E76D: E6 33
	and.w #$00FF		; $80E76F: 29 FF 00
	bit.w #$0080		; $80E772: 89 80 00
	beq CODE_80E77A		; $80E775: F0 03
	ora.w #$FF00		; $80E777: 09 00 FF
CODE_80E77A:		; M=16 X=16
	sec		; $80E77A: 38
	sbc.w #$0006		; $80E77B: E9 06 00
	eor.b $53		; $80E77E: 45 53
	bmi CODE_80E7E0		; $80E780: 30 5E
CODE_80E782:		; M=16 X=16
	jsl.l $80E7F7		; $80E782: 22 F7 E7 80
CODE_80E786:		; M=16 X=16
	dec.b $33		; $80E786: C6 33
	lda.b ($33)		; $80E788: B2 33
	tay		; $80E78A: A8
	ora.w #$0080		; $80E78B: 09 80 00
	sta.b ($33)		; $80E78E: 92 33
	inc.b $33		; $80E790: E6 33
	tya		; $80E792: 98
	bit.w #$0080		; $80E793: 89 80 00
	bne CODE_80E722		; $80E796: D0 8A
	dec.b $33		; $80E798: C6 33
	dec.b $33		; $80E79A: C6 33
	lda.b ($33)		; $80E79C: B2 33
	inc.b $33		; $80E79E: E6 33
	inc.b $33		; $80E7A0: E6 33
	and.w #$00FF		; $80E7A2: 29 FF 00
	sta.b $53		; $80E7A5: 85 53
	tay		; $80E7A7: A8
	lda.w #$BF6A		; $80E7A8: A9 6A BF
	sta.b $37		; $80E7AB: 85 37
	lda.w #$0080		; $80E7AD: A9 80 00
	sta.b $39		; $80E7B0: 85 39
	lda.b [$37],y		; $80E7B2: B7 37
	clc		; $80E7B4: 18
	adc.b $37		; $80E7B5: 65 37
	sta.b $37		; $80E7B7: 85 37
	ldy.w #$0001		; $80E7B9: A0 01 00
	lda.b [$37],y		; $80E7BC: B7 37
	and.w #$00FF		; $80E7BE: 29 FF 00
	asl a		; $80E7C1: 0A
	asl a		; $80E7C2: 0A
	asl a		; $80E7C3: 0A
	asl a		; $80E7C4: 0A
	asl a		; $80E7C5: 0A
	sta.b $57		; $80E7C6: 85 57
	sec		; $80E7C8: 38
	sbc.w $12E0		; $80E7C9: ED E0 12
	beq CODE_80E7D2		; $80E7CC: F0 04
	bmi CODE_80E7D5		; $80E7CE: 30 05
	bvc CODE_80E7D7		; $80E7D0: 50 05
CODE_80E7D2:		; M=16 X=16
	jmp.w $E722		; $80E7D2: 4C 22 E7
CODE_80E7D5:		; M=16 X=16
	bvc CODE_80E7D2		; $80E7D5: 50 FB
CODE_80E7D7:		; M=16 X=16
	lda.b $57		; $80E7D7: A5 57
	sta.w $12E0		; $80E7D9: 8D E0 12
	jmp.w $E722		; $80E7DC: 4C 22 E7
CODE_80E7DF:		; M=16 X=16
	rtl		; $80E7DF: 6B
CODE_80E7E0:		; M=16 X=16
	lda.w #$0008		; $80E7E0: A9 08 00
	tsb.w $1288		; $80E7E3: 0C 88 12
	beq CODE_80E7EB		; $80E7E6: F0 03
	jmp.w $E722		; $80E7E8: 4C 22 E7
CODE_80E7EB:		; M=16 X=16
	lda.w #$002C		; $80E7EB: A9 2C 00
	sta.b $53		; $80E7EE: 85 53
	jsl.l $80ED0C		; $80E7F0: 22 0C ED 80
	jmp.w $E722		; $80E7F4: 4C 22 E7
CODE_80E7F7:		; M=16 X=16
	lda.w #$FFFF		; $80E7F7: A9 FF FF
	tsb.w $128A		; $80E7FA: 0C 8A 12
	beq CODE_80E802		; $80E7FD: F0 03
	jmp.w $E8CC		; $80E7FF: 4C CC E8
CODE_80E802:		; M=16 X=16
	stz.b $53		; $80E802: 64 53
	stz.b $57		; $80E804: 64 57
	dec.b $33		; $80E806: C6 33
	dec.b $33		; $80E808: C6 33
	lda.b ($33)		; $80E80A: B2 33
	inc.b $33		; $80E80C: E6 33
	inc.b $33		; $80E80E: E6 33
	and.w #$00FF		; $80E810: 29 FF 00
	cmp.w #$000E		; $80E813: C9 0E 00
	beq CODE_80E850		; $80E816: F0 38
	ldy.w $018D		; $80E818: AC 8D 01
	sty.b $53		; $80E81B: 84 53
	ldy.w $018F		; $80E81D: AC 8F 01
	sty.b $57		; $80E820: 84 57
	cmp.w #$0006		; $80E822: C9 06 00
	beq CODE_80E850		; $80E825: F0 29
	ldy.w $091B		; $80E827: AC 1B 09
	sty.b $53		; $80E82A: 84 53
	ldy.w $097B		; $80E82C: AC 7B 09
	sty.b $57		; $80E82F: 84 57
	cmp.w #$000C		; $80E831: C9 0C 00
	bne CODE_80E850		; $80E834: D0 1A
	dec.b $33		; $80E836: C6 33
	lda.b ($33)		; $80E838: B2 33
	inc.b $33		; $80E83A: E6 33
	and.w #$00FF		; $80E83C: 29 FF 00
	asl a		; $80E83F: 0A
	tay		; $80E840: A8
	lda.w #$0258		; $80E841: A9 58 02
	sta.b $57		; $80E844: 85 57
	lda.w $113F,y		; $80E846: B9 3F 11
	beq CODE_80E850		; $80E849: F0 05
	lda.w #$FDA8		; $80E84B: A9 A8 FD
	sta.b $57		; $80E84E: 85 57
CODE_80E850:		; M=16 X=16
	lda.b $53		; $80E850: A5 53
	sta.b $73		; $80E852: 85 73
	sec		; $80E854: 38
	sbc.w #$0046		; $80E855: E9 46 00
	bmi CODE_80E85E		; $80E858: 30 04
	bvc CODE_80E860		; $80E85A: 50 04
	bra CODE_80E865		; $80E85C: 80 07
CODE_80E85E:		; M=16 X=16
	bvc CODE_80E865		; $80E85E: 50 05
CODE_80E860:		; M=16 X=16
	lda.w #$0046		; $80E860: A9 46 00
	sta.b $53		; $80E863: 85 53
CODE_80E865:		; M=16 X=16
	lda.b $53		; $80E865: A5 53
	sec		; $80E867: 38
	sbc.w #$FFBA		; $80E868: E9 BA FF
	beq CODE_80E875		; $80E86B: F0 08
	bmi CODE_80E873		; $80E86D: 30 04
	bvs CODE_80E875		; $80E86F: 70 04
	bra CODE_80E87A		; $80E871: 80 07
CODE_80E873:		; M=16 X=16
	bvs CODE_80E87A		; $80E873: 70 05
CODE_80E875:		; M=16 X=16
	lda.w #$FFBA		; $80E875: A9 BA FF
	sta.b $53		; $80E878: 85 53
CODE_80E87A:		; M=16 X=16
	lda.b $57		; $80E87A: A5 57
	sec		; $80E87C: 38
	sbc.w #$00A6		; $80E87D: E9 A6 00
	bmi CODE_80E886		; $80E880: 30 04
	bvc CODE_80E888		; $80E882: 50 04
	bra CODE_80E89B		; $80E884: 80 15
CODE_80E886:		; M=16 X=16
	bvc CODE_80E89B		; $80E886: 50 13
CODE_80E888:		; M=16 X=16
	lda.w #$00CE		; $80E888: A9 CE 00
	sta.b $57		; $80E88B: 85 57
	lda.w #$0046		; $80E88D: A9 46 00
	sta.b $53		; $80E890: 85 53
	lda.b $73		; $80E892: A5 73
	bpl CODE_80E89B		; $80E894: 10 05
	lda.w #$FFBA		; $80E896: A9 BA FF
	sta.b $53		; $80E899: 85 53
CODE_80E89B:		; M=16 X=16
	lda.b $57		; $80E89B: A5 57
	sec		; $80E89D: 38
	sbc.w #$FF5A		; $80E89E: E9 5A FF
	beq CODE_80E8AB		; $80E8A1: F0 08
	bmi CODE_80E8A9		; $80E8A3: 30 04
	bvs CODE_80E8AB		; $80E8A5: 70 04
	bra CODE_80E8BE		; $80E8A7: 80 15
CODE_80E8A9:		; M=16 X=16
	bvs CODE_80E8BE		; $80E8A9: 70 13
CODE_80E8AB:		; M=16 X=16
	lda.w #$FF32		; $80E8AB: A9 32 FF
	sta.b $57		; $80E8AE: 85 57
	lda.w #$0046		; $80E8B0: A9 46 00
	sta.b $53		; $80E8B3: 85 53
	lda.b $73		; $80E8B5: A5 73
	bpl CODE_80E8BE		; $80E8B7: 10 05
	lda.w #$FFBA		; $80E8B9: A9 BA FF
	sta.b $53		; $80E8BC: 85 53
CODE_80E8BE:		; M=16 X=16
	lda.b $53		; $80E8BE: A5 53
	sta.w $0146		; $80E8C0: 8D 46 01
	lda.b $57		; $80E8C3: A5 57
	sta.w $0148		; $80E8C5: 8D 48 01
	jsl.l $80E8F4		; $80E8C8: 22 F4 E8 80
CODE_80E8CC:		; M=16 X=16
	lda.b $00		; $80E8CC: A5 00
	sec		; $80E8CE: 38
	sbc.w $04A7		; $80E8CF: ED A7 04
	cmp.w #$003C		; $80E8D2: C9 3C 00
	bcc CODE_80E8DB		; $80E8D5: 90 04
	jsl.l $82FA1A		; $80E8D7: 22 1A FA 82
CODE_80E8DB:		; M=16 X=16
	lda.w #$0089		; $80E8DB: A9 89 00
	pha		; $80E8DE: 48
	jsl.l $80C28B		; $80E8DF: 22 8B C2 80
	stz.w $12E0		; $80E8E3: 9C E0 12
	lda.w #$0004		; $80E8E6: A9 04 00
	tsb.w $1288		; $80E8E9: 0C 88 12
	lda.w #$000A		; $80E8EC: A9 0A 00
	sta.b $53		; $80E8EF: 85 53
	jmp.w $ED0C		; $80E8F1: 4C 0C ED
CODE_80E8F4:		; M=16 X=16
	stx.b $0A		; $80E8F4: 86 0A
	ldx.w #$0000		; $80E8F6: A2 00 00
CODE_80E8F9:		; M=16 X=16
	lda.b $53,x		; $80E8F9: B5 53
	pha		; $80E8FB: 48
	inx		; $80E8FC: E8
	inx		; $80E8FD: E8
	cpx.w #$0008		; $80E8FE: E0 08 00
	bne CODE_80E8F9		; $80E901: D0 F6
	ldx.b $0A		; $80E903: A6 0A
	stx.b $0A		; $80E905: 86 0A
	ldx.w #$0000		; $80E907: A2 00 00
CODE_80E90A:		; M=16 X=16
	lda.b $33,x		; $80E90A: B5 33
	pha		; $80E90C: 48
	inx		; $80E90D: E8
	inx		; $80E90E: E8
	cpx.w #$0008		; $80E90F: E0 08 00
	bne CODE_80E90A		; $80E912: D0 F6
	ldx.b $0A		; $80E914: A6 0A
	lda.w #$129E		; $80E916: A9 9E 12
	sta.b $33		; $80E919: 85 33
	lda.w #$0000		; $80E91B: A9 00 00
	sta.b $35		; $80E91E: 85 35
CODE_80E920:		; M=16 X=16
	jsl.l $80E949		; $80E920: 22 49 E9 80
	inc.b $33		; $80E924: E6 33
	inc.b $33		; $80E926: E6 33
	lda.b [$33]		; $80E928: A7 33
	bne CODE_80E920		; $80E92A: D0 F4
	stx.b $0A		; $80E92C: 86 0A
	ldx.w #$0006		; $80E92E: A2 06 00
CODE_80E931:		; M=16 X=16
	pla		; $80E931: 68
	sta.b $33,x		; $80E932: 95 33
	dex		; $80E934: CA
	dex		; $80E935: CA
	bpl CODE_80E931		; $80E936: 10 F9
	ldx.b $0A		; $80E938: A6 0A
	stx.b $0A		; $80E93A: 86 0A
	ldx.w #$0006		; $80E93C: A2 06 00
CODE_80E93F:		; M=16 X=16
	pla		; $80E93F: 68
	sta.b $53,x		; $80E940: 95 53
	dex		; $80E942: CA
	dex		; $80E943: CA
	bpl CODE_80E93F		; $80E944: 10 F9
	ldx.b $0A		; $80E946: A6 0A
	rtl		; $80E948: 6B
CODE_80E949:		; M=16 X=16
	lda.b [$33]		; $80E949: A7 33
	xba		; $80E94B: EB
	and.w #$007F		; $80E94C: 29 7F 00
	asl a		; $80E94F: 0A
	tay		; $80E950: A8
	lda.w #$0058		; $80E951: A9 58 00
	sta.b $57		; $80E954: 85 57
	lda.w $113F,y		; $80E956: B9 3F 11
	bne CODE_80E974		; $80E959: D0 19
	lda.w #$FFA8		; $80E95B: A9 A8 FF
	sta.b $57		; $80E95E: 85 57
	sec		; $80E960: 38
	sbc.w $0148		; $80E961: ED 48 01
	bmi CODE_80E96A		; $80E964: 30 04
	bvc CODE_80E96C		; $80E966: 50 04
	bra CODE_80E99E		; $80E968: 80 34
CODE_80E96A:		; M=16 X=16
	bvc CODE_80E99E		; $80E96A: 50 32
CODE_80E96C:		; M=16 X=16
	lda.w #$FFBF		; $80E96C: A9 BF FF
	sta.w $0148		; $80E96F: 8D 48 01
	bra CODE_80E98A		; $80E972: 80 16
CODE_80E974:		; M=16 X=16
	lda.b $57		; $80E974: A5 57
	sec		; $80E976: 38
	sbc.w $0148		; $80E977: ED 48 01
	beq CODE_80E984		; $80E97A: F0 08
	bmi CODE_80E982		; $80E97C: 30 04
	bvs CODE_80E984		; $80E97E: 70 04
	bra CODE_80E99E		; $80E980: 80 1C
CODE_80E982:		; M=16 X=16
	bvs CODE_80E99E		; $80E982: 70 1A
CODE_80E984:		; M=16 X=16
	lda.w #$0041		; $80E984: A9 41 00
	sta.w $0148		; $80E987: 8D 48 01
CODE_80E98A:		; M=16 X=16
	lda.w #$0046		; $80E98A: A9 46 00
	sta.b $53		; $80E98D: 85 53
	lda.w $0146		; $80E98F: AD 46 01
	bpl CODE_80E999		; $80E992: 10 05
	lda.w #$FFBA		; $80E994: A9 BA FF
	sta.b $53		; $80E997: 85 53
CODE_80E999:		; M=16 X=16
	lda.b $53		; $80E999: A5 53
	sta.w $0146		; $80E99B: 8D 46 01
CODE_80E99E:		; M=16 X=16
	rtl		; $80E99E: 6B
CODE_80E99F:		; M=16 X=16
	lda.w $1288		; $80E99F: AD 88 12
	bit.w #$0004		; $80E9A2: 89 04 00
	bne CODE_80E9AA		; $80E9A5: D0 03
	jmp.w $EA3F		; $80E9A7: 4C 3F EA
CODE_80E9AA:		; M=16 X=16
	lda.w $12E0		; $80E9AA: AD E0 12
	bpl CODE_80E9B2		; $80E9AD: 10 03
	jmp.w $EA40		; $80E9AF: 4C 40 EA
CODE_80E9B2:		; M=16 X=16
	sec		; $80E9B2: 38
	sbc.b $6F		; $80E9B3: E5 6F
	sta.w $12E0		; $80E9B5: 8D E0 12
	bmi CODE_80E9BD		; $80E9B8: 30 03
	jmp.w $EA3F		; $80E9BA: 4C 3F EA
CODE_80E9BD:		; M=16 X=16
	lda.w #$0008		; $80E9BD: A9 08 00
	trb.w $1288		; $80E9C0: 1C 88 12
	lda.w #$129E		; $80E9C3: A9 9E 12
	sta.b $33		; $80E9C6: 85 33
	lda.w #$0000		; $80E9C8: A9 00 00
	sta.b $35		; $80E9CB: 85 35
CODE_80E9CD:		; M=16 X=16
	lda.b [$33]		; $80E9CD: A7 33
	inc.b $33		; $80E9CF: E6 33
	inc.b $33		; $80E9D1: E6 33
	tay		; $80E9D3: A8
	beq CODE_80EA3F		; $80E9D4: F0 69
	dec.b $33		; $80E9D6: C6 33
	dec.b $33		; $80E9D8: C6 33
	lda.b [$33]		; $80E9DA: A7 33
	inc.b $33		; $80E9DC: E6 33
	inc.b $33		; $80E9DE: E6 33
	and.w #$00FF		; $80E9E0: 29 FF 00
	sta.b $53		; $80E9E3: 85 53
	tay		; $80E9E5: A8
	lda.w #$0080		; $80E9E6: A9 80 00
	sta.b $39		; $80E9E9: 85 39
	lda.w #$BF6A		; $80E9EB: A9 6A BF
	sta.b $37		; $80E9EE: 85 37
	clc		; $80E9F0: 18
	adc.b [$37],y		; $80E9F1: 77 37
	sta.b $37		; $80E9F3: 85 37
	lda.b [$37]		; $80E9F5: A7 37
	and.w #$00FF		; $80E9F7: 29 FF 00
	beq CODE_80E9CD		; $80E9FA: F0 D1
	lda.w #$0400		; $80E9FC: A9 00 04
	tsb.w $128C		; $80E9FF: 0C 8C 12
	jsl.l $8F84B5		; $80EA02: 22 B5 84 8F
	jsl.l $8F8858		; $80EA06: 22 58 88 8F
	lda.w #$FF00		; $80EA0A: A9 00 FF
	tsb.w $0EBB		; $80EA0D: 0C BB 0E
	ldx.w #$001C		; $80EA10: A2 1C 00
	stx.b $3F		; $80EA13: 86 3F
	lda.w #$001A		; $80EA15: A9 1A 00
	sta.b $53		; $80EA18: 85 53
	jsl.l $80B49D		; $80EA1A: 22 9D B4 80
	lda.w #$1C20		; $80EA1E: A9 20 1C
	ldx.b $3F		; $80EA21: A6 3F
	sta.w $0C5F,x		; $80EA23: 9D 5F 0C
	lda.w #$FF00		; $80EA26: A9 00 FF
	tsb.w $12EC		; $80EA29: 0C EC 12
	stz.w $12EA		; $80EA2C: 9C EA 12
	jsl.l $80ECC7		; $80EA2F: 22 C7 EC 80
	lda.w #$0032		; $80EA33: A9 32 00
	sta.w $12EA		; $80EA36: 8D EA 12
	stz.b $53		; $80EA39: 64 53
	jsl.l $8F83A7		; $80EA3B: 22 A7 83 8F
CODE_80EA3F:		; M=16 X=16
	rtl		; $80EA3F: 6B
CODE_80EA40:		; M=16 X=16
	lda.w $12EA		; $80EA40: AD EA 12
	bmi CODE_80EA48		; $80EA43: 30 03
	jmp.w $EC88		; $80EA45: 4C 88 EC
CODE_80EA48:		; M=16 X=16
	lda.w $12EC		; $80EA48: AD EC 12
	bmi CODE_80EA50		; $80EA4B: 30 03
	jmp.w $EC88		; $80EA4D: 4C 88 EC
CODE_80EA50:		; M=16 X=16
	stx.b $0A		; $80EA50: 86 0A
	ldx.w #$0000		; $80EA52: A2 00 00
CODE_80EA55:		; M=16 X=16
	lda.b $53,x		; $80EA55: B5 53
	pha		; $80EA57: 48
	inx		; $80EA58: E8
	inx		; $80EA59: E8
	cpx.w #$0004		; $80EA5A: E0 04 00
	bne CODE_80EA55		; $80EA5D: D0 F6
	ldx.b $0A		; $80EA5F: A6 0A
	stx.b $0A		; $80EA61: 86 0A
	ldx.w #$0000		; $80EA63: A2 00 00
CODE_80EA66:		; M=16 X=16
	lda.b $33,x		; $80EA66: B5 33
	pha		; $80EA68: 48
	inx		; $80EA69: E8
	inx		; $80EA6A: E8
	cpx.w #$0010		; $80EA6B: E0 10 00
	bne CODE_80EA66		; $80EA6E: D0 F6
	ldx.b $0A		; $80EA70: A6 0A
CODE_80EA72:		; M=16 X=16
	lda.w #$0000		; $80EA72: A9 00 00
	sta.b $35		; $80EA75: 85 35
	lda.w #$129E		; $80EA77: A9 9E 12
	sta.b $33		; $80EA7A: 85 33
	lda.b [$33]		; $80EA7C: A7 33
	inc.b $33		; $80EA7E: E6 33
	inc.b $33		; $80EA80: E6 33
	cmp.w #$0000		; $80EA82: C9 00 00
	bne CODE_80EA8A		; $80EA85: D0 03
	jmp.w $EC47		; $80EA87: 4C 47 EC
CODE_80EA8A:		; M=16 X=16
	lda.b [$33]		; $80EA8A: A7 33
	inc.b $33		; $80EA8C: E6 33
	inc.b $33		; $80EA8E: E6 33
	cmp.w #$0000		; $80EA90: C9 00 00
	bne CODE_80EA8A		; $80EA93: D0 F5
	dec.b $33		; $80EA95: C6 33
	dec.b $33		; $80EA97: C6 33
	dec.b $33		; $80EA99: C6 33
	dec.b $33		; $80EA9B: C6 33
	lda.b [$33]		; $80EA9D: A7 33
	pha		; $80EA9F: 48
	and.w #$7FFF		; $80EAA0: 29 FF 7F
	sta.b [$33]		; $80EAA3: 87 33
	pla		; $80EAA5: 68
	bmi CODE_80EAC2		; $80EAA6: 30 1A
	lda.b [$33]		; $80EAA8: A7 33
	xba		; $80EAAA: EB
	and.w #$00FF		; $80EAAB: 29 FF 00
	asl a		; $80EAAE: 0A
	sta.b $57		; $80EAAF: 85 57
	tay		; $80EAB1: A8
	lda.w $0B9F,y		; $80EAB2: B9 9F 0B
	bmi CODE_80EABA		; $80EAB5: 30 03
	jmp.w $EC6A		; $80EAB7: 4C 6A EC
CODE_80EABA:		; M=16 X=16
	lda.w #$0000		; $80EABA: A9 00 00
	sta.b [$33]		; $80EABD: 87 33
	jmp.w $EC6A		; $80EABF: 4C 6A EC
CODE_80EAC2:		; M=16 X=16
	lda.b [$33]		; $80EAC2: A7 33
	and.w #$00FF		; $80EAC4: 29 FF 00
	sta.b $53		; $80EAC7: 85 53
	tay		; $80EAC9: A8
	lda.w #$BF6A		; $80EACA: A9 6A BF
	sta.b $37		; $80EACD: 85 37
	lda.w #$0080		; $80EACF: A9 80 00
	sta.b $39		; $80EAD2: 85 39
	lda.b [$37],y		; $80EAD4: B7 37
	clc		; $80EAD6: 18
	adc.b $37		; $80EAD7: 65 37
	sta.b $37		; $80EAD9: 85 37
	lda.b [$37]		; $80EADB: A7 37
	and.w #$00FF		; $80EADD: 29 FF 00
	sta.b $5B		; $80EAE0: 85 5B
	bne CODE_80EAE7		; $80EAE2: D0 03
	jmp.w $EC34		; $80EAE4: 4C 34 EC
CODE_80EAE7:		; M=16 X=16
	stx.b $0A		; $80EAE7: 86 0A
	ldx.w #$0000		; $80EAE9: A2 00 00
CODE_80EAEC:		; M=16 X=16
	lda.b $53,x		; $80EAEC: B5 53
	pha		; $80EAEE: 48
	inx		; $80EAEF: E8
	inx		; $80EAF0: E8
	cpx.w #$0008		; $80EAF1: E0 08 00
	bne CODE_80EAEC		; $80EAF4: D0 F6
	ldx.b $0A		; $80EAF6: A6 0A
	stx.b $0A		; $80EAF8: 86 0A
	ldx.w #$0000		; $80EAFA: A2 00 00
CODE_80EAFD:		; M=16 X=16
	lda.b $37,x		; $80EAFD: B5 37
	pha		; $80EAFF: 48
	inx		; $80EB00: E8
	inx		; $80EB01: E8
	cpx.w #$0010		; $80EB02: E0 10 00
	bne CODE_80EAFD		; $80EB05: D0 F6
	ldx.b $0A		; $80EB07: A6 0A
	jsl.l $86FC8A		; $80EB09: 22 8A FC 86
	lda.b [$33]		; $80EB0D: A7 33
	xba		; $80EB0F: EB
	and.w #$00FF		; $80EB10: 29 FF 00
	asl a		; $80EB13: 0A
	sta.b $57		; $80EB14: 85 57
	tax		; $80EB16: AA
	stx.b $3F		; $80EB17: 86 3F
	stz.b $53		; $80EB19: 64 53
	stz.b $3B		; $80EB1B: 64 3B
	lda.w #$0002		; $80EB1D: A9 02 00
	sta.b $37		; $80EB20: 85 37
	lda.w $119F,x		; $80EB22: BD 9F 11
	beq CODE_80EB33		; $80EB25: F0 0C
	lda.w #$8000		; $80EB27: A9 00 80
	sta.b $53		; $80EB2A: 85 53
	stz.b $37		; $80EB2C: 64 37
	lda.w #$0002		; $80EB2E: A9 02 00
	sta.b $3B		; $80EB31: 85 3B
CODE_80EB33:		; M=16 X=16
	ldy.b $3B		; $80EB33: A4 3B
	lda.w $13BE,y		; $80EB35: B9 BE 13
	inc a		; $80EB38: 1A
	sta.w $13BE,y		; $80EB39: 99 BE 13
	lda.w $13C2,y		; $80EB3C: B9 C2 13
	clc		; $80EB3F: 18
	adc.b $5B		; $80EB40: 65 5B
	sta.w $13C2,y		; $80EB42: 99 C2 13
	lda.w $0F1F,x		; $80EB45: BD 1F 0F
	and.w #$00FF		; $80EB48: 29 FF 00
	ora.b $53		; $80EB4B: 05 53
	sta.w $12FA		; $80EB4D: 8D FA 12
	and.w #$00FF		; $80EB50: 29 FF 00
	bit.w #$0080		; $80EB53: 89 80 00
	beq CODE_80EB5B		; $80EB56: F0 03
	ora.w #$FF00		; $80EB58: 09 00 FF
CODE_80EB5B:		; M=16 X=16
	asl a		; $80EB5B: 0A
	sta.b $53		; $80EB5C: 85 53
	lda.w #$003C		; $80EB5E: A9 3C 00
	sta.b $7D		; $80EB61: 85 7D
	lda.b $5B		; $80EB63: A5 5B
	and.w #$00FF		; $80EB65: 29 FF 00
	sta.b $83		; $80EB68: 85 83
	jsl.l $8D871C		; $80EB6A: 22 1C 87 8D
	ora.w #$2000		; $80EB6E: 09 00 20
	sta.b $5B		; $80EB71: 85 5B
	lda.b $3B		; $80EB73: A5 3B
	beq CODE_80EB7A		; $80EB75: F0 03
	lda.w #$0034		; $80EB77: A9 34 00
CODE_80EB7A:		; M=16 X=16
	clc		; $80EB7A: 18
	adc.b $53		; $80EB7B: 65 53
	tay		; $80EB7D: A8
	lda.w $14E2,y		; $80EB7E: B9 E2 14
	bmi CODE_80EB88		; $80EB81: 30 05
	and.w #$1000		; $80EB83: 29 00 10
	tsb.b $5B		; $80EB86: 04 5B
CODE_80EB88:		; M=16 X=16
	lda.b $5B		; $80EB88: A5 5B
	sta.w $14E2,y		; $80EB8A: 99 E2 14
	lda.w #$1000		; $80EB8D: A9 00 10
	trb.b $5B		; $80EB90: 14 5B
	lda.w #$0034		; $80EB92: A9 34 00
	sta.b $57		; $80EB95: 85 57
CODE_80EB97:		; M=16 X=16
	dec.b $57		; $80EB97: C6 57
	dec.b $57		; $80EB99: C6 57
	bmi CODE_80EBD1		; $80EB9B: 30 34
	lda.b $37		; $80EB9D: A5 37
	beq CODE_80EBA4		; $80EB9F: F0 03
	lda.w #$0034		; $80EBA1: A9 34 00
CODE_80EBA4:		; M=16 X=16
	clc		; $80EBA4: 18
	adc.b $57		; $80EBA5: 65 57
	tay		; $80EBA7: A8
	lda.w $14E2,y		; $80EBA8: B9 E2 14
	and.w #$EFFF		; $80EBAB: 29 FF EF
	sta.b $5F		; $80EBAE: 85 5F
	cmp.b $5B		; $80EBB0: C5 5B
	bne CODE_80EB97		; $80EBB2: D0 E3
	lda.w $14E2,y		; $80EBB4: B9 E2 14
	ora.w #$4000		; $80EBB7: 09 00 40
	sta.w $14E2,y		; $80EBBA: 99 E2 14
	lda.b $3B		; $80EBBD: A5 3B
	beq CODE_80EBC4		; $80EBBF: F0 03
	lda.w #$0034		; $80EBC1: A9 34 00
CODE_80EBC4:		; M=16 X=16
	clc		; $80EBC4: 18
	adc.b $53		; $80EBC5: 65 53
	tay		; $80EBC7: A8
	lda.w $14E2,y		; $80EBC8: B9 E2 14
	ora.w #$4000		; $80EBCB: 09 00 40
	sta.w $14E2,y		; $80EBCE: 99 E2 14
CODE_80EBD1:		; M=16 X=16
	lda.b $35		; $80EBD1: A5 35
	pha		; $80EBD3: 48
	lda.b $33		; $80EBD4: A5 33
	pha		; $80EBD6: 48
	lda.b $3B		; $80EBD7: A5 3B
	beq CODE_80EBDE		; $80EBD9: F0 03
	lda.w #$001A		; $80EBDB: A9 1A 00
CODE_80EBDE:		; M=16 X=16
	sta.b $33		; $80EBDE: 85 33
	lda.w #$0018		; $80EBE0: A9 18 00
	sta.b $57		; $80EBE3: 85 57
CODE_80EBE5:		; M=16 X=16
	ldy.b $33		; $80EBE5: A4 33
	inc.b $33		; $80EBE7: E6 33
	lda.w $154A,y		; $80EBE9: B9 4A 15
	bit.w #$0080		; $80EBEC: 89 80 00
	bne CODE_80EBF5		; $80EBEF: D0 04
	dec.b $57		; $80EBF1: C6 57
	bpl CODE_80EBE5		; $80EBF3: 10 F0
CODE_80EBF5:		; M=16 X=16
	lda.b $53		; $80EBF5: A5 53
	ora.w #$FF00		; $80EBF7: 09 00 FF
	sta.w $154A,y		; $80EBFA: 99 4A 15
	pla		; $80EBFD: 68
	sta.b $33		; $80EBFE: 85 33
	pla		; $80EC00: 68
	sta.b $35		; $80EC01: 85 35
	lda.w #$000C		; $80EC03: A9 0C 00
	sta.b $53		; $80EC06: 85 53
	jsl.l $80B4A7		; $80EC08: 22 A7 B4 80
	stx.b $0A		; $80EC0C: 86 0A
	ldx.w #$000E		; $80EC0E: A2 0E 00
CODE_80EC11:		; M=16 X=16
	pla		; $80EC11: 68
	sta.b $37,x		; $80EC12: 95 37
	dex		; $80EC14: CA
	dex		; $80EC15: CA
	bpl CODE_80EC11		; $80EC16: 10 F9
	ldx.b $0A		; $80EC18: A6 0A
	stx.b $0A		; $80EC1A: 86 0A
	ldx.w #$0006		; $80EC1C: A2 06 00
CODE_80EC1F:		; M=16 X=16
	pla		; $80EC1F: 68
	sta.b $53,x		; $80EC20: 95 53
	dex		; $80EC22: CA
	dex		; $80EC23: CA
	bpl CODE_80EC1F		; $80EC24: 10 F9
	ldx.b $0A		; $80EC26: A6 0A
	ldx.b $3F		; $80EC28: A6 3F
	jsl.l $80ED0C		; $80EC2A: 22 0C ED 80
	jsl.l $8F852E		; $80EC2E: 22 2E 85 8F
	bra CODE_80EC6A		; $80EC32: 80 36
CODE_80EC34:		; M=16 X=16
	lda.w #$0000		; $80EC34: A9 00 00
	sta.b [$33]		; $80EC37: 87 33
	lda.w $128E		; $80EC39: AD 8E 12
	beq CODE_80EC41		; $80EC3C: F0 03
	jmp.w $EA72		; $80EC3E: 4C 72 EA
CODE_80EC41:		; M=16 X=16
	jsl.l $80ED0C		; $80EC41: 22 0C ED 80
	bra CODE_80EC6A		; $80EC45: 80 23
CODE_80EC47:		; M=16 X=16
	stz.b $3B		; $80EC47: 64 3B
	jsl.l $80EC89		; $80EC49: 22 89 EC 80
	lda.w #$0002		; $80EC4D: A9 02 00
	sta.b $3B		; $80EC50: 85 3B
	jsl.l $80EC89		; $80EC52: 22 89 EC 80
	lda.w #$0004		; $80EC56: A9 04 00
	trb.w $1288		; $80EC59: 1C 88 12
	ldx.w #$001C		; $80EC5C: A2 1C 00
	stx.b $3F		; $80EC5F: 86 3F
	lda.w #$001B		; $80EC61: A9 1B 00
	sta.b $53		; $80EC64: 85 53
	jsl.l $80B4A7		; $80EC66: 22 A7 B4 80
CODE_80EC6A:		; M=16 X=16
	stx.b $0A		; $80EC6A: 86 0A
	ldx.w #$000E		; $80EC6C: A2 0E 00
CODE_80EC6F:		; M=16 X=16
	pla		; $80EC6F: 68
	sta.b $33,x		; $80EC70: 95 33
	dex		; $80EC72: CA
	dex		; $80EC73: CA
	bpl CODE_80EC6F		; $80EC74: 10 F9
	ldx.b $0A		; $80EC76: A6 0A
	stx.b $0A		; $80EC78: 86 0A
	ldx.w #$0002		; $80EC7A: A2 02 00
CODE_80EC7D:		; M=16 X=16
	pla		; $80EC7D: 68
	sta.b $53,x		; $80EC7E: 95 53
	dex		; $80EC80: CA
	dex		; $80EC81: CA
	bpl CODE_80EC7D		; $80EC82: 10 F9
	ldx.b $0A		; $80EC84: A6 0A
	ldx.b $3F		; $80EC86: A6 3F
CODE_80EC88:		; M=16 X=16
	rtl		; $80EC88: 6B
CODE_80EC89:		; M=16 X=16
	lda.w #$0006		; $80EC89: A9 06 00
	sta.b $57		; $80EC8C: 85 57
	lda.w #$0032		; $80EC8E: A9 32 00
	sta.b $53		; $80EC91: 85 53
CODE_80EC93:		; M=16 X=16
	lda.b $3B		; $80EC93: A5 3B
	beq CODE_80EC9A		; $80EC95: F0 03
	lda.w #$0034		; $80EC97: A9 34 00
CODE_80EC9A:		; M=16 X=16
	clc		; $80EC9A: 18
	adc.b $53		; $80EC9B: 65 53
	tay		; $80EC9D: A8
	lda.w $14E2,y		; $80EC9E: B9 E2 14
	bmi CODE_80ECB9		; $80ECA1: 30 16
	beq CODE_80ECB9		; $80ECA3: F0 14
	and.w #$DFFF		; $80ECA5: 29 FF DF
	sta.w $14E2,y		; $80ECA8: 99 E2 14
	bit.w #$5000		; $80ECAB: 89 00 50
	bne CODE_80ECB9		; $80ECAE: D0 09
	lda.b $57		; $80ECB0: A5 57
	cmp.w #$0004		; $80ECB2: C9 04 00
	beq CODE_80ECB9		; $80ECB5: F0 02
	dec.b $57		; $80ECB7: C6 57
CODE_80ECB9:		; M=16 X=16
	dec.b $53		; $80ECB9: C6 53
	dec.b $53		; $80ECBB: C6 53
	bpl CODE_80EC93		; $80ECBD: 10 D4
	ldy.b $3B		; $80ECBF: A4 3B
	lda.b $57		; $80ECC1: A5 57
	sta.w $13EE,y		; $80ECC3: 99 EE 13
	rtl		; $80ECC6: 6B
CODE_80ECC7:		; M=16 X=16
	lda.w $12EA		; $80ECC7: AD EA 12
	bmi CODE_80ED0B		; $80ECCA: 30 3F
	sec		; $80ECCC: 38
	sbc.b $6F		; $80ECCD: E5 6F
	sta.w $12EA		; $80ECCF: 8D EA 12
	bpl CODE_80ECD8		; $80ECD2: 10 04
	jsl.l $82F93C		; $80ECD4: 22 3C F9 82
CODE_80ECD8:		; M=16 X=16
	lda.w $12E8		; $80ECD8: AD E8 12
	sec		; $80ECDB: 38
	sbc.b $6F		; $80ECDC: E5 6F
	sta.w $12E8		; $80ECDE: 8D E8 12
	bpl CODE_80ED0B		; $80ECE1: 10 28
	lda.w #$7FFF		; $80ECE3: A9 FF 7F
	sta.w $12E8		; $80ECE6: 8D E8 12
	jsl.l $82FD95		; $80ECE9: 22 95 FD 82
	jsl.l $80B90C		; $80ECED: 22 0C B9 80
	ora.b $00		; $80ECF1: 05 00
	lda.l $220B11,x		; $80ECF3: BF 11 0B 22
	ora.b $86		; $80ECF7: 05 86
	sta.w $37A7		; $80ECF9: 8D A7 37
	lsr a		; $80ECFC: 4A
	sta.b $53		; $80ECFD: 85 53
	lda.w $047B		; $80ECFF: AD 7B 04
	sec		; $80ED02: 38
	sbc.b $53		; $80ED03: E5 53
	sta.w $047B		; $80ED05: 8D 7B 04
	jmp.w $B92D		; $80ED08: 4C 2D B9
CODE_80ED0B:		; M=16 X=16
	rtl		; $80ED0B: 6B
CODE_80ED0C:		; M=16 X=16
	lda.b $53		; $80ED0C: A5 53
	sta.w $12EE		; $80ED0E: 8D EE 12
	stz.w $12EC		; $80ED11: 9C EC 12
	jsl.l $8FF63D		; $80ED14: 22 3D F6 8F
	lda.b $53		; $80ED18: A5 53
	cmp.w #$000E		; $80ED1A: C9 0E 00
	bne CODE_80ED23		; $80ED1D: D0 04
	jsl.l $8FFEB4		; $80ED1F: 22 B4 FE 8F
CODE_80ED23:		; M=16 X=16
	lda.w #$7FFF		; $80ED23: A9 FF 7F
	sta.w $12E8		; $80ED26: 8D E8 12
	lda.w $128E		; $80ED29: AD 8E 12
	beq CODE_80ED34		; $80ED2C: F0 06
	lda.w #$003C		; $80ED2E: A9 3C 00
	sta.w $12E8		; $80ED31: 8D E8 12
CODE_80ED34:		; M=16 X=16
	jml.l $82F93C		; $80ED34: 5C 3C F9 82
	db $20,$09,$0C,$01,$0C,$02,$0C,$03,$0C,$04,$0C,$05,$DD,$0A,$06,$0C	; $80ED38
	db $07,$0C,$08,$0C,$09,$0C,$0A,$0C,$0B,$30,$0C,$02,$0D,$0C,$0E,$80	; $80ED48
	db $10,$0A,$0F,$0C,$10,$0C,$11,$0C,$12,$0C,$13,$0C,$14,$82,$10,$0A	; $80ED58
	db $15,$0C,$16,$0C,$17,$0C,$18,$0C,$19,$0C,$1A,$82,$10,$0A,$1B,$0C	; $80ED68
	db $1C,$0C,$1D,$0C,$1E,$0C,$1F,$0C,$20,$82,$10,$0A,$21,$0C,$22,$0C	; $80ED78
	db $23,$0C,$24,$0C,$25,$0C,$26,$80,$10,$1A,$27,$0C,$28,$0C,$29,$0C	; $80ED88
	db $2A,$0C,$2B,$0C,$2C,$0C,$2D,$0C,$2E,$0C,$2F,$0C,$30,$0C,$31,$0C	; $80ED98
	db $32,$0C,$33,$0C,$34,$DD,$0C,$35,$0C,$36,$0C,$37,$0C,$38,$0C,$39	; $80EDA8
	db $0C,$3A,$0C,$3B,$DD,$05,$3C,$0C,$F2,$7F,$E4,$7F,$21,$0F,$84,$10	; $80EDB8
	db $29,$25,$AD,$35,$52,$4A,$D6,$5A,$7B,$6F,$FF,$7F,$FF,$03,$20,$00	; $80EDC8
	db $7C,$20,$00,$6C,$20,$00,$58,$20,$00,$48,$20,$0E,$34,$F2,$7F,$7B	; $80EDD8
	db $6F,$52,$4A,$29,$25,$84,$10,$5B,$02,$B6,$01,$21,$00,$84,$80,$14	; $80EDE8
	db $02,$24,$01,$80,$20,$02,$36,$01,$0D,$20,$0D,$B6,$35,$2D,$11,$F2	; $80EDF8
	db $7F,$FF,$7F,$D6,$5A,$52,$4A,$AD,$35,$81,$24,$21,$01,$84,$34,$20	; $80EE08
	db $0A,$24,$80,$24,$4D,$5A,$CD,$6E,$6D,$7F,$3F,$25,$20,$01,$10,$F2	; $80EE18
	db $80,$5E,$81,$5C,$83,$5A,$02,$20,$49,$09,$20,$00,$0D,$20,$00,$12	; $80EE28
	db $20,$00,$96,$20,$08,$3B,$11,$5B,$36,$DF,$4A,$7F,$5B,$ED,$80,$20	; $80EE38
	db $9C,$80,$BB,$BF,$20,$06,$FF,$7F,$80,$40,$80,$5F,$9F,$4E,$00,$FF	; $80EE48
	db $20,$8B,$02,$50,$59,$61,$47,$9B,$1F,$05,$FE,$FC,$F8,$F0,$E2,$C1	; $80EE58
	db $87,$1A,$05,$FC,$01,$F0,$07,$C0,$1E,$84,$20,$07,$C0,$C0,$39,$38	; $80EE68
	db $FF,$8A,$8C,$38,$DD,$4A,$00,$C0,$21,$00,$06,$21,$01,$70,$03,$20	; $80EE78
	db $00,$3F,$84,$20,$05,$3F,$CF,$03,$BB,$03,$7F,$86,$3C,$E0,$17,$02	; $80EE88
	db $F0,$03,$C4,$20,$00,$80,$E4,$59,$86,$80,$01,$1F,$5F,$8B,$7E,$07	; $80EE98
	db $1F,$A0,$01,$FE,$FD,$02,$05,$06,$CC,$4E,$00,$FE,$20,$00,$FC,$20	; $80EEA8
	db $00,$F8,$88,$02,$87,$DA,$8F,$E0,$E6,$C8,$02,$FE,$FE,$FC,$4A,$03	; $80EEB8
	db $FF,$F8,$FF,$F0,$81,$14,$80,$44,$00,$01,$4A,$00,$F8,$20,$00,$F0	; $80EEC8
	db $20,$02,$C4,$83,$87,$20,$00,$07,$20,$00,$3E,$20,$09,$E5,$03,$C6	; $80EED8
	db $20,$BF,$20,$30,$4F,$80,$3C,$20,$00,$7F,$80,$57,$00,$C1,$20,$07	; $80EEE8
	db $1F,$1F,$3F,$1F,$7F,$3F,$FF,$EC,$20,$00,$5F,$20,$04,$82,$01,$98	; $80EEF8
	db $78,$07,$80,$38,$02,$F2,$3F,$63,$60,$00,$F3,$20,$00,$A0,$20,$01	; $80EF08
	db $7F,$07,$33,$FF,$03,$F3,$FF,$E3,$0E,$20,$04,$10,$09,$01,$01,$F4	; $80EF18
	db $20,$07,$FA,$04,$85,$7A,$05,$FA,$FB,$FC,$20,$02,$FF,$06,$FF,$E3	; $80EF28
	db $6F,$44,$1C,$9F,$07,$5F,$03,$07,$9B,$B7,$89,$1B,$45,$5B,$64,$9F	; $80EF38
	db $20,$AD,$22,$07,$60,$03,$A0,$03,$E0,$01,$C0,$81,$E0,$80,$E0,$C0	; $80EF48
	db $48,$00,$F0,$3C,$FF,$00,$7F,$8B,$BE,$00,$7F,$20,$87,$FA,$4C,$89	; $80EF58
	db $FC,$4A,$80,$D2,$8A,$02,$00,$F0,$80,$D4,$89,$02,$00,$3F,$20,$02	; $80EF68
	db $9F,$40,$5F,$80,$C4,$0A,$5E,$01,$1F,$40,$59,$46,$7C,$47,$7F,$FF	; $80EF78
	db $3F,$89,$02,$03,$FC,$C0,$FF,$80,$80,$74,$04,$FC,$03,$31,$CF,$8F	; $80EF88
	db $DC,$01,$7F,$FF,$E0,$0D,$3B,$FF,$0A,$F3,$FC,$8F,$70,$F8,$07,$02	; $80EF98
	db $FF,$E6,$FF,$0C,$E0,$D5,$00,$C0,$20,$36,$FF,$02,$E7,$FF,$0F,$72	; $80EFA8
	db $00,$DF,$20,$00,$D7,$49,$02,$57,$80,$97,$20,$02,$87,$10,$CF,$CC	; $80EFB8
	db $04,$08,$E0,$F0,$E0,$F8,$4E,$00,$F0,$49,$80,$D2,$8A,$73,$00,$7F	; $80EFC8
	db $80,$D4,$00,$3F,$88,$02,$85,$B8,$03,$F9,$FC,$F8,$FD,$C8,$40,$84	; $80EFD8
	db $B8,$01,$06,$FA,$48,$00,$07,$4A,$00,$B0,$20,$17,$A4,$08,$B6,$18	; $80EFE8
	db $ED,$86,$70,$04,$B0,$80,$7F,$C0,$BF,$CF,$7F,$FF,$70,$FF,$67,$FF	; $80EFF8
