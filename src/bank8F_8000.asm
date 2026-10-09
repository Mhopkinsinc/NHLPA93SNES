; $8F8000-$8F8FFF  ROM $78000  (from src/bank8F.asm; quick pass, TODO segment agents refine)
org $8F8000

	db $00,$04,$01,$04,$02,$04,$03,$04,$04,$04,$05,$04,$06,$04,$07,$04	; $8F8000
	db $08,$04,$09,$04,$08,$04,$09,$04,$0A,$04,$0B,$04,$0C,$04,$0D,$04	; $8F8010
	db $0E,$04,$0F,$04,$10,$04,$11,$04,$12,$04,$13,$04,$14,$04,$15,$04	; $8F8020
	db $16,$04,$17,$04,$18,$04,$19,$04,$1A,$04,$1B,$04,$1C,$04,$1D,$04	; $8F8030
	db $1E,$04,$1B,$04,$1F,$04,$20,$04,$21,$04,$22,$04,$23,$04,$24,$04	; $8F8040
	db $25,$04,$24,$04,$26,$04,$27,$04,$28,$04,$29,$04,$2A,$04,$2B,$04	; $8F8050
	db $2C,$04,$2D,$04,$2E,$04,$2F,$04,$30,$04,$31,$04,$32,$04,$33,$04	; $8F8060
	db $34,$04,$35,$04,$36,$04,$37,$04,$38,$04,$39,$04,$3A,$04,$3B,$04	; $8F8070
	db $3C,$04,$3D,$04,$3E,$04,$3F,$04,$40,$04,$41,$04,$42,$04,$43,$04	; $8F8080
	db $14,$04,$44,$04,$45,$04,$46,$04,$47,$04,$48,$04,$49,$04,$4A,$04	; $8F8090
	db $4B,$04,$4C,$04,$4D,$04,$4E,$04,$4F,$04,$50,$04,$51,$04,$52,$04	; $8F80A0
	db $53,$04,$54,$04,$55,$04,$56,$04,$57,$04,$58,$04,$59,$04,$5A,$04	; $8F80B0
	db $5B,$04,$58,$04,$5C,$04,$5D,$04,$5E,$04,$5F,$04,$60,$04,$61,$04	; $8F80C0
	db $62,$04,$63,$04,$64,$04,$65,$04,$66,$04,$67,$04,$68,$04,$69,$04	; $8F80D0
	db $6A,$04,$6B,$04,$6C,$04,$6D,$04,$59,$04,$6E,$04,$6F,$04,$70,$04	; $8F80E0
	db $71,$04,$72,$04,$73,$04,$74,$04,$75,$04,$76,$04,$77,$04,$78,$04	; $8F80F0
	db $79,$04,$7A,$04,$7B,$04,$7C,$04,$7D,$04,$7E,$04,$7F,$04,$80,$04	; $8F8100
	db $81,$04,$82,$04,$83,$04,$84,$04,$85,$04,$86,$04,$87,$04,$88,$04	; $8F8110
	db $89,$04,$8A,$04,$8B,$04,$8C,$04,$42,$04,$8D,$04,$8E,$04,$8F,$04	; $8F8120
	db $86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$10,$00,$D0,$F6,$A6	; $8F8130
	db $0A,$86,$0A,$A2,$00,$00,$B5,$37,$48,$E8,$E8,$E0,$04,$00,$D0,$F6	; $8F8140
	db $A6,$0A,$A9,$00,$20,$8D,$77,$04,$A5,$53,$4A,$4A,$4A,$4A,$4A,$4A	; $8F8150
	db $4A,$C9,$20,$00,$90,$03,$A9,$1F,$00,$85,$53,$A0,$02,$00,$A9,$06	; $8F8160
	db $00,$8D,$91,$01,$A9,$03,$00,$85,$5F,$A9,$FF,$FF,$85,$5B,$A5,$53	; $8F8170
	db $30,$0C,$85,$5B,$C9,$08,$00,$90,$05,$A9,$07,$00,$85,$5B,$A5,$5B	; $8F8180
	db $38,$65,$57,$29,$FF,$00,$D0,$03,$A9,$20,$00,$99,$91,$01,$C8,$A5	; $8F8190
	db $53,$38,$E9,$08,$00,$85,$53,$C6,$5F,$10,$CE,$A5,$57,$F0,$06,$A9	; $8F81A0
	db $00,$0C,$0C,$77,$04,$A9,$91,$01,$85,$37,$A9,$00,$00,$85,$39,$AD	; $8F81B0
	db $7B,$04,$38,$E9,$0B,$00,$8D,$7B,$04,$A9,$00,$40,$0C,$77,$04,$A9	; $8F81C0
	db $91,$01,$85,$37,$A9,$00,$00,$85,$39,$E2,$20,$AD,$96,$01,$AC,$93	; $8F81D0
	db $01,$8D,$93,$01,$8C,$96,$01,$C2,$30,$AD,$94,$01,$EB,$8D,$94,$01	; $8F81E0
	db $A9,$00,$40,$1C,$77,$04,$86,$0A,$A2,$02,$00,$68,$95,$37,$CA,$CA	; $8F81F0
	db $10,$F9,$A6,$0A,$86,$0A,$A2,$0E,$00,$68,$95,$53,$CA,$CA,$10,$F9	; $8F8200
	db $A6,$0A,$6B,$05,$00,$53,$63,$31,$05,$00,$53,$63,$32,$05,$00,$43	; $8F8210
	db $68,$6B,$05,$00,$50,$77,$31,$05,$00,$50,$77,$32,$05,$00,$50,$4B	; $8F8220
	db $31,$05,$00,$50,$4B,$32,$04,$00,$31,$12,$04,$00,$32,$13,$04,$00	; $8F8230
	db $33,$14,$04,$00,$4F,$54,$07,$00,$46,$69,$6E,$61,$6C,$00,$04,$01	; $8F8240
	db $04,$02,$04,$03,$04,$04,$04,$05,$04,$06,$04,$07,$04,$08,$04,$09	; $8F8250
	db $04,$0A,$04,$0B,$04,$0C,$04,$0D,$04,$00,$B7,$00,$00,$00,$00,$00	; $8F8260
	db $BA,$00,$00,$00,$00,$00,$00,$C2,$00,$33,$CB,$36,$38,$3A,$3C,$3E	; $8F8270
	db $40,$42,$44,$BB,$00,$00,$00,$00,$48,$4A,$00,$02,$04,$06,$08,$0A	; $8F8280
	db $0C,$0E,$F0,$11,$13,$15,$17,$19,$1B,$1D,$1F,$21,$23,$25,$27,$29	; $8F8290
	db $2B,$2D,$2F,$31	; $8F82A0
CODE_8F82A4:		; M=16 X=16
	lda.w $128C		; $8F82A4: AD 8C 12
	bit.w #$0800		; $8F82A7: 89 00 08
	beq CODE_8F82AF		; $8F82AA: F0 03
	jmp.w $833E		; $8F82AC: 4C 3E 83
CODE_8F82AF:		; M=16 X=16
	lda.w #$0007		; $8F82AF: A9 07 00
	sta.w $0191		; $8F82B2: 8D 91 01
	lda.w #$0020		; $8F82B5: A9 20 00
	sta.w $0193		; $8F82B8: 8D 93 01
	lda.w $12F2		; $8F82BB: AD F2 12
	sta.b $83		; $8F82BE: 85 83
	lda.w #$0258		; $8F82C0: A9 58 02
	sta.b $7D		; $8F82C3: 85 7D
	jsl.l $80B8D8		; $8F82C5: 22 D8 B8 80
	beq CODE_8F82D1		; $8F82C9: F0 06
	adc.w #$0030		; $8F82CB: 69 30 00
	sta.w $0193		; $8F82CE: 8D 93 01
CODE_8F82D1:		; M=16 X=16
	lda.w #$003C		; $8F82D1: A9 3C 00
	sta.b $7D		; $8F82D4: 85 7D
	lda.b $95		; $8F82D6: A5 95
	sta.b $83		; $8F82D8: 85 83
	jsl.l $80B8D8		; $8F82DA: 22 D8 B8 80
	adc.w #$0030		; $8F82DE: 69 30 00
	sta.w $0194		; $8F82E1: 8D 94 01
	lda.w #$003A		; $8F82E4: A9 3A 00
	sta.w $0195		; $8F82E7: 8D 95 01
	lda.w #$000A		; $8F82EA: A9 0A 00
	sta.b $7D		; $8F82ED: 85 7D
	lda.b $95		; $8F82EF: A5 95
	sta.b $83		; $8F82F1: 85 83
	jsl.l $80B8D8		; $8F82F3: 22 D8 B8 80
	adc.w #$0030		; $8F82F7: 69 30 00
	sta.w $0196		; $8F82FA: 8D 96 01
	lda.b $95		; $8F82FD: A5 95
	adc.w #$0030		; $8F82FF: 69 30 00
	sta.w $0197		; $8F8302: 8D 97 01
	lda.w #$2000		; $8F8305: A9 00 20
	sta.w $0477		; $8F8308: 8D 77 04
	lda.w #$0003		; $8F830B: A9 03 00
	sta.w $047B		; $8F830E: 8D 7B 04
	lda.w #$0018		; $8F8311: A9 18 00
	sta.w $047D		; $8F8314: 8D 7D 04
	lda.w $128E		; $8F8317: AD 8E 12
	beq CODE_8F8330		; $8F831A: F0 14
	lda.w #$000D		; $8F831C: A9 0D 00
	sta.w $047B		; $8F831F: 8D 7B 04
	lda.w #$0004		; $8F8322: A9 04 00
	sta.w $047D		; $8F8325: 8D 7D 04
	lda.w $12F0		; $8F8328: AD F0 12
	cmp.w #$0004		; $8F832B: C9 04 00
	beq CODE_8F833E		; $8F832E: F0 0E
CODE_8F8330:		; M=16 X=16
	lda.w #$0191		; $8F8330: A9 91 01
	sta.b $37		; $8F8333: 85 37
	lda.w #$0000		; $8F8335: A9 00 00
	sta.b $39		; $8F8338: 85 39
	jml.l $80B92D		; $8F833A: 5C 2D B9 80
