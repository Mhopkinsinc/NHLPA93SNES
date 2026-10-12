; Utilities (print, joypads, math, decompression).
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8F8682
PushNumber:		;convert d0 into string format of base 10 number, no leading zeros. Return a1 = string
		;   SNES: built down from the end of mesarea
	lda.w #mesarea+30
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
.0:
	sta.b mulb
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.b mulres
	bne .0
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl

org $8F87C9
appstring:		;append string a1 to string a3
		;   SNES: append string [a1] to the string [a3]
	lda.w #$0002
	sta.b tmp0
	lda.b [a3]
	sta.b tmp1
.loop:
	lda.b tmp0
	cmp.b [a1]
	beq .done
	tay
	lda.b [a1],y
	ldy.b tmp1
	sta.b [a3],y
	inc.b tmp0
	inc.b tmp1
	bra .loop
.done:
	lda.b tmp1
	sta.b [a3]
	rtl
PushTime:		;convert d0 into string format of minutes:seconds. Return a1 = string. 93 pads the minutes to 2 places with a space
		;   SNES: mesarea string m:ss of the time d0 (seconds)
	lda.w #mesarea+30
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
	sta.b mulb
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.w #$0006
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	dec.b a1
	lda.b #$3A
	sta.b [a1]
	rep #$30
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.b mulres
	beq .noz
	dec.b a1
	sep #$20
	adc.b #$30
	sta.b [a1]
	rep #$30
.noz:
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl

org $8F8AE9
waitxsr:		;special version of waitx for zamboni crossing
		;   SNES: wait d0 frames or until a pad button (d1)
	lda.b d0
	pha
.wait:
	jsl.l Readjoy1
	lda.b d1
	bne .exit
	jsl.l Readjoy2
	lda.b d1
	bne .exit
	jsl.l setvideo
	lda.b vcount
.vb:
	cmp.b vcount
	beq .vb
	jsl.l ReadPads
	pla
	dec a
	pha
	bpl .wait
.exit:
	pla
	rtl

org $8F901A
jdtab8F:		;buttons r,l,d,u -> direction 0-7, 8 = none (checksso)
	db 8,0,4,8,6,7,5,8,2,1,3,8,8,8,8,8

org $8FD69F
Framer:		;frame and fill (uses framer.map graphics and assums tiles are already located at framercset). d0/d1 = x/y size of rectangle, printx/y/m define top left corner to start at

		;   SNES: a d0 x d1 box of FramerMap pieces at printx/printy
	phx
	lda.w printx
	sta.b tmp0
	lda.b d0
	sta.b tmp2
	ldx.w #$0000
	jsl.l .setter
	dec.b tmp2
	dec.b tmp2
.top:
	ldx.w #$0002
	jsl.l .setter
	dec.b tmp2
	bne .top
	ldx.w #$0004
	jsl.l .setter
	dec.b d1
	dec.b d1
.row:
	lda.b tmp0
	sta.w printx
	inc.w printy
	lda.b d0
	dec a
	dec a
	sta.b tmp2
	ldx.w #$0006
	jsl.l .setter
.mid:
	ldx.w #$0008
	jsl.l .setter
	dec.b tmp2
	bne .mid
	ldx.w #$000A
	jsl.l .setter
	dec.b d1
	bne .row
	lda.b tmp0
	sta.w printx
	inc.w printy
	dec.b d0
	dec.b d0
	ldx.w #$000C
	jsl.l .setter
.bot:
	ldx.w #$000E
	jsl.l .setter
	dec.b d0
	bne .bot
	ldx.w #$0010
	jsl.l .setter
	lda.b tmp0
	sta.w printx
	inc.w printy
	plx
	rtl
.setter:		;one FramerMap piece (X = piece * 2) at printx/printy, printx + 1
	lda.l FramerMap,x
	clc
	adc.w Framercset
	clc
	adc.w printfontset
	pha
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	pla
	ora.w printa
	sta.l textmap,x
	inc.w printx
	txa
	lsr a
	cmp.b textdirtylo
	bcs .lo
	sta.b textdirtylo
.lo:
	cmp.b textdirtyhi
	bcc .hi
	sta.b textdirtyhi
.hi:
	rtl

org $8FE316
randomd0sd0:		;randomd0s with the range in d0: d0 = random -d0..+d0 (randomd0s in bank $80 takes A)
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

org $8FE404
forceblack:		;fade all colors to black but don't upset palfadenew
		;   SNES: no fade: default vblank/hblank handlers, sprite VRAM caches marked stale, wait a frame, empty DMAList
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
.frametime:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .frametime
	ldx.w #$0000
.slottime:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .slottime
	pla
.vb:
	cmp.b vcount
	beq .vb
	stz.b DMAListend
	plx
	rtl

org $8FF54E
PushNumberWidth:		;93: convert d0 into a d1 digit base 10 string, leading zeros as spaces (the last digit always shown). Return a1 = string at
		;   PushWidthBuf
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
.dig:
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
	bne .dig
	rtl

org $8FFB8B
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
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	inc.b mulres
.next:
	dec.b mulcnt
	bne .loop
	lsr.b mulsign
	bcc .pos
	lda.w #$0000
	sbc.b mulres
	sta.b mulres
.pos:
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
