; $8FEE83-$8FFFFF  ROM $7EE83-$7FFFF: setoptions (hockey93_08) with its option strings, PixelRemapFramer/PixelRemapFont, UnpackNibbles,
; PushNumberWidth, StatsReport, Findhittype, prefmes, CheckInjury, setInjuryType, sublist/priolist, ShowInjuryBox, passtoa0,
; GetPlayerCount, GetPlayerNameWithAttrib, Acheck, divs16, doplayeracc, ResetAndSelectPlayers, cd0, MusicCue, sfx8F and the goal box
; (93G DisplayPlayerAttributeMenu) with attrText. The end of the ROM.
org $8FEE83
setoptions:		;options screen display and input. Called from PeriodOver (hockey93_06). (93G hockey93_08)
		;   SNES: the options screen: GameSetupMap backdrop, small font and Framer tiles (remapped), NHLPA logo, team blocks; Up/Down
		;   picks a line (.nms), Left/Right changes it (.IncItem), Start goes to maketree; after $12C0 idle frames a demo with random teams
	lda.w #vb2_blank
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
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
	stz.b DMAListend
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	rep #$30
	lda.b vcount
.loop3:
	cmp.b vcount
	beq .loop3
	jsl.l InitPPU
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	lda.b #$03
	sta.w OBSEL
	lda.b #BGMODE_1
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$04
	sta.w BG2SC
	lda.b #$11
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2|TM_OBJ
	sta.w TM
	rep #$30
	stz.w printfontset
	stz.w charofs
	stz.w charofs2
	lda.w #$0012
	sta.w blankchar
	inc a
	sta.w smallfontchars
	clc
	adc.w #$0064
	sta.w Framercset
	adc.w #$0004
	sta.w logochars
	adc.w #$0035
	sta.w scorechars
	jsl.l DrawGameSetupBack
	lda.w #GameSetupMap
	sta.b tmp0
	lda.w #GameSetupMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.loop4:
	lda.l TestList+$800,x
	sta.l palbuffer,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .loop4
	ldx.w #$0000
.loop5:
	lda.l RinkPalette,x
	sta.l palbuffer+$100,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .loop5
	rep #$30
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.loop6:
	lda.l TestList+$900,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0240
	bne .loop6
	ldx.w #$0010
.loop7:
	stz.w VMDATAL
	dex
	bne .loop7
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	lda.w #unpackbuf&$FFFF
	sta.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemapFont
	sta.b a1
	lda.w #PixelRemapFont>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles
	lda.w #FramerTiles
	sta.b a0
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #PixelRemapFramer
	sta.b a1
	lda.w #PixelRemapFramer>>16
	sta.b a1+2
	lda.w #$0004
	sta.b d0
	jsl.l RemapTiles
	lda.w #NHLPALogo
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.loop8:
	lda.l TestList+$1A0,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06A0
	bne .loop8
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.loop9:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .loop9
	jsl.l ReadPads
	jsl.l Readjoy12
	lda.w #$0000
	sta.b sprpriority
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FE,$00,$00
	jsl.l InitSortObjects
	lda.w #$0028
	sta.w OldXpos
	sta.w OldXpos+$C
	lda.w #.text
	sta.b a1
	lda.w #.text>>16
	sta.b a1+2
.textlp:		;93G .textlp: print the .text lines until a 0 byte
	jsl.l print
	ldy.w #$0002
	lda.b [a1],y
	and.w #$00FF
	bne .textlp
	lda.w #$FFFF
	sta.w notdemo
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .OptPlayModelt
	jsl.l NewPO
.OptPlayModelt:
	stz.b d7
	stz.b d0
	jsl.l .nms
	jsl.l .ps
	jsl.l ReadPads
	jsl.l StartSong6
	lda.w #$0001
	sta.b fadein
.idle:		;restart the idle count (d6 = $12C0 frames until the demo)
	lda.w #$12C0
	sta.b d6
