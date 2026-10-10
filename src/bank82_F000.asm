; $82F93C-$82FFFF  ROM $1793C  (from src/bank82.asm; quick pass, TODO segment agents refine). Starts at the code after the packed rink tiles (boundary moved from $82F000)
org $82F93C
CODE_82F93C:		; M=16 X=16
	phx		; $82F93C: DA
	stx.b $0A		; $82F93D: 86 0A
	ldx.w #$0000		; $82F93F: A2 00 00
CODE_82F942:		; M=16 X=16
	lda.b $53,x		; $82F942: B5 53
	pha		; $82F944: 48
	inx		; $82F945: E8
	inx		; $82F946: E8
	cpx.w #$000C		; $82F947: E0 0C 00
	bne CODE_82F942		; $82F94A: D0 F6
	ldx.b $0A		; $82F94C: A6 0A
	stx.b $0A		; $82F94E: 86 0A
	ldx.w #$0000		; $82F950: A2 00 00
CODE_82F953:		; M=16 X=16
	lda.b $33,x		; $82F953: B5 33
	pha		; $82F955: 48
	inx		; $82F956: E8
	inx		; $82F957: E8
	cpx.w #$0008		; $82F958: E0 08 00
	bne CODE_82F953		; $82F95B: D0 F6
	ldx.b $0A		; $82F95D: A6 0A
	lda.w #$0040		; $82F95F: A9 40 00
	sta.b $53		; $82F962: 85 53
	lda.w $12EC		; $82F964: AD EC 12
	bmi CODE_82F9AF		; $82F967: 30 46
	sta.b $53		; $82F969: 85 53
	inc.w $12EC		; $82F96B: EE EC 12
	inc.w $12EC		; $82F96E: EE EC 12
	lda.w $12EE		; $82F971: AD EE 12
	sta.b $57		; $82F974: 85 57
	tax		; $82F976: AA
	lda.l $80BF6A,x		; $82F977: BF 6A BF 80
	inc a		; $82F97B: 1A
	inc a		; $82F97C: 1A
	tax		; $82F97D: AA
	clc		; $82F97E: 18
	adc.l $80BF6A,x		; $82F97F: 7F 6A BF 80
	adc.b $53		; $82F983: 65 53
	tax		; $82F985: AA
	lda.l $80BF6A,x		; $82F986: BF 6A BF 80
	sta.b $53		; $82F98A: 85 53
	bpl CODE_82F99A		; $82F98C: 10 0C
	eor.w #$FFFF		; $82F98E: 49 FF FF
	inc a		; $82F991: 1A
	sta.b $53		; $82F992: 85 53
	lda.w #$FFFF		; $82F994: A9 FF FF
	sta.w $12EC		; $82F997: 8D EC 12
CODE_82F99A:		; M=16 X=16
	lda.b $53		; $82F99A: A5 53
	and.w #$00FF		; $82F99C: 29 FF 00
	asl a		; $82F99F: 0A
	asl a		; $82F9A0: 0A
	asl a		; $82F9A1: 0A
	sta.b $57		; $82F9A2: 85 57
	sta.w $12EA		; $82F9A4: 8D EA 12
	lda.b $53		; $82F9A7: A5 53
	xba		; $82F9A9: EB
	and.w #$00FF		; $82F9AA: 29 FF 00
	sta.b $53		; $82F9AD: 85 53
CODE_82F9AF:		; M=16 X=16
	jsl.l $8F83A7		; $82F9AF: 22 A7 83 8F
	stx.b $0A		; $82F9B3: 86 0A
	ldx.w #$0006		; $82F9B5: A2 06 00
CODE_82F9B8:		; M=16 X=16
	pla		; $82F9B8: 68
	sta.b $33,x		; $82F9B9: 95 33
	dex		; $82F9BB: CA
	dex		; $82F9BC: CA
	bpl CODE_82F9B8		; $82F9BD: 10 F9
	ldx.b $0A		; $82F9BF: A6 0A
	stx.b $0A		; $82F9C1: 86 0A
	ldx.w #$000A		; $82F9C3: A2 0A 00
