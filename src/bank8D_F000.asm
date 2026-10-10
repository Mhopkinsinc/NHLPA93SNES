; $8DF00C-$8DFFFF  ROM $6F00C-$6FFFF: the rest of BigFontTiles, StartHL2 (92G penalty.asm: play the highlight of another playoff game), asspenalty
; and clrplayer (logic93_2, asstab $C), avdgoal (logic93_5), zero fill.
org $8DF00C
	incbin "../data/BigFont.chr.pak":$144..$9C0		; $8DF00C-$8DF887
BigFontTilesEnd:
	assert BigFontTilesEnd-BigFontTiles == $9C0
StartHL2:		;auto: CODE_8DF888 (from $82FCB9 with d0-d7/a0-a6 saved). 92G StartHL2: play the highlight of playoff game a0: "Highlight from game:", then 1-3 minutes of that game with its score; Start
		;   or A ends it, a tie gets a random winner
	lda.w sflags3		; $8DF888: AD 90 12  Start pressed before: no more highlights
	bit.w #sf3sbut		; $8DF88B: 89 08 00
	beq .go		; $8DF88E: F0 03
	jmp.w .nhl0		; $8DF890: 4C 0E FC
.go:
	jsl.l .sv		; $8DF893: 22 5B FC 8D  save the game state
	lda.b d1		; $8DF897: A5 57
	sta.b d3		; $8DF899: 85 5F
	jsl.l $8F887A		; $8DF89B: 22 7A 88 8F  93G NewTicker3: the score of the highlight game, bank $8F: 93G NewTicker3
	lda.w sflags3		; $8DF89F: AD 90 12
	bit.w #sf3sbut		; $8DF8A2: 89 08 00
	beq .show		; $8DF8A5: F0 03
	jmp.w .nhl1		; $8DF8A7: 4C 04 FC
.show:
	lda.w #$0004		; $8DF8AA: A9 04 00  Framer 24 x 3
	sta.w printx		; $8DF8AD: 8D 7B 04
	lda.w printy		; $8DF8B0: AD 7D 04
	sec		; $8DF8B3: 38
	sbc.w #$0006		; $8DF8B4: E9 06 00
	sta.w printy		; $8DF8B7: 8D 7D 04
	lda.w #24		; $8DF8BA: A9 18 00
	sta.b d0		; $8DF8BD: 85 53
	lda.w #3		; $8DF8BF: A9 03 00
	sta.b d1		; $8DF8C2: 85 57
	jsl.l $8FD69F		; $8DF8C4: 22 9F D6 8F  bank $8F: 93G Framer (d0 x d1)
	inc.w printx		; $8DF8C8: EE 7B 04
	dec.w printy		; $8DF8CB: CE 7D 04
	dec.w printy		; $8DF8CE: CE 7D 04
	jsl.l printz		; $8DF8D1: 22 0C B9 80
	dw $0016		; $8DF8D5  printz inline string: length (counts itself), then control bytes / text
	db "Highlight from game:"
	lda.w #180		; $8DF8EB: A9 B4 00  180 frames, Start skips
	sta.b d0		; $8DF8EE: 85 53
	jsl.l $8F8AE9		; $8DF8F0: 22 E9 8A 8F  bank $8F: wait d0 frames or a button (92G waitxsr)
	lda.b d1		; $8DF8F4: A5 57
	bit.w #JOYSTART		; $8DF8F6: 89 00 10
	beq .play		; $8DF8F9: F0 03
	jmp.w .nhl1		; $8DF8FB: 4C 04 FC
.play:
	jsl.l $8FE404		; $8DF8FE: 22 04 E4 8F  bank $8F: 93G forceblack
	jsl.l sndqreset		; $8DF902: 22 1A FA 82
	lda.w sndbank		; $8DF906: AD 4F 16
	cmp.w #$0001		; $8DF909: C9 01 00
	beq .snd		; $8DF90C: F0 04
	jsl.l SPCGameUpload		; $8DF90E: 22 7A FA 82
.snd:
	ldy.b a0		; $8DF912: A4 33  HomeTeam/VisTeam of game a0
	lda.w gst1,y		; $8DF914: B9 7F 15
	sta.w HomeTeam		; $8DF917: 8D 9A 12
	lda.w gst2,y		; $8DF91A: B9 8F 15
	sta.w VisTeam		; $8DF91D: 8D 9C 12
	stx.b xsave		; $8DF920: 86 0A
	ldx.w #$0000		; $8DF922: A2 00 00
.pusha:
	lda.b a0,x		; $8DF925: B5 33
	pha		; $8DF927: 48
	inx		; $8DF928: E8
	inx		; $8DF929: E8
	cpx.w #$0004		; $8DF92A: E0 04 00
	bne .pusha		; $8DF92D: D0 F6
	ldx.b xsave		; $8DF92F: A6 0A
	jsl.l ClearTeamStats		; $8DF931: 22 6B FD 82
	jsl.l restoreteams		; $8DF935: 22 3A FD 89
	stz.b a2		; $8DF939: 64 3B
	jsl.l reenergizeteam		; $8DF93B: 22 D1 FE 80
	lda.w #$0002		; $8DF93F: A9 02 00
	sta.b a2		; $8DF942: 85 3B
	jsl.l reenergizeteam		; $8DF944: 22 D1 FE 80
	lda.w #$FFFF		; $8DF948: A9 FF FF
	sta.w c1playernum		; $8DF94B: 8D 92 12
	sta.w c2playernum		; $8DF94E: 8D 94 12
	stz.w cont1team		; $8DF951: 9C 96 12
	stz.w cont2team		; $8DF954: 9C 98 12
	lda.w #120		; $8DF957: A9 78 00  gameclock = 120 + random 120
	jsl.l randoma		; $8DF95A: 22 8B AE 80
	adc.w #120		; $8DF95E: 69 78 00
	sta.w gameclock		; $8DF961: 8D F2 12
	stx.b xsave		; $8DF964: 86 0A
	ldx.w #$0002		; $8DF966: A2 02 00
