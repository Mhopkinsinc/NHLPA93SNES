; $80C00A-$80CFFF  ROM $0400A  (from src/bank80.asm; quick pass, TODO segment agents refine)
org $80C00A
	db $00,$00,$02,$00,$F6,$FA,$02,$04,$0A,$00,$43,$68,$61,$72,$67,$69	; $80C00A
	db $6E,$67,$04,$00,$01,$01,$01,$0A,$01,$0B,$01,$0A,$01,$0B,$01,$0A	; $80C01A
	db $01,$0B,$01,$0A,$01,$0B,$FF,$FE,$02,$04,$0A,$00,$53,$6C,$61,$73	; $80C02A
	db $68,$69,$6E,$67,$04,$00,$01,$01,$01,$02,$01,$03,$01,$02,$01,$03	; $80C03A
	db $01,$02,$01,$03,$01,$02,$01,$03,$FF,$FE,$02,$04,$0A,$00,$54,$72	; $80C04A
	db $69,$70,$70,$69,$6E,$67,$04,$00,$01,$04,$01,$05,$01,$04,$01,$05	; $80C05A
	db $01,$04,$01,$05,$01,$04,$01,$05,$FF,$FE,$02,$0A,$0A,$00,$52,$6F	; $80C06A
	db $75,$67,$68,$69,$6E,$67,$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E	; $80C07A
	db $01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE,$02,$04,$0A,$00,$52,$6F	; $80C08A
	db $75,$67,$68,$69,$6E,$67,$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E	; $80C09A
	db $01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE,$02,$04,$09,$00,$48,$6F	; $80C0AA
	db $6F,$6B,$69,$6E,$67,$04,$00,$01,$01,$01,$09,$01,$08,$01,$09,$01	; $80C0BA
	db $08,$01,$09,$01,$08,$01,$09,$01,$08,$FF,$FE,$02,$04,$0D,$00,$43	; $80C0CA
	db $72,$6F,$73,$73,$20,$43,$68,$65,$63,$6B,$04,$00,$01,$06,$01,$0F	; $80C0DA
	db $01,$10,$01,$0F,$01,$10,$01,$0F,$01,$10,$01,$0F,$01,$10,$FF,$FE	; $80C0EA
	db $02,$04,$0E,$00,$49,$6E,$74,$65,$72,$66,$65,$72,$65,$6E,$63,$65	; $80C0FA
	db $04,$00,$01,$01,$06,$0C,$FF,$FE,$02,$04,$09,$00,$48,$6F,$6C,$64	; $80C10A
	db $69,$6E,$67,$04,$00,$01,$01,$06,$07,$FF,$FE,$05,$28,$0A,$00,$46	; $80C11A
	db $69,$67,$68,$74,$69,$6E,$67,$04,$00,$01,$0D,$01,$0E,$01,$0D,$01	; $80C12A
	db $0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE,$05,$28,$0C,$00,$46	; $80C13A
	db $69,$67,$68,$74,$69,$6E,$67,$20,$2A,$04,$00,$01,$0D,$01,$0E,$01	; $80C14A
	db $0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE,$02,$28,$12	; $80C15A
	db $00,$46,$69,$67,$68,$74,$20,$49,$6E,$73,$74,$69,$67,$61,$74,$6F	; $80C16A
	db $72,$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01	; $80C17A
	db $0D,$01,$0E,$FF,$FE	; $80C18A
CODE_80C18F:		; M=16 X=16
	lda.w $128A		; $80C18F: AD 8A 12
	bne CODE_80C1AF		; $80C192: D0 1B
	lda.b $53		; $80C194: A5 53
	cmp.w #$000C		; $80C196: C9 0C 00
	beq CODE_80C1B0		; $80C199: F0 15
	lda.w $160A		; $80C19B: AD 0A 16
	beq CODE_80C1AF		; $80C19E: F0 0F
	lda.w $1288		; $80C1A0: AD 88 12
	bit.w #$0020		; $80C1A3: 89 20 00
	bne CODE_80C1B0		; $80C1A6: D0 08
	lda.b $53		; $80C1A8: A5 53
	cmp.w #$0010		; $80C1AA: C9 10 00
	bne CODE_80C1B0		; $80C1AD: D0 01
CODE_80C1AF:		; M=16 X=16
	rtl		; $80C1AF: 6B
CODE_80C1B0:		; M=16 X=16
	lda.w $128E		; $80C1B0: AD 8E 12
	beq CODE_80C1B8		; $80C1B3: F0 03
	jmp.w $C277		; $80C1B5: 4C 77 C2
CODE_80C1B8:		; M=16 X=16
	stx.b $0A		; $80C1B8: 86 0A
	ldx.w #$0000		; $80C1BA: A2 00 00
CODE_80C1BD:		; M=16 X=16
	lda.b $57,x		; $80C1BD: B5 57
	pha		; $80C1BF: 48
	inx		; $80C1C0: E8
	inx		; $80C1C1: E8
	cpx.w #$0004		; $80C1C2: E0 04 00
	bne CODE_80C1BD		; $80C1C5: D0 F6
	ldx.b $0A		; $80C1C7: A6 0A
	stx.b $0A		; $80C1C9: 86 0A
	ldx.w #$0000		; $80C1CB: A2 00 00
CODE_80C1CE:		; M=16 X=16
	lda.b $33,x		; $80C1CE: B5 33
	pha		; $80C1D0: 48
	inx		; $80C1D1: E8
	inx		; $80C1D2: E8
	cpx.w #$0008		; $80C1D3: E0 08 00
	bne CODE_80C1CE		; $80C1D6: D0 F6
	ldx.b $0A		; $80C1D8: A6 0A
	lda.b $53		; $80C1DA: A5 53
	sec		; $80C1DC: 38
	sbc.w #$000E		; $80C1DD: E9 0E 00
	bmi CODE_80C1E6		; $80C1E0: 30 04
	bvc CODE_80C1E8		; $80C1E2: 50 04
	bra CODE_80C202		; $80C1E4: 80 1C
CODE_80C1E6:		; M=16 X=16
	bvc CODE_80C202		; $80C1E6: 50 1A
CODE_80C1E8:		; M=16 X=16
	lda.b $DE		; $80C1E8: A5 DE
	clc		; $80C1EA: 18
	adc.w #$00C8		; $80C1EB: 69 C8 00
	sta.b $DE		; $80C1EE: 85 DE
	lda.w #$008B		; $80C1F0: A9 8B 00
	pha		; $80C1F3: 48
	lda.w $119F,x		; $80C1F4: BD 9F 11
	beq CODE_80C1FE		; $80C1F7: F0 05
	lda.w #$008A		; $80C1F9: A9 8A 00
	sta.b $01,s		; $80C1FC: 83 01
CODE_80C1FE:		; M=16 X=16
	jsl.l $80C28B		; $80C1FE: 22 8B C2 80
CODE_80C202:		; M=16 X=16
	lda.w #$129E		; $80C202: A9 9E 12
	sta.b $37		; $80C205: 85 37
	lda.w #$0000		; $80C207: A9 00 00
	sta.b $39		; $80C20A: 85 39
	lda.w #$001F		; $80C20C: A9 1F 00
	sta.b $57		; $80C20F: 85 57
CODE_80C211:		; M=16 X=16
	lda.b [$37]		; $80C211: A7 37
	inc.b $37		; $80C213: E6 37
	inc.b $37		; $80C215: E6 37
	tay		; $80C217: A8
	beq CODE_80C220		; $80C218: F0 06
	dec.b $57		; $80C21A: C6 57
	bpl CODE_80C211		; $80C21C: 10 F3
	bra CODE_80C25B		; $80C21E: 80 3B
CODE_80C220:		; M=16 X=16
	dec.b $37		; $80C220: C6 37
	dec.b $37		; $80C222: C6 37
	txa		; $80C224: 8A
	lsr a		; $80C225: 4A
	xba		; $80C226: EB
	and.w #$FF00		; $80C227: 29 00 FF
	ora.b $53		; $80C22A: 05 53
	sta.b [$37]		; $80C22C: 87 37
	lda.w #$0080		; $80C22E: A9 80 00
	sta.b $35		; $80C231: 85 35
	lda.w #$BF6A		; $80C233: A9 6A BF
	sta.b $33		; $80C236: 85 33
	ldy.b $53		; $80C238: A4 53
	clc		; $80C23A: 18
	adc.b [$33],y		; $80C23B: 77 33
	sta.b $33		; $80C23D: 85 33
	lda.b [$33]		; $80C23F: A7 33
	and.w #$00FF		; $80C241: 29 FF 00
	beq CODE_80C25B		; $80C244: F0 15
	lda.w $0EDF,x		; $80C246: BD DF 0E
	pha		; $80C249: 48
	ora.w #$4000		; $80C24A: 09 00 40
	sta.w $0EDF,x		; $80C24D: 9D DF 0E
	pla		; $80C250: 68
	bit.w #$4000		; $80C251: 89 00 40
	beq CODE_80C25B		; $80C254: F0 05
	lda.w #$0000		; $80C256: A9 00 00
	sta.b [$37]		; $80C259: 87 37
CODE_80C25B:		; M=16 X=16
	stx.b $0A		; $80C25B: 86 0A
	ldx.w #$0006		; $80C25D: A2 06 00
CODE_80C260:		; M=16 X=16
	pla		; $80C260: 68
	sta.b $33,x		; $80C261: 95 33
	dex		; $80C263: CA
	dex		; $80C264: CA
	bpl CODE_80C260		; $80C265: 10 F9
	ldx.b $0A		; $80C267: A6 0A
	stx.b $0A		; $80C269: 86 0A
	ldx.w #$0002		; $80C26B: A2 02 00
CODE_80C26E:		; M=16 X=16
	pla		; $80C26E: 68
	sta.b $57,x		; $80C26F: 95 57
	dex		; $80C271: CA
	dex		; $80C272: CA
	bpl CODE_80C26E		; $80C273: 10 F9
	ldx.b $0A		; $80C275: A6 0A
CODE_80C277:		; M=16 X=16
	rtl		; $80C277: 6B
CODE_80C278:		; M=16 X=16
	lda.w $08DF		; $80C278: AD DF 08
	sta.w $08F7		; $80C27B: 8D F7 08
	lda.w $0154		; $80C27E: AD 54 01
	sta.w $08F5		; $80C281: 8D F5 08
	lda.w #$0040		; $80C284: A9 40 00
	tsb.w $128C		; $80C287: 0C 8C 12
	rtl		; $80C28A: 6B
CODE_80C28B:		; M=16 X=16
	pla		; $80C28B: 68
	inc a		; $80C28C: 1A
	sta.w $0179		; $80C28D: 8D 79 01
	sep #$20		; $80C290: E2 20
	pla		; $80C292: 68
	sta.w $017B		; $80C293: 8D 7B 01
	rep #$20		; $80C296: C2 20
	lda.b $00		; $80C298: A5 00
	sec		; $80C29A: 38
	sbc.w $04A7		; $80C29B: ED A7 04
	cmp.w #$00B4		; $80C29E: C9 B4 00
	bcc CODE_80C2B1		; $80C2A1: 90 0E
	pla		; $80C2A3: 68
	sta.w $017F		; $80C2A4: 8D 7F 01
	beq CODE_80C2AD		; $80C2A7: F0 04
	jsl.l $82FB79		; $80C2A9: 22 79 FB 82
CODE_80C2AD:		; M=16 X=16
	jml.l $000178		; $80C2AD: 5C 78 01 00
CODE_80C2B1:		; M=16 X=16
	pla		; $80C2B1: 68
	bra CODE_80C2AD		; $80C2B2: 80 F9
CODE_80C2B4:		; M=16 X=16
	lda.w $1288		; $80C2B4: AD 88 12
	bit.w #$0010		; $80C2B7: 89 10 00
	beq CODE_80C2BF		; $80C2BA: F0 03
	jmp.w $C3D3		; $80C2BC: 4C D3 C3
CODE_80C2BF:		; M=16 X=16
	lda.w $128C		; $80C2BF: AD 8C 12
	bit.w #$0400		; $80C2C2: 89 00 04
	bne CODE_80C2F5		; $80C2C5: D0 2E
	lda.w $0495		; $80C2C7: AD 95 04
	clc		; $80C2CA: 18
	adc.w #$0071		; $80C2CB: 69 71 00
	sta.w $0495		; $80C2CE: 8D 95 04
	bcc CODE_80C2D6		; $80C2D1: 90 03
	inc.w $0497		; $80C2D3: EE 97 04