CODE_8F833E:		; M=16 X=16
	rtl		; $8F833E: 6B
	db $BD,$7F,$11,$D0,$43,$BD,$DF,$0E,$89,$02,$00,$F0,$3C,$29,$FD,$FF	; $8F833F
	db $9D,$DF,$0E,$9E,$DF,$0A,$9E,$FF,$0A,$8A,$4A,$38,$E9,$06,$00,$30	; $8F834F
	db $01,$1A,$85,$83,$A9,$0E,$00,$85,$7D,$22,$96,$84,$80,$9D,$5F,$09	; $8F835F
	db $A9,$78,$FF,$9D,$FF,$08,$A9,$02,$00,$9D,$BF,$0D,$9D,$7F,$11,$A9	; $8F836F
	db $1A,$10,$85,$57,$5C,$06,$B0,$80,$6B,$A9,$04,$00,$9D,$BF,$0D,$BD	; $8F837F
	db $DF,$0E,$29,$FF,$6F,$9D,$DF,$0E,$9E,$FF,$11,$9E,$FF,$0D,$A9,$00	; $8F838F
	db $10,$9D,$DF,$0A,$5C,$F9,$96,$80	; $8F839F
CODE_8F83A7:		; M=16 X=16
	phx		; $8F83A7: DA
	stx.b $0A		; $8F83A8: 86 0A
	ldx.w #$0000		; $8F83AA: A2 00 00
CODE_8F83AD:		; M=16 X=16
	lda.b $53,x		; $8F83AD: B5 53
	pha		; $8F83AF: 48
	inx		; $8F83B0: E8
	inx		; $8F83B1: E8
	cpx.w #$000C		; $8F83B2: E0 0C 00
	bne CODE_8F83AD		; $8F83B5: D0 F6
	ldx.b $0A		; $8F83B7: A6 0A
	stx.b $0A		; $8F83B9: 86 0A
	ldx.w #$0000		; $8F83BB: A2 00 00
CODE_8F83BE:		; M=16 X=16
	lda.b $33,x		; $8F83BE: B5 33
	pha		; $8F83C0: 48
	inx		; $8F83C1: E8
	inx		; $8F83C2: E8
	cpx.w #$0008		; $8F83C3: E0 08 00
	bne CODE_8F83BE		; $8F83C6: D0 F6
	ldx.b $0A		; $8F83C8: A6 0A
	lda.b $53		; $8F83CA: A5 53
	cmp.w #$0040		; $8F83CC: C9 40 00
	bne CODE_8F83D4		; $8F83CF: D0 03
	jmp.w $845B		; $8F83D1: 4C 5B 84
CODE_8F83D4:		; M=16 X=16
	sta.b $83		; $8F83D4: 85 83
	lda.w #$0070		; $8F83D6: A9 70 00
	sta.b $7D		; $8F83D9: 85 7D
	jsl.l $8D871C		; $8F83DB: 22 1C 87 8D
	sta.b $53		; $8F83DF: 85 53
	lda.w #$FAEC		; $8F83E1: A9 EC FA
	sta.b $33		; $8F83E4: 85 33
	lda.w #$0083		; $8F83E6: A9 83 00
	sta.b $35		; $8F83E9: 85 35
	lda.w #$0084		; $8F83EB: A9 84 00
	sta.b $75		; $8F83EE: 85 75
	lda.w $1BE1		; $8F83F0: AD E1 1B
	sta.b $73		; $8F83F3: 85 73
	lda.w $128E		; $8F83F5: AD 8E 12
	beq CODE_8F840E		; $8F83F8: F0 14
	lda.w $1BDF		; $8F83FA: AD DF 1B
	sta.b $73		; $8F83FD: 85 73
	lda.w #$03DA		; $8F83FF: A9 DA 03
	sta.b $75		; $8F8402: 85 75
	lda.w #$F3FB		; $8F8404: A9 FB F3
	sta.b $33		; $8F8407: 85 33
	lda.w #$0089		; $8F8409: A9 89 00
	sta.b $35		; $8F840C: 85 35
CODE_8F840E:		; M=16 X=16
	lda.b $33		; $8F840E: A5 33
	clc		; $8F8410: 18
	adc.b $53		; $8F8411: 65 53
	sta.b $33		; $8F8413: 85 33
	lda.w #$0008		; $8F8415: A9 08 00
	sta.b $77		; $8F8418: 85 77
CODE_8F841A:		; M=16 X=16
	ldy.w #$0007		; $8F841A: A0 07 00
CODE_8F841D:		; M=16 X=16
	lda.b [$33]		; $8F841D: A7 33
	clc		; $8F841F: 18
	adc.b $73		; $8F8420: 65 73
	adc.w $1BCD		; $8F8422: 6D CD 1B
	ldx.b $75		; $8F8425: A6 75
	ora.w #$2000		; $8F8427: 09 00 20
	sta.l $7E6E74,x		; $8F842A: 9F 74 6E 7E
	txa		; $8F842E: 8A
	lsr a		; $8F842F: 4A
	cmp.b $D0		; $8F8430: C5 D0
	bcs CODE_8F8436		; $8F8432: B0 02
	sta.b $D0		; $8F8434: 85 D0
CODE_8F8436:		; M=16 X=16
	cmp.b $D2		; $8F8436: C5 D2
	bcc CODE_8F843C		; $8F8438: 90 02
	sta.b $D2		; $8F843A: 85 D2
CODE_8F843C:		; M=16 X=16
	inc.b $33		; $8F843C: E6 33
	inc.b $33		; $8F843E: E6 33
	inc.b $75		; $8F8440: E6 75
	inc.b $75		; $8F8442: E6 75
	dey		; $8F8444: 88
	bne CODE_8F841D		; $8F8445: D0 D6
	lda.b $75		; $8F8447: A5 75
	clc		; $8F8449: 18
	adc.w #$0032		; $8F844A: 69 32 00
	sta.b $75		; $8F844D: 85 75
	dec.b $77		; $8F844F: C6 77
	bne CODE_8F841A		; $8F8451: D0 C7
	lda.w #$0200		; $8F8453: A9 00 02
	tsb.w $128C		; $8F8456: 0C 8C 12
	bra CODE_8F8497		; $8F8459: 80 3C
CODE_8F845B:		; M=16 X=16
	lda.w #$0007		; $8F845B: A9 07 00
	sta.b $53		; $8F845E: 85 53
	lda.w #$0008		; $8F8460: A9 08 00
	sta.b $57		; $8F8463: 85 57
	lda.w $1BE7		; $8F8465: AD E7 1B
	sta.b $5B		; $8F8468: 85 5B
	lda.w #$0002		; $8F846A: A9 02 00
	sta.w $047B		; $8F846D: 8D 7B 04
	sta.w $047D		; $8F8470: 8D 7D 04
	lda.w $128E		; $8F8473: AD 8E 12
	beq CODE_8F8484		; $8F8476: F0 0C
	lda.w #$000D		; $8F8478: A9 0D 00
	sta.w $047B		; $8F847B: 8D 7B 04
	lda.w #$000F		; $8F847E: A9 0F 00
	sta.w $047D		; $8F8481: 8D 7D 04
CODE_8F8484:		; M=16 X=16
	jsl.l $8D847C		; $8F8484: 22 7C 84 8D
	lda.w #$0200		; $8F8488: A9 00 02
	tsb.w $128C		; $8F848B: 0C 8C 12
	lda.w #$FFFF		; $8F848E: A9 FF FF
	sta.b $53		; $8F8491: 85 53
	jsl.l $8FF63D		; $8F8493: 22 3D F6 8F
CODE_8F8497:		; M=16 X=16
	stx.b $0A		; $8F8497: 86 0A
	ldx.w #$0006		; $8F8499: A2 06 00
CODE_8F849C:		; M=16 X=16
	pla		; $8F849C: 68
	sta.b $33,x		; $8F849D: 95 33
	dex		; $8F849F: CA
	dex		; $8F84A0: CA
	bpl CODE_8F849C		; $8F84A1: 10 F9
	ldx.b $0A		; $8F84A3: A6 0A
	stx.b $0A		; $8F84A5: 86 0A
	ldx.w #$000A		; $8F84A7: A2 0A 00
CODE_8F84AA:		; M=16 X=16
	pla		; $8F84AA: 68
	sta.b $53,x		; $8F84AB: 95 53
	dex		; $8F84AD: CA
	dex		; $8F84AE: CA
	bpl CODE_8F84AA		; $8F84AF: 10 F9
	ldx.b $0A		; $8F84B1: A6 0A
	plx		; $8F84B3: FA
	rtl		; $8F84B4: 6B
CODE_8F84B5:		; M=16 X=16
	stx.b $0A		; $8F84B5: 86 0A
	ldx.w #$0000		; $8F84B7: A2 00 00
CODE_8F84BA:		; M=16 X=16
	lda.b $53,x		; $8F84BA: B5 53
	pha		; $8F84BC: 48
	inx		; $8F84BD: E8
	inx		; $8F84BE: E8
	cpx.w #$001C		; $8F84BF: E0 1C 00
	bne CODE_8F84BA		; $8F84C2: D0 F6
	ldx.b $0A		; $8F84C4: A6 0A
	stx.b $0A		; $8F84C6: 86 0A
	ldx.w #$0000		; $8F84C8: A2 00 00
