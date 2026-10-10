; $89F00A-$89FFFF  ROM $4F00A-$4FFFF: the rest of RefTilesHor, RefsMapHor (ref window frames for the horizontal rink), the music cue starters
; StartSong1-5/8/9, CopyWords, EraseScoutName, GetPlayerRecord, MesAreaDone, StartGame and restoreteams (hockey93_01), EvadePC (logic93_3),
; asswingd (logic93_2, asstab 3), $FF fill.
org $89F00A
	incbin "../data/RefHor.chr.pak":$4C5..$8B6		; $89F00A-$89F3FA
RefTilesHorEnd:
	assert RefTilesHorEnd-RefTilesHor == $8B6
RefsMapHor:		;ref window frames for the horizontal rink, 17 frames of 8 x 7 words (data/RefsHor.snesmap); PushRef ($8F83A7) uses it when sfhormode
	incbin "../data/RefsHor.snesmap"		; $89F3FB-$89FB6A
RefsMapHorEnd:
	assert RefsMapHorEnd-RefsMapHor == 17*$70
StartSong8:		;auto: CODE_89FB6B. SNES: start song 8 (no caller found) unless it plays: the boot sound set (SPCBootUpload), then driver command 9
	lda.w cursong		; $89FB6B: AD 51 16
	cmp.w #8		; $89FB6E: C9 08 00
	beq .rtl		; $89FB71: F0 1B
	lda.w sndbank		; $89FB73: AD 4F 16
	cmp.w #2		; $89FB76: C9 02 00
	beq .cmd		; $89FB79: F0 04
	jsl.l SPCBootUpload		; $89FB7B: 22 31 FA 82
.cmd:
	sep #$20		; $89FB7F: E2 20
	lda.b #$09		; $89FB81: A9 09
	sta.w APUIO0		; $89FB83: 8D 40 21
	rep #$30		; $89FB86: C2 30
	lda.w #8		; $89FB88: A9 08 00
	sta.w cursong		; $89FB8B: 8D 51 16
.rtl:
	rtl		; $89FB8E: 6B
StartSong9:		;auto: CODE_89FB8F. SNES: start song 9 (the playoff screen music, PlayoffScreen) unless it plays: the boot sound set (SPCBootUpload), then driver command 1
	lda.w cursong		; $89FB8F: AD 51 16
	cmp.w #9		; $89FB92: C9 09 00
	beq .rtl		; $89FB95: F0 1B
	lda.w sndbank		; $89FB97: AD 4F 16
	cmp.w #2		; $89FB9A: C9 02 00
	beq .cmd		; $89FB9D: F0 04
	jsl.l SPCBootUpload		; $89FB9F: 22 31 FA 82
.cmd:
	sep #$20		; $89FBA3: E2 20
	lda.b #$01		; $89FBA5: A9 01
	sta.w APUIO0		; $89FBA7: 8D 40 21
	rep #$30		; $89FBAA: C2 30
	lda.w #9		; $89FBAC: A9 09 00
	sta.w cursong		; $89FBAF: 8D 51 16
.rtl:
	rtl		; $89FBB2: 6B
StartSong1:		;auto: CODE_89FBB3. SNES: start music cue 1 (home goal) unless it plays: the in-game sound set, then $8FFE7B with 4; cuetimer = its length
	lda.w cursong		; $89FBB3: AD 51 16
	cmp.w #$0001		; $89FBB6: C9 01 00
	beq .rtl		; $89FBB9: F0 23
	lda.w sndbank		; $89FBBB: AD 4F 16
	cmp.w #$0001		; $89FBBE: C9 01 00
	beq .cmd		; $89FBC1: F0 08
	jsl.l sndqreset		; $89FBC3: 22 1A FA 82
	jsl.l SPCGameUpload		; $89FBC7: 22 7A FA 82
.cmd:
	lda.w #$0004		; $89FBCB: A9 04 00
	jsl.l $8FFE7B		; $89FBCE: 22 7B FE 8F  bank $8F: driver command A (music cue)
	lda.w #$0001		; $89FBD2: A9 01 00
	sta.w cursong		; $89FBD5: 8D 51 16
	lda.w #$0240		; $89FBD8: A9 40 02
	sta.w cuetimer		; $89FBDB: 8D A9 04
.rtl:
	rtl		; $89FBDE: 6B
