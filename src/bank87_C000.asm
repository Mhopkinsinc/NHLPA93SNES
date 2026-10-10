; $87C000-$87D204  ROM $3C000-$3D204: the last SpriteSet2 tiles; EASNMap (93G EASN.map.jim: the EASN logo backdrop, packed map and
; tiles); FaceOffTiles (packed faceoff box tiles); TeamBlocksMap (93G TeamBlocks.map: the 9 x 2 tile name block of each team);
; DrawFrame, the SNES sprite emitter for frames below $293 (4-byte pieces) and the addframe end. Ends after it (boundary moved from $87CFFF).
org $87C000
	incbin "../data/Sprites/set02.chr":$3C60..$4000		; $87C000-$87C39F
SpriteSet2End:
	assert SpriteSet2End-SpriteSet2 == $3A0+512*32
EASNMap:		;93G EASN.map.jim: the EASN logo backdrop, packed (decompressor $86FA3E): a 32 x 16 map, then the tiles; unpacked by $8FDC7B and $8FE8D9
	incbin "../data/EASN.map.pak"		; $87C3A0-$87C6B3
FaceOffTiles:		;packed faceoff box tiles (55, 93G FaceOff.map.jim tiles): setupice sends them to faceoffvrcset
	incbin "../data/FaceOff.chr.pak"		; $87C6B4-$87CAB9
