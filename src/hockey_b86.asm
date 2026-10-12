; The game, screens, menus, password, playoffs.
; Bank $86. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $86FB96
RestoreBenchEnergy:		;called once per second. Restore energy for players on the bench
		;   SNES: once a second with line changes on, players on the bench (TMPDBENCH) regain 10 energy up to $1000, both teams
	lda.w OptLine
	bne .x
	stz.b a2		; home team, then the away team
	jsl.l .team
	lda.w #$0002
	sta.b a2
.team:
	lda.w #$0032
	sta.b d0
.b0:
	lda.b a2
	beq .away
	lda.w #$0034
.away:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y		; on the bench?
	cmp.w #TMPDBENCH
	bne .next
	lda.w tmpde,y
	clc
	adc.w #10
	sta.w tmpde,y
	sec
	sbc.w #$1000
	bmi .neg
	bvc .max
	bra .next
.neg:
	bvc .next
.max:
	lda.w #$1000
	sta.w tmpde,y
.next:
	dec.b d0
	dec.b d0
	bpl .b0
.x:
	rtl

org $86FC29
setteams:		;use hometeam/visteam to set team structures. Falls in from clearTeamStats.
		;   SNES: with InitTeamStructure: use HomeTeam/VisTeam to set the team structs (tmsort, tmteam, tmdata from TeamList). Falls in from ClearTeamStats
	stz.w tmsort		; home: tmsort 0, away: tmsort $0C
	lda.w #$000C
	sta.w tmsort+2
	lda.w HomeTeam
	sta.w tmteam
	asl a
	asl a
	tax
	lda.l TeamList,x
	sta.w tmdata
	lda.w VisTeam
	sta.w tmteam+2
	asl a
	asl a
	tax
	lda.l TeamList,x
	sta.w tmdata+2
	rtl

org $86FC76
ScoutNamePos:		;SNES: print position of a showcased player name: x 1, y 10; the home team (a2 = 0) at x 20
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$0A
	lda.b a2
	bne .rtl
	lda.w #20
	sta.w printx
.rtl:
	rtl
GetPeriodTimeRemaining:		;return d0 = (gsp << 14 | PerTimeTotal) - gameclock. Called from Goal (ScoreSum entry) and InProgress
		;   SNES: d0 = (gsp << 14 | PerTimeTotal) - gameclock (Goal and InProgress log it)
	lda.w gsp		; gsp in bits 14-15
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	ora.w PerTimeTotal
	sec
	sbc.w gameclock
	sta.b d0
	rtl
GetPeriodTime:		;return d0 = period length in seconds for the period length option
		;   SNES: d0 = period length in seconds for OptPerlen
	phx
	lda.w OptPerlen
	asl a
	tax
	lda.l GetPeriodTime_timetab,x
	sta.b d0
	plx
	rtl
GetPeriodTime_timetab:		;5, 10, 20 minutes, 30 seconds
	dw 5*60,10*60,20*60,30

org $86FCE3
PickStartingGoalie:		;SNES: tmgoalie of team a2 = 0 (FigureJoy); a computer team in the later playoff rounds (gamelevel >= 2, line changes on) picks the goalie by its scouting
		;   report (UnpackNibbles, WeightedRandomSelect)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	ldy.b a2
	lda.w #$0000
	sta.w tmgoalie,y
	jsl.l FigureJoy
	lda.b a2
	tay
	lsr a
	inc a
	sta.b d0
	cmp.w cont1team		; a controller team: keep goalie 0
	beq .x
	cmp.w cont2team
	beq .x
	stz.b d0
	lda.w gamelevel
	sec
	sbc.w #$0002
	beq .po
	bmi .neg
	bvs .po
	bra .set
.neg:
	bvs .set
.po:
	lda.w OptLine
	bne .set
	lda.w #TeamList
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmshots,y
	asl a
	asl a
	tay
	lda.b [a0],y
	sta.b a0
	ldy.w #ScoreOdds
	adc.b [a0],y
	sta.b a0
	lda.w #$0004
	sta.b d0
	jsl.l UnpackNibbles
	jsl.l WeightedRandomSelect
.set:
	ldy.b a2
	lda.b d0
	sta.w tmgoalie,y
.x:
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