StartSong2:		;auto: CODE_89FBDF. SNES: start music cue 2 (period start) unless it plays: the in-game sound set, then $8FFE7B with 5; cuetimer = its length
	lda.w cursong		; $89FBDF: AD 51 16
	cmp.w #$0002		; $89FBE2: C9 02 00
	beq .rtl		; $89FBE5: F0 23
	lda.w sndbank		; $89FBE7: AD 4F 16
	cmp.w #$0001		; $89FBEA: C9 01 00
	beq .cmd		; $89FBED: F0 08
	jsl.l sndqreset		; $89FBEF: 22 1A FA 82
	jsl.l SPCGameUpload		; $89FBF3: 22 7A FA 82
.cmd:
	lda.w #$0005		; $89FBF7: A9 05 00
	jsl.l $8FFE7B		; $89FBFA: 22 7B FE 8F  bank $8F: driver command A (music cue)
	lda.w #$0002		; $89FBFE: A9 02 00
	sta.w cursong		; $89FC01: 8D 51 16
	lda.w #$01CE		; $89FC04: A9 CE 01
	sta.w cuetimer		; $89FC07: 8D A9 04
.rtl:
	rtl		; $89FC0A: 6B
StartSong3:		;auto: CODE_89FC0B. SNES: start music cue 3 (from bank $8E) unless it plays: the in-game sound set, then $8FFE7B with 6; cuetimer = its length
	lda.w cursong		; $89FC0B: AD 51 16
	cmp.w #$0003		; $89FC0E: C9 03 00
	beq .rtl		; $89FC11: F0 23
	lda.w sndbank		; $89FC13: AD 4F 16
	cmp.w #$0001		; $89FC16: C9 01 00
	beq .cmd		; $89FC19: F0 08
	jsl.l sndqreset		; $89FC1B: 22 1A FA 82
	jsl.l SPCGameUpload		; $89FC1F: 22 7A FA 82
.cmd:
	lda.w #$0006		; $89FC23: A9 06 00
	jsl.l $8FFE7B		; $89FC26: 22 7B FE 8F  bank $8F: driver command A (music cue)
	lda.w #$0003		; $89FC2A: A9 03 00
	sta.w cursong		; $89FC2D: 8D 51 16
	lda.w #$0474		; $89FC30: A9 74 04
	sta.w cuetimer		; $89FC33: 8D A9 04
.rtl:
	rtl		; $89FC36: 6B
StartSong4:		;auto: CODE_89FC37. SNES: start music cue 4 (no caller found) unless it plays: the in-game sound set, then $8FFE7B with 7; cuetimer = its length
	lda.w cursong		; $89FC37: AD 51 16
	cmp.w #$0004		; $89FC3A: C9 04 00
	beq .rtl		; $89FC3D: F0 23
	lda.w sndbank		; $89FC3F: AD 4F 16
	cmp.w #$0001		; $89FC42: C9 01 00
	beq .cmd		; $89FC45: F0 08
	jsl.l sndqreset		; $89FC47: 22 1A FA 82
	jsl.l SPCGameUpload		; $89FC4B: 22 7A FA 82
.cmd:
	lda.w #$0007		; $89FC4F: A9 07 00
	jsl.l $8FFE7B		; $89FC52: 22 7B FE 8F  bank $8F: driver command A (music cue)
	lda.w #$0004		; $89FC56: A9 04 00
	sta.w cursong		; $89FC59: 8D 51 16
	lda.w #$022E		; $89FC5C: A9 2E 02
	sta.w cuetimer		; $89FC5F: 8D A9 04
.rtl:
	rtl		; $89FC62: 6B
StartSong5:		;auto: CODE_89FC63. SNES: start music cue 5 (mid-period) unless it plays: the in-game sound set, then $8FFE7B with 8; cuetimer = its length
	lda.w cursong		; $89FC63: AD 51 16
	cmp.w #$0005		; $89FC66: C9 05 00
	beq .rtl		; $89FC69: F0 23
	lda.w sndbank		; $89FC6B: AD 4F 16
	cmp.w #$0001		; $89FC6E: C9 01 00
	beq .cmd		; $89FC71: F0 08
	jsl.l sndqreset		; $89FC73: 22 1A FA 82
	jsl.l SPCGameUpload		; $89FC77: 22 7A FA 82
