; $80B006-$80C18E  ROM $03006-$0418E: SetSPA, team personnel (ResetBench, forcepldata, Setplass, setplayer, setpersonel, SetPlList:
; hockey93_05), resetplstuff, assinsert/assreplace, setupice and team colors (hockey93_06), SprSort, the game frame (DoGameFrame,
; periodicevents: hockey93_01), AvgCline, printz/print (middle93_2), updatepwrplay, the goalie pulls (ChkGoalies, ReturnGoalies,
; CPgoalie: logic93_4), updatecrowdf, and PenaltyList (hockey93_11).
org $80B006
SetSPA:		;auto: CODE_80B006. 93G SetSPA (logic93_5): set sprite animation d1 on object X (restart at frame 0)
	lda.b d1		; $80B006: A5 57
	cmp.w SPA,x		; $80B008: DD FF 0D  same animation: keep going
	beq .rtl		; $80B00B: F0 0C
	sta.w SPA,x		; $80B00D: 9D FF 0D
	stz.w SPAnum,x		; $80B010: 9E 1F 0E  SPAnum = 0, SPAcnt = -1
	lda.w #$FFFF		; $80B013: A9 FF FF
	sta.w SPAcnt,x		; $80B016: 9D 3F 0E
.rtl:
	rtl		; $80B019: 6B
ResetBench:		;auto: CODE_80B01A. 93G ResetBench (hockey93_05): empty the penalty boxes / put all players on their own bench. PBnum = players left in the box, home*16 + visitors
	stz.w PBnum		; $80B01A: 9C E4 12
	lda.w #$0010		; $80B01D: A9 10 00  home: +$10 per player
	sta.b d1		; $80B020: 85 57
	stz.b a0		; $80B022: 64 33
	jsl.l .rb		; $80B024: 22 32 B0 80
	lda.w #$0001		; $80B028: A9 01 00
	sta.b d1		; $80B02B: 85 57
	lda.w #$0002		; $80B02D: A9 02 00
	sta.b a0		; $80B030: 85 33
.rb:		;team a0 (0/2), d1 = PBnum step
	lda.w #$0032		; $80B032: A9 32 00  (MaxRos-1)*2
	sta.b d0		; $80B035: 85 53
.rb1:
	lda.w PBnum		; $80B037: AD E4 12
	clc		; $80B03A: 18
	adc.b d1		; $80B03B: 65 57
	sta.w PBnum		; $80B03D: 8D E4 12
	lda.b a0		; $80B040: A5 33
	beq .idx		; $80B042: F0 03
	lda.w #$0034		; $80B044: A9 34 00
.idx:
	adc.b d0		; $80B047: 65 53
	tay		; $80B049: A8
	lda.w tmpdst,y		; $80B04A: B9 E2 14
	bmi .nopen		; $80B04D: 30 19  on the ice or bench
	beq .nopen		; $80B04F: F0 17
	bit.w #TMPDINJ		; $80B051: 89 00 10  TMPDINJ: stays in the box
	beq .next		; $80B054: F0 29
	and.w #$07FF		; $80B056: 29 FF 07  no time left: not counted
	sta.b d2		; $80B059: 85 5B
	bne .next		; $80B05B: D0 22
	lda.w PBnum		; $80B05D: AD E4 12
	sec		; $80B060: 38
	sbc.b d1		; $80B061: E5 57
	sta.w PBnum		; $80B063: 8D E4 12
	bra .next		; $80B066: 80 17
.nopen:
	lda.w PBnum		; $80B068: AD E4 12
	sec		; $80B06B: 38
	sbc.b d1		; $80B06C: E5 57
	sta.w PBnum		; $80B06E: 8D E4 12
	lda.w tmpdst,y		; $80B071: B9 E2 14
	cmp.w #TMPDOUT		; $80B074: C9 FD FF  TMPDOUT stays out
	beq .next		; $80B077: F0 06
	lda.w #TMPDBENCH		; $80B079: A9 FE FF  TMPDBENCH
	sta.w tmpdst,y		; $80B07C: 99 E2 14
.next:
	dec.b d0		; $80B07F: C6 53
	dec.b d0		; $80B081: C6 53
	bpl .rb1		; $80B083: 10 B2
	rtl		; $80B085: 6B
forcepldata:		;auto: CODE_80B086. 93G forcepldata (hockey93_05): a2 = team. No skating on/off: force the players to their new positions (faceoffs only)
	stx.b xsave		; $80B086: 86 0A
	ldx.w #$0000		; $80B088: A2 00 00
.pushd:
	lda.b d0,x		; $80B08B: B5 53
	pha		; $80B08D: 48
	inx		; $80B08E: E8
	inx		; $80B08F: E8
	cpx.w #$0014		; $80B090: E0 14 00
	bne .pushd		; $80B093: D0 F6
	ldx.b xsave		; $80B095: A6 0A
	stx.b xsave		; $80B097: 86 0A
	ldx.w #$0000		; $80B099: A2 00 00
.pusha:
	lda.b a0,x		; $80B09C: B5 33
	pha		; $80B09E: 48
	inx		; $80B09F: E8
	inx		; $80B0A0: E8
	cpx.w #$0010		; $80B0A1: E0 10 00
	bne .pusha		; $80B0A4: D0 F6
	ldx.b xsave		; $80B0A6: A6 0A
	ldy.b a2		; $80B0A8: A4 3B
	lda.w tmsort,y		; $80B0AA: B9 D2 13
	sta.b a3		; $80B0AD: 85 3F
	lda.w #$0005		; $80B0AF: A9 05 00
	sta.b d4		; $80B0B2: 85 63
.top:
	ldx.b a3		; $80B0B4: A6 3F
	lda.w newpos,x		; $80B0B6: BD 9F 0E  position = newpos (byte)
	and.w #$00FF		; $80B0B9: 29 FF 00
	bit.w #$0080		; $80B0BC: 89 80 00
	beq .pos		; $80B0BF: F0 03
	ora.w #$FF00		; $80B0C1: 09 00 FF
.pos:
	sta.b d0		; $80B0C4: 85 53
	sta.w position,x		; $80B0C6: 9D 9F 0B
	cmp.w #$0000		; $80B0C9: C9 00 00
	bmi .next		; $80B0CC: 30 38
	jsl.l Setplass		; $80B0CE: 22 38 B1 80
	ldx.b a3		; $80B0D2: A6 3F
	lda.w position,x		; $80B0D4: BD 9F 0B
	cmp.w #$0004		; $80B0D7: C9 04 00  center
	bne .notnear		; $80B0DA: D0 09
	lda.w #anearest		; $80B0DC: A9 11 00  anearest
	sta.b d0		; $80B0DF: 85 53
	jsl.l assinsert		; $80B0E1: 22 9D B4 80
.notnear:
	ldx.b a3		; $80B0E5: A6 3F
	lda.w newpnum,x		; $80B0E7: BD BF 0E  tmpdst of newpnum = TMPDICE: on the ice
	and.w #$00FF		; $80B0EA: 29 FF 00
	asl a		; $80B0ED: 0A
	sta.b d3		; $80B0EE: 85 5F
	lda.b a2		; $80B0F0: A5 3B
	beq .idx		; $80B0F2: F0 03
	lda.w #$0034		; $80B0F4: A9 34 00
.idx:
	adc.b d3		; $80B0F7: 65 5F
	tay		; $80B0F9: A8
	lda.w #TMPDICE		; $80B0FA: A9 FF FF
	sta.w tmpdst,y		; $80B0FD: 99 E2 14
	lsr.b d3		; $80B100: 46 5F
	jsl.l setplayer		; $80B102: 22 5D B1 80  setplayer
.next:
	ldx.b a3		; $80B106: A6 3F
	lda.w #$FFFF		; $80B108: A9 FF FF  newpnum = newpos = -1
	sta.w newpnum,x		; $80B10B: 9D BF 0E
	sta.w newpos,x		; $80B10E: 9D 9F 0E
	inc.b a3		; $80B111: E6 3F
	inc.b a3		; $80B113: E6 3F
	dec.b d4		; $80B115: C6 63
	bpl .top		; $80B117: 10 9B
	stx.b xsave		; $80B119: 86 0A
	ldx.w #$000E		; $80B11B: A2 0E 00
.popa:
	pla		; $80B11E: 68
	sta.b a0,x		; $80B11F: 95 33
	dex		; $80B121: CA
	dex		; $80B122: CA
	bpl .popa		; $80B123: 10 F9
	ldx.b xsave		; $80B125: A6 0A
	stx.b xsave		; $80B127: 86 0A
	ldx.w #$0012		; $80B129: A2 12 00
.popd:
	pla		; $80B12C: 68
	sta.b d0,x		; $80B12D: 95 53
	dex		; $80B12F: CA
	dex		; $80B130: CA
	bpl .popd		; $80B131: 10 F9
	ldx.b xsave		; $80B133: A6 0A
	ldx.b a3		; $80B135: A6 3F
	rtl		; $80B137: 6B
Setplass:		;auto: CODE_80B138. 93G Setplass (hockey93_05): set the initial assignment of player X from its position
	lda.w position,x		; $80B138: BD 9F 0B
	sta.b d0		; $80B13B: 85 53
	bmi .rtl		; $80B13D: 30 16  no position: no assignment
	lda.w #.alist		; $80B13F: A9 56 B1
	sta.b a0		; $80B142: 85 33
	lda.w #.alist>>16		; $80B144: A9 80 00
	sta.b a0+2		; $80B147: 85 35
	ldy.b d0		; $80B149: A4 53
	lda.b [a0],y		; $80B14B: B7 33
	and.w #$00FF		; $80B14D: 29 FF 00
	sta.b d0		; $80B150: 85 53
	jmp.w assreplace		; $80B152: 4C A7 B4
.rtl:
	rtl		; $80B155: 6B
.alist:		;93G .alist: assignment for each position (goalie, LD, RD, LW, C, RW, extra)
	db agoalie,adefd,adefd,awingd,acenterd,awingd,acenterd		; $80B156
setplayer:		;auto: CODE_80B15D. 93G setplayer (hockey93_05): bring roster player d3 (in d3 = $5F) onto the ice as object X and set his stats from the roster record plus the bonuses
	phx		; $80B15D: DA
	phy		; $80B15E: 5A
	lda.w pflags,x		; $80B15F: BD DF 0E  clear pf2inj
	and.w #~pf2inj&$FFFF		; $80B162: 29 FB FF
	sta.w pflags,x		; $80B165: 9D DF 0E
	stz.b a0		; $80B168: 64 33
	lda.w pfteam,x		; $80B16A: BD 9F 11
	beq .tm		; $80B16D: F0 04
	inc.b a0		; $80B16F: E6 33
	inc.b a0		; $80B171: E6 33
.tm:
	lda.b d3		; $80B173: A5 5F
	and.w #$00FF		; $80B175: 29 FF 00
	sta.w pnum,x		; $80B178: 9D 1F 0F  pnum = d3
	asl a		; $80B17B: 0A
	sta.b d3		; $80B17C: 85 5F
	lda.w #aepen		; $80B17E: A9 0A 00  aepen: from the penalty box
	sta.b d0		; $80B181: 85 53
	lda.b a0		; $80B183: A5 33
	beq .idx		; $80B185: F0 03
	lda.w #$0034		; $80B187: A9 34 00
.idx:
	adc.b d3		; $80B18A: 65 5F
	tay		; $80B18C: A8
	lda.w tmpdst,y		; $80B18D: B9 E2 14
	sta.b d1		; $80B190: 85 57
	bpl .da		; $80B192: 10 0C
	lda.w #aeben		; $80B194: A9 09 00  aeben: from the bench
	sta.b d0		; $80B197: 85 53
	lda.b d1		; $80B199: A5 57
	cmp.w #TMPDBENCH		; $80B19B: C9 FE FF
	bne .nda		; $80B19E: D0 0A
.da:
	jsl.l assinsert		; $80B1A0: 22 9D B4 80
	stz.w pfalock,x		; $80B1A4: 9E 7F 11  pfalock = 0, SPA = 0
	stz.w SPA,x		; $80B1A7: 9E FF 0D
.nda:
	lda.b a0		; $80B1AA: A5 33
	beq .nda1		; $80B1AC: F0 03
	lda.w #$0034		; $80B1AE: A9 34 00
.nda1:
	clc		; $80B1B1: 18
	adc.b d3		; $80B1B2: 65 5F
	tay		; $80B1B4: A8
	lda.w #TMPDICE		; $80B1B5: A9 FF FF  tmpdst = TMPDICE
	sta.w tmpdst,y		; $80B1B8: 99 E2 14
	lsr.b d3		; $80B1BB: 46 5F
	ldy.b a0		; $80B1BD: A4 33  a0 = team data (bank $83)
	lda.w tmdata,y		; $80B1BF: B9 CE 13
	sta.b a0		; $80B1C2: 85 33
	lda.w #$0083		; $80B1C4: A9 83 00
	sta.b a0+2		; $80B1C7: 85 35
	stx.b xsave		; $80B1C9: 86 0A
	ldx.w #$0000		; $80B1CB: A2 00 00
.push:
	lda.b a0,x		; $80B1CE: B5 33
	pha		; $80B1D0: 48
	inx		; $80B1D1: E8
	inx		; $80B1D2: E8
	cpx.w #$0004		; $80B1D3: E0 04 00
	bne .push		; $80B1D6: D0 F6
	ldx.b xsave		; $80B1D8: A6 0A
	ldy.w #$0008		; $80B1DA: A0 08 00  team data + word at +8: bonus bytes
	lda.b [a0],y		; $80B1DD: B7 33
	clc		; $80B1DF: 18
	adc.b a0		; $80B1E0: 65 33
	sta.b a0		; $80B1E2: 85 33
	stz.w PPBonus		; $80B1E4: 9C 75 04  all four bonuses = 0
	stz.w PKBonus		; $80B1E7: 9C 41 04
	stz.b ThirdPBonus		; $80B1EA: 64 F0
	stz.w HmAwBonus		; $80B1EC: 9C 5A 01
	lda.w position,x		; $80B1EF: BD 9F 0B  goalie: no modifiers
	bne .mods		; $80B1F2: D0 03
	jmp.w .nomod		; $80B1F4: 4C 98 B2
