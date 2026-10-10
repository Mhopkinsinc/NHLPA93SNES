; $8B8000-$8B9002  ROM $58000-$59002: the 92G playoff code: NewPO, FigureJoy, Opening/Opening4, ReadPassBits, ResolveGames; then SpriteSet5
; (frame set 5: the falls), tiles continue to bank8B_F000.
org $8B8000
NewPO:		;auto: CODE_8B8000. 92G NewPO: new playoffs with the same team 1: random postarts whose playoffseats hold OptTeam1 (all-star teams count as team 23), clear the series, then maketree
	lda.w #32		; $8B8000: A9 20 00  d0 = random 0-31
	sta.b d0		; $8B8003: 85 53
	jsl.l randomd0		; $8B8005: 22 A3 97 80
.top:
	lda.b d0		; $8B8009: A5 53
	inc a		; $8B800B: 1A
	and.w #$001F		; $8B800C: 29 1F 00
	sta.b d0		; $8B800F: 85 53
	asl a		; $8B8011: 0A
	asl a		; $8B8012: 0A
	asl a		; $8B8013: 0A
	asl a		; $8B8014: 0A
	adc.w #playoffseats		; $8B8015: 69 B8 C4  a0 = playoffseats + 16 * d0
	sta.b a0		; $8B8018: 85 33
	lda.w #playoffseats>>16		; $8B801A: A9 83 00
	sta.b a0+2		; $8B801D: 85 35
	lda.w #15		; $8B801F: A9 0F 00
	sta.b d1		; $8B8022: 85 57
	lda.w OptTeam1		; $8B8024: AD 04 16
	sta.b d2		; $8B8027: 85 5B
	cmp.w #24		; $8B8029: C9 18 00  all-star teams (24+): team 23
	bcc .loop		; $8B802C: 90 05
	lda.w #23		; $8B802E: A9 17 00
	sta.b d2		; $8B8031: 85 5B
.loop:
	lda.b [a0]		; $8B8033: A7 33
	inc.b a0		; $8B8035: E6 33
	and.w #$00FF		; $8B8037: 29 FF 00
	cmp.b d2		; $8B803A: C5 5B
	beq .found		; $8B803C: F0 06
	dec.b d1		; $8B803E: C6 57
	bpl .loop		; $8B8040: 10 F1
	bra .top		; $8B8042: 80 C5
.found:
	lda.b d1		; $8B8044: A5 57  potreeteam = slot of OptTeam1
	eor.w #$000F		; $8B8046: 49 0F 00
	sta.b d1		; $8B8049: 85 57
	sta.w potreeteam		; $8B804B: 8D 73 04
	lda.b d0		; $8B804E: A5 53
	sta.w postarts		; $8B8050: 8D 51 04
	stz.w gamelevel		; $8B8053: 9C 4A 01
	lda.w #7		; $8B8056: A9 07 00  bosgames 7: single games (OptPlayMode 2)
	sta.b bosgames		; $8B8059: 85 D6
	lda.w OptPlayMode		; $8B805B: AD 00 16
	cmp.w #2		; $8B805E: C9 02 00
	beq .n0		; $8B8061: F0 16
	stz.b bosgames		; $8B8063: 64 D6  best of seven: clear the series
	lda.w #7		; $8B8065: A9 07 00
	sta.b d0		; $8B8068: 85 53
	ldx.w #$0000		; $8B806A: A2 00 00
.cg:
	stz.w gspotwins,x		; $8B806D: 9E 9F 15
	stz.w gspobwins,x		; $8B8070: 9E AF 15
	inx		; $8B8073: E8
	inx		; $8B8074: E8
	dec.b d0		; $8B8075: C6 53
	bpl .cg		; $8B8077: 10 F4
.n0:
	jml.l maketree		; $8B8079: 5C 00 80 8D  bank $8D: maketree
