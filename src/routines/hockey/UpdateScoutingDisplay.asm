UpdateScoutingDisplay:		;Every frame of the scouting report: print the next word of the commentary when its timer runs out,
		;   filling in team and goalie names
	lda.w ScoutingReportTimer		; text finished ($7FFF)
	sec
	sbc.w #$1000
	beq .tm
	bmi .neg
	bvs .tm
	bra .rtl
.neg:
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
	bmi .neg1
	bvs .noscr
.scr:
	jsl.l ScrollDisplayUp
	bra .noscr
.neg1:
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
