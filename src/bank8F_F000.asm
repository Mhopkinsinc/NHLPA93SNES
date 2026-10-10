; $8FEE83-$8FFFFF  ROM $7EE83  (quick pass; starts at setoptions, boundary moved from $8FF003)
org $8FEE83
	db $A9,$CE,$80,$85,$14,$A9,$A3,$83,$85,$16,$A5,$A7,$38,$E9,$3C,$00	; $8FEE83
	db $A2,$00,$00,$9F,$00,$20,$7E,$E8,$E8,$E0,$74,$4C,$D0,$F5,$A2,$00	; $8FEE93
	db $00,$9D,$AB,$04,$E8,$E8,$E0,$00,$04,$D0,$F6,$64,$A3,$E2,$20,$58	; $8FEEA3
	db $AD,$10,$42,$A9,$81,$8D,$00,$42,$C2,$30,$A5,$00,$C5,$00,$F0,$FC	; $8FEEB3
	db $22,$20,$81,$8D,$E2,$20,$58,$AD,$10,$42,$A9,$81,$8D,$00,$42,$A9	; $8FEEC3
	db $03,$8D,$01,$21,$A9,$01,$8D,$05,$21,$A9,$00,$8D,$07,$21,$A9,$04	; $8FEED3
	db $8D,$08,$21,$A9,$11,$8D,$0B,$21,$A9,$13,$8D,$2C,$21,$C2,$30,$9C	; $8FEEE3
	db $CB,$1B,$9C,$CD,$1B,$9C,$CF,$1B,$A9,$12,$00,$8D,$E7,$1B,$1A,$8D	; $8FEEF3
	db $D7,$1B,$18,$69,$64,$00,$8D,$DB,$1B,$69,$04,$00,$8D,$DD,$1B,$69	; $8FEF03
	db $35,$00,$8D,$E5,$1B,$22,$C3,$88,$88,$A9,$00,$80,$85,$73,$A9,$88	; $8FEF13
	db $00,$85,$75,$22,$3E,$FA,$86,$E2,$20,$9C,$21,$21,$A2,$00,$00,$BF	; $8FEF23
	db $00,$08,$7F,$9F,$74,$6C,$7E,$8D,$22,$21,$E8,$E0,$00,$01,$D0,$EF	; $8FEF33
	db $A2,$00,$00,$BF,$2B,$F7,$83,$9F,$74,$6D,$7E,$8D,$22,$21,$E8,$E0	; $8FEF43
	db $00,$01,$D0,$EF,$C2,$30,$A9,$00,$10,$8D,$16,$21,$A2,$00,$00,$BF	; $8FEF53
	db $00,$09,$7F,$8D,$18,$21,$E8,$E8,$E0,$40,$02,$D0,$F2,$A2,$10,$00	; $8FEF63
	db $9C,$18,$21,$CA,$D0,$FA,$A9,$D8,$C6,$85,$73,$A9,$83,$00,$85,$75	; $8FEF73
	db $22,$3E,$FA,$86,$A9,$00,$00,$85,$33,$A9,$7F,$00,$85,$35,$A9,$C8	; $8FEF83
	db $F4,$85,$37,$A9,$8F,$00,$85,$39,$A9,$64,$00,$85,$53,$22,$E4,$E0	; $8FEF93
	db $8F,$A9,$2E,$87,$85,$33,$A9,$88,$00,$85,$35,$A9,$B8,$F4,$85,$37	; $8FEFA3
	db $A9,$8F,$00,$85,$39,$A9,$04,$00,$85,$53,$22,$E4,$E0,$8F,$A9,$00	; $8FEFB3
	db $80,$85,$73,$A9,$8C,$00,$85,$75,$22,$3E,$FA,$86,$A2,$00,$00,$BF	; $8FEFC3
	db $A0,$01,$7F,$8D,$18,$21,$E8,$E8,$E0,$A0,$06,$D0,$F2,$A9,$73,$9B	; $8FEFD3
	db $85,$73,$A9,$88,$00,$85,$75,$22,$3E,$FA,$86,$A2,$00,$00,$BF,$00	; $8FEFE3
	db $00,$7F,$8D,$18,$21,$E8,$E8,$E0,$A0,$32,$D0,$F2,$22,$E8,$F3,$80	; $8FEFF3
	jsl.l $84FAD2		; $8FF003: 22 D2 FA 84
	lda.w #$0000		; $8FF007: A9 00 00
	sta.b $BB		; $8FF00A: 85 BB
	jsl.l $80B90C		; $8FF00C: 22 0C B9 80
	ora.b $00		; $8FF010: 05 00
	inc.w $0000,x		; $8FF012: FE 00 00
	jsl.l $84F816		; $8FF015: 22 16 F8 84
	lda.w #$0028		; $8FF019: A9 28 00
	sta.w $0A1F		; $8FF01C: 8D 1F 0A
	sta.w $0A2B		; $8FF01F: 8D 2B 0A
	lda.w #$F456		; $8FF022: A9 56 F4
	sta.b $37		; $8FF025: 85 37
	lda.w #$008F		; $8FF027: A9 8F 00
	sta.b $39		; $8FF02A: 85 39
CODE_8FF02C:		; M=16 X=16
	jsl.l $80B92D		; $8FF02C: 22 2D B9 80
	ldy.w #$0002		; $8FF030: A0 02 00
	lda.b [$37],y		; $8FF033: B7 37
	and.w #$00FF		; $8FF035: 29 FF 00
	bne CODE_8FF02C		; $8FF038: D0 F2
	lda.w #$FFFF		; $8FF03A: A9 FF FF
	sta.w $160E		; $8FF03D: 8D 0E 16
	lda.w $1600		; $8FF040: AD 00 16
	cmp.w #$0002		; $8FF043: C9 02 00
	bcc CODE_8FF04C		; $8FF046: 90 04
	jsl.l $8B8000		; $8FF048: 22 00 80 8B
CODE_8FF04C:		; M=16 X=16
	stz.b $6F		; $8FF04C: 64 6F
	stz.b $53		; $8FF04E: 64 53
	jsl.l $8FF2C5		; $8FF050: 22 C5 F2 8F
	jsl.l $8FF1EA		; $8FF054: 22 EA F1 8F
	jsl.l $80F3E8		; $8FF058: 22 E8 F3 80
	jsl.l $86FBE1		; $8FF05C: 22 E1 FB 86
	lda.w #$0001		; $8FF060: A9 01 00
	sta.b $08		; $8FF063: 85 08
CODE_8FF065:		; M=16 X=16
	lda.w #$12C0		; $8FF065: A9 C0 12
	sta.b $6B		; $8FF068: 85 6B
CODE_8FF06A:		; M=16 X=16
	inc.w $04A1		; $8FF06A: EE A1 04
	bne CODE_8FF072		; $8FF06D: D0 03
	inc.w $04A3		; $8FF06F: EE A3 04
CODE_8FF072:		; M=16 X=16
	lda.b $14		; $8FF072: A5 14
	cmp.w #$81C5		; $8FF074: C9 C5 81
	beq CODE_8FF06A		; $8FF077: F0 F1
	jsl.l $80F3E8		; $8FF079: 22 E8 F3 80
	lda.b $00		; $8FF07D: A5 00
	sta.w $08DB		; $8FF07F: 8D DB 08
	sta.w $0427		; $8FF082: 8D 27 04
	jsl.l $8FE04C		; $8FF085: 22 4C E0 8F
	jsl.l $84EA66		; $8FF089: 22 66 EA 84
	jsl.l $80C40B		; $8FF08D: 22 0B C4 80
	jsl.l $86FC53		; $8FF091: 22 53 FC 86
	lda.b $57		; $8FF095: A5 57
	bne CODE_8FF102		; $8FF097: D0 69
	jsl.l $80C429		; $8FF099: 22 29 C4 80
	jsl.l $86FC53		; $8FF09D: 22 53 FC 86
	lda.b $57		; $8FF0A1: A5 57
	bne CODE_8FF102		; $8FF0A3: D0 5D
	jsl.l $8F8EF7		; $8FF0A5: 22 F7 8E 8F
	lda.b $A3		; $8FF0A9: A5 A3
	bne CODE_8FF0B1		; $8FF0AB: D0 04
	jsl.l $8F8F28		; $8FF0AD: 22 28 8F 8F
CODE_8FF0B1:		; M=16 X=16
	lda.w #$81C5		; $8FF0B1: A9 C5 81
	sta.b $14		; $8FF0B4: 85 14
	dec.b $6B		; $8FF0B6: C6 6B
	bpl CODE_8FF06A		; $8FF0B8: 10 B0
	lda.w #$001A		; $8FF0BA: A9 1A 00
	jsl.l $80AE8B		; $8FF0BD: 22 8B AE 80
	sta.w $1604		; $8FF0C1: 8D 04 16
	sta.w $129A		; $8FF0C4: 8D 9A 12
CODE_8FF0C7:		; M=16 X=16
	lda.w #$001A		; $8FF0C7: A9 1A 00
	jsl.l $80AE8B		; $8FF0CA: 22 8B AE 80
	cmp.w $1604		; $8FF0CE: CD 04 16
	beq CODE_8FF0C7		; $8FF0D1: F0 F4
	sta.w $1606		; $8FF0D3: 8D 06 16
	sta.w $129C		; $8FF0D6: 8D 9C 12
	stz.w $160E		; $8FF0D9: 9C 0E 16
	stz.w $1600		; $8FF0DC: 9C 00 16
	stz.w $1602		; $8FF0DF: 9C 02 16
CODE_8FF0E2:		; M=16 X=16
	lda.w $1602		; $8FF0E2: AD 02 16
	sec		; $8FF0E5: 38
	sbc.w #$0005		; $8FF0E6: E9 05 00
	sta.w $044F		; $8FF0E9: 8D 4F 04
	lda.w $1600		; $8FF0EC: AD 00 16
	cmp.w #$0001		; $8FF0EF: C9 01 00
	bne CODE_8FF0F8		; $8FF0F2: D0 04
	jsl.l $88EF9C		; $8FF0F4: 22 9C EF 88
CODE_8FF0F8:		; M=16 X=16
	lda.w #$0080		; $8FF0F8: A9 80 00
	tsb.w $1610		; $8FF0FB: 0C 10 16
	jml.l $8D8000		; $8FF0FE: 5C 00 80 8D
CODE_8FF102:		; M=16 X=16
	lda.b $57		; $8FF102: A5 57
	bit.w #$1000		; $8FF104: 89 00 10
	bne CODE_8FF0E2		; $8FF107: D0 D9
	bit.w #$0400		; $8FF109: 89 00 04
	beq CODE_8FF11E		; $8FF10C: F0 10
	lda.w #$0002		; $8FF10E: A9 02 00
	sta.b $53		; $8FF111: 85 53
	jsl.l $8FF2C5		; $8FF113: 22 C5 F2 8F
	jsl.l $8FF1EA		; $8FF117: 22 EA F1 8F
	jmp.w $F065		; $8FF11B: 4C 65 F0
CODE_8FF11E:		; M=16 X=16
	bit.w #$0800		; $8FF11E: 89 00 08
	beq CODE_8FF133		; $8FF121: F0 10
	lda.w #$FFFE		; $8FF123: A9 FE FF
	sta.b $53		; $8FF126: 85 53
	jsl.l $8FF2C5		; $8FF128: 22 C5 F2 8F
	jsl.l $8FF1EA		; $8FF12C: 22 EA F1 8F
CODE_8FF130:		; M=16 X=16
	jmp.w $F065		; $8FF130: 4C 65 F0
CODE_8FF133:		; M=16 X=16
	lda.w #$0001		; $8FF133: A9 01 00
	sta.b $5B		; $8FF136: 85 5B
	lda.b $57		; $8FF138: A5 57
	bit.w #$0100		; $8FF13A: 89 00 01
	bne CODE_8FF149		; $8FF13D: D0 0A
	bit.w #$0200		; $8FF13F: 89 00 02
	beq CODE_8FF130		; $8FF142: F0 EC
	lda.w #$FFFF		; $8FF144: A9 FF FF
	sta.b $5B		; $8FF147: 85 5B
CODE_8FF149:		; M=16 X=16
	jsl.l $8FF154		; $8FF149: 22 54 F1 8F
	jsl.l $8FF1EA		; $8FF14D: 22 EA F1 8F
	jmp.w $F065		; $8FF151: 4C 65 F0
