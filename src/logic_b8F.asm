; Player logic and the assignments (asstab).
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8F833F
asseben:		;asstab 9. player a3 should exit bench area
		;   SNES: player X comes onto the ice from the bench door (SPAwallright), then assexit
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #$0002
	beq .nopflags
	and.w #$FFFD
	sta.w pflags,x
	stz.w Xvel,x
	stz.w Yvel,x
	txa
	lsr a
	sec
	sbc.w #$0006
	bmi .neg
	inc a
.neg:
	sta.b mulb
	lda.w #$000E
	sta.b mula
	jsl.l muls16
	sta.w Ypos,x
	lda.w #$FF78
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #$101A
	sta.b d1
	jml.l SetSPA
.rtl:
	rtl
.nopflags:
	lda.w #$0004
	sta.w facedir,x
	lda.w pflags,x
	and.w #$6FFF
	sta.w pflags,x
	stz.w pfnc,x
	stz.w SPA,x
	lda.w #$1000
	sta.w Xvel,x
	jml.l assexit

org $8F8C4B
assdopen:		;asstab $D. add player a3 to penalty box
		;   SNES: add player X to the penalty box (PBnum), position -1, frame 0
	lda.w pfalock,x
	bne .rtl
	lda.w #$0010
	sta.b d0
	lda.w pfteam,x
	beq .nopfteam
	lda.w #$0001
	sta.b d0
.nopfteam:
	lda.w PBnum
	clc
	adc.b d0
	sta.w PBnum
	lda.w #$FFFF
	sta.w position,x
	stz.w frame,x
.rtl:
	rtl

org $8F8DC7
lcfound:		;d2 = line choice 0-2: getlchoice; loadTeamStruct, tmline, setpersonel, lcfound2
	ldx.b a3
	ldy.b a2
	lda.b d2
	sta.b d0
	sta.w tmlcchoice,y
	jsl.l getlchoice
	lda.b d0
	bmi .rtl
	lda.w pflags,x
	and.w #$DFFF
	ora.w #$0008
	sta.w pflags,x
	jsl.l loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFF7
	sta.w tmflags,y
	lda.b d0
	sta.w tmline,y
	jsl.l setpersonel
	jml.l lcfound2
.rtl:
	rtl

org $8FD4F9
fightinput:		;controller processing for fighting
		;   SNES: pad input in a fight: dpad moves (playeracc), stay near the fight spot (xc1), B/A/Y punch (SPA $F82/$F50/$F0C)
	lda.w temp3,x
	ora.w Pencntdwn
	bpl .Pencntdwnpos
	jmp.w .rtl
.Pencntdwnpos:
	lda.w SPA,x
	cmp.w #$0EDA
	bne .SPAne
	jmp.w .rtl
.SPAne:
	lda.b d1
	pha
	lda.b d0
	sta.b d2
	bit.w #$0008
	bne .nonzero
	and.w #$0007
	sta.b d2
	jsl.l playeracc
.nonzero:
	lda.w xc1
	clc
	adc.w #$000C
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .facedirne
	lda.b d0
	sec
	sbc.w #$0018
	sta.b d0
.facedirne:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Xvel,x
	eor.b d0
	sta.b d1
	bpl .Xvelpos
	lda.b d0
	bit.w #$8000
	beq .nod0
	eor.w #$FFFF
	inc a
.nod0:
	sta.b d0
	lda.w Xvel,x
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lda.w #$0006
	sta.b mula
	jsl.l divs
	sta.b d0
	lda.w Xvel,x
	sec
	sbc.b d0
	sta.w Xvel,x
.Xvelpos:
	pla
	sta.b d1
	lda.w pf2aip,x
	bne .rtl
	lda.b d1
	sta.b d2
	lda.w #$0F50
	sta.b d1
	sta.w pf2aip,x
	lda.b d2
	bit.w #$0080
	beq .nod2
	jml.l SetSPA
