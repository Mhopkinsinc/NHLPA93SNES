; Penalties, scoreboard, ticker, intermission.
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $80A828
ClrHor:		;revert the graphics back to vertical ice rink mode. 93 does not remap the fonts
		;   SNES: revert to the vertical ice rink: clear sfhormode, Oldrow, SprSort, clear the text map, printscores1
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$003C
	bne .push
	ldx.b xsave
	stz.w sfhormode		; vertical
	lda.w #999		; Oldrow = 999: redraw the rink rows
	sta.w Oldrow
	jsl.l SprSort
	lda.w sflags
	bit.w #sfpz		; paused: keep the text
	bne .pop
	lda.w blankchar		; clear the text map
	clc
	adc.w charofs
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	stz.b textdirtylo		; whole text map dirty
	lda.w #$03FF
	sta.b textdirtyhi
	jsl.l printscores1		; bank $89
.pop:
	stx.b xsave
	ldx.w #$003A
.popl:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popl
	ldx.b xsave
	ldx.b a3
	rtl

org $80B84C
AvgCline:		;return d0 = average energy of current line on team a2
		;   SNES: d0 = average energy of the current line of team a2
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$000C
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
	stz.b d0
	stz.b d1
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.loop:
	ldy.b a0
	lda.w position,y
	beq .next
	bmi .next
	lda.w pnum,y
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpde,y
	adc.b d0
	sta.b d0
	inc.b d1
.next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .loop
	lda.b d1		; players counted
	beq .ex
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l divu16
	sta.b d0
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
	ldx.w #$000A
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl

org $80B9F4
updatepwrplay:		;show graphic and time remaining for power plays. 93: plays song $33 at the start of a home power play, then prints the time and the team on the power play
		;   SNES: show the power play box: time left and the team on the power play
	stz.b a2		; a2 = home, a3 = away
	lda.w #$0002
	sta.b a3
	lda.w tmap
	sec
	sbc.w tmap+2
	sta.b d0
	bne .neg
	jmp.w updatepwrplay_clr
.neg:
	bpl .t0
	lda.w sflags
	bit.w #sf2pwrtm		; sf2pwrtm
	bne .upp
	jsl.l updatepwrplay_clr
	lda.w #sf2pwrtm
	tsb.w sflags
	bra .upp
.t0:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w sflags
	bit.w #sf2pwrtm
	beq .upp
	jsl.l updatepwrplay_clr
	lda.w #sf2pwrtm
	trb.w sflags
.upp:
	lda.w #sf2pwrplay		; sf2pwrplay; new: tmPwrPlays + 1
	tsb.w sflags
	bne .uppt
	ldx.b a3
	inc.w tmPwrPlays,x
.uppt:
	jsl.l printz
	dw $0012		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19,"   ",$16,$17,$18,$19,$BF,$01,$1A,"   "
	jsl.l GetLowestPen		; bank $8D
	jsl.l PushTime		; bank $8F
	jsl.l print
	ldx.b a3
	lda.w tmdata,x		; team name (bank $83)
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w #mesarea		; a3 = mesarea, length 2
	sta.b a3
	lda.w #mesarea>>16
	sta.b a3+2
	lda.w #$0002
	sta.b [a3]
	jsl.l appendz		; appendz (bank $82)
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	lda.b a0
	ldy.w #$0004
	clc
	adc.b [a0],y
	sta.b a0
	adc.b [a0]
	sta.b a0
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	jsl.l appstring		; appstring, bank $8F
	lda.b a3
	sta.b a1
	lda.b a3+2
	sta.b a1+2
	jmp.w print
updatepwrplay_clr:		;power play over, EASN logo back
	lda.w #sf2pwrplay
	trb.w sflags
	beq .rtl
	jml.l EASNLogo		; EASNLogo, bank $8D
.rtl:
	rtl
printteamname:		;print the team name of team d3 (0 home) at printx/printy, then printy += 2
	lda.w printx
	pha
	lda.w tmdata		; tmdata of team d3
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b d3
	beq .name
	lda.w tmdata+2
	sta.b a1
.name:
	ldy.w #Teamname
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	adc.b a1
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	inc.w printy
	rtl

