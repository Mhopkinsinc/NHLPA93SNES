; $808000-$80910E  ROM $00000-$0110E: reset, vblank/irq handlers, and the start of the player logic (93G logic93_5 / logic93_1 /
; logic93_3 / logic93_4 routines). The 68k registers of 93G are DP pseudo registers (d0 = $53 ... a3 = $3F, see ram93snes.asm);
; X = SCnum*2 of the current object (93G a3). Out-of-bank or later-segment calls keep their address with the 93G name in the comment.
org $808000

Start:		;auto: CODE_808000. 93G main93 Start + hockey93_01 Begin (RAM clear). Reset vector. Native mode, stack $1FFF, D=0, DB=$00; clears DP/RAM, sets vbint/hbint, inits the sprite tile cache,
		;   checks the ROM sum, inits hardware/sound, then the title screen
	sei		; interrupts off
	clc
	xce		; native mode
	rep #$30
	lda.w #$1FFF
	tcs		; stack $1FFF
	lda.w #$0000
	tcd		; D = 0
	sep #$20
	pha
	plb		; DB = $00 (low RAM and registers)
	rep #$30
	ldx.w #$0000
.clrdp:		;clear $0000-$164D (DP and low RAM)
	stz.b vcount,x
	inx
	inx
	cpx.w #DPCLEAREND
	bcc .clrdp
	lda.w #vb2_blank
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	lda.w #JMLOPCODE		; jml opcode for the jmlvector trampoline
	sta.w jmlvector
	lda.w #$0012		; sprite VRAM slots stay reserved 18 frames
	sta.b sprslotlife
	lda.b sprclock
	sec
	sbc.w #$003C		; 60 frames ago
	ldx.w #$0000
.clrcache:		;sprframetime: every frame "sent 60 frames ago" (sprclock-$3C), so every cached frame is stale
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .clrcache
	ldx.w #$0000
.clrslots:		;sprslottime ($04AB-$08AA): every VRAM sprite slot free
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .clrslots
	lda.w #$0020
	sta.b sprpriority
	stz.b tmp0		; sum = 0
	ldx.w #$0000
	ldy.w #$0002		; word at +2 of each pointer
.sumloop:		;sum the word at [ptr]+2 for each long ptr in the table at $8FE67D (0-terminated, 4 bytes per entry)
	lda.l FrameSetTable,x
	beq .validate
	sta.b tmp1
	lda.l FrameSetTable+1,x
	sta.b tmp1+1
	lda.b [tmp1],y
	clc
	adc.b tmp0
	sta.b tmp0
	inx
	inx
	inx
	inx
	bra .sumloop
.validate:		;anti-tamper: hang forever unless the sum is $131D (93G ValidationRoutine role, inline here)
	lda.b tmp0
	cmp.w #$131D
	bne .validate
	lda.w #$0001		; hold the sound queue while the hardware/sound driver starts
	sta.b sndlock
	jsl.l InitPPU		; bank $8D: PPU registers off/clear, sound driver start
	sep #$20
	cli
	lda.w RDNMI		; ack a pending NMI
	lda.b #$81		; NMI on, auto joypad read
	sta.w NMITIMEN
	rep #$30
	jsl.l SPCBootUpload
	stz.b sndlock
	stz.b vbactive		; vblank handlers may run
	jsl.l ResetPassWord		; bank $8F: $1610-$161F = $1E
	jsl.l DefaultMenus		; bank $8F: 93G DefaultMenus (initial menu choices at $1600)
	jsl.l Readjoy12
	jml.l Opening		; bank $8B: on to the title screen (93G Opening)
BRKHalt:		;auto: CODE_8080B2. BRK vector: hang. No 92G/93G counterpart (68k traps go to IRQ7 rte)
	bra BRKHalt
VBjsr:		;auto: CODE_8080B4. 93G VBjsr (hockey93_01, IDA VBLANK). NMI: ack RDNMI, skip if vbactive, else "rts" into the vbint handler
	rep #$30
	pha
	lda.w RDNMI
	bit.w #$0080
	beq .skip		; not a vblank NMI
	lda.b vbactive
	beq .dispatch
.skip:		;not a vblank NMI, or the last handler still runs
	pla
	rti
.dispatch:		;push vbint-1 and rts into it (A/X/Y stay on the stack for the handler to pull)
	inc.b vbactive
	phx
	phy
	lda.b vbint
	dec a
	pha
	rts
vb2_blank:		;auto: CODE_8080CE. vbint target: vb2 with the screen held in forced blank. Resets hbint to HBdefault
	sep #$20
	lda.b #$80
	sta.w INIDISP
	rep #$30
	lda.w #HBdefault
	sta.b hbint
	bra vb2_main
vb2:		;auto: CODE_8080DE. 93G vb2 (video93_1): vblank for fades only, no dma. INIDISP from brightness, then vb2_main
	sep #$20
	lda.b brightness
	sta.w INIDISP
vb2_main:		;auto: CODE_8080E5. common vblank tail: vcount, sound tick (93G p_music_vblank), brightness fades (93G cramfade), rti
	rep #$30
	inc.b vcount
	bne .tick
	inc.b vcount+2
.tick:
	jsl.l p_music_vblank		; bank $89: 93G p_music_vblank (sound tick)
	stz.b hcount		; clear the IRQ count every frame
	lda.b fadeout
	beq .fadein
	lda.b brightness
	beq .fadeoutdone
	lda.b vcount
	bit.w #$0003		; every 4th frame
	bne .fadein
	dec.b brightness
	bra .fadein
.fadeoutdone:
	stz.b fadeout
.fadein:
	lda.b fadein
	beq .exit
	cmp.w #$0001		; 1 = fading in, >1 = delay first
	bne .fadeindelay
	lda.b brightness
	cmp.w #$000F		; full brightness
	beq .fadeindone
	lda.b vcount
	bit.w #$0003
	bne .exit
	inc.b brightness
	bra .exit