CODE_8FF154:		; M=16 X=16
	lda.w #$1600		; $8FF154: A9 00 16
	sta.b $3B		; $8FF157: 85 3B
	lda.w #$0000		; $8FF159: A9 00 00
	sta.b $3D		; $8FF15C: 85 3D
	lda.w #$F367		; $8FF15E: A9 67 F3
	sta.b $3F		; $8FF161: 85 3F
	lda.w #$008F		; $8FF163: A9 8F 00
	sta.b $41		; $8FF166: 85 41
	stz.b $67		; $8FF168: 64 67
	ldy.b $6F		; $8FF16A: A4 6F
	lda.b [$3F],y		; $8FF16C: B7 3F
	sta.b $63		; $8FF16E: 85 63
	lda.b [$3B],y		; $8FF170: B7 3B
	sta.b $5F		; $8FF172: 85 5F
	lda.w $1600		; $8FF174: AD 00 16
	cmp.w #$0002		; $8FF177: C9 02 00
	bcc CODE_8FF186		; $8FF17A: 90 0A
	cpy.w #$0004		; $8FF17C: C0 04 00
	bne CODE_8FF186		; $8FF17F: D0 05
	lda.w #$0018		; $8FF181: A9 18 00
	sta.b $63		; $8FF184: 85 63
CODE_8FF186:		; M=16 X=16
	cpy.w #$0002		; $8FF186: C0 02 00
	bne CODE_8FF19C		; $8FF189: D0 11
	lda.w #$0005		; $8FF18B: A9 05 00
	sta.b $67		; $8FF18E: 85 67
	lda.w $1600		; $8FF190: AD 00 16
	bne CODE_8FF19C		; $8FF193: D0 07
	stz.b $67		; $8FF195: 64 67
	lda.w #$0005		; $8FF197: A9 05 00
	sta.b $63		; $8FF19A: 85 63
CODE_8FF19C:		; M=16 X=16
	jsl.l $8FF1C1		; $8FF19C: 22 C1 F1 8F
	lda.b $5F		; $8FF1A0: A5 5F
	sta.b [$3B],y		; $8FF1A2: 97 3B
	lda.b $5B		; $8FF1A4: A5 5B
	beq CODE_8FF1C0		; $8FF1A6: F0 18
	lda.w $1600		; $8FF1A8: AD 00 16
	cmp.w #$0002		; $8FF1AB: C9 02 00
	bcc CODE_8FF1C0		; $8FF1AE: 90 10
	tya		; $8FF1B0: 98
	bne CODE_8FF1B7		; $8FF1B1: D0 04
	jml.l $8B8000		; $8FF1B3: 5C 00 80 8B
CODE_8FF1B7:		; M=16 X=16
	cpy.w #$0004		; $8FF1B7: C0 04 00
	bne CODE_8FF1C0		; $8FF1BA: D0 04
	jml.l $8B8000		; $8FF1BC: 5C 00 80 8B
CODE_8FF1C0:		; M=16 X=16
	rtl		; $8FF1C0: 6B
CODE_8FF1C1:		; M=16 X=16
	lda.b $5F		; $8FF1C1: A5 5F
	clc		; $8FF1C3: 18
	adc.b $5B		; $8FF1C4: 65 5B
	sta.b $5F		; $8FF1C6: 85 5F
	sec		; $8FF1C8: 38
	sbc.b $67		; $8FF1C9: E5 67
	bmi CODE_8FF1D1		; $8FF1CB: 30 04
	bvs CODE_8FF1D3		; $8FF1CD: 70 04
	bra CODE_8FF1D8		; $8FF1CF: 80 07
CODE_8FF1D1:		; M=16 X=16
	bvs CODE_8FF1D8		; $8FF1D1: 70 05
CODE_8FF1D3:		; M=16 X=16
	lda.b $63		; $8FF1D3: A5 63
	dec a		; $8FF1D5: 3A
	sta.b $5F		; $8FF1D6: 85 5F
CODE_8FF1D8:		; M=16 X=16
	lda.b $5F		; $8FF1D8: A5 5F
	sec		; $8FF1DA: 38
	sbc.b $63		; $8FF1DB: E5 63
	bmi CODE_8FF1E3		; $8FF1DD: 30 04
	bvc CODE_8FF1E5		; $8FF1DF: 50 04
	bra CODE_8FF1C0		; $8FF1E1: 80 DD
CODE_8FF1E3:		; M=16 X=16
	bvc CODE_8FF1C0		; $8FF1E3: 50 DB
CODE_8FF1E5:		; M=16 X=16
	lda.b $67		; $8FF1E5: A5 67
	sta.b $5F		; $8FF1E7: 85 5F
	rtl		; $8FF1E9: 6B
CODE_8FF1EA:		; M=16 X=16
	lda.b $6F		; $8FF1EA: A5 6F
	sta.b $6B		; $8FF1EC: 85 6B
	lda.w #$FFFE		; $8FF1EE: A9 FE FF
	sta.b $6F		; $8FF1F1: 85 6F
CODE_8FF1F3:		; M=16 X=16
	inc.b $6F		; $8FF1F3: E6 6F
	inc.b $6F		; $8FF1F5: E6 6F
	stz.b $5B		; $8FF1F7: 64 5B
	jsl.l $8FF154		; $8FF1F9: 22 54 F1 8F
	jsl.l $8FF210		; $8FF1FD: 22 10 F2 8F
	lda.b $6F		; $8FF201: A5 6F
	cmp.w #$000C		; $8FF203: C9 0C 00
	bne CODE_8FF1F3		; $8FF206: D0 EB
	lda.b $6B		; $8FF208: A5 6B
	sta.b $6F		; $8FF20A: 85 6F
	jml.l $85FF1E		; $8FF20C: 5C 1E FF 85
CODE_8FF210:		; M=16 X=16
	jsl.l $80B90C		; $8FF210: 22 0C B9 80
	ora.b $00		; $8FF214: 05 00
	ldx.w $0D11,y		; $8FF216: BE 11 0D
	lda.w $047D		; $8FF219: AD 7D 04
	clc		; $8FF21C: 18
	adc.b $6F		; $8FF21D: 65 6F
	sta.w $047D		; $8FF21F: 8D 7D 04
	lda.w #$000E		; $8FF222: A9 0E 00
	sta.b $53		; $8FF225: 85 53
	lda.w #$0001		; $8FF227: A9 01 00
	sta.b $57		; $8FF22A: 85 57
	lda.w $1BE7		; $8FF22C: AD E7 1B
	sta.b $5B		; $8FF22F: 85 5B
	jsl.l $8D847C		; $8FF231: 22 7C 84 8D
	dec.w $047D		; $8FF235: CE 7D 04
	lda.w #$0011		; $8FF238: A9 11 00
	sta.w $047B		; $8FF23B: 8D 7B 04
	ldy.b $6F		; $8FF23E: A4 6F
	cpy.w #$0004		; $8FF240: C0 04 00
	beq CODE_8FF27C		; $8FF243: F0 37
	cpy.w #$0006		; $8FF245: C0 06 00
	beq CODE_8FF27C		; $8FF248: F0 32
	lda.w #$1600		; $8FF24A: A9 00 16
	sta.b $33		; $8FF24D: 85 33
	lda.w #$0000		; $8FF24F: A9 00 00
	sta.b $35		; $8FF252: 85 35
	lda.b [$33],y		; $8FF254: B7 33
	sta.b $5F		; $8FF256: 85 5F
	lda.w #$008F		; $8FF258: A9 8F 00
	sta.b $35		; $8FF25B: 85 35
	lda.w #$F375		; $8FF25D: A9 75 F3
	sta.b $33		; $8FF260: 85 33
	clc		; $8FF262: 18
	adc.b [$33],y		; $8FF263: 77 33
	sta.b $33		; $8FF265: 85 33
CODE_8FF267:		; M=16 X=16
	lda.b $35		; $8FF267: A5 35
	sta.b $39		; $8FF269: 85 39
	lda.b $33		; $8FF26B: A5 33
	sta.b $37		; $8FF26D: 85 37
	clc		; $8FF26F: 18
	adc.b [$33]		; $8FF270: 67 33
	sta.b $33		; $8FF272: 85 33
	dec.b $5F		; $8FF274: C6 5F
	bpl CODE_8FF267		; $8FF276: 10 EF
	jml.l $80B92D		; $8FF278: 5C 2D B9 80
CODE_8FF27C:		; M=16 X=16
	ldy.b $6F		; $8FF27C: A4 6F
	lda.w #$1600		; $8FF27E: A9 00 16
	sta.b $37		; $8FF281: 85 37
	lda.w #$0000		; $8FF283: A9 00 00
	sta.b $39		; $8FF286: 85 39
	lda.b [$37],y		; $8FF288: B7 37
	sta.b $5F		; $8FF28A: 85 5F
	asl a		; $8FF28C: 0A
	asl a		; $8FF28D: 0A
	tay		; $8FF28E: A8
	lda.w #$8000		; $8FF28F: A9 00 80
	sta.b $37		; $8FF292: 85 37
	lda.w #$0083		; $8FF294: A9 83 00
	sta.b $39		; $8FF297: 85 39
	lda.b [$37],y		; $8FF299: B7 37
	sta.b $37		; $8FF29B: 85 37
	ldy.w #$0004		; $8FF29D: A0 04 00
	clc		; $8FF2A0: 18
	adc.b [$37],y		; $8FF2A1: 77 37
	sta.b $37		; $8FF2A3: 85 37
	lda.w $1600		; $8FF2A5: AD 00 16
	cmp.w #$0001		; $8FF2A8: C9 01 00
	bne CODE_8FF2B7		; $8FF2AB: D0 0A
	lda.w #$F2BB		; $8FF2AD: A9 BB F2
	sta.b $37		; $8FF2B0: 85 37
	lda.w #$008F		; $8FF2B2: A9 8F 00
	sta.b $39		; $8FF2B5: 85 39
CODE_8FF2B7:		; M=16 X=16
	jml.l $80B92D		; $8FF2B7: 5C 2D B9 80
	db $0A,$00,$50,$6C,$61,$79,$6F,$66,$66,$73	; $8FF2BB
CODE_8FF2C5:		; M=16 X=16
	lda.b $6F		; $8FF2C5: A5 6F
	sta.b $5F		; $8FF2C7: 85 5F
CODE_8FF2C9:		; M=16 X=16
	lda.b $6F		; $8FF2C9: A5 6F
	clc		; $8FF2CB: 18
	adc.b $53		; $8FF2CC: 65 53
	sta.b $6F		; $8FF2CE: 85 6F
	bpl CODE_8FF2D4		; $8FF2D0: 10 02
	stz.b $6F		; $8FF2D2: 64 6F
CODE_8FF2D4:		; M=16 X=16
	lda.b $6F		; $8FF2D4: A5 6F
	cmp.w #$000E		; $8FF2D6: C9 0E 00
	bcc CODE_8FF2E1		; $8FF2D9: 90 06
	lda.b $6F		; $8FF2DB: A5 6F
	sbc.b $53		; $8FF2DD: E5 53
	sta.b $6F		; $8FF2DF: 85 6F
CODE_8FF2E1:		; M=16 X=16
	lda.w $1600		; $8FF2E1: AD 00 16
	cmp.w #$0002		; $8FF2E4: C9 02 00
	bcc CODE_8FF2F5		; $8FF2E7: 90 0C
	cmp.w #$0004		; $8FF2E9: C9 04 00
	bcs CODE_8FF2F5		; $8FF2EC: B0 07
	lda.b $6F		; $8FF2EE: A5 6F
	cmp.w #$0002		; $8FF2F0: C9 02 00
	beq CODE_8FF2C9		; $8FF2F3: F0 D4
CODE_8FF2F5:		; M=16 X=16
	lda.w $1600		; $8FF2F5: AD 00 16
	cmp.w #$0001		; $8FF2F8: C9 01 00
	bne CODE_8FF306		; $8FF2FB: D0 09
	lda.b $6F		; $8FF2FD: A5 6F
	beq CODE_8FF306		; $8FF2FF: F0 05
	cmp.w #$0007		; $8FF301: C9 07 00
	bcc CODE_8FF2C9		; $8FF304: 90 C3
CODE_8FF306:		; M=16 X=16
	lda.w $1600		; $8FF306: AD 00 16
	cmp.w #$0002		; $8FF309: C9 02 00
	bcc CODE_8FF315		; $8FF30C: 90 07
	lda.b $6F		; $8FF30E: A5 6F
	cmp.w #$0006		; $8FF310: C9 06 00
	beq CODE_8FF2C9		; $8FF313: F0 B4
CODE_8FF315:		; M=16 X=16
	jsl.l $8FF32E		; $8FF315: 22 2E F3 8F
	lda.w $1BE7		; $8FF319: AD E7 1B
	sta.b $5B		; $8FF31C: 85 5B
	jsl.l $8D847C		; $8FF31E: 22 7C 84 8D
	lda.b $6F		; $8FF322: A5 6F
	sta.b $5F		; $8FF324: 85 5F
	jsl.l $8FF32E		; $8FF326: 22 2E F3 8F
	jml.l $8FD69F		; $8FF32A: 5C 9F D6 8F
