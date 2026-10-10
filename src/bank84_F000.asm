; $84EF3C-$84FFFF  ROM $26F3C-$27FFF: HotList, UpdateScoutingDisplay, ScrollDisplayUp (hockey93_07), PlayoffTiles, InitSortObjects and
; its tables, Readjoy12, DisplayStats (92G penalty.asm), GetNameandAttrib, attribjmp and its handlers (stats93), $FF fill.
; Starts at HotList (boundary moved from $84F00C).
org $84EF3C
HotList:		;93G HotList: hot spot (stick blade) x, y bytes for every sprite frame (763 pairs, data/HotList.bin), read by GetHot
	incbin "../data/HotList.bin"		; $84EF3C-$84F531
HotListEnd:
UpdateScoutingDisplay:		;auto: CODE_84F532. 93G UpdateScoutingDisplay (hockey93_07): when ScoutingReportTimer runs out (at once with asv), print the next word of ScoutingReportText. ~ { } [ ] print
		;   a team or goalie name
	lda.w ScoutingReportTimer		; $84F532: AD EF 08  text finished ($7FFF)
	sec		; $84F535: 38
	sbc.w #$1000		; $84F536: E9 00 10
	beq .tm		; $84F539: F0 08
	bmi .v1		; $84F53B: 30 04
	bvs .tm		; $84F53D: 70 04
	bra .rtl		; $84F53F: 80 45
.v1:
	bvs .rtl		; $84F541: 70 43
.tm:
	lda.w asv		; $84F543: AD 44 16  asv: no delay
	bmi .go		; $84F546: 30 05
	dec.w ScoutingReportTimer		; $84F548: CE EF 08
	bpl .rtl		; $84F54B: 10 39
.go:
	lda.w #ScoutingReportText		; $84F54D: A9 30 D6
	sta.b a1		; $84F550: 85 37
	lda.w #ScoutingReportText>>16		; $84F552: A9 84 00
	sta.b a1+2		; $84F555: 85 39
	lda.w PlayerScrollCtr		; $84F557: AD E9 08
	sta.b d0		; $84F55A: 85 53
	bpl .cont		; $84F55C: 10 4E
	stz.w DispAttribCtr		; $84F55E: 9C F1 08  next paragraph number from TestList; -1: stop typing, leave the screen in 480 frames
	ldy.w SelectedPlayerIdx		; $84F561: AC ED 08
	inc.w SelectedPlayerIdx		; $84F564: EE ED 08
	inc.w SelectedPlayerIdx		; $84F567: EE ED 08
	lda.w #$0000		; $84F56A: A9 00 00
	sta.b a0		; $84F56D: 85 33
	lda.w #TestList>>16		; $84F56F: A9 7F 00
	sta.b a0+2		; $84F572: 85 35
	lda.b [a0],y		; $84F574: B7 33
	sta.b d0		; $84F576: 85 53
	bpl .para		; $84F578: 10 0D
	lda.w #$7FFF		; $84F57A: A9 FF 7F
	sta.w ScoutingReportTimer		; $84F57D: 8D EF 08
	lda.w #$01E0		; $84F580: A9 E0 01
	sta.w screentimer		; $84F583: 8D EB 08
.rtl:
	rtl		; $84F586: 6B
.para:		;blank line between paragraphs
	jsl.l ScrollDisplayUp		; $84F587: 22 34 F7 84
	lda.b a1		; $84F58B: A5 37
	sta.b a2		; $84F58D: 85 3B
	lda.b a1+2		; $84F58F: A5 39
	sta.b a2+2		; $84F591: 85 3D
	bra .cnt		; $84F593: 80 0C
.find:
	lda.b [a2]		; $84F595: A7 3B
	inc.b a2		; $84F597: E6 3B
	and.w #$00FF		; $84F599: 29 FF 00
	cmp.w #$000D		; $84F59C: C9 0D 00
	bne .find		; $84F59F: D0 F4
.cnt:
	dec.b d0		; $84F5A1: C6 53
	bpl .find		; $84F5A3: 10 F0
	lda.b a2		; $84F5A5: A5 3B
	sec		; $84F5A7: 38
	sbc.b a1		; $84F5A8: E5 37
	sta.b d0		; $84F5AA: 85 53
.cont:
	lda.b a1		; $84F5AC: A5 37
	clc		; $84F5AE: 18
	adc.b d0		; $84F5AF: 65 53
	sta.b a2		; $84F5B1: 85 3B
	lda.b a1+2		; $84F5B3: A5 39
	sta.b a2+2		; $84F5B5: 85 3D
	lda.w #$000A		; $84F5B7: A9 0A 00  10 frames per word
	sta.w ScoutingReportTimer		; $84F5BA: 8D EF 08
	lda.w DispAttribCtr		; $84F5BD: AD F1 08
	sta.b d0		; $84F5C0: 85 53
	lda.b [a2]		; $84F5C2: A7 3B
	and.w #$00FF		; $84F5C4: 29 FF 00
	cmp.w #'~'		; $84F5C7: C9 7E 00
	bne .c2		; $84F5CA: D0 03
	jmp.w .arena		; $84F5CC: 4C E6 F6
.c2:
	cmp.w #'{'		; $84F5CF: C9 7B 00
	bne .c3		; $84F5D2: D0 03
	jmp.w .home		; $84F5D4: 4C FF F6
.c3:
	cmp.w #'}'		; $84F5D7: C9 7D 00
	bne .c4		; $84F5DA: D0 03
	jmp.w .away		; $84F5DC: 4C DA F6
.c4:
	cmp.w #'['		; $84F5DF: C9 5B 00
	bne .c5		; $84F5E2: D0 03
	jmp.w .hmtm		; $84F5E4: 4C AB F6
.c5:
	cmp.w #']'		; $84F5E7: C9 5D 00
	bne .word		; $84F5EA: D0 03
	jmp.w .awtm		; $84F5EC: 4C A4 F6
.word:		;copy the word and its trailing spaces to mesarea+2
	lda.w #$FFFF		; $84F5EF: A9 FF FF
	sta.w PlayerScrollCtr		; $84F5F2: 8D E9 08
	lda.w #mesarea+2		; $84F5F5: A9 93 01
	sta.b a0		; $84F5F8: 85 33
	lda.w #$0000		; $84F5FA: A9 00 00
	sta.b a0+2		; $84F5FD: 85 35
	stz.b d1		; $84F5FF: 64 57
