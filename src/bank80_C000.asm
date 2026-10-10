; $80C18F-$80CEE6  ROM $0418F-$04EE6: AddPenalty/AddPenalty2 (penalty93_1), freezewindow, sfx, updatereplay, demoread and the joypad
; readers (hockey93_01/middle93_1), updateplayers (hockey93_02), checkcoll, checkwallcoll, wallcollb, wallcoll (hockey93_03/04),
; sroot, divu, puckflip.
org $80C18F
AddPenalty:		;auto: CODE_80C18F. 93G AddPenalty (penalty93_1): add penalty d0 (PenaltyList offset) for player X. Ignored while the clock is stopped, when penalties are off, or offsides when offsides are off. Falls into AddPenalty2
	lda.w gmclock		; $80C18F: AD 8A 12  clock stopped
	bne .rtl		; $80C192: D0 1B
	lda.b d0		; $80C194: A5 53
	cmp.w #PenIcing		; $80C196: C9 0C 00  icing always counts
	beq AddPenalty2		; $80C199: F0 15
	lda.w OptPen		; $80C19B: AD 0A 16  penalties off
	beq .rtl		; $80C19E: F0 0F
	lda.w gmode		; $80C1A0: AD 88 12
	bit.w #gmoffs		; $80C1A3: 89 20 00  offsides on: all count
	bne AddPenalty2		; $80C1A6: D0 08
	lda.b d0		; $80C1A8: A5 53
	cmp.w #PenOffsides		; $80C1AA: C9 10 00  offsides off: no offsides penalty
	bne AddPenalty2		; $80C1AD: D0 01
.rtl:
	rtl		; $80C1AF: 6B
AddPenalty2:		;auto: CODE_80C1B0. 93G AddPenalty2 (penalty93_1): forced penalties like face off and game over. d0 = penalty, X = player or a player of the penalized team
	lda.w sfhormode		; $80C1B0: AD 8E 12  horizontal rink: none
	beq .go		; $80C1B3: F0 03
	jmp.w .rtl		; $80C1B5: 4C 77 C2
.go:
	stx.b xsave		; $80C1B8: 86 0A
	ldx.w #$0000		; $80C1BA: A2 00 00
.pushd:
	lda.b d1,x		; $80C1BD: B5 57
	pha		; $80C1BF: 48
	inx		; $80C1C0: E8
	inx		; $80C1C1: E8
	cpx.w #$0004		; $80C1C2: E0 04 00
	bne .pushd		; $80C1C5: D0 F6
	ldx.b xsave		; $80C1C7: A6 0A
	stx.b xsave		; $80C1C9: 86 0A
	ldx.w #$0000		; $80C1CB: A2 00 00
.pusha:
	lda.b a0,x		; $80C1CE: B5 33
	pha		; $80C1D0: 48
	inx		; $80C1D1: E8
	inx		; $80C1D2: E8
	cpx.w #$0008		; $80C1D3: E0 08 00
	bne .pusha		; $80C1D6: D0 F6
	ldx.b xsave		; $80C1D8: A6 0A
	lda.b d0		; $80C1DA: A5 53
	sec		; $80C1DC: 38
	sbc.w #$000E		; $80C1DD: E9 0E 00  goal (93G $E) and up
	bmi .v1		; $80C1E0: 30 04
	bvc .snd		; $80C1E2: 50 04
	bra .nosnd		; $80C1E4: 80 1C
.v1:
	bvc .nosnd		; $80C1E6: 50 1A
.snd:		;goal and up: crowd and a sound
	lda.b crowdlevel		; $80C1E8: A5 DE  crowd +200
	clc		; $80C1EA: 18
	adc.w #$00C8		; $80C1EB: 69 C8 00
	sta.b crowdlevel		; $80C1EE: 85 DE
	lda.w #SFXcrowdboo		; $80C1F0: A9 8B 00  home penalized: boo; visitors: cheer
	pha		; $80C1F3: 48
	lda.w pfteam,x		; $80C1F4: BD 9F 11
	beq .sfx		; $80C1F7: F0 05
	lda.w #SFXcrowdcheer		; $80C1F9: A9 8A 00
	sta.b $01,s		; $80C1FC: 83 01
.sfx:
	jsl.l sfx		; $80C1FE: 22 8B C2 80
.nosnd:
	lda.w #PenBuf		; $80C202: A9 9E 12  a1 = PenBuf, 32 slots
	sta.b a1		; $80C205: 85 37
	lda.w #PenBuf>>16		; $80C207: A9 00 00
	sta.b a1+2		; $80C20A: 85 39
	lda.w #$001F		; $80C20C: A9 1F 00
	sta.b d1		; $80C20F: 85 57
.find:		;find a free PenBuf slot
	lda.b [a1]		; $80C211: A7 37
	inc.b a1		; $80C213: E6 37
	inc.b a1		; $80C215: E6 37
	tay		; $80C217: A8
	beq .put		; $80C218: F0 06
	dec.b d1		; $80C21A: C6 57
	bpl .find		; $80C21C: 10 F3
	bra .noplayer		; $80C21E: 80 3B
.put:
	dec.b a1		; $80C220: C6 37
	dec.b a1		; $80C222: C6 37
	txa		; $80C224: 8A  store (SCnum << 8) | penalty
	lsr a		; $80C225: 4A
	xba		; $80C226: EB
	and.w #$FF00		; $80C227: 29 00 FF
	ora.b d0		; $80C22A: 05 53
	sta.b [a1]		; $80C22C: 87 37
	lda.w #PenaltyList>>16		; $80C22E: A9 80 00  a0 = PenaltyList + [d0]
	sta.b a0+2		; $80C231: 85 35
	lda.w #PenaltyList		; $80C233: A9 6A BF
	sta.b a0		; $80C236: 85 33
	ldy.b d0		; $80C238: A4 53
	clc		; $80C23A: 18
	adc.b [a0],y		; $80C23B: 77 33
	sta.b a0		; $80C23D: 85 33
	lda.b [a0]		; $80C23F: A7 33  penalty minutes
	and.w #$00FF		; $80C241: 29 FF 00
	beq .noplayer		; $80C244: F0 15
	lda.w pflags,x		; $80C246: BD DF 0E
	pha		; $80C249: 48
	ora.w #pf2pen		; $80C24A: 09 00 40  pf2pen; already set: drop this one
	sta.w pflags,x		; $80C24D: 9D DF 0E
	pla		; $80C250: 68
	bit.w #pf2pen		; $80C251: 89 00 40
	beq .noplayer		; $80C254: F0 05
	lda.w #$0000		; $80C256: A9 00 00
	sta.b [a1]		; $80C259: 87 37
.noplayer:
	stx.b xsave		; $80C25B: 86 0A
	ldx.w #$0006		; $80C25D: A2 06 00
.popa:
	pla		; $80C260: 68
	sta.b a0,x		; $80C261: 95 33
	dex		; $80C263: CA
	dex		; $80C264: CA
	bpl .popa		; $80C265: 10 F9
	ldx.b xsave		; $80C267: A6 0A
	stx.b xsave		; $80C269: 86 0A
	ldx.w #$0002		; $80C26B: A2 02 00
.popd:
	pla		; $80C26E: 68
	sta.b d1,x		; $80C26F: 95 57
	dex		; $80C271: CA
	dex		; $80C272: CA
	bpl .popd		; $80C273: 10 F9
	ldx.b xsave		; $80C275: A6 0A
.rtl:
	rtl		; $80C277: 6B
freezewindow:		;auto: CODE_80C278. 93G freezewindow (hockey93_02): lock scrolling at the current position
	lda.w Vpos		; $80C278: AD DF 08  yc1 = Vpos, xc1 = Hpos, sfslock
	sta.w yc1		; $80C27B: 8D F7 08
	lda.w Hpos		; $80C27E: AD 54 01
	sta.w xc1		; $80C281: 8D F5 08
	lda.w #sfslock		; $80C284: A9 40 00
	tsb.w sflags		; $80C287: 0C 8C 12
	rtl		; $80C28A: 6B
sfx:		;auto: CODE_80C28B. 93G sfx (middle93_1): play the sound number pushed before the jsl (it is pulled here). Dropped within 180 frames of sfxmutetime; remembered in lastsfx
	pla		; $80C28B: 68  return address +1 into jmlvector
	inc a		; $80C28C: 1A
	sta.w jmlvector+1		; $80C28D: 8D 79 01
	sep #$20		; $80C290: E2 20
	pla		; $80C292: 68
	sta.w jmlvector+3		; $80C293: 8D 7B 01
	rep #$20		; $80C296: C2 20
	lda.b vcount		; $80C298: A5 00  sound effects muted?
	sec		; $80C29A: 38
	sbc.w sfxmutetime		; $80C29B: ED A7 04
	cmp.w #$00B4		; $80C29E: C9 B4 00
	bcc .drop		; $80C2A1: 90 0E
	pla		; $80C2A3: 68  lastsfx = sound number
	sta.w lastsfx		; $80C2A4: 8D 7F 01
	beq .ret		; $80C2A7: F0 04
	jsl.l $82FB79		; $80C2A9: 22 79 FB 82  queue it (bank $82), bank $82: queue sound A
.ret:		;return through jmlvector
	jml.l $000178		; $80C2AD: 5C 78 01 00  jmlvector
.drop:
	pla		; $80C2B1: 68
	bra .ret		; $80C2B2: 80 F9
updatereplay:		;auto: CODE_80C2B4. 93G updatereplay (hockey93_02): save this frame into the replay buffer (positions, frames, players, puck, sound, pads, crowd, gloves, box, scroll)
	lda.w gmode		; $80C2B4: AD 88 12
	bit.w #gmhl		; $80C2B7: 89 10 00  gmhl: no recording
	beq .rec		; $80C2BA: F0 03
	jmp.w .rtl		; $80C2BC: 4C D3 C3
.rec:
	lda.w sflags		; $80C2BF: AD 8C 12
	bit.w #sf2drec		; $80C2C2: 89 00 04  sf2drec: keep overwriting the same frame
	bne .save		; $80C2C5: D0 2E
	lda.w ReplayBufferPtr		; $80C2C7: AD 95 04  next record (113 bytes)
	clc		; $80C2CA: 18
	adc.w #$0071		; $80C2CB: 69 71 00
	sta.w ReplayBufferPtr		; $80C2CE: 8D 95 04
	bcc .wrap		; $80C2D1: 90 03
	inc.w ReplayBufferPtr+2		; $80C2D3: EE 97 04
.wrap:
	cmp.w #$FF41		; $80C2D6: C9 41 FF
	bne .save		; $80C2D9: D0 1A
	lda.w ReplayBufferPtr+2		; $80C2DB: AD 97 04
	cmp.w #$007E		; $80C2DE: C9 7E 00
	bne .save		; $80C2E1: D0 12
	lda.w #sfwrap		; $80C2E3: A9 10 00  wrapped: sfwrap, back to the start
	tsb.w sflags		; $80C2E6: 0C 8C 12
	lda.w #$8174		; $80C2E9: A9 74 81
	sta.w ReplayBufferPtr		; $80C2EC: 8D 95 04
	lda.w #$007E		; $80C2EF: A9 7E 00
	sta.w ReplayBufferPtr+2		; $80C2F2: 8D 97 04
.save:
	lda.w ReplayBufferPtr		; $80C2F5: AD 95 04
	sta.b a0		; $80C2F8: 85 33
	lda.w ReplayBufferPtr+2		; $80C2FA: AD 97 04
	sta.b a0+2		; $80C2FD: 85 35
	lda.w #$000F		; $80C2FF: A9 0F 00
	sta.b d2		; $80C302: 85 5B
	ldx.w #$0000		; $80C304: A2 00 00
	ldy.w #$0001		; $80C307: A0 01 00
