; $8E8000-$8E900A  ROM $70000-$7100A: Gameloop (hockey93_01, with the DoGameFrame time steps), PlayerShortName, assbench (logic93_2, asstab $B);
; then SpriteSet3 (frame set 3: celebrations), tiles continue to bank8E_D000.
org $8E8000
Gameloop:		;auto: CODE_8E8000 (from StartPer). 93G Gameloop (hockey93_01): wait for a new frame, time steps from d7, clock, music cue timers, crowd cheers, DoGameFrame, demoread, goalie
		;   puck-handling penalty, line change end, Pausemode
	lda.b vcount		; $8E8000: A5 00  wait for the next frame
	cmp.w oldvcount		; $8E8002: CD 27 04
	beq Gameloop		; $8E8005: F0 F9
	tax		; $8E8007: AA  d7 = frames elapsed; the time steps
	sec		; $8E8008: 38
	sbc.w oldvcount		; $8E8009: ED 27 04
	sta.b d7		; $8E800C: 85 6F
	asl a		; $8E800E: 0A
	sta.b impactstep		; $8E800F: 85 E2
	asl a		; $8E8011: 0A
	asl a		; $8E8012: 0A
	asl a		; $8E8013: 0A
	sta.b velstep		; $8E8014: 85 E4
	asl a		; $8E8016: 0A
	sta.b gravstep		; $8E8017: 85 E6
	asl a		; $8E8019: 0A
	adc.b gravstep		; $8E801A: 65 E6
	sta.b gravstep		; $8E801C: 85 E6
	lda.b velstep		; $8E801E: A5 E4
	asl a		; $8E8020: 0A
	asl a		; $8E8021: 0A
	asl a		; $8E8022: 0A
	asl a		; $8E8023: 0A
	asl a		; $8E8024: 0A
	asl a		; $8E8025: 0A
	sta.b d7x1024		; $8E8026: 85 E8
	stx.w lastframevc		; $8E8028: 8E DB 08
	stx.w oldvcount		; $8E802B: 8E 27 04
	jsl.l ReadPads		; $8E802E: 22 E8 F3 80
	lda.w sflags		; $8E8032: AD 8C 12  clock stops in pause and when stopped
	bit.w #sfpz		; $8E8035: 89 01 00
	bne .cue		; $8E8038: D0 1E
	lda.w gmclock		; $8E803A: AD 8A 12
	bne .cue		; $8E803D: D0 19
	ldx.b d7		; $8E803F: A6 6F
.clk:
	lda.w gameclock		; $8E8041: AD F2 12
	beq .clk1		; $8E8044: F0 0F
	lda.w gameclock+2		; $8E8046: AD F4 12
	sec		; $8E8049: 38
	sbc.w #$0AAA		; $8E804A: E9 AA 0A  clock fraction: one second per $10000
	sta.w gameclock+2		; $8E804D: 8D F4 12
	bcs .clk1		; $8E8050: B0 03
	dec.w gameclock		; $8E8052: CE F2 12
.clk1:
	dex		; $8E8055: CA
	bne .clk		; $8E8056: D0 E9
.cue:
	lda.w cuetimer		; $8E8058: AD A9 04  music cue: sounds back near its end
	beq .p3		; $8E805B: F0 18
	ldx.b d7		; $8E805D: A6 6F
.cue1:
	dec.w cuetimer		; $8E805F: CE A9 04
	lda.w cuetimer		; $8E8062: AD A9 04
	beq .p3		; $8E8065: F0 0E
	cmp.w #2		; $8E8067: C9 02 00
	bne .cue2		; $8E806A: D0 06
	jsl.l sndqreset		; $8E806C: 22 1A FA 82
	bra .p3		; $8E8070: 80 03
.cue2:
	dex		; $8E8072: CA
	bne .cue1		; $8E8073: D0 EA
