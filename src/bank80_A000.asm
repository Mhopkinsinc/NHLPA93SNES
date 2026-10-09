; $80A121-$80B005  ROM $02121-$03005: puck deflect/body/goalie collisions (hockey93_05), controller player switching (logic93_1),
; makepde, pucknothing, the faceoff (puckfaceoff, puckfaceoff2, updatefaceoff, Endfaceoff: logic93_4) with the line change box
; (SetLCmode, SetLCmode2) and ClrHor, dirtab, random/randoma, changeplayer, vtoa (logic93_5 / middle93_1).
org $80A121
deflect:		;auto: CODE_80A121. 93G deflect (hockey93_05): random puck direction on a deflection. Entered from puckstick .stdef
	lda.w #$FFFF		; $80A121: A9 FF FF  puck loose
	sta.w puckc		; $80A124: 8D BB 0E
	lda.w #$1000		; $80A127: A9 00 10  random velocity +-$1000 in y and x, 0..$1000 up
	jsl.l $80F6A1		; $80A12A: 22 A1 F6 80  randomd0s: A = random -A..A
	sta.w puckvy		; $80A12E: 8D 1B 0B
	lda.w #$1000		; $80A131: A9 00 10
	jsl.l $80F6A1		; $80A134: 22 A1 F6 80  randomd0s: A = random -A..A
	sta.w puckvx		; $80A138: 8D FB 0A
	lda.w #$1000		; $80A13B: A9 00 10
	jsl.l randoma		; $80A13E: 22 8B AE 80
	sta.w puckvz		; $80A142: 8D 3B 0B
	jmp.w puckflip		; $80A145: 4C C9 CE  puckflip
setc1player:		;auto: CODE_80A148. 93G setc1player (logic93_1): restore the old player and give controller 1 to player d0
	lda.b d0		; $80A148: A5 53
	cmp.w c1playernum		; $80A14A: CD 92 12
	beq .rtl		; $80A14D: F0 0E
	lda.w c1playernum		; $80A14F: AD 92 12
	sta.b d1		; $80A152: 85 57
	jsl.l restorepl		; $80A154: 22 74 A1 80
	lda.b d0		; $80A158: A5 53
	sta.w c1playernum		; $80A15A: 8D 92 12
.rtl:
	rtl		; $80A15D: 6B
setc2player:		;auto: CODE_80A15E. 93G setc2player (logic93_1): same for controller 2
	lda.b d0		; $80A15E: A5 53
	cmp.w c2playernum		; $80A160: CD 94 12
	beq .rtl		; $80A163: F0 0E
	lda.w c2playernum		; $80A165: AD 94 12
	sta.b d1		; $80A168: 85 57
	jsl.l restorepl		; $80A16A: 22 74 A1 80
	lda.b d0		; $80A16E: A5 53
	sta.w c2playernum		; $80A170: 8D 94 12
.rtl:
	rtl		; $80A173: 6B
restorepl:		;auto: CODE_80A174. 93G restorepl (logic93_1 IDA retorepl): release old joystick player d1, give d0 the joystick. A player in line change mode keeps control (d0 = d1)
	stz.b a0		; $80A174: 64 33
	lda.b d1		; $80A176: A5 57
	bmi .spd		; $80A178: 30 21
	cmp.w #$000C		; $80A17A: C9 0C 00  only players 0-11
	bcs .spd		; $80A17D: B0 1C
	asl.b d1		; $80A17F: 06 57
	ldy.b d1		; $80A181: A4 57
	lda.w pflags,y		; $80A183: B9 DF 0E
	bit.w #pf2lcm		; $80A186: 89 00 20  pf2lcm: he keeps the joystick
	beq .rel		; $80A189: F0 07
	lsr.b d1		; $80A18B: 46 57
	lda.b d1		; $80A18D: A5 57
	sta.b d0		; $80A18F: 85 53
	rtl		; $80A191: 6B
.rel:		;release the old player: clear pfjoycon, set pfna
	and.w #~pfjoycon&$FFFF		; $80A192: 29 F7 FF  clear pfjoycon, set pfna
	ora.w #pfna		; $80A195: 09 02 00
	sta.w pflags,y		; $80A198: 99 DF 0E
.spd:		;set pfjoycon on the new player
	lda.b d0		; $80A19B: A5 53
	bmi .rtl		; $80A19D: 30 14
	cmp.w #$000C		; $80A19F: C9 0C 00
	bcs .rtl		; $80A1A2: B0 0F
	sta.b d1		; $80A1A4: 85 57
	asl.b d1		; $80A1A6: 06 57
	ldy.b d1		; $80A1A8: A4 57
	lda.w pflags,y		; $80A1AA: B9 DF 0E
	ora.w #pfjoycon		; $80A1AD: 09 08 00
	sta.w pflags,y		; $80A1B0: 99 DF 0E
.rtl:
	rtl		; $80A1B3: 6B
makepde:		;auto: CODE_80A1B4. 93G makepde (hockey93_05): d0 = rating A (on entry) scaled by the energy of player a0: A*energy/$1000
	pha		; $80A1B4: 48
	stx.b xsave		; $80A1B5: 86 0A
	ldx.w #$0000		; $80A1B7: A2 00 00
.pushd:		;movem d1/a2-a3
	lda.b d1,x		; $80A1BA: B5 57
	pha		; $80A1BC: 48
	inx		; $80A1BD: E8
	inx		; $80A1BE: E8
	cpx.w #$0004		; $80A1BF: E0 04 00
	bne .pushd		; $80A1C2: D0 F6
	ldx.b xsave		; $80A1C4: A6 0A
	stx.b xsave		; $80A1C6: 86 0A
	ldx.w #$0000		; $80A1C8: A2 00 00
.pusha:
	lda.b a2,x		; $80A1CB: B5 3B
	pha		; $80A1CD: 48
	inx		; $80A1CE: E8
	inx		; $80A1CF: E8
	cpx.w #$0008		; $80A1D0: E0 08 00
	bne .pusha		; $80A1D3: D0 F6
	ldx.b xsave		; $80A1D5: A6 0A
	ldx.b a0		; $80A1D7: A6 33  a3 = a0 for getpde
	stx.b a3		; $80A1D9: 86 3F
	jsl.l getpde		; $80A1DB: 22 C4 84 80
	stx.b xsave		; $80A1DF: 86 0A
	ldx.w #$0006		; $80A1E1: A2 06 00
.popa:
	pla		; $80A1E4: 68
	sta.b a2,x		; $80A1E5: 95 3B
	dex		; $80A1E7: CA
	dex		; $80A1E8: CA
	bpl .popa		; $80A1E9: 10 F9
	ldx.b xsave		; $80A1EB: A6 0A
	stx.b xsave		; $80A1ED: 86 0A
	ldx.w #$0002		; $80A1EF: A2 02 00
.popd:
	pla		; $80A1F2: 68
	sta.b d1,x		; $80A1F3: 95 57
	dex		; $80A1F5: CA
	dex		; $80A1F6: CA
	bpl .popd		; $80A1F7: 10 F9
	ldx.b xsave		; $80A1F9: A6 0A
	ldx.b a3		; $80A1FB: A6 3F
	pla		; $80A1FD: 68
	sta.b mula		; $80A1FE: 85 7D
	lda.b d0		; $80A200: A5 53
	sta.b mulb		; $80A202: 85 83
	jsl.l $82FCDB		; $80A204: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	asl a		; $80A208: 0A  *16, high word: *energy/$1000
	rol.b mulres+2		; $80A209: 26 95
	asl a		; $80A20B: 0A
	rol.b mulres+2		; $80A20C: 26 95
	asl a		; $80A20E: 0A
	rol.b mulres+2		; $80A20F: 26 95
	asl a		; $80A211: 0A
	rol.b mulres+2		; $80A212: 26 95
	lda.b mulres+2		; $80A214: A5 95
	sta.b d0		; $80A216: 85 53
	clc		; $80A218: 18
	rtl		; $80A219: 6B
puckbody:		;auto: CODE_80A21A. 93G puckbody (hockey93_05): puck (X) hits player a2. d0 = distance^2. A fast high puck knocks a2 down (FallDown), a slower one plays SPAslowhit
	lda.w Zpos,x		; $80A21A: BD 9F 09  puck above 8: always a hit
	sec		; $80A21D: 38
	sbc.w #$0008		; $80A21E: E9 08 00
	beq .low		; $80A221: F0 08
	bmi .v1		; $80A223: 30 04
	bvs .low		; $80A225: 70 04
	bra .hit		; $80A227: 80 0C
.v1:
	bvs .hit		; $80A229: 70 0A
.low:		;low puck: only a hit dead center counts
	lda.b d0		; $80A22B: A5 53
	and.w #$000F		; $80A22D: 29 0F 00
	beq .hit		; $80A230: F0 03
	jmp.w .rtl		; $80A232: 4C D4 A2
.hit:
	jsl.l a2touchpuck		; $80A235: 22 C7 99 80
	lda.w seed		; $80A239: AD A1 04  puck body sound (one of 2)
	and.w #$0001		; $80A23C: 29 01 00
	clc		; $80A23F: 18
	adc.w #SFXpuckbody		; $80A240: 69 90 00
	pha		; $80A243: 48
	jsl.l sfx		; $80A244: 22 8B C2 80
	stz.w Zvel,x		; $80A248: 9E 1F 0B  Zvel = 0, nopuck(a2) = 8
	ldy.b a2		; $80A24B: A4 3B
	lda.w #$0008		; $80A24D: A9 08 00
	sta.w nopuck,y		; $80A250: 99 5F 0E
	lda.w Xpos,x		; $80A253: BD FF 08
	sec		; $80A256: 38
	sbc.w Xpos,y		; $80A257: F9 FF 08
	sta.b d0		; $80A25A: 85 53
	lda.w Ypos,x		; $80A25C: BD 5F 09
	sec		; $80A25F: 38
	sbc.w Ypos,y		; $80A260: F9 5F 09
	sta.b d1		; $80A263: 85 57
	bne .vel		; $80A265: D0 05  centered: use the hot spot
	tya		; $80A267: 98
	jsl.l GetHot		; $80A268: 22 0A 9B 80
.vel:
	lda.w Xvel,x		; $80A26C: BD DF 0A
	sta.b d2		; $80A26F: 85 5B
	lda.w Yvel,x		; $80A271: BD FF 0A
	sta.b d3		; $80A274: 85 5F
	sep #$20		; $80A276: E2 20  puck velocity high bytes = offset (93G move.b)
	lda.b d0		; $80A278: A5 53
	sta.w Xvel+1,x		; $80A27A: 9D E0 0A
	lda.b d1		; $80A27D: A5 57
	sta.w Yvel+1,x		; $80A27F: 9D 00 0B
	rep #$30		; $80A282: C2 30
	jsl.l puckflip		; $80A284: 22 C9 CE 80  puckflip
	lda.w Zpos,x		; $80A288: BD 9F 09
	sec		; $80A28B: 38
	sbc.w #$0008		; $80A28C: E9 08 00
	beq .rtl		; $80A28F: F0 43
	bmi .v2		; $80A291: 30 04
	bvc .high		; $80A293: 50 04
	bra .rtl		; $80A295: 80 3D
.v2:
	bvc .rtl		; $80A297: 50 3B
.high:		;old speed^2 > $3000^2 and puck above 12: FallDown
	lda.b d2		; $80A299: A5 5B
	sta.b mula		; $80A29B: 85 7D
	sta.b mulb		; $80A29D: 85 83
	jsl.l $82FCDB		; $80A29F: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d2		; $80A2A3: 85 5B
	lda.b mulres+2		; $80A2A5: A5 95
	sta.b d2+2		; $80A2A7: 85 5D
	lda.b d3		; $80A2A9: A5 5F
	sta.b mula		; $80A2AB: 85 7D
	sta.b mulb		; $80A2AD: 85 83
	jsl.l $82FCDB		; $80A2AF: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d2		; $80A2B3: 65 5B
	sta.b d2		; $80A2B5: 85 5B
	lda.b mulres+2		; $80A2B7: A5 95
	adc.b d2+2		; $80A2B9: 65 5D
	sta.b d2+2		; $80A2BB: 85 5D
	cmp.w #$0900		; $80A2BD: C9 00 09  $3000^2
	bcc .slow		; $80A2C0: 90 13
	lda.w Zpos,x		; $80A2C2: BD 9F 09
	sec		; $80A2C5: 38
	sbc.w #$000C		; $80A2C6: E9 0C 00  Zpos 12
	beq .rtl		; $80A2C9: F0 09
	bmi .v3		; $80A2CB: 30 05
	bvs .rtl		; $80A2CD: 70 05
