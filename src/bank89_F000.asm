; $89F00A-$89FFFF  ROM $4F00A-$4FFFF: the rest of RefTilesHor, RefsMapHor (ref window frames for the horizontal rink), the music cue starters
; StartSong1-5/8/9, CopyWords, EraseScoutName, GetPlayerRecord, MesAreaDone, StartGame and restoreteams (hockey93_01), EvadePC (logic93_3),
; asswingd (logic93_2, asstab 3), $FF fill.
org $89F00A
	incbin "../data/RefHor.chr.pak":$4C5..$8B6		; $89F00A-$89F3FA
RefTilesHorEnd:
	assert RefTilesHorEnd-RefTilesHor == $8B6
RefsMapHor:		;ref window frames for the horizontal rink, 17 frames of 8 x 7 words (data/RefsHor.snesmap); PushRef ($8F83A7) uses it when sfhormode
	incbin "../data/RefsHor.snesmap"		; $89F3FB-$89FB6A
RefsMapHorEnd:
	assert RefsMapHorEnd-RefsMapHor == 17*$70
StartSong8:		;SNES: start song 8 (no caller found) unless it plays: the boot sound set (SPCBootUpload), then driver command 9
	lda.w cursong
	cmp.w #8
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$09
	sta.w APUIO0
	rep #$30
	lda.w #8
	sta.w cursong
.rtl:
	rtl
StartSong9:		;SNES: start song 9 (the playoff screen music, PlayoffScreen) unless it plays: the boot sound set (SPCBootUpload), then driver command 1
	lda.w cursong
	cmp.w #9
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$01
	sta.w APUIO0
	rep #$30
	lda.w #9
	sta.w cursong
.rtl:
	rtl
StartSong1:		;SNES: start music cue 1 (home goal) unless it plays: the in-game sound set, then $8FFE7B with 4; cuetimer = its length
	lda.w cursong
	cmp.w #$0001
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0004
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0001
	sta.w cursong
	lda.w #$0240
	sta.w cuetimer
.rtl:
	rtl
StartSong2:		;SNES: start music cue 2 (period start) unless it plays: the in-game sound set, then $8FFE7B with 5; cuetimer = its length
	lda.w cursong
	cmp.w #$0002
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0005
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0002
	sta.w cursong
	lda.w #$01CE
	sta.w cuetimer
.rtl:
	rtl
StartSong3:		;SNES: start music cue 3 (third period, Gameloop by p3cue) unless it plays: the in-game sound set, then $8FFE7B with 6; cuetimer = its length
	lda.w cursong
	cmp.w #$0003
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0006
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0003
	sta.w cursong
	lda.w #$0474
	sta.w cuetimer
.rtl:
	rtl
StartSong4:		;SNES: start music cue 4 (no caller found) unless it plays: the in-game sound set, then $8FFE7B with 7; cuetimer = its length
	lda.w cursong
	cmp.w #$0004
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0007
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0004
	sta.w cursong
	lda.w #$022E
	sta.w cuetimer
.rtl:
	rtl
StartSong5:		;SNES: start music cue 5 (mid-period) unless it plays: the in-game sound set, then $8FFE7B with 8; cuetimer = its length
	lda.w cursong
	cmp.w #$0005
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0008
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0005
	sta.w cursong
	lda.w #$041A
	sta.w cuetimer
.rtl:
	rtl
CopyWords:		;SNES: copy d0 bytes (words) from [d2] to [d1]
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
.copy:
	lda.b [d2]
	sta.b [d1]
	inc.b d1
	inc.b d1
	inc.b d2
	inc.b d2
	dec.b d0
	dec.b d0
	bne .copy
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
EraseScoutName:		;SNES: blank the 11 x 2 showcased player name area (ScoutNamePos, eraser)
	jsl.l ScoutNamePos
	lda.w #$000B
	sta.b d0
	lda.w #$0002
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser		; bank $8D: 92G eraser
GetPlayerRecord:		;SNES: a0 = roster record of player d0 of team a2 (tmdata: the player data, then name length + 8 bytes per player; 93G does it inline)
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	ldy.w #Playerdata
	clc
	adc.b [a0]
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
MesAreaDone:		;SNES: end a string built in mesarea: length = a1 - mesarea, a1 = mesarea
	lda.b a1
	sec
	sbc.w #$0191
	sta.w mesarea
	lda.w #mesarea
	sta.b a1
	rtl
StartGame:		;93G StartGame (hockey93_01): reset the game state (gmode, offsides option, team stats, scores, gsp), restoreteams, then on to the period start
	stz.w gmode
	lda.w OptPen		; OptPen 1: offsides on
	cmp.w #1
	bne .go
	lda.w #gmoffs
	tsb.w gmode