.mods:
	lda.w sflags		; $80B1F7: AD 8C 12
	bit.w #sf2pwrplay		; $80B1FA: 89 00 20  sf2pwrplay
	beq .nda3		; $80B1FD: F0 26
	jsl.l chkpk2		; $80B1FF: 22 9F 8D 80
	beq .nda2		; $80B203: F0 0D
	ldy.w #$0001		; $80B205: A0 01 00  power play: PPBonus = low nibble of byte 1
	lda.b [a0],y		; $80B208: B7 33
	and.w #$000F		; $80B20A: 29 0F 00
	sta.w PPBonus		; $80B20D: 8D 75 04
	bra .nda3		; $80B210: 80 13
.nda2:
	ldy.w #$0001		; $80B212: A0 01 00  short-handed: PKBonus = -high nibble of byte 1
	lda.b [a0],y		; $80B215: B7 33
	lsr a		; $80B217: 4A
	lsr a		; $80B218: 4A
	lsr a		; $80B219: 4A
	lsr a		; $80B21A: 4A
	and.w #$000F		; $80B21B: 29 0F 00
	eor.w #$FFFF		; $80B21E: 49 FF FF
	inc a		; $80B221: 1A
	sta.w PKBonus		; $80B222: 8D 41 04
.nda3:
	ldy.w #$0002		; $80B225: A0 02 00  HmAwBonus: home = high nibble of byte 2, visitors = -low nibble
	lda.b [a0],y		; $80B228: B7 33
	and.w #$000F		; $80B22A: 29 0F 00
	eor.w #$FFFF		; $80B22D: 49 FF FF
	inc a		; $80B230: 1A
	sta.b d0		; $80B231: 85 53
	lda.w pfteam,x		; $80B233: BD 9F 11
	bne .tmb		; $80B236: D0 0B
	lda.b [a0],y		; $80B238: B7 33
	lsr a		; $80B23A: 4A
	lsr a		; $80B23B: 4A
	lsr a		; $80B23C: 4A
	lsr a		; $80B23D: 4A
	and.w #$000F		; $80B23E: 29 0F 00
	sta.b d0		; $80B241: 85 53
.tmb:
	lda.b d0		; $80B243: A5 53
	sta.w HmAwBonus		; $80B245: 8D 5A 01
	lda.w gsp		; $80B248: AD F0 12  3rd period?
	sec		; $80B24B: 38
	sbc.w #$0002		; $80B24C: E9 02 00
	bmi .v1		; $80B24F: 30 04
	bvc .p3		; $80B251: 50 04
	bra .nomod		; $80B253: 80 43
.v1:
	bvc .nomod		; $80B255: 50 41
.p3:
	beq .half		; $80B257: F0 08
	bmi .v2		; $80B259: 30 04
	bvs .half		; $80B25B: 70 04
	bra .score		; $80B25D: 80 18
.v2:
	bvs .score		; $80B25F: 70 16
.half:
	jsl.l $86FCA1		; $80B261: 22 A1 FC 86  GetPeriodTime, bank $86: 93G GetPeriodTime
	lsr.b d0		; $80B265: 46 53
	lda.b d0		; $80B267: A5 53
	sec		; $80B269: 38
	sbc.w gameclock		; $80B26A: ED F2 12
	beq .score		; $80B26D: F0 08
	bmi .v3		; $80B26F: 30 04
	bvs .score		; $80B271: 70 04
	bra .nomod		; $80B273: 80 23
.v3:
	bvs .nomod		; $80B275: 70 21
.score:
	lda.w tmscore		; $80B277: AD D6 13  tied or trailing: ThirdPBonus = 2
	sec		; $80B27A: 38
	sbc.w tmscore+2		; $80B27B: ED D8 13
	sta.b tmp0		; $80B27E: 85 73
	beq .close		; $80B280: F0 11
	lda.w pfteam,x		; $80B282: BD 9F 11
	beq .side		; $80B285: F0 08
	lda.b tmp0		; $80B287: A5 73
	eor.w #$FFFF		; $80B289: 49 FF FF
	inc a		; $80B28C: 1A
	sta.b tmp0		; $80B28D: 85 73
.side:
	lda.b tmp0		; $80B28F: A5 73
	bpl .nomod		; $80B291: 10 05
.close:
	lda.w #$0002		; $80B293: A9 02 00
	sta.b ThirdPBonus		; $80B296: 85 F0
.nomod:
	stx.b xsave		; $80B298: 86 0A
	ldx.w #$0002		; $80B29A: A2 02 00
.pop:
	pla		; $80B29D: 68
	sta.b a0,x		; $80B29E: 95 33
	dex		; $80B2A0: CA
	dex		; $80B2A1: CA
	bpl .pop		; $80B2A2: 10 F9
	ldx.b xsave		; $80B2A4: A6 0A
	ldy.w #$0000		; $80B2A6: A0 00 00  a0 = roster records
	lda.b [a0],y		; $80B2A9: B7 33
	clc		; $80B2AB: 18
	adc.b a0		; $80B2AC: 65 33
	sta.b a0		; $80B2AE: 85 33
.find:		;skip the roster records before player d3
	lda.b [a0]		; $80B2B0: A7 33
	clc		; $80B2B2: 18
	adc.b a0		; $80B2B3: 65 33
	adc.w #$0008		; $80B2B5: 69 08 00
	sta.b a0		; $80B2B8: 85 33
	dec.b d3		; $80B2BA: C6 5F
	bpl .find		; $80B2BC: 10 F2
	lda.b a0		; $80B2BE: A5 33
	sec		; $80B2C0: 38
	sbc.w #$0008		; $80B2C1: E9 08 00
	sta.b a0		; $80B2C4: 85 33
	lda.b [a0]		; $80B2C6: A7 33  byte 0: rostnum
	and.w #$00FF		; $80B2C8: 29 FF 00
	sta.w rostnum,x		; $80B2CB: 9D 3F 10
	ldy.w #$0001		; $80B2CE: A0 01 00  byte 1: weight (high nibble*8), legstr
	lda.b [a0],y		; $80B2D1: B7 33
	and.w #$00F0		; $80B2D3: 29 F0 00
	lsr a		; $80B2D6: 4A
	sta.w weight,x		; $80B2D7: 9D 3F 0F
	lda.b [a0],y		; $80B2DA: B7 33
	and.w #$000F		; $80B2DC: 29 0F 00
	sta.w legstr,x		; $80B2DF: 9D 5F 0F
	iny		; $80B2E2: C8  byte 2: legspd, aioff
	lda.b [a0],y		; $80B2E3: B7 33
	lsr a		; $80B2E5: 4A
	lsr a		; $80B2E6: 4A
	lsr a		; $80B2E7: 4A
	lsr a		; $80B2E8: 4A
	and.w #$000F		; $80B2E9: 29 0F 00
	sta.w legspd,x		; $80B2EC: 9D 7F 0F
	lda.b [a0],y		; $80B2EF: B7 33
	and.w #$000F		; $80B2F1: 29 0F 00
	clc		; $80B2F4: 18
	adc.w PPBonus		; $80B2F5: 6D 75 04
	clc		; $80B2F8: 18
	adc.w PKBonus		; $80B2F9: 6D 41 04
	clc		; $80B2FC: 18
	adc.w HmAwBonus		; $80B2FD: 6D 5A 01
	clc		; $80B300: 18
	adc.b ThirdPBonus		; $80B301: 65 F0
	jsl.l ClampNibble		; $80B303: 22 E7 B3 80
	eor.w #$000F		; $80B307: 49 0F 00  frames to skip: (15-n+15)/2
	clc		; $80B30A: 18
	adc.w #$000F		; $80B30B: 69 0F 00
	lsr a		; $80B30E: 4A
	sta.w aioff,x		; $80B30F: 9D 9F 0F
	iny		; $80B312: C8  byte 3: aidef, shotspd
	lda.b [a0],y		; $80B313: B7 33
	lsr a		; $80B315: 4A
	lsr a		; $80B316: 4A
	lsr a		; $80B317: 4A
	lsr a		; $80B318: 4A
	and.w #$000F		; $80B319: 29 0F 00
	clc		; $80B31C: 18
	adc.w HmAwBonus		; $80B31D: 6D 5A 01
	jsl.l ClampNibble		; $80B320: 22 E7 B3 80
	eor.w #$000F		; $80B324: 49 0F 00
	clc		; $80B327: 18
	adc.w #$000F		; $80B328: 69 0F 00
	lsr a		; $80B32B: 4A
	sta.w aidef,x		; $80B32C: 9D BF 0F
	lda.b [a0],y		; $80B32F: B7 33
	and.w #$000F		; $80B331: 29 0F 00
	sta.w shotspd,x		; $80B334: 9D DF 0F
	lda.w attribute,x		; $80B337: BD DF 09  clear the x flip
	and.w #~attrxflip&$FFFF		; $80B33A: 29 FF F7
	sta.w attribute,x		; $80B33D: 9D DF 09
	iny		; $80B340: C8  byte 4: aggress, handed, fightagg
	lda.b [a0],y		; $80B341: B7 33
	lsr a		; $80B343: 4A
	lsr a		; $80B344: 4A
	lsr a		; $80B345: 4A
	lsr a		; $80B346: 4A
	and.w #$000F		; $80B347: 29 0F 00
	clc		; $80B34A: 18
	adc.b ThirdPBonus		; $80B34B: 65 F0
	jsl.l ClampNibble		; $80B34D: 22 E7 B3 80
	sta.w aggress,x		; $80B351: 9D FF 10
	lda.b [a0],y		; $80B354: B7 33
	and.w #$0001		; $80B356: 29 01 00  bit 0 set: left handed
	sta.w handed,x		; $80B359: 9D 1F 11
	bne .ha		; $80B35C: D0 09
	lda.w attribute,x		; $80B35E: BD DF 09
	ora.w #attrxflip		; $80B361: 09 00 08
	sta.w attribute,x		; $80B364: 9D DF 09
.ha:
	lda.b [a0],y		; $80B367: B7 33
	and.w #$000E		; $80B369: 29 0E 00
	sta.w fightagg,x		; $80B36C: 9D DF 10
	iny		; $80B36F: C8  byte 5: stickhand, shotacc
	lda.b [a0],y		; $80B370: B7 33
	lsr a		; $80B372: 4A
	lsr a		; $80B373: 4A
	lsr a		; $80B374: 4A
	lsr a		; $80B375: 4A
	and.w #$000F		; $80B376: 29 0F 00
	clc		; $80B379: 18
	adc.w PPBonus		; $80B37A: 6D 75 04
	clc		; $80B37D: 18
	adc.w PKBonus		; $80B37E: 6D 41 04
	clc		; $80B381: 18
	adc.w HmAwBonus		; $80B382: 6D 5A 01
	jsl.l ClampNibble		; $80B385: 22 E7 B3 80
	sta.w stickhand,x		; $80B389: 9D 7F 10
	lda.b [a0],y		; $80B38C: B7 33
	and.w #$000F		; $80B38E: 29 0F 00
	clc		; $80B391: 18
	adc.w PPBonus		; $80B392: 6D 75 04
	clc		; $80B395: 18
	adc.w PKBonus		; $80B396: 6D 41 04
	clc		; $80B399: 18
	adc.w HmAwBonus		; $80B39A: 6D 5A 01
	jsl.l ClampNibble		; $80B39D: 22 E7 B3 80
	sta.w shotacc,x		; $80B3A1: 9D FF 0F
	iny		; $80B3A4: C8  byte 6: endurance, spodds
	lda.b [a0],y		; $80B3A5: B7 33
	lsr a		; $80B3A7: 4A
	lsr a		; $80B3A8: 4A
	lsr a		; $80B3A9: 4A
	lsr a		; $80B3AA: 4A
	and.w #$000F		; $80B3AB: 29 0F 00
	sta.w endurance,x		; $80B3AE: 9D 9F 10
	lda.b [a0],y		; $80B3B1: B7 33
	and.w #$000F		; $80B3B3: 29 0F 00
	clc		; $80B3B6: 18
	adc.b ThirdPBonus		; $80B3B7: 65 F0
	clc		; $80B3B9: 18
	adc.b ThirdPBonus		; $80B3BA: 65 F0
	jsl.l ClampNibble		; $80B3BC: 22 E7 B3 80
	sta.w spodds,x		; $80B3C0: 9D 5F 10
	iny		; $80B3C3: C8  byte 7: passacc, GGSleft
	lda.b [a0],y		; $80B3C4: B7 33
	lsr a		; $80B3C6: 4A
	lsr a		; $80B3C7: 4A
	lsr a		; $80B3C8: 4A
	lsr a		; $80B3C9: 4A
	and.w #$000F		; $80B3CA: 29 0F 00
	clc		; $80B3CD: 18
	adc.w PPBonus		; $80B3CE: 6D 75 04
	clc		; $80B3D1: 18
	adc.w HmAwBonus		; $80B3D2: 6D 5A 01
	jsl.l ClampNibble		; $80B3D5: 22 E7 B3 80
	sta.w passacc,x		; $80B3D9: 9D 1F 10
	lda.b [a0],y		; $80B3DC: B7 33
	and.w #$000F		; $80B3DE: 29 0F 00
	sta.w GGSleft,x		; $80B3E1: 9D BF 10
	ply		; $80B3E4: 7A
	plx		; $80B3E5: FA
	rtl		; $80B3E6: 6B
ClampNibble:		;auto: CODE_80B3E7. 93G ClampNibble (hockey93_05): clamp A to 0-15
	bit.w #$0080		; $80B3E7: 89 80 00  negative: 0
	beq .hi		; $80B3EA: F0 03
	lda.w #$0000		; $80B3EC: A9 00 00
.hi:
	cmp.w #$000F		; $80B3EF: C9 0F 00
	bcc .x		; $80B3F2: 90 03
	lda.w #$000F		; $80B3F4: A9 0F 00
.x:
	rtl		; $80B3F7: 6B
resetplstuff:		;auto: CODE_80B3F8. 93G resetplstuff (hockey93_06): reset team variables and the players on both teams
	stx.b xsave		; $80B3F8: 86 0A
	ldx.w #$0000		; $80B3FA: A2 00 00