FigureJoy:		;auto: CODE_8B807D. 92G FigureJoy: set cont1team/cont2team: in the playoffs from the po team's game (gamenum, OptTeam2, HomeTeam/VisTeam) and pojoy; else from OptPlayers. Not after the
		;   demo (notdemo = 0)
	stz.w cont1team		; $8B807D: 9C 96 12
	stz.w cont2team		; $8B8080: 9C 98 12
	lda.w notdemo		; $8B8083: AD 0E 16  after the demo: no controller teams
	beq .rtl		; $8B8086: F0 43
	lda.w OptPlayMode		; $8B8088: AD 00 16
	bne .po		; $8B808B: D0 03
	jmp.w .fjnpo		; $8B808D: 4C 17 81
.po:
	jsl.l GetShifter		; $8B8090: 22 A4 D5 85
	lda.w #potree		; $8B8094: A9 53 04  d2 = the po team
	sta.b a0		; $8B8097: 85 33
	lda.w #$0000		; $8B8099: A9 00 00
	sta.b a0+2		; $8B809C: 85 35
	ldy.w potreeteam		; $8B809E: AC 73 04
	lda.b [a0],y		; $8B80A1: B7 33
	and.w #$00FF		; $8B80A3: 29 FF 00
	sta.b d2		; $8B80A6: 85 5B
	lda.b d1		; $8B80A8: A5 57
	asl a		; $8B80AA: 0A
	sta.b a1		; $8B80AB: 85 37
	lda.w #$FFFF		; $8B80AD: A9 FF FF  gamenum -1: po team not playing
	sta.w gamenum		; $8B80B0: 8D 4C 01
	stz.b d0		; $8B80B3: 64 53
.f0:
	lda.b d2		; $8B80B5: A5 5B
	ldy.b a1		; $8B80B7: A4 37
	cmp.w gst1,y		; $8B80B9: D9 7F 15
	beq .it1		; $8B80BC: F0 1B
	cmp.w gst2,y		; $8B80BE: D9 8F 15
	beq .it2		; $8B80C1: F0 09
	dec.b a1		; $8B80C3: C6 37
	dec.b a1		; $8B80C5: C6 37
	dec.b d1		; $8B80C7: C6 57
	bpl .f0		; $8B80C9: 10 EA
.rtl:		;po team not in the playoffs
	rtl		; $8B80CB: 6B
.it2:
	lda.w #4		; $8B80CC: A9 04 00
	sta.b d0		; $8B80CF: 85 53
	lda.w gst1,y		; $8B80D1: B9 7F 15
	sta.w OptTeam2		; $8B80D4: 8D 06 16
	bra .itx		; $8B80D7: 80 08
.it1:
	stz.b d0		; $8B80D9: 64 53
	lda.w gst2,y		; $8B80DB: B9 8F 15
	sta.w OptTeam2		; $8B80DE: 8D 06 16
.itx:
	lda.b d0		; $8B80E1: A5 53
	clc		; $8B80E3: 18
	adc.w pojoy		; $8B80E4: 6D 4F 04
	sta.b d0		; $8B80E7: 85 53
	lda.b d1		; $8B80E9: A5 57
	sta.w gamenum		; $8B80EB: 8D 4C 01
	lda.w gst1,y		; $8B80EE: B9 7F 15
	sta.w HomeTeam		; $8B80F1: 8D 9A 12
	lda.w gst2,y		; $8B80F4: B9 8F 15
	sta.w VisTeam		; $8B80F7: 8D 9C 12
	asl.b d0		; $8B80FA: 06 53
	asl.b d0		; $8B80FC: 06 53
	lda.w #.pojoylist		; $8B80FE: A9 36 81  .pojoylist entry (pojoy + 4 if the po team is team 2)
	sta.b a0		; $8B8101: 85 33
	lda.w #.pojoylist>>16		; $8B8103: A9 8B 00
	sta.b a0+2		; $8B8106: 85 35
	ldy.b d0		; $8B8108: A4 53
	lda.b [a0],y		; $8B810A: B7 33
	sta.w cont1team		; $8B810C: 8D 96 12
	iny		; $8B810F: C8
	iny		; $8B8110: C8
	lda.b [a0],y		; $8B8111: B7 33
	sta.w cont2team		; $8B8113: 8D 98 12
	rtl		; $8B8116: 6B
