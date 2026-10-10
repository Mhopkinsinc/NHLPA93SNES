; $87C000-$87D204  ROM $3C000-$3D204: the last SpriteSet2 tiles; EASNMap (93G EASN.map.jim: the EASN logo backdrop, packed map and
; tiles); FaceOffTiles (packed faceoff box tiles); TeamBlocksMap (93G TeamBlocks.map: the 9 x 2 tile name block of each team);
; DrawFrame, the SNES sprite emitter for frames below $293 (4-byte pieces) and the addframe end. Ends after it (boundary moved from $87CFFF).
org $87C000
	incbin "../data/Sprites/set02.chr":$3C60..$4000		; $87C000-$87C39F
SpriteSet2End:
	assert SpriteSet2End-SpriteSet2 == $3A0+512*32
EASNMap:		;93G EASN.map.jim: the EASN logo backdrop, packed (decompressor $86FA3E): a 32 x 16 map, then the tiles; unpacked by $8FDC7B and $8FE8D9
	incbin "../data/EASN.map.pak"		; $87C3A0-$87C6B3
FaceOffTiles:		;packed faceoff box tiles (55, 93G FaceOff.map.jim tiles): setupice sends them to faceoffvrcset
	incbin "../data/FaceOff.chr.pak"		; $87C6B4-$87CAB9
TeamBlocksMap:		;93G TeamBlocks.map: per team (26) a 9 x 2 tile block map (palette 1, tiles from TeamBlocksTiles), 36 bytes each (team * 36 by $88F672, $8D84F4)
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406,$0401,$0407,$0408,$0409,$040A,$040B,$040C,$040D,$040E,$0409,$040F		; team 0
	dw $0410,$0411,$0412,$0413,$0414,$0415,$0416,$0417,$0418,$0408,$0419,$041A,$041B,$041C,$041D,$041E,$041F,$040F		; team 1
	dw $0420,$0421,$0422,$0423,$0424,$0425,$0426,$0427,$0428,$0408,$0429,$042A,$042B,$042C,$042D,$042E,$0409,$040F		; team 2
	dw $0400,$042F,$0430,$0431,$0432,$0433,$0434,$0401,$0407,$0435,$0436,$0437,$0438,$0439,$043A,$043B,$043C,$043D		; team 3
	dw $0420,$043E,$043F,$0440,$0441,$0442,$0443,$043E,$0428,$0435,$043C,$0444,$0445,$0446,$0447,$0448,$043C,$043D		; team 4
	dw $0449,$044A,$044B,$044C,$044D,$044E,$044F,$0450,$0451,$0452,$0453,$0454,$0455,$0456,$0457,$0458,$0459,$045A		; team 5
	dw $045B,$045C,$045D,$045E,$045F,$0460,$0461,$0462,$0463,$0464,$0465,$0466,$0467,$0468,$0469,$046A,$046B,$046C		; team 6
	dw $046D,$046E,$046F,$0470,$0471,$0472,$0473,$0474,$0475,$0476,$0477,$0478,$0479,$047A,$047B,$047C,$047D,$047E		; team 7
	dw $047F,$0480,$0481,$0482,$0483,$0484,$0485,$0486,$0487,$0488,$0489,$048A,$048B,$048C,$048D,$048E,$048F,$0490		; team 8
	dw $0400,$0491,$0492,$0493,$0494,$0495,$0496,$0497,$0407,$0498,$0499,$049A,$049B,$049C,$049D,$049E,$049F,$04A0		; team 9
	dw $0449,$04A1,$04A2,$04A3,$04A4,$04A5,$04A6,$04A7,$0451,$0435,$04A8,$04A9,$04AA,$04AB,$04AC,$04AD,$04AE,$043D		; team 10
	dw $04AF,$04B0,$04B1,$04B2,$04B3,$04B4,$04B5,$04B6,$04B7,$04B8,$04B9,$04BA,$04BB,$04BC,$04BD,$04BE,$04BF,$043D		; team 11
	dw $0449,$04C0,$04C1,$04C2,$04C3,$04C4,$04C5,$04C6,$0451,$0435,$04C7,$04C8,$04C9,$04CA,$04CB,$04CC,$04CD,$043D		; team 12
	dw $0420,$043E,$04CE,$04CF,$04D0,$04D1,$04D2,$043E,$0428,$04D3,$04D4,$04D5,$04D6,$04D7,$04D8,$04D9,$04D4,$04DA		; team 13
	dw $04DB,$04DC,$04DD,$04DE,$04DF,$04E0,$04E1,$04E2,$04E3,$04E4,$04E5,$04E6,$04E7,$04E8,$04E9,$04EA,$04EB,$04EC		; team 14
	dw $0400,$04ED,$04EE,$04EF,$04F0,$04F1,$04F2,$04F3,$0407,$0408,$04F4,$04F5,$04F6,$04F7,$04F8,$04F9,$04FA,$040F		; team 15
	dw $0449,$04FB,$04FC,$04FD,$04FE,$04FF,$0500,$04FB,$0451,$0435,$043C,$0501,$0502,$0503,$0504,$0505,$043C,$043D		; team 16
	dw $0400,$0506,$0507,$0508,$0509,$050A,$050B,$050C,$0407,$050D,$050E,$050F,$0510,$0511,$0512,$0513,$0514,$0515		; team 17
	dw $0410,$0516,$0517,$0518,$0519,$051A,$051B,$051C,$0418,$04D3,$051D,$051E,$051F,$0520,$0521,$0522,$0523,$04DA		; team 18
	dw $0400,$0524,$0525,$0526,$0527,$0528,$0529,$052A,$0407,$052B,$052C,$052D,$052E,$052F,$0530,$0531,$0532,$0533		; team 19
	dw $0449,$0534,$0535,$0536,$0537,$0538,$0539,$053A,$0451,$052B,$053B,$053C,$053D,$053E,$053F,$0540,$0541,$0533		; team 20
	dw $0400,$0542,$0543,$0544,$0545,$0546,$0547,$0548,$0549,$0408,$054A,$054B,$054C,$054D,$054E,$054F,$0550,$0551		; team 21
	dw $0552,$0553,$0554,$0555,$0556,$0557,$0558,$0559,$055A,$055B,$055C,$055D,$055E,$055F,$0560,$0561,$0562,$0563		; team 22
	dw $0449,$0564,$0565,$0566,$0567,$0568,$0569,$056A,$0451,$0435,$056B,$056C,$056D,$056E,$056F,$0570,$0571,$043D		; team 23
	dw $0572,$0573,$0574,$0575,$0576,$0577,$0578,$0579,$0407,$057A,$057B,$057C,$057D,$057E,$057F,$0580,$0581,$0582		; team 24
	dw $0583,$0584,$0585,$0586,$0587,$0588,$0589,$058A,$058B,$058C,$058D,$058E,$058F,$0590,$0591,$0592,$0593,$0594		; team 25