.cmd:
	lda.w #$0008		; $89FC7B: A9 08 00
	jsl.l $8FFE7B		; $89FC7E: 22 7B FE 8F  bank $8F: driver command A (music cue)
	lda.w #$0005		; $89FC82: A9 05 00
	sta.w cursong		; $89FC85: 8D 51 16
	lda.w #$041A		; $89FC88: A9 1A 04
	sta.w cuetimer		; $89FC8B: 8D A9 04
.rtl:
	rtl		; $89FC8E: 6B
CopyWords:		;auto: CODE_89FC8F. SNES: copy d0 bytes (words) from [d2] to [d1]
	stx.b xsave		; $89FC8F: 86 0A
	ldx.w #$0000		; $89FC91: A2 00 00
.pushd:
	lda.b d0,x		; $89FC94: B5 53
	pha		; $89FC96: 48
	inx		; $89FC97: E8
	inx		; $89FC98: E8
	cpx.w #$000C		; $89FC99: E0 0C 00
	bne .pushd		; $89FC9C: D0 F6
	ldx.b xsave		; $89FC9E: A6 0A
.copy:
	lda.b [d2]		; $89FCA0: A7 5B
	sta.b [d1]		; $89FCA2: 87 57
	inc.b d1		; $89FCA4: E6 57
	inc.b d1		; $89FCA6: E6 57
	inc.b d2		; $89FCA8: E6 5B
	inc.b d2		; $89FCAA: E6 5B
	dec.b d0		; $89FCAC: C6 53
	dec.b d0		; $89FCAE: C6 53
	bne .copy		; $89FCB0: D0 EE
	stx.b xsave		; $89FCB2: 86 0A
	ldx.w #$000A		; $89FCB4: A2 0A 00
.popd:
	pla		; $89FCB7: 68
	sta.b d0,x		; $89FCB8: 95 53
	dex		; $89FCBA: CA
	dex		; $89FCBB: CA
	bpl .popd		; $89FCBC: 10 F9
	ldx.b xsave		; $89FCBE: A6 0A
	rtl		; $89FCC0: 6B
EraseScoutName:		;auto: CODE_89FCC1. SNES: blank the 11 x 2 showcased player name area (ScoutNamePos, eraser)
	jsl.l ScoutNamePos		; $89FCC1: 22 76 FC 86
	lda.w #$000B		; $89FCC5: A9 0B 00
	sta.b d0		; $89FCC8: 85 53
	lda.w #$0002		; $89FCCA: A9 02 00
	sta.b d1		; $89FCCD: 85 57
	lda.w blankchar		; $89FCCF: AD E7 1B
	sta.b d2		; $89FCD2: 85 5B
	jml.l $8D847C		; $89FCD4: 5C 7C 84 8D  bank $8D: 92G eraser
GetPlayerRecord:		;auto: CODE_89FCD8. SNES: a0 = roster record of player d0 of team a2 (tmdata: the player data, then name length + 8 bytes per player; 93G does it inline)
	lda.w #$0083		; $89FCD8: A9 83 00
	sta.b a0+2		; $89FCDB: 85 35
	ldy.b a2		; $89FCDD: A4 3B
	lda.w tmdata,y		; $89FCDF: B9 CE 13
	sta.b a0		; $89FCE2: 85 33
	ldy.w #$0000		; $89FCE4: A0 00 00
	clc		; $89FCE7: 18
	adc.b [a0]		; $89FCE8: 67 33
	sta.b a0		; $89FCEA: 85 33
	bra .cnt		; $89FCEC: 80 0A
.next:
	lda.b a0		; $89FCEE: A5 33
	clc		; $89FCF0: 18
	adc.b [a0]		; $89FCF1: 67 33
	adc.w #$0008		; $89FCF3: 69 08 00
	sta.b a0		; $89FCF6: 85 33
.cnt:
	dec.b d0		; $89FCF8: C6 53
	bpl .next		; $89FCFA: 10 F2
	rtl		; $89FCFC: 6B
MesAreaDone:		;auto: CODE_89FCFD. SNES: end a string built in mesarea: length = a1 - mesarea, a1 = mesarea
	lda.b a1		; $89FCFD: A5 37
	sec		; $89FCFF: 38
	sbc.w #$0191		; $89FD00: E9 91 01
	sta.w mesarea		; $89FD03: 8D 91 01
	lda.w #$0191		; $89FD06: A9 91 01
	sta.b a1		; $89FD09: 85 37
	rtl		; $89FD0B: 6B