.popa:
	pla		; $8DF969: 68
	sta.b a0,x		; $8DF96A: 95 33
	dex		; $8DF96C: CA
	dex		; $8DF96D: CA
	bpl .popa		; $8DF96E: 10 F9
	ldx.b xsave		; $8DF970: A6 0A
	stx.b xsave		; $8DF972: 86 0A
	ldx.w #$0000		; $8DF974: A2 00 00
.pusha2:
	lda.b a0,x		; $8DF977: B5 33
	pha		; $8DF979: 48
	inx		; $8DF97A: E8
	inx		; $8DF97B: E8
	cpx.w #$0004		; $8DF97C: E0 04 00
	bne .pusha2		; $8DF97F: D0 F6
	ldx.b xsave		; $8DF981: A6 0A
	ldy.b a0		; $8DF983: A4 33  gsp, scores from the game
	lda.w gsper,y		; $8DF985: B9 BF 15
	dec a		; $8DF988: 3A
	sta.w gsp		; $8DF989: 8D F0 12
	lda.w gss1,y		; $8DF98C: B9 CF 15
	sta.w tmscore		; $8DF98F: 8D D6 13
	lda.w gss2,y		; $8DF992: B9 DF 15
	sta.w tmscore+2		; $8DF995: 8D D8 13
	lda.w #gmhl		; $8DF998: A9 10 00  gmode = gmhl
	sta.w gmode		; $8DF99B: 8D 88 12
	stz.w gmclock		; $8DF99E: 9C 8A 12
	lda.w gsp		; $8DF9A1: AD F0 12  odd period: gmdir
	lsr a		; $8DF9A4: 4A
	bcc .ndi		; $8DF9A5: 90 06
	lda.w #gmdir		; $8DF9A7: A9 02 00
	tsb.w gmode		; $8DF9AA: 0C 88 12
.ndi:
	stz.w sflags3		; $8DF9AD: 9C 90 12
	lda.w #sf2drec		; $8DF9B0: A9 00 04  sflags = sf2drec
	sta.w sflags		; $8DF9B3: 8D 8C 12
	stz.w sfhormode		; $8DF9B6: 9C 8E 12
	stz.w glovecords		; $8DF9B9: 9C 4E 01
	stz.w iflags		; $8DF9BC: 9C 5C 01
	lda.w #$FFFF		; $8DF9BF: A9 FF FF  RefCnt, puckcross times -1
	sta.w RefCnt		; $8DF9C2: 8D EA 12
	sta.w puckcross+2		; $8DF9C5: 8D 8B 04
	sta.w puckcross+6		; $8DF9C8: 8D 8F 04
	jsl.l setupice		; $8DF9CB: 22 C1 B4 80
	jsl.l ClrHor		; $8DF9CF: 22 28 A8 80
	stz.w Vpos		; $8DF9D3: 9C DF 08
	stz.w Hpos		; $8DF9D6: 9C 54 01
	jsl.l ResetBench		; $8DF9D9: 22 1A B0 80
	stz.b a2		; $8DF9DD: 64 3B
	jsl.l .team		; $8DF9DF: 22 14 FC 8D
	lda.w #$0002		; $8DF9E3: A9 02 00
	sta.b a2		; $8DF9E6: 85 3B
	jsl.l .team		; $8DF9E8: 22 14 FC 8D
	jsl.l resetplstuff		; $8DF9EC: 22 F8 B3 80
	lda.w #11		; $8DF9F0: A9 0B 00  12 players to their .postab spots
	sta.b d0		; $8DF9F3: 85 53
	lda.w #.postab		; $8DF9F5: A9 97 FC
	sta.b a0		; $8DF9F8: 85 33
	lda.w #.postab>>16		; $8DF9FA: A9 8D 00
	sta.b a0+2		; $8DF9FD: 85 35
	stz.b a1		; $8DF9FF: 64 37
.ploop:
	ldx.b a1		; $8DFA01: A6 37
	lda.w position,x		; $8DFA03: BD 9F 0B
	sta.b d1		; $8DFA06: 85 57
	lda.w pfgoal,x		; $8DFA08: BD 3F 11
	bne .pl0		; $8DFA0B: D0 08
	lda.b d1		; $8DFA0D: A5 57
	clc		; $8DFA0F: 18
	adc.w #6		; $8DFA10: 69 06 00
	sta.b d1		; $8DFA13: 85 57
