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
	lda.b sprnodraw		; $85FBB9: A5 C7
	beq .go		; $85FBBB: F0 04
	jml.l addframe_end		; $85FBBD: 5C FE D1 87
.go:		;sprtileptr = the set + $200 (tiles)
	lda.b farptr+1		; $85FBC1: A5 0D
	sta.b sprtileptr+1		; $85FBC3: 85 10
	lda.b farptr		; $85FBC5: A5 0C
	clc		; $85FBC7: 18
	adc.w #$0200		; $85FBC8: 69 00 02
	sta.b sprtileptr		; $85FBCB: 85 0F
	lda.b sprhflip		; $85FBCD: A5 A5
	beq .fr		; $85FBCF: F0 05
	lda.w #$0040		; $85FBD1: A9 40 00
	sta.b sprhflip		; $85FBD4: 85 A5
.fr:		;first and next piece of the frame: sprpieces = count
	lda.b sprframe		; $85FBD6: A5 C3
	asl a		; $85FBD8: 0A
	adc.w #$000A		; $85FBD9: 69 0A 00
	tay		; $85FBDC: A8
	lda.b [farptr],y		; $85FBDD: B7 0C
	sta.b sprframe		; $85FBDF: 85 C3
	iny		; $85FBE1: C8
	iny		; $85FBE2: C8
	lda.b [farptr],y		; $85FBE3: B7 0C
	sec		; $85FBE5: 38
	sbc.b sprframe		; $85FBE6: E5 C3
	bne .cnt		; $85FBE8: D0 04
	jml.l addframe_end		; $85FBEA: 5C FE D1 87
.cnt:
	sta.w sprpieces		; $85FBEE: 8D 87 04
.piece:		;next piece; OAM full (128): done
	lda.b sprcount		; $85FBF1: A5 A9
	cmp.w #$0080		; $85FBF3: C9 80 00
	bne .pc		; $85FBF6: D0 04
	jml.l addframe_end		; $85FBF8: 5C FE D1 87
.pc:		;sprox/sproy = piece x/y + sprx/spry, sprtile, sprpal, sprpattr from the 6-byte piece
	lda.b sprframe		; $85FBFC: A5 C3
	asl a		; $85FBFE: 0A
	asl a		; $85FBFF: 0A
	adc.b sprframe		; $85FC00: 65 C3
	adc.b sprframe		; $85FC02: 65 C3
	ldy.w #$0006		; $85FC04: A0 06 00
	adc.b [farptr],y		; $85FC07: 77 0C
	tay		; $85FC09: A8
	lda.b [farptr],y		; $85FC0A: B7 0C
	sta.b sprox		; $85FC0C: 85 BD
	iny		; $85FC0E: C8
	iny		; $85FC0F: C8
	lda.b [farptr],y		; $85FC10: B7 0C
	clc		; $85FC12: 18
	adc.b spry		; $85FC13: 65 CB
	sta.b sproy		; $85FC15: 85 BF
	iny		; $85FC17: C8
	iny		; $85FC18: C8
	lda.b [farptr],y		; $85FC19: B7 0C
	and.w #$03FF		; $85FC1B: 29 FF 03
	asl a		; $85FC1E: 0A
	asl a		; $85FC1F: 0A
	asl a		; $85FC20: 0A
	asl a		; $85FC21: 0A
	asl a		; $85FC22: 0A
	sta.b sprtile		; $85FC23: 85 B9
	iny		; $85FC25: C8
	lda.b [farptr],y		; $85FC26: B7 0C
	tax		; $85FC28: AA
	lsr a		; $85FC29: 4A
	lsr a		; $85FC2A: 4A
	clc		; $85FC2B: 18
	adc.b sprflag		; $85FC2C: 65 AB
	and.w #$0007		; $85FC2E: 29 07 00
	asl a		; $85FC31: 0A
	sta.b sprpal		; $85FC32: 85 AD
	cmp.w #$0004		; $85FC34: C9 04 00
	bne .size		; $85FC37: D0 09
	lda.b sprflag		; $85FC39: A5 AB
	bpl .size		; $85FC3B: 10 05
	lda.w #$0006		; $85FC3D: A9 06 00
	sta.b sprpal		; $85FC40: 85 AD