CODE_80C2D6:		; M=16 X=16
	cmp.w #$FF41		; $80C2D6: C9 41 FF
	bne CODE_80C2F5		; $80C2D9: D0 1A
	lda.w $0497		; $80C2DB: AD 97 04
	cmp.w #$007E		; $80C2DE: C9 7E 00
	bne CODE_80C2F5		; $80C2E1: D0 12
	lda.w #$0010		; $80C2E3: A9 10 00
	tsb.w $128C		; $80C2E6: 0C 8C 12
	lda.w #$8174		; $80C2E9: A9 74 81
	sta.w $0495		; $80C2EC: 8D 95 04
	lda.w #$007E		; $80C2EF: A9 7E 00
	sta.w $0497		; $80C2F2: 8D 97 04
CODE_80C2F5:		; M=16 X=16
	lda.w $0495		; $80C2F5: AD 95 04
	sta.b $33		; $80C2F8: 85 33
	lda.w $0497		; $80C2FA: AD 97 04
	sta.b $35		; $80C2FD: 85 35
	lda.w #$000F		; $80C2FF: A9 0F 00
	sta.b $5B		; $80C302: 85 5B
	ldx.w #$0000		; $80C304: A2 00 00
	ldy.w #$0001		; $80C307: A0 01 00
CODE_80C30A:		; M=16 X=16
	lda.w #$0000		; $80C30A: A9 00 00
	sta.b [$33]		; $80C30D: 87 33
	sta.b [$33],y		; $80C30F: 97 33
	lda.w $08FF,x		; $80C311: BD FF 08
	and.w #$0FFF		; $80C314: 29 FF 0F
	sta.b [$33]		; $80C317: 87 33
	inc.b $33		; $80C319: E6 33
	lda.w $095F,x		; $80C31B: BD 5F 09
	asl a		; $80C31E: 0A
	asl a		; $80C31F: 0A
	asl a		; $80C320: 0A
	asl a		; $80C321: 0A
	ora.b [$33]		; $80C322: 07 33
	sta.b [$33]		; $80C324: 87 33
	inc.b $33		; $80C326: E6 33
	inc.b $33		; $80C328: E6 33
	lda.w $093F,x		; $80C32A: BD 3F 09
	and.w #$3FFF		; $80C32D: 29 FF 3F
	sta.b [$33]		; $80C330: 87 33
	lda.w $09DF,x		; $80C332: BD DF 09
	and.w #$1800		; $80C335: 29 00 18
	asl a		; $80C338: 0A
	asl a		; $80C339: 0A
	asl a		; $80C33A: 0A
	ora.b [$33]		; $80C33B: 07 33
	sta.b [$33]		; $80C33D: 87 33
	inc.b $33		; $80C33F: E6 33
	inc.b $33		; $80C341: E6 33
	inx		; $80C343: E8
	inx		; $80C344: E8
	dec.b $5B		; $80C345: C6 5B
	bpl CODE_80C30A		; $80C347: 10 C1
	lda.w #$0005		; $80C349: A9 05 00
	sta.b $5B		; $80C34C: 85 5B
	ldx.w #$0000		; $80C34E: A2 00 00
CODE_80C351:		; M=16 X=16
	lda.w $103F,x		; $80C351: BD 3F 10
	sta.b [$33]		; $80C354: 87 33
	inc.b $33		; $80C356: E6 33
	lda.w $1041,x		; $80C358: BD 41 10
	sta.b [$33]		; $80C35B: 87 33
	inc.b $33		; $80C35D: E6 33
	lda.w $0B9F,x		; $80C35F: BD 9F 0B
	bpl CODE_80C367		; $80C362: 10 03
	lda.w #$FFFF		; $80C364: A9 FF FF
CODE_80C367:		; M=16 X=16
	and.w #$000F		; $80C367: 29 0F 00
	sta.b [$33]		; $80C36A: 87 33
	lda.w $0BA1,x		; $80C36C: BD A1 0B
	bpl CODE_80C374		; $80C36F: 10 03
	lda.w #$FFFF		; $80C371: A9 FF FF
CODE_80C374:		; M=16 X=16
	asl a		; $80C374: 0A
	asl a		; $80C375: 0A
	asl a		; $80C376: 0A
	asl a		; $80C377: 0A
	ora.b [$33]		; $80C378: 07 33
	sta.b [$33]		; $80C37A: 87 33
	inc.b $33		; $80C37C: E6 33
	inx		; $80C37E: E8
	inx		; $80C37F: E8
	inx		; $80C380: E8
	inx		; $80C381: E8
	dec.b $5B		; $80C382: C6 5B
	bpl CODE_80C351		; $80C384: 10 CB
	lda.w $09BB		; $80C386: AD BB 09
	sta.b [$33]		; $80C389: 87 33
	inc.b $33		; $80C38B: E6 33
	lda.w $09BD		; $80C38D: AD BD 09
	sta.b [$33]		; $80C390: 87 33
	inc.b $33		; $80C392: E6 33
	lda.w $017F		; $80C394: AD 7F 01
	sta.b [$33]		; $80C397: 87 33
	inc.b $33		; $80C399: E6 33
	stz.w $017F		; $80C39B: 9C 7F 01
	lda.b $6F		; $80C39E: A5 6F
	sta.b [$33]		; $80C3A0: 87 33
	inc.b $33		; $80C3A2: E6 33
	lda.w $0431		; $80C3A4: AD 31 04
	sta.b [$33]		; $80C3A7: 87 33
	inc.b $33		; $80C3A9: E6 33
	inc.b $33		; $80C3AB: E6 33
	lda.b $DC		; $80C3AD: A5 DC
	sta.b [$33]		; $80C3AF: 87 33
	inc.b $33		; $80C3B1: E6 33
	inc.b $33		; $80C3B3: E6 33
	lda.w $014E		; $80C3B5: AD 4E 01
	sta.b [$33]		; $80C3B8: 87 33
	inc.b $33		; $80C3BA: E6 33
	inc.b $33		; $80C3BC: E6 33
	lda.w $12E4		; $80C3BE: AD E4 12
	sta.b [$33]		; $80C3C1: 87 33
	inc.b $33		; $80C3C3: E6 33
	lda.w $0154		; $80C3C5: AD 54 01
	sta.b [$33]		; $80C3C8: 87 33
	inc.b $33		; $80C3CA: E6 33
	inc.b $33		; $80C3CC: E6 33
	lda.w $08DF		; $80C3CE: AD DF 08
	sta.b [$33]		; $80C3D1: 87 33
CODE_80C3D3:		; M=16 X=16
	rtl		; $80C3D3: 6B
CODE_80C3D4:		; M=16 X=16
	lda.w $1296		; $80C3D4: AD 96 12
	ora.w $1298		; $80C3D7: 0D 98 12
	bne CODE_80C402		; $80C3DA: D0 26
	jsl.l $80C40B		; $80C3DC: 22 0B C4 80
	lda.b $57		; $80C3E0: A5 57
	bit.w #$1000		; $80C3E2: 89 00 10
	beq CODE_80C3EB		; $80C3E5: F0 04
	jml.l $8F8E03		; $80C3E7: 5C 03 8E 8F
CODE_80C3EB:		; M=16 X=16
	lda.b $57		; $80C3EB: A5 57
	bne CODE_80C403		; $80C3ED: D0 14
	jsl.l $80C429		; $80C3EF: 22 29 C4 80
	lda.b $57		; $80C3F3: A5 57
	bit.w #$1000		; $80C3F5: 89 00 10
	beq CODE_80C3FE		; $80C3F8: F0 04
	jml.l $82FDB5		; $80C3FA: 5C B5 FD 82
CODE_80C3FE:		; M=16 X=16
	lda.b $57		; $80C3FE: A5 57
	bne CODE_80C403		; $80C400: D0 01
CODE_80C402:		; M=16 X=16
	rtl		; $80C402: 6B
CODE_80C403:		; M=16 X=16
	jsl.l $82FA1A		; $80C403: 22 1A FA 82
	jml.l $8B816A		; $80C407: 5C 6A 81 8B
CODE_80C40B:		; M=16 X=16
	phx		; $80C40B: DA
	ldx.w #$0000		; $80C40C: A2 00 00
	jsl.l $80C447		; $80C40F: 22 47 C4 80
	plx		; $80C413: FA
	lda.w $0185		; $80C414: AD 85 01
	sta.b $5B		; $80C417: 85 5B
	lda.b $57		; $80C419: A5 57
	sta.w $0185		; $80C41B: 8D 85 01
	sta.b $5F		; $80C41E: 85 5F
	eor.b $5B		; $80C420: 45 5B
	sta.b $5B		; $80C422: 85 5B
	and.b $57		; $80C424: 25 57
	sta.b $57		; $80C426: 85 57
	rtl		; $80C428: 6B
CODE_80C429:		; M=16 X=16
	phx		; $80C429: DA
	ldx.w #$0002		; $80C42A: A2 02 00
	jsl.l $80C447		; $80C42D: 22 47 C4 80
	plx		; $80C431: FA
	lda.w $0187		; $80C432: AD 87 01
	sta.b $5B		; $80C435: 85 5B
	lda.b $57		; $80C437: A5 57
	sta.w $0187		; $80C439: 8D 87 01
	sta.b $5F		; $80C43C: 85 5F
	eor.b $5B		; $80C43E: 45 5B
	sta.b $5B		; $80C440: 85 5B
	and.b $57		; $80C442: 25 57
	sta.b $57		; $80C444: 85 57
	rtl		; $80C446: 6B
CODE_80C447:		; M=16 X=16
	lda.w $015E,x		; $80C447: BD 5E 01
	sta.b $55		; $80C44A: 85 55
	sta.b $57		; $80C44C: 85 57
	xba		; $80C44E: EB
	and.w #$000F		; $80C44F: 29 0F 00
	tax		; $80C452: AA
	lda.l $80C45D,x		; $80C453: BF 5D C4 80
	and.w #$00FF		; $80C457: 29 FF 00
	sta.b $53		; $80C45A: 85 53
	rtl		; $80C45C: 6B
	db $08,$02,$06,$08,$04,$03,$05,$08,$00,$01,$07,$08,$08,$08,$08,$08	; $80C45D
CODE_80C46D:		; M=16 X=16
	ldx.w #$0016		; $80C46D: A2 16 00
CODE_80C470:		; M=16 X=16
	lda.w $0ADF,x		; $80C470: BD DF 0A
	bit.w #$8000		; $80C473: 89 00 80
	beq CODE_80C47C		; $80C476: F0 04
	eor.w #$FFFF		; $80C478: 49 FF FF
	inc a		; $80C47B: 1A
CODE_80C47C:		; M=16 X=16
	sta.b $73		; $80C47C: 85 73
	lda.w $0AFF,x		; $80C47E: BD FF 0A
	bit.w #$8000		; $80C481: 89 00 80
	beq CODE_80C48A		; $80C484: F0 04
	eor.w #$FFFF		; $80C486: 49 FF FF
	inc a		; $80C489: 1A
CODE_80C48A:		; M=16 X=16
	clc		; $80C48A: 18
	adc.b $73		; $80C48B: 65 73
	sta.b $73		; $80C48D: 85 73
	lsr a		; $80C48F: 4A
	lsr a		; $80C490: 4A
	adc.b $73		; $80C491: 65 73
	cmp.w #$1000		; $80C493: C9 00 10
	bcs CODE_80C49B		; $80C496: B0 03
	lda.w #$1000		; $80C498: A9 00 10
CODE_80C49B:		; M=16 X=16
	sta.w $126F,x		; $80C49B: 9D 6F 12
	dex		; $80C49E: CA
	dex		; $80C49F: CA
	bpl CODE_80C470		; $80C4A0: 10 CE
	lda.w $128E		; $80C4A2: AD 8E 12
	bne CODE_80C4AD		; $80C4A5: D0 06
	lda.w #$000F		; $80C4A7: A9 0F 00
	tsb.w $0431		; $80C4AA: 0C 31 04
CODE_80C4AD:		; M=16 X=16
	ldx.w #$0000		; $80C4AD: A2 00 00
	stx.b $3F		; $80C4B0: 86 3F