.wd:
	lda.b [a2]		; $84F601: A7 3B
	and.w #$00FF		; $84F603: 29 FF 00
	cmp.w #$000D		; $84F606: C9 0D 00
	beq .eol		; $84F609: F0 49
	inc.b d0		; $84F60B: E6 53
.copy:
	sep #$20		; $84F60D: E2 20
	lda.b [a2]		; $84F60F: A7 3B
	sta.b [a0]		; $84F611: 87 33
	rep #$30		; $84F613: C2 30
	inc.b a0		; $84F615: E6 33
	inc.b d1		; $84F617: E6 57
	lda.b [a2]		; $84F619: A7 3B
	and.w #$00FF		; $84F61B: 29 FF 00
	cmp.w #','		; $84F61E: C9 2C 00
	beq .pause		; $84F621: F0 05
	cmp.w #'.'		; $84F623: C9 2E 00
	bne .nopause		; $84F626: D0 0A
.pause:		;40 more frames after punctuation
	lda.w ScoutingReportTimer		; $84F628: AD EF 08
	clc		; $84F62B: 18
	adc.w #$0028		; $84F62C: 69 28 00
	sta.w ScoutingReportTimer		; $84F62F: 8D EF 08
.nopause:
	lda.b [a2]		; $84F632: A7 3B
	inc.b a2		; $84F634: E6 3B
	and.w #$00FF		; $84F636: 29 FF 00
	cmp.w #' '		; $84F639: C9 20 00
	bne .wd		; $84F63C: D0 C3
	lda.b [a2]		; $84F63E: A7 3B
	and.w #$00FF		; $84F640: 29 FF 00
	cmp.w #' '		; $84F643: C9 20 00
	beq .copy		; $84F646: F0 C5
	dec.b d0		; $84F648: C6 53
	lda.b a2		; $84F64A: A5 3B
	sec		; $84F64C: 38
	sbc.b a1		; $84F64D: E5 37
	sta.b a2		; $84F64F: 85 3B
	sta.w PlayerScrollCtr		; $84F651: 8D E9 08
.eol:		;make a String at mesarea
	lda.b d1		; $84F654: A5 57
	inc a		; $84F656: 1A
	inc a		; $84F657: 1A
	sta.w mesarea		; $84F658: 8D 91 01
	lda.w #mesarea		; $84F65B: A9 91 01
	sta.b a1		; $84F65E: 85 37
	lda.w #$0000		; $84F660: A9 00 00
	sta.b a1+2		; $84F663: 85 39
.print:		;past column 20: ScrollDisplayUp
	lda.b d0		; $84F665: A5 53
	sec		; $84F667: 38
	sbc.w #$0014		; $84F668: E9 14 00
	beq .noscr		; $84F66B: F0 0C
	bmi .v2		; $84F66D: 30 08
	bvs .noscr		; $84F66F: 70 08
.scr:
	jsl.l ScrollDisplayUp		; $84F671: 22 34 F7 84
	bra .noscr		; $84F675: 80 02
.v2:
	bvs .scr		; $84F677: 70 F8
.noscr:
	jsl.l printz		; $84F679: 22 0C B9 80  print at column + DispAttribCtr, line + VertLineScrolling
	dw $0005		; $84F67D  printz inline string: length (counts itself), then control bytes / text
	db $FF,$0A,$04
	lda.w DispAttribCtr		; $84F682: AD F1 08
	clc		; $84F685: 18
	adc.w printx		; $84F686: 6D 7B 04
	sta.w printx		; $84F689: 8D 7B 04
	lda.w VertLineScrolling		; $84F68C: AD F3 08
	clc		; $84F68F: 18
	adc.w printy		; $84F690: 6D 7D 04
	sta.w printy		; $84F693: 8D 7D 04
	jsl.l print		; $84F696: 22 2D B9 80
	lda.w DispAttribCtr		; $84F69A: AD F1 08
	clc		; $84F69D: 18
	adc.b d1		; $84F69E: 65 57
	sta.w DispAttribCtr		; $84F6A0: 8D F1 08
	rtl		; $84F6A3: 6B
.awtm:		;away goalie
	lda.w #$0002		; $84F6A4: A9 02 00
	sta.b a1		; $84F6A7: 85 37
	bra .team		; $84F6A9: 80 02
.hmtm:		;home goalie
	stz.b a1		; $84F6AB: 64 37
.team:
	ldy.b a1		; $84F6AD: A4 37
	lda.w tmgoalie,y		; $84F6AF: B9 F2 13
	sta.b d1		; $84F6B2: 85 57
	lda.w tmdata,y		; $84F6B4: B9 CE 13
	sta.b a1		; $84F6B7: 85 37
	lda.w #TeamList>>16		; $84F6B9: A9 83 00
	sta.b a1+2		; $84F6BC: 85 39
	ldy.w #Playerdata		; $84F6BE: A0 00 00
	lda.b a1		; $84F6C1: A5 37
	clc		; $84F6C3: 18
	adc.b [a1],y		; $84F6C4: 77 37
	sta.b a1		; $84F6C6: 85 37
	bra .pn		; $84F6C8: 80 0A
.pl:
	lda.b a1		; $84F6CA: A5 37
	clc		; $84F6CC: 18
	adc.b [a1]		; $84F6CD: 67 37
	adc.w #$0008		; $84F6CF: 69 08 00
	sta.b a1		; $84F6D2: 85 37
.pn:
	dec.b d1		; $84F6D4: C6 57
	bpl .pl		; $84F6D6: 10 F2
	bra .name		; $84F6D8: 80 39
.away:		;away team name
	lda.w tmdata+2		; $84F6DA: AD D0 13
	sta.b a1		; $84F6DD: 85 37
	lda.w #TeamList>>16		; $84F6DF: A9 83 00
	sta.b a1+2		; $84F6E2: 85 39
	bra .tname		; $84F6E4: 80 23
.arena:		;~: the home team (Montreal for the All-Star teams)
	lda.w #TeamList>>16		; $84F6E6: A9 83 00
	sta.b a1+2		; $84F6E9: 85 39
	lda.w tmdata		; $84F6EB: AD CE 13
	cmp.w #AllStarsEast		; $84F6EE: C9 68 80
	beq .mtl		; $84F6F1: F0 05
	cmp.w #AllStarsWest		; $84F6F3: C9 F6 82
	bne .ar		; $84F6F6: D0 03
.mtl:
	lda.w #Montreal		; $84F6F8: A9 0E A0
.ar:
	sta.b a1		; $84F6FB: 85 37
	bra .tname		; $84F6FD: 80 0A
