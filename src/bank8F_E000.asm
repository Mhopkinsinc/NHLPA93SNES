; $8FE00E-$8FEFFF  ROM $7E00E  (from src/bank8F.asm; quick pass, TODO segment agents refine)
org $8FE00E
	db $64,$3B,$A9,$02,$00,$85,$3F,$22,$20,$E0,$8F,$64,$3F,$A9,$02,$00	; $8FE00E
	db $85,$3B,$22,$D1,$FE,$80,$A6,$3F,$A4,$3B,$9E,$DE,$13,$AD,$0C,$16	; $8FE01E
	db $D0,$1B,$BD,$EE,$13,$38,$F9,$EE,$13,$85,$53,$F0,$10,$A9,$03,$00	; $8FE02E
	db $9D,$DE,$13,$A5,$53,$10,$06,$A9,$05,$00,$9D,$DE,$13,$6B	; $8FE03E
CODE_8FE04C:		; M=16 X=16
	clc		; $8FE04C: 18
	ldx.w #$0000		; $8FE04D: A2 00 00
	ldy.w #$0008		; $8FE050: A0 08 00
CODE_8FE053:		; M=16 X=16
	lda.w #$E0E0		; $8FE053: A9 E0 E0
	sta.w $01FF,x		; $8FE056: 9D FF 01
	stz.w $0201,x		; $8FE059: 9E 01 02
	sta.w $0203,x		; $8FE05C: 9D 03 02
	stz.w $0205,x		; $8FE05F: 9E 05 02
	sta.w $0207,x		; $8FE062: 9D 07 02
	stz.w $0209,x		; $8FE065: 9E 09 02
	sta.w $020B,x		; $8FE068: 9D 0B 02
	stz.w $020D,x		; $8FE06B: 9E 0D 02
	sta.w $020F,x		; $8FE06E: 9D 0F 02
	stz.w $0211,x		; $8FE071: 9E 11 02
	sta.w $0213,x		; $8FE074: 9D 13 02
	stz.w $0215,x		; $8FE077: 9E 15 02
	sta.w $0217,x		; $8FE07A: 9D 17 02
	stz.w $0219,x		; $8FE07D: 9E 19 02
	sta.w $021B,x		; $8FE080: 9D 1B 02
	stz.w $021D,x		; $8FE083: 9E 1D 02
	sta.w $021F,x		; $8FE086: 9D 1F 02
	stz.w $0221,x		; $8FE089: 9E 21 02
	sta.w $0223,x		; $8FE08C: 9D 23 02
	stz.w $0225,x		; $8FE08F: 9E 25 02
	sta.w $0227,x		; $8FE092: 9D 27 02
	stz.w $0229,x		; $8FE095: 9E 29 02
	sta.w $022B,x		; $8FE098: 9D 2B 02
	stz.w $022D,x		; $8FE09B: 9E 2D 02
	sta.w $022F,x		; $8FE09E: 9D 2F 02
	stz.w $0231,x		; $8FE0A1: 9E 31 02
	sta.w $0233,x		; $8FE0A4: 9D 33 02
	stz.w $0235,x		; $8FE0A7: 9E 35 02
	sta.w $0237,x		; $8FE0AA: 9D 37 02
	stz.w $0239,x		; $8FE0AD: 9E 39 02
	sta.w $023B,x		; $8FE0B0: 9D 3B 02
	stz.w $023D,x		; $8FE0B3: 9E 3D 02
	txa		; $8FE0B6: 8A
	adc.w #$0040		; $8FE0B7: 69 40 00
	tax		; $8FE0BA: AA
	dey		; $8FE0BB: 88
	bne CODE_8FE053		; $8FE0BC: D0 95
CODE_8FE0BE:		; M=16 X=16
	stz.w $01FF,x		; $8FE0BE: 9E FF 01
	inx		; $8FE0C1: E8
	inx		; $8FE0C2: E8
	cpx.w #$0220		; $8FE0C3: E0 20 02
	bne CODE_8FE0BE		; $8FE0C6: D0 F6
	stz.b $A9		; $8FE0C8: 64 A9
	inc.b $A7		; $8FE0CA: E6 A7
	lda.b $C7		; $8FE0CC: A5 C7
	beq CODE_8FE0DB		; $8FE0CE: F0 0B
	stz.b $C7		; $8FE0D0: 64 C7
	lda.b $C1		; $8FE0D2: A5 C1
	cmp.w #$0003		; $8FE0D4: C9 03 00
	bcc CODE_8FE0DB		; $8FE0D7: 90 02
	dec.b $C1		; $8FE0D9: C6 C1
CODE_8FE0DB:		; M=16 X=16
	lda.b $B1		; $8FE0DB: A5 B1
	sta.b $B3		; $8FE0DD: 85 B3
	lda.b $B5		; $8FE0DF: A5 B5
	sta.b $B7		; $8FE0E1: 85 B7
	rtl		; $8FE0E3: 6B
CODE_8FE0E4:		; M=16 X=16
	lda.w #$000E		; $8FE0E4: A9 0E 00
	sta.b $78		; $8FE0E7: 85 78
CODE_8FE0E9:		; M=16 X=16
	rep #$30		; $8FE0E9: C2 30
	ldy.b $78		; $8FE0EB: A4 78
	lda.b [$33],y		; $8FE0ED: B7 33
	sta.b $73		; $8FE0EF: 85 73
	tya		; $8FE0F1: 98
	clc		; $8FE0F2: 18
	adc.w #$0010		; $8FE0F3: 69 10 00
	tay		; $8FE0F6: A8
	lda.b [$33],y		; $8FE0F7: B7 33
	sta.b $75		; $8FE0F9: 85 75
	sep #$30		; $8FE0FB: E2 30
	ldx.b $78		; $8FE0FD: A6 78
	lda.b #$07		; $8FE0FF: A9 07
	sta.b $77		; $8FE101: 85 77
CODE_8FE103:		; M=8 X=8
	ldy.b #$00		; $8FE103: A0 00
	asl.b $76		; $8FE105: 06 76
	bcc CODE_8FE10B		; $8FE107: 90 02
	ldy.b #$08		; $8FE109: A0 08
CODE_8FE10B:		; M=8 X=8
	asl.b $75		; $8FE10B: 06 75
	bcc CODE_8FE113		; $8FE10D: 90 04
	iny		; $8FE10F: C8
	iny		; $8FE110: C8
	iny		; $8FE111: C8
	iny		; $8FE112: C8
CODE_8FE113:		; M=8 X=8
	asl.b $74		; $8FE113: 06 74
	bcc CODE_8FE119		; $8FE115: 90 02
	iny		; $8FE117: C8
	iny		; $8FE118: C8
CODE_8FE119:		; M=8 X=8
	asl.b $73		; $8FE119: 06 73
	bcc CODE_8FE11E		; $8FE11B: 90 01
	iny		; $8FE11D: C8
CODE_8FE11E:		; M=8 X=8
	lda.b [$37],y		; $8FE11E: B7 37
	lsr a		; $8FE120: 4A
	rol.b $7D,x		; $8FE121: 36 7D
	lsr a		; $8FE123: 4A
	rol.b $7E,x		; $8FE124: 36 7E
	lsr a		; $8FE126: 4A
	rol.b $8D,x		; $8FE127: 36 8D
	lsr a		; $8FE129: 4A
	rol.b $8E,x		; $8FE12A: 36 8E
	dec.b $77		; $8FE12C: C6 77
	bpl CODE_8FE103		; $8FE12E: 10 D3
	dec.b $78		; $8FE130: C6 78
	dec.b $78		; $8FE132: C6 78
	bpl CODE_8FE0E9		; $8FE134: 10 B3
	rep #$30		; $8FE136: C2 30
	ldx.w #$0000		; $8FE138: A2 00 00
CODE_8FE13B:		; M=16 X=16
	lda.b $7D,x		; $8FE13B: B5 7D
	sta.w $2118		; $8FE13D: 8D 18 21
	inx		; $8FE140: E8
	inx		; $8FE141: E8
	cpx.w #$0020		; $8FE142: E0 20 00
	bne CODE_8FE13B		; $8FE145: D0 F4
	lda.b $33		; $8FE147: A5 33
	clc		; $8FE149: 18
	adc.w #$0020		; $8FE14A: 69 20 00
	sta.b $33		; $8FE14D: 85 33
	dec.b $53		; $8FE14F: C6 53
	bne CODE_8FE0E4		; $8FE151: D0 91
	rtl		; $8FE153: 6B
	db $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FE154
CODE_8FE164:		; M=16 X=16
	asl.b $5B		; $8FE164: 06 5B
	asl.b $5B		; $8FE166: 06 5B
	ldx.b $5B		; $8FE168: A6 5B
	lda.l $8FE2DB,x		; $8FE16A: BF DB E2 8F
	sta.b $7D		; $8FE16E: 85 7D
	lda.b $6F		; $8FE170: A5 6F
	sta.b $83		; $8FE172: 85 83
	jsl.l $808496		; $8FE174: 22 96 84 80
	lsr a		; $8FE178: 4A
	lsr a		; $8FE179: 4A
	bit.w #$2000		; $8FE17A: 89 00 20
	beq CODE_8FE182		; $8FE17D: F0 03
	ora.w #$C000		; $8FE17F: 09 00 C0
