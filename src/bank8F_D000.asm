; $8FD005-$8FE009  ROM $7D005-$7E009: the last SpriteSet1 tiles, fightinput, holdcheck, PrintStringFromList, Framer, assnothing, GoalieCount,
; AdvanceStringPtr, the attribute menu tables, releasepl, assstanley, RemovePlayerFromList, asscenterd, loadTeamStruct, ScoutingReport,
; ScoutLabels, PuckcSpots. Ends before SetupTeamForIntermission (boundary moved from $8FE00D).
org $8FD005
	incbin "../data/Sprites/set01.chr":$3B0C..$4000		; $8FD005-$8FD4F8
SpriteSet1End:
	assert SpriteSet1End-SpriteSet1 == $474+512*32
fightinput:		;auto: CODE_8FD4F9 (from joyplayer). 93G fightinput: pad input in a fight: dpad moves (playeracc), stay near the fight spot (xc1), B/A/Y punch (SPA $F82/$F50/$F0C)
	lda.w temp3,x		; $8FD4F9: BD 9F 0C
	ora.w Pencntdwn		; $8FD4FC: 0D E0 12
	bpl .l1		; $8FD4FF: 10 03
	jmp.w .l10		; $8FD501: 4C BE D5
.l1:
	lda.w SPA,x		; $8FD504: BD FF 0D
	cmp.w #$0EDA		; $8FD507: C9 DA 0E
	bne .l2		; $8FD50A: D0 03
	jmp.w .l10		; $8FD50C: 4C BE D5
.l2:
	lda.b d1		; $8FD50F: A5 57
	pha		; $8FD511: 48
	lda.b d0		; $8FD512: A5 53
	sta.b d2		; $8FD514: 85 5B
	bit.w #$0008		; $8FD516: 89 08 00
	bne .l3		; $8FD519: D0 09
	and.w #$0007		; $8FD51B: 29 07 00
	sta.b d2		; $8FD51E: 85 5B
	jsl.l $8FE164		; $8FD520: 22 64 E1 8F  bank8F_E000: 93G playeracc
.l3:
	lda.w xc1		; $8FD524: AD F5 08
	clc		; $8FD527: 18
	adc.w #$000C		; $8FD528: 69 0C 00
	sta.b d0		; $8FD52B: 85 53
	lda.w facedir,x		; $8FD52D: BD BF 0D
	cmp.w #$0002		; $8FD530: C9 02 00
	bne .l4		; $8FD533: D0 08
	lda.b d0		; $8FD535: A5 53
	sec		; $8FD537: 38
	sbc.w #$0018		; $8FD538: E9 18 00
	sta.b d0		; $8FD53B: 85 53
.l4:
	lda.b d0		; $8FD53D: A5 53
	sec		; $8FD53F: 38
	sbc.w Xpos,x		; $8FD540: FD FF 08
	sta.b d0		; $8FD543: 85 53
	lda.w Xvel,x		; $8FD545: BD DF 0A
	eor.b d0		; $8FD548: 45 53
	sta.b d1		; $8FD54A: 85 57
	bpl .l6		; $8FD54C: 10 2E
	lda.b d0		; $8FD54E: A5 53
	bit.w #$8000		; $8FD550: 89 00 80
	beq .l5		; $8FD553: F0 04
	eor.w #$FFFF		; $8FD555: 49 FF FF
	inc a		; $8FD558: 1A
.l5:
	sta.b d0		; $8FD559: 85 53
	lda.w Xvel,x		; $8FD55B: BD DF 0A
	sta.b mula		; $8FD55E: 85 7D
	lda.b d0		; $8FD560: A5 53
	sta.b mulb		; $8FD562: 85 83
	jsl.l muls32		; $8FD564: 22 DB FC 82
	lda.w #$0006		; $8FD568: A9 06 00
	sta.b mula		; $8FD56B: 85 7D
	jsl.l divs		; $8FD56D: 22 6C 99 80
	sta.b d0		; $8FD571: 85 53
	lda.w Xvel,x		; $8FD573: BD DF 0A
	sec		; $8FD576: 38
	sbc.b d0		; $8FD577: E5 53
	sta.w Xvel,x		; $8FD579: 9D DF 0A
.l6:
	pla		; $8FD57C: 68
	sta.b d1		; $8FD57D: 85 57
	lda.w pf2aip,x		; $8FD57F: BD DF 11
	bne .l10		; $8FD582: D0 3A
	lda.b d1		; $8FD584: A5 57
	sta.b d2		; $8FD586: 85 5B
	lda.w #$0F50		; $8FD588: A9 50 0F
	sta.b d1		; $8FD58B: 85 57
	sta.w pf2aip,x		; $8FD58D: 9D DF 11
	lda.b d2		; $8FD590: A5 5B
	bit.w #$0080		; $8FD592: 89 80 00
	beq .l7		; $8FD595: F0 04
	jml.l SetSPA		; $8FD597: 5C 06 B0 80
.l7:
	lda.w #$0F82		; $8FD59B: A9 82 0F
	sta.b d1		; $8FD59E: 85 57
	lda.b d2		; $8FD5A0: A5 5B
	bit.w #$8000		; $8FD5A2: 89 00 80
	beq .l8		; $8FD5A5: F0 04
	jml.l SetSPA		; $8FD5A7: 5C 06 B0 80
.l8:
	lda.w #$0F0C		; $8FD5AB: A9 0C 0F
	sta.b d1		; $8FD5AE: 85 57
	lda.b d2		; $8FD5B0: A5 5B
	bit.w #$4000		; $8FD5B2: 89 00 40
	beq .l9		; $8FD5B5: F0 04
	jml.l SetSPA		; $8FD5B7: 5C 06 B0 80
.l9:
	stz.w pf2aip,x		; $8FD5BB: 9E DF 11
.l10:
	rtl		; $8FD5BE: 6B
holdcheck:		;auto: CODE_8FD5BF (from checkcheck). 93G holdcheck: player X holds a2 (SPAHold/SPAhook), both slow to the average speed; checkagr may call a holding/hooking penalty
	lda.w pfalock,x		; $8FD5BF: BD 7F 11
	ora.w pf2fight,x		; $8FD5C2: 1D 5F 11
	beq .l1		; $8FD5C5: F0 03
	jmp.w .l8		; $8FD5C7: 4C 8B D6
.l1:
	lda.w position,x		; $8FD5CA: BD 9F 0B
	bne .l2		; $8FD5CD: D0 03
	jmp.w .l8		; $8FD5CF: 4C 8B D6
.l2:
	ldy.b a2		; $8FD5D2: A4 3B
	lda.w Xpos,x		; $8FD5D4: BD FF 08
	sec		; $8FD5D7: 38
	sbc.w Xpos,y		; $8FD5D8: F9 FF 08
	sta.b d0		; $8FD5DB: 85 53
	lda.w Ypos,x		; $8FD5DD: BD 5F 09
	sec		; $8FD5E0: 38
	sbc.w Ypos,y		; $8FD5E1: F9 5F 09
	sta.b d1		; $8FD5E4: 85 57
	jsl.l vtoa		; $8FD5E6: 22 A8 AF 80
	ldy.b a2		; $8FD5EA: A4 3B
	lda.b d0		; $8FD5EC: A5 53
	sec		; $8FD5EE: 38
	sbc.w facedir,y		; $8FD5EF: F9 BF 0D
	inc a		; $8FD5F2: 1A
	and.w #$0007		; $8FD5F3: 29 07 00
	cmp.w #$0003		; $8FD5F6: C9 03 00
	bcc .l3		; $8FD5F9: 90 03
	jmp.w .l8		; $8FD5FB: 4C 8B D6
.l3:
	lda.w puckc		; $8FD5FE: AD BB 0E
	asl a		; $8FD601: 0A
	cmp.b a3		; $8FD602: C5 3F
	bne .l4		; $8FD604: D0 06
	lda.w #$0008		; $8FD606: A9 08 00
	trb.w sflags		; $8FD609: 1C 8C 12
