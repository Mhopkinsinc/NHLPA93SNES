; Bank $8F  ROM $78000-$7FFFF  (auto-generated quick pass; TODO: segment agents refine)
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
	adc.w #$0020		; $8F9000: 69 20 00
	sta.b $73		; $8F9003: 85 73
	lda.w #$0040		; $8F9005: A9 40 00
	sta.w $1656,y		; $8F9008: 99 56 16
	lsr a		; $8F900B: 4A
	sta.w $165D,y		; $8F900C: 99 5D 16
	tya		; $8F900F: 98
	adc.w #$000E		; $8F9010: 69 0E 00
	tay		; $8F9013: A8
	dex		; $8F9014: CA
	bne CODE_8F8FD1		; $8F9015: D0 BA
CODE_8F9017:		; M=16 X=16
	sty.b $A3		; $8F9017: 84 A3
	rtl		; $8F9019: 6B
	db $08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; $8F901A
CODE_8F902A:		; M=16 X=16
	lda.w $1600		; $8F902A: AD 00 16
	beq CODE_8F9072		; $8F902D: F0 43
	lda.w $014A		; $8F902F: AD 4A 01
	cmp.w #$0002		; $8F9032: C9 02 00
	bcs CODE_8F9072		; $8F9035: B0 3B
	jsl.l $85D5A4		; $8F9037: 22 A4 D5 85
	lda.b $57		; $8F903B: A5 57
	asl a		; $8F903D: 0A
	sta.b $33		; $8F903E: 85 33
CODE_8F9040:		; M=16 X=16
	lda.b $57		; $8F9040: A5 57
	cmp.w $014C		; $8F9042: CD 4C 01
	beq CODE_8F906A		; $8F9045: F0 23
	ldy.b $33		; $8F9047: A4 33
	lda.w $15EF,y		; $8F9049: B9 EF 15
	bit.w #$0004		; $8F904C: 89 04 00
	bne CODE_8F906A		; $8F904F: D0 19
	lda.w #$0000		; $8F9051: A9 00 00
	sta.w $15BF,y		; $8F9054: 99 BF 15
	lda.w #$0003		; $8F9057: A9 03 00
	sta.b $53		; $8F905A: 85 53
	jsl.l $8097A3		; $8F905C: 22 A3 97 80
	bra CODE_8F9066		; $8F9060: 80 04
CODE_8F9062:		; M=16 X=16
	jsl.l $8AFE21		; $8F9062: 22 21 FE 8A
CODE_8F9066:		; M=16 X=16
	dec.b $53		; $8F9066: C6 53
	bpl CODE_8F9062		; $8F9068: 10 F8
CODE_8F906A:		; M=16 X=16
	dec.b $33		; $8F906A: C6 33
	dec.b $33		; $8F906C: C6 33
	dec.b $57		; $8F906E: C6 57
	bpl CODE_8F9040		; $8F9070: 10 CE
CODE_8F9072:		; M=16 X=16
	rtl		; $8F9072: 6B
CODE_8F9073:		; M=16 X=16
	sep #$30		; $8F9073: E2 30
	stz.w $1610		; $8F9075: 9C 10 16
	ldy.b #$0F		; $8F9078: A0 0F
	lda.b #$1E		; $8F907A: A9 1E
