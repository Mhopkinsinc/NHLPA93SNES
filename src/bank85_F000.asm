; $85F000-$85FFFF  ROM $2F000-$2FFFF: the end of Title1Map (packed title screen, see bank85_D000), then DrawFrameHi: the SNES sprite
; emitter for addframe (OAM entries, the sprite VRAM tile cache and the tile dma list), getpzjoy, PrintTeamNames, ResetClock.
; The cache: sprframetime (4 bytes per frame: sprclock when sent, VRAM slot), sprslottime (sprclock per 32-byte slot);
; a slot is free when sprclock - its time >= sprslotlife.
org $85F000
	incbin "../data/Title1.map.pak":$1A40..$25F9		; $85F000-$85FBB8
Title1MapEnd:
	assert Title1MapEnd-Title1Map == $25F9
DrawFrameHi:		;auto: CODE_85FBB9 (from addframe_hi). SNES: draw frame sprframe ($293 and up, 6-byte pieces) of the frame set at [farptr] (sprsetofs = its first frame number) at sprx/spry: for each
		;   piece an OAM entry, and the piece tiles to a free VRAM slot through DMAList when not cached
	lda.b sprnodraw
	beq .go
	jml.l addframe_end
.go:		;sprtileptr = the set + $200 (tiles)
	lda.b farptr+1
	sta.b sprtileptr+1
	lda.b farptr
	clc
	adc.w #$0200
	sta.b sprtileptr
	lda.b sprhflip
	beq .fr
	lda.w #$0040
	sta.b sprhflip
.fr:		;first and next piece of the frame: sprpieces = count
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
	jml.l addframe_end
.cnt:
	sta.w sprpieces
.piece:		;next piece; OAM full (128): done
	lda.b sprcount
	cmp.w #$0080
	bne .pc
	jml.l addframe_end
.pc:		;sprox/sproy = piece x/y + sprx/spry, sprtile, sprpal, sprpattr from the 6-byte piece
	lda.b sprframe
	asl a
	asl a
	adc.b sprframe
	adc.b sprframe
	ldy.w #$0006
	adc.b [farptr],y
	tay
	lda.b [farptr],y
	sta.b sprox
	iny
	iny
	lda.b [farptr],y
	clc
	adc.b spry
	sta.b sproy
	iny
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
.size:		;bit 5 of the attribute: 16 x 16 piece
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
	lda.b sprox
	eor.w #$FFFF
	inc a
	sec
	sbc.w #$0007
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
	beq .y1
	bmi .v2
	bvs .y1
.off2:
	jmp.w .skip
.v2:
	bvs .off2
.y1:
	lda.b sproy
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
.cache:		;cached and still fresh: reuse its slot
	lda.b sprframe
	clc
	adc.b sprsetofs
	cmp.w #$131D
.hang1:		;frame number out of range: hang
	bcs .hang1
	asl a
	asl a
	tax
	lda.b sprclock
	sec
	sbc.l sprframetime,x
	cmp.b sprslotlife
	bcc .have
.find:		;find a free 8x8 slot
	lda.b sprslot
	inc a
	and.w #$01FF
	sta.b sprslot
	cmp.b sprslotend
	bne .chk
	jml.l addframe_full		; bank $8F: VRAM sprite cache full
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
.hang2:		;dma list full: hang
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
.have:		;mark frame and slot used now, write the OAM entry
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
.big:		;16 x 16 piece
	lda.b sprhflip
	beq .bx
	lda.b sprox
	eor.w #$FFFF
	inc a
	sec
	sbc.w #$000F
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
	beq .by1
	bmi .bv2
	bvs .by1
.boff2:
	jmp.w .skip
.bv2:
	bvs .boff2
.by1:
	lda.b sproy
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
.bfind:		;find a free 16x16 slot: 4 free 8x8 slots in a 2 x 2 block, not in the last row/column
	lda.b sprbigslot
	inc a
	and.w #$01FF
	sta.b sprbigslot
	cmp.b sprbigslotend
	bne .bchk
	jml.l addframe_full		; bank $8F: VRAM sprite cache full
.bchk:
	and.w #$000F
	cmp.w #$000F
	beq .bfind
	lda.b sprbigslot
	and.w #$00F0
	cmp.w #$00F0
	beq .bfind
	lda.b sprbigslot
	asl a
	tax
	lda.b sprclock
	sec
	sbc.w sprslottime,x
	cmp.b sprslotlife
	bcc .bfind
	lda.b sprclock
	sec
	sbc.w sprslottime+2,x
	cmp.b sprslotlife
	bcc .bfind
	lda.b sprclock
	sec
	sbc.w sprslottime+$20,x
	cmp.b sprslotlife
	bcc .bfind
	lda.b sprclock
	sec
	sbc.w sprslottime+$22,x
	cmp.b sprslotlife
	bcc .bfind
	txa
	asl a
	asl a
	asl a
	adc.w #$6000
	ldx.b DMAListend
.hang4:
	cpx.w #$0571
	bcs .hang4
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
.bhave:		;mark the 4 slots, write the OAM entry (size bit set)
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
.skip:		;next piece
	inc.b sprframe
	dec.w sprpieces
	beq .done
	jmp.w .piece
.done:		;clear sprhflip, sprvflip, sprflag
	stz.b sprhflip
	stz.b sprvflip
	stz.b sprflag
	rtl
getpzjoy:		;auto: CODE_85FF0E. 93G getpzjoy (hockey93_02): read the joystick of the pad that paused (sfpj: Readjoy2, else Readjoy1)
	lda.w sflags
	bit.w #sfpj
	beq .p1
	jml.l Readjoy2
.p1:
	jml.l Readjoy1
PrintTeamNames:		;auto: CODE_85FF1E. SNES: regular season: HomeTeam/VisTeam from the options; print both team names ($8D84E2), then $86FC29
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
	cpx.w #$000C
	bne .pusha
	ldx.b xsave
	lda.w OptPlayMode		; OptPlayMode 0: teams from the options
	bne .pr
	lda.w OptTeam1
	sta.w HomeTeam
	lda.w OptTeam2
	sta.w VisTeam
.pr:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$02,$01
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks		; bank $8D: print team d1 name
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$15,$01
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks		; bank $8D: print team d1 name
	jsl.l setteams
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
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
nullrtl85:		;auto: CODE_85FF96. does nothing
	rtl
ResetClock:		;auto: CODE_85FF97. 93G ResetClock (hockey93_01): set the period length (GetPeriodTime; regular season overtime is 10:00) and stop the clock
	jsl.l GetPeriodTime
	lda.w gsp		; gsp >= 3 (overtime) and OptPlayMode 0: 600 seconds
	sec
	sbc.w #$0003
	bmi .v1
	bvc .ot
	bra .set
.v1:
	bvc .set
.ot:
	lda.w OptPlayMode
	bne .set
	lda.w #600
	sta.b d0
.set:
	lda.b d0		; gameclock = PerTimeTotal = d0, gmclock
	sta.w gameclock
	sta.w PerTimeTotal
	sta.w gmclock
	rtl
unusedFF85:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