.frame:		;one frame: seed counts up while waiting for VBlank_SprPal to run
	inc.w seed
	bne .seed
	inc.w seed+2
.seed:
	lda.b vbint
	cmp.w #VBlank_SprPal		; VBlank_SprPal not run yet?
	beq .frame
	jsl.l ReadPads
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	jsl.l ClearSprites
	jsl.l ScoutPlayersRun
	jsl.l Readjoy1
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bne .input
	jsl.l Readjoy2
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bne .input
	jsl.l QueueTextDMA
	lda.b DMAListend
	bne .DMAListend
	jsl.l QueueBackmapDMA
.DMAListend:
	lda.w #VBlank_SprPal
	sta.b vbint
	dec.b d6
	bpl .frame
	lda.w #$001A		; demo: random teams, both computer
	jsl.l randoma
	sta.w OptTeam1
	sta.w HomeTeam
.loop10:
	lda.w #$001A
	jsl.l randoma
	cmp.w OptTeam1
	beq .loop10
	sta.w OptTeam2
	sta.w VisTeam
	stz.w notdemo
	stz.w OptPlayMode
	stz.w OptPlayers
.start:		;Start, or the demo: pojoy from OptPlayers, the password in Cont. Playoffs, then maketree
	lda.w OptPlayers
	sec
	sbc.w #$0005
	sta.w pojoy
	lda.w OptPlayMode
	cmp.w #$0001
	bne .OptPlayModene
	jsl.l GetPassWord
.OptPlayModene:
	lda.w #$0080
	tsb.w PassWord
	jml.l maketree
.input:		;a pad pressed (d1): Start, Up/Down (.nms by 2), Left/Right (.IncItem by 1)
	lda.b d1
	bit.w #$1000
	bne .start
	bit.w #$0400
	beq .zero
	lda.w #$0002
	sta.b d0
	jsl.l .nms
	jsl.l .ps
	jmp.w .idle
.zero:
	bit.w #$0800
	beq .zero2
	lda.w #$FFFE
	sta.b d0
	jsl.l .nms
	jsl.l .ps
.loop11:
	jmp.w .idle
.zero2:
	lda.w #$0001
	sta.b d2
	lda.b d1
	bit.w #$0100
	bne .d1
	bit.w #$0200
	beq .loop11
	lda.w #$FFFF
	sta.b d2
.d1:
	jsl.l .IncItem
	jsl.l .ps
	jmp.w .idle
.IncItem:		;93G .IncItem: add d2 to option d7 (OptPlayMode + d7) within .pslim (d2 = 0: just limit it). Players is fixed to One outside Regular Season; Team 1 has $18 choices in the playoffs; a new
		;   mode or Team 1 in the playoffs restarts them (NewPO)
	lda.w #OptPlayMode
	sta.b a2
	lda.w #$0000
	sta.b a2+2
	lda.w #.pslim
	sta.b a3
	lda.w #.pslim>>16
	sta.b a3+2
	stz.b d5
	ldy.b d7
	lda.b [a3],y
	sta.b d4
	lda.b [a2],y
	sta.b d3
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .OptPlayModelt2
	cpy.w #$0004
	bne .OptPlayModelt2
	lda.w #$0018
	sta.b d4
.OptPlayModelt2:
	cpy.w #$0002
	bne .ne
	lda.w #$0005
	sta.b d5
	lda.w OptPlayMode
	bne .ne
	stz.b d5
	lda.w #$0005
	sta.b d4
.ne:
	jsl.l .iilimit		; d3 = the new value
	lda.b d3
	sta.b [a2],y
	lda.b d2
	beq .rts
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .rts
	tya
	bne .nonzero
	jml.l NewPO
.nonzero:
	cpy.w #$0004
	bne .rts
	jml.l NewPO
.rts:
	rtl