org $80C18F
AddPenalty:		;add penalty d0 (PenaltyList offset) for player X. Ignored while the clock is stopped, when penalties are off, or offsides when offsides
		;   are off. Falls into AddPenalty2
	lda.w gmclock		; clock stopped
	bne .rtl
	lda.b d0
	cmp.w #PenIcing		; icing always counts
	beq AddPenalty2
	lda.w OptPen		; penalties off
	beq .rtl
	lda.w gmode
	bit.w #gmoffs		; offsides on: all count
	bne AddPenalty2
	lda.b d0
	cmp.w #PenOffsides		; offsides off: no offsides penalty
	bne AddPenalty2
.rtl:
	rtl
AddPenalty2:		;forced penalties like face off and game over. d0 = penalty, X = player or a player of the penalized team
	lda.w sfhormode		; horizontal rink: none
	beq .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
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
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.b d0
	sec
	sbc.w #$000E		; goal (93 $E) and up
	bmi .v1
	bvc .snd
	bra .nosnd
.v1:
	bvc .nosnd
.snd:		;goal and up: crowd and a sound
	lda.b crowdlevel		; crowd +200
	clc
	adc.w #$00C8
	sta.b crowdlevel
	lda.w #SFXcrowdboo		; home penalized: boo; visitors: cheer
	pha
	lda.w pfteam,x
	beq .sfx
	lda.w #SFXcrowdcheer
	sta.b $01,s
.sfx:
	jsl.l sfx
.nosnd:
	lda.w #PenBuf		; a1 = PenBuf, 32 slots
	sta.b a1
	lda.w #PenBuf>>16
	sta.b a1+2
	lda.w #$001F
	sta.b d1
.find:		;find a free PenBuf slot
	lda.b [a1]
	inc.b a1
	inc.b a1
	tay
	beq .put
	dec.b d1
	bpl .find
	bra .noplayer
.put:
	dec.b a1
	dec.b a1
	txa		; store (SCnum << 8) | penalty
	lsr a
	xba
	and.w #$FF00
	ora.b d0
	sta.b [a1]
	lda.w #PenaltyList>>16		; a0 = PenaltyList + [d0]
	sta.b a0+2
	lda.w #PenaltyList
	sta.b a0
	ldy.b d0
	clc
	adc.b [a0],y
	sta.b a0
	lda.b [a0]		; penalty minutes
	and.w #$00FF
	beq .noplayer
	lda.w pflags,x
	pha
	ora.w #pf2pen		; pf2pen; already set: drop this one
	sta.w pflags,x
	pla
	bit.w #pf2pen
	beq .noplayer
	lda.w #$0000
	sta.b [a1]
.noplayer:
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
	ldx.w #$0002
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
	ldx.b xsave
.rtl:
	rtl

org $80D12E
ChkShotStat:		;add to shot stat if a shot was taken. 93 also raises the crowd and counts the shot for the shooter and against the other team's goalie
		;   SNES: if a shot was taken (sf2shot, cleared here), add 1 to the shooting team tmshots
	lda.w #sf2shot
	trb.w sflags
	beq .rtl
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	phx
	lda.w shotplayer
	asl a
	tax
	stx.b a3		; a3 = the shooter
	lda.w #$0001
	sta.b d0
	lda.w #tmshots
	sta.b d1
	jsl.l addteamstat
	plx
	stx.b a3
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
.rtl:
	rtl
addteamstat:		;add d0 to the team word stat at d1 (+2 for team 2, pfteam of X). inline in ChkShotStat
	ldy.b d1		; pfteam: team 2 word
	lda.w pfteam,x
	beq .add
	iny
	iny
.add:
	lda.w $0000,y		; absolute stat address in d1 (+$0000,y)
	clc
	adc.b d0
	sta.w $0000,y
	rtl

org $80D329
PenGoalStuff:		;do this stuff after a goal. a1 = scored on team, a2 = scoring team. If the scoring team had more players on ice, the first scored on player in the box without a coincidental
		;   penalty is released
		;   SNES: a1 = scored on team, a2 = scoring team. If the scoring team had more players on the ice, release the first scored on
		;   player in the box without a coincidental penalty
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
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
	jsl.l ClearPenaltyBuffer		; ClearPenaltyBuffer, bank $8F
	ldy.b a2
	lda.w tmap,y		; tmap(a2) - tmap(a1) > 0?
	ldy.b a1
	sec
	sbc.w tmap,y
	beq .ex
	bmi .v1
	bvc .more
	bra .ex
