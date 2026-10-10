; $86F000-$86FFFF  ROM $37000-$37FFF: the last BootSamples and the end block of BootSoundUpload, then DecompressGraphics, UpdateLineChange,
; the song starters, setteams, ProcessInputWithRepeat, GetPeriodTimeRemaining, GetPeriodTime, lcfound2, PickStartingGoalie,
; assscore (logic93_2), $FF fill.
org $86F000
	incbin "../data/bootsamples.brr":$4837..$5271		; $86F000-$86FA39
BootSamplesEnd:
	assert BootSamplesEnd-BootSamples == BOOTSAMPLESIZE
	dw $0000, SPCDRIVER		; $86FA3A end block: length 0, start the driver at $0400
DecompressGraphics:		;auto: CODE_86FA3E. SNES: unpack the stream at [tmp0] to $7F0000 (output pointer tmp1+1..+3, copy distance tmp2+2). Control byte: $00-$1F copy n+1 bytes; $2x n+1 zeros; $3x n+3
		;   times the next byte; $40-$7F, $8x, $9x, $Ax, $Bx copy from earlier output going up; $C0-$DF, $Ex, $Fx going down; $E0 $00 ends
	stz.b tmp1+1		; $86FA3E: 64 76
	lda.w #TestList>>16		; $86FA40: A9 7F 00
	sta.b tmp1+3		; $86FA43: 85 78
.next:
	lda.b [tmp0]		; $86FA45: A7 73
	inc.b tmp0		; $86FA47: E6 73
	bit.w #$00E0		; $86FA49: 89 E0 00
	bne .c20		; $86FA4C: D0 11
	and.w #$001F		; $86FA4E: 29 1F 00
	tax		; $86FA51: AA
.lit:
	lda.b [tmp0]		; $86FA52: A7 73
	inc.b tmp0		; $86FA54: E6 73
	sta.b [tmp1+1]		; $86FA56: 87 76
	inc.b tmp1+1		; $86FA58: E6 76
	dex		; $86FA5A: CA
	bpl .lit		; $86FA5B: 10 F5
	bra .next		; $86FA5D: 80 E6
.c20:
	tay		; $86FA5F: A8
	and.w #$00F0		; $86FA60: 29 F0 00
	cmp.w #$0020		; $86FA63: C9 20 00
	bne .c30		; $86FA66: D0 11
	tya		; $86FA68: 98
	and.w #$000F		; $86FA69: 29 0F 00
	tax		; $86FA6C: AA
	lda.w #$0000		; $86FA6D: A9 00 00
.zero:
	sta.b [tmp1+1]		; $86FA70: 87 76
	inc.b tmp1+1		; $86FA72: E6 76
	dex		; $86FA74: CA
	bpl .zero		; $86FA75: 10 F9
	bra .next		; $86FA77: 80 CC
.c30:
	cmp.w #$0030		; $86FA79: C9 30 00
	bne .c40		; $86FA7C: D0 14
	tya		; $86FA7E: 98
	and.w #$000F		; $86FA7F: 29 0F 00
	tax		; $86FA82: AA
	inx		; $86FA83: E8
	inx		; $86FA84: E8
	lda.b [tmp0]		; $86FA85: A7 73
	inc.b tmp0		; $86FA87: E6 73
.fill:
	sta.b [tmp1+1]		; $86FA89: 87 76
	inc.b tmp1+1		; $86FA8B: E6 76
	dex		; $86FA8D: CA
	bpl .fill		; $86FA8E: 10 F9
	bra .next		; $86FA90: 80 B3
.c40:		;$40-$7F: distance bits 3-5 + 1, length bits 0-2 + 2
	and.w #$00C0		; $86FA92: 29 C0 00
	cmp.w #$0040		; $86FA95: C9 40 00
	bne .c80		; $86FA98: D0 25
	tya		; $86FA9A: 98
	lsr a		; $86FA9B: 4A
	lsr a		; $86FA9C: 4A
	lsr a		; $86FA9D: 4A
	and.w #$0007		; $86FA9E: 29 07 00
	inc a		; $86FAA1: 1A
	sta.b tmp2+2		; $86FAA2: 85 79
	tya		; $86FAA4: 98
	and.w #$0007		; $86FAA5: 29 07 00
	inc a		; $86FAA8: 1A
	inc a		; $86FAA9: 1A
	tay		; $86FAAA: A8