.fjnpo:
	lda.w OptPlayers		; $8B8117: AD 02 16  regular season: .noplist by OptPlayers
	asl a		; $8B811A: 0A
	asl a		; $8B811B: 0A
	sta.b d0		; $8B811C: 85 53
	tay		; $8B811E: A8
	lda.w #.noplist		; $8B811F: A9 56 81
	sta.b a0		; $8B8122: 85 33
	lda.w #.noplist>>16		; $8B8124: A9 8B 00
	sta.b a0+2		; $8B8127: 85 35
	lda.b [a0],y		; $8B8129: B7 33
	sta.w cont1team		; $8B812B: 8D 96 12
	iny		; $8B812E: C8
	iny		; $8B812F: C8
	lda.b [a0],y		; $8B8130: B7 33
	sta.w cont2team		; $8B8132: 8D 98 12
	rtl		; $8B8135: 6B
.pojoylist:		;92G .pojoylist: cont1team, cont2team by pojoy 0-3 (the po team as team 1), then as team 2
	dw 1,0		; $8B8136
	dw 1,1		; $8B813A
	dw 1,2		; $8B813E
	dw 2,1		; $8B8142
	dw 2,0		; $8B8146
	dw 2,2		; $8B814A
	dw 2,1		; $8B814E
	dw 1,2		; $8B8152
.noplist:		;92G .noplist: cont1team, cont2team by OptPlayers
	dw 0,0		; $8B8156
	dw 1,0		; $8B815A
	dw 2,0		; $8B815E
	dw 1,1		; $8B8162
	dw 1,2		; $8B8166
Opening:		;auto: CODE_8B816A (from Start, $80C407). 92G Opening: TitleScreen, then Restart (93G Opening2: the setup screens)
	jsl.l TitleScreen		; $8B816A: 22 B0 F2 88
	jml.l $83FA87		; $8B816E: 5C 87 FA 83  Restart
Opening4:		;auto: CODE_8B8172 (from ContinuePlayoffs, far8B8172). 92G Opening4: ScoutingReport ($8FDC0D), then StartGame
	jsl.l ScoutingReport		; $8B8172: 22 0D DC 8F  bank $8F: 93G ScoutingReport
	jml.l StartGame		; $8B8176: 5C 0C FD 89
ReadPassBits:		;auto: CODE_8B817A. 92G ReadPassBits: passbits back into the playoff state (SuperDiv by each range, the reverse of WritePassBits); a bad 9-bit checksum sets postarts -1
	lda.w #512		; $8B817A: A9 00 02  checksum first (range 512)
	sta.b d0		; $8B817D: 85 53
	jsl.l SuperDiv		; $8B817F: 22 FA F5 80
	lda.b d0		; $8B8183: A5 53
	pha		; $8B8185: 48
	stz.b d7		; $8B8186: 64 6F
	lda.w #7		; $8B8188: A9 07 00
	sta.b d2		; $8B818B: 85 5B
	lda.w #14		; $8B818D: A9 0E 00
	sta.b a1		; $8B8190: 85 37
.gs:		;the 8 series scores, range 5
	ldy.b a1		; $8B8192: A4 37
	lda.w gsflags,y		; $8B8194: B9 EF 15  gsftf off
	and.w #$FFFB		; $8B8197: 29 FB FF
	sta.w gsflags,y		; $8B819A: 99 EF 15
	lda.w #5		; $8B819D: A9 05 00
	sta.b d0		; $8B81A0: 85 53
	jsl.l .sd		; $8B81A2: 22 47 82 8B
	lda.b d0		; $8B81A6: A5 53
	ldy.b a1		; $8B81A8: A4 37
	sta.w gspobwins,y		; $8B81AA: 99 AF 15
	cmp.w #4		; $8B81AD: C9 04 00  4 wins: gsftf (series over)
	bne .g1		; $8B81B0: D0 09
	lda.w gsflags,y		; $8B81B2: B9 EF 15
	ora.w #$0004		; $8B81B5: 09 04 00
	sta.w gsflags,y		; $8B81B8: 99 EF 15