TeamBlocksMap:		;93G TeamBlocks.map: per team (26) a 9 x 2 tile block map (palette 1, tiles from TeamBlocksTiles), 36 bytes each (team * 36 by $88F672, $8D84F4)
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406,$0401,$0407,$0408,$0409,$040A,$040B,$040C,$040D,$040E,$0409,$040F		; $87CABA team 0
	dw $0410,$0411,$0412,$0413,$0414,$0415,$0416,$0417,$0418,$0408,$0419,$041A,$041B,$041C,$041D,$041E,$041F,$040F		; $87CADE team 1
	dw $0420,$0421,$0422,$0423,$0424,$0425,$0426,$0427,$0428,$0408,$0429,$042A,$042B,$042C,$042D,$042E,$0409,$040F		; $87CB02 team 2
	dw $0400,$042F,$0430,$0431,$0432,$0433,$0434,$0401,$0407,$0435,$0436,$0437,$0438,$0439,$043A,$043B,$043C,$043D		; $87CB26 team 3
	dw $0420,$043E,$043F,$0440,$0441,$0442,$0443,$043E,$0428,$0435,$043C,$0444,$0445,$0446,$0447,$0448,$043C,$043D		; $87CB4A team 4
	dw $0449,$044A,$044B,$044C,$044D,$044E,$044F,$0450,$0451,$0452,$0453,$0454,$0455,$0456,$0457,$0458,$0459,$045A		; $87CB6E team 5
	dw $045B,$045C,$045D,$045E,$045F,$0460,$0461,$0462,$0463,$0464,$0465,$0466,$0467,$0468,$0469,$046A,$046B,$046C		; $87CB92 team 6
	dw $046D,$046E,$046F,$0470,$0471,$0472,$0473,$0474,$0475,$0476,$0477,$0478,$0479,$047A,$047B,$047C,$047D,$047E		; $87CBB6 team 7
	dw $047F,$0480,$0481,$0482,$0483,$0484,$0485,$0486,$0487,$0488,$0489,$048A,$048B,$048C,$048D,$048E,$048F,$0490		; $87CBDA team 8
	dw $0400,$0491,$0492,$0493,$0494,$0495,$0496,$0497,$0407,$0498,$0499,$049A,$049B,$049C,$049D,$049E,$049F,$04A0		; $87CBFE team 9
	dw $0449,$04A1,$04A2,$04A3,$04A4,$04A5,$04A6,$04A7,$0451,$0435,$04A8,$04A9,$04AA,$04AB,$04AC,$04AD,$04AE,$043D		; $87CC22 team 10
	dw $04AF,$04B0,$04B1,$04B2,$04B3,$04B4,$04B5,$04B6,$04B7,$04B8,$04B9,$04BA,$04BB,$04BC,$04BD,$04BE,$04BF,$043D		; $87CC46 team 11
	dw $0449,$04C0,$04C1,$04C2,$04C3,$04C4,$04C5,$04C6,$0451,$0435,$04C7,$04C8,$04C9,$04CA,$04CB,$04CC,$04CD,$043D		; $87CC6A team 12
	dw $0420,$043E,$04CE,$04CF,$04D0,$04D1,$04D2,$043E,$0428,$04D3,$04D4,$04D5,$04D6,$04D7,$04D8,$04D9,$04D4,$04DA		; $87CC8E team 13
	dw $04DB,$04DC,$04DD,$04DE,$04DF,$04E0,$04E1,$04E2,$04E3,$04E4,$04E5,$04E6,$04E7,$04E8,$04E9,$04EA,$04EB,$04EC		; $87CCB2 team 14
	dw $0400,$04ED,$04EE,$04EF,$04F0,$04F1,$04F2,$04F3,$0407,$0408,$04F4,$04F5,$04F6,$04F7,$04F8,$04F9,$04FA,$040F		; $87CCD6 team 15
	dw $0449,$04FB,$04FC,$04FD,$04FE,$04FF,$0500,$04FB,$0451,$0435,$043C,$0501,$0502,$0503,$0504,$0505,$043C,$043D		; $87CCFA team 16
	dw $0400,$0506,$0507,$0508,$0509,$050A,$050B,$050C,$0407,$050D,$050E,$050F,$0510,$0511,$0512,$0513,$0514,$0515		; $87CD1E team 17
	dw $0410,$0516,$0517,$0518,$0519,$051A,$051B,$051C,$0418,$04D3,$051D,$051E,$051F,$0520,$0521,$0522,$0523,$04DA		; $87CD42 team 18
	dw $0400,$0524,$0525,$0526,$0527,$0528,$0529,$052A,$0407,$052B,$052C,$052D,$052E,$052F,$0530,$0531,$0532,$0533		; $87CD66 team 19
	dw $0449,$0534,$0535,$0536,$0537,$0538,$0539,$053A,$0451,$052B,$053B,$053C,$053D,$053E,$053F,$0540,$0541,$0533		; $87CD8A team 20
	dw $0400,$0542,$0543,$0544,$0545,$0546,$0547,$0548,$0549,$0408,$054A,$054B,$054C,$054D,$054E,$054F,$0550,$0551		; $87CDAE team 21
	dw $0552,$0553,$0554,$0555,$0556,$0557,$0558,$0559,$055A,$055B,$055C,$055D,$055E,$055F,$0560,$0561,$0562,$0563		; $87CDD2 team 22
	dw $0449,$0564,$0565,$0566,$0567,$0568,$0569,$056A,$0451,$0435,$056B,$056C,$056D,$056E,$056F,$0570,$0571,$043D		; $87CDF6 team 23
	dw $0572,$0573,$0574,$0575,$0576,$0577,$0578,$0579,$0407,$057A,$057B,$057C,$057D,$057E,$057F,$0580,$0581,$0582		; $87CE1A team 24
	dw $0583,$0584,$0585,$0586,$0587,$0588,$0589,$058A,$058B,$058C,$058D,$058E,$058F,$0590,$0591,$0592,$0593,$0594		; $87CE3E team 25
DrawFrame:		;auto: CODE_87CE62 (from addframe). SNES: as DrawFrameHi (bank85_F000) for frames below $293 with 4-byte pieces (x, y signed bytes, tile, attributes); sprnodraw skips the upload; a full
		;   cache shortens sprslotlife first
	lda.b farptr+1		; $87CE62: A5 0D
	sta.b sprtileptr+1		; $87CE64: 85 10
	lda.b farptr		; $87CE66: A5 0C
	clc		; $87CE68: 18
	adc.w #$0200		; $87CE69: 69 00 02
	sta.b sprtileptr		; $87CE6C: 85 0F
	lda.b sprhflip		; $87CE6E: A5 A5
	beq .vf		; $87CE70: F0 05
	lda.w #$0040		; $87CE72: A9 40 00
	sta.b sprhflip		; $87CE75: 85 A5
.vf:
	lda.b sprvflip		; $87CE77: A5 CD
	beq .fr		; $87CE79: F0 05
	lda.w #$0080		; $87CE7B: A9 80 00
	sta.b sprvflip		; $87CE7E: 85 CD