CODE_82F9C6:		; M=16 X=16
	pla		; $82F9C6: 68
	sta.b $53,x		; $82F9C7: 95 53
	dex		; $82F9C9: CA
	dex		; $82F9CA: CA
	bpl CODE_82F9C6		; $82F9CB: 10 F9
	ldx.b $0A		; $82F9CD: A6 0A
	plx		; $82F9CF: FA
	rtl		; $82F9D0: 6B
CODE_82F9D1:		; M=16 X=16
	jsl.l $85D5A4		; $82F9D1: 22 A4 D5 85
	lda.b $57		; $82F9D5: A5 57
	sta.w $08D7		; $82F9D7: 8D D7 08
	asl a		; $82F9DA: 0A
	sta.b $33		; $82F9DB: 85 33
CODE_82F9DD:		; M=16 X=16
	lda.b $57		; $82F9DD: A5 57
	cmp.w $014C		; $82F9DF: CD 4C 01
	beq CODE_82F9F8		; $82F9E2: F0 14
	ldy.b $33		; $82F9E4: A4 33
	lda.w $15EF,y		; $82F9E6: B9 EF 15
	and.w #$FFFD		; $82F9E9: 29 FD FF
	sta.w $15EF,y		; $82F9EC: 99 EF 15
	bit.w #$0004		; $82F9EF: 89 04 00
	bne CODE_82F9F8		; $82F9F2: D0 04
	jsl.l $8AFE21		; $82F9F4: 22 21 FE 8A
CODE_82F9F8:		; M=16 X=16
	dec.b $33		; $82F9F8: C6 33
	dec.b $33		; $82F9FA: C6 33
	dec.b $57		; $82F9FC: C6 57
	bpl CODE_82F9DD		; $82F9FE: 10 DD
	rtl		; $82FA00: 6B
	db $A2,$0F,$00,$A9,$1E,$00,$85,$53,$22,$FA,$F5,$80,$E2,$20,$A5,$53	; $82FA01
	db $9D,$10,$16,$C2,$30,$CA,$10,$EB,$6B	; $82FA11
CODE_82FA1A:		; M=16 X=16
	lda.w #$0001		; $82FA1A: A9 01 00
	sta.b $21		; $82FA1D: 85 21
	stz.w $1651		; $82FA1F: 9C 51 16
	stz.w $04A9		; $82FA22: 9C A9 04
	stz.b $23		; $82FA25: 64 23
	stz.b $1F		; $82FA27: 64 1F
	lda.w #$0002		; $82FA29: A9 02 00
	sta.b $1D		; $82FA2C: 85 1D
	stz.b $21		; $82FA2E: 64 21
	rtl		; $82FA30: 6B
CODE_82FA31:		; M=16 X=16
	phy		; $82FA31: 5A
	phx		; $82FA32: DA
	pha		; $82FA33: 48
CODE_82FA34:		; M=16 X=16
	lda.b $04		; $82FA34: A5 04
	cmp.w #$000F		; $82FA36: C9 0F 00
	beq CODE_82FA3D		; $82FA39: F0 02
	stz.b $04		; $82FA3B: 64 04
CODE_82FA3D:		; M=16 X=16
	lda.b $1D		; $82FA3D: A5 1D
	cmp.b $1F		; $82FA3F: C5 1F
	bne CODE_82FA34		; $82FA41: D0 F1
	lda.b $00		; $82FA43: A5 00
CODE_82FA45:		; M=16 X=16
	cmp.b $00		; $82FA45: C5 00
	beq CODE_82FA45		; $82FA47: F0 FC
	lda.w #$0001		; $82FA49: A9 01 00
	sta.b $21		; $82FA4C: 85 21
	lda.w #$0002		; $82FA4E: A9 02 00
	sta.w $164F		; $82FA51: 8D 4F 16
	stz.w $1651		; $82FA54: 9C 51 16
	lda.w #$8000		; $82FA57: A9 00 80
	sta.b $1A		; $82FA5A: 85 1A
	lda.w #$8680		; $82FA5C: A9 80 86
	sta.b $1B		; $82FA5F: 85 1B
	jsl.l $82FAB9		; $82FA61: 22 B9 FA 82
	sep #$20		; $82FA65: E2 20
	lda.b #$81		; $82FA67: A9 81
	sta.w $4200		; $82FA69: 8D 00 42
	rep #$30		; $82FA6C: C2 30
	lda.b $00		; $82FA6E: A5 00
	inc a		; $82FA70: 1A
	inc a		; $82FA71: 1A