.g1:
	lda.w #5		; $8B81BB: A9 05 00
	sta.b d0		; $8B81BE: 85 53
	jsl.l .sd		; $8B81C0: 22 47 82 8B
	ldy.b a1		; $8B81C4: A4 37
	lda.b d0		; $8B81C6: A5 53
	sta.w gspotwins,y		; $8B81C8: 99 9F 15
	cmp.w #4		; $8B81CB: C9 04 00
	bne .g2		; $8B81CE: D0 09
	lda.w gsflags,y		; $8B81D0: B9 EF 15
	ora.w #$0004		; $8B81D3: 09 04 00
	sta.w gsflags,y		; $8B81D6: 99 EF 15
.g2:
	dec.b a1		; $8B81D9: C6 37
	dec.b a1		; $8B81DB: C6 37
	dec.b d2		; $8B81DD: C6 5B
	bpl .gs		; $8B81DF: 10 B1
	lda.w #$4000		; $8B81E1: A9 00 40
	sta.b d0		; $8B81E4: 85 53
	jsl.l .sd		; $8B81E6: 22 47 82 8B
	lda.b d0		; $8B81EA: A5 53
	sta.w WinBits		; $8B81EC: 8D E7 08
	lda.w #4		; $8B81EF: A9 04 00
	sta.b d0		; $8B81F2: 85 53
	jsl.l .sd		; $8B81F4: 22 47 82 8B
	lda.b d0		; $8B81F8: A5 53
	sta.w pojoy		; $8B81FA: 8D 4F 04
	lda.w #16		; $8B81FD: A9 10 00
	sta.b d0		; $8B8200: 85 53
	jsl.l .sd		; $8B8202: 22 47 82 8B
	lda.b d0		; $8B8206: A5 53
	sta.w potreeteam		; $8B8208: 8D 73 04
	lda.w #4		; $8B820B: A9 04 00
	sta.b d0		; $8B820E: 85 53
	jsl.l .sd		; $8B8210: 22 47 82 8B
	lda.b d0		; $8B8214: A5 53
	sta.w gamelevel		; $8B8216: 8D 4A 01
	lda.w #8		; $8B8219: A9 08 00
	sta.b d0		; $8B821C: 85 53
	jsl.l .sd		; $8B821E: 22 47 82 8B
	lda.b d0		; $8B8222: A5 53
	sta.b bosgames		; $8B8224: 85 D6
	lda.w #32		; $8B8226: A9 20 00
	sta.b d0		; $8B8229: 85 53
	jsl.l .sd		; $8B822B: 22 47 82 8B
	lda.b d0		; $8B822F: A5 53
	sta.w postarts		; $8B8231: 8D 51 04
	lda.b d7		; $8B8234: A5 6F
	and.w #$01FF		; $8B8236: 29 FF 01
	sta.b tmp0		; $8B8239: 85 73
	pla		; $8B823B: 68
	cmp.b tmp0		; $8B823C: C5 73
	beq .rtl		; $8B823E: F0 06
	lda.w #$FFFF		; $8B8240: A9 FF FF  bad password
	sta.w postarts		; $8B8243: 8D 51 04
.rtl:
	rtl		; $8B8246: 6B
.sd:		;92G .sd: d0 = passbits mod d0 (SuperDiv), added to the checksum d7
	jsl.l SuperDiv		; $8B8247: 22 FA F5 80
	lda.b d7		; $8B824B: A5 6F
	clc		; $8B824D: 18
	adc.b d0		; $8B824E: 65 53
	sta.b d7		; $8B8250: 85 6F
	rtl		; $8B8252: 6B
