; $80B006-$80BFFF  ROM $03006  (from src/bank80.asm; quick pass, TODO segment agents refine)
org $80B006
CODE_80B006:		; M=16 X=16
	lda.b $57		; $80B006: A5 57
	cmp.w $0DFF,x		; $80B008: DD FF 0D
	beq CODE_80B019		; $80B00B: F0 0C
	sta.w $0DFF,x		; $80B00D: 9D FF 0D
	stz.w $0E1F,x		; $80B010: 9E 1F 0E
	lda.w #$FFFF		; $80B013: A9 FF FF
	sta.w $0E3F,x		; $80B016: 9D 3F 0E
CODE_80B019:		; M=16 X=16
	rtl		; $80B019: 6B
	db $9C,$E4,$12,$A9,$10,$00,$85,$57,$64,$33,$22,$32,$B0,$80,$A9,$01	; $80B01A
	db $00,$85,$57,$A9,$02,$00,$85,$33,$A9,$32,$00,$85,$53,$AD,$E4,$12	; $80B02A
	db $18,$65,$57,$8D,$E4,$12,$A5,$33,$F0,$03,$A9,$34,$00,$65,$53,$A8	; $80B03A
	db $B9,$E2,$14,$30,$19,$F0,$17,$89,$00,$10,$F0,$29,$29,$FF,$07,$85	; $80B04A
	db $5B,$D0,$22,$AD,$E4,$12,$38,$E5,$57,$8D,$E4,$12,$80,$17,$AD,$E4	; $80B05A
	db $12,$38,$E5,$57,$8D,$E4,$12,$B9,$E2,$14,$C9,$FD,$FF,$F0,$06,$A9	; $80B06A
	db $FE,$FF,$99,$E2,$14,$C6,$53,$C6,$53,$10,$B2,$6B,$86,$0A,$A2,$00	; $80B07A
	db $00,$B5,$53,$48,$E8,$E8,$E0,$14,$00,$D0,$F6,$A6,$0A,$86,$0A,$A2	; $80B08A
	db $00,$00,$B5,$33,$48,$E8,$E8,$E0,$10,$00,$D0,$F6,$A6,$0A,$A4,$3B	; $80B09A
	db $B9,$D2,$13,$85,$3F,$A9,$05,$00,$85,$63,$A6,$3F,$BD,$9F,$0E,$29	; $80B0AA
	db $FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$85,$53,$9D,$9F,$0B,$C9	; $80B0BA
	db $00,$00,$30,$38,$22,$38,$B1,$80,$A6,$3F,$BD,$9F,$0B,$C9,$04,$00	; $80B0CA
	db $D0,$09,$A9,$11,$00,$85,$53,$22,$9D,$B4,$80,$A6,$3F,$BD,$BF,$0E	; $80B0DA
	db $29,$FF,$00,$0A,$85,$5F,$A5,$3B,$F0,$03,$A9,$34,$00,$65,$5F,$A8	; $80B0EA
	db $A9,$FF,$FF,$99,$E2,$14,$46,$5F,$22,$5D,$B1,$80,$A6,$3F,$A9,$FF	; $80B0FA
	db $FF,$9D,$BF,$0E,$9D,$9F,$0E,$E6,$3F,$E6,$3F,$C6,$63,$10,$9B,$86	; $80B10A
	db $0A,$A2,$0E,$00,$68,$95,$33,$CA,$CA,$10,$F9,$A6,$0A,$86,$0A,$A2	; $80B11A
	db $12,$00,$68,$95,$53,$CA,$CA,$10,$F9,$A6,$0A,$A6,$3F,$6B	; $80B12A
CODE_80B138:		; M=16 X=16
	lda.w $0B9F,x		; $80B138: BD 9F 0B
	sta.b $53		; $80B13B: 85 53
	bmi CODE_80B155		; $80B13D: 30 16
	lda.w #$B156		; $80B13F: A9 56 B1
	sta.b $33		; $80B142: 85 33
	lda.w #$0080		; $80B144: A9 80 00
	sta.b $35		; $80B147: 85 35
	ldy.b $53		; $80B149: A4 53
	lda.b [$33],y		; $80B14B: B7 33
	and.w #$00FF		; $80B14D: 29 FF 00
	sta.b $53		; $80B150: 85 53
	jmp.w $B4A7		; $80B152: 4C A7 B4
CODE_80B155:		; M=16 X=16
	rtl		; $80B155: 6B
	db $0E,$02,$02,$03,$05,$03,$05	; $80B156
CODE_80B15D:		; M=16 X=16
	phx		; $80B15D: DA
	phy		; $80B15E: 5A
	lda.w $0EDF,x		; $80B15F: BD DF 0E
	and.w #$FFFB		; $80B162: 29 FB FF
	sta.w $0EDF,x		; $80B165: 9D DF 0E
	stz.b $33		; $80B168: 64 33
	lda.w $119F,x		; $80B16A: BD 9F 11
	beq CODE_80B173		; $80B16D: F0 04
	inc.b $33		; $80B16F: E6 33
	inc.b $33		; $80B171: E6 33
CODE_80B173:		; M=16 X=16
	lda.b $5F		; $80B173: A5 5F
	and.w #$00FF		; $80B175: 29 FF 00
	sta.w $0F1F,x		; $80B178: 9D 1F 0F
	asl a		; $80B17B: 0A
	sta.b $5F		; $80B17C: 85 5F
	lda.w #$000A		; $80B17E: A9 0A 00
	sta.b $53		; $80B181: 85 53
	lda.b $33		; $80B183: A5 33
	beq CODE_80B18A		; $80B185: F0 03
	lda.w #$0034		; $80B187: A9 34 00
CODE_80B18A:		; M=16 X=16
	adc.b $5F		; $80B18A: 65 5F
	tay		; $80B18C: A8
	lda.w $14E2,y		; $80B18D: B9 E2 14
	sta.b $57		; $80B190: 85 57
	bpl CODE_80B1A0		; $80B192: 10 0C
	lda.w #$0009		; $80B194: A9 09 00
	sta.b $53		; $80B197: 85 53
	lda.b $57		; $80B199: A5 57
	cmp.w #$FFFE		; $80B19B: C9 FE FF
	bne CODE_80B1AA		; $80B19E: D0 0A
CODE_80B1A0:		; M=16 X=16
	jsl.l $80B49D		; $80B1A0: 22 9D B4 80
	stz.w $117F,x		; $80B1A4: 9E 7F 11
	stz.w $0DFF,x		; $80B1A7: 9E FF 0D
CODE_80B1AA:		; M=16 X=16
	lda.b $33		; $80B1AA: A5 33
	beq CODE_80B1B1		; $80B1AC: F0 03
	lda.w #$0034		; $80B1AE: A9 34 00
CODE_80B1B1:		; M=16 X=16
	clc		; $80B1B1: 18
	adc.b $5F		; $80B1B2: 65 5F
	tay		; $80B1B4: A8
	lda.w #$FFFF		; $80B1B5: A9 FF FF
	sta.w $14E2,y		; $80B1B8: 99 E2 14
	lsr.b $5F		; $80B1BB: 46 5F
	ldy.b $33		; $80B1BD: A4 33
	lda.w $13CE,y		; $80B1BF: B9 CE 13
	sta.b $33		; $80B1C2: 85 33
	lda.w #$0083		; $80B1C4: A9 83 00
	sta.b $35		; $80B1C7: 85 35
	stx.b $0A		; $80B1C9: 86 0A
	ldx.w #$0000		; $80B1CB: A2 00 00
CODE_80B1CE:		; M=16 X=16
	lda.b $33,x		; $80B1CE: B5 33
	pha		; $80B1D0: 48
	inx		; $80B1D1: E8
	inx		; $80B1D2: E8
	cpx.w #$0004		; $80B1D3: E0 04 00
	bne CODE_80B1CE		; $80B1D6: D0 F6
	ldx.b $0A		; $80B1D8: A6 0A
	ldy.w #$0008		; $80B1DA: A0 08 00
	lda.b [$33],y		; $80B1DD: B7 33
	clc		; $80B1DF: 18
	adc.b $33		; $80B1E0: 65 33
	sta.b $33		; $80B1E2: 85 33
	stz.w $0475		; $80B1E4: 9C 75 04
	stz.w $0441		; $80B1E7: 9C 41 04
	stz.b $F0		; $80B1EA: 64 F0
	stz.w $015A		; $80B1EC: 9C 5A 01
	lda.w $0B9F,x		; $80B1EF: BD 9F 0B
	bne CODE_80B1F7		; $80B1F2: D0 03
	jmp.w $B298		; $80B1F4: 4C 98 B2
CODE_80B1F7:		; M=16 X=16
	lda.w $128C		; $80B1F7: AD 8C 12
	bit.w #$2000		; $80B1FA: 89 00 20
	beq CODE_80B225		; $80B1FD: F0 26
	jsl.l $808D9F		; $80B1FF: 22 9F 8D 80
	beq CODE_80B212		; $80B203: F0 0D
	ldy.w #$0001		; $80B205: A0 01 00
	lda.b [$33],y		; $80B208: B7 33
	and.w #$000F		; $80B20A: 29 0F 00
	sta.w $0475		; $80B20D: 8D 75 04
	bra CODE_80B225		; $80B210: 80 13
CODE_80B212:		; M=16 X=16
	ldy.w #$0001		; $80B212: A0 01 00
	lda.b [$33],y		; $80B215: B7 33
	lsr a		; $80B217: 4A
	lsr a		; $80B218: 4A
	lsr a		; $80B219: 4A
	lsr a		; $80B21A: 4A
	and.w #$000F		; $80B21B: 29 0F 00
	eor.w #$FFFF		; $80B21E: 49 FF FF
	inc a		; $80B221: 1A
	sta.w $0441		; $80B222: 8D 41 04
CODE_80B225:		; M=16 X=16
	ldy.w #$0002		; $80B225: A0 02 00
	lda.b [$33],y		; $80B228: B7 33
	and.w #$000F		; $80B22A: 29 0F 00
	eor.w #$FFFF		; $80B22D: 49 FF FF
	inc a		; $80B230: 1A
	sta.b $53		; $80B231: 85 53
	lda.w $119F,x		; $80B233: BD 9F 11
	bne CODE_80B243		; $80B236: D0 0B
	lda.b [$33],y		; $80B238: B7 33
	lsr a		; $80B23A: 4A
	lsr a		; $80B23B: 4A
	lsr a		; $80B23C: 4A
	lsr a		; $80B23D: 4A
	and.w #$000F		; $80B23E: 29 0F 00
	sta.b $53		; $80B241: 85 53
CODE_80B243:		; M=16 X=16
	lda.b $53		; $80B243: A5 53
	sta.w $015A		; $80B245: 8D 5A 01
	lda.w $12F0		; $80B248: AD F0 12
	sec		; $80B24B: 38
	sbc.w #$0002		; $80B24C: E9 02 00
	bmi CODE_80B255		; $80B24F: 30 04
	bvc CODE_80B257		; $80B251: 50 04
	bra CODE_80B298		; $80B253: 80 43
CODE_80B255:		; M=16 X=16
	bvc CODE_80B298		; $80B255: 50 41
CODE_80B257:		; M=16 X=16
	beq CODE_80B261		; $80B257: F0 08
	bmi CODE_80B25F		; $80B259: 30 04
	bvs CODE_80B261		; $80B25B: 70 04
	bra CODE_80B277		; $80B25D: 80 18
CODE_80B25F:		; M=16 X=16
	bvs CODE_80B277		; $80B25F: 70 16
CODE_80B261:		; M=16 X=16
	jsl.l $86FCA1		; $80B261: 22 A1 FC 86
	lsr.b $53		; $80B265: 46 53
	lda.b $53		; $80B267: A5 53
	sec		; $80B269: 38
	sbc.w $12F2		; $80B26A: ED F2 12
	beq CODE_80B277		; $80B26D: F0 08
	bmi CODE_80B275		; $80B26F: 30 04
	bvs CODE_80B277		; $80B271: 70 04
	bra CODE_80B298		; $80B273: 80 23