CODE_8FE182:		; M=16 X=16
	sta.b $57		; $8FE182: 85 57
	lda.l $8FE2D9,x		; $8FE184: BF D9 E2 8F
	sta.b $7D		; $8FE188: 85 7D
	lda.b $6F		; $8FE18A: A5 6F
	sta.b $83		; $8FE18C: 85 83
	jsl.l $808496		; $8FE18E: 22 96 84 80
	lsr a		; $8FE192: 4A
	lsr a		; $8FE193: 4A
	bit.w #$2000		; $8FE194: 89 00 20
	beq CODE_8FE19C		; $8FE197: F0 03
	ora.w #$C000		; $8FE199: 09 00 C0
CODE_8FE19C:		; M=16 X=16
	sta.b $53		; $8FE19C: 85 53
	ldx.b $3F		; $8FE19E: A6 3F
	lda.w $0D7F,x		; $8FE1A0: BD 7F 0D
	beq CODE_8FE1AB		; $8FE1A3: F0 06
	eor.b $53		; $8FE1A5: 45 53
	bpl CODE_8FE1AB		; $8FE1A7: 10 02
	stz.b $53		; $8FE1A9: 64 53
CODE_8FE1AB:		; M=16 X=16
	lda.w $0D5F,x		; $8FE1AB: BD 5F 0D
	beq CODE_8FE1B6		; $8FE1AE: F0 06
	eor.b $57		; $8FE1B0: 45 57
	bmi CODE_8FE1B6		; $8FE1B2: 30 02
	stz.b $57		; $8FE1B4: 64 57
CODE_8FE1B6:		; M=16 X=16
	lda.w $0F3F,x		; $8FE1B6: BD 3F 0F
	lsr a		; $8FE1B9: 4A
	lsr a		; $8FE1BA: 4A
	lsr a		; $8FE1BB: 4A
	lsr a		; $8FE1BC: 4A
	eor.w #$FFFF		; $8FE1BD: 49 FF FF
	inc a		; $8FE1C0: 1A
	clc		; $8FE1C1: 18
	adc.w #$0020		; $8FE1C2: 69 20 00
	clc		; $8FE1C5: 18
	adc.w $0F5F,x		; $8FE1C6: 7D 5F 0F
	sta.b $5B		; $8FE1C9: 85 5B
	lda.w $0B9F,x		; $8FE1CB: BD 9F 0B
	bne CODE_8FE1DC		; $8FE1CE: D0 0C
	lda.b $5B		; $8FE1D0: A5 5B
	clc		; $8FE1D2: 18
	adc.w $0F5F,x		; $8FE1D3: 7D 5F 0F
	clc		; $8FE1D6: 18
	adc.w #$0008		; $8FE1D7: 69 08 00
	sta.b $5B		; $8FE1DA: 85 5B
CODE_8FE1DC:		; M=16 X=16
	lda.b $5B		; $8FE1DC: A5 5B
	pha		; $8FE1DE: 48
	sta.b $7D		; $8FE1DF: 85 7D
	lda.b $53		; $8FE1E1: A5 53
	sta.b $83		; $8FE1E3: 85 83
	jsl.l $82FCDB		; $8FE1E5: 22 DB FC 82
	lsr.b $95		; $8FE1E9: 46 95
	ror a		; $8FE1EB: 6A
	lsr.b $95		; $8FE1EC: 46 95
	ror a		; $8FE1EE: 6A
	lsr.b $95		; $8FE1EF: 46 95
	ror a		; $8FE1F1: 6A
	lsr.b $95		; $8FE1F2: 46 95
	ror a		; $8FE1F4: 6A
	lsr.b $95		; $8FE1F5: 46 95
	ror a		; $8FE1F7: 6A
	sta.b $7D		; $8FE1F8: 85 7D
	lda.b $6F		; $8FE1FA: A5 6F
	sta.b $83		; $8FE1FC: 85 83
	jsl.l $808496		; $8FE1FE: 22 96 84 80
	adc.w $0ADF,x		; $8FE202: 7D DF 0A
	sta.b $53		; $8FE205: 85 53
	sta.b $7D		; $8FE207: 85 7D
	sta.b $83		; $8FE209: 85 83
	jsl.l $82FCDB		; $8FE20B: 22 DB FC 82
	sta.b $5B		; $8FE20F: 85 5B
	lda.b $95		; $8FE211: A5 95
	sta.b $5D		; $8FE213: 85 5D
	pla		; $8FE215: 68
	sta.b $7D		; $8FE216: 85 7D
	lda.b $57		; $8FE218: A5 57
	sta.b $83		; $8FE21A: 85 83
	jsl.l $82FCDB		; $8FE21C: 22 DB FC 82
	lsr.b $95		; $8FE220: 46 95
	ror a		; $8FE222: 6A
	lsr.b $95		; $8FE223: 46 95
	ror a		; $8FE225: 6A
	lsr.b $95		; $8FE226: 46 95
	ror a		; $8FE228: 6A
	lsr.b $95		; $8FE229: 46 95
	ror a		; $8FE22B: 6A
	lsr.b $95		; $8FE22C: 46 95
	ror a		; $8FE22E: 6A
	sta.b $7D		; $8FE22F: 85 7D
	lda.b $6F		; $8FE231: A5 6F
	sta.b $83		; $8FE233: 85 83
	jsl.l $808496		; $8FE235: 22 96 84 80
	adc.w $0AFF,x		; $8FE239: 7D FF 0A
	sta.b $57		; $8FE23C: 85 57
	sta.b $7D		; $8FE23E: 85 7D
	sta.b $83		; $8FE240: 85 83
	jsl.l $82FCDB		; $8FE242: 22 DB FC 82
	adc.b $5B		; $8FE246: 65 5B
	sta.b $5F		; $8FE248: 85 5F
	lda.b $95		; $8FE24A: A5 95
	adc.b $5D		; $8FE24C: 65 5D
	sta.b $61		; $8FE24E: 85 61
	lda.b $57		; $8FE250: A5 57
	pha		; $8FE252: 48
	lda.b $53		; $8FE253: A5 53
	pha		; $8FE255: 48
	jsl.l $8084C4		; $8FE256: 22 C4 84 80
	lda.w $0F7F,x		; $8FE25A: BD 7F 0F
	sta.b $7D		; $8FE25D: 85 7D
	lda.b $53		; $8FE25F: A5 53
	lsr a		; $8FE261: 4A
	clc		; $8FE262: 18
	adc.w #$0800		; $8FE263: 69 00 08
	sta.b $83		; $8FE266: 85 83
	jsl.l $888942		; $8FE268: 22 42 89 88
	asl a		; $8FE26C: 0A
	rol.b $95		; $8FE26D: 26 95
	asl a		; $8FE26F: 0A
	rol.b $95		; $8FE270: 26 95
	asl a		; $8FE272: 0A
	rol.b $95		; $8FE273: 26 95
	asl a		; $8FE275: 0A
	rol.b $95		; $8FE276: 26 95
	lda.b $95		; $8FE278: A5 95
	asl a		; $8FE27A: 0A
	asl a		; $8FE27B: 0A
	tax		; $8FE27C: AA
	lda.l $8084E7,x		; $8FE27D: BF E7 84 80
	sta.b $5B		; $8FE281: 85 5B
	lda.l $8084E9,x		; $8FE283: BF E9 84 80
	sta.b $5D		; $8FE287: 85 5D
	ldx.b $3F		; $8FE289: A6 3F
	pla		; $8FE28B: 68
	sta.b $53		; $8FE28C: 85 53
	pla		; $8FE28E: 68
	sta.b $57		; $8FE28F: 85 57
	lda.b $5B		; $8FE291: A5 5B
	cmp.b $5F		; $8FE293: C5 5F
	lda.b $5D		; $8FE295: A5 5D
	sbc.b $61		; $8FE297: E5 61
	bcc CODE_8FE2A5		; $8FE299: 90 0A
	lda.b $53		; $8FE29B: A5 53
	sta.w $0ADF,x		; $8FE29D: 9D DF 0A
	lda.b $57		; $8FE2A0: A5 57
	sta.w $0AFF,x		; $8FE2A2: 9D FF 0A
CODE_8FE2A5:		; M=16 X=16
	lda.w $160C		; $8FE2A5: AD 0C 16
	bne CODE_8FE2D8		; $8FE2A8: D0 2E
	lda.w $04A1		; $8FE2AA: AD A1 04
	and.w #$003F		; $8FE2AD: 29 3F 00
	bne CODE_8FE2D8		; $8FE2B0: D0 26
	jsl.l $8084C4		; $8FE2B2: 22 C4 84 80
	lda.b $53		; $8FE2B6: A5 53
	sec		; $8FE2B8: 38
	sbc.w #$0021		; $8FE2B9: E9 21 00
	sta.b $53		; $8FE2BC: 85 53
	sec		; $8FE2BE: 38
	sbc.w #$0C00		; $8FE2BF: E9 00 0C
	bmi CODE_8FE2C9		; $8FE2C2: 30 05
	bvc CODE_8FE2CB		; $8FE2C4: 50 05
CODE_8FE2C6:		; M=16 X=16
	jmp.w $EE6B		; $8FE2C6: 4C 6B EE
CODE_8FE2C9:		; M=16 X=16
	bvc CODE_8FE2C6		; $8FE2C9: 50 FB
CODE_8FE2CB:		; M=16 X=16
	lda.w $109F,x		; $8FE2CB: BD 9F 10
	sta.b $5B		; $8FE2CE: 85 5B
	clc		; $8FE2D0: 18
	adc.b $53		; $8FE2D1: 65 53
	sta.b $53		; $8FE2D3: 85 53
	jmp.w $EE6B		; $8FE2D5: 4C 6B EE