.fadeindelay:
	dec.b fadein
	bra .exit
.fadeindone:
	stz.b fadein
.exit:
	ply
	plx
	pla
	stz.b vbactive		; vblank done
	rti
VBlank_long:		;auto: CODE_80812F. vbint target (set by bank $80E3B3): jml into VBlank so it runs from the FastROM bank $80
	jml.l VBlank
VBlank:		;auto: CODE_808133. 93G VBlank / DumpSprites2+DoDMAList role: forced blank, run DMAList (ch7), BG2 scroll from Hscroll/vramrow/Vscroll, OAM dma from Satt; one shot: sets vbint back to vb2
	sep #$20
	lda.b #$80
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:		;one DMAList entry: VRAM address, length, source, bank, then start ch7 (word writes to VMDATA)
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #$1801
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
.next:		;step back one 7-byte entry; done when below 0
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	lda.w Hscroll
	clc
	adc.w #$00C0		; BG2 h-scroll = Hscroll + 192
	sep #$20
	sta.w BG2HOFS
	xba
	sta.w BG2HOFS
	lda.w Vscroll
	and.b #$07		; fine row
	pha
	rep #$30
	lda.w vramrow
	asl a
	asl a
	asl a		; vramrow*8 | (Vscroll&7)
	sep #$20
	ora.b $01,s
	sta.w BG2VOFS
	xba
	sta.w BG2VOFS
	pla
	rep #$30
	lda.w #$0400		; DMAP7=$00 (A->B, increment), BBAD7=$04 (OAMDATA)
	sta.w DMAP7
	lda.w #Satt
	sta.w A1T7L
	lda.w #$0220		; $220 bytes: 128 sprites + high table
	sta.w DAS7L
	stz.w OAMADDL
	sep #$20
	lda.b #$00
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
	rep #$30
	lda.w #vb2		; one shot: back to vb2 next frame
	sta.b vbint
	jmp.w vb2
VBlank_SprPal:		;auto: CODE_8081C5. vbint target (banks $88/$8F): VBlank, plus CGRAM colors $A0-$BF (sprite palettes 2-3) from palbuffer; one shot, then vb2
	sep #$20
	lda.b #$80
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #$1801
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
.next:
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	lda.w #$0400
	sta.w DMAP7
	lda.w #$01FF
	sta.w A1T7L
	lda.w #$0220
	sta.w DAS7L
	stz.w OAMADDL
	sep #$20
	lda.b #$00
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
	rep #$30
	lda.w #$2200		; DMAP7=$00, BBAD7=$22 (CGDATA)
	sta.w DMAP7
	lda.w #$6DB4		; palbuffer+$140 (color $A0)
	sta.w A1T7L
	lda.w #$0040		; 32 colors
	sta.w DAS7L
	sep #$20
	lda.b #$A0		; sprite palettes 2-3
	sta.w CGADD
	lda.b #$7E
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
	rep #$30
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
VBlank_List:		;auto: CODE_808250. vbint target (bank $8F): forced blank and DMAList only; one shot, then vb2
	sep #$20
	lda.b #$80
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #$1801
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
.next:
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
VBlank_VScroll:		;auto: CODE_808293. vbint target (bank $88): BG1VOFS = d0, then DMAList; one shot, then vb2
	sep #$20
	lda.b #$80
	sta.w INIDISP
	lda.b d0		; BG1VOFS = d0 (low, high)
	sta.w BG1VOFS
	lda.b d0+1
	sta.w BG1VOFS
	ldx.b DMAListend
	bra .next
.dmaloop:
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #$1801
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
.next:
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
VBlank_Cram:		;auto: CODE_8082E0. vbint target (bank $88): DMAList, BG1 fine h-scroll Hscroll&7, BG1VOFS 0, CGRAM 0-127 from palbuffer; then VBlank_CramOnly every frame
	sep #$20
	lda.b #$80
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #$1801
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
.next:
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	sep #$20
	lda.w Hscroll
	and.b #$07
	sta.w BG1HOFS		; BG1HOFS = Hscroll&7
	stz.w BG1HOFS
	stz.w BG1VOFS
	stz.w BG1VOFS
	rep #$30
	lda.w #$2200
	sta.w DMAP7
	lda.w #$6C74		; palbuffer, colors 0-127
	sta.w A1T7L
	lda.w #$0100
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #$7E
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
	rep #$30
	lda.w #VBlank_CramOnly		; from now on: CGRAM every frame
	sta.b vbint
	ldx.w #$0012
.wait:		;short delay before leaving the handler
	dex
	bne .wait
	jmp.w vb2
VBlank_CramOnly:		;auto: CODE_808361. vbint target (stays installed): forced blank, CGRAM 0-127 from palbuffer each frame, then vb2_main
	sep #$20
	lda.b #$80
	sta.w INIDISP
	rep #$30
	lda.w #$2200
	sta.w DMAP7
	lda.w #$6C74
	sta.w A1T7L
	lda.w #$0100
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #$7E
	sta.w A1B7
	lda.b #$80
	sta.w MDMAEN
	rep #$30
	jmp.w vb2
HBjsr:		;auto: CODE_808390. IRQ vector: if TIMEUP set, "rts" into hbint; else HBdefault. No 93G counterpart (Genesis hbint not used this way)
	rep #$30
	pha
	phx
	phy
	sep #$20
	lda.w TIMEUP
	bpl HBdefault		; not a timer IRQ
	rep #$30
	lda.b hbint
	dec a
	pha
	rts
HBdefault:		;auto: CODE_8083A3. default hbint: count hcount, restore regs, rti
	rep #$30
	inc.b hcount
	ply
	plx
	pla
	rti