.v1:
	bvc .ex
.more:		;scoring team had more players on the ice
	lda.b a1
	beq .lst
	lda.w #$001A
.lst:
	sta.b a0
.loop:		;next player in the box list (negative = end)
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .ex
	lda.b a1
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y		; coincidental penalty: skip
	bit.w #$4000
	bne .loop
	lda.w #$0000		; out of the box, one more on the ice, power play goal
	sta.w tmpdst,y
	jsl.l RemovePlayerFromList		; bank $8F
	ldy.b a1
	lda.w tmap,y
	inc a
	sta.w tmap,y
	ldy.b a2
	lda.w tmPwrGoals,y
	inc a
	sta.w tmPwrGoals,y
	lda.w #tmflcc
	tsb.w tmflags		; line change box redraw
	tsb.w tmflags+2
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
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl

org $80E6C7
PenaltyManager:		;called periodically. d7 = elapsed time since last call
		;   SNES: updatepentime, checkfornewpen, chkprogress, UpdatePA
	jsl.l updatepentime		; updatepentime, checkfornewpen, chkprogress, then UpdatePA, bank $8F
	jsl.l checkfornewpen
	jsl.l chkprogress
	jmp.w UpdatePA
chkatop:		;attack time of possession stat update. Called once a second from updatepentime
		;   SNES: tmATOP +1 for the team with the puck past the blue line ($58)
	stz.b d1
	lda.w pucky
	sec
	sbc.w #$0058
	beq .lo
	bmi .v1
	bvs .lo
	bra .one
.v1:
	bvs .one
.lo:
	inc.b d1
	inc.b d1
	lda.w pucky
	sec
	sbc.w #$FFA8
	bmi .v2
	bvs .one
	bra .rtl
.v2:
	bvs .rtl
.one:
	lda.w gmode		; gmdir: swap the teams
	bit.w #gmdir
	beq .zero
	lda.b d1
	eor.w #$0002
	sta.b d1
.zero:
	ldy.b d1
	lda.w tmATOP,y
	inc a
	sta.w tmATOP,y
.rtl:
	rtl
checkfornewpen:		;look for new penalty (entered thru addpenalty(2)). Stops play at once for penalties without minutes or when the guilty team does not have the puck, otherwise starts a
		;   delayed penalty call
		;   SNES: new penalties in PenBuf. Stops play at once for penalties without minutes or when the guilty team has the puck, otherwise a
		;   delayed penalty call
	lda.w sfhormode		; not in horizontal mode
	beq .go
	jmp.w .rtl
.go:
	lda.w #PenBuf
	sta.b a0
.next:
	lda.b (a0)
	inc.b a0
	inc.b a0
	tay
	bne .notcalled
	jmp.w .rtl
.notcalled:
	lda.w gmode		; already called: mark it
	bit.w #gmpen
	bne .iscalled
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList		; a1 = PenaltyList entry; minutes?
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	beq .callit
	lda.w puckc		; no carrier, or the guilty team has the puck... else delayed call
	bmi .dc
	sec
	sbc.w #$0006
	sta.b d0
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pl
	ora.w #$FF00
.pl:
	sec
	sbc.w #$0006
	eor.b d0
	bmi .dc
.callit:
	jsl.l Stop4Pen
.iscalled:		;mark it called (bit 7 of the player byte)
	dec.b a0
	lda.b (a0)
	tay
	ora.w #$0080
	sta.b (a0)
	inc.b a0
	tya
	bit.w #$0080
	bne .next
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList		; delay byte (+1) * 32
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.w #$0001
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	sec
	sbc.w Pencntdwn
	beq .nx
	bmi .v1
	bvc .longer
.nx:
	jmp.w .next
.v1:
	bvc .nx
.longer:		;Pencntdwn = delay*32 if longer
	lda.b d1
	sta.w Pencntdwn
	jmp.w .next
