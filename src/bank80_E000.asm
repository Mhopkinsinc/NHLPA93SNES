; $80E0E1-$80ED37  ROM $060E1-$06D37: setpads (logic93_1), updateanim, checkwindow (hockey93_02), setvideo, show_rink, checkfo
; (video93_1), setsortcords, setffo, uppads (video93_2) with the SNES projxy, PenaltyManager, chkatop, checkfornewpen, Stop4Pen,
; limitfo, chkprogress, InProgress, coinsearch, UpdatePA, SetPA (penalty93_1). Starts at setpads (boundary moved from $80E001),
; ends before the compressed block at $80ED38 (now in bank80_F000).
org $80E0E1
setpads:		;auto: CODE_80E0E1. 93G setpads (logic93_1): d4 = pad index (-2 puck carrier, 0/2 controllers, 4 replay target): put SCnum of X in that nibble of PadControlBits
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	lda.w #$0002		; d0 = (2 + d4) * 2 = nibble shift
	clc
	adc.b d4
	asl a
	sta.b d0
	sta.b tmp0
	lda.w #$FFF0
	sta.b d1
.m1:		;d1 = $FFF0 rotated left by d0
	lda.b tmp0
	beq .and
	dec.b tmp0
	asl.b d1
	bcc .m2
	inc.b d1
.m2:
	bra .m1
.and:
	lda.w PadControlBits
	and.b d1
	sta.w PadControlBits
	lda.w SCnum,x
	sta.b d1
.sh:		;d1 = SCnum << d0
	lda.b d0
	beq .or
	dec.b d0
	asl.b d1
	bra .sh
.or:
	lda.w PadControlBits
	ora.b d1
	sta.w PadControlBits
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
updateanim:		;auto: CODE_80E13E. 93G updateanim (hockey93_02): frame switch control on object X. SPA = offset in SPAList; next frame when SPAcnt runs out (d7), loops or ends the animation
	lda.w SPA,x		; no animation: clear pfalock, pf2aip
	bne .ia
	stz.w pf2aip,x
	stz.w pfalock,x
	rtl
.ia:
	clc		; a0 = SPAList + SPA; d1 = attributes (+$10)
	adc.w #SPAList&$FFFF
	sta.b a0
	lda.w #SPAList>>16
	sta.b a0+2
	ldy.w #$0010
	lda.b [a0],y
	sta.b d1
	lda.w facedir,x
	sta.b d0
	lda.w sfhormode		; horizontal rink: players turn 90 degrees
	beq .nhor
	cpx.w #$0018
	bcs .nhor
	lda.b d0
	dec a
	dec a
	and.w #$0007
	sta.b d0
.nhor:
	lda.w attribute,x		; x flip: mirror the direction
	bit.w #$0800
	beq .nox
	lda.b d0
	eor.w #$FFFF
	inc a
	and.w #$0007
	sta.b d0
.nox:
	lda.b d0		; a0 += direction table entry; d2 = new frame
	asl a
	tay
	lda.b [a0],y
	adc.b a0
	sta.b a0
	ldy.w SPAnum,x
	sty.b d0
	lda.b [a0],y
	sta.b d2
	lda.w SPAcnt,x		; SPAcnt negative: hold the frame
	bmi .one
	sec
	sbc.b d7
	sta.w SPAcnt,x
	bpl .cframe
	lda.w SPAnum,x		; next frame (4 bytes); a negative frame ends the list
	clc
	adc.w #$0004
	sta.w SPAnum,x
	iny
	iny
	iny
	iny
	sty.b d0
	dey
	dey
	lda.b [a0],y
	bpl .one
	stz.b d0		; end: restart, clear pfalock/pf2aip; d1 bit 0 = looper, else SPA = 0
	stz.w SPAnum,x
	stz.w pf2aip,x
	stz.w pfalock,x
	lda.b d1
	lsr a
	bcs .one
	stz.w SPA,x
.one:		;93G .1: SPAcnt = |delay|
	ldy.b d0
	iny
	iny
	lda.b [a0],y
	bit.w #$8000
	beq .zero
	eor.w #$FFFF
	inc a
.zero:
	sta.w SPAcnt,x
.cframe:		;frame = new frame (93G also has a minimum switch time)
	lda.b d2
	sta.w frame,x
	rtl
