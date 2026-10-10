; $80CEE7-$80E0E0  ROM $04EE7-$060E0: checkgoal, Goal, checkgoalp, CheckBump (hockey93_04), ChkShotStat (penalty93_2), PenGoalStuff
; (penalty93_1), checkplcoll, checkcx, newcheck, checkint, FallDown, checkcheck (hockey93_03), checkfight, SetInst (hockey93_04),
; doinput, faceoffinput, holdplayer (logic93_1). Starts at checkgoal (boundary moved from $80D002), ends before setpads.
org $80CEE7
checkgoal:		;auto: CODE_80CEE7. 93G checkgoal (hockey93_04): collision with the goal/net. a2 = goal object, X = object, d2/d3 = x/y. Not the puck: checkgoalp. Puck in the goal area: over the top (Zvel), through the mouth (Goal), off a post (deflect) or off the side/back (wallcoll)
	lda.w Zpos,x		; $80CEE7: BD 9F 09  Zpos > 13 (goal height): over the goal
	sec		; $80CEEA: 38
	sbc.w #$000D		; $80CEEB: E9 0D 00
	beq .z		; $80CEEE: F0 09
	bmi .v1		; $80CEF0: 30 05
	bvs .z		; $80CEF2: 70 05
.ex1:
	jmp.w .rtl		; $80CEF4: 4C 13 D1
.v1:
	bvs .ex1		; $80CEF7: 70 FB
.z:
	cpx.w #puckobj		; $80CEF9: E0 1C 00  not the puck: checkgoalp
	beq .puck		; $80CEFC: F0 03
	jmp.w checkgoalp		; $80CEFE: 4C D3 D3
.puck:		;puck: inside |dx| <= 16+wcradiusx and |dy| <= 4+wcradiusy?
	ldy.b a2		; $80CF01: A4 3B  d2 = x - goal x
	lda.w #$0010		; $80CF03: A9 10 00
	clc		; $80CF06: 18
	adc.w wcradiusx		; $80CF07: 6D E3 08
	sta.b d4		; $80CF0A: 85 63
	lda.b d2		; $80CF0C: A5 5B
	sec		; $80CF0E: 38
	sbc.w Xpos,y		; $80CF0F: F9 FF 08
	sta.b d2		; $80CF12: 85 5B
	sec		; $80CF14: 38
	sbc.b d4		; $80CF15: E5 63
	beq .xl		; $80CF17: F0 09
	bmi .v2		; $80CF19: 30 05
	bvs .xl		; $80CF1B: 70 05
.ex2:
	jmp.w .rtl		; $80CF1D: 4C 13 D1
.v2:
	bvs .ex2		; $80CF20: 70 FB
.xl:
	lda.b d4		; $80CF22: A5 63
	eor.w #$FFFF		; $80CF24: 49 FF FF
	inc a		; $80CF27: 1A
	sta.b d4		; $80CF28: 85 63
	lda.b d2		; $80CF2A: A5 5B
	sec		; $80CF2C: 38
	sbc.b d4		; $80CF2D: E5 63
	bmi .v3		; $80CF2F: 30 05
	bvc .yh		; $80CF31: 50 05
.ex3:
	jmp.w .rtl		; $80CF33: 4C 13 D1
.v3:
	bvc .ex3		; $80CF36: 50 FB
.yh:
	lda.w #$0004		; $80CF38: A9 04 00
	clc		; $80CF3B: 18
	adc.w wcradiusy		; $80CF3C: 6D E5 08
	sta.b d5		; $80CF3F: 85 67
	lda.b d3		; $80CF41: A5 5F
	sec		; $80CF43: 38
	sbc.w Ypos,y		; $80CF44: F9 5F 09
	sta.b d3		; $80CF47: 85 5F
	sec		; $80CF49: 38
	sbc.b d5		; $80CF4A: E5 67
	beq .yl		; $80CF4C: F0 09
	bmi .v4		; $80CF4E: 30 05
	bvs .yl		; $80CF50: 70 05
.ex4:
	jmp.w .rtl		; $80CF52: 4C 13 D1
.v4:
	bvs .ex4		; $80CF55: 70 FB
.yl:
	lda.b d5		; $80CF57: A5 67
	eor.w #$FFFF		; $80CF59: 49 FF FF
	inc a		; $80CF5C: 1A
	sta.b d5		; $80CF5D: 85 67
	lda.b d3		; $80CF5F: A5 5F
	sec		; $80CF61: 38
	sbc.b d5		; $80CF62: E5 67
	bmi .v5		; $80CF64: 30 05
	bvc .inside		; $80CF66: 50 05
.ex5:
	jmp.w .rtl		; $80CF68: 4C 13 D1
.v5:
	bvc .ex5		; $80CF6B: 50 FB
.inside:		;inside the goal area now
	lda.w #$FFFF		; $80CF6D: A9 FF FF  collflag
	sta.b collflag		; $80CF70: 85 D8
	lda.w OldZpos+puckobj		; $80CF72: AD BB 0A
	sec		; $80CF75: 38
	sbc.w #$000D		; $80CF76: E9 0D 00
	bmi .v6		; $80CF79: 30 04
	bvc .over		; $80CF7B: 50 04
	bra .nod		; $80CF7D: 80 0B
.v6:
	bvc .nod		; $80CF7F: 50 09
.over:		;OldZpos >= 13: came over the top
	lda.w OldZpos+puckobj		; $80CF81: AD BB 0A
	sta.w Zpos+puckobj		; $80CF84: 8D BB 09
	jmp.w .deflectz		; $80CF87: 4C 04 D1
.nod:		;pfgoal of the puck = the carrier shot into his own goal
	stz.w pfgoal+puckobj		; $80CF8A: 9C 5B 11
	lda.w puckc		; $80CF8D: AD BB 0E  carrier: loses the puck, nopuck 8
	bmi .nocon		; $80CF90: 30 2A
	asl a		; $80CF92: 0A
	tay		; $80CF93: A8
	lda.w #$FFFF		; $80CF94: A9 FF FF
	sta.w puckc		; $80CF97: 8D BB 0E
	lda.w #$0008		; $80CF9A: A9 08 00
	sta.w nopuck,y		; $80CF9D: 99 5F 0E
	lda.w pucky		; $80CFA0: AD 7B 09
	sta.b d1		; $80CFA3: 85 57
	lda.w pfgoal,y		; $80CFA5: B9 3F 11
	bne .an		; $80CFA8: D0 08
	lda.b d1		; $80CFAA: A5 57
	eor.w #$FFFF		; $80CFAC: 49 FF FF
	inc a		; $80CFAF: 1A
	sta.b d1		; $80CFB0: 85 57
.an:
	lda.b d1		; $80CFB2: A5 57
	bpl .nocon		; $80CFB4: 10 06
	lda.w #$0001		; $80CFB6: A9 01 00
	sta.w pfgoal+puckobj		; $80CFB9: 8D 5B 11
.nocon:		;d0 = -256 (top entry: +256)
	lda.w #$FF00		; $80CFBC: A9 00 FF  d1 = (Ypos - OldYpos) >> 8
	sta.b d0		; $80CFBF: 85 53
	lda.w Yfrac,x		; $80CFC1: BD 7F 09
	sec		; $80CFC4: 38
	sbc.w OldYfrac,x		; $80CFC5: FD 7F 0A
	sta.b d1		; $80CFC8: 85 57
	lda.w Ypos,x		; $80CFCA: BD 5F 09
	sbc.w OldYpos,x		; $80CFCD: FD 5F 0A
	sta.b d1+2		; $80CFD0: 85 59
	lda.b d1+1		; $80CFD2: A5 58
	sta.b d1		; $80CFD4: 85 57
	bne .dy		; $80CFD6: D0 03
	jmp.w .sideentry		; $80CFD8: 4C 14 D1
.dy:
	bmi .dy0		; $80CFDB: 30 10
	lda.b d0		; $80CFDD: A5 53
	eor.w #$FFFF		; $80CFDF: 49 FF FF
	inc a		; $80CFE2: 1A
	sta.b d0		; $80CFE3: 85 53
	lda.b d5		; $80CFE5: A5 67
	eor.w #$FFFF		; $80CFE7: 49 FF FF
	inc a		; $80CFEA: 1A
	sta.b d5		; $80CFEB: 85 67
.dy0:		;d5 = dy at entry; d2 -= dx*dy/vy: x where the puck crossed the goal line
	lda.b d5		; $80CFED: A5 67
	clc		; $80CFEF: 18
	adc.b d3		; $80CFF0: 65 5F
	sta.b d5		; $80CFF2: 85 67
	sta.b mulb		; $80CFF4: 85 83
	lda.w Xfrac,x		; $80CFF6: BD 1F 09  d3 = (Xpos - OldXpos) >> 8; d5*d3
	sec		; $80CFF9: 38
	sbc.w OldXfrac,x		; $80CFFA: FD 3F 0A
	sta.b d3		; $80CFFD: 85 5F
	lda.w Xpos,x		; $80CFFF: BD FF 08
	sbc.w OldXpos,x		; $80D002: FD 1F 0A
	sta.b d3+2		; $80D005: 85 61
	lda.b d3+1		; $80D007: A5 60
	sta.b d3		; $80D009: 85 5F
	sta.b mula		; $80D00B: 85 7D
	jsl.l $82FCDB		; $80D00D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d1		; $80D011: A5 57  |d5*d3| < |d1|? else side entry
	bit.w #$8000		; $80D013: 89 00 80
	beq .m1		; $80D016: F0 04
	eor.w #$FFFF		; $80D018: 49 FF FF
	inc a		; $80D01B: 1A
.m1:
	sta.b mula		; $80D01C: 85 7D
	lda.b mulres+2		; $80D01E: A5 95
	bit.w #$8000		; $80D020: 89 00 80
	beq .m2		; $80D023: F0 04
	eor.w #$FFFF		; $80D025: 49 FF FF
	inc a		; $80D028: 1A
.m2:
	cmp.b mula		; $80D029: C5 7D
	bcc .dv		; $80D02B: 90 03
	jmp.w .sideentry		; $80D02D: 4C 14 D1
.dv:
	lda.b d1		; $80D030: A5 57
	sta.b mula		; $80D032: 85 7D
	jsl.l divs		; $80D034: 22 6C 99 80  d5 = d5*d3 / d1
	sta.b d5		; $80D038: 85 67
	lda.b d2		; $80D03A: A5 5B
	sec		; $80D03C: 38
	sbc.b d5		; $80D03D: E5 67
	sta.b d2		; $80D03F: 85 5B
	sec		; $80D041: 38
	sbc.b d4		; $80D042: E5 63
	bmi .v7		; $80D044: 30 05
	bvc .xl2		; $80D046: 50 05
.se1:
	jmp.w .sideentry		; $80D048: 4C 14 D1
.v7:
	bvc .se1		; $80D04B: 50 FB
.xl2:
	lda.b d4		; $80D04D: A5 63
	eor.w #$FFFF		; $80D04F: 49 FF FF
	inc a		; $80D052: 1A
	sta.b d4		; $80D053: 85 63
	lda.b d2		; $80D055: A5 5B
	sec		; $80D057: 38
	sbc.b d4		; $80D058: E5 63
	beq .mouth		; $80D05A: F0 09
	bmi .v8		; $80D05C: 30 05
	bvs .mouth		; $80D05E: 70 05
.se2:
	jmp.w .sideentry		; $80D060: 4C 14 D1
.v8:
	bvs .se2		; $80D063: 70 FB
.mouth:		;crossed between the posts
	stz.b d1		; $80D065: 64 57
	lda.w pucky		; $80D067: AD 7B 09  puck on the back side: wallcoll
	eor.b d0		; $80D06A: 45 53
	bpl .pf		; $80D06C: 10 03
	jmp.w wallcoll		; $80D06E: 4C DE CC
.pf:
	lda.b d0		; $80D071: A5 53
	eor.w #$FFFF		; $80D073: 49 FF FF
	inc a		; $80D076: 1A
	sta.b d0		; $80D077: 85 53
	lda.w pfgoal+puckobj		; $80D079: AD 5B 11  own goal by the carrier: wallcoll
	beq .z13		; $80D07C: F0 03
	jmp.w wallcoll		; $80D07E: 4C DE CC
.z13:		;at the crossbar height: off the post
	lda.w Zpos+puckobj		; $80D081: AD BB 09
	cmp.w #$000D		; $80D084: C9 0D 00
	beq .deflectsf		; $80D087: F0 2D
	lda.b d4		; $80D089: A5 63  mouth = half width - 5
	sec		; $80D08B: 38
	sbc.w #$0005		; $80D08C: E9 05 00
	sta.b d4		; $80D08F: 85 63
	lda.b d2		; $80D091: A5 5B
	sec		; $80D093: 38
	sbc.b d4		; $80D094: E5 63
	beq .ml		; $80D096: F0 08
	bmi .v9		; $80D098: 30 04
	bvs .ml		; $80D09A: 70 04
	bra .deflectsf		; $80D09C: 80 18
.v9:
	bvs .deflectsf		; $80D09E: 70 16
.ml:
	lda.b d4		; $80D0A0: A5 63
	eor.w #$FFFF		; $80D0A2: 49 FF FF
	inc a		; $80D0A5: 1A
	sta.b d4		; $80D0A6: 85 63
	lda.b d2		; $80D0A8: A5 5B
	sec		; $80D0AA: 38
	sbc.b d4		; $80D0AB: E5 63
	bmi .v10		; $80D0AD: 30 05
	bvs .deflectsf		; $80D0AF: 70 05
.goal:
	jmp.w Goal		; $80D0B1: 4C 82 D1
.v10:
	bvs .goal		; $80D0B4: 70 FB
.deflectsf:		;off the post
	jsl.l ChkShotStat		; $80D0B6: 22 2E D1 80  off the post: sfx and crowd +300
	lda.w #SFXpost		; $80D0BA: A9 94 00
	pha		; $80D0BD: 48
	jsl.l sfx		; $80D0BE: 22 8B C2 80
	lda.b crowdlevel		; $80D0C2: A5 DE
	clc		; $80D0C4: 18
	adc.w #$012C		; $80D0C5: 69 2C 01
	sta.b crowdlevel		; $80D0C8: 85 DE
	lda.w #$1000		; $80D0CA: A9 00 10  random Yvel away from the goal, Xvel/Zvel +-$1000
	jsl.l randoma		; $80D0CD: 22 8B AE 80
	sta.b d0		; $80D0D1: 85 53
	lda.w pucky		; $80D0D3: AD 7B 09
	bmi .df0		; $80D0D6: 30 08
	lda.b d0		; $80D0D8: A5 53
	eor.w #$FFFF		; $80D0DA: 49 FF FF
	inc a		; $80D0DD: 1A
	sta.b d0		; $80D0DE: 85 53
.df0:
	lda.b d0		; $80D0E0: A5 53
	sta.w puckvy		; $80D0E2: 8D 1B 0B
	lda.w #$2000		; $80D0E5: A9 00 20
	jsl.l randoma		; $80D0E8: 22 8B AE 80
	sec		; $80D0EC: 38
	sbc.w #$1000		; $80D0ED: E9 00 10
	sta.w puckvx		; $80D0F0: 8D FB 0A
	lda.w #$2000		; $80D0F3: A9 00 20
	jsl.l randoma		; $80D0F6: 22 8B AE 80
	sec		; $80D0FA: 38
	sbc.w #$1000		; $80D0FB: E9 00 10
	sta.w puckvz		; $80D0FE: 8D 3B 0B
	jmp.w puckflip		; $80D101: 4C C9 CE
