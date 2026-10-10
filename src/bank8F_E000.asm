; $8FE00A-$8FEE82  ROM $7E00A-$7EE82: SetupTeamForIntermission, ClearSprites, RemapTiles, playeracc (logic93_5), ClearPenaltyBuffer, randomd0s,
; DefaultMenus, checkagr, WeightedRandomSelect, forceblack, passmode/dopass, FrameSetTable, CompLine, TeamRoster, addframe, Pmenu with the
; pause menu lists, GetPadTeam, setpde. Ends before setoptions (boundaries moved from $8FE00E / $8FF002).
org $8FE00A
SetupTeamForIntermission:		;93G SetupTeamForIntermission: ResetBench; both teams re-energized, line 0 (3/5 when a team is a man short or up)
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
	bne .rtl
	lda.w tmap,x
	sec
	sbc.w tmap,y
	sta.b d0
	beq .rtl
	lda.w #$0003
	sta.w tmline,x
	lda.b d0
	bpl .rtl
	lda.w #$0005
	sta.w tmline,x
.rtl:
	rtl
ClearSprites:		;SNES: all 128 OAM entries off screen (y $E0), the high table clear; new sprite frame (sprclock), VRAM slot rotors restart
	clc
	ldx.w #$0000
	ldy.w #$0008
.loop:
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
	bne .loop
.loop2:
	stz.w Satt,x
	inx
	inx
	cpx.w #$0220
	bne .loop2
	stz.b sprcount
	inc.b sprclock
	lda.b sprnodraw
	beq .nosprnodraw
	stz.b sprnodraw
	lda.b sprslotlife
	cmp.w #$0003
	bcc .nosprnodraw
	dec.b sprslotlife
.nosprnodraw:
	lda.b sprbigslot
	sta.b sprbigslotend
	lda.b sprslot
	sta.b sprslotend
	rtl
RemapTiles:		;SNES: d0 4bpp tiles at [a0] to vram with each pixel value remapped through the 16-byte table [a1]
	lda.w #$000E
	sta.b tmp2+1
.loop:
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
.loop2:
	ldy.b #$00
	asl.b tmp1+1
	bcc .lt
	ldy.b #$08
.lt:
	asl.b tmp1
	bcc .lt2
	iny
	iny
	iny
	iny
.lt2:
	asl.b tmp0+1
	bcc .lt3
	iny
	iny
.lt3:
	asl.b tmp0
	bcc .lt4
	iny
.lt4:
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
	bpl .loop2
	dec.b tmp2+1
	dec.b tmp2+1
	bpl .loop
	rep #$30
	ldx.w #$0000
.loop3:
	lda.b mula,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0020
	bne .loop3
	lda.b a0
	clc
	adc.w #$0020
	sta.b a0
	dec.b d0
	bne RemapTiles
	rtl
PixelRemap8F:		;SNES: 4bpp pixel value remap for RemapTiles: colour 1 stays, the rest 0
	db $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
playeracc:		;93G playeracc (logic93_5): accelerate player X in direction d2 (dirtab8F, Wallsin/Wallcos, weight and legstr), cap at MaxSpeed; energy use
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
dirtab8F:		;93G dirtab: x, y acceleration per direction 0-7 (playeracc)
	dw 0,800
	dw 565,565
	dw 800,0
	dw 565,-565
	dw 0,-800
	dw -565,-565
	dw -800,0
	dw -565,565
ClearPenaltyBuffer:		;93G ClearPenaltyBuffer: clear the 32 words of the penalty list (PenBuf)
	lda.w #$001F
	sta.b d0
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.loop:
	lda.w #$0000
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .loop
	rtl
randomd0sd0:		;93G randomd0s with the range in d0: d0 = random -d0..+d0 (randomd0s in bank $80 takes A)
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
DefaultMenus:		;93G DefaultMenus: the 7 options at $1600 from .tab; notdemo set
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
.loop:
	lda.b [a1]
	inc.b a1
	inc.b a1
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .loop
	rtl
.tab:		;93G DefaultMenus .tab: OptPlayMode, OptPlayers, OptTeam1, OptTeam2, OptPerlen, OptPen, OptLine
	dw $0000,$0001,$000F,$0003,$0001,$0000,$0001