.fall:
	jmp.w FallDown		; $80A2CF: 4C 33 D9  FallDown
.v3:
	bvs .fall		; $80A2D2: 70 FB
.rtl:
	rtl		; $80A2D4: 6B
.slow:
	ldy.b a2		; $80A2D5: A4 3B
	lda.w pfalock,y		; $80A2D7: B9 7F 11  pfalock: already in a locked animation
	bne .rtl		; $80A2DA: D0 F8
	inc a		; $80A2DC: 1A
	sta.w pfalock,y		; $80A2DD: 99 7F 11
	lda.w #SPAslowhit		; $80A2E0: A9 18 14
	sta.b d1		; $80A2E3: 85 57
	ldx.b a2		; $80A2E5: A6 3B  exg a2,a3 around SetSPA
	ldy.b a3		; $80A2E7: A4 3F
	stx.b a3		; $80A2E9: 86 3F
	sty.b a2		; $80A2EB: 84 3B
	jsl.l SetSPA		; $80A2ED: 22 06 B0 80
	ldx.b a2		; $80A2F1: A6 3B
	ldy.b a3		; $80A2F3: A4 3F
	stx.b a3		; $80A2F5: 86 3F
	sty.b a2		; $80A2F7: 84 3B
	rtl		; $80A2F9: 6B
puckgoalie:		;auto: CODE_80A2FA. 93G puckgoalie (hockey93_05): puck (X) hits goalie a2. d0/d1 = goalie - puck x/y. SNES: save odds from the four save ratings, no .list2 frame table
	lda.w gmode		; $80A2FA: AD 88 12
	bit.w #gmhl		; $80A2FD: 89 10 00  gmhl
	beq .go		; $80A300: F0 03
	jmp.w .rtl		; $80A302: 4C B3 A4
.go:
	stz.b d2		; $80A305: 64 5B
	lda.w Zpos+puckobj		; $80A307: AD BB 09
	sec		; $80A30A: 38
	sbc.w #$0008		; $80A30B: E9 08 00
	beq .low		; $80A30E: F0 08
	bmi .v1		; $80A310: 30 04
	bvs .low		; $80A312: 70 04
	bra .side		; $80A314: 80 06
.v1:
	bvs .side		; $80A316: 70 04
.low:		;puck region: +2 when low
	inc.b d2		; $80A318: E6 5B
	inc.b d2		; $80A31A: E6 5B
.side:
	lda.b d0		; $80A31C: A5 53  direction from the goalie to the puck, relative to facedir
	eor.w #$FFFF		; $80A31E: 49 FF FF
	inc a		; $80A321: 1A
	sta.b d0		; $80A322: 85 53
	lda.b d1		; $80A324: A5 57
	eor.w #$FFFF		; $80A326: 49 FF FF
	inc a		; $80A329: 1A
	sta.b d1		; $80A32A: 85 57
	jsl.l vtoa		; $80A32C: 22 A8 AF 80
	ldy.b a2		; $80A330: A4 3B
	lda.b d0		; $80A332: A5 53
	sec		; $80A334: 38
	sbc.w facedir,y		; $80A335: F9 BF 0D
	and.w #$0007		; $80A338: 29 07 00
	sta.b d0		; $80A33B: 85 53
	and.w #$0003		; $80A33D: 29 03 00
	sta.b d1		; $80A340: 85 57
	bne .lr		; $80A342: D0 05
	lda.w seed		; $80A344: AD A1 04  straight in front or behind: random side
	sta.b d0		; $80A347: 85 53
.lr:
	lda.b d0		; $80A349: A5 53
	and.w #$0004		; $80A34B: 29 04 00
	lsr a		; $80A34E: 4A
	lsr a		; $80A34F: 4A
	eor.w #$0001		; $80A350: 49 01 00
	clc		; $80A353: 18
	adc.b d2		; $80A354: 65 5B
	asl a		; $80A356: 0A
	sta.b d2		; $80A357: 85 5B
	lda.w GGSleft,y		; $80A359: B9 BF 10  save rating for the region: GGSleft, passacc, spodds, endurance
	sta.b d1		; $80A35C: 85 57
	lda.b d2		; $80A35E: A5 5B
	beq .odds		; $80A360: F0 1D
	lda.w passacc,y		; $80A362: B9 1F 10
	sta.b d1		; $80A365: 85 57
	lda.b d2		; $80A367: A5 5B
	cmp.w #$0002		; $80A369: C9 02 00
	beq .odds		; $80A36C: F0 11
	lda.w spodds,y		; $80A36E: B9 5F 10
	sta.b d1		; $80A371: 85 57
	lda.b d2		; $80A373: A5 5B
	cmp.w #$0004		; $80A375: C9 04 00
	beq .odds		; $80A378: F0 05
	lda.w endurance,y		; $80A37A: B9 9F 10
	sta.b d1		; $80A37D: 85 57
.odds:		;d1 = save rating + 15
	lda.b d1		; $80A37F: A5 57
	clc		; $80A381: 18
	adc.w #$000F		; $80A382: 69 0F 00
	sta.b d1		; $80A385: 85 57
	lda.w attribute,y		; $80A387: B9 DF 09
	bit.w #$0800		; $80A38A: 89 00 08  x flip
	beq .noflip		; $80A38D: F0 07
	lda.b d2		; $80A38F: A5 5B
	eor.w #$0002		; $80A391: 49 02 00
	sta.b d2		; $80A394: 85 5B
.noflip:
	lda.w puckvy		; $80A396: AD 1B 0B
	bit.w #$8000		; $80A399: 89 00 80
	beq .hard		; $80A39C: F0 04
	eor.w #$FFFF		; $80A39E: 49 FF FF
	inc a		; $80A3A1: 1A
.hard:		;hard shot from the blue line area may slip through
	cmp.w #$3000		; $80A3A2: C9 00 30  |puckvy| >= $3000
	bcc .frame		; $80A3A5: 90 2A
	lda.w carriedy		; $80A3A7: AD 81 01  shot taken 80..169 from the goal line: 1 in (182-y) slips through
	bit.w #$8000		; $80A3AA: 89 00 80
	beq .dist		; $80A3AD: F0 04
	eor.w #$FFFF		; $80A3AF: 49 FF FF
	inc a		; $80A3B2: 1A
.dist:
	cmp.w #$0050		; $80A3B3: C9 50 00
	bcc .frame		; $80A3B6: 90 19
	cmp.w #$00AA		; $80A3B8: C9 AA 00
	bcs .frame		; $80A3BB: B0 14
	eor.w #$FFFF		; $80A3BD: 49 FF FF
	inc a		; $80A3C0: 1A
	clc		; $80A3C1: 18
	adc.w #$00B6		; $80A3C2: 69 B6 00
	jsl.l randoma		; $80A3C5: 22 8B AE 80
	cmp.w #$0003		; $80A3C9: C9 03 00
	bne .frame		; $80A3CC: D0 03
	jmp.w .rtl		; $80A3CE: 4C B3 A4
.frame:		;goalie in the down frames and the puck on the ice: no save
	lda.w frame,y		; $80A3D1: B9 3F 09
	sec		; $80A3D4: 38
	sbc.w #SPFgoalie		; $80A3D5: E9 83 02  goalie frames SPFgoalie..+15
	cmp.w #$0010		; $80A3D8: C9 10 00
	bcs .save		; $80A3DB: B0 10
	lda.w Zpos+puckobj		; $80A3DD: AD BB 09
	sec		; $80A3E0: 38
	sbc.w #$0002		; $80A3E1: E9 02 00
	bmi .v2		; $80A3E4: 30 05
	bvs .save		; $80A3E6: 70 05
.nosave:
	jmp.w .rtl		; $80A3E8: 4C B3 A4
.v2:
	bvs .nosave		; $80A3EB: 70 FB
.save:
	jsl.l ChkShotStat		; $80A3ED: 22 2E D1 80  ChkShotStat
	jsl.l a2touchpuck		; $80A3F1: 22 C7 99 80
	lda.w seed+1		; $80A3F5: AD A2 04  puck body sound (one of 2)
	and.w #$0001		; $80A3F8: 29 01 00
	clc		; $80A3FB: 18
	adc.w #SFXpuckbody		; $80A3FC: 69 90 00
	pha		; $80A3FF: 48
	jsl.l sfx		; $80A400: 22 8B C2 80
	lda.w puckvy		; $80A404: AD 1B 0B
	bit.w #$8000		; $80A407: 89 00 80
	beq .vy		; $80A40A: F0 04
	eor.w #$FFFF		; $80A40C: 49 FF FF
	inc a		; $80A40F: 1A
.vy:
	cmp.w #$3000		; $80A410: C9 00 30
	bcc .nosong		; $80A413: 90 14
	lda.w #SFXsavehome		; $80A415: A9 8A 00  crowd: home save
	pha		; $80A418: 48
	ldy.b a2		; $80A419: A4 3B
	lda.w pfteam,y		; $80A41B: B9 9F 11
	beq .song		; $80A41E: F0 05
	lda.w #SFXsaveaway		; $80A420: A9 8C 00
	sta.b $01,s		; $80A423: 83 01
.song:
	jsl.l sfx		; $80A425: 22 8B C2 80
.nosong:
	lda.w puckc		; $80A429: AD BB 0E
	sta.b d2		; $80A42C: 85 5B
	bpl .carried		; $80A42E: 10 03
	jmp.w .nopc		; $80A430: 4C B4 A4
.carried:		;carrier loses the puck
	lda.w #$FF00		; $80A433: A9 00 FF  puckc high byte = $FF: loose
	tsb.w puckc		; $80A436: 0C BB 0E
	asl.b d2		; $80A439: 06 5B
	lda.b d2		; $80A43B: A5 5B
	sta.b a0		; $80A43D: 85 33
	tay		; $80A43F: A8
	lda.w #$0014		; $80A440: A9 14 00  old carrier nopuck = 20
	sta.w nopuck,y		; $80A443: 99 5F 0E
	tya		; $80A446: 98
	lsr a		; $80A447: 4A
	sta.w lastplayer		; $80A448: 8D 7D 01
	lda.w #sfspdir|sfssdir		; $80A44B: A9 0C 00  clear sfspdir/sfssdir
	trb.w sflags		; $80A44E: 1C 8C 12
.bounce:
	stz.w Zvel,x		; $80A451: 9E 1F 0B  Zvel = 0, nopuck(a2) = 10, temp4(a2) = 4
	ldy.b a2		; $80A454: A4 3B
	lda.w #$000A		; $80A456: A9 0A 00
	sta.w nopuck,y		; $80A459: 99 5F 0E
	lda.w #$0004		; $80A45C: A9 04 00
	sta.w temp4,y		; $80A45F: 99 BF 0C
	lda.w Xpos,x		; $80A462: BD FF 08
	sec		; $80A465: 38
	sbc.w Xpos,y		; $80A466: F9 FF 08
	sta.b d0		; $80A469: 85 53
	lda.w Ypos,x		; $80A46B: BD 5F 09
	sec		; $80A46E: 38
	sbc.w Ypos,y		; $80A46F: F9 5F 09
	sta.b d1		; $80A472: 85 57
	bne .sx		; $80A474: D0 06
	lda.b a2		; $80A476: A5 3B
	jsl.l GetHot		; $80A478: 22 0A 9B 80
.sx:
	lda.b d1		; $80A47C: A5 57
	and.w #$00FF		; $80A47E: 29 FF 00
	bit.w #$0080		; $80A481: 89 80 00
	beq .sy		; $80A484: F0 03
	ora.w #$FF00		; $80A486: 09 00 FF
.sy:
	sta.b d1		; $80A489: 85 57
	lda.b d1		; $80A48B: A5 57
	beq .away		; $80A48D: F0 02
	inc.b d1		; $80A48F: E6 57
.away:
	ldy.b a2		; $80A491: A4 3B
	lda.w Yvel,y		; $80A493: B9 FF 0A
	eor.b d1		; $80A496: 45 57
	bmi .setv		; $80A498: 30 08
	lda.b d1		; $80A49A: A5 57
	eor.w #$FFFF		; $80A49C: 49 FF FF
	inc a		; $80A49F: 1A
	sta.b d1		; $80A4A0: 85 57
.setv:
	sep #$20		; $80A4A2: E2 20
	lda.b d0		; $80A4A4: A5 53
	sta.w Xvel+1,x		; $80A4A6: 9D E0 0A
	lda.b d1		; $80A4A9: A5 57
	sta.w Yvel+1,x		; $80A4AB: 9D 00 0B
	rep #$20		; $80A4AE: C2 20
	jmp.w puckflip		; $80A4B0: 4C C9 CE