CODE_8F84CB:		; M=16 X=16
	lda.b $33,x		; $8F84CB: B5 33
	pha		; $8F84CD: 48
	inx		; $8F84CE: E8
	inx		; $8F84CF: E8
	cpx.w #$001C		; $8F84D0: E0 1C 00
	bne CODE_8F84CB		; $8F84D3: D0 F6
	ldx.b $0A		; $8F84D5: A6 0A
	lda.w $0AFB		; $8F84D7: AD FB 0A
	pha		; $8F84DA: 48
	asl a		; $8F84DB: 0A
	pla		; $8F84DC: 68
	ror a		; $8F84DD: 6A
	sta.w $0AFB		; $8F84DE: 8D FB 0A
	lda.w $0B1B		; $8F84E1: AD 1B 0B
	pha		; $8F84E4: 48
	asl a		; $8F84E5: 0A
	pla		; $8F84E6: 68
	ror a		; $8F84E7: 6A
	sta.w $0B1B		; $8F84E8: 8D 1B 0B
	jsl.l $8FE404		; $8F84EB: 22 04 E4 8F
	lda.w #$0001		; $8F84EF: A9 01 00
	sta.w $128E		; $8F84F2: 8D 8E 12
	stz.w $0156		; $8F84F5: 9C 56 01
	lda.w #$FFFF		; $8F84F8: A9 FF FF
	sta.w $08E1		; $8F84FB: 8D E1 08
	lda.w #$002E		; $8F84FE: A9 2E 00
	sta.w $049B		; $8F8501: 8D 9B 04
	stz.w $049D		; $8F8504: 9C 9D 04
	jsl.l $80B76C		; $8F8507: 22 6C B7 80
	jsl.l $8FF58D		; $8F850B: 22 8D F5 8F
	stx.b $0A		; $8F850F: 86 0A
	ldx.w #$001A		; $8F8511: A2 1A 00
CODE_8F8514:		; M=16 X=16
	pla		; $8F8514: 68
	sta.b $33,x		; $8F8515: 95 33
	dex		; $8F8517: CA
	dex		; $8F8518: CA
	bpl CODE_8F8514		; $8F8519: 10 F9
	ldx.b $0A		; $8F851B: A6 0A
	stx.b $0A		; $8F851D: 86 0A
	ldx.w #$001A		; $8F851F: A2 1A 00
CODE_8F8522:		; M=16 X=16
	pla		; $8F8522: 68
	sta.b $53,x		; $8F8523: 95 53
	dex		; $8F8525: CA
	dex		; $8F8526: CA
	bpl CODE_8F8522		; $8F8527: 10 F9
	ldx.b $0A		; $8F8529: A6 0A
	ldx.b $3F		; $8F852B: A6 3F
	rtl		; $8F852D: 6B
CODE_8F852E:		; M=16 X=16
	stx.b $0A		; $8F852E: 86 0A
	ldx.w #$0000		; $8F8530: A2 00 00
CODE_8F8533:		; M=16 X=16
	lda.b $53,x		; $8F8533: B5 53
	pha		; $8F8535: 48
	inx		; $8F8536: E8
	inx		; $8F8537: E8
	cpx.w #$0020		; $8F8538: E0 20 00
	bne CODE_8F8533		; $8F853B: D0 F6
	ldx.b $0A		; $8F853D: A6 0A
	stx.b $0A		; $8F853F: 86 0A
	ldx.w #$0000		; $8F8541: A2 00 00
CODE_8F8544:		; M=16 X=16
	lda.b $33,x		; $8F8544: B5 33
	pha		; $8F8546: 48
	inx		; $8F8547: E8
	inx		; $8F8548: E8
	cpx.w #$0010		; $8F8549: E0 10 00
	bne CODE_8F8544		; $8F854C: D0 F6
	ldx.b $0A		; $8F854E: A6 0A
	jsl.l $89E95D		; $8F8550: 22 5D E9 89
	jsl.l $80B90C		; $8F8554: 22 0C B9 80
	ora.b $00		; $8F8558: 05 00
	lda.l $640814,x		; $8F855A: BF 14 08 64
	tsc		; $8F855E: 3B
	jsl.l $8F8594		; $8F855F: 22 94 85 8F
	jsl.l $80B90C		; $8F8563: 22 0C B9 80
	ora.b $00		; $8F8567: 05 00
	lda.l $A90805,x		; $8F8569: BF 05 08 A9
	db $02,$00,$85,$3B,$22,$94,$85,$8F,$86,$0A,$A2,$0E,$00,$68,$95,$33	; $8F856D
	db $CA,$CA,$10,$F9,$A6,$0A,$86,$0A,$A2,$1E,$00,$68,$95,$53,$CA,$CA	; $8F857D
	db $10,$F9,$A6,$0A,$A6,$3F	; $8F858D
CODE_8F8593:		; M=16 X=16
	rtl		; $8F8593: 6B
CODE_8F8594:		; M=16 X=16
	lda.b $3B		; $8F8594: A5 3B
	beq CODE_8F859B		; $8F8596: F0 03
	lda.w #$001A		; $8F8598: A9 1A 00
CODE_8F859B:		; M=16 X=16
	sta.b $33		; $8F859B: 85 33
CODE_8F859D:		; M=16 X=16
	ldy.b $33		; $8F859D: A4 33
	lda.w $154A,y		; $8F859F: B9 4A 15
	inc.b $33		; $8F85A2: E6 33
	and.w #$00FF		; $8F85A4: 29 FF 00
	sta.b $53		; $8F85A7: 85 53
	bit.w #$0080		; $8F85A9: 89 80 00
	bne CODE_8F85C7		; $8F85AC: D0 19
	lda.b $3B		; $8F85AE: A5 3B
	beq CODE_8F85B5		; $8F85B0: F0 03
	lda.w #$0034		; $8F85B2: A9 34 00
CODE_8F85B5:		; M=16 X=16
	clc		; $8F85B5: 18
	adc.b $53		; $8F85B6: 65 53
	tay		; $8F85B8: A8
	lda.w $14E2,y		; $8F85B9: B9 E2 14
	bit.w #$4000		; $8F85BC: 89 00 40
	bne CODE_8F859D		; $8F85BF: D0 DC
	jsl.l $8F85FA		; $8F85C1: 22 FA 85 8F
	bra CODE_8F859D		; $8F85C5: 80 D6
CODE_8F85C7:		; M=16 X=16
	lda.b $3B		; $8F85C7: A5 3B
	beq CODE_8F85CE		; $8F85C9: F0 03
	lda.w #$001A		; $8F85CB: A9 1A 00
CODE_8F85CE:		; M=16 X=16
	sta.b $33		; $8F85CE: 85 33
CODE_8F85D0:		; M=16 X=16
	ldy.b $33		; $8F85D0: A4 33
	lda.w $154A,y		; $8F85D2: B9 4A 15
	inc.b $33		; $8F85D5: E6 33
	and.w #$00FF		; $8F85D7: 29 FF 00
	sta.b $53		; $8F85DA: 85 53
	bit.w #$0080		; $8F85DC: 89 80 00
	bne CODE_8F8593		; $8F85DF: D0 B2
	lda.b $3B		; $8F85E1: A5 3B
	beq CODE_8F85E8		; $8F85E3: F0 03
	lda.w #$0034		; $8F85E5: A9 34 00
CODE_8F85E8:		; M=16 X=16
	clc		; $8F85E8: 18
	adc.b $53		; $8F85E9: 65 53
	tay		; $8F85EB: A8
	lda.w $14E2,y		; $8F85EC: B9 E2 14
	bit.w #$4000		; $8F85EF: 89 00 40
	beq CODE_8F85D0		; $8F85F2: F0 DC
	jsl.l $8F85FA		; $8F85F4: 22 FA 85 8F
	bra CODE_8F85D0		; $8F85F8: 80 D6
CODE_8F85FA:		; M=16 X=16
	lda.w $047D		; $8F85FA: AD 7D 04
	cmp.w #$000B		; $8F85FD: C9 0B 00
	bcs CODE_8F8593		; $8F8600: B0 91
	lda.b $3B		; $8F8602: A5 3B
	beq CODE_8F8609		; $8F8604: F0 03
	lda.w #$0034		; $8F8606: A9 34 00
CODE_8F8609:		; M=16 X=16
	adc.b $53		; $8F8609: 65 53
	tay		; $8F860B: A8
	lda.w $14E2,y		; $8F860C: B9 E2 14
	and.w #$07FF		; $8F860F: 29 FF 07
	sta.b $5B		; $8F8612: 85 5B
	lda.w #$0083		; $8F8614: A9 83 00
	sta.b $39		; $8F8617: 85 39
	ldy.b $3B		; $8F8619: A4 3B
	lda.w $13CE,y		; $8F861B: B9 CE 13
	sta.b $37		; $8F861E: 85 37
	ldy.w #$0000		; $8F8620: A0 00 00
	adc.b [$37],y		; $8F8623: 77 37
	sta.b $37		; $8F8625: 85 37
	lsr.b $53		; $8F8627: 46 53
CODE_8F8629:		; M=16 X=16
	lda.b [$37]		; $8F8629: A7 37
	clc		; $8F862B: 18
	adc.b $37		; $8F862C: 65 37
	adc.w #$0008		; $8F862E: 69 08 00
	sta.b $37		; $8F8631: 85 37
	dec.b $53		; $8F8633: C6 53
	bpl CODE_8F8629		; $8F8635: 10 F2
	lda.b $37		; $8F8637: A5 37
	sec		; $8F8639: 38
	sbc.w #$0008		; $8F863A: E9 08 00
	sta.b $37		; $8F863D: 85 37
	lda.b [$37]		; $8F863F: A7 37
	and.w #$00FF		; $8F8641: 29 FF 00
	sta.b $53		; $8F8644: 85 53
	lda.w $047B		; $8F8646: AD 7B 04
	pha		; $8F8649: 48
	lda.w #$0193		; $8F864A: A9 93 01
	sta.b $37		; $8F864D: 85 37
	lda.w #$0000		; $8F864F: A9 00 00
	sta.b $39		; $8F8652: 85 39
	jsl.l $84EA39		; $8F8654: 22 39 EA 84
	lda.w #$0191		; $8F8658: A9 91 01
	sta.b $37		; $8F865B: 85 37
	lda.w #$0000		; $8F865D: A9 00 00
	sta.b $39		; $8F8660: 85 39
	lda.w #$0004		; $8F8662: A9 04 00
	sta.b [$37]		; $8F8665: 87 37
	jsl.l $80B92D		; $8F8667: 22 2D B9 80
	lda.b $5B		; $8F866B: A5 5B
	sta.b $53		; $8F866D: 85 53
	jsl.l $8F87EA		; $8F866F: 22 EA 87 8F
	inc.w $047B		; $8F8673: EE 7B 04
	jsl.l $80B92D		; $8F8676: 22 2D B9 80
	pla		; $8F867A: 68
	sta.w $047B		; $8F867B: 8D 7B 04
	inc.w $047D		; $8F867E: EE 7D 04
	rtl		; $8F8681: 6B