.pushd:
	lda.b d0,x		; $80B3FD: B5 53
	pha		; $80B3FF: 48
	inx		; $80B400: E8
	inx		; $80B401: E8
	cpx.w #$000C		; $80B402: E0 0C 00
	bne .pushd		; $80B405: D0 F6
	ldx.b xsave		; $80B407: A6 0A
	stx.b xsave		; $80B409: 86 0A
	ldx.w #$0000		; $80B40B: A2 00 00
.pusha:
	lda.b a0,x		; $80B40E: B5 33
	pha		; $80B410: 48
	inx		; $80B411: E8
	inx		; $80B412: E8
	cpx.w #$0010		; $80B413: E0 10 00
	bne .pusha		; $80B416: D0 F6
	ldx.b xsave		; $80B418: A6 0A
	stz.b a2		; $80B41A: 64 3B
	jsl.l .top		; $80B41C: 22 48 B4 80
	lda.w #$0002		; $80B420: A9 02 00
	sta.b a2		; $80B423: 85 3B
	jsl.l .top		; $80B425: 22 48 B4 80
	stx.b xsave		; $80B429: 86 0A
	ldx.w #$000E		; $80B42B: A2 0E 00
.popa:
	pla		; $80B42E: 68
	sta.b a0,x		; $80B42F: 95 33
	dex		; $80B431: CA
	dex		; $80B432: CA
	bpl .popa		; $80B433: 10 F9
	ldx.b xsave		; $80B435: A6 0A
	stx.b xsave		; $80B437: 86 0A
	ldx.w #$000A		; $80B439: A2 0A 00
.popd:
	pla		; $80B43C: 68
	sta.b d0,x		; $80B43D: 95 53
	dex		; $80B43F: CA
	dex		; $80B440: CA
	bpl .popd		; $80B441: 10 F9
	ldx.b xsave		; $80B443: A6 0A
	ldx.b a3		; $80B445: A6 3F
	rtl		; $80B447: 6B
.top:		;team a2
	ldy.b a2		; $80B448: A4 3B
	lda.w tmflags,y		; $80B44A: B9 0A 14
	and.w #~tmfoffside&$FFFF		; $80B44D: 29 EF FF  clear tmfoffside
	sta.w tmflags,y		; $80B450: 99 0A 14
	lda.w #$0005		; $80B453: A9 05 00
	sta.b d2		; $80B456: 85 5B
	ldx.w tmsort,y		; $80B458: BE D2 13
	stx.b a3		; $80B45B: 86 3F
.loop:
	stz.w pf2fight,x		; $80B45D: 9E 5F 11  pf2fight = pf2aip = 0, pflags2 bits cleared
	stz.w pf2aip,x		; $80B460: 9E DF 11
	lda.w pflags,x		; $80B463: BD DF 0E
	and.w #~(pf2unav|pf2lcm|pf2pen|pf2npc)&$FFFF		; $80B466: 29 FF 0F
	sta.w pflags,x		; $80B469: 9D DF 0E
	lda.w position,x		; $80B46C: BD 9F 0B
	bmi .next		; $80B46F: 30 21
	lda.w #SPAglide		; $80B471: A9 78 04
	sta.b d1		; $80B474: 85 57
	jsl.l SetSPA		; $80B476: 22 06 B0 80
	stz.w impact,x		; $80B47A: 9E 7F 0B  impact = 0, nopuck = 0
	stz.w nopuck,x		; $80B47D: 9E 5F 0E
	lda.w pflags,x		; $80B480: BD DF 0E
	and.w #~(pfdoff|pfjoycon)&$FFFF		; $80B483: 29 F6 FF  keep pfteam/pfgoal/pfna: clear pfdoff, pfjoycon
	sta.w pflags,x		; $80B486: 9D DF 0E
	stz.w pfnc,x		; $80B489: 9E FF 11
	stz.w pfrev,x		; $80B48C: 9E BF 11
	stz.w pfalock,x		; $80B48F: 9E 7F 11
.next:
	inc.b a3		; $80B492: E6 3F
	inc.b a3		; $80B494: E6 3F
	ldx.b a3		; $80B496: A6 3F
	dec.b d2		; $80B498: C6 5B
	bpl .loop		; $80B49A: 10 C1
	rtl		; $80B49C: 6B
assinsert:		;auto: CODE_80B49D. 93G assinsert (logic93_5): insert assignment d0 on player X. Falls into assreplace
	lda.w assnum,x		; $80B49D: BD BF 0B  assnum - 1
	dec a		; $80B4A0: 3A
	and.w #$0007		; $80B4A1: 29 07 00
	sta.w assnum,x		; $80B4A4: 9D BF 0B
assreplace:		;auto: CODE_80B4A7. 93G assreplace (logic93_5): replace the current assignment of player X with d0
	lda.w pflags,x		; $80B4A7: BD DF 0E
	ora.w #pfna		; $80B4AA: 09 02 00  pfna
	sta.w pflags,x		; $80B4AD: 9D DF 0E
	txa		; $80B4B0: 8A  asslist+X*4+assnum = d0 (byte)
	asl a		; $80B4B1: 0A
	asl a		; $80B4B2: 0A
	adc.w assnum,x		; $80B4B3: 7D BF 0B
	tay		; $80B4B6: A8
	sep #$20		; $80B4B7: E2 20
	lda.b d0		; $80B4B9: A5 53
	sta.w asslist,y		; $80B4BB: 99 DF 0B
	rep #$30		; $80B4BE: C2 30
	rtl		; $80B4C0: 6B
setupice:		;auto: CODE_80B4C1. 93G setupice (hockey93_06): set all variables, send the rink and text graphics to vram, palettes, video mode, team colors
	jsl.l $8FE404		; $80B4C1: 22 04 E4 8F  93G setvram role (bank $8F), bank $8F
	lda.w #$0207		; $80B4C5: A9 07 02  vram tile bases of the text layer
	sta.w faceoffvrcset		; $80B4C8: 8D D9 1B
	clc		; $80B4CB: 18
	adc.w #$0037		; $80B4CC: 69 37 00
	sta.w unusedchars		; $80B4CF: 8D D3 1B
	adc.w #$000E		; $80B4D2: 69 0E 00
	sta.w refcharshor		; $80B4D5: 8D DF 1B
	adc.w #$0068		; $80B4D8: 69 68 00
	sta.w refchars		; $80B4DB: 8D E1 1B
	adc.w #$0075		; $80B4DE: 69 75 00
	sta.w blankchar		; $80B4E1: 8D E7 1B
	inc a		; $80B4E4: 1A
	sta.w smallfontchars		; $80B4E5: 8D D7 1B
	adc.w #$0064		; $80B4E8: 69 64 00
	sta.w Framercset		; $80B4EB: 8D DB 1B
	adc.w #$0004		; $80B4EE: 69 04 00
	sta.w BigFontChars		; $80B4F1: 8D D1 1B
	adc.w #$0090		; $80B4F4: 69 90 00
	sta.w scorechars		; $80B4F7: 8D E5 1B
	adc.w #$0195		; $80B4FA: 69 95 01
	sta.w ExtraChars		; $80B4FD: 8D D5 1B
	lda.w #$FF00		; $80B500: A9 00 FF  charofs = $FF00
	sta.w charofs		; $80B503: 8D CD 1B
	stz.w charofs+2		; $80B506: 9C CF 1B
	jsl.l $8D8120		; $80B509: 22 20 81 8D  PPU init (bank $8D), bank $8D: PPU registers off/clear, sound driver start
	sep #$20		; $80B50D: E2 20
	cli		; $80B50F: 58
	lda.w RDNMI		; $80B510: AD 10 42
	lda.b #$81		; $80B513: A9 81  NMI on, auto joypad read
	sta.w NMITIMEN		; $80B515: 8D 00 42
	lda.b #$03		; $80B518: A9 03  OBSEL: 8x8/16x16 sprites at $6000
	sta.w OBSEL		; $80B51A: 8D 01 21
	lda.b #$01		; $80B51D: A9 01  BGMODE 1
	sta.w BGMODE		; $80B51F: 8D 05 21
	lda.b #$00		; $80B522: A9 00
	sta.w BG1SC		; $80B524: 8D 07 21
	lda.b #$05		; $80B527: A9 05  BG2 map at $0400, 64x32
	sta.w BG2SC		; $80B529: 8D 08 21
	lda.b #$12		; $80B52C: A9 12  BG1 tiles $2000, BG2 tiles $1000
	sta.w BG12NBA		; $80B52E: 8D 0B 21
	lda.b #$13		; $80B531: A9 13  TM: BG1, BG2, sprites
	sta.w TM		; $80B533: 8D 2C 21
	rep #$30		; $80B536: C2 30
	ldx.w #$00FE		; $80B538: A2 FE 00
.pal:		;rink palette (bank $83) to both halves of palbuffer
	lda.l $83F72B,x		; $80B53B: BF 2B F7 83
	sta.l palbuffer,x		; $80B53F: 9F 74 6C 7E
	sta.l palbuffer+$100,x		; $80B543: 9F 74 6D 7E
	dex		; $80B547: CA
	dex		; $80B548: CA
	bpl .pal		; $80B549: 10 F0
	jsl.l $82FA1A		; $80B54B: 22 1A FA 82  sound queue reset (bank $82), bank $82: reset the sound command queue
	lda.w sndbank		; $80B54F: AD 4F 16  in-game sound set not loaded yet: load it
	cmp.w #$0001		; $80B552: C9 01 00
	beq .gfx		; $80B555: F0 04
	jsl.l $82FA7A		; $80B557: 22 7A FA 82  bank $82
.gfx:		;decompress each tile set to $7F0000 and send it to vram
	lda.w #$CDA0		; $80B55B: A9 A0 CD  rink tiles (bank $82)
	sta.b tmp0		; $80B55E: 85 73
	lda.w #$0082		; $80B560: A9 82 00
	sta.b tmp1		; $80B563: 85 75
	jsl.l $86FA3E		; $80B565: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	lda.w #$1000		; $80B569: A9 00 10  vram $1000
	sta.w VMADDL		; $80B56C: 8D 16 21
	ldx.w #$0000		; $80B56F: A2 00 00
.up1:
	lda.l $7F0000,x		; $80B572: BF 00 00 7F
	sta.w VMDATAL		; $80B576: 8D 18 21
	inx		; $80B579: E8
	inx		; $80B57A: E8
	cpx.w #$40E0		; $80B57B: E0 E0 40
	bne .up1		; $80B57E: D0 F2
	lda.w #$C6B4		; $80B580: A9 B4 C6  bank $87 tiles
	sta.b tmp0		; $80B583: 85 73
	lda.w #$0087		; $80B585: A9 87 00
	sta.b tmp1		; $80B588: 85 75
	jsl.l $86FA3E		; $80B58A: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	ldx.w #$0000		; $80B58E: A2 00 00
.up2:
	lda.l $7F0000,x		; $80B591: BF 00 00 7F
	sta.w VMDATAL		; $80B595: 8D 18 21
	inx		; $80B598: E8
	inx		; $80B599: E8
	cpx.w #$06E0		; $80B59A: E0 E0 06
	bne .up2		; $80B59D: D0 F2
	lda.w #$F386		; $80B59F: A9 86 F3  bank $84 tiles
	sta.b tmp0		; $80B5A2: 85 73
	lda.w #$0084		; $80B5A4: A9 84 00
	sta.b tmp1		; $80B5A7: 85 75
	jsl.l $86FA3E		; $80B5A9: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	ldx.w #$0000		; $80B5AD: A2 00 00
.up3:
	lda.l $7F0000,x		; $80B5B0: BF 00 00 7F
	sta.w VMDATAL		; $80B5B4: 8D 18 21
	inx		; $80B5B7: E8
	inx		; $80B5B8: E8
	cpx.w #$01C0		; $80B5B9: E0 C0 01
	bne .up3		; $80B5BC: D0 F2
	lda.w #$EB45		; $80B5BE: A9 45 EB  bank $89 tiles
	sta.b tmp0		; $80B5C1: 85 73
	lda.w #$0089		; $80B5C3: A9 89 00
	sta.b tmp1		; $80B5C6: 85 75
	jsl.l $86FA3E		; $80B5C8: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	ldx.w #$0000		; $80B5CC: A2 00 00
.up4:
	lda.l $7F0000,x		; $80B5CF: BF 00 00 7F
	sta.w VMDATAL		; $80B5D3: 8D 18 21
	inx		; $80B5D6: E8
	inx		; $80B5D7: E8
	cpx.w #$0D00		; $80B5D8: E0 00 0D
	bne .up4		; $80B5DB: D0 F2
	lda.w #$F55E		; $80B5DD: A9 5E F5  bank $87 tiles
	sta.b tmp0		; $80B5E0: 85 73
	lda.w #$0087		; $80B5E2: A9 87 00
	sta.b tmp1		; $80B5E5: 85 75
	jsl.l $86FA3E		; $80B5E7: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	ldx.w #$0000		; $80B5EB: A2 00 00
.up5:
	lda.l $7F0000,x		; $80B5EE: BF 00 00 7F
	sta.w VMDATAL		; $80B5F2: 8D 18 21
	inx		; $80B5F5: E8
	inx		; $80B5F6: E8
	cpx.w #$0EA0		; $80B5F7: E0 A0 0E
	bne .up5		; $80B5FA: D0 F2
	ldx.w #$0010		; $80B5FC: A2 10 00