CODE_80B275:		; M=16 X=16
	bvs CODE_80B298		; $80B275: 70 21
CODE_80B277:		; M=16 X=16
	lda.w $13D6		; $80B277: AD D6 13
	sec		; $80B27A: 38
	sbc.w $13D8		; $80B27B: ED D8 13
	sta.b $73		; $80B27E: 85 73
	beq CODE_80B293		; $80B280: F0 11
	lda.w $119F,x		; $80B282: BD 9F 11
	beq CODE_80B28F		; $80B285: F0 08
	lda.b $73		; $80B287: A5 73
	eor.w #$FFFF		; $80B289: 49 FF FF
	inc a		; $80B28C: 1A
	sta.b $73		; $80B28D: 85 73
CODE_80B28F:		; M=16 X=16
	lda.b $73		; $80B28F: A5 73
	bpl CODE_80B298		; $80B291: 10 05
CODE_80B293:		; M=16 X=16
	lda.w #$0002		; $80B293: A9 02 00
	sta.b $F0		; $80B296: 85 F0
CODE_80B298:		; M=16 X=16
	stx.b $0A		; $80B298: 86 0A
	ldx.w #$0002		; $80B29A: A2 02 00
CODE_80B29D:		; M=16 X=16
	pla		; $80B29D: 68
	sta.b $33,x		; $80B29E: 95 33
	dex		; $80B2A0: CA
	dex		; $80B2A1: CA
	bpl CODE_80B29D		; $80B2A2: 10 F9
	ldx.b $0A		; $80B2A4: A6 0A
	ldy.w #$0000		; $80B2A6: A0 00 00
	lda.b [$33],y		; $80B2A9: B7 33
	clc		; $80B2AB: 18
	adc.b $33		; $80B2AC: 65 33
	sta.b $33		; $80B2AE: 85 33
CODE_80B2B0:		; M=16 X=16
	lda.b [$33]		; $80B2B0: A7 33
	clc		; $80B2B2: 18
	adc.b $33		; $80B2B3: 65 33
	adc.w #$0008		; $80B2B5: 69 08 00
	sta.b $33		; $80B2B8: 85 33
	dec.b $5F		; $80B2BA: C6 5F
	bpl CODE_80B2B0		; $80B2BC: 10 F2
	lda.b $33		; $80B2BE: A5 33
	sec		; $80B2C0: 38
	sbc.w #$0008		; $80B2C1: E9 08 00
	sta.b $33		; $80B2C4: 85 33
	lda.b [$33]		; $80B2C6: A7 33
	and.w #$00FF		; $80B2C8: 29 FF 00
	sta.w $103F,x		; $80B2CB: 9D 3F 10
	ldy.w #$0001		; $80B2CE: A0 01 00
	lda.b [$33],y		; $80B2D1: B7 33
	and.w #$00F0		; $80B2D3: 29 F0 00
	lsr a		; $80B2D6: 4A
	sta.w $0F3F,x		; $80B2D7: 9D 3F 0F
	lda.b [$33],y		; $80B2DA: B7 33
	and.w #$000F		; $80B2DC: 29 0F 00
	sta.w $0F5F,x		; $80B2DF: 9D 5F 0F
	iny		; $80B2E2: C8
	lda.b [$33],y		; $80B2E3: B7 33
	lsr a		; $80B2E5: 4A
	lsr a		; $80B2E6: 4A
	lsr a		; $80B2E7: 4A
	lsr a		; $80B2E8: 4A
	and.w #$000F		; $80B2E9: 29 0F 00
	sta.w $0F7F,x		; $80B2EC: 9D 7F 0F
	lda.b [$33],y		; $80B2EF: B7 33
	and.w #$000F		; $80B2F1: 29 0F 00
	clc		; $80B2F4: 18
	adc.w $0475		; $80B2F5: 6D 75 04
	clc		; $80B2F8: 18
	adc.w $0441		; $80B2F9: 6D 41 04
	clc		; $80B2FC: 18
	adc.w $015A		; $80B2FD: 6D 5A 01
	clc		; $80B300: 18
	adc.b $F0		; $80B301: 65 F0
	jsl.l $80B3E7		; $80B303: 22 E7 B3 80
	eor.w #$000F		; $80B307: 49 0F 00
	clc		; $80B30A: 18
	adc.w #$000F		; $80B30B: 69 0F 00
	lsr a		; $80B30E: 4A
	sta.w $0F9F,x		; $80B30F: 9D 9F 0F
	iny		; $80B312: C8
	lda.b [$33],y		; $80B313: B7 33
	lsr a		; $80B315: 4A
	lsr a		; $80B316: 4A
	lsr a		; $80B317: 4A
	lsr a		; $80B318: 4A
	and.w #$000F		; $80B319: 29 0F 00
	clc		; $80B31C: 18
	adc.w $015A		; $80B31D: 6D 5A 01
	jsl.l $80B3E7		; $80B320: 22 E7 B3 80
	eor.w #$000F		; $80B324: 49 0F 00
	clc		; $80B327: 18
	adc.w #$000F		; $80B328: 69 0F 00
	lsr a		; $80B32B: 4A
	sta.w $0FBF,x		; $80B32C: 9D BF 0F
	lda.b [$33],y		; $80B32F: B7 33
	and.w #$000F		; $80B331: 29 0F 00
	sta.w $0FDF,x		; $80B334: 9D DF 0F
	lda.w $09DF,x		; $80B337: BD DF 09
	and.w #$F7FF		; $80B33A: 29 FF F7
	sta.w $09DF,x		; $80B33D: 9D DF 09
	iny		; $80B340: C8
	lda.b [$33],y		; $80B341: B7 33
	lsr a		; $80B343: 4A
	lsr a		; $80B344: 4A
	lsr a		; $80B345: 4A
	lsr a		; $80B346: 4A
	and.w #$000F		; $80B347: 29 0F 00
	clc		; $80B34A: 18
	adc.b $F0		; $80B34B: 65 F0
	jsl.l $80B3E7		; $80B34D: 22 E7 B3 80
	sta.w $10FF,x		; $80B351: 9D FF 10
	lda.b [$33],y		; $80B354: B7 33
	and.w #$0001		; $80B356: 29 01 00
	sta.w $111F,x		; $80B359: 9D 1F 11
	bne CODE_80B367		; $80B35C: D0 09
	lda.w $09DF,x		; $80B35E: BD DF 09
	ora.w #$0800		; $80B361: 09 00 08
	sta.w $09DF,x		; $80B364: 9D DF 09
CODE_80B367:		; M=16 X=16
	lda.b [$33],y		; $80B367: B7 33
	and.w #$000E		; $80B369: 29 0E 00
	sta.w $10DF,x		; $80B36C: 9D DF 10
	iny		; $80B36F: C8
	lda.b [$33],y		; $80B370: B7 33
	lsr a		; $80B372: 4A
	lsr a		; $80B373: 4A
	lsr a		; $80B374: 4A
	lsr a		; $80B375: 4A
	and.w #$000F		; $80B376: 29 0F 00
	clc		; $80B379: 18
	adc.w $0475		; $80B37A: 6D 75 04
	clc		; $80B37D: 18
	adc.w $0441		; $80B37E: 6D 41 04
	clc		; $80B381: 18
	adc.w $015A		; $80B382: 6D 5A 01
	jsl.l $80B3E7		; $80B385: 22 E7 B3 80
	sta.w $107F,x		; $80B389: 9D 7F 10
	lda.b [$33],y		; $80B38C: B7 33
	and.w #$000F		; $80B38E: 29 0F 00
	clc		; $80B391: 18
	adc.w $0475		; $80B392: 6D 75 04
	clc		; $80B395: 18
	adc.w $0441		; $80B396: 6D 41 04
	clc		; $80B399: 18
	adc.w $015A		; $80B39A: 6D 5A 01
	jsl.l $80B3E7		; $80B39D: 22 E7 B3 80
	sta.w $0FFF,x		; $80B3A1: 9D FF 0F
	iny		; $80B3A4: C8
	lda.b [$33],y		; $80B3A5: B7 33
	lsr a		; $80B3A7: 4A
	lsr a		; $80B3A8: 4A
	lsr a		; $80B3A9: 4A
	lsr a		; $80B3AA: 4A
	and.w #$000F		; $80B3AB: 29 0F 00
	sta.w $109F,x		; $80B3AE: 9D 9F 10
	lda.b [$33],y		; $80B3B1: B7 33
	and.w #$000F		; $80B3B3: 29 0F 00
	clc		; $80B3B6: 18
	adc.b $F0		; $80B3B7: 65 F0
	clc		; $80B3B9: 18
	adc.b $F0		; $80B3BA: 65 F0
	jsl.l $80B3E7		; $80B3BC: 22 E7 B3 80
	sta.w $105F,x		; $80B3C0: 9D 5F 10
	iny		; $80B3C3: C8
	lda.b [$33],y		; $80B3C4: B7 33
	lsr a		; $80B3C6: 4A
	lsr a		; $80B3C7: 4A
	lsr a		; $80B3C8: 4A
	lsr a		; $80B3C9: 4A
	and.w #$000F		; $80B3CA: 29 0F 00
	clc		; $80B3CD: 18
	adc.w $0475		; $80B3CE: 6D 75 04
	clc		; $80B3D1: 18
	adc.w $015A		; $80B3D2: 6D 5A 01
	jsl.l $80B3E7		; $80B3D5: 22 E7 B3 80
	sta.w $101F,x		; $80B3D9: 9D 1F 10
	lda.b [$33],y		; $80B3DC: B7 33
	and.w #$000F		; $80B3DE: 29 0F 00
	sta.w $10BF,x		; $80B3E1: 9D BF 10
	ply		; $80B3E4: 7A
	plx		; $80B3E5: FA
	rtl		; $80B3E6: 6B
CODE_80B3E7:		; M=16 X=16
	bit.w #$0080		; $80B3E7: 89 80 00
	beq CODE_80B3EF		; $80B3EA: F0 03
	lda.w #$0000		; $80B3EC: A9 00 00
CODE_80B3EF:		; M=16 X=16
	cmp.w #$000F		; $80B3EF: C9 0F 00
	bcc CODE_80B3F7		; $80B3F2: 90 03
	lda.w #$000F		; $80B3F4: A9 0F 00
CODE_80B3F7:		; M=16 X=16
	rtl		; $80B3F7: 6B
	db $86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$0C,$00,$D0,$F6,$A6	; $80B3F8
	db $0A,$86,$0A,$A2,$00,$00,$B5,$33,$48,$E8,$E8,$E0,$10,$00,$D0,$F6	; $80B408
	db $A6,$0A,$64,$3B,$22,$48,$B4,$80,$A9,$02,$00,$85,$3B,$22,$48,$B4	; $80B418
	db $80,$86,$0A,$A2,$0E,$00,$68,$95,$33,$CA,$CA,$10,$F9,$A6,$0A,$86	; $80B428
	db $0A,$A2,$0A,$00,$68,$95,$53,$CA,$CA,$10,$F9,$A6,$0A,$A6,$3F,$6B	; $80B438
	db $A4,$3B,$B9,$0A,$14,$29,$EF,$FF,$99,$0A,$14,$A9,$05,$00,$85,$5B	; $80B448
	db $BE,$D2,$13,$86,$3F,$9E,$5F,$11,$9E,$DF,$11,$BD,$DF,$0E,$29,$FF	; $80B458
	db $0F,$9D,$DF,$0E,$BD,$9F,$0B,$30,$21,$A9,$78,$04,$85,$57,$22,$06	; $80B468
	db $B0,$80,$9E,$7F,$0B,$9E,$5F,$0E,$BD,$DF,$0E,$29,$F6,$FF,$9D,$DF	; $80B478
	db $0E,$9E,$FF,$11,$9E,$BF,$11,$9E,$7F,$11,$E6,$3F,$E6,$3F,$A6,$3F	; $80B488
	db $C6,$5B,$10,$C1,$6B	; $80B498