.iilimit:		;93G .iilimit: d3 + d2, wrapped into d5 ... d4-1
	lda.b d3
	clc
	adc.b d2
	sta.b d3
	sec
	sbc.b d5
	bmi .neg
	bvs .vs
	bra .join
.neg:
	bvs .join
.vs:
	lda.b d4
	dec a
	sta.b d3
.join:
	lda.b d3
	sec
	sbc.b d4
	bmi .d3neg
	bvc .vc
	bra .rts
.d3neg:
	bvc .rts
.vc:
	lda.b d5
	sta.b d3
	rtl
.ps:		;93G .ps: print the choices of all 7 lines (.psd), then PrintTeamNames
	lda.b d7
	sta.b d6
	lda.w #$FFFE
	sta.b d7
.psloop:
	inc.b d7
	inc.b d7
	stz.b d2
	jsl.l .IncItem
	jsl.l .psd
	lda.b d7
	cmp.w #$000C
	bne .psloop
	lda.b d6
	sta.b d7
	jml.l PrintTeamNames
.psd:		;93G .psd: print the choice of line d7 at x $11 (14 chars erased first): string d3 of its .pl list; the team lines print the team name (.psdtp)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$11,$0D
	lda.w printy
	clc
	adc.b d7
	sta.w printy
	lda.w #$000E
	sta.b d0
	lda.w #$0001
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	dec.w printy
	lda.w #$0011
	sta.w printx
	ldy.b d7
	cpy.w #$0004
	beq .psdtp
	cpy.w #$0006
	beq .psdtp
	lda.w #OptPlayMode
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.b [a0],y
	sta.b d3
	lda.w #.pl>>16
	sta.b a0+2
	lda.w #.pl
	sta.b a0
	clc
	adc.b [a0],y
	sta.b a0
.psd3:		;93G .psd3: step to string d3
	lda.b a0+2
	sta.b a1+2
	lda.b a0
	sta.b a1
	clc
	adc.b [a0]
	sta.b a0
	dec.b d3
	bpl .psd3
	jml.l print
.psdtp:		;93G .psdtp: team line: the name of team d3 from its bank $83 team record, or .playoffs in Cont. Playoffs
	ldy.b d7
	lda.w #OptPlayMode
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b [a1],y
	sta.b d3
	asl a
	asl a
	tay
	lda.w #TeamList
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b [a1],y
	sta.b a1
	ldy.w #Teamname
	clc
	adc.b [a1],y
	sta.b a1
	lda.w OptPlayMode
	cmp.w #$0001
	bne .goprint
	lda.w #.playoffs
	sta.b a1
	lda.w #.playoffs>>16
	sta.b a1+2
.goprint:
	jml.l print
.playoffs:		;the Team 1 / Team 2 choice in Cont. Playoffs
	dw 10
	db "Playoffs"
.nms:		;93G .nms: move to line d7 + d0 (0..$C), skipping the lines fixed in this mode (Players in the playoffs, lines 1-3 in Cont. Playoffs, Team 2 in the playoffs), then move the frame from line d3
		;   to d7
	lda.b d7
	sta.b d3
.nms0:
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	bpl .nms1
	stz.b d7
.nms1:
	lda.b d7
	cmp.w #$000E
	bcc .nms2
	lda.b d7
	sbc.b d0
	sta.b d7
.nms2:
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .OptPlayModelt3
	cmp.w #$0004
	bcs .OptPlayModelt3
	lda.b d7
	cmp.w #$0002
	beq .nms0
.OptPlayModelt3:
	lda.w OptPlayMode
	cmp.w #$0001
	bne .OptPlayModene2
	lda.b d7
	beq .OptPlayModene2
	cmp.w #$0007
	bcc .nms0
.OptPlayModene2:
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .nms4
	lda.b d7
	cmp.w #$0006
	beq .nms0
.nms4:		;93G .nms4: erase the old frame, draw the new one
	jsl.l .setrect
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	lda.b d7
	sta.b d3
	jsl.l .setrect
	jml.l Framer
