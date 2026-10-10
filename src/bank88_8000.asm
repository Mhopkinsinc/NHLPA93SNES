; $888000-$88900E  ROM $40000-$4100E: GameSetupMap (packed game setup screen backdrop), SmallFontMap (print: character -> small font tile),
; mulu32, getlinee (penalty93_2), the 92G password code (WritePassBits, EncodePW, PWprint, SuperMult), noturn0 (logic93_5), FramerMap and
; FramerTiles, showcrowd (video93_1), DrawGameSetupBack, mulu; then SpriteSet8 (frame set 8: arrows, pads, puck, goal), tiles continue to bank88_9000.
org $888000
GameSetupMap:		;SNES: the game setup screen backdrop (two team boxes, options box), packed: 32 x 32 map, 128 colours at $800, 18 tiles at $900
	incbin "../data/GameSetup.map.pak"		; $888000-$88822E
GameSetupMapEnd:
	assert GameSetupMapEnd-GameSetupMap == $22F
SmallFontMap:		;93G smallfontmap: print character (0-127) -> small font tile (+ flip bits), added to smallfontchars by print
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; chars $00-$07
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; chars $08-$0F
	dw $0000,$0000,$0001,$0002,$0003,$0000,$0004,$0005		; chars $10-$17
	dw $0006,$0007,$0000,$0000,$0000,$0060,$0061,$0062		; chars $18-$1F
	dw $0000,$0008,$0009,$000A,$000B,$000C,$0000,$000D		; chars $20-$27
	dw $000E,$000F,$0010,$0011,$0012,$0013,$0014,$0015		; chars $28-$2F
	dw $0016,$0017,$0018,$0019,$001A,$001B,$001C,$001D		; chars $30-$37
	dw $001E,$001F,$0020,$0021,$0022,$0023,$0024,$0025		; chars $38-$3F
	dw $0026,$0027,$0028,$0029,$002A,$002B,$002C,$002D		; chars $40-$47
	dw $002E,$002F,$0030,$0031,$0032,$0033,$0034,$0016		; chars $48-$4F
	dw $0035,$0036,$0037,$0038,$0039,$003A,$003B,$003C		; chars $50-$57
	dw $003D,$003E,$003F,$0040,$0041,$4040,$0042,$0043		; chars $58-$5F
	dw $0044,$0045,$0046,$0047,$0048,$0049,$004A,$004B		; chars $60-$67
	dw $004C,$004D,$004E,$004F,$0050,$0051,$0052,$0053		; chars $68-$6F
	dw $0054,$0055,$0056,$0057,$0058,$0059,$005A,$005B		; chars $70-$77
	dw $005C,$005D,$005E,$0063,$005F,$8063,$0000,$0000		; chars $78-$7F
mulu32:		;auto: CODE_88832F. SNES: 32-bit multiply with the 8x8 hardware multiplier: A = mulres (32-bit, low word) = mula * mulb (low 32 bits). C clear
	sep #$20
	lda.b mula
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	sta.b mulres
	stz.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c1
	inc.b mulres+3
.c1:
	lda.b mulb+2
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+3
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c2
	inc.b mulres+3
.c2:
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+2
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+2
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+3
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	rep #$30
	lda.b mulres
	clc
	rtl
getlinee:		;auto: CODE_888405. 93G getlinee (penalty93_2): d0 = line number, a2 = team. Returns d0 = average energy (tmpde) of the skaters of that line (priolist $8FF820 picks the positions)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d3,x
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
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	lda.w #$0083		; a1 = the team data (bank $83)
	sta.b a1+2
	ldy.w #$0006		; + offset of the line sets
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b d0		; line d0: 8 bytes
	asl a
	asl a
	asl a
	adc.b a1
	sta.b a1
	stz.b mulb
	stz.b mula
	lda.w #priolist		; a0 = priolist ($8FF820)
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	ldy.b a2		; tmap: positions - 1
	lda.w tmap,y
	sta.b d4
	bra .next
.loop:
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	beq .next
	tay		; player number
	lda.b [a1],y
	and.w #$00FF
	asl a
	sta.b d3
	inc.b mula
	lda.b a2
	beq .home
	lda.w #$0034
.home:
	adc.b d3
	tay
	lda.w tmpde-2,y
	adc.b mulb
	sta.b mulb
.next:
	dec.b d4
	bpl .loop
	jsl.l divu16		; d0 = energy sum / players
	sta.b d0
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
	sta.b d3,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
