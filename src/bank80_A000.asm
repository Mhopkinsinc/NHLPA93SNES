; $80A121-$80B005  ROM $02121-$03005: puck deflect/body/goalie collisions (hockey93_05), controller player switching (logic93_1),
; makepde, pucknothing, the faceoff (puckfaceoff, puckfaceoff2, updatefaceoff, Endfaceoff: logic93_4) with the line change box
; (SetLCmode, SetLCmode2) and ClrHor, dirtab, random/randoma, changeplayer, vtoa (logic93_5 / middle93_1).
org $80A121
deflect:		;93G deflect (hockey93_05): random puck direction on a deflection. Entered from puckstick .stdef
	lda.w #$FFFF		; puck loose
	sta.w puckc
	lda.w #$1000		; random velocity +-$1000 in y and x, 0..$1000 up
	jsl.l randomd0s
	sta.w puckvy
	lda.w #$1000
	jsl.l randomd0s
	sta.w puckvx
	lda.w #$1000
	jsl.l randoma
	sta.w puckvz
	jmp.w puckflip		; puckflip
setc1player:		;93G setc1player (logic93_1): restore the old player and give controller 1 to player d0
	lda.b d0
	cmp.w c1playernum
	beq .rtl
	lda.w c1playernum
	sta.b d1
	jsl.l restorepl
	lda.b d0
	sta.w c1playernum
.rtl:
	rtl
setc2player:		;93G setc2player (logic93_1): same for controller 2
	lda.b d0
	cmp.w c2playernum
	beq .rtl
	lda.w c2playernum
	sta.b d1
	jsl.l restorepl
	lda.b d0
	sta.w c2playernum
.rtl:
	rtl
restorepl:		;93G restorepl (logic93_1 IDA retorepl): release old joystick player d1, give d0 the joystick. A player in line change mode keeps control (d0 = d1)
	stz.b a0
	lda.b d1
	bmi .spd
	cmp.w #$000C		; only players 0-11
	bcs .spd
	asl.b d1
	ldy.b d1
	lda.w pflags,y
	bit.w #pf2lcm		; pf2lcm: he keeps the joystick
	beq .rel
	lsr.b d1
	lda.b d1
	sta.b d0
	rtl
.rel:		;release the old player: clear pfjoycon, set pfna
	and.w #~pfjoycon&$FFFF		; clear pfjoycon, set pfna
	ora.w #pfna
	sta.w pflags,y
.spd:		;set pfjoycon on the new player
	lda.b d0
	bmi .rtl
	cmp.w #$000C
	bcs .rtl
	sta.b d1
	asl.b d1
	ldy.b d1
	lda.w pflags,y
	ora.w #pfjoycon
	sta.w pflags,y
.rtl:
	rtl
makepde:		;93G makepde (hockey93_05): d0 = rating A (on entry) scaled by the energy of player a0: A*energy/$1000
	pha
	stx.b xsave
	ldx.w #$0000
.pushd:		;movem d1/a2-a3
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
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	ldx.b a0		; a3 = a0 for getpde
	stx.b a3
	jsl.l getpde
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a2,x
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
	ldx.b a3
	pla
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	asl a		; *16, high word: *energy/$1000
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	lda.b mulres+2
	sta.b d0
	clc
	rtl
puckbody:		;93G puckbody (hockey93_05): puck (X) hits player a2. d0 = distance^2. A fast high puck knocks a2 down (FallDown), a slower one plays SPAcatch
	lda.w Zpos,x		; puck above 8: always a hit
	sec
	sbc.w #$0008
	beq .low
	bmi .v1
	bvs .low
	bra .hit
.v1:
	bvs .hit
.low:		;low puck: only a hit dead center counts
	lda.b d0
	and.w #$000F
	beq .hit
	jmp.w .rtl
.hit:
	jsl.l a2touchpuck
	lda.w seed		; puck body sound (one of 2)
	and.w #$0001
	clc
	adc.w #SFXpuckbody
	pha
	jsl.l sfx
	stz.w Zvel,x		; Zvel = 0, nopuck(a2) = 8
	ldy.b a2
	lda.w #$0008
	sta.w nopuck,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .vel		; centered: use the hot spot
	tya
	jsl.l GetHot
.vel:
	lda.w Xvel,x
	sta.b d2
	lda.w Yvel,x
	sta.b d3
	sep #$20		; puck velocity high bytes = offset (93G move.b)
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$30
	jsl.l puckflip		; puckflip
	lda.w Zpos,x
	sec
	sbc.w #$0008
	beq .rtl
	bmi .v2
	bvc .high
	bra .rtl
.v2:
	bvc .rtl
.high:		;old speed^2 > $3000^2 and puck above 12: FallDown
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	lda.b d3
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d2
	lda.b mulres+2
	adc.b d2+2
	sta.b d2+2
	cmp.w #$0900		; $3000^2
	bcc .slow
	lda.w Zpos,x
	sec
	sbc.w #$000C		; Zpos 12
	beq .rtl
	bmi .v3
	bvs .rtl