CODE_80B49D:		; M=16 X=16
	lda.w $0BBF,x		; $80B49D: BD BF 0B
	dec a		; $80B4A0: 3A
	and.w #$0007		; $80B4A1: 29 07 00
	sta.w $0BBF,x		; $80B4A4: 9D BF 0B
CODE_80B4A7:		; M=16 X=16
	lda.w $0EDF,x		; $80B4A7: BD DF 0E
	ora.w #$0002		; $80B4AA: 09 02 00
	sta.w $0EDF,x		; $80B4AD: 9D DF 0E
	txa		; $80B4B0: 8A
	asl a		; $80B4B1: 0A
	asl a		; $80B4B2: 0A
	adc.w $0BBF,x		; $80B4B3: 7D BF 0B
	tay		; $80B4B6: A8
	sep #$20		; $80B4B7: E2 20
	lda.b $53		; $80B4B9: A5 53
	sta.w $0BDF,y		; $80B4BB: 99 DF 0B
	rep #$30		; $80B4BE: C2 30
	rtl		; $80B4C0: 6B
CODE_80B4C1:		; M=16 X=16
	jsl.l $8FE404		; $80B4C1: 22 04 E4 8F
	lda.w #$0207		; $80B4C5: A9 07 02
	sta.w $1BD9		; $80B4C8: 8D D9 1B
	clc		; $80B4CB: 18
	adc.w #$0037		; $80B4CC: 69 37 00
	sta.w $1BD3		; $80B4CF: 8D D3 1B
	adc.w #$000E		; $80B4D2: 69 0E 00
	sta.w $1BDF		; $80B4D5: 8D DF 1B
	adc.w #$0068		; $80B4D8: 69 68 00
	sta.w $1BE1		; $80B4DB: 8D E1 1B
	adc.w #$0075		; $80B4DE: 69 75 00
	sta.w $1BE7		; $80B4E1: 8D E7 1B
	inc a		; $80B4E4: 1A
	sta.w $1BD7		; $80B4E5: 8D D7 1B
	adc.w #$0064		; $80B4E8: 69 64 00
	sta.w $1BDB		; $80B4EB: 8D DB 1B
	adc.w #$0004		; $80B4EE: 69 04 00
	sta.w $1BD1		; $80B4F1: 8D D1 1B
	adc.w #$0090		; $80B4F4: 69 90 00
	sta.w $1BE5		; $80B4F7: 8D E5 1B
	adc.w #$0195		; $80B4FA: 69 95 01
	sta.w $1BD5		; $80B4FD: 8D D5 1B
	lda.w #$FF00		; $80B500: A9 00 FF
	sta.w $1BCD		; $80B503: 8D CD 1B
	stz.w $1BCF		; $80B506: 9C CF 1B
	jsl.l $8D8120		; $80B509: 22 20 81 8D
	sep #$20		; $80B50D: E2 20
	cli		; $80B50F: 58
	lda.w $4210		; $80B510: AD 10 42
	lda.b #$81		; $80B513: A9 81
	sta.w $4200		; $80B515: 8D 00 42
	lda.b #$03		; $80B518: A9 03
	sta.w $2101		; $80B51A: 8D 01 21
	lda.b #$01		; $80B51D: A9 01
	sta.w $2105		; $80B51F: 8D 05 21
	lda.b #$00		; $80B522: A9 00
	sta.w $2107		; $80B524: 8D 07 21
	lda.b #$05		; $80B527: A9 05
	sta.w $2108		; $80B529: 8D 08 21
	lda.b #$12		; $80B52C: A9 12
	sta.w $210B		; $80B52E: 8D 0B 21
	lda.b #$13		; $80B531: A9 13
	sta.w $212C		; $80B533: 8D 2C 21
	rep #$30		; $80B536: C2 30
	ldx.w #$00FE		; $80B538: A2 FE 00
CODE_80B53B:		; M=16 X=16
	lda.l $83F72B,x		; $80B53B: BF 2B F7 83
	sta.l $7E6C74,x		; $80B53F: 9F 74 6C 7E
	sta.l $7E6D74,x		; $80B543: 9F 74 6D 7E
	dex		; $80B547: CA
	dex		; $80B548: CA
	bpl CODE_80B53B		; $80B549: 10 F0
	jsl.l $82FA1A		; $80B54B: 22 1A FA 82
	lda.w $164F		; $80B54F: AD 4F 16
	cmp.w #$0001		; $80B552: C9 01 00
	beq CODE_80B55B		; $80B555: F0 04
	jsl.l $82FA7A		; $80B557: 22 7A FA 82
CODE_80B55B:		; M=16 X=16
	lda.w #$CDA0		; $80B55B: A9 A0 CD
	sta.b $73		; $80B55E: 85 73
	lda.w #$0082		; $80B560: A9 82 00
	sta.b $75		; $80B563: 85 75
	jsl.l $86FA3E		; $80B565: 22 3E FA 86
	lda.w #$1000		; $80B569: A9 00 10
	sta.w $2116		; $80B56C: 8D 16 21
	ldx.w #$0000		; $80B56F: A2 00 00
CODE_80B572:		; M=16 X=16
	lda.l $7F0000,x		; $80B572: BF 00 00 7F
	sta.w $2118		; $80B576: 8D 18 21
	inx		; $80B579: E8
	inx		; $80B57A: E8
	cpx.w #$40E0		; $80B57B: E0 E0 40
	bne CODE_80B572		; $80B57E: D0 F2
	lda.w #$C6B4		; $80B580: A9 B4 C6
	sta.b $73		; $80B583: 85 73
	lda.w #$0087		; $80B585: A9 87 00
	sta.b $75		; $80B588: 85 75
	jsl.l $86FA3E		; $80B58A: 22 3E FA 86
	ldx.w #$0000		; $80B58E: A2 00 00
CODE_80B591:		; M=16 X=16
	lda.l $7F0000,x		; $80B591: BF 00 00 7F
	sta.w $2118		; $80B595: 8D 18 21
	inx		; $80B598: E8
	inx		; $80B599: E8
	cpx.w #$06E0		; $80B59A: E0 E0 06
	bne CODE_80B591		; $80B59D: D0 F2
	lda.w #$F386		; $80B59F: A9 86 F3
	sta.b $73		; $80B5A2: 85 73
	lda.w #$0084		; $80B5A4: A9 84 00
	sta.b $75		; $80B5A7: 85 75
	jsl.l $86FA3E		; $80B5A9: 22 3E FA 86
	ldx.w #$0000		; $80B5AD: A2 00 00
CODE_80B5B0:		; M=16 X=16
	lda.l $7F0000,x		; $80B5B0: BF 00 00 7F
	sta.w $2118		; $80B5B4: 8D 18 21
	inx		; $80B5B7: E8
	inx		; $80B5B8: E8
	cpx.w #$01C0		; $80B5B9: E0 C0 01
	bne CODE_80B5B0		; $80B5BC: D0 F2
	lda.w #$EB45		; $80B5BE: A9 45 EB
	sta.b $73		; $80B5C1: 85 73
	lda.w #$0089		; $80B5C3: A9 89 00
	sta.b $75		; $80B5C6: 85 75
	jsl.l $86FA3E		; $80B5C8: 22 3E FA 86
	ldx.w #$0000		; $80B5CC: A2 00 00
CODE_80B5CF:		; M=16 X=16
	lda.l $7F0000,x		; $80B5CF: BF 00 00 7F
	sta.w $2118		; $80B5D3: 8D 18 21
	inx		; $80B5D6: E8
	inx		; $80B5D7: E8
	cpx.w #$0D00		; $80B5D8: E0 00 0D
	bne CODE_80B5CF		; $80B5DB: D0 F2
	lda.w #$F55E		; $80B5DD: A9 5E F5
	sta.b $73		; $80B5E0: 85 73
	lda.w #$0087		; $80B5E2: A9 87 00
	sta.b $75		; $80B5E5: 85 75
	jsl.l $86FA3E		; $80B5E7: 22 3E FA 86
	ldx.w #$0000		; $80B5EB: A2 00 00
CODE_80B5EE:		; M=16 X=16
	lda.l $7F0000,x		; $80B5EE: BF 00 00 7F
	sta.w $2118		; $80B5F2: 8D 18 21
	inx		; $80B5F5: E8
	inx		; $80B5F6: E8
	cpx.w #$0EA0		; $80B5F7: E0 A0 0E
	bne CODE_80B5EE		; $80B5FA: D0 F2
	ldx.w #$0010		; $80B5FC: A2 10 00
CODE_80B5FF:		; M=16 X=16
	stz.w $2118		; $80B5FF: 9C 18 21
	dex		; $80B602: CA
	bne CODE_80B5FF		; $80B603: D0 FA
	lda.w #$C6D8		; $80B605: A9 D8 C6
	sta.b $73		; $80B608: 85 73
	lda.w #$0083		; $80B60A: A9 83 00
	sta.b $75		; $80B60D: 85 75
	jsl.l $86FA3E		; $80B60F: 22 3E FA 86
	stz.b $33		; $80B613: 64 33
	lda.w #$007F		; $80B615: A9 7F 00
	sta.b $35		; $80B618: 85 35
	lda.w #$FCD4		; $80B61A: A9 D4 FC
	sta.b $37		; $80B61D: 85 37
	lda.w #$0082		; $80B61F: A9 82 00
	sta.b $39		; $80B622: 85 39
	lda.w #$0064		; $80B624: A9 64 00
	sta.b $53		; $80B627: 85 53
	jsl.l $8FE0E4		; $80B629: 22 E4 E0 8F
	lda.w #$872E		; $80B62D: A9 2E 87
	sta.b $33		; $80B630: 85 33
	lda.w #$0088		; $80B632: A9 88 00
	sta.b $35		; $80B635: 85 35
	lda.w #$F55A		; $80B637: A9 5A F5
	sta.b $37		; $80B63A: 85 37
	lda.w #$0087		; $80B63C: A9 87 00
	sta.b $39		; $80B63F: 85 39
	lda.w #$0004		; $80B641: A9 04 00
	sta.b $53		; $80B644: 85 53
	jsl.l $8FE0E4		; $80B646: 22 E4 E0 8F
	lda.w #$EEC8		; $80B64A: A9 C8 EE
	sta.b $73		; $80B64D: 85 73
	lda.w #$008D		; $80B64F: A9 8D 00
	sta.b $75		; $80B652: 85 75
	jsl.l $86FA3E		; $80B654: 22 3E FA 86
	stz.b $33		; $80B658: 64 33
	lda.w #$007F		; $80B65A: A9 7F 00
	sta.b $35		; $80B65D: 85 35
	lda.w #$FCBD		; $80B65F: A9 BD FC
	sta.b $37		; $80B662: 85 37
	lda.w #$0082		; $80B664: A9 82 00
	sta.b $39		; $80B667: 85 39
	lda.w #$0090		; $80B669: A9 90 00
	sta.b $53		; $80B66C: 85 53
	jsl.l $8FE0E4		; $80B66E: 22 E4 E0 8F
	lda.w #$03E7		; $80B672: A9 E7 03
	sta.w $049B		; $80B675: 8D 9B 04
	lda.w #$0001		; $80B678: A9 01 00
	trb.w $128C		; $80B67B: 1C 8C 12
	stz.w $0154		; $80B67E: 9C 54 01
	stz.w $08DF		; $80B681: 9C DF 08
	lda.b $02		; $80B684: A5 02
	dec a		; $80B686: 3A
	dec a		; $80B687: 3A
	sta.w $08FD		; $80B688: 8D FD 08
	jsl.l $84F816		; $80B68B: 22 16 F8 84
	stz.w $08DD		; $80B68F: 9C DD 08
	jsl.l $80B76B		; $80B692: 22 6B B7 80
	lda.w $1288		; $80B696: AD 88 12
	bit.w #$0002		; $80B699: 89 02 00
	beq CODE_80B6AE		; $80B69C: F0 10
	ldx.w #$0016		; $80B69E: A2 16 00