.size:		;bit 5 of the attribute: 16 x 16 piece
	txa		; $85FC42: 8A
	and.w #$00C0		; $85FC43: 29 C0 00
	sta.b sprpattr		; $85FC46: 85 AF
	txa		; $85FC48: 8A
	and.w #$0020		; $85FC49: 29 20 00
	beq .small		; $85FC4C: F0 03
	jmp.w .big		; $85FC4E: 4C 7D FD
.small:
	lda.b sprhflip		; $85FC51: A5 A5
	beq .sx		; $85FC53: F0 0C
	lda.b sprox		; $85FC55: A5 BD
	eor.w #$FFFF		; $85FC57: 49 FF FF
	inc a		; $85FC5A: 1A
	sec		; $85FC5B: 38
	sbc.w #$0007		; $85FC5C: E9 07 00
	sta.b sprox		; $85FC5F: 85 BD
.sx:
	lda.b sprx		; $85FC61: A5 C9
	clc		; $85FC63: 18
	adc.b sprox		; $85FC64: 65 BD
	sta.b sprox		; $85FC66: 85 BD
	sec		; $85FC68: 38
	sbc.w #$FFF9		; $85FC69: E9 F9 FF
	bmi .v1		; $85FC6C: 30 05
	bvc .x2		; $85FC6E: 50 05
.off1:
	jmp.w .skip		; $85FC70: 4C FD FE
.v1:
	bvc .off1		; $85FC73: 50 FB
.x2:
	lda.b sprox		; $85FC75: A5 BD
	sec		; $85FC77: 38
	sbc.w #$00FF		; $85FC78: E9 FF 00
	beq .y1		; $85FC7B: F0 09
	bmi .v2		; $85FC7D: 30 05
	bvs .y1		; $85FC7F: 70 05
.off2:
	jmp.w .skip		; $85FC81: 4C FD FE
.v2:
	bvs .off2		; $85FC84: 70 FB
.y1:
	lda.b sproy		; $85FC86: A5 BF
	sec		; $85FC88: 38
	sbc.w #$FFF9		; $85FC89: E9 F9 FF
	bmi .v3		; $85FC8C: 30 05
	bvc .y2		; $85FC8E: 50 05
.off3:
	jmp.w .skip		; $85FC90: 4C FD FE
.v3:
	bvc .off3		; $85FC93: 50 FB
.y2:
	lda.b sproy		; $85FC95: A5 BF
	sec		; $85FC97: 38
	sbc.w #$00DF		; $85FC98: E9 DF 00
	beq .cache		; $85FC9B: F0 09
	bmi .v4		; $85FC9D: 30 05
	bvs .cache		; $85FC9F: 70 05
.off4:
	jmp.w .skip		; $85FCA1: 4C FD FE
.v4:
	bvs .off4		; $85FCA4: 70 FB
.cache:		;cached and still fresh: reuse its slot
	lda.b sprframe		; $85FCA6: A5 C3
	clc		; $85FCA8: 18
	adc.b sprsetofs		; $85FCA9: 65 C5
	cmp.w #$131D		; $85FCAB: C9 1D 13
.hang1:		;frame number out of range: hang
	bcs .hang1		; $85FCAE: B0 FE
	asl a		; $85FCB0: 0A
	asl a		; $85FCB1: 0A
	tax		; $85FCB2: AA
	lda.b sprclock		; $85FCB3: A5 A7
	sec		; $85FCB5: 38
	sbc.l sprframetime,x		; $85FCB6: FF 00 20 7E
	cmp.b sprslotlife		; $85FCBA: C5 C1
	bcc .have		; $85FCBC: 90 57
.find:		;find a free 8x8 slot
	lda.b sprslot		; $85FCBE: A5 B5
	inc a		; $85FCC0: 1A
	and.w #$01FF		; $85FCC1: 29 FF 01
	sta.b sprslot		; $85FCC4: 85 B5
	cmp.b sprslotend		; $85FCC6: C5 B7
	bne .chk		; $85FCC8: D0 04
	jml.l $8FDAF3		; $85FCCA: 5C F3 DA 8F  bank $8F: VRAM sprite cache full
.chk:
	asl a		; $85FCCE: 0A
	tax		; $85FCCF: AA
	lda.b sprclock		; $85FCD0: A5 A7
	sec		; $85FCD2: 38
	sbc.w sprslottime,x		; $85FCD3: FD AB 04
	cmp.b sprslotlife		; $85FCD6: C5 C1
	bcc .find		; $85FCD8: 90 E4
	txa		; $85FCDA: 8A
	asl a		; $85FCDB: 0A
	asl a		; $85FCDC: 0A
	asl a		; $85FCDD: 0A
	adc.w #$6000		; $85FCDE: 69 00 60
	ldx.b DMAListend		; $85FCE1: A6 A3