CODE_8F8682:		; M=16 X=16
	lda.w #$01AF		; $8F8682: A9 AF 01
	sta.b $37		; $8F8685: 85 37
	lda.w #$0000		; $8F8687: A9 00 00
	sta.b $39		; $8F868A: 85 39
	lda.b $53		; $8F868C: A5 53
CODE_8F868E:		; M=16 X=16
	sta.b $83		; $8F868E: 85 83
	lda.w #$000A		; $8F8690: A9 0A 00
	sta.b $7D		; $8F8693: 85 7D
	jsl.l $80B8D8		; $8F8695: 22 D8 B8 80
	dec.b $37		; $8F8699: C6 37
	sep #$20		; $8F869B: E2 20
	lda.b $95		; $8F869D: A5 95
	adc.b #$30		; $8F869F: 69 30
	sta.b [$37]		; $8F86A1: 87 37
	rep #$30		; $8F86A3: C2 30
	lda.b $93		; $8F86A5: A5 93
	bne CODE_8F868E		; $8F86A7: D0 E5
	dec.b $37		; $8F86A9: C6 37
	dec.b $37		; $8F86AB: C6 37
	lda.w #$01AF		; $8F86AD: A9 AF 01
	sec		; $8F86B0: 38
	sbc.b $37		; $8F86B1: E5 37
	sta.b [$37]		; $8F86B3: 87 37
	rtl		; $8F86B5: 6B
	db $22,$1A,$FA,$82,$22,$0A,$E0,$8F,$A9,$00,$00,$A0,$1E,$00,$99,$FF	; $8F86B6
	db $08,$88,$88,$10,$F9,$A5,$00,$A4,$02,$C5,$00,$D0,$F8,$8D,$FB,$08	; $8F86C6
	db $8C,$FD,$08,$A9,$01,$00,$1C,$8C,$12,$AD,$F0,$12,$C9,$04,$00,$F0	; $8F86D6
	db $02,$80,$00,$A9,$08,$07,$85,$EE,$A9,$01,$00,$8D,$D5,$08,$A5,$00	; $8F86E6
	db $38,$E9,$50,$01,$8D,$D9,$08,$22,$3F,$87,$8F,$AD,$D7,$08,$8D,$58	; $8F86F6
	db $01,$A9,$00,$00,$A0,$1E,$00,$99,$FF,$08,$88,$88,$10,$F9,$22,$0C	; $8F8706
	db $B9,$80,$05,$00,$BF,$05,$0C,$A9,$16,$00,$85,$53,$A9,$07,$00,$85	; $8F8716
	db $57,$22,$9F,$D6,$8F,$22,$5D,$E9,$89,$A9,$02,$00,$1C,$8C,$12,$22	; $8F8726
	db $91,$F8,$83,$D0,$CC,$9C,$D5,$08,$6B,$AD,$D7,$08,$30,$05,$0D,$4C	; $8F8736
	db $01,$D0,$0B,$22,$A4,$D5,$85,$A5,$57,$8D,$D7,$08,$30,$EA,$4C,$61	; $8F8746
	db $88,$22,$E3,$FA,$84,$A5,$00,$48,$22,$5E,$E3,$80,$22,$E8,$F3,$80	; $8F8756
	db $22,$0E,$FF,$85,$A5,$57,$89,$80,$00,$D0,$0A,$A5,$00,$38,$E3,$01	; $8F8766
	db $C9,$10,$0E,$90,$E3,$68,$6B,$AD,$D5,$08,$F0,$21,$A5,$00,$38,$ED	; $8F8776
	db $D9,$08,$C9,$50,$01,$90,$17,$22,$A8,$87,$8F,$AD,$58,$01,$CD,$D7	; $8F8786
	db $08,$D0,$E4,$22,$1B,$8C,$8F,$A9,$08,$00,$1C,$90,$12,$6B,$A9,$00	; $8F8796
	db $00,$6B,$AD,$D7,$08,$30,$05,$0D,$4C,$01,$D0,$0B,$22,$A4,$D5,$85	; $8F87A6
	db $A5,$57,$8D,$D7,$08,$30,$E6,$4C,$61,$88	; $8F87B6
CODE_8F87C0:		; M=16 X=16
	lda.w #$0088		; $8F87C0: A9 88 00
	pha		; $8F87C3: 48
	jsl.l $8FFE8E		; $8F87C4: 22 8E FE 8F
	rtl		; $8F87C8: 6B
CODE_8F87C9:		; M=16 X=16
	lda.w #$0002		; $8F87C9: A9 02 00
	sta.b $73		; $8F87CC: 85 73
	lda.b [$3F]		; $8F87CE: A7 3F
	sta.b $75		; $8F87D0: 85 75
CODE_8F87D2:		; M=16 X=16
	lda.b $73		; $8F87D2: A5 73
	cmp.b [$37]		; $8F87D4: C7 37
	beq CODE_8F87E5		; $8F87D6: F0 0D
	tay		; $8F87D8: A8
	lda.b [$37],y		; $8F87D9: B7 37
	ldy.b $75		; $8F87DB: A4 75
	sta.b [$3F],y		; $8F87DD: 97 3F
	inc.b $73		; $8F87DF: E6 73
	inc.b $75		; $8F87E1: E6 75
	bra CODE_8F87D2		; $8F87E3: 80 ED
CODE_8F87E5:		; M=16 X=16
	lda.b $75		; $8F87E5: A5 75
	sta.b [$3F]		; $8F87E7: 87 3F
	rtl		; $8F87E9: 6B
CODE_8F87EA:		; M=16 X=16
	lda.w #$01AF		; $8F87EA: A9 AF 01
	sta.b $37		; $8F87ED: 85 37
	lda.w #$0000		; $8F87EF: A9 00 00
	sta.b $39		; $8F87F2: 85 39
	lda.b $53		; $8F87F4: A5 53
	sta.b $83		; $8F87F6: 85 83
	lda.w #$000A		; $8F87F8: A9 0A 00
	sta.b $7D		; $8F87FB: 85 7D
	jsl.l $80B8D8		; $8F87FD: 22 D8 B8 80
	dec.b $37		; $8F8801: C6 37
	sep #$20		; $8F8803: E2 20
	lda.b $95		; $8F8805: A5 95
	adc.b #$30		; $8F8807: 69 30
	sta.b [$37]		; $8F8809: 87 37
	rep #$30		; $8F880B: C2 30
	lda.w #$0006		; $8F880D: A9 06 00
	sta.b $7D		; $8F8810: 85 7D
	jsl.l $80B8D8		; $8F8812: 22 D8 B8 80
	dec.b $37		; $8F8816: C6 37
	sep #$20		; $8F8818: E2 20
	lda.b $95		; $8F881A: A5 95
	adc.b #$30		; $8F881C: 69 30
	sta.b [$37]		; $8F881E: 87 37
	dec.b $37		; $8F8820: C6 37
	lda.b #$3A		; $8F8822: A9 3A
	sta.b [$37]		; $8F8824: 87 37
	rep #$30		; $8F8826: C2 30
	lda.w #$000A		; $8F8828: A9 0A 00
	sta.b $7D		; $8F882B: 85 7D
	jsl.l $80B8D8		; $8F882D: 22 D8 B8 80
	dec.b $37		; $8F8831: C6 37
	sep #$20		; $8F8833: E2 20
	lda.b $95		; $8F8835: A5 95
	adc.b #$30		; $8F8837: 69 30
	sta.b [$37]		; $8F8839: 87 37
	rep #$30		; $8F883B: C2 30
	lda.b $93		; $8F883D: A5 93
	beq CODE_8F884B		; $8F883F: F0 0A
	dec.b $37		; $8F8841: C6 37
	sep #$20		; $8F8843: E2 20
	adc.b #$30		; $8F8845: 69 30
	sta.b [$37]		; $8F8847: 87 37
	rep #$30		; $8F8849: C2 30
CODE_8F884B:		; M=16 X=16
	dec.b $37		; $8F884B: C6 37
	dec.b $37		; $8F884D: C6 37
	lda.w #$01AF		; $8F884F: A9 AF 01
	sec		; $8F8852: 38
	sbc.b $37		; $8F8853: E5 37
	sta.b [$37]		; $8F8855: 87 37
	rtl		; $8F8857: 6B
CODE_8F8858:		; M=16 X=16
	lda.w $12F2		; $8F8858: AD F2 12
	cmp.w #$01E1		; $8F885B: C9 E1 01
	bcc CODE_8F8861		; $8F885E: 90 01
	rtl		; $8F8860: 6B
CODE_8F8861:		; M=16 X=16
	lda.w $1600		; $8F8861: AD 00 16
	beq CODE_8F8879		; $8F8864: F0 13
	lda.w $08D7		; $8F8866: AD D7 08
	sta.b $5F		; $8F8869: 85 5F
	bmi CODE_8F8879		; $8F886B: 30 0C
	dec.w $08D7		; $8F886D: CE D7 08
	lda.b $5F		; $8F8870: A5 5F
	cmp.w $014C		; $8F8872: CD 4C 01
	beq CODE_8F8861		; $8F8875: F0 EA
	bra CODE_8F887A		; $8F8877: 80 01
CODE_8F8879:		; M=16 X=16
	rtl		; $8F8879: 6B