.nod2:
	lda.w #$0F82
	sta.b d1
	lda.b d2
	bit.w #$8000
	beq .nod22
	jml.l SetSPA
.nod22:
	lda.w #$0F0C
	sta.b d1
	lda.b d2
	bit.w #$4000
	beq .nod23
	jml.l SetSPA
.nod23:
	stz.w pf2aip,x
.rtl:
	rtl

org $8FD75A
assnothing:		;player should do nothing
		;   SNES: a computer player stands (doplayeracc 8)
	lda.w pflags,x
	bit.w #$0008
	bne .rtl
	lda.w #$0008
	sta.b d0
	jmp.w doplayeracc
.rtl:
	rtl
GoalieCount:		;SNES: d0 = goalies of team a2 (nibbles of its goalie weights word, team record +$A, until 0); hangs if a2 is not 0 or 2
	lda.b a2
	tay
	and.w #$FFFD
.loop:
	bne .loop
	lda.w #TeamList>>16
	sta.b tmp1
	lda.w tmdata,y
	sta.b tmp0
	ldy.w #ScoreOdds
	clc
	adc.b [tmp0],y
	sta.b tmp0
	stz.b d0
	lda.b [tmp0]
	xba
.loop2:
	inc.b d0
	asl a
	asl a
	asl a
	asl a
	bne .loop2
	rtl

org $8FDA8F
assstanley:		;asstab 8. player a3 skates with stanley cup overhead
		;   SNES: skate to the side of the screen holding the Stanley Cup (SPAcup)
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #$0002
	beq .nopflags
	and.w #$FFFD
	sta.w pflags,x
	lda.w #$005A
	sta.w temp3,x
	lda.w Hpos
	bpl .Hpospos
	lda.w #$FFA6
	sta.w temp3,x
.Hpospos:
	lda.w Vpos
	sta.w temp4,x
	lda.w #$1124
	sta.b d1
	jsl.l SetSPA
.nopflags:
	lda.w temp3,x
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w temp4,x
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w #$0007
	beq .nod0
	bmi .neg
	bvs .nod0
	bra .rtl
.neg:
	bvs .rtl
.nod0:
	lda.b d0
	sta.b d2
	sta.w facedir,x
	jmp.w playeracc
.rtl:
	rtl

org $8FDB1B
asscenterd:		;asstab 5. player a3 is center on defense
		;   SNES: centre on defence: halfway between the puck and his goal; acentero when the team gets the puck
	lda.w gmclock
	beq .nogmclock
	jml.l assnothing
.nogmclock:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .nopflags
	jmp.w .rtl
.nopflags:
	bit.w #$0002
	beq .zero
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.zero:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .pos
	lda.w aidef,x
	sta.w temp1,x
	lda.w puckc
	bmi .pos
	sec
	sbc.w #$0006
	sta.b d1
	lda.w #$0006
	sta.b d0
	txa
	lsr a
	sec
	sbc.w #$0006
	eor.b d1
	bmi .pos
	jml.l assreplace
.pos:
	lda.w puckx
	pha
	asl a
	pla
	ror a
	sta.b d0
	lda.w #$0080
	sta.b d1
	lda.w pfgoal,x
	beq .nopfgoal
	lda.w #$FF80
	sta.b d1
	lda.w #$FFA8
	sec
	sbc.w pucky
	beq .zero2
	bmi .neg
	bvs .zero2
	bra .join
.neg:
	bvs .join
.zero2:
	lda.w #$FF80
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
	bra .join
.rtl:
	rtl
.nopfgoal:
	lda.w #$0058
	sec
	sbc.w pucky
	bmi .neg2
	bvc .vc
	bra .join
.neg2:
	bvc .join
.vc:
	lda.b d1
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
.join:
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jml.l skateto