CODE_8FE2D8:		; M=16 X=16
	rtl		; $8FE2D8: 6B
	db $00,$00,$20,$03,$35,$02,$35,$02,$20,$03,$00,$00,$35,$02,$CB,$FD	; $8FE2D9
	db $00,$00,$E0,$FC,$CB,$FD,$CB,$FD,$E0,$FC,$00,$00,$CB,$FD,$35,$02	; $8FE2E9
CODE_8FE2F9:		; M=16 X=16
	lda.w #$001F		; $8FE2F9: A9 1F 00
	sta.b $53		; $8FE2FC: 85 53
	lda.w #$129E		; $8FE2FE: A9 9E 12
	sta.b $33		; $8FE301: 85 33
	lda.w #$0000		; $8FE303: A9 00 00
	sta.b $35		; $8FE306: 85 35
CODE_8FE308:		; M=16 X=16
	lda.w #$0000		; $8FE308: A9 00 00
	sta.b [$33]		; $8FE30B: 87 33
	inc.b $33		; $8FE30D: E6 33
	inc.b $33		; $8FE30F: E6 33
	dec.b $53		; $8FE311: C6 53
	bpl CODE_8FE308		; $8FE313: 10 F3
	rtl		; $8FE315: 6B
CODE_8FE316:		; M=16 X=16
	lda.b $53		; $8FE316: A5 53
	pha		; $8FE318: 48
	asl.b $53		; $8FE319: 06 53
	jsl.l $8097A3		; $8FE31B: 22 A3 97 80
	pla		; $8FE31F: 68
	eor.w #$FFFF		; $8FE320: 49 FF FF
	inc a		; $8FE323: 1A
	clc		; $8FE324: 18
	adc.b $53		; $8FE325: 65 53
	sta.b $53		; $8FE327: 85 53
	clc		; $8FE329: 18
	rtl		; $8FE32A: 6B
CODE_8FE32B:		; M=16 X=16
	lda.w #$FFFF		; $8FE32B: A9 FF FF
	sta.w $160E		; $8FE32E: 8D 0E 16
	lda.w #$1600		; $8FE331: A9 00 16
	sta.b $33		; $8FE334: 85 33
	lda.w #$0000		; $8FE336: A9 00 00
	sta.b $35		; $8FE339: 85 35
	lda.w #$E35B		; $8FE33B: A9 5B E3
	sta.b $37		; $8FE33E: 85 37
	lda.w #$008F		; $8FE340: A9 8F 00
	sta.b $39		; $8FE343: 85 39
	lda.w #$0006		; $8FE345: A9 06 00
	sta.b $53		; $8FE348: 85 53
CODE_8FE34A:		; M=16 X=16
	lda.b [$37]		; $8FE34A: A7 37
	inc.b $37		; $8FE34C: E6 37
	inc.b $37		; $8FE34E: E6 37
	sta.b [$33]		; $8FE350: 87 33
	inc.b $33		; $8FE352: E6 33
	inc.b $33		; $8FE354: E6 33
	dec.b $53		; $8FE356: C6 53
	bpl CODE_8FE34A		; $8FE358: 10 F0
	rtl		; $8FE35A: 6B
	db $00,$00,$01,$00,$0F,$00,$03,$00,$01,$00,$00,$00,$01,$00	; $8FE35B
CODE_8FE369:		; M=16 X=16
	lda.w #$0014		; $8FE369: A9 14 00
	sec		; $8FE36C: 38
	sbc.w $10BF,x		; $8FE36D: FD BF 10
	asl a		; $8FE370: 0A
	asl a		; $8FE371: 0A
	asl a		; $8FE372: 0A
	asl a		; $8FE373: 0A
	sta.b $53		; $8FE374: 85 53
	lda.w $0EDF,x		; $8FE376: BD DF 0E
	bit.w #$0008		; $8FE379: 89 08 00
	beq CODE_8FE380		; $8FE37C: F0 02
	asl.b $53		; $8FE37E: 06 53
CODE_8FE380:		; M=16 X=16
	lda.w $08FF,x		; $8FE380: BD FF 08
	sec		; $8FE383: 38
	sbc.w $091B		; $8FE384: ED 1B 09
	bit.w #$8000		; $8FE387: 89 00 80
	beq CODE_8FE390		; $8FE38A: F0 04
	eor.w #$FFFF		; $8FE38C: 49 FF FF
	inc a		; $8FE38F: 1A
CODE_8FE390:		; M=16 X=16
	cmp.w #$0029		; $8FE390: C9 29 00
	bcs CODE_8FE3AC		; $8FE393: B0 17
	lda.w $095F,x		; $8FE395: BD 5F 09
	sec		; $8FE398: 38
	sbc.w $097B		; $8FE399: ED 7B 09
	bit.w #$8000		; $8FE39C: 89 00 80
	beq CODE_8FE3A5		; $8FE39F: F0 04
	eor.w #$FFFF		; $8FE3A1: 49 FF FF
	inc a		; $8FE3A4: 1A
CODE_8FE3A5:		; M=16 X=16
	cmp.w #$0029		; $8FE3A5: C9 29 00
	bcs CODE_8FE3AC		; $8FE3A8: B0 02
	lsr.b $53		; $8FE3AA: 46 53
CODE_8FE3AC:		; M=16 X=16
	jml.l $8097A3		; $8FE3AC: 5C A3 97 80
CODE_8FE3B0:		; M=16 X=16
	lda.b $59		; $8FE3B0: A5 59
	pha		; $8FE3B2: 48
	lda.b $57		; $8FE3B3: A5 57
	pha		; $8FE3B5: 48
	lda.b $39		; $8FE3B6: A5 39
	pha		; $8FE3B8: 48
	lda.b $37		; $8FE3B9: A5 37
	pha		; $8FE3BB: 48
	lda.w #$041F		; $8FE3BC: A9 1F 04
	sta.b $37		; $8FE3BF: 85 37
	lda.w #$0000		; $8FE3C1: A9 00 00
	sta.b $39		; $8FE3C4: 85 39
	stz.b $57		; $8FE3C6: 64 57
	bra CODE_8FE3D5		; $8FE3C8: 80 0B
CODE_8FE3CA:		; M=16 X=16
	lda.b $57		; $8FE3CA: A5 57
	clc		; $8FE3CC: 18
	adc.b [$37]		; $8FE3CD: 67 37
	sta.b $57		; $8FE3CF: 85 57
	inc.b $37		; $8FE3D1: E6 37
	inc.b $37		; $8FE3D3: E6 37
CODE_8FE3D5:		; M=16 X=16
	dec.b $53		; $8FE3D5: C6 53
	bpl CODE_8FE3CA		; $8FE3D7: 10 F1
	lda.b $57		; $8FE3D9: A5 57
	sta.b $53		; $8FE3DB: 85 53
	jsl.l $8097A3		; $8FE3DD: 22 A3 97 80
CODE_8FE3E1:		; M=16 X=16
	dec.b $37		; $8FE3E1: C6 37
	dec.b $37		; $8FE3E3: C6 37
	lda.b $53		; $8FE3E5: A5 53
	sec		; $8FE3E7: 38
	sbc.b [$37]		; $8FE3E8: E7 37
	sta.b $53		; $8FE3EA: 85 53
	bpl CODE_8FE3E1		; $8FE3EC: 10 F3
	lda.b $37		; $8FE3EE: A5 37
	sec		; $8FE3F0: 38
	sbc.w #$041F		; $8FE3F1: E9 1F 04
	lsr a		; $8FE3F4: 4A
	sta.b $53		; $8FE3F5: 85 53
	pla		; $8FE3F7: 68
	sta.b $37		; $8FE3F8: 85 37
	pla		; $8FE3FA: 68
	sta.b $39		; $8FE3FB: 85 39
	pla		; $8FE3FD: 68
	sta.b $57		; $8FE3FE: 85 57
	pla		; $8FE400: 68
	sta.b $59		; $8FE401: 85 59
	rtl		; $8FE403: 6B
CODE_8FE404:		; M=16 X=16
	phx		; $8FE404: DA
	lda.w #$80CE		; $8FE405: A9 CE 80
	sta.b $14		; $8FE408: 85 14
	lda.w #$83A3		; $8FE40A: A9 A3 83
	sta.b $16		; $8FE40D: 85 16
	lda.b $00		; $8FE40F: A5 00
	pha		; $8FE411: 48
	lda.b $A7		; $8FE412: A5 A7
	sec		; $8FE414: 38
	sbc.w #$003C		; $8FE415: E9 3C 00
	ldx.w #$0000		; $8FE418: A2 00 00
CODE_8FE41B:		; M=16 X=16
	sta.l $7E2000,x		; $8FE41B: 9F 00 20 7E
	inx		; $8FE41F: E8
	inx		; $8FE420: E8
	cpx.w #$4C74		; $8FE421: E0 74 4C
	bne CODE_8FE41B		; $8FE424: D0 F5
	ldx.w #$0000		; $8FE426: A2 00 00
CODE_8FE429:		; M=16 X=16
	sta.w $04AB,x		; $8FE429: 9D AB 04
	inx		; $8FE42C: E8
	inx		; $8FE42D: E8
	cpx.w #$0400		; $8FE42E: E0 00 04
	bne CODE_8FE429		; $8FE431: D0 F6
	pla		; $8FE433: 68
CODE_8FE434:		; M=16 X=16
	cmp.b $00		; $8FE434: C5 00
	beq CODE_8FE434		; $8FE436: F0 FC
	stz.b $A3		; $8FE438: 64 A3
	plx		; $8FE43A: FA
	rtl		; $8FE43B: 6B