CODE_8FF32E:		; M=16 X=16
	jsl.l $80B90C		; $8FF32E: 22 0C B9 80
	ora.b $00		; $8FF332: 05 00
	sbc.l $AD0C10,x		; $8FF334: FF 10 0C AD
	adc.w $1804,x		; $8FF338: 7D 04 18
	adc.b $5F		; $8FF33B: 65 5F
	sta.w $047D		; $8FF33D: 8D 7D 04
	lda.w #$0010		; $8FF340: A9 10 00
	sta.b $53		; $8FF343: 85 53
	lda.w #$0003		; $8FF345: A9 03 00
	sta.b $57		; $8FF348: 85 57
	lda.w $1600		; $8FF34A: AD 00 16
	cmp.w #$0002		; $8FF34D: C9 02 00
	bcs CODE_8FF355		; $8FF350: B0 03
	jmp.w $F1C0		; $8FF352: 4C C0 F1
CODE_8FF355:		; M=16 X=16
	lda.b $5F		; $8FF355: A5 5F
	cmp.w #$0004		; $8FF357: C9 04 00
	beq CODE_8FF35F		; $8FF35A: F0 03
	jmp.w $F1C0		; $8FF35C: 4C C0 F1
CODE_8FF35F:		; M=16 X=16
	lda.w #$0005		; $8FF35F: A9 05 00
	sta.b $57		; $8FF362: 85 57
	rtl		; $8FF364: 6B
	db $00,$00,$04,$00,$06,$00,$1A,$00,$1A,$00,$03,$00,$03,$00,$02,$00	; $8FF365
	db $0E,$00,$47,$00,$86,$00,$86,$00,$86,$00,$B5,$00,$D8,$00,$10,$00	; $8FF375
	db $52,$65,$67,$75,$6C,$61,$72,$20,$53,$65,$61,$73,$6F,$6E,$10,$00	; $8FF385
	db $43,$6F,$6E,$74,$2E,$20,$50,$6C,$61,$79,$6F,$66,$66,$73,$0E,$00	; $8FF395
	db $4E,$65,$77,$20,$50,$6C,$61,$79,$6F,$66,$66,$73,$0B,$00,$42,$65	; $8FF3A5
	db $73,$74,$20,$6F,$66,$20,$37,$06,$00,$44,$65,$6D,$6F,$0C,$00,$4F	; $8FF3B5
	db $6E,$65,$20,$2D,$20,$48,$6F,$6D,$65,$0F,$00,$4F,$6E,$65,$20,$2D	; $8FF3C5
	db $20,$56,$69,$73,$69,$74,$6F,$72,$0B,$00,$54,$65,$61,$6D,$6D,$61	; $8FF3D5
	db $74,$65,$73,$0E,$00,$48,$65,$61,$64,$20,$74,$6F,$20,$48,$65,$61	; $8FF3E5
	db $64,$05,$00,$4F,$6E,$65,$0B,$00,$35,$20,$4D,$69,$6E,$75,$74,$65	; $8FF3F5
	db $73,$0C,$00,$31,$30,$20,$4D,$69,$6E,$75,$74,$65,$73,$0C,$00,$32	; $8FF405
	db $30,$20,$4D,$69,$6E,$75,$74,$65,$73,$0C,$00,$33,$30,$20,$53,$65	; $8FF415
	db $63,$6F,$6E,$64,$73,$0F,$00,$4F,$6E,$6C,$79,$20,$46,$69,$67,$68	; $8FF425
	db $74,$69,$6E,$67,$04,$00,$4F,$6E,$10,$00,$4F,$6E,$2C,$20,$4E,$6F	; $8FF435
	db $20,$4F,$66,$66,$73,$69,$64,$65,$04,$00,$4F,$6E,$05,$00,$4F,$66	; $8FF445
	db $66,$0E,$00,$FE,$03,$0D,$50,$6C,$61,$79,$20,$4D,$6F,$64,$65,$0C	; $8FF455
	db $00,$FE,$03,$0F,$50,$6C,$61,$79,$65,$72,$73,$0B,$00,$FE,$03,$11	; $8FF465
	db $54,$65,$61,$6D,$20,$31,$0B,$00,$FE,$03,$13,$54,$65,$61,$6D,$20	; $8FF475
	db $32,$10,$00,$FE,$03,$15,$50,$65,$72,$2E,$20,$4C,$65,$6E,$67,$74	; $8FF485
	db $68,$0E,$00,$FE,$03,$17,$50,$65,$6E,$61,$6C,$74,$69,$65,$73,$11	; $8FF495
	db $00,$FE,$03,$19,$4C,$69,$6E,$65,$20,$43,$68,$61,$6E,$67,$65,$73	; $8FF4A5
	db $03,$00,$00,$00,$01,$0A,$03,$04,$05,$06,$02,$08,$09,$0A,$0B,$0C	; $8FF4B5
	db $0D,$0E,$0F,$00,$0F,$00,$00,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C	; $8FF4C5
	db $0D,$0E,$0F	; $8FF4D5
CODE_8FF4D8:		; M=16 X=16
	stx.b $0A		; $8FF4D8: 86 0A
	ldx.w #$0000		; $8FF4DA: A2 00 00
CODE_8FF4DD:		; M=16 X=16
	lda.b $53,x		; $8FF4DD: B5 53
	pha		; $8FF4DF: 48
	inx		; $8FF4E0: E8
	inx		; $8FF4E1: E8
	cpx.w #$000C		; $8FF4E2: E0 0C 00
	bne CODE_8FF4DD		; $8FF4E5: D0 F6
	ldx.b $0A		; $8FF4E7: A6 0A
	stx.b $0A		; $8FF4E9: 86 0A
	ldx.w #$0000		; $8FF4EB: A2 00 00
CODE_8FF4EE:		; M=16 X=16
	lda.b $33,x		; $8FF4EE: B5 33
	pha		; $8FF4F0: 48
	inx		; $8FF4F1: E8
	inx		; $8FF4F2: E8
	cpx.w #$0008		; $8FF4F3: E0 08 00
	bne CODE_8FF4EE		; $8FF4F6: D0 F6
	ldx.b $0A		; $8FF4F8: A6 0A
	lda.w #$041F		; $8FF4FA: A9 1F 04
	sta.b $37		; $8FF4FD: 85 37
	lda.w #$0000		; $8FF4FF: A9 00 00
	sta.b $39		; $8FF502: 85 39
	stz.b $5B		; $8FF504: 64 5B
	bra CODE_8FF52D		; $8FF506: 80 25
CODE_8FF508:		; M=16 X=16
	lda.b [$33]		; $8FF508: A7 33
	inc.b $33		; $8FF50A: E6 33
	and.w #$00FF		; $8FF50C: 29 FF 00
	sta.b $57		; $8FF50F: 85 57
	inc.b $5B		; $8FF511: E6 5B
	lda.b $5B		; $8FF513: A5 5B
	lsr a		; $8FF515: 4A
	bcc CODE_8FF522		; $8FF516: 90 0A
	dec.b $33		; $8FF518: C6 33
	lda.b $57		; $8FF51A: A5 57
	lsr a		; $8FF51C: 4A
	lsr a		; $8FF51D: 4A
	lsr a		; $8FF51E: 4A
	lsr a		; $8FF51F: 4A
	sta.b $57		; $8FF520: 85 57
CODE_8FF522:		; M=16 X=16
	lda.b $57		; $8FF522: A5 57
	and.w #$000F		; $8FF524: 29 0F 00
	sta.b [$37]		; $8FF527: 87 37
	inc.b $37		; $8FF529: E6 37
	inc.b $37		; $8FF52B: E6 37
CODE_8FF52D:		; M=16 X=16
	dec.b $53		; $8FF52D: C6 53
	bpl CODE_8FF508		; $8FF52F: 10 D7
	stx.b $0A		; $8FF531: 86 0A
	ldx.w #$0006		; $8FF533: A2 06 00
CODE_8FF536:		; M=16 X=16
	pla		; $8FF536: 68
	sta.b $33,x		; $8FF537: 95 33
	dex		; $8FF539: CA
	dex		; $8FF53A: CA
	bpl CODE_8FF536		; $8FF53B: 10 F9
	ldx.b $0A		; $8FF53D: A6 0A
	stx.b $0A		; $8FF53F: 86 0A
	ldx.w #$000A		; $8FF541: A2 0A 00
CODE_8FF544:		; M=16 X=16
	pla		; $8FF544: 68
	sta.b $53,x		; $8FF545: 95 53
	dex		; $8FF547: CA
	dex		; $8FF548: CA
	bpl CODE_8FF544		; $8FF549: 10 F9
	ldx.b $0A		; $8FF54B: A6 0A
	rtl		; $8FF54D: 6B
	db $A9,$F5,$01,$85,$37,$A9,$00,$00,$85,$39,$A5,$57,$1A,$1A,$8D,$F5	; $8FF54E
	db $01,$A8,$A9,$20,$20,$8D,$F7,$01,$8D,$F9,$01,$8D,$FB,$01,$8D,$FD	; $8FF55E
	db $01,$A5,$53,$85,$83,$A9,$0A,$00,$85,$7D,$88,$22,$D8,$B8,$80,$A5	; $8FF56E
	db $95,$E2,$20,$69,$30,$99,$F5,$01,$C2,$20,$A5,$93,$D0,$E5,$6B	; $8FF57E
CODE_8FF58D:		; M=16 X=16
	jsl.l $80B90C		; $8FF58D: 22 0C B9 80
	ora.b $00		; $8FF591: 05 00
	sbc.l $A90000,x		; $8FF593: FF 00 00 A9
	jsr.w $8500		; $8FF597: 20 00 85
	eor.b ($A9,s),y		; $8FF59A: 53 A9
	ora.w $8500,x		; $8FF59C: 1D 00 85
	eor.b [$AD],y		; $8FF59F: 57 AD
	sbc.b [$1B]		; $8FF5A1: E7 1B
	sta.b $5B		; $8FF5A3: 85 5B
	jsl.l $8D847C		; $8FF5A5: 22 7C 84 8D
	jsl.l $80B90C		; $8FF5A9: 22 0C B9 80
	ora.b $00		; $8FF5AD: 05 00
	sbc.l $A90000,x		; $8FF5AF: FF 00 00 A9
	clc		; $8FF5B3: 18
	tsb.b $8D		; $8FF5B4: 04 8D
	asl.b $21,x		; $8FF5B6: 16 21
	lda.w #$001C		; $8FF5B8: A9 1C 00
	sta.b $73		; $8FF5BB: 85 73
	ldx.w #$0000		; $8FF5BD: A2 00 00
CODE_8FF5C0:		; M=16 X=16
	ldy.w #$0020		; $8FF5C0: A0 20 00
CODE_8FF5C3:		; M=16 X=16
	lda.l $83ECAB,x		; $8FF5C3: BF AB EC 83
	sta.w $2118		; $8FF5C7: 8D 18 21
	inx		; $8FF5CA: E8
	inx		; $8FF5CB: E8
	dey		; $8FF5CC: 88
	bne CODE_8FF5C3		; $8FF5CD: D0 F4
	txa		; $8FF5CF: 8A
	clc		; $8FF5D0: 18
	adc.w #$0020		; $8FF5D1: 69 20 00
	tax		; $8FF5D4: AA
	dec.b $73		; $8FF5D5: C6 73
	bne CODE_8FF5C0		; $8FF5D7: D0 E7
	lda.w #$0800		; $8FF5D9: A9 00 08
	sta.w $2116		; $8FF5DC: 8D 16 21
	lda.w #$001C		; $8FF5DF: A9 1C 00
	sta.b $73		; $8FF5E2: 85 73
	ldx.w #$0000		; $8FF5E4: A2 00 00
CODE_8FF5E7:		; M=16 X=16
	ldy.w #$0020		; $8FF5E7: A0 20 00
CODE_8FF5EA:		; M=16 X=16
	lda.l $83ECBB,x		; $8FF5EA: BF BB EC 83
	sta.w $2118		; $8FF5EE: 8D 18 21
	inx		; $8FF5F1: E8
	inx		; $8FF5F2: E8
	dey		; $8FF5F3: 88
	bne CODE_8FF5EA		; $8FF5F4: D0 F4
	txa		; $8FF5F6: 8A
	clc		; $8FF5F7: 18
	adc.w #$0020		; $8FF5F8: 69 20 00
	tax		; $8FF5FB: AA
	dec.b $73		; $8FF5FC: C6 73
	bne CODE_8FF5E7		; $8FF5FE: D0 E7
	jmp.w $852E		; $8FF600: 4C 2E 85