CODE_80B6A1:		; M=16 X=16
	lda.w $113F,x		; $80B6A1: BD 3F 11
	eor.w #$0001		; $80B6A4: 49 01 00
	sta.w $113F,x		; $80B6A7: 9D 3F 11
	dex		; $80B6AA: CA
	dex		; $80B6AB: CA
	bpl CODE_80B6A1		; $80B6AC: 10 F3
CODE_80B6AE:		; M=16 X=16
	jsl.l $80B6D5		; $80B6AE: 22 D5 B6 80
	lda.w #$FFFF		; $80B6B2: A9 FF FF
	sta.w $0431		; $80B6B5: 8D 31 04
	stz.w $0433		; $80B6B8: 9C 33 04
	stz.w $0435		; $80B6BB: 9C 35 04
	stz.w $0437		; $80B6BE: 9C 37 04
	stz.w $0439		; $80B6C1: 9C 39 04
	lda.w #$FFFF		; $80B6C4: A9 FF FF
	sta.w $1292		; $80B6C7: 8D 92 12
	sta.w $1294		; $80B6CA: 8D 94 12
	stz.b $04		; $80B6CD: 64 04
	lda.w #$000A		; $80B6CF: A9 0A 00
	sta.b $08		; $80B6D2: 85 08
	rtl		; $80B6D4: 6B
CODE_80B6D5:		; M=16 X=16
	stz.w $0106		; $80B6D5: 9C 06 01
	stz.w $08B7		; $80B6D8: 9C B7 08
	stz.w $08B9		; $80B6DB: 9C B9 08
	jsl.l $80B706		; $80B6DE: 22 06 B7 80
	lda.w #$2200		; $80B6E2: A9 00 22
	sta.w $4370		; $80B6E5: 8D 70 43
	lda.w #$6C74		; $80B6E8: A9 74 6C
	sta.w $4372		; $80B6EB: 8D 72 43
	lda.w #$0200		; $80B6EE: A9 00 02
	sta.w $4375		; $80B6F1: 8D 75 43
	sep #$20		; $80B6F4: E2 20
	stz.w $2121		; $80B6F6: 9C 21 21
	lda.b #$7E		; $80B6F9: A9 7E
	sta.w $4374		; $80B6FB: 8D 74 43
	lda.b #$80		; $80B6FE: A9 80
	sta.w $420B		; $80B700: 8D 0B 42
	rep #$30		; $80B703: C2 30
	rtl		; $80B705: 6B
CODE_80B706:		; M=16 X=16
	phx		; $80B706: DA
	phy		; $80B707: 5A
	ldx.w #$0000		; $80B708: A2 00 00
	lda.w $13CE		; $80B70B: AD CE 13
	sta.b $73		; $80B70E: 85 73
	lda.w #$0083		; $80B710: A9 83 00
	sta.b $75		; $80B713: 85 75
	stz.b $78		; $80B715: 64 78
	jsl.l $80B72C		; $80B717: 22 2C B7 80
	lda.w $13D0		; $80B71B: AD D0 13
	sta.b $73		; $80B71E: 85 73
	lda.w #$0020		; $80B720: A9 20 00
	sta.b $78		; $80B723: 85 78
	jsl.l $80B72C		; $80B725: 22 2C B7 80
	ply		; $80B729: 7A
	plx		; $80B72A: FA
	rtl		; $80B72B: 6B
CODE_80B72C:		; M=16 X=16
	ldy.w #$0002		; $80B72C: A0 02 00
	lda.b [$73],y		; $80B72F: B7 73
	clc		; $80B731: 18
	adc.b $78		; $80B732: 65 78
	tay		; $80B734: A8
	lda.w #$0010		; $80B735: A9 10 00
	sta.b $78		; $80B738: 85 78
CODE_80B73A:		; M=16 X=16
	lda.b [$73],y		; $80B73A: B7 73
	xba		; $80B73C: EB
	and.w #$000F		; $80B73D: 29 0F 00
	asl a		; $80B740: 0A
	sta.b $76		; $80B741: 85 76
	lda.b [$73],y		; $80B743: B7 73
	xba		; $80B745: EB
	and.w #$00F0		; $80B746: 29 F0 00
	asl a		; $80B749: 0A
	asl a		; $80B74A: 0A
	ora.b $76		; $80B74B: 05 76
	sta.b $76		; $80B74D: 85 76
	lda.b [$73],y		; $80B74F: B7 73
	xba		; $80B751: EB
	and.w #$0F00		; $80B752: 29 00 0F
	asl a		; $80B755: 0A
	asl a		; $80B756: 0A
	asl a		; $80B757: 0A
	ora.b $76		; $80B758: 05 76
	sta.l $7E6CB4,x		; $80B75A: 9F B4 6C 7E
	sta.l $7E6DB4,x		; $80B75E: 9F B4 6D 7E
	inx		; $80B762: E8
	inx		; $80B763: E8
	iny		; $80B764: C8
	iny		; $80B765: C8
	dec.b $78		; $80B766: C6 78
	bne CODE_80B73A		; $80B768: D0 D0
	rtl		; $80B76A: 6B
CODE_80B76B:		; M=16 X=16
	rtl		; $80B76B: 6B
CODE_80B76C:		; M=16 X=16
	phx		; $80B76C: DA
	phy		; $80B76D: 5A
	stx.b $0A		; $80B76E: 86 0A
	ldx.w #$0000		; $80B770: A2 00 00
CODE_80B773:		; M=16 X=16
	lda.b $53,x		; $80B773: B5 53
	pha		; $80B775: 48
	inx		; $80B776: E8
	inx		; $80B777: E8
	cpx.w #$000C		; $80B778: E0 0C 00
	bne CODE_80B773		; $80B77B: D0 F6
	ldx.b $0A		; $80B77D: A6 0A
	ldx.w #$0000		; $80B77F: A2 00 00
	lda.w $128E		; $80B782: AD 8E 12
	bne CODE_80B796		; $80B785: D0 0F
CODE_80B787:		; M=16 X=16
	lda.w $095F,x		; $80B787: BD 5F 09
	sta.w $121F,x		; $80B78A: 9D 1F 12
	inx		; $80B78D: E8
	inx		; $80B78E: E8
	cpx.w #$0020		; $80B78F: E0 20 00
	bne CODE_80B787		; $80B792: D0 F3
	bra CODE_80B7A3		; $80B794: 80 0D
CODE_80B796:		; M=16 X=16
	lda.w $08FF,x		; $80B796: BD FF 08
	sta.w $121F,x		; $80B799: 9D 1F 12
	inx		; $80B79C: E8
	inx		; $80B79D: E8
	cpx.w #$0020		; $80B79E: E0 20 00
	bne CODE_80B796		; $80B7A1: D0 F3
CODE_80B7A3:		; M=16 X=16
	stz.b $5B		; $80B7A3: 64 5B
	ldx.w #$0000		; $80B7A5: A2 00 00
CODE_80B7A8:		; M=16 X=16
	lda.w $1260,x		; $80B7A8: BD 60 12
	and.w #$00FF		; $80B7AB: 29 FF 00
	sta.b $57		; $80B7AE: 85 57
	lda.w $125F,x		; $80B7B0: BD 5F 12
	and.w #$00FF		; $80B7B3: 29 FF 00
	sta.b $53		; $80B7B6: 85 53
	tay		; $80B7B8: A8
	lda.w $121F,y		; $80B7B9: B9 1F 12
	ldy.b $57		; $80B7BC: A4 57
	sec		; $80B7BE: 38
	sbc.w $121F,y		; $80B7BF: F9 1F 12
	beq CODE_80B7DF		; $80B7C2: F0 1B
	bmi CODE_80B7CA		; $80B7C4: 30 04
	bvc CODE_80B7CC		; $80B7C6: 50 04
	bra CODE_80B7DF		; $80B7C8: 80 15
CODE_80B7CA:		; M=16 X=16
	bvc CODE_80B7DF		; $80B7CA: 50 13
CODE_80B7CC:		; M=16 X=16
	lda.w $125F,x		; $80B7CC: BD 5F 12
	xba		; $80B7CF: EB
	sta.w $125F,x		; $80B7D0: 9D 5F 12
	txa		; $80B7D3: 8A
	sta.w $123F,y		; $80B7D4: 99 3F 12
	inc a		; $80B7D7: 1A
	ldy.b $53		; $80B7D8: A4 53
	sta.w $123F,y		; $80B7DA: 99 3F 12
	inc.b $5B		; $80B7DD: E6 5B
CODE_80B7DF:		; M=16 X=16
	inx		; $80B7DF: E8
	cpx.w #$000F		; $80B7E0: E0 0F 00
	bne CODE_80B7A8		; $80B7E3: D0 C3
	lda.b $5B		; $80B7E5: A5 5B
	bne CODE_80B7A3		; $80B7E7: D0 BA
	stx.b $0A		; $80B7E9: 86 0A
	ldx.w #$000A		; $80B7EB: A2 0A 00
CODE_80B7EE:		; M=16 X=16
	pla		; $80B7EE: 68
	sta.b $53,x		; $80B7EF: 95 53
	dex		; $80B7F1: CA
	dex		; $80B7F2: CA
	bpl CODE_80B7EE		; $80B7F3: 10 F9
	ldx.b $0A		; $80B7F5: A6 0A
	ply		; $80B7F7: 7A
	plx		; $80B7F8: FA
	rtl		; $80B7F9: 6B
CODE_80B7FA:		; M=16 X=16
	jsl.l $80B80D		; $80B7FA: 22 0D B8 80
	jsl.l $80C46D		; $80B7FE: 22 6D C4 80
	jsl.l $80E1E8		; $80B802: 22 E8 E1 80
	jsl.l $80C2B4		; $80B806: 22 B4 C2 80
	jmp.w $E35E		; $80B80A: 4C 5E E3
CODE_80B80D:		; M=16 X=16
	jsl.l $80E6C7		; $80B80D: 22 C7 E6 80
	jsl.l $80BED1		; $80B811: 22 D1 BE 80
	jsl.l $8D865A		; $80B815: 22 5A 86 8D
	jsl.l $8F8B11		; $80B819: 22 11 8B 8F
	lda.w $128E		; $80B81D: AD 8E 12
	bne CODE_80B84B		; $80B820: D0 29
	lda.w $0189		; $80B822: AD 89 01
	sec		; $80B825: 38
	sbc.b $6F		; $80B826: E5 6F
	sta.w $0189		; $80B828: 8D 89 01
	bpl CODE_80B84B		; $80B82B: 10 1E
	clc		; $80B82D: 18
	adc.w #$0018		; $80B82E: 69 18 00
	sta.w $0189		; $80B831: 8D 89 01
	jsl.l $80BAF2		; $80B834: 22 F2 BA 80
	jsl.l $8FDBF7		; $80B838: 22 F7 DB 8F
	jsl.l $8FDBF8		; $80B83C: 22 F8 DB 8F
	jsl.l $86FB96		; $80B840: 22 96 FB 86
	jsl.l $8FF741		; $80B844: 22 41 F7 8F
	jmp.w $B9F4		; $80B848: 4C F4 B9