.fall:
	jmp.w FallDown		; FallDown
.v3:
	bvs .fall
.rtl:
	rtl
.slow:
	ldy.b a2
	lda.w pfalock,y		; pfalock: already in a locked animation
	bne .rtl
	inc a
	sta.w pfalock,y
	lda.w #SPAcatch
	sta.b d1
	ldx.b a2		; exg a2,a3 around SetSPA
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	rtl
puckgoalie:		;93G puckgoalie (hockey93_05): puck (X) hits goalie a2. d0/d1 = goalie - puck x/y. SNES: save odds from the four save ratings, no .list2 frame table
	lda.w gmode
	bit.w #gmhl		; gmhl
	beq .go
	jmp.w .rtl
.go:
	stz.b d2
	lda.w Zpos+puckobj
	sec
	sbc.w #$0008
	beq .low
	bmi .v1
	bvs .low
	bra .side
.v1:
	bvs .side
.low:		;puck region: +2 when low
	inc.b d2
	inc.b d2
.side:
	lda.b d0		; direction from the goalie to the puck, relative to facedir
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	and.w #$0007
	sta.b d0
	and.w #$0003
	sta.b d1
	bne .lr
	lda.w seed		; straight in front or behind: random side
	sta.b d0
.lr:
	lda.b d0
	and.w #$0004
	lsr a
	lsr a
	eor.w #$0001
	clc
	adc.b d2
	asl a
	sta.b d2
	lda.w GGSleft,y		; save rating for the region: GGSleft, passacc, spodds, endurance
	sta.b d1
	lda.b d2
	beq .odds
	lda.w passacc,y
	sta.b d1
	lda.b d2
	cmp.w #$0002
	beq .odds
	lda.w spodds,y
	sta.b d1
	lda.b d2
	cmp.w #$0004
	beq .odds
	lda.w endurance,y
	sta.b d1
.odds:		;d1 = save rating + 15
	lda.b d1
	clc
	adc.w #$000F
	sta.b d1
	lda.w attribute,y
	bit.w #$0800		; x flip
	beq .noflip
	lda.b d2
	eor.w #$0002
	sta.b d2
.noflip:
	lda.w puckvy
	bit.w #$8000
	beq .hard
	eor.w #$FFFF
	inc a
.hard:		;hard shot from the blue line area may slip through
	cmp.w #$3000		; |puckvy| >= $3000
	bcc .frame
	lda.w carriedy		; shot taken 80..169 from the goal line: 1 in (182-y) slips through
	bit.w #$8000
	beq .dist
	eor.w #$FFFF
	inc a
.dist:
	cmp.w #$0050
	bcc .frame
	cmp.w #$00AA
	bcs .frame
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00B6
	jsl.l randoma
	cmp.w #$0003
	bne .frame
	jmp.w .rtl
.frame:		;goalie in the down frames and the puck on the ice: no save
	lda.w frame,y
	sec
	sbc.w #SPFgdive		; goalie dive frames SPFgdive..+15
	cmp.w #$0010
	bcs .save
	lda.w Zpos+puckobj
	sec
	sbc.w #$0002
	bmi .v2
	bvs .save
.nosave:
	jmp.w .rtl
.v2:
	bvs .nosave
.save:
	jsl.l ChkShotStat		; ChkShotStat
	jsl.l a2touchpuck
	lda.w seed+1		; puck body sound (one of 2)
	and.w #$0001
	clc
	adc.w #SFXpuckbody
	pha
	jsl.l sfx
	lda.w puckvy
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	cmp.w #$3000
	bcc .nosong
	lda.w #SFXsavehome		; crowd: home save
	pha
	ldy.b a2
	lda.w pfteam,y
	beq .song
	lda.w #SFXsaveaway
	sta.b $01,s
.song:
	jsl.l sfx
.nosong:
	lda.w puckc
	sta.b d2
	bpl .carried
	jmp.w .nopc
.carried:		;carrier loses the puck
	lda.w #$FF00		; puckc high byte = $FF: loose
	tsb.w puckc
	asl.b d2
	lda.b d2
	sta.b a0
	tay
	lda.w #$0014		; old carrier nopuck = 20
	sta.w nopuck,y
	tya
	lsr a
	sta.w lastplayer
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
.bounce:
	stz.w Zvel,x		; Zvel = 0, nopuck(a2) = 10, temp4(a2) = 4
	ldy.b a2
	lda.w #$000A
	sta.w nopuck,y
	lda.w #$0004
	sta.w temp4,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .sx
	lda.b a2
	jsl.l GetHot
.sx:
	lda.b d1
	and.w #$00FF
	bit.w #$0080
	beq .sy
	ora.w #$FF00
.sy:
	sta.b d1
	lda.b d1
	beq .away
	inc.b d1
.away:
	ldy.b a2
	lda.w Yvel,y
	eor.b d1
	bmi .setv
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.setv:
	sep #$20
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$20
	jmp.w puckflip
.rtl:
	rtl