CODE_8F907C:		; M=8 X=8
	sta.w $1610,y		; $8F907C: 99 10 16
	dey		; $8F907F: 88
	bne CODE_8F907C		; $8F9080: D0 FA
	rep #$30		; $8F9082: C2 30
	rtl		; $8F9084: 6B
	db $30,$00,$02,$01,$00,$02,$6C,$00,$74,$04,$00,$00,$06,$00,$0C,$00	; $8F9085
	db $14,$00,$18,$00,$1D,$00,$23,$00,$27,$00,$2B,$00,$2D,$00,$30,$00	; $8F9095
	db $38,$00,$3C,$00,$40,$00,$45,$00,$48,$00,$4C,$00,$54,$00,$59,$00	; $8F90A5
	db $5E,$00,$61,$00,$64,$00,$6A,$00,$70,$00,$78,$00,$7D,$00,$83,$00	; $8F90B5
	db $88,$00,$8C,$00,$91,$00,$9D,$00,$A2,$00,$A6,$00,$AC,$00,$B0,$00	; $8F90C5
	db $BA,$00,$C5,$00,$C9,$00,$CE,$00,$D1,$00,$D7,$00,$E0,$00,$E8,$00	; $8F90D5
	db $EE,$00,$F3,$00,$F8,$00,$FC,$00,$FF,$00,$02,$01,$F9,$F4,$2C,$29	; $8F90E5
	db $F4,$EC,$EE,$09,$FC,$EC,$ED,$09,$FC,$E4,$EC,$09,$EC,$DC,$EB,$09	; $8F90F5
	db $EC,$E4,$EA,$09,$F8,$EB,$2A,$29,$F8,$FB,$E9,$09,$00,$FB,$E8,$09	; $8F9105
	db $F9,$E3,$E7,$09,$E8,$EE,$E6,$09,$F0,$EE,$E5,$09,$F7,$ED,$28,$29	; $8F9115
	db $F7,$FD,$E4,$09,$FF,$FD,$E3,$09,$F7,$E5,$E2,$09,$FF,$E5,$E1,$09	; $8F9125
	db $EF,$EE,$E0,$09,$EF,$F6,$DF,$09,$E7,$EE,$DE,$09,$F7,$EC,$26,$29	; $8F9135
	db $F7,$FC,$DD,$09,$FF,$FC,$DC,$09,$FD,$E4,$DB,$09,$F9,$E5,$24,$29	; $8F9145
	db $F9,$F5,$22,$29,$F1,$FD,$DA,$09,$09,$E5,$D9,$09,$09,$ED,$D8,$09	; $8F9155
	db $FA,$E5,$20,$29,$FA,$F5,$0E,$29,$0A,$ED,$D7,$09,$12,$ED,$D6,$09	; $8F9165
	db $0A,$F5,$D5,$09,$F2,$FD,$D4,$09,$F7,$E6,$0C,$29,$F7,$F6,$0A,$29	; $8F9175
	db $F4,$D6,$D3,$09,$F4,$DE,$D2,$09,$F9,$E5,$08,$29,$F9,$F5,$06,$29	; $8F9185
	db $F1,$E9,$D1,$09,$EA,$E3,$D0,$09,$F9,$E7,$04,$29,$F9,$F7,$02,$29	; $8F9195
	db $FB,$E6,$00,$29,$FB,$F6,$EE,$28,$0B,$F0,$CF,$09,$F7,$EE,$EC,$28	; $8F91A5
	db $07,$EE,$CE,$09,$07,$F6,$CD,$09,$F7,$FE,$CC,$09,$FF,$FE,$CB,$09	; $8F91B5
	db $07,$FE,$CA,$09,$FF,$E6,$C9,$09,$0F,$F5,$C8,$09,$FD,$E7,$EA,$28	; $8F91C5
	db $F9,$F7,$E8,$28,$09,$F7,$E6,$28,$19,$F4,$C7,$09,$FA,$E9,$E4,$28	; $8F91D5
	db $FA,$F9,$E2,$28,$FA,$D9,$C6,$09,$FA,$E1,$C5,$09,$FA,$E4,$E0,$28	; $8F91E5
	db $FA,$F4,$C4,$09,$02,$F4,$C3,$09,$FD,$FC,$C2,$09,$FD,$04,$C1,$09	; $8F91F5
	db $FA,$EB,$CE,$28,$FA,$FB,$CC,$28,$0A,$EE,$C0,$09,$FC,$ED,$CA,$28	; $8F9205
	db $FA,$FD,$C8,$28,$0A,$FD,$BF,$09,$12,$FD,$BE,$09,$F9,$F1,$C6,$28	; $8F9215
	db $F9,$01,$BD,$09,$01,$01,$BC,$09,$F1,$F9,$BB,$09,$09,$F9,$BA,$09	; $8F9225
	db $09,$01,$B9,$09,$11,$00,$B8,$09,$01,$E9,$B7,$09,$FA,$EA,$C4,$28	; $8F9235
	db $FA,$FA,$C2,$28,$F2,$FA,$B6,$09,$0A,$02,$B5,$09,$06,$0A,$B4,$09	; $8F9245
	db $F9,$E2,$C0,$28,$F9,$F2,$AE,$28,$F9,$02,$B3,$09,$01,$D2,$B2,$09	; $8F9255
	db $01,$DA,$B1,$09,$F9,$E7,$AC,$28,$F9,$F7,$AA,$28,$09,$E5,$B0,$09	; $8F9265
	db $F9,$E8,$A8,$28,$F9,$F8,$A6,$28,$09,$F2,$A4,$28,$F9,$ED,$A2,$28	; $8F9275
	db $FA,$FD,$AF,$09,$02,$FD,$AE,$09,$FA,$05,$AD,$09,$02,$03,$AC,$09	; $8F9285
	db $0A,$03,$AB,$09,$F6,$EC,$A0,$28,$F6,$FC,$AA,$09,$FE,$FC,$A9,$09	; $8F9295
	db $F4,$04,$A8,$09,$FC,$04,$A7,$09,$F4,$0C,$A6,$09,$F5,$EB,$8E,$28	; $8F92A5
	db $F8,$FB,$A5,$09,$00,$FB,$A4,$09,$E8,$03,$A3,$09,$F0,$03,$A2,$09	; $8F92B5
	db $F8,$03,$A1,$09,$E5,$F7,$A0,$09,$ED,$F7,$9F,$09,$FB,$E3,$8C,$28	; $8F92C5
	db $FB,$F3,$8A,$28,$F3,$FB,$9E,$09,$0A,$D9,$9D,$09,$0A,$E1,$9C,$09	; $8F92D5
	db $F9,$E5,$88,$28,$F9,$F5,$86,$28,$09,$FD,$9B,$09,$09,$E2,$9A,$09	; $8F92E5
	db $09,$EA,$99,$09,$09,$DA,$98,$09,$F7,$E5,$84,$28,$F7,$F5,$82,$28	; $8F92F5
	db $07,$EF,$97,$09,$0F,$EF,$96,$09,$07,$FC,$95,$09,$F7,$EA,$80,$28	; $8F9305
	db $F7,$FA,$6E,$28,$07,$FA,$94,$09,$02,$0A,$93,$09,$F7,$E8,$6C,$28	; $8F9315
	db $F7,$F8,$6A,$28,$07,$F8,$92,$09,$EF,$00,$91,$09,$F7,$08,$90,$09	; $8F9325
	db $F7,$E8,$8F,$09,$FF,$E8,$8E,$09,$F8,$F0,$68,$28,$F8,$00,$8D,$09	; $8F9335
	db $00,$00,$8C,$09,$08,$F8,$8B,$09,$F0,$F0,$8A,$09,$E4,$F8,$89,$09	; $8F9345
	db $EC,$F8,$88,$09,$E4,$F0,$87,$09,$E8,$01,$86,$09,$F0,$01,$85,$09	; $8F9355
	db $F9,$E7,$66,$28,$F9,$F7,$64,$28,$09,$D9,$84,$09,$09,$E1,$83,$09	; $8F9365
	db $09,$E9,$82,$09,$F9,$E5,$62,$28,$F9,$F5,$60,$28,$09,$EE,$81,$09	; $8F9375
	db $0F,$EA,$80,$09,$FA,$ED,$4E,$28,$FA,$FD,$7F,$09,$02,$FD,$7E,$09	; $8F9385
	db $F5,$E5,$7D,$09,$FD,$E5,$7C,$09,$FF,$05,$7B,$09,$F6,$EA,$4C,$28	; $8F9395
	db $F6,$FA,$4A,$28,$F2,$08,$7A,$09,$06,$FE,$79,$09,$F6,$ED,$48,$28	; $8F93A5
	db $F6,$FD,$78,$09,$FE,$FD,$77,$09,$06,$F7,$76,$09,$06,$FF,$75,$09	; $8F93B5
	db $EE,$F6,$74,$09,$EE,$FE,$73,$09,$E6,$F6,$72,$09,$F5,$E5,$71,$09	; $8F93C5
	db $FD,$E5,$70,$09,$F3,$E5,$46,$28,$F3,$F5,$44,$28,$03,$F4,$6F,$09	; $8F93D5
	db $03,$FC,$6E,$09,$03,$04,$6D,$09,$0B,$01,$6C,$09,$E3,$F9,$6B,$09	; $8F93E5
	db $EB,$F9,$6A,$09,$E3,$EC,$69,$09,$EB,$EC,$68,$09,$E3,$E4,$67,$09	; $8F93F5
	db $F7,$EA,$42,$28,$F7,$FA,$66,$09,$FF,$FA,$65,$09,$FF,$02,$64,$09	; $8F9405
	db $F9,$F0,$40,$28,$F9,$00,$63,$09,$01,$00,$62,$09,$F9,$E8,$61,$09	; $8F9415
	db $FF,$08,$60,$09,$F5,$E9,$2E,$28,$F5,$F9,$2C,$28,$ED,$F9,$5F,$09	; $8F9425
	db $F7,$EA,$2A,$28,$F7,$FA,$28,$28,$EF,$FA,$5E,$09,$EF,$02,$5D,$09	; $8F9435
	db $E7,$02,$5C,$09,$FF,$0A,$5B,$09,$F3,$ED,$26,$28,$F3,$FD,$5A,$09	; $8F9445
	db $FB,$FD,$59,$09,$FB,$05,$58,$09,$03,$05,$57,$09,$03,$FD,$56,$09	; $8F9455
	db $EB,$F5,$55,$09,$EB,$FD,$54,$09,$E3,$F5,$53,$09,$F4,$EB,$24,$28	; $8F9465
	db $F4,$FB,$52,$09,$FC,$FB,$51,$09,$EC,$E3,$50,$09,$EC,$EB,$4F,$09	; $8F9475
	db $EC,$F3,$4E,$09,$F9,$03,$4D,$09,$01,$03,$4C,$09,$F8,$F9,$22,$28	; $8F9485
	db $EA,$F1,$4B,$09,$F2,$F1,$4A,$09,$FA,$F1,$49,$09,$EA,$E9,$48,$49	; $8F9495
	db $F7,$E9,$47,$09,$F8,$EF,$20,$28,$F8,$FF,$46,$09,$00,$FF,$45,$09	; $8F94A5
	db $F0,$F9,$44,$09,$F7,$E7,$43,$09,$F6,$E8,$0E,$28,$F6,$F8,$0C,$28	; $8F94B5
	db $EE,$F6,$42,$09,$EE,$FE,$41,$09,$E6,$F6,$40,$49,$F5,$E7,$0A,$28	; $8F94C5
	db $F5,$F7,$08,$28,$E5,$F7,$3F,$09,$ED,$F7,$3E,$09,$F6,$E3,$06,$28	; $8F94D5
	db $F6,$F3,$04,$28,$FC,$03,$2F,$09,$F9,$E4,$02,$28,$F9,$F4,$00,$28	; $8F94E5
	db $FB,$04,$2E,$09,$18,$18,$0C,$0C,$07,$00,$01,$02,$09,$02,$12,$04	; $8F94F5
	db $12,$04,$13,$04,$07,$1F,$03,$0F,$00,$0F,$09,$06,$09,$06,$13,$0C	; $8F9505
	db $13,$0C,$13,$0C,$20,$00,$D0,$90,$50,$10,$80,$00,$00,$00,$60,$60	; $8F9515
	db $C0,$C0,$20,$E0,$C0,$F0,$00,$E0,$60,$80,$E0,$00,$C0,$00,$A0,$60	; $8F9525
	db $00,$C0,$20,$20,$00,$00,$00,$00,$0C,$08,$06,$06,$02,$02,$06,$06	; $8F9535
	db $2E,$0C,$1E,$12,$00,$00,$00,$00,$14,$1C,$38,$3E,$3C,$3E,$38,$3E	; $8F9545
	db $32,$3E,$0E,$1C,$00,$04,$00,$0C,$00,$0C,$00,$18,$00,$10,$00,$30	; $8F9555
	db $02,$22,$02,$42,$04,$04,$0C,$0C,$0C,$0C,$18,$18,$10,$10,$30,$30	; $8F9565
	db $22,$22,$42,$42,$36,$0A,$1F,$03,$03,$05,$03,$01,$01,$00,$00,$00	; $8F9575
	db $04,$01,$04,$01,$25,$3F,$1C,$1F,$02,$03,$00,$03,$01,$00,$02,$01	; $8F9585
	db $04,$03,$04,$03,$00,$00,$38,$30,$8C,$84,$6C,$04,$14,$44,$68,$88	; $8F9595
	db $C0,$10,$B0,$30,$F8,$FC,$C0,$FC,$48,$F0,$38,$C0,$38,$C0,$70,$80	; $8F95A5
	db $E0,$10,$C0,$30,$00,$00,$00,$00,$00,$20,$00,$20,$03,$22,$01,$21	; $8F95B5
	db $00,$20,$01,$21,$00,$00,$00,$00,$20,$20,$20,$20,$25,$27,$2E,$2F	; $8F95C5
	db $2F,$2F,$2E,$2F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80	; $8F95D5
	db $80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80	; $8F95E5
	db $00,$80,$00,$80,$3F,$7C,$33,$40,$00,$81,$04,$01,$04,$01,$00,$02	; $8F95F5
	db $00,$01,$E1,$E1,$02,$3D,$73,$70,$80,$83,$04,$03,$04,$03,$01,$06	; $8F9605
	db $04,$07,$E2,$E3,$74,$04,$F4,$04,$2C,$0C,$7C,$1C,$7C,$1C,$CC,$1C	; $8F9615
	db $C2,$5E,$BF,$B7,$08,$F0,$F8,$00,$F0,$00,$E0,$00,$E0,$00,$E0,$0C	; $8F9625
	db $A2,$42,$37,$F7,$01,$01,$00,$00,$00,$00,$00,$00,$05,$01,$03,$02	; $8F9635
	db $00,$03,$00,$07,$02,$03,$07,$07,$07,$07,$07,$07,$06,$07,$01,$03	; $8F9645
	db $00,$03,$00,$07,$80,$00,$C0,$C0,$40,$40,$C0,$C0,$C0,$80,$C8,$70	; $8F9655
	db $1C,$EC,$3C,$DC,$80,$80,$00,$C0,$80,$C0,$00,$C0,$40,$C0,$C0,$B8	; $8F9665
	db $00,$FC,$00,$FE,$C7,$E0,$00,$02,$08,$02,$01,$04,$01,$04,$01,$04	; $8F9675
	db $00,$02,$03,$02,$24,$E3,$01,$06,$09,$06,$03,$0C,$03,$0C,$03,$0C	; $8F9685
	db $09,$06,$04,$03,$38,$18,$C4,$04,$BC,$3C,$9C,$3C,$8C,$3C,$02,$3E	; $8F9695
	db $83,$9F,$1E,$16,$00,$E0,$F8,$00,$C0,$00,$C0,$00,$80,$0C,$82,$02	; $8F96A5
	db $03,$83,$16,$96,$0C,$08,$06,$06,$02,$02,$06,$06,$2E,$0D,$1E,$13	; $8F96B5
	db $00,$1F,$00,$3F,$14,$1C,$38,$3E,$3C,$3E,$38,$3E,$32,$3F,$0E,$1D	; $8F96C5
	db $00,$1F,$00,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$80	; $8F96D5
	db $C0,$40,$A0,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0	; $8F96E5
	db $00,$C0,$40,$E0,$13,$05,$03,$03,$09,$08,$02,$01,$0C,$0E,$00,$01	; $8F96F5
	db $04,$07,$08,$0F,$12,$0D,$0C,$0F,$06,$0F,$00,$07,$0D,$0F,$02,$02	; $8F9705
	db $04,$04,$08,$08,$D0,$50,$E8,$E8,$7C,$7C,$70,$F0,$E0,$E0,$60,$E0	; $8F9715
	db $50,$D0,$40,$C0,$50,$50,$E8,$E8,$7C,$FC,$70,$F0,$60,$E0,$60,$60	; $8F9725
	db $50,$50,$40,$40,$00,$7F,$C0,$3F,$BF,$80,$BD,$BD,$C0,$40,$70,$10	; $8F9735
	db $38,$18,$18,$18,$00,$7F,$80,$FF,$40,$FF,$42,$FF,$BF,$FF,$6F,$7F	; $8F9745
	db $27,$3F,$07,$1F,$24,$E4,$58,$98,$90,$08,$EC,$54,$D4,$A4,$78,$18	; $8F9755
	db $70,$10,$30,$00,$44,$E4,$28,$F8,$60,$FC,$80,$FC,$48,$FC,$E0,$F8	; $8F9765
	db $F0,$F0,$F0,$F0,$04,$01,$04,$01,$00,$00,$00,$00,$01,$00,$00,$01	; $8F9775
	db $03,$03,$05,$05,$04,$03,$04,$03,$06,$05,$03,$03,$02,$03,$00,$01	; $8F9785
	db $03,$03,$05,$05,$A0,$30,$88,$38,$FC,$DC,$B8,$B8,$B4,$74,$68,$E8	; $8F9795
	db $C8,$F8,$84,$FC,$C0,$20,$C8,$08,$1C,$DC,$38,$F8,$14,$F4,$08,$E8	; $8F97A5
	db $08,$C8,$84,$84,$0B,$23,$47,$54,$00,$1F,$40,$4F,$0F,$00,$20,$20	; $8F97B5
	db $2C,$0C,$06,$36,$2C,$2F,$53,$57,$00,$1F,$40,$5F,$10,$1F,$1F,$3F	; $8F97C5
	db $03,$3F,$01,$3F,$80,$60,$80,$F0,$38,$C8,$F8,$34,$60,$68,$B4,$B4	; $8F97D5
	db $3C,$34,$1C,$10,$80,$E0,$80,$78,$00,$F8,$00,$FC,$80,$FC,$40,$FC	; $8F97E5
	db $C8,$FC,$EC,$FC,$09,$08,$04,$05,$02,$02,$00,$03,$00,$03,$03,$00	; $8F97F5
	db $07,$07,$00,$00,$08,$0B,$04,$05,$02,$02,$00,$00,$00,$00,$00,$00	; $8F9805
	db $07,$07,$00,$00,$AE,$6E,$78,$F8,$0E,$EE,$16,$F6,$08,$E8,$18,$F8	; $8F9815
	db $F4,$34,$78,$78,$2E,$EE,$18,$F8,$0E,$0E,$16,$16,$08,$08,$18,$18	; $8F9825
	db $34,$34,$78,$78,$00,$07,$07,$00,$0E,$0E,$0D,$01,$11,$0C,$2B,$21	; $8F9835
	db $23,$21,$3D,$7D,$00,$07,$00,$0F,$01,$0F,$02,$0F,$01,$1F,$12,$3F	; $8F9845
	db $1E,$3F,$00,$3F,$EC,$2A,$08,$04,$0E,$0A,$0E,$0A,$86,$80,$0C,$0C	; $8F9855
	db $18,$18,$EC,$E0,$10,$FE,$F8,$FE,$F4,$FE,$F4,$FE,$7E,$FE,$F0,$FC	; $8F9865
	db $E0,$FC,$00,$FC,$00,$01,$03,$03,$04,$07,$C0,$C7,$06,$01,$01,$00	; $8F9875
	db $00,$00,$00,$00,$00,$03,$02,$03,$04,$04,$C0,$C0,$00,$00,$00,$00	; $8F9885
	db $00,$00,$00,$00,$2E,$AE,$18,$D8,$34,$F4,$38,$F8,$30,$F0,$F0,$30	; $8F9895
	db $C0,$C0,$20,$20,$2E,$AE,$18,$18,$34,$34,$38,$38,$30,$30,$30,$30	; $8F98A5
	db $C0,$C0,$20,$20,$01,$3E,$06,$18,$38,$20,$5C,$1C,$2E,$4E,$46,$22	; $8F98B5
	db $83,$97,$61,$7F,$00,$3F,$41,$7F,$47,$7F,$23,$7F,$11,$7F,$85,$F7	; $8F98C5
	db $44,$F7,$9C,$FD,$00,$00,$10,$10,$00,$00,$08,$08,$08,$08,$18,$18	; $8F98D5
	db $70,$70,$E8,$E0,$E0,$E0,$E0,$F0,$F0,$F0,$F0,$F8,$F0,$F8,$E0,$F8	; $8F98E5
	db $80,$F8,$00,$F8,$05,$79,$04,$78,$0A,$32,$36,$02,$0E,$06,$17,$03	; $8F98F5
	db $27,$19,$15,$20,$02,$7F,$03,$7F,$05,$7F,$4D,$7F,$79,$7F,$24,$3F	; $8F9905
	db $06,$3F,$04,$3F,$00,$00,$80,$80,$C0,$C0,$40,$40,$60,$60,$A0,$80	; $8F9915
	db $40,$00,$80,$00,$00,$00,$00,$80,$00,$C0,$80,$E0,$80,$E0,$00,$E0	; $8F9925
	db $00,$E0,$20,$C0,$19,$F4,$06,$68,$09,$31,$08,$10,$48,$10,$40,$10	; $8F9935
	db $28,$00,$14,$0C,$E1,$FE,$07,$18,$0E,$10,$0C,$30,$48,$30,$48,$30	; $8F9945
	db $68,$58,$30,$3C,$80,$00,$D0,$F0,$30,$78,$10,$DC,$03,$FF,$FE,$FE	; $8F9955
	db $39,$39,$74,$74,$C0,$20,$00,$30,$00,$F0,$20,$30,$03,$03,$FE,$FE	; $8F9965
	db $39,$39,$74,$74,$00,$00,$00,$00,$00,$00,$00,$80,$01,$42,$11,$23	; $8F9975
	db $39,$01,$2C,$03,$00,$00,$01,$01,$03,$03,$83,$83,$43,$41,$33,$30	; $8F9985
	db $39,$38,$3C,$3F,$00,$00,$C0,$C0,$60,$00,$60,$40,$E0,$C0,$C0,$30	; $8F9995
	db $12,$E0,$28,$C2,$00,$00,$00,$C0,$E0,$E0,$A0,$E0,$20,$E0,$C0,$F8	; $8F99A5
	db $0C,$FE,$18,$FE,$06,$04,$03,$02,$03,$02,$0F,$16,$0F,$19,$0E,$0F	; $8F99B5
	db $00,$03,$00,$07,$0A,$0E,$1D,$1F,$1D,$1F,$19,$0F,$1F,$06,$0E,$01	; $8F99C5
	db $00,$03,$00,$07,$00,$00,$00,$00,$00,$00,$00,$60,$10,$E0,$28,$C8	; $8F99D5
	db $44,$84,$80,$00,$00,$00,$00,$00,$00,$00,$00,$60,$00,$F0,$10,$F8	; $8F99E5
	db $38,$FC,$7E,$FE,$0C,$7C,$00,$78,$01,$70,$00,$80,$02,$00,$02,$00	; $8F99F5
	db $01,$00,$00,$00,$00,$0C,$01,$00,$41,$40,$82,$81,$02,$01,$02,$01	; $8F9A05
	db $03,$02,$03,$03,$18,$40,$30,$80,$60,$00,$58,$80,$30,$88,$08,$F8	; $8F9A15
	db $FC,$8C,$32,$72,$38,$C0,$78,$80,$70,$80,$78,$98,$70,$B0,$08,$88	; $8F9A25
	db $0C,$8C,$32,$F2,$00,$00,$00,$00,$04,$04,$06,$04,$36,$34,$1F,$2D	; $8F9A35
	db $1E,$33,$1C,$1F,$00,$00,$00,$00,$18,$1C,$3A,$3E,$0A,$3E,$33,$1E	; $8F9A45
	db $3E,$0D,$1C,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80	; $8F9A55
	db $60,$A0,$A0,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0	; $8F9A65
	db $00,$E0,$40,$E0,$00,$00,$00,$04,$01,$07,$00,$8F,$00,$CE,$00,$D8	; $8F9A75
	db $00,$70,$00,$70,$03,$03,$03,$03,$00,$01,$84,$84,$CC,$CC,$D8,$D8	; $8F9A85
	db $70,$70,$70,$70,$64,$68,$C6,$D0,$8C,$90,$18,$22,$54,$20,$40,$28	; $8F9A95
	db $96,$9E,$51,$45,$87,$F8,$0F,$F0,$0E,$B0,$5C,$20,$5C,$24,$50,$20	; $8F9AA5
	db $C6,$F6,$61,$7D,$00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$03,$05	; $8F9AB5
	db $03,$06,$03,$03,$00,$00,$00,$00,$02,$03,$07,$07,$07,$07,$06,$03	; $8F9AC5
	db $07,$01,$03,$00,$00,$00,$00,$00,$80,$00,$C0,$80,$C0,$80,$C0,$A0	; $8F9AD5
	db $C8,$68,$9C,$EC,$00,$00,$00,$00,$80,$80,$40,$C0,$40,$C0,$40,$E0	; $8F9AE5
	db $C0,$B8,$80,$7C,$26,$00,$01,$02,$0B,$8C,$14,$F8,$06,$E8,$16,$C8	; $8F9AF5
	db $10,$04,$12,$05,$18,$3F,$79,$7E,$73,$7C,$07,$18,$97,$88,$17,$08	; $8F9B05
	db $12,$0C,$12,$0E,$40,$00,$A0,$20,$70,$70,$D0,$F0,$30,$70,$10,$18	; $8F9B15
	db $00,$F8,$0E,$FE,$E0,$00,$C0,$00,$80,$10,$00,$70,$00,$F0,$60,$70	; $8F9B25
	db $00,$00,$0E,$0E,$04,$16,$04,$07,$00,$1F,$00,$3F,$1F,$00,$7F,$7F	; $8F9B35
	db $10,$10,$00,$00,$08,$1C,$18,$1C,$00,$00,$00,$00,$00,$00,$7F,$7F	; $8F9B45
	db $10,$10,$00,$00,$D0,$D0,$68,$68,$00,$00,$A0,$A0,$C0,$C0,$40,$40	; $8F9B55
	db $B0,$B0,$00,$00,$D0,$D0,$68,$68,$00,$00,$A0,$A0,$C0,$C0,$40,$40	; $8F9B65
	db $B0,$B0,$00,$00,$30,$0B,$2B,$10,$00,$10,$0C,$0C,$03,$03,$01,$01	; $8F9B75
	db $00,$00,$01,$01,$20,$3F,$04,$3F,$07,$1F,$03,$0F,$00,$03,$00,$01	; $8F9B85
	db $00,$00,$00,$00,$CD,$08,$06,$00,$06,$04,$87,$85,$0E,$0C,$9E,$9C	; $8F9B95
	db $F8,$F0,$B0,$80,$34,$FF,$FF,$FF,$FB,$FF,$7A,$FF,$F2,$FE,$60,$FE	; $8F9BA5
	db $02,$FC,$06,$78,$03,$04,$06,$02,$6A,$04,$64,$83,$70,$10,$1C,$1C	; $8F9BB5
	db $00,$00,$00,$00,$00,$07,$01,$07,$70,$7F,$F8,$FF,$6C,$7E,$00,$1C	; $8F9BC5
	db $00,$00,$00,$00,$42,$42,$C5,$84,$CA,$08,$E4,$00,$58,$40,$C2,$C4	; $8F9BD5
	db $D2,$C4,$42,$48,$BC,$FE,$78,$FF,$F0,$FF,$F1,$FE,$03,$3C,$33,$0C	; $8F9BE5
	db $33,$0C,$A6,$98,$01,$00,$00,$01,$00,$00,$00,$00,$8E,$8E,$34,$35	; $8F9BF5
	db $00,$01,$00,$01,$00,$01,$00,$01,$00,$00,$00,$00,$8E,$8E,$34,$34	; $8F9C05
	db $00,$00,$00,$00,$48,$C8,$F0,$F0,$18,$78,$00,$F0,$08,$F8,$18,$E8	; $8F9C15
	db $34,$D4,$68,$A8,$08,$C8,$10,$F0,$98,$98,$00,$00,$08,$08,$08,$08	; $8F9C25
	db $14,$14,$28,$28,$01,$0E,$06,$08,$09,$01,$01,$00,$1F,$12,$03,$0C	; $8F9C35
	db $1D,$12,$00,$20,$00,$0F,$01,$0F,$16,$1F,$1F,$1F,$01,$1F,$01,$1F	; $8F9C45
	db $01,$1F,$1C,$1E,$10,$10,$10,$10,$08,$08,$18,$18,$38,$38,$E8,$E0	; $8F9C55
	db $F0,$00,$80,$40,$E0,$F0,$E0,$F0,$F0,$F8,$E0,$F8,$C0,$F8,$00,$F8	; $8F9C65
	db $00,$F8,$38,$C0,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01	; $8F9C75
	db $02,$02,$04,$04,$20,$20,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01	; $8F9C85
	db $02,$02,$04,$04,$06,$1E,$66,$66,$E3,$FF,$02,$3E,$47,$7F,$3C,$0C	; $8F9C95
	db $36,$36,$41,$41,$02,$3E,$7A,$7E,$E3,$E3,$02,$02,$47,$47,$0C,$0C	; $8F9CA5
	db $36,$36,$41,$41,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8F9CB5
	db $00,$00,$00,$00,$00,$01,$00,$01,$01,$01,$01,$01,$01,$01,$00,$00	; $8F9CC5
	db $01,$01,$01,$01,$18,$E8,$1A,$DA,$D1,$11,$71,$51,$D9,$39,$1A,$DA	; $8F9CD5
	db $FF,$3C,$2C,$20,$04,$FC,$04,$FE,$2E,$FF,$8E,$FF,$06,$FF,$04,$FF	; $8F9CE5
	db $00,$FF,$C1,$FE,$0C,$1F,$D0,$CF,$E9,$86,$C7,$C1,$56,$22,$36,$64	; $8F9CF5
	db $76,$64,$43,$62,$4C,$73,$20,$FF,$70,$FF,$18,$FF,$1D,$FF,$1B,$7F	; $8F9D05
	db $1A,$7F,$0D,$5F,$80,$00,$C0,$40,$E0,$E0,$60,$60,$20,$10,$C0,$20	; $8F9D15
	db $30,$D0,$F0,$30,$00,$80,$00,$C0,$00,$E0,$80,$E0,$C0,$F0,$00,$F0	; $8F9D25
	db $00,$F0,$00,$F0,$03,$02,$01,$01,$0D,$0D,$07,$0B,$07,$0C,$07,$07	; $8F9D35
	db $03,$07,$0E,$09,$05,$07,$0E,$0F,$02,$0F,$0C,$07,$0F,$03,$07,$00	; $8F9D45
	db $13,$1C,$10,$1F,$00,$00,$80,$00,$80,$0C,$80,$0C,$80,$CC,$A0,$CC	; $8F9D55
	db $30,$DC,$70,$BC,$00,$00,$80,$80,$8C,$8C,$8C,$CC,$8C,$6C,$8C,$6C	; $8F9D65
	db $0C,$FC,$0C,$FC,$7B,$0A,$01,$01,$03,$03,$03,$03,$03,$03,$01,$00	; $8F9D75
	db $00,$00,$00,$01,$75,$7F,$00,$00,$00,$00,$00,$00,$00,$00,$03,$01	; $8F9D85
	db $00,$01,$00,$01,$FE,$3C,$3C,$3A,$DC,$C4,$E6,$E0,$C6,$C0,$E7,$E0	; $8F9D95
	db $63,$00,$00,$80,$C0,$FF,$01,$FE,$02,$39,$1E,$01,$3F,$00,$07,$00	; $8F9DA5
	db $63,$E0,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$30,$30	; $8F9DB5
	db $3B,$3A,$3F,$3E,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$1E,$0F,$3F	; $8F9DC5
	db $05,$3F,$01,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8F9DD5
	db $00,$00,$18,$50,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8F9DE5
	db $00,$00,$08,$78,$FC,$AE,$78,$FF,$68,$6F,$00,$0F,$01,$1E,$03,$1D	; $8F9DF5
	db $07,$1B,$1F,$07,$FC,$53,$F8,$07,$68,$07,$00,$0F,$00,$1F,$00,$1F	; $8F9E05
	db $00,$1F,$00,$1F,$C0,$C0,$A0,$20,$90,$10,$98,$18,$84,$84,$1C,$1C	; $8F9E15
	db $9D,$9C,$BA,$38,$00,$C0,$40,$E0,$60,$F0,$60,$F8,$78,$FC,$E2,$FE	; $8F9E25
	db $60,$FF,$C0,$FF,$00,$01,$00,$02,$00,$07,$00,$0F,$01,$0F,$00,$08	; $8F9E35
	db $00,$08,$00,$08,$01,$01,$03,$03,$00,$00,$04,$04,$05,$05,$08,$08	; $8F9E45
	db $08,$08,$08,$08,$30,$42,$10,$44,$62,$A2,$D0,$D1,$F5,$F3,$78,$7C	; $8F9E55
	db $98,$98,$3C,$3D,$B9,$86,$B2,$8C,$18,$27,$CC,$DF,$F8,$FF,$7B,$7F	; $8F9E65
	db $9B,$9B,$3C,$3C,$00,$00,$60,$60,$76,$75,$7F,$7D,$3F,$2B,$1F,$3F	; $8F9E75
	db $1A,$1B,$00,$03,$3C,$3C,$1E,$7E,$0A,$7F,$03,$7E,$3F,$14,$3F,$00	; $8F9E85
	db $1A,$01,$00,$03,$00,$00,$00,$00,$00,$00,$00,$80,$50,$90,$28,$C8	; $8F9E95
	db $24,$C4,$20,$C0,$00,$00,$00,$00,$40,$C0,$20,$E0,$20,$F0,$10,$F8	; $8F9EA5
	db $18,$FC,$1C,$FC,$D1,$DE,$00,$1F,$00,$0F,$19,$16,$16,$10,$14,$08	; $8F9EB5
	db $0E,$14,$0E,$0D,$D0,$0F,$00,$1F,$00,$1F,$00,$1F,$01,$1F,$07,$1F	; $8F9EC5
	db $0B,$1F,$02,$0F,$00,$00,$80,$00,$80,$00,$00,$00,$40,$00,$40,$00	; $8F9ED5
	db $20,$00,$B4,$40,$C0,$C0,$60,$E0,$60,$E0,$F0,$F0,$F0,$F0,$F8,$F8	; $8F9EE5
	db $B8,$FC,$30,$FC,$0F,$36,$03,$31,$00,$19,$10,$07,$08,$13,$04,$1B	; $8F9EF5
	db $04,$19,$36,$20,$11,$1F,$18,$17,$1E,$18,$1E,$16,$0C,$08,$04,$00	; $8F9F05
	db $04,$03,$2E,$29,$90,$90,$00,$03,$10,$53,$00,$C3,$00,$C3,$00,$C6	; $8F9F15
	db $00,$36,$00,$96,$60,$F0,$F3,$E3,$A3,$A3,$33,$03,$23,$03,$66,$46	; $8F9F25
	db $F6,$36,$56,$96,$19,$00,$1C,$14,$06,$02,$06,$0A,$0F,$09,$02,$06	; $8F9F35
	db $00,$07,$00,$07,$1E,$1F,$0B,$1F,$05,$0F,$05,$0F,$02,$0F,$00,$03	; $8F9F45
	db $00,$00,$01,$01,$F0,$7C,$4C,$30,$40,$20,$82,$C2,$04,$E4,$0E,$CA	; $8F9F55
	db $7E,$C6,$62,$02,$0C,$FC,$DC,$FC,$FE,$FE,$7C,$FE,$58,$5E,$30,$3C	; $8F9F65
	db $B0,$F8,$8C,$70,$00,$01,$00,$03,$00,$07,$C8,$CF,$18,$1F,$03,$03	; $8F9F75
	db $0C,$0C,$00,$00,$00,$00,$00,$00,$00,$00,$C8,$C8,$18,$18,$03,$03	; $8F9F85
	db $0C,$0C,$00,$00,$80,$E0,$00,$E0,$10,$F0,$22,$E2,$FC,$FC,$69,$69	; $8F9F95
	db $2E,$2E,$08,$08,$00,$C0,$00,$00,$10,$10,$22,$22,$FC,$FC,$69,$69	; $8F9FA5
	db $2E,$2E,$08,$08,$1F,$15,$0F,$1F,$0D,$0D,$00,$03,$44,$C1,$F2,$34	; $8F9FB5
	db $E1,$22,$62,$A1,$1F,$0A,$1F,$00,$0D,$00,$00,$03,$00,$47,$C0,$FF	; $8F9FC5
	db $D8,$FF,$5C,$7F,$0C,$E8,$0C,$E8,$24,$C0,$24,$C4,$42,$82,$22,$22	; $8F9FD5
	db $71,$51,$F7,$17,$04,$FC,$04,$FC,$1C,$FC,$18,$FC,$3C,$FE,$5D,$FF	; $8F9FE5
	db $2E,$FF,$E8,$FF,$0F,$0E,$02,$12,$12,$E1,$2D,$E1,$23,$E3,$1F,$19	; $8F9FF5
	db $01,$02,$02,$07,$01,$0F,$1C,$1F,$7C,$7F,$9E,$BF,$1C,$3E,$06,$1E	; $8FA005
	db $01,$03,$00,$03,$F4,$72,$F8,$31,$64,$81,$8C,$81,$0E,$00,$C6,$C0	; $8FA015
	db $83,$00,$01,$00,$81,$FE,$C0,$FF,$44,$FB,$7C,$03,$FE,$01,$0E,$01	; $8FA025
	db $C7,$80,$03,$80,$00,$10,$00,$10,$00,$20,$00,$20,$03,$43,$04,$44	; $8FA035
	db $18,$58,$20,$A0,$10,$10,$10,$10,$20,$20,$20,$20,$43,$43,$44,$44	; $8FA045
	db $58,$58,$A0,$A0,$5E,$5F,$AC,$AF,$1C,$1F,$80,$83,$03,$03,$00,$00	; $8FA055
	db $00,$00,$00,$00,$5E,$5E,$AC,$AC,$1C,$1C,$80,$80,$03,$03,$00,$00	; $8FA065
	db $00,$00,$00,$00,$00,$03,$00,$03,$00,$01,$01,$00,$00,$00,$00,$00	; $8FA075
	db $00,$01,$00,$01,$00,$03,$00,$03,$00,$03,$02,$03,$01,$01,$01,$01	; $8FA085
	db $01,$01,$01,$01,$42,$82,$46,$86,$C2,$40,$F4,$71,$F8,$01,$10,$01	; $8FA095
	db $68,$E1,$F8,$42,$3C,$FE,$38,$FF,$38,$FF,$80,$FF,$C4,$FB,$9C,$F3	; $8FA0A5
	db $1C,$83,$B9,$86,$06,$0D,$00,$0E,$00,$0E,$1C,$1E,$1E,$1F,$0E,$2F	; $8FA0B5
	db $24,$11,$18,$65,$02,$07,$01,$01,$01,$01,$03,$02,$01,$01,$00,$30	; $8FA0C5
	db $25,$3D,$19,$19,$18,$80,$A0,$10,$00,$08,$00,$08,$00,$C4,$00,$C0	; $8FA0D5
	db $00,$84,$00,$0C,$00,$FC,$48,$F0,$E0,$F8,$E4,$F8,$30,$2C,$38,$04	; $8FA0E5
	db $7C,$04,$7C,$7C,$00,$07,$0C,$0F,$0C,$0E,$1F,$1F,$3F,$1F,$3E,$2E	; $8FA0F5
	db $44,$34,$00,$F8,$00,$00,$00,$00,$01,$00,$00,$00,$00,$20,$00,$30	; $8FA105
	db $40,$58,$00,$00,$00,$FF,$98,$80,$70,$04,$70,$04,$30,$04,$28,$00	; $8FA115
	db $1C,$1C,$38,$24,$FE,$FE,$78,$04,$F0,$0C,$F0,$0C,$70,$0C,$78,$04	; $8FA125
	db $60,$1C,$00,$3C,$00,$00,$0C,$0C,$0E,$0E,$0F,$0F,$07,$05,$03,$0F	; $8FA135
	db $03,$1F,$08,$07,$07,$07,$03,$0F,$01,$0F,$00,$0F,$07,$02,$07,$08	; $8FA145
	db $03,$1C,$20,$3F,$00,$00,$00,$00,$C0,$80,$C0,$80,$80,$40,$B0,$D0	; $8FA155
	db $20,$C0,$40,$80,$80,$80,$C0,$C0,$40,$C0,$40,$C0,$80,$E0,$80,$70	; $8FA165
	db $18,$F8,$38,$F8,$1E,$1F,$0C,$1D,$17,$27,$04,$74,$00,$78,$00,$70	; $8FA175
	db $10,$70,$7E,$7E,$00,$00,$02,$10,$18,$10,$02,$08,$04,$00,$00,$00	; $8FA185
	db $10,$10,$7E,$7E,$1C,$C0,$1C,$C0,$14,$00,$0E,$00,$20,$20,$18,$18	; $8FA195
	db $10,$04,$00,$0C,$3C,$02,$3C,$02,$7C,$02,$3E,$00,$1C,$20,$00,$1C	; $8FA1A5
	db $00,$1C,$10,$18,$00,$00,$30,$30,$3B,$38,$3F,$3C,$1E,$15,$0E,$1F	; $8FA1B5
	db $0D,$3E,$20,$1E,$1E,$1E,$0F,$3F,$07,$3F,$03,$3F,$1E,$0B,$1E,$01	; $8FA1C5
	db $0C,$33,$41,$7F,$00,$00,$00,$00,$20,$C0,$10,$E0,$2B,$C4,$42,$88	; $8FA1D5
	db $E4,$40,$34,$21,$00,$00,$00,$00,$00,$E0,$08,$F8,$13,$FF,$33,$FF	; $8FA1E5
	db $37,$FF,$D6,$FE,$0B,$78,$0C,$24,$26,$5A,$79,$E5,$38,$38,$AA,$A8	; $8FA1F5
	db $87,$80,$0F,$00,$04,$0F,$23,$3F,$41,$7F,$80,$FF,$C2,$FD,$47,$F0	; $8FA205
	db $0F,$90,$1F,$00,$6C,$4C,$78,$58,$F4,$B0,$BA,$0E,$78,$3A,$3C,$3D	; $8FA215
	db $1C,$1D,$8E,$0E,$B0,$FC,$A0,$FC,$40,$FE,$C0,$F4,$00,$C6,$C0,$03	; $8FA225
	db $E0,$03,$F0,$01,$1C,$01,$08,$03,$08,$0B,$02,$1C,$00,$0E,$06,$0E	; $8FA235
	db $08,$1E,$00,$1E,$3E,$00,$3C,$00,$16,$1E,$04,$1E,$18,$1E,$18,$1E	; $8FA245
	db $10,$18,$10,$10,$4F,$CF,$0E,$8F,$00,$83,$01,$01,$02,$02,$05,$05	; $8FA255
	db $5E,$5E,$3C,$3C,$00,$41,$00,$02,$00,$04,$01,$01,$02,$02,$05,$05	; $8FA265
	db $5E,$5E,$3C,$3C,$00,$00,$02,$02,$34,$28,$3A,$24,$19,$16,$19,$16	; $8FA275
	db $18,$17,$B8,$2F,$00,$00,$1C,$1E,$53,$7F,$D9,$FF,$E8,$FF,$E8,$FF	; $8FA285
	db $E8,$FF,$D8,$F7,$00,$00,$00,$00,$80,$80,$20,$20,$10,$10,$08,$08	; $8FA295
	db $84,$04,$46,$04,$00,$00,$00,$00,$00,$80,$C0,$E0,$E0,$F0,$F0,$F8	; $8FA2A5
	db $78,$FC,$78,$FE,$3E,$1F,$18,$21,$1C,$1D,$00,$1C,$00,$1D,$00,$3D	; $8FA2B5
	db $00,$38,$07,$3F,$01,$31,$01,$3D,$01,$1D,$00,$00,$00,$00,$00,$00	; $8FA2C5
	db $00,$00,$07,$07,$0D,$09,$10,$10,$40,$F3,$00,$E3,$00,$E3,$0E,$EF	; $8FA2D5
	db $3A,$FB,$4B,$6B,$76,$79,$6D,$73,$8C,$C6,$00,$00,$00,$00,$0E,$0E	; $8FA2E5
	db $7A,$7A,$6B,$6B,$0E,$FE,$1E,$FE,$5A,$5A,$03,$03,$01,$01,$01,$01	; $8FA2F5
	db $00,$00,$00,$00,$0E,$0E,$1E,$1E,$5A,$5A,$03,$03,$01,$01,$01,$01	; $8FA305
	db $00,$00,$00,$00,$24,$1C,$80,$80,$40,$5C,$80,$BC,$40,$78,$C4,$FC	; $8FA315
	db $3E,$2E,$05,$05,$00,$3C,$9C,$9C,$40,$40,$80,$80,$40,$40,$C4,$C4	; $8FA325
	db $2E,$2E,$05,$05,$0F,$08,$00,$00,$0C,$04,$06,$02,$07,$01,$09,$05	; $8FA335
	db $07,$1A,$01,$02,$30,$3F,$3F,$3F,$3B,$3F,$3D,$3F,$1A,$1F,$00,$1F	; $8FA345
	db $01,$1F,$05,$0D,$A0,$20,$34,$12,$32,$24,$24,$28,$1C,$10,$1E,$10	; $8FA355
	db $AA,$A1,$D0,$41,$5C,$FC,$E8,$FE,$D0,$FE,$C3,$FF,$EF,$FF,$EF,$FF	; $8FA365
	db $42,$FA,$84,$F8,$32,$32,$0F,$0F,$03,$03,$05,$05,$00,$00,$00,$00	; $8FA375
	db $00,$00,$00,$00,$32,$32,$0F,$0F,$03,$03,$05,$05,$00,$00,$00,$00	; $8FA385
	db $00,$00,$00,$00,$00,$1C,$00,$1C,$80,$98,$60,$78,$DC,$DC,$3A,$3A	; $8FA395
	db $0C,$0C,$02,$02,$00,$00,$00,$00,$80,$80,$60,$60,$DC,$DC,$3A,$3A	; $8FA3A5
	db $0C,$0C,$02,$02,$1C,$00,$18,$18,$0C,$04,$0A,$08,$02,$0C,$0B,$01	; $8FA3B5
	db $08,$09,$0C,$0D,$63,$7F,$67,$7F,$7B,$7F,$33,$3F,$33,$3F,$06,$0F	; $8FA3C5
	db $06,$06,$02,$02,$30,$21,$18,$01,$18,$12,$08,$04,$04,$18,$C0,$D4	; $8FA3D5
	db $40,$20,$08,$C0,$D2,$F2,$F8,$FC,$EA,$FE,$FC,$FC,$F8,$FC,$18,$F4	; $8FA3E5
	db $28,$F4,$7C,$40,$1F,$00,$1F,$00,$0A,$00,$00,$00,$06,$06,$18,$02	; $8FA3F5
	db $02,$1E,$08,$1E,$3F,$00,$3F,$00,$3F,$00,$1E,$00,$18,$1E,$00,$1E	; $8FA405
	db $00,$1E,$00,$08,$3E,$3E,$1F,$1F,$0C,$0F,$00,$07,$00,$03,$02,$03	; $8FA415
	db $07,$07,$1B,$1B,$80,$01,$00,$01,$00,$0C,$00,$00,$00,$00,$02,$02	; $8FA425
	db $07,$07,$1B,$1B,$00,$3E,$03,$3F,$02,$7E,$07,$7F,$1E,$4E,$13,$93	; $8FA435
	db $00,$80,$01,$01,$20,$20,$23,$23,$42,$42,$47,$47,$4E,$4E,$93,$93	; $8FA445
	db $80,$80,$01,$01,$EC,$EC,$18,$18,$88,$88,$70,$70,$00,$00,$00,$00	; $8FA455
	db $80,$80,$00,$00,$EC,$EC,$18,$18,$88,$88,$70,$70,$00,$00,$00,$00	; $8FA465
	db $80,$80,$00,$00,$74,$73,$3C,$3F,$1B,$1C,$00,$04,$09,$02,$0D,$00	; $8FA475
	db $1C,$00,$3E,$01,$70,$0F,$00,$3F,$00,$1B,$0B,$03,$0C,$11,$0F,$13	; $8FA485
	db $1F,$03,$3E,$00,$34,$94,$FE,$5A,$3C,$2A,$48,$10,$8C,$6E,$FC,$1C	; $8FA495
	db $7E,$5F,$FF,$FF,$28,$FE,$20,$FC,$D0,$FE,$80,$FE,$00,$F2,$C0,$F2	; $8FA4A5
	db $A0,$F1,$00,$E0,$1D,$0D,$07,$07,$00,$00,$00,$00,$00,$00,$00,$00	; $8FA4B5
	db $00,$00,$00,$00,$0D,$0D,$07,$07,$00,$00,$00,$00,$00,$00,$00,$00	; $8FA4C5
	db $00,$00,$00,$00,$96,$B6,$C0,$D0,$40,$50,$40,$48,$20,$28,$10,$18	; $8FA4D5
	db $08,$0E,$08,$0E,$B6,$B6,$D0,$D0,$50,$50,$48,$48,$28,$28,$18,$18	; $8FA4E5
	db $0E,$0E,$0E,$0E,$18,$10,$1C,$10,$0E,$8A,$0E,$88,$0D,$8A,$5C,$97	; $8FA4F5
	db $38,$7F,$20,$1F,$2E,$3E,$6F,$7F,$75,$FF,$75,$FF,$74,$FF,$6C,$FB	; $8FA505
	db $38,$47,$00,$3F,$00,$00,$80,$80,$60,$60,$10,$10,$08,$08,$84,$04	; $8FA515
	db $8E,$0E,$66,$64,$00,$00,$00,$80,$80,$E0,$E0,$F0,$F0,$F8,$78,$FC	; $8FA525
	db $70,$FE,$18,$FE,$00,$13,$0C,$10,$08,$00,$19,$01,$02,$02,$0C,$0C	; $8FA535
	db $2C,$08,$18,$24,$0C,$10,$0F,$10,$0F,$10,$1E,$20,$1C,$20,$30,$20	; $8FA545
	db $10,$3C,$00,$3C,$68,$EF,$64,$64,$62,$62,$36,$36,$1E,$1E,$08,$08	; $8FA555
	db $02,$07,$00,$0F,$17,$07,$98,$00,$1C,$00,$08,$00,$00,$06,$10,$1E	; $8FA565
	db $00,$0E,$00,$00,$00,$00,$00,$00,$06,$04,$07,$04,$03,$02,$03,$22	; $8FA575
	db $03,$62,$17,$65,$00,$00,$00,$00,$0A,$0E,$1B,$1F,$1D,$1F,$1D,$7F	; $8FA585
	db $1D,$FF,$1B,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0	; $8FA595
	db $00,$F0,$1C,$E8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$00,$F0	; $8FA5A5
	db $00,$F8,$04,$FC,$20,$13,$0E,$21,$0C,$20,$0C,$20,$20,$20,$2C,$0C	; $8FA5B5
	db $10,$20,$00,$58,$24,$18,$0E,$30,$0F,$30,$0E,$30,$0E,$30,$10,$3C	; $8FA5C5
	db $04,$3C,$20,$38,$28,$E0,$60,$E0,$74,$74,$18,$18,$18,$04,$10,$1C	; $8FA5D5
	db $00,$1C,$00,$1E,$1C,$00,$1C,$00,$08,$04,$20,$1C,$00,$1C,$00,$1C	; $8FA5E5
	db $00,$00,$00,$00,$03,$03,$01,$01,$00,$00,$00,$08,$07,$1B,$01,$1F	; $8FA5F5
	db $21,$1E,$1F,$01,$00,$03,$06,$07,$07,$07,$07,$0F,$04,$1F,$03,$3C	; $8FA605
	db $00,$3F,$20,$3F,$80,$80,$C0,$E0,$40,$70,$48,$68,$C4,$04,$B4,$A0	; $8FA615
	db $6A,$44,$B6,$AA,$00,$80,$00,$E0,$80,$F0,$80,$F8,$D8,$FC,$98,$7C	; $8FA625
	db $30,$FE,$50,$FE,$54,$07,$0D,$21,$07,$47,$1A,$42,$38,$80,$38,$80	; $8FA635
	db $F0,$80,$00,$00,$18,$7C,$40,$3E,$18,$60,$9C,$60,$3E,$C0,$3C,$C0	; $8FA645
	db $78,$80,$F0,$80,$30,$D0,$20,$80,$80,$80,$C0,$C0,$60,$60,$70,$70	; $8FA655
	db $30,$00,$40,$F0,$20,$00,$70,$00,$70,$00,$30,$00,$90,$80,$80,$F0	; $8FA665
	db $00,$70,$00,$70,$00,$00,$00,$00,$00,$00,$06,$07,$03,$02,$21,$00	; $8FA675
	db $21,$00,$41,$20,$00,$00,$00,$00,$02,$03,$08,$0F,$1D,$1F,$3F,$3F	; $8FA685
	db $5F,$7F,$9F,$FF,$00,$01,$68,$6F,$00,$07,$48,$8F,$50,$97,$60,$A7	; $8FA695
	db $C0,$44,$80,$88,$01,$01,$11,$79,$79,$F9,$30,$F8,$28,$F8,$04,$E4	; $8FA6A5
	db $04,$C4,$08,$88,$04,$00,$0B,$04,$10,$4E,$50,$2C,$40,$54,$7D,$75	; $8FA6B5
	db $3B,$33,$1D,$1D,$0B,$0F,$30,$3F,$01,$7F,$03,$7F,$03,$7F,$0A,$7F	; $8FA6C5
	db $0D,$3E,$03,$1E,$00,$00,$00,$00,$20,$20,$14,$14,$12,$02,$F4,$C8	; $8FA6D5
	db $70,$FC,$60,$FC,$80,$80,$30,$F0,$C8,$F8,$E8,$FC,$F4,$FE,$32,$FE	; $8FA6E5
	db $D0,$2E,$E0,$1E,$10,$2F,$1C,$11,$09,$0E,$01,$1F,$11,$1F,$39,$3F	; $8FA6F5
	db $3D,$3F,$3E,$3F,$00,$3F,$20,$3F,$10,$19,$00,$01,$04,$04,$02,$02	; $8FA705
	db $02,$02,$01,$21,$7C,$98,$38,$AA,$04,$00,$3C,$00,$84,$B2,$34,$40	; $8FA715
	db $3C,$38,$0C,$08,$20,$FE,$10,$FE,$74,$FA,$CC,$F2,$04,$FA,$0C,$7A	; $8FA725
	db $04,$7A,$74,$7A,$0C,$0C,$10,$38,$00,$38,$07,$3F,$43,$7B,$3C,$2C	; $8FA735
	db $1E,$1E,$11,$11,$30,$3C,$00,$10,$00,$00,$07,$07,$43,$43,$2C,$2C	; $8FA745
	db $1E,$1E,$11,$11,$00,$0F,$14,$13,$7F,$7E,$D3,$D3,$34,$34,$90,$90	; $8FA755
	db $00,$00,$00,$00,$00,$00,$10,$10,$7E,$7E,$D3,$D3,$34,$34,$90,$90	; $8FA765
	db $00,$00,$00,$00,$6E,$1F,$70,$60,$D1,$31,$29,$49,$5F,$13,$0F,$0C	; $8FA775
	db $00,$07,$08,$0F,$8E,$F1,$9F,$FF,$0E,$FF,$06,$7F,$2C,$7F,$33,$3F	; $8FA785
	db $18,$18,$10,$18,$FC,$1C,$64,$22,$F1,$DD,$F7,$E1,$FD,$F1,$D0,$C0	; $8FA795
	db $21,$81,$00,$F9,$00,$FC,$D8,$FE,$20,$FF,$12,$FF,$0E,$FF,$07,$F7	; $8FA7A5
	db $02,$73,$78,$78,$00,$C0,$20,$E0,$00,$E0,$0F,$EF,$16,$F6,$FD,$BD	; $8FA7B5
	db $7E,$7E,$94,$94,$38,$38,$10,$30,$00,$00,$0F,$0F,$16,$16,$BD,$BD	; $8FA7C5
	db $7E,$7E,$94,$94,$00,$1F,$30,$3F,$FF,$F9,$FF,$FF,$B8,$B8,$40,$40	; $8FA7D5
	db $00,$00,$00,$00,$00,$00,$30,$30,$F9,$F9,$FF,$FF,$B8,$B8,$40,$40	; $8FA7E5
	db $00,$00,$00,$00,$06,$06,$14,$00,$26,$1A,$16,$22,$03,$01,$03,$02	; $8FA7F5
	db $02,$13,$04,$17,$39,$3F,$27,$3F,$05,$3F,$05,$3F,$1E,$1F,$1D,$1F	; $8FA805
	db $0C,$1E,$00,$1C,$3C,$25,$32,$23,$38,$2B,$68,$6F,$B2,$8F,$C0,$10	; $8FA815
	db $10,$E0,$38,$C0,$D2,$FE,$DC,$FE,$D4,$FC,$82,$FA,$0C,$FE,$10,$F0	; $8FA825
	db $38,$20,$3C,$00,$E0,$60,$00,$80,$81,$81,$00,$00,$0F,$0F,$95,$95	; $8FA835
	db $B8,$B8,$F0,$F0,$00,$E0,$00,$C0,$01,$81,$00,$00,$0F,$0F,$95,$95	; $8FA845
	db $B8,$B8,$F0,$F0,$00,$F0,$00,$F8,$80,$FC,$72,$6E,$AD,$AD,$5E,$5E	; $8FA855
	db $30,$30,$00,$00,$00,$00,$00,$00,$80,$80,$62,$62,$AD,$AD,$5E,$5E	; $8FA865
	db $30,$30,$00,$00,$97,$66,$0F,$FF,$83,$7D,$FC,$04,$7E,$02,$3E,$0C	; $8FA875
	db $07,$06,$02,$03,$19,$FF,$0E,$F1,$00,$FF,$8B,$FF,$FD,$FF,$72,$7F	; $8FA885
	db $79,$7F,$3C,$3E,$80,$88,$00,$10,$00,$10,$80,$A0,$00,$40,$80,$C0	; $8FA895
	db $40,$80,$30,$D0,$08,$88,$10,$10,$10,$10,$20,$A0,$40,$C0,$60,$40	; $8FA8A5
	db $E0,$80,$20,$00,$17,$1F,$03,$1E,$01,$1F,$00,$0C,$0C,$70,$11,$F1	; $8FA8B5
	db $08,$F8,$18,$F8,$00,$17,$01,$03,$00,$01,$08,$0B,$3E,$31,$0E,$1F	; $8FA8C5
	db $07,$0F,$07,$1F,$C6,$FA,$82,$38,$E6,$18,$DA,$40,$46,$04,$9C,$58	; $8FA8D5
	db $18,$20,$7C,$58,$C0,$3E,$82,$FE,$C2,$FE,$A6,$FE,$3A,$FE,$24,$FC	; $8FA8E5
	db $98,$F8,$A0,$E4,$00,$00,$03,$00,$04,$00,$18,$00,$40,$78,$66,$5F	; $8FA8F5
	db $7E,$43,$0F,$1F,$01,$01,$04,$07,$0B,$0F,$27,$3F,$07,$7F,$03,$7C	; $8FA905
	db $23,$7C,$01,$3E,$00,$00,$B0,$30,$48,$48,$20,$30,$24,$18,$E2,$BC	; $8FA915
	db $C0,$FC,$84,$B8,$E0,$E0,$08,$F8,$84,$FC,$C4,$FC,$E2,$FE,$E0,$5E	; $8FA925
	db $C0,$3E,$80,$7E,$00,$00,$10,$18,$00,$18,$23,$1B,$26,$1F,$3A,$23	; $8FA935
	db $1F,$0F,$19,$09,$03,$07,$07,$1F,$27,$3F,$04,$3F,$43,$7C,$43,$7C	; $8FA945
	db $71,$7E,$76,$7F,$50,$40,$68,$70,$20,$38,$E0,$F8,$E0,$F8,$D0,$CC	; $8FA955
	db $FE,$F2,$FE,$FE,$80,$F0,$80,$F8,$C0,$F8,$00,$FC,$A0,$5C,$C0,$3E	; $8FA965
	db $80,$7E,$00,$FE,$00,$00,$00,$00,$80,$80,$80,$C0,$00,$E0,$00,$F0	; $8FA975
	db $00,$F8,$00,$E7,$00,$00,$00,$00,$00,$80,$00,$80,$00,$00,$80,$80	; $8FA985
	db $08,$08,$07,$07,$00,$00,$00,$00,$00,$06,$00,$0E,$00,$1C,$00,$38	; $8FA995
	db $00,$70,$00,$E0,$00,$00,$00,$00,$06,$06,$0E,$0E,$1C,$1C,$38,$38	; $8FA9A5
	db $70,$70,$E0,$E0,$28,$10,$09,$11,$04,$10,$00,$10,$00,$10,$18,$00	; $8FA9B5
	db $20,$40,$08,$28,$2F,$10,$0E,$10,$07,$18,$07,$18,$2E,$10,$3C,$20	; $8FA9C5
	db $18,$70,$40,$78,$F0,$F1,$F0,$F0,$70,$70,$60,$48,$10,$78,$00,$7C	; $8FA9D5
	db $00,$7E,$E1,$FF,$00,$00,$00,$00,$00,$38,$00,$78,$00,$70,$00,$00	; $8FA9E5
	db $00,$00,$E1,$E1,$00,$00,$01,$01,$03,$03,$00,$0C,$03,$1D,$23,$1C	; $8FA9F5
	db $B3,$2D,$5C,$90,$00,$00,$00,$01,$00,$03,$03,$0F,$02,$1F,$43,$7F	; $8FAA05
	db $43,$FE,$20,$FF,$00,$00,$C0,$C0,$20,$20,$60,$40,$E0,$F0,$E0,$F8	; $8FAA15
	db $F0,$E0,$DC,$DC,$00,$00,$00,$C0,$C0,$E0,$A0,$E0,$00,$F0,$20,$D8	; $8FAA25
	db $E0,$1C,$C0,$3C,$10,$04,$18,$04,$10,$0C,$01,$10,$01,$00,$20,$01	; $8FAA35
	db $1C,$2D,$08,$11,$19,$06,$19,$06,$11,$0E,$07,$19,$3F,$31,$1C,$30	; $8FAA45
	db $00,$3C,$60,$78,$E0,$90,$80,$F0,$C0,$30,$80,$40,$C0,$40,$C0,$60	; $8FAA55
	db $09,$F9,$06,$FE,$60,$60,$40,$40,$C0,$C0,$80,$C0,$80,$C0,$80,$C0	; $8FAA65
	db $09,$09,$06,$06,$00,$00,$00,$00,$00,$00,$00,$01,$02,$01,$02,$01	; $8FAA75
	db $06,$05,$16,$15,$00,$00,$00,$00,$00,$01,$00,$03,$04,$07,$0C,$0F	; $8FAA85
	db $18,$1F,$08,$1F,$00,$00,$00,$00,$68,$A8,$84,$85,$FC,$7D,$FC,$3D	; $8FAA95
	db $78,$B9,$30,$FA,$00,$00,$00,$60,$50,$F8,$79,$FD,$81,$FD,$C1,$FD	; $8FAAA5
	db $49,$F1,$3A,$C2,$1F,$07,$17,$02,$19,$05,$19,$04,$08,$02,$04,$02	; $8FAAB5
	db $00,$02,$00,$04,$20,$1F,$30,$0F,$18,$07,$19,$06,$0C,$03,$04,$03	; $8FAAC5
	db $04,$03,$09,$06,$B8,$38,$48,$40,$F0,$08,$78,$60,$60,$60,$60,$60	; $8FAAD5
	db $60,$60,$40,$00,$C0,$F8,$30,$F8,$C0,$F8,$98,$38,$80,$00,$80,$00	; $8FAAE5
	db $80,$00,$C0,$60,$0F,$03,$0E,$01,$04,$0B,$00,$13,$00,$11,$02,$08	; $8FAAF5
	db $00,$09,$00,$0B,$0C,$1F,$0E,$0E,$04,$0C,$04,$18,$06,$18,$13,$0C	; $8FAB05
	db $03,$0D,$01,$0D,$E6,$9A,$1E,$86,$3A,$FA,$2A,$E2,$76,$F8,$08,$8C	; $8FAB15
	db $10,$FC,$00,$FC,$40,$FE,$00,$7E,$04,$1E,$44,$5E,$82,$BE,$F0,$FC	; $8FAB25
	db $00,$10,$00,$00,$2C,$14,$4F,$29,$04,$07,$0C,$0F,$08,$0F,$0C,$00	; $8FAB35
	db $0E,$00,$1C,$00,$4B,$7F,$06,$7F,$18,$3C,$10,$1C,$00,$18,$0F,$10	; $8FAB45
	db $0F,$10,$1F,$20,$76,$56,$F2,$C2,$14,$00,$70,$EE,$7A,$F8,$12,$D2	; $8FAB55
	db $14,$24,$08,$16,$A8,$FE,$3C,$FE,$10,$FE,$10,$1E,$80,$8E,$EC,$CE	; $8FAB65
	db $38,$3C,$18,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FAB75
	db $CF,$CF,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FAB85
	db $CF,$CF,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$08	; $8FAB95
	db $50,$50,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$08	; $8FABA5
	db $50,$50,$00,$00,$31,$31,$0E,$7E,$06,$7E,$C3,$FF,$62,$7E,$1F,$17	; $8FABB5
	db $0C,$0C,$02,$02,$41,$71,$0E,$0E,$06,$06,$C3,$C3,$62,$62,$17,$17	; $8FABC5
	db $0C,$0C,$02,$02,$7F,$73,$B0,$B0,$60,$60,$80,$80,$00,$00,$00,$00	; $8FABD5
	db $00,$00,$00,$00,$73,$73,$B0,$B0,$60,$60,$80,$80,$00,$00,$00,$00	; $8FABE5
	db $00,$00,$00,$00,$AF,$4F,$78,$08,$0E,$06,$01,$0F,$00,$1F,$00,$1E	; $8FABF5
	db $01,$2F,$0D,$11,$30,$FF,$F7,$FF,$79,$7F,$30,$31,$01,$01,$20,$01	; $8FAC05
	db $00,$30,$2E,$10,$88,$88,$32,$1E,$27,$0A,$C7,$D5,$4A,$CA,$00,$60	; $8FAC15
	db $E1,$FF,$F0,$F1,$70,$FC,$E0,$FE,$E1,$FF,$02,$DF,$85,$CF,$67,$E7	; $8FAC25
	db $1E,$1F,$01,$01,$31,$30,$20,$60,$03,$7B,$07,$7F,$65,$5D,$3E,$26	; $8FAC35
	db $10,$10,$00,$00,$40,$70,$10,$30,$03,$03,$07,$07,$45,$45,$26,$26	; $8FAC45
	db $10,$10,$00,$00,$FF,$07,$F4,$F4,$5B,$5B,$F0,$F0,$00,$00,$00,$00	; $8FAC55
	db $00,$00,$00,$00,$07,$07,$F4,$F4,$5B,$5B,$F0,$F0,$00,$00,$00,$00	; $8FAC65
	db $00,$00,$00,$00,$02,$01,$3B,$1A,$1B,$1A,$1F,$0F,$16,$06,$2D,$01	; $8FAC75
	db $10,$04,$19,$04,$1C,$3F,$04,$3F,$05,$3F,$20,$1F,$20,$1F,$20,$1F	; $8FAC85
	db $19,$06,$19,$06,$10,$F7,$10,$FF,$50,$1F,$A0,$A4,$A0,$24,$60,$68	; $8FAC95
	db $40,$88,$80,$70,$00,$F0,$02,$F2,$02,$F2,$44,$E4,$C4,$E4,$08,$E8	; $8FACA5
	db $08,$E8,$90,$F0,$10,$08,$0B,$0B,$0F,$16,$00,$09,$48,$49,$31,$F0	; $8FACB5
	db $00,$F0,$07,$FF,$13,$0C,$14,$1B,$21,$3F,$30,$3C,$30,$78,$00,$30	; $8FACC5
	db $00,$00,$07,$07,$80,$40,$C0,$40,$C0,$60,$00,$F0,$00,$F8,$FE,$06	; $8FACD5
	db $FC,$FC,$F3,$F3,$80,$C0,$80,$C0,$80,$C0,$00,$00,$00,$00,$06,$06	; $8FACE5
	db $FC,$FC,$F3,$F3,$03,$03,$07,$06,$0C,$0A,$03,$05,$0F,$0A,$06,$05	; $8FACF5
	db $06,$05,$02,$01,$00,$03,$01,$07,$00,$0F,$00,$0F,$00,$0F,$00,$07	; $8FAD05
	db $00,$07,$00,$03,$80,$F8,$E0,$30,$80,$90,$80,$10,$00,$D0,$00,$F0	; $8FAD15
	db $60,$A0,$E0,$20,$00,$80,$D0,$F0,$10,$90,$10,$D0,$10,$F0,$10,$F0	; $8FAD25
	db $58,$F8,$DC,$FC,$C0,$93,$E4,$C8,$73,$68,$28,$A4,$8C,$43,$31,$F1	; $8FAD35
	db $E3,$E1,$F9,$FA,$6D,$91,$37,$C8,$13,$EC,$08,$E7,$8C,$8B,$36,$31	; $8FAD45
	db $E0,$E3,$F8,$FB,$00,$70,$00,$F0,$00,$F0,$80,$60,$40,$10,$E0,$F0	; $8FAD55
	db $20,$28,$60,$64,$80,$00,$00,$00,$00,$00,$A0,$20,$70,$90,$10,$F0	; $8FAD65
	db $C8,$E8,$04,$E4,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$05,$01	; $8FAD75
	db $09,$07,$10,$0F,$00,$00,$00,$00,$01,$01,$01,$01,$00,$01,$00,$07	; $8FAD85
	db $01,$0E,$00,$1F,$00,$00,$20,$20,$70,$60,$10,$00,$30,$20,$E0,$B8	; $8FAD95
	db $E0,$F8,$64,$FC,$00,$00,$C0,$E0,$90,$F0,$F0,$F0,$D0,$F0,$70,$C8	; $8FADA5
	db $F0,$0C,$60,$9C,$01,$01,$02,$02,$06,$05,$0C,$0B,$32,$30,$13,$03	; $8FADB5
	db $34,$00,$19,$04,$00,$01,$04,$07,$08,$0F,$10,$1F,$0C,$3F,$1C,$3F	; $8FADC5
	db $1B,$3F,$29,$1F,$DF,$9E,$87,$66,$06,$F3,$0E,$FF,$16,$E6,$7C,$18	; $8FADD5
	db $F0,$70,$20,$EC,$01,$FF,$19,$FF,$1F,$EC,$0F,$F0,$06,$F8,$04,$FC	; $8FADE5
	db $80,$FC,$00,$3C,$0C,$79,$0C,$71,$C0,$FA,$1F,$1C,$08,$0B,$18,$18	; $8FADF5
	db $00,$0F,$10,$1F,$06,$09,$0E,$01,$C4,$C3,$1C,$1F,$0C,$0F,$1F,$1F	; $8FAE05
	db $00,$00,$10,$10,$80,$03,$80,$01,$00,$00,$00,$00,$00,$00,$40,$C0	; $8FAE15
	db $3A,$3A,$15,$D5,$C0,$00,$C0,$00,$C0,$C0,$80,$80,$00,$80,$40,$C0	; $8FAE25
	db $3A,$3A,$15,$15,$00,$00,$00,$00,$00,$00,$00,$01,$04,$03,$04,$03	; $8FAE35
	db $02,$01,$05,$00,$00,$00,$00,$00,$00,$00,$00,$03,$08,$0F,$18,$1F	; $8FAE45
	db $3C,$3F,$7E,$7F,$10,$10,$B8,$B0,$F8,$F0,$38,$30,$30,$98,$70,$F8	; $8FAE55
	db $30,$F0,$B8,$20,$60,$70,$48,$F8,$08,$F8,$C8,$F8,$F8,$60,$78,$80	; $8FAE65
	db $30,$C0,$18,$F8,$18,$32,$1C,$71,$0C,$71,$00,$3A,$DB,$DC,$0C,$0F	; $8FAE75
	db $01,$01,$31,$3F,$0C,$13,$0E,$11,$0E,$01,$04,$03,$D8,$DF,$08,$0F	; $8FAE85
	db $0E,$0F,$31,$31,$01,$01,$01,$01,$02,$02,$C8,$C8,$10,$10,$00,$00	; $8FAE95
	db $C0,$C0,$A0,$A0,$C1,$01,$41,$81,$42,$82,$08,$C8,$90,$90,$00,$80	; $8FAEA5
	db $C0,$C0,$A0,$A0,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$0E,$01	; $8FAEB5
	db $05,$00,$18,$06,$00,$00,$00,$00,$00,$00,$02,$03,$06,$07,$0C,$0F	; $8FAEC5
	db $12,$1F,$19,$1F,$08,$08,$1C,$18,$7C,$78,$3C,$B8,$38,$AC,$38,$FC	; $8FAED5
	db $98,$78,$D8,$10,$30,$38,$64,$7C,$04,$7C,$44,$FC,$5C,$F0,$3C,$C0	; $8FAEE5
	db $18,$E0,$88,$F8,$02,$01,$06,$05,$07,$06,$17,$16,$03,$03,$3B,$1B	; $8FAEF5
	db $1B,$1B,$1F,$0F,$04,$07,$00,$07,$08,$0F,$08,$1F,$1C,$1F,$04,$3F	; $8FAF05
	db $04,$3F,$00,$3F,$C4,$44,$FC,$3C,$78,$B8,$30,$F8,$80,$70,$80,$70	; $8FAF15
	db $E0,$80,$F0,$70,$B8,$FC,$C0,$FC,$48,$F0,$38,$C0,$00,$F0,$00,$F0	; $8FAF25
	db $00,$F0,$80,$F0,$B2,$B3,$DD,$DF,$21,$2F,$10,$1F,$28,$2F,$06,$05	; $8FAF35
	db $03,$02,$00,$00,$B4,$B7,$D8,$DD,$20,$21,$10,$10,$28,$28,$04,$04	; $8FAF45
	db $02,$02,$00,$00,$00,$82,$80,$81,$00,$00,$40,$C0,$00,$C0,$20,$E0	; $8FAF55
	db $F0,$70,$F0,$F0,$02,$C2,$01,$81,$00,$00,$40,$40,$00,$00,$20,$20	; $8FAF65
	db $70,$70,$F0,$F0,$0C,$03,$03,$40,$1C,$30,$0F,$0B,$1F,$1F,$60,$3F	; $8FAF75
	db $A0,$1E,$C0,$9E,$30,$3F,$1C,$7F,$0F,$7F,$74,$7F,$60,$7F,$00,$E0	; $8FAF85
	db $C0,$21,$63,$12,$10,$C0,$1A,$12,$3A,$32,$F2,$EC,$F0,$C2,$F4,$94	; $8FAF95
	db $64,$24,$08,$78,$0C,$FC,$2C,$FE,$C8,$FE,$10,$FE,$30,$FE,$68,$FE	; $8FAFA5
	db $58,$FC,$80,$08,$2B,$10,$2F,$10,$34,$2B,$50,$7E,$EC,$F1,$F0,$C0	; $8FAFB5
	db $01,$F0,$3A,$FB,$2B,$1F,$2F,$1F,$14,$28,$00,$7F,$0E,$F9,$37,$F0	; $8FAFC5
	db $00,$01,$38,$3B,$A6,$56,$0C,$FE,$00,$8F,$40,$07,$20,$87,$F0,$F3	; $8FAFD5
	db $90,$90,$E0,$20,$E0,$FE,$30,$3C,$48,$08,$76,$86,$30,$C0,$00,$F0	; $8FAFE5
	db $60,$F0,$00,$E0,$70,$7F,$0F,$00,$0F,$0F,$01,$01,$00,$00,$00,$00	; $8FAFF5
	db $00,$00,$00,$00,$70,$70,$00,$00,$0F,$0F,$01,$01,$00,$00,$00,$00	; $8FB005
	db $00,$00,$00,$00,$2E,$EE,$F0,$70,$C8,$C8,$A0,$A0,$00,$00,$00,$00	; $8FB015
	db $00,$00,$00,$00,$2E,$2E,$70,$70,$C8,$C8,$A0,$A0,$00,$00,$00,$00	; $8FB025
	db $00,$00,$00,$00,$0C,$04,$FE,$72,$7A,$24,$38,$53,$8A,$20,$C0,$20	; $8FB035
	db $65,$15,$60,$C8,$FB,$FF,$09,$FF,$18,$FF,$88,$7F,$CC,$3F,$CF,$37	; $8FB045
	db $62,$1F,$32,$4C,$F0,$A0,$C0,$88,$C4,$74,$4C,$EC,$9E,$FE,$98,$FE	; $8FB055
	db $00,$FF,$00,$CF,$50,$F8,$40,$F8,$80,$FC,$00,$5C,$00,$9E,$20,$B8	; $8FB065
	db $10,$10,$0C,$0C,$10,$1F,$00,$0F,$04,$03,$03,$00,$01,$01,$00,$00	; $8FB075
	db $00,$00,$00,$00,$10,$10,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00	; $8FB085
	db $00,$00,$00,$00,$C0,$C0,$60,$E0,$70,$F0,$E8,$68,$C0,$C0,$30,$30	; $8FB095
	db $00,$00,$00,$00,$C0,$C0,$60,$60,$70,$70,$68,$68,$C0,$C0,$30,$30	; $8FB0A5
	db $00,$00,$00,$00,$16,$01,$10,$00,$28,$01,$18,$03,$00,$11,$28,$10	; $8FB0B5
	db $30,$08,$10,$04,$18,$1F,$1E,$1F,$1E,$3E,$00,$3C,$24,$1A,$22,$1D	; $8FB0C5
	db $33,$0C,$19,$06,$10,$00,$30,$91,$60,$BB,$00,$FE,$00,$FC,$40,$1C	; $8FB0D5
	db $00,$00,$00,$00,$F0,$F0,$61,$71,$43,$63,$12,$12,$00,$00,$00,$C0	; $8FB0E5
	db $80,$00,$C0,$00,$00,$00,$00,$03,$00,$03,$00,$03,$00,$06,$00,$06	; $8FB0F5
	db $00,$06,$00,$04,$00,$00,$03,$03,$03,$03,$03,$03,$06,$06,$06,$06	; $8FB105
	db $06,$06,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$08	; $8FB115
	db $4C,$4C,$5C,$58,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$30,$38	; $8FB125
	db $30,$7C,$24,$7C,$06,$01,$0A,$09,$05,$1C,$01,$1C,$02,$1F,$1C,$1C	; $8FB135
	db $04,$07,$00,$00,$0E,$01,$06,$01,$03,$00,$03,$00,$00,$01,$1D,$1D	; $8FB145
	db $04,$07,$03,$03,$00,$00,$40,$00,$00,$80,$00,$80,$00,$00,$00,$00	; $8FB155
	db $80,$00,$40,$80,$60,$80,$60,$80,$20,$C0,$20,$C0,$60,$80,$E0,$E0	; $8FB165
	db $40,$C0,$00,$C0,$0E,$09,$32,$34,$36,$2A,$0C,$04,$0F,$04,$04,$04	; $8FB175
	db $00,$00,$00,$00,$37,$3F,$00,$3E,$00,$3F,$02,$1F,$02,$0F,$03,$07	; $8FB185
	db $07,$07,$07,$07,$08,$08,$1C,$98,$7C,$F8,$3C,$BC,$18,$FC,$88,$78	; $8FB195
	db $C0,$B8,$60,$58,$30,$38,$E4,$FC,$04,$FC,$40,$FC,$0C,$F0,$08,$F0	; $8FB1A5
	db $00,$F8,$80,$F8,$00,$7C,$00,$33,$00,$00,$00,$00,$00,$00,$00,$00	; $8FB1B5
	db $00,$00,$00,$00,$1C,$1C,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00	; $8FB1C5
	db $00,$00,$00,$00,$00,$01,$00,$07,$00,$DE,$00,$3C,$00,$00,$00,$00	; $8FB1D5
	db $00,$00,$00,$00,$01,$01,$07,$07,$DE,$DE,$3C,$3C,$00,$00,$00,$00	; $8FB1E5
	db $00,$00,$00,$00,$07,$00,$1D,$1C,$1E,$1E,$0F,$0F,$0E,$2E,$0C,$1C	; $8FB1F5
	db $00,$00,$20,$68,$0F,$00,$03,$00,$01,$00,$10,$10,$10,$30,$20,$30	; $8FB205
	db $30,$38,$10,$30,$10,$40,$98,$40,$CC,$20,$64,$10,$30,$08,$1A,$04	; $8FB215
	db $02,$04,$16,$16,$98,$60,$9C,$60,$CC,$30,$E6,$18,$72,$0C,$3A,$04	; $8FB225
	db $1A,$04,$08,$1E,$00,$00,$00,$00,$00,$00,$01,$01,$01,$00,$01,$00	; $8FB235
	db $08,$0B,$0C,$0B,$00,$00,$00,$00,$01,$01,$00,$01,$01,$01,$05,$07	; $8FB245
	db $00,$0F,$00,$0F,$00,$00,$20,$20,$30,$20,$B0,$A0,$90,$90,$E0,$70	; $8FB255
	db $F0,$30,$F0,$F0,$00,$00,$C0,$E0,$D0,$F0,$50,$F0,$60,$F0,$90,$E0	; $8FB265
	db $F0,$C0,$E0,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02	; $8FB275
	db $07,$03,$05,$00,$00,$00,$01,$01,$01,$01,$03,$03,$03,$03,$01,$07	; $8FB285
	db $00,$07,$04,$03,$20,$1E,$10,$0E,$0D,$01,$11,$01,$3B,$22,$F3,$CC	; $8FB295
	db $68,$51,$FE,$D7,$C0,$FE,$E0,$FE,$F0,$FF,$FE,$FF,$D1,$FF,$23,$FF	; $8FB2A5
	db $A2,$FE,$28,$FE,$3C,$20,$09,$00,$0B,$08,$59,$18,$00,$40,$50,$F0	; $8FB2B5
	db $00,$F0,$18,$E8,$11,$0E,$7F,$00,$77,$00,$23,$40,$03,$70,$01,$70	; $8FB2C5
	db $00,$00,$08,$08,$38,$B8,$00,$40,$83,$23,$84,$24,$C8,$28,$D0,$20	; $8FB2D5
	db $10,$30,$F0,$70,$00,$F8,$80,$60,$C3,$23,$C4,$34,$C8,$38,$D0,$20	; $8FB2E5
	db $C0,$30,$00,$F0,$00,$03,$00,$03,$06,$05,$03,$02,$09,$01,$08,$00	; $8FB2F5
	db $00,$00,$00,$00,$02,$03,$00,$07,$00,$07,$04,$07,$0E,$0F,$0F,$0F	; $8FB305
	db $0F,$0F,$1F,$1F,$1C,$98,$18,$DC,$18,$F8,$00,$F8,$C0,$3C,$78,$60	; $8FB315
	db $0C,$0C,$24,$04,$64,$FC,$2C,$F0,$18,$E0,$00,$F8,$00,$FC,$80,$FC	; $8FB325
	db $F0,$FC,$F8,$FC,$08,$0C,$00,$0E,$01,$0F,$00,$0F,$08,$07,$06,$01	; $8FB335
	db $03,$03,$01,$01,$0B,$0B,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00	; $8FB345
	db $03,$03,$01,$01,$40,$40,$80,$80,$00,$00,$00,$00,$C0,$C0,$80,$80	; $8FB355
	db $E0,$E0,$90,$90,$C0,$C0,$80,$80,$00,$00,$00,$00,$C0,$C0,$80,$80	; $8FB365
	db $E0,$E0,$90,$90,$00,$00,$00,$00,$00,$00,$00,$00,$28,$08,$17,$07	; $8FB375
	db $0B,$01,$1D,$00,$0F,$0F,$0F,$0F,$1F,$1F,$1F,$1F,$07,$3F,$20,$1F	; $8FB385
	db $10,$0F,$1E,$01,$38,$20,$04,$04,$64,$44,$D8,$D8,$C0,$20,$E8,$B8	; $8FB395
	db $B0,$B0,$00,$00,$C0,$FC,$F8,$FC,$B8,$FC,$00,$F8,$C0,$F8,$40,$F8	; $8FB3A5
	db $00,$F0,$40,$80,$00,$00,$00,$00,$60,$E0,$16,$96,$C0,$C0,$A0,$A0	; $8FB3B5
	db $00,$00,$C0,$C0,$00,$00,$00,$00,$60,$60,$16,$16,$C0,$C0,$A0,$A0	; $8FB3C5
	db $00,$00,$C0,$C0,$00,$00,$00,$00,$00,$00,$80,$80,$30,$30,$05,$05	; $8FB3D5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$30,$30,$05,$05	; $8FB3E5
	db $00,$00,$00,$00,$06,$7E,$0B,$7B,$FC,$7C,$72,$72,$07,$07,$01,$01	; $8FB3F5
	db $00,$00,$00,$00,$06,$06,$0B,$0B,$7C,$7C,$72,$72,$07,$07,$01,$01	; $8FB405
	db $00,$00,$00,$00,$00,$0C,$40,$42,$C4,$CF,$70,$7F,$F1,$FE,$5F,$51	; $8FB415
	db $A7,$A7,$18,$18,$10,$1E,$5C,$5C,$C0,$C4,$70,$70,$F0,$F0,$51,$51	; $8FB425
	db $A7,$A7,$18,$18,$04,$03,$0B,$10,$77,$4B,$67,$40,$72,$62,$BA,$33	; $8FB435
	db $BE,$03,$8A,$00,$08,$1F,$04,$3F,$24,$7F,$3F,$7F,$9D,$FF,$0C,$FE	; $8FB445
	db $8C,$7E,$E3,$1C,$10,$90,$F0,$28,$C0,$B0,$54,$84,$3A,$CA,$1E,$C6	; $8FB455
	db $00,$BF,$00,$0F,$20,$F0,$40,$F8,$40,$F8,$48,$7C,$34,$3E,$58,$5E	; $8FB465
	db $38,$38,$0E,$0E,$07,$00,$05,$04,$06,$06,$0F,$0F,$0F,$0F,$17,$07	; $8FB475
	db $0F,$17,$02,$0A,$07,$00,$03,$00,$01,$00,$00,$00,$00,$00,$08,$18	; $8FB485
	db $00,$1C,$30,$3E,$78,$1F,$C0,$10,$E0,$0C,$B8,$82,$BC,$82,$0D,$03	; $8FB495
	db $03,$03,$04,$04,$00,$F8,$E2,$1C,$F0,$0E,$7D,$02,$3D,$02,$1C,$03	; $8FB4A5
	db $0C,$03,$02,$07,$B3,$D3,$5C,$5C,$12,$12,$05,$05,$0B,$0B,$06,$06	; $8FB4B5
	db $01,$01,$00,$00,$93,$93,$5C,$5C,$12,$12,$05,$05,$0B,$0B,$06,$06	; $8FB4C5
	db $01,$01,$00,$00,$40,$80,$00,$60,$50,$70,$00,$F8,$04,$FC,$1F,$EF	; $8FB4D5
	db $F2,$B2,$68,$68,$00,$E0,$80,$E0,$90,$D0,$00,$00,$04,$04,$0F,$0F	; $8FB4E5
	db $B2,$B2,$68,$68,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FB4F5
	db $01,$00,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01	; $8FB505
	db $02,$03,$06,$07,$00,$00,$18,$18,$0C,$08,$4C,$48,$64,$24,$78,$9C	; $8FB515
	db $38,$C8,$80,$70,$00,$00,$20,$38,$74,$7C,$34,$7C,$58,$7C,$64,$F8	; $8FB525
	db $38,$F0,$00,$F0,$3E,$30,$3B,$38,$1D,$1C,$24,$64,$18,$78,$1C,$6C	; $8FB535
	db $C4,$FC,$62,$7A,$0F,$00,$07,$20,$03,$20,$01,$38,$00,$18,$14,$1C	; $8FB545
	db $C4,$C4,$62,$62,$20,$80,$90,$40,$88,$20,$88,$20,$C8,$18,$10,$10	; $8FB555
	db $60,$60,$30,$08,$20,$C0,$90,$60,$C8,$30,$C8,$30,$E0,$18,$68,$18	; $8FB565
	db $10,$78,$00,$78,$00,$00,$00,$00,$00,$20,$00,$30,$00,$33,$00,$37	; $8FB575
	db $0E,$39,$03,$32,$00,$00,$00,$00,$20,$20,$30,$30,$30,$33,$30,$3F	; $8FB585
	db $30,$3F,$3C,$3F,$30,$30,$18,$10,$98,$90,$C8,$48,$F0,$78,$70,$90	; $8FB595
	db $00,$F0,$C0,$30,$40,$70,$E8,$F8,$68,$F8,$B0,$F8,$88,$F0,$70,$E0	; $8FB5A5
	db $00,$F0,$00,$F8,$30,$20,$37,$30,$3F,$3C,$1C,$1C,$14,$20,$20,$38	; $8FB5B5
	db $38,$78,$18,$70,$1F,$00,$0F,$00,$03,$20,$03,$30,$04,$3C,$00,$3C	; $8FB5C5
	db $00,$38,$08,$18,$00,$40,$00,$40,$80,$40,$C0,$20,$C0,$20,$C0,$A0	; $8FB5D5
	db $08,$28,$58,$78,$80,$60,$90,$60,$90,$60,$C0,$30,$C8,$30,$48,$30	; $8FB5E5
	db $40,$38,$00,$38,$00,$00,$00,$00,$01,$01,$01,$00,$01,$00,$00,$0F	; $8FB5F5
	db $10,$0F,$0C,$03,$00,$00,$01,$01,$00,$01,$01,$01,$01,$01,$00,$1F	; $8FB605
	db $20,$3F,$30,$7F,$20,$20,$10,$00,$90,$80,$D0,$D0,$E0,$70,$C0,$20	; $8FB615
	db $00,$C0,$00,$E0,$C0,$E0,$F0,$F0,$70,$F0,$20,$F0,$90,$E0,$E0,$C0	; $8FB625
	db $00,$C0,$00,$E0,$0D,$04,$0E,$06,$03,$03,$01,$0C,$04,$06,$06,$0E	; $8FB635
	db $06,$0C,$00,$0E,$0B,$08,$09,$08,$00,$0C,$01,$0F,$00,$06,$00,$06	; $8FB645
	db $02,$06,$00,$00,$C0,$10,$C0,$10,$A0,$90,$60,$50,$40,$50,$28,$30	; $8FB655
	db $18,$14,$14,$08,$E0,$18,$E0,$18,$60,$18,$20,$18,$20,$18,$08,$18	; $8FB665
	db $20,$3C,$24,$3C,$00,$60,$00,$F0,$00,$F0,$20,$D0,$68,$1B,$F0,$23	; $8FB675
	db $E4,$45,$8B,$AA,$00,$00,$20,$20,$20,$20,$30,$30,$70,$7F,$C8,$FF	; $8FB685
	db $98,$FF,$14,$FF,$10,$10,$18,$10,$D8,$D0,$C8,$48,$F0,$38,$30,$D0	; $8FB695
	db $00,$F0,$00,$F8,$60,$70,$E8,$F8,$28,$F8,$B0,$F8,$C8,$F0,$30,$E0	; $8FB6A5
	db $00,$F0,$00,$F8,$1F,$20,$31,$01,$38,$48,$35,$45,$78,$80,$70,$80	; $8FB6B5
	db $70,$00,$40,$00,$18,$27,$3E,$40,$37,$40,$38,$40,$78,$80,$70,$80	; $8FB6C5
	db $F0,$80,$30,$F0,$FE,$2C,$D0,$D0,$30,$30,$F0,$F0,$F0,$F0,$C0,$C0	; $8FB6D5
	db $80,$38,$20,$F8,$52,$9E,$20,$00,$C0,$00,$00,$00,$00,$10,$00,$E0	; $8FB6E5
	db $00,$E0,$00,$E0,$00,$00,$00,$00,$00,$00,$20,$20,$23,$23,$37,$17	; $8FB6F5
	db $1F,$1F,$17,$06,$0F,$0F,$1F,$1F,$1F,$1F,$1F,$3F,$1C,$3F,$08,$3F	; $8FB705
	db $00,$3F,$20,$1F,$C0,$B8,$30,$00,$44,$44,$CC,$8C,$F0,$30,$F4,$88	; $8FB715
	db $C4,$37,$74,$24,$00,$F8,$C0,$F8,$B8,$FC,$70,$FC,$C0,$F8,$44,$FC	; $8FB725
	db $C3,$FF,$48,$FC,$3F,$3F,$4B,$4B,$04,$04,$01,$01,$00,$00,$00,$00	; $8FB735
	db $00,$00,$00,$00,$3F,$3F,$4B,$4B,$04,$04,$01,$01,$00,$00,$00,$00	; $8FB745
	db $00,$00,$00,$00,$88,$B8,$78,$7C,$D8,$FC,$C0,$FC,$46,$7E,$2D,$3D	; $8FB755
	db $14,$14,$08,$08,$80,$B8,$40,$78,$C0,$D8,$C0,$C0,$46,$46,$2D,$2D	; $8FB765
	db $14,$14,$08,$08,$00,$10,$00,$00,$20,$20,$10,$10,$39,$09,$0F,$07	; $8FB775
	db $07,$00,$28,$20,$1F,$1F,$1F,$1F,$1F,$3F,$0F,$3F,$06,$3F,$20,$1F	; $8FB785
	db $30,$0F,$1F,$00,$20,$00,$60,$20,$70,$30,$F0,$A0,$E0,$18,$F0,$20	; $8FB795
	db $30,$00,$40,$80,$C8,$F8,$D8,$F8,$C8,$F8,$40,$F8,$C0,$F8,$40,$F8	; $8FB7A5
	db $30,$B0,$40,$80,$00,$78,$C6,$FE,$3A,$2A,$0D,$0D,$16,$16,$02,$02	; $8FB7B5
	db $00,$00,$00,$00,$00,$00,$C6,$C6,$2A,$2A,$0D,$0D,$16,$16,$02,$02	; $8FB7C5
	db $00,$00,$00,$00,$30,$08,$00,$30,$30,$30,$90,$9C,$E0,$FC,$04,$7C	; $8FB7D5
	db $8E,$FE,$79,$59,$40,$78,$00,$70,$40,$70,$E0,$F0,$80,$E0,$04,$04	; $8FB7E5
	db $8E,$8E,$59,$59,$AB,$40,$00,$20,$08,$08,$10,$30,$18,$18,$1D,$05	; $8FB7F5
	db $07,$03,$23,$00,$1C,$FF,$8F,$FF,$C7,$CF,$AF,$BF,$07,$1F,$02,$1F	; $8FB805
	db $20,$1F,$38,$07,$90,$60,$60,$00,$00,$00,$60,$20,$F8,$B8,$C8,$80	; $8FB815
	db $C0,$B8,$30,$30,$00,$F0,$90,$F0,$F8,$F8,$D8,$F8,$40,$F8,$40,$F8	; $8FB825
	db $40,$F8,$00,$F0,$09,$0F,$07,$07,$03,$03,$05,$05,$00,$00,$00,$00	; $8FB835
	db $00,$00,$00,$00,$09,$09,$07,$07,$03,$03,$05,$05,$00,$00,$00,$00	; $8FB845
	db $00,$00,$00,$00,$28,$0C,$D8,$DE,$20,$3E,$72,$7E,$D2,$DE,$3E,$36	; $8FB855
	db $10,$10,$0B,$0B,$10,$38,$C0,$D8,$20,$20,$72,$72,$D2,$D2,$36,$36	; $8FB865
	db $10,$10,$0B,$0B,$1D,$31,$04,$04,$04,$04,$06,$06,$07,$03,$03,$01	; $8FB875
	db $01,$00,$00,$00,$0E,$7F,$03,$07,$03,$07,$01,$07,$00,$07,$00,$07	; $8FB885
	db $04,$03,$07,$00,$C0,$38,$6C,$54,$1C,$0C,$1C,$04,$30,$10,$E0,$D8	; $8FB895
	db $E0,$00,$00,$20,$00,$FC,$80,$FC,$E0,$FC,$F8,$FC,$E0,$F8,$20,$F8	; $8FB8A5
	db $00,$F0,$C0,$30,$20,$C0,$40,$E0,$0F,$EF,$1F,$FF,$14,$F4,$DB,$1B	; $8FB8B5
	db $F4,$F4,$30,$30,$00,$F0,$00,$60,$0F,$0F,$1F,$1F,$14,$14,$1B,$1B	; $8FB8C5
	db $F4,$F4,$30,$30,$4E,$F6,$1C,$EC,$FA,$9A,$60,$60,$D0,$D0,$00,$00	; $8FB8D5
	db $00,$00,$00,$00,$06,$46,$0C,$0C,$9A,$9A,$60,$60,$D0,$D0,$00,$00	; $8FB8E5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FB8F5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FB905
	db $01,$01,$03,$03,$18,$08,$30,$10,$30,$10,$38,$18,$32,$02,$1E,$FE	; $8FB915
	db $8C,$7C,$40,$38,$14,$1C,$2E,$3E,$2E,$3E,$26,$3E,$3E,$3C,$1E,$E0	; $8FB925
	db $0C,$F0,$80,$F8,$00,$10,$18,$00,$1C,$24,$1A,$22,$38,$40,$38,$40	; $8FB935
	db $00,$00,$58,$18,$0E,$31,$1F,$20,$1B,$20,$1C,$20,$3C,$40,$38,$40	; $8FB945
	db $78,$40,$20,$78,$D9,$11,$EA,$EA,$1E,$1E,$3C,$3C,$30,$24,$24,$3C	; $8FB955
	db $48,$5C,$40,$5C,$09,$F9,$12,$02,$E2,$02,$40,$00,$00,$3C,$20,$3C	; $8FB965
	db $40,$48,$40,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01	; $8FB975
	db $00,$03,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01	; $8FB985
	db $00,$03,$00,$03,$00,$00,$60,$20,$C0,$40,$C0,$40,$E0,$60,$C8,$08	; $8FB995
	db $00,$F8,$00,$FD,$00,$00,$50,$70,$B8,$F8,$B8,$F8,$98,$F8,$F8,$F0	; $8FB9A5
	db $00,$F8,$01,$FD,$04,$03,$02,$01,$05,$04,$08,$08,$08,$08,$08,$40	; $8FB9B5
	db $28,$60,$0C,$64,$00,$07,$04,$07,$02,$07,$07,$0F,$07,$0F,$4F,$4F	; $8FB9C5
	db $6F,$6F,$6B,$6F,$04,$F8,$3C,$C4,$CC,$0C,$48,$48,$38,$24,$60,$58	; $8FB9D5
	db $FC,$C4,$F0,$D0,$00,$FC,$00,$FC,$30,$FC,$B0,$FC,$C0,$FC,$A0,$FC	; $8FB9E5
	db $20,$FC,$28,$F8,$23,$00,$00,$20,$2C,$14,$1C,$04,$1C,$0C,$1C,$0C	; $8FB9F5
	db $75,$F1,$03,$E0,$1C,$3F,$0F,$3F,$4B,$7F,$7B,$7F,$73,$7F,$F3,$FF	; $8FBA05
	db $00,$7F,$08,$07,$E8,$08,$4C,$48,$78,$54,$24,$08,$34,$04,$78,$58	; $8FBA15
	db $A0,$80,$C0,$10,$00,$F8,$B0,$FC,$A0,$FC,$E0,$FC,$F0,$FC,$A0,$F8	; $8FBA25
	db $00,$F0,$00,$F0,$07,$0F,$00,$1F,$10,$0F,$3F,$30,$CE,$0E,$10,$C0	; $8FBA35
	db $D0,$30,$10,$00,$07,$08,$00,$3F,$20,$3F,$40,$7F,$31,$FF,$1F,$FF	; $8FBA45
	db $0F,$FF,$DF,$FF,$00,$80,$00,$C0,$20,$A0,$E0,$40,$60,$40,$40,$60	; $8FBA55
	db $60,$40,$20,$00,$00,$80,$00,$C0,$00,$E0,$20,$E0,$A0,$E0,$80,$E0	; $8FBA65
	db $A0,$E0,$E0,$E0,$1A,$1A,$1F,$0F,$0F,$40,$60,$80,$5F,$9F,$71,$11	; $8FBA75
	db $20,$00,$20,$10,$05,$1F,$00,$3F,$20,$5F,$7F,$80,$60,$80,$E0,$80	; $8FBA85
	db $E0,$A0,$80,$F0,$C0,$C0,$C0,$80,$20,$20,$00,$20,$E0,$D0,$A0,$80	; $8FBA95
	db $C8,$C0,$60,$60,$00,$C0,$00,$E0,$40,$80,$C0,$20,$20,$10,$70,$00	; $8FBAA5
	db $38,$08,$10,$18,$03,$3D,$7F,$43,$FE,$FE,$11,$11,$00,$00,$00,$00	; $8FBAB5
	db $00,$00,$00,$00,$01,$01,$43,$43,$FE,$FE,$11,$11,$00,$00,$00,$00	; $8FBAC5
	db $00,$00,$00,$00,$00,$1E,$02,$3E,$47,$7B,$DE,$EE,$78,$78,$0E,$0E	; $8FBAD5
	db $04,$04,$00,$00,$00,$00,$02,$02,$43,$43,$CE,$CE,$78,$78,$0E,$0E	; $8FBAE5
	db $04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01	; $8FBAF5
	db $21,$01,$17,$07,$07,$07,$07,$07,$0F,$0F,$0F,$0F,$1F,$1F,$1E,$1F	; $8FBB05
	db $1E,$3F,$20,$1F,$00,$3C,$52,$40,$E7,$A4,$E7,$A4,$E9,$A2,$E1,$8C	; $8FBB15
	db $EF,$12,$DF,$8E,$C0,$FC,$A2,$FE,$5B,$FF,$5B,$FF,$51,$FF,$61,$FF	; $8FBB25
	db $E1,$FF,$01,$FF,$30,$40,$00,$30,$35,$B5,$0F,$FF,$0E,$FE,$FD,$1D	; $8FBB35
	db $F8,$F8,$04,$04,$00,$78,$40,$70,$45,$75,$0F,$0F,$0E,$0E,$1D,$1D	; $8FBB45
	db $F8,$F8,$04,$04,$02,$1E,$7F,$77,$D8,$D8,$B0,$B0,$48,$48,$00,$00	; $8FBB55
	db $00,$00,$00,$00,$02,$02,$77,$77,$D8,$D8,$B0,$B0,$48,$48,$00,$00	; $8FBB65
	db $00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$0E	; $8FBB75
	db $0B,$03,$07,$11,$06,$07,$07,$07,$0F,$0F,$0F,$0F,$0F,$1F,$01,$1F	; $8FBB85
	db $10,$0F,$00,$1F,$C0,$3E,$3A,$02,$1E,$1E,$66,$66,$34,$30,$60,$7E	; $8FBB95
	db $EC,$E4,$FD,$D9,$02,$FE,$C0,$FE,$E0,$FE,$98,$FE,$C8,$FE,$80,$FE	; $8FBBA5
	db $00,$FC,$25,$FD,$17,$30,$04,$18,$18,$10,$0A,$12,$1D,$21,$1D,$01	; $8FBBB5
	db $12,$12,$2E,$0E,$30,$3F,$1F,$18,$1F,$10,$0D,$10,$1E,$20,$3E,$00	; $8FBBC5
	db $2C,$30,$12,$3E,$80,$10,$60,$10,$00,$10,$60,$50,$C0,$C8,$68,$68	; $8FBBD5
	db $30,$38,$08,$1E,$00,$F0,$E0,$18,$E0,$18,$A0,$18,$30,$08,$10,$08	; $8FBBE5
	db $40,$78,$00,$38,$0F,$C0,$09,$10,$0F,$10,$0C,$10,$1F,$23,$04,$20	; $8FBBF5
	db $00,$00,$10,$00,$0F,$10,$0F,$10,$0F,$10,$0F,$30,$1C,$20,$1E,$20	; $8FBC05
	db $3C,$30,$0C,$3C,$E0,$10,$C0,$08,$60,$68,$F0,$F0,$60,$64,$30,$30	; $8FBC15
	db $00,$00,$08,$07,$E0,$18,$F0,$08,$90,$0C,$08,$04,$18,$04,$0C,$00	; $8FBC25
	db $18,$1C,$00,$1C,$D8,$C8,$0F,$0F,$07,$20,$00,$20,$3C,$40,$1F,$5F	; $8FBC35
	db $34,$44,$08,$00,$17,$DF,$00,$1F,$10,$2F,$1F,$20,$3F,$40,$20,$40	; $8FBC45
	db $38,$40,$78,$48,$40,$40,$80,$80,$A0,$20,$20,$20,$40,$00,$E0,$80	; $8FBC55
	db $A0,$80,$40,$40,$80,$C0,$00,$C0,$40,$80,$C0,$00,$F0,$00,$70,$00	; $8FBC65
	db $78,$00,$38,$00,$00,$60,$00,$80,$20,$F0,$80,$70,$CE,$FE,$37,$37	; $8FBC75
	db $0F,$0F,$00,$00,$10,$70,$70,$70,$00,$20,$00,$00,$CE,$CE,$37,$37	; $8FBC85
	db $0F,$0F,$00,$00,$10,$0C,$0C,$1E,$04,$06,$00,$0E,$BF,$BD,$67,$67	; $8FBC95
	db $D8,$D8,$24,$24,$20,$3C,$00,$3C,$18,$1C,$00,$00,$BD,$BD,$67,$67	; $8FBCA5
	db $D8,$D8,$24,$24,$00,$00,$00,$00,$00,$00,$00,$03,$00,$EC,$88,$F8	; $8FBCB5
	db $3C,$3C,$03,$03,$00,$00,$00,$00,$00,$00,$03,$03,$EC,$EC,$F8,$F8	; $8FBCC5
	db $3C,$3C,$03,$03,$00,$00,$00,$00,$00,$00,$00,$03,$02,$03,$01,$01	; $8FBCD5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$01,$01	; $8FBCE5
	db $00,$00,$00,$00,$00,$00,$00,$30,$00,$70,$00,$E0,$00,$C0,$00,$80	; $8FBCF5
	db $00,$00,$00,$00,$00,$00,$30,$30,$70,$70,$E0,$E0,$C0,$C0,$80,$80	; $8FBD05
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$0A	; $8FBD15
	db $30,$30,$C0,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$0A	; $8FBD25
	db $30,$30,$C0,$C0,$01,$01,$02,$02,$03,$07,$00,$0F,$00,$B0,$00,$C0	; $8FBD35
	db $00,$00,$00,$00,$00,$01,$01,$03,$00,$03,$08,$08,$B0,$B0,$C0,$C0	; $8FBD45
	db $00,$00,$00,$00,$00,$00,$00,$00,$30,$20,$18,$18,$08,$08,$18,$1C	; $8FBD55
	db $B8,$36,$79,$4E,$00,$00,$00,$00,$50,$70,$E0,$F8,$F0,$F8,$E0,$FE	; $8FBD65
	db $C8,$FF,$38,$77,$00,$00,$00,$01,$00,$01,$00,$01,$00,$21,$00,$32	; $8FBD75
	db $00,$1E,$00,$0C,$00,$00,$00,$00,$00,$00,$01,$01,$21,$21,$32,$32	; $8FBD85
	db $1E,$1E,$0C,$0C,$FD,$FD,$28,$28,$58,$D8,$60,$E0,$50,$D0,$A0,$20	; $8FBD95
	db $C0,$C0,$20,$20,$FD,$FD,$28,$28,$58,$58,$60,$60,$50,$50,$20,$20	; $8FBDA5
	db $C0,$C0,$20,$20,$0D,$0F,$02,$0F,$02,$03,$00,$1F,$00,$3F,$1F,$00	; $8FBDB5
	db $0F,$0F,$00,$00,$01,$0F,$00,$0E,$0C,$0E,$00,$00,$00,$00,$00,$00	; $8FBDC5
	db $0F,$0F,$00,$00,$00,$00,$00,$00,$30,$20,$18,$18,$08,$08,$18,$18	; $8FBDD5
	db $BE,$32,$77,$4B,$00,$00,$00,$00,$50,$70,$E0,$F8,$F0,$F8,$E0,$FC	; $8FBDE5
	db $C8,$FE,$30,$7F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$60,$00,$60	; $8FBDF5
	db $00,$60,$00,$60,$00,$00,$00,$00,$00,$00,$00,$00,$60,$60,$60,$60	; $8FBE05
	db $60,$60,$60,$60,$2C,$CC,$44,$84,$B6,$16,$F2,$92,$93,$52,$D5,$B4	; $8FBE15
	db $3A,$18,$6C,$20,$10,$FC,$38,$FC,$68,$FE,$2C,$FE,$0C,$FF,$08,$FF	; $8FBE25
	db $E0,$FF,$C1,$FE,$00,$01,$00,$00,$00,$00,$00,$00,$00,$F0,$01,$79	; $8FBE35
	db $00,$7C,$02,$3E,$00,$01,$00,$01,$01,$01,$00,$00,$C0,$C1,$66,$67	; $8FBE45
	db $03,$03,$01,$03,$00,$06,$00,$06,$00,$02,$00,$01,$00,$00,$00,$00	; $8FBE55
	db $00,$00,$00,$00,$06,$06,$06,$06,$02,$02,$01,$01,$00,$00,$00,$00	; $8FBE65
	db $00,$00,$00,$00,$10,$70,$38,$00,$F8,$80,$FC,$04,$F6,$16,$79,$39	; $8FBE75
	db $04,$04,$00,$00,$00,$F0,$78,$78,$F8,$F8,$E4,$E4,$D6,$D6,$39,$39	; $8FBE85
	db $04,$04,$00,$00,$FE,$82,$7E,$7E,$3E,$3E,$05,$05,$00,$00,$01,$01	; $8FBE95
	db $00,$00,$00,$00,$82,$82,$7E,$7E,$3E,$3E,$05,$05,$00,$00,$01,$01	; $8FBEA5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02	; $8FBEB5
	db $00,$00,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02	; $8FBEC5
	db $00,$00,$02,$02,$00,$06,$00,$02,$00,$03,$00,$01,$00,$00,$00,$00	; $8FBED5
	db $00,$00,$00,$00,$06,$06,$02,$02,$03,$03,$01,$01,$00,$00,$00,$00	; $8FBEE5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$00,$0C	; $8FBEF5
	db $00,$04,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$0C,$0C,$0C	; $8FBF05
	db $04,$04,$06,$06,$84,$88,$A4,$88,$84,$90,$88,$90,$80,$08,$80,$44	; $8FBF15
	db $FB,$03,$EE,$0C,$66,$18,$64,$18,$4C,$30,$4E,$B0,$26,$D8,$B2,$CC	; $8FBF25
	db $F8,$E7,$E0,$EF,$03,$03,$83,$83,$40,$40,$20,$20,$00,$00,$10,$10	; $8FBF35
	db $07,$04,$03,$00,$00,$00,$80,$80,$41,$41,$20,$21,$00,$00,$10,$10	; $8FBF45
	db $07,$07,$03,$03,$00,$01,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00	; $8FBF55
	db $00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00	; $8FBF65
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$14,$01,$01,$00,$00	; $8FBF75
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$14,$01,$01,$00,$00	; $8FBF85
	db $00,$00,$00,$00,$00,$80,$00,$C0,$00,$E0,$00,$63,$00,$3C,$00,$00	; $8FBF95
	db $00,$00,$00,$00,$80,$80,$C0,$C0,$E0,$E0,$63,$63,$3C,$3C,$00,$00	; $8FBFA5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$C0,$C0	; $8FBFB5
	db $60,$40,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$80,$00,$C0	; $8FBFC5
	db $A0,$E0,$E0,$E0,$F0,$00,$FC,$1C,$F8,$38,$F4,$F4,$28,$28,$00,$00	; $8FBFD5
	db $00,$00,$00,$00,$E0,$E0,$DC,$DC,$B8,$B8,$F4,$F4,$28,$28,$00,$00	; $8FBFE5
	db $00,$00,$00,$00,$36,$36,$0B,$0A,$05,$04,$00,$00,$00,$00,$00,$00	; $8FBFF5
	db $00,$00,$00,$00,$36,$36,$0B,$0B,$05,$05,$00,$00,$00,$00,$00,$00	; $8FC005
	db $00,$00,$00,$00,$E4,$68,$60,$08,$01,$65,$AB,$03,$E7,$06,$E6,$01	; $8FC015
	db $F0,$12,$E9,$E9,$06,$F8,$06,$78,$12,$6D,$F8,$E7,$F8,$FF,$E8,$EF	; $8FC025
	db $11,$13,$E9,$E9,$00,$00,$00,$00,$00,$00,$00,$00,$41,$40,$33,$30	; $8FC035
	db $07,$04,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$41,$41,$33,$33	; $8FC045
	db $04,$04,$03,$03,$C0,$C0,$C0,$C0,$20,$20,$00,$00,$00,$00,$00,$00	; $8FC055
	db $00,$00,$00,$00,$C0,$C0,$C0,$C0,$20,$20,$00,$00,$00,$00,$00,$00	; $8FC065
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$0C,$0F,$00,$00	; $8FC075
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$0F,$0F,$00,$00	; $8FC085
	db $00,$00,$00,$00,$00,$08,$00,$10,$00,$20,$00,$E0,$31,$F1,$0C,$0C	; $8FC095
	db $00,$00,$00,$00,$08,$08,$10,$10,$20,$20,$E0,$E0,$F1,$F1,$0C,$0C	; $8FC0A5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01	; $8FC0B5
	db $00,$02,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01	; $8FC0C5
	db $02,$02,$04,$04,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$00,$00	; $8FC0D5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$00,$00	; $8FC0E5
	db $00,$00,$00,$00,$F0,$30,$7C,$7C,$23,$23,$04,$04,$02,$02,$01,$01	; $8FC0F5
	db $00,$00,$00,$00,$30,$30,$7C,$7C,$23,$23,$04,$04,$02,$02,$01,$01	; $8FC105
	db $00,$00,$00,$00,$00,$00,$00,$00,$18,$10,$0C,$08,$0C,$08,$3C,$58	; $8FC115
	db $3C,$64,$3C,$3E,$00,$00,$00,$00,$28,$38,$74,$7C,$74,$7C,$64,$3C	; $8FC125
	db $7C,$1A,$3C,$03,$80,$1E,$00,$44,$60,$E0,$F0,$F0,$58,$F8,$10,$F0	; $8FC135
	db $10,$F0,$E8,$28,$9E,$9E,$04,$C4,$20,$E0,$30,$F0,$18,$58,$10,$10	; $8FC145
	db $10,$10,$28,$28,$19,$19,$11,$10,$08,$09,$05,$05,$00,$01,$00,$03	; $8FC155
	db $00,$07,$00,$07,$1E,$1F,$16,$17,$08,$0B,$04,$05,$00,$00,$00,$00	; $8FC165
	db $00,$00,$00,$00,$B8,$F8,$C4,$FC,$06,$7E,$09,$F9,$34,$D4,$6E,$2E	; $8FC175
	db $50,$50,$30,$30,$88,$F8,$C4,$C4,$06,$06,$09,$09,$14,$14,$2E,$2E	; $8FC185
	db $50,$50,$30,$30,$44,$14,$00,$20,$A0,$40,$00,$40,$00,$40,$80,$40	; $8FC195
	db $60,$00,$40,$20,$C8,$30,$98,$60,$B0,$40,$30,$C0,$20,$C0,$A0,$60	; $8FC1A5
	db $C0,$E0,$10,$F0,$00,$07,$00,$06,$00,$02,$00,$06,$00,$06,$0A,$08	; $8FC1B5
	db $07,$07,$03,$03,$02,$02,$01,$00,$01,$00,$01,$00,$01,$00,$09,$09	; $8FC1C5
	db $07,$07,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC1D5
	db $00,$30,$00,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC1E5
	db $30,$30,$30,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C1	; $8FC1F5
	db $00,$3F,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$C0	; $8FC205
	db $3E,$3E,$00,$00,$00,$18,$00,$18,$00,$1C,$00,$0C,$00,$0E,$00,$07	; $8FC215
	db $00,$00,$00,$00,$18,$18,$18,$18,$1C,$1C,$0C,$0C,$0E,$0E,$07,$07	; $8FC225
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC235
	db $00,$00,$CA,$CA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC245
	db $00,$00,$CA,$CA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$10	; $8FC255
	db $04,$04,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$10	; $8FC265
	db $04,$04,$01,$01,$00,$00,$00,$00,$80,$80,$C0,$C0,$30,$30,$00,$00	; $8FC275
	db $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$C0,$C0,$30,$30,$00,$00	; $8FC285
	db $00,$00,$00,$00,$7F,$7B,$02,$02,$01,$01,$00,$00,$00,$00,$00,$00	; $8FC295
	db $00,$00,$00,$00,$7B,$7B,$02,$02,$01,$01,$00,$00,$00,$00,$00,$00	; $8FC2A5
	db $00,$00,$00,$00,$E0,$20,$18,$04,$20,$16,$00,$0E,$00,$0E,$80,$8E	; $8FC2B5
	db $21,$2F,$90,$9E,$D8,$1C,$60,$3C,$08,$38,$00,$00,$00,$00,$80,$80	; $8FC2C5
	db $21,$21,$90,$90,$00,$00,$00,$00,$80,$80,$00,$80,$00,$C0,$00,$40	; $8FC2D5
	db $08,$28,$8C,$1C,$80,$80,$00,$80,$00,$00,$40,$80,$20,$C0,$30,$C0	; $8FC2E5
	db $90,$68,$C0,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC2F5
	db $00,$00,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC305
	db $00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$C0	; $8FC315
	db $EC,$E8,$FC,$FA,$00,$00,$00,$00,$00,$00,$00,$00,$78,$78,$3C,$FC	; $8FC325
	db $14,$FC,$04,$FF,$00,$00,$00,$00,$00,$30,$00,$38,$00,$1C,$00,$0F	; $8FC335
	db $00,$06,$00,$00,$00,$00,$00,$00,$30,$30,$38,$38,$1C,$1C,$0F,$0F	; $8FC345
	db $06,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC355
	db $01,$01,$4E,$4E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC365
	db $01,$01,$4E,$4E,$00,$00,$00,$01,$00,$03,$00,$1D,$00,$60,$00,$80	; $8FC375
	db $00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$1C,$1C,$60,$60,$80,$80	; $8FC385
	db $00,$00,$00,$00,$00,$38,$00,$38,$00,$38,$44,$7C,$DE,$CE,$FD,$FD	; $8FC395
	db $08,$08,$04,$04,$00,$00,$00,$00,$00,$00,$44,$44,$CE,$CE,$FD,$FD	; $8FC3A5
	db $08,$08,$04,$04,$00,$00,$80,$00,$00,$80,$00,$80,$30,$70,$80,$00	; $8FC3B5
	db $60,$10,$80,$58,$00,$00,$80,$00,$00,$80,$60,$A0,$00,$F0,$E0,$70	; $8FC3C5
	db $80,$F0,$20,$E0,$00,$80,$00,$80,$C0,$C0,$C0,$C0,$6D,$6D,$52,$52	; $8FC3D5
	db $01,$01,$00,$00,$01,$00,$00,$00,$C0,$C0,$C0,$C0,$6D,$6D,$52,$52	; $8FC3E5
	db $01,$01,$00,$00,$03,$0F,$00,$1F,$00,$1F,$03,$1F,$0D,$0D,$02,$02	; $8FC3F5
	db $38,$38,$80,$80,$00,$03,$00,$00,$00,$00,$03,$03,$0D,$0D,$02,$02	; $8FC405
	db $38,$38,$80,$80,$00,$00,$00,$00,$00,$E0,$00,$E0,$20,$C0,$40,$80	; $8FC415
	db $60,$E0,$F8,$F8,$80,$80,$C0,$C0,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC425
	db $60,$60,$F8,$F8,$01,$05,$02,$0A,$07,$3F,$0C,$3C,$00,$00,$00,$00	; $8FC435
	db $00,$00,$00,$00,$05,$05,$0A,$0A,$3F,$3F,$3C,$3C,$00,$00,$00,$00	; $8FC445
	db $00,$00,$00,$00,$12,$12,$00,$00,$08,$08,$08,$08,$04,$04,$04,$04	; $8FC455
	db $02,$02,$00,$00,$12,$12,$00,$00,$08,$08,$08,$08,$04,$04,$04,$04	; $8FC465
	db $02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$80,$40	; $8FC475
	db $80,$E0,$88,$F0,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$90,$F0	; $8FC485
	db $88,$78,$84,$7C,$00,$00,$00,$00,$00,$00,$18,$18,$1D,$1D,$1F,$1F	; $8FC495
	db $0F,$0A,$07,$0F,$00,$00,$00,$00,$0F,$0F,$07,$1F,$02,$1F,$00,$1F	; $8FC4A5
	db $0F,$05,$0F,$00,$00,$9C,$20,$98,$80,$F8,$80,$FC,$80,$BC,$83,$FF	; $8FC4B5
	db $86,$FE,$7D,$6D,$BC,$BC,$9C,$BC,$FC,$FC,$F0,$F0,$80,$80,$83,$83	; $8FC4C5
	db $86,$86,$6D,$6D,$13,$EF,$0F,$FF,$79,$79,$07,$07,$01,$01,$01,$01	; $8FC4D5
	db $01,$01,$01,$01,$13,$13,$0F,$0F,$79,$79,$07,$07,$01,$01,$01,$01	; $8FC4E5
	db $01,$01,$01,$01,$00,$00,$00,$00,$00,$30,$00,$30,$00,$30,$00,$70	; $8FC4F5
	db $00,$60,$00,$60,$00,$00,$00,$00,$30,$30,$30,$30,$30,$30,$70,$70	; $8FC505
	db $60,$60,$60,$60,$00,$00,$00,$01,$00,$01,$00,$01,$00,$03,$00,$C7	; $8FC515
	db $00,$F8,$00,$C0,$00,$00,$01,$01,$01,$01,$81,$81,$C3,$C3,$07,$07	; $8FC525
	db $78,$78,$00,$00,$00,$08,$00,$10,$00,$20,$00,$40,$00,$C0,$00,$C0	; $8FC535
	db $00,$C0,$00,$C0,$08,$08,$10,$10,$20,$20,$C0,$C0,$40,$40,$40,$40	; $8FC545
	db $00,$00,$00,$00,$00,$18,$00,$1C,$00,$0C,$00,$0C,$00,$0E,$00,$06	; $8FC555
	db $00,$06,$00,$04,$18,$18,$1C,$1C,$0C,$0C,$0C,$0C,$0E,$0E,$06,$06	; $8FC565
	db $06,$06,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC575
	db $00,$00,$00,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC585
	db $00,$00,$18,$18,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$0F,$60,$60	; $8FC595
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$0F,$60,$60	; $8FC5A5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80	; $8FC5B5
	db $23,$23,$0E,$0E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80	; $8FC5C5
	db $23,$23,$0E,$0E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$60	; $8FC5D5
	db $00,$70,$00,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$60,$60	; $8FC5E5
	db $70,$70,$38,$38,$00,$06,$00,$08,$00,$30,$00,$C0,$00,$00,$00,$00	; $8FC5F5
	db $00,$00,$00,$00,$06,$06,$08,$08,$30,$30,$C0,$C0,$00,$00,$00,$00	; $8FC605
	db $00,$00,$00,$00,$00,$1C,$00,$0E,$00,$07,$00,$03,$00,$00,$00,$00	; $8FC615
	db $00,$00,$00,$00,$1C,$1C,$0E,$0E,$07,$07,$03,$03,$00,$00,$00,$00	; $8FC625
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$00,$0F	; $8FC635
	db $00,$0F,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$04	; $8FC645
	db $08,$08,$10,$10,$00,$00,$00,$00,$00,$80,$00,$C0,$10,$F0,$18,$F8	; $8FC655
	db $F0,$F0,$68,$68,$00,$00,$00,$00,$00,$00,$00,$00,$10,$10,$18,$18	; $8FC665
	db $F0,$F0,$68,$68,$34,$34,$6E,$6E,$B1,$B1,$40,$40,$B0,$B0,$00,$00	; $8FC675
	db $00,$00,$00,$00,$34,$34,$6E,$6E,$B1,$B1,$40,$40,$B0,$B0,$00,$00	; $8FC685
	db $00,$00,$00,$00,$00,$1E,$01,$3F,$03,$7F,$07,$7F,$FE,$DE,$7C,$7C	; $8FC695
	db $38,$38,$04,$04,$00,$00,$01,$01,$03,$03,$07,$07,$DE,$DE,$7C,$7C	; $8FC6A5
	db $38,$38,$04,$04,$00,$00,$C0,$00,$60,$00,$50,$90,$48,$88,$48,$88	; $8FC6B5
	db $4C,$8C,$56,$86,$00,$00,$C0,$C0,$60,$E0,$20,$F0,$30,$F8,$34,$FC	; $8FC6C5
	db $30,$FC,$38,$FE,$0F,$2C,$0E,$4E,$06,$45,$86,$05,$6E,$0B,$7C,$1F	; $8FC6D5
	db $38,$0B,$3C,$2D,$13,$3F,$30,$7F,$3A,$FF,$BA,$FF,$76,$7D,$7C,$63	; $8FC6E5
	db $30,$3F,$10,$3F,$00,$00,$02,$02,$00,$00,$02,$02,$00,$00,$00,$00	; $8FC6F5
	db $00,$00,$00,$00,$00,$00,$02,$02,$00,$00,$02,$02,$00,$00,$00,$00	; $8FC705
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18	; $8FC715
	db $00,$1F,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$18	; $8FC725
	db $1F,$1F,$07,$07,$00,$80,$00,$80,$40,$C0,$E0,$E0,$40,$40,$00,$00	; $8FC735
	db $C0,$C0,$00,$00,$00,$00,$00,$00,$40,$40,$E0,$E0,$40,$40,$00,$00	; $8FC745
	db $C0,$C0,$00,$00,$20,$38,$10,$1C,$10,$1C,$0C,$0C,$02,$02,$00,$00	; $8FC755
	db $00,$00,$00,$00,$38,$38,$1C,$1C,$1C,$1C,$0C,$0C,$02,$02,$00,$00	; $8FC765
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$C0,$00,$C0,$00,$C0	; $8FC775
	db $00,$C0,$F0,$B0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC785
	db $00,$00,$B0,$B0,$00,$80,$00,$C0,$20,$E0,$F0,$70,$D0,$D0,$00,$00	; $8FC795
	db $3D,$3D,$00,$00,$00,$00,$00,$00,$20,$20,$70,$70,$D0,$D0,$00,$00	; $8FC7A5
	db $3D,$3D,$00,$00,$00,$00,$00,$00,$00,$03,$00,$07,$00,$0E,$00,$1C	; $8FC7B5
	db $00,$18,$00,$F0,$00,$00,$00,$00,$03,$03,$07,$07,$0E,$0E,$1C,$1C	; $8FC7C5
	db $18,$18,$F0,$F0,$00,$00,$80,$80,$80,$80,$C0,$C0,$80,$E0,$00,$F0	; $8FC7D5
	db $00,$FC,$00,$73,$00,$00,$00,$80,$00,$80,$00,$C0,$00,$80,$00,$00	; $8FC7E5
	db $DC,$DC,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC7F5
	db $00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FC805
	db $00,$00,$03,$03,$00,$08,$00,$10,$00,$20,$00,$40,$00,$C0,$00,$C0	; $8FC815
	db $00,$C0,$00,$80,$08,$08,$10,$10,$20,$20,$40,$40,$80,$80,$00,$00	; $8FC825
	db $00,$00,$00,$00,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03	; $8FC835
	db $00,$02,$00,$04,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03	; $8FC845
	db $02,$02,$04,$04,$00,$00,$80,$80,$C0,$C0,$00,$00,$00,$00,$00,$00	; $8FC855
	db $00,$00,$00,$00,$00,$00,$80,$80,$C0,$C0,$00,$00,$00,$00,$00,$00	; $8FC865
	db $00,$00,$00,$00,$00,$40,$00,$40,$00,$80,$00,$80,$00,$C0,$00,$C0	; $8FC875
	db $00,$C0,$00,$80,$40,$40,$40,$40,$80,$80,$80,$80,$80,$80,$00,$00	; $8FC885
	db $00,$00,$00,$00,$00,$40,$00,$E0,$00,$60,$00,$60,$00,$70,$00,$30	; $8FC895
	db $00,$30,$00,$20,$40,$40,$E0,$E0,$60,$60,$60,$60,$70,$70,$30,$30	; $8FC8A5
	db $30,$30,$20,$20,$02,$03,$04,$04,$02,$0E,$00,$0F,$08,$07,$01,$07	; $8FC8B5
	db $04,$03,$06,$05,$00,$03,$03,$07,$01,$03,$00,$00,$00,$00,$01,$01	; $8FC8C5
	db $00,$00,$04,$04,$00,$00,$00,$01,$00,$01,$00,$8F,$00,$F0,$00,$C0	; $8FC8D5
	db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$8E,$8E,$F0,$F0,$C0,$C0	; $8FC8E5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$00,$3F,$00,$07,$00,$00	; $8FC8F5
	db $00,$00,$00,$00,$00,$00,$00,$00,$38,$38,$3F,$3F,$07,$07,$00,$00	; $8FC905
	db $00,$00,$00,$00,$1E,$7E,$09,$79,$07,$7F,$02,$3E,$01,$3D,$1E,$16	; $8FC915
	db $03,$03,$00,$00,$06,$1E,$09,$09,$07,$07,$02,$02,$01,$01,$16,$16	; $8FC925
	db $03,$03,$00,$00,$00,$00,$00,$00,$12,$12,$2C,$2C,$40,$40,$00,$00	; $8FC935
	db $00,$00,$00,$00,$00,$00,$00,$00,$12,$12,$2C,$2C,$40,$40,$00,$00	; $8FC945
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$15,$00,$00	; $8FC955
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$15,$00,$00	; $8FC965
	db $00,$00,$00,$00,$80,$E0,$00,$F0,$08,$F8,$F0,$90,$78,$78,$B4,$B4	; $8FC975
	db $50,$50,$F0,$F0,$00,$80,$00,$00,$08,$08,$90,$90,$78,$78,$B4,$B4	; $8FC985
	db $50,$50,$F0,$F0,$1C,$21,$1C,$21,$18,$20,$11,$03,$3E,$3A,$3F,$1F	; $8FC995
	db $16,$26,$25,$3D,$5E,$20,$1E,$20,$1E,$20,$3D,$01,$04,$3E,$01,$3F	; $8FC9A5
	db $02,$3E,$45,$7D,$00,$00,$02,$02,$08,$08,$20,$20,$00,$00,$00,$00	; $8FC9B5
	db $00,$00,$00,$00,$00,$00,$02,$02,$08,$08,$20,$20,$00,$00,$00,$00	; $8FC9C5
	db $00,$00,$00,$00,$30,$F0,$30,$F0,$30,$F0,$E0,$60,$D8,$D8,$20,$20	; $8FC9D5
	db $20,$20,$40,$40,$30,$30,$30,$30,$30,$30,$60,$60,$D8,$D8,$20,$20	; $8FC9E5
	db $20,$20,$40,$40,$00,$03,$00,$03,$00,$03,$01,$03,$00,$06,$00,$3E	; $8FC9F5
	db $00,$FC,$00,$E0,$02,$02,$02,$02,$02,$02,$03,$03,$06,$06,$3E,$3E	; $8FCA05
	db $FC,$FC,$E0,$E0,$00,$DC,$7C,$F0,$CE,$4E,$D1,$D1,$C0,$C0,$E0,$E0	; $8FCA15
	db $D0,$D0,$A0,$A0,$00,$00,$70,$70,$8E,$CE,$51,$D1,$40,$C0,$E0,$E0	; $8FCA25
	db $D0,$D0,$A0,$A0,$00,$07,$00,$03,$05,$07,$05,$0B,$00,$06,$02,$07	; $8FCA35
	db $03,$0F,$01,$0F,$09,$05,$06,$02,$02,$07,$02,$0F,$0C,$0F,$0C,$0F	; $8FCA45
	db $0D,$0F,$09,$09,$00,$80,$00,$80,$00,$7F,$80,$BF,$7E,$7E,$00,$00	; $8FCA55
	db $00,$00,$00,$00,$80,$80,$80,$80,$7F,$7F,$BF,$BF,$7E,$7E,$00,$00	; $8FCA65
	db $00,$00,$00,$00,$00,$00,$10,$10,$0E,$0E,$01,$01,$00,$00,$00,$00	; $8FCA75
	db $00,$00,$00,$00,$00,$00,$10,$10,$0E,$0E,$01,$01,$00,$00,$00,$00	; $8FCA85
	db $00,$00,$00,$00,$FD,$DD,$3E,$3E,$16,$16,$09,$09,$00,$00,$00,$00	; $8FCA95
	db $00,$00,$00,$00,$DD,$DD,$3E,$3E,$16,$16,$09,$09,$00,$00,$00,$00	; $8FCAA5
	db $00,$00,$00,$00,$41,$7D,$82,$BE,$43,$7F,$E0,$FC,$50,$52,$80,$81	; $8FCAB5
	db $00,$00,$10,$10,$51,$51,$92,$92,$4B,$4B,$E4,$E4,$52,$52,$81,$81	; $8FCAC5
	db $00,$00,$10,$10,$00,$00,$58,$18,$30,$50,$40,$60,$73,$03,$79,$09	; $8FCAD5
	db $FA,$8A,$FB,$8B,$7C,$60,$20,$78,$00,$70,$00,$70,$73,$73,$79,$79	; $8FCAE5
	db $FA,$FA,$FB,$FB,$00,$20,$00,$60,$00,$60,$00,$C0,$00,$C0,$00,$80	; $8FCAF5
	db $00,$00,$00,$00,$20,$20,$60,$60,$60,$60,$C0,$C0,$C0,$C0,$80,$80	; $8FCB05
	db $00,$00,$00,$00,$00,$1C,$00,$18,$00,$10,$00,$10,$00,$10,$00,$10	; $8FCB15
	db $00,$38,$00,$78,$1C,$1C,$18,$18,$10,$10,$10,$10,$10,$10,$10,$10	; $8FCB25
	db $10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FCB35
	db $00,$06,$00,$0E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FCB45
	db $06,$06,$0E,$0E,$42,$3A,$64,$5C,$3A,$3A,$14,$14,$02,$02,$00,$00	; $8FCB55
	db $00,$00,$00,$00,$02,$02,$44,$44,$3A,$3A,$14,$14,$02,$02,$00,$00	; $8FCB65
	db $00,$00,$00,$00,$80,$80,$40,$40,$10,$10,$08,$08,$06,$06,$01,$01	; $8FCB75
	db $00,$00,$00,$00,$80,$80,$40,$40,$10,$10,$08,$08,$06,$06,$01,$01	; $8FCB85
	db $00,$00,$00,$00,$00,$00,$00,$C0,$00,$F0,$00,$3E,$00,$0E,$00,$00	; $8FCB95
	db $00,$00,$00,$00,$00,$00,$C0,$C0,$F0,$F0,$3E,$3E,$0E,$0E,$00,$00	; $8FCBA5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$03,$03,$03,$06,$00,$0F	; $8FCBB5
	db $00,$0F,$3F,$3F,$00,$00,$00,$00,$00,$01,$00,$03,$01,$03,$00,$00	; $8FCBC5
	db $00,$00,$3F,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FCBD5
	db $02,$02,$17,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FCBE5
	db $0C,$0E,$09,$1F,$00,$00,$00,$1C,$00,$FC,$00,$E0,$00,$00,$00,$00	; $8FCBF5
	db $00,$00,$80,$80,$00,$00,$1C,$1C,$FC,$FC,$E0,$E0,$00,$00,$00,$00	; $8FCC05
	db $00,$00,$80,$80,$00,$04,$00,$03,$00,$00,$00,$00,$00,$00,$20,$20	; $8FCC15
	db $05,$05,$00,$00,$04,$04,$03,$03,$00,$00,$00,$00,$00,$00,$20,$20	; $8FCC25
	db $05,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$80,$00,$C0	; $8FCC35
	db $00,$30,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$40	; $8FCC45
	db $30,$30,$08,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03	; $8FCC55
	db $04,$07,$0C,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FCC65
	db $04,$04,$0C,$0C,$00,$C0,$C0,$C0,$80,$80,$20,$E0,$04,$E4,$19,$F9	; $8FCC75
	db $FC,$9C,$36,$36,$00,$C0,$00,$C0,$00,$80,$20,$20,$04,$04,$19,$19	; $8FCC85
	db $9C,$9C,$36,$36,$F1,$F1,$7C,$7E,$B8,$BF,$18,$1F,$04,$07,$0B,$0A	; $8FCC95
	db $01,$01,$00,$00,$F2,$F3,$7D,$7D,$B8,$B8,$18,$18,$04,$04,$0A,$0A	; $8FCCA5
	db $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F0,$00,$F0,$F0,$F0	; $8FCCB5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F0,$F0,$F0,$F0,$F0,$F0	; $8FCCC5
	db $00,$00,$00,$00,$00,$C0,$00,$C0,$00,$20,$00,$10,$00,$0F,$00,$07	; $8FCCD5
	db $1F,$1F,$60,$60,$80,$80,$40,$40,$20,$20,$10,$10,$0F,$0F,$07,$07	; $8FCCE5
	db $1F,$1F,$60,$60,$00,$00,$00,$00,$00,$60,$00,$60,$00,$C0,$00,$C0	; $8FCCF5
	db $00,$80,$00,$80,$00,$00,$00,$00,$60,$60,$60,$60,$C0,$C0,$C0,$C0	; $8FCD05
	db $80,$80,$80,$80,$02,$7E,$01,$7F,$41,$7F,$1F,$1F,$06,$06,$01,$01	; $8FCD15
	db $00,$00,$00,$00,$02,$02,$01,$01,$41,$41,$1F,$1F,$06,$06,$01,$01	; $8FCD25
	db $00,$00,$00,$00,$62,$C8,$E0,$D0,$70,$70,$DC,$C4,$44,$78,$58,$5C	; $8FCD35
	db $0E,$0E,$0D,$4D,$32,$0C,$E4,$D8,$44,$78,$C0,$FC,$40,$7C,$60,$7C	; $8FCD45
	db $76,$7E,$3D,$3D,$64,$44,$E8,$88,$D0,$E0,$E0,$F8,$00,$38,$00,$30	; $8FCD55
	db $40,$00,$40,$00,$B8,$FC,$70,$F8,$00,$F8,$00,$F0,$40,$80,$40,$80	; $8FCD65
	db $40,$80,$40,$80,$00,$00,$10,$10,$1F,$0F,$0E,$00,$1B,$00,$0C,$01	; $8FCD75
	db $04,$01,$0C,$19,$1F,$1F,$0F,$1F,$00,$1F,$10,$0F,$18,$07,$0E,$01	; $8FCD85
	db $0E,$01,$06,$01,$00,$08,$00,$08,$00,$04,$00,$04,$00,$06,$00,$0F	; $8FCD95
	db $00,$13,$06,$05,$08,$08,$08,$08,$04,$04,$04,$04,$00,$00,$00,$00	; $8FCDA5
	db $0E,$0E,$1B,$1F,$00,$00,$00,$0C,$00,$1C,$00,$18,$00,$18,$00,$30	; $8FCDB5
	db $00,$30,$00,$10,$00,$00,$0C,$0C,$1C,$1C,$18,$18,$18,$18,$30,$30	; $8FCDC5
	db $30,$30,$10,$10,$00,$00,$00,$00,$00,$C0,$00,$C0,$00,$80,$00,$00	; $8FCDD5
	db $00,$00,$00,$00,$00,$00,$00,$00,$C0,$C0,$C0,$C0,$80,$80,$00,$00	; $8FCDE5
	db $00,$00,$00,$00,$00,$08,$00,$18,$00,$30,$00,$60,$00,$C0,$00,$80	; $8FCDF5
	db $00,$00,$80,$80,$08,$08,$18,$18,$30,$30,$60,$60,$C0,$C0,$80,$80	; $8FCE05
	db $00,$00,$80,$80,$00,$00,$02,$02,$01,$00,$19,$18,$1D,$0D,$1E,$07	; $8FCE15
	db $4C,$32,$C0,$BC,$00,$00,$0C,$0E,$1F,$1F,$07,$1F,$12,$1F,$19,$1E	; $8FCE25
	db $0E,$7C,$00,$FC,$90,$90,$80,$80,$80,$F0,$1C,$FC,$70,$B0,$CC,$4C	; $8FCE35
	db $80,$80,$40,$40,$10,$90,$00,$80,$00,$80,$1C,$1C,$30,$30,$4C,$4C	; $8FCE45
	db $80,$80,$40,$40,$02,$01,$01,$03,$00,$00,$E5,$E7,$5A,$5B,$23,$22	; $8FCE55
	db $81,$81,$00,$00,$04,$07,$00,$03,$03,$03,$E4,$E5,$5A,$5A,$22,$22	; $8FCE65
	db $81,$81,$00,$00,$28,$2C,$10,$3C,$04,$3C,$7F,$3F,$26,$26,$01,$01	; $8FCE75
	db $00,$00,$00,$00,$10,$38,$00,$10,$04,$04,$3F,$3F,$26,$26,$01,$01	; $8FCE85
	db $00,$00,$00,$00,$80,$F0,$00,$78,$00,$04,$00,$02,$00,$01,$00,$00	; $8FCE95
	db $03,$03,$04,$04,$10,$90,$08,$08,$04,$04,$02,$02,$01,$01,$00,$00	; $8FCEA5
	db $03,$03,$04,$84,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$C0,$40	; $8FCEB5
	db $00,$E0,$80,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$C0	; $8FCEC5
	db $80,$80,$40,$C0,$00,$10,$08,$38,$10,$70,$20,$E0,$40,$C0,$40,$40	; $8FCED5
	db $00,$00,$80,$80,$10,$10,$38,$38,$70,$70,$E0,$E0,$C0,$C0,$40,$40	; $8FCEE5
	db $00,$00,$80,$80,$00,$00,$00,$06,$00,$06,$00,$06,$00,$03,$00,$03	; $8FCEF5
	db $00,$03,$00,$01,$00,$00,$06,$06,$06,$06,$06,$06,$03,$03,$03,$03	; $8FCF05
	db $03,$03,$01,$01,$00,$80,$00,$C0,$00,$20,$00,$1B,$03,$0D,$02,$04	; $8FCF15
	db $02,$00,$01,$00,$80,$80,$C0,$C0,$20,$20,$18,$18,$0E,$0F,$03,$03	; $8FCF25
	db $03,$03,$01,$01,$00,$60,$00,$60,$00,$20,$00,$20,$00,$10,$00,$10	; $8FCF35
	db $00,$08,$00,$08,$60,$60,$60,$60,$20,$20,$20,$20,$10,$10,$10,$10	; $8FCF45
	db $08,$08,$08,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$60,$00,$60	; $8FCF55
	db $00,$60,$00,$60,$00,$00,$00,$00,$00,$00,$00,$00,$60,$60,$60,$60	; $8FCF65
	db $60,$60,$60,$60,$00,$00,$00,$01,$00,$07,$0C,$0B,$07,$04,$03,$03	; $8FCF75
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$08,$04,$04,$03,$03	; $8FCF85
	db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$02,$02,$0C,$0C,$10,$10	; $8FCF95
	db $40,$40,$80,$80,$00,$00,$00,$00,$01,$01,$02,$02,$0C,$0C,$10,$10	; $8FCFA5
	db $40,$40,$80,$80,$00,$30,$00,$E0,$00,$80,$00,$00,$00,$00,$00,$00	; $8FCFB5
	db $00,$00,$00,$00,$30,$30,$E0,$E0,$80,$80,$00,$00,$00,$00,$00,$00	; $8FCFC5
	db $00,$00,$00,$00,$00,$00,$00,$00,$C0,$01,$C0,$27,$20,$DC,$00,$C0	; $8FCFD5
	db $00,$00,$00,$00,$00,$00,$00,$00,$C1,$C1,$C7,$C7,$BC,$BC,$00,$00	; $8FCFE5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$40	; $8FCFF5
	db $80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$40	; $8FD005
	db $80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$70	; $8FD015
	db $00,$C0,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$18,$18,$70,$70	; $8FD025
	db $C0,$C0,$80,$80,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$07,$07	; $8FD035
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$07	; $8FD045
	db $00,$00,$00,$00,$00,$00,$00,$00,$30,$10,$60,$20,$60,$20,$70,$30	; $8FD055
	db $64,$04,$38,$FE,$00,$00,$00,$00,$28,$38,$5C,$7C,$5C,$7C,$4C,$7C	; $8FD065
	db $7C,$78,$38,$C6,$11,$3F,$41,$7F,$E3,$FF,$FD,$F5,$98,$98,$44,$44	; $8FD075
	db $00,$00,$00,$00,$01,$11,$41,$41,$E3,$E3,$F5,$F5,$98,$98,$44,$44	; $8FD085
	db $00,$00,$00,$00,$11,$21,$09,$11,$20,$E8,$1F,$FF,$85,$FD,$47,$7F	; $8FD095
	db $B8,$A8,$1C,$1C,$09,$39,$21,$39,$10,$38,$07,$1F,$85,$85,$47,$47	; $8FD0A5
	db $A8,$A8,$1C,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$03	; $8FD0B5
	db $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03	; $8FD0C5
	db $01,$01,$00,$00,$00,$78,$00,$00,$00,$00,$00,$00,$80,$80,$40,$40	; $8FD0D5
	db $20,$20,$19,$19,$78,$78,$00,$00,$00,$00,$00,$00,$80,$80,$40,$40	; $8FD0E5
	db $20,$20,$19,$19,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$81	; $8FD0F5
	db $00,$C1,$00,$E7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80	; $8FD105
	db $C1,$C1,$E6,$E6,$80,$80,$00,$00,$00,$00,$80,$80,$20,$20,$C0,$E0	; $8FD115
	db $00,$F0,$00,$F0,$40,$C0,$E0,$E0,$E0,$E0,$60,$E0,$E0,$C0,$C0,$20	; $8FD125
	db $00,$F0,$00,$F8,$01,$00,$03,$01,$03,$01,$03,$01,$03,$00,$01,$0F	; $8FD135
	db $00,$0F,$1C,$13,$01,$01,$02,$03,$02,$03,$02,$03,$03,$03,$01,$0E	; $8FD145
	db $00,$1F,$00,$1F,$20,$2B,$11,$1F,$F2,$FE,$3E,$3E,$C1,$C1,$20,$20	; $8FD155
	db $00,$00,$00,$00,$24,$2C,$11,$11,$F2,$F2,$3E,$3E,$C1,$C1,$20,$20	; $8FD165
	db $00,$00,$00,$00,$08,$30,$80,$E8,$02,$7A,$07,$3F,$65,$7D,$FE,$FE	; $8FD175
	db $18,$18,$04,$04,$00,$3C,$90,$98,$02,$02,$07,$07,$65,$65,$FE,$FE	; $8FD185
	db $18,$18,$04,$04,$00,$00,$00,$00,$00,$00,$00,$06,$03,$87,$01,$DF	; $8FD195
	db $01,$E7,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$84,$87,$D8,$D9	; $8FD1A5
	db $E0,$E1,$00,$00,$00,$00,$00,$06,$00,$07,$00,$03,$00,$01,$00,$01	; $8FD1B5
	db $00,$00,$00,$00,$00,$00,$06,$06,$07,$07,$03,$03,$01,$01,$01,$01	; $8FD1C5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$04,$18,$08,$18,$08	; $8FD1D5
	db $1C,$0C,$19,$01,$00,$00,$00,$00,$00,$00,$0A,$0E,$17,$1F,$17,$1F	; $8FD1E5
	db $13,$1F,$1F,$1E,$70,$70,$50,$48,$08,$38,$38,$3C,$00,$3C,$60,$7C	; $8FD1F5
	db $FF,$F7,$6C,$6C,$00,$38,$00,$78,$00,$38,$00,$38,$00,$00,$60,$60	; $8FD205
	db $F7,$F7,$6C,$6C,$00,$00,$10,$08,$08,$38,$18,$38,$00,$38,$46,$7E	; $8FD215
	db $E5,$FD,$3E,$3E,$70,$78,$00,$38,$00,$38,$00,$18,$00,$00,$46,$46	; $8FD225
	db $E5,$E5,$3E,$3E,$00,$30,$00,$30,$00,$18,$00,$18,$00,$08,$00,$04	; $8FD235
	db $00,$02,$00,$01,$30,$30,$30,$30,$18,$18,$18,$18,$08,$08,$04,$04	; $8FD245
	db $02,$02,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD255
	db $00,$30,$00,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD265
	db $30,$30,$30,$30,$00,$00,$00,$00,$00,$00,$70,$30,$C0,$40,$C0,$40	; $8FD275
	db $C0,$40,$E8,$28,$00,$00,$00,$00,$00,$00,$40,$70,$B8,$F8,$B8,$F8	; $8FD285
	db $B8,$F8,$D8,$F0,$70,$9C,$00,$FE,$83,$7D,$7E,$02,$02,$03,$03,$02	; $8FD295
	db $03,$02,$82,$82,$70,$EC,$00,$FE,$00,$FF,$80,$FF,$FC,$FF,$FC,$FF	; $8FD2A5
	db $FD,$FF,$7C,$FE,$00,$C1,$00,$E0,$01,$D9,$02,$84,$09,$04,$01,$02	; $8FD2B5
	db $0F,$0D,$01,$01,$80,$81,$22,$23,$3A,$3F,$71,$7F,$31,$3F,$19,$1F	; $8FD2C5
	db $02,$0F,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD2D5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD2E5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD2F5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD305
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD315
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD325
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD335
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD345
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD355
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD365
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD375
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD385
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD395
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD3A5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD3B5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD3C5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD3D5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD3E5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD3F5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD405
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD415
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD425
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD435
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD445
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD455
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD465
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD475
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD485
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD495
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD4A5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD4B5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD4C5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD4D5
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; $8FD4E5
	db $00,$00,$00,$00	; $8FD4F5