.rtl:
	rtl		; $80A4B3: 6B
.nopc:		;loose puck: the goalie holds it if it is slow enough
	ldy.b a2		; $80A4B4: A4 3B
	lda.w SPA,y		; $80A4B6: B9 FF 0D
	cmp.w #SPAg314		; $80A4B9: C9 90 14  SPAg314: always bounce
	beq .bounce		; $80A4BC: F0 93
	lda.w #$0002		; $80A4BE: A9 02 00  catch speed limit = random((2+shotspd)*512) + $C00
	clc		; $80A4C1: 18
	adc.w shotspd,y		; $80A4C2: 79 DF 0F
	xba		; $80A4C5: EB
	and.w #$FF00		; $80A4C6: 29 00 FF
	asl a		; $80A4C9: 0A
	jsl.l randoma		; $80A4CA: 22 8B AE 80
	adc.w #$0C00		; $80A4CE: 69 00 0C
	sta.b d0		; $80A4D1: 85 53
	sec		; $80A4D3: 38
	sbc.w puckvx		; $80A4D4: ED FB 0A
	bmi .v3		; $80A4D7: 30 05
	bvc .c2		; $80A4D9: 50 05
.b1:
	jmp.w .bounce		; $80A4DB: 4C 51 A4
.v3:
	bvc .b1		; $80A4DE: 50 FB
.c2:
	lda.b d0		; $80A4E0: A5 53
	sec		; $80A4E2: 38
	sbc.w puckvy		; $80A4E3: ED 1B 0B
	bmi .v4		; $80A4E6: 30 05
	bvc .c3		; $80A4E8: 50 05
.b2:
	jmp.w .bounce		; $80A4EA: 4C 51 A4
.v4:
	bvc .b2		; $80A4ED: 50 FB
.c3:
	lda.b d0		; $80A4EF: A5 53
	eor.w #$FFFF		; $80A4F1: 49 FF FF
	inc a		; $80A4F4: 1A
	sta.b d0		; $80A4F5: 85 53
	sec		; $80A4F7: 38
	sbc.w puckvx		; $80A4F8: ED FB 0A
	beq .c4		; $80A4FB: F0 09
	bmi .v5		; $80A4FD: 30 05
	bvs .c4		; $80A4FF: 70 05
.b3:
	jmp.w .bounce		; $80A501: 4C 51 A4
.v5:
	bvs .b3		; $80A504: 70 FB
.c4:
	lda.b d0		; $80A506: A5 53
	sec		; $80A508: 38
	sbc.w puckvy		; $80A509: ED 1B 0B
	beq .c5		; $80A50C: F0 09
	bmi .v6		; $80A50E: 30 05
	bvs .c5		; $80A510: 70 05
.b4:
	jmp.w .bounce		; $80A512: 4C 51 A4
.v6:
	bvs .b4		; $80A515: 70 FB
.c5:
	ldy.b a2		; $80A517: A4 3B
	lda.w pflags,y		; $80A519: B9 DF 0E
	bit.w #pf2unav		; $80A51C: 89 00 10  pf2unav
	beq .hold		; $80A51F: F0 03
	jmp.w .bounce		; $80A521: 4C 51 A4
.hold:
	stz.w Zvel,x		; $80A524: 9E 1F 0B
	jmp.w puckglue		; $80A527: 4C 7D A0  puckglue: goalie holds the puck
pucknothing:		;auto: asstab $1A. 93G pucknothing / puckunflip (logic93_4 / logic93_5): puck just slides; stop spinning (93G pucknothing is bra puckunflip)
	lda.w SPAnum+puckobj		; $80A52A: AD 3B 0E
	cmp.w #$0008		; $80A52D: C9 08 00  SPAnum 2*4..6*4: flip the face
	bcc .k		; $80A530: 90 0E
	cmp.w #$0018		; $80A532: C9 18 00
	bcs .k		; $80A535: B0 09
	lda.w facedir+puckobj		; $80A537: AD DB 0D
	eor.w #$0002		; $80A53A: 49 02 00
	sta.w facedir+puckobj		; $80A53D: 8D DB 0D
.k:
	lda.w #$0004		; $80A540: A9 04 00  facedir |= 4
	tsb.w facedir+puckobj		; $80A543: 0C DB 0D
	stz.w SPAnum+puckobj		; $80A546: 9C 3B 0E  SPAnum = 0, SPAcnt = -1 (restart)
	lda.w #$FFFF		; $80A549: A9 FF FF
	sta.w SPAcnt+puckobj		; $80A54C: 8D 5B 0E
	rtl		; $80A54F: 6B
puckfaceoff:		;auto: asstab $1B. 93G puckfaceoff (logic93_4): this is where the action starts: period end checks, goalies, line change boxes, then pfaceoff2
	lda.w pflags,x		; $80A550: BD DF 0E
	bit.w #pfna		; $80A553: 89 02 00
	bne .first		; $80A556: D0 03
	jmp.w .nna		; $80A558: 4C 6F A6
.first:
	and.w #~pfna&$FFFF		; $80A55B: 29 FD FF
	sta.w pflags,x		; $80A55E: 9D DF 0E
	lda.w gameclock		; $80A561: AD F2 12  clock out: PeriodOver
	bne .g6		; $80A564: D0 04
	jml.l $8D85A9		; $80A566: 5C A9 85 8D  bank $8D: 93G PeriodOver
.g6:
	lda.w gmode		; $80A56A: AD 88 12
	bit.w #gmendper		; $80A56D: 89 40 00
	beq .ot		; $80A570: F0 04
	jml.l $8D85A9		; $80A572: 5C A9 85 8D  bank $8D: 93G PeriodOver
.ot:
	lda.w gsp		; $80A576: AD F0 12  overtime and not tied: clockcont_0
	cmp.w #$0003		; $80A579: C9 03 00
	bne .npo		; $80A57C: D0 0C
	lda.w tmscore		; $80A57E: AD D6 13
	cmp.w tmscore+2		; $80A581: CD D8 13
	beq .npo		; $80A584: F0 04
	jml.l $8F8B21		; $80A586: 5C 21 8B 8F  bank $8F: 93G clockcont_0
.npo:
	lda.w gmode		; $80A58A: AD 88 12
	bit.w #gmpendel		; $80A58D: 89 08 00  gmpendel: Stop4Pen
	beq .rg		; $80A590: F0 03
	jmp.w $E7F7		; $80A592: 4C F7 E7  Stop4Pen
.rg:
	jsl.l ReturnGoalies		; $80A595: 22 47 BE 80  ReturnGoalies
	lda.w #$FFFF		; $80A599: A9 FF FF  temp1/temp2 = -1: no lc box timers
	sta.w temp1,x		; $80A59C: 9D 5F 0C
	sta.w temp2,x		; $80A59F: 9D 7F 0C
	lda.w OptLine		; $80A5A2: AD 0C 16  line changes off
	beq .lines		; $80A5A5: F0 03
	jmp.w .nna		; $80A5A7: 4C 6F A6
.lines:		;line changes on: no team in lc mode, clear pf2lcm on all 12 players
	lda.w #tmflc		; $80A5AA: A9 08 00
	trb.w tmflags		; $80A5AD: 1C 0A 14
	trb.w tmflags+2		; $80A5B0: 1C 0C 14
	ldy.w #$0016		; $80A5B3: A0 16 00
.lcm:
	lda.w pflags,y		; $80A5B6: B9 DF 0E
	and.w #~pf2lcm&$FFFF		; $80A5B9: 29 FF DF
	sta.w pflags,y		; $80A5BC: 99 DF 0E
	dey		; $80A5BF: 88
	dey		; $80A5C0: 88
	bpl .lcm		; $80A5C1: 10 F3
	lda.w cont1team		; $80A5C3: AD 96 12  a controlled team in horizontal mode: back to vertical
	ora.w cont2team		; $80A5C6: 0D 98 12
	beq .nohor		; $80A5C9: F0 0F
	lda.w sfhormode		; $80A5CB: AD 8E 12
	beq .nohor		; $80A5CE: F0 0A
	lda.w #sfslock		; $80A5D0: A9 40 00
	tsb.w sflags		; $80A5D3: 0C 8C 12
	jsl.l ClrHor		; $80A5D6: 22 28 A8 80
.nohor:
	lda.w c1playernum		; $80A5DA: AD 92 12  controller players get the lc box
	sta.b d0		; $80A5DD: 85 53
	bmi .nlp		; $80A5DF: 30 04
	jsl.l .slc		; $80A5E1: 22 1C A6 80
.nlp:
	lda.w c2playernum		; $80A5E5: AD 94 12
	sta.b d0		; $80A5E8: 85 53
	bmi .nlp2		; $80A5EA: 30 04
	jsl.l .slc		; $80A5EC: 22 1C A6 80
.nlp2:
	stz.b a1		; $80A5F0: 64 37  a1 = home, a2 = away
	lda.w #$0002		; $80A5F2: A9 02 00
	sta.b a2		; $80A5F5: 85 3B
	sta.b d0		; $80A5F7: 85 53
	jsl.l .sclc		; $80A5F9: 22 FF A5 80
	bra .nna		; $80A5FD: 80 70
.sclc:		;d0 = team (1/2), a2/a1 = team/other: computer line change unless that team is on a controller
	lda.w OptLine		; $80A5FF: AD 0C 16
	bne .rtl		; $80A602: D0 6A
	lda.b d0		; $80A604: A5 53
	cmp.w cont1team		; $80A606: CD 96 12
	beq .rtl		; $80A609: F0 63
	cmp.w cont2team		; $80A60B: CD 98 12
	beq .rtl		; $80A60E: F0 5E
	jsl.l $8FE6BD		; $80A610: 22 BD E6 8F  bank $8F: 93G CompLine
	jsl.l setpersonel		; $80A614: 22 5A BB 80
	jml.l $89E95D		; $80A618: 5C 5D E9 89  bank $89: 93G printscores1
.slc:		;controlled player d0 gets the line change box
	ldy.b a3		; $80A61C: A4 3F
	sty.b a2		; $80A61E: 84 3B
	lda.b d0		; $80A620: A5 53
	asl a		; $80A622: 0A  exg a2,a3: X = the controlled player
	sta.b d0		; $80A623: 85 53
	sta.b a3		; $80A625: 85 3F
	tax		; $80A627: AA
	lda.w pflags,x		; $80A628: BD DF 0E
	and.w #~pf2lcm&$FFFF		; $80A62B: 29 FF DF
	sta.w pflags,x		; $80A62E: 9D DF 0E
	phy		; $80A631: 5A
	lda.w #$FFFF		; $80A632: A9 FF FF  lcplayer = -1
	sta.w lcplayer		; $80A635: 8D 83 01
	jsl.l SetLCmode		; $80A638: 22 0F A7 80
	ply		; $80A63C: 7A
	sty.b a2		; $80A63D: 84 3B
	ldx.b a3		; $80A63F: A6 3F
	lda.w pflags,x		; $80A641: BD DF 0E
	bit.w #pf2lcm		; $80A644: 89 00 20  pf2lcm: the box opened
	beq .slcex		; $80A647: F0 1D
	lda.w pfteam,x		; $80A649: BD 9F 11
	beq .t1		; $80A64C: F0 0D
	lda.w #$0168		; $80A64E: A9 68 01  visitors: temp2 = 6*60, temp4 = SCnum
	sta.w temp2,y		; $80A651: 99 7F 0C
	txa		; $80A654: 8A
	lsr a		; $80A655: 4A
	sta.w temp4,y		; $80A656: 99 BF 0C
	bra .slcex		; $80A659: 80 0B
.t1:
	lda.w #$0258		; $80A65B: A9 58 02  home: temp1 = 10*60, temp3 = SCnum
	sta.w temp1,y		; $80A65E: 99 5F 0C
	txa		; $80A661: 8A
	lsr a		; $80A662: 4A
	sta.w temp3,y		; $80A663: 99 9F 0C
.slcex:
	ldx.b a2		; $80A666: A6 3B
	ldy.b a3		; $80A668: A4 3F
	stx.b a3		; $80A66A: 86 3F
	sty.b a2		; $80A66C: 84 3B
.rtl:
	rtl		; $80A66E: 6B
