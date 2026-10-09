; $808000-$80910E  ROM $00000-$0110E: reset, vblank/irq handlers, and the start of the player logic (93G logic93_5 / logic93_1 /
; logic93_3 / logic93_4 routines). The 68k registers of 93G are DP pseudo registers (d0 = $53 ... a3 = $3F, see ram93snes.asm);
; X = SCnum*2 of the current object (93G a3). Out-of-bank or later-segment calls keep their address with the 93G name in the comment.
org $808000

Start:		;auto: CODE_808000. 93G main93 Start + hockey93_01 Begin (RAM clear). Reset vector. Native mode, stack $1FFF, D=0, DB=$00; clears DP/RAM, sets vbint/hbint, inits the sprite tile cache, checks the ROM sum, inits hardware/sound, then the title screen
	sei		; $808000: 78  interrupts off
	clc		; $808001: 18
	xce		; $808002: FB  native mode
	rep #$30		; $808003: C2 30
	lda.w #$1FFF		; $808005: A9 FF 1F
	tcs		; $808008: 1B  stack $1FFF
	lda.w #$0000		; $808009: A9 00 00
	tcd		; $80800C: 5B  D = 0
	sep #$20		; $80800D: E2 20
	pha		; $80800F: 48
	plb		; $808010: AB  DB = $00 (low RAM and registers)
	rep #$30		; $808011: C2 30
	ldx.w #$0000		; $808013: A2 00 00
.clrdp:		;clear $0000-$164D (DP and low RAM)
	stz.b vcount,x		; $808016: 74 00
	inx		; $808018: E8
	inx		; $808019: E8
	cpx.w #DPCLEAREND		; $80801A: E0 4E 16
	bcc .clrdp		; $80801D: 90 F7
	lda.w #vb2_blank		; $80801F: A9 CE 80
	sta.b vbint		; $808022: 85 14
	lda.w #HBdefault		; $808024: A9 A3 83
	sta.b hbint		; $808027: 85 16
	lda.w #JMLOPCODE		; $808029: A9 5C 00  jml opcode for the jmlvector trampoline
	sta.w jmlvector		; $80802C: 8D 78 01
	lda.w #$0012		; $80802F: A9 12 00  sprite VRAM slots stay reserved 18 frames
	sta.b sprslotlife		; $808032: 85 C1
	lda.b sprclock		; $808034: A5 A7
	sec		; $808036: 38
	sbc.w #$003C		; $808037: E9 3C 00  60 frames ago
	ldx.w #$0000		; $80803A: A2 00 00
.clrcache:		;sprframetime: every frame "sent 60 frames ago" (sprclock-$3C), so every cached frame is stale
	sta.l sprframetime,x		; $80803D: 9F 00 20 7E
	inx		; $808041: E8
	inx		; $808042: E8
	cpx.w #$4C74		; $808043: E0 74 4C
	bne .clrcache		; $808046: D0 F5
	ldx.w #$0000		; $808048: A2 00 00
.clrslots:		;sprslottime ($04AB-$08AA): every VRAM sprite slot free
	sta.w sprslottime,x		; $80804B: 9D AB 04
	inx		; $80804E: E8
	inx		; $80804F: E8
	cpx.w #$0400		; $808050: E0 00 04
	bne .clrslots		; $808053: D0 F6
	lda.w #$0020		; $808055: A9 20 00
	sta.b sprpriority		; $808058: 85 BB
	stz.b tmp0		; $80805A: 64 73  sum = 0
	ldx.w #$0000		; $80805C: A2 00 00
	ldy.w #$0002		; $80805F: A0 02 00  word at +2 of each pointer
.sumloop:		;sum the word at [ptr]+2 for each long ptr in the table at $8FE67D (0-terminated, 4 bytes per entry)
	lda.l $8FE67D,x		; $808062: BF 7D E6 8F
	beq .validate		; $808066: F0 15
	sta.b tmp1		; $808068: 85 75
	lda.l $8FE67D+1,x		; $80806A: BF 7E E6 8F
	sta.b tmp1+1		; $80806E: 85 76
	lda.b [tmp1],y		; $808070: B7 75
	clc		; $808072: 18
	adc.b tmp0		; $808073: 65 73
	sta.b tmp0		; $808075: 85 73
	inx		; $808077: E8
	inx		; $808078: E8
	inx		; $808079: E8
	inx		; $80807A: E8
	bra .sumloop		; $80807B: 80 E5
.validate:		;anti-tamper: hang forever unless the sum is $131D (93G ValidationRoutine role, inline here)
	lda.b tmp0		; $80807D: A5 73
	cmp.w #$131D		; $80807F: C9 1D 13
	bne .validate		; $808082: D0 F9
	lda.w #$0001		; $808084: A9 01 00  hold the sound queue while the hardware/sound driver starts
	sta.b sndlock		; $808087: 85 21
	jsl.l $8D8120		; $808089: 22 20 81 8D  bank $8D: PPU registers off/clear, sound driver start
	sep #$20		; $80808D: E2 20
	cli		; $80808F: 58
	lda.w RDNMI		; $808090: AD 10 42  ack a pending NMI
	lda.b #$81		; $808093: A9 81  NMI on, auto joypad read
	sta.w NMITIMEN		; $808095: 8D 00 42
	rep #$30		; $808098: C2 30
	jsl.l $82FA31		; $80809A: 22 31 FA 82  bank $82: wait until the sound command queue is empty
	stz.b sndlock		; $80809E: 64 21
	stz.b vbactive		; $8080A0: 64 12  vblank handlers may run
	jsl.l $8F9073		; $8080A2: 22 73 90 8F  bank $8F: $1610-$161F = $1E
	jsl.l $8FE32B		; $8080A6: 22 2B E3 8F  bank $8F: 93G DefaultMenus (initial menu choices at $1600)
	jsl.l $84FAD2		; $8080AA: 22 D2 FA 84  bank $84
	jml.l $8B816A		; $8080AE: 5C 6A 81 8B  bank $8B: on to the title screen (93G Opening)
BRKHalt:		;auto: CODE_8080B2. BRK vector: hang. No 92G/93G counterpart (68k traps go to IRQ7 rte)
	bra BRKHalt		; $8080B2: 80 FE
VBjsr:		;auto: CODE_8080B4. 93G VBjsr (hockey93_01, IDA VBLANK). NMI: ack RDNMI, skip if vbactive, else "rts" into the vbint handler
	rep #$30		; $8080B4: C2 30
	pha		; $8080B6: 48
	lda.w RDNMI		; $8080B7: AD 10 42
	bit.w #$0080		; $8080BA: 89 80 00
	beq .skip		; $8080BD: F0 04  not a vblank NMI
	lda.b vbactive		; $8080BF: A5 12
	beq .dispatch		; $8080C1: F0 02
.skip:		;not a vblank NMI, or the last handler still runs
	pla		; $8080C3: 68
	rti		; $8080C4: 40
.dispatch:		;push vbint-1 and rts into it (A/X/Y stay on the stack for the handler to pull)
	inc.b vbactive		; $8080C5: E6 12
	phx		; $8080C7: DA
	phy		; $8080C8: 5A
	lda.b vbint		; $8080C9: A5 14
	dec a		; $8080CB: 3A
	pha		; $8080CC: 48
	rts		; $8080CD: 60
vb2_blank:		;auto: CODE_8080CE. vbint target: vb2 with the screen held in forced blank. Resets hbint to HBdefault
	sep #$20		; $8080CE: E2 20
	lda.b #$80		; $8080D0: A9 80
	sta.w INIDISP		; $8080D2: 8D 00 21
	rep #$30		; $8080D5: C2 30
	lda.w #$83A3		; $8080D7: A9 A3 83
	sta.b hbint		; $8080DA: 85 16
	bra vb2_main		; $8080DC: 80 07
vb2:		;auto: CODE_8080DE. 93G vb2 (video93_1): vblank for fades only, no dma. INIDISP from brightness, then vb2_main
	sep #$20		; $8080DE: E2 20
	lda.b brightness		; $8080E0: A5 04
	sta.w INIDISP		; $8080E2: 8D 00 21
vb2_main:		;auto: CODE_8080E5. common vblank tail: vcount, sound tick (93G p_music_vblank), brightness fades (93G cramfade), rti
	rep #$30		; $8080E5: C2 30
	inc.b vcount		; $8080E7: E6 00
	bne .tick		; $8080E9: D0 02
	inc.b vcount+2		; $8080EB: E6 02
.tick:
	jsl.l $89EB15		; $8080ED: 22 15 EB 89  bank $89: 93G p_music_vblank (sound tick)
	stz.b hcount		; $8080F1: 64 18  clear the IRQ count every frame
	lda.b fadeout		; $8080F3: A5 06
	beq .fadein		; $8080F5: F0 11
	lda.b brightness		; $8080F7: A5 04
	beq .fadeoutdone		; $8080F9: F0 0B
	lda.b vcount		; $8080FB: A5 00
	bit.w #$0003		; $8080FD: 89 03 00  every 4th frame
	bne .fadein		; $808100: D0 06
	dec.b brightness		; $808102: C6 04
	bra .fadein		; $808104: 80 02
.fadeoutdone:
	stz.b fadeout		; $808106: 64 06
.fadein:
	lda.b fadein		; $808108: A5 08
	beq .exit		; $80810A: F0 1D
	cmp.w #$0001		; $80810C: C9 01 00  1 = fading in, >1 = delay first
	bne .fadeindelay		; $80810F: D0 12
	lda.b brightness		; $808111: A5 04
	cmp.w #$000F		; $808113: C9 0F 00  full brightness
	beq .fadeindone		; $808116: F0 0F
	lda.b vcount		; $808118: A5 00
	bit.w #$0003		; $80811A: 89 03 00
	bne .exit		; $80811D: D0 0A
	inc.b brightness		; $80811F: E6 04
	bra .exit		; $808121: 80 06
.fadeindelay:
	dec.b fadein		; $808123: C6 08
	bra .exit		; $808125: 80 02
.fadeindone:
	stz.b fadein		; $808127: 64 08
.exit:
	ply		; $808129: 7A
	plx		; $80812A: FA
	pla		; $80812B: 68
	stz.b vbactive		; $80812C: 64 12  vblank done
	rti		; $80812E: 40
VBlank_long:		;auto: CODE_80812F. vbint target (set by bank $80E3B3): jml into VBlank so it runs from the FastROM bank $80
	jml.l VBlank		; $80812F: 5C 33 81 80
VBlank:		;auto: CODE_808133. 93G VBlank / DumpSprites2+DoDMAList role: forced blank, run DMAList (ch7), BG2 scroll from Hscroll/vramrow/Vscroll, OAM dma from Satt; one shot: sets vbint back to vb2
	sep #$20		; $808133: E2 20
	lda.b #$80		; $808135: A9 80
	sta.w INIDISP		; $808137: 8D 00 21
	ldx.b DMAListend		; $80813A: A6 A3
	bra .next		; $80813C: 80 23
.dmaloop:		;one DMAList entry: VRAM address, length, source, bank, then start ch7 (word writes to VMDATA)
	ldy.w DMAList+dmavram,x		; $80813E: BC 58 16
	sty.w VMADDL		; $808141: 8C 16 21
	ldy.w DMAList+dmalen,x		; $808144: BC 56 16
	sty.w DAS7L		; $808147: 8C 75 43
	ldy.w #$1801		; $80814A: A0 01 18
	sty.w DMAP7		; $80814D: 8C 70 43
	ldy.w DMAList+dmasrc,x		; $808150: BC 53 16
	sty.w A1T7L		; $808153: 8C 72 43
	lda.w DMAList+dmabank,x		; $808156: BD 55 16
	sta.w A1B7		; $808159: 8D 74 43
	lda.b #$80		; $80815C: A9 80
	sta.w MDMAEN		; $80815E: 8D 0B 42
.next:		;step back one 7-byte entry; done when below 0
	dex		; $808161: CA
	dex		; $808162: CA
	dex		; $808163: CA
	dex		; $808164: CA
	dex		; $808165: CA
	dex		; $808166: CA
	dex		; $808167: CA
	bpl .dmaloop		; $808168: 10 D4
	rep #$30		; $80816A: C2 30
	stz.b DMAListend		; $80816C: 64 A3
	lda.w Hscroll		; $80816E: AD 56 01
	clc		; $808171: 18
	adc.w #$00C0		; $808172: 69 C0 00  BG2 h-scroll = Hscroll + 192
	sep #$20		; $808175: E2 20
	sta.w BG2HOFS		; $808177: 8D 0F 21
	xba		; $80817A: EB
	sta.w BG2HOFS		; $80817B: 8D 0F 21
	lda.w Vscroll		; $80817E: AD E1 08
	and.b #$07		; $808181: 29 07  fine row
	pha		; $808183: 48
	rep #$30		; $808184: C2 30
	lda.w vramrow		; $808186: AD 9D 04
	asl a		; $808189: 0A
	asl a		; $80818A: 0A
	asl a		; $80818B: 0A  vramrow*8 | (Vscroll&7)
	sep #$20		; $80818C: E2 20
	ora.b $01,s		; $80818E: 03 01
	sta.w BG2VOFS		; $808190: 8D 10 21
	xba		; $808193: EB
	sta.w BG2VOFS		; $808194: 8D 10 21
	pla		; $808197: 68
	rep #$30		; $808198: C2 30
	lda.w #$0400		; $80819A: A9 00 04  DMAP7=$00 (A->B, increment), BBAD7=$04 (OAMDATA)
	sta.w DMAP7		; $80819D: 8D 70 43
	lda.w #Satt		; $8081A0: A9 FF 01
	sta.w A1T7L		; $8081A3: 8D 72 43
	lda.w #$0220		; $8081A6: A9 20 02  $220 bytes: 128 sprites + high table
	sta.w DAS7L		; $8081A9: 8D 75 43
	stz.w OAMADDL		; $8081AC: 9C 02 21
	sep #$20		; $8081AF: E2 20
	lda.b #$00		; $8081B1: A9 00
	sta.w A1B7		; $8081B3: 8D 74 43
	lda.b #$80		; $8081B6: A9 80
	sta.w MDMAEN		; $8081B8: 8D 0B 42
	rep #$30		; $8081BB: C2 30
	lda.w #vb2		; $8081BD: A9 DE 80  one shot: back to vb2 next frame
	sta.b vbint		; $8081C0: 85 14
	jmp.w vb2		; $8081C2: 4C DE 80
