; $86F000-$86FFFF  ROM $37000-$37FFF: the last BootSamples and the end block of BootSoundUpload, then DecompressGraphics, UpdateLineChange,
; the song starters, setteams, ProcessInputWithRepeat, GetPeriodTimeRemaining, GetPeriodTime, lcfound2, PickStartingGoalie,
; assscore (logic93_2), $FF fill.
org $86F000
	incbin "../data/bootsamples.brr":$4837..$5271		; $86F000-$86FA39
BootSamplesEnd:
	assert BootSamplesEnd-BootSamples == BOOTSAMPLESIZE
	dw $0000, SPCDRIVER		; end block: length 0, start the driver at $0400
DecompressGraphics:		;send tiles to vram. a2 = data: word count of tiles (0 = none, bit 15 set = compressed by DecompressBytecode), then the tiles. d4 = start char, returns d4 = end char +
		;   1. Uses remap with callbackPtr when it is set, else DoDMApro (93G middle93_2)
		;   SNES: unpack the stream at [tmp0] to $7F0000 (output pointer tmp1+1..+3, copy distance tmp2+2). Control byte: $00-$1F copy n+1 bytes; $2x n+1 zeros; $3x n+3
		;   times the next byte; $40-$7F, $8x, $9x, $Ax, $Bx copy from earlier output going up; $C0-$DF, $Ex, $Fx going down; $E0 $00 ends
	stz.b tmp1+1		; output pointer = $7F0000
	lda.w #TestList>>16
	sta.b tmp1+3
.next:
	lda.b [tmp0]
	inc.b tmp0
	bit.w #$00E0
	bne .c20
	and.w #$001F
	tax
.lit:
	lda.b [tmp0]
	inc.b tmp0
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .lit
	bra .next
.c20:
	tay
	and.w #$00F0
	cmp.w #$0020
	bne .c30
	tya
	and.w #$000F
	tax
	lda.w #$0000
.zero:
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .zero
	bra .next
.c30:
	cmp.w #$0030
	bne .c40
	tya
	and.w #$000F
	tax
	inx
	inx
	lda.b [tmp0]
	inc.b tmp0
.fill:
	sta.b [tmp1+1]
	inc.b tmp1+1
	dex
	bpl .fill
	bra .next
.c40:		;$40-$7F: distance bits 3-5 + 1, length bits 0-2 + 2
	and.w #$00C0
	cmp.w #$0040
	bne .c80
	tya
	lsr a
	lsr a
	lsr a
	and.w #$0007
	inc a
	sta.b tmp2+2
	tya
	and.w #$0007
	inc a
	inc a
	tay
.up:		;copy Y bytes from output - distance, going up
	lda.b tmp1+1
	sec
	sbc.b tmp2+2
	tax
.upl:
	lda.l TestList,x
	inx
	sta.b [tmp1+1]
	inc.b tmp1+1
	dey
	bne .upl
	bra .next
.c80:		;$8x: length n+3, distance = next byte
	tya
	and.w #$00F0
	cmp.w #$0080
	bne .c90
	tya
	and.w #$000F
	inc a
	inc a
	inc a
	tay
	lda.b [tmp0]
	inc.b tmp0
	and.w #$00FF
	sta.b tmp2+2
	bra .up
.c90:		;$9x: distance 7 bits, length 5 bits
	cmp.w #$0090
	bne .cA0
	lda.b [tmp0]
	inc.b tmp0
	and.w #$007F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	xba
	and.w #$001F
	inc a
	inc a
	inc a
	tay
	bra .up
.cA0:		;$Ax: distance 6 bits, length 6 bits
	cmp.w #$00A0
	bne .cB0
	lda.b [tmp0]
	inc.b tmp0
	and.w #$003F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	asl a
	xba
	and.w #$003F
	inc a
	inc a
	inc a
	tay
	bra .up
.cB0:		;$Bx: distance 5 bits, length 7 bits
	cmp.w #$00B0
	bne .cC0
	lda.b [tmp0]
	inc.b tmp0
	and.w #$001F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	asl a
	asl a
	xba
	and.w #$007F
	inc a
	inc a
	inc a
	tay
	jmp.w .up