CODE_8FD4F9:		; M=16 X=16
	lda.w $0C9F,x		; $8FD4F9: BD 9F 0C
	ora.w $12E0		; $8FD4FC: 0D E0 12
	bpl CODE_8FD504		; $8FD4FF: 10 03
	jmp.w $D5BE		; $8FD501: 4C BE D5
CODE_8FD504:		; M=16 X=16
	lda.w $0DFF,x		; $8FD504: BD FF 0D
	cmp.w #$0EDA		; $8FD507: C9 DA 0E
	bne CODE_8FD50F		; $8FD50A: D0 03
	jmp.w $D5BE		; $8FD50C: 4C BE D5
CODE_8FD50F:		; M=16 X=16
	lda.b $57		; $8FD50F: A5 57
	pha		; $8FD511: 48
	lda.b $53		; $8FD512: A5 53
	sta.b $5B		; $8FD514: 85 5B
	bit.w #$0008		; $8FD516: 89 08 00
	bne CODE_8FD524		; $8FD519: D0 09
	and.w #$0007		; $8FD51B: 29 07 00
	sta.b $5B		; $8FD51E: 85 5B
	jsl.l $8FE164		; $8FD520: 22 64 E1 8F
CODE_8FD524:		; M=16 X=16
	lda.w $08F5		; $8FD524: AD F5 08
	clc		; $8FD527: 18
	adc.w #$000C		; $8FD528: 69 0C 00
	sta.b $53		; $8FD52B: 85 53
	lda.w $0DBF,x		; $8FD52D: BD BF 0D
	cmp.w #$0002		; $8FD530: C9 02 00
	bne CODE_8FD53D		; $8FD533: D0 08
	lda.b $53		; $8FD535: A5 53
	sec		; $8FD537: 38
	sbc.w #$0018		; $8FD538: E9 18 00
	sta.b $53		; $8FD53B: 85 53
