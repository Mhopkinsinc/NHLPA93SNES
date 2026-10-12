setoptions:		;The options screen: up and down pick a line, left and right change it, Start goes on;
		;   left idle, a demo game starts with random teams
	lda.w #vb2_blank
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	lda.b sprclock
	sec
	sbc.w #$003C
	ldx.w #$0000
.clrframetime:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .clrframetime
	ldx.w #$0000
.clrslottime:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .clrslottime
	stz.b DMAListend
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	rep #$30
	lda.b vcount
.vwait:
	cmp.b vcount
	beq .vwait
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
	jsl.l DecompressBytecode
	sep #$20
	stz.w CGADD
	ldx.w #$0000
.setuppal:
	lda.l TestList+$800,x
	sta.l palbuffer,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .setuppal
	ldx.w #$0000
.rinkpal:
	lda.l RinkPalette,x
	sta.l palbuffer+$100,x
	sta.w CGDATA
	inx
	cpx.w #$0100
	bne .rinkpal
	rep #$30
	lda.w #$1000
	sta.w VMADDL
	ldx.w #$0000
.setuptiles:
	lda.l TestList+$900,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0240
	bne .setuptiles
	ldx.w #$0010
.padvram:
	stz.w VMDATAL
	dex
	bne .padvram
	lda.w #SmallFontTiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
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
	jsl.l DecompressBytecode
	ldx.w #$0000
.logotiles:
	lda.l TestList+$1A0,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06A0
	bne .logotiles
	lda.w #TeamBlocksTiles
	sta.b tmp0
	lda.w #TeamBlocksTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.blocktiles:
	lda.l TestList,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$32A0
	bne .blocktiles
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
.textlp:		;print the .text lines until a 0 byte
	jsl.l print
	ldy.w #$0002
	lda.b [a1],y
	and.w #$00FF
	bne .textlp
	lda.w #$FFFF
	sta.w notdemo
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .nopo
	jsl.l NewPO
.nopo:
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
	bne .dmaqueued
	jsl.l QueueBackmapDMA
.dmaqueued:
	lda.w #VBlank_SprPal
	sta.b vbint
	dec.b d6
	bpl .frame
	lda.w #$001A		; demo: random teams, both computer
	jsl.l randoma
	sta.w OptTeam1
	sta.w HomeTeam
.team2:
	lda.w #$001A
	jsl.l randoma
	cmp.w OptTeam1
	beq .team2
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
	bne .nopass
	jsl.l GetPassWord
.nopass:
	lda.w #$0080
	tsb.w PassWord
	jml.l maketree
.input:		;a pad pressed (d1): Start, Up/Down (.nms by 2), Left/Right (.IncItem by 1)
	lda.b d1
	bit.w #$1000
	bne .start
	bit.w #$0400
	beq .2
	lda.w #$0002
	sta.b d0
	jsl.l .nms
	jsl.l .ps
	jmp.w .idle
.2:
	bit.w #$0800
	beq .3
	lda.w #$FFFE
	sta.b d0
	jsl.l .nms
	jsl.l .ps
.back:
	jmp.w .idle
.3:
	lda.w #$0001
	sta.b d2
	lda.b d1
	bit.w #$0100
	bne .4
	bit.w #$0200
	beq .back
	lda.w #$FFFF
	sta.b d2
.4:
	jsl.l .IncItem
	jsl.l .ps
	jmp.w .idle
.IncItem:		;add d2 to option d7 (OptPlayMode + d7) within .pslim (d2 = 0: just limit it). Players is fixed to One outside Regular Season; Team 1 has $18 choices in the playoffs; a new
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
	bcc .ii0
	cpy.w #$0004
	bne .ii0
	lda.w #$0018
	sta.b d4
.ii0:
	cpy.w #$0002
	bne .ii1
	lda.w #$0005
	sta.b d5
	lda.w OptPlayMode
	bne .ii1
	stz.b d5
	lda.w #$0005
	sta.b d4
.ii1:
	jsl.l .iilimit		; d3 = the new value
	lda.b d3
	sta.b [a2],y
	lda.b d2
	beq .rts
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .rts
	tya
	bne .npo
	jml.l NewPO
.npo:
	cpy.w #$0004
	bne .rts
	jml.l NewPO
.rts:
	rtl
.iilimit:		;d3 + d2, wrapped into d5 ... d4-1
	lda.b d3
	clc
	adc.b d2
	sta.b d3
	sec
	sbc.b d5
	bmi .lowneg
	bvs .under
	bra .iil1
.lowneg:
	bvs .iil1
.under:
	lda.b d4
	dec a
	sta.b d3
.iil1:
	lda.b d3
	sec
	sbc.b d4
	bmi .highneg
	bvc .over
	bra .rts
.highneg:
	bvc .rts
.over:
	lda.b d5
	sta.b d3
	rtl
.ps:		;print the choices of all 7 lines (.psd), then PrintTeamNames
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
.psd:		;print the choice of line d7 at x $11 (14 chars erased first): string d3 of its .pl list; the team lines print the team name (.psdtp)
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
.psd3:		;step to string d3
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
.psdtp:		;team line: the name of team d3 from its bank $83 team record, or .playoffs in Cont. Playoffs
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
	bne .print
	lda.w #.playoffs
	sta.b a1
	lda.w #.playoffs>>16
	sta.b a1+2
.print:
	jml.l print
.playoffs:		;the Team 1 / Team 2 choice in Cont. Playoffs
	dw 10
	db "Playoffs"
.nms:		;move to line d7 + d0 (0..$C), skipping the lines fixed in this mode (Players in the playoffs, lines 1-3 in Cont. Playoffs, Team 2 in the playoffs), then move the frame from line d3
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
	bcc .nmscp
	cmp.w #$0004
	bcs .nmscp
	lda.b d7
	cmp.w #$0002
	beq .nms0
.nmscp:
	lda.w OptPlayMode
	cmp.w #$0001
	bne .nmst2
	lda.b d7
	beq .nmst2
	cmp.w #$0007
	bcc .nms0
.nmst2:
	lda.w OptPlayMode
	cmp.w #$0002
	bcc .nms4
	lda.b d7
	cmp.w #$0006
	beq .nms0
.nms4:		;erase the old frame, draw the new one
	jsl.l .setrect
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	lda.b d7
	sta.b d3
	jsl.l .setrect
	jml.l Framer
.setrect:		;printx $10, printy $C + d3, frame size d0 x d1 = $10 x 3 (5 tall for Team 1 in the playoff modes)
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
	bcs .po
	jmp.w .rts
.po:
	lda.b d3
	cmp.w #$0004
	beq .team1
	jmp.w .rts
.team1:
	lda.w #$0005
	sta.b d1
	rtl
	dw 0
.pslim:		;choices of each line (Play Mode, Players, Team 1, Team 2, Per. Length, Penalties, Line Changes)
	dw $4,$6,$1A,$1A,$3,$3,$2
.pl:		;offsets from .pl of the choice strings of each line
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
.text:		;the line names
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