.hang2:		;dma list full: hang
	cpx.w #$0578		; $85FCE3: E0 78 05
	bcs .hang2		; $85FCE6: B0 FB
	sta.w DMAList+dmavram,x		; $85FCE8: 9D 58 16
	lda.b farptr+2		; $85FCEB: A5 0E
	sta.w DMAList+dmabank,x		; $85FCED: 9D 55 16
	ldy.w #$0008		; $85FCF0: A0 08 00
	lda.b [farptr],y		; $85FCF3: B7 0C
	adc.b sprtile		; $85FCF5: 65 B9
	adc.b farptr		; $85FCF7: 65 0C
	sta.w DMAList,x		; $85FCF9: 9D 53 16
	lda.w #$0020		; $85FCFC: A9 20 00
	sta.w DMAList+dmalen,x		; $85FCFF: 9D 56 16
	txa		; $85FD02: 8A
	adc.w #$0007		; $85FD03: 69 07 00
	sta.b DMAListend		; $85FD06: 85 A3
	lda.b sprframe		; $85FD08: A5 C3
	adc.b sprsetofs		; $85FD0A: 65 C5
	asl a		; $85FD0C: 0A
	asl a		; $85FD0D: 0A
	tax		; $85FD0E: AA
	lda.b sprslot		; $85FD0F: A5 B5
	sta.l sprframetime+2,x		; $85FD11: 9F 02 20 7E
.have:		;mark frame and slot used now, write the OAM entry
	lda.b sprclock		; $85FD15: A5 A7
	sta.l sprframetime,x		; $85FD17: 9F 00 20 7E
	lda.l sprframetime+2,x		; $85FD1B: BF 02 20 7E
	sta.b sprtile		; $85FD1F: 85 B9
	asl a		; $85FD21: 0A
	tax		; $85FD22: AA
	lda.b sprclock		; $85FD23: A5 A7
	sta.w sprslottime,x		; $85FD25: 9D AB 04
	lda.b sprcount		; $85FD28: A5 A9
	asl a		; $85FD2A: 0A
	asl a		; $85FD2B: 0A
	tax		; $85FD2C: AA
	lda.b sprox		; $85FD2D: A5 BD
	sta.w Satt,x		; $85FD2F: 9D FF 01
	lda.b sproy		; $85FD32: A5 BF
	sta.w Satt+1,x		; $85FD34: 9D 00 02
	lda.b sprtile		; $85FD37: A5 B9
	sta.w Satt+2,x		; $85FD39: 9D 01 02
	xba		; $85FD3C: EB
	sep #$20		; $85FD3D: E2 20
	ora.b sprpal		; $85FD3F: 05 AD
	ora.b sprpriority		; $85FD41: 05 BB
	ora.b sprpattr		; $85FD43: 05 AF
	eor.b sprhflip		; $85FD45: 45 A5
	sta.w Satt+3,x		; $85FD47: 9D 02 02
	rep #$30		; $85FD4A: C2 30
	lda.b sprcount		; $85FD4C: A5 A9
	and.w #$0003		; $85FD4E: 29 03 00
	tax		; $85FD51: AA
	lda.l .himask,x		; $85FD52: BF 79 FD 85
	tay		; $85FD56: A8
	lda.b sprcount		; $85FD57: A5 A9
	lsr a		; $85FD59: 4A
	lsr a		; $85FD5A: 4A
	tax		; $85FD5B: AA
	sep #$20		; $85FD5C: E2 20
	tya		; $85FD5E: 98
	and.w SattHi,x		; $85FD5F: 3D FF 03
	sta.w SattHi,x		; $85FD62: 9D FF 03
	lda.b sprox+1		; $85FD65: A5 BE
	bpl .next		; $85FD67: 10 09
	tya		; $85FD69: 98
	eor.b #$FF		; $85FD6A: 49 FF
	ora.w SattHi,x		; $85FD6C: 1D FF 03
	sta.w SattHi,x		; $85FD6F: 9D FF 03