.fr:
	lda.b sprframe		; $87CE80: A5 C3
	asl a		; $87CE82: 0A
	adc.w #$000A		; $87CE83: 69 0A 00
	tay		; $87CE86: A8
	lda.b [farptr],y		; $87CE87: B7 0C
	sta.b sprframe		; $87CE89: 85 C3
	iny		; $87CE8B: C8
	iny		; $87CE8C: C8
	lda.b [farptr],y		; $87CE8D: B7 0C
	sec		; $87CE8F: 38
	sbc.b sprframe		; $87CE90: E5 C3
	bne .cnt		; $87CE92: D0 03
	jmp.w addframe_end		; $87CE94: 4C FE D1
.cnt:
	sta.w sprpieces		; $87CE97: 8D 87 04
.piece:		;next piece; OAM full (128): done
	lda.b sprcount		; $87CE9A: A5 A9
	cmp.w #$0080		; $87CE9C: C9 80 00
	bne .pc		; $87CE9F: D0 03
	jmp.w addframe_end		; $87CEA1: 4C FE D1
.pc:
	lda.b sprframe		; $87CEA4: A5 C3
	asl a		; $87CEA6: 0A
	asl a		; $87CEA7: 0A
	ldy.w #$0006		; $87CEA8: A0 06 00
	adc.b [farptr],y		; $87CEAB: 77 0C
	tay		; $87CEAD: A8
	lda.b [farptr],y		; $87CEAE: B7 0C
	and.w #$00FF		; $87CEB0: 29 FF 00
	bit.w #$0080		; $87CEB3: 89 80 00
	beq .px		; $87CEB6: F0 03
	ora.w #$FF00		; $87CEB8: 09 00 FF
.px:
	sta.b sprox		; $87CEBB: 85 BD
	iny		; $87CEBD: C8
	lda.b [farptr],y		; $87CEBE: B7 0C
	and.w #$00FF		; $87CEC0: 29 FF 00
	bit.w #$0080		; $87CEC3: 89 80 00
	beq .py		; $87CEC6: F0 03
	ora.w #$FF00		; $87CEC8: 09 00 FF
.py:
	sta.b sproy		; $87CECB: 85 BF
	iny		; $87CECD: C8
	lda.b [farptr],y		; $87CECE: B7 0C
	and.w #$03FF		; $87CED0: 29 FF 03
	asl a		; $87CED3: 0A
	asl a		; $87CED4: 0A
	asl a		; $87CED5: 0A
	asl a		; $87CED6: 0A
	asl a		; $87CED7: 0A
	sta.b sprtile		; $87CED8: 85 B9
	iny		; $87CEDA: C8
	lda.b [farptr],y		; $87CEDB: B7 0C
	tax		; $87CEDD: AA
	lsr a		; $87CEDE: 4A
	lsr a		; $87CEDF: 4A
	clc		; $87CEE0: 18
	adc.b sprflag		; $87CEE1: 65 AB
	and.w #$0007		; $87CEE3: 29 07 00
	asl a		; $87CEE6: 0A
	sta.b sprpal		; $87CEE7: 85 AD
	cmp.w #$0004		; $87CEE9: C9 04 00
	bne .size		; $87CEEC: D0 09
	lda.b sprflag		; $87CEEE: A5 AB
	bpl .size		; $87CEF0: 10 05
	lda.w #$0006		; $87CEF2: A9 06 00
	sta.b sprpal		; $87CEF5: 85 AD
.size:
	txa		; $87CEF7: 8A
	and.w #$00C0		; $87CEF8: 29 C0 00
	sta.b sprpattr		; $87CEFB: 85 AF
	txa		; $87CEFD: 8A
	and.w #$0020		; $87CEFE: 29 20 00
	beq .small		; $87CF01: F0 03
	jmp.w .big		; $87CF03: 4C 53 D0
.small:
	lda.b sprhflip		; $87CF06: A5 A5
	beq .sx		; $87CF08: F0 08
	lda.w #$FFF9		; $87CF0A: A9 F9 FF
	sec		; $87CF0D: 38
	sbc.b sprox		; $87CF0E: E5 BD
	sta.b sprox		; $87CF10: 85 BD
