; Bank $80  ROM $00000-$07FFF  (auto-generated quick pass; TODO: segment agents refine)
org $808000


Start:		;auto: CODE_808000. 93G main93 Start (+ Begin RAM clear). Reset vector. Native mode, stack $1FFF, D=0, DB=$80; clears DP/RAM, sets vbint/hbint
	sei		; $808000: 78
	clc		; $808001: 18
	xce		; $808002: FB
	rep #$30		; $808003: C2 30
	lda.w #$1FFF		; $808005: A9 FF 1F
	tcs		; $808008: 1B
	lda.w #$0000		; $808009: A9 00 00
	tcd		; $80800C: 5B
	sep #$20		; $80800D: E2 20
	pha		; $80800F: 48
	plb		; $808010: AB
	rep #$30		; $808011: C2 30
	ldx.w #$0000		; $808013: A2 00 00
.clrdp:		;clear DP $0000-$164D
	stz.b $00,x		; $808016: 74 00
	inx		; $808018: E8
	inx		; $808019: E8
	cpx.w #$164E		; $80801A: E0 4E 16
	bcc .clrdp		; $80801D: 90 F7
	lda.w #vb2_blank		; $80801F: A9 CE 80
	sta.b vbint		; $808022: 85 14
	lda.w #HBdefault		; $808024: A9 A3 83
	sta.b hbint		; $808027: 85 16
	lda.w #$005C		; $808029: A9 5C 00
	sta.w $0178		; $80802C: 8D 78 01
	lda.w #$0012		; $80802F: A9 12 00
	sta.b $C1		; $808032: 85 C1
	lda.b $A7		; $808034: A5 A7
	sec		; $808036: 38
	sbc.w #$003C		; $808037: E9 3C 00
	ldx.w #$0000		; $80803A: A2 00 00
.clrwram:		;fill $7E2000-$7E6C73 with ($A7-$3C)
	sta.l $7E2000,x		; $80803D: 9F 00 20 7E
	inx		; $808041: E8
	inx		; $808042: E8
	cpx.w #$4C74		; $808043: E0 74 4C
	bne .clrwram		; $808046: D0 F5
	ldx.w #$0000		; $808048: A2 00 00
.clrbuf:		;fill $04AB-$08AA
	sta.w $04AB,x		; $80804B: 9D AB 04
	inx		; $80804E: E8
	inx		; $80804F: E8
	cpx.w #$0400		; $808050: E0 00 04
	bne .clrbuf		; $808053: D0 F6
	lda.w #$0020		; $808055: A9 20 00
	sta.b $BB		; $808058: 85 BB
	stz.b $73		; $80805A: 64 73
	ldx.w #$0000		; $80805C: A2 00 00
	ldy.w #$0002		; $80805F: A0 02 00
.sumloop:		;sum the word at [ptr]+2 for each long ptr in the table at $8FE67D (0-terminated)
	lda.l $8FE67D,x		; $808062: BF 7D E6 8F
	beq .validate		; $808066: F0 15
	sta.b $75		; $808068: 85 75
	lda.l $8FE67E,x		; $80806A: BF 7E E6 8F
	sta.b $76		; $80806E: 85 76
	lda.b [$75],y		; $808070: B7 75
	clc		; $808072: 18
	adc.b $73		; $808073: 65 73
	sta.b $73		; $808075: 85 73
	inx		; $808077: E8
	inx		; $808078: E8
	inx		; $808079: E8
	inx		; $80807A: E8
	bra .sumloop		; $80807B: 80 E5
.validate:		;anti-tamper: hang forever unless the sum is $131D (93G ValidationRoutine role, inline here)
	lda.b $73		; $80807D: A5 73
	cmp.w #$131D		; $80807F: C9 1D 13
	bne .validate		; $808082: D0 F9
	lda.w #$0001		; $808084: A9 01 00
	sta.b $21		; $808087: 85 21
	jsl.l $8D8120		; $808089: 22 20 81 8D
	sep #$20		; $80808D: E2 20
	cli		; $80808F: 58
	lda.w RDNMI		; $808090: AD 10 42
	lda.b #$81		; $808093: A9 81
	sta.w NMITIMEN		; $808095: 8D 00 42
	rep #$30		; $808098: C2 30
	jsl.l $82FA31		; $80809A: 22 31 FA 82
	stz.b $21		; $80809E: 64 21
	stz.b vbactive		; $8080A0: 64 12
	jsl.l $8F9073		; $8080A2: 22 73 90 8F
	jsl.l $8FE32B		; $8080A6: 22 2B E3 8F
	jsl.l $84FAD2		; $8080AA: 22 D2 FA 84
	jml.l $8B816A		; $8080AE: 5C 6A 81 8B

BRKHalt:		;auto: CODE_8080B2. BRK vector: hang. No 92G/93G counterpart (68k traps go to IRQ7 rte)
	bra BRKHalt		; $8080B2: 80 FE

VBjsr:		;auto: CODE_8080B4. 93G VBjsr (hockey93_01, IDA VBLANK). NMI: ack RDNMI, skip if vbactive, else "rts" into the vbint handler
	rep #$30		; $8080B4: C2 30
	pha		; $8080B6: 48
	lda.w RDNMI		; $8080B7: AD 10 42
	bit.w #$0080		; $8080BA: 89 80 00
	beq .skip		; $8080BD: F0 04
	lda.b vbactive		; $8080BF: A5 12
	beq .dispatch		; $8080C1: F0 02
.skip:
	pla		; $8080C3: 68
	rti		; $8080C4: 40
.dispatch:
	inc.b vbactive		; $8080C5: E6 12
	phx		; $8080C7: DA
	phy		; $8080C8: 5A
	lda.b vbint		; $8080C9: A5 14
	dec a		; $8080CB: 3A
	pha		; $8080CC: 48
	rts		; $8080CD: 60

vb2_blank:		;auto: CODE_8080CE. vbint target: vb2 with the screen held in forced blank. Resets hbint to HBdefault
	sep #$20		; $8080CE: E2 20
	lda.b #$80		; $8080D0: A9 80
	sta.w INIDISP		; $8080D2: 8D 00 21
	rep #$30		; $8080D5: C2 30
	lda.w #HBdefault		; $8080D7: A9 A3 83
	sta.b hbint		; $8080DA: 85 16
	bra vb2_main		; $8080DC: 80 07

vb2:		;auto: CODE_8080DE. 93G vb2 (video93_1): vblank for fades only, no dma. INIDISP from brightness, then vb2_main
	sep #$20		; $8080DE: E2 20
	lda.b brightness		; $8080E0: A5 04
	sta.w INIDISP		; $8080E2: 8D 00 21

vb2_main:		;auto: CODE_8080E5. common vblank tail: vcount, sound tick (jsl $89EB15, 93G p_music_vblank), brightness fades (93G cramfade), rti
	rep #$30		; $8080E5: C2 30
	inc.b vcount		; $8080E7: E6 00
	bne .tick		; $8080E9: D0 02
	inc.b vcount+2		; $8080EB: E6 02
.tick:
	jsl.l $89EB15		; $8080ED: 22 15 EB 89
	stz.b hcount		; $8080F1: 64 18
	lda.b fadeout		; $8080F3: A5 06
	beq .fadein		; $8080F5: F0 11
	lda.b brightness		; $8080F7: A5 04
	beq .fadeoutdone		; $8080F9: F0 0B
	lda.b vcount		; $8080FB: A5 00
	bit.w #$0003		; $8080FD: 89 03 00
	bne .fadein		; $808100: D0 06
	dec.b brightness		; $808102: C6 04
	bra .fadein		; $808104: 80 02
.fadeoutdone:
	stz.b fadeout		; $808106: 64 06
.fadein:
	lda.b fadein		; $808108: A5 08
	beq .exit		; $80810A: F0 1D
	cmp.w #$0001		; $80810C: C9 01 00
	bne .fadeindelay		; $80810F: D0 12
	lda.b brightness		; $808111: A5 04
	cmp.w #$000F		; $808113: C9 0F 00
	beq .fadeindone		; $808116: F0 0F
	lda.b vcount		; $808118: A5 00
	bit.w #$0003		; $80811A: 89 03 00
	bne .exit		; $80811D: D0 0A
	inc.b brightness		; $80811F: E6 04
	bra .exit		; $808121: 80 06
.fadeindelay:
	dec.b fadein		; $808123: C6 08
	bra .exit		; $808125: 80 02
.fadeindone:
	stz.b fadein		; $808127: 64 08
.exit:
	ply		; $808129: 7A
	plx		; $80812A: FA
	pla		; $80812B: 68
	stz.b vbactive		; $80812C: 64 12
	rti		; $80812E: 40
	db $5C,$33,$81,$80	; $80812F

VBlank:		;auto: CODE_808133. 93G VBlank / DumpSprites2+DoDMAList role: forced blank, run the DMA list at $1653 (7-byte entries, ch7), BG2 scroll, OAM dma from $0400; one shot: sets vbint back to vb2
	sep #$20		; $808133: E2 20
	lda.b #$80		; $808135: A9 80
	sta.w INIDISP		; $808137: 8D 00 21
	ldx.b $A3		; $80813A: A6 A3
	bra .next		; $80813C: 80 23
.dmaloop:
	ldy.w $1658,x		; $80813E: BC 58 16
	sty.w VMADDL		; $808141: 8C 16 21
	ldy.w $1656,x		; $808144: BC 56 16
	sty.w DAS7L		; $808147: 8C 75 43
	ldy.w #$1801		; $80814A: A0 01 18
	sty.w DMAP7		; $80814D: 8C 70 43
	ldy.w $1653,x		; $808150: BC 53 16
	sty.w A1T7L		; $808153: 8C 72 43
	lda.w $1655,x		; $808156: BD 55 16
	sta.w A1B7		; $808159: 8D 74 43
	lda.b #$80		; $80815C: A9 80
	sta.w MDMAEN		; $80815E: 8D 0B 42
.next:
	dex		; $808161: CA
	dex		; $808162: CA
	dex		; $808163: CA
	dex		; $808164: CA
	dex		; $808165: CA
	dex		; $808166: CA
	dex		; $808167: CA
	bpl .dmaloop		; $808168: 10 D4
	rep #$30		; $80816A: C2 30
	stz.b $A3		; $80816C: 64 A3
	lda.w $0156		; $80816E: AD 56 01
	clc		; $808171: 18
	adc.w #$00C0		; $808172: 69 C0 00
	sep #$20		; $808175: E2 20
	sta.w BG2HOFS		; $808177: 8D 0F 21
	xba		; $80817A: EB
	sta.w BG2HOFS		; $80817B: 8D 0F 21
	lda.w $08E1		; $80817E: AD E1 08
	and.b #$07		; $808181: 29 07
	pha		; $808183: 48
	rep #$30		; $808184: C2 30
	lda.w $049D		; $808186: AD 9D 04
	asl a		; $808189: 0A
	asl a		; $80818A: 0A
	asl a		; $80818B: 0A
	sep #$20		; $80818C: E2 20
	ora.b $01,s		; $80818E: 03 01
	sta.w BG2VOFS		; $808190: 8D 10 21
	xba		; $808193: EB
	sta.w BG2VOFS		; $808194: 8D 10 21
	pla		; $808197: 68
	rep #$30		; $808198: C2 30
	lda.w #$0400		; $80819A: A9 00 04
	sta.w DMAP7		; $80819D: 8D 70 43
	lda.w #$01FF		; $8081A0: A9 FF 01
	sta.w A1T7L		; $8081A3: 8D 72 43
	lda.w #$0220		; $8081A6: A9 20 02
	sta.w DAS7L		; $8081A9: 8D 75 43
	stz.w OAMADDL		; $8081AC: 9C 02 21
	sep #$20		; $8081AF: E2 20
	lda.b #$00		; $8081B1: A9 00
	sta.w A1B7		; $8081B3: 8D 74 43
	lda.b #$80		; $8081B6: A9 80
	sta.w MDMAEN		; $8081B8: 8D 0B 42
	rep #$30		; $8081BB: C2 30
	lda.w #vb2		; $8081BD: A9 DE 80
	sta.b vbint		; $8081C0: 85 14
	jmp.w $80DE		; $8081C2: 4C DE 80
	db $E2,$20,$A9,$80,$8D,$00,$21,$A6,$A3,$80,$23,$BC,$58,$16,$8C,$16	; $8081C5
	db $21,$BC,$56,$16,$8C,$75,$43,$A0,$01,$18,$8C,$70,$43,$BC,$53,$16	; $8081D5
	db $8C,$72,$43,$BD,$55,$16,$8D,$74,$43,$A9,$80,$8D,$0B,$42,$CA,$CA	; $8081E5
	db $CA,$CA,$CA,$CA,$CA,$10,$D4,$C2,$30,$64,$A3,$A9,$00,$04,$8D,$70	; $8081F5
	db $43,$A9,$FF,$01,$8D,$72,$43,$A9,$20,$02,$8D,$75,$43,$9C,$02,$21	; $808205
	db $E2,$20,$A9,$00,$8D,$74,$43,$A9,$80,$8D,$0B,$42,$C2,$30,$A9,$00	; $808215
	db $22,$8D,$70,$43,$A9,$B4,$6D,$8D,$72,$43,$A9,$40,$00,$8D,$75,$43	; $808225
	db $E2,$20,$A9,$A0,$8D,$21,$21,$A9,$7E,$8D,$74,$43,$A9,$80,$8D,$0B	; $808235
	db $42,$C2,$30,$A9,$DE,$80,$85,$14,$4C,$DE,$80,$E2,$20,$A9,$80,$8D	; $808245
	db $00,$21,$A6,$A3,$80,$23,$BC,$58,$16,$8C,$16,$21,$BC,$56,$16,$8C	; $808255
	db $75,$43,$A0,$01,$18,$8C,$70,$43,$BC,$53,$16,$8C,$72,$43,$BD,$55	; $808265
	db $16,$8D,$74,$43,$A9,$80,$8D,$0B,$42,$CA,$CA,$CA,$CA,$CA,$CA,$CA	; $808275
	db $10,$D4,$C2,$30,$64,$A3,$A9,$DE,$80,$85,$14,$4C,$DE,$80,$E2,$20	; $808285
	db $A9,$80,$8D,$00,$21,$A5,$53,$8D,$0E,$21,$A5,$54,$8D,$0E,$21,$A6	; $808295
	db $A3,$80,$23,$BC,$58,$16,$8C,$16,$21,$BC,$56,$16,$8C,$75,$43,$A0	; $8082A5
	db $01,$18,$8C,$70,$43,$BC,$53,$16,$8C,$72,$43,$BD,$55,$16,$8D,$74	; $8082B5
	db $43,$A9,$80,$8D,$0B,$42,$CA,$CA,$CA,$CA,$CA,$CA,$CA,$10,$D4,$C2	; $8082C5
	db $30,$64,$A3,$A9,$DE,$80,$85,$14,$4C,$DE,$80,$E2,$20,$A9,$80,$8D	; $8082D5
	db $00,$21,$A6,$A3,$80,$23,$BC,$58,$16,$8C,$16,$21,$BC,$56,$16,$8C	; $8082E5
	db $75,$43,$A0,$01,$18,$8C,$70,$43,$BC,$53,$16,$8C,$72,$43,$BD,$55	; $8082F5
	db $16,$8D,$74,$43,$A9,$80,$8D,$0B,$42,$CA,$CA,$CA,$CA,$CA,$CA,$CA	; $808305
	db $10,$D4,$C2,$30,$64,$A3,$E2,$20,$AD,$56,$01,$29,$07,$8D,$0D,$21	; $808315
	db $9C,$0D,$21,$9C,$0E,$21,$9C,$0E,$21,$C2,$30,$A9,$00,$22,$8D,$70	; $808325
	db $43,$A9,$74,$6C,$8D,$72,$43,$A9,$00,$01,$8D,$75,$43,$E2,$20,$9C	; $808335
	db $21,$21,$A9,$7E,$8D,$74,$43,$A9,$80,$8D,$0B,$42,$C2,$30,$A9,$61	; $808345
	db $83,$85,$14,$A2,$12,$00,$CA,$D0,$FD,$4C,$DE,$80,$E2,$20,$A9,$80	; $808355
	db $8D,$00,$21,$C2,$30,$A9,$00,$22,$8D,$70,$43,$A9,$74,$6C,$8D,$72	; $808365
	db $43,$A9,$00,$01,$8D,$75,$43,$E2,$20,$9C,$21,$21,$A9,$7E,$8D,$74	; $808375
	db $43,$A9,$80,$8D,$0B,$42,$C2,$30,$4C,$DE,$80	; $808385

HBjsr:		;auto: CODE_808390. IRQ vector: if TIMEUP set, "rts" into hbint; else HBdefault. No 93G counterpart (Genesis hbint not used this way)
	rep #$30		; $808390: C2 30
	pha		; $808392: 48
	phx		; $808393: DA
	phy		; $808394: 5A
	sep #$20		; $808395: E2 20
	lda.w TIMEUP		; $808397: AD 11 42
	bpl HBdefault		; $80839A: 10 07
	rep #$30		; $80839C: C2 30
	lda.b hbint		; $80839E: A5 16
	dec a		; $8083A0: 3A
	pha		; $8083A1: 48
	rts		; $8083A2: 60

HBdefault:		;auto: CODE_8083A3. default hbint: count hcount, restore regs, rti
	rep #$30		; $8083A3: C2 30
	inc.b hcount		; $8083A5: E6 18
	ply		; $8083A7: 7A
	plx		; $8083A8: FA
	pla		; $8083A9: 68
	rti		; $8083AA: 40
CODE_8083AB:		; M=16 X=16
	lda.w #$0002		; $8083AB: A9 02 00
	sta.b $57		; $8083AE: 85 57
	lda.b $53		; $8083B0: A5 53
	and.w #$000F		; $8083B2: 29 0F 00
	sta.b $53		; $8083B5: 85 53
	cmp.w #$0008		; $8083B7: C9 08 00
	bcc CODE_8083D5		; $8083BA: 90 19
	cmp.w #$0009		; $8083BC: C9 09 00
	bne CODE_8083CC		; $8083BF: D0 0B
	lda.w $0ADF,x		; $8083C1: BD DF 0A
	ora.w $0AFF,x		; $8083C4: 1D FF 0A
	beq CODE_8083CC		; $8083C7: F0 03
	jmp.w $8452		; $8083C9: 4C 52 84
CODE_8083CC:		; M=16 X=16
	lda.w $11DF,x		; $8083CC: BD DF 11
	bne CODE_8083D4		; $8083CF: D0 03
	jmp.w $B006		; $8083D1: 4C 06 B0
CODE_8083D4:		; M=16 X=16
	rtl		; $8083D4: 6B
CODE_8083D5:		; M=16 X=16
	sec		; $8083D5: 38
	sbc.w $0DBF,x		; $8083D6: FD BF 0D
	sta.b $53		; $8083D9: 85 53
	beq CODE_8083F2		; $8083DB: F0 15
	eor.w #$FFFF		; $8083DD: 49 FF FF
	inc a		; $8083E0: 1A
	and.w #$0004		; $8083E1: 29 04 00
	lsr a		; $8083E4: 4A
	dec a		; $8083E5: 3A
	clc		; $8083E6: 18
	adc.w $0DBF,x		; $8083E7: 7D BF 0D
	and.w #$0007		; $8083EA: 29 07 00
	sta.b $53		; $8083ED: 85 53
	sta.w $0DBF,x		; $8083EF: 9D BF 0D
CODE_8083F2:		; M=16 X=16
	lda.w #$0344		; $8083F2: A9 44 03
	sta.b $57		; $8083F5: 85 57
	jsl.l $80B006		; $8083F7: 22 06 B0 80
	lda.w $0DBF,x		; $8083FB: BD BF 0D
	sta.b $5B		; $8083FE: 85 5B
	jml.l $8FE164		; $808400: 5C 64 E1 8F
CODE_808404:		; M=16 X=16
	lda.w $0ADF,x		; $808404: BD DF 0A
	bit.w #$8000		; $808407: 89 00 80
	beq CODE_808410		; $80840A: F0 04
	eor.w #$FFFF		; $80840C: 49 FF FF
	inc a		; $80840F: 1A
CODE_808410:		; M=16 X=16
	cmp.w #$1001		; $808410: C9 01 10
	bcs CODE_808426		; $808413: B0 11
	lda.w $0AFF,x		; $808415: BD FF 0A
	bit.w #$8000		; $808418: 89 00 80
	beq CODE_808421		; $80841B: F0 04
	eor.w #$FFFF		; $80841D: 49 FF FF
	inc a		; $808420: 1A
CODE_808421:		; M=16 X=16
	cmp.w #$1001		; $808421: C9 01 10
	bcc CODE_808452		; $808424: 90 2C
CODE_808426:		; M=16 X=16
	lda.w #$0478		; $808426: A9 78 04
	sta.b $57		; $808429: 85 57
	lda.w $11BF,x		; $80842B: BD BF 11
	bne CODE_80844E		; $80842E: D0 1E
	txa		; $808430: 8A
	lsr a		; $808431: 4A
	cmp.w $0EBB		; $808432: CD BB 0E
	bne CODE_808446		; $808435: D0 0F
	lda.w $04A2		; $808437: AD A2 04
	and.w #$0001		; $80843A: 29 01 00
	clc		; $80843D: 18
	adc.w #$009C		; $80843E: 69 9C 00
	pha		; $808441: 48
	jsl.l $80C28B		; $808442: 22 8B C2 80
CODE_808446:		; M=16 X=16
	lda.w #$0672		; $808446: A9 72 06
	sta.b $57		; $808449: 85 57
	sta.w $11DF,x		; $80844B: 9D DF 11
CODE_80844E:		; M=16 X=16
	jsl.l $80B006		; $80844E: 22 06 B0 80
CODE_808452:		; M=16 X=16
	lda.w #$0070		; $808452: A9 70 00
	sta.b $7D		; $808455: 85 7D
	lda.b $6F		; $808457: A5 6F
	sta.b $83		; $808459: 85 83
	jsl.l $8D871C		; $80845B: 22 1C 87 8D
	lda.w $0ADF,x		; $80845F: BD DF 0A
	bpl CODE_80846F		; $808462: 10 0B
	clc		; $808464: 18
	adc.b $93		; $808465: 65 93
	sta.w $0ADF,x		; $808467: 9D DF 0A
	bmi CODE_80847A		; $80846A: 30 0E
	lda.w #$0000		; $80846C: A9 00 00
CODE_80846F:		; M=16 X=16
	sec		; $80846F: 38
	sbc.b $93		; $808470: E5 93
	sta.w $0ADF,x		; $808472: 9D DF 0A
	bpl CODE_80847A		; $808475: 10 03
	stz.w $0ADF,x		; $808477: 9E DF 0A
CODE_80847A:		; M=16 X=16
	lda.w $0AFF,x		; $80847A: BD FF 0A
	bpl CODE_80848A		; $80847D: 10 0B
	clc		; $80847F: 18
	adc.b $93		; $808480: 65 93
	sta.w $0AFF,x		; $808482: 9D FF 0A
	bmi CODE_808495		; $808485: 30 0E
	lda.w #$0000		; $808487: A9 00 00
CODE_80848A:		; M=16 X=16
	sec		; $80848A: 38
	sbc.b $93		; $80848B: E5 93
	sta.w $0AFF,x		; $80848D: 9D FF 0A
	bpl CODE_808495		; $808490: 10 03
	stz.w $0AFF,x		; $808492: 9E FF 0A
CODE_808495:		; M=16 X=16
	rtl		; $808495: 6B
CODE_808496:		; M=16 X=16
	stz.b $7F		; $808496: 64 7F
	lda.b $7D		; $808498: A5 7D
	bpl CODE_8084A4		; $80849A: 10 08
	eor.w #$FFFF		; $80849C: 49 FF FF
	inc a		; $80849F: 1A
	sta.b $7D		; $8084A0: 85 7D
	inc.b $7F		; $8084A2: E6 7F
CODE_8084A4:		; M=16 X=16
	lda.b $83		; $8084A4: A5 83
	bpl CODE_8084B0		; $8084A6: 10 08
	eor.w #$FFFF		; $8084A8: 49 FF FF
	inc a		; $8084AB: 1A
	sta.b $83		; $8084AC: 85 83
	inc.b $7F		; $8084AE: E6 7F
CODE_8084B0:		; M=16 X=16
	jsl.l $8D871C		; $8084B0: 22 1C 87 8D
	lsr.b $7F		; $8084B4: 46 7F
	bcc CODE_8084C3		; $8084B6: 90 0B
	eor.w #$FFFF		; $8084B8: 49 FF FF
	inc a		; $8084BB: 1A
	sta.b $7D		; $8084BC: 85 7D
	sta.b $83		; $8084BE: 85 83
	sta.b $93		; $8084C0: 85 93
	clc		; $8084C2: 18
CODE_8084C3:		; M=16 X=16
	rtl		; $8084C3: 6B
CODE_8084C4:		; M=16 X=16
	lda.w $119F,x		; $8084C4: BD 9F 11
	beq CODE_8084CC		; $8084C7: F0 03
	lda.w #$0002		; $8084C9: A9 02 00
CODE_8084CC:		; M=16 X=16
	sta.b $3B		; $8084CC: 85 3B
	lda.w $0F1F,x		; $8084CE: BD 1F 0F
	and.w #$00FF		; $8084D1: 29 FF 00
	asl a		; $8084D4: 0A
	sta.b $57		; $8084D5: 85 57
	lda.b $3B		; $8084D7: A5 3B
	beq CODE_8084DE		; $8084D9: F0 03
	lda.w #$0034		; $8084DB: A9 34 00
CODE_8084DE:		; M=16 X=16
	adc.b $57		; $8084DE: 65 57
	tay		; $8084E0: A8
	lda.w $147A,y		; $8084E1: B9 7A 14
	sta.b $53		; $8084E4: 85 53
	rtl		; $8084E6: 6B
	db $40,$DC,$AF,$01,$44,$20,$DC,$01,$10,$8D,$0A,$02,$A4,$22,$3B,$02	; $8084E7
	db $00,$E1,$6D,$02,$24,$C8,$A2,$02,$10,$D8,$D9,$02,$C4,$10,$13,$03	; $8084F7
	db $40,$72,$4E,$03,$84,$FC,$8B,$03,$90,$AF,$CB,$03,$64,$8B,$0D,$04	; $808507
	db $00,$90,$51,$04,$64,$BD,$97,$04,$90,$13,$E0,$04,$84,$92,$2A,$05	; $808517
	db $BD,$DF,$0E,$89,$08,$40,$D0,$45,$BD,$9F,$0E,$10,$05,$BD,$BF,$0E	; $808527
	db $30,$3B,$BD,$BF,$0E,$DD,$1F,$0F,$F0,$34,$8A,$0A,$0A,$7D,$BF,$0B	; $808537
	db $A8,$B9,$DF,$0B,$29,$FF,$00,$C9,$0B,$00,$F0,$21,$8A,$4A,$CD,$BB	; $808547
	db $0E,$F0,$1A,$E2,$20,$68,$C2,$30,$68,$BD,$DF,$0E,$09,$00,$10,$9D	; $808557
	db $DF,$0E,$9E,$5F,$0C,$A9,$0B,$00,$85,$53,$4C,$A7,$B4,$6B,$E2,$20	; $808567
	db $68,$C2,$30,$68,$BD,$DF,$0E,$29,$FF,$EF,$9D,$DF,$0E,$9E,$FF,$11	; $808577
	db $A9,$FF,$FF,$9D,$BF,$0E,$9D,$9F,$0E,$BD,$9F,$0B,$85,$53,$4C,$38	; $808587
	db $B1	; $808597