.nna:		;count down the two lc box timers (temp1/temp2); both done: pfaceoff2
	stz.b d0		; $80A66F: 64 53
	jsl.l .clc		; $80A671: 22 A2 A6 80
	lda.w #$0020		; $80A675: A9 20 00  temp2/temp4
	sta.b d0		; $80A678: 85 53
	jsl.l .clc		; $80A67A: 22 A2 A6 80
	ldx.b a3		; $80A67E: A6 3F
	lda.w temp1,x		; $80A680: BD 5F 0C
	bpl .rtl		; $80A683: 10 E9
	lda.w temp2,x		; $80A685: BD 7F 0C
	bpl .rtl		; $80A688: 10 E4
	stz.b a2		; $80A68A: 64 3B  a2 = home, a1 = away
	lda.w #$0001		; $80A68C: A9 01 00
	sta.b d0		; $80A68F: 85 53
	inc a		; $80A691: 1A
	sta.b a1		; $80A692: 85 37
	jsl.l .sclc		; $80A694: 22 FF A5 80
	lda.w #pfaceoff2		; $80A698: A9 1C 00  pfaceoff2
	sta.b d0		; $80A69B: 85 53
	ldx.b a3		; $80A69D: A6 3F
	jmp.w assreplace		; $80A69F: 4C A7 B4
.clc:		;d0 = 0 (temp1/temp3) or $20 (temp2/temp4): update one lc box timer
	lda.b a3		; $80A6A2: A5 3F
	clc		; $80A6A4: 18
	adc.b d0		; $80A6A5: 65 53
	tay		; $80A6A7: A8
	lda.w temp1,y		; $80A6A8: B9 5F 0C
	bmi .rtl		; $80A6AB: 30 C1
	lda.w temp3,y		; $80A6AD: B9 9F 0C  temp3/temp4 = SCnum of the box owner
	asl a		; $80A6B0: 0A
	sta.b d1		; $80A6B1: 85 57
	tay		; $80A6B3: A8
	stz.b a0		; $80A6B4: 64 33
	stz.b a2		; $80A6B6: 64 3B
	lda.w pfteam,y		; $80A6B8: B9 9F 11
	beq .clh		; $80A6BB: F0 05
	lda.w #$0002		; $80A6BD: A9 02 00
	sta.b a2		; $80A6C0: 85 3B
.clh:
	lda.w pflags,y		; $80A6C2: B9 DF 0E
	bit.w #pf2lcm		; $80A6C5: 89 00 20  pf2lcm still on?
	bne .clnd		; $80A6C8: D0 14
	lda.b a3		; $80A6CA: A5 3F
	clc		; $80A6CC: 18
	adc.b d0		; $80A6CD: 65 53
	tay		; $80A6CF: A8
	lda.w temp1,y		; $80A6D0: B9 5F 0C
	ora.w #$FF00		; $80A6D3: 09 00 FF  timer negative: box closed
	sta.w temp1,y		; $80A6D6: 99 5F 0C
	ldx.b a3		; $80A6D9: A6 3F
	jmp.w SetLCmode2		; $80A6DB: 4C 48 A7
.clnd:
	lda.b a3		; $80A6DE: A5 3F
	clc		; $80A6E0: 18
	adc.b d0		; $80A6E1: 65 53
	tay		; $80A6E3: A8
	lda.w temp1,y		; $80A6E4: B9 5F 0C
	sec		; $80A6E7: 38
	sbc.b d7		; $80A6E8: E5 6F  count down
	sta.w temp1,y		; $80A6EA: 99 5F 0C
	bmi .clcex		; $80A6ED: 30 03
	jmp.w .rtl		; $80A6EF: 4C 6E A6
.clcex:
	ldx.b a3		; $80A6F2: A6 3F
	phx		; $80A6F4: DA
	ldx.b d1		; $80A6F5: A6 57
	stx.b a3		; $80A6F7: 86 3F
	lda.w pflags,x		; $80A6F9: BD DF 0E
	bit.w #pf2lcm		; $80A6FC: 89 00 20  still in lc mode: lcfound with choice 0
	beq .pop		; $80A6FF: F0 0A
	stz.b d2		; $80A701: 64 5B
	jsl.l $8F8DC7		; $80A703: 22 C7 8D 8F  bank $8F: 93G lcfound
	jsl.l SetLCmode2		; $80A707: 22 48 A7 80
.pop:
	plx		; $80A70B: FA
	stx.b a3		; $80A70C: 86 3F
	rtl		; $80A70E: 6B
SetLCmode:		;auto: CODE_80A70F. 93G SetLCmode (logic93_1): open the line change box for player X (abut of the puck carrier)
	lda.w OptLine		; $80A70F: AD 0C 16
	bne .rtl		; $80A712: D0 33
	jsl.l $8FDBF9		; $80A714: 22 F9 DB 8F  loadTeamStruct: a2 = team of X, bank $8F: 93G loadTeamStruct
	ldy.b a2		; $80A718: A4 3B
	lda.w tmflags,y		; $80A71A: B9 0A 14
	bit.w #tmflc		; $80A71D: 89 08 00  tmflc: team already in lc mode
	bne .rtl		; $80A720: D0 25
	ora.w #tmflc		; $80A722: 09 08 00
	sta.w tmflags,y		; $80A725: 99 0A 14
	lda.w #sfspdir|sfssdir		; $80A728: A9 0C 00  clear sfspdir/sfssdir
	trb.w sflags		; $80A72B: 1C 8C 12
	lda.w pflags,x		; $80A72E: BD DF 0E
	ora.w #pf2lcm		; $80A731: 09 00 20  pf2lcm
	sta.w pflags,x		; $80A734: 9D DF 0E
	lda.w lcplayer		; $80A737: AD 83 01  remember the player when lcplayer = $FFFE
	cmp.w #$FFFE		; $80A73A: C9 FE FF
	bne .show		; $80A73D: D0 05
	txa		; $80A73F: 8A
	lsr a		; $80A740: 4A
	sta.w lcplayer		; $80A741: 8D 83 01
.show:
	jmp.w SetLCmode2		; $80A744: 4C 48 A7
.rtl:
	rtl		; $80A747: 6B
SetLCmode2:		;auto: CODE_80A748. 93G SetLCmode2 (logic93_1 IDA showfaceoff): a2 = team; draw the lc box, one row per eligible line (button letter + line name)
	jsl.l $80F391		; $80A748: 22 91 F3 80  setlccords
	inc.b d0		; $80A74C: E6 53  box size +1
	inc.b d1		; $80A74E: E6 57
	lda.w blankchar		; $80A750: AD E7 1B  d2 = blank tile
	sta.b d2		; $80A753: 85 5B
	lda.b fobox		; $80A755: A5 F4  faceoff box up: do not clear
	bne .cords		; $80A757: D0 04
	jsl.l $8D847C		; $80A759: 22 7C 84 8D  bank $8D: 93G eraser (d0/d1 size, d2 tile)
.cords:
	jsl.l $80F391		; $80A75D: 22 91 F3 80  setlccords
	lda.w printy		; $80A761: AD 7D 04  lower half of the screen?
	sec		; $80A764: 38
	sbc.w #$000F		; $80A765: E9 0F 00
	bmi .v1		; $80A768: 30 04
	bvc .lower		; $80A76A: 50 04
	bra .box		; $80A76C: 80 0A
.v1:
	bvc .box		; $80A76E: 50 08
.lower:		;lower box: sf3llcs
	lda.w #sf3llcs		; $80A770: A9 01 00
	tsb.w sflags3		; $80A773: 0C 90 12
	bra .frame		; $80A776: 80 08
.box:
	jsl.l $8FDBDB		; $80A778: 22 DB DB 8F  bank $8F: 93G box
	jsl.l $80F391		; $80A77C: 22 91 F3 80  setlccords
.frame:
	jsl.l $8FD69F		; $80A780: 22 9F D6 8F  bank $8F: 93G Framer (d0/d1 size)
	dec.w printy		; $80A784: CE 7D 04  printy -= 2, printx += 1
	dec.w printy		; $80A787: CE 7D 04
	inc.w printx		; $80A78A: EE 7B 04
	lda.w #$0002		; $80A78D: A9 02 00
	sta.b d4		; $80A790: 85 63
	lda.w printx		; $80A792: AD 7B 04
	pha		; $80A795: 48
.loop:		;rows 2..0: button letter, line name, energy bar
	lda.b $01,s		; $80A796: A3 01
	sta.w printx		; $80A798: 8D 7B 04
	lda.b d4		; $80A79B: A5 63
	sta.b d0		; $80A79D: 85 53
	jsl.l $8AFD6D		; $80A79F: 22 6D FD 8A  bank $8A: 93G getlchoice
	lda.b d0		; $80A7A3: A5 53
	bmi .next		; $80A7A5: 30 57
	ldy.b a2		; $80A7A7: A4 3B
	lda.w tmflags,y		; $80A7A9: B9 0A 14
	bit.w #tmflc		; $80A7AC: 89 08 00  tmflc: show every row
	bne .pr		; $80A7AF: D0 0C
	lda.b d4		; $80A7B1: A5 63
	cmp.w tmlcchoice,y		; $80A7B3: D9 0E 14  box being closed: only the chosen row
	bne .up		; $80A7B6: D0 43
	lda.w tmline,y		; $80A7B8: B9 DE 13
	sta.b d0		; $80A7BB: 85 53
.pr:
	lda.w #mesarea		; $80A7BD: A9 91 01  mesarea = 4, button letter
	sta.b a1		; $80A7C0: 85 37
	lda.w #mesarea>>16		; $80A7C2: A9 00 00
	sta.b a1+2		; $80A7C5: 85 39
	lda.w #$0004		; $80A7C7: A9 04 00
	sta.b [a1]		; $80A7CA: 87 37
	phx		; $80A7CC: DA
	ldx.b d4		; $80A7CD: A6 63
	lda.l .btn,x		; $80A7CF: BF 25 A8 80
	plx		; $80A7D3: FA
	and.w #$00FF		; $80A7D4: 29 FF 00
	ora.w #$2000		; $80A7D7: 09 00 20  text attribute $20
	ldy.w #$0002		; $80A7DA: A0 02 00
	sta.b [a1],y		; $80A7DD: 97 37
	jsl.l print		; $80A7DF: 22 2D B9 80
	lda.b d0		; $80A7E3: A5 53
	pha		; $80A7E5: 48
	lda.w #$8213		; $80A7E6: A9 13 82  linelist (bank $8F)
	sta.b a1		; $80A7E9: 85 37
	lda.w #$008F		; $80A7EB: A9 8F 00
	sta.b a1+2		; $80A7EE: 85 39
	jsl.l $8FD68C		; $80A7F0: 22 8C D6 8F  bank $8F: 93G PrintStringFromList
	pla		; $80A7F4: 68
	sta.b d0		; $80A7F5: 85 53
	jsl.l $8F8D68		; $80A7F7: 22 68 8D 8F  bank $8F: 93G linebar
.up:
	dec.w printy		; $80A7FB: CE 7D 04
.next:
	dec.b d4		; $80A7FE: C6 63
	bpl .loop		; $80A800: 10 94
	pla		; $80A802: 68
	clc		; $80A803: 18
	adc.w #$0005		; $80A804: 69 05 00
	sta.w printx		; $80A807: 8D 7B 04
	ldy.b a2		; $80A80A: A4 3B
	lda.w #$0083		; $80A80C: A9 83 00  team name: [tmdata] + its offsets (bank $83)
	sta.b a1+2		; $80A80F: 85 39
	lda.w tmdata,y		; $80A811: B9 CE 13
	sta.b a1		; $80A814: 85 37
	ldy.w #$0004		; $80A816: A0 04 00
	clc		; $80A819: 18
	adc.b [a1],y		; $80A81A: 77 37
	sta.b a1		; $80A81C: 85 37
	adc.b [a1]		; $80A81E: 67 37
	sta.b a1		; $80A820: 85 37
	jmp.w print		; $80A822: 4C 2D B9
.btn:		;SNES button letter for lc rows 0-2 (93G A/B/C)
	db "YBA"		; $80A825
ClrHor:		;auto: CODE_80A828. 93G ClrHor (penalty93_1): revert to the vertical ice rink: clear sfhormode, Oldrow, SprSort, clear the text map, printscores1
	stx.b xsave		; $80A828: 86 0A
	ldx.w #$0000		; $80A82A: A2 00 00
.push:
	lda.b a0,x		; $80A82D: B5 33
	pha		; $80A82F: 48
	inx		; $80A830: E8
	inx		; $80A831: E8
	cpx.w #$003C		; $80A832: E0 3C 00
	bne .push		; $80A835: D0 F6
	ldx.b xsave		; $80A837: A6 0A
	stz.w sfhormode		; $80A839: 9C 8E 12  vertical
	lda.w #999		; $80A83C: A9 E7 03  Oldrow = 999: redraw the rink rows
	sta.w Oldrow		; $80A83F: 8D 9B 04
	jsl.l SprSort		; $80A842: 22 6C B7 80
	lda.w sflags		; $80A846: AD 8C 12
	bit.w #sfpz		; $80A849: 89 01 00  paused: keep the text
	bne .pop		; $80A84C: D0 1D
	lda.w blankchar		; $80A84E: AD E7 1B  clear the text map
	clc		; $80A851: 18
	adc.w charofs		; $80A852: 6D CD 1B
	ldx.w #$07FE		; $80A855: A2 FE 07