.up:		;copy Y bytes from output - distance, going up
	lda.b tmp1+1		; $86FAAB: A5 76
	sec		; $86FAAD: 38
	sbc.b tmp2+2		; $86FAAE: E5 79
	tax		; $86FAB0: AA
.upl:
	lda.l TestList,x		; $86FAB1: BF 00 00 7F
	inx		; $86FAB5: E8
	sta.b [tmp1+1]		; $86FAB6: 87 76
	inc.b tmp1+1		; $86FAB8: E6 76
	dey		; $86FABA: 88
	bne .upl		; $86FABB: D0 F4
	bra .next		; $86FABD: 80 86
.c80:		;$8x: length n+3, distance = next byte
	tya		; $86FABF: 98
	and.w #$00F0		; $86FAC0: 29 F0 00
	cmp.w #$0080		; $86FAC3: C9 80 00
	bne .c90		; $86FAC6: D0 13
	tya		; $86FAC8: 98
	and.w #$000F		; $86FAC9: 29 0F 00
	inc a		; $86FACC: 1A
	inc a		; $86FACD: 1A
	inc a		; $86FACE: 1A
	tay		; $86FACF: A8
	lda.b [tmp0]		; $86FAD0: A7 73
	inc.b tmp0		; $86FAD2: E6 73
	and.w #$00FF		; $86FAD4: 29 FF 00
	sta.b tmp2+2		; $86FAD7: 85 79
	bra .up		; $86FAD9: 80 D0
.c90:		;$9x: distance 7 bits, length 5 bits
	cmp.w #$0090		; $86FADB: C9 90 00
	bne .cA0		; $86FADE: D0 17
	lda.b [tmp0]		; $86FAE0: A7 73
	inc.b tmp0		; $86FAE2: E6 73
	and.w #$007F		; $86FAE4: 29 7F 00
	inc a		; $86FAE7: 1A
	sta.b tmp2+2		; $86FAE8: 85 79
	tya		; $86FAEA: 98
	xba		; $86FAEB: EB
	asl a		; $86FAEC: 0A
	xba		; $86FAED: EB
	and.w #$001F		; $86FAEE: 29 1F 00
	inc a		; $86FAF1: 1A
	inc a		; $86FAF2: 1A
	inc a		; $86FAF3: 1A
	tay		; $86FAF4: A8
	bra .up		; $86FAF5: 80 B4
.cA0:		;$Ax: distance 6 bits, length 6 bits
	cmp.w #$00A0		; $86FAF7: C9 A0 00
	bne .cB0		; $86FAFA: D0 18
	lda.b [tmp0]		; $86FAFC: A7 73
	inc.b tmp0		; $86FAFE: E6 73
	and.w #$003F		; $86FB00: 29 3F 00
	inc a		; $86FB03: 1A
	sta.b tmp2+2		; $86FB04: 85 79
	tya		; $86FB06: 98
	xba		; $86FB07: EB
	asl a		; $86FB08: 0A
	asl a		; $86FB09: 0A
	xba		; $86FB0A: EB
	and.w #$003F		; $86FB0B: 29 3F 00
	inc a		; $86FB0E: 1A
	inc a		; $86FB0F: 1A
	inc a		; $86FB10: 1A
	tay		; $86FB11: A8
	bra .up		; $86FB12: 80 97