CODE_8FE43C:		; M=16 X=16
	lda.b $5B		; $8FE43C: A5 5B
	bit.w #$8000		; $8FE43E: 89 00 80
	bne CODE_8FE458		; $8FE441: D0 15
	lda.b $53		; $8FE443: A5 53
	bit.w #$0008		; $8FE445: 89 08 00
	bne CODE_8FE457		; $8FE448: D0 0D
	and.w #$0007		; $8FE44A: 29 07 00
	sta.w $043B		; $8FE44D: 8D 3B 04
	ora.w #$0008		; $8FE450: 09 08 00
	sta.b $53		; $8FE453: 85 53
	bra CODE_8FE458		; $8FE455: 80 01
CODE_8FE457:		; M=16 X=16
	rtl		; $8FE457: 6B
CODE_8FE458:		; M=16 X=16
	stx.b $0A		; $8FE458: 86 0A
	ldx.w #$0000		; $8FE45A: A2 00 00
CODE_8FE45D:		; M=16 X=16
	lda.b $53,x		; $8FE45D: B5 53
	pha		; $8FE45F: 48
	inx		; $8FE460: E8
	inx		; $8FE461: E8
	cpx.w #$0018		; $8FE462: E0 18 00
	bne CODE_8FE45D		; $8FE465: D0 F6
	ldx.b $0A		; $8FE467: A6 0A
	stx.b $0A		; $8FE469: 86 0A
	ldx.w #$0000		; $8FE46B: A2 00 00
CODE_8FE46E:		; M=16 X=16
	lda.b $33,x		; $8FE46E: B5 33
	pha		; $8FE470: 48
	inx		; $8FE471: E8
	inx		; $8FE472: E8
	cpx.w #$0008		; $8FE473: E0 08 00
	bne CODE_8FE46E		; $8FE476: D0 F6
	ldx.b $0A		; $8FE478: A6 0A
	lda.w $04A3		; $8FE47A: AD A3 04
	and.w #$0003		; $8FE47D: 29 03 00
	clc		; $8FE480: 18
	adc.w #$0098		; $8FE481: 69 98 00
	pha		; $8FE484: 48
	jsl.l $80C28B		; $8FE485: 22 8B C2 80
	lda.w #$0004		; $8FE489: A9 04 00
	trb.w $128C		; $8FE48C: 1C 8C 12
	lda.w #$FFFF		; $8FE48F: A9 FF FF
	sta.w $0EBB		; $8FE492: 8D BB 0E
	lda.w #$0010		; $8FE495: A9 10 00
	sta.w $0E5F,x		; $8FE498: 9D 5F 0E
	txa		; $8FE49B: 8A
	lsr a		; $8FE49C: 4A
	sta.w $017D		; $8FE49D: 8D 7D 01
	lda.w #$0007		; $8FE4A0: A9 07 00
	sta.b $53		; $8FE4A3: 85 53
	lda.w $0B9F,x		; $8FE4A5: BD 9F 0B
	beq CODE_8FE4AF		; $8FE4A8: F0 05
	lda.w $101F,x		; $8FE4AA: BD 1F 10
	sta.b $53		; $8FE4AD: 85 53
CODE_8FE4AF:		; M=16 X=16
	lda.b $53		; $8FE4AF: A5 53
	asl a		; $8FE4B1: 0A
	asl a		; $8FE4B2: 0A
	adc.w #$0090		; $8FE4B3: 69 90 00
	sta.w $043D		; $8FE4B6: 8D 3D 04
	lda.w #$FFFF		; $8FE4B9: A9 FF FF
	sta.b $65		; $8FE4BC: 85 65
	lda.w #$0005		; $8FE4BE: A9 05 00
	sta.b $5F		; $8FE4C1: 85 5F
	stz.b $37		; $8FE4C3: 64 37
	cpx.w #$000C		; $8FE4C5: E0 0C 00
	bcc CODE_8FE4CF		; $8FE4C8: 90 05
	lda.w #$000C		; $8FE4CA: A9 0C 00
	sta.b $37		; $8FE4CD: 85 37
CODE_8FE4CF:		; M=16 X=16
	cpx.b $37		; $8FE4CF: E4 37
	bne CODE_8FE4D6		; $8FE4D1: D0 03
	jmp.w $E582		; $8FE4D3: 4C 82 E5
CODE_8FE4D6:		; M=16 X=16
	ldy.b $37		; $8FE4D6: A4 37
	lda.w $0B9F,y		; $8FE4D8: B9 9F 0B
	bne CODE_8FE4E0		; $8FE4DB: D0 03
	jmp.w $E582		; $8FE4DD: 4C 82 E5
CODE_8FE4E0:		; M=16 X=16
	lda.w $0EDF,y		; $8FE4E0: B9 DF 0E
	bit.w #$1000		; $8FE4E3: 89 00 10
	beq CODE_8FE4EB		; $8FE4E6: F0 03
	jmp.w $E582		; $8FE4E8: 4C 82 E5
CODE_8FE4EB:		; M=16 X=16
	lda.w $095F,y		; $8FE4EB: B9 5F 09
	sec		; $8FE4EE: 38
	sbc.w $097B		; $8FE4EF: ED 7B 09
	sta.b $57		; $8FE4F2: 85 57
	pha		; $8FE4F4: 48
	lda.w $08FF,y		; $8FE4F5: B9 FF 08
	sec		; $8FE4F8: 38
	sbc.w $091B		; $8FE4F9: ED 1B 09
	sta.b $53		; $8FE4FC: 85 53
	pha		; $8FE4FE: 48
	jsl.l $80AFA8		; $8FE4FF: 22 A8 AF 80
	pla		; $8FE503: 68
	sta.b $57		; $8FE504: 85 57
	pla		; $8FE506: 68
	sta.b $5B		; $8FE507: 85 5B
	lda.b $53		; $8FE509: A5 53
	sec		; $8FE50B: 38
	sbc.w $043B		; $8FE50C: ED 3B 04
	and.w #$0007		; $8FE50F: 29 07 00
	asl a		; $8FE512: 0A
	asl a		; $8FE513: 0A
	asl a		; $8FE514: 0A
	asl a		; $8FE515: 0A
	asl a		; $8FE516: 0A
	and.w #$00FF		; $8FE517: 29 FF 00
	bit.w #$0080		; $8FE51A: 89 80 00
	beq CODE_8FE522		; $8FE51D: F0 03
	ora.w #$FF00		; $8FE51F: 09 00 FF
CODE_8FE522:		; M=16 X=16
	asl a		; $8FE522: 0A
	asl a		; $8FE523: 0A
	asl a		; $8FE524: 0A
	sta.b $7D		; $8FE525: 85 7D
	sta.b $83		; $8FE527: 85 83
	jsl.l $82FCDB		; $8FE529: 22 DB FC 82
	sta.b $53		; $8FE52D: 85 53
	cmp.w #$0001		; $8FE52F: C9 01 00
	lda.b $95		; $8FE532: A5 95
	sta.b $55		; $8FE534: 85 55
	sbc.w #$0001		; $8FE536: E9 01 00
	bcs CODE_8FE582		; $8FE539: B0 47
	lda.b $57		; $8FE53B: A5 57
	sta.b $7D		; $8FE53D: 85 7D
	sta.b $83		; $8FE53F: 85 83
	jsl.l $82FCDB		; $8FE541: 22 DB FC 82
	sta.b $57		; $8FE545: 85 57
	lda.b $95		; $8FE547: A5 95
	sta.b $59		; $8FE549: 85 59
	lda.b $5B		; $8FE54B: A5 5B
	sta.b $7D		; $8FE54D: 85 7D
	sta.b $83		; $8FE54F: 85 83
	jsl.l $82FCDB		; $8FE551: 22 DB FC 82
	adc.b $57		; $8FE555: 65 57
	sta.b $5B		; $8FE557: 85 5B
	lda.b $95		; $8FE559: A5 95
	adc.b $59		; $8FE55B: 65 59
	sta.b $5D		; $8FE55D: 85 5D
	lda.b $5B		; $8FE55F: A5 5B
	clc		; $8FE561: 18
	adc.b $53		; $8FE562: 65 53
	sta.b $5B		; $8FE564: 85 5B
	lda.b $5D		; $8FE566: A5 5D
	adc.b $55		; $8FE568: 65 55
	sta.b $5D		; $8FE56A: 85 5D
	lda.b $63		; $8FE56C: A5 63
	cmp.b $5B		; $8FE56E: C5 5B
	lda.b $65		; $8FE570: A5 65
	sbc.b $5D		; $8FE572: E5 5D
	bcc CODE_8FE582		; $8FE574: 90 0C
	lda.b $5B		; $8FE576: A5 5B
	sta.b $63		; $8FE578: 85 63
	lda.b $5D		; $8FE57A: A5 5D
	sta.b $65		; $8FE57C: 85 65
	lda.b $37		; $8FE57E: A5 37
	sta.b $33		; $8FE580: 85 33
CODE_8FE582:		; M=16 X=16
	inc.b $37		; $8FE582: E6 37
	inc.b $37		; $8FE584: E6 37
	dec.b $5F		; $8FE586: C6 5F
	bmi CODE_8FE58D		; $8FE588: 30 03
	jmp.w $E4CF		; $8FE58A: 4C CF E4
CODE_8FE58D:		; M=16 X=16
	lda.b $65		; $8FE58D: A5 65
	bmi CODE_8FE598		; $8FE58F: 30 07
	jsl.l $8FF8C4		; $8FE591: 22 C4 F8 8F
	jmp.w $E611		; $8FE595: 4C 11 E6