CODE_8F887A:		; M=16 X=16
	lda.b $5F		; $8F887A: A5 5F
	asl a		; $8F887C: 0A
	sta.b $33		; $8F887D: 85 33
	tay		; $8F887F: A8
	lda.w $15EF,y		; $8F8880: B9 EF 15
	bit.w #$0006		; $8F8883: 89 06 00
	bne CODE_8F8861		; $8F8886: D0 D9
	jsl.l $80B90C		; $8F8888: 22 0C B9 80
	ora.b $00		; $8F888C: 05 00
	lda.l $AD1702,x		; $8F888E: BF 02 17 AD
	sty.w $8912		; $8F8892: 8C 12 89
	ora.b ($00,x)		; $8F8895: 01 00
	db $D0,$09 ; bne $8F88A2		; $8F8897: D0 09
	jsl.l $80B90C		; $8F8899: 22 0C B9 80
	ora.b $00		; $8F889D: 05 00
	lda.l $AD1702,x		; $8F889F: BF 02 17 AD
	stx.w $D012		; $8F88A3: 8E 12 D0
	asl a		; $8F88A6: 0A
	lda.w $047D		; $8F88A7: AD 7D 04
	sec		; $8F88AA: 38
	sbc.w #$0005		; $8F88AB: E9 05 00
	sta.w $047D		; $8F88AE: 8D 7D 04
	lda.w #$001C		; $8F88B1: A9 1C 00
	sta.b $53		; $8F88B4: 85 53
	lda.w #$0005		; $8F88B6: A9 05 00
	sta.b $57		; $8F88B9: 85 57
	jsl.l $8FD69F		; $8F88BB: 22 9F D6 8F
	lda.b $00		; $8F88BF: A5 00
	sta.w $08D9		; $8F88C1: 8D D9 08
	inc.w $047B		; $8F88C4: EE 7B 04
	lda.w $047D		; $8F88C7: AD 7D 04
	sec		; $8F88CA: 38
	sbc.w #$0004		; $8F88CB: E9 04 00
	sta.w $047D		; $8F88CE: 8D 7D 04
	lda.w $047B		; $8F88D1: AD 7B 04
	pha		; $8F88D4: 48
	jsl.l $85D5A4		; $8F88D5: 22 A4 D5 85
	lda.w #$2400		; $8F88D9: A9 00 24
	sta.w $0477		; $8F88DC: 8D 77 04
	jsl.l $80B90C		; $8F88DF: 22 0C B9 80
	trb.w $2000		; $8F88E3: 1C 00 20
	jsr.w $2020		; $8F88E6: 20 20 20
	jsr.w $2020		; $8F88E9: 20 20 20
	jsr.w $2020		; $8F88EC: 20 20 20
	jsr.w $2020		; $8F88EF: 20 20 20
	jsr.w $2020		; $8F88F2: 20 20 20
	jsr.w $2020		; $8F88F5: 20 20 20
	jsr.w $2020		; $8F88F8: 20 20 20
	jsr.w $2020		; $8F88FB: 20 20 20
	jsr.w $01A3		; $8F88FE: 20 A3 01
	sta.w $047B		; $8F8901: 8D 7B 04
	lda.b $5F		; $8F8904: A5 5F
	clc		; $8F8906: 18
	adc.b $5B		; $8F8907: 65 5B
	sta.b $53		; $8F8909: 85 53
	lda.w #$89A3		; $8F890B: A9 A3 89
	sta.b $37		; $8F890E: 85 37
	lda.w #$008F		; $8F8910: A9 8F 00
	sta.b $39		; $8F8913: 85 39
	jsl.l $8FD68C		; $8F8915: 22 8C D6 8F
	lda.b $01,s		; $8F8919: A3 01
	clc		; $8F891B: 18
	adc.w #$0015		; $8F891C: 69 15 00
	sta.w $047B		; $8F891F: 8D 7B 04
	ldy.b $33		; $8F8922: A4 33
	lda.w $15BF,y		; $8F8924: B9 BF 15
	dec a		; $8F8927: 3A
	sta.b $53		; $8F8928: 85 53
	lda.w #$8236		; $8F892A: A9 36 82
	sta.b $37		; $8F892D: 85 37
	lda.w #$008F		; $8F892F: A9 8F 00
	sta.b $39		; $8F8932: 85 39
	jsl.l $8FD68C		; $8F8934: 22 8C D6 8F
	lda.w #$2000		; $8F8938: A9 00 20
	sta.w $0477		; $8F893B: 8D 77 04
	ldy.b $33		; $8F893E: A4 33
	lda.w $157F,y		; $8F8940: B9 7F 15
	sta.b $53		; $8F8943: 85 53
	lda.w $15CF,y		; $8F8945: B9 CF 15
	sta.b $57		; $8F8948: 85 57
	jsl.l $8F8960		; $8F894A: 22 60 89 8F
	ldy.b $33		; $8F894E: A4 33
	lda.w $158F,y		; $8F8950: B9 8F 15
	sta.b $53		; $8F8953: 85 53
	lda.w $15DF,y		; $8F8955: B9 DF 15
	sta.b $57		; $8F8958: 85 57
	jsl.l $8F8960		; $8F895A: 22 60 89 8F
	pla		; $8F895E: 68
	rtl		; $8F895F: 6B
CODE_8F8960:		; M=16 X=16
	lda.b $04,s		; $8F8960: A3 04
	sta.w $047B		; $8F8962: 8D 7B 04
	inc.w $047D		; $8F8965: EE 7D 04
	lda.w #$8000		; $8F8968: A9 00 80
	sta.b $37		; $8F896B: 85 37
	lda.w #$0083		; $8F896D: A9 83 00
	sta.b $39		; $8F8970: 85 39
	asl.b $53		; $8F8972: 06 53
	asl.b $53		; $8F8974: 06 53
	ldy.b $53		; $8F8976: A4 53
	lda.b [$37],y		; $8F8978: B7 37
	sta.b $37		; $8F897A: 85 37
	lda.w #$0083		; $8F897C: A9 83 00
	sta.b $39		; $8F897F: 85 39
	ldy.w #$0004		; $8F8981: A0 04 00
	lda.b [$37],y		; $8F8984: B7 37
	adc.b $37		; $8F8986: 65 37
	sta.b $37		; $8F8988: 85 37
	jsl.l $80B92D		; $8F898A: 22 2D B9 80
	lda.b $04,s		; $8F898E: A3 04
	clc		; $8F8990: 18
	adc.w #$0017		; $8F8991: 69 17 00
	sta.w $047B		; $8F8994: 8D 7B 04
	lda.b $57		; $8F8997: A5 57
	sta.b $53		; $8F8999: 85 53
	jsl.l $8F8682		; $8F899B: 22 82 86 8F
	jml.l $80B92D		; $8F899F: 5C 2D B9 80
	db $13,$00,$45,$41,$53,$4E,$20,$48,$6F,$63,$6B,$65,$79,$20,$4E,$69	; $8F89A3
	db $67,$68,$74,$12,$00,$45,$41,$20,$43,$75,$70,$20,$51,$75,$61,$6C	; $8F89B3
	db $69,$66,$69,$65,$72,$12,$00,$45,$41,$20,$43,$75,$70,$20,$51,$75	; $8F89C3
	db $61,$6C,$69,$66,$69,$65,$72,$12,$00,$45,$41,$20,$43,$75,$70,$20	; $8F89D3
	db $51,$75,$61,$6C,$69,$66,$69,$65,$72,$12,$00,$45,$41,$20,$43,$75	; $8F89E3
	db $70,$20,$51,$75,$61,$6C,$69,$66,$69,$65,$72,$12,$00,$45,$41,$20	; $8F89F3
	db $43,$75,$70,$20,$51,$75,$61,$6C,$69,$66,$69,$65,$72,$12,$00,$45	; $8F8A03
	db $41,$20,$43,$75,$70,$20,$51,$75,$61,$6C,$69,$66,$69,$65,$72,$12	; $8F8A13
	db $00,$45,$41,$20,$43,$75,$70,$20,$51,$75,$61,$6C,$69,$66,$69,$65	; $8F8A23
	db $72,$12,$00,$45,$41,$20,$43,$75,$70,$20,$51,$75,$61,$6C,$69,$66	; $8F8A33
	db $69,$65,$72,$11,$00,$45,$41,$20,$51,$75,$61,$72,$74,$65,$72,$66	; $8F8A43
	db $69,$6E,$61,$6C,$11,$00,$45,$41,$20,$51,$75,$61,$72,$74,$65,$72	; $8F8A53
	db $66,$69,$6E,$61,$6C,$11,$00,$45,$41,$20,$51,$75,$61,$72,$74,$65	; $8F8A63
	db $72,$66,$69,$6E,$61,$6C,$11,$00,$45,$41,$20,$51,$75,$61,$72,$74	; $8F8A73
	db $65,$72,$66,$69,$6E,$61,$6C,$12,$00,$45,$41,$20,$43,$75,$70,$20	; $8F8A83
	db $53,$65,$6D,$69,$66,$69,$6E,$61,$6C,$12,$00,$45,$41,$20,$43,$75	; $8F8A93
	db $70,$20,$53,$65,$6D,$69,$66,$69,$6E,$61,$6C,$0E,$00,$45,$41,$20	; $8F8AA3
	db $43,$75,$70,$20,$66,$69,$6E,$61,$6C	; $8F8AB3
CODE_8F8ABC:		; M=16 X=16
	lda.b $00		; $8F8ABC: A5 00
	ldy.b $02		; $8F8ABE: A4 02
	cmp.b $00		; $8F8AC0: C5 00
	bne CODE_8F8ABC		; $8F8AC2: D0 F8
	sbc.w $08FB		; $8F8AC4: ED FB 08
	sta.b $73		; $8F8AC7: 85 73
	tya		; $8F8AC9: 98
	sbc.w $08FD		; $8F8ACA: ED FD 08
	bne CODE_8F8AE8		; $8F8ACD: D0 19
	lda.w $128E		; $8F8ACF: AD 8E 12
	beq CODE_8F8AE8		; $8F8AD2: F0 14
	lda.b $73		; $8F8AD4: A5 73
	lsr a		; $8F8AD6: 4A
	lsr a		; $8F8AD7: 4A
	sta.b $C9		; $8F8AD8: 85 C9
	lda.w #$00C8		; $8F8ADA: A9 C8 00
	sta.b $CB		; $8F8ADD: 85 CB
	lda.w #$022D		; $8F8ADF: A9 2D 02
	sta.b $C3		; $8F8AE2: 85 C3
	jsl.l $8FEC68		; $8F8AE4: 22 68 EC 8F
