; The game, screens, menus, password, playoffs.
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84EA66
ScoutPlayersRun:		;SNES scouting report: one frame of the two showcased players (home a2 = 0, away a2 = 2), then draw them
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .savea
	ldx.b xsave
	lda.w #$0001		; d7 = 1 frame
	sta.b d7
	stz.b a2
	jsl.l ScoutTeamStep
	lda.w #$0002
	sta.b a2
	jsl.l ScoutTeamStep
	jsl.l DrawScoutPlayers
	stx.b xsave
	ldx.w #$001A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
ScoutTeamStep:		;SNES: step the showcased player of team a2: a new team (tmteam changed) picks its goalie and restarts the order (ScoutPlayerExit); skating out to the side
		;   (tmflags bit 1) ends at x 40 (ScoutNextPlayer); else the next script step (SPA, facedir) every 9 frames, then print his number and name
	ldy.b a2
	lda.w tmteam,y		; team changed?
	sta.b d0
	cmp.w tmshots,y
	beq .cur
	sta.w tmshots,y
	jsl.l PickStartingGoalie
	ldy.b a2
	lda.w #$0000
	sta.w tmPwrGoals,y
	jsl.l ScoutPlayerExit
.cur:
	ldy.b a2
	lda.w tmsort,y		; X = a3 = first object of the team
	sta.b a3
	tax
	lda.w tmflags,y
	bit.w #$0002
	beq .in
	inc.w OldZpos,x		; skating out: x += 3
	inc.w OldZpos,x
	inc.w OldZpos,x
	inc.w OldXpos,x
	inc.w OldXpos,x
	inc.w OldXpos,x
	lda.w OldXpos,x
	sec
	sbc.w #40
	beq .rtl
	bmi .v1
	bvs .rtl
.next1:
	jmp.w ScoutNextPlayer
.v1:
	bvs .next1
.rtl:
	rtl
.in:		;skating in from the left
	lda.w OldXpos,x		; skating in: x += 1 while negative
	bpl .anim
	inc.w OldZpos,x
	inc.w OldXpos,x
.anim:
	jsl.l updateanim
	lda.w pf2aip,x		; pf2aip: wait for the step delay
	beq .step
	jmp.w ScoutPlayerExit_rtl
.step:		;next script step
	ldy.b a2
	lda.w tmPenmin,y		; a0 = ScoutScripts + offset of the script + step; step += 4
	asl a
	sta.b d0
	tay
	lda.w #ScoutScripts>>16
	sta.b a0+2
	lda.w #ScoutScripts
	sta.b a0
	clc
	adc.b [a0],y
	ldy.b a2
	adc.w tmATOP,y
	sta.b a0
	lda.w tmATOP,y
	adc.w #$0004
	sta.w tmATOP,y
	lda.b [a0]
	sta.b d1
	bne .set
	jmp.w ScoutPlayerExit
.set:
	jsl.l SetSPA		; SetSPA d1, 9 frames per step, facedir
	lda.w #$0009
	sta.w pf2aip,x
	ldy.w #$0002
	lda.b [a0],y
	sta.w facedir,x
	bmi .flip
	jmp.w ScoutPlayerExit_rtl
.flip:		;negative facedir: first step of a new player, print the name
	eor.w #$FFFF
	inc a
	sta.w facedir,x
	ldy.b a2
	lda.w tmPwrPlays,y
	sta.b d0
	jsl.l GetRosterEntry		; mesarea = number and the first name, centered in 11 columns
	jsl.l ScoutNamePos
	lda.w printx
	pha
	lda.w #mesarea+2
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b [a0]
	tay
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	beq .lo
	clc
	adc.w #$0030
	sta.b [a1]
	inc.b a1
.lo:
	lda.b d0
	and.w #$000F
	clc
	adc.w #$0030
	sta.b [a1]
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	ldy.w #$0001
.first:
	iny
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$0020
	beq .pr1
	sta.b [a1]
	inc.b a1
	bra .first
.pr1:
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	dec a
	dec a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000B
	lsr a
	clc
	adc.w printx
	sta.w printx
	lda.w #mesarea
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	lda.b [a0]		; then the last name on the next line
	sta.b tmp0
	ldy.w #$0001
