; $84E949-$84EF3B  ROM $26949-$26F3B: ScoutPicMap, then the SNES scouting report extras: PutDigits2, the two showcased
; players who skate in with their number and name (ScoutPlayersRun: one per team, picked from the line sets in ScoutLineOrder,
; animated with the ScoutScripts chosen from their ratings), and the roster helpers. The team stat words are scratch during the
; scouting report: tmshots = team shown, tmPwrGoals = ScoutLineOrder index, tmPwrPlays = roster player, tmPenalties = line slot,
; tmPenmin = script, tmATOP = script step. Starts after ScoutingReportText (boundary moved), ends before HotList.
org $84E949
ScoutPicMap:		;a 12 x 10 tile picture map, sequential tiles with attribute $20 (no reference found; the size of the 93G RonBarrMap picture on the scouting report)
	dw $2000,$2001,$2002,$2003,$2004,$2005,$2006,$2007,$2008,$2009,$200A,$200B		; $84E949
	dw $200C,$200D,$200E,$200F,$2010,$2011,$2012,$2013,$2014,$2015,$2016,$2017		; $84E961
	dw $2018,$2019,$201A,$2019,$2019,$2019,$201B,$201C,$2019,$2019,$2019,$201D		; $84E979
	dw $201E,$201F,$2020,$201F,$201F,$201F,$2021,$2022,$601F,$601F,$601F,$2023		; $84E991
	dw $2024,$2025,$2026,$2025,$2025,$2025,$2027,$2028,$2025,$2025,$2025,$2029		; $84E9A9
	dw $2024,$2025,$2025,$2025,$2025,$2025,$202A,$202B,$202C,$2025,$2025,$2029		; $84E9C1
	dw $2024,$2025,$2025,$2025,$2025,$2025,$202D,$202E,$202F,$2025,$2025,$2029		; $84E9D9
	dw $2024,$2025,$2025,$2025,$2025,$2025,$2030,$2031,$2032,$2033,$2025,$2029		; $84E9F1
	dw $2024,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2029		; $84EA09
	dw $2034,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2036		; $84EA21
PutDigits2:		;auto: CODE_84EA39. SNES: write the 2 digit number d0 (BCD byte, blank leading zero) as 2 characters at [a1], a1 += 2
	lda.w #$2020		; $84EA39: A9 20 20  blank, then the tens digit when d0 >= 10
	sta.b tmp0		; $84EA3C: 85 73
	lda.b d0		; $84EA3E: A5 53
	and.w #$00FF		; $84EA40: 29 FF 00
	cmp.w #$000A		; $84EA43: C9 0A 00
	bcc .lo		; $84EA46: 90 0A
	lsr a		; $84EA48: 4A
	lsr a		; $84EA49: 4A
	lsr a		; $84EA4A: 4A
	lsr a		; $84EA4B: 4A
	clc		; $84EA4C: 18
	adc.w #$0030		; $84EA4D: 69 30 00
	sta.b tmp0		; $84EA50: 85 73
.lo:
	lda.b d0		; $84EA52: A5 53
	and.w #$000F		; $84EA54: 29 0F 00
	clc		; $84EA57: 18
	adc.w #$0030		; $84EA58: 69 30 00
	sta.b tmp0+1		; $84EA5B: 85 74
	lda.b tmp0		; $84EA5D: A5 73
	sta.b [a1]		; $84EA5F: 87 37
	inc.b a1		; $84EA61: E6 37
	inc.b a1		; $84EA63: E6 37
	rtl		; $84EA65: 6B
ScoutPlayersRun:		;auto: CODE_84EA66. SNES scouting report: one frame of the two showcased players (home a2 = 0, away a2 = 2), then draw them
	stx.b xsave		; $84EA66: 86 0A
	ldx.w #$0000		; $84EA68: A2 00 00