ResolveGames:		;auto: CODE_8B8253. 92G ResolveGames: the played game's score into its gstruct, wins for all series of the round; when the round is over (or single games) WinBits and gamelevel move on
	lda.w gamenum		; $8B8253: AD 4C 01
	asl a		; $8B8256: 0A
	sta.b d0		; $8B8257: 85 53
	stz.b a0		; $8B8259: 64 33  copy the score of the played game
	tay		; $8B825B: A8
	lda.w tmscore		; $8B825C: AD D6 13
	sta.w gss1,y		; $8B825F: 99 CF 15
	lda.w tmscore+2		; $8B8262: AD D8 13
	sta.w gss2,y		; $8B8265: 99 DF 15
	jsl.l GetShifter		; $8B8268: 22 A4 D5 85
	lda.b d1		; $8B826C: A5 57
	asl a		; $8B826E: 0A
	sta.b a0		; $8B826F: 85 33
	lda.b bosgames		; $8B8271: A5 D6
	cmp.w #7		; $8B8273: C9 07 00
	bne .b0		; $8B8276: D0 03
	jmp.w .notbos		; $8B8278: 4C 9C 83
.b0:
	ldy.b a0		; $8B827B: A4 33
	lda.w #4		; $8B827D: A9 04 00
	cmp.w gspotwins,y		; $8B8280: D9 9F 15
	beq .b1		; $8B8283: F0 2C
	cmp.w gspobwins,y		; $8B8285: D9 AF 15
	beq .b1		; $8B8288: F0 27
	stz.b d3		; $8B828A: 64 5F
	lda.w gsflags,y		; $8B828C: B9 EF 15  gsflags bit 0 (gsftf): teams swapped
	bit.w #$0001		; $8B828F: 89 01 00
	beq .nf		; $8B8292: F0 05
	lda.w #$0010		; $8B8294: A9 10 00
	sta.b d3		; $8B8297: 85 5F
.nf:
	lda.w gss1,y		; $8B8299: B9 CF 15
	cmp.w gss2,y		; $8B829C: D9 DF 15
	bpl .ns1		; $8B829F: 10 07
	lda.b d3		; $8B82A1: A5 5F
	eor.w #$0010		; $8B82A3: 49 10 00
	sta.b d3		; $8B82A6: 85 5F
.ns1:
	lda.b a0		; $8B82A8: A5 33
	clc		; $8B82AA: 18
	adc.b d3		; $8B82AB: 65 5F
	tax		; $8B82AD: AA
	inc.w gspotwins,x		; $8B82AE: FE 9F 15
.b1:
	dec.b a0		; $8B82B1: C6 33
	dec.b a0		; $8B82B3: C6 33
	dec.b d1		; $8B82B5: C6 57
	bpl .b0		; $8B82B7: 10 C2
	inc.b bosgames		; $8B82B9: E6 D6  next game of the series
	lda.b bosgames		; $8B82BB: A5 D6
	cmp.w #7		; $8B82BD: C9 07 00
	bne .more		; $8B82C0: D0 03
	jmp.w .nextround		; $8B82C2: 4C 4A 83
.more:
	lda.w gamenum		; $8B82C5: AD 4C 01
	asl a		; $8B82C8: 0A
	sta.b a0		; $8B82C9: 85 33
	tay		; $8B82CB: A8
	lda.w #4		; $8B82CC: A9 04 00
	cmp.w gspotwins,y		; $8B82CF: D9 9F 15
	beq .cround		; $8B82D2: F0 08
	cmp.w gspobwins,y		; $8B82D4: D9 AF 15
	beq .cround		; $8B82D7: F0 03
	jmp.w .rtl		; $8B82D9: 4C 9B 83
.cround:		;finish the other series of the round
	lda.w gamelevel		; $8B82DC: AD 4A 01
	sec		; $8B82DF: 38
	sbc.w #3		; $8B82E0: E9 03 00
	bmi .lt		; $8B82E3: 30 04
	bvs .cr		; $8B82E5: 70 04
	bra .nextround		; $8B82E7: 80 61