checkwindow:		;auto: CODE_80E1E8. 93G checkwindow (hockey93_02): set Hpos/Vpos so the screen follows the puck (or xc1/yc1 when sfslock)
	lda.w yc1
	sta.b d2
	lda.w xc1
	sta.b d3
	lda.w sflags		; sfslock: use xc1/yc1
	bit.w #sfslock
	bne .dd
	ldx.w #puckobj		; follow the puck, or its carrier with yleader
	lda.w puckc
	bmi .ok
	asl a
	tax
	lda.w pfgoal,x		; carrier goes up: yleader up to 50, else down to -50
	beq .gd
	lda.w yleader
	adc.b impactstep
	sta.w yleader
	sec
	sbc.w #$0032
	bmi .v1
	bvc .ylmax
	bra .ok
.v1:
	bvc .ok
.ylmax:
	lda.w #$0032
	sta.w yleader
	bra .ok
.gd:
	lda.w yleader
	sec
	sbc.b impactstep
	sta.w yleader
	sec
	sbc.w #$FFCE
	beq .ylmin
	bmi .v2
	bvs .ylmin
	bra .ok
.v2:
	bvs .ok
.ylmin:
	lda.w #$FFCE
	sta.w yleader
.ok:		;d2 = Ypos + Yvel/128 + yleader, d3 = Xpos
	lda.w Yvel,x
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0100
	beq .sy
	ora.w #$FE00
.sy:
	clc
	adc.w Ypos,x
	clc
	adc.w yleader
	sta.b d2
	sta.w yc1
	lda.w Xpos,x
	sta.b d3
	sta.w xc1
.dd:
	lda.b d2		; |target - Vpos| > 10: scroll
	sec
	sbc.w Vpos
	sta.b d0
	sec
	sbc.w #$FFF6
	bmi .v3
	bvs .up
	bra .one
.v3:
	bvs .one
.up:
	lda.b d2
	sec
	sbc.w #$FFF6
	sta.b d1
	sec
	sbc.w #$FF39
	beq .yslimd
	bmi .v4
	bvs .yslimd
	bra .two
.v4:
	bvs .two
.yslimd:
	lda.w #$FF39
	sta.b d1
	bra .two
.one:		;93G .1
	lda.b d0
	sec
	sbc.w #$000A
	beq .twox
	bmi .v5
	bvc .down
	bra .twox
.v5:
	bvc .twox
.down:
	lda.b d2
	sec
	sbc.w #$000A
	sta.b d1
	sec
	sbc.w #$0100
	bmi .v6
	bvc .yslimu
	bra .two
.v6:
	bvc .two
.yslimu:
	lda.w #$0100
	sta.b d1
.two:		;93G .2: Vpos += (target - Vpos) / 8 (at least 1)
	lda.b d1
	sec
	sbc.w Vpos
	beq .twox
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .s2
	ora.w #$E000
.s2:
	cmp.w #$0000
	bne .v2b
	inc a
.v2b:
	clc
	adc.w Vpos
	sta.w Vpos
.twox:		;93G .2x
	lda.b d3		; |target - Hpos| > 40: scroll
	sec
	sbc.w Hpos
	sta.b d0
	sec
	sbc.w #$FFD8
	bmi .v7
	bvs .left
	bra .three
.v7:
	bvs .three
.left:
	lda.b d3
	sec
	sbc.w #$FFD8
	sta.b d1
	sec
	sbc.w #$FFC4
	bmi .v8
	bvs .xslimn
	bra .four
.v8:
	bvs .four
.xslimn:
	lda.w #$FFC4
	sta.b d1
	bra .four
.three:		;93G .3
	lda.b d0
	sec
	sbc.w #$0028
	beq .rtl
	bmi .v9
	bvc .right
	bra .rtl
.v9:
	bvc .rtl
.right:
	lda.b d3
	sec
	sbc.w #$0028
	sta.b d1
	sec
	sbc.w #$003C
	beq .four
	bmi .v10
	bvc .xslim
	bra .four
.v10:
	bvc .four
.xslim:
	lda.w #$003C
	sta.b d1
.four:		;93G .4: Hpos += (target - Hpos) / 8 (at least 1)
	lda.b d1
	sec
	sbc.w Hpos
	beq .rtl
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .s4
	ora.w #$E000
.s4:
	cmp.w #$0000
	bne .h2
	inc a
.h2:
	clc
	adc.w Hpos
	sta.w Hpos
.rtl:
	rtl
setvideo:		;auto: CODE_80E35E. 93G setvideo (video93_1): once per game frame, if vblank is idle (vb2 / vb2_blank): build the sprite table and the dma list, then hand VBlank_long to vbint
	lda.b vbint		; vblank busy with a list: skip this frame
	cmp.w #vb2
	beq .go
	cmp.w #vb2_blank
	bne .rtl
	lda.b fadein		; first time after vb2_blank: fade in
	bne .go
	stz.b brightness
	inc.b fadein