CODE_8FE598:		; M=16 X=16
	lda.w $043B		; $8FE598: AD 3B 04
	asl a		; $8FE59B: 0A
	asl a		; $8FE59C: 0A
	adc.w #$AE38		; $8FE59D: 69 38 AE
	sta.b $33		; $8FE5A0: 85 33
	lda.w #$0080		; $8FE5A2: A9 80 00
	sta.b $35		; $8FE5A5: 85 35
	lda.b [$33]		; $8FE5A7: A7 33
	sta.b $83		; $8FE5A9: 85 83
	lda.w $043D		; $8FE5AB: AD 3D 04
	sta.b $7D		; $8FE5AE: 85 7D
	jsl.l $82FCDB		; $8FE5B0: 22 DB FC 82
	stz.b $83		; $8FE5B4: 64 83
	lda.b $93		; $8FE5B6: A5 93
	sta.b $84		; $8FE5B8: 85 84
	lda.b $95		; $8FE5BA: A5 95
	sta.b $86		; $8FE5BC: 85 86
	asl.b $83		; $8FE5BE: 06 83
	rol.b $85		; $8FE5C0: 26 85
	asl.b $83		; $8FE5C2: 06 83
	rol.b $85		; $8FE5C4: 26 85
	lda.w #$0BB8		; $8FE5C6: A9 B8 0B
	sta.b $7D		; $8FE5C9: 85 7D
	jsl.l $80996C		; $8FE5CB: 22 6C 99 80
	adc.w $0AFF,x		; $8FE5CF: 7D FF 0A
	sta.w $0B1B		; $8FE5D2: 8D 1B 0B
	dec.b $33		; $8FE5D5: C6 33
	dec.b $33		; $8FE5D7: C6 33
	lda.b [$33]		; $8FE5D9: A7 33
	sta.b $83		; $8FE5DB: 85 83
	lda.w $043D		; $8FE5DD: AD 3D 04
	sta.b $7D		; $8FE5E0: 85 7D
	jsl.l $82FCDB		; $8FE5E2: 22 DB FC 82
	stz.b $83		; $8FE5E6: 64 83
	lda.b $93		; $8FE5E8: A5 93
	sta.b $84		; $8FE5EA: 85 84
	lda.b $95		; $8FE5EC: A5 95
	sta.b $86		; $8FE5EE: 85 86
	asl.b $83		; $8FE5F0: 06 83
	rol.b $85		; $8FE5F2: 26 85
	asl.b $83		; $8FE5F4: 06 83
	rol.b $85		; $8FE5F6: 26 85
	lda.w #$0BB8		; $8FE5F8: A9 B8 0B
	sta.b $7D		; $8FE5FB: 85 7D
	jsl.l $80996C		; $8FE5FD: 22 6C 99 80
	adc.w $0ADF,x		; $8FE601: 7D DF 0A
	sta.w $0AFB		; $8FE604: 8D FB 0A
	lda.w #$1000		; $8FE607: A9 00 10
	jsl.l $80AE8B		; $8FE60A: 22 8B AE 80
	sta.w $0B3B		; $8FE60E: 8D 3B 0B
CODE_8FE611:		; M=16 X=16
	lda.w $0B9F,x		; $8FE611: BD 9F 0B
	bne CODE_8FE62E		; $8FE614: D0 18
	lda.w $113F,x		; $8FE616: BD 3F 11
	beq CODE_8FE622		; $8FE619: F0 07
	lda.w $0B1B		; $8FE61B: AD 1B 0B
	bmi CODE_8FE627		; $8FE61E: 30 07
	bra CODE_8FE62E		; $8FE620: 80 0C
CODE_8FE622:		; M=16 X=16
	lda.w $0B1B		; $8FE622: AD 1B 0B
	bmi CODE_8FE62E		; $8FE625: 30 07
CODE_8FE627:		; M=16 X=16
	eor.w #$FFFF		; $8FE627: 49 FF FF
	inc a		; $8FE62A: 1A
	sta.w $0B1B		; $8FE62B: 8D 1B 0B
CODE_8FE62E:		; M=16 X=16
	lda.w $0AFB		; $8FE62E: AD FB 0A
	sta.b $53		; $8FE631: 85 53
	lda.w $0B1B		; $8FE633: AD 1B 0B
	sta.b $57		; $8FE636: 85 57
	jsl.l $80AFA8		; $8FE638: 22 A8 AF 80
	lda.w #$02D2		; $8FE63C: A9 D2 02
	sta.b $57		; $8FE63F: 85 57
	lda.w $0B9F,x		; $8FE641: BD 9F 0B
	beq CODE_8FE656		; $8FE644: F0 10
	lda.w #$06C4		; $8FE646: A9 C4 06
	sta.b $57		; $8FE649: 85 57
	jsl.l $8FF603		; $8FE64B: 22 03 F6 8F
	beq CODE_8FE656		; $8FE64F: F0 05
	lda.w #$0736		; $8FE651: A9 36 07
	sta.b $57		; $8FE654: 85 57
CODE_8FE656:		; M=16 X=16
	jsl.l $80B006		; $8FE656: 22 06 B0 80
	lda.w #$0001		; $8FE65A: A9 01 00
	sta.w $117F,x		; $8FE65D: 9D 7F 11
	stx.b $0A		; $8FE660: 86 0A
	ldx.w #$0006		; $8FE662: A2 06 00
CODE_8FE665:		; M=16 X=16
	pla		; $8FE665: 68
	sta.b $33,x		; $8FE666: 95 33
	dex		; $8FE668: CA
	dex		; $8FE669: CA
	bpl CODE_8FE665		; $8FE66A: 10 F9
	ldx.b $0A		; $8FE66C: A6 0A
	stx.b $0A		; $8FE66E: 86 0A
	ldx.w #$0016		; $8FE670: A2 16 00