.next:
	rep #$30		; $85FD72: C2 30
	inc.b sprcount		; $85FD74: E6 A9
	jmp.w .skip		; $85FD76: 4C FD FE
.himask:		;SattHi masks that clear the x bit 8 of sprite 0-3 in a byte
	db $FE,$FB,$EF,$BF		; $85FD79
.big:		;16 x 16 piece
	lda.b sprhflip		; $85FD7D: A5 A5
	beq .bx		; $85FD7F: F0 0C
	lda.b sprox		; $85FD81: A5 BD
	eor.w #$FFFF		; $85FD83: 49 FF FF
	inc a		; $85FD86: 1A
	sec		; $85FD87: 38
	sbc.w #$000F		; $85FD88: E9 0F 00
	sta.b sprox		; $85FD8B: 85 BD
.bx:
	lda.b sprx		; $85FD8D: A5 C9
	clc		; $85FD8F: 18
	adc.b sprox		; $85FD90: 65 BD
	sta.b sprox		; $85FD92: 85 BD
	sec		; $85FD94: 38
	sbc.w #$FFF1		; $85FD95: E9 F1 FF
	bmi .bv1		; $85FD98: 30 05
	bvc .bx2		; $85FD9A: 50 05
.boff1:
	jmp.w .skip		; $85FD9C: 4C FD FE
.bv1:
	bvc .boff1		; $85FD9F: 50 FB
.bx2:
	lda.b sprox		; $85FDA1: A5 BD
	sec		; $85FDA3: 38
	sbc.w #$00FF		; $85FDA4: E9 FF 00
	beq .by1		; $85FDA7: F0 09
	bmi .bv2		; $85FDA9: 30 05
	bvs .by1		; $85FDAB: 70 05
.boff2:
	jmp.w .skip		; $85FDAD: 4C FD FE
.bv2:
	bvs .boff2		; $85FDB0: 70 FB
.by1:
	lda.b sproy		; $85FDB2: A5 BF
	sec		; $85FDB4: 38
	sbc.w #$FFF1		; $85FDB5: E9 F1 FF
	bmi .bv3		; $85FDB8: 30 05
	bvc .by2		; $85FDBA: 50 05
.boff3:
	jmp.w .skip		; $85FDBC: 4C FD FE
.bv3:
	bvc .boff3		; $85FDBF: 50 FB
.by2:
	lda.b sproy		; $85FDC1: A5 BF
	sec		; $85FDC3: 38
	sbc.w #$00DF		; $85FDC4: E9 DF 00
	beq .bcache		; $85FDC7: F0 09
	bmi .bv4		; $85FDC9: 30 05
	bvs .bcache		; $85FDCB: 70 05
.boff4:
	jmp.w .skip		; $85FDCD: 4C FD FE
.bv4:
	bvs .boff4		; $85FDD0: 70 FB
.bcache:
	lda.b sprframe		; $85FDD2: A5 C3
	clc		; $85FDD4: 18
	adc.b sprsetofs		; $85FDD5: 65 C5
	cmp.w #$131D		; $85FDD7: C9 1D 13
.hang3:
	bcs .hang3		; $85FDDA: B0 FE
	asl a		; $85FDDC: 0A
	asl a		; $85FDDD: 0A
	tax		; $85FDDE: AA
	lda.b sprclock		; $85FDDF: A5 A7
	sec		; $85FDE1: 38
	sbc.l sprframetime,x		; $85FDE2: FF 00 20 7E
	cmp.b sprslotlife		; $85FDE6: C5 C1
	bcs .bfind		; $85FDE8: B0 03
	jmp.w .bhave		; $85FDEA: 4C 89 FE
.bfind:		;find a free 16x16 slot: 4 free 8x8 slots in a 2 x 2 block, not in the last row/column
	lda.b sprbigslot		; $85FDED: A5 B1
	inc a		; $85FDEF: 1A
	and.w #$01FF		; $85FDF0: 29 FF 01
	sta.b sprbigslot		; $85FDF3: 85 B1
	cmp.b sprbigslotend		; $85FDF5: C5 B3
	bne .bchk		; $85FDF7: D0 04
	jml.l $8FDAF3		; $85FDF9: 5C F3 DA 8F  bank $8F: VRAM sprite cache full