.go:		;clear the sprite table
	jsl.l ClearSprites		; bank $8F: clear the sprite table (all sprites off screen)
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$003C
	bne .push
	ldx.b xsave
	jsl.l show_rink		; show_rink, checkfo, checksso, setsortcords, setffo, showclock, showzam, showcrowd, showref
	jsl.l checkfo
	jsl.l checksso		; bank $8C: 93G checksso
	jsl.l setsortcords
	jsl.l setffo
	jsl.l showclock		; bank $8F: 93G showclock
	jsl.l showzam		; bank $8F: 93G showzam (elapsed time from vcountmark)
	jsl.l showcrowd		; bank $88: 93G showcrowd
	jsl.l showref		; bank $8B: 93G showref (clears sf2refref)
	jsl.l ShowRinkRows		; bank $8F: queue the rink map rows for Vscroll (93G show_rink rows)
	jsl.l QueueTextDMA		; bank $8F: queue the changed textmap words (textdirtylo/hi)
	lda.w #VBlank_long		; VBlank sends it all next vblank
	sta.b vbint
	stx.b xsave
	ldx.w #$003A
.pop:
	pla
	sta.b a0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
show_rink:		;auto: CODE_80E3C9. 93G show_rink (video93_1): vertical rink: Hscroll = Hpos - 128, Vscroll = -Vpos - 112 (the rows are sent elsewhere)
	lda.w sfhormode
	bne .rtl
	lda.w Hpos
	sec
	sbc.w #$0080
	sta.w Hscroll
	lda.w Vpos
	eor.w #$FFFF
	inc a
	sec
	sbc.w #$0070
	sta.w Vscroll
.rtl:
	rtl
checkfo:		;auto: CODE_80E3E7. 93G checkfo/checkfo2 (video93_1): face off sprites: the three fofdata2 entries (frame, flags) at fodropx/fodropy, priority $30
	lda.w sflags		; not in pause, face off only
	bit.w #sfpz
	bne .rtl
	lda.w sflags
	bit.w #sf2faceoff
	beq .rtl
	lda.w #$0030		; faceoff sprites above the players
	sta.b sprpriority
	ldx.w #$0000
.top:
	lda.w fodropx
	sta.b sprx
	lda.w fodropy
	sta.b spry
	lda.w fofdata2,x		; frame + faceoff sprite base $213
	clc
	adc.w #$0213
	sta.b sprframe
	lda.w fofdata2+2,x
	and.w #$0800
	sta.b sprhflip
	cpx.w #$0004		; third entry (the ref): sprflag
	bne .add
	lda.w #$8000
	sta.b sprflag
.add:
	phx
	jsl.l addframe		; bank $8F: 93G addframe (sprframe at sprx/spry)
	plx
	inx
	inx
	inx
	inx
	cpx.w #$000C
	bne .top
	lda.w #$0020
	sta.b sprpriority
.rtl:
	rtl
setsortcords:		;auto: CODE_80E439. 93G setsortcords (video93_2): addframe for the 16 objects in OOlist order (hidden when Zpos < 0 or off the screen)
	lda.w #OOlist		; a4 = OOlist
	sta.b a4
.top:
	lda.b (a4)
	and.w #$00FF
	tax
	lda.w Zpos,x
	bmi .next
	sta.b d2
	lda.w Xpos,x
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	jsl.l projxy
	cmp.w #OFFSCREEN		; off the screen
	beq .next
	sta.b spry
	lda.b d0
	sta.b sprx
	lda.w frame,x		; oldframe = frame
	sta.w oldframe,x
	sta.b sprframe
	lda.w attribute,x
	and.w #$0800
	sta.b sprhflip
	lda.w attribute,x
	and.w #$1000
	sta.b sprvflip
	lda.w attribute,x		; attribute bit 0: sprflag
	lsr a
	bcc .add
	lda.w #$8000
	sta.b sprflag
.add:
	jsl.l addframe		; bank $8F: 93G addframe (sprframe at sprx/spry)
.next:
	inc.b a4
	lda.b a4
	cmp.w #OOlist+$10
	bne .top
	rtl
projxy:		;auto: CODE_80E495. SNES (93G addframe position math): rink d0/d1/d2 = x/y/z to screen: d0 = x - Hpos + 128, d1 = 112 - (y - Vpos + 1.5*z); d1 = OFFSCREEN when |x| or |y| > 144. Horizontal
		;   rink: x = -y, y = x - 197
	lda.w sfhormode
	beq .nhor
	lda.b d0
	pha
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d0
	pla
	sec
	sbc.w #$00C5
	sta.b d1
	bra .cx
