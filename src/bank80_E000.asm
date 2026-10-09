; $80E0E1-$80ED37  ROM $060E1-$06D37: setpads (logic93_1), updateanim, checkwindow (hockey93_02), setvideo, show_rink, checkfo
; (video93_1), setsortcords, setffo, uppads (video93_2) with the SNES projxy, PenaltyManager, chkatop, checkfornewpen, Stop4Pen,
; limitfo, chkprogress, InProgress, coinsearch, UpdatePA, SetPA (penalty93_1). Starts at setpads (boundary moved from $80E001),
; ends before the compressed block at $80ED38 (now in bank80_F000).
org $80E0E1
setpads:		;auto: CODE_80E0E1. 93G setpads (logic93_1): d4 = pad index (-2 puck carrier, 0/2 controllers, 4 replay target): put SCnum of X in that nibble of PadControlBits
	stx.b xsave		; $80E0E1: 86 0A
	ldx.w #$0000		; $80E0E3: A2 00 00
.push:
	lda.b d0,x		; $80E0E6: B5 53
	pha		; $80E0E8: 48
	inx		; $80E0E9: E8
	inx		; $80E0EA: E8
	cpx.w #$0008		; $80E0EB: E0 08 00
	bne .push		; $80E0EE: D0 F6
	ldx.b xsave		; $80E0F0: A6 0A
	lda.w #$0002		; $80E0F2: A9 02 00  d0 = (2 + d4) * 2 = nibble shift
	clc		; $80E0F5: 18
	adc.b d4		; $80E0F6: 65 63
	asl a		; $80E0F8: 0A
	sta.b d0		; $80E0F9: 85 53
	sta.b tmp0		; $80E0FB: 85 73
	lda.w #$FFF0		; $80E0FD: A9 F0 FF
	sta.b d1		; $80E100: 85 57
.m1:		;d1 = $FFF0 rotated left by d0
	lda.b tmp0		; $80E102: A5 73
	beq .and		; $80E104: F0 0A
	dec.b tmp0		; $80E106: C6 73
	asl.b d1		; $80E108: 06 57
	bcc .m2		; $80E10A: 90 02
	inc.b d1		; $80E10C: E6 57
.m2:
	bra .m1		; $80E10E: 80 F2
.and:
	lda.w PadControlBits		; $80E110: AD 31 04
	and.b d1		; $80E113: 25 57
	sta.w PadControlBits		; $80E115: 8D 31 04
	lda.w SCnum,x		; $80E118: BD 9F 0D
	sta.b d1		; $80E11B: 85 57
.sh:		;d1 = SCnum << d0
	lda.b d0		; $80E11D: A5 53
	beq .or		; $80E11F: F0 06
	dec.b d0		; $80E121: C6 53
	asl.b d1		; $80E123: 06 57
	bra .sh		; $80E125: 80 F6
.or:
	lda.w PadControlBits		; $80E127: AD 31 04
	ora.b d1		; $80E12A: 05 57
	sta.w PadControlBits		; $80E12C: 8D 31 04
	stx.b xsave		; $80E12F: 86 0A
	ldx.w #$0006		; $80E131: A2 06 00
.pop:
	pla		; $80E134: 68
	sta.b d0,x		; $80E135: 95 53
	dex		; $80E137: CA
	dex		; $80E138: CA
	bpl .pop		; $80E139: 10 F9
	ldx.b xsave		; $80E13B: A6 0A
	rtl		; $80E13D: 6B
updateanim:		;auto: CODE_80E13E. 93G updateanim (hockey93_02): frame switch control on object X. SPA = offset in SPAList; next frame when SPAcnt runs out (d7), loops or ends the animation
	lda.w SPA,x		; $80E13E: BD FF 0D  no animation: clear pfalock, pf2aip
	bne .ia		; $80E141: D0 07
	stz.w pf2aip,x		; $80E143: 9E DF 11
	stz.w pfalock,x		; $80E146: 9E 7F 11
	rtl		; $80E149: 6B
.ia:
	clc		; $80E14A: 18  a0 = SPAList + SPA; d1 = attributes (+$10)
	adc.w #SPAList&$FFFF		; $80E14B: 69 6C B8
	sta.b a0		; $80E14E: 85 33
	lda.w #SPAList>>16		; $80E150: A9 82 00
	sta.b a0+2		; $80E153: 85 35
	ldy.w #$0010		; $80E155: A0 10 00
	lda.b [a0],y		; $80E158: B7 33
	sta.b d1		; $80E15A: 85 57
	lda.w facedir,x		; $80E15C: BD BF 0D
	sta.b d0		; $80E15F: 85 53
	lda.w sfhormode		; $80E161: AD 8E 12  horizontal rink: players turn 90 degrees
	beq .nhor		; $80E164: F0 0E
	cpx.w #$0018		; $80E166: E0 18 00
	bcs .nhor		; $80E169: B0 09
	lda.b d0		; $80E16B: A5 53
	dec a		; $80E16D: 3A
	dec a		; $80E16E: 3A
	and.w #$0007		; $80E16F: 29 07 00
	sta.b d0		; $80E172: 85 53
.nhor:
	lda.w attribute,x		; $80E174: BD DF 09  x flip: mirror the direction
	bit.w #$0800		; $80E177: 89 00 08
	beq .nox		; $80E17A: F0 0B
	lda.b d0		; $80E17C: A5 53
	eor.w #$FFFF		; $80E17E: 49 FF FF
	inc a		; $80E181: 1A
	and.w #$0007		; $80E182: 29 07 00
	sta.b d0		; $80E185: 85 53
.nox:
	lda.b d0		; $80E187: A5 53  a0 += direction table entry; d2 = new frame
	asl a		; $80E189: 0A
	tay		; $80E18A: A8
	lda.b [a0],y		; $80E18B: B7 33
	adc.b a0		; $80E18D: 65 33
	sta.b a0		; $80E18F: 85 33
	ldy.w SPAnum,x		; $80E191: BC 1F 0E
	sty.b d0		; $80E194: 84 53
	lda.b [a0],y		; $80E196: B7 33
	sta.b d2		; $80E198: 85 5B
	lda.w SPAcnt,x		; $80E19A: BD 3F 0E  SPAcnt negative: hold the frame
	bmi .one		; $80E19D: 30 31
	sec		; $80E19F: 38
	sbc.b d7		; $80E1A0: E5 6F
	sta.w SPAcnt,x		; $80E1A2: 9D 3F 0E
	bpl .cframe		; $80E1A5: 10 3B
	lda.w SPAnum,x		; $80E1A7: BD 1F 0E  next frame (4 bytes); a negative frame ends the list
	clc		; $80E1AA: 18
	adc.w #$0004		; $80E1AB: 69 04 00
	sta.w SPAnum,x		; $80E1AE: 9D 1F 0E
	iny		; $80E1B1: C8
	iny		; $80E1B2: C8
	iny		; $80E1B3: C8
	iny		; $80E1B4: C8
	sty.b d0		; $80E1B5: 84 53
	dey		; $80E1B7: 88
	dey		; $80E1B8: 88
	lda.b [a0],y		; $80E1B9: B7 33
	bpl .one		; $80E1BB: 10 13
	stz.b d0		; $80E1BD: 64 53  end: restart, clear pfalock/pf2aip; d1 bit 0 = looper, else SPA = 0
	stz.w SPAnum,x		; $80E1BF: 9E 1F 0E
	stz.w pf2aip,x		; $80E1C2: 9E DF 11
	stz.w pfalock,x		; $80E1C5: 9E 7F 11
	lda.b d1		; $80E1C8: A5 57
	lsr a		; $80E1CA: 4A
	bcs .one		; $80E1CB: B0 03
	stz.w SPA,x		; $80E1CD: 9E FF 0D
.one:		;93G .1: SPAcnt = |delay|
	ldy.b d0		; $80E1D0: A4 53
	iny		; $80E1D2: C8
	iny		; $80E1D3: C8
	lda.b [a0],y		; $80E1D4: B7 33
	bit.w #$8000		; $80E1D6: 89 00 80
	beq .zero		; $80E1D9: F0 04
	eor.w #$FFFF		; $80E1DB: 49 FF FF
	inc a		; $80E1DE: 1A
.zero:
	sta.w SPAcnt,x		; $80E1DF: 9D 3F 0E
.cframe:		;frame = new frame (93G also has a minimum switch time)
	lda.b d2		; $80E1E2: A5 5B
	sta.w frame,x		; $80E1E4: 9D 3F 09
	rtl		; $80E1E7: 6B
checkwindow:		;auto: CODE_80E1E8. 93G checkwindow (hockey93_02): set Hpos/Vpos so the screen follows the puck (or xc1/yc1 when sfslock)
	lda.w yc1		; $80E1E8: AD F7 08
	sta.b d2		; $80E1EB: 85 5B
	lda.w xc1		; $80E1ED: AD F5 08
	sta.b d3		; $80E1F0: 85 5F
	lda.w sflags		; $80E1F2: AD 8C 12  sfslock: use xc1/yc1
	bit.w #sfslock		; $80E1F5: 89 40 00
	bne .dd		; $80E1F8: D0 6F
	ldx.w #puckobj		; $80E1FA: A2 1C 00  follow the puck, or its carrier with yleader
	lda.w puckc		; $80E1FD: AD BB 0E
	bmi .ok		; $80E200: 30 40
	asl a		; $80E202: 0A
	tax		; $80E203: AA
	lda.w pfgoal,x		; $80E204: BD 3F 11  carrier goes up: yleader up to 50, else down to -50
	beq .gd		; $80E207: F0 1C
	lda.w yleader		; $80E209: AD F9 08
	adc.b impactstep		; $80E20C: 65 E2
	sta.w yleader		; $80E20E: 8D F9 08
	sec		; $80E211: 38
	sbc.w #$0032		; $80E212: E9 32 00
	bmi .v1		; $80E215: 30 04
	bvc .ylmax		; $80E217: 50 04
	bra .ok		; $80E219: 80 27
.v1:
	bvc .ok		; $80E21B: 50 25
.ylmax:
	lda.w #$0032		; $80E21D: A9 32 00
	sta.w yleader		; $80E220: 8D F9 08
	bra .ok		; $80E223: 80 1D
.gd:
	lda.w yleader		; $80E225: AD F9 08
	sec		; $80E228: 38
	sbc.b impactstep		; $80E229: E5 E2
	sta.w yleader		; $80E22B: 8D F9 08
	sec		; $80E22E: 38
	sbc.w #$FFCE		; $80E22F: E9 CE FF
	beq .ylmin		; $80E232: F0 08
	bmi .v2		; $80E234: 30 04
	bvs .ylmin		; $80E236: 70 04
	bra .ok		; $80E238: 80 08
.v2:
	bvs .ok		; $80E23A: 70 06
.ylmin:
	lda.w #$FFCE		; $80E23C: A9 CE FF
	sta.w yleader		; $80E23F: 8D F9 08