CODE_80C4B2:		; M=16 X=16
	lda.w $08FF,x		; $80C4B2: BD FF 08
	sta.w $0A1F,x		; $80C4B5: 9D 1F 0A
	lda.w $091F,x		; $80C4B8: BD 1F 09
	sta.w $0A3F,x		; $80C4BB: 9D 3F 0A
	lda.w $095F,x		; $80C4BE: BD 5F 09
	sta.w $0A5F,x		; $80C4C1: 9D 5F 0A
	lda.w $097F,x		; $80C4C4: BD 7F 09
	sta.w $0A7F,x		; $80C4C7: 9D 7F 0A
	lda.w $099F,x		; $80C4CA: BD 9F 09
	sta.w $0A9F,x		; $80C4CD: 9D 9F 0A
	lda.w $09BF,x		; $80C4D0: BD BF 09
	sta.w $0ABF,x		; $80C4D3: 9D BF 0A
	lda.w $0B9F,x		; $80C4D6: BD 9F 0B
	bpl CODE_80C4DE		; $80C4D9: 10 03
	jmp.w $C76A		; $80C4DB: 4C 6A C7
CODE_80C4DE:		; M=16 X=16
	jsl.l $80E13E		; $80C4DE: 22 3E E1 80
	lda.w $0E5F,x		; $80C4E2: BD 5F 0E
	sec		; $80C4E5: 38
	sbc.b $6F		; $80C4E6: E5 6F
	bpl CODE_80C4ED		; $80C4E8: 10 03
	lda.w #$0000		; $80C4EA: A9 00 00
CODE_80C4ED:		; M=16 X=16
	sta.w $0E5F,x		; $80C4ED: 9D 5F 0E
	lda.w $0E7F,x		; $80C4F0: BD 7F 0E
	sec		; $80C4F3: 38
	sbc.b $6F		; $80C4F4: E5 6F
	bpl CODE_80C4FB		; $80C4F6: 10 03
	lda.w #$0000		; $80C4F8: A9 00 00
CODE_80C4FB:		; M=16 X=16
	sta.w $0E7F,x		; $80C4FB: 9D 7F 0E
	lda.w $1290		; $80C4FE: AD 90 12
	bit.w #$0020		; $80C501: 89 20 00
	beq CODE_80C521		; $80C504: F0 1B
	lda.w $0F1F,x		; $80C506: BD 1F 0F
	and.w #$00FF		; $80C509: 29 FF 00
	bit.w #$0080		; $80C50C: 89 80 00
	beq CODE_80C514		; $80C50F: F0 03
	ora.w #$FF00		; $80C511: 09 00 FF
CODE_80C514:		; M=16 X=16
	sta.b $53		; $80C514: 85 53
	cmp.w #$0000		; $80C516: C9 00 00
	bmi CODE_80C521		; $80C519: 30 06
	asl.b $53		; $80C51B: 06 53
	jsl.l $8FDBF9		; $80C51D: 22 F9 DB 8F
CODE_80C521:		; M=16 X=16
	lda.w $0DFF,x		; $80C521: BD FF 0D
	cmp.w #$1502		; $80C524: C9 02 15
	bne CODE_80C52C		; $80C527: D0 03
	jmp.w $C647		; $80C529: 4C 47 C6
CODE_80C52C:		; M=16 X=16
	lda.w $099F,x		; $80C52C: BD 9F 09
	bne CODE_80C57C		; $80C52F: D0 4B
	ldx.b $6F		; $80C531: A6 6F
CODE_80C533:		; M=16 X=16
	cpx.w #$000A		; $80C533: E0 0A 00
	bcs CODE_80C533		; $80C536: B0 FB
	lda.l $80C675,x		; $80C538: BF 75 C6 80
	and.w #$00FF		; $80C53C: 29 FF 00
	sta.b $5B		; $80C53F: 85 5B
	lda.l $80C67F,x		; $80C541: BF 7F C6 80
	sta.b $5D		; $80C545: 85 5D
	ldx.b $3F		; $80C547: A6 3F
	lda.w $0EDF,x		; $80C549: BD DF 0E
	bit.w #$0001		; $80C54C: 89 01 00
	beq CODE_80C558		; $80C54F: F0 07
	lda.b $5D		; $80C551: A5 5D
	and.w #$00FF		; $80C553: 29 FF 00
	sta.b $5B		; $80C556: 85 5B
CODE_80C558:		; M=16 X=16
	lda.w $0ADF,x		; $80C558: BD DF 0A
	sta.b $7D		; $80C55B: 85 7D
	lda.b $5B		; $80C55D: A5 5B
	sta.b $83		; $80C55F: 85 83
	jsl.l $82FCDB		; $80C561: 22 DB FC 82
	lda.b $94		; $80C565: A5 94
	sta.w $0ADF,x		; $80C567: 9D DF 0A
	lda.w $0AFF,x		; $80C56A: BD FF 0A
	sta.b $7D		; $80C56D: 85 7D
	lda.b $5B		; $80C56F: A5 5B
	sta.b $83		; $80C571: 85 83
	jsl.l $82FCDB		; $80C573: 22 DB FC 82
	lda.b $94		; $80C577: A5 94
	sta.w $0AFF,x		; $80C579: 9D FF 0A
CODE_80C57C:		; M=16 X=16
	lda.w $0ADF,x		; $80C57C: BD DF 0A
	beq CODE_80C5B4		; $80C57F: F0 33
	sta.b $7D		; $80C581: 85 7D
	lda.b $E4		; $80C583: A5 E4
	sta.b $83		; $80C585: 85 83
	lda.w $128E		; $80C587: AD 8E 12
	beq CODE_80C5A2		; $80C58A: F0 16
	txa		; $80C58C: 8A
	asl a		; $80C58D: 0A
	asl a		; $80C58E: 0A
	adc.w $0BBF,x		; $80C58F: 7D BF 0B
	tay		; $80C592: A8
	lda.w $0BDF,y		; $80C593: B9 DF 0B
	and.w #$00FF		; $80C596: 29 FF 00
	cmp.w #$000C		; $80C599: C9 0C 00
	beq CODE_80C5A2		; $80C59C: F0 04
	lsr.b $83		; $80C59E: 46 83
	lsr.b $83		; $80C5A0: 46 83
CODE_80C5A2:		; M=16 X=16
	jsl.l $82FCDB		; $80C5A2: 22 DB FC 82
	adc.w $091F,x		; $80C5A6: 7D 1F 09
	sta.w $091F,x		; $80C5A9: 9D 1F 09
	lda.w $08FF,x		; $80C5AC: BD FF 08
	adc.b $95		; $80C5AF: 65 95
	sta.w $08FF,x		; $80C5B1: 9D FF 08
CODE_80C5B4:		; M=16 X=16
	lda.w $0AFF,x		; $80C5B4: BD FF 0A
	beq CODE_80C5EC		; $80C5B7: F0 33
	sta.b $7D		; $80C5B9: 85 7D
	lda.b $E4		; $80C5BB: A5 E4
	sta.b $83		; $80C5BD: 85 83
	lda.w $128E		; $80C5BF: AD 8E 12
	beq CODE_80C5DA		; $80C5C2: F0 16
	txa		; $80C5C4: 8A
	asl a		; $80C5C5: 0A
	asl a		; $80C5C6: 0A
	adc.w $0BBF,x		; $80C5C7: 7D BF 0B
	tay		; $80C5CA: A8
	lda.w $0BDF,y		; $80C5CB: B9 DF 0B
	and.w #$00FF		; $80C5CE: 29 FF 00
	cmp.w #$000C		; $80C5D1: C9 0C 00
	beq CODE_80C5DA		; $80C5D4: F0 04
	lsr.b $83		; $80C5D6: 46 83
	lsr.b $83		; $80C5D8: 46 83
CODE_80C5DA:		; M=16 X=16
	jsl.l $82FCDB		; $80C5DA: 22 DB FC 82
	adc.w $097F,x		; $80C5DE: 7D 7F 09
	sta.w $097F,x		; $80C5E1: 9D 7F 09
	lda.w $095F,x		; $80C5E4: BD 5F 09
	adc.b $95		; $80C5E7: 65 95
	sta.w $095F,x		; $80C5E9: 9D 5F 09
CODE_80C5EC:		; M=16 X=16
	lda.w $099F,x		; $80C5EC: BD 9F 09
	bmi CODE_80C647		; $80C5EF: 30 56
	bne CODE_80C5F8		; $80C5F1: D0 05
	lda.w $0B1F,x		; $80C5F3: BD 1F 0B
	beq CODE_80C647		; $80C5F6: F0 4F
CODE_80C5F8:		; M=16 X=16
	lda.b $E4		; $80C5F8: A5 E4
	sta.b $7D		; $80C5FA: 85 7D
	lda.w $0B1F,x		; $80C5FC: BD 1F 0B
	sec		; $80C5FF: 38
	sbc.b $E6		; $80C600: E5 E6
	sta.w $0B1F,x		; $80C602: 9D 1F 0B
	sta.b $83		; $80C605: 85 83
	jsl.l $82FCDB		; $80C607: 22 DB FC 82
	adc.w $09BF,x		; $80C60B: 7D BF 09
	sta.w $09BF,x		; $80C60E: 9D BF 09
	lda.w $099F,x		; $80C611: BD 9F 09
	adc.b $95		; $80C614: 65 95
	sta.w $099F,x		; $80C616: 9D 9F 09
	bpl CODE_80C647		; $80C619: 10 2C
	stz.w $099F,x		; $80C61B: 9E 9F 09
	stz.w $09BF,x		; $80C61E: 9E BF 09
	lda.w $0B1F,x		; $80C621: BD 1F 0B
	eor.w #$FFFF		; $80C624: 49 FF FF
	inc a		; $80C627: 1A
	lsr a		; $80C628: 4A
	sta.w $0B1F,x		; $80C629: 9D 1F 0B
	sec		; $80C62C: 38
	sbc.w #$0200		; $80C62D: E9 00 02
	bmi CODE_80C636		; $80C630: 30 04
	bvc CODE_80C638		; $80C632: 50 04
	bra CODE_80C647		; $80C634: 80 11
CODE_80C636:		; M=16 X=16
	bvc CODE_80C647		; $80C636: 50 0F
CODE_80C638:		; M=16 X=16
	lda.w $04A1		; $80C638: AD A1 04
	and.w #$0003		; $80C63B: 29 03 00
	clc		; $80C63E: 18
	adc.w #$0098		; $80C63F: 69 98 00
	pha		; $80C642: 48
	jsl.l $80C28B		; $80C643: 22 8B C2 80
CODE_80C647:		; M=16 X=16
	txa		; $80C647: 8A
	lsr a		; $80C648: 4A
	sta.b $6B		; $80C649: 85 6B
	cmp.w $0EBB		; $80C64B: CD BB 0E
	bne CODE_80C663		; $80C64E: D0 13
	lda.w $115F,x		; $80C650: BD 5F 11
	bne CODE_80C663		; $80C653: D0 0E
	lda.w $128E		; $80C655: AD 8E 12
	bne CODE_80C663		; $80C658: D0 09
	lda.w #$FFFE		; $80C65A: A9 FE FF
	sta.b $63		; $80C65D: 85 63
	jsl.l $80E0E1		; $80C65F: 22 E1 E0 80
CODE_80C663:		; M=16 X=16
	lda.b $6B		; $80C663: A5 6B
	cmp.w $1292		; $80C665: CD 92 12
	bne CODE_80C68A		; $80C668: D0 20
	jsl.l $80C40B		; $80C66A: 22 0B C4 80
	stz.b $63		; $80C66E: 64 63
	jsl.l $80DF3F		; $80C670: 22 3F DF 80
	bra CODE_80C69C		; $80C674: 80 26
	db $F7,$F5,$F2,$EF,$EC,$E9,$E6,$E3,$E1,$DE,$FF,$FF,$FE,$FE,$FE,$FD	; $80C676
	db $FD,$FD,$FC,$FC	; $80C686
CODE_80C68A:		; M=16 X=16
	cmp.w $1294		; $80C68A: CD 94 12
	bne CODE_80C69C		; $80C68D: D0 0D
	jsl.l $80C429		; $80C68F: 22 29 C4 80
	lda.w #$0002		; $80C693: A9 02 00
	sta.b $63		; $80C696: 85 63
	jsl.l $80DF3F		; $80C698: 22 3F DF 80