.nhor:
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.cx:
	lda.b d0
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0091		; |x| > 144: off
	bcs .off
	lda.b d0
	adc.w #$0080
	sta.b d0
	lda.b d2		; d1 += 1.5 * z
	asl a
	clc
	adc.b d2
	pha
	asl a
	pla
	ror a
	clc
	adc.b d1
	sta.b d1
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$0091
	bcs .off
	lda.w #$0070
	sec
	sbc.b d1
	sta.b d1
	rtl
.off:
	lda.w #OFFSCREEN
	sta.b d1
	rtl
setffo:		;auto: CODE_80E501. 93G setffo (video93_2): uppads, then draw the 5 objects tied to rink scrolling (pads 0-2 with their 3 character label, gloves; pad 3 skipped)
	jsl.l uppads
	ldx.w #$0000
.top:
	cpx.w #$0006
	bne .obj
	jmp.w .next		; pad 3: not drawn
.obj:
	lda.w ffox,x
	sta.b d0
	lda.w ffoy,x
	sta.b d1
	lda.w ffoz,x		; hidden
	bpl .shown
	jmp.w .next
.shown:
	sta.b d2
	jsl.l projxy
	cmp.w #OFFSCREEN
	bne .add
	jmp.w .next
.add:
	sta.b spry
	lda.b d0
	sta.b sprx
	lda.w ffoframe,x		; frame, flip bits from ffoattr
	sta.b sprframe
	lda.b ffoattr,x
	and.w #$0800
	sta.b sprhflip
	lda.b ffoattr,x
	and.w #$1000
	sta.b sprvflip
	phx
	jsl.l addframe		; bank $8F: 93G addframe (sprframe at sprx/spry)
	plx
	cpx.w #$0006		; gloves: no label
	bcc .label
	jmp.w .next
.label:		;label: two digits (rostnum, $A+ = blank) and a position letter
	ldy.w #$0000		; mesarea+2 = label tiles, mesarea = count; d0 moves left 4 per digit
	lda.w padcont,x
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	beq .lo
	cmp.w #$000A
	bcc .hi
	jmp.w .next
.hi:
	sta.w mesarea+2,y
	iny
	dec.b d0
	dec.b d0
	dec.b d0
	dec.b d0
.lo:
	lda.w padcont,x
	and.w #$000F
	cmp.w #$000A
	bcs .next
	sta.w mesarea+2,y
	iny
	dec.b d0
	dec.b d0
	dec.b d0
	dec.b d0
	lda.w padcont+1,x		; position letter from ButtonLabelCharTable, after a blank
	and.w #$0007
	beq .draw
	adc.w #ButtonLabelCharTable-1
	sta.b a4
	lda.w #ButtonLabelCharTable>>16
	sta.b a4+2
	lda.b d0
	sec
	sbc.w #$0006
	sta.b d0
	lda.w #$FFFF
	sta.w mesarea+2,y
	iny
	lda.b [a4]
	sta.w mesarea+2,y
	iny
.draw:
	sty.w mesarea
	stz.b d0+2
.ch:
	ldy.b d0+2
	cpy.w mesarea
	beq .next
	lda.w mesarea+2,y
	and.w #$00FF
	cmp.w #$00FF
	beq .sp
	adc.w #$021E		; small font sprite base $21E
	sta.b sprframe
	lda.b d0
	sta.b sprx
	lda.b d1
	clc
	adc.w #$000A
	sta.b spry
	phx
	jsl.l addframe		; bank $8F: 93G addframe (sprframe at sprx/spry)
	plx
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0
.sp:		;blank: 4 pixels
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0
	inc.b d0+2
	bra .ch
.next:
	inx
	inx
	cpx.w #$000A
	beq .rtl
	jmp.w .top
.rtl:
	rtl
ButtonLabelCharTable:		;93G ButtonLabelCharTable (video93_2): tile of the position letter in the pad label, by position 1-6
	db $0B,$0B,$0C,$0A,$0D,$0E		; tiles by position (index 1-6)
uppads:		;auto: CODE_80E60B. 93G uppads (video93_2): gloves object from glovecords, and the 4 pad objects from the PadControlBits nibbles ($E = stays, $F = hidden); padcont = label code (position <<
		;   8 | rostnum)
	ldy.w #$0008		; gloves (ffo 4): hidden unless glovecords
	lda.w #$FFFF
	sta.w ffoz,y
	lda.w glovecords
	and.w #$00FF
	beq .nogloves
	and.w #$00FF
	bit.w #$0080
	beq .gx
	ora.w #$FF00
.gx:
	asl a
	asl a
	sta.w ffox,y
	lda.w glovecords+1
	and.w #$00FF
	bit.w #$0080
	beq .gy
	ora.w #$FF00
.gy:
	asl a
	asl a
	sta.w ffoy,y
	lda.w #$0000
	sta.w ffoz,y
