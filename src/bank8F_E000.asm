; $8FE00A-$8FEE82  ROM $7E00A-$7EE82: SetupTeamForIntermission, ClearSprites, RemapTiles, playeracc (logic93_5), ClearPenaltyBuffer, randomd0s,
; DefaultMenus, checkagr, WeightedRandomSelect, forceblack, passmode/dopass, FrameSetTable, CompLine, TeamRoster, addframe, Pmenu with the
; pause menu lists, GetPadTeam, setpde. Ends before setoptions (boundaries moved from $8FE00E / $8FF002).
org $8FE00A
SetupTeamForIntermission:		;auto: CODE_8FE00A (from Intermission). 93G SetupTeamForIntermission: ResetBench; both teams re-energized, line 0 (3/5 when a team is a man short or up)
	jsl.l ResetBench
	stz.b a2
	lda.w #$0002
	sta.b a3
	jsl.l .team
	stz.b a3
	lda.w #$0002
	sta.b a2
.team:		;team a2 (a3 = the other)
	jsl.l reenergizeteam
	ldx.b a3
	ldy.b a2
	stz.w tmline,x
	lda.w OptLine
	bne .l1
	lda.w tmap,x
	sec
	sbc.w tmap,y
	sta.b d0
	beq .l1
	lda.w #$0003
	sta.w tmline,x
	lda.b d0
	bpl .l1
	lda.w #$0005
	sta.w tmline,x
.l1:
	rtl
ClearSprites:		;auto: CODE_8FE04C. SNES: all 128 OAM entries off screen (y $E0), the high table clear; new sprite frame (sprclock), VRAM slot rotors restart
	clc
	ldx.w #$0000
	ldy.w #$0008
.l1:
	lda.w #$E0E0
	sta.w Satt,x
	stz.w Satt+2,x
	sta.w Satt+$4,x
	stz.w Satt+$6,x
	sta.w Satt+$8,x
	stz.w Satt+$A,x
	sta.w Satt+$C,x
	stz.w Satt+$E,x
	sta.w Satt+$10,x
	stz.w Satt+$12,x
	sta.w Satt+$14,x
	stz.w Satt+$16,x
	sta.w Satt+$18,x
	stz.w Satt+$1A,x
	sta.w Satt+$1C,x
	stz.w Satt+$1E,x
	sta.w Satt+$20,x
	stz.w Satt+$22,x
	sta.w Satt+$24,x
	stz.w Satt+$26,x
	sta.w Satt+$28,x
	stz.w Satt+$2A,x
	sta.w Satt+$2C,x
	stz.w Satt+$2E,x
	sta.w Satt+$30,x
	stz.w Satt+$32,x
	sta.w Satt+$34,x
	stz.w Satt+$36,x
	sta.w Satt+$38,x
	stz.w Satt+$3A,x
	sta.w Satt+$3C,x
	stz.w Satt+$3E,x
	txa
	adc.w #$0040
	tax
	dey
	bne .l1
.l2:
	stz.w Satt,x
	inx
	inx
	cpx.w #$0220
	bne .l2
	stz.b sprcount
	inc.b sprclock
	lda.b sprnodraw
	beq .l3
	stz.b sprnodraw
	lda.b sprslotlife
	cmp.w #$0003
	bcc .l3
	dec.b sprslotlife
.l3:
	lda.b sprbigslot
	sta.b sprbigslotend
	lda.b sprslot
	sta.b sprslotend
	rtl
RemapTiles:		;auto: CODE_8FE0E4. SNES: d0 4bpp tiles at [a0] to vram with each pixel value remapped through the 16-byte table [a1]
	lda.w #$000E
	sta.b tmp2+1
.l1:
	rep #$30
	ldy.b tmp2+1
	lda.b [a0],y
	sta.b tmp0
	tya
	clc
	adc.w #$0010
	tay
	lda.b [a0],y
	sta.b tmp1
	sep #$30
	ldx.b tmp2+1
	lda.b #$07
	sta.b tmp2
