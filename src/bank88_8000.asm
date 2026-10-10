; $888000-$88900E  ROM $40000-$4100E: GameSetupMap (packed game setup screen backdrop), SmallFontMap (print: character -> small font tile),
; mulu32, getlinee (penalty93_2), the 92G password code (WritePassBits, EncodePW, PWprint, SuperMult), noturn0 (logic93_5), FramerMap and
; FramerTiles, showcrowd (video93_1), DrawGameSetupBack, mulu; then SpriteSet8 (frame set 8: arrows, pads, puck, goal), tiles continue to bank88_9000.
org $888000
GameSetupMap:		;SNES: the game setup screen backdrop (two team boxes, options box), packed: 32 x 32 map, 128 colours at $800, 18 tiles at $900
	incbin "../data/GameSetup.map.pak"		; $888000-$88822E
GameSetupMapEnd:
	assert GameSetupMapEnd-GameSetupMap == $22F
SmallFontMap:		;93G smallfontmap: print character (0-127) -> small font tile (+ flip bits), added to smallfontchars by print
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; $88822F chars $00-$07
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; $88823F chars $08-$0F
	dw $0000,$0000,$0001,$0002,$0003,$0000,$0004,$0005		; $88824F chars $10-$17
	dw $0006,$0007,$0000,$0000,$0000,$0060,$0061,$0062		; $88825F chars $18-$1F
	dw $0000,$0008,$0009,$000A,$000B,$000C,$0000,$000D		; $88826F chars $20-$27
	dw $000E,$000F,$0010,$0011,$0012,$0013,$0014,$0015		; $88827F chars $28-$2F
	dw $0016,$0017,$0018,$0019,$001A,$001B,$001C,$001D		; $88828F chars $30-$37
	dw $001E,$001F,$0020,$0021,$0022,$0023,$0024,$0025		; $88829F chars $38-$3F
	dw $0026,$0027,$0028,$0029,$002A,$002B,$002C,$002D		; $8882AF chars $40-$47
	dw $002E,$002F,$0030,$0031,$0032,$0033,$0034,$0016		; $8882BF chars $48-$4F
	dw $0035,$0036,$0037,$0038,$0039,$003A,$003B,$003C		; $8882CF chars $50-$57
	dw $003D,$003E,$003F,$0040,$0041,$4040,$0042,$0043		; $8882DF chars $58-$5F
	dw $0044,$0045,$0046,$0047,$0048,$0049,$004A,$004B		; $8882EF chars $60-$67
	dw $004C,$004D,$004E,$004F,$0050,$0051,$0052,$0053		; $8882FF chars $68-$6F
	dw $0054,$0055,$0056,$0057,$0058,$0059,$005A,$005B		; $88830F chars $70-$77
	dw $005C,$005D,$005E,$0063,$005F,$8063,$0000,$0000		; $88831F chars $78-$7F
mulu32:		;auto: CODE_88832F. SNES: 32-bit multiply with the 8x8 hardware multiplier: A = mulres (32-bit, low word) = mula * mulb (low 32 bits). C clear
	sep #$20		; $88832F: E2 20
	lda.b mula		; $888331: A5 7D
	sta.w WRMPYA		; $888333: 8D 02 42
	lda.b mulb		; $888336: A5 83
	sta.w WRMPYB		; $888338: 8D 03 42
	rep #$30		; $88833B: C2 30
	rep #$30		; $88833D: C2 30
	clc		; $88833F: 18
	lda.w RDMPYL		; $888340: AD 16 42
	sta.b mulres		; $888343: 85 93
	stz.b mulres+2		; $888345: 64 95
	sep #$20		; $888347: E2 20
	lda.b mulb+1		; $888349: A5 84
	sta.w WRMPYB		; $88834B: 8D 03 42
	rep #$30		; $88834E: C2 30
	rep #$30		; $888350: C2 30
	clc		; $888352: 18
	lda.w RDMPYL		; $888353: AD 16 42
	adc.b mulres+1		; $888356: 65 94
	sta.b mulres+1		; $888358: 85 94
	sep #$20		; $88835A: E2 20
	bcc .c1		; $88835C: 90 02
	inc.b mulres+3		; $88835E: E6 96
.c1:
	lda.b mulb+2		; $888360: A5 85
	sta.w WRMPYB		; $888362: 8D 03 42
	rep #$30		; $888365: C2 30
	rep #$30		; $888367: C2 30
	clc		; $888369: 18
	lda.w RDMPYL		; $88836A: AD 16 42
	adc.b mulres+2		; $88836D: 65 95
	sta.b mulres+2		; $88836F: 85 95
	sep #$20		; $888371: E2 20
	lda.b mulb+3		; $888373: A5 86
	sta.w WRMPYB		; $888375: 8D 03 42
	clc		; $888378: 18
	clc		; $888379: 18
	clc		; $88837A: 18
	clc		; $88837B: 18
	lda.w RDMPYL		; $88837C: AD 16 42
	adc.b mulres+3		; $88837F: 65 96
	sta.b mulres+3		; $888381: 85 96
	lda.b mula+1		; $888383: A5 7E
	sta.w WRMPYA		; $888385: 8D 02 42
	lda.b mulb		; $888388: A5 83
	sta.w WRMPYB		; $88838A: 8D 03 42
	rep #$30		; $88838D: C2 30
	rep #$30		; $88838F: C2 30
	clc		; $888391: 18
	lda.w RDMPYL		; $888392: AD 16 42
	adc.b mulres+1		; $888395: 65 94
	sta.b mulres+1		; $888397: 85 94
	sep #$20		; $888399: E2 20
	bcc .c2		; $88839B: 90 02
	inc.b mulres+3		; $88839D: E6 96