.deflectz:		;Zvel = |Zvel|
	lda.w puckvz		; $80D104: AD 3B 0B
	bit.w #$8000		; $80D107: 89 00 80
	beq .dz		; $80D10A: F0 04
	eor.w #$FFFF		; $80D10C: 49 FF FF
	inc a		; $80D10F: 1A
.dz:
	sta.w puckvz		; $80D110: 8D 3B 0B
.rtl:
	rtl		; $80D113: 6B
.sideentry:		;off the side: wallcoll with normal (0, +-256)
	stz.b d0		; $80D114: 64 53
	lda.w #$0100		; $80D116: A9 00 01  d1 = +-256 by the x movement
	sta.b d1		; $80D119: 85 57
	lda.w puckx		; $80D11B: AD 1B 09
	sec		; $80D11E: 38
	sbc.w OldXpos+puckobj		; $80D11F: ED 3B 0A
	sta.b d2		; $80D122: 85 5B
	bmi .wc		; $80D124: 30 05
	lda.w #$FF00		; $80D126: A9 00 FF
	sta.b d1		; $80D129: 85 57
.wc:
	jmp.w wallcoll		; $80D12B: 4C DE CC
ChkShotStat:		;auto: CODE_80D12E. 93G ChkShotStat (penalty93_2): if a shot was taken (sf2shot, cleared here), add 1 to the shooting team tmshots
	lda.w #sf2shot		; $80D12E: A9 00 10
	trb.w sflags		; $80D131: 1C 8C 12
	beq .rtl		; $80D134: F0 38
	stx.b xsave		; $80D136: 86 0A
	ldx.w #$0000		; $80D138: A2 00 00
.push:
	lda.b d0,x		; $80D13B: B5 53
	pha		; $80D13D: 48
	inx		; $80D13E: E8
	inx		; $80D13F: E8
	cpx.w #$0008		; $80D140: E0 08 00
	bne .push		; $80D143: D0 F6
	ldx.b xsave		; $80D145: A6 0A
	phx		; $80D147: DA
	lda.w shotplayer		; $80D148: AD A5 04
	asl a		; $80D14B: 0A
	tax		; $80D14C: AA
	stx.b a3		; $80D14D: 86 3F  a3 = the shooter
	lda.w #$0001		; $80D14F: A9 01 00
	sta.b d0		; $80D152: 85 53
	lda.w #tmshots		; $80D154: A9 B2 13
	sta.b d1		; $80D157: 85 57
	jsl.l addteamstat		; $80D159: 22 6F D1 80
	plx		; $80D15D: FA
	stx.b a3		; $80D15E: 86 3F
	stx.b xsave		; $80D160: 86 0A
	ldx.w #$0006		; $80D162: A2 06 00
.pop:
	pla		; $80D165: 68
	sta.b d0,x		; $80D166: 95 53
	dex		; $80D168: CA
	dex		; $80D169: CA
	bpl .pop		; $80D16A: 10 F9
	ldx.b xsave		; $80D16C: A6 0A
.rtl:
	rtl		; $80D16E: 6B
addteamstat:		;auto: CODE_80D16F. add d0 to the team word stat at d1 (+2 for team 2, pfteam of X). 93G inline in ChkShotStat
	ldy.b d1		; $80D16F: A4 57  pfteam: team 2 word
	lda.w pfteam,x		; $80D171: BD 9F 11
	beq .add		; $80D174: F0 02
	iny		; $80D176: C8
	iny		; $80D177: C8
.add:
	lda.w $0000,y		; $80D178: B9 00 00  absolute stat address in d1 (+$0000,y)
	clc		; $80D17B: 18
	adc.b d0		; $80D17C: 65 53
	sta.w $0000,y		; $80D17E: 99 00 00
	rtl		; $80D181: 6B
Goal:		;auto: CODE_80D182. 93G Goal (hockey93_04): puck in the goal. Score +1 for the scoring team (a2, a1 = the other team), siren, ScoreSum entry, goal counts, PenGoalStuff, printscores1, ascore for the scorers, puck into the net, siren SPA and PenGoal
	lda.w gmclock		; $80D182: AD 8A 12  clock stopped: no goal
	beq .go		; $80D185: F0 03
	jmp.w .rtl		; $80D187: 4C 28 D3
.go:		;puck must be moving into the net
	lda.w pucky		; $80D18A: AD 7B 09
	eor.w puckvy		; $80D18D: 4D 1B 0B
	bpl .in		; $80D190: 10 03
	jmp.w .rtl		; $80D192: 4C 28 D3
.in:
	jsl.l ChkShotStat		; $80D195: 22 2E D1 80  sound reset, siren, mute other sfx
	jsl.l $82FA1A		; $80D199: 22 1A FA 82  bank $82: reset the sound command queue
	lda.w #SFXsiren		; $80D19D: A9 A0 00
	pha		; $80D1A0: 48
	jsl.l sfx		; $80D1A1: 22 8B C2 80
	lda.b vcount		; $80D1A5: A5 00
	sta.w sfxmutetime		; $80D1A7: 8D A7 04
	jsl.l freezewindow		; $80D1AA: 22 78 C2 80
	lda.b crowdlevel		; $80D1AE: A5 DE  crowd +500
	clc		; $80D1B0: 18
	adc.w #$01F4		; $80D1B1: 69 F4 01
	sta.b crowdlevel		; $80D1B4: 85 DE
	stz.b a2		; $80D1B6: 64 3B  a2 = scoring team (0/2), a1 = other
	lda.w #$0002		; $80D1B8: A9 02 00
	sta.b a1		; $80D1BB: 85 37
	lda.w Ypos,x		; $80D1BD: BD 5F 09
	bpl .g0		; $80D1C0: 10 07
	stz.b a1		; $80D1C2: 64 37
	lda.w #$0002		; $80D1C4: A9 02 00
	sta.b a2		; $80D1C7: 85 3B
.g0:
	lda.w gmode		; $80D1C9: AD 88 12  gmdir: swap
	bit.w #gmdir		; $80D1CC: 89 02 00
	beq .g1		; $80D1CF: F0 09
	lda.b a1		; $80D1D1: A5 37
	sta.b a2		; $80D1D3: 85 3B
	eor.w #$0002		; $80D1D5: 49 02 00
	sta.b a1		; $80D1D8: 85 37
.g1:
	ldy.b a2		; $80D1DA: A4 3B
	lda.w tmscore,y		; $80D1DC: B9 D6 13
	inc a		; $80D1DF: 1A
	sta.w tmscore,y		; $80D1E0: 99 D6 13
	lda.w ScoreSumbytes		; $80D1E3: AD FC 12  ScoreSum full (30 entries): overwrite the last
	cmp.w #$00B4		; $80D1E6: C9 B4 00
	bne .sum		; $80D1E9: D0 07
	sec		; $80D1EB: 38
	sbc.w #$0006		; $80D1EC: E9 06 00
	sta.w ScoreSumbytes		; $80D1EF: 8D FC 12
.sum:
	lda.w #$0000		; $80D1F2: A9 00 00
	sta.b a0+2		; $80D1F5: 85 35
	lda.w #ScoreSum		; $80D1F7: A9 FE 12
	clc		; $80D1FA: 18
	adc.w ScoreSumbytes		; $80D1FB: 6D FC 12
	sta.b a0		; $80D1FE: 85 33
	lda.w ScoreSumbytes		; $80D200: AD FC 12
	adc.w #$0006		; $80D203: 69 06 00
	sta.w ScoreSumbytes		; $80D206: 8D FC 12
	jsl.l $86FC8A		; $80D209: 22 8A FC 86  entry word 0 = time, bank $86: 93G GetPeriodTimeRemaining (d0)
	lda.b d0		; $80D20D: A5 53
	sta.b [a0]		; $80D20F: 87 33
	inc.b a0		; $80D211: E6 33
	inc.b a0		; $80D213: E6 33
	lda.w #$0002		; $80D215: A9 02 00  byte 2 = 2 + tmap(a2) - tmap(a1), bit 7 = away team scored
	clc		; $80D218: 18
	ldy.b a2		; $80D219: A4 3B
	adc.w tmap,y		; $80D21B: 79 EE 13
	ldy.b a1		; $80D21E: A4 37
	sec		; $80D220: 38
	sbc.w tmap,y		; $80D221: F9 EE 13
	ldy.b a2		; $80D224: A4 3B
	beq .home		; $80D226: F0 03
	ora.w #$0080		; $80D228: 09 80 00
.home:
	sta.b [a0]		; $80D22B: 87 33
	inc.b a0		; $80D22D: E6 33
	lda.w tmtouch1,y		; $80D22F: B9 E2 13  byte 3 = scorer; no assists yet
	sta.b d0		; $80D232: 85 53
	sta.b [a0]		; $80D234: 87 33
	inc.b a0		; $80D236: E6 33
	lda.w #$FFFF		; $80D238: A9 FF FF
	sta.b [a0]		; $80D23B: 87 33
	lda.b a2		; $80D23D: A5 3B  goals +1 for the scorer
	beq .h1		; $80D23F: F0 03
	lda.w #$001A		; $80D241: A9 1A 00
.h1:
	clc		; $80D244: 18
	adc.b d0		; $80D245: 65 53
	tay		; $80D247: A8
	sep #$20		; $80D248: E2 20
	lda.w tmgoals,y		; $80D24A: B9 12 14
	inc a		; $80D24D: 1A
	sta.w tmgoals,y		; $80D24E: 99 12 14
	rep #$20		; $80D251: C2 20
	ldy.b a2		; $80D253: A4 3B  assists
	lda.w tmtouch2,y		; $80D255: B9 E6 13
	bmi .noast		; $80D258: 30 13
	sep #$20		; $80D25A: E2 20
	sta.b [a0]		; $80D25C: 87 33
	rep #$20		; $80D25E: C2 20
	inc.b a0		; $80D260: E6 33
	lda.w tmtouch3,y		; $80D262: B9 EA 13
	bmi .noast		; $80D265: 30 06
	sep #$20		; $80D267: E2 20
	sta.b [a0]		; $80D269: 87 33
	rep #$20		; $80D26B: C2 20
.noast:
	jsl.l PenGoalStuff		; $80D26D: 22 29 D3 80  PenGoalStuff, printscores1, ascore for the scoring team
	jsl.l $89E95D		; $80D271: 22 5D E9 89  bank $89: 93G printscores1
	lda.w #ascore		; $80D275: A9 07 00
	sta.b d0		; $80D278: 85 53
	jsl.l .setass		; $80D27A: 22 02 D3 80
	lda.b a2		; $80D27E: A5 3B  home team within 3 after scoring: goal cue
	bne .nocue		; $80D280: D0 11
	lda.w tmscore+2		; $80D282: AD D8 13
	sec		; $80D285: 38
	sbc.w tmscore		; $80D286: ED D6 13
	bmi .nocue		; $80D289: 30 08
	cmp.w #$0003		; $80D28B: C9 03 00
	bcs .nocue		; $80D28E: B0 03
	inc.w goalcue		; $80D290: EE 29 04
.nocue:
	stz.b collflag		; $80D293: 64 D8  puck into the net at (+-6, +-$110), Zvel $600
	stz.w puckvx		; $80D295: 9C FB 0A
	stz.w puckvy		; $80D298: 9C 1B 0B
	lda.w #$0006		; $80D29B: A9 06 00
	sta.b d0		; $80D29E: 85 53
	lda.w puckx		; $80D2A0: AD 1B 09
	bpl .px		; $80D2A3: 10 05
	lda.w #$FFFA		; $80D2A5: A9 FA FF
	sta.b d0		; $80D2A8: 85 53
.px:
	lda.b d0		; $80D2AA: A5 53
	sta.w puckx		; $80D2AC: 8D 1B 09
	lda.w #$0110		; $80D2AF: A9 10 01
	sta.b d0		; $80D2B2: 85 53
	lda.w pucky		; $80D2B4: AD 7B 09
	bpl .py		; $80D2B7: 10 05
	lda.w #$FEF0		; $80D2B9: A9 F0 FE
	sta.b d0		; $80D2BC: 85 53
.py:
	lda.b d0		; $80D2BE: A5 53
	sta.w pucky		; $80D2C0: 8D 7B 09
	lda.w #$0600		; $80D2C3: A9 00 06
	sta.w puckvz		; $80D2C6: 8D 3B 0B
	stz.w Zpos+puckobj		; $80D2C9: 9C BB 09
	lda.w #$FFFF		; $80D2CC: A9 FF FF  puckcross never; pfnc
	sta.w puckcross+2		; $80D2CF: 8D 8B 04
	sta.w puckcross+6		; $80D2D2: 8D 8F 04
	sta.w pfnc+puckobj		; $80D2D5: 8D 1B 12
	lda.w #pnothing		; $80D2D8: A9 1A 00
	sta.b d0		; $80D2DB: 85 53
	jsl.l assreplace		; $80D2DD: 22 A7 B4 80
	inx		; $80D2E1: E8  shadow: siren anim
	inx		; $80D2E2: E8
	lda.w #SPAsiren		; $80D2E3: A9 DA 10
	sta.b d1		; $80D2E6: 85 57
	jsl.l SetSPA		; $80D2E8: 22 06 B0 80
	ldy.b a2		; $80D2EC: A4 3B  PenGoal for the first object of team a2
	ldx.w tmsort,y		; $80D2EE: BE D2 13
	stx.b a3		; $80D2F1: 86 3F
	lda.w #PenGoal		; $80D2F3: A9 0E 00
	sta.b d0		; $80D2F6: 85 53
	jsl.l AddPenalty2		; $80D2F8: 22 B0 C1 80
	ldx.w #puckobj		; $80D2FC: A2 1C 00
	stx.b a3		; $80D2FF: 86 3F
	rtl		; $80D301: 6B
.setass:		;IDA ResetTeamPlayerAssignments: give each skater of team a2 that is not fighting assignment d0, clear pfnc
	phx		; $80D302: DA
	ldy.b a2		; $80D303: A4 3B
	lda.w tmsort,y		; $80D305: B9 D2 13
	tax		; $80D308: AA
	lda.w #$0005		; $80D309: A9 05 00
	sta.b d3		; $80D30C: 85 5F
.loop:
	lda.w position,x		; $80D30E: BD 9F 0B
	bmi .nl		; $80D311: 30 0E
	beq .nl		; $80D313: F0 0C
	lda.w pf2fight,x		; $80D315: BD 5F 11
	bne .nl		; $80D318: D0 07
	stz.w pfnc,x		; $80D31A: 9E FF 11
	jsl.l assinsert		; $80D31D: 22 9D B4 80
.nl:
	inx		; $80D321: E8
	inx		; $80D322: E8
	dec.b d3		; $80D323: C6 5F
	bpl .loop		; $80D325: 10 E7
	plx		; $80D327: FA
.rtl:
	rtl		; $80D328: 6B
PenGoalStuff:		;auto: CODE_80D329. 93G PenGoalStuff (penalty93_1): after a goal. a1 = scored on team, a2 = scoring team. If the scoring team had more players on the ice, release the first scored on player in the box without a coincidental penalty
	stx.b xsave		; $80D329: 86 0A
	ldx.w #$0000		; $80D32B: A2 00 00
.pushd:
	lda.b d0,x		; $80D32E: B5 53
	pha		; $80D330: 48
	inx		; $80D331: E8
	inx		; $80D332: E8
	cpx.w #$000C		; $80D333: E0 0C 00
	bne .pushd		; $80D336: D0 F6
	ldx.b xsave		; $80D338: A6 0A
	stx.b xsave		; $80D33A: 86 0A
	ldx.w #$0000		; $80D33C: A2 00 00