.obj:		;16 objects: x (12 bits) and y (12 bits), frame and flip bits
	lda.w #$0000		; $80C30A: A9 00 00
	sta.b [a0]		; $80C30D: 87 33
	sta.b [a0],y		; $80C30F: 97 33
	lda.w Xpos,x		; $80C311: BD FF 08
	and.w #$0FFF		; $80C314: 29 FF 0F
	sta.b [a0]		; $80C317: 87 33
	inc.b a0		; $80C319: E6 33
	lda.w Ypos,x		; $80C31B: BD 5F 09
	asl a		; $80C31E: 0A
	asl a		; $80C31F: 0A
	asl a		; $80C320: 0A
	asl a		; $80C321: 0A
	ora.b [a0]		; $80C322: 07 33
	sta.b [a0]		; $80C324: 87 33
	inc.b a0		; $80C326: E6 33
	inc.b a0		; $80C328: E6 33
	lda.w frame,x		; $80C32A: BD 3F 09
	and.w #$3FFF		; $80C32D: 29 FF 3F
	sta.b [a0]		; $80C330: 87 33
	lda.w attribute,x		; $80C332: BD DF 09
	and.w #$1800		; $80C335: 29 00 18
	asl a		; $80C338: 0A
	asl a		; $80C339: 0A
	asl a		; $80C33A: 0A
	ora.b [a0]		; $80C33B: 07 33
	sta.b [a0]		; $80C33D: 87 33
	inc.b a0		; $80C33F: E6 33
	inc.b a0		; $80C341: E6 33
	inx		; $80C343: E8
	inx		; $80C344: E8
	dec.b d2		; $80C345: C6 5B
	bpl .obj		; $80C347: 10 C1
	lda.w #$0005		; $80C349: A9 05 00
	sta.b d2		; $80C34C: 85 5B
	ldx.w #$0000		; $80C34E: A2 00 00
.pl:		;6 pairs: rostnum, positions
	lda.w rostnum,x		; $80C351: BD 3F 10
	sta.b [a0]		; $80C354: 87 33
	inc.b a0		; $80C356: E6 33
	lda.w rostnum+2,x		; $80C358: BD 41 10
	sta.b [a0]		; $80C35B: 87 33
	inc.b a0		; $80C35D: E6 33
	lda.w position,x		; $80C35F: BD 9F 0B
	bpl .p1		; $80C362: 10 03
	lda.w #$FFFF		; $80C364: A9 FF FF
.p1:
	and.w #$000F		; $80C367: 29 0F 00
	sta.b [a0]		; $80C36A: 87 33
	lda.w position+2,x		; $80C36C: BD A1 0B
	bpl .p2		; $80C36F: 10 03
	lda.w #$FFFF		; $80C371: A9 FF FF
.p2:
	asl a		; $80C374: 0A
	asl a		; $80C375: 0A
	asl a		; $80C376: 0A
	asl a		; $80C377: 0A
	ora.b [a0]		; $80C378: 07 33
	sta.b [a0]		; $80C37A: 87 33
	inc.b a0		; $80C37C: E6 33
	inx		; $80C37E: E8
	inx		; $80C37F: E8
	inx		; $80C380: E8
	inx		; $80C381: E8
	dec.b d2		; $80C382: C6 5B
	bpl .pl		; $80C384: 10 CB
	lda.w Zpos+puckobj		; $80C386: AD BB 09  puck and shadow height, lastsfx, d7, PadControlBits, crowdframe, glovecords, PBnum, Hpos, Vpos
	sta.b [a0]		; $80C389: 87 33
	inc.b a0		; $80C38B: E6 33
	lda.w Zpos+$1E		; $80C38D: AD BD 09
	sta.b [a0]		; $80C390: 87 33
	inc.b a0		; $80C392: E6 33
	lda.w lastsfx		; $80C394: AD 7F 01
	sta.b [a0]		; $80C397: 87 33
	inc.b a0		; $80C399: E6 33
	stz.w lastsfx		; $80C39B: 9C 7F 01
	lda.b d7		; $80C39E: A5 6F
	sta.b [a0]		; $80C3A0: 87 33
	inc.b a0		; $80C3A2: E6 33
	lda.w PadControlBits		; $80C3A4: AD 31 04
	sta.b [a0]		; $80C3A7: 87 33
	inc.b a0		; $80C3A9: E6 33
	inc.b a0		; $80C3AB: E6 33
	lda.b crowdframe		; $80C3AD: A5 DC
	sta.b [a0]		; $80C3AF: 87 33
	inc.b a0		; $80C3B1: E6 33
	inc.b a0		; $80C3B3: E6 33
	lda.w glovecords		; $80C3B5: AD 4E 01
	sta.b [a0]		; $80C3B8: 87 33
	inc.b a0		; $80C3BA: E6 33
	inc.b a0		; $80C3BC: E6 33
	lda.w PBnum		; $80C3BE: AD E4 12
	sta.b [a0]		; $80C3C1: 87 33
	inc.b a0		; $80C3C3: E6 33
	lda.w Hpos		; $80C3C5: AD 54 01
	sta.b [a0]		; $80C3C8: 87 33
	inc.b a0		; $80C3CA: E6 33
	inc.b a0		; $80C3CC: E6 33
	lda.w Vpos		; $80C3CE: AD DF 08
	sta.b [a0]		; $80C3D1: 87 33
.rtl:
	rtl		; $80C3D3: 6B
demoread:		;auto: CODE_80C3D4. 93G demoread (hockey93_01): in demo mode (no controller team), Start pauses and any other button ends the demo
	lda.w cont1team		; $80C3D4: AD 96 12  a controller team: not a demo
	ora.w cont2team		; $80C3D7: 0D 98 12
	bne .rtl		; $80C3DA: D0 26
	jsl.l Readjoy1		; $80C3DC: 22 0B C4 80
	lda.b d1		; $80C3E0: A5 57
	bit.w #JOYSTART		; $80C3E2: 89 00 10  Start on pad 1: startpause1
	beq .any1		; $80C3E5: F0 04
	jml.l $8F8E03		; $80C3E7: 5C 03 8E 8F  bank $8F: 93G startpause1
.any1:
	lda.b d1		; $80C3EB: A5 57
	bne .exit		; $80C3ED: D0 14
	jsl.l Readjoy2		; $80C3EF: 22 29 C4 80
	lda.b d1		; $80C3F3: A5 57
	bit.w #JOYSTART		; $80C3F5: 89 00 10  Start on pad 2: startpause2
	beq .any2		; $80C3F8: F0 04
	jml.l $82FDB5		; $80C3FA: 5C B5 FD 82  bank $82: 93G startpause2
.any2:
	lda.b d1		; $80C3FE: A5 57
	bne .exit		; $80C400: D0 01
.rtl:
	rtl		; $80C402: 6B
.exit:		;end the demo: back to the title screen (93G ExitToOpening)
	jsl.l $82FA1A		; $80C403: 22 1A FA 82  sound queue reset; on to the title screen, bank $82: reset the sound command queue
	jml.l $8B816A		; $80C407: 5C 6A 81 8B  bank $8B: on to the title screen (93G Opening)
Readjoy1:		;auto: CODE_80C40B. 93G Readjoy1 (middle93_1): read controller 1. d0 = direction, d1 = new presses, d2 = changed, d3 = held
	phx		; $80C40B: DA
	ldx.w #$0000		; $80C40C: A2 00 00
	jsl.l ReadJoy		; $80C40F: 22 47 C4 80
	plx		; $80C413: FA
	lda.w lj1		; $80C414: AD 85 01  d2 = changed, d3 = held, d1 = new presses
	sta.b d2		; $80C417: 85 5B
	lda.b d1		; $80C419: A5 57
	sta.w lj1		; $80C41B: 8D 85 01
	sta.b d3		; $80C41E: 85 5F
	eor.b d2		; $80C420: 45 5B
	sta.b d2		; $80C422: 85 5B
	and.b d1		; $80C424: 25 57
	sta.b d1		; $80C426: 85 57
	rtl		; $80C428: 6B
Readjoy2:		;auto: CODE_80C429. 93G Readjoy2 (middle93_1): read controller 2
	phx		; $80C429: DA
	ldx.w #$0002		; $80C42A: A2 02 00
	jsl.l ReadJoy		; $80C42D: 22 47 C4 80
	plx		; $80C431: FA
	lda.w lj2		; $80C432: AD 87 01
	sta.b d2		; $80C435: 85 5B
	lda.b d1		; $80C437: A5 57
	sta.w lj2		; $80C439: 8D 87 01
	sta.b d3		; $80C43C: 85 5F
	eor.b d2		; $80C43E: 45 5B
	sta.b d2		; $80C440: 85 5B
	and.b d1		; $80C442: 25 57
	sta.b d1		; $80C444: 85 57
	rtl		; $80C446: 6B
ReadJoy:		;auto: CODE_80C447. 93G ReadJoy (middle93_1): X = 0/2: d1 = buttons held, d0 = direction from jdtab
	lda.w joypad1,x		; $80C447: BD 5E 01  buttons
	sta.b d0+2		; $80C44A: 85 55
	sta.b d1		; $80C44C: 85 57
	xba		; $80C44E: EB  r/l/d/u bits
	and.w #$000F		; $80C44F: 29 0F 00
	tax		; $80C452: AA
	lda.l jdtab,x		; $80C453: BF 5D C4 80
	and.w #$00FF		; $80C457: 29 FF 00
	sta.b d0		; $80C45A: 85 53
	rtl		; $80C45C: 6B
jdtab:		;93G jdtab (middle93_1): convert buttons r,l,d,u into directions 0-7, 8
	db 8,2,6,8,4,3,5,8,0,1,7,8,8,8,8,8		; $80C45D
updateplayers:		;auto: CODE_80C46D. 93G updateplayers (hockey93_02): animation, velocity, position, input and the assignment for every sort object
	ldx.w #$0016		; $80C46D: A2 16 00  12 players
.spd:		;pspeed = max($1000, (|Xvel|+|Yvel|)*5/4) for the 12 players
	lda.w Xvel,x		; $80C470: BD DF 0A
	bit.w #$8000		; $80C473: 89 00 80
	beq .vx		; $80C476: F0 04
	eor.w #$FFFF		; $80C478: 49 FF FF
	inc a		; $80C47B: 1A
.vx:
	sta.b tmp0		; $80C47C: 85 73
	lda.w Yvel,x		; $80C47E: BD FF 0A
	bit.w #$8000		; $80C481: 89 00 80
	beq .vy		; $80C484: F0 04
	eor.w #$FFFF		; $80C486: 49 FF FF
	inc a		; $80C489: 1A
.vy:
	clc		; $80C48A: 18
	adc.b tmp0		; $80C48B: 65 73
	sta.b tmp0		; $80C48D: 85 73
	lsr a		; $80C48F: 4A
	lsr a		; $80C490: 4A
	adc.b tmp0		; $80C491: 65 73
	cmp.w #$1000		; $80C493: C9 00 10
	bcs .setspd		; $80C496: B0 03
	lda.w #$1000		; $80C498: A9 00 10
.setspd:
	sta.w pspeed,x		; $80C49B: 9D 6F 12
	dex		; $80C49E: CA
	dex		; $80C49F: CA
	bpl .spd		; $80C4A0: 10 CE
	lda.w sfhormode		; $80C4A2: AD 8E 12  vertical rink: PadControlBits |= $F
	bne .scload		; $80C4A5: D0 06
	lda.w #$000F		; $80C4A7: A9 0F 00
	tsb.w PadControlBits		; $80C4AA: 0C 31 04
.scload:
	ldx.w #$0000		; $80C4AD: A2 00 00
	stx.b a3		; $80C4B0: 86 3F