.setrect:		;93G .setrect: printx $10, printy $C + d3, frame size d0 x d1 = $10 x 3 (5 tall for Team 1 in the new playoffs)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$10,$0C
	lda.w printy
	clc
	adc.b d3
	sta.w printy
	lda.w #$0010
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.w OptPlayMode
	cmp.w #$0002
	bcs .OptPlayModege
	jmp.w .rts
.OptPlayModege:
	lda.b d3
	cmp.w #$0004
	beq .d3eq
	jmp.w .rts
.d3eq:
	lda.w #$0005
	sta.b d1
	rtl
	dw 0
.pslim:		;93G .pslim: choices of each line (Play Mode, Players, Team 1, Team 2, Per. Length, Penalties, Line Changes)
	dw $4,$6,$1A,$1A,$3,$3,$2
.pl:		;93G .pl: offsets from .pl of the choice strings of each line
	dw .pl0-.pl
	dw .pl1-.pl
	dw .pl2-.pl
	dw .pl3-.pl
	dw .pl4-.pl
	dw .pl5-.pl
	dw .pl6-.pl
.pl0:		;Play Mode
	dw 16
	db "Regular Season"
	dw 16
	db "Cont. Playoffs"
	dw 14
	db "New Playoffs"
	dw 11
	db "Best of 7"
.pl1:		;Players (the last, One, is the only choice in the playoffs)
	dw 6
	db "Demo"
	dw 12
	db "One - Home"
	dw 15
	db "One - Visitor"
	dw 11
	db "Teammates"
	dw 14
	db "Head to Head"
	dw 5
	db "One"
.pl2:		;Team 1 and Team 2 (not used: .psdtp prints team names), Per. Length (30 Seconds is beyond .pslim)
.pl3:
.pl4:
	dw 11
	db "5 Minutes"
	dw 12
	db "10 Minutes"
	dw 12
	db "20 Minutes"
	dw 12
	db "30 Seconds"
.pl5:		;Penalties
	dw 15
	db "Only Fighting"
	dw 4
	db "On"
	dw 16
	db "On, No Offside"
.pl6:		;Line Changes
	dw 4
	db "On"
	dw 5
	db "Off"
.text:		;93G .text: the line names
	dw 14
	db $FE,$03,$0D,"Play Mode"
	dw 12
	db $FE,$03,$0F,"Players"
	dw 11
	db $FE,$03,$11,"Team 1"
	dw 11
	db $FE,$03,$13,"Team 2"
	dw 16
	db $FE,$03,$15,"Per. Length"
	dw 14
	db $FE,$03,$17,"Penalties"
	dw 17
	db $FE,$03,$19,"Line Changes"
	dw 3		; end (a 0 byte)
	db 0
PixelRemapFramer:		;SNES: RemapTiles table for the Framer tiles (setoptions)
	db $00,$01,$0A,$03,$04,$05,$06,$02,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
PixelRemapFont:		;SNES: RemapTiles table for the small font (setoptions)
	db $00,$0F,$00,$00,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
UnpackNibbles:		;a0 = packed data, d0 = count. Unpacks d0 4-bit values (high nibble first) into words at nibblebuffer. Called from UpdateTeamNameisplay (93G logic93_5)
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
PushNumberWidth:		;IDA: pushnumber (Rev A lst DeterStrLength?). 93: convert d0 into a d1 digit base 10 string, leading zeros as spaces (the last digit always shown). Return a1 = string at
		;   PushWidthBuf (93G middle93_2)
		;   SNES: a1 = PushWidthBuf: d0 as a d1 digit decimal string, right aligned with leading spaces (the last digit always shown)
	lda.w #PushWidthBuf
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b d1
	inc a
	inc a
	sta.w PushWidthBuf
	tay
	lda.w #$2020
	sta.w PushWidthBuf+2
	sta.w PushWidthBuf+4
	sta.w PushWidthBuf+6
	sta.w PushWidthBuf+8
	lda.b d0