checkagr:		;93G checkagr: d0 = random value by the GGSleft rating of player X (x2 joystick controlled, /2 near the puck): small values call a penalty
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
	beq .nopflags
	asl.b d0
.nopflags:
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .zero
	eor.w #$FFFF
	inc a
.zero:
	cmp.w #$0029
	bcs .gorandomd0
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .zero2
	eor.w #$FFFF
	inc a
.zero2:
	cmp.w #$0029
	bcs .gorandomd0
	lsr.b d0
.gorandomd0:
	jml.l randomd0
WeightedRandomSelect:		;93G WeightedRandomSelect: d0 = random index 0..d0-1 weighted by the words in nibblebuffer
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
forceblack:		;93G forceblack role: the default vblank/IRQ handlers, the sprite VRAM caches reset, wait a frame, empty DMAList
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
.loop:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .loop
	ldx.w #$0000
.loop2:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .loop2
	pla
.loop3:
	cmp.b vcount
	beq .loop3
	stz.b DMAListend
	plx
	rtl
passmode:		;93G passmode: B held: a dpad direction sets passdir (d0 | 8) before dopass
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
dopass:		;93G dopass: pass the puck: the team mate nearest the passdir lane (or passdir), puck velocity, SPA, pfalock
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
CompLine:		;93G CompLine: the computer team picks a line by the man advantage, the score late in the game and the line energies (getlinee)
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
.tie:		;93G CompLine tables: next line by tmline, score tied (7 words)
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
TeamRoster:		;SNES Team Roster screen: the team block, each line's players and an attribute; dpad moves, Y switches team, Start leaves
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
.loop:
	lda.l FramerTiles,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0080
	bne .loop
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
.loop2:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .loop2
	lda.w #EASNMap
	sta.b tmp0
	lda.w #EASNMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.loop3:
	lda.l TestList+$400,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$04A0
	bne .loop3
	ldx.w #$03FE
.loop4:
	lda.l TestList,x
	clc
	adc.w ExtraChars
	clc
	adc.w charofs2
	sta.l backmap,x
	sta.l backmap+$400,x
	dex
	dex
	bpl .loop4
	lda.w #RonBarrMap
	sta.b tmp0
	lda.w #RonBarrMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.loop5:
	lda.l TestList+$90,x
	sta.w CGDATA
	inx
	cpx.w #$0080
	bne .loop5
	rep #$30
	stz.b a2
	lda.w cont1team
	sta.b tmp0
	lda.w sflags
	bit.w #$0002
	beq .nosflags
	lda.w cont2team
	sta.b tmp0
.nosflags:
	lda.b tmp0
	cmp.w #$0002
	bne .tmp0ne
	lda.w #$0002
	sta.b a2
.tmp0ne:
	ldy.b a2
	lda.w tmline,y
	inc a
	sta.b d0
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
.loop6:
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
.loop7:
	sta.l textmap,x
	dex
	dex
	bpl .loop7
	jsl.l printbigz
	dw $0014		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$04,"Team  Roster",$BF,$0B,$01
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .noa2
	lda.w VisTeam
	sta.b d1
	lda.w #$0030
.noa2:
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
.loop8:
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
.loop9:
	cmp.b vbint
	beq .loop9
	jsl.l ReadPads
	jsl.l getpzjoy
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	beq .nod1
	jmp.w .rtl
.nod1:
	bit.w #$4000
	bne .nonzero3
	stz.b d0
	inc.b d0
	bit.w #$0100
	bne .nonzero2
	dec.b d0
	dec.b d0
	bit.w #$0200
	bne .nonzero2
	bit.w #$0800
	bne .nonzero
	inc.b d0
	inc.b d0
	bit.w #$0400
	beq .loop10
.nonzero:
	lda.b d0
	clc
	adc.w SelectedPlayerIdx
	sta.b d0
	bmi .loop10
	cmp.w #$0008
	bcs .loop10
	sta.w SelectedPlayerIdx
	jsl.l .show
.loop10:
	jmp.w .loop8