.home:		;home team name
	lda.w tmdata		; $84F6FF: AD CE 13
	sta.b a1		; $84F702: 85 37
	lda.w #TeamList>>16		; $84F704: A9 83 00
	sta.b a1+2		; $84F707: 85 39
.tname:
	ldy.w #Teamname		; $84F709: A0 04 00
	lda.b a1		; $84F70C: A5 37
	clc		; $84F70E: 18
	adc.b [a1],y		; $84F70F: 77 37
	sta.b a1		; $84F711: 85 37
.name:
	inc.w PlayerScrollCtr		; $84F713: EE E9 08
	lda.b d0		; $84F716: A5 53
	clc		; $84F718: 18
	adc.b [a1]		; $84F719: 67 37
	dec a		; $84F71B: 3A
	sta.b d0		; $84F71C: 85 53
	lda.b [a1]		; $84F71E: A7 37
	dec a		; $84F720: 3A
	tay		; $84F721: A8
	dec a		; $84F722: 3A
	sta.b d1		; $84F723: 85 57
	lda.b [a1],y		; $84F725: B7 37
	and.w #$00FF		; $84F727: 29 FF 00
	beq .pad		; $84F72A: F0 03
	jmp.w .print		; $84F72C: 4C 65 F6
.pad:
	dec.b d1		; $84F72F: C6 57
	jmp.w .print		; $84F731: 4C 65 F6
ScrollDisplayUp:		;auto: CODE_84F734. 93G ScrollDisplayUp (hockey93_07): next text line (column 0); after line 7 move the text box up one row ($89FC8F copies 8 textmap rows)
	stz.w DispAttribCtr		; $84F734: 9C F1 08
	inc.w VertLineScrolling		; $84F737: EE F3 08
	lda.w VertLineScrolling		; $84F73A: AD F3 08
	sec		; $84F73D: 38
	sbc.w #$0007		; $84F73E: E9 07 00
	bmi .v1		; $84F741: 30 05
	bvc .up		; $84F743: 50 05
.ex1:
	jmp.w UpdateScoutingDisplay_rtl		; $84F745: 4C 86 F5
.v1:
	bvc .ex1		; $84F748: 50 FB
.up:
	dec.w VertLineScrolling		; $84F74A: CE F3 08
	stx.b xsave		; $84F74D: 86 0A
	ldx.w #$0000		; $84F74F: A2 00 00
.push:
	lda.b d0,x		; $84F752: B5 53
	pha		; $84F754: 48
	inx		; $84F755: E8
	inx		; $84F756: E8
	cpx.w #$0010		; $84F757: E0 10 00
	bne .push		; $84F75A: D0 F6
	ldx.b xsave		; $84F75C: A6 0A
	lda.w #$0007		; $84F75E: A9 07 00
	sta.b d3		; $84F761: 85 5F
	lda.w #textmap+$114		; $84F763: A9 88 6F  textmap+$114: the text box
	sta.b d1		; $84F766: 85 57
	lda.w #textmap>>16		; $84F768: A9 7E 00
	sta.b d1+2		; $84F76B: 85 59
.loop:
	lda.w #$0028		; $84F76D: A9 28 00
	sta.b d0		; $84F770: 85 53
	lda.b d1		; $84F772: A5 57
	clc		; $84F774: 18
	adc.w #$0040		; $84F775: 69 40 00
	sta.b d2		; $84F778: 85 5B
	lda.b d1+2		; $84F77A: A5 59
	sta.b d2+2		; $84F77C: 85 5D
	jsl.l $89FC8F		; $84F77E: 22 8F FC 89  bank $89: copy a textmap row
	lda.b d2		; $84F782: A5 5B
	sta.b d1		; $84F784: 85 57
	lda.b d2+2		; $84F786: A5 5D
	sta.b d1+2		; $84F788: 85 59
	dec.b d3		; $84F78A: C6 5F
	bpl .loop		; $84F78C: 10 DF
	stx.b xsave		; $84F78E: 86 0A
	ldx.w #$000E		; $84F790: A2 0E 00
.pop:
	pla		; $84F793: 68
	sta.b d0,x		; $84F794: 95 53
	dex		; $84F796: CA
	dex		; $84F797: CA
	bpl .pop		; $84F798: 10 F9
	ldx.b xsave		; $84F79A: A6 0A
	rtl		; $84F79C: 6B
PlayoffTiles:		;packed playoff screen palette and tiles (decompressor $86FA3E): 128 colours, then 6 tiles; PlayoffScreen sends them to vram $1000
	incbin "../data/PlayoffTiles.chr.pak"		; $84F79D-$84F815
InitSortObjects:		;auto: CODE_84F816. SNES: clear the sort objects, then set the 4 sso arrows, the 5 ffo objects and the 16 sort objects from SsoInitTable, FfoInitTable and SortObjInitTable; then
		;   SprSort
	ldx.w #$0000		; $84F816: A2 00 00  SortCords (all fields of the 16 objects)
.clr:
	stz.w Xpos,x		; $84F819: 9E FF 08
	inx		; $84F81C: E8
	inx		; $84F81D: E8
	cpx.w #$0840		; $84F81E: E0 40 08
	bne .clr		; $84F821: D0 F6
	ldx.w #$0000		; $84F823: A2 00 00
	ldy.w #$0000		; $84F826: A0 00 00
	lda.w #$0003		; $84F829: A9 03 00
	sta.b d0		; $84F82C: 85 53
.sso:
	lda.w #$FFFF		; $84F82E: A9 FF FF
	sta.w ssoz,y		; $84F831: 99 BB 08
	lda.l SsoInitTable,x		; $84F834: BF 60 F9 84
	sta.w ssox,y		; $84F838: 99 C3 08
	lda.l SsoInitTable+2,x		; $84F83B: BF 62 F9 84
	sta.w ssoy,y		; $84F83F: 99 CB 08
	lda.l SsoInitTable+4,x		; $84F842: BF 64 F9 84
	sta.w ssoframe,y		; $84F846: 99 B3 08
	lda.l SsoInitTable+6,x		; $84F849: BF 66 F9 84
	sta.w ssoattr,y		; $84F84D: 99 AB 08
	txa		; $84F850: 8A
	clc		; $84F851: 18
	adc.w #$0008		; $84F852: 69 08 00
	tax		; $84F855: AA
	iny		; $84F856: C8
	iny		; $84F857: C8
	dec.b d0		; $84F858: C6 53
	bpl .sso		; $84F85A: 10 D2
	ldx.w #$0000		; $84F85C: A2 00 00
	ldy.w #$0000		; $84F85F: A0 00 00
	lda.w #$0004		; $84F862: A9 04 00
	sta.b d0		; $84F865: 85 53