CODE_8F8AE8:		; M=16 X=16
	rtl		; $8F8AE8: 6B
	db $A5,$53,$48,$22,$0B,$C4,$80,$A5,$57,$D0,$1B,$22,$29,$C4,$80,$A5	; $8F8AE9
	db $57,$D0,$13,$22,$5E,$E3,$80,$A5,$00,$C5,$00,$F0,$FC,$22,$E8,$F3	; $8F8AF9
	db $80,$68,$3A,$48,$10,$DD,$68,$6B	; $8F8B09
CODE_8F8B11:		; M=16 X=16
	lda.w $128A		; $8F8B11: AD 8A 12
	ora.w $12F2		; $8F8B14: 0D F2 12
	bne CODE_8F8B20		; $8F8B17: D0 07
	jsl.l $80C278		; $8F8B19: 22 78 C2 80
	jmp.w $8B21		; $8F8B1D: 4C 21 8B
CODE_8F8B20:		; M=16 X=16
	rtl		; $8F8B20: 6B
CODE_8F8B21:		; M=16 X=16
	ldx.w #$001C		; $8F8B21: A2 1C 00
	stx.b $3F		; $8F8B24: 86 3F
	lda.w #$0018		; $8F8B26: A9 18 00
	sta.b $53		; $8F8B29: 85 53
	jsl.l $80B49D		; $8F8B2B: 22 9D B4 80
	lda.w $12F0		; $8F8B2F: AD F0 12
	cmp.w #$0002		; $8F8B32: C9 02 00
	bcs CODE_8F8B3A		; $8F8B35: B0 03
	jmp.w $8C05		; $8F8B37: 4C 05 8C
CODE_8F8B3A:		; M=16 X=16
	lda.w #$0007		; $8F8B3A: A9 07 00
	sta.b $53		; $8F8B3D: 85 53
	ldx.w #$0000		; $8F8B3F: A2 00 00
	stx.b $3F		; $8F8B42: 86 3F
	lda.w $014A		; $8F8B44: AD 4A 01
	cmp.w #$0003		; $8F8B47: C9 03 00
	bne CODE_8F8BA4		; $8F8B4A: D0 58
	lda.b $D6		; $8F8B4C: A5 D6
	cmp.w #$0007		; $8F8B4E: C9 07 00
	beq CODE_8F8B86		; $8F8B51: F0 33
	lda.w $014C		; $8F8B53: AD 4C 01
	asl a		; $8F8B56: 0A
	sta.b $33		; $8F8B57: 85 33
	tay		; $8F8B59: A8
	stz.b $5F		; $8F8B5A: 64 5F
	lda.w $15EF,y		; $8F8B5C: B9 EF 15
	bit.w #$0001		; $8F8B5F: 89 01 00
	beq CODE_8F8B69		; $8F8B62: F0 05
	lda.w #$0010		; $8F8B64: A9 10 00
	sta.b $5F		; $8F8B67: 85 5F
CODE_8F8B69:		; M=16 X=16
	lda.w $13D6		; $8F8B69: AD D6 13
	cmp.w $13D8		; $8F8B6C: CD D8 13
	bpl CODE_8F8B78		; $8F8B6F: 10 07
	lda.b $5F		; $8F8B71: A5 5F
	eor.w #$0010		; $8F8B73: 49 10 00
	sta.b $5F		; $8F8B76: 85 5F
CODE_8F8B78:		; M=16 X=16
	lda.b $33		; $8F8B78: A5 33
	clc		; $8F8B7A: 18
	adc.b $5F		; $8F8B7B: 65 5F
	tay		; $8F8B7D: A8
	lda.w $159F,y		; $8F8B7E: B9 9F 15
	cmp.w #$0003		; $8F8B81: C9 03 00
	bne CODE_8F8BA4		; $8F8B84: D0 1E
CODE_8F8B86:		; M=16 X=16
	lda.w #$0008		; $8F8B86: A9 08 00
	sta.b $53		; $8F8B89: 85 53
	lda.w #$000B		; $8F8B8B: A9 0B 00
	sta.b $5B		; $8F8B8E: 85 5B
CODE_8F8B90:		; M=16 X=16
	lda.w $0EDF,x		; $8F8B90: BD DF 0E
	and.w #$FFF7		; $8F8B93: 29 F7 FF
	sta.w $0EDF,x		; $8F8B96: 9D DF 0E
	inx		; $8F8B99: E8
	inx		; $8F8B9A: E8
	dec.b $5B		; $8F8B9B: C6 5B
	bpl CODE_8F8B90		; $8F8B9D: 10 F1
	ldx.w #$0000		; $8F8B9F: A2 00 00
	stx.b $3F		; $8F8BA2: 86 3F
CODE_8F8BA4:		; M=16 X=16
	lda.w #$0005		; $8F8BA4: A9 05 00
	sta.b $5B		; $8F8BA7: 85 5B
	lda.w $13D6		; $8F8BA9: AD D6 13
	cmp.w $13D8		; $8F8BAC: CD D8 13
	beq CODE_8F8C05		; $8F8BAF: F0 54
	bpl CODE_8F8BB8		; $8F8BB1: 10 05
	ldx.w #$000C		; $8F8BB3: A2 0C 00
	stx.b $3F		; $8F8BB6: 86 3F
CODE_8F8BB8:		; M=16 X=16
	lda.w $0B9F,x		; $8F8BB8: BD 9F 0B
	beq CODE_8F8BC6		; $8F8BBB: F0 09
	jsl.l $80B49D		; $8F8BBD: 22 9D B4 80
	lda.w #$0007		; $8F8BC1: A9 07 00
	sta.b $53		; $8F8BC4: 85 53
CODE_8F8BC6:		; M=16 X=16
	inx		; $8F8BC6: E8
	inx		; $8F8BC7: E8
	stx.b $3F		; $8F8BC8: 86 3F
	dec.b $5B		; $8F8BCA: C6 5B
	bpl CODE_8F8BB8		; $8F8BCC: 10 EA
CODE_8F8BCE:		; M=16 X=16
	jsl.l $8FE2F9		; $8F8BCE: 22 F9 E2 8F
	lda.b $DE		; $8F8BD2: A5 DE
	clc		; $8F8BD4: 18
	adc.w #$03E8		; $8F8BD5: 69 E8 03
	sta.b $DE		; $8F8BD8: 85 DE
	lda.w #$0040		; $8F8BDA: A9 40 00
	sta.w $128A		; $8F8BDD: 8D 8A 12
	tsb.w $1288		; $8F8BE0: 0C 88 12
	lda.w $13D6		; $8F8BE3: AD D6 13
	cmp.w $13D8		; $8F8BE6: CD D8 13
	bmi CODE_8F8BFC		; $8F8BE9: 30 11
	stz.b $DE		; $8F8BEB: 64 DE
	lda.w #$0003		; $8F8BED: A9 03 00
	sta.w $0150		; $8F8BF0: 8D 50 01
	lda.b $00		; $8F8BF3: A5 00
	sec		; $8F8BF5: 38
	sbc.w #$0096		; $8F8BF6: E9 96 00
	sta.w $0152		; $8F8BF9: 8D 52 01
CODE_8F8BFC:		; M=16 X=16
	lda.w #$0004		; $8F8BFC: A9 04 00
	sta.b $53		; $8F8BFF: 85 53
	jml.l $80C1B0		; $8F8C01: 5C B0 C1 80
CODE_8F8C05:		; M=16 X=16
	lda.w $12F0		; $8F8C05: AD F0 12
	cmp.w #$0003		; $8F8C08: C9 03 00
	bne CODE_8F8C12		; $8F8C0B: D0 05
	lda.w $1600		; $8F8C0D: AD 00 16
	beq CODE_8F8BCE		; $8F8C10: F0 BC
CODE_8F8C12:		; M=16 X=16
	lda.w #$0002		; $8F8C12: A9 02 00
	sta.b $53		; $8F8C15: 85 53
	jml.l $80C1B0		; $8F8C17: 5C B0 C1 80
	db $AD,$00,$16,$F0,$2A,$22,$A4,$D5,$85,$A5,$57,$0A,$85,$33,$A4,$33	; $8F8C1B
	db $B9,$EF,$15,$89,$04,$00,$D0,$0F,$89,$02,$00,$F0,$0A,$29,$FD,$FF	; $8F8C2B
	db $99,$EF,$15,$22,$97,$FC,$82,$C6,$33,$C6,$33,$C6,$57,$10,$DF,$6B	; $8F8C3B
	db $BD,$7F,$11,$D0,$21,$A9,$10,$00,$85,$53,$BD,$9F,$11,$F0,$05,$A9	; $8F8C4B
	db $01,$00,$85,$53,$AD,$E4,$12,$18,$65,$53,$8D,$E4,$12,$A9,$FF,$FF	; $8F8C5B
	db $9D,$9F,$0B,$9E,$3F,$09,$6B	; $8F8C6B
CODE_8F8C72:		; M=16 X=16
	lda.w #$0020		; $8F8C72: A9 20 00
	trb.w $1290		; $8F8C75: 1C 90 12
	lda.w $128A		; $8F8C78: AD 8A 12
	bne CODE_8F8CFC		; $8F8C7B: D0 7F
	lda.w $12E2		; $8F8C7D: AD E2 12
	sec		; $8F8C80: 38
	sbc.b $6F		; $8F8C81: E5 6F
	sta.w $12E2		; $8F8C83: 8D E2 12
	bpl CODE_8F8CFC		; $8F8C86: 10 74
	adc.w #$0018		; $8F8C88: 69 18 00
	sta.w $12E2		; $8F8C8B: 8D E2 12
	lda.w #$0020		; $8F8C8E: A9 20 00
	tsb.w $1290		; $8F8C91: 0C 90 12
	jsl.l $80E6D6		; $8F8C94: 22 D6 E6 80
	stz.b $3B		; $8F8C98: 64 3B
	jsl.l $8F8CA3		; $8F8C9A: 22 A3 8C 8F
	lda.w #$0002		; $8F8C9E: A9 02 00
	sta.b $3B		; $8F8CA1: 85 3B
CODE_8F8CA3:		; M=16 X=16
	lda.b $3B		; $8F8CA3: A5 3B
	beq CODE_8F8CAA		; $8F8CA5: F0 03
	lda.w #$001A		; $8F8CA7: A9 1A 00