.l4:
	ldy.b a2		; $8FD60C: A4 3B
	lda.w Xvel,x		; $8FD60E: BD DF 0A
	clc		; $8FD611: 18
	adc.w Xvel,y		; $8FD612: 79 DF 0A
	pha		; $8FD615: 48
	asl a		; $8FD616: 0A
	pla		; $8FD617: 68
	ror a		; $8FD618: 6A
	sta.w Xvel,x		; $8FD619: 9D DF 0A
	sta.w Xvel,y		; $8FD61C: 99 DF 0A
	lda.w Yvel,x		; $8FD61F: BD FF 0A
	clc		; $8FD622: 18
	adc.w Yvel,y		; $8FD623: 79 FF 0A
	pha		; $8FD626: 48
	asl a		; $8FD627: 0A
	pla		; $8FD628: 68
	ror a		; $8FD629: 6A
	sta.w Yvel,x		; $8FD62A: 9D FF 0A
	sta.w Yvel,y		; $8FD62D: 99 FF 0A
	lda.w #$0C60		; $8FD630: A9 60 0C
	sta.b d1		; $8FD633: 85 57
	sta.w pfalock,x		; $8FD635: 9D 7F 11
	jsl.l SetSPA		; $8FD638: 22 06 B0 80
	ldx.b a2		; $8FD63C: A6 3B
	ldy.b a3		; $8FD63E: A4 3F
	stx.b a3		; $8FD640: 86 3F
	sty.b a2		; $8FD642: 84 3B
	lda.w #$0C2E		; $8FD644: A9 2E 0C
	sta.b d1		; $8FD647: 85 57
	sta.w pfalock,x		; $8FD649: 9D 7F 11
	lda.w SPA,x		; $8FD64C: BD FF 0D
	cmp.w #$0BFC		; $8FD64F: C9 FC 0B
	beq .l5		; $8FD652: F0 05
	lda.w #$1386		; $8FD654: A9 86 13
	sta.b d1		; $8FD657: 85 57
.l5:
	jsl.l SetSPA		; $8FD659: 22 06 B0 80
	jsl.l $8FE369		; $8FD65D: 22 69 E3 8F  bank8F_E000: 93G checkagr
	lda.b d0		; $8FD661: A5 53
	cmp.w #$0007		; $8FD663: C9 07 00
	bcs .l7		; $8FD666: B0 16
	lda.w #$0024		; $8FD668: A9 24 00
	sta.b d0		; $8FD66B: 85 53
	lda.w SPA,x		; $8FD66D: BD FF 0D
	cmp.w #$0C2E		; $8FD670: C9 2E 0C
	beq .l6		; $8FD673: F0 05
	lda.w #$001E		; $8FD675: A9 1E 00
	sta.b d0		; $8FD678: 85 53
.l6:
	jsl.l AddPenalty		; $8FD67A: 22 8F C1 80
.l7:
	ldx.b a2		; $8FD67E: A6 3B
	ldy.b a3		; $8FD680: A4 3F
	stx.b a3		; $8FD682: 86 3F
	sty.b a2		; $8FD684: 84 3B
	lda.w #$FFFF		; $8FD686: A9 FF FF
	sta.b collflag		; $8FD689: 85 D8
.l8:
	rtl		; $8FD68B: 6B
PrintStringFromList:		;auto: CODE_8FD68C. 93G PrintStringFromList: print string d0 of the list [a1]
	lda.b d0		; $8FD68C: A5 53
	bne .l1		; $8FD68E: D0 04
	jml.l print		; $8FD690: 5C 2D B9 80
.l1:
	lda.b [a1]		; $8FD694: A7 37
	clc		; $8FD696: 18
	adc.b a1		; $8FD697: 65 37
	sta.b a1		; $8FD699: 85 37
	dec.b d0		; $8FD69B: C6 53
	bra PrintStringFromList		; $8FD69D: 80 ED
Framer:		;auto: CODE_8FD69F. 93G Framer: a d0 x d1 box of FramerMap pieces at printx/printy
	phx		; $8FD69F: DA
	lda.w printx		; $8FD6A0: AD 7B 04
	sta.b tmp0		; $8FD6A3: 85 73
	lda.b d0		; $8FD6A5: A5 53
	sta.b tmp2		; $8FD6A7: 85 77
	ldx.w #$0000		; $8FD6A9: A2 00 00
	jsl.l .piece		; $8FD6AC: 22 24 D7 8F
	dec.b tmp2		; $8FD6B0: C6 77
	dec.b tmp2		; $8FD6B2: C6 77
.l1:
	ldx.w #$0002		; $8FD6B4: A2 02 00
	jsl.l .piece		; $8FD6B7: 22 24 D7 8F
	dec.b tmp2		; $8FD6BB: C6 77
	bne .l1		; $8FD6BD: D0 F5
	ldx.w #$0004		; $8FD6BF: A2 04 00
	jsl.l .piece		; $8FD6C2: 22 24 D7 8F
	dec.b d1		; $8FD6C6: C6 57
	dec.b d1		; $8FD6C8: C6 57
.l2:
	lda.b tmp0		; $8FD6CA: A5 73
	sta.w printx		; $8FD6CC: 8D 7B 04
	inc.w printy		; $8FD6CF: EE 7D 04
	lda.b d0		; $8FD6D2: A5 53
	dec a		; $8FD6D4: 3A
	dec a		; $8FD6D5: 3A
	sta.b tmp2		; $8FD6D6: 85 77
	ldx.w #$0006		; $8FD6D8: A2 06 00
	jsl.l .piece		; $8FD6DB: 22 24 D7 8F
.l3:
	ldx.w #$0008		; $8FD6DF: A2 08 00
	jsl.l .piece		; $8FD6E2: 22 24 D7 8F
	dec.b tmp2		; $8FD6E6: C6 77
	bne .l3		; $8FD6E8: D0 F5
	ldx.w #$000A		; $8FD6EA: A2 0A 00
	jsl.l .piece		; $8FD6ED: 22 24 D7 8F
	dec.b d1		; $8FD6F1: C6 57
	bne .l2		; $8FD6F3: D0 D5
	lda.b tmp0		; $8FD6F5: A5 73
	sta.w printx		; $8FD6F7: 8D 7B 04
	inc.w printy		; $8FD6FA: EE 7D 04
	dec.b d0		; $8FD6FD: C6 53
	dec.b d0		; $8FD6FF: C6 53
	ldx.w #$000C		; $8FD701: A2 0C 00
	jsl.l .piece		; $8FD704: 22 24 D7 8F
.l4:
	ldx.w #$000E		; $8FD708: A2 0E 00
	jsl.l .piece		; $8FD70B: 22 24 D7 8F
	dec.b d0		; $8FD70F: C6 53
	bne .l4		; $8FD711: D0 F5
	ldx.w #$0010		; $8FD713: A2 10 00
	jsl.l .piece		; $8FD716: 22 24 D7 8F
	lda.b tmp0		; $8FD71A: A5 73
	sta.w printx		; $8FD71C: 8D 7B 04
	inc.w printy		; $8FD71F: EE 7D 04
	plx		; $8FD722: FA
	rtl		; $8FD723: 6B
.piece:		;one FramerMap piece (X = piece * 2) at printx/printy, printx + 1
	lda.l FramerMap,x		; $8FD724: BF 1C 87 88
	clc		; $8FD728: 18
	adc.w Framercset		; $8FD729: 6D DB 1B
	clc		; $8FD72C: 18
	adc.w printfontset		; $8FD72D: 6D CB 1B
	pha		; $8FD730: 48
	lda.w printy		; $8FD731: AD 7D 04
	asl a		; $8FD734: 0A
	asl a		; $8FD735: 0A
	asl a		; $8FD736: 0A
	asl a		; $8FD737: 0A
	asl a		; $8FD738: 0A
	adc.w printx		; $8FD739: 6D 7B 04
	asl a		; $8FD73C: 0A
	adc.b printm		; $8FD73D: 65 D4
	tax		; $8FD73F: AA
	pla		; $8FD740: 68
	ora.w printa		; $8FD741: 0D 77 04
	sta.l textmap,x		; $8FD744: 9F 74 6E 7E
	inc.w printx		; $8FD748: EE 7B 04
	txa		; $8FD74B: 8A
	lsr a		; $8FD74C: 4A
	cmp.b textdirtylo		; $8FD74D: C5 D0
	bcs .l5		; $8FD74F: B0 02
	sta.b textdirtylo		; $8FD751: 85 D0