.bchk:
	and.w #$000F		; $85FDFD: 29 0F 00
	cmp.w #$000F		; $85FE00: C9 0F 00
	beq .bfind		; $85FE03: F0 E8
	lda.b sprbigslot		; $85FE05: A5 B1
	and.w #$00F0		; $85FE07: 29 F0 00
	cmp.w #$00F0		; $85FE0A: C9 F0 00
	beq .bfind		; $85FE0D: F0 DE
	lda.b sprbigslot		; $85FE0F: A5 B1
	asl a		; $85FE11: 0A
	tax		; $85FE12: AA
	lda.b sprclock		; $85FE13: A5 A7
	sec		; $85FE15: 38
	sbc.w sprslottime,x		; $85FE16: FD AB 04
	cmp.b sprslotlife		; $85FE19: C5 C1
	bcc .bfind		; $85FE1B: 90 D0
	lda.b sprclock		; $85FE1D: A5 A7
	sec		; $85FE1F: 38
	sbc.w sprslottime+2,x		; $85FE20: FD AD 04
	cmp.b sprslotlife		; $85FE23: C5 C1
	bcc .bfind		; $85FE25: 90 C6
	lda.b sprclock		; $85FE27: A5 A7
	sec		; $85FE29: 38
	sbc.w sprslottime+$20,x		; $85FE2A: FD CB 04
	cmp.b sprslotlife		; $85FE2D: C5 C1
	bcc .bfind		; $85FE2F: 90 BC
	lda.b sprclock		; $85FE31: A5 A7
	sec		; $85FE33: 38
	sbc.w sprslottime+$22,x		; $85FE34: FD CD 04
	cmp.b sprslotlife		; $85FE37: C5 C1
	bcc .bfind		; $85FE39: 90 B2
	txa		; $85FE3B: 8A
	asl a		; $85FE3C: 0A
	asl a		; $85FE3D: 0A
	asl a		; $85FE3E: 0A
	adc.w #$6000		; $85FE3F: 69 00 60
	ldx.b DMAListend		; $85FE42: A6 A3
.hang4:
	cpx.w #$0571		; $85FE44: E0 71 05
	bcs .hang4		; $85FE47: B0 FB
	sta.w DMAList+dmavram,x		; $85FE49: 9D 58 16
	adc.w #$0100		; $85FE4C: 69 00 01
	sta.w DMAList+dmasize+dmavram,x		; $85FE4F: 9D 5F 16
	lda.b farptr+2		; $85FE52: A5 0E
	sta.w DMAList+dmabank,x		; $85FE54: 9D 55 16
	sta.w DMAList+dmasize+dmabank,x		; $85FE57: 9D 5C 16
	lda.w #$0040		; $85FE5A: A9 40 00
	sta.w DMAList+dmalen,x		; $85FE5D: 9D 56 16
	sta.w DMAList+dmasize+dmalen,x		; $85FE60: 9D 5D 16
	ldy.w #$0008		; $85FE63: A0 08 00
	lda.b [farptr],y		; $85FE66: B7 0C
	adc.b sprtile		; $85FE68: 65 B9
	adc.b farptr		; $85FE6A: 65 0C
	sta.w DMAList,x		; $85FE6C: 9D 53 16
	adc.w #$0200		; $85FE6F: 69 00 02
	sta.w DMAList+dmasize+dmasrc,x		; $85FE72: 9D 5A 16
	txa		; $85FE75: 8A
	adc.w #$000E		; $85FE76: 69 0E 00
	sta.b DMAListend		; $85FE79: 85 A3
	lda.b sprframe		; $85FE7B: A5 C3
	clc		; $85FE7D: 18
	adc.b sprsetofs		; $85FE7E: 65 C5
	asl a		; $85FE80: 0A
	asl a		; $85FE81: 0A
	tax		; $85FE82: AA
	lda.b sprbigslot		; $85FE83: A5 B1
	sta.l sprframetime+2,x		; $85FE85: 9F 02 20 7E