CODE_8FD53D:		; M=16 X=16
	lda.b $53		; $8FD53D: A5 53
	sec		; $8FD53F: 38
	sbc.w $08FF,x		; $8FD540: FD FF 08
	sta.b $53		; $8FD543: 85 53
	lda.w $0ADF,x		; $8FD545: BD DF 0A
	eor.b $53		; $8FD548: 45 53
	sta.b $57		; $8FD54A: 85 57
	bpl CODE_8FD57C		; $8FD54C: 10 2E
	lda.b $53		; $8FD54E: A5 53
	bit.w #$8000		; $8FD550: 89 00 80
	beq CODE_8FD559		; $8FD553: F0 04
	eor.w #$FFFF		; $8FD555: 49 FF FF
	inc a		; $8FD558: 1A
CODE_8FD559:		; M=16 X=16
	sta.b $53		; $8FD559: 85 53
	lda.w $0ADF,x		; $8FD55B: BD DF 0A
	sta.b $7D		; $8FD55E: 85 7D
	lda.b $53		; $8FD560: A5 53
	sta.b $83		; $8FD562: 85 83
	jsl.l $82FCDB		; $8FD564: 22 DB FC 82
	lda.w #$0006		; $8FD568: A9 06 00
	sta.b $7D		; $8FD56B: 85 7D
	jsl.l $80996C		; $8FD56D: 22 6C 99 80
	sta.b $53		; $8FD571: 85 53
	lda.w $0ADF,x		; $8FD573: BD DF 0A
	sec		; $8FD576: 38
	sbc.b $53		; $8FD577: E5 53
	sta.w $0ADF,x		; $8FD579: 9D DF 0A