.blank:		;blank tile
	stz.w VMDATAL		; $80B5FF: 9C 18 21
	dex		; $80B602: CA
	bne .blank		; $80B603: D0 FA
	lda.w #$C6D8		; $80B605: A9 D8 C6  bank $83 data
	sta.b tmp0		; $80B608: 85 73
	lda.w #$0083		; $80B60A: A9 83 00
	sta.b tmp1		; $80B60D: 85 75
	jsl.l $86FA3E		; $80B60F: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	stz.b a0		; $80B613: 64 33  sprite frame list from the $7F0000 data
	lda.w #$007F		; $80B615: A9 7F 00
	sta.b a0+2		; $80B618: 85 35
	lda.w #$FCD4		; $80B61A: A9 D4 FC
	sta.b a1		; $80B61D: 85 37
	lda.w #$0082		; $80B61F: A9 82 00
	sta.b a1+2		; $80B622: 85 39
	lda.w #$0064		; $80B624: A9 64 00
	sta.b d0		; $80B627: 85 53
	jsl.l $8FE0E4		; $80B629: 22 E4 E0 8F  bank $8F: build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #$872E		; $80B62D: A9 2E 87
	sta.b a0		; $80B630: 85 33
	lda.w #$0088		; $80B632: A9 88 00
	sta.b a0+2		; $80B635: 85 35
	lda.w #$F55A		; $80B637: A9 5A F5
	sta.b a1		; $80B63A: 85 37
	lda.w #$0087		; $80B63C: A9 87 00
	sta.b a1+2		; $80B63F: 85 39
	lda.w #$0004		; $80B641: A9 04 00
	sta.b d0		; $80B644: 85 53
	jsl.l $8FE0E4		; $80B646: 22 E4 E0 8F  bank $8F: build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #$EEC8		; $80B64A: A9 C8 EE
	sta.b tmp0		; $80B64D: 85 73
	lda.w #$008D		; $80B64F: A9 8D 00
	sta.b tmp1		; $80B652: 85 75
	jsl.l $86FA3E		; $80B654: 22 3E FA 86  bank $86: 93G DecompressGraphics ([tmp0] -> $7F0000)
	stz.b a0		; $80B658: 64 33
	lda.w #$007F		; $80B65A: A9 7F 00
	sta.b a0+2		; $80B65D: 85 35
	lda.w #$FCBD		; $80B65F: A9 BD FC
	sta.b a1		; $80B662: 85 37
	lda.w #$0082		; $80B664: A9 82 00
	sta.b a1+2		; $80B667: 85 39
	lda.w #$0090		; $80B669: A9 90 00
	sta.b d0		; $80B66C: 85 53
	jsl.l $8FE0E4		; $80B66E: 22 E4 E0 8F  bank $8F: build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #999		; $80B672: A9 E7 03  Oldrow = 999, no pause, Hpos = Vpos = 0
	sta.w Oldrow		; $80B675: 8D 9B 04
	lda.w #$0001		; $80B678: A9 01 00
	trb.w sflags		; $80B67B: 1C 8C 12
	stz.w Hpos		; $80B67E: 9C 54 01
	stz.w Vpos		; $80B681: 9C DF 08
	lda.b vcount+2		; $80B684: A5 02  vcountmark well in the past
	dec a		; $80B686: 3A
	dec a		; $80B687: 3A
	sta.w vcountmark+2		; $80B688: 8D FD 08
	jsl.l $84F816		; $80B68B: 22 16 F8 84  bank $84
	stz.w zamx		; $80B68F: 9C DD 08
	jsl.l nullrtl		; $80B692: 22 6B B7 80
	lda.w gmode		; $80B696: AD 88 12
	bit.w #gmdir		; $80B699: 89 02 00  gmdir
	beq .gok		; $80B69C: F0 10
	ldx.w #$0016		; $80B69E: A2 16 00
.flip:		;gmdir: flip pfgoal of the 12 players
	lda.w pfgoal,x		; $80B6A1: BD 3F 11
	eor.w #$0001		; $80B6A4: 49 01 00
	sta.w pfgoal,x		; $80B6A7: 9D 3F 11
	dex		; $80B6AA: CA
	dex		; $80B6AB: CA
	bpl .flip		; $80B6AC: 10 F3
.gok:
	jsl.l setplayercolors		; $80B6AE: 22 D5 B6 80
	lda.w #$FFFF		; $80B6B2: A9 FF FF  PadControlBits = $FFFF, padcont = 0
	sta.w PadControlBits		; $80B6B5: 8D 31 04
	stz.w padcont		; $80B6B8: 9C 33 04
	stz.w padcont+2		; $80B6BB: 9C 35 04
	stz.w padcont+4		; $80B6BE: 9C 37 04
	stz.w padcont+6		; $80B6C1: 9C 39 04
	lda.w #$FFFF		; $80B6C4: A9 FF FF  c1playernum = c2playernum = -1
	sta.w c1playernum		; $80B6C7: 8D 92 12
	sta.w c2playernum		; $80B6CA: 8D 94 12
	stz.b brightness		; $80B6CD: 64 04  brightness 0, fade in after 10 frames
	lda.w #$000A		; $80B6CF: A9 0A 00
	sta.b fadein		; $80B6D2: 85 08
	rtl		; $80B6D4: 6B
setplayercolors:		;auto: CODE_80B6D5. 93G setplayercolors (hockey93_06): team colors into palbuffer, then the whole palette to CGRAM
	stz.w ffoframe+6		; $80B6D5: 9C 06 01  pad 3 frame = 0
	stz.w colorflag1		; $80B6D8: 9C B7 08
	stz.w colorflag2		; $80B6DB: 9C B9 08
	jsl.l SetTeamColors		; $80B6DE: 22 06 B7 80
	lda.w #$2200		; $80B6E2: A9 00 22  whole CGRAM from palbuffer
	sta.w DMAP7		; $80B6E5: 8D 70 43
	lda.w #palbuffer		; $80B6E8: A9 74 6C
	sta.w A1T7L		; $80B6EB: 8D 72 43
	lda.w #$0200		; $80B6EE: A9 00 02
	sta.w DAS7L		; $80B6F1: 8D 75 43
	sep #$20		; $80B6F4: E2 20
	stz.w CGADD		; $80B6F6: 9C 21 21
	lda.b #palbuffer>>16		; $80B6F9: A9 7E
	sta.w A1B7		; $80B6FB: 8D 74 43
	lda.b #$80		; $80B6FE: A9 80
	sta.w MDMAEN		; $80B700: 8D 0B 42
	rep #$30		; $80B703: C2 30
	rtl		; $80B705: 6B
SetTeamColors:		;auto: CODE_80B706. 92 SetTeamColors role: convert both teams' Genesis colors (team data +2) to SNES colors in palbuffer (BG and sprite halves)
	phx		; $80B706: DA
	phy		; $80B707: 5A
	ldx.w #$0000		; $80B708: A2 00 00
	lda.w tmdata		; $80B70B: AD CE 13  home team colors: palbuffer+$40
	sta.b tmp0		; $80B70E: 85 73
	lda.w #$0083		; $80B710: A9 83 00
	sta.b tmp1		; $80B713: 85 75
	stz.b tmp2+1		; $80B715: 64 78
	jsl.l SetTeamColors_team		; $80B717: 22 2C B7 80
	lda.w tmdata+2		; $80B71B: AD D0 13  away team colors: palbuffer+$60
	sta.b tmp0		; $80B71E: 85 73
	lda.w #$0020		; $80B720: A9 20 00
	sta.b tmp2+1		; $80B723: 85 78
	jsl.l SetTeamColors_team		; $80B725: 22 2C B7 80
	ply		; $80B729: 7A
	plx		; $80B72A: FA
	rtl		; $80B72B: 6B
SetTeamColors_team:		;auto: CODE_80B72C. one team: tmp0 = team data, tmp2+1 = palbuffer offset
	ldy.w #$0002		; $80B72C: A0 02 00  team data + word at +2: palette
	lda.b [tmp0],y		; $80B72F: B7 73
	clc		; $80B731: 18
	adc.b tmp2+1		; $80B732: 65 78
	tay		; $80B734: A8
	lda.w #$0010		; $80B735: A9 10 00
	sta.b tmp2+1		; $80B738: 85 78
.col:		;0BGR (4 bits) -> 0BBBBBGGGGGRRRRR
	lda.b [tmp0],y		; $80B73A: B7 73
	xba		; $80B73C: EB
	and.w #$000F		; $80B73D: 29 0F 00
	asl a		; $80B740: 0A
	sta.b tmp1+1		; $80B741: 85 76
	lda.b [tmp0],y		; $80B743: B7 73
	xba		; $80B745: EB
	and.w #$00F0		; $80B746: 29 F0 00
	asl a		; $80B749: 0A
	asl a		; $80B74A: 0A
	ora.b tmp1+1		; $80B74B: 05 76
	sta.b tmp1+1		; $80B74D: 85 76
	lda.b [tmp0],y		; $80B74F: B7 73
	xba		; $80B751: EB
	and.w #$0F00		; $80B752: 29 00 0F
	asl a		; $80B755: 0A
	asl a		; $80B756: 0A
	asl a		; $80B757: 0A
	ora.b tmp1+1		; $80B758: 05 76
	sta.l palbuffer+$40,x		; $80B75A: 9F B4 6C 7E
	sta.l palbuffer+$140,x		; $80B75E: 9F B4 6D 7E
	inx		; $80B762: E8
	inx		; $80B763: E8
	iny		; $80B764: C8
	iny		; $80B765: C8
	dec.b tmp2+1		; $80B766: C6 78
	bne .col		; $80B768: D0 D0
	rtl		; $80B76A: 6B
nullrtl:		;auto: CODE_80B76B. does nothing (setupice calls it)
	rtl		; $80B76B: 6B
SprSort:		;auto: CODE_80B76C. 93G SprSort (hockey93_06): sort the objects by y (x in horizontal mode) into OOlist/OOlistpos
	phx		; $80B76C: DA
	phy		; $80B76D: 5A
	stx.b xsave		; $80B76E: 86 0A
	ldx.w #$0000		; $80B770: A2 00 00
.push:
	lda.b d0,x		; $80B773: B5 53
	pha		; $80B775: 48
	inx		; $80B776: E8
	inx		; $80B777: E8
	cpx.w #$000C		; $80B778: E0 0C 00
	bne .push		; $80B77B: D0 F6
	ldx.b xsave		; $80B77D: A6 0A
	ldx.w #$0000		; $80B77F: A2 00 00
	lda.w sfhormode		; $80B782: AD 8E 12  horizontal mode sorts by x
	bne .xlist		; $80B785: D0 0F
.ylist:
	lda.w Ypos,x		; $80B787: BD 5F 09
	sta.w Ylist,x		; $80B78A: 9D 1F 12
	inx		; $80B78D: E8
	inx		; $80B78E: E8
	cpx.w #$0020		; $80B78F: E0 20 00
	bne .ylist		; $80B792: D0 F3
	bra .loop		; $80B794: 80 0D
.xlist:
	lda.w Xpos,x		; $80B796: BD FF 08
	sta.w Ylist,x		; $80B799: 9D 1F 12
	inx		; $80B79C: E8
	inx		; $80B79D: E8
	cpx.w #$0020		; $80B79E: E0 20 00
	bne .xlist		; $80B7A1: D0 F3
.loop:
	stz.b d2		; $80B7A3: 64 5B
	ldx.w #$0000		; $80B7A5: A2 00 00
.pair:
	lda.w OOlist+1,x		; $80B7A8: BD 60 12
	and.w #$00FF		; $80B7AB: 29 FF 00
	sta.b d1		; $80B7AE: 85 57
	lda.w OOlist,x		; $80B7B0: BD 5F 12
	and.w #$00FF		; $80B7B3: 29 FF 00
	sta.b d0		; $80B7B6: 85 53
	tay		; $80B7B8: A8
	lda.w Ylist,y		; $80B7B9: B9 1F 12
	ldy.b d1		; $80B7BC: A4 57
	sec		; $80B7BE: 38
	sbc.w Ylist,y		; $80B7BF: F9 1F 12
	beq .next		; $80B7C2: F0 1B
	bmi .v1		; $80B7C4: 30 04
	bvc .swap		; $80B7C6: 50 04
	bra .next		; $80B7C8: 80 15
.v1:
	bvc .next		; $80B7CA: 50 13
.swap:
	lda.w OOlist,x		; $80B7CC: BD 5F 12
	xba		; $80B7CF: EB
	sta.w OOlist,x		; $80B7D0: 9D 5F 12
	txa		; $80B7D3: 8A
	sta.w OOlistpos,y		; $80B7D4: 99 3F 12
	inc a		; $80B7D7: 1A
	ldy.b d0		; $80B7D8: A4 53
	sta.w OOlistpos,y		; $80B7DA: 99 3F 12
	inc.b d2		; $80B7DD: E6 5B
.next:
	inx		; $80B7DF: E8
	cpx.w #$000F		; $80B7E0: E0 0F 00
	bne .pair		; $80B7E3: D0 C3
	lda.b d2		; $80B7E5: A5 5B  swapped: sort again
	bne .loop		; $80B7E7: D0 BA
	stx.b xsave		; $80B7E9: 86 0A
	ldx.w #$000A		; $80B7EB: A2 0A 00
.pop:
	pla		; $80B7EE: 68
	sta.b d0,x		; $80B7EF: 95 53
	dex		; $80B7F1: CA
	dex		; $80B7F2: CA
	bpl .pop		; $80B7F3: 10 F9
	ldx.b xsave		; $80B7F5: A6 0A
	ply		; $80B7F7: 7A
	plx		; $80B7F8: FA
	rtl		; $80B7F9: 6B
DoGameFrame:		;auto: CODE_80B7FA. 93G DoGameFrame (hockey93_01): one frame of game logic (d7 = elapsed frames, set by the caller)
	jsl.l periodicevents		; $80B7FA: 22 0D B8 80  periodicevents
	jsl.l updateplayers		; $80B7FE: 22 6D C4 80  updateplayers
	jsl.l checkwindow		; $80B802: 22 E8 E1 80  checkwindow
	jsl.l updatereplay		; $80B806: 22 B4 C2 80  updatereplay
	jmp.w setvideo		; $80B80A: 4C 5E E3