CODE_82FA72:		; M=16 X=16
	cmp.b $00		; $82FA72: C5 00
	bne CODE_82FA72		; $82FA74: D0 FC
	pla		; $82FA76: 68
	plx		; $82FA77: FA
	ply		; $82FA78: 7A
	rtl		; $82FA79: 6B
CODE_82FA7A:		; M=16 X=16
	phy		; $82FA7A: 5A
	phx		; $82FA7B: DA
	pha		; $82FA7C: 48
CODE_82FA7D:		; M=16 X=16
	lda.b $1D		; $82FA7D: A5 1D
	cmp.b $1F		; $82FA7F: C5 1F
	bne CODE_82FA7D		; $82FA81: D0 FA
	lda.b $00		; $82FA83: A5 00
	clc		; $82FA85: 18
	adc.w #$0006		; $82FA86: 69 06 00
CODE_82FA89:		; M=16 X=16
	cmp.b $00		; $82FA89: C5 00
	bne CODE_82FA89		; $82FA8B: D0 FC
	lda.w #$0001		; $82FA8D: A9 01 00
	sta.b $21		; $82FA90: 85 21
	sta.w $164F		; $82FA92: 8D 4F 16
	stz.w $1651		; $82FA95: 9C 51 16
	lda.w #$8000		; $82FA98: A9 00 80
	sta.b $1A		; $82FA9B: 85 1A
	lda.w #$8180		; $82FA9D: A9 80 81
	sta.b $1B		; $82FAA0: 85 1B
	jsl.l $82FAB9		; $82FAA2: 22 B9 FA 82
	sep #$20		; $82FAA6: E2 20
	lda.b #$81		; $82FAA8: A9 81
	sta.w $4200		; $82FAAA: 8D 00 42
	rep #$30		; $82FAAD: C2 30
	lda.w #$000A		; $82FAAF: A9 0A 00
	sta.w $049F		; $82FAB2: 8D 9F 04
	pla		; $82FAB5: 68
	plx		; $82FAB6: FA
	ply		; $82FAB7: 7A
	rtl		; $82FAB8: 6B
CODE_82FAB9:		; M=16 X=16
	stz.w $1651		; $82FAB9: 9C 51 16
	sep #$20		; $82FABC: E2 20
	stz.w $4200		; $82FABE: 9C 00 42
	lda.b #$01		; $82FAC1: A9 01
	sta.b $12		; $82FAC3: 85 12
	sta.b $21		; $82FAC5: 85 21
	stz.b $1D		; $82FAC7: 64 1D
	stz.b $1F		; $82FAC9: 64 1F
	lda.b #$F8		; $82FACB: A9 F8
	sta.w $2140		; $82FACD: 8D 40 21
	rep #$30		; $82FAD0: C2 30
	ldy.w #$0000		; $82FAD2: A0 00 00
	lda.w #$BBAA		; $82FAD5: A9 AA BB
	jmp.w $FADB		; $82FAD8: 4C DB FA
CODE_82FADB:		; M=16 X=16
	cmp.w $2140		; $82FADB: CD 40 21
	bne CODE_82FADB		; $82FADE: D0 FB
	lda.w #$00CC		; $82FAE0: A9 CC 00
	bra CODE_82FB30		; $82FAE3: 80 4B