CODE_8FF603:		; M=16 X=16
	lda.b $53		; $8FF603: A5 53
	eor.w #$FFFF		; $8FF605: 49 FF FF
	inc a		; $8FF608: 1A
	clc		; $8FF609: 18
	adc.w $0DBF,x		; $8FF60A: 7D BF 0D
	and.w #$0007		; $8FF60D: 29 07 00
	sta.b $53		; $8FF610: 85 53
	lda.w $09DF,x		; $8FF612: BD DF 09
	bit.w #$0800		; $8FF615: 89 00 08
	beq CODE_8FF626		; $8FF618: F0 0C
	phx		; $8FF61A: DA
	ldx.b $53		; $8FF61B: A6 53
	lda.l $8FF632,x		; $8FF61D: BF 32 F6 8F
	plx		; $8FF621: FA
	and.w #$00FF		; $8FF622: 29 FF 00
	rtl		; $8FF625: 6B
CODE_8FF626:		; M=16 X=16
	phx		; $8FF626: DA
	ldx.b $53		; $8FF627: A6 53
	lda.l $8FF635,x		; $8FF629: BF 35 F6 8F
	plx		; $8FF62D: FA
	and.w #$00FF		; $8FF62E: 29 FF 00
	rtl		; $8FF631: 6B
	db $00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00	; $8FF632
CODE_8FF63D:		; M=16 X=16
	stx.b $0A		; $8FF63D: 86 0A
	ldx.w #$0000		; $8FF63F: A2 00 00
CODE_8FF642:		; M=16 X=16
	lda.b $53,x		; $8FF642: B5 53
	pha		; $8FF644: 48
	inx		; $8FF645: E8
	inx		; $8FF646: E8
	cpx.w #$000C		; $8FF647: E0 0C 00
	bne CODE_8FF642		; $8FF64A: D0 F6
	ldx.b $0A		; $8FF64C: A6 0A
	stx.b $0A		; $8FF64E: 86 0A
	ldx.w #$0000		; $8FF650: A2 00 00
CODE_8FF653:		; M=16 X=16
	lda.b $37,x		; $8FF653: B5 37
	pha		; $8FF655: 48
	inx		; $8FF656: E8
	inx		; $8FF657: E8
	cpx.w #$0004		; $8FF658: E0 04 00
	bne CODE_8FF653		; $8FF65B: D0 F6
	ldx.b $0A		; $8FF65D: A6 0A
	lda.w $128E		; $8FF65F: AD 8E 12
	beq CODE_8FF667		; $8FF662: F0 03
	jmp.w $F6EC		; $8FF664: 4C EC F6
CODE_8FF667:		; M=16 X=16
	lda.b $53		; $8FF667: A5 53
	bpl CODE_8FF68A		; $8FF669: 10 1F
	jsl.l $80B90C		; $8FF66B: 22 0C B9 80
	ora.b $00		; $8FF66F: 05 00
	lda.l $A90A00,x		; $8FF671: BF 00 0A A9
	ora.w $8500		; $8FF675: 0D 00 85
	eor.b ($A9,s),y		; $8FF678: 53 A9
	ora.b $00,s		; $8FF67A: 03 00
	sta.b $57		; $8FF67C: 85 57
	lda.w $1BE7		; $8FF67E: AD E7 1B
	sta.b $5B		; $8FF681: 85 5B
	jsl.l $8D847C		; $8FF683: 22 7C 84 8D
	jmp.w $F724		; $8FF687: 4C 24 F7
CODE_8FF68A:		; M=16 X=16
	jsl.l $80B90C		; $8FF68A: 22 0C B9 80
	ora.b $00		; $8FF68E: 05 00
	lda.l $A40A05,x		; $8FF690: BF 05 0A A4
	eor.b ($A9,s),y		; $8FF694: 53 A9
	ror a		; $8FF696: 6A
	lda.l $A93785,x		; $8FF697: BF 85 37 A9
	bra CODE_8FF69D		; $8FF69B: 80 00
CODE_8FF69D:		; M=16 X=16
	sta.b $39		; $8FF69D: 85 39
	lda.b [$37],y		; $8FF69F: B7 37
	clc		; $8FF6A1: 18
	adc.b $37		; $8FF6A2: 65 37
	inc a		; $8FF6A4: 1A
	inc a		; $8FF6A5: 1A
	sta.b $37		; $8FF6A6: 85 37
	lda.b [$37]		; $8FF6A8: A7 37
	dec a		; $8FF6AA: 3A
	dec a		; $8FF6AB: 3A
	sta.b $53		; $8FF6AC: 85 53
	beq CODE_8FF724		; $8FF6AE: F0 74
	inc a		; $8FF6B0: 1A
	lsr a		; $8FF6B1: 4A
	sta.b $53		; $8FF6B2: 85 53
	lda.w $047B		; $8FF6B4: AD 7B 04
	sec		; $8FF6B7: 38
	sbc.b $53		; $8FF6B8: E5 53
	sta.w $047B		; $8FF6BA: 8D 7B 04
	bpl CODE_8FF6C2		; $8FF6BD: 10 03
	stz.w $047B		; $8FF6BF: 9C 7B 04
CODE_8FF6C2:		; M=16 X=16
	lda.b [$37]		; $8FF6C2: A7 37
	sta.b $53		; $8FF6C4: 85 53
	tay		; $8FF6C6: A8
	dec.b $37		; $8FF6C7: C6 37
	lda.b [$37],y		; $8FF6C9: B7 37
	inc.b $37		; $8FF6CB: E6 37
	and.w #$00FF		; $8FF6CD: 29 FF 00
	bne CODE_8FF6D4		; $8FF6D0: D0 02
	dec.b $53		; $8FF6D2: C6 53
CODE_8FF6D4:		; M=16 X=16
	lda.w #$0003		; $8FF6D4: A9 03 00
	sta.b $57		; $8FF6D7: 85 57
	jsl.l $8FD69F		; $8FF6D9: 22 9F D6 8F
	dec.w $047D		; $8FF6DD: CE 7D 04
	dec.w $047D		; $8FF6E0: CE 7D 04
	inc.w $047B		; $8FF6E3: EE 7B 04
	jsl.l $80B92D		; $8FF6E6: 22 2D B9 80
	bra CODE_8FF724		; $8FF6EA: 80 38
CODE_8FF6EC:		; M=16 X=16
	jsl.l $82FD95		; $8FF6EC: 22 95 FD 82
	lda.b $53		; $8FF6F0: A5 53
	bmi CODE_8FF724		; $8FF6F2: 30 30
	jsl.l $80B90C		; $8FF6F4: 22 0C B9 80
	ora.b $00		; $8FF6F8: 05 00
	lda.l $A90B11,x		; $8FF6FA: BF 11 0B A9
	ror a		; $8FF6FE: 6A
	lda.l $A93785,x		; $8FF6FF: BF 85 37 A9
	bra CODE_8FF705		; $8FF703: 80 00
CODE_8FF705:		; M=16 X=16
	sta.b $39		; $8FF705: 85 39
	ldy.b $53		; $8FF707: A4 53
	lda.b [$37],y		; $8FF709: B7 37
	clc		; $8FF70B: 18
	adc.b $37		; $8FF70C: 65 37
	inc a		; $8FF70E: 1A
	inc a		; $8FF70F: 1A
	sta.b $37		; $8FF710: 85 37
	lda.b [$37]		; $8FF712: A7 37
	lsr a		; $8FF714: 4A
	sta.b $53		; $8FF715: 85 53
	lda.w $047B		; $8FF717: AD 7B 04
	sec		; $8FF71A: 38
	sbc.b $53		; $8FF71B: E5 53
	sta.w $047B		; $8FF71D: 8D 7B 04
	jsl.l $80B92D		; $8FF720: 22 2D B9 80
CODE_8FF724:		; M=16 X=16
	stx.b $0A		; $8FF724: 86 0A
	ldx.w #$0002		; $8FF726: A2 02 00
CODE_8FF729:		; M=16 X=16
	pla		; $8FF729: 68
	sta.b $37,x		; $8FF72A: 95 37
	dex		; $8FF72C: CA
	dex		; $8FF72D: CA
	bpl CODE_8FF729		; $8FF72E: 10 F9
	ldx.b $0A		; $8FF730: A6 0A
	stx.b $0A		; $8FF732: 86 0A
	ldx.w #$000A		; $8FF734: A2 0A 00
CODE_8FF737:		; M=16 X=16
	pla		; $8FF737: 68
	sta.b $53,x		; $8FF738: 95 53
	dex		; $8FF73A: CA
	dex		; $8FF73B: CA
	bpl CODE_8FF737		; $8FF73C: 10 F9
	ldx.b $0A		; $8FF73E: A6 0A
	rtl		; $8FF740: 6B
CODE_8FF741:		; M=16 X=16
	dec.w $12E6		; $8FF741: CE E6 12
	bne CODE_8FF749		; $8FF744: D0 03
	jmp.w $F827		; $8FF746: 4C 27 F8
CODE_8FF749:		; M=16 X=16
	rtl		; $8FF749: 6B
CODE_8FF74A:		; M=16 X=16
	ldy.b $3B		; $8FF74A: A4 3B
	lda.w $0EDF,y		; $8FF74C: B9 DF 0E
	ora.w #$1000		; $8FF74F: 09 00 10
	sta.w $0EDF,y		; $8FF752: 99 DF 0E
	lda.b $DE		; $8FF755: A5 DE
	clc		; $8FF757: 18
	adc.w #$012C		; $8FF758: 69 2C 01
	sta.b $DE		; $8FF75B: 85 DE
	lda.w #$008C		; $8FF75D: A9 8C 00
	pha		; $8FF760: 48
	jsl.l $80C28B		; $8FF761: 22 8B C2 80
	ldy.b $3B		; $8FF765: A4 3B
	lda.w $08FF,y		; $8FF767: B9 FF 08
	sta.w $08F5		; $8FF76A: 8D F5 08
	lda.w $095F,y		; $8FF76D: B9 5F 09
	sta.w $08F7		; $8FF770: 8D F7 08
	lda.w #$0040		; $8FF773: A9 40 00
	tsb.w $128C		; $8FF776: 0C 8C 12
	stz.b $57		; $8FF779: 64 57
	stz.b $33		; $8FF77B: 64 33
	lda.w $119F,y		; $8FF77D: B9 9F 11
	beq CODE_8FF78C		; $8FF780: F0 0A
	lda.w #$8000		; $8FF782: A9 00 80
	sta.b $57		; $8FF785: 85 57
	lda.w #$0002		; $8FF787: A9 02 00
	sta.b $33		; $8FF78A: 85 33
CODE_8FF78C:		; M=16 X=16
	lda.w $0F1F,y		; $8FF78C: B9 1F 0F
	and.w #$00FF		; $8FF78F: 29 FF 00
	ora.b $57		; $8FF792: 05 57
	sta.w $12FA		; $8FF794: 8D FA 12
	and.w #$00FF		; $8FF797: 29 FF 00
	bit.w #$0080		; $8FF79A: 89 80 00
	beq CODE_8FF7A2		; $8FF79D: F0 03
	ora.w #$FF00		; $8FF79F: 09 00 FF
CODE_8FF7A2:		; M=16 X=16
	asl a		; $8FF7A2: 0A
	sta.b $57		; $8FF7A3: 85 57
	lda.b $33		; $8FF7A5: A5 33
	beq CODE_8FF7AC		; $8FF7A7: F0 03
	lda.w #$0034		; $8FF7A9: A9 34 00
CODE_8FF7AC:		; M=16 X=16
	adc.b $57		; $8FF7AC: 65 57
	tay		; $8FF7AE: A8
	lda.w #$FFFD		; $8FF7AF: A9 FD FF
	sta.w $14E2,y		; $8FF7B2: 99 E2 14
	rtl		; $8FF7B5: 6B
	db $0E,$00,$0E,$00,$1C,$00,$2A,$00,$54,$00,$3F,$00,$54,$00,$01,$09	; $8FF7B6
	db $11,$19,$21,$29,$31,$02,$0A,$12,$1A,$22,$2A,$32,$02,$0A,$12,$1A	; $8FF7C6
	db $22,$2A,$32,$01,$09,$11,$19,$21,$29,$31,$03,$0B,$13,$1B,$23,$2B	; $8FF7D6
	db $33,$05,$0D,$15,$1D,$25,$2D,$35,$04,$0C,$14,$1C,$24,$2C,$34,$05	; $8FF7E6
	db $0D,$15,$1D,$25,$2D,$35,$03,$0B,$13,$1B,$23,$2B,$33,$04,$0C,$14	; $8FF7F6
	db $1C,$24,$2C,$34,$04,$0C,$14,$1C,$24,$2C,$34,$03,$0B,$13,$1B,$23	; $8FF806
	db $2B,$33,$05,$0D,$15,$1D,$25,$2D,$35,$FF,$00,$01,$02,$04,$03,$05	; $8FF816
	db $06	; $8FF826