.pl0:
	asl.b d1		; $8DFA15: 06 57
	asl.b d1		; $8DFA17: 06 57
	ldy.b d1		; $8DFA19: A4 57
	lda.b [a0],y		; $8DFA1B: B7 33
	sta.w Xpos,x		; $8DFA1D: 9D FF 08
	iny		; $8DFA20: C8
	iny		; $8DFA21: C8
	lda.b [a0],y		; $8DFA22: B7 33
	sta.w Ypos,x		; $8DFA24: 9D 5F 09
	stz.w Xvel,x		; $8DFA27: 9E DF 0A
	stz.w Yvel,x		; $8DFA2A: 9E FF 0A
	inc.b a1		; $8DFA2D: E6 37
	inc.b a1		; $8DFA2F: E6 37
	dec.b d0		; $8DFA31: C6 53
	bpl .ploop		; $8DFA33: 10 CC
	jsl.l SprSort		; $8DFA35: 22 6C B7 80
	lda.w #180		; $8DFA39: A9 B4 00  180 frames after the clock stops
	pha		; $8DFA3C: 48
	lda.b vcount		; $8DFA3D: A5 00
	sta.w oldvcount		; $8DFA3F: 8D 27 04
.zero:		;92G .0: wait for the next frame
	lda.b vcount		; $8DFA42: A5 00  the frame time steps as the game loop
	cmp.w oldvcount		; $8DFA44: CD 27 04
	beq .zero		; $8DFA47: F0 F9
	tax		; $8DFA49: AA
	sec		; $8DFA4A: 38
	sbc.w oldvcount		; $8DFA4B: ED 27 04
	sta.b d7		; $8DFA4E: 85 6F
	asl a		; $8DFA50: 0A
	sta.b impactstep		; $8DFA51: 85 E2
	asl a		; $8DFA53: 0A
	asl a		; $8DFA54: 0A
	asl a		; $8DFA55: 0A
	sta.b velstep		; $8DFA56: 85 E4
	asl a		; $8DFA58: 0A
	sta.b gravstep		; $8DFA59: 85 E6
	asl a		; $8DFA5B: 0A
	adc.b gravstep		; $8DFA5C: 65 E6
	sta.b gravstep		; $8DFA5E: 85 E6
	lda.b velstep		; $8DFA60: A5 E4
	asl a		; $8DFA62: 0A
	asl a		; $8DFA63: 0A
	asl a		; $8DFA64: 0A
	asl a		; $8DFA65: 0A
	asl a		; $8DFA66: 0A
	asl a		; $8DFA67: 0A
	sta.b d7x1024		; $8DFA68: 85 E8
	stx.w lastframevc		; $8DFA6A: 8E DB 08
	stx.w oldvcount		; $8DFA6D: 8E 27 04
	jsl.l ReadPads		; $8DFA70: 22 E8 F3 80
	lda.w sflags		; $8DFA74: AD 8C 12
	bit.w #sfpz		; $8DFA77: 89 01 00
	bne .frame		; $8DFA7A: D0 1E
	lda.w gmclock		; $8DFA7C: AD 8A 12
	bne .frame		; $8DFA7F: D0 19
	ldx.b d7		; $8DFA81: A6 6F
.clk:
	lda.w gameclock		; $8DFA83: AD F2 12  run the clock
	beq .clk1		; $8DFA86: F0 0F
	lda.w gameclock+2		; $8DFA88: AD F4 12
	sec		; $8DFA8B: 38
	sbc.w #$0AAA		; $8DFA8C: E9 AA 0A
	sta.w gameclock+2		; $8DFA8F: 8D F4 12
	bcs .clk1		; $8DFA92: B0 03
	dec.w gameclock		; $8DFA94: CE F2 12
.clk1:
	dex		; $8DFA97: CA
	bne .clk		; $8DFA98: D0 E9
.frame:
	lda.b d7		; $8DFA9A: A5 6F
	pha		; $8DFA9C: 48
	jsl.l DoGameFrame		; $8DFA9D: 22 FA B7 80
	pla		; $8DFAA1: 68
	sta.b d7		; $8DFAA2: 85 6F
	lda.w gmclock		; $8DFAA4: AD 8A 12
	beq .one		; $8DFAA7: F0 07
	pla		; $8DFAA9: 68
	sec		; $8DFAAA: 38
	sbc.b d7		; $8DFAAB: E5 6F
	pha		; $8DFAAD: 48
	bmi .endhl		; $8DFAAE: 30 1E
.one:		;92G .1
	jsl.l Readjoy12		; $8DFAB0: 22 D2 FA 84  Start or A ends it
	lda.b d1		; $8DFAB4: A5 57
	bit.w #JOYSTART|JOYA		; $8DFAB6: 89 80 10
	beq .zero		; $8DFAB9: F0 87
	lda.w tmscore		; $8DFABB: AD D6 13  tied: random goal
	cmp.w tmscore+2		; $8DFABE: CD D8 13
	bne .endhl		; $8DFAC1: D0 0B
	jsl.l random		; $8DFAC3: 22 56 AE 80
	and.w #$0002		; $8DFAC7: 29 02 00
	tax		; $8DFACA: AA
	inc.w tmscore,x		; $8DFACB: FE D6 13
.endhl:
	pla		; $8DFACE: 68
	stx.b xsave		; $8DFACF: 86 0A
	ldx.w #$0002		; $8DFAD1: A2 02 00
.popa3:
	pla		; $8DFAD4: 68
	sta.b a0,x		; $8DFAD5: 95 33
	dex		; $8DFAD7: CA
	dex		; $8DFAD8: CA
	bpl .popa3		; $8DFAD9: 10 F9
	ldx.b xsave		; $8DFADB: A6 0A
	stx.b xsave		; $8DFADD: 86 0A
	ldx.w #$0000		; $8DFADF: A2 00 00