.cB0:		;$Bx: distance 5 bits, length 7 bits
	cmp.w #$00B0		; $86FB14: C9 B0 00
	bne .cC0		; $86FB17: D0 1A
	lda.b [tmp0]		; $86FB19: A7 73
	inc.b tmp0		; $86FB1B: E6 73
	and.w #$001F		; $86FB1D: 29 1F 00
	inc a		; $86FB20: 1A
	sta.b tmp2+2		; $86FB21: 85 79
	tya		; $86FB23: 98
	xba		; $86FB24: EB
	asl a		; $86FB25: 0A
	asl a		; $86FB26: 0A
	asl a		; $86FB27: 0A
	xba		; $86FB28: EB
	and.w #$007F		; $86FB29: 29 7F 00
	inc a		; $86FB2C: 1A
	inc a		; $86FB2D: 1A
	inc a		; $86FB2E: 1A
	tay		; $86FB2F: A8
	jmp.w .up		; $86FB30: 4C AB FA
.cC0:		;$C0-$DF: going down
	and.w #$00E0		; $86FB33: 29 E0 00
	cmp.w #$00C0		; $86FB36: C9 C0 00
	bne .cE0		; $86FB39: D0 25
	tya		; $86FB3B: 98
	lsr a		; $86FB3C: 4A
	lsr a		; $86FB3D: 4A
	and.w #$0007		; $86FB3E: 29 07 00
	inc a		; $86FB41: 1A
	sta.b tmp2+2		; $86FB42: 85 79
	tya		; $86FB44: 98
	and.w #$0003		; $86FB45: 29 03 00
	inc a		; $86FB48: 1A
	inc a		; $86FB49: 1A
	tay		; $86FB4A: A8
.down:		;copy Y bytes going down from output - distance
	lda.b tmp1+1		; $86FB4B: A5 76
	sec		; $86FB4D: 38
	sbc.b tmp2+2		; $86FB4E: E5 79
	tax		; $86FB50: AA
.dnl:
	lda.l TestList,x		; $86FB51: BF 00 00 7F
	dex		; $86FB55: CA
	sta.b [tmp1+1]		; $86FB56: 87 76
	inc.b tmp1+1		; $86FB58: E6 76
	dey		; $86FB5A: 88
	bne .dnl		; $86FB5B: D0 F4
	jmp.w .next		; $86FB5D: 4C 45 FA
.cE0:		;$Ex: length n+3, distance = next byte (0 = end)
	tya		; $86FB60: 98
	and.w #$00F0		; $86FB61: 29 F0 00
	cmp.w #$00E0		; $86FB64: C9 E0 00
	bne .cF0		; $86FB67: D0 15
	tya		; $86FB69: 98
	and.w #$000F		; $86FB6A: 29 0F 00
	inc a		; $86FB6D: 1A
	inc a		; $86FB6E: 1A
	inc a		; $86FB6F: 1A
	tay		; $86FB70: A8
	lda.b [tmp0]		; $86FB71: A7 73
	inc.b tmp0		; $86FB73: E6 73
	and.w #$00FF		; $86FB75: 29 FF 00
	beq .end		; $86FB78: F0 1B
	sta.b tmp2+2		; $86FB7A: 85 79
	bra .down		; $86FB7C: 80 CD
.cF0:		;$Fx: going down, distance 7 bits, length 5 bits
	lda.b [tmp0]		; $86FB7E: A7 73
	inc.b tmp0		; $86FB80: E6 73
	and.w #$007F		; $86FB82: 29 7F 00
	inc a		; $86FB85: 1A
	sta.b tmp2+2		; $86FB86: 85 79
	tya		; $86FB88: 98
	xba		; $86FB89: EB
	asl a		; $86FB8A: 0A
	xba		; $86FB8B: EB
	and.w #$001F		; $86FB8C: 29 1F 00
	inc a		; $86FB8F: 1A
	inc a		; $86FB90: 1A
	inc a		; $86FB91: 1A
	tay		; $86FB92: A8
	bra .down		; $86FB93: 80 B6
.end:
	rtl		; $86FB95: 6B