.ffo:
	lda.w #$FFFF		; $84F867: A9 FF FF
	sta.w ffoxofs,y		; $84F86A: 99 0A 01
	lda.l FfoInitTable,x		; $84F86D: BF 80 F9 84
	sta.w ffox,y		; $84F871: 99 14 01
	lda.l FfoInitTable+2,x		; $84F874: BF 82 F9 84
	sta.w ffoy,y		; $84F878: 99 1E 01
	lda.l FfoInitTable+4,x		; $84F87B: BF 84 F9 84
	sta.w ffoz,y		; $84F87F: 99 28 01
	lda.l FfoInitTable+6,x		; $84F882: BF 86 F9 84
	sta.w ffoframe,y		; $84F886: 99 00 01
	lda.l FfoInitTable+8,x		; $84F889: BF 88 F9 84
	sta.w ffoattr,y		; $84F88D: 99 F6 00
	txa		; $84F890: 8A
	clc		; $84F891: 18
	adc.w #$000A		; $84F892: 69 0A 00
	tax		; $84F895: AA
	iny		; $84F896: C8
	iny		; $84F897: C8
	dec.b d0		; $84F898: C6 53
	bpl .ffo		; $84F89A: 10 CB
	stz.b d6		; $84F89C: 64 6B
	stz.b a1		; $84F89E: 64 37
	stz.b a2		; $84F8A0: 64 3B
	stz.b a3		; $84F8A2: 64 3F
	stz.b a4		; $84F8A4: 64 43
.obj:
	ldx.b a2		; $84F8A6: A6 3B
	ldy.b a3		; $84F8A8: A4 3F
	lda.b d6		; $84F8AA: A5 6B
	sta.w SCnum,y		; $84F8AC: 99 9F 0D
	lda.w #$FFFF		; $84F8AF: A9 FF FF
	sta.w oldframe,y		; $84F8B2: 99 FF 09
	sta.w pnum,y		; $84F8B5: 99 1F 0F
	lda.l SortObjInitTable,x		; $84F8B8: BF B2 F9 84
	sta.w Xpos,y		; $84F8BC: 99 FF 08
	lda.l SortObjInitTable+2,x		; $84F8BF: BF B4 F9 84
	sta.w Ypos,y		; $84F8C3: 99 5F 09
	lda.l SortObjInitTable+4,x		; $84F8C6: BF B6 F9 84
	sta.w Zpos,y		; $84F8CA: 99 9F 09
	lda.l SortObjInitTable+6,x		; $84F8CD: BF B8 F9 84
	sta.w frame,y		; $84F8D1: 99 3F 09
	lda.l SortObjInitTable+8,x		; $84F8D4: BF BA F9 84
	sta.w attribute,y		; $84F8D8: 99 DF 09
	lda.l SortObjInitTable+10,x		; $84F8DB: BF BC F9 84
	sta.w radiusx,y		; $84F8DF: 99 1F 0D
	lda.l SortObjInitTable+12,x		; $84F8E2: BF BE F9 84
	sta.w radiusy,y		; $84F8E6: 99 3F 0D
	lda.b d6		; $84F8E9: A5 6B
	asl a		; $84F8EB: 0A
	asl a		; $84F8EC: 0A
	asl a		; $84F8ED: 0A
	tay		; $84F8EE: A8
	lda.l SortObjInitTable+14,x		; $84F8EF: BF C0 F9 84
	sta.w asslist,y		; $84F8F3: 99 DF 0B
	ldy.b a3		; $84F8F6: A4 3F
	lda.l SortObjInitTable+16,x		; $84F8F8: BF C2 F9 84
	sta.w pflags,y		; $84F8FC: 99 DF 0E
	lda.w #$0000		; $84F8FF: A9 00 00
	sta.w pfnc,y		; $84F902: 99 FF 11
	cpy.w #$001E		; $84F905: C0 1E 00  object $1E (puck shadow): pfnc
	bne .tm		; $84F908: D0 06
	lda.w #$0001		; $84F90A: A9 01 00
	sta.w pfnc,y		; $84F90D: 99 FF 11
.tm:
	cpx.w #$006C		; $84F910: E0 6C 00  pfgoal for objects 6-11 and 12-15, pfteam $34 for 6-11
	rol a		; $84F913: 2A
	inc a		; $84F914: 1A
	and.w #$0001		; $84F915: 29 01 00
	sta.w pfgoal,y		; $84F918: 99 3F 11
	cpx.w #$006C		; $84F91B: E0 6C 00
	bcc .next		; $84F91E: 90 0B
	cpx.w #$00D8		; $84F920: E0 D8 00
	bcs .next		; $84F923: B0 06
	lda.w #$0034		; $84F925: A9 34 00
	sta.w pfteam,y		; $84F928: 99 9F 11
.next:
	inc.b a3		; $84F92B: E6 3F
	inc.b a3		; $84F92D: E6 3F
	sep #$20		; $84F92F: E2 20
	lda.b d6		; $84F931: A5 6B
	asl a		; $84F933: 0A
	ldy.b a1		; $84F934: A4 37
	sta.w OOlist,y		; $84F936: 99 5F 12
	inc.b a1		; $84F939: E6 37
	rep #$30		; $84F93B: C2 30
	lda.b d6		; $84F93D: A5 6B
	ldy.b a4		; $84F93F: A4 43
	sta.w OOlistpos,y		; $84F941: 99 3F 12
	inc.b a4		; $84F944: E6 43
	inc.b a4		; $84F946: E6 43
	inc.b d6		; $84F948: E6 6B
	lda.b a2		; $84F94A: A5 3B
	clc		; $84F94C: 18
	adc.w #$0012		; $84F94D: 69 12 00
	sta.b a2		; $84F950: 85 3B
	lda.b d6		; $84F952: A5 6B
	cmp.w #$0010		; $84F954: C9 10 00
	beq .sort		; $84F957: F0 03
	jmp.w .obj		; $84F959: 4C A6 F8
.sort:
	jml.l SprSort		; $84F95C: 5C 6C B7 80
SsoInitTable:		;SNES: 4 x (ssox, ssoy, ssoframe, ssoattr)
	dw $0000,$0000,$0000,$0000		; $84F960
	dw $0000,$0000,$0000,$0000		; $84F968
	dw $0040,$FFA4,$0000,$8000		; $84F970
	dw $FFC0,$FFA4,$0000,$8000		; $84F978