.sx:
	lda.b sprx		; $87CF12: A5 C9
	clc		; $87CF14: 18
	adc.b sprox		; $87CF15: 65 BD
	sta.b sprox		; $87CF17: 85 BD
	sec		; $87CF19: 38
	sbc.w #$FFF9		; $87CF1A: E9 F9 FF
	bmi .v1		; $87CF1D: 30 05
	bvc .x2		; $87CF1F: 50 05
.off1:
	jmp.w .skip		; $87CF21: 4C F4 D1
.v1:
	bvc .off1		; $87CF24: 50 FB
.x2:
	lda.b sprox		; $87CF26: A5 BD
	sec		; $87CF28: 38
	sbc.w #$00FF		; $87CF29: E9 FF 00
	beq .sy		; $87CF2C: F0 09
	bmi .v2		; $87CF2E: 30 05
	bvs .sy		; $87CF30: 70 05
.off2:
	jmp.w .skip		; $87CF32: 4C F4 D1
.v2:
	bvs .off2		; $87CF35: 70 FB
.sy:
	lda.b sprvflip		; $87CF37: A5 CD
	beq .y1		; $87CF39: F0 08
	lda.w #$FFF9		; $87CF3B: A9 F9 FF
	sec		; $87CF3E: 38
	sbc.b sproy		; $87CF3F: E5 BF
	sta.b sproy		; $87CF41: 85 BF
.y1:
	lda.b spry		; $87CF43: A5 CB
	clc		; $87CF45: 18
	adc.b sproy		; $87CF46: 65 BF
	sta.b sproy		; $87CF48: 85 BF
	sec		; $87CF4A: 38
	sbc.w #$FFF9		; $87CF4B: E9 F9 FF
	bmi .v3		; $87CF4E: 30 05
	bvc .y2		; $87CF50: 50 05
.off3:
	jmp.w .skip		; $87CF52: 4C F4 D1
.v3:
	bvc .off3		; $87CF55: 50 FB
.y2:
	lda.b sproy		; $87CF57: A5 BF
	sec		; $87CF59: 38
	sbc.w #$00DF		; $87CF5A: E9 DF 00
	beq .cache		; $87CF5D: F0 09
	bmi .v4		; $87CF5F: 30 05
	bvs .cache		; $87CF61: 70 05
.off4:
	jmp.w .skip		; $87CF63: 4C F4 D1
.v4:
	bvs .off4		; $87CF66: 70 FB
.cache:
	lda.b sprframe		; $87CF68: A5 C3
	clc		; $87CF6A: 18
	adc.b sprsetofs		; $87CF6B: 65 C5
	cmp.w #$131D		; $87CF6D: C9 1D 13
.hang1:
	bcs .hang1		; $87CF70: B0 FE
	asl a		; $87CF72: 0A
	asl a		; $87CF73: 0A
	tax		; $87CF74: AA
	lda.b sprclock		; $87CF75: A5 A7
	sec		; $87CF77: 38
	sbc.l sprframetime,x		; $87CF78: FF 00 20 7E
	cmp.b sprslotlife		; $87CF7C: C5 C1
	bcc .have		; $87CF7E: 90 69
	lda.b sprnodraw		; $87CF80: A5 C7
	beq .find		; $87CF82: F0 03
	jmp.w addframe_end		; $87CF84: 4C FE D1
.find:
	lda.b sprslot		; $87CF87: A5 B5
	inc a		; $87CF89: 1A
	and.w #$01FF		; $87CF8A: 29 FF 01
	sta.b sprslot		; $87CF8D: 85 B5
	cmp.b sprslotend		; $87CF8F: C5 B7
	bne .chk		; $87CF91: D0 0F
	lda.b sprslotlife		; $87CF93: A5 C1
	cmp.w #$0005		; $87CF95: C9 05 00
	bcs .shorten		; $87CF98: B0 04
	jml.l $8FDAF3		; $87CF9A: 5C F3 DA 8F  bank $8F: VRAM sprite cache full
.shorten:
	dec.b sprslotlife		; $87CF9E: C6 C1
	lda.b sprslot		; $87CFA0: A5 B5