.l5:
	cmp.b textdirtyhi		; $8FD753: C5 D2
	bcc .l6		; $8FD755: 90 02
	sta.b textdirtyhi		; $8FD757: 85 D2
.l6:
	rtl		; $8FD759: 6B
assnothing:		;auto: CODE_8FD75A. 93G assnothing: a computer player stands (doplayeracc 8)
	lda.w pflags,x		; $8FD75A: BD DF 0E
	bit.w #$0008		; $8FD75D: 89 08 00
	bne .l1		; $8FD760: D0 08
	lda.w #$0008		; $8FD762: A9 08 00
	sta.b d0		; $8FD765: 85 53
	jmp.w $FBDC		; $8FD767: 4C DC FB  bank8F_F000: 93G doplayeracc
.l1:
	rtl		; $8FD76A: 6B
GoalieCount:		;auto: CODE_8FD76B. SNES: d0 = goalies of team a2 (nibbles of its goalie weights word, team record +$A, until 0); hangs if a2 is not 0 or 2
	lda.b a2		; $8FD76B: A5 3B
	tay		; $8FD76D: A8
	and.w #$FFFD		; $8FD76E: 29 FD FF
.l1:
	bne .l1		; $8FD771: D0 FE
	lda.w #$0083		; $8FD773: A9 83 00
	sta.b tmp1		; $8FD776: 85 75
	lda.w tmdata,y		; $8FD778: B9 CE 13
	sta.b tmp0		; $8FD77B: 85 73
	ldy.w #$000A		; $8FD77D: A0 0A 00
	clc		; $8FD780: 18
	adc.b [tmp0],y		; $8FD781: 77 73
	sta.b tmp0		; $8FD783: 85 73
	stz.b d0		; $8FD785: 64 53
	lda.b [tmp0]		; $8FD787: A7 73
	xba		; $8FD789: EB
.l2:
	inc.b d0		; $8FD78A: E6 53
	asl a		; $8FD78C: 0A
	asl a		; $8FD78D: 0A
	asl a		; $8FD78E: 0A
	asl a		; $8FD78F: 0A
	bne .l2		; $8FD790: D0 F8
	rtl		; $8FD792: 6B
AdvanceStringPtr:		;auto: CODE_8FD793. 93G AdvanceStringPtr: a1 = string d0 of the list [a1]
	bra .l2		; $8FD793: 80 07
.l1:
	lda.b a1		; $8FD795: A5 37
	clc		; $8FD797: 18
	adc.b [a1]		; $8FD798: 67 37
	sta.b a1		; $8FD79A: 85 37
.l2:
	dec.b d0		; $8FD79C: C6 53
	bpl .l1		; $8FD79E: 10 F5
	rtl		; $8FD7A0: 6B
AttribMenuSkater:		;SNES: player attribute menu (DisplayPlayerAttributeMenu): 15-byte item strings, the rating bit mask and column, $FFFF ends
	dw 15		; $8FD7A1
	db "   Status   ]"
	dw $0000,$0000		; $8FD7B0 bit mask, rating column
	dw 15		; $8FD7B4
	db "[  Overall  ]"
	dw $1F3A,$000A		; $8FD7C3 bit mask, rating column
	dw 15		; $8FD7C7
	db "[  Energy   ]"
	dw $0000,$0002		; $8FD7D6 bit mask, rating column
	dw 15		; $8FD7DA
	db "[  Agility  ]"
	dw $1000,$000A		; $8FD7E9 bit mask, rating column
	dw 15		; $8FD7ED
	db "[   Speed   ]"
	dw $0800,$000A		; $8FD7FC bit mask, rating column
	dw 15		; $8FD800
	db "[  Handed   ]"
	dw $0040,$0004		; $8FD80F bit mask, rating column
	dw 15		; $8FD813
	db "[Off. Aware.]"
	dw $0400,$000A		; $8FD822 bit mask, rating column
	dw 15		; $8FD826
	db "[Def. Aware.]"
	dw $0200,$000A		; $8FD835 bit mask, rating column
	dw 15		; $8FD839
	db "[Shot Power ]"
	dw $0100,$000A		; $8FD848 bit mask, rating column
	dw 15		; $8FD84C
	db "[Shot  Accur]"
	dw $0010,$000A		; $8FD85B bit mask, rating column
	dw 15		; $8FD85F
	db "[Pass  Accur]"
	dw $0002,$000A		; $8FD86E bit mask, rating column
	dw 15		; $8FD872
	db "[Stick Handl]"
	dw $0020,$000A		; $8FD881 bit mask, rating column
	dw 15		; $8FD885
	db "[  Weight   ]"
	dw $2000,$0006		; $8FD894 bit mask, rating column
	dw 15		; $8FD898
	db "[ Endurance ]"
	dw $0008,$000A		; $8FD8A7 bit mask, rating column
	dw 15		; $8FD8AB
	db "[Aggression ]"
	dw $0001,$000A		; $8FD8BA bit mask, rating column
	dw 15		; $8FD8BE
	db "[ Checking  ]"
	dw $0080,$000A		; $8FD8CD bit mask, rating column
	dw 15		; $8FD8D1
	db "[  Fighting  "
	dw $0040,$0008		; $8FD8E0 bit mask, rating column
	dw $FFFF		; $8FD8E4 end
AttribMenuGoalie:		;SNES: goalie attribute menu
	dw 15		; $8FD8E6
	db "   Status   ]"
	dw $0000,$0000		; $8FD8F5 bit mask, rating column
	dw 15		; $8FD8F9
	db "[  Overall  ]"
	dw $1B0F,$000A		; $8FD908 bit mask, rating column
	dw 15		; $8FD90C
	db "[  Agility  ]"
	dw $1000,$000A		; $8FD91B bit mask, rating column
	dw 15		; $8FD91F
	db "[   Speed   ]"
	dw $0800,$000A		; $8FD92E bit mask, rating column
	dw 15		; $8FD932
	db "[Glove Hand ]"
	dw $0040,$0004		; $8FD941 bit mask, rating column
	dw 15		; $8FD945
	db "[Def. Aware.]"
	dw $0200,$000A		; $8FD954 bit mask, rating column
	dw 15		; $8FD958
	db "[Puck Cont. ]"
	dw $0100,$000A		; $8FD967 bit mask, rating column
	dw 15		; $8FD96B
	db "[Stick Right]"
	dw $0008,$000A		; $8FD97A bit mask, rating column
	dw 15		; $8FD97E
	db "[Stick Left ]"
	dw $0004,$000A		; $8FD98D bit mask, rating column
	dw 15		; $8FD991
	db "[Glove Right]"
	dw $0002,$000A		; $8FD9A0 bit mask, rating column
	dw 15		; $8FD9A4
	db "[Glove Left ]"
	dw $0001,$000A		; $8FD9B3 bit mask, rating column
	dw 15		; $8FD9B7
	db "[   Weight   "
	dw $2000,$0006		; $8FD9C6 bit mask, rating column
	dw $FFFF		; $8FD9CA end
PositionNames:		;SNES: position names LD, RD, LW, C, RW
	dw 4		; $8FD9CC
	db "LD"
	dw 4		; $8FD9D0
	db "RD"
	dw 4		; $8FD9D4
	db "LW"
	dw 3		; $8FD9D8
	db "C"
	dw 4		; $8FD9DB
	db "RW"