CODE_808598:		; M=16 X=16
	lda.w $1288		; $808598: AD 88 12
	bit.w #$0020		; $80859B: 89 20 00
	bne CODE_8085A3		; $80859E: D0 03
	jmp.w $863B		; $8085A0: 4C 3B 86
CODE_8085A3:		; M=16 X=16
	stx.b $0A		; $8085A3: 86 0A
	ldx.w #$0000		; $8085A5: A2 00 00
CODE_8085A8:		; M=16 X=16
	lda.b $53,x		; $8085A8: B5 53
	pha		; $8085AA: 48
	inx		; $8085AB: E8
	inx		; $8085AC: E8
	cpx.w #$0008		; $8085AD: E0 08 00
	bne CODE_8085A8		; $8085B0: D0 F6
	ldx.b $0A		; $8085B2: A6 0A
	stx.b $0A		; $8085B4: 86 0A
	ldx.w #$0000		; $8085B6: A2 00 00
CODE_8085B9:		; M=16 X=16
	lda.b $33,x		; $8085B9: B5 33
	pha		; $8085BB: 48
	inx		; $8085BC: E8
	inx		; $8085BD: E8
	cpx.w #$0004		; $8085BE: E0 04 00
	bne CODE_8085B9		; $8085C1: D0 F6
	ldx.b $0A		; $8085C3: A6 0A
	lda.w #$0005		; $8085C5: A9 05 00
	sta.b $53		; $8085C8: 85 53
	stz.b $33		; $8085CA: 64 33
	cpx.w #$000C		; $8085CC: E0 0C 00
	bcc CODE_8085D6		; $8085CF: 90 05
	lda.w #$000C		; $8085D1: A9 0C 00
	sta.b $33		; $8085D4: 85 33
CODE_8085D6:		; M=16 X=16
	lda.w #$005C		; $8085D6: A9 5C 00
	sta.b $57		; $8085D9: 85 57
	lda.w $113F,x		; $8085DB: BD 3F 11
	bne CODE_808654		; $8085DE: D0 74
	lda.w #$FFA4		; $8085E0: A9 A4 FF
	sta.b $57		; $8085E3: 85 57
	sec		; $8085E5: 38
	sbc.w $097B		; $8085E6: ED 7B 09
	beq CODE_8085F3		; $8085E9: F0 08
	bmi CODE_8085F1		; $8085EB: 30 04
	bvs CODE_8085F3		; $8085ED: 70 04
	bra CODE_808612		; $8085EF: 80 21
CODE_8085F1:		; M=16 X=16
	bvs CODE_808612		; $8085F1: 70 1F
CODE_8085F3:		; M=16 X=16
	ldy.b $33		; $8085F3: A4 33
	lda.w $0B9F,y		; $8085F5: B9 9F 0B
	bmi CODE_80860A		; $8085F8: 30 10
	lda.b $57		; $8085FA: A5 57
	sec		; $8085FC: 38
	sbc.w $095F,y		; $8085FD: F9 5F 09
	beq CODE_80860A		; $808600: F0 08
	bmi CODE_808608		; $808602: 30 04
	bvs CODE_80860A		; $808604: 70 04
	bra CODE_80863C		; $808606: 80 34
CODE_808608:		; M=16 X=16
	bvs CODE_80863C		; $808608: 70 32
CODE_80860A:		; M=16 X=16
	inc.b $33		; $80860A: E6 33
	inc.b $33		; $80860C: E6 33
	dec.b $53		; $80860E: C6 53
	bpl CODE_8085F3		; $808610: 10 E1
CODE_808612:		; M=16 X=16
	lda.w #$0040		; $808612: A9 40 00
	sta.b $53		; $808615: 85 53
	lda.w #$8000		; $808617: A9 00 80
	trb.w $128C		; $80861A: 1C 8C 12
	bne CODE_808649		; $80861D: D0 2A
CODE_80861F:		; M=16 X=16
	stx.b $0A		; $80861F: 86 0A
	ldx.w #$0002		; $808621: A2 02 00
CODE_808624:		; M=16 X=16
	pla		; $808624: 68
	sta.b $33,x		; $808625: 95 33
	dex		; $808627: CA
	dex		; $808628: CA
	bpl CODE_808624		; $808629: 10 F9
	ldx.b $0A		; $80862B: A6 0A
	stx.b $0A		; $80862D: 86 0A
	ldx.w #$0006		; $80862F: A2 06 00
CODE_808632:		; M=16 X=16
	pla		; $808632: 68
	sta.b $53,x		; $808633: 95 53
	dex		; $808635: CA
	dex		; $808636: CA
	bpl CODE_808632		; $808637: 10 F9
	ldx.b $0A		; $808639: A6 0A
CODE_80863B:		; M=16 X=16
	rtl		; $80863B: 6B
CODE_80863C:		; M=16 X=16
	lda.w #$0006		; $80863C: A9 06 00
	sta.b $53		; $80863F: 85 53
	lda.w #$8000		; $808641: A9 00 80
	tsb.w $128C		; $808644: 0C 8C 12
	bne CODE_80861F		; $808647: D0 D6
CODE_808649:		; M=16 X=16
	lda.w $12EA		; $808649: AD EA 12
	bpl CODE_80861F		; $80864C: 10 D1
	jsl.l $8F83A7		; $80864E: 22 A7 83 8F
	bra CODE_80861F		; $808652: 80 CB
CODE_808654:		; M=16 X=16
	lda.b $57		; $808654: A5 57
	sec		; $808656: 38
	sbc.w $097B		; $808657: ED 7B 09
	bmi CODE_808660		; $80865A: 30 04
	bvc CODE_808662		; $80865C: 50 04
	bra CODE_808612		; $80865E: 80 B2
CODE_808660:		; M=16 X=16
	bvc CODE_808612		; $808660: 50 B0
CODE_808662:		; M=16 X=16
	ldy.b $33		; $808662: A4 33
	lda.w $0B9F,y		; $808664: B9 9F 0B
	bmi CODE_808677		; $808667: 30 0E
	lda.b $57		; $808669: A5 57
	sec		; $80866B: 38
	sbc.w $095F,y		; $80866C: F9 5F 09
	bmi CODE_808675		; $80866F: 30 04
	bvc CODE_808677		; $808671: 50 04
	bra CODE_80863C		; $808673: 80 C7
CODE_808675:		; M=16 X=16
	bvc CODE_80863C		; $808675: 50 C5
CODE_808677:		; M=16 X=16
	inc.b $33		; $808677: E6 33
	inc.b $33		; $808679: E6 33
	dec.b $53		; $80867B: C6 53
	bpl CODE_808662		; $80867D: 10 E3
	bra CODE_808612		; $80867F: 80 91
	db $AD,$7B,$09,$85,$53,$BD,$3F,$11,$D0,$08,$A5,$53,$49,$FF,$FF,$1A	; $808681
	db $85,$53,$A5,$53,$30,$4B,$38,$E9,$58,$00,$F0,$08,$30,$04,$70,$04	; $808691
	db $80,$3F,$70,$3D,$AD,$A1,$04,$29,$03,$00,$D0,$35,$BD,$DF,$0E,$89	; $8086A1
	db $00,$20,$D0,$2D,$64,$3B,$A9,$02,$00,$85,$37,$BD,$9F,$11,$F0,$07	; $8086B1
	db $64,$37,$A9,$02,$00,$85,$3B,$22,$4C,$B8,$80,$A5,$53,$C9,$01,$0C	; $8086C1
	db $B0,$0F,$22,$BD,$E6,$8F,$22,$5A,$BB,$80,$22,$5D,$E9,$89,$4C,$F7	; $8086D1
	db $87,$6B,$22,$95,$8D,$80,$D0,$21,$AD,$D3,$08,$F0,$1C,$BD,$5F,$09	; $8086E1
	db $89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$ED,$00,$B0,$0B,$AD,$A1	; $8086F1
	db $04,$29,$03,$00,$D0,$03,$4C,$F7,$87,$A9,$20,$00,$38,$FD,$5F,$10	; $808701
	db $0A,$0A,$0A,$0A,$85,$63,$A9,$08,$01,$85,$57,$BD,$3F,$11,$D0,$05	; $808711
	db $A9,$F8,$FE,$85,$57,$A5,$57,$38,$ED,$7B,$09,$85,$57,$48,$AD,$1B	; $808721
	db $09,$49,$FF,$FF,$1A,$85,$7D,$85,$83,$48,$22,$DB,$FC,$82,$85,$53	; $808731
	db $A5,$95,$85,$55,$A5,$57,$85,$7D,$85,$83,$22,$DB,$FC,$82,$65,$53	; $808741
	db $85,$73,$A5,$95,$65,$55,$85,$75,$68,$85,$53,$68,$85,$57,$A5,$73	; $808751
	db $C9,$11,$27,$A5,$75,$E9,$00,$00,$B0,$58,$46,$63,$46,$63,$46,$63	; $808761
	db $46,$63,$22,$A8,$AF,$80,$85,$67,$A9,$05,$00,$85,$5F,$64,$37,$E0	; $808771
	db $0C,$00,$B0,$05,$A9,$0C,$00,$85,$37,$A4,$37,$B9,$9F,$0B,$F0,$1E	; $808781
	db $B9,$FF,$08,$38,$ED,$1B,$09,$85,$53,$B9,$5F,$09,$38,$ED,$7B,$09	; $808791
	db $85,$57,$22,$A8,$AF,$80,$C5,$67,$D0,$10,$06,$63,$80,$0C,$B9,$DF	; $8087A1
	db $11,$F0,$07,$64,$5F,$A9,$01,$00,$85,$63,$E6,$37,$E6,$37,$C6,$5F	; $8087B1
	db $10,$C7,$A5,$63,$22,$8B,$AE,$80,$C9,$09,$00,$B0,$28,$AD,$7B,$09	; $8087C1
	db $85,$53,$BD,$3F,$11,$D0,$08,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$A5	; $8087D1
	db $53,$30,$12,$A9,$08,$01,$38,$E5,$53,$30,$0A,$AD,$8C,$12,$89,$00	; $8087E1
	db $80,$D0,$02,$80,$01,$6B,$68,$E2,$20,$68,$C2,$30,$AD,$7B,$09,$85	; $8087F1
	db $53,$BD,$3F,$11,$D0,$08,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$A9,$08	; $808801
	db $01,$38,$E5,$53,$4A,$4A,$4A,$85,$57,$C9,$14,$00,$90,$05,$A9,$14	; $808811
	db $00,$85,$57,$9E,$7F,$0C,$A5,$57,$9D,$FF,$0C,$A9,$12,$00,$85,$53	; $808821
	db $4C,$A7,$B4,$BD,$DF,$0E,$89,$02,$00,$F0,$15,$29,$FD,$FF,$9D,$DF	; $808831
	db $0E,$9E,$9F,$0C,$9E,$7F,$0C,$A9,$08,$00,$9D,$FF,$0C,$9E,$5F,$0C	; $808841
	db $8A,$4A,$85,$57,$CD,$BB,$0E,$D0,$19,$BD,$9F,$0B,$D0,$03,$4C,$AD	; $808851
	db $F6,$A9,$10,$00,$85,$53,$BD,$DF,$0E,$89,$08,$00,$D0,$03,$4C,$9D	; $808861
	db $B4,$6B,$BD,$5F,$0C,$38,$E5,$6F,$9D,$5F,$0C,$30,$03,$4C,$40,$8A	; $808871
	db $7D,$9F,$0F,$10,$03,$A9,$00,$00,$9D,$5F,$0C,$A4,$3B,$A9,$00,$00	; $808881
	db $99,$FA,$13,$99,$FE,$13,$AD,$BB,$0E,$30,$1D,$0A,$85,$37,$A8,$B9	; $808891
	db $9F,$11,$F0,$03,$A9,$01,$00,$85,$73,$BD,$9F,$11,$F0,$03,$A9,$01	; $8088A1
	db $00,$45,$73,$D0,$03,$4C,$AA,$89,$A9,$FF,$FF,$85,$5B,$85,$5D,$A9	; $8088B1
	db $05,$00,$85,$63,$A4,$3B,$B9,$D2,$13,$85,$33,$A4,$33,$B9,$9F,$0B	; $8088C1
	db $10,$03,$4C,$91,$89,$D0,$03,$4C,$91,$89,$B9,$5F,$0E,$F0,$03,$4C	; $8088D1
	db $91,$89,$B9,$DF,$0E,$89,$00,$10,$F0,$03,$4C,$91,$89,$98,$0A,$0A	; $8088E1
	db $79,$BF,$0B,$A8,$B9,$DF,$0B,$29,$FF,$00,$C9,$13,$00,$D0,$03,$4C	; $8088F1
	db $91,$89,$A5,$33,$22,$0A,$9B,$80,$A4,$33,$A5,$53,$18,$79,$FF,$08	; $808901
	db $38,$ED,$1B,$09,$85,$53,$A5,$57,$18,$79,$5F,$09,$38,$ED,$7B,$09	; $808911
	db $85,$57,$AD,$FB,$0A,$4A,$4A,$4A,$4A,$4A,$4A,$89,$00,$02,$F0,$03	; $808921
	db $09,$00,$FC,$85,$5F,$A5,$53,$38,$E5,$5F,$85,$53,$AD,$1B,$0B,$4A	; $808931
	db $4A,$4A,$4A,$4A,$4A,$89,$00,$02,$F0,$03,$09,$00,$FC,$85,$5F,$A5	; $808941
	db $57,$38,$E5,$5F,$85,$57,$A5,$53,$85,$7D,$85,$83,$22,$DB,$FC,$82	; $808951
	db $85,$53,$A5,$95,$85,$55,$A5,$57,$85,$7D,$85,$83,$22,$DB,$FC,$82	; $808961
	db $65,$53,$85,$53,$A5,$95,$65,$55,$85,$55,$A5,$5B,$C5,$53,$A5,$5D	; $808971
	db $E5,$55,$90,$0C,$A5,$53,$85,$5B,$A5,$55,$85,$5D,$A5,$33,$85,$37	; $808981
	db $E6,$33,$E6,$33,$C6,$63,$30,$03,$4C,$CC,$88,$A5,$5D,$30,$42,$A4	; $808991
	db $3B,$99,$FE,$13,$A5,$5B,$99,$FA,$13,$E4,$37,$F0,$34,$AD,$8A,$12	; $8089A1
	db $D0,$2F,$A4,$37,$B9,$DF,$0E,$89,$00,$10,$D0,$25,$A6,$37,$A4,$3F	; $8089B1
	db $86,$3F,$84,$37,$BD,$DF,$0E,$29,$FE,$FF,$9D,$DF,$0E,$A9,$11,$00	; $8089C1
	db $85,$53,$22,$9D,$B4,$80,$A6,$37,$A4,$3F,$86,$3F,$84,$37,$4C,$F9	; $8089D1
	db $96,$BD,$7F,$11,$F0,$03,$4C,$72,$88,$A9,$02,$00,$85,$57,$A5,$5B	; $8089E1
	db $C9,$91,$01,$B0,$0A,$64,$57,$BD,$9F,$0B,$C9,$03,$00,$90,$40,$AD	; $8089F1
	db $8C,$12,$89,$00,$20,$F0,$12,$C6,$57,$C6,$57,$22,$9F,$8D,$80,$D0	; $808A01
	db $08,$E6,$57,$E6,$57,$E6,$57,$E6,$57,$A9,$14,$00,$38,$FD,$FF,$10	; $808A11
	db $85,$53,$A5,$57,$85,$73,$C6,$73,$30,$04,$06,$53,$80,$F8,$22,$A3	; $808A21
	db $97,$80,$A5,$53,$C9,$02,$00,$B0,$06,$A9,$F0,$00,$9D,$9F,$0C,$BD	; $808A31
	db $7F,$11,$F0,$03,$4C,$72,$88,$AD,$8A,$12,$F0,$04,$5C,$5A,$D7,$8F	; $808A41
	db $BD,$DF,$0E,$89,$08,$00,$F0,$03,$4C,$72,$88,$A4,$3B,$B9,$0A,$14	; $808A51
	db $89,$02,$00,$D0,$19,$AD,$BB,$0E,$10,$03,$4C,$0E,$8B,$BD,$9F,$0C	; $808A61
	db $38,$E5,$6F,$9D,$9F,$0C,$30,$03,$4C,$0E,$8B,$9E,$9F,$0C,$22,$D3	; $808A71
	db $FF,$8B,$A5,$57,$48,$A5,$53,$48,$49,$FF,$FF,$1A,$85,$53,$A5,$57	; $808A81
	db $49,$FF,$FF,$1A,$18,$69,$F4,$00,$85,$57,$BD,$3F,$11,$F0,$08,$A5	; $808A91
	db $57,$38,$E9,$E8,$01,$85,$57,$A5,$53,$48,$0A,$68,$6A,$85,$53,$A5	; $808AA1
	db $57,$48,$0A,$68,$6A,$85,$57,$68,$18,$65,$53,$85,$53,$68,$18,$65	; $808AB1
	db $57,$85,$57,$A4,$3B,$B9,$0A,$14,$89,$02,$00,$F0,$2F,$BD,$3F,$11	; $808AC1
	db $F0,$15,$A5,$57,$38,$E9,$53,$00,$30,$04,$50,$04,$80,$1E,$50,$1C	; $808AD1
	db $A9,$44,$00,$85,$57,$80,$15,$A5,$57,$38,$E9,$AD,$FF,$F0,$08,$30	; $808AE1
	db $04,$70,$04,$80,$07,$70,$05,$A9,$BC,$FF,$85,$57,$A9,$E6,$84,$85	; $808AF1
	db $33,$A9,$80,$00,$85,$35,$22,$D0,$FD,$88,$4C,$15,$8B,$22,$2D,$8C	; $808B01
	db $80,$4C,$15,$8B,$A9,$14,$00,$38,$FD,$FF,$10,$85,$53,$AD,$0A,$16	; $808B11
	db $F0,$02,$06,$53,$A5,$53,$22,$8B,$AE,$80,$C9,$04,$00,$90,$0B,$A5	; $808B21
	db $53,$22,$8B,$AE,$80,$C9,$04,$00,$B0,$71,$A9,$05,$00,$85,$5B,$64	; $808B31
	db $33,$E0,$0C,$00,$B0,$05,$A9,$0C,$00,$85,$33,$A4,$33,$B9,$9F,$0B	; $808B41
	db $F0,$51,$B9,$7F,$11,$D0,$4C,$B9,$5F,$11,$D0,$47,$B9,$FF,$08,$38	; $808B51
	db $FD,$FF,$08,$85,$53,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$1F	; $808B61
	db $00,$B0,$30,$B9,$5F,$09,$38,$FD,$5F,$09,$85,$57,$89,$00,$80,$F0	; $808B71
	db $04,$49,$FF,$FF,$1A,$C9,$1F,$00,$B0,$19,$22,$A8,$AF,$80,$A5,$53	; $808B81
	db $DD,$BF,$0D,$D0,$0E,$AD,$A4,$04,$29,$03,$00,$85,$53,$D0,$0D,$5C	; $808B91
	db $5B,$FB,$8F,$E6,$33,$E6,$33,$C6,$5B,$10,$A0,$6B	; $808BA1
CODE_808BAD:		; M=16 X=16
	jsl.l $8084C4		; $808BAD: 22 C4 84 80
	lda.w $160C		; $808BB1: AD 0C 16
	bne CODE_808BC2		; $808BB4: D0 0C
	lda.b $53		; $808BB6: A5 53
	sec		; $808BB8: 38
	sbc.w #$00CC		; $808BB9: E9 CC 00
	sta.b $53		; $808BBC: 85 53
	jsl.l $8FEE6B		; $808BBE: 22 6B EE 8F
CODE_808BC2:		; M=16 X=16
	lda.b $53		; $808BC2: A5 53
	sta.b $7D		; $808BC4: 85 7D
	lda.w #$0233		; $808BC6: A9 33 02
	sta.b $83		; $808BC9: 85 83
	jsl.l $888942		; $808BCB: 22 42 89 88
	lda.b $95		; $808BCF: A5 95
	sta.b $83		; $808BD1: 85 83
	pha		; $808BD3: 48
	lda.w $0DBF,x		; $808BD4: BD BF 0D
	asl a		; $808BD7: 0A
	asl a		; $808BD8: 0A
	tay		; $808BD9: A8
	lda.w #$AE36		; $808BDA: A9 36 AE
	sta.b $33		; $808BDD: 85 33
	lda.w #$0080		; $808BDF: A9 80 00
	sta.b $35		; $808BE2: 85 35
	lda.b [$33],y		; $808BE4: B7 33
	iny		; $808BE6: C8
	iny		; $808BE7: C8
	sta.b $7D		; $808BE8: 85 7D
	jsl.l $808496		; $808BEA: 22 96 84 80
	adc.w $0ADF,x		; $808BEE: 7D DF 0A
	sta.w $0ADF,x		; $808BF1: 9D DF 0A
	lda.b [$33],y		; $808BF4: B7 33
	sta.b $7D		; $808BF6: 85 7D
	pla		; $808BF8: 68
	sta.b $83		; $808BF9: 85 83
	jsl.l $808496		; $808BFB: 22 96 84 80
	adc.w $0AFF,x		; $808BFF: 7D FF 0A
	sta.w $0AFF,x		; $808C02: 9D FF 0A
	bit.w #$8000		; $808C05: 89 00 80
	beq CODE_808C0E		; $808C08: F0 04
	eor.w #$FFFF		; $808C0A: 49 FF FF
	inc a		; $808C0D: 1A
CODE_808C0E:		; M=16 X=16
	sta.b $73		; $808C0E: 85 73
	lda.w $0ADF,x		; $808C10: BD DF 0A
	bit.w #$8000		; $808C13: 89 00 80
	beq CODE_808C1C		; $808C16: F0 04
	eor.w #$FFFF		; $808C18: 49 FF FF
	inc a		; $808C1B: 1A
CODE_808C1C:		; M=16 X=16
	clc		; $808C1C: 18
	adc.b $73		; $808C1D: 65 73
	sta.w $126F,x		; $808C1F: 9D 6F 12
	lda.w #$0BCA		; $808C22: A9 CA 0B
	sta.b $57		; $808C25: 85 57
	sta.w $117F,x		; $808C27: 9D 7F 11
	jmp.w $B006		; $808C2A: 4C 06 B0
	db $22,$D3,$FF,$8B,$BD,$7F,$0C,$38,$E5,$6F,$9D,$7F,$0C,$30,$03,$4C	; $808C2D
	db $1B,$8D,$69,$09,$00,$9D,$7F,$0C,$22,$36,$FE,$8D,$A5,$57,$48,$A5	; $808C3D
	db $53,$48,$8A,$22,$0A,$9B,$80,$A5,$53,$49,$FF,$FF,$1A,$38,$FD,$E0	; $808C4D
	db $0A,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$18,$63,$01,$38	; $808C5D
	db $FD,$FF,$08,$85,$53,$A5,$57,$49,$FF,$FF,$1A,$38,$FD,$00,$0B,$29	; $808C6D
	db $FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$18,$63,$03,$38,$FD,$5F	; $808C7D
	db $09,$85,$57,$68,$68,$22,$A8,$AF,$80,$A5,$53,$9D,$FF,$0C,$BD,$9F	; $808C8D
	db $0B,$F0,$7B,$AD,$FB,$0A,$85,$53,$AD,$1B,$0B,$85,$57,$22,$A8,$AF	; $808C9D
	db $80,$A5,$53,$49,$04,$00,$DD,$BF,$0D,$F0,$63,$AD,$7B,$09,$38,$FD	; $808CAD
	db $5F,$09,$85,$57,$48,$AD,$1B,$09,$38,$FD,$FF,$08,$85,$53,$48,$22	; $808CBD
	db $A8,$AF,$80,$A5,$53,$85,$73,$68,$85,$53,$85,$7D,$85,$83,$68,$85	; $808CCD
	db $57,$BD,$BF,$0D,$C5,$73,$D0,$36,$22,$DB,$FC,$82,$85,$53,$A5,$95	; $808CDD
	db $85,$55,$A5,$57,$85,$7D,$85,$83,$22,$DB,$FC,$82,$65,$53,$85,$53	; $808CED
	db $A5,$55,$65,$95,$85,$55,$A5,$53,$C9,$85,$03,$A5,$55,$E9,$00,$00	; $808CFD
	db $90,$0C,$A5,$53,$C9,$A5,$05,$A5,$55,$E9,$00,$00,$90,$6F,$BD,$FF	; $808D0D
	db $0C,$85,$53,$BD,$9F,$0B,$F0,$61,$BD,$FF,$08,$38,$ED,$1B,$09,$89	; $808D1D
	db $00,$80,$F0,$04,$49,$FF,$FF,$1A,$85,$73,$BD,$5F,$09,$38,$ED,$7B	; $808D2D
	db $09,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$18,$65,$73,$C9,$36,$00	; $808D3D
	db $B0,$37,$BD,$DF,$0A,$85,$7D,$A9,$07,$00,$85,$83,$22,$DB,$FC,$82	; $808D4D
	db $46,$95,$6A,$46,$95,$6A,$46,$95,$6A,$9D,$DF,$0A,$BD,$FF,$0A,$85	; $808D5D
	db $7D,$A9,$07,$00,$85,$83,$22,$DB,$FC,$82,$46,$95,$6A,$46,$95,$6A	; $808D6D
	db $46,$95,$6A,$46,$95,$6A,$9D,$FF,$0A,$5C,$DC,$FB,$8F	; $808D7D
CODE_808D8A:		; M=16 X=16
	lda.w #$0A90		; $808D8A: A9 90 0A
	sta.b $57		; $808D8D: 85 57
	sta.w $117F,x		; $808D8F: 9D 7F 11
	jmp.w $B006		; $808D92: 4C 06 B0
	db $AD,$8C,$12,$29,$00,$20,$D0,$02,$1A,$6B	; $808D95
CODE_808D9F:		; M=16 X=16
	lda.w $119F,x		; $808D9F: BD 9F 11
	bne CODE_808DAE		; $808DA2: D0 0A
	lda.w $128C		; $808DA4: AD 8C 12
	and.w #$4000		; $808DA7: 29 00 40
	eor.w #$4000		; $808DAA: 49 00 40
	rtl		; $808DAD: 6B
CODE_808DAE:		; M=16 X=16
	lda.w $128C		; $808DAE: AD 8C 12
	and.w #$4000		; $808DB1: 29 00 40
	rtl		; $808DB4: 6B
	db $BD,$DF,$0E,$89,$02,$00,$F0,$08,$29,$FD,$FF,$9D,$DF,$0E,$80,$24	; $808DB5
	db $AD,$8C,$12,$89,$08,$00,$D0,$03,$4C,$F9,$96,$BD,$5F,$0C,$85,$53	; $808DC5
	db $64,$5B,$BD,$FF,$0C,$38,$E5,$6F,$9D,$FF,$0C,$10,$51,$A9,$80,$00	; $808DD5
	db $04,$5B,$80,$4A	; $808DE5
