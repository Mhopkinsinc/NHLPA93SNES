; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $87. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $87CE62
DrawFrame:		;SNES: as DrawFrameHi with 4-byte pieces (x, y signed bytes, tile, attributes); sprnodraw skips the upload; a full
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
	bne .data
	jmp.w addframe_end
.data:
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
	bmi .xlov
	bvc .xhi
.xloout:
	jmp.w .skip
.xlov:
	bvc .xloout
.xhi:
	lda.b sprox
	sec
	sbc.w #$00FF
	beq .sy
	bmi .xhiv
	bvs .sy
.xhiout:
	jmp.w .skip
.xhiv:
	bvs .xhiout
.sy:
	lda.b sprvflip
	beq .ylo
	lda.w #$FFF9
	sec
	sbc.b sproy
	sta.b sproy
.ylo:
	lda.b spry
	clc
	adc.b sproy
	sta.b sproy
	sec
	sbc.w #$FFF9
	bmi .ylov
	bvc .yhi
.yloout:
	jmp.w .skip
.ylov:
	bvc .yloout
.yhi:
	lda.b sproy
	sec
	sbc.w #$00DF
	beq .cache
	bmi .yhiv
	bvs .cache
.yhiout:
	jmp.w .skip
.yhiv:
	bvs .yhiout
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
	bmi .bxlov
	bvc .bxhi
.bxloout:
	jmp.w .skip
.bxlov:
	bvc .bxloout
.bxhi:
	lda.b sprox
	sec
	sbc.w #$00FF
	beq .by
	bmi .bxhiv
	bvs .by
.bxhiout:
	jmp.w .skip
.bxhiv:
	bvs .bxhiout
.by:
	lda.b sprvflip
	beq .bylo
	lda.w #$FFF1
	sec
	sbc.b sproy
	sta.b sproy
.bylo:
	lda.b spry
	clc
	adc.b sproy
	sta.b sproy
	sec
	sbc.w #$FFF1
	bmi .bylov
	bvc .byhi
.byloout:
	jmp.w .skip
.bylov:
	bvc .byloout
.byhi:
	lda.b sproy
	sec
	sbc.w #$00DF
	beq .bcache
	bmi .byhiv
	bvs .bcache
.byhiout:
	jmp.w .skip
.byhiv:
	bvs .byhiout
.bcache:
	lda.b sprframe
	clc
	adc.b sprsetofs
	cmp.w #$131D
.bhang1:
	bcs .bhang1
	asl a
	asl a
	tax
	lda.b sprclock
	sec
	sbc.l sprframetime,x
	cmp.b sprslotlife
	bcs .bnodraw
	jmp.w .bhave
.bnodraw:
	lda.b sprnodraw
	beq .bfind
	jmp.w addframe_end
.bfind:
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
.bhang2:
	cpx.w #$0571
	bcs .bhang2
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