.clr:
	sta.l textmap,x		; $80A858: 9F 74 6E 7E
	dex		; $80A85C: CA
	dex		; $80A85D: CA
	bpl .clr		; $80A85E: 10 F8
	stz.b textdirtylo		; $80A860: 64 D0  whole text map dirty
	lda.w #$03FF		; $80A862: A9 FF 03
	sta.b textdirtyhi		; $80A865: 85 D2
	jsl.l $89E95D		; $80A867: 22 5D E9 89  bank $89: 93G printscores1
.pop:
	stx.b xsave		; $80A86B: 86 0A
	ldx.w #$003A		; $80A86D: A2 3A 00
.popl:
	pla		; $80A870: 68
	sta.b a0,x		; $80A871: 95 33
	dex		; $80A873: CA
	dex		; $80A874: CA
	bpl .popl		; $80A875: 10 F9
	ldx.b xsave		; $80A877: A6 0A
	ldx.b a3		; $80A879: A6 3F
	rtl		; $80A87B: 6B
puckfaceoff2:		;auto: asstab $1C. 93G puckfaceoff2 (logic93_4): face off control logic and general setup for action
	lda.w pflags,x		; $80A87C: BD DF 0E
	bit.w #pfna		; $80A87F: 89 02 00
	bne .first		; $80A882: D0 03
	jmp.w .nna		; $80A884: 4C 6D AC
.first:		;first time: set up the faceoff
	and.w #~pfna&$FFFF		; $80A887: 29 FD FF
	sta.w pflags,x		; $80A88A: 9D DF 0E
	stx.b xsave		; $80A88D: 86 0A
	ldx.w #$0000		; $80A88F: A2 00 00
.pushd:
	lda.b d0,x		; $80A892: B5 53
	pha		; $80A894: 48
	inx		; $80A895: E8
	inx		; $80A896: E8
	cpx.w #$0020		; $80A897: E0 20 00
	bne .pushd		; $80A89A: D0 F6
	ldx.b xsave		; $80A89C: A6 0A
	stx.b xsave		; $80A89E: 86 0A
	ldx.w #$0000		; $80A8A0: A2 00 00
.pusha:
	lda.b a0,x		; $80A8A3: B5 33
	pha		; $80A8A5: 48
	inx		; $80A8A6: E8
	inx		; $80A8A7: E8
	cpx.w #$001C		; $80A8A8: E0 1C 00
	bne .pusha		; $80A8AB: D0 F6
	ldx.b xsave		; $80A8AD: A6 0A
	lda.b crowdlevel		; $80A8AF: A5 DE  limit crowd level
	cmp.w #$0258		; $80A8B1: C9 58 02
	bcc .ntm		; $80A8B4: 90 05
	lda.w #$0258		; $80A8B6: A9 58 02
	sta.b crowdlevel		; $80A8B9: 85 DE
.ntm:
	lda.w #sfpz		; $80A8BB: A9 01 00  no pause, no lower lc box, no gloves, no icing, no refs, no goalie moves, puck invisible and loose
	trb.w sflags		; $80A8BE: 1C 8C 12
	lda.w #sf3llcs		; $80A8C1: A9 01 00
	trb.w sflags3		; $80A8C4: 1C 90 12
	stz.w glovecords		; $80A8C7: 9C 4E 01
	stz.w iflags		; $80A8CA: 9C 5C 01
	lda.w #$FFFF		; $80A8CD: A9 FF FF
	sta.w RefCnt		; $80A8D0: 8D EA 12
	sta.w puckcross+2		; $80A8D3: 8D 8B 04
	sta.w puckcross+6		; $80A8D6: 8D 8F 04
	sta.w Zpos+puckobj		; $80A8D9: 8D BB 09
	sta.w puckc		; $80A8DC: 8D BB 0E
	sta.w passReceiverPlayerNum		; $80A8DF: 8D 3F 04
	lda.w #sf2refref		; $80A8E2: A9 00 02  clear sf2refref; faceoff on, replay record off
	trb.w sflags		; $80A8E5: 1C 8C 12
	lda.w #sf2faceoff|sf2drec		; $80A8E8: A9 00 05
	tsb.w sflags		; $80A8EB: 0C 8C 12
	jsl.l ClrHor		; $80A8EE: 22 28 A8 80
	stz.w Vpos		; $80A8F2: 9C DF 08  Vpos = Hpos = 0
	stz.w Hpos		; $80A8F5: 9C 54 01
	lda.w fox		; $80A8F8: AD 46 01  puck to the faceoff spot, stopped
	sta.w puckx		; $80A8FB: 8D 1B 09
	lda.w foy		; $80A8FE: AD 48 01
	sta.w pucky		; $80A901: 8D 7B 09
	stz.w puckvx		; $80A904: 9C FB 0A
	stz.w puckvy		; $80A907: 9C 1B 0B
	stz.w puckvz		; $80A90A: 9C 3B 0B
	stz.w Xvel+$18		; $80A90D: 9C F7 0A  goal nets (objects 12/13) at y +-268
	stz.w Yvel+$18		; $80A910: 9C 17 0B
	stz.w Xpos+$18		; $80A913: 9C 17 09
	lda.w #$010C		; $80A916: A9 0C 01
	sta.w Ypos+$18		; $80A919: 8D 77 09
	stz.w Xvel+$1A		; $80A91C: 9C F9 0A
	stz.w Yvel+$1A		; $80A91F: 9C 19 0B
	stz.w Xpos+$1A		; $80A922: 9C 19 09
	lda.w #$FEF4		; $80A925: A9 F4 FE
	sta.w Ypos+$1A		; $80A928: 8D 79 09
	lda.w #SPFpuck		; $80A92B: A9 89 01  object 15 (puck shadow) = SPFpuck
	sta.w frame+$1E		; $80A92E: 8D 5D 09
	stz.w SPA+$1E		; $80A931: 9C 1D 0E
	stz.w attribute+$1E		; $80A934: 9C FD 09
	stz.w attribute+puckobj		; $80A937: 9C FB 09
	lda.w #sfslock		; $80A93A: A9 40 00  clear sfslock: free up scrolling
	trb.w sflags		; $80A93D: 1C 8C 12
	lda.w #$0064		; $80A940: A9 64 00
	sta.b d4		; $80A943: 85 63
.cw:		;scroll to the faceoff spot
	jsl.l $80E1E8		; $80A945: 22 E8 E1 80  checkwindow
	dec.b d4		; $80A949: C6 63
	bpl .cw		; $80A94B: 10 F8
	lda.w #$003C		; $80A94D: A9 3C 00  yleader = 60
	sta.w yleader		; $80A950: 8D F9 08
	jsl.l ResetBench		; $80A953: 22 1A B0 80  ResetBench
	stz.b a2		; $80A957: 64 3B
	jsl.l setpersonel		; $80A959: 22 5A BB 80
	jsl.l forcepldata		; $80A95D: 22 86 B0 80
	inc.b a2		; $80A961: E6 3B
	inc.b a2		; $80A963: E6 3B
	jsl.l setpersonel		; $80A965: 22 5A BB 80
	jsl.l forcepldata		; $80A969: 22 86 B0 80
	jsl.l resetplstuff		; $80A96D: 22 F8 B3 80  resetplstuff
	lda.b a3+2		; $80A971: A5 41  push a3
	pha		; $80A973: 48
	lda.b a3		; $80A974: A5 3F
	pha		; $80A976: 48
	stz.b a3		; $80A977: 64 3F
	lda.w #$000B		; $80A979: A9 0B 00
	sta.b d2		; $80A97C: 85 5B
.l0:		;each player: assignment and faceoff position
	ldx.b a3		; $80A97E: A6 3F
	lda.w #$FF10		; $80A980: A9 10 FF  Xpos = -240, off the screen
	sta.w Xpos,x		; $80A983: 9D FF 08
	stz.w Ypos,x		; $80A986: 9E 5F 09
	stz.w frame,x		; $80A989: 9E 3F 09
	lda.w position,x		; $80A98C: BD 9F 0B
	sta.b d1		; $80A98F: 85 57
	bpl .pos		; $80A991: 10 03
	jmp.w .next		; $80A993: 4C D6 AA
.pos:
	beq .goalie1		; $80A996: F0 3D
	lda.w #afaceoff		; $80A998: A9 16 00
	sta.b d0		; $80A99B: 85 53
	lda.b d1		; $80A99D: A5 57
	cmp.w #$0004		; $80A99F: C9 04 00
	bne .l1		; $80A9A2: D0 2D
	stz.b a2		; $80A9A4: 64 3B  center: team touches = him only
	lda.w pfteam,x		; $80A9A6: BD 9F 11
	beq .tm		; $80A9A9: F0 04
	inc.b a2		; $80A9AB: E6 3B
	inc.b a2		; $80A9AD: E6 3B
.tm:
	ldy.b a2		; $80A9AF: A4 3B
	lda.w pnum,x		; $80A9B1: BD 1F 0F
	and.w #$00FF		; $80A9B4: 29 FF 00
	sta.w tmtouch1,y		; $80A9B7: 99 E2 13
	lda.w #$FFFF		; $80A9BA: A9 FF FF
	sta.w tmtouch2,y		; $80A9BD: 99 E6 13
	sta.w tmtouch3,y		; $80A9C0: 99 EA 13
	lda.w tmflags,y		; $80A9C3: B9 0A 14
	and.w #~tmflast&$FFFF		; $80A9C6: 29 FB FF
	sta.w tmflags,y		; $80A9C9: 99 0A 14
	lda.w #afaceoffpl		; $80A9CC: A9 17 00  afaceoffpl
	sta.b d0		; $80A9CF: 85 53
.l1:
	jsl.l assinsert		; $80A9D1: 22 9D B4 80
.goalie1:
	lda.w tmap		; $80A9D5: AD EE 13  d4 = (6-tmap)*8: .apl row
	sta.b d4		; $80A9D8: 85 63
	ldx.b a3		; $80A9DA: A6 3F
	lda.w pfteam,x		; $80A9DC: BD 9F 11
	beq .t0		; $80A9DF: F0 05
	lda.w tmap+2		; $80A9E1: AD F0 13
	sta.b d4		; $80A9E4: 85 63
.t0:
	lda.b d4		; $80A9E6: A5 63
	eor.w #$FFFF		; $80A9E8: 49 FF FF
	inc a		; $80A9EB: 1A
	clc		; $80A9EC: 18
	adc.w #$0006		; $80A9ED: 69 06 00
	asl a		; $80A9F0: 0A
	asl a		; $80A9F1: 0A
	asl a		; $80A9F2: 0A
	sta.b d4		; $80A9F3: 85 63
	lda.w #.apl>>16		; $80A9F5: A9 80 00
	sta.b a1+2		; $80A9F8: 85 39
	lda.w #.apl		; $80A9FA: A9 90 AC
	clc		; $80A9FD: 18
	adc.b d4		; $80A9FE: 65 63
	sta.b a1		; $80AA00: 85 37
	ldy.b d1		; $80AA02: A4 57
	lda.b [a1],y		; $80AA04: B7 37
	and.w #$00FF		; $80AA06: 29 FF 00
	asl a		; $80AA09: 0A
	asl a		; $80AA0A: 0A
	sta.b d4		; $80AA0B: 85 63
	lda.w #.ptab		; $80AA0D: A9 A8 AC
	sta.b a1		; $80AA10: 85 37
	lda.w #.ptab>>16		; $80AA12: A9 80 00
	sta.b a1+2		; $80AA15: 85 39
	ldy.b d4		; $80AA17: A4 63
	lda.b [a1],y		; $80AA19: B7 37
	sta.b d0		; $80AA1B: 85 53
	iny		; $80AA1D: C8
	iny		; $80AA1E: C8
	lda.b [a1],y		; $80AA1F: B7 37
	sta.b d1		; $80AA21: 85 57
	lda.w pfgoal,x		; $80AA23: BD 3F 11
	bne .f0		; $80AA26: D0 10
	lda.b d0		; $80AA28: A5 53
	eor.w #$FFFF		; $80AA2A: 49 FF FF
	inc a		; $80AA2D: 1A
	sta.b d0		; $80AA2E: 85 53
	lda.b d1		; $80AA30: A5 57
	eor.w #$FFFF		; $80AA32: 49 FF FF
	inc a		; $80AA35: 1A
	sta.b d1		; $80AA36: 85 57