.nogloves:
	lda.w #$0003		; 4 pads: a0 = ffo index, a1 = padcont, d3 = PadControlBits
	sta.b d4
	stz.b a0
	lda.w #padcont
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b a2
	lda.w PadControlBits
	sta.b d3
.top:
	lda.b d3
	and.w #$000F
	sta.b d0
	lda.w #$000F		; label code for $E
	sta.b d1
	lda.b d0
	cmp.w #$000E
	beq .chg
	ldy.b a0		; hidden
	lda.w #$FFFF
	sta.w ffoz,y
	lda.b d0
	cmp.w #$000F
	beq .next
	asl.b d0		; pad at the player
	ldy.b d0
	lda.w Xpos,y
	ldy.b a0
	sta.w ffox,y
	ldy.b d0
	lda.w Ypos,y
	ldy.b a0
	sta.w ffoy,y
	lda.w #$0000
	sta.w ffoz,y
	ldy.b d0
	lda.w position,y
	xba
	and.w #$FF00
	sta.b d1
	lda.w rostnum,y
	and.w #$00FF
	tsb.b d1
.chg:
	lda.b d1
	sta.b [a1]
.next:
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
	inc.b a0
	inc.b a0
	inc.b a1
	inc.b a1
	dec.b d4
	bpl .top
	rtl
PenaltyManager:		;auto: CODE_80E6C7. 93G PenaltyManager (penalty93_1): called periodically, d7 = elapsed time: updatepentime, checkfornewpen, chkprogress, UpdatePA
	jsl.l updatepentime		; updatepentime, checkfornewpen, chkprogress, then UpdatePA, bank $8F: 93G updatepentime
	jsl.l checkfornewpen
	jsl.l chkprogress
	jmp.w UpdatePA
chkatop:		;auto: CODE_80E6D6. 93G chkatop (penalty93_1): attack time of possession: tmATOP +1 for the team with the puck past the blue line ($58)
	stz.b d1
	lda.w pucky
	sec
	sbc.w #$0058
	beq .lo
	bmi .v1
	bvs .lo
	bra .one
.v1:
	bvs .one
.lo:
	inc.b d1
	inc.b d1
	lda.w pucky
	sec
	sbc.w #$FFA8
	bmi .v2
	bvs .one
	bra .rtl
.v2:
	bvs .rtl
.one:		;93G .1
	lda.w gmode		; gmdir: swap the teams
	bit.w #gmdir
	beq .zero
	lda.b d1
	eor.w #$0002
	sta.b d1
.zero:
	ldy.b d1
	lda.w tmATOP,y
	inc a
	sta.w tmATOP,y
.rtl:
	rtl
checkfornewpen:		;auto: CODE_80E715. 93G checkfornewpen (penalty93_1): new penalties in PenBuf. Stops play at once for penalties without minutes or when the guilty team has the puck, otherwise a
		;   delayed penalty call
	lda.w sfhormode		; not in horizontal mode
	beq .go
	jmp.w .rtl
.go:
	lda.w #PenBuf
	sta.b a0
.next:
	lda.b (a0)
	inc.b a0
	inc.b a0
	tay
	bne .notcalled
	jmp.w .rtl
.notcalled:
	lda.w gmode		; already called: mark it
	bit.w #gmpen
	bne .iscalled
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList		; a1 = PenaltyList entry; minutes?
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	beq .callit
	lda.w puckc		; no carrier, or the guilty team has the puck... else delayed call
	bmi .dc
	sec
	sbc.w #$0006
	sta.b d0
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pl
	ora.w #$FF00
.pl:
	sec
	sbc.w #$0006
	eor.b d0
	bmi .dc
.callit:
	jsl.l Stop4Pen
.iscalled:		;mark it called (bit 7 of the player byte)
	dec.b a0
	lda.b (a0)
	tay
	ora.w #$0080
	sta.b (a0)
	inc.b a0
	tya
	bit.w #$0080
	bne .next
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList		; delay byte (+1) * 32
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.w #$0001
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	sec
	sbc.w Pencntdwn
	beq .nx
	bmi .v1
	bvc .longer
.nx:
	jmp.w .next
.v1:
	bvc .nx
.longer:		;Pencntdwn = delay*32 if longer
	lda.b d1
	sta.w Pencntdwn
	jmp.w .next
.rtl:
	rtl
.dc:		;delayed call: PenDelay ref once
	lda.w #gmpendel		; first delayed call: SetPA PenDelay
	tsb.w gmode
	beq .dc2
	jmp.w .next
.dc2:
	lda.w #PenDelay
	sta.b d0
	jsl.l SetPA
	jmp.w .next