CODE_808DE9:		; M=16 X=16
	lda.w #$0008		; $808DE9: A9 08 00
	sta.w $043B		; $808DEC: 8D 3B 04
	lda.w #$0008		; $808DEF: A9 08 00
	tsb.w $128C		; $808DF2: 0C 8C 12
	stz.b $53		; $808DF5: 64 53
	lda.w #$0128		; $808DF7: A9 28 01
	sta.b $57		; $808DFA: 85 57
	lda.w $113F,x		; $808DFC: BD 3F 11
	bne CODE_808E06		; $808DFF: D0 05
	lda.w #$FED8		; $808E01: A9 D8 FE
	sta.b $57		; $808E04: 85 57
CODE_808E06:		; M=16 X=16
	lda.b $53		; $808E06: A5 53
	sec		; $808E08: 38
	sbc.w $08FF,x		; $808E09: FD FF 08
	sta.b $53		; $808E0C: 85 53
	lda.b $57		; $808E0E: A5 57
	sec		; $808E10: 38
	sbc.w $095F,x		; $808E11: FD 5F 09
	sta.b $57		; $808E14: 85 57
	jsl.l $80AFA8		; $808E16: 22 A8 AF 80
	lda.w #$000F		; $808E1A: A9 0F 00
	sta.w $043D		; $808E1D: 8D 3D 04
	lda.w #$07A8		; $808E20: A9 A8 07
	sta.b $57		; $808E23: 85 57
	jsl.l $8FF603		; $808E25: 22 03 F6 8F
	beq CODE_808E30		; $808E29: F0 05
	lda.w #$08BA		; $808E2B: A9 BA 08
	sta.b $57		; $808E2E: 85 57
CODE_808E30:		; M=16 X=16
	jmp.w $B006		; $808E30: 4C 06 B0
CODE_808E33:		; M=16 X=16
	lda.w $0E1F,x		; $808E33: BD 1F 0E
	cmp.w #$0018		; $808E36: C9 18 00
	bcs CODE_808E78		; $808E39: B0 3D
	lda.b $53		; $808E3B: A5 53
	bit.w #$0008		; $808E3D: 89 08 00
	bne CODE_808E48		; $808E40: D0 06
	and.w #$0007		; $808E42: 29 07 00
	sta.w $043B		; $808E45: 8D 3B 04
CODE_808E48:		; M=16 X=16
	lda.w $0E1F,x		; $808E48: BD 1F 0E
	cmp.w #$0010		; $808E4B: C9 10 00
	bcs CODE_808E77		; $808E4E: B0 27
	lda.w $043D		; $808E50: AD 3D 04
	clc		; $808E53: 18
	adc.b $6F		; $808E54: 65 6F
	sta.w $043D		; $808E56: 8D 3D 04
	lda.b $5B		; $808E59: A5 5B
	bit.w #$0080		; $808E5B: 89 80 00
	beq CODE_808E77		; $808E5E: F0 17
	lda.w #$001C		; $808E60: A9 1C 00
	sec		; $808E63: 38
	sbc.w $0E1F,x		; $808E64: FD 1F 0E
	sta.w $0E1F,x		; $808E67: 9D 1F 0E
	cmp.w #$0018		; $808E6A: C9 18 00
	bcc CODE_808E77		; $808E6D: 90 08
	lda.w #$0018		; $808E6F: A9 18 00
	sta.w $0E1F,x		; $808E72: 9D 1F 0E
	bra CODE_808E78		; $808E75: 80 01
CODE_808E77:		; M=16 X=16
	rtl		; $808E77: 6B
CODE_808E78:		; M=16 X=16
	stx.b $0A		; $808E78: 86 0A
	ldx.w #$0000		; $808E7A: A2 00 00
CODE_808E7D:		; M=16 X=16
	lda.b $53,x		; $808E7D: B5 53
	pha		; $808E7F: 48
	inx		; $808E80: E8
	inx		; $808E81: E8
	cpx.w #$0020		; $808E82: E0 20 00
	bne CODE_808E7D		; $808E85: D0 F6
	ldx.b $0A		; $808E87: A6 0A
	stx.b $0A		; $808E89: 86 0A
	ldx.w #$0000		; $808E8B: A2 00 00
CODE_808E8E:		; M=16 X=16
	lda.b $33,x		; $808E8E: B5 33
	pha		; $808E90: 48
	inx		; $808E91: E8
	inx		; $808E92: E8
	cpx.w #$0010		; $808E93: E0 10 00
	bne CODE_808E8E		; $808E96: D0 F6
	ldx.b $0A		; $808E98: A6 0A
	jsl.l $80FD7C		; $808E9A: 22 7C FD 80
	lda.w $04A1		; $808E9E: AD A1 04
	and.w #$0003		; $808EA1: 29 03 00
	clc		; $808EA4: 18
	adc.w #$0098		; $808EA5: 69 98 00
	pha		; $808EA8: 48
	lda.w #$0008		; $808EA9: A9 08 00
	trb.w $128C		; $808EAC: 1C 8C 12
	sta.w $117F,x		; $808EAF: 9D 7F 11
	txa		; $808EB2: 8A
	lsr a		; $808EB3: 4A
	sta.w $04A5		; $808EB4: 8D A5 04
	cmp.w $0EBB		; $808EB7: CD BB 0E
	beq CODE_808EBF		; $808EBA: F0 03
	jmp.w $90A4		; $808EBC: 4C A4 90
CODE_808EBF:		; M=16 X=16
	lda.w #$008D		; $808EBF: A9 8D 00
	sta.b $01,s		; $808EC2: 83 01
	lda.w #$1000		; $808EC4: A9 00 10
	tsb.w $128C		; $808EC7: 0C 8C 12
	lda.w $0DFF,x		; $808ECA: BD FF 0D
	cmp.w #$08BA		; $808ECD: C9 BA 08
	bne CODE_808EE7		; $808ED0: D0 15
	lda.w #$008E		; $808ED2: A9 8E 00
	sta.b $01,s		; $808ED5: 83 01
	lda.w $043D		; $808ED7: AD 3D 04
	lsr a		; $808EDA: 4A
	lsr a		; $808EDB: 4A
	eor.w #$FFFF		; $808EDC: 49 FF FF
	inc a		; $808EDF: 1A
	clc		; $808EE0: 18
	adc.w $043D		; $808EE1: 6D 3D 04
	sta.w $043D		; $808EE4: 8D 3D 04
CODE_808EE7:		; M=16 X=16
	lda.w $043D		; $808EE7: AD 3D 04
	cmp.w #$0032		; $808EEA: C9 32 00
	bcc CODE_808EF4		; $808EED: 90 05
	lda.w #$008F		; $808EEF: A9 8F 00
	sta.b $01,s		; $808EF2: 83 01
CODE_808EF4:		; M=16 X=16
	lda.w $0FDF,x		; $808EF4: BD DF 0F
	sta.b $53		; $808EF7: 85 53
	stx.b $33		; $808EF9: 86 33
	jsl.l $80A1B4		; $808EFB: 22 B4 A1 80
	adc.w #$0014		; $808EFF: 69 14 00
	sta.b $83		; $808F02: 85 83
	lda.w $043D		; $808F04: AD 3D 04
	sta.b $7D		; $808F07: 85 7D
	jsl.l $8D871C		; $808F09: 22 1C 87 8D
	lda.w #$2570		; $808F0D: A9 70 25
	sta.b $7D		; $808F10: 85 7D
	jsl.l $888942		; $808F12: 22 42 89 88
	lda.b $95		; $808F16: A5 95
	sta.w $043D		; $808F18: 8D 3D 04
	lda.w #$FFFF		; $808F1B: A9 FF FF
	sta.w $0EBB		; $808F1E: 8D BB 0E
	lda.w #$0010		; $808F21: A9 10 00
	sta.w $0E5F,x		; $808F24: 9D 5F 0E
	txa		; $808F27: 8A
	lsr a		; $808F28: 4A
	sta.w $017D		; $808F29: 8D 7D 01
	lda.w #$0108		; $808F2C: A9 08 01
	sta.b $57		; $808F2F: 85 57
	lda.w $113F,x		; $808F31: BD 3F 11
	bne CODE_808F3B		; $808F34: D0 05
	lda.w #$FEF8		; $808F36: A9 F8 FE
	sta.b $57		; $808F39: 85 57
CODE_808F3B:		; M=16 X=16
	lda.w $043B		; $808F3B: AD 3B 04
	asl a		; $808F3E: 0A
	asl a		; $808F3F: 0A
	tay		; $808F40: A8
	lda.w #$90EB		; $808F41: A9 EB 90
	sta.b $33		; $808F44: 85 33
	lda.w #$0080		; $808F46: A9 80 00
	sta.b $35		; $808F49: 85 35
	lda.b [$33],y		; $808F4B: B7 33
	sec		; $808F4D: 38
	sbc.w $091B		; $808F4E: ED 1B 09
	sta.b $53		; $808F51: 85 53
	iny		; $808F53: C8
	iny		; $808F54: C8
	lda.b [$33],y		; $808F55: B7 33
	sta.b $5B		; $808F57: 85 5B
	pha		; $808F59: 48
	lda.b $57		; $808F5A: A5 57
	sec		; $808F5C: 38
	sbc.w $097B		; $808F5D: ED 7B 09
	sta.b $57		; $808F60: 85 57
	pha		; $808F62: 48
	lda.b $53		; $808F63: A5 53
	pha		; $808F65: 48
	sta.b $7D		; $808F66: 85 7D
	sta.b $83		; $808F68: 85 83
	jsl.l $82FCDB		; $808F6A: 22 DB FC 82
	sta.b $53		; $808F6E: 85 53
	lda.b $95		; $808F70: A5 95
	sta.b $55		; $808F72: 85 55
	lda.b $57		; $808F74: A5 57
	sta.b $7D		; $808F76: 85 7D
	sta.b $83		; $808F78: 85 83
	jsl.l $82FCDB		; $808F7A: 22 DB FC 82
	adc.b $53		; $808F7E: 65 53
	sta.b $53		; $808F80: 85 53
	lda.b $95		; $808F82: A5 95
	adc.b $55		; $808F84: 65 55
	sta.b $55		; $808F86: 85 55
	jsl.l $80CBB1		; $808F88: 22 B1 CB 80
	bne CODE_808F8F		; $808F8C: D0 01
	inc a		; $808F8E: 1A
CODE_808F8F:		; M=16 X=16
	sta.b $5F		; $808F8F: 85 5F
	lda.w $1288		; $808F91: AD 88 12
	bit.w #$0010		; $808F94: 89 10 00
	beq CODE_808F9C		; $808F97: F0 03
	jmp.w $901C		; $808F99: 4C 1C 90
CODE_808F9C:		; M=16 X=16
	lda.b $5F		; $808F9C: A5 5F
	cmp.w #$00C9		; $808F9E: C9 C9 00
	bcs CODE_808FB2		; $808FA1: B0 0F
	lda.w #$0010		; $808FA3: A9 10 00
	adc.w $0FFF,x		; $808FA6: 7D FF 0F
	jsl.l $80AE8B		; $808FA9: 22 8B AE 80
	cmp.w #$000F		; $808FAD: C9 0F 00
	bcs CODE_80901C		; $808FB0: B0 6A
CODE_808FB2:		; M=16 X=16
	lda.w $043D		; $808FB2: AD 3D 04
	lsr a		; $808FB5: 4A
	lsr a		; $808FB6: 4A
	lsr a		; $808FB7: 4A
	sec		; $808FB8: 38
	sbc.w $0FFF,x		; $808FB9: FD FF 0F
	clc		; $808FBC: 18
	adc.w #$0010		; $808FBD: 69 10 00
	sta.b $83		; $808FC0: 85 83
	lda.b $5F		; $808FC2: A5 5F
	sta.b $7D		; $808FC4: 85 7D
	jsl.l $8D871C		; $808FC6: 22 1C 87 8D
	lsr a		; $808FCA: 4A
	lsr a		; $808FCB: 4A
	lsr a		; $808FCC: 4A
	lsr a		; $808FCD: 4A
	lsr a		; $808FCE: 4A
	lsr a		; $808FCF: 4A
	sta.b $53		; $808FD0: 85 53
	lda.b $5F		; $808FD2: A5 5F
	cmp.w #$00FB		; $808FD4: C9 FB 00
	bcs CODE_808FDB		; $808FD7: B0 02
	lsr.b $53		; $808FD9: 46 53
CODE_808FDB:		; M=16 X=16
	lda.b $53		; $808FDB: A5 53
	cmp.w #$0088		; $808FDD: C9 88 00
	bcc CODE_808FE7		; $808FE0: 90 05
	lda.w #$0088		; $808FE2: A9 88 00
	sta.b $53		; $808FE5: 85 53
CODE_808FE7:		; M=16 X=16
	lda.b $53		; $808FE7: A5 53
	pha		; $808FE9: 48
	jsl.l $80F6A1		; $808FEA: 22 A1 F6 80
	adc.b $03,s		; $808FEE: 63 03
	sta.b $03,s		; $808FF0: 83 03
	lda.b $01,s		; $808FF2: A3 01
	sta.b $53		; $808FF4: 85 53
	cmp.w #$003D		; $808FF6: C9 3D 00
	bcc CODE_809002		; $808FF9: 90 07
	lda.w #$003C		; $808FFB: A9 3C 00
	sta.b $53		; $808FFE: 85 53
	sta.b $01,s		; $809000: 83 01
CODE_809002:		; M=16 X=16
	lda.b $05,s		; $809002: A3 05
	bpl CODE_809008		; $809004: 10 02
	lsr.b $53		; $809006: 46 53
CODE_809008:		; M=16 X=16
	jsl.l $8FE316		; $809008: 22 16 E3 8F
	lda.b $05,s		; $80900C: A3 05
	adc.b $53		; $80900E: 65 53
	sta.b $05,s		; $809010: 83 05
	pla		; $809012: 68
	lsr a		; $809013: 4A
	jsl.l $80AE8B		; $809014: 22 8B AE 80
	adc.b $05,s		; $809018: 63 05
	sta.b $05,s		; $80901A: 83 05
CODE_80901C:		; M=16 X=16
	lda.w $043D		; $80901C: AD 3D 04
	sta.b $83		; $80901F: 85 83
	lda.w #$0044		; $809021: A9 44 00
	sta.b $7D		; $809024: 85 7D
	jsl.l $808496		; $809026: 22 96 84 80
	pla		; $80902A: 68
	sta.b $7D		; $80902B: 85 7D
	jsl.l $82FCDB		; $80902D: 22 DB FC 82
	lda.b $5F		; $809031: A5 5F
	sta.b $7D		; $809033: 85 7D
	jsl.l $80996C		; $809035: 22 6C 99 80
	asl a		; $809039: 0A
	sta.w $0AFB		; $80903A: 8D FB 0A
	lda.w $043D		; $80903D: AD 3D 04
	sta.b $83		; $809040: 85 83
	lda.w #$0044		; $809042: A9 44 00
	sta.b $7D		; $809045: 85 7D
	jsl.l $808496		; $809047: 22 96 84 80
	pla		; $80904B: 68
	sta.b $7D		; $80904C: 85 7D
	jsl.l $82FCDB		; $80904E: 22 DB FC 82
	lda.b $5F		; $809052: A5 5F
	sta.b $7D		; $809054: 85 7D
	jsl.l $80996C		; $809056: 22 6C 99 80
	asl a		; $80905A: 0A
	sta.w $0B1B		; $80905B: 8D 1B 0B
	pla		; $80905E: 68
	beq CODE_8090A4		; $80905F: F0 43
	sta.b $83		; $809061: 85 83
	lda.w $043D		; $809063: AD 3D 04
	sta.b $7D		; $809066: 85 7D
	jsl.l $8D871C		; $809068: 22 1C 87 8D
	lda.w #$0044		; $80906C: A9 44 00
	sta.b $7D		; $80906F: 85 7D
	jsl.l $888942		; $809071: 22 42 89 88
	lda.b $5F		; $809075: A5 5F
	sta.b $7D		; $809077: 85 7D
	jsl.l $80CBE5		; $809079: 22 E5 CB 80
	asl a		; $80907D: 0A
	sta.b $57		; $80907E: 85 57
	lda.w #$0B33		; $809080: A9 33 0B
	sta.b $7D		; $809083: 85 7D
	lda.b $5F		; $809085: A5 5F
	sta.b $83		; $809087: 85 83
	jsl.l $888942		; $809089: 22 42 89 88
	lda.w $043D		; $80908D: AD 3D 04
	sta.b $7D		; $809090: 85 7D
	jsl.l $80CBE5		; $809092: 22 E5 CB 80
	lsr a		; $809096: 4A
	adc.b $57		; $809097: 65 57
	cmp.w #$1801		; $809099: C9 01 18
	bcc CODE_8090A1		; $80909C: 90 03
	lda.w #$1800		; $80909E: A9 00 18
CODE_8090A1:		; M=16 X=16
	sta.w $0B3B		; $8090A1: 8D 3B 0B
CODE_8090A4:		; M=16 X=16
	jsl.l $80C28B		; $8090A4: 22 8B C2 80
	stx.b $0A		; $8090A8: 86 0A
	ldx.w #$000E		; $8090AA: A2 0E 00
CODE_8090AD:		; M=16 X=16
	pla		; $8090AD: 68
	sta.b $33,x		; $8090AE: 95 33
	dex		; $8090B0: CA
	dex		; $8090B1: CA
	bpl CODE_8090AD		; $8090B2: 10 F9
	ldx.b $0A		; $8090B4: A6 0A
	stx.b $0A		; $8090B6: 86 0A
	ldx.w #$001E		; $8090B8: A2 1E 00
CODE_8090BB:		; M=16 X=16
	pla		; $8090BB: 68
	sta.b $53,x		; $8090BC: 95 53
	dex		; $8090BE: CA
	dex		; $8090BF: CA
	bpl CODE_8090BB		; $8090C0: 10 F9
	ldx.b $0A		; $8090C2: A6 0A
	ldx.b $3F		; $8090C4: A6 3F
	lda.w #$0108		; $8090C6: A9 08 01
	sta.b $73		; $8090C9: 85 73
	lda.w $113F,x		; $8090CB: BD 3F 11
	bne CODE_8090D5		; $8090CE: D0 05
	lda.w #$FEF8		; $8090D0: A9 F8 FE
	sta.b $73		; $8090D3: 85 73
CODE_8090D5:		; M=16 X=16
	lda.b $73		; $8090D5: A5 73
	sec		; $8090D7: 38
	sbc.w $097B		; $8090D8: ED 7B 09
	eor.w $0B1B		; $8090DB: 4D 1B 0B
	bpl CODE_8090EA		; $8090DE: 10 0A
	lda.w $0B1B		; $8090E0: AD 1B 0B
	eor.w #$FFFF		; $8090E3: 49 FF FF
	inc a		; $8090E6: 1A
	sta.w $0B1B		; $8090E7: 8D 1B 0B
CODE_8090EA:		; M=16 X=16
	rtl		; $8090EA: 6B
	db $00,$00,$0C,$00,$10,$00,$0C,$00,$10,$00,$06,$00,$10,$00,$00,$00	; $8090EB
	db $00,$00,$00,$00,$F0,$FF,$00,$00,$F0,$FF,$06,$00,$F0,$FF,$0C,$00	; $8090FB
	db $00,$00,$06,$00,$BD,$7F,$11,$D0,$47,$AD,$8A,$12,$F0,$04,$5C,$5A	; $80910B
	db $D7,$8F,$BD,$DF,$0E,$89,$08,$00,$F0,$03,$4C,$F9,$96,$89,$02,$00	; $80911B
	db $F0,$12,$29,$FD,$FF,$09,$01,$00,$9D,$DF,$0E,$9E,$7F,$0C,$A9,$08	; $80912B
	db $00,$9D,$FF,$0C,$AD,$BB,$0E,$10,$0B,$BD,$5F,$0C,$38,$E5,$6F,$9D	; $80913B
	db $5F,$0C,$10,$0C,$BD,$DF,$0E,$29,$FE,$FF,$9D,$DF,$0E,$4C,$F9,$96	; $80914B
	db $6B,$BD,$7F,$11,$F0,$03,$4C,$29,$93,$AD,$E0,$12,$10,$04,$5C,$5A	; $80915B
	db $D7,$8F,$BD,$DF,$0E,$89,$02,$00,$F0,$46,$29,$FD,$FF,$9D,$DF,$0E	; $80916B
	db $22,$C4,$84,$80,$BD,$DF,$10,$85,$57,$85,$7D,$A5,$53,$85,$83,$22	; $80917B
	db $1C,$87,$8D,$EB,$29,$FF,$00,$4A,$4A,$4A,$4A,$C9,$06,$00,$B0,$03	; $80918B
	db $A9,$05,$00,$9D,$9F,$0C,$9E,$7F,$0C,$9E,$FF,$0C,$A9,$FF,$FF,$9D	; $80919B
	db $BF,$0C,$BD,$BF,$0D,$C9,$02,$00,$D0,$06,$A9,$5A,$00,$9D,$BF,$0C	; $8091AB
	db $BD,$FF,$08,$38,$E9,$6F,$00,$F0,$11,$30,$04,$50,$04,$80,$0B,$50	; $8091BB
	db $09,$9E,$DF,$0A,$A9,$6F,$00,$9D,$FF,$08,$BD,$FF,$08,$38,$E9,$91	; $8091CB
	db $FF,$30,$04,$70,$04,$80,$0B,$70,$09,$9E,$DF,$0A,$A9,$91,$FF,$9D	; $8091DB
	db $FF,$08,$BD,$BF,$0C,$38,$E5,$6F,$9D,$BF,$0C,$BD,$9F,$0C,$10,$03	; $8091EB
	db $4C,$29,$93,$BD,$3F,$0B,$0A,$85,$33,$A8,$BD,$FF,$08,$79,$FF,$08	; $8091FB
	db $48,$0A,$68,$6A,$8D,$F5,$08,$BD,$DF,$0E,$89,$08,$00,$D0,$7B,$BD	; $80920B
	db $DF,$11,$48,$A9,$01,$00,$9D,$DF,$11,$68,$D0,$6E,$BD,$FF,$08,$38	; $80921B
	db $F9,$FF,$08,$85,$53,$BD,$DF,$0A,$EB,$29,$FF,$00,$89,$80,$00,$F0	; $80922B
	db $03,$09,$00,$FF,$18,$65,$53,$85,$53,$B9,$DF,$0A,$EB,$29,$FF,$00	; $80923B
	db $89,$80,$00,$F0,$03,$09,$00,$FF,$85,$57,$A5,$53,$38,$E5,$57,$85	; $80924B
	db $53,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$19,$00,$B0,$2B,$A9	; $80925B
	db $08,$00,$85,$53,$22,$A3,$97,$80,$A5,$53,$C9,$03,$00,$90,$05,$29	; $80926B
	db $01,$00,$85,$53,$06,$53,$A9,$2A,$93,$85,$37,$A9,$80,$00,$85,$39	; $80927B
	db $A4,$53,$B7,$37,$85,$57,$22,$06,$B0,$80,$22,$30,$93,$80,$BD,$FF	; $80928B
	db $0D,$C9,$2E,$0F,$F0,$0D,$C9,$DA,$0E,$F0,$4B,$BD,$DF,$0E,$89,$08	; $80929B
	db $00,$D0,$43,$AD,$F5,$08,$18,$69,$0A,$00,$85,$53,$BD,$BF,$0D,$C9	; $8092AB
	db $02,$00,$D0,$08,$A5,$53,$38,$E9,$14,$00,$85,$53,$A5,$53,$38,$FD	; $8092BB
	db $FF,$08,$85,$7D,$A9,$23,$00,$85,$83,$BD,$BF,$0D,$38,$E9,$04,$00	; $8092CB
	db $45,$7D,$30,$05,$A9,$05,$00,$85,$83,$22,$96,$84,$80,$85,$53,$18	; $8092DB
	db $7D,$DF,$0A,$9D,$DF,$0A,$AD,$F7,$08,$38,$FD,$5F,$09,$EB,$29,$00	; $8092EB
	db $FF,$85,$57,$38,$E9,$00,$10,$30,$04,$50,$04,$80,$07,$50,$05,$A9	; $8092FB
	db $00,$10,$85,$57,$A5,$57,$38,$E9,$00,$F0,$F0,$08,$30,$04,$70,$04	; $80930B
	db $80,$07,$70,$05,$A9,$00,$F0,$85,$57,$A5,$57,$9D,$FF,$0A,$6B,$50	; $80931B
	db $0F,$82,$0F,$0C,$0F,$86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0	; $80932B
	db $04,$00,$D0,$F6,$A6,$0A,$86,$0A,$A2,$00,$00,$B5,$33,$48,$E8,$E8	; $80933B
	db $E0,$10,$00,$D0,$F6,$A6,$0A,$A4,$33,$BD,$3F,$09,$DD,$FF,$09,$F0	; $80934B
	db $5C,$C9,$64,$01,$F0,$76,$BD,$FF,$08,$38,$F9,$FF,$08,$89,$00,$80	; $80935B
	db $F0,$04,$49,$FF,$FF,$1A,$C9,$17,$00,$B0,$42,$BD,$5F,$09,$38,$F9	; $80936B
	db $5F,$09,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$09,$00,$B0,$2D	; $80937B
	db $BD,$3F,$09,$C9,$68,$01,$D0,$03,$4C,$3D,$94,$C9,$6D,$01,$D0,$03	; $80938B
	db $4C,$3D,$94,$C9,$69,$01,$D0,$03,$4C,$68,$94,$C9,$6E,$01,$D0,$03	; $80939B
	db $4C,$68,$94,$C9,$66,$01,$F0,$73,$C9,$6B,$01,$F0,$6E,$86,$0A,$A2	; $8093AB
	db $0E,$00,$68,$95,$33,$CA,$CA,$10,$F9,$A6,$0A,$86,$0A,$A2,$02,$00	; $8093BB
	db $68,$95,$53,$CA,$CA,$10,$F9,$A6,$0A,$A6,$3F,$6B,$BD,$DF,$0E,$29	; $8093CB
	db $FF,$7F,$9D,$DF,$0E,$AD,$F5,$08,$85,$53,$38,$E9,$5A,$00,$30,$04	; $8093DB
	db $50,$04,$80,$07,$50,$05,$A9,$5A,$00,$85,$53,$A5,$53,$38,$E9,$A6	; $8093EB
	db $FF,$F0,$08,$30,$04,$70,$04,$80,$07,$70,$05,$A9,$A6,$FF,$85,$53	; $8093FB
	db $A5,$53,$4A,$4A,$29,$FF,$00,$D0,$01,$1A,$8D,$4E,$01,$AD,$F7,$08	; $80940B
	db $4A,$4A,$E2,$20,$8D,$4F,$01,$C2,$30,$80,$92,$A6,$33,$A4,$3F,$86	; $80941B
	db $3F,$84,$33,$A9,$2E,$0F,$85,$57,$9D,$DF,$11,$22,$06,$B0,$80,$4C	; $80942B
	db $B8,$93,$A6,$33,$A4,$3F,$86,$3F,$84,$33,$22,$93,$94,$80,$A9,$01	; $80943B
	db $00,$9D,$DF,$11,$DE,$9F,$0C,$30,$77,$A9,$B4,$0F,$85,$57,$22,$06	; $80944B
	db $B0,$80,$A9,$92,$00,$48,$22,$8B,$C2,$80,$4C,$B8,$93,$A6,$33,$A4	; $80945B
	db $3F,$86,$3F,$84,$33,$22,$93,$94,$80,$A9,$01,$00,$9D,$DF,$11,$DE	; $80946B
	db $9F,$0C,$30,$4C,$A9,$D6,$0F,$85,$57,$22,$06,$B0,$80,$A9,$93,$00	; $80947B
	db $48,$22,$8B,$C2,$80,$4C,$B8,$93,$A4,$33,$A5,$DE,$18,$69,$50,$00	; $80948B
	db $85,$DE,$A9,$05,$00,$18,$79,$9F,$0C,$85,$83,$A9,$F4,$01,$85,$7D	; $80949B
	db $22,$1C,$87,$8D,$85,$53,$BD,$BF,$0D,$C9,$02,$00,$D0,$08,$A5,$53	; $8094AB
	db $49,$FF,$FF,$1A,$85,$53,$BD,$DF,$0A,$18,$65,$53,$9D,$DF,$0A,$6B	; $8094BB
	db $A5,$39,$48,$A5,$37,$48,$A9,$9C,$12,$85,$37,$A9,$00,$00,$85,$39	; $8094CB
	db $E6,$37,$E6,$37,$A7,$37,$29,$FF,$00,$C9,$26,$00,$D0,$F2,$A7,$37	; $8094DB
	db $EB,$29,$0F,$00,$85,$53,$A4,$33,$D9,$9F,$0D,$D0,$E3,$E2,$20,$A9	; $8094EB
	db $28,$87,$37,$C2,$20,$68,$85,$37,$68,$85,$39,$A9,$3C,$00,$8D,$E0	; $8094FB
	db $12,$A9,$FF,$FF,$99,$9F,$0C,$A5,$DE,$18,$69,$58,$02,$85,$DE,$A9	; $80950B
	db $3C,$00,$85,$53,$22,$A3,$97,$80,$A4,$33,$A5,$53,$38,$F9,$FF,$10	; $80951B
	db $F0,$08,$30,$04,$70,$04,$80,$3D,$70,$3B,$A9,$B4,$00,$8D,$E0,$12	; $80952B
	db $BD,$DF,$0E,$09,$04,$00,$9D,$DF,$0E,$A9,$56,$11,$85,$57,$22,$06	; $80953B
	db $B0,$80,$86,$3B,$22,$4A,$F7,$8F,$A5,$33,$F0,$03,$A9,$34,$00,$18	; $80954B
	db $65,$57,$A8,$A9,$2C,$11,$99,$E2,$14,$A9,$03,$00,$8D,$E6,$12,$9E	; $80955B
	db $DF,$0A,$4C,$B8,$93,$A9,$F8,$0F,$85,$57,$22,$06,$B0,$80,$64,$3B	; $80956B
	db $A9,$8A,$00,$48,$BD,$9F,$11,$D0,$0A,$A9,$02,$00,$85,$3B,$A9,$8B	; $80957B
	db $00,$83,$01,$22,$8B,$C2,$80,$4C,$B8,$93,$BD,$7F,$11,$F0,$03,$4C	; $80958B
	db $A7,$96,$BD,$DF,$0E,$89,$08,$00,$F0,$03,$4C,$A7,$96,$89,$02,$00	; $80959B
	db $F0,$09,$29,$FD,$FF,$9D,$DF,$0E,$9E,$5F,$0C,$BD,$5F,$0C,$38,$E5	; $8095AB
	db $6F,$9D,$5F,$0C,$30,$03,$4C,$78,$96,$69,$3C,$00,$9D,$5F,$0C,$BD	; $8095BB
	db $5F,$09,$38,$ED,$F7,$08,$48,$BD,$FF,$08,$38,$ED,$F5,$08,$48,$85	; $8095CB
	db $7D,$85,$83,$22,$DB,$FC,$82,$85,$53,$A5,$95,$85,$55,$A3,$03,$85	; $8095DB
	db $7D,$85,$83,$22,$DB,$FC,$82,$65,$53,$85,$53,$A5,$95,$65,$55,$85	; $8095EB
	db $55,$22,$B1,$CB,$80,$A5,$53,$D0,$03,$A9,$01,$00,$85,$5B,$68,$85	; $8095FB
	db $53,$85,$83,$68,$85,$57,$A9,$50,$00,$85,$7D,$22,$DB,$FC,$82,$A5	; $80960B
	db $5B,$85,$7D,$22,$6C,$99,$80,$6D,$F5,$08,$85,$53,$A9,$7E,$00,$85	; $80961B
	db $5F,$A5,$53,$38,$E5,$5F,$30,$04,$50,$04,$80,$06,$50,$04,$A5,$5F	; $80962B
	db $85,$53,$A5,$5F,$49,$FF,$FF,$1A,$85,$5F,$A5,$53,$38,$E5,$5F,$F0	; $80963B
	db $08,$30,$04,$70,$04,$80,$06,$70,$04,$A5,$5F,$85,$53,$A5,$53,$9D	; $80964B
	db $9F,$0C,$A9,$50,$00,$85,$7D,$A5,$57,$85,$83,$22,$DB,$FC,$82,$A5	; $80965B
	db $5B,$85,$7D,$22,$6C,$99,$80,$6D,$F7,$08,$9D,$BF,$0C,$BD,$9F,$0C	; $80966B
	db $85,$53,$BD,$BF,$0C,$85,$57,$A9,$E6,$84,$85,$33,$A9,$80,$00,$85	; $80967B
	db $35,$BD,$DF,$0A,$48,$0A,$68,$6A,$9D,$DF,$0A,$BD,$FF,$0A,$48,$0A	; $80968B
	db $68,$6A,$9D,$FF,$0A,$22,$D0,$FD,$88,$4C,$15,$8B,$6B,$BD,$7F,$11	; $80969B
	db $D0,$4B,$AD,$8C,$12,$89,$00,$01,$F0,$44,$AD,$29,$04,$F0,$10,$9C	; $8096AB
	db $29,$04,$A9,$01,$00,$85,$21,$64,$1D,$64,$1F,$22,$B3,$FB,$89,$AD	; $8096BB
	db $2B,$04,$F0,$10,$9C,$2B,$04,$A9,$01,$00,$85,$21,$64,$1D,$64,$1F	; $8096CB
	db $22,$DF,$FB,$89,$AD,$A9,$04,$D0,$14,$AD,$F2,$12,$C9,$3C,$00,$90	; $8096DB
	db $0C,$CD,$2F,$04,$B0,$07,$9C,$2F,$04,$22,$63,$FC,$89,$6B,$BD,$BF	; $8096EB
	db $0B,$1A,$29,$07,$00,$9D,$BF,$0B,$BD,$DF,$0E,$09,$02,$00,$9D,$DF	; $8096FB
	db $0E,$6B,$BD,$7F,$11,$F0,$03,$4C,$99,$97,$AD,$8C,$12,$89,$00,$01	; $80970B
	db $F0,$7D,$BD,$DF,$0E,$89,$02,$00,$F0,$09,$29,$FD,$FF,$9D,$DF,$0E	; $80971B
	db $9E,$5F,$0C,$A9,$3A,$01,$85,$33,$A9,$00,$00,$85,$35,$BD,$9F,$11	; $80972B
	db $F0,$05,$A9,$3E,$01,$85,$33,$BD,$1F,$0E,$4A,$4A,$1A,$85,$53,$BD	; $80973B
	db $1F,$11,$D0,$06,$E6,$53,$E6,$53,$E6,$53,$A5,$53,$87,$33,$BD,$DF	; $80974B
	db $0E,$89,$08,$00,$D0,$38,$BD,$DF,$11,$48,$A9,$01,$00,$9D,$DF,$11	; $80975B
	db $68,$C9,$00,$00,$D0,$28,$A9,$96,$10,$85,$57,$AD,$7B,$0C,$C9,$11	; $80976B
	db $00,$90,$12,$A9,$08,$00,$85,$53,$22,$A3,$97,$80,$A5,$53,$F0,$05	; $80977B
	db $A9,$C0,$10,$85,$57,$A9,$01,$00,$9D,$DF,$11,$4C,$06,$B0,$6B,$A9	; $80978B
	db $14,$00,$9D,$5F,$0E,$4C,$F9,$96	; $80979B