VBlank_SprPal:		;auto: CODE_8081C5. vbint target (banks $88/$8F): VBlank, plus CGRAM colors $A0-$BF (sprite palettes 2-3) from palbuffer; one shot, then vb2
	sep #$20		; $8081C5: E2 20
	lda.b #$80		; $8081C7: A9 80
	sta.w INIDISP		; $8081C9: 8D 00 21
	ldx.b DMAListend		; $8081CC: A6 A3
	bra .next		; $8081CE: 80 23
.dmaloop:
	ldy.w DMAList+dmavram,x		; $8081D0: BC 58 16
	sty.w VMADDL		; $8081D3: 8C 16 21
	ldy.w DMAList+dmalen,x		; $8081D6: BC 56 16
	sty.w DAS7L		; $8081D9: 8C 75 43
	ldy.w #$1801		; $8081DC: A0 01 18
	sty.w DMAP7		; $8081DF: 8C 70 43
	ldy.w DMAList+dmasrc,x		; $8081E2: BC 53 16
	sty.w A1T7L		; $8081E5: 8C 72 43
	lda.w DMAList+dmabank,x		; $8081E8: BD 55 16
	sta.w A1B7		; $8081EB: 8D 74 43
	lda.b #$80		; $8081EE: A9 80
	sta.w MDMAEN		; $8081F0: 8D 0B 42
.next:
	dex		; $8081F3: CA
	dex		; $8081F4: CA
	dex		; $8081F5: CA
	dex		; $8081F6: CA
	dex		; $8081F7: CA
	dex		; $8081F8: CA
	dex		; $8081F9: CA
	bpl .dmaloop		; $8081FA: 10 D4
	rep #$30		; $8081FC: C2 30
	stz.b DMAListend		; $8081FE: 64 A3
	lda.w #$0400		; $808200: A9 00 04
	sta.w DMAP7		; $808203: 8D 70 43
	lda.w #$01FF		; $808206: A9 FF 01
	sta.w A1T7L		; $808209: 8D 72 43
	lda.w #$0220		; $80820C: A9 20 02
	sta.w DAS7L		; $80820F: 8D 75 43
	stz.w OAMADDL		; $808212: 9C 02 21
	sep #$20		; $808215: E2 20
	lda.b #$00		; $808217: A9 00
	sta.w A1B7		; $808219: 8D 74 43
	lda.b #$80		; $80821C: A9 80
	sta.w MDMAEN		; $80821E: 8D 0B 42
	rep #$30		; $808221: C2 30
	lda.w #$2200		; $808223: A9 00 22  DMAP7=$00, BBAD7=$22 (CGDATA)
	sta.w DMAP7		; $808226: 8D 70 43
	lda.w #$6DB4		; $808229: A9 B4 6D  palbuffer+$140 (color $A0)
	sta.w A1T7L		; $80822C: 8D 72 43
	lda.w #$0040		; $80822F: A9 40 00  32 colors
	sta.w DAS7L		; $808232: 8D 75 43
	sep #$20		; $808235: E2 20
	lda.b #$A0		; $808237: A9 A0  sprite palettes 2-3
	sta.w CGADD		; $808239: 8D 21 21
	lda.b #$7E		; $80823C: A9 7E
	sta.w A1B7		; $80823E: 8D 74 43
	lda.b #$80		; $808241: A9 80
	sta.w MDMAEN		; $808243: 8D 0B 42
	rep #$30		; $808246: C2 30
	lda.w #vb2		; $808248: A9 DE 80
	sta.b vbint		; $80824B: 85 14
	jmp.w vb2		; $80824D: 4C DE 80
VBlank_List:		;auto: CODE_808250. vbint target (bank $8F): forced blank and DMAList only; one shot, then vb2
	sep #$20		; $808250: E2 20
	lda.b #$80		; $808252: A9 80
	sta.w INIDISP		; $808254: 8D 00 21
	ldx.b DMAListend		; $808257: A6 A3
	bra .next		; $808259: 80 23
.dmaloop:
	ldy.w DMAList+dmavram,x		; $80825B: BC 58 16
	sty.w VMADDL		; $80825E: 8C 16 21
	ldy.w DMAList+dmalen,x		; $808261: BC 56 16
	sty.w DAS7L		; $808264: 8C 75 43
	ldy.w #$1801		; $808267: A0 01 18
	sty.w DMAP7		; $80826A: 8C 70 43
	ldy.w DMAList+dmasrc,x		; $80826D: BC 53 16
	sty.w A1T7L		; $808270: 8C 72 43
	lda.w DMAList+dmabank,x		; $808273: BD 55 16
	sta.w A1B7		; $808276: 8D 74 43
	lda.b #$80		; $808279: A9 80
	sta.w MDMAEN		; $80827B: 8D 0B 42
.next:
	dex		; $80827E: CA
	dex		; $80827F: CA
	dex		; $808280: CA
	dex		; $808281: CA
	dex		; $808282: CA
	dex		; $808283: CA
	dex		; $808284: CA
	bpl .dmaloop		; $808285: 10 D4
	rep #$30		; $808287: C2 30
	stz.b DMAListend		; $808289: 64 A3
	lda.w #vb2		; $80828B: A9 DE 80
	sta.b vbint		; $80828E: 85 14
	jmp.w vb2		; $808290: 4C DE 80
VBlank_VScroll:		;auto: CODE_808293. vbint target (bank $88): BG1VOFS = d0, then DMAList; one shot, then vb2
	sep #$20		; $808293: E2 20
	lda.b #$80		; $808295: A9 80
	sta.w INIDISP		; $808297: 8D 00 21
	lda.b d0		; $80829A: A5 53  BG1VOFS = d0 (low, high)
	sta.w BG1VOFS		; $80829C: 8D 0E 21
	lda.b d0+1		; $80829F: A5 54
	sta.w BG1VOFS		; $8082A1: 8D 0E 21
	ldx.b DMAListend		; $8082A4: A6 A3
	bra .next		; $8082A6: 80 23
.dmaloop:
	ldy.w DMAList+dmavram,x		; $8082A8: BC 58 16
	sty.w VMADDL		; $8082AB: 8C 16 21
	ldy.w DMAList+dmalen,x		; $8082AE: BC 56 16
	sty.w DAS7L		; $8082B1: 8C 75 43
	ldy.w #$1801		; $8082B4: A0 01 18
	sty.w DMAP7		; $8082B7: 8C 70 43
	ldy.w DMAList+dmasrc,x		; $8082BA: BC 53 16
	sty.w A1T7L		; $8082BD: 8C 72 43
	lda.w DMAList+dmabank,x		; $8082C0: BD 55 16
	sta.w A1B7		; $8082C3: 8D 74 43
	lda.b #$80		; $8082C6: A9 80
	sta.w MDMAEN		; $8082C8: 8D 0B 42
.next:
	dex		; $8082CB: CA
	dex		; $8082CC: CA
	dex		; $8082CD: CA
	dex		; $8082CE: CA
	dex		; $8082CF: CA
	dex		; $8082D0: CA
	dex		; $8082D1: CA
	bpl .dmaloop		; $8082D2: 10 D4
	rep #$30		; $8082D4: C2 30
	stz.b DMAListend		; $8082D6: 64 A3
	lda.w #vb2		; $8082D8: A9 DE 80
	sta.b vbint		; $8082DB: 85 14
	jmp.w vb2		; $8082DD: 4C DE 80
VBlank_Cram:		;auto: CODE_8082E0. vbint target (bank $88): DMAList, BG1 fine h-scroll Hscroll&7, BG1VOFS 0, CGRAM 0-127 from palbuffer; then VBlank_CramOnly every frame
	sep #$20		; $8082E0: E2 20
	lda.b #$80		; $8082E2: A9 80
	sta.w INIDISP		; $8082E4: 8D 00 21
	ldx.b DMAListend		; $8082E7: A6 A3
	bra .next		; $8082E9: 80 23
.dmaloop:
	ldy.w DMAList+dmavram,x		; $8082EB: BC 58 16
	sty.w VMADDL		; $8082EE: 8C 16 21
	ldy.w DMAList+dmalen,x		; $8082F1: BC 56 16
	sty.w DAS7L		; $8082F4: 8C 75 43
	ldy.w #$1801		; $8082F7: A0 01 18
	sty.w DMAP7		; $8082FA: 8C 70 43
	ldy.w DMAList+dmasrc,x		; $8082FD: BC 53 16
	sty.w A1T7L		; $808300: 8C 72 43
	lda.w DMAList+dmabank,x		; $808303: BD 55 16
	sta.w A1B7		; $808306: 8D 74 43
	lda.b #$80		; $808309: A9 80
	sta.w MDMAEN		; $80830B: 8D 0B 42
.next:
	dex		; $80830E: CA
	dex		; $80830F: CA
	dex		; $808310: CA
	dex		; $808311: CA
	dex		; $808312: CA
	dex		; $808313: CA
	dex		; $808314: CA
	bpl .dmaloop		; $808315: 10 D4
	rep #$30		; $808317: C2 30
	stz.b DMAListend		; $808319: 64 A3
	sep #$20		; $80831B: E2 20
	lda.w Hscroll		; $80831D: AD 56 01
	and.b #$07		; $808320: 29 07
	sta.w BG1HOFS		; $808322: 8D 0D 21  BG1HOFS = Hscroll&7
	stz.w BG1HOFS		; $808325: 9C 0D 21
	stz.w BG1VOFS		; $808328: 9C 0E 21
	stz.w BG1VOFS		; $80832B: 9C 0E 21
	rep #$30		; $80832E: C2 30
	lda.w #$2200		; $808330: A9 00 22
	sta.w DMAP7		; $808333: 8D 70 43
	lda.w #$6C74		; $808336: A9 74 6C  palbuffer, colors 0-127
	sta.w A1T7L		; $808339: 8D 72 43
	lda.w #$0100		; $80833C: A9 00 01
	sta.w DAS7L		; $80833F: 8D 75 43
	sep #$20		; $808342: E2 20
	stz.w CGADD		; $808344: 9C 21 21
	lda.b #$7E		; $808347: A9 7E
	sta.w A1B7		; $808349: 8D 74 43
	lda.b #$80		; $80834C: A9 80
	sta.w MDMAEN		; $80834E: 8D 0B 42
	rep #$30		; $808351: C2 30
	lda.w #VBlank_CramOnly		; $808353: A9 61 83  from now on: CGRAM every frame
	sta.b vbint		; $808356: 85 14
	ldx.w #$0012		; $808358: A2 12 00
.wait:		;short delay before leaving the handler
	dex		; $80835B: CA
	bne .wait		; $80835C: D0 FD
	jmp.w vb2		; $80835E: 4C DE 80
VBlank_CramOnly:		;auto: CODE_808361. vbint target (stays installed): forced blank, CGRAM 0-127 from palbuffer each frame, then vb2_main
	sep #$20		; $808361: E2 20
	lda.b #$80		; $808363: A9 80
	sta.w INIDISP		; $808365: 8D 00 21
	rep #$30		; $808368: C2 30
	lda.w #$2200		; $80836A: A9 00 22
	sta.w DMAP7		; $80836D: 8D 70 43
	lda.w #$6C74		; $808370: A9 74 6C
	sta.w A1T7L		; $808373: 8D 72 43
	lda.w #$0100		; $808376: A9 00 01
	sta.w DAS7L		; $808379: 8D 75 43
	sep #$20		; $80837C: E2 20
	stz.w CGADD		; $80837E: 9C 21 21
	lda.b #$7E		; $808381: A9 7E
	sta.w A1B7		; $808383: 8D 74 43
	lda.b #$80		; $808386: A9 80
	sta.w MDMAEN		; $808388: 8D 0B 42
	rep #$30		; $80838B: C2 30
	jmp.w vb2		; $80838D: 4C DE 80
HBjsr:		;auto: CODE_808390. IRQ vector: if TIMEUP set, "rts" into hbint; else HBdefault. No 93G counterpart (Genesis hbint not used this way)
	rep #$30		; $808390: C2 30
	pha		; $808392: 48
	phx		; $808393: DA
	phy		; $808394: 5A
	sep #$20		; $808395: E2 20
	lda.w TIMEUP		; $808397: AD 11 42
	bpl HBdefault		; $80839A: 10 07  not a timer IRQ
	rep #$30		; $80839C: C2 30
	lda.b hbint		; $80839E: A5 16
	dec a		; $8083A0: 3A
	pha		; $8083A1: 48
	rts		; $8083A2: 60
HBdefault:		;auto: CODE_8083A3. default hbint: count hcount, restore regs, rti
	rep #$30		; $8083A3: C2 30
	inc.b hcount		; $8083A5: E6 18
	ply		; $8083A7: 7A
	plx		; $8083A8: FA
	pla		; $8083A9: 68
	rti		; $8083AA: 40
goalieacc:		;auto: CODE_8083AB. 93G goalieacc (logic93_5): goalie gets acc. in direction d0. Turns facedir one step toward d0, then playeracc
	lda.w #SPAgready		; $8083AB: A9 02 00  93G SPAgready (2)
	sta.b d1		; $8083AE: 85 57
	lda.b d0		; $8083B0: A5 53
	and.w #$000F		; $8083B2: 29 0F 00
	sta.b d0		; $8083B5: 85 53
	cmp.w #$0008		; $8083B7: C9 08 00  8 = no direction
	bcc .d1		; $8083BA: 90 19
	cmp.w #$0009		; $8083BC: C9 09 00  9 = stop
	bne .cgl		; $8083BF: D0 0B
	lda.w Xvel,x		; $8083C1: BD DF 0A
	ora.w Yvel,x		; $8083C4: 1D FF 0A
	beq .cgl		; $8083C7: F0 03
	jmp.w StopNA		; $8083C9: 4C 52 84  moving: slow down
.cgl:		;no direction: ready stance unless an animation is in progress
	lda.w pf2aip,x		; $8083CC: BD DF 11
	bne .rts		; $8083CF: D0 03
	jmp.w SetSPA		; $8083D1: 4C 06 B0
.rts:
	rtl		; $8083D4: 6B