CODE_8F8CAA:		; M=16 X=16
	sta.b $33		; $8F8CAA: 85 33
	lda.w #$0191		; $8F8CAC: A9 91 01
	sta.b $37		; $8F8CAF: 85 37
	lda.w #$0000		; $8F8CB1: A9 00 00
	sta.b $39		; $8F8CB4: 85 39
	lda.w #$0002		; $8F8CB6: A9 02 00
	sta.b $57		; $8F8CB9: 85 57
	sta.b $5F		; $8F8CBB: 85 5F
CODE_8F8CBD:		; M=16 X=16
	ldy.b $33		; $8F8CBD: A4 33
	lda.w $154A,y		; $8F8CBF: B9 4A 15
	inc.b $33		; $8F8CC2: E6 33
	and.w #$00FF		; $8F8CC4: 29 FF 00
	sta.b $53		; $8F8CC7: 85 53
	bit.w #$0080		; $8F8CC9: 89 80 00
	bne CODE_8F8CFD		; $8F8CCC: D0 2F
	lda.b $3B		; $8F8CCE: A5 3B
	beq CODE_8F8CD5		; $8F8CD0: F0 03
	lda.w #$0034		; $8F8CD2: A9 34 00
CODE_8F8CD5:		; M=16 X=16
	clc		; $8F8CD5: 18
	adc.b $53		; $8F8CD6: 65 53
	tay		; $8F8CD8: A8
	lda.w $14E2,y		; $8F8CD9: B9 E2 14
	bit.w #$4000		; $8F8CDC: 89 00 40
	bne CODE_8F8D45		; $8F8CDF: D0 64
	dec.b $57		; $8F8CE1: C6 57
	bmi CODE_8F8CBD		; $8F8CE3: 30 D8
	lda.b $53		; $8F8CE5: A5 53
	sta.b [$37]		; $8F8CE7: 87 37
	inc.b $37		; $8F8CE9: E6 37
	inc.b $37		; $8F8CEB: E6 37
	lda.w $14E2,y		; $8F8CED: B9 E2 14
	dec a		; $8F8CF0: 3A
	sta.w $14E2,y		; $8F8CF1: 99 E2 14
	bne CODE_8F8CFA		; $8F8CF4: D0 04
	jsl.l $8FDAFC		; $8F8CF6: 22 FC DA 8F
CODE_8F8CFA:		; M=16 X=16
	bra CODE_8F8CBD		; $8F8CFA: 80 C1
CODE_8F8CFC:		; M=16 X=16
	rtl		; $8F8CFC: 6B
CODE_8F8CFD:		; M=16 X=16
	lda.w $0191		; $8F8CFD: AD 91 01
	sta.b $53		; $8F8D00: 85 53
	lda.b $57		; $8F8D02: A5 57
	cmp.w #$0001		; $8F8D04: C9 01 00
	beq CODE_8F8D1F		; $8F8D07: F0 16
	lda.b $57		; $8F8D09: A5 57
	bne CODE_8F8D13		; $8F8D0B: D0 06
	jsl.l $8F8D1F		; $8F8D0D: 22 1F 8D 8F
	bra CODE_8F8D1A		; $8F8D11: 80 07
CODE_8F8D13:		; M=16 X=16
	lda.b $57		; $8F8D13: A5 57
	cmp.w #$FFFF		; $8F8D15: C9 FF FF
	bne CODE_8F8CFC		; $8F8D18: D0 E2
CODE_8F8D1A:		; M=16 X=16
	lda.w $0193		; $8F8D1A: AD 93 01
	sta.b $53		; $8F8D1D: 85 53
CODE_8F8D1F:		; M=16 X=16
	lda.b $3B		; $8F8D1F: A5 3B
	beq CODE_8F8D26		; $8F8D21: F0 03
	lda.w #$0034		; $8F8D23: A9 34 00
CODE_8F8D26:		; M=16 X=16
	clc		; $8F8D26: 18
	adc.b $53		; $8F8D27: 65 53
	tay		; $8F8D29: A8
	lda.w $14E2,y		; $8F8D2A: B9 E2 14
	sec		; $8F8D2D: 38
	sbc.w #$0005		; $8F8D2E: E9 05 00
	beq CODE_8F8D3B		; $8F8D31: F0 08
	bmi CODE_8F8D39		; $8F8D33: 30 04
	bvs CODE_8F8D3B		; $8F8D35: 70 04
	bra CODE_8F8CFC		; $8F8D37: 80 C3
CODE_8F8D39:		; M=16 X=16
	bvs CODE_8F8CFC		; $8F8D39: 70 C1
CODE_8F8D3B:		; M=16 X=16
	lda.w $14E2,y		; $8F8D3B: B9 E2 14
	bne CODE_8F8D44		; $8F8D3E: D0 04
	jsl.l $8FD9DF		; $8F8D40: 22 DF D9 8F
CODE_8F8D44:		; M=16 X=16
	rtl		; $8F8D44: 6B
CODE_8F8D45:		; M=16 X=16
	dec a		; $8F8D45: 3A
	sta.w $14E2,y		; $8F8D46: 99 E2 14
	bit.w #$0800		; $8F8D49: 89 00 08
	bne CODE_8F8D51		; $8F8D4C: D0 03
	jmp.w $8CBD		; $8F8D4E: 4C BD 8C
CODE_8F8D51:		; M=16 X=16
	bit.w #$1000		; $8F8D51: 89 00 10
	bne CODE_8F8D5F		; $8F8D54: D0 09
	lda.w #$1000		; $8F8D56: A9 00 10
	sta.w $14E2,y		; $8F8D59: 99 E2 14
	jmp.w $DAFC		; $8F8D5C: 4C FC DA
CODE_8F8D5F:		; M=16 X=16
	lda.w #$0000		; $8F8D5F: A9 00 00
	sta.w $14E2,y		; $8F8D62: 99 E2 14
	jmp.w $DAFC		; $8F8D65: 4C FC DA
CODE_8F8D68:		; M=16 X=16
	jsl.l $888405		; $8F8D68: 22 05 84 88
	lda.w $0477		; $8F8D6C: AD 77 04
	pha		; $8F8D6F: 48
	lda.w #$3000		; $8F8D70: A9 00 30
	sta.w $0477		; $8F8D73: 8D 77 04
	lda.b $53		; $8F8D76: A5 53
	cmp.w #$1000		; $8F8D78: C9 00 10
	bcc CODE_8F8D80		; $8F8D7B: 90 03
	lda.w #$1000		; $8F8D7D: A9 00 10
CODE_8F8D80:		; M=16 X=16
	sta.b $53		; $8F8D80: 85 53
	sta.b $7D		; $8F8D82: 85 7D
	lda.w #$002F		; $8F8D84: A9 2F 00
	sta.b $83		; $8F8D87: 85 83
	jsl.l $888942		; $8F8D89: 22 42 89 88
	lda.b $95		; $8F8D8D: A5 95
	adc.w #$001D		; $8F8D8F: 69 1D 00
	sta.w $0193		; $8F8D92: 8D 93 01
	sta.w $0194		; $8F8D95: 8D 94 01
	sta.w $0195		; $8F8D98: 8D 95 01
	sta.w $0196		; $8F8D9B: 8D 96 01
	sta.w $0197		; $8F8D9E: 8D 97 01
	lda.w #$0191		; $8F8DA1: A9 91 01
	sta.b $37		; $8F8DA4: 85 37
	lda.w #$0000		; $8F8DA6: A9 00 00
	sta.b $39		; $8F8DA9: 85 39
	lda.b $53		; $8F8DAB: A5 53
	sta.b $7D		; $8F8DAD: 85 7D
	lda.w #$0054		; $8F8DAF: A9 54 00
	sta.b $83		; $8F8DB2: 85 83
	jsl.l $888942		; $8F8DB4: 22 42 89 88
	lda.b $95		; $8F8DB8: A5 95
	inc a		; $8F8DBA: 1A
	inc a		; $8F8DBB: 1A
	sta.b [$37]		; $8F8DBC: 87 37
	jsl.l $80B92D		; $8F8DBE: 22 2D B9 80
	pla		; $8F8DC2: 68
	sta.w $0477		; $8F8DC3: 8D 77 04
	rtl		; $8F8DC6: 6B
CODE_8F8DC7:		; M=16 X=16
	ldx.b $3F		; $8F8DC7: A6 3F
	ldy.b $3B		; $8F8DC9: A4 3B
	lda.b $5B		; $8F8DCB: A5 5B
	sta.b $53		; $8F8DCD: 85 53
	sta.w $140E,y		; $8F8DCF: 99 0E 14
	jsl.l $8AFD6D		; $8F8DD2: 22 6D FD 8A
	lda.b $53		; $8F8DD6: A5 53
	bmi CODE_8F8E02		; $8F8DD8: 30 28
	lda.w $0EDF,x		; $8F8DDA: BD DF 0E
	and.w #$DFFF		; $8F8DDD: 29 FF DF
	ora.w #$0008		; $8F8DE0: 09 08 00
	sta.w $0EDF,x		; $8F8DE3: 9D DF 0E
	jsl.l $8FDBF9		; $8F8DE6: 22 F9 DB 8F
	ldy.b $3B		; $8F8DEA: A4 3B
	lda.w $140A,y		; $8F8DEC: B9 0A 14
	and.w #$FFF7		; $8F8DEF: 29 F7 FF
	sta.w $140A,y		; $8F8DF2: 99 0A 14
	lda.b $53		; $8F8DF5: A5 53
	sta.w $13DE,y		; $8F8DF7: 99 DE 13
	jsl.l $80BB5A		; $8F8DFA: 22 5A BB 80
	jml.l $86FCB7		; $8F8DFE: 5C B7 FC 86
CODE_8F8E02:		; M=16 X=16
	rtl		; $8F8E02: 6B
CODE_8F8E03:		; M=16 X=16
	lda.w #$0002		; $8F8E03: A9 02 00
	trb.w $128C		; $8F8E06: 1C 8C 12
	jml.l $80F3E1		; $8F8E09: 5C E1 F3 80
	db $9C,$A9,$04,$9C,$46,$16,$22,$04,$E4,$8F,$DA,$A2,$FE	; $8F8E0D