UpdateLineChange:		;auto: CODE_86FB96. 93G UpdateLineChange (hockey93_01): once a second with line changes on, players on the bench (TMPDBENCH) regain 10 energy up to $1000, both teams
	lda.w OptLine		; $86FB96: AD 0C 16
	bne .rtl		; $86FB99: D0 45
	stz.b a2		; $86FB9B: 64 3B
	jsl.l .tm		; $86FB9D: 22 A6 FB 86
	lda.w #$0002		; $86FBA1: A9 02 00
	sta.b a2		; $86FBA4: 85 3B
.tm:
	lda.w #$0032		; $86FBA6: A9 32 00
	sta.b d0		; $86FBA9: 85 53
.pl:
	lda.b a2		; $86FBAB: A5 3B
	beq .p2		; $86FBAD: F0 03
	lda.w #$0034		; $86FBAF: A9 34 00
.p2:
	clc		; $86FBB2: 18
	adc.b d0		; $86FBB3: 65 53
	tay		; $86FBB5: A8
	lda.w tmpdst,y		; $86FBB6: B9 E2 14
	cmp.w #TMPDBENCH		; $86FBB9: C9 FE FF
	bne .next		; $86FBBC: D0 1C
	lda.w tmpde,y		; $86FBBE: B9 7A 14
	clc		; $86FBC1: 18
	adc.w #10		; $86FBC2: 69 0A 00
	sta.w tmpde,y		; $86FBC5: 99 7A 14
	sec		; $86FBC8: 38
	sbc.w #$1000		; $86FBC9: E9 00 10
	bmi .v1		; $86FBCC: 30 04
	bvc .max		; $86FBCE: 50 04
	bra .next		; $86FBD0: 80 08
.v1:
	bvc .next		; $86FBD2: 50 06
.max:
	lda.w #$1000		; $86FBD4: A9 00 10
	sta.w tmpde,y		; $86FBD7: 99 7A 14
.next:
	dec.b d0		; $86FBDA: C6 53
	dec.b d0		; $86FBDC: C6 53
	bpl .pl		; $86FBDE: 10 CB
.rtl:
	rtl		; $86FBE0: 6B
StartSong6:		;auto: CODE_86FBE1. SNES: start song 6 (the title screen music: TitleScreen $88F3A1, $8FF05C) unless it plays: the boot sound set (SPCBootUpload), then driver command 3
	lda.w cursong		; $86FBE1: AD 51 16
	cmp.w #6		; $86FBE4: C9 06 00
	beq .rtl		; $86FBE7: F0 1B
	lda.w sndbank		; $86FBE9: AD 4F 16
	cmp.w #2		; $86FBEC: C9 02 00
	beq .cmd		; $86FBEF: F0 04
	jsl.l SPCBootUpload		; $86FBF1: 22 31 FA 82
.cmd:
	sep #$20		; $86FBF5: E2 20
	lda.b #$03		; $86FBF7: A9 03
	sta.w APUIO0		; $86FBF9: 8D 40 21
	rep #$30		; $86FBFC: C2 30
	lda.w #6		; $86FBFE: A9 06 00
	sta.w cursong		; $86FC01: 8D 51 16
.rtl:
	rtl		; $86FC04: 6B
StartSong7:		;auto: CODE_86FC05. SNES: start song 7 (driver command 2); no caller found
	lda.w cursong		; $86FC05: AD 51 16
	cmp.w #7		; $86FC08: C9 07 00
	beq .rtl		; $86FC0B: F0 1B
	lda.w sndbank		; $86FC0D: AD 4F 16
	cmp.w #2		; $86FC10: C9 02 00
	beq .cmd		; $86FC13: F0 04
	jsl.l SPCBootUpload		; $86FC15: 22 31 FA 82
.cmd:
	sep #$20		; $86FC19: E2 20
	lda.b #$02		; $86FC1B: A9 02
	sta.w APUIO0		; $86FC1D: 8D 40 21
	rep #$30		; $86FC20: C2 30
	lda.w #7		; $86FC22: A9 07 00
	sta.w cursong		; $86FC25: 8D 51 16
.rtl:
	rtl		; $86FC28: 6B