.f0:
	lda.w position,x		; $80AA38: BD 9F 0B
	beq .goalie2		; $80AA3B: F0 54
	lda.b d4		; $80AA3D: A5 63  defense (entry <= 2*4): shift by fox/foy
	sec		; $80AA3F: 38
	sbc.w #$0008		; $80AA40: E9 08 00
	beq .def		; $80AA43: F0 08
	bmi .v1		; $80AA45: 30 04
	bvs .def		; $80AA47: 70 04
	bra .nodef		; $80AA49: 80 36
.v1:
	bvs .nodef		; $80AA4B: 70 34
.def:
	lda.w fox		; $80AA4D: AD 46 01
	eor.b d0		; $80AA50: 45 53
	bpl .notmid		; $80AA52: 10 17
	lda.w foy		; $80AA54: AD 48 01
	lsr a		; $80AA57: 4A
	lsr a		; $80AA58: 4A
	lsr a		; $80AA59: 4A
	bit.w #$1000		; $80AA5A: 89 00 10
	beq .mid		; $80AA5D: F0 03
	ora.w #$E000		; $80AA5F: 09 00 E0
.mid:
	eor.w #$FFFF		; $80AA62: 49 FF FF
	inc a		; $80AA65: 1A
	clc		; $80AA66: 18
	adc.b d1		; $80AA67: 65 57
	sta.b d1		; $80AA69: 85 57
.notmid:
	lda.w fox		; $80AA6B: AD 46 01
	lsr a		; $80AA6E: 4A
	lsr a		; $80AA6F: 4A
	bit.w #$2000		; $80AA70: 89 00 20
	beq .xadj		; $80AA73: F0 03
	ora.w #$C000		; $80AA75: 09 00 C0
.xadj:
	sta.b d3		; $80AA78: 85 5F
	lda.b d0		; $80AA7A: A5 53
	sec		; $80AA7C: 38
	sbc.b d3		; $80AA7D: E5 5F
	sta.b d0		; $80AA7F: 85 53
.nodef:
	lda.b d0		; $80AA81: A5 53
	clc		; $80AA83: 18
	adc.w fox		; $80AA84: 6D 46 01
	sta.b d0		; $80AA87: 85 53
	lda.b d1		; $80AA89: A5 57
	clc		; $80AA8B: 18
	adc.w foy		; $80AA8C: 6D 48 01
	sta.b d1		; $80AA8F: 85 57
.goalie2:
	lda.b d0		; $80AA91: A5 53
	sta.w Xpos,x		; $80AA93: 9D FF 08
	sec		; $80AA96: 38
	sbc.w puckx		; $80AA97: ED 1B 09
	eor.w #$FFFF		; $80AA9A: 49 FF FF
	inc a		; $80AA9D: 1A
	sta.b d0		; $80AA9E: 85 53
	lda.b d1		; $80AAA0: A5 57
	sta.w Ypos,x		; $80AAA2: 9D 5F 09
	sec		; $80AAA5: 38
	sbc.w pucky		; $80AAA6: ED 7B 09
	eor.w #$FFFF		; $80AAA9: 49 FF FF
	inc a		; $80AAAC: 1A
	sta.b d1		; $80AAAD: 85 57
	stz.w Xvel,x		; $80AAAF: 9E DF 0A
	stz.w Yvel,x		; $80AAB2: 9E FF 0A
	jsl.l vtoa		; $80AAB5: 22 A8 AF 80  face the puck
	lda.b d0		; $80AAB9: A5 53
	sta.w facedir,x		; $80AABB: 9D BF 0D
	lda.w pflags,x		; $80AABE: BD DF 0E
	and.w #~pf2unav&$FFFF		; $80AAC1: 29 FF EF  clear pf2unav, pfalock, SPA
	sta.w pflags,x		; $80AAC4: 9D DF 0E
	stz.w pfalock,x		; $80AAC7: 9E 7F 11
	stz.w SPA,x		; $80AACA: 9E FF 0D
	lda.w #SPAglide		; $80AACD: A9 78 04
	sta.b d1		; $80AAD0: 85 57
	jsl.l SetSPA		; $80AAD2: 22 06 B0 80
.next:
	inc.b a3		; $80AAD6: E6 3F
	inc.b a3		; $80AAD8: E6 3F
	dec.b d2		; $80AADA: C6 5B
	bmi .done		; $80AADC: 30 03
	jmp.w .l0		; $80AADE: 4C 7E A9
.done:
	jsl.l SprSort		; $80AAE1: 22 6C B7 80  SprSort
	pla		; $80AAE5: 68
	sta.b a3		; $80AAE6: 85 3F
	pla		; $80AAE8: 68
	sta.b a3+2		; $80AAE9: 85 41
	ldx.b a3		; $80AAEB: A6 3F
	jsl.l $8FFDD8		; $80AAED: 22 D8 FD 8F  bank $8F: 93G ResetAndSelectPlayers
	jsl.l printz		; $80AAF1: 22 0C B9 80
	dw $0005		; $80AAF5  printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w #$0036		; $80AAFA: A9 36 00  8+46
	sta.b d0		; $80AAFD: 85 53
	lda.w fox		; $80AAFF: AD 46 01
	bpl .fok		; $80AB02: 10 05
	lda.w #$00BE		; $80AB04: A9 BE 00  (18*8)+46
	sta.b d0		; $80AB07: 85 53
.fok:
	lda.b d0		; $80AB09: A5 53
	sta.w fodropx		; $80AB0B: 8D 36 01
	sec		; $80AB0E: 38
	sbc.w #$002E		; $80AB0F: E9 2E 00
	lsr a		; $80AB12: 4A
	lsr a		; $80AB13: 4A
	lsr a		; $80AB14: 4A
	sta.w printx		; $80AB15: 8D 7B 04
	lda.w #$005C		; $80AB18: A9 5C 00  (3*8)+68
	sta.w fodropy		; $80AB1B: 8D 38 01
	lda.w #$0003		; $80AB1E: A9 03 00
	sta.w printy		; $80AB21: 8D 7D 04
	lda.w printy		; $80AB24: AD 7D 04
	asl a		; $80AB27: 0A
	asl a		; $80AB28: 0A
	asl a		; $80AB29: 0A
	asl a		; $80AB2A: 0A
	asl a		; $80AB2B: 0A
	adc.w printx		; $80AB2C: 6D 7B 04
	jsl.l $82FCCD		; $80AB2F: 22 CD FC 82  mark the box rows dirty, bank $82: textdirtylo = min(A)
	lda.w printy		; $80AB33: AD 7D 04
	clc		; $80AB36: 18
	adc.w #$0009		; $80AB37: 69 09 00
	asl a		; $80AB3A: 0A
	asl a		; $80AB3B: 0A
	asl a		; $80AB3C: 0A
	asl a		; $80AB3D: 0A
	asl a		; $80AB3E: 0A
	adc.w printx		; $80AB3F: 6D 7B 04
	adc.w #$000B		; $80AB42: 69 0B 00
	jsl.l $82FD64		; $80AB45: 22 64 FD 82  bank $82: textdirtyhi = max(A)
	lda.w #$E949		; $80AB49: A9 49 E9  FaceOffMap (bank $84); fobox nonzero
	sta.b fobox		; $80AB4C: 85 F4
	sta.b tmp0		; $80AB4E: 85 73
	lda.w #$0084		; $80AB50: A9 84 00
	sta.b tmp1		; $80AB53: 85 75
	lda.w printy		; $80AB55: AD 7D 04
	asl a		; $80AB58: 0A
	asl a		; $80AB59: 0A
	asl a		; $80AB5A: 0A
	asl a		; $80AB5B: 0A
	asl a		; $80AB5C: 0A
	adc.w printx		; $80AB5D: 6D 7B 04
	asl a		; $80AB60: 0A
	tax		; $80AB61: AA
	ldy.w #$0000		; $80AB62: A0 00 00
	lda.w #$000A		; $80AB65: A9 0A 00
	sta.b tmp1+1		; $80AB68: 85 76
	clc		; $80AB6A: 18
.row:		;copy the 12x10 FaceOffMap into the text map
	lda.w #$000C		; $80AB6B: A9 0C 00
	sta.b tmp2+1		; $80AB6E: 85 78
.col:
	lda.b [tmp0],y		; $80AB70: B7 73
	clc		; $80AB72: 18
	adc.w faceoffvrcset		; $80AB73: 6D D9 1B
	adc.w charofs		; $80AB76: 6D CD 1B
	sta.l textmap,x		; $80AB79: 9F 74 6E 7E
	iny		; $80AB7D: C8
	iny		; $80AB7E: C8
	inx		; $80AB7F: E8
	inx		; $80AB80: E8
	dec.b tmp2+1		; $80AB81: C6 78
	bne .col		; $80AB83: D0 EB
	txa		; $80AB85: 8A
	clc		; $80AB86: 18
	adc.w #$0028		; $80AB87: 69 28 00
	tax		; $80AB8A: AA
	dec.b tmp1+1		; $80AB8B: C6 76
	bne .row		; $80AB8D: D0 DC
	ldx.b a3		; $80AB8F: A6 3F
	lda.w OptLine		; $80AB91: AD 0C 16  line changes on: line names box
	bne .nol		; $80AB94: D0 69
	lda.w printy		; $80AB96: AD 7D 04
	clc		; $80AB99: 18
	adc.w #$000A		; $80AB9A: 69 0A 00
	sta.w printy		; $80AB9D: 8D 7D 04
	lda.w #$000C		; $80ABA0: A9 0C 00
	sta.b d0		; $80ABA3: 85 53
	lda.w #$0003		; $80ABA5: A9 03 00
	sta.b d1		; $80ABA8: 85 57
	jsl.l $8FD69F		; $80ABAA: 22 9F D6 8F  bank $8F: 93G Framer (d0/d1 size)
	lda.w tmline		; $80ABAE: AD DE 13
	sta.b d0		; $80ABB1: 85 53
	lda.w tmline+2		; $80ABB3: AD E0 13
	sta.b d1		; $80ABB6: 85 57
	lda.w gmode		; $80ABB8: AD 88 12  gmdir
	bit.w #gmdir		; $80ABBB: 89 02 00
	bne .nx		; $80ABBE: D0 0A
	lda.w tmline		; $80ABC0: AD DE 13
	sta.b d1		; $80ABC3: 85 57
	lda.w tmline+2		; $80ABC5: AD E0 13
	sta.b d0		; $80ABC8: 85 53
.nx:
	inc.w printx		; $80ABCA: EE 7B 04
	dec.w printy		; $80ABCD: CE 7D 04
	dec.w printy		; $80ABD0: CE 7D 04
	lda.w #$8213		; $80ABD3: A9 13 82  linelist (bank $8F)
	sta.b a1		; $80ABD6: 85 37
	lda.w #$008F		; $80ABD8: A9 8F 00
	sta.b a1+2		; $80ABDB: 85 39
	jsl.l $8FD68C		; $80ABDD: 22 8C D6 8F  bank $8F: 93G PrintStringFromList
	inc.w printx		; $80ABE1: EE 7B 04
	inc.w printx		; $80ABE4: EE 7B 04
	inc.w printx		; $80ABE7: EE 7B 04
	inc.w printx		; $80ABEA: EE 7B 04
	lda.b d1		; $80ABED: A5 57
	sta.b d0		; $80ABEF: 85 53
	lda.w #$8213		; $80ABF1: A9 13 82
	sta.b a1		; $80ABF4: 85 37
	lda.w #$008F		; $80ABF6: A9 8F 00
	sta.b a1+2		; $80ABF9: 85 39
	jsl.l $8FD68C		; $80ABFB: 22 8C D6 8F  bank $8F: 93G PrintStringFromList
.nol:		;time for the puck drop: 180-299 frames
	lda.w #$0078		; $80ABFF: A9 78 00
	jsl.l randoma		; $80AC02: 22 8B AE 80
	adc.w #$00B4		; $80AC06: 69 B4 00
	sta.b d0		; $80AC09: 85 53
	ldx.b a3		; $80AC0B: A6 3F
	sta.w temp1,x		; $80AC0D: 9D 5F 0C
	lda.w #$0001		; $80AC10: A9 01 00  fofdata2: home pull frame 1, away 4, ref 7
	sta.w fofdata2		; $80AC13: 8D 3A 01
	lda.w #$8000		; $80AC16: A9 00 80
	sta.w fofdata2+2		; $80AC19: 8D 3C 01
	sta.w fofdata+2		; $80AC1C: 8D 44 01
	lda.w #$0004		; $80AC1F: A9 04 00
	sta.w fofdata2+4		; $80AC22: 8D 3E 01
	lda.w #$A800		; $80AC25: A9 00 A8
	sta.w fofdata2+6		; $80AC28: 8D 40 01
	lda.w #$0007		; $80AC2B: A9 07 00
	sta.w fofdata		; $80AC2E: 8D 42 01
	lda.w gmode		; $80AC31: AD 88 12
	bit.w #gmdir		; $80AC34: 89 02 00  gmdir: flip the attributes
	bne .nfl		; $80AC37: D0 0C
	lda.w #$8800		; $80AC39: A9 00 88
	sta.w fofdata2+2		; $80AC3C: 8D 3C 01
	lda.w #$A000		; $80AC3F: A9 00 A0
	sta.w fofdata2+6		; $80AC42: 8D 40 01