FfoInitTable:		;SNES: 5 x (ffox, ffoy, ffoz, ffoframe, ffoattr)
	dw $0000,$0000,$FFFF,$0188,$0000		; $84F980
	dw $0000,$0000,$FFFF,$0186,$0000		; $84F98A
	dw $0000,$0000,$FFFF,$0187,$0000		; $84F994
	dw $0000,$0000,$0000,$0000,$0000		; $84F99E
	dw $0000,$0000,$FFFF,$0161,$0000		; $84F9A8
SortObjInitTable:		;SNES: 16 x (Xpos, Ypos, Zpos, frame, attribute, radiusx, radiusy, assignment, pflags); objects 6-11 are team 2
	dw $0160,$00C0,$0000,$0001,$0000,$0008,$0004,$0000,$0000		; $84F9B2
	dw $FF38,$FF9C,$0000,$0001,$0000,$0008,$0004,$0000,$0000		; $84F9C4
	dw $FF38,$FFB0,$0000,$0001,$0000,$0008,$0004,$0000,$0000		; $84F9D6
	dw $FF38,$FFC4,$0000,$0001,$0000,$0008,$0004,$0000,$0000		; $84F9E8
	dw $FF38,$FFD8,$0000,$0001,$0000,$0008,$0004,$0000,$0000		; $84F9FA
	dw $FF38,$FFEC,$0000,$0001,$0000,$0008,$0004,$0000,$0000		; $84FA0C
	dw $00C0,$00C0,$0000,$0001,$0001,$0008,$0004,$0000,$0000		; $84FA1E
	dw $FF38,$0028,$0000,$0001,$0001,$0008,$0004,$0000,$0000		; $84FA30
	dw $FF38,$003C,$0000,$0001,$0001,$0008,$0004,$0000,$0000		; $84FA42
	dw $FF38,$0050,$0000,$0001,$0001,$0008,$0004,$0000,$0000		; $84FA54
	dw $FF38,$0064,$0000,$0001,$0001,$0008,$0004,$0000,$0000		; $84FA66
	dw $FF38,$0078,$0000,$0001,$0001,$0008,$0004,$0000,$0000		; $84FA78
	dw $0000,$010C,$0000,$0194,$0000,$0014,$0006,$0000,$0000		; $84FA8A
	dw $0000,$FEF4,$0000,$0195,$0000,$0014,$0006,$0000,$0000		; $84FA9C
	dw $0000,$0000,$0000,$018A,$0000,$0005,$0005,$0018,$0001		; $84FAAE
	dw $0000,$0000,$0000,$0189,$0000,$0003,$0003,$0019,$0000		; $84FAC0
Readjoy12:		;auto: CODE_84FAD2. SNES: Readjoy1 and Readjoy2, d1 = the new presses of both pads
	jsl.l Readjoy1		; $84FAD2: 22 0B C4 80  pad 1 or pad 2
	lda.b d1		; $84FAD6: A5 57
	pha		; $84FAD8: 48
	jsl.l Readjoy2		; $84FAD9: 22 29 C4 80
	pla		; $84FADD: 68
	ora.b d1		; $84FADE: 05 57
	sta.b d1		; $84FAE0: 85 57
	rtl		; $84FAE2: 6B
DisplayStats:		;auto: CODE_84FAE3. 92G DisplayStats (penalty.asm): the STATS page of the pause menu: Shots, Power Play, Penalties, Body Checks (92G Fights Won), AttackZone for both teams
	jsl.l printz8B		; $84FAE3: 22 BF FD 82
	dw $000A		; $84FAE7  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02,"STATS"
	jsl.l printz		; $84FAF1: 22 0C B9 80
	dw $0005		; $84FAF5  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$07
	lda.w #$0016		; $84FAFA: A9 16 00
	sta.b d0		; $84FAFD: 85 53
	lda.w #$0005		; $84FAFF: A9 05 00
	sta.b d1		; $84FB02: 85 57
	lda.w smallfontchars		; $84FB04: AD D7 1B
	sta.b d2		; $84FB07: 85 5B
	jsl.l $8D847C		; $84FB09: 22 7C 84 8D  bank $8D: 92G eraser
	jsl.l printz		; $84FB0D: 22 0C B9 80
	dw $000B		; $84FB11  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0D,$06,"      "
	jsl.l printz		; $84FB1C: 22 0C B9 80
	dw $000A		; $84FB20  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0D,$07,"Shots"
	jsl.l printz		; $84FB2A: 22 0C B9 80
	dw $000F		; $84FB2E  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$08,"Power Play"
	jsl.l printz		; $84FB3D: 22 0C B9 80
	dw $000E		; $84FB41  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$09,"Penalties"
	jsl.l printz		; $84FB4F: 22 0C B9 80
	dw $0010		; $84FB53  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$0A,"Body Checks"
	jsl.l printz		; $84FB63: 22 0C B9 80
	dw $000F		; $84FB67  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$0B,"AttackZone"
	jsl.l printz		; $84FB76: 22 0C B9 80
	dw $0005		; $84FB7A  printz inline string: length (counts itself), then control bytes / text
	db $BF,$1A,$07
	stz.b a2		; $84FB7F: 64 3B  home stats at x 26, then the away stats at x 9
	jsl.l .ss		; $84FB81: 22 92 FB 84
	jsl.l printz		; $84FB85: 22 0C B9 80
	dw $0005		; $84FB89  printz inline string: length (counts itself), then control bytes / text
	db $BF,$09,$07
	inc.b a2		; $84FB8E: E6 3B
	inc.b a2		; $84FB90: E6 3B
.ss:		;92G .ss: the .sslist stats of team a2 at printx
	lda.w #DisplayStats_sslist		; $84FB92: A9 30 FC
	sta.b a0		; $84FB95: 85 33
	lda.w #DisplayStats_sslist>>16		; $84FB97: A9 84 00
	sta.b a0+2		; $84FB9A: 85 35