DrawFrame:		;auto: CODE_87CE62 (from addframe). SNES: as DrawFrameHi (bank85_F000) for frames below $293 with 4-byte pieces (x, y signed bytes, tile, attributes); sprnodraw skips the upload; a full
		;   cache shortens sprslotlife first
	lda.b farptr+1
	sta.b sprtileptr+1
	lda.b farptr
	clc
	adc.w #$0200
	sta.b sprtileptr
	lda.b sprhflip
	beq .vf
	lda.w #$0040
	sta.b sprhflip
.vf:
	lda.b sprvflip
	beq .fr
	lda.w #$0080
	sta.b sprvflip
.fr:
	lda.b sprframe
	asl a
	adc.w #$000A
	tay
	lda.b [farptr],y
	sta.b sprframe
	iny
	iny
	lda.b [farptr],y
	sec
	sbc.b sprframe
	bne .cnt
	jmp.w addframe_end
.cnt:
	sta.w sprpieces
.piece:		;next piece; OAM full (128): done
	lda.b sprcount
	cmp.w #$0080
	bne .pc
	jmp.w addframe_end
.pc:
	lda.b sprframe
	asl a
	asl a
	ldy.w #$0006
	adc.b [farptr],y
	tay
	lda.b [farptr],y
	and.w #$00FF
	bit.w #$0080
	beq .px
	ora.w #$FF00
.px:
	sta.b sprox
	iny
	lda.b [farptr],y
	and.w #$00FF
	bit.w #$0080
	beq .py
	ora.w #$FF00
.py:
	sta.b sproy
	iny
	lda.b [farptr],y
	and.w #$03FF
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b sprtile
	iny
	lda.b [farptr],y
	tax
	lsr a
	lsr a
	clc
	adc.b sprflag
	and.w #$0007
	asl a
	sta.b sprpal
	cmp.w #$0004
	bne .size
	lda.b sprflag
	bpl .size
	lda.w #$0006
	sta.b sprpal
.size:
	txa
	and.w #$00C0
	sta.b sprpattr
	txa
	and.w #$0020
	beq .small
	jmp.w .big
.small:
	lda.b sprhflip
	beq .sx
	lda.w #$FFF9
	sec
	sbc.b sprox
	sta.b sprox
.sx:
	lda.b sprx
	clc
	adc.b sprox
	sta.b sprox
	sec
	sbc.w #$FFF9
	bmi .v1
	bvc .x2