.nfl:
	lda.w #$FFFF		; $80AC45: A9 FF FF  fodir1/fodir2 = none
	sta.w fodir1		; $80AC48: 8D 32 01
	sta.w fodir2		; $80AC4B: 8D 34 01
	stx.b xsave		; $80AC4E: 86 0A
	ldx.w #$001A		; $80AC50: A2 1A 00
.popa:
	pla		; $80AC53: 68
	sta.b a0,x		; $80AC54: 95 33
	dex		; $80AC56: CA
	dex		; $80AC57: CA
	bpl .popa		; $80AC58: 10 F9
	ldx.b xsave		; $80AC5A: A6 0A
	stx.b xsave		; $80AC5C: 86 0A
	ldx.w #$001E		; $80AC5E: A2 1E 00
.popd:
	pla		; $80AC61: 68
	sta.b d0,x		; $80AC62: 95 53
	dex		; $80AC64: CA
	dex		; $80AC65: CA
	bpl .popd		; $80AC66: 10 F9
	ldx.b xsave		; $80AC68: A6 0A
	ldx.b a3		; $80AC6A: A6 3F
	rtl		; $80AC6C: 6B
.nna:		;count down to the drop; then Endfaceoff
	lda.b d7		; $80AC6D: A5 6F  temp1 -= min(d7, temp1)
	sta.b tmp0		; $80AC6F: 85 73
	sec		; $80AC71: 38
	sbc.w temp1,x		; $80AC72: FD 5F 0C
	bmi .v2		; $80AC75: 30 04
	bvc .one		; $80AC77: 50 04
	bra .sub		; $80AC79: 80 07
.v2:
	bvc .sub		; $80AC7B: 50 05
.one:
	lda.w #$0001		; $80AC7D: A9 01 00
	sta.b tmp0		; $80AC80: 85 73
.sub:
	lda.w temp1,x		; $80AC82: BD 5F 0C
	sec		; $80AC85: 38
	sbc.b tmp0		; $80AC86: E5 73
	sta.w temp1,x		; $80AC88: 9D 5F 0C
	bpl updatefaceoff		; $80AC8B: 10 37
	jmp.w Endfaceoff		; $80AC8D: 4C 34 AD
.apl:		;93G .apl: .ptab entry for each position, by players on ice (6, 5, 4)
	db 0,1,2,3,4,5,6,0		; $80AC90  6 on ice
	db 0,1,5,3,4,2,0,0		; $80AC98  5 on ice
	db 0,3,5,1,4,0,0,0		; $80ACA0  4 on ice
.ptab:		;93G .ptab: faceoff x/y offsets
	dw 0,-250, -35,-50, 35,-50, -50,-10		; $80ACA8
	dw 0,-15, 50,-10, 0,-60		; $80ACB8
updatefaceoff:		;auto: CODE_80ACC4. 93G updatefaceoff (logic93_4): X = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	lda.w temp1,x		; $80ACC4: BD 5F 0C
	beq .erase		; $80ACC7: F0 27
	clc		; $80ACC9: 18  (temp1+6)/8 <= 2: drop frame 10-d0
	adc.w #$0006		; $80ACCA: 69 06 00
	lsr a		; $80ACCD: 4A
	lsr a		; $80ACCE: 4A
	lsr a		; $80ACCF: 4A
	sta.b d0		; $80ACD0: 85 53
	sec		; $80ACD2: 38
	sbc.w #$0002		; $80ACD3: E9 02 00
	beq .set		; $80ACD6: F0 08
	bmi .v1		; $80ACD8: 30 04
	bvs .set		; $80ACDA: 70 04
	bra .rtl		; $80ACDC: 80 11
.v1:
	bvs .rtl		; $80ACDE: 70 0F
.set:
	lda.b d0		; $80ACE0: A5 53
	eor.w #$FFFF		; $80ACE2: 49 FF FF
	inc a		; $80ACE5: 1A
	clc		; $80ACE6: 18
	adc.w #$000A		; $80ACE7: 69 0A 00
	sta.b d0		; $80ACEA: 85 53
	sta.w fofdata		; $80ACEC: 8D 42 01
.rtl:
	rtl		; $80ACEF: 6B
.erase:
	jsl.l printz		; $80ACF0: 22 0C B9 80  erase the faceoff box
	dw $0005		; $80ACF4  printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w fodropx		; $80ACF9: AD 36 01
	sec		; $80ACFC: 38
	sbc.w #$002E		; $80ACFD: E9 2E 00
	lsr a		; $80AD00: 4A
	lsr a		; $80AD01: 4A
	lsr a		; $80AD02: 4A
	bit.w #$1000		; $80AD03: 89 00 10
	beq .x		; $80AD06: F0 03
	ora.w #$E000		; $80AD08: 09 00 E0
.x:
	sta.w printx		; $80AD0B: 8D 7B 04
	lda.w fodropy		; $80AD0E: AD 38 01
	sec		; $80AD11: 38
	sbc.w #$0044		; $80AD12: E9 44 00
	lsr a		; $80AD15: 4A
	lsr a		; $80AD16: 4A
	lsr a		; $80AD17: 4A
	bit.w #$1000		; $80AD18: 89 00 10
	beq .y		; $80AD1B: F0 03
	ora.w #$E000		; $80AD1D: 09 00 E0
.y:
	sta.w printy		; $80AD20: 8D 7D 04
	lda.w #$000C		; $80AD23: A9 0C 00
	sta.b d0		; $80AD26: 85 53
	inc a		; $80AD28: 1A
	sta.b d1		; $80AD29: 85 57
	lda.w blankchar		; $80AD2B: AD E7 1B
	sta.b d2		; $80AD2E: 85 5B
	jml.l $8D847C		; $80AD30: 5C 7C 84 8D  bank $8D: 93G eraser (d0/d1 size, d2 tile)
Endfaceoff:		;auto: CODE_80AD34. 93G Endfaceoff (logic93_4): drop the puck: pick the faceoff winner and send the puck off
	lda.w seed+2		; $80AD34: AD A3 04  puck on the ice sound
	and.w #$0003		; $80AD37: 29 03 00
	clc		; $80AD3A: 18
	adc.w #SFXshotwiff		; $80AD3B: 69 98 00
	pha		; $80AD3E: 48
	jsl.l sfx		; $80AD3F: 22 8B C2 80
	lda.w #sf2faceoff		; $80AD43: A9 00 01  faceoff over, fobox off, replay record on, clock running
	trb.w sflags		; $80AD46: 1C 8C 12
	stz.b fobox		; $80AD49: 64 F4
	lda.w #sf2drec		; $80AD4B: A9 00 04
	trb.w sflags		; $80AD4E: 1C 8C 12
	stz.w gmclock		; $80AD51: 9C 8A 12
	stz.w pf2fight,x		; $80AD54: 9E 5F 11
	lda.w #sf3fo		; $80AD57: A9 10 00  sf3fo
	tsb.w sflags3		; $80AD5A: 0C 90 12
	lda.w fodir1		; $80AD5D: AD 32 01  d3 = fodir1, d4 = $800 (toward the top), a1 = home
	sta.b d3		; $80AD60: 85 5F
	lda.w #$0800		; $80AD62: A9 00 08
	sta.b d4		; $80AD65: 85 63
	stz.b a1		; $80AD67: 64 37
	lda.w #$0010		; $80AD69: A9 10 00
	sta.b d2		; $80AD6C: 85 5B
	ldx.w fofdata2		; $80AD6E: AE 3A 01
	lda.l .ftab-1,x		; $80AD71: BF 2F AE 80
	and.w #$00FF		; $80AD75: 29 FF 00
	bit.w #$0080		; $80AD78: 89 80 00
	beq .f1		; $80AD7B: F0 03
	ora.w #$FF00		; $80AD7D: 09 00 FF
.f1:
	eor.w #$FFFF		; $80AD80: 49 FF FF
	inc a		; $80AD83: 1A
	clc		; $80AD84: 18
	adc.b d2		; $80AD85: 65 5B
	sta.b d2		; $80AD87: 85 5B
	ldx.w fofdata2+4		; $80AD89: AE 3E 01
	lda.l .ftab-1,x		; $80AD8C: BF 2F AE 80
	and.w #$00FF		; $80AD90: 29 FF 00
	bit.w #$0080		; $80AD93: 89 80 00
	beq .f2		; $80AD96: F0 03
	ora.w #$FF00		; $80AD98: 09 00 FF
.f2:
	clc		; $80AD9B: 18
	adc.b d2		; $80AD9C: 65 5B
	sta.b d2		; $80AD9E: 85 5B
	lda.w #$0021		; $80ADA0: A9 21 00  random(33) vs the pull frames: who won
	jsl.l randoma		; $80ADA3: 22 8B AE 80
	cmp.b d2		; $80ADA7: C5 5B
	bcs .p1won		; $80ADA9: B0 05
	lda.w #$0004		; $80ADAB: A9 04 00  visitors won
	sta.b a1		; $80ADAE: 85 37
.p1won:
	ldx.b a1		; $80ADB0: A6 37
	lda.w fofdata2+2,x		; $80ADB2: BD 3C 01
	bit.w #$0800		; $80ADB5: 89 00 08  winner faces down: fodir2, -$800
	beq .pos		; $80ADB8: F0 0A
	lda.w fodir2		; $80ADBA: AD 34 01
	sta.b d3		; $80ADBD: 85 5F
	lda.w #$F800		; $80ADBF: A9 00 F8
	sta.b d4		; $80ADC2: 85 63
.pos:
	lda.b d3		; $80ADC4: A5 5F
	bit.w #$0008		; $80ADC6: 89 08 00
	bne .nojoy		; $80ADC9: D0 0D
	and.w #$0007		; $80ADCB: 29 07 00
	sta.b d0		; $80ADCE: 85 53
	lda.w seed		; $80ADD0: AD A1 04  joystick direction 3 in 4
	and.w #$0003		; $80ADD3: 29 03 00
	bne .nj2		; $80ADD6: D0 19
.nojoy:
	lda.w #$0005		; $80ADD8: A9 05 00  random direction -2..2
	jsl.l randoma		; $80ADDB: 22 8B AE 80
	dec a		; $80ADDF: 3A
	dec a		; $80ADE0: 3A
	and.w #$0007		; $80ADE1: 29 07 00
	sta.b d0		; $80ADE4: 85 53
	lda.b d4		; $80ADE6: A5 63
	bmi .nj2		; $80ADE8: 30 07
	lda.b d0		; $80ADEA: A5 53
	eor.w #$0004		; $80ADEC: 49 04 00
	sta.b d0		; $80ADEF: 85 53
.nj2:
	asl.b d0		; $80ADF1: 06 53
	asl.b d0		; $80ADF3: 06 53
	ldx.b d0		; $80ADF5: A6 53
	lda.l dirtab,x		; $80ADF7: BF 36 AE 80  Xvel = dirtab x * 32
	asl a		; $80ADFB: 0A
	asl a		; $80ADFC: 0A
	asl a		; $80ADFD: 0A
	asl a		; $80ADFE: 0A
	asl a		; $80ADFF: 0A
	ldx.b a3		; $80AE00: A6 3F
	sta.w Xvel,x		; $80AE02: 9D DF 0A
	ldx.b d0		; $80AE05: A6 53
	lda.l dirtab+2,x		; $80AE07: BF 38 AE 80  Yvel = dirtab y * 32 + d4
	asl a		; $80AE0B: 0A
	asl a		; $80AE0C: 0A
	asl a		; $80AE0D: 0A
	asl a		; $80AE0E: 0A
	asl a		; $80AE0F: 0A
	clc		; $80AE10: 18
	adc.b d4		; $80AE11: 65 63
	ldx.b a3		; $80AE13: A6 3F
	sta.w Yvel,x		; $80AE15: 9D FF 0A
	lda.w #$0800		; $80AE18: A9 00 08  Zvel = random(0..$800)
	jsl.l randoma		; $80AE1B: 22 8B AE 80
	sta.w Zvel,x		; $80AE1F: 9D 1F 0B
	stz.w Zpos+puckobj		; $80AE22: 9C BB 09
	stz.w pfnc,x		; $80AE25: 9E FF 11
	lda.w #pnorm		; $80AE28: A9 18 00  pnorm
	sta.b d0		; $80AE2B: 85 53
	jmp.w assreplace		; $80AE2D: 4C A7 B4