.nopc:		;loose puck: the goalie holds it if it is slow enough
	ldy.b a2
	lda.w SPA,y
	cmp.w #SPAgdive		; SPAgdive: always bounce
	beq .bounce
	lda.w #$0002		; catch speed limit = random((2+shotspd)*512) + $C00
	clc
	adc.w shotspd,y
	xba
	and.w #$FF00
	asl a
	jsl.l randoma
	adc.w #$0C00
	sta.b d0
	sec
	sbc.w puckvx
	bmi .v3
	bvc .c2
.b1:
	jmp.w .bounce
.v3:
	bvc .b1
.c2:
	lda.b d0
	sec
	sbc.w puckvy
	bmi .v4
	bvc .c3
.b2:
	jmp.w .bounce
.v4:
	bvc .b2
.c3:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	sec
	sbc.w puckvx
	beq .c4
	bmi .v5
	bvs .c4
.b3:
	jmp.w .bounce
.v5:
	bvs .b3
.c4:
	lda.b d0
	sec
	sbc.w puckvy
	beq .c5
	bmi .v6
	bvs .c5
.b4:
	jmp.w .bounce
.v6:
	bvs .b4
.c5:
	ldy.b a2
	lda.w pflags,y
	bit.w #pf2unav		; pf2unav
	beq .hold
	jmp.w .bounce
.hold:
	stz.w Zvel,x
	jmp.w puckglue		; puckglue: goalie holds the puck
pucknothing:		;asstab $1A. 93G pucknothing / puckunflip (logic93_4 / logic93_5): puck just slides; stop spinning (93G pucknothing is bra puckunflip)
	lda.w SPAnum+puckobj
	cmp.w #$0008		; SPAnum 2*4..6*4: flip the face
	bcc .k
	cmp.w #$0018
	bcs .k
	lda.w facedir+puckobj
	eor.w #$0002
	sta.w facedir+puckobj
.k:
	lda.w #$0004		; facedir |= 4
	tsb.w facedir+puckobj
	stz.w SPAnum+puckobj		; SPAnum = 0, SPAcnt = -1 (restart)
	lda.w #$FFFF
	sta.w SPAcnt+puckobj
	rtl
puckfaceoff:		;asstab $1B. 93G puckfaceoff (logic93_4): this is where the action starts: period end checks, goalies, line change boxes, then pfaceoff2
	lda.w pflags,x
	bit.w #pfna
	bne .first
	jmp.w .nna
.first:
	and.w #~pfna&$FFFF
	sta.w pflags,x
	lda.w gameclock		; clock out: PeriodOver
	bne .g6
	jml.l PeriodOver		; bank $8D: 93G PeriodOver
.g6:
	lda.w gmode
	bit.w #gmendper
	beq .ot
	jml.l PeriodOver		; bank $8D: 93G PeriodOver
.ot:
	lda.w gsp		; overtime and not tied: clockcont_0
	cmp.w #$0003
	bne .npo
	lda.w tmscore
	cmp.w tmscore+2
	beq .npo
	jml.l clockcont_0		; bank $8F: 93G clockcont_0
.npo:
	lda.w gmode
	bit.w #gmpendel		; gmpendel: Stop4Pen
	beq .rg
	jmp.w Stop4Pen
.rg:
	jsl.l ReturnGoalies		; ReturnGoalies
	lda.w #$FFFF		; temp1/temp2 = -1: no lc box timers
	sta.w temp1,x
	sta.w temp2,x
	lda.w OptLine		; line changes off
	beq .lines
	jmp.w .nna
.lines:		;line changes on: no team in lc mode, clear pf2lcm on all 12 players
	lda.w #tmflc
	trb.w tmflags
	trb.w tmflags+2
	ldy.w #$0016
.lcm:
	lda.w pflags,y
	and.w #~pf2lcm&$FFFF
	sta.w pflags,y
	dey
	dey
	bpl .lcm
	lda.w cont1team		; a controlled team in horizontal mode: back to vertical
	ora.w cont2team
	beq .nohor
	lda.w sfhormode
	beq .nohor
	lda.w #sfslock
	tsb.w sflags
	jsl.l ClrHor
.nohor:
	lda.w c1playernum		; controller players get the lc box
	sta.b d0
	bmi .nlp
	jsl.l .slc
.nlp:
	lda.w c2playernum
	sta.b d0
	bmi .nlp2
	jsl.l .slc
.nlp2:
	stz.b a1		; a1 = home, a2 = away
	lda.w #$0002
	sta.b a2
	sta.b d0
	jsl.l .sclc
	bra .nna
.sclc:		;d0 = team (1/2), a2/a1 = team/other: computer line change unless that team is on a controller
	lda.w OptLine
	bne .rtl
	lda.b d0
	cmp.w cont1team
	beq .rtl
	cmp.w cont2team
	beq .rtl
	jsl.l CompLine		; bank $8F: 93G CompLine
	jsl.l setpersonel
	jml.l printscores1		; bank $89: 93G printscores1
