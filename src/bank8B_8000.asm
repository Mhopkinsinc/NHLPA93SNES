; $8B8000-$8B9002  ROM $58000-$59002: the 92G playoff code: NewPO, FigureJoy, Opening/Opening4, ReadPassBits, ResolveGames; then SpriteSet5
; (frame set 5: the falls), tiles continue to bank8B_F000.
org $8B8000
NewPO:		;92G NewPO: new playoffs with the same team 1: random postarts whose playoffseats hold OptTeam1 (all-star teams count as team 23), clear the series, then maketree
	lda.w #32		; d0 = random 0-31
	sta.b d0
	jsl.l randomd0
.top:
	lda.b d0
	inc a
	and.w #$001F
	sta.b d0
	asl a
	asl a
	asl a
	asl a
	adc.w #playoffseats		; a0 = playoffseats + 16 * d0
	sta.b a0
	lda.w #playoffseats>>16
	sta.b a0+2
	lda.w #15
	sta.b d1
	lda.w OptTeam1
	sta.b d2
	cmp.w #24		; all-star teams (24+): team 23
	bcc .loop
	lda.w #23
	sta.b d2
.loop:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	cmp.b d2
	beq .found
	dec.b d1
	bpl .loop
	bra .top
.found:
	lda.b d1		; potreeteam = slot of OptTeam1
	eor.w #$000F
	sta.b d1
	sta.w potreeteam
	lda.b d0
	sta.w postarts
	stz.w gamelevel
	lda.w #7		; bosgames 7: single games (OptPlayMode 2)
	sta.b bosgames
	lda.w OptPlayMode
	cmp.w #2
	beq .n0
	stz.b bosgames		; best of seven: clear the series
	lda.w #7
	sta.b d0
	ldx.w #$0000
.cg:
	stz.w gspotwins,x
	stz.w gspobwins,x
	inx
	inx
	dec.b d0
	bpl .cg
.n0:
	jml.l maketree		; bank $8D: maketree
FigureJoy:		;92G FigureJoy: set cont1team/cont2team: in the playoffs from the po team's game (gamenum, OptTeam2, HomeTeam/VisTeam) and pojoy; else from OptPlayers. Not after the
		;   demo (notdemo = 0)
	stz.w cont1team
	stz.w cont2team
	lda.w notdemo		; after the demo: no controller teams
	beq .rtl
	lda.w OptPlayMode
	bne .po
	jmp.w .fjnpo
.po:
	jsl.l GetShifter
	lda.w #potree		; d2 = the po team
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	ldy.w potreeteam
	lda.b [a0],y
	and.w #$00FF
	sta.b d2
	lda.b d1
	asl a
	sta.b a1
	lda.w #$FFFF		; gamenum -1: po team not playing
	sta.w gamenum
	stz.b d0
.f0:
	lda.b d2
	ldy.b a1
	cmp.w gst1,y
	beq .it1
	cmp.w gst2,y
	beq .it2
	dec.b a1
	dec.b a1
	dec.b d1
	bpl .f0
.rtl:		;po team not in the playoffs
	rtl
.it2:
	lda.w #4
	sta.b d0
	lda.w gst1,y
	sta.w OptTeam2
	bra .itx
.it1:
	stz.b d0
	lda.w gst2,y
	sta.w OptTeam2
.itx:
	lda.b d0
	clc
	adc.w pojoy
	sta.b d0
	lda.b d1
	sta.w gamenum
	lda.w gst1,y
	sta.w HomeTeam
	lda.w gst2,y
	sta.w VisTeam
	asl.b d0
	asl.b d0
	lda.w #.pojoylist		; .pojoylist entry (pojoy + 4 if the po team is team 2)
	sta.b a0
	lda.w #.pojoylist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	sta.w cont1team
	iny
	iny
	lda.b [a0],y
	sta.w cont2team
	rtl