CODE_82FAE5:		; M=8 X=16
	sep #$20		; $82FAE5: E2 20
	lda.b [$1A],y		; $82FAE7: B7 1A
	iny		; $82FAE9: C8
	bpl CODE_82FAF4		; $82FAEA: 10 08
	ldy.w #$0000		; $82FAEC: A0 00 00
	inc.b $1C		; $82FAEF: E6 1C
	jmp.w $FAF4		; $82FAF1: 4C F4 FA
CODE_82FAF4:		; M=8 X=16
	xba		; $82FAF4: EB
	lda.b #$00		; $82FAF5: A9 00
	bra CODE_82FB14		; $82FAF7: 80 1B
CODE_82FAF9:		; M=8 X=16
	xba		; $82FAF9: EB
	lda.b [$1A],y		; $82FAFA: B7 1A
	iny		; $82FAFC: C8
	bpl CODE_82FB07		; $82FAFD: 10 08
	ldy.w #$0000		; $82FAFF: A0 00 00
	inc.b $1C		; $82FB02: E6 1C
	jmp.w $FB07		; $82FB04: 4C 07 FB
CODE_82FB07:		; M=8 X=16
	xba		; $82FB07: EB
	jmp.w $FB0B		; $82FB08: 4C 0B FB
CODE_82FB0B:		; M=8 X=16
	cmp.w $2140		; $82FB0B: CD 40 21
	bne CODE_82FB0B		; $82FB0E: D0 FB
	inc a		; $82FB10: 1A
	jmp.w $FB14		; $82FB11: 4C 14 FB
CODE_82FB14:		; M=8 X=16
	rep #$30		; $82FB14: C2 30
	sta.w $2140		; $82FB16: 8D 40 21
	sep #$20		; $82FB19: E2 20
	dex		; $82FB1B: CA
	bne CODE_82FAF9		; $82FB1C: D0 DB
	jmp.w $FB21		; $82FB1E: 4C 21 FB
CODE_82FB21:		; M=8 X=16
	cmp.w $2140		; $82FB21: CD 40 21
	bne CODE_82FB21		; $82FB24: D0 FB
	jmp.w $FB29		; $82FB26: 4C 29 FB
CODE_82FB29:		; M=8 X=16
	adc.b #$03		; $82FB29: 69 03
	beq CODE_82FB29		; $82FB2B: F0 FC
	jmp.w $FB30		; $82FB2D: 4C 30 FB
CODE_82FB30:		; M=16 X=16
	sep #$20		; $82FB30: E2 20
	pha		; $82FB32: 48
	rep #$30		; $82FB33: C2 30
	lda.b [$1A],y		; $82FB35: B7 1A
	tax		; $82FB37: AA
	iny		; $82FB38: C8
	iny		; $82FB39: C8
	bpl CODE_82FB43		; $82FB3A: 10 07
	tya		; $82FB3C: 98
	and.w #$7FFF		; $82FB3D: 29 FF 7F
	tay		; $82FB40: A8
	inc.b $1C		; $82FB41: E6 1C
CODE_82FB43:		; M=16 X=16
	lda.b [$1A],y		; $82FB43: B7 1A
	sta.w $2142		; $82FB45: 8D 42 21
	iny		; $82FB48: C8
	iny		; $82FB49: C8
	bpl CODE_82FB53		; $82FB4A: 10 07
	tya		; $82FB4C: 98
	and.w #$7FFF		; $82FB4D: 29 FF 7F
	tay		; $82FB50: A8
	inc.b $1C		; $82FB51: E6 1C
CODE_82FB53:		; M=16 X=16
	sep #$20		; $82FB53: E2 20
	cpx.w #$0001		; $82FB55: E0 01 00
	lda.b #$00		; $82FB58: A9 00
	rol a		; $82FB5A: 2A
	sta.w $2141		; $82FB5B: 8D 41 21
	adc.b #$7F		; $82FB5E: 69 7F
	pla		; $82FB60: 68
	sta.w $2140		; $82FB61: 8D 40 21
	jmp.w $FB67		; $82FB64: 4C 67 FB
CODE_82FB67:		; M=8 X=16
	cmp.w $2140		; $82FB67: CD 40 21
	bne CODE_82FB67		; $82FB6A: D0 FB
	bvc CODE_82FB71		; $82FB6C: 50 03
	jmp.w $FAE5		; $82FB6E: 4C E5 FA