CODE_8FD57C:		; M=16 X=16
	pla		; $8FD57C: 68
	sta.b $57		; $8FD57D: 85 57
	lda.w $11DF,x		; $8FD57F: BD DF 11
	bne CODE_8FD5BE		; $8FD582: D0 3A
	lda.b $57		; $8FD584: A5 57
	sta.b $5B		; $8FD586: 85 5B
	lda.w #$0F50		; $8FD588: A9 50 0F
	sta.b $57		; $8FD58B: 85 57
	sta.w $11DF,x		; $8FD58D: 9D DF 11
	lda.b $5B		; $8FD590: A5 5B
	bit.w #$0080		; $8FD592: 89 80 00
	beq CODE_8FD59B		; $8FD595: F0 04
	jml.l $80B006		; $8FD597: 5C 06 B0 80
CODE_8FD59B:		; M=16 X=16
	lda.w #$0F82		; $8FD59B: A9 82 0F
	sta.b $57		; $8FD59E: 85 57
	lda.b $5B		; $8FD5A0: A5 5B
	bit.w #$8000		; $8FD5A2: 89 00 80
	beq CODE_8FD5AB		; $8FD5A5: F0 04
	jml.l $80B006		; $8FD5A7: 5C 06 B0 80
CODE_8FD5AB:		; M=16 X=16
	lda.w #$0F0C		; $8FD5AB: A9 0C 0F
	sta.b $57		; $8FD5AE: 85 57
	lda.b $5B		; $8FD5B0: A5 5B
	bit.w #$4000		; $8FD5B2: 89 00 40
	beq CODE_8FD5BB		; $8FD5B5: F0 04
	jml.l $80B006		; $8FD5B7: 5C 06 B0 80