.rtl:
	rtl
.dc:		;delayed call: PenDelay ref once
	lda.w #gmpendel		; first delayed call: SetPA PenDelay
	tsb.w gmode
	beq .dc2
	jmp.w .next
.dc2:
	lda.w #PenDelay
	sta.b d0
	jsl.l SetPA
	jmp.w .next
Stop4Pen:		;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from the penalty type, blow the whistle. Also entered from puckfaceoff+38
		;   SNES: a0 = PenBuf entry +2. Stop the clock, set the face off spot from the penalty type, blow the whistle
	lda.w #$FFFF		; clock already stopped: skip the face off spot
	tsb.w gmclock
	beq .spot
	jmp.w .skipfo
.spot:		;goal: center; OOP: last touch; icing: the end of the icing team (+-600); else the puck
	stz.b d0
	stz.b d1
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #PenGoal		; goal: center ice
	beq .noticing
	ldy.w ltx
	sty.b d0
	ldy.w lty
	sty.b d1
	cmp.w #PenOOP		; OOP: last touch
	beq .noticing
	ldy.w puckx
	sty.b d0
	ldy.w pucky
	sty.b d1
	cmp.w #PenIcing		; icing: +-600 by pfgoal of the icing player
	bne .noticing
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	asl a
	tay
	lda.w #$0258
	sta.b d1
	lda.w pfgoal,y
	beq .noticing
	lda.w #$FDA8
	sta.b d1
.noticing:
	lda.b d0		; x within +-70; y near the ends: end face off spots (+-206, x +-70)
	sta.b tmp0
	sec
	sbc.w #$0046
	bmi .v0
	bvc .x0
	bra .zero
.v0:
	bvc .zero
.x0:
	lda.w #$0046
	sta.b d0
.zero:
	lda.b d0
	sec
	sbc.w #$FFBA
	beq .x1
	bmi .v1
	bvs .x1
	bra .one
.v1:
	bvs .one
.x1:
	lda.w #$FFBA
	sta.b d0
.one:
	lda.b d1
	sec
	sbc.w #$00A6
	bmi .v2
	bvc .yhi
	bra .two
.v2:
	bvc .two
.yhi:
	lda.w #$00CE
	sta.b d1
	lda.w #$0046
	sta.b d0
	lda.b tmp0
	bpl .two
	lda.w #$FFBA
	sta.b d0
.two:
	lda.b d1
	sec
	sbc.w #$FF5A
	beq .ylo
	bmi .v3
	bvs .ylo
	bra .three
.v3:
	bvs .three
.ylo:
	lda.w #$FF32
	sta.b d1
	lda.w #$0046
	sta.b d0
	lda.b tmp0
	bpl .three
	lda.w #$FFBA
	sta.b d0
.three:
	lda.b d0
	sta.w fox
	lda.b d1
	sta.w foy
	jsl.l limitfo
.skipfo:
	lda.b vcount		; sound cut off within 60 frames: reset the queue
	sec
	sbc.w sfxmutetime
	cmp.w #$003C
	bcc .snd
	jsl.l sndqreset
.snd:
	lda.w #SFXwhistle		; whistle, Pencntdwn = 0, gmpen, SetPA PenWhistle
	pha
	jsl.l sfx
	stz.w Pencntdwn
	lda.w #gmpen
	tsb.w gmode
	lda.w #PenWhistle
	sta.b d0
	jmp.w SetPA
limitfo:		;limit face off to 5-20 feet from walls of rink. Checks every player in PenBuf
		;   SNES: keep the face off spot 65 from the blue line for every player in PenBuf
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
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
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.loop:
	jsl.l .lf
	inc.b a0
	inc.b a0
	lda.b [a0]
	bne .loop
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
	ldx.w #$0006
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
.lf:		;a0 = PenBuf entry
	lda.b [a0]		; player SCnum*2; blue line +-$58 by pfgoal
	xba
	and.w #$007F
	asl a
	tay
	lda.w #$0058
	sta.b d1
	lda.w pfgoal,y
	bne .zero
	lda.w #$FFA8
	sta.b d1
	sec
	sbc.w foy
	bmi .v1
	bvc .ny
	bra .rtl
