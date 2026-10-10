; $80910F-$80A120  ROM $0110F-$02120: 93G player logic continued: asspassrec, assfight (chkhit, CwdFight, FightFall), assfwatch,
; assfaceoff, assexit, assfaceoffp1 (logic93_2/4/5), randomd0, puck logic pucknorm with findpc, divs, a2touchpuck, a2offsides,
; GetHot, puckIChk, ChkOffsides (logic93_4/5), and the puck/player collision checkpuckcoll, puckstick, puckglue (hockey93_04/05).
org $80910F
asspassrec:		;asstab $13. assignment for catching pass. Assignment apassrec ($13) (93G logic93_4)
		;   SNES: assignment for catching a pass
	lda.w pfalock,x
	bne .rts		; locked
	lda.w gmclock		; clock stopped
	beq .joy
	jml.l assnothing		; bank $8F: 93G assnothing
.joy:
	lda.w pflags,x
	bit.w #pfjoycon		; joystick controlled
	beq .na
	jmp.w assexit
.na:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF		; clear pfna, set pfdoff
	ora.w #pfdoff
	sta.w pflags,x
	stz.w temp2,x		; temp2 = 8 (93G temp2+1 = 8, temp2 = 0)
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w puckc		; puck loose: wait temp1 frames
	bpl .ex
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .rts
.ex:
	lda.w pflags,x		; clear pfdoff
	and.w #~pfdoff&$FFFF
	sta.w pflags,x
	jmp.w assexit
.rts:
	rtl
assfight:		;asstab $14. 93G assfight (logic93_2): fighting logic for player X. The SNES drops the 93G banner call and keeps the fighters inside x +-$6F
	lda.w pfalock,x
	beq .go
	jmp.w .rts
.go:
	lda.w Pencntdwn		; fight over
	bpl .chkna
	jml.l assnothing		; bank $8F: 93G assnothing
.chkna:
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	jsl.l getpde
	lda.w fightagg,x		; getpde * fightagg / $1000
	sta.b d1
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	xba
	and.w #$00FF
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0006
	bcs .s
	lda.w #$0005
.s:		;temp3 = strength (min 5)
	sta.w temp3,x
	stz.w temp2,x
	stz.w temp2b,x
	lda.w #$FFFF		; temp4 = banner timer
	sta.w temp4,x
	lda.w facedir,x
	cmp.w #$0002		; one player shows the banner
	bne .nna
	lda.w #$005A
	sta.w temp4,x
.nna:		;keep the fighter within x -$6F..$6F
	lda.w Xpos,x
	sec
	sbc.w #$006F
	beq .left
	bmi .v1
	bvc .clampr
	bra .left
.v1:
	bvc .left
.clampr:
	stz.w Xvel,x
	lda.w #$006F
	sta.w Xpos,x
.left:
	lda.w Xpos,x
	sec
	sbc.w #$FF91
	bmi .v2
	bvs .clampl
	bra .nna2
.v2:
	bvs .nna2
.clampl:
	stz.w Xvel,x
	lda.w #$FF91
	sta.w Xpos,x
.nna2:		;temp4 = banner timer (no banner on the SNES)
	lda.w temp4,x
	sec
	sbc.b d7
	sta.w temp4,x
	lda.w temp3,x
	bpl .fight
	jmp.w .rts
.fight:
	lda.w impactp,x		; a0 = opponent; xc1 = half way between the fighters
	asl a
	sta.b a0
	tay
	lda.w Xpos,x
	adc.w Xpos,y
	pha
	asl a
	pla
	ror a
	sta.w xc1
	lda.w pflags,x
	bit.w #pfjoycon		; joystick: no computer punch
	bne .j
	lda.w pf2aip,x		; set pf2aip, test the old value
	pha
	lda.w #$0001
	sta.w pf2aip,x
	pla
	bne .j
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx1
	ora.w #$FF00
.vx1:
	clc
	adc.b d0
	sta.b d0
	lda.w Xvel,y
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx2
	ora.w #$FF00
.vx2:
	sta.b d1
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	bit.w #$8000
	beq .inrange
	eor.w #$FFFF
	inc a
.inrange:
	cmp.w #$0019		; computer punches only within 25 pixels
	bcs .j
	lda.w #$0008
	sta.b d0
	jsl.l randomd0
	lda.b d0
	cmp.w #$0003
	bcc .p
	and.w #$0001
	sta.b d0
.p:		;choose the punch type from .al
	asl.b d0
	lda.w #.al
	sta.b a1
	lda.w #.al>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b d1
	jsl.l SetSPA
.j:
	jsl.l chkhit
	lda.w SPA,x
	cmp.w #SPAfheld		; held: still pushed
	beq .njc
	cmp.w #SPAfight		; ready: no push
	beq .jc
	lda.w pflags,x
	bit.w #pfjoycon
	bne .jc
.njc:		;push toward the fight spot (xc1+-10)
	lda.w xc1
	clc
	adc.w #$000A
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .push
	lda.b d0
	sec
	sbc.w #$0014
	sta.b d0
.push:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b mula
	lda.w #$0023		; 35 toward the spot, 5 away from it (93G asl #5)
	sta.b mulb
	lda.w facedir,x
	sec
	sbc.w #$0004
	eor.b mula
	bmi .mul
	lda.w #$0005
	sta.b mulb
.mul:
	jsl.l muls16
	sta.b d0
	clc
	adc.w Xvel,x
	sta.w Xvel,x