.pushd:
	lda.b d1,x		; $8DFAE2: B5 57
	pha		; $8DFAE4: 48
	inx		; $8DFAE5: E8
	inx		; $8DFAE6: E8
	cpx.w #$0004		; $8DFAE7: E0 04 00
	bne .pushd		; $8DFAEA: D0 F6
	ldx.b xsave		; $8DFAEC: A6 0A
	stx.b xsave		; $8DFAEE: 86 0A
	ldx.w #$0000		; $8DFAF0: A2 00 00
.pusha4:
	lda.b a0,x		; $8DFAF3: B5 33
	pha		; $8DFAF5: 48
	inx		; $8DFAF6: E8
	inx		; $8DFAF7: E8
	cpx.w #$0004		; $8DFAF8: E0 04 00
	bne .pusha4		; $8DFAFB: D0 F6
	ldx.b xsave		; $8DFAFD: A6 0A
	jsl.l $8F87C0		; $8DFAFF: 22 C0 87 8F  $8F87C0, bank $8F
	jsl.l sndqreset		; $8DFB03: 22 1A FA 82
	stx.b xsave		; $8DFB07: 86 0A
	ldx.w #$0002		; $8DFB09: A2 02 00
.popa4:
	pla		; $8DFB0C: 68
	sta.b a0,x		; $8DFB0D: 95 33
	dex		; $8DFB0F: CA
	dex		; $8DFB10: CA
	bpl .popa4		; $8DFB11: 10 F9
	ldx.b xsave		; $8DFB13: A6 0A
	stx.b xsave		; $8DFB15: 86 0A
	ldx.w #$0002		; $8DFB17: A2 02 00
.popd:
	pla		; $8DFB1A: 68
	sta.b d1,x		; $8DFB1B: 95 57
	dex		; $8DFB1D: CA
	dex		; $8DFB1E: CA
	bpl .popd		; $8DFB1F: 10 F9
	ldx.b xsave		; $8DFB21: A6 0A
	ldy.b a0		; $8DFB23: A4 33  back into the game record
	lda.w tmscore		; $8DFB25: AD D6 13
	sta.w gss1,y		; $8DFB28: 99 CF 15
	lda.w tmscore+2		; $8DFB2B: AD D8 13
	sta.w gss2,y		; $8DFB2E: 99 DF 15
	lda.b d1		; $8DFB31: A5 57  Start: skip
	bit.w #JOYSTART		; $8DFB33: 89 00 10
	beq .stats		; $8DFB36: F0 03
	jmp.w .nhl1		; $8DFB38: 4C 04 FC
.stats:
	jsl.l $8FE404		; $8DFB3B: 22 04 E4 8F  bank $8F: 93G forceblack
	jsl.l .lo		; $8DFB3F: 22 7C FC 8D  restore the game state
	jsl.l setplayercolors		; $8DFB43: 22 D5 B6 80
	jsl.l $8F84B5		; $8DFB47: 22 B5 84 8F  bank $8F: 93G SetHor
	jsl.l setvideo		; $8DFB4B: 22 5E E3 80
	jsl.l printz		; $8DFB4F: 22 0C B9 80  DisplayStats box
	dw $0005		; $8DFB53  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #22		; $8DFB58: A9 16 00
	sta.b d0		; $8DFB5B: 85 53
	lda.w #7		; $8DFB5D: A9 07 00
	sta.b d1		; $8DFB60: 85 57
	jsl.l $8FD69F		; $8DFB62: 22 9F D6 8F  bank $8F: 93G Framer (d0 x d1)
	jsl.l printscores1		; $8DFB66: 22 5D E9 89
	jsl.l $8FECAB		; $8DFB6A: 22 AB EC 8F  bank $8F: 93G DisplayStats
	stx.b xsave		; $8DFB6E: 86 0A
	ldx.w #$001A		; $8DFB70: A2 1A 00
.popa5:
	pla		; $8DFB73: 68
	sta.b a0,x		; $8DFB74: 95 33
	dex		; $8DFB76: CA
	dex		; $8DFB77: CA
	bpl .popa5		; $8DFB78: 10 F9
	ldx.b xsave		; $8DFB7A: A6 0A
	stx.b xsave		; $8DFB7C: 86 0A
	ldx.w #$001E		; $8DFB7E: A2 1E 00
.popd5:
	pla		; $8DFB81: 68
	sta.b d0,x		; $8DFB82: 95 53
	dex		; $8DFB84: CA
	dex		; $8DFB85: CA
	bpl .popd5		; $8DFB86: 10 F9
	ldx.b xsave		; $8DFB88: A6 0A
	ldx.b a3		; $8DFB8A: A6 3F
	stx.b xsave		; $8DFB8C: 86 0A
	ldx.w #$0000		; $8DFB8E: A2 00 00
.pushd6:
	lda.b d0,x		; $8DFB91: B5 53
	pha		; $8DFB93: 48
	inx		; $8DFB94: E8
	inx		; $8DFB95: E8
	cpx.w #$0020		; $8DFB96: E0 20 00
	bne .pushd6		; $8DFB99: D0 F6
	ldx.b xsave		; $8DFB9B: A6 0A
	stx.b xsave		; $8DFB9D: 86 0A
	ldx.w #$0000		; $8DFB9F: A2 00 00