.v1:
	bvc .rtl
.ny:
	lda.w #$FFBF
	sta.w foy
	bra .sx
.zero:
	lda.b d1
	sec
	sbc.w foy
	beq .py
	bmi .v2
	bvs .py
	bra .rtl
.v2:
	bvs .rtl
.py:
	lda.w #$0041
	sta.w foy
.sx:
	lda.w #$0046
	sta.b d0
	lda.w fox
	bpl .one
	lda.w #$FFBA
	sta.b d0
.one:
	lda.b d0
	sta.w fox
.rtl:
	rtl
chkprogress:		;control progress of ref and game control thru penalty events. When the stop delay runs out and a penalty with minutes is in PenBuf, switch to the horizontal rink for the
		;   player to enter the penalty box
		;   SNES: when the stop delay runs out and a penalty with minutes is in PenBuf, switch to the horizontal rink for the player to enter the box
	lda.w gmode		; gmpen: ref in progress
	bit.w #gmpen
	bne .pen
	jmp.w .rtl
.pen:
	lda.w Pencntdwn		; Pencntdwn negative: InProgress
	bpl .cnt
	jmp.w InProgress
.cnt:
	sec
	sbc.b d7
	sta.w Pencntdwn
	bmi .out
	jmp.w .rtl
.out:
	lda.w #gmpendel		; stop delay over: clear gmpendel
	trb.w gmode
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.find:
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	beq .rtl
	dec.b a0
	dec.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.w #PenaltyList
	sta.b a1
	clc
	adc.b [a1],y
	sta.b a1
	lda.b [a1]		; penalty with minutes?
	and.w #$00FF
	beq .find
	lda.w #sf2drec		; sf2drec, SetHor, load the horizontal ref; the puck does nothing for 120 s
	tsb.w sflags
	jsl.l SetHor		; bank $8F
	jsl.l NewTicker		; bank $8F (horizontal ref)
	lda.w #$FF00
	tsb.w puckc
	ldx.w #puckobj
	stx.b a3
	lda.w #pnothing
	sta.b d0
	jsl.l assinsert
	lda.w #$1C20
	ldx.b a3
	sta.w temp1,x
	lda.w #$FF00		; RefStep negative, RefCnt 0; UpdatePA; RefCnt 50; PushRef 0
	tsb.w RefStep
	stz.w RefCnt
	jsl.l UpdatePA
	lda.w #$0032
	sta.w RefCnt
	stz.b d0
	jsl.l PushRef		; bank $8F
.rtl:
	rtl
InProgress:		;ref in progress-- update graphics and stats and penalty information. Takes the last PenBuf entry: the first pass logs a penalty with minutes and sends the player to the box
		;   later passes wait until he is off the ice and drop the entry. When PenBuf is empty, recount players and go to the face off. Entered from chkprogress
		;   SNES: Takes the last PenBuf entry: the first pass logs a penalty with minutes and sends the player to the box, later passes
		;   clear it; at the end coinsearch and the face off
	lda.w RefCnt		; animation in progress: exit
	bmi .step
	jmp.w .rtl
.step:
	lda.w RefStep
	bmi .go
	jmp.w .rtl
.go:
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
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
.top:
	lda.w #$0000
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne .end
	jmp.w .exit
.end:		;find the end of the list
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne .end
	dec.b a0
	dec.b a0
	dec.b a0
	dec.b a0
	lda.b [a0]		; clear bit 15 of the entry (first pass)
	pha
	and.w #$7FFF
	sta.b [a0]
	pla
	bmi .Sa
	lda.b [a0]		; later pass: clear it when the player left the ice
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tay
	lda.w position,y
	bmi .clr
	jmp.w .ex
.clr:
	lda.w #$0000
	sta.b [a0]
	jmp.w .ex
.Sa:
	lda.b [a0]		; d2 = penalty minutes; none: no player involved
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b d2
	bne .min
	jmp.w .sa2
.min:
	stx.b xsave
	ldx.w #$0000