.top:		;each object: old position = position
	lda.w Xpos,x		; $80C4B2: BD FF 08
	sta.w OldXpos,x		; $80C4B5: 9D 1F 0A
	lda.w Xfrac,x		; $80C4B8: BD 1F 09
	sta.w OldXfrac,x		; $80C4BB: 9D 3F 0A
	lda.w Ypos,x		; $80C4BE: BD 5F 09
	sta.w OldYpos,x		; $80C4C1: 9D 5F 0A
	lda.w Yfrac,x		; $80C4C4: BD 7F 09
	sta.w OldYfrac,x		; $80C4C7: 9D 7F 0A
	lda.w Zpos,x		; $80C4CA: BD 9F 09
	sta.w OldZpos,x		; $80C4CD: 9D 9F 0A
	lda.w Zfrac,x		; $80C4D0: BD BF 09
	sta.w OldZfrac,x		; $80C4D3: 9D BF 0A
	lda.w position,x		; $80C4D6: BD 9F 0B  not on the ice
	bpl .onice		; $80C4D9: 10 03
	jmp.w .nf1		; $80C4DB: 4C 6A C7
.onice:
	jsl.l updateanim		; $80C4DE: 22 3E E1 80  updateanim
	lda.w nopuck,x		; $80C4E2: BD 5F 0E  nopuck, nopuckb count down
	sec		; $80C4E5: 38
	sbc.b d7		; $80C4E6: E5 6F
	bpl .np		; $80C4E8: 10 03
	lda.w #$0000		; $80C4EA: A9 00 00
.np:
	sta.w nopuck,x		; $80C4ED: 9D 5F 0E
	lda.w nopuckb,x		; $80C4F0: BD 7F 0E
	sec		; $80C4F3: 38
	sbc.b d7		; $80C4F4: E5 6F
	bpl .np2		; $80C4F6: 10 03
	lda.w #$0000		; $80C4F8: A9 00 00
.np2:
	sta.w nopuckb,x		; $80C4FB: 9D 7F 0E
	lda.w sflags3		; $80C4FE: AD 90 12  sflags3 bit 5: count frames on ice (loadTeamStruct)
	bit.w #sf3icetime		; $80C501: 89 20 00
	beq .vel		; $80C504: F0 1B
	lda.w pnum,x		; $80C506: BD 1F 0F
	and.w #$00FF		; $80C509: 29 FF 00
	bit.w #$0080		; $80C50C: 89 80 00
	beq .pn		; $80C50F: F0 03
	ora.w #$FF00		; $80C511: 09 00 FF
.pn:
	sta.b d0		; $80C514: 85 53
	cmp.w #$0000		; $80C516: C9 00 00
	bmi .vel		; $80C519: 30 06
	asl.b d0		; $80C51B: 06 53
	jsl.l $8FDBF9		; $80C51D: 22 F9 DB 8F  bank $8F: 93G loadTeamStruct
.vel:
	lda.w SPA,x		; $80C521: BD FF 0D
	cmp.w #SPAinjury1		; $80C524: C9 02 15  SPAinjury1: no movement
	bne .slow		; $80C527: D0 03
	jmp.w .done		; $80C529: 4C 47 C6
.slow:
	lda.w Zpos,x		; $80C52C: BD 9F 09  on the ice: decelerate
	bne .x2		; $80C52F: D0 4B
	ldx.b d7		; $80C531: A6 6F
.hang:		;d7 >= 10: hang
	cpx.w #$000A		; $80C533: E0 0A 00
	bcs .hang		; $80C536: B0 FB
	lda.l .decel-1,x		; $80C538: BF 75 C6 80  per-frame factor
	and.w #$00FF		; $80C53C: 29 FF 00
	sta.b d2		; $80C53F: 85 5B
	lda.l .decel2-1,x		; $80C541: BF 7F C6 80
	sta.b d2+2		; $80C545: 85 5D
	ldx.b a3		; $80C547: A6 3F
	lda.w pflags,x		; $80C549: BD DF 0E
	bit.w #pfdoff		; $80C54C: 89 01 00  pfdoff: less deceleration
	beq .off		; $80C54F: F0 07
	lda.b d2+2		; $80C551: A5 5D
	and.w #$00FF		; $80C553: 29 FF 00
	sta.b d2		; $80C556: 85 5B
.off:
	lda.w Xvel,x		; $80C558: BD DF 0A
	sta.b mula		; $80C55B: 85 7D
	lda.b d2		; $80C55D: A5 5B
	sta.b mulb		; $80C55F: 85 83
	jsl.l $82FCDB		; $80C561: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b mulres+1		; $80C565: A5 94  velocity = velocity * factor / 256
	sta.w Xvel,x		; $80C567: 9D DF 0A
	lda.w Yvel,x		; $80C56A: BD FF 0A
	sta.b mula		; $80C56D: 85 7D
	lda.b d2		; $80C56F: A5 5B
	sta.b mulb		; $80C571: 85 83
	jsl.l $82FCDB		; $80C573: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b mulres+1		; $80C577: A5 94
	sta.w Yvel,x		; $80C579: 9D FF 0A
.x2:		;Xpos += Xvel*velstep (/4 in horizontal mode except in the penalty box)
	lda.w Xvel,x		; $80C57C: BD DF 0A
	beq .y2		; $80C57F: F0 33
	sta.b mula		; $80C581: 85 7D
	lda.b velstep		; $80C583: A5 E4
	sta.b mulb		; $80C585: 85 83
	lda.w sfhormode		; $80C587: AD 8E 12
	beq .x3		; $80C58A: F0 16
	txa		; $80C58C: 8A
	asl a		; $80C58D: 0A
	asl a		; $80C58E: 0A
	adc.w assnum,x		; $80C58F: 7D BF 0B
	tay		; $80C592: A8
	lda.w asslist,y		; $80C593: B9 DF 0B
	and.w #$00FF		; $80C596: 29 FF 00
	cmp.w #apenalty		; $80C599: C9 0C 00  apenalty: full speed
	beq .x3		; $80C59C: F0 04
	lsr.b mulb		; $80C59E: 46 83
	lsr.b mulb		; $80C5A0: 46 83
.x3:
	jsl.l $82FCDB		; $80C5A2: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.w Xfrac,x		; $80C5A6: 7D 1F 09
	sta.w Xfrac,x		; $80C5A9: 9D 1F 09
	lda.w Xpos,x		; $80C5AC: BD FF 08
	adc.b mulres+2		; $80C5AF: 65 95
	sta.w Xpos,x		; $80C5B1: 9D FF 08
.y2:
	lda.w Yvel,x		; $80C5B4: BD FF 0A
	beq .z		; $80C5B7: F0 33
	sta.b mula		; $80C5B9: 85 7D
	lda.b velstep		; $80C5BB: A5 E4
	sta.b mulb		; $80C5BD: 85 83
	lda.w sfhormode		; $80C5BF: AD 8E 12
	beq .y3		; $80C5C2: F0 16
	txa		; $80C5C4: 8A
	asl a		; $80C5C5: 0A
	asl a		; $80C5C6: 0A
	adc.w assnum,x		; $80C5C7: 7D BF 0B
	tay		; $80C5CA: A8
	lda.w asslist,y		; $80C5CB: B9 DF 0B
	and.w #$00FF		; $80C5CE: 29 FF 00
	cmp.w #apenalty		; $80C5D1: C9 0C 00
	beq .y3		; $80C5D4: F0 04
	lsr.b mulb		; $80C5D6: 46 83
	lsr.b mulb		; $80C5D8: 46 83
.y3:
	jsl.l $82FCDB		; $80C5DA: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.w Yfrac,x		; $80C5DE: 7D 7F 09
	sta.w Yfrac,x		; $80C5E1: 9D 7F 09
	lda.w Ypos,x		; $80C5E4: BD 5F 09
	adc.b mulres+2		; $80C5E7: 65 95
	sta.w Ypos,x		; $80C5E9: 9D 5F 09
.z:		;height: gravity and the bounce off the ice
	lda.w Zpos,x		; $80C5EC: BD 9F 09
	bmi .done		; $80C5EF: 30 56
	bne .z1		; $80C5F1: D0 05
	lda.w Zvel,x		; $80C5F3: BD 1F 0B
	beq .done		; $80C5F6: F0 4F
.z1:
	lda.b velstep		; $80C5F8: A5 E4
	sta.b mula		; $80C5FA: 85 7D
	lda.w Zvel,x		; $80C5FC: BD 1F 0B  Zvel -= gravstep
	sec		; $80C5FF: 38
	sbc.b gravstep		; $80C600: E5 E6
	sta.w Zvel,x		; $80C602: 9D 1F 0B
	sta.b mulb		; $80C605: 85 83
	jsl.l $82FCDB		; $80C607: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.w Zfrac,x		; $80C60B: 7D BF 09
	sta.w Zfrac,x		; $80C60E: 9D BF 09
	lda.w Zpos,x		; $80C611: BD 9F 09
	adc.b mulres+2		; $80C614: 65 95
	sta.w Zpos,x		; $80C616: 9D 9F 09
	bpl .done		; $80C619: 10 2C
	stz.w Zpos,x		; $80C61B: 9E 9F 09  bounce off the ice: Zvel = -Zvel/2
	stz.w Zfrac,x		; $80C61E: 9E BF 09
	lda.w Zvel,x		; $80C621: BD 1F 0B
	eor.w #$FFFF		; $80C624: 49 FF FF
	inc a		; $80C627: 1A
	lsr a		; $80C628: 4A
	sta.w Zvel,x		; $80C629: 9D 1F 0B
	sec		; $80C62C: 38
	sbc.w #$0200		; $80C62D: E9 00 02  bounce sound when Zvel >= $200
	bmi .v1		; $80C630: 30 04
	bvc .bsnd		; $80C632: 50 04
	bra .done		; $80C634: 80 11
.v1:
	bvc .done		; $80C636: 50 0F
.bsnd:
	lda.w seed		; $80C638: AD A1 04
	and.w #$0003		; $80C63B: 29 03 00
	clc		; $80C63E: 18
	adc.w #SFXshotwiff		; $80C63F: 69 98 00
	pha		; $80C642: 48
	jsl.l sfx		; $80C643: 22 8B C2 80
.done:
	txa		; $80C647: 8A
	lsr a		; $80C648: 4A
	sta.b d6		; $80C649: 85 6B
	cmp.w puckc		; $80C64B: CD BB 0E  puck carrier (not fighting, vertical): setpads
	bne .tp		; $80C64E: D0 13
	lda.w pf2fight,x		; $80C650: BD 5F 11
	bne .tp		; $80C653: D0 0E
	lda.w sfhormode		; $80C655: AD 8E 12
	bne .tp		; $80C658: D0 09
	lda.w #-2		; $80C65A: A9 FE FF  d4 = -2: pad index of the puck carrier
	sta.b d4		; $80C65D: 85 63
	jsl.l setpads		; $80C65F: 22 E1 E0 80
.tp:
	lda.b d6		; $80C663: A5 6B
	cmp.w c1playernum		; $80C665: CD 92 12  controller 1 player: doinput
	bne .t0		; $80C668: D0 20
	jsl.l Readjoy1		; $80C66A: 22 0B C4 80
	stz.b d4		; $80C66E: 64 63
	jsl.l doinput		; $80C670: 22 3F DF 80
	bra .t1		; $80C674: 80 26
.decel:		;deceleration factor /256 per d7 (1-10): normal
	db $F7,$F5,$F2,$EF,$EC,$E9,$E6,$E3,$E1,$DE		; $80C676
.decel2:		;with pfdoff
	db $FF,$FF,$FE,$FE,$FE,$FD,$FD,$FD,$FC,$FC		; $80C680