setteams:		;auto: CODE_86FC29. 93G setteams (hockey93_06) with InitTeamSructure: use HomeTeam/VisTeam to set the team structs (tmsort, tmteam, tmdata from TeamList). Falls in from ClearTeamStats
	stz.w tmsort		; $86FC29: 9C D2 13
	lda.w #$000C		; $86FC2C: A9 0C 00
	sta.w tmsort+2		; $86FC2F: 8D D4 13
	lda.w HomeTeam		; $86FC32: AD 9A 12
	sta.w tmteam		; $86FC35: 8D F6 13
	asl a		; $86FC38: 0A
	asl a		; $86FC39: 0A
	tax		; $86FC3A: AA
	lda.l TeamList,x		; $86FC3B: BF 00 80 83
	sta.w tmdata		; $86FC3F: 8D CE 13
	lda.w VisTeam		; $86FC42: AD 9C 12
	sta.w tmteam+2		; $86FC45: 8D F8 13
	asl a		; $86FC48: 0A
	asl a		; $86FC49: 0A
	tax		; $86FC4A: AA
	lda.l TeamList,x		; $86FC4B: BF 00 80 83
	sta.w tmdata+2		; $86FC4F: 8D D0 13
	rtl		; $86FC52: 6B
ProcessInputWithRepeat:		;auto: CODE_86FC53. 93G ProcessInputWithRepeat (middle93_1): nodiag (nullrtl85), then key repeat: a change (d2) resets the delay to 15 frames; while the same buttons stay
		;   held, every 4 frames d1 = held buttons (d3)
	jsl.l nullrtl85		; $86FC53: 22 96 FF 85
	lda.b d3		; $86FC57: A5 5F
	beq .rtl		; $86FC59: F0 13
	lda.b d2		; $86FC5B: A5 5B
	bne .chg		; $86FC5D: D0 10
	dec.w repeatdelay		; $86FC5F: CE 99 04
	bpl .rtl		; $86FC62: 10 0A
	lda.w #4		; $86FC64: A9 04 00
	sta.w repeatdelay		; $86FC67: 8D 99 04
	lda.b d3		; $86FC6A: A5 5F
	sta.b d1		; $86FC6C: 85 57
.rtl:
	rtl		; $86FC6E: 6B
.chg:
	lda.w #15		; $86FC6F: A9 0F 00
	sta.w repeatdelay		; $86FC72: 8D 99 04
	rtl		; $86FC75: 6B
ScoutNamePos:		;auto: CODE_86FC76. SNES: print position of a showcased player name: x 1, y 10; the home team (a2 = 0) at x 20
	jsl.l printz		; $86FC76: 22 0C B9 80
	dw $0005		; $86FC7A  printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$0A
	lda.b a2		; $86FC7F: A5 3B
	bne .rtl		; $86FC81: D0 06
	lda.w #20		; $86FC83: A9 14 00
	sta.w printx		; $86FC86: 8D 7B 04
.rtl:
	rtl		; $86FC89: 6B
GetPeriodTimeRemaining:		;auto: CODE_86FC8A. 93G GetPeriodTimeRemaining (hockey93_04): d0 = (gsp << 14 | PerTimeTotal) - gameclock (Goal and InProgress log it)
	lda.w gsp		; $86FC8A: AD F0 12
	xba		; $86FC8D: EB
	and.w #$FF00		; $86FC8E: 29 00 FF
	asl a		; $86FC91: 0A
	asl a		; $86FC92: 0A
	asl a		; $86FC93: 0A
	asl a		; $86FC94: 0A
	asl a		; $86FC95: 0A
	asl a		; $86FC96: 0A
	ora.w PerTimeTotal		; $86FC97: 0D F6 12
	sec		; $86FC9A: 38
	sbc.w gameclock		; $86FC9B: ED F2 12
	sta.b d0		; $86FC9E: 85 53
	rtl		; $86FCA0: 6B