releasepl:		;auto: CODE_8FD9DF. 93G releasepl (penalty93_1): player d0 leaves the penalty box: the next free object of team a2 comes on (tmap+1, priolist position), setplayer
	stx.b xsave		; $8FD9DF: 86 0A
	ldx.w #$0000		; $8FD9E1: A2 00 00
.l1:
	lda.b d0,x		; $8FD9E4: B5 53
	pha		; $8FD9E6: 48
	inx		; $8FD9E7: E8
	inx		; $8FD9E8: E8
	cpx.w #$0010		; $8FD9E9: E0 10 00
	bne .l1		; $8FD9EC: D0 F6
	ldx.b xsave		; $8FD9EE: A6 0A
	stx.b xsave		; $8FD9F0: 86 0A
	ldx.w #$0000		; $8FD9F2: A2 00 00
.l2:
	lda.b a0,x		; $8FD9F5: B5 33
	pha		; $8FD9F7: 48
	inx		; $8FD9F8: E8
	inx		; $8FD9F9: E8
	cpx.w #$0010		; $8FD9FA: E0 10 00
	bne .l2		; $8FD9FD: D0 F6
	ldx.b xsave		; $8FD9FF: A6 0A
	ldy.b a2		; $8FDA01: A4 3B
	ldx.w tmsort,y		; $8FDA03: BE D2 13
	dex		; $8FDA06: CA
	dex		; $8FDA07: CA
.l3:
	inx		; $8FDA08: E8
	inx		; $8FDA09: E8
	lda.w position,x		; $8FDA0A: BD 9F 0B
	bpl .l3		; $8FDA0D: 10 F9
	lda.b d0		; $8FDA0F: A5 53
	lsr a		; $8FDA11: 4A
	sta.b d3		; $8FDA12: 85 5F
	ldy.b a2		; $8FDA14: A4 3B
	lda.w tmap,y		; $8FDA16: B9 EE 13
	sta.b d1		; $8FDA19: 85 57
	inc a		; $8FDA1B: 1A
	sta.w tmap,y		; $8FDA1C: 99 EE 13
	lda.w #$0001		; $8FDA1F: A9 01 00
	tsb.w tmflags		; $8FDA22: 0C 0A 14
	tsb.w tmflags+2		; $8FDA25: 0C 0C 14
	lda.w #$F820		; $8FDA28: A9 20 F8
	sta.b a0		; $8FDA2B: 85 33
	lda.w #$008F		; $8FDA2D: A9 8F 00
	sta.b a0+2		; $8FDA30: 85 35
	lda.w tmgoalie,y		; $8FDA32: B9 F2 13
	bpl .l4		; $8FDA35: 10 02
	inc.b a0		; $8FDA37: E6 33
.l4:
	ldy.b d1		; $8FDA39: A4 57
	lda.b [a0],y		; $8FDA3B: B7 33
	and.w #$00FF		; $8FDA3D: 29 FF 00
	sta.w position,x		; $8FDA40: 9D 9F 0B
	stx.b a3		; $8FDA43: 86 3F
	jsl.l Setplass		; $8FDA45: 22 38 B1 80
	jsl.l setplayer		; $8FDA49: 22 5D B1 80
	lda.w pflags,x		; $8FDA4D: BD DF 0E
	ora.w #$1000		; $8FDA50: 09 00 10
	sta.w pflags,x		; $8FDA53: 9D DF 0E
	stx.b xsave		; $8FDA56: 86 0A
	ldx.w #$000E		; $8FDA58: A2 0E 00
.l5:
	pla		; $8FDA5B: 68
	sta.b a0,x		; $8FDA5C: 95 33
	dex		; $8FDA5E: CA
	dex		; $8FDA5F: CA
	bpl .l5		; $8FDA60: 10 F9
	ldx.b xsave		; $8FDA62: A6 0A
	stx.b xsave		; $8FDA64: 86 0A
	ldx.w #$000E		; $8FDA66: A2 0E 00
.l6:
	pla		; $8FDA69: 68
	sta.b d0,x		; $8FDA6A: 95 53
	dex		; $8FDA6C: CA
	dex		; $8FDA6D: CA
	bpl .l6		; $8FDA6E: 10 F9
	ldx.b xsave		; $8FDA70: A6 0A
	ldx.b a3		; $8FDA72: A6 3F
	rtl		; $8FDA74: 6B
InitScoutDisplay:		;auto: CODE_8FDA75. SNES: scouting report scroll state reset; a0 = $7F0000 (the text buffer)
	lda.w #$FFFF		; $8FDA75: A9 FF FF
	sta.w VertLineScrolling		; $8FDA78: 8D F3 08
	sta.w PlayerScrollCtr		; $8FDA7B: 8D E9 08
	stz.w SelectedPlayerIdx		; $8FDA7E: 9C ED 08
	stz.w ScoutingReportTimer		; $8FDA81: 9C EF 08
	lda.w #$0000		; $8FDA84: A9 00 00
	sta.b a0		; $8FDA87: 85 33
	lda.w #$007F		; $8FDA89: A9 7F 00
	sta.b a0+2		; $8FDA8C: 85 35
	rtl		; $8FDA8E: 6B
assstanley:		;auto: CODE_8FDA8F (asstab 8). 93G assstanley: skate to the side of the screen holding the Stanley Cup (SPAcup)
	lda.w pfalock,x		; $8FDA8F: BD 7F 11
	bne .l5		; $8FDA92: D0 5E
	lda.w pflags,x		; $8FDA94: BD DF 0E
	bit.w #$0002		; $8FDA97: 89 02 00
	beq .l2		; $8FDA9A: F0 26
	and.w #$FFFD		; $8FDA9C: 29 FD FF
	sta.w pflags,x		; $8FDA9F: 9D DF 0E
	lda.w #$005A		; $8FDAA2: A9 5A 00
	sta.w temp3,x		; $8FDAA5: 9D 9F 0C
	lda.w Hpos		; $8FDAA8: AD 54 01
	bpl .l1		; $8FDAAB: 10 06
	lda.w #$FFA6		; $8FDAAD: A9 A6 FF
	sta.w temp3,x		; $8FDAB0: 9D 9F 0C
.l1:
	lda.w Vpos		; $8FDAB3: AD DF 08
	sta.w temp4,x		; $8FDAB6: 9D BF 0C
	lda.w #$1124		; $8FDAB9: A9 24 11
	sta.b d1		; $8FDABC: 85 57
	jsl.l SetSPA		; $8FDABE: 22 06 B0 80
.l2:
	lda.w temp3,x		; $8FDAC2: BD 9F 0C
	sec		; $8FDAC5: 38
	sbc.w Xpos,x		; $8FDAC6: FD FF 08
	sta.b d0		; $8FDAC9: 85 53
	lda.w temp4,x		; $8FDACB: BD BF 0C
	sec		; $8FDACE: 38
	sbc.w Ypos,x		; $8FDACF: FD 5F 09
	sta.b d1		; $8FDAD2: 85 57
	jsl.l vtoa		; $8FDAD4: 22 A8 AF 80
	lda.b d0		; $8FDAD8: A5 53
	sec		; $8FDADA: 38
	sbc.w #$0007		; $8FDADB: E9 07 00
	beq .l4		; $8FDADE: F0 08
	bmi .l3		; $8FDAE0: 30 04
	bvs .l4		; $8FDAE2: 70 04
	bra .l5		; $8FDAE4: 80 0C
.l3:
	bvs .l5		; $8FDAE6: 70 0A
.l4:
	lda.b d0		; $8FDAE8: A5 53
	sta.b d2		; $8FDAEA: 85 5B
	sta.w facedir,x		; $8FDAEC: 9D BF 0D
	jmp.w $E164		; $8FDAEF: 4C 64 E1  bank8F_E000: 93G playeracc
.l5:
	rtl		; $8FDAF2: 6B