.slc:		;controlled player d0 gets the line change box
	ldy.b a3
	sty.b a2
	lda.b d0
	asl a		; exg a2,a3: X = the controlled player
	sta.b d0
	sta.b a3
	tax
	lda.w pflags,x
	and.w #~pf2lcm&$FFFF
	sta.w pflags,x
	phy
	lda.w #$FFFF		; lcplayer = -1
	sta.w lcplayer
	jsl.l SetLCmode
	ply
	sty.b a2
	ldx.b a3
	lda.w pflags,x
	bit.w #pf2lcm		; pf2lcm: the box opened
	beq .slcex
	lda.w pfteam,x
	beq .t1
	lda.w #$0168		; visitors: temp2 = 6*60, temp4 = SCnum
	sta.w temp2,y
	txa
	lsr a
	sta.w temp4,y
	bra .slcex
.t1:
	lda.w #$0258		; home: temp1 = 10*60, temp3 = SCnum
	sta.w temp1,y
	txa
	lsr a
	sta.w temp3,y
.slcex:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
.rtl:
	rtl
.nna:		;count down the two lc box timers (temp1/temp2); both done: pfaceoff2
	stz.b d0
	jsl.l .clc
	lda.w #$0020		; temp2/temp4
	sta.b d0
	jsl.l .clc
	ldx.b a3
	lda.w temp1,x
	bpl .rtl
	lda.w temp2,x
	bpl .rtl
	stz.b a2		; a2 = home, a1 = away
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l .sclc
	lda.w #pfaceoff2		; pfaceoff2
	sta.b d0
	ldx.b a3
	jmp.w assreplace
.clc:		;d0 = 0 (temp1/temp3) or $20 (temp2/temp4): update one lc box timer
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	bmi .rtl
	lda.w temp3,y		; temp3/temp4 = SCnum of the box owner
	asl a
	sta.b d1
	tay
	stz.b a0
	stz.b a2
	lda.w pfteam,y
	beq .clh
	lda.w #$0002
	sta.b a2
.clh:
	lda.w pflags,y
	bit.w #pf2lcm		; pf2lcm still on?
	bne .clnd
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	ora.w #$FF00		; timer negative: box closed
	sta.w temp1,y
	ldx.b a3
	jmp.w SetLCmode2
.clnd:
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	sec
	sbc.b d7		; count down
	sta.w temp1,y
	bmi .clcex
	jmp.w .rtl
.clcex:
	ldx.b a3
	phx
	ldx.b d1
	stx.b a3
	lda.w pflags,x
	bit.w #pf2lcm		; still in lc mode: lcfound with choice 0
	beq .pop
	stz.b d2
	jsl.l lcfound		; bank $8F: 93G lcfound
	jsl.l SetLCmode2
.pop:
	plx
	stx.b a3
	rtl
SetLCmode:		;93G SetLCmode (logic93_1): open the line change box for player X (abut of the puck carrier)
	lda.w OptLine
	bne .rtl
	jsl.l loadTeamStruct		; loadTeamStruct: a2 = team of X, bank $8F: 93G loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmflc		; tmflc: team already in lc mode
	bne .rtl
	ora.w #tmflc
	sta.w tmflags,y
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
	lda.w pflags,x
	ora.w #pf2lcm		; pf2lcm
	sta.w pflags,x
	lda.w lcplayer		; remember the player when lcplayer = $FFFE
	cmp.w #$FFFE
	bne .show
	txa
	lsr a
	sta.w lcplayer
.show:
	jmp.w SetLCmode2
.rtl:
	rtl
SetLCmode2:		;93G SetLCmode2 (logic93_1 IDA showfaceoff): a2 = team; draw the lc box, one row per eligible line (button letter + line name)
	jsl.l setlccords
	inc.b d0		; box size +1
	inc.b d1
	lda.w blankchar		; d2 = blank tile
	sta.b d2
	lda.b fobox		; faceoff box up: do not clear
	bne .cords
	jsl.l eraser		; bank $8D: 93G eraser (d0/d1 size, d2 tile)
.cords:
	jsl.l setlccords
	lda.w printy		; lower half of the screen?
	sec
	sbc.w #$000F
	bmi .v1
	bvc .lower
	bra .box
.v1:
	bvc .box
.lower:		;lower box: sf3llcs
	lda.w #sf3llcs
	tsb.w sflags3
	bra .frame
.box:
	jsl.l box		; bank $8F: 93G box
	jsl.l setlccords
.frame:
	jsl.l Framer		; bank $8F: 93G Framer (d0/d1 size)
	dec.w printy		; printy -= 2, printx += 1
	dec.w printy
	inc.w printx
	lda.w #$0002
	sta.b d4
	lda.w printx
	pha
.loop:		;rows 2..0: button letter, line name, energy bar
	lda.b $01,s
	sta.w printx
	lda.b d4
	sta.b d0
	jsl.l getlchoice		; bank $8A: 93G getlchoice
	lda.b d0
	bmi .next
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmflc		; tmflc: show every row
	bne .pr
	lda.b d4
	cmp.w tmlcchoice,y		; box being closed: only the chosen row
	bne .up
	lda.w tmline,y
	sta.b d0