CODE_8FE673:		; M=16 X=16
	pla		; $8FE673: 68
	sta.b $53,x		; $8FE674: 95 53
	dex		; $8FE676: CA
	dex		; $8FE677: CA
	bpl CODE_8FE673		; $8FE678: 10 F9
	ldx.b $0A		; $8FE67A: A6 0A
	rtl		; $8FE67C: 6B
	db $5A,$84,$8C,$00,$85,$90,$8F,$00,$00,$80,$87,$00,$EB,$83,$8E,$00	; $8FE67D
	db $00,$80,$85,$00,$EE,$83,$8B,$00,$05,$D2,$87,$00,$56,$BC,$88,$00	; $8FE68D
	db $0F,$8A,$88,$00,$00,$80,$84,$00,$3C,$88,$8D,$00,$00,$80,$89,$00	; $8FE69D
	db $00,$80,$8A,$00,$83,$93,$89,$00,$A7,$D9,$8E,$00,$00,$00,$00,$00	; $8FE6AD
	db $86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$0C,$00,$D0,$F6,$A6	; $8FE6BD
	db $0A,$86,$0A,$A2,$00,$00,$B5,$33,$48,$E8,$E8,$E0,$04,$00,$D0,$F6	; $8FE6CD
	db $A6,$0A,$A9,$03,$00,$85,$53,$A4,$3B,$B9,$EE,$13,$A4,$37,$D9,$EE	; $8FE6DD
	db $13,$F0,$4D,$10,$04,$E6,$53,$E6,$53,$A5,$53,$48,$22,$05,$84,$88	; $8FE6ED
	db $A5,$53,$85,$57,$A3,$01,$1A,$85,$53,$22,$05,$84,$88,$A5,$57,$38	; $8FE6FD
	db $E5,$53,$30,$04,$70,$04,$80,$05,$70,$03,$68,$1A,$48,$68,$A4,$3B	; $8FE70D
	db $99,$DE,$13,$86,$0A,$A2,$02,$00,$68,$95,$33,$CA,$CA,$10,$F9,$A6	; $8FE71D
	db $0A,$86,$0A,$A2,$0A,$00,$68,$95,$53,$CA,$CA,$10,$F9,$A6,$0A,$6B	; $8FE72D
	db $A4,$3B,$D0,$7C,$A9,$02,$00,$85,$57,$A9,$93,$E7,$85,$33,$A9,$8F	; $8FE73D
	db $00,$85,$35,$AD,$F0,$12,$C9,$02,$00,$D0,$18,$B9,$D6,$13,$A4,$37	; $8FE74D
	db $D9,$D6,$13,$F0,$0E,$08,$A9,$A1,$E7,$85,$33,$28,$10,$05,$A9,$AF	; $8FE75D
	db $E7,$85,$33,$A4,$37,$B9,$DE,$13,$0A,$85,$57,$A8,$B7,$33,$85,$53	; $8FE76D
	db $22,$05,$84,$88,$A5,$53,$C9,$01,$0C,$90,$35,$A4,$57,$B7,$33,$A4	; $8FE77D
	db $3B,$99,$DE,$13,$80,$8D,$00,$00,$01,$00,$02,$00,$00,$00,$01,$00	; $8FE78D
	db $00,$00,$01,$00,$02,$00,$00,$00,$01,$00,$02,$00,$00,$00,$02,$00	; $8FE79D
	db $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$01,$00,$00,$00,$01,$00	; $8FE7AD
	db $A9,$02,$00,$85,$57,$A9,$13,$E8,$85,$33,$A9,$8F,$00,$85,$35,$AD	; $8FE7BD
	db $F0,$12,$C9,$02,$00,$D0,$1A,$A4,$3B,$B9,$D6,$13,$A4,$37,$D9,$D6	; $8FE7CD
	db $13,$F0,$0E,$08,$A9,$19,$E8,$85,$33,$28,$10,$05,$A9,$1F,$E8,$85	; $8FE7DD
	db $33,$A7,$33,$E6,$33,$E6,$33,$85,$53,$22,$05,$84,$88,$A5,$53,$C9	; $8FE7ED
	db $34,$0F,$B0,$04,$C6,$57,$10,$E9,$C6,$33,$C6,$33,$A4,$3B,$A7,$33	; $8FE7FD
	db $99,$DE,$13,$4C,$20,$E7,$00,$00,$01,$00,$02,$00,$00,$00,$02,$00	; $8FE80D
	db $01,$00,$00,$00,$01,$00,$00,$00,$22,$04,$E4,$8F,$E2,$20,$9C,$0D	; $8FE81D
	db $21,$9C,$0D,$21,$9C,$0E,$21,$9C,$0E,$21,$9C,$0F,$21,$9C,$0F,$21	; $8FE82D
	db $9C,$10,$21,$9C,$10,$21,$A9,$00,$8D,$07,$21,$A9,$04,$8D,$08,$21	; $8FE83D
	db $A9,$44,$8D,$0B,$21,$A9,$03,$8D,$2C,$21,$C2,$30,$A9,$00,$FD,$8D	; $8FE84D
	db $CD,$1B,$8D,$CF,$1B,$8D,$CB,$1B,$64,$D4,$AD,$D7,$1B,$0A,$0A,$0A	; $8FE85D
	db $0A,$69,$00,$10,$8D,$16,$21,$A9,$D8,$C6,$85,$73,$A9,$83,$00,$85	; $8FE86D
	db $75,$22,$3E,$FA,$86,$64,$33,$A9,$7F,$00,$85,$35,$A9,$54,$E1,$85	; $8FE87D
	db $37,$A9,$8F,$00,$85,$39,$A9,$64,$00,$85,$53,$22,$E4,$E0,$8F,$A2	; $8FE88D
	db $00,$00,$BF,$2E,$87,$88,$8D,$18,$21,$E8,$E8,$E0,$80,$00,$D0,$F2	; $8FE89D
	db $AD,$E5,$1B,$0A,$0A,$0A,$0A,$69,$00,$10,$8D,$16,$21,$A9,$73,$9B	; $8FE8AD
	db $85,$73,$A9,$88,$00,$85,$75,$22,$3E,$FA,$86,$A2,$00,$00,$BF,$00	; $8FE8BD
	db $00,$7F,$8D,$18,$21,$E8,$E8,$E0,$A0,$32,$D0,$F2,$A9,$A0,$C3,$85	; $8FE8CD
	db $73,$A9,$87,$00,$85,$75,$22,$3E,$FA,$86,$A2,$00,$00,$BF,$00,$04	; $8FE8DD
	db $7F,$8D,$18,$21,$E8,$E8,$E0,$A0,$04,$D0,$F2,$A2,$FE,$03,$BF,$00	; $8FE8ED
	db $00,$7F,$18,$6D,$D5,$1B,$18,$6D,$CF,$1B,$9F,$74,$76,$7E,$9F,$74	; $8FE8FD
	db $7A,$7E,$CA,$CA,$10,$E8,$A9,$38,$ED,$85,$73,$A9,$80,$00,$85,$75	; $8FE90D
	db $22,$3E,$FA,$86,$E2,$20,$9C,$21,$21,$A2,$00,$00,$BF,$90,$00,$7F	; $8FE91D
	db $8D,$22,$21,$E8,$E0,$80,$00,$D0,$F3,$C2,$30,$64,$3B,$AD,$96,$12	; $8FE92D
	db $85,$73,$AD,$8C,$12,$89,$02,$00,$F0,$05,$AD,$98,$12,$85,$73,$A5	; $8FE93D
	db $73,$C9,$02,$00,$D0,$05,$A9,$02,$00,$85,$3B,$A4,$3B,$B9,$DE,$13	; $8FE94D
	db $1A,$85,$53,$8D,$ED,$08,$9C,$F1,$08,$22,$0C,$B9,$80,$05,$00,$FE	; $8FE95D
	db $03,$01,$A9,$1A,$00,$85,$53,$A9,$06,$00,$85,$57,$22,$9F,$D6,$8F	; $8FE96D
	db $AD,$E7,$1B,$18,$6D,$CD,$1B,$A2,$FE,$07,$9F,$74,$6E,$7E,$CA,$CA	; $8FE97D
	db $10,$F8,$22,$BF,$FD,$82,$14,$00,$BF,$05,$04,$54,$65,$61,$6D,$20	; $8FE98D
	db $20,$52,$6F,$73,$74,$65,$72,$BF,$0B,$01,$AD,$9A,$12,$85,$57,$A5	; $8FE99D
	db $3B,$F0,$08,$AD,$9C,$12,$85,$57,$A9,$30,$00,$85,$53,$22,$E2,$84	; $8FE9AD
	db $8D,$22,$0C,$B9,$80,$17,$00,$9F,$08,$0C,$50,$6C,$61,$79,$65,$72	; $8FE9BD
	db $9F,$18,$0C,$52,$61,$74,$69,$6E,$67,$BE,$01,$08,$A9,$0F,$00,$85	; $8FE9CD
	db $53,$A9,$03,$00,$85,$57,$22,$9F,$D6,$8F,$22,$0C,$B9,$80,$05,$00	; $8FE9DD
	db $BE,$10,$08,$A9,$0F,$00,$85,$53,$A9,$03,$00,$85,$57,$22,$9F,$D6	; $8FE9ED
	db $8F,$22,$96,$EA,$8F,$A9,$74,$6E,$8D,$53,$16,$A9,$7E,$00,$8D,$55	; $8FE9FD
	db $16,$A9,$00,$10,$8D,$56,$16,$9C,$58,$16,$A9,$07,$00,$85,$A3,$A9	; $8FEA0D
	db $50,$82,$85,$14,$C5,$14,$F0,$FC,$22,$E8,$F3,$80,$22,$0E,$FF,$85	; $8FEA1D
	db $22,$53,$FC,$86,$A5,$57,$89,$00,$10,$F0,$03,$4C,$DF,$EB,$89,$00	; $8FEA2D
	db $40,$D0,$4C,$64,$53,$E6,$53,$89,$00,$01,$D0,$30,$C6,$53,$C6,$53	; $8FEA3D
	db $89,$00,$02,$D0,$27,$89,$00,$08,$D0,$09,$E6,$53,$E6,$53,$89,$00	; $8FEA4D
	db $04,$F0,$16,$A5,$53,$18,$6D,$ED,$08,$85,$53,$30,$0C,$C9,$08,$00	; $8FEA5D
	db $B0,$07,$8D,$ED,$08,$22,$96,$EA,$8F,$4C,$02,$EA,$A5,$53,$18,$6D	; $8FEA6D
	db $F1,$08,$85,$53,$30,$F3,$8D,$F1,$08,$22,$96,$EA,$8F,$80,$EA,$A5	; $8FEA7D
	db $3B,$49,$02,$00,$85,$3B,$4C,$66,$E9,$22,$0C,$B9,$80,$05,$00,$9F	; $8FEA8D
	db $02,$09,$AD,$ED,$08,$85,$53,$A9,$F0,$EB,$85,$37,$A9,$8F,$00,$85	; $8FEA9D
	db $39,$22,$93,$D7,$8F,$22,$2D,$B9,$80,$A9,$11,$00,$8D,$7B,$04,$A9	; $8FEAAD
	db $09,$00,$8D,$7D,$04,$A9,$A1,$D7,$85,$37,$A9,$8F,$00,$85,$39,$AD	; $8FEABD
	db $F1,$08,$85,$53,$AD,$ED,$08,$D0,$16,$A9,$E6,$D8,$85,$37,$A9,$8F	; $8FEACD
	db $00,$85,$39,$80,$0A,$A5,$37,$18,$67,$37,$69,$04,$00,$85,$37,$A7	; $8FEADD
	db $37,$30,$04,$C6,$53,$10,$EE,$A7,$37,$10,$05,$CE,$F1,$08,$80,$C5	; $8FEAED
	db $22,$2D,$B9,$80,$A7,$37,$85,$65,$A0,$02,$00,$B7,$37,$85,$63,$22	; $8FEAFD
	db $0C,$B9,$80,$05,$00,$BF,$00,$0D,$A9,$20,$00,$85,$53,$A9,$13,$00	; $8FEB0D
	db $85,$57,$AD,$E7,$1B,$85,$5B,$22,$7C,$84,$8D,$22,$0C,$B9,$80,$18	; $8FEB1D
	db $00,$9F,$08,$1A,$59,$20,$2D,$20,$53,$77,$69,$74,$63,$68,$20,$54	; $8FEB2D
	db $65,$61,$6D,$73,$BF,$00,$0E,$22,$6B,$D7,$8F,$A5,$53,$3A,$85,$57	; $8FEB3D
	db $A9,$E4,$EB,$85,$47,$A9,$8F,$00,$85,$49,$A9,$E0,$EB,$85,$3F,$A9	; $8FEB4D
	db $8F,$00,$85,$41,$AD,$ED,$08,$3A,$85,$53,$30,$3E,$0A,$0A,$0A,$85	; $8FEB5D
	db $53,$A4,$3B,$A9,$83,$00,$85,$41,$B9,$CE,$13,$85,$3F,$A0,$06,$00	; $8FEB6D
	db $18,$77,$3F,$38,$65,$53,$85,$3F,$A9,$CC,$D9,$85,$47,$A9,$8F,$00	; $8FEB7D
	db $85,$49,$A9,$04,$00,$85,$57,$AD,$ED,$08,$38,$E9,$05,$00,$F0,$0A	; $8FEB8D
	db $30,$04,$50,$04,$80,$04,$50,$02,$C6,$57,$A9,$02,$00,$8D,$7B,$04	; $8FEB9D
	db $A5,$47,$85,$37,$A5,$49,$85,$39,$22,$2D,$B9,$80,$A5,$37,$85,$47	; $8FEBAD
	db $A5,$39,$85,$49,$A9,$05,$00,$8D,$7B,$04,$A7,$3F,$E6,$3F,$29,$FF	; $8FEBBD
	db $00,$3A,$85,$53,$22,$44,$FC,$84,$EE,$7D,$04,$EE,$7D,$04,$C6,$57	; $8FEBCD
	db $10,$C8,$6B,$01,$02,$03,$04,$03,$00,$47,$03,$00,$47,$03,$00,$47	; $8FEBDD
	db $03,$00,$47,$0F,$00,$20,$20,$47,$6F,$61,$6C,$69,$65,$73,$20,$20	; $8FEBED
	db $20,$7D,$0F,$00,$7B,$53,$63,$6F,$72,$69,$6E,$67,$20,$20,$31,$20	; $8FEBFD
	db $7D,$0F,$00,$7B,$53,$63,$6F,$72,$69,$6E,$67,$20,$20,$32,$20,$7D	; $8FEC0D
	db $0F,$00,$7B,$20,$43,$68,$65,$63,$6B,$69,$6E,$67,$20,$20,$7D,$0F	; $8FEC1D
	db $00,$7B,$50,$77,$72,$2E,$20,$50,$6C,$61,$79,$20,$31,$7D,$0F,$00	; $8FEC2D
	db $7B,$50,$77,$72,$2E,$20,$50,$6C,$61,$79,$20,$32,$7D,$0F,$00,$7B	; $8FEC3D
	db $50,$65,$6E,$2E,$20,$4B,$69,$6C,$6C,$20,$31,$7D,$0F,$00,$7B,$50	; $8FEC4D
	db $65,$6E,$2E,$20,$4B,$69,$6C,$6C,$20,$32,$20	; $8FEC5D