.t0:
	cmp.w c2playernum		; $80C68A: CD 94 12
	bne .t1		; $80C68D: D0 0D
	jsl.l Readjoy2		; $80C68F: 22 29 C4 80
	lda.w #$0002		; $80C693: A9 02 00
	sta.b d4		; $80C696: 85 63
	jsl.l doinput		; $80C698: 22 3F DF 80
.t1:		;call the assignment through asstab and jmlvector
	lda.w pfalock,x		; $80C69C: BD 7F 11
	bne .cc		; $80C69F: D0 2D
	txa		; $80C6A1: 8A
	asl a		; $80C6A2: 0A
	asl a		; $80C6A3: 0A
	adc.w assnum,x		; $80C6A4: 7D BF 0B
	tay		; $80C6A7: A8
	lda.w asslist,y		; $80C6A8: B9 DF 0B  current assignment
	and.w #$00FF		; $80C6AB: 29 FF 00
.hang2:
	cmp.w #$001D		; $80C6AE: C9 1D 00  bad assignment: hang
	bcs .hang2		; $80C6B1: B0 FB
	asl a		; $80C6B3: 0A
	asl a		; $80C6B4: 0A
	tax		; $80C6B5: AA
	lda.l $8D86A8,x		; $80C6B6: BF A8 86 8D  asstab (bank $8D) entry into jmlvector
	sta.w jmlvector+1		; $80C6BA: 8D 79 01
	lda.l $8D86A8+1,x		; $80C6BD: BF A9 86 8D
	sta.w jmlvector+2		; $80C6C1: 8D 7A 01
	ldx.b a3		; $80C6C4: A6 3F
	jsl.l $8FDBF9		; $80C6C6: 22 F9 DB 8F  loadTeamStruct, then the assignment, bank $8F: 93G loadTeamStruct
	jsl.l jmlvector		; $80C6CA: 22 78 01 00
.cc:
	lda.w Ypos,x		; $80C6CE: BD 5F 09
	sta.b d3		; $80C6D1: 85 5F
	stz.w Wallcos,x		; $80C6D3: 9E 5F 0D  Wallcos = Wallsin = 0
	stz.w Wallsin,x		; $80C6D6: 9E 7F 0D
	lda.w Xpos,x		; $80C6D9: BD FF 08
	sta.b d2		; $80C6DC: 85 5B
	cmp.w OldXpos,x		; $80C6DE: DD 1F 0A
	bne .moved		; $80C6E1: D0 0A
	lda.b d3		; $80C6E3: A5 5F
	cmp.w OldYpos,x		; $80C6E5: DD 5F 0A
	bne .moved		; $80C6E8: D0 03
	jmp.w .nf		; $80C6EA: 4C 5F C7
.moved:		;moved at least 1 pixel: checkcoll
	jsl.l checkcoll		; $80C6ED: 22 94 C8 80
	cpx.w #$0018		; $80C6F1: E0 18 00  only players
	bcs .nf		; $80C6F4: B0 69
	lda.w position,x		; $80C6F6: BD 9F 0B
	beq .nf		; $80C6F9: F0 64
	lda.w pflags,x		; $80C6FB: BD DF 0E
	and.w #pf2npc		; $80C6FE: 29 00 80  pf2npc or horizontal: no goal check
	ora.w sfhormode		; $80C701: 0D 8E 12
	bne .nf		; $80C704: D0 59
	lda.w Xpos,x		; $80C706: BD FF 08
	bit.w #$8000		; $80C709: 89 00 80
	beq .ax		; $80C70C: F0 04
	eor.w #$FFFF		; $80C70E: 49 FF FF
	inc a		; $80C711: 1A
.ax:
	cmp.w #$0019		; $80C712: C9 19 00  |x| < 25
	bcs .nf		; $80C715: B0 48
	lda.w Ypos,x		; $80C717: BD 5F 09
	bit.w #$8000		; $80C71A: 89 00 80
	beq .ay		; $80C71D: F0 04
	eor.w #$FFFF		; $80C71F: 49 FF FF
	inc a		; $80C722: 1A
.ay:
	sec		; $80C723: 38
	sbc.w #$010D		; $80C724: E9 0D 01  crossing y = +-269 (the goal line)?
	sta.b tmp0		; $80C727: 85 73
	lda.w OldYpos,x		; $80C729: BD 5F 0A
	bit.w #$8000		; $80C72C: 89 00 80
	beq .oy		; $80C72F: F0 04
	eor.w #$FFFF		; $80C731: 49 FF FF
	inc a		; $80C734: 1A
.oy:
	sec		; $80C735: 38
	sbc.w #$010D		; $80C736: E9 0D 01
	eor.b tmp0		; $80C739: 45 73
	bmi .back		; $80C73B: 30 16
	lda.w Ypos,x		; $80C73D: BD 5F 09
	bit.w #$8000		; $80C740: 89 00 80
	beq .gl		; $80C743: F0 04
	eor.w #$FFFF		; $80C745: 49 FF FF
	inc a		; $80C748: 1A
.gl:
	cmp.w #$0103		; $80C749: C9 03 01  259 <= |y| < 279
	bcc .nf		; $80C74C: 90 11
	cmp.w #$0117		; $80C74E: C9 17 01
	bcs .nf		; $80C751: B0 0C
.back:		;do not skate into the goal: old position
	lda.w OldXpos,x		; $80C753: BD 1F 0A
	sta.w Xpos,x		; $80C756: 9D FF 08
	lda.w OldYpos,x		; $80C759: BD 5F 0A
	sta.w Ypos,x		; $80C75C: 9D 5F 09
.nf:		;impact decays; limpact = impact
	lda.w impact,x		; $80C75F: BD 7F 0B
	sec		; $80C762: 38
	sbc.b impactstep		; $80C763: E5 E2
	bpl .nf1		; $80C765: 10 03
	lda.w #$0000		; $80C767: A9 00 00
.nf1:
	sta.w impact,x		; $80C76A: 9D 7F 0B
	sta.w limpact,x		; $80C76D: 9D 5F 0B
	lda.w frame,x		; $80C770: BD 3F 09  frames $173-$178: x kept within +-$60
	cmp.w #$0173		; $80C773: C9 73 01
	bcc .next		; $80C776: 90 31
	cmp.w #$0179		; $80C778: C9 79 01
	bcs .next		; $80C77B: B0 2C
	lda.w Xpos,x		; $80C77D: BD FF 08
	sec		; $80C780: 38
	sbc.w #$FFA0		; $80C781: E9 A0 FF
	beq .cl1		; $80C784: F0 08
	bmi .v2		; $80C786: 30 04
	bvs .cl1		; $80C788: 70 04
	bra .cx		; $80C78A: 80 08
.v2:
	bvs .cx		; $80C78C: 70 06
.cl1:
	lda.w #$FFA0		; $80C78E: A9 A0 FF
	sta.w Xpos,x		; $80C791: 9D FF 08
.cx:
	lda.w Xpos,x		; $80C794: BD FF 08
	sec		; $80C797: 38
	sbc.w #$0060		; $80C798: E9 60 00
	bmi .v3		; $80C79B: 30 04
	bvc .cl2		; $80C79D: 50 04
	bra .next		; $80C79F: 80 08
.v3:
	bvc .next		; $80C7A1: 50 06
.cl2:
	lda.w #$0060		; $80C7A3: A9 60 00
	sta.w Xpos,x		; $80C7A6: 9D FF 08
.next:
	inx		; $80C7A9: E8
	inx		; $80C7AA: E8
	stx.b a3		; $80C7AB: 86 3F
	cpx.w #$0020		; $80C7AD: E0 20 00  all 16 objects
	beq .lim		; $80C7B0: F0 03
	jmp.w .top		; $80C7B2: 4C B2 C4
.lim:		;players faster than pspeed are slowed to it
	ldx.w #$0016		; $80C7B5: A2 16 00
.lim1:
	lda.w Xvel,x		; $80C7B8: BD DF 0A
	bit.w #$8000		; $80C7BB: 89 00 80
	beq .lvx		; $80C7BE: F0 04
	eor.w #$FFFF		; $80C7C0: 49 FF FF
	inc a		; $80C7C3: 1A
.lvx:
	sta.b tmp0		; $80C7C4: 85 73
	lda.w Yvel,x		; $80C7C6: BD FF 0A
	bit.w #$8000		; $80C7C9: 89 00 80
	beq .lvy		; $80C7CC: F0 04
	eor.w #$FFFF		; $80C7CE: 49 FF FF
	inc a		; $80C7D1: 1A
.lvy:
	clc		; $80C7D2: 18
	adc.b tmp0		; $80C7D3: 65 73
	cmp.w pspeed,x		; $80C7D5: DD 6F 12
	bcc .lnext		; $80C7D8: 90 34
	sta.b tmp0		; $80C7DA: 85 73
	lda.w Xvel,x		; $80C7DC: BD DF 0A
	sta.b mula		; $80C7DF: 85 7D
	lda.w pspeed,x		; $80C7E1: BD 6F 12
	sta.b mulb		; $80C7E4: 85 83
	jsl.l $82FCDB		; $80C7E6: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b tmp0		; $80C7EA: A5 73
	sta.b mula		; $80C7EC: 85 7D
	jsl.l divs		; $80C7EE: 22 6C 99 80
	sta.w Xvel,x		; $80C7F2: 9D DF 0A
	lda.w Yvel,x		; $80C7F5: BD FF 0A
	sta.b mula		; $80C7F8: 85 7D
	lda.w pspeed,x		; $80C7FA: BD 6F 12
	sta.b mulb		; $80C7FD: 85 83
	jsl.l $82FCDB		; $80C7FF: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b tmp0		; $80C803: A5 73
	sta.b mula		; $80C805: 85 7D
	jsl.l divs		; $80C807: 22 6C 99 80
	sta.w Yvel,x		; $80C80B: 9D FF 0A
.lnext:
	dex		; $80C80E: CA
	dex		; $80C80F: CA
	bpl .lim1		; $80C810: 10 A6
	lda.w Zpos+puckobj		; $80C812: AD BB 09  puck below 24: keep it inside the boards
	cmp.w #$0018		; $80C815: C9 18 00
	bcs .py		; $80C818: B0 2C
	lda.w puckx		; $80C81A: AD 1B 09
	sec		; $80C81D: 38
	sbc.w #$FF78		; $80C81E: E9 78 FF  x >= -$88
	bmi .v4		; $80C821: 30 04
	bvs .px1		; $80C823: 70 04
	bra .px2		; $80C825: 80 08
.v4:
	bvs .px2		; $80C827: 70 06
.px1:
	lda.w #$FF78		; $80C829: A9 78 FF
	sta.w puckx		; $80C82C: 8D 1B 09
.px2:
	lda.w puckx		; $80C82F: AD 1B 09
	sec		; $80C832: 38
	sbc.w #$0088		; $80C833: E9 88 00  x <= $88
	beq .py		; $80C836: F0 0E
	bmi .v5		; $80C838: 30 04
	bvc .px3		; $80C83A: 50 04
	bra .py		; $80C83C: 80 08
.v5:
	bvc .py		; $80C83E: 50 06
.px3:
	lda.w #$0088		; $80C840: A9 88 00
	sta.w puckx		; $80C843: 8D 1B 09
.py:		;puck on the ice within |y| < 318: keep it inside the boards
	lda.w Zpos+puckobj		; $80C846: AD BB 09
	bne .cy		; $80C849: D0 3D
	lda.w pucky		; $80C84B: AD 7B 09
	bit.w #$8000		; $80C84E: 89 00 80
	beq .py1		; $80C851: F0 04
	eor.w #$FFFF		; $80C853: 49 FF FF
	inc a		; $80C856: 1A