CODE_8FD5BB:		; M=16 X=16
	stz.w $11DF,x		; $8FD5BB: 9E DF 11
CODE_8FD5BE:		; M=16 X=16
	rtl		; $8FD5BE: 6B
CODE_8FD5BF:		; M=16 X=16
	lda.w $117F,x		; $8FD5BF: BD 7F 11
	ora.w $115F,x		; $8FD5C2: 1D 5F 11
	beq CODE_8FD5CA		; $8FD5C5: F0 03
	jmp.w $D68B		; $8FD5C7: 4C 8B D6
CODE_8FD5CA:		; M=16 X=16
	lda.w $0B9F,x		; $8FD5CA: BD 9F 0B
	bne CODE_8FD5D2		; $8FD5CD: D0 03
	jmp.w $D68B		; $8FD5CF: 4C 8B D6
CODE_8FD5D2:		; M=16 X=16
	ldy.b $3B		; $8FD5D2: A4 3B
	lda.w $08FF,x		; $8FD5D4: BD FF 08
	sec		; $8FD5D7: 38
	sbc.w $08FF,y		; $8FD5D8: F9 FF 08
	sta.b $53		; $8FD5DB: 85 53
	lda.w $095F,x		; $8FD5DD: BD 5F 09
	sec		; $8FD5E0: 38
	sbc.w $095F,y		; $8FD5E1: F9 5F 09
	sta.b $57		; $8FD5E4: 85 57
	jsl.l $80AFA8		; $8FD5E6: 22 A8 AF 80
	ldy.b $3B		; $8FD5EA: A4 3B
	lda.b $53		; $8FD5EC: A5 53
	sec		; $8FD5EE: 38
	sbc.w $0DBF,y		; $8FD5EF: F9 BF 0D
	inc a		; $8FD5F2: 1A
	and.w #$0007		; $8FD5F3: 29 07 00
	cmp.w #$0003		; $8FD5F6: C9 03 00
	bcc CODE_8FD5FE		; $8FD5F9: 90 03
	jmp.w $D68B		; $8FD5FB: 4C 8B D6