.ok:		;d2 = Ypos + Yvel/128 + yleader, d3 = Xpos
	lda.w Yvel,x		; $80E242: BD FF 0A
	lsr a		; $80E245: 4A
	lsr a		; $80E246: 4A
	lsr a		; $80E247: 4A
	lsr a		; $80E248: 4A
	lsr a		; $80E249: 4A
	lsr a		; $80E24A: 4A
	lsr a		; $80E24B: 4A
	bit.w #$0100		; $80E24C: 89 00 01
	beq .sy		; $80E24F: F0 03
	ora.w #$FE00		; $80E251: 09 00 FE
.sy:
	clc		; $80E254: 18
	adc.w Ypos,x		; $80E255: 7D 5F 09
	clc		; $80E258: 18
	adc.w yleader		; $80E259: 6D F9 08
	sta.b d2		; $80E25C: 85 5B
	sta.w yc1		; $80E25E: 8D F7 08
	lda.w Xpos,x		; $80E261: BD FF 08
	sta.b d3		; $80E264: 85 5F
	sta.w xc1		; $80E266: 8D F5 08
.dd:
	lda.b d2		; $80E269: A5 5B  |target - Vpos| > 10: scroll
	sec		; $80E26B: 38
	sbc.w Vpos		; $80E26C: ED DF 08
	sta.b d0		; $80E26F: 85 53
	sec		; $80E271: 38
	sbc.w #$FFF6		; $80E272: E9 F6 FF
	bmi .v3		; $80E275: 30 04
	bvs .up		; $80E277: 70 04
	bra .one		; $80E279: 80 1F
.v3:
	bvs .one		; $80E27B: 70 1D
.up:
	lda.b d2		; $80E27D: A5 5B
	sec		; $80E27F: 38
	sbc.w #$FFF6		; $80E280: E9 F6 FF
	sta.b d1		; $80E283: 85 57
	sec		; $80E285: 38
	sbc.w #$FF39		; $80E286: E9 39 FF
	beq .yslimd		; $80E289: F0 08
	bmi .v4		; $80E28B: 30 04
	bvs .yslimd		; $80E28D: 70 04
	bra .two		; $80E28F: 80 32
.v4:
	bvs .two		; $80E291: 70 30
.yslimd:
	lda.w #$FF39		; $80E293: A9 39 FF
	sta.b d1		; $80E296: 85 57
	bra .two		; $80E298: 80 29
.one:		;93G .1
	lda.b d0		; $80E29A: A5 53
	sec		; $80E29C: 38
	sbc.w #$000A		; $80E29D: E9 0A 00
	beq .twox		; $80E2A0: F0 41
	bmi .v5		; $80E2A2: 30 04
	bvc .down		; $80E2A4: 50 04
	bra .twox		; $80E2A6: 80 3B
.v5:
	bvc .twox		; $80E2A8: 50 39
.down:
	lda.b d2		; $80E2AA: A5 5B
	sec		; $80E2AC: 38
	sbc.w #$000A		; $80E2AD: E9 0A 00
	sta.b d1		; $80E2B0: 85 57
	sec		; $80E2B2: 38
	sbc.w #$0100		; $80E2B3: E9 00 01
	bmi .v6		; $80E2B6: 30 04
	bvc .yslimu		; $80E2B8: 50 04
	bra .two		; $80E2BA: 80 07
.v6:
	bvc .two		; $80E2BC: 50 05
.yslimu:
	lda.w #$0100		; $80E2BE: A9 00 01
	sta.b d1		; $80E2C1: 85 57
.two:		;93G .2: Vpos += (target - Vpos) / 8 (at least 1)
	lda.b d1		; $80E2C3: A5 57
	sec		; $80E2C5: 38
	sbc.w Vpos		; $80E2C6: ED DF 08
	beq .twox		; $80E2C9: F0 18
	lsr a		; $80E2CB: 4A
	lsr a		; $80E2CC: 4A
	lsr a		; $80E2CD: 4A
	bit.w #$1000		; $80E2CE: 89 00 10
	beq .s2		; $80E2D1: F0 03
	ora.w #$E000		; $80E2D3: 09 00 E0
.s2:
	cmp.w #$0000		; $80E2D6: C9 00 00
	bne .v2b		; $80E2D9: D0 01
	inc a		; $80E2DB: 1A
.v2b:
	clc		; $80E2DC: 18
	adc.w Vpos		; $80E2DD: 6D DF 08
	sta.w Vpos		; $80E2E0: 8D DF 08
.twox:		;93G .2x
	lda.b d3		; $80E2E3: A5 5F  |target - Hpos| > 40: scroll
	sec		; $80E2E5: 38
	sbc.w Hpos		; $80E2E6: ED 54 01
	sta.b d0		; $80E2E9: 85 53
	sec		; $80E2EB: 38
	sbc.w #$FFD8		; $80E2EC: E9 D8 FF
	bmi .v7		; $80E2EF: 30 04
	bvs .left		; $80E2F1: 70 04
	bra .three		; $80E2F3: 80 1D
.v7:
	bvs .three		; $80E2F5: 70 1B
.left:
	lda.b d3		; $80E2F7: A5 5F
	sec		; $80E2F9: 38
	sbc.w #$FFD8		; $80E2FA: E9 D8 FF
	sta.b d1		; $80E2FD: 85 57
	sec		; $80E2FF: 38
	sbc.w #$FFC4		; $80E300: E9 C4 FF
	bmi .v8		; $80E303: 30 04
	bvs .xslimn		; $80E305: 70 04
	bra .four		; $80E307: 80 34
.v8:
	bvs .four		; $80E309: 70 32
.xslimn:
	lda.w #$FFC4		; $80E30B: A9 C4 FF
	sta.b d1		; $80E30E: 85 57
	bra .four		; $80E310: 80 2B
.three:		;93G .3
	lda.b d0		; $80E312: A5 53
	sec		; $80E314: 38
	sbc.w #$0028		; $80E315: E9 28 00
	beq .rtl		; $80E318: F0 43
	bmi .v9		; $80E31A: 30 04
	bvc .right		; $80E31C: 50 04
	bra .rtl		; $80E31E: 80 3D
.v9:
	bvc .rtl		; $80E320: 50 3B
.right:
	lda.b d3		; $80E322: A5 5F
	sec		; $80E324: 38
	sbc.w #$0028		; $80E325: E9 28 00
	sta.b d1		; $80E328: 85 57
	sec		; $80E32A: 38
	sbc.w #$003C		; $80E32B: E9 3C 00
	beq .four		; $80E32E: F0 0D
	bmi .v10		; $80E330: 30 04
	bvc .xslim		; $80E332: 50 04
	bra .four		; $80E334: 80 07
.v10:
	bvc .four		; $80E336: 50 05
.xslim:
	lda.w #$003C		; $80E338: A9 3C 00
	sta.b d1		; $80E33B: 85 57
.four:		;93G .4: Hpos += (target - Hpos) / 8 (at least 1)
	lda.b d1		; $80E33D: A5 57
	sec		; $80E33F: 38
	sbc.w Hpos		; $80E340: ED 54 01
	beq .rtl		; $80E343: F0 18
	lsr a		; $80E345: 4A
	lsr a		; $80E346: 4A
	lsr a		; $80E347: 4A
	bit.w #$1000		; $80E348: 89 00 10
	beq .s4		; $80E34B: F0 03
	ora.w #$E000		; $80E34D: 09 00 E0
.s4:
	cmp.w #$0000		; $80E350: C9 00 00
	bne .h2		; $80E353: D0 01
	inc a		; $80E355: 1A
.h2:
	clc		; $80E356: 18
	adc.w Hpos		; $80E357: 6D 54 01
	sta.w Hpos		; $80E35A: 8D 54 01
.rtl:
	rtl		; $80E35D: 6B
setvideo:		;auto: CODE_80E35E. 93G setvideo (video93_1): once per game frame, if vblank is idle (vb2 / vb2_blank): build the sprite table and the dma list, then hand VBlank_long to vbint
	lda.b vbint		; $80E35E: A5 14  vblank busy with a list: skip this frame
	cmp.w #vb2		; $80E360: C9 DE 80
	beq .go		; $80E363: F0 0D
	cmp.w #vb2_blank		; $80E365: C9 CE 80
	bne .rtl		; $80E368: D0 5E
	lda.b fadein		; $80E36A: A5 08  first time after vb2_blank: fade in
	bne .go		; $80E36C: D0 04
	stz.b brightness		; $80E36E: 64 04
	inc.b fadein		; $80E370: E6 08
.go:		;clear the sprite table
	jsl.l $8FE04C		; $80E372: 22 4C E0 8F  bank $8F: clear the sprite table (all sprites off screen)
	stx.b xsave		; $80E376: 86 0A
	ldx.w #$0000		; $80E378: A2 00 00
.push:
	lda.b a0,x		; $80E37B: B5 33
	pha		; $80E37D: 48
	inx		; $80E37E: E8
	inx		; $80E37F: E8
	cpx.w #$003C		; $80E380: E0 3C 00
	bne .push		; $80E383: D0 F6
	ldx.b xsave		; $80E385: A6 0A
	jsl.l show_rink		; $80E387: 22 C9 E3 80  show_rink, checkfo, checksso, setsortcords, setffo, showclock, showzam, showcrowd, showref
	jsl.l checkfo		; $80E38B: 22 E7 E3 80
	jsl.l $8CFC1A		; $80E38F: 22 1A FC 8C  bank $8C: 93G checksso
	jsl.l setsortcords		; $80E393: 22 39 E4 80
	jsl.l setffo		; $80E397: 22 01 E5 80
	jsl.l $8F82A4		; $80E39B: 22 A4 82 8F  bank $8F: 93G showclock
	jsl.l $8F8ABC		; $80E39F: 22 BC 8A 8F  bank $8F: 93G showzam (elapsed time from vcountmark)
	jsl.l $8887AE		; $80E3A3: 22 AE 87 88  bank $88: 93G showcrowd
	jsl.l $8BFFCC		; $80E3A7: 22 CC FF 8B  bank $8B: 93G showref (clears sf2refref)
	jsl.l $8F8F4A		; $80E3AB: 22 4A 8F 8F  bank $8F: queue the rink map rows for Vscroll (93G show_rink rows)
	jsl.l $8F8EF7		; $80E3AF: 22 F7 8E 8F  bank $8F: queue the changed textmap words (textdirtylo/hi)
	lda.w #VBlank_long		; $80E3B3: A9 2F 81  VBlank sends it all next vblank
	sta.b vbint		; $80E3B6: 85 14
	stx.b xsave		; $80E3B8: 86 0A
	ldx.w #$003A		; $80E3BA: A2 3A 00
.pop:
	pla		; $80E3BD: 68
	sta.b a0,x		; $80E3BE: 95 33
	dex		; $80E3C0: CA
	dex		; $80E3C1: CA
	bpl .pop		; $80E3C2: 10 F9
	ldx.b xsave		; $80E3C4: A6 0A
	ldx.b a3		; $80E3C6: A6 3F
.rtl:
	rtl		; $80E3C8: 6B