.p3:
	lda.w p3cue		; $8E8075: AD 2D 04  third period cue
	beq .cheer		; $8E8078: F0 1B
	sec		; $8E807A: 38
	sbc.b d7		; $8E807B: E5 6F
	bpl .p3a		; $8E807D: 10 03
	lda.w #$0000		; $8E807F: A9 00 00
.p3a:
	sta.w p3cue		; $8E8082: 8D 2D 04
	bne .cheer		; $8E8085: D0 0E
	lda.w cuetimer		; $8E8087: AD A9 04  another cue plays: try next frame
	beq .p3go		; $8E808A: F0 05
	inc.w p3cue		; $8E808C: EE 2D 04
	bra .cheer		; $8E808F: 80 04
.p3go:
	jsl.l StartSong3		; $8E8091: 22 0B FC 89
.cheer:
	lda.w cheercnt		; $8E8095: AD 50 01  crowd cheers after a goal: every 150 frames
	beq .frame		; $8E8098: F0 20
	lda.b vcount		; $8E809A: A5 00
	sec		; $8E809C: 38
	sbc.w cheervc		; $8E809D: ED 52 01
	cmp.w #150		; $8E80A0: C9 96 00
	bcc .frame		; $8E80A3: 90 15
	lda.w #SFXcrowdcheer		; $8E80A5: A9 8A 00  SFXcrowdcheer
	pha		; $8E80A8: 48
	jsl.l sfx		; $8E80A9: 22 8B C2 80
	dec.w cheercnt		; $8E80AD: CE 50 01
	lda.w cheervc		; $8E80B0: AD 52 01
	clc		; $8E80B3: 18
	adc.w #150		; $8E80B4: 69 96 00
	sta.w cheervc		; $8E80B7: 8D 52 01
.frame:
	jsl.l DoGameFrame		; $8E80BA: 22 FA B7 80
	jsl.l demoread		; $8E80BE: 22 D4 C3 80
	bra .gh		; $8E80C2: 80 3E
.cheat:		;not reached (the bra above skips it): new pad presses L, A, X in a row set the score of controller 1's team to 9
	lda.w padnew1		; $8E80C4: AD 6E 01
	beq .gh		; $8E80C7: F0 39
	ldx.w cheatpads+2		; $8E80C9: AE 4A 16
	stx.w cheatpads		; $8E80CC: 8E 48 16
	ldx.w cheatpads+4		; $8E80CF: AE 4C 16
	stx.w cheatpads+2		; $8E80D2: 8E 4A 16
	sta.w cheatpads+4		; $8E80D5: 8D 4C 16
	lda.w cheatpads		; $8E80D8: AD 48 16
	cmp.w #$20		; $8E80DB: C9 20 00
	bne .gh		; $8E80DE: D0 22
	lda.w cheatpads+2		; $8E80E0: AD 4A 16
	cmp.w #$80		; $8E80E3: C9 80 00
	bne .gh		; $8E80E6: D0 1A
	lda.w cheatpads+4		; $8E80E8: AD 4C 16
	cmp.w #$40		; $8E80EB: C9 40 00
	bne .gh		; $8E80EE: D0 12
	lda.w cont1team		; $8E80F0: AD 96 12
	beq .gh		; $8E80F3: F0 0D
	dec a		; $8E80F5: 3A
	asl a		; $8E80F6: 0A
	tax		; $8E80F7: AA
	lda.w #9		; $8E80F8: A9 09 00
	sta.w tmscore,x		; $8E80FB: 9D D6 13
	jsl.l printscores1		; $8E80FE: 22 5D E9 89
.gh:		;goalie carrying the puck far from his net: penalty 6
	lda.w position		; $8E8102: AD 9F 0B  goalies on the ice
	ora.w position+2		; $8E8105: 0D A1 0B
	beq .lc		; $8E8108: F0 34
	lda.w puckc		; $8E810A: AD BB 0E
	bmi .lc		; $8E810D: 30 2F
	asl a		; $8E810F: 0A
	tax		; $8E8110: AA
	lda.w position,x		; $8E8111: BD 9F 0B
	bne .lc		; $8E8114: D0 28
	lda.w pucky		; $8E8116: AD 7B 09
	bit.w #$8000		; $8E8119: 89 00 80
	beq .ay		; $8E811C: F0 04
	eor.w #$FFFF		; $8E811E: 49 FF FF
	inc a		; $8E8121: 1A