StartGame:		;auto: CODE_89FD0C (from $8B8176). 93G StartGame (hockey93_01): reset the game state (gmode, offsides option, team stats, scores, gsp), restoreteams, then on to the period start
	stz.w gmode		; $89FD0C: 9C 88 12
	lda.w OptPen		; $89FD0F: AD 0A 16
	cmp.w #1		; $89FD12: C9 01 00
	bne .go		; $89FD15: D0 06
	lda.w #gmoffs		; $89FD17: A9 20 00
	tsb.w gmode		; $89FD1A: 0C 88 12
.go:
	jsl.l ClearTeamStats		; $89FD1D: 22 6B FD 82
	stz.w ScoreSumbytes		; $89FD21: 9C FC 12
	stz.w gsp		; $89FD24: 9C F0 12
	stz.w ChkCnt		; $89FD27: 9C F8 12
	jsl.l restoreteams		; $89FD2A: 22 3A FD 89
	jsl.l $8F902A		; $89FD2E: 22 2A 90 8F  bank $8F: 93G InitScores
	jsl.l UpdateScores		; $89FD32: 22 D1 F9 82
	jml.l $8D8217		; $89FD36: 5C 17 82 8D  bank $8D: on to the period start
restoreteams:		;auto: CODE_89FD3A. 93G restoreteams (hockey93_01): both rosters to the bench: tmap 6, every tmpdst -2
	stz.b a2		; $89FD3A: 64 3B
	jsl.l .r		; $89FD3C: 22 45 FD 89
	lda.w #$0002		; $89FD40: A9 02 00
	sta.b a2		; $89FD43: 85 3B
.r:		;93G .r: one team (a2)
	ldy.b a2		; $89FD45: A4 3B
	lda.w #6		; $89FD47: A9 06 00
	sta.w tmap,y		; $89FD4A: 99 EE 13
	lda.w #$32		; $89FD4D: A9 32 00
	sta.b d0		; $89FD50: 85 53
.pl:
	lda.b a2		; $89FD52: A5 3B
	beq .home		; $89FD54: F0 03
	lda.w #$34		; $89FD56: A9 34 00
.home:
	clc		; $89FD59: 18
	adc.b d0		; $89FD5A: 65 53
	tay		; $89FD5C: A8
	lda.w #TMPDBENCH		; $89FD5D: A9 FE FF
	sta.w tmpdst,y		; $89FD60: 99 E2 14
	dec.b d0		; $89FD63: C6 53
	dec.b d0		; $89FD65: C6 53
	bpl .pl		; $89FD67: 10 E9
	rtl		; $89FD69: 6B
EvadePC:		;auto: CODE_89FD6A (skateto avoidance routine). 93G EvadePC (logic93_3, the 92G form): within 40 of the puck carrier (after one frame of both velocities) d0 = direction away from him
	lda.w puckc		; $89FD6A: AD BB 0E
	bmi .rtl		; $89FD6D: 30 66
	lda.w Xvel+1,x		; $89FD6F: BD E0 0A
	sec		; $89FD72: 38
	sbc.w puckvx+1		; $89FD73: ED FC 0A
	and.w #$00FF		; $89FD76: 29 FF 00
	bit.w #$0080		; $89FD79: 89 80 00
	beq .xs		; $89FD7C: F0 03
	ora.w #$FF00		; $89FD7E: 09 00 FF
.xs:
	clc		; $89FD81: 18
	adc.w Xpos,x		; $89FD82: 7D FF 08
	sec		; $89FD85: 38
	sbc.w puckx		; $89FD86: ED 1B 09
	bit.w #$8000		; $89FD89: 89 00 80
	beq .xa		; $89FD8C: F0 04
	eor.w #$FFFF		; $89FD8E: 49 FF FF
	inc a		; $89FD91: 1A
.xa:
	cmp.w #41		; $89FD92: C9 29 00
	bcs .rtl		; $89FD95: B0 3E
	lda.w Yvel+1,x		; $89FD97: BD 00 0B
	sec		; $89FD9A: 38
	sbc.w puckvy+1		; $89FD9B: ED 1C 0B
	and.w #$00FF		; $89FD9E: 29 FF 00
	bit.w #$0080		; $89FDA1: 89 80 00
	beq .ys		; $89FDA4: F0 03
	ora.w #$FF00		; $89FDA6: 09 00 FF