.pushd:
	lda.b d0,x		; $84EA6B: B5 53
	pha		; $84EA6D: 48
	inx		; $84EA6E: E8
	inx		; $84EA6F: E8
	cpx.w #$0020		; $84EA70: E0 20 00
	bne .pushd		; $84EA73: D0 F6
	ldx.b xsave		; $84EA75: A6 0A
	stx.b xsave		; $84EA77: 86 0A
	ldx.w #$0000		; $84EA79: A2 00 00
.pusha:
	lda.b a0,x		; $84EA7C: B5 33
	pha		; $84EA7E: 48
	inx		; $84EA7F: E8
	inx		; $84EA80: E8
	cpx.w #$001C		; $84EA81: E0 1C 00
	bne .pusha		; $84EA84: D0 F6
	ldx.b xsave		; $84EA86: A6 0A
	lda.w #$0001		; $84EA88: A9 01 00  d7 = 1 frame
	sta.b d7		; $84EA8B: 85 6F
	stz.b a2		; $84EA8D: 64 3B
	jsl.l ScoutTeamStep		; $84EA8F: 22 BF EA 84
	lda.w #$0002		; $84EA93: A9 02 00
	sta.b a2		; $84EA96: 85 3B
	jsl.l ScoutTeamStep		; $84EA98: 22 BF EA 84
	jsl.l DrawScoutPlayers		; $84EA9C: 22 F4 EE 84
	stx.b xsave		; $84EAA0: 86 0A
	ldx.w #$001A		; $84EAA2: A2 1A 00
.popa:
	pla		; $84EAA5: 68
	sta.b a0,x		; $84EAA6: 95 33
	dex		; $84EAA8: CA
	dex		; $84EAA9: CA
	bpl .popa		; $84EAAA: 10 F9
	ldx.b xsave		; $84EAAC: A6 0A
	stx.b xsave		; $84EAAE: 86 0A
	ldx.w #$001E		; $84EAB0: A2 1E 00
.popd:
	pla		; $84EAB3: 68
	sta.b d0,x		; $84EAB4: 95 53
	dex		; $84EAB6: CA
	dex		; $84EAB7: CA
	bpl .popd		; $84EAB8: 10 F9
	ldx.b xsave		; $84EABA: A6 0A
	ldx.b a3		; $84EABC: A6 3F
	rtl		; $84EABE: 6B
ScoutTeamStep:		;auto: CODE_84EABF. SNES: step the showcased player of team a2: a new team (tmteam changed) picks its goalie and restarts the order (ScoutPlayerExit); skating out to the side
		;   (tmflags bit 1) ends at x 40 (ScoutNextPlayer); else the next script step (SPA, facedir) every 9 frames, then print his number and name
	ldy.b a2		; $84EABF: A4 3B
	lda.w tmteam,y		; $84EAC1: B9 F6 13  team changed?
	sta.b d0		; $84EAC4: 85 53
	cmp.w tmshots,y		; $84EAC6: D9 B2 13
	beq .cur		; $84EAC9: F0 13
	sta.w tmshots,y		; $84EACB: 99 B2 13
	jsl.l PickStartingGoalie		; $84EACE: 22 E3 FC 86
	ldy.b a2		; $84EAD2: A4 3B
	lda.w #$0000		; $84EAD4: A9 00 00
	sta.w tmPwrGoals,y		; $84EAD7: 99 B6 13
	jsl.l ScoutPlayerExit		; $84EADA: 22 4C EC 84
.cur:
	ldy.b a2		; $84EADE: A4 3B
	lda.w tmsort,y		; $84EAE0: B9 D2 13  X = a3 = first object of the team
	sta.b a3		; $84EAE3: 85 3F
	tax		; $84EAE5: AA
	lda.w tmflags,y		; $84EAE6: B9 0A 14
	bit.w #$0002		; $84EAE9: 89 02 00
	beq .in		; $84EAEC: F0 25
	inc.w OldZpos,x		; $84EAEE: FE 9F 0A  skating out: x += 3
	inc.w OldZpos,x		; $84EAF1: FE 9F 0A
	inc.w OldZpos,x		; $84EAF4: FE 9F 0A
	inc.w OldXpos,x		; $84EAF7: FE 1F 0A
	inc.w OldXpos,x		; $84EAFA: FE 1F 0A
	inc.w OldXpos,x		; $84EAFD: FE 1F 0A
	lda.w OldXpos,x		; $84EB00: BD 1F 0A
	sec		; $84EB03: 38
	sbc.w #40		; $84EB04: E9 28 00
	beq .rtl		; $84EB07: F0 09
	bmi .v1		; $84EB09: 30 05
	bvs .rtl		; $84EB0B: 70 05