addframe_full:		;auto: CODE_8FDAF3. SNES: sprite VRAM cache full: sprnodraw, addframe_end
	lda.w #$0001		; $8FDAF3: A9 01 00
	sta.b sprnodraw		; $8FDAF6: 85 C7
	jml.l addframe_end		; $8FDAF8: 5C FE D1 87
RemovePlayerFromList:		;auto: CODE_8FDAFC. 93G RemovePlayerFromList: remove entry a0 from the penalty box list (tmboxlist) by shifting the rest down
	lda.w #$FFFF		; $8FDAFC: A9 FF FF
	sta.b d2		; $8FDAFF: 85 5B
.l1:
	inc.b d2		; $8FDB01: E6 5B
	lda.b a0		; $8FDB03: A5 33
	clc		; $8FDB05: 18
	adc.b d2		; $8FDB06: 65 5B
	tay		; $8FDB08: A8
	sep #$20		; $8FDB09: E2 20
	lda.w tmboxlist,y		; $8FDB0B: B9 4A 15
	sta.w tmboxlist-1,y		; $8FDB0E: 99 49 15
	rep #$30		; $8FDB11: C2 30
	bit.w #$0080		; $8FDB13: 89 80 00
	beq .l1		; $8FDB16: F0 E9
	dec.b a0		; $8FDB18: C6 33
	rtl		; $8FDB1A: 6B
asscenterd:		;auto: CODE_8FDB1B (asstab 5). 93G asscenterd (logic93_2): centre on defence: halfway between the puck and his goal; acentero when the team gets the puck
	lda.w gmclock		; $8FDB1B: AD 8A 12
	beq .l1		; $8FDB1E: F0 04
	jml.l assnothing		; $8FDB20: 5C 5A D7 8F
.l1:
	jsl.l check4bench		; $8FDB24: 22 27 85 80
	lda.w pflags,x		; $8FDB28: BD DF 0E
	bit.w #$0008		; $8FDB2B: 89 08 00
	beq .l2		; $8FDB2E: F0 03
	jmp.w .l7		; $8FDB30: 4C B1 DB
.l2:
	bit.w #$0002		; $8FDB33: 89 02 00
	beq .l3		; $8FDB36: F0 12
	and.w #$FFFD		; $8FDB38: 29 FD FF
	sta.w pflags,x		; $8FDB3B: 9D DF 0E
	stz.w temp1,x		; $8FDB3E: 9E 5F 0C
	stz.w temp2,x		; $8FDB41: 9E 7F 0C
	lda.w #$0008		; $8FDB44: A9 08 00
	sta.w temp2b,x		; $8FDB47: 9D FF 0C
.l3:
	lda.w temp1,x		; $8FDB4A: BD 5F 0C
	sec		; $8FDB4D: 38
	sbc.b d7		; $8FDB4E: E5 6F
	sta.w temp1,x		; $8FDB50: 9D 5F 0C
	bpl .l4		; $8FDB53: 10 24
	lda.w aidef,x		; $8FDB55: BD BF 0F
	sta.w temp1,x		; $8FDB58: 9D 5F 0C
	lda.w puckc		; $8FDB5B: AD BB 0E
	bmi .l4		; $8FDB5E: 30 19
	sec		; $8FDB60: 38
	sbc.w #$0006		; $8FDB61: E9 06 00
	sta.b d1		; $8FDB64: 85 57
	lda.w #$0006		; $8FDB66: A9 06 00
	sta.b d0		; $8FDB69: 85 53
	txa		; $8FDB6B: 8A
	lsr a		; $8FDB6C: 4A
	sec		; $8FDB6D: 38
	sbc.w #$0006		; $8FDB6E: E9 06 00
	eor.b d1		; $8FDB71: 45 57
	bmi .l4		; $8FDB73: 30 04
	jml.l assreplace		; $8FDB75: 5C A7 B4 80
.l4:
	lda.w puckx		; $8FDB79: AD 1B 09
	pha		; $8FDB7C: 48
	asl a		; $8FDB7D: 0A
	pla		; $8FDB7E: 68
	ror a		; $8FDB7F: 6A
	sta.b d0		; $8FDB80: 85 53
	lda.w #$0080		; $8FDB82: A9 80 00
	sta.b d1		; $8FDB85: 85 57
	lda.w pfgoal,x		; $8FDB87: BD 3F 11
	beq .l8		; $8FDB8A: F0 26
	lda.w #$FF80		; $8FDB8C: A9 80 FF
	sta.b d1		; $8FDB8F: 85 57
	lda.w #$FFA8		; $8FDB91: A9 A8 FF
	sec		; $8FDB94: 38
	sbc.w pucky		; $8FDB95: ED 7B 09
	beq .l6		; $8FDB98: F0 08
	bmi .l5		; $8FDB9A: 30 04
	bvs .l6		; $8FDB9C: 70 04
	bra .l11		; $8FDB9E: 80 2D
.l5:
	bvs .l11		; $8FDBA0: 70 2B
.l6:
	lda.w #$FF80		; $8FDBA2: A9 80 FF
	clc		; $8FDBA5: 18
	adc.w pucky		; $8FDBA6: 6D 7B 09
	pha		; $8FDBA9: 48
	asl a		; $8FDBAA: 0A
	pla		; $8FDBAB: 68
	ror a		; $8FDBAC: 6A
	sta.b d1		; $8FDBAD: 85 57
	bra .l11		; $8FDBAF: 80 1C
.l7:
	rtl		; $8FDBB1: 6B
.l8:
	lda.w #$0058		; $8FDBB2: A9 58 00
	sec		; $8FDBB5: 38
	sbc.w pucky		; $8FDBB6: ED 7B 09
	bmi .l9		; $8FDBB9: 30 04
	bvc .l10		; $8FDBBB: 50 04
	bra .l11		; $8FDBBD: 80 0E
.l9:
	bvc .l11		; $8FDBBF: 50 0C
.l10:
	lda.b d1		; $8FDBC1: A5 57
	clc		; $8FDBC3: 18
	adc.w pucky		; $8FDBC4: 6D 7B 09
	pha		; $8FDBC7: 48
	asl a		; $8FDBC8: 0A
	pla		; $8FDBC9: 68
	ror a		; $8FDBCA: 6A
	sta.b d1		; $8FDBCB: 85 57
.l11:
	lda.w #$84E6		; $8FDBCD: A9 E6 84
	sta.b a0		; $8FDBD0: 85 33
	lda.w #$0080		; $8FDBD2: A9 80 00
	sta.b a0+2		; $8FDBD5: 85 35
	jml.l skateto		; $8FDBD7: 5C D0 FD 88
box:		;auto: CODE_8FDBDB. SNES: erase the 19 x 9 box at x 11, y 2 (93G box role)
	jsl.l printz		; $8FDBDB: 22 0C B9 80
	dw $0005		; $8FDBDF  printz inline string: length (counts itself), then control bytes / text
	db $FF,$0B,$02
	lda.w #$0013		; $8FDBE4: A9 13 00
	sta.b d0		; $8FDBE7: 85 53
	lda.w #$0009		; $8FDBE9: A9 09 00
	sta.b d1		; $8FDBEC: 85 57
	lda.w blankchar		; $8FDBEE: AD E7 1B
	sta.b d2		; $8FDBF1: 85 5B
	jml.l eraser		; $8FDBF3: 5C 7C 84 8D
UpdateCwdExcite:		;auto: CODE_8FDBF7. 93G UpdateCwdExcite: nothing on the SNES
	rtl		; $8FDBF7: 6B
CheckPeriodEnd:		;auto: CODE_8FDBF8. 93G CheckPeriodEnd: nothing on the SNES
	rtl		; $8FDBF8: 6B
loadTeamStruct:		;auto: CODE_8FDBF9. 93G loadTeamStruct: a2 = team of player X, a1 = the other team
	stz.b a2		; $8FDBF9: 64 3B
	lda.w #$0002		; $8FDBFB: A9 02 00
	sta.b a1		; $8FDBFE: 85 37
	lda.w pfteam,x		; $8FDC00: BD 9F 11
	beq .l1		; $8FDC03: F0 07
	stz.b a1		; $8FDC05: 64 37
	lda.w #$0002		; $8FDC07: A9 02 00
	sta.b a2		; $8FDC0A: 85 3B