show_rink:		;auto: CODE_80E3C9. 93G show_rink (video93_1): vertical rink: Hscroll = Hpos - 128, Vscroll = -Vpos - 112 (the rows are sent elsewhere)
	lda.w sfhormode		; $80E3C9: AD 8E 12
	bne .rtl		; $80E3CC: D0 18
	lda.w Hpos		; $80E3CE: AD 54 01
	sec		; $80E3D1: 38
	sbc.w #$0080		; $80E3D2: E9 80 00
	sta.w Hscroll		; $80E3D5: 8D 56 01
	lda.w Vpos		; $80E3D8: AD DF 08
	eor.w #$FFFF		; $80E3DB: 49 FF FF
	inc a		; $80E3DE: 1A
	sec		; $80E3DF: 38
	sbc.w #$0070		; $80E3E0: E9 70 00
	sta.w Vscroll		; $80E3E3: 8D E1 08
.rtl:
	rtl		; $80E3E6: 6B
checkfo:		;auto: CODE_80E3E7. 93G checkfo/checkfo2 (video93_1): face off sprites: the three fofdata2 entries (frame, flags) at fodropx/fodropy, priority $30
	lda.w sflags		; $80E3E7: AD 8C 12  not in pause, face off only
	bit.w #sfpz		; $80E3EA: 89 01 00
	bne .rtl		; $80E3ED: D0 49
	lda.w sflags		; $80E3EF: AD 8C 12
	bit.w #sf2faceoff		; $80E3F2: 89 00 01
	beq .rtl		; $80E3F5: F0 41
	lda.w #$0030		; $80E3F7: A9 30 00  faceoff sprites above the players
	sta.b sprpriority		; $80E3FA: 85 BB
	ldx.w #$0000		; $80E3FC: A2 00 00
.top:
	lda.w fodropx		; $80E3FF: AD 36 01
	sta.b sprx		; $80E402: 85 C9
	lda.w fodropy		; $80E404: AD 38 01
	sta.b spry		; $80E407: 85 CB
	lda.w fofdata2,x		; $80E409: BD 3A 01  frame + faceoff sprite base $213
	clc		; $80E40C: 18
	adc.w #$0213		; $80E40D: 69 13 02
	sta.b sprframe		; $80E410: 85 C3
	lda.w fofdata2+2,x		; $80E412: BD 3C 01
	and.w #$0800		; $80E415: 29 00 08
	sta.b sprhflip		; $80E418: 85 A5
	cpx.w #$0004		; $80E41A: E0 04 00  third entry (the ref): sprflag
	bne .add		; $80E41D: D0 05
	lda.w #$8000		; $80E41F: A9 00 80
	sta.b sprflag		; $80E422: 85 AB
.add:
	phx		; $80E424: DA
	jsl.l $8FEC68		; $80E425: 22 68 EC 8F  bank $8F: 93G addframe (sprframe at sprx/spry)
	plx		; $80E429: FA
	inx		; $80E42A: E8
	inx		; $80E42B: E8
	inx		; $80E42C: E8
	inx		; $80E42D: E8
	cpx.w #$000C		; $80E42E: E0 0C 00
	bne .top		; $80E431: D0 CC
	lda.w #$0020		; $80E433: A9 20 00
	sta.b sprpriority		; $80E436: 85 BB
.rtl:
	rtl		; $80E438: 6B
setsortcords:		;auto: CODE_80E439. 93G setsortcords (video93_2): addframe for the 16 objects in OOlist order (hidden when Zpos < 0 or off the screen)
	lda.w #OOlist		; $80E439: A9 5F 12  a4 = OOlist
	sta.b a4		; $80E43C: 85 43
.top:
	lda.b (a4)		; $80E43E: B2 43
	and.w #$00FF		; $80E440: 29 FF 00
	tax		; $80E443: AA
	lda.w Zpos,x		; $80E444: BD 9F 09
	bmi .next		; $80E447: 30 42
	sta.b d2		; $80E449: 85 5B
	lda.w Xpos,x		; $80E44B: BD FF 08
	sta.b d0		; $80E44E: 85 53
	lda.w Ypos,x		; $80E450: BD 5F 09
	sta.b d1		; $80E453: 85 57
	jsl.l projxy		; $80E455: 22 95 E4 80
	cmp.w #OFFSCREEN		; $80E459: C9 20 4E  off the screen
	beq .next		; $80E45C: F0 2D
	sta.b spry		; $80E45E: 85 CB
	lda.b d0		; $80E460: A5 53
	sta.b sprx		; $80E462: 85 C9
	lda.w frame,x		; $80E464: BD 3F 09  oldframe = frame
	sta.w oldframe,x		; $80E467: 9D FF 09
	sta.b sprframe		; $80E46A: 85 C3
	lda.w attribute,x		; $80E46C: BD DF 09
	and.w #$0800		; $80E46F: 29 00 08
	sta.b sprhflip		; $80E472: 85 A5
	lda.w attribute,x		; $80E474: BD DF 09
	and.w #$1000		; $80E477: 29 00 10
	sta.b sprvflip		; $80E47A: 85 CD
	lda.w attribute,x		; $80E47C: BD DF 09  attribute bit 0: sprflag
	lsr a		; $80E47F: 4A
	bcc .add		; $80E480: 90 05
	lda.w #$8000		; $80E482: A9 00 80
	sta.b sprflag		; $80E485: 85 AB
.add:
	jsl.l $8FEC68		; $80E487: 22 68 EC 8F  bank $8F: 93G addframe (sprframe at sprx/spry)
.next:
	inc.b a4		; $80E48B: E6 43
	lda.b a4		; $80E48D: A5 43
	cmp.w #OOlist+$10		; $80E48F: C9 6F 12
	bne .top		; $80E492: D0 AA
	rtl		; $80E494: 6B
projxy:		;auto: CODE_80E495. SNES (93G addframe position math): rink d0/d1/d2 = x/y/z to screen: d0 = x - Hpos + 128, d1 = 112 - (y - Vpos + 1.5*z); d1 = OFFSCREEN when |x| or |y| > 144. Horizontal rink: x = -y, y = x - 197
	lda.w sfhormode		; $80E495: AD 8E 12
	beq .nhor		; $80E498: F0 14
	lda.b d0		; $80E49A: A5 53
	pha		; $80E49C: 48
	lda.b d1		; $80E49D: A5 57
	eor.w #$FFFF		; $80E49F: 49 FF FF
	inc a		; $80E4A2: 1A
	sta.b d0		; $80E4A3: 85 53
	pla		; $80E4A5: 68
	sec		; $80E4A6: 38
	sbc.w #$00C5		; $80E4A7: E9 C5 00
	sta.b d1		; $80E4AA: 85 57
	bra .cx		; $80E4AC: 80 10
.nhor:
	lda.b d0		; $80E4AE: A5 53
	sec		; $80E4B0: 38
	sbc.w Hpos		; $80E4B1: ED 54 01
	sta.b d0		; $80E4B4: 85 53
	lda.b d1		; $80E4B6: A5 57
	sec		; $80E4B8: 38
	sbc.w Vpos		; $80E4B9: ED DF 08
	sta.b d1		; $80E4BC: 85 57
.cx:
	lda.b d0		; $80E4BE: A5 53
	bit.w #$8000		; $80E4C0: 89 00 80
	beq .ax		; $80E4C3: F0 04
	eor.w #$FFFF		; $80E4C5: 49 FF FF
	inc a		; $80E4C8: 1A
.ax:
	cmp.w #$0091		; $80E4C9: C9 91 00  |x| > 144: off
	bcs .off		; $80E4CC: B0 2D
	lda.b d0		; $80E4CE: A5 53
	adc.w #$0080		; $80E4D0: 69 80 00
	sta.b d0		; $80E4D3: 85 53
	lda.b d2		; $80E4D5: A5 5B  d1 += 1.5 * z
	asl a		; $80E4D7: 0A
	clc		; $80E4D8: 18
	adc.b d2		; $80E4D9: 65 5B
	pha		; $80E4DB: 48
	asl a		; $80E4DC: 0A
	pla		; $80E4DD: 68
	ror a		; $80E4DE: 6A
	clc		; $80E4DF: 18
	adc.b d1		; $80E4E0: 65 57
	sta.b d1		; $80E4E2: 85 57
	bit.w #$8000		; $80E4E4: 89 00 80
	beq .ay		; $80E4E7: F0 04
	eor.w #$FFFF		; $80E4E9: 49 FF FF
	inc a		; $80E4EC: 1A
.ay:
	cmp.w #$0091		; $80E4ED: C9 91 00
	bcs .off		; $80E4F0: B0 09
	lda.w #$0070		; $80E4F2: A9 70 00
	sec		; $80E4F5: 38
	sbc.b d1		; $80E4F6: E5 57
	sta.b d1		; $80E4F8: 85 57
	rtl		; $80E4FA: 6B
.off:
	lda.w #OFFSCREEN		; $80E4FB: A9 20 4E
	sta.b d1		; $80E4FE: 85 57
	rtl		; $80E500: 6B
setffo:		;auto: CODE_80E501. 93G setffo (video93_2): uppads, then draw the 5 objects tied to rink scrolling (pads 0-2 with their 3 character label, gloves; pad 3 skipped)
	jsl.l uppads		; $80E501: 22 0B E6 80
	ldx.w #$0000		; $80E505: A2 00 00
.top:
	cpx.w #$0006		; $80E508: E0 06 00
	bne .obj		; $80E50B: D0 03
	jmp.w .next		; $80E50D: 4C FA E5  pad 3: not drawn
.obj:
	lda.w ffox,x		; $80E510: BD 14 01
	sta.b d0		; $80E513: 85 53
	lda.w ffoy,x		; $80E515: BD 1E 01
	sta.b d1		; $80E518: 85 57
	lda.w ffoz,x		; $80E51A: BD 28 01  hidden
	bpl .shown		; $80E51D: 10 03
	jmp.w .next		; $80E51F: 4C FA E5
.shown:
	sta.b d2		; $80E522: 85 5B
	jsl.l projxy		; $80E524: 22 95 E4 80
	cmp.w #OFFSCREEN		; $80E528: C9 20 4E
	bne .add		; $80E52B: D0 03
	jmp.w .next		; $80E52D: 4C FA E5
.add:
	sta.b spry		; $80E530: 85 CB
	lda.b d0		; $80E532: A5 53
	sta.b sprx		; $80E534: 85 C9
	lda.w ffoframe,x		; $80E536: BD 00 01  frame, flip bits from ffoattr
	sta.b sprframe		; $80E539: 85 C3
	lda.b ffoattr,x		; $80E53B: B5 F6
	and.w #$0800		; $80E53D: 29 00 08
	sta.b sprhflip		; $80E540: 85 A5
	lda.b ffoattr,x		; $80E542: B5 F6
	and.w #$1000		; $80E544: 29 00 10
	sta.b sprvflip		; $80E547: 85 CD
	phx		; $80E549: DA
	jsl.l $8FEC68		; $80E54A: 22 68 EC 8F  bank $8F: 93G addframe (sprframe at sprx/spry)
	plx		; $80E54E: FA
	cpx.w #$0006		; $80E54F: E0 06 00  gloves: no label
	bcc .label		; $80E552: 90 03
	jmp.w .next		; $80E554: 4C FA E5