.ay:
	cmp.w #165		; $8E8122: C9 A5 00  beyond y 165
	bcs .lc		; $8E8125: B0 17
	stx.b a3		; $8E8127: 86 3F
	lda.w #6		; $8E8129: A9 06 00  penalty 6
	sta.b d0		; $8E812C: 85 53
	jsl.l AddPenalty2		; $8E812E: 22 B0 C1 80
	lda.w #300		; $8E8132: A9 2C 01  nopuck 300
	sta.w nopuck,x		; $8E8135: 9D 5F 0E
	lda.w #$FFFF		; $8E8138: A9 FF FF
	sta.w puckc		; $8E813B: 8D BB 0E
.lc:
	lda.w lcplayer		; $8E813E: AD 83 01  a line change player waiting
	bmi .pause		; $8E8141: 30 30
	cmp.w puckc		; $8E8143: CD BB 0E
	beq .pause		; $8E8146: F0 2B
	asl a		; $8E8148: 0A
	tax		; $8E8149: AA
	stx.b a3		; $8E814A: 86 3F
	lda.w pflags,x		; $8E814C: BD DF 0E  pf2lcm off
	and.w #~pf2lcm&$FFFF		; $8E814F: 29 FF DF
	sta.w pflags,x		; $8E8152: 9D DF 0E
	stz.b a2		; $8E8155: 64 3B
	jsl.l lcfound2		; $8E8157: 22 B7 FC 86
	lda.w #$0002		; $8E815B: A9 02 00
	sta.b a2		; $8E815E: 85 3B
	jsl.l lcfound2		; $8E8160: 22 B7 FC 86
	lda.w #tmflc		; $8E8164: A9 08 00  tmflc off for both teams
	trb.w tmflags		; $8E8167: 1C 0A 14
	trb.w tmflags+2		; $8E816A: 1C 0C 14
	lda.w #$FFFF		; $8E816D: A9 FF FF
	sta.w lcplayer		; $8E8170: 8D 83 01
.pause:
	lda.w sflags		; $8E8173: AD 8C 12
	bit.w #sfpz		; $8E8176: 89 01 00
	beq .loop		; $8E8179: F0 04
	jsl.l Pausemode		; $8E817B: 22 2B F8 83
.loop:
	jmp.w Gameloop		; $8E817F: 4C 00 80
PlayerShortName:		;auto: CODE_8E8182. SNES: mesarea = "<number> <first initial>. <last name>" of roster player d0 (team a2)
	stx.b xsave		; $8E8182: 86 0A
	ldx.w #$0000		; $8E8184: A2 00 00
.pushd:
	lda.b d0,x		; $8E8187: B5 53
	pha		; $8E8189: 48
	inx		; $8E818A: E8
	inx		; $8E818B: E8
	cpx.w #$0010		; $8E818C: E0 10 00
	bne .pushd		; $8E818F: D0 F6
	ldx.b xsave		; $8E8191: A6 0A
	stx.b xsave		; $8E8193: 86 0A
	ldx.w #$0000		; $8E8195: A2 00 00
.pusha2:
	lda.b a2,x		; $8E8198: B5 3B
	pha		; $8E819A: 48
	inx		; $8E819B: E8
	inx		; $8E819C: E8
	cpx.w #$0004		; $8E819D: E0 04 00
	bne .pusha2		; $8E81A0: D0 F6
	ldx.b xsave		; $8E81A2: A6 0A
	stx.b xsave		; $8E81A4: 86 0A
	ldx.w #$0000		; $8E81A6: A2 00 00