CODE_82FB71:		; M=8 X=16
	rep #$30		; $82FB71: C2 30
	stz.w $2140		; $82FB73: 9C 40 21
	stz.b $12		; $82FB76: 64 12
	rtl		; $82FB78: 6B
CODE_82FB79:		; M=16 X=16
	phx		; $82FB79: DA
	ldx.w $04A9		; $82FB7A: AE A9 04
	bne CODE_82FBA4		; $82FB7D: D0 25
	phy		; $82FB7F: 5A
	pha		; $82FB80: 48
	ldx.w #$0001		; $82FB81: A2 01 00
	stx.b $21		; $82FB84: 86 21
	cpx.w $164F		; $82FB86: EC 4F 16
	beq CODE_82FB94		; $82FB89: F0 09
	cmp.w #$00A2		; $82FB8B: C9 A2 00
	bcs CODE_82FB94		; $82FB8E: B0 04
	jsl.l $82FA7A		; $82FB90: 22 7A FA 82
CODE_82FB94:		; M=16 X=16
	ldx.b $1D		; $82FB94: A6 1D
	pla		; $82FB96: 68
	sta.b $23,x		; $82FB97: 95 23
	txa		; $82FB99: 8A
	inc a		; $82FB9A: 1A
	inc a		; $82FB9B: 1A
	and.w #$000F		; $82FB9C: 29 0F 00
	sta.b $1D		; $82FB9F: 85 1D
	stz.b $21		; $82FBA1: 64 21
	ply		; $82FBA3: 7A
CODE_82FBA4:		; M=16 X=16
	plx		; $82FBA4: FA
	rtl		; $82FBA5: 6B
	db $42,$43,$44,$46,$47,$48,$4A,$4B,$4C,$4D,$4E,$50,$52,$53,$54,$56	; $82FBA6
	db $57,$58,$59,$5A,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$2D	; $82FBB6
CODE_82FBC5:		; M=16 X=16
	jsl.l $82FBEA		; $82FBC5: 22 EA FB 82
	ldx.w #$0000		; $82FBC9: A2 00 00
CODE_82FBCC:		; M=16 X=16
	lda.w #$001E		; $82FBCC: A9 1E 00
	sta.b $53		; $82FBCF: 85 53
	jsl.l $888853		; $82FBD1: 22 53 88 88
	lda.w $1610,x		; $82FBD5: BD 10 16
	and.w #$00FF		; $82FBD8: 29 FF 00
	sta.b $53		; $82FBDB: 85 53
	stz.b $55		; $82FBDD: 64 55
	jsl.l $88FDB2		; $82FBDF: 22 B2 FD 88
	inx		; $82FBE3: E8
	cpx.w #$0010		; $82FBE4: E0 10 00
	bne CODE_82FBCC		; $82FBE7: D0 E3
	rtl		; $82FBE9: 6B