.py1:
	cmp.w #$013E		; $80C857: C9 3E 01
	bcs .cy		; $80C85A: B0 2C
	lda.w pucky		; $80C85C: AD 7B 09
	sec		; $80C85F: 38
	sbc.w #$FEDB		; $80C860: E9 DB FE  y >= -$125
	bmi .v6		; $80C863: 30 04
	bvs .py2		; $80C865: 70 04
	bra .py3		; $80C867: 80 08
.v6:
	bvs .py3		; $80C869: 70 06
.py2:
	lda.w #$FEDB		; $80C86B: A9 DB FE
	sta.w pucky		; $80C86E: 8D 7B 09
.py3:
	lda.w pucky		; $80C871: AD 7B 09
	sec		; $80C874: 38
	sbc.w #$012A		; $80C875: E9 2A 01  y <= $12A
	beq .cy		; $80C878: F0 0E
	bmi .v7		; $80C87A: 30 04
	bvc .py4		; $80C87C: 50 04
	bra .cy		; $80C87E: 80 08
.v7:
	bvc .cy		; $80C880: 50 06
.py4:
	lda.w #$012A		; $80C882: A9 2A 01
	sta.w pucky		; $80C885: 8D 7B 09
.cy:		;carried: carriedy = pucky
	lda.w puckc		; $80C888: AD BB 0E
	bmi .rtl		; $80C88B: 30 06
	lda.w pucky		; $80C88D: AD 7B 09
	sta.w carriedy		; $80C890: 8D 81 01
.rtl:
	rtl		; $80C893: 6B
checkcoll:		;auto: CODE_80C894. 93G checkcoll (hockey93_03): d2/d3 = new x/y of object X. Wall collision (hot spot, end of the stick), player collision, then keep OOlist sorted
	stz.b collflag		; $80C894: 64 D8  collflag = 0
	lda.w sfhormode		; $80C896: AD 8E 12  horizontal: exg d2,d3
	beq .nhor1		; $80C899: F0 08
	lda.b d2		; $80C89B: A5 5B
	ldy.b d3		; $80C89D: A4 5F
	sta.b d3		; $80C89F: 85 5F
	sty.b d2		; $80C8A1: 84 5B
.nhor1:
	lda.w pfnc,x		; $80C8A3: BD FF 11  pfnc: no collision
	beq .go		; $80C8A6: F0 03
	jmp.w .ex		; $80C8A8: 4C 84 C9
.go:		;movem d0-d6
	lda.b d6+2		; $80C8AB: A5 6D
	pha		; $80C8AD: 48
	lda.b d6		; $80C8AE: A5 6B
	pha		; $80C8B0: 48
	lda.b d5+2		; $80C8B1: A5 69
	pha		; $80C8B3: 48
	lda.b d5		; $80C8B4: A5 67
	pha		; $80C8B6: 48
	lda.b d4+2		; $80C8B7: A5 65
	pha		; $80C8B9: 48
	lda.b d4		; $80C8BA: A5 63
	pha		; $80C8BC: 48
	lda.b d3+2		; $80C8BD: A5 61
	pha		; $80C8BF: 48
	lda.b d3		; $80C8C0: A5 5F
	pha		; $80C8C2: 48
	lda.b d2+2		; $80C8C3: A5 5D
	pha		; $80C8C5: 48
	lda.b d2		; $80C8C6: A5 5B
	pha		; $80C8C8: 48
	lda.b d1+2		; $80C8C9: A5 59
	pha		; $80C8CB: 48
	lda.b d1		; $80C8CC: A5 57
	pha		; $80C8CE: 48
	lda.b d0+2		; $80C8CF: A5 55
	pha		; $80C8D1: 48
	lda.b d0		; $80C8D2: A5 53
	pha		; $80C8D4: 48
	lda.w Xpos,x		; $80C8D5: BD FF 08  around the hot spot with the wall
	sta.b d2		; $80C8D8: 85 5B
	lda.w Ypos,x		; $80C8DA: BD 5F 09
	sta.b d3		; $80C8DD: 85 5F
	lda.w radiusx,x		; $80C8DF: BD 1F 0D
	sta.w wcradiusx		; $80C8E2: 8D E3 08
	lda.w radiusy,x		; $80C8E5: BD 3F 0D
	sta.w wcradiusy		; $80C8E8: 8D E5 08
	jsl.l checkwallcoll		; $80C8EB: 22 1D CA 80
	lda.w Wallcos,x		; $80C8EF: BD 5F 0D  wall hit: done
	ora.w Wallsin,x		; $80C8F2: 1D 7F 0D
	bne .xx		; $80C8F5: D0 5F
	cpx.w #$0018		; $80C8F7: E0 18 00  only players: the end of the stick
	bcs .xx		; $80C8FA: B0 5A
	lda.b $01,s		; $80C8FC: A3 01
	sta.b d0		; $80C8FE: 85 53
	lda.b $03,s		; $80C900: A3 03
	sta.b d0+2		; $80C902: 85 55
	lda.b $05,s		; $80C904: A3 05
	sta.b d1		; $80C906: 85 57
	lda.b $07,s		; $80C908: A3 07
	sta.b d1+2		; $80C90A: 85 59
	lda.b $09,s		; $80C90C: A3 09
	sta.b d2		; $80C90E: 85 5B
	lda.b $0B,s		; $80C910: A3 0B
	sta.b d2+2		; $80C912: 85 5D
	lda.b $0D,s		; $80C914: A3 0D
	sta.b d3		; $80C916: 85 5F
	lda.b $0F,s		; $80C918: A3 0F
	sta.b d3+2		; $80C91A: 85 61
	lda.b $11,s		; $80C91C: A3 11
	sta.b d4		; $80C91E: 85 63
	lda.b $13,s		; $80C920: A3 13
	sta.b d4+2		; $80C922: 85 65
	lda.b $15,s		; $80C924: A3 15
	sta.b d5		; $80C926: 85 67
	lda.b $17,s		; $80C928: A3 17
	sta.b d5+2		; $80C92A: 85 69
	lda.b $19,s		; $80C92C: A3 19
	sta.b d6		; $80C92E: 85 6B
	lda.b $1B,s		; $80C930: A3 1B
	sta.b d6+2		; $80C932: 85 6D
	txa		; $80C934: 8A
	jsl.l GetHot		; $80C935: 22 0A 9B 80  GetHot
	lda.w Xpos,x		; $80C939: BD FF 08
	clc		; $80C93C: 18
	adc.b d0		; $80C93D: 65 53
	sta.b d2		; $80C93F: 85 5B
	lda.w Ypos,x		; $80C941: BD 5F 09
	clc		; $80C944: 18
	adc.b d1		; $80C945: 65 57
	sta.b d3		; $80C947: 85 5F
	lda.w #$0001		; $80C949: A9 01 00  radius 1
	sta.w wcradiusx		; $80C94C: 8D E3 08
	sta.w wcradiusy		; $80C94F: 8D E5 08
	jsl.l checkwallcoll		; $80C952: 22 1D CA 80
.xx:
	pla		; $80C956: 68
	sta.b d0		; $80C957: 85 53
	pla		; $80C959: 68
	sta.b d0+2		; $80C95A: 85 55
	pla		; $80C95C: 68
	sta.b d1		; $80C95D: 85 57
	pla		; $80C95F: 68
	sta.b d1+2		; $80C960: 85 59
	pla		; $80C962: 68
	sta.b d2		; $80C963: 85 5B
	pla		; $80C965: 68
	sta.b d2+2		; $80C966: 85 5D
	pla		; $80C968: 68
	sta.b d3		; $80C969: 85 5F
	pla		; $80C96B: 68
	sta.b d3+2		; $80C96C: 85 61
	pla		; $80C96E: 68
	sta.b d4		; $80C96F: 85 63
	pla		; $80C971: 68
	sta.b d4+2		; $80C972: 85 65
	pla		; $80C974: 68
	sta.b d5		; $80C975: 85 67
	pla		; $80C977: 68
	sta.b d5+2		; $80C978: 85 69
	pla		; $80C97A: 68
	sta.b d6		; $80C97B: 85 6B
	pla		; $80C97D: 68
	sta.b d6+2		; $80C97E: 85 6D
	jsl.l checkplcoll		; $80C980: 22 73 D5 80  checkplcoll
.ex:
	lda.b collflag		; $80C984: A5 D8  collflag: restore the old position
	beq .sort		; $80C986: F0 03
	jmp.w .restoreold		; $80C988: 4C 10 CA
.sort:
	lda.w OOlistpos,x		; $80C98B: BD 3F 12  move up/down OOlist by y
	sta.b d1		; $80C98E: 85 57
.up:
	ldy.b d1		; $80C990: A4 57
	cpy.w #$000F		; $80C992: C0 0F 00
	beq .cl2		; $80C995: F0 36
	lda.w OOlist+1,y		; $80C997: B9 60 12
	and.w #$00FF		; $80C99A: 29 FF 00
	sta.b d4		; $80C99D: 85 63
	tay		; $80C99F: A8
	lda.b d3		; $80C9A0: A5 5F
	sec		; $80C9A2: 38
	sbc.w Ylist,y		; $80C9A3: F9 1F 12
	beq .cl2		; $80C9A6: F0 25
	bmi .v1		; $80C9A8: 30 04
	bvc .swapup		; $80C9AA: 50 04
	bra .cl2		; $80C9AC: 80 1F
.v1:
	bvc .cl2		; $80C9AE: 50 1D
.swapup:
	inc.w OOlistpos,x		; $80C9B0: FE 3F 12
	lda.w OOlistpos,y		; $80C9B3: B9 3F 12
	dec a		; $80C9B6: 3A
	sta.w OOlistpos,y		; $80C9B7: 99 3F 12
	sep #$30		; $80C9BA: E2 30
	ldy.b d1		; $80C9BC: A4 57
	lda.b d4		; $80C9BE: A5 63
	sta.w OOlist,y		; $80C9C0: 99 5F 12
	txa		; $80C9C3: 8A
	sta.w OOlist+1,y		; $80C9C4: 99 60 12
	rep #$30		; $80C9C7: C2 30
	inc.b d1		; $80C9C9: E6 57
	bra .up		; $80C9CB: 80 C3
.cl2:
	lda.w OOlistpos,x		; $80C9CD: BD 3F 12
	beq .ex2		; $80C9D0: F0 38
	sta.b d1		; $80C9D2: 85 57
.dn:
	ldy.b d1		; $80C9D4: A4 57
	lda.w OOlist-1,y		; $80C9D6: B9 5E 12
	and.w #$00FF		; $80C9D9: 29 FF 00
	sta.b d4		; $80C9DC: 85 63
	tay		; $80C9DE: A8
	lda.b d3		; $80C9DF: A5 5F
	sec		; $80C9E1: 38
	sbc.w Ylist,y		; $80C9E2: F9 1F 12
	bmi .v2		; $80C9E5: 30 04
	bvs .swapdn		; $80C9E7: 70 04
	bra .ex2		; $80C9E9: 80 1F
.v2:
	bvs .ex2		; $80C9EB: 70 1D
.swapdn:
	dec.w OOlistpos,x		; $80C9ED: DE 3F 12
	lda.w OOlistpos,y		; $80C9F0: B9 3F 12
	inc a		; $80C9F3: 1A
	sta.w OOlistpos,y		; $80C9F4: 99 3F 12
	sep #$30		; $80C9F7: E2 30
	ldy.b d1		; $80C9F9: A4 57
	lda.b d4		; $80C9FB: A5 63
	sta.w OOlist,y		; $80C9FD: 99 5F 12
	txa		; $80CA00: 8A
	sta.w OOlist-1,y		; $80CA01: 99 5E 12
	rep #$30		; $80CA04: C2 30
	dec.b d1		; $80CA06: C6 57
	bne .dn		; $80CA08: D0 CA