.label:		;label: two digits (rostnum, $A+ = blank) and a position letter
	ldy.w #$0000		; $80E557: A0 00 00  mesarea+2 = label tiles, mesarea = count; d0 moves left 4 per digit
	lda.w padcont,x		; $80E55A: BD 33 04
	lsr a		; $80E55D: 4A
	lsr a		; $80E55E: 4A
	lsr a		; $80E55F: 4A
	lsr a		; $80E560: 4A
	and.w #$000F		; $80E561: 29 0F 00
	beq .lo		; $80E564: F0 14
	cmp.w #$000A		; $80E566: C9 0A 00
	bcc .hi		; $80E569: 90 03
	jmp.w .next		; $80E56B: 4C FA E5
.hi:
	sta.w mesarea+2,y		; $80E56E: 99 93 01
	iny		; $80E571: C8
	dec.b d0		; $80E572: C6 53
	dec.b d0		; $80E574: C6 53
	dec.b d0		; $80E576: C6 53
	dec.b d0		; $80E578: C6 53
.lo:
	lda.w padcont,x		; $80E57A: BD 33 04
	and.w #$000F		; $80E57D: 29 0F 00
	cmp.w #$000A		; $80E580: C9 0A 00
	bcs .next		; $80E583: B0 75
	sta.w mesarea+2,y		; $80E585: 99 93 01
	iny		; $80E588: C8
	dec.b d0		; $80E589: C6 53
	dec.b d0		; $80E58B: C6 53
	dec.b d0		; $80E58D: C6 53
	dec.b d0		; $80E58F: C6 53
	lda.w padcont+1,x		; $80E591: BD 34 04  position letter from ButtonLabelCharTable, after a blank
	and.w #$0007		; $80E594: 29 07 00
	beq .draw		; $80E597: F0 1F
	adc.w #ButtonLabelCharTable-1		; $80E599: 69 04 E6
	sta.b a4		; $80E59C: 85 43
	lda.w #ButtonLabelCharTable>>16		; $80E59E: A9 80 00
	sta.b a4+2		; $80E5A1: 85 45
	lda.b d0		; $80E5A3: A5 53
	sec		; $80E5A5: 38
	sbc.w #$0006		; $80E5A6: E9 06 00
	sta.b d0		; $80E5A9: 85 53
	lda.w #$FFFF		; $80E5AB: A9 FF FF
	sta.w mesarea+2,y		; $80E5AE: 99 93 01
	iny		; $80E5B1: C8
	lda.b [a4]		; $80E5B2: A7 43
	sta.w mesarea+2,y		; $80E5B4: 99 93 01
	iny		; $80E5B7: C8
.draw:
	sty.w mesarea		; $80E5B8: 8C 91 01
	stz.b d0+2		; $80E5BB: 64 55
.ch:
	ldy.b d0+2		; $80E5BD: A4 55
	cpy.w mesarea		; $80E5BF: CC 91 01
	beq .next		; $80E5C2: F0 36
	lda.w mesarea+2,y		; $80E5C4: B9 93 01
	and.w #$00FF		; $80E5C7: 29 FF 00
	cmp.w #$00FF		; $80E5CA: C9 FF 00
	beq .sp		; $80E5CD: F0 1F
	adc.w #$021E		; $80E5CF: 69 1E 02  small font sprite base $21E
	sta.b sprframe		; $80E5D2: 85 C3
	lda.b d0		; $80E5D4: A5 53
	sta.b sprx		; $80E5D6: 85 C9
	lda.b d1		; $80E5D8: A5 57
	clc		; $80E5DA: 18
	adc.w #$000A		; $80E5DB: 69 0A 00
	sta.b spry		; $80E5DE: 85 CB
	phx		; $80E5E0: DA
	jsl.l $8FEC68		; $80E5E1: 22 68 EC 8F  bank $8F: 93G addframe (sprframe at sprx/spry)
	plx		; $80E5E5: FA
	inc.b d0		; $80E5E6: E6 53
	inc.b d0		; $80E5E8: E6 53
	inc.b d0		; $80E5EA: E6 53
	inc.b d0		; $80E5EC: E6 53
.sp:		;blank: 4 pixels
	inc.b d0		; $80E5EE: E6 53
	inc.b d0		; $80E5F0: E6 53
	inc.b d0		; $80E5F2: E6 53
	inc.b d0		; $80E5F4: E6 53
	inc.b d0+2		; $80E5F6: E6 55
	bra .ch		; $80E5F8: 80 C3
.next:
	inx		; $80E5FA: E8
	inx		; $80E5FB: E8
	cpx.w #$000A		; $80E5FC: E0 0A 00
	beq .rtl		; $80E5FF: F0 03
	jmp.w .top		; $80E601: 4C 08 E5
.rtl:
	rtl		; $80E604: 6B
ButtonLabelCharTable:		;93G ButtonLabelCharTable (video93_2): tile of the position letter in the pad label, by position 1-6
	db $0B,$0B,$0C,$0A,$0D,$0E		; $80E605  tiles by position (index 1-6)
uppads:		;auto: CODE_80E60B. 93G uppads (video93_2): gloves object from glovecords, and the 4 pad objects from the PadControlBits nibbles ($E = stays, $F = hidden); padcont = label code (position << 8 | rostnum)
	ldy.w #$0008		; $80E60B: A0 08 00  gloves (ffo 4): hidden unless glovecords
	lda.w #$FFFF		; $80E60E: A9 FF FF
	sta.w ffoz,y		; $80E611: 99 28 01
	lda.w glovecords		; $80E614: AD 4E 01
	and.w #$00FF		; $80E617: 29 FF 00
	beq .nogloves		; $80E61A: F0 29
	and.w #$00FF		; $80E61C: 29 FF 00
	bit.w #$0080		; $80E61F: 89 80 00
	beq .gx		; $80E622: F0 03
	ora.w #$FF00		; $80E624: 09 00 FF
.gx:
	asl a		; $80E627: 0A
	asl a		; $80E628: 0A
	sta.w ffox,y		; $80E629: 99 14 01
	lda.w glovecords+1		; $80E62C: AD 4F 01
	and.w #$00FF		; $80E62F: 29 FF 00
	bit.w #$0080		; $80E632: 89 80 00
	beq .gy		; $80E635: F0 03
	ora.w #$FF00		; $80E637: 09 00 FF
.gy:
	asl a		; $80E63A: 0A
	asl a		; $80E63B: 0A
	sta.w ffoy,y		; $80E63C: 99 1E 01
	lda.w #$0000		; $80E63F: A9 00 00
	sta.w ffoz,y		; $80E642: 99 28 01
.nogloves:
	lda.w #$0003		; $80E645: A9 03 00  4 pads: a0 = ffo index, a1 = padcont, d3 = PadControlBits
	sta.b d4		; $80E648: 85 63
	stz.b a0		; $80E64A: 64 33
	lda.w #padcont		; $80E64C: A9 33 04
	sta.b a1		; $80E64F: 85 37
	lda.w #$0000		; $80E651: A9 00 00
	sta.b a1+2		; $80E654: 85 39
	stz.b a2		; $80E656: 64 3B
	lda.w PadControlBits		; $80E658: AD 31 04
	sta.b d3		; $80E65B: 85 5F
.top:
	lda.b d3		; $80E65D: A5 5F
	and.w #$000F		; $80E65F: 29 0F 00
	sta.b d0		; $80E662: 85 53
	lda.w #$000F		; $80E664: A9 0F 00  label code for $E
	sta.b d1		; $80E667: 85 57
	lda.b d0		; $80E669: A5 53
	cmp.w #$000E		; $80E66B: C9 0E 00
	beq .chg		; $80E66E: F0 3E
	ldy.b a0		; $80E670: A4 33  hidden
	lda.w #$FFFF		; $80E672: A9 FF FF
	sta.w ffoz,y		; $80E675: 99 28 01
	lda.b d0		; $80E678: A5 53
	cmp.w #$000F		; $80E67A: C9 0F 00
	beq .next		; $80E67D: F0 33
	asl.b d0		; $80E67F: 06 53  pad at the player
	ldy.b d0		; $80E681: A4 53
	lda.w Xpos,y		; $80E683: B9 FF 08
	ldy.b a0		; $80E686: A4 33
	sta.w ffox,y		; $80E688: 99 14 01
	ldy.b d0		; $80E68B: A4 53
	lda.w Ypos,y		; $80E68D: B9 5F 09
	ldy.b a0		; $80E690: A4 33
	sta.w ffoy,y		; $80E692: 99 1E 01
	lda.w #$0000		; $80E695: A9 00 00
	sta.w ffoz,y		; $80E698: 99 28 01
	ldy.b d0		; $80E69B: A4 53
	lda.w position,y		; $80E69D: B9 9F 0B
	xba		; $80E6A0: EB
	and.w #$FF00		; $80E6A1: 29 00 FF
	sta.b d1		; $80E6A4: 85 57
	lda.w rostnum,y		; $80E6A6: B9 3F 10
	and.w #$00FF		; $80E6A9: 29 FF 00
	tsb.b d1		; $80E6AC: 04 57
.chg:
	lda.b d1		; $80E6AE: A5 57
	sta.b [a1]		; $80E6B0: 87 37
.next:
	lda.b d3		; $80E6B2: A5 5F
	lsr a		; $80E6B4: 4A
	lsr a		; $80E6B5: 4A
	lsr a		; $80E6B6: 4A
	lsr a		; $80E6B7: 4A
	sta.b d3		; $80E6B8: 85 5F
	inc.b a0		; $80E6BA: E6 33
	inc.b a0		; $80E6BC: E6 33
	inc.b a1		; $80E6BE: E6 37
	inc.b a1		; $80E6C0: E6 37
	dec.b d4		; $80E6C2: C6 63
	bpl .top		; $80E6C4: 10 97
	rtl		; $80E6C6: 6B
PenaltyManager:		;auto: CODE_80E6C7. 93G PenaltyManager (penalty93_1): called periodically, d7 = elapsed time: updatepentime, checkfornewpen, chkprogress, UpdatePA
	jsl.l $8F8C72		; $80E6C7: 22 72 8C 8F  updatepentime, checkfornewpen, chkprogress, then UpdatePA, bank $8F: 93G updatepentime
	jsl.l checkfornewpen		; $80E6CB: 22 15 E7 80
	jsl.l chkprogress		; $80E6CF: 22 9F E9 80
	jmp.w UpdatePA		; $80E6D3: 4C C7 EC
chkatop:		;auto: CODE_80E6D6. 93G chkatop (penalty93_1): attack time of possession: tmATOP +1 for the team with the puck past the blue line ($58)
	stz.b d1		; $80E6D6: 64 57
	lda.w pucky		; $80E6D8: AD 7B 09
	sec		; $80E6DB: 38
	sbc.w #$0058		; $80E6DC: E9 58 00
	beq .lo		; $80E6DF: F0 08
	bmi .v1		; $80E6E1: 30 04
	bvs .lo		; $80E6E3: 70 04
	bra .one		; $80E6E5: 80 15
.v1:
	bvs .one		; $80E6E7: 70 13