.loop:
	sta.b mulb
	lda.w #$000A
	sta.b mula
	dey
	jsl.l divu16
	lda.b mulres+2
	sep #$20
	adc.b #$30
	sta.w PushWidthBuf,y
	rep #$20
	lda.b mulres
	bne .loop
	rtl
StatsReport:		;92G StatsReport role: clear the text screen, send 28 rows of HorRinkMap (32 columns each) to vram $0418 and, 8 columns
		;   in, to $0800, then USBoard
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0020
	sta.b d0
	lda.w #$001D
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0418
	sta.w VMADDL
	lda.w #$001C
	sta.b tmp0
	ldx.w #$0000
.loop:
	ldy.w #$0020
.loop2:
	lda.l HorRinkMap,x
	sta.w VMDATAL
	inx
	inx
	dey
	bne .loop2
	txa
	clc
	adc.w #$0020
	tax
	dec.b tmp0
	bne .loop
	lda.w #$0800
	sta.w VMADDL
	lda.w #$001C
	sta.b tmp0
	ldx.w #$0000
.loop3:
	ldy.w #$0020
.loop4:
	lda.l HorRinkMap+$10,x
	sta.w VMDATAL
	inx
	inx
	dey
	bne .loop4
	txa
	clc
	adc.w #$0020
	tax
	dec.b tmp0
	bne .loop3
	jmp.w USBoard
Findhittype:		;look for type of swing (forhand or backhand) (93G logic93_1)
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
.xflip:		;x flip: 1 = backhand for d0 4-7 (93G %11110000); its last 5 bytes start .noflip
	db $00,$00,$00
.noflip:		;1 = backhand for d0 1-4 (93G %00011110)
	db $00,$01,$01,$01,$01,$00,$00,$00
prefmes:		;print message for penalty d0 (negative clears it). Vertical mode: framed under the ref. Horizontal mode: one centered line on row $B (93G penalty93_1)
		;   SNES: print the message of penalty d0 (negative clears it). Vertical: framed under the ref at y $A, centred by its length; horizontal (sfhormode):
		;   PrintPenaltyMessagesString, one centred line at x $11, y $B. Saves d0-d2, a1
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
.loop:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .loop
	ldx.b xsave
	lda.w sfhormode
	beq .nosfhormode
	jmp.w .join
.nosfhormode:
	lda.b d0
	bpl .d0pos
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0A
	lda.w #$000D
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jmp.w .join2
.d0pos:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0A
	ldy.b d0
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
.skip:
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	dec a
	dec a
	sta.b d0
	beq .join2
	inc a
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	bpl .pos
	stz.w printx
.pos:
	lda.b [a1]
	sta.b d0
	tay
	dec.b a1
	lda.b [a1],y
	inc.b a1
	and.w #$00FF
	bne .nonzero
	dec.b d0
.nonzero:
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	dec.w printy
	dec.w printy
	inc.w printx
	jsl.l print
	bra .join2
.join:
	jsl.l PrintPenaltyMessagesString
	lda.b d0
	bmi .join2
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
.skip2:
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jsl.l print
.join2:
	stx.b xsave
	ldx.w #$0002
.loop2:
	pla
	sta.b a1,x
	dex
	dex
	bpl .loop2
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
CheckInjury:		;called once per second. Count down InjCntDown, act on it at zero (93G hockey93_01)
		;   SNES: once a second: count InjCntDown down; at zero ShowInjuryBox
	dec.w InjCntDown
	bne .rtl
	jmp.w ShowInjuryBox
.rtl:
	rtl