.jc:		;Yvel = (yc1-Ypos)*256, +-$1000
	lda.w yc1
	sec
	sbc.w Ypos,x
	xba
	and.w #$FF00
	sta.b d1
	sec
	sbc.w #$1000
	bmi .v3
	bvc .y1
	bra .y2
.v3:
	bvc .y2
.y1:
	lda.w #$1000
	sta.b d1
.y2:
	lda.b d1
	sec
	sbc.w #$F000
	beq .y3
	bmi .v4
	bvs .y3
	bra .sety
.v4:
	bvs .sety
.y3:
	lda.w #$F000
	sta.b d1
.sety:
	lda.b d1
	sta.w Yvel,x
.rts:
	rtl
.al:		;93G .al: punch animations SPAfhigh, SPAflow, SPAfgrab
	dw SPAfhigh,SPAflow,SPAfgrab
chkhit:		;part of fight to see if player is hit (93G logic93_2)
		;   SNES: part of the fight, is player X hit by opponent a0?
	stx.b xsave
	ldx.w #$0000
.pushd:		;movem d0/a0-a3 to the stack
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
	ldy.b a0		; Y = opponent
	lda.w frame,x
	cmp.w oldframe,x		; same frame as last time: nothing new
	beq .ex
	cmp.w #SPFfight+2		; gloves dropped frame
	beq .dropped
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$0017		; within 22 in x
	bcs .ex
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$0009		; within 8 in y
	bcs .ex
	lda.w frame,x
	cmp.w #SPFfight+6		; high punch frames
	bne .h2
	jmp.w .hithigh
.h2:
	cmp.w #SPFfight+6+5
	bne .ne
	jmp.w .hithigh
.ne:
	cmp.w #SPFfight+7		; low punch frames
	bne .ne2
	jmp.w .hitlow
.ne2:
	cmp.w #SPFfight+7+5
	bne .g1
	jmp.w .hitlow
.g1:
	cmp.w #SPFfight+4		; grab frames
	beq .grab
	cmp.w #SPFfight+4+5
	beq .grab
.ex:		;93G chkhit .ex: movem the registers back (global: CwdFight/FightFall paths jump here)
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
	ldx.b a3		; X = a3 again
	rtl
.dropped:		;93G chkhit .dropped: gloves dropped, glovecords from xc1/yc1 (x clamped +-90)
	lda.w pflags,x
	and.w #~pf2npc&$FFFF		; clear pf2npc: gloves dropped
	sta.w pflags,x
	lda.w xc1
	sta.b d0
	sec
	sbc.w #$005A
	bmi .v1
	bvc .cl1
	bra .chkneg
.v1:
	bvc .chkneg
.cl1:
	lda.w #$005A
	sta.b d0
.chkneg:
	lda.b d0
	sec
	sbc.w #$FFA6
	beq .cl2
	bmi .v2
	bvs .cl2
	bra .drcont
.v2:
	bvs .drcont
.cl2:
	lda.w #$FFA6
	sta.b d0
.drcont:
	lda.b d0
	lsr a
	lsr a
	and.w #$00FF
	bne .dr0
	inc a
.dr0:
	sta.w glovecords		; glovecords x byte (0 becomes 1)
	lda.w yc1
	lsr a
	lsr a
	sep #$20
	sta.w glovecords+1		; glovecords y byte
	rep #$30
	bra .ex
.grab:		;exg a0,a3: the opponent is held
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	lda.w #SPAfheld
	sta.b d1
	sta.w pf2aip,x
	jsl.l SetSPA
	jmp.w .ex
.hithigh:
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	jsl.l CwdFight
	lda.w #$0001		; pf2aip
	sta.w pf2aip,x
	dec.w temp3,x		; strength -1; out of strength: falls
	bmi FightFall
	lda.w #SPAfhith
	sta.b d1
	jsl.l SetSPA
	lda.w #SFXhithigh
	pha
	jsl.l sfx
	jmp.w .ex
.hitlow:
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	jsl.l CwdFight
	lda.w #$0001
	sta.w pf2aip,x
	dec.w temp3,x
	bmi FightFall
	lda.w #SPAfhitl
	sta.b d1
	jsl.l SetSPA
	lda.w #SFXhitlow
	pha
	jsl.l sfx
	jmp.w .ex
CwdFight:		;93G chkhit .cwd (IDA CwdFight): crowd reacts to a punch; push the hit player X back by the puncher (a0) strength
	ldy.b a0
	lda.b crowdlevel
	clc
	adc.w #$0050		; +80
	sta.b crowdlevel
	lda.w #$0005		; (5 + puncher strength) * 500
	clc
	adc.w temp3,y
	sta.b mulb
	lda.w #$01F4
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002		; push the other way when facing right
	bne .xveladj
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.xveladj:
	lda.w Xvel,x
	clc
	adc.b d0
	sta.w Xvel,x
	rtl