.pusha6:
	lda.b a0,x		; $8DFBA2: B5 33
	pha		; $8DFBA4: 48
	inx		; $8DFBA5: E8
	inx		; $8DFBA6: E8
	cpx.w #$001C		; $8DFBA7: E0 1C 00
	bne .pusha6		; $8DFBAA: D0 F6
	ldx.b xsave		; $8DFBAC: A6 0A
	ldy.b a0		; $8DFBAE: A4 33
	lda.w #4		; $8DFBB0: A9 04 00  gsper 4: tied after the highlight: again
	sta.w gsper,y		; $8DFBB3: 99 BF 15
	lda.w gss1,y		; $8DFBB6: B9 CF 15
	cmp.w gss2,y		; $8DFBB9: D9 DF 15
	bne .won		; $8DFBBC: D0 03
	jmp.w StartHL2		; $8DFBBE: 4C 88 F8
.won:
	lda.w #5		; $8DFBC1: A9 05 00  gsper 5: final
	sta.w gsper,y		; $8DFBC4: 99 BF 15
	lda.b d1		; $8DFBC7: A5 57
	sta.b d3		; $8DFBC9: 85 5F
	jsl.l $8F887A		; $8DFBCB: 22 7A 88 8F  bank $8F: 93G NewTicker3
	lda.w #180		; $8DFBCF: A9 B4 00
	sta.b d0		; $8DFBD2: 85 53
	jsl.l $8F8AE9		; $8DFBD4: 22 E9 8A 8F  bank $8F: wait d0 frames or a button (92G waitxsr)
	lda.b d1		; $8DFBD8: A5 57
	bit.w #JOYSTART		; $8DFBDA: 89 00 10
	beq .exit		; $8DFBDD: F0 06
.exit2:
	lda.w #sf3sbut		; $8DFBDF: A9 08 00  sf3sbut
	tsb.w sflags3		; $8DFBE2: 0C 90 12
.exit:
	stx.b xsave		; $8DFBE5: 86 0A
	ldx.w #$001A		; $8DFBE7: A2 1A 00
.popa7:
	pla		; $8DFBEA: 68
	sta.b a0,x		; $8DFBEB: 95 33
	dex		; $8DFBED: CA
	dex		; $8DFBEE: CA
	bpl .popa7		; $8DFBEF: 10 F9
	ldx.b xsave		; $8DFBF1: A6 0A
	stx.b xsave		; $8DFBF3: 86 0A
	ldx.w #$001E		; $8DFBF5: A2 1E 00
.popd7:
	pla		; $8DFBF8: 68
	sta.b d0,x		; $8DFBF9: 95 53
	dex		; $8DFBFB: CA
	dex		; $8DFBFC: CA
	bpl .popd7		; $8DFBFD: 10 F9
	ldx.b xsave		; $8DFBFF: A6 0A
	ldx.b a3		; $8DFC01: A6 3F
	rtl		; $8DFC03: 6B
.nhl1:
	jsl.l .lo		; $8DFC04: 22 7C FC 8D
	jsl.l .ranres		; $8DFC08: 22 2F FC 8D
	bra .exit2		; $8DFC0C: 80 D1
.nhl0:
	jsl.l .ranres		; $8DFC0E: 22 2F FC 8D
	bra .exit		; $8DFC12: 80 D1
.team:		;SNES: team a2 for the highlight: energy, setpersonel, forcepldata, no last touches
	jsl.l reenergizeteam		; $8DFC14: 22 D1 FE 80
	jsl.l setpersonel		; $8DFC18: 22 5A BB 80
	jsl.l forcepldata		; $8DFC1C: 22 86 B0 80
	ldy.b a2		; $8DFC20: A4 3B
	lda.w #$FFFF		; $8DFC22: A9 FF FF
	sta.w tmtouch1,y		; $8DFC25: 99 E2 13
	sta.w tmtouch2,y		; $8DFC28: 99 E6 13
	sta.w tmtouch3,y		; $8DFC2B: 99 EA 13
	rtl		; $8DFC2E: 6B
.ranres:		;92G .ranres: a tie gets a random one-goal winner; gsper 5 (final)
	ldy.b a0		; $8DFC2F: A4 33
	lda.w gss1,y		; $8DFC31: B9 CF 15
	cmp.w gss2,y		; $8DFC34: D9 DF 15
	bne .rr0		; $8DFC37: D0 1B
	lda.w #2		; $8DFC39: A9 02 00
	jsl.l randoma		; $8DFC3C: 22 8B AE 80
	ldy.b a0		; $8DFC40: A4 33
	pha		; $8DFC42: 48
	clc		; $8DFC43: 18
	adc.w gss1,y		; $8DFC44: 79 CF 15
	sta.w gss1,y		; $8DFC47: 99 CF 15
	pla		; $8DFC4A: 68
	eor.w #$0001		; $8DFC4B: 49 01 00
	adc.w gss2,y		; $8DFC4E: 79 DF 15
	sta.w gss2,y		; $8DFC51: 99 DF 15
.rr0:
	lda.w #5		; $8DFC54: A9 05 00
	sta.w gsper,y		; $8DFC57: 99 BF 15
	rtl		; $8DFC5A: 6B
.sv:		;92G .sv: save the game state (gmode-1 .. ScoreSumbytes) to hlsavebuf
	ldx.w #$0000		; $8DFC5B: A2 00 00