setInjuryType:		;sets period injury. a2 = player injured, a3 = player checking. Marks a2 unavailable, pumps up the crowd, plays sfx $D, locks the scroll on a2, sets TempPlOffset (pnum, bit
		;   15 set for the away team) and puts $FFFD (injured for the period) in a2's tmpdst. Called from FallDown and from logic93_2 chkhit .fall (IDA FightFall) (93G hockey93_03)
		;   SNES: player a2 is injured: pflags bit $1000, crowdlevel + $12C, sfx $8C, the scroll locked on him (xc1/yc1, sflags $40), TempPlOffset
		;   = pnum (| $8000 for the visitors), his tmpdst = $FFFD (out for the period)
	ldy.b a2
	lda.w pflags,y
	ora.w #$1000
	sta.w pflags,y
	lda.b crowdlevel
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w #$008C
	pha
	jsl.l sfx
	ldy.b a2
	lda.w Xpos,y
	sta.w xc1
	lda.w Ypos,y
	sta.w yc1
	lda.w #$0040
	tsb.w sflags
	stz.b d1
	stz.b a0
	lda.w pfteam,y
	beq .nopfteam
	lda.w #$8000
	sta.b d1
	lda.w #$0002
	sta.b a0
.nopfteam:
	lda.w pnum,y
	and.w #$00FF
	ora.b d1
	sta.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .zero
	ora.w #$FF00
.zero:
	asl a
	sta.b d1
	lda.b a0
	beq .noa0
	lda.w #$0034
.noa0:
	adc.b d1
	tay
	lda.w #$FFFD
	sta.w tmpdst,y
	rtl
sublist:		;93G sublist (hockey93_11): substitution lists by position: word offsets from sublist, then roster slots (line * 8 + position); -1 ends
	dw .defl-sublist		; goalie
	dw .defl-sublist		; LD
	dw .defr-sublist		; RD
	dw .wingl-sublist		; LW
	dw .center-sublist		; C
	dw .wingr-sublist		; RW
	dw .center-sublist		; extra attacker
.defl:	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1
	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2
.defr:	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2
	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1
.wingl:	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
.wingr:	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
.center:	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db -1
priolist:		;93G priolist: positions in order of importance (SetPlList, releasepl, getlinee); no pad byte on the SNES
	db 0,1,2,4,3,5,6
ShowInjuryBox:		;93 only: injury box "Injury to:" player TempPlOffset (set by setInjuryType), (93G hockey93_10)
		;   SNES: "Injury to:" the player TempPlOffset (GetPlayerNameWithAttrib), "Out for period", or "the game" when pf2fight of the puck is set.
		;   Jumped to by CheckInjury; saves d0-d2, a0-a4, ends with X = a3
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
	cpx.w #$0014
	bne .pusha
	ldx.b xsave
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$03
	lda.w #$0012
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
	jsl.l printz
	dw $0023		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$04,"Injury to:",$BF,$0C,$06,"Out for period",$BF,$0C,$05
	jsl.l GetPlayerNameWithAttrib
	jsl.l print
	lda.w pf2fight+puckobj
	beq .nopf2fight
	jsl.l printz
	dw $000D		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$06,"the game"
.nopf2fight:
	stx.b xsave
	ldx.w #$0012
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
	ldx.b a3
	rtl
passtoa0:		;pass puck to player a0 (93G logic93_1)
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
GetPlayerCount:		;d0 = players on team a2 (records until a length word of 2) (93G stats93)
		;   SNES: d0 = roster players of team a2 (its bank $83 team record: Player entries until the empty one); saves a0
	lda.b a0+2		; save a0
	pha
	lda.b a0
	pha
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.w #Playerdata
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.b d0
.loop:
	inc.b d0
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	lda.b [a0]
	cmp.w #$0002
	bne .loop
	pla
	sta.b a0
	pla
	sta.b a0+2
	rtl
GetPlayerNameWithAttrib:		;93 only: a1 = mesarea "NN F. Last" (FormatPlayerNameWithAttrib) for player (93G hockey93_10)
		;   SNES: a1 = the name of player TempPlOffset (PlayerShortName; bit 15 = the visitors); saves d0, a2
	lda.b d0+2
	pha
	lda.b d0
	pha
	lda.b a2+2
	pha
	lda.b a2
	pha
	stz.b a2
	lda.w TempPlOffset
	sta.b d0
	bpl .TempPlOffsetpos
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b a2
.TempPlOffsetpos:
	jsl.l PlayerShortName
	pla
	sta.b a2
	pla
	sta.b a2+2
	pla
	sta.b d0
	pla
	sta.b d0+2
	rtl