CODE_82FBEA:		; M=16 X=16
	stz.w $1624		; $82FBEA: 9C 24 16
	stz.w $1626		; $82FBED: 9C 26 16
	stz.w $1628		; $82FBF0: 9C 28 16
	stz.w $162A		; $82FBF3: 9C 2A 16
	stz.w $162C		; $82FBF6: 9C 2C 16
	stz.w $162E		; $82FBF9: 9C 2E 16
	stz.w $1630		; $82FBFC: 9C 30 16
	stz.w $1632		; $82FBFF: 9C 32 16
	rtl		; $82FC02: 6B
	db $86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$08,$00,$D0,$F6,$A6	; $82FC03
	db $0A,$A5,$53,$A6,$57,$85,$57,$86,$53,$22,$53,$88,$88,$64,$55,$A5	; $82FC13
	db $57,$85,$53,$22,$B2,$FD,$88,$86,$0A,$A2,$06,$00,$68,$95,$53,$CA	; $82FC23
	db $CA,$10,$F9,$A6,$0A,$6B,$01,$00,$02,$00,$04,$00,$08,$00,$10,$00	; $82FC33
	db $20,$00,$40,$00,$80,$00,$00,$01,$00,$02,$00,$04,$00,$08,$00,$10	; $82FC43
	db $00,$20,$00,$40,$00,$80,$22,$8D,$86,$88,$22,$12,$F5,$88,$AD,$00	; $82FC53
	db $16,$C9,$01,$00,$F0,$04,$5C,$87,$FA,$83,$AD,$4C,$01,$10,$04,$5C	; $82FC63
	db $87,$FA,$83,$AD,$10,$16,$29,$7F,$7F,$8D,$10,$16,$22,$EA,$F5,$80	; $82FC73
	db $22,$00,$80,$8D,$A9,$04,$00,$1C,$90,$12,$F0,$04,$5C,$F2,$F5,$80	; $82FC83
	db $5C,$72,$81,$8B,$86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$20	; $82FC93
	db $00,$D0,$F6,$A6,$0A,$86,$0A,$A2,$00,$00,$B5,$33,$48,$E8,$E8,$E0	; $82FCA3
	db $1C,$00,$D0,$F6,$A6,$0A,$5C,$88,$F8,$8D,$07,$01,$02,$03,$04,$05	; $82FCB3
	db $06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$C5,$D0,$B0,$02,$85,$D0	; $82FCC3
	db $6B,$04,$03,$04,$03,$02,$01,$04	; $82FCD3
CODE_82FCDB:		; M=16 X=16
	stz.b $98		; $82FCDB: 64 98
	lda.b $7D		; $82FCDD: A5 7D
	bpl CODE_82FCE9		; $82FCDF: 10 08
	eor.w #$FFFF		; $82FCE1: 49 FF FF
	inc a		; $82FCE4: 1A
	sta.b $7D		; $82FCE5: 85 7D
	inc.b $98		; $82FCE7: E6 98
CODE_82FCE9:		; M=16 X=16
	lda.b $83		; $82FCE9: A5 83
	bpl CODE_82FCF5		; $82FCEB: 10 08
	eor.w #$FFFF		; $82FCED: 49 FF FF
	inc a		; $82FCF0: 1A
	sta.b $83		; $82FCF1: 85 83
	inc.b $98		; $82FCF3: E6 98
CODE_82FCF5:		; M=16 X=16
	jsl.l $888942		; $82FCF5: 22 42 89 88
	lsr.b $98		; $82FCF9: 46 98
	bcc CODE_82FD16		; $82FCFB: 90 19
	lda.w #$0000		; $82FCFD: A9 00 00
	sbc.b $93		; $82FD00: E5 93
	sta.b $7D		; $82FD02: 85 7D
	sta.b $83		; $82FD04: 85 83
	sta.b $93		; $82FD06: 85 93
	lda.w #$0000		; $82FD08: A9 00 00
	sbc.b $95		; $82FD0B: E5 95
	sta.b $7F		; $82FD0D: 85 7F
	sta.b $85		; $82FD0F: 85 85
	sta.b $95		; $82FD11: 85 95
	lda.b $93		; $82FD13: A5 93
	clc		; $82FD15: 18
CODE_82FD16:		; M=16 X=16
	rtl		; $82FD16: 6B
CODE_82FD17:		; M=16 X=16
	lda.b $C3		; $82FD17: A5 C3
	cmp.w #$0293		; $82FD19: C9 93 02
	bcs CODE_82FD22		; $82FD1C: B0 04
	jml.l $87D1FE		; $82FD1E: 5C FE D1 87
CODE_82FD22:		; M=16 X=16
	dec.b $C3		; $82FD22: C6 C3
	stz.b $C5		; $82FD24: 64 C5
	ldx.w #$0000		; $82FD26: A2 00 00
	ldy.w #$0002		; $82FD29: A0 02 00