periodicevents:		;auto: CODE_80B80D. 93G periodicevents (hockey93_01): every game loop; once a second (lldisp) the slower checks
	jsl.l PenaltyManager		; $80B80D: 22 C7 E6 80  PenaltyManager
	jsl.l updatecrowdf		; $80B811: 22 D1 BE 80  updatecrowdf
	jsl.l $8D865A		; $80B815: 22 5A 86 8D  updatesound, bank $8D: 93G updatesound
	jsl.l $8F8B11		; $80B819: 22 11 8B 8F  clockcont, bank $8F: 93G clockcont
	lda.w sfhormode		; $80B81D: AD 8E 12  horizontal: no screen updates
	bne .rtl		; $80B820: D0 29
	lda.w lldisp		; $80B822: AD 89 01
	sec		; $80B825: 38
	sbc.b d7		; $80B826: E5 6F
	sta.w lldisp		; $80B828: 8D 89 01
	bpl .rtl		; $80B82B: 10 1E
	clc		; $80B82D: 18
	adc.w #$0018		; $80B82E: 69 18 00  +$18 frames
	sta.w lldisp		; $80B831: 8D 89 01
	jsl.l ChkGoalies		; $80B834: 22 F2 BA 80  ChkGoalies
	jsl.l $8FDBF7		; $80B838: 22 F7 DB 8F  UpdateCwdExcite, bank $8F: 93G UpdateCwdExcite
	jsl.l $8FDBF8		; $80B83C: 22 F8 DB 8F  CheckPeriodEnd, bank $8F: 93G CheckPeriodEnd
	jsl.l $86FB96		; $80B840: 22 96 FB 86  UpdateLineChange, bank $86: 93G UpdateLineChange
	jsl.l $8FF741		; $80B844: 22 41 F7 8F  CheckInjury, bank $8F: 93G CheckInjury
	jmp.w updatepwrplay		; $80B848: 4C F4 B9
.rtl:
	rtl		; $80B84B: 6B
AvgCline:		;auto: CODE_80B84C. 93G AvgCline (penalty93_2): d0 = average energy of the current line of team a2
	stx.b xsave		; $80B84C: 86 0A
	ldx.w #$0000		; $80B84E: A2 00 00
.pushd:
	lda.b d1,x		; $80B851: B5 57
	pha		; $80B853: 48
	inx		; $80B854: E8
	inx		; $80B855: E8
	cpx.w #$000C		; $80B856: E0 0C 00
	bne .pushd		; $80B859: D0 F6
	ldx.b xsave		; $80B85B: A6 0A
	stx.b xsave		; $80B85D: 86 0A
	ldx.w #$0000		; $80B85F: A2 00 00
.pusha:
	lda.b a0,x		; $80B862: B5 33
	pha		; $80B864: 48
	inx		; $80B865: E8
	inx		; $80B866: E8
	cpx.w #$0004		; $80B867: E0 04 00
	bne .pusha		; $80B86A: D0 F6
	ldx.b xsave		; $80B86C: A6 0A
	stz.b d0		; $80B86E: 64 53
	stz.b d1		; $80B870: 64 57
	lda.w #$0005		; $80B872: A9 05 00
	sta.b d2		; $80B875: 85 5B
	ldy.b a2		; $80B877: A4 3B
	lda.w tmsort,y		; $80B879: B9 D2 13
	sta.b a0		; $80B87C: 85 33
.l0:
	ldy.b a0		; $80B87E: A4 33
	lda.w position,y		; $80B880: B9 9F 0B
	beq .next		; $80B883: F0 1E
	bmi .next		; $80B885: 30 1C
	lda.w pnum,y		; $80B887: B9 1F 0F
	and.w #$00FF		; $80B88A: 29 FF 00
	asl a		; $80B88D: 0A
	sta.b d3		; $80B88E: 85 5F
	lda.b a2		; $80B890: A5 3B
	beq .idx		; $80B892: F0 03
	lda.w #$0034		; $80B894: A9 34 00
.idx:
	adc.b d3		; $80B897: 65 5F
	tay		; $80B899: A8
	lda.w tmpde,y		; $80B89A: B9 7A 14
	adc.b d0		; $80B89D: 65 53
	sta.b d0		; $80B89F: 85 53
	inc.b d1		; $80B8A1: E6 57
.next:
	inc.b a0		; $80B8A3: E6 33
	inc.b a0		; $80B8A5: E6 33
	dec.b d2		; $80B8A7: C6 5B
	bpl .l0		; $80B8A9: 10 D3
	lda.b d1		; $80B8AB: A5 57  players counted
	beq .ex		; $80B8AD: F0 0C
	sta.b mula		; $80B8AF: 85 7D
	lda.b d0		; $80B8B1: A5 53
	sta.b mulb		; $80B8B3: 85 83
	jsl.l divu16		; $80B8B5: 22 D8 B8 80
	sta.b d0		; $80B8B9: 85 53
.ex:
	stx.b xsave		; $80B8BB: 86 0A
	ldx.w #$0002		; $80B8BD: A2 02 00
.popa:
	pla		; $80B8C0: 68
	sta.b a0,x		; $80B8C1: 95 33
	dex		; $80B8C3: CA
	dex		; $80B8C4: CA
	bpl .popa		; $80B8C5: 10 F9
	ldx.b xsave		; $80B8C7: A6 0A
	stx.b xsave		; $80B8C9: 86 0A
	ldx.w #$000A		; $80B8CB: A2 0A 00
.popd:
	pla		; $80B8CE: 68
	sta.b d1,x		; $80B8CF: 95 57
	dex		; $80B8D1: CA
	dex		; $80B8D2: CA
	bpl .popd		; $80B8D3: 10 F9
	ldx.b xsave		; $80B8D5: A6 0A
	rtl		; $80B8D7: 6B
divu16:		;auto: CODE_80B8D8. 68k divu.w: mulres = mulb / mula (16-bit), mulres+2 = remainder; A = mula = mulb = quotient. C clear
	lda.b mula		; $80B8D8: A5 7D
	sta.b mula+2		; $80B8DA: 85 7F
	stz.b mula		; $80B8DC: 64 7D
	lda.w #$0010		; $80B8DE: A9 10 00  16 quotient bits
	sta.b mulb+2		; $80B8E1: 85 85
.loop:
	asl.b mulres		; $80B8E3: 06 93
	lsr.b mula+2		; $80B8E5: 46 7F
	ror.b mula		; $80B8E7: 66 7D
	lda.b mulb		; $80B8E9: A5 83
	cmp.b mula		; $80B8EB: C5 7D
	lda.w #$0000		; $80B8ED: A9 00 00
	sbc.b mula+2		; $80B8F0: E5 7F
	bcc .next		; $80B8F2: 90 08
	lda.b mulb		; $80B8F4: A5 83
	sbc.b mula		; $80B8F6: E5 7D
	sta.b mulb		; $80B8F8: 85 83
	inc.b mulres		; $80B8FA: E6 93
.next:
	dec.b mulb+2		; $80B8FC: C6 85
	bne .loop		; $80B8FE: D0 E3
	lda.b mulb		; $80B900: A5 83
	sta.b mulres+2		; $80B902: 85 95
	lda.b mulres		; $80B904: A5 93
	sta.b mula		; $80B906: 85 7D
	sta.b mulb		; $80B908: 85 83
	clc		; $80B90A: 18
	rtl		; $80B90B: 6B
printz:		;auto: CODE_80B90C. 93G printz (middle93_2): print the string that follows the jsl (length word counting itself, then control bytes / text), return after it. Keeps a1
	lda.b a1+2		; $80B90C: A5 39
	pha		; $80B90E: 48
	lda.b a1		; $80B90F: A5 37
	pha		; $80B911: 48
	lda.b $07,s		; $80B912: A3 07  a1 = return address+1: the string
	sta.b a1+2		; $80B914: 85 39
	lda.b $05,s		; $80B916: A3 05
	inc a		; $80B918: 1A
	sta.b a1		; $80B919: 85 37
	lda.b [a1]		; $80B91B: A7 37  return past the string
	clc		; $80B91D: 18
	adc.b $05,s		; $80B91E: 63 05
	sta.b $05,s		; $80B920: 83 05
	jsl.l print		; $80B922: 22 2D B9 80
	pla		; $80B926: 68
	sta.b a1		; $80B927: 85 37
	pla		; $80B929: 68
	sta.b a1+2		; $80B92A: 85 39
	rtl		; $80B92C: 6B
print:		;auto: CODE_80B92D. 93G print (middle93_2): [a1] = string (length word, control bytes / text) into textmap at printx/printy; marks textdirtylo/hi. "@" = blank tile
	lda.b [a1]		; $80B92D: A7 37
	cmp.w #$0100		; $80B92F: C9 00 01
.hang:		;string longer than 255: hang
	bcs .hang		; $80B932: B0 FE
	phx		; $80B934: DA
	ldy.w #$0002		; $80B935: A0 02 00  Y = 2: skip the length word
.pos:
	lda.w printy		; $80B938: AD 7D 04  X = (printy*32+printx)*2 + printm
	asl a		; $80B93B: 0A
	asl a		; $80B93C: 0A
	asl a		; $80B93D: 0A
	asl a		; $80B93E: 0A
	asl a		; $80B93F: 0A
	adc.w printx		; $80B940: 6D 7B 04
	asl a		; $80B943: 0A
	adc.b printm		; $80B944: 65 D4
	tax		; $80B946: AA
.char:
	tya		; $80B947: 98
	cmp.b [a1]		; $80B948: C7 37
	bne .ctl		; $80B94A: D0 03
	jmp.w .done		; $80B94C: 4C E3 B9
.ctl:
	lda.b [a1],y		; $80B94F: B7 37
	bit.w #$0080		; $80B951: 89 80 00  bit 7: control code
	bne .code		; $80B954: D0 3C
	and.w #$00FF		; $80B956: 29 FF 00
	cmp.w #$0040		; $80B959: C9 40 00  "@" = blank tile
	bne .font		; $80B95C: D0 03
	jmp.w .blank		; $80B95E: 4C EA B9
.font:
	phx		; $80B961: DA
	asl a		; $80B962: 0A
	tax		; $80B963: AA
	lda.l $88822F,x		; $80B964: BF 2F 82 88  char -> tile (bank $88 table) + font + printa
	adc.w smallfontchars		; $80B968: 6D D7 1B
	adc.w printfontset		; $80B96B: 6D CB 1B
	ora.w printa		; $80B96E: 0D 77 04
	plx		; $80B971: FA
.put:
	cmp.l textmap,x		; $80B972: DF 74 6E 7E
	beq .nextc		; $80B976: F0 12
	sta.l textmap,x		; $80B978: 9F 74 6E 7E
	txa		; $80B97C: 8A
	lsr a		; $80B97D: 4A
	cmp.b textdirtylo		; $80B97E: C5 D0  textdirtylo/hi
	bcs .hi		; $80B980: B0 02
	sta.b textdirtylo		; $80B982: 85 D0
.hi:
	cmp.b textdirtyhi		; $80B984: C5 D2
	bcc .nextc		; $80B986: 90 02
	sta.b textdirtyhi		; $80B988: 85 D2
.nextc:
	inc.w printx		; $80B98A: EE 7B 04
	inx		; $80B98D: E8
	inx		; $80B98E: E8
	iny		; $80B98F: C8
	bra .char		; $80B990: 80 B5
.code:		;control code -n: palette/priority bits, font number, map; then x, y
	eor.w #$FFFF		; $80B992: 49 FF FF
	inc a		; $80B995: 1A
	pha		; $80B996: 48
	and.w #$0030		; $80B997: 29 30 00  bits 4-5: palette (printa bits 10-12)
	asl a		; $80B99A: 0A
	asl a		; $80B99B: 0A
	asl a		; $80B99C: 0A
	asl a		; $80B99D: 0A
	asl a		; $80B99E: 0A
	asl a		; $80B99F: 0A
	sta.w printa		; $80B9A0: 8D 77 04
	lda.b $01,s		; $80B9A3: A3 01
	and.w #$0040		; $80B9A5: 29 40 00  bit 6: priority
	asl a		; $80B9A8: 0A
	asl a		; $80B9A9: 0A
	asl a		; $80B9AA: 0A
	asl a		; $80B9AB: 0A
	asl a		; $80B9AC: 0A
	asl a		; $80B9AD: 0A
	asl a		; $80B9AE: 0A
	tsb.w printa		; $80B9AF: 0C 77 04
	pla		; $80B9B2: 68
	and.w #$0003		; $80B9B3: 29 03 00  bits 0-1: font, printfontset = font table entry
	sta.w printfont		; $80B9B6: 8D 79 04
	pha		; $80B9B9: 48
	asl a		; $80B9BA: 0A
	tax		; $80B9BB: AA
	lda.w printfontset,x		; $80B9BC: BD CB 1B
	sta.w printfontset		; $80B9BF: 8D CB 1B
	pla		; $80B9C2: 68
	dec a		; $80B9C3: 3A  map (font-1) * $800 bytes
	xba		; $80B9C4: EB
	and.w #$FF00		; $80B9C5: 29 00 FF
	asl a		; $80B9C8: 0A
	asl a		; $80B9C9: 0A
	asl a		; $80B9CA: 0A
	sta.b printm		; $80B9CB: 85 D4
	iny		; $80B9CD: C8
	lda.b [a1],y		; $80B9CE: B7 37
	and.w #$007F		; $80B9D0: 29 7F 00
	sta.w printx		; $80B9D3: 8D 7B 04
	iny		; $80B9D6: C8
	lda.b [a1],y		; $80B9D7: B7 37
	and.w #$007F		; $80B9D9: 29 7F 00
	sta.w printy		; $80B9DC: 8D 7D 04
	iny		; $80B9DF: C8
	jmp.w .pos		; $80B9E0: 4C 38 B9
.done:
	clc		; $80B9E3: 18
	adc.b a1		; $80B9E4: 65 37
	sta.b a1		; $80B9E6: 85 37
	plx		; $80B9E8: FA
	rtl		; $80B9E9: 6B
.blank:
	lda.w blankchar		; $80B9EA: AD E7 1B
	clc		; $80B9ED: 18
	adc.w printfontset		; $80B9EE: 6D CB 1B
	jmp.w .put		; $80B9F1: 4C 72 B9
updatepwrplay:		;auto: CODE_80B9F4. 93G updatepwrplay (penalty93_1): show the power play box: time left and the team on the power play
	stz.b a2		; $80B9F4: 64 3B  a2 = home, a3 = away
	lda.w #$0002		; $80B9F6: A9 02 00
	sta.b a3		; $80B9F9: 85 3F
	lda.w tmap		; $80B9FB: AD EE 13
	sec		; $80B9FE: 38
	sbc.w tmap+2		; $80B9FF: ED F0 13
	sta.b d0		; $80BA02: 85 53
	bne .neg		; $80BA04: D0 03
	jmp.w updatepwrplay_clr		; $80BA06: 4C AF BA