CODE_8097A3:		; M=16 X=16
	lda.b $53		; $8097A3: A5 53
	jsl.l $80AE8B		; $8097A5: 22 8B AE 80
	sta.b $53		; $8097A9: 85 53
	rtl		; $8097AB: 6B
	db $A9,$02,$00,$1C,$FB,$0E,$F0,$0C,$9C,$7B,$0C,$9C,$9B,$0C,$A9,$78	; $8097AC
	db $00,$8D,$1B,$0D,$AD,$8B,$04,$38,$E5,$6F,$8D,$8B,$04,$AD,$8F,$04	; $8097BC
	db $38,$E5,$6F,$8D,$8F,$04,$AD,$7B,$0C,$38,$E5,$6F,$8D,$7B,$0C,$10	; $8097CC
	db $0A,$69,$05,$00,$8D,$7B,$0C,$22,$8A,$98,$80,$AD,$BB,$0E,$30,$51	; $8097DC
	db $0A,$85,$3B,$22,$C7,$99,$80,$A5,$3B,$22,$0A,$9B,$80,$A4,$3B,$A5	; $8097EC
	db $53,$18,$79,$FF,$08,$38,$ED,$1B,$09,$4A,$4A,$89,$00,$20,$F0,$03	; $8097FC
	db $09,$00,$C0,$18,$6D,$1B,$09,$8D,$1B,$09,$A5,$57,$18,$79,$5F,$09	; $80980C
	db $38,$ED,$7B,$09,$4A,$4A,$89,$00,$20,$F0,$03,$09,$00,$C0,$18,$6D	; $80981C
	db $7B,$09,$8D,$7B,$09,$B9,$DF,$0A,$8D,$FB,$0A,$B9,$FF,$0A,$8D,$1B	; $80982C
	db $0B,$22,$7A,$9B,$80,$22,$C3,$9B,$80,$AD,$8A,$12,$D0,$2B,$AD,$BB	; $80983C
	db $0E,$10,$20,$AD,$1B,$09,$CD,$3B,$0A,$D0,$18,$AD,$7B,$09,$CD,$7B	; $80984C
	db $0A,$D0,$10,$A9,$06,$00,$85,$53,$CE,$1B,$0D,$10,$04,$22,$B0,$C1	; $80985C
	db $80,$80,$06,$A9,$78,$00,$8D,$1B,$0D,$AD,$3B,$0B,$29,$00,$FF,$0D	; $80986C
	db $BB,$09,$F0,$03,$4C,$17,$9D,$22,$2A,$A5,$80,$4C,$17,$9D,$86,$0A	; $80987C
	db $A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$14,$00,$D0,$F6,$A6,$0A,$A9	; $80988C
	db $08,$01,$85,$63,$A0,$00,$00,$22,$C2,$98,$80,$A9,$F8,$FE,$85,$63	; $80989C
	db $A0,$04,$00,$22,$C2,$98,$80,$86,$0A,$A2,$12,$00,$68,$95,$53,$CA	; $8098AC
	db $CA,$10,$F9,$A6,$0A,$6B,$A5,$63,$38,$ED,$7B,$09,$85,$53,$AD,$1B	; $8098BC
	db $0B,$D0,$03,$4C,$65,$99,$85,$7D,$A5,$53,$64,$83,$4A,$66,$83,$4A	; $8098CC
	db $66,$83,$4A,$66,$83,$4A,$66,$83,$89,$00,$08,$F0,$03,$09,$00,$F0	; $8098DC
	db $85,$85,$22,$6C,$99,$80,$10,$03,$4C,$65,$99,$99,$8B,$04,$AD,$FB	; $8098EC
	db $0A,$85,$7D,$A5,$53,$85,$83,$22,$DB,$FC,$82,$AD,$1B,$0B,$89,$00	; $8098FC
	db $80,$F0,$04,$49,$FF,$FF,$1A,$85,$7D,$A5,$95,$89,$00,$80,$F0,$04	; $80990C
	db $49,$FF,$FF,$1A,$C5,$7D,$B0,$41,$AD,$1B,$0B,$85,$7D,$22,$6C,$99	; $80991C
	db $80,$6D,$1B,$09,$85,$53,$38,$E9,$88,$00,$30,$04,$50,$04,$80,$0A	; $80992C
	db $50,$08,$A9,$98,$01,$38,$E5,$53,$85,$53,$A5,$53,$38,$E9,$78,$FF	; $80993C
	db $F0,$08,$30,$04,$70,$04,$80,$0A,$70,$08,$A9,$68,$FE,$38,$E5,$53	; $80994C
	db $85,$53,$A5,$53,$99,$89,$04,$80,$06,$A9,$FF,$FF,$99,$8B,$04,$6B	; $80995C
CODE_80996C:		; M=16 X=16
	stz.b $81		; $80996C: 64 81
	lda.b $7D		; $80996E: A5 7D
	bpl CODE_809978		; $809970: 10 06
	eor.w #$FFFF		; $809972: 49 FF FF
	inc a		; $809975: 1A
	inc.b $81		; $809976: E6 81
CODE_809978:		; M=16 X=16
	sta.b $7F		; $809978: 85 7F
	stz.b $7D		; $80997A: 64 7D
	lda.w #$0010		; $80997C: A9 10 00
	sta.b $87		; $80997F: 85 87
	lda.b $85		; $809981: A5 85
	bpl CODE_809996		; $809983: 10 11
	lda.w #$0000		; $809985: A9 00 00
	sec		; $809988: 38
	sbc.b $83		; $809989: E5 83
	sta.b $83		; $80998B: 85 83
	lda.w #$0000		; $80998D: A9 00 00
	sbc.b $85		; $809990: E5 85
	sta.b $85		; $809992: 85 85
	inc.b $81		; $809994: E6 81
CODE_809996:		; M=16 X=16
	lsr.b $7F		; $809996: 46 7F
	ror.b $7D		; $809998: 66 7D
	asl.b $93		; $80999A: 06 93
	lda.b $83		; $80999C: A5 83
	cmp.b $7D		; $80999E: C5 7D
	lda.b $85		; $8099A0: A5 85
	sbc.b $7F		; $8099A2: E5 7F
	bcc CODE_8099B4		; $8099A4: 90 0E
	lda.b $83		; $8099A6: A5 83
	sbc.b $7D		; $8099A8: E5 7D
	sta.b $83		; $8099AA: 85 83
	lda.b $85		; $8099AC: A5 85
	sbc.b $7F		; $8099AE: E5 7F
	sta.b $85		; $8099B0: 85 85
	inc.b $93		; $8099B2: E6 93
CODE_8099B4:		; M=16 X=16
	dec.b $87		; $8099B4: C6 87
	bne CODE_809996		; $8099B6: D0 DE
	lsr.b $81		; $8099B8: 46 81
	bcc CODE_8099C3		; $8099BA: 90 07
	lda.w #$0000		; $8099BC: A9 00 00
	sbc.b $93		; $8099BF: E5 93
	sta.b $93		; $8099C1: 85 93
CODE_8099C3:		; M=16 X=16
	lda.b $93		; $8099C3: A5 93
	clc		; $8099C5: 18
	rtl		; $8099C6: 6B
	db $A4,$3B,$B9,$FF,$08,$8D,$8D,$01,$B9,$5F,$09,$8D,$8F,$01,$98,$4A	; $8099C7
	db $8D,$8B,$01,$64,$33,$B9,$9F,$11,$F0,$04,$E6,$33,$E6,$33,$B9,$1F	; $8099D7
	db $0F,$85,$53,$A4,$33,$D9,$E2,$13,$F0,$2C,$B9,$0A,$14,$89,$04,$00	; $8099E7
	db $F0,$08,$29,$FB,$FF,$99,$0A,$14,$80,$0C,$B9,$E6,$13,$99,$EA,$13	; $8099F7
	db $B9,$E2,$13,$99,$E6,$13,$A5,$53,$99,$E2,$13,$D9,$EA,$13,$D0,$06	; $809A07
	db $A9,$FF,$FF,$99,$EA,$13,$A9,$00,$10,$1C,$8C,$12,$22,$A8,$9A,$80	; $809A17
	db $A4,$3B,$AD,$5C,$01,$89,$04,$00,$F0,$34,$89,$01,$00,$F0,$2F,$B9	; $809A27
	db $9F,$0B,$F0,$2A,$AD,$5C,$01,$89,$02,$00,$D0,$1D,$B9,$3F,$11,$F0	; $809A37
	db $1D,$DA,$AD,$5D,$01,$29,$FF,$00,$0A,$85,$3F,$AA,$A9,$0C,$00,$85	; $809A47
	db $53,$22,$8F,$C1,$80,$FA,$86,$3F,$6B,$B9,$3F,$11,$F0,$E3,$98,$4A	; $809A57
	db $EB,$8D,$5C,$01,$AD,$7B,$09,$85,$53,$B9,$3F,$11,$F0,$0E,$A9,$02	; $809A67
	db $00,$0C,$5C,$01,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$A5,$53,$30,$D8	; $809A77
	db $AD,$EE,$13,$38,$ED,$F0,$13,$85,$53,$B9,$9F,$11,$F0,$08,$A5,$53	; $809A87
	db $49,$FF,$FF,$1A,$85,$53,$A5,$53,$30,$BE,$A9,$04,$00,$0C,$5C,$01	; $809A97
	db $6B,$A4,$3B,$AD,$88,$12,$89,$20,$00,$F0,$57,$AD,$7B,$09,$85,$53	; $809AA7
	db $B9,$3F,$11,$D0,$08,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$A5,$53,$38	; $809AB7
	db $E9,$58,$00,$30,$04,$50,$04,$80,$39,$50,$37,$64,$33,$B9,$9F,$11	; $809AC7
	db $F0,$05,$A9,$02,$00,$85,$33,$A4,$33,$B9,$0A,$14,$89,$10,$00,$F0	; $809AD7
	db $21,$AD,$88,$12,$89,$10,$00,$D0,$19,$A6,$3B,$A4,$3F,$86,$3F,$84	; $809AE7
	db $3B,$A9,$10,$00,$85,$53,$22,$8F,$C1,$80,$A6,$3B,$A4,$3F,$86,$3F	; $809AF7
	db $84,$3B,$6B	; $809B07
CODE_809B0A:		; M=16 X=16
	phx		; $809B0A: DA
	tay		; $809B0B: A8
	stz.b $53		; $809B0C: 64 53
	stz.b $57		; $809B0E: 64 57
	lda.w $093F,y		; $809B10: B9 3F 09
	cmp.w #$0179		; $809B13: C9 79 01
	bcc CODE_809B1B		; $809B16: 90 03
	sbc.w #$0006		; $809B18: E9 06 00
CODE_809B1B:		; M=16 X=16
	cmp.w #$0226		; $809B1B: C9 26 02
	bcs CODE_809B78		; $809B1E: B0 58
	dec a		; $809B20: 3A
	bmi CODE_809B78		; $809B21: 30 55
	asl a		; $809B23: 0A
	tax		; $809B24: AA
	lda.l $84EF3C,x		; $809B25: BF 3C EF 84
	and.w #$00FF		; $809B29: 29 FF 00
	bit.w #$0080		; $809B2C: 89 80 00
	beq CODE_809B34		; $809B2F: F0 03
	ora.w #$FF00		; $809B31: 09 00 FF
CODE_809B34:		; M=16 X=16
	sta.b $53		; $809B34: 85 53
	lda.l $84EF3D,x		; $809B36: BF 3D EF 84
	and.w #$00FF		; $809B3A: 29 FF 00
	bit.w #$0080		; $809B3D: 89 80 00
	beq CODE_809B45		; $809B40: F0 03
	ora.w #$FF00		; $809B42: 09 00 FF
CODE_809B45:		; M=16 X=16
	sta.b $57		; $809B45: 85 57
	lda.w $09DF,y		; $809B47: B9 DF 09
	bit.w #$0800		; $809B4A: 89 00 08
	beq CODE_809B57		; $809B4D: F0 08
	lda.b $53		; $809B4F: A5 53
	eor.w #$FFFF		; $809B51: 49 FF FF
	inc a		; $809B54: 1A
	sta.b $53		; $809B55: 85 53
CODE_809B57:		; M=16 X=16
	lda.w $09DF,y		; $809B57: B9 DF 09
	bit.w #$1000		; $809B5A: 89 00 10
	bne CODE_809B67		; $809B5D: D0 08
	lda.b $57		; $809B5F: A5 57
	eor.w #$FFFF		; $809B61: 49 FF FF
	inc a		; $809B64: 1A
	sta.b $57		; $809B65: 85 57
CODE_809B67:		; M=16 X=16
	lda.w $128E		; $809B67: AD 8E 12
	beq CODE_809B78		; $809B6A: F0 0C
	lda.b $53		; $809B6C: A5 53
	ldy.b $57		; $809B6E: A4 57
	eor.w #$FFFF		; $809B70: 49 FF FF
	inc a		; $809B73: 1A
	sta.b $57		; $809B74: 85 57
	sty.b $53		; $809B76: 84 53