.l2:
	ldy.b #$00
	asl.b tmp1+1
	bcc .l3
	ldy.b #$08
.l3:
	asl.b tmp1
	bcc .l4
	iny
	iny
	iny
	iny
.l4:
	asl.b tmp0+1
	bcc .l5
	iny
	iny
.l5:
	asl.b tmp0
	bcc .l6
	iny
.l6:
	lda.b [a1],y
	lsr a
	rol.b mula,x
	lsr a
	rol.b mula+1,x
	lsr a
	rol.b mula+16,x
	lsr a
	rol.b mula+17,x
	dec.b tmp2
	bpl .l2
	dec.b tmp2+1
	dec.b tmp2+1
	bpl .l1
	rep #$30
	ldx.w #$0000
.l7:
	lda.b mula,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0020
	bne .l7
	lda.b a0
	clc
	adc.w #$0020
	sta.b a0
	dec.b d0
	bne RemapTiles
	rtl
PixelRemap8F:		;SNES: 4bpp pixel value remap for RemapTiles: colour 1 stays, the rest 0
	db $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
playeracc:		;auto: CODE_8FE164 (from noturn, fightinput). 93G playeracc (logic93_5): accelerate player X in direction d2 (dirtab8F, Wallsin/Wallcos, weight and legstr), cap at MaxSpeed; energy use
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
	beq .l1
	ora.w #$C000
.l1:
	sta.b d1
	lda.l dirtab8F,x
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	lsr a
	lsr a
	bit.w #$2000
	beq .l2
	ora.w #$C000
.l2:
	sta.b d0
	ldx.b a3
	lda.w Wallsin,x
	beq .l3
	eor.b d0
	bpl .l3
	stz.b d0
.l3:
	lda.w Wallcos,x
	beq .l4
	eor.b d1
	bmi .l4
	stz.b d1
.l4:
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
	bne .l5
	lda.b d2
	clc
	adc.w legstr,x
	clc
	adc.w #$0008
	sta.b d2
.l5:
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
	bcc .l6
	lda.b d0
	sta.w Xvel,x
	lda.b d1
	sta.w Yvel,x
.l6:
	lda.w OptLine
	bne .l10
	lda.w seed
	and.w #$003F
	bne .l10
	jsl.l getpde
	lda.b d0
	sec
	sbc.w #$0021
	sta.b d0
	sec
	sbc.w #$0C00
	bmi .l8
	bvc .l9
.l7:
	jmp.w setpde
.l8:
	bvc .l7
.l9:
	lda.w endurance,x
	sta.b d2
	clc
	adc.b d0
	sta.b d0
	jmp.w setpde
.l10:
	rtl
dirtab8F:		;93G dirtab: x, y acceleration per direction 0-7 (playeracc)
	dw 0,800
	dw 565,565
	dw 800,0
	dw 565,-565
	dw 0,-800
	dw -565,-565
	dw -800,0
	dw -565,565
ClearPenaltyBuffer:		;auto: CODE_8FE2F9. 93G ClearPenaltyBuffer: clear the 32 words of the penalty list (PenBuf)
	lda.w #$001F
	sta.b d0
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.l1:
	lda.w #$0000
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .l1
	rtl
randomd0sd0:		;auto: CODE_8FE316. 93G randomd0s with the range in d0: d0 = random -d0..+d0 (randomd0s in bank $80 takes A)
	lda.b d0
	pha
	asl.b d0
	jsl.l randomd0
	pla
	eor.w #$FFFF
	inc a
	clc
	adc.b d0
	sta.b d0
	clc
	rtl
DefaultMenus:		;auto: CODE_8FE32B (from Start). 93G DefaultMenus: the 7 options at $1600 from .tab; notdemo set
	lda.w #$FFFF
	sta.w notdemo
	lda.w #OptPlayMode
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #.tab
	sta.b a1
	lda.w #.tab>>16
	sta.b a1+2
	lda.w #$0006
	sta.b d0