org $8FE164
playeracc:		;d2 = direction of acc
		;   SNES: accelerate player X in direction d2 (dirtab8F, Wallsin/Wallcos, weight and legstr), cap at MaxSpeed; energy use
	asl.b d2
	asl.b d2
	ldx.b d2
	lda.l dirtab8F+2,x
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	lsr a
	lsr a
	bit.w #$2000
	beq .zero
	ora.w #$C000
.zero:
	sta.b d1
	lda.l dirtab8F,x
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	lsr a
	lsr a
	bit.w #$2000
	beq .zero2
	ora.w #$C000
.zero2:
	sta.b d0
	ldx.b a3
	lda.w Wallsin,x
	beq .noWallsin
	eor.b d0
	bpl .noWallsin
	stz.b d0
.noWallsin:
	lda.w Wallcos,x
	beq .noWallcos
	eor.b d1
	bmi .noWallcos
	stz.b d1
.noWallcos:
	lda.w weight,x
	lsr a
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0020
	clc
	adc.w legstr,x
	sta.b d2
	lda.w position,x
	bne .position
	lda.b d2
	clc
	adc.w legstr,x
	clc
	adc.w #$0008
	sta.b d2
.position:
	lda.b d2
	pha
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	adc.w Xvel,x
	sta.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	pla
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	adc.w Yvel,x
	sta.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d3
	lda.b mulres+2
	adc.b d2+2
	sta.b d3+2
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l getpde
	lda.w legspd,x
	sta.b mula
	lda.b d0
	lsr a
	clc
	adc.w #$0800
	sta.b mulb
	jsl.l mulu
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	lda.b mulres+2
	asl a
	asl a
	tax
	lda.l MaxSpeed,x
	sta.b d2
	lda.l MaxSpeed+2,x
	sta.b d2+2
	ldx.b a3
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b d2
	cmp.b d3
	lda.b d2+2
	sbc.b d3+2
	bcc .d2lt
	lda.b d0
	sta.w Xvel,x
	lda.b d1
	sta.w Yvel,x
.d2lt:
	lda.w OptLine
	bne .rtl
	lda.w seed
	and.w #$003F
	bne .rtl
	jsl.l getpde
	lda.b d0
	sec
	sbc.w #$0021
	sta.b d0
	sec
	sbc.w #$0C00
	bmi .neg
	bvc .vc
.loop:
	jmp.w setpde
.neg:
	bvc .loop
.vc:
	lda.w endurance,x
	sta.b d2
	clc
	adc.b d0
	sta.b d0
	jmp.w setpde
.rtl:
	rtl
dirtab8F:		;x, y acceleration per direction 0-7 (playeracc)
	dw 0,800
	dw 565,565
	dw 800,0
	dw 565,-565
	dw 0,-800
	dw -565,-565
	dw -800,0
	dw -565,565

org $8FE3B0
WeightedRandomSelect:		;d0 = number of word weights at nibblebuffer. Return d0 = random index, picked with those weights. Called from SetScore_getscore and UpdateTeamNameisplay

		;   SNES: d0 = random index 0..d0-1 weighted by the words in nibblebuffer
	lda.b d1+2
	pha
	lda.b d1
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #nibblebuffer
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b d1
	bra .join
.loop:
	lda.b d1
	clc
	adc.b [a1]
	sta.b d1
	inc.b a1
	inc.b a1
.join:
	dec.b d0
	bpl .loop
	lda.b d1
	sta.b d0
	jsl.l randomd0
.loop2:
	dec.b a1
	dec.b a1
	lda.b d0
	sec
	sbc.b [a1]
	sta.b d0
	bpl .loop2
	lda.b a1
	sec
	sbc.w #nibblebuffer
	lsr a
	sta.b d0
	pla
	sta.b a1
	pla
	sta.b a1+2
	pla
	sta.b d1
	pla
	sta.b d1+2
	rtl