CODE_8FD5FE:		; M=16 X=16
	lda.w $0EBB		; $8FD5FE: AD BB 0E
	asl a		; $8FD601: 0A
	cmp.b $3F		; $8FD602: C5 3F
	bne CODE_8FD60C		; $8FD604: D0 06
	lda.w #$0008		; $8FD606: A9 08 00
	trb.w $128C		; $8FD609: 1C 8C 12
CODE_8FD60C:		; M=16 X=16
	ldy.b $3B		; $8FD60C: A4 3B
	lda.w $0ADF,x		; $8FD60E: BD DF 0A
	clc		; $8FD611: 18
	adc.w $0ADF,y		; $8FD612: 79 DF 0A
	pha		; $8FD615: 48
	asl a		; $8FD616: 0A
	pla		; $8FD617: 68
	ror a		; $8FD618: 6A
	sta.w $0ADF,x		; $8FD619: 9D DF 0A
	sta.w $0ADF,y		; $8FD61C: 99 DF 0A
	lda.w $0AFF,x		; $8FD61F: BD FF 0A
	clc		; $8FD622: 18
	adc.w $0AFF,y		; $8FD623: 79 FF 0A
	pha		; $8FD626: 48
	asl a		; $8FD627: 0A
	pla		; $8FD628: 68
	ror a		; $8FD629: 6A
	sta.w $0AFF,x		; $8FD62A: 9D FF 0A
	sta.w $0AFF,y		; $8FD62D: 99 FF 0A
	lda.w #$0C60		; $8FD630: A9 60 0C
	sta.b $57		; $8FD633: 85 57
	sta.w $117F,x		; $8FD635: 9D 7F 11
	jsl.l $80B006		; $8FD638: 22 06 B0 80
	ldx.b $3B		; $8FD63C: A6 3B
	ldy.b $3F		; $8FD63E: A4 3F
	stx.b $3F		; $8FD640: 86 3F
	sty.b $3B		; $8FD642: 84 3B
	lda.w #$0C2E		; $8FD644: A9 2E 0C
	sta.b $57		; $8FD647: 85 57
	sta.w $117F,x		; $8FD649: 9D 7F 11
	lda.w $0DFF,x		; $8FD64C: BD FF 0D
	cmp.w #$0BFC		; $8FD64F: C9 FC 0B
	beq CODE_8FD659		; $8FD652: F0 05
	lda.w #$1386		; $8FD654: A9 86 13
	sta.b $57		; $8FD657: 85 57
CODE_8FD659:		; M=16 X=16
	jsl.l $80B006		; $8FD659: 22 06 B0 80
	jsl.l $8FE369		; $8FD65D: 22 69 E3 8F
	lda.b $53		; $8FD661: A5 53
	cmp.w #$0007		; $8FD663: C9 07 00
	bcs CODE_8FD67E		; $8FD666: B0 16
	lda.w #$0024		; $8FD668: A9 24 00
	sta.b $53		; $8FD66B: 85 53
	lda.w $0DFF,x		; $8FD66D: BD FF 0D
	cmp.w #$0C2E		; $8FD670: C9 2E 0C
	beq CODE_8FD67A		; $8FD673: F0 05
	lda.w #$001E		; $8FD675: A9 1E 00
	sta.b $53		; $8FD678: 85 53
CODE_8FD67A:		; M=16 X=16
	jsl.l $80C18F		; $8FD67A: 22 8F C1 80
CODE_8FD67E:		; M=16 X=16
	ldx.b $3B		; $8FD67E: A6 3B
	ldy.b $3F		; $8FD680: A4 3F
	stx.b $3F		; $8FD682: 86 3F
	sty.b $3B		; $8FD684: 84 3B
	lda.w #$FFFF		; $8FD686: A9 FF FF
	sta.b $D8		; $8FD689: 85 D8
CODE_8FD68B:		; M=16 X=16
	rtl		; $8FD68B: 6B
CODE_8FD68C:		; M=16 X=16
	lda.b $53		; $8FD68C: A5 53
	bne CODE_8FD694		; $8FD68E: D0 04
	jml.l $80B92D		; $8FD690: 5C 2D B9 80
CODE_8FD694:		; M=16 X=16
	lda.b [$37]		; $8FD694: A7 37
	clc		; $8FD696: 18
	adc.b $37		; $8FD697: 65 37
	sta.b $37		; $8FD699: 85 37
	dec.b $53		; $8FD69B: C6 53
	bra CODE_8FD68C		; $8FD69D: 80 ED
CODE_8FD69F:		; M=16 X=16
	phx		; $8FD69F: DA
	lda.w $047B		; $8FD6A0: AD 7B 04
	sta.b $73		; $8FD6A3: 85 73
	lda.b $53		; $8FD6A5: A5 53
	sta.b $77		; $8FD6A7: 85 77
	ldx.w #$0000		; $8FD6A9: A2 00 00
	jsl.l $8FD724		; $8FD6AC: 22 24 D7 8F
	dec.b $77		; $8FD6B0: C6 77
	dec.b $77		; $8FD6B2: C6 77
CODE_8FD6B4:		; M=16 X=16
	ldx.w #$0002		; $8FD6B4: A2 02 00
	jsl.l $8FD724		; $8FD6B7: 22 24 D7 8F
	dec.b $77		; $8FD6BB: C6 77
	bne CODE_8FD6B4		; $8FD6BD: D0 F5
	ldx.w #$0004		; $8FD6BF: A2 04 00
	jsl.l $8FD724		; $8FD6C2: 22 24 D7 8F
	dec.b $57		; $8FD6C6: C6 57
	dec.b $57		; $8FD6C8: C6 57
CODE_8FD6CA:		; M=16 X=16
	lda.b $73		; $8FD6CA: A5 73
	sta.w $047B		; $8FD6CC: 8D 7B 04
	inc.w $047D		; $8FD6CF: EE 7D 04
	lda.b $53		; $8FD6D2: A5 53
	dec a		; $8FD6D4: 3A
	dec a		; $8FD6D5: 3A
	sta.b $77		; $8FD6D6: 85 77
	ldx.w #$0006		; $8FD6D8: A2 06 00
	jsl.l $8FD724		; $8FD6DB: 22 24 D7 8F
CODE_8FD6DF:		; M=16 X=16
	ldx.w #$0008		; $8FD6DF: A2 08 00
	jsl.l $8FD724		; $8FD6E2: 22 24 D7 8F
	dec.b $77		; $8FD6E6: C6 77
	bne CODE_8FD6DF		; $8FD6E8: D0 F5
	ldx.w #$000A		; $8FD6EA: A2 0A 00
	jsl.l $8FD724		; $8FD6ED: 22 24 D7 8F
	dec.b $57		; $8FD6F1: C6 57
	bne CODE_8FD6CA		; $8FD6F3: D0 D5
	lda.b $73		; $8FD6F5: A5 73
	sta.w $047B		; $8FD6F7: 8D 7B 04
	inc.w $047D		; $8FD6FA: EE 7D 04
	dec.b $53		; $8FD6FD: C6 53
	dec.b $53		; $8FD6FF: C6 53
	ldx.w #$000C		; $8FD701: A2 0C 00
	jsl.l $8FD724		; $8FD704: 22 24 D7 8F
CODE_8FD708:		; M=16 X=16
	ldx.w #$000E		; $8FD708: A2 0E 00
	jsl.l $8FD724		; $8FD70B: 22 24 D7 8F
	dec.b $53		; $8FD70F: C6 53
	bne CODE_8FD708		; $8FD711: D0 F5
	ldx.w #$0010		; $8FD713: A2 10 00
	jsl.l $8FD724		; $8FD716: 22 24 D7 8F
	lda.b $73		; $8FD71A: A5 73
	sta.w $047B		; $8FD71C: 8D 7B 04
	inc.w $047D		; $8FD71F: EE 7D 04
	plx		; $8FD722: FA
	rtl		; $8FD723: 6B
CODE_8FD724:		; M=16 X=16
	lda.l $88871C,x		; $8FD724: BF 1C 87 88
	clc		; $8FD728: 18
	adc.w $1BDB		; $8FD729: 6D DB 1B
	clc		; $8FD72C: 18
	adc.w $1BCB		; $8FD72D: 6D CB 1B
	pha		; $8FD730: 48
	lda.w $047D		; $8FD731: AD 7D 04
	asl a		; $8FD734: 0A
	asl a		; $8FD735: 0A
	asl a		; $8FD736: 0A
	asl a		; $8FD737: 0A
	asl a		; $8FD738: 0A
	adc.w $047B		; $8FD739: 6D 7B 04
	asl a		; $8FD73C: 0A
	adc.b $D4		; $8FD73D: 65 D4
	tax		; $8FD73F: AA
	pla		; $8FD740: 68
	ora.w $0477		; $8FD741: 0D 77 04
	sta.l $7E6E74,x		; $8FD744: 9F 74 6E 7E
	inc.w $047B		; $8FD748: EE 7B 04
	txa		; $8FD74B: 8A
	lsr a		; $8FD74C: 4A
	cmp.b $D0		; $8FD74D: C5 D0
	bcs CODE_8FD753		; $8FD74F: B0 02
	sta.b $D0		; $8FD751: 85 D0
CODE_8FD753:		; M=16 X=16
	cmp.b $D2		; $8FD753: C5 D2
	bcc CODE_8FD759		; $8FD755: 90 02
	sta.b $D2		; $8FD757: 85 D2
CODE_8FD759:		; M=16 X=16
	rtl		; $8FD759: 6B
	db $BD,$DF,$0E,$89,$08,$00,$D0,$08,$A9,$08,$00,$85,$53,$4C,$DC,$FB	; $8FD75A
	db $6B,$A5,$3B,$A8,$29,$FD,$FF,$D0,$FE,$A9,$83,$00,$85,$75,$B9,$CE	; $8FD76A
	db $13,$85,$73,$A0,$0A,$00,$18,$77,$73,$85,$73,$64,$53,$A7,$73,$EB	; $8FD77A
	db $E6,$53,$0A,$0A,$0A,$0A,$D0,$F8,$6B,$80,$07,$A5,$37,$18,$67,$37	; $8FD78A
	db $85,$37,$C6,$53,$10,$F5,$6B,$0F,$00,$20,$20,$20,$53,$74,$61,$74	; $8FD79A
	db $75,$73,$20,$20,$20,$5D,$00,$00,$00,$00,$0F,$00,$5B,$20,$20,$4F	; $8FD7AA
	db $76,$65,$72,$61,$6C,$6C,$20,$20,$5D,$3A,$1F,$0A,$00,$0F,$00,$5B	; $8FD7BA
	db $20,$20,$45,$6E,$65,$72,$67,$79,$20,$20,$20,$5D,$00,$00,$02,$00	; $8FD7CA
	db $0F,$00,$5B,$20,$20,$41,$67,$69,$6C,$69,$74,$79,$20,$20,$5D,$00	; $8FD7DA
	db $10,$0A,$00,$0F,$00,$5B,$20,$20,$20,$53,$70,$65,$65,$64,$20,$20	; $8FD7EA
	db $20,$5D,$00,$08,$0A,$00,$0F,$00,$5B,$20,$20,$48,$61,$6E,$64,$65	; $8FD7FA
	db $64,$20,$20,$20,$5D,$40,$00,$04,$00,$0F,$00,$5B,$4F,$66,$66,$2E	; $8FD80A
	db $20,$41,$77,$61,$72,$65,$2E,$5D,$00,$04,$0A,$00,$0F,$00,$5B,$44	; $8FD81A
	db $65,$66,$2E,$20,$41,$77,$61,$72,$65,$2E,$5D,$00,$02,$0A,$00,$0F	; $8FD82A
	db $00,$5B,$53,$68,$6F,$74,$20,$50,$6F,$77,$65,$72,$20,$5D,$00,$01	; $8FD83A
	db $0A,$00,$0F,$00,$5B,$53,$68,$6F,$74,$20,$20,$41,$63,$63,$75,$72	; $8FD84A
	db $5D,$10,$00,$0A,$00,$0F,$00,$5B,$50,$61,$73,$73,$20,$20,$41,$63	; $8FD85A
	db $63,$75,$72,$5D,$02,$00,$0A,$00,$0F,$00,$5B,$53,$74,$69,$63,$6B	; $8FD86A
	db $20,$48,$61,$6E,$64,$6C,$5D,$20,$00,$0A,$00,$0F,$00,$5B,$20,$20	; $8FD87A
	db $57,$65,$69,$67,$68,$74,$20,$20,$20,$5D,$00,$20,$06,$00,$0F,$00	; $8FD88A
	db $5B,$20,$45,$6E,$64,$75,$72,$61,$6E,$63,$65,$20,$5D,$08,$00,$0A	; $8FD89A
	db $00,$0F,$00,$5B,$41,$67,$67,$72,$65,$73,$73,$69,$6F,$6E,$20,$5D	; $8FD8AA
	db $01,$00,$0A,$00,$0F,$00,$5B,$20,$43,$68,$65,$63,$6B,$69,$6E,$67	; $8FD8BA
	db $20,$20,$5D,$80,$00,$0A,$00,$0F,$00,$5B,$20,$20,$46,$69,$67,$68	; $8FD8CA
	db $74,$69,$6E,$67,$20,$20,$40,$00,$08,$00,$FF,$FF,$0F,$00,$20,$20	; $8FD8DA
	db $20,$53,$74,$61,$74,$75,$73,$20,$20,$20,$5D,$00,$00,$00,$00,$0F	; $8FD8EA
	db $00,$5B,$20,$20,$4F,$76,$65,$72,$61,$6C,$6C,$20,$20,$5D,$0F,$1B	; $8FD8FA
	db $0A,$00,$0F,$00,$5B,$20,$20,$41,$67,$69,$6C,$69,$74,$79,$20,$20	; $8FD90A
	db $5D,$00,$10,$0A,$00,$0F,$00,$5B,$20,$20,$20,$53,$70,$65,$65,$64	; $8FD91A
	db $20,$20,$20,$5D,$00,$08,$0A,$00,$0F,$00,$5B,$47,$6C,$6F,$76,$65	; $8FD92A
	db $20,$48,$61,$6E,$64,$20,$5D,$40,$00,$04,$00,$0F,$00,$5B,$44,$65	; $8FD93A
	db $66,$2E,$20,$41,$77,$61,$72,$65,$2E,$5D,$00,$02,$0A,$00,$0F,$00	; $8FD94A
	db $5B,$50,$75,$63,$6B,$20,$43,$6F,$6E,$74,$2E,$20,$5D,$00,$01,$0A	; $8FD95A
	db $00,$0F,$00,$5B,$53,$74,$69,$63,$6B,$20,$52,$69,$67,$68,$74,$5D	; $8FD96A
	db $08,$00,$0A,$00,$0F,$00,$5B,$53,$74,$69,$63,$6B,$20,$4C,$65,$66	; $8FD97A
	db $74,$20,$5D,$04,$00,$0A,$00,$0F,$00,$5B,$47,$6C,$6F,$76,$65,$20	; $8FD98A
	db $52,$69,$67,$68,$74,$5D,$02,$00,$0A,$00,$0F,$00,$5B,$47,$6C,$6F	; $8FD99A
	db $76,$65,$20,$4C,$65,$66,$74,$20,$5D,$01,$00,$0A,$00,$0F,$00,$5B	; $8FD9AA
	db $20,$20,$20,$57,$65,$69,$67,$68,$74,$20,$20,$20,$00,$20,$06,$00	; $8FD9BA
	db $FF,$FF,$04,$00,$4C,$44,$04,$00,$52,$44,$04,$00,$4C,$57,$03,$00	; $8FD9CA
	db $43,$04,$00,$52,$57	; $8FD9DA
CODE_8FD9DF:		; M=16 X=16
	stx.b $0A		; $8FD9DF: 86 0A
	ldx.w #$0000		; $8FD9E1: A2 00 00
CODE_8FD9E4:		; M=16 X=16
	lda.b $53,x		; $8FD9E4: B5 53
	pha		; $8FD9E6: 48
	inx		; $8FD9E7: E8
	inx		; $8FD9E8: E8
	cpx.w #$0010		; $8FD9E9: E0 10 00
	bne CODE_8FD9E4		; $8FD9EC: D0 F6
	ldx.b $0A		; $8FD9EE: A6 0A
	stx.b $0A		; $8FD9F0: 86 0A
	ldx.w #$0000		; $8FD9F2: A2 00 00
CODE_8FD9F5:		; M=16 X=16
	lda.b $33,x		; $8FD9F5: B5 33
	pha		; $8FD9F7: 48
	inx		; $8FD9F8: E8
	inx		; $8FD9F9: E8
	cpx.w #$0010		; $8FD9FA: E0 10 00
	bne CODE_8FD9F5		; $8FD9FD: D0 F6
	ldx.b $0A		; $8FD9FF: A6 0A
	ldy.b $3B		; $8FDA01: A4 3B
	ldx.w $13D2,y		; $8FDA03: BE D2 13
	dex		; $8FDA06: CA
	dex		; $8FDA07: CA