.pusha:
	lda.b a0,x		; $80D33F: B5 33
	pha		; $80D341: 48
	inx		; $80D342: E8
	inx		; $80D343: E8
	cpx.w #$0004		; $80D344: E0 04 00
	bne .pusha		; $80D347: D0 F6
	ldx.b xsave		; $80D349: A6 0A
	jsl.l $8FE2F9		; $80D34B: 22 F9 E2 8F  ClearPenaltyBuffer, bank $8F: 93G ClearPenaltyBuffer
	ldy.b a2		; $80D34F: A4 3B
	lda.w tmap,y		; $80D351: B9 EE 13  tmap(a2) - tmap(a1) > 0?
	ldy.b a1		; $80D354: A4 37
	sec		; $80D356: 38
	sbc.w tmap,y		; $80D357: F9 EE 13
	beq .ex		; $80D35A: F0 5A
	bmi .v1		; $80D35C: 30 04
	bvc .more		; $80D35E: 50 04
	bra .ex		; $80D360: 80 54
.v1:
	bvc .ex		; $80D362: 50 52
.more:		;scoring team had more players on the ice
	lda.b a1		; $80D364: A5 37
	beq .lst		; $80D366: F0 03
	lda.w #$001A		; $80D368: A9 1A 00
.lst:
	sta.b a0		; $80D36B: 85 33
.loop:		;next player in the box list (negative = end)
	ldy.b a0		; $80D36D: A4 33
	lda.w tmboxlist,y		; $80D36F: B9 4A 15
	inc.b a0		; $80D372: E6 33
	and.w #$00FF		; $80D374: 29 FF 00
	sta.b d2		; $80D377: 85 5B
	bit.w #$0080		; $80D379: 89 80 00
	bne .ex		; $80D37C: D0 38
	lda.b a1		; $80D37E: A5 37
	beq .tm		; $80D380: F0 03
	lda.w #$0034		; $80D382: A9 34 00
.tm:
	clc		; $80D385: 18
	adc.b d2		; $80D386: 65 5B
	tay		; $80D388: A8
	lda.w tmpdst,y		; $80D389: B9 E2 14  coincidental penalty: skip
	bit.w #$4000		; $80D38C: 89 00 40
	bne .loop		; $80D38F: D0 DC
	lda.w #$0000		; $80D391: A9 00 00  out of the box, one more on the ice, power play goal
	sta.w tmpdst,y		; $80D394: 99 E2 14
	jsl.l $8FDAFC		; $80D397: 22 FC DA 8F  bank $8F: 93G RemovePlayerFromList
	ldy.b a1		; $80D39B: A4 37
	lda.w tmap,y		; $80D39D: B9 EE 13
	inc a		; $80D3A0: 1A
	sta.w tmap,y		; $80D3A1: 99 EE 13
	ldy.b a2		; $80D3A4: A4 3B
	lda.w tmPwrGoals,y		; $80D3A6: B9 B6 13
	inc a		; $80D3A9: 1A
	sta.w tmPwrGoals,y		; $80D3AA: 99 B6 13
	lda.w #tmflcc		; $80D3AD: A9 01 00
	tsb.w tmflags		; $80D3B0: 0C 0A 14  line change box redraw
	tsb.w tmflags+2		; $80D3B3: 0C 0C 14
.ex:
	stx.b xsave		; $80D3B6: 86 0A
	ldx.w #$0002		; $80D3B8: A2 02 00
.popa:
	pla		; $80D3BB: 68
	sta.b a0,x		; $80D3BC: 95 33
	dex		; $80D3BE: CA
	dex		; $80D3BF: CA
	bpl .popa		; $80D3C0: 10 F9
	ldx.b xsave		; $80D3C2: A6 0A
	stx.b xsave		; $80D3C4: 86 0A
	ldx.w #$000A		; $80D3C6: A2 0A 00
.popd:
	pla		; $80D3C9: 68
	sta.b d0,x		; $80D3CA: 95 53
	dex		; $80D3CC: CA
	dex		; $80D3CD: CA
	bpl .popd		; $80D3CE: 10 F9
	ldx.b xsave		; $80D3D0: A6 0A
	rtl		; $80D3D2: 6B
checkgoalp:		;auto: CODE_80D3D3. 93G checkgoalp (hockey93_04): player X collision with the goal/net a2 (oval, radius x 32, y 11). CheckBump, then wallcoll with the normal
	lda.w pflags,x		; $80D3D3: BD DF 0E
	bit.w #pf2npc		; $80D3D6: 89 00 80
	beq .npc		; $80D3D9: F0 03
	jmp.w .rtl		; $80D3DB: 4C C4 D4
.npc:
	lda.w Zpos,x		; $80D3DE: BD 9F 09
	sec		; $80D3E1: 38
	sbc.w #$000A		; $80D3E2: E9 0A 00
	beq .pl		; $80D3E5: F0 09
	bmi .v1		; $80D3E7: 30 05
	bvs .pl		; $80D3E9: 70 05
.ex1:
	jmp.w .rtl		; $80D3EB: 4C C4 D4
.v1:
	bvs .ex1		; $80D3EE: 70 FB
.pl:		;players only (SCnum <= 11)
	cpx.w #$0017		; $80D3F0: E0 17 00
	bcc .go		; $80D3F3: 90 03
	jmp.w .rtl		; $80D3F5: 4C C4 D4
.go:
	ldy.b a2		; $80D3F8: A4 3B  d0 = -dy, d1 = dx
	lda.b d3		; $80D3FA: A5 5F
	pha		; $80D3FC: 48
	sec		; $80D3FD: 38
	sbc.w Ypos,y		; $80D3FE: F9 5F 09
	sta.b d3		; $80D401: 85 5F
	eor.w #$FFFF		; $80D403: 49 FF FF
	inc a		; $80D406: 1A
	sta.b d0		; $80D407: 85 53
	lda.b d2		; $80D409: A5 5B
	pha		; $80D40B: 48
	sec		; $80D40C: 38
	sbc.w Xpos,y		; $80D40D: F9 FF 08
	sta.b d1		; $80D410: 85 57
	asl a		; $80D412: 0A
	asl a		; $80D413: 0A
	asl a		; $80D414: 0A
	asl a		; $80D415: 0A
	sta.b mula		; $80D416: 85 7D
	sta.b mulb		; $80D418: 85 83
	jsl.l $82FCDB		; $80D41A: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.w #$0400		; $80D41E: A9 00 04
	sta.b mula		; $80D421: 85 7D
	jsl.l divu		; $80D423: 22 E5 CB 80
	cmp.w #$0101		; $80D427: C9 01 01
	bcc .inx		; $80D42A: 90 03
	jmp.w .exit		; $80D42C: 4C BE D4
.inx:		;(dy*16)^2/$79 + (dx*16)^2/$400 <= $100?
	sta.b d2		; $80D42F: 85 5B
	lda.b d3		; $80D431: A5 5F
	asl a		; $80D433: 0A
	asl a		; $80D434: 0A
	asl a		; $80D435: 0A
	asl a		; $80D436: 0A
	sta.b mula		; $80D437: 85 7D
	sta.b mulb		; $80D439: 85 83
	jsl.l $82FCDB		; $80D43B: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.w #$0079		; $80D43F: A9 79 00
	sta.b mula		; $80D442: 85 7D
	jsl.l divu		; $80D444: 22 E5 CB 80
	adc.b d2		; $80D448: 65 5B
	cmp.w #$0101		; $80D44A: C9 01 01
	bcs .exit		; $80D44D: B0 6F
	pla		; $80D44F: 68
	sta.b d2		; $80D450: 85 5B
	pla		; $80D452: 68
	sta.b d3		; $80D453: 85 5F
	jsl.l CheckBump		; $80D455: 22 C5 D4 80  CheckBump, then wallcoll with the normal (d0,d1)/r
	lda.b d3		; $80D459: A5 5F
	pha		; $80D45B: 48
	lda.b d2		; $80D45C: A5 5B
	pha		; $80D45E: 48
	lda.b d1		; $80D45F: A5 57
	pha		; $80D461: 48
	lda.b d0		; $80D462: A5 53
	pha		; $80D464: 48
	sta.b mula		; $80D465: 85 7D
	sta.b mulb		; $80D467: 85 83
	jsl.l $82FCDB		; $80D469: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $80D46D: 85 53
	lda.b mulres+2		; $80D46F: A5 95
	sta.b d0+2		; $80D471: 85 55
	lda.b d1		; $80D473: A5 57
	sta.b mula		; $80D475: 85 7D
	sta.b mulb		; $80D477: 85 83
	jsl.l $82FCDB		; $80D479: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $80D47D: 65 53
	sta.b d0		; $80D47F: 85 53
	lda.b d0+2		; $80D481: A5 55
	adc.b mulres+2		; $80D483: 65 95
	sta.b d0+2		; $80D485: 85 55
	jsl.l sroot		; $80D487: 22 B1 CB 80
	inc a		; $80D48B: 1A
	sta.b d2		; $80D48C: 85 5B
	sta.b mula		; $80D48E: 85 7D
	pla		; $80D490: 68
	sta.b d0		; $80D491: 85 53
	pla		; $80D493: 68
	sta.b d1		; $80D494: 85 57
	stz.b mulb		; $80D496: 64 83
	lda.b d0		; $80D498: A5 53
	sta.b mulb+1		; $80D49A: 85 84
	lda.b d0+2		; $80D49C: A5 55
	sta.b mulb+3		; $80D49E: 85 86
	jsl.l divs		; $80D4A0: 22 6C 99 80
	sta.b d0		; $80D4A4: 85 53
	lda.b d2		; $80D4A6: A5 5B
	sta.b mula		; $80D4A8: 85 7D
	stz.b mulb		; $80D4AA: 64 83
	lda.b d1		; $80D4AC: A5 57
	sta.b mulb+1		; $80D4AE: 85 84
	lda.b d1+2		; $80D4B0: A5 59
	sta.b mulb+3		; $80D4B2: 85 86
	jsl.l divs		; $80D4B4: 22 6C 99 80
	sta.b d1		; $80D4B8: 85 57
	jsl.l wallcoll		; $80D4BA: 22 DE CC 80
.exit:
	pla		; $80D4BE: 68
	sta.b d2		; $80D4BF: 85 5B
	pla		; $80D4C1: 68
	sta.b d3		; $80D4C2: 85 5F
.rtl:
	rtl		; $80D4C4: 6B
CheckBump:		;auto: CODE_80D4C5. 93G CheckBump (hockey93_04): goalie X against the net a2 with the puck near (1 in 32): if moving faster than $2000, bump the net (Xvel/Yvel / 4), stop and call PenGhold
	stx.b xsave		; $80D4C5: 86 0A
	ldx.w #$0000		; $80D4C7: A2 00 00
.push:
	lda.b d0,x		; $80D4CA: B5 53
	pha		; $80D4CC: 48
	inx		; $80D4CD: E8
	inx		; $80D4CE: E8
	cpx.w #$0008		; $80D4CF: E0 08 00
	bne .push		; $80D4D2: D0 F6
	ldx.b xsave		; $80D4D4: A6 0A
	lda.w seed		; $80D4D6: AD A1 04  1 in 32 frames
	and.w #$001F		; $80D4D9: 29 1F 00
	bne .exit		; $80D4DC: D0 3F
	ldy.b a2		; $80D4DE: A4 3B
	lda.w pucky		; $80D4E0: AD 7B 09  puck within 41 of the net in y
	sec		; $80D4E3: 38
	sbc.w Ypos,y		; $80D4E4: F9 5F 09
	bit.w #$8000		; $80D4E7: 89 00 80
	beq .dy		; $80D4EA: F0 04
	eor.w #$FFFF		; $80D4EC: 49 FF FF
	inc a		; $80D4EF: 1A
.dy:
	cmp.w #$0029		; $80D4F0: C9 29 00
	bcs .exit		; $80D4F3: B0 28
	lda.w Xvel,x		; $80D4F5: BD DF 0A
	sta.b d0		; $80D4F8: 85 53
	lda.w Yvel,x		; $80D4FA: BD FF 0A
	sta.b d1		; $80D4FD: 85 57
	bit.w #$8000		; $80D4FF: 89 00 80
	beq .vy		; $80D502: F0 04
	eor.w #$FFFF		; $80D504: 49 FF FF
	inc a		; $80D507: 1A
.vy:
	cmp.w #$2001		; $80D508: C9 01 20
	bcs .bb		; $80D50B: B0 1F
	lda.b d0		; $80D50D: A5 53
	bit.w #$8000		; $80D50F: 89 00 80
	beq .vx		; $80D512: F0 04
	eor.w #$FFFF		; $80D514: 49 FF FF
	inc a		; $80D517: 1A
.vx:
	cmp.w #$2001		; $80D518: C9 01 20
	bcs .bb		; $80D51B: B0 0F
.exit:
	stx.b xsave		; $80D51D: 86 0A
	ldx.w #$0006		; $80D51F: A2 06 00
.pop:
	pla		; $80D522: 68
	sta.b d0,x		; $80D523: 95 53
	dex		; $80D525: CA
	dex		; $80D526: CA
	bpl .pop		; $80D527: 10 F9
	ldx.b xsave		; $80D529: A6 0A
.rtl:
	rtl		; $80D52B: 6B
.bb:		;drop the saved d0-d3 and the jsl return: return to the caller of checkgoalp
	pla		; $80D52C: 68
	pla		; $80D52D: 68
	pla		; $80D52E: 68
	pla		; $80D52F: 68
	pla		; $80D530: 68
	sep #$20		; $80D531: E2 20
	pla		; $80D533: 68
	rep #$30		; $80D534: C2 30
	lda.b d0		; $80D536: A5 53  net Xvel/Yvel = speed / 4; player stops
	lsr a		; $80D538: 4A
	lsr a		; $80D539: 4A
	bit.w #$2000		; $80D53A: 89 00 20
	beq .sx		; $80D53D: F0 03
	ora.w #$C000		; $80D53F: 09 00 C0
.sx:
	sta.b d0		; $80D542: 85 53
	ldy.b a2		; $80D544: A4 3B
	sta.w Xvel,y		; $80D546: 99 DF 0A
	lda.b d1		; $80D549: A5 57
	lsr a		; $80D54B: 4A
	lsr a		; $80D54C: 4A
	bit.w #$2000		; $80D54D: 89 00 20
	beq .sy		; $80D550: F0 03
	ora.w #$C000		; $80D552: 09 00 C0
.sy:
	sta.b d1		; $80D555: 85 57
	sta.w Yvel,y		; $80D557: 99 FF 0A
	stz.w Xvel,x		; $80D55A: 9E DF 0A
	stz.w Yvel,x		; $80D55D: 9E FF 0A
	lda.w #sfslock		; $80D560: A9 40 00
	tsb.w sflags		; $80D563: 0C 8C 12
	lda.w gmclock		; $80D566: AD 8A 12
	bne .rtl		; $80D569: D0 C0
	lda.w #PenGhold		; $80D56B: A9 08 00
	sta.b d0		; $80D56E: 85 53
	jmp.w AddPenalty2		; $80D570: 4C B0 C1
checkplcoll:		;auto: CODE_80D573. 93G checkplcoll (hockey93_03): d2/d3 = x/y, X = object. Walk up and down the OOlist from X and call checkcx for each object within 14 in y
	lda.w pflags,x		; $80D573: BD DF 0E
	bit.w #pf2npc		; $80D576: 89 00 80
	beq .pl		; $80D579: F0 03
	jmp.w .ex		; $80D57B: 4C 31 D6