Acheck:		;start hold (or hook if a0 is ahead, $CB0) on player a0. Also entered (93G logic93_1)
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
divs16:		;SNES: signed 16 / 16 divide: A = mulres = mulb / mula (toward zero; also left in mula and mulb); uses mulsign, mulcnt
	stz.b mulsign
	lda.b mula
	bpl .mulapos
	eor.w #$FFFF
	inc a
	inc.b mulsign
.mulapos:
	sta.b mula+2
	stz.b mula
	lda.w #$0010
	sta.b mulcnt
	lda.b mulb
	bpl .loop
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mulsign
.loop:
	lsr.b mula+2
	ror.b mula
	asl.b mulres
	lda.b mulb
	cmp.b mula
	lda.w #$0000
	sbc.b mula+2
	bcc .lt
	lda.b mulb
	sbc.b mula
	sta.b mulb
	inc.b mulres
.lt:
	dec.b mulcnt
	bne .loop
	lsr.b mulsign
	bcc .lt2
	lda.w #$0000
	sbc.b mulres
	sta.b mulres
.lt2:
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
doplayeracc:		;player a3 gets acc. in d0 dir (93G logic93_5)
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
.d0:		;93G .d0
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
.cgl:		;93G .cgl: no turn animation playing (pf2aip): SetSPA
	lda.w pf2aip,x
	bne .rtl
	jml.l SetSPA
.rtl:
	rtl
.d1:		;93G .d1: a direction: pfrev, then the turn
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
.c1:		;93G .c1
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
.inrev:		;93G .inrev
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
.rev:		;93G .rev
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
.setrev:		;93G .setrev
	inc a
	sta.w pfrev,x
	bra .done
.clrrev:		;93G .fwd / .clrrev
	stz.w pfrev,x
.done:		;93G .done: turn rate = .ftab (direction difference) * d7; 0: noturn0
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
.iok:		;93G .iok
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
.i0:		;93G .i0: facedir.l + d4
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
.s1:		;93G .s1
	lda.w attribute,x
	bit.w #$0800
	beq .s2
	lda.b d1
	eor.w #SPAturnl-SPAturnr
	sta.b d1
.s2:		;93G .s2: SPAturnr (or SPAturnl), pf2aip
	lda.b d1
	clc
	adc.w #SPAturnr
	sta.b d1
	sta.w pf2aip,x
.s3:		;93G .s3
	jsl.l SetSPA
	lda.b d3
	cmp.w #$0003
	bcc .rtl2
	jml.l revplayeracc
.rtl2:
	rtl
.ftab:		;93G .ftab: turn rate by the direction difference (93G $10)
	dw 0,23,23,23,0,-23,-23,-23
ResetAndSelectPlayers:		;93 split from 92 puckfaceoff2: c1playernum/c2playernum = -1, then changeplayer for each human team. Called from puckfaceoff2 (93G logic93_4)
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
cd0:		;93G cd0 (hockey93_11): $fftt = frame/time for the levels of crowd excitement (updatecrowdf: crowd level, crowdstep); 4 levels of 16
	dw $010C,$020C,$030C,$040C,$050C,$0A0C,$090C,$080C
	dw $060C,$070C,$080C,$090C,$0A0C,$050C,$040C,$030C
	dw $0107,$0207,$0307,$0407,$0507,$0B07,$0C07,$0D07
	dw $0607,$0707,$0807,$0907,$0A07,$0B07,$0C07,$0D07
	dw $0E07,$0F07,$1007,$1107,$1207,$0B07,$0C07,$0D07
	dw $1207,$1107,$1007,$0F07,$0E07,$0D07,$0C07,$0B07
	dw $0E03,$0F03,$1003,$1103,$1203,$0B03,$0C03,$0D03
	dw $1203,$1103,$1003,$0F03,$0E03,$0D03,$0C03,$0B03