.chk:
	asl a		; $87CFA2: 0A
	tax		; $87CFA3: AA
	lda.b sprclock		; $87CFA4: A5 A7
	sec		; $87CFA6: 38
	sbc.w sprslottime,x		; $87CFA7: FD AB 04
	cmp.b sprslotlife		; $87CFAA: C5 C1
	bcc .find		; $87CFAC: 90 D9
	txa		; $87CFAE: 8A
	asl a		; $87CFAF: 0A
	asl a		; $87CFB0: 0A
	asl a		; $87CFB1: 0A
	adc.w #$6000		; $87CFB2: 69 00 60
	ldx.b DMAListend		; $87CFB5: A6 A3
.hang2:
	cpx.w #$0578		; $87CFB7: E0 78 05
	bcs .hang2		; $87CFBA: B0 FB
	sta.w DMAList+dmavram,x		; $87CFBC: 9D 58 16
	lda.b farptr+2		; $87CFBF: A5 0E
	sta.w DMAList+dmabank,x		; $87CFC1: 9D 55 16
	ldy.w #$0008		; $87CFC4: A0 08 00
	lda.b [farptr],y		; $87CFC7: B7 0C
	adc.b sprtile		; $87CFC9: 65 B9
	adc.b farptr		; $87CFCB: 65 0C
	sta.w DMAList,x		; $87CFCD: 9D 53 16
	lda.w #$0020		; $87CFD0: A9 20 00
	sta.w DMAList+dmalen,x		; $87CFD3: 9D 56 16
	txa		; $87CFD6: 8A
	adc.w #$0007		; $87CFD7: 69 07 00
	sta.b DMAListend		; $87CFDA: 85 A3
	lda.b sprframe		; $87CFDC: A5 C3
	adc.b sprsetofs		; $87CFDE: 65 C5
	asl a		; $87CFE0: 0A
	asl a		; $87CFE1: 0A
	tax		; $87CFE2: AA
	lda.b sprslot		; $87CFE3: A5 B5
	sta.l sprframetime+2,x		; $87CFE5: 9F 02 20 7E
.have:
	lda.b sprclock		; $87CFE9: A5 A7
	sta.l sprframetime,x		; $87CFEB: 9F 00 20 7E
	lda.l sprframetime+2,x		; $87CFEF: BF 02 20 7E
	sta.b sprtile		; $87CFF3: 85 B9
	asl a		; $87CFF5: 0A
	tax		; $87CFF6: AA
	lda.b sprclock		; $87CFF7: A5 A7
	sta.w sprslottime,x		; $87CFF9: 9D AB 04
	lda.b sprcount		; $87CFFC: A5 A9
	asl a		; $87CFFE: 0A
	asl a		; $87CFFF: 0A
	tax		; $87D000: AA
	lda.b sprox		; $87D001: A5 BD
	sta.w Satt,x		; $87D003: 9D FF 01
	lda.b sproy		; $87D006: A5 BF
	sta.w Satt+1,x		; $87D008: 9D 00 02
	lda.b sprtile		; $87D00B: A5 B9
	sta.w Satt+2,x		; $87D00D: 9D 01 02
	xba		; $87D010: EB
	sep #$20		; $87D011: E2 20
	ora.b sprpal		; $87D013: 05 AD
	ora.b sprpriority		; $87D015: 05 BB
	ora.b sprpattr		; $87D017: 05 AF
	eor.b sprhflip		; $87D019: 45 A5
	eor.b sprvflip		; $87D01B: 45 CD
	sta.w Satt+3,x		; $87D01D: 9D 02 02
	rep #$30		; $87D020: C2 30
	lda.b sprcount		; $87D022: A5 A9
	and.w #$0003		; $87D024: 29 03 00
	tax		; $87D027: AA
	lda.l .himask,x		; $87D028: BF 4F D0 87
	tay		; $87D02C: A8
	lda.b sprcount		; $87D02D: A5 A9
	lsr a		; $87D02F: 4A
	lsr a		; $87D030: 4A
	tax		; $87D031: AA
	sep #$20		; $87D032: E2 20
	tya		; $87D034: 98
	and.w SattHi,x		; $87D035: 3D FF 03
	sta.w SattHi,x		; $87D038: 9D FF 03
	lda.b sprox+1		; $87D03B: A5 BE
	bpl .next		; $87D03D: 10 09
	tya		; $87D03F: 98
	eor.b #$FF		; $87D040: 49 FF
	ora.w SattHi,x		; $87D042: 1D FF 03
	sta.w SattHi,x		; $87D045: 9D FF 03