CODE_8F8E1A:		; M=16 X=16
	ora.b [$BF]		; $8F8E1A: 07 BF
	db $00,$F8,$7F,$9F,$74,$6E,$7E,$CA,$CA,$10,$F4,$FA,$64,$D0,$A9,$FF	; $8F8E1C
	db $03,$85,$D2,$68,$8D,$8C,$12,$68,$8D,$8E,$12,$D0,$04,$22,$28,$A8	; $8F8E2C
	db $80,$A9,$01,$00,$1C,$8C,$12,$22,$5D,$E9,$89,$22,$5E,$E3,$80,$A5	; $8F8E3C
	db $00,$8D,$DB,$08,$8D,$27,$04,$6B,$A5,$43,$C9,$74,$81,$D0,$19,$A5	; $8F8E4C
	db $45,$C9,$7E,$00,$D0,$12,$AD,$8C,$12,$89,$10,$00,$F0,$3E,$A9,$41	; $8F8E5C
	db $FF,$85,$43,$A9,$7E,$00,$85,$45,$A5,$43,$38,$E9,$71,$00,$85,$43	; $8F8E6C
	db $A5,$45,$E9,$00,$00,$85,$45,$A5,$43,$CD,$95,$04,$F0,$04,$5C,$E9	; $8F8E7C
	db $F3,$87,$A5,$45,$CD,$97,$04,$F0,$04,$5C,$E9,$F3,$87,$A5,$43,$18	; $8F8E8C
	db $69,$71,$00,$85,$43,$A5,$45,$69,$00,$00,$85,$45,$22,$E9,$F3,$87	; $8F8E9C
	db $64,$6F,$6B,$64,$6F,$AD,$8C,$12,$89,$00,$04,$F0,$27,$A5,$45,$48	; $8F8EAC
	db $A5,$43,$48,$22,$6E,$F3,$80,$A5,$43,$85,$73,$A5,$45,$85,$75,$68	; $8F8EBC
	db $85,$43,$68,$85,$45,$A5,$73,$CD,$95,$04,$D0,$08,$A5,$75,$CD,$97	; $8F8ECC
	db $04,$D0,$01,$6B,$A5,$43,$CD,$95,$04,$D0,$08,$A5,$45,$CD,$97,$04	; $8F8EDC
	db $D0,$01,$6B,$22,$E9,$F3,$87,$5C,$6E,$F3,$80	; $8F8EEC
CODE_8F8EF7:		; M=16 X=16
	lda.b $D0		; $8F8EF7: A5 D0
	bmi CODE_8F8F27		; $8F8EF9: 30 2C
	ldy.b $A3		; $8F8EFB: A4 A3
	sta.w $1658,y		; $8F8EFD: 99 58 16
	asl a		; $8F8F00: 0A
	adc.w #$6E74		; $8F8F01: 69 74 6E
	sta.w $1653,y		; $8F8F04: 99 53 16
	lda.w #$007E		; $8F8F07: A9 7E 00
	sta.w $1655,y		; $8F8F0A: 99 55 16
	lda.b $D2		; $8F8F0D: A5 D2
	beq CODE_8F8F27		; $8F8F0F: F0 16
	sec		; $8F8F11: 38
	sbc.b $D0		; $8F8F12: E5 D0
	inc a		; $8F8F14: 1A
	asl a		; $8F8F15: 0A
	sta.w $1656,y		; $8F8F16: 99 56 16
	lda.w #$FFFF		; $8F8F19: A9 FF FF
	sta.b $D0		; $8F8F1C: 85 D0
	stz.b $D2		; $8F8F1E: 64 D2
	tya		; $8F8F20: 98
	clc		; $8F8F21: 18
	adc.w #$0007		; $8F8F22: 69 07 00
	sta.b $A3		; $8F8F25: 85 A3
CODE_8F8F27:		; M=16 X=16
	rtl		; $8F8F27: 6B
CODE_8F8F28:		; M=16 X=16
	ldy.b $A3		; $8F8F28: A4 A3
	lda.w #$7674		; $8F8F2A: A9 74 76
	sta.w $1653,y		; $8F8F2D: 99 53 16
	lda.w #$007E		; $8F8F30: A9 7E 00
	sta.w $1655,y		; $8F8F33: 99 55 16
	lda.w #$0800		; $8F8F36: A9 00 08
	sta.w $1656,y		; $8F8F39: 99 56 16
	lda.w #$0400		; $8F8F3C: A9 00 04
	sta.w $1658,y		; $8F8F3F: 99 58 16
	tya		; $8F8F42: 98
	clc		; $8F8F43: 18
	adc.w #$0007		; $8F8F44: 69 07 00
	sta.b $A3		; $8F8F47: 85 A3
	rtl		; $8F8F49: 6B
CODE_8F8F4A:		; M=16 X=16
	ldy.b $A3		; $8F8F4A: A4 A3
	lda.w $08E1		; $8F8F4C: AD E1 08
	clc		; $8F8F4F: 18
	adc.w #$0170		; $8F8F50: 69 70 01
	lsr a		; $8F8F53: 4A
	lsr a		; $8F8F54: 4A
	lsr a		; $8F8F55: 4A
	tax		; $8F8F56: AA
	sec		; $8F8F57: 38
	sbc.w $049B		; $8F8F58: ED 9B 04
	bne CODE_8F8F60		; $8F8F5B: D0 03
	jmp.w $9017		; $8F8F5D: 4C 17 90
CODE_8F8F60:		; M=16 X=16
	bpl CODE_8F8F8C		; $8F8F60: 10 2A
	stx.w $049B		; $8F8F62: 8E 9B 04
	eor.w #$FFFF		; $8F8F65: 49 FF FF
	inc a		; $8F8F68: 1A
	cmp.w #$0019		; $8F8F69: C9 19 00
	bcs CODE_8F8F80		; $8F8F6C: B0 12
	sta.b $75		; $8F8F6E: 85 75
	lda.w $049D		; $8F8F70: AD 9D 04
	sec		; $8F8F73: 38
	sbc.b $75		; $8F8F74: E5 75
	and.w #$001F		; $8F8F76: 29 1F 00
	sta.w $049D		; $8F8F79: 8D 9D 04
	sta.b $77		; $8F8F7C: 85 77
	bra CODE_8F8FB3		; $8F8F7E: 80 33
CODE_8F8F80:		; M=16 X=16
	lda.w #$001D		; $8F8F80: A9 1D 00
	sta.b $75		; $8F8F83: 85 75
	stz.w $049D		; $8F8F85: 9C 9D 04
	stz.b $77		; $8F8F88: 64 77
	bra CODE_8F8FB3		; $8F8F8A: 80 27
CODE_8F8F8C:		; M=16 X=16
	stx.w $049B		; $8F8F8C: 8E 9B 04
	cmp.w #$0019		; $8F8F8F: C9 19 00
	bcs CODE_8F8F80		; $8F8F92: B0 EC
	sta.b $75		; $8F8F94: 85 75
	adc.w $049D		; $8F8F96: 6D 9D 04
	and.w #$001F		; $8F8F99: 29 1F 00
	sta.w $049D		; $8F8F9C: 8D 9D 04
	adc.w #$001D		; $8F8F9F: 69 1D 00
	sec		; $8F8FA2: 38
	sbc.b $75		; $8F8FA3: E5 75
	and.w #$001F		; $8F8FA5: 29 1F 00
	sta.b $77		; $8F8FA8: 85 77
	txa		; $8F8FAA: 8A
	clc		; $8F8FAB: 18
	adc.w #$001D		; $8F8FAC: 69 1D 00
	sec		; $8F8FAF: 38
	sbc.b $75		; $8F8FB0: E5 75
	tax		; $8F8FB2: AA
CODE_8F8FB3:		; M=16 X=16
	txa		; $8F8FB3: 8A
	asl a		; $8F8FB4: 0A
	asl a		; $8F8FB5: 0A
	asl a		; $8F8FB6: 0A
	asl a		; $8F8FB7: 0A
	asl a		; $8F8FB8: 0A
	sta.b $73		; $8F8FB9: 85 73
	asl a		; $8F8FBB: 0A
	adc.b $73		; $8F8FBC: 65 73
	adc.w #$CCCB		; $8F8FBE: 69 CB CC
	sta.b $73		; $8F8FC1: 85 73
	lda.b $77		; $8F8FC3: A5 77
	asl a		; $8F8FC5: 0A
	asl a		; $8F8FC6: 0A
	asl a		; $8F8FC7: 0A
	asl a		; $8F8FC8: 0A
	asl a		; $8F8FC9: 0A
	adc.w #$0400		; $8F8FCA: 69 00 04
	sta.b $77		; $8F8FCD: 85 77
	ldx.b $75		; $8F8FCF: A6 75
CODE_8F8FD1:		; M=16 X=16
	lda.w #$0083		; $8F8FD1: A9 83 00
	sta.w $1655,y		; $8F8FD4: 99 55 16
	sta.w $165C,y		; $8F8FD7: 99 5C 16
	lda.b $77		; $8F8FDA: A5 77
	sta.w $1658,y		; $8F8FDC: 99 58 16
	clc		; $8F8FDF: 18
	adc.w #$0400		; $8F8FE0: 69 00 04
	sta.w $165F,y		; $8F8FE3: 99 5F 16
	sec		; $8F8FE6: 38
	sbc.w #$03E0		; $8F8FE7: E9 E0 03
	cmp.w #$0800		; $8F8FEA: C9 00 08
	bne CODE_8F8FF2		; $8F8FED: D0 03
	lda.w #$0400		; $8F8FEF: A9 00 04
CODE_8F8FF2:		; M=16 X=16
	sta.b $77		; $8F8FF2: 85 77
	lda.b $73		; $8F8FF4: A5 73
	sta.w $1653,y		; $8F8FF6: 99 53 16
	clc		; $8F8FF9: 18
	adc.w #$0040		; $8F8FFA: 69 40 00
	sta.w $165A,y		; $8F8FFD: 99 5A 16