CODE_80B84B:		; M=16 X=16
	rtl		; $80B84B: 6B
	db $86,$0A,$A2,$00,$00,$B5,$57,$48,$E8,$E8,$E0,$0C,$00,$D0,$F6,$A6	; $80B84C
	db $0A,$86,$0A,$A2,$00,$00,$B5,$33,$48,$E8,$E8,$E0,$04,$00,$D0,$F6	; $80B85C
	db $A6,$0A,$64,$53,$64,$57,$A9,$05,$00,$85,$5B,$A4,$3B,$B9,$D2,$13	; $80B86C
	db $85,$33,$A4,$33,$B9,$9F,$0B,$F0,$1E,$30,$1C,$B9,$1F,$0F,$29,$FF	; $80B87C
	db $00,$0A,$85,$5F,$A5,$3B,$F0,$03,$A9,$34,$00,$65,$5F,$A8,$B9,$7A	; $80B88C
	db $14,$65,$53,$85,$53,$E6,$57,$E6,$33,$E6,$33,$C6,$5B,$10,$D3,$A5	; $80B89C
	db $57,$F0,$0C,$85,$7D,$A5,$53,$85,$83,$22,$D8,$B8,$80,$85,$53,$86	; $80B8AC
	db $0A,$A2,$02,$00,$68,$95,$33,$CA,$CA,$10,$F9,$A6,$0A,$86,$0A,$A2	; $80B8BC
	db $0A,$00,$68,$95,$57,$CA,$CA,$10,$F9,$A6,$0A,$6B	; $80B8CC
CODE_80B8D8:		; M=16 X=16
	lda.b $7D		; $80B8D8: A5 7D
	sta.b $7F		; $80B8DA: 85 7F
	stz.b $7D		; $80B8DC: 64 7D
	lda.w #$0010		; $80B8DE: A9 10 00
	sta.b $85		; $80B8E1: 85 85
CODE_80B8E3:		; M=16 X=16
	asl.b $93		; $80B8E3: 06 93
	lsr.b $7F		; $80B8E5: 46 7F
	ror.b $7D		; $80B8E7: 66 7D
	lda.b $83		; $80B8E9: A5 83
	cmp.b $7D		; $80B8EB: C5 7D
	lda.w #$0000		; $80B8ED: A9 00 00
	sbc.b $7F		; $80B8F0: E5 7F
	bcc CODE_80B8FC		; $80B8F2: 90 08
	lda.b $83		; $80B8F4: A5 83
	sbc.b $7D		; $80B8F6: E5 7D
	sta.b $83		; $80B8F8: 85 83
	inc.b $93		; $80B8FA: E6 93
CODE_80B8FC:		; M=16 X=16
	dec.b $85		; $80B8FC: C6 85
	bne CODE_80B8E3		; $80B8FE: D0 E3
	lda.b $83		; $80B900: A5 83
	sta.b $95		; $80B902: 85 95
	lda.b $93		; $80B904: A5 93
	sta.b $7D		; $80B906: 85 7D
	sta.b $83		; $80B908: 85 83
	clc		; $80B90A: 18
	rtl		; $80B90B: 6B
CODE_80B90C:		; M=16 X=16
	lda.b $39		; $80B90C: A5 39
	pha		; $80B90E: 48
	lda.b $37		; $80B90F: A5 37
	pha		; $80B911: 48
	lda.b $07,s		; $80B912: A3 07
	sta.b $39		; $80B914: 85 39
	lda.b $05,s		; $80B916: A3 05
	inc a		; $80B918: 1A
	sta.b $37		; $80B919: 85 37
	lda.b [$37]		; $80B91B: A7 37
	clc		; $80B91D: 18
	adc.b $05,s		; $80B91E: 63 05
	sta.b $05,s		; $80B920: 83 05
	jsl.l $80B92D		; $80B922: 22 2D B9 80
	pla		; $80B926: 68
	sta.b $37		; $80B927: 85 37
	pla		; $80B929: 68
	sta.b $39		; $80B92A: 85 39
	rtl		; $80B92C: 6B
CODE_80B92D:		; M=16 X=16
	lda.b [$37]		; $80B92D: A7 37
	cmp.w #$0100		; $80B92F: C9 00 01
CODE_80B932:		; M=16 X=16
	bcs CODE_80B932		; $80B932: B0 FE
	phx		; $80B934: DA
	ldy.w #$0002		; $80B935: A0 02 00
CODE_80B938:		; M=16 X=16
	lda.w $047D		; $80B938: AD 7D 04
	asl a		; $80B93B: 0A
	asl a		; $80B93C: 0A
	asl a		; $80B93D: 0A
	asl a		; $80B93E: 0A
	asl a		; $80B93F: 0A
	adc.w $047B		; $80B940: 6D 7B 04
	asl a		; $80B943: 0A
	adc.b $D4		; $80B944: 65 D4
	tax		; $80B946: AA
CODE_80B947:		; M=16 X=16
	tya		; $80B947: 98
	cmp.b [$37]		; $80B948: C7 37
	bne CODE_80B94F		; $80B94A: D0 03
	jmp.w $B9E3		; $80B94C: 4C E3 B9
CODE_80B94F:		; M=16 X=16
	lda.b [$37],y		; $80B94F: B7 37
	bit.w #$0080		; $80B951: 89 80 00
	bne CODE_80B992		; $80B954: D0 3C
	and.w #$00FF		; $80B956: 29 FF 00
	cmp.w #$0040		; $80B959: C9 40 00
	bne CODE_80B961		; $80B95C: D0 03
	jmp.w $B9EA		; $80B95E: 4C EA B9
CODE_80B961:		; M=16 X=16
	phx		; $80B961: DA
	asl a		; $80B962: 0A
	tax		; $80B963: AA
	lda.l $88822F,x		; $80B964: BF 2F 82 88
	adc.w $1BD7		; $80B968: 6D D7 1B
	adc.w $1BCB		; $80B96B: 6D CB 1B
	ora.w $0477		; $80B96E: 0D 77 04
	plx		; $80B971: FA
CODE_80B972:		; M=16 X=16
	cmp.l $7E6E74,x		; $80B972: DF 74 6E 7E
	beq CODE_80B98A		; $80B976: F0 12
	sta.l $7E6E74,x		; $80B978: 9F 74 6E 7E
	txa		; $80B97C: 8A
	lsr a		; $80B97D: 4A
	cmp.b $D0		; $80B97E: C5 D0
	bcs CODE_80B984		; $80B980: B0 02
	sta.b $D0		; $80B982: 85 D0
CODE_80B984:		; M=16 X=16
	cmp.b $D2		; $80B984: C5 D2
	bcc CODE_80B98A		; $80B986: 90 02
	sta.b $D2		; $80B988: 85 D2
CODE_80B98A:		; M=16 X=16
	inc.w $047B		; $80B98A: EE 7B 04
	inx		; $80B98D: E8
	inx		; $80B98E: E8
	iny		; $80B98F: C8
	bra CODE_80B947		; $80B990: 80 B5
CODE_80B992:		; M=16 X=16
	eor.w #$FFFF		; $80B992: 49 FF FF
	inc a		; $80B995: 1A
	pha		; $80B996: 48
	and.w #$0030		; $80B997: 29 30 00
	asl a		; $80B99A: 0A
	asl a		; $80B99B: 0A
	asl a		; $80B99C: 0A
	asl a		; $80B99D: 0A
	asl a		; $80B99E: 0A
	asl a		; $80B99F: 0A
	sta.w $0477		; $80B9A0: 8D 77 04
	lda.b $01,s		; $80B9A3: A3 01
	and.w #$0040		; $80B9A5: 29 40 00
	asl a		; $80B9A8: 0A
	asl a		; $80B9A9: 0A
	asl a		; $80B9AA: 0A
	asl a		; $80B9AB: 0A
	asl a		; $80B9AC: 0A
	asl a		; $80B9AD: 0A
	asl a		; $80B9AE: 0A
	tsb.w $0477		; $80B9AF: 0C 77 04
	pla		; $80B9B2: 68
	and.w #$0003		; $80B9B3: 29 03 00
	sta.w $0479		; $80B9B6: 8D 79 04
	pha		; $80B9B9: 48
	asl a		; $80B9BA: 0A
	tax		; $80B9BB: AA
	lda.w $1BCB,x		; $80B9BC: BD CB 1B
	sta.w $1BCB		; $80B9BF: 8D CB 1B
	pla		; $80B9C2: 68
	dec a		; $80B9C3: 3A
	xba		; $80B9C4: EB
	and.w #$FF00		; $80B9C5: 29 00 FF
	asl a		; $80B9C8: 0A
	asl a		; $80B9C9: 0A
	asl a		; $80B9CA: 0A
	sta.b $D4		; $80B9CB: 85 D4
	iny		; $80B9CD: C8
	lda.b [$37],y		; $80B9CE: B7 37
	and.w #$007F		; $80B9D0: 29 7F 00
	sta.w $047B		; $80B9D3: 8D 7B 04
	iny		; $80B9D6: C8
	lda.b [$37],y		; $80B9D7: B7 37
	and.w #$007F		; $80B9D9: 29 7F 00
	sta.w $047D		; $80B9DC: 8D 7D 04
	iny		; $80B9DF: C8
	jmp.w $B938		; $80B9E0: 4C 38 B9
CODE_80B9E3:		; M=16 X=16
	clc		; $80B9E3: 18
	adc.b $37		; $80B9E4: 65 37
	sta.b $37		; $80B9E6: 85 37
	plx		; $80B9E8: FA
	rtl		; $80B9E9: 6B
CODE_80B9EA:		; M=16 X=16
	lda.w $1BE7		; $80B9EA: AD E7 1B
	clc		; $80B9ED: 18
	adc.w $1BCB		; $80B9EE: 6D CB 1B
	jmp.w $B972		; $80B9F1: 4C 72 B9
CODE_80B9F4:		; M=16 X=16
	stz.b $3B		; $80B9F4: 64 3B
	lda.w #$0002		; $80B9F6: A9 02 00
	sta.b $3F		; $80B9F9: 85 3F
	lda.w $13EE		; $80B9FB: AD EE 13
	sec		; $80B9FE: 38
	sbc.w $13F0		; $80B9FF: ED F0 13
	sta.b $53		; $80BA02: 85 53
	bne CODE_80BA09		; $80BA04: D0 03
	jmp.w $BAAF		; $80BA06: 4C AF BA
CODE_80BA09:		; M=16 X=16
	bpl CODE_80BA1F		; $80BA09: 10 14
	lda.w $128C		; $80BA0B: AD 8C 12
	bit.w #$4000		; $80BA0E: 89 00 40
	bne CODE_80BA39		; $80BA11: D0 26
	jsl.l $80BAAF		; $80BA13: 22 AF BA 80
	lda.w #$4000		; $80BA17: A9 00 40
	tsb.w $128C		; $80BA1A: 0C 8C 12
	bra CODE_80BA39		; $80BA1D: 80 1A
CODE_80BA1F:		; M=16 X=16
	ldx.b $3B		; $80BA1F: A6 3B
	ldy.b $3F		; $80BA21: A4 3F
	stx.b $3F		; $80BA23: 86 3F
	sty.b $3B		; $80BA25: 84 3B
	lda.w $128C		; $80BA27: AD 8C 12
	bit.w #$4000		; $80BA2A: 89 00 40
	beq CODE_80BA39		; $80BA2D: F0 0A
	jsl.l $80BAAF		; $80BA2F: 22 AF BA 80
	lda.w #$4000		; $80BA33: A9 00 40
	trb.w $128C		; $80BA36: 1C 8C 12
CODE_80BA39:		; M=16 X=16
	lda.w #$2000		; $80BA39: A9 00 20
	tsb.w $128C		; $80BA3C: 0C 8C 12
	bne CODE_80BA46		; $80BA3F: D0 05
	ldx.b $3F		; $80BA41: A6 3F
	inc.w $13BA,x		; $80BA43: FE BA 13