CODE_80C69C:		; M=16 X=16
	lda.w $117F,x		; $80C69C: BD 7F 11
	bne CODE_80C6CE		; $80C69F: D0 2D
	txa		; $80C6A1: 8A
	asl a		; $80C6A2: 0A
	asl a		; $80C6A3: 0A
	adc.w $0BBF,x		; $80C6A4: 7D BF 0B
	tay		; $80C6A7: A8
	lda.w $0BDF,y		; $80C6A8: B9 DF 0B
	and.w #$00FF		; $80C6AB: 29 FF 00
CODE_80C6AE:		; M=16 X=16
	cmp.w #$001D		; $80C6AE: C9 1D 00
	bcs CODE_80C6AE		; $80C6B1: B0 FB
	asl a		; $80C6B3: 0A
	asl a		; $80C6B4: 0A
	tax		; $80C6B5: AA
	lda.l $8D86A8,x		; $80C6B6: BF A8 86 8D
	sta.w $0179		; $80C6BA: 8D 79 01
	lda.l $8D86A9,x		; $80C6BD: BF A9 86 8D
	sta.w $017A		; $80C6C1: 8D 7A 01
	ldx.b $3F		; $80C6C4: A6 3F
	jsl.l $8FDBF9		; $80C6C6: 22 F9 DB 8F
	jsl.l $000178		; $80C6CA: 22 78 01 00
CODE_80C6CE:		; M=16 X=16
	lda.w $095F,x		; $80C6CE: BD 5F 09
	sta.b $5F		; $80C6D1: 85 5F
	stz.w $0D5F,x		; $80C6D3: 9E 5F 0D
	stz.w $0D7F,x		; $80C6D6: 9E 7F 0D
	lda.w $08FF,x		; $80C6D9: BD FF 08
	sta.b $5B		; $80C6DC: 85 5B
	cmp.w $0A1F,x		; $80C6DE: DD 1F 0A
	bne CODE_80C6ED		; $80C6E1: D0 0A
	lda.b $5F		; $80C6E3: A5 5F
	cmp.w $0A5F,x		; $80C6E5: DD 5F 0A
	bne CODE_80C6ED		; $80C6E8: D0 03
	jmp.w $C75F		; $80C6EA: 4C 5F C7
CODE_80C6ED:		; M=16 X=16
	jsl.l $80C894		; $80C6ED: 22 94 C8 80
	cpx.w #$0018		; $80C6F1: E0 18 00
	bcs CODE_80C75F		; $80C6F4: B0 69
	lda.w $0B9F,x		; $80C6F6: BD 9F 0B
	beq CODE_80C75F		; $80C6F9: F0 64
	lda.w $0EDF,x		; $80C6FB: BD DF 0E
	and.w #$8000		; $80C6FE: 29 00 80
	ora.w $128E		; $80C701: 0D 8E 12
	bne CODE_80C75F		; $80C704: D0 59
	lda.w $08FF,x		; $80C706: BD FF 08
	bit.w #$8000		; $80C709: 89 00 80
	beq CODE_80C712		; $80C70C: F0 04
	eor.w #$FFFF		; $80C70E: 49 FF FF
	inc a		; $80C711: 1A
CODE_80C712:		; M=16 X=16
	cmp.w #$0019		; $80C712: C9 19 00
	bcs CODE_80C75F		; $80C715: B0 48
	lda.w $095F,x		; $80C717: BD 5F 09
	bit.w #$8000		; $80C71A: 89 00 80
	beq CODE_80C723		; $80C71D: F0 04
	eor.w #$FFFF		; $80C71F: 49 FF FF
	inc a		; $80C722: 1A
CODE_80C723:		; M=16 X=16
	sec		; $80C723: 38
	sbc.w #$010D		; $80C724: E9 0D 01
	sta.b $73		; $80C727: 85 73
	lda.w $0A5F,x		; $80C729: BD 5F 0A
	bit.w #$8000		; $80C72C: 89 00 80
	beq CODE_80C735		; $80C72F: F0 04
	eor.w #$FFFF		; $80C731: 49 FF FF
	inc a		; $80C734: 1A
CODE_80C735:		; M=16 X=16
	sec		; $80C735: 38
	sbc.w #$010D		; $80C736: E9 0D 01
	eor.b $73		; $80C739: 45 73
	bmi CODE_80C753		; $80C73B: 30 16
	lda.w $095F,x		; $80C73D: BD 5F 09
	bit.w #$8000		; $80C740: 89 00 80
	beq CODE_80C749		; $80C743: F0 04
	eor.w #$FFFF		; $80C745: 49 FF FF
	inc a		; $80C748: 1A
CODE_80C749:		; M=16 X=16
	cmp.w #$0103		; $80C749: C9 03 01
	bcc CODE_80C75F		; $80C74C: 90 11
	cmp.w #$0117		; $80C74E: C9 17 01
	bcs CODE_80C75F		; $80C751: B0 0C
CODE_80C753:		; M=16 X=16
	lda.w $0A1F,x		; $80C753: BD 1F 0A
	sta.w $08FF,x		; $80C756: 9D FF 08
	lda.w $0A5F,x		; $80C759: BD 5F 0A
	sta.w $095F,x		; $80C75C: 9D 5F 09
CODE_80C75F:		; M=16 X=16
	lda.w $0B7F,x		; $80C75F: BD 7F 0B
	sec		; $80C762: 38
	sbc.b $E2		; $80C763: E5 E2
	bpl CODE_80C76A		; $80C765: 10 03
	lda.w #$0000		; $80C767: A9 00 00
CODE_80C76A:		; M=16 X=16
	sta.w $0B7F,x		; $80C76A: 9D 7F 0B
	sta.w $0B5F,x		; $80C76D: 9D 5F 0B
	lda.w $093F,x		; $80C770: BD 3F 09
	cmp.w #$0173		; $80C773: C9 73 01
	bcc CODE_80C7A9		; $80C776: 90 31
	cmp.w #$0179		; $80C778: C9 79 01
	bcs CODE_80C7A9		; $80C77B: B0 2C
	lda.w $08FF,x		; $80C77D: BD FF 08
	sec		; $80C780: 38
	sbc.w #$FFA0		; $80C781: E9 A0 FF
	beq CODE_80C78E		; $80C784: F0 08
	bmi CODE_80C78C		; $80C786: 30 04
	bvs CODE_80C78E		; $80C788: 70 04
	bra CODE_80C794		; $80C78A: 80 08
CODE_80C78C:		; M=16 X=16
	bvs CODE_80C794		; $80C78C: 70 06
CODE_80C78E:		; M=16 X=16
	lda.w #$FFA0		; $80C78E: A9 A0 FF
	sta.w $08FF,x		; $80C791: 9D FF 08
CODE_80C794:		; M=16 X=16
	lda.w $08FF,x		; $80C794: BD FF 08
	sec		; $80C797: 38
	sbc.w #$0060		; $80C798: E9 60 00
	bmi CODE_80C7A1		; $80C79B: 30 04
	bvc CODE_80C7A3		; $80C79D: 50 04
	bra CODE_80C7A9		; $80C79F: 80 08
CODE_80C7A1:		; M=16 X=16
	bvc CODE_80C7A9		; $80C7A1: 50 06
CODE_80C7A3:		; M=16 X=16
	lda.w #$0060		; $80C7A3: A9 60 00
	sta.w $08FF,x		; $80C7A6: 9D FF 08
CODE_80C7A9:		; M=16 X=16
	inx		; $80C7A9: E8
	inx		; $80C7AA: E8
	stx.b $3F		; $80C7AB: 86 3F
	cpx.w #$0020		; $80C7AD: E0 20 00
	beq CODE_80C7B5		; $80C7B0: F0 03
	jmp.w $C4B2		; $80C7B2: 4C B2 C4
CODE_80C7B5:		; M=16 X=16
	ldx.w #$0016		; $80C7B5: A2 16 00
CODE_80C7B8:		; M=16 X=16
	lda.w $0ADF,x		; $80C7B8: BD DF 0A
	bit.w #$8000		; $80C7BB: 89 00 80
	beq CODE_80C7C4		; $80C7BE: F0 04
	eor.w #$FFFF		; $80C7C0: 49 FF FF
	inc a		; $80C7C3: 1A
CODE_80C7C4:		; M=16 X=16
	sta.b $73		; $80C7C4: 85 73
	lda.w $0AFF,x		; $80C7C6: BD FF 0A
	bit.w #$8000		; $80C7C9: 89 00 80
	beq CODE_80C7D2		; $80C7CC: F0 04
	eor.w #$FFFF		; $80C7CE: 49 FF FF
	inc a		; $80C7D1: 1A
CODE_80C7D2:		; M=16 X=16
	clc		; $80C7D2: 18
	adc.b $73		; $80C7D3: 65 73
	cmp.w $126F,x		; $80C7D5: DD 6F 12
	bcc CODE_80C80E		; $80C7D8: 90 34
	sta.b $73		; $80C7DA: 85 73
	lda.w $0ADF,x		; $80C7DC: BD DF 0A
	sta.b $7D		; $80C7DF: 85 7D
	lda.w $126F,x		; $80C7E1: BD 6F 12
	sta.b $83		; $80C7E4: 85 83
	jsl.l $82FCDB		; $80C7E6: 22 DB FC 82
	lda.b $73		; $80C7EA: A5 73
	sta.b $7D		; $80C7EC: 85 7D
	jsl.l $80996C		; $80C7EE: 22 6C 99 80
	sta.w $0ADF,x		; $80C7F2: 9D DF 0A
	lda.w $0AFF,x		; $80C7F5: BD FF 0A
	sta.b $7D		; $80C7F8: 85 7D
	lda.w $126F,x		; $80C7FA: BD 6F 12
	sta.b $83		; $80C7FD: 85 83
	jsl.l $82FCDB		; $80C7FF: 22 DB FC 82
	lda.b $73		; $80C803: A5 73
	sta.b $7D		; $80C805: 85 7D
	jsl.l $80996C		; $80C807: 22 6C 99 80
	sta.w $0AFF,x		; $80C80B: 9D FF 0A
CODE_80C80E:		; M=16 X=16
	dex		; $80C80E: CA
	dex		; $80C80F: CA
	bpl CODE_80C7B8		; $80C810: 10 A6
	lda.w $09BB		; $80C812: AD BB 09
	cmp.w #$0018		; $80C815: C9 18 00
	bcs CODE_80C846		; $80C818: B0 2C
	lda.w $091B		; $80C81A: AD 1B 09
	sec		; $80C81D: 38
	sbc.w #$FF78		; $80C81E: E9 78 FF
	bmi CODE_80C827		; $80C821: 30 04
	bvs CODE_80C829		; $80C823: 70 04
	bra CODE_80C82F		; $80C825: 80 08
CODE_80C827:		; M=16 X=16
	bvs CODE_80C82F		; $80C827: 70 06
CODE_80C829:		; M=16 X=16
	lda.w #$FF78		; $80C829: A9 78 FF
	sta.w $091B		; $80C82C: 8D 1B 09
CODE_80C82F:		; M=16 X=16
	lda.w $091B		; $80C82F: AD 1B 09
	sec		; $80C832: 38
	sbc.w #$0088		; $80C833: E9 88 00
	beq CODE_80C846		; $80C836: F0 0E
	bmi CODE_80C83E		; $80C838: 30 04
	bvc CODE_80C840		; $80C83A: 50 04
	bra CODE_80C846		; $80C83C: 80 08
CODE_80C83E:		; M=16 X=16
	bvc CODE_80C846		; $80C83E: 50 06
CODE_80C840:		; M=16 X=16
	lda.w #$0088		; $80C840: A9 88 00
	sta.w $091B		; $80C843: 8D 1B 09
CODE_80C846:		; M=16 X=16
	lda.w $09BB		; $80C846: AD BB 09
	bne CODE_80C888		; $80C849: D0 3D
	lda.w $097B		; $80C84B: AD 7B 09
	bit.w #$8000		; $80C84E: 89 00 80
	beq CODE_80C857		; $80C851: F0 04
	eor.w #$FFFF		; $80C853: 49 FF FF
	inc a		; $80C856: 1A
CODE_80C857:		; M=16 X=16
	cmp.w #$013E		; $80C857: C9 3E 01
	bcs CODE_80C888		; $80C85A: B0 2C
	lda.w $097B		; $80C85C: AD 7B 09
	sec		; $80C85F: 38
	sbc.w #$FEDB		; $80C860: E9 DB FE
	bmi CODE_80C869		; $80C863: 30 04
	bvs CODE_80C86B		; $80C865: 70 04
	bra CODE_80C871		; $80C867: 80 08