.l1:
	lda.b [a1]
	inc.b a1
	inc.b a1
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .l1
	rtl
.tab:		;93G DefaultMenus .tab: OptPlayMode, OptPlayers, OptTeam1, OptTeam2, OptPerlen, OptPen, OptLine
	dw $0000,$0001,$000F,$0003,$0001,$0000,$0001
checkagr:		;auto: CODE_8FE369. 93G checkagr: d0 = random value by the GGSleft rating of player X (x2 joystick controlled, /2 near the puck): small values call a penalty
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	asl a
	asl a
	asl a
	asl a
	sta.b d0
	lda.w pflags,x
	bit.w #$0008
	beq .l1
	asl.b d0
.l1:
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .l2
	eor.w #$FFFF
	inc a
.l2:
	cmp.w #$0029
	bcs .l4
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .l3
	eor.w #$FFFF
	inc a
.l3:
	cmp.w #$0029
	bcs .l4
	lsr.b d0
.l4:
	jml.l randomd0
WeightedRandomSelect:		;auto: CODE_8FE3B0. 93G WeightedRandomSelect: d0 = random index 0..d0-1 weighted by the words in nibblebuffer
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
	bra .l2
.l1:
	lda.b d1
	clc
	adc.b [a1]
	sta.b d1
	inc.b a1
	inc.b a1
.l2:
	dec.b d0
	bpl .l1
	lda.b d1
	sta.b d0
	jsl.l randomd0
.l3:
	dec.b a1
	dec.b a1
	lda.b d0
	sec
	sbc.b [a1]
	sta.b d0
	bpl .l3
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
forceblack:		;auto: CODE_8FE404. 93G forceblack role: the default vblank/IRQ handlers, the sprite VRAM caches reset, wait a frame, empty DMAList
	phx
	lda.w #vb2_blank
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	lda.b vcount
	pha
	lda.b sprclock
	sec
	sbc.w #$003C
	ldx.w #$0000
.l1:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .l1
	ldx.w #$0000
.l2:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .l2
	pla
.l3:
	cmp.b vcount
	beq .l3
	stz.b DMAListend
	plx
	rtl
passmode:		;auto: CODE_8FE43C (from joyplayer). 93G passmode: B held: a dpad direction sets passdir (d0 | 8) before dopass
	lda.b d2
	bit.w #$8000
	bne dopass
	lda.b d0
	bit.w #$0008
	bne .l1
	and.w #$0007
	sta.w passdir
	ora.w #$0008
	sta.b d0
	bra dopass
.l1:
	rtl
dopass:		;auto: CODE_8FE458. 93G dopass: pass the puck: the team mate nearest the passdir lane (or passdir), puck velocity, SPA, pfalock
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .l2
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
	beq .l3
	lda.w passacc,x
	sta.b d0
.l3:
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
	bcc .l4
	lda.w #$000C
	sta.b a1
.l4:
	cpx.b a1
	bne .l5
	jmp.w .l9
.l5:
	ldy.b a1
	lda.w position,y
	bne .l6
	jmp.w .l9
.l6:
	lda.w pflags,y
	bit.w #$1000
	beq .l7
	jmp.w .l9
.l7:
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
	beq .l8
	ora.w #$FF00
.l8:
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
	bcs .l9
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
	bcc .l9
	lda.b d2
	sta.b d4
	lda.b d2+2
	sta.b d4+2
	lda.b a1
	sta.b a0
.l9:
	inc.b a1
	inc.b a1
	dec.b d3
	bmi .l10
	jmp.w .l4
.l10:
	lda.b d4+2
	bmi .l11
	jsl.l passtoa0
	jmp.w .l12
.l11:
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
.l12:
	lda.w position,x
	bne .l15
	lda.w pfgoal,x
	beq .l13
	lda.w puckvy
	bmi .l14
	bra .l15
.l13:
	lda.w puckvy
	bmi .l15