.next:
	rep #$30		; $87D048: C2 30
	inc.b sprcount		; $87D04A: E6 A9
	jmp.w .skip		; $87D04C: 4C F4 D1
.himask:		;SattHi masks that clear the x bit 8 of sprite 0-3 in a byte
	db $FE,$FB,$EF,$BF		; $87D04F
.big:
	lda.b sprhflip		; $87D053: A5 A5
	beq .bx		; $87D055: F0 08
	lda.w #$FFF1		; $87D057: A9 F1 FF
	sec		; $87D05A: 38
	sbc.b sprox		; $87D05B: E5 BD
	sta.b sprox		; $87D05D: 85 BD
.bx:
	lda.b sprx		; $87D05F: A5 C9
	clc		; $87D061: 18
	adc.b sprox		; $87D062: 65 BD
	sta.b sprox		; $87D064: 85 BD
	sec		; $87D066: 38
	sbc.w #$FFF1		; $87D067: E9 F1 FF
	bmi .bv1		; $87D06A: 30 05
	bvc .bx2		; $87D06C: 50 05
.boff1:
	jmp.w .skip		; $87D06E: 4C F4 D1
.bv1:
	bvc .boff1		; $87D071: 50 FB
.bx2:
	lda.b sprox		; $87D073: A5 BD
	sec		; $87D075: 38
	sbc.w #$00FF		; $87D076: E9 FF 00
	beq .by		; $87D079: F0 09
	bmi .bv2		; $87D07B: 30 05
	bvs .by		; $87D07D: 70 05
.boff2:
	jmp.w .skip		; $87D07F: 4C F4 D1
.bv2:
	bvs .boff2		; $87D082: 70 FB
.by:
	lda.b sprvflip		; $87D084: A5 CD
	beq .by1		; $87D086: F0 08
	lda.w #$FFF1		; $87D088: A9 F1 FF
	sec		; $87D08B: 38
	sbc.b sproy		; $87D08C: E5 BF
	sta.b sproy		; $87D08E: 85 BF
.by1:
	lda.b spry		; $87D090: A5 CB
	clc		; $87D092: 18
	adc.b sproy		; $87D093: 65 BF
	sta.b sproy		; $87D095: 85 BF
	sec		; $87D097: 38
	sbc.w #$FFF1		; $87D098: E9 F1 FF
	bmi .bv3		; $87D09B: 30 05
	bvc .by2		; $87D09D: 50 05
.boff3:
	jmp.w .skip		; $87D09F: 4C F4 D1
.bv3:
	bvc .boff3		; $87D0A2: 50 FB
.by2:
	lda.b sproy		; $87D0A4: A5 BF
	sec		; $87D0A6: 38
	sbc.w #$00DF		; $87D0A7: E9 DF 00
	beq .bcache		; $87D0AA: F0 09
	bmi .bv4		; $87D0AC: 30 05
	bvs .bcache		; $87D0AE: 70 05
.boff4:
	jmp.w .skip		; $87D0B0: 4C F4 D1
.bv4:
	bvs .boff4		; $87D0B3: 70 FB
.bcache:
	lda.b sprframe		; $87D0B5: A5 C3
	clc		; $87D0B7: 18
	adc.b sprsetofs		; $87D0B8: 65 C5
	cmp.w #$131D		; $87D0BA: C9 1D 13
.hang3:
	bcs .hang3		; $87D0BD: B0 FE
	asl a		; $87D0BF: 0A
	asl a		; $87D0C0: 0A
	tax		; $87D0C1: AA
	lda.b sprclock		; $87D0C2: A5 A7
	sec		; $87D0C4: 38
	sbc.l sprframetime,x		; $87D0C5: FF 00 20 7E
	cmp.b sprslotlife		; $87D0C9: C5 C1
	bcs .bfind		; $87D0CB: B0 03
	jmp.w .bhave		; $87D0CD: 4C 7E D1
.bfind:
	lda.b sprnodraw		; $87D0D0: A5 C7
	beq .bfind2		; $87D0D2: F0 03
	jmp.w addframe_end		; $87D0D4: 4C FE D1