.go:
	jsl.l ClearTeamStats
	stz.w ScoreSumbytes
	stz.w gsp
	stz.w ChkCnt
	jsl.l restoreteams
	jsl.l InitScores		; bank $8F: 93G InitScores
	jsl.l UpdateScores
	jml.l StartPer		; bank $8D: on to the period start
restoreteams:		;93G restoreteams (hockey93_01): both rosters to the bench: tmap 6, every tmpdst -2
	stz.b a2
	jsl.l .r
	lda.w #$0002
	sta.b a2
.r:		;93G .r: one team (a2)
	ldy.b a2
	lda.w #6
	sta.w tmap,y
	lda.w #$32
	sta.b d0
.pl:
	lda.b a2
	beq .home
	lda.w #$34
.home:
	clc
	adc.b d0
	tay
	lda.w #TMPDBENCH		; TMPDBENCH
	sta.w tmpdst,y
	dec.b d0
	dec.b d0
	bpl .pl
	rtl
EvadePC:		;93G EvadePC (logic93_3, the 92G form): within 40 of the puck carrier (after one frame of both velocities) d0 = direction away from him
	lda.w puckc
	bmi .rtl
	lda.w Xvel+1,x		; x after one frame, relative to the puck carrier
	sec
	sbc.w puckvx+1
	and.w #$00FF
	bit.w #$0080
	beq .xs
	ora.w #$FF00
.xs:
	clc
	adc.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .xa
	eor.w #$FFFF
	inc a
.xa:
	cmp.w #41
	bcs .rtl
	lda.w Yvel+1,x
	sec
	sbc.w puckvy+1
	and.w #$00FF
	bit.w #$0080
	beq .ys
	ora.w #$FF00
.ys:
	clc
	adc.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .ya
	eor.w #$FFFF
	inc a
.ya:
	cmp.w #41
	bcs .rtl
	lda.w Xpos,x
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w pucky
	sta.b d1
	jml.l vtoa
.rtl:
	rtl
asswingd:		;asstab 3. 93G asswingd (logic93_2): wing on defence: cover his side between the puck and the goal; awingo when the team gets the puck
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing		; bank $8F: assnothing
.gm:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .chk
	jmp.w .rtl
.chk:
	bit.w #$0002
	beq .nna
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .nodec
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w puckc		; our team has the puck: awingo
	bmi .nodec
	sec
	sbc.w #6
	sta.b d1
	lda.w #4
	sta.b d0
	txa
	lsr a
	sec
	sbc.w #6
	eor.b d1
	sta.b d1
	bmi .nodec
	jml.l assreplace
.nodec:
	lda.w #100		; x 100 (left wing -100)
	sta.b d0
	lda.w position,x
	cmp.w #5
	bne .zero
	lda.w #-100
	sta.b d0
.zero:		;93G .0
	lda.w #158
	sta.b d1
	lda.w pfgoal,x		; pfgoal: defending the top goal
	beq .up
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w #-158
	sta.b d1
	lda.w #-78
	sta.b d2
	ldy.b a2
	lda.w tmflags,y		; offsides: stay at the blue line
	bit.w #tmfoffside
	bne .set
	lda.b d2
	sec
	sbc.w pucky
	beq .hi0
	bmi .lt
	bvs .hi0
	bra .lo
.lt:
	bvs .lo
.hi0:
	lda.w pucky
	sta.b d1
	bra .go2
.rtl:
	rtl
.lo:
	lda.w #-264
	sta.b d2
	sec
	sbc.w pucky
	bmi .lt2
	bvc .set1
	bra .go2
.lt2:
	bvc .go2
.set1:
	bra .set
.up:
	lda.w #78
	sta.b d2
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .set
	lda.b d2
	sec
	sbc.w pucky
	bmi .lt3
	bvc .up0
	bra .hi
.lt3:
	bvc .hi
.up0:
	lda.w pucky
	sta.b d1
	bra .go2
.hi:
	lda.w #264
	sta.b d2
	sec
	sbc.w pucky
	beq .set
	bmi .lt4
	bvs .set
	bra .go2
.lt4:
	bvs .go2
.set:
	lda.b d2
	sta.b d1
.go2:		;93G .go
	lda.w #rtss		; a0 = rtss: no avoidance
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w puckx
	eor.b d0
	sta.b d2
	bmi .skate
	lda.w puckx
	sta.b d0
.skate:
	jml.l skateto
unusedFF89:		;unused, $FF fill to the end of the bank
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
	db $FF,$FF