GetPeriodTime:		;auto: CODE_86FCA1. 93G GetPeriodTime (hockey93_01): d0 = period length in seconds for OptPerlen
	phx		; $86FCA1: DA
	lda.w OptPerlen		; $86FCA2: AD 08 16
	asl a		; $86FCA5: 0A
	tax		; $86FCA6: AA
	lda.l GetPeriodTime_timetab,x		; $86FCA7: BF AF FC 86
	sta.b d0		; $86FCAB: 85 53
	plx		; $86FCAD: FA
	rtl		; $86FCAE: 6B
GetPeriodTime_timetab:		;93G .timetab (IDA PeriodTimeTable): 5, 10, 20 minutes, 30 seconds
	dw 5*60,10*60,20*60,30		; $86FCAF
lcfound2:		;auto: CODE_86FCB7. 93G lcfound2 (logic93_1): close the line change box (setlccords; the lower box clears sf3llcs), erase it unless the faceoff box is up, then printscores1
	jsl.l setlccords		; $86FCB7: 22 91 F3 80
	lda.w printy		; $86FCBB: AD 7D 04
	sec		; $86FCBE: 38
	sbc.w #15		; $86FCBF: E9 0F 00
	bmi .v1		; $86FCC2: 30 04
	bvc .low		; $86FCC4: 50 04
	bra .nollcm		; $86FCC6: 80 08
.v1:
	bvc .nollcm		; $86FCC8: 50 06
.low:
	lda.w #sf3llcs		; $86FCCA: A9 01 00
	trb.w sflags3		; $86FCCD: 1C 90 12
.nollcm:
	inc.b d1		; $86FCD0: E6 57
	lda.w blankchar		; $86FCD2: AD E7 1B
	sta.b d2		; $86FCD5: 85 5B
	lda.b fobox		; $86FCD7: A5 F4
	bne .ps		; $86FCD9: D0 04
	jsl.l $8D847C		; $86FCDB: 22 7C 84 8D  bank $8D: 92G eraser
.ps:
	jml.l printscores1		; $86FCDF: 5C 5D E9 89  bank $89: 93G printscores1
PickStartingGoalie:		;auto: CODE_86FCE3. SNES: tmgoalie of team a2 = 0 ($8B807D); a computer team in the later playoff rounds (gamelevel >= 2, line changes on) picks the goalie by its scouting
		;   report ($8FF4D8, $8FE3B0)
	stx.b xsave		; $86FCE3: 86 0A
	ldx.w #$0000		; $86FCE5: A2 00 00
.pushd:
	lda.b d0,x		; $86FCE8: B5 53
	pha		; $86FCEA: 48
	inx		; $86FCEB: E8
	inx		; $86FCEC: E8
	cpx.w #$0004		; $86FCED: E0 04 00
	bne .pushd		; $86FCF0: D0 F6
	ldx.b xsave		; $86FCF2: A6 0A
	stx.b xsave		; $86FCF4: 86 0A
	ldx.w #$0000		; $86FCF6: A2 00 00
.pusha:
	lda.b a0,x		; $86FCF9: B5 33
	pha		; $86FCFB: 48
	inx		; $86FCFC: E8
	inx		; $86FCFD: E8
	cpx.w #$0004		; $86FCFE: E0 04 00
	bne .pusha		; $86FD01: D0 F6
	ldx.b xsave		; $86FD03: A6 0A
	ldy.b a2		; $86FD05: A4 3B
	lda.w #$0000		; $86FD07: A9 00 00
	sta.w tmgoalie,y		; $86FD0A: 99 F2 13
	jsl.l $8B807D		; $86FD0D: 22 7D 80 8B  bank $8B
	lda.b a2		; $86FD11: A5 3B
	tay		; $86FD13: A8
	lsr a		; $86FD14: 4A
	inc a		; $86FD15: 1A
	sta.b d0		; $86FD16: 85 53
	cmp.w cont1team		; $86FD18: CD 96 12
	beq .ex		; $86FD1B: F0 4C
	cmp.w cont2team		; $86FD1D: CD 98 12
	beq .ex		; $86FD20: F0 47
	stz.b d0		; $86FD22: 64 53
	lda.w gamelevel		; $86FD24: AD 4A 01
	sec		; $86FD27: 38
	sbc.w #$0002		; $86FD28: E9 02 00
	beq .po		; $86FD2B: F0 08
	bmi .v1		; $86FD2D: 30 04
	bvs .po		; $86FD2F: 70 04
	bra .set		; $86FD31: 80 2F