.pushd2:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushd2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha2:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha2
	ldx.b xsave
	jsl.l GetPeriodTimeRemaining		; GetPeriodTimeRemaining
	lda.b [a0]
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tax
	stx.b a3
	stz.b d0
	stz.b a2		; a2 = penalized team, a1 = other; d0 = $8000 for the visitors
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .sa1
	lda.w #$8000
	sta.b d0
	stz.b a1
	lda.w #$0002
	sta.b a2
.sa1:
	ldy.b a2		; tmPenalties +1, tmPenmin += minutes
	lda.w tmPenalties,y
	inc a
	sta.w tmPenalties,y
	lda.w tmPenmin,y
	clc
	adc.b d2
	sta.w tmPenmin,y
	lda.w pnum,x		; TempPlOffset = pnum | visitors
	and.w #$00FF
	ora.b d0
	sta.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .pn
	ora.w #$FF00
.pn:
	asl a
	sta.b d0
	lda.w #$003C		; d2 = minutes*60 | $2000
	sta.b mula
	lda.b d2
	and.w #$00FF
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, A = mula*mulb
	ora.w #$2000
	sta.b d2
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y		; keep TMPDINJ of an old penalty time
	bmi .st
	and.w #TMPDINJ
	tsb.b d2
.st:
	lda.b d2
	sta.w tmpdst,y
	lda.w #TMPDINJ
	trb.b d2
	lda.w #$0034
	sta.b d1
.ctop:		;same time on the other team: coincidental
	dec.b d1
	dec.b d1
	bmi .nocoin
	lda.b a1
	beq .ct
	lda.w #$0034
.ct:
	clc
	adc.b d1
	tay
	lda.w tmpdst,y
	and.w #~TMPDINJ&$FFFF
	sta.b d3
	cmp.b d2
	bne .ctop
	lda.w tmpdst,y		; coincidental: $4000 on both
	ora.w #$4000
	sta.w tmpdst,y
	lda.b a2
	beq .cg
	lda.w #$0034
.cg:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	ora.w #$4000
	sta.w tmpdst,y
.nocoin:		;add the player to the penalty box list
	lda.b a0+2
	pha
	lda.b a0
	pha
	lda.b a2
	beq .bl
	lda.w #$001A
.bl:
	sta.b a0
	lda.w #$0018
	sta.b d1
.pl:
	ldy.b a0
	inc.b a0
	lda.w tmboxlist,y
	bit.w #$0080
	bne .put
	dec.b d1
	bpl .pl
.put:
	lda.b d0
	ora.w #$FF00
	sta.w tmboxlist,y
	pla
	sta.b a0
	pla
	sta.b a0+2
	lda.w #apenalty		; apenalty
	sta.b d0
	jsl.l assreplace
	stx.b xsave
	ldx.w #$000E
.popa2:
	pla
	sta.b a1,x
	dex
	dex
	bpl .popa2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.popd2:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd2
	ldx.b xsave
	ldx.b a3		; SetPA, USBoard
	jsl.l SetPA
	jsl.l USBoard		; bank $8F
	bra .ex
.sa2:
	lda.w #$0000		; no minutes: clear it, SetPA
	sta.b [a0]
	lda.w sfhormode
	beq .sa3
	jmp.w .top
.sa3:
	jsl.l SetPA
	bra .ex
.exit:
	stz.b a2		; coinsearch for both teams, clear gmpen, the puck: pfaceoff
	jsl.l coinsearch
	lda.w #$0002
	sta.b a2
	jsl.l coinsearch
	lda.w #gmpen
	trb.w gmode
	ldx.w #puckobj
	stx.b a3
	lda.w #pfaceoff
	sta.b d0
	jsl.l assreplace
.ex:
	stx.b xsave
	ldx.w #$000E
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
	ldx.b a3
.rtl:
	rtl
coinsearch:		;penalty-box part of InProgress. a2 = team. Clears tmpdst bit 5, counts players kept off the ice by penalties (coincidental
		;   and bit 4 times do not count, at most 2) and sets tmap. Called twice from InProgress
		;   SNES: Clears tmpdst bit $2000, counts the players kept off the ice by penalties (not coincidental, not injured, never below 4)
		;   into tmap
	lda.w #$0006		; d1 = 6 players, d0 = last roster word
	sta.b d1
	lda.w #$0032
	sta.b d0