Stop4Pen:		;auto: CODE_80E7F7. 93G Stop4Pen (penalty93_1): a0 = PenBuf entry +2. Stop the clock, set the face off spot from the penalty type, blow the whistle
	lda.w #$FFFF		; clock already stopped: skip the face off spot
	tsb.w gmclock
	beq .spot
	jmp.w .skipfo
.spot:		;goal: center; OOP: last touch; icing: the end of the icing team (+-600); else the puck
	stz.b d0
	stz.b d1
	dec.b a0
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #PenGoal		; goal: center ice
	beq .noticing
	ldy.w ltx
	sty.b d0
	ldy.w lty
	sty.b d1
	cmp.w #PenOOP		; OOP: last touch
	beq .noticing
	ldy.w puckx
	sty.b d0
	ldy.w pucky
	sty.b d1
	cmp.w #PenIcing		; icing: +-600 by pfgoal of the icing player
	bne .noticing
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	asl a
	tay
	lda.w #$0258
	sta.b d1
	lda.w pfgoal,y
	beq .noticing
	lda.w #$FDA8
	sta.b d1
.noticing:
	lda.b d0		; x within +-70; y near the ends: end face off spots (+-206, x +-70)
	sta.b tmp0
	sec
	sbc.w #$0046
	bmi .v0
	bvc .x0
	bra .zero
.v0:
	bvc .zero
.x0:
	lda.w #$0046
	sta.b d0
.zero:		;93G .0
	lda.b d0
	sec
	sbc.w #$FFBA
	beq .x1
	bmi .v1
	bvs .x1
	bra .one
.v1:
	bvs .one
.x1:
	lda.w #$FFBA
	sta.b d0
.one:		;93G .1
	lda.b d1
	sec
	sbc.w #$00A6
	bmi .v2
	bvc .yhi
	bra .two
.v2:
	bvc .two
.yhi:
	lda.w #$00CE
	sta.b d1
	lda.w #$0046
	sta.b d0
	lda.b tmp0
	bpl .two
	lda.w #$FFBA
	sta.b d0
.two:		;93G .2
	lda.b d1
	sec
	sbc.w #$FF5A
	beq .ylo
	bmi .v3
	bvs .ylo
	bra .three
.v3:
	bvs .three
.ylo:
	lda.w #$FF32
	sta.b d1
	lda.w #$0046
	sta.b d0
	lda.b tmp0
	bpl .three
	lda.w #$FFBA
	sta.b d0
.three:		;93G .3
	lda.b d0
	sta.w fox
	lda.b d1
	sta.w foy
	jsl.l limitfo
.skipfo:
	lda.b vcount		; sound cut off within 60 frames: reset the queue
	sec
	sbc.w sfxmutetime
	cmp.w #$003C
	bcc .snd
	jsl.l sndqreset
.snd:
	lda.w #SFXwhistle		; whistle, Pencntdwn = 0, gmpen, SetPA PenWhistle
	pha
	jsl.l sfx
	stz.w Pencntdwn
	lda.w #gmpen
	tsb.w gmode
	lda.w #PenWhistle
	sta.b d0
	jmp.w SetPA
limitfo:		;auto: CODE_80E8F4. 93G limitfo (penalty93_1): keep the face off spot 65 from the blue line for every player in PenBuf
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
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.loop:
	jsl.l .lf
	inc.b a0
	inc.b a0
	lda.b [a0]
	bne .loop
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
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
.lf:		;IDA limitfo_lf: a0 = PenBuf entry
	lda.b [a0]		; player SCnum*2; blue line +-$58 by pfgoal
	xba
	and.w #$007F
	asl a
	tay
	lda.w #$0058
	sta.b d1
	lda.w pfgoal,y
	bne .zero
	lda.w #$FFA8
	sta.b d1
	sec
	sbc.w foy
	bmi .v1
	bvc .ny
	bra .rtl
.v1:
	bvc .rtl
.ny:
	lda.w #$FFBF
	sta.w foy
	bra .sx
.zero:		;93G .0
	lda.b d1
	sec
	sbc.w foy
	beq .py
	bmi .v2
	bvs .py
	bra .rtl
.v2:
	bvs .rtl
.py:
	lda.w #$0041
	sta.w foy
.sx:
	lda.w #$0046
	sta.b d0
	lda.w fox
	bpl .one
	lda.w #$FFBA
	sta.b d0
.one:
	lda.b d0
	sta.w fox
.rtl:
	rtl
chkprogress:		;auto: CODE_80E99F. 93G chkprogress (penalty93_1): when the stop delay runs out and a penalty with minutes is in PenBuf, switch to the horizontal rink for the player to enter the box
	lda.w gmode		; gmpen: ref in progress
	bit.w #gmpen
	bne .pen
	jmp.w .rtl