.next1:
	jmp.w ScoutNextPlayer		; $84EB0D: 4C 5C EC
.v1:
	bvs .next1		; $84EB10: 70 FB
.rtl:
	rtl		; $84EB12: 6B
.in:		;skating in from the left
	lda.w OldXpos,x		; $84EB13: BD 1F 0A  skating in: x += 1 while negative
	bpl .anim		; $84EB16: 10 06
	inc.w OldZpos,x		; $84EB18: FE 9F 0A
	inc.w OldXpos,x		; $84EB1B: FE 1F 0A
.anim:
	jsl.l updateanim		; $84EB1E: 22 3E E1 80
	lda.w pf2aip,x		; $84EB22: BD DF 11  pf2aip: wait for the step delay
	beq .step		; $84EB25: F0 03
	jmp.w ScoutPlayerExit_rtl		; $84EB27: 4C 5B EC
.step:		;next script step
	ldy.b a2		; $84EB2A: A4 3B
	lda.w tmPenmin,y		; $84EB2C: B9 C2 13  a0 = ScoutScripts + offset of the script + step; step += 4
	asl a		; $84EB2F: 0A
	sta.b d0		; $84EB30: 85 53
	tay		; $84EB32: A8
	lda.w #ScoutScripts>>16		; $84EB33: A9 84 00
	sta.b a0+2		; $84EB36: 85 35
	lda.w #ScoutScripts		; $84EB38: A9 F3 ED
	sta.b a0		; $84EB3B: 85 33
	clc		; $84EB3D: 18
	adc.b [a0],y		; $84EB3E: 77 33
	ldy.b a2		; $84EB40: A4 3B
	adc.w tmATOP,y		; $84EB42: 79 CA 13
	sta.b a0		; $84EB45: 85 33
	lda.w tmATOP,y		; $84EB47: B9 CA 13
	adc.w #$0004		; $84EB4A: 69 04 00
	sta.w tmATOP,y		; $84EB4D: 99 CA 13
	lda.b [a0]		; $84EB50: A7 33
	sta.b d1		; $84EB52: 85 57
	bne .set		; $84EB54: D0 03
	jmp.w ScoutPlayerExit		; $84EB56: 4C 4C EC
.set:
	jsl.l SetSPA		; $84EB59: 22 06 B0 80  SetSPA d1, 9 frames per step, facedir
	lda.w #$0009		; $84EB5D: A9 09 00
	sta.w pf2aip,x		; $84EB60: 9D DF 11
	ldy.w #$0002		; $84EB63: A0 02 00
	lda.b [a0],y		; $84EB66: B7 33
	sta.w facedir,x		; $84EB68: 9D BF 0D
	bmi .flip		; $84EB6B: 30 03
	jmp.w ScoutPlayerExit_rtl		; $84EB6D: 4C 5B EC