.off1:
	jmp.w .skip
.v1:
	bvc .off1
.x2:
	lda.b sprox
	sec
	sbc.w #$00FF
	beq .sy
	bmi .v2
	bvs .sy
.off2:
	jmp.w .skip
.v2:
	bvs .off2
.sy:
	lda.b sprvflip
	beq .y1
	lda.w #$FFF9
	sec
	sbc.b sproy
	sta.b sproy
.y1:
	lda.b spry
	clc
	adc.b sproy
	sta.b sproy
	sec
	sbc.w #$FFF9
	bmi .v3
	bvc .y2
.off3:
	jmp.w .skip
.v3:
	bvc .off3
.y2:
	lda.b sproy
	sec
	sbc.w #$00DF
	beq .cache
	bmi .v4
	bvs .cache
.off4:
	jmp.w .skip
.v4:
	bvs .off4
.cache:
	lda.b sprframe
	clc
	adc.b sprsetofs
	cmp.w #$131D
.hang1:
	bcs .hang1
	asl a
	asl a
	tax
	lda.b sprclock
	sec
	sbc.l sprframetime,x
	cmp.b sprslotlife
	bcc .have
	lda.b sprnodraw
	beq .find
	jmp.w addframe_end
.find:
	lda.b sprslot
	inc a
	and.w #$01FF
	sta.b sprslot
	cmp.b sprslotend
	bne .chk
	lda.b sprslotlife
	cmp.w #$0005
	bcs .shorten
	jml.l addframe_full		; bank $8F: VRAM sprite cache full
.shorten:
	dec.b sprslotlife
	lda.b sprslot
.chk:
	asl a
	tax
	lda.b sprclock
	sec
	sbc.w sprslottime,x
	cmp.b sprslotlife
	bcc .find
	txa
	asl a
	asl a
	asl a
	adc.w #$6000
	ldx.b DMAListend
.hang2:
	cpx.w #$0578
	bcs .hang2
	sta.w DMAList+dmavram,x
	lda.b farptr+2
	sta.w DMAList+dmabank,x
	ldy.w #$0008
	lda.b [farptr],y
	adc.b sprtile
	adc.b farptr
	sta.w DMAList,x
	lda.w #$0020
	sta.w DMAList+dmalen,x
	txa
	adc.w #$0007
	sta.b DMAListend
	lda.b sprframe
	adc.b sprsetofs
	asl a
	asl a
	tax
	lda.b sprslot
	sta.l sprframetime+2,x
.have:
	lda.b sprclock
	sta.l sprframetime,x
	lda.l sprframetime+2,x
	sta.b sprtile
	asl a
	tax
	lda.b sprclock
	sta.w sprslottime,x
	lda.b sprcount
	asl a
	asl a
	tax
	lda.b sprox
	sta.w Satt,x
	lda.b sproy
	sta.w Satt+1,x
	lda.b sprtile
	sta.w Satt+2,x
	xba
	sep #$20
	ora.b sprpal
	ora.b sprpriority
	ora.b sprpattr
	eor.b sprhflip
	eor.b sprvflip
	sta.w Satt+3,x
	rep #$30
	lda.b sprcount
	and.w #$0003
	tax
	lda.l .himask,x
	tay
	lda.b sprcount
	lsr a
	lsr a
	tax
	sep #$20
	tya
	and.w SattHi,x
	sta.w SattHi,x
	lda.b sprox+1
	bpl .next
	tya
	eor.b #$FF
	ora.w SattHi,x
	sta.w SattHi,x
.next:
	rep #$30
	inc.b sprcount
	jmp.w .skip
.himask:		;SattHi masks that clear the x bit 8 of sprite 0-3 in a byte
	db $FE,$FB,$EF,$BF
.big:
	lda.b sprhflip
	beq .bx
	lda.w #$FFF1
	sec
	sbc.b sprox
	sta.b sprox
.bx:
	lda.b sprx
	clc
	adc.b sprox
	sta.b sprox
	sec
	sbc.w #$FFF1
	bmi .bv1
	bvc .bx2
.boff1:
	jmp.w .skip
.bv1:
	bvc .boff1
.bx2:
	lda.b sprox
	sec
	sbc.w #$00FF
	beq .by
	bmi .bv2
	bvs .by
.boff2:
	jmp.w .skip
.bv2:
	bvs .boff2
.by:
	lda.b sprvflip
	beq .by1
	lda.w #$FFF1
	sec
	sbc.b sproy
	sta.b sproy
.by1:
	lda.b spry
	clc
	adc.b sproy
	sta.b sproy
	sec
	sbc.w #$FFF1
	bmi .bv3
	bvc .by2