CODE_80C869:		; M=16 X=16
	bvs CODE_80C871		; $80C869: 70 06
CODE_80C86B:		; M=16 X=16
	lda.w #$FEDB		; $80C86B: A9 DB FE
	sta.w $097B		; $80C86E: 8D 7B 09
CODE_80C871:		; M=16 X=16
	lda.w $097B		; $80C871: AD 7B 09
	sec		; $80C874: 38
	sbc.w #$012A		; $80C875: E9 2A 01
	beq CODE_80C888		; $80C878: F0 0E
	bmi CODE_80C880		; $80C87A: 30 04
	bvc CODE_80C882		; $80C87C: 50 04
	bra CODE_80C888		; $80C87E: 80 08
CODE_80C880:		; M=16 X=16
	bvc CODE_80C888		; $80C880: 50 06
CODE_80C882:		; M=16 X=16
	lda.w #$012A		; $80C882: A9 2A 01
	sta.w $097B		; $80C885: 8D 7B 09
CODE_80C888:		; M=16 X=16
	lda.w $0EBB		; $80C888: AD BB 0E
	bmi CODE_80C893		; $80C88B: 30 06
	lda.w $097B		; $80C88D: AD 7B 09
	sta.w $0181		; $80C890: 8D 81 01
CODE_80C893:		; M=16 X=16
	rtl		; $80C893: 6B
CODE_80C894:		; M=16 X=16
	stz.b $D8		; $80C894: 64 D8
	lda.w $128E		; $80C896: AD 8E 12
	beq CODE_80C8A3		; $80C899: F0 08
	lda.b $5B		; $80C89B: A5 5B
	ldy.b $5F		; $80C89D: A4 5F
	sta.b $5F		; $80C89F: 85 5F
	sty.b $5B		; $80C8A1: 84 5B
CODE_80C8A3:		; M=16 X=16
	lda.w $11FF,x		; $80C8A3: BD FF 11
	beq CODE_80C8AB		; $80C8A6: F0 03
	jmp.w $C984		; $80C8A8: 4C 84 C9
CODE_80C8AB:		; M=16 X=16
	lda.b $6D		; $80C8AB: A5 6D
	pha		; $80C8AD: 48
	lda.b $6B		; $80C8AE: A5 6B
	pha		; $80C8B0: 48
	lda.b $69		; $80C8B1: A5 69
	pha		; $80C8B3: 48
	lda.b $67		; $80C8B4: A5 67
	pha		; $80C8B6: 48
	lda.b $65		; $80C8B7: A5 65
	pha		; $80C8B9: 48
	lda.b $63		; $80C8BA: A5 63
	pha		; $80C8BC: 48
	lda.b $61		; $80C8BD: A5 61
	pha		; $80C8BF: 48
	lda.b $5F		; $80C8C0: A5 5F
	pha		; $80C8C2: 48
	lda.b $5D		; $80C8C3: A5 5D
	pha		; $80C8C5: 48
	lda.b $5B		; $80C8C6: A5 5B
	pha		; $80C8C8: 48
	lda.b $59		; $80C8C9: A5 59
	pha		; $80C8CB: 48
	lda.b $57		; $80C8CC: A5 57
	pha		; $80C8CE: 48
	lda.b $55		; $80C8CF: A5 55
	pha		; $80C8D1: 48
	lda.b $53		; $80C8D2: A5 53
	pha		; $80C8D4: 48
	lda.w $08FF,x		; $80C8D5: BD FF 08
	sta.b $5B		; $80C8D8: 85 5B
	lda.w $095F,x		; $80C8DA: BD 5F 09
	sta.b $5F		; $80C8DD: 85 5F
	lda.w $0D1F,x		; $80C8DF: BD 1F 0D
	sta.w $08E3		; $80C8E2: 8D E3 08
	lda.w $0D3F,x		; $80C8E5: BD 3F 0D
	sta.w $08E5		; $80C8E8: 8D E5 08
	jsl.l $80CA1D		; $80C8EB: 22 1D CA 80
	lda.w $0D5F,x		; $80C8EF: BD 5F 0D
	ora.w $0D7F,x		; $80C8F2: 1D 7F 0D
	bne CODE_80C956		; $80C8F5: D0 5F
	cpx.w #$0018		; $80C8F7: E0 18 00
	bcs CODE_80C956		; $80C8FA: B0 5A
	lda.b $01,s		; $80C8FC: A3 01
	sta.b $53		; $80C8FE: 85 53
	lda.b $03,s		; $80C900: A3 03
	sta.b $55		; $80C902: 85 55
	lda.b $05,s		; $80C904: A3 05
	sta.b $57		; $80C906: 85 57
	lda.b $07,s		; $80C908: A3 07
	sta.b $59		; $80C90A: 85 59
	lda.b $09,s		; $80C90C: A3 09
	sta.b $5B		; $80C90E: 85 5B
	lda.b $0B,s		; $80C910: A3 0B
	sta.b $5D		; $80C912: 85 5D
	lda.b $0D,s		; $80C914: A3 0D
	sta.b $5F		; $80C916: 85 5F
	lda.b $0F,s		; $80C918: A3 0F
	sta.b $61		; $80C91A: 85 61
	lda.b $11,s		; $80C91C: A3 11
	sta.b $63		; $80C91E: 85 63
	lda.b $13,s		; $80C920: A3 13
	sta.b $65		; $80C922: 85 65
	lda.b $15,s		; $80C924: A3 15
	sta.b $67		; $80C926: 85 67
	lda.b $17,s		; $80C928: A3 17
	sta.b $69		; $80C92A: 85 69
	lda.b $19,s		; $80C92C: A3 19
	sta.b $6B		; $80C92E: 85 6B
	lda.b $1B,s		; $80C930: A3 1B
	sta.b $6D		; $80C932: 85 6D
	txa		; $80C934: 8A
	jsl.l $809B0A		; $80C935: 22 0A 9B 80
	lda.w $08FF,x		; $80C939: BD FF 08
	clc		; $80C93C: 18
	adc.b $53		; $80C93D: 65 53
	sta.b $5B		; $80C93F: 85 5B
	lda.w $095F,x		; $80C941: BD 5F 09
	clc		; $80C944: 18
	adc.b $57		; $80C945: 65 57
	sta.b $5F		; $80C947: 85 5F
	lda.w #$0001		; $80C949: A9 01 00
	sta.w $08E3		; $80C94C: 8D E3 08
	sta.w $08E5		; $80C94F: 8D E5 08
	jsl.l $80CA1D		; $80C952: 22 1D CA 80
CODE_80C956:		; M=16 X=16
	pla		; $80C956: 68
	sta.b $53		; $80C957: 85 53
	pla		; $80C959: 68
	sta.b $55		; $80C95A: 85 55
	pla		; $80C95C: 68
	sta.b $57		; $80C95D: 85 57
	pla		; $80C95F: 68
	sta.b $59		; $80C960: 85 59
	pla		; $80C962: 68
	sta.b $5B		; $80C963: 85 5B
	pla		; $80C965: 68
	sta.b $5D		; $80C966: 85 5D
	pla		; $80C968: 68
	sta.b $5F		; $80C969: 85 5F
	pla		; $80C96B: 68
	sta.b $61		; $80C96C: 85 61
	pla		; $80C96E: 68
	sta.b $63		; $80C96F: 85 63
	pla		; $80C971: 68
	sta.b $65		; $80C972: 85 65
	pla		; $80C974: 68
	sta.b $67		; $80C975: 85 67
	pla		; $80C977: 68
	sta.b $69		; $80C978: 85 69
	pla		; $80C97A: 68
	sta.b $6B		; $80C97B: 85 6B
	pla		; $80C97D: 68
	sta.b $6D		; $80C97E: 85 6D
	jsl.l $80D573		; $80C980: 22 73 D5 80
CODE_80C984:		; M=16 X=16
	lda.b $D8		; $80C984: A5 D8
	beq CODE_80C98B		; $80C986: F0 03
	jmp.w $CA10		; $80C988: 4C 10 CA
CODE_80C98B:		; M=16 X=16
	lda.w $123F,x		; $80C98B: BD 3F 12
	sta.b $57		; $80C98E: 85 57
CODE_80C990:		; M=16 X=16
	ldy.b $57		; $80C990: A4 57
	cpy.w #$000F		; $80C992: C0 0F 00
	beq CODE_80C9CD		; $80C995: F0 36
	lda.w $1260,y		; $80C997: B9 60 12
	and.w #$00FF		; $80C99A: 29 FF 00
	sta.b $63		; $80C99D: 85 63
	tay		; $80C99F: A8
	lda.b $5F		; $80C9A0: A5 5F
	sec		; $80C9A2: 38
	sbc.w $121F,y		; $80C9A3: F9 1F 12
	beq CODE_80C9CD		; $80C9A6: F0 25
	bmi CODE_80C9AE		; $80C9A8: 30 04
	bvc CODE_80C9B0		; $80C9AA: 50 04
	bra CODE_80C9CD		; $80C9AC: 80 1F
CODE_80C9AE:		; M=16 X=16
	bvc CODE_80C9CD		; $80C9AE: 50 1D
CODE_80C9B0:		; M=16 X=16
	inc.w $123F,x		; $80C9B0: FE 3F 12
	lda.w $123F,y		; $80C9B3: B9 3F 12
	dec a		; $80C9B6: 3A
	sta.w $123F,y		; $80C9B7: 99 3F 12
	sep #$30		; $80C9BA: E2 30
	ldy.b $57		; $80C9BC: A4 57
	lda.b $63		; $80C9BE: A5 63
	sta.w $125F,y		; $80C9C0: 99 5F 12
	txa		; $80C9C3: 8A
	sta.w $1260,y		; $80C9C4: 99 60 12
	rep #$30		; $80C9C7: C2 30
	inc.b $57		; $80C9C9: E6 57
	bra CODE_80C990		; $80C9CB: 80 C3
CODE_80C9CD:		; M=16 X=16
	lda.w $123F,x		; $80C9CD: BD 3F 12
	beq CODE_80CA0A		; $80C9D0: F0 38
	sta.b $57		; $80C9D2: 85 57
CODE_80C9D4:		; M=16 X=16
	ldy.b $57		; $80C9D4: A4 57
	lda.w $125E,y		; $80C9D6: B9 5E 12
	and.w #$00FF		; $80C9D9: 29 FF 00
	sta.b $63		; $80C9DC: 85 63
	tay		; $80C9DE: A8
	lda.b $5F		; $80C9DF: A5 5F
	sec		; $80C9E1: 38
	sbc.w $121F,y		; $80C9E2: F9 1F 12
	bmi CODE_80C9EB		; $80C9E5: 30 04
	bvs CODE_80C9ED		; $80C9E7: 70 04
	bra CODE_80CA0A		; $80C9E9: 80 1F
CODE_80C9EB:		; M=16 X=16
	bvs CODE_80CA0A		; $80C9EB: 70 1D
CODE_80C9ED:		; M=16 X=16
	dec.w $123F,x		; $80C9ED: DE 3F 12
	lda.w $123F,y		; $80C9F0: B9 3F 12
	inc a		; $80C9F3: 1A
	sta.w $123F,y		; $80C9F4: 99 3F 12
	sep #$30		; $80C9F7: E2 30
	ldy.b $57		; $80C9F9: A4 57
	lda.b $63		; $80C9FB: A5 63
	sta.w $125F,y		; $80C9FD: 99 5F 12
	txa		; $80CA00: 8A
	sta.w $125E,y		; $80CA01: 99 5E 12
	rep #$30		; $80CA04: C2 30
	dec.b $57		; $80CA06: C6 57
	bne CODE_80C9D4		; $80CA08: D0 CA
CODE_80CA0A:		; M=16 X=16
	lda.b $5F		; $80CA0A: A5 5F
	sta.w $121F,x		; $80CA0C: 9D 1F 12
	rtl		; $80CA0F: 6B
CODE_80CA10:		; M=16 X=16
	lda.w $0A1F,x		; $80CA10: BD 1F 0A
	sta.w $08FF,x		; $80CA13: 9D FF 08
	lda.w $0A5F,x		; $80CA16: BD 5F 0A
	sta.w $095F,x		; $80CA19: 9D 5F 09
	rtl		; $80CA1C: 6B