.pl:
	cpx.w #$0018		; $80D57E: E0 18 00
	bcc .go		; $80D581: 90 03
	jmp.w .ex		; $80D583: 4C 31 D6
.go:
	lda.w OOlistpos,x		; $80D586: BD 3F 12  d1 = position of X in OOlist
	sta.b d1		; $80D589: 85 57
.up:		;objects higher in the list
	ldy.b d1		; $80D58B: A4 57
	cpy.w #$000F		; $80D58D: C0 0F 00  top of the list
	beq .cl		; $80D590: F0 4B
	lda.w OOlist+1,y		; $80D592: B9 60 12
	and.w #$00FF		; $80D595: 29 FF 00
	sta.b d4		; $80D598: 85 63
	tay		; $80D59A: A8
	lda.w Ylist,y		; $80D59B: B9 1F 12
	sec		; $80D59E: 38
	sbc.b d3		; $80D59F: E5 5F
	sta.b d5		; $80D5A1: 85 67
	sec		; $80D5A3: 38
	sbc.w #$000E		; $80D5A4: E9 0E 00
	beq .uy		; $80D5A7: F0 08
	bmi .v1		; $80D5A9: 30 04
	bvs .uy		; $80D5AB: 70 04
	bra .cl		; $80D5AD: 80 2E
.v1:
	bvs .cl		; $80D5AF: 70 2C
.uy:
	lda.w Xpos,y		; $80D5B1: B9 FF 08
	sec		; $80D5B4: 38
	sbc.b d2		; $80D5B5: E5 5B
	bit.w #$8000		; $80D5B7: 89 00 80
	beq .ux		; $80D5BA: F0 04
	eor.w #$FFFF		; $80D5BC: 49 FF FF
	inc a		; $80D5BF: 1A
.ux:
	cmp.w #$000F		; $80D5C0: C9 0F 00
	bcs .unext		; $80D5C3: B0 14
	lda.w pflags,y		; $80D5C5: B9 DF 0E  not npc, nc, players only
	and.w #pf2npc		; $80D5C8: 29 00 80
	ora.w pfnc,y		; $80D5CB: 19 FF 11
	bne .unext		; $80D5CE: D0 09
	cpy.w #$0018		; $80D5D0: C0 18 00
	bcs .unext		; $80D5D3: B0 04
	jsl.l checkcx		; $80D5D5: 22 32 D6 80
.unext:
	inc.b d1		; $80D5D9: E6 57
	bra .up		; $80D5DB: 80 AE
.cl:		;objects lower in the list
	lda.w OOlistpos,x		; $80D5DD: BD 3F 12
	beq .ex		; $80D5E0: F0 4F
	sta.b d1		; $80D5E2: 85 57
.down:
	ldy.b d1		; $80D5E4: A4 57
	lda.w OOlist-1,y		; $80D5E6: B9 5E 12
	and.w #$00FF		; $80D5E9: 29 FF 00
	sta.b d4		; $80D5EC: 85 63
	tay		; $80D5EE: A8
	lda.b d3		; $80D5EF: A5 5F
	sec		; $80D5F1: 38
	sbc.w Ylist,y		; $80D5F2: F9 1F 12
	sta.b d5		; $80D5F5: 85 67
	sec		; $80D5F7: 38
	sbc.w #$000E		; $80D5F8: E9 0E 00
	beq .dy		; $80D5FB: F0 08
	bmi .v2		; $80D5FD: 30 04
	bvs .dy		; $80D5FF: 70 04
	bra .ex		; $80D601: 80 2E
.v2:
	bvs .ex		; $80D603: 70 2C
.dy:
	lda.w Xpos,y		; $80D605: B9 FF 08
	sec		; $80D608: 38
	sbc.b d2		; $80D609: E5 5B
	bit.w #$8000		; $80D60B: 89 00 80
	beq .dx		; $80D60E: F0 04
	eor.w #$FFFF		; $80D610: 49 FF FF
	inc a		; $80D613: 1A
.dx:
	cmp.w #$000F		; $80D614: C9 0F 00
	bcs .dnext		; $80D617: B0 14
	lda.w pflags,y		; $80D619: B9 DF 0E
	and.w #pf2npc		; $80D61C: 29 00 80
	ora.w pfnc,y		; $80D61F: 19 FF 11
	bne .dnext		; $80D622: D0 09
	cpy.w #$0018		; $80D624: C0 18 00
	bcs .dnext		; $80D627: B0 04
	jsl.l checkcx		; $80D629: 22 32 D6 80
.dnext:
	dec.b d1		; $80D62D: C6 57
	bne .down		; $80D62F: D0 B3
.ex:
	rtl		; $80D631: 6B
checkcx:		;auto: CODE_80D632. 93G checkcx (hockey93_03): Y = object near X. Opposing players add impact and run newcheck, checkint, checkcheck and checkfight; then momentum moves from X to a2 (weights + 140, elasticity evalue)
	stx.b xsave		; $80D632: 86 0A
	ldx.w #$0000		; $80D634: A2 00 00
.push:
	lda.b d0,x		; $80D637: B5 53
	pha		; $80D639: 48
	inx		; $80D63A: E8
	inx		; $80D63B: E8
	cpx.w #$0018		; $80D63C: E0 18 00
	bne .push		; $80D63F: D0 F6
	ldx.b xsave		; $80D641: A6 0A
	sty.b a2		; $80D643: 84 3B  a2 = Y; d0/d1 = relative velocity, d2/d3 = relative position
	stz.b evalue		; $80D645: 64 F2
	lda.w Xvel,x		; $80D647: BD DF 0A
	sec		; $80D64A: 38
	sbc.w Xvel,y		; $80D64B: F9 DF 0A
	sta.b d0		; $80D64E: 85 53
	lda.w Yvel,x		; $80D650: BD FF 0A
	sec		; $80D653: 38
	sbc.w Yvel,y		; $80D654: F9 FF 0A
	sta.b d1		; $80D657: 85 57
	sta.b mulb		; $80D659: 85 83
	lda.w Xpos,y		; $80D65B: B9 FF 08
	sec		; $80D65E: 38
	sbc.w Xpos,x		; $80D65F: FD FF 08
	sta.b d2		; $80D662: 85 5B
	lda.w Ypos,y		; $80D664: B9 5F 09
	sec		; $80D667: 38
	sbc.w Ypos,x		; $80D668: FD 5F 09
	sta.b d3		; $80D66B: 85 5F
	sta.b mula		; $80D66D: 85 7D
	lda.b d1		; $80D66F: A5 57
	pha		; $80D671: 48
	lda.b d0		; $80D672: A5 53
	pha		; $80D674: 48
	jsl.l $82FCDB		; $80D675: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d1		; $80D679: 85 57
	lda.b mulres+2		; $80D67B: A5 95
	sta.b d1+2		; $80D67D: 85 59
	lda.b d2		; $80D67F: A5 5B
	sta.b mula		; $80D681: 85 7D
	lda.b d0		; $80D683: A5 53
	sta.b mulb		; $80D685: 85 83
	jsl.l $82FCDB		; $80D687: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d1		; $80D68B: 65 57
	sta.b d1		; $80D68D: 85 57
	lda.b d1+2		; $80D68F: A5 59
	adc.b mulres+2		; $80D691: 65 95
	bpl .v1n		; $80D693: 10 03  v1n < 0: no collision
	jmp.w .exit4		; $80D695: 4C 77 D8
.v1n:		;V1n = (Vy*Dy + Vx*Dx) / 16
	lsr a		; $80D698: 4A
	ror.b d1		; $80D699: 66 57
	lsr a		; $80D69B: 4A
	ror.b d1		; $80D69C: 66 57
	lsr a		; $80D69E: 4A
	ror.b d1		; $80D69F: 66 57
	lsr a		; $80D6A1: 4A
	ror.b d1		; $80D6A2: 66 57
	lda.w pfteam,x		; $80D6A4: BD 9F 11  same team: no impact
	cmp.w pfteam,y		; $80D6A7: D9 9F 11
	beq .not		; $80D6AA: F0 59
	lda.b d1+1		; $80D6AC: A5 58
	and.w #$00FF		; $80D6AE: 29 FF 00
	sta.b d4		; $80D6B1: 85 63
	cmp.w #$0006		; $80D6B3: C9 06 00
	bcs .g40		; $80D6B6: B0 05
	lda.w #$0005		; $80D6B8: A9 05 00
	sta.b d4		; $80D6BB: 85 63
.g40:		;minimum impact 5
	clc		; $80D6BD: 18
	adc.w impact,x		; $80D6BE: 7D 7F 0B
	sta.w impact,x		; $80D6C1: 9D 7F 0B
	lda.w impact,y		; $80D6C4: B9 7F 0B
	clc		; $80D6C7: 18
	adc.b d4		; $80D6C8: 65 63
	sta.w impact,y		; $80D6CA: 99 7F 0B
	lda.w pf2fight,y		; $80D6CD: B9 5F 11  impactp = the other (not while fighting)
	bne .if		; $80D6D0: D0 05
	txa		; $80D6D2: 8A
	lsr a		; $80D6D3: 4A
	sta.w impactp,y		; $80D6D4: 99 3F 0B
.if:
	lda.w pf2fight,x		; $80D6D7: BD 5F 11
	bne .if2		; $80D6DA: D0 05
	tya		; $80D6DC: 98
	lsr a		; $80D6DD: 4A
	sta.w impactp,x		; $80D6DE: 9D 3F 0B
.if2:		;impact under 20: no check sound
	lda.b d4		; $80D6E1: A5 63
	cmp.w #$0014		; $80D6E3: C9 14 00
	bcc .n1		; $80D6E6: 90 11
	lda.w puckc		; $80D6E8: AD BB 0E  check sound only if one of them has the puck
	cmp.w SCnum,x		; $80D6EB: DD 9F 0D
	beq .nc		; $80D6EE: F0 05
	cmp.w SCnum,y		; $80D6F0: D9 9F 0D
	bne .n1		; $80D6F3: D0 04
.nc:
	jsl.l newcheck		; $80D6F5: 22 7B D8 80
.n1:
	jsl.l checkint		; $80D6F9: 22 8B D8 80
	jsl.l checkcheck		; $80D6FD: 22 12 DB 80
	jsl.l checkfight		; $80D701: 22 95 DC 80
.not:		;same team: no check events
	lda.b d1		; $80D705: A5 57
	sta.b d4		; $80D707: 85 63
	pla		; $80D709: 68
	sta.b d0		; $80D70A: 85 53
	pla		; $80D70C: 68
	sta.b d1		; $80D70D: 85 57
	lda.b collflag		; $80D70F: A5 D8  collflag set by holdcheck / Bcheck: no transfer
	bpl .tr		; $80D711: 10 03
	jmp.w .exit		; $80D713: 4C 68 D8
.tr:		;V1t = (Vx*Dy - Vy*Dx) / 16
	lda.b d2		; $80D716: A5 5B
	sta.b mula		; $80D718: 85 7D
	lda.b d1		; $80D71A: A5 57
	sta.b mulb		; $80D71C: 85 83
	jsl.l $82FCDB		; $80D71E: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d1		; $80D722: 85 57
	lda.b mulres+2		; $80D724: A5 95
	sta.b d1+2		; $80D726: 85 59
	lda.b d3		; $80D728: A5 5F
	sta.b mula		; $80D72A: 85 7D
	lda.b d0		; $80D72C: A5 53
	sta.b mulb		; $80D72E: 85 83
	jsl.l $82FCDB		; $80D730: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sec		; $80D734: 38
	sbc.b d1		; $80D735: E5 57
	sta.b d0		; $80D737: 85 53
	lda.b mulres+2		; $80D739: A5 95
	sbc.b d1+2		; $80D73B: E5 59
	lsr a		; $80D73D: 4A
	ror.b d0		; $80D73E: 66 53
	lsr a		; $80D740: 4A
	ror.b d0		; $80D741: 66 53
	lsr a		; $80D743: 4A
	ror.b d0		; $80D744: 66 53
	lsr a		; $80D746: 4A
	ror.b d0		; $80D747: 66 53
	lda.b d0		; $80D749: A5 53
	sta.b d5		; $80D74B: 85 67
	lda.w weight,x		; $80D74D: BD 3F 0F  weights + 140
	clc		; $80D750: 18
	adc.w #$008C		; $80D751: 69 8C 00
	sta.b d0		; $80D754: 85 53
	ldy.b a2		; $80D756: A4 3B
	lda.w weight,y		; $80D758: B9 3F 0F
	clc		; $80D75B: 18
	adc.w #$008C		; $80D75C: 69 8C 00
	sta.b d1		; $80D75F: 85 57
	sta.b mula		; $80D761: 85 7D
	lda.b evalue		; $80D763: A5 F2
	sta.b mulb		; $80D765: 85 83
	jsl.l $8D871C		; $80D767: 22 1C 87 8D  bank $8D: mulu, A = mula*mulb
	lsr a		; $80D76B: 4A
	lsr a		; $80D76C: 4A
	lsr a		; $80D76D: 4A
	lsr a		; $80D76E: 4A
	sta.b d7+2		; $80D76F: 85 71
	lda.b d1		; $80D771: A5 57
	clc		; $80D773: 18
	adc.b d0		; $80D774: 65 53
	sta.b d1		; $80D776: 85 57
	lda.b d0		; $80D778: A5 53
	sec		; $80D77A: 38
	sbc.b d7+2		; $80D77B: E5 71
	sta.b mulb		; $80D77D: 85 83
	lda.b d4		; $80D77F: A5 63
	sta.b mula		; $80D781: 85 7D
	jsl.l $82FCDB		; $80D783: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d1		; $80D787: A5 57
	sta.b mula		; $80D789: 85 7D
	jsl.l divs		; $80D78B: 22 6C 99 80
	sta.b d0		; $80D78F: 85 53
	lda.b evalue		; $80D791: A5 F2
	sta.b mulb		; $80D793: 85 83
	lda.b d4		; $80D795: A5 63
	sta.b mula		; $80D797: 85 7D
	jsl.l muls16		; $80D799: 22 96 84 80
	lsr a		; $80D79D: 4A
	lsr a		; $80D79E: 4A
	lsr a		; $80D79F: 4A
	lsr a		; $80D7A0: 4A
	bit.w #$0800		; $80D7A1: 89 00 08
	beq .v2n		; $80D7A4: F0 03
	ora.w #$F000		; $80D7A6: 09 00 F0