.pr:
	lda.w #mesarea		; mesarea = 4, button letter
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #$0004
	sta.b [a1]
	phx
	ldx.b d4
	lda.l .btn,x
	plx
	and.w #$00FF
	ora.w #$2000		; text attribute $20
	ldy.w #$0002
	sta.b [a1],y
	jsl.l print
	lda.b d0
	pha
	lda.w #linelist		; linelist (bank $8F)
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F: 93G PrintStringFromList
	pla
	sta.b d0
	jsl.l linebar		; bank $8F: 93G linebar
.up:
	dec.w printy
.next:
	dec.b d4
	bpl .loop
	pla
	clc
	adc.w #$0005
	sta.w printx
	ldy.b a2
	lda.w #TeamList>>16		; team name: [tmdata] + its offsets (bank $83)
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #Teamname
	clc
	adc.b [a1],y
	sta.b a1
	adc.b [a1]
	sta.b a1
	jmp.w print
.btn:		;SNES button letter for lc rows 0-2 (93G A/B/C)
	db "YBA"
ClrHor:		;93G ClrHor (penalty93_1): revert to the vertical ice rink: clear sfhormode, Oldrow, SprSort, clear the text map, printscores1
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
	jsl.l printscores1		; bank $89: 93G printscores1
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
puckfaceoff2:		;asstab $1C. 93G puckfaceoff2 (logic93_4): face off control logic and general setup for action
	lda.w pflags,x
	bit.w #pfna
	bne .first
	jmp.w .nna
.first:		;first time: set up the faceoff
	and.w #~pfna&$FFFF
	sta.w pflags,x
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
	cpx.w #$001C
	bne .pusha
	ldx.b xsave
	lda.b crowdlevel		; limit crowd level
	cmp.w #$0258
	bcc .ntm
	lda.w #$0258
	sta.b crowdlevel
.ntm:
	lda.w #sfpz		; no pause, no lower lc box, no gloves, no icing, no refs, no goalie moves, puck invisible and loose
	trb.w sflags
	lda.w #sf3llcs
	trb.w sflags3
	stz.w glovecords
	stz.w iflags
	lda.w #$FFFF
	sta.w RefCnt
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w Zpos+puckobj
	sta.w puckc
	sta.w passReceiverPlayerNum
	lda.w #sf2refref		; clear sf2refref; faceoff on, replay record off
	trb.w sflags
	lda.w #sf2faceoff|sf2drec
	tsb.w sflags
	jsl.l ClrHor
	stz.w Vpos		; Vpos = Hpos = 0
	stz.w Hpos
	lda.w fox		; puck to the faceoff spot, stopped
	sta.w puckx
	lda.w foy
	sta.w pucky
	stz.w puckvx
	stz.w puckvy
	stz.w puckvz
	stz.w Xvel+$18		; goal nets (objects 12/13) at y +-268
	stz.w Yvel+$18
	stz.w Xpos+$18
	lda.w #$010C
	sta.w Ypos+$18
	stz.w Xvel+$1A
	stz.w Yvel+$1A
	stz.w Xpos+$1A
	lda.w #$FEF4
	sta.w Ypos+$1A
	lda.w #SPFpuck		; object 15 (puck shadow) = SPFpuck
	sta.w frame+$1E
	stz.w SPA+$1E
	stz.w attribute+$1E
	stz.w attribute+puckobj
	lda.w #sfslock		; clear sfslock: free up scrolling
	trb.w sflags
	lda.w #$0064
	sta.b d4
.cw:		;scroll to the faceoff spot
	jsl.l checkwindow
	dec.b d4
	bpl .cw
	lda.w #$003C		; yleader = 60
	sta.w yleader
	jsl.l ResetBench		; ResetBench
	stz.b a2
	jsl.l setpersonel
	jsl.l forcepldata
	inc.b a2
	inc.b a2
	jsl.l setpersonel
	jsl.l forcepldata
	jsl.l resetplstuff		; resetplstuff
	lda.b a3+2		; push a3
	pha
	lda.b a3
	pha
	stz.b a3
	lda.w #$000B
	sta.b d2
.loop:		;each player: assignment and faceoff position
	ldx.b a3
	lda.w #$FF10		; Xpos = -240, off the screen
	sta.w Xpos,x
	stz.w Ypos,x
	stz.w frame,x
	lda.w position,x
	sta.b d1
	bpl .pos
	jmp.w .next
.pos:
	beq .goalie1
	lda.w #afaceoff
	sta.b d0
	lda.b d1
	cmp.w #$0004
	bne .d1ne
	stz.b a2		; center: team touches = him only
	lda.w pfteam,x
	beq .tm
	inc.b a2
	inc.b a2
.tm:
	ldy.b a2
	lda.w pnum,x
	and.w #$00FF
	sta.w tmtouch1,y
	lda.w #$FFFF
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmflags,y
	and.w #~tmflast&$FFFF
	sta.w tmflags,y
	lda.w #afaceoffpl		; afaceoffpl
	sta.b d0
