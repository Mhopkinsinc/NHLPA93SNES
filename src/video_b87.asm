; video_b87: 93G video93_1/video93_2: vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $87. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $87CE62
DrawFrame:		;SNES: as DrawFrameHi (bank85_F000) for frames below $293 with 4-byte pieces (x, y signed bytes, tile, attributes); sprnodraw skips the upload; a full
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
addframe_end:		;SNES addframe end: clear sprhflip, sprvflip, sprflag
	stz.b sprhflip
	stz.b sprvflip
	stz.b sprflag
	rtl