.v2n:		;V2n = V1n + V1n*e
	clc		; $80D7A9: 18
	adc.b d0		; $80D7AA: 65 53
	sta.b d1		; $80D7AC: 85 57
	lda.b d5		; $80D7AE: A5 67
	sta.b mula		; $80D7B0: 85 7D
	lda.b d3		; $80D7B2: A5 5F
	sta.b mulb		; $80D7B4: 85 83
	jsl.l $82FCDB		; $80D7B6: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b tmp0		; $80D7BA: 85 73
	lda.b mulres+2		; $80D7BC: A5 95
	sta.b tmp1		; $80D7BE: 85 75
	lda.b d0		; $80D7C0: A5 53
	sta.b mula		; $80D7C2: 85 7D
	lda.b d2		; $80D7C4: A5 5B
	sta.b mulb		; $80D7C6: 85 83
	jsl.l $82FCDB		; $80D7C8: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b tmp0		; $80D7CC: 65 73
	sta.b tmp0		; $80D7CE: 85 73
	lda.b tmp1		; $80D7D0: A5 75
	adc.b mulres+2		; $80D7D2: 65 95
	lsr a		; $80D7D4: 4A
	ror.b tmp0		; $80D7D5: 66 73
	lsr a		; $80D7D7: 4A
	ror.b tmp0		; $80D7D8: 66 73
	lsr a		; $80D7DA: 4A
	ror.b tmp0		; $80D7DB: 66 73
	lsr a		; $80D7DD: 4A
	ror.b tmp0		; $80D7DE: 66 73
	lda.w Xvel,y		; $80D7E0: B9 DF 0A
	clc		; $80D7E3: 18
	adc.b tmp0		; $80D7E4: 65 73
	sta.w Xvel,x		; $80D7E6: 9D DF 0A
	lda.b d5		; $80D7E9: A5 67
	sta.b mula		; $80D7EB: 85 7D
	lda.b d2		; $80D7ED: A5 5B
	sta.b mulb		; $80D7EF: 85 83
	jsl.l $82FCDB		; $80D7F1: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b tmp0		; $80D7F5: 85 73
	lda.b mulres+2		; $80D7F7: A5 95
	sta.b tmp1		; $80D7F9: 85 75
	lda.b d0		; $80D7FB: A5 53
	sta.b mula		; $80D7FD: 85 7D
	lda.b d3		; $80D7FF: A5 5F
	sta.b mulb		; $80D801: 85 83
	jsl.l $82FCDB		; $80D803: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sec		; $80D807: 38
	sbc.b tmp0		; $80D808: E5 73
	sta.b tmp0		; $80D80A: 85 73
	lda.b mulres+2		; $80D80C: A5 95
	sbc.b tmp1		; $80D80E: E5 75
	lsr a		; $80D810: 4A
	ror.b tmp0		; $80D811: 66 73
	lsr a		; $80D813: 4A
	ror.b tmp0		; $80D814: 66 73
	lsr a		; $80D816: 4A
	ror.b tmp0		; $80D817: 66 73
	lsr a		; $80D819: 4A
	ror.b tmp0		; $80D81A: 66 73
	lda.w Yvel,y		; $80D81C: B9 FF 0A
	clc		; $80D81F: 18
	adc.b tmp0		; $80D820: 65 73
	sta.w Yvel,x		; $80D822: 9D FF 0A
	lda.b d1		; $80D825: A5 57
	sta.b mula		; $80D827: 85 7D
	lda.b d2		; $80D829: A5 5B
	sta.b mulb		; $80D82B: 85 83
	jsl.l $82FCDB		; $80D82D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lsr.b mulres+2		; $80D831: 46 95
	ror a		; $80D833: 6A
	lsr.b mulres+2		; $80D834: 46 95
	ror a		; $80D836: 6A
	lsr.b mulres+2		; $80D837: 46 95
	ror a		; $80D839: 6A
	lsr.b mulres+2		; $80D83A: 46 95
	ror a		; $80D83C: 6A
	clc		; $80D83D: 18
	adc.w Xvel,y		; $80D83E: 79 DF 0A
	sta.w Xvel,y		; $80D841: 99 DF 0A
	lda.b d1		; $80D844: A5 57
	sta.b mula		; $80D846: 85 7D
	lda.b d3		; $80D848: A5 5F
	sta.b mulb		; $80D84A: 85 83
	jsl.l $82FCDB		; $80D84C: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lsr.b mulres+2		; $80D850: 46 95
	ror a		; $80D852: 6A
	lsr.b mulres+2		; $80D853: 46 95
	ror a		; $80D855: 6A
	lsr.b mulres+2		; $80D856: 46 95
	ror a		; $80D858: 6A
	lsr.b mulres+2		; $80D859: 46 95
	ror a		; $80D85B: 6A
	clc		; $80D85C: 18
	adc.w Yvel,y		; $80D85D: 79 FF 0A
	sta.w Yvel,y		; $80D860: 99 FF 0A
	lda.w #$FFFF		; $80D863: A9 FF FF  collflag
	sta.b collflag		; $80D866: 85 D8
.exit:
	stx.b xsave		; $80D868: 86 0A
	ldx.w #$0016		; $80D86A: A2 16 00
.pop:
	pla		; $80D86D: 68
	sta.b d0,x		; $80D86E: 95 53
	dex		; $80D870: CA
	dex		; $80D871: CA
	bpl .pop		; $80D872: 10 F9
	ldx.b xsave		; $80D874: A6 0A
	rtl		; $80D876: 6B
.exit4:		;drop the saved Vx/Vy
	pla		; $80D877: 68
	pla		; $80D878: 68
	bra .exit		; $80D879: 80 ED
newcheck:		;auto: CODE_80D87B. 93G newcheck (hockey93_03): check sound SFXcheck + random 0/1
	lda.w seed+1		; $80D87B: AD A2 04
	and.w #$0001		; $80D87E: 29 01 00
	clc		; $80D881: 18
	adc.w #SFXcheck		; $80D882: 69 90 00
	pha		; $80D885: 48
	jsl.l sfx		; $80D886: 22 8B C2 80
	rtl		; $80D88A: 6B
checkint:		;auto: CODE_80D88B. 93G checkint (hockey93_03): interference: goalie a2 against a3 and the other way round
	lda.b d0+2		; $80D88B: A5 55  a2 and a3 swapped for the second call
	pha		; $80D88D: 48
	lda.b d0		; $80D88E: A5 53
	pha		; $80D890: 48
	jsl.l .ci		; $80D891: 22 B0 D8 80
	ldx.b a2		; $80D895: A6 3B
	ldy.b a3		; $80D897: A4 3F
	stx.b a3		; $80D899: 86 3F
	sty.b a2		; $80D89B: 84 3B
	jsl.l .ci		; $80D89D: 22 B0 D8 80
	ldx.b a2		; $80D8A1: A6 3B
	ldy.b a3		; $80D8A3: A4 3F
	stx.b a3		; $80D8A5: 86 3F
	sty.b a2		; $80D8A7: 84 3B
	pla		; $80D8A9: 68
	sta.b d0		; $80D8AA: 85 53
	pla		; $80D8AC: 68
	sta.b d0+2		; $80D8AD: 85 55
.rtl:
	rtl		; $80D8AF: 6B
.ci:		;IDA checkint_ci: a2 must be a goalie, clock running
	ldy.b a2		; $80D8B0: A4 3B
	lda.w position,y		; $80D8B2: B9 9F 0B
	bne .rtl		; $80D8B5: D0 F8
	lda.w gmclock		; $80D8B7: AD 8A 12
	bne .rtl		; $80D8BA: D0 F3
	lda.w puckc		; $80D8BC: AD BB 0E  a3 has the puck: skip the impact 26 test
	asl a		; $80D8BF: 0A
	cmp.b a3		; $80D8C0: C5 3F
	beq .pc		; $80D8C2: F0 11
	lda.w impact,x		; $80D8C4: BD 7F 0B
	sec		; $80D8C7: 38
	sbc.w #$001A		; $80D8C8: E9 1A 00
	beq .rtl		; $80D8CB: F0 E2
	bmi .v1		; $80D8CD: 30 04
	bvc .pc		; $80D8CF: 50 04
	bra .rtl		; $80D8D1: 80 DC
.v1:
	bvc .rtl		; $80D8D3: 50 DA
.pc:		;impact of X > 2
	lda.w impact,x		; $80D8D5: BD 7F 0B
	sec		; $80D8D8: 38
	sbc.w #$0003		; $80D8D9: E9 03 00
	beq .rtl		; $80D8DC: F0 D1
	bmi .v2		; $80D8DE: 30 04
	bvc .fall		; $80D8E0: 50 04
	bra .rtl		; $80D8E2: 80 CB
.v2:
	bvc .rtl		; $80D8E4: 50 C9
.fall:		;X falls
	ldx.b a2		; $80D8E6: A6 3B
	ldy.b a3		; $80D8E8: A4 3F
	stx.b a3		; $80D8EA: 86 3F
	sty.b a2		; $80D8EC: 84 3B
	jsl.l FallDown		; $80D8EE: 22 33 D9 80
	ldx.b a2		; $80D8F2: A6 3B
	ldy.b a3		; $80D8F4: A4 3F
	stx.b a3		; $80D8F6: 86 3F
	sty.b a2		; $80D8F8: 84 3B
	lda.w impact,y		; $80D8FA: B9 7F 0B  impact of a2 > 31
	sec		; $80D8FD: 38
	sbc.w #$001F		; $80D8FE: E9 1F 00
	beq .rtl		; $80D901: F0 AC
	bmi .v3		; $80D903: 30 04
	bvc .pen		; $80D905: 50 04
	bra .rtl		; $80D907: 80 A6
.v3:
	bvc .rtl		; $80D909: 50 A4
.pen:		;no double minor; penalty 3 times in (20 - GGSleft)
	lda.w pflags,x		; $80D90B: BD DF 0E
	bit.w #pf2pen		; $80D90E: 89 00 40
	bne .rtl		; $80D911: D0 9C
	lda.w #$0014		; $80D913: A9 14 00
	sec		; $80D916: 38
	sbc.w GGSleft,x		; $80D917: FD BF 10
	jsl.l randoma		; $80D91A: 22 8B AE 80
	cmp.w #$0003		; $80D91E: C9 03 00
	bcs .rtl		; $80D921: B0 8C
	lda.w gmode		; $80D923: AD 88 12  not in highlights
	bit.w #gmhl		; $80D926: 89 10 00
	bne .rtl		; $80D929: D0 84
	lda.w #PenInt		; $80D92B: A9 22 00
	sta.b d0		; $80D92E: 85 53
	jmp.w AddPenalty		; $80D930: 4C 8F C1
FallDown:		;auto: CODE_80D933. 93G FallDown (hockey93_03): player a2 falls, X is the hitter. Stumble for some players, check stats, fall back/forward/third fall, injuries with a penalty and crowd sounds
	ldy.b a2		; $80D933: A4 3B  players only, not fighting
	cpy.w #$0018		; $80D935: C0 18 00
	bcc .f1		; $80D938: 90 03
	jmp.w .rtl		; $80D93A: 4C 11 DB
.f1:
	lda.w pf2fight,y		; $80D93D: B9 5F 11
	beq .spa		; $80D940: F0 03
	jmp.w .rtl		; $80D942: 4C 11 DB
.spa:		;already in one of the fall anims?
	lda.w SPA,y		; $80D945: B9 FF 0D
	cmp.w #SPAinjury1		; $80D948: C9 02 15
	bne .s2		; $80D94B: D0 03
	jmp.w .rtl		; $80D94D: 4C 11 DB
.s2:
	cmp.w #SPAstumble		; $80D950: C9 A2 12
	bne .s3		; $80D953: D0 03
	jmp.w .rtl		; $80D955: 4C 11 DB
.s3:
	cmp.w #SPAfallfwd		; $80D958: C9 92 0C
	bne .s4		; $80D95B: D0 03
	jmp.w .rtl		; $80D95D: 4C 11 DB
.s4:
	cmp.w #SPAfallback		; $80D960: C9 44 0D
	bne .s5		; $80D963: D0 03
	jmp.w .rtl		; $80D965: 4C 11 DB
.s5:
	cmp.w #SPAflip		; $80D968: C9 B0 11
	bne .s6		; $80D96B: D0 03
	jmp.w .rtl		; $80D96D: 4C 11 DB
.s6:		;stumble when stickhand (93G byte $71) >= $C, nopuckb is 0 and impact < $10-$1F
	lda.w #SPAstumble		; $80D970: A9 A2 12
	sta.b d1		; $80D973: 85 57
	lda.w stickhand,y		; $80D975: B9 7F 10
	cmp.w #$000C		; $80D978: C9 0C 00
	bcc .fall		; $80D97B: 90 27
	lda.w nopuckb,y		; $80D97D: B9 7F 0E
	bne .fall		; $80D980: D0 22
	lda.w seed		; $80D982: AD A1 04
	and.w #$000F		; $80D985: 29 0F 00
	ora.w #$0010		; $80D988: 09 10 00
	sta.b d0		; $80D98B: 85 53
	sec		; $80D98D: 38
	sbc.w impact,y		; $80D98E: F9 7F 0B
	beq .fall		; $80D991: F0 11
	bmi .v1		; $80D993: 30 04
	bvc .stumble		; $80D995: 50 04
	bra .fall		; $80D997: 80 0B
.v1:
	bvc .fall		; $80D999: 50 09
.stumble:		;no second stumble for $3C
	lda.w #$003C		; $80D99B: A9 3C 00
	sta.w nopuckb,y		; $80D99E: 99 7F 0E
	jmp.w .set		; $80D9A1: 4C 42 DA
.fall:		;no check stats for a goalie hitter
	lda.w position,x		; $80D9A4: BD 9F 0B
	beq .nostat		; $80D9A7: F0 3F
	stz.b a0		; $80D9A9: 64 33  team checks, player checks, ChkCnt (+3 when fightagg is 0)
	lda.w pfteam,x		; $80D9AB: BD 9F 11
	beq .tm		; $80D9AE: F0 05
	lda.w #$0002		; $80D9B0: A9 02 00
	sta.b a0		; $80D9B3: 85 33
.tm:
	ldy.b a0		; $80D9B5: A4 33
	lda.w tmchecks,y		; $80D9B7: B9 02 14
	inc a		; $80D9BA: 1A
	sta.w tmchecks,y		; $80D9BB: 99 02 14
	inc.w ChkCnt		; $80D9BE: EE F8 12
	lda.w pnum,x		; $80D9C1: BD 1F 0F
	sta.b d0		; $80D9C4: 85 53
	lda.w pfteam,x		; $80D9C6: BD 9F 11
	beq .pl		; $80D9C9: F0 03
	lda.w #$001A		; $80D9CB: A9 1A 00
.pl:
	clc		; $80D9CE: 18
	adc.b d0		; $80D9CF: 65 53
	tay		; $80D9D1: A8
	sep #$20		; $80D9D2: E2 20
	lda.w pchecks,y		; $80D9D4: B9 46 14
	inc a		; $80D9D7: 1A
	sta.w pchecks,y		; $80D9D8: 99 46 14
	rep #$20		; $80D9DB: C2 20
	lda.w fightagg,x		; $80D9DD: BD DF 10
	bne .nostat		; $80D9E0: D0 06
	inc.w ChkCnt		; $80D9E2: EE F8 12
	inc.w ChkCnt		; $80D9E5: EE F8 12
.nostat:
	ldy.b a2		; $80D9E8: A4 3B  nopuck 120 for a2
	lda.w #$0078		; $80D9EA: A9 78 00
	sta.w nopuck,y		; $80D9ED: 99 5F 0E
	lda.w Xpos,x		; $80D9F0: BD FF 08  direction from a2 to the hitter
	sec		; $80D9F3: 38
	sbc.w Xpos,y		; $80D9F4: F9 FF 08
	sta.b d0		; $80D9F7: 85 53
	lda.w Ypos,x		; $80D9F9: BD 5F 09
	sec		; $80D9FC: 38
	sbc.w Ypos,y		; $80D9FD: F9 5F 09
	sta.b d1		; $80DA00: 85 57
	jsl.l vtoa		; $80DA02: 22 A8 AF 80
	lda.w #SPAfallback		; $80DA06: A9 44 0D
	sta.b d1		; $80DA09: 85 57
	ldy.b a2		; $80DA0B: A4 3B  hit from the front: fall back
	lda.b d0		; $80DA0D: A5 53
	sec		; $80DA0F: 38
	sbc.w facedir,y		; $80DA10: F9 BF 0D
	inc a		; $80DA13: 1A
	and.w #$0007		; $80DA14: 29 07 00
	cmp.w #$0003		; $80DA17: C9 03 00
	bcc .set		; $80DA1A: 90 26
	lda.w #SPAfallfwd		; $80DA1C: A9 92 0C
	sta.b d1		; $80DA1F: 85 57
	lda.w facedir,y		; $80DA21: B9 BF 0D  facedir 0 or 4 and hitter aggress >= 10: third fall
	and.w #$0003		; $80DA24: 29 03 00
	bne .set		; $80DA27: D0 19
	lda.w aggress,x		; $80DA29: BD FF 10
	sec		; $80DA2C: 38
	sbc.w #$000A		; $80DA2D: E9 0A 00
	bmi .v2		; $80DA30: 30 04
	bvc .f3		; $80DA32: 50 04
	bra .set		; $80DA34: 80 0C