org $8FE43C
passmode:		;dpad sets passdir until bbut changes
		;   SNES: B held: a dpad direction sets passdir (d0 | 8) before dopass
	lda.b d2
	bit.w #$8000
	bne dopass
	lda.b d0
	bit.w #$0008
	bne .rtl
	and.w #$0007
	sta.w passdir
	ora.w #$0008
	sta.b d0
	bra dopass
.rtl:
	rtl
dopass:		;pass the puck in passdir, to the best teammate there if any.
		;   SNES: the team mate nearest the passdir lane (or passdir), puck velocity, SPA, pfalock
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
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
	lda.w seed+2
	and.w #$0003
	clc
	adc.w #$0098
	pha
	jsl.l sfx
	lda.w #$0004
	trb.w sflags
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0010
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	lda.w #$0007
	sta.b d0
	lda.w position,x
	beq .noposition
	lda.w passacc,x
	sta.b d0
.noposition:
	lda.b d0
	asl a
	asl a
	adc.w #$0090
	sta.w passspeed
	lda.w #$FFFF
	sta.b d4+2
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcc .loop
	lda.w #$000C
	sta.b a1
.loop:
	cpx.b a1
	bne .ne
	jmp.w .join
.ne:
	ldy.b a1
	lda.w position,y
	bne .position
	jmp.w .join
.position:
	lda.w pflags,y
	bit.w #$1000
	beq .nopflags
	jmp.w .join
.nopflags:
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	pha
	jsl.l vtoa
	pla
	sta.b d1
	pla
	sta.b d2
	lda.b d0
	sec
	sbc.w passdir
	and.w #$0007
	asl a
	asl a
	asl a
	asl a
	asl a
	and.w #$00FF
	bit.w #$0080
	beq .zero
	ora.w #$FF00
.zero:
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	cmp.w #$0001
	lda.b mulres+2
	sta.b d0+2
	sbc.w #$0001
	bcs .join
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d1
	sta.b d2
	lda.b mulres+2
	adc.b d1+2
	sta.b d2+2
	lda.b d2
	clc
	adc.b d0
	sta.b d2
	lda.b d2+2
	adc.b d0+2
	sta.b d2+2
	lda.b d4
	cmp.b d2
	lda.b d4+2
	sbc.b d2+2
	bcc .join
	lda.b d2
	sta.b d4
	lda.b d2+2
	sta.b d4+2
	lda.b a1
	sta.b a0
.join:
	inc.b a1
	inc.b a1
	dec.b d3
	bmi .d3neg
	jmp.w .loop
.d3neg:
	lda.b d4+2
	bmi .d4neg
	jsl.l passtoa0
	jmp.w .join2
.d4neg:
	lda.w passdir
	asl a
	asl a
	adc.w #dirtab+2
	sta.b a0
	lda.w #dirtab>>16
	sta.b a0+2
	lda.b [a0]
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l muls32
	stz.b mulb
	lda.b mulres
	sta.b mulb+1
	lda.b mulres+2
	sta.b mulb+3
	asl.b mulb
	rol.b mulb+2
	asl.b mulb
	rol.b mulb+2
	lda.w #$0BB8
	sta.b mula
	jsl.l divs
	adc.w Yvel,x
	sta.w puckvy
	dec.b a0
	dec.b a0
	lda.b [a0]
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l muls32
	stz.b mulb
	lda.b mulres
	sta.b mulb+1
	lda.b mulres+2
	sta.b mulb+3
	asl.b mulb
	rol.b mulb+2
	asl.b mulb
	rol.b mulb+2
	lda.w #$0BB8
	sta.b mula
	jsl.l divs
	adc.w Xvel,x
	sta.w puckvx
	lda.w #$1000
	jsl.l randoma
	sta.w puckvz
.join2:
	lda.w position,x
	bne .position2
	lda.w pfgoal,x
	beq .nopfgoal
	lda.w puckvy
	bmi .puckvyneg
	bra .position2
.nopfgoal:
	lda.w puckvy
	bmi .position2
.puckvyneg:
	eor.w #$FFFF
	inc a
	sta.w puckvy