.l14:
	eor.w #$FFFF
	inc a
	sta.w puckvy
.l15:
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	lda.w #$02D2
	sta.b d1
	lda.w position,x
	beq .l16
	lda.w #$06C4
	sta.b d1
	jsl.l Findhittype
	beq .l16
	lda.w #$0736
	sta.b d1
.l16:
	jsl.l SetSPA
	lda.w #$0001
	sta.w pfalock,x
	stx.b xsave
	ldx.w #$0006
.l17:
	pla
	sta.b a0,x
	dex
	dex
	bpl .l17
	ldx.b xsave
	stx.b xsave
	ldx.w #$0016
.l18:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l18
	ldx.b xsave
	rtl
FrameSetTable:		;SNES: long pointers to the 15 sprite frame sets (addframe), then a 0 entry
	dd SpriteSet0
	dd SpriteSet1
	dd SpriteSet2
	dd SpriteSet3
	dd SpriteSet4
	dd SpriteSet5
	dd SpriteSet6
	dd SpriteSet7
	dd SpriteSet8
	dd SpriteSet9
	dd SpriteSet10
	dd SpriteSet11
	dd SpriteSet12
	dd SpriteSet13
	dd SpriteSet14
	dd 0		; end
CompLine:		;auto: CODE_8FE6BD (from setpersonel). 93G CompLine: the computer team picks a line by the man advantage, the score late in the game and the line energies (getlinee)
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .l2
	ldx.b xsave
	lda.w #$0003
	sta.b d0
	ldy.b a2
	lda.w tmap,y
	ldy.b a1
	cmp.w tmap,y
	beq .l10
	bpl .l3
	inc.b d0
	inc.b d0
.l3:
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
	bmi .l4
	bvs .l5
	bra .l6
.l4:
	bvs .l6
.l5:
	pla
	inc a
	pha
.l6:
	pla
	ldy.b a2
	sta.w tmline,y
.l7:
	stx.b xsave
	ldx.w #$0002
.l8:
	pla
	sta.b a0,x
	dex
	dex
	bpl .l8
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.l9:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l9
	ldx.b xsave
	rtl
.l10:
	ldy.b a2
	bne .l12
	lda.w #$0002
	sta.b d1
	lda.w #.tie
	sta.b a0
	lda.w #.tie>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0002
	bne .l11
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .l11
	php
	lda.w #.ahead
	sta.b a0
	plp
	bpl .l11
	lda.w #.behind
	sta.b a0
.l11:
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
	bcc .l12
	ldy.b d1
	lda.b [a0],y
	ldy.b a2
	sta.w tmline,y
	bra .l7
.tie:		;93G CompLine tables: next line by tmline, score tied (7 words)
	dw 0,1,2,0,1,0,1
.ahead:		;ahead in the third period
	dw 2,0,1,2,0,2,0
.behind:		;behind in the third period
	dw 0,1,0,0,1,0,1
.l12:
	lda.w #$0002
	sta.b d1
	lda.w #.tie2
	sta.b a0
	lda.w #.tie2>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0002
	bne .l13
	ldy.b a2
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .l13
	php
	lda.w #.ahead2
	sta.b a0
	plp
	bpl .l13
	lda.w #.behind2
	sta.b a0
.l13:
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0F34
	bcs .l14
	dec.b d1
	bpl .l13
.l14:
	dec.b a0
	dec.b a0
	ldy.b a2
	lda.b [a0]
	sta.w tmline,y
	jmp.w .l7
.tie2:		;the lines tried on a power play / penalty kill (3 words each)
	dw 0,1,2
.ahead2:
	dw 0,2,1
.behind2:
	dw 0,1,0