.v2:
	bvc .set		; $80DA36: 50 0A
.f3:
	cpx.w #$0018		; $80DA38: E0 18 00
	bcs .set		; $80DA3B: B0 05
	lda.w #SPAflip		; $80DA3D: A9 B0 11
	sta.b d1		; $80DA40: 85 57
.set:		;SetSPA d1 for a2
	ldx.b a2		; $80DA42: A6 3B
	ldy.b a3		; $80DA44: A4 3F
	stx.b a3		; $80DA46: 86 3F
	sty.b a2		; $80DA48: 84 3B
	lda.w #$0001		; $80DA4A: A9 01 00  pfalock
	sta.w pfalock,x		; $80DA4D: 9D 7F 11
	jsl.l SetSPA		; $80DA50: 22 06 B0 80
	ldx.b a2		; $80DA54: A6 3B
	ldy.b a3		; $80DA56: A4 3F
	stx.b a3		; $80DA58: 86 3F
	sty.b a2		; $80DA5A: 84 3B
	lda.b crowdlevel		; $80DA5C: A5 DE  crowd +300
	clc		; $80DA5E: 18
	adc.w #$012C		; $80DA5F: 69 2C 01
	sta.b crowdlevel		; $80DA62: 85 DE
	lda.w puckc		; $80DA64: AD BB 0E  a2 did not have the puck: check sound only
	sta.b d0		; $80DA67: 85 53
	bpl .pc		; $80DA69: 10 03
	jmp.w newcheck		; $80DA6B: 4C 7B D8
.pc:
	tya		; $80DA6E: 98
	lsr a		; $80DA6F: 4A
	cmp.b d0		; $80DA70: C5 53
	beq .drop		; $80DA72: F0 03
	jmp.w newcheck		; $80DA74: 4C 7B D8
.drop:		;a2 had the puck: lose it, maybe an injury
	lda.w #$FFFF		; $80DA77: A9 FF FF
	sta.w puckc		; $80DA7A: 8D BB 0E
	lda.w gmode		; $80DA7D: AD 88 12  injury: no highlight, fall back, facedir 0/4, no penalty, random(160) <= impact, clock running
	bit.w #gmhl		; $80DA80: 89 10 00
	bne .snd		; $80DA83: D0 78
	lda.w SPA,y		; $80DA85: B9 FF 0D
	cmp.w #SPAfallback		; $80DA88: C9 44 0D
	bne .snd		; $80DA8B: D0 70
	lda.w facedir,y		; $80DA8D: B9 BF 0D
	and.w #$0003		; $80DA90: 29 03 00
	bne .snd		; $80DA93: D0 68
	lda.w pflags,y		; $80DA95: B9 DF 0E
	bit.w #pf2pen		; $80DA98: 89 00 40
	bne .snd		; $80DA9B: D0 60
	lda.w #$00A0		; $80DA9D: A9 A0 00
	jsl.l randoma		; $80DAA0: 22 8B AE 80
	ldy.b a2		; $80DAA4: A4 3B
	sec		; $80DAA6: 38
	sbc.w impact,y		; $80DAA7: F9 7F 0B
	beq .inj		; $80DAAA: F0 08
	bmi .v3		; $80DAAC: 30 04
	bvs .inj		; $80DAAE: 70 04
	bra .snd		; $80DAB0: 80 4B
.v3:
	bvs .snd		; $80DAB2: 70 49
.inj:
	lda.w gmclock		; $80DAB4: AD 8A 12
	bne .snd		; $80DAB7: D0 44
	ldx.b a2		; $80DAB9: A6 3B
	ldy.b a3		; $80DABB: A4 3F
	stx.b a3		; $80DABD: 86 3F
	sty.b a2		; $80DABF: 84 3B
	lda.w #SPAinjury1		; $80DAC1: A9 02 15
	sta.b d1		; $80DAC4: 85 57
	jsl.l SetSPA		; $80DAC6: 22 06 B0 80
	ldx.b a2		; $80DACA: A6 3B
	ldy.b a3		; $80DACC: A4 3F
	stx.b a3		; $80DACE: 86 3F
	sty.b a2		; $80DAD0: 84 3B
	jsl.l $8FF74A		; $80DAD2: 22 4A F7 8F  setInjuryType, bank $8F: 93G setInjuryType
	lda.w #$0004		; $80DAD6: A9 04 00
	sta.w InjCntDown		; $80DAD9: 8D E6 12
	lda.w #PenInjury		; $80DADC: A9 14 00  PenInjury if the hitter is a goalie or penalties are off, else PenRough2 and Stop4Pen
	sta.b d0		; $80DADF: 85 53
	lda.w position,x		; $80DAE1: BD 9F 0B
	bne .g		; $80DAE4: D0 03
	jmp.w AddPenalty2		; $80DAE6: 4C B0 C1
.g:
	lda.w OptPen		; $80DAE9: AD 0A 16
	bne .rough		; $80DAEC: D0 03
	jmp.w AddPenalty2		; $80DAEE: 4C B0 C1
.rough:
	lda.w #PenRough2		; $80DAF1: A9 12 00
	sta.b d0		; $80DAF4: 85 53
	jsl.l AddPenalty2		; $80DAF6: 22 B0 C1 80
	jmp.w Stop4Pen		; $80DAFA: 4C F7 E7
.snd:
	ldy.b a2		; $80DAFD: A4 3B  home player fell: boo, else cheer
	lda.w #SFXcrowdcheer		; $80DAFF: A9 8A 00
	pha		; $80DB02: 48
	lda.w pfteam,y		; $80DB03: B9 9F 11
	bne .play		; $80DB06: D0 05
	lda.w #SFXcrowdboo		; $80DB08: A9 8B 00
	sta.b $01,s		; $80DB0B: 83 01
.play:
	jsl.l sfx		; $80DB0D: 22 8B C2 80
.rtl:
	rtl		; $80DB11: 6B
checkcheck:		;auto: CODE_80DB12. 93G checkcheck (hockey93_03): players in contact: .cc for X on a2, then for a2 on X. d4 = impact
	stx.b xsave		; $80DB12: 86 0A
	ldx.w #$0000		; $80DB14: A2 00 00
.pushd:
	lda.b d0,x		; $80DB17: B5 53
	pha		; $80DB19: 48
	inx		; $80DB1A: E8
	inx		; $80DB1B: E8
	cpx.w #$0014		; $80DB1C: E0 14 00
	bne .pushd		; $80DB1F: D0 F6
	ldx.b xsave		; $80DB21: A6 0A
	stx.b xsave		; $80DB23: 86 0A
	ldx.w #$0000		; $80DB25: A2 00 00
.pusha:
	lda.b a0,x		; $80DB28: B5 33
	pha		; $80DB2A: 48
	inx		; $80DB2B: E8
	inx		; $80DB2C: E8
	cpx.w #$0010		; $80DB2D: E0 10 00
	bne .pusha		; $80DB30: D0 F6
	ldx.b xsave		; $80DB32: A6 0A
	jsl.l .cc		; $80DB34: 22 63 DB 80
	ldx.b a2		; $80DB38: A6 3B
	ldy.b a3		; $80DB3A: A4 3F
	stx.b a3		; $80DB3C: 86 3F
	sty.b a2		; $80DB3E: 84 3B
	jsl.l .cc		; $80DB40: 22 63 DB 80
	stx.b xsave		; $80DB44: 86 0A
	ldx.w #$000E		; $80DB46: A2 0E 00
.popa:
	pla		; $80DB49: 68
	sta.b a0,x		; $80DB4A: 95 33
	dex		; $80DB4C: CA
	dex		; $80DB4D: CA
	bpl .popa		; $80DB4E: 10 F9
	ldx.b xsave		; $80DB50: A6 0A
	stx.b xsave		; $80DB52: 86 0A
	ldx.w #$0012		; $80DB54: A2 12 00
.popd:
	pla		; $80DB57: 68
	sta.b d0,x		; $80DB58: 95 53
	dex		; $80DB5A: CA
	dex		; $80DB5B: CA
	bpl .popd		; $80DB5C: 10 F9
	ldx.b xsave		; $80DB5E: A6 0A
	ldx.b a3		; $80DB60: A6 3F
.rtl:
	rtl		; $80DB62: 6B
.cc:		;IDA CC: X is checking a2
	ldy.b a2		; $80DB63: A4 3B  a2 holding: holdcheck
	lda.w SPA,y		; $80DB65: B9 FF 0D
	cmp.w #SPAHold		; $80DB68: C9 FC 0B
	bne .h2		; $80DB6B: D0 04
	jml.l $8FD5BF		; $80DB6D: 5C BF D5 8F  bank $8F: 93G holdcheck
.h2:
	cmp.w #SPAhook		; $80DB71: C9 54 13
	bne .b		; $80DB74: D0 04
	jml.l $8FD5BF		; $80DB76: 5C BF D5 8F  bank $8F: 93G holdcheck
.b:
	cmp.w #SPAsweepchk		; $80DB7A: C9 90 0A
	bne .burst		; $80DB7D: D0 04
	jml.l $8D8389		; $80DB7F: 5C 89 83 8D  bank $8D: 93G Bcheck
.burst:		;X must be in the burst anim
	lda.w SPA,x		; $80DB83: BD FF 0D
	cmp.w #SPAburst		; $80DB86: C9 CA 0B
	bne .rtl		; $80DB89: D0 D7
	lda.w gmclock		; $80DB8B: AD 8A 12  clock stopped: fight chance up
	beq .nofight		; $80DB8E: F0 09
	lda.w #$0100		; $80DB90: A9 00 01
	sta.w impact,x		; $80DB93: 9D 7F 0B
	sta.w impact,y		; $80DB96: 99 7F 0B
.nofight:
	lda.w Xpos,y		; $80DB99: B9 FF 08
	sec		; $80DB9C: 38
	sbc.w Xpos,x		; $80DB9D: FD FF 08
	sta.b d0		; $80DBA0: 85 53
	lda.w Ypos,y		; $80DBA2: B9 5F 09
	sec		; $80DBA5: 38
	sbc.w Ypos,x		; $80DBA6: FD 5F 09
	sta.b d1		; $80DBA9: 85 57
	jsl.l vtoa		; $80DBAB: 22 A8 AF 80
	lda.b d0		; $80DBAF: A5 53
	sec		; $80DBB1: 38
	sbc.w facedir,x		; $80DBB2: FD BF 0D
	and.w #$0007		; $80DBB5: 29 07 00
	sta.b d0		; $80DBB8: 85 53
	lda.w attribute,x		; $80DBBA: BD DF 09  xflip: mirror the direction
	bit.w #$0800		; $80DBBD: 89 00 08
	beq .n0		; $80DBC0: F0 0B
	lda.b d0		; $80DBC2: A5 53
	eor.w #$FFFF		; $80DBC4: 49 FF FF
	inc a		; $80DBC7: 1A
	and.w #$0007		; $80DBC8: 29 07 00
	sta.b d0		; $80DBCB: 85 53
.n0:		;check anim from .list by the direction to a2
	asl.b d0		; $80DBCD: 06 53
	lda.w #.list		; $80DBCF: A9 85 DC
	sta.b a0		; $80DBD2: 85 33
	sta.w pfalock,x		; $80DBD4: 9D 7F 11  pfalock
	lda.w #.list>>16		; $80DBD7: A9 80 00
	sta.b a0+2		; $80DBDA: 85 35
	ldy.b d0		; $80DBDC: A4 53
	lda.b [a0],y		; $80DBDE: B7 33
	sta.b d1		; $80DBE0: 85 57
	jsl.l SetSPA		; $80DBE2: 22 06 B0 80
	ldy.b a2		; $80DBE6: A4 3B
	lda.w position,y		; $80DBE8: B9 9F 0B
	bne .pos		; $80DBEB: D0 03
	jmp.w .rtl		; $80DBED: 4C 62 DB
.pos:		;goalie does not fall
	lda.b d4		; $80DBF0: A5 63  impact under 20: no fall
	sec		; $80DBF2: 38
	sbc.w #$0014		; $80DBF3: E9 14 00
	bmi .v1		; $80DBF6: 30 05
	bvc .fall		; $80DBF8: 50 05
.ex1:
	jmp.w .rtl		; $80DBFA: 4C 62 DB
.v1:
	bvc .ex1		; $80DBFD: 50 FB
.fall:		;d0 = (120 (*2 joystick) - weight + weight of a2) / 2 - impact of a2
	lda.w #$0078		; $80DBFF: A9 78 00
	sta.b d0		; $80DC02: 85 53
	lda.w pflags,x		; $80DC04: BD DF 0E
	bit.w #pfjoycon		; $80DC07: 89 08 00
	beq .n00		; $80DC0A: F0 02
	asl.b d0		; $80DC0C: 06 53
.n00:
	lda.b d0		; $80DC0E: A5 53
	sec		; $80DC10: 38
	sbc.w weight,x		; $80DC11: FD 3F 0F
	clc		; $80DC14: 18
	adc.w weight,y		; $80DC15: 79 3F 0F
	lsr a		; $80DC18: 4A
	sec		; $80DC19: 38
	sbc.w impact,y		; $80DC1A: F9 7F 0B
	sta.b d0		; $80DC1D: 85 53
	beq .down		; $80DC1F: F0 3E
	bmi .down		; $80DC21: 30 3C
	jsl.l randomd0		; $80DC23: 22 A3 97 80  random < aggress: down
	lda.b d0		; $80DC27: A5 53
	sec		; $80DC29: 38
	sbc.w aggress,x		; $80DC2A: FD FF 10
	beq .down		; $80DC2D: F0 30
	bmi .v2		; $80DC2F: 30 04
	bvc .pen		; $80DC31: 50 04
	bra .down		; $80DC33: 80 2A
.v2:
	bvc .down		; $80DC35: 50 28
.pen:
	jsl.l $8FE369		; $80DC37: 22 69 E3 8F  checkagr <= 4 and no highlight: PenCharge or PenSlash, bank $8F: 93G checkagr (d0 = penalty roll)
	lda.b d0		; $80DC3B: A5 53
	cmp.w #$0005		; $80DC3D: C9 05 00
	bcc .nohl		; $80DC40: 90 03
	jmp.w .rtl		; $80DC42: 4C 62 DB
.nohl:
	lda.w gmode		; $80DC45: AD 88 12
	bit.w #gmhl		; $80DC48: 89 10 00
	beq .roll		; $80DC4B: F0 03
	jmp.w .rtl		; $80DC4D: 4C 62 DB
.roll:
	lda.w seed+1		; $80DC50: AD A2 04
	and.w #$0002		; $80DC53: 29 02 00
	clc		; $80DC56: 18
	adc.w #PenCharge		; $80DC57: 69 16 00
	sta.b d0		; $80DC5A: 85 53
	jmp.w AddPenalty		; $80DC5C: 4C 8F C1