.flip:		;negative facedir: first step of a new player, print the name
	eor.w #$FFFF		; $84EB70: 49 FF FF
	inc a		; $84EB73: 1A
	sta.w facedir,x		; $84EB74: 9D BF 0D
	ldy.b a2		; $84EB77: A4 3B
	lda.w tmPwrPlays,y		; $84EB79: B9 BA 13
	sta.b d0		; $84EB7C: 85 53
	jsl.l GetRosterEntry		; $84EB7E: 22 96 ED 84  mesarea = number and the first name, centered in 11 columns
	jsl.l ScoutNamePos		; $84EB82: 22 76 FC 86
	lda.w printx		; $84EB86: AD 7B 04
	pha		; $84EB89: 48
	lda.w #mesarea+2		; $84EB8A: A9 93 01
	sta.b a1		; $84EB8D: 85 37
	lda.w #$0000		; $84EB8F: A9 00 00
	sta.b a1+2		; $84EB92: 85 39
	lda.b [a0]		; $84EB94: A7 33
	tay		; $84EB96: A8
	lda.b [a0],y		; $84EB97: B7 33
	and.w #$00FF		; $84EB99: 29 FF 00
	sta.b d0		; $84EB9C: 85 53
	lsr a		; $84EB9E: 4A
	lsr a		; $84EB9F: 4A
	lsr a		; $84EBA0: 4A
	lsr a		; $84EBA1: 4A
	beq .lo		; $84EBA2: F0 08
	clc		; $84EBA4: 18
	adc.w #$0030		; $84EBA5: 69 30 00
	sta.b [a1]		; $84EBA8: 87 37
	inc.b a1		; $84EBAA: E6 37
.lo:
	lda.b d0		; $84EBAC: A5 53
	and.w #$000F		; $84EBAE: 29 0F 00
	clc		; $84EBB1: 18
	adc.w #$0030		; $84EBB2: 69 30 00
	sta.b [a1]		; $84EBB5: 87 37
	inc.b a1		; $84EBB7: E6 37
	lda.w #$0020		; $84EBB9: A9 20 00
	sta.b [a1]		; $84EBBC: 87 37
	inc.b a1		; $84EBBE: E6 37
	ldy.w #$0001		; $84EBC0: A0 01 00
.first:
	iny		; $84EBC3: C8
	lda.b [a0],y		; $84EBC4: B7 33
	and.w #$00FF		; $84EBC6: 29 FF 00
	cmp.w #$0020		; $84EBC9: C9 20 00
	beq .pr1		; $84EBCC: F0 06
	sta.b [a1]		; $84EBCE: 87 37
	inc.b a1		; $84EBD0: E6 37
	bra .first		; $84EBD2: 80 EF
.pr1:
	lda.b a1		; $84EBD4: A5 37
	sec		; $84EBD6: 38
	sbc.w #mesarea		; $84EBD7: E9 91 01
	sta.w mesarea		; $84EBDA: 8D 91 01
	dec a		; $84EBDD: 3A
	dec a		; $84EBDE: 3A
	eor.w #$FFFF		; $84EBDF: 49 FF FF
	inc a		; $84EBE2: 1A
	clc		; $84EBE3: 18
	adc.w #$000B		; $84EBE4: 69 0B 00
	lsr a		; $84EBE7: 4A
	clc		; $84EBE8: 18
	adc.w printx		; $84EBE9: 6D 7B 04
	sta.w printx		; $84EBEC: 8D 7B 04
	lda.w #mesarea		; $84EBEF: A9 91 01
	sta.b a1		; $84EBF2: 85 37
	jsl.l print		; $84EBF4: 22 2D B9 80
	pla		; $84EBF8: 68
	sta.w printx		; $84EBF9: 8D 7B 04
	inc.w printy		; $84EBFC: EE 7D 04
	lda.b [a0]		; $84EBFF: A7 33  then the last name on the next line
	sta.b tmp0		; $84EC01: 85 73
	ldy.w #$0001		; $84EC03: A0 01 00
.skip:
	iny		; $84EC06: C8
	lda.b [a0],y		; $84EC07: B7 33
	and.w #$00FF		; $84EC09: 29 FF 00
	cmp.w #$0020		; $84EC0C: C9 20 00
	bne .skip		; $84EC0F: D0 F5
	lda.w #mesarea+2		; $84EC11: A9 93 01
	sta.b a1		; $84EC14: 85 37
	lda.w #$0000		; $84EC16: A9 00 00
	sta.b a1+2		; $84EC19: 85 39
.last:
	iny		; $84EC1B: C8
	cpy.b tmp0		; $84EC1C: C4 73
	beq .pr2		; $84EC1E: F0 08
	lda.b [a0],y		; $84EC20: B7 33
	sta.b [a1]		; $84EC22: 87 37
	inc.b a1		; $84EC24: E6 37
	bra .last		; $84EC26: 80 F3