WritePassBits:		;auto: CODE_8884A9. 92G WritePassBits: playoff state into passbits (PushBits with each range), then the 9-bit checksum of the values (d7) with range 512
	jsl.l ClrPassBits
	stz.b d7
	lda.w postarts		; PushBits ranges: postarts 32, bosgames 8, gamelevel 4, potreeteam 16, pojoy 4, WinBits $4000
	sta.b d0
	lda.w #32
	sta.b d1
	jsl.l .pb
	lda.b bosgames
	sta.b d0
	lda.w #8
	sta.b d1
	jsl.l .pb
	lda.w gamelevel
	sta.b d0
	lda.w #4
	sta.b d1
	jsl.l .pb
	lda.w potreeteam
	sta.b d0
	lda.w #16
	sta.b d1
	jsl.l .pb
	lda.w pojoy
	sta.b d0
	lda.w #4
	sta.b d1
	jsl.l .pb
	lda.w WinBits
	sta.b d0
	lda.w #$4000
	sta.b d1
	jsl.l .pb
	lda.w #5
	sta.b d1
	lda.w #7
	sta.b d2
	stz.b a1
.gs:		;93G .0: the 8 series scores, range 5
	ldy.b a1
	lda.w gspotwins,y
	sta.b d0
	jsl.l .pb
	ldy.b a1
	lda.w gspobwins,y
	sta.b d0
	jsl.l .pb
	inc.b a1
	inc.b a1
	dec.b d2
	bpl .gs
	lda.b d7		; checksum
	and.w #$01FF
	sta.b d0
	lda.w #512
	sta.b d1
	jsl.l PushBits
	rtl
.pb:		;92G .pb: d7 += d0, then PushBits
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	jml.l PushBits
noturn0:		;auto: CODE_888548 (from doplayeracc). 93G noturn0 (logic93_5): wanted direction needs no turn; glide/stop/skate animation, then revplayeracc (93G noturn). d0 = direction - facedir
	lda.w #$0002		; d4 (here d2) = 2, 6 skating backwards
	sta.b d4
	lda.w pfrev,x
	beq .zero
	lda.w #$0006
	sta.b d4
	lda.b d0
	eor.w #$0008
	sta.b d0
.zero:		;93G .0
	lda.b d0
	beq .nochg
	lda.w Xvel,x		; moving: stop if the direction is more than 90 degrees off
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa
	bit.w #$0008
	bne .nostop
	sec
	sbc.w facedir,x
	clc
	adc.b d4
	and.w #$0007
	sta.b d0
	cmp.w #$0004
	bcs .nostop
	jml.l dostop
.nostop:
	inc.w facedir,x		; turn one step
	lda.w attribute,x
	bit.w #$0800
	beq .nos0
	dec.w facedir,x
	dec.w facedir,x
.nos0:
	lda.w facedir,x
	and.w #$0007
	sta.w facedir,x
	lda.w #SPAglide
	sta.b d1
	lda.w pfrev,x
	bne .gback
	jml.l SetSPA
.gback:
	lda.w #SPAglideback
	sta.b d1
	jml.l SetSPA
.nochg:
	lda.w #SPAskateback		; no change: skate
	sta.b d1
	lda.w pfrev,x
	bne .ns
	lda.w #SPAskate
	sta.b d1
	lda.w pflags,x		; pflags $0004 (93G pflags2 bit 6): stumble
	bit.w #$0004
	beq .nb6
	lda.w #SPAstumble
	sta.b d1
.nb6:
	lda.w puckc		; carrier: skate with the puck
	sta.b d4
	cmp.w SCnum,x
	bne .ns
	lda.w #SPAskatewp
	sta.b d1
.ns:
	lda.w pf2aip,x
	beq .set
	jml.l revplayeracc
.set:
	jsl.l SetSPA
	jml.l revplayeracc
PWprint:		;auto: CODE_8885F7. 92G PWprint: print the 16 password characters (PassWord through PasstoText) at printx/printy, unless PassWord bit 7 hides it
	lda.w PassWord
	bit.w #$0080
	beq .show
	jmp.w .rtl
.show:
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
	cpx.w #$000C
	bne .pusha
	ldx.b xsave
	lda.w #PasstoText		; a2 = PasstoText
	sta.b a2
	lda.w #PasstoText>>16
	sta.b a2+2
	lda.w #mesarea		; a1 = mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #18		; length 18: 16 characters
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w #15
	sta.b d1
.top:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	tay
	lda.b [a2],y
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .top
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jsl.l print
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
	ldx.w #$0006
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
.rtl:
	rtl