CODE_80CA1D:		; M=16 X=16
	lda.w #$012A		; $80CA1D: A9 2A 01
	sec		; $80CA20: 38
	sbc.w $08E5		; $80CA21: ED E5 08
	pha		; $80CA24: 48
	eor.w #$FFFF		; $80CA25: 49 FF FF
	inc a		; $80CA28: 1A
	clc		; $80CA29: 18
	adc.w #$0040		; $80CA2A: 69 40 00
	sta.b $67		; $80CA2D: 85 67
	lda.w #$0088		; $80CA2F: A9 88 00
	sec		; $80CA32: 38
	sbc.w $08E3		; $80CA33: ED E3 08
	pha		; $80CA36: 48
	eor.w #$FFFF		; $80CA37: 49 FF FF
	inc a		; $80CA3A: 1A
	clc		; $80CA3B: 18
	adc.w #$0040		; $80CA3C: 69 40 00
	sta.b $63		; $80CA3F: 85 63
	lda.b $5F		; $80CA41: A5 5F
	pha		; $80CA43: 48
	ldy.b $5B		; $80CA44: A4 5B
	phy		; $80CA46: 5A
	sec		; $80CA47: 38
	sbc.b $67		; $80CA48: E5 67
	beq CODE_80CA54		; $80CA4A: F0 08
	bmi CODE_80CA52		; $80CA4C: 30 04
	bvs CODE_80CA54		; $80CA4E: 70 04
	bra CODE_80CA80		; $80CA50: 80 2E
CODE_80CA52:		; M=16 X=16
	bvs CODE_80CA80		; $80CA52: 70 2C
CODE_80CA54:		; M=16 X=16
	lda.b $5B		; $80CA54: A5 5B
	sec		; $80CA56: 38
	sbc.b $63		; $80CA57: E5 63
	bmi CODE_80CA5F		; $80CA59: 30 04
	bvc CODE_80CA61		; $80CA5B: 50 04
	bra CODE_80CAC2		; $80CA5D: 80 63
CODE_80CA5F:		; M=16 X=16
	bvc CODE_80CAC2		; $80CA5F: 50 61
CODE_80CA61:		; M=16 X=16
	lda.b $63		; $80CA61: A5 63
	eor.w #$FFFF		; $80CA63: 49 FF FF
	inc a		; $80CA66: 1A
	sta.b $63		; $80CA67: 85 63
	sec		; $80CA69: 38
	sbc.b $5B		; $80CA6A: E5 5B
	bmi CODE_80CA72		; $80CA6C: 30 04
	bvc CODE_80CA74		; $80CA6E: 50 04
	bra CODE_80CAC2		; $80CA70: 80 50
CODE_80CA72:		; M=16 X=16
	bvc CODE_80CAC2		; $80CA72: 50 4E
CODE_80CA74:		; M=16 X=16
	lda.w #$001A		; $80CA74: A9 1A 00
	sta.b $3B		; $80CA77: 85 3B
	jsl.l $80CEE7		; $80CA79: 22 E7 CE 80
	jmp.w $CB37		; $80CA7D: 4C 37 CB
CODE_80CA80:		; M=16 X=16
	lda.b $67		; $80CA80: A5 67
	eor.w #$FFFF		; $80CA82: 49 FF FF
	inc a		; $80CA85: 1A
	sta.b $67		; $80CA86: 85 67
	sec		; $80CA88: 38
	sbc.b $5F		; $80CA89: E5 5F
	beq CODE_80CA96		; $80CA8B: F0 09
	bmi CODE_80CA94		; $80CA8D: 30 05
	bvs CODE_80CA96		; $80CA8F: 70 05
CODE_80CA91:		; M=16 X=16
	jmp.w $CB37		; $80CA91: 4C 37 CB
CODE_80CA94:		; M=16 X=16
	bvs CODE_80CA91		; $80CA94: 70 FB
CODE_80CA96:		; M=16 X=16
	lda.b $5B		; $80CA96: A5 5B
	sec		; $80CA98: 38
	sbc.b $63		; $80CA99: E5 63
	bmi CODE_80CAA1		; $80CA9B: 30 04
	bvc CODE_80CAA3		; $80CA9D: 50 04
	bra CODE_80CAC2		; $80CA9F: 80 21
CODE_80CAA1:		; M=16 X=16
	bvc CODE_80CAC2		; $80CAA1: 50 1F
CODE_80CAA3:		; M=16 X=16
	lda.b $63		; $80CAA3: A5 63
	eor.w #$FFFF		; $80CAA5: 49 FF FF
	inc a		; $80CAA8: 1A
	sta.b $63		; $80CAA9: 85 63
	sec		; $80CAAB: 38
	sbc.b $5B		; $80CAAC: E5 5B
	bmi CODE_80CAB4		; $80CAAE: 30 04
	bvc CODE_80CAB6		; $80CAB0: 50 04
	bra CODE_80CAC2		; $80CAB2: 80 0E
CODE_80CAB4:		; M=16 X=16
	bvc CODE_80CAC2		; $80CAB4: 50 0C
CODE_80CAB6:		; M=16 X=16
	lda.w #$0018		; $80CAB6: A9 18 00
	sta.b $3B		; $80CAB9: 85 3B
	jsl.l $80CEE7		; $80CABB: 22 E7 CE 80
	jmp.w $CB37		; $80CABF: 4C 37 CB
CODE_80CAC2:		; M=16 X=16
	lda.b $5B		; $80CAC2: A5 5B
	sec		; $80CAC4: 38
	sbc.b $63		; $80CAC5: E5 63
	sta.b $5B		; $80CAC7: 85 5B
	eor.w #$FFFF		; $80CAC9: 49 FF FF
	inc a		; $80CACC: 1A
	sta.b $57		; $80CACD: 85 57
	bit.w #$8000		; $80CACF: 89 00 80
	beq CODE_80CAD8		; $80CAD2: F0 04
	eor.w #$FFFF		; $80CAD4: 49 FF FF
	inc a		; $80CAD7: 1A
CODE_80CAD8:		; M=16 X=16
	sta.b $7D		; $80CAD8: 85 7D
	lda.b $5F		; $80CADA: A5 5F
	sec		; $80CADC: 38
	sbc.b $67		; $80CADD: E5 67
	sta.b $53		; $80CADF: 85 53
	bit.w #$8000		; $80CAE1: 89 00 80
	beq CODE_80CAEA		; $80CAE4: F0 04
	eor.w #$FFFF		; $80CAE6: 49 FF FF
	inc a		; $80CAE9: 1A
CODE_80CAEA:		; M=16 X=16
	sta.b $83		; $80CAEA: 85 83
	cmp.b $7D		; $80CAEC: C5 7D
	bcc CODE_80CAF8		; $80CAEE: 90 08
	lda.b $7D		; $80CAF0: A5 7D
	lsr a		; $80CAF2: 4A
	lsr a		; $80CAF3: 4A
	adc.b $83		; $80CAF4: 65 83
	bra CODE_80CAFC		; $80CAF6: 80 04
CODE_80CAF8:		; M=16 X=16
	lsr a		; $80CAF8: 4A
	lsr a		; $80CAF9: 4A
	adc.b $7D		; $80CAFA: 65 7D
CODE_80CAFC:		; M=16 X=16
	cmp.w #$0041		; $80CAFC: C9 41 00
	bcc CODE_80CB37		; $80CAFF: 90 36
	sta.b $5F		; $80CB01: 85 5F
	sta.b $7D		; $80CB03: 85 7D
	stz.b $83		; $80CB05: 64 83
	stz.b $85		; $80CB07: 64 85
	lda.b $53		; $80CB09: A5 53
	sta.b $84		; $80CB0B: 85 84
	bpl CODE_80CB14		; $80CB0D: 10 05
	lda.w #$FFFF		; $80CB0F: A9 FF FF
	sta.b $86		; $80CB12: 85 86
CODE_80CB14:		; M=16 X=16
	jsl.l $80996C		; $80CB14: 22 6C 99 80
	sta.b $53		; $80CB18: 85 53
	lda.b $5F		; $80CB1A: A5 5F
	sta.b $7D		; $80CB1C: 85 7D
	stz.b $83		; $80CB1E: 64 83
	stz.b $85		; $80CB20: 64 85
	lda.b $57		; $80CB22: A5 57
	sta.b $84		; $80CB24: 85 84
	bpl CODE_80CB2D		; $80CB26: 10 05
	lda.w #$FFFF		; $80CB28: A9 FF FF
	sta.b $86		; $80CB2B: 85 86
CODE_80CB2D:		; M=16 X=16
	jsl.l $80996C		; $80CB2D: 22 6C 99 80
	sta.b $57		; $80CB31: 85 57
	jsl.l $80CC1E		; $80CB33: 22 1E CC 80
CODE_80CB37:		; M=16 X=16
	pla		; $80CB37: 68
	sta.b $5B		; $80CB38: 85 5B
	pla		; $80CB3A: 68
	sta.b $5F		; $80CB3B: 85 5F
	pla		; $80CB3D: 68
	sta.b $63		; $80CB3E: 85 63
	pla		; $80CB40: 68
	sta.b $67		; $80CB41: 85 67
	lda.w $0D5F,x		; $80CB43: BD 5F 0D
	ora.w $0D7F,x		; $80CB46: 1D 7F 0D
	bne CODE_80CBB0		; $80CB49: D0 65
	lda.w #$0100		; $80CB4B: A9 00 01
	sta.b $53		; $80CB4E: 85 53
	stz.b $57		; $80CB50: 64 57
	lda.b $5F		; $80CB52: A5 5F
	sec		; $80CB54: 38
	sbc.b $67		; $80CB55: E5 67
	bmi CODE_80CB5E		; $80CB57: 30 05
	bvs CODE_80CB60		; $80CB59: 70 05
CODE_80CB5B:		; M=16 X=16
	jmp.w $CC1E		; $80CB5B: 4C 1E CC
CODE_80CB5E:		; M=16 X=16
	bvs CODE_80CB5B		; $80CB5E: 70 FB
CODE_80CB60:		; M=16 X=16
	lda.b $53		; $80CB60: A5 53
	eor.w #$FFFF		; $80CB62: 49 FF FF
	inc a		; $80CB65: 1A
	sta.b $53		; $80CB66: 85 53
	lda.b $67		; $80CB68: A5 67
	eor.w #$FFFF		; $80CB6A: 49 FF FF
	inc a		; $80CB6D: 1A
	sta.b $67		; $80CB6E: 85 67
	sec		; $80CB70: 38
	sbc.b $5F		; $80CB71: E5 5F
	bmi CODE_80CB7A		; $80CB73: 30 05
	bvs CODE_80CB7C		; $80CB75: 70 05
CODE_80CB77:		; M=16 X=16
	jmp.w $CC1E		; $80CB77: 4C 1E CC
CODE_80CB7A:		; M=16 X=16
	bvs CODE_80CB77		; $80CB7A: 70 FB
CODE_80CB7C:		; M=16 X=16
	lda.b $53		; $80CB7C: A5 53
	pha		; $80CB7E: 48
	lda.b $57		; $80CB7F: A5 57
	sta.b $53		; $80CB81: 85 53
	pla		; $80CB83: 68
	sta.b $57		; $80CB84: 85 57
	lda.b $5B		; $80CB86: A5 5B
	sec		; $80CB88: 38
	sbc.b $63		; $80CB89: E5 63
	bmi CODE_80CB92		; $80CB8B: 30 05
	bvs CODE_80CB94		; $80CB8D: 70 05
CODE_80CB8F:		; M=16 X=16
	jmp.w $CC1E		; $80CB8F: 4C 1E CC
CODE_80CB92:		; M=16 X=16
	bvs CODE_80CB8F		; $80CB92: 70 FB
CODE_80CB94:		; M=16 X=16
	lda.b $57		; $80CB94: A5 57
	eor.w #$FFFF		; $80CB96: 49 FF FF
	inc a		; $80CB99: 1A
	sta.b $57		; $80CB9A: 85 57
	lda.b $63		; $80CB9C: A5 63
	eor.w #$FFFF		; $80CB9E: 49 FF FF
	inc a		; $80CBA1: 1A
	sta.b $63		; $80CBA2: 85 63
	sec		; $80CBA4: 38
	sbc.b $5B		; $80CBA5: E5 5B
	bmi CODE_80CBAE		; $80CBA7: 30 05
	bvs CODE_80CBB0		; $80CBA9: 70 05