.pr2:
	lda.b a1		; $84EC28: A5 37
	sec		; $84EC2A: 38
	sbc.w #mesarea		; $84EC2B: E9 91 01
	sta.w mesarea		; $84EC2E: 8D 91 01
	dec a		; $84EC31: 3A
	dec a		; $84EC32: 3A
	eor.w #$FFFF		; $84EC33: 49 FF FF
	inc a		; $84EC36: 1A
	clc		; $84EC37: 18
	adc.w #$000B		; $84EC38: 69 0B 00
	lsr a		; $84EC3B: 4A
	clc		; $84EC3C: 18
	adc.w printx		; $84EC3D: 6D 7B 04
	sta.w printx		; $84EC40: 8D 7B 04
	lda.w #mesarea		; $84EC43: A9 91 01
	sta.b a1		; $84EC46: 85 37
	jml.l print		; $84EC48: 5C 2D B9 80
ScoutPlayerExit:		;auto: CODE_84EC4C. SNES: the showcased player of team a2 skates off ($89FCC1, tmflags bit 1)
	jsl.l EraseScoutName		; $84EC4C: 22 C1 FC 89  bank $89
	ldy.b a2		; $84EC50: A4 3B
	lda.w tmflags,y		; $84EC52: B9 0A 14
	ora.w #$0002		; $84EC55: 09 02 00
	sta.w tmflags,y		; $84EC58: 99 0A 14
.rtl:
	rtl		; $84EC5B: 6B
ScoutNextPlayer:		;auto: CODE_84EC5C. SNES: the next showcased player of team a2 from ScoutLineOrder (goalie: tmgoalie): start at x -40, pick his ScoutScripts entry from his ratings
	jsl.l SetTeamColors		; $84EC5C: 22 06 B7 80  SprSort
	ldy.b a2		; $84EC60: A4 3B
	lda.w tmflags,y		; $84EC62: B9 0A 14
	and.w #$FFFD		; $84EC65: 29 FD FF
	sta.w tmflags,y		; $84EC68: 99 0A 14
	lda.w tmsort,y		; $84EC6B: B9 D2 13
	sta.b a3		; $84EC6E: 85 3F
	tax		; $84EC70: AA
	lda.w #-40		; $84EC71: A9 D8 FF
	sta.w OldXpos,x		; $84EC74: 9D 1F 0A
	stz.w SPA,x		; $84EC77: 9E FF 0D
.order:
	ldy.b a2		; $84EC7A: A4 3B
	lda.w tmPwrGoals,y		; $84EC7C: B9 B6 13
	sta.b d0		; $84EC7F: 85 53
	tay		; $84EC81: A8
	lda.w #ScoutLineOrder		; $84EC82: A9 E3 EE  ScoutLineOrder[tmPwrGoals]: $FF restarts the list
	sta.b a0		; $84EC85: 85 33
	lda.w #ScoutLineOrder>>16		; $84EC87: A9 84 00
	sta.b a0+2		; $84EC8A: 85 35
	lda.b [a0],y		; $84EC8C: B7 33
	and.w #$00FF		; $84EC8E: 29 FF 00
	sta.b d0		; $84EC91: 85 53
	bit.w #$0080		; $84EC93: 89 80 00
	beq .got		; $84EC96: F0 0A
	ldy.b a2		; $84EC98: A4 3B
	lda.w #$0000		; $84EC9A: A9 00 00
	sta.w tmPwrGoals,y		; $84EC9D: 99 B6 13
	bra .order		; $84ECA0: 80 D8