CODE_80BA46:		; M=16 X=16
	jsl.l $80B90C		; $80BA46: 22 0C B9 80
	ora.b ($00)		; $80BA4A: 12 00
	lda.l $201901,x		; $80BA4C: BF 01 19 20
	jsr.w $1620		; $80BA50: 20 20 16
	ora.b [$18],y		; $80BA53: 17 18
	ora.w $01BF,y		; $80BA55: 19 BF 01
	inc a		; $80BA58: 1A
	jsr.w $2020		; $80BA59: 20 20 20
	jsl.l $8D82F0		; $80BA5C: 22 F0 82 8D
	jsl.l $8F87EA		; $80BA60: 22 EA 87 8F
	jsl.l $80B92D		; $80BA64: 22 2D B9 80
	ldx.b $3F		; $80BA68: A6 3F
	lda.w $13CE,x		; $80BA6A: BD CE 13
	sta.b $33		; $80BA6D: 85 33
	lda.w #$0083		; $80BA6F: A9 83 00
	sta.b $35		; $80BA72: 85 35
	lda.w #$0191		; $80BA74: A9 91 01
	sta.b $3F		; $80BA77: 85 3F
	lda.w #$0000		; $80BA79: A9 00 00
	sta.b $41		; $80BA7C: 85 41
	lda.w #$0002		; $80BA7E: A9 02 00
	sta.b [$3F]		; $80BA81: 87 3F
	jsl.l $82FDD3		; $80BA83: 22 D3 FD 82
	ora.b $00		; $80BA87: 05 00
	lda.l $A51901,x		; $80BA89: BF 01 19 A5
	and.b ($A0,s),y		; $80BA8D: 33 A0
	tsb.b $00		; $80BA8F: 04 00
	clc		; $80BA91: 18
	adc.b [$33],y		; $80BA92: 77 33
	sta.b $33		; $80BA94: 85 33
	adc.b [$33]		; $80BA96: 67 33
	sta.b $33		; $80BA98: 85 33
	sta.b $37		; $80BA9A: 85 37
	lda.b $35		; $80BA9C: A5 35
	sta.b $39		; $80BA9E: 85 39
	jsl.l $8F87C9		; $80BAA0: 22 C9 87 8F
	lda.b $3F		; $80BAA4: A5 3F
	sta.b $37		; $80BAA6: 85 37
	lda.b $41		; $80BAA8: A5 41
	sta.b $39		; $80BAAA: 85 39
	jmp.w $B92D		; $80BAAC: 4C 2D B9
CODE_80BAAF:		; M=16 X=16
	lda.w #$2000		; $80BAAF: A9 00 20
	trb.w $128C		; $80BAB2: 1C 8C 12
	beq CODE_80BABB		; $80BAB5: F0 04
	jml.l $8D8549		; $80BAB7: 5C 49 85 8D
CODE_80BABB:		; M=16 X=16
	rtl		; $80BABB: 6B
	db $AD,$7B,$04,$48,$AD,$CE,$13,$85,$37,$A9,$83,$00,$85,$39,$A5,$5F	; $80BABC
	db $F0,$05,$AD,$D0,$13,$85,$37,$A0,$04,$00,$B7,$37,$18,$65,$37,$85	; $80BACC
	db $37,$A7,$37,$65,$37,$85,$37,$22,$2D,$B9,$80,$68,$8D,$7B,$04,$EE	; $80BADC
	db $7D,$04,$EE,$7D,$04,$6B	; $80BAEC
CODE_80BAF2:		; M=16 X=16
	lda.w $128A		; $80BAF2: AD 8A 12
	bne CODE_80BB59		; $80BAF5: D0 62
	stz.b $3B		; $80BAF7: 64 3B
	lda.w #$0001		; $80BAF9: A9 01 00
	sta.b $53		; $80BAFC: 85 53
	inc a		; $80BAFE: 1A
	sta.b $37		; $80BAFF: 85 37
	jsl.l $80BB12		; $80BB01: 22 12 BB 80
	lda.w #$0002		; $80BB05: A9 02 00
	sta.b $53		; $80BB08: 85 53
	lda.b $37		; $80BB0A: A5 37
	ldy.b $3B		; $80BB0C: A4 3B
	sta.b $3B		; $80BB0E: 85 3B
	sty.b $37		; $80BB10: 84 37
CODE_80BB12:		; M=16 X=16
	lda.b $53		; $80BB12: A5 53
	cmp.w $1296		; $80BB14: CD 96 12
	beq CODE_80BB59		; $80BB17: F0 40
	cmp.w $1298		; $80BB19: CD 98 12
	beq CODE_80BB59		; $80BB1C: F0 3B
	ldy.b $3B		; $80BB1E: A4 3B
	lda.w $13F2,y		; $80BB20: B9 F2 13
	bmi CODE_80BB59		; $80BB23: 30 34
	lda.w $0EBB		; $80BB25: AD BB 0E
	bmi CODE_80BB59		; $80BB28: 30 2F
	sec		; $80BB2A: 38
	sbc.w #$0006		; $80BB2B: E9 06 00
	ldy.b $3B		; $80BB2E: A4 3B
	beq CODE_80BB36		; $80BB30: F0 04
	eor.w #$FFFF		; $80BB32: 49 FF FF
	inc a		; $80BB35: 1A
CODE_80BB36:		; M=16 X=16
	sta.b $53		; $80BB36: 85 53
	cmp.w #$0000		; $80BB38: C9 00 00
	bpl CODE_80BB59		; $80BB3B: 10 1C
	lda.w $097B		; $80BB3D: AD 7B 09
	sta.b $57		; $80BB40: 85 57
	lda.w $1288		; $80BB42: AD 88 12
	bit.w #$0008		; $80BB45: 89 08 00
	bne CODE_80BB4D		; $80BB48: D0 03
	jmp.w $BE89		; $80BB4A: 4C 89 BE
CODE_80BB4D:		; M=16 X=16
	lda.w $13F2,y		; $80BB4D: B9 F2 13
	ora.w #$FF00		; $80BB50: 09 00 FF
	sta.w $13F2,y		; $80BB53: 99 F2 13
	jmp.w $BB5A		; $80BB56: 4C 5A BB
CODE_80BB59:		; M=16 X=16
	rtl		; $80BB59: 6B
CODE_80BB5A:		; M=16 X=16
	stx.b $0A		; $80BB5A: 86 0A
	ldx.w #$0000		; $80BB5C: A2 00 00
CODE_80BB5F:		; M=16 X=16
	lda.b $53,x		; $80BB5F: B5 53
	pha		; $80BB61: 48
	inx		; $80BB62: E8
	inx		; $80BB63: E8
	cpx.w #$0018		; $80BB64: E0 18 00
	bne CODE_80BB5F		; $80BB67: D0 F6
	ldx.b $0A		; $80BB69: A6 0A
	stx.b $0A		; $80BB6B: 86 0A
	ldx.w #$0000		; $80BB6D: A2 00 00
CODE_80BB70:		; M=16 X=16
	lda.b $33,x		; $80BB70: B5 33
	pha		; $80BB72: 48
	inx		; $80BB73: E8
	inx		; $80BB74: E8
	cpx.w #$0014		; $80BB75: E0 14 00
	bne CODE_80BB70		; $80BB78: D0 F6
	ldx.b $0A		; $80BB7A: A6 0A
	ldy.b $3B		; $80BB7C: A4 3B
	ldx.w $13D2,y		; $80BB7E: BE D2 13
	stx.b $3F		; $80BB81: 86 3F
	lda.w #$0005		; $80BB83: A9 05 00
	sta.b $63		; $80BB86: 85 63
CODE_80BB88:		; M=16 X=16
	lda.w #$FFFF		; $80BB88: A9 FF FF
	sta.w $0E9F,x		; $80BB8B: 9D 9F 0E
	sta.w $0EBF,x		; $80BB8E: 9D BF 0E
	inx		; $80BB91: E8
	inx		; $80BB92: E8
	stx.b $3F		; $80BB93: 86 3F
	dec.b $63		; $80BB95: C6 63
	bpl CODE_80BB88		; $80BB97: 10 EF
	jsl.l $80BCB0		; $80BB99: 22 B0 BC 80
	lda.w #$0005		; $80BB9D: A9 05 00
	sta.b $63		; $80BBA0: 85 63
	lda.w #$0443		; $80BBA2: A9 43 04
	sta.b $43		; $80BBA5: 85 43
	lda.w #$0000		; $80BBA7: A9 00 00
	sta.b $45		; $80BBAA: 85 45
CODE_80BBAC:		; M=16 X=16
	ldy.b $63		; $80BBAC: A4 63
	lda.b [$43],y		; $80BBAE: B7 43
	and.w #$00FF		; $80BBB0: 29 FF 00
	sta.b $67		; $80BBB3: 85 67
	beq CODE_80BC11		; $80BBB5: F0 5A
	dec.b $67		; $80BBB7: C6 67
	lda.w #$0005		; $80BBB9: A9 05 00
	sta.b $5F		; $80BBBC: 85 5F
	ldy.b $3B		; $80BBBE: A4 3B
	ldx.w $13D2,y		; $80BBC0: BE D2 13
	dex		; $80BBC3: CA
	dex		; $80BBC4: CA
CODE_80BBC5:		; M=16 X=16
	inx		; $80BBC5: E8
	inx		; $80BBC6: E8
	stx.b $3F		; $80BBC7: 86 3F
	lda.w $0F1F,x		; $80BBC9: BD 1F 0F
	and.w #$00FF		; $80BBCC: 29 FF 00
	sta.b $73		; $80BBCF: 85 73
	lda.b $67		; $80BBD1: A5 67
	and.w #$00FF		; $80BBD3: 29 FF 00
	cmp.b $73		; $80BBD6: C5 73
	beq CODE_80BBE0		; $80BBD8: F0 06
	dec.b $5F		; $80BBDA: C6 5F
	bpl CODE_80BBC5		; $80BBDC: 10 E7
	bra CODE_80BC11		; $80BBDE: 80 31
CODE_80BBE0:		; M=16 X=16
	lda.b $63		; $80BBE0: A5 63
	clc		; $80BBE2: 18
	adc.w #$0006		; $80BBE3: 69 06 00
	tay		; $80BBE6: A8
	lda.b [$43],y		; $80BBE7: B7 43
	and.w #$00FF		; $80BBE9: 29 FF 00
	bit.w #$0080		; $80BBEC: 89 80 00
	beq CODE_80BBF4		; $80BBEF: F0 03
	ora.w #$FF00		; $80BBF1: 09 00 FF
CODE_80BBF4:		; M=16 X=16
	sta.w $0E9F,x		; $80BBF4: 9D 9F 0E
	lda.b $67		; $80BBF7: A5 67
	and.w #$00FF		; $80BBF9: 29 FF 00
	bit.w #$0080		; $80BBFC: 89 80 00
	beq CODE_80BC04		; $80BBFF: F0 03
	ora.w #$FF00		; $80BC01: 09 00 FF
CODE_80BC04:		; M=16 X=16
	sta.w $0EBF,x		; $80BC04: 9D BF 0E
	ldy.b $63		; $80BC07: A4 63
	sep #$20		; $80BC09: E2 20
	lda.b #$00		; $80BC0B: A9 00
	sta.b [$43],y		; $80BC0D: 97 43
	rep #$20		; $80BC0F: C2 20
CODE_80BC11:		; M=16 X=16
	dec.b $63		; $80BC11: C6 63
	bpl CODE_80BBAC		; $80BC13: 10 97
	lda.w #$0005		; $80BC15: A9 05 00
	sta.b $63		; $80BC18: 85 63
	lda.w #$0443		; $80BC1A: A9 43 04
	sta.b $43		; $80BC1D: 85 43
	lda.w #$0000		; $80BC1F: A9 00 00
	sta.b $45		; $80BC22: 85 45
CODE_80BC24:		; M=16 X=16
	ldy.b $63		; $80BC24: A4 63
	lda.b [$43],y		; $80BC26: B7 43
	and.w #$00FF		; $80BC28: 29 FF 00
	sta.b $67		; $80BC2B: 85 67
	beq CODE_80BC8D		; $80BC2D: F0 5E
	dec.b $67		; $80BC2F: C6 67
	lda.w #$0005		; $80BC31: A9 05 00
	sta.b $5F		; $80BC34: 85 5F
	ldy.b $3B		; $80BC36: A4 3B
	ldx.w $13D2,y		; $80BC38: BE D2 13
	dex		; $80BC3B: CA
	dex		; $80BC3C: CA