CODE_80CBAB:		; M=16 X=16
	jmp.w $CC1E		; $80CBAB: 4C 1E CC
CODE_80CBAE:		; M=16 X=16
	bvs CODE_80CBAB		; $80CBAE: 70 FB
CODE_80CBB0:		; M=16 X=16
	rtl		; $80CBB0: 6B
CODE_80CBB1:		; M=16 X=16
	stz.b $73		; $80CBB1: 64 73
	lda.w #$1000		; $80CBB3: A9 00 10
	sta.b $75		; $80CBB6: 85 75
CODE_80CBB8:		; M=16 X=16
	lda.b $73		; $80CBB8: A5 73
	clc		; $80CBBA: 18
	adc.b $75		; $80CBBB: 65 75
	ror a		; $80CBBD: 6A
	cmp.b $73		; $80CBBE: C5 73
	beq CODE_80CBE2		; $80CBC0: F0 20
	sta.b $77		; $80CBC2: 85 77
	sta.b $7D		; $80CBC4: 85 7D
	sta.b $83		; $80CBC6: 85 83
	jsl.l $888942		; $80CBC8: 22 42 89 88
	lda.b $53		; $80CBCC: A5 53
	cmp.b $93		; $80CBCE: C5 93
	lda.b $55		; $80CBD0: A5 55
	sbc.b $95		; $80CBD2: E5 95
	bcs CODE_80CBDC		; $80CBD4: B0 06
	lda.b $77		; $80CBD6: A5 77
	sta.b $75		; $80CBD8: 85 75
	bra CODE_80CBB8		; $80CBDA: 80 DC
CODE_80CBDC:		; M=16 X=16
	lda.b $77		; $80CBDC: A5 77
	sta.b $73		; $80CBDE: 85 73
	bra CODE_80CBB8		; $80CBE0: 80 D6
CODE_80CBE2:		; M=16 X=16
	sta.b $53		; $80CBE2: 85 53
	rtl		; $80CBE4: 6B
CODE_80CBE5:		; M=16 X=16
	lda.b $7D		; $80CBE5: A5 7D
	sta.b $7F		; $80CBE7: 85 7F
	stz.b $7D		; $80CBE9: 64 7D
	lda.w #$0010		; $80CBEB: A9 10 00
	sta.b $95		; $80CBEE: 85 95
CODE_80CBF0:		; M=16 X=16
	asl.b $93		; $80CBF0: 06 93
	lsr.b $7F		; $80CBF2: 46 7F
	ror.b $7D		; $80CBF4: 66 7D
	lda.b $83		; $80CBF6: A5 83
	cmp.b $7D		; $80CBF8: C5 7D
	lda.b $85		; $80CBFA: A5 85
	sbc.b $7F		; $80CBFC: E5 7F
	bcc CODE_80CC0E		; $80CBFE: 90 0E
	lda.b $83		; $80CC00: A5 83
	sbc.b $7D		; $80CC02: E5 7D
	sta.b $83		; $80CC04: 85 83
	lda.b $85		; $80CC06: A5 85
	sbc.b $7F		; $80CC08: E5 7F
	sta.b $85		; $80CC0A: 85 85
	inc.b $93		; $80CC0C: E6 93
CODE_80CC0E:		; M=16 X=16
	dec.b $95		; $80CC0E: C6 95
	bne CODE_80CBF0		; $80CC10: D0 DE
	lda.b $83		; $80CC12: A5 83
	sta.b $95		; $80CC14: 85 95
	lda.b $93		; $80CC16: A5 93
	sta.b $7D		; $80CC18: 85 7D
	sta.b $83		; $80CC1A: 85 83
	clc		; $80CC1C: 18
	rtl		; $80CC1D: 6B
CODE_80CC1E:		; M=16 X=16
	cpx.w #$001C		; $80CC1E: E0 1C 00
	beq CODE_80CC26		; $80CC21: F0 03
	jmp.w $CCDE		; $80CC23: 4C DE CC
CODE_80CC26:		; M=16 X=16
	lda.w $09BB		; $80CC26: AD BB 09
	sec		; $80CC29: 38
	sbc.w #$0020		; $80CC2A: E9 20 00
	beq CODE_80CC37		; $80CC2D: F0 08
	bmi CODE_80CC35		; $80CC2F: 30 04
	bvs CODE_80CC37		; $80CC31: 70 04
	bra CODE_80CCAC		; $80CC33: 80 77
CODE_80CC35:		; M=16 X=16
	bvs CODE_80CCAC		; $80CC35: 70 75
CODE_80CC37:		; M=16 X=16
	lda.w $09BB		; $80CC37: AD BB 09
	cmp.w #$0016		; $80CC3A: C9 16 00
	bcs CODE_80CC42		; $80CC3D: B0 03
	jmp.w $CCDE		; $80CC3F: 4C DE CC
CODE_80CC42:		; M=16 X=16
	lda.w $097B		; $80CC42: AD 7B 09
	sec		; $80CC45: 38
	sbc.w #$0112		; $80CC46: E9 12 01
	bmi CODE_80CC4F		; $80CC49: 30 04
	bvc CODE_80CC51		; $80CC4B: 50 04
	bra CODE_80CCAC		; $80CC4D: 80 5D
CODE_80CC4F:		; M=16 X=16
	bvc CODE_80CCAC		; $80CC4F: 50 5B
CODE_80CC51:		; M=16 X=16
	lda.w $091B		; $80CC51: AD 1B 09
	sec		; $80CC54: 38
	sbc.w #$000D		; $80CC55: E9 0D 00
	bmi CODE_80CC5F		; $80CC58: 30 05
	bvc CODE_80CC61		; $80CC5A: 50 05
CODE_80CC5C:		; M=16 X=16
	jmp.w $CCDE		; $80CC5C: 4C DE CC
CODE_80CC5F:		; M=16 X=16
	bvc CODE_80CC5C		; $80CC5F: 50 FB
CODE_80CC61:		; M=16 X=16
	lda.w $091B		; $80CC61: AD 1B 09
	sec		; $80CC64: 38
	sbc.w #$000F		; $80CC65: E9 0F 00
	beq CODE_80CC72		; $80CC68: F0 08
	bmi CODE_80CC70		; $80CC6A: 30 04
	bvs CODE_80CC72		; $80CC6C: 70 04
	bra CODE_80CCDE		; $80CC6E: 80 6E
CODE_80CC70:		; M=16 X=16
	bvs CODE_80CCDE		; $80CC70: 70 6C
CODE_80CC72:		; M=16 X=16
	lda.w $0B1B		; $80CC72: AD 1B 0B
	sec		; $80CC75: 38
	sbc.w #$0FA0		; $80CC76: E9 A0 0F
	bmi CODE_80CC7F		; $80CC79: 30 04
	bvc CODE_80CC81		; $80CC7B: 50 04
	bra CODE_80CCDE		; $80CC7D: 80 5F
CODE_80CC7F:		; M=16 X=16
	bvc CODE_80CCDE		; $80CC7F: 50 5D
CODE_80CC81:		; M=16 X=16
	phx		; $80CC81: DA
	lda.w $0B1B		; $80CC82: AD 1B 0B
	pha		; $80CC85: 48
	asl a		; $80CC86: 0A
	pla		; $80CC87: 68
	ror a		; $80CC88: 6A
	sta.w $0B1B		; $80CC89: 8D 1B 0B
	inx		; $80CC8C: E8
	inx		; $80CC8D: E8
	stx.b $3F		; $80CC8E: 86 3F
	lda.w #$146A		; $80CC90: A9 6A 14
	sta.b $57		; $80CC93: 85 57
	jsl.l $80B006		; $80CC95: 22 06 B0 80
	plx		; $80CC99: FA
	stx.b $3F		; $80CC9A: 86 3F
	lda.w #$008C		; $80CC9C: A9 8C 00
	pha		; $80CC9F: 48
	jsl.l $80C28B		; $80CCA0: 22 8B C2 80
	lda.b $DE		; $80CCA4: A5 DE
	clc		; $80CCA6: 18
	adc.w #$0258		; $80CCA7: 69 58 02
	sta.b $DE		; $80CCAA: 85 DE
CODE_80CCAC:		; M=16 X=16
	lda.w #$0040		; $80CCAC: A9 40 00
	tsb.w $128C		; $80CCAF: 0C 8C 12
	sta.w $121B		; $80CCB2: 8D 1B 12
	lda.w $097B		; $80CCB5: AD 7B 09
	bpl CODE_80CCC0		; $80CCB8: 10 06
	lda.w #$8000		; $80CCBA: A9 00 80
	tsb.w $09FB		; $80CCBD: 0C FB 09
CODE_80CCC0:		; M=16 X=16
	stz.w $095D		; $80CCC0: 9C 5D 09
	lda.w $128A		; $80CCC3: AD 8A 12
	bne CODE_80CCDD		; $80CCC6: D0 15
	lda.w $018B		; $80CCC8: AD 8B 01
	asl a		; $80CCCB: 0A
	sta.b $3F		; $80CCCC: 85 3F
	tax		; $80CCCE: AA
	lda.w #$0006		; $80CCCF: A9 06 00
	sta.b $53		; $80CCD2: 85 53
	jsl.l $80C1B0		; $80CCD4: 22 B0 C1 80
	ldx.w #$001C		; $80CCD8: A2 1C 00
	stx.b $3F		; $80CCDB: 86 3F
CODE_80CCDD:		; M=16 X=16
	rtl		; $80CCDD: 6B
CODE_80CCDE:		; M=16 X=16
	lda.b $53		; $80CCDE: A5 53
	sta.w $0D5F,x		; $80CCE0: 9D 5F 0D
	lda.b $57		; $80CCE3: A5 57
	sta.w $0D7F,x		; $80CCE5: 9D 7F 0D
	stx.b $0A		; $80CCE8: 86 0A
	ldx.w #$0000		; $80CCEA: A2 00 00
CODE_80CCED:		; M=16 X=16
	lda.b $5B,x		; $80CCED: B5 5B
	pha		; $80CCEF: 48
	inx		; $80CCF0: E8
	inx		; $80CCF1: E8
	cpx.w #$0008		; $80CCF2: E0 08 00
	bne CODE_80CCED		; $80CCF5: D0 F6
	ldx.b $0A		; $80CCF7: A6 0A
	lda.b $57		; $80CCF9: A5 57
	pha		; $80CCFB: 48
	lda.b $53		; $80CCFC: A5 53
	pha		; $80CCFE: 48
	sta.b $83		; $80CCFF: 85 83
	lda.w $0AFF,x		; $80CD01: BD FF 0A
	sta.b $7D		; $80CD04: 85 7D
	jsl.l $82FCDB		; $80CD06: 22 DB FC 82
	sta.b $53		; $80CD0A: 85 53
	lda.b $95		; $80CD0C: A5 95
	sta.b $55		; $80CD0E: 85 55
	lda.w $0ADF,x		; $80CD10: BD DF 0A
	sta.b $7D		; $80CD13: 85 7D
	lda.b $57		; $80CD15: A5 57
	sta.b $83		; $80CD17: 85 83
	jsl.l $82FCDB		; $80CD19: 22 DB FC 82
	lda.b $53		; $80CD1D: A5 53
	sec		; $80CD1F: 38
	sbc.b $93		; $80CD20: E5 93
	sta.b $53		; $80CD22: 85 53
	lda.b $55		; $80CD24: A5 55
	sbc.b $95		; $80CD26: E5 95
	sta.b $55		; $80CD28: 85 55
	lda.b $54		; $80CD2A: A5 54
	eor.w #$FFFF		; $80CD2C: 49 FF FF
	inc a		; $80CD2F: 1A
	sta.b $5B		; $80CD30: 85 5B
	lda.w $0ADF,x		; $80CD32: BD DF 0A
	sta.b $7D		; $80CD35: 85 7D
	lda.b $01,s		; $80CD37: A3 01
	sta.b $83		; $80CD39: 85 83
	jsl.l $82FCDB		; $80CD3B: 22 DB FC 82
	sta.b $53		; $80CD3F: 85 53
	lda.b $95		; $80CD41: A5 95
	sta.b $55		; $80CD43: 85 55
	lda.w $0AFF,x		; $80CD45: BD FF 0A
	sta.b $7D		; $80CD48: 85 7D
	lda.b $57		; $80CD4A: A5 57
	sta.b $83		; $80CD4C: 85 83
	jsl.l $82FCDB		; $80CD4E: 22 DB FC 82
	adc.b $53		; $80CD52: 65 53
	sta.b $53		; $80CD54: 85 53
	lda.b $55		; $80CD56: A5 55
	adc.b $95		; $80CD58: 65 95
	sta.b $55		; $80CD5A: 85 55
	lda.b $54		; $80CD5C: A5 54
	sta.b $5F		; $80CD5E: 85 5F
	cpx.w #$001C		; $80CD60: E0 1C 00
	beq CODE_80CD68		; $80CD63: F0 03
	jmp.w $CDF5		; $80CD65: 4C F5 CD