.neg:
	bpl .t0		; $80BA09: 10 14
	lda.w sflags		; $80BA0B: AD 8C 12
	bit.w #sf2pwrtm		; $80BA0E: 89 00 40  sf2pwrtm
	bne .upp		; $80BA11: D0 26
	jsl.l updatepwrplay_clr		; $80BA13: 22 AF BA 80
	lda.w #sf2pwrtm		; $80BA17: A9 00 40
	tsb.w sflags		; $80BA1A: 0C 8C 12
	bra .upp		; $80BA1D: 80 1A
.t0:
	ldx.b a2		; $80BA1F: A6 3B
	ldy.b a3		; $80BA21: A4 3F
	stx.b a3		; $80BA23: 86 3F
	sty.b a2		; $80BA25: 84 3B
	lda.w sflags		; $80BA27: AD 8C 12
	bit.w #sf2pwrtm		; $80BA2A: 89 00 40
	beq .upp		; $80BA2D: F0 0A
	jsl.l updatepwrplay_clr		; $80BA2F: 22 AF BA 80
	lda.w #sf2pwrtm		; $80BA33: A9 00 40
	trb.w sflags		; $80BA36: 1C 8C 12
.upp:
	lda.w #sf2pwrplay		; $80BA39: A9 00 20  sf2pwrplay; new: tmPwrPlays + 1
	tsb.w sflags		; $80BA3C: 0C 8C 12
	bne .uppt		; $80BA3F: D0 05
	ldx.b a3		; $80BA41: A6 3F
	inc.w tmPwrPlays,x		; $80BA43: FE BA 13
.uppt:
	jsl.l printz		; $80BA46: 22 0C B9 80
	dw $0012		; $80BA4A  printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19,"   ",$16,$17,$18,$19,$BF,$01,$1A,"   "
	jsl.l $8D82F0		; $80BA5C: 22 F0 82 8D  bank $8D: 93G GetLowestPen
	jsl.l $8F87EA		; $80BA60: 22 EA 87 8F  bank $8F: 93G PushTime
	jsl.l print		; $80BA64: 22 2D B9 80
	ldx.b a3		; $80BA68: A6 3F
	lda.w tmdata,x		; $80BA6A: BD CE 13  team name (bank $83)
	sta.b a0		; $80BA6D: 85 33
	lda.w #$0083		; $80BA6F: A9 83 00
	sta.b a0+2		; $80BA72: 85 35
	lda.w #mesarea		; $80BA74: A9 91 01  a3 = mesarea, length 2
	sta.b a3		; $80BA77: 85 3F
	lda.w #mesarea>>16		; $80BA79: A9 00 00
	sta.b a3+2		; $80BA7C: 85 41
	lda.w #$0002		; $80BA7E: A9 02 00
	sta.b [a3]		; $80BA81: 87 3F
	jsl.l $82FDD3		; $80BA83: 22 D3 FD 82  appendz (bank $82), bank $82: 93G appendz (inline string follows)
	dw $0005		; $80BA87  printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	lda.b a0		; $80BA8C: A5 33
	ldy.w #$0004		; $80BA8E: A0 04 00
	clc		; $80BA91: 18
	adc.b [a0],y		; $80BA92: 77 33
	sta.b a0		; $80BA94: 85 33
	adc.b [a0]		; $80BA96: 67 33
	sta.b a0		; $80BA98: 85 33
	sta.b a1		; $80BA9A: 85 37
	lda.b a0+2		; $80BA9C: A5 35
	sta.b a1+2		; $80BA9E: 85 39
	jsl.l $8F87C9		; $80BAA0: 22 C9 87 8F  appstring, bank $8F: 93G appstring
	lda.b a3		; $80BAA4: A5 3F
	sta.b a1		; $80BAA6: 85 37
	lda.b a3+2		; $80BAA8: A5 41
	sta.b a1+2		; $80BAAA: 85 39
	jmp.w print		; $80BAAC: 4C 2D B9
updatepwrplay_clr:		;auto: CODE_80BAAF. 93G updatepwrplay .clrpwrplay: power play over, EASN logo back
	lda.w #sf2pwrplay		; $80BAAF: A9 00 20
	trb.w sflags		; $80BAB2: 1C 8C 12
	beq .rtl		; $80BAB5: F0 04
	jml.l $8D8549		; $80BAB7: 5C 49 85 8D  EASNLogo, bank $8D: 93G EASNLogo
.rtl:
	rtl		; $80BABB: 6B
printteamname:		;auto: CODE_80BABC. print the team name of team d3 (0 home) at printx/printy, then printy += 2
	lda.w printx		; $80BABC: AD 7B 04
	pha		; $80BABF: 48
	lda.w tmdata		; $80BAC0: AD CE 13  tmdata of team d3
	sta.b a1		; $80BAC3: 85 37
	lda.w #$0083		; $80BAC5: A9 83 00
	sta.b a1+2		; $80BAC8: 85 39
	lda.b d3		; $80BACA: A5 5F
	beq .name		; $80BACC: F0 05
	lda.w tmdata+2		; $80BACE: AD D0 13
	sta.b a1		; $80BAD1: 85 37
.name:
	ldy.w #$0004		; $80BAD3: A0 04 00
	lda.b [a1],y		; $80BAD6: B7 37
	clc		; $80BAD8: 18
	adc.b a1		; $80BAD9: 65 37
	sta.b a1		; $80BADB: 85 37
	lda.b [a1]		; $80BADD: A7 37
	adc.b a1		; $80BADF: 65 37
	sta.b a1		; $80BAE1: 85 37
	jsl.l print		; $80BAE3: 22 2D B9 80
	pla		; $80BAE7: 68
	sta.w printx		; $80BAE8: 8D 7B 04
	inc.w printy		; $80BAEB: EE 7D 04
	inc.w printy		; $80BAEE: EE 7D 04
	rtl		; $80BAF1: 6B
ChkGoalies:		;auto: CODE_80BAF2. 93G ChkGoalies (logic93_4): computer pulls the goalie on a delayed penalty. Called from periodicevents
	lda.w gmclock		; $80BAF2: AD 8A 12  clock stopped
	bne ChkGoalies_CPG_rtl		; $80BAF5: D0 62
	stz.b a2		; $80BAF7: 64 3B
	lda.w #$0001		; $80BAF9: A9 01 00
	sta.b d0		; $80BAFC: 85 53
	inc a		; $80BAFE: 1A
	sta.b a1		; $80BAFF: 85 37
	jsl.l ChkGoalies_CPG		; $80BB01: 22 12 BB 80
	lda.w #$0002		; $80BB05: A9 02 00
	sta.b d0		; $80BB08: 85 53
	lda.b a1		; $80BB0A: A5 37
	ldy.b a2		; $80BB0C: A4 3B
	sta.b a2		; $80BB0E: 85 3B
	sty.b a1		; $80BB10: 84 37
ChkGoalies_CPG:		;auto: CODE_80BB12. 93G ChkGoalies .CPG: d0 = team (1/2), a2/a1 = team/other
	lda.b d0		; $80BB12: A5 53
	cmp.w cont1team		; $80BB14: CD 96 12  controlled team: no
	beq .rtl		; $80BB17: F0 40
	cmp.w cont2team		; $80BB19: CD 98 12
	beq .rtl		; $80BB1C: F0 3B
	ldy.b a2		; $80BB1E: A4 3B
	lda.w tmgoalie,y		; $80BB20: B9 F2 13  goalie already out
	bmi .rtl		; $80BB23: 30 34
	lda.w puckc		; $80BB25: AD BB 0E
	bmi .rtl		; $80BB28: 30 2F
	sec		; $80BB2A: 38
	sbc.w #$0006		; $80BB2B: E9 06 00  puckc - 6, negated for the away team: negative = team a2 has the puck
	ldy.b a2		; $80BB2E: A4 3B
	beq .side		; $80BB30: F0 04
	eor.w #$FFFF		; $80BB32: 49 FF FF
	inc a		; $80BB35: 1A
.side:
	sta.b d0		; $80BB36: 85 53
	cmp.w #$0000		; $80BB38: C9 00 00
	bpl .rtl		; $80BB3B: 10 1C
	lda.w pucky		; $80BB3D: AD 7B 09
	sta.b d1		; $80BB40: 85 57
	lda.w gmode		; $80BB42: AD 88 12
	bit.w #gmpendel		; $80BB45: 89 08 00  gmpendel
	bne .pull		; $80BB48: D0 03
	jmp.w CPgoalie		; $80BB4A: 4C 89 BE
.pull:		;delayed penalty: pull the goalie, any team
	lda.w tmgoalie,y		; $80BB4D: B9 F2 13
	ora.w #$FF00		; $80BB50: 09 00 FF  tmgoalie high byte $FF: pulled
	sta.w tmgoalie,y		; $80BB53: 99 F2 13
	jmp.w setpersonel		; $80BB56: 4C 5A BB
.rtl:
	rtl		; $80BB59: 6B
setpersonel:		;auto: CODE_80BB5A. 93G setpersonel (hockey93_05): set the personel of team a2 from SetPlList: keep the players already on the ice, place the rest
	stx.b xsave		; $80BB5A: 86 0A
	ldx.w #$0000		; $80BB5C: A2 00 00
.pushd:
	lda.b d0,x		; $80BB5F: B5 53
	pha		; $80BB61: 48
	inx		; $80BB62: E8
	inx		; $80BB63: E8
	cpx.w #$0018		; $80BB64: E0 18 00
	bne .pushd		; $80BB67: D0 F6
	ldx.b xsave		; $80BB69: A6 0A
	stx.b xsave		; $80BB6B: 86 0A
	ldx.w #$0000		; $80BB6D: A2 00 00
.pusha:
	lda.b a0,x		; $80BB70: B5 33
	pha		; $80BB72: 48
	inx		; $80BB73: E8
	inx		; $80BB74: E8
	cpx.w #$0014		; $80BB75: E0 14 00
	bne .pusha		; $80BB78: D0 F6
	ldx.b xsave		; $80BB7A: A6 0A
	ldy.b a2		; $80BB7C: A4 3B
	ldx.w tmsort,y		; $80BB7E: BE D2 13
	stx.b a3		; $80BB81: 86 3F
	lda.w #$0005		; $80BB83: A9 05 00
	sta.b d4		; $80BB86: 85 63
.l0:
	lda.w #$FFFF		; $80BB88: A9 FF FF  newpos = newpnum = -1 for the 6 objects
	sta.w newpos,x		; $80BB8B: 9D 9F 0E
	sta.w newpnum,x		; $80BB8E: 9D BF 0E
	inx		; $80BB91: E8
	inx		; $80BB92: E8
	stx.b a3		; $80BB93: 86 3F
	dec.b d4		; $80BB95: C6 63
	bpl .l0		; $80BB97: 10 EF
	jsl.l SetPlList		; $80BB99: 22 B0 BC 80
	lda.w #$0005		; $80BB9D: A9 05 00
	sta.b d4		; $80BBA0: 85 63
	lda.w #PlList		; $80BBA2: A9 43 04  a4 = PlList
	sta.b a4		; $80BBA5: 85 43
	lda.w #PlList>>16		; $80BBA7: A9 00 00
	sta.b a4+2		; $80BBAA: 85 45
.l1:		;wanted players already on the ice keep their object
	ldy.b d4		; $80BBAC: A4 63
	lda.b [a4],y		; $80BBAE: B7 43
	and.w #$00FF		; $80BBB0: 29 FF 00
	sta.b d5		; $80BBB3: 85 67
	beq .next		; $80BBB5: F0 5A
	dec.b d5		; $80BBB7: C6 67
	lda.w #$0005		; $80BBB9: A9 05 00
	sta.b d3		; $80BBBC: 85 5F
	ldy.b a2		; $80BBBE: A4 3B
	ldx.w tmsort,y		; $80BBC0: BE D2 13
	dex		; $80BBC3: CA
	dex		; $80BBC4: CA
.l2:
	inx		; $80BBC5: E8
	inx		; $80BBC6: E8
	stx.b a3		; $80BBC7: 86 3F
	lda.w pnum,x		; $80BBC9: BD 1F 0F
	and.w #$00FF		; $80BBCC: 29 FF 00
	sta.b tmp0		; $80BBCF: 85 73
	lda.b d5		; $80BBD1: A5 67
	and.w #$00FF		; $80BBD3: 29 FF 00
	cmp.b tmp0		; $80BBD6: C5 73
	beq .found		; $80BBD8: F0 06
	dec.b d3		; $80BBDA: C6 5F
	bpl .l2		; $80BBDC: 10 E7
	bra .next		; $80BBDE: 80 31
.found:
	lda.b d4		; $80BBE0: A5 63
	clc		; $80BBE2: 18
	adc.w #$0006		; $80BBE3: 69 06 00
	tay		; $80BBE6: A8
	lda.b [a4],y		; $80BBE7: B7 43
	and.w #$00FF		; $80BBE9: 29 FF 00
	bit.w #$0080		; $80BBEC: 89 80 00
	beq .np		; $80BBEF: F0 03
	ora.w #$FF00		; $80BBF1: 09 00 FF
.np:
	sta.w newpos,x		; $80BBF4: 9D 9F 0E
	lda.b d5		; $80BBF7: A5 67
	and.w #$00FF		; $80BBF9: 29 FF 00
	bit.w #$0080		; $80BBFC: 89 80 00
	beq .npn		; $80BBFF: F0 03
	ora.w #$FF00		; $80BC01: 09 00 FF
.npn:
	sta.w newpnum,x		; $80BC04: 9D BF 0E
	ldy.b d4		; $80BC07: A4 63
	sep #$20		; $80BC09: E2 20
	lda.b #$00		; $80BC0B: A9 00
	sta.b [a4],y		; $80BC0D: 97 43
	rep #$20		; $80BC0F: C2 20
.next:
	dec.b d4		; $80BC11: C6 63
	bpl .l1		; $80BC13: 10 97
	lda.w #$0005		; $80BC15: A9 05 00
	sta.b d4		; $80BC18: 85 63
	lda.w #PlList		; $80BC1A: A9 43 04
	sta.b a4		; $80BC1D: 85 43
	lda.w #PlList>>16		; $80BC1F: A9 00 00
	sta.b a4+2		; $80BC22: 85 45