.c2:
	lda.b mulb+1		; $88839F: A5 84
	sta.w WRMPYB		; $8883A1: 8D 03 42
	rep #$30		; $8883A4: C2 30
	rep #$30		; $8883A6: C2 30
	clc		; $8883A8: 18
	lda.w RDMPYL		; $8883A9: AD 16 42
	adc.b mulres+2		; $8883AC: 65 95
	sta.b mulres+2		; $8883AE: 85 95
	sep #$20		; $8883B0: E2 20
	lda.b mulb+2		; $8883B2: A5 85
	sta.w WRMPYB		; $8883B4: 8D 03 42
	clc		; $8883B7: 18
	clc		; $8883B8: 18
	clc		; $8883B9: 18
	clc		; $8883BA: 18
	lda.w RDMPYL		; $8883BB: AD 16 42
	adc.b mulres+3		; $8883BE: 65 96
	sta.b mulres+3		; $8883C0: 85 96
	lda.b mula+2		; $8883C2: A5 7F
	sta.w WRMPYA		; $8883C4: 8D 02 42
	lda.b mulb		; $8883C7: A5 83
	sta.w WRMPYB		; $8883C9: 8D 03 42
	rep #$30		; $8883CC: C2 30
	rep #$30		; $8883CE: C2 30
	clc		; $8883D0: 18
	lda.w RDMPYL		; $8883D1: AD 16 42
	adc.b mulres+2		; $8883D4: 65 95
	sta.b mulres+2		; $8883D6: 85 95
	sep #$20		; $8883D8: E2 20
	lda.b mulb+1		; $8883DA: A5 84
	sta.w WRMPYB		; $8883DC: 8D 03 42
	clc		; $8883DF: 18
	clc		; $8883E0: 18
	clc		; $8883E1: 18
	clc		; $8883E2: 18
	lda.w RDMPYL		; $8883E3: AD 16 42
	adc.b mulres+3		; $8883E6: 65 96
	sta.b mulres+3		; $8883E8: 85 96
	lda.b mula+3		; $8883EA: A5 80
	sta.w WRMPYA		; $8883EC: 8D 02 42
	lda.b mulb		; $8883EF: A5 83
	sta.w WRMPYB		; $8883F1: 8D 03 42
	clc		; $8883F4: 18
	clc		; $8883F5: 18
	clc		; $8883F6: 18
	clc		; $8883F7: 18
	lda.w RDMPYL		; $8883F8: AD 16 42
	adc.b mulres+3		; $8883FB: 65 96
	sta.b mulres+3		; $8883FD: 85 96
	rep #$30		; $8883FF: C2 30
	lda.b mulres		; $888401: A5 93
	clc		; $888403: 18
	rtl		; $888404: 6B
getlinee:		;auto: CODE_888405. 93G getlinee (penalty93_2): d0 = line number, a2 = team. Returns d0 = average energy (tmpde) of the skaters of that line (priolist $8FF820 picks the positions)
	stx.b xsave		; $888405: 86 0A
	ldx.w #$0000		; $888407: A2 00 00
.pushd:
	lda.b d3,x		; $88840A: B5 5F
	pha		; $88840C: 48
	inx		; $88840D: E8
	inx		; $88840E: E8
	cpx.w #$0008		; $88840F: E0 08 00
	bne .pushd		; $888412: D0 F6
	ldx.b xsave		; $888414: A6 0A
	stx.b xsave		; $888416: 86 0A
	ldx.w #$0000		; $888418: A2 00 00
.pusha:
	lda.b a0,x		; $88841B: B5 33
	pha		; $88841D: 48
	inx		; $88841E: E8
	inx		; $88841F: E8
	cpx.w #$0008		; $888420: E0 08 00
	bne .pusha		; $888423: D0 F6
	ldx.b xsave		; $888425: A6 0A
	ldy.b a2		; $888427: A4 3B
	lda.w tmdata,y		; $888429: B9 CE 13
	sta.b a1		; $88842C: 85 37
	lda.w #$0083		; $88842E: A9 83 00  a1 = the team data (bank $83)
	sta.b a1+2		; $888431: 85 39
	ldy.w #$0006		; $888433: A0 06 00  + offset of the line sets
	lda.b [a1],y		; $888436: B7 37
	clc		; $888438: 18
	adc.b a1		; $888439: 65 37
	sta.b a1		; $88843B: 85 37
	lda.b d0		; $88843D: A5 53  line d0: 8 bytes
	asl a		; $88843F: 0A
	asl a		; $888440: 0A
	asl a		; $888441: 0A
	adc.b a1		; $888442: 65 37
	sta.b a1		; $888444: 85 37
	stz.b mulb		; $888446: 64 83
	stz.b mula		; $888448: 64 7D
	lda.w #$F820		; $88844A: A9 20 F8  a0 = priolist ($8FF820)
	sta.b a0		; $88844D: 85 33
	lda.w #$008F		; $88844F: A9 8F 00
	sta.b a0+2		; $888452: 85 35
	ldy.b a2		; $888454: A4 3B  tmap: positions - 1
	lda.w tmap,y		; $888456: B9 EE 13
	sta.b d4		; $888459: 85 63
	bra .next		; $88845B: 80 25
.loop:
	ldy.b d4		; $88845D: A4 63
	lda.b [a0],y		; $88845F: B7 33
	and.w #$00FF		; $888461: 29 FF 00
	beq .next		; $888464: F0 1C
	tay		; $888466: A8  player number
	lda.b [a1],y		; $888467: B7 37
	and.w #$00FF		; $888469: 29 FF 00
	asl a		; $88846C: 0A
	sta.b d3		; $88846D: 85 5F
	inc.b mula		; $88846F: E6 7D
	lda.b a2		; $888471: A5 3B
	beq .home		; $888473: F0 03
	lda.w #$0034		; $888475: A9 34 00