FightFall:		;93G chkhit .fall (IDA FightFall): X lost the fight: the a0 player gets PenFighting, maybe X is injured
	lda.b a1+2		; push a1
	pha
	lda.b a1
	pha
	lda.w #PenaltyBufferEnd		; a1 = penalty list
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.loop:		;find the fight penalty of the a0 player
	inc.b a1
	inc.b a1
	lda.b [a1]
	and.w #$00FF
	cmp.w #PenFight
	bne .loop
	lda.b [a1]
	xba
	and.w #$000F
	sta.b d0
	ldy.b a0
	cmp.w SCnum,y		; penalty of the a0 player?
	bne .loop
	sep #$20
	lda.b #PenFighting		; it becomes PenFighting
	sta.b [a1]
	rep #$20
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$003C		; 60
	sta.w Pencntdwn
	lda.w #$FFFF		; temp3(a0) = -1: fight over for him
	sta.w temp3,y
	lda.b crowdlevel
	clc
	adc.w #$0258		; +600
	sta.b crowdlevel
	lda.w #$003C
	sta.b d0
	jsl.l randomd0
	ldy.b a0
	lda.b d0
	sec
	sbc.w aggress,y		; random 60 vs the winner aggress: injury?
	beq .inj
	bmi .v1
	bvs .inj
	bra .noinj
.v1:
	bvs .noinj
.inj:		;player X is injured
	lda.w #$00B4		; 180: player is injured
	sta.w Pencntdwn
	lda.w pflags,x
	ora.w #pf2inj
	sta.w pflags,x
	lda.w #SPAfinjury
	sta.b d1
	jsl.l SetSPA
	stx.b a2
	jsl.l setInjuryType		; setInjuryType (bank $8F): d1 = roster offset, bank $8F: 93G setInjuryType
	lda.b a0
	beq .team
	lda.w #$0034
.team:
	clc
	adc.b d1
	tay
	lda.w #INJfight		; tmpdst of the injured player = INJfight
	sta.w tmpdst,y
	lda.w #$0003
	sta.w InjCntDown		; 93G InjCntDown = 3
	stz.w Xvel,x
	jmp.w chkhit_ex
.noinj:
	lda.w #SPAffall
	sta.b d1
	jsl.l SetSPA
	stz.b a2
	lda.w #SFXcrowdcheer		; home won: cheer
	pha
	lda.w pfteam,x
	bne .snd
	lda.w #$0002
	sta.b a2
	lda.w #SFXcrowdboo
	sta.b $01,s
.snd:
	jsl.l sfx
	jmp.w chkhit_ex
assfwatch:		;asstab $15. for player who is watching fight (93G logic93_2)
		;   SNES: for a player watching a fight: skate to a spot 80 pixels from the fight
	lda.w pfalock,x
	beq .joy
	jmp.w .rts
.joy:
	lda.w pflags,x
	bit.w #pfjoycon		; joystick controlled
	beq .na
	jmp.w .rts
.na:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .spot
	jmp.w .go
.spot:		;new spot every second
	adc.w #$003C		; +60
	sta.w temp1,x
	lda.w Ypos,x
	sec
	sbc.w yc1
	pha
	lda.w Xpos,x
	sec
	sbc.w xc1
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b $03,s
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot		; distance to the fight
	lda.b d0
	bne .d
	lda.w #$0001
.d:
	sta.b d2
	pla
	sta.b d0
	sta.b mulb
	pla
	sta.b d1
	lda.w #$0050		; 80 pixels from the fight
	sta.b mula
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	adc.w xc1
	sta.b d0
	lda.w #$007E		; x within +-$7E
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	bmi .v1
	bvc .x0
	bra .x1
.v1:
	bvc .x1
.x0:
	lda.b d3
	sta.b d0
.x1:
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	beq .x2
	bmi .v2
	bvs .x2
	bra .x3
.v2:
	bvs .x3
.x2:
	lda.b d3
	sta.b d0
.x3:
	lda.b d0
	sta.w temp3,x
	lda.w #$0050
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	adc.w yc1
	sta.w temp4,x
.go:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss		; a0 = rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w Xvel,x		; SNES: halve the velocity while watching
	pha
	asl a
	pla
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	pha
	asl a
	pla
	ror a
	sta.w Yvel,x
	jsl.l skateto		; bank $88: 93G skateto (d0/d1 = spot, [a0] = arrival routine)
	jmp.w check4check
.rts:
	rtl
assfaceoff:		;asstab $16. players do nothing until faceoff is over (93G logic93_2)
		;   SNES: also starts the goal / period / mid-period music cues
	lda.w pfalock,x
	bne .rts
	lda.w sflags
	bit.w #sf2faceoff		; faceoff over: exit
	beq assexit
	lda.w goalcue		; home goal music cue
	beq .per
	stz.w goalcue
	lda.w #$0001		; hold and clear the sound queue
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	jsl.l StartSong1		; bank $89: home goal music cue
.per:
	lda.w percue		; period start music cue
	beq .mid
	stz.w percue
	lda.w #$0001
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	jsl.l StartSong2		; bank $89: period start music cue
.mid:
	lda.w cuetimer		; no cue playing, clock >= 60 and past midpercue: mid-period cue
	bne .rts
	lda.w gameclock
	cmp.w #$003C
	bcc .rts
	cmp.w midpercue
	bcs .rts
	stz.w midpercue
	jsl.l StartSong5		; bank $89: mid-period music cue
.rts:
	rtl
assexit:		;exit current assignment on player a3 (93G logic93_5)
		;   SNES: exit the current assignment of player X
	lda.w assnum,x
	inc a		; next assignment
	and.w #$0007
	sta.w assnum,x
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	rtl
assfaceoffp1:		;asstab $17. assignment for players actually participating in faceoff (93G logic93_2)
		;   SNES: assignment for the players taking the faceoff
	lda.w pfalock,x
	beq .go
	jmp.w .rts