.lo:
	inc.b d1		; $80E6E9: E6 57
	inc.b d1		; $80E6EB: E6 57
	lda.w pucky		; $80E6ED: AD 7B 09
	sec		; $80E6F0: 38
	sbc.w #$FFA8		; $80E6F1: E9 A8 FF
	bmi .v2		; $80E6F4: 30 04
	bvs .one		; $80E6F6: 70 04
	bra .rtl		; $80E6F8: 80 1A
.v2:
	bvs .rtl		; $80E6FA: 70 18
.one:		;93G .1
	lda.w gmode		; $80E6FC: AD 88 12  gmdir: swap the teams
	bit.w #gmdir		; $80E6FF: 89 02 00
	beq .zero		; $80E702: F0 07
	lda.b d1		; $80E704: A5 57
	eor.w #$0002		; $80E706: 49 02 00
	sta.b d1		; $80E709: 85 57
.zero:
	ldy.b d1		; $80E70B: A4 57
	lda.w tmATOP,y		; $80E70D: B9 CA 13
	inc a		; $80E710: 1A
	sta.w tmATOP,y		; $80E711: 99 CA 13
.rtl:
	rtl		; $80E714: 6B
checkfornewpen:		;auto: CODE_80E715. 93G checkfornewpen (penalty93_1): new penalties in PenBuf. Stops play at once for penalties without minutes or when the guilty team has the puck, otherwise a delayed penalty call
	lda.w sfhormode		; $80E715: AD 8E 12  not in horizontal mode
	beq .go		; $80E718: F0 03
	jmp.w .rtl		; $80E71A: 4C DF E7
.go:
	lda.w #PenBuf		; $80E71D: A9 9E 12
	sta.b a0		; $80E720: 85 33
.next:
	lda.b (a0)		; $80E722: B2 33
	inc.b a0		; $80E724: E6 33
	inc.b a0		; $80E726: E6 33
	tay		; $80E728: A8
	bne .notcalled		; $80E729: D0 03
	jmp.w .rtl		; $80E72B: 4C DF E7
.notcalled:
	lda.w gmode		; $80E72E: AD 88 12  already called: mark it
	bit.w #gmpen		; $80E731: 89 04 00
	bne .iscalled		; $80E734: D0 50
	dec.b a0		; $80E736: C6 33
	dec.b a0		; $80E738: C6 33
	lda.b (a0)		; $80E73A: B2 33
	inc.b a0		; $80E73C: E6 33
	inc.b a0		; $80E73E: E6 33
	and.w #$00FF		; $80E740: 29 FF 00
	sta.b d0		; $80E743: 85 53
	tay		; $80E745: A8
	lda.w #PenaltyList		; $80E746: A9 6A BF  a1 = PenaltyList entry; minutes?
	sta.b a1		; $80E749: 85 37
	lda.w #PenaltyList>>16		; $80E74B: A9 80 00
	sta.b a1+2		; $80E74E: 85 39
	lda.b [a1],y		; $80E750: B7 37
	clc		; $80E752: 18
	adc.b a1		; $80E753: 65 37
	sta.b a1		; $80E755: 85 37
	lda.b [a1]		; $80E757: A7 37
	and.w #$00FF		; $80E759: 29 FF 00
	beq .callit		; $80E75C: F0 24
	lda.w puckc		; $80E75E: AD BB 0E  no carrier, or the guilty team has the puck... else delayed call
	bmi .dc		; $80E761: 30 7D
	sec		; $80E763: 38
	sbc.w #$0006		; $80E764: E9 06 00
	sta.b d0		; $80E767: 85 53
	dec.b a0		; $80E769: C6 33
	lda.b (a0)		; $80E76B: B2 33
	inc.b a0		; $80E76D: E6 33
	and.w #$00FF		; $80E76F: 29 FF 00
	bit.w #$0080		; $80E772: 89 80 00
	beq .pl		; $80E775: F0 03
	ora.w #$FF00		; $80E777: 09 00 FF
.pl:
	sec		; $80E77A: 38
	sbc.w #$0006		; $80E77B: E9 06 00
	eor.b d0		; $80E77E: 45 53
	bmi .dc		; $80E780: 30 5E
.callit:
	jsl.l Stop4Pen		; $80E782: 22 F7 E7 80
.iscalled:		;mark it called (bit 7 of the player byte)
	dec.b a0		; $80E786: C6 33
	lda.b (a0)		; $80E788: B2 33
	tay		; $80E78A: A8
	ora.w #$0080		; $80E78B: 09 80 00
	sta.b (a0)		; $80E78E: 92 33
	inc.b a0		; $80E790: E6 33
	tya		; $80E792: 98
	bit.w #$0080		; $80E793: 89 80 00
	bne .next		; $80E796: D0 8A
	dec.b a0		; $80E798: C6 33
	dec.b a0		; $80E79A: C6 33
	lda.b (a0)		; $80E79C: B2 33
	inc.b a0		; $80E79E: E6 33
	inc.b a0		; $80E7A0: E6 33
	and.w #$00FF		; $80E7A2: 29 FF 00
	sta.b d0		; $80E7A5: 85 53
	tay		; $80E7A7: A8
	lda.w #PenaltyList		; $80E7A8: A9 6A BF  delay byte (+1) * 32
	sta.b a1		; $80E7AB: 85 37
	lda.w #PenaltyList>>16		; $80E7AD: A9 80 00
	sta.b a1+2		; $80E7B0: 85 39
	lda.b [a1],y		; $80E7B2: B7 37
	clc		; $80E7B4: 18
	adc.b a1		; $80E7B5: 65 37
	sta.b a1		; $80E7B7: 85 37
	ldy.w #$0001		; $80E7B9: A0 01 00
	lda.b [a1],y		; $80E7BC: B7 37
	and.w #$00FF		; $80E7BE: 29 FF 00
	asl a		; $80E7C1: 0A
	asl a		; $80E7C2: 0A
	asl a		; $80E7C3: 0A
	asl a		; $80E7C4: 0A
	asl a		; $80E7C5: 0A
	sta.b d1		; $80E7C6: 85 57
	sec		; $80E7C8: 38
	sbc.w Pencntdwn		; $80E7C9: ED E0 12
	beq .nx		; $80E7CC: F0 04
	bmi .v1		; $80E7CE: 30 05
	bvc .longer		; $80E7D0: 50 05
.nx:
	jmp.w .next		; $80E7D2: 4C 22 E7
.v1:
	bvc .nx		; $80E7D5: 50 FB
.longer:		;Pencntdwn = delay*32 if longer
	lda.b d1		; $80E7D7: A5 57
	sta.w Pencntdwn		; $80E7D9: 8D E0 12
	jmp.w .next		; $80E7DC: 4C 22 E7
.rtl:
	rtl		; $80E7DF: 6B
.dc:		;delayed call: PenDelay ref once
	lda.w #gmpendel		; $80E7E0: A9 08 00  first delayed call: SetPA PenDelay
	tsb.w gmode		; $80E7E3: 0C 88 12
	beq .dc2		; $80E7E6: F0 03
	jmp.w .next		; $80E7E8: 4C 22 E7
.dc2:
	lda.w #PenDelay		; $80E7EB: A9 2C 00
	sta.b d0		; $80E7EE: 85 53
	jsl.l SetPA		; $80E7F0: 22 0C ED 80
	jmp.w .next		; $80E7F4: 4C 22 E7
Stop4Pen:		;auto: CODE_80E7F7. 93G Stop4Pen (penalty93_1): a0 = PenBuf entry +2. Stop the clock, set the face off spot from the penalty type, blow the whistle
	lda.w #$FFFF		; $80E7F7: A9 FF FF  clock already stopped: skip the face off spot
	tsb.w gmclock		; $80E7FA: 0C 8A 12
	beq .spot		; $80E7FD: F0 03
	jmp.w .skipfo		; $80E7FF: 4C CC E8
.spot:		;goal: center; OOP: last touch; icing: the end of the icing team (+-600); else the puck
	stz.b d0		; $80E802: 64 53
	stz.b d1		; $80E804: 64 57
	dec.b a0		; $80E806: C6 33
	dec.b a0		; $80E808: C6 33
	lda.b (a0)		; $80E80A: B2 33
	inc.b a0		; $80E80C: E6 33
	inc.b a0		; $80E80E: E6 33
	and.w #$00FF		; $80E810: 29 FF 00
	cmp.w #PenGoal		; $80E813: C9 0E 00  goal: center ice
	beq .noticing		; $80E816: F0 38
	ldy.w ltx		; $80E818: AC 8D 01
	sty.b d0		; $80E81B: 84 53
	ldy.w lty		; $80E81D: AC 8F 01
	sty.b d1		; $80E820: 84 57
	cmp.w #PenOOP		; $80E822: C9 06 00  OOP: last touch
	beq .noticing		; $80E825: F0 29
	ldy.w puckx		; $80E827: AC 1B 09
	sty.b d0		; $80E82A: 84 53
	ldy.w pucky		; $80E82C: AC 7B 09
	sty.b d1		; $80E82F: 84 57
	cmp.w #PenIcing		; $80E831: C9 0C 00  icing: +-600 by pfgoal of the icing player
	bne .noticing		; $80E834: D0 1A
	dec.b a0		; $80E836: C6 33
	lda.b (a0)		; $80E838: B2 33
	inc.b a0		; $80E83A: E6 33
	and.w #$00FF		; $80E83C: 29 FF 00
	asl a		; $80E83F: 0A
	tay		; $80E840: A8
	lda.w #$0258		; $80E841: A9 58 02
	sta.b d1		; $80E844: 85 57
	lda.w pfgoal,y		; $80E846: B9 3F 11
	beq .noticing		; $80E849: F0 05
	lda.w #$FDA8		; $80E84B: A9 A8 FD
	sta.b d1		; $80E84E: 85 57
.noticing:
	lda.b d0		; $80E850: A5 53  x within +-70; y near the ends: end face off spots (+-206, x +-70)
	sta.b tmp0		; $80E852: 85 73
	sec		; $80E854: 38
	sbc.w #$0046		; $80E855: E9 46 00
	bmi .v0		; $80E858: 30 04
	bvc .x0		; $80E85A: 50 04
	bra .zero		; $80E85C: 80 07
.v0:
	bvc .zero		; $80E85E: 50 05
.x0:
	lda.w #$0046		; $80E860: A9 46 00
	sta.b d0		; $80E863: 85 53
.zero:		;93G .0
	lda.b d0		; $80E865: A5 53
	sec		; $80E867: 38
	sbc.w #$FFBA		; $80E868: E9 BA FF
	beq .x1		; $80E86B: F0 08
	bmi .v1		; $80E86D: 30 04
	bvs .x1		; $80E86F: 70 04
	bra .one		; $80E871: 80 07
.v1:
	bvs .one		; $80E873: 70 05
.x1:
	lda.w #$FFBA		; $80E875: A9 BA FF
	sta.b d0		; $80E878: 85 53
.one:		;93G .1
	lda.b d1		; $80E87A: A5 57
	sec		; $80E87C: 38
	sbc.w #$00A6		; $80E87D: E9 A6 00
	bmi .v2		; $80E880: 30 04
	bvc .yhi		; $80E882: 50 04
	bra .two		; $80E884: 80 15