.home:
	adc.b d3		; $888478: 65 5F
	tay		; $88847A: A8
	lda.w tmpde-2,y		; $88847B: B9 78 14
	adc.b mulb		; $88847E: 65 83
	sta.b mulb		; $888480: 85 83
.next:
	dec.b d4		; $888482: C6 63
	bpl .loop		; $888484: 10 D7
	jsl.l divu16		; $888486: 22 D8 B8 80  d0 = energy sum / players
	sta.b d0		; $88848A: 85 53
	stx.b xsave		; $88848C: 86 0A
	ldx.w #$0006		; $88848E: A2 06 00
.popa:
	pla		; $888491: 68
	sta.b a0,x		; $888492: 95 33
	dex		; $888494: CA
	dex		; $888495: CA
	bpl .popa		; $888496: 10 F9
	ldx.b xsave		; $888498: A6 0A
	stx.b xsave		; $88849A: 86 0A
	ldx.w #$0006		; $88849C: A2 06 00
.popd:
	pla		; $88849F: 68
	sta.b d3,x		; $8884A0: 95 5F
	dex		; $8884A2: CA
	dex		; $8884A3: CA
	bpl .popd		; $8884A4: 10 F9
	ldx.b xsave		; $8884A6: A6 0A
	rtl		; $8884A8: 6B
WritePassBits:		;auto: CODE_8884A9. 92G WritePassBits: playoff state into passbits (PushBits with each range), then the 9-bit checksum of the values (d7) with range 512
	jsl.l ClrPassBits		; $8884A9: 22 EA FB 82
	stz.b d7		; $8884AD: 64 6F
	lda.w postarts		; $8884AF: AD 51 04  PushBits ranges: postarts 32, bosgames 8, gamelevel 4, potreeteam 16, pojoy 4, WinBits $4000
	sta.b d0		; $8884B2: 85 53
	lda.w #32		; $8884B4: A9 20 00
	sta.b d1		; $8884B7: 85 57
	jsl.l .pb		; $8884B9: 22 3D 85 88
	lda.b bosgames		; $8884BD: A5 D6
	sta.b d0		; $8884BF: 85 53
	lda.w #8		; $8884C1: A9 08 00
	sta.b d1		; $8884C4: 85 57
	jsl.l .pb		; $8884C6: 22 3D 85 88
	lda.w gamelevel		; $8884CA: AD 4A 01
	sta.b d0		; $8884CD: 85 53
	lda.w #4		; $8884CF: A9 04 00
	sta.b d1		; $8884D2: 85 57
	jsl.l .pb		; $8884D4: 22 3D 85 88
	lda.w potreeteam		; $8884D8: AD 73 04
	sta.b d0		; $8884DB: 85 53
	lda.w #16		; $8884DD: A9 10 00
	sta.b d1		; $8884E0: 85 57
	jsl.l .pb		; $8884E2: 22 3D 85 88
	lda.w pojoy		; $8884E6: AD 4F 04
	sta.b d0		; $8884E9: 85 53
	lda.w #4		; $8884EB: A9 04 00
	sta.b d1		; $8884EE: 85 57
	jsl.l .pb		; $8884F0: 22 3D 85 88
	lda.w WinBits		; $8884F4: AD E7 08
	sta.b d0		; $8884F7: 85 53
	lda.w #$4000		; $8884F9: A9 00 40
	sta.b d1		; $8884FC: 85 57
	jsl.l .pb		; $8884FE: 22 3D 85 88
	lda.w #5		; $888502: A9 05 00
	sta.b d1		; $888505: 85 57
	lda.w #7		; $888507: A9 07 00
	sta.b d2		; $88850A: 85 5B
	stz.b a1		; $88850C: 64 37
.gs:		;93G .0: the 8 series scores, range 5
	ldy.b a1		; $88850E: A4 37
	lda.w gspotwins,y		; $888510: B9 9F 15
	sta.b d0		; $888513: 85 53
	jsl.l .pb		; $888515: 22 3D 85 88
	ldy.b a1		; $888519: A4 37
	lda.w gspobwins,y		; $88851B: B9 AF 15
	sta.b d0		; $88851E: 85 53
	jsl.l .pb		; $888520: 22 3D 85 88
	inc.b a1		; $888524: E6 37
	inc.b a1		; $888526: E6 37
	dec.b d2		; $888528: C6 5B
	bpl .gs		; $88852A: 10 E2
	lda.b d7		; $88852C: A5 6F  checksum
	and.w #$01FF		; $88852E: 29 FF 01
	sta.b d0		; $888531: 85 53
	lda.w #512		; $888533: A9 00 02
	sta.b d1		; $888536: 85 57
	jsl.l PushBits		; $888538: 22 03 FC 82
	rtl		; $88853C: 6B
.pb:		;92G .pb: d7 += d0, then PushBits
	lda.b d7		; $88853D: A5 6F
	clc		; $88853F: 18
	adc.b d0		; $888540: 65 53
	sta.b d7		; $888542: 85 6F
	jml.l PushBits		; $888544: 5C 03 FC 82
noturn0:		;auto: CODE_888548 (from doplayeracc). 93G noturn0 (logic93_5): wanted direction needs no turn; glide/stop/skate animation, then revplayeracc (93G noturn). d0 = direction - facedir
	lda.w #$0002		; $888548: A9 02 00  d4 (here d2) = 2, 6 skating backwards
	sta.b d4		; $88854B: 85 63
	lda.w pfrev,x		; $88854D: BD BF 11
	beq .zero		; $888550: F0 0C
	lda.w #$0006		; $888552: A9 06 00
	sta.b d4		; $888555: 85 63
	lda.b d0		; $888557: A5 53
	eor.w #$0008		; $888559: 49 08 00
	sta.b d0		; $88855C: 85 53