.pusha:
	lda.b a0,x		; $8E81A9: B5 33
	pha		; $8E81AB: 48
	inx		; $8E81AC: E8
	inx		; $8E81AD: E8
	cpx.w #$0004		; $8E81AE: E0 04 00
	bne .pusha		; $8E81B1: D0 F6
	ldx.b xsave		; $8E81B3: A6 0A
	jsl.l GetPlayerRecord		; $8E81B5: 22 D8 FC 89
	stx.b xsave		; $8E81B9: 86 0A
	ldx.w #$0000		; $8E81BB: A2 00 00
.pusha3:
	lda.b a0,x		; $8E81BE: B5 33
	pha		; $8E81C0: 48
	inx		; $8E81C1: E8
	inx		; $8E81C2: E8
	cpx.w #$0004		; $8E81C3: E0 04 00
	bne .pusha3		; $8E81C6: D0 F6
	ldx.b xsave		; $8E81C8: A6 0A
	lda.w #$0000		; $8E81CA: A9 00 00
	sta.b a1+2		; $8E81CD: 85 39
	lda.w #mesarea+2		; $8E81CF: A9 93 01  a1 = mesarea+2
	sta.b a1		; $8E81D2: 85 37
	lda.b a0		; $8E81D4: A5 33
	clc		; $8E81D6: 18
	adc.b [a0]		; $8E81D7: 67 33
	sta.b a0		; $8E81D9: 85 33
	lda.b [a0]		; $8E81DB: A7 33
	and.w #$00FF		; $8E81DD: 29 FF 00
	sta.b d0		; $8E81E0: 85 53
	jsl.l PutDigits2		; $8E81E2: 22 39 EA 84  number
	lda.w #' '		; $8E81E6: A9 20 00
	sta.b [a1]		; $8E81E9: 87 37
	inc.b a1		; $8E81EB: E6 37
	stx.b xsave		; $8E81ED: 86 0A
	ldx.w #$0002		; $8E81EF: A2 02 00
.popa3:
	pla		; $8E81F2: 68
	sta.b a0,x		; $8E81F3: 95 33
	dex		; $8E81F5: CA
	dex		; $8E81F6: CA
	bpl .popa3		; $8E81F7: 10 F9
	ldx.b xsave		; $8E81F9: A6 0A
	lda.b [a0]		; $8E81FB: A7 33  name length
	sta.b d0		; $8E81FD: 85 53
	clc		; $8E81FF: 18
	adc.b a0		; $8E8200: 65 33
	sta.b a2		; $8E8202: 85 3B
	lda.b a0+2		; $8E8204: A5 35
	sta.b a2+2		; $8E8206: 85 3D
	inc.b a0		; $8E8208: E6 33
	inc.b a0		; $8E820A: E6 33
	lda.b [a0]		; $8E820C: A7 33  first initial
	inc.b a0		; $8E820E: E6 33
	sta.b [a1]		; $8E8210: 87 37
	inc.b a1		; $8E8212: E6 37
	lda.w #'.'		; $8E8214: A9 2E 00
	sta.b [a1]		; $8E8217: 87 37
	inc.b a1		; $8E8219: E6 37
	lda.w #' '		; $8E821B: A9 20 00
	sta.b [a1]		; $8E821E: 87 37
	inc.b a1		; $8E8220: E6 37
.skip:
	lda.b [a0]		; $8E8222: A7 33  skip to the last name
	inc.b a0		; $8E8224: E6 33
	and.w #$00FF		; $8E8226: 29 FF 00
	cmp.w #' '		; $8E8229: C9 20 00
	bne .skip		; $8E822C: D0 F4
.last:
	lda.b [a0]		; $8E822E: A7 33
	inc.b a0		; $8E8230: E6 33
	sta.b [a1]		; $8E8232: 87 37
	inc.b a1		; $8E8234: E6 37
	lda.b a0		; $8E8236: A5 33
	cmp.b a2		; $8E8238: C5 3B
	bne .last		; $8E823A: D0 F2
	jsl.l MesAreaDone		; $8E823C: 22 FD FC 89
	stx.b xsave		; $8E8240: 86 0A
	ldx.w #$0002		; $8E8242: A2 02 00