.ftab:		;93G .ftab: faceoff strength by pull frame
	db 0,8,16,0,8,16		; $80AE30
dirtab:		;93G dirtab (logic93_5): x,y speed for each direction 0-7 (92 runspeed 200, diagonal 141)
	dw 0,200, 141,141, 200,0, 141,-141		; $80AE36
	dw 0,-200, -141,-141, -200,0, -141,141		; $80AE46
random:		;auto: CODE_80AE56. 93G randomd0 seed step: seed = seed*$BB40E62D+1 (32-bit LCG); returns A = seed+1 (middle bytes), rndb1/rndb2 set
	lda.w seed		; $80AE56: AD A1 04  mula = seed (32-bit)
	sta.b mula		; $80AE59: 85 7D
	lda.w seed+2		; $80AE5B: AD A3 04
	sta.b mula+2		; $80AE5E: 85 7F
	lda.w #$E62D		; $80AE60: A9 2D E6  mulb = $BB40E62D
	sta.b mulb		; $80AE63: 85 83
	lda.w #$BB40		; $80AE65: A9 40 BB
	sta.b mulb+2		; $80AE68: 85 85
	jsl.l $88832F		; $80AE6A: 22 2F 83 88  bank $88: mulu 32-bit
	adc.w #$0001		; $80AE6E: 69 01 00
	sta.w seed		; $80AE71: 8D A1 04
	lda.b mulres+2		; $80AE74: A5 95
	adc.w #$0000		; $80AE76: 69 00 00
	sta.w seed+2		; $80AE79: 8D A3 04
	xba		; $80AE7C: EB  seed bytes 2/1 for the 8-bit users ($0493/$0491)
	and.w #$00FF		; $80AE7D: 29 FF 00
	sta.w rndb2		; $80AE80: 8D 93 04
	lda.w seed+1		; $80AE83: AD A2 04
	sta.w rndb1		; $80AE86: 8D 91 04
	clc		; $80AE89: 18
	rtl		; $80AE8A: 6B
randoma:		;auto: CODE_80AE8B. 93G randomd0 with A = range: returns A = random 0..range-1 (high word of random*range). C clear
	pha		; $80AE8B: 48
	jsl.l random		; $80AE8C: 22 56 AE 80
	sta.b mula		; $80AE90: 85 7D
	pla		; $80AE92: 68
	sta.b mulb		; $80AE93: 85 83
	jsl.l $888942		; $80AE95: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2		; $80AE99: A5 95
	clc		; $80AE9B: 18
	rtl		; $80AE9C: 6B
changeplayer:		;auto: CODE_80AE9D. 93G changeplayer (logic93_1): switch controller d4 (0/2) to the teammate nearest the puck, or sweep check if that is the current player
	stx.b xsave		; $80AE9D: 86 0A
	ldx.w #$0000		; $80AE9F: A2 00 00
.pushd:
	lda.b d0,x		; $80AEA2: B5 53
	pha		; $80AEA4: 48
	inx		; $80AEA5: E8
	inx		; $80AEA6: E8
	cpx.w #$001C		; $80AEA7: E0 1C 00
	bne .pushd		; $80AEAA: D0 F6
	ldx.b xsave		; $80AEAC: A6 0A
	stx.b xsave		; $80AEAE: 86 0A
	ldx.w #$0000		; $80AEB0: A2 00 00
.pusha:
	lda.b a0,x		; $80AEB3: B5 33
	pha		; $80AEB5: 48
	inx		; $80AEB6: E8
	inx		; $80AEB7: E8
	cpx.w #$0008		; $80AEB8: E0 08 00
	bne .pusha		; $80AEBB: D0 F6
	ldx.b xsave		; $80AEBD: A6 0A
	lda.w puckvy		; $80AEBF: AD 1B 0B  puck + velocity/256 (lead the puck)
	xba		; $80AEC2: EB
	and.w #$00FF		; $80AEC3: 29 FF 00
	bit.w #$0080		; $80AEC6: 89 80 00
	beq .ly		; $80AEC9: F0 03
	ora.w #$FF00		; $80AECB: 09 00 FF
.ly:
	clc		; $80AECE: 18
	adc.w pucky		; $80AECF: 6D 7B 09
	pha		; $80AED2: 48
	lda.w puckvx		; $80AED3: AD FB 0A
	xba		; $80AED6: EB
	and.w #$00FF		; $80AED7: 29 FF 00
	bit.w #$0080		; $80AEDA: 89 80 00
	beq .lx		; $80AEDD: F0 03
	ora.w #$FF00		; $80AEDF: 09 00 FF
.lx:
	clc		; $80AEE2: 18
	adc.w puckx		; $80AEE3: 6D 1B 09
	pha		; $80AEE6: 48
	lda.w #$0005		; $80AEE7: A9 05 00
	sta.b d2		; $80AEEA: 85 5B
	lda.b d4		; $80AEEC: A5 63
	tay		; $80AEEE: A8
	eor.w #$0002		; $80AEEF: 49 02 00  d3 = the other controller
	sta.b d3		; $80AEF2: 85 5F
	lda.w #$FFFF		; $80AEF4: A9 FF FF  d5 = best distance^2
	sta.b d5+2		; $80AEF7: 85 69
	ldx.w #$0000		; $80AEF9: A2 00 00
	lda.w cont1team,y		; $80AEFC: B9 96 12  controller on the home team: players 0-5, else 6-11
	cmp.w #$0001		; $80AEFF: C9 01 00
	beq .t1		; $80AF02: F0 03
	ldx.w #$000C		; $80AF04: A2 0C 00
.t1:
	ldy.b d3		; $80AF07: A4 5F
.top:
	lda.w position,x		; $80AF09: BD 9F 0B
	bmi .next		; $80AF0C: 30 54
	beq .next		; $80AF0E: F0 52
	lda.w pflags,x		; $80AF10: BD DF 0E  pf2unav or pfalock: skip
	and.w #$1000		; $80AF13: 29 00 10
	ora.w pfalock,x		; $80AF16: 1D 7F 11
	bne .next		; $80AF19: D0 47
	lda.b $01,s		; $80AF1B: A3 01
	sec		; $80AF1D: 38
	sbc.w Xpos,x		; $80AF1E: FD FF 08
	sta.b mula		; $80AF21: 85 7D
	sta.b mulb		; $80AF23: 85 83
	jsl.l $82FCDB		; $80AF25: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $80AF29: 85 53
	lda.b mulres+2		; $80AF2B: A5 95
	sta.b d0+2		; $80AF2D: 85 55
	lda.b $03,s		; $80AF2F: A3 03
	sec		; $80AF31: 38
	sbc.w Ypos,x		; $80AF32: FD 5F 09
	sta.b mula		; $80AF35: 85 7D
	sta.b mulb		; $80AF37: 85 83
	jsl.l $82FCDB		; $80AF39: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $80AF3D: 65 53
	sta.b d0		; $80AF3F: 85 53
	lda.b mulres+2		; $80AF41: A5 95
	adc.b d0+2		; $80AF43: 65 55
	sta.b d0+2		; $80AF45: 85 55
	lda.b d5		; $80AF47: A5 67
	cmp.b d0		; $80AF49: C5 53
	lda.b d5+2		; $80AF4B: A5 69
	sbc.b d0+2		; $80AF4D: E5 55
	bcc .next		; $80AF4F: 90 11
	txa		; $80AF51: 8A
	lsr a		; $80AF52: 4A
	cmp.w c1playernum,y		; $80AF53: D9 92 12  the other controller has him
	beq .next		; $80AF56: F0 0A
	sta.b d6		; $80AF58: 85 6B
	lda.b d0		; $80AF5A: A5 53
	sta.b d5		; $80AF5C: 85 67
	lda.b d0+2		; $80AF5E: A5 55
	sta.b d5+2		; $80AF60: 85 69
.next:
	inx		; $80AF62: E8
	inx		; $80AF63: E8
	dec.b d2		; $80AF64: C6 5B
	bpl .top		; $80AF66: 10 A1
	ldx.b a3		; $80AF68: A6 3F
	pla		; $80AF6A: 68
	pla		; $80AF6B: 68
	ldy.b d4		; $80AF6C: A4 63
	lda.b d6		; $80AF6E: A5 6B
	cmp.w c1playernum,y		; $80AF70: D9 92 12  same player: Sweepcheck
	bne .set		; $80AF73: D0 06
	jsl.l Sweepcheck		; $80AF75: 22 8A 8D 80
	bra .ex		; $80AF79: 80 10
.set:
	sta.b d0		; $80AF7B: 85 53
	lda.b d4		; $80AF7D: A5 63
	bne .c2		; $80AF7F: D0 06
	jsl.l setc1player		; $80AF81: 22 48 A1 80
	bra .ex		; $80AF85: 80 04
.c2:
	jsl.l setc2player		; $80AF87: 22 5E A1 80
.ex:
	stx.b xsave		; $80AF8B: 86 0A
	ldx.w #$0006		; $80AF8D: A2 06 00
.popa:
	pla		; $80AF90: 68
	sta.b a0,x		; $80AF91: 95 33
	dex		; $80AF93: CA
	dex		; $80AF94: CA
	bpl .popa		; $80AF95: 10 F9
	ldx.b xsave		; $80AF97: A6 0A
	stx.b xsave		; $80AF99: 86 0A
	ldx.w #$001A		; $80AF9B: A2 1A 00
.popd:
	pla		; $80AF9E: 68
	sta.b d0,x		; $80AF9F: 95 53
	dex		; $80AFA1: CA
	dex		; $80AFA2: CA
	bpl .popd		; $80AFA3: 10 F9
	ldx.b xsave		; $80AFA5: A6 0A
	rtl		; $80AFA7: 6B
vtoa:		;auto: CODE_80AFA8. 93G vtoa (logic93_5): d0/d1 are x/y distances, returned in d0 as a direction 0-7 (8 = no direction)
	lda.b d0		; $80AFA8: A5 53
	ora.b d1		; $80AFAA: 05 57
	beq .nodir		; $80AFAC: F0 42  no direction
	stz.b d0+2		; $80AFAE: 64 55
	lda.b d0		; $80AFB0: A5 53
	bpl .yabs		; $80AFB2: 10 08
	eor.w #$FFFF		; $80AFB4: 49 FF FF
	inc a		; $80AFB7: 1A
	sta.b d0		; $80AFB8: 85 53
	inc.b d0+2		; $80AFBA: E6 55
.yabs:
	lda.b d1		; $80AFBC: A5 57
	bpl .b2		; $80AFBE: 10 0A
	eor.w #$FFFF		; $80AFC0: 49 FF FF
	inc a		; $80AFC3: 1A
	sta.b d1		; $80AFC4: 85 57
	inc.b d0+2		; $80AFC6: E6 55
	inc.b d0+2		; $80AFC8: E6 55
.b2:
	lda.b d1		; $80AFCA: A5 57  bit 2: |dx| <= 2|dy|
	asl a		; $80AFCC: 0A
	cmp.b d0		; $80AFCD: C5 53
	bcc .b3		; $80AFCF: 90 05
	lda.w #$0004		; $80AFD1: A9 04 00
	tsb.b d0+2		; $80AFD4: 04 55
.b3:
	lda.b d0		; $80AFD6: A5 53  bit 3: |dy| <= 2|dx|
	asl a		; $80AFD8: 0A
	cmp.b d1		; $80AFD9: C5 57
	bcc .look		; $80AFDB: 90 05
	lda.w #$0008		; $80AFDD: A9 08 00
	tsb.b d0+2		; $80AFE0: 04 55
.look:
	phx		; $80AFE2: DA
	ldx.b d0+2		; $80AFE3: A6 55
	lda.l .dt,x		; $80AFE5: BF F6 AF 80
	plx		; $80AFE9: FA
	and.w #$00FF		; $80AFEA: 29 FF 00
	sta.b d0		; $80AFED: 85 53
	rtl		; $80AFEF: 6B
.nodir:
	lda.w #$0008		; $80AFF0: A9 08 00
	sta.b d0		; $80AFF3: 85 53
	rtl		; $80AFF5: 6B
.dt:		;93G vtoa .dt: direction for each sign/ratio combination
	db 1,7,3,5,0,0,4,4,2,6,2,6,1,7,3,5		; $80AFF6