.bhave:		;mark the 4 slots, write the OAM entry (size bit set)
	lda.b sprclock		; $85FE89: A5 A7
	sta.l sprframetime,x		; $85FE8B: 9F 00 20 7E
	lda.l sprframetime+2,x		; $85FE8F: BF 02 20 7E
	sta.b sprtile		; $85FE93: 85 B9
	asl a		; $85FE95: 0A
	tax		; $85FE96: AA
	lda.b sprclock		; $85FE97: A5 A7
	sta.w sprslottime,x		; $85FE99: 9D AB 04
	sta.w sprslottime+2,x		; $85FE9C: 9D AD 04
	sta.w sprslottime+$20,x		; $85FE9F: 9D CB 04
	sta.w sprslottime+$22,x		; $85FEA2: 9D CD 04
	lda.b sprcount		; $85FEA5: A5 A9
	asl a		; $85FEA7: 0A
	asl a		; $85FEA8: 0A
	tax		; $85FEA9: AA
	lda.b sprox		; $85FEAA: A5 BD
	sta.w Satt,x		; $85FEAC: 9D FF 01
	lda.b sproy		; $85FEAF: A5 BF
	sta.w Satt+1,x		; $85FEB1: 9D 00 02
	lda.b sprtile		; $85FEB4: A5 B9
	sta.w Satt+2,x		; $85FEB6: 9D 01 02
	xba		; $85FEB9: EB
	sep #$20		; $85FEBA: E2 20
	ora.b sprpal		; $85FEBC: 05 AD
	ora.b sprpriority		; $85FEBE: 05 BB
	ora.b sprpattr		; $85FEC0: 05 AF
	eor.b sprhflip		; $85FEC2: 45 A5
	sta.w Satt+3,x		; $85FEC4: 9D 02 02
	rep #$30		; $85FEC7: C2 30
	lda.b sprcount		; $85FEC9: A5 A9
	and.w #$0003		; $85FECB: 29 03 00
	tax		; $85FECE: AA
	lda.l .himask,x		; $85FECF: BF 79 FD 85
	tay		; $85FED3: A8
	lda.b sprcount		; $85FED4: A5 A9
	lsr a		; $85FED6: 4A
	lsr a		; $85FED7: 4A
	tax		; $85FED8: AA
	sep #$20		; $85FED9: E2 20
	tya		; $85FEDB: 98
	and.w SattHi,x		; $85FEDC: 3D FF 03
	sta.w SattHi,x		; $85FEDF: 9D FF 03
	tya		; $85FEE2: 98
	eor.b #$FF		; $85FEE3: 49 FF
	asl a		; $85FEE5: 0A
	ora.w SattHi,x		; $85FEE6: 1D FF 03
	sta.w SattHi,x		; $85FEE9: 9D FF 03
	lda.b sprox+1		; $85FEEC: A5 BE
	bpl .bnext		; $85FEEE: 10 09
	tya		; $85FEF0: 98
	eor.b #$FF		; $85FEF1: 49 FF
	ora.w SattHi,x		; $85FEF3: 1D FF 03
	sta.w SattHi,x		; $85FEF6: 9D FF 03
.bnext:
	rep #$30		; $85FEF9: C2 30
	inc.b sprcount		; $85FEFB: E6 A9
.skip:		;next piece
	inc.b sprframe		; $85FEFD: E6 C3
	dec.w sprpieces		; $85FEFF: CE 87 04
	beq .done		; $85FF02: F0 03
	jmp.w .piece		; $85FF04: 4C F1 FB
.done:		;clear sprhflip, sprvflip, sprflag
	stz.b sprhflip		; $85FF07: 64 A5
	stz.b sprvflip		; $85FF09: 64 CD
	stz.b sprflag		; $85FF0B: 64 AB
	rtl		; $85FF0D: 6B
getpzjoy:		;auto: CODE_85FF0E. 93G getpzjoy (hockey93_02): read the joystick of the pad that paused (sfpj: Readjoy2, else Readjoy1)
	lda.w sflags		; $85FF0E: AD 8C 12
	bit.w #sfpj		; $85FF11: 89 02 00
	beq .p1		; $85FF14: F0 04
	jml.l Readjoy2		; $85FF16: 5C 29 C4 80
.p1:
	jml.l Readjoy1		; $85FF1A: 5C 0B C4 80
PrintTeamNames:		;auto: CODE_85FF1E. SNES: regular season: HomeTeam/VisTeam from the options; print both team names ($8D84E2), then $86FC29
	stx.b xsave		; $85FF1E: 86 0A
	ldx.w #$0000		; $85FF20: A2 00 00
.pushd:
	lda.b d0,x		; $85FF23: B5 53
	pha		; $85FF25: 48
	inx		; $85FF26: E8
	inx		; $85FF27: E8
	cpx.w #$0020		; $85FF28: E0 20 00
	bne .pushd		; $85FF2B: D0 F6
	ldx.b xsave		; $85FF2D: A6 0A
	stx.b xsave		; $85FF2F: 86 0A
	ldx.w #$0000		; $85FF31: A2 00 00