CODE_8FF827:		; M=16 X=16
	stx.b $0A		; $8FF827: 86 0A
	ldx.w #$0000		; $8FF829: A2 00 00
CODE_8FF82C:		; M=16 X=16
	lda.b $53,x		; $8FF82C: B5 53
	pha		; $8FF82E: 48
	inx		; $8FF82F: E8
	inx		; $8FF830: E8
	cpx.w #$000C		; $8FF831: E0 0C 00
	bne CODE_8FF82C		; $8FF834: D0 F6
	ldx.b $0A		; $8FF836: A6 0A
	stx.b $0A		; $8FF838: 86 0A
	ldx.w #$0000		; $8FF83A: A2 00 00
CODE_8FF83D:		; M=16 X=16
	lda.b $33,x		; $8FF83D: B5 33
	pha		; $8FF83F: 48
	inx		; $8FF840: E8
	inx		; $8FF841: E8
	cpx.w #$0014		; $8FF842: E0 14 00
	bne CODE_8FF83D		; $8FF845: D0 F6
	ldx.b $0A		; $8FF847: A6 0A
	jsl.l $80B90C		; $8FF849: 22 0C B9 80
	ora.b $00		; $8FF84D: 05 00
	lda.l $A9030B,x		; $8FF84F: BF 0B 03 A9
	ora.b ($00)		; $8FF853: 12 00
	sta.b $53		; $8FF855: 85 53
	lda.w #$0005		; $8FF857: A9 05 00
	sta.b $57		; $8FF85A: 85 57
	jsl.l $8FD69F		; $8FF85C: 22 9F D6 8F
	jsl.l $80B90C		; $8FF860: 22 0C B9 80
	and.b $00,s		; $8FF864: 23 00
	lda.l $49040C,x		; $8FF866: BF 0C 04 49
	ror.w $756A		; $8FF86A: 6E 6A 75
	adc.b ($79)		; $8FF86D: 72 79
	jsr.w $6F74		; $8FF86F: 20 74 6F
	dec a		; $8FF872: 3A
	lda.l $4F060C,x		; $8FF873: BF 0C 06 4F
	adc.b $74,x		; $8FF877: 75 74
	jsr.w $6F66		; $8FF879: 20 66 6F
	adc.b ($20)		; $8FF87C: 72 20
	bvs CODE_8FF8E5		; $8FF87E: 70 65
	adc.b ($69)		; $8FF880: 72 69
	adc.l $0CBF64		; $8FF882: 6F 64 BF 0C
	ora.b $22		; $8FF886: 05 22
	pld		; $8FF888: 2B
	xce		; $8FF889: FB
	sta.l $B92D22		; $8FF88A: 8F 22 2D B9
	bra CODE_8FF83D		; $8FF88E: 80 AD
	db $7B,$11,$F0,$11,$22,$0C,$B9,$80,$0D,$00,$BF,$14,$06,$74,$68,$65	; $8FF890
	db $20,$67,$61,$6D,$65,$86,$0A,$A2,$12,$00,$68,$95,$33,$CA,$CA,$10	; $8FF8A0
	db $F9,$A6,$0A,$86,$0A,$A2,$0A,$00,$68,$95,$53,$CA,$CA,$10,$F9,$A6	; $8FF8B0
	db $0A,$A6,$3F,$6B	; $8FF8C0
CODE_8FF8C4:		; M=16 X=16
	jsl.l $8FDBF9		; $8FF8C4: 22 F9 DB 8F
	lda.b $33		; $8FF8C8: A5 33
	lsr a		; $8FF8CA: 4A
	sta.w $043F		; $8FF8CB: 8D 3F 04
	lda.w $043D		; $8FF8CE: AD 3D 04
	lsr a		; $8FF8D1: 4A
	lsr a		; $8FF8D2: 4A
	bit.w #$2000		; $8FF8D3: 89 00 20
	beq CODE_8FF8DB		; $8FF8D6: F0 03
	ora.w #$C000		; $8FF8D8: 09 00 C0
CODE_8FF8DB:		; M=16 X=16
	sta.b $67		; $8FF8DB: 85 67
	ldx.b $33		; $8FF8DD: A6 33
	ldy.b $3F		; $8FF8DF: A4 3F
	stx.b $3F		; $8FF8E1: 86 3F
	sty.b $33		; $8FF8E3: 84 33
CODE_8FF8E5:		; M=16 X=16
	lda.w #$0013		; $8FF8E5: A9 13 00
	sta.b $53		; $8FF8E8: 85 53
	jsl.l $80B49D		; $8FF8EA: 22 9D B4 80
	ldx.b $33		; $8FF8EE: A6 33
	ldy.b $3F		; $8FF8F0: A4 3F
	stx.b $3F		; $8FF8F2: 86 3F
	sty.b $33		; $8FF8F4: 84 33
	tya		; $8FF8F6: 98
	jsl.l $809B0A		; $8FF8F7: 22 0A 9B 80
	ldy.b $33		; $8FF8FB: A4 33
	lda.b $57		; $8FF8FD: A5 57
	clc		; $8FF8FF: 18
	adc.w $095F,y		; $8FF900: 79 5F 09
	sec		; $8FF903: 38
	sbc.w $097B		; $8FF904: ED 7B 09
	sta.b $57		; $8FF907: 85 57
	pha		; $8FF909: 48
	lsr a		; $8FF90A: 4A
	lsr a		; $8FF90B: 4A
	bit.w #$2000		; $8FF90C: 89 00 20
	beq CODE_8FF914		; $8FF90F: F0 03
	ora.w #$C000		; $8FF911: 09 00 C0
CODE_8FF914:		; M=16 X=16
	sta.b $5F		; $8FF914: 85 5F
	lda.b $53		; $8FF916: A5 53
	clc		; $8FF918: 18
	adc.w $08FF,y		; $8FF919: 79 FF 08
	sec		; $8FF91C: 38
	sbc.w $091B		; $8FF91D: ED 1B 09
	sta.b $53		; $8FF920: 85 53
	pha		; $8FF922: 48
	lsr a		; $8FF923: 4A
	lsr a		; $8FF924: 4A
	bit.w #$2000		; $8FF925: 89 00 20
	beq CODE_8FF92D		; $8FF928: F0 03
	ora.w #$C000		; $8FF92A: 09 00 C0
CODE_8FF92D:		; M=16 X=16
	sta.b $5B		; $8FF92D: 85 5B
	lda.w $0AFF,y		; $8FF92F: B9 FF 0A
	sta.b $83		; $8FF932: 85 83
	lda.w #$00F0		; $8FF934: A9 F0 00
	sta.b $7D		; $8FF937: 85 7D
	jsl.l $82FCDB		; $8FF939: 22 DB FC 82
	lda.b $95		; $8FF93D: A5 95
	sta.b $57		; $8FF93F: 85 57
	pha		; $8FF941: 48
	lda.w $0ADF,y		; $8FF942: B9 DF 0A
	sta.b $83		; $8FF945: 85 83
	lda.w #$00F0		; $8FF947: A9 F0 00
	sta.b $7D		; $8FF94A: 85 7D
	jsl.l $82FCDB		; $8FF94C: 22 DB FC 82
	lda.b $95		; $8FF950: A5 95
	sta.b $53		; $8FF952: 85 53
	pha		; $8FF954: 48
	sta.b $83		; $8FF955: 85 83
	lda.b $5B		; $8FF957: A5 5B
	sta.b $7D		; $8FF959: 85 7D
	jsl.l $808496		; $8FF95B: 22 96 84 80
	sta.b $53		; $8FF95F: 85 53
	lda.b $5F		; $8FF961: A5 5F
	sta.b $7D		; $8FF963: 85 7D
	lda.b $57		; $8FF965: A5 57
	sta.b $83		; $8FF967: 85 83
	jsl.l $808496		; $8FF969: 22 96 84 80
	adc.b $53		; $8FF96D: 65 53
	asl a		; $8FF96F: 0A
	sta.b $63		; $8FF970: 85 63
	lda.b $01,s		; $8FF972: A3 01
	sta.b $7D		; $8FF974: 85 7D
	sta.b $83		; $8FF976: 85 83
	jsl.l $808496		; $8FF978: 22 96 84 80
	sta.b $53		; $8FF97C: 85 53
	lda.b $03,s		; $8FF97E: A3 03
	sta.b $7D		; $8FF980: 85 7D
	sta.b $83		; $8FF982: 85 83
	jsl.l $808496		; $8FF984: 22 96 84 80
	sta.b $57		; $8FF988: 85 57
	lda.b $67		; $8FF98A: A5 67
	sta.b $7D		; $8FF98C: 85 7D
	eor.w #$FFFF		; $8FF98E: 49 FF FF
	inc a		; $8FF991: 1A
	sta.b $83		; $8FF992: 85 83
	jsl.l $808496		; $8FF994: 22 96 84 80
	adc.b $53		; $8FF998: 65 53
	clc		; $8FF99A: 18
	adc.b $57		; $8FF99B: 65 57
	sta.b $67		; $8FF99D: 85 67
	lda.b $5B		; $8FF99F: A5 5B
	sta.b $7D		; $8FF9A1: 85 7D
	sta.b $83		; $8FF9A3: 85 83
	jsl.l $808496		; $8FF9A5: 22 96 84 80
	sta.b $5B		; $8FF9A9: 85 5B
	lda.b $5F		; $8FF9AB: A5 5F
	sta.b $7D		; $8FF9AD: 85 7D
	sta.b $83		; $8FF9AF: 85 83
	jsl.l $808496		; $8FF9B1: 22 96 84 80
	adc.b $5B		; $8FF9B5: 65 5B
	sta.b $83		; $8FF9B7: 85 83
	lda.b $67		; $8FF9B9: A5 67
	sta.b $7D		; $8FF9BB: 85 7D
	jsl.l $82FCDB		; $8FF9BD: 22 DB FC 82
	sta.b $5F		; $8FF9C1: 85 5F
	lda.b $95		; $8FF9C3: A5 95
	sta.b $61		; $8FF9C5: 85 61
	asl.b $5F		; $8FF9C7: 06 5F
	rol.b $61		; $8FF9C9: 26 61
	asl.b $5F		; $8FF9CB: 06 5F
	rol.b $61		; $8FF9CD: 26 61
	lda.b $63		; $8FF9CF: A5 63
	sta.b $7D		; $8FF9D1: 85 7D
	sta.b $83		; $8FF9D3: 85 83
	jsl.l $82FCDB		; $8FF9D5: 22 DB FC 82
	sec		; $8FF9D9: 38
	sbc.b $5F		; $8FF9DA: E5 5F
	sta.b $53		; $8FF9DC: 85 53
	lda.b $95		; $8FF9DE: A5 95
	sbc.b $61		; $8FF9E0: E5 61
	sta.b $55		; $8FF9E2: 85 55
	jsl.l $80CBB1		; $8FF9E4: 22 B1 CB 80
	lda.w #$0001		; $8FF9E8: A9 01 00
	sta.b $5F		; $8FF9EB: 85 5F
	lda.b $67		; $8FF9ED: A5 67
	lsr a		; $8FF9EF: 4A
	lsr a		; $8FF9F0: 4A
	bit.w #$2000		; $8FF9F1: 89 00 20
	beq CODE_8FF9F9		; $8FF9F4: F0 03
	ora.w #$C000		; $8FF9F6: 09 00 C0
CODE_8FF9F9:		; M=16 X=16
	sta.b $67		; $8FF9F9: 85 67
	lda.b $67		; $8FF9FB: A5 67
	bne CODE_8FFA04		; $8FF9FD: D0 05
	lda.w #$0001		; $8FF9FF: A9 01 00
	sta.b $67		; $8FFA02: 85 67
CODE_8FFA04:		; M=16 X=16
	lda.b $53		; $8FFA04: A5 53
	sta.b $5B		; $8FFA06: 85 5B
	eor.w #$FFFF		; $8FFA08: 49 FF FF
	inc a		; $8FFA0B: 1A
	sta.b $53		; $8FFA0C: 85 53
	lda.b $5B		; $8FFA0E: A5 5B
	sec		; $8FFA10: 38
	sbc.b $63		; $8FFA11: E5 63
	sta.b $83		; $8FFA13: 85 83
	lda.b $67		; $8FFA15: A5 67
	sta.b $7D		; $8FFA17: 85 7D
	jsl.l $8FFB8B		; $8FFA19: 22 8B FB 8F
	sta.b $5B		; $8FFA1D: 85 5B
	bpl CODE_8FFA25		; $8FFA1F: 10 04
	dec.b $5F		; $8FFA21: C6 5F
	bpl CODE_8FFA04		; $8FFA23: 10 DF