.v1:
	bvs .set		; $86FD33: 70 2D
.po:
	lda.w OptLine		; $86FD35: AD 0C 16
	bne .set		; $86FD38: D0 28
	lda.w #TeamList		; $86FD3A: A9 00 80
	sta.b a0		; $86FD3D: 85 33
	lda.w #TeamList>>16		; $86FD3F: A9 83 00
	sta.b a0+2		; $86FD42: 85 35
	lda.w tmshots,y		; $86FD44: B9 B2 13
	asl a		; $86FD47: 0A
	asl a		; $86FD48: 0A
	tay		; $86FD49: A8
	lda.b [a0],y		; $86FD4A: B7 33
	sta.b a0		; $86FD4C: 85 33
	ldy.w #ScoreOdds		; $86FD4E: A0 0A 00
	adc.b [a0],y		; $86FD51: 77 33
	sta.b a0		; $86FD53: 85 33
	lda.w #$0004		; $86FD55: A9 04 00
	sta.b d0		; $86FD58: 85 53
	jsl.l $8FF4D8		; $86FD5A: 22 D8 F4 8F  bank $8F
	jsl.l $8FE3B0		; $86FD5E: 22 B0 E3 8F  bank $8F
.set:
	ldy.b a2		; $86FD62: A4 3B
	lda.b d0		; $86FD64: A5 53
	sta.w tmgoalie,y		; $86FD66: 99 F2 13
.ex:
	stx.b xsave		; $86FD69: 86 0A
	ldx.w #$0002		; $86FD6B: A2 02 00
.popa:
	pla		; $86FD6E: 68
	sta.b a0,x		; $86FD6F: 95 33
	dex		; $86FD71: CA
	dex		; $86FD72: CA
	bpl .popa		; $86FD73: 10 F9
	ldx.b xsave		; $86FD75: A6 0A
	stx.b xsave		; $86FD77: 86 0A
	ldx.w #$0002		; $86FD79: A2 02 00
.popd:
	pla		; $86FD7C: 68
	sta.b d0,x		; $86FD7D: 95 53
	dex		; $86FD7F: CA
	dex		; $86FD80: CA
	bpl .popd		; $86FD81: 10 F9
	ldx.b xsave		; $86FD83: A6 0A
	rtl		; $86FD85: 6B
assscore:		;auto: CODE_86FD86 (asstab 7). 93G assscore (logic93_2): player X celebrates, the scorer pumps his arm. SNES: velocities * 3/4 each frame, the carrier drops the puck (nopuck 1800)
	lda.w Xvel,x		; $86FD86: BD DF 0A
	sta.b mula		; $86FD89: 85 7D
	lda.w #$00C0		; $86FD8B: A9 C0 00
	sta.b mulb		; $86FD8E: 85 83
	jsl.l muls32		; $86FD90: 22 DB FC 82
	lda.b mulres+1		; $86FD94: A5 94
	sta.w Xvel,x		; $86FD96: 9D DF 0A
	lda.w Yvel,x		; $86FD99: BD FF 0A
	sta.b mula		; $86FD9C: 85 7D
	lda.w #$00C0		; $86FD9E: A9 C0 00
	sta.b mulb		; $86FDA1: 85 83
	jsl.l muls32		; $86FDA3: 22 DB FC 82
	lda.b mulres+1		; $86FDA7: A5 94
	sta.w Yvel,x		; $86FDA9: 9D FF 0A
	txa		; $86FDAC: 8A
	lsr a		; $86FDAD: 4A
	cmp.w puckc		; $86FDAE: CD BB 0E
	bne .al		; $86FDB1: D0 0C
	lda.w #$FFFF		; $86FDB3: A9 FF FF
	sta.w puckc		; $86FDB6: 8D BB 0E
	lda.w #1800		; $86FDB9: A9 08 07
	sta.w nopuck,x		; $86FDBC: 9D 5F 0E