CODE_8FEC68:		; M=16 X=16
	lda.b $C3		; $8FEC68: A5 C3
	cmp.w #$0293		; $8FEC6A: C9 93 02
	bcc CODE_8FEC73		; $8FEC6D: 90 04
	jml.l $87D1FE		; $8FEC6F: 5C FE D1 87
CODE_8FEC73:		; M=16 X=16
	dec.b $C3		; $8FEC73: C6 C3
	bpl CODE_8FEC7B		; $8FEC75: 10 04
	jml.l $87D1FE		; $8FEC77: 5C FE D1 87
CODE_8FEC7B:		; M=16 X=16
	stz.b $C5		; $8FEC7B: 64 C5
	ldx.w #$0000		; $8FEC7D: A2 00 00
	ldy.w #$0002		; $8FEC80: A0 02 00
CODE_8FEC83:		; M=16 X=16
	lda.l $8FE67D,x		; $8FEC83: BF 7D E6 8F
	beq CODE_8FEC83		; $8FEC87: F0 FA
	sta.b $0C		; $8FEC89: 85 0C
	lda.l $8FE67E,x		; $8FEC8B: BF 7E E6 8F
	sta.b $0D		; $8FEC8F: 85 0D
	lda.b $C3		; $8FEC91: A5 C3
	sec		; $8FEC93: 38
	sbc.b [$0C]		; $8FEC94: E7 0C
	bcs CODE_8FEC9C		; $8FEC96: B0 04
	jml.l $87CE62		; $8FEC98: 5C 62 CE 87
CODE_8FEC9C:		; M=16 X=16
	sta.b $C3		; $8FEC9C: 85 C3
	lda.b $C5		; $8FEC9E: A5 C5
	clc		; $8FECA0: 18
	adc.b [$0C],y		; $8FECA1: 77 0C
	sta.b $C5		; $8FECA3: 85 C5
	inx		; $8FECA5: E8
	inx		; $8FECA6: E8
	inx		; $8FECA7: E8
	inx		; $8FECA8: E8
	bra CODE_8FEC83		; $8FECA9: 80 D8
	db $22,$0C,$B9,$80,$05,$00,$BF,$06,$0D,$64,$53,$A9,$C6,$ED,$85,$33	; $8FECAB
	db $A9,$8F,$00,$85,$35,$AD,$F0,$12,$C9,$04,$00,$D0,$05,$A9,$09,$EE	; $8FECBB
	db $85,$33,$A9,$00,$24,$8D,$77,$04,$A5,$53,$CD,$85,$04,$D0,$06,$A9	; $8FECCB
	db $00,$20,$8D,$77,$04,$A9,$06,$00,$8D,$7B,$04,$22,$0C,$B9,$80,$16	; $8FECDB
	db $00,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; $8FECEB
	db $20,$20,$20,$20,$20,$A9,$91,$01,$85,$37,$A9,$00,$00,$85,$39,$A0	; $8FECFB
	db $1E,$00,$B7,$33,$97,$37,$88,$88,$10,$F8,$22,$3F,$ED,$8F,$A7,$37	; $8FED0B
	db $4A,$49,$FF,$FF,$1A,$18,$69,$11,$00,$8D,$7B,$04,$22,$2D,$B9,$80	; $8FED1B
	db $EE,$7D,$04,$A5,$33,$18,$67,$33,$85,$33,$E6,$53,$A5,$53,$C9,$05	; $8FED2B
	db $00,$D0,$8F,$6B,$A5,$53,$C9,$03,$00,$F0,$03,$4C,$9D,$ED,$22,$4A	; $8FED3B
	db $EE,$8F,$A4,$3B,$B9,$F2,$13,$30,$4A,$85,$73,$B9,$CE,$13,$85,$43	; $8FED4B
	db $A9,$83,$00,$85,$45,$A0,$00,$00,$B7,$43,$18,$65,$43,$85,$43,$C6	; $8FED5B
	db $73,$30,$0C,$A7,$43,$18,$65,$43,$69,$08,$00,$85,$43,$80,$F0,$A0	; $8FED6B
	db $01,$00,$C8,$B7,$43,$29,$FF,$00,$C9,$20,$00,$D0,$F5,$C8,$98,$C7	; $8FED7B
	db $43,$F0,$0F,$B7,$43,$5A,$AC,$91,$01,$99,$91,$01,$EE,$91,$01,$7A	; $8FED8B
	db $80,$EB,$6B,$AC,$91,$01,$A9,$4E,$00,$99,$91,$01,$A9,$4F,$00,$99	; $8FED9B
	db $92,$01,$A9,$4E,$00,$99,$93,$01,$A9,$45,$00,$99,$94,$01,$EE,$91	; $8FEDAB
	db $01,$EE,$91,$01,$EE,$91,$01,$EE,$91,$01,$6B,$0D,$00,$52,$65,$73	; $8FEDBB
	db $75,$6D,$65,$20,$47,$61,$6D,$65,$10,$00,$49,$6E,$73,$74,$61,$6E	; $8FEDCB
	db $74,$20,$52,$65,$70,$6C,$61,$79,$0E,$00,$53,$74,$61,$74,$73,$20	; $8FEDDB
	db $52,$65,$70,$6F,$72,$74,$0B,$00,$47,$6F,$61,$6C,$69,$65,$20,$2D	; $8FEDEB
	db $20,$0D,$00,$54,$65,$61,$6D,$20,$52,$6F,$73,$74,$65,$72,$0B,$00	; $8FEDFB
	db $45,$78,$69,$74,$20,$47,$61,$6D,$65,$10,$00,$49,$6E,$73,$74,$61	; $8FEE0B
	db $6E,$74,$20,$52,$65,$70,$6C,$61,$79,$0E,$00,$53,$74,$61,$74,$73	; $8FEE1B
	db $20,$52,$65,$70,$6F,$72,$74,$0B,$00,$47,$6F,$61,$6C,$69,$65,$20	; $8FEE2B
	db $2D,$20,$0D,$00,$54,$65,$61,$6D,$20,$52,$6F,$73,$74,$65,$72,$64	; $8FEE3B
	db $3B,$AD,$96,$12,$F0,$19,$AD,$8C,$12,$89,$02,$00,$F0,$05,$AD,$98	; $8FEE4B
	db $12,$80,$03,$AD,$96,$12,$C9,$01,$00,$F0,$04,$E6,$3B,$E6,$3B,$6B	; $8FEE5B
CODE_8FEE6B:		; M=16 X=16
	lda.b $3B		; $8FEE6B: A5 3B
	beq CODE_8FEE72		; $8FEE6D: F0 03
	lda.w #$0034		; $8FEE6F: A9 34 00
CODE_8FEE72:		; M=16 X=16
	clc		; $8FEE72: 18
	adc.b $57		; $8FEE73: 65 57
	tay		; $8FEE75: A8
	lda.b $53		; $8FEE76: A5 53
	bpl CODE_8FEE7F		; $8FEE78: 10 05
	lda.w #$0000		; $8FEE7A: A9 00 00
	sta.b $53		; $8FEE7D: 85 53
CODE_8FEE7F:		; M=16 X=16
	sta.w $147A,y		; $8FEE7F: 99 7A 14
	rtl		; $8FEE82: 6B