CODE_80BC3D:		; M=16 X=16
	inx		; $80BC3D: E8
	inx		; $80BC3E: E8
	stx.b $3F		; $80BC3F: 86 3F
	lda.w $0EBF,x		; $80BC41: BD BF 0E
	bit.w #$0080		; $80BC44: 89 80 00
	bne CODE_80BC4F		; $80BC47: D0 06
	dec.b $5F		; $80BC49: C6 5F
	bpl CODE_80BC3D		; $80BC4B: 10 F0
	bra CODE_80BC51		; $80BC4D: 80 02
CODE_80BC4F:		; M=16 X=16
	stx.b $33		; $80BC4F: 86 33
CODE_80BC51:		; M=16 X=16
	lda.w $0B9F,x		; $80BC51: BD 9F 0B
	bpl CODE_80BC5A		; $80BC54: 10 04
	dec.b $5F		; $80BC56: C6 5F
	bpl CODE_80BC3D		; $80BC58: 10 E3
CODE_80BC5A:		; M=16 X=16
	lda.b $63		; $80BC5A: A5 63
	clc		; $80BC5C: 18
	adc.w #$0006		; $80BC5D: 69 06 00
	tay		; $80BC60: A8
	lda.b [$43],y		; $80BC61: B7 43
	and.w #$00FF		; $80BC63: 29 FF 00
	bit.w #$0080		; $80BC66: 89 80 00
	beq CODE_80BC6E		; $80BC69: F0 03
	ora.w #$FF00		; $80BC6B: 09 00 FF
CODE_80BC6E:		; M=16 X=16
	ldy.b $33		; $80BC6E: A4 33
	sta.w $0E9F,y		; $80BC70: 99 9F 0E
	lda.b $67		; $80BC73: A5 67
	and.w #$00FF		; $80BC75: 29 FF 00
	bit.w #$0080		; $80BC78: 89 80 00
	beq CODE_80BC80		; $80BC7B: F0 03
	ora.w #$FF00		; $80BC7D: 09 00 FF
CODE_80BC80:		; M=16 X=16
	sta.w $0EBF,y		; $80BC80: 99 BF 0E
	ldy.b $63		; $80BC83: A4 63
	sep #$20		; $80BC85: E2 20
	lda.b #$00		; $80BC87: A9 00
	sta.b [$43],y		; $80BC89: 97 43
	rep #$20		; $80BC8B: C2 20
CODE_80BC8D:		; M=16 X=16
	dec.b $63		; $80BC8D: C6 63
	bpl CODE_80BC24		; $80BC8F: 10 93
	stx.b $0A		; $80BC91: 86 0A
	ldx.w #$0012		; $80BC93: A2 12 00
CODE_80BC96:		; M=16 X=16
	pla		; $80BC96: 68
	sta.b $33,x		; $80BC97: 95 33
	dex		; $80BC99: CA
	dex		; $80BC9A: CA
	bpl CODE_80BC96		; $80BC9B: 10 F9
	ldx.b $0A		; $80BC9D: A6 0A
	stx.b $0A		; $80BC9F: 86 0A
	ldx.w #$0016		; $80BCA1: A2 16 00
CODE_80BCA4:		; M=16 X=16
	pla		; $80BCA4: 68
	sta.b $53,x		; $80BCA5: 95 53
	dex		; $80BCA7: CA
	dex		; $80BCA8: CA
	bpl CODE_80BCA4		; $80BCA9: 10 F9
	ldx.b $0A		; $80BCAB: A6 0A
	ldx.b $3F		; $80BCAD: A6 3F
	rtl		; $80BCAF: 6B
CODE_80BCB0:		; M=16 X=16
	lda.w #$0443		; $80BCB0: A9 43 04
	sta.b $43		; $80BCB3: 85 43
	lda.w #$0000		; $80BCB5: A9 00 00
	sta.b $45		; $80BCB8: 85 45
	lda.w #$0000		; $80BCBA: A9 00 00
	sta.b [$43]		; $80BCBD: 87 43
	ldy.w #$0002		; $80BCBF: A0 02 00
	sta.b [$43],y		; $80BCC2: 97 43
	ldy.w #$0004		; $80BCC4: A0 04 00
	sta.b [$43],y		; $80BCC7: 97 43
	lda.w #$F820		; $80BCC9: A9 20 F8
	sta.b $33		; $80BCCC: 85 33
	lda.w #$008F		; $80BCCE: A9 8F 00
	sta.b $35		; $80BCD1: 85 35
	ldy.b $3B		; $80BCD3: A4 3B
	lda.w $13F2,y		; $80BCD5: B9 F2 13
	bpl CODE_80BCDC		; $80BCD8: 10 02
	inc.b $33		; $80BCDA: E6 33
CODE_80BCDC:		; M=16 X=16
	lda.w $13CE,y		; $80BCDC: B9 CE 13
	sta.b $37		; $80BCDF: 85 37
	lda.w #$0083		; $80BCE1: A9 83 00
	sta.b $39		; $80BCE4: 85 39
	ldy.w #$0006		; $80BCE6: A0 06 00
	lda.b [$37],y		; $80BCE9: B7 37
	clc		; $80BCEB: 18
	adc.b $37		; $80BCEC: 65 37
	sta.b $37		; $80BCEE: 85 37
	ldy.b $3B		; $80BCF0: A4 3B
	lda.w $13DE,y		; $80BCF2: B9 DE 13
	asl a		; $80BCF5: 0A
	asl a		; $80BCF6: 0A
	asl a		; $80BCF7: 0A
	sta.b $53		; $80BCF8: 85 53
	adc.b $37		; $80BCFA: 65 37
	sta.b $37		; $80BCFC: 85 37
	lda.w $13EE,y		; $80BCFE: B9 EE 13
	sta.b $63		; $80BD01: 85 63
	bra CODE_80BD39		; $80BD03: 80 34
CODE_80BD05:		; M=16 X=16
	ldy.b $63		; $80BD05: A4 63
	lda.b [$33],y		; $80BD07: B7 33
	and.w #$00FF		; $80BD09: 29 FF 00
	sta.b $67		; $80BD0C: 85 67
	tay		; $80BD0E: A8
	sep #$20		; $80BD0F: E2 20
	lda.b [$37],y		; $80BD11: B7 37
	ldy.b $63		; $80BD13: A4 63
	sta.b [$43],y		; $80BD15: 97 43
	iny		; $80BD17: C8
	iny		; $80BD18: C8
	iny		; $80BD19: C8
	iny		; $80BD1A: C8
	iny		; $80BD1B: C8
	iny		; $80BD1C: C8
	lda.b $67		; $80BD1D: A5 67
	sta.b [$43],y		; $80BD1F: 97 43
	rep #$20		; $80BD21: C2 20
	lda.b $67		; $80BD23: A5 67
	bne CODE_80BD39		; $80BD25: D0 12
	ldy.b $3B		; $80BD27: A4 3B
	lda.w $13F2,y		; $80BD29: B9 F2 13
	inc a		; $80BD2C: 1A
	sta.b $5F		; $80BD2D: 85 5F
	ldy.b $63		; $80BD2F: A4 63
	sep #$20		; $80BD31: E2 20
	lda.b $5F		; $80BD33: A5 5F
	sta.b [$43],y		; $80BD35: 97 43
	rep #$20		; $80BD37: C2 20
CODE_80BD39:		; M=16 X=16
	dec.b $63		; $80BD39: C6 63
	bpl CODE_80BD05		; $80BD3B: 10 C8
	lda.w #$0005		; $80BD3D: A9 05 00
	sta.b $63		; $80BD40: 85 63
CODE_80BD42:		; M=16 X=16
	ldy.b $63		; $80BD42: A4 63
	lda.b [$43],y		; $80BD44: B7 43
	and.w #$00FF		; $80BD46: 29 FF 00
	sta.b $5F		; $80BD49: 85 5F
	beq CODE_80BDCB		; $80BD4B: F0 7E
	and.w #$00FF		; $80BD4D: 29 FF 00
	bit.w #$0080		; $80BD50: 89 80 00
	beq CODE_80BD58		; $80BD53: F0 03
	ora.w #$FF00		; $80BD55: 09 00 FF
CODE_80BD58:		; M=16 X=16
	dec a		; $80BD58: 3A
	asl a		; $80BD59: 0A
	sta.b $5F		; $80BD5A: 85 5F
	lda.b $3B		; $80BD5C: A5 3B
	beq CODE_80BD63		; $80BD5E: F0 03
	lda.w #$0034		; $80BD60: A9 34 00
CODE_80BD63:		; M=16 X=16
	clc		; $80BD63: 18
	adc.b $5F		; $80BD64: 65 5F
	tay		; $80BD66: A8
	lda.w $14E2,y		; $80BD67: B9 E2 14
	cmp.w #$FFFD		; $80BD6A: C9 FD FF
	beq CODE_80BD76		; $80BD6D: F0 07
	lda.w $14E2,y		; $80BD6F: B9 E2 14
	bmi CODE_80BDCB		; $80BD72: 30 57
	beq CODE_80BDCB		; $80BD74: F0 55
CODE_80BD76:		; M=16 X=16
	ldy.b $3B		; $80BD76: A4 3B
	lda.w $13CE,y		; $80BD78: B9 CE 13
	sta.b $37		; $80BD7B: 85 37
	lda.w #$0083		; $80BD7D: A9 83 00
	sta.b $39		; $80BD80: 85 39
	ldy.w #$0006		; $80BD82: A0 06 00
	lda.b [$37],y		; $80BD85: B7 37
	clc		; $80BD87: 18
	adc.b $37		; $80BD88: 65 37
	sta.b $37		; $80BD8A: 85 37
	lda.b $63		; $80BD8C: A5 63
	clc		; $80BD8E: 18
	adc.w #$0006		; $80BD8F: 69 06 00
	tay		; $80BD92: A8
	lda.b [$43],y		; $80BD93: B7 43
	and.w #$00FF		; $80BD95: 29 FF 00
	asl a		; $80BD98: 0A
	sta.b $53		; $80BD99: 85 53
	lda.w #$F7B6		; $80BD9B: A9 B6 F7
	sta.b $33		; $80BD9E: 85 33
	lda.w #$008F		; $80BDA0: A9 8F 00
	sta.b $35		; $80BDA3: 85 35
	ldy.b $53		; $80BDA5: A4 53
	lda.b [$33],y		; $80BDA7: B7 33
	clc		; $80BDA9: 18
	adc.b $33		; $80BDAA: 65 33
	sta.b $33		; $80BDAC: 85 33
CODE_80BDAE:		; M=16 X=16
	lda.b [$33]		; $80BDAE: A7 33
	inc.b $33		; $80BDB0: E6 33
	and.w #$00FF		; $80BDB2: 29 FF 00
	sta.b $53		; $80BDB5: 85 53
	bit.w #$0080		; $80BDB7: 89 80 00
	bne CODE_80BDD3		; $80BDBA: D0 17
	ldy.b $53		; $80BDBC: A4 53
	lda.b [$37],y		; $80BDBE: B7 37
	and.w #$00FF		; $80BDC0: 29 FF 00
	sta.b $53		; $80BDC3: 85 53
	jsl.l $80BDEB		; $80BDC5: 22 EB BD 80
	beq CODE_80BDAE		; $80BDC9: F0 E3
CODE_80BDCB:		; M=16 X=16
	dec.b $63		; $80BDCB: C6 63
	bmi CODE_80BDD2		; $80BDCD: 30 03
	jmp.w $BD42		; $80BDCF: 4C 42 BD
CODE_80BDD2:		; M=16 X=16
	rtl		; $80BDD2: 6B
CODE_80BDD3:		; M=16 X=16
	jsl.l $8FFAF3		; $80BDD3: 22 F3 FA 8F
	lda.b $53		; $80BDD7: A5 53
	sta.b $5F		; $80BDD9: 85 5F