CODE_809B78:		; M=16 X=16
	plx		; $809B78: FA
	rtl		; $809B79: 6B
	db $AD,$5C,$01,$89,$04,$00,$F0,$28,$89,$01,$00,$D0,$23,$AD,$BB,$0E	; $809B7A
	db $10,$1E,$A9,$08,$01,$85,$53,$AD,$5C,$01,$89,$02,$00,$D0,$12,$A9	; $809B8A
	db $F8,$FE,$38,$ED,$7B,$09,$F0,$08,$30,$04,$70,$04,$80,$14,$70,$12	; $809B9A
	db $6B,$A9,$08,$01,$38,$ED,$7B,$09,$F0,$08,$30,$04,$70,$04,$80,$F0	; $809BAA
	db $70,$EE,$A9,$01,$00,$0C,$5C,$01,$6B,$AD,$88,$12,$89,$20,$00,$F0	; $809BBA
	db $7B,$64,$37,$A9,$02,$00,$85,$3B,$22,$C2,$9C,$80,$64,$3B,$A9,$02	; $809BCA
	db $00,$85,$37,$22,$C2,$9C,$80,$A9,$54,$00,$85,$53,$38,$ED,$7B,$09	; $809BDA
	db $F0,$08,$30,$04,$70,$04,$80,$5E,$70,$5C,$A9,$54,$00,$38,$ED,$7B	; $809BEA
	db $0A,$F0,$49,$30,$04,$50,$04,$80,$43,$50,$41,$A9,$5E,$00,$85,$53	; $809BFA
	db $AD,$88,$12,$89,$02,$00,$F0,$08,$A5,$3B,$A4,$37,$85,$37,$84,$3B	; $809C0A
	db $A9,$05,$00,$85,$5B,$A4,$3B,$B9,$D2,$13,$85,$33,$A4,$33,$B9,$9F	; $809C1A
	db $0B,$30,$1A,$A5,$53,$38,$F9,$5F,$09,$30,$04,$70,$04,$80,$0E,$70	; $809C2A
	db $0C,$A4,$3B,$B9,$0A,$14,$09,$10,$00,$99,$0A,$14,$6B,$E6,$33,$E6	; $809C3A
	db $33,$C6,$5B,$10,$D7,$6B,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$38,$ED	; $809C4A
	db $7B,$09,$30,$04,$50,$04,$80,$E4,$50,$E2,$A5,$53,$38,$ED,$7B,$0A	; $809C5A
	db $30,$04,$70,$04,$80,$D6,$70,$D4,$A5,$53,$38,$E9,$0A,$00,$85,$53	; $809C6A
	db $AD,$88,$12,$89,$02,$00,$D0,$08,$A5,$3B,$A4,$37,$85,$37,$84,$3B	; $809C7A
	db $A9,$05,$00,$85,$5B,$A4,$3B,$B9,$D2,$13,$85,$33,$A4,$33,$B9,$9F	; $809C8A
	db $0B,$30,$1C,$A5,$53,$38,$F9,$5F,$09,$F0,$14,$30,$04,$50,$04,$80	; $809C9A
	db $0E,$50,$0C,$A4,$3B,$B9,$0A,$14,$09,$10,$00,$99,$0A,$14,$6B,$E6	; $809CAA
	db $33,$E6,$33,$C6,$5B,$10,$D5,$6B,$A4,$3B,$B9,$0A,$14,$89,$10,$00	; $809CBA
	db $D0,$03,$4C,$46,$9C,$B9,$D2,$13,$85,$33,$A9,$05,$00,$85,$57,$A4	; $809CCA
	db $33,$B9,$9F,$0B,$30,$12,$B9,$5F,$09,$85,$53,$B9,$3F,$11,$D0,$08	; $809CDA
	db $A5,$53,$49,$FF,$FF,$1A,$85,$53,$E6,$33,$E6,$33,$A5,$53,$38,$E9	; $809CEA
	db $58,$00,$F0,$09,$30,$05,$70,$05,$4C,$46,$9C,$70,$FB,$C6,$57,$10	; $809CFA
	db $CE,$A4,$3B,$B9,$0A,$14,$29,$EF,$FF,$99,$0A,$14,$6B,$AD,$BB,$09	; $809D0A
	db $38,$E9,$10,$00,$F0,$08,$30,$04,$70,$04,$80,$63,$70,$61,$AD,$5B	; $809D1A
	db $12,$85,$57,$A4,$57,$C0,$0F,$00,$F0,$26,$B9,$60,$12,$29,$FF,$00	; $809D2A
	db $85,$63,$A8,$B9,$1F,$12,$38,$ED,$7B,$09,$38,$E9,$16,$00,$F0,$08	; $809D3A
	db $30,$04,$70,$04,$80,$0A,$70,$08,$22,$8A,$9D,$80,$E6,$57,$80,$D3	; $809D4A
	db $AD,$5B,$12,$F0,$2A,$85,$57,$A4,$57,$B9,$5E,$12,$29,$FF,$00,$85	; $809D5A
	db $63,$A8,$AD,$7B,$09,$38,$F9,$1F,$12,$38,$E9,$16,$00,$F0,$08,$30	; $809D6A
	db $04,$70,$04,$80,$0A,$70,$08,$22,$8A,$9D,$80,$C6,$57,$D0,$D8,$6B	; $809D7A
	db $86,$0A,$A2,$00,$00,$B5,$53,$48,$E8,$E8,$E0,$1C,$00,$D0,$F6,$A6	; $809D8A
	db $0A,$A5,$63,$85,$3B,$A8,$4A,$CD,$BB,$0E,$D0,$03,$4C,$D2,$9E,$C9	; $809D9A
	db $0C,$00,$90,$03,$4C,$D2,$9E,$B9,$FF,$11,$19,$5F,$0E,$F0,$03,$4C	; $809DAA
	db $D2,$9E,$B9,$DF,$0E,$89,$00,$10,$F0,$03,$4C,$6B,$9E,$AD,$BB,$09	; $809DBA
	db $38,$E9,$05,$00,$F0,$09,$30,$05,$70,$05,$4C,$6B,$9E,$70,$FB,$AD	; $809DCA
	db $3B,$0B,$38,$E9,$00,$01,$F0,$09,$30,$05,$70,$05,$4C,$6B,$9E,$70	; $809DDA
	db $FB,$98,$22,$0A,$9B,$80,$A4,$3B,$A5,$53,$18,$79,$FF,$08,$38,$ED	; $809DEA
	db $1B,$09,$85,$53,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$0F,$00	; $809DFA
	db $B0,$5F,$A5,$57,$18,$79,$5F,$09,$38,$ED,$7B,$09,$85,$57,$89,$00	; $809E0A
	db $80,$F0,$04,$49,$FF,$FF,$1A,$C9,$0F,$00,$B0,$45,$A5,$53,$85,$7D	; $809E1A
	db $85,$83,$22,$DB,$FC,$82,$85,$53,$A5,$95,$85,$55,$A5,$57,$85,$7D	; $809E2A
	db $85,$83,$22,$DB,$FC,$82,$65,$53,$85,$53,$A5,$55,$65,$95,$85,$55	; $809E3A
	db $A9,$C4,$00,$85,$57,$AD,$7B,$0E,$30,$06,$F0,$04,$46,$57,$46,$57	; $809E4A
	db $A5,$57,$C5,$53,$A9,$00,$00,$E5,$55,$90,$06,$22,$15,$9F,$80,$80	; $809E5A
	db $67,$B9,$9F,$0B,$F0,$71,$B9,$FF,$08,$38,$ED,$1B,$09,$85,$53,$89	; $809E6A
	db $00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$09,$00,$B0,$4B,$B9,$5F,$09	; $809E7A
	db $38,$ED,$7B,$09,$85,$57,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9	; $809E8A
	db $09,$00,$B0,$34,$A5,$53,$85,$7D,$85,$83,$22,$DB,$FC,$82,$85,$53	; $809E9A
	db $A5,$95,$85,$55,$A5,$57,$85,$7D,$85,$83,$22,$DB,$FC,$82,$65,$53	; $809EAA
	db $85,$53,$A5,$55,$65,$95,$85,$55,$A5,$53,$C9,$41,$00,$A5,$55,$E9	; $809EBA
	db $00,$00,$B0,$04,$22,$1A,$A2,$80,$86,$0A,$A2,$1A,$00,$68,$95,$53	; $809ECA
	db $CA,$CA,$10,$F9,$A6,$0A,$6B,$B9,$FF,$08,$38,$ED,$1B,$09,$85,$53	; $809EDA
	db $89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$0D,$00,$B0,$DA,$B9,$5F	; $809EEA
	db $09,$38,$ED,$7B,$09,$85,$57,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A	; $809EFA
	db $C9,$0D,$00,$B0,$C3,$22,$FA,$A2,$80,$80,$BD,$A4,$3B,$B9,$9F,$0B	; $809F0A
	db $D0,$0B,$AD,$88,$12,$89,$10,$00,$F0,$03,$4C,$06,$A0,$B9,$DF,$0E	; $809F1A
	db $29,$FE,$FF,$99,$DF,$0E,$AD,$BB,$0E,$10,$03,$4C,$07,$A0,$0A,$85	; $809F2A
	db $33,$A8,$B9,$9F,$11,$F0,$03,$A9,$01,$00,$85,$73,$A4,$3B,$B9,$9F	; $809F3A
	db $11,$F0,$03,$A9,$01,$00,$45,$73,$D0,$03,$4C,$06,$A0,$A5,$53,$C9	; $809F4A
	db $25,$00,$A5,$55,$E9,$00,$00,$90,$03,$4C,$06,$A0,$B9,$9F,$0B,$F0	; $809F5A
	db $40,$A4,$33,$B9,$9F,$0B,$D0,$03,$4C,$06,$A0,$B9,$7F,$10,$85,$53	; $809F6A
	db $22,$B4,$A1,$80,$A5,$53,$48,$A5,$33,$A4,$3B,$85,$3B,$84,$33,$B9	; $809F7A
	db $7F,$10,$85,$53,$22,$B4,$A1,$80,$A5,$33,$A4,$3B,$85,$3B,$84,$33	; $809F8A
	db $68,$38,$E5,$53,$18,$69,$24,$00,$22,$8B,$AE,$80,$C9,$03,$00,$B0	; $809F9A
	db $5B,$A4,$33,$B9,$7F,$10,$85,$53,$22,$B4,$A1,$80,$A5,$53,$18,$69	; $809FAA
	db $14,$00,$A4,$33,$99,$5F,$0E,$A5,$33,$A4,$3B,$85,$3B,$84,$33,$B9	; $809FBA
	db $7F,$10,$85,$53,$22,$B4,$A1,$80,$A5,$53,$18,$69,$14,$00,$A4,$33	; $809FCA
	db $99,$5F,$0E,$A5,$33,$A4,$3B,$85,$3B,$84,$33,$98,$4A,$8D,$7D,$01	; $809FDA
	db $A9,$0C,$00,$1C,$8C,$12,$AD,$A2,$04,$29,$03,$00,$18,$69,$98,$00	; $809FEA
	db $48,$22,$8B,$C2,$80,$22,$C7,$99,$80,$4C,$21,$A1,$6B,$A4,$3B,$B9	; $809FFA
	db $9F,$0B,$D0,$0C,$A5,$53,$C9,$41,$00,$A5,$55,$E9,$00,$00,$B0,$EC	; $80A00A
	db $AD,$FB,$0A,$85,$7D,$85,$83,$22,$DB,$FC,$82,$85,$53,$A5,$95,$85	; $80A01A
	db $55,$AD,$1B,$0B,$85,$7D,$85,$83,$22,$DB,$FC,$82,$65,$53,$85,$53	; $80A02A
	db $A5,$55,$65,$95,$85,$55,$64,$57,$AD,$8C,$12,$89,$00,$10,$D0,$12	; $80A03A
	db $A4,$3B,$B9,$7F,$10,$85,$83,$A9,$BC,$02,$85,$7D,$22,$1C,$87,$8D	; $80A04A
	db $85,$57,$A5,$57,$18,$69,$C8,$32,$85,$7D,$85,$83,$22,$42,$89,$88	; $80A05A
	db $C5,$53,$A5,$95,$E5,$55,$B0,$0B,$A4,$3B,$A9,$08,$00,$99,$5F,$0E	; $80A06A
	db $4C,$F0,$9F,$AD,$A3,$04,$29,$03,$00,$18,$69,$98,$00,$48,$22,$8B	; $80A07A
	db $C2,$80,$A4,$3B,$98,$4A,$8D,$BB,$0E,$85,$53,$64,$33,$A9,$02,$00	; $80A08A
	db $85,$37,$B9,$9F,$11,$D0,$07,$64,$37,$A9,$02,$00,$85,$33,$A4,$33	; $80A09A
	db $A9,$FF,$FF,$99,$E6,$13,$99,$EA,$13,$B9,$0A,$14,$09,$04,$00,$99	; $80A0AA
	db $0A,$14,$A9,$10,$00,$1C,$90,$12,$F0,$11,$A4,$37,$B9,$DA,$13,$1A	; $80A0BA
	db $99,$DA,$13,$A5,$DE,$18,$69,$C8,$00,$85,$DE,$A5,$3B,$4A,$85,$53	; $80A0CA
	db $CD,$3F,$04,$D0,$09,$A4,$37,$B9,$06,$14,$1A,$99,$06,$14,$A9,$FF	; $80A0DA
	db $FF,$8D,$3F,$04,$A9,$0C,$00,$1C,$8C,$12,$A4,$3B,$B9,$9F,$0B,$F0	; $80A0EA
	db $04,$5C,$FB,$87,$8D,$22,$2E,$D1,$80,$A4,$3B,$A9,$8C,$00,$99,$DF	; $80A0FA
	db $0C,$B9,$FF,$0D,$C9,$90,$14,$F0,$04,$5C,$FB,$87,$8D,$A9,$05,$00	; $80A10A
	db $99,$DF,$0C,$5C,$FB,$87,$8D,$A9,$FF,$FF,$8D,$BB,$0E,$A9,$00,$10	; $80A11A
	db $22,$A1,$F6,$80,$8D,$1B,$0B,$A9,$00,$10,$22,$A1,$F6,$80,$8D,$FB	; $80A12A
	db $0A,$A9,$00,$10,$22,$8B,$AE,$80,$8D,$3B,$0B,$4C,$C9,$CE	; $80A13A
CODE_80A148:		; M=16 X=16
	lda.b $53		; $80A148: A5 53
	cmp.w $1292		; $80A14A: CD 92 12
	beq CODE_80A15D		; $80A14D: F0 0E
	lda.w $1292		; $80A14F: AD 92 12
	sta.b $57		; $80A152: 85 57
	jsl.l $80A174		; $80A154: 22 74 A1 80
	lda.b $53		; $80A158: A5 53
	sta.w $1292		; $80A15A: 8D 92 12
CODE_80A15D:		; M=16 X=16
	rtl		; $80A15D: 6B
CODE_80A15E:		; M=16 X=16
	lda.b $53		; $80A15E: A5 53
	cmp.w $1294		; $80A160: CD 94 12
	beq CODE_80A173		; $80A163: F0 0E
	lda.w $1294		; $80A165: AD 94 12
	sta.b $57		; $80A168: 85 57
	jsl.l $80A174		; $80A16A: 22 74 A1 80
	lda.b $53		; $80A16E: A5 53
	sta.w $1294		; $80A170: 8D 94 12
CODE_80A173:		; M=16 X=16
	rtl		; $80A173: 6B
CODE_80A174:		; M=16 X=16
	stz.b $33		; $80A174: 64 33
	lda.b $57		; $80A176: A5 57
	bmi CODE_80A19B		; $80A178: 30 21
	cmp.w #$000C		; $80A17A: C9 0C 00
	bcs CODE_80A19B		; $80A17D: B0 1C
	asl.b $57		; $80A17F: 06 57
	ldy.b $57		; $80A181: A4 57
	lda.w $0EDF,y		; $80A183: B9 DF 0E
	bit.w #$2000		; $80A186: 89 00 20
	beq CODE_80A192		; $80A189: F0 07
	lsr.b $57		; $80A18B: 46 57
	lda.b $57		; $80A18D: A5 57
	sta.b $53		; $80A18F: 85 53
	rtl		; $80A191: 6B
CODE_80A192:		; M=16 X=16
	and.w #$FFF7		; $80A192: 29 F7 FF
	ora.w #$0002		; $80A195: 09 02 00
	sta.w $0EDF,y		; $80A198: 99 DF 0E
CODE_80A19B:		; M=16 X=16
	lda.b $53		; $80A19B: A5 53
	bmi CODE_80A1B3		; $80A19D: 30 14
	cmp.w #$000C		; $80A19F: C9 0C 00
	bcs CODE_80A1B3		; $80A1A2: B0 0F
	sta.b $57		; $80A1A4: 85 57
	asl.b $57		; $80A1A6: 06 57
	ldy.b $57		; $80A1A8: A4 57
	lda.w $0EDF,y		; $80A1AA: B9 DF 0E
	ora.w #$0008		; $80A1AD: 09 08 00
	sta.w $0EDF,y		; $80A1B0: 99 DF 0E
CODE_80A1B3:		; M=16 X=16
	rtl		; $80A1B3: 6B
CODE_80A1B4:		; M=16 X=16
	pha		; $80A1B4: 48
	stx.b $0A		; $80A1B5: 86 0A
	ldx.w #$0000		; $80A1B7: A2 00 00
CODE_80A1BA:		; M=16 X=16
	lda.b $57,x		; $80A1BA: B5 57
	pha		; $80A1BC: 48
	inx		; $80A1BD: E8
	inx		; $80A1BE: E8
	cpx.w #$0004		; $80A1BF: E0 04 00
	bne CODE_80A1BA		; $80A1C2: D0 F6
	ldx.b $0A		; $80A1C4: A6 0A
	stx.b $0A		; $80A1C6: 86 0A
	ldx.w #$0000		; $80A1C8: A2 00 00
CODE_80A1CB:		; M=16 X=16
	lda.b $3B,x		; $80A1CB: B5 3B
	pha		; $80A1CD: 48
	inx		; $80A1CE: E8
	inx		; $80A1CF: E8
	cpx.w #$0008		; $80A1D0: E0 08 00
	bne CODE_80A1CB		; $80A1D3: D0 F6
	ldx.b $0A		; $80A1D5: A6 0A
	ldx.b $33		; $80A1D7: A6 33
	stx.b $3F		; $80A1D9: 86 3F
	jsl.l $8084C4		; $80A1DB: 22 C4 84 80
	stx.b $0A		; $80A1DF: 86 0A
	ldx.w #$0006		; $80A1E1: A2 06 00
CODE_80A1E4:		; M=16 X=16
	pla		; $80A1E4: 68
	sta.b $3B,x		; $80A1E5: 95 3B
	dex		; $80A1E7: CA
	dex		; $80A1E8: CA
	bpl CODE_80A1E4		; $80A1E9: 10 F9
	ldx.b $0A		; $80A1EB: A6 0A
	stx.b $0A		; $80A1ED: 86 0A
	ldx.w #$0002		; $80A1EF: A2 02 00
CODE_80A1F2:		; M=16 X=16
	pla		; $80A1F2: 68
	sta.b $57,x		; $80A1F3: 95 57
	dex		; $80A1F5: CA
	dex		; $80A1F6: CA
	bpl CODE_80A1F2		; $80A1F7: 10 F9
	ldx.b $0A		; $80A1F9: A6 0A
	ldx.b $3F		; $80A1FB: A6 3F
	pla		; $80A1FD: 68
	sta.b $7D		; $80A1FE: 85 7D
	lda.b $53		; $80A200: A5 53
	sta.b $83		; $80A202: 85 83
	jsl.l $82FCDB		; $80A204: 22 DB FC 82
	asl a		; $80A208: 0A
	rol.b $95		; $80A209: 26 95
	asl a		; $80A20B: 0A
	rol.b $95		; $80A20C: 26 95
	asl a		; $80A20E: 0A
	rol.b $95		; $80A20F: 26 95
	asl a		; $80A211: 0A
	rol.b $95		; $80A212: 26 95
	lda.b $95		; $80A214: A5 95
	sta.b $53		; $80A216: 85 53
	clc		; $80A218: 18
	rtl		; $80A219: 6B
	db $BD,$9F,$09,$38,$E9,$08,$00,$F0,$08,$30,$04,$70,$04,$80,$0C,$70	; $80A21A
	db $0A,$A5,$53,$29,$0F,$00,$F0,$03,$4C,$D4,$A2,$22,$C7,$99,$80,$AD	; $80A22A
	db $A1,$04,$29,$01,$00,$18,$69,$90,$00,$48,$22,$8B,$C2,$80,$9E,$1F	; $80A23A
	db $0B,$A4,$3B,$A9,$08,$00,$99,$5F,$0E,$BD,$FF,$08,$38,$F9,$FF,$08	; $80A24A
	db $85,$53,$BD,$5F,$09,$38,$F9,$5F,$09,$85,$57,$D0,$05,$98,$22,$0A	; $80A25A
	db $9B,$80,$BD,$DF,$0A,$85,$5B,$BD,$FF,$0A,$85,$5F,$E2,$20,$A5,$53	; $80A26A
	db $9D,$E0,$0A,$A5,$57,$9D,$00,$0B,$C2,$30,$22,$C9,$CE,$80,$BD,$9F	; $80A27A
	db $09,$38,$E9,$08,$00,$F0,$43,$30,$04,$50,$04,$80,$3D,$50,$3B,$A5	; $80A28A
	db $5B,$85,$7D,$85,$83,$22,$DB,$FC,$82,$85,$5B,$A5,$95,$85,$5D,$A5	; $80A29A
	db $5F,$85,$7D,$85,$83,$22,$DB,$FC,$82,$65,$5B,$85,$5B,$A5,$95,$65	; $80A2AA
	db $5D,$85,$5D,$C9,$00,$09,$90,$13,$BD,$9F,$09,$38,$E9,$0C,$00,$F0	; $80A2BA
	db $09,$30,$05,$70,$05,$4C,$33,$D9,$70,$FB,$6B,$A4,$3B,$B9,$7F,$11	; $80A2CA
	db $D0,$F8,$1A,$99,$7F,$11,$A9,$18,$14,$85,$57,$A6,$3B,$A4,$3F,$86	; $80A2DA
	db $3F,$84,$3B,$22,$06,$B0,$80,$A6,$3B,$A4,$3F,$86,$3F,$84,$3B,$6B	; $80A2EA
	db $AD,$88,$12,$89,$10,$00,$F0,$03,$4C,$B3,$A4,$64,$5B,$AD,$BB,$09	; $80A2FA
	db $38,$E9,$08,$00,$F0,$08,$30,$04,$70,$04,$80,$06,$70,$04,$E6,$5B	; $80A30A
	db $E6,$5B,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$A5,$57,$49,$FF,$FF,$1A	; $80A31A
	db $85,$57,$22,$A8,$AF,$80,$A4,$3B,$A5,$53,$38,$F9,$BF,$0D,$29,$07	; $80A32A
	db $00,$85,$53,$29,$03,$00,$85,$57,$D0,$05,$AD,$A1,$04,$85,$53,$A5	; $80A33A
	db $53,$29,$04,$00,$4A,$4A,$49,$01,$00,$18,$65,$5B,$0A,$85,$5B,$B9	; $80A34A
	db $BF,$10,$85,$57,$A5,$5B,$F0,$1D,$B9,$1F,$10,$85,$57,$A5,$5B,$C9	; $80A35A
	db $02,$00,$F0,$11,$B9,$5F,$10,$85,$57,$A5,$5B,$C9,$04,$00,$F0,$05	; $80A36A
	db $B9,$9F,$10,$85,$57,$A5,$57,$18,$69,$0F,$00,$85,$57,$B9,$DF,$09	; $80A37A
	db $89,$00,$08,$F0,$07,$A5,$5B,$49,$02,$00,$85,$5B,$AD,$1B,$0B,$89	; $80A38A
	db $00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$00,$30,$90,$2A,$AD,$81,$01	; $80A39A
	db $89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$50,$00,$90,$19,$C9,$AA	; $80A3AA
	db $00,$B0,$14,$49,$FF,$FF,$1A,$18,$69,$B6,$00,$22,$8B,$AE,$80,$C9	; $80A3BA
	db $03,$00,$D0,$03,$4C,$B3,$A4,$B9,$3F,$09,$38,$E9,$83,$02,$C9,$10	; $80A3CA
	db $00,$B0,$10,$AD,$BB,$09,$38,$E9,$02,$00,$30,$05,$70,$05,$4C,$B3	; $80A3DA
	db $A4,$70,$FB,$22,$2E,$D1,$80,$22,$C7,$99,$80,$AD,$A2,$04,$29,$01	; $80A3EA
	db $00,$18,$69,$90,$00,$48,$22,$8B,$C2,$80,$AD,$1B,$0B,$89,$00,$80	; $80A3FA
	db $F0,$04,$49,$FF,$FF,$1A,$C9,$00,$30,$90,$14,$A9,$8A,$00,$48,$A4	; $80A40A
	db $3B,$B9,$9F,$11,$F0,$05,$A9,$8C,$00,$83,$01,$22,$8B,$C2,$80,$AD	; $80A41A
	db $BB,$0E,$85,$5B,$10,$03,$4C,$B4,$A4,$A9,$00,$FF,$0C,$BB,$0E,$06	; $80A42A
	db $5B,$A5,$5B,$85,$33,$A8,$A9,$14,$00,$99,$5F,$0E,$98,$4A,$8D,$7D	; $80A43A
	db $01,$A9,$0C,$00,$1C,$8C,$12,$9E,$1F,$0B,$A4,$3B,$A9,$0A,$00,$99	; $80A44A
	db $5F,$0E,$A9,$04,$00,$99,$BF,$0C,$BD,$FF,$08,$38,$F9,$FF,$08,$85	; $80A45A
	db $53,$BD,$5F,$09,$38,$F9,$5F,$09,$85,$57,$D0,$06,$A5,$3B,$22,$0A	; $80A46A
	db $9B,$80,$A5,$57,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$85	; $80A47A
	db $57,$A5,$57,$F0,$02,$E6,$57,$A4,$3B,$B9,$FF,$0A,$45,$57,$30,$08	; $80A48A
	db $A5,$57,$49,$FF,$FF,$1A,$85,$57,$E2,$20,$A5,$53,$9D,$E0,$0A,$A5	; $80A49A
	db $57,$9D,$00,$0B,$C2,$20,$4C,$C9,$CE,$6B,$A4,$3B,$B9,$FF,$0D,$C9	; $80A4AA
	db $90,$14,$F0,$93,$A9,$02,$00,$18,$79,$DF,$0F,$EB,$29,$00,$FF,$0A	; $80A4BA
	db $22,$8B,$AE,$80,$69,$00,$0C,$85,$53,$38,$ED,$FB,$0A,$30,$05,$50	; $80A4CA
	db $05,$4C,$51,$A4,$50,$FB,$A5,$53,$38,$ED,$1B,$0B,$30,$05,$50,$05	; $80A4DA
	db $4C,$51,$A4,$50,$FB,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$38,$ED,$FB	; $80A4EA
	db $0A,$F0,$09,$30,$05,$70,$05,$4C,$51,$A4,$70,$FB,$A5,$53,$38,$ED	; $80A4FA
	db $1B,$0B,$F0,$09,$30,$05,$70,$05,$4C,$51,$A4,$70,$FB,$A4,$3B,$B9	; $80A50A
	db $DF,$0E,$89,$00,$10,$F0,$03,$4C,$51,$A4,$9E,$1F,$0B,$4C,$7D,$A0	; $80A51A
	db $AD,$3B,$0E,$C9,$08,$00,$90,$0E,$C9,$18,$00,$B0,$09,$AD,$DB,$0D	; $80A52A
	db $49,$02,$00,$8D,$DB,$0D,$A9,$04,$00,$0C,$DB,$0D,$9C,$3B,$0E,$A9	; $80A53A
	db $FF,$FF,$8D,$5B,$0E,$6B,$BD,$DF,$0E,$89,$02,$00,$D0,$03,$4C,$6F	; $80A54A
	db $A6,$29,$FD,$FF,$9D,$DF,$0E,$AD,$F2,$12,$D0,$04,$5C,$A9,$85,$8D	; $80A55A
	db $AD,$88,$12,$89,$40,$00,$F0,$04,$5C,$A9,$85,$8D,$AD,$F0,$12,$C9	; $80A56A
	db $03,$00,$D0,$0C,$AD,$D6,$13,$CD,$D8,$13,$F0,$04,$5C,$21,$8B,$8F	; $80A57A
	db $AD,$88,$12,$89,$08,$00,$F0,$03,$4C,$F7,$E7,$22,$47,$BE,$80,$A9	; $80A58A
	db $FF,$FF,$9D,$5F,$0C,$9D,$7F,$0C,$AD,$0C,$16,$F0,$03,$4C,$6F,$A6	; $80A59A
	db $A9,$08,$00,$1C,$0A,$14,$1C,$0C,$14,$A0,$16,$00,$B9,$DF,$0E,$29	; $80A5AA
	db $FF,$DF,$99,$DF,$0E,$88,$88,$10,$F3,$AD,$96,$12,$0D,$98,$12,$F0	; $80A5BA
	db $0F,$AD,$8E,$12,$F0,$0A,$A9,$40,$00,$0C,$8C,$12,$22,$28,$A8,$80	; $80A5CA
	db $AD,$92,$12,$85,$53,$30,$04,$22,$1C,$A6,$80,$AD,$94,$12,$85,$53	; $80A5DA
	db $30,$04,$22,$1C,$A6,$80,$64,$37,$A9,$02,$00,$85,$3B,$85,$53,$22	; $80A5EA
	db $FF,$A5,$80,$80,$70,$AD,$0C,$16,$D0,$6A,$A5,$53,$CD,$96,$12,$F0	; $80A5FA
	db $63,$CD,$98,$12,$F0,$5E,$22,$BD,$E6,$8F,$22,$5A,$BB,$80,$5C,$5D	; $80A60A
	db $E9,$89,$A4,$3F,$84,$3B,$A5,$53,$0A,$85,$53,$85,$3F,$AA,$BD,$DF	; $80A61A
	db $0E,$29,$FF,$DF,$9D,$DF,$0E,$5A,$A9,$FF,$FF,$8D,$83,$01,$22,$0F	; $80A62A
	db $A7,$80,$7A,$84,$3B,$A6,$3F,$BD,$DF,$0E,$89,$00,$20,$F0,$1D,$BD	; $80A63A
	db $9F,$11,$F0,$0D,$A9,$68,$01,$99,$7F,$0C,$8A,$4A,$99,$BF,$0C,$80	; $80A64A
	db $0B,$A9,$58,$02,$99,$5F,$0C,$8A,$4A,$99,$9F,$0C,$A6,$3B,$A4,$3F	; $80A65A
	db $86,$3F,$84,$3B,$6B,$64,$53,$22,$A2,$A6,$80,$A9,$20,$00,$85,$53	; $80A66A
	db $22,$A2,$A6,$80,$A6,$3F,$BD,$5F,$0C,$10,$E9,$BD,$7F,$0C,$10,$E4	; $80A67A
	db $64,$3B,$A9,$01,$00,$85,$53,$1A,$85,$37,$22,$FF,$A5,$80,$A9,$1C	; $80A68A
	db $00,$85,$53,$A6,$3F,$4C,$A7,$B4,$A5,$3F,$18,$65,$53,$A8,$B9,$5F	; $80A69A
	db $0C,$30,$C1,$B9,$9F,$0C,$0A,$85,$57,$A8,$64,$33,$64,$3B,$B9,$9F	; $80A6AA
	db $11,$F0,$05,$A9,$02,$00,$85,$3B,$B9,$DF,$0E,$89,$00,$20,$D0,$14	; $80A6BA
	db $A5,$3F,$18,$65,$53,$A8,$B9,$5F,$0C,$09,$00,$FF,$99,$5F,$0C,$A6	; $80A6CA
	db $3F,$4C,$48,$A7,$A5,$3F,$18,$65,$53,$A8,$B9,$5F,$0C,$38,$E5,$6F	; $80A6DA
	db $99,$5F,$0C,$30,$03,$4C,$6E,$A6,$A6,$3F,$DA,$A6,$57,$86,$3F,$BD	; $80A6EA
	db $DF,$0E,$89,$00,$20,$F0,$0A,$64,$5B,$22,$C7,$8D,$8F,$22,$48,$A7	; $80A6FA
	db $80,$FA,$86,$3F,$6B	; $80A70A
CODE_80A70F:		; M=16 X=16
	lda.w $160C		; $80A70F: AD 0C 16
	bne CODE_80A747		; $80A712: D0 33
	jsl.l $8FDBF9		; $80A714: 22 F9 DB 8F
	ldy.b $3B		; $80A718: A4 3B
	lda.w $140A,y		; $80A71A: B9 0A 14
	bit.w #$0008		; $80A71D: 89 08 00
	bne CODE_80A747		; $80A720: D0 25
	ora.w #$0008		; $80A722: 09 08 00
	sta.w $140A,y		; $80A725: 99 0A 14
	lda.w #$000C		; $80A728: A9 0C 00
	trb.w $128C		; $80A72B: 1C 8C 12
	lda.w $0EDF,x		; $80A72E: BD DF 0E
	ora.w #$2000		; $80A731: 09 00 20
	sta.w $0EDF,x		; $80A734: 9D DF 0E
	lda.w $0183		; $80A737: AD 83 01
	cmp.w #$FFFE		; $80A73A: C9 FE FF
	bne CODE_80A744		; $80A73D: D0 05
	txa		; $80A73F: 8A
	lsr a		; $80A740: 4A
	sta.w $0183		; $80A741: 8D 83 01