.v2:
	bvc .two		; $80E886: 50 13
.yhi:
	lda.w #$00CE		; $80E888: A9 CE 00
	sta.b d1		; $80E88B: 85 57
	lda.w #$0046		; $80E88D: A9 46 00
	sta.b d0		; $80E890: 85 53
	lda.b tmp0		; $80E892: A5 73
	bpl .two		; $80E894: 10 05
	lda.w #$FFBA		; $80E896: A9 BA FF
	sta.b d0		; $80E899: 85 53
.two:		;93G .2
	lda.b d1		; $80E89B: A5 57
	sec		; $80E89D: 38
	sbc.w #$FF5A		; $80E89E: E9 5A FF
	beq .ylo		; $80E8A1: F0 08
	bmi .v3		; $80E8A3: 30 04
	bvs .ylo		; $80E8A5: 70 04
	bra .three		; $80E8A7: 80 15
.v3:
	bvs .three		; $80E8A9: 70 13
.ylo:
	lda.w #$FF32		; $80E8AB: A9 32 FF
	sta.b d1		; $80E8AE: 85 57
	lda.w #$0046		; $80E8B0: A9 46 00
	sta.b d0		; $80E8B3: 85 53
	lda.b tmp0		; $80E8B5: A5 73
	bpl .three		; $80E8B7: 10 05
	lda.w #$FFBA		; $80E8B9: A9 BA FF
	sta.b d0		; $80E8BC: 85 53
.three:		;93G .3
	lda.b d0		; $80E8BE: A5 53
	sta.w fox		; $80E8C0: 8D 46 01
	lda.b d1		; $80E8C3: A5 57
	sta.w foy		; $80E8C5: 8D 48 01
	jsl.l limitfo		; $80E8C8: 22 F4 E8 80
.skipfo:
	lda.b vcount		; $80E8CC: A5 00  sound cut off within 60 frames: reset the queue
	sec		; $80E8CE: 38
	sbc.w sfxmutetime		; $80E8CF: ED A7 04
	cmp.w #$003C		; $80E8D2: C9 3C 00
	bcc .snd		; $80E8D5: 90 04
	jsl.l $82FA1A		; $80E8D7: 22 1A FA 82  bank $82: reset the sound command queue
.snd:
	lda.w #SFXwhistle		; $80E8DB: A9 89 00  whistle, Pencntdwn = 0, gmpen, SetPA PenWhistle
	pha		; $80E8DE: 48
	jsl.l sfx		; $80E8DF: 22 8B C2 80
	stz.w Pencntdwn		; $80E8E3: 9C E0 12
	lda.w #gmpen		; $80E8E6: A9 04 00
	tsb.w gmode		; $80E8E9: 0C 88 12
	lda.w #PenWhistle		; $80E8EC: A9 0A 00
	sta.b d0		; $80E8EF: 85 53
	jmp.w SetPA		; $80E8F1: 4C 0C ED
limitfo:		;auto: CODE_80E8F4. 93G limitfo (penalty93_1): keep the face off spot 65 from the blue line for every player in PenBuf
	stx.b xsave		; $80E8F4: 86 0A
	ldx.w #$0000		; $80E8F6: A2 00 00
.pushd:
	lda.b d0,x		; $80E8F9: B5 53
	pha		; $80E8FB: 48
	inx		; $80E8FC: E8
	inx		; $80E8FD: E8
	cpx.w #$0008		; $80E8FE: E0 08 00
	bne .pushd		; $80E901: D0 F6
	ldx.b xsave		; $80E903: A6 0A
	stx.b xsave		; $80E905: 86 0A
	ldx.w #$0000		; $80E907: A2 00 00
.pusha:
	lda.b a0,x		; $80E90A: B5 33
	pha		; $80E90C: 48
	inx		; $80E90D: E8
	inx		; $80E90E: E8
	cpx.w #$0008		; $80E90F: E0 08 00
	bne .pusha		; $80E912: D0 F6
	ldx.b xsave		; $80E914: A6 0A
	lda.w #PenBuf		; $80E916: A9 9E 12
	sta.b a0		; $80E919: 85 33
	lda.w #$0000		; $80E91B: A9 00 00
	sta.b a0+2		; $80E91E: 85 35
.loop:
	jsl.l .lf		; $80E920: 22 49 E9 80
	inc.b a0		; $80E924: E6 33
	inc.b a0		; $80E926: E6 33
	lda.b [a0]		; $80E928: A7 33
	bne .loop		; $80E92A: D0 F4
	stx.b xsave		; $80E92C: 86 0A
	ldx.w #$0006		; $80E92E: A2 06 00
.popa:
	pla		; $80E931: 68
	sta.b a0,x		; $80E932: 95 33
	dex		; $80E934: CA
	dex		; $80E935: CA
	bpl .popa		; $80E936: 10 F9
	ldx.b xsave		; $80E938: A6 0A
	stx.b xsave		; $80E93A: 86 0A
	ldx.w #$0006		; $80E93C: A2 06 00
.popd:
	pla		; $80E93F: 68
	sta.b d0,x		; $80E940: 95 53
	dex		; $80E942: CA
	dex		; $80E943: CA
	bpl .popd		; $80E944: 10 F9
	ldx.b xsave		; $80E946: A6 0A
	rtl		; $80E948: 6B
.lf:		;IDA limitfo_lf: a0 = PenBuf entry
	lda.b [a0]		; $80E949: A7 33  player SCnum*2; blue line +-$58 by pfgoal
	xba		; $80E94B: EB
	and.w #$007F		; $80E94C: 29 7F 00
	asl a		; $80E94F: 0A
	tay		; $80E950: A8
	lda.w #$0058		; $80E951: A9 58 00
	sta.b d1		; $80E954: 85 57
	lda.w pfgoal,y		; $80E956: B9 3F 11
	bne .zero		; $80E959: D0 19
	lda.w #$FFA8		; $80E95B: A9 A8 FF
	sta.b d1		; $80E95E: 85 57
	sec		; $80E960: 38
	sbc.w foy		; $80E961: ED 48 01
	bmi .v1		; $80E964: 30 04
	bvc .ny		; $80E966: 50 04
	bra .rtl		; $80E968: 80 34
.v1:
	bvc .rtl		; $80E96A: 50 32
.ny:
	lda.w #$FFBF		; $80E96C: A9 BF FF
	sta.w foy		; $80E96F: 8D 48 01
	bra .sx		; $80E972: 80 16
.zero:		;93G .0
	lda.b d1		; $80E974: A5 57
	sec		; $80E976: 38
	sbc.w foy		; $80E977: ED 48 01
	beq .py		; $80E97A: F0 08
	bmi .v2		; $80E97C: 30 04
	bvs .py		; $80E97E: 70 04
	bra .rtl		; $80E980: 80 1C
.v2:
	bvs .rtl		; $80E982: 70 1A
.py:
	lda.w #$0041		; $80E984: A9 41 00
	sta.w foy		; $80E987: 8D 48 01
.sx:
	lda.w #$0046		; $80E98A: A9 46 00
	sta.b d0		; $80E98D: 85 53
	lda.w fox		; $80E98F: AD 46 01
	bpl .one		; $80E992: 10 05
	lda.w #$FFBA		; $80E994: A9 BA FF
	sta.b d0		; $80E997: 85 53
.one:
	lda.b d0		; $80E999: A5 53
	sta.w fox		; $80E99B: 8D 46 01
.rtl:
	rtl		; $80E99E: 6B
chkprogress:		;auto: CODE_80E99F. 93G chkprogress (penalty93_1): when the stop delay runs out and a penalty with minutes is in PenBuf, switch to the horizontal rink for the player to enter the box
	lda.w gmode		; $80E99F: AD 88 12  gmpen: ref in progress
	bit.w #gmpen		; $80E9A2: 89 04 00
	bne .pen		; $80E9A5: D0 03
	jmp.w .rtl		; $80E9A7: 4C 3F EA
.pen:
	lda.w Pencntdwn		; $80E9AA: AD E0 12  Pencntdwn negative: InProgress
	bpl .cnt		; $80E9AD: 10 03
	jmp.w InProgress		; $80E9AF: 4C 40 EA
.cnt:
	sec		; $80E9B2: 38
	sbc.b d7		; $80E9B3: E5 6F
	sta.w Pencntdwn		; $80E9B5: 8D E0 12
	bmi .out		; $80E9B8: 30 03
	jmp.w .rtl		; $80E9BA: 4C 3F EA
.out:
	lda.w #gmpendel		; $80E9BD: A9 08 00  stop delay over: clear gmpendel
	trb.w gmode		; $80E9C0: 1C 88 12
	lda.w #PenBuf		; $80E9C3: A9 9E 12
	sta.b a0		; $80E9C6: 85 33
	lda.w #$0000		; $80E9C8: A9 00 00
	sta.b a0+2		; $80E9CB: 85 35
.find:
	lda.b [a0]		; $80E9CD: A7 33
	inc.b a0		; $80E9CF: E6 33
	inc.b a0		; $80E9D1: E6 33
	tay		; $80E9D3: A8
	beq .rtl		; $80E9D4: F0 69
	dec.b a0		; $80E9D6: C6 33
	dec.b a0		; $80E9D8: C6 33
	lda.b [a0]		; $80E9DA: A7 33
	inc.b a0		; $80E9DC: E6 33
	inc.b a0		; $80E9DE: E6 33
	and.w #$00FF		; $80E9E0: 29 FF 00
	sta.b d0		; $80E9E3: 85 53
	tay		; $80E9E5: A8
	lda.w #PenaltyList>>16		; $80E9E6: A9 80 00
	sta.b a1+2		; $80E9E9: 85 39
	lda.w #PenaltyList		; $80E9EB: A9 6A BF
	sta.b a1		; $80E9EE: 85 37
	clc		; $80E9F0: 18
	adc.b [a1],y		; $80E9F1: 77 37
	sta.b a1		; $80E9F3: 85 37
	lda.b [a1]		; $80E9F5: A7 37  penalty with minutes?
	and.w #$00FF		; $80E9F7: 29 FF 00
	beq .find		; $80E9FA: F0 D1
	lda.w #sf2drec		; $80E9FC: A9 00 04  sf2drec, SetHor, load the horizontal ref; the puck does nothing for 120 s
	tsb.w sflags		; $80E9FF: 0C 8C 12
	jsl.l $8F84B5		; $80EA02: 22 B5 84 8F  bank $8F: 93G SetHor
	jsl.l $8F8858		; $80EA06: 22 58 88 8F  bank $8F: 93G NewTicker (horizontal ref)
	lda.w #$FF00		; $80EA0A: A9 00 FF
	tsb.w puckc		; $80EA0D: 0C BB 0E
	ldx.w #puckobj		; $80EA10: A2 1C 00
	stx.b a3		; $80EA13: 86 3F
	lda.w #pnothing		; $80EA15: A9 1A 00
	sta.b d0		; $80EA18: 85 53
	jsl.l assinsert		; $80EA1A: 22 9D B4 80
	lda.w #$1C20		; $80EA1E: A9 20 1C
	ldx.b a3		; $80EA21: A6 3F
	sta.w temp1,x		; $80EA23: 9D 5F 0C
	lda.w #$FF00		; $80EA26: A9 00 FF  RefStep negative, RefCnt 0; UpdatePA; RefCnt 50; PushRef 0
	tsb.w RefStep		; $80EA29: 0C EC 12
	stz.w RefCnt		; $80EA2C: 9C EA 12
	jsl.l UpdatePA		; $80EA2F: 22 C7 EC 80
	lda.w #$0032		; $80EA33: A9 32 00
	sta.w RefCnt		; $80EA36: 8D EA 12
	stz.b d0		; $80EA39: 64 53
	jsl.l $8F83A7		; $80EA3B: 22 A7 83 8F  bank $8F: 93G PushRef
