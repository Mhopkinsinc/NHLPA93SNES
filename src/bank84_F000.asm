; $84EF3C-$84FFFF  ROM $26F3C-$27FFF: HotList, UpdateScoutingDisplay, ScrollDisplayUp (hockey93_07), PlayoffTiles, InitSortObjects and
; its tables, Readjoy12, DisplayStats (92G penalty.asm), GetNameandAttrib, attribjmp and its handlers (stats93), $FF fill.
; Starts at HotList (boundary moved from $84F00C).
org $84EF3C
HotList:		;93G HotList: hot spot (stick blade) x, y bytes for every sprite frame (549 pairs), read by GetHot
	incbin "../data/HotList.bin":0..$44A		; $84EF3C-$84F385
RinkLogoTiles:		;SNES: packed rink logo tiles (14 tiles, $1C0 bytes unpacked), sent to vram after FaceOffTiles by setupice. Kept in data/HotList.bin after the hot spots
	incbin "../data/HotList.bin":$44A..$5F6		; $84F386-$84F531
RinkLogoTilesEnd:
UpdateScoutingDisplay:		;called every frame by ScoutingReport. When ScoutingReportTimer runs out (at once if asv (93G hockey93_07)
		;   SNES: ~ { } [ ] print
		;   a team or goalie name
	lda.w ScoutingReportTimer		; text finished ($7FFF)
	sec
	sbc.w #$1000
	beq .tm
	bmi .v1
	bvs .tm
	bra .rtl
.v1:
	bvs .rtl
.tm:
	lda.w asv		; asv: no delay
	bmi .go
	dec.w ScoutingReportTimer
	bpl .rtl
.go:
	lda.w #ScoutingReportText
	sta.b a1
	lda.w #ScoutingReportText>>16
	sta.b a1+2
	lda.w PlayerScrollCtr
	sta.b d0
	bpl .cont
	stz.w DispAttribCtr		; next paragraph number from TestList; -1: stop typing, leave the screen in 480 frames
	ldy.w SelectedPlayerIdx
	inc.w SelectedPlayerIdx
	inc.w SelectedPlayerIdx
	lda.w #$0000
	sta.b a0
	lda.w #TestList>>16
	sta.b a0+2
	lda.b [a0],y
	sta.b d0
	bpl .para
	lda.w #$7FFF
	sta.w ScoutingReportTimer
	lda.w #$01E0
	sta.w screentimer
.rtl:
	rtl
.para:		;blank line between paragraphs
	jsl.l ScrollDisplayUp
	lda.b a1
	sta.b a2
	lda.b a1+2
	sta.b a2+2
	bra .cnt
.find:
	lda.b [a2]
	inc.b a2
	and.w #$00FF
	cmp.w #$000D
	bne .find
.cnt:
	dec.b d0
	bpl .find
	lda.b a2
	sec
	sbc.b a1
	sta.b d0
.cont:
	lda.b a1
	clc
	adc.b d0
	sta.b a2
	lda.b a1+2
	sta.b a2+2
	lda.w #$000A		; 10 frames per word
	sta.w ScoutingReportTimer
	lda.w DispAttribCtr
	sta.b d0
	lda.b [a2]
	and.w #$00FF
	cmp.w #'~'
	bne .c2
	jmp.w .arena
.c2:
	cmp.w #'{'
	bne .c3
	jmp.w .home
.c3:
	cmp.w #'}'
	bne .c4
	jmp.w .away
.c4:
	cmp.w #'['
	bne .c5
	jmp.w .hmtm
.c5:
	cmp.w #']'
	bne .word
	jmp.w .awtm
.word:		;copy the word and its trailing spaces to mesarea+2
	lda.w #$FFFF
	sta.w PlayerScrollCtr
	lda.w #mesarea+2
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	stz.b d1
.wd:
	lda.b [a2]
	and.w #$00FF
	cmp.w #$000D
	beq .eol
	inc.b d0
.copy:
	sep #$20
	lda.b [a2]
	sta.b [a0]
	rep #$30
	inc.b a0
	inc.b d1
	lda.b [a2]
	and.w #$00FF
	cmp.w #','
	beq .pause
	cmp.w #'.'
	bne .nopause
.pause:		;40 more frames after punctuation
	lda.w ScoutingReportTimer
	clc
	adc.w #$0028
	sta.w ScoutingReportTimer
.nopause:
	lda.b [a2]
	inc.b a2
	and.w #$00FF
	cmp.w #' '
	bne .wd
	lda.b [a2]
	and.w #$00FF
	cmp.w #' '
	beq .copy
	dec.b d0
	lda.b a2
	sec
	sbc.b a1
	sta.b a2
	sta.w PlayerScrollCtr
.eol:		;make a String at mesarea
	lda.b d1
	inc a
	inc a
	sta.w mesarea
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.print:		;past column 20: ScrollDisplayUp
	lda.b d0
	sec
	sbc.w #$0014
	beq .noscr
	bmi .v2
	bvs .noscr
.scr:
	jsl.l ScrollDisplayUp
	bra .noscr
.v2:
	bvs .scr
.noscr:
	jsl.l printz		; print at column + DispAttribCtr, line + VertLineScrolling
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$0A,$04
	lda.w DispAttribCtr
	clc
	adc.w printx
	sta.w printx
	lda.w VertLineScrolling
	clc
	adc.w printy
	sta.w printy
	jsl.l print
	lda.w DispAttribCtr
	clc
	adc.b d1
	sta.w DispAttribCtr
	rtl
.awtm:		;away goalie
	lda.w #$0002
	sta.b a1
	bra .team
.hmtm:		;home goalie
	stz.b a1
.team:
	ldy.b a1
	lda.w tmgoalie,y
	sta.b d1
	lda.w tmdata,y
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #Playerdata
	lda.b a1
	clc
	adc.b [a1],y
	sta.b a1
	bra .pn
.pl:
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0008
	sta.b a1
.pn:
	dec.b d1
	bpl .pl
	bra .name
.away:		;away team name
	lda.w tmdata+2
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	bra .tname
.arena:		;~: the home team (Montreal for the All-Star teams)
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w tmdata
	cmp.w #AllStarsEast
	beq .mtl
	cmp.w #AllStarsWest
	bne .ar
.mtl:
	lda.w #Montreal
.ar:
	sta.b a1
	bra .tname
.home:		;home team name
	lda.w tmdata
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
.tname:
	ldy.w #Teamname
	lda.b a1
	clc
	adc.b [a1],y
	sta.b a1
.name:
	inc.w PlayerScrollCtr
	lda.b d0
	clc
	adc.b [a1]
	dec a
	sta.b d0
	lda.b [a1]
	dec a
	tay
	dec a
	sta.b d1
	lda.b [a1],y
	and.w #$00FF
	beq .pad
	jmp.w .print
.pad:
	dec.b d1
	jmp.w .print
ScrollDisplayUp:		;next text line for UpdateScoutingDisplay (column 0). After line 7, move the text box up (93G hockey93_07)
		;   SNES: next text line (column 0); after line 7 move the text box up one row ($89FC8F copies 8 textmap rows)
	stz.w DispAttribCtr
	inc.w VertLineScrolling
	lda.w VertLineScrolling
	sec
	sbc.w #$0007
	bmi .v1
	bvc .up
.ex1:
	jmp.w UpdateScoutingDisplay_rtl
.v1:
	bvc .ex1
.up:
	dec.w VertLineScrolling
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .push
	ldx.b xsave
	lda.w #$0007
	sta.b d3
	lda.w #textmap+$114		; textmap+$114: the text box
	sta.b d1
	lda.w #textmap>>16
	sta.b d1+2
.loop:
	lda.w #$0028
	sta.b d0
	lda.b d1
	clc
	adc.w #$0040
	sta.b d2
	lda.b d1+2
	sta.b d2+2
	jsl.l CopyWords		; bank $89: copy a textmap row
	lda.b d2
	sta.b d1
	lda.b d2+2
	sta.b d1+2
	dec.b d3
	bpl .loop
	stx.b xsave
	ldx.w #$000E
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
PlayoffTiles:		;packed playoff screen palette and tiles (decompressor $86FA3E): 128 colours, then 6 tiles; PlayoffScreen sends them to vram $1000
	incbin "../data/PlayoffTiles.chr.pak"		; $84F79D-$84F815
InitSortObjects:		;SNES: clear the sort objects, then set the 4 sso arrows, the 5 ffo objects and the 16 sort objects from SsoInitTable, FfoInitTable and SortObjInitTable; then
		;   SprSort
	ldx.w #$0000		; SortCords (all fields of the 16 objects)
.clr:
	stz.w Xpos,x
	inx
	inx
	cpx.w #$0840
	bne .clr
	ldx.w #$0000
	ldy.w #$0000
	lda.w #$0003
	sta.b d0
.sso:
	lda.w #$FFFF
	sta.w ssoz,y
	lda.l SsoInitTable,x
	sta.w ssox,y
	lda.l SsoInitTable+2,x
	sta.w ssoy,y
	lda.l SsoInitTable+4,x
	sta.w ssoframe,y
	lda.l SsoInitTable+6,x
	sta.w ssoattr,y
	txa
	clc
	adc.w #$0008
	tax
	iny
	iny
	dec.b d0
	bpl .sso
	ldx.w #$0000
	ldy.w #$0000
	lda.w #$0004
	sta.b d0
.ffo:
	lda.w #$FFFF
	sta.w ffoxofs,y
	lda.l FfoInitTable,x
	sta.w ffox,y
	lda.l FfoInitTable+2,x
	sta.w ffoy,y
	lda.l FfoInitTable+4,x
	sta.w ffoz,y
	lda.l FfoInitTable+6,x
	sta.w ffoframe,y
	lda.l FfoInitTable+8,x
	sta.w ffoattr,y
	txa
	clc
	adc.w #$000A
	tax
	iny
	iny
	dec.b d0
	bpl .ffo
	stz.b d6
	stz.b a1
	stz.b a2
	stz.b a3
	stz.b a4
.obj:
	ldx.b a2
	ldy.b a3
	lda.b d6
	sta.w SCnum,y
	lda.w #$FFFF
	sta.w oldframe,y
	sta.w pnum,y
	lda.l SortObjInitTable,x
	sta.w Xpos,y
	lda.l SortObjInitTable+2,x
	sta.w Ypos,y
	lda.l SortObjInitTable+4,x
	sta.w Zpos,y
	lda.l SortObjInitTable+6,x
	sta.w frame,y
	lda.l SortObjInitTable+8,x
	sta.w attribute,y
	lda.l SortObjInitTable+10,x
	sta.w radiusx,y
	lda.l SortObjInitTable+12,x
	sta.w radiusy,y
	lda.b d6
	asl a
	asl a
	asl a
	tay
	lda.l SortObjInitTable+14,x
	sta.w asslist,y
	ldy.b a3
	lda.l SortObjInitTable+16,x
	sta.w pflags,y
	lda.w #$0000
	sta.w pfnc,y
	cpy.w #$001E		; object $1E (puck shadow): pfnc
	bne .tm
	lda.w #$0001
	sta.w pfnc,y
.tm:
	cpx.w #$006C		; pfgoal for objects 6-11 and 12-15, pfteam $34 for 6-11
	rol a
	inc a
	and.w #$0001
	sta.w pfgoal,y
	cpx.w #$006C
	bcc .next
	cpx.w #$00D8
	bcs .next
	lda.w #$0034
	sta.w pfteam,y
.next:
	inc.b a3
	inc.b a3
	sep #$20
	lda.b d6
	asl a
	ldy.b a1
	sta.w OOlist,y
	inc.b a1
	rep #$30
	lda.b d6
	ldy.b a4
	sta.w OOlistpos,y
	inc.b a4
	inc.b a4
	inc.b d6
	lda.b a2
	clc
	adc.w #$0012
	sta.b a2
	lda.b d6
	cmp.w #$0010
	beq .sort
	jmp.w .obj
.sort:
	jml.l SprSort
SsoInitTable:		;SNES: 4 x (ssox, ssoy, ssoframe, ssoattr)
	dw $0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000
	dw $0040,$FFA4,$0000,$8000
	dw $FFC0,$FFA4,$0000,$8000
FfoInitTable:		;SNES: 5 x (ffox, ffoy, ffoz, ffoframe, ffoattr)
	dw $0000,$0000,$FFFF,$0188,$0000
	dw $0000,$0000,$FFFF,$0186,$0000
	dw $0000,$0000,$FFFF,$0187,$0000
	dw $0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$FFFF,$0161,$0000
SortObjInitTable:		;SNES: 16 x (Xpos, Ypos, Zpos, frame, attribute, radiusx, radiusy, assignment, pflags); objects 6-11 are team 2
	dw $0160,$00C0,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FF9C,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFB0,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFC4,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFD8,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFEC,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $00C0,$00C0,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0028,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$003C,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0050,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0064,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0078,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $0000,$010C,$0000,$0194,$0000,$0014,$0006,$0000,$0000
	dw $0000,$FEF4,$0000,$0195,$0000,$0014,$0006,$0000,$0000
	dw $0000,$0000,$0000,$018A,$0000,$0005,$0005,$0018,$0001
	dw $0000,$0000,$0000,$0189,$0000,$0003,$0003,$0019,$0000
Readjoy12:		;SNES: Readjoy1 and Readjoy2, d1 = the new presses of both pads
	jsl.l Readjoy1		; pad 1 or pad 2
	lda.b d1
	pha
	jsl.l Readjoy2
	pla
	ora.b d1
	sta.b d1
	rtl
DisplayStats:		;92G DisplayStats (penalty.asm): the STATS page of the pause menu: Shots, Power Play, Penalties, Body Checks (92G Fights Won), AttackZone for both teams
	jsl.l printbigz
	dw $000A		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02,"STATS"
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$07
	lda.w #$0016
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.w smallfontchars
	sta.b d2
	jsl.l eraser		; bank $8D: 92G eraser
	jsl.l printz
	dw $000B		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0D,$06,"      "
	jsl.l printz
	dw $000A		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0D,$07,"Shots"
	jsl.l printz
	dw $000F		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$08,"Power Play"
	jsl.l printz
	dw $000E		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$09,"Penalties"
	jsl.l printz
	dw $0010		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$0A,"Body Checks"
	jsl.l printz
	dw $000F		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$0B,"AttackZone"
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$1A,$07
	stz.b a2		; home stats at x 26, then the away stats at x 9
	jsl.l .ss
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$09,$07
	inc.b a2
	inc.b a2
.ss:		;92G .ss: the .sslist stats of team a2 at printx
	lda.w #DisplayStats_sslist
	sta.b a0
	lda.w #DisplayStats_sslist>>16
	sta.b a0+2
.sstop:
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	bmi .atz
	ldy.w printx
	phy
	clc
	adc.b a2
	tay
	lda.w $0000,y		; stat word of team a2 (absolute address +$0000,y)
	sta.b d0
	jsl.l pushnumber		; bank $8F: 93G pushnumber
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	bmi .nextss
	sta.b d1
	lda.w #mesarea
	sta.b a3
	lda.w #$0000
	sta.b a3+2
	lda.w #$0002
	sta.b [a3]
	jsl.l appstring		; bank $8F: appstring
	jsl.l appendz
	dw $0003		; printz inline string: length (counts itself), then control bytes / text
	db "/"
	lda.b a2
	clc
	adc.b d1
	tay
	lda.w $0000,y
	sta.b d0
	jsl.l pushnumber		; bank $8F: 93G pushnumber
	jsl.l appstring		; bank $8F: appstring
	lda.b a3
	sta.b a1
	lda.b a3+2
	sta.b a1+2
.nextss:
	lda.b [a1]
	inc a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w printx
	sta.w printx
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	bra .sstop
.atz:		;tmATOP as a time
	ldy.b a2
	lda.w tmATOP,y
	sta.b d0
	jsl.l PushTime		; bank $8F: 93G PushTime (d0 = time)
	lda.b [a1]
	inc a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w printx
	sta.w printx
	jml.l print
DisplayStats_sslist:		;92G .sslist: stat, second stat (-1 = none)
	dw tmshots,-1, tmPwrGoals,tmPwrPlays, tmPenalties,tmPenmin, tmchecks,-1, -1,-1
GetNameandAttrib:		;print player d0's name, then at x $1E the column picked by (93G stats93)
		;   SNES: print player d0 (number and name), then at x 26 the column d4 (attribjmp); columns above 2 average the rating nibbles masked by
		;   d4 high word
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	jsl.l PlayerNumName
	jsl.l print
	lda.w #$001A
	sta.w printx
	lda.b d4		; status, energy, handed: no ratings
	cmp.w #$0003
	bcs .rate
	jmp.w .jump
.rate:
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmdata,y
	sta.b a0
	clc
	ldy.w #Playerdata
	adc.b [a0],y
	sta.b a0
.pl:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
	dec.b d0
	bpl .pl
	stz.b d0
	stz.b d1
	lda.w #$000F
	sta.b d2
	lda.b d4
	ldy.b d4+2
	sta.b d4+2
	sty.b d4
.one:
	lda.b d4
	sta.b tmp0
	lda.b d4+2
	sta.b tmp1
	lda.b d2
	sta.b tmp2
.sh:
	dec.b tmp2
	bmi .bit
	lsr.b tmp1
	ror.b tmp0
	bra .sh
.bit:
	lsr.b tmp0
	bcc .three
	lda.b d2
	lsr a
	eor.w #$FFFF
	inc a
	dec a
	clc
	adc.b a0
	sta.b tmp0
	lda.b a0+2
	sta.b tmp1
	lda.b [tmp0]
	sta.b d3
	lda.b d2
	lsr a
	bcc .lo
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
.lo:
	lda.b d3
	and.w #$000F
	sta.b d3
	clc
	adc.b d0
	sta.b d0
	lda.b d1
	clc
	adc.w #$000F
	sta.b d1
.three:
	dec.b d2
	bpl .one
	lda.b d4
	ldy.b d4+2
	sta.b d4+2
	sty.b d4
.jump:		;go to attribjmp[d4] through jmlvector
	lda.w #attribjmp
	sta.b a0
	lda.w #attribjmp>>16
	sta.b a0+2
	ldy.b d4
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
attribjmp:		;93G attribjmp: GetNameandAttrib column handlers, offsets from attribjmp
	dw AttribStatus-attribjmp,AttribEnergy-attribjmp,AttribHanded-attribjmp,AttribWeight-attribjmp,AttribFighting-attribjmp,AttribRating-attribjmp
AttribStatus:		;IDA: no label ("jump for status"). Player d0's word at $66(a2): (93G stats93)
		;   SNES: tmpdst of player d0: Ice/Bench/Injury, or the penalty time (injured: Inj G, $4000: C)
	asl.b d0
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	adc.b d0
	tay
	lda.w tmpdst,y		; tmpdst: negative = not of the status
	sta.b d0
	bpl .pen
	eor.w #$FFFF
	sta.b d0
	cmp.w #$0003
	bcc .st
	lda.w #$0001
	sta.b d0
	bra .st
.inj:
	lda.w #$0003
	sta.b d0
.st:
	lda.w #StatusTextTbl>>16
	sta.b a1+2
	lda.w #StatusTextTbl
	sta.b a1
	jml.l PrintStringFromList		; bank $8F: 93G PrintStringFromList (d0 = index, [a1] = list)
.pen:
	lda.b d0
	bit.w #TMPDINJ
	bne .inj
	dec.w printx
	lda.b d0
	sta.b d1
	and.w #$0FFF
	sta.b d0
	jsl.l PushTime		; bank $8F: 93G PushTime (d0 = time)
	jsl.l print
	lda.w #$0004
	sta.b d0
	lda.w #$4000
	trb.b d1
	beq .t
	lda.w #$0005
	sta.b d0
.t:
	lda.w #StatusTextTbl>>16
	sta.b a1+2
	lda.w #StatusTextTbl
	sta.b a1
	jml.l PrintStringFromList		; bank $8F: 93G PrintStringFromList (d0 = index, [a1] = list)
StatusTextTbl:		;93G StatusTextTbl: AttribStatus strings
	%String("Ice   ")
	%String("Bench ")
	%String("Inj P ")
	%String("Inj G ")
	%String("  ")
	%String(" C")
AttribEnergy:		;IDA: no label ("jump for energy"). $32(a2) word / 40, max 100 (93G stats93)
		;   SNES: tmpde of player d0 / 40, max 100
	asl.b d0
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	adc.b d0
	tay
	lda.w tmpde,y		; divu16 by 40
	sta.b mulb
	lda.w #$0028
	sta.b mula
	jsl.l divu16
	cmp.w #$0065
	bcc .pr
	lda.w #$0064
.pr:
	sta.b d0
	bra AttribPrintPct
AttribFighting:		;IDA: no label ("jump for fighting"). Bit 0 of the nibble is (93G stats93)
		;   SNES: bit 0 of the nibble is handedness, only bits 1-3 count
	lda.b d0
	and.w #$000E
	sta.b d0
	dec.b d1
AttribRating:		;IDA: no label. Sum d0 of d1/15 ratings as a percentage (93G stats93)
	lda.w #$0064
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b d1
	sta.b mula
	jsl.l divu
	sta.b d0
AttribPrintPct:		;93G AttribPrintPct: print d0 4 wide plus padding
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWidth		; bank $8F: 93G PushNumberWidth
	jsl.l print
	jsl.l printz
	dw $0004		; printz inline string: length (counts itself), then control bytes / text
	db "  "
	rtl
AttribHanded:		;IDA: no label ("jump for handedness"). Bit 0 of the sum (93G stats93)
	lda.b d0
	and.w #$0001
	sta.b d0
	lda.w #HandedTextTbl>>16
	sta.b a1+2
	lda.w #HandedTextTbl
	sta.b a1
	jml.l PrintStringFromList		; bank $8F: 93G PrintStringFromList (d0 = index, [a1] = list)
HandedTextTbl:		;93G HandedTextTbl: AttribHanded strings (93G Righty, Lefty)
	%String("Right ")
	%String("Left  ")
AttribWeight:		;IDA: no label ("jump for Weight"). 140 + 8 * rating lb (93G stats93)
	lda.b d0
	asl a
	asl a
	asl a
	adc.w #140
	sta.b d0
	jsl.l pushnumber		; bank $8F: 93G pushnumber
	jsl.l print
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db "   "
	rtl
unusedFF84:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF
