; $80910F-$80A120  ROM $0110F-$02120: 93G player logic continued: asspassrec, assfight (chkhit, CwdFight, FightFall), assfwatch,
; assfaceoff, assexit, assfaceoffp1 (logic93_2/4/5), randomd0, puck logic pucknorm with findpc, divs, a2touchpuck, a2offsides,
; GetHot, puckIChk, ChkOffsides (logic93_4/5), and the puck/player collision checkpuckcoll, puckstick, puckglue (hockey93_04/05).
org $80910F
asspassrec:		;auto: asstab $13. 93G asspassrec (logic93_4 IDA loc_BFC6): assignment for catching a pass
	lda.w pfalock,x		; $80910F: BD 7F 11
	bne .rts		; $809112: D0 47  locked
	lda.w gmclock		; $809114: AD 8A 12  clock stopped
	beq .joy		; $809117: F0 04
	jml.l $8FD75A		; $809119: 5C 5A D7 8F  bank $8F: 93G assnothing
.joy:
	lda.w pflags,x		; $80911D: BD DF 0E
	bit.w #pfjoycon		; $809120: 89 08 00  joystick controlled
	beq .na		; $809123: F0 03
	jmp.w assexit		; $809125: 4C F9 96
.na:
	bit.w #pfna		; $809128: 89 02 00
	beq .nna		; $80912B: F0 12
	and.w #~pfna&$FFFF		; $80912D: 29 FD FF  clear pfna, set pfdoff
	ora.w #pfdoff		; $809130: 09 01 00
	sta.w pflags,x		; $809133: 9D DF 0E
	stz.w temp2,x		; $809136: 9E 7F 0C  temp2 = 8 (93G temp2+1 = 8, temp2 = 0)
	lda.w #$0008		; $809139: A9 08 00
	sta.w temp2b,x		; $80913C: 9D FF 0C
.nna:
	lda.w puckc		; $80913F: AD BB 0E  puck loose: wait temp1 frames
	bpl .ex		; $809142: 10 0B
	lda.w temp1,x		; $809144: BD 5F 0C
	sec		; $809147: 38
	sbc.b d7		; $809148: E5 6F
	sta.w temp1,x		; $80914A: 9D 5F 0C
	bpl .rts		; $80914D: 10 0C
.ex:
	lda.w pflags,x		; $80914F: BD DF 0E  clear pfdoff
	and.w #~pfdoff&$FFFF		; $809152: 29 FE FF
	sta.w pflags,x		; $809155: 9D DF 0E
	jmp.w assexit		; $809158: 4C F9 96
.rts:
	rtl		; $80915B: 6B
assfight:		;auto: asstab $14. 93G assfight (logic93_2): fighting logic for player X. The SNES drops the 93G banner call and keeps the fighters inside x +-$6F
	lda.w pfalock,x		; $80915C: BD 7F 11
	beq .go		; $80915F: F0 03
	jmp.w .rts		; $809161: 4C 29 93
.go:
	lda.w Pencntdwn		; $809164: AD E0 12  fight over
	bpl .chkna		; $809167: 10 04
	jml.l $8FD75A		; $809169: 5C 5A D7 8F  bank $8F: 93G assnothing
.chkna:
	lda.w pflags,x		; $80916D: BD DF 0E
	bit.w #pfna		; $809170: 89 02 00
	beq .nna		; $809173: F0 46
	and.w #~pfna&$FFFF		; $809175: 29 FD FF
	sta.w pflags,x		; $809178: 9D DF 0E
	jsl.l getpde		; $80917B: 22 C4 84 80
	lda.w fightagg,x		; $80917F: BD DF 10  getpde * fightagg / $1000
	sta.b d1		; $809182: 85 57
	sta.b mula		; $809184: 85 7D
	lda.b d0		; $809186: A5 53
	sta.b mulb		; $809188: 85 83
	jsl.l $8D871C		; $80918A: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	xba		; $80918E: EB
	and.w #$00FF		; $80918F: 29 FF 00
	lsr a		; $809192: 4A
	lsr a		; $809193: 4A
	lsr a		; $809194: 4A
	lsr a		; $809195: 4A
	cmp.w #$0006		; $809196: C9 06 00
	bcs .s		; $809199: B0 03
	lda.w #$0005		; $80919B: A9 05 00
.s:		;temp3 = strength (min 5)
	sta.w temp3,x		; $80919E: 9D 9F 0C
	stz.w temp2,x		; $8091A1: 9E 7F 0C
	stz.w temp2b,x		; $8091A4: 9E FF 0C
	lda.w #$FFFF		; $8091A7: A9 FF FF  temp4 = banner timer
	sta.w temp4,x		; $8091AA: 9D BF 0C
	lda.w facedir,x		; $8091AD: BD BF 0D
	cmp.w #$0002		; $8091B0: C9 02 00  one player shows the banner
	bne .nna		; $8091B3: D0 06
	lda.w #$005A		; $8091B5: A9 5A 00
	sta.w temp4,x		; $8091B8: 9D BF 0C
.nna:		;keep the fighter within x -$6F..$6F
	lda.w Xpos,x		; $8091BB: BD FF 08
	sec		; $8091BE: 38
	sbc.w #$006F		; $8091BF: E9 6F 00
	beq .left		; $8091C2: F0 11
	bmi .v1		; $8091C4: 30 04
	bvc .clampr		; $8091C6: 50 04
	bra .left		; $8091C8: 80 0B
.v1:
	bvc .left		; $8091CA: 50 09
.clampr:
	stz.w Xvel,x		; $8091CC: 9E DF 0A
	lda.w #$006F		; $8091CF: A9 6F 00
	sta.w Xpos,x		; $8091D2: 9D FF 08
.left:
	lda.w Xpos,x		; $8091D5: BD FF 08
	sec		; $8091D8: 38
	sbc.w #$FF91		; $8091D9: E9 91 FF
	bmi .v2		; $8091DC: 30 04
	bvs .clampl		; $8091DE: 70 04
	bra .nna2		; $8091E0: 80 0B
.v2:
	bvs .nna2		; $8091E2: 70 09
.clampl:
	stz.w Xvel,x		; $8091E4: 9E DF 0A
	lda.w #$FF91		; $8091E7: A9 91 FF
	sta.w Xpos,x		; $8091EA: 9D FF 08
.nna2:		;temp4 = banner timer (no banner on the SNES)
	lda.w temp4,x		; $8091ED: BD BF 0C
	sec		; $8091F0: 38
	sbc.b d7		; $8091F1: E5 6F
	sta.w temp4,x		; $8091F3: 9D BF 0C
	lda.w temp3,x		; $8091F6: BD 9F 0C
	bpl .fight		; $8091F9: 10 03
	jmp.w .rts		; $8091FB: 4C 29 93
.fight:
	lda.w impactp,x		; $8091FE: BD 3F 0B  a0 = opponent; xc1 = half way between the fighters
	asl a		; $809201: 0A
	sta.b a0		; $809202: 85 33
	tay		; $809204: A8
	lda.w Xpos,x		; $809205: BD FF 08
	adc.w Xpos,y		; $809208: 79 FF 08
	pha		; $80920B: 48
	asl a		; $80920C: 0A
	pla		; $80920D: 68
	ror a		; $80920E: 6A
	sta.w xc1		; $80920F: 8D F5 08
	lda.w pflags,x		; $809212: BD DF 0E
	bit.w #pfjoycon		; $809215: 89 08 00  joystick: no computer punch
	bne .j		; $809218: D0 7B
	lda.w pf2aip,x		; $80921A: BD DF 11  set pf2aip, test the old value
	pha		; $80921D: 48
	lda.w #$0001		; $80921E: A9 01 00
	sta.w pf2aip,x		; $809221: 9D DF 11
	pla		; $809224: 68
	bne .j		; $809225: D0 6E
	lda.w Xpos,x		; $809227: BD FF 08
	sec		; $80922A: 38
	sbc.w Xpos,y		; $80922B: F9 FF 08
	sta.b d0		; $80922E: 85 53
	lda.w Xvel,x		; $809230: BD DF 0A
	xba		; $809233: EB
	and.w #$00FF		; $809234: 29 FF 00
	bit.w #$0080		; $809237: 89 80 00
	beq .vx1		; $80923A: F0 03
	ora.w #$FF00		; $80923C: 09 00 FF
.vx1:
	clc		; $80923F: 18
	adc.b d0		; $809240: 65 53
	sta.b d0		; $809242: 85 53
	lda.w Xvel,y		; $809244: B9 DF 0A
	xba		; $809247: EB
	and.w #$00FF		; $809248: 29 FF 00
	bit.w #$0080		; $80924B: 89 80 00
	beq .vx2		; $80924E: F0 03
	ora.w #$FF00		; $809250: 09 00 FF
.vx2:
	sta.b d1		; $809253: 85 57
	lda.b d0		; $809255: A5 53
	sec		; $809257: 38
	sbc.b d1		; $809258: E5 57
	sta.b d0		; $80925A: 85 53
	bit.w #$8000		; $80925C: 89 00 80
	beq .inrange		; $80925F: F0 04
	eor.w #$FFFF		; $809261: 49 FF FF
	inc a		; $809264: 1A
.inrange:
	cmp.w #$0019		; $809265: C9 19 00  computer punches only within 25 pixels
	bcs .j		; $809268: B0 2B
	lda.w #$0008		; $80926A: A9 08 00
	sta.b d0		; $80926D: 85 53
	jsl.l randomd0		; $80926F: 22 A3 97 80
	lda.b d0		; $809273: A5 53
	cmp.w #$0003		; $809275: C9 03 00
	bcc .p		; $809278: 90 05
	and.w #$0001		; $80927A: 29 01 00
	sta.b d0		; $80927D: 85 53
.p:		;choose the punch type from .al
	asl.b d0		; $80927F: 06 53
	lda.w #.al		; $809281: A9 2A 93
	sta.b a1		; $809284: 85 37
	lda.w #.al>>16		; $809286: A9 80 00
	sta.b a1+2		; $809289: 85 39
	ldy.b d0		; $80928B: A4 53
	lda.b [a1],y		; $80928D: B7 37
	sta.b d1		; $80928F: 85 57
	jsl.l $80B006		; $809291: 22 06 B0 80  SetSPA (d1 = animation)
.j:
	jsl.l chkhit		; $809295: 22 30 93 80
	lda.w SPA,x		; $809299: BD FF 0D
	cmp.w #SPAfheld		; $80929C: C9 2E 0F  held: still pushed
	beq .njc		; $80929F: F0 0D
	cmp.w #SPAfight		; $8092A1: C9 DA 0E  ready: no push
	beq .jc		; $8092A4: F0 4B
	lda.w pflags,x		; $8092A6: BD DF 0E
	bit.w #pfjoycon		; $8092A9: 89 08 00
	bne .jc		; $8092AC: D0 43
.njc:		;push toward the fight spot (xc1+-10)
	lda.w xc1		; $8092AE: AD F5 08
	clc		; $8092B1: 18
	adc.w #$000A		; $8092B2: 69 0A 00
	sta.b d0		; $8092B5: 85 53
	lda.w facedir,x		; $8092B7: BD BF 0D
	cmp.w #$0002		; $8092BA: C9 02 00
	bne .push		; $8092BD: D0 08
	lda.b d0		; $8092BF: A5 53
	sec		; $8092C1: 38
	sbc.w #$0014		; $8092C2: E9 14 00
	sta.b d0		; $8092C5: 85 53
.push:
	lda.b d0		; $8092C7: A5 53
	sec		; $8092C9: 38
	sbc.w Xpos,x		; $8092CA: FD FF 08
	sta.b mula		; $8092CD: 85 7D
	lda.w #$0023		; $8092CF: A9 23 00  35 toward the spot, 5 away from it (93G asl #5)
	sta.b mulb		; $8092D2: 85 83
	lda.w facedir,x		; $8092D4: BD BF 0D
	sec		; $8092D7: 38
	sbc.w #$0004		; $8092D8: E9 04 00
	eor.b mula		; $8092DB: 45 7D
	bmi .mul		; $8092DD: 30 05
	lda.w #$0005		; $8092DF: A9 05 00
	sta.b mulb		; $8092E2: 85 83
.mul:
	jsl.l muls16		; $8092E4: 22 96 84 80
	sta.b d0		; $8092E8: 85 53
	clc		; $8092EA: 18
	adc.w Xvel,x		; $8092EB: 7D DF 0A
	sta.w Xvel,x		; $8092EE: 9D DF 0A
.jc:		;Yvel = (yc1-Ypos)*256, +-$1000
	lda.w yc1		; $8092F1: AD F7 08
	sec		; $8092F4: 38
	sbc.w Ypos,x		; $8092F5: FD 5F 09
	xba		; $8092F8: EB
	and.w #$FF00		; $8092F9: 29 00 FF
	sta.b d1		; $8092FC: 85 57
	sec		; $8092FE: 38
	sbc.w #$1000		; $8092FF: E9 00 10
	bmi .v3		; $809302: 30 04
	bvc .y1		; $809304: 50 04
	bra .y2		; $809306: 80 07
.v3:
	bvc .y2		; $809308: 50 05
.y1:
	lda.w #$1000		; $80930A: A9 00 10
	sta.b d1		; $80930D: 85 57
.y2:
	lda.b d1		; $80930F: A5 57
	sec		; $809311: 38
	sbc.w #$F000		; $809312: E9 00 F0
	beq .y3		; $809315: F0 08
	bmi .v4		; $809317: 30 04
	bvs .y3		; $809319: 70 04
	bra .sety		; $80931B: 80 07
.v4:
	bvs .sety		; $80931D: 70 05
.y3:
	lda.w #$F000		; $80931F: A9 00 F0
	sta.b d1		; $809322: 85 57
.sety:
	lda.b d1		; $809324: A5 57
	sta.w Yvel,x		; $809326: 9D FF 0A
.rts:
	rtl		; $809329: 6B
.al:		;93G .al: punch animations SPAfhigh, SPAflow, SPAfgrab
	dw SPAfhigh,SPAflow,SPAfgrab		; $80932A
chkhit:		;auto: CODE_809330. 93G chkhit (logic93_2): part of the fight, is player X hit by opponent a0?
	stx.b xsave		; $809330: 86 0A
	ldx.w #$0000		; $809332: A2 00 00
.pushd:		;movem d0/a0-a3 to the stack
	lda.b d0,x		; $809335: B5 53
	pha		; $809337: 48
	inx		; $809338: E8
	inx		; $809339: E8
	cpx.w #$0004		; $80933A: E0 04 00
	bne .pushd		; $80933D: D0 F6
	ldx.b xsave		; $80933F: A6 0A
	stx.b xsave		; $809341: 86 0A
	ldx.w #$0000		; $809343: A2 00 00
.pusha:
	lda.b a0,x		; $809346: B5 33
	pha		; $809348: 48
	inx		; $809349: E8
	inx		; $80934A: E8
	cpx.w #$0010		; $80934B: E0 10 00
	bne .pusha		; $80934E: D0 F6
	ldx.b xsave		; $809350: A6 0A
	ldy.b a0		; $809352: A4 33  Y = opponent
	lda.w frame,x		; $809354: BD 3F 09
	cmp.w oldframe,x		; $809357: DD FF 09  same frame as last time: nothing new
	beq .ex		; $80935A: F0 5C
	cmp.w #SPFfight+2		; $80935C: C9 64 01  gloves dropped frame
	beq .dropped		; $80935F: F0 76
	lda.w Xpos,x		; $809361: BD FF 08
	sec		; $809364: 38
	sbc.w Xpos,y		; $809365: F9 FF 08
	bit.w #$8000		; $809368: 89 00 80
	beq .dx		; $80936B: F0 04
	eor.w #$FFFF		; $80936D: 49 FF FF
	inc a		; $809370: 1A
.dx:
	cmp.w #$0017		; $809371: C9 17 00  within 22 in x
	bcs .ex		; $809374: B0 42
	lda.w Ypos,x		; $809376: BD 5F 09
	sec		; $809379: 38
	sbc.w Ypos,y		; $80937A: F9 5F 09
	bit.w #$8000		; $80937D: 89 00 80
	beq .dy		; $809380: F0 04
	eor.w #$FFFF		; $809382: 49 FF FF
	inc a		; $809385: 1A
.dy:
	cmp.w #$0009		; $809386: C9 09 00  within 8 in y
	bcs .ex		; $809389: B0 2D
	lda.w frame,x		; $80938B: BD 3F 09
	cmp.w #SPFfight+6		; $80938E: C9 68 01  high punch frames
	bne .h2		; $809391: D0 03
	jmp.w .hithigh		; $809393: 4C 3D 94
.h2:
	cmp.w #SPFfight+6+5		; $809396: C9 6D 01
	bne .l1		; $809399: D0 03
	jmp.w .hithigh		; $80939B: 4C 3D 94
.l1:
	cmp.w #SPFfight+7		; $80939E: C9 69 01  low punch frames
	bne .l2		; $8093A1: D0 03
	jmp.w .hitlow		; $8093A3: 4C 68 94
.l2:
	cmp.w #SPFfight+7+5		; $8093A6: C9 6E 01
	bne .g1		; $8093A9: D0 03
	jmp.w .hitlow		; $8093AB: 4C 68 94
.g1:
	cmp.w #SPFfight+4		; $8093AE: C9 66 01  grab frames
	beq .grab		; $8093B1: F0 73
	cmp.w #SPFfight+4+5		; $8093B3: C9 6B 01
	beq .grab		; $8093B6: F0 6E
.ex:		;auto: CODE_8093B8. 93G chkhit .ex: movem the registers back (global: CwdFight/FightFall paths jump here)
	stx.b xsave		; $8093B8: 86 0A
	ldx.w #$000E		; $8093BA: A2 0E 00
.popa:
	pla		; $8093BD: 68
	sta.b a0,x		; $8093BE: 95 33
	dex		; $8093C0: CA
	dex		; $8093C1: CA
	bpl .popa		; $8093C2: 10 F9
	ldx.b xsave		; $8093C4: A6 0A
	stx.b xsave		; $8093C6: 86 0A
	ldx.w #$0002		; $8093C8: A2 02 00
.popd:
	pla		; $8093CB: 68
	sta.b d0,x		; $8093CC: 95 53
	dex		; $8093CE: CA
	dex		; $8093CF: CA
	bpl .popd		; $8093D0: 10 F9
	ldx.b xsave		; $8093D2: A6 0A
	ldx.b a3		; $8093D4: A6 3F  X = a3 again
	rtl		; $8093D6: 6B
.dropped:		;auto: CODE_8093D7. 93G chkhit .dropped: gloves dropped, glovecords from xc1/yc1 (x clamped +-90)
	lda.w pflags,x		; $8093D7: BD DF 0E
	and.w #~pf2npc&$FFFF		; $8093DA: 29 FF 7F  clear pf2npc: gloves dropped
	sta.w pflags,x		; $8093DD: 9D DF 0E
	lda.w xc1		; $8093E0: AD F5 08
	sta.b d0		; $8093E3: 85 53
	sec		; $8093E5: 38
	sbc.w #$005A		; $8093E6: E9 5A 00
	bmi .v1		; $8093E9: 30 04
	bvc .cl1		; $8093EB: 50 04
	bra .chkneg		; $8093ED: 80 07
.v1:
	bvc .chkneg		; $8093EF: 50 05
.cl1:
	lda.w #$005A		; $8093F1: A9 5A 00
	sta.b d0		; $8093F4: 85 53
.chkneg:
	lda.b d0		; $8093F6: A5 53
	sec		; $8093F8: 38
	sbc.w #$FFA6		; $8093F9: E9 A6 FF
	beq .cl2		; $8093FC: F0 08
	bmi .v2		; $8093FE: 30 04
	bvs .cl2		; $809400: 70 04
	bra .drcont		; $809402: 80 07
.v2:
	bvs .drcont		; $809404: 70 05
.cl2:
	lda.w #$FFA6		; $809406: A9 A6 FF
	sta.b d0		; $809409: 85 53
.drcont:
	lda.b d0		; $80940B: A5 53
	lsr a		; $80940D: 4A
	lsr a		; $80940E: 4A
	and.w #$00FF		; $80940F: 29 FF 00
	bne .dr0		; $809412: D0 01
	inc a		; $809414: 1A
.dr0:
	sta.w glovecords		; $809415: 8D 4E 01  glovecords x byte (0 becomes 1)
	lda.w yc1		; $809418: AD F7 08
	lsr a		; $80941B: 4A
	lsr a		; $80941C: 4A
	sep #$20		; $80941D: E2 20
	sta.w glovecords+1		; $80941F: 8D 4F 01  glovecords y byte
	rep #$30		; $809422: C2 30
	bra .ex		; $809424: 80 92
.grab:		;exg a0,a3: the opponent is held
	ldx.b a0		; $809426: A6 33
	ldy.b a3		; $809428: A4 3F
	stx.b a3		; $80942A: 86 3F
	sty.b a0		; $80942C: 84 33
	lda.w #SPAfheld		; $80942E: A9 2E 0F
	sta.b d1		; $809431: 85 57
	sta.w pf2aip,x		; $809433: 9D DF 11
	jsl.l $80B006		; $809436: 22 06 B0 80  SetSPA (d1 = animation)
	jmp.w .ex		; $80943A: 4C B8 93
.hithigh:
	ldx.b a0		; $80943D: A6 33
	ldy.b a3		; $80943F: A4 3F
	stx.b a3		; $809441: 86 3F
	sty.b a0		; $809443: 84 33
	jsl.l CwdFight		; $809445: 22 93 94 80
	lda.w #$0001		; $809449: A9 01 00  pf2aip
	sta.w pf2aip,x		; $80944C: 9D DF 11
	dec.w temp3,x		; $80944F: DE 9F 0C  strength -1; out of strength: falls
	bmi FightFall		; $809452: 30 77
	lda.w #SPAfhith		; $809454: A9 B4 0F
	sta.b d1		; $809457: 85 57
	jsl.l $80B006		; $809459: 22 06 B0 80  SetSPA (d1 = animation)
	lda.w #SFXhithigh		; $80945D: A9 92 00
	pha		; $809460: 48
	jsl.l $80C28B		; $809461: 22 8B C2 80  sfx (sound number pushed)
	jmp.w .ex		; $809465: 4C B8 93
.hitlow:
	ldx.b a0		; $809468: A6 33
	ldy.b a3		; $80946A: A4 3F
	stx.b a3		; $80946C: 86 3F
	sty.b a0		; $80946E: 84 33
	jsl.l CwdFight		; $809470: 22 93 94 80
	lda.w #$0001		; $809474: A9 01 00
	sta.w pf2aip,x		; $809477: 9D DF 11
	dec.w temp3,x		; $80947A: DE 9F 0C
	bmi FightFall		; $80947D: 30 4C
	lda.w #SPAfhitl		; $80947F: A9 D6 0F
	sta.b d1		; $809482: 85 57
	jsl.l $80B006		; $809484: 22 06 B0 80  SetSPA (d1 = animation)
	lda.w #SFXhitlow		; $809488: A9 93 00
	pha		; $80948B: 48
	jsl.l $80C28B		; $80948C: 22 8B C2 80  sfx (sound number pushed)
	jmp.w .ex		; $809490: 4C B8 93
CwdFight:		;auto: CODE_809493. 93G chkhit .cwd (IDA CwdFight): crowd reacts to a punch; push the hit player X back by the puncher (a0) strength
	ldy.b a0		; $809493: A4 33
	lda.b crowdlevel		; $809495: A5 DE
	clc		; $809497: 18
	adc.w #$0050		; $809498: 69 50 00  +80
	sta.b crowdlevel		; $80949B: 85 DE
	lda.w #$0005		; $80949D: A9 05 00  (5 + puncher strength) * 500
	clc		; $8094A0: 18
	adc.w temp3,y		; $8094A1: 79 9F 0C
	sta.b mulb		; $8094A4: 85 83
	lda.w #$01F4		; $8094A6: A9 F4 01
	sta.b mula		; $8094A9: 85 7D
	jsl.l $8D871C		; $8094AB: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	sta.b d0		; $8094AF: 85 53
	lda.w facedir,x		; $8094B1: BD BF 0D
	cmp.w #$0002		; $8094B4: C9 02 00  push the other way when facing right
	bne .xveladj		; $8094B7: D0 08
	lda.b d0		; $8094B9: A5 53
	eor.w #$FFFF		; $8094BB: 49 FF FF
	inc a		; $8094BE: 1A
	sta.b d0		; $8094BF: 85 53
.xveladj:
	lda.w Xvel,x		; $8094C1: BD DF 0A
	clc		; $8094C4: 18
	adc.b d0		; $8094C5: 65 53
	sta.w Xvel,x		; $8094C7: 9D DF 0A
	rtl		; $8094CA: 6B
FightFall:		;auto: CODE_8094CB. 93G chkhit .fall (IDA FightFall): X lost the fight: the a0 player gets PenFighting, maybe X is injured
	lda.b a1+2		; $8094CB: A5 39  push a1
	pha		; $8094CD: 48
	lda.b a1		; $8094CE: A5 37
	pha		; $8094D0: 48
	lda.w #PenaltyBufferEnd		; $8094D1: A9 9C 12  a1 = penalty list
	sta.b a1		; $8094D4: 85 37
	lda.w #$0000		; $8094D6: A9 00 00
	sta.b a1+2		; $8094D9: 85 39
.loop:		;find the fight penalty of the a0 player
	inc.b a1		; $8094DB: E6 37
	inc.b a1		; $8094DD: E6 37
	lda.b [a1]		; $8094DF: A7 37
	and.w #$00FF		; $8094E1: 29 FF 00
	cmp.w #PenFight		; $8094E4: C9 26 00
	bne .loop		; $8094E7: D0 F2
	lda.b [a1]		; $8094E9: A7 37
	xba		; $8094EB: EB
	and.w #$000F		; $8094EC: 29 0F 00
	sta.b d0		; $8094EF: 85 53
	ldy.b a0		; $8094F1: A4 33
	cmp.w SCnum,y		; $8094F3: D9 9F 0D  penalty of the a0 player?
	bne .loop		; $8094F6: D0 E3
	sep #$20		; $8094F8: E2 20
	lda.b #PenFighting		; $8094FA: A9 28  it becomes PenFighting
	sta.b [a1]		; $8094FC: 87 37
	rep #$20		; $8094FE: C2 20
	pla		; $809500: 68
	sta.b a1		; $809501: 85 37
	pla		; $809503: 68
	sta.b a1+2		; $809504: 85 39
	lda.w #$003C		; $809506: A9 3C 00  60
	sta.w Pencntdwn		; $809509: 8D E0 12
	lda.w #$FFFF		; $80950C: A9 FF FF  temp3(a0) = -1: fight over for him
	sta.w temp3,y		; $80950F: 99 9F 0C
	lda.b crowdlevel		; $809512: A5 DE
	clc		; $809514: 18
	adc.w #$0258		; $809515: 69 58 02  +600
	sta.b crowdlevel		; $809518: 85 DE
	lda.w #$003C		; $80951A: A9 3C 00
	sta.b d0		; $80951D: 85 53
	jsl.l randomd0		; $80951F: 22 A3 97 80
	ldy.b a0		; $809523: A4 33
	lda.b d0		; $809525: A5 53
	sec		; $809527: 38
	sbc.w aggress,y		; $809528: F9 FF 10  random 60 vs the winner aggress: injury?
	beq .inj		; $80952B: F0 08
	bmi .v1		; $80952D: 30 04
	bvs .inj		; $80952F: 70 04
	bra .noinj		; $809531: 80 3D
.v1:
	bvs .noinj		; $809533: 70 3B
.inj:		;player X is injured
	lda.w #$00B4		; $809535: A9 B4 00  180: player is injured
	sta.w Pencntdwn		; $809538: 8D E0 12
	lda.w pflags,x		; $80953B: BD DF 0E
	ora.w #pf2inj		; $80953E: 09 04 00
	sta.w pflags,x		; $809541: 9D DF 0E
	lda.w #SPAffall		; $809544: A9 56 11
	sta.b d1		; $809547: 85 57
	jsl.l $80B006		; $809549: 22 06 B0 80  SetSPA (d1 = animation)
	stx.b a2		; $80954D: 86 3B
	jsl.l $8FF74A		; $80954F: 22 4A F7 8F  setInjuryType (bank $8F): d1 = roster offset, bank $8F: 93G setInjuryType
	lda.b a0		; $809553: A5 33
	beq .team		; $809555: F0 03
	lda.w #$0034		; $809557: A9 34 00
.team:
	clc		; $80955A: 18
	adc.b d1		; $80955B: 65 57
	tay		; $80955D: A8
	lda.w #INJfight		; $80955E: A9 2C 11  tmpdst of the injured player = INJfight
	sta.w tmpdst,y		; $809561: 99 E2 14
	lda.w #$0003		; $809564: A9 03 00
	sta.w InjCntDown		; $809567: 8D E6 12  93G InjCntDown = 3
	stz.w Xvel,x		; $80956A: 9E DF 0A
	jmp.w chkhit_ex		; $80956D: 4C B8 93
.noinj:
	lda.w #SPAbfall		; $809570: A9 F8 0F
	sta.b d1		; $809573: 85 57
	jsl.l $80B006		; $809575: 22 06 B0 80  SetSPA (d1 = animation)
	stz.b a2		; $809579: 64 3B
	lda.w #SFXcrowdcheer		; $80957B: A9 8A 00  home won: cheer
	pha		; $80957E: 48
	lda.w pfteam,x		; $80957F: BD 9F 11
	bne .snd		; $809582: D0 0A
	lda.w #$0002		; $809584: A9 02 00
	sta.b a2		; $809587: 85 3B
	lda.w #SFXcrowdboo		; $809589: A9 8B 00
	sta.b $01,s		; $80958C: 83 01
.snd:
	jsl.l $80C28B		; $80958E: 22 8B C2 80  sfx (sound number pushed)
	jmp.w chkhit_ex		; $809592: 4C B8 93
assfwatch:		;auto: asstab $15. 93G assfwatch (logic93_2): for a player watching a fight: skate to a spot 80 pixels from the fight
	lda.w pfalock,x		; $809595: BD 7F 11
	beq .joy		; $809598: F0 03
	jmp.w .rts		; $80959A: 4C A7 96
.joy:
	lda.w pflags,x		; $80959D: BD DF 0E
	bit.w #pfjoycon		; $8095A0: 89 08 00  joystick controlled
	beq .na		; $8095A3: F0 03
	jmp.w .rts		; $8095A5: 4C A7 96
.na:
	bit.w #pfna		; $8095A8: 89 02 00
	beq .nna		; $8095AB: F0 09
	and.w #~pfna&$FFFF		; $8095AD: 29 FD FF
	sta.w pflags,x		; $8095B0: 9D DF 0E
	stz.w temp1,x		; $8095B3: 9E 5F 0C
.nna:
	lda.w temp1,x		; $8095B6: BD 5F 0C
	sec		; $8095B9: 38
	sbc.b d7		; $8095BA: E5 6F
	sta.w temp1,x		; $8095BC: 9D 5F 0C
	bmi .spot		; $8095BF: 30 03
	jmp.w .go		; $8095C1: 4C 78 96
.spot:		;new spot every second
	adc.w #$003C		; $8095C4: 69 3C 00  +60
	sta.w temp1,x		; $8095C7: 9D 5F 0C
	lda.w Ypos,x		; $8095CA: BD 5F 09
	sec		; $8095CD: 38
	sbc.w yc1		; $8095CE: ED F7 08
	pha		; $8095D1: 48
	lda.w Xpos,x		; $8095D2: BD FF 08
	sec		; $8095D5: 38
	sbc.w xc1		; $8095D6: ED F5 08
	pha		; $8095D9: 48
	sta.b mula		; $8095DA: 85 7D
	sta.b mulb		; $8095DC: 85 83
	jsl.l $82FCDB		; $8095DE: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $8095E2: 85 53
	lda.b mulres+2		; $8095E4: A5 95
	sta.b d0+2		; $8095E6: 85 55
	lda.b $03,s		; $8095E8: A3 03
	sta.b mula		; $8095EA: 85 7D
	sta.b mulb		; $8095EC: 85 83
	jsl.l $82FCDB		; $8095EE: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $8095F2: 65 53
	sta.b d0		; $8095F4: 85 53
	lda.b mulres+2		; $8095F6: A5 95
	adc.b d0+2		; $8095F8: 65 55
	sta.b d0+2		; $8095FA: 85 55
	jsl.l $80CBB1		; $8095FC: 22 B1 CB 80  distance to the fight, sroot: A = sqrt(d0 32-bit)
	lda.b d0		; $809600: A5 53
	bne .d		; $809602: D0 03
	lda.w #$0001		; $809604: A9 01 00
.d:
	sta.b d2		; $809607: 85 5B
	pla		; $809609: 68
	sta.b d0		; $80960A: 85 53
	sta.b mulb		; $80960C: 85 83
	pla		; $80960E: 68
	sta.b d1		; $80960F: 85 57
	lda.w #$0050		; $809611: A9 50 00  80 pixels from the fight
	sta.b mula		; $809614: 85 7D
	jsl.l $82FCDB		; $809616: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d2		; $80961A: A5 5B
	sta.b mula		; $80961C: 85 7D
	jsl.l divs		; $80961E: 22 6C 99 80
	adc.w xc1		; $809622: 6D F5 08
	sta.b d0		; $809625: 85 53
	lda.w #$007E		; $809627: A9 7E 00  x within +-$7E
	sta.b d3		; $80962A: 85 5F
	lda.b d0		; $80962C: A5 53
	sec		; $80962E: 38
	sbc.b d3		; $80962F: E5 5F
	bmi .v1		; $809631: 30 04
	bvc .x0		; $809633: 50 04
	bra .x1		; $809635: 80 06
.v1:
	bvc .x1		; $809637: 50 04
.x0:
	lda.b d3		; $809639: A5 5F
	sta.b d0		; $80963B: 85 53
.x1:
	lda.b d3		; $80963D: A5 5F
	eor.w #$FFFF		; $80963F: 49 FF FF
	inc a		; $809642: 1A
	sta.b d3		; $809643: 85 5F
	lda.b d0		; $809645: A5 53
	sec		; $809647: 38
	sbc.b d3		; $809648: E5 5F
	beq .x2		; $80964A: F0 08
	bmi .v2		; $80964C: 30 04
	bvs .x2		; $80964E: 70 04
	bra .x3		; $809650: 80 06
.v2:
	bvs .x3		; $809652: 70 04
.x2:
	lda.b d3		; $809654: A5 5F
	sta.b d0		; $809656: 85 53
.x3:
	lda.b d0		; $809658: A5 53
	sta.w temp3,x		; $80965A: 9D 9F 0C
	lda.w #$0050		; $80965D: A9 50 00
	sta.b mula		; $809660: 85 7D
	lda.b d1		; $809662: A5 57
	sta.b mulb		; $809664: 85 83
	jsl.l $82FCDB		; $809666: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d2		; $80966A: A5 5B
	sta.b mula		; $80966C: 85 7D
	jsl.l divs		; $80966E: 22 6C 99 80
	adc.w yc1		; $809672: 6D F7 08
	sta.w temp4,x		; $809675: 9D BF 0C
.go:
	lda.w temp3,x		; $809678: BD 9F 0C
	sta.b d0		; $80967B: 85 53
	lda.w temp4,x		; $80967D: BD BF 0C
	sta.b d1		; $809680: 85 57
	lda.w #rtss		; $809682: A9 E6 84  a0 = rtss
	sta.b a0		; $809685: 85 33
	lda.w #rtss>>16		; $809687: A9 80 00
	sta.b a0+2		; $80968A: 85 35
	lda.w Xvel,x		; $80968C: BD DF 0A  SNES: halve the velocity while watching
	pha		; $80968F: 48
	asl a		; $809690: 0A
	pla		; $809691: 68
	ror a		; $809692: 6A
	sta.w Xvel,x		; $809693: 9D DF 0A
	lda.w Yvel,x		; $809696: BD FF 0A
	pha		; $809699: 48
	asl a		; $80969A: 0A
	pla		; $80969B: 68
	ror a		; $80969C: 6A
	sta.w Yvel,x		; $80969D: 9D FF 0A
	jsl.l $88FDD0		; $8096A0: 22 D0 FD 88  bank $88: 93G skateto (d0/d1 = spot, [a0] = arrival routine)
	jmp.w check4check		; $8096A4: 4C 15 8B
.rts:
	rtl		; $8096A7: 6B
assfaceoff:		;auto: asstab $16. 93G assfaceoff (logic93_2): players do nothing until the faceoff is over. SNES: also starts the goal / period / mid-period music cues
	lda.w pfalock,x		; $8096A8: BD 7F 11
	bne .rts		; $8096AB: D0 4B
	lda.w sflags		; $8096AD: AD 8C 12
	bit.w #sf2faceoff		; $8096B0: 89 00 01  faceoff over: exit
	beq assexit		; $8096B3: F0 44
	lda.w goalcue		; $8096B5: AD 29 04  home goal music cue
	beq .per		; $8096B8: F0 10
	stz.w goalcue		; $8096BA: 9C 29 04
	lda.w #$0001		; $8096BD: A9 01 00  hold and clear the sound queue
	sta.b sndlock		; $8096C0: 85 21
	stz.b sndqin		; $8096C2: 64 1D
	stz.b sndqout		; $8096C4: 64 1F
	jsl.l $89FBB3		; $8096C6: 22 B3 FB 89  bank $89: home goal music cue
.per:
	lda.w percue		; $8096CA: AD 2B 04  period start music cue
	beq .mid		; $8096CD: F0 10
	stz.w percue		; $8096CF: 9C 2B 04
	lda.w #$0001		; $8096D2: A9 01 00
	sta.b sndlock		; $8096D5: 85 21
	stz.b sndqin		; $8096D7: 64 1D
	stz.b sndqout		; $8096D9: 64 1F
	jsl.l $89FBDF		; $8096DB: 22 DF FB 89  bank $89: period start music cue
.mid:
	lda.w cuetimer		; $8096DF: AD A9 04  no cue playing, clock >= 60 and past midpercue: mid-period cue
	bne .rts		; $8096E2: D0 14
	lda.w gameclock		; $8096E4: AD F2 12
	cmp.w #$003C		; $8096E7: C9 3C 00
	bcc .rts		; $8096EA: 90 0C
	cmp.w midpercue		; $8096EC: CD 2F 04
	bcs .rts		; $8096EF: B0 07
	stz.w midpercue		; $8096F1: 9C 2F 04
	jsl.l $89FC63		; $8096F4: 22 63 FC 89  bank $89: mid-period music cue
.rts:
	rtl		; $8096F8: 6B
assexit:		;auto: CODE_8096F9. 93G assexit (logic93_5): exit the current assignment of player X
	lda.w assnum,x		; $8096F9: BD BF 0B
	inc a		; $8096FC: 1A  next assignment
	and.w #$0007		; $8096FD: 29 07 00
	sta.w assnum,x		; $809700: 9D BF 0B
	lda.w pflags,x		; $809703: BD DF 0E
	ora.w #pfna		; $809706: 09 02 00  pfna
	sta.w pflags,x		; $809709: 9D DF 0E
	rtl		; $80970C: 6B
assfaceoffp1:		;auto: asstab $17. 93G assfaceoffp1 (logic93_2): assignment for the players taking the faceoff
	lda.w pfalock,x		; $80970D: BD 7F 11
	beq .go		; $809710: F0 03
	jmp.w .rts		; $809712: 4C 99 97
.go:
	lda.w sflags		; $809715: AD 8C 12
	bit.w #sf2faceoff		; $809718: 89 00 01  faceoff over
	beq .exit		; $80971B: F0 7D
	lda.w pflags,x		; $80971D: BD DF 0E
	bit.w #pfna		; $809720: 89 02 00
	beq .nna		; $809723: F0 09
	and.w #~pfna&$FFFF		; $809725: 29 FD FF
	sta.w pflags,x		; $809728: 9D DF 0E
	stz.w temp1,x		; $80972B: 9E 5F 0C