.down:
	jsl.l $8FE369		; $80DC5F: 22 69 E3 8F  checkagr <= 3 and no highlight: PenRough or PenCross, bank $8F: 93G checkagr (d0 = penalty roll)
	lda.b d0		; $80DC63: A5 53
	cmp.w #$0004		; $80DC65: C9 04 00
	bcs .dn2		; $80DC68: B0 18
	lda.w gmode		; $80DC6A: AD 88 12
	bit.w #gmhl		; $80DC6D: 89 10 00
	bne .dn2		; $80DC70: D0 10
	lda.w seed+3		; $80DC72: AD A4 04
	and.w #$0002		; $80DC75: 29 02 00
	clc		; $80DC78: 18
	adc.w #PenRough		; $80DC79: 69 1A 00
	sta.b d0		; $80DC7C: 85 53
	jsl.l AddPenalty		; $80DC7E: 22 8F C1 80
.dn2:
	jmp.w FallDown		; $80DC82: 4C 33 D9
.list:		;check anim by direction
	dw SPAshoulderchkl,SPAshoulderchkr,SPAhipchkr,SPAhipchkr,SPAhipchkr,SPAhipchkl,SPAhipchkl,SPAshoulderchkl		; $80DC85
checkfight:		;auto: CODE_80DC95. 93G checkfight (hockey93_04): start of a fight between a2 and X. Both impact >= 10, no anim lock, no penalty, no goalie, clock running, no highlight, the puck not fighting or on a faceoff. SetInst both ways with d0 = 10 + max(0, 40 - ChkCnt)/4
	ldy.b a2		; $80DC95: A4 3B
	lda.w impact,x		; $80DC97: BD 7F 0B
	sec		; $80DC9A: 38
	sbc.w #$000A		; $80DC9B: E9 0A 00
	bmi .v1		; $80DC9E: 30 05
	bvc .i2		; $80DCA0: 50 05
.ex1:
	jmp.w .rtl		; $80DCA2: 4C 27 DE
.v1:
	bvc .ex1		; $80DCA5: 50 FB
.i2:
	lda.w impact,y		; $80DCA7: B9 7F 0B
	sec		; $80DCAA: 38
	sbc.w #$000A		; $80DCAB: E9 0A 00
	bmi .v2		; $80DCAE: 30 05
	bvc .lock		; $80DCB0: 50 05
.ex2:
	jmp.w .rtl		; $80DCB2: 4C 27 DE
.v2:
	bvc .ex2		; $80DCB5: 50 FB
.lock:
	lda.w pfalock,y		; $80DCB7: B9 7F 11
	ora.w pfalock,x		; $80DCBA: 1D 7F 11
	beq .pen		; $80DCBD: F0 03
	jmp.w .rtl		; $80DCBF: 4C 27 DE
.pen:
	lda.w pflags,x		; $80DCC2: BD DF 0E
	ora.w pflags,y		; $80DCC5: 19 DF 0E
	bit.w #pf2pen		; $80DCC8: 89 00 40
	beq .pos1		; $80DCCB: F0 03
	jmp.w .rtl		; $80DCCD: 4C 27 DE
.pos1:
	lda.w position,x		; $80DCD0: BD 9F 0B
	bne .pos2		; $80DCD3: D0 03
	jmp.w .rtl		; $80DCD5: 4C 27 DE
.pos2:
	lda.w position,y		; $80DCD8: B9 9F 0B
	bne .clk		; $80DCDB: D0 03
	jmp.w .rtl		; $80DCDD: 4C 27 DE
.clk:
	lda.w gmode		; $80DCE0: AD 88 12  highlight, clock stopped, the puck fighting
	and.w #gmhl		; $80DCE3: 29 10 00
	ora.w gmclock		; $80DCE6: 0D 8A 12
	ora.w pf2fight+puckobj		; $80DCE9: 0D 7B 11
	beq .go		; $80DCEC: F0 03
	jmp.w .rtl		; $80DCEE: 4C 27 DE
.go:
	stx.b xsave		; $80DCF1: 86 0A
	ldx.w #$0000		; $80DCF3: A2 00 00
.pushd:
	lda.b d0,x		; $80DCF6: B5 53
	pha		; $80DCF8: 48
	inx		; $80DCF9: E8
	inx		; $80DCFA: E8
	cpx.w #$0014		; $80DCFB: E0 14 00
	bne .pushd		; $80DCFE: D0 F6
	ldx.b xsave		; $80DD00: A6 0A
	stx.b xsave		; $80DD02: 86 0A
	ldx.w #$0000		; $80DD04: A2 00 00
.pusha:
	lda.b a0,x		; $80DD07: B5 33
	pha		; $80DD09: 48
	inx		; $80DD0A: E8
	inx		; $80DD0B: E8
	cpx.w #$0010		; $80DD0C: E0 10 00
	bne .pusha		; $80DD0F: D0 F6
	ldx.b xsave		; $80DD11: A6 0A
	ldy.w assnum+puckobj		; $80DD13: AC DB 0B  puck assignment pfaceoff: no fight
	lda.w asslist+puckobj*4,y		; $80DD16: B9 4F 0C
	and.w #$00FF		; $80DD19: 29 FF 00
	cmp.w #pfaceoff		; $80DD1C: C9 1B 00
	bne .nofo		; $80DD1F: D0 03
	jmp.w .ex		; $80DD21: 4C 09 DE
.nofo:
	lda.w #$0028		; $80DD24: A9 28 00  d0 = 10 + max(0, 40 - ChkCnt)/4
	sec		; $80DD27: 38
	sbc.w ChkCnt		; $80DD28: ED F8 12
	bpl .pos		; $80DD2B: 10 03
	lda.w #$0000		; $80DD2D: A9 00 00
.pos:
	lsr a		; $80DD30: 4A
	lsr a		; $80DD31: 4A
	clc		; $80DD32: 18
	adc.w #$000A		; $80DD33: 69 0A 00
	sta.b d0		; $80DD36: 85 53
	jsl.l SetInst		; $80DD38: 22 89 DE 80
	ldx.b a2		; $80DD3C: A6 3B
	ldy.b a3		; $80DD3E: A4 3F
	stx.b a3		; $80DD40: 86 3F
	sty.b a2		; $80DD42: 84 3B
	jsl.l SetInst		; $80DD44: 22 89 DE 80
	ldx.b a2		; $80DD48: A6 3B
	ldy.b a3		; $80DD4A: A4 3F
	stx.b a3		; $80DD4C: 86 3F
	sty.b a2		; $80DD4E: 84 3B
	lda.w pf2fight,x		; $80DD50: BD 5F 11
	bne .fight		; $80DD53: D0 03
	jmp.w .ex		; $80DD55: 4C 09 DE
.fight:		;clear ChkCnt and the check counts of both teams
	stz.w ChkCnt		; $80DD58: 9C F8 12
	lda.w #$0000		; $80DD5B: A9 00 00
	ldy.w #$0032		; $80DD5E: A0 32 00
.clr:
	sta.w pchecks,y		; $80DD61: 99 46 14
	dey		; $80DD64: 88
	dey		; $80DD65: 88
	bpl .clr		; $80DD66: 10 F9
	lda.b crowdlevel		; $80DD68: A5 DE  crowd +1000; no pass/shot dir; puckc = X; yc1 = middle; sfslock
	clc		; $80DD6A: 18
	adc.w #$03E8		; $80DD6B: 69 E8 03
	sta.b crowdlevel		; $80DD6E: 85 DE
	lda.w #sfspdir|sfssdir		; $80DD70: A9 0C 00
	trb.w sflags		; $80DD73: 1C 8C 12
	ldy.b a2		; $80DD76: A4 3B
	txa		; $80DD78: 8A
	lsr a		; $80DD79: 4A
	sta.w puckc		; $80DD7A: 8D BB 0E
	lda.w Ypos,x		; $80DD7D: BD 5F 09
	clc		; $80DD80: 18
	adc.w Ypos,y		; $80DD81: 79 5F 09
	pha		; $80DD84: 48
	asl a		; $80DD85: 0A
	pla		; $80DD86: 68
	ror a		; $80DD87: 6A
	sta.w yc1		; $80DD88: 8D F7 08
	lda.w #sfslock		; $80DD8B: A9 40 00
	tsb.w sflags		; $80DD8E: 0C 8C 12
	lda.w #$0002		; $80DD91: A9 02 00
	sta.b d1		; $80DD94: 85 57
	lda.w Xpos,x		; $80DD96: BD FF 08
	sta.b d0		; $80DD99: 85 53
	sec		; $80DD9B: 38
	sbc.w Xpos,y		; $80DD9C: F9 FF 08
	bmi .v3		; $80DD9F: 30 04
	bvc .flip		; $80DDA1: 50 04
	bra .o1		; $80DDA3: 80 09
.v3:
	bvc .o1		; $80DDA5: 50 07
.flip:
	lda.b d1		; $80DDA7: A5 57
	eor.w #$0007		; $80DDA9: 49 07 00
	sta.b d1		; $80DDAC: 85 57
.o1:		;face each other
	lda.b d1		; $80DDAE: A5 57
	sta.w facedir,x		; $80DDB0: 9D BF 0D
	eor.w #$0007		; $80DDB3: 49 07 00
	sta.b d1		; $80DDB6: 85 57
	sta.w facedir,y		; $80DDB8: 99 BF 0D
	jsl.l .sf		; $80DDBB: 22 28 DE 80
	ldx.b a2		; $80DDBF: A6 3B
	ldy.b a3		; $80DDC1: A4 3F
	stx.b a3		; $80DDC3: 86 3F
	sty.b a2		; $80DDC5: 84 3B
	jsl.l .sf		; $80DDC7: 22 28 DE 80
	ldx.w #$0000		; $80DDCB: A2 00 00  others: afwatch (not unavailable, not fighting, not goalies)
	lda.w #afwatch		; $80DDCE: A9 15 00
	sta.b d0		; $80DDD1: 85 53
	lda.w #$000B		; $80DDD3: A9 0B 00
	sta.b d1		; $80DDD6: 85 57
.watch:		;the others watch the fight
	lda.w pflags,x		; $80DDD8: BD DF 0E
	and.w #pf2unav		; $80DDDB: 29 00 10
	ora.w pf2fight,x		; $80DDDE: 1D 5F 11
	bne .next		; $80DDE1: D0 09
	lda.w position,x		; $80DDE3: BD 9F 0B
	beq .next		; $80DDE6: F0 04
	jsl.l assinsert		; $80DDE8: 22 9D B4 80
.next:
	inx		; $80DDEC: E8
	inx		; $80DDED: E8
	dec.b d1		; $80DDEE: C6 57
	bpl .watch		; $80DDF0: 10 E6
	ldx.w #puckobj		; $80DDF2: A2 1C 00  the puck: pf2fight, pnothing
	lda.w #$0001		; $80DDF5: A9 01 00
	sta.w pf2fight+puckobj		; $80DDF8: 8D 7B 11
	lda.w #pnothing		; $80DDFB: A9 1A 00
	sta.b d0		; $80DDFE: 85 53
	jsl.l assinsert		; $80DE00: 22 9D B4 80
	lda.w #$FFFF		; $80DE04: A9 FF FF
	sta.b collflag		; $80DE07: 85 D8
.ex:
	stx.b xsave		; $80DE09: 86 0A
	ldx.w #$000E		; $80DE0B: A2 0E 00
.popa:
	pla		; $80DE0E: 68
	sta.b a0,x		; $80DE0F: 95 33
	dex		; $80DE11: CA
	dex		; $80DE12: CA
	bpl .popa		; $80DE13: 10 F9
	ldx.b xsave		; $80DE15: A6 0A
	stx.b xsave		; $80DE17: 86 0A
	ldx.w #$0012		; $80DE19: A2 12 00
.popd:
	pla		; $80DE1C: 68
	sta.b d0,x		; $80DE1D: 95 53
	dex		; $80DE1F: CA
	dex		; $80DE20: CA
	bpl .popd		; $80DE21: 10 F9
	ldx.b xsave		; $80DE23: A6 0A
	ldx.b a3		; $80DE25: A6 3F
.rtl:
	rtl		; $80DE27: 6B
.sf:		;IDA checkfight_sf: start the fight for X against a2
	ldy.b a2		; $80DE28: A4 3B  impactp = a2
	tya		; $80DE2A: 98
	lsr a		; $80DE2B: 4A
	sta.w impactp,x		; $80DE2C: 9D 3F 0B
	lda.w #PenFight		; $80DE2F: A9 26 00
	sta.b d0		; $80DE32: 85 53
	jsl.l AddPenalty2		; $80DE34: 22 B0 C1 80
	txa		; $80DE38: 8A  setd0player
	lsr a		; $80DE39: 4A
	sta.b d0		; $80DE3A: 85 53
	jsl.l $8D87FB		; $80DE3C: 22 FB 87 8D  bank $8D: 93G setd0player
	lda.w #afight		; $80DE40: A9 14 00
	sta.b d0		; $80DE43: 85 53
	jsl.l assinsert		; $80DE45: 22 9D B4 80
	lda.w attribute,x		; $80DE49: BD DF 09  Xvel -$400 facing 2, else flipped and +$400
	and.w #$F7FF		; $80DE4C: 29 FF F7
	sta.w attribute,x		; $80DE4F: 9D DF 09
	lda.w #$FC00		; $80DE52: A9 00 FC
	sta.b d1		; $80DE55: 85 57
	lda.w facedir,x		; $80DE57: BD BF 0D
	cmp.w #$0002		; $80DE5A: C9 02 00
	beq .sf2		; $80DE5D: F0 0E
	lda.w attribute,x		; $80DE5F: BD DF 09
	ora.w #$0800		; $80DE62: 09 00 08
	sta.w attribute,x		; $80DE65: 9D DF 09
	lda.w #$0400		; $80DE68: A9 00 04
	sta.b d1		; $80DE6B: 85 57
.sf2:
	lda.b d1		; $80DE6D: A5 57
	sta.w Xvel,x		; $80DE6F: 9D DF 0A
	lda.w pflags,x		; $80DE72: BD DF 0E  unavailable, no player coll; pf2aip; SPAfight
	ora.w #pf2npc|pf2unav		; $80DE75: 09 00 90
	sta.w pflags,x		; $80DE78: 9D DF 0E
	stz.w pfalock,x		; $80DE7B: 9E 7F 11
	lda.w #SPAfight		; $80DE7E: A9 DA 0E
	sta.b d1		; $80DE81: 85 57
	sta.w pf2aip,x		; $80DE83: 9D DF 11
	jmp.w SetSPA		; $80DE86: 4C 06 B0
SetInst:		;auto: CODE_80DE89. 93G SetInst (hockey93_04): d0 = fight rating X needs. If fightagg of X >= d0, of a2 >= 2 and >= $10 - 2 * a2 checks, set pf2fight on both. Then 92 style: an instigator penalty for a shoulder check
	lda.w fightagg,x		; $80DE89: BD DF 10
	cmp.b d0		; $80DE8C: C5 53
	bcc checkfight_rtl		; $80DE8E: 90 97
	ldy.b a2		; $80DE90: A4 3B  tmp0 = fightagg of a2 >= 2
	lda.w fightagg,y		; $80DE92: B9 DF 10
	sta.b tmp0		; $80DE95: 85 73
	sec		; $80DE97: 38
	sbc.w #$0002		; $80DE98: E9 02 00
	bmi .v1		; $80DE9B: 30 05
	bvc .r2		; $80DE9D: 50 05