.pusha:
	lda.b a0,x		; $85FF34: B5 33
	pha		; $85FF36: 48
	inx		; $85FF37: E8
	inx		; $85FF38: E8
	cpx.w #$000C		; $85FF39: E0 0C 00
	bne .pusha		; $85FF3C: D0 F6
	ldx.b xsave		; $85FF3E: A6 0A
	lda.w OptPlayMode		; $85FF40: AD 00 16  OptPlayMode 0: teams from the options
	bne .pr		; $85FF43: D0 0C
	lda.w OptTeam1		; $85FF45: AD 04 16
	sta.w HomeTeam		; $85FF48: 8D 9A 12
	lda.w OptTeam2		; $85FF4B: AD 06 16
	sta.w VisTeam		; $85FF4E: 8D 9C 12
.pr:
	jsl.l printz		; $85FF51: 22 0C B9 80
	dw $0005		; $85FF55  printz inline string: length (counts itself), then control bytes / text
	db $BE,$02,$01
	lda.w VisTeam		; $85FF5A: AD 9C 12
	sta.b d1		; $85FF5D: 85 57
	jsl.l DrawTeamBlocks		; $85FF5F: 22 E2 84 8D  bank $8D: print team d1 name
	jsl.l printz		; $85FF63: 22 0C B9 80
	dw $0005		; $85FF67  printz inline string: length (counts itself), then control bytes / text
	db $BE,$15,$01
	lda.w HomeTeam		; $85FF6C: AD 9A 12
	sta.b d1		; $85FF6F: 85 57
	jsl.l DrawTeamBlocks		; $85FF71: 22 E2 84 8D  bank $8D: print team d1 name
	jsl.l setteams		; $85FF75: 22 29 FC 86
	stx.b xsave		; $85FF79: 86 0A
	ldx.w #$000A		; $85FF7B: A2 0A 00
.popa:
	pla		; $85FF7E: 68
	sta.b a0,x		; $85FF7F: 95 33
	dex		; $85FF81: CA
	dex		; $85FF82: CA
	bpl .popa		; $85FF83: 10 F9
	ldx.b xsave		; $85FF85: A6 0A
	stx.b xsave		; $85FF87: 86 0A
	ldx.w #$001E		; $85FF89: A2 1E 00
.popd:
	pla		; $85FF8C: 68
	sta.b d0,x		; $85FF8D: 95 53
	dex		; $85FF8F: CA
	dex		; $85FF90: CA
	bpl .popd		; $85FF91: 10 F9
	ldx.b xsave		; $85FF93: A6 0A
	rtl		; $85FF95: 6B
nullrtl85:		;auto: CODE_85FF96. does nothing
	rtl		; $85FF96: 6B
ResetClock:		;auto: CODE_85FF97. 93G ResetClock (hockey93_01): set the period length (GetPeriodTime; regular season overtime is 10:00) and stop the clock
	jsl.l GetPeriodTime		; $85FF97: 22 A1 FC 86
	lda.w gsp		; $85FF9B: AD F0 12  gsp >= 3 (overtime) and OptPlayMode 0: 600 seconds
	sec		; $85FF9E: 38
	sbc.w #$0003		; $85FF9F: E9 03 00
	bmi .v1		; $85FFA2: 30 04
	bvc .ot		; $85FFA4: 50 04
	bra .set		; $85FFA6: 80 0C
.v1:
	bvc .set		; $85FFA8: 50 0A
.ot:
	lda.w OptPlayMode		; $85FFAA: AD 00 16
	bne .set		; $85FFAD: D0 05
	lda.w #600		; $85FFAF: A9 58 02
	sta.b d0		; $85FFB2: 85 53
.set:
	lda.b d0		; $85FFB4: A5 53  gameclock = PerTimeTotal = d0, gmclock
	sta.w gameclock		; $85FFB6: 8D F2 12
	sta.w PerTimeTotal		; $85FFB9: 8D F6 12
	sta.w gmclock		; $85FFBC: 8D 8A 12
	rtl		; $85FFBF: 6B
unusedFF85:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $85FFC0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $85FFD0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $85FFE0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $85FFF0