.fjnpo:
	lda.w OptPlayers		; regular season: .noplist by OptPlayers
	asl a
	asl a
	sta.b d0
	tay
	lda.w #.noplist
	sta.b a0
	lda.w #.noplist>>16
	sta.b a0+2
	lda.b [a0],y
	sta.w cont1team
	iny
	iny
	lda.b [a0],y
	sta.w cont2team
	rtl
.pojoylist:		;92G .pojoylist: cont1team, cont2team by pojoy 0-3 (the po team as team 1), then as team 2
	dw 1,0
	dw 1,1
	dw 1,2
	dw 2,1
	dw 2,0
	dw 2,2
	dw 2,1
	dw 1,2
.noplist:		;92G .noplist: cont1team, cont2team by OptPlayers
	dw 0,0
	dw 1,0
	dw 2,0
	dw 1,1
	dw 1,2
Opening:		;92G Opening: TitleScreen, then Restart (93G Opening2: the setup screens)
	jsl.l TitleScreen
	jml.l Restart
Opening4:		;92G Opening4: ScoutingReport ($8FDC0D), then StartGame
	jsl.l ScoutingReport		; bank $8F: 93G ScoutingReport
	jml.l StartGame
ReadPassBits:		;92G ReadPassBits: passbits back into the playoff state (SuperDiv by each range, the reverse of WritePassBits); a bad 9-bit checksum sets postarts -1
	lda.w #512		; checksum first (range 512)
	sta.b d0
	jsl.l SuperDiv
	lda.b d0
	pha
	stz.b d7
	lda.w #7
	sta.b d2
	lda.w #14
	sta.b a1
.gs:		;the 8 series scores, range 5
	ldy.b a1
	lda.w gsflags,y		; gsftf off
	and.w #$FFFB
	sta.w gsflags,y
	lda.w #5
	sta.b d0
	jsl.l .sd
	lda.b d0
	ldy.b a1
	sta.w gspobwins,y
	cmp.w #4		; 4 wins: gsftf (series over)
	bne .g1
	lda.w gsflags,y
	ora.w #$0004
	sta.w gsflags,y
.g1:
	lda.w #5
	sta.b d0
	jsl.l .sd
	ldy.b a1
	lda.b d0
	sta.w gspotwins,y
	cmp.w #4
	bne .g2
	lda.w gsflags,y
	ora.w #$0004
	sta.w gsflags,y
.g2:
	dec.b a1
	dec.b a1
	dec.b d2
	bpl .gs
	lda.w #$4000
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w WinBits
	lda.w #4
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w pojoy
	lda.w #16
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w potreeteam
	lda.w #4
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w gamelevel
	lda.w #8
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.b bosgames
	lda.w #32
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w postarts
	lda.b d7
	and.w #$01FF
	sta.b tmp0
	pla
	cmp.b tmp0
	beq .rtl
	lda.w #$FFFF		; bad password
	sta.w postarts
.rtl:
	rtl
.sd:		;92G .sd: d0 = passbits mod d0 (SuperDiv), added to the checksum d7
	jsl.l SuperDiv
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	rtl
ResolveGames:		;92G ResolveGames: the played game's score into its gstruct, wins for all series of the round; when the round is over (or single games) WinBits and gamelevel move on
	lda.w gamenum
	asl a
	sta.b d0
	stz.b a0		; copy the score of the played game
	tay
	lda.w tmscore
	sta.w gss1,y
	lda.w tmscore+2
	sta.w gss2,y
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
	lda.b bosgames
	cmp.w #7
	bne .b0
	jmp.w .notbos
.b0:
	ldy.b a0
	lda.w #4
	cmp.w gspotwins,y
	beq .b1
	cmp.w gspobwins,y
	beq .b1
	stz.b d3
	lda.w gsflags,y		; gsflags bit 0 (gsftf): teams swapped
	bit.w #$0001
	beq .nf
	lda.w #$0010
	sta.b d3
.nf:
	lda.w gss1,y
	cmp.w gss2,y
	bpl .ns1
	lda.b d3
	eor.w #$0010
	sta.b d3