.popa:
	pla		; $8E8245: 68
	sta.b a0,x		; $8E8246: 95 33
	dex		; $8E8248: CA
	dex		; $8E8249: CA
	bpl .popa		; $8E824A: 10 F9
	ldx.b xsave		; $8E824C: A6 0A
	stx.b xsave		; $8E824E: 86 0A
	ldx.w #$0002		; $8E8250: A2 02 00
.popa2:
	pla		; $8E8253: 68
	sta.b a2,x		; $8E8254: 95 3B
	dex		; $8E8256: CA
	dex		; $8E8257: CA
	bpl .popa2		; $8E8258: 10 F9
	ldx.b xsave		; $8E825A: A6 0A
	stx.b xsave		; $8E825C: 86 0A
	ldx.w #$000E		; $8E825E: A2 0E 00
.popd:
	pla		; $8E8261: 68
	sta.b d0,x		; $8E8262: 95 53
	dex		; $8E8264: CA
	dex		; $8E8265: CA
	bpl .popd		; $8E8266: 10 F9
	ldx.b xsave		; $8E8268: A6 0A
	rtl		; $8E826A: 6B
assbench:		;auto: CODE_8E826B (asstab $B). 93G assbench (logic93_2): player X skates to the bench door and leaves; the new player (newpnum) comes on (setplayer)
	lda.w pfalock,x		; $8E826B: BD 7F 11
	beq .go		; $8E826E: F0 03
	jmp.w .rtl		; $8E8270: 4C 7B 83
.go:
	lda.w temp1,x		; $8E8273: BD 5F 0C
	cmp.w #100		; $8E8276: C9 64 00  temp1 100: at the bench door
	bne .chk		; $8E8279: D0 03
	jmp.w .done		; $8E827B: 4C 7C 83
.chk:
	jsl.l check4bench		; $8E827E: 22 27 85 80
	lda.w pflags,x		; $8E8282: BD DF 0E
	bit.w #pf2pen		; $8E8285: 89 00 40  pf2pen: assexit
	beq .pen		; $8E8288: F0 04
	jml.l assexit		; $8E828A: 5C F9 96 80
.pen:
	bit.w #pfna		; $8E828E: 89 02 00
	beq .nna		; $8E8291: F0 2C
	and.w #~pfna&$FFFF		; $8E8293: 29 FD FF
	sta.w pflags,x		; $8E8296: 9D DF 0E
	stz.w temp2,x		; $8E8299: 9E 7F 0C
	lda.w #8		; $8E829C: A9 08 00
	sta.w temp2b,x		; $8E829F: 9D FF 0C
	lda.w #80		; $8E82A2: A9 50 00  temp4 = bench y +-80, temp3 = bench x -144
	sta.b d0		; $8E82A5: 85 53
	lda.w pfteam,x		; $8E82A7: BD 9F 11
	bne .zero		; $8E82AA: D0 05
	lda.w #-80		; $8E82AC: A9 B0 FF
	sta.b d0		; $8E82AF: 85 53
.zero:		;93G .0
	lda.b d0		; $8E82B1: A5 53
	sta.w temp4,x		; $8E82B3: 9D BF 0C
	lda.w #-144		; $8E82B6: A9 70 FF
	sta.w temp3,x		; $8E82B9: 9D 9F 0C
	stz.w temp1,x		; $8E82BC: 9E 5F 0C
.nna:
	lda.w newpnum,x		; $8E82BF: BD BF 0E  same player: just change position
	cmp.w pnum,x		; $8E82C2: DD 1F 0F
	bne .dec		; $8E82C5: D0 03
	jmp.w .nobench		; $8E82C7: 4C CC 83