.al:
	lda.w pfalock,x		; $86FDBF: BD 7F 11
	bne .rtl		; $86FDC2: D0 73
	lda.w pflags,x		; $86FDC4: BD DF 0E
	bit.w #pfna		; $86FDC7: 89 02 00
	beq .nna		; $86FDCA: F0 2A
	and.w #~pfna&$FFFF		; $86FDCC: 29 FD FF
	sta.w pflags,x		; $86FDCF: 9D DF 0E
	jsl.l .one		; $86FDD2: 22 2D FE 86
	stz.w temp2,x		; $86FDD6: 9E 7F 0C
	lda.w #$0008		; $86FDD9: A9 08 00
	sta.w temp2b,x		; $86FDDC: 9D FF 0C
	lda.w #90		; $86FDDF: A9 5A 00
	sta.w temp3,x		; $86FDE2: 9D 9F 0C
	lda.w Hpos		; $86FDE5: AD 54 01
	bpl .zero		; $86FDE8: 10 06
	lda.w #-90		; $86FDEA: A9 A6 FF
	sta.w temp3,x		; $86FDED: 9D 9F 0C
.zero:		;93G .0
	lda.w Vpos		; $86FDF0: AD DF 08
	sta.w temp4,x		; $86FDF3: 9D BF 0C
.nna:
	lda.w #rtss		; $86FDF6: A9 E6 84
	sta.b a0		; $86FDF9: 85 33
	lda.w #rtss>>16		; $86FDFB: A9 80 00
	sta.b a0+2		; $86FDFE: 85 35
	lda.w temp3,x		; $86FE00: BD 9F 0C
	sta.b d0		; $86FE03: 85 53
	lda.w temp4,x		; $86FE05: BD BF 0C
	sta.b d1		; $86FE08: 85 57
	lda.w temp1,x		; $86FE0A: BD 5F 0C
	sec		; $86FE0D: 38
	sbc.b d7		; $86FE0E: E5 6F
	sta.w temp1,x		; $86FE10: 9D 5F 0C
	bpl .chkcon		; $86FE13: 10 23
	sta.w pfalock,x		; $86FE15: 9D 7F 11
	lda.w #SPAcelebrate		; $86FE18: A9 F6 0D
	sta.b d1		; $86FE1B: 85 57
	txa		; $86FE1D: 8A
	lsr a		; $86FE1E: 4A
	cmp.w shotplayer		; $86FE1F: CD A5 04
	bne .nopump		; $86FE22: D0 05
	lda.w #SPApump		; $86FE24: A9 68 0E
	sta.b d1		; $86FE27: 85 57
.nopump:
	jsl.l SetSPA		; $86FE29: 22 06 B0 80
.one:		;93G .1: temp1 = random 120
	lda.w #120		; $86FE2D: A9 78 00
	jsl.l randoma		; $86FE30: 22 8B AE 80
	sta.w temp1,x		; $86FE34: 9D 5F 0C
.rtl:
	rtl		; $86FE37: 6B
.chkcon:		;joystick controlled: stand, else skateto
	lda.w pflags,x		; $86FE38: BD DF 0E
	bit.w #pfjoycon		; $86FE3B: 89 08 00
	bne .rtl2		; $86FE3E: D0 04
	jml.l skateto		; $86FE40: 5C D0 FD 88  bank $88: 93G skateto
.rtl2:
	rtl		; $86FE44: 6B
unusedFF86:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FE45
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FE55
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FE65
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FE75
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FE85
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FE95
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FEA5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FEB5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FEC5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FED5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FEE5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FEF5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF05
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF15
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF25
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF35
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF45
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF55
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF65
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF75
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF85
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FF95
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FFA5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FFB5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FFC5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FFD5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FFE5
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $86FFF5