.rtl:
	rtl		; $80EA3F: 6B
InProgress:		;auto: CODE_80EA40. 93G InProgress (penalty93_1): ref in progress. Takes the last PenBuf entry: the first pass logs a penalty with minutes and sends the player to the box, later passes clear it; at the end coinsearch and the face off
	lda.w RefCnt		; $80EA40: AD EA 12  animation in progress: exit
	bmi .step		; $80EA43: 30 03
	jmp.w .rtl		; $80EA45: 4C 88 EC
.step:
	lda.w RefStep		; $80EA48: AD EC 12
	bmi .go		; $80EA4B: 30 03
	jmp.w .rtl		; $80EA4D: 4C 88 EC
.go:
	stx.b xsave		; $80EA50: 86 0A
	ldx.w #$0000		; $80EA52: A2 00 00
.pushd:
	lda.b d0,x		; $80EA55: B5 53
	pha		; $80EA57: 48
	inx		; $80EA58: E8
	inx		; $80EA59: E8
	cpx.w #$0004		; $80EA5A: E0 04 00
	bne .pushd		; $80EA5D: D0 F6
	ldx.b xsave		; $80EA5F: A6 0A
	stx.b xsave		; $80EA61: 86 0A
	ldx.w #$0000		; $80EA63: A2 00 00
.pusha:
	lda.b a0,x		; $80EA66: B5 33
	pha		; $80EA68: 48
	inx		; $80EA69: E8
	inx		; $80EA6A: E8
	cpx.w #$0010		; $80EA6B: E0 10 00
	bne .pusha		; $80EA6E: D0 F6
	ldx.b xsave		; $80EA70: A6 0A
.top:
	lda.w #$0000		; $80EA72: A9 00 00
	sta.b a0+2		; $80EA75: 85 35
	lda.w #PenBuf		; $80EA77: A9 9E 12
	sta.b a0		; $80EA7A: 85 33
	lda.b [a0]		; $80EA7C: A7 33
	inc.b a0		; $80EA7E: E6 33
	inc.b a0		; $80EA80: E6 33
	cmp.w #$0000		; $80EA82: C9 00 00
	bne .end		; $80EA85: D0 03
	jmp.w .exit		; $80EA87: 4C 47 EC
.end:		;find the end of the list
	lda.b [a0]		; $80EA8A: A7 33
	inc.b a0		; $80EA8C: E6 33
	inc.b a0		; $80EA8E: E6 33
	cmp.w #$0000		; $80EA90: C9 00 00
	bne .end		; $80EA93: D0 F5
	dec.b a0		; $80EA95: C6 33
	dec.b a0		; $80EA97: C6 33
	dec.b a0		; $80EA99: C6 33
	dec.b a0		; $80EA9B: C6 33
	lda.b [a0]		; $80EA9D: A7 33  clear bit 15 of the entry (first pass)
	pha		; $80EA9F: 48
	and.w #$7FFF		; $80EAA0: 29 FF 7F
	sta.b [a0]		; $80EAA3: 87 33
	pla		; $80EAA5: 68
	bmi .Sa		; $80EAA6: 30 1A
	lda.b [a0]		; $80EAA8: A7 33  later pass: clear it when the player left the ice
	xba		; $80EAAA: EB
	and.w #$00FF		; $80EAAB: 29 FF 00
	asl a		; $80EAAE: 0A
	sta.b d1		; $80EAAF: 85 57
	tay		; $80EAB1: A8
	lda.w position,y		; $80EAB2: B9 9F 0B
	bmi .clr		; $80EAB5: 30 03
	jmp.w .ex		; $80EAB7: 4C 6A EC
.clr:
	lda.w #$0000		; $80EABA: A9 00 00
	sta.b [a0]		; $80EABD: 87 33
	jmp.w .ex		; $80EABF: 4C 6A EC
.Sa:
	lda.b [a0]		; $80EAC2: A7 33  d2 = penalty minutes; none: no player involved
	and.w #$00FF		; $80EAC4: 29 FF 00
	sta.b d0		; $80EAC7: 85 53
	tay		; $80EAC9: A8
	lda.w #PenaltyList		; $80EACA: A9 6A BF
	sta.b a1		; $80EACD: 85 37
	lda.w #PenaltyList>>16		; $80EACF: A9 80 00
	sta.b a1+2		; $80EAD2: 85 39
	lda.b [a1],y		; $80EAD4: B7 37
	clc		; $80EAD6: 18
	adc.b a1		; $80EAD7: 65 37
	sta.b a1		; $80EAD9: 85 37
	lda.b [a1]		; $80EADB: A7 37
	and.w #$00FF		; $80EADD: 29 FF 00
	sta.b d2		; $80EAE0: 85 5B
	bne .min		; $80EAE2: D0 03
	jmp.w .sa2		; $80EAE4: 4C 34 EC
.min:
	stx.b xsave		; $80EAE7: 86 0A
	ldx.w #$0000		; $80EAE9: A2 00 00
.pushd2:
	lda.b d0,x		; $80EAEC: B5 53
	pha		; $80EAEE: 48
	inx		; $80EAEF: E8
	inx		; $80EAF0: E8
	cpx.w #$0008		; $80EAF1: E0 08 00
	bne .pushd2		; $80EAF4: D0 F6
	ldx.b xsave		; $80EAF6: A6 0A
	stx.b xsave		; $80EAF8: 86 0A
	ldx.w #$0000		; $80EAFA: A2 00 00
.pusha2:
	lda.b a1,x		; $80EAFD: B5 37
	pha		; $80EAFF: 48
	inx		; $80EB00: E8
	inx		; $80EB01: E8
	cpx.w #$0010		; $80EB02: E0 10 00
	bne .pusha2		; $80EB05: D0 F6
	ldx.b xsave		; $80EB07: A6 0A
	jsl.l $86FC8A		; $80EB09: 22 8A FC 86  GetPeriodTimeRemaining, bank $86: 93G GetPeriodTimeRemaining (d0)
	lda.b [a0]		; $80EB0D: A7 33
	xba		; $80EB0F: EB
	and.w #$00FF		; $80EB10: 29 FF 00
	asl a		; $80EB13: 0A
	sta.b d1		; $80EB14: 85 57
	tax		; $80EB16: AA
	stx.b a3		; $80EB17: 86 3F
	stz.b d0		; $80EB19: 64 53
	stz.b a2		; $80EB1B: 64 3B  a2 = penalized team, a1 = other; d0 = $8000 for the visitors
	lda.w #$0002		; $80EB1D: A9 02 00
	sta.b a1		; $80EB20: 85 37
	lda.w pfteam,x		; $80EB22: BD 9F 11
	beq .sa1		; $80EB25: F0 0C
	lda.w #$8000		; $80EB27: A9 00 80
	sta.b d0		; $80EB2A: 85 53
	stz.b a1		; $80EB2C: 64 37
	lda.w #$0002		; $80EB2E: A9 02 00
	sta.b a2		; $80EB31: 85 3B
.sa1:
	ldy.b a2		; $80EB33: A4 3B  tmPenalties +1, tmPenmin += minutes
	lda.w tmPenalties,y		; $80EB35: B9 BE 13
	inc a		; $80EB38: 1A
	sta.w tmPenalties,y		; $80EB39: 99 BE 13
	lda.w tmPenmin,y		; $80EB3C: B9 C2 13
	clc		; $80EB3F: 18
	adc.b d2		; $80EB40: 65 5B
	sta.w tmPenmin,y		; $80EB42: 99 C2 13
	lda.w pnum,x		; $80EB45: BD 1F 0F  TempPlOffset = pnum | visitors
	and.w #$00FF		; $80EB48: 29 FF 00
	ora.b d0		; $80EB4B: 05 53
	sta.w TempPlOffset		; $80EB4D: 8D FA 12
	and.w #$00FF		; $80EB50: 29 FF 00
	bit.w #$0080		; $80EB53: 89 80 00
	beq .pn		; $80EB56: F0 03
	ora.w #$FF00		; $80EB58: 09 00 FF
.pn:
	asl a		; $80EB5B: 0A
	sta.b d0		; $80EB5C: 85 53
	lda.w #$003C		; $80EB5E: A9 3C 00  d2 = minutes*60 | $2000
	sta.b mula		; $80EB61: 85 7D
	lda.b d2		; $80EB63: A5 5B
	and.w #$00FF		; $80EB65: 29 FF 00
	sta.b mulb		; $80EB68: 85 83
	jsl.l $8D871C		; $80EB6A: 22 1C 87 8D  bank $8D: mulu, A = mula*mulb
	ora.w #$2000		; $80EB6E: 09 00 20
	sta.b d2		; $80EB71: 85 5B
	lda.b a2		; $80EB73: A5 3B
	beq .tm		; $80EB75: F0 03
	lda.w #$0034		; $80EB77: A9 34 00
.tm:
	clc		; $80EB7A: 18
	adc.b d0		; $80EB7B: 65 53
	tay		; $80EB7D: A8
	lda.w tmpdst,y		; $80EB7E: B9 E2 14  keep TMPDINJ of an old penalty time
	bmi .st		; $80EB81: 30 05
	and.w #TMPDINJ		; $80EB83: 29 00 10
	tsb.b d2		; $80EB86: 04 5B
.st:
	lda.b d2		; $80EB88: A5 5B
	sta.w tmpdst,y		; $80EB8A: 99 E2 14
	lda.w #TMPDINJ		; $80EB8D: A9 00 10
	trb.b d2		; $80EB90: 14 5B
	lda.w #$0034		; $80EB92: A9 34 00
	sta.b d1		; $80EB95: 85 57
.ctop:		;same time on the other team: coincidental
	dec.b d1		; $80EB97: C6 57
	dec.b d1		; $80EB99: C6 57
	bmi .nocoin		; $80EB9B: 30 34
	lda.b a1		; $80EB9D: A5 37
	beq .ct		; $80EB9F: F0 03
	lda.w #$0034		; $80EBA1: A9 34 00
.ct:
	clc		; $80EBA4: 18
	adc.b d1		; $80EBA5: 65 57
	tay		; $80EBA7: A8
	lda.w tmpdst,y		; $80EBA8: B9 E2 14
	and.w #~TMPDINJ&$FFFF		; $80EBAB: 29 FF EF
	sta.b d3		; $80EBAE: 85 5F
	cmp.b d2		; $80EBB0: C5 5B
	bne .ctop		; $80EBB2: D0 E3
	lda.w tmpdst,y		; $80EBB4: B9 E2 14  coincidental: $4000 on both
	ora.w #$4000		; $80EBB7: 09 00 40
	sta.w tmpdst,y		; $80EBBA: 99 E2 14
	lda.b a2		; $80EBBD: A5 3B
	beq .cg		; $80EBBF: F0 03
	lda.w #$0034		; $80EBC1: A9 34 00