.d1ne:
	jsl.l assinsert
.goalie1:
	lda.w tmap		; d4 = (6-tmap)*8: .apl row
	sta.b d4
	ldx.b a3
	lda.w pfteam,x
	beq .t0
	lda.w tmap+2
	sta.b d4
.t0:
	lda.b d4
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0006
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #.apl>>16
	sta.b a1+2
	lda.w #.apl
	clc
	adc.b d4
	sta.b a1
	ldy.b d1
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	sta.b d4
	lda.w #.ptab
	sta.b a1
	lda.w #.ptab>>16
	sta.b a1+2
	ldy.b d4
	lda.b [a1],y
	sta.b d0
	iny
	iny
	lda.b [a1],y
	sta.b d1
	lda.w pfgoal,x
	bne .f0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.f0:
	lda.w position,x
	beq .goalie2
	lda.b d4		; defense (entry <= 2*4): shift by fox/foy
	sec
	sbc.w #$0008
	beq .def
	bmi .v1
	bvs .def
	bra .nodef
.v1:
	bvs .nodef
.def:
	lda.w fox
	eor.b d0
	bpl .notmid
	lda.w foy
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .mid
	ora.w #$E000
.mid:
	eor.w #$FFFF
	inc a
	clc
	adc.b d1
	sta.b d1
.notmid:
	lda.w fox
	lsr a
	lsr a
	bit.w #$2000
	beq .xadj
	ora.w #$C000
.xadj:
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
.nodef:
	lda.b d0
	clc
	adc.w fox
	sta.b d0
	lda.b d1
	clc
	adc.w foy
	sta.b d1
.goalie2:
	lda.b d0
	sta.w Xpos,x
	sec
	sbc.w puckx
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	sta.w Ypos,x
	sec
	sbc.w pucky
	eor.w #$FFFF
	inc a
	sta.b d1
	stz.w Xvel,x
	stz.w Yvel,x
	jsl.l vtoa		; face the puck
	lda.b d0
	sta.w facedir,x
	lda.w pflags,x
	and.w #~pf2unav&$FFFF		; clear pf2unav, pfalock, SPA
	sta.w pflags,x
	stz.w pfalock,x
	stz.w SPA,x
	lda.w #SPAglide
	sta.b d1
	jsl.l SetSPA
.next:
	inc.b a3
	inc.b a3
	dec.b d2
	bmi .done
	jmp.w .loop
.done:
	jsl.l SprSort		; SprSort
	pla
	sta.b a3
	pla
	sta.b a3+2
	ldx.b a3
	jsl.l ResetAndSelectPlayers		; bank $8F: 93G ResetAndSelectPlayers
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w #$0036		; 8+46
	sta.b d0
	lda.w fox
	bpl .fok
	lda.w #$00BE		; (18*8)+46
	sta.b d0
.fok:
	lda.b d0
	sta.w fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	sta.w printx
	lda.w #$005C		; (3*8)+68
	sta.w fodropy
	lda.w #$0003
	sta.w printy
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	jsl.l marktextlo		; mark the box rows dirty
	lda.w printy
	clc
	adc.w #$0009
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.w #$000B
	jsl.l marktexthi
	lda.w #FaceOffMap		; fobox nonzero
	sta.b fobox
	sta.b tmp0
	lda.w #FaceOffMap>>16
	sta.b tmp1
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	ldy.w #$0000
	lda.w #$000A
	sta.b tmp1+1
	clc
.row:		;copy the 12x10 FaceOffMap into the text map
	lda.w #$000C
	sta.b tmp2+1
.col:
	lda.b [tmp0],y
	clc
	adc.w faceoffvrcset
	adc.w charofs
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp2+1
	bne .col
	txa
	clc
	adc.w #$0028
	tax
	dec.b tmp1+1
	bne .row
	ldx.b a3
	lda.w OptLine		; line changes on: line names box
	bne .nol
	lda.w printy
	clc
	adc.w #$000A
	sta.w printy
	lda.w #$000C
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer		; bank $8F: 93G Framer (d0/d1 size)
	lda.w tmline
	sta.b d0
	lda.w tmline+2
	sta.b d1
	lda.w gmode		; gmdir
	bit.w #gmdir
	bne .nx
	lda.w tmline
	sta.b d1
	lda.w tmline+2
	sta.b d0
.nx:
	inc.w printx
	dec.w printy
	dec.w printy
	lda.w #linelist		; linelist (bank $8F)
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F: 93G PrintStringFromList
	inc.w printx
	inc.w printx
	inc.w printx
	inc.w printx
	lda.b d1
	sta.b d0
	lda.w #linelist
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F: 93G PrintStringFromList
.nol:		;time for the puck drop: 180-299 frames
	lda.w #$0078
	jsl.l randoma
	adc.w #$00B4
	sta.b d0
	ldx.b a3
	sta.w temp1,x
	lda.w #$0001		; fofdata2: home pull frame 1, away 4, ref 7
	sta.w fofdata2
	lda.w #$8000
	sta.w fofdata2+2
	sta.w fofdata+2
	lda.w #$0004
	sta.w fofdata2+4
	lda.w #$A800
	sta.w fofdata2+6
	lda.w #$0007
	sta.w fofdata
	lda.w gmode
	bit.w #gmdir		; gmdir: flip the attributes
	bne .nfl
	lda.w #$8800
	sta.w fofdata2+2
	lda.w #$A000
	sta.w fofdata2+6