.got:
	ldy.b a2		; $84ECA2: A4 3B
	lda.b d0		; $84ECA4: A5 53
	sta.w tmPenalties,y		; $84ECA6: 99 BE 13
	lda.w tmPwrGoals,y		; $84ECA9: B9 B6 13
	inc a		; $84ECAC: 1A
	sta.w tmPwrGoals,y		; $84ECAD: 99 B6 13
	lda.w #TeamList>>16		; $84ECB0: A9 83 00
	sta.b a0+2		; $84ECB3: 85 35
	lda.w tmdata,y		; $84ECB5: B9 CE 13  roster player = LineSets byte - 1 (goalie slot: tmgoalie)
	sta.b a0		; $84ECB8: 85 33
	clc		; $84ECBA: 18
	ldy.w #LineSets		; $84ECBB: A0 06 00
	adc.b [a0],y		; $84ECBE: 77 33
	sta.b a0		; $84ECC0: 85 33
	ldy.b d0		; $84ECC2: A4 53
	lda.b [a0],y		; $84ECC4: B7 33
	and.w #$00FF		; $84ECC6: 29 FF 00
	dec a		; $84ECC9: 3A
	sta.b d0		; $84ECCA: 85 53
	ldy.b a2		; $84ECCC: A4 3B
	lda.w tmPenalties,y		; $84ECCE: B9 BE 13
	bne .pl		; $84ECD1: D0 05
	lda.w tmgoalie,y		; $84ECD3: B9 F2 13
	sta.b d0		; $84ECD6: 85 53
.pl:
	lda.b d0		; $84ECD8: A5 53
	ldy.b a2		; $84ECDA: A4 3B
	sta.w tmPwrPlays,y		; $84ECDC: 99 BA 13
	jsl.l GetRosterEntry		; $84ECDF: 22 96 ED 84
	lda.b a0		; $84ECE3: A5 33
	clc		; $84ECE5: 18
	adc.b [a0]		; $84ECE6: 67 33
	sta.b a0		; $84ECE8: 85 33
	lda.w attribute,x		; $84ECEA: BD DF 09  handedness bit: flip
	and.w #$F7FF		; $84ECED: 29 FF F7
	sta.w attribute,x		; $84ECF0: 9D DF 09
	ldy.w #Playerdata+4		; $84ECF3: A0 04 00
	lda.b [a0],y		; $84ECF6: B7 33
	lsr a		; $84ECF8: 4A
	bcs .rate		; $84ECF9: B0 09
	lda.w attribute,x		; $84ECFB: BD DF 09
	ora.w #$0800		; $84ECFE: 09 00 08
	sta.w attribute,x		; $84ED01: 9D DF 09
.rate:		;ScoutPickScript for each of the 14 rating nibbles (ScoutScriptPick, goalies ScoutScriptPickG)
	inc.b a0		; $84ED04: E6 33
	lda.w #$0006		; $84ED06: A9 06 00
	sta.b d0		; $84ED09: 85 53
	stz.b d2		; $84ED0B: 64 5B
	lda.w #ScoutScriptPick		; $84ED0D: A9 BB ED
	sta.b a1		; $84ED10: 85 37
	lda.w #ScoutScriptPick>>16		; $84ED12: A9 84 00
	sta.b a1+2		; $84ED15: 85 39
	ldy.b a2		; $84ED17: A4 3B
	lda.w tmPenalties,y		; $84ED19: B9 BE 13
	and.w #$0007		; $84ED1C: 29 07 00
	sta.b d3		; $84ED1F: 85 5F
	bne .nib		; $84ED21: D0 05
	lda.w #ScoutScriptPickG		; $84ED23: A9 D7 ED
	sta.b a1		; $84ED26: 85 37
.nib:
	lda.b [a0]		; $84ED28: A7 33
	and.w #$00FF		; $84ED2A: 29 FF 00
	lsr a		; $84ED2D: 4A
	lsr a		; $84ED2E: 4A
	lsr a		; $84ED2F: 4A
	lsr a		; $84ED30: 4A
	sta.b d1		; $84ED31: 85 57
	jsl.l ScoutPickScript		; $84ED33: 22 51 ED 84
	lda.b [a0]		; $84ED37: A7 33
	inc.b a0		; $84ED39: E6 33
	and.w #$000F		; $84ED3B: 29 0F 00
	sta.b d1		; $84ED3E: 85 57
	jsl.l ScoutPickScript		; $84ED40: 22 51 ED 84
	dec.b d0		; $84ED44: C6 53
	bpl .nib		; $84ED46: 10 E0
	ldy.b a2		; $84ED48: A4 3B
	lda.w #$0000		; $84ED4A: A9 00 00
	sta.w tmATOP,y		; $84ED4D: 99 CA 13
	rtl		; $84ED50: 6B