.pen:
	lda.w Pencntdwn		; Pencntdwn negative: InProgress
	bpl .cnt
	jmp.w InProgress
.cnt:
	sec
	sbc.b d7
	sta.w Pencntdwn
	bmi .out
	jmp.w .rtl
.out:
	lda.w #gmpendel		; stop delay over: clear gmpendel
	trb.w gmode
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.find:
	lda.b [a0]
	inc.b a0
	inc.b a0
	tay
	beq .rtl
	dec.b a0
	dec.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.w #PenaltyList
	sta.b a1
	clc
	adc.b [a1],y
	sta.b a1
	lda.b [a1]		; penalty with minutes?
	and.w #$00FF
	beq .find
	lda.w #sf2drec		; sf2drec, SetHor, load the horizontal ref; the puck does nothing for 120 s
	tsb.w sflags
	jsl.l SetHor		; bank $8F: 93G SetHor
	jsl.l NewTicker		; bank $8F: 93G NewTicker (horizontal ref)
	lda.w #$FF00
	tsb.w puckc
	ldx.w #puckobj
	stx.b a3
	lda.w #pnothing
	sta.b d0
	jsl.l assinsert
	lda.w #$1C20
	ldx.b a3
	sta.w temp1,x
	lda.w #$FF00		; RefStep negative, RefCnt 0; UpdatePA; RefCnt 50; PushRef 0
	tsb.w RefStep
	stz.w RefCnt
	jsl.l UpdatePA
	lda.w #$0032
	sta.w RefCnt
	stz.b d0
	jsl.l PushRef		; bank $8F: 93G PushRef
.rtl:
	rtl
InProgress:		;auto: CODE_80EA40. 93G InProgress (penalty93_1): ref in progress. Takes the last PenBuf entry: the first pass logs a penalty with minutes and sends the player to the box, later passes
		;   clear it; at the end coinsearch and the face off
	lda.w RefCnt		; animation in progress: exit
	bmi .step
	jmp.w .rtl
.step:
	lda.w RefStep
	bmi .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
.top:
	lda.w #$0000
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne .end
	jmp.w .exit
.end:		;find the end of the list
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne .end
	dec.b a0
	dec.b a0
	dec.b a0
	dec.b a0
	lda.b [a0]		; clear bit 15 of the entry (first pass)
	pha
	and.w #$7FFF
	sta.b [a0]
	pla
	bmi .Sa
	lda.b [a0]		; later pass: clear it when the player left the ice
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tay
	lda.w position,y
	bmi .clr
	jmp.w .ex
.clr:
	lda.w #$0000
	sta.b [a0]
	jmp.w .ex
.Sa:
	lda.b [a0]		; d2 = penalty minutes; none: no player involved
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b d2
	bne .min
	jmp.w .sa2
.min:
	stx.b xsave
	ldx.w #$0000
.pushd2:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushd2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha2:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha2
	ldx.b xsave
	jsl.l GetPeriodTimeRemaining		; GetPeriodTimeRemaining
	lda.b [a0]
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tax
	stx.b a3
	stz.b d0
	stz.b a2		; a2 = penalized team, a1 = other; d0 = $8000 for the visitors
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .sa1
	lda.w #$8000
	sta.b d0
	stz.b a1
	lda.w #$0002
	sta.b a2
.sa1:
	ldy.b a2		; tmPenalties +1, tmPenmin += minutes
	lda.w tmPenalties,y
	inc a
	sta.w tmPenalties,y
	lda.w tmPenmin,y
	clc
	adc.b d2
	sta.w tmPenmin,y
	lda.w pnum,x		; TempPlOffset = pnum | visitors
	and.w #$00FF
	ora.b d0
	sta.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .pn
	ora.w #$FF00
.pn:
	asl a
	sta.b d0
	lda.w #$003C		; d2 = minutes*60 | $2000
	sta.b mula
	lda.b d2
	and.w #$00FF
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, A = mula*mulb
	ora.w #$2000
	sta.b d2
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y		; keep TMPDINJ of an old penalty time
	bmi .st
	and.w #TMPDINJ
	tsb.b d2
.st:
	lda.b d2
	sta.w tmpdst,y
	lda.w #TMPDINJ
	trb.b d2
	lda.w #$0034
	sta.b d1
.ctop:		;same time on the other team: coincidental
	dec.b d1
	dec.b d1
	bmi .nocoin
	lda.b a1
	beq .ct
	lda.w #$0034