CODE_8FFA25:		; M=16 X=16
	bne CODE_8FFA29		; $8FFA25: D0 02
	inc.b $5B		; $8FFA27: E6 5B
CODE_8FFA29:		; M=16 X=16
	lda.b $5B		; $8FFA29: A5 5B
	cmp.w #$0019		; $8FFA2B: C9 19 00
	bcc CODE_8FFA35		; $8FFA2E: 90 05
	lda.w #$0018		; $8FFA30: A9 18 00
	sta.b $5B		; $8FFA33: 85 5B
CODE_8FFA35:		; M=16 X=16
	lda.b $5B		; $8FFA35: A5 5B
	sep #$20		; $8FFA37: E2 20
	sta.w $0B3C		; $8FFA39: 8D 3C 0B
	rep #$30		; $8FFA3C: C2 30
	cmp.w #$000C		; $8FFA3E: C9 0C 00
	bcc CODE_8FFA4C		; $8FFA41: 90 09
	sep #$20		; $8FFA43: E2 20
	lda.b #$0C		; $8FFA45: A9 0C
	sta.w $0B3C		; $8FFA47: 8D 3C 0B
	rep #$30		; $8FFA4A: C2 30
CODE_8FFA4C:		; M=16 X=16
	ldy.b $33		; $8FFA4C: A4 33
	lda.b $5B		; $8FFA4E: A5 5B
	asl a		; $8FFA50: 0A
	asl a		; $8FFA51: 0A
	asl a		; $8FFA52: 0A
	sec		; $8FFA53: 38
	sbc.w #$000A		; $8FFA54: E9 0A 00
	sta.w $0C5F,y		; $8FFA57: 99 5F 0C
	sec		; $8FFA5A: 38
	sbc.w #$0006		; $8FFA5B: E9 06 00
	sta.w $0E7B		; $8FFA5E: 8D 7B 0E
	pla		; $8FFA61: 68
	sta.b $53		; $8FFA62: 85 53
	sta.b $83		; $8FFA64: 85 83
	pla		; $8FFA66: 68
	sta.b $57		; $8FFA67: 85 57
	lda.b $5B		; $8FFA69: A5 5B
	sta.b $7D		; $8FFA6B: 85 7D
	jsl.l $82FCDB		; $8FFA6D: 22 DB FC 82
	lda.b $95		; $8FFA71: A5 95
	lsr a		; $8FFA73: 4A
	lda.b $93		; $8FFA74: A5 93
	ror a		; $8FFA76: 6A
	sta.b $53		; $8FFA77: 85 53
	lda.b $95		; $8FFA79: A5 95
	pha		; $8FFA7B: 48
	asl a		; $8FFA7C: 0A
	pla		; $8FFA7D: 68
	ror a		; $8FFA7E: 6A
	sta.b $55		; $8FFA7F: 85 55
	pla		; $8FFA81: 68
	clc		; $8FFA82: 18
	adc.b $53		; $8FFA83: 65 53
	sta.b $53		; $8FFA85: 85 53
	clc		; $8FFA87: 18
	adc.w $091B		; $8FFA88: 6D 1B 09
	ldy.b $33		; $8FFA8B: A4 33
	sta.w $0C9F,y		; $8FFA8D: 99 9F 0C
	lda.b $5B		; $8FFA90: A5 5B
	sta.b $7D		; $8FFA92: 85 7D
	lda.b $57		; $8FFA94: A5 57
	sta.b $83		; $8FFA96: 85 83
	jsl.l $82FCDB		; $8FFA98: 22 DB FC 82
	lda.b $95		; $8FFA9C: A5 95
	lsr a		; $8FFA9E: 4A
	lda.b $93		; $8FFA9F: A5 93
	ror a		; $8FFAA1: 6A
	sta.b $57		; $8FFAA2: 85 57
	lda.b $95		; $8FFAA4: A5 95
	pha		; $8FFAA6: 48
	asl a		; $8FFAA7: 0A
	pla		; $8FFAA8: 68
	ror a		; $8FFAA9: 6A
	sta.b $59		; $8FFAAA: 85 59
	pla		; $8FFAAC: 68
	clc		; $8FFAAD: 18
	adc.b $57		; $8FFAAE: 65 57
	sta.b $57		; $8FFAB0: 85 57
	clc		; $8FFAB2: 18
	adc.w $097B		; $8FFAB3: 6D 7B 09
	ldy.b $33		; $8FFAB6: A4 33
	sta.w $0CBF,y		; $8FFAB8: 99 BF 0C
	lda.w #$0078		; $8FFABB: A9 78 00
	sta.b $7D		; $8FFABE: 85 7D
	lda.b $5B		; $8FFAC0: A5 5B
	sta.b $83		; $8FFAC2: 85 83
	jsl.l $8D871C		; $8FFAC4: 22 1C 87 8D
	sta.b $5B		; $8FFAC8: 85 5B
	sta.b $7D		; $8FFACA: 85 7D
	lda.b $53		; $8FFACC: A5 53
	sta.b $85		; $8FFACE: 85 85
	lda.b $55		; $8FFAD0: A5 55
	sta.b $83		; $8FFAD2: 85 83
	jsl.l $80996C		; $8FFAD4: 22 6C 99 80
	sta.b $53		; $8FFAD8: 85 53
	sta.w $0AFB		; $8FFADA: 8D FB 0A
	lda.b $5B		; $8FFADD: A5 5B
	sta.b $7D		; $8FFADF: 85 7D
	lda.b $57		; $8FFAE1: A5 57
	sta.b $85		; $8FFAE3: 85 85
	lda.b $59		; $8FFAE5: A5 59
	sta.b $83		; $8FFAE7: 85 83
	jsl.l $80996C		; $8FFAE9: 22 6C 99 80
	sta.b $57		; $8FFAED: 85 57
	sta.w $0B1B		; $8FFAEF: 8D 1B 0B
	rtl		; $8FFAF2: 6B
CODE_8FFAF3:		; M=16 X=16
	lda.b $35		; $8FFAF3: A5 35
	pha		; $8FFAF5: 48
	lda.b $33		; $8FFAF6: A5 33
	pha		; $8FFAF8: 48
	ldy.b $3B		; $8FFAF9: A4 3B
	lda.w $13CE,y		; $8FFAFB: B9 CE 13
	sta.b $33		; $8FFAFE: 85 33
	lda.w #$0083		; $8FFB00: A9 83 00
	sta.b $35		; $8FFB03: 85 35
	ldy.w #$0000		; $8FFB05: A0 00 00
	lda.b [$33],y		; $8FFB08: B7 33
	clc		; $8FFB0A: 18
	adc.b $33		; $8FFB0B: 65 33
	sta.b $33		; $8FFB0D: 85 33
	stz.b $53		; $8FFB0F: 64 53
CODE_8FFB11:		; M=16 X=16
	inc.b $53		; $8FFB11: E6 53
	lda.b [$33]		; $8FFB13: A7 33
	clc		; $8FFB15: 18
	adc.b $33		; $8FFB16: 65 33
	adc.w #$0008		; $8FFB18: 69 08 00
	sta.b $33		; $8FFB1B: 85 33
	lda.b [$33]		; $8FFB1D: A7 33
	cmp.w #$0002		; $8FFB1F: C9 02 00
	bne CODE_8FFB11		; $8FFB22: D0 ED
	pla		; $8FFB24: 68
	sta.b $33		; $8FFB25: 85 33
	pla		; $8FFB27: 68
	sta.b $35		; $8FFB28: 85 35
	rtl		; $8FFB2A: 6B
	db $A5,$55,$48,$A5,$53,$48,$A5,$3D,$48,$A5,$3B,$48,$64,$3B,$AD,$FA	; $8FFB2B
	db $12,$85,$53,$10,$0A,$29,$FF,$00,$85,$53,$A9,$02,$00,$85,$3B,$22	; $8FFB3B
	db $82,$81,$8E,$68,$85,$3B,$68,$85,$3D,$68,$85,$53,$68,$85,$55,$6B	; $8FFB4B
CODE_8FFB5B:		; M=16 X=16
	ldy.b $33		; $8FFB5B: A4 33
	lda.w #$1354		; $8FFB5D: A9 54 13
	sta.b $57		; $8FFB60: 85 57
	sta.w $117F,x		; $8FFB62: 9D 7F 11
	lda.w $0B7F,x		; $8FFB65: BD 7F 0B
	beq CODE_8FFB87		; $8FFB68: F0 1D
	lda.w $095F,x		; $8FFB6A: BD 5F 09
	sec		; $8FFB6D: 38
	sbc.w $095F,y		; $8FFB6E: F9 5F 09
	sta.b $53		; $8FFB71: 85 53
	lda.w $113F,x		; $8FFB73: BD 3F 11
	beq CODE_8FFB80		; $8FFB76: F0 08
	lda.b $53		; $8FFB78: A5 53
	eor.w #$FFFF		; $8FFB7A: 49 FF FF
	inc a		; $8FFB7D: 1A
	sta.b $53		; $8FFB7E: 85 53
CODE_8FFB80:		; M=16 X=16
	bmi CODE_8FFB87		; $8FFB80: 30 05
	lda.w #$0BFC		; $8FFB82: A9 FC 0B
	sta.b $57		; $8FFB85: 85 57
CODE_8FFB87:		; M=16 X=16
	jml.l $80B006		; $8FFB87: 5C 06 B0 80
CODE_8FFB8B:		; M=16 X=16
	stz.b $81		; $8FFB8B: 64 81
	lda.b $7D		; $8FFB8D: A5 7D
	bpl CODE_8FFB97		; $8FFB8F: 10 06
	eor.w #$FFFF		; $8FFB91: 49 FF FF
	inc a		; $8FFB94: 1A
	inc.b $81		; $8FFB95: E6 81
CODE_8FFB97:		; M=16 X=16
	sta.b $7F		; $8FFB97: 85 7F
	stz.b $7D		; $8FFB99: 64 7D
	lda.w #$0010		; $8FFB9B: A9 10 00
	sta.b $87		; $8FFB9E: 85 87
	lda.b $83		; $8FFBA0: A5 83
	bpl CODE_8FFBAC		; $8FFBA2: 10 08
	eor.w #$FFFF		; $8FFBA4: 49 FF FF
	inc a		; $8FFBA7: 1A
	sta.b $83		; $8FFBA8: 85 83
	inc.b $81		; $8FFBAA: E6 81
CODE_8FFBAC:		; M=16 X=16
	lsr.b $7F		; $8FFBAC: 46 7F
	ror.b $7D		; $8FFBAE: 66 7D
	asl.b $93		; $8FFBB0: 06 93
	lda.b $83		; $8FFBB2: A5 83
	cmp.b $7D		; $8FFBB4: C5 7D
	lda.w #$0000		; $8FFBB6: A9 00 00
	sbc.b $7F		; $8FFBB9: E5 7F
	bcc CODE_8FFBC5		; $8FFBBB: 90 08
	lda.b $83		; $8FFBBD: A5 83
	sbc.b $7D		; $8FFBBF: E5 7D
	sta.b $83		; $8FFBC1: 85 83
	inc.b $93		; $8FFBC3: E6 93
CODE_8FFBC5:		; M=16 X=16
	dec.b $87		; $8FFBC5: C6 87
	bne CODE_8FFBAC		; $8FFBC7: D0 E3
	lsr.b $81		; $8FFBC9: 46 81
	bcc CODE_8FFBD4		; $8FFBCB: 90 07
	lda.w #$0000		; $8FFBCD: A9 00 00
	sbc.b $93		; $8FFBD0: E5 93
	sta.b $93		; $8FFBD2: 85 93
CODE_8FFBD4:		; M=16 X=16
	lda.b $93		; $8FFBD4: A5 93
	sta.b $7D		; $8FFBD6: 85 7D
	sta.b $83		; $8FFBD8: 85 83
	clc		; $8FFBDA: 18
	rtl		; $8FFBDB: 6B
CODE_8FFBDC:		; M=16 X=16
	lda.w $0B9F,x		; $8FFBDC: BD 9F 0B
	bne CODE_8FFBE5		; $8FFBDF: D0 04
	jml.l $8083AB		; $8FFBE1: 5C AB 83 80