.sstop:
	lda.b [a0]		; $84FB9C: A7 33
	inc.b a0		; $84FB9E: E6 33
	inc.b a0		; $84FBA0: E6 33
	tay		; $84FBA2: A8
	bmi .atz		; $84FBA3: 30 6D
	ldy.w printx		; $84FBA5: AC 7B 04
	phy		; $84FBA8: 5A
	clc		; $84FBA9: 18
	adc.b a2		; $84FBAA: 65 3B
	tay		; $84FBAC: A8
	lda.w $0000,y		; $84FBAD: B9 00 00  stat word of team a2 (absolute address +$0000,y)
	sta.b d0		; $84FBB0: 85 53
	jsl.l $8F8682		; $84FBB2: 22 82 86 8F  bank $8F: 93G pushnumber
	lda.b [a0]		; $84FBB6: A7 33
	inc.b a0		; $84FBB8: E6 33
	inc.b a0		; $84FBBA: E6 33
	tay		; $84FBBC: A8
	bmi .nextss		; $84FBBD: 30 37
	sta.b d1		; $84FBBF: 85 57
	lda.w #mesarea		; $84FBC1: A9 91 01
	sta.b a3		; $84FBC4: 85 3F
	lda.w #$0000		; $84FBC6: A9 00 00
	sta.b a3+2		; $84FBC9: 85 41
	lda.w #$0002		; $84FBCB: A9 02 00
	sta.b [a3]		; $84FBCE: 87 3F
	jsl.l $8F87C9		; $84FBD0: 22 C9 87 8F  bank $8F: appstring
	jsl.l appendz		; $84FBD4: 22 D3 FD 82
	dw $0003		; $84FBD8  printz inline string: length (counts itself), then control bytes / text
	db "/"
	lda.b a2		; $84FBDB: A5 3B
	clc		; $84FBDD: 18
	adc.b d1		; $84FBDE: 65 57
	tay		; $84FBE0: A8
	lda.w $0000,y		; $84FBE1: B9 00 00
	sta.b d0		; $84FBE4: 85 53
	jsl.l $8F8682		; $84FBE6: 22 82 86 8F  bank $8F: 93G pushnumber
	jsl.l $8F87C9		; $84FBEA: 22 C9 87 8F  bank $8F: appstring
	lda.b a3		; $84FBEE: A5 3F
	sta.b a1		; $84FBF0: 85 37
	lda.b a3+2		; $84FBF2: A5 41
	sta.b a1+2		; $84FBF4: 85 39
.nextss:
	lda.b [a1]		; $84FBF6: A7 37
	inc a		; $84FBF8: 1A
	lsr a		; $84FBF9: 4A
	eor.w #$FFFF		; $84FBFA: 49 FF FF
	inc a		; $84FBFD: 1A
	clc		; $84FBFE: 18
	adc.w printx		; $84FBFF: 6D 7B 04
	sta.w printx		; $84FC02: 8D 7B 04
	jsl.l print		; $84FC05: 22 2D B9 80
	pla		; $84FC09: 68
	sta.w printx		; $84FC0A: 8D 7B 04
	inc.w printy		; $84FC0D: EE 7D 04
	bra .sstop		; $84FC10: 80 8A
.atz:		;tmATOP as a time
	ldy.b a2		; $84FC12: A4 3B
	lda.w tmATOP,y		; $84FC14: B9 CA 13
	sta.b d0		; $84FC17: 85 53
	jsl.l $8F87EA		; $84FC19: 22 EA 87 8F  bank $8F: 93G PushTime (d0 = time)
	lda.b [a1]		; $84FC1D: A7 37
	inc a		; $84FC1F: 1A
	lsr a		; $84FC20: 4A
	eor.w #$FFFF		; $84FC21: 49 FF FF
	inc a		; $84FC24: 1A
	clc		; $84FC25: 18
	adc.w printx		; $84FC26: 6D 7B 04
	sta.w printx		; $84FC29: 8D 7B 04
	jml.l print		; $84FC2C: 5C 2D B9 80
DisplayStats_sslist:		;92G .sslist: stat, second stat (-1 = none)
	dw tmshots,-1, tmPwrGoals,tmPwrPlays, tmPenalties,tmPenmin, tmchecks,-1, -1,-1		; $84FC30
GetNameandAttrib:		;auto: CODE_84FC44. 93G GetNameandAttrib (stats93): print player d0 (number and name), then at x 26 the column d4 (attribjmp); columns above 2 average the rating nibbles masked by
		;   d4 high word
	stx.b xsave		; $84FC44: 86 0A
	ldx.w #$0000		; $84FC46: A2 00 00
.pushd:
	lda.b d0,x		; $84FC49: B5 53
	pha		; $84FC4B: 48
	inx		; $84FC4C: E8
	inx		; $84FC4D: E8
	cpx.w #$0014		; $84FC4E: E0 14 00
	bne .pushd		; $84FC51: D0 F6
	ldx.b xsave		; $84FC53: A6 0A
	stx.b xsave		; $84FC55: 86 0A
	ldx.w #$0000		; $84FC57: A2 00 00
.pusha:
	lda.b a0,x		; $84FC5A: B5 33
	pha		; $84FC5C: 48
	inx		; $84FC5D: E8
	inx		; $84FC5E: E8
	cpx.w #$0008		; $84FC5F: E0 08 00
	bne .pusha		; $84FC62: D0 F6
	ldx.b xsave		; $84FC64: A6 0A
	jsl.l PlayerNumName		; $84FC66: 22 0C CC 83
	jsl.l print		; $84FC6A: 22 2D B9 80
	lda.w #$001A		; $84FC6E: A9 1A 00
	sta.w printx		; $84FC71: 8D 7B 04
	lda.b d4		; $84FC74: A5 63  status, energy, handed: no ratings
	cmp.w #$0003		; $84FC76: C9 03 00
	bcs .rate		; $84FC79: B0 03
	jmp.w .jump		; $84FC7B: 4C 0D FD
.rate:
	ldy.b a2		; $84FC7E: A4 3B
	lda.w #TeamList>>16		; $84FC80: A9 83 00
	sta.b a0+2		; $84FC83: 85 35
	lda.w tmdata,y		; $84FC85: B9 CE 13
	sta.b a0		; $84FC88: 85 33
	clc		; $84FC8A: 18
	ldy.w #Playerdata		; $84FC8B: A0 00 00
	adc.b [a0],y		; $84FC8E: 77 33
	sta.b a0		; $84FC90: 85 33
.pl:
	lda.b a0		; $84FC92: A5 33
	clc		; $84FC94: 18
	adc.b [a0]		; $84FC95: 67 33
	adc.w #$0008		; $84FC97: 69 08 00
	sta.b a0		; $84FC9A: 85 33
	dec.b d0		; $84FC9C: C6 53
	bpl .pl		; $84FC9E: 10 F2
	stz.b d0		; $84FCA0: 64 53
	stz.b d1		; $84FCA2: 64 57
	lda.w #$000F		; $84FCA4: A9 0F 00
	sta.b d2		; $84FCA7: 85 5B
	lda.b d4		; $84FCA9: A5 63
	ldy.b d4+2		; $84FCAB: A4 65
	sta.b d4+2		; $84FCAD: 85 65
	sty.b d4		; $84FCAF: 84 63