.bfind2:
	lda.b sprbigslot		; $87D0D7: A5 B1
	inc a		; $87D0D9: 1A
	and.w #$01FF		; $87D0DA: 29 FF 01
	sta.b sprbigslot		; $87D0DD: 85 B1
	cmp.b sprbigslotend		; $87D0DF: C5 B3
	bne .bchk		; $87D0E1: D0 0F
	lda.b sprslotlife		; $87D0E3: A5 C1
	cmp.w #$0005		; $87D0E5: C9 05 00
	bcs .bshorten		; $87D0E8: B0 04
	jml.l $8FDAF3		; $87D0EA: 5C F3 DA 8F  bank $8F: VRAM sprite cache full
.bshorten:
	dec.b sprslotlife		; $87D0EE: C6 C1
	lda.b sprbigslot		; $87D0F0: A5 B1
.bchk:
	and.w #$000F		; $87D0F2: 29 0F 00
	cmp.w #$000F		; $87D0F5: C9 0F 00
	beq .bfind2		; $87D0F8: F0 DD
	lda.b sprbigslot		; $87D0FA: A5 B1
	and.w #$00F0		; $87D0FC: 29 F0 00
	cmp.w #$00F0		; $87D0FF: C9 F0 00
	beq .bfind2		; $87D102: F0 D3
	lda.b sprbigslot		; $87D104: A5 B1
	asl a		; $87D106: 0A
	tax		; $87D107: AA
	lda.b sprclock		; $87D108: A5 A7
	sec		; $87D10A: 38
	sbc.w sprslottime,x		; $87D10B: FD AB 04
	cmp.b sprslotlife		; $87D10E: C5 C1
	bcc .bfind2		; $87D110: 90 C5
	lda.b sprclock		; $87D112: A5 A7
	sec		; $87D114: 38
	sbc.w sprslottime+2,x		; $87D115: FD AD 04
	cmp.b sprslotlife		; $87D118: C5 C1
	bcc .bfind2		; $87D11A: 90 BB
	lda.b sprclock		; $87D11C: A5 A7
	sec		; $87D11E: 38
	sbc.w sprslottime+$20,x		; $87D11F: FD CB 04
	cmp.b sprslotlife		; $87D122: C5 C1
	bcc .bfind2		; $87D124: 90 B1
	lda.b sprclock		; $87D126: A5 A7
	sec		; $87D128: 38
	sbc.w sprslottime+$22,x		; $87D129: FD CD 04
	cmp.b sprslotlife		; $87D12C: C5 C1
	bcc .bfind2		; $87D12E: 90 A7
	txa		; $87D130: 8A
	asl a		; $87D131: 0A
	asl a		; $87D132: 0A
	asl a		; $87D133: 0A
	adc.w #$6000		; $87D134: 69 00 60
	ldx.b DMAListend		; $87D137: A6 A3
.bhang:
	cpx.w #$0571		; $87D139: E0 71 05
	bcs .bhang		; $87D13C: B0 FB
	sta.w DMAList+dmavram,x		; $87D13E: 9D 58 16
	adc.w #$0100		; $87D141: 69 00 01
	sta.w DMAList+dmasize+dmavram,x		; $87D144: 9D 5F 16
	lda.b farptr+2		; $87D147: A5 0E
	sta.w DMAList+dmabank,x		; $87D149: 9D 55 16
	sta.w DMAList+dmasize+dmabank,x		; $87D14C: 9D 5C 16
	lda.w #$0040		; $87D14F: A9 40 00
	sta.w DMAList+dmalen,x		; $87D152: 9D 56 16
	sta.w DMAList+dmasize+dmalen,x		; $87D155: 9D 5D 16
	ldy.w #$0008		; $87D158: A0 08 00
	lda.b [farptr],y		; $87D15B: B7 0C
	adc.b sprtile		; $87D15D: 65 B9
	adc.b farptr		; $87D15F: 65 0C
	sta.w DMAList,x		; $87D161: 9D 53 16
	adc.w #$0200		; $87D164: 69 00 02
	sta.w DMAList+dmasize+dmasrc,x		; $87D167: 9D 5A 16
	txa		; $87D16A: 8A
	adc.w #$000E		; $87D16B: 69 0E 00
	sta.b DMAListend		; $87D16E: 85 A3
	lda.b sprframe		; $87D170: A5 C3
	clc		; $87D172: 18
	adc.b sprsetofs		; $87D173: 65 C5
	asl a		; $87D175: 0A
	asl a		; $87D176: 0A
	tax		; $87D177: AA
	lda.b sprbigslot		; $87D178: A5 B1
	sta.l sprframetime+2,x		; $87D17A: 9F 02 20 7E