TeamRoster:		;auto: CODE_8FE825 (pause menu). SNES Team Roster screen: the team block, each line's players and an attribute; dpad moves, Y switches team, Start leaves
	jsl.l forceblack
	sep #$20
	stz.w BG1HOFS
	stz.w BG1HOFS
	stz.w BG1VOFS
	stz.w BG1VOFS
	stz.w BG2HOFS
	stz.w BG2HOFS
	stz.w BG2VOFS
	stz.w BG2VOFS
	lda.b #$00
	sta.w BG1SC
	lda.b #$04
	sta.w BG2SC
	lda.b #$44
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2
	sta.w TM
	rep #$30
	lda.w #$FD00
	sta.w charofs
	sta.w charofs2
	sta.w printfontset
	stz.b printm
	lda.w smallfontchars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	stz.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap8F
	sta.b a1
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles
	ldx.w #$0000
.l1:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .l1
	lda.w scorechars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.l2:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .l2
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.l3:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .l3
	ldx.w #$03FE
.l4:
	lda.l TestList,x
	clc
	adc.w ExtraChars
	clc
	adc.w charofs2
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .l4
	lda.w #RonBarrMap
	sta.b tmp0
	lda.w #RonBarrMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.l5:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .l5
	rep #$30
	stz.b a2
	lda.w cont1team
	sta.b tmp0
	lda.w sflags
	bit.w #$0002
	beq .l6
	lda.w cont2team
	sta.b tmp0
.l6:
	lda.b tmp0
	cmp.w #$0002
	bne .l7
	lda.w #$0002
	sta.b a2
.l7:
	ldy.b a2
	lda.w tmline,y
	inc a
	sta.b d0
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
.l8:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$03,$01
	lda.w #$001A
	sta.b d0
	lda.w #$0006
	sta.b d1
	jsl.l Framer
	lda.w blankchar
	clc
	adc.w charofs
	ldx.w #$07FE
.l9:
	sta.l textmap,x
	dex
	dex
	bpl .l9
	jsl.l printz8B
	dw $0014		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$04,"Team  Roster",$BF,$0B,$01
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .l10
	lda.w VisTeam
	sta.b d1
	lda.w #$0030
.l10:
	sta.b d0
	jsl.l DrawTeamBlocks
	jsl.l printz
	dw $0017		; printz inline string: length (counts itself), then control bytes / text
	db $9F,$08,$0C,"Player",$9F,$18,$0C,"Rating",$BE,$01,$08
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$10,$08
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	jsl.l .show
.l11:
	lda.w #textmap
	sta.w DMAList
	lda.w #textmap>>16
	sta.w DMAList+dmabank
	lda.w #$1000
	sta.w DMAList+dmalen
	stz.w DMAList+dmavram
	lda.w #$0007
	sta.b DMAListend
	lda.w #VBlank_List
	sta.b vbint
.l12:
	cmp.b vbint
	beq .l12
	jsl.l ReadPads
	jsl.l getpzjoy
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	beq .l13
	jmp.w .l26
.l13:
	bit.w #$4000
	bne .l17
	stz.b d0
	inc.b d0
	bit.w #$0100
	bne .l16
	dec.b d0
	dec.b d0
	bit.w #$0200
	bne .l16
	bit.w #$0800
	bne .l14
	inc.b d0
	inc.b d0
	bit.w #$0400
	beq .l15
.l14:
	lda.b d0
	clc
	adc.w SelectedPlayerIdx
	sta.b d0
	bmi .l15
	cmp.w #$0008
	bcs .l15
	sta.w SelectedPlayerIdx
	jsl.l .show
.l15:
	jmp.w .l11
.l16:
	lda.b d0
	clc
	adc.w DispAttribCtr
	sta.b d0
	bmi .l15
	sta.w DispAttribCtr
	jsl.l .show
	bra .l15
.l17:
	lda.b a2
	eor.w #$0002
	sta.b a2
	jmp.w .l8
.show:		;print the selected line and attribute column
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $9F,$02,$09
	lda.w SelectedPlayerIdx
	sta.b d0
	lda.w #RosterLineNames
	sta.b a1
	lda.w #RosterLineNames>>16
	sta.b a1+2
	jsl.l AdvanceStringPtr
	jsl.l print
	lda.w #$0011
	sta.w printx
	lda.w #$0009
	sta.w printy