CODE_8FDA08:		; M=16 X=16
	inx		; $8FDA08: E8
	inx		; $8FDA09: E8
	lda.w $0B9F,x		; $8FDA0A: BD 9F 0B
	bpl CODE_8FDA08		; $8FDA0D: 10 F9
	lda.b $53		; $8FDA0F: A5 53
	lsr a		; $8FDA11: 4A
	sta.b $5F		; $8FDA12: 85 5F
	ldy.b $3B		; $8FDA14: A4 3B
	lda.w $13EE,y		; $8FDA16: B9 EE 13
	sta.b $57		; $8FDA19: 85 57
	inc a		; $8FDA1B: 1A
	sta.w $13EE,y		; $8FDA1C: 99 EE 13
	lda.w #$0001		; $8FDA1F: A9 01 00
	tsb.w $140A		; $8FDA22: 0C 0A 14
	tsb.w $140C		; $8FDA25: 0C 0C 14
	lda.w #$F820		; $8FDA28: A9 20 F8
	sta.b $33		; $8FDA2B: 85 33
	lda.w #$008F		; $8FDA2D: A9 8F 00
	sta.b $35		; $8FDA30: 85 35
	lda.w $13F2,y		; $8FDA32: B9 F2 13
	bpl CODE_8FDA39		; $8FDA35: 10 02
	inc.b $33		; $8FDA37: E6 33
CODE_8FDA39:		; M=16 X=16
	ldy.b $57		; $8FDA39: A4 57
	lda.b [$33],y		; $8FDA3B: B7 33
	and.w #$00FF		; $8FDA3D: 29 FF 00
	sta.w $0B9F,x		; $8FDA40: 9D 9F 0B
	stx.b $3F		; $8FDA43: 86 3F
	jsl.l $80B138		; $8FDA45: 22 38 B1 80
	jsl.l $80B15D		; $8FDA49: 22 5D B1 80
	lda.w $0EDF,x		; $8FDA4D: BD DF 0E
	ora.w #$1000		; $8FDA50: 09 00 10
	sta.w $0EDF,x		; $8FDA53: 9D DF 0E
	stx.b $0A		; $8FDA56: 86 0A
	ldx.w #$000E		; $8FDA58: A2 0E 00
CODE_8FDA5B:		; M=16 X=16
	pla		; $8FDA5B: 68
	sta.b $33,x		; $8FDA5C: 95 33
	dex		; $8FDA5E: CA
	dex		; $8FDA5F: CA
	bpl CODE_8FDA5B		; $8FDA60: 10 F9
	ldx.b $0A		; $8FDA62: A6 0A
	stx.b $0A		; $8FDA64: 86 0A
	ldx.w #$000E		; $8FDA66: A2 0E 00
CODE_8FDA69:		; M=16 X=16
	pla		; $8FDA69: 68
	sta.b $53,x		; $8FDA6A: 95 53
	dex		; $8FDA6C: CA
	dex		; $8FDA6D: CA
	bpl CODE_8FDA69		; $8FDA6E: 10 F9
	ldx.b $0A		; $8FDA70: A6 0A
	ldx.b $3F		; $8FDA72: A6 3F
	rtl		; $8FDA74: 6B
	db $A9,$FF,$FF,$8D,$F3,$08,$8D,$E9,$08,$9C,$ED,$08,$9C,$EF,$08,$A9	; $8FDA75
	db $00,$00,$85,$33,$A9,$7F,$00,$85,$35,$6B,$BD,$7F,$11,$D0,$5E,$BD	; $8FDA85
	db $DF,$0E,$89,$02,$00,$F0,$26,$29,$FD,$FF,$9D,$DF,$0E,$A9,$5A,$00	; $8FDA95
	db $9D,$9F,$0C,$AD,$54,$01,$10,$06,$A9,$A6,$FF,$9D,$9F,$0C,$AD,$DF	; $8FDAA5
	db $08,$9D,$BF,$0C,$A9,$24,$11,$85,$57,$22,$06,$B0,$80,$BD,$9F,$0C	; $8FDAB5
	db $38,$FD,$FF,$08,$85,$53,$BD,$BF,$0C,$38,$FD,$5F,$09,$85,$57,$22	; $8FDAC5
	db $A8,$AF,$80,$A5,$53,$38,$E9,$07,$00,$F0,$08,$30,$04,$70,$04,$80	; $8FDAD5
	db $0C,$70,$0A,$A5,$53,$85,$5B,$9D,$BF,$0D,$4C,$64,$E1,$6B	; $8FDAE5
CODE_8FDAF3:		; M=16 X=16
	lda.w #$0001		; $8FDAF3: A9 01 00
	sta.b $C7		; $8FDAF6: 85 C7
	jml.l $87D1FE		; $8FDAF8: 5C FE D1 87
CODE_8FDAFC:		; M=16 X=16
	lda.w #$FFFF		; $8FDAFC: A9 FF FF
	sta.b $5B		; $8FDAFF: 85 5B
CODE_8FDB01:		; M=16 X=16
	inc.b $5B		; $8FDB01: E6 5B
	lda.b $33		; $8FDB03: A5 33
	clc		; $8FDB05: 18
	adc.b $5B		; $8FDB06: 65 5B
	tay		; $8FDB08: A8
	sep #$20		; $8FDB09: E2 20
	lda.w $154A,y		; $8FDB0B: B9 4A 15
	sta.w $1549,y		; $8FDB0E: 99 49 15
	rep #$30		; $8FDB11: C2 30
	bit.w #$0080		; $8FDB13: 89 80 00
	beq CODE_8FDB01		; $8FDB16: F0 E9
	dec.b $33		; $8FDB18: C6 33
	rtl		; $8FDB1A: 6B
	db $AD,$8A,$12,$F0,$04,$5C,$5A,$D7,$8F,$22,$27,$85,$80,$BD,$DF,$0E	; $8FDB1B
	db $89,$08,$00,$F0,$03,$4C,$B1,$DB,$89,$02,$00,$F0,$12,$29,$FD,$FF	; $8FDB2B
	db $9D,$DF,$0E,$9E,$5F,$0C,$9E,$7F,$0C,$A9,$08,$00,$9D,$FF,$0C,$BD	; $8FDB3B
	db $5F,$0C,$38,$E5,$6F,$9D,$5F,$0C,$10,$24,$BD,$BF,$0F,$9D,$5F,$0C	; $8FDB4B
	db $AD,$BB,$0E,$30,$19,$38,$E9,$06,$00,$85,$57,$A9,$06,$00,$85,$53	; $8FDB5B
	db $8A,$4A,$38,$E9,$06,$00,$45,$57,$30,$04,$5C,$A7,$B4,$80,$AD,$1B	; $8FDB6B
	db $09,$48,$0A,$68,$6A,$85,$53,$A9,$80,$00,$85,$57,$BD,$3F,$11,$F0	; $8FDB7B
	db $26,$A9,$80,$FF,$85,$57,$A9,$A8,$FF,$38,$ED,$7B,$09,$F0,$08,$30	; $8FDB8B
	db $04,$70,$04,$80,$2D,$70,$2B,$A9,$80,$FF,$18,$6D,$7B,$09,$48,$0A	; $8FDB9B
	db $68,$6A,$85,$57,$80,$1C,$6B,$A9,$58,$00,$38,$ED,$7B,$09,$30,$04	; $8FDBAB
	db $50,$04,$80,$0E,$50,$0C,$A5,$57,$18,$6D,$7B,$09,$48,$0A,$68,$6A	; $8FDBBB
	db $85,$57,$A9,$E6,$84,$85,$33,$A9,$80,$00,$85,$35,$5C,$D0,$FD,$88	; $8FDBCB
CODE_8FDBDB:		; M=16 X=16
	jsl.l $80B90C		; $8FDBDB: 22 0C B9 80
	ora.b $00		; $8FDBDF: 05 00
	sbc.l $A9020B,x		; $8FDBE1: FF 0B 02 A9
	ora.b ($00,s),y		; $8FDBE5: 13 00
	sta.b $53		; $8FDBE7: 85 53
	lda.w #$0009		; $8FDBE9: A9 09 00
	sta.b $57		; $8FDBEC: 85 57
	lda.w $1BE7		; $8FDBEE: AD E7 1B
	sta.b $5B		; $8FDBF1: 85 5B
	jml.l $8D847C		; $8FDBF3: 5C 7C 84 8D
CODE_8FDBF7:		; M=16 X=16
	rtl		; $8FDBF7: 6B
CODE_8FDBF8:		; M=16 X=16
	rtl		; $8FDBF8: 6B
CODE_8FDBF9:		; M=16 X=16
	stz.b $3B		; $8FDBF9: 64 3B
	lda.w #$0002		; $8FDBFB: A9 02 00
	sta.b $37		; $8FDBFE: 85 37
	lda.w $119F,x		; $8FDC00: BD 9F 11
	beq CODE_8FDC0C		; $8FDC03: F0 07
	stz.b $37		; $8FDC05: 64 37
	lda.w #$0002		; $8FDC07: A9 02 00
	sta.b $3B		; $8FDC0A: 85 3B
CODE_8FDC0C:		; M=16 X=16
	rtl		; $8FDC0C: 6B
CODE_8FDC0D:		; M=16 X=16
	jsl.l $82FD6B		; $8FDC0D: 22 6B FD 82
	jsl.l $8FE404		; $8FDC11: 22 04 E4 8F
	jsl.l $8D8120		; $8FDC15: 22 20 81 8D
	sep #$20		; $8FDC19: E2 20
	cli		; $8FDC1B: 58
	lda.w $4210		; $8FDC1C: AD 10 42
	lda.b #$81		; $8FDC1F: A9 81
	sta.w $4200		; $8FDC21: 8D 00 42
	lda.b #$03		; $8FDC24: A9 03
	sta.w $2101		; $8FDC26: 8D 01 21
	lda.b #$01		; $8FDC29: A9 01
	sta.w $2105		; $8FDC2B: 8D 05 21
	lda.b #$00		; $8FDC2E: A9 00
	sta.w $2107		; $8FDC30: 8D 07 21
	lda.b #$04		; $8FDC33: A9 04
	sta.w $2108		; $8FDC35: 8D 08 21
	lda.b #$11		; $8FDC38: A9 11
	sta.w $210B		; $8FDC3A: 8D 0B 21
	lda.b #$03		; $8FDC3D: A9 03
	sta.w $212C		; $8FDC3F: 8D 2C 21
	rep #$30		; $8FDC42: C2 30
	stz.w $13F2		; $8FDC44: 9C F2 13
	stz.w $13F4		; $8FDC47: 9C F4 13
	lda.w #$0025		; $8FDC4A: A9 25 00
	sta.w $1BE7		; $8FDC4D: 8D E7 1B
	inc a		; $8FDC50: 1A
	sta.w $1BE5		; $8FDC51: 8D E5 1B
	clc		; $8FDC54: 18
	adc.w #$0195		; $8FDC55: 69 95 01
	sta.w $1BD7		; $8FDC58: 8D D7 1B
	adc.w #$0064		; $8FDC5B: 69 64 00
	sta.w $1BDB		; $8FDC5E: 8D DB 1B
	adc.w #$0004		; $8FDC61: 69 04 00
	sta.w $1BE3		; $8FDC64: 8D E3 1B
	stz.w $1BCD		; $8FDC67: 9C CD 1B
	stz.w $1BCF		; $8FDC6A: 9C CF 1B
	lda.w $1BE7		; $8FDC6D: AD E7 1B
	ldx.w #$07FE		; $8FDC70: A2 FE 07
CODE_8FDC73:		; M=16 X=16
	sta.l $7E6E74,x		; $8FDC73: 9F 74 6E 7E
	dex		; $8FDC77: CA
	dex		; $8FDC78: CA
	bpl CODE_8FDC73		; $8FDC79: 10 F8
	lda.w #$C3A0		; $8FDC7B: A9 A0 C3
	sta.b $73		; $8FDC7E: 85 73
	lda.w #$0087		; $8FDC80: A9 87 00
	sta.b $75		; $8FDC83: 85 75
	jsl.l $86FA3E		; $8FDC85: 22 3E FA 86
	ldx.w #$03FE		; $8FDC89: A2 FE 03
CODE_8FDC8C:		; M=16 X=16
	lda.l $7F0000,x		; $8FDC8C: BF 00 00 7F
	sta.l $7E7674,x		; $8FDC90: 9F 74 76 7E
	sta.l $7E7A74,x		; $8FDC94: 9F 74 7A 7E
	dex		; $8FDC98: CA
	dex		; $8FDC99: CA
	bpl CODE_8FDC8C		; $8FDC9A: 10 F0
	lda.w #$1000		; $8FDC9C: A9 00 10
	sta.w $2116		; $8FDC9F: 8D 16 21
	ldx.w #$0000		; $8FDCA2: A2 00 00
CODE_8FDCA5:		; M=16 X=16
	lda.l $7F0400,x		; $8FDCA5: BF 00 04 7F
	sta.w $2118		; $8FDCA9: 8D 18 21
	inx		; $8FDCAC: E8
	inx		; $8FDCAD: E8
	cpx.w #$04A0		; $8FDCAE: E0 A0 04
	bne CODE_8FDCA5		; $8FDCB1: D0 F2
	ldx.w #$0010		; $8FDCB3: A2 10 00
CODE_8FDCB6:		; M=16 X=16
	stz.w $2118		; $8FDCB6: 9C 18 21
	dex		; $8FDCB9: CA
	bne CODE_8FDCB6		; $8FDCBA: D0 FA
	lda.w #$9B73		; $8FDCBC: A9 73 9B
	sta.b $73		; $8FDCBF: 85 73
	lda.w #$0088		; $8FDCC1: A9 88 00
	sta.b $75		; $8FDCC4: 85 75
	jsl.l $86FA3E		; $8FDCC6: 22 3E FA 86
	ldx.w #$0000		; $8FDCCA: A2 00 00
CODE_8FDCCD:		; M=16 X=16
	lda.l $7F0000,x		; $8FDCCD: BF 00 00 7F
	sta.w $2118		; $8FDCD1: 8D 18 21
	inx		; $8FDCD4: E8
	inx		; $8FDCD5: E8
	cpx.w #$32A0		; $8FDCD6: E0 A0 32
	bne CODE_8FDCCD		; $8FDCD9: D0 F2
	lda.w #$C6D8		; $8FDCDB: A9 D8 C6
	sta.b $73		; $8FDCDE: 85 73
	lda.w #$0083		; $8FDCE0: A9 83 00
	sta.b $75		; $8FDCE3: 85 75
	jsl.l $86FA3E		; $8FDCE5: 22 3E FA 86
	ldx.w #$0000		; $8FDCE9: A2 00 00
CODE_8FDCEC:		; M=16 X=16
	lda.l $7F0000,x		; $8FDCEC: BF 00 00 7F
	sta.w $2118		; $8FDCF0: 8D 18 21
	inx		; $8FDCF3: E8
	inx		; $8FDCF4: E8
	cpx.w #$0C80		; $8FDCF5: E0 80 0C
	bne CODE_8FDCEC		; $8FDCF8: D0 F2
	ldx.w #$0000		; $8FDCFA: A2 00 00
CODE_8FDCFD:		; M=16 X=16
	lda.l $88872E,x		; $8FDCFD: BF 2E 87 88
	sta.w $2118		; $8FDD01: 8D 18 21
	inx		; $8FDD04: E8
	inx		; $8FDD05: E8
	cpx.w #$0080		; $8FDD06: E0 80 00
	bne CODE_8FDCFD		; $8FDD09: D0 F2
	jsl.l $80B90C		; $8FDD0B: 22 0C B9 80
	ora.b $00		; $8FDD0F: 05 00
	inc.w $0306,x		; $8FDD11: FE 06 03
	lda.w #$0019		; $8FDD14: A9 19 00
	sta.b $53		; $8FDD17: 85 53
	lda.w #$0009		; $8FDD19: A9 09 00
	sta.b $57		; $8FDD1C: 85 57
	jsl.l $8FD69F		; $8FDD1E: 22 9F D6 8F
	lda.w #$ED38		; $8FDD22: A9 38 ED
	sta.b $73		; $8FDD25: 85 73
	lda.w #$0080		; $8FDD27: A9 80 00
	sta.b $75		; $8FDD2A: 85 75
	jsl.l $86FA3E		; $8FDD2C: 22 3E FA 86
	sep #$20		; $8FDD30: E2 20
	stz.w $2121		; $8FDD32: 9C 21 21
	ldx.w #$0000		; $8FDD35: A2 00 00
CODE_8FDD38:		; M=8 X=16
	lda.l $7F0090,x		; $8FDD38: BF 90 00 7F
	sta.w $2122		; $8FDD3C: 8D 22 21
	inx		; $8FDD3F: E8
	cpx.w #$0080		; $8FDD40: E0 80 00
	bne CODE_8FDD38		; $8FDD43: D0 F3
	rep #$30		; $8FDD45: C2 30
	ldx.w #$0000		; $8FDD47: A2 00 00
CODE_8FDD4A:		; M=16 X=16
	lda.l $7F0190,x		; $8FDD4A: BF 90 01 7F
	sta.w $2118		; $8FDD4E: 8D 18 21
	inx		; $8FDD51: E8
	inx		; $8FDD52: E8
	cpx.w #$07A0		; $8FDD53: E0 A0 07
	bne CODE_8FDD4A		; $8FDD56: D0 F2
	stz.b $75		; $8FDD58: 64 75
CODE_8FDD5A:		; M=16 X=16
	stz.b $73		; $8FDD5A: 64 73
CODE_8FDD5C:		; M=16 X=16
	lda.b $75		; $8FDD5C: A5 75
	sta.b $7D		; $8FDD5E: 85 7D
	lda.w #$0008		; $8FDD60: A9 08 00
	sta.b $83		; $8FDD63: 85 83
	jsl.l $8D871C		; $8FDD65: 22 1C 87 8D
	adc.b $73		; $8FDD69: 65 73
	asl a		; $8FDD6B: 0A
	tax		; $8FDD6C: AA
	lda.l $7F0000,x		; $8FDD6D: BF 00 00 7F
	adc.w $1BE3		; $8FDD71: 6D E3 1B
	pha		; $8FDD74: 48
	lda.b $75		; $8FDD75: A5 75
	asl a		; $8FDD77: 0A
	asl a		; $8FDD78: 0A
	asl a		; $8FDD79: 0A
	asl a		; $8FDD7A: 0A
	asl a		; $8FDD7B: 0A
	adc.b $73		; $8FDD7C: 65 73
	asl a		; $8FDD7E: 0A
	tax		; $8FDD7F: AA
	pla		; $8FDD80: 68
	sta.l $7E76B8,x		; $8FDD81: 9F B8 76 7E
	inc.b $73		; $8FDD85: E6 73
	lda.b $73		; $8FDD87: A5 73
	cmp.w #$0008		; $8FDD89: C9 08 00
	bne CODE_8FDD5C		; $8FDD8C: D0 CE
	inc.b $75		; $8FDD8E: E6 75
	lda.b $75		; $8FDD90: A5 75
	cmp.w #$0009		; $8FDD92: C9 09 00
	bne CODE_8FDD5A		; $8FDD95: D0 C3
	jsl.l $80B90C		; $8FDD97: 22 0C B9 80
	ora.b $00		; $8FDD9B: 05 00
	sbc.l $AD0D02,x		; $8FDD9D: FF 02 0D AD
	stz.w $8512		; $8FDDA1: 9C 12 85
	eor.b [$22],y		; $8FDDA4: 57 22
	sep #$84		; $8FDDA6: E2 84
	sta.w $0C22		; $8FDDA8: 8D 22 0C
	lda.w $0580,y		; $8FDDAB: B9 80 05
	db $00,$FF,$15,$0D,$AD,$9A,$12,$85,$57,$22,$E2,$84,$8D,$22,$0C,$B9	; $8FDDAE
	db $80,$05,$00,$FF,$11,$0F,$A9,$66,$DF,$85,$37,$A9,$8F,$00,$85,$39	; $8FDDBE
	db $A7,$37,$4A,$49,$FF,$FF,$1A,$18,$69,$11,$00,$8D,$7B,$04,$22,$2D	; $8FDDCE
	db $B9,$80,$EE,$7D,$04,$A0,$02,$00,$B7,$37,$89,$80,$00,$F0,$E1,$22	; $8FDDDE
	db $0C,$B9,$80,$05,$00,$FF,$19,$0F,$AD,$CE,$13,$85,$33,$A9,$83,$00	; $8FDDEE
	db $85,$35,$85,$3D,$AD,$D0,$13,$85,$3B,$A0,$08,$00,$B7,$33,$18,$65	; $8FDDFE
	db $33,$85,$33,$B7,$3B,$65,$3B,$85,$3B,$22,$D2,$DE,$8F,$22,$0C,$B9	; $8FDE0E
	db $80,$05,$00,$FF,$04,$0F,$A5,$33,$A6,$3B,$85,$3B,$86,$33,$22,$D2	; $8FDE1E
	db $DE,$8F,$22,$75,$DA,$8F,$A9,$1A,$00,$87,$33,$E6,$33,$E6,$33,$1A	; $8FDE2E
	db $87,$33,$E6,$33,$E6,$33,$1A,$1A,$87,$33,$E6,$33,$E6,$33,$AD,$9A	; $8FDE3E
	db $12,$85,$53,$87,$33,$E6,$33,$E6,$33,$A9,$1D,$00,$87,$33,$E6,$33	; $8FDE4E
	db $E6,$33,$AD,$9C,$12,$C5,$53,$F0,$06,$87,$33,$E6,$33,$E6,$33,$A9	; $8FDE5E
	db $1D,$00,$87,$33,$E6,$33,$E6,$33,$3A,$87,$33,$E6,$33,$E6,$33,$A9	; $8FDE6E
	db $FF,$FF,$87,$33,$9C,$44,$16,$A9,$FF,$7F,$8D,$EB,$08,$A9,$74,$6E	; $8FDE7E
	db $8D,$53,$16,$A9,$7E,$00,$8D,$55,$16,$A9,$00,$10,$8D,$56,$16,$9C	; $8FDE8E
	db $58,$16,$A9,$07,$00,$85,$A3,$A9,$50,$82,$85,$14,$C5,$14,$F0,$FC	; $8FDE9E
	db $22,$E8,$F3,$80,$AD,$6E,$01,$0D,$70,$01,$89,$00,$10,$D0,$14,$89	; $8FDEAE
	db $00,$04,$F0,$06,$A9,$FF,$FF,$8D,$44,$16,$22,$32,$F5,$84,$CE,$EB	; $8FDEBE
	db $08,$10,$BA,$6B,$A0,$04,$00,$B7,$33,$EB,$85,$69,$C8,$C8,$B7,$33	; $8FDECE
	db $EB,$85,$67,$A9,$07,$00,$85,$6B,$A0,$04,$00,$06,$67,$26,$69,$A5	; $8FDEDE
	db $67,$69,$00,$00,$85,$67,$88,$D0,$F2,$A5,$67,$29,$0F,$00,$85,$53	; $8FDEEE
	db $22,$4D,$DF,$8F,$A5,$6B,$C9,$01,$00,$D0,$04,$22,$12,$DF,$8F,$C6	; $8FDEFE
	db $6B,$10,$D5,$6B,$A7,$33,$EB,$29,$0F,$00,$85,$53,$A7,$3B,$EB,$4A	; $8FDF0E
	db $4A,$4A,$4A,$29,$0F,$00,$18,$65,$53,$85,$53,$22,$4D,$DF,$8F,$AD	; $8FDF1E
	db $7B,$04,$C9,$10,$00,$90,$2D,$A0,$02,$00,$B7,$33,$4A,$4A,$4A,$4A	; $8FDF2E
	db $29,$0F,$00,$85,$53,$B7,$3B,$29,$0F,$00,$18,$65,$53,$85,$53,$A9	; $8FDF3E
	db $02,$00,$85,$57,$22,$4E,$F5,$8F,$AD,$7B,$04,$48,$22,$2D,$B9,$80	; $8FDF4E
	db $68,$8D,$7B,$04,$EE,$7D,$04,$6B,$0A,$00,$53,$68,$6F,$6F,$74,$69	; $8FDF5E
	db $6E,$67,$09,$00,$53,$6B,$61,$74,$69,$6E,$67,$09,$00,$50,$61,$73	; $8FDF6E
	db $73,$69,$6E,$67,$09,$00,$44,$65,$66,$65,$6E,$73,$65,$0A,$00,$43	; $8FDF7E
	db $68,$65,$63,$6B,$69,$6E,$67,$0A,$00,$46,$69,$67,$68,$74,$69,$6E	; $8FDF8E
	db $67,$0D,$00,$47,$6F,$61,$6C,$6B,$65,$65,$70,$69,$6E,$67,$11,$00	; $8FDF9E
	db $50,$6F,$77,$65,$72,$20,$50,$6C,$61,$79,$20,$41,$64,$76,$2E,$19	; $8FDFAE
	db $00,$2D,$20,$20,$20,$20,$48,$6F,$6D,$65,$20,$54,$65,$61,$6D,$20	; $8FDFBE
	db $41,$64,$76,$2E,$20,$20,$20,$20,$09,$00,$4F,$76,$65,$72,$61,$6C	; $8FDFCE
	db $6C,$03,$00,$FF,$9C,$FF,$EC,$FF,$64,$00,$EC,$FF,$88,$FF,$28,$00	; $8FDFDE
	db $14,$00,$28,$00,$78,$00,$28,$00,$EC,$FF,$28,$00,$D8,$FF,$F0,$00	; $8FDFEE
	db $00,$00,$DC,$00,$14,$00,$E6,$00,$1E,$00,$E6,$00,$22,$1A,$B0,$80	; $8FDFFE
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
	brl CODE_8F8E1A		; $8FFF96: 82 81 8E
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