.nfl:
	lda.w #$FFFF		; fodir1/fodir2 = none
	sta.w fodir1
	sta.w fodir2
	stx.b xsave
	ldx.w #$001A
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
	ldx.b a3
	rtl
.nna:		;count down to the drop; then Endfaceoff
	lda.b d7		; temp1 -= min(d7, temp1)
	sta.b tmp0
	sec
	sbc.w temp1,x
	bmi .v2
	bvc .one
	bra .sub
.v2:
	bvc .sub
.one:
	lda.w #$0001
	sta.b tmp0
.sub:
	lda.w temp1,x
	sec
	sbc.b tmp0
	sta.w temp1,x
	bpl updatefaceoff
	jmp.w Endfaceoff
.apl:		;93G .apl: .ptab entry for each position, by players on ice (6, 5, 4)
	db 0,1,2,3,4,5,6,0		; 6 on ice
	db 0,1,5,3,4,2,0,0		; 5 on ice
	db 0,3,5,1,4,0,0,0		; 4 on ice
.ptab:		;93G .ptab: faceoff x/y offsets
	dw 0,-250, -35,-50, 35,-50, -50,-10
	dw 0,-15, 50,-10, 0,-60
updatefaceoff:		;93G updatefaceoff (logic93_4): X = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	lda.w temp1,x
	beq .erase
	clc		; (temp1+6)/8 <= 2: drop frame 10-d0
	adc.w #$0006
	lsr a
	lsr a
	lsr a
	sta.b d0
	sec
	sbc.w #$0002
	beq .set
	bmi .v1
	bvs .set
	bra .rtl
.v1:
	bvs .rtl
.set:
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000A
	sta.b d0
	sta.w fofdata
.rtl:
	rtl
.erase:
	jsl.l printz		; erase the faceoff box
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .x
	ora.w #$E000
.x:
	sta.w printx
	lda.w fodropy
	sec
	sbc.w #$0044
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .y
	ora.w #$E000
.y:
	sta.w printy
	lda.w #$000C
	sta.b d0
	inc a
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser		; bank $8D: 93G eraser (d0/d1 size, d2 tile)
Endfaceoff:		;93G Endfaceoff (logic93_4): drop the puck: pick the faceoff winner and send the puck off
	lda.w seed+2		; puck on the ice sound
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	lda.w #sf2faceoff		; faceoff over, fobox off, replay record on, clock running
	trb.w sflags
	stz.b fobox
	lda.w #sf2drec
	trb.w sflags
	stz.w gmclock
	stz.w pf2fight,x
	lda.w #sf3fo		; sf3fo
	tsb.w sflags3
	lda.w fodir1		; d3 = fodir1, d4 = $800 (toward the top), a1 = home
	sta.b d3
	lda.w #$0800
	sta.b d4
	stz.b a1
	lda.w #$0010
	sta.b d2
	ldx.w fofdata2
	lda.l .ftab-1,x
	and.w #$00FF
	bit.w #$0080
	beq .f1
	ora.w #$FF00
.f1:
	eor.w #$FFFF
	inc a
	clc
	adc.b d2
	sta.b d2
	ldx.w fofdata2+4
	lda.l .ftab-1,x
	and.w #$00FF
	bit.w #$0080
	beq .f2
	ora.w #$FF00
.f2:
	clc
	adc.b d2
	sta.b d2
	lda.w #$0021		; random(33) vs the pull frames: who won
	jsl.l randoma
	cmp.b d2
	bcs .p1won
	lda.w #$0004		; visitors won
	sta.b a1
.p1won:
	ldx.b a1
	lda.w fofdata2+2,x
	bit.w #$0800		; winner faces down: fodir2, -$800
	beq .pos
	lda.w fodir2
	sta.b d3
	lda.w #$F800
	sta.b d4
.pos:
	lda.b d3
	bit.w #$0008
	bne .nojoy
	and.w #$0007
	sta.b d0
	lda.w seed		; joystick direction 3 in 4
	and.w #$0003
	bne .nj2
.nojoy:
	lda.w #$0005		; random direction -2..2
	jsl.l randoma
	dec a
	dec a
	and.w #$0007
	sta.b d0
	lda.b d4
	bmi .nj2
	lda.b d0
	eor.w #$0004
	sta.b d0