.dec:
	lda.w temp1,x		; $8E82CA: BD 5F 0C
	sec		; $8E82CD: 38
	sbc.b d7		; $8E82CE: E5 6F
	sta.w temp1,x		; $8E82D0: 9D 5F 0C
	bmi .near		; $8E82D3: 30 03
	jmp.w .nodec		; $8E82D5: 4C AF 83
.near:
	lda.w temp1,x		; $8E82D8: BD 5F 0C
	adc.w #8		; $8E82DB: 69 08 00
	sta.w temp1,x		; $8E82DE: 9D 5F 0C
	lda.w Ypos,x		; $8E82E1: BD 5F 09
	sec		; $8E82E4: 38
	sbc.w temp4,x		; $8E82E5: FD BF 0C
	bit.w #$8000		; $8E82E8: 89 00 80
	beq .ay		; $8E82EB: F0 04
	eor.w #$FFFF		; $8E82ED: 49 FF FF
	inc a		; $8E82F0: 1A
.ay:
	cmp.w #41		; $8E82F1: C9 29 00
	bcc .ax		; $8E82F4: 90 03
	jmp.w .nodec		; $8E82F6: 4C AF 83
.ax:
	lda.w Xpos,x		; $8E82F9: BD FF 08
	sec		; $8E82FC: 38
	sbc.w temp3,x		; $8E82FD: FD 9F 0C
	sta.b d0		; $8E8300: 85 53
	sec		; $8E8302: 38
	sbc.w #32		; $8E8303: E9 20 00
	beq .gli0		; $8E8306: F0 09
	bmi .lt		; $8E8308: 30 05
	bvs .gli0		; $8E830A: 70 05
.nd:
	jmp.w .nodec		; $8E830C: 4C AF 83
.lt:
	bvs .nd		; $8E830F: 70 FB
.gli0:
	lda.w #SPAglide		; $8E8311: A9 78 04  SPAglide (goalie SPAgready)
	sta.b d1		; $8E8314: 85 57
	lda.w position,x		; $8E8316: BD 9F 0B
	bne .gli		; $8E8319: D0 05
	lda.w #SPAgready		; $8E831B: A9 02 00
	sta.b d1		; $8E831E: 85 57
.gli:
	jsl.l SetSPA		; $8E8320: 22 06 B0 80
	lda.w #1		; $8E8324: A9 01 00
	sta.w pfnc,x		; $8E8327: 9D FF 11
	lda.w facedir,x		; $8E832A: BD BF 0D
	cmp.w #4		; $8E832D: C9 04 00
	beq .ok		; $8E8330: F0 07
	inc a		; $8E8332: 1A
	and.w #$0007		; $8E8333: 29 07 00
	sta.w facedir,x		; $8E8336: 9D BF 0D
.ok:
	stz.w Yvel,x		; $8E8339: 9E FF 0A
	lda.w #$F800		; $8E833C: A9 00 F8
	sta.w Xvel,x		; $8E833F: 9D DF 0A
	lda.b d0		; $8E8342: A5 53
	sec		; $8E8344: 38
	sbc.w #16		; $8E8345: E9 10 00
	beq .stop		; $8E8348: F0 08
	bmi .lt2		; $8E834A: 30 04
	bvs .stop		; $8E834C: 70 04
	bra .rtl		; $8E834E: 80 2B
.lt2:
	bvs .rtl		; $8E8350: 70 29
.stop:
	stz.w Xvel,x		; $8E8352: 9E DF 0A
	lda.w facedir,x		; $8E8355: BD BF 0D
	cmp.w #4		; $8E8358: C9 04 00
	bne .rtl		; $8E835B: D0 1E
	lda.w #$F800		; $8E835D: A9 00 F8
	sta.w Xvel,x		; $8E8360: 9D DF 0A
	lda.w #2		; $8E8363: A9 02 00
	sta.w facedir,x		; $8E8366: 9D BF 0D
	lda.w #SPAwallleft		; $8E8369: A9 58 10  SPAwallleft
	sta.b d1		; $8E836C: 85 57
	jsl.l SetSPA		; $8E836E: 22 06 B0 80
	lda.w #100		; $8E8372: A9 64 00
	sta.w temp1,x		; $8E8375: 9D 5F 0C
	sta.w pfalock,x		; $8E8378: 9D 7F 11