.sv1:
	lda.w gmode-1,x		; $8DFC5E: BD 87 12
	sta.l hlsavebuf,x		; $8DFC61: 9F 74 7E 7E
	inx		; $8DFC65: E8
	inx		; $8DFC66: E8
	cpx.w #$02F7		; $8DFC67: E0 F7 02
	bcc .sv1		; $8DFC6A: 90 F2
	lda.w ScoreSumbytes		; $8DFC6C: AD FC 12
	sta.l hlsavebuf,x		; $8DFC6F: 9F 74 7E 7E
	inx		; $8DFC73: E8
	inx		; $8DFC74: E8
	stz.w tmgoalie		; $8DFC75: 9C F2 13
	stz.w tmgoalie+2		; $8DFC78: 9C F4 13
	rtl		; $8DFC7B: 6B
.lo:		;92G .lo: restore the game state from hlsavebuf
	ldx.w #$0000		; $8DFC7C: A2 00 00
.lo1:
	lda.l hlsavebuf,x		; $8DFC7F: BF 74 7E 7E
	sta.w gmode-1,x		; $8DFC83: 9D 87 12
	inx		; $8DFC86: E8
	inx		; $8DFC87: E8
	cpx.w #$02F7		; $8DFC88: E0 F7 02
	bcc .lo1		; $8DFC8B: 90 F2
	lda.l hlsavebuf,x		; $8DFC8D: BF 74 7E 7E
	inx		; $8DFC91: E8
	inx		; $8DFC92: E8
	sta.w ScoreSumbytes		; $8DFC93: 8D FC 12
	rtl		; $8DFC96: 6B
.postab:		;92G .postab: x, y start spot by position (0-5 attacking up, 6-11 down)
	dw 0,-240		; $8DFC97
	dw -70,-140		; $8DFC9B
	dw 20,-110		; $8DFC9F
	dw -100,-60		; $8DFCA3
	dw 25,-40		; $8DFCA7
	dw 70,-80		; $8DFCAB
	dw 0,240		; $8DFCAF
	dw 34,90		; $8DFCB3
	dw -55,80		; $8DFCB7
	dw 100,40		; $8DFCBB
	dw -10,10		; $8DFCBF
	dw -50,0		; $8DFCC3
asspenalty:		;auto: CODE_8DFCC7 (asstab $C). 93G asspenalty (logic93_2): player X skates to the penalty box (temp3/temp4 by PBnum), glides in, faces the ice (SPAwallright), then adopen
	lda.w pfalock,x		; $8DFCC7: BD 7F 11
	beq .go		; $8DFCCA: F0 03
	jmp.w .rtl		; $8DFCCC: 4C 02 FE
.go:
	lda.w pflags,x		; $8DFCCF: BD DF 0E  new assignment
	bit.w #pfna		; $8DFCD2: 89 02 00
	beq .nna		; $8DFCD5: F0 7B
	and.w #~pfna&$FFFF		; $8DFCD7: 29 FD FF
	ora.w #pf2unav		; $8DFCDA: 09 00 10
	sta.w pflags,x		; $8DFCDD: 9D DF 0E
	jsl.l clrplayer		; $8DFCE0: 22 1B FE 8D
	lda.w #-2		; $8DFCE4: A9 FE FF  setpads -2: number on the leaving player
	sta.b d4		; $8DFCE7: 85 63
	jsl.l setpads		; $8DFCE9: 22 E1 E0 80
	stz.w temp2,x		; $8DFCED: 9E 7F 0C
	lda.w #8		; $8DFCF0: A9 08 00
	sta.w temp2b,x		; $8DFCF3: 9D FF 0C
	lda.w #11		; $8DFCF6: A9 0B 00  temp4 = 11 * (n + 3), n = players in the box (0-2)
	sta.b d0		; $8DFCF9: 85 53
	lda.w PBnum		; $8DFCFB: AD E4 12
	sta.b d1		; $8DFCFE: 85 57
	lda.w pfteam,x		; $8DFD00: BD 9F 11
	bne .zero		; $8DFD03: D0 0D
	lda.b d1		; $8DFD05: A5 57
	lsr a		; $8DFD07: 4A
	lsr a		; $8DFD08: 4A
	lsr a		; $8DFD09: 4A
	lsr a		; $8DFD0A: 4A
	sta.b d1		; $8DFD0B: 85 57
	lda.w #-11		; $8DFD0D: A9 F5 FF
	sta.b d0		; $8DFD10: 85 53
.zero:		;93G .0
	lda.b d1		; $8DFD12: A5 57
	and.w #$000F		; $8DFD14: 29 0F 00
	sta.b d1		; $8DFD17: 85 57
	cmp.w #3		; $8DFD19: C9 03 00
	bcc .one		; $8DFD1C: 90 05
	lda.w #2		; $8DFD1E: A9 02 00
	sta.b d1		; $8DFD21: 85 57
.one:		;93G .1
	inc.b d1		; $8DFD23: E6 57
	inc.b d1		; $8DFD25: E6 57
	inc.b d1		; $8DFD27: E6 57
	lda.b d0		; $8DFD29: A5 53
	sta.b mula		; $8DFD2B: 85 7D
	lda.b d1		; $8DFD2D: A5 57
	sta.b mulb		; $8DFD2F: 85 83
	jsl.l muls16		; $8DFD31: 22 96 84 80
	sta.b d1		; $8DFD35: 85 57
	sta.w temp4,x		; $8DFD37: 9D BF 0C
	lda.w #$0088		; $8DFD3A: A9 88 00  temp3 = $88: the sideline
	sta.w temp3,x		; $8DFD3D: 9D 9F 0C
	stz.w temp1,x		; $8DFD40: 9E 5F 0C
	lda.w pflags,x		; $8DFD43: BD DF 0E  pf2npc: no player collision
	ora.w #pf2npc		; $8DFD46: 09 00 80
	sta.w pflags,x		; $8DFD49: 9D DF 0E
	stz.w Wallcos,x		; $8DFD4C: 9E 5F 0D
	stz.w Wallsin,x		; $8DFD4F: 9E 7F 0D