.l18:
	lda.w #AttribMenuSkater
	sta.b a1
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w DispAttribCtr
	sta.b d0
	lda.w SelectedPlayerIdx
	bne .l20
	lda.w #AttribMenuGoalie
	sta.b a1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	bra .l20
.l19:
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.l20:
	lda.b [a1]
	bmi .l21
	dec.b d0
	bpl .l19
.l21:
	lda.b [a1]
	bpl .l22
	dec.w DispAttribCtr
	bra .l18
.l22:
	jsl.l print
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
	lda.b [a1],y
	sta.b d4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0D
	lda.w #$0020
	sta.b d0
	lda.w #$0013
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jsl.l printz
	dw $0018		; printz inline string: length (counts itself), then control bytes / text
	db $9F,$08,$1A,"Y - Switch Teams",$BF,$00,$0E
	jsl.l GoalieCount
	lda.b d0
	dec a
	sta.b d1
	lda.w #RosterG
	sta.b a4+4
	lda.w #RosterG>>16
	sta.b a4+6
	lda.w #RosterGoalies
	sta.b a3
	lda.w #RosterGoalies>>16
	sta.b a3+2
	lda.w SelectedPlayerIdx
	dec a
	sta.b d0
	bmi .l25
	asl a
	asl a
	asl a
	sta.b d0
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #LineSets
	clc
	adc.b [a3],y
	sec
	adc.b d0
	sta.b a3
	lda.w #PositionNames
	sta.b a4+4
	lda.w #PositionNames>>16
	sta.b a4+6
	lda.w #$0004
	sta.b d1
	lda.w SelectedPlayerIdx
	sec
	sbc.w #$0005
	beq .l25
	bmi .l23
	bvc .l24
	bra .l25
.l23:
	bvc .l25
.l24:
	dec.b d1
.l25:
	lda.w #$0002
	sta.w printx
	lda.b a4+4
	sta.b a1
	lda.b a4+6
	sta.b a1+2
	jsl.l print
	lda.b a1
	sta.b a4+4
	lda.b a1+2
	sta.b a4+6
	lda.w #$0005
	sta.w printx
	lda.b [a3]
	inc.b a3
	and.w #$00FF
	dec a
	sta.b d0
	jsl.l GetNameandAttrib
	inc.w printy
	inc.w printy
	dec.b d1
	bpl .l25
.l26:
	rtl
RosterGoalies:		;SNES: the goalie row numbers of the Team Roster screen
	db 1,2,3,4
RosterG:		;SNES: the "G" position label of the goalie rows
	dw 3
	db "G"
	dw 3
	db "G"
	dw 3
	db "G"
	dw 3
	db "G"
RosterLineNames:		;SNES: the Team Roster line names (15-byte strings)
	dw 15
	db "  Goalies   }"
	dw 15
	db "{Scoring  1 }"
	dw 15
	db "{Scoring  2 }"
	dw 15
	db "{ Checking  }"
	dw 15
	db "{Pwr. Play 1}"
	dw 15
	db "{Pwr. Play 2}"
	dw 15
	db "{Pen. Kill 1}"
	dw 15
	db "{Pen. Kill 2 "
addframe:		;auto: CODE_8FEC68. 93G addframe: sprite frame sprframe at sprx/spry: find its frame set in FrameSetTable (sprsetofs), then DrawFrame; frames $293 and up are drawn by addframe_hi
	lda.b sprframe
	cmp.w #$0293
	bcc .l1
	jml.l addframe_end
.l1:
	dec.b sprframe
	bpl .l2
	jml.l addframe_end
.l2:
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.l3:
	lda.l FrameSetTable,x
	beq .l3
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .l4
	jml.l DrawFrame