.nj2:
	asl.b d0
	asl.b d0
	ldx.b d0
	lda.l dirtab,x		; Xvel = dirtab x * 32
	asl a
	asl a
	asl a
	asl a
	asl a
	ldx.b a3
	sta.w Xvel,x
	ldx.b d0
	lda.l dirtab+2,x		; Yvel = dirtab y * 32 + d4
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.b d4
	ldx.b a3
	sta.w Yvel,x
	lda.w #$0800		; Zvel = random(0..$800)
	jsl.l randoma
	sta.w Zvel,x
	stz.w Zpos+puckobj
	stz.w pfnc,x
	lda.w #pnorm		; pnorm
	sta.b d0
	jmp.w assreplace
.ftab:		;93G .ftab: faceoff strength by pull frame
	db 0,8,16,0,8,16
dirtab:		;93G dirtab (logic93_5): x,y speed for each direction 0-7 (92 runspeed 200, diagonal 141)
	dw 0,200, 141,141, 200,0, 141,-141
	dw 0,-200, -141,-141, -200,0, -141,141
random:		;93G randomd0 seed step: seed = seed*$BB40E62D+1 (32-bit LCG); returns A = seed+1 (middle bytes), rndb1/rndb2 set
	lda.w seed		; mula = seed (32-bit)
	sta.b mula
	lda.w seed+2
	sta.b mula+2
	lda.w #$E62D		; mulb = $BB40E62D
	sta.b mulb
	lda.w #$BB40
	sta.b mulb+2
	jsl.l mulu32		; bank $88: mulu 32-bit
	adc.w #$0001
	sta.w seed
	lda.b mulres+2
	adc.w #$0000
	sta.w seed+2
	xba		; seed bytes 2/1 for the 8-bit users ($0493/$0491)
	and.w #$00FF
	sta.w rndb2
	lda.w seed+1
	sta.w rndb1
	clc
	rtl
randoma:		;93G randomd0 with A = range: returns A = random 0..range-1 (high word of random*range). C clear
	pha
	jsl.l random
	sta.b mula
	pla
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2
	clc
	rtl
changeplayer:		;93G changeplayer (logic93_1): switch controller d4 (0/2) to the teammate nearest the puck, or sweep check if that is the current player
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
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
	lda.w puckvy		; puck + velocity/256 (lead the puck)
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ly
	ora.w #$FF00
.ly:
	clc
	adc.w pucky
	pha
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .lx
	ora.w #$FF00
.lx:
	clc
	adc.w puckx
	pha
	lda.w #$0005
	sta.b d2
	lda.b d4
	tay
	eor.w #$0002		; d3 = the other controller
	sta.b d3
	lda.w #$FFFF		; d5 = best distance^2
	sta.b d5+2
	ldx.w #$0000
	lda.w cont1team,y		; controller on the home team: players 0-5, else 6-11
	cmp.w #$0001
	beq .t1
	ldx.w #$000C
.t1:
	ldy.b d3
.top:
	lda.w position,x
	bmi .next
	beq .next
	lda.w pflags,x		; pf2unav or pfalock: skip
	and.w #$1000
	ora.w pfalock,x
	bne .next
	lda.b $01,s
	sec
	sbc.w Xpos,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b $03,s
	sec
	sbc.w Ypos,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	lda.b d5
	cmp.b d0
	lda.b d5+2
	sbc.b d0+2
	bcc .next
	txa
	lsr a
	cmp.w c1playernum,y		; the other controller has him
	beq .next
	sta.b d6
	lda.b d0
	sta.b d5
	lda.b d0+2
	sta.b d5+2
.next:
	inx
	inx
	dec.b d2
	bpl .top
	ldx.b a3
	pla
	pla
	ldy.b d4
	lda.b d6
	cmp.w c1playernum,y		; same player: Sweepcheck
	bne .set
	jsl.l Sweepcheck
	bra .ex
.set:
	sta.b d0
	lda.b d4
	bne .c2
	jsl.l setc1player
	bra .ex
.c2:
	jsl.l setc2player
.ex:
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
	ldx.w #$001A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
vtoa:		;93G vtoa (logic93_5): d0/d1 are x/y distances, returned in d0 as a direction 0-7 (8 = no direction)
	lda.b d0
	ora.b d1
	beq .nodir		; no direction
	stz.b d0+2
	lda.b d0
	bpl .yabs
	eor.w #$FFFF
	inc a
	sta.b d0
	inc.b d0+2
.yabs:
	lda.b d1
	bpl .b2
	eor.w #$FFFF
	inc a
	sta.b d1
	inc.b d0+2
	inc.b d0+2
.b2:
	lda.b d1		; bit 2: |dx| <= 2|dy|
	asl a
	cmp.b d0
	bcc .b3
	lda.w #$0004
	tsb.b d0+2
.b3:
	lda.b d0		; bit 3: |dy| <= 2|dx|
	asl a
	cmp.b d1
	bcc .look
	lda.w #$0008
	tsb.b d0+2
.look:
	phx
	ldx.b d0+2
	lda.l .dt,x
	plx
	and.w #$00FF
	sta.b d0
	rtl
.nodir:
	lda.w #$0008
	sta.b d0
	rtl
.dt:		;93G vtoa .dt: direction for each sign/ratio combination
	db 1,7,3,5,0,0,4,4,2,6,2,6,1,7,3,5