.nna:
	lda.w Ypos,x		; $8DFD52: BD 5F 09
	sec		; $8DFD55: 38
	sbc.w temp4,x		; $8DFD56: FD BF 0C
	bit.w #$8000		; $8DFD59: 89 00 80
	beq .ay		; $8DFD5C: F0 04
	eor.w #$FFFF		; $8DFD5E: 49 FF FF
	inc a		; $8DFD61: 1A
.ay:
	cmp.w #13		; $8DFD62: C9 0D 00
	bcc .in		; $8DFD65: 90 03
	jmp.w .st		; $8DFD67: 4C 03 FE
.in:
	lda.w Xpos,x		; $8DFD6A: BD FF 08
	sec		; $8DFD6D: 38
	sbc.w temp3,x		; $8DFD6E: FD 9F 0C
	sta.b d0		; $8DFD71: 85 53
	sec		; $8DFD73: 38
	sbc.w #-24		; $8DFD74: E9 E8 FF
	bmi .lt		; $8DFD77: 30 05
	bvc .near		; $8DFD79: 50 05
.st0:
	jmp.w .st		; $8DFD7B: 4C 03 FE
.lt:
	bvc .st0		; $8DFD7E: 50 FB
.near:
	lda.w temp1,x		; $8DFD80: BD 5F 0C
	sec		; $8DFD83: 38
	sbc.b d7		; $8DFD84: E5 6F
	sta.w temp1,x		; $8DFD86: 9D 5F 0C
	bmi .step		; $8DFD89: 30 03
	jmp.w .rtl		; $8DFD8B: 4C 02 FE
.step:
	adc.w #8		; $8DFD8E: 69 08 00
	sta.w temp1,x		; $8DFD91: 9D 5F 0C
	lda.w #SPAglide		; $8DFD94: A9 78 04  SPAglide, pfnc
	sta.b d1		; $8DFD97: 85 57
	sta.w pfnc,x		; $8DFD99: 9D FF 11
	jsl.l SetSPA		; $8DFD9C: 22 06 B0 80
	lda.w #6		; $8DFDA0: A9 06 00  face 6 (2 for the other hand)
	sta.b d2		; $8DFDA3: 85 5B
	lda.w handed,x		; $8DFDA5: BD 1F 11
	beq .left		; $8DFDA8: F0 05
	lda.w #2		; $8DFDAA: A9 02 00
	sta.b d2		; $8DFDAD: 85 5B
.left:
	lda.w facedir,x		; $8DFDAF: BD BF 0D
	cmp.b d2		; $8DFDB2: C5 5B
	beq .ok		; $8DFDB4: F0 07
	inc a		; $8DFDB6: 1A
	and.w #$0007		; $8DFDB7: 29 07 00
	sta.w facedir,x		; $8DFDBA: 9D BF 0D
.ok:
	stz.w Yvel,x		; $8DFDBD: 9E FF 0A
	lda.w #$1000		; $8DFDC0: A9 00 10
	sta.w Xvel,x		; $8DFDC3: 9D DF 0A
	lda.b d0		; $8DFDC6: A5 53
	sec		; $8DFDC8: 38
	sbc.w #-8		; $8DFDC9: E9 F8 FF
	bmi .lt2		; $8DFDCC: 30 04
	bvc .stop		; $8DFDCE: 50 04
	bra .rtl		; $8DFDD0: 80 30
.lt2:
	bvc .rtl		; $8DFDD2: 50 2E
.stop:
	stz.w Xvel,x		; $8DFDD4: 9E DF 0A
	lda.w facedir,x		; $8DFDD7: BD BF 0D
	cmp.b d2		; $8DFDDA: C5 5B
	bne .rtl		; $8DFDDC: D0 24
	lda.w #2		; $8DFDDE: A9 02 00
	sta.w facedir,x		; $8DFDE1: 9D BF 0D
	sta.w pfalock,x		; $8DFDE4: 9D 7F 11
	lda.w #SPAwallright		; $8DFDE7: A9 1A 10  SPAwallright
	sta.b d1		; $8DFDEA: 85 57
	jsl.l SetSPA		; $8DFDEC: 22 06 B0 80
	lda.w pflags,x		; $8DFDF0: BD DF 0E
	and.w #~pf2pen&$FFFF		; $8DFDF3: 29 FF BF  pf2pen off
	sta.w pflags,x		; $8DFDF6: 9D DF 0E
	lda.w #$0D		; $8DFDF9: A9 0D 00  adopen
	sta.b d0		; $8DFDFC: 85 53
	jml.l assreplace		; $8DFDFE: 5C A7 B4 80
.rtl:
	rtl		; $8DFE02: 6B