CODE_8FEE83:		; M=16 X=16
	lda.w #$80CE		; $8FEE83: A9 CE 80
	sta.b $14		; $8FEE86: 85 14
	lda.w #$83A3		; $8FEE88: A9 A3 83
	sta.b $16		; $8FEE8B: 85 16
	lda.b $A7		; $8FEE8D: A5 A7
	sec		; $8FEE8F: 38
	sbc.w #$003C		; $8FEE90: E9 3C 00
	ldx.w #$0000		; $8FEE93: A2 00 00
CODE_8FEE96:		; M=16 X=16
	sta.l $7E2000,x		; $8FEE96: 9F 00 20 7E
	inx		; $8FEE9A: E8
	inx		; $8FEE9B: E8
	cpx.w #$4C74		; $8FEE9C: E0 74 4C
	bne CODE_8FEE96		; $8FEE9F: D0 F5
	ldx.w #$0000		; $8FEEA1: A2 00 00
CODE_8FEEA4:		; M=16 X=16
	sta.w $04AB,x		; $8FEEA4: 9D AB 04
	inx		; $8FEEA7: E8
	inx		; $8FEEA8: E8
	cpx.w #$0400		; $8FEEA9: E0 00 04
	bne CODE_8FEEA4		; $8FEEAC: D0 F6
	stz.b $A3		; $8FEEAE: 64 A3
	sep #$20		; $8FEEB0: E2 20
	cli		; $8FEEB2: 58
	lda.w $4210		; $8FEEB3: AD 10 42
	lda.b #$81		; $8FEEB6: A9 81
	sta.w $4200		; $8FEEB8: 8D 00 42
	rep #$30		; $8FEEBB: C2 30
	lda.b $00		; $8FEEBD: A5 00
CODE_8FEEBF:		; M=16 X=16
	cmp.b $00		; $8FEEBF: C5 00
	beq CODE_8FEEBF		; $8FEEC1: F0 FC
	jsl.l $8D8120		; $8FEEC3: 22 20 81 8D
	sep #$20		; $8FEEC7: E2 20
	cli		; $8FEEC9: 58
	lda.w $4210		; $8FEECA: AD 10 42
	lda.b #$81		; $8FEECD: A9 81
	sta.w $4200		; $8FEECF: 8D 00 42
	lda.b #$03		; $8FEED2: A9 03
	sta.w $2101		; $8FEED4: 8D 01 21
	lda.b #$01		; $8FEED7: A9 01
	sta.w $2105		; $8FEED9: 8D 05 21
	lda.b #$00		; $8FEEDC: A9 00
	sta.w $2107		; $8FEEDE: 8D 07 21
	lda.b #$04		; $8FEEE1: A9 04
	sta.w $2108		; $8FEEE3: 8D 08 21
	lda.b #$11		; $8FEEE6: A9 11
	sta.w $210B		; $8FEEE8: 8D 0B 21
	lda.b #$13		; $8FEEEB: A9 13
	sta.w $212C		; $8FEEED: 8D 2C 21
	rep #$30		; $8FEEF0: C2 30
	stz.w $1BCB		; $8FEEF2: 9C CB 1B
	stz.w $1BCD		; $8FEEF5: 9C CD 1B
	stz.w $1BCF		; $8FEEF8: 9C CF 1B
	lda.w #$0012		; $8FEEFB: A9 12 00
	sta.w $1BE7		; $8FEEFE: 8D E7 1B
	inc a		; $8FEF01: 1A
	sta.w $1BD7		; $8FEF02: 8D D7 1B
	clc		; $8FEF05: 18
	adc.w #$0064		; $8FEF06: 69 64 00
	sta.w $1BDB		; $8FEF09: 8D DB 1B
	adc.w #$0004		; $8FEF0C: 69 04 00
	sta.w $1BDD		; $8FEF0F: 8D DD 1B
	adc.w #$0035		; $8FEF12: 69 35 00
	sta.w $1BE5		; $8FEF15: 8D E5 1B
	jsl.l $8888C3		; $8FEF18: 22 C3 88 88
	lda.w #$8000		; $8FEF1C: A9 00 80
	sta.b $73		; $8FEF1F: 85 73
	lda.w #$0088		; $8FEF21: A9 88 00
	sta.b $75		; $8FEF24: 85 75
	jsl.l $86FA3E		; $8FEF26: 22 3E FA 86
	sep #$20		; $8FEF2A: E2 20
	stz.w $2121		; $8FEF2C: 9C 21 21
	ldx.w #$0000		; $8FEF2F: A2 00 00
CODE_8FEF32:		; M=8 X=16
	lda.l $7F0800,x		; $8FEF32: BF 00 08 7F
	sta.l $7E6C74,x		; $8FEF36: 9F 74 6C 7E
	sta.w $2122		; $8FEF3A: 8D 22 21
	inx		; $8FEF3D: E8
	cpx.w #$0100		; $8FEF3E: E0 00 01
	bne CODE_8FEF32		; $8FEF41: D0 EF
	ldx.w #$0000		; $8FEF43: A2 00 00
CODE_8FEF46:		; M=8 X=16
	lda.l $83F72B,x		; $8FEF46: BF 2B F7 83
	sta.l $7E6D74,x		; $8FEF4A: 9F 74 6D 7E
	sta.w $2122		; $8FEF4E: 8D 22 21
	inx		; $8FEF51: E8
	cpx.w #$0100		; $8FEF52: E0 00 01
	bne CODE_8FEF46		; $8FEF55: D0 EF
	rep #$30		; $8FEF57: C2 30
	lda.w #$1000		; $8FEF59: A9 00 10
	sta.w $2116		; $8FEF5C: 8D 16 21
	ldx.w #$0000		; $8FEF5F: A2 00 00
CODE_8FEF62:		; M=16 X=16
	lda.l $7F0900,x		; $8FEF62: BF 00 09 7F
	sta.w $2118		; $8FEF66: 8D 18 21
	inx		; $8FEF69: E8
	inx		; $8FEF6A: E8
	cpx.w #$0240		; $8FEF6B: E0 40 02
	bne CODE_8FEF62		; $8FEF6E: D0 F2
	ldx.w #$0010		; $8FEF70: A2 10 00
CODE_8FEF73:		; M=16 X=16
	stz.w $2118		; $8FEF73: 9C 18 21
	dex		; $8FEF76: CA
	bne CODE_8FEF73		; $8FEF77: D0 FA
	lda.w #$C6D8		; $8FEF79: A9 D8 C6
	sta.b $73		; $8FEF7C: 85 73
	lda.w #$0083		; $8FEF7E: A9 83 00
	sta.b $75		; $8FEF81: 85 75
	jsl.l $86FA3E		; $8FEF83: 22 3E FA 86
	lda.w #$0000		; $8FEF87: A9 00 00
	sta.b $33		; $8FEF8A: 85 33
	lda.w #$007F		; $8FEF8C: A9 7F 00
	sta.b $35		; $8FEF8F: 85 35
	lda.w #$F4C8		; $8FEF91: A9 C8 F4
	sta.b $37		; $8FEF94: 85 37
	lda.w #$008F		; $8FEF96: A9 8F 00
	sta.b $39		; $8FEF99: 85 39
	lda.w #$0064		; $8FEF9B: A9 64 00
	sta.b $53		; $8FEF9E: 85 53
	jsl.l $8FE0E4		; $8FEFA0: 22 E4 E0 8F
	lda.w #$872E		; $8FEFA4: A9 2E 87
	sta.b $33		; $8FEFA7: 85 33
	lda.w #$0088		; $8FEFA9: A9 88 00
	sta.b $35		; $8FEFAC: 85 35
	lda.w #$F4B8		; $8FEFAE: A9 B8 F4
	sta.b $37		; $8FEFB1: 85 37
	lda.w #$008F		; $8FEFB3: A9 8F 00
	sta.b $39		; $8FEFB6: 85 39
	lda.w #$0004		; $8FEFB8: A9 04 00
	sta.b $53		; $8FEFBB: 85 53
	jsl.l $8FE0E4		; $8FEFBD: 22 E4 E0 8F
	lda.w #$8000		; $8FEFC1: A9 00 80
	sta.b $73		; $8FEFC4: 85 73
	lda.w #$008C		; $8FEFC6: A9 8C 00
	sta.b $75		; $8FEFC9: 85 75
	jsl.l $86FA3E		; $8FEFCB: 22 3E FA 86
	ldx.w #$0000		; $8FEFCF: A2 00 00
CODE_8FEFD2:		; M=16 X=16
	lda.l $7F01A0,x		; $8FEFD2: BF A0 01 7F
	sta.w $2118		; $8FEFD6: 8D 18 21
	inx		; $8FEFD9: E8
	inx		; $8FEFDA: E8
	cpx.w #$06A0		; $8FEFDB: E0 A0 06
	bne CODE_8FEFD2		; $8FEFDE: D0 F2
	lda.w #$9B73		; $8FEFE0: A9 73 9B
	sta.b $73		; $8FEFE3: 85 73
	lda.w #$0088		; $8FEFE5: A9 88 00
	sta.b $75		; $8FEFE8: 85 75
	jsl.l $86FA3E		; $8FEFEA: 22 3E FA 86
	ldx.w #$0000		; $8FEFEE: A2 00 00
CODE_8FEFF1:		; M=16 X=16
	lda.l $7F0000,x		; $8FEFF1: BF 00 00 7F
	sta.w $2118		; $8FEFF5: 8D 18 21
	inx		; $8FEFF8: E8
	inx		; $8FEFF9: E8
	cpx.w #$32A0		; $8FEFFA: E0 A0 32
	bne CODE_8FEFF1		; $8FEFFD: D0 F2
	jsl.l $80F3E8		; $8FEFFF: 22 E8 F3 80