goalieacc:		;auto: CODE_8083AB. 93G goalieacc (logic93_5): goalie gets acc. in direction d0. Turns facedir one step toward d0, then playeracc
	lda.w #SPAgready		; 93G SPAgready (2)
	sta.b d1
	lda.b d0
	and.w #$000F
	sta.b d0
	cmp.w #$0008		; 8 = no direction
	bcc .d1
	cmp.w #$0009		; 9 = stop
	bne .cgl
	lda.w Xvel,x
	ora.w Yvel,x
	beq .cgl
	jmp.w StopNA		; moving: slow down
.cgl:		;no direction: ready stance unless an animation is in progress
	lda.w pf2aip,x
	bne .rts
	jmp.w SetSPA
.rts:
	rtl
.d1:		;d0 = wanted direction: step facedir one eighth toward it
	sec
	sbc.w facedir,x
	sta.b d0
	beq .spa
	eor.w #$FFFF
	inc a
	and.w #$0004		; one step (+1/-1) toward d0
	lsr a
	dec a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.b d0
	sta.w facedir,x
.spa:
	lda.w #SPAgskate		; 93G SPAgskate $3F8
	sta.b d1
	jsl.l SetSPA
	lda.w facedir,x
	sta.b d2
	jml.l playeracc		; d2 = facedir, bank $8F: 93G playeracc (d2 = direction)
dostop:		;auto: CODE_808404. 93G dostop (logic93_5 IDA loc_D538): player X stops. Stop animation (and sound for the puck carrier) if fast, then StopNA
	lda.w Xvel,x
	bit.w #$8000
	beq .xabs
	eor.w #$FFFF
	inc a
.xabs:
	cmp.w #$1001		; |Xvel| > $1000?
	bcs .set
	lda.w Yvel,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	cmp.w #$1001
	bcc StopNA
.set:		;moving fast: glide (skating backwards) or stop animation
	lda.w #SPAglide		; 93G SPAglide $52C
	sta.b d1
	lda.w pfrev,x		; skating backwards: glide
	bne .setspa
	txa
	lsr a
	cmp.w puckc		; puck carrier: skate stop sound
	bne .stopanim
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXstop
	pha
	jsl.l sfx
.stopanim:
	lda.w #SPAstop		; 93G SPAstop $6E6, pf2aip
	sta.b d1
	sta.w pf2aip,x
.setspa:
	jsl.l SetSPA
StopNA:		;auto: CODE_808452. 93G StopNA (logic93_5): slow player X by $70*d7 on each axis (93G 150), no animation change
	lda.w #$0070		; $70 per frame (93G 150)
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lda.w Xvel,x
	bpl .xp
	clc
	adc.b mulres
	sta.w Xvel,x
	bmi .y
	lda.w #$0000
.xp:
	sec
	sbc.b mulres
	sta.w Xvel,x
	bpl .y
	stz.w Xvel,x
.y:
	lda.w Yvel,x
	bpl .yp
	clc
	adc.b mulres
	sta.w Yvel,x
	bmi .rts
	lda.w #$0000
.yp:
	sec
	sbc.b mulres
	sta.w Yvel,x
	bpl .rts
	stz.w Yvel,x
.rts:
	rtl
muls16:		;auto: CODE_808496. 68k muls.w: A = mula*mulb (signed 16-bit result, also in mula/mulb/mulres); C clear. Signs folded around the unsigned mulu (bank $8D)
	stz.b mula+2		; count the negative operands in mula+2
	lda.b mula
	bpl .bpos
	eor.w #$FFFF
	inc a
	sta.b mula
	inc.b mula+2
.bpos:
	lda.b mulb
	bpl .mul
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mula+2
.mul:
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lsr.b mula+2		; odd count: negate the result
	bcc .rtl
	eor.w #$FFFF
	inc a
	sta.b mula
	sta.b mulb
	sta.b mulres
	clc
.rtl:
	rtl
getpde:		;auto: CODE_8084C4. 93G getpde: d0 = energy of player X (tmpde of its team, entry pnum)
	lda.w pfteam,x
	beq .team
	lda.w #$0002		; a2 = 2: away team
.team:
	sta.b a2
	lda.w pnum,x
	and.w #$00FF		; pnum low byte
	asl a
	sta.b d1
	lda.b a2
	beq .idx
	lda.w #$0034		; away team entries start $34 bytes in
.idx:
	adc.b d1
	tay
	lda.w tmpde,y
	sta.b d0