CODE_8FFBE5:		; M=16 X=16
	lda.w #$0478		; $8FFBE5: A9 78 04
	sta.b $57		; $8FFBE8: 85 57
	lda.w $11BF,x		; $8FFBEA: BD BF 11
	beq CODE_8FFBF4		; $8FFBED: F0 05
	lda.w #$09CC		; $8FFBEF: A9 CC 09
	sta.b $57		; $8FFBF2: 85 57
CODE_8FFBF4:		; M=16 X=16
	lda.b $53		; $8FFBF4: A5 53
	and.w #$000F		; $8FFBF6: 29 0F 00
	sta.b $53		; $8FFBF9: 85 53
	cmp.w #$0008		; $8FFBFB: C9 08 00
	bcc CODE_8FFC1B		; $8FFBFE: 90 1B
	cmp.w #$0009		; $8FFC00: C9 09 00
	bne CODE_8FFC11		; $8FFC03: D0 0C
	lda.w $0ADF,x		; $8FFC05: BD DF 0A
	ora.w $0AFF,x		; $8FFC08: 1D FF 0A
	beq CODE_8FFC11		; $8FFC0B: F0 04
	jml.l $808404		; $8FFC0D: 5C 04 84 80
CODE_8FFC11:		; M=16 X=16
	lda.w $11DF,x		; $8FFC11: BD DF 11
	bne CODE_8FFC1A		; $8FFC14: D0 04
	jml.l $80B006		; $8FFC16: 5C 06 B0 80
CODE_8FFC1A:		; M=16 X=16
	rtl		; $8FFC1A: 6B
CODE_8FFC1B:		; M=16 X=16
	lda.b $57		; $8FFC1B: A5 57
	pha		; $8FFC1D: 48
	lda.b $53		; $8FFC1E: A5 53
	pha		; $8FFC20: 48
	sta.b $5B		; $8FFC21: 85 5B
	txa		; $8FFC23: 8A
	lsr a		; $8FFC24: 4A
	cmp.w $0EBB		; $8FFC25: CD BB 0E
	bne CODE_8FFC2D		; $8FFC28: D0 03
	jmp.w $FCDF		; $8FFC2A: 4C DF FC
CODE_8FFC2D:		; M=16 X=16
	lda.w $091B		; $8FFC2D: AD 1B 09
	sec		; $8FFC30: 38
	sbc.w $08FF,x		; $8FFC31: FD FF 08
	sta.b $53		; $8FFC34: 85 53
	lda.w $095F,x		; $8FFC36: BD 5F 09
	sta.b $5F		; $8FFC39: 85 5F
	lda.w $0B1B		; $8FFC3B: AD 1B 0B
	lsr a		; $8FFC3E: 4A
	lsr a		; $8FFC3F: 4A
	lsr a		; $8FFC40: 4A
	lsr a		; $8FFC41: 4A
	lsr a		; $8FFC42: 4A
	lsr a		; $8FFC43: 4A
	lsr a		; $8FFC44: 4A
	bit.w #$0100		; $8FFC45: 89 00 01
	beq CODE_8FFC4D		; $8FFC48: F0 03
	ora.w #$FE00		; $8FFC4A: 09 00 FE
CODE_8FFC4D:		; M=16 X=16
	clc		; $8FFC4D: 18
	adc.w $097B		; $8FFC4E: 6D 7B 09
	sec		; $8FFC51: 38
	sbc.b $5F		; $8FFC52: E5 5F
	sta.b $57		; $8FFC54: 85 57
	lda.w $113F,x		; $8FFC56: BD 3F 11
	bne CODE_8FFC7A		; $8FFC59: D0 1F
	lda.b $53		; $8FFC5B: A5 53
	eor.w #$FFFF		; $8FFC5D: 49 FF FF
	inc a		; $8FFC60: 1A
	sta.b $53		; $8FFC61: 85 53
	lda.b $57		; $8FFC63: A5 57
	eor.w #$FFFF		; $8FFC65: 49 FF FF
	inc a		; $8FFC68: 1A
	sta.b $57		; $8FFC69: 85 57
	lda.b $5F		; $8FFC6B: A5 5F
	eor.w #$FFFF		; $8FFC6D: 49 FF FF
	inc a		; $8FFC70: 1A
	sta.b $5F		; $8FFC71: 85 5F
	lda.b $5B		; $8FFC73: A5 5B
	eor.w #$0004		; $8FFC75: 49 04 00
	sta.b $5B		; $8FFC78: 85 5B
CODE_8FFC7A:		; M=16 X=16
	lda.w $11BF,x		; $8FFC7A: BD BF 11
	bne CODE_8FFC99		; $8FFC7D: D0 1A
	lda.b $5F		; $8FFC7F: A5 5F
	bpl CODE_8FFCDF		; $8FFC81: 10 5C
	lda.b $5B		; $8FFC83: A5 5B
	cmp.w #$0004		; $8FFC85: C9 04 00
	bne CODE_8FFCDF		; $8FFC88: D0 55
	jsl.l $80AFA8		; $8FFC8A: 22 A8 AF 80
	inc a		; $8FFC8E: 1A
	and.w #$0007		; $8FFC8F: 29 07 00
	cmp.w #$0003		; $8FFC92: C9 03 00
	bcs CODE_8FFCDF		; $8FFC95: B0 48
	bra CODE_8FFCB5		; $8FFC97: 80 1C
CODE_8FFC99:		; M=16 X=16
	lda.b $5B		; $8FFC99: A5 5B
	sec		; $8FFC9B: 38
	sbc.w #$0003		; $8FFC9C: E9 03 00
	and.w #$0007		; $8FFC9F: 29 07 00
	cmp.w #$0003		; $8FFCA2: C9 03 00
	bcs CODE_8FFCDF		; $8FFCA5: B0 38
	jsl.l $80AFA8		; $8FFCA7: 22 A8 AF 80
	inc a		; $8FFCAB: 1A
	inc a		; $8FFCAC: 1A
	and.w #$0007		; $8FFCAD: 29 07 00
	cmp.w #$0005		; $8FFCB0: C9 05 00
	bcs CODE_8FFCDF		; $8FFCB3: B0 2A
CODE_8FFCB5:		; M=16 X=16
	lda.w $11BF,x		; $8FFCB5: BD BF 11
	bne CODE_8FFCE2		; $8FFCB8: D0 28
	lda.w $0ADF,x		; $8FFCBA: BD DF 0A
	sta.b $53		; $8FFCBD: 85 53
	ora.w $0AFF,x		; $8FFCBF: 1D FF 0A
	beq CODE_8FFCD9		; $8FFCC2: F0 15
	lda.w $0AFF,x		; $8FFCC4: BD FF 0A
	sta.b $57		; $8FFCC7: 85 57
	jsl.l $80AFA8		; $8FFCC9: 22 A8 AF 80
	sec		; $8FFCCD: 38
	sbc.b $01,s		; $8FFCCE: E3 01
	inc a		; $8FFCD0: 1A
	and.w #$0007		; $8FFCD1: 29 07 00
	cmp.w #$0003		; $8FFCD4: C9 03 00
	bcs CODE_8FFCE2		; $8FFCD7: B0 09
CODE_8FFCD9:		; M=16 X=16
	inc a		; $8FFCD9: 1A
	sta.w $11BF,x		; $8FFCDA: 9D BF 11
	bra CODE_8FFCE2		; $8FFCDD: 80 03
CODE_8FFCDF:		; M=16 X=16
	stz.w $11BF,x		; $8FFCDF: 9E BF 11
CODE_8FFCE2:		; M=16 X=16
	pla		; $8FFCE2: 68
	sta.b $53		; $8FFCE3: 85 53
	pla		; $8FFCE5: 68
	sta.b $57		; $8FFCE6: 85 57
	lda.w $0DBF,x		; $8FFCE8: BD BF 0D
	sta.b $5B		; $8FFCEB: 85 5B
	lda.b $53		; $8FFCED: A5 53
	sec		; $8FFCEF: 38
	sbc.b $5B		; $8FFCF0: E5 5B
	and.w #$0007		; $8FFCF2: 29 07 00
	asl a		; $8FFCF5: 0A
	sta.b $53		; $8FFCF6: 85 53
	tax		; $8FFCF8: AA
	lda.l $8FFDC8,x		; $8FFCF9: BF C8 FD 8F
	ldx.b $3F		; $8FFCFD: A6 3F
	sta.b $7D		; $8FFCFF: 85 7D
	lda.b $6F		; $8FFD01: A5 6F
	sta.b $83		; $8FFD03: 85 83
	jsl.l $808496		; $8FFD05: 22 96 84 80
	sta.b $73		; $8FFD09: 85 73
	lda.b $73		; $8FFD0B: A5 73
	bne CODE_8FFD13		; $8FFD0D: D0 04
	jml.l $888548		; $8FFD0F: 5C 48 85 88
CODE_8FFD13:		; M=16 X=16
	lda.w $0ADF,x		; $8FFD13: BD DF 0A
	sta.b $7D		; $8FFD16: 85 7D
	sta.b $83		; $8FFD18: 85 83
	jsl.l $82FCDB		; $8FFD1A: 22 DB FC 82
	sta.b $63		; $8FFD1E: 85 63
	lda.b $95		; $8FFD20: A5 95
	sta.b $65		; $8FFD22: 85 65
	lda.w $0AFF,x		; $8FFD24: BD FF 0A
	sta.b $7D		; $8FFD27: 85 7D
	sta.b $83		; $8FFD29: 85 83
	jsl.l $82FCDB		; $8FFD2B: 22 DB FC 82
	adc.b $63		; $8FFD2F: 65 63
	lda.b $95		; $8FFD31: A5 95
	adc.b $65		; $8FFD33: 65 65
	sta.b $5F		; $8FFD35: 85 5F
	lda.w #$0300		; $8FFD37: A9 00 03
	sec		; $8FFD3A: 38
	sbc.b $5F		; $8FFD3B: E5 5F
	sta.b $63		; $8FFD3D: 85 63
	sec		; $8FFD3F: 38
	sbc.w #$0180		; $8FFD40: E9 80 01
	bmi CODE_8FFD49		; $8FFD43: 30 04
	bvs CODE_8FFD4B		; $8FFD45: 70 04
	bra CODE_8FFD50		; $8FFD47: 80 07
CODE_8FFD49:		; M=16 X=16
	bvs CODE_8FFD50		; $8FFD49: 70 05
CODE_8FFD4B:		; M=16 X=16
	lda.w #$0180		; $8FFD4B: A9 80 01
	sta.b $63		; $8FFD4E: 85 63
CODE_8FFD50:		; M=16 X=16
	lda.b $73		; $8FFD50: A5 73
	sta.b $7D		; $8FFD52: 85 7D
	lda.b $63		; $8FFD54: A5 63
	sta.b $83		; $8FFD56: 85 83
	jsl.l $82FCDB		; $8FFD58: 22 DB FC 82
	sta.b $63		; $8FFD5C: 85 63
	lda.b $95		; $8FFD5E: A5 95
	sta.b $65		; $8FFD60: 85 65
	lda.w $11BF,x		; $8FFD62: BD BF 11
	beq CODE_8FFD76		; $8FFD65: F0 0F
	lda.w #$0000		; $8FFD67: A9 00 00
	sec		; $8FFD6A: 38
	sbc.b $63		; $8FFD6B: E5 63
	sta.b $63		; $8FFD6D: 85 63
	lda.w #$0000		; $8FFD6F: A9 00 00
	sbc.b $65		; $8FFD72: E5 65
	sta.b $65		; $8FFD74: 85 65
CODE_8FFD76:		; M=16 X=16
	lda.w $0DDF,x		; $8FFD76: BD DF 0D
	clc		; $8FFD79: 18
	adc.b $63		; $8FFD7A: 65 63
	sta.w $0DDF,x		; $8FFD7C: 9D DF 0D
	lda.w $0DBF,x		; $8FFD7F: BD BF 0D
	adc.b $65		; $8FFD82: 65 65
	and.w #$0007		; $8FFD84: 29 07 00
	sta.w $0DBF,x		; $8FFD87: 9D BF 0D
	sta.b $5B		; $8FFD8A: 85 5B
	lda.b $5F		; $8FFD8C: A5 5F
	cmp.w #$0015		; $8FFD8E: C9 15 00
	bcc CODE_8FFDB8		; $8FFD91: 90 25
	stz.b $57		; $8FFD93: 64 57
	lda.b $73		; $8FFD95: A5 73
	bpl CODE_8FFD9E		; $8FFD97: 10 05
	lda.w #$FFCE		; $8FFD99: A9 CE FF
	sta.b $57		; $8FFD9C: 85 57