.ex2:
	lda.b d3		; $80CA0A: A5 5F
	sta.w Ylist,x		; $80CA0C: 9D 1F 12
	rtl		; $80CA0F: 6B
.restoreold:
	lda.w OldXpos,x		; $80CA10: BD 1F 0A
	sta.w Xpos,x		; $80CA13: 9D FF 08
	lda.w OldYpos,x		; $80CA16: BD 5F 0A
	sta.w Ypos,x		; $80CA19: 9D 5F 09
	rtl		; $80CA1C: 6B
checkwallcoll:		;auto: CODE_80CA1D. 93G checkwallcoll (hockey93_04): d2/d3 = x/y, object X, wcradiusx/y. Corner circles, goals, then side and end boards
	lda.w #$012A		; $80CA1D: A9 2A 01  d3 = $12A - wcradiusy, d2 = $88 - wcradiusx; corner centers 64 in
	sec		; $80CA20: 38
	sbc.w wcradiusy		; $80CA21: ED E5 08
	pha		; $80CA24: 48
	eor.w #$FFFF		; $80CA25: 49 FF FF
	inc a		; $80CA28: 1A
	clc		; $80CA29: 18
	adc.w #$0040		; $80CA2A: 69 40 00
	sta.b d5		; $80CA2D: 85 67
	lda.w #$0088		; $80CA2F: A9 88 00
	sec		; $80CA32: 38
	sbc.w wcradiusx		; $80CA33: ED E3 08
	pha		; $80CA36: 48
	eor.w #$FFFF		; $80CA37: 49 FF FF
	inc a		; $80CA3A: 1A
	clc		; $80CA3B: 18
	adc.w #$0040		; $80CA3C: 69 40 00
	sta.b d4		; $80CA3F: 85 63
	lda.b d3		; $80CA41: A5 5F
	pha		; $80CA43: 48
	ldy.b d2		; $80CA44: A4 5B
	phy		; $80CA46: 5A
	sec		; $80CA47: 38
	sbc.b d5		; $80CA48: E5 67
	beq .negy		; $80CA4A: F0 08
	bmi .v1		; $80CA4C: 30 04
	bvs .negy		; $80CA4E: 70 04
	bra .ctc		; $80CA50: 80 2E
.v1:
	bvs .ctc		; $80CA52: 70 2C
.negy:
	lda.b d2		; $80CA54: A5 5B
	sec		; $80CA56: 38
	sbc.b d4		; $80CA57: E5 63
	bmi .v2		; $80CA59: 30 04
	bvc .gl1		; $80CA5B: 50 04
	bra .circle		; $80CA5D: 80 63
.v2:
	bvc .circle		; $80CA5F: 50 61
.gl1:
	lda.b d4		; $80CA61: A5 63
	eor.w #$FFFF		; $80CA63: 49 FF FF
	inc a		; $80CA66: 1A
	sta.b d4		; $80CA67: 85 63
	sec		; $80CA69: 38
	sbc.b d2		; $80CA6A: E5 5B
	bmi .v3		; $80CA6C: 30 04
	bvc .goal13		; $80CA6E: 50 04
	bra .circle		; $80CA70: 80 50
.v3:
	bvc .circle		; $80CA72: 50 4E
.goal13:		;goal at the -y end (object 13)
	lda.w #$001A		; $80CA74: A9 1A 00
	sta.b a2		; $80CA77: 85 3B
	jsl.l checkgoal		; $80CA79: 22 E7 CE 80
	jmp.w .exit		; $80CA7D: 4C 37 CB
.ctc:
	lda.b d5		; $80CA80: A5 67
	eor.w #$FFFF		; $80CA82: 49 FF FF
	inc a		; $80CA85: 1A
	sta.b d5		; $80CA86: 85 67
	sec		; $80CA88: 38
	sbc.b d3		; $80CA89: E5 5F
	beq .c2		; $80CA8B: F0 09
	bmi .v4		; $80CA8D: 30 05
	bvs .c2		; $80CA8F: 70 05
.exit1:
	jmp.w .exit		; $80CA91: 4C 37 CB
.v4:
	bvs .exit1		; $80CA94: 70 FB
.c2:
	lda.b d2		; $80CA96: A5 5B
	sec		; $80CA98: 38
	sbc.b d4		; $80CA99: E5 63
	bmi .v5		; $80CA9B: 30 04
	bvc .c3		; $80CA9D: 50 04
	bra .circle		; $80CA9F: 80 21
.v5:
	bvc .circle		; $80CAA1: 50 1F
.c3:
	lda.b d4		; $80CAA3: A5 63
	eor.w #$FFFF		; $80CAA5: 49 FF FF
	inc a		; $80CAA8: 1A
	sta.b d4		; $80CAA9: 85 63
	sec		; $80CAAB: 38
	sbc.b d2		; $80CAAC: E5 5B
	bmi .v6		; $80CAAE: 30 04
	bvc .goal12		; $80CAB0: 50 04
	bra .circle		; $80CAB2: 80 0E
.v6:
	bvc .circle		; $80CAB4: 50 0C
.goal12:		;goal at the +y end (object 12)
	lda.w #$0018		; $80CAB6: A9 18 00
	sta.b a2		; $80CAB9: 85 3B
	jsl.l checkgoal		; $80CABB: 22 E7 CE 80
	jmp.w .exit		; $80CABF: 4C 37 CB
.circle:		;distance from the corner center (max+min/4)
	lda.b d2		; $80CAC2: A5 5B
	sec		; $80CAC4: 38
	sbc.b d4		; $80CAC5: E5 63
	sta.b d2		; $80CAC7: 85 5B
	eor.w #$FFFF		; $80CAC9: 49 FF FF
	inc a		; $80CACC: 1A
	sta.b d1		; $80CACD: 85 57
	bit.w #$8000		; $80CACF: 89 00 80
	beq .dx		; $80CAD2: F0 04
	eor.w #$FFFF		; $80CAD4: 49 FF FF
	inc a		; $80CAD7: 1A
.dx:
	sta.b mula		; $80CAD8: 85 7D
	lda.b d3		; $80CADA: A5 5F
	sec		; $80CADC: 38
	sbc.b d5		; $80CADD: E5 67
	sta.b d0		; $80CADF: 85 53
	bit.w #$8000		; $80CAE1: 89 00 80
	beq .dy		; $80CAE4: F0 04
	eor.w #$FFFF		; $80CAE6: 49 FF FF
	inc a		; $80CAE9: 1A
.dy:
	sta.b mulb		; $80CAEA: 85 83
	cmp.b mula		; $80CAEC: C5 7D
	bcc .m2		; $80CAEE: 90 08
	lda.b mula		; $80CAF0: A5 7D
	lsr a		; $80CAF2: 4A
	lsr a		; $80CAF3: 4A
	adc.b mulb		; $80CAF4: 65 83
	bra .dist		; $80CAF6: 80 04
.m2:
	lsr a		; $80CAF8: 4A
	lsr a		; $80CAF9: 4A
	adc.b mula		; $80CAFA: 65 7D
.dist:
	cmp.w #$0041		; $80CAFC: C9 41 00  inside the radius 64 circle: no hit
	bcc .exit		; $80CAFF: 90 36
	sta.b d3		; $80CB01: 85 5F  cos = dy*256/r, sin = dx*256/r
	sta.b mula		; $80CB03: 85 7D
	stz.b mulb		; $80CB05: 64 83
	stz.b mulb+2		; $80CB07: 64 85
	lda.b d0		; $80CB09: A5 53
	sta.b mulb+1		; $80CB0B: 85 84
	bpl .cos		; $80CB0D: 10 05
	lda.w #$FFFF		; $80CB0F: A9 FF FF
	sta.b mulb+3		; $80CB12: 85 86
.cos:
	jsl.l divs		; $80CB14: 22 6C 99 80
	sta.b d0		; $80CB18: 85 53
	lda.b d3		; $80CB1A: A5 5F
	sta.b mula		; $80CB1C: 85 7D
	stz.b mulb		; $80CB1E: 64 83
	stz.b mulb+2		; $80CB20: 64 85
	lda.b d1		; $80CB22: A5 57
	sta.b mulb+1		; $80CB24: 85 84
	bpl .sin		; $80CB26: 10 05
	lda.w #$FFFF		; $80CB28: A9 FF FF
	sta.b mulb+3		; $80CB2B: 85 86
.sin:
	jsl.l divs		; $80CB2D: 22 6C 99 80
	sta.b d1		; $80CB31: 85 57
	jsl.l wallcollb		; $80CB33: 22 1E CC 80
.exit:		;no corner hit: the side and end boards
	pla		; $80CB37: 68
	sta.b d2		; $80CB38: 85 5B
	pla		; $80CB3A: 68
	sta.b d3		; $80CB3B: 85 5F
	pla		; $80CB3D: 68
	sta.b d4		; $80CB3E: 85 63
	pla		; $80CB40: 68
	sta.b d5		; $80CB41: 85 67
	lda.w Wallcos,x		; $80CB43: BD 5F 0D  corner hit: done
	ora.w Wallsin,x		; $80CB46: 1D 7F 0D
	bne .rtl		; $80CB49: D0 65
	lda.w #$0100		; $80CB4B: A9 00 01  side walls: cos $100, sin 0
	sta.b d0		; $80CB4E: 85 53
	stz.b d1		; $80CB50: 64 57
	lda.b d3		; $80CB52: A5 5F
	sec		; $80CB54: 38
	sbc.b d5		; $80CB55: E5 67
	bmi .v7		; $80CB57: 30 05
	bvs .s1		; $80CB59: 70 05
.b1:
	jmp.w wallcollb		; $80CB5B: 4C 1E CC
.v7:
	bvs .b1		; $80CB5E: 70 FB
.s1:
	lda.b d0		; $80CB60: A5 53
	eor.w #$FFFF		; $80CB62: 49 FF FF
	inc a		; $80CB65: 1A
	sta.b d0		; $80CB66: 85 53
	lda.b d5		; $80CB68: A5 67
	eor.w #$FFFF		; $80CB6A: 49 FF FF
	inc a		; $80CB6D: 1A
	sta.b d5		; $80CB6E: 85 67
	sec		; $80CB70: 38
	sbc.b d3		; $80CB71: E5 5F
	bmi .v8		; $80CB73: 30 05
	bvs .s2		; $80CB75: 70 05
.b2:
	jmp.w wallcollb		; $80CB77: 4C 1E CC
.v8:
	bvs .b2		; $80CB7A: 70 FB
.s2:
	lda.b d0		; $80CB7C: A5 53
	pha		; $80CB7E: 48
	lda.b d1		; $80CB7F: A5 57
	sta.b d0		; $80CB81: 85 53
	pla		; $80CB83: 68
	sta.b d1		; $80CB84: 85 57
	lda.b d2		; $80CB86: A5 5B
	sec		; $80CB88: 38
	sbc.b d4		; $80CB89: E5 63
	bmi .v9		; $80CB8B: 30 05
	bvs .s3		; $80CB8D: 70 05
.b3:
	jmp.w wallcollb		; $80CB8F: 4C 1E CC
.v9:
	bvs .b3		; $80CB92: 70 FB
.s3:
	lda.b d1		; $80CB94: A5 57
	eor.w #$FFFF		; $80CB96: 49 FF FF
	inc a		; $80CB99: 1A
	sta.b d1		; $80CB9A: 85 57
	lda.b d4		; $80CB9C: A5 63
	eor.w #$FFFF		; $80CB9E: 49 FF FF
	inc a		; $80CBA1: 1A
	sta.b d4		; $80CBA2: 85 63
	sec		; $80CBA4: 38
	sbc.b d2		; $80CBA5: E5 5B
	bmi .v10		; $80CBA7: 30 05
	bvs .rtl		; $80CBA9: 70 05