.position2:
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	lda.w #$02D2
	sta.b d1
	lda.w position,x
	beq .noposition2
	lda.w #$06C4
	sta.b d1
	jsl.l Findhittype
	beq .noposition2
	lda.w #$0736
	sta.b d1
.noposition2:
	jsl.l SetSPA
	lda.w #$0001
	sta.w pfalock,x
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
	ldx.w #$0016
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl

org $8FE6BD
CompLine:		;find good line for comp to switch to. a2 = team, a1 = other team. Called from chk4lc and puckfaceoff
		;   SNES: the computer team picks a line by the man advantage, the score late in the game and the line energies (getlinee)
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
	lda.w #$0003
	sta.b d0
	ldy.b a2
	lda.w tmap,y
	ldy.b a1
	cmp.w tmap,y
	beq .a1eq
	bpl .a1pos
	inc.b d0
	inc.b d0
.a1pos:
	lda.b d0
	pha
	jsl.l getlinee
	lda.b d0
	sta.b d1
	lda.b $01,s
	inc a
	sta.b d0
	jsl.l getlinee
	lda.b d1
	sec
	sbc.b d0
	bmi .d1neg
	bvs .vs
	bra .join
.d1neg:
	bvs .join
.vs:
	pla
	inc a
	pha
.join:
	pla
	ldy.b a2
	sta.w tmline,y
.loop:
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
.a1eq:
	ldy.b a2
	bne .a2
	lda.w #$0002
	sta.b d1
	lda.w #.tie
	sta.b a0
	lda.w #.tie>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0002
	bne .gspne
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .gspne
	php
	lda.w #.ahead
	sta.b a0
	plp
	bpl .gspne
	lda.w #.behind
	sta.b a0
.gspne:
	ldy.b a1
	lda.w tmline,y
	asl a
	sta.b d1
	tay
	lda.b [a0],y
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0C01
	bcc .a2
	ldy.b d1
	lda.b [a0],y
	ldy.b a2
	sta.w tmline,y
	bra .loop
.tie:		;CompLine tables: next line by tmline, score tied (7 words)
	dw 0,1,2,0,1,0,1
.ahead:		;ahead in the third period
	dw 2,0,1,2,0,2,0
.behind:		;behind in the third period
	dw 0,1,0,0,1,0,1
.a2:
	lda.w #$0002
	sta.b d1
	lda.w #.tie2
	sta.b a0
	lda.w #.tie2>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0002
	bne .loop2
	ldy.b a2
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .loop2
	php
	lda.w #.ahead2
	sta.b a0
	plp
	bpl .loop2
	lda.w #.behind2
	sta.b a0
.loop2:
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0F34
	bcs .d0ge
	dec.b d1
	bpl .loop2
.d0ge:
	dec.b a0
	dec.b a0
	ldy.b a2
	lda.b [a0]
	sta.w tmline,y
	jmp.w .loop
.tie2:		;the lines tried on a power play / penalty kill (3 words each)
	dw 0,1,2
.ahead2:
	dw 0,2,1
.behind2:
	dw 0,1,0

org $8FF4D8
UnpackNibbles:		;a0 = packed data, d0 = count. Unpacks d0 4-bit values (high nibble first) into words at nibblebuffer. Called from UpdateTeamNameisplay
		;   SNES: d0 nibbles at [a0], high nibble first, to words at nibblebuffer; saves d0-d2, a0-a1
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
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.w #nibblebuffer
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b d2
	bra .join
.loop:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d1
	inc.b d2
	lda.b d2
	lsr a
	bcc .d2lt
	dec.b a0
	lda.b d1
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
.d2lt:
	lda.b d1
	and.w #$000F
	sta.b [a1]
	inc.b a1
	inc.b a1
.join:
	dec.b d0
	bpl .loop
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
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl

org $8FF603
Findhittype:		;look for type of swing (forhand or backhand)
		;   SNES: swing type of player X for launch direction d0: A = 0 forehand (Z set), 1 backhand; .xflip when attribute bit $800 (x
		;   flip)
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .noattribute
	phx
	ldx.b d0
	lda.l .xflip,x		; x flip: backhand for d0 4-7
	plx
	and.w #$00FF
	rtl
.noattribute:
	phx
	ldx.b d0
	lda.l .noflip,x		; backhand for d0 1-4
	plx
	and.w #$00FF
	rtl
.xflip:		;x flip: 1 = backhand for d0 4-7 (%11110000); its last 5 bytes start .noflip
	db $00,$00,$00
.noflip:		;1 = backhand for d0 1-4
	db $00,$01,$01,$01,$01,$00,$00,$00

org $8FF8C4
passtoa0:		;pass puck to player a0
		;   SNES: pass the puck from player a3 to player a0 (no pass count on the SNES): lead him by his velocity, solve the travel time d2
		;   (sroot, divs16; 1-$18), then puckvz, the puck temp1/nopuck, the target temp3/temp4, puckvx/puckvy
	jsl.l loadTeamStruct
	lda.b a0
	lsr a
	sta.w passReceiverPlayerNum
	lda.w passspeed
	lsr a
	lsr a
	bit.w #$2000
	beq .zero
	ora.w #$C000
.zero:
	sta.b d5
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
.skip:
	lda.w #$0013
	sta.b d0
	jsl.l assinsert
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	tya
	jsl.l GetHot
	ldy.b a0
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	pha
	lsr a
	lsr a
	bit.w #$2000
	beq .zero2
	ora.w #$C000
.zero2:
	sta.b d3
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	pha
	lsr a
	lsr a
	bit.w #$2000
	beq .zero3
	ora.w #$C000
.zero3:
	sta.b d2
	lda.w Yvel,y
	sta.b mulb
	lda.w #$00F0
	sta.b mula
	jsl.l muls32
	lda.b mulres+2
	sta.b d1
	pha
	lda.w Xvel,y
	sta.b mulb
	lda.w #$00F0
	sta.b mula
	jsl.l muls32
	lda.b mulres+2
	sta.b d0
	pha
	sta.b mulb
	lda.b d2
	sta.b mula
	jsl.l muls16
	sta.b d0
	lda.b d3
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls16
	adc.b d0
	asl a
	sta.b d4
	lda.b $01,s
	sta.b mula
	sta.b mulb
	jsl.l muls16
	sta.b d0
	lda.b $03,s
	sta.b mula
	sta.b mulb
	jsl.l muls16
	sta.b d1
	lda.b d5
	sta.b mula
	eor.w #$FFFF
	inc a
	sta.b mulb
	jsl.l muls16
	adc.b d0
	clc
	adc.b d1
	sta.b d5
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls16
	sta.b d2
	lda.b d3
	sta.b mula
	sta.b mulb
	jsl.l muls16
	adc.b d2
	sta.b mulb
	lda.b d5
	sta.b mula
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	asl.b d3
	rol.b d3+2
	asl.b d3
	rol.b d3+2
	lda.b d4
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b d3
	sta.b d0
	lda.b mulres+2
	sbc.b d3+2
	sta.b d0+2
	jsl.l sroot
	lda.w #$0001
	sta.b d3
	lda.b d5
	lsr a
	lsr a
	bit.w #$2000
	beq .zero4
	ora.w #$C000
.zero4:
	sta.b d5
	lda.b d5
	bne .loop
	lda.w #$0001
	sta.b d5
.loop:
	lda.b d0
	sta.b d2
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d2
	sec
	sbc.b d4
	sta.b mulb
	lda.b d5
	sta.b mula
	jsl.l divs16
	sta.b d2
	bpl .pos
	dec.b d3
	bpl .loop
.pos:
	bne .nonzero
	inc.b d2