CODE_82FD2C:		; M=16 X=16
	lda.l $8FE67D,x		; $82FD2C: BF 7D E6 8F
	beq CODE_82FD2C		; $82FD30: F0 FA
	sta.b $0C		; $82FD32: 85 0C
	lda.l $8FE67E,x		; $82FD34: BF 7E E6 8F
	sta.b $0D		; $82FD38: 85 0D
	lda.b $C3		; $82FD3A: A5 C3
	sec		; $82FD3C: 38
	sbc.b [$0C]		; $82FD3D: E7 0C
	bcs CODE_82FD45		; $82FD3F: B0 04
	jml.l $85FBB9		; $82FD41: 5C B9 FB 85
CODE_82FD45:		; M=16 X=16
	sta.b $C3		; $82FD45: 85 C3
	lda.b $C5		; $82FD47: A5 C5
	clc		; $82FD49: 18
	adc.b [$0C],y		; $82FD4A: 77 0C
	sta.b $C5		; $82FD4C: 85 C5
	inx		; $82FD4E: E8
	inx		; $82FD4F: E8
	inx		; $82FD50: E8
	inx		; $82FD51: E8
	bra CODE_82FD2C		; $82FD52: 80 D8
CODE_82FD54:		; M=16 X=16
	lda.w $11BF,x		; $82FD54: BD BF 11
	beq CODE_82FD60		; $82FD57: F0 07
	lda.b $5B		; $82FD59: A5 5B
	eor.w #$0004		; $82FD5B: 49 04 00
	sta.b $5B		; $82FD5E: 85 5B
CODE_82FD60:		; M=16 X=16
	jml.l $8FE164		; $82FD60: 5C 64 E1 8F
	db $C5,$D2,$90,$02,$85,$D2,$6B	; $82FD64
CODE_82FD6B:		; M=16 X=16
	lda.w $13F2		; $82FD6B: AD F2 13
	pha		; $82FD6E: 48
	lda.w $13F4		; $82FD6F: AD F4 13
	pha		; $82FD72: 48
	ldx.w #$0000		; $82FD73: A2 00 00
CODE_82FD76:		; M=16 X=16
	stz.w $13B2,x		; $82FD76: 9E B2 13
	inx		; $82FD79: E8
	inx		; $82FD7A: E8
	cpx.w #$01CC		; $82FD7B: E0 CC 01
	bne CODE_82FD76		; $82FD7E: D0 F6
	pla		; $82FD80: 68
	sta.w $13F4		; $82FD81: 8D F4 13
	pla		; $82FD84: 68
	sta.w $13F2		; $82FD85: 8D F2 13
	lda.w #$FFFF		; $82FD88: A9 FF FF
	sta.w $154A		; $82FD8B: 8D 4A 15
	sta.w $1564		; $82FD8E: 8D 64 15
	jml.l $86FC29		; $82FD91: 5C 29 FC 86
CODE_82FD95:		; M=16 X=16
	jsl.l $80B90C		; $82FD95: 22 0C B9 80
	tcs		; $82FD99: 1B
	db $00,$BF,$05,$0B,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; $82FD9A
	db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$6B	; $82FDAA
CODE_82FDB5:		; M=16 X=16
	lda.w #$0002		; $82FDB5: A9 02 00
	tsb.w $128C		; $82FDB8: 0C 8C 12
	jml.l $80F3E1		; $82FDBB: 5C E1 F3 80
CODE_82FDBF:		; M=16 X=16
	lda.b $03,s		; $82FDBF: A3 03
	sta.b $39		; $82FDC1: 85 39
	lda.b $01,s		; $82FDC3: A3 01
	inc a		; $82FDC5: 1A
	sta.b $37		; $82FDC6: 85 37
	lda.b [$37]		; $82FDC8: A7 37
	clc		; $82FDCA: 18
	adc.b $01,s		; $82FDCB: 63 01
	sta.b $01,s		; $82FDCD: 83 01
	jml.l $8BFCCE		; $82FDCF: 5C CE FC 8B