.one:
	lda.b d4		; $84FCB1: A5 63
	sta.b tmp0		; $84FCB3: 85 73
	lda.b d4+2		; $84FCB5: A5 65
	sta.b tmp1		; $84FCB7: 85 75
	lda.b d2		; $84FCB9: A5 5B
	sta.b tmp2		; $84FCBB: 85 77
.sh:
	dec.b tmp2		; $84FCBD: C6 77
	bmi .bit		; $84FCBF: 30 06
	lsr.b tmp1		; $84FCC1: 46 75
	ror.b tmp0		; $84FCC3: 66 73
	bra .sh		; $84FCC5: 80 F6
.bit:
	lsr.b tmp0		; $84FCC7: 46 73
	bcc .three		; $84FCC9: 90 36
	lda.b d2		; $84FCCB: A5 5B
	lsr a		; $84FCCD: 4A
	eor.w #$FFFF		; $84FCCE: 49 FF FF
	inc a		; $84FCD1: 1A
	dec a		; $84FCD2: 3A
	clc		; $84FCD3: 18
	adc.b a0		; $84FCD4: 65 33
	sta.b tmp0		; $84FCD6: 85 73
	lda.b a0+2		; $84FCD8: A5 35
	sta.b tmp1		; $84FCDA: 85 75
	lda.b [tmp0]		; $84FCDC: A7 73
	sta.b d3		; $84FCDE: 85 5F
	lda.b d2		; $84FCE0: A5 5B
	lsr a		; $84FCE2: 4A
	bcc .lo		; $84FCE3: 90 08
	lda.b d3		; $84FCE5: A5 5F
	lsr a		; $84FCE7: 4A
	lsr a		; $84FCE8: 4A
	lsr a		; $84FCE9: 4A
	lsr a		; $84FCEA: 4A
	sta.b d3		; $84FCEB: 85 5F
.lo:
	lda.b d3		; $84FCED: A5 5F
	and.w #$000F		; $84FCEF: 29 0F 00
	sta.b d3		; $84FCF2: 85 5F
	clc		; $84FCF4: 18
	adc.b d0		; $84FCF5: 65 53
	sta.b d0		; $84FCF7: 85 53
	lda.b d1		; $84FCF9: A5 57
	clc		; $84FCFB: 18
	adc.w #$000F		; $84FCFC: 69 0F 00
	sta.b d1		; $84FCFF: 85 57
.three:
	dec.b d2		; $84FD01: C6 5B
	bpl .one		; $84FD03: 10 AC
	lda.b d4		; $84FD05: A5 63
	ldy.b d4+2		; $84FD07: A4 65
	sta.b d4+2		; $84FD09: 85 65
	sty.b d4		; $84FD0B: 84 63
.jump:		;go to attribjmp[d4] through jmlvector
	lda.w #attribjmp		; $84FD0D: A9 49 FD
	sta.b a0		; $84FD10: 85 33
	lda.w #attribjmp>>16		; $84FD12: A9 84 00
	sta.b a0+2		; $84FD15: 85 35
	ldy.b d4		; $84FD17: A4 63
	lda.b [a0],y		; $84FD19: B7 33
	clc		; $84FD1B: 18
	adc.b a0		; $84FD1C: 65 33
	sta.b a0		; $84FD1E: 85 33
	sta.w jmlvector+1		; $84FD20: 8D 79 01
	lda.b a0+1		; $84FD23: A5 34
	sta.w jmlvector+2		; $84FD25: 8D 7A 01
	jsl.l $000178		; $84FD28: 22 78 01 00  jmlvector
	stx.b xsave		; $84FD2C: 86 0A
	ldx.w #$0006		; $84FD2E: A2 06 00
.popa:
	pla		; $84FD31: 68
	sta.b a0,x		; $84FD32: 95 33
	dex		; $84FD34: CA
	dex		; $84FD35: CA
	bpl .popa		; $84FD36: 10 F9
	ldx.b xsave		; $84FD38: A6 0A
	stx.b xsave		; $84FD3A: 86 0A
	ldx.w #$0012		; $84FD3C: A2 12 00
.popd:
	pla		; $84FD3F: 68
	sta.b d0,x		; $84FD40: 95 53
	dex		; $84FD42: CA
	dex		; $84FD43: CA
	bpl .popd		; $84FD44: 10 F9
	ldx.b xsave		; $84FD46: A6 0A
	rtl		; $84FD48: 6B
attribjmp:		;93G attribjmp: GetNameandAttrib column handlers, offsets from attribjmp
	dw AttribStatus-attribjmp,AttribEnergy-attribjmp,AttribHanded-attribjmp,AttribWeight-attribjmp,AttribFighting-attribjmp,AttribRating-attribjmp		; $84FD49
AttribStatus:		;auto: CODE_84FD55. 93G AttribStatus: tmpdst of player d0: Ice/Bench/Injury, or the penalty time (injured: Inj G, $4000: C)
	asl.b d0		; $84FD55: 06 53
	lda.b a2		; $84FD57: A5 3B
	beq .tm		; $84FD59: F0 03
	lda.w #$0034		; $84FD5B: A9 34 00
.tm:
	adc.b d0		; $84FD5E: 65 53
	tay		; $84FD60: A8
	lda.w tmpdst,y		; $84FD61: B9 E2 14  tmpdst: negative = not of the status
	sta.b d0		; $84FD64: 85 53
	bpl .pen		; $84FD66: 10 24
	eor.w #$FFFF		; $84FD68: 49 FF FF
	sta.b d0		; $84FD6B: 85 53
	cmp.w #$0003		; $84FD6D: C9 03 00
	bcc .st		; $84FD70: 90 0C
	lda.w #$0001		; $84FD72: A9 01 00
	sta.b d0		; $84FD75: 85 53
	bra .st		; $84FD77: 80 05
.inj:
	lda.w #$0003		; $84FD79: A9 03 00
	sta.b d0		; $84FD7C: 85 53
.st:
	lda.w #StatusTextTbl>>16		; $84FD7E: A9 84 00
	sta.b a1+2		; $84FD81: 85 39
	lda.w #StatusTextTbl		; $84FD83: A9 C6 FD
	sta.b a1		; $84FD86: 85 37
	jml.l $8FD68C		; $84FD88: 5C 8C D6 8F  bank $8F: 93G PrintStringFromList (d0 = index, [a1] = list)