.lt:
	bvs .nextround		; $8B82E9: 70 5F
.cr:
	jsl.l GetShifter		; $8B82EB: 22 A4 D5 85
	lda.b d1		; $8B82EF: A5 57
	asl a		; $8B82F1: 0A
	sta.b a0		; $8B82F2: 85 33
.c0:
	ldy.b a0		; $8B82F4: A4 33
	lda.b d1		; $8B82F6: A5 57
	cmp.w gamenum		; $8B82F8: CD 4C 01
	beq .c1		; $8B82FB: F0 2E
	lda.w #4		; $8B82FD: A9 04 00
	cmp.w gspotwins,y		; $8B8300: D9 9F 15
	beq .c1		; $8B8303: F0 26
	cmp.w gspobwins,y		; $8B8305: D9 AF 15
	beq .c1		; $8B8308: F0 21
	lda.w gspotwins,y		; $8B830A: B9 9F 15
	inc a		; $8B830D: 1A
	sta.w gspotwins,y		; $8B830E: 99 9F 15
	lda.w #200		; $8B8311: A9 C8 00  random series result: 50/50 per game
	jsl.l randoma		; $8B8314: 22 8B AE 80
	lsr a		; $8B8318: 4A
	bcc .c0		; $8B8319: 90 D9
	lda.w gspotwins,y		; $8B831B: B9 9F 15
	dec a		; $8B831E: 3A
	sta.w gspotwins,y		; $8B831F: 99 9F 15
	lda.w gspobwins,y		; $8B8322: B9 AF 15
	inc a		; $8B8325: 1A
	sta.w gspobwins,y		; $8B8326: 99 AF 15
	bra .c0		; $8B8329: 80 C9
.c1:
	dec.b a0		; $8B832B: C6 33
	dec.b a0		; $8B832D: C6 33
	dec.b d1		; $8B832F: C6 57
	bpl .c0		; $8B8331: 10 C1
	jsl.l WritePassBits		; $8B8333: 22 A9 84 88  sf3alttree: passbits before the rest was resolved
	ldy.w #$000E		; $8B8337: A0 0E 00
.cp:
	lda.w passbits,y		; $8B833A: B9 24 16
	sta.w tpassbits,y		; $8B833D: 99 34 16
	dey		; $8B8340: 88
	dey		; $8B8341: 88
	bpl .cp		; $8B8342: 10 F6
	lda.w #sf3alttree		; $8B8344: A9 04 00
	tsb.w sflags3		; $8B8347: 0C 90 12
.nextround:
	stz.b bosgames		; $8B834A: 64 D6
	jsl.l GetShifter		; $8B834C: 22 A4 D5 85
	lda.b d1		; $8B8350: A5 57
	asl a		; $8B8352: 0A
	sta.b a0		; $8B8353: 85 33
	stz.b d3		; $8B8355: 64 5F
.n0:
	ldy.b a0		; $8B8357: A4 33
	lda.w gspotwins,y		; $8B8359: B9 9F 15
	cmp.w #$0004		; $8B835C: C9 04 00
	beq .n1		; $8B835F: F0 0A
	lda.b d1		; $8B8361: A5 57
	asl a		; $8B8363: 0A
	tax		; $8B8364: AA
	lda.l BitMaskTable,x		; $8B8365: BF 39 FC 82
	tsb.b d3		; $8B8369: 04 5F
.n1:
	lda.w #$0000		; $8B836B: A9 00 00
	sta.w gspotwins,y		; $8B836E: 99 9F 15
	sta.w gspobwins,y		; $8B8371: 99 AF 15
	dec.b a0		; $8B8374: C6 33
	dec.b a0		; $8B8376: C6 33
	dec.b d1		; $8B8378: C6 57
	bpl .n0		; $8B837A: 10 DB
	lda.b d2		; $8B837C: A5 5B  WinBits: the winners of level d2
	asl a		; $8B837E: 0A
	tax		; $8B837F: AA
	lda.l BitMaskTable,x		; $8B8380: BF 39 FC 82
	sta.b mula		; $8B8384: 85 7D
	dec a		; $8B8386: 3A
	and.w WinBits		; $8B8387: 2D E7 08
	sta.w WinBits		; $8B838A: 8D E7 08
	lda.b d3		; $8B838D: A5 5F
	sta.b mulb		; $8B838F: 85 83
	jsl.l mulu16		; $8B8391: 22 1C 87 8D  bank $8D: 16-bit multiply
	tsb.w WinBits		; $8B8395: 0C E7 08
	inc.w gamelevel		; $8B8398: EE 4A 01