.top:
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nap
	beq .nap
	and.w #$DFFF		; clear bit $2000; coincidental or injured: does not count
	sta.w tmpdst,y
	bit.w #TMPDINJ|$4000
	bne .nap
	lda.b d1
	cmp.w #$0004
	beq .nap
	dec.b d1
.nap:
	dec.b d0
	dec.b d0
	bpl .top
	ldy.b a2
	lda.b d1
	sta.w tmap,y
	rtl
UpdatePA:		;animate ref in ref window. 93: also runs ShowThreeStars for game over and reprints the horizontal penalty message line when penmsgtimer runs out
		;   SNES: animate the ref (SetPA2 when RefCnt runs out); reprint the horizontal penalty message line when penmsgtimer runs out
	lda.w RefCnt		; RefCnt negative: idle
	bmi .rtl
	sec
	sbc.b d7
	sta.w RefCnt
	bpl .zero
	jsl.l SetPA2		; SetPA2
.zero:
	lda.w penmsgtimer
	sec
	sbc.b d7
	sta.w penmsgtimer
	bpl .rtl
	lda.w #$7FFF
	sta.w penmsgtimer
	jsl.l ClearPenaltyMessage		; ClearPenaltyMessage, then the player name centered at row $B
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	jsl.l GetPlayerName		; bank $8D (a1 = name)
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jmp.w print
.rtl:
	rtl
SetPA:		;start ref animation. d0 = animation (penalty number). 93: goal also calls ShowGoalBox, and penmsgtimer is set to 60 in horizontal mode. Falls into SetPA2

		;   SNES: start the ref animation for penalty d0: prefmes, ShowGoalBox for a goal, penmsgtimer (60 in horizontal mode), then SetPA2
	lda.b d0		; RefPen = d0, RefStep = 0, prefmes
	sta.w RefPen
	stz.w RefStep
	jsl.l prefmes		; bank $8F
	lda.b d0
	cmp.w #PenGoal		; goal: the goal box
	bne .zero
	jsl.l ShowGoalBox		; the goal box
.zero:
	lda.w #$7FFF
	sta.w penmsgtimer
	lda.w sfhormode
	beq .pa2
	lda.w #$003C
	sta.w penmsgtimer
.pa2:
	jml.l SetPA2

org $80FED1
reenergizeteam:		;set all players to max energy on team a2. 93 also moves players marked -3 in tmpdst to the bench (-2). Called from SetupTeamForIntermission and StartHL2 .setteam

		;   SNES: max energy for every player of team a2; TMPDOUT players go to the bench
	lda.w #$0032
	sta.b d0
.top:
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w #$1000		; max energy
	sta.w tmpde,y
	lda.w tmpdst,y		; out: back to the bench
	cmp.w #TMPDOUT
	bne .nb
	lda.w #TMPDBENCH
	sta.w tmpdst,y
.nb:
	dec.b d0
	dec.b d0
	bpl .top
	rtl
unusedFF:		;unused, $FF fill up to the internal header
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
	db $FF,$FF,$FF,$FF
	db "NHLPA Hockey '93     "		; title (21 bytes)
	db $30		; map mode: LoROM, FastROM
	db $00		; cartridge type: ROM only
	db $09		; ROM size: 512 KB
	db $00		; SRAM size: none
	db $01		; country: USA
	db $69		; licensee: Electronic Arts
	db $00		; version
	dw $B75A		; checksum complement
	dw $48A5		; checksum
	db $FF,$FF,$FF,$FF		; native mode vectors:
	dw VBjsr&$FFFF		; COP
	dw BRKHalt&$FFFF		; BRK
	dw VBjsr&$FFFF		; ABORT
	dw VBjsr&$FFFF		; NMI
	dw Start&$FFFF		; (unused)
	dw HBjsr&$FFFF		; IRQ
	db $FF,$FF,$FF,$FF		; emulation mode vectors:
	dw VBjsr&$FFFF		; COP
	dw VBjsr&$FFFF		; (unused)
	dw VBjsr&$FFFF		; ABORT
	dw VBjsr&$FFFF		; NMI
	dw Start&$FFFF		; RESET
	dw HBjsr&$FFFF		; IRQ/BRK