ScoutPickScript:		;auto: CODE_84ED51. SNES: rating nibble d1 against the next (minimum, script) pair at [a1]: the highest qualifying rating picks tmPenmin
	lda.b [a1]		; $84ED51: A7 37
	and.w #$00FF		; $84ED53: 29 FF 00
	sta.b tmp0		; $84ED56: 85 73
	inc.b a1		; $84ED58: E6 37
	lda.b [a1]		; $84ED5A: A7 37
	and.w #$00FF		; $84ED5C: 29 FF 00
	sta.b tmp1		; $84ED5F: 85 75
	inc.b a1		; $84ED61: E6 37
	lda.b d1		; $84ED63: A5 57
	sec		; $84ED65: 38
	sbc.b tmp0		; $84ED66: E5 73
	bmi .v1		; $84ED68: 30 05
	bvc .best		; $84ED6A: 50 05
.ex1:
	jmp.w ScoutPlayerExit_rtl		; $84ED6C: 4C 5B EC
.v1:
	bvc .ex1		; $84ED6F: 50 FB
.best:
	lda.b d1		; $84ED71: A5 57
	sec		; $84ED73: 38
	sbc.b d2		; $84ED74: E5 5B
	bmi .v2		; $84ED76: 30 05
	bvc .z		; $84ED78: 50 05
.ex2:
	jmp.w ScoutPlayerExit_rtl		; $84ED7A: 4C 5B EC
.v2:
	bvc .ex2		; $84ED7D: 50 FB
.z:
	lda.b d2		; $84ED7F: A5 5B
	beq .take		; $84ED81: F0 07
	lda.b tmp0		; $84ED83: A5 73
	bne .take		; $84ED85: D0 03
	jmp.w ScoutPlayerExit_rtl		; $84ED87: 4C 5B EC
.take:
	lda.b d1		; $84ED8A: A5 57
	sta.b d2		; $84ED8C: 85 5B
	ldy.b a2		; $84ED8E: A4 3B
	lda.b tmp1		; $84ED90: A5 75
	sta.w tmPenmin,y		; $84ED92: 99 C2 13
	rtl		; $84ED95: 6B
GetRosterEntry:		;auto: CODE_84ED96. SNES: a0 = Playerdata entry of roster player d0 of team a2 (walks the Player list)
	lda.w #TeamList>>16		; $84ED96: A9 83 00
	sta.b a0+2		; $84ED99: 85 35
	ldy.b a2		; $84ED9B: A4 3B
	lda.w tmdata,y		; $84ED9D: B9 CE 13
	sta.b a0		; $84EDA0: 85 33
	clc		; $84EDA2: 18
	ldy.w #Playerdata		; $84EDA3: A0 00 00
	adc.b [a0],y		; $84EDA6: 77 33
	sta.b a0		; $84EDA8: 85 33
	bra .cnt		; $84EDAA: 80 0A
.next:
	lda.b a0		; $84EDAC: A5 33
	clc		; $84EDAE: 18
	adc.b [a0]		; $84EDAF: 67 33
	adc.w #$0008		; $84EDB1: 69 08 00
	sta.b a0		; $84EDB4: 85 33
.cnt:
	dec.b d0		; $84EDB6: C6 53
	bpl .next		; $84EDB8: 10 F2
	rtl		; $84EDBA: 6B
ScoutScriptPick:		;SNES: (minimum rating, script) per rating nibble for skaters
	db 0,1, 11,2, 0,1, 0,1, 11,6, 11,3, 0,1, 11,7, 11,4, 0,1, 0,1, 0,1, 0,1, 0,1		; $84EDBB
ScoutScriptPickG:		;SNES: (minimum rating, script) per rating nibble for goalies
	db 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 11,5, 11,5		; $84EDD7