CODE_8FFD9E:		; M=16 X=16
	lda.w $09DF,x		; $8FFD9E: BD DF 09
	bit.w #$0800		; $8FFDA1: 89 00 08
	beq CODE_8FFDAD		; $8FFDA4: F0 07
	lda.b $57		; $8FFDA6: A5 57
	eor.w #$FFCE		; $8FFDA8: 49 CE FF
	sta.b $57		; $8FFDAB: 85 57
CODE_8FFDAD:		; M=16 X=16
	lda.b $57		; $8FFDAD: A5 57
	clc		; $8FFDAF: 18
	adc.w #$0640		; $8FFDB0: 69 40 06
	sta.b $57		; $8FFDB3: 85 57
	sta.w $11DF,x		; $8FFDB5: 9D DF 11
CODE_8FFDB8:		; M=16 X=16
	jsl.l $80B006		; $8FFDB8: 22 06 B0 80
	lda.b $5F		; $8FFDBC: A5 5F
	cmp.w #$0003		; $8FFDBE: C9 03 00
	bcc CODE_8FFDC7		; $8FFDC1: 90 04
	jml.l $82FD54		; $8FFDC3: 5C 54 FD 82
CODE_8FFDC7:		; M=16 X=16
	rtl		; $8FFDC7: 6B
	db $00,$00,$17,$00,$17,$00,$17,$00,$00,$00,$E9,$FF,$E9,$FF,$E9,$FF	; $8FFDC8
	db $A9,$FF,$FF,$8D,$92,$12,$8D,$94,$12,$AD,$96,$12,$F0,$06,$64,$63	; $8FFDD8
	db $22,$9D,$AE,$80,$AD,$98,$12,$F0,$09,$A9,$02,$00,$85,$63,$22,$9D	; $8FFDE8
	db $AE,$80,$6B,$0C,$01,$0C,$02,$0C,$03,$0C,$04,$0C,$05,$0C,$0A,$0C	; $8FFDF8
	db $09,$0C,$08,$0C,$06,$0C,$07,$0C,$08,$0C,$09,$0C,$0A,$0C,$05,$0C	; $8FFE08
	db $04,$0C,$03,$07,$01,$07,$02,$07,$03,$07,$04,$07,$05,$07,$0B,$07	; $8FFE18
	db $0C,$07,$0D,$07,$06,$07,$07,$07,$08,$07,$09,$07,$0A,$07,$0B,$07	; $8FFE28
	db $0C,$07,$0D,$07,$0E,$07,$0F,$07,$10,$07,$11,$07,$12,$07,$0B,$07	; $8FFE38
	db $0C,$07,$0D,$07,$12,$07,$11,$07,$10,$07,$0F,$07,$0E,$07,$0D,$07	; $8FFE48
	db $0C,$07,$0B,$03,$0E,$03,$0F,$03,$10,$03,$11,$03,$12,$03,$0B,$03	; $8FFE58
	db $0C,$03,$0D,$03,$12,$03,$11,$03,$10,$03,$0F,$03,$0E,$03,$0D,$03	; $8FFE68
	db $0C,$03,$0B	; $8FFE78
CODE_8FFE7B:		; M=16 X=16
	pha		; $8FFE7B: 48
	lda.w #$0001		; $8FFE7C: A9 01 00
	sta.b $21		; $8FFE7F: 85 21
	pla		; $8FFE81: 68
	sta.b $23		; $8FFE82: 85 23
	stz.b $1F		; $8FFE84: 64 1F
	lda.w #$0002		; $8FFE86: A9 02 00
	sta.b $1D		; $8FFE89: 85 1D
	stz.b $21		; $8FFE8B: 64 21
	rtl		; $8FFE8D: 6B
CODE_8FFE8E:		; M=16 X=16
	pla		; $8FFE8E: 68
	inc a		; $8FFE8F: 1A
	sta.w $0179		; $8FFE90: 8D 79 01
	sep #$20		; $8FFE93: E2 20
	pla		; $8FFE95: 68
	sta.w $017B		; $8FFE96: 8D 7B 01
	rep #$20		; $8FFE99: C2 20
	lda.b $00		; $8FFE9B: A5 00
	sec		; $8FFE9D: 38
	sbc.w $04A7		; $8FFE9E: ED A7 04
	cmp.w #$00B4		; $8FFEA1: C9 B4 00
	bcc CODE_8FFEB1		; $8FFEA4: 90 0B
	pla		; $8FFEA6: 68
	beq CODE_8FFEAD		; $8FFEA7: F0 04
	jsl.l $82FB79		; $8FFEA9: 22 79 FB 82
CODE_8FFEAD:		; M=16 X=16
	jml.l $000178		; $8FFEAD: 5C 78 01 00
CODE_8FFEB1:		; M=16 X=16
	pla		; $8FFEB1: 68
	bra CODE_8FFEAD		; $8FFEB2: 80 F9
CODE_8FFEB4:		; M=16 X=16
	stx.b $0A		; $8FFEB4: 86 0A
	ldx.w #$0000		; $8FFEB6: A2 00 00
CODE_8FFEB9:		; M=16 X=16
	lda.b $53,x		; $8FFEB9: B5 53
	pha		; $8FFEBB: 48
	inx		; $8FFEBC: E8
	inx		; $8FFEBD: E8
	cpx.w #$000C		; $8FFEBE: E0 0C 00
	bne CODE_8FFEB9		; $8FFEC1: D0 F6
	ldx.b $0A		; $8FFEC3: A6 0A
	stx.b $0A		; $8FFEC5: 86 0A
	ldx.w #$0000		; $8FFEC7: A2 00 00
CODE_8FFECA:		; M=16 X=16
	lda.b $33,x		; $8FFECA: B5 33
	pha		; $8FFECC: 48
	inx		; $8FFECD: E8
	inx		; $8FFECE: E8
	cpx.w #$0014		; $8FFECF: E0 14 00
	bne CODE_8FFECA		; $8FFED2: D0 F6
	ldx.b $0A		; $8FFED4: A6 0A
	stz.b $3B		; $8FFED6: 64 3B
	jsl.l $86FCB7		; $8FFED8: 22 B7 FC 86
	inc.b $3B		; $8FFEDC: E6 3B
	inc.b $3B		; $8FFEDE: E6 3B
	jsl.l $86FCB7		; $8FFEE0: 22 B7 FC 86
	lda.w #$0000		; $8FFEE4: A9 00 00
	sta.b $45		; $8FFEE7: 85 45
	lda.w #$12F8		; $8FFEE9: A9 F8 12
	clc		; $8FFEEC: 18
	adc.w $12FC		; $8FFEED: 6D FC 12
	sta.b $43		; $8FFEF0: 85 43
	jsl.l $80B90C		; $8FFEF2: 22 0C B9 80
	ora.b $00		; $8FFEF6: 05 00
	lda.l $A9020B,x		; $8FFEF8: BF 0B 02 A9
	ora.b ($00,s),y		; $8FFEFC: 13 00
	sta.b $53		; $8FFEFE: 85 53
	lda.w #$0005		; $8FFF00: A9 05 00
	sta.b $57		; $8FFF03: 85 57
	ldy.w #$0004		; $8FFF05: A0 04 00
	lda.b [$43],y		; $8FFF08: B7 43
	bit.w #$0080		; $8FFF0A: 89 80 00
	bne CODE_8FFF19		; $8FFF0D: D0 0A
	inc.b $57		; $8FFF0F: E6 57
	inc.b $57		; $8FFF11: E6 57
	lda.b [$43],y		; $8FFF13: B7 43
	bmi CODE_8FFF19		; $8FFF15: 30 02
	inc.b $57		; $8FFF17: E6 57
CODE_8FFF19:		; M=16 X=16
	jsl.l $8FD69F		; $8FFF19: 22 9F D6 8F
	stz.b $3B		; $8FFF1D: 64 3B
	ldy.w #$0002		; $8FFF1F: A0 02 00
	lda.b [$43],y		; $8FFF22: B7 43
	bit.w #$0080		; $8FFF24: 89 80 00
	beq CODE_8FFF2D		; $8FFF27: F0 04
	inc.b $3B		; $8FFF29: E6 3B
	inc.b $3B		; $8FFF2B: E6 3B
CODE_8FFF2D:		; M=16 X=16
	lda.w #$FFDC		; $8FFF2D: A9 DC FF
	sta.b $37		; $8FFF30: 85 37
	lda.w #$008F		; $8FFF32: A9 8F 00
	sta.b $39		; $8FFF35: 85 39
	ldy.w #$0003		; $8FFF37: A0 03 00
	lda.b [$43],y		; $8FFF3A: B7 43
	and.w #$00FF		; $8FFF3C: 29 FF 00
	ldy.b $3B		; $8FFF3F: A4 3B
	beq CODE_8FFF47		; $8FFF41: F0 04
	clc		; $8FFF43: 18
	adc.w #$001A		; $8FFF44: 69 1A 00
CODE_8FFF47:		; M=16 X=16
	tay		; $8FFF47: A8
	lda.w $1412,y		; $8FFF48: B9 12 14
	and.w #$00FF		; $8FFF4B: 29 FF 00
	cmp.w #$0003		; $8FFF4E: C9 03 00
	bne CODE_8FFF5A		; $8FFF51: D0 07
	lda.b $37		; $8FFF53: A5 37
	clc		; $8FFF55: 18
	adc.b [$37]		; $8FFF56: 67 37
	sta.b $37		; $8FFF58: 85 37
CODE_8FFF5A:		; M=16 X=16
	jsl.l $8BFCCE		; $8FFF5A: 22 CE FC 8B
	ldy.w #$0003		; $8FFF5E: A0 03 00
	lda.b [$43],y		; $8FFF61: B7 43
	and.w #$00FF		; $8FFF63: 29 FF 00
	sta.b $53		; $8FFF66: 85 53
	jsl.l $8E8182		; $8FFF68: 22 82 81 8E
	jsl.l $80B92D		; $8FFF6C: 22 2D B9 80
	ldy.w #$0004		; $8FFF70: A0 04 00
	lda.b [$43],y		; $8FFF73: B7 43
	and.w #$00FF		; $8FFF75: 29 FF 00
	sta.b $53		; $8FFF78: 85 53
	bit.w #$0080		; $8FFF7A: 89 80 00
	bne CODE_8FFFBD		; $8FFF7D: D0 3E
	jsl.l $80B90C		; $8FFF7F: 22 0C B9 80
	ora.b ($00)		; $8FFF83: 12 00
	lda.l $41060E,x		; $8FFF85: BF 0E 06 41
	adc.b ($73,s),y		; $8FFF89: 73 73
	adc.w #$7473		; $8FFF8B: 69 73 74
	jsr.w $7962		; $8FFF8E: 20 62 79
	dec a		; $8FFF91: 3A
	lda.l $22070C,x		; $8FFF92: BF 0C 07 22
	db $82,$81,$8E		; $8FFF96
	db $22,$2D,$B9,$80,$A0,$05,$00,$B7,$43,$29,$FF,$00,$85,$53,$89,$80	; $8FFF99
	db $00,$D0,$11,$22,$0C,$B9,$80,$05,$00,$BF,$0C,$08,$22,$82,$81,$8E	; $8FFFA9
	db $22,$2D,$B9,$80	; $8FFFB9
CODE_8FFFBD:		; M=16 X=16
	stx.b $0A		; $8FFFBD: 86 0A
	ldx.w #$0012		; $8FFFBF: A2 12 00
CODE_8FFFC2:		; M=16 X=16
	pla		; $8FFFC2: 68
	sta.b $33,x		; $8FFFC3: 95 33
	dex		; $8FFFC5: CA
	dex		; $8FFFC6: CA
	bpl CODE_8FFFC2		; $8FFFC7: 10 F9
	ldx.b $0A		; $8FFFC9: A6 0A
	stx.b $0A		; $8FFFCB: 86 0A
	ldx.w #$000A		; $8FFFCD: A2 0A 00
CODE_8FFFD0:		; M=16 X=16
	pla		; $8FFFD0: 68
	sta.b $53,x		; $8FFFD1: 95 53
	dex		; $8FFFD3: CA
	dex		; $8FFFD4: CA
	bpl CODE_8FFFD0		; $8FFFD5: 10 F9
	ldx.b $0A		; $8FFFD7: A6 0A
	ldx.b $3F		; $8FFFD9: A6 3F
	rtl		; $8FFFDB: 6B
	db $0D,$00,$BF,$0F,$03,$47,$4F,$41,$4C,$21,$BF,$0C,$05,$12,$00,$BF	; $8FFFDC
	db $0C,$03,$48,$41,$54,$20,$54,$52,$49,$43,$4B,$21,$BF,$0C,$05,$00	; $8FFFEC
	db $00,$00,$00,$00	; $8FFFFC