.b4:
	jmp.w wallcollb		; $80CBAB: 4C 1E CC
.v10:
	bvs .b4		; $80CBAE: 70 FB
.rtl:
	rtl		; $80CBB0: 6B
sroot:		;auto: CODE_80CBB1. 93G sroot (middle93_1): d0 = sqrt(d0, 32-bit) by binary search on the square
	stz.b tmp0		; $80CBB1: 64 73
	lda.w #$1000		; $80CBB3: A9 00 10
	sta.b tmp1		; $80CBB6: 85 75
.loop:
	lda.b tmp0		; $80CBB8: A5 73
	clc		; $80CBBA: 18
	adc.b tmp1		; $80CBBB: 65 75
	ror a		; $80CBBD: 6A
	cmp.b tmp0		; $80CBBE: C5 73
	beq .done		; $80CBC0: F0 20
	sta.b tmp2		; $80CBC2: 85 77
	sta.b mula		; $80CBC4: 85 7D
	sta.b mulb		; $80CBC6: 85 83
	jsl.l $888942		; $80CBC8: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.b d0		; $80CBCC: A5 53
	cmp.b mulres		; $80CBCE: C5 93
	lda.b d0+2		; $80CBD0: A5 55
	sbc.b mulres+2		; $80CBD2: E5 95
	bcs .low		; $80CBD4: B0 06
	lda.b tmp2		; $80CBD6: A5 77
	sta.b tmp1		; $80CBD8: 85 75
	bra .loop		; $80CBDA: 80 DC
.low:
	lda.b tmp2		; $80CBDC: A5 77
	sta.b tmp0		; $80CBDE: 85 73
	bra .loop		; $80CBE0: 80 D6
.done:
	sta.b d0		; $80CBE2: 85 53
	rtl		; $80CBE4: 6B
divu:		;auto: CODE_80CBE5. 68k divu: A = mulres = mulb (32-bit) / mula; mulres+2 = remainder. C clear
	lda.b mula		; $80CBE5: A5 7D
	sta.b mula+2		; $80CBE7: 85 7F
	stz.b mula		; $80CBE9: 64 7D
	lda.w #$0010		; $80CBEB: A9 10 00
	sta.b mulres+2		; $80CBEE: 85 95
.loop:
	asl.b mulres		; $80CBF0: 06 93
	lsr.b mula+2		; $80CBF2: 46 7F
	ror.b mula		; $80CBF4: 66 7D
	lda.b mulb		; $80CBF6: A5 83
	cmp.b mula		; $80CBF8: C5 7D
	lda.b mulb+2		; $80CBFA: A5 85
	sbc.b mula+2		; $80CBFC: E5 7F
	bcc .next		; $80CBFE: 90 0E
	lda.b mulb		; $80CC00: A5 83
	sbc.b mula		; $80CC02: E5 7D
	sta.b mulb		; $80CC04: 85 83
	lda.b mulb+2		; $80CC06: A5 85
	sbc.b mula+2		; $80CC08: E5 7F
	sta.b mulb+2		; $80CC0A: 85 85
	inc.b mulres		; $80CC0C: E6 93
.next:
	dec.b mulres+2		; $80CC0E: C6 95
	bne .loop		; $80CC10: D0 DE
	lda.b mulb		; $80CC12: A5 83
	sta.b mulres+2		; $80CC14: 85 95
	lda.b mulres		; $80CC16: A5 93
	sta.b mula		; $80CC18: 85 7D
	sta.b mulb		; $80CC1A: 85 83
	clc		; $80CC1C: 18
	rtl		; $80CC1D: 6B
wallcollb:		;auto: CODE_80CC1E. 93G wallcollb (hockey93_04): object X hits a wall (d0/d1 = cos/sin). The puck may go over the glass; otherwise wallcoll
	cpx.w #$001C		; $80CC1E: E0 1C 00  not the puck: wallcoll
	beq .puck		; $80CC21: F0 03
	jmp.w wallcoll		; $80CC23: 4C DE CC
.puck:
	lda.w Zpos+puckobj		; $80CC26: AD BB 09
	sec		; $80CC29: 38
	sbc.w #$0020		; $80CC2A: E9 20 00  Zpos > 32: over
	beq .z1		; $80CC2D: F0 08
	bmi .v1		; $80CC2F: 30 04
	bvs .z1		; $80CC31: 70 04
	bra .over		; $80CC33: 80 77
.v1:
	bvs .over		; $80CC35: 70 75
.z1:
	lda.w Zpos+puckobj		; $80CC37: AD BB 09
	cmp.w #$0016		; $80CC3A: C9 16 00  Zpos <= 21: wallcoll
	bcs .y280		; $80CC3D: B0 03
	jmp.w wallcoll		; $80CC3F: 4C DE CC
.y280:
	lda.w pucky		; $80CC42: AD 7B 09
	sec		; $80CC45: 38
	sbc.w #$0112		; $80CC46: E9 12 01  y >= 274
	bmi .v2		; $80CC49: 30 04
	bvc .x13		; $80CC4B: 50 04
	bra .over		; $80CC4D: 80 5D
.v2:
	bvc .over		; $80CC4F: 50 5B
.x13:
	lda.w puckx		; $80CC51: AD 1B 09
	sec		; $80CC54: 38
	sbc.w #$000D		; $80CC55: E9 0D 00  x 13-15 (the goal mouth)
	bmi .v3		; $80CC58: 30 05
	bvc .x15		; $80CC5A: 50 05
.wc1:
	jmp.w wallcoll		; $80CC5C: 4C DE CC
.v3:
	bvc .wc1		; $80CC5F: 50 FB
.x15:
	lda.w puckx		; $80CC61: AD 1B 09
	sec		; $80CC64: 38
	sbc.w #$000F		; $80CC65: E9 0F 00
	beq .vy		; $80CC68: F0 08
	bmi .v4		; $80CC6A: 30 04
	bvs .vy		; $80CC6C: 70 04
	bra wallcoll		; $80CC6E: 80 6E
.v4:
	bvs wallcoll		; $80CC70: 70 6C
.vy:
	lda.w puckvy		; $80CC72: AD 1B 0B
	sec		; $80CC75: 38
	sbc.w #$0FA0		; $80CC76: E9 A0 0F  Yvel >= $FA0
	bmi .v5		; $80CC79: 30 04
	bvc .glass		; $80CC7B: 50 04
	bra wallcoll		; $80CC7D: 80 5F
.v5:
	bvc wallcoll		; $80CC7F: 50 5D
.glass:		;over the glass at the goal: shadow animation, sound, crowd
	phx		; $80CC81: DA
	lda.w puckvy		; $80CC82: AD 1B 0B  halve puckvy
	pha		; $80CC85: 48
	asl a		; $80CC86: 0A
	pla		; $80CC87: 68
	ror a		; $80CC88: 6A
	sta.w puckvy		; $80CC89: 8D 1B 0B
	inx		; $80CC8C: E8
	inx		; $80CC8D: E8
	stx.b a3		; $80CC8E: 86 3F
	lda.w #SPAbglass		; $80CC90: A9 6A 14  object 15 (shadow): SPAbglass
	sta.b d1		; $80CC93: 85 57
	jsl.l SetSPA		; $80CC95: 22 06 B0 80
	plx		; $80CC99: FA
	stx.b a3		; $80CC9A: 86 3F
	lda.w #SFXoverglass		; $80CC9C: A9 8C 00  over the glass sound
	pha		; $80CC9F: 48
	jsl.l sfx		; $80CCA0: 22 8B C2 80
	lda.b crowdlevel		; $80CCA4: A5 DE  crowd +600
	clc		; $80CCA6: 18
	adc.w #$0258		; $80CCA7: 69 58 02
	sta.b crowdlevel		; $80CCAA: 85 DE
.over:		;puck out of play
	lda.w #sfslock		; $80CCAC: A9 40 00  sfslock; puck pfnc
	tsb.w sflags		; $80CCAF: 0C 8C 12
	sta.w pfnc+puckobj		; $80CCB2: 8D 1B 12
	lda.w pucky		; $80CCB5: AD 7B 09  bottom: y flip
	bpl .n1		; $80CCB8: 10 06
	lda.w #$8000		; $80CCBA: A9 00 80
	tsb.w attribute+puckobj		; $80CCBD: 0C FB 09
.n1:
	stz.w frame+$1E		; $80CCC0: 9C 5D 09  shadow frame 0
	lda.w gmclock		; $80CCC3: AD 8A 12  clock stopped
	bne .rtl		; $80CCC6: D0 15
	lda.w ltplayer		; $80CCC8: AD 8B 01  penalty 6 for the last touch player
	asl a		; $80CCCB: 0A
	sta.b a3		; $80CCCC: 85 3F
	tax		; $80CCCE: AA
	lda.w #PenOOP		; $80CCCF: A9 06 00
	sta.b d0		; $80CCD2: 85 53
	jsl.l AddPenalty2		; $80CCD4: 22 B0 C1 80
	ldx.w #$001C		; $80CCD8: A2 1C 00
	stx.b a3		; $80CCDB: 86 3F
.rtl:
	rtl		; $80CCDD: 6B
wallcoll:		;auto: CODE_80CCDE. 93G wallcoll (hockey93_04): d0/d1 = cos/sin of the wall; bounce object X: puck loses speed, flips, sound; players sound on a hard hit
	lda.b d0		; $80CCDE: A5 53  Wallcos/Wallsin
	sta.w Wallcos,x		; $80CCE0: 9D 5F 0D
	lda.b d1		; $80CCE3: A5 57
	sta.w Wallsin,x		; $80CCE5: 9D 7F 0D
	stx.b xsave		; $80CCE8: 86 0A
	ldx.w #$0000		; $80CCEA: A2 00 00
.push:
	lda.b d2,x		; $80CCED: B5 5B
	pha		; $80CCEF: 48
	inx		; $80CCF0: E8
	inx		; $80CCF1: E8
	cpx.w #$0008		; $80CCF2: E0 08 00
	bne .push		; $80CCF5: D0 F6
	ldx.b xsave		; $80CCF7: A6 0A
	lda.b d1		; $80CCF9: A5 57  v1n = (Yvel*cos - Xvel*sin)/256, negated; v1t = (Xvel*cos + Yvel*sin)/256
	pha		; $80CCFB: 48
	lda.b d0		; $80CCFC: A5 53
	pha		; $80CCFE: 48
	sta.b mulb		; $80CCFF: 85 83
	lda.w Yvel,x		; $80CD01: BD FF 0A
	sta.b mula		; $80CD04: 85 7D
	jsl.l $82FCDB		; $80CD06: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $80CD0A: 85 53
	lda.b mulres+2		; $80CD0C: A5 95
	sta.b d0+2		; $80CD0E: 85 55
	lda.w Xvel,x		; $80CD10: BD DF 0A
	sta.b mula		; $80CD13: 85 7D
	lda.b d1		; $80CD15: A5 57
	sta.b mulb		; $80CD17: 85 83
	jsl.l $82FCDB		; $80CD19: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d0		; $80CD1D: A5 53
	sec		; $80CD1F: 38
	sbc.b mulres		; $80CD20: E5 93
	sta.b d0		; $80CD22: 85 53
	lda.b d0+2		; $80CD24: A5 55
	sbc.b mulres+2		; $80CD26: E5 95
	sta.b d0+2		; $80CD28: 85 55
	lda.b d0+1		; $80CD2A: A5 54
	eor.w #$FFFF		; $80CD2C: 49 FF FF
	inc a		; $80CD2F: 1A
	sta.b d2		; $80CD30: 85 5B
	lda.w Xvel,x		; $80CD32: BD DF 0A
	sta.b mula		; $80CD35: 85 7D
	lda.b $01,s		; $80CD37: A3 01
	sta.b mulb		; $80CD39: 85 83
	jsl.l $82FCDB		; $80CD3B: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $80CD3F: 85 53
	lda.b mulres+2		; $80CD41: A5 95
	sta.b d0+2		; $80CD43: 85 55
	lda.w Yvel,x		; $80CD45: BD FF 0A
	sta.b mula		; $80CD48: 85 7D
	lda.b d1		; $80CD4A: A5 57
	sta.b mulb		; $80CD4C: 85 83
	jsl.l $82FCDB		; $80CD4E: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $80CD52: 65 53
	sta.b d0		; $80CD54: 85 53
	lda.b d0+2		; $80CD56: A5 55
	adc.b mulres+2		; $80CD58: 65 95
	sta.b d0+2		; $80CD5A: 85 55
	lda.b d0+1		; $80CD5C: A5 54
	sta.b d3		; $80CD5E: 85 5F
	cpx.w #$001C		; $80CD60: E0 1C 00
	beq .puck		; $80CD63: F0 03
	jmp.w .player		; $80CD65: 4C F5 CD
