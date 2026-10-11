; The game, screens, menus, password, playoffs.
; Bank $85. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $85D5A4
GetShifter:		;/GetShifter: d1 = number of games - 1, d2 = first bit of WinBits for the playoff gamelevel
	lda.w #-16
	sta.b d2
	lda.w #16
	sta.b d1
	ldy.w gamelevel
.3:
	lda.b d2
	clc
	adc.b d1
	sta.b d2
	lsr.b d1
	dey
	bpl .3
	dec.b d1
	rtl

org $85FF0E
getpzjoy:		;read the joystick of the pad that paused (sfpj: Readjoy2, else Readjoy1)
	lda.w sflags
	bit.w #sfpj
	beq .p1
	jml.l Readjoy2
.p1:
	jml.l Readjoy1
PrintTeamNames:		;SNES: regular season: HomeTeam/VisTeam from the options; print both team names (DrawTeamBlocks), then setteams
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pusha
	ldx.b xsave
	lda.w OptPlayMode		; OptPlayMode 0: teams from the options
	bne .pr
	lda.w OptTeam1
	sta.w HomeTeam
	lda.w OptTeam2
	sta.w VisTeam
.pr:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$02,$01
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks		; bank $8D: print team d1 name
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$15,$01
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks		; bank $8D: print team d1 name
	jsl.l setteams
	stx.b xsave
	ldx.w #$000A
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
nullrtl85:		;does nothing
	rtl
ResetClock:		;set period length and stop clock
		;   SNES: set the period length (GetPeriodTime; regular season overtime is 10:00) and stop the clock
	jsl.l GetPeriodTime
	lda.w gsp		; gsp >= 3 (overtime) and OptPlayMode 0: 600 seconds
	sec
	sbc.w #$0003
	bmi .v1
	bvc .ot
	bra .set
.v1:
	bvc .set
.ot:
	lda.w OptPlayMode
	bne .set
	lda.w #600
	sta.b d0
.set:
	lda.b d0		; gameclock = PerTimeTotal = d0, gmclock
	sta.w gameclock
	sta.w PerTimeTotal
	sta.w gmclock
	rtl
unusedFF85:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