CODE_80A744:		; M=16 X=16
	jmp.w $A748		; $80A744: 4C 48 A7
CODE_80A747:		; M=16 X=16
	rtl		; $80A747: 6B
CODE_80A748:		; M=16 X=16
	jsl.l $80F391		; $80A748: 22 91 F3 80
	inc.b $53		; $80A74C: E6 53
	inc.b $57		; $80A74E: E6 57
	lda.w $1BE7		; $80A750: AD E7 1B
	sta.b $5B		; $80A753: 85 5B
	lda.b $F4		; $80A755: A5 F4
	bne CODE_80A75D		; $80A757: D0 04
	jsl.l $8D847C		; $80A759: 22 7C 84 8D
CODE_80A75D:		; M=16 X=16
	jsl.l $80F391		; $80A75D: 22 91 F3 80
	lda.w $047D		; $80A761: AD 7D 04
	sec		; $80A764: 38
	sbc.w #$000F		; $80A765: E9 0F 00
	bmi CODE_80A76E		; $80A768: 30 04
	bvc CODE_80A770		; $80A76A: 50 04
	bra CODE_80A778		; $80A76C: 80 0A
CODE_80A76E:		; M=16 X=16
	bvc CODE_80A778		; $80A76E: 50 08
CODE_80A770:		; M=16 X=16
	lda.w #$0001		; $80A770: A9 01 00
	tsb.w $1290		; $80A773: 0C 90 12
	bra CODE_80A780		; $80A776: 80 08
CODE_80A778:		; M=16 X=16
	jsl.l $8FDBDB		; $80A778: 22 DB DB 8F
	jsl.l $80F391		; $80A77C: 22 91 F3 80
CODE_80A780:		; M=16 X=16
	jsl.l $8FD69F		; $80A780: 22 9F D6 8F
	dec.w $047D		; $80A784: CE 7D 04
	dec.w $047D		; $80A787: CE 7D 04
	inc.w $047B		; $80A78A: EE 7B 04
	lda.w #$0002		; $80A78D: A9 02 00
	sta.b $63		; $80A790: 85 63
	lda.w $047B		; $80A792: AD 7B 04
	pha		; $80A795: 48
CODE_80A796:		; M=16 X=16
	lda.b $01,s		; $80A796: A3 01
	sta.w $047B		; $80A798: 8D 7B 04
	lda.b $63		; $80A79B: A5 63
	sta.b $53		; $80A79D: 85 53
	jsl.l $8AFD6D		; $80A79F: 22 6D FD 8A
	lda.b $53		; $80A7A3: A5 53
	bmi CODE_80A7FE		; $80A7A5: 30 57
	ldy.b $3B		; $80A7A7: A4 3B
	lda.w $140A,y		; $80A7A9: B9 0A 14
	bit.w #$0008		; $80A7AC: 89 08 00
	bne CODE_80A7BD		; $80A7AF: D0 0C
	lda.b $63		; $80A7B1: A5 63
	cmp.w $140E,y		; $80A7B3: D9 0E 14
	bne CODE_80A7FB		; $80A7B6: D0 43
	lda.w $13DE,y		; $80A7B8: B9 DE 13
	sta.b $53		; $80A7BB: 85 53
CODE_80A7BD:		; M=16 X=16
	lda.w #$0191		; $80A7BD: A9 91 01
	sta.b $37		; $80A7C0: 85 37
	lda.w #$0000		; $80A7C2: A9 00 00
	sta.b $39		; $80A7C5: 85 39
	lda.w #$0004		; $80A7C7: A9 04 00
	sta.b [$37]		; $80A7CA: 87 37
	phx		; $80A7CC: DA
	ldx.b $63		; $80A7CD: A6 63
	lda.l $80A825,x		; $80A7CF: BF 25 A8 80
	plx		; $80A7D3: FA
	and.w #$00FF		; $80A7D4: 29 FF 00
	ora.w #$2000		; $80A7D7: 09 00 20
	ldy.w #$0002		; $80A7DA: A0 02 00
	sta.b [$37],y		; $80A7DD: 97 37
	jsl.l $80B92D		; $80A7DF: 22 2D B9 80
	lda.b $53		; $80A7E3: A5 53
	pha		; $80A7E5: 48
	lda.w #$8213		; $80A7E6: A9 13 82
	sta.b $37		; $80A7E9: 85 37
	lda.w #$008F		; $80A7EB: A9 8F 00
	sta.b $39		; $80A7EE: 85 39
	jsl.l $8FD68C		; $80A7F0: 22 8C D6 8F
	pla		; $80A7F4: 68
	sta.b $53		; $80A7F5: 85 53
	jsl.l $8F8D68		; $80A7F7: 22 68 8D 8F
CODE_80A7FB:		; M=16 X=16
	dec.w $047D		; $80A7FB: CE 7D 04
CODE_80A7FE:		; M=16 X=16
	dec.b $63		; $80A7FE: C6 63
	bpl CODE_80A796		; $80A800: 10 94
	pla		; $80A802: 68
	clc		; $80A803: 18
	adc.w #$0005		; $80A804: 69 05 00
	sta.w $047B		; $80A807: 8D 7B 04
	ldy.b $3B		; $80A80A: A4 3B
	lda.w #$0083		; $80A80C: A9 83 00
	sta.b $39		; $80A80F: 85 39
	lda.w $13CE,y		; $80A811: B9 CE 13
	sta.b $37		; $80A814: 85 37
	ldy.w #$0004		; $80A816: A0 04 00
	clc		; $80A819: 18
	adc.b [$37],y		; $80A81A: 77 37
	sta.b $37		; $80A81C: 85 37
	adc.b [$37]		; $80A81E: 67 37
	sta.b $37		; $80A820: 85 37
	jmp.w $B92D		; $80A822: 4C 2D B9
	db $59,$42,$41,$86,$0A,$A2,$00,$00,$B5,$33,$48,$E8,$E8,$E0,$3C,$00	; $80A825
	db $D0,$F6,$A6,$0A,$9C,$8E,$12,$A9,$E7,$03,$8D,$9B,$04,$22,$6C,$B7	; $80A835
	db $80,$AD,$8C,$12,$89,$01,$00,$D0,$1D,$AD,$E7,$1B,$18,$6D,$CD,$1B	; $80A845
	db $A2,$FE,$07,$9F,$74,$6E,$7E,$CA,$CA,$10,$F8,$64,$D0,$A9,$FF,$03	; $80A855
	db $85,$D2,$22,$5D,$E9,$89,$86,$0A,$A2,$3A,$00,$68,$95,$33,$CA,$CA	; $80A865
	db $10,$F9,$A6,$0A,$A6,$3F,$6B,$BD,$DF,$0E,$89,$02,$00,$D0,$03,$4C	; $80A875
	db $6D,$AC,$29,$FD,$FF,$9D,$DF,$0E,$86,$0A,$A2,$00,$00,$B5,$53,$48	; $80A885
	db $E8,$E8,$E0,$20,$00,$D0,$F6,$A6,$0A,$86,$0A,$A2,$00,$00,$B5,$33	; $80A895
	db $48,$E8,$E8,$E0,$1C,$00,$D0,$F6,$A6,$0A,$A5,$DE,$C9,$58,$02,$90	; $80A8A5
	db $05,$A9,$58,$02,$85,$DE,$A9,$01,$00,$1C,$8C,$12,$A9,$01,$00,$1C	; $80A8B5
	db $90,$12,$9C,$4E,$01,$9C,$5C,$01,$A9,$FF,$FF,$8D,$EA,$12,$8D,$8B	; $80A8C5
	db $04,$8D,$8F,$04,$8D,$BB,$09,$8D,$BB,$0E,$8D,$3F,$04,$A9,$00,$02	; $80A8D5
	db $1C,$8C,$12,$A9,$00,$05,$0C,$8C,$12,$22,$28,$A8,$80,$9C,$DF,$08	; $80A8E5
	db $9C,$54,$01,$AD,$46,$01,$8D,$1B,$09,$AD,$48,$01,$8D,$7B,$09,$9C	; $80A8F5
	db $FB,$0A,$9C,$1B,$0B,$9C,$3B,$0B,$9C,$F7,$0A,$9C,$17,$0B,$9C,$17	; $80A905
	db $09,$A9,$0C,$01,$8D,$77,$09,$9C,$F9,$0A,$9C,$19,$0B,$9C,$19,$09	; $80A915
	db $A9,$F4,$FE,$8D,$79,$09,$A9,$89,$01,$8D,$5D,$09,$9C,$1D,$0E,$9C	; $80A925
	db $FD,$09,$9C,$FB,$09,$A9,$40,$00,$1C,$8C,$12,$A9,$64,$00,$85,$63	; $80A935
	db $22,$E8,$E1,$80,$C6,$63,$10,$F8,$A9,$3C,$00,$8D,$F9,$08,$22,$1A	; $80A945
	db $B0,$80,$64,$3B,$22,$5A,$BB,$80,$22,$86,$B0,$80,$E6,$3B,$E6,$3B	; $80A955
	db $22,$5A,$BB,$80,$22,$86,$B0,$80,$22,$F8,$B3,$80,$A5,$41,$48,$A5	; $80A965
	db $3F,$48,$64,$3F,$A9,$0B,$00,$85,$5B,$A6,$3F,$A9,$10,$FF,$9D,$FF	; $80A975
	db $08,$9E,$5F,$09,$9E,$3F,$09,$BD,$9F,$0B,$85,$57,$10,$03,$4C,$D6	; $80A985
	db $AA,$F0,$3D,$A9,$16,$00,$85,$53,$A5,$57,$C9,$04,$00,$D0,$2D,$64	; $80A995
	db $3B,$BD,$9F,$11,$F0,$04,$E6,$3B,$E6,$3B,$A4,$3B,$BD,$1F,$0F,$29	; $80A9A5
	db $FF,$00,$99,$E2,$13,$A9,$FF,$FF,$99,$E6,$13,$99,$EA,$13,$B9,$0A	; $80A9B5
	db $14,$29,$FB,$FF,$99,$0A,$14,$A9,$17,$00,$85,$53,$22,$9D,$B4,$80	; $80A9C5
	db $AD,$EE,$13,$85,$63,$A6,$3F,$BD,$9F,$11,$F0,$05,$AD,$F0,$13,$85	; $80A9D5
	db $63,$A5,$63,$49,$FF,$FF,$1A,$18,$69,$06,$00,$0A,$0A,$0A,$85,$63	; $80A9E5
	db $A9,$80,$00,$85,$39,$A9,$90,$AC,$18,$65,$63,$85,$37,$A4,$57,$B7	; $80A9F5
	db $37,$29,$FF,$00,$0A,$0A,$85,$63,$A9,$A8,$AC,$85,$37,$A9,$80,$00	; $80AA05
	db $85,$39,$A4,$63,$B7,$37,$85,$53,$C8,$C8,$B7,$37,$85,$57,$BD,$3F	; $80AA15
	db $11,$D0,$10,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$A5,$57,$49,$FF,$FF	; $80AA25
	db $1A,$85,$57,$BD,$9F,$0B,$F0,$54,$A5,$63,$38,$E9,$08,$00,$F0,$08	; $80AA35
	db $30,$04,$70,$04,$80,$36,$70,$34,$AD,$46,$01,$45,$53,$10,$17,$AD	; $80AA45
	db $48,$01,$4A,$4A,$4A,$89,$00,$10,$F0,$03,$09,$00,$E0,$49,$FF,$FF	; $80AA55
	db $1A,$18,$65,$57,$85,$57,$AD,$46,$01,$4A,$4A,$89,$00,$20,$F0,$03	; $80AA65
	db $09,$00,$C0,$85,$5F,$A5,$53,$38,$E5,$5F,$85,$53,$A5,$53,$18,$6D	; $80AA75
	db $46,$01,$85,$53,$A5,$57,$18,$6D,$48,$01,$85,$57,$A5,$53,$9D,$FF	; $80AA85
	db $08,$38,$ED,$1B,$09,$49,$FF,$FF,$1A,$85,$53,$A5,$57,$9D,$5F,$09	; $80AA95
	db $38,$ED,$7B,$09,$49,$FF,$FF,$1A,$85,$57,$9E,$DF,$0A,$9E,$FF,$0A	; $80AAA5
	db $22,$A8,$AF,$80,$A5,$53,$9D,$BF,$0D,$BD,$DF,$0E,$29,$FF,$EF,$9D	; $80AAB5
	db $DF,$0E,$9E,$7F,$11,$9E,$FF,$0D,$A9,$78,$04,$85,$57,$22,$06,$B0	; $80AAC5
	db $80,$E6,$3F,$E6,$3F,$C6,$5B,$30,$03,$4C,$7E,$A9,$22,$6C,$B7,$80	; $80AAD5
	db $68,$85,$3F,$68,$85,$41,$A6,$3F,$22,$D8,$FD,$8F,$22,$0C,$B9,$80	; $80AAE5
	db $05,$00,$BF,$00,$00,$A9,$36,$00,$85,$53,$AD,$46,$01,$10,$05,$A9	; $80AAF5
	db $BE,$00,$85,$53,$A5,$53,$8D,$36,$01,$38,$E9,$2E,$00,$4A,$4A,$4A	; $80AB05
	db $8D,$7B,$04,$A9,$5C,$00,$8D,$38,$01,$A9,$03,$00,$8D,$7D,$04,$AD	; $80AB15
	db $7D,$04,$0A,$0A,$0A,$0A,$0A,$6D,$7B,$04,$22,$CD,$FC,$82,$AD,$7D	; $80AB25
	db $04,$18,$69,$09,$00,$0A,$0A,$0A,$0A,$0A,$6D,$7B,$04,$69,$0B,$00	; $80AB35
	db $22,$64,$FD,$82,$A9,$49,$E9,$85,$F4,$85,$73,$A9,$84,$00,$85,$75	; $80AB45
	db $AD,$7D,$04,$0A,$0A,$0A,$0A,$0A,$6D,$7B,$04,$0A,$AA,$A0,$00,$00	; $80AB55
	db $A9,$0A,$00,$85,$76,$18,$A9,$0C,$00,$85,$78,$B7,$73,$18,$6D,$D9	; $80AB65
	db $1B,$6D,$CD,$1B,$9F,$74,$6E,$7E,$C8,$C8,$E8,$E8,$C6,$78,$D0,$EB	; $80AB75
	db $8A,$18,$69,$28,$00,$AA,$C6,$76,$D0,$DC,$A6,$3F,$AD,$0C,$16,$D0	; $80AB85
	db $69,$AD,$7D,$04,$18,$69,$0A,$00,$8D,$7D,$04,$A9,$0C,$00,$85,$53	; $80AB95
	db $A9,$03,$00,$85,$57,$22,$9F,$D6,$8F,$AD,$DE,$13,$85,$53,$AD,$E0	; $80ABA5
	db $13,$85,$57,$AD,$88,$12,$89,$02,$00,$D0,$0A,$AD,$DE,$13,$85,$57	; $80ABB5
	db $AD,$E0,$13,$85,$53,$EE,$7B,$04,$CE,$7D,$04,$CE,$7D,$04,$A9,$13	; $80ABC5
	db $82,$85,$37,$A9,$8F,$00,$85,$39,$22,$8C,$D6,$8F,$EE,$7B,$04,$EE	; $80ABD5
	db $7B,$04,$EE,$7B,$04,$EE,$7B,$04,$A5,$57,$85,$53,$A9,$13,$82,$85	; $80ABE5
	db $37,$A9,$8F,$00,$85,$39,$22,$8C,$D6,$8F,$A9,$78,$00,$22,$8B,$AE	; $80ABF5
	db $80,$69,$B4,$00,$85,$53,$A6,$3F,$9D,$5F,$0C,$A9,$01,$00,$8D,$3A	; $80AC05
	db $01,$A9,$00,$80,$8D,$3C,$01,$8D,$44,$01,$A9,$04,$00,$8D,$3E,$01	; $80AC15
	db $A9,$00,$A8,$8D,$40,$01,$A9,$07,$00,$8D,$42,$01,$AD,$88,$12,$89	; $80AC25
	db $02,$00,$D0,$0C,$A9,$00,$88,$8D,$3C,$01,$A9,$00,$A0,$8D,$40,$01	; $80AC35
	db $A9,$FF,$FF,$8D,$32,$01,$8D,$34,$01,$86,$0A,$A2,$1A,$00,$68,$95	; $80AC45
	db $33,$CA,$CA,$10,$F9,$A6,$0A,$86,$0A,$A2,$1E,$00,$68,$95,$53,$CA	; $80AC55
	db $CA,$10,$F9,$A6,$0A,$A6,$3F,$6B,$A5,$6F,$85,$73,$38,$FD,$5F,$0C	; $80AC65
	db $30,$04,$50,$04,$80,$07,$50,$05,$A9,$01,$00,$85,$73,$BD,$5F,$0C	; $80AC75
	db $38,$E5,$73,$9D,$5F,$0C,$10,$37,$4C,$34,$AD,$00,$01,$02,$03,$04	; $80AC85
	db $05,$06,$00,$00,$01,$05,$03,$04,$02,$00,$00,$00,$03,$05,$01,$04	; $80AC95
	db $00,$00,$00,$00,$00,$06,$FF,$DD,$FF,$CE,$FF,$23,$00,$CE,$FF,$CE	; $80ACA5
	db $FF,$F6,$FF,$00,$00,$F1,$FF,$32,$00,$F6,$FF,$00,$00,$C4,$FF,$BD	; $80ACB5
	db $5F,$0C,$F0,$27,$18,$69,$06,$00,$4A,$4A,$4A,$85,$53,$38,$E9,$02	; $80ACC5
	db $00,$F0,$08,$30,$04,$70,$04,$80,$11,$70,$0F,$A5,$53,$49,$FF,$FF	; $80ACD5
	db $1A,$18,$69,$0A,$00,$85,$53,$8D,$42,$01,$6B,$22,$0C,$B9,$80,$05	; $80ACE5
	db $00,$BF,$00,$00,$AD,$36,$01,$38,$E9,$2E,$00,$4A,$4A,$4A,$89,$00	; $80ACF5
	db $10,$F0,$03,$09,$00,$E0,$8D,$7B,$04,$AD,$38,$01,$38,$E9,$44,$00	; $80AD05
	db $4A,$4A,$4A,$89,$00,$10,$F0,$03,$09,$00,$E0,$8D,$7D,$04,$A9,$0C	; $80AD15
	db $00,$85,$53,$1A,$85,$57,$AD,$E7,$1B,$85,$5B,$5C,$7C,$84,$8D,$AD	; $80AD25
	db $A3,$04,$29,$03,$00,$18,$69,$98,$00,$48,$22,$8B,$C2,$80,$A9,$00	; $80AD35
	db $01,$1C,$8C,$12,$64,$F4,$A9,$00,$04,$1C,$8C,$12,$9C,$8A,$12,$9E	; $80AD45
	db $5F,$11,$A9,$10,$00,$0C,$90,$12,$AD,$32,$01,$85,$5F,$A9,$00,$08	; $80AD55
	db $85,$63,$64,$37,$A9,$10,$00,$85,$5B,$AE,$3A,$01,$BF,$2F,$AE,$80	; $80AD65
	db $29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$49,$FF,$FF,$1A,$18	; $80AD75
	db $65,$5B,$85,$5B,$AE,$3E,$01,$BF,$2F,$AE,$80,$29,$FF,$00,$89,$80	; $80AD85
	db $00,$F0,$03,$09,$00,$FF,$18,$65,$5B,$85,$5B,$A9,$21,$00,$22,$8B	; $80AD95
	db $AE,$80,$C5,$5B,$B0,$05,$A9,$04,$00,$85,$37,$A6,$37,$BD,$3C,$01	; $80ADA5
	db $89,$00,$08,$F0,$0A,$AD,$34,$01,$85,$5F,$A9,$00,$F8,$85,$63,$A5	; $80ADB5
	db $5F,$89,$08,$00,$D0,$0D,$29,$07,$00,$85,$53,$AD,$A1,$04,$29,$03	; $80ADC5
	db $00,$D0,$19,$A9,$05,$00,$22,$8B,$AE,$80,$3A,$3A,$29,$07,$00,$85	; $80ADD5
	db $53,$A5,$63,$30,$07,$A5,$53,$49,$04,$00,$85,$53,$06,$53,$06,$53	; $80ADE5
	db $A6,$53,$BF,$36,$AE,$80,$0A,$0A,$0A,$0A,$0A,$A6,$3F,$9D,$DF,$0A	; $80ADF5
	db $A6,$53,$BF,$38,$AE,$80,$0A,$0A,$0A,$0A,$0A,$18,$65,$63,$A6,$3F	; $80AE05
	db $9D,$FF,$0A,$A9,$00,$08,$22,$8B,$AE,$80,$9D,$1F,$0B,$9C,$BB,$09	; $80AE15
	db $9E,$FF,$11,$A9,$18,$00,$85,$53,$4C,$A7,$B4,$00,$08,$10,$00,$08	; $80AE25
	db $10,$00,$00,$C8,$00,$8D,$00,$8D,$00,$C8,$00,$00,$00,$8D,$00,$73	; $80AE35
	db $FF,$00,$00,$38,$FF,$73,$FF,$73,$FF,$38,$FF,$00,$00,$73,$FF,$8D	; $80AE45
	db $00	; $80AE55
CODE_80AE56:		; M=16 X=16
	lda.w $04A1		; $80AE56: AD A1 04
	sta.b $7D		; $80AE59: 85 7D
	lda.w $04A3		; $80AE5B: AD A3 04
	sta.b $7F		; $80AE5E: 85 7F
	lda.w #$E62D		; $80AE60: A9 2D E6
	sta.b $83		; $80AE63: 85 83
	lda.w #$BB40		; $80AE65: A9 40 BB
	sta.b $85		; $80AE68: 85 85
	jsl.l $88832F		; $80AE6A: 22 2F 83 88
	adc.w #$0001		; $80AE6E: 69 01 00
	sta.w $04A1		; $80AE71: 8D A1 04
	lda.b $95		; $80AE74: A5 95
	adc.w #$0000		; $80AE76: 69 00 00
	sta.w $04A3		; $80AE79: 8D A3 04
	xba		; $80AE7C: EB
	and.w #$00FF		; $80AE7D: 29 FF 00
	sta.w $0493		; $80AE80: 8D 93 04
	lda.w $04A2		; $80AE83: AD A2 04
	sta.w $0491		; $80AE86: 8D 91 04
	clc		; $80AE89: 18
	rtl		; $80AE8A: 6B
CODE_80AE8B:		; M=16 X=16
	pha		; $80AE8B: 48
	jsl.l $80AE56		; $80AE8C: 22 56 AE 80
	sta.b $7D		; $80AE90: 85 7D
	pla		; $80AE92: 68
	sta.b $83		; $80AE93: 85 83
	jsl.l $888942		; $80AE95: 22 42 89 88
	lda.b $95		; $80AE99: A5 95
	clc		; $80AE9B: 18
	rtl		; $80AE9C: 6B
CODE_80AE9D:		; M=16 X=16
	stx.b $0A		; $80AE9D: 86 0A
	ldx.w #$0000		; $80AE9F: A2 00 00
CODE_80AEA2:		; M=16 X=16
	lda.b $53,x		; $80AEA2: B5 53
	pha		; $80AEA4: 48
	inx		; $80AEA5: E8
	inx		; $80AEA6: E8
	cpx.w #$001C		; $80AEA7: E0 1C 00
	bne CODE_80AEA2		; $80AEAA: D0 F6
	ldx.b $0A		; $80AEAC: A6 0A
	stx.b $0A		; $80AEAE: 86 0A
	ldx.w #$0000		; $80AEB0: A2 00 00
CODE_80AEB3:		; M=16 X=16
	lda.b $33,x		; $80AEB3: B5 33
	pha		; $80AEB5: 48
	inx		; $80AEB6: E8
	inx		; $80AEB7: E8
	cpx.w #$0008		; $80AEB8: E0 08 00
	bne CODE_80AEB3		; $80AEBB: D0 F6
	ldx.b $0A		; $80AEBD: A6 0A
	lda.w $0B1B		; $80AEBF: AD 1B 0B
	xba		; $80AEC2: EB
	and.w #$00FF		; $80AEC3: 29 FF 00
	bit.w #$0080		; $80AEC6: 89 80 00
	beq CODE_80AECE		; $80AEC9: F0 03
	ora.w #$FF00		; $80AECB: 09 00 FF
CODE_80AECE:		; M=16 X=16
	clc		; $80AECE: 18
	adc.w $097B		; $80AECF: 6D 7B 09
	pha		; $80AED2: 48
	lda.w $0AFB		; $80AED3: AD FB 0A
	xba		; $80AED6: EB
	and.w #$00FF		; $80AED7: 29 FF 00
	bit.w #$0080		; $80AEDA: 89 80 00
	beq CODE_80AEE2		; $80AEDD: F0 03
	ora.w #$FF00		; $80AEDF: 09 00 FF
CODE_80AEE2:		; M=16 X=16
	clc		; $80AEE2: 18
	adc.w $091B		; $80AEE3: 6D 1B 09
	pha		; $80AEE6: 48
	lda.w #$0005		; $80AEE7: A9 05 00
	sta.b $5B		; $80AEEA: 85 5B
	lda.b $63		; $80AEEC: A5 63
	tay		; $80AEEE: A8
	eor.w #$0002		; $80AEEF: 49 02 00
	sta.b $5F		; $80AEF2: 85 5F
	lda.w #$FFFF		; $80AEF4: A9 FF FF
	sta.b $69		; $80AEF7: 85 69
	ldx.w #$0000		; $80AEF9: A2 00 00
	lda.w $1296,y		; $80AEFC: B9 96 12
	cmp.w #$0001		; $80AEFF: C9 01 00
	beq CODE_80AF07		; $80AF02: F0 03
	ldx.w #$000C		; $80AF04: A2 0C 00
CODE_80AF07:		; M=16 X=16
	ldy.b $5F		; $80AF07: A4 5F
CODE_80AF09:		; M=16 X=16
	lda.w $0B9F,x		; $80AF09: BD 9F 0B
	bmi CODE_80AF62		; $80AF0C: 30 54
	beq CODE_80AF62		; $80AF0E: F0 52
	lda.w $0EDF,x		; $80AF10: BD DF 0E
	and.w #$1000		; $80AF13: 29 00 10
	ora.w $117F,x		; $80AF16: 1D 7F 11
	bne CODE_80AF62		; $80AF19: D0 47
	lda.b $01,s		; $80AF1B: A3 01
	sec		; $80AF1D: 38
	sbc.w $08FF,x		; $80AF1E: FD FF 08
	sta.b $7D		; $80AF21: 85 7D
	sta.b $83		; $80AF23: 85 83
	jsl.l $82FCDB		; $80AF25: 22 DB FC 82
	sta.b $53		; $80AF29: 85 53
	lda.b $95		; $80AF2B: A5 95
	sta.b $55		; $80AF2D: 85 55
	lda.b $03,s		; $80AF2F: A3 03
	sec		; $80AF31: 38
	sbc.w $095F,x		; $80AF32: FD 5F 09
	sta.b $7D		; $80AF35: 85 7D
	sta.b $83		; $80AF37: 85 83
	jsl.l $82FCDB		; $80AF39: 22 DB FC 82
	adc.b $53		; $80AF3D: 65 53
	sta.b $53		; $80AF3F: 85 53
	lda.b $95		; $80AF41: A5 95
	adc.b $55		; $80AF43: 65 55
	sta.b $55		; $80AF45: 85 55
	lda.b $67		; $80AF47: A5 67
	cmp.b $53		; $80AF49: C5 53
	lda.b $69		; $80AF4B: A5 69
	sbc.b $55		; $80AF4D: E5 55
	bcc CODE_80AF62		; $80AF4F: 90 11
	txa		; $80AF51: 8A
	lsr a		; $80AF52: 4A
	cmp.w $1292,y		; $80AF53: D9 92 12
	beq CODE_80AF62		; $80AF56: F0 0A
	sta.b $6B		; $80AF58: 85 6B
	lda.b $53		; $80AF5A: A5 53
	sta.b $67		; $80AF5C: 85 67
	lda.b $55		; $80AF5E: A5 55
	sta.b $69		; $80AF60: 85 69