.nonzero:
	lda.b d2
	cmp.w #$0019
	bcc .d2lt
	lda.w #$0018
	sta.b d2
.d2lt:
	lda.b d2
	sep #$20
	sta.w puckvz+1
	rep #$30
	cmp.w #$000C
	bcc .lt
	sep #$20
	lda.b #$0C
	sta.w puckvz+1
	rep #$30
.lt:
	ldy.b a0
	lda.b d2
	asl a
	asl a
	asl a
	sec
	sbc.w #$000A
	sta.w temp1,y
	sec
	sbc.w #$0006
	sta.w nopuck+puckobj
	pla
	sta.b d0
	sta.b mulb
	pla
	sta.b d1
	lda.b d2
	sta.b mula
	jsl.l muls32
	lda.b mulres+2
	lsr a
	lda.b mulres
	ror a
	sta.b d0
	lda.b mulres+2
	pha
	asl a
	pla
	ror a
	sta.b d0+2
	pla
	clc
	adc.b d0
	sta.b d0
	clc
	adc.w puckx
	ldy.b a0
	sta.w temp3,y
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b mulres+2
	lsr a
	lda.b mulres
	ror a
	sta.b d1
	lda.b mulres+2
	pha
	asl a
	pla
	ror a
	sta.b d1+2
	pla
	clc
	adc.b d1
	sta.b d1
	clc
	adc.w pucky
	ldy.b a0
	sta.w temp4,y
	lda.w #$0078
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l mulu16
	sta.b d2
	sta.b mula
	lda.b d0
	sta.b mulb+2
	lda.b d0+2
	sta.b mulb
	jsl.l divs
	sta.b d0
	sta.w puckvx
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb+2
	lda.b d1+2
	sta.b mulb
	jsl.l divs
	sta.b d1
	sta.w puckvy
	rtl

org $8FFB5B
Acheck:		;start hold (or hook if a0 is ahead, $CB0) on player a0. Also entered
		;   SNES: player X holds a0: pfalock, SPAhook, or SPAHold when he has impact and a0 is not ahead. SNES: with pfgoal clear the bmi tests the pfgoal load, so
		;   always SPAHold then
	ldy.b a0
	lda.w #SPAhook
	sta.b d1
	sta.w pfalock,x
	lda.w impact,x
	beq .goSetSPA
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d0
	lda.w pfgoal,x
	beq .nopfgoal
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.nopfgoal:
	bmi .goSetSPA
	lda.w #SPAHold
	sta.b d1
.goSetSPA:
	jml.l SetSPA

org $8FFBDC
doplayeracc:		;player a3 gets acc. in d0 dir
		;   SNES: player X skates in direction d0 (0-7; 8 glides, 9 stops when moving); goalies use goalieacc. Sets pfrev to skate backwards in his own
		;   zone, turns facedir/facefrac toward d0 (.ftab * d7, slower when fast), SPAturnl/SPAturnr or SPAglide/SPAglideback; revplayeracc when moving
	lda.w position,x
	bne .position
	jml.l goalieacc
.position:
	lda.w #SPAglide
	sta.b d1
	lda.w pfrev,x
	beq .d0
	lda.w #SPAglideback
	sta.b d1
.d0:
	lda.b d0
	and.w #$000F
	sta.b d0
	cmp.w #$0008
	bcc .d1
	cmp.w #$0009
	bne .cgl
	lda.w Xvel,x
	ora.w Yvel,x
	beq .cgl
	jml.l dostop
.cgl:		;no turn animation playing (pf2aip): SetSPA
	lda.w pf2aip,x
	bne .rtl
	jml.l SetSPA
.rtl:
	rtl
.d1:		;a direction: pfrev, then the turn
	lda.b d1
	pha
	lda.b d0
	pha
	sta.b d2
	txa
	lsr a
	cmp.w puckc
	bne .ne
	jmp.w .clrrev
.ne:
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Ypos,x
	sta.b d3
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0100
	beq .zero
	ora.w #$FE00