.boff3:
	jmp.w .skip
.bv3:
	bvc .boff3
.by2:
	lda.b sproy
	sec
	sbc.w #$00DF
	beq .bcache
	bmi .bv4
	bvs .bcache
.boff4:
	jmp.w .skip
.bv4:
	bvs .boff4
.bcache:
	lda.b sprframe
	clc
	adc.b sprsetofs
	cmp.w #$131D
.hang3:
	bcs .hang3
	asl a
	asl a
	tax
	lda.b sprclock
	sec
	sbc.l sprframetime,x
	cmp.b sprslotlife
	bcs .bfind
	jmp.w .bhave
.bfind:
	lda.b sprnodraw
	beq .bfind2
	jmp.w addframe_end
.bfind2:
	lda.b sprbigslot
	inc a
	and.w #$01FF
	sta.b sprbigslot
	cmp.b sprbigslotend
	bne .bchk
	lda.b sprslotlife
	cmp.w #$0005
	bcs .bshorten
	jml.l addframe_full		; bank $8F: VRAM sprite cache full
.bshorten:
	dec.b sprslotlife
	lda.b sprbigslot
.bchk:
	and.w #$000F
	cmp.w #$000F
	beq .bfind2
	lda.b sprbigslot
	and.w #$00F0
	cmp.w #$00F0
	beq .bfind2
	lda.b sprbigslot
	asl a
	tax
	lda.b sprclock
	sec
	sbc.w sprslottime,x
	cmp.b sprslotlife
	bcc .bfind2
	lda.b sprclock
	sec
	sbc.w sprslottime+2,x
	cmp.b sprslotlife
	bcc .bfind2
	lda.b sprclock
	sec
	sbc.w sprslottime+$20,x
	cmp.b sprslotlife
	bcc .bfind2
	lda.b sprclock
	sec
	sbc.w sprslottime+$22,x
	cmp.b sprslotlife
	bcc .bfind2
	txa
	asl a
	asl a
	asl a
	adc.w #$6000
	ldx.b DMAListend
.bhang:
	cpx.w #$0571
	bcs .bhang
	sta.w DMAList+dmavram,x
	adc.w #$0100
	sta.w DMAList+dmasize+dmavram,x
	lda.b farptr+2
	sta.w DMAList+dmabank,x
	sta.w DMAList+dmasize+dmabank,x
	lda.w #$0040
	sta.w DMAList+dmalen,x
	sta.w DMAList+dmasize+dmalen,x
	ldy.w #$0008
	lda.b [farptr],y
	adc.b sprtile
	adc.b farptr
	sta.w DMAList,x
	adc.w #$0200
	sta.w DMAList+dmasize+dmasrc,x
	txa
	adc.w #$000E
	sta.b DMAListend
	lda.b sprframe
	clc
	adc.b sprsetofs
	asl a
	asl a
	tax
	lda.b sprbigslot
	sta.l sprframetime+2,x
.bhave:
	lda.b sprclock
	sta.l sprframetime,x
	lda.l sprframetime+2,x
	sta.b sprtile
	asl a
	tax
	lda.b sprclock
	sta.w sprslottime,x
	sta.w sprslottime+2,x
	sta.w sprslottime+$20,x
	sta.w sprslottime+$22,x
	lda.b sprcount
	asl a
	asl a
	tax
	lda.b sprox
	sta.w Satt,x
	lda.b sproy
	sta.w Satt+1,x
	lda.b sprtile
	sta.w Satt+2,x
	xba
	sep #$20
	ora.b sprpal
	ora.b sprpriority
	ora.b sprpattr
	eor.b sprhflip
	eor.b sprvflip
	sta.w Satt+3,x
	rep #$30
	lda.b sprcount
	and.w #$0003
	tax
	lda.l .himask,x
	tay
	lda.b sprcount
	lsr a
	lsr a
	tax
	sep #$20
	tya
	and.w SattHi,x
	sta.w SattHi,x
	tya
	eor.b #$FF
	asl a
	ora.w SattHi,x
	sta.w SattHi,x
	lda.b sprox+1
	bpl .bnext
	tya
	eor.b #$FF
	ora.w SattHi,x
	sta.w SattHi,x
.bnext:
	rep #$30
	inc.b sprcount
.skip:
	inc.b sprframe
	dec.w sprpieces
	beq addframe_end
	jmp.w .piece
addframe_end:		;auto: CODE_87D1FE. SNES addframe end: clear sprhflip, sprvflip, sprflag
	stz.b sprhflip
	stz.b sprvflip
	stz.b sprflag
	rtl