MusicCue:		;SNES: send driver command A (a music cue): the sound queue becomes just A (sndqueue, out 0, in 2), under sndlock
	pha
	lda.w #$0001
	sta.b sndlock
	pla
	sta.b sndqueue
	stz.b sndqout
	lda.w #$0002
	sta.b sndqin
	stz.b sndlock
	rtl
sfx8F:		;SNES: bank $8F copy of sfx: queue the sound pushed before the jsl (0 = none) unless within 180 frames of sfxmutetime; no lastsfx; returns through jmlvector. Sends the
		;   crowd volume (bank $8D, $8F87C4)
	pla		; return address +1 into jmlvector
	inc a
	sta.w jmlvector+1
	sep #$20
	pla
	sta.w jmlvector+3
	rep #$20
	lda.b vcount
	sec
	sbc.w sfxmutetime
	cmp.w #$00B4
	bcc .lt
	pla		; the sound (0 = none)
	beq .loop
	jsl.l QueueSound
.loop:
	jml.l jmlvector
.lt:
	pla
	bra .loop
DisplayPlayerAttributeMenu:		;93 only: goal box. Closes both line change boxes, then printbig "GOAL!" (or "HAT (93G hockey93_10)
		;   SNES: , really the goal box: close both line change boxes (lcfound2), Framer at x $B, y 2 (5-8 tall by the
		;   assists), printbig "GOAL!" or "HAT TRICK!" (the scorer's third goal, tmgoals), the scorer and "Assist by:" names from the last ScoreSum entry; saves d0-d2, a0-a4, ends with X = a3
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
	cpx.w #$0014
	bne .pusha
	ldx.b xsave
	stz.b a2
	jsl.l lcfound2
	inc.b a2
	inc.b a2
	jsl.l lcfound2
	lda.w #$0000
	sta.b a4+2
	lda.w #ScoreSum-6
	clc
	adc.w ScoreSumbytes
	sta.b a4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02
	lda.w #$0013
	sta.b d0
	lda.w #$0005
	sta.b d1
	ldy.w #$0004
	lda.b [a4],y
	bit.w #$0080
	bne .nonzero
	inc.b d1
	inc.b d1
	lda.b [a4],y
	bmi .nonzero
	inc.b d1
.nonzero:
	jsl.l Framer
	stz.b a2
	ldy.w #$0002
	lda.b [a4],y
	bit.w #$0080
	beq .zero
	inc.b a2
	inc.b a2
.zero:
	lda.w #attrText
	sta.b a1
	lda.w #attrText>>16
	sta.b a1+2
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	ldy.b a2
	beq .noa2
	clc
	adc.w #$001A
.noa2:
	tay
	lda.w tmgoals,y		; goals of the scorer
	and.w #$00FF
	cmp.w #$0003
	bne .tmgoalsne
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.tmgoalsne:
	jsl.l printbig
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0004
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .ex
	jsl.l printz
	dw $0012		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0E,$06,"Assist by:",$BF,$0C,$07
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0005
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .ex
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$08
	jsl.l PlayerShortName
	jsl.l print
.ex:		;93G .ex
	stx.b xsave
	ldx.w #$0012
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
	ldx.b a3
	rtl
attrText:		;93G attrText: printbig strings of DisplayPlayerAttributeMenu: GOAL!, then HAT TRICK!
	dw 13
	db $BF,$0F,$03,"GOAL!",$BF,$0C,$05
	dw 18
	db $BF,$0C,$03,"HAT TRICK!",$BF,$0C,$05
unusedFF8F:		;the end of the ROM: zero fill
	db 0,0,0,0,0