.cC0:		;$C0-$DF: going down
	and.w #$00E0
	cmp.w #$00C0
	bne .cE0
	tya
	lsr a
	lsr a
	and.w #$0007
	inc a
	sta.b tmp2+2
	tya
	and.w #$0003
	inc a
	inc a
	tay
.down:		;copy Y bytes going down from output - distance
	lda.b tmp1+1
	sec
	sbc.b tmp2+2
	tax
.dnl:
	lda.l TestList,x
	dex
	sta.b [tmp1+1]
	inc.b tmp1+1
	dey
	bne .dnl
	jmp.w .next
.cE0:		;$Ex: length n+3, distance = next byte (0 = end)
	tya
	and.w #$00F0
	cmp.w #$00E0
	bne .cF0
	tya
	and.w #$000F
	inc a
	inc a
	inc a
	tay
	lda.b [tmp0]
	inc.b tmp0
	and.w #$00FF
	beq .end
	sta.b tmp2+2
	bra .down
.cF0:		;$Fx: going down, distance 7 bits, length 5 bits
	lda.b [tmp0]
	inc.b tmp0
	and.w #$007F
	inc a
	sta.b tmp2+2
	tya
	xba
	asl a
	xba
	and.w #$001F
	inc a
	inc a
	inc a
	tay
	bra .down
.end:
	rtl
UpdateLineChange:		;called once per second. Restore energy for players on the bench (93G hockey93_01)
		;   SNES: once a second with line changes on, players on the bench (TMPDBENCH) regain 10 energy up to $1000, both teams
	lda.w OptLine
	bne .rtl
	stz.b a2		; home team, then the away team
	jsl.l .tm
	lda.w #$0002
	sta.b a2
.tm:
	lda.w #$0032
	sta.b d0
.pl:
	lda.b a2
	beq .p2
	lda.w #$0034
.p2:
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
	bmi .v1
	bvc .max
	bra .next
.v1:
	bvc .next
.max:
	lda.w #$1000
	sta.w tmpde,y
.next:
	dec.b d0
	dec.b d0
	bpl .pl
.rtl:
	rtl
StartSong6:		;SNES: start song 6 (the title screen music: TitleScreen $88F3A1, $8FF05C) unless it plays: the boot sound set (SPCBootUpload), then driver command 3
	lda.w cursong
	cmp.w #6
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20		; APUIO0 = 3: play song 6
	lda.b #$03
	sta.w APUIO0
	rep #$30
	lda.w #6
	sta.w cursong
.rtl:
	rtl
StartSong7:		;SNES: start song 7 (driver command 2); no caller found
	lda.w cursong
	cmp.w #7
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$02
	sta.w APUIO0
	rep #$30
	lda.w #7
	sta.w cursong
.rtl:
	rtl
setteams:		;use hometeam/visteam to set team structures. Falls in from clearTeamStats, also called from hockey93_08. (93G hockey93_06)
		;   SNES: with InitTeamSructure: use HomeTeam/VisTeam to set the team structs (tmsort, tmteam, tmdata from TeamList). Falls in from ClearTeamStats
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
ProcessInputWithRepeat:		;nodiag, then key repeat on d1-d3 from Readjoy1/2. A change (d2) resets the delay to 15 frames; while the same buttons stay held, every 4 frames return d1 = held
		;   buttons (d3). Called from Pausemode, menus and IntermissionLoop (93G middle93_1)
		;   SNES: nodiag (nullrtl85), then key repeat: a change (d2) resets the delay to 15 frames; while the same buttons stay
		;   held, every 4 frames d1 = held buttons (d3)
	jsl.l nullrtl85
	lda.b d3
	beq .rtl
	lda.b d2		; d2 = changed buttons
	bne .chg
	dec.w repeatdelay
	bpl .rtl
	lda.w #4
	sta.w repeatdelay
	lda.b d3
	sta.b d1
.rtl:
	rtl