.st:		;skate to the box
	lda.w temp3,x		; $8DFE03: BD 9F 0C
	sta.b d0		; $8DFE06: 85 53
	lda.w temp4,x		; $8DFE08: BD BF 0C
	sta.b d1		; $8DFE0B: 85 57
	lda.w #rtss		; $8DFE0D: A9 E6 84  a0 = rtss: no avoidance
	sta.b a0		; $8DFE10: 85 33
	lda.w #rtss>>16		; $8DFE12: A9 80 00
	sta.b a0+2		; $8DFE15: 85 35
	jml.l skateto		; $8DFE17: 5C D0 FD 88
clrplayer:		;auto: CODE_8DFE1B. 93G clrplayer: take the joystick off player X (changeplayer)
	lda.w pflags,x		; $8DFE1B: BD DF 0E
	bit.w #pfjoycon		; $8DFE1E: 89 08 00
	beq asspenalty_rtl		; $8DFE21: F0 DF
	stz.b d4		; $8DFE23: 64 63
	txa		; $8DFE25: 8A
	lsr a		; $8DFE26: 4A
	sta.b d0		; $8DFE27: 85 53
	cmp.w c1playernum		; $8DFE29: CD 92 12
	beq .ch		; $8DFE2C: F0 04
	inc.b d4		; $8DFE2E: E6 63
	inc.b d4		; $8DFE30: E6 63
.ch:
	jml.l changeplayer		; $8DFE32: 5C 9D AE 80
avdgoal:		;auto: CODE_8DFE36 (from skateto, $808C45). 93G avdgoal (logic93_5, SNES form): if the path d0/d1 crosses a goal line (y +-254) within 40 of the net, aim beside the net (x +-60) instead
	stz.b tmp2		; $8DFE36: 64 77
	lda.w #-258		; $8DFE38: A9 FE FE  goal line at y -258 ($FEFE) and 258 ($102)
	jsl.l .ch1		; $8DFE3B: 22 7E FE 8D
	lda.w #258		; $8DFE3F: A9 02 01
	jsl.l .ch1		; $8DFE42: 22 7E FE 8D
	lda.b tmp2		; $8DFE46: A5 77
	bne .rtl		; $8DFE48: D0 6D
	lda.w Xpos,x		; $8DFE4A: BD FF 08  not crossing: is the player in front of a net?
	eor.b d0		; $8DFE4D: 45 53
	bpl .rtl		; $8DFE4F: 10 66
	lda.w Ypos,x		; $8DFE51: BD 5F 09
	sec		; $8DFE54: 38
	sbc.w #258		; $8DFE55: E9 02 01
	bit.w #$8000		; $8DFE58: 89 00 80
	beq .b		; $8DFE5B: F0 04
	eor.w #$FFFF		; $8DFE5D: 49 FF FF
	inc a		; $8DFE60: 1A
.b:
	cmp.w #32		; $8DFE61: C9 20 00
	bcc .x		; $8DFE64: 90 15
	lda.w Ypos,x		; $8DFE66: BD 5F 09
	sec		; $8DFE69: 38
	sbc.w #-258		; $8DFE6A: E9 FE FE
	bit.w #$8000		; $8DFE6D: 89 00 80
	beq .c		; $8DFE70: F0 04
	eor.w #$FFFF		; $8DFE72: 49 FF FF
	inc a		; $8DFE75: 1A
.c:
	cmp.w #32		; $8DFE76: C9 20 00
	bcs .rtl		; $8DFE79: B0 3C
.x:
	stz.b d1		; $8DFE7B: 64 57
	rtl		; $8DFE7D: 6B
.ch1:		;goal line A: crossed within 40 of the net: d1 = line, d0 = +-60 by Xvel, tmp2 = 1
	sta.b tmp0		; $8DFE7E: 85 73
	lda.b d1		; $8DFE80: A5 57
	sec		; $8DFE82: 38
	sbc.b tmp0		; $8DFE83: E5 73
	sta.b tmp1		; $8DFE85: 85 75
	lda.w Ypos,x		; $8DFE87: BD 5F 09
	sec		; $8DFE8A: 38
	sbc.b tmp0		; $8DFE8B: E5 73
	eor.b tmp1		; $8DFE8D: 45 75
	bpl .rtl		; $8DFE8F: 10 26
	lda.w Xpos,x		; $8DFE91: BD FF 08
	bit.w #$8000		; $8DFE94: 89 00 80
	beq .ax		; $8DFE97: F0 04
	eor.w #$FFFF		; $8DFE99: 49 FF FF
	inc a		; $8DFE9C: 1A
.ax:
	cmp.w #40		; $8DFE9D: C9 28 00
	bcs .rtl		; $8DFEA0: B0 15
	inc.b tmp2		; $8DFEA2: E6 77
	lda.b tmp0		; $8DFEA4: A5 73
	sta.b d1		; $8DFEA6: 85 57
	lda.w #60		; $8DFEA8: A9 3C 00
	sta.b d0		; $8DFEAB: 85 53
	lda.w Xvel,x		; $8DFEAD: BD DF 0A
	bpl .rtl		; $8DFEB0: 10 05
	lda.w #-60		; $8DFEB2: A9 C4 FF
	sta.b d0		; $8DFEB5: 85 53
.rtl:
	rtl		; $8DFEB7: 6B
unused008D:		;unused, zero fill to the end of the bank
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFEB8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFEC8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFED8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFEE8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFEF8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF08
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF18
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF28
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF38
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF48
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF58
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF68
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF78
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF88
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFF98
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFFA8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFFB8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFFC8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFFD8
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8DFFE8
	db $00,$00,$00,$00,$00,$00,$00,$00		; $8DFFF8
