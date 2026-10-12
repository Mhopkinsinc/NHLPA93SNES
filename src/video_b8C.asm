; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $8C. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8CFC1A
checksso:		;do graphics for sso structure: arrows for the two players when they are off screen.
		;   SNES: falls into .ca for player 2
	lda.w #2		; player 1: ffo 1, sso 0, SPFarrow
	sta.b a0
	stz.b a3
	lda.w #SPFarrow
	sta.b d3
	jsl.l .ca
	inc.b a0
	inc.b a0
	inc.b a3
	inc.b a3
	lda.w #SPFarrow+3		; player 2: SPFarrow+3
	sta.b d3
	jsl.l .ca
.rtl:
	rtl
.ca:		;a0 = pad object (ffo index), a3 = sso, d3 = first arrow frame
	ldy.b a0
	lda.w ffoz,y
	bmi .rtl
	ldx.b a3
	lda.w #$FFFF		; frame -1: no arrow
	sta.w ssoframe,x
	lda.w ffox,y
	sta.b d0
	lda.w ffoy,y
	sta.b d1
	lda.w sfhormode
	beq .nhor
	lda.b d1		; horizontal rink: x = -y, y = x - $C5
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w ffox,y
	sec
	sbc.w #$C5
	sta.b d1
	bra .hord
.nhor:
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.hord:		;d2 = off-screen directions as joystick bits
	stz.b d2
	lda.b d0
	sec
	sbc.w #116		; right of the screen
	bmi .r0
	bvc .rb
	bra .0
.r0:
	bvc .0
.rb:
	lda.w #8
	sta.b d2
.0:
	lda.b d0
	sec
	sbc.w #-116		; left
	beq .lb
	bmi .neg
	bvs .lb
	bra .1
.neg:
	bvs .1
.lb:
	lda.w #4
	tsb.b d2
.1:
	lda.b d1
	sec
	sbc.w #100		; above
	bmi .u0
	bvc .ub
	bra .2
.u0:
	bvc .2
.ub:
	inc.b d2
.2:
	lda.b d1
	sec
	sbc.w #-100		; below
	beq .db
	bmi .d0
	bvs .db
	bra .3
.d0:
	bvs .3
.db:
	inc.b d2
	inc.b d2
.3:
	ldx.b d2		; on screen: no arrow
	bne .off
	jmp.w .rtl
.off:
	lda.l jdtab8F,x		; direction 0-7
	and.w #$00FF
	asl a
	asl a
	asl a
	tax
	lda.l .tab,x		; .tab: x spot (0 = keep), y spot, frame add, flip bits
	beq .4
	sta.b d0
.4:
	lda.b d0
	clc
	adc.w #$0100
	ldy.b a3
	sta.w ssox,y
	lda.l .tab+2,x
	beq .5
	sta.b d1
.5:
	lda.b d1
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00F0
	sta.w ssoy,y
	lda.b d3
	clc
	adc.l .tab+4,x
	sta.w ssoframe,y
	lda.l .tab+6,x
	sta.w ssoattr,y
	ldx.b a3
	lda.w ssox,x
	sec
	sbc.w #$0080
	sta.b sprx
	lda.w ssoy,x
	sec
	sbc.w #$0080
	sta.b spry
	lda.w ssoframe,x
	sta.b sprframe
	lda.w ssoattr,x
	and.w #attrxflip
	sta.b sprhflip
	lda.w ssoattr,x
	and.w #$1000
	sta.b sprvflip
	jml.l addframe		; bank $8F
.tab:		;x spot, y spot, frame add, flip bits per direction (.xspot 116, .yspot 100)
	dw 0,100,0,$0000
	dw 116,100,1,$0000
	dw 116,0,2,$0000
	dw 116,-100,1,$1000
	dw 0,-100,0,$1000
	dw -116,-100,1,$1800
	dw -116,0,2,$0800
	dw -116,100,1,$0800