.ys:
	clc		; $89FDA9: 18
	adc.w Ypos,x		; $89FDAA: 7D 5F 09
	sec		; $89FDAD: 38
	sbc.w pucky		; $89FDAE: ED 7B 09
	bit.w #$8000		; $89FDB1: 89 00 80
	beq .ya		; $89FDB4: F0 04
	eor.w #$FFFF		; $89FDB6: 49 FF FF
	inc a		; $89FDB9: 1A
.ya:
	cmp.w #41		; $89FDBA: C9 29 00
	bcs .rtl		; $89FDBD: B0 16
	lda.w Xpos,x		; $89FDBF: BD FF 08
	sec		; $89FDC2: 38
	sbc.w puckx		; $89FDC3: ED 1B 09
	sta.b d0		; $89FDC6: 85 53
	lda.w Ypos,x		; $89FDC8: BD 5F 09
	sec		; $89FDCB: 38
	sbc.w pucky		; $89FDCC: ED 7B 09
	sta.b d1		; $89FDCF: 85 57
	jml.l vtoa		; $89FDD1: 5C A8 AF 80
.rtl:
	rtl		; $89FDD5: 6B
asswingd:		;auto: CODE_89FDD6 (asstab 3). 93G asswingd (logic93_2): wing on defence: cover his side between the puck and the goal; awingo when the team gets the puck
	lda.w pfalock,x		; $89FDD6: BD 7F 11
	beq .go		; $89FDD9: F0 03
	jmp.w .rtl		; $89FDDB: 4C 93 FE
.go:
	lda.w gmclock		; $89FDDE: AD 8A 12
	beq .gm		; $89FDE1: F0 04
	jml.l $8FD75A		; $89FDE3: 5C 5A D7 8F  bank $8F: assnothing
.gm:
	jsl.l check4bench		; $89FDE7: 22 27 85 80
	lda.w pflags,x		; $89FDEB: BD DF 0E
	bit.w #$0008		; $89FDEE: 89 08 00
	beq .chk		; $89FDF1: F0 03
	jmp.w .rtl		; $89FDF3: 4C 93 FE
.chk:
	bit.w #$0002		; $89FDF6: 89 02 00
	beq .nna		; $89FDF9: F0 12
	and.w #$FFFD		; $89FDFB: 29 FD FF
	sta.w pflags,x		; $89FDFE: 9D DF 0E
	stz.w temp1,x		; $89FE01: 9E 5F 0C
	stz.w temp2,x		; $89FE04: 9E 7F 0C
	lda.w #8		; $89FE07: A9 08 00
	sta.w temp2b,x		; $89FE0A: 9D FF 0C
.nna:
	lda.w temp1,x		; $89FE0D: BD 5F 0C
	sec		; $89FE10: 38
	sbc.b d7		; $89FE11: E5 6F
	sta.w temp1,x		; $89FE13: 9D 5F 0C
	bpl .nodec		; $89FE16: 10 2C
	clc		; $89FE18: 18
	adc.w aidef,x		; $89FE19: 7D BF 0F
	bpl .t1		; $89FE1C: 10 03
	lda.w #$0000		; $89FE1E: A9 00 00
.t1:
	sta.w temp1,x		; $89FE21: 9D 5F 0C
	lda.w puckc		; $89FE24: AD BB 0E
	bmi .nodec		; $89FE27: 30 1B
	sec		; $89FE29: 38
	sbc.w #6		; $89FE2A: E9 06 00
	sta.b d1		; $89FE2D: 85 57
	lda.w #4		; $89FE2F: A9 04 00
	sta.b d0		; $89FE32: 85 53
	txa		; $89FE34: 8A
	lsr a		; $89FE35: 4A
	sec		; $89FE36: 38
	sbc.w #6		; $89FE37: E9 06 00
	eor.b d1		; $89FE3A: 45 57
	sta.b d1		; $89FE3C: 85 57
	bmi .nodec		; $89FE3E: 30 04
	jml.l assreplace		; $89FE40: 5C A7 B4 80
.nodec:
	lda.w #100		; $89FE44: A9 64 00
	sta.b d0		; $89FE47: 85 53
	lda.w position,x		; $89FE49: BD 9F 0B
	cmp.w #5		; $89FE4C: C9 05 00
	bne .zero		; $89FE4F: D0 05
	lda.w #-100		; $89FE51: A9 9C FF
	sta.b d0		; $89FE54: 85 53