.bhave:
	lda.b sprclock		; $87D17E: A5 A7
	sta.l sprframetime,x		; $87D180: 9F 00 20 7E
	lda.l sprframetime+2,x		; $87D184: BF 02 20 7E
	sta.b sprtile		; $87D188: 85 B9
	asl a		; $87D18A: 0A
	tax		; $87D18B: AA
	lda.b sprclock		; $87D18C: A5 A7
	sta.w sprslottime,x		; $87D18E: 9D AB 04
	sta.w sprslottime+2,x		; $87D191: 9D AD 04
	sta.w sprslottime+$20,x		; $87D194: 9D CB 04
	sta.w sprslottime+$22,x		; $87D197: 9D CD 04
	lda.b sprcount		; $87D19A: A5 A9
	asl a		; $87D19C: 0A
	asl a		; $87D19D: 0A
	tax		; $87D19E: AA
	lda.b sprox		; $87D19F: A5 BD
	sta.w Satt,x		; $87D1A1: 9D FF 01
	lda.b sproy		; $87D1A4: A5 BF
	sta.w Satt+1,x		; $87D1A6: 9D 00 02
	lda.b sprtile		; $87D1A9: A5 B9
	sta.w Satt+2,x		; $87D1AB: 9D 01 02
	xba		; $87D1AE: EB
	sep #$20		; $87D1AF: E2 20
	ora.b sprpal		; $87D1B1: 05 AD
	ora.b sprpriority		; $87D1B3: 05 BB
	ora.b sprpattr		; $87D1B5: 05 AF
	eor.b sprhflip		; $87D1B7: 45 A5
	eor.b sprvflip		; $87D1B9: 45 CD
	sta.w Satt+3,x		; $87D1BB: 9D 02 02
	rep #$30		; $87D1BE: C2 30
	lda.b sprcount		; $87D1C0: A5 A9
	and.w #$0003		; $87D1C2: 29 03 00
	tax		; $87D1C5: AA
	lda.l .himask,x		; $87D1C6: BF 4F D0 87
	tay		; $87D1CA: A8
	lda.b sprcount		; $87D1CB: A5 A9
	lsr a		; $87D1CD: 4A
	lsr a		; $87D1CE: 4A
	tax		; $87D1CF: AA
	sep #$20		; $87D1D0: E2 20
	tya		; $87D1D2: 98
	and.w SattHi,x		; $87D1D3: 3D FF 03
	sta.w SattHi,x		; $87D1D6: 9D FF 03
	tya		; $87D1D9: 98
	eor.b #$FF		; $87D1DA: 49 FF
	asl a		; $87D1DC: 0A
	ora.w SattHi,x		; $87D1DD: 1D FF 03
	sta.w SattHi,x		; $87D1E0: 9D FF 03
	lda.b sprox+1		; $87D1E3: A5 BE
	bpl .bnext		; $87D1E5: 10 09
	tya		; $87D1E7: 98
	eor.b #$FF		; $87D1E8: 49 FF
	ora.w SattHi,x		; $87D1EA: 1D FF 03
	sta.w SattHi,x		; $87D1ED: 9D FF 03
.bnext:
	rep #$30		; $87D1F0: C2 30
	inc.b sprcount		; $87D1F2: E6 A9
.skip:
	inc.b sprframe		; $87D1F4: E6 C3
	dec.w sprpieces		; $87D1F6: CE 87 04
	beq addframe_end		; $87D1F9: F0 03
	jmp.w .piece		; $87D1FB: 4C 9A CE
addframe_end:		;auto: CODE_87D1FE. SNES addframe end: clear sprhflip, sprvflip, sprflag
	stz.b sprhflip		; $87D1FE: 64 A5
	stz.b sprvflip		; $87D200: 64 CD
	stz.b sprflag		; $87D202: 64 AB
	rtl		; $87D204: 6B