.zero:		;93G .0
	lda.b d0		; $88855E: A5 53
	beq .nochg		; $888560: F0 59
	lda.w Xvel,x		; $888562: BD DF 0A  moving: stop if the direction is more than 90 degrees off
	sta.b d0		; $888565: 85 53
	lda.w Yvel,x		; $888567: BD FF 0A
	sta.b d1		; $88856A: 85 57
	jsl.l vtoa		; $88856C: 22 A8 AF 80
	bit.w #$0008		; $888570: 89 08 00
	bne .nostop		; $888573: D0 15
	sec		; $888575: 38
	sbc.w facedir,x		; $888576: FD BF 0D
	clc		; $888579: 18
	adc.b d4		; $88857A: 65 63
	and.w #$0007		; $88857C: 29 07 00
	sta.b d0		; $88857F: 85 53
	cmp.w #$0004		; $888581: C9 04 00
	bcs .nostop		; $888584: B0 04
	jml.l dostop		; $888586: 5C 04 84 80
.nostop:
	inc.w facedir,x		; $88858A: FE BF 0D  turn one step
	lda.w attribute,x		; $88858D: BD DF 09
	bit.w #$0800		; $888590: 89 00 08
	beq .nos0		; $888593: F0 06
	dec.w facedir,x		; $888595: DE BF 0D
	dec.w facedir,x		; $888598: DE BF 0D
.nos0:
	lda.w facedir,x		; $88859B: BD BF 0D
	and.w #$0007		; $88859E: 29 07 00
	sta.w facedir,x		; $8885A1: 9D BF 0D
	lda.w #SPAglide		; $8885A4: A9 78 04
	sta.b d1		; $8885A7: 85 57
	lda.w pfrev,x		; $8885A9: BD BF 11
	bne .gback		; $8885AC: D0 04
	jml.l SetSPA		; $8885AE: 5C 06 B0 80
.gback:
	lda.w #SPAglideback		; $8885B2: A9 CC 09
	sta.b d1		; $8885B5: 85 57
	jml.l SetSPA		; $8885B7: 5C 06 B0 80
.nochg:
	lda.w #SPAskateback		; $8885BB: A9 FE 09  no change: skate
	sta.b d1		; $8885BE: 85 57
	lda.w pfrev,x		; $8885C0: BD BF 11
	bne .ns		; $8885C3: D0 21
	lda.w #SPAskate		; $8885C5: A9 5C 05
	sta.b d1		; $8885C8: 85 57
	lda.w pflags,x		; $8885CA: BD DF 0E  pflags $0004 (93G pflags2 bit 6): stumble
	bit.w #$0004		; $8885CD: 89 04 00
	beq .nb6		; $8885D0: F0 05
	lda.w #SPAstumble		; $8885D2: A9 A2 12
	sta.b d1		; $8885D5: 85 57
.nb6:
	lda.w puckc		; $8885D7: AD BB 0E  carrier: skate with the puck
	sta.b d4		; $8885DA: 85 63
	cmp.w SCnum,x		; $8885DC: DD 9F 0D
	bne .ns		; $8885DF: D0 05
	lda.w #SPAskatewp		; $8885E1: A9 AA 04
	sta.b d1		; $8885E4: 85 57
.ns:
	lda.w pf2aip,x		; $8885E6: BD DF 11
	beq .set		; $8885E9: F0 04
	jml.l revplayeracc		; $8885EB: 5C 54 FD 82
.set:
	jsl.l SetSPA		; $8885EF: 22 06 B0 80
	jml.l revplayeracc		; $8885F3: 5C 54 FD 82
PWprint:		;auto: CODE_8885F7. 92G PWprint: print the 16 password characters (PassWord through PasstoText) at printx/printy, unless PassWord bit 7 hides it
	lda.w PassWord		; $8885F7: AD 10 16
	bit.w #$0080		; $8885FA: 89 80 00
	beq .show		; $8885FD: F0 03
	jmp.w .rtl		; $8885FF: 4C 8C 86
.show:
	stx.b xsave		; $888602: 86 0A
	ldx.w #$0000		; $888604: A2 00 00
.pushd:
	lda.b d0,x		; $888607: B5 53
	pha		; $888609: 48
	inx		; $88860A: E8
	inx		; $88860B: E8
	cpx.w #$0008		; $88860C: E0 08 00
	bne .pushd		; $88860F: D0 F6
	ldx.b xsave		; $888611: A6 0A
	stx.b xsave		; $888613: 86 0A
	ldx.w #$0000		; $888615: A2 00 00
.pusha:
	lda.b a0,x		; $888618: B5 33
	pha		; $88861A: 48
	inx		; $88861B: E8
	inx		; $88861C: E8
	cpx.w #$000C		; $88861D: E0 0C 00
	bne .pusha		; $888620: D0 F6
	ldx.b xsave		; $888622: A6 0A
	lda.w #PasstoText		; $888624: A9 A6 FB  a2 = PasstoText
	sta.b a2		; $888627: 85 3B
	lda.w #PasstoText>>16		; $888629: A9 82 00
	sta.b a2+2		; $88862C: 85 3D
	lda.w #mesarea		; $88862E: A9 91 01  a1 = mesarea
	sta.b a1		; $888631: 85 37
	lda.w #$0000		; $888633: A9 00 00
	sta.b a1+2		; $888636: 85 39
	lda.w #PassWord		; $888638: A9 10 16
	sta.b a0		; $88863B: 85 33
	lda.w #$0000		; $88863D: A9 00 00
	sta.b a0+2		; $888640: 85 35
	lda.w #18		; $888642: A9 12 00  length 18: 16 characters
	sta.b [a1]		; $888645: 87 37
	inc.b a1		; $888647: E6 37
	inc.b a1		; $888649: E6 37
	lda.w #15		; $88864B: A9 0F 00
	sta.b d1		; $88864E: 85 57