.pen:
	lda.b d0		; $84FD8C: A5 53
	bit.w #TMPDINJ		; $84FD8E: 89 00 10
	bne .inj		; $84FD91: D0 E6
	dec.w printx		; $84FD93: CE 7B 04
	lda.b d0		; $84FD96: A5 53
	sta.b d1		; $84FD98: 85 57
	and.w #$0FFF		; $84FD9A: 29 FF 0F
	sta.b d0		; $84FD9D: 85 53
	jsl.l $8F87EA		; $84FD9F: 22 EA 87 8F  bank $8F: 93G PushTime (d0 = time)
	jsl.l print		; $84FDA3: 22 2D B9 80
	lda.w #$0004		; $84FDA7: A9 04 00
	sta.b d0		; $84FDAA: 85 53
	lda.w #$4000		; $84FDAC: A9 00 40
	trb.b d1		; $84FDAF: 14 57
	beq .t		; $84FDB1: F0 05
	lda.w #$0005		; $84FDB3: A9 05 00
	sta.b d0		; $84FDB6: 85 53
.t:
	lda.w #StatusTextTbl>>16		; $84FDB8: A9 84 00
	sta.b a1+2		; $84FDBB: 85 39
	lda.w #StatusTextTbl		; $84FDBD: A9 C6 FD
	sta.b a1		; $84FDC0: 85 37
	jml.l $8FD68C		; $84FDC2: 5C 8C D6 8F  bank $8F: 93G PrintStringFromList (d0 = index, [a1] = list)
StatusTextTbl:		;93G StatusTextTbl: AttribStatus strings
	%String("Ice   ")		; $84FDC6
	%String("Bench ")		; $84FDCE
	%String("Inj P ")		; $84FDD6
	%String("Inj G ")		; $84FDDE
	%String("  ")		; $84FDE6
	%String(" C")		; $84FDEA
AttribEnergy:		;auto: CODE_84FDEE. 93G AttribEnergy: tmpde of player d0 / 40, max 100
	asl.b d0		; $84FDEE: 06 53
	lda.b a2		; $84FDF0: A5 3B
	beq .tm		; $84FDF2: F0 03
	lda.w #$0034		; $84FDF4: A9 34 00
.tm:
	adc.b d0		; $84FDF7: 65 53
	tay		; $84FDF9: A8
	lda.w tmpde,y		; $84FDFA: B9 7A 14  divu16 by 40
	sta.b mulb		; $84FDFD: 85 83
	lda.w #$0028		; $84FDFF: A9 28 00
	sta.b mula		; $84FE02: 85 7D
	jsl.l divu16		; $84FE04: 22 D8 B8 80
	cmp.w #$0065		; $84FE08: C9 65 00
	bcc .pr		; $84FE0B: 90 03
	lda.w #$0064		; $84FE0D: A9 64 00
.pr:
	sta.b d0		; $84FE10: 85 53
	bra AttribPrintPct		; $84FE12: 80 20
AttribFighting:		;auto: CODE_84FE14. 93G AttribFighting: bit 0 of the nibble is handedness, only bits 1-3 count
	lda.b d0		; $84FE14: A5 53
	and.w #$000E		; $84FE16: 29 0E 00
	sta.b d0		; $84FE19: 85 53
	dec.b d1		; $84FE1B: C6 57
AttribRating:		;auto: CODE_84FE1D. 93G AttribRating: sum d0 of d1/15 ratings as a percentage
	lda.w #$0064		; $84FE1D: A9 64 00
	sta.b mula		; $84FE20: 85 7D
	lda.b d0		; $84FE22: A5 53
	sta.b mulb		; $84FE24: 85 83
	jsl.l mulu		; $84FE26: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.b d1		; $84FE2A: A5 57
	sta.b mula		; $84FE2C: 85 7D
	jsl.l divu		; $84FE2E: 22 E5 CB 80
	sta.b d0		; $84FE32: 85 53
AttribPrintPct:		;auto: CODE_84FE34. 93G AttribPrintPct: print d0 4 wide plus padding
	lda.w #$0004		; $84FE34: A9 04 00
	sta.b d1		; $84FE37: 85 57
	jsl.l $8FF54E		; $84FE39: 22 4E F5 8F  bank $8F: 93G PushNumberWidth
	jsl.l print		; $84FE3D: 22 2D B9 80
	jsl.l printz		; $84FE41: 22 0C B9 80
	dw $0004		; $84FE45  printz inline string: length (counts itself), then control bytes / text
	db "  "
	rtl		; $84FE49: 6B
AttribHanded:		;auto: CODE_84FE4A. 93G AttribHanded: bit 0 of the sum
	lda.b d0		; $84FE4A: A5 53
	and.w #$0001		; $84FE4C: 29 01 00
	sta.b d0		; $84FE4F: 85 53
	lda.w #HandedTextTbl>>16		; $84FE51: A9 84 00
	sta.b a1+2		; $84FE54: 85 39
	lda.w #HandedTextTbl		; $84FE56: A9 5F FE
	sta.b a1		; $84FE59: 85 37
	jml.l $8FD68C		; $84FE5B: 5C 8C D6 8F  bank $8F: 93G PrintStringFromList (d0 = index, [a1] = list)
HandedTextTbl:		;93G HandedTextTbl: AttribHanded strings (93G Righty, Lefty)
	%String("Right ")		; $84FE5F
	%String("Left  ")		; $84FE67
AttribWeight:		;auto: CODE_84FE6F. 93G AttribWeight: 140 + 8 * rating lb
	lda.b d0		; $84FE6F: A5 53
	asl a		; $84FE71: 0A
	asl a		; $84FE72: 0A
	asl a		; $84FE73: 0A
	adc.w #140		; $84FE74: 69 8C 00
	sta.b d0		; $84FE77: 85 53
	jsl.l $8F8682		; $84FE79: 22 82 86 8F  bank $8F: 93G pushnumber
	jsl.l print		; $84FE7D: 22 2D B9 80
	jsl.l printz		; $84FE81: 22 0C B9 80
	dw $0005		; $84FE85  printz inline string: length (counts itself), then control bytes / text
	db "   "
	rtl		; $84FE8A: 6B
unusedFF84:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FE8B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FE9B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FEAB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FEBB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FECB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FEDB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FEEB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FEFB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF0B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF1B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF2B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF3B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF4B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF5B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF6B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF7B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF8B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FF9B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FFAB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FFBB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FFCB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FFDB
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $84FFEB
	db $FF,$FF,$FF,$FF,$FF		; $84FFFB