.rtl:
	rtl		; $8E837B: 6B
.done:
	stz.w frame,x		; $8E837C: 9E 3F 09
	lda.w pnum,x		; $8E837F: BD 1F 0F
	asl a		; $8E8382: 0A
	sta.b d0		; $8E8383: 85 53
	stz.b a0		; $8E8385: 64 33
	lda.w pfteam,x		; $8E8387: BD 9F 11
	beq .t0		; $8E838A: F0 05
	lda.w #2		; $8E838C: A9 02 00
	sta.b a0		; $8E838F: 85 33
.t0:
	lda.b a0		; $8E8391: A5 33
	beq .t1		; $8E8393: F0 03
	lda.w #$34		; $8E8395: A9 34 00
.t1:
	clc		; $8E8398: 18
	adc.b d0		; $8E8399: 65 53
	tay		; $8E839B: A8
	lda.w #TMPDBENCH		; $8E839C: A9 FE FF  TMPDBENCH: on the bench
	sta.w tmpdst,y		; $8E839F: 99 E2 14
	lda.w newpnum,x		; $8E83A2: BD BF 0E
	sta.b d3		; $8E83A5: 85 5F
	jsl.l .nobench2		; $8E83A7: 22 D5 83 8E
	jml.l setplayer		; $8E83AB: 5C 5D B1 80
.nodec:
	lda.w pfnc,x		; $8E83AF: BD FF 11
	bne .rtl		; $8E83B2: D0 C7
	lda.w temp3,x		; $8E83B4: BD 9F 0C
	sta.b d0		; $8E83B7: 85 53
	lda.w temp4,x		; $8E83B9: BD BF 0C
	sta.b d1		; $8E83BC: 85 57
	lda.w #EvadePC		; $8E83BE: A9 6A FD
	sta.b a0		; $8E83C1: 85 33
	lda.w #EvadePC>>16		; $8E83C3: A9 89 00
	sta.b a0+2		; $8E83C6: 85 35
	jml.l skateto		; $8E83C8: 5C D0 FD 88
.nobench:
	lda.w pflags,x		; $8E83CC: BD DF 0E
	and.w #~pf2unav&$FFFF		; $8E83CF: 29 FF EF
	sta.w pflags,x		; $8E83D2: 9D DF 0E
.nobench2:		;position = newpos (Setplass), newpnum/newpos -1
	lda.w newpos,x		; $8E83D5: BD 9F 0E
	sta.b d0		; $8E83D8: 85 53
	sta.w position,x		; $8E83DA: 9D 9F 0B
	jsl.l Setplass		; $8E83DD: 22 38 B1 80
	lda.w #$FFFF		; $8E83E1: A9 FF FF
	sta.w newpnum,x		; $8E83E4: 9D BF 0E
	sta.w newpos,x		; $8E83E7: 9D 9F 0E
	rtl		; $8E83EA: 6B
SpriteSet3:		;frame set 3 (SPFcelebrate, SPFpump, SPFcup): frames 185-224
	dw 40		; $8E83EB frames
	dw 344		; $8E83ED pieces
	dw 640		; $8E83EF tiles
	dw .pieces-SpriteSet3		; $8E83F1
	dw .tiles-SpriteSet3		; $8E83F3
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,16,26,34,48,59,68		; $8E83F5
	dw 75,82,89,97,105,120,132,140		; $8E8405
	dw 147,157,161,167,177,187,195,201		; $8E8415
	dw 210,217,222,232,241,247,258,263		; $8E8425
	dw 267,276,292,304,311,319,327,333		; $8E8435
	dw 344		; $8E8445
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set03.pieces"		; $8E8447-$8E89A6
	assert .tiles-.pieces == 4*344
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set03.chr":0..$664		; $8E89A7-$8E900A