EncodePW:		;auto: CODE_88868D. 92G EncodePW (Rev A): after a playoff game, ResolveGames and maketree; then the new password, or new playoffs when the user won or went out
	lda.w OptPlayMode
	bne .po
	jmp.w .rtl
.po:
	lda.w #$0001
	sta.w OptPlayMode
	jsl.l ResolveGames		; bank $8B: 92G ResolveGames
	jsl.l maketree		; bank $8D: maketree
	lda.w gamelevel		; finished playoffs
	cmp.w #$0004
	beq .userwon
	lda.w gamenum		; gamenum >= 0: player 1 won
	bpl .nofail
	lda.w pojoy		; pojoy < 2: one player or teammates
	sec
	sbc.w #$0002
	bmi .lt
	bvc .two
	bra .userfailed
.lt:
	bvc .userfailed
.two:		;two players, first round: switch to the other team
	lda.w gamelevel
	cmp.w #$0001
	bne .userfailed
	lda.w potreeteam
	eor.w #$0001
	sta.w potreeteam
	lda.w pojoy
	eor.w #$0001
	sta.w pojoy
.nofail:
	jsl.l WritePassBits
	jsl.l BitstoPW
	lda.w sflags3		; sf3alttree: passbits before all games were resolved
	bit.w #sf3alttree
	beq .tree
	ldy.w #$000E
.cp:
	lda.w tpassbits,y
	sta.w passbits,y
	dey
	dey
	bpl .cp
	jsl.l ReadPassBits		; bank $8B: 92G ReadPassBits
.tree:
	jml.l maketree		; bank $8D: maketree
.userwon:
	jsl.l ResetPassWord		; bank $8F: 92G ResetPassWord
.userfailed:
	lda.w #$0080		; PassWord bit 7: no password
	tsb.w PassWord
	lda.w #$0002
	sta.w OptPlayMode
	lda.b bosgames
	cmp.w #$0007
	beq .rtl
	lda.w #$0003
	sta.w OptPlayMode
.rtl:
	rtl
FramerMap:		;93G Framer.map.jim: the 3 x 3 box pieces (corner, edge, side, centre) from the 4 FramerTiles with flips ($8FD724)
	dw $0000,$0001,$4000
	dw $0002,$0003,$4002
	dw $8000,$8001,$C000
FramerTiles:		;the 4 Framer box tiles (4bpp, data/Framer.chr): vram by $8FDCFD; setupice remaps them with PixelRemap87
	incbin "../data/Framer.chr"		; $88872E-$8887AD
showcrowd:		;auto: CODE_8887AE. 93G showcrowd (video93_1): crowd sprites: up to 3 frames per PBnum nibble (penalty box), then the two crowdframe frames (not on the horizontal rink)
	stz.b a1
	lda.w Hpos
	sta.b d4
	lda.w Vpos
	sta.b d5
	lda.w sfhormode
	beq .v
	lda.w #$FFC0
	sta.b d4
	lda.w #$0100
	sta.b d5
.v:
	stz.b d0
	lda.w PBnum
	sta.b d2
	lda.w #$001A		; frames 26+
	sta.b d3
	jsl.l .pb
	lda.w PBnum
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d2
	lda.w #$001D		; frames 29+
	sta.b d3
	jsl.l .pb
	lda.w sfhormode
	bne .rtl
	lda.b crowdframe
	sta.b d0
	jsl.l .sc
	lda.b crowdframe+1
	sta.b d0
	bra .sc
.pb:		;d2 = count, d3 = first frame
	lda.b d2
	and.w #$000F
	sta.b d2
	cmp.w #$0004
	bcc .pb0
	lda.w #$0003
	sta.b d2
.pb0:
	bra .nextpb
.pbt:
	lda.b d3
	clc
	adc.b d2
	sta.b d0
	jsl.l .sc
.nextpb:
	dec.b d2
	bpl .pbt
.rtl:
	rtl
.sc:		;d0 = frame (0 = none): sprite frame $292 + d0 (+31 horizontal) at the rink scroll position
	lda.b d0		; frame byte
	and.w #$00FF
	sta.b d0
	beq .rtl
	lda.w sfhormode
	beq .chk
	lda.b d0
	clc
	adc.w #31
	sta.b d0
.chk:
	lda.b d0
	clc
	adc.w #$0292		; crowd frames start at $293
	sta.b sprframe
	lda.w #$FFC0		; x = $FFC0 - Hpos
	sec
	sbc.b d4
	sta.b sprx
	lda.w #$FEFF		; y = Vpos - $101
	clc
	adc.b d5
	sta.b spry
	jml.l addframe_hi