.d1:		;d0 = wanted direction: step facedir one eighth toward it
	sec		; $8083D5: 38
	sbc.w facedir,x		; $8083D6: FD BF 0D
	sta.b d0		; $8083D9: 85 53
	beq .spa		; $8083DB: F0 15
	eor.w #$FFFF		; $8083DD: 49 FF FF
	inc a		; $8083E0: 1A
	and.w #$0004		; $8083E1: 29 04 00  one step (+1/-1) toward d0
	lsr a		; $8083E4: 4A
	dec a		; $8083E5: 3A
	clc		; $8083E6: 18
	adc.w facedir,x		; $8083E7: 7D BF 0D
	and.w #$0007		; $8083EA: 29 07 00
	sta.b d0		; $8083ED: 85 53
	sta.w facedir,x		; $8083EF: 9D BF 0D
.spa:
	lda.w #SPAgskate		; $8083F2: A9 44 03  93G SPAgskate $3F8
	sta.b d1		; $8083F5: 85 57
	jsl.l SetSPA		; $8083F7: 22 06 B0 80
	lda.w facedir,x		; $8083FB: BD BF 0D
	sta.b d2		; $8083FE: 85 5B
	jml.l $8FE164		; $808400: 5C 64 E1 8F  d2 = facedir, bank $8F: 93G playeracc (d2 = direction)
dostop:		;auto: CODE_808404. 93G dostop (logic93_5 IDA loc_D538): player X stops. Stop animation (and sound for the puck carrier) if fast, then StopNA
	lda.w Xvel,x		; $808404: BD DF 0A
	bit.w #$8000		; $808407: 89 00 80
	beq .xabs		; $80840A: F0 04
	eor.w #$FFFF		; $80840C: 49 FF FF
	inc a		; $80840F: 1A
.xabs:
	cmp.w #$1001		; $808410: C9 01 10  |Xvel| > $1000?
	bcs .set		; $808413: B0 11
	lda.w Yvel,x		; $808415: BD FF 0A
	bit.w #$8000		; $808418: 89 00 80
	beq .yabs		; $80841B: F0 04
	eor.w #$FFFF		; $80841D: 49 FF FF
	inc a		; $808420: 1A
.yabs:
	cmp.w #$1001		; $808421: C9 01 10
	bcc StopNA		; $808424: 90 2C
.set:		;moving fast: glide (skating backwards) or stop animation
	lda.w #SPAglide		; $808426: A9 78 04  93G SPAglide $52C
	sta.b d1		; $808429: 85 57
	lda.w pfrev,x		; $80842B: BD BF 11  skating backwards: glide
	bne .setspa		; $80842E: D0 1E
	txa		; $808430: 8A
	lsr a		; $808431: 4A
	cmp.w puckc		; $808432: CD BB 0E  puck carrier: skate stop sound
	bne .stopanim		; $808435: D0 0F
	lda.w seed+1		; $808437: AD A2 04
	and.w #$0001		; $80843A: 29 01 00
	clc		; $80843D: 18
	adc.w #SFXstop		; $80843E: 69 9C 00
	pha		; $808441: 48
	jsl.l sfx		; $808442: 22 8B C2 80
.stopanim:
	lda.w #SPAstop		; $808446: A9 72 06  93G SPAstop $6E6, pf2aip
	sta.b d1		; $808449: 85 57
	sta.w pf2aip,x		; $80844B: 9D DF 11
.setspa:
	jsl.l SetSPA		; $80844E: 22 06 B0 80
StopNA:		;auto: CODE_808452. 93G StopNA (logic93_5): slow player X by $70*d7 on each axis (93G 150), no animation change
	lda.w #$0070		; $808452: A9 70 00  $70 per frame (93G 150)
	sta.b mula		; $808455: 85 7D
	lda.b d7		; $808457: A5 6F
	sta.b mulb		; $808459: 85 83
	jsl.l $8D871C		; $80845B: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	lda.w Xvel,x		; $80845F: BD DF 0A
	bpl .xp		; $808462: 10 0B
	clc		; $808464: 18
	adc.b mulres		; $808465: 65 93
	sta.w Xvel,x		; $808467: 9D DF 0A
	bmi .y		; $80846A: 30 0E
	lda.w #$0000		; $80846C: A9 00 00
.xp:
	sec		; $80846F: 38
	sbc.b mulres		; $808470: E5 93
	sta.w Xvel,x		; $808472: 9D DF 0A
	bpl .y		; $808475: 10 03
	stz.w Xvel,x		; $808477: 9E DF 0A
.y:
	lda.w Yvel,x		; $80847A: BD FF 0A
	bpl .yp		; $80847D: 10 0B
	clc		; $80847F: 18
	adc.b mulres		; $808480: 65 93
	sta.w Yvel,x		; $808482: 9D FF 0A
	bmi .rts		; $808485: 30 0E
	lda.w #$0000		; $808487: A9 00 00
.yp:
	sec		; $80848A: 38
	sbc.b mulres		; $80848B: E5 93
	sta.w Yvel,x		; $80848D: 9D FF 0A
	bpl .rts		; $808490: 10 03
	stz.w Yvel,x		; $808492: 9E FF 0A
.rts:
	rtl		; $808495: 6B
muls16:		;auto: CODE_808496. 68k muls.w: A = mula*mulb (signed 16-bit result, also in mula/mulb/mulres); C clear. Signs folded around the unsigned mulu (bank $8D)
	stz.b mula+2		; $808496: 64 7F  count the negative operands in mula+2
	lda.b mula		; $808498: A5 7D
	bpl .bpos		; $80849A: 10 08
	eor.w #$FFFF		; $80849C: 49 FF FF
	inc a		; $80849F: 1A
	sta.b mula		; $8084A0: 85 7D
	inc.b mula+2		; $8084A2: E6 7F
.bpos:
	lda.b mulb		; $8084A4: A5 83
	bpl .mul		; $8084A6: 10 08
	eor.w #$FFFF		; $8084A8: 49 FF FF
	inc a		; $8084AB: 1A
	sta.b mulb		; $8084AC: 85 83
	inc.b mula+2		; $8084AE: E6 7F
.mul:
	jsl.l $8D871C		; $8084B0: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	lsr.b mula+2		; $8084B4: 46 7F  odd count: negate the result
	bcc .rtl		; $8084B6: 90 0B
	eor.w #$FFFF		; $8084B8: 49 FF FF
	inc a		; $8084BB: 1A
	sta.b mula		; $8084BC: 85 7D
	sta.b mulb		; $8084BE: 85 83
	sta.b mulres		; $8084C0: 85 93
	clc		; $8084C2: 18
.rtl:
	rtl		; $8084C3: 6B
getpde:		;auto: CODE_8084C4. 93G getpde: d0 = energy of player X (tmpde of its team, entry pnum)
	lda.w pfteam,x		; $8084C4: BD 9F 11
	beq .team		; $8084C7: F0 03
	lda.w #$0002		; $8084C9: A9 02 00  a2 = 2: away team
.team:
	sta.b a2		; $8084CC: 85 3B
	lda.w pnum,x		; $8084CE: BD 1F 0F
	and.w #$00FF		; $8084D1: 29 FF 00  pnum low byte
	asl a		; $8084D4: 0A
	sta.b d1		; $8084D5: 85 57
	lda.b a2		; $8084D7: A5 3B
	beq .idx		; $8084D9: F0 03
	lda.w #$0034		; $8084DB: A9 34 00  away team entries start $34 bytes in
.idx:
	adc.b d1		; $8084DE: 65 57
	tay		; $8084E0: A8
	lda.w tmpde,y		; $8084E1: B9 7A 14
	sta.b d0		; $8084E4: 85 53