.rtl:
	rtl		; $8B839B: 6B
.notbos:		;single games
	stz.b d3		; $8B839C: 64 5F
.s0:
	ldy.b a0		; $8B839E: A4 33
	lda.w gss2,y		; $8B83A0: B9 DF 15
	cmp.w gss1,y		; $8B83A3: D9 CF 15
	bcc .s1		; $8B83A6: 90 0A
	lda.b d1		; $8B83A8: A5 57
	asl a		; $8B83AA: 0A
	tax		; $8B83AB: AA
	lda.l BitMaskTable,x		; $8B83AC: BF 39 FC 82
	tsb.b d3		; $8B83B0: 04 5F
.s1:
	lda.w gsflags,y		; $8B83B2: B9 EF 15
	bit.w #$0001		; $8B83B5: 89 01 00
	beq .s2		; $8B83B8: F0 0C
	lda.b d1		; $8B83BA: A5 57
	asl a		; $8B83BC: 0A
	tax		; $8B83BD: AA
	lda.l BitMaskTable,x		; $8B83BE: BF 39 FC 82
	eor.b d3		; $8B83C2: 45 5F
	sta.b d3		; $8B83C4: 85 5F
.s2:
	dec.b a0		; $8B83C6: C6 33
	dec.b a0		; $8B83C8: C6 33
	dec.b d1		; $8B83CA: C6 57
	bpl .s0		; $8B83CC: 10 D0
	lda.b d2		; $8B83CE: A5 5B
	asl a		; $8B83D0: 0A
	tax		; $8B83D1: AA
	lda.l BitMaskTable,x		; $8B83D2: BF 39 FC 82
	sta.b mula		; $8B83D6: 85 7D
	dec a		; $8B83D8: 3A
	and.w WinBits		; $8B83D9: 2D E7 08
	sta.w WinBits		; $8B83DC: 8D E7 08
	lda.b d3		; $8B83DF: A5 5F
	sta.b mulb		; $8B83E1: 85 83
	jsl.l mulu16		; $8B83E3: 22 1C 87 8D  bank $8D: 16-bit multiply
	tsb.w WinBits		; $8B83E7: 0C E7 08
	inc.w gamelevel		; $8B83EA: EE 4A 01
	rtl		; $8B83ED: 6B
SpriteSet5:		;frame set 5 (falls: SPFfallback, SPFfallfwd): frames 273-336
	dw 64		; $8B83EE frames
	dw 533		; $8B83F0 pieces
	dw 896		; $8B83F2 tiles
	dw .pieces-SpriteSet5		; $8B83F4
	dw .tiles-SpriteSet5		; $8B83F6
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,5,13,24,31,36,42,50		; $8B83F8
	dw 57,65,74,83,91,98,108,117		; $8B8408
	dw 124,132,142,152,161,167,177,187		; $8B8418
	dw 196,205,212,221,229,234,244,253		; $8B8428
	dw 260,263,271,278,283,292,303,314		; $8B8438
	dw 321,331,341,349,356,365,375,384		; $8B8448
	dw 391,398,408,416,423,432,443,455		; $8B8458
	dw 463,471,482,490,498,505,515,526		; $8B8468
	dw 533		; $8B8478
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set05.pieces"		; $8B847A-$8B8CCD
	assert .tiles-.pieces == 4*533
.tiles:		;896 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set05.chr":0..$335		; $8B8CCE-$8B9002