.zero:
	clc
	adc.w pucky
	sec
	sbc.b d3
	sta.b d1
	lda.w pfgoal,x
	bne .c1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
	lda.b d2
	eor.w #$0004
	sta.b d2
.c1:
	lda.w pfrev,x
	bne .inrev
	lda.b d3
	bpl .clrrev
	lda.b d2
	cmp.w #$0004
	bne .clrrev
	jsl.l vtoa
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .clrrev
	bra .rev
.inrev:
	lda.b d2
	sec
	sbc.w #$0003
	and.w #$0007
	cmp.w #$0003
	bcs .clrrev
	jsl.l vtoa
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcs .clrrev
.rev:
	lda.w pfrev,x
	bne .done
	lda.w Xvel,x
	sta.b d0
	ora.w Yvel,x
	beq .setrev
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa
	sec
	sbc.b $01,s
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .done
.setrev:
	inc a
	sta.w pfrev,x
	bra .done
.clrrev:		;.fwd / .clrrev
	stz.w pfrev,x
.done:		;turn rate = .ftab (direction difference) * d7; 0: noturn0
	pla
	sta.b d0
	pla
	sta.b d1
	lda.w facedir,x
	sta.b d2
	lda.b d0
	sec
	sbc.b d2
	and.w #$0007
	asl a
	sta.b d0
	tax
	lda.l .ftab,x
	ldx.b a3
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	sta.b tmp0
	lda.b tmp0
	bne .tmp0
	jml.l noturn0
.tmp0:
	lda.w Xvel,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.w Yvel,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d4
	lda.b mulres+2
	adc.b d4+2
	sta.b d3
	lda.w #$0300
	sec
	sbc.b d3
	sta.b d4
	sec
	sbc.w #$0180
	bmi .neg
	bvs .vs
	bra .iok
.neg:
	bvs .iok
.vs:
	lda.w #$0180
	sta.b d4
.iok:
	lda.b tmp0
	sta.b mula
	lda.b d4
	sta.b mulb
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.w pfrev,x
	beq .i0
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
	lda.w #$0000
	sbc.b d4+2
	sta.b d4+2
.i0:		;facedir.l + d4
	lda.w facefrac,x
	clc
	adc.b d4
	sta.w facefrac,x
	lda.w facedir,x
	adc.b d4+2
	and.w #$0007
	sta.w facedir,x
	sta.b d2
	lda.b d3
	cmp.w #$0015
	bcc .s3
	stz.b d1
	lda.b tmp0
	bpl .s1
	lda.w #SPAturnl-SPAturnr
	sta.b d1
.s1:
	lda.w attribute,x
	bit.w #$0800
	beq .s2
	lda.b d1
	eor.w #SPAturnl-SPAturnr
	sta.b d1
.s2:		;SPAturnr (or SPAturnl), pf2aip
	lda.b d1
	clc
	adc.w #SPAturnr
	sta.b d1
	sta.w pf2aip,x
.s3:
	jsl.l SetSPA
	lda.b d3
	cmp.w #$0003
	bcc .rtl2
	jml.l revplayeracc
.rtl2:
	rtl
.ftab:		;turn rate by the direction difference (93 $10)
	dw 0,23,23,23,0,-23,-23,-23
ResetAndSelectPlayers:		;93 split from 92 puckfaceoff2: c1playernum/c2playernum = -1, then changeplayer for each human team. Called from puckfaceoff2
		;   SNES: c1playernum/c2playernum = -1, then changeplayer for each human team (d4 = 0, 2)
	lda.w #$FFFF
	sta.w c1playernum
	sta.w c2playernum
	lda.w cont1team
	beq .nocont1team
	stz.b d4
	jsl.l changeplayer
.nocont1team:
	lda.w cont2team
	beq .rtl
	lda.w #$0002
	sta.b d4
	jsl.l changeplayer
.rtl:
	rtl