.l4:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .l3
Pmenu:		;auto: CODE_8FECAB (from Pausemode, StartHL2). 92G Pausemode .Pmenu: the 5 pause menu items (.mlist, game-over list when gsp = 4), item psitem highlighted
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$06,$0D
	stz.b d0
	lda.w #.mlist
	sta.b a0
	lda.w #.mlist>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0004
	bne .l1
	lda.w #.mlist2
	sta.b a0
.l1:
	lda.w #$2400
	sta.w printa
	lda.b d0
	cmp.w psitem
	bne .l2
	lda.w #$2000
	sta.w printa
.l2:
	lda.w #$0006
	sta.w printx
	jsl.l printz
	dw $0016		; printz inline string: length (counts itself), then control bytes / text
	db "                    "
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	ldy.w #$001E
.l3:
	lda.b [a0],y
	sta.b [a1],y
	dey
	dey
	bpl .l3
	jsl.l .goalie
	lda.b [a1]
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0011
	sta.w printx
	jsl.l print
	inc.w printy
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	inc.b d0
	lda.b d0
	cmp.w #$0005
	bne .l1
	rtl
.goalie:		;item 3: append the name of the goalie on the ice (or NONE)
	lda.b d0
	cmp.w #$0003
	beq .l4
	jmp.w .l9
.l4:
	jsl.l GetPadTeam
	ldy.b a2
	lda.w tmgoalie,y
	bmi .l10
	sta.b tmp0
	lda.w tmdata,y
	sta.b a4
	lda.w #TeamList>>16
	sta.b a4+2
	ldy.w #Playerdata
	lda.b [a4],y
	clc
	adc.b a4
	sta.b a4
.l5:
	dec.b tmp0
	bmi .l6
	lda.b [a4]
	clc
	adc.b a4
	adc.w #$0008
	sta.b a4
	bra .l5
.l6:
	ldy.w #$0001
.l7:
	iny
	lda.b [a4],y
	and.w #$00FF
	cmp.w #$0020
	bne .l7
.l8:
	iny
	tya
	cmp.b [a4]
	beq .l9
	lda.b [a4],y
	phy
	ldy.w mesarea
	sta.w mesarea,y
	inc.w mesarea
	ply
	bra .l8
.l9:
	rtl
.l10:
	ldy.w mesarea
	lda.w #$004E
	sta.w mesarea,y
	lda.w #$004F
	sta.w mesarea+1,y
	lda.w #$004E
	sta.w mesarea+2,y
	lda.w #$0045
	sta.w mesarea+3,y
	inc.w mesarea
	inc.w mesarea
	inc.w mesarea
	inc.w mesarea
	rtl
.mlist:		;92G Pausemode .mlist: the pause menu items
	dw 13
	db "Resume Game"
	dw 16
	db "Instant Replay"
	dw 14
	db "Stats Report"
	dw 11
	db "Goalie - "
	dw 13
	db "Team Roster"
.mlist2:		;SNES: the menu items after the game (Exit Game first)
	dw 11
	db "Exit Game"
	dw 16
	db "Instant Replay"
	dw 14
	db "Stats Report"
	dw 11
	db "Goalie - "
	dw 13
	db "Team Roster"
GetPadTeam:		;auto: CODE_8FEE4A. SNES: a2 = team of the controller that paused (cont1team/cont2team by sfpj)
	stz.b a2
	lda.w cont1team
	beq .l3
	lda.w sflags
	bit.w #$0002
	beq .l1
	lda.w cont2team
	bra .l2
.l1:
	lda.w cont1team
.l2:
	cmp.w #$0001
	beq .l3
	inc.b a2
	inc.b a2
.l3:
	rtl
setpde:		;auto: CODE_8FEE6B. 93G setpde: tmpde of player d1 (team a2) = d0 (not below 0)
	lda.b a2
	beq .l1
	lda.w #$0034
.l1:
	clc
	adc.b d1
	tay
	lda.b d0
	bpl .l2
	lda.w #$0000
	sta.b d0
.l2:
	sta.w tmpde,y
	rtl