.go:
	lda.w sflags
	bit.w #sf2faceoff		; faceoff over
	beq .exit
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w #fofdata2		; a0 = fofdata2, +4 for the visitors
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w pfteam,x
	beq .frame
	lda.w #fofdata2+4
	sta.b a0
.frame:
	lda.w SPAnum,x		; frame = SPAnum/4 + 1, +3 for a righty
	lsr a
	lsr a
	inc a
	sta.b d0
	lda.w handed,x
	bne .lefty
	inc.b d0
	inc.b d0
	inc.b d0
.lefty:
	lda.b d0
	sta.b [a0]
	lda.w pflags,x
	bit.w #pfjoycon		; joystick: the player pulls
	bne .rts
	lda.w pf2aip,x		; set pf2aip, test the old value
	pha
	lda.w #$0001
	sta.w pf2aip,x
	pla
	cmp.w #$0000
	bne .rts
	lda.w #SPAfaceoff
	sta.b d1
	lda.w temp1+puckobj		; puck temp1 > $10: 7 in 8 reverse pull
	cmp.w #$0011
	bcc .d
	lda.w #$0008
	sta.b d0
	jsl.l randomd0
	lda.b d0
	beq .d
	lda.w #SPAfaceoffr
	sta.b d1
.d:
	lda.w #$0001
	sta.w pf2aip,x
	jmp.w SetSPA
.rts:
	rtl
.exit:
	lda.w #$0014		; nopuck = 20
	sta.w nopuck,x
	jmp.w assexit
randomd0:		;d0 = range. Return random number in d0 (0 <= d0 < range) (93G middle93_1)
		;   SNES: d0 = random 0..d0-1 (via randoma)
	lda.b d0
	jsl.l randoma
	sta.b d0
	rtl
pucknorm:		;asstab $18. assignment for puck most of the time. a3 = puck, d7 = elapse frames since last call (93G logic93_4)
		;   SNES: assignment for the puck most of the time. X = puck, d7 = elapsed frames
	lda.w #pfna
	trb.w pflags+puckobj		; pfna
	beq .nna
	stz.w temp1+puckobj		; temp1 = 0, temp2b = still puck timer 120
	stz.w temp2+puckobj
	lda.w #$0078
	sta.w temp2b+puckobj
.nna:
	lda.w puckcross+2		; puckcross times count down
	sec
	sbc.b d7
	sta.w puckcross+2
	lda.w puckcross+6
	sec
	sbc.b d7
	sta.w puckcross+6
	lda.w temp1+puckobj		; every 5 frames: findpc
	sec
	sbc.b d7
	sta.w temp1+puckobj
	bpl .c0
	adc.w #$0005
	sta.w temp1+puckobj
	jsl.l findpc
.c0:		;puck carried: pull it a quarter of the way to the carrier hot spot
	lda.w puckc		; puck carrier
	bmi .nothandled
	asl a
	sta.b a2
	jsl.l a2touchpuck
	lda.b a2
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	lsr a
	lsr a
	bit.w #$2000		; asr #2
	beq .x
	ora.w #$C000
.x:
	clc
	adc.w puckx
	sta.w puckx
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	lsr a
	lsr a
	bit.w #$2000
	beq .y
	ora.w #$C000
.y:
	clc
	adc.w pucky
	sta.w pucky
	lda.w Xvel,y		; puck velocity = carrier velocity
	sta.w puckvx
	lda.w Yvel,y
	sta.w puckvy
.nothandled:
	jsl.l puckIChk
	jsl.l ChkOffsides
	lda.w gmclock		; clock stopped
	bne .z
	lda.w puckc		; loose puck that has not moved for 120 calls: whistle
	bpl .mv
	lda.w puckx
	cmp.w OldXpos+puckobj
	bne .mv
	lda.w pucky
	cmp.w OldYpos+puckobj
	bne .mv
	lda.w #PenOOP		; PenOOP: whistle
	sta.b d0
	dec.w temp2b+puckobj
	bpl .np
	jsl.l AddPenalty2
.np:
	bra .z
.mv:		;reset the still puck timer
	lda.w #$0078
	sta.w temp2b+puckobj
.z:
	lda.w puckvz		; puck in the air: no unflip
	and.w #$FF00
	ora.w Zpos+puckobj
	beq .flat
	jmp.w checkpuckcoll
.flat:
	jsl.l pucknothing		; pucknothing: stop spinning
	jmp.w checkpuckcoll		; 93G bra checkpuckcoll
findpc:		;find puck crossing lines: calculate when puck will cross goalline (if at all). Called from pucknorm (93G logic93_5)
		;   SNES: when and where will the puck cross each goal line
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .push
	ldx.b xsave
	lda.w #blueline+goalline		; top goal line (blueline+goalline)
	sta.b d4
	ldy.w #$0000
	jsl.l findpc_calc
	lda.w #-(blueline+goalline)		; bottom goal line
	sta.b d4
	ldy.w #$0004
	jsl.l findpc_calc
	stx.b xsave
	ldx.w #$0012
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
findpc_calc:		;93G findpc .calc: d4 = goal line y, Y = puckcross entry offset
	lda.b d4		; d0 = line - pucky
	sec
	sbc.w pucky
	sta.b d0
	lda.w puckvy
	bne .div
	jmp.w .nocross