.top:
	lda.b [a0]		; $888650: A7 33
	inc.b a0		; $888652: E6 33
	and.w #$00FF		; $888654: 29 FF 00
	tay		; $888657: A8
	lda.b [a2],y		; $888658: B7 3B
	sta.b [a1]		; $88865A: 87 37
	inc.b a1		; $88865C: E6 37
	dec.b d1		; $88865E: C6 57
	bpl .top		; $888660: 10 EE
	lda.w #mesarea		; $888662: A9 91 01
	sta.b a1		; $888665: 85 37
	lda.w #$0000		; $888667: A9 00 00
	sta.b a1+2		; $88866A: 85 39
	jsl.l print		; $88866C: 22 2D B9 80
	stx.b xsave		; $888670: 86 0A
	ldx.w #$000A		; $888672: A2 0A 00
.popa:
	pla		; $888675: 68
	sta.b a0,x		; $888676: 95 33
	dex		; $888678: CA
	dex		; $888679: CA
	bpl .popa		; $88867A: 10 F9
	ldx.b xsave		; $88867C: A6 0A
	stx.b xsave		; $88867E: 86 0A
	ldx.w #$0006		; $888680: A2 06 00
.popd:
	pla		; $888683: 68
	sta.b d0,x		; $888684: 95 53
	dex		; $888686: CA
	dex		; $888687: CA
	bpl .popd		; $888688: 10 F9
	ldx.b xsave		; $88868A: A6 0A
.rtl:
	rtl		; $88868C: 6B
EncodePW:		;auto: CODE_88868D. 92G EncodePW (Rev A): after a playoff game, ResolveGames and maketree; then the new password, or new playoffs when the user won or went out
	lda.w OptPlayMode		; $88868D: AD 00 16
	bne .po		; $888690: D0 03
	jmp.w .rtl		; $888692: 4C 1B 87
.po:
	lda.w #$0001		; $888695: A9 01 00
	sta.w OptPlayMode		; $888698: 8D 00 16
	jsl.l ResolveGames		; $88869B: 22 53 82 8B  bank $8B: 92G ResolveGames
	jsl.l $8D8000		; $88869F: 22 00 80 8D  bank $8D: maketree
	lda.w gamelevel		; $8886A3: AD 4A 01  finished playoffs
	cmp.w #$0004		; $8886A6: C9 04 00
	beq .userwon		; $8886A9: F0 53
	lda.w gamenum		; $8886AB: AD 4C 01  gamenum >= 0: player 1 won
	bpl .nofail		; $8886AE: 10 29
	lda.w pojoy		; $8886B0: AD 4F 04  pojoy < 2: one player or teammates
	sec		; $8886B3: 38
	sbc.w #$0002		; $8886B4: E9 02 00
	bmi .lt		; $8886B7: 30 04
	bvc .two		; $8886B9: 50 04
	bra .userfailed		; $8886BB: 80 45
.lt:
	bvc .userfailed		; $8886BD: 50 43
.two:		;two players, first round: switch to the other team
	lda.w gamelevel		; $8886BF: AD 4A 01
	cmp.w #$0001		; $8886C2: C9 01 00
	bne .userfailed		; $8886C5: D0 3B
	lda.w potreeteam		; $8886C7: AD 73 04
	eor.w #$0001		; $8886CA: 49 01 00
	sta.w potreeteam		; $8886CD: 8D 73 04
	lda.w pojoy		; $8886D0: AD 4F 04
	eor.w #$0001		; $8886D3: 49 01 00
	sta.w pojoy		; $8886D6: 8D 4F 04
.nofail:
	jsl.l WritePassBits		; $8886D9: 22 A9 84 88
	jsl.l BitstoPW		; $8886DD: 22 01 FA 82
	lda.w sflags3		; $8886E1: AD 90 12  sf3alttree: passbits before all games were resolved
	bit.w #sf3alttree		; $8886E4: 89 04 00
	beq .tree		; $8886E7: F0 11
	ldy.w #$000E		; $8886E9: A0 0E 00
.cp:
	lda.w tpassbits,y		; $8886EC: B9 34 16
	sta.w passbits,y		; $8886EF: 99 24 16
	dey		; $8886F2: 88
	dey		; $8886F3: 88
	bpl .cp		; $8886F4: 10 F6
	jsl.l ReadPassBits		; $8886F6: 22 7A 81 8B  bank $8B: 92G ReadPassBits
.tree:
	jml.l $8D8000		; $8886FA: 5C 00 80 8D  bank $8D: maketree
.userwon:
	jsl.l $8F9073		; $8886FE: 22 73 90 8F  bank $8F: 92G ResetPassWord
.userfailed:
	lda.w #$0080		; $888702: A9 80 00  PassWord bit 7: no password
	tsb.w PassWord		; $888705: 0C 10 16
	lda.w #$0002		; $888708: A9 02 00
	sta.w OptPlayMode		; $88870B: 8D 00 16
	lda.b bosgames		; $88870E: A5 D6
	cmp.w #$0007		; $888710: C9 07 00
	beq .rtl		; $888713: F0 06
	lda.w #$0003		; $888715: A9 03 00
	sta.w OptPlayMode		; $888718: 8D 00 16
.rtl:
	rtl		; $88871B: 6B