.ct:
	clc
	adc.b d1
	tay
	lda.w tmpdst,y
	and.w #~TMPDINJ&$FFFF
	sta.b d3
	cmp.b d2
	bne .ctop
	lda.w tmpdst,y		; coincidental: $4000 on both
	ora.w #$4000
	sta.w tmpdst,y
	lda.b a2
	beq .cg
	lda.w #$0034
.cg:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	ora.w #$4000
	sta.w tmpdst,y
.nocoin:		;add the player to the penalty box list
	lda.b a0+2
	pha
	lda.b a0
	pha
	lda.b a2
	beq .bl
	lda.w #$001A
.bl:
	sta.b a0
	lda.w #$0018
	sta.b d1
.pl:
	ldy.b a0
	inc.b a0
	lda.w tmboxlist,y
	bit.w #$0080
	bne .put
	dec.b d1
	bpl .pl
.put:
	lda.b d0
	ora.w #$FF00
	sta.w tmboxlist,y
	pla
	sta.b a0
	pla
	sta.b a0+2
	lda.w #apenalty		; apenalty
	sta.b d0
	jsl.l assreplace
	stx.b xsave
	ldx.w #$000E
.popa2:
	pla
	sta.b a1,x
	dex
	dex
	bpl .popa2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.popd2:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd2
	ldx.b xsave
	ldx.b a3		; SetPA, USBoard
	jsl.l SetPA
	jsl.l USBoard		; bank $8F: 93G USBoard
	bra .ex
.sa2:
	lda.w #$0000		; no minutes: clear it, SetPA
	sta.b [a0]
	lda.w sfhormode
	beq .sa3
	jmp.w .top
.sa3:
	jsl.l SetPA
	bra .ex
.exit:
	stz.b a2		; coinsearch for both teams, clear gmpen, the puck: pfaceoff
	jsl.l coinsearch
	lda.w #$0002
	sta.b a2
	jsl.l coinsearch
	lda.w #gmpen
	trb.w gmode
	ldx.w #puckobj
	stx.b a3
	lda.w #pfaceoff
	sta.b d0
	jsl.l assreplace
.ex:
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
coinsearch:		;auto: CODE_80EC89. 93G coinsearch (penalty93_1): a2 = team. Clears tmpdst bit $2000, counts the players kept off the ice by penalties (not coincidental, not injured, never below 4)
		;   into tmap
	lda.w #$0006		; d1 = 6 players, d0 = last roster word
	sta.b d1
	lda.w #$0032
	sta.b d0
.top:
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nap
	beq .nap
	and.w #$DFFF		; clear bit $2000; coincidental or injured: does not count
	sta.w tmpdst,y
	bit.w #TMPDINJ|$4000
	bne .nap
	lda.b d1
	cmp.w #$0004
	beq .nap
	dec.b d1
.nap:
	dec.b d0
	dec.b d0
	bpl .top
	ldy.b a2
	lda.b d1
	sta.w tmap,y
	rtl
UpdatePA:		;auto: CODE_80ECC7. 93G UpdatePA (penalty93_1): animate the ref (SetPA2 when RefCnt runs out); reprint the horizontal penalty message line when penmsgtimer runs out
	lda.w RefCnt		; RefCnt negative: idle
	bmi .rtl
	sec
	sbc.b d7
	sta.w RefCnt
	bpl .zero
	jsl.l SetPA2		; SetPA2
.zero:		;93G .1
	lda.w penmsgtimer
	sec
	sbc.b d7
	sta.w penmsgtimer
	bpl .rtl
	lda.w #$7FFF
	sta.w penmsgtimer
	jsl.l PrintPenaltyMessagesString		; PrintPenaltyMessagesString, then the player name centered at row $B
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	jsl.l GetPlayerName		; bank $8D: 93G GetPlayerName (a1 = name)
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jmp.w print
.rtl:
	rtl
SetPA:		;auto: CODE_80ED0C. 93G SetPA (penalty93_1): start the ref animation for penalty d0: prefmes, DisplayPlayerAttributeMenu for a goal, penmsgtimer (60 in horizontal mode), then SetPA2
	lda.b d0		; RefPen = d0, RefStep = 0, prefmes
	sta.w RefPen
	stz.w RefStep
	jsl.l prefmes		; bank $8F: 93G prefmes
	lda.b d0
	cmp.w #PenGoal		; goal: the goal box
	bne .zero
	jsl.l DisplayPlayerAttributeMenu		; the goal box (93G DisplayPlayerAttributeMenu)
.zero:		;93G .0
	lda.w #$7FFF
	sta.w penmsgtimer
	lda.w sfhormode
	beq .pa2
	lda.w #$003C
	sta.w penmsgtimer
.pa2:
	jml.l SetPA2