.skip:
	iny
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$0020
	bne .skip
	lda.w #mesarea+2
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.last:
	iny
	cpy.b tmp0
	beq .pr2
	lda.b [a0],y
	sta.b [a1]
	inc.b a1
	bra .last
.pr2:
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	dec a
	dec a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000B
	lsr a
	clc
	adc.w printx
	sta.w printx
	lda.w #mesarea
	sta.b a1
	jml.l print
ScoutPlayerExit:		;SNES: the showcased player of team a2 skates off (EraseScoutName, tmflags bit 1)
	jsl.l EraseScoutName
	ldy.b a2
	lda.w tmflags,y
	ora.w #$0002
	sta.w tmflags,y
.rtl:
	rtl
ScoutNextPlayer:		;SNES: the next showcased player of team a2 from ScoutLineOrder (goalie: tmgoalie): start at x -40, pick his ScoutScripts entry from his ratings
	jsl.l SetTeamColors
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFFD
	sta.w tmflags,y
	lda.w tmsort,y
	sta.b a3
	tax
	lda.w #-40
	sta.w OldXpos,x
	stz.w SPA,x
.order:
	ldy.b a2
	lda.w tmPwrGoals,y
	sta.b d0
	tay
	lda.w #ScoutLineOrder		; ScoutLineOrder[tmPwrGoals]: $FF restarts the list
	sta.b a0
	lda.w #ScoutLineOrder>>16
	sta.b a0+2
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	beq .got
	ldy.b a2
	lda.w #$0000
	sta.w tmPwrGoals,y
	bra .order
.got:
	ldy.b a2
	lda.b d0
	sta.w tmPenalties,y
	lda.w tmPwrGoals,y
	inc a
	sta.w tmPwrGoals,y
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmdata,y		; roster player = LineSets byte - 1 (goalie slot: tmgoalie)
	sta.b a0
	clc
	ldy.w #LineSets
	adc.b [a0],y
	sta.b a0
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	dec a
	sta.b d0
	ldy.b a2
	lda.w tmPenalties,y
	bne .pl
	lda.w tmgoalie,y
	sta.b d0
.pl:
	lda.b d0
	ldy.b a2
	sta.w tmPwrPlays,y
	jsl.l GetRosterEntry
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.w attribute,x		; handedness bit: flip
	and.w #$F7FF
	sta.w attribute,x
	ldy.w #Playerdata+4
	lda.b [a0],y
	lsr a
	bcs .rate
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
.rate:		;ScoutPickScript for each of the 14 rating nibbles (ScoutScriptPick, goalies ScoutScriptPickG)
	inc.b a0
	lda.w #$0006
	sta.b d0
	stz.b d2
	lda.w #ScoutScriptPick
	sta.b a1
	lda.w #ScoutScriptPick>>16
	sta.b a1+2
	ldy.b a2
	lda.w tmPenalties,y
	and.w #$0007
	sta.b d3
	bne .nib
	lda.w #ScoutScriptPickG
	sta.b a1
.nib:
	lda.b [a0]
	and.w #$00FF
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
	jsl.l ScoutPickScript
	lda.b [a0]
	inc.b a0
	and.w #$000F
	sta.b d1
	jsl.l ScoutPickScript
	dec.b d0
	bpl .nib
	ldy.b a2
	lda.w #$0000
	sta.w tmATOP,y
	rtl
ScoutPickScript:		;SNES: rating nibble d1 against the next (minimum, script) pair at [a1]: the highest qualifying rating picks tmPenmin
	lda.b [a1]
	and.w #$00FF
	sta.b tmp0
	inc.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b tmp1
	inc.b a1
	lda.b d1
	sec
	sbc.b tmp0
	bmi .v1
	bvc .best
.ex1:
	jmp.w ScoutPlayerExit_rtl
.v1:
	bvc .ex1
.best:
	lda.b d1
	sec
	sbc.b d2
	bmi .v2
	bvc .z
.ex2:
	jmp.w ScoutPlayerExit_rtl
.v2:
	bvc .ex2
.z:
	lda.b d2
	beq .take
	lda.b tmp0
	bne .take
	jmp.w ScoutPlayerExit_rtl
.take:
	lda.b d1
	sta.b d2
	ldy.b a2
	lda.b tmp1
	sta.w tmPenmin,y
	rtl