.chg:
	lda.w #15
	sta.w repeatdelay
	rtl
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
GetPeriodTimeRemaining:		;return d0 = (gsp << 14 | PerTimeTotal) - gameclock. Called from Goal (ScoreSum entry) and InProgress (penalty93_1) (93G hockey93_04)
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
GetPeriodTime:		;return d0 = period length in seconds for the period length option (93G hockey93_01)
		;   SNES: d0 = period length in seconds for OptPerlen
	phx
	lda.w OptPerlen
	asl a
	tax
	lda.l GetPeriodTime_timetab,x
	sta.b d0
	plx
	rtl
GetPeriodTime_timetab:		;93G .timetab (IDA PeriodTimeTable): 5, 10, 20 minutes, 30 seconds
	dw 5*60,10*60,20*60,30
lcfound2:		;close lc box. Also called from lineinput (93G logic93_1)
		;   SNES: close the line change box (setlccords; the lower box clears sf3llcs), erase it unless the faceoff box is up, then printscores1
	jsl.l setlccords
	lda.w printy
	sec
	sbc.w #15
	bmi .v1
	bvc .low
	bra .nollcm
.v1:
	bvc .nollcm
.low:
	lda.w #sf3llcs
	trb.w sflags3
.nollcm:
	inc.b d1
	lda.w blankchar
	sta.b d2
	lda.b fobox
	bne .ps
	jsl.l eraser		; bank $8D: 92G eraser
.ps:
	jml.l printscores1
PickStartingGoalie:		;SNES: tmgoalie of team a2 = 0 ($8B807D); a computer team in the later playoff rounds (gamelevel >= 2, line changes on) picks the goalie by its scouting
		;   report ($8FF4D8, $8FE3B0)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	ldy.b a2
	lda.w #$0000
	sta.w tmgoalie,y
	jsl.l FigureJoy		; bank $8B
	lda.b a2
	tay
	lsr a
	inc a
	sta.b d0
	cmp.w cont1team		; a controller team: keep goalie 0
	beq .ex
	cmp.w cont2team
	beq .ex
	stz.b d0
	lda.w gamelevel
	sec
	sbc.w #$0002
	beq .po
	bmi .v1
	bvs .po
	bra .set
.v1:
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
	jsl.l UnpackNibbles		; bank $8F
	jsl.l WeightedRandomSelect		; bank $8F
.set:
	ldy.b a2
	lda.b d0
	sta.w tmgoalie,y
.ex:
	stx.b xsave
	ldx.w #$0002
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
assscore:		;asstab 7. player a3 celebrates, if scoring player then do arm pump (93G logic93_2)
		;   SNES: player X celebrates, the scorer pumps his arm. SNES: velocities * 3/4 each frame, the carrier drops the puck (nopuck 1800)
	lda.w Xvel,x		; Xvel, Yvel *= $C0/256
	sta.b mula
	lda.w #$00C0
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #$00C0
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1
	sta.w Yvel,x
	txa		; the carrier drops the puck
	lsr a
	cmp.w puckc
	bne .al
	lda.w #$FFFF
	sta.w puckc
	lda.w #1800
	sta.w nopuck,x
.al:
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #pfna		; new assignment: spot (+-90, Vpos)
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	jsl.l .one
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #90
	sta.w temp3,x
	lda.w Hpos
	bpl .zero
	lda.w #-90
	sta.w temp3,x
.zero:		;93G .0
	lda.w Vpos
	sta.w temp4,x
.nna:
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w temp1,x		; temp1 runs out: celebrate (SPApump for the scorer)
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .chkcon
	sta.w pfalock,x
	lda.w #SPAcelebrate
	sta.b d1
	txa
	lsr a
	cmp.w shotplayer
	bne .nopump
	lda.w #SPApump
	sta.b d1
.nopump:
	jsl.l SetSPA
.one:		;93G .1: temp1 = random 120
	lda.w #120
	jsl.l randoma
	sta.w temp1,x
.rtl:
	rtl
.chkcon:		;joystick controlled: stand, else skateto
	lda.w pflags,x
	bit.w #pfjoycon
	bne .rtl2
	jml.l skateto
.rtl2:
	rtl
unusedFF86:		;unused, $FF fill to the end of the bank
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
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