CODE_82FDD3:		; M=16 X=16
	lda.b $03,s		; $82FDD3: A3 03
	sta.b $39		; $82FDD5: 85 39
	lda.b $01,s		; $82FDD7: A3 01
	inc a		; $82FDD9: 1A
	sta.b $37		; $82FDDA: 85 37
	lda.b [$37]		; $82FDDC: A7 37
	clc		; $82FDDE: 18
	adc.b $01,s		; $82FDDF: 63 01
	sta.b $01,s		; $82FDE1: 83 01
	jml.l $8F87C9		; $82FDE3: 5C C9 87 8F
	db $BD,$7F,$11,$F0,$03,$4C,$15,$FF,$AD,$8A,$12,$F0,$04,$5C,$5A,$D7	; $82FDE7
	db $8F,$22,$27,$85,$80,$BD,$DF,$0E,$89,$08,$00,$F0,$03,$4C,$15,$FF	; $82FDF7
	db $89,$02,$00,$F0,$18,$29,$FD,$FF,$9D,$DF,$0E,$A9,$FF,$FF,$9D,$DF	; $82FE07
	db $0C,$9E,$5F,$0C,$9E,$7F,$0C,$A9,$08,$00,$9D,$FF,$0C,$BD,$5F,$0C	; $82FE17
	db $38,$E5,$6F,$9D,$5F,$0C,$30,$03,$4C,$F0,$FE,$18,$7D,$BF,$0F,$10	; $82FE27
	db $03,$A9,$00,$00,$9D,$5F,$0C,$AD,$BB,$0E,$30,$18,$38,$E9,$06,$00	; $82FE37
	db $85,$57,$A9,$05,$00,$85,$53,$8A,$38,$E9,$0C,$00,$45,$57,$10,$04	; $82FE47
	db $5C,$A7,$B4,$80,$AD,$7B,$09,$85,$53,$BD,$3F,$11,$D0,$08,$A5,$53	; $82FE57
	db $49,$FF,$FF,$1A,$85,$53,$64,$5B,$A5,$53,$38,$E9,$A8,$FF,$30,$04	; $82FE67
	db $50,$04,$80,$34,$50,$32,$A9,$08,$00,$85,$5B,$A5,$53,$38,$E9,$58	; $82FE77
	db $00,$30,$04,$50,$04,$80,$21,$50,$1F,$A4,$3B,$B9,$0A,$14,$89,$10	; $82FE87
	db $00,$D0,$15,$06,$5B,$A5,$53,$38,$E9,$08,$01,$30,$04,$50,$04,$80	; $82FE97
	db $07,$50,$05,$A9,$18,$00,$85,$5B,$A5,$5B,$DD,$DF,$0C,$D0,$08,$AD	; $82FEA7
	db $A3,$04,$C9,$00,$02,$B0,$32,$A5,$5B,$9D,$DF,$0C,$A8,$A9,$16,$FF	; $82FEB7
	db $85,$33,$A9,$82,$00,$85,$35,$C8,$C8,$B7,$33,$88,$88,$22,$A1,$F6	; $82FEC7
	db $80,$77,$33,$9D,$9F,$0C,$C8,$C8,$C8,$C8,$C8,$C8,$B7,$33,$88,$88	; $82FED7
	db $22,$A1,$F6,$80,$77,$33,$9D,$BF,$0C,$BD,$9F,$0C,$85,$53,$BD,$BF	; $82FEE7
	db $0C,$85,$57,$BD,$3F,$11,$D0,$08,$A5,$57,$49,$FF,$FF,$1A,$85,$57	; $82FEF7
	db $A9,$6A,$FD,$85,$33,$A9,$89,$00,$85,$35,$5C,$D0,$FD,$88,$6B,$00	; $82FF07
	db $00,$3C,$00,$BA,$FF,$0A,$00,$00,$00,$3C,$00,$3C,$00,$0A,$00,$00	; $82FF17
	db $00,$28,$00,$AA,$00,$1E,$00,$00,$00,$50,$00,$AA,$00,$14,$00,$FF	; $82FF27
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF37
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF47
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF57
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF67
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF77
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF87
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FF97
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FFA7
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FFB7
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FFC7
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FFD7
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FFE7
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $82FFF7