.ns1:
	lda.b a0
	clc
	adc.b d3
	tax
	inc.w gspotwins,x
.b1:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .b0
	inc.b bosgames		; next game of the series
	lda.b bosgames
	cmp.w #7
	bne .more
	jmp.w .nextround
.more:
	lda.w gamenum
	asl a
	sta.b a0
	tay
	lda.w #4
	cmp.w gspotwins,y
	beq .cround
	cmp.w gspobwins,y
	beq .cround
	jmp.w .rtl
.cround:		;finish the other series of the round
	lda.w gamelevel
	sec
	sbc.w #3
	bmi .lt
	bvs .cr
	bra .nextround
.lt:
	bvs .nextround
.cr:
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.c0:
	ldy.b a0
	lda.b d1
	cmp.w gamenum
	beq .c1
	lda.w #4
	cmp.w gspotwins,y
	beq .c1
	cmp.w gspobwins,y
	beq .c1
	lda.w gspotwins,y
	inc a
	sta.w gspotwins,y
	lda.w #200		; random series result: 50/50 per game
	jsl.l randoma
	lsr a
	bcc .c0
	lda.w gspotwins,y
	dec a
	sta.w gspotwins,y
	lda.w gspobwins,y
	inc a
	sta.w gspobwins,y
	bra .c0
.c1:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .c0
	jsl.l WritePassBits		; sf3alttree: passbits before the rest was resolved
	ldy.w #$000E
.cp:
	lda.w passbits,y
	sta.w tpassbits,y
	dey
	dey
	bpl .cp
	lda.w #sf3alttree
	tsb.w sflags3
.nextround:
	stz.b bosgames
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
	stz.b d3
.n0:
	ldy.b a0
	lda.w gspotwins,y
	cmp.w #$0004
	beq .n1
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	tsb.b d3
.n1:
	lda.w #$0000
	sta.w gspotwins,y
	sta.w gspobwins,y
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .n0
	lda.b d2		; WinBits: the winners of level d2
	asl a
	tax
	lda.l BitMaskTable,x
	sta.b mula
	dec a
	and.w WinBits
	sta.w WinBits
	lda.b d3
	sta.b mulb
	jsl.l mulu16		; bank $8D: 16-bit multiply
	tsb.w WinBits
	inc.w gamelevel
.rtl:
	rtl
.notbos:		;single games
	stz.b d3
.s0:
	ldy.b a0
	lda.w gss2,y
	cmp.w gss1,y
	bcc .s1
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	tsb.b d3
.s1:
	lda.w gsflags,y
	bit.w #$0001
	beq .s2
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	eor.b d3
	sta.b d3
.s2:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .s0
	lda.b d2
	asl a
	tax
	lda.l BitMaskTable,x
	sta.b mula
	dec a
	and.w WinBits
	sta.w WinBits
	lda.b d3
	sta.b mulb
	jsl.l mulu16		; bank $8D: 16-bit multiply
	tsb.w WinBits
	inc.w gamelevel
	rtl
SpriteSet5:		;frame set 5 (falls: SPFfallback, SPFfallfwd): frames 273-336
	dw 64		; frames
	dw 533		; pieces
	dw 896		; tiles
	dw .pieces-SpriteSet5
	dw .tiles-SpriteSet5
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,5,13,24,31,36,42,50
	dw 57,65,74,83,91,98,108,117
	dw 124,132,142,152,161,167,177,187
	dw 196,205,212,221,229,234,244,253
	dw 260,263,271,278,283,292,303,314
	dw 321,331,341,349,356,365,375,384
	dw 391,398,408,416,423,432,443,455
	dw 463,471,482,490,498,505,515,526
	dw 533
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set05.pieces"		; $8B847A-$8B8CCD
	assert .tiles-.pieces == 4*533
.tiles:		;896 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set05.chr":0..$335		; $8B8CCE-$8B9002