rtss:		;auto (inside CODE_8084C4). 93G rtss: the rtl that ends getpde, also used as a do-nothing callback (lda #rtss for skateto)
	rtl
MaxSpeed:		;93G MaxSpeed (logic93_5): max speed^2 for each leg speed rating level 0-15. SNES ((n+20)*266)^2 (93G 275)
	dd (20*266)*(20*266)
	dd (21*266)*(21*266)
	dd (22*266)*(22*266)
	dd (23*266)*(23*266)
	dd (24*266)*(24*266)
	dd (25*266)*(25*266)
	dd (26*266)*(26*266)
	dd (27*266)*(27*266)
	dd (28*266)*(28*266)
	dd (29*266)*(29*266)
	dd (30*266)*(30*266)
	dd (31*266)*(31*266)
	dd (32*266)*(32*266)
	dd (33*266)*(33*266)
	dd (34*266)*(34*266)
	dd (35*266)*(35*266)
check4bench:		;auto: CODE_808527 (asscenter*, assdef*, asswing* ... call it with jsl). 93G check4bench (logic93_1): should player X go to the bench? Pops its return address when it takes over
	lda.w pflags,x
	bit.w #pfjoycon|pf2pen		; joystick controlled, or penalty (93G btst #4,pflags2)
	bne .rts
	lda.w newpos,x
	bpl .b		; newpos negative: only a new roster player counts
	lda.w newpnum,x
	bmi .rts
.b:		;newpos or newpnum requested
	lda.w newpnum,x
	cmp.w pnum,x		; same roster player: just a position change
	beq .samepl
	txa		; current assignment: asslist+X*4+assnum
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #abench		; already going to the bench
	beq .rts
	txa
	lsr a
	cmp.w puckc		; puck carrier stays
	beq .rts
	sep #$20		; pop the jsl return address (93G addq #4,sp)
	pla
	rep #$30
	pla
	lda.w pflags,x
	ora.w #pf2unav		; pf2unav
	sta.w pflags,x
	stz.w temp1,x
	lda.w #abench		; abench
	sta.b d0
	jmp.w assreplace
.rts:
	rtl
.samepl:		;same roster player: just change position (93G .samepl)
	sep #$20		; pop the jsl return address
	pla
	rep #$30
	pla
	lda.w pflags,x
	and.w #~pf2unav&$FFFF		; clear pf2unav
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w position,x		; d0 = position (newpos is negative here)
	sta.b d0
	jmp.w Setplass
checkob:		;auto: CODE_808598. 93G checkob (logic93_4): bring up the little warning ref if a player on your team is over the blue line. Called from doinput and asspuckc
	lda.w gmode
	bit.w #gmoffs		; offsides off: nothing to do
	bne .push
	jmp.w .rts
.push:		;movem d0-d1/a0 to the stack
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
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	lda.w #$0005
	sta.b d0
	stz.b a0
	cpx.w #$000C		; a0 = first object of the own team
	bcc .side
	lda.w #$000C
	sta.b a0
.side:		;d1 = blue line y ($5C), negated for the bottom goal
	lda.w #$5C		; blue line y (93G $5C)
	sta.b d1
	lda.w pfgoal,x
	bne .top
	lda.w #-$5C
	sta.b d1
	sec
	sbc.w pucky		; puck not in this zone: no offside
	beq .bottom
	bmi .v1
	bvs .bottom
	bra .nob
.v1:
	bvs .nob
.bottom:		;any teammate below the blue line?
	ldy.b a0
	lda.w position,y
	bmi .bn
	lda.b d1
	sec
	sbc.w Ypos,y
	beq .bn
	bmi .v2
	bvs .bn
	bra .ob
.v2:
	bvs .ob
.bn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .bottom
.nob:		;no player offside: clear the offside signal, ref away
	lda.w #$0040		; 93G d0 = $40
	sta.b d0
	lda.w #sf2offsig
	trb.w sflags		; sf2offsig
	bne .dref
.ex:		;movem the registers back
	stx.b xsave
	ldx.w #$0002
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
.rts:
	rtl
.ob:		;offside: set the signal, ref up
	lda.w #$0006		; 93G d0 = 6
	sta.b d0
	lda.w #sf2offsig
	tsb.w sflags
	bne .ex
.dref:
	lda.w RefCnt		; ref idle? then bring him up
	bpl .ex
	jsl.l PushRef		; bank $8F: 93G PushRef
	bra .ex
.top:
	lda.b d1
	sec
	sbc.w pucky
	bmi .v3
	bvc .top1
	bra .nob
.v3:
	bvc .nob
.top1:
	ldy.b a0
	lda.w position,y
	bmi .tn
	lda.b d1
	sec
	sbc.w Ypos,y
	bmi .v4
	bvc .tn
	bra .ob
.v4:
	bvc .ob
.tn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .top1
	bra .nob
chk4lc:		;auto: CODE_808681. 93G chk4lc (logic93_3): should the computer call a line change? Then shoot the puck in (CompShoot)
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .gu
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.gu:
	lda.b d0
	bmi .rts
	sec
	sbc.w #blueline		; blueline
	beq .inzone
	bmi .v1
	bvs .inzone
	bra .rts
.v1:
	bvs .rts
.inzone:		;in own half, inside the blue line
	lda.w seed
	and.w #$0003		; one time in four
	bne .rts
	lda.w pflags,x
	bit.w #pf2lcm		; pf2lcm
	bne .rts
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .teams
	stz.b a1
	lda.w #$0002
	sta.b a2
.teams:		;a2 = own team, a1 = other team
	jsl.l AvgCline
	lda.b d0
	cmp.w #$0C01		; average energy of the line still above $C00: no change
	bcs .rts
	jsl.l CompLine		; bank $8F: 93G CompLine
	jsl.l setpersonel
	jsl.l printscores1		; bank $89: 93G printscores1
	jmp.w CompShoot
.rts:
	rtl
chk4shot:		;auto: CODE_8086E3. 93G chk4shot (logic93_3): computer player X looks for a shot. Called from asspuckc
	jsl.l chkpk
	bne .npk
	lda.w threat		; threat on the puck carrier
	beq .npk
	lda.w Ypos,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	cmp.w #$00ED		; in front of the net
	bcs .npk
	lda.w seed		; one time in four: clear the puck
	and.w #$0003
	bne .npk
	jmp.w CompShoot
.npk:		;d4 = shot odds ($20-spodds)*16
	lda.w #$0020
	sec
	sbc.w spodds,x
	asl a
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #blueline+goalline		; blueline+goalline
	sta.b d1
	lda.w pfgoal,x
	bne .c0
	lda.w #-(blueline+goalline)
	sta.b d1
.c0:
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w puckx
	eor.w #$FFFF
	inc a
	sta.b mula
	sta.b mulb
	pha
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b tmp0
	lda.b mulres+2
	adc.b d0+2
	sta.b tmp1
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b tmp0
	cmp.w #$2711		; distance^2 > 100*100?
	lda.b tmp1
	sbc.w #$0000
	bcs .no1
	lsr.b d4
	lsr.b d4
	lsr.b d4
	lsr.b d4
	jsl.l vtoa
	sta.b d5
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcs .co0
	lda.w #$000C
	sta.b a1
.co0:		;each opponent: a defender in the shot line doubles d4; a busy goalie means shoot now
	ldy.b a1
	lda.w position,y
	beq .gl
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	jsl.l vtoa
	cmp.b d5
	bne .co1
	asl.b d4
	bra .co1
.gl:
	lda.w pf2aip,y
	beq .co1
	stz.b d3
	lda.w #$0001
	sta.b d4
.co1:
	inc.b a1
	inc.b a1
	dec.b d3
	bpl .co0
.no1:
	lda.b d4
	jsl.l randoma
	cmp.w #$0009		; no shot if random(d4) > 8
	bcs .rts
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .ds0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.ds0:
	lda.b d0
	bmi .rts
	lda.w #blueline+goalline
	sec
	sbc.b d0
	bmi .rts
	lda.w sflags		; sf2offsig: player is offside
	bit.w #sf2offsig
	bne .rts
	bra CompShoot
.rts:
	rtl
CompShoot:		;auto: CODE_8087F7. 93G CompShoot (logic93_3): computer player X shoots. Pops the caller (addq #4,sp), temp2b = swing time, assignment ashoot
	pla		; pop the caller (93G addq #4,sp)
	sep #$20
	pla
	rep #$30
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .ds0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.ds0:
	lda.w #blueline+goalline		; swing time = (blueline+goalline - y)/8, max 20
	sec
	sbc.b d0
	lsr a
	lsr a
	lsr a
	sta.b d1
	cmp.w #$0014
	bcc .lt
	lda.w #$0014
	sta.b d1
.lt:
	stz.w temp2,x
	lda.b d1
	sta.w temp2b,x
	lda.w #ashoot		; ashoot
	sta.b d0
	jmp.w assreplace
assnearest:		;auto: CODE_808834 (asstab $11). 93G assnearest (logic93_4): assignment for the player nearest the puck who does not have it
	lda.w pflags,x
	bit.w #pfna		; pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp3,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	stz.w temp1,x
.nna:
	txa
	lsr a
	sta.b d1
	cmp.w puckc		; X has the puck?
	bne .nopc
	lda.w position,x
	bne .pc
	jmp.w assgoalie
.pc:
	lda.w #apuckc		; apuckc unless joystick controlled
	sta.b d0
	lda.w pflags,x
	bit.w #pfjoycon
	bne .rts
	jmp.w assinsert
.rts:
	rtl
.nopc:		;every aioff frames: find the teammate nearest the (moving) puck
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	adc.w aioff,x		; reload temp1 from aioff
	bpl .setcnt
	lda.w #$0000
.setcnt:
	sta.w temp1,x
	ldy.b a2
	lda.w #$0000		; tmnear = 0
	sta.w tmnear,y
	sta.w tmnear+4,y
	lda.w puckc
	bmi .np
	asl a
	sta.b a1
	tay
	lda.w pfteam,y		; puck carrier on my team?
	beq .pcteam
	lda.w #$0001
.pcteam:
	sta.b tmp0
	lda.w pfteam,x
	beq .myteam
	lda.w #$0001
.myteam:
	eor.b tmp0
	bne .np
	jmp.w .switch
.np:
	lda.w #$FFFF		; d2 = best distance^2 = $FFFFFFFF
	sta.b d2
	sta.b d2+2
	lda.w #$0005
	sta.b d4
	ldy.b a2
	lda.w tmsort,y		; a0 = first object of the team
	sta.b a0
.de0:
	ldy.b a0
	lda.w position,y
	bpl .pos
	jmp.w .next
.pos:
	bne .nop
	jmp.w .next
.nop:
	lda.w nopuck,y
	beq .unav
	jmp.w .next
.unav:
	lda.w pflags,y
	bit.w #pf2unav
	beq .pass
	jmp.w .next
.pass:
	tya
	asl a
	asl a
	adc.w assnum,y
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #apassrec		; skip a player on apassrec
	bne .dist
	jmp.w .next
.dist:
	lda.b a0
	jsl.l GetHot
	ldy.b a0
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	lda.w puckvx		; lead the puck: puckvx/64
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .vx
	ora.w #$FC00
.vx:
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .vy
	ora.w #$FC00
.vy:
	sta.b d3
	lda.b d1
	sec
	sbc.b d3
	sta.b d1
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	lda.b d2		; nearer?
	cmp.b d0
	lda.b d2+2
	sbc.b d0+2
	bcc .next
	lda.b d0
	sta.b d2
	lda.b d0+2
	sta.b d2+2
	lda.b a0
	sta.b a1
.next:
	inc.b a0
	inc.b a0
	dec.b d4
	bmi .done
	jmp.w .de0
.done:
	lda.b d2+2
	bmi .de1
	ldy.b a2
	sta.w tmnear+4,y		; tmnear = nearest distance^2
	lda.b d2
	sta.w tmnear,y
.switch:		;if another player is nearer: give him anearest and leave
	cpx.b a1
	beq .de1
	lda.w gmclock		; clock stopped
	bne .de1
	ldy.b a1
	lda.w pflags,y
	bit.w #pf2unav
	bne .de1
	ldx.b a1		; exg a1,a3 (X = a1)
	ldy.b a3
	stx.b a3
	sty.b a1
	lda.w pflags,x
	and.w #~pfdoff&$FFFF		; clear pfdoff
	sta.w pflags,x
	lda.w #anearest		; anearest
	sta.b d0
	jsl.l assinsert
	ldx.b a1		; exg back
	ldy.b a3
	stx.b a3
	sty.b a1
	jmp.w assexit
.de1:
	lda.w pfalock,x
	beq .odds
	jmp.w .rts
.odds:
	lda.w #$0002
	sta.b d1
	lda.b d2
	cmp.w #$0191		; 20^2
	bcs .nfar
	stz.b d1
	lda.w position,x
	cmp.w #$0003
	bcc .nodec
.nfar:
	lda.w sflags
	bit.w #sf2pwrplay		; sf2pwrplay
	beq .x
	dec.b d1
	dec.b d1
	jsl.l chkpk2
	bne .x
	inc.b d1
	inc.b d1
	inc.b d1
	inc.b d1
.x:
	lda.w #$0014		; ($14-aggress) << d1
	sec
	sbc.w aggress,x
	sta.b d0
	lda.b d1
	sta.b tmp0
.shl:
	dec.b tmp0
	bmi .rnd
	asl.b d0
	bra .shl
.rnd:
	jsl.l randomd0
	lda.b d0
	cmp.w #$0002
	bcs .nodec
	lda.w #$00F0		; temp3 = 240
	sta.w temp3,x
.nodec:
	lda.w pfalock,x
	beq .clk
	jmp.w .rts
.clk:
	lda.w gmclock
	beq .joy
	jml.l assnothing		; bank $8F: 93G assnothing
.joy:
	lda.w pflags,x
	bit.w #pfjoycon
	beq .mode
	jmp.w .rts
.mode:
	ldy.b a2
	lda.w tmflags,y		; tmfmid: always the in-between spot
	bit.w #tmfmid
	bne .mid
	lda.w puckc
	bpl .cnt
	jmp.w .topuck
.cnt:
	lda.w temp3,x
	sec
	sbc.b d7
	sta.w temp3,x
	bmi .clr
	jmp.w .topuck
.clr:
	stz.w temp3,x
.mid:		;skate to halfway between the puck spot and the own goal mouth (0,+-$F4)
	jsl.l skatetopuckinit		; bank $8B: 93G skatetopuckinit (d0/d1 = puck spot)
	lda.b d1
	pha
	lda.b d0
	pha
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00F4		; own goal mouth y $F4
	sta.b d1
	lda.w pfgoal,x
	beq .half
	lda.b d1
	sec
	sbc.w #$01E8		; $1E8 = 2*$F4 for the top goal
	sta.b d1
.half:
	lda.b d0
	pha
	asl a		; asr #1
	pla
	ror a
	sta.b d0
	lda.b d1
	pha
	asl a
	pla
	ror a
	sta.b d1
	pla
	clc
	adc.b d0
	sta.b d0
	pla
	clc
	adc.b d1
	sta.b d1
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfmid
	beq .go
	lda.w pfgoal,x
	beq .neg
	lda.b d1
	sec
	sbc.w #$0053
	bmi .v1
	bvc .clamp1
	bra .go
.v1:
	bvc .go
.clamp1:
	lda.w #$0044
	sta.b d1
	bra .go
.neg:
	lda.b d1
	sec
	sbc.w #$FFAD
	beq .clamp2
	bmi .v2
	bvs .clamp2
	bra .go
.v2:
	bvs .go
.clamp2:
	lda.w #$FFBC
	sta.b d1
.go:
	lda.w #rtss		; a0 = rtss: nothing to do on arrival
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jsl.l skateto		; bank $88: 93G skateto (d0/d1 = spot, [a0] = arrival routine)
	jmp.w check4check
.topuck:
	jsl.l skatetopuck
	jmp.w check4check
check4check:		;auto: CODE_808B15. 93G check4check (logic93_4): look for a good chance to check an opponent. Falls in from assnearest; also entered from assfwatch and asswingd
	lda.w #$0014
	sec
	sbc.w aggress,x
	sta.b d0
	lda.w OptPen		; penalties on: half the chance
	beq .nopen
	asl.b d0
.nopen:
	lda.b d0
	jsl.l randoma
	cmp.w #$0004
	bcc .go
	lda.b d0
	jsl.l randoma
	cmp.w #$0004
	bcs .rts
.go:
	lda.w #$0005
	sta.b d2
	stz.b a0
	cpx.w #$000C
	bcs .loop
	lda.w #$000C
	sta.b a0
.loop:		;each opponent within 30 pixels in the facing direction
	ldy.b a0
	lda.w position,y
	beq .next
	lda.w pfalock,y
	bne .next
	lda.w pf2fight,y
	bne .next
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$001F
	bcs .next
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$001F
	bcs .next
	jsl.l vtoa
	lda.b d0
	cmp.w facedir,x		; opponent in the facing direction
	bne .next
	lda.w seed+3		; random: 1 in 4 hold, else check
	and.w #$0003
	sta.b d0
	bne burst
	jml.l Acheck		; bank $8F: 93G Acheck
.next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .loop
.rts:
	rtl
burst:		;auto: CODE_808BAD. 93G burst (logic93_1): check button: speed burst in the facing direction (costs energy), lock in SPAburst. Also entered from check4check
	jsl.l getpde
	lda.w OptLine		; line changes off: no energy cost
	bne .spd
	lda.b d0
	sec
	sbc.w #$00CC		; $1000/20
	sta.b d0
	jsl.l setpde		; bank $8F: 93G setpde
.spd:		;speed = energy*$233/$10000 (93G energy/128)
	lda.b d0
	sta.b mula
	lda.w #$0233
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2
	sta.b mulb
	pha
	lda.w facedir,x
	asl a
	asl a
	tay
	lda.w #$AE36		; dirtab (bank $80)
	sta.b a0
	lda.w #$0080
	sta.b a0+2
	lda.b [a0],y
	iny
	iny
	sta.b mula
	jsl.l muls16
	adc.w Xvel,x
	sta.w Xvel,x
	lda.b [a0],y
	sta.b mula
	pla
	sta.b mulb
	jsl.l muls16
	adc.w Yvel,x
	sta.w Yvel,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	sta.b tmp0
	lda.w Xvel,x
	bit.w #$8000
	beq .xabs
	eor.w #$FFFF
	inc a
.xabs:
	clc
	adc.b tmp0
	sta.w pspeed,x		; |Xvel|+|Yvel|
	lda.w #SPAburst		; 93G SPAburst $C7E, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
skatetopuck:		;auto: CODE_808C2D. 93G skatetopuck (logic93_5): player X skates to the puck. d7 = elapsed frames
	jsl.l skatetopuckinit		; bank $8B: 93G skatetopuckinit (d0/d1 = puck spot)
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .aim
	jmp.w .ex
.aim:		;every 10 frames: aim at the puck (avoid the goal), maybe sweep check
	adc.w #$0009		; +10
	sta.w temp2,x
	jsl.l avdgoal		; bank $8D: 93G avdgoal
	lda.b d1
	pha
	lda.b d0
	pha
	txa
	jsl.l GetHot
	lda.b d0
	eor.w #$FFFF
	inc a
	sec
	sbc.w Xvel+1,x		; - high byte of Xvel
	and.w #$00FF
	bit.w #$0080
	beq .vx
	ora.w #$FF00
.vx:
	clc
	adc.b $01,s
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sec
	sbc.w Yvel+1,x		; - high byte of Yvel
	and.w #$00FF
	bit.w #$0080
	beq .vy
	ora.w #$FF00
.vy:
	clc
	adc.b $03,s
	sec
	sbc.w Ypos,x
	sta.b d1
	pla
	pla
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x		; temp2b = direction to the puck
	lda.w position,x
	beq .ex		; goalie skips the sweep check
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	lda.b d0
	eor.w #$0004		; puck coming toward the player
	cmp.w facedir,x
	beq .ex
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	pha
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	pha
	jsl.l vtoa
	lda.b d0
	sta.b tmp0
	pla
	sta.b d0
	sta.b mula
	sta.b mulb
	pla
	sta.b d1
	lda.w facedir,x
	cmp.b tmp0
	bne .ex
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0
	cmp.w #$0385		; 30*30
	lda.b d0+2
	sbc.w #$0000
	bcc .ex
	lda.b d0
	cmp.w #$05A5		; 38*38
	lda.b d0+2
	sbc.w #$0000
	bcc Sweepcheck
.ex:
	lda.w temp2b,x
	sta.b d0
	lda.w position,x
	beq .acc
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b tmp0
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	clc
	adc.b tmp0
	cmp.w #$0036		; close to the puck (SNES only): slow down, Xvel*7/8, Yvel*7/16
	bcs .acc
	lda.w Xvel,x
	sta.b mula
	lda.w #$0007
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #$0007
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Yvel,x
.acc:
	jml.l doplayeracc		; bank $8F: 93G doplayeracc (d0 = direction)
Sweepcheck:		;auto: CODE_808D8A. 93G Sweepcheck (logic93_1): start a sweep check on player X
	lda.w #SPAsweepchk		; 93G SPAsweepchk $B44, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
chkpk:		;auto: CODE_808D95. 93G chkpk (logic93_3): Z set if player X is killing a penalty. No power play returns NE
	lda.w sflags
	and.w #sf2pwrplay		; sf2pwrplay
	bne chkpk2
	inc a
	rtl
chkpk2:		;auto: CODE_808D9F. 93G chkpk2 (logic93_3): Z set if player X is on the short-handed team (sf2pwrtm vs pfteam)
	lda.w pfteam,x
	bne .team2
	lda.w sflags
	and.w #sf2pwrtm		; sf2pwrtm
	eor.w #sf2pwrtm
	rtl
.team2:
	lda.w sflags
	and.w #sf2pwrtm
	rtl
assshoot:		;auto: CODE_808DB5 (asstab $12). 93G assshoot (logic93_4): assignment for computer shooting
	lda.w pflags,x
	bit.w #pfna		; pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	bra SetShotMode
.nna:
	lda.w sflags
	bit.w #sfssdir		; sfssdir
	bne .swing
	jmp.w assexit
.swing:		;count down the swing time; then press the shot button (d2 = cbut)
	lda.w temp1,x
	sta.b d0
	stz.b d2
	lda.w temp2b,x
	sec
	sbc.b d7
	sta.w temp2b,x
	bpl ShotMode
	lda.w #cbut
	tsb.b d2
	bra ShotMode
SetShotMode:		;auto: CODE_808DE9. 93G SetShotMode (logic93_1): start a shot by player X: shot mode, direction to goal, shot animation
	lda.w #$0008		; default shot direction: none
	sta.w passdir
	lda.w #sfssdir
	tsb.w sflags
	stz.b d0
	lda.w #$0128		; $128: goal y + 40
	sta.b d1
	lda.w pfgoal,x
	bne .ck0
	lda.w #$FED8
	sta.b d1
.ck0:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.w #$000F		; minimum shot speed
	sta.w passspeed
	lda.w #SPAshotf		; 93G SPAshotf $81C
	sta.b d1
	jsl.l Findhittype		; bank $8F: 93G Findhittype (Z = forehand)
	beq .ck1
	lda.w #SPAshotb		; 93G SPAshotb $94E
	sta.b d1
.ck1:
	jmp.w SetSPA
ShotMode:		;auto: CODE_808E33. 93G ShotMode (logic93_1): shot input. d0 = dpad, d2 = changed buttons. Falls into doshot at the end of the animation
	lda.w SPAnum,x
	cmp.w #$0018		; 7*4: end of the animation
	bcs doshot
	lda.b d0
	bit.w #$0008
	bne .ss0
	and.w #$0007
	sta.w passdir
.ss0:
	lda.w SPAnum,x
	cmp.w #$0010		; 4*4: past full windup
	bcs .rts
	lda.w passspeed
	clc
	adc.b d7
	sta.w passspeed
	lda.b d2
	bit.w #cbut		; button released
	beq .rts
	lda.w #$001C		; end the windup and swing through
	sec
	sbc.w SPAnum,x
	sta.w SPAnum,x
	cmp.w #$0018
	bcc .rts
	lda.w #$0018
	sta.w SPAnum,x
	bra doshot
.rts:
	rtl
doshot:		;auto: CODE_808E78. 93G doshot (logic93_1): stick is at the puck, launch it toward the goal
	stx.b xsave
	ldx.w #$0000
.pushd:		;movem d0-d7/a0-a3 to the stack
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
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
	jsl.l checkgoalp_CalcGoalShotDir
	lda.w seed		; sound: wiff (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	lda.w #sfssdir
	trb.w sflags		; sfssdir off, pfalock on
	sta.w pfalock,x
	txa
	lsr a
	sta.w shotplayer
	cmp.w puckc		; wiffed shot
	beq .hit
	jmp.w .ex
.hit:		;player has the puck: shot taken
	lda.w #SFXshotfh		; forehand shot sound
	sta.b $01,s
	lda.w #sf2shot		; sf2shot
	tsb.w sflags
	lda.w SPA,x
	cmp.w #SPAshotb
	bne .nbh
	lda.w #SFXshotbh		; backhand: sound, 25% less speed
	sta.b $01,s
	lda.w passspeed
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w passspeed
	sta.w passspeed
.nbh:
	lda.w passspeed
	cmp.w #$0032		; hard shot sound
	bcc .speed
	lda.w #SFXshothard
	sta.b $01,s
.speed:		;passspeed = passspeed*(makepde(shotspd)+$14)*$2570/$10000
	lda.w shotspd,x
	sta.b d0
	stx.b a0
	jsl.l makepde
	adc.w #$0014
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lda.w #$2570
	sta.b mula
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2
	sta.w passspeed
	lda.w #$FFFF		; puck loose
	sta.w puckc
	lda.w #$0010		; no puck pickup for 16 frames
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	lda.w #blueline+goalline
	sta.b d1
	lda.w pfgoal,x
	bne .dir
	lda.w #-(blueline+goalline)
	sta.b d1
.dir:		;d0/d1 = shotsets[passdir] - puck, d2 = height; d3 = distance to the goal
	lda.w passdir
	asl a
	asl a
	tay
	lda.w #shotsets
	sta.b a0
	lda.w #shotsets>>16
	sta.b a0+2
	lda.b [a0],y
	sec
	sbc.w puckx
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d2
	pha
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.b d0
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot
	bne .dist
	inc a
.dist:
	sta.b d3
	lda.w gmode
	bit.w #gmhl		; gmhl: highlights are always perfect
	beq .chkperf
	jmp.w .perf
.chkperf:
	lda.b d3
	cmp.w #$00C9		; too far away for a perfect shot
	bcs .notperf
	lda.w #$0010
	adc.w shotacc,x
	jsl.l randoma
	cmp.w #$000F		; chance of a perfect shot
	bcs .perf
.notperf:		;aim error from passspeed, shotacc and distance
	lda.w passspeed
	lsr a
	lsr a
	lsr a
	sec
	sbc.w shotacc,x
	clc
	adc.w #$0010
	sta.b mulb
	lda.b d3
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.b d3
	cmp.w #$00FB		; closer than 251: half the error
	bcs .cp
	lsr.b d0
.cp:
	lda.b d0
	cmp.w #$0088		; clamp $88
	bcc .ar
	lda.w #$0088
	sta.b d0
.ar:
	lda.b d0
	pha
	jsl.l randomd0s
	adc.b $03,s
	sta.b $03,s
	lda.b $01,s
	sta.b d0
	cmp.w #$003D		; max 60
	bcc .ay
	lda.w #$003C
	sta.b d0
	sta.b $01,s
.ay:
	lda.b $05,s
	bpl .am
	lsr.b d0
.am:
	jsl.l randomd0sd0		; bank $8F: 93G randomd0s on d0
	lda.b $05,s
	adc.b d0
	sta.b $05,s
	pla
	lsr a
	jsl.l randoma
	adc.b $05,s
	sta.b $05,s
.perf:		;puckvx/puckvy = passspeed*$44*dx/d3 and dy/d3; puckvz from the height
	lda.w passspeed
	sta.b mulb
	lda.w #$0044		; 1024/15
	sta.b mula
	jsl.l muls16
	pla
	sta.b mula
	jsl.l muls32
	lda.b d3
	sta.b mula
	jsl.l divs
	asl a
	sta.w puckvx
	lda.w passspeed
	sta.b mulb
	lda.w #$0044
	sta.b mula
	jsl.l muls16
	pla
	sta.b mula
	jsl.l muls32
	lda.b d3
	sta.b mula
	jsl.l divs
	asl a
	sta.w puckvy
	pla
	beq .ex
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lda.w #$0044
	sta.b mula
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.b d3
	sta.b mula
	jsl.l divu
	asl a
	sta.b d1
	lda.w #$0B33
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l mulu		; bank $88: mulu, mulres = mula*mulb
	lda.w passspeed
	sta.b mula
	jsl.l divu
	lsr a
	adc.b d1
	cmp.w #$1801
	bcc .noup
	lda.w #$1800		; max $1800
.noup:
	sta.w puckvz
.ex:		;play the sound, movem the registers back
	jsl.l sfx
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
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	lda.w #blueline+goalline		; puckvy sign toward the shooting goal
	sta.b tmp0
	lda.w pfgoal,x
	bne .side
	lda.w #-(blueline+goalline)
	sta.b tmp0
.side:
	lda.b tmp0
	sec
	sbc.w pucky
	eor.w puckvy
	bpl .rtl
	lda.w puckvy
	eor.w #$FFFF
	inc a
	sta.w puckvy
.rtl:
	rtl
shotsets:		;93G doshot .shotsets: x offset, height for each shot direction 0-8
	dw 0,$C,$10,$C		; 0: straight, high; 1
	dw $10,6,$10,0		; 2; 3
	dw 0,0,-$10,0		; 4; 5
	dw -$10,6,-$10,$C		; 6; 7
	dw 0,6		; 8: no direction