.puck:
	lda.w #sf2shot		; $80CD68: A9 00 10  puck: clear sf2shot
	trb.w sflags		; $80CD6B: 1C 8C 12
	lda.b d2		; $80CD6E: A5 5B  moving away from the wall
	bmi .pn		; $80CD70: 30 03
	jmp.w .nocoll		; $80CD72: 4C B8 CE
.pn:
	lsr a		; $80CD75: 4A  normal speed /4
	lsr a		; $80CD76: 4A
	bit.w #$2000		; $80CD77: 89 00 20
	beq .pn1		; $80CD7A: F0 03
	ora.w #$C000		; $80CD7C: 09 00 C0
.pn1:
	sta.b d2		; $80CD7F: 85 5B
	sec		; $80CD81: 38
	sbc.w #$FC00		; $80CD82: E9 00 FC  hard hit (v1n <= -$400): pop up, flip, sound by speed
	beq .hard		; $80CD85: F0 08
	bmi .v1		; $80CD87: 30 04
	bvs .hard		; $80CD89: 70 04
	bra .pok		; $80CD8B: 80 44
.v1:
	bvs .pok		; $80CD8D: 70 42
.hard:
	lda.w #$0800		; $80CD8F: A9 00 08
	jsl.l randoma		; $80CD92: 22 8B AE 80
	eor.w #$FFFF		; $80CD96: 49 FF FF
	inc a		; $80CD99: 1A
	sta.w puckvz		; $80CD9A: 8D 3B 0B
	sta.b d0		; $80CD9D: 85 53
	jsl.l puckflip		; $80CD9F: 22 C9 CE 80
	lda.w #SFXpuckwall		; $80CDA3: A9 95 00
	pha		; $80CDA6: 48
	lda.b d2		; $80CDA7: A5 5B
	sec		; $80CDA9: 38
	sbc.w #$EE00		; $80CDAA: E9 00 EE
	bmi .v2		; $80CDAD: 30 04
	bvc .s2		; $80CDAF: 50 04
	bra .snd		; $80CDB1: 80 1A
.v2:
	bvc .snd		; $80CDB3: 50 18
.s2:
	pla		; $80CDB5: 68
	lda.w #SFXpuckwall+1		; $80CDB6: A9 96 00
	pha		; $80CDB9: 48
	lda.b d2		; $80CDBA: A5 5B
	sec		; $80CDBC: 38
	sbc.w #$F800		; $80CDBD: E9 00 F8
	bmi .v3		; $80CDC0: 30 04
	bvc .s3		; $80CDC2: 50 04
	bra .snd		; $80CDC4: 80 07
.v3:
	bvc .snd		; $80CDC6: 50 05
.s3:
	pla		; $80CDC8: 68
	lda.w #SFXpuckwall+2		; $80CDC9: A9 97 00
	pha		; $80CDCC: 48
.snd:
	jsl.l sfx		; $80CDCD: 22 8B C2 80
.pok:		;reduce the tangent speed of the puck
	lda.b d3		; $80CDD1: A5 5F
	lsr a		; $80CDD3: 4A
	lsr a		; $80CDD4: 4A
	lsr a		; $80CDD5: 4A
	lsr a		; $80CDD6: 4A
	lsr a		; $80CDD7: 4A
	lsr a		; $80CDD8: 4A
	bit.w #$0200		; $80CDD9: 89 00 02
	beq .t1		; $80CDDC: F0 03
	ora.w #$FC00		; $80CDDE: 09 00 FC
.t1:
	sta.b d0		; $80CDE1: 85 53
	pha		; $80CDE3: 48
	asl a		; $80CDE4: 0A
	pla		; $80CDE5: 68
	ror a		; $80CDE6: 6A
	sta.b d0+2		; $80CDE7: 85 55
	lda.b d3		; $80CDE9: A5 5F
	sec		; $80CDEB: 38
	sbc.b d0		; $80CDEC: E5 53
	sec		; $80CDEE: 38
	sbc.b d0+2		; $80CDEF: E5 55
	sta.b d3		; $80CDF1: 85 5F
	bra .noadd		; $80CDF3: 80 5E
.player:
	lda.b d2		; $80CDF5: A5 5B
	sec		; $80CDF7: 38
	sbc.w #$03E8		; $80CDF8: E9 E8 03  player: v1n > 1000: no collision
	beq .p1		; $80CDFB: F0 09
	bmi .v4		; $80CDFD: 30 05
	bvs .p1		; $80CDFF: 70 05
.nocoll1:
	jmp.w .nocoll		; $80CE01: 4C B8 CE
.v4:
	bvs .nocoll1		; $80CE04: 70 FB
.p1:
	lda.b d2		; $80CE06: A5 5B
	sec		; $80CE08: 38
	sbc.w #$F000		; $80CE09: E9 00 F0  v1n <= -$1000 and impact >= 10: board sound
	beq .imp		; $80CE0C: F0 08
	bmi .v5		; $80CE0E: 30 04
	bvs .imp		; $80CE10: 70 04
	bra .nosfx		; $80CE12: 80 20
.v5:
	bvs .nosfx		; $80CE14: 70 1E
.imp:
	lda.w impact,x		; $80CE16: BD 7F 0B
	sec		; $80CE19: 38
	sbc.w #$000A		; $80CE1A: E9 0A 00
	bmi .v6		; $80CE1D: 30 04
	bvc .psnd		; $80CE1F: 50 04
	bra .nosfx		; $80CE21: 80 11
.v6:
	bvc .nosfx		; $80CE23: 50 0F
.psnd:
	lda.w seed+1		; $80CE25: AD A2 04
	and.w #$0001		; $80CE28: 29 01 00
	clc		; $80CE2B: 18
	adc.w #SFXplayerwall		; $80CE2C: 69 9E 00
	pha		; $80CE2F: 48
	jsl.l sfx		; $80CE30: 22 8B C2 80
.nosfx:
	lda.b d2		; $80CE34: A5 5B
	lsr a		; $80CE36: 4A
	lsr a		; $80CE37: 4A
	bit.w #$2000		; $80CE38: 89 00 20
	beq .n1		; $80CE3B: F0 03
	ora.w #$C000		; $80CE3D: 09 00 C0
.n1:
	sta.b d2		; $80CE40: 85 5B
	sec		; $80CE42: 38
	sbc.w #$FC7C		; $80CE43: E9 7C FC  v1n >= -900: -1000
	bmi .v7		; $80CE46: 30 04
	bvc .min		; $80CE48: 50 04
	bra .noadd		; $80CE4A: 80 07
.v7:
	bvc .noadd		; $80CE4C: 50 05
.min:
	lda.w #$FC18		; $80CE4E: A9 18 FC
	sta.b d2		; $80CE51: 85 5B
.noadd:		;rotate back: new Xvel/Yvel
	lda.b $01,s		; $80CE53: A3 01
	sta.b mula		; $80CE55: 85 7D
	lda.b d3		; $80CE57: A5 5F
	sta.b mulb		; $80CE59: 85 83
	jsl.l $82FCDB		; $80CE5B: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b tmp0		; $80CE5F: 85 73
	lda.b mulres+2		; $80CE61: A5 95
	sta.b tmp1		; $80CE63: 85 75
	lda.b $03,s		; $80CE65: A3 03
	sta.b mula		; $80CE67: 85 7D
	lda.b d2		; $80CE69: A5 5B
	sta.b mulb		; $80CE6B: 85 83
	jsl.l $82FCDB		; $80CE6D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b tmp0		; $80CE71: A5 73
	sec		; $80CE73: 38
	sbc.b mulres		; $80CE74: E5 93
	sta.b tmp0		; $80CE76: 85 73
	lda.b tmp1		; $80CE78: A5 75
	sbc.b mulres+2		; $80CE7A: E5 95
	sta.b tmp1		; $80CE7C: 85 75
	lda.b tmp0+1		; $80CE7E: A5 74
	sta.w Xvel,x		; $80CE80: 9D DF 0A
	lda.b $03,s		; $80CE83: A3 03
	sta.b mula		; $80CE85: 85 7D
	lda.b d3		; $80CE87: A5 5F
	sta.b mulb		; $80CE89: 85 83
	jsl.l $82FCDB		; $80CE8B: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d3		; $80CE8F: 85 5F
	lda.b mulres+2		; $80CE91: A5 95
	sta.b d3+2		; $80CE93: 85 61
	lda.b $01,s		; $80CE95: A3 01
	sta.b mula		; $80CE97: 85 7D
	lda.b d2		; $80CE99: A5 5B
	sta.b mulb		; $80CE9B: 85 83
	jsl.l $82FCDB		; $80CE9D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d3		; $80CEA1: 65 5F
	sta.b d3		; $80CEA3: 85 5F
	lda.b d3+2		; $80CEA5: A5 61
	adc.b mulres+2		; $80CEA7: 65 95
	sta.b d3+2		; $80CEA9: 85 61
	lda.b d3+1		; $80CEAB: A5 60
	sta.w Yvel,x		; $80CEAD: 9D FF 0A
	lda.w Zvel,x		; $80CEB0: BD 1F 0B  moving up: Zvel = 0
	bmi .nocoll		; $80CEB3: 30 03
	stz.w Zvel,x		; $80CEB5: 9E 1F 0B
.nocoll:
	pla		; $80CEB8: 68
	pla		; $80CEB9: 68
	stx.b xsave		; $80CEBA: 86 0A
	ldx.w #$0006		; $80CEBC: A2 06 00
.pop:
	pla		; $80CEBF: 68
	sta.b d2,x		; $80CEC0: 95 5B
	dex		; $80CEC2: CA
	dex		; $80CEC3: CA
	bpl .pop		; $80CEC4: 10 F9
	ldx.b xsave		; $80CEC6: A6 0A
	rtl		; $80CEC8: 6B
puckflip:		;auto: CODE_80CEC9. 93G puckflip (logic93_5): start the puck spinning. d0 bit 0 = flip
	lda.b d0		; $80CEC9: A5 53
	and.w #$0001		; $80CECB: 29 01 00  facedir of the puck ^= d0 bit 0, & 3
	sta.b d0		; $80CECE: 85 53
	eor.w facedir+puckobj		; $80CED0: 4D DB 0D
	and.w #$0003		; $80CED3: 29 03 00
	sta.w facedir+puckobj		; $80CED6: 8D DB 0D
	lda.w #$FFFF		; $80CED9: A9 FF FF  SPAcnt = -1
	sta.w SPAcnt+puckobj		; $80CEDC: 8D 5B 0E
	lda.w #SPApflip		; $80CEDF: A9 D6 03
	sta.b d1		; $80CEE2: 85 57
	jmp.w SetSPA		; $80CEE4: 4C 06 B0