GetRosterEntry:		;SNES: a0 = Playerdata entry of roster player d0 of team a2 (walks the Player list)
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	clc
	ldy.w #Playerdata
	adc.b [a0],y
	sta.b a0
	bra .cnt
.next:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
.cnt:
	dec.b d0
	bpl .next
	rtl
ScoutScriptPick:		;SNES: (minimum rating, script) per rating nibble for skaters
	db 0,1, 11,2, 0,1, 0,1, 11,6, 11,3, 0,1, 11,7, 11,4, 0,1, 0,1, 0,1, 0,1, 0,1
ScoutScriptPickG:		;SNES: (minimum rating, script) per rating nibble for goalies
	db 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 11,5, 11,5
ScoutScripts:		;SNES: the showcase animation scripts: 8 offsets, then (SPA, facedir) steps; a negative facedir prints the name (and flips), 0 ends
	dw .s0-ScoutScripts,.s1-ScoutScripts,.s2-ScoutScripts,.s3-ScoutScripts,.s4-ScoutScripts,.s5-ScoutScripts,.s6-ScoutScripts,.s7-ScoutScripts
.s0:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglover,4,SPAgready2,4,SPAgglovel,4,SPAgready2,4,0
.s5:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglovel,4,SPAgready2,4,SPAgready2,4,0
.s1:	dw SPAskate,3,SPAskate,4,SPAcelebrate,-5,SPAcelebrate,4,SPAglide,4,SPAglide,4,0
.s2:	dw SPAskatewp,4,SPAskatewp,4,SPAskatewp,-4,SPAglide,4,SPAglide,4,0
.s3:	dw SPAskatewp,5,SPAskatewp,5,SPAshotf,-5,SPAglide,5,SPAglide,5,0
.s4:	dw SPAskatewp,3,SPAskatewp,3,SPAstumble,-3,SPAshotf,3,SPAglide,3,SPAglide,3,0
.s6:	dw SPAskate,4,SPAskate,5,SPAsweepchk,-5,SPAsweepchk,5,SPAskate,5,SPAsweepchk,5,SPAglide,5,SPAglide,5,0
.s7:	dw SPAskate,3,SPAskate,2,SPAfight,-2,SPAfhigh,2,SPAflow,2,SPAfhigh,2,SPAflow,2,0
ScoutLineOrder:		;SNES: the LineSets bytes shown in order (lines 1-3), $FF ends
	db $04,$05,$03,$00,$02,$01,$0C,$0D,$0B,$0A,$09,$14,$15,$13,$12,$11,$FF
DrawScoutPlayers:		;SNES: addframe for the two showcased players (objects 0 and 6)
	ldx.w #$0000
	stx.b a3
	jsl.l DrawScoutPlayer
	ldx.w #$000C
	stx.b a3
DrawScoutPlayer:		;SNES: addframe for object X at (Xpos + OldXpos - 144, Ypos - 128)
	lda.w Xpos,x
	clc
	adc.w OldXpos,x
	sec
	sbc.w #$0090
	sta.b sprx
	lda.w Ypos,x
	sec
	sbc.w #$0080
	sta.b spry
	lda.w frame,x
	sta.b sprframe
	lda.w attribute,x
	and.w #$0800
	sta.b sprhflip
	lda.w attribute,x
	and.w #$1000
	sta.b sprvflip
	lda.w attribute,x
	lsr a
	bcc .add
	lda.w #$8000
	sta.b sprflag
.add:
	jml.l addframe

org $84F532
UpdateScoutingDisplay:		;called every frame by ScoutingReport. When ScoutingReportTimer runs out (at once if asv
		;   is set), print the next word of ScoutingReportText. PlayerScrollCtr = offset of the next word (negative: next paragraph),
		;   DispAttribCtr = column
		;   SNES: '~' '{' '}' '[' ']' print a team or goalie name
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
	jmp.w .under
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
.under:		;~: the home team (Montreal for the All-Star teams)
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
ScrollDisplayUp:		;next text line for UpdateScoutingDisplay (column 0). After line 7, move the text box up
		;   SNES: next text line (column 0); after line 7 move the text box up one row (CopyWords copies 8 textmap rows)
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
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .save
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
	jsl.l CopyWords		; copy a textmap row
	lda.b d2
	sta.b d1
	lda.b d2+2
	sta.b d1+2
	dec.b d3
	bpl .loop
	stx.b xsave
	ldx.w #$000E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
