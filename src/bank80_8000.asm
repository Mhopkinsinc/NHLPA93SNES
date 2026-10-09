; $808000-$808FFF  ROM $00000  (from src/bank80.asm; quick pass, TODO segment agents refine)
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