rtss:		;auto (inside CODE_8084C4). 93G rtss: the rtl that ends getpde, also used as a do-nothing callback (lda #rtss for skateto)
	rtl		; $8084E6: 6B
MaxSpeed:		;93G MaxSpeed (logic93_5): max speed^2 for each leg speed rating level 0-15. SNES ((n+20)*266)^2 (93G 275)
	dd (20*266)*(20*266)		; $8084E7
	dd (21*266)*(21*266)		; $8084EB
	dd (22*266)*(22*266)		; $8084EF
	dd (23*266)*(23*266)		; $8084F3
	dd (24*266)*(24*266)		; $8084F7
	dd (25*266)*(25*266)		; $8084FB
	dd (26*266)*(26*266)		; $8084FF
	dd (27*266)*(27*266)		; $808503
	dd (28*266)*(28*266)		; $808507
	dd (29*266)*(29*266)		; $80850B
	dd (30*266)*(30*266)		; $80850F
	dd (31*266)*(31*266)		; $808513
	dd (32*266)*(32*266)		; $808517
	dd (33*266)*(33*266)		; $80851B
	dd (34*266)*(34*266)		; $80851F
	dd (35*266)*(35*266)		; $808523
check4bench:		;auto: CODE_808527 (asscenter*, assdef*, asswing* ... call it with jsl). 93G check4bench (logic93_1): should player X go to the bench? Pops its return address when it takes over
	lda.w pflags,x		; $808527: BD DF 0E
	bit.w #pfjoycon|pf2pen		; $80852A: 89 08 40  joystick controlled, or penalty (93G btst #4,pflags2)
	bne .rts		; $80852D: D0 45
	lda.w newpos,x		; $80852F: BD 9F 0E
	bpl .b		; $808532: 10 05  newpos negative: only a new roster player counts
	lda.w newpnum,x		; $808534: BD BF 0E
	bmi .rts		; $808537: 30 3B
.b:		;newpos or newpnum requested
	lda.w newpnum,x		; $808539: BD BF 0E
	cmp.w pnum,x		; $80853C: DD 1F 0F  same roster player: just a position change
	beq .samepl		; $80853F: F0 34
	txa		; $808541: 8A  current assignment: asslist+X*4+assnum
	asl a		; $808542: 0A
	asl a		; $808543: 0A
	adc.w assnum,x		; $808544: 7D BF 0B
	tay		; $808547: A8
	lda.w asslist,y		; $808548: B9 DF 0B
	and.w #$00FF		; $80854B: 29 FF 00
	cmp.w #abench		; $80854E: C9 0B 00  already going to the bench
	beq .rts		; $808551: F0 21
	txa		; $808553: 8A
	lsr a		; $808554: 4A
	cmp.w puckc		; $808555: CD BB 0E  puck carrier stays
	beq .rts		; $808558: F0 1A
	sep #$20		; $80855A: E2 20  pop the jsl return address (93G addq #4,sp)
	pla		; $80855C: 68
	rep #$30		; $80855D: C2 30
	pla		; $80855F: 68
	lda.w pflags,x		; $808560: BD DF 0E
	ora.w #pf2unav		; $808563: 09 00 10  pf2unav
	sta.w pflags,x		; $808566: 9D DF 0E
	stz.w temp1,x		; $808569: 9E 5F 0C
	lda.w #abench		; $80856C: A9 0B 00  abench
	sta.b d0		; $80856F: 85 53
	jmp.w assreplace		; $808571: 4C A7 B4
.rts:
	rtl		; $808574: 6B
.samepl:		;same roster player: just change position (93G .samepl)
	sep #$20		; $808575: E2 20  pop the jsl return address
	pla		; $808577: 68
	rep #$30		; $808578: C2 30
	pla		; $80857A: 68
	lda.w pflags,x		; $80857B: BD DF 0E
	and.w #~pf2unav&$FFFF		; $80857E: 29 FF EF  clear pf2unav
	sta.w pflags,x		; $808581: 9D DF 0E
	stz.w pfnc,x		; $808584: 9E FF 11
	lda.w #$FFFF		; $808587: A9 FF FF
	sta.w newpnum,x		; $80858A: 9D BF 0E
	sta.w newpos,x		; $80858D: 9D 9F 0E
	lda.w position,x		; $808590: BD 9F 0B  d0 = position (newpos is negative here)
	sta.b d0		; $808593: 85 53
	jmp.w Setplass		; $808595: 4C 38 B1
checkob:		;auto: CODE_808598. 93G checkob (logic93_4): bring up the little warning ref if a player on your team is over the blue line. Called from doinput and asspuckc
	lda.w gmode		; $808598: AD 88 12
	bit.w #gmoffs		; $80859B: 89 20 00  offsides off: nothing to do
	bne .push		; $80859E: D0 03
	jmp.w .rts		; $8085A0: 4C 3B 86
.push:		;movem d0-d1/a0 to the stack
	stx.b xsave		; $8085A3: 86 0A
	ldx.w #$0000		; $8085A5: A2 00 00
.pushd:
	lda.b d0,x		; $8085A8: B5 53
	pha		; $8085AA: 48
	inx		; $8085AB: E8
	inx		; $8085AC: E8
	cpx.w #$0008		; $8085AD: E0 08 00
	bne .pushd		; $8085B0: D0 F6
	ldx.b xsave		; $8085B2: A6 0A
	stx.b xsave		; $8085B4: 86 0A
	ldx.w #$0000		; $8085B6: A2 00 00
.pusha:
	lda.b a0,x		; $8085B9: B5 33
	pha		; $8085BB: 48
	inx		; $8085BC: E8
	inx		; $8085BD: E8
	cpx.w #$0004		; $8085BE: E0 04 00
	bne .pusha		; $8085C1: D0 F6
	ldx.b xsave		; $8085C3: A6 0A
	lda.w #$0005		; $8085C5: A9 05 00
	sta.b d0		; $8085C8: 85 53
	stz.b a0		; $8085CA: 64 33
	cpx.w #$000C		; $8085CC: E0 0C 00  a0 = first object of the own team
	bcc .side		; $8085CF: 90 05
	lda.w #$000C		; $8085D1: A9 0C 00
	sta.b a0		; $8085D4: 85 33
.side:		;d1 = blue line y ($5C), negated for the bottom goal
	lda.w #$5C		; $8085D6: A9 5C 00  blue line y (93G $5C)
	sta.b d1		; $8085D9: 85 57
	lda.w pfgoal,x		; $8085DB: BD 3F 11
	bne .top		; $8085DE: D0 74
	lda.w #-$5C		; $8085E0: A9 A4 FF
	sta.b d1		; $8085E3: 85 57
	sec		; $8085E5: 38
	sbc.w pucky		; $8085E6: ED 7B 09  puck not in this zone: no offside
	beq .bottom		; $8085E9: F0 08
	bmi .v1		; $8085EB: 30 04
	bvs .bottom		; $8085ED: 70 04
	bra .nob		; $8085EF: 80 21
.v1:
	bvs .nob		; $8085F1: 70 1F
.bottom:		;any teammate below the blue line?
	ldy.b a0		; $8085F3: A4 33
	lda.w position,y		; $8085F5: B9 9F 0B
	bmi .bn		; $8085F8: 30 10
	lda.b d1		; $8085FA: A5 57
	sec		; $8085FC: 38
	sbc.w Ypos,y		; $8085FD: F9 5F 09
	beq .bn		; $808600: F0 08
	bmi .v2		; $808602: 30 04
	bvs .bn		; $808604: 70 04
	bra .ob		; $808606: 80 34
.v2:
	bvs .ob		; $808608: 70 32
.bn:
	inc.b a0		; $80860A: E6 33
	inc.b a0		; $80860C: E6 33
	dec.b d0		; $80860E: C6 53
	bpl .bottom		; $808610: 10 E1
.nob:		;no player offside: clear the offside signal, ref away
	lda.w #$0040		; $808612: A9 40 00  93G d0 = $40
	sta.b d0		; $808615: 85 53
	lda.w #sf2offsig		; $808617: A9 00 80
	trb.w sflags		; $80861A: 1C 8C 12  sf2offsig
	bne .dref		; $80861D: D0 2A
.ex:		;movem the registers back
	stx.b xsave		; $80861F: 86 0A
	ldx.w #$0002		; $808621: A2 02 00
.popa:
	pla		; $808624: 68
	sta.b a0,x		; $808625: 95 33
	dex		; $808627: CA
	dex		; $808628: CA
	bpl .popa		; $808629: 10 F9
	ldx.b xsave		; $80862B: A6 0A
	stx.b xsave		; $80862D: 86 0A
	ldx.w #$0006		; $80862F: A2 06 00
.popd:
	pla		; $808632: 68
	sta.b d0,x		; $808633: 95 53
	dex		; $808635: CA
	dex		; $808636: CA
	bpl .popd		; $808637: 10 F9
	ldx.b xsave		; $808639: A6 0A
.rts:
	rtl		; $80863B: 6B
.ob:		;offside: set the signal, ref up
	lda.w #$0006		; $80863C: A9 06 00  93G d0 = 6
	sta.b d0		; $80863F: 85 53
	lda.w #sf2offsig		; $808641: A9 00 80
	tsb.w sflags		; $808644: 0C 8C 12
	bne .ex		; $808647: D0 D6
.dref:
	lda.w RefCnt		; $808649: AD EA 12  ref idle? then bring him up
	bpl .ex		; $80864C: 10 D1
	jsl.l $8F83A7		; $80864E: 22 A7 83 8F  bank $8F: 93G PushRef
	bra .ex		; $808652: 80 CB
.top:
	lda.b d1		; $808654: A5 57
	sec		; $808656: 38
	sbc.w pucky		; $808657: ED 7B 09
	bmi .v3		; $80865A: 30 04
	bvc .top1		; $80865C: 50 04
	bra .nob		; $80865E: 80 B2
.v3:
	bvc .nob		; $808660: 50 B0
.top1:
	ldy.b a0		; $808662: A4 33
	lda.w position,y		; $808664: B9 9F 0B
	bmi .tn		; $808667: 30 0E
	lda.b d1		; $808669: A5 57
	sec		; $80866B: 38
	sbc.w Ypos,y		; $80866C: F9 5F 09
	bmi .v4		; $80866F: 30 04
	bvc .tn		; $808671: 50 04
	bra .ob		; $808673: 80 C7
.v4:
	bvc .ob		; $808675: 50 C5
.tn:
	inc.b a0		; $808677: E6 33
	inc.b a0		; $808679: E6 33
	dec.b d0		; $80867B: C6 53
	bpl .top1		; $80867D: 10 E3
	bra .nob		; $80867F: 80 91
chk4lc:		;auto: CODE_808681. 93G chk4lc (logic93_3): should the computer call a line change? Then shoot the puck in (CompShoot)
	lda.w pucky		; $808681: AD 7B 09
	sta.b d0		; $808684: 85 53
	lda.w pfgoal,x		; $808686: BD 3F 11
	bne .gu		; $808689: D0 08
	lda.b d0		; $80868B: A5 53
	eor.w #$FFFF		; $80868D: 49 FF FF
	inc a		; $808690: 1A
	sta.b d0		; $808691: 85 53
.gu:
	lda.b d0		; $808693: A5 53
	bmi .rts		; $808695: 30 4B
	sec		; $808697: 38
	sbc.w #blueline		; $808698: E9 58 00  blueline
	beq .inzone		; $80869B: F0 08
	bmi .v1		; $80869D: 30 04
	bvs .inzone		; $80869F: 70 04
	bra .rts		; $8086A1: 80 3F
.v1:
	bvs .rts		; $8086A3: 70 3D
.inzone:		;in own half, inside the blue line
	lda.w seed		; $8086A5: AD A1 04
	and.w #$0003		; $8086A8: 29 03 00  one time in four
	bne .rts		; $8086AB: D0 35
	lda.w pflags,x		; $8086AD: BD DF 0E
	bit.w #pf2lcm		; $8086B0: 89 00 20  pf2lcm
	bne .rts		; $8086B3: D0 2D
	stz.b a2		; $8086B5: 64 3B
	lda.w #$0002		; $8086B7: A9 02 00
	sta.b a1		; $8086BA: 85 37
	lda.w pfteam,x		; $8086BC: BD 9F 11
	beq .teams		; $8086BF: F0 07
	stz.b a1		; $8086C1: 64 37
	lda.w #$0002		; $8086C3: A9 02 00
	sta.b a2		; $8086C6: 85 3B
.teams:		;a2 = own team, a1 = other team
	jsl.l AvgCline		; $8086C8: 22 4C B8 80
	lda.b d0		; $8086CC: A5 53
	cmp.w #$0C01		; $8086CE: C9 01 0C  average energy of the line still above $C00: no change
	bcs .rts		; $8086D1: B0 0F
	jsl.l $8FE6BD		; $8086D3: 22 BD E6 8F  bank $8F: 93G CompLine
	jsl.l setpersonel		; $8086D7: 22 5A BB 80
	jsl.l $89E95D		; $8086DB: 22 5D E9 89  bank $89: 93G printscores1
	jmp.w CompShoot		; $8086DF: 4C F7 87
.rts:
	rtl		; $8086E2: 6B
chk4shot:		;auto: CODE_8086E3. 93G chk4shot (logic93_3): computer player X looks for a shot. Called from asspuckc
	jsl.l chkpk		; $8086E3: 22 95 8D 80
	bne .npk		; $8086E7: D0 21
	lda.w threat		; $8086E9: AD D3 08  threat on the puck carrier
	beq .npk		; $8086EC: F0 1C
	lda.w Ypos,x		; $8086EE: BD 5F 09
	bit.w #$8000		; $8086F1: 89 00 80
	beq .yabs		; $8086F4: F0 04
	eor.w #$FFFF		; $8086F6: 49 FF FF
	inc a		; $8086F9: 1A
.yabs:
	cmp.w #$00ED		; $8086FA: C9 ED 00  in front of the net
	bcs .npk		; $8086FD: B0 0B
	lda.w seed		; $8086FF: AD A1 04  one time in four: clear the puck
	and.w #$0003		; $808702: 29 03 00
	bne .npk		; $808705: D0 03
	jmp.w CompShoot		; $808707: 4C F7 87
.npk:		;d4 = shot odds ($20-spodds)*16
	lda.w #$0020		; $80870A: A9 20 00
	sec		; $80870D: 38
	sbc.w spodds,x		; $80870E: FD 5F 10
	asl a		; $808711: 0A
	asl a		; $808712: 0A
	asl a		; $808713: 0A
	asl a		; $808714: 0A
	sta.b d4		; $808715: 85 63
	lda.w #blueline+goalline		; $808717: A9 08 01  blueline+goalline
	sta.b d1		; $80871A: 85 57
	lda.w pfgoal,x		; $80871C: BD 3F 11
	bne .c0		; $80871F: D0 05
	lda.w #-(blueline+goalline)		; $808721: A9 F8 FE
	sta.b d1		; $808724: 85 57
.c0:
	lda.b d1		; $808726: A5 57
	sec		; $808728: 38
	sbc.w pucky		; $808729: ED 7B 09
	sta.b d1		; $80872C: 85 57
	pha		; $80872E: 48
	lda.w puckx		; $80872F: AD 1B 09
	eor.w #$FFFF		; $808732: 49 FF FF
	inc a		; $808735: 1A
	sta.b mula		; $808736: 85 7D
	sta.b mulb		; $808738: 85 83
	pha		; $80873A: 48
	jsl.l $82FCDB		; $80873B: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $80873F: 85 53
	lda.b mulres+2		; $808741: A5 95
	sta.b d0+2		; $808743: 85 55
	lda.b d1		; $808745: A5 57
	sta.b mula		; $808747: 85 7D
	sta.b mulb		; $808749: 85 83
	jsl.l $82FCDB		; $80874B: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $80874F: 65 53
	sta.b tmp0		; $808751: 85 73
	lda.b mulres+2		; $808753: A5 95
	adc.b d0+2		; $808755: 65 55
	sta.b tmp1		; $808757: 85 75
	pla		; $808759: 68
	sta.b d0		; $80875A: 85 53
	pla		; $80875C: 68
	sta.b d1		; $80875D: 85 57
	lda.b tmp0		; $80875F: A5 73
	cmp.w #$2711		; $808761: C9 11 27  distance^2 > 100*100?
	lda.b tmp1		; $808764: A5 75
	sbc.w #$0000		; $808766: E9 00 00
	bcs .no1		; $808769: B0 58
	lsr.b d4		; $80876B: 46 63
	lsr.b d4		; $80876D: 46 63
	lsr.b d4		; $80876F: 46 63
	lsr.b d4		; $808771: 46 63
	jsl.l vtoa		; $808773: 22 A8 AF 80
	sta.b d5		; $808777: 85 67
	lda.w #$0005		; $808779: A9 05 00
	sta.b d3		; $80877C: 85 5F
	stz.b a1		; $80877E: 64 37
	cpx.w #$000C		; $808780: E0 0C 00
	bcs .co0		; $808783: B0 05
	lda.w #$000C		; $808785: A9 0C 00
	sta.b a1		; $808788: 85 37
.co0:		;each opponent: a defender in the shot line doubles d4; a busy goalie means shoot now
	ldy.b a1		; $80878A: A4 37
	lda.w position,y		; $80878C: B9 9F 0B
	beq .gl		; $80878F: F0 1E
	lda.w Xpos,y		; $808791: B9 FF 08
	sec		; $808794: 38
	sbc.w puckx		; $808795: ED 1B 09
	sta.b d0		; $808798: 85 53
	lda.w Ypos,y		; $80879A: B9 5F 09
	sec		; $80879D: 38
	sbc.w pucky		; $80879E: ED 7B 09
	sta.b d1		; $8087A1: 85 57
	jsl.l vtoa		; $8087A3: 22 A8 AF 80
	cmp.b d5		; $8087A7: C5 67
	bne .co1		; $8087A9: D0 10
	asl.b d4		; $8087AB: 06 63
	bra .co1		; $8087AD: 80 0C
.gl:
	lda.w pf2aip,y		; $8087AF: B9 DF 11
	beq .co1		; $8087B2: F0 07
	stz.b d3		; $8087B4: 64 5F
	lda.w #$0001		; $8087B6: A9 01 00
	sta.b d4		; $8087B9: 85 63
.co1:
	inc.b a1		; $8087BB: E6 37
	inc.b a1		; $8087BD: E6 37
	dec.b d3		; $8087BF: C6 5F
	bpl .co0		; $8087C1: 10 C7
.no1:
	lda.b d4		; $8087C3: A5 63
	jsl.l randoma		; $8087C5: 22 8B AE 80
	cmp.w #$0009		; $8087C9: C9 09 00  no shot if random(d4) > 8
	bcs .rts		; $8087CC: B0 28
	lda.w pucky		; $8087CE: AD 7B 09
	sta.b d0		; $8087D1: 85 53
	lda.w pfgoal,x		; $8087D3: BD 3F 11
	bne .ds0		; $8087D6: D0 08
	lda.b d0		; $8087D8: A5 53
	eor.w #$FFFF		; $8087DA: 49 FF FF
	inc a		; $8087DD: 1A
	sta.b d0		; $8087DE: 85 53
.ds0:
	lda.b d0		; $8087E0: A5 53
	bmi .rts		; $8087E2: 30 12
	lda.w #blueline+goalline		; $8087E4: A9 08 01
	sec		; $8087E7: 38
	sbc.b d0		; $8087E8: E5 53
	bmi .rts		; $8087EA: 30 0A
	lda.w sflags		; $8087EC: AD 8C 12  sf2offsig: player is offside
	bit.w #sf2offsig		; $8087EF: 89 00 80
	bne .rts		; $8087F2: D0 02
	bra CompShoot		; $8087F4: 80 01
.rts:
	rtl		; $8087F6: 6B
CompShoot:		;auto: CODE_8087F7. 93G CompShoot (logic93_3): computer player X shoots. Pops the caller (addq #4,sp), temp2b = swing time, assignment ashoot
	pla		; $8087F7: 68  pop the caller (93G addq #4,sp)
	sep #$20		; $8087F8: E2 20
	pla		; $8087FA: 68
	rep #$30		; $8087FB: C2 30
	lda.w pucky		; $8087FD: AD 7B 09
	sta.b d0		; $808800: 85 53
	lda.w pfgoal,x		; $808802: BD 3F 11
	bne .ds0		; $808805: D0 08
	lda.b d0		; $808807: A5 53
	eor.w #$FFFF		; $808809: 49 FF FF
	inc a		; $80880C: 1A
	sta.b d0		; $80880D: 85 53
.ds0:
	lda.w #blueline+goalline		; $80880F: A9 08 01  swing time = (blueline+goalline - y)/8, max 20
	sec		; $808812: 38
	sbc.b d0		; $808813: E5 53
	lsr a		; $808815: 4A
	lsr a		; $808816: 4A
	lsr a		; $808817: 4A
	sta.b d1		; $808818: 85 57
	cmp.w #$0014		; $80881A: C9 14 00
	bcc .lt		; $80881D: 90 05
	lda.w #$0014		; $80881F: A9 14 00
	sta.b d1		; $808822: 85 57
.lt:
	stz.w temp2,x		; $808824: 9E 7F 0C
	lda.b d1		; $808827: A5 57
	sta.w temp2b,x		; $808829: 9D FF 0C
	lda.w #ashoot		; $80882C: A9 12 00  ashoot
	sta.b d0		; $80882F: 85 53
	jmp.w assreplace		; $808831: 4C A7 B4
assnearest:		;auto: CODE_808834 (asstab $11). 93G assnearest (logic93_4): assignment for the player nearest the puck who does not have it
	lda.w pflags,x		; $808834: BD DF 0E
	bit.w #pfna		; $808837: 89 02 00  pfna
	beq .nna		; $80883A: F0 15
	and.w #~pfna&$FFFF		; $80883C: 29 FD FF
	sta.w pflags,x		; $80883F: 9D DF 0E
	stz.w temp3,x		; $808842: 9E 9F 0C
	stz.w temp2,x		; $808845: 9E 7F 0C
	lda.w #$0008		; $808848: A9 08 00
	sta.w temp2b,x		; $80884B: 9D FF 0C
	stz.w temp1,x		; $80884E: 9E 5F 0C
.nna:
	txa		; $808851: 8A
	lsr a		; $808852: 4A
	sta.b d1		; $808853: 85 57
	cmp.w puckc		; $808855: CD BB 0E  X has the puck?
	bne .nopc		; $808858: D0 19
	lda.w position,x		; $80885A: BD 9F 0B
	bne .pc		; $80885D: D0 03
	jmp.w assgoalie		; $80885F: 4C AD F6
.pc:
	lda.w #apuckc		; $808862: A9 10 00  apuckc unless joystick controlled
	sta.b d0		; $808865: 85 53
	lda.w pflags,x		; $808867: BD DF 0E
	bit.w #pfjoycon		; $80886A: 89 08 00
	bne .rts		; $80886D: D0 03
	jmp.w assinsert		; $80886F: 4C 9D B4
.rts:
	rtl		; $808872: 6B
.nopc:		;every aioff frames: find the teammate nearest the (moving) puck
	lda.w temp1,x		; $808873: BD 5F 0C
	sec		; $808876: 38
	sbc.b d7		; $808877: E5 6F
	sta.w temp1,x		; $808879: 9D 5F 0C
	bmi .dec		; $80887C: 30 03
	jmp.w .nodec		; $80887E: 4C 40 8A
.dec:
	adc.w aioff,x		; $808881: 7D 9F 0F  reload temp1 from aioff
	bpl .setcnt		; $808884: 10 03
	lda.w #$0000		; $808886: A9 00 00
.setcnt:
	sta.w temp1,x		; $808889: 9D 5F 0C
	ldy.b a2		; $80888C: A4 3B
	lda.w #$0000		; $80888E: A9 00 00  tmnear = 0
	sta.w tmnear,y		; $808891: 99 FA 13
	sta.w tmnear+4,y		; $808894: 99 FE 13
	lda.w puckc		; $808897: AD BB 0E
	bmi .np		; $80889A: 30 1D
	asl a		; $80889C: 0A
	sta.b a1		; $80889D: 85 37
	tay		; $80889F: A8
	lda.w pfteam,y		; $8088A0: B9 9F 11  puck carrier on my team?
	beq .pcteam		; $8088A3: F0 03
	lda.w #$0001		; $8088A5: A9 01 00
.pcteam:
	sta.b tmp0		; $8088A8: 85 73
	lda.w pfteam,x		; $8088AA: BD 9F 11
	beq .myteam		; $8088AD: F0 03
	lda.w #$0001		; $8088AF: A9 01 00
.myteam:
	eor.b tmp0		; $8088B2: 45 73
	bne .np		; $8088B4: D0 03
	jmp.w .switch		; $8088B6: 4C AA 89
.np:
	lda.w #$FFFF		; $8088B9: A9 FF FF  d2 = best distance^2 = $FFFFFFFF
	sta.b d2		; $8088BC: 85 5B
	sta.b d2+2		; $8088BE: 85 5D
	lda.w #$0005		; $8088C0: A9 05 00
	sta.b d4		; $8088C3: 85 63
	ldy.b a2		; $8088C5: A4 3B
	lda.w tmsort,y		; $8088C7: B9 D2 13  a0 = first object of the team
	sta.b a0		; $8088CA: 85 33
.de0:
	ldy.b a0		; $8088CC: A4 33
	lda.w position,y		; $8088CE: B9 9F 0B
	bpl .pos		; $8088D1: 10 03
	jmp.w .next		; $8088D3: 4C 91 89
.pos:
	bne .nop		; $8088D6: D0 03
	jmp.w .next		; $8088D8: 4C 91 89
.nop:
	lda.w nopuck,y		; $8088DB: B9 5F 0E
	beq .unav		; $8088DE: F0 03
	jmp.w .next		; $8088E0: 4C 91 89
.unav:
	lda.w pflags,y		; $8088E3: B9 DF 0E
	bit.w #pf2unav		; $8088E6: 89 00 10
	beq .pass		; $8088E9: F0 03
	jmp.w .next		; $8088EB: 4C 91 89
.pass:
	tya		; $8088EE: 98
	asl a		; $8088EF: 0A
	asl a		; $8088F0: 0A
	adc.w assnum,y		; $8088F1: 79 BF 0B
	tay		; $8088F4: A8
	lda.w asslist,y		; $8088F5: B9 DF 0B
	and.w #$00FF		; $8088F8: 29 FF 00
	cmp.w #apassrec		; $8088FB: C9 13 00  skip a player on apassrec
	bne .dist		; $8088FE: D0 03
	jmp.w .next		; $808900: 4C 91 89
.dist:
	lda.b a0		; $808903: A5 33
	jsl.l GetHot		; $808905: 22 0A 9B 80
	ldy.b a0		; $808909: A4 33
	lda.b d0		; $80890B: A5 53
	clc		; $80890D: 18
	adc.w Xpos,y		; $80890E: 79 FF 08
	sec		; $808911: 38
	sbc.w puckx		; $808912: ED 1B 09
	sta.b d0		; $808915: 85 53
	lda.b d1		; $808917: A5 57
	clc		; $808919: 18
	adc.w Ypos,y		; $80891A: 79 5F 09
	sec		; $80891D: 38
	sbc.w pucky		; $80891E: ED 7B 09
	sta.b d1		; $808921: 85 57
	lda.w puckvx		; $808923: AD FB 0A  lead the puck: puckvx/64
	lsr a		; $808926: 4A
	lsr a		; $808927: 4A
	lsr a		; $808928: 4A
	lsr a		; $808929: 4A
	lsr a		; $80892A: 4A
	lsr a		; $80892B: 4A
	bit.w #$0200		; $80892C: 89 00 02
	beq .vx		; $80892F: F0 03
	ora.w #$FC00		; $808931: 09 00 FC
.vx:
	sta.b d3		; $808934: 85 5F
	lda.b d0		; $808936: A5 53
	sec		; $808938: 38
	sbc.b d3		; $808939: E5 5F
	sta.b d0		; $80893B: 85 53
	lda.w puckvy		; $80893D: AD 1B 0B
	lsr a		; $808940: 4A
	lsr a		; $808941: 4A
	lsr a		; $808942: 4A
	lsr a		; $808943: 4A
	lsr a		; $808944: 4A
	lsr a		; $808945: 4A
	bit.w #$0200		; $808946: 89 00 02
	beq .vy		; $808949: F0 03
	ora.w #$FC00		; $80894B: 09 00 FC
.vy:
	sta.b d3		; $80894E: 85 5F
	lda.b d1		; $808950: A5 57
	sec		; $808952: 38
	sbc.b d3		; $808953: E5 5F
	sta.b d1		; $808955: 85 57
	lda.b d0		; $808957: A5 53
	sta.b mula		; $808959: 85 7D
	sta.b mulb		; $80895B: 85 83
	jsl.l $82FCDB		; $80895D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $808961: 85 53
	lda.b mulres+2		; $808963: A5 95
	sta.b d0+2		; $808965: 85 55
	lda.b d1		; $808967: A5 57
	sta.b mula		; $808969: 85 7D
	sta.b mulb		; $80896B: 85 83
	jsl.l $82FCDB		; $80896D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $808971: 65 53
	sta.b d0		; $808973: 85 53
	lda.b mulres+2		; $808975: A5 95
	adc.b d0+2		; $808977: 65 55
	sta.b d0+2		; $808979: 85 55
	lda.b d2		; $80897B: A5 5B  nearer?
	cmp.b d0		; $80897D: C5 53
	lda.b d2+2		; $80897F: A5 5D
	sbc.b d0+2		; $808981: E5 55
	bcc .next		; $808983: 90 0C
	lda.b d0		; $808985: A5 53
	sta.b d2		; $808987: 85 5B
	lda.b d0+2		; $808989: A5 55
	sta.b d2+2		; $80898B: 85 5D
	lda.b a0		; $80898D: A5 33
	sta.b a1		; $80898F: 85 37
.next:
	inc.b a0		; $808991: E6 33
	inc.b a0		; $808993: E6 33
	dec.b d4		; $808995: C6 63
	bmi .done		; $808997: 30 03
	jmp.w .de0		; $808999: 4C CC 88
.done:
	lda.b d2+2		; $80899C: A5 5D
	bmi .de1		; $80899E: 30 42
	ldy.b a2		; $8089A0: A4 3B
	sta.w tmnear+4,y		; $8089A2: 99 FE 13  tmnear = nearest distance^2
	lda.b d2		; $8089A5: A5 5B
	sta.w tmnear,y		; $8089A7: 99 FA 13
.switch:		;if another player is nearer: give him anearest and leave
	cpx.b a1		; $8089AA: E4 37
	beq .de1		; $8089AC: F0 34
	lda.w gmclock		; $8089AE: AD 8A 12  clock stopped
	bne .de1		; $8089B1: D0 2F
	ldy.b a1		; $8089B3: A4 37
	lda.w pflags,y		; $8089B5: B9 DF 0E
	bit.w #pf2unav		; $8089B8: 89 00 10
	bne .de1		; $8089BB: D0 25
	ldx.b a1		; $8089BD: A6 37  exg a1,a3 (X = a1)
	ldy.b a3		; $8089BF: A4 3F
	stx.b a3		; $8089C1: 86 3F
	sty.b a1		; $8089C3: 84 37
	lda.w pflags,x		; $8089C5: BD DF 0E
	and.w #~pfdoff&$FFFF		; $8089C8: 29 FE FF  clear pfdoff
	sta.w pflags,x		; $8089CB: 9D DF 0E
	lda.w #anearest		; $8089CE: A9 11 00  anearest
	sta.b d0		; $8089D1: 85 53
	jsl.l assinsert		; $8089D3: 22 9D B4 80
	ldx.b a1		; $8089D7: A6 37  exg back
	ldy.b a3		; $8089D9: A4 3F
	stx.b a3		; $8089DB: 86 3F
	sty.b a1		; $8089DD: 84 37
	jmp.w assexit		; $8089DF: 4C F9 96
.de1:
	lda.w pfalock,x		; $8089E2: BD 7F 11
	beq .odds		; $8089E5: F0 03
	jmp.w .rts		; $8089E7: 4C 72 88
.odds:
	lda.w #$0002		; $8089EA: A9 02 00
	sta.b d1		; $8089ED: 85 57
	lda.b d2		; $8089EF: A5 5B
	cmp.w #$0191		; $8089F1: C9 91 01  20^2
	bcs .nfar		; $8089F4: B0 0A
	stz.b d1		; $8089F6: 64 57
	lda.w position,x		; $8089F8: BD 9F 0B
	cmp.w #$0003		; $8089FB: C9 03 00
	bcc .nodec		; $8089FE: 90 40
.nfar:
	lda.w sflags		; $808A00: AD 8C 12
	bit.w #sf2pwrplay		; $808A03: 89 00 20  sf2pwrplay
	beq .x		; $808A06: F0 12
	dec.b d1		; $808A08: C6 57
	dec.b d1		; $808A0A: C6 57
	jsl.l chkpk2		; $808A0C: 22 9F 8D 80
	bne .x		; $808A10: D0 08
	inc.b d1		; $808A12: E6 57
	inc.b d1		; $808A14: E6 57
	inc.b d1		; $808A16: E6 57
	inc.b d1		; $808A18: E6 57
.x:
	lda.w #$0014		; $808A1A: A9 14 00  ($14-aggress) << d1
	sec		; $808A1D: 38
	sbc.w aggress,x		; $808A1E: FD FF 10
	sta.b d0		; $808A21: 85 53
	lda.b d1		; $808A23: A5 57
	sta.b tmp0		; $808A25: 85 73
.shl:
	dec.b tmp0		; $808A27: C6 73
	bmi .rnd		; $808A29: 30 04
	asl.b d0		; $808A2B: 06 53
	bra .shl		; $808A2D: 80 F8
.rnd:
	jsl.l randomd0		; $808A2F: 22 A3 97 80
	lda.b d0		; $808A33: A5 53
	cmp.w #$0002		; $808A35: C9 02 00
	bcs .nodec		; $808A38: B0 06
	lda.w #$00F0		; $808A3A: A9 F0 00  temp3 = 240
	sta.w temp3,x		; $808A3D: 9D 9F 0C
.nodec:
	lda.w pfalock,x		; $808A40: BD 7F 11
	beq .clk		; $808A43: F0 03
	jmp.w .rts		; $808A45: 4C 72 88
.clk:
	lda.w gmclock		; $808A48: AD 8A 12
	beq .joy		; $808A4B: F0 04
	jml.l $8FD75A		; $808A4D: 5C 5A D7 8F  bank $8F: 93G assnothing
.joy:
	lda.w pflags,x		; $808A51: BD DF 0E
	bit.w #pfjoycon		; $808A54: 89 08 00
	beq .mode		; $808A57: F0 03
	jmp.w .rts		; $808A59: 4C 72 88
.mode:
	ldy.b a2		; $808A5C: A4 3B
	lda.w tmflags,y		; $808A5E: B9 0A 14  tmfmid: always the in-between spot
	bit.w #tmfmid		; $808A61: 89 02 00
	bne .mid		; $808A64: D0 19
	lda.w puckc		; $808A66: AD BB 0E
	bpl .cnt		; $808A69: 10 03
	jmp.w .topuck		; $808A6B: 4C 0E 8B
.cnt:
	lda.w temp3,x		; $808A6E: BD 9F 0C
	sec		; $808A71: 38
	sbc.b d7		; $808A72: E5 6F
	sta.w temp3,x		; $808A74: 9D 9F 0C
	bmi .clr		; $808A77: 30 03
	jmp.w .topuck		; $808A79: 4C 0E 8B
.clr:
	stz.w temp3,x		; $808A7C: 9E 9F 0C
.mid:		;skate to halfway between the puck spot and the own goal mouth (0,+-$F4)
	jsl.l $8BFFD3		; $808A7F: 22 D3 FF 8B  bank $8B: 93G skatetopuckinit (d0/d1 = puck spot)
	lda.b d1		; $808A83: A5 57
	pha		; $808A85: 48
	lda.b d0		; $808A86: A5 53
	pha		; $808A88: 48
	eor.w #$FFFF		; $808A89: 49 FF FF
	inc a		; $808A8C: 1A
	sta.b d0		; $808A8D: 85 53
	lda.b d1		; $808A8F: A5 57
	eor.w #$FFFF		; $808A91: 49 FF FF
	inc a		; $808A94: 1A
	clc		; $808A95: 18
	adc.w #$00F4		; $808A96: 69 F4 00  own goal mouth y $F4
	sta.b d1		; $808A99: 85 57
	lda.w pfgoal,x		; $808A9B: BD 3F 11
	beq .half		; $808A9E: F0 08
	lda.b d1		; $808AA0: A5 57
	sec		; $808AA2: 38
	sbc.w #$01E8		; $808AA3: E9 E8 01  $1E8 = 2*$F4 for the top goal
	sta.b d1		; $808AA6: 85 57
.half:
	lda.b d0		; $808AA8: A5 53
	pha		; $808AAA: 48
	asl a		; $808AAB: 0A  asr #1
	pla		; $808AAC: 68
	ror a		; $808AAD: 6A
	sta.b d0		; $808AAE: 85 53
	lda.b d1		; $808AB0: A5 57
	pha		; $808AB2: 48
	asl a		; $808AB3: 0A
	pla		; $808AB4: 68
	ror a		; $808AB5: 6A
	sta.b d1		; $808AB6: 85 57
	pla		; $808AB8: 68
	clc		; $808AB9: 18
	adc.b d0		; $808ABA: 65 53
	sta.b d0		; $808ABC: 85 53
	pla		; $808ABE: 68
	clc		; $808ABF: 18
	adc.b d1		; $808AC0: 65 57
	sta.b d1		; $808AC2: 85 57
	ldy.b a2		; $808AC4: A4 3B
	lda.w tmflags,y		; $808AC6: B9 0A 14
	bit.w #tmfmid		; $808AC9: 89 02 00
	beq .go		; $808ACC: F0 2F
	lda.w pfgoal,x		; $808ACE: BD 3F 11
	beq .neg		; $808AD1: F0 15
	lda.b d1		; $808AD3: A5 57
	sec		; $808AD5: 38
	sbc.w #$0053		; $808AD6: E9 53 00
	bmi .v1		; $808AD9: 30 04
	bvc .clamp1		; $808ADB: 50 04
	bra .go		; $808ADD: 80 1E
.v1:
	bvc .go		; $808ADF: 50 1C
.clamp1:
	lda.w #$0044		; $808AE1: A9 44 00
	sta.b d1		; $808AE4: 85 57
	bra .go		; $808AE6: 80 15
.neg:
	lda.b d1		; $808AE8: A5 57
	sec		; $808AEA: 38
	sbc.w #$FFAD		; $808AEB: E9 AD FF
	beq .clamp2		; $808AEE: F0 08
	bmi .v2		; $808AF0: 30 04
	bvs .clamp2		; $808AF2: 70 04
	bra .go		; $808AF4: 80 07
.v2:
	bvs .go		; $808AF6: 70 05
.clamp2:
	lda.w #$FFBC		; $808AF8: A9 BC FF
	sta.b d1		; $808AFB: 85 57
.go:
	lda.w #rtss		; $808AFD: A9 E6 84  a0 = rtss: nothing to do on arrival
	sta.b a0		; $808B00: 85 33
	lda.w #rtss>>16		; $808B02: A9 80 00
	sta.b a0+2		; $808B05: 85 35
	jsl.l $88FDD0		; $808B07: 22 D0 FD 88  bank $88: 93G skateto (d0/d1 = spot, [a0] = arrival routine)
	jmp.w check4check		; $808B0B: 4C 15 8B
.topuck:
	jsl.l skatetopuck		; $808B0E: 22 2D 8C 80
	jmp.w check4check		; $808B12: 4C 15 8B
check4check:		;auto: CODE_808B15. 93G check4check (logic93_4): look for a good chance to check an opponent. Falls in from assnearest; also entered from assfwatch and asswingd
	lda.w #$0014		; $808B15: A9 14 00
	sec		; $808B18: 38
	sbc.w aggress,x		; $808B19: FD FF 10
	sta.b d0		; $808B1C: 85 53
	lda.w OptPen		; $808B1E: AD 0A 16  penalties on: half the chance
	beq .nopen		; $808B21: F0 02
	asl.b d0		; $808B23: 06 53
.nopen:
	lda.b d0		; $808B25: A5 53
	jsl.l randoma		; $808B27: 22 8B AE 80
	cmp.w #$0004		; $808B2B: C9 04 00
	bcc .go		; $808B2E: 90 0B
	lda.b d0		; $808B30: A5 53
	jsl.l randoma		; $808B32: 22 8B AE 80
	cmp.w #$0004		; $808B36: C9 04 00
	bcs .rts		; $808B39: B0 71
.go:
	lda.w #$0005		; $808B3B: A9 05 00
	sta.b d2		; $808B3E: 85 5B
	stz.b a0		; $808B40: 64 33
	cpx.w #$000C		; $808B42: E0 0C 00
	bcs .loop		; $808B45: B0 05
	lda.w #$000C		; $808B47: A9 0C 00
	sta.b a0		; $808B4A: 85 33
.loop:		;each opponent within 30 pixels in the facing direction
	ldy.b a0		; $808B4C: A4 33
	lda.w position,y		; $808B4E: B9 9F 0B
	beq .next		; $808B51: F0 51
	lda.w pfalock,y		; $808B53: B9 7F 11
	bne .next		; $808B56: D0 4C
	lda.w pf2fight,y		; $808B58: B9 5F 11
	bne .next		; $808B5B: D0 47
	lda.w Xpos,y		; $808B5D: B9 FF 08
	sec		; $808B60: 38
	sbc.w Xpos,x		; $808B61: FD FF 08
	sta.b d0		; $808B64: 85 53
	bit.w #$8000		; $808B66: 89 00 80
	beq .dx		; $808B69: F0 04
	eor.w #$FFFF		; $808B6B: 49 FF FF
	inc a		; $808B6E: 1A
.dx:
	cmp.w #$001F		; $808B6F: C9 1F 00
	bcs .next		; $808B72: B0 30
	lda.w Ypos,y		; $808B74: B9 5F 09
	sec		; $808B77: 38
	sbc.w Ypos,x		; $808B78: FD 5F 09
	sta.b d1		; $808B7B: 85 57
	bit.w #$8000		; $808B7D: 89 00 80
	beq .dy		; $808B80: F0 04
	eor.w #$FFFF		; $808B82: 49 FF FF
	inc a		; $808B85: 1A
.dy:
	cmp.w #$001F		; $808B86: C9 1F 00
	bcs .next		; $808B89: B0 19
	jsl.l vtoa		; $808B8B: 22 A8 AF 80
	lda.b d0		; $808B8F: A5 53
	cmp.w facedir,x		; $808B91: DD BF 0D  opponent in the facing direction
	bne .next		; $808B94: D0 0E
	lda.w seed+3		; $808B96: AD A4 04  random: 1 in 4 hold, else check
	and.w #$0003		; $808B99: 29 03 00
	sta.b d0		; $808B9C: 85 53
	bne burst		; $808B9E: D0 0D
	jml.l $8FFB5B		; $808BA0: 5C 5B FB 8F  bank $8F: 93G Acheck
.next:
	inc.b a0		; $808BA4: E6 33
	inc.b a0		; $808BA6: E6 33
	dec.b d2		; $808BA8: C6 5B
	bpl .loop		; $808BAA: 10 A0
.rts:
	rtl		; $808BAC: 6B
burst:		;auto: CODE_808BAD. 93G burst (logic93_1): check button: speed burst in the facing direction (costs energy), lock in SPAburst. Also entered from check4check
	jsl.l getpde		; $808BAD: 22 C4 84 80
	lda.w OptLine		; $808BB1: AD 0C 16  line changes off: no energy cost
	bne .spd		; $808BB4: D0 0C
	lda.b d0		; $808BB6: A5 53
	sec		; $808BB8: 38
	sbc.w #$00CC		; $808BB9: E9 CC 00  $1000/20
	sta.b d0		; $808BBC: 85 53
	jsl.l $8FEE6B		; $808BBE: 22 6B EE 8F  bank $8F: 93G setpde
.spd:		;speed = energy*$233/$10000 (93G energy/128)
	lda.b d0		; $808BC2: A5 53
	sta.b mula		; $808BC4: 85 7D
	lda.w #$0233		; $808BC6: A9 33 02
	sta.b mulb		; $808BC9: 85 83
	jsl.l $888942		; $808BCB: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2		; $808BCF: A5 95
	sta.b mulb		; $808BD1: 85 83
	pha		; $808BD3: 48
	lda.w facedir,x		; $808BD4: BD BF 0D
	asl a		; $808BD7: 0A
	asl a		; $808BD8: 0A
	tay		; $808BD9: A8
	lda.w #$AE36		; $808BDA: A9 36 AE  dirtab (bank $80)
	sta.b a0		; $808BDD: 85 33
	lda.w #$0080		; $808BDF: A9 80 00
	sta.b a0+2		; $808BE2: 85 35
	lda.b [a0],y		; $808BE4: B7 33
	iny		; $808BE6: C8
	iny		; $808BE7: C8
	sta.b mula		; $808BE8: 85 7D
	jsl.l muls16		; $808BEA: 22 96 84 80
	adc.w Xvel,x		; $808BEE: 7D DF 0A
	sta.w Xvel,x		; $808BF1: 9D DF 0A
	lda.b [a0],y		; $808BF4: B7 33
	sta.b mula		; $808BF6: 85 7D
	pla		; $808BF8: 68
	sta.b mulb		; $808BF9: 85 83
	jsl.l muls16		; $808BFB: 22 96 84 80
	adc.w Yvel,x		; $808BFF: 7D FF 0A
	sta.w Yvel,x		; $808C02: 9D FF 0A
	bit.w #$8000		; $808C05: 89 00 80
	beq .yabs		; $808C08: F0 04
	eor.w #$FFFF		; $808C0A: 49 FF FF
	inc a		; $808C0D: 1A
.yabs:
	sta.b tmp0		; $808C0E: 85 73
	lda.w Xvel,x		; $808C10: BD DF 0A
	bit.w #$8000		; $808C13: 89 00 80
	beq .xabs		; $808C16: F0 04
	eor.w #$FFFF		; $808C18: 49 FF FF
	inc a		; $808C1B: 1A
.xabs:
	clc		; $808C1C: 18
	adc.b tmp0		; $808C1D: 65 73
	sta.w pspeed,x		; $808C1F: 9D 6F 12  |Xvel|+|Yvel|
	lda.w #SPAburst		; $808C22: A9 CA 0B  93G SPAburst $C7E, pfalock
	sta.b d1		; $808C25: 85 57
	sta.w pfalock,x		; $808C27: 9D 7F 11
	jmp.w SetSPA		; $808C2A: 4C 06 B0
skatetopuck:		;auto: CODE_808C2D. 93G skatetopuck (logic93_5): player X skates to the puck. d7 = elapsed frames
	jsl.l $8BFFD3		; $808C2D: 22 D3 FF 8B  bank $8B: 93G skatetopuckinit (d0/d1 = puck spot)
	lda.w temp2,x		; $808C31: BD 7F 0C
	sec		; $808C34: 38
	sbc.b d7		; $808C35: E5 6F
	sta.w temp2,x		; $808C37: 9D 7F 0C
	bmi .aim		; $808C3A: 30 03
	jmp.w .ex		; $808C3C: 4C 1B 8D
.aim:		;every 10 frames: aim at the puck (avoid the goal), maybe sweep check
	adc.w #$0009		; $808C3F: 69 09 00  +10
	sta.w temp2,x		; $808C42: 9D 7F 0C
	jsl.l $8DFE36		; $808C45: 22 36 FE 8D  bank $8D: 93G avdgoal
	lda.b d1		; $808C49: A5 57
	pha		; $808C4B: 48
	lda.b d0		; $808C4C: A5 53
	pha		; $808C4E: 48
	txa		; $808C4F: 8A
	jsl.l GetHot		; $808C50: 22 0A 9B 80
	lda.b d0		; $808C54: A5 53
	eor.w #$FFFF		; $808C56: 49 FF FF
	inc a		; $808C59: 1A
	sec		; $808C5A: 38
	sbc.w Xvel+1,x		; $808C5B: FD E0 0A  - high byte of Xvel
	and.w #$00FF		; $808C5E: 29 FF 00
	bit.w #$0080		; $808C61: 89 80 00
	beq .vx		; $808C64: F0 03
	ora.w #$FF00		; $808C66: 09 00 FF
.vx:
	clc		; $808C69: 18
	adc.b $01,s		; $808C6A: 63 01
	sec		; $808C6C: 38
	sbc.w Xpos,x		; $808C6D: FD FF 08
	sta.b d0		; $808C70: 85 53
	lda.b d1		; $808C72: A5 57
	eor.w #$FFFF		; $808C74: 49 FF FF
	inc a		; $808C77: 1A
	sec		; $808C78: 38
	sbc.w Yvel+1,x		; $808C79: FD 00 0B  - high byte of Yvel
	and.w #$00FF		; $808C7C: 29 FF 00
	bit.w #$0080		; $808C7F: 89 80 00
	beq .vy		; $808C82: F0 03
	ora.w #$FF00		; $808C84: 09 00 FF
.vy:
	clc		; $808C87: 18
	adc.b $03,s		; $808C88: 63 03
	sec		; $808C8A: 38
	sbc.w Ypos,x		; $808C8B: FD 5F 09
	sta.b d1		; $808C8E: 85 57
	pla		; $808C90: 68
	pla		; $808C91: 68
	jsl.l vtoa		; $808C92: 22 A8 AF 80
	lda.b d0		; $808C96: A5 53
	sta.w temp2b,x		; $808C98: 9D FF 0C  temp2b = direction to the puck
	lda.w position,x		; $808C9B: BD 9F 0B
	beq .ex		; $808C9E: F0 7B  goalie skips the sweep check
	lda.w puckvx		; $808CA0: AD FB 0A
	sta.b d0		; $808CA3: 85 53
	lda.w puckvy		; $808CA5: AD 1B 0B
	sta.b d1		; $808CA8: 85 57
	jsl.l vtoa		; $808CAA: 22 A8 AF 80
	lda.b d0		; $808CAE: A5 53
	eor.w #$0004		; $808CB0: 49 04 00  puck coming toward the player
	cmp.w facedir,x		; $808CB3: DD BF 0D
	beq .ex		; $808CB6: F0 63
	lda.w pucky		; $808CB8: AD 7B 09
	sec		; $808CBB: 38
	sbc.w Ypos,x		; $808CBC: FD 5F 09
	sta.b d1		; $808CBF: 85 57
	pha		; $808CC1: 48
	lda.w puckx		; $808CC2: AD 1B 09
	sec		; $808CC5: 38
	sbc.w Xpos,x		; $808CC6: FD FF 08
	sta.b d0		; $808CC9: 85 53
	pha		; $808CCB: 48
	jsl.l vtoa		; $808CCC: 22 A8 AF 80
	lda.b d0		; $808CD0: A5 53
	sta.b tmp0		; $808CD2: 85 73
	pla		; $808CD4: 68
	sta.b d0		; $808CD5: 85 53
	sta.b mula		; $808CD7: 85 7D
	sta.b mulb		; $808CD9: 85 83
	pla		; $808CDB: 68
	sta.b d1		; $808CDC: 85 57
	lda.w facedir,x		; $808CDE: BD BF 0D
	cmp.b tmp0		; $808CE1: C5 73
	bne .ex		; $808CE3: D0 36
	jsl.l $82FCDB		; $808CE5: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $808CE9: 85 53
	lda.b mulres+2		; $808CEB: A5 95
	sta.b d0+2		; $808CED: 85 55
	lda.b d1		; $808CEF: A5 57
	sta.b mula		; $808CF1: 85 7D
	sta.b mulb		; $808CF3: 85 83
	jsl.l $82FCDB		; $808CF5: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $808CF9: 65 53
	sta.b d0		; $808CFB: 85 53
	lda.b d0+2		; $808CFD: A5 55
	adc.b mulres+2		; $808CFF: 65 95
	sta.b d0+2		; $808D01: 85 55
	lda.b d0		; $808D03: A5 53
	cmp.w #$0385		; $808D05: C9 85 03  30*30
	lda.b d0+2		; $808D08: A5 55
	sbc.w #$0000		; $808D0A: E9 00 00
	bcc .ex		; $808D0D: 90 0C
	lda.b d0		; $808D0F: A5 53
	cmp.w #$05A5		; $808D11: C9 A5 05  38*38
	lda.b d0+2		; $808D14: A5 55
	sbc.w #$0000		; $808D16: E9 00 00
	bcc Sweepcheck		; $808D19: 90 6F
.ex:
	lda.w temp2b,x		; $808D1B: BD FF 0C
	sta.b d0		; $808D1E: 85 53
	lda.w position,x		; $808D20: BD 9F 0B
	beq .acc		; $808D23: F0 61
	lda.w Xpos,x		; $808D25: BD FF 08
	sec		; $808D28: 38
	sbc.w puckx		; $808D29: ED 1B 09
	bit.w #$8000		; $808D2C: 89 00 80
	beq .dx		; $808D2F: F0 04
	eor.w #$FFFF		; $808D31: 49 FF FF
	inc a		; $808D34: 1A
.dx:
	sta.b tmp0		; $808D35: 85 73
	lda.w Ypos,x		; $808D37: BD 5F 09
	sec		; $808D3A: 38
	sbc.w pucky		; $808D3B: ED 7B 09
	bit.w #$8000		; $808D3E: 89 00 80
	beq .dy		; $808D41: F0 04
	eor.w #$FFFF		; $808D43: 49 FF FF
	inc a		; $808D46: 1A
.dy:
	clc		; $808D47: 18
	adc.b tmp0		; $808D48: 65 73
	cmp.w #$0036		; $808D4A: C9 36 00  close to the puck (SNES only): slow down, Xvel*7/8, Yvel*7/16
	bcs .acc		; $808D4D: B0 37
	lda.w Xvel,x		; $808D4F: BD DF 0A
	sta.b mula		; $808D52: 85 7D
	lda.w #$0007		; $808D54: A9 07 00
	sta.b mulb		; $808D57: 85 83
	jsl.l $82FCDB		; $808D59: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lsr.b mulres+2		; $808D5D: 46 95
	ror a		; $808D5F: 6A
	lsr.b mulres+2		; $808D60: 46 95
	ror a		; $808D62: 6A
	lsr.b mulres+2		; $808D63: 46 95
	ror a		; $808D65: 6A
	sta.w Xvel,x		; $808D66: 9D DF 0A
	lda.w Yvel,x		; $808D69: BD FF 0A
	sta.b mula		; $808D6C: 85 7D
	lda.w #$0007		; $808D6E: A9 07 00
	sta.b mulb		; $808D71: 85 83
	jsl.l $82FCDB		; $808D73: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lsr.b mulres+2		; $808D77: 46 95
	ror a		; $808D79: 6A
	lsr.b mulres+2		; $808D7A: 46 95
	ror a		; $808D7C: 6A
	lsr.b mulres+2		; $808D7D: 46 95
	ror a		; $808D7F: 6A
	lsr.b mulres+2		; $808D80: 46 95
	ror a		; $808D82: 6A
	sta.w Yvel,x		; $808D83: 9D FF 0A
.acc:
	jml.l $8FFBDC		; $808D86: 5C DC FB 8F  bank $8F: 93G doplayeracc (d0 = direction)
Sweepcheck:		;auto: CODE_808D8A. 93G Sweepcheck (logic93_1): start a sweep check on player X
	lda.w #SPAsweepchk		; $808D8A: A9 90 0A  93G SPAsweepchk $B44, pfalock
	sta.b d1		; $808D8D: 85 57
	sta.w pfalock,x		; $808D8F: 9D 7F 11
	jmp.w SetSPA		; $808D92: 4C 06 B0
chkpk:		;auto: CODE_808D95. 93G chkpk (logic93_3): Z set if player X is killing a penalty. No power play returns NE
	lda.w sflags		; $808D95: AD 8C 12
	and.w #sf2pwrplay		; $808D98: 29 00 20  sf2pwrplay
	bne chkpk2		; $808D9B: D0 02
	inc a		; $808D9D: 1A
	rtl		; $808D9E: 6B
chkpk2:		;auto: CODE_808D9F. 93G chkpk2 (logic93_3): Z set if player X is on the short-handed team (sf2pwrtm vs pfteam)
	lda.w pfteam,x		; $808D9F: BD 9F 11
	bne .team2		; $808DA2: D0 0A
	lda.w sflags		; $808DA4: AD 8C 12
	and.w #sf2pwrtm		; $808DA7: 29 00 40  sf2pwrtm
	eor.w #sf2pwrtm		; $808DAA: 49 00 40
	rtl		; $808DAD: 6B
.team2:
	lda.w sflags		; $808DAE: AD 8C 12
	and.w #sf2pwrtm		; $808DB1: 29 00 40
	rtl		; $808DB4: 6B
assshoot:		;auto: CODE_808DB5 (asstab $12). 93G assshoot (logic93_4): assignment for computer shooting
	lda.w pflags,x		; $808DB5: BD DF 0E
	bit.w #pfna		; $808DB8: 89 02 00  pfna
	beq .nna		; $808DBB: F0 08
	and.w #~pfna&$FFFF		; $808DBD: 29 FD FF
	sta.w pflags,x		; $808DC0: 9D DF 0E
	bra SetShotMode		; $808DC3: 80 24
.nna:
	lda.w sflags		; $808DC5: AD 8C 12
	bit.w #sfssdir		; $808DC8: 89 08 00  sfssdir
	bne .swing		; $808DCB: D0 03
	jmp.w assexit		; $808DCD: 4C F9 96
.swing:		;count down the swing time; then press the shot button (d2 = cbut)
	lda.w temp1,x		; $808DD0: BD 5F 0C
	sta.b d0		; $808DD3: 85 53
	stz.b d2		; $808DD5: 64 5B
	lda.w temp2b,x		; $808DD7: BD FF 0C
	sec		; $808DDA: 38
	sbc.b d7		; $808DDB: E5 6F
	sta.w temp2b,x		; $808DDD: 9D FF 0C
	bpl ShotMode		; $808DE0: 10 51
	lda.w #cbut		; $808DE2: A9 80 00
	tsb.b d2		; $808DE5: 04 5B
	bra ShotMode		; $808DE7: 80 4A
SetShotMode:		;auto: CODE_808DE9. 93G SetShotMode (logic93_1): start a shot by player X: shot mode, direction to goal, shot animation
	lda.w #$0008		; $808DE9: A9 08 00  default shot direction: none
	sta.w passdir		; $808DEC: 8D 3B 04
	lda.w #sfssdir		; $808DEF: A9 08 00
	tsb.w sflags		; $808DF2: 0C 8C 12
	stz.b d0		; $808DF5: 64 53
	lda.w #$0128		; $808DF7: A9 28 01  $128: goal y + 40
	sta.b d1		; $808DFA: 85 57
	lda.w pfgoal,x		; $808DFC: BD 3F 11
	bne .ck0		; $808DFF: D0 05
	lda.w #$FED8		; $808E01: A9 D8 FE
	sta.b d1		; $808E04: 85 57
.ck0:
	lda.b d0		; $808E06: A5 53
	sec		; $808E08: 38
	sbc.w Xpos,x		; $808E09: FD FF 08
	sta.b d0		; $808E0C: 85 53
	lda.b d1		; $808E0E: A5 57
	sec		; $808E10: 38
	sbc.w Ypos,x		; $808E11: FD 5F 09
	sta.b d1		; $808E14: 85 57
	jsl.l vtoa		; $808E16: 22 A8 AF 80
	lda.w #$000F		; $808E1A: A9 0F 00  minimum shot speed
	sta.w passspeed		; $808E1D: 8D 3D 04
	lda.w #SPAshotf		; $808E20: A9 A8 07  93G SPAshotf $81C
	sta.b d1		; $808E23: 85 57
	jsl.l $8FF603		; $808E25: 22 03 F6 8F  bank $8F: 93G Findhittype (Z = forehand)
	beq .ck1		; $808E29: F0 05
	lda.w #SPAshotb		; $808E2B: A9 BA 08  93G SPAshotb $94E
	sta.b d1		; $808E2E: 85 57
.ck1:
	jmp.w SetSPA		; $808E30: 4C 06 B0
ShotMode:		;auto: CODE_808E33. 93G ShotMode (logic93_1): shot input. d0 = dpad, d2 = changed buttons. Falls into doshot at the end of the animation
	lda.w SPAnum,x		; $808E33: BD 1F 0E
	cmp.w #$0018		; $808E36: C9 18 00  7*4: end of the animation
	bcs doshot		; $808E39: B0 3D
	lda.b d0		; $808E3B: A5 53
	bit.w #$0008		; $808E3D: 89 08 00
	bne .ss0		; $808E40: D0 06
	and.w #$0007		; $808E42: 29 07 00
	sta.w passdir		; $808E45: 8D 3B 04
.ss0:
	lda.w SPAnum,x		; $808E48: BD 1F 0E
	cmp.w #$0010		; $808E4B: C9 10 00  4*4: past full windup
	bcs .rts		; $808E4E: B0 27
	lda.w passspeed		; $808E50: AD 3D 04
	clc		; $808E53: 18
	adc.b d7		; $808E54: 65 6F
	sta.w passspeed		; $808E56: 8D 3D 04
	lda.b d2		; $808E59: A5 5B
	bit.w #cbut		; $808E5B: 89 80 00  button released
	beq .rts		; $808E5E: F0 17
	lda.w #$001C		; $808E60: A9 1C 00  end the windup and swing through
	sec		; $808E63: 38
	sbc.w SPAnum,x		; $808E64: FD 1F 0E
	sta.w SPAnum,x		; $808E67: 9D 1F 0E
	cmp.w #$0018		; $808E6A: C9 18 00
	bcc .rts		; $808E6D: 90 08
	lda.w #$0018		; $808E6F: A9 18 00
	sta.w SPAnum,x		; $808E72: 9D 1F 0E
	bra doshot		; $808E75: 80 01
.rts:
	rtl		; $808E77: 6B
doshot:		;auto: CODE_808E78. 93G doshot (logic93_1): stick is at the puck, launch it toward the goal
	stx.b xsave		; $808E78: 86 0A
	ldx.w #$0000		; $808E7A: A2 00 00
.pushd:		;movem d0-d7/a0-a3 to the stack
	lda.b d0,x		; $808E7D: B5 53
	pha		; $808E7F: 48
	inx		; $808E80: E8
	inx		; $808E81: E8
	cpx.w #$0020		; $808E82: E0 20 00
	bne .pushd		; $808E85: D0 F6
	ldx.b xsave		; $808E87: A6 0A
	stx.b xsave		; $808E89: 86 0A
	ldx.w #$0000		; $808E8B: A2 00 00
.pusha:
	lda.b a0,x		; $808E8E: B5 33
	pha		; $808E90: 48
	inx		; $808E91: E8
	inx		; $808E92: E8
	cpx.w #$0010		; $808E93: E0 10 00
	bne .pusha		; $808E96: D0 F6
	ldx.b xsave		; $808E98: A6 0A
	jsl.l checkgoalp_CalcGoalShotDir		; $808E9A: 22 7C FD 80
	lda.w seed		; $808E9E: AD A1 04  sound: wiff (one of 4)
	and.w #$0003		; $808EA1: 29 03 00
	clc		; $808EA4: 18
	adc.w #SFXshotwiff		; $808EA5: 69 98 00
	pha		; $808EA8: 48
	lda.w #sfssdir		; $808EA9: A9 08 00
	trb.w sflags		; $808EAC: 1C 8C 12  sfssdir off, pfalock on
	sta.w pfalock,x		; $808EAF: 9D 7F 11
	txa		; $808EB2: 8A
	lsr a		; $808EB3: 4A
	sta.w shotplayer		; $808EB4: 8D A5 04
	cmp.w puckc		; $808EB7: CD BB 0E  wiffed shot
	beq .hit		; $808EBA: F0 03
	jmp.w .ex		; $808EBC: 4C A4 90
.hit:		;player has the puck: shot taken
	lda.w #SFXshotfh		; $808EBF: A9 8D 00  forehand shot sound
	sta.b $01,s		; $808EC2: 83 01
	lda.w #sf2shot		; $808EC4: A9 00 10  sf2shot
	tsb.w sflags		; $808EC7: 0C 8C 12
	lda.w SPA,x		; $808ECA: BD FF 0D
	cmp.w #SPAshotb		; $808ECD: C9 BA 08
	bne .nbh		; $808ED0: D0 15
	lda.w #SFXshotbh		; $808ED2: A9 8E 00  backhand: sound, 25% less speed
	sta.b $01,s		; $808ED5: 83 01
	lda.w passspeed		; $808ED7: AD 3D 04
	lsr a		; $808EDA: 4A
	lsr a		; $808EDB: 4A
	eor.w #$FFFF		; $808EDC: 49 FF FF
	inc a		; $808EDF: 1A
	clc		; $808EE0: 18
	adc.w passspeed		; $808EE1: 6D 3D 04
	sta.w passspeed		; $808EE4: 8D 3D 04
.nbh:
	lda.w passspeed		; $808EE7: AD 3D 04
	cmp.w #$0032		; $808EEA: C9 32 00  hard shot sound
	bcc .speed		; $808EED: 90 05
	lda.w #SFXshothard		; $808EEF: A9 8F 00
	sta.b $01,s		; $808EF2: 83 01
.speed:		;passspeed = passspeed*(makepde(shotspd)+$14)*$2570/$10000
	lda.w shotspd,x		; $808EF4: BD DF 0F
	sta.b d0		; $808EF7: 85 53
	stx.b a0		; $808EF9: 86 33
	jsl.l makepde		; $808EFB: 22 B4 A1 80
	adc.w #$0014		; $808EFF: 69 14 00
	sta.b mulb		; $808F02: 85 83
	lda.w passspeed		; $808F04: AD 3D 04
	sta.b mula		; $808F07: 85 7D
	jsl.l $8D871C		; $808F09: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	lda.w #$2570		; $808F0D: A9 70 25
	sta.b mula		; $808F10: 85 7D
	jsl.l $888942		; $808F12: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.b mulres+2		; $808F16: A5 95
	sta.w passspeed		; $808F18: 8D 3D 04
	lda.w #$FFFF		; $808F1B: A9 FF FF  puck loose
	sta.w puckc		; $808F1E: 8D BB 0E
	lda.w #$0010		; $808F21: A9 10 00  no puck pickup for 16 frames
	sta.w nopuck,x		; $808F24: 9D 5F 0E
	txa		; $808F27: 8A
	lsr a		; $808F28: 4A
	sta.w lastplayer		; $808F29: 8D 7D 01
	lda.w #blueline+goalline		; $808F2C: A9 08 01
	sta.b d1		; $808F2F: 85 57
	lda.w pfgoal,x		; $808F31: BD 3F 11
	bne .dir		; $808F34: D0 05
	lda.w #-(blueline+goalline)		; $808F36: A9 F8 FE
	sta.b d1		; $808F39: 85 57
.dir:		;d0/d1 = shotsets[passdir] - puck, d2 = height; d3 = distance to the goal
	lda.w passdir		; $808F3B: AD 3B 04
	asl a		; $808F3E: 0A
	asl a		; $808F3F: 0A
	tay		; $808F40: A8
	lda.w #shotsets		; $808F41: A9 EB 90
	sta.b a0		; $808F44: 85 33
	lda.w #shotsets>>16		; $808F46: A9 80 00
	sta.b a0+2		; $808F49: 85 35
	lda.b [a0],y		; $808F4B: B7 33
	sec		; $808F4D: 38
	sbc.w puckx		; $808F4E: ED 1B 09
	sta.b d0		; $808F51: 85 53
	iny		; $808F53: C8
	iny		; $808F54: C8
	lda.b [a0],y		; $808F55: B7 33
	sta.b d2		; $808F57: 85 5B
	pha		; $808F59: 48
	lda.b d1		; $808F5A: A5 57
	sec		; $808F5C: 38
	sbc.w pucky		; $808F5D: ED 7B 09
	sta.b d1		; $808F60: 85 57
	pha		; $808F62: 48
	lda.b d0		; $808F63: A5 53
	pha		; $808F65: 48
	sta.b mula		; $808F66: 85 7D
	sta.b mulb		; $808F68: 85 83
	jsl.l $82FCDB		; $808F6A: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	sta.b d0		; $808F6E: 85 53
	lda.b mulres+2		; $808F70: A5 95
	sta.b d0+2		; $808F72: 85 55
	lda.b d1		; $808F74: A5 57
	sta.b mula		; $808F76: 85 7D
	sta.b mulb		; $808F78: 85 83
	jsl.l $82FCDB		; $808F7A: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	adc.b d0		; $808F7E: 65 53
	sta.b d0		; $808F80: 85 53
	lda.b mulres+2		; $808F82: A5 95
	adc.b d0+2		; $808F84: 65 55
	sta.b d0+2		; $808F86: 85 55
	jsl.l sroot		; $808F88: 22 B1 CB 80
	bne .dist		; $808F8C: D0 01
	inc a		; $808F8E: 1A
.dist:
	sta.b d3		; $808F8F: 85 5F
	lda.w gmode		; $808F91: AD 88 12
	bit.w #gmhl		; $808F94: 89 10 00  gmhl: highlights are always perfect
	beq .chkperf		; $808F97: F0 03
	jmp.w .perf		; $808F99: 4C 1C 90
.chkperf:
	lda.b d3		; $808F9C: A5 5F
	cmp.w #$00C9		; $808F9E: C9 C9 00  too far away for a perfect shot
	bcs .notperf		; $808FA1: B0 0F
	lda.w #$0010		; $808FA3: A9 10 00
	adc.w shotacc,x		; $808FA6: 7D FF 0F
	jsl.l randoma		; $808FA9: 22 8B AE 80
	cmp.w #$000F		; $808FAD: C9 0F 00  chance of a perfect shot
	bcs .perf		; $808FB0: B0 6A
.notperf:		;aim error from passspeed, shotacc and distance
	lda.w passspeed		; $808FB2: AD 3D 04
	lsr a		; $808FB5: 4A
	lsr a		; $808FB6: 4A
	lsr a		; $808FB7: 4A
	sec		; $808FB8: 38
	sbc.w shotacc,x		; $808FB9: FD FF 0F
	clc		; $808FBC: 18
	adc.w #$0010		; $808FBD: 69 10 00
	sta.b mulb		; $808FC0: 85 83
	lda.b d3		; $808FC2: A5 5F
	sta.b mula		; $808FC4: 85 7D
	jsl.l $8D871C		; $808FC6: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	lsr a		; $808FCA: 4A
	lsr a		; $808FCB: 4A
	lsr a		; $808FCC: 4A
	lsr a		; $808FCD: 4A
	lsr a		; $808FCE: 4A
	lsr a		; $808FCF: 4A
	sta.b d0		; $808FD0: 85 53
	lda.b d3		; $808FD2: A5 5F
	cmp.w #$00FB		; $808FD4: C9 FB 00  closer than 251: half the error
	bcs .cp		; $808FD7: B0 02
	lsr.b d0		; $808FD9: 46 53
.cp:
	lda.b d0		; $808FDB: A5 53
	cmp.w #$0088		; $808FDD: C9 88 00  clamp $88
	bcc .ar		; $808FE0: 90 05
	lda.w #$0088		; $808FE2: A9 88 00
	sta.b d0		; $808FE5: 85 53
.ar:
	lda.b d0		; $808FE7: A5 53
	pha		; $808FE9: 48
	jsl.l randomd0s		; $808FEA: 22 A1 F6 80
	adc.b $03,s		; $808FEE: 63 03
	sta.b $03,s		; $808FF0: 83 03
	lda.b $01,s		; $808FF2: A3 01
	sta.b d0		; $808FF4: 85 53
	cmp.w #$003D		; $808FF6: C9 3D 00  max 60
	bcc .ay		; $808FF9: 90 07
	lda.w #$003C		; $808FFB: A9 3C 00
	sta.b d0		; $808FFE: 85 53
	sta.b $01,s		; $809000: 83 01
.ay:
	lda.b $05,s		; $809002: A3 05
	bpl .am		; $809004: 10 02
	lsr.b d0		; $809006: 46 53
.am:
	jsl.l $8FE316		; $809008: 22 16 E3 8F  bank $8F: 93G randomd0s on d0
	lda.b $05,s		; $80900C: A3 05
	adc.b d0		; $80900E: 65 53
	sta.b $05,s		; $809010: 83 05
	pla		; $809012: 68
	lsr a		; $809013: 4A
	jsl.l randoma		; $809014: 22 8B AE 80
	adc.b $05,s		; $809018: 63 05
	sta.b $05,s		; $80901A: 83 05
.perf:		;puckvx/puckvy = passspeed*$44*dx/d3 and dy/d3; puckvz from the height
	lda.w passspeed		; $80901C: AD 3D 04
	sta.b mulb		; $80901F: 85 83
	lda.w #$0044		; $809021: A9 44 00  1024/15
	sta.b mula		; $809024: 85 7D
	jsl.l muls16		; $809026: 22 96 84 80
	pla		; $80902A: 68
	sta.b mula		; $80902B: 85 7D
	jsl.l $82FCDB		; $80902D: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d3		; $809031: A5 5F
	sta.b mula		; $809033: 85 7D
	jsl.l divs		; $809035: 22 6C 99 80
	asl a		; $809039: 0A
	sta.w puckvx		; $80903A: 8D FB 0A
	lda.w passspeed		; $80903D: AD 3D 04
	sta.b mulb		; $809040: 85 83
	lda.w #$0044		; $809042: A9 44 00
	sta.b mula		; $809045: 85 7D
	jsl.l muls16		; $809047: 22 96 84 80
	pla		; $80904B: 68
	sta.b mula		; $80904C: 85 7D
	jsl.l $82FCDB		; $80904E: 22 DB FC 82  bank $82: muls 32-bit, A/mulres+2 = mula*mulb
	lda.b d3		; $809052: A5 5F
	sta.b mula		; $809054: 85 7D
	jsl.l divs		; $809056: 22 6C 99 80
	asl a		; $80905A: 0A
	sta.w puckvy		; $80905B: 8D 1B 0B
	pla		; $80905E: 68
	beq .ex		; $80905F: F0 43
	sta.b mulb		; $809061: 85 83
	lda.w passspeed		; $809063: AD 3D 04
	sta.b mula		; $809066: 85 7D
	jsl.l $8D871C		; $809068: 22 1C 87 8D  bank $8D: mulu, mulres = mula*mulb
	lda.w #$0044		; $80906C: A9 44 00
	sta.b mula		; $80906F: 85 7D
	jsl.l $888942		; $809071: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.b d3		; $809075: A5 5F
	sta.b mula		; $809077: 85 7D
	jsl.l divu		; $809079: 22 E5 CB 80
	asl a		; $80907D: 0A
	sta.b d1		; $80907E: 85 57
	lda.w #$0B33		; $809080: A9 33 0B
	sta.b mula		; $809083: 85 7D
	lda.b d3		; $809085: A5 5F
	sta.b mulb		; $809087: 85 83
	jsl.l $888942		; $809089: 22 42 89 88  bank $88: mulu, mulres = mula*mulb
	lda.w passspeed		; $80908D: AD 3D 04
	sta.b mula		; $809090: 85 7D
	jsl.l divu		; $809092: 22 E5 CB 80
	lsr a		; $809096: 4A
	adc.b d1		; $809097: 65 57
	cmp.w #$1801		; $809099: C9 01 18
	bcc .noup		; $80909C: 90 03
	lda.w #$1800		; $80909E: A9 00 18  max $1800
.noup:
	sta.w puckvz		; $8090A1: 8D 3B 0B
.ex:		;play the sound, movem the registers back
	jsl.l sfx		; $8090A4: 22 8B C2 80
	stx.b xsave		; $8090A8: 86 0A
	ldx.w #$000E		; $8090AA: A2 0E 00
.popa:
	pla		; $8090AD: 68
	sta.b a0,x		; $8090AE: 95 33
	dex		; $8090B0: CA
	dex		; $8090B1: CA
	bpl .popa		; $8090B2: 10 F9
	ldx.b xsave		; $8090B4: A6 0A
	stx.b xsave		; $8090B6: 86 0A
	ldx.w #$001E		; $8090B8: A2 1E 00
.popd:
	pla		; $8090BB: 68
	sta.b d0,x		; $8090BC: 95 53
	dex		; $8090BE: CA
	dex		; $8090BF: CA
	bpl .popd		; $8090C0: 10 F9
	ldx.b xsave		; $8090C2: A6 0A
	ldx.b a3		; $8090C4: A6 3F
	lda.w #blueline+goalline		; $8090C6: A9 08 01  puckvy sign toward the shooting goal
	sta.b tmp0		; $8090C9: 85 73
	lda.w pfgoal,x		; $8090CB: BD 3F 11
	bne .side		; $8090CE: D0 05
	lda.w #-(blueline+goalline)		; $8090D0: A9 F8 FE
	sta.b tmp0		; $8090D3: 85 73
.side:
	lda.b tmp0		; $8090D5: A5 73
	sec		; $8090D7: 38
	sbc.w pucky		; $8090D8: ED 7B 09
	eor.w puckvy		; $8090DB: 4D 1B 0B
	bpl .rtl		; $8090DE: 10 0A
	lda.w puckvy		; $8090E0: AD 1B 0B
	eor.w #$FFFF		; $8090E3: 49 FF FF
	inc a		; $8090E6: 1A
	sta.w puckvy		; $8090E7: 8D 1B 0B
.rtl:
	rtl		; $8090EA: 6B
shotsets:		;93G doshot .shotsets: x offset, height for each shot direction 0-8
	dw 0,$C,$10,$C		; $8090EB  0: straight, high; 1
	dw $10,6,$10,0		; $8090F3  2; 3
	dw 0,0,-$10,0		; $8090FB  4; 5
	dw -$10,6,-$10,$C		; $809103  6; 7
	dw 0,6		; $80910B  8: no direction