FramerMap:		;93G Framer.map.jim: the 3 x 3 box pieces (corner, edge, side, centre) from the 4 FramerTiles with flips ($8FD724)
	dw $0000,$0001,$4000		; $88871C
	dw $0002,$0003,$4002		; $888722
	dw $8000,$8001,$C000		; $888728
FramerTiles:		;the 4 Framer box tiles (4bpp, data/Framer.chr): vram by $8FDCFD; setupice remaps them with PixelRemap87
	incbin "../data/Framer.chr"		; $88872E-$8887AD
showcrowd:		;auto: CODE_8887AE. 93G showcrowd (video93_1): crowd sprites: up to 3 frames per PBnum nibble (penalty box), then the two crowdframe frames (not on the horizontal rink)
	stz.b a1		; $8887AE: 64 37
	lda.w Hpos		; $8887B0: AD 54 01
	sta.b d4		; $8887B3: 85 63
	lda.w Vpos		; $8887B5: AD DF 08
	sta.b d5		; $8887B8: 85 67
	lda.w sfhormode		; $8887BA: AD 8E 12
	beq .v		; $8887BD: F0 0A
	lda.w #$FFC0		; $8887BF: A9 C0 FF
	sta.b d4		; $8887C2: 85 63
	lda.w #$0100		; $8887C4: A9 00 01
	sta.b d5		; $8887C7: 85 67
.v:
	stz.b d0		; $8887C9: 64 53
	lda.w PBnum		; $8887CB: AD E4 12
	sta.b d2		; $8887CE: 85 5B
	lda.w #$001A		; $8887D0: A9 1A 00  frames 26+
	sta.b d3		; $8887D3: 85 5F
	jsl.l .pb		; $8887D5: 22 FE 87 88
	lda.w PBnum		; $8887D9: AD E4 12
	lsr a		; $8887DC: 4A
	lsr a		; $8887DD: 4A
	lsr a		; $8887DE: 4A
	lsr a		; $8887DF: 4A
	sta.b d2		; $8887E0: 85 5B
	lda.w #$001D		; $8887E2: A9 1D 00  frames 29+
	sta.b d3		; $8887E5: 85 5F
	jsl.l .pb		; $8887E7: 22 FE 87 88
	lda.w sfhormode		; $8887EB: AD 8E 12
	bne .rtl		; $8887EE: D0 30
	lda.b crowdframe		; $8887F0: A5 DC
	sta.b d0		; $8887F2: 85 53
	jsl.l .sc		; $8887F4: 22 21 88 88
	lda.b crowdframe+1		; $8887F8: A5 DD
	sta.b d0		; $8887FA: 85 53
	bra .sc		; $8887FC: 80 23
.pb:		;d2 = count, d3 = first frame
	lda.b d2		; $8887FE: A5 5B
	and.w #$000F		; $888800: 29 0F 00
	sta.b d2		; $888803: 85 5B
	cmp.w #$0004		; $888805: C9 04 00
	bcc .pb0		; $888808: 90 05
	lda.w #$0003		; $88880A: A9 03 00
	sta.b d2		; $88880D: 85 5B
.pb0:
	bra .nextpb		; $88880F: 80 0B
.pbt:
	lda.b d3		; $888811: A5 5F
	clc		; $888813: 18
	adc.b d2		; $888814: 65 5B
	sta.b d0		; $888816: 85 53
	jsl.l .sc		; $888818: 22 21 88 88
.nextpb:
	dec.b d2		; $88881C: C6 5B
	bpl .pbt		; $88881E: 10 F1
.rtl:
	rtl		; $888820: 6B
.sc:		;d0 = frame (0 = none): sprite frame $292 + d0 (+31 horizontal) at the rink scroll position
	lda.b d0		; $888821: A5 53  frame byte
	and.w #$00FF		; $888823: 29 FF 00
	sta.b d0		; $888826: 85 53
	beq .rtl		; $888828: F0 F6
	lda.w sfhormode		; $88882A: AD 8E 12
	beq .chk		; $88882D: F0 08
	lda.b d0		; $88882F: A5 53
	clc		; $888831: 18
	adc.w #31		; $888832: 69 1F 00
	sta.b d0		; $888835: 85 53
.chk:
	lda.b d0		; $888837: A5 53
	clc		; $888839: 18
	adc.w #$0292		; $88883A: 69 92 02  crowd frames start at $293
	sta.b sprframe		; $88883D: 85 C3
	lda.w #$FFC0		; $88883F: A9 C0 FF  x = $FFC0 - Hpos
	sec		; $888842: 38
	sbc.b d4		; $888843: E5 63
	sta.b sprx		; $888845: 85 C9
	lda.w #$FEFF		; $888847: A9 FF FE  y = Vpos - $101
	clc		; $88884A: 18
	adc.b d5		; $88884B: 65 67
	sta.b spry		; $88884D: 85 CB
	jml.l addframe_hi		; $88884F: 5C 17 FD 82
SuperMult:		;auto: CODE_888853. 92G SuperMult: passbits (8 words) *= d0, by shift and add (mulres..mulres+15 hold the shifted copy)
	phx		; $888853: DA
	ldx.w #$000E		; $888854: A2 0E 00
.copy:
	lda.w passbits,x		; $888857: BD 24 16  copy passbits, clear passbits
	sta.b mulres,x		; $88885A: 95 93
	stz.w passbits,x		; $88885C: 9E 24 16
	dex		; $88885F: CA
	dex		; $888860: CA
	bpl .copy		; $888861: 10 F4
	lda.b d0		; $888863: A5 53
	sta.b mula		; $888865: 85 7D