.l1:
	rtl		; $8FDC0C: 6B
ScoutingReport:		;auto: CODE_8FDC0D (from Opening4). 93G ScoutingReport (hockey93_07): the scouting report screen: EASN backdrop, both team blocks, ScoutLabels with both teams' ratings, Ron Barr and
		;   the scrolling text until Start
	jsl.l ClearTeamStats		; $8FDC0D: 22 6B FD 82
	jsl.l $8FE404		; $8FDC11: 22 04 E4 8F  bank8F_E000: 93G forceblack
	jsl.l InitPPU		; $8FDC15: 22 20 81 8D
	sep #$20		; $8FDC19: E2 20
	cli		; $8FDC1B: 58
	lda.w RDNMI		; $8FDC1C: AD 10 42
	lda.b #$81		; $8FDC1F: A9 81
	sta.w NMITIMEN		; $8FDC21: 8D 00 42
	lda.b #$03		; $8FDC24: A9 03
	sta.w OBSEL		; $8FDC26: 8D 01 21
	lda.b #$01		; $8FDC29: A9 01
	sta.w BGMODE		; $8FDC2B: 8D 05 21
	lda.b #$00		; $8FDC2E: A9 00
	sta.w BG1SC		; $8FDC30: 8D 07 21
	lda.b #$04		; $8FDC33: A9 04
	sta.w BG2SC		; $8FDC35: 8D 08 21
	lda.b #$11		; $8FDC38: A9 11
	sta.w BG12NBA		; $8FDC3A: 8D 0B 21
	lda.b #$03		; $8FDC3D: A9 03
	sta.w TM		; $8FDC3F: 8D 2C 21
	rep #$30		; $8FDC42: C2 30
	stz.w tmgoalie		; $8FDC44: 9C F2 13
	stz.w tmgoalie+2		; $8FDC47: 9C F4 13
	lda.w #$0025		; $8FDC4A: A9 25 00
	sta.w blankchar		; $8FDC4D: 8D E7 1B
	inc a		; $8FDC50: 1A
	sta.w scorechars		; $8FDC51: 8D E5 1B
	clc		; $8FDC54: 18
	adc.w #$0195		; $8FDC55: 69 95 01
	sta.w smallfontchars		; $8FDC58: 8D D7 1B
	adc.w #$0064		; $8FDC5B: 69 64 00
	sta.w Framercset		; $8FDC5E: 8D DB 1B
	adc.w #$0004		; $8FDC61: 69 04 00
	sta.w ronbarrchars		; $8FDC64: 8D E3 1B
	stz.w charofs		; $8FDC67: 9C CD 1B
	stz.w charofs2		; $8FDC6A: 9C CF 1B
	lda.w blankchar		; $8FDC6D: AD E7 1B
	ldx.w #$07FE		; $8FDC70: A2 FE 07
.l1:
	sta.l textmap,x		; $8FDC73: 9F 74 6E 7E
	dex		; $8FDC77: CA
	dex		; $8FDC78: CA
	bpl .l1		; $8FDC79: 10 F8
	lda.w #EASNMap		; $8FDC7B: A9 A0 C3
	sta.b tmp0		; $8FDC7E: 85 73
	lda.w #EASNMap>>16		; $8FDC80: A9 87 00
	sta.b tmp1		; $8FDC83: 85 75
	jsl.l DecompressGraphics		; $8FDC85: 22 3E FA 86
	ldx.w #$03FE		; $8FDC89: A2 FE 03
.l2:
	lda.l TestList,x		; $8FDC8C: BF 00 00 7F
	sta.l backmap,x		; $8FDC90: 9F 74 76 7E
	sta.l backmap+$400,x		; $8FDC94: 9F 74 7A 7E
	dex		; $8FDC98: CA
	dex		; $8FDC99: CA
	bpl .l2		; $8FDC9A: 10 F0
	lda.w #$1000		; $8FDC9C: A9 00 10
	sta.w VMADDL		; $8FDC9F: 8D 16 21
	ldx.w #$0000		; $8FDCA2: A2 00 00
.l3:
	lda.l TestList+$400,x		; $8FDCA5: BF 00 04 7F
	sta.w VMDATAL		; $8FDCA9: 8D 18 21
	inx		; $8FDCAC: E8
	inx		; $8FDCAD: E8
	cpx.w #$04A0		; $8FDCAE: E0 A0 04
	bne .l3		; $8FDCB1: D0 F2
	ldx.w #$0010		; $8FDCB3: A2 10 00
.l4:
	stz.w VMDATAL		; $8FDCB6: 9C 18 21
	dex		; $8FDCB9: CA
	bne .l4		; $8FDCBA: D0 FA
	lda.w #TeamBlocksTiles		; $8FDCBC: A9 73 9B
	sta.b tmp0		; $8FDCBF: 85 73
	lda.w #TeamBlocksTiles>>16		; $8FDCC1: A9 88 00
	sta.b tmp1		; $8FDCC4: 85 75
	jsl.l DecompressGraphics		; $8FDCC6: 22 3E FA 86
	ldx.w #$0000		; $8FDCCA: A2 00 00
.l5:
	lda.l TestList,x		; $8FDCCD: BF 00 00 7F
	sta.w VMDATAL		; $8FDCD1: 8D 18 21
	inx		; $8FDCD4: E8
	inx		; $8FDCD5: E8
	cpx.w #$32A0		; $8FDCD6: E0 A0 32
	bne .l5		; $8FDCD9: D0 F2
	lda.w #SmallFontTiles		; $8FDCDB: A9 D8 C6
	sta.b tmp0		; $8FDCDE: 85 73
	lda.w #SmallFontTiles>>16		; $8FDCE0: A9 83 00
	sta.b tmp1		; $8FDCE3: 85 75
	jsl.l DecompressGraphics		; $8FDCE5: 22 3E FA 86
	ldx.w #$0000		; $8FDCE9: A2 00 00
.l6:
	lda.l TestList,x		; $8FDCEC: BF 00 00 7F
	sta.w VMDATAL		; $8FDCF0: 8D 18 21
	inx		; $8FDCF3: E8
	inx		; $8FDCF4: E8
	cpx.w #$0C80		; $8FDCF5: E0 80 0C
	bne .l6		; $8FDCF8: D0 F2
	ldx.w #$0000		; $8FDCFA: A2 00 00
.l7:
	lda.l FramerTiles,x		; $8FDCFD: BF 2E 87 88
	sta.w VMDATAL		; $8FDD01: 8D 18 21
	inx		; $8FDD04: E8
	inx		; $8FDD05: E8
	cpx.w #$0080		; $8FDD06: E0 80 00
	bne .l7		; $8FDD09: D0 F2
	jsl.l printz		; $8FDD0B: 22 0C B9 80
	dw $0005		; $8FDD0F  printz inline string: length (counts itself), then control bytes / text
	db $FE,$06,$03
	lda.w #$0019		; $8FDD14: A9 19 00
	sta.b d0		; $8FDD17: 85 53
	lda.w #$0009		; $8FDD19: A9 09 00
	sta.b d1		; $8FDD1C: 85 57
	jsl.l Framer		; $8FDD1E: 22 9F D6 8F
	lda.w #RonBarrMap		; $8FDD22: A9 38 ED
	sta.b tmp0		; $8FDD25: 85 73
	lda.w #RonBarrMap>>16		; $8FDD27: A9 80 00
	sta.b tmp1		; $8FDD2A: 85 75
	jsl.l DecompressGraphics		; $8FDD2C: 22 3E FA 86
	sep #$20		; $8FDD30: E2 20
	stz.w CGADD		; $8FDD32: 9C 21 21
	ldx.w #$0000		; $8FDD35: A2 00 00