.nna:
	lda.w #fofdata2		; $80972E: A9 3A 01  a0 = fofdata2, +4 for the visitors
	sta.b a0		; $809731: 85 33
	lda.w #$0000		; $809733: A9 00 00
	sta.b a0+2		; $809736: 85 35
	lda.w pfteam,x		; $809738: BD 9F 11
	beq .frame		; $80973B: F0 05
	lda.w #fofdata2+4		; $80973D: A9 3E 01
	sta.b a0		; $809740: 85 33
.frame:
	lda.w SPAnum,x		; $809742: BD 1F 0E  frame = SPAnum/4 + 1, +3 for a righty
	lsr a		; $809745: 4A
	lsr a		; $809746: 4A
	inc a		; $809747: 1A
	sta.b d0		; $809748: 85 53
	lda.w handed,x		; $80974A: BD 1F 11
	bne .lefty		; $80974D: D0 06
	inc.b d0		; $80974F: E6 53
	inc.b d0		; $809751: E6 53
	inc.b d0		; $809753: E6 53
.lefty:
	lda.b d0		; $809755: A5 53
	sta.b [a0]		; $809757: 87 33
	lda.w pflags,x		; $809759: BD DF 0E
	bit.w #pfjoycon		; $80975C: 89 08 00  joystick: the player pulls
	bne .rts		; $80975F: D0 38
	lda.w pf2aip,x		; $809761: BD DF 11  set pf2aip, test the old value
	pha		; $809764: 48
	lda.w #$0001		; $809765: A9 01 00
	sta.w pf2aip,x		; $809768: 9D DF 11
	pla		; $80976B: 68
	cmp.w #$0000		; $80976C: C9 00 00
	bne .rts		; $80976F: D0 28
	lda.w #SPAfaceoff		; $809771: A9 96 10
	sta.b d1		; $809774: 85 57
	lda.w temp1+puckobj		; $809776: AD 7B 0C  puck temp1 > $10: 7 in 8 reverse pull
	cmp.w #$0011		; $809779: C9 11 00
	bcc .d		; $80977C: 90 12
	lda.w #$0008		; $80977E: A9 08 00
	sta.b d0		; $809781: 85 53
	jsl.l randomd0		; $809783: 22 A3 97 80
	lda.b d0		; $809787: A5 53
	beq .d		; $809789: F0 05
	lda.w #SPAfaceoffr		; $80978B: A9 C0 10
	sta.b d1		; $80978E: 85 57
.d:
	lda.w #$0001		; $809790: A9 01 00
	sta.w pf2aip,x		; $809793: 9D DF 11
	jmp.w $B006		; $809796: 4C 06 B0  SetSPA (d1 = animation)
.rts:
	rtl		; $809799: 6B
.exit:
	lda.w #$0014		; $80979A: A9 14 00  nopuck = 20
	sta.w nopuck,x		; $80979D: 9D 5F 0E
	jmp.w assexit		; $8097A0: 4C F9 96
randomd0:		;auto: CODE_8097A3. 93G randomd0: d0 = random 0..d0-1 (via randoma)
	lda.b d0		; $8097A3: A5 53
	jsl.l $80AE8B		; $8097A5: 22 8B AE 80  randoma: A = random 0..A-1
	sta.b d0		; $8097A9: 85 53
	rtl		; $8097AB: 6B
pucknorm:		;auto: asstab $18. 93G pucknorm (logic93_4): assignment for the puck most of the time. X = puck, d7 = elapsed frames
	lda.w #pfna		; $8097AC: A9 02 00
	trb.w pflags+puckobj		; $8097AF: 1C FB 0E  pfna
	beq .nna		; $8097B2: F0 0C
	stz.w temp1+puckobj		; $8097B4: 9C 7B 0C  temp1 = 0, temp2b = still puck timer 120
	stz.w temp2+puckobj		; $8097B7: 9C 9B 0C
	lda.w #$0078		; $8097BA: A9 78 00
	sta.w temp2b+puckobj		; $8097BD: 8D 1B 0D
.nna:
	lda.w puckcross+2		; $8097C0: AD 8B 04  puckcross times count down
	sec		; $8097C3: 38
	sbc.b d7		; $8097C4: E5 6F
	sta.w puckcross+2		; $8097C6: 8D 8B 04
	lda.w puckcross+6		; $8097C9: AD 8F 04
	sec		; $8097CC: 38
	sbc.b d7		; $8097CD: E5 6F
	sta.w puckcross+6		; $8097CF: 8D 8F 04
	lda.w temp1+puckobj		; $8097D2: AD 7B 0C  every 5 frames: findpc
	sec		; $8097D5: 38
	sbc.b d7		; $8097D6: E5 6F
	sta.w temp1+puckobj		; $8097D8: 8D 7B 0C
	bpl .c0		; $8097DB: 10 0A
	adc.w #$0005		; $8097DD: 69 05 00
	sta.w temp1+puckobj		; $8097E0: 8D 7B 0C
	jsl.l findpc		; $8097E3: 22 8A 98 80
.c0:		;puck carried: pull it a quarter of the way to the carrier hot spot
	lda.w puckc		; $8097E7: AD BB 0E  puck carrier
	bmi .nothandled		; $8097EA: 30 51
	asl a		; $8097EC: 0A
	sta.b a2		; $8097ED: 85 3B
	jsl.l a2touchpuck		; $8097EF: 22 C7 99 80
	lda.b a2		; $8097F3: A5 3B
	jsl.l GetHot		; $8097F5: 22 0A 9B 80
	ldy.b a2		; $8097F9: A4 3B
	lda.b d0		; $8097FB: A5 53
	clc		; $8097FD: 18
	adc.w Xpos,y		; $8097FE: 79 FF 08
	sec		; $809801: 38
	sbc.w puckx		; $809802: ED 1B 09
	lsr a		; $809805: 4A
	lsr a		; $809806: 4A
	bit.w #$2000		; $809807: 89 00 20  asr #2
	beq .x		; $80980A: F0 03
	ora.w #$C000		; $80980C: 09 00 C0
.x:
	clc		; $80980F: 18
	adc.w puckx		; $809810: 6D 1B 09
	sta.w puckx		; $809813: 8D 1B 09
	lda.b d1		; $809816: A5 57
	clc		; $809818: 18
	adc.w Ypos,y		; $809819: 79 5F 09
	sec		; $80981C: 38
	sbc.w pucky		; $80981D: ED 7B 09
	lsr a		; $809820: 4A
	lsr a		; $809821: 4A
	bit.w #$2000		; $809822: 89 00 20
	beq .y		; $809825: F0 03
	ora.w #$C000		; $809827: 09 00 C0
.y:
	clc		; $80982A: 18
	adc.w pucky		; $80982B: 6D 7B 09
	sta.w pucky		; $80982E: 8D 7B 09
	lda.w Xvel,y		; $809831: B9 DF 0A  puck velocity = carrier velocity
	sta.w puckvx		; $809834: 8D FB 0A
	lda.w Yvel,y		; $809837: B9 FF 0A
	sta.w puckvy		; $80983A: 8D 1B 0B
.nothandled:
	jsl.l puckIChk		; $80983D: 22 7A 9B 80
	jsl.l ChkOffsides		; $809841: 22 C3 9B 80
	lda.w gmclock		; $809845: AD 8A 12  clock stopped
	bne .z		; $809848: D0 2B
	lda.w puckc		; $80984A: AD BB 0E  loose puck that has not moved for 120 calls: whistle
	bpl .mv		; $80984D: 10 20
	lda.w puckx		; $80984F: AD 1B 09
	cmp.w OldXpos+puckobj		; $809852: CD 3B 0A
	bne .mv		; $809855: D0 18
	lda.w pucky		; $809857: AD 7B 09
	cmp.w OldYpos+puckobj		; $80985A: CD 7B 0A
	bne .mv		; $80985D: D0 10
	lda.w #PenHold6		; $80985F: A9 06 00  PenHold6
	sta.b d0		; $809862: 85 53
	dec.w temp2b+puckobj		; $809864: CE 1B 0D
	bpl .np		; $809867: 10 04
	jsl.l $80C1B0		; $809869: 22 B0 C1 80  AddPenalty2 (d0 = penalty)
.np:
	bra .z		; $80986D: 80 06
.mv:		;reset the still puck timer
	lda.w #$0078		; $80986F: A9 78 00
	sta.w temp2b+puckobj		; $809872: 8D 1B 0D
.z:
	lda.w puckvz		; $809875: AD 3B 0B  puck in the air: no unflip
	and.w #$FF00		; $809878: 29 00 FF
	ora.w Zpos+puckobj		; $80987B: 0D BB 09
	beq .flat		; $80987E: F0 03
	jmp.w checkpuckcoll		; $809880: 4C 17 9D
.flat:
	jsl.l $80A52A		; $809883: 22 2A A5 80  pucknothing: stop spinning, pucknothing
	jmp.w checkpuckcoll		; $809887: 4C 17 9D  93G bra checkpuckcoll
findpc:		;auto: CODE_80988A. 93G findpc (logic93_5): when and where will the puck cross each goal line
	stx.b xsave		; $80988A: 86 0A
	ldx.w #$0000		; $80988C: A2 00 00
.push:
	lda.b d0,x		; $80988F: B5 53
	pha		; $809891: 48
	inx		; $809892: E8
	inx		; $809893: E8
	cpx.w #$0014		; $809894: E0 14 00
	bne .push		; $809897: D0 F6
	ldx.b xsave		; $809899: A6 0A
	lda.w #blueline+goalline		; $80989B: A9 08 01  top goal line (blueline+goalline)
	sta.b d4		; $80989E: 85 63
	ldy.w #$0000		; $8098A0: A0 00 00
	jsl.l findpc_calc		; $8098A3: 22 C2 98 80
	lda.w #-(blueline+goalline)		; $8098A7: A9 F8 FE  bottom goal line
	sta.b d4		; $8098AA: 85 63
	ldy.w #$0004		; $8098AC: A0 04 00
	jsl.l findpc_calc		; $8098AF: 22 C2 98 80
	stx.b xsave		; $8098B3: 86 0A
	ldx.w #$0012		; $8098B5: A2 12 00
.pop:
	pla		; $8098B8: 68
	sta.b d0,x		; $8098B9: 95 53
	dex		; $8098BB: CA
	dex		; $8098BC: CA
	bpl .pop		; $8098BD: 10 F9
	ldx.b xsave		; $8098BF: A6 0A
	rtl		; $8098C1: 6B
findpc_calc:		;auto: CODE_8098C2. 93G findpc .calc: d4 = goal line y, Y = puckcross entry offset
	lda.b d4		; $8098C2: A5 63  d0 = line - pucky
	sec		; $8098C4: 38
	sbc.w pucky		; $8098C5: ED 7B 09
	sta.b d0		; $8098C8: 85 53
	lda.w puckvy		; $8098CA: AD 1B 0B
	bne .div		; $8098CD: D0 03
	jmp.w .nocross		; $8098CF: 4C 65 99
.div:
	sta.b mula		; $8098D2: 85 7D
	lda.b d0		; $8098D4: A5 53  mulb = d0 << 12 (93G swap/asr #4)
	stz.b mulb		; $8098D6: 64 83
	lsr a		; $8098D8: 4A
	ror.b mulb		; $8098D9: 66 83
	lsr a		; $8098DB: 4A
	ror.b mulb		; $8098DC: 66 83
	lsr a		; $8098DE: 4A
	ror.b mulb		; $8098DF: 66 83
	lsr a		; $8098E1: 4A
	ror.b mulb		; $8098E2: 66 83
	bit.w #$0800		; $8098E4: 89 00 08
	beq .hi		; $8098E7: F0 03
	ora.w #$F000		; $8098E9: 09 00 F0
.hi:
	sta.b mulb+2		; $8098EC: 85 85
	jsl.l divs		; $8098EE: 22 6C 99 80
	bpl .time		; $8098F2: 10 03
	jmp.w .nocross		; $8098F4: 4C 65 99
.time:
	sta.w puckcross+2,y		; $8098F7: 99 8B 04  frames until crossing
	lda.w puckvx		; $8098FA: AD FB 0A
	sta.b mula		; $8098FD: 85 7D
	lda.b d0		; $8098FF: A5 53
	sta.b mulb		; $809901: 85 83
	jsl.l $82FCDB		; $809903: 22 DB FC 82  x offset = puckvx*d0/puckvy, if it fits, bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.w puckvy		; $809907: AD 1B 0B
	bit.w #$8000		; $80990A: 89 00 80
	beq .vy		; $80990D: F0 04
	eor.w #$FFFF		; $80990F: 49 FF FF
	inc a		; $809912: 1A
.vy:
	sta.b mula		; $809913: 85 7D
	lda.b mulres+2		; $809915: A5 95
	bit.w #$8000		; $809917: 89 00 80
	beq .ov		; $80991A: F0 04
	eor.w #$FFFF		; $80991C: 49 FF FF
	inc a		; $80991F: 1A
.ov:
	cmp.b mula		; $809920: C5 7D
	bcs .nocross		; $809922: B0 41
	lda.w puckvy		; $809924: AD 1B 0B
	sta.b mula		; $809927: 85 7D
	jsl.l divs		; $809929: 22 6C 99 80
	adc.w puckx		; $80992D: 6D 1B 09
	sta.b d0		; $809930: 85 53
	sec		; $809932: 38
	sbc.w #$0088		; $809933: E9 88 00  sideline $88
	bmi .v1		; $809936: 30 04
	bvc .o1		; $809938: 50 04
	bra .o1b		; $80993A: 80 0A
.v1:
	bvc .o1b		; $80993C: 50 08
.o1:		;bounce off the right side boards
	lda.w #$0198		; $80993E: A9 98 01  3*$88 - x
	sec		; $809941: 38
	sbc.b d0		; $809942: E5 53
	sta.b d0		; $809944: 85 53
.o1b:
	lda.b d0		; $809946: A5 53
	sec		; $809948: 38
	sbc.w #$FF78		; $809949: E9 78 FF
	beq .o2		; $80994C: F0 08
	bmi .v2		; $80994E: 30 04
	bvs .o2		; $809950: 70 04
	bra .o2b		; $809952: 80 0A
.v2:
	bvs .o2b		; $809954: 70 08
.o2:		;bounce off the left side boards
	lda.w #$FE68		; $809956: A9 68 FE  -3*$88 - x
	sec		; $809959: 38
	sbc.b d0		; $80995A: E5 53
	sta.b d0		; $80995C: 85 53
.o2b:
	lda.b d0		; $80995E: A5 53
	sta.w puckcross,y		; $809960: 99 89 04
	bra .rtl		; $809963: 80 06
.nocross:
	lda.w #$FFFF		; $809965: A9 FF FF
	sta.w puckcross+2,y		; $809968: 99 8B 04
.rtl:
	rtl		; $80996B: 6B
divs:		;auto: CODE_80996C. 68k divs: A = mulres = mulb (32-bit) / mula, signed 16-bit quotient. C clear
	stz.b mulsign		; $80996C: 64 81  mulsign = number of negative operands
	lda.b mula		; $80996E: A5 7D
	bpl .apos		; $809970: 10 06
	eor.w #$FFFF		; $809972: 49 FF FF
	inc a		; $809975: 1A
	inc.b mulsign		; $809976: E6 81
.apos:
	sta.b mula+2		; $809978: 85 7F
	stz.b mula		; $80997A: 64 7D
	lda.w #$0010		; $80997C: A9 10 00  16 quotient bits
	sta.b mulcnt		; $80997F: 85 87
	lda.b mulb+2		; $809981: A5 85
	bpl .loop		; $809983: 10 11
	lda.w #$0000		; $809985: A9 00 00
	sec		; $809988: 38
	sbc.b mulb		; $809989: E5 83
	sta.b mulb		; $80998B: 85 83
	lda.w #$0000		; $80998D: A9 00 00
	sbc.b mulb+2		; $809990: E5 85
	sta.b mulb+2		; $809992: 85 85
	inc.b mulsign		; $809994: E6 81
.loop:
	lsr.b mula+2		; $809996: 46 7F
	ror.b mula		; $809998: 66 7D
	asl.b mulres		; $80999A: 06 93
	lda.b mulb		; $80999C: A5 83
	cmp.b mula		; $80999E: C5 7D
	lda.b mulb+2		; $8099A0: A5 85
	sbc.b mula+2		; $8099A2: E5 7F
	bcc .next		; $8099A4: 90 0E
	lda.b mulb		; $8099A6: A5 83
	sbc.b mula		; $8099A8: E5 7D
	sta.b mulb		; $8099AA: 85 83
	lda.b mulb+2		; $8099AC: A5 85
	sbc.b mula+2		; $8099AE: E5 7F
	sta.b mulb+2		; $8099B0: 85 85
	inc.b mulres		; $8099B2: E6 93
.next:
	dec.b mulcnt		; $8099B4: C6 87
	bne .loop		; $8099B6: D0 DE
	lsr.b mulsign		; $8099B8: 46 81
	bcc .rtl		; $8099BA: 90 07
	lda.w #$0000		; $8099BC: A9 00 00
	sbc.b mulres		; $8099BF: E5 93
	sta.b mulres		; $8099C1: 85 93
.rtl:
	lda.b mulres		; $8099C3: A5 93
	clc		; $8099C5: 18
	rtl		; $8099C6: 6B
a2touchpuck:		;auto: CODE_8099C7. 93G a2touchpuck (logic93_5): player a2 touches the puck: last touch, offsides, icing
	ldy.b a2		; $8099C7: A4 3B
	lda.w Xpos,y		; $8099C9: B9 FF 08
	sta.w ltx		; $8099CC: 8D 8D 01  ltx/lty/ltplayer
	lda.w Ypos,y		; $8099CF: B9 5F 09
	sta.w lty		; $8099D2: 8D 8F 01
	tya		; $8099D5: 98
	lsr a		; $8099D6: 4A
	sta.w ltplayer		; $8099D7: 8D 8B 01
	stz.b a0		; $8099DA: 64 33  a0 = team
	lda.w pfteam,y		; $8099DC: B9 9F 11
	beq .t		; $8099DF: F0 04
	inc.b a0		; $8099E1: E6 33
	inc.b a0		; $8099E3: E6 33
.t:
	lda.w pnum,y		; $8099E5: B9 1F 0F
	sta.b d0		; $8099E8: 85 53
	ldy.b a0		; $8099EA: A4 33
	cmp.w tmtouch1,y		; $8099EC: D9 E2 13  same player as the last touch: no change
	beq .same		; $8099EF: F0 2C
	lda.w tmflags,y		; $8099F1: B9 0A 14
	bit.w #tmflast		; $8099F4: 89 04 00  tmflast: overwrite the last touch only
	beq .shift		; $8099F7: F0 08
	and.w #~tmflast&$FFFF		; $8099F9: 29 FB FF
	sta.w tmflags,y		; $8099FC: 99 0A 14
	bra .st		; $8099FF: 80 0C
.shift:		;shift the touch list down
	lda.w tmtouch2,y		; $809A01: B9 E6 13
	sta.w tmtouch3,y		; $809A04: 99 EA 13
	lda.w tmtouch1,y		; $809A07: B9 E2 13
	sta.w tmtouch2,y		; $809A0A: 99 E6 13
.st:
	lda.b d0		; $809A0D: A5 53
	sta.w tmtouch1,y		; $809A0F: 99 E2 13
	cmp.w tmtouch3,y		; $809A12: D9 EA 13  also the third touch: drop it
	bne .same		; $809A15: D0 06
	lda.w #$FFFF		; $809A17: A9 FF FF
	sta.w tmtouch3,y		; $809A1A: 99 EA 13
.same:
	lda.w #sf2shot		; $809A1D: A9 00 10  sf2shot
	trb.w sflags		; $809A20: 1C 8C 12
	jsl.l a2offsides		; $809A23: 22 A8 9A 80
	ldy.b a2		; $809A27: A4 3B
	lda.w iflags		; $809A29: AD 5C 01  ifok and ifcgl and a skater: icing
	bit.w #ifok		; $809A2C: 89 04 00
	beq .notice		; $809A2F: F0 34
	bit.w #ifcgl		; $809A31: 89 01 00
	beq .notice		; $809A34: F0 2F
	lda.w position,y		; $809A36: B9 9F 0B
	beq .notice		; $809A39: F0 2A
	lda.w iflags		; $809A3B: AD 5C 01
	bit.w #ifdir		; $809A3E: 89 02 00
	bne .up		; $809A41: D0 1D
	lda.w pfgoal,y		; $809A43: B9 3F 11
	beq .notice		; $809A46: F0 1D
.icing:		;auto: CODE_809A48. 93G a2touchpuck .icing: icing on icingPlayer
	phx		; $809A48: DA
	lda.w iflags+1		; $809A49: AD 5D 01  X = icingPlayer
	and.w #$00FF		; $809A4C: 29 FF 00
	asl a		; $809A4F: 0A
	sta.b a3		; $809A50: 85 3F
	tax		; $809A52: AA
	lda.w #PenIcing		; $809A53: A9 0C 00  PenIcing
	sta.b d0		; $809A56: 85 53
	jsl.l $80C18F		; $809A58: 22 8F C1 80  AddPenalty, AddPenalty (d0 = penalty, X = player)
	plx		; $809A5C: FA
	stx.b a3		; $809A5D: 86 3F
.rtl:		;auto: CODE_809A5F
	rtl		; $809A5F: 6B
.up:
	lda.w pfgoal,y		; $809A60: B9 3F 11
	beq .icing		; $809A63: F0 E3
.notice:		;auto: CODE_809A65. 93G a2touchpuck .notice: start a new icing watch for player a2
	tya		; $809A65: 98
	lsr a		; $809A66: 4A
	xba		; $809A67: EB
	sta.w iflags		; $809A68: 8D 5C 01  iflags = 0, icingPlayer = a2
	lda.w pucky		; $809A6B: AD 7B 09
	sta.b d0		; $809A6E: 85 53
	lda.w pfgoal,y		; $809A70: B9 3F 11
	beq .zero		; $809A73: F0 0E
	lda.w #ifdir		; $809A75: A9 02 00  ifdir
	tsb.w iflags		; $809A78: 0C 5C 01
	lda.b d0		; $809A7B: A5 53
	eor.w #$FFFF		; $809A7D: 49 FF FF
	inc a		; $809A80: 1A
	sta.b d0		; $809A81: 85 53
.zero:
	lda.b d0		; $809A83: A5 53
	bmi .rtl		; $809A85: 30 D8
	lda.w tmap		; $809A87: AD EE 13  own team not short-handed?
	sec		; $809A8A: 38
	sbc.w tmap+2		; $809A8B: ED F0 13
	sta.b d0		; $809A8E: 85 53
	lda.w pfteam,y		; $809A90: B9 9F 11
	beq .men		; $809A93: F0 08
	lda.b d0		; $809A95: A5 53
	eor.w #$FFFF		; $809A97: 49 FF FF
	inc a		; $809A9A: 1A
	sta.b d0		; $809A9B: 85 53
.men:
	lda.b d0		; $809A9D: A5 53
	bmi .rtl		; $809A9F: 30 BE
	lda.w #ifok		; $809AA1: A9 04 00  ifok
	tsb.w iflags		; $809AA4: 0C 5C 01
	rtl		; $809AA7: 6B
a2offsides:		;auto: CODE_809AA8. 93G a2offsides (logic93_5): player a2 touched the puck: offsides if his team is flagged and the puck is past the blue line
	ldy.b a2		; $809AA8: A4 3B
	lda.w gmode		; $809AAA: AD 88 12
	bit.w #gmoffs		; $809AAD: 89 20 00
	beq .rtl		; $809AB0: F0 57
	lda.w pucky		; $809AB2: AD 7B 09
	sta.b d0		; $809AB5: 85 53
	lda.w pfgoal,y		; $809AB7: B9 3F 11
	bne .p0		; $809ABA: D0 08
	lda.b d0		; $809ABC: A5 53
	eor.w #$FFFF		; $809ABE: 49 FF FF
	inc a		; $809AC1: 1A
	sta.b d0		; $809AC2: 85 53
.p0:
	lda.b d0		; $809AC4: A5 53
	sec		; $809AC6: 38
	sbc.w #blueline		; $809AC7: E9 58 00  blueline
	bmi .v1		; $809ACA: 30 04
	bvc .team		; $809ACC: 50 04
	bra .rtl		; $809ACE: 80 39
.v1:
	bvc .rtl		; $809AD0: 50 37
.team:
	stz.b a0		; $809AD2: 64 33
	lda.w pfteam,y		; $809AD4: B9 9F 11
	beq .t1		; $809AD7: F0 05
	lda.w #$0002		; $809AD9: A9 02 00
	sta.b a0		; $809ADC: 85 33
.t1:
	ldy.b a0		; $809ADE: A4 33
	lda.w tmflags,y		; $809AE0: B9 0A 14
	bit.w #tmfoffside		; $809AE3: 89 10 00  team flagged offsides
	beq .rtl		; $809AE6: F0 21
	lda.w gmode		; $809AE8: AD 88 12
	bit.w #gmhl		; $809AEB: 89 10 00  gmhl
	bne .rtl		; $809AEE: D0 19
	ldx.b a2		; $809AF0: A6 3B  exg a2,a3
	ldy.b a3		; $809AF2: A4 3F
	stx.b a3		; $809AF4: 86 3F
	sty.b a2		; $809AF6: 84 3B
	lda.w #PenOffsides		; $809AF8: A9 10 00  PenOffsides
	sta.b d0		; $809AFB: 85 53
	jsl.l $80C18F		; $809AFD: 22 8F C1 80  AddPenalty, AddPenalty (d0 = penalty, X = player)
	ldx.b a2		; $809B01: A6 3B
	ldy.b a3		; $809B03: A4 3F
	stx.b a3		; $809B05: 86 3F
	sty.b a2		; $809B07: 84 3B
.rtl:
	rtl		; $809B09: 6B
GetHot:		;auto: CODE_809B0A. 93G GetHot (logic93_5): A = object index; d0/d1 = its hot spot x/y from HotList ($84EF3C, a byte pair per frame)
	phx		; $809B0A: DA
	tay		; $809B0B: A8
	stz.b d0		; $809B0C: 64 53
	stz.b d1		; $809B0E: 64 57
	lda.w frame,y		; $809B10: B9 3F 09
	cmp.w #$0179		; $809B13: C9 79 01  the SNES frame list skips 6 frames from $179
	bcc .remap		; $809B16: 90 03
	sbc.w #$0006		; $809B18: E9 06 00
.remap:
	cmp.w #$0226		; $809B1B: C9 26 02  frames 1-$225 have hot spots
	bcs .ex		; $809B1E: B0 58
	dec a		; $809B20: 3A
	bmi .ex		; $809B21: 30 55
	asl a		; $809B23: 0A
	tax		; $809B24: AA
	lda.l $84EF3C,x		; $809B25: BF 3C EF 84  HotList x (bank $84)
	and.w #$00FF		; $809B29: 29 FF 00
	bit.w #$0080		; $809B2C: 89 80 00
	beq .hx		; $809B2F: F0 03
	ora.w #$FF00		; $809B31: 09 00 FF
.hx:
	sta.b d0		; $809B34: 85 53
	lda.l $84EF3C+1,x		; $809B36: BF 3D EF 84  HotList y
	and.w #$00FF		; $809B3A: 29 FF 00
	bit.w #$0080		; $809B3D: 89 80 00
	beq .hy		; $809B40: F0 03
	ora.w #$FF00		; $809B42: 09 00 FF
.hy:
	sta.b d1		; $809B45: 85 57
	lda.w attribute,y		; $809B47: B9 DF 09
	bit.w #attrxflip		; $809B4A: 89 00 08  x flip
	beq .nox		; $809B4D: F0 08
	lda.b d0		; $809B4F: A5 53
	eor.w #$FFFF		; $809B51: 49 FF FF
	inc a		; $809B54: 1A
	sta.b d0		; $809B55: 85 53
.nox:
	lda.w attribute,y		; $809B57: B9 DF 09
	bit.w #attryflip		; $809B5A: 89 00 10  y flip (clear = negate)
	bne .noy		; $809B5D: D0 08
	lda.b d1		; $809B5F: A5 57
	eor.w #$FFFF		; $809B61: 49 FF FF
	inc a		; $809B64: 1A
	sta.b d1		; $809B65: 85 57
.noy:
	lda.w sfhormode		; $809B67: AD 8E 12  horizontal mode: rotate
	beq .ex		; $809B6A: F0 0C
	lda.b d0		; $809B6C: A5 53
	ldy.b d1		; $809B6E: A4 57
	eor.w #$FFFF		; $809B70: 49 FF FF
	inc a		; $809B73: 1A
	sta.b d1		; $809B74: 85 57
	sty.b d0		; $809B76: 84 53
.ex:
	plx		; $809B78: FA
	rtl		; $809B79: 6B
puckIChk:		;auto: CODE_809B7A. 93G puckIChk (logic93_5): check for icing. Called from pucknorm
	lda.w iflags		; $809B7A: AD 5C 01
	bit.w #ifok		; $809B7D: 89 04 00  ifok and not ifcgl, puck loose
	beq .rtl		; $809B80: F0 28
	bit.w #ifcgl		; $809B82: 89 01 00
	bne .rtl		; $809B85: D0 23
	lda.w puckc		; $809B87: AD BB 0E
	bpl .rtl		; $809B8A: 10 1E
	lda.w #blueline+goalline		; $809B8C: A9 08 01  blueline+goalline
	sta.b d0		; $809B8F: 85 53
	lda.w iflags		; $809B91: AD 5C 01
	bit.w #ifdir		; $809B94: 89 02 00
	bne .up		; $809B97: D0 12
	lda.w #-(blueline+goalline)		; $809B99: A9 F8 FE
	sec		; $809B9C: 38
	sbc.w pucky		; $809B9D: ED 7B 09
	beq .rtl		; $809BA0: F0 08
	bmi .v1		; $809BA2: 30 04
	bvs .rtl		; $809BA4: 70 04
	bra .set		; $809BA6: 80 14
.v1:
	bvs .set		; $809BA8: 70 12
.rtl:
	rtl		; $809BAA: 6B
.up:
	lda.w #blueline+goalline		; $809BAB: A9 08 01
	sec		; $809BAE: 38
	sbc.w pucky		; $809BAF: ED 7B 09
	beq .set		; $809BB2: F0 08
	bmi .v2		; $809BB4: 30 04
	bvs .set		; $809BB6: 70 04
	bra .rtl		; $809BB8: 80 F0
.v2:
	bvs .rtl		; $809BBA: 70 EE
.set:
	lda.w #ifcgl		; $809BBC: A9 01 00  ifcgl
	tsb.w iflags		; $809BBF: 0C 5C 01
	rtl		; $809BC2: 6B
ChkOffsides:		;auto: CODE_809BC3. 93G ChkOffsides (logic93_5): flag a team offsides when the puck crosses its blue line. Called from pucknorm
	lda.w gmode		; $809BC3: AD 88 12
	bit.w #gmoffs		; $809BC6: 89 20 00
	beq .rtl		; $809BC9: F0 7B
	stz.b a1		; $809BCB: 64 37  a1 = home, a2 = away; then swapped
	lda.w #$0002		; $809BCD: A9 02 00
	sta.b a2		; $809BD0: 85 3B
	jsl.l ClearOffsidesIfAllPlayers		; $809BD2: 22 C2 9C 80
	stz.b a2		; $809BD6: 64 3B
	lda.w #$0002		; $809BD8: A9 02 00
	sta.b a1		; $809BDB: 85 37
	jsl.l ClearOffsidesIfAllPlayers		; $809BDD: 22 C2 9C 80
	lda.w #blueline-4		; $809BE1: A9 54 00  blueline-4
	sta.b d0		; $809BE4: 85 53
	sec		; $809BE6: 38
	sbc.w pucky		; $809BE7: ED 7B 09
	beq .top		; $809BEA: F0 08
	bmi .v1		; $809BEC: 30 04
	bvs .top		; $809BEE: 70 04
	bra .neg		; $809BF0: 80 5E
.v1:
	bvs .neg		; $809BF2: 70 5C
.top:		;puck crossed the top line this frame?
	lda.w #blueline-4		; $809BF4: A9 54 00
	sec		; $809BF7: 38
	sbc.w OldYpos+puckobj		; $809BF8: ED 7B 0A
	beq .rtl		; $809BFB: F0 49
	bmi .v2		; $809BFD: 30 04
	bvc .t		; $809BFF: 50 04
	bra .rtl		; $809C01: 80 43
.v2:
	bvc .rtl		; $809C03: 50 41
.t:
	lda.w #blueline-4+$A		; $809C05: A9 5E 00  +$A
	sta.b d0		; $809C08: 85 53
	lda.w gmode		; $809C0A: AD 88 12
	bit.w #gmdir		; $809C0D: 89 02 00  gmdir
	beq .t0		; $809C10: F0 08
	lda.b a2		; $809C12: A5 3B
	ldy.b a1		; $809C14: A4 37
	sta.b a1		; $809C16: 85 37
	sty.b a2		; $809C18: 84 3B
.t0:
	lda.w #$0005		; $809C1A: A9 05 00
	sta.b d2		; $809C1D: 85 5B
	ldy.b a2		; $809C1F: A4 3B
	lda.w tmsort,y		; $809C21: B9 D2 13
	sta.b a0		; $809C24: 85 33
.l0:
	ldy.b a0		; $809C26: A4 33
	lda.w position,y		; $809C28: B9 9F 0B
	bmi .n0		; $809C2B: 30 1A
	lda.b d0		; $809C2D: A5 53
	sec		; $809C2F: 38
	sbc.w Ypos,y		; $809C30: F9 5F 09
	bmi .v3		; $809C33: 30 04
	bvs .set0		; $809C35: 70 04
	bra .n0		; $809C37: 80 0E
.v3:
	bvs .n0		; $809C39: 70 0C
.set0:
	ldy.b a2		; $809C3B: A4 3B
	lda.w tmflags,y		; $809C3D: B9 0A 14
	ora.w #tmfoffside		; $809C40: 09 10 00  tmfoffside
	sta.w tmflags,y		; $809C43: 99 0A 14
.rtl:		;auto: CODE_809C46 (also the exit of ClearOffsidesIfAllPlayers)
	rtl		; $809C46: 6B
.n0:
	inc.b a0		; $809C47: E6 33
	inc.b a0		; $809C49: E6 33
	dec.b d2		; $809C4B: C6 5B
	bpl .l0		; $809C4D: 10 D7
	rtl		; $809C4F: 6B
.neg:		;bottom line
	lda.b d0		; $809C50: A5 53
	eor.w #$FFFF		; $809C52: 49 FF FF
	inc a		; $809C55: 1A
	sta.b d0		; $809C56: 85 53
	sec		; $809C58: 38
	sbc.w pucky		; $809C59: ED 7B 09
	bmi .v4		; $809C5C: 30 04
	bvc .b1		; $809C5E: 50 04
	bra .rtl		; $809C60: 80 E4
.v4:
	bvc .rtl		; $809C62: 50 E2
.b1:
	lda.b d0		; $809C64: A5 53
	sec		; $809C66: 38
	sbc.w OldYpos+puckobj		; $809C67: ED 7B 0A
	bmi .v5		; $809C6A: 30 04
	bvs .t1		; $809C6C: 70 04
	bra .rtl		; $809C6E: 80 D6
.v5:
	bvs .rtl		; $809C70: 70 D4
.t1:
	lda.b d0		; $809C72: A5 53
	sec		; $809C74: 38
	sbc.w #$000A		; $809C75: E9 0A 00  -$A
	sta.b d0		; $809C78: 85 53
	lda.w gmode		; $809C7A: AD 88 12
	bit.w #gmdir		; $809C7D: 89 02 00
	bne .t2		; $809C80: D0 08
	lda.b a2		; $809C82: A5 3B
	ldy.b a1		; $809C84: A4 37
	sta.b a1		; $809C86: 85 37
	sty.b a2		; $809C88: 84 3B
.t2:
	lda.w #$0005		; $809C8A: A9 05 00
	sta.b d2		; $809C8D: 85 5B
	ldy.b a2		; $809C8F: A4 3B
	lda.w tmsort,y		; $809C91: B9 D2 13
	sta.b a0		; $809C94: 85 33
.l2:
	ldy.b a0		; $809C96: A4 33
	lda.w position,y		; $809C98: B9 9F 0B
	bmi .n2		; $809C9B: 30 1C
	lda.b d0		; $809C9D: A5 53
	sec		; $809C9F: 38
	sbc.w Ypos,y		; $809CA0: F9 5F 09
	beq .n2		; $809CA3: F0 14
	bmi .v6		; $809CA5: 30 04
	bvc .set2		; $809CA7: 50 04
	bra .n2		; $809CA9: 80 0E
.v6:
	bvc .n2		; $809CAB: 50 0C
.set2:
	ldy.b a2		; $809CAD: A4 3B
	lda.w tmflags,y		; $809CAF: B9 0A 14
	ora.w #tmfoffside		; $809CB2: 09 10 00
	sta.w tmflags,y		; $809CB5: 99 0A 14
	rtl		; $809CB8: 6B
.n2:
	inc.b a0		; $809CB9: E6 33
	inc.b a0		; $809CBB: E6 33
	dec.b d2		; $809CBD: C6 5B
	bpl .l2		; $809CBF: 10 D5
	rtl		; $809CC1: 6B
ClearOffsidesIfAllPlayers:		;auto: CODE_809CC2. 93G ClearOffsidesIfAllPlayers (logic93_5): a2 = team; clear tmfoffside once no skater is past the blue line
	ldy.b a2		; $809CC2: A4 3B
	lda.w tmflags,y		; $809CC4: B9 0A 14  tmfoffside
	bit.w #tmfoffside		; $809CC7: 89 10 00
	bne .go		; $809CCA: D0 03
	jmp.w ChkOffsides_rtl		; $809CCC: 4C 46 9C
.go:
	lda.w tmsort,y		; $809CCF: B9 D2 13
	sta.b a0		; $809CD2: 85 33
	lda.w #$0005		; $809CD4: A9 05 00
	sta.b d1		; $809CD7: 85 57
.top:
	ldy.b a0		; $809CD9: A4 33
	lda.w position,y		; $809CDB: B9 9F 0B
	bmi .next		; $809CDE: 30 12
	lda.w Ypos,y		; $809CE0: B9 5F 09
	sta.b d0		; $809CE3: 85 53
	lda.w pfgoal,y		; $809CE5: B9 3F 11
	bne .next		; $809CE8: D0 08
	lda.b d0		; $809CEA: A5 53
	eor.w #$FFFF		; $809CEC: 49 FF FF
	inc a		; $809CEF: 1A
	sta.b d0		; $809CF0: 85 53
.next:
	inc.b a0		; $809CF2: E6 33
	inc.b a0		; $809CF4: E6 33
	lda.b d0		; $809CF6: A5 53
	sec		; $809CF8: 38
	sbc.w #blueline		; $809CF9: E9 58 00
	beq .more		; $809CFC: F0 09
	bmi .v1		; $809CFE: 30 05
	bvs .more		; $809D00: 70 05
.rtl:
	jmp.w ChkOffsides_rtl		; $809D02: 4C 46 9C
.v1:
	bvs .rtl		; $809D05: 70 FB
.more:
	dec.b d1		; $809D07: C6 57
	bpl .top		; $809D09: 10 CE
	ldy.b a2		; $809D0B: A4 3B
	lda.w tmflags,y		; $809D0D: B9 0A 14
	and.w #~tmfoffside&$FFFF		; $809D10: 29 EF FF  clear tmfoffside
	sta.w tmflags,y		; $809D13: 99 0A 14
	rtl		; $809D16: 6B
checkpuckcoll:		;auto: CODE_809D17. 93G checkpuckcoll (hockey93_04): puck collision with the players within 22 in y (OOlist up and down from the puck)
	lda.w Zpos+puckobj		; $809D17: AD BB 09  puck feet in the air (Zpos > 16): no collision
	sec		; $809D1A: 38
	sbc.w #$0010		; $809D1B: E9 10 00
	beq .setup		; $809D1E: F0 08
	bmi .v1		; $809D20: 30 04
	bvs .setup		; $809D22: 70 04
	bra .rtl		; $809D24: 80 63
.v1:
	bvs .rtl		; $809D26: 70 61
.setup:
	lda.w OOlistpos+puckobj		; $809D28: AD 5B 12  Y = puck position in OOlist
	sta.b d1		; $809D2B: 85 57
.up:
	ldy.b d1		; $809D2D: A4 57
	cpy.w #$000F		; $809D2F: C0 0F 00  top object
	beq .cl		; $809D32: F0 26
	lda.w OOlist+1,y		; $809D34: B9 60 12
	and.w #$00FF		; $809D37: 29 FF 00
	sta.b d4		; $809D3A: 85 63
	tay		; $809D3C: A8
	lda.w Ylist,y		; $809D3D: B9 1F 12
	sec		; $809D40: 38
	sbc.w pucky		; $809D41: ED 7B 09
	sec		; $809D44: 38
	sbc.w #$0016		; $809D45: E9 16 00  next higher object within 22 in y
	beq .cc1		; $809D48: F0 08
	bmi .v2		; $809D4A: 30 04
	bvs .cc1		; $809D4C: 70 04
	bra .cl		; $809D4E: 80 0A
.v2:
	bvs .cl		; $809D50: 70 08
.cc1:
	jsl.l checkpuckcoll_ccx		; $809D52: 22 8A 9D 80
	inc.b d1		; $809D56: E6 57
	bra .up		; $809D58: 80 D3
.cl:
	lda.w OOlistpos+puckobj		; $809D5A: AD 5B 12
	beq .rtl		; $809D5D: F0 2A
	sta.b d1		; $809D5F: 85 57
.dn:
	ldy.b d1		; $809D61: A4 57
	lda.w OOlist-1,y		; $809D63: B9 5E 12
	and.w #$00FF		; $809D66: 29 FF 00
	sta.b d4		; $809D69: 85 63
	tay		; $809D6B: A8
	lda.w pucky		; $809D6C: AD 7B 09
	sec		; $809D6F: 38
	sbc.w Ylist,y		; $809D70: F9 1F 12
	sec		; $809D73: 38
	sbc.w #$0016		; $809D74: E9 16 00
	beq .cc2		; $809D77: F0 08
	bmi .v3		; $809D79: 30 04
	bvs .cc2		; $809D7B: 70 04
	bra .rtl		; $809D7D: 80 0A
.v3:
	bvs .rtl		; $809D7F: 70 08
.cc2:
	jsl.l checkpuckcoll_ccx		; $809D81: 22 8A 9D 80
	dec.b d1		; $809D85: C6 57
	bne .dn		; $809D87: D0 D8
.rtl:
	rtl		; $809D89: 6B
checkpuckcoll_ccx:		;auto: CODE_809D8A. 93G checkpuckcoll .ccx: d4 = object index: stick (puckstick), body (puckbody) or goalie (puckgoalie) contact
	stx.b xsave		; $809D8A: 86 0A
	ldx.w #$0000		; $809D8C: A2 00 00
.push:
	lda.b d0,x		; $809D8F: B5 53
	pha		; $809D91: 48
	inx		; $809D92: E8
	inx		; $809D93: E8
	cpx.w #$001C		; $809D94: E0 1C 00
	bne .push		; $809D97: D0 F6
	ldx.b xsave		; $809D99: A6 0A
	lda.b d4		; $809D9B: A5 63  a2 = object
	sta.b a2		; $809D9D: 85 3B
	tay		; $809D9F: A8
	lsr a		; $809DA0: 4A
	cmp.w puckc		; $809DA1: CD BB 0E
	bne .pl		; $809DA4: D0 03
	jmp.w .exit		; $809DA6: 4C D2 9E
.pl:
	cmp.w #$000C		; $809DA9: C9 0C 00  not a player
	bcc .nc		; $809DAC: 90 03
	jmp.w .exit		; $809DAE: 4C D2 9E
.nc:
	lda.w pfnc,y		; $809DB1: B9 FF 11  no collision or nopuck
	ora.w nopuck,y		; $809DB4: 19 5F 0E
	beq .unav		; $809DB7: F0 03
	jmp.w .exit		; $809DB9: 4C D2 9E
.unav:
	lda.w pflags,y		; $809DBC: B9 DF 0E
	bit.w #pf2unav		; $809DBF: 89 00 10  pf2unav: body only
	beq .z		; $809DC2: F0 03
	jmp.w .chkbody		; $809DC4: 4C 6B 9E
.z:
	lda.w Zpos+puckobj		; $809DC7: AD BB 09
	sec		; $809DCA: 38
	sbc.w #$0005		; $809DCB: E9 05 00  puck above 5
	beq .zv		; $809DCE: F0 09
	bmi .v1		; $809DD0: 30 05
	bvs .zv		; $809DD2: 70 05
.body1:
	jmp.w .chkbody		; $809DD4: 4C 6B 9E
.v1:
	bvs .body1		; $809DD7: 70 FB
.zv:
	lda.w puckvz		; $809DD9: AD 3B 0B
	sec		; $809DDC: 38
	sbc.w #$0100		; $809DDD: E9 00 01  puckvz > $100
	beq .stick		; $809DE0: F0 09
	bmi .v2		; $809DE2: 30 05
	bvs .stick		; $809DE4: 70 05
.body2:
	jmp.w .chkbody		; $809DE6: 4C 6B 9E
.v2:
	bvs .body2		; $809DE9: 70 FB
.stick:
	tya		; $809DEB: 98
	jsl.l GetHot		; $809DEC: 22 0A 9B 80
	ldy.b a2		; $809DF0: A4 3B
	lda.b d0		; $809DF2: A5 53
	clc		; $809DF4: 18
	adc.w Xpos,y		; $809DF5: 79 FF 08
	sec		; $809DF8: 38
	sbc.w puckx		; $809DF9: ED 1B 09
	sta.b d0		; $809DFC: 85 53
	bit.w #$8000		; $809DFE: 89 00 80
	beq .sx		; $809E01: F0 04
	eor.w #$FFFF		; $809E03: 49 FF FF
	inc a		; $809E06: 1A
.sx:
	cmp.w #$000F		; $809E07: C9 0F 00  stick: within 14
	bcs .chkbody		; $809E0A: B0 5F
	lda.b d1		; $809E0C: A5 57
	clc		; $809E0E: 18
	adc.w Ypos,y		; $809E0F: 79 5F 09
	sec		; $809E12: 38
	sbc.w pucky		; $809E13: ED 7B 09
	sta.b d1		; $809E16: 85 57
	bit.w #$8000		; $809E18: 89 00 80
	beq .sy		; $809E1B: F0 04
	eor.w #$FFFF		; $809E1D: 49 FF FF
	inc a		; $809E20: 1A
.sy:
	cmp.w #$000F		; $809E21: C9 0F 00
	bcs .chkbody		; $809E24: B0 45
	lda.b d0		; $809E26: A5 53
	sta.b mula		; $809E28: 85 7D
	sta.b mulb		; $809E2A: 85 83
	jsl.l $82FCDB		; $809E2C: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $809E30: 85 53
	lda.b mulres+2		; $809E32: A5 95
	sta.b d0+2		; $809E34: 85 55
	lda.b d1		; $809E36: A5 57
	sta.b mula		; $809E38: 85 7D
	sta.b mulb		; $809E3A: 85 83
	jsl.l $82FCDB		; $809E3C: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $809E40: 65 53
	sta.b d0		; $809E42: 85 53
	lda.b d0+2		; $809E44: A5 55
	adc.b mulres+2		; $809E46: 65 95
	sta.b d0+2		; $809E48: 85 55
	lda.w #$00C4		; $809E4A: A9 C4 00  cstick^2 ($C4), /4 if the puck is not ready to be caught
	sta.b d1		; $809E4D: 85 57
	lda.w nopuck+puckobj		; $809E4F: AD 7B 0E
	bmi .lo		; $809E52: 30 06
	beq .lo		; $809E54: F0 04
	lsr.b d1		; $809E56: 46 57
	lsr.b d1		; $809E58: 46 57
.lo:
	lda.b d1		; $809E5A: A5 57
	cmp.b d0		; $809E5C: C5 53
	lda.w #$0000		; $809E5E: A9 00 00
	sbc.b d0+2		; $809E61: E5 55
	bcc .chkbody		; $809E63: 90 06
	jsl.l puckstick		; $809E65: 22 15 9F 80
	bra .exit		; $809E69: 80 67
.chkbody:
	lda.w position,y		; $809E6B: B9 9F 0B
	beq .chkgoalie		; $809E6E: F0 71
	lda.w Xpos,y		; $809E70: B9 FF 08
	sec		; $809E73: 38
	sbc.w puckx		; $809E74: ED 1B 09
	sta.b d0		; $809E77: 85 53
	bit.w #$8000		; $809E79: 89 00 80
	beq .bx		; $809E7C: F0 04
	eor.w #$FFFF		; $809E7E: 49 FF FF
	inc a		; $809E81: 1A
.bx:
	cmp.w #$0009		; $809E82: C9 09 00  body: within 8
	bcs .exit		; $809E85: B0 4B
	lda.w Ypos,y		; $809E87: B9 5F 09
	sec		; $809E8A: 38
	sbc.w pucky		; $809E8B: ED 7B 09
	sta.b d1		; $809E8E: 85 57
	bit.w #$8000		; $809E90: 89 00 80
	beq .by		; $809E93: F0 04
	eor.w #$FFFF		; $809E95: 49 FF FF
	inc a		; $809E98: 1A
.by:
	cmp.w #$0009		; $809E99: C9 09 00
	bcs .exit		; $809E9C: B0 34
	lda.b d0		; $809E9E: A5 53
	sta.b mula		; $809EA0: 85 7D
	sta.b mulb		; $809EA2: 85 83
	jsl.l $82FCDB		; $809EA4: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $809EA8: 85 53
	lda.b mulres+2		; $809EAA: A5 95
	sta.b d0+2		; $809EAC: 85 55
	lda.b d1		; $809EAE: A5 57
	sta.b mula		; $809EB0: 85 7D
	sta.b mulb		; $809EB2: 85 83
	jsl.l $82FCDB		; $809EB4: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $809EB8: 65 53
	sta.b d0		; $809EBA: 85 53
	lda.b d0+2		; $809EBC: A5 55
	adc.b mulres+2		; $809EBE: 65 95
	sta.b d0+2		; $809EC0: 85 55
	lda.b d0		; $809EC2: A5 53
	cmp.w #$0041		; $809EC4: C9 41 00  cbody^2
	lda.b d0+2		; $809EC7: A5 55
	sbc.w #$0000		; $809EC9: E9 00 00
	bcs .exit		; $809ECC: B0 04
	jsl.l $80A21A		; $809ECE: 22 1A A2 80  puckbody
.exit:
	stx.b xsave		; $809ED2: 86 0A
	ldx.w #$001A		; $809ED4: A2 1A 00
.pop:
	pla		; $809ED7: 68
	sta.b d0,x		; $809ED8: 95 53
	dex		; $809EDA: CA
	dex		; $809EDB: CA
	bpl .pop		; $809EDC: 10 F9
	ldx.b xsave		; $809EDE: A6 0A
	rtl		; $809EE0: 6B
.chkgoalie:
	lda.w Xpos,y		; $809EE1: B9 FF 08
	sec		; $809EE4: 38
	sbc.w puckx		; $809EE5: ED 1B 09
	sta.b d0		; $809EE8: 85 53
	bit.w #$8000		; $809EEA: 89 00 80
	beq .gx		; $809EED: F0 04
	eor.w #$FFFF		; $809EEF: 49 FF FF
	inc a		; $809EF2: 1A
.gx:
	cmp.w #$000D		; $809EF3: C9 0D 00  goalie: within 12
	bcs .exit		; $809EF6: B0 DA
	lda.w Ypos,y		; $809EF8: B9 5F 09
	sec		; $809EFB: 38
	sbc.w pucky		; $809EFC: ED 7B 09
	sta.b d1		; $809EFF: 85 57
	bit.w #$8000		; $809F01: 89 00 80
	beq .gy		; $809F04: F0 04
	eor.w #$FFFF		; $809F06: 49 FF FF
	inc a		; $809F09: 1A
.gy:
	cmp.w #$000D		; $809F0A: C9 0D 00
	bcs .exit		; $809F0D: B0 C3
	jsl.l $80A2FA		; $809F0F: 22 FA A2 80  puckgoalie
	bra .exit		; $809F13: 80 BD
puckstick:		;auto: CODE_809F15. 93G puckstick (hockey93_05): puck hits the stick of player a2. d0 = distance^2 (from checkpuckcoll_ccx)
	ldy.b a2		; $809F15: A4 3B
	lda.w position,y		; $809F17: B9 9F 0B
	bne .p0		; $809F1A: D0 0B
	lda.w gmode		; $809F1C: AD 88 12
	bit.w #gmhl		; $809F1F: 89 10 00  gmhl: goalie ignores the puck
	beq .p0		; $809F22: F0 03
	jmp.w .rtl		; $809F24: 4C 06 A0
.p0:
	lda.w pflags,y		; $809F27: B9 DF 0E
	and.w #~pfdoff&$FFFF		; $809F2A: 29 FE FF  clear pfdoff
	sta.w pflags,y		; $809F2D: 99 DF 0E
	lda.w puckc		; $809F30: AD BB 0E
	bpl .carried		; $809F33: 10 03
	jmp.w .nosteal		; $809F35: 4C 07 A0
.carried:
	asl a		; $809F38: 0A
	sta.b a0		; $809F39: 85 33
	tay		; $809F3B: A8
	lda.w pfteam,y		; $809F3C: B9 9F 11
	beq .t1		; $809F3F: F0 03
	lda.w #$0001		; $809F41: A9 01 00
.t1:
	sta.b tmp0		; $809F44: 85 73
	ldy.b a2		; $809F46: A4 3B
	lda.w pfteam,y		; $809F48: B9 9F 11
	beq .t2		; $809F4B: F0 03
	lda.w #$0001		; $809F4D: A9 01 00
.t2:
	eor.b tmp0		; $809F50: 45 73
	bne .range		; $809F52: D0 03
	jmp.w .rtl		; $809F54: 4C 06 A0
.range:
	lda.b d0		; $809F57: A5 53
	cmp.w #$0025		; $809F59: C9 25 00  6*6: smaller range for stealing
	lda.b d0+2		; $809F5C: A5 55
	sbc.w #$0000		; $809F5E: E9 00 00
	bcc .roll		; $809F61: 90 03
	jmp.w .rtl		; $809F63: 4C 06 A0
.roll:		;steal roll: carrier stickhand - stealer stickhand + 36
	lda.w position,y		; $809F66: B9 9F 0B
	beq .steal		; $809F69: F0 40  goalie always steals
	ldy.b a0		; $809F6B: A4 33
	lda.w position,y		; $809F6D: B9 9F 0B
	bne .rnd		; $809F70: D0 03
	jmp.w .rtl		; $809F72: 4C 06 A0
.rnd:
	lda.w stickhand,y		; $809F75: B9 7F 10
	sta.b d0		; $809F78: 85 53
	jsl.l $80A1B4		; $809F7A: 22 B4 A1 80  makepde: d0 = rating d0 scaled by the energy of player a0
	lda.b d0		; $809F7E: A5 53
	pha		; $809F80: 48
	lda.b a0		; $809F81: A5 33
	ldy.b a2		; $809F83: A4 3B
	sta.b a2		; $809F85: 85 3B
	sty.b a0		; $809F87: 84 33
	lda.w stickhand,y		; $809F89: B9 7F 10
	sta.b d0		; $809F8C: 85 53
	jsl.l $80A1B4		; $809F8E: 22 B4 A1 80  makepde: d0 = rating d0 scaled by the energy of player a0
	lda.b a0		; $809F92: A5 33
	ldy.b a2		; $809F94: A4 3B
	sta.b a2		; $809F96: 85 3B
	sty.b a0		; $809F98: 84 33
	pla		; $809F9A: 68
	sec		; $809F9B: 38
	sbc.b d0		; $809F9C: E5 53
	clc		; $809F9E: 18
	adc.w #$0024		; $809F9F: 69 24 00
	jsl.l $80AE8B		; $809FA2: 22 8B AE 80  randoma: A = random 0..A-1
	cmp.w #$0003		; $809FA6: C9 03 00  steal fails
	bcs .rtl		; $809FA9: B0 5B
.steal:
	ldy.b a0		; $809FAB: A4 33
	lda.w stickhand,y		; $809FAD: B9 7F 10
	sta.b d0		; $809FB0: 85 53
	jsl.l $80A1B4		; $809FB2: 22 B4 A1 80  makepde: d0 = rating d0 scaled by the energy of player a0
	lda.b d0		; $809FB6: A5 53
	clc		; $809FB8: 18
	adc.w #$0014		; $809FB9: 69 14 00  nopuck = makepde(stickhand) + 20 for both
	ldy.b a0		; $809FBC: A4 33
	sta.w nopuck,y		; $809FBE: 99 5F 0E
	lda.b a0		; $809FC1: A5 33
	ldy.b a2		; $809FC3: A4 3B
	sta.b a2		; $809FC5: 85 3B
	sty.b a0		; $809FC7: 84 33
	lda.w stickhand,y		; $809FC9: B9 7F 10
	sta.b d0		; $809FCC: 85 53
	jsl.l $80A1B4		; $809FCE: 22 B4 A1 80  makepde: d0 = rating d0 scaled by the energy of player a0
	lda.b d0		; $809FD2: A5 53
	clc		; $809FD4: 18
	adc.w #$0014		; $809FD5: 69 14 00
	ldy.b a0		; $809FD8: A4 33
	sta.w nopuck,y		; $809FDA: 99 5F 0E
	lda.b a0		; $809FDD: A5 33
	ldy.b a2		; $809FDF: A4 3B
	sta.b a2		; $809FE1: 85 3B
	sty.b a0		; $809FE3: 84 33
	tya		; $809FE5: 98
	lsr a		; $809FE6: 4A
	sta.w lastplayer		; $809FE7: 8D 7D 01  lastplayer = the old carrier
	lda.w #sfspdir|sfssdir		; $809FEA: A9 0C 00  clear sfspdir/sfssdir
	trb.w sflags		; $809FED: 1C 8C 12
.stdef:		;stick deflect sound, touch, deflect
	lda.w seed+1		; $809FF0: AD A2 04  stick deflect sound (one of 4)
	and.w #$0003		; $809FF3: 29 03 00
	clc		; $809FF6: 18
	adc.w #SFXshotwiff		; $809FF7: 69 98 00
	pha		; $809FFA: 48
	jsl.l $80C28B		; $809FFB: 22 8B C2 80  sfx (sound number pushed)
	jsl.l a2touchpuck		; $809FFF: 22 C7 99 80
	jmp.w $A121		; $80A003: 4C 21 A1  deflect, deflect
.rtl:
	rtl		; $80A006: 6B
.nosteal:
	ldy.b a2		; $80A007: A4 3B
	lda.w position,y		; $80A009: B9 9F 0B
	bne .spd		; $80A00C: D0 0C
	lda.b d0		; $80A00E: A5 53
	cmp.w #$0041		; $80A010: C9 41 00  goalie: loose puck within 8
	lda.b d0+2		; $80A013: A5 55
	sbc.w #$0000		; $80A015: E9 00 00
	bcs .rtl		; $80A018: B0 EC
.spd:		;catch if the puck speed^2 <= (13000+700*stickhand)^2
	lda.w puckvx		; $80A01A: AD FB 0A
	sta.b mula		; $80A01D: 85 7D
	sta.b mulb		; $80A01F: 85 83
	jsl.l $82FCDB		; $80A021: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $80A025: 85 53
	lda.b mulres+2		; $80A027: A5 95
	sta.b d0+2		; $80A029: 85 55
	lda.w puckvy		; $80A02B: AD 1B 0B
	sta.b mula		; $80A02E: 85 7D
	sta.b mulb		; $80A030: 85 83
	jsl.l $82FCDB		; $80A032: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $80A036: 65 53
	sta.b d0		; $80A038: 85 53
	lda.b d0+2		; $80A03A: A5 55
	adc.b mulres+2		; $80A03C: 65 95
	sta.b d0+2		; $80A03E: 85 55
	stz.b d1		; $80A040: 64 57
	lda.w sflags		; $80A042: AD 8C 12  sf2shot: no stickhand bonus
	bit.w #sf2shot		; $80A045: 89 00 10
	bne .nohand		; $80A048: D0 12
	ldy.b a2		; $80A04A: A4 3B
	lda.w stickhand,y		; $80A04C: B9 7F 10
	sta.b mulb		; $80A04F: 85 83
	lda.w #$02BC		; $80A051: A9 BC 02  * 700
	sta.b mula		; $80A054: 85 7D
	jsl.l $8D871C		; $80A056: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	sta.b d1		; $80A05A: 85 57
.nohand:
	lda.b d1		; $80A05C: A5 57
	clc		; $80A05E: 18
	adc.w #$32C8		; $80A05F: 69 C8 32  + 13000
	sta.b mula		; $80A062: 85 7D
	sta.b mulb		; $80A064: 85 83
	jsl.l $888942		; $80A066: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	cmp.b d0		; $80A06A: C5 53
	lda.b mulres+2		; $80A06C: A5 95
	sbc.b d0+2		; $80A06E: E5 55
	bcs puckglue		; $80A070: B0 0B
	ldy.b a2		; $80A072: A4 3B
	lda.w #$0008		; $80A074: A9 08 00  too fast: nopuck 8, deflect
	sta.w nopuck,y		; $80A077: 99 5F 0E
	jmp.w .stdef		; $80A07A: 4C F0 9F
puckglue:		;auto: CODE_80A07D. 93G puckglue (hockey93_05 IDA loc_10F8A): player a2 takes the puck. Falls into setd0player (bank $8D)
	lda.w seed+2		; $80A07D: AD A3 04  pickup sound (one of 4)
	and.w #$0003		; $80A080: 29 03 00
	clc		; $80A083: 18
	adc.w #SFXshotwiff		; $80A084: 69 98 00
	pha		; $80A087: 48
	jsl.l $80C28B		; $80A088: 22 8B C2 80  sfx (sound number pushed)
	ldy.b a2		; $80A08C: A4 3B
	tya		; $80A08E: 98
	lsr a		; $80A08F: 4A
	sta.w puckc		; $80A090: 8D BB 0E  puckc = a2
	sta.b d0		; $80A093: 85 53
	stz.b a0		; $80A095: 64 33
	lda.w #$0002		; $80A097: A9 02 00
	sta.b a1		; $80A09A: 85 37
	lda.w pfteam,y		; $80A09C: B9 9F 11
	bne .tm		; $80A09F: D0 07
	stz.b a1		; $80A0A1: 64 37
	lda.w #$0002		; $80A0A3: A9 02 00
	sta.b a0		; $80A0A6: 85 33
.tm:
	ldy.b a0		; $80A0A8: A4 33
	lda.w #$FFFF		; $80A0AA: A9 FF FF
	sta.w tmtouch2,y		; $80A0AD: 99 E6 13  other team loses its touches
	sta.w tmtouch3,y		; $80A0B0: 99 EA 13
	lda.w tmflags,y		; $80A0B3: B9 0A 14
	ora.w #tmflast		; $80A0B6: 09 04 00
	sta.w tmflags,y		; $80A0B9: 99 0A 14
	lda.w #sf3fo		; $80A0BC: A9 10 00
	trb.w sflags3		; $80A0BF: 1C 90 12  sf3fo: this pickup wins the faceoff
	beq .snd		; $80A0C2: F0 11
	ldy.b a1		; $80A0C4: A4 37
	lda.w tmfowon,y		; $80A0C6: B9 DA 13
	inc a		; $80A0C9: 1A
	sta.w tmfowon,y		; $80A0CA: 99 DA 13
	lda.b crowdlevel		; $80A0CD: A5 DE  +200
	clc		; $80A0CF: 18
	adc.w #$00C8		; $80A0D0: 69 C8 00
	sta.b crowdlevel		; $80A0D3: 85 DE
.snd:
	lda.b a2		; $80A0D5: A5 3B
	lsr a		; $80A0D7: 4A
	sta.b d0		; $80A0D8: 85 53
	cmp.w passReceiverPlayerNum		; $80A0DA: CD 3F 04  pass reached its receiver
	bne .nrec		; $80A0DD: D0 09
	ldy.b a1		; $80A0DF: A4 37
	lda.w tmpasscomp,y		; $80A0E1: B9 06 14
	inc a		; $80A0E4: 1A
	sta.w tmpasscomp,y		; $80A0E5: 99 06 14
.nrec:
	lda.w #$FFFF		; $80A0E8: A9 FF FF
	sta.w passReceiverPlayerNum		; $80A0EB: 8D 3F 04
	lda.w #sfspdir|sfssdir		; $80A0EE: A9 0C 00  clear sfspdir/sfssdir
	trb.w sflags		; $80A0F1: 1C 8C 12
	ldy.b a2		; $80A0F4: A4 3B
	lda.w position,y		; $80A0F6: B9 9F 0B
	beq .goalie		; $80A0F9: F0 04
	jml.l $8D87FB		; $80A0FB: 5C FB 87 8D  bank $8D: 93G setd0player
.goalie:
	jsl.l $80D12E		; $80A0FF: 22 2E D1 80  ChkShotStat (goalie made a save), ChkShotStat
	ldy.b a2		; $80A103: A4 3B
	lda.w #$008C		; $80A105: A9 8C 00  temp5 = 140, count down for the faceoff
	sta.w temp5,y		; $80A108: 99 DF 0C
	lda.w SPA,y		; $80A10B: B9 FF 0D
	cmp.w #SPAg314		; $80A10E: C9 90 14
	beq .g314		; $80A111: F0 04
	jml.l $8D87FB		; $80A113: 5C FB 87 8D  bank $8D: 93G setd0player
.g314:
	lda.w #$0005		; $80A117: A9 05 00
	sta.w temp5,y		; $80A11A: 99 DF 0C
	jml.l $8D87FB		; $80A11D: 5C FB 87 8D  bank $8D: 93G setd0player