.l3:		;the rest go to objects with no requested player
	ldy.b d4		; $80BC24: A4 63
	lda.b [a4],y		; $80BC26: B7 43
	and.w #$00FF		; $80BC28: 29 FF 00
	sta.b d5		; $80BC2B: 85 67
	beq .next2		; $80BC2D: F0 5E
	dec.b d5		; $80BC2F: C6 67
	lda.w #$0005		; $80BC31: A9 05 00
	sta.b d3		; $80BC34: 85 5F
	ldy.b a2		; $80BC36: A4 3B
	ldx.w tmsort,y		; $80BC38: BE D2 13
	dex		; $80BC3B: CA
	dex		; $80BC3C: CA
.l4:
	inx		; $80BC3D: E8
	inx		; $80BC3E: E8
	stx.b a3		; $80BC3F: 86 3F
	lda.w newpnum,x		; $80BC41: BD BF 0E
	bit.w #$0080		; $80BC44: 89 80 00
	bne .free		; $80BC47: D0 06
	dec.b d3		; $80BC49: C6 5F
	bpl .l4		; $80BC4B: 10 F0
	bra .chkpos		; $80BC4D: 80 02
.free:
	stx.b a0		; $80BC4F: 86 33
.chkpos:
	lda.w position,x		; $80BC51: BD 9F 0B
	bpl .put		; $80BC54: 10 04
	dec.b d3		; $80BC56: C6 5F
	bpl .l4		; $80BC58: 10 E3
.put:
	lda.b d4		; $80BC5A: A5 63
	clc		; $80BC5C: 18
	adc.w #$0006		; $80BC5D: 69 06 00
	tay		; $80BC60: A8
	lda.b [a4],y		; $80BC61: B7 43
	and.w #$00FF		; $80BC63: 29 FF 00
	bit.w #$0080		; $80BC66: 89 80 00
	beq .np2		; $80BC69: F0 03
	ora.w #$FF00		; $80BC6B: 09 00 FF
.np2:
	ldy.b a0		; $80BC6E: A4 33
	sta.w newpos,y		; $80BC70: 99 9F 0E
	lda.b d5		; $80BC73: A5 67
	and.w #$00FF		; $80BC75: 29 FF 00
	bit.w #$0080		; $80BC78: 89 80 00
	beq .npn2		; $80BC7B: F0 03
	ora.w #$FF00		; $80BC7D: 09 00 FF
.npn2:
	sta.w newpnum,y		; $80BC80: 99 BF 0E
	ldy.b d4		; $80BC83: A4 63
	sep #$20		; $80BC85: E2 20
	lda.b #$00		; $80BC87: A9 00
	sta.b [a4],y		; $80BC89: 97 43
	rep #$20		; $80BC8B: C2 20
.next2:
	dec.b d4		; $80BC8D: C6 63
	bpl .l3		; $80BC8F: 10 93
	stx.b xsave		; $80BC91: 86 0A
	ldx.w #$0012		; $80BC93: A2 12 00
.popa:
	pla		; $80BC96: 68
	sta.b a0,x		; $80BC97: 95 33
	dex		; $80BC99: CA
	dex		; $80BC9A: CA
	bpl .popa		; $80BC9B: 10 F9
	ldx.b xsave		; $80BC9D: A6 0A
	stx.b xsave		; $80BC9F: 86 0A
	ldx.w #$0016		; $80BCA1: A2 16 00
.popd:
	pla		; $80BCA4: 68
	sta.b d0,x		; $80BCA5: 95 53
	dex		; $80BCA7: CA
	dex		; $80BCA8: CA
	bpl .popd		; $80BCA9: 10 F9
	ldx.b xsave		; $80BCAB: A6 0A
	ldx.b a3		; $80BCAD: A6 3F
	rtl		; $80BCAF: 6B
SetPlList:		;auto: CODE_80BCB0. 93G SetPlList (hockey93_05): make PlList, the players we want on the ice now (team a2)
	lda.w #PlList		; $80BCB0: A9 43 04
	sta.b a4		; $80BCB3: 85 43
	lda.w #PlList>>16		; $80BCB5: A9 00 00
	sta.b a4+2		; $80BCB8: 85 45
	lda.w #$0000		; $80BCBA: A9 00 00
	sta.b [a4]		; $80BCBD: 87 43
	ldy.w #$0002		; $80BCBF: A0 02 00
	sta.b [a4],y		; $80BCC2: 97 43
	ldy.w #$0004		; $80BCC4: A0 04 00
	sta.b [a4],y		; $80BCC7: 97 43
	lda.w #$F820		; $80BCC9: A9 20 F8  priolist (bank $8F)
	sta.b a0		; $80BCCC: 85 33
	lda.w #$008F		; $80BCCE: A9 8F 00
	sta.b a0+2		; $80BCD1: 85 35
	ldy.b a2		; $80BCD3: A4 3B
	lda.w tmgoalie,y		; $80BCD5: B9 F2 13
	bpl .gin		; $80BCD8: 10 02  no goalie: skip the priolist goalie entry
	inc.b a0		; $80BCDA: E6 33
.gin:
	lda.w tmdata,y		; $80BCDC: B9 CE 13  line sets: team data + word at +6, + tmline*8
	sta.b a1		; $80BCDF: 85 37
	lda.w #$0083		; $80BCE1: A9 83 00
	sta.b a1+2		; $80BCE4: 85 39
	ldy.w #$0006		; $80BCE6: A0 06 00
	lda.b [a1],y		; $80BCE9: B7 37
	clc		; $80BCEB: 18
	adc.b a1		; $80BCEC: 65 37
	sta.b a1		; $80BCEE: 85 37
	ldy.b a2		; $80BCF0: A4 3B
	lda.w tmline,y		; $80BCF2: B9 DE 13
	asl a		; $80BCF5: 0A
	asl a		; $80BCF6: 0A
	asl a		; $80BCF7: 0A
	sta.b d0		; $80BCF8: 85 53
	adc.b a1		; $80BCFA: 65 37
	sta.b a1		; $80BCFC: 85 37
	lda.w tmap,y		; $80BCFE: B9 EE 13  tmap: players on ice
	sta.b d4		; $80BD01: 85 63
	bra .next		; $80BD03: 80 34
.l0:
	ldy.b d4		; $80BD05: A4 63
	lda.b [a0],y		; $80BD07: B7 33
	and.w #$00FF		; $80BD09: 29 FF 00
	sta.b d5		; $80BD0C: 85 67
	tay		; $80BD0E: A8
	sep #$20		; $80BD0F: E2 20
	lda.b [a1],y		; $80BD11: B7 37
	ldy.b d4		; $80BD13: A4 63
	sta.b [a4],y		; $80BD15: 97 43
	iny		; $80BD17: C8
	iny		; $80BD18: C8
	iny		; $80BD19: C8
	iny		; $80BD1A: C8
	iny		; $80BD1B: C8
	iny		; $80BD1C: C8
	lda.b d5		; $80BD1D: A5 67
	sta.b [a4],y		; $80BD1F: 97 43
	rep #$20		; $80BD21: C2 20
	lda.b d5		; $80BD23: A5 67
	bne .next		; $80BD25: D0 12
	ldy.b a2		; $80BD27: A4 3B  goalie: 1 + tmgoalie
	lda.w tmgoalie,y		; $80BD29: B9 F2 13
	inc a		; $80BD2C: 1A
	sta.b d3		; $80BD2D: 85 5F
	ldy.b d4		; $80BD2F: A4 63
	sep #$20		; $80BD31: E2 20
	lda.b d3		; $80BD33: A5 5F
	sta.b [a4],y		; $80BD35: 97 43
	rep #$20		; $80BD37: C2 20
.next:
	dec.b d4		; $80BD39: C6 63
	bpl .l0		; $80BD3B: 10 C8
	lda.w #$0005		; $80BD3D: A9 05 00
	sta.b d4		; $80BD40: 85 63
.l1:		;is each wanted player available?
	ldy.b d4		; $80BD42: A4 63
	lda.b [a4],y		; $80BD44: B7 43
	and.w #$00FF		; $80BD46: 29 FF 00
	sta.b d3		; $80BD49: 85 5F
	beq .next1		; $80BD4B: F0 7E
	and.w #$00FF		; $80BD4D: 29 FF 00
	bit.w #$0080		; $80BD50: 89 80 00
	beq .p		; $80BD53: F0 03
	ora.w #$FF00		; $80BD55: 09 00 FF
.p:
	dec a		; $80BD58: 3A
	asl a		; $80BD59: 0A
	sta.b d3		; $80BD5A: 85 5F
	lda.b a2		; $80BD5C: A5 3B
	beq .idx		; $80BD5E: F0 03
	lda.w #$0034		; $80BD60: A9 34 00
.idx:
	clc		; $80BD63: 18
	adc.b d3		; $80BD64: 65 5F
	tay		; $80BD66: A8
	lda.w tmpdst,y		; $80BD67: B9 E2 14
	cmp.w #TMPDOUT		; $80BD6A: C9 FD FF  TMPDOUT: substitute
	beq .sub		; $80BD6D: F0 07
	lda.w tmpdst,y		; $80BD6F: B9 E2 14
	bmi .next1		; $80BD72: 30 57  bench or ice: ok
	beq .next1		; $80BD74: F0 55
.sub:		;not available: find a player of a similar position (sublist)
	ldy.b a2		; $80BD76: A4 3B
	lda.w tmdata,y		; $80BD78: B9 CE 13
	sta.b a1		; $80BD7B: 85 37
	lda.w #$0083		; $80BD7D: A9 83 00
	sta.b a1+2		; $80BD80: 85 39
	ldy.w #$0006		; $80BD82: A0 06 00
	lda.b [a1],y		; $80BD85: B7 37
	clc		; $80BD87: 18
	adc.b a1		; $80BD88: 65 37
	sta.b a1		; $80BD8A: 85 37
	lda.b d4		; $80BD8C: A5 63
	clc		; $80BD8E: 18
	adc.w #$0006		; $80BD8F: 69 06 00
	tay		; $80BD92: A8
	lda.b [a4],y		; $80BD93: B7 43
	and.w #$00FF		; $80BD95: 29 FF 00
	asl a		; $80BD98: 0A
	sta.b d0		; $80BD99: 85 53
	lda.w #$F7B6		; $80BD9B: A9 B6 F7  sublist (bank $8F, word offsets)
	sta.b a0		; $80BD9E: 85 33
	lda.w #$008F		; $80BDA0: A9 8F 00
	sta.b a0+2		; $80BDA3: 85 35
	ldy.b d0		; $80BDA5: A4 53
	lda.b [a0],y		; $80BDA7: B7 33
	clc		; $80BDA9: 18
	adc.b a0		; $80BDAA: 65 33
	sta.b a0		; $80BDAC: 85 33
.s1:
	lda.b [a0]		; $80BDAE: A7 33
	inc.b a0		; $80BDB0: E6 33
	and.w #$00FF		; $80BDB2: 29 FF 00
	sta.b d0		; $80BDB5: 85 53
	bit.w #$0080		; $80BDB7: 89 80 00
	bne .all		; $80BDBA: D0 17
	ldy.b d0		; $80BDBC: A4 53
	lda.b [a1],y		; $80BDBE: B7 37
	and.w #$00FF		; $80BDC0: 29 FF 00
	sta.b d0		; $80BDC3: 85 53
	jsl.l TryAddPlayerToList		; $80BDC5: 22 EB BD 80
	beq .s1		; $80BDC9: F0 E3
.next1:
	dec.b d4		; $80BDCB: C6 63
	bmi .rtl		; $80BDCD: 30 03
	jmp.w .l1		; $80BDCF: 4C 42 BD
.rtl:
	rtl		; $80BDD2: 6B
.all:		;try every roster player, last first
	jsl.l $8FFAF3		; $80BDD3: 22 F3 FA 8F  GetPlayerCount, bank $8F: 93G GetPlayerCount
	lda.b d0		; $80BDD7: A5 53
	sta.b d3		; $80BDD9: 85 5F
.try:
	lda.b d3		; $80BDDB: A5 5F
	sta.b d0		; $80BDDD: 85 53
	dec.b d3		; $80BDDF: C6 5F
	bmi .next1		; $80BDE1: 30 E8
	jsl.l TryAddPlayerToList		; $80BDE3: 22 EB BD 80
	beq .try		; $80BDE7: F0 F2
	bra .next1		; $80BDE9: 80 E0
TryAddPlayerToList:		;auto: CODE_80BDEB. 93G TryAddPlayerToList (hockey93_05): d0 = roster player (1 based), d4 = PlList slot. A = d1 = player if added, 0 (Z set) if not available
	lda.b d0		; $80BDEB: A5 53
	sta.b d1		; $80BDED: 85 57
	dec.b d0		; $80BDEF: C6 53
	asl.b d0		; $80BDF1: 06 53
	lda.b a2		; $80BDF3: A5 3B
	beq .idx		; $80BDF5: F0 03
	lda.w #$0034		; $80BDF7: A9 34 00
.idx:
	adc.b d0		; $80BDFA: 65 53
	tay		; $80BDFC: A8
	lda.w tmpdst,y		; $80BDFD: B9 E2 14
	sec		; $80BE00: 38
	sbc.w #$0000		; $80BE01: E9 00 00
	beq .chk		; $80BE04: F0 08
	bmi .v1		; $80BE06: 30 04
	bvs .chk		; $80BE08: 70 04
	bra .no		; $80BE0A: 80 35
.v1:
	bvs .no		; $80BE0C: 70 33
.chk:
	lda.w tmpdst,y		; $80BE0E: B9 E2 14
	cmp.w #TMPDOUT		; $80BE11: C9 FD FF  TMPDOUT: not available
	beq .no		; $80BE14: F0 2B
	lda.w #$0005		; $80BE16: A9 05 00
	sta.b d0		; $80BE19: 85 53