.l8:
	lda.l TestList+$90,x		; $8FDD38: BF 90 00 7F
	sta.w CGDATA		; $8FDD3C: 8D 22 21
	inx		; $8FDD3F: E8
	cpx.w #$0080		; $8FDD40: E0 80 00
	bne .l8		; $8FDD43: D0 F3
	rep #$30		; $8FDD45: C2 30
	ldx.w #$0000		; $8FDD47: A2 00 00
.l9:
	lda.l TestList+$190,x		; $8FDD4A: BF 90 01 7F
	sta.w VMDATAL		; $8FDD4E: 8D 18 21
	inx		; $8FDD51: E8
	inx		; $8FDD52: E8
	cpx.w #$07A0		; $8FDD53: E0 A0 07
	bne .l9		; $8FDD56: D0 F2
	stz.b tmp1		; $8FDD58: 64 75
.l10:
	stz.b tmp0		; $8FDD5A: 64 73
.l11:
	lda.b tmp1		; $8FDD5C: A5 75
	sta.b mula		; $8FDD5E: 85 7D
	lda.w #$0008		; $8FDD60: A9 08 00
	sta.b mulb		; $8FDD63: 85 83
	jsl.l mulu16		; $8FDD65: 22 1C 87 8D
	adc.b tmp0		; $8FDD69: 65 73
	asl a		; $8FDD6B: 0A
	tax		; $8FDD6C: AA
	lda.l TestList,x		; $8FDD6D: BF 00 00 7F
	adc.w ronbarrchars		; $8FDD71: 6D E3 1B
	pha		; $8FDD74: 48
	lda.b tmp1		; $8FDD75: A5 75
	asl a		; $8FDD77: 0A
	asl a		; $8FDD78: 0A
	asl a		; $8FDD79: 0A
	asl a		; $8FDD7A: 0A
	asl a		; $8FDD7B: 0A
	adc.b tmp0		; $8FDD7C: 65 73
	asl a		; $8FDD7E: 0A
	tax		; $8FDD7F: AA
	pla		; $8FDD80: 68
	sta.l backmap+$44,x		; $8FDD81: 9F B8 76 7E
	inc.b tmp0		; $8FDD85: E6 73
	lda.b tmp0		; $8FDD87: A5 73
	cmp.w #$0008		; $8FDD89: C9 08 00
	bne .l11		; $8FDD8C: D0 CE
	inc.b tmp1		; $8FDD8E: E6 75
	lda.b tmp1		; $8FDD90: A5 75
	cmp.w #$0009		; $8FDD92: C9 09 00
	bne .l10		; $8FDD95: D0 C3
	jsl.l printz		; $8FDD97: 22 0C B9 80
	dw $0005		; $8FDD9B  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$0D
	lda.w VisTeam		; $8FDDA0: AD 9C 12
	sta.b d1		; $8FDDA3: 85 57
	jsl.l DrawTeamBlocks		; $8FDDA5: 22 E2 84 8D
	jsl.l printz		; $8FDDA9: 22 0C B9 80
	dw $0005		; $8FDDAD  printz inline string: length (counts itself), then control bytes / text
	db $FF,$15,$0D
	lda.w HomeTeam		; $8FDDB2: AD 9A 12
	sta.b d1		; $8FDDB5: 85 57
	jsl.l DrawTeamBlocks		; $8FDDB7: 22 E2 84 8D
	jsl.l printz		; $8FDDBB: 22 0C B9 80
	dw $0005		; $8FDDBF  printz inline string: length (counts itself), then control bytes / text
	db $FF,$11,$0F
	lda.w #ScoutLabels		; $8FDDC4: A9 66 DF
	sta.b a1		; $8FDDC7: 85 37
	lda.w #ScoutLabels>>16		; $8FDDC9: A9 8F 00
	sta.b a1+2		; $8FDDCC: 85 39
.l12:
	lda.b [a1]		; $8FDDCE: A7 37
	lsr a		; $8FDDD0: 4A
	eor.w #$FFFF		; $8FDDD1: 49 FF FF
	inc a		; $8FDDD4: 1A
	clc		; $8FDDD5: 18
	adc.w #$0011		; $8FDDD6: 69 11 00
	sta.w printx		; $8FDDD9: 8D 7B 04
	jsl.l print		; $8FDDDC: 22 2D B9 80
	inc.w printy		; $8FDDE0: EE 7D 04
	ldy.w #$0002		; $8FDDE3: A0 02 00
	lda.b [a1],y		; $8FDDE6: B7 37
	bit.w #$0080		; $8FDDE8: 89 80 00
	beq .l12		; $8FDDEB: F0 E1
	jsl.l printz		; $8FDDED: 22 0C B9 80
	dw $0005		; $8FDDF1  printz inline string: length (counts itself), then control bytes / text
	db $FF,$19,$0F
	lda.w tmdata		; $8FDDF6: AD CE 13
	sta.b a0		; $8FDDF9: 85 33
	lda.w #$0083		; $8FDDFB: A9 83 00
	sta.b a0+2		; $8FDDFE: 85 35
	sta.b a2+2		; $8FDE00: 85 3D
	lda.w tmdata+2		; $8FDE02: AD D0 13
	sta.b a2		; $8FDE05: 85 3B
	ldy.w #$0008		; $8FDE07: A0 08 00
	lda.b [a0],y		; $8FDE0A: B7 33
	clc		; $8FDE0C: 18
	adc.b a0		; $8FDE0D: 65 33
	sta.b a0		; $8FDE0F: 85 33
	lda.b [a2],y		; $8FDE11: B7 3B
	adc.b a2		; $8FDE13: 65 3B
	sta.b a2		; $8FDE15: 85 3B
	jsl.l ScoutCompare		; $8FDE17: 22 D2 DE 8F
	jsl.l printz		; $8FDE1B: 22 0C B9 80
	dw $0005		; $8FDE1F  printz inline string: length (counts itself), then control bytes / text
	db $FF,$04,$0F
	lda.b a0		; $8FDE24: A5 33
	ldx.b a2		; $8FDE26: A6 3B
	sta.b a2		; $8FDE28: 85 3B
	stx.b a0		; $8FDE2A: 86 33
	jsl.l ScoutCompare		; $8FDE2C: 22 D2 DE 8F
	jsl.l InitScoutDisplay		; $8FDE30: 22 75 DA 8F
	lda.w #$001A		; $8FDE34: A9 1A 00
	sta.b [a0]		; $8FDE37: 87 33
	inc.b a0		; $8FDE39: E6 33
	inc.b a0		; $8FDE3B: E6 33
	inc a		; $8FDE3D: 1A
	sta.b [a0]		; $8FDE3E: 87 33
	inc.b a0		; $8FDE40: E6 33
	inc.b a0		; $8FDE42: E6 33
	inc a		; $8FDE44: 1A
	inc a		; $8FDE45: 1A
	sta.b [a0]		; $8FDE46: 87 33
	inc.b a0		; $8FDE48: E6 33
	inc.b a0		; $8FDE4A: E6 33
	lda.w HomeTeam		; $8FDE4C: AD 9A 12
	sta.b d0		; $8FDE4F: 85 53
	sta.b [a0]		; $8FDE51: 87 33
	inc.b a0		; $8FDE53: E6 33
	inc.b a0		; $8FDE55: E6 33
	lda.w #$001D		; $8FDE57: A9 1D 00
	sta.b [a0]		; $8FDE5A: 87 33
	inc.b a0		; $8FDE5C: E6 33
	inc.b a0		; $8FDE5E: E6 33
	lda.w VisTeam		; $8FDE60: AD 9C 12
	cmp.b d0		; $8FDE63: C5 53
	beq .l13		; $8FDE65: F0 06
	sta.b [a0]		; $8FDE67: 87 33
	inc.b a0		; $8FDE69: E6 33
	inc.b a0		; $8FDE6B: E6 33