.loop:
	lsr.b mula		; $888867: 46 7D
	bcc .noadd		; $888869: 90 41
	lda.w passbits		; $88886B: AD 24 16
	clc		; $88886E: 18
	adc.b mulres		; $88886F: 65 93
	sta.w passbits		; $888871: 8D 24 16
	lda.w passbits+2		; $888874: AD 26 16
	adc.b mulres+2		; $888877: 65 95
	sta.w passbits+2		; $888879: 8D 26 16
	lda.w passbits+4		; $88887C: AD 28 16
	adc.b mulres+4		; $88887F: 65 97
	sta.w passbits+4		; $888881: 8D 28 16
	lda.w passbits+6		; $888884: AD 2A 16
	adc.b mulres+6		; $888887: 65 99
	sta.w passbits+6		; $888889: 8D 2A 16
	lda.w passbits+8		; $88888C: AD 2C 16
	adc.b mulres+8		; $88888F: 65 9B
	sta.w passbits+8		; $888891: 8D 2C 16
	lda.w passbits+10		; $888894: AD 2E 16
	adc.b mulres+10		; $888897: 65 9D
	sta.w passbits+10		; $888899: 8D 2E 16
	lda.w passbits+12		; $88889C: AD 30 16
	adc.b mulres+12		; $88889F: 65 9F
	sta.w passbits+12		; $8888A1: 8D 30 16
	lda.w passbits+14		; $8888A4: AD 32 16
	adc.b mulres+14		; $8888A7: 65 A1
	sta.w passbits+14		; $8888A9: 8D 32 16
.noadd:
	asl.b mulres		; $8888AC: 06 93
	rol.b mulres+2		; $8888AE: 26 95
	rol.b mulres+4		; $8888B0: 26 97
	rol.b mulres+6		; $8888B2: 26 99
	rol.b mulres+8		; $8888B4: 26 9B
	rol.b mulres+10		; $8888B6: 26 9D
	rol.b mulres+12		; $8888B8: 26 9F
	rol.b mulres+14		; $8888BA: 26 A1
	lda.b mula		; $8888BC: A5 7D
	bne .loop		; $8888BE: D0 A7
	plx		; $8888C0: FA
	clc		; $8888C1: 18
	rtl		; $8888C2: 6B
DrawGameSetupBack:		;auto: CODE_8888C3. SNES: game setup screen backdrop: textmap blank, GameSetupMap to backmap (priority off), the NHLPA logo map ($8C8000, 8 x 10) into textmap at x 12-19, y 0-9
	lda.w blankchar		; $8888C3: AD E7 1B
	ldx.w #$07FE		; $8888C6: A2 FE 07
.clr:
	sta.l textmap,x		; $8888C9: 9F 74 6E 7E
	dex		; $8888CD: CA
	dex		; $8888CE: CA
	bpl .clr		; $8888CF: 10 F8
	lda.w #GameSetupMap		; $8888D1: A9 00 80
	sta.b tmp0		; $8888D4: 85 73
	lda.w #GameSetupMap>>16		; $8888D6: A9 88 00
	sta.b tmp1		; $8888D9: 85 75
	jsl.l DecompressGraphics		; $8888DB: 22 3E FA 86
	ldx.w #$07FE		; $8888DF: A2 FE 07
.map:
	lda.l TestList,x		; $8888E2: BF 00 00 7F
	and.w #$DFFF		; $8888E6: 29 FF DF  priority bit off
	sta.l backmap,x		; $8888E9: 9F 74 76 7E
	dex		; $8888ED: CA
	dex		; $8888EE: CA
	bpl .map		; $8888EF: 10 F1
	stz.b textdirtylo		; $8888F1: 64 D0
	lda.w #$03FF		; $8888F3: A9 FF 03
	sta.b textdirtyhi		; $8888F6: 85 D2
	lda.w #NHLPALogo		; $8888F8: A9 00 80  the NHLPA logo (packed)
	sta.b tmp0		; $8888FB: 85 73
	lda.w #NHLPALogo>>16		; $8888FD: A9 8C 00
	sta.b tmp1		; $888900: 85 75
	jsl.l DecompressGraphics		; $888902: 22 3E FA 86
	lda.w #$0009		; $888906: A9 09 00
	sta.b tmp1		; $888909: 85 75
.row:
	lda.w #$0007		; $88890B: A9 07 00
	sta.b tmp0		; $88890E: 85 73
.col:
	lda.b tmp1		; $888910: A5 75
	sta.b mula		; $888912: 85 7D
	lda.w #$0008		; $888914: A9 08 00
	sta.b mulb		; $888917: 85 83
	jsl.l $8D871C		; $888919: 22 1C 87 8D  bank $8D: 16-bit multiply
	adc.b tmp0		; $88891D: 65 73
	asl a		; $88891F: 0A  logo map word + logochars
	tax		; $888920: AA
	lda.l TestList,x		; $888921: BF 00 00 7F
	adc.w logochars		; $888925: 6D DD 1B
	pha		; $888928: 48
	lda.b tmp1		; $888929: A5 75
	asl a		; $88892B: 0A
	asl a		; $88892C: 0A
	asl a		; $88892D: 0A
	asl a		; $88892E: 0A
	asl a		; $88892F: 0A  textmap row y * 32 + x + 12
	adc.b tmp0		; $888930: 65 73
	asl a		; $888932: 0A
	tax		; $888933: AA
	pla		; $888934: 68
	sta.l textmap+$18,x		; $888935: 9F 8C 6E 7E
	dec.b tmp0		; $888939: C6 73
	bpl .col		; $88893B: 10 D3
	dec.b tmp1		; $88893D: C6 75
	bpl .row		; $88893F: 10 CA
	rtl		; $888941: 6B