CODE_80AF62:		; M=16 X=16
	inx		; $80AF62: E8
	inx		; $80AF63: E8
	dec.b $5B		; $80AF64: C6 5B
	bpl CODE_80AF09		; $80AF66: 10 A1
	ldx.b $3F		; $80AF68: A6 3F
	pla		; $80AF6A: 68
	pla		; $80AF6B: 68
	ldy.b $63		; $80AF6C: A4 63
	lda.b $6B		; $80AF6E: A5 6B
	cmp.w $1292,y		; $80AF70: D9 92 12
	bne CODE_80AF7B		; $80AF73: D0 06
	jsl.l $808D8A		; $80AF75: 22 8A 8D 80
	bra CODE_80AF8B		; $80AF79: 80 10
CODE_80AF7B:		; M=16 X=16
	sta.b $53		; $80AF7B: 85 53
	lda.b $63		; $80AF7D: A5 63
	bne CODE_80AF87		; $80AF7F: D0 06
	jsl.l $80A148		; $80AF81: 22 48 A1 80
	bra CODE_80AF8B		; $80AF85: 80 04
CODE_80AF87:		; M=16 X=16
	jsl.l $80A15E		; $80AF87: 22 5E A1 80
CODE_80AF8B:		; M=16 X=16
	stx.b $0A		; $80AF8B: 86 0A
	ldx.w #$0006		; $80AF8D: A2 06 00
CODE_80AF90:		; M=16 X=16
	pla		; $80AF90: 68
	sta.b $33,x		; $80AF91: 95 33
	dex		; $80AF93: CA
	dex		; $80AF94: CA
	bpl CODE_80AF90		; $80AF95: 10 F9
	ldx.b $0A		; $80AF97: A6 0A
	stx.b $0A		; $80AF99: 86 0A
	ldx.w #$001A		; $80AF9B: A2 1A 00
CODE_80AF9E:		; M=16 X=16
	pla		; $80AF9E: 68
	sta.b $53,x		; $80AF9F: 95 53
	dex		; $80AFA1: CA
	dex		; $80AFA2: CA
	bpl CODE_80AF9E		; $80AFA3: 10 F9
	ldx.b $0A		; $80AFA5: A6 0A
	rtl		; $80AFA7: 6B
CODE_80AFA8:		; M=16 X=16
	lda.b $53		; $80AFA8: A5 53
	ora.b $57		; $80AFAA: 05 57
	beq CODE_80AFF0		; $80AFAC: F0 42
	stz.b $55		; $80AFAE: 64 55
	lda.b $53		; $80AFB0: A5 53
	bpl CODE_80AFBC		; $80AFB2: 10 08
	eor.w #$FFFF		; $80AFB4: 49 FF FF
	inc a		; $80AFB7: 1A
	sta.b $53		; $80AFB8: 85 53
	inc.b $55		; $80AFBA: E6 55
CODE_80AFBC:		; M=16 X=16
	lda.b $57		; $80AFBC: A5 57
	bpl CODE_80AFCA		; $80AFBE: 10 0A
	eor.w #$FFFF		; $80AFC0: 49 FF FF
	inc a		; $80AFC3: 1A
	sta.b $57		; $80AFC4: 85 57
	inc.b $55		; $80AFC6: E6 55
	inc.b $55		; $80AFC8: E6 55
CODE_80AFCA:		; M=16 X=16
	lda.b $57		; $80AFCA: A5 57
	asl a		; $80AFCC: 0A
	cmp.b $53		; $80AFCD: C5 53
	bcc CODE_80AFD6		; $80AFCF: 90 05
	lda.w #$0004		; $80AFD1: A9 04 00
	tsb.b $55		; $80AFD4: 04 55
CODE_80AFD6:		; M=16 X=16
	lda.b $53		; $80AFD6: A5 53
	asl a		; $80AFD8: 0A
	cmp.b $57		; $80AFD9: C5 57
	bcc CODE_80AFE2		; $80AFDB: 90 05
	lda.w #$0008		; $80AFDD: A9 08 00
	tsb.b $55		; $80AFE0: 04 55
CODE_80AFE2:		; M=16 X=16
	phx		; $80AFE2: DA
	ldx.b $55		; $80AFE3: A6 55
	lda.l $80AFF6,x		; $80AFE5: BF F6 AF 80
	plx		; $80AFE9: FA
	and.w #$00FF		; $80AFEA: 29 FF 00
	sta.b $53		; $80AFED: 85 53
	rtl		; $80AFEF: 6B
CODE_80AFF0:		; M=16 X=16
	lda.w #$0008		; $80AFF0: A9 08 00
	sta.b $53		; $80AFF3: 85 53
	rtl		; $80AFF5: 6B
	db $01,$07,$03,$05,$00,$00,$04,$04,$02,$06,$02,$06,$01,$07,$03,$05	; $80AFF6
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
	db $78,$FE,$FA,$FD,$83,$57,$02,$7E,$60,$46,$20,$17,$25,$42,$F5,$02	; $80F008
	db $95,$02,$C5,$12,$95,$12,$F5,$12,$FF,$FF,$1F,$BF,$8F,$DF,$0F,$1F	; $80F018
	db $2F,$5D,$EF,$FD,$4A,$0A,$2F,$30,$E8,$C0,$55,$06,$5E,$21,$46,$31	; $80F028
	db $66,$20,$05,$32,$02,$8F,$30,$C0,$FF,$20,$09,$F7,$83,$EF,$80,$E1	; $80F038
	db $91,$EA,$DF,$FF,$FD,$30,$FF,$02,$1F,$08,$93,$20,$00,$63,$20,$11	; $80F048
	db $E0,$80,$22,$80,$60,$06,$A2,$46,$4A,$EE,$F0,$F8,$78,$FC,$B8,$FC	; $80F058
	db $79,$FF,$48,$00,$F9,$49,$01,$F1,$FF,$E5,$B6,$C0,$40,$01,$BF,$BF	; $80F068
	db $D9,$E3,$BA,$00,$80,$4A,$00,$3F,$E0,$90,$01,$FE,$FC,$48,$02,$FF	; $80F078
	db $FD,$FC,$C4,$30,$FE,$32,$FF,$00,$03,$4D,$01,$01,$FE,$C4,$20,$48	; $80F088
	db $11,$38,$4F,$90,$4F,$1C,$C7,$09,$C6,$2C,$62,$25,$61,$B2,$F3,$BB	; $80F098
	db $9B,$BF,$F8,$49,$19,$FC,$BF,$FF,$9F,$FF,$9E,$FF,$0C,$FF,$84,$7F	; $80F0A8
	db $64,$C3,$68,$C7,$B5,$8E,$C8,$98,$83,$08,$B5,$86,$A4,$99,$5F,$20	; $80F0B8
	db $0A,$FF,$7C,$FF,$7E,$FF,$FF,$27,$FF,$70,$FC,$78,$D9,$10,$BF,$FF	; $80F0C8
	db $86,$1F,$CC,$07,$E3,$07,$89,$DB,$59,$C4,$3C,$80,$A8,$90,$FA,$20	; $80F0D8
	db $03,$FF,$FE,$FF,$FC,$81,$20,$02,$3B,$FF,$7F,$49,$04,$FD,$FF,$E9	; $80F0E8
	db $CC,$AB,$49,$05,$6A,$8C,$49,$8C,$CB,$0F,$48,$03,$8F,$0B,$F3,$FF	; $80F0F8
	db $4C,$00,$F2,$58,$00,$FC,$4A,$80,$BA,$81,$BB,$47,$81,$B8,$81,$98	; $80F108
	db $4F,$38,$FF,$E0,$C3,$50,$88,$1C,$00,$FE,$20,$00,$FC,$20,$14,$BB	; $80F118
	db $9B,$ED,$CD,$CA,$CE,$C0,$C6,$E3,$E5,$B1,$E2,$40,$83,$D0,$11,$84	; $80F128
	db $7F,$C2,$3F,$C1,$49,$05,$C0,$1F,$80,$0F,$20,$1F,$C4,$07,$FF,$C0	; $80F138
	db $A7,$90,$80,$AF,$0E,$13,$20,$06,$0F,$CF,$0F,$E3,$03,$98,$40,$20	; $80F148
	db $07,$DF,$4F,$E0,$50,$FF,$EF,$FF,$F0,$49,$18,$7C,$FF,$3F,$FF,$FC	; $80F158
	db $30,$EC,$30,$3E,$88,$4E,$90,$1C,$E0,$80,$81,$05,$01,$54,$29,$03	; $80F168
	db $FB,$C3,$07,$77,$80,$20,$00,$1F,$80,$DE,$00,$FE,$49,$11,$17,$1B	; $80F178
	db $13,$1B,$6B,$73,$F3,$E3,$03,$E3,$2D,$C3,$16,$C1,$23,$94,$E3,$FC	; $80F188
	db $48,$02,$83,$FC,$03,$49,$01,$01,$F8,$20,$02,$F8,$08,$F8,$3B,$FF	; $80F198
	db $01,$DF,$3F,$8A,$BC,$20,$00,$1F,$20,$01,$5F,$9F,$4A,$07,$5E,$9F	; $80F1A8
	db $59,$9E,$47,$98,$5F,$80,$48,$85,$BA,$00,$F8,$20,$00,$E0,$4B,$05	; $80F1B8
	db $F7,$F8,$DF,$E0,$BF,$C0,$87,$F4,$00,$F0,$20,$00,$C0,$20,$00,$80	; $80F1C8
	db $2A,$13,$C0,$08,$E0,$3A,$E0,$3D,$C2,$35,$E2,$08,$F1,$1E,$F0,$05	; $80F1D8
	db $F8,$0E,$30,$0F,$10,$07,$48,$06,$18,$03,$1C,$03,$0C,$01,$0E,$20	; $80F1E8
	db $00,$07,$20,$0A,$90,$4F,$6C,$23,$90,$31,$35,$8F,$01,$40,$57,$20	; $80F1F8
	db $00,$8F,$20,$02,$40,$80,$3F,$80,$BA,$00,$0E,$83,$4B,$00,$F8,$59	; $80F208
	db $08,$7F,$F0,$F1,$D3,$E0,$05,$C0,$9A,$F1,$21,$00,$89,$20,$00,$E3	; $80F218
	db $20,$06,$02,$01,$FE,$FF,$FC,$FF,$38,$83,$20,$E1,$1C,$10,$FE,$53	; $80F228
	db $3C,$97,$74,$07,$FC,$43,$8C,$8F,$70,$0F,$D8,$0F,$A0,$1F,$70,$20	; $80F238
	db $01,$F0,$08,$48,$07,$E0,$38,$E0,$18,$C0,$30,$80,$70,$81,$A0,$02	; $80F248
	db $0F,$FD,$03,$89,$D2,$00,$07,$20,$00,$01,$2C,$01,$FD,$FE,$48,$07	; $80F258
	db $7D,$FE,$9D,$7E,$F5,$0E,$FD,$06,$4A,$00,$F8,$80,$77,$00,$78,$20	; $80F268
	db $00,$18,$28,$81,$F4,$89,$02,$83,$F6,$4F,$E9,$50,$4B,$2F,$03,$F0	; $80F278
	db $0F,$F8,$07,$49,$05,$03,$FC,$07,$FC,$01,$FE,$68,$01,$03,$07,$80	; $80F288
	db $82,$4A,$00,$03,$49,$00,$01,$49,$14,$38,$40,$18,$A0,$06,$E8,$0E	; $80F298
	db $F4,$1F,$E8,$3C,$D0,$7B,$A3,$FE,$42,$80,$3F,$C0,$1F,$F0,$80,$30	; $80F2A8
	db $00,$F0,$20,$0B,$E1,$03,$C0,$07,$81,$0F,$2C,$02,$02,$09,$60,$17	; $80F2B8
	db $20,$08,$5F,$C0,$5F,$E0,$8F,$D0,$C7,$58,$63,$E0,$45,$05,$F0,$0F	; $80F2C8
	db $E0,$3F,$80,$3F,$20,$01,$1F,$80,$78,$05,$87,$F0,$0F,$F0,$1F,$E0	; $80F2D8
	db $E0,$31,$58,$01,$A0,$7F,$68,$C4,$84,$A0,$00,$C0,$49,$00,$80,$4B	; $80F2E8
	db $83,$D6,$4F,$00,$06,$2F,$89,$DC,$01,$40,$BF,$85,$40,$85,$46,$00	; $80F2F8
	db $80,$8B,$DC,$00,$FF,$8F,$E0,$00,$FF,$20,$00,$FE,$58,$00,$01,$87	; $80F308
	db $20,$81,$D4,$2B,$0B,$EE,$82,$EA,$06,$CA,$06,$82,$26,$05,$F1,$10	; $80F318
	db $C3,$82,$20,$00,$1F,$49,$06,$3F,$01,$5F,$62,$0F,$60,$0F,$23,$0B	; $80F328
	db $26,$41,$04,$62,$4A,$C5,$5D,$CE,$20,$D1,$61,$8D,$81,$20,$03,$83	; $80F338
	db $F8,$81,$F8,$20,$00,$F0,$20,$04,$E0,$0E,$C0,$1E,$80,$83,$60,$00	; $80F348
	db $7F,$58,$01,$80,$7F,$C6,$80,$8D,$E1,$8E,$82,$17,$28,$89,$DC,$01	; $80F358
	db $01,$FE,$8F,$A0,$E0,$00,$A5,$43,$18,$69,$71,$00,$85,$43,$90,$02	; $80F368
	db $E6,$45,$C9,$41,$FF,$D0,$11,$A5,$45,$C9,$7E,$00,$D0,$0A,$A9,$74	; $80F378
	db $81,$85,$43,$A9,$7E,$00,$85,$45,$6B	; $80F388
CODE_80F391:		; M=16 X=16
	stz.b $53		; $80F391: 64 53
	lda.b $3B		; $80F393: A5 3B
	bne CODE_80F399		; $80F395: D0 02
	inc.b $53		; $80F397: E6 53
CODE_80F399:		; M=16 X=16
	jsl.l $80B90C		; $80F399: 22 0C B9 80
	ora.b $00		; $80F39D: 05 00
	lda.l $AD0113,x		; $80F39F: BF 13 01 AD
	dey		; $80F3A3: 88
	ora.b ($89)		; $80F3A4: 12 89
	db $02,$00,$F0,$07,$A5,$53,$49,$01,$00,$85,$53,$A9,$15,$00,$85,$7D	; $80F3A6
	db $A5,$53,$85,$83,$22,$1C,$87,$8D,$6D,$7D,$04,$8D,$7D,$04,$A9,$02	; $80F3B6
	db $00,$85,$53,$22,$6D,$FD,$8A,$A9,$06,$00,$85,$57,$A5,$53,$10,$05	; $80F3C6
	db $C6,$57,$EE,$7D,$04,$A9,$0C,$00,$85,$53,$6B	; $80F3D6
CODE_80F3E1:		; M=16 X=16
	lda.w #$0001		; $80F3E1: A9 01 00
	tsb.w $128C		; $80F3E4: 0C 8C 12
	rtl		; $80F3E7: 6B
CODE_80F3E8:		; M=16 X=16
	lda.b $00		; $80F3E8: A5 00
	cmp.w $0176		; $80F3EA: CD 76 01
	beq CODE_80F412		; $80F3ED: F0 23
	sta.w $0176		; $80F3EF: 8D 76 01
	lda.w #$0001		; $80F3F2: A9 01 00
CODE_80F3F5:		; M=16 X=16
	bit.w $4212		; $80F3F5: 2C 12 42
	bne CODE_80F3F5		; $80F3F8: D0 FB
	lda.w $4218		; $80F3FA: AD 18 42
	sta.w $015E		; $80F3FD: 8D 5E 01
	lda.w $421A		; $80F400: AD 1A 42
	sta.w $0160		; $80F403: 8D 60 01
	lda.w $421C		; $80F406: AD 1C 42
	sta.w $0162		; $80F409: 8D 62 01
	lda.w $421E		; $80F40C: AD 1E 42
	sta.w $0164		; $80F40F: 8D 64 01
CODE_80F412:		; M=16 X=16
	lda.w $015E		; $80F412: AD 5E 01
	eor.w $0166		; $80F415: 4D 66 01
	and.w $015E		; $80F418: 2D 5E 01
	sta.w $016E		; $80F41B: 8D 6E 01
	lda.w $0160		; $80F41E: AD 60 01
	eor.w $0168		; $80F421: 4D 68 01
	and.w $0160		; $80F424: 2D 60 01
	sta.w $0170		; $80F427: 8D 70 01
	lda.w $0162		; $80F42A: AD 62 01
	eor.w $016A		; $80F42D: 4D 6A 01
	and.w $0162		; $80F430: 2D 62 01
	sta.w $0172		; $80F433: 8D 72 01
	lda.w $0164		; $80F436: AD 64 01
	eor.w $016C		; $80F439: 4D 6C 01
	and.w $0164		; $80F43C: 2D 64 01
	sta.w $0174		; $80F43F: 8D 74 01
	lda.w $015E		; $80F442: AD 5E 01
	sta.w $0166		; $80F445: 8D 66 01
	lda.w $0160		; $80F448: AD 60 01
	sta.w $0168		; $80F44B: 8D 68 01
	lda.w $0162		; $80F44E: AD 62 01
	sta.w $016A		; $80F451: 8D 6A 01
	lda.w $0164		; $80F454: AD 64 01
	sta.w $016C		; $80F457: 8D 6C 01
	rtl		; $80F45A: 6B
	db $8A,$4A,$CD,$BB,$0E,$F0,$03,$4C,$F9,$96,$BD,$7F,$11,$F0,$03,$4C	; $80F45B
	db $19,$F5,$AD,$8A,$12,$F0,$04,$5C,$5A,$D7,$8F,$BD,$DF,$0E,$89,$08	; $80F46B
	db $00,$F0,$03,$4C,$F9,$96,$89,$02,$00,$F0,$1B,$29,$FD,$FF,$9D,$DF	; $80F47B
	db $0E,$9E,$5F,$0C,$9E,$7F,$0C,$A9,$08,$00,$9D,$FF,$0C,$AD,$A1,$04	; $80F48B
	db $29,$03,$00,$9D,$9F,$0C,$BD,$5F,$0C,$38,$E5,$6F,$9D,$5F,$0C,$10	; $80F49B
	db $1B,$7D,$9F,$0F,$10,$03,$A9,$00,$00,$9D,$5F,$0C,$22,$98,$85,$80	; $80F4AB
	db $22,$81,$86,$80,$22,$E3,$86,$80,$22,$83,$FD,$8C,$A9,$06,$00,$18	; $80F4BB
	db $7D,$9F,$0C,$85,$53,$A9,$E2,$DF,$85,$33,$A9,$8F,$00,$85,$35,$AD	; $80F4CB
	db $8C,$12,$89,$00,$80,$F0,$05,$BD,$9F,$0B,$85,$53,$A5,$53,$0A,$0A	; $80F4DB
	db $A8,$B7,$33,$85,$53,$C8,$C8,$B7,$33,$85,$57,$BD,$3F,$11,$D0,$10	; $80F4EB
	db $A5,$53,$49,$FF,$FF,$1A,$85,$53,$A5,$57,$49,$FF,$FF,$1A,$85,$57	; $80F4FB
	db $A9,$1A,$F5,$85,$33,$A9,$80,$00,$85,$35,$5C,$D0,$FD,$88,$6B,$A5	; $80F50B
	db $53,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$85,$53,$BD,$E0	; $80F51B
	db $0A,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$18,$6D,$1B,$09	; $80F52B
	db $85,$5B,$BD,$00,$0B,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF	; $80F53B
	db $18,$6D,$7B,$09,$85,$5F,$9C,$D3,$08,$A9,$05,$00,$85,$63,$64,$33	; $80F54B
	db $E0,$0C,$00,$B0,$05,$A9,$0C,$00,$85,$33,$A4,$33,$B9,$E0,$0A,$29	; $80F55B
	db $FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$18,$79,$FF,$08,$38,$E5	; $80F56B
	db $5B,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$15,$00,$B0,$54,$B9	; $80F57B
	db $00,$0B,$29,$FF,$00,$89,$80,$00,$F0,$03,$09,$00,$FF,$18,$79,$5F	; $80F58B
	db $09,$38,$E5,$5F,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$15,$00	; $80F59B
	db $B0,$31,$EE,$D3,$08,$BD,$FF,$08,$38,$F9,$FF,$08,$85,$53,$BD,$5F	; $80F5AB
	db $09,$38,$F9,$5F,$09,$85,$57,$22,$A8,$AF,$80,$BD,$BF,$0D,$49,$04	; $80F5BB
	db $00,$C5,$53,$D0,$0E,$AD,$A3,$04,$29,$01,$00,$18,$65,$53,$29,$07	; $80F5CB
	db $00,$85,$53,$E6,$33,$E6,$33,$C6,$63,$30,$03,$4C,$65,$F5,$6B	; $80F5DB
CODE_80F5EA:		; M=16 X=16
	jsl.l $82FBC5		; $80F5EA: 22 C5 FB 82
	jml.l $8B817A		; $80F5EE: 5C 7A 81 8B
CODE_80F5F2:		; M=16 X=16
	jsl.l $88F512		; $80F5F2: 22 12 F5 88
	jml.l $8B8172		; $80F5F6: 5C 72 81 8B
CODE_80F5FA:		; M=16 X=16
	phx		; $80F5FA: DA
	ldx.w #$000E		; $80F5FB: A2 0E 00
CODE_80F5FE:		; M=16 X=16
	lda.w $1624,x		; $80F5FE: BD 24 16
	sta.b $93,x		; $80F601: 95 93
	stz.b $7D,x		; $80F603: 74 7D
	dex		; $80F605: CA
	dex		; $80F606: CA
	bpl CODE_80F5FE		; $80F607: 10 F5
	lda.b $53		; $80F609: A5 53
	sta.b $8D		; $80F60B: 85 8D
	ldx.w #$0080		; $80F60D: A2 80 00
CODE_80F610:		; M=16 X=16
	lsr.b $8D		; $80F610: 46 8D
	ror.b $8B		; $80F612: 66 8B
	ror.b $89		; $80F614: 66 89
	ror.b $87		; $80F616: 66 87
	ror.b $85		; $80F618: 66 85
	ror.b $83		; $80F61A: 66 83
	ror.b $81		; $80F61C: 66 81
	ror.b $7F		; $80F61E: 66 7F
	ror.b $7D		; $80F620: 66 7D
	asl.w $1624		; $80F622: 0E 24 16
	rol.w $1626		; $80F625: 2E 26 16
	rol.w $1628		; $80F628: 2E 28 16
	rol.w $162A		; $80F62B: 2E 2A 16
	rol.w $162C		; $80F62E: 2E 2C 16
	rol.w $162E		; $80F631: 2E 2E 16
	rol.w $1630		; $80F634: 2E 30 16
	rol.w $1632		; $80F637: 2E 32 16
	lda.b $93		; $80F63A: A5 93
	cmp.b $7D		; $80F63C: C5 7D
	lda.b $95		; $80F63E: A5 95
	sbc.b $7F		; $80F640: E5 7F
	lda.b $97		; $80F642: A5 97
	sbc.b $81		; $80F644: E5 81
	lda.b $99		; $80F646: A5 99
	sbc.b $83		; $80F648: E5 83
	lda.b $9B		; $80F64A: A5 9B
	sbc.b $85		; $80F64C: E5 85
	lda.b $9D		; $80F64E: A5 9D
	sbc.b $87		; $80F650: E5 87
	lda.b $9F		; $80F652: A5 9F
	sbc.b $89		; $80F654: E5 89
	lda.b $A1		; $80F656: A5 A1
	sbc.b $8B		; $80F658: E5 8B
	lda.w #$0000		; $80F65A: A9 00 00
	sbc.b $8D		; $80F65D: E5 8D
	bcc CODE_80F694		; $80F65F: 90 33
	lda.b $93		; $80F661: A5 93
	sbc.b $7D		; $80F663: E5 7D
	sta.b $93		; $80F665: 85 93
	lda.b $95		; $80F667: A5 95
	sbc.b $7F		; $80F669: E5 7F
	sta.b $95		; $80F66B: 85 95
	lda.b $97		; $80F66D: A5 97
	sbc.b $81		; $80F66F: E5 81
	sta.b $97		; $80F671: 85 97
	lda.b $99		; $80F673: A5 99
	sbc.b $83		; $80F675: E5 83
	sta.b $99		; $80F677: 85 99
	lda.b $9B		; $80F679: A5 9B
	sbc.b $85		; $80F67B: E5 85
	sta.b $9B		; $80F67D: 85 9B
	lda.b $9D		; $80F67F: A5 9D
	sbc.b $87		; $80F681: E5 87
	sta.b $9D		; $80F683: 85 9D
	lda.b $9F		; $80F685: A5 9F
	sbc.b $89		; $80F687: E5 89
	sta.b $9F		; $80F689: 85 9F
	lda.b $A1		; $80F68B: A5 A1
	sbc.b $8B		; $80F68D: E5 8B
	sta.b $A1		; $80F68F: 85 A1
	inc.w $1624		; $80F691: EE 24 16
CODE_80F694:		; M=16 X=16
	dex		; $80F694: CA
	beq CODE_80F69A		; $80F695: F0 03
	jmp.w $F610		; $80F697: 4C 10 F6
CODE_80F69A:		; M=16 X=16
	plx		; $80F69A: FA
	lda.b $93		; $80F69B: A5 93
	sta.b $53		; $80F69D: 85 53
	clc		; $80F69F: 18
	rtl		; $80F6A0: 6B