ScoutScripts:		;SNES: the showcase animation scripts: 8 offsets, then (SPA, facedir) steps; a negative facedir prints the name (and flips), 0 ends
	dw .s0-ScoutScripts,.s1-ScoutScripts,.s2-ScoutScripts,.s3-ScoutScripts,.s4-ScoutScripts,.s5-ScoutScripts,.s6-ScoutScripts,.s7-ScoutScripts		; $84EDF3
.s0:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglover,4,SPAgready2,4,SPAgglovel,4,SPAgready2,4,0		; $84EE03
.s5:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglovel,4,SPAgready2,4,SPAgready2,4,0		; $84EE25
.s1:	dw SPAskate,3,SPAskate,4,SPAcelebrate,-5,SPAcelebrate,4,SPAglide,4,SPAglide,4,0		; $84EE43
.s2:	dw SPAskatewp,4,SPAskatewp,4,SPAskatewp,-4,SPAglide,4,SPAglide,4,0		; $84EE5D
.s3:	dw SPAskatewp,5,SPAskatewp,5,SPAshotf,-5,SPAglide,5,SPAglide,5,0		; $84EE73
.s4:	dw SPAskatewp,3,SPAskatewp,3,SPAstumble,-3,SPAshotf,3,SPAglide,3,SPAglide,3,0		; $84EE89
.s6:	dw SPAskate,4,SPAskate,5,SPAsweepchk,-5,SPAsweepchk,5,SPAskate,5,SPAsweepchk,5,SPAglide,5,SPAglide,5,0		; $84EEA3
.s7:	dw SPAskate,3,SPAskate,2,SPAfight,-2,SPAfhigh,2,SPAflow,2,SPAfhigh,2,SPAflow,2,0		; $84EEC5
ScoutLineOrder:		;SNES: the LineSets bytes shown in order (lines 1-3), $FF ends
	db $04,$05,$03,$00,$02,$01,$0C,$0D,$0B,$0A,$09,$14,$15,$13,$12,$11,$FF		; $84EEE3
DrawScoutPlayers:		;auto: CODE_84EEF4. SNES: addframe for the two showcased players (objects 0 and 6)
	ldx.w #$0000		; $84EEF4: A2 00 00
	stx.b a3		; $84EEF7: 86 3F
	jsl.l DrawScoutPlayer		; $84EEF9: 22 02 EF 84
	ldx.w #$000C		; $84EEFD: A2 0C 00
	stx.b a3		; $84EF00: 86 3F
DrawScoutPlayer:		;auto: CODE_84EF02. SNES: addframe for object X at (Xpos + OldXpos - 144, Ypos - 128)
	lda.w Xpos,x		; $84EF02: BD FF 08
	clc		; $84EF05: 18
	adc.w OldXpos,x		; $84EF06: 7D 1F 0A
	sec		; $84EF09: 38
	sbc.w #$0090		; $84EF0A: E9 90 00
	sta.b sprx		; $84EF0D: 85 C9
	lda.w Ypos,x		; $84EF0F: BD 5F 09
	sec		; $84EF12: 38
	sbc.w #$0080		; $84EF13: E9 80 00
	sta.b spry		; $84EF16: 85 CB
	lda.w frame,x		; $84EF18: BD 3F 09
	sta.b sprframe		; $84EF1B: 85 C3
	lda.w attribute,x		; $84EF1D: BD DF 09
	and.w #$0800		; $84EF20: 29 00 08
	sta.b sprhflip		; $84EF23: 85 A5
	lda.w attribute,x		; $84EF25: BD DF 09
	and.w #$1000		; $84EF28: 29 00 10
	sta.b sprvflip		; $84EF2B: 85 CD
	lda.w attribute,x		; $84EF2D: BD DF 09
	lsr a		; $84EF30: 4A
	bcc .add		; $84EF31: 90 05
	lda.w #$8000		; $84EF33: A9 00 80
	sta.b sprflag		; $84EF36: 85 AB
.add:
	jml.l addframe		; $84EF38: 5C 68 EC 8F  bank $8F: 93G addframe