.div:
	sta.b mula
	lda.b d0		; mulb = d0 << 12 (93G swap/asr #4)
	stz.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	bit.w #$0800
	beq .hi
	ora.w #$F000
.hi:
	sta.b mulb+2
	jsl.l divs
	bpl .time
	jmp.w .nocross
.time:
	sta.w puckcross+2,y		; frames until crossing
	lda.w puckvx
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32		; x offset = puckvx*d0/puckvy, if it fits
	lda.w puckvy
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	sta.b mula
	lda.b mulres+2
	bit.w #$8000
	beq .ov
	eor.w #$FFFF
	inc a
.ov:
	cmp.b mula
	bcs .nocross
	lda.w puckvy
	sta.b mula
	jsl.l divs
	adc.w puckx
	sta.b d0
	sec
	sbc.w #$0088		; sideline $88
	bmi .v1
	bvc .o1
	bra .o1b
.v1:
	bvc .o1b
.o1:		;bounce off the right side boards
	lda.w #$0198		; 3*$88 - x
	sec
	sbc.b d0
	sta.b d0
.o1b:
	lda.b d0
	sec
	sbc.w #$FF78
	beq .o2
	bmi .v2
	bvs .o2
	bra .o2b
.v2:
	bvs .o2b
.o2:		;bounce off the left side boards
	lda.w #$FE68		; -3*$88 - x
	sec
	sbc.b d0
	sta.b d0
.o2b:
	lda.b d0
	sta.w puckcross,y
	bra .rtl
.nocross:
	lda.w #$FFFF
	sta.w puckcross+2,y
.rtl:
	rtl
divs:		;68k divs: A = mulres = mulb (32-bit) / mula, signed 16-bit quotient. C clear
	stz.b mulsign		; mulsign = number of negative operands
	lda.b mula
	bpl .apos
	eor.w #$FFFF
	inc a
	inc.b mulsign
.apos:
	sta.b mula+2
	stz.b mula
	lda.w #$0010		; 16 quotient bits
	sta.b mulcnt
	lda.b mulb+2
	bpl .loop
	lda.w #$0000
	sec
	sbc.b mulb
	sta.b mulb
	lda.w #$0000
	sbc.b mulb+2
	sta.b mulb+2
	inc.b mulsign
.loop:
	lsr.b mula+2
	ror.b mula
	asl.b mulres
	lda.b mulb
	cmp.b mula
	lda.b mulb+2
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	lda.b mulb+2
	sbc.b mula+2
	sta.b mulb+2
	inc.b mulres
.next:
	dec.b mulcnt
	bne .loop
	lsr.b mulsign
	bcc .rtl
	lda.w #$0000
	sbc.b mulres
	sta.b mulres
.rtl:
	lda.b mulres
	clc
	rtl
a2touchpuck:		;player a2 touches puck. Look for penalties/offsides/other junk. Called from pucknorm, puckstick and others (93G logic93_5)
		;   SNES: last touch, offsides, icing
	ldy.b a2
	lda.w Xpos,y
	sta.w ltx		; ltx/lty/ltplayer
	lda.w Ypos,y
	sta.w lty
	tya
	lsr a
	sta.w ltplayer
	stz.b a0		; a0 = team
	lda.w pfteam,y
	beq .t
	inc.b a0
	inc.b a0
.t:
	lda.w pnum,y
	sta.b d0
	ldy.b a0
	cmp.w tmtouch1,y		; same player as the last touch: no change
	beq .same
	lda.w tmflags,y
	bit.w #tmflast		; tmflast: overwrite the last touch only
	beq .shift
	and.w #~tmflast&$FFFF
	sta.w tmflags,y
	bra .st
.shift:		;shift the touch list down
	lda.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmtouch1,y
	sta.w tmtouch2,y
.st:
	lda.b d0
	sta.w tmtouch1,y
	cmp.w tmtouch3,y		; also the third touch: drop it
	bne .same
	lda.w #$FFFF
	sta.w tmtouch3,y
.same:
	lda.w #sf2shot		; sf2shot
	trb.w sflags
	jsl.l a2offsides
	ldy.b a2
	lda.w iflags		; ifok and ifcgl and a skater: icing
	bit.w #ifok
	beq .notice
	bit.w #ifcgl
	beq .notice
	lda.w position,y
	beq .notice
	lda.w iflags
	bit.w #ifdir
	bne .up
	lda.w pfgoal,y
	beq .notice
.icing:		;93G a2touchpuck .icing: icing on icingPlayer
	phx
	lda.w iflags+1		; X = icingPlayer
	and.w #$00FF
	asl a
	sta.b a3
	tax
	lda.w #PenIcing		; PenIcing
	sta.b d0
	jsl.l AddPenalty		; AddPenalty
	plx
	stx.b a3
.rtl:
	rtl
.up:
	lda.w pfgoal,y
	beq .icing
.notice:		;93G a2touchpuck .notice: start a new icing watch for player a2
	tya
	lsr a
	xba
	sta.w iflags		; iflags = 0, icingPlayer = a2
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	beq .zero
	lda.w #ifdir		; ifdir
	tsb.w iflags
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.zero:
	lda.b d0
	bmi .rtl
	lda.w tmap		; own team not short-handed?
	sec
	sbc.w tmap+2
	sta.b d0
	lda.w pfteam,y
	beq .men
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.men:
	lda.b d0
	bmi .rtl
	lda.w #ifok		; ifok
	tsb.w iflags
	rtl
a2offsides:		;player a2 touched the puck: offsides penalty if his team is flagged and the puck is past the blue line. Called from a2touchpuck (93G logic93_5)
		;   SNES: offsides if his team is flagged and the puck is past the blue line
	ldy.b a2
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	bne .p0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.p0:
	lda.b d0
	sec
	sbc.w #blueline		; blueline
	bmi .v1
	bvc .team
	bra .rtl
.v1:
	bvc .rtl
.team:
	stz.b a0
	lda.w pfteam,y
	beq .t1
	lda.w #$0002
	sta.b a0
.t1:
	ldy.b a0
	lda.w tmflags,y
	bit.w #tmfoffside		; team flagged offsides
	beq .rtl
	lda.w gmode
	bit.w #gmhl		; gmhl
	bne .rtl
	ldx.b a2		; exg a2,a3
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #PenOffsides		; PenOffsides
	sta.b d0
	jsl.l AddPenalty		; AddPenalty
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
.rtl:
	rtl
GetHot:		;push long address of structure to get hot spot from. Hot spot x/y returned in d0/d1. 93 reads a byte pair per frame from HotList (92 framelist SprStrHot) (93G logic93_5)
		;   SNES: A = object index; d0/d1 = its hot spot x/y from HotList (bank84_F000, a byte pair per frame)
	phx
	tay
	stz.b d0
	stz.b d1
	lda.w frame,y
	cmp.w #$0179		; the SNES frame list skips 6 frames from $179
	bcc .remap
	sbc.w #$0006
.remap:
	cmp.w #$0226		; frames 1-$225 have hot spots
	bcs .ex
	dec a
	bmi .ex
	asl a
	tax
	lda.l HotList,x		; HotList x (bank $84)
	and.w #$00FF
	bit.w #$0080
	beq .hx
	ora.w #$FF00
.hx:
	sta.b d0
	lda.l HotList+1,x		; HotList y
	and.w #$00FF
	bit.w #$0080
	beq .hy
	ora.w #$FF00
.hy:
	sta.b d1
	lda.w attribute,y
	bit.w #attrxflip		; x flip
	beq .nox
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.nox:
	lda.w attribute,y
	bit.w #attryflip		; y flip (clear = negate)
	bne .noy
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.noy:
	lda.w sfhormode		; horizontal mode: rotate
	beq .ex
	lda.b d0
	ldy.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	sty.b d0
.ex:
	plx
	rtl
puckIChk:		;check for icing of puck penalty. Called from pucknorm (93G logic93_5)
		;   SNES: Called from pucknorm
	lda.w iflags
	bit.w #ifok		; ifok and not ifcgl, puck loose
	beq .rtl
	bit.w #ifcgl
	bne .rtl
	lda.w puckc
	bpl .rtl
	lda.w #blueline+goalline		; blueline+goalline
	sta.b d0
	lda.w iflags
	bit.w #ifdir
	bne .up
	lda.w #-(blueline+goalline)
	sec
	sbc.w pucky
	beq .rtl
	bmi .v1
	bvs .rtl
	bra .set
.v1:
	bvs .set
.rtl:
	rtl
.up:
	lda.w #blueline+goalline
	sec
	sbc.w pucky
	beq .set
	bmi .v2
	bvs .set
	bra .rtl
.v2:
	bvs .rtl
.set:
	lda.w #ifcgl		; ifcgl
	tsb.w iflags
	rtl
ChkOffsides:		;check for offsides penalty. a3 = puck. 93 flags the whole team (tmflags bit 4), 92 flagged each player (pf3oside). Called from pucknorm (93G logic93_5)
		;   SNES: flag a team offsides when the puck crosses its blue line. Called from pucknorm
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	stz.b a1		; a1 = home, a2 = away; then swapped
	lda.w #$0002
	sta.b a2
	jsl.l ClearOffsidesIfAllPlayers
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l ClearOffsidesIfAllPlayers
	lda.w #blueline-4		; blueline-4
	sta.b d0
	sec
	sbc.w pucky
	beq .top
	bmi .v1
	bvs .top
	bra .neg
.v1:
	bvs .neg
.top:		;puck crossed the top line this frame?
	lda.w #blueline-4
	sec
	sbc.w OldYpos+puckobj
	beq .rtl
	bmi .v2
	bvc .t
	bra .rtl
.v2:
	bvc .rtl
.t:
	lda.w #blueline-4+$A		; +$A
	sta.b d0
	lda.w gmode
	bit.w #gmdir		; gmdir
	beq .t0
	lda.b a2
	ldy.b a1
	sta.b a1
	sty.b a2
.t0:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.loop:
	ldy.b a0
	lda.w position,y
	bmi .n0
	lda.b d0
	sec
	sbc.w Ypos,y
	bmi .v3
	bvs .set0
	bra .n0
.v3:
	bvs .n0
.set0:
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoffside		; tmfoffside
	sta.w tmflags,y
.rtl:
	rtl
.n0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .loop
	rtl
.neg:		;bottom line
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	sec
	sbc.w pucky
	bmi .v4
	bvc .b1
	bra .rtl
.v4:
	bvc .rtl
.b1:
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi .v5
	bvs .t1
	bra .rtl
.v5:
	bvs .rtl
.t1:
	lda.b d0
	sec
	sbc.w #$000A		; -$A
	sta.b d0
	lda.w gmode
	bit.w #gmdir
	bne .t2
	lda.b a2
	ldy.b a1
	sta.b a1
	sty.b a2
.t2:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.loop2:
	ldy.b a0
	lda.w position,y
	bmi .n2
	lda.b d0
	sec
	sbc.w Ypos,y
	beq .n2
	bmi .v6
	bvc .set2
	bra .n2
.v6:
	bvc .n2
.set2:
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoffside
	sta.w tmflags,y
	rtl
.n2:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .loop2
	rtl
ClearOffsidesIfAllPlayers:		;a2 = team struct. Clears the team offsides flag (tmflags bit 4) once no skater on ice is past the blue line ($58, sign by pfgoal). Called twice from ChkOffsides
		;   (93G logic93_5)
		;   SNES: clear tmfoffside once no skater is past the blue line
	ldy.b a2
	lda.w tmflags,y		; tmfoffside
	bit.w #tmfoffside
	bne .go
	jmp.w ChkOffsides_rtl
.go:
	lda.w tmsort,y
	sta.b a0
	lda.w #$0005
	sta.b d1
.top:
	ldy.b a0
	lda.w position,y
	bmi .next
	lda.w Ypos,y
	sta.b d0
	lda.w pfgoal,y
	bne .next
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.next:
	inc.b a0
	inc.b a0
	lda.b d0
	sec
	sbc.w #blueline
	beq .more
	bmi .v1
	bvs .more
.rtl:
	jmp.w ChkOffsides_rtl
.v1:
	bvs .rtl
.more:
	dec.b d1
	bpl .top
	ldy.b a2
	lda.w tmflags,y
	and.w #~tmfoffside&$FFFF		; clear tmfoffside
	sta.w tmflags,y
	rtl
checkpuckcoll:		;look for puck coll with players. a3 = puck. Entered from pucknorm (logic93_4) (93G hockey93_04)
		;   SNES: puck collision with the players within 22 in y (OOlist up and down from the puck)
	lda.w Zpos+puckobj		; puck feet in the air (Zpos > 16): no collision
	sec
	sbc.w #$0010
	beq .setup
	bmi .v1
	bvs .setup
	bra .rtl
.v1:
	bvs .rtl
.setup:
	lda.w OOlistpos+puckobj		; Y = puck position in OOlist
	sta.b d1
.up:
	ldy.b d1
	cpy.w #$000F		; top object
	beq .cl
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w Ylist,y
	sec
	sbc.w pucky
	sec
	sbc.w #$0016		; next higher object within 22 in y
	beq .cc1
	bmi .v2
	bvs .cc1
	bra .cl
.v2:
	bvs .cl
.cc1:
	jsl.l checkpuckcoll_ccx
	inc.b d1
	bra .up
.cl:
	lda.w OOlistpos+puckobj
	beq .rtl
	sta.b d1
.dn:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w pucky
	sec
	sbc.w Ylist,y
	sec
	sbc.w #$0016
	beq .cc2
	bmi .v3
	bvs .cc2
	bra .rtl
.v3:
	bvs .rtl
.cc2:
	jsl.l checkpuckcoll_ccx
	dec.b d1
	bne .dn
.rtl:
	rtl
checkpuckcoll_ccx:		;93G checkpuckcoll .ccx: d4 = object index: stick (puckstick), body (puckbody) or goalie (puckgoalie) contact
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .push
	ldx.b xsave
	lda.b d4		; a2 = object
	sta.b a2
	tay
	lsr a
	cmp.w puckc
	bne .pl
	jmp.w .exit
.pl:
	cmp.w #$000C		; not a player
	bcc .nc
	jmp.w .exit
.nc:
	lda.w pfnc,y		; no collision or nopuck
	ora.w nopuck,y
	beq .unav
	jmp.w .exit
.unav:
	lda.w pflags,y
	bit.w #pf2unav		; pf2unav: body only
	beq .z
	jmp.w .chkbody
.z:
	lda.w Zpos+puckobj
	sec
	sbc.w #$0005		; puck above 5
	beq .zv
	bmi .v1
	bvs .zv
.body1:
	jmp.w .chkbody
.v1:
	bvs .body1
.zv:
	lda.w puckvz
	sec
	sbc.w #$0100		; puckvz > $100
	beq .stick
	bmi .v2
	bvs .stick
.body2:
	jmp.w .chkbody
.v2:
	bvs .body2
.stick:
	tya
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .sx
	eor.w #$FFFF
	inc a
.sx:
	cmp.w #$000F		; stick: within 14
	bcs .chkbody
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .sy
	eor.w #$FFFF
	inc a
.sy:
	cmp.w #$000F
	bcs .chkbody
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.w #$00C4		; cstick^2 ($C4), /4 if the puck is not ready to be caught
	sta.b d1
	lda.w nopuck+puckobj
	bmi .lo
	beq .lo
	lsr.b d1
	lsr.b d1
.lo:
	lda.b d1
	cmp.b d0
	lda.w #$0000
	sbc.b d0+2
	bcc .chkbody
	jsl.l puckstick
	bra .exit
.chkbody:
	lda.w position,y
	beq .chkgoalie
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .bx
	eor.w #$FFFF
	inc a
.bx:
	cmp.w #$0009		; body: within 8
	bcs .exit
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .by
	eor.w #$FFFF
	inc a
.by:
	cmp.w #$0009
	bcs .exit
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0
	cmp.w #$0041		; cbody^2
	lda.b d0+2
	sbc.w #$0000
	bcs .exit
	jsl.l puckbody
.exit:
	stx.b xsave
	ldx.w #$001A
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
.chkgoalie:
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .gx
	eor.w #$FFFF
	inc a
.gx:
	cmp.w #$000D		; goalie: within 12
	bcs .exit
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .gy
	eor.w #$FFFF
	inc a
.gy:
	cmp.w #$000D
	bcs .exit
	jsl.l puckgoalie
	bra .exit
puckstick:		;puck collides with stick (93G hockey93_05)
		;   SNES: puck hits the stick of player a2. d0 = distance^2 (from checkpuckcoll_ccx)
	ldy.b a2
	lda.w position,y
	bne .p0
	lda.w gmode
	bit.w #gmhl		; gmhl: goalie ignores the puck
	beq .p0
	jmp.w .rtl
.p0:
	lda.w pflags,y
	and.w #~pfdoff&$FFFF		; clear pfdoff
	sta.w pflags,y
	lda.w puckc
	bpl .carried
	jmp.w .nosteal
.carried:
	asl a
	sta.b a0
	tay
	lda.w pfteam,y
	beq .t1
	lda.w #$0001
.t1:
	sta.b tmp0
	ldy.b a2
	lda.w pfteam,y
	beq .t2
	lda.w #$0001
.t2:
	eor.b tmp0
	bne .range
	jmp.w .rtl
.range:
	lda.b d0
	cmp.w #$0025		; 6*6: smaller range for stealing
	lda.b d0+2
	sbc.w #$0000
	bcc .roll
	jmp.w .rtl
.roll:		;steal roll: carrier stickhand - stealer stickhand + 36
	lda.w position,y
	beq .steal		; goalie always steals
	ldy.b a0
	lda.w position,y
	bne .rnd
	jmp.w .rtl
.rnd:
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	pha
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	pla
	sec
	sbc.b d0
	clc
	adc.w #$0024
	jsl.l randoma
	cmp.w #$0003		; steal fails
	bcs .rtl
.steal:
	ldy.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	clc
	adc.w #$0014		; nopuck = makepde(stickhand) + 20 for both
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	clc
	adc.w #$0014
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	tya
	lsr a
	sta.w lastplayer		; lastplayer = the old carrier
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
.stdef:		;stick deflect sound, touch, deflect
	lda.w seed+1		; stick deflect sound (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	jsl.l a2touchpuck
	jmp.w deflect		; deflect
.rtl:
	rtl
.nosteal:
	ldy.b a2
	lda.w position,y
	bne .spd
	lda.b d0
	cmp.w #$0041		; goalie: loose puck within 8
	lda.b d0+2
	sbc.w #$0000
	bcs .rtl
.spd:		;catch if the puck speed^2 <= (13000+700*stickhand)^2
	lda.w puckvx
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w puckvy
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	stz.b d1
	lda.w sflags		; sf2shot: no stickhand bonus
	bit.w #sf2shot
	bne .nohand
	ldy.b a2
	lda.w stickhand,y
	sta.b mulb
	lda.w #$02BC		; * 700
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	sta.b d1
.nohand:
	lda.b d1
	clc
	adc.w #$32C8		; + 13000
	sta.b mula
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	cmp.b d0
	lda.b mulres+2
	sbc.b d0+2
	bcs puckglue
	ldy.b a2
	lda.w #$0008		; too fast: nopuck 8, deflect
	sta.w nopuck,y
	jmp.w .stdef
puckglue:		;Player a2 takes the puck (92 puckstick .glue) (93G hockey93_05)
		;   SNES: Falls into setd0player (bank $8D)
	lda.w seed+2		; pickup sound (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	ldy.b a2
	tya
	lsr a
	sta.w puckc		; puckc = a2
	sta.b d0
	stz.b a0
	lda.w #$0002
	sta.b a1
	lda.w pfteam,y
	bne .tm
	stz.b a1
	lda.w #$0002
	sta.b a0
.tm:
	ldy.b a0
	lda.w #$FFFF
	sta.w tmtouch2,y		; other team loses its touches
	sta.w tmtouch3,y
	lda.w tmflags,y
	ora.w #tmflast
	sta.w tmflags,y
	lda.w #sf3fo
	trb.w sflags3		; sf3fo: this pickup wins the faceoff
	beq .snd
	ldy.b a1
	lda.w tmfowon,y
	inc a
	sta.w tmfowon,y
	lda.b crowdlevel		; +200
	clc
	adc.w #$00C8
	sta.b crowdlevel
.snd:
	lda.b a2
	lsr a
	sta.b d0
	cmp.w passReceiverPlayerNum		; pass reached its receiver
	bne .nrec
	ldy.b a1
	lda.w tmpasscomp,y
	inc a
	sta.w tmpasscomp,y
.nrec:
	lda.w #$FFFF
	sta.w passReceiverPlayerNum
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
	ldy.b a2
	lda.w position,y
	beq .goalie
	jml.l setd0player		; bank $8D: 93G setd0player
.goalie:
	jsl.l ChkShotStat		; ChkShotStat (goalie made a save)
	ldy.b a2
	lda.w #$008C		; temp5 = 140, count down for the faceoff
	sta.w temp5,y
	lda.w SPA,y
	cmp.w #SPAgdive
	beq .g314
	jml.l setd0player		; bank $8D: 93G setd0player
.g314:
	lda.w #$0005
	sta.w temp5,y
	jml.l setd0player		; bank $8D: 93G setd0player