CODE_80CD68:		; M=16 X=16
	lda.w #$1000		; $80CD68: A9 00 10
	trb.w $128C		; $80CD6B: 1C 8C 12
	lda.b $5B		; $80CD6E: A5 5B
	bmi CODE_80CD75		; $80CD70: 30 03
	jmp.w $CEB8		; $80CD72: 4C B8 CE
CODE_80CD75:		; M=16 X=16
	lsr a		; $80CD75: 4A
	lsr a		; $80CD76: 4A
	bit.w #$2000		; $80CD77: 89 00 20
	beq CODE_80CD7F		; $80CD7A: F0 03
	ora.w #$C000		; $80CD7C: 09 00 C0
CODE_80CD7F:		; M=16 X=16
	sta.b $5B		; $80CD7F: 85 5B
	sec		; $80CD81: 38
	sbc.w #$FC00		; $80CD82: E9 00 FC
	beq CODE_80CD8F		; $80CD85: F0 08
	bmi CODE_80CD8D		; $80CD87: 30 04
	bvs CODE_80CD8F		; $80CD89: 70 04
	bra CODE_80CDD1		; $80CD8B: 80 44
CODE_80CD8D:		; M=16 X=16
	bvs CODE_80CDD1		; $80CD8D: 70 42
CODE_80CD8F:		; M=16 X=16
	lda.w #$0800		; $80CD8F: A9 00 08
	jsl.l $80AE8B		; $80CD92: 22 8B AE 80
	eor.w #$FFFF		; $80CD96: 49 FF FF
	inc a		; $80CD99: 1A
	sta.w $0B3B		; $80CD9A: 8D 3B 0B
	sta.b $53		; $80CD9D: 85 53
	jsl.l $80CEC9		; $80CD9F: 22 C9 CE 80
	lda.w #$0095		; $80CDA3: A9 95 00
	pha		; $80CDA6: 48
	lda.b $5B		; $80CDA7: A5 5B
	sec		; $80CDA9: 38
	sbc.w #$EE00		; $80CDAA: E9 00 EE
	bmi CODE_80CDB3		; $80CDAD: 30 04
	bvc CODE_80CDB5		; $80CDAF: 50 04
	bra CODE_80CDCD		; $80CDB1: 80 1A
CODE_80CDB3:		; M=16 X=16
	bvc CODE_80CDCD		; $80CDB3: 50 18
CODE_80CDB5:		; M=16 X=16
	pla		; $80CDB5: 68
	lda.w #$0096		; $80CDB6: A9 96 00
	pha		; $80CDB9: 48
	lda.b $5B		; $80CDBA: A5 5B
	sec		; $80CDBC: 38
	sbc.w #$F800		; $80CDBD: E9 00 F8
	bmi CODE_80CDC6		; $80CDC0: 30 04
	bvc CODE_80CDC8		; $80CDC2: 50 04
	bra CODE_80CDCD		; $80CDC4: 80 07
CODE_80CDC6:		; M=16 X=16
	bvc CODE_80CDCD		; $80CDC6: 50 05
CODE_80CDC8:		; M=16 X=16
	pla		; $80CDC8: 68
	lda.w #$0097		; $80CDC9: A9 97 00
	pha		; $80CDCC: 48
CODE_80CDCD:		; M=16 X=16
	jsl.l $80C28B		; $80CDCD: 22 8B C2 80
CODE_80CDD1:		; M=16 X=16
	lda.b $5F		; $80CDD1: A5 5F
	lsr a		; $80CDD3: 4A
	lsr a		; $80CDD4: 4A
	lsr a		; $80CDD5: 4A
	lsr a		; $80CDD6: 4A
	lsr a		; $80CDD7: 4A
	lsr a		; $80CDD8: 4A
	bit.w #$0200		; $80CDD9: 89 00 02
	beq CODE_80CDE1		; $80CDDC: F0 03
	ora.w #$FC00		; $80CDDE: 09 00 FC
CODE_80CDE1:		; M=16 X=16
	sta.b $53		; $80CDE1: 85 53
	pha		; $80CDE3: 48
	asl a		; $80CDE4: 0A
	pla		; $80CDE5: 68
	ror a		; $80CDE6: 6A
	sta.b $55		; $80CDE7: 85 55
	lda.b $5F		; $80CDE9: A5 5F
	sec		; $80CDEB: 38
	sbc.b $53		; $80CDEC: E5 53
	sec		; $80CDEE: 38
	sbc.b $55		; $80CDEF: E5 55
	sta.b $5F		; $80CDF1: 85 5F
	bra CODE_80CE53		; $80CDF3: 80 5E
CODE_80CDF5:		; M=16 X=16
	lda.b $5B		; $80CDF5: A5 5B
	sec		; $80CDF7: 38
	sbc.w #$03E8		; $80CDF8: E9 E8 03
	beq CODE_80CE06		; $80CDFB: F0 09
	bmi CODE_80CE04		; $80CDFD: 30 05
	bvs CODE_80CE06		; $80CDFF: 70 05
CODE_80CE01:		; M=16 X=16
	jmp.w $CEB8		; $80CE01: 4C B8 CE
CODE_80CE04:		; M=16 X=16
	bvs CODE_80CE01		; $80CE04: 70 FB
CODE_80CE06:		; M=16 X=16
	lda.b $5B		; $80CE06: A5 5B
	sec		; $80CE08: 38
	sbc.w #$F000		; $80CE09: E9 00 F0
	beq CODE_80CE16		; $80CE0C: F0 08
	bmi CODE_80CE14		; $80CE0E: 30 04
	bvs CODE_80CE16		; $80CE10: 70 04
	bra CODE_80CE34		; $80CE12: 80 20
CODE_80CE14:		; M=16 X=16
	bvs CODE_80CE34		; $80CE14: 70 1E
CODE_80CE16:		; M=16 X=16
	lda.w $0B7F,x		; $80CE16: BD 7F 0B
	sec		; $80CE19: 38
	sbc.w #$000A		; $80CE1A: E9 0A 00
	bmi CODE_80CE23		; $80CE1D: 30 04
	bvc CODE_80CE25		; $80CE1F: 50 04
	bra CODE_80CE34		; $80CE21: 80 11
CODE_80CE23:		; M=16 X=16
	bvc CODE_80CE34		; $80CE23: 50 0F
CODE_80CE25:		; M=16 X=16
	lda.w $04A2		; $80CE25: AD A2 04
	and.w #$0001		; $80CE28: 29 01 00
	clc		; $80CE2B: 18
	adc.w #$009E		; $80CE2C: 69 9E 00
	pha		; $80CE2F: 48
	jsl.l $80C28B		; $80CE30: 22 8B C2 80
CODE_80CE34:		; M=16 X=16
	lda.b $5B		; $80CE34: A5 5B
	lsr a		; $80CE36: 4A
	lsr a		; $80CE37: 4A
	bit.w #$2000		; $80CE38: 89 00 20
	beq CODE_80CE40		; $80CE3B: F0 03
	ora.w #$C000		; $80CE3D: 09 00 C0
CODE_80CE40:		; M=16 X=16
	sta.b $5B		; $80CE40: 85 5B
	sec		; $80CE42: 38
	sbc.w #$FC7C		; $80CE43: E9 7C FC
	bmi CODE_80CE4C		; $80CE46: 30 04
	bvc CODE_80CE4E		; $80CE48: 50 04
	bra CODE_80CE53		; $80CE4A: 80 07
CODE_80CE4C:		; M=16 X=16
	bvc CODE_80CE53		; $80CE4C: 50 05
CODE_80CE4E:		; M=16 X=16
	lda.w #$FC18		; $80CE4E: A9 18 FC
	sta.b $5B		; $80CE51: 85 5B
CODE_80CE53:		; M=16 X=16
	lda.b $01,s		; $80CE53: A3 01
	sta.b $7D		; $80CE55: 85 7D
	lda.b $5F		; $80CE57: A5 5F
	sta.b $83		; $80CE59: 85 83
	jsl.l $82FCDB		; $80CE5B: 22 DB FC 82
	sta.b $73		; $80CE5F: 85 73
	lda.b $95		; $80CE61: A5 95
	sta.b $75		; $80CE63: 85 75
	lda.b $03,s		; $80CE65: A3 03
	sta.b $7D		; $80CE67: 85 7D
	lda.b $5B		; $80CE69: A5 5B
	sta.b $83		; $80CE6B: 85 83
	jsl.l $82FCDB		; $80CE6D: 22 DB FC 82
	lda.b $73		; $80CE71: A5 73
	sec		; $80CE73: 38
	sbc.b $93		; $80CE74: E5 93
	sta.b $73		; $80CE76: 85 73
	lda.b $75		; $80CE78: A5 75
	sbc.b $95		; $80CE7A: E5 95
	sta.b $75		; $80CE7C: 85 75
	lda.b $74		; $80CE7E: A5 74
	sta.w $0ADF,x		; $80CE80: 9D DF 0A
	lda.b $03,s		; $80CE83: A3 03
	sta.b $7D		; $80CE85: 85 7D
	lda.b $5F		; $80CE87: A5 5F
	sta.b $83		; $80CE89: 85 83
	jsl.l $82FCDB		; $80CE8B: 22 DB FC 82
	sta.b $5F		; $80CE8F: 85 5F
	lda.b $95		; $80CE91: A5 95
	sta.b $61		; $80CE93: 85 61
	lda.b $01,s		; $80CE95: A3 01
	sta.b $7D		; $80CE97: 85 7D
	lda.b $5B		; $80CE99: A5 5B
	sta.b $83		; $80CE9B: 85 83
	jsl.l $82FCDB		; $80CE9D: 22 DB FC 82
	adc.b $5F		; $80CEA1: 65 5F
	sta.b $5F		; $80CEA3: 85 5F
	lda.b $61		; $80CEA5: A5 61
	adc.b $95		; $80CEA7: 65 95
	sta.b $61		; $80CEA9: 85 61
	lda.b $60		; $80CEAB: A5 60
	sta.w $0AFF,x		; $80CEAD: 9D FF 0A
	lda.w $0B1F,x		; $80CEB0: BD 1F 0B
	bmi CODE_80CEB8		; $80CEB3: 30 03
	stz.w $0B1F,x		; $80CEB5: 9E 1F 0B
CODE_80CEB8:		; M=16 X=16
	pla		; $80CEB8: 68
	pla		; $80CEB9: 68
	stx.b $0A		; $80CEBA: 86 0A
	ldx.w #$0006		; $80CEBC: A2 06 00
CODE_80CEBF:		; M=16 X=16
	pla		; $80CEBF: 68
	sta.b $5B,x		; $80CEC0: 95 5B
	dex		; $80CEC2: CA
	dex		; $80CEC3: CA
	bpl CODE_80CEBF		; $80CEC4: 10 F9
	ldx.b $0A		; $80CEC6: A6 0A
	rtl		; $80CEC8: 6B
CODE_80CEC9:		; M=16 X=16
	lda.b $53		; $80CEC9: A5 53
	and.w #$0001		; $80CECB: 29 01 00
	sta.b $53		; $80CECE: 85 53
	eor.w $0DDB		; $80CED0: 4D DB 0D
	and.w #$0003		; $80CED3: 29 03 00
	sta.w $0DDB		; $80CED6: 8D DB 0D
	lda.w #$FFFF		; $80CED9: A9 FF FF
	sta.w $0E5B		; $80CEDC: 8D 5B 0E
	lda.w #$03D6		; $80CEDF: A9 D6 03
	sta.b $57		; $80CEE2: 85 57
	jmp.w $B006		; $80CEE4: 4C 06 B0
CODE_80CEE7:		; M=16 X=16
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