.ex1:
	jmp.w checkfight_rtl		; $80DE9F: 4C 27 DE
.v1:
	bvc .ex1		; $80DEA2: 50 FB
.r2:
	lda.w pnum,y		; $80DEA4: B9 1F 0F  d1 = $10 - 2 * a2 checks
	sta.b d1		; $80DEA7: 85 57
	lda.w pfteam,y		; $80DEA9: B9 9F 11
	beq .tm		; $80DEAC: F0 03
	lda.w #$001A		; $80DEAE: A9 1A 00
.tm:
	clc		; $80DEB1: 18
	adc.w pnum,y		; $80DEB2: 79 1F 0F
	tay		; $80DEB5: A8
	lda.w pchecks,y		; $80DEB6: B9 46 14
	and.w #$00FF		; $80DEB9: 29 FF 00
	bit.w #$0080		; $80DEBC: 89 80 00
	beq .cnt		; $80DEBF: F0 03
	ora.w #$FF00		; $80DEC1: 09 00 FF
.cnt:
	asl a		; $80DEC4: 0A
	eor.w #$FFFF		; $80DEC5: 49 FF FF
	inc a		; $80DEC8: 1A
	clc		; $80DEC9: 18
	adc.w #$0010		; $80DECA: 69 10 00
	sta.b d1		; $80DECD: 85 57
	ldy.b a2		; $80DECF: A4 3B
	sec		; $80DED1: 38
	sbc.b tmp0		; $80DED2: E5 73
	beq .set		; $80DED4: F0 09
	bmi .v2		; $80DED6: 30 05
	bvs .set		; $80DED8: 70 05
.ex2:
	jmp.w checkfight_rtl		; $80DEDA: 4C 27 DE
.v2:
	bvs .ex2		; $80DEDD: 70 FB
.set:
	lda.w #$0001		; $80DEDF: A9 01 00
	sta.w pf2fight,x		; $80DEE2: 9D 5F 11
	sta.w pf2fight,y		; $80DEE5: 99 5F 11
	jmp.w .inst		; $80DEE8: 4C EB DE
.inst:		;X in a shoulder check: PenInst for the first teammate on the ice without a penalty
	jsl.l $82FA1A		; $80DEEB: 22 1A FA 82  sound reset, bank $82: reset the sound command queue
	lda.w SPA,x		; $80DEEF: BD FF 0D
	cmp.w #SPAshoulderchkl		; $80DEF2: C9 02 0B
	beq .chk		; $80DEF5: F0 05
	cmp.w #SPAshoulderchkr		; $80DEF7: C9 34 0B
	bne .rtl		; $80DEFA: D0 35
.chk:
	stx.b a4		; $80DEFC: 86 43
	lda.w #$0005		; $80DEFE: A9 05 00
	sta.b d0		; $80DF01: 85 53
	stz.b a3		; $80DF03: 64 3F
	lda.w pfteam,x		; $80DF05: BD 9F 11
	beq .loop		; $80DF08: F0 05
	lda.w #$000C		; $80DF0A: A9 0C 00
	sta.b a3		; $80DF0D: 85 3F
.loop:
	ldx.b a3		; $80DF0F: A6 3F
	cpx.b a4		; $80DF11: E4 43
	beq .next		; $80DF13: F0 1D
	lda.w position,x		; $80DF15: BD 9F 0B
	bmi .next		; $80DF18: 30 18
	beq .next		; $80DF1A: F0 16
	lda.w pflags,x		; $80DF1C: BD DF 0E
	bit.w #pf2pen|pf2unav		; $80DF1F: 89 00 50
	bne .next		; $80DF22: D0 0E
	lda.w #PenInst		; $80DF24: A9 2A 00
	sta.b d0		; $80DF27: 85 53
	jsl.l AddPenalty2		; $80DF29: 22 B0 C1 80
	ldx.b a4		; $80DF2D: A6 43
	stx.b a3		; $80DF2F: 86 3F
.rtl:
	rtl		; $80DF31: 6B
.next:
	inc.b a3		; $80DF32: E6 3F
	inc.b a3		; $80DF34: E6 3F
	dec.b d0		; $80DF36: C6 53
	bpl .loop		; $80DF38: 10 D5
	ldx.b a4		; $80DF3A: A6 43
	stx.b a3		; $80DF3C: 86 3F
	rtl		; $80DF3E: 6B
doinput:		;auto: CODE_80DF3F. 93G doinput (logic93_1): controller input for player X. d0 = dpad, d1 = new buttons, d4 = controller 0/2
	jsl.l setpads		; $80DF3F: 22 E1 E0 80  setpads; Start: pause
	lda.b d1		; $80DF43: A5 57
	bit.w #JOYSTART		; $80DF45: 89 00 10
	beq .nostart		; $80DF48: F0 0C
	lda.b d4		; $80DF4A: A5 63
	bne .pause2		; $80DF4C: D0 04
	jml.l $8F8E03		; $80DF4E: 5C 03 8E 8F  bank $8F: 93G startpause1
.pause2:
	jml.l $82FDB5		; $80DF52: 5C B5 FD 82  bank $82: 93G startpause2
.nostart:
	lda.w sfhormode		; $80DF56: AD 8E 12  horizontal mode: dpad +90 degrees
	beq .nhor		; $80DF59: F0 0E
	lda.b d0		; $80DF5B: A5 53
	bit.w #$0008		; $80DF5D: 89 08 00
	bne .nhor		; $80DF60: D0 07
	inc a		; $80DF62: 1A
	inc a		; $80DF63: 1A
	and.w #$0007		; $80DF64: 29 07 00
	sta.b d0		; $80DF67: 85 53
.nhor:
	lda.w sflags		; $80DF69: AD 8C 12  faceoff in progress
	bit.w #sf2faceoff		; $80DF6C: 89 00 01
	beq .nofo		; $80DF6F: F0 03
	jmp.w faceoffinput		; $80DF71: 4C 73 E0
.nofo:
	lda.w pflags,x		; $80DF74: BD DF 0E  line change interface
	bit.w #pf2lcm		; $80DF77: 89 00 20
	beq .nolcm		; $80DF7A: F0 04
	jml.l $8AFD0C		; $80DF7C: 5C 0C FD 8A  bank $8A: 93G lineinput
.nolcm:
	bit.w #pfjoycon		; $80DF80: 89 08 00  not joystick controlled: exit
	bne .joy		; $80DF83: D0 03
	jmp.w .rtl		; $80DF85: 4C 36 E0
.joy:
	lda.w pfalock,x		; $80DF88: BD 7F 11
	beq .nolock		; $80DF8B: F0 03
	jmp.w .islocked		; $80DF8D: 4C 25 E0
.nolock:
	lda.w pf2fight,x		; $80DF90: BD 5F 11
	beq .nofight		; $80DF93: F0 04
	jml.l $8FD4F9		; $80DF95: 5C F9 D4 8F  bank $8F: 93G fightinput
.nofight:
	lda.w puckc		; $80DF99: AD BB 0E  carrier?
	sta.b d5		; $80DF9C: 85 67
	txa		; $80DF9E: 8A
	lsr a		; $80DF9F: 4A
	cmp.b d5		; $80DFA0: C5 67
	beq .ispc		; $80DFA2: F0 25
	lda.b d1		; $80DFA4: A5 57
	bit.w #abut		; $80DFA6: 89 00 40
	beq .nohold		; $80DFA9: F0 03
	jmp.w holdplayer		; $80DFAB: 4C C5 E0
.nohold:
	bit.w #bbut		; $80DFAE: 89 00 80
	beq .nob		; $80DFB1: F0 03
	jmp.w changeplayer		; $80DFB3: 4C 9D AE
.nob:		;goalie cannot check
	lda.w position,x		; $80DFB6: BD 9F 0B
	beq .rtl		; $80DFB9: F0 7B
	lda.b d1		; $80DFBB: A5 57
	bit.w #cbut		; $80DFBD: 89 80 00
	beq .acc		; $80DFC0: F0 03
	jmp.w burst		; $80DFC2: 4C AD 8B
.acc:
	jml.l $8FFBDC		; $80DFC5: 5C DC FB 8F  bank $8F: 93G doplayeracc
.ispc:		;player is the puck carrier
	jsl.l checkob		; $80DFC9: 22 98 85 80  goalie with pf2aip: exit
	lda.w position,x		; $80DFCD: BD 9F 0B
	bne .pc1		; $80DFD0: D0 05
	lda.w pf2aip,x		; $80DFD2: BD DF 11
	bne .rtl		; $80DFD5: D0 5F
.pc1:
	lda.w sflags		; $80DFD7: AD 8C 12
	bit.w #sfspdir		; $80DFDA: 89 04 00
	beq .nopass		; $80DFDD: F0 04
	jml.l $8FE43C		; $80DFDF: 5C 3C E4 8F  bank $8F: 93G passmode
.nopass:
	bit.w #sfssdir		; $80DFE3: 89 08 00
	beq .noshot		; $80DFE6: F0 03
	jmp.w ShotMode		; $80DFE8: 4C 33 8E
.noshot:
	lda.b d1		; $80DFEB: A5 57
	bit.w #bbut		; $80DFED: 89 00 80
	bne .setpassmode		; $80DFF0: D0 45
	lda.w sflags		; $80DFF2: AD 8C 12  Y without a faceoff: line change mode
	bit.w #sf2faceoff		; $80DFF5: 89 00 01
	bne .shoot		; $80DFF8: D0 07
	lda.b d1		; $80DFFA: A5 57
	bit.w #abut		; $80DFFC: 89 00 40
	bne .lc		; $80DFFF: D0 13
.shoot:
	lda.w position,x		; $80E001: BD 9F 0B
	beq .rtl		; $80E004: F0 30
	lda.b d1		; $80E006: A5 57
	bit.w #cbut		; $80E008: 89 80 00
	beq .acc2		; $80E00B: F0 03
	jmp.w SetShotMode		; $80E00D: 4C E9 8D
.acc2:
	jml.l $8FFBDC		; $80E010: 5C DC FB 8F  bank $8F: 93G doplayeracc
.lc:
	lda.w lcplayer		; $80E014: AD 83 01  lcplayer $FFFF -> $FFFE
	cmp.w #$FFFF		; $80E017: C9 FF FF
	bne .setlc		; $80E01A: D0 06
	lda.w #$FFFE		; $80E01C: A9 FE FF
	sta.w lcplayer		; $80E01F: 8D 83 01
.setlc:
	jmp.w SetLCmode		; $80E022: 4C 0F A7
.islocked:		;anim locked: only B (switch player) when not the carrier
	txa		; $80E025: 8A
	lsr a		; $80E026: 4A
	cmp.w puckc		; $80E027: CD BB 0E
	beq .rtl		; $80E02A: F0 0A
	lda.b d1		; $80E02C: A5 57
	bit.w #$8000		; $80E02E: 89 00 80
	beq .rtl		; $80E031: F0 03
	jmp.w changeplayer		; $80E033: 4C 9D AE
.rtl:
	rtl		; $80E036: 6B
.setpassmode:		;93G setpassmode: the goalie keeps the puck behind the net (|x| < 16, |y| $108-$10F)
	lda.w position,x		; $80E037: BD 9F 0B
	bne .set		; $80E03A: D0 27
	lda.w puckx		; $80E03C: AD 1B 09
	bit.w #$8000		; $80E03F: 89 00 80
	beq .px		; $80E042: F0 04
	eor.w #$FFFF		; $80E044: 49 FF FF
	inc a		; $80E047: 1A
.px:
	cmp.w #$0010		; $80E048: C9 10 00
	bcs .set		; $80E04B: B0 16
	lda.w pucky		; $80E04D: AD 7B 09
	bit.w #$8000		; $80E050: 89 00 80
	beq .py		; $80E053: F0 04
	eor.w #$FFFF		; $80E055: 49 FF FF
	inc a		; $80E058: 1A
.py:
	cmp.w #$0108		; $80E059: C9 08 01
	bcc .set		; $80E05C: 90 05
	cmp.w #$0110		; $80E05E: C9 10 01
	bcc .rtl2		; $80E061: 90 0F
.set:
	lda.w facedir,x		; $80E063: BD BF 0D  passdir = facedir; sfspdir
	and.w #$0007		; $80E066: 29 07 00
	sta.w passdir		; $80E069: 8D 3B 04
	lda.w #sfspdir		; $80E06C: A9 04 00
	tsb.w sflags		; $80E06F: 0C 8C 12
.rtl2:
	rtl		; $80E072: 6B
faceoffinput:		;auto: CODE_80E073. 93G faceoffinput (logic93_1): faceoff player X: dpad into fodir1/fodir2, B pulls (SPAfaceoff)
	txa		; $80E073: 8A  faceoff player only
	asl a		; $80E074: 0A
	asl a		; $80E075: 0A
	adc.w assnum,x		; $80E076: 7D BF 0B
	tay		; $80E079: A8
	lda.w asslist,y		; $80E07A: B9 DF 0B
	and.w #$00FF		; $80E07D: 29 FF 00
	cmp.w #afaceoffpl		; $80E080: C9 17 00
	bne .rtl		; $80E083: D0 3F
	lda.w #fodir1		; $80E085: A9 32 01
	sta.b a0		; $80E088: 85 33
	lda.w #$0000		; $80E08A: A9 00 00
	sta.b a0+2		; $80E08D: 85 35
	lda.w pfgoal,x		; $80E08F: BD 3F 11
	beq .store		; $80E092: F0 0A
	lda.w #fodir2		; $80E094: A9 34 01
	sta.b a0		; $80E097: 85 33
	lda.w #$0000		; $80E099: A9 00 00
	sta.b a0+2		; $80E09C: 85 35
.store:
	lda.b d0		; $80E09E: A5 53
	sta.b [a0]		; $80E0A0: 87 33
	lda.w pf2aip,x		; $80E0A2: BD DF 11  pf2aip set: already pulling
	bne .rtl		; $80E0A5: D0 1D
	lda.b d1		; $80E0A7: A5 57
	bit.w #bbut		; $80E0A9: 89 00 80
	beq .nob		; $80E0AC: F0 0E
	lda.w #SPAfaceoff		; $80E0AE: A9 96 10
	sta.b d1		; $80E0B1: 85 57
	lda.w #$0001		; $80E0B3: A9 01 00
	sta.w pf2aip,x		; $80E0B6: 9D DF 11
	jmp.w SetSPA		; $80E0B9: 4C 06 B0
.nob:
	lda.w #SPAfaceoffr		; $80E0BC: A9 C0 10
	sta.b d1		; $80E0BF: 85 57
	jmp.w SetSPA		; $80E0C1: 4C 06 B0
.rtl:
	rtl		; $80E0C4: 6B
holdplayer:		;auto: CODE_80E0C5. 93G holdplayer (logic93_1): Y pressed: hold. With impact, hold the last player who hit X (Acheck)
	lda.w #SPAhook		; $80E0C5: A9 54 13  pfalock
	sta.b d1		; $80E0C8: 85 57
	sta.w pfalock,x		; $80E0CA: 9D 7F 11
	lda.w impact,x		; $80E0CD: BD 7F 0B
	bne .imp		; $80E0D0: D0 03
	jmp.w SetSPA		; $80E0D2: 4C 06 B0
.imp:
	lda.w impactp,x		; $80E0D5: BD 3F 0B  a0 = d0 = impactp*2
	asl a		; $80E0D8: 0A
	sta.b d0		; $80E0D9: 85 53
	sta.b a0		; $80E0DB: 85 33
	jml.l $8FFB5B		; $80E0DD: 5C 5B FB 8F  bank $8F: 93G Acheck