CODE_80F6A1:		; M=16 X=16
	sta.b $73		; $80F6A1: 85 73
	asl a		; $80F6A3: 0A
	jsl.l $80AE8B		; $80F6A4: 22 8B AE 80
	sec		; $80F6A8: 38
	sbc.b $73		; $80F6A9: E5 73
	clc		; $80F6AB: 18
	rtl		; $80F6AC: 6B
	db $BD,$7F,$11,$F0,$03,$4C,$D0,$F8,$22,$27,$85,$80,$BD,$DF,$0E,$89	; $80F6AD
	db $02,$00,$F0,$18,$29,$FD,$FF,$9D,$DF,$0E,$9E,$5F,$0C,$9E,$7F,$0C	; $80F6BD
	db $A9,$08,$00,$9D,$FF,$0C,$A9,$FF,$FF,$9D,$BF,$0C,$BD,$FF,$08,$89	; $80F6CD
	db $00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$35,$00,$B0,$16,$BD,$5F,$09	; $80F6DD
	db $89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$0F,$01,$B0,$05,$C9,$D3	; $80F6ED
	db $00,$B0,$2C,$A9,$E6,$84,$85,$33,$A9,$80,$00,$85,$35,$A9,$04,$00	; $80F6FD
	db $85,$53,$BD,$FF,$08,$10,$05,$A9,$FC,$FF,$85,$53,$A9,$E4,$00,$85	; $80F70D
	db $57,$BD,$3F,$11,$F0,$05,$A9,$1C,$FF,$85,$57,$5C,$D0,$FD,$88,$BD	; $80F71D
	db $DF,$11,$F0,$03,$4C,$D0,$F8,$A9,$02,$00,$85,$57,$22,$06,$B0,$80	; $80F72D
	db $AD,$8A,$12,$F0,$03,$4C,$D0,$F8,$BD,$DF,$0C,$30,$26,$BD,$9F,$0D	; $80F73D
	db $85,$53,$CD,$BB,$0E,$F0,$08,$A9,$FF,$FF,$9D,$DF,$0C,$80,$14,$BD	; $80F74D
	db $DF,$0C,$38,$E5,$6F,$9D,$DF,$0C,$10,$09,$A9,$08,$00,$85,$53,$22	; $80F75D
	db $B0,$C1,$80,$BD,$5F,$0C,$38,$E5,$6F,$9D,$5F,$0C,$30,$03,$4C,$FD	; $80F76D
	db $FB,$BD,$BF,$0F,$4A,$4A,$18,$7D,$5F,$0C,$10,$03,$A9,$00,$00,$9D	; $80F77D
	db $5F,$0C,$BD,$DF,$0E,$89,$08,$00,$F0,$03,$4C,$63,$F8,$AD,$7B,$09	; $80F78D
	db $85,$53,$BD,$5F,$09,$45,$53,$85,$57,$10,$17,$64,$53,$A9,$F4,$00	; $80F79D
	db $85,$5B,$BD,$3F,$11,$D0,$03,$4C,$7E,$FB,$A9,$0C,$FF,$85,$5B,$4C	; $80F7AD
	db $7E,$FB,$DE,$BF,$0C,$10,$06,$A9,$FF,$FF,$9D,$BF,$0C,$BD,$9F,$0D	; $80F7BD
	db $CD,$BB,$0E,$F0,$03,$4C,$63,$F8,$BD,$DF,$0C,$10,$06,$A9,$5A,$00	; $80F7CD
	db $9D,$DF,$0C,$A9,$FF,$FF,$9D,$BF,$0C,$BD,$DF,$0C,$38,$E9,$5A,$00	; $80F7DD
	db $F0,$09,$30,$05,$70,$05,$4C,$D1,$F8,$70,$FB,$A9,$64,$00,$22,$8B	; $80F7ED
	db $AE,$80,$C9,$4B,$00,$B0,$03,$4C,$D1,$F8,$A9,$05,$00,$85,$53,$64	; $80F7FD
	db $33,$BD,$9F,$11,$D0,$05,$A9,$0C,$00,$85,$33,$A4,$33,$B9,$DF,$0E	; $80F80D
	db $89,$00,$10,$D0,$2D,$AD,$7B,$09,$38,$F9,$5F,$09,$89,$00,$80,$F0	; $80F81D
	db $04,$49,$FF,$FF,$1A,$C9,$1D,$00,$B0,$18,$AD,$1B,$09,$38,$F9,$FF	; $80F82D
	db $08,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$1A,$00,$B0,$03,$4C	; $80F83D
	db $D1,$F8,$E6,$33,$E6,$33,$C6,$53,$10,$C1,$A9,$01,$00,$8D,$D3,$08	; $80F84D
	db $22,$83,$FD,$8C,$80,$6E,$BD,$BF,$0C,$D0,$69,$AD,$BB,$0E,$10,$64	; $80F85D
	db $AD,$1B,$09,$38,$FD,$FF,$08,$85,$53,$89,$00,$80,$F0,$04,$49,$FF	; $80F86D
	db $FF,$1A,$C9,$15,$00,$B0,$4D,$AD,$7B,$09,$85,$57,$89,$00,$80,$F0	; $80F87D
	db $04,$49,$FF,$FF,$1A,$C9,$09,$01,$B0,$3A,$A5,$57,$38,$FD,$5F,$09	; $80F88D
	db $85,$57,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$1F,$00,$B0,$24	; $80F89D
	db $22,$A8,$AF,$80,$A5,$53,$9D,$BF,$0D,$A9,$08,$00,$9D,$5F,$0E,$A9	; $80F8AD
	db $90,$14,$85,$57,$22,$06,$B0,$80,$A9,$96,$00,$9D,$DF,$11,$18,$65	; $80F8BD
	db $DE,$85,$DE,$6B,$A9,$89,$04,$85,$33,$A9,$00,$00,$85,$35,$A9,$04	; $80F8CD
	db $01,$85,$5F,$BD,$3F,$11,$F0,$0A,$A9,$8D,$04,$85,$33,$A9,$FC,$FE	; $80F8DD
	db $85,$5F,$BD,$5F,$09,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$05	; $80F8ED
	db $01,$B0,$37,$AD,$1B,$09,$85,$53,$AD,$7B,$09,$85,$57,$22,$C9,$FC	; $80F8FD
	db $80,$A5,$57,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$2E,$00,$B0	; $80F90D
	db $46,$A5,$57,$48,$A5,$53,$48,$22,$A8,$AF,$80,$22,$05,$FD,$80,$A3	; $80F91D
	db $01,$85,$53,$A3,$03,$85,$57,$4C,$CD,$F9,$64,$5B,$64,$53,$BD,$FF	; $80F92D
	db $08,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9,$2D,$00,$90,$03,$4C	; $80F93D
	db $7E,$FB,$A9,$88,$00,$85,$53,$BD,$FF,$08,$30,$03,$4C,$7E,$FB,$A9	; $80F94D
	db $78,$FF,$85,$53,$4C,$7E,$FB,$22,$A8,$AF,$80,$22,$05,$FD,$80,$AD	; $80F95D
	db $1B,$0B,$EB,$4A,$29,$7F,$00,$89,$40,$00,$F0,$03,$09,$80,$FF,$18	; $80F96D
	db $6D,$7B,$09,$85,$57,$AD,$FB,$0A,$EB,$29,$FF,$00,$89,$80,$00,$F0	; $80F97D
	db $03,$09,$00,$FF,$85,$53,$A5,$57,$38,$E9,$E0,$00,$F0,$08,$30,$04	; $80F98D
	db $70,$04,$80,$12,$70,$10,$A5,$57,$38,$E9,$20,$FF,$F0,$08,$30,$04	; $80F99D
	db $70,$04,$80,$0A,$70,$08,$A5,$53,$48,$0A,$68,$6A,$85,$53,$A5,$53	; $80F9AD
	db $18,$6D,$1B,$09,$85,$53,$22,$C9,$FC,$80,$A5,$57,$48,$A5,$53,$48	; $80F9BD
	db $A5,$53,$85,$7D,$85,$83,$22,$DB,$FC,$82,$85,$53,$A5,$95,$85,$55	; $80F9CD
	db $A5,$57,$85,$7D,$85,$83,$22,$DB,$FC,$82,$85,$57,$A5,$95,$85,$59	; $80F9DD
	db $A5,$53,$65,$57,$85,$53,$A5,$55,$65,$59,$85,$55,$A5,$53,$C9,$85	; $80F9ED
	db $03,$A5,$55,$E9,$00,$00,$B0,$08,$68,$85,$53,$68,$85,$57,$80,$50	; $80F9FD
	db $22,$B1,$CB,$80,$A5,$53,$1A,$85,$5B,$A9,$14,$00,$85,$63,$AD,$8C	; $80FA0D
	db $12,$89,$08,$00,$F0,$05,$A9,$1C,$00,$85,$63,$68,$85,$53,$68,$85	; $80FA1D
	db $57,$85,$83,$A5,$63,$85,$7D,$22,$DB,$FC,$82,$A5,$5B,$85,$7D,$22	; $80FA2D
	db $6C,$99,$80,$85,$57,$A5,$63,$69,$06,$00,$85,$63,$85,$7D,$A5,$53	; $80FA3D
	db $85,$83,$22,$DB,$FC,$82,$A5,$5B,$85,$7D,$22,$6C,$99,$80,$85,$53	; $80FA4D
	db $A5,$57,$18,$65,$5F,$85,$57,$85,$5B,$A0,$02,$00,$B7,$33,$C9,$14	; $80FA5D
	db $00,$90,$03,$4C,$7E,$FB,$A7,$33,$89,$00,$80,$F0,$04,$49,$FF,$FF	; $80FA6D
	db $1A,$C9,$19,$00,$90,$03,$4C,$15,$FC,$B7,$33,$C9,$0C,$00,$90,$03	; $80FA7D
	db $4C,$49,$FB,$AD,$7B,$09,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C9	; $80FA8D
	db $09,$01,$90,$03,$4C,$49,$FB,$BD,$DF,$11,$F0,$03,$4C,$49,$FB,$FE	; $80FA9D
	db $DF,$11,$A7,$33,$38,$FD,$FF,$08,$85,$53,$A5,$5F,$38,$FD,$5F,$09	; $80FAAD
	db $85,$57,$22,$A8,$AF,$80,$A5,$53,$38,$FD,$BF,$0D,$29,$07,$00,$85	; $80FABD
	db $5F,$4A,$4A,$85,$53,$BD,$DF,$09,$89,$00,$08,$F0,$07,$A5,$53,$49	; $80FACD
	db $01,$00,$85,$53,$AD,$BB,$09,$38,$E9,$08,$00,$F0,$08,$30,$04,$70	; $80FADD
	db $04,$80,$3B,$70,$39,$AD,$3B,$0B,$38,$E9,$00,$08,$F0,$08,$30,$04	; $80FAED
	db $70,$04,$80,$2A,$70,$28,$A5,$53,$18,$69,$04,$00,$85,$53,$A0,$02	; $80FAFD
	db $00,$B7,$33,$C9,$09,$00,$90,$16,$BD,$BF,$0D,$C9,$02,$00,$F0,$0E	; $80FB0D
	db $C9,$06,$00,$F0,$09,$AD,$BB,$0E,$30,$04,$C6,$53,$C6,$53,$06,$53	; $80FB1D
	db $A9,$70,$FD,$85,$37,$A9,$80,$00,$85,$39,$A4,$53,$B7,$37,$85,$57	; $80FB2D
	db $22,$06,$B0,$80,$A5,$DE,$18,$69,$96,$00,$85,$DE,$A7,$33,$85,$53	; $80FB3D
	db $AD,$7B,$09,$38,$E9,$FC,$00,$F0,$08,$30,$04,$70,$04,$80,$13,$70	; $80FB4D
	db $11,$AD,$7B,$09,$38,$E9,$04,$FF,$F0,$08,$30,$04,$70,$04,$80,$11	; $80FB5D
	db $70,$0F,$A9,$18,$00,$85,$53,$AD,$1B,$09,$10,$05,$A9,$E8,$FF,$85	; $80FB6D
	db $53,$A5,$5B,$85,$57,$48,$A5,$53,$48,$BD,$DF,$0A,$EB,$29,$FF,$00	; $80FB7D
	db $89,$80,$00,$F0,$03,$09,$00,$FF,$49,$FF,$FF,$1A,$85,$53,$68,$18	; $80FB8D
	db $65,$53,$38,$FD,$FF,$08,$85,$53,$BD,$FF,$0A,$EB,$29,$FF,$00,$89	; $80FB9D
	db $80,$00,$F0,$03,$09,$00,$FF,$49,$FF,$FF,$1A,$85,$57,$68,$18,$65	; $80FBAD
	db $57,$38,$FD,$5F,$09,$85,$57,$A9,$05,$00,$85,$73,$8A,$4A,$CD,$BB	; $80FBBD
	db $0E,$D0,$02,$06,$73,$A5,$53,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A	; $80FBCD
	db $C5,$73,$B0,$13,$A5,$57,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$C5	; $80FBDD
	db $73,$B0,$04,$64,$53,$64,$57,$22,$A8,$AF,$80,$A5,$53,$9D,$FF,$0C	; $80FBED
	db $BD,$FF,$0C,$85,$5B,$38,$E9,$07,$00,$F0,$04,$30,$06,$50,$06,$5C	; $80FBFD
	db $64,$E1,$8F,$50,$FA,$4C,$52,$84,$AD,$BB,$0E,$30,$03,$4C,$7E,$FB	; $80FC0D
	db $AD,$5C,$01,$89,$04,$00,$F0,$03,$4C,$7E,$FB,$64,$37,$A9,$02,$00	; $80FC1D
	db $85,$3B,$BD,$9F,$11,$F0,$07,$64,$3B,$A9,$02,$00,$85,$37,$A4,$37	; $80FC2D
	db $B9,$FA,$13,$C9,$24,$13,$B9,$FE,$13,$E9,$00,$00,$B0,$03,$4C,$7E	; $80FC3D
	db $FB,$A4,$3B,$B9,$FA,$13,$C9,$C4,$09,$B9,$FE,$13,$E9,$00,$00,$B0	; $80FC4D
	db $03,$4C,$7E,$FB,$AD,$7B,$09,$E9,$E0,$00,$F0,$08,$30,$04,$70,$04	; $80FC5D
	db $80,$14,$70,$12,$AD,$7B,$09,$38,$E9,$20,$FF,$F0,$09,$30,$05,$70	; $80FC6D
	db $05,$4C,$7E,$FB,$70,$FB,$AD,$1B,$0B,$85,$73,$BD,$3F,$11,$F0,$08	; $80FC7D
	db $A5,$73,$49,$FF,$FF,$1A,$85,$73,$A5,$73,$10,$03,$4C,$7E,$FB,$AD	; $80FC8D
	db $FB,$0A,$89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$85,$53,$AD,$1B,$0B	; $80FC9D
	db $89,$00,$80,$F0,$04,$49,$FF,$FF,$1A,$85,$57,$A5,$57,$C5,$53,$B0	; $80FCAD
	db $03,$4C,$7E,$FB,$A9,$0F,$00,$85,$53,$4C,$9D,$B4,$AD,$BB,$0E,$85	; $80FCBD
	db $5B,$DD,$9F,$0D,$D0,$02,$64,$53,$A5,$57,$38,$E9,$03,$01,$30,$04	; $80FCCD
	db $50,$04,$80,$07,$50,$05,$A9,$03,$01,$85,$57,$A5,$57,$38,$E9,$FD	; $80FCDD
	db $FE,$F0,$08,$30,$04,$70,$04,$80,$07,$70,$05,$A9,$FD,$FE,$85,$57	; $80FCED
	db $A5,$57,$38,$E5,$5F,$85,$57,$6B,$BD,$BF,$0D,$85,$57,$A5,$53,$38	; $80FCFD
	db $E5,$57,$85,$53,$D0,$03,$4C,$D0,$F8,$49,$FF,$FF,$1A,$29,$04,$00	; $80FD0D
	db $4A,$3A,$85,$53,$A5,$57,$C9,$01,$00,$F0,$05,$C9,$06,$00,$D0,$31	; $80FD1D
	db $18,$65,$53,$85,$57,$BD,$3F,$11,$D0,$0E,$A5,$57,$C9,$02,$00,$90	; $80FD2D
	db $13,$C9,$07,$00,$F0,$0E,$80,$20,$A5,$57,$C9,$03,$00,$90,$19,$C9	; $80FD3D
	db $06,$00,$B0,$14,$A5,$53,$49,$FF,$FF,$1A,$85,$53,$18,$65,$57,$85	; $80FD4D
	db $57,$A5,$57,$18,$65,$53,$85,$57,$A5,$57,$29,$07,$00,$85,$57,$9D	; $80FD5D
	db $BF,$0D,$6B,$66,$01,$98,$01,$2E,$02,$80,$02,$CA,$01,$FC,$01	; $80FD6D
CODE_80FD7C:		; M=16 X=16
	lda.w $0EDF,x		; $80FD7C: BD DF 0E
	bit.w #$0008		; $80FD7F: 89 08 00
	beq CODE_80FD87		; $80FD82: F0 03
	jmp.w $FE88		; $80FD84: 4C 88 FE
CODE_80FD87:		; M=16 X=16
	lda.w #$0008		; $80FD87: A9 08 00
	sta.b $53		; $80FD8A: 85 53
	lda.w #$0005		; $80FD8C: A9 05 00
	sta.b $57		; $80FD8F: 85 57
	lda.w #$FFFE		; $80FD91: A9 FE FF
	sta.b $33		; $80FD94: 85 33
	lda.w $119F,x		; $80FD96: BD 9F 11
	bne CODE_80FDA0		; $80FD99: D0 05
	lda.w #$000A		; $80FD9B: A9 0A 00
	sta.b $33		; $80FD9E: 85 33
CODE_80FDA0:		; M=16 X=16
	inc.b $33		; $80FDA0: E6 33
	inc.b $33		; $80FDA2: E6 33
	ldy.b $33		; $80FDA4: A4 33
	lda.w $0B9F,y		; $80FDA6: B9 9F 0B
	beq CODE_80FDB2		; $80FDA9: F0 07
	dec.b $57		; $80FDAB: C6 57
	bpl CODE_80FDA0		; $80FDAD: 10 F1
	jmp.w $FE83		; $80FDAF: 4C 83 FE
CODE_80FDB2:		; M=16 X=16
	lda.w $0AE0,y		; $80FDB2: B9 E0 0A
	and.w #$00FF		; $80FDB5: 29 FF 00
	bit.w #$0080		; $80FDB8: 89 80 00
	beq CODE_80FDC0		; $80FDBB: F0 03
	ora.w #$FF00		; $80FDBD: 09 00 FF
CODE_80FDC0:		; M=16 X=16
	pha		; $80FDC0: 48
	asl a		; $80FDC1: 0A
	pla		; $80FDC2: 68
	ror a		; $80FDC3: 6A
	clc		; $80FDC4: 18
	adc.w $08FF,y		; $80FDC5: 79 FF 08
	sec		; $80FDC8: 38
	sbc.w $091B		; $80FDC9: ED 1B 09
	sta.b $53		; $80FDCC: 85 53
	lda.w $0B00,y		; $80FDCE: B9 00 0B
	and.w #$00FF		; $80FDD1: 29 FF 00
	bit.w #$0080		; $80FDD4: 89 80 00
	beq CODE_80FDDC		; $80FDD7: F0 03
	ora.w #$FF00		; $80FDD9: 09 00 FF
CODE_80FDDC:		; M=16 X=16
	pha		; $80FDDC: 48
	asl a		; $80FDDD: 0A
	pla		; $80FDDE: 68
	ror a		; $80FDDF: 6A
	clc		; $80FDE0: 18
	adc.w $095F,y		; $80FDE1: 79 5F 09
	sec		; $80FDE4: 38
	sbc.w $097B		; $80FDE5: ED 7B 09
	sta.b $57		; $80FDE8: 85 57
	pha		; $80FDEA: 48
	lda.b $53		; $80FDEB: A5 53
	pha		; $80FDED: 48
	sta.b $7D		; $80FDEE: 85 7D
	sta.b $83		; $80FDF0: 85 83
	jsl.l $82FCDB		; $80FDF2: 22 DB FC 82
	sta.b $53		; $80FDF6: 85 53
	lda.b $95		; $80FDF8: A5 95
	sta.b $55		; $80FDFA: 85 55
	lda.b $57		; $80FDFC: A5 57
	sta.b $7D		; $80FDFE: 85 7D
	sta.b $83		; $80FE00: 85 83
	jsl.l $82FCDB		; $80FE02: 22 DB FC 82
	sec		; $80FE06: 38
	adc.b $53		; $80FE07: 65 53
	sta.b $53		; $80FE09: 85 53
	lda.b $95		; $80FE0B: A5 95
	adc.b $55		; $80FE0D: 65 55
	sta.b $55		; $80FE0F: 85 55
	jsl.l $80CBB1		; $80FE11: 22 B1 CB 80
	lda.b $53		; $80FE15: A5 53
	sta.b $5B		; $80FE17: 85 5B
	pla		; $80FE19: 68
	sta.b $53		; $80FE1A: 85 53
	pla		; $80FE1C: 68
	sta.b $57		; $80FE1D: 85 57
	lda.w #$0012		; $80FE1F: A9 12 00
	sta.b $5F		; $80FE22: 85 5F
	lda.w #$0108		; $80FE24: A9 08 01
	sta.b $63		; $80FE27: 85 63
	lda.w $113F,x		; $80FE29: BD 3F 11
	bne CODE_80FE33		; $80FE2C: D0 05
	lda.w #$FEF8		; $80FE2E: A9 F8 FE
	sta.b $63		; $80FE31: 85 63
CODE_80FE33:		; M=16 X=16
	lda.b $63		; $80FE33: A5 63
	pha		; $80FE35: 48
	lda.b $5F		; $80FE36: A5 5F
	pha		; $80FE38: 48
	jsl.l $80FE89		; $80FE39: 22 89 FE 80
	lda.b $63		; $80FE3D: A5 63
	sta.b $67		; $80FE3F: 85 67
	pla		; $80FE41: 68
	eor.w #$FFFF		; $80FE42: 49 FF FF
	inc a		; $80FE45: 1A
	sta.b $5F		; $80FE46: 85 5F
	pla		; $80FE48: 68
	sta.b $63		; $80FE49: 85 63
	jsl.l $80FE89		; $80FE4B: 22 89 FE 80
	lda.b $63		; $80FE4F: A5 63
	clc		; $80FE51: 18
	adc.b $67		; $80FE52: 65 67
	sta.b $63		; $80FE54: 85 63
	stz.b $53		; $80FE56: 64 53
	lda.b $63		; $80FE58: A5 63
	bit.w #$8000		; $80FE5A: 89 00 80
	beq CODE_80FE63		; $80FE5D: F0 04
	eor.w #$FFFF		; $80FE5F: 49 FF FF
	inc a		; $80FE62: 1A
CODE_80FE63:		; M=16 X=16
	cmp.w #$002D		; $80FE63: C9 2D 00
	bcs CODE_80FE83		; $80FE66: B0 1B
	lda.w $113F,x		; $80FE68: BD 3F 11
	beq CODE_80FE75		; $80FE6B: F0 08
	lda.b $63		; $80FE6D: A5 63
	eor.w #$FFFF		; $80FE6F: 49 FF FF
	inc a		; $80FE72: 1A
	sta.b $63		; $80FE73: 85 63
CODE_80FE75:		; M=16 X=16
	lda.w #$0002		; $80FE75: A9 02 00
	sta.b $53		; $80FE78: 85 53
	lda.b $63		; $80FE7A: A5 63
	bpl CODE_80FE83		; $80FE7C: 10 05
	lda.w #$0006		; $80FE7E: A9 06 00
	sta.b $53		; $80FE81: 85 53
CODE_80FE83:		; M=16 X=16
	lda.b $53		; $80FE83: A5 53
	sta.w $043B		; $80FE85: 8D 3B 04
CODE_80FE88:		; M=16 X=16
	rtl		; $80FE88: 6B
CODE_80FE89:		; M=16 X=16
	lda.b $5F		; $80FE89: A5 5F
	sec		; $80FE8B: 38
	sbc.w $091B		; $80FE8C: ED 1B 09
	sta.b $5F		; $80FE8F: 85 5F
	lda.b $63		; $80FE91: A5 63
	sec		; $80FE93: 38
	sbc.w $097B		; $80FE94: ED 7B 09
	sta.b $83		; $80FE97: 85 83
	lda.b $53		; $80FE99: A5 53
	sta.b $7D		; $80FE9B: 85 7D
	jsl.l $82FCDB		; $80FE9D: 22 DB FC 82
	sta.b $63		; $80FEA1: 85 63
	lda.b $95		; $80FEA3: A5 95
	sta.b $65		; $80FEA5: 85 65
	lda.b $57		; $80FEA7: A5 57
	sta.b $7D		; $80FEA9: 85 7D
	lda.b $5F		; $80FEAB: A5 5F
	sta.b $83		; $80FEAD: 85 83
	jsl.l $82FCDB		; $80FEAF: 22 DB FC 82
	sta.b $5F		; $80FEB3: 85 5F
	lda.b $95		; $80FEB5: A5 95
	sta.b $61		; $80FEB7: 85 61
	lda.b $63		; $80FEB9: A5 63
	sec		; $80FEBB: 38
	sbc.b $5F		; $80FEBC: E5 5F
	sta.b $83		; $80FEBE: 85 83
	lda.b $65		; $80FEC0: A5 65
	sbc.b $61		; $80FEC2: E5 61
	sta.b $85		; $80FEC4: 85 85
	lda.b $5B		; $80FEC6: A5 5B
	sta.b $7D		; $80FEC8: 85 7D
	jsl.l $80996C		; $80FECA: 22 6C 99 80
	sta.b $63		; $80FECE: 85 63
	rtl		; $80FED0: 6B
CODE_80FED1:		; M=16 X=16
	lda.w #$0032		; $80FED1: A9 32 00
	sta.b $53		; $80FED4: 85 53
CODE_80FED6:		; M=16 X=16
	lda.b $3B		; $80FED6: A5 3B
	beq CODE_80FEDD		; $80FED8: F0 03
	lda.w #$0034		; $80FEDA: A9 34 00
CODE_80FEDD:		; M=16 X=16
	clc		; $80FEDD: 18
	adc.b $53		; $80FEDE: 65 53
	tay		; $80FEE0: A8
	lda.w #$1000		; $80FEE1: A9 00 10
	sta.w $147A,y		; $80FEE4: 99 7A 14
	lda.w $14E2,y		; $80FEE7: B9 E2 14
	cmp.w #$FFFD		; $80FEEA: C9 FD FF
	bne CODE_80FEF5		; $80FEED: D0 06
	lda.w #$FFFE		; $80FEEF: A9 FE FF
	sta.w $14E2,y		; $80FEF2: 99 E2 14
CODE_80FEF5:		; M=16 X=16
	dec.b $53		; $80FEF5: C6 53
	dec.b $53		; $80FEF7: C6 53
	bpl CODE_80FED6		; $80FEF9: 10 DB
	rtl		; $80FEFB: 6B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FEFC
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF0C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF1C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF2C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF3C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF4C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF5C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF6C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF7C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF8C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FF9C
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $80FFAC
	db $FF,$FF,$FF,$FF	; $80FFBC
; Internal header $FFC0-$FFFF follows as data (see header.asm notes)
	db $4E,$48,$4C,$50,$41,$20,$48,$6F,$63,$6B,$65,$79,$20,$27,$39,$33	; $80FFC0
	db $20,$20,$20,$20,$20,$30,$00,$09,$00,$01,$69,$00,$5A,$B7,$A5,$48	; $80FFD0
	db $FF,$FF,$FF,$FF,$B4,$80,$B2,$80,$B4,$80,$B4,$80,$00,$80,$90,$83	; $80FFE0
	db $FF,$FF,$FF,$FF,$B4,$80,$B4,$80,$B4,$80,$B4,$80,$00,$80,$90,$83	; $80FFF0