.l13:
	lda.w #$001D		; $8FDE6D: A9 1D 00
	sta.b [a0]		; $8FDE70: 87 33
	inc.b a0		; $8FDE72: E6 33
	inc.b a0		; $8FDE74: E6 33
	dec a		; $8FDE76: 3A
	sta.b [a0]		; $8FDE77: 87 33
	inc.b a0		; $8FDE79: E6 33
	inc.b a0		; $8FDE7B: E6 33
	lda.w #$FFFF		; $8FDE7D: A9 FF FF
	sta.b [a0]		; $8FDE80: 87 33
	stz.w asv		; $8FDE82: 9C 44 16
	lda.w #$7FFF		; $8FDE85: A9 FF 7F
	sta.w screentimer		; $8FDE88: 8D EB 08
.l14:
	lda.w #textmap		; $8FDE8B: A9 74 6E
	sta.w DMAList		; $8FDE8E: 8D 53 16
	lda.w #textmap>>16		; $8FDE91: A9 7E 00
	sta.w DMAList+dmabank		; $8FDE94: 8D 55 16
	lda.w #$1000		; $8FDE97: A9 00 10
	sta.w DMAList+dmalen		; $8FDE9A: 8D 56 16
	stz.w DMAList+dmavram		; $8FDE9D: 9C 58 16
	lda.w #$0007		; $8FDEA0: A9 07 00
	sta.b DMAListend		; $8FDEA3: 85 A3
	lda.w #$8250		; $8FDEA5: A9 50 82
	sta.b vbint		; $8FDEA8: 85 14
.l15:
	cmp.b vbint		; $8FDEAA: C5 14
	beq .l15		; $8FDEAC: F0 FC
	jsl.l ReadPads		; $8FDEAE: 22 E8 F3 80
	lda.w padnew1		; $8FDEB2: AD 6E 01
	ora.w padnew1+2		; $8FDEB5: 0D 70 01
	bit.w #$1000		; $8FDEB8: 89 00 10
	bne .l17		; $8FDEBB: D0 14
	bit.w #$0400		; $8FDEBD: 89 00 04
	beq .l16		; $8FDEC0: F0 06
	lda.w #$FFFF		; $8FDEC2: A9 FF FF
	sta.w asv		; $8FDEC5: 8D 44 16
.l16:
	jsl.l UpdateScoutingDisplay		; $8FDEC8: 22 32 F5 84
	dec.w screentimer		; $8FDECC: CE EB 08
	bpl .l14		; $8FDECF: 10 BA
.l17:
	rtl		; $8FDED1: 6B
ScoutCompare:		;auto: CODE_8FDED2. SNES: print the scouting ratings of team [a0] (nibbles of .sr, against [a2] for the advantages) down the screen
	ldy.w #$0004		; $8FDED2: A0 04 00
	lda.b [a0],y		; $8FDED5: B7 33
	xba		; $8FDED7: EB
	sta.b d5+2		; $8FDED8: 85 69
	iny		; $8FDEDA: C8
	iny		; $8FDEDB: C8
	lda.b [a0],y		; $8FDEDC: B7 33
	xba		; $8FDEDE: EB
	sta.b d5		; $8FDEDF: 85 67
	lda.w #$0007		; $8FDEE1: A9 07 00
	sta.b d6		; $8FDEE4: 85 6B
.l1:
	ldy.w #$0004		; $8FDEE6: A0 04 00
.l2:
	asl.b d5		; $8FDEE9: 06 67
	rol.b d5+2		; $8FDEEB: 26 69
	lda.b d5		; $8FDEED: A5 67
	adc.w #$0000		; $8FDEEF: 69 00 00
	sta.b d5		; $8FDEF2: 85 67
	dey		; $8FDEF4: 88
	bne .l2		; $8FDEF5: D0 F2
	lda.b d5		; $8FDEF7: A5 67
	and.w #$000F		; $8FDEF9: 29 0F 00
	sta.b d0		; $8FDEFC: 85 53
	jsl.l .l5		; $8FDEFE: 22 4D DF 8F
	lda.b d6		; $8FDF02: A5 6B
	cmp.w #$0001		; $8FDF04: C9 01 00
	bne .l3		; $8FDF07: D0 04
	jsl.l .l4		; $8FDF09: 22 12 DF 8F
.l3:
	dec.b d6		; $8FDF0D: C6 6B
	bpl .l1		; $8FDF0F: 10 D5
	rtl		; $8FDF11: 6B
.l4:
	lda.b [a0]		; $8FDF12: A7 33
	xba		; $8FDF14: EB
	and.w #$000F		; $8FDF15: 29 0F 00
	sta.b d0		; $8FDF18: 85 53
	lda.b [a2]		; $8FDF1A: A7 3B
	xba		; $8FDF1C: EB
	lsr a		; $8FDF1D: 4A
	lsr a		; $8FDF1E: 4A
	lsr a		; $8FDF1F: 4A
	lsr a		; $8FDF20: 4A
	and.w #$000F		; $8FDF21: 29 0F 00
	clc		; $8FDF24: 18
	adc.b d0		; $8FDF25: 65 53
	sta.b d0		; $8FDF27: 85 53
	jsl.l .l5		; $8FDF29: 22 4D DF 8F
	lda.w printx		; $8FDF2D: AD 7B 04
	cmp.w #$0010		; $8FDF30: C9 10 00
	bcc .l6		; $8FDF33: 90 2D
	ldy.w #$0002		; $8FDF35: A0 02 00
	lda.b [a0],y		; $8FDF38: B7 33
	lsr a		; $8FDF3A: 4A
	lsr a		; $8FDF3B: 4A
	lsr a		; $8FDF3C: 4A
	lsr a		; $8FDF3D: 4A
	and.w #$000F		; $8FDF3E: 29 0F 00
	sta.b d0		; $8FDF41: 85 53
	lda.b [a2],y		; $8FDF43: B7 3B
	and.w #$000F		; $8FDF45: 29 0F 00
	clc		; $8FDF48: 18
	adc.b d0		; $8FDF49: 65 53
	sta.b d0		; $8FDF4B: 85 53
.l5:
	lda.w #$0002		; $8FDF4D: A9 02 00
	sta.b d1		; $8FDF50: 85 57
	jsl.l $8FF54E		; $8FDF52: 22 4E F5 8F  bank8F_F000: 93G PushNumberWidth
	lda.w printx		; $8FDF56: AD 7B 04
	pha		; $8FDF59: 48
	jsl.l print		; $8FDF5A: 22 2D B9 80
	pla		; $8FDF5E: 68
	sta.w printx		; $8FDF5F: 8D 7B 04
.l6:
	inc.w printy		; $8FDF62: EE 7D 04
	rtl		; $8FDF65: 6B
ScoutLabels:		;93G scouting labels: the rating names of the scouting report; a $FF string ends the list
	dw 10		; $8FDF66
	db "Shooting"
	dw 9		; $8FDF70
	db "Skating"
	dw 9		; $8FDF79
	db "Passing"
	dw 9		; $8FDF82
	db "Defense"
	dw 10		; $8FDF8B
	db "Checking"
	dw 10		; $8FDF95
	db "Fighting"
	dw 13		; $8FDF9F
	db "Goalkeeping"
	dw 17		; $8FDFAC
	db "Power Play Adv."
	dw 25		; $8FDFBD
	db "-    Home Team Adv.    "
	dw 9		; $8FDFD6
	db "Overall"
	dw 3		; $8FDFDF
	db $FF
PuckcSpots:		;93G asspuckc spots: x, y of spot d0 (6 + temp3, or position when offsides)
	dw -100,-20		; $8FDFE2
	dw 100,-20		; $8FDFE6
	dw -120,40		; $8FDFEA
	dw 20,40		; $8FDFEE
	dw 120,40		; $8FDFF2
	dw -20,40		; $8FDFF6
	dw -40,240		; $8FDFFA
	dw 0,220		; $8FDFFE
	dw 20,230		; $8FE002
	dw 30,230		; $8FE006