.s2:
	ldy.b d0		; $80BE1B: A4 53
	lda.b [a4],y		; $80BE1D: B7 43
	and.w #$00FF		; $80BE1F: 29 FF 00
	sta.b tmp0		; $80BE22: 85 73
	lda.b d1		; $80BE24: A5 57
	and.w #$00FF		; $80BE26: 29 FF 00
	cmp.b tmp0		; $80BE29: C5 73
	beq .no		; $80BE2B: F0 14  already in PlList
	dec.b d0		; $80BE2D: C6 53
	bpl .s2		; $80BE2F: 10 EA
	ldy.b d4		; $80BE31: A4 63
	sep #$20		; $80BE33: E2 20
	lda.b d1		; $80BE35: A5 57
	sta.b [a4],y		; $80BE37: 97 43
	rep #$20		; $80BE39: C2 20
	lda.b d1		; $80BE3B: A5 57
	and.w #$00FF		; $80BE3D: 29 FF 00
	rtl		; $80BE40: 6B
.no:
	lda.w #$0000		; $80BE41: A9 00 00
	sta.b d1		; $80BE44: 85 57
	rtl		; $80BE46: 6B
ReturnGoalies:		;auto: CODE_80BE47. 93G ReturnGoalies (logic93_4): if the computer pulled its goalie, should he come back? Called from puckfaceoff
	stz.b a2		; $80BE47: 64 3B
	lda.w #$0001		; $80BE49: A9 01 00
	sta.b d0		; $80BE4C: 85 53
	inc a		; $80BE4E: 1A
	sta.b a1		; $80BE4F: 85 37
	jsl.l ReturnGoalies_r		; $80BE51: 22 62 BE 80
	lda.w #$0002		; $80BE55: A9 02 00
	sta.b d0		; $80BE58: 85 53
	lda.b a1		; $80BE5A: A5 37
	ldy.b a2		; $80BE5C: A4 3B
	sta.b a2		; $80BE5E: 85 3B
	sty.b a1		; $80BE60: 84 37
ReturnGoalies_r:		;auto: CODE_80BE62. 93G ReturnGoalies .r: d0 = team (1/2), a2/a1 = team/other
	lda.b d0		; $80BE62: A5 53
	cmp.w cont1team		; $80BE64: CD 96 12  controlled team: no
	beq .rtl		; $80BE67: F0 1F
	cmp.w cont2team		; $80BE69: CD 98 12
	beq .rtl		; $80BE6C: F0 1A
	ldy.b a2		; $80BE6E: A4 3B
	lda.w tmgoalie,y		; $80BE70: B9 F2 13
	bpl .rtl		; $80BE73: 10 13  goalie in
	and.w #$00FF		; $80BE75: 29 FF 00
	cmp.w #$000A		; $80BE78: C9 0A 00  low byte = goalie to return
	bcs .rtl		; $80BE7B: B0 0B
	sta.w tmgoalie,y		; $80BE7D: 99 F2 13
	lda.w foy		; $80BE80: AD 48 01  d1 = foy
	sta.b d1		; $80BE83: 85 57
	jmp.w CPgoalie		; $80BE85: 4C 89 BE
.rtl:
	rtl		; $80BE88: 6B
CPgoalie:		;auto: CODE_80BE89. 93G CPgoalie (logic93_4): should the computer pull its goalie? d1 = puck/faceoff y. 3rd period, behind by 2, under a minute
	lda.w gsp		; $80BE89: AD F0 12  3rd period only
	cmp.w #$0002		; $80BE8C: C9 02 00
	bne .rtl		; $80BE8F: D0 3F
	ldy.b a1		; $80BE91: A4 37
	lda.w tmscore,y		; $80BE93: B9 D6 13
	ldy.b a2		; $80BE96: A4 3B
	sec		; $80BE98: 38
	sbc.w tmscore,y		; $80BE99: F9 D6 13
	sta.b d0		; $80BE9C: 85 53
	bmi .rtl		; $80BE9E: 30 30
	cmp.w #$0002		; $80BEA0: C9 02 00  behind by exactly 2
	bne .rtl		; $80BEA3: D0 2B
	lda.w gameclock		; $80BEA5: AD F2 12
	cmp.w #$003D		; $80BEA8: C9 3D 00  60 seconds or less
	bcs .rtl		; $80BEAB: B0 23
	lda.w tmsort,y		; $80BEAD: B9 D2 13
	tay		; $80BEB0: A8
	lda.w pfgoal,y		; $80BEB1: B9 3F 11  own half of the faceoff/puck
	bne .side		; $80BEB4: D0 08
	lda.b d1		; $80BEB6: A5 57
	eor.w #$FFFF		; $80BEB8: 49 FF FF
	inc a		; $80BEBB: 1A
	sta.b d1		; $80BEBC: 85 57
.side:
	lda.b d1		; $80BEBE: A5 57
	bmi .rtl		; $80BEC0: 30 0E
	ldy.b a2		; $80BEC2: A4 3B
	lda.w tmgoalie,y		; $80BEC4: B9 F2 13
	ora.w #$FF00		; $80BEC7: 09 00 FF  pull the goalie
	sta.w tmgoalie,y		; $80BECA: 99 F2 13
	jmp.w setpersonel		; $80BECD: 4C 5A BB
.rtl:
	rtl		; $80BED0: 6B
updatecrowdf:		;auto: CODE_80BED1. 93G updatecrowdf (hockey93_01): every game loop (d7 = elapsed frames): crowd level decay and the crowd animation frame
	lda.b crowdlevel		; $80BED1: A5 DE
	sec		; $80BED3: 38
	sbc.w #$015E		; $80BED4: E9 5E 01  350
	bmi .v1		; $80BED7: 30 04
	bvc .loud		; $80BED9: 50 04
	bra .dec		; $80BEDB: 80 08
.v1:
	bvc .dec		; $80BEDD: 50 06
.loud:
	dec.b crowdlevel		; $80BEDF: C6 DE  loud crowd calms down faster
	dec.b crowdlevel		; $80BEE1: C6 DE
	dec.b crowdlevel		; $80BEE3: C6 DE
.dec:
	lda.b crowdlevel		; $80BEE5: A5 DE
	sec		; $80BEE7: 38
	sbc.b d7		; $80BEE8: E5 6F
	sta.b crowdlevel		; $80BEEA: 85 DE
	bpl .cnt		; $80BEEC: 10 02
	stz.b crowdlevel		; $80BEEE: 64 DE
.cnt:
	lda.b crowdcnt		; $80BEF0: A5 DA
	sec		; $80BEF2: 38
	sbc.b d7		; $80BEF3: E5 6F
	sta.b crowdcnt		; $80BEF5: 85 DA
	bpl .cf		; $80BEF7: 10 4D
	lda.b crowdlevel		; $80BEF9: A5 DE
	lsr a		; $80BEFB: 4A
	sta.b d0		; $80BEFC: 85 53
	cmp.w #$0080		; $80BEFE: C9 80 00
	bcc .lvl		; $80BF01: 90 05
	lda.w #$007F		; $80BF03: A9 7F 00
	sta.b d0		; $80BF06: 85 53
.lvl:
	lda.b d0		; $80BF08: A5 53
	and.w #$0060		; $80BF0A: 29 60 00  %01100000
	sta.b d0		; $80BF0D: 85 53
	lda.b crowdstep		; $80BF0F: A5 E0
	inc a		; $80BF11: 1A
	inc a		; $80BF12: 1A
	and.w #$001E		; $80BF13: 29 1E 00  %00011110
	sta.b crowdstep		; $80BF16: 85 E0
	clc		; $80BF18: 18
	adc.b d0		; $80BF19: 65 53
	sta.b d0		; $80BF1B: 85 53
	tay		; $80BF1D: A8
	lda.w #$FDFB		; $80BF1E: A9 FB FD  cd0 (bank $8F): frame high byte, time low byte
	sta.b a0		; $80BF21: 85 33
	lda.w #$008F		; $80BF23: A9 8F 00
	sta.b a0+2		; $80BF26: 85 35
	lda.b [a0],y		; $80BF28: B7 33
	xba		; $80BF2A: EB
	sep #$20		; $80BF2B: E2 20
	sta.b crowdframe+1		; $80BF2D: 85 DD
	rep #$20		; $80BF2F: C2 20
	lda.b [a0],y		; $80BF31: B7 33
	and.w #$00FF		; $80BF33: 29 FF 00
	sta.b d1		; $80BF36: 85 57
	lda.w seed		; $80BF38: AD A1 04  random 0..time
	and.b d1		; $80BF3B: 25 57
	sta.b d2		; $80BF3D: 85 5B
	clc		; $80BF3F: 18
	adc.b d1		; $80BF40: 65 57
	sta.b d1		; $80BF42: 85 57
	sta.b crowdcnt		; $80BF44: 85 DA
.cf:		;random extra frame 19-25 when the crowd is loud
	sep #$20		; $80BF46: E2 20
	stz.b crowdframe		; $80BF48: 64 DC
	rep #$30		; $80BF4A: C2 30
	lda.b crowdlevel		; $80BF4C: A5 DE
	cmp.w #$0119		; $80BF4E: C9 19 01  280
	bcc .rtl		; $80BF51: 90 16
	lda.w seed		; $80BF53: AD A1 04
	and.w #$007F		; $80BF56: 29 7F 00
	cmp.w #$0013		; $80BF59: C9 13 00
	bcc .rtl		; $80BF5C: 90 0B
	cmp.w #$001A		; $80BF5E: C9 1A 00
	bcs .rtl		; $80BF61: B0 06
	sep #$20		; $80BF63: E2 20
	sta.b crowdframe		; $80BF65: 85 DC
	rep #$30		; $80BF67: C2 30
.rtl:
	rtl		; $80BF69: 6B
PenaltyList:		;93G PenaltyList (hockey93_11): penalty number = word offset into this table. Used by AddPenalty, the penalty box and stats
	dw $0000		; $80BF6A  0
	dw .eop-PenaltyList		; $80BF6C  $02 period over (92 PenEOP 2)
	dw .eog-PenaltyList		; $80BF6E  $04 game over (92 PenEOG 4)
	dw .ghold-PenaltyList		; $80BF70  $06 (92 PenOOP $C)
	dw .ghold-PenaltyList		; $80BF72  $08 (92 PenGhold $E)
	dw .whistle-PenaltyList		; $80BF74  $0A whistle (92 PenWhistle $26)
	dw .ice-PenaltyList		; $80BF76  $0C icing (92 PenIcing 8)
	dw .goal-PenaltyList		; $80BF78  $0E goal (92 PenGoal 6)
	dw .offsides-PenaltyList		; $80BF7A  $10 offsides (92 PenOffsides $A)
	dw .rough2-PenaltyList		; $80BF7C  $12 roughing, slow down time $A
	dw .p14-PenaltyList		; $80BF7E  $14 93 only, no text
	dw .charge-PenaltyList		; $80BF80  $16 charging
	dw .slash-PenaltyList		; $80BF82  $18 slashing
	dw .rough-PenaltyList		; $80BF84  $1A roughing
	dw .cross-PenaltyList		; $80BF86  $1C cross check
	dw .hook-PenaltyList		; $80BF88  $1E hooking
	dw .trip-PenaltyList		; $80BF8A  $20 tripping
	dw .int-PenaltyList		; $80BF8C  $22 interference
	dw .hold-PenaltyList		; $80BF8E  $24 holding
	dw .fight-PenaltyList		; $80BF90  $26 fighting
	dw .fight2-PenaltyList		; $80BF92  $28 fighting * (93 only)
	dw .inst-PenaltyList		; $80BF94  $2A fight instigator
	dw .delay-PenaltyList		; $80BF96  $2C delay (92 PenDelay $24)
;format: dw $ttmm (tt = slow down time in half secs, mm = penalty min.); string (length word counting itself, text);
;then dw $ffdd,... (ff = frame, dd = delay; negative ends). 93G PenaltyList (hockey93_11)
.eop:		;period over (92 PenEOP 2)
	dw $0100		; $80BF98
	dw 13
	db "Period Over"
	dw -$0510
.eog:		;game over (92 PenEOG 4)
	dw $0100		; $80BFA9
	dw 11
	db "Game Over"
	dw $0510,-$4030
.goal:		;goal (92 PenGoal 6)
	dw $0100		; $80BFBA
	dw 2
	dw $050A,-$4010
.p14:		;93 only, no text
	dw $0100		; $80BFC2
	dw 2
	dw $0510,-$4018
.ice:		;icing (92 PenIcing 8)
	dw $0100		; $80BFCA
	dw 7
	db "Icing"
	dw $0002,$0101,-$0206
.offsides:		;offsides (92 PenOffsides $A)
	dw $0100		; $80BFD9
	dw 10
	db "Off-side"
	dw $0002,$0301,-$040F
.ghold:		;(92 PenOOP $C)
	dw $0100		; $80BFEB
	dw 10
	db "Face Off"
	dw -$050A
.delay:		;delay (92 PenDelay $24)
	dw $0000		; $80BFF9
	dw 9
	db "Penalty"
	dw $0003,$0301,-$040F
.whistle:		;whistle (92 PenWhistle $26)
	dw $0000		; $80C00A
	dw 2
	dw -$050A
.charge:		;charging
	dw $0402		; $80C010
	dw 10
	db "Charging"
	dw $0004,$0101,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,-$0101
.slash:		;slashing
	dw $0402		; $80C032
	dw 10
	db "Slashing"
	dw $0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.trip:		;tripping
	dw $0402		; $80C054
	dw 10
	db "Tripping"
	dw $0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.rough2:		;roughing, slow down time $A
	dw $0A02		; $80C074
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.rough:		;roughing
	dw $0402		; $80C094
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.hook:		;hooking
	dw $0402		; $80C0B4
	dw 9
	db "Hooking"
	dw $0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.cross:		;cross check
	dw $0402		; $80C0D5
	dw 13
	db "Cross Check"
	dw $0004,$0601,$0F01,$1001,$0F01,$1001,$0F01,$1001,$0F01,$1001,-$0101
.int:		;interference
	dw $0402		; $80C0FA
	dw 14
	db "Interference"
	dw $0004,$0101,$0C06,-$0101
.hold:		;holding
	dw $0402		; $80C112
	dw 9
	db "Holding"
	dw $0004,$0101,$0706,-$0101
.fight:		;fighting
	dw $2805		; $80C125
	dw 10
	db "Fighting"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.fight2:		;fighting * (93 only)
	dw $2805		; $80C145
	dw 12
	db "Fighting *"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.inst:		;fight instigator
	dw $2802		; $80C167
	dw 18
	db "Fight Instigator"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