CODE_80BDDB:		; M=16 X=16
	lda.b $5F		; $80BDDB: A5 5F
	sta.b $53		; $80BDDD: 85 53
	dec.b $5F		; $80BDDF: C6 5F
	bmi CODE_80BDCB		; $80BDE1: 30 E8
	jsl.l $80BDEB		; $80BDE3: 22 EB BD 80
	beq CODE_80BDDB		; $80BDE7: F0 F2
	bra CODE_80BDCB		; $80BDE9: 80 E0
CODE_80BDEB:		; M=16 X=16
	lda.b $53		; $80BDEB: A5 53
	sta.b $57		; $80BDED: 85 57
	dec.b $53		; $80BDEF: C6 53
	asl.b $53		; $80BDF1: 06 53
	lda.b $3B		; $80BDF3: A5 3B
	beq CODE_80BDFA		; $80BDF5: F0 03
	lda.w #$0034		; $80BDF7: A9 34 00
CODE_80BDFA:		; M=16 X=16
	adc.b $53		; $80BDFA: 65 53
	tay		; $80BDFC: A8
	lda.w $14E2,y		; $80BDFD: B9 E2 14
	sec		; $80BE00: 38
	sbc.w #$0000		; $80BE01: E9 00 00
	beq CODE_80BE0E		; $80BE04: F0 08
	bmi CODE_80BE0C		; $80BE06: 30 04
	bvs CODE_80BE0E		; $80BE08: 70 04
	bra CODE_80BE41		; $80BE0A: 80 35
CODE_80BE0C:		; M=16 X=16
	bvs CODE_80BE41		; $80BE0C: 70 33
CODE_80BE0E:		; M=16 X=16
	lda.w $14E2,y		; $80BE0E: B9 E2 14
	cmp.w #$FFFD		; $80BE11: C9 FD FF
	beq CODE_80BE41		; $80BE14: F0 2B
	lda.w #$0005		; $80BE16: A9 05 00
	sta.b $53		; $80BE19: 85 53
CODE_80BE1B:		; M=16 X=16
	ldy.b $53		; $80BE1B: A4 53
	lda.b [$43],y		; $80BE1D: B7 43
	and.w #$00FF		; $80BE1F: 29 FF 00
	sta.b $73		; $80BE22: 85 73
	lda.b $57		; $80BE24: A5 57
	and.w #$00FF		; $80BE26: 29 FF 00
	cmp.b $73		; $80BE29: C5 73
	beq CODE_80BE41		; $80BE2B: F0 14
	dec.b $53		; $80BE2D: C6 53
	bpl CODE_80BE1B		; $80BE2F: 10 EA
	ldy.b $63		; $80BE31: A4 63
	sep #$20		; $80BE33: E2 20
	lda.b $57		; $80BE35: A5 57
	sta.b [$43],y		; $80BE37: 97 43
	rep #$20		; $80BE39: C2 20
	lda.b $57		; $80BE3B: A5 57
	and.w #$00FF		; $80BE3D: 29 FF 00
	rtl		; $80BE40: 6B
CODE_80BE41:		; M=16 X=16
	lda.w #$0000		; $80BE41: A9 00 00
	sta.b $57		; $80BE44: 85 57
	rtl		; $80BE46: 6B
	db $64,$3B,$A9,$01,$00,$85,$53,$1A,$85,$37,$22,$62,$BE,$80,$A9,$02	; $80BE47
	db $00,$85,$53,$A5,$37,$A4,$3B,$85,$3B,$84,$37,$A5,$53,$CD,$96,$12	; $80BE57
	db $F0,$1F,$CD,$98,$12,$F0,$1A,$A4,$3B,$B9,$F2,$13,$10,$13,$29,$FF	; $80BE67
	db $00,$C9,$0A,$00,$B0,$0B,$99,$F2,$13,$AD,$48,$01,$85,$57,$4C,$89	; $80BE77
	db $BE,$6B	; $80BE87
CODE_80BE89:		; M=16 X=16
	lda.w $12F0		; $80BE89: AD F0 12
	cmp.w #$0002		; $80BE8C: C9 02 00
	bne CODE_80BED0		; $80BE8F: D0 3F
	ldy.b $37		; $80BE91: A4 37
	lda.w $13D6,y		; $80BE93: B9 D6 13
	ldy.b $3B		; $80BE96: A4 3B
	sec		; $80BE98: 38
	sbc.w $13D6,y		; $80BE99: F9 D6 13
	sta.b $53		; $80BE9C: 85 53
	bmi CODE_80BED0		; $80BE9E: 30 30
	cmp.w #$0002		; $80BEA0: C9 02 00
	bne CODE_80BED0		; $80BEA3: D0 2B
	lda.w $12F2		; $80BEA5: AD F2 12
	cmp.w #$003D		; $80BEA8: C9 3D 00
	bcs CODE_80BED0		; $80BEAB: B0 23
	lda.w $13D2,y		; $80BEAD: B9 D2 13
	tay		; $80BEB0: A8
	lda.w $113F,y		; $80BEB1: B9 3F 11
	bne CODE_80BEBE		; $80BEB4: D0 08
	lda.b $57		; $80BEB6: A5 57
	eor.w #$FFFF		; $80BEB8: 49 FF FF
	inc a		; $80BEBB: 1A
	sta.b $57		; $80BEBC: 85 57
CODE_80BEBE:		; M=16 X=16
	lda.b $57		; $80BEBE: A5 57
	bmi CODE_80BED0		; $80BEC0: 30 0E
	ldy.b $3B		; $80BEC2: A4 3B
	lda.w $13F2,y		; $80BEC4: B9 F2 13
	ora.w #$FF00		; $80BEC7: 09 00 FF
	sta.w $13F2,y		; $80BECA: 99 F2 13
	jmp.w $BB5A		; $80BECD: 4C 5A BB
CODE_80BED0:		; M=16 X=16
	rtl		; $80BED0: 6B
CODE_80BED1:		; M=16 X=16
	lda.b $DE		; $80BED1: A5 DE
	sec		; $80BED3: 38
	sbc.w #$015E		; $80BED4: E9 5E 01
	bmi CODE_80BEDD		; $80BED7: 30 04
	bvc CODE_80BEDF		; $80BED9: 50 04
	bra CODE_80BEE5		; $80BEDB: 80 08
CODE_80BEDD:		; M=16 X=16
	bvc CODE_80BEE5		; $80BEDD: 50 06
CODE_80BEDF:		; M=16 X=16
	dec.b $DE		; $80BEDF: C6 DE
	dec.b $DE		; $80BEE1: C6 DE
	dec.b $DE		; $80BEE3: C6 DE
CODE_80BEE5:		; M=16 X=16
	lda.b $DE		; $80BEE5: A5 DE
	sec		; $80BEE7: 38
	sbc.b $6F		; $80BEE8: E5 6F
	sta.b $DE		; $80BEEA: 85 DE
	bpl CODE_80BEF0		; $80BEEC: 10 02
	stz.b $DE		; $80BEEE: 64 DE
CODE_80BEF0:		; M=16 X=16
	lda.b $DA		; $80BEF0: A5 DA
	sec		; $80BEF2: 38
	sbc.b $6F		; $80BEF3: E5 6F
	sta.b $DA		; $80BEF5: 85 DA
	bpl CODE_80BF46		; $80BEF7: 10 4D
	lda.b $DE		; $80BEF9: A5 DE
	lsr a		; $80BEFB: 4A
	sta.b $53		; $80BEFC: 85 53
	cmp.w #$0080		; $80BEFE: C9 80 00
	bcc CODE_80BF08		; $80BF01: 90 05
	lda.w #$007F		; $80BF03: A9 7F 00
	sta.b $53		; $80BF06: 85 53
CODE_80BF08:		; M=16 X=16
	lda.b $53		; $80BF08: A5 53
	and.w #$0060		; $80BF0A: 29 60 00
	sta.b $53		; $80BF0D: 85 53
	lda.b $E0		; $80BF0F: A5 E0
	inc a		; $80BF11: 1A
	inc a		; $80BF12: 1A
	and.w #$001E		; $80BF13: 29 1E 00
	sta.b $E0		; $80BF16: 85 E0
	clc		; $80BF18: 18
	adc.b $53		; $80BF19: 65 53
	sta.b $53		; $80BF1B: 85 53
	tay		; $80BF1D: A8
	lda.w #$FDFB		; $80BF1E: A9 FB FD
	sta.b $33		; $80BF21: 85 33
	lda.w #$008F		; $80BF23: A9 8F 00
	sta.b $35		; $80BF26: 85 35
	lda.b [$33],y		; $80BF28: B7 33
	xba		; $80BF2A: EB
	sep #$20		; $80BF2B: E2 20
	sta.b $DD		; $80BF2D: 85 DD
	rep #$20		; $80BF2F: C2 20
	lda.b [$33],y		; $80BF31: B7 33
	and.w #$00FF		; $80BF33: 29 FF 00
	sta.b $57		; $80BF36: 85 57
	lda.w $04A1		; $80BF38: AD A1 04
	and.b $57		; $80BF3B: 25 57
	sta.b $5B		; $80BF3D: 85 5B
	clc		; $80BF3F: 18
	adc.b $57		; $80BF40: 65 57
	sta.b $57		; $80BF42: 85 57
	sta.b $DA		; $80BF44: 85 DA
CODE_80BF46:		; M=16 X=16
	sep #$20		; $80BF46: E2 20
	stz.b $DC		; $80BF48: 64 DC
	rep #$30		; $80BF4A: C2 30
	lda.b $DE		; $80BF4C: A5 DE
	cmp.w #$0119		; $80BF4E: C9 19 01
	bcc CODE_80BF69		; $80BF51: 90 16
	lda.w $04A1		; $80BF53: AD A1 04
	and.w #$007F		; $80BF56: 29 7F 00
	cmp.w #$0013		; $80BF59: C9 13 00
	bcc CODE_80BF69		; $80BF5C: 90 0B
	cmp.w #$001A		; $80BF5E: C9 1A 00
	bcs CODE_80BF69		; $80BF61: B0 06
	sep #$20		; $80BF63: E2 20
	sta.b $DC		; $80BF65: 85 DC
	rep #$30		; $80BF67: C2 30
CODE_80BF69:		; M=16 X=16
	rtl		; $80BF69: 6B
	db $00,$00,$2E,$00,$3F,$00,$81,$00,$81,$00,$A0,$00,$60,$00,$50,$00	; $80BF6A
	db $6F,$00,$0A,$01,$58,$00,$A6,$00,$C8,$00,$2A,$01,$6B,$01,$4A,$01	; $80BF7A
	db $EA,$00,$90,$01,$A8,$01,$BB,$01,$DB,$01,$FD,$01,$8F,$00,$00,$01	; $80BF8A
	db $0D,$00,$50,$65,$72,$69,$6F,$64,$20,$4F,$76,$65,$72,$F0,$FA,$00	; $80BF9A
	db $01,$0B,$00,$47,$61,$6D,$65,$20,$4F,$76,$65,$72,$10,$05,$D0,$BF	; $80BFAA
	db $00,$01,$02,$00,$0A,$05,$F0,$BF,$00,$01,$02,$00,$10,$05,$E8,$BF	; $80BFBA
	db $00,$01,$07,$00,$49,$63,$69,$6E,$67,$02,$00,$01,$01,$FA,$FD,$00	; $80BFCA
	db $01,$0A,$00,$4F,$66,$66,$2D,$73,$69,$64,$65,$02,$00,$01,$03,$F1	; $80BFDA
	db $FB,$00,$01,$0A,$00,$46,$61,$63,$65,$20,$4F,$66,$66,$F6,$FA,$00	; $80BFEA
	db $00,$09,$00,$50,$65,$6E,$61,$6C,$74,$79,$03,$00,$01,$03,$F1,$FB	; $80BFFA