SuperMult:		;auto: CODE_888853. 92G SuperMult: passbits (8 words) *= d0, by shift and add (mulres..mulres+15 hold the shifted copy)
	phx
	ldx.w #$000E
.copy:
	lda.w passbits,x		; copy passbits, clear passbits
	sta.b mulres,x
	stz.w passbits,x
	dex
	dex
	bpl .copy
	lda.b d0
	sta.b mula
.loop:
	lsr.b mula
	bcc .noadd
	lda.w passbits
	clc
	adc.b mulres
	sta.w passbits
	lda.w passbits+2
	adc.b mulres+2
	sta.w passbits+2
	lda.w passbits+4
	adc.b mulres+4
	sta.w passbits+4
	lda.w passbits+6
	adc.b mulres+6
	sta.w passbits+6
	lda.w passbits+8
	adc.b mulres+8
	sta.w passbits+8
	lda.w passbits+10
	adc.b mulres+10
	sta.w passbits+10
	lda.w passbits+12
	adc.b mulres+12
	sta.w passbits+12
	lda.w passbits+14
	adc.b mulres+14
	sta.w passbits+14
.noadd:
	asl.b mulres
	rol.b mulres+2
	rol.b mulres+4
	rol.b mulres+6
	rol.b mulres+8
	rol.b mulres+10
	rol.b mulres+12
	rol.b mulres+14
	lda.b mula
	bne .loop
	plx
	clc
	rtl
DrawGameSetupBack:		;auto: CODE_8888C3. SNES: game setup screen backdrop: textmap blank, GameSetupMap to backmap (priority off), the NHLPA logo map ($8C8000, 8 x 10) into textmap at x 12-19, y 0-9
	lda.w blankchar
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #GameSetupMap
	sta.b tmp0
	lda.w #GameSetupMap>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$07FE
.map:
	lda.l TestList,x
	and.w #$DFFF		; priority bit off
	sta.l backmap,x
	dex
	dex
	bpl .map
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	lda.w #NHLPALogo		; the NHLPA logo (packed)
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	lda.w #$0009
	sta.b tmp1
.row:
	lda.w #$0007
	sta.b tmp0
.col:
	lda.b tmp1
	sta.b mula
	lda.w #$0008
	sta.b mulb
	jsl.l mulu16		; bank $8D: 16-bit multiply
	adc.b tmp0
	asl a		; logo map word + logochars
	tax
	lda.l TestList,x
	adc.w logochars
	pha
	lda.b tmp1
	asl a
	asl a
	asl a
	asl a
	asl a		; textmap row y * 32 + x + 12
	adc.b tmp0
	asl a
	tax
	pla
	sta.l textmap+$18,x
	dec.b tmp0
	bpl .col
	dec.b tmp1
	bpl .row
	rtl
mulu:		;auto: CODE_888942. 68k mulu.w: mulres (32-bit) = mula * mulb; mula/mulb also get the result. A byte factor uses the mode 7 multiplier (M7A/M7B)
	lda.b mula		; mula >= $80 needs mulb < $80
	bmi .full
	cmp.w #$0080
	bcc .byteb
	lda.b mulb
	bmi .full
	cmp.w #$0080
	bcs .full
	sep #$20
	sta.w M7B
	lda.b mula
	sta.w M7A
	lda.b mula+1
	sta.w M7A
	lda.w MPYH
	rep #$30
	and.w #$00FF
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.byteb:
	lda.b mulb		; mula < $80: byte factor
	bmi .full
	sep #$20
	sta.w M7A
	xba
	sta.w M7A
	lda.b mula
	sta.w M7B
	lda.w MPYH
	rep #$30
	and.w #$00FF
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.full:
	sep #$20
	lda.b mula
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	sta.b mulres
	stz.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c1
	inc.b mulres+3
.c1:
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c2
	inc.b mulres+3
.c2:
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
SpriteSet8:		;frame set 8 (arrows, pads, puck and goal): frames 384-405
	dw 22		; frames
	dw 75		; pieces
	dw 128		; tiles
	dw .pieces-SpriteSet8
	dw .tiles-SpriteSet8
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,12,18,24,30,36,38
	dw 40,42,43,44,45,46,47,48
	dw 49,50,51,52,53,63,75
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set08.pieces"		; $888A47-$888B72
	assert .tiles-.pieces == 4*75
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set08.chr":0..$49C		; $888B73-$88900E