.nonzero2:
	lda.b d0
	clc
	adc.w DispAttribCtr
	sta.b d0
	bmi .loop10
	sta.w DispAttribCtr
	jsl.l .show
	bra .loop10
.nonzero3:
	lda.b a2
	eor.w #$0002
	sta.b a2
	jmp.w .loop6
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
.loop11:
	lda.w #AttribMenuSkater
	sta.b a1
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w DispAttribCtr
	sta.b d0
	lda.w SelectedPlayerIdx
	bne .SelectedPlayerIdx
	lda.w #AttribMenuGoalie
	sta.b a1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	bra .SelectedPlayerIdx
.loop12:
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.SelectedPlayerIdx:
	lda.b [a1]
	bmi .neg
	dec.b d0
	bpl .loop12
.neg:
	lda.b [a1]
	bpl .pos
	dec.w DispAttribCtr
	bra .loop11
.pos:
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
	bmi .loop13
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
	beq .loop13
	bmi .neg2
	bvc .vc
	bra .loop13
.neg2:
	bvc .loop13
.vc:
	dec.b d1
.loop13:
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
	bpl .loop13
.rtl:
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
addframe:		;93G addframe: sprite frame sprframe at sprx/spry: find its frame set in FrameSetTable (sprsetofs), then DrawFrame; frames $293 and up are drawn by addframe_hi
	lda.b sprframe
	cmp.w #$0293
	bcc .sprframelt
	jml.l addframe_end
.sprframelt:
	dec.b sprframe
	bpl .sprframepos
	jml.l addframe_end
.sprframepos:
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.loop:
	lda.l FrameSetTable,x
	beq .loop
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .sprframege
	jml.l DrawFrame
.sprframege:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .loop
Pmenu:		;92G Pausemode .Pmenu: the 5 pause menu items (.mlist, game-over list when gsp = 4), item psitem highlighted
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
	bne .loop
	lda.w #.mlist2
	sta.b a0
.loop:
	lda.w #$2400
	sta.w printa
	lda.b d0
	cmp.w psitem
	bne .d0ne
	lda.w #$2000
	sta.w printa
.d0ne:
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
.loop2:
	lda.b [a0],y
	sta.b [a1],y
	dey
	dey
	bpl .loop2
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
	bne .loop
	rtl
.goalie:		;item 3: append the name of the goalie on the ice (or NONE)
	lda.b d0
	cmp.w #$0003
	beq .d0eq
	jmp.w .rtl
.d0eq:
	jsl.l GetPadTeam
	ldy.b a2
	lda.w tmgoalie,y
	bmi .tmgoalieneg
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
.loop3:
	dec.b tmp0
	bmi .tmp0neg
	lda.b [a4]
	clc
	adc.b a4
	adc.w #$0008
	sta.b a4
	bra .loop3
.tmp0neg:
	ldy.w #$0001
.loop4:
	iny
	lda.b [a4],y
	and.w #$00FF
	cmp.w #$0020
	bne .loop4
.loop5:
	iny
	tya
	cmp.b [a4]
	beq .rtl
	lda.b [a4],y
	phy
	ldy.w mesarea
	sta.w mesarea,y
	inc.w mesarea
	ply
	bra .loop5
.rtl:
	rtl
.tmgoalieneg:
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
GetPadTeam:		;SNES: a2 = team of the controller that paused (cont1team/cont2team by sfpj)
	stz.b a2
	lda.w cont1team
	beq .rtl
	lda.w sflags
	bit.w #$0002
	beq .nosflags
	lda.w cont2team
	bra .join
.nosflags:
	lda.w cont1team
.join:
	cmp.w #$0001
	beq .rtl
	inc.b a2
	inc.b a2
.rtl:
	rtl
setpde:		;93G setpde: tmpde of player d1 (team a2) = d0 (not below 0)
	lda.b a2
	beq .noa2
	lda.w #$0034
.noa2:
	clc
	adc.b d1
	tay
	lda.b d0
	bpl .d0pos
	lda.w #$0000
	sta.b d0
.d0pos:
	sta.w tmpde,y
	rtl