mulu:		;auto: CODE_888942. 68k mulu.w: mulres (32-bit) = mula * mulb; mula/mulb also get the result. A byte factor uses the mode 7 multiplier (M7A/M7B)
	lda.b mula		; $888942: A5 7D  mula >= $80 needs mulb < $80
	bmi .full		; $888944: 30 5F
	cmp.w #$0080		; $888946: C9 80 00
	bcc .byteb		; $888949: 90 30
	lda.b mulb		; $88894B: A5 83
	bmi .full		; $88894D: 30 56
	cmp.w #$0080		; $88894F: C9 80 00
	bcs .full		; $888952: B0 51
	sep #$20		; $888954: E2 20
	sta.w M7B		; $888956: 8D 1C 21
	lda.b mula		; $888959: A5 7D
	sta.w M7A		; $88895B: 8D 1B 21
	lda.b mula+1		; $88895E: A5 7E
	sta.w M7A		; $888960: 8D 1B 21
	lda.w MPYH		; $888963: AD 36 21
	rep #$30		; $888966: C2 30
	and.w #$00FF		; $888968: 29 FF 00
	sta.b mula+2		; $88896B: 85 7F
	sta.b mulb+2		; $88896D: 85 85
	sta.b mulres+2		; $88896F: 85 95
	lda.w MPYL		; $888971: AD 34 21
	sta.b mula		; $888974: 85 7D
	sta.b mulb		; $888976: 85 83
	sta.b mulres		; $888978: 85 93
	rtl		; $88897A: 6B
.byteb:
	lda.b mulb		; $88897B: A5 83  mula < $80: byte factor
	bmi .full		; $88897D: 30 26
	sep #$20		; $88897F: E2 20
	sta.w M7A		; $888981: 8D 1B 21
	xba		; $888984: EB
	sta.w M7A		; $888985: 8D 1B 21
	lda.b mula		; $888988: A5 7D
	sta.w M7B		; $88898A: 8D 1C 21
	lda.w MPYH		; $88898D: AD 36 21
	rep #$30		; $888990: C2 30
	and.w #$00FF		; $888992: 29 FF 00
	sta.b mula+2		; $888995: 85 7F
	sta.b mulb+2		; $888997: 85 85
	sta.b mulres+2		; $888999: 85 95
	lda.w MPYL		; $88899B: AD 34 21
	sta.b mula		; $88899E: 85 7D
	sta.b mulb		; $8889A0: 85 83
	sta.b mulres		; $8889A2: 85 93
	rtl		; $8889A4: 6B
.full:
	sep #$20		; $8889A5: E2 20
	lda.b mula		; $8889A7: A5 7D
	sta.w WRMPYA		; $8889A9: 8D 02 42
	lda.b mulb		; $8889AC: A5 83
	sta.w WRMPYB		; $8889AE: 8D 03 42
	rep #$30		; $8889B1: C2 30
	rep #$30		; $8889B3: C2 30
	clc		; $8889B5: 18
	lda.w RDMPYL		; $8889B6: AD 16 42
	sta.b mulres		; $8889B9: 85 93
	stz.b mulres+2		; $8889BB: 64 95
	sep #$20		; $8889BD: E2 20
	lda.b mulb+1		; $8889BF: A5 84
	sta.w WRMPYB		; $8889C1: 8D 03 42
	rep #$30		; $8889C4: C2 30
	rep #$30		; $8889C6: C2 30
	clc		; $8889C8: 18
	lda.w RDMPYL		; $8889C9: AD 16 42
	adc.b mulres+1		; $8889CC: 65 94
	sta.b mulres+1		; $8889CE: 85 94
	sep #$20		; $8889D0: E2 20
	bcc .c1		; $8889D2: 90 02
	inc.b mulres+3		; $8889D4: E6 96
.c1:
	lda.b mula+1		; $8889D6: A5 7E
	sta.w WRMPYA		; $8889D8: 8D 02 42
	lda.b mulb		; $8889DB: A5 83
	sta.w WRMPYB		; $8889DD: 8D 03 42
	rep #$30		; $8889E0: C2 30
	rep #$30		; $8889E2: C2 30
	clc		; $8889E4: 18
	lda.w RDMPYL		; $8889E5: AD 16 42
	adc.b mulres+1		; $8889E8: 65 94
	sta.b mulres+1		; $8889EA: 85 94
	sep #$20		; $8889EC: E2 20
	bcc .c2		; $8889EE: 90 02
	inc.b mulres+3		; $8889F0: E6 96
.c2:
	lda.b mulb+1		; $8889F2: A5 84
	sta.w WRMPYB		; $8889F4: 8D 03 42
	rep #$30		; $8889F7: C2 30
	rep #$30		; $8889F9: C2 30
	clc		; $8889FB: 18
	lda.w RDMPYL		; $8889FC: AD 16 42
	adc.b mulres+2		; $8889FF: 65 95
	sta.b mula+2		; $888A01: 85 7F
	sta.b mulb+2		; $888A03: 85 85
	sta.b mulres+2		; $888A05: 85 95
	lda.b mulres		; $888A07: A5 93
	sta.b mula		; $888A09: 85 7D
	sta.b mulb		; $888A0B: 85 83
	clc		; $888A0D: 18
	rtl		; $888A0E: 6B
SpriteSet8:		;frame set 8 (arrows, pads, puck and goal): frames 384-405
	dw 22		; $888A0F frames
	dw 75		; $888A11 pieces
	dw 128		; $888A13 tiles
	dw .pieces-SpriteSet8		; $888A15
	dw .tiles-SpriteSet8		; $888A17
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,12,18,24,30,36,38		; $888A19
	dw 40,42,43,44,45,46,47,48		; $888A29
	dw 49,50,51,52,53,63,75		; $888A39
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set08.pieces"		; $888A47-$888B72
	assert .tiles-.pieces == 4*75
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set08.chr":0..$49C		; $888B73-$88900E