.cg:
	clc		; $80EBC4: 18
	adc.b d0		; $80EBC5: 65 53
	tay		; $80EBC7: A8
	lda.w tmpdst,y		; $80EBC8: B9 E2 14
	ora.w #$4000		; $80EBCB: 09 00 40
	sta.w tmpdst,y		; $80EBCE: 99 E2 14
.nocoin:		;add the player to the penalty box list
	lda.b a0+2		; $80EBD1: A5 35
	pha		; $80EBD3: 48
	lda.b a0		; $80EBD4: A5 33
	pha		; $80EBD6: 48
	lda.b a2		; $80EBD7: A5 3B
	beq .bl		; $80EBD9: F0 03
	lda.w #$001A		; $80EBDB: A9 1A 00
.bl:
	sta.b a0		; $80EBDE: 85 33
	lda.w #$0018		; $80EBE0: A9 18 00
	sta.b d1		; $80EBE3: 85 57
.pl:
	ldy.b a0		; $80EBE5: A4 33
	inc.b a0		; $80EBE7: E6 33
	lda.w tmboxlist,y		; $80EBE9: B9 4A 15
	bit.w #$0080		; $80EBEC: 89 80 00
	bne .put		; $80EBEF: D0 04
	dec.b d1		; $80EBF1: C6 57
	bpl .pl		; $80EBF3: 10 F0
.put:
	lda.b d0		; $80EBF5: A5 53
	ora.w #$FF00		; $80EBF7: 09 00 FF
	sta.w tmboxlist,y		; $80EBFA: 99 4A 15
	pla		; $80EBFD: 68
	sta.b a0		; $80EBFE: 85 33
	pla		; $80EC00: 68
	sta.b a0+2		; $80EC01: 85 35
	lda.w #apenalty		; $80EC03: A9 0C 00  apenalty
	sta.b d0		; $80EC06: 85 53
	jsl.l assreplace		; $80EC08: 22 A7 B4 80
	stx.b xsave		; $80EC0C: 86 0A
	ldx.w #$000E		; $80EC0E: A2 0E 00
.popa2:
	pla		; $80EC11: 68
	sta.b a1,x		; $80EC12: 95 37
	dex		; $80EC14: CA
	dex		; $80EC15: CA
	bpl .popa2		; $80EC16: 10 F9
	ldx.b xsave		; $80EC18: A6 0A
	stx.b xsave		; $80EC1A: 86 0A
	ldx.w #$0006		; $80EC1C: A2 06 00
.popd2:
	pla		; $80EC1F: 68
	sta.b d0,x		; $80EC20: 95 53
	dex		; $80EC22: CA
	dex		; $80EC23: CA
	bpl .popd2		; $80EC24: 10 F9
	ldx.b xsave		; $80EC26: A6 0A
	ldx.b a3		; $80EC28: A6 3F  SetPA, USBoard
	jsl.l SetPA		; $80EC2A: 22 0C ED 80
	jsl.l $8F852E		; $80EC2E: 22 2E 85 8F  bank $8F: 93G USBoard
	bra .ex		; $80EC32: 80 36
.sa2:
	lda.w #$0000		; $80EC34: A9 00 00  no minutes: clear it, SetPA
	sta.b [a0]		; $80EC37: 87 33
	lda.w sfhormode		; $80EC39: AD 8E 12
	beq .sa3		; $80EC3C: F0 03
	jmp.w .top		; $80EC3E: 4C 72 EA
.sa3:
	jsl.l SetPA		; $80EC41: 22 0C ED 80
	bra .ex		; $80EC45: 80 23
.exit:
	stz.b a2		; $80EC47: 64 3B  coinsearch for both teams, clear gmpen, the puck: pfaceoff
	jsl.l coinsearch		; $80EC49: 22 89 EC 80
	lda.w #$0002		; $80EC4D: A9 02 00
	sta.b a2		; $80EC50: 85 3B
	jsl.l coinsearch		; $80EC52: 22 89 EC 80
	lda.w #gmpen		; $80EC56: A9 04 00
	trb.w gmode		; $80EC59: 1C 88 12
	ldx.w #puckobj		; $80EC5C: A2 1C 00
	stx.b a3		; $80EC5F: 86 3F
	lda.w #pfaceoff		; $80EC61: A9 1B 00
	sta.b d0		; $80EC64: 85 53
	jsl.l assreplace		; $80EC66: 22 A7 B4 80
.ex:
	stx.b xsave		; $80EC6A: 86 0A
	ldx.w #$000E		; $80EC6C: A2 0E 00
.popa:
	pla		; $80EC6F: 68
	sta.b a0,x		; $80EC70: 95 33
	dex		; $80EC72: CA
	dex		; $80EC73: CA
	bpl .popa		; $80EC74: 10 F9
	ldx.b xsave		; $80EC76: A6 0A
	stx.b xsave		; $80EC78: 86 0A
	ldx.w #$0002		; $80EC7A: A2 02 00
.popd:
	pla		; $80EC7D: 68
	sta.b d0,x		; $80EC7E: 95 53
	dex		; $80EC80: CA
	dex		; $80EC81: CA
	bpl .popd		; $80EC82: 10 F9
	ldx.b xsave		; $80EC84: A6 0A
	ldx.b a3		; $80EC86: A6 3F
.rtl:
	rtl		; $80EC88: 6B
coinsearch:		;auto: CODE_80EC89. 93G coinsearch (penalty93_1): a2 = team. Clears tmpdst bit $2000, counts the players kept off the ice by penalties (not coincidental, not injured, never below 4) into tmap
	lda.w #$0006		; $80EC89: A9 06 00  d1 = 6 players, d0 = last roster word
	sta.b d1		; $80EC8C: 85 57
	lda.w #$0032		; $80EC8E: A9 32 00
	sta.b d0		; $80EC91: 85 53
.top:
	lda.b a2		; $80EC93: A5 3B
	beq .tm		; $80EC95: F0 03
	lda.w #$0034		; $80EC97: A9 34 00
.tm:
	clc		; $80EC9A: 18
	adc.b d0		; $80EC9B: 65 53
	tay		; $80EC9D: A8
	lda.w tmpdst,y		; $80EC9E: B9 E2 14
	bmi .nap		; $80ECA1: 30 16
	beq .nap		; $80ECA3: F0 14
	and.w #$DFFF		; $80ECA5: 29 FF DF  clear bit $2000; coincidental or injured: does not count
	sta.w tmpdst,y		; $80ECA8: 99 E2 14
	bit.w #TMPDINJ|$4000		; $80ECAB: 89 00 50
	bne .nap		; $80ECAE: D0 09
	lda.b d1		; $80ECB0: A5 57
	cmp.w #$0004		; $80ECB2: C9 04 00
	beq .nap		; $80ECB5: F0 02
	dec.b d1		; $80ECB7: C6 57
.nap:
	dec.b d0		; $80ECB9: C6 53
	dec.b d0		; $80ECBB: C6 53
	bpl .top		; $80ECBD: 10 D4
	ldy.b a2		; $80ECBF: A4 3B
	lda.b d1		; $80ECC1: A5 57
	sta.w tmap,y		; $80ECC3: 99 EE 13
	rtl		; $80ECC6: 6B
UpdatePA:		;auto: CODE_80ECC7. 93G UpdatePA (penalty93_1): animate the ref (SetPA2 when RefCnt runs out); reprint the horizontal penalty message line when penmsgtimer runs out
	lda.w RefCnt		; $80ECC7: AD EA 12  RefCnt negative: idle
	bmi .rtl		; $80ECCA: 30 3F
	sec		; $80ECCC: 38
	sbc.b d7		; $80ECCD: E5 6F
	sta.w RefCnt		; $80ECCF: 8D EA 12
	bpl .zero		; $80ECD2: 10 04
	jsl.l $82F93C		; $80ECD4: 22 3C F9 82  SetPA2, bank $82: 93G SetPA2
.zero:		;93G .1
	lda.w penmsgtimer		; $80ECD8: AD E8 12
	sec		; $80ECDB: 38
	sbc.b d7		; $80ECDC: E5 6F
	sta.w penmsgtimer		; $80ECDE: 8D E8 12
	bpl .rtl		; $80ECE1: 10 28
	lda.w #$7FFF		; $80ECE3: A9 FF 7F
	sta.w penmsgtimer		; $80ECE6: 8D E8 12
	jsl.l $82FD95		; $80ECE9: 22 95 FD 82  PrintPenaltyMessagesString, then the player name centered at row $B, bank $82: 93G PrintPenaltyMessagesString
	jsl.l printz		; $80ECED: 22 0C B9 80
	dw $0005		; $80ECF1  printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	jsl.l $8D8605		; $80ECF6: 22 05 86 8D  bank $8D: 93G GetPlayerName (a1 = name)
	lda.b [a1]		; $80ECFA: A7 37
	lsr a		; $80ECFC: 4A
	sta.b d0		; $80ECFD: 85 53
	lda.w printx		; $80ECFF: AD 7B 04
	sec		; $80ED02: 38
	sbc.b d0		; $80ED03: E5 53
	sta.w printx		; $80ED05: 8D 7B 04
	jmp.w print		; $80ED08: 4C 2D B9
.rtl:
	rtl		; $80ED0B: 6B
SetPA:		;auto: CODE_80ED0C. 93G SetPA (penalty93_1): start the ref animation for penalty d0: prefmes, DisplayPlayerAttributeMenu for a goal, penmsgtimer (60 in horizontal mode), then SetPA2
	lda.b d0		; $80ED0C: A5 53  RefPen = d0, RefStep = 0, prefmes
	sta.w RefPen		; $80ED0E: 8D EE 12
	stz.w RefStep		; $80ED11: 9C EC 12
	jsl.l $8FF63D		; $80ED14: 22 3D F6 8F  bank $8F: 93G prefmes
	lda.b d0		; $80ED18: A5 53
	cmp.w #PenGoal		; $80ED1A: C9 0E 00  goal: DisplayPlayerAttributeMenu
	bne .zero		; $80ED1D: D0 04
	jsl.l $8FFEB4		; $80ED1F: 22 B4 FE 8F  bank $8F: 93G DisplayPlayerAttributeMenu
.zero:		;93G .0
	lda.w #$7FFF		; $80ED23: A9 FF 7F
	sta.w penmsgtimer		; $80ED26: 8D E8 12
	lda.w sfhormode		; $80ED29: AD 8E 12
	beq .pa2		; $80ED2C: F0 06
	lda.w #$003C		; $80ED2E: A9 3C 00
	sta.w penmsgtimer		; $80ED31: 8D E8 12
.pa2:
	jml.l $82F93C		; $80ED34: 5C 3C F9 82  bank $82: 93G SetPA2