.zero:		;93G .0
	lda.w #158		; $89FE56: A9 9E 00
	sta.b d1		; $89FE59: 85 57
	lda.w pfgoal,x		; $89FE5B: BD 3F 11
	beq .up		; $89FE5E: F0 47
	lda.b d0		; $89FE60: A5 53
	eor.w #$FFFF		; $89FE62: 49 FF FF
	inc a		; $89FE65: 1A
	sta.b d0		; $89FE66: 85 53
	lda.w #-158		; $89FE68: A9 62 FF
	sta.b d1		; $89FE6B: 85 57
	lda.w #-78		; $89FE6D: A9 B2 FF
	sta.b d2		; $89FE70: 85 5B
	ldy.b a2		; $89FE72: A4 3B
	lda.w tmflags,y		; $89FE74: B9 0A 14
	bit.w #tmfoffside		; $89FE77: 89 10 00
	bne .set		; $89FE7A: D0 62
	lda.b d2		; $89FE7C: A5 5B
	sec		; $89FE7E: 38
	sbc.w pucky		; $89FE7F: ED 7B 09
	beq .hi0		; $89FE82: F0 08
	bmi .lt		; $89FE84: 30 04
	bvs .hi0		; $89FE86: 70 04
	bra .lo		; $89FE88: 80 0A
.lt:
	bvs .lo		; $89FE8A: 70 08
.hi0:
	lda.w pucky		; $89FE8C: AD 7B 09
	sta.b d1		; $89FE8F: 85 57
	bra .go2		; $89FE91: 80 4F
.rtl:
	rtl		; $89FE93: 6B
.lo:
	lda.w #-264		; $89FE94: A9 F8 FE
	sta.b d2		; $89FE97: 85 5B
	sec		; $89FE99: 38
	sbc.w pucky		; $89FE9A: ED 7B 09
	bmi .lt2		; $89FE9D: 30 04
	bvc .set1		; $89FE9F: 50 04
	bra .go2		; $89FEA1: 80 3F
.lt2:
	bvc .go2		; $89FEA3: 50 3D
.set1:
	bra .set		; $89FEA5: 80 37
.up:
	lda.w #78		; $89FEA7: A9 4E 00
	sta.b d2		; $89FEAA: 85 5B
	ldy.b a2		; $89FEAC: A4 3B
	lda.w tmflags,y		; $89FEAE: B9 0A 14
	bit.w #tmfoffside		; $89FEB1: 89 10 00
	bne .set		; $89FEB4: D0 28
	lda.b d2		; $89FEB6: A5 5B
	sec		; $89FEB8: 38
	sbc.w pucky		; $89FEB9: ED 7B 09
	bmi .lt3		; $89FEBC: 30 04
	bvc .up0		; $89FEBE: 50 04
	bra .hi		; $89FEC0: 80 09
.lt3:
	bvc .hi		; $89FEC2: 50 07
.up0:
	lda.w pucky		; $89FEC4: AD 7B 09
	sta.b d1		; $89FEC7: 85 57
	bra .go2		; $89FEC9: 80 17
.hi:
	lda.w #264		; $89FECB: A9 08 01
	sta.b d2		; $89FECE: 85 5B
	sec		; $89FED0: 38
	sbc.w pucky		; $89FED1: ED 7B 09
	beq .set		; $89FED4: F0 08
	bmi .lt4		; $89FED6: 30 04
	bvs .set		; $89FED8: 70 04
	bra .go2		; $89FEDA: 80 06
.lt4:
	bvs .go2		; $89FEDC: 70 04
.set:
	lda.b d2		; $89FEDE: A5 5B
	sta.b d1		; $89FEE0: 85 57
.go2:		;93G .go
	lda.w #rtss		; $89FEE2: A9 E6 84
	sta.b a0		; $89FEE5: 85 33
	lda.w #rtss>>16		; $89FEE7: A9 80 00
	sta.b a0+2		; $89FEEA: 85 35
	lda.w puckx		; $89FEEC: AD 1B 09
	eor.b d0		; $89FEEF: 45 53
	sta.b d2		; $89FEF1: 85 5B
	bmi .skate		; $89FEF3: 30 05
	lda.w puckx		; $89FEF5: AD 1B 09
	sta.b d0		; $89FEF8: 85 53
.skate:
	jml.l skateto		; $89FEFA: 5C D0 FD 88
unusedFF89:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FEFE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF0E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF1E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF2E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF3E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF4E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF5E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF6E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF7E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF8E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FF9E
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FFAE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FFBE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FFCE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FFDE
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $89FFEE
	db $FF,$FF		; $89FFFE
