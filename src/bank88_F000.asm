; $88EF9C-$88FFFF  ROM $46F9C-$47FFF: GetPassWord (92G, the password screen), TitleScreen (93G hockey93_07: title backdrop and scrolling credits),
; PlayoffScreen (93G hockey93_06: the playoff tree) with PlayoffTreeSetup, assdefd (logic93_2, asstab 2), SuperAdd (92G), skateto (logic93_5),
; $FF fill. Starts after SpriteSet7 (boundary moved from $88F002).
org $88EF9C
GetPassWord:		;auto: CODE_88EF9C (from $8FF0F4). 92G GetPassWord: the password screen on the game setup backdrop: pick characters from the PasstoText grid; Start decodes it (DecodePW), a bad one
		;   offers retry or the setup screen
	lda.w #$0080		; $88EF9C: A9 80 00  show the password again
	trb.w PassWord		; $88EF9F: 1C 10 16
	jsl.l Readjoy12		; $88EFA2: 22 D2 FA 84
	jsl.l DrawGameSetupBack		; $88EFA6: 22 C3 88 88
	jsl.l ReadPads		; $88EFAA: 22 E8 F3 80
	jsl.l Readjoy12		; $88EFAE: 22 D2 FA 84
	jsl.l $8FE04C		; $88EFB2: 22 4C E0 8F  bank $8F: clear the sprite table
	jsl.l printz		; $88EFB6: 22 0C B9 80
	dw $0005		; $88EFBA  printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$12
	lda.w #17		; $88EFBF: A9 11 00
	sta.b d0		; $88EFC2: 85 53
	lda.w #5		; $88EFC4: A9 05 00
	sta.b d1		; $88EFC7: 85 57
	jsl.l $8FD69F		; $88EFC9: 22 9F D6 8F  Framer 17 x 5, bank $8F: 93G Framer (d0 x d1)
	lda.w #PasswordText		; $88EFCD: A9 8F F2
	sta.b a1		; $88EFD0: 85 37
	lda.w #PasswordText>>16		; $88EFD2: A9 88 00
	sta.b a1+2		; $88EFD5: 85 39
.textlp:
	jsl.l print		; $88EFD7: 22 2D B9 80
	ldy.w #$0002		; $88EFDB: A0 02 00
	lda.b [a1],y		; $88EFDE: B7 37
	and.w #$00FF		; $88EFE0: 29 FF 00
	bne .textlp		; $88EFE3: D0 F2
	dec.w printx		; $88EFE5: CE 7B 04  cursor back over the blanks
	dec.w printx		; $88EFE8: CE 7B 04
	lda.w #PasstoText		; $88EFEB: A9 A6 FB  a0 = PasstoText
	sta.b a0		; $88EFEE: 85 33
	lda.w #PasstoText>>16		; $88EFF0: A9 82 00
	sta.b a0+2		; $88EFF3: 85 35
	lda.w #4		; $88EFF5: A9 04 00
	sta.b d0		; $88EFF8: 85 53
.top2:		;5 rows
	lda.w #5		; $88EFFA: A9 05 00
	sta.b d1		; $88EFFD: 85 57
	lda.w #mesarea		; $88EFFF: A9 91 01  a1 = mesarea, length 13
	sta.b a1		; $88F002: 85 37
	lda.w #$0000		; $88F004: A9 00 00
	sta.b a1+2		; $88F007: 85 39
	lda.w #13		; $88F009: A9 0D 00
	sta.b [a1]		; $88F00C: 87 37
	inc.b a1		; $88F00E: E6 37
	inc.b a1		; $88F010: E6 37
.top1:		;6 columns: character, blank
	lda.b [a0]		; $88F012: A7 33
	sta.b [a1]		; $88F014: 87 37
	inc.b a0		; $88F016: E6 33
	inc.b a1		; $88F018: E6 37
	lda.w #$0020		; $88F01A: A9 20 00
	sta.b [a1]		; $88F01D: 87 37
	inc.b a1		; $88F01F: E6 37
	dec.b d1		; $88F021: C6 57
	bpl .top1		; $88F023: 10 ED
	lda.w #mesarea		; $88F025: A9 91 01
	sta.b a1		; $88F028: 85 37
	lda.w #$0000		; $88F02A: A9 00 00
	sta.b a1+2		; $88F02D: 85 39
	jsl.l print		; $88F02F: 22 2D B9 80
	inc.w printy		; $88F033: EE 7D 04
	inc.w printy		; $88F036: EE 7D 04
	lda.w printx		; $88F039: AD 7B 04
	sec		; $88F03C: 38
	sbc.w #11		; $88F03D: E9 0B 00
	sta.w printx		; $88F040: 8D 7B 04
	dec.b d0		; $88F043: C6 53
	bpl .top2		; $88F045: 10 B3
	stz.b d4		; $88F047: 64 63
	stz.b d5		; $88F049: 64 67
	jsl.l .setd4		; $88F04B: 22 9F F1 88  cursor at character 0, frame around grid character 0
	jsl.l .setd5		; $88F04F: 22 BB F1 88
	jsl.l $8FD69F		; $88F053: 22 9F D6 8F  bank $8F: 93G Framer (d0 x d1)
.topx:
	jsl.l printz		; $88F057: 22 0C B9 80
	dw $0013		; $88F05B  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$13,"D Pad - Select"
	jsl.l printz		; $88F06E: 22 0C B9 80
	dw $0011		; $88F072  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$14,"    A - Next"
	jsl.l printz		; $88F083: 22 0C B9 80
	dw $0011		; $88F087  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$15,"    Y - Back"
.input:
	jsl.l printz		; $88F098: 22 0C B9 80
	dw $0005		; $88F09C  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$10
	jsl.l PWprint		; $88F0A1: 22 F7 85 88
	lda.w #$81C5		; $88F0A5: A9 C5 81
.wait:		;wait for the next vblank
	cmp.b vbint		; $88F0A8: C5 14
	beq .wait		; $88F0AA: F0 FC
	jsl.l $8F8EF7		; $88F0AC: 22 F7 8E 8F  bank $8F: queue the changed textmap words
	jsl.l $8F8F28		; $88F0B0: 22 28 8F 8F  bank $8F
	lda.w #$81C5		; $88F0B4: A9 C5 81
	sta.b vbint		; $88F0B7: 85 14
.pad:
	jsl.l ReadPads		; $88F0B9: 22 E8 F3 80
	lda.w padnew1		; $88F0BD: AD 6E 01
	ora.w padnew1+2		; $88F0C0: 0D 70 01
	beq .pad		; $88F0C3: F0 F4
	sta.b d1		; $88F0C5: 85 57
	bit.w #JOYSTART		; $88F0C7: 89 00 10  Start: done
	beq .keys		; $88F0CA: F0 03
	jmp.w .exit		; $88F0CC: 4C EB F1
.keys:
	stz.b d0		; $88F0CF: 64 53
	dec.b d0		; $88F0D1: C6 53
	bit.w #abut		; $88F0D3: 89 00 40  Y: left
	bne .pwl		; $88F0D6: D0 2D
	stz.b d0		; $88F0D8: 64 53
	inc.b d0		; $88F0DA: E6 53
	bit.w #JOYA		; $88F0DC: 89 80 00  A: right
	bne .pwl		; $88F0DF: D0 24
	bit.w #JOYRIGHT		; $88F0E1: 89 00 01  right: next character
	bne .pws		; $88F0E4: D0 4C
	stz.b d0		; $88F0E6: 64 53
	dec.b d0		; $88F0E8: C6 53
	bit.w #JOYLEFT		; $88F0EA: 89 00 02  left
	bne .pws		; $88F0ED: D0 43
	ldy.w #6		; $88F0EF: A0 06 00
	sty.b d0		; $88F0F2: 84 53
	bit.w #JOYDOWN		; $88F0F4: 89 00 04  down: 6 on
	bne .pws		; $88F0F7: D0 39
	ldy.w #-6		; $88F0F9: A0 FA FF
	sty.b d0		; $88F0FC: 84 53
	bit.w #JOYUP		; $88F0FE: 89 00 08  up: 6 back
	bne .pws		; $88F101: D0 2F
	bra .input		; $88F103: 80 93
.pwl:		;Y/A: cursor d4 left/right
	lda.b d4		; $88F105: A5 63
	clc		; $88F107: 18
	adc.b d0		; $88F108: 65 53
	cmp.w #16		; $88F10A: C9 10 00  PWlength-1
	bcs .input		; $88F10D: B0 89
	sta.b d4		; $88F10F: 85 63
	jsl.l .setd4		; $88F111: 22 9F F1 88
	lda.w #PassWord		; $88F115: A9 10 16
	sta.b a0		; $88F118: 85 33
	lda.w #$0000		; $88F11A: A9 00 00
	sta.b a0+2		; $88F11D: 85 35
	stz.b d0		; $88F11F: 64 53
	ldy.b d4		; $88F121: A4 63
	lda.b [a0],y		; $88F123: B7 33
	and.w #$00FF		; $88F125: 29 FF 00
	cmp.w #PWrange		; $88F128: C9 1E 00  pwrange: a set character
	bcs .pws		; $88F12B: B0 05
	sec		; $88F12D: 38
	sbc.b d5		; $88F12E: E5 67
	sta.b d0		; $88F130: 85 53
.pws:		;dpad: character d5 by d0
	lda.b d5		; $88F132: A5 67
	clc		; $88F134: 18
	adc.b d0		; $88F135: 65 53
	cmp.w #PWrange		; $88F137: C9 1E 00  PWrange
	bcc .pwset		; $88F13A: 90 03
	jmp.w .input		; $88F13C: 4C 98 F0
.pwset:
	pha		; $88F13F: 48
	jsl.l .setd5		; $88F140: 22 BB F1 88
	phx		; $88F144: DA
	lda.w printy		; $88F145: AD 7D 04  erase the old frame (3 x 3 blanks in backmap)
	asl a		; $88F148: 0A
	asl a		; $88F149: 0A
	asl a		; $88F14A: 0A
	asl a		; $88F14B: 0A
	asl a		; $88F14C: 0A
	asl a		; $88F14D: 0A
	adc.w printx		; $88F14E: 6D 7B 04
	adc.w printx		; $88F151: 6D 7B 04
	tax		; $88F154: AA
	lda.w blankchar		; $88F155: AD E7 1B
	sta.l backmap,x		; $88F158: 9F 74 76 7E
	sta.l backmap+2,x		; $88F15C: 9F 76 76 7E
	sta.l backmap+4,x		; $88F160: 9F 78 76 7E
	sta.l backmap+$40,x		; $88F164: 9F B4 76 7E
	sta.l backmap+$42,x		; $88F168: 9F B6 76 7E
	sta.l backmap+$44,x		; $88F16C: 9F B8 76 7E
	sta.l backmap+$80,x		; $88F170: 9F F4 76 7E
	sta.l backmap+$82,x		; $88F174: 9F F6 76 7E
	sta.l backmap+$84,x		; $88F178: 9F F8 76 7E
	plx		; $88F17C: FA
	pla		; $88F17D: 68
	sta.b d5		; $88F17E: 85 67
	jsl.l .setd5		; $88F180: 22 BB F1 88
	jsl.l $8FD69F		; $88F184: 22 9F D6 8F  bank $8F: 93G Framer (d0 x d1)
	lda.w #PassWord		; $88F188: A9 10 16
	sta.b a0		; $88F18B: 85 33
	lda.w #$0000		; $88F18D: A9 00 00
	sta.b a0+2		; $88F190: 85 35
	ldy.b d4		; $88F192: A4 63
	sep #$20		; $88F194: E2 20  PassWord[d4] = d5
	lda.b d5		; $88F196: A5 67
	sta.b [a0],y		; $88F198: 97 33
	rep #$30		; $88F19A: C2 30
	jmp.w .input		; $88F19C: 4C 98 F0
.setd4:		;print the " < " cursor under password character d4
	jsl.l printz		; $88F19F: 22 0C B9 80
	dw $0005		; $88F1A3  printz inline string: length (counts itself), then control bytes / text
	db $FE,$01,$11
	lda.w printx		; $88F1A8: AD 7B 04
	clc		; $88F1AB: 18
	adc.b d4		; $88F1AC: 65 63
	sta.w printx		; $88F1AE: 8D 7B 04
	jsl.l printz		; $88F1B1: 22 0C B9 80
	dw $0005		; $88F1B5  printz inline string: length (counts itself), then control bytes / text
	db " < "
	rtl		; $88F1BA: 6B
.setd5:		;printx/printy and d0 = d1 = 3: frame around grid character d5
	jsl.l printz		; $88F1BB: 22 0C B9 80
	dw $0005		; $88F1BF  printz inline string: length (counts itself), then control bytes / text
	db $FE,$14,$0D
	lda.b d5		; $88F1C4: A5 67
	sta.b mulb		; $88F1C6: 85 83
	lda.w #6		; $88F1C8: A9 06 00
	sta.b mula		; $88F1CB: 85 7D
	jsl.l divu16		; $88F1CD: 22 D8 B8 80  grid row/column of d5 (6 per row)
	asl a		; $88F1D1: 0A
	adc.w printy		; $88F1D2: 6D 7D 04
	sta.w printy		; $88F1D5: 8D 7D 04
	lda.b mulres+2		; $88F1D8: A5 95
	asl a		; $88F1DA: 0A
	adc.w printx		; $88F1DB: 6D 7B 04
	dec a		; $88F1DE: 3A
	dec a		; $88F1DF: 3A
	sta.w printx		; $88F1E0: 8D 7B 04
	lda.w #3		; $88F1E3: A9 03 00
	sta.b d0		; $88F1E6: 85 53
	sta.b d1		; $88F1E8: 85 57
.rtl:
	rtl		; $88F1EA: 6B
.exit:		;Start
	jsl.l DecodePW		; $88F1EB: 22 EA F5 80
	lda.w postarts		; $88F1EF: AD 51 04  no error: exit
	bpl .rtl		; $88F1F2: 10 F6
	jsl.l printz		; $88F1F4: 22 0C B9 80
	dw $0013		; $88F1F8  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$13,"Bad Password  "
	jsl.l printz		; $88F20B: 22 0C B9 80
	dw $0013		; $88F20F  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$14,"A - Retry     "
	jsl.l printz		; $88F222: 22 0C B9 80
	dw $0014		; $88F226  printz inline string: length (counts itself), then control bytes / text
	db $FF,$02,$15,"Y - Exit Screen"
	lda.w #$81C5		; $88F23A: A9 C5 81
.wait2:
	cmp.b vbint		; $88F23D: C5 14
	beq .wait2		; $88F23F: F0 FC
	jsl.l $8F8EF7		; $88F241: 22 F7 8E 8F  bank $8F: queue the changed textmap words
	jsl.l $8F8F28		; $88F245: 22 28 8F 8F  bank $8F
	lda.w #$81C5		; $88F249: A9 C5 81
	sta.b vbint		; $88F24C: 85 14
.notok:
	jsl.l ReadPads		; $88F24E: 22 E8 F3 80
	lda.w padnew1		; $88F252: AD 6E 01
	ora.w padnew1+2		; $88F255: 0D 70 01
	beq .notok		; $88F258: F0 F4
	sta.b d1		; $88F25A: 85 57
	bit.w #abut		; $88F25C: 89 00 40  Y: setup screen
	bne .setup		; $88F25F: D0 24
	bit.w #JOYA		; $88F261: 89 80 00  A: retry
	beq .notok		; $88F264: F0 E8
	jsl.l printz		; $88F266: 22 0C B9 80
	dw $0005		; $88F26A  printz inline string: length (counts itself), then control bytes / text
	db $FF,$01,$12
	lda.w #17		; $88F26F: A9 11 00
	sta.b d0		; $88F272: 85 53
	lda.w #5		; $88F274: A9 05 00
	sta.b d1		; $88F277: 85 57
	lda.w blankchar		; $88F279: AD E7 1B
	sta.b d2		; $88F27C: 85 5B
	jsl.l $8D847C		; $88F27E: 22 7C 84 8D  erase the message box, bank $8D: 93G eraser (d0 x d1, tile d2)
	jmp.w .topx		; $88F282: 4C 57 F0
.setup:		;Y: back to the setup screen (new playoffs)
	lda.w #2		; $88F285: A9 02 00
	sta.w OptPlayMode		; $88F288: 8D 00 16
	jml.l $83FA87		; $88F28B: 5C 87 FA 83  bank $83: the setup screens
PasswordText:		;92G GetPassWord .text: "Password" at 2, 14, "Press Start" at 10, 24, then print at 21, 14; then an empty string ends it
	dw 30		; $88F28F
	db $FF,2,14,"Password",$FF,10,24,"Press Start",$FF,21,14
	dw 3		; $88F2AD
	db 0
TitleScreen:		;auto: CODE_88F2B0 (from $8B816A). 93G TitleScreen (hockey93_07): Title1Map backdrop, StartSong6, then the Credits scroll up 6 rows at a time; Start leaves
	lda.w #$0198		; $88F2B0: A9 98 01  the blank tile and the small font above the title tiles
	sta.w blankchar		; $88F2B3: 8D E7 1B
	inc a		; $88F2B6: 1A
	sta.w smallfontchars		; $88F2B7: 8D D7 1B
	stz.w charofs		; $88F2BA: 9C CD 1B
	stz.w charofs2		; $88F2BD: 9C CF 1B
	jsl.l $8FE404		; $88F2C0: 22 04 E4 8F  bank $8F: 93G forceblack
	jsl.l $8D8120		; $88F2C4: 22 20 81 8D  bank $8D: PPU registers off/clear
	sep #$20		; $88F2C8: E2 20
	cli		; $88F2CA: 58
	lda.w RDNMI		; $88F2CB: AD 10 42
	lda.b #$81		; $88F2CE: A9 81
	sta.w NMITIMEN		; $88F2D0: 8D 00 42
	lda.b #$03		; $88F2D3: A9 03
	sta.w OBSEL		; $88F2D5: 8D 01 21
	lda.b #$01		; $88F2D8: A9 01
	sta.w BGMODE		; $88F2DA: 8D 05 21
	lda.b #$00		; $88F2DD: A9 00
	sta.w BG1SC		; $88F2DF: 8D 07 21
	lda.b #$04		; $88F2E2: A9 04
	sta.w BG2SC		; $88F2E4: 8D 08 21
	lda.b #$11		; $88F2E7: A9 11
	sta.w BG12NBA		; $88F2E9: 8D 0B 21
	lda.b #$03		; $88F2EC: A9 03
	sta.w TM		; $88F2EE: 8D 2C 21
	rep #$30		; $88F2F1: C2 30
	lda.w blankchar		; $88F2F3: AD E7 1B
	ldx.w #$07FE		; $88F2F6: A2 FE 07
.clr:
	sta.l textmap,x		; $88F2F9: 9F 74 6E 7E
	dex		; $88F2FD: CA
	dex		; $88F2FE: CA
	bpl .clr		; $88F2FF: 10 F8
	lda.w #Title1Map		; $88F301: A9 C0 D5  Title1Map (packed): map $700, palette $700, tiles $800
	sta.b tmp0		; $88F304: 85 73
	lda.w #Title1Map>>16		; $88F306: A9 85 00
	sta.b tmp1		; $88F309: 85 75
	jsl.l DecompressGraphics		; $88F30B: 22 3E FA 86
	lda.l TestList		; $88F30F: AF 00 00 7F  first map word fills backmap
	ldx.w #$07FE		; $88F313: A2 FE 07
.fill:
	sta.l backmap,x		; $88F316: 9F 74 76 7E
	dex		; $88F31A: CA
	dex		; $88F31B: CA
	bpl .fill		; $88F31C: 10 F8
	ldx.w #$06FE		; $88F31E: A2 FE 06
.map:
	lda.l TestList,x		; $88F321: BF 00 00 7F
	sta.l backmap,x		; $88F325: 9F 74 76 7E
	dex		; $88F329: CA
	dex		; $88F32A: CA
	bpl .map		; $88F32B: 10 F4
	ldx.w #$057E		; $88F32D: A2 7E 05  rows 0-21: priority
.prio:
	lda.l backmap,x		; $88F330: BF 74 76 7E
	ora.w #$2000		; $88F334: 09 00 20
	sta.l backmap,x		; $88F337: 9F 74 76 7E
	dex		; $88F33B: CA
	dex		; $88F33C: CA
	bpl .prio		; $88F33D: 10 F1
	lda.w #$1000		; $88F33F: A9 00 10
	sta.w VMADDL		; $88F342: 8D 16 21
	ldx.w #$0000		; $88F345: A2 00 00
.tiles:
	lda.l TestList+$800,x		; $88F348: BF 00 08 7F
	sta.w VMDATAL		; $88F34C: 8D 18 21
	inx		; $88F34F: E8
	inx		; $88F350: E8
	cpx.w #$3300		; $88F351: E0 00 33
	bne .tiles		; $88F354: D0 F2
	sep #$20		; $88F356: E2 20
	stz.w CGADD		; $88F358: 9C 21 21
	ldx.w #$0000		; $88F35B: A2 00 00
.pal:
	lda.l TestList+$700,x		; $88F35E: BF 00 07 7F
	sta.w CGDATA		; $88F362: 8D 22 21
	inx		; $88F365: E8
	cpx.w #$0100		; $88F366: E0 00 01
	bne .pal		; $88F369: D0 F3
	rep #$30		; $88F36B: C2 30
	ldx.w #$0010		; $88F36D: A2 10 00
.zero:
	stz.w VMDATAL		; $88F370: 9C 18 21
	dex		; $88F373: CA
	bne .zero		; $88F374: D0 FA
	lda.w #BigFontTiles		; $88F376: A9 D8 C6  BigFontTiles, remapped with the table at $8FE154
	sta.b tmp0		; $88F379: 85 73
	lda.w #BigFontTiles>>16		; $88F37B: A9 83 00
	sta.b tmp1		; $88F37E: 85 75
	jsl.l DecompressGraphics		; $88F380: 22 3E FA 86
	lda.w #$0000		; $88F384: A9 00 00
	sta.b a0		; $88F387: 85 33
	lda.w #$007F		; $88F389: A9 7F 00
	sta.b a0+2		; $88F38C: 85 35
	lda.w #$E154		; $88F38E: A9 54 E1
	sta.b a1		; $88F391: 85 37
	lda.w #$008F		; $88F393: A9 8F 00
	sta.b a1+2		; $88F396: 85 39
	lda.w #$0064		; $88F398: A9 64 00
	sta.b d0		; $88F39B: 85 53
	jsl.l $8FE0E4		; $88F39D: 22 E4 E0 8F  bank $8F: remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	jsl.l StartSong6		; $88F3A1: 22 E1 FB 86
	jsl.l printz		; $88F3A5: 22 0C B9 80
	dw $0005		; $88F3A9  printz inline string: length (counts itself), then control bytes / text
	db $CF,$00,$1C
	stz.b d0		; $88F3AE: 64 53
	lda.w #Credits		; $88F3B0: A9 A8 FA  a0 = the credits text ($8AFAA8)
	sta.b a0		; $88F3B3: 85 33
	lda.w #Credits>>16		; $88F3B5: A9 8A 00
	sta.b a0+2		; $88F3B8: 85 35
	lda.w #textmap		; $88F3BA: A9 74 6E  DMAList: textmap ($7E6E74) $1000 bytes to vram 0 each frame
	sta.w DMAList		; $88F3BD: 8D 53 16
	lda.w #textmap>>16		; $88F3C0: A9 7E 00
	sta.w DMAList+dmabank		; $88F3C3: 8D 55 16
	lda.w #$1000		; $88F3C6: A9 00 10
	sta.w DMAList+dmalen		; $88F3C9: 8D 56 16
	stz.w DMAList+dmavram		; $88F3CC: 9C 58 16
	lda.w #dmasize		; $88F3CF: A9 07 00
	sta.b DMAListend		; $88F3D2: 85 A3
	lda.w #$8293		; $88F3D4: A9 93 82  title vblank handler $8293
	sta.b vbint		; $88F3D7: 85 14
	lda.w #$0001		; $88F3D9: A9 01 00
	sta.b fadein		; $88F3DC: 85 08
.wait1:
	cmp.b vbint		; $88F3DE: C5 14
	beq .wait1		; $88F3E0: F0 FC
.top2:		;next credits page
	ldy.w #$0002		; $88F3E2: A0 02 00
	lda.b [a0],y		; $88F3E5: B7 33
	and.w #$00FF		; $88F3E7: 29 FF 00
	cmp.w #$00FF		; $88F3EA: C9 FF 00  end of the credits
	bne .top4		; $88F3ED: D0 03
	jmp.w .exit		; $88F3EF: 4C E8 F4
.top4:		;93G .top4: blank the 6 rows below the screen
	lda.w printy		; $88F3F2: AD 7D 04
	pha		; $88F3F5: 48
	ldx.w #$0006		; $88F3F6: A2 06 00
.erase:
	stz.w printx		; $88F3F9: 9C 7B 04
	txa		; $88F3FC: 8A
	clc		; $88F3FD: 18
	adc.b $01,s		; $88F3FE: 63 01
	and.w #$001F		; $88F400: 29 1F 00
	sta.w printy		; $88F403: 8D 7D 04
	lda.w #CreditsBlank		; $88F406: A9 F0 F4
	sta.b a1		; $88F409: 85 37
	lda.w #CreditsBlank>>16		; $88F40B: A9 88 00
	sta.b a1+2		; $88F40E: 85 39
	jsl.l print		; $88F410: 22 2D B9 80
	dex		; $88F414: CA
	bpl .erase		; $88F415: 10 E2
	lda.b $01,s		; $88F417: A3 01
	sta.w printy		; $88F419: 8D 7D 04
.top4x:		;print the page lines centred
	lda.w #34		; $88F41C: A9 22 00  printx = (34 - length) / 2
	sec		; $88F41F: 38
	sbc.b [a0]		; $88F420: E7 33
	lsr a		; $88F422: 4A
	sta.w printx		; $88F423: 8D 7B 04
	lda.b a0		; $88F426: A5 33
	sta.b a1		; $88F428: 85 37
	lda.b a0+2		; $88F42A: A5 35
	sta.b a1+2		; $88F42C: 85 39
	jsl.l print		; $88F42E: 22 2D B9 80
	lda.w printy		; $88F432: AD 7D 04
	inc a		; $88F435: 1A
	and.w #$001F		; $88F436: 29 1F 00
	sta.w printy		; $88F439: 8D 7D 04
	lda.b [a0]		; $88F43C: A7 33
	clc		; $88F43E: 18
	adc.b a0		; $88F43F: 65 33
	sta.b a0		; $88F441: 85 33
	ldy.w #$0002		; $88F443: A0 02 00
	lda.b [a0],y		; $88F446: B7 33
	and.w #$00FF		; $88F448: 29 FF 00
	sta.b d3		; $88F44B: 85 5F
	cmp.w #$00FE		; $88F44D: C9 FE 00  $FE: last page, $FF: end
	beq .scroll		; $88F450: F0 05
	cmp.w #$00FF		; $88F452: C9 FF 00
	bne .top4x		; $88F455: D0 C5
.scroll:
	lda.b [a0]		; $88F457: A7 33
	clc		; $88F459: 18
	adc.b a0		; $88F45A: 65 33
	sta.b a0		; $88F45C: 85 33
	pla		; $88F45E: 68
	clc		; $88F45F: 18
	adc.w #6		; $88F460: 69 06 00
	and.w #$001F		; $88F463: 29 1F 00
	sta.w printy		; $88F466: 8D 7D 04
	sec		; $88F469: 38  scroll target
	sbc.w #28		; $88F46A: E9 1C 00
	and.w #$001F		; $88F46D: 29 1F 00
	asl a		; $88F470: 0A
	asl a		; $88F471: 0A
	asl a		; $88F472: 0A
	sta.b d1		; $88F473: 85 57
	jsl.l $8F8EF7		; $88F475: 22 F7 8E 8F  bank $8F: queue the changed textmap words
.top5:		;scroll 6*8 lines
	lda.b d0		; $88F479: A5 53
	inc a		; $88F47B: 1A
	and.w #$00FF		; $88F47C: 29 FF 00
	sta.b d0		; $88F47F: 85 53
	lda.w #$8293		; $88F481: A9 93 82
	sta.b vbint		; $88F484: 85 14
.wait:
	cmp.b vbint		; $88F486: C5 14
	beq .wait		; $88F488: F0 FC
	jsl.l ReadPads		; $88F48A: 22 E8 F3 80
	lda.b d3		; $88F48E: A5 5F
	cmp.w #$00FE		; $88F490: C9 FE 00  $FE: no Start (copyright page)
	bne .nopause		; $88F493: D0 06
	stz.w padnew1		; $88F495: 9C 6E 01
	stz.w padnew1+2		; $88F498: 9C 70 01
.nopause:
	lda.w padnew1		; $88F49B: AD 6E 01
	ora.w padnew1+2		; $88F49E: 0D 70 01
	bit.w #JOYSTART		; $88F4A1: 89 00 10
	bne .exit		; $88F4A4: D0 42
	lda.b d0		; $88F4A6: A5 53
	cmp.b d1		; $88F4A8: C5 57
	bne .top5		; $88F4AA: D0 CD
	lda.b vcount		; $88F4AC: A5 00  90 frames
	clc		; $88F4AE: 18
	adc.w #90		; $88F4AF: 69 5A 00
	sta.b d2		; $88F4B2: 85 5B
	lda.b d3		; $88F4B4: A5 5F
	cmp.w #$00FE		; $88F4B6: C9 FE 00
	bne .top6s		; $88F4B9: D0 19
	lda.b vcount		; $88F4BB: A5 00  180 frames for the copyright page
	clc		; $88F4BD: 18
	adc.w #180		; $88F4BE: 69 B4 00
	sta.b d2		; $88F4C1: 85 5B
.top6:
	jsl.l ReadPads		; $88F4C3: 22 E8 F3 80
	lda.b d3		; $88F4C7: A5 5F
	cmp.w #$00FE		; $88F4C9: C9 FE 00
	bne .top6s		; $88F4CC: D0 06
	stz.w padnew1		; $88F4CE: 9C 6E 01
	stz.w padnew1+2		; $88F4D1: 9C 70 01
.top6s:
	lda.w padnew1		; $88F4D4: AD 6E 01
	ora.w padnew1+2		; $88F4D7: 0D 70 01
	bit.w #JOYSTART		; $88F4DA: 89 00 10
	bne .exit		; $88F4DD: D0 09
	lda.b vcount		; $88F4DF: A5 00
	cmp.b d2		; $88F4E1: C5 5B
	bne .top6		; $88F4E3: D0 DE
	jmp.w .top2		; $88F4E5: 4C E2 F3
.exit:		;wait for the default vblank handler, return
	lda.b vbint		; $88F4E8: A5 14
	cmp.w #$80DE		; $88F4EA: C9 DE 80  the default vblank handler $80DE
	bne .exit		; $88F4ED: D0 F9
	rtl		; $88F4EF: 6B
CreditsBlank:		;print string of 32 blanks: TitleScreen erases the rows below the credits with it
	dw 34		; $88F4F0
	db "                                "
PlayoffScreen:		;auto: CODE_88F512 (from ContinuePlayoffs, $80F5F2). 93G PlayoffScreen (hockey93_06): set the font tile bases; in playoff mode draw the tree (PlayoffTreeSetup by gamelevel: team
		;   blocks, arrows, series scores) with the NHLPA logo, PWprint; scroll with left/right until Start
	lda.w #6		; $88F512: A9 06 00  tile bases: small font 6, big font +100, score/team blocks +100, NHLPA logo +405
	sta.w smallfontchars		; $88F515: 8D D7 1B
	clc		; $88F518: 18
	adc.w #100		; $88F519: 69 64 00
	sta.w BigFontChars		; $88F51C: 8D D1 1B
	adc.w #100		; $88F51F: 69 64 00
	sta.w scorechars		; $88F522: 8D E5 1B
	adc.w #405		; $88F525: 69 95 01
	sta.w logochars		; $88F528: 8D DD 1B
	stz.w charofs		; $88F52B: 9C CD 1B
	stz.w charofs2		; $88F52E: 9C CF 1B
	lda.w OptPlayMode		; $88F531: AD 00 16  not in playoff mode: done
	bne .po		; $88F534: D0 03
	jmp.w .rtl		; $88F536: 4C 04 F7
.po:
	jsl.l $8FE404		; $88F539: 22 04 E4 8F  bank $8F: 93G forceblack
	sep #$20		; $88F53D: E2 20
	lda.b #$01		; $88F53F: A9 01
	sta.w BGMODE		; $88F541: 8D 05 21
	lda.b #$01		; $88F544: A9 01
	sta.w BG1SC		; $88F546: 8D 07 21
	lda.b #$01		; $88F549: A9 01
	sta.w BG12NBA		; $88F54B: 8D 0B 21
	lda.b #$01		; $88F54E: A9 01
	sta.w TM		; $88F550: 8D 2C 21
	rep #$30		; $88F553: C2 30
	lda.w #$1000		; $88F555: A9 00 10
	sta.w VMADDL		; $88F558: 8D 16 21
	lda.w #PlayoffTiles		; $88F55B: A9 9D F7  PlayoffTiles ($84F79D): 128 colours, then 6 tiles
	sta.b tmp0		; $88F55E: 85 73
	lda.w #PlayoffTiles>>16		; $88F560: A9 84 00
	sta.b tmp1		; $88F563: 85 75
	jsl.l DecompressGraphics		; $88F565: 22 3E FA 86
	ldx.w #$0000		; $88F569: A2 00 00
.tl:
	lda.l TestList+$100,x		; $88F56C: BF 00 01 7F
	sta.w VMDATAL		; $88F570: 8D 18 21
	inx		; $88F573: E8
	inx		; $88F574: E8
	cpx.w #$00C0		; $88F575: E0 C0 00
	bne .tl		; $88F578: D0 F2
	ldx.w #$0000		; $88F57A: A2 00 00
.pl:
	lda.l TestList,x		; $88F57D: BF 00 00 7F
	sta.l palbuffer,x		; $88F581: 9F 74 6C 7E
	inx		; $88F585: E8
	inx		; $88F586: E8
	cpx.w #$0100		; $88F587: E0 00 01
	bne .pl		; $88F58A: D0 F1
	lda.w #BigFontTiles		; $88F58C: A9 D8 C6  BigFontTiles twice: remapped with $8FE154, then with PixelRemap83
	sta.b tmp0		; $88F58F: 85 73
	lda.w #BigFontTiles>>16		; $88F591: A9 83 00
	sta.b tmp1		; $88F594: 85 75
	jsl.l DecompressGraphics		; $88F596: 22 3E FA 86
	lda.w #$0000		; $88F59A: A9 00 00
	sta.b a0		; $88F59D: 85 33
	lda.w #$007F		; $88F59F: A9 7F 00
	sta.b a0+2		; $88F5A2: 85 35
	lda.w #$E154		; $88F5A4: A9 54 E1
	sta.b a1		; $88F5A7: 85 37
	lda.w #$008F		; $88F5A9: A9 8F 00
	sta.b a1+2		; $88F5AC: 85 39
	lda.w #$0064		; $88F5AE: A9 64 00
	sta.b d0		; $88F5B1: 85 53
	jsl.l $8FE0E4		; $88F5B3: 22 E4 E0 8F  bank $8F: remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	lda.w #BigFontTiles		; $88F5B7: A9 D8 C6
	sta.b tmp0		; $88F5BA: 85 73
	lda.w #BigFontTiles>>16		; $88F5BC: A9 83 00
	sta.b tmp1		; $88F5BF: 85 75
	jsl.l DecompressGraphics		; $88F5C1: 22 3E FA 86
	lda.w #$0000		; $88F5C5: A9 00 00
	sta.b a0		; $88F5C8: 85 33
	lda.w #$007F		; $88F5CA: A9 7F 00
	sta.b a0+2		; $88F5CD: 85 35
	lda.w #PixelRemap83		; $88F5CF: A9 D4 FC
	sta.b a1		; $88F5D2: 85 37
	lda.w #PixelRemap83>>16		; $88F5D4: A9 82 00
	sta.b a1+2		; $88F5D7: 85 39
	lda.w #$0064		; $88F5D9: A9 64 00
	sta.b d0		; $88F5DC: 85 53
	jsl.l $8FE0E4		; $88F5DE: 22 E4 E0 8F  bank $8F: remap the 4bpp pixels ([a0] data, [a1] table, d0 tiles)
	lda.w #TeamBlocksTiles		; $88F5E2: A9 73 9B  TeamBlocksTiles
	sta.b tmp0		; $88F5E5: 85 73
	lda.w #TeamBlocksTiles>>16		; $88F5E7: A9 88 00
	sta.b tmp1		; $88F5EA: 85 75
	jsl.l DecompressGraphics		; $88F5EC: 22 3E FA 86
	ldx.w #$0000		; $88F5F0: A2 00 00
.tb:
	lda.l TestList,x		; $88F5F3: BF 00 00 7F
	sta.w VMDATAL		; $88F5F7: 8D 18 21
	inx		; $88F5FA: E8
	inx		; $88F5FB: E8
	cpx.w #$32A0		; $88F5FC: E0 A0 32
	bne .tb		; $88F5FF: D0 F2
	lda.w #$0000		; $88F601: A9 00 00  clear textmap and backmap (128 x 32 map)
	ldx.w #$1FFE		; $88F604: A2 FE 1F
.clr:
	sta.l textmap,x		; $88F607: 9F 74 6E 7E
	dex		; $88F60B: CA
	dex		; $88F60C: CA
	bpl .clr		; $88F60D: 10 F8
	lda.w #potree		; $88F60F: A9 53 04  a1 = potree
	sta.b a1		; $88F612: 85 37
	lda.w #$0000		; $88F614: A9 00 00
	sta.b a1+2		; $88F617: 85 39
	lda.w #PlayoffTreeSetup		; $88F619: A9 FB F9  a0 = PlayoffTreeSetup level gamelevel
	sta.b a0		; $88F61C: 85 33
	lda.w #PlayoffTreeSetup>>16		; $88F61E: A9 88 00
	sta.b a0+2		; $88F621: 85 35
	lda.w gamelevel		; $88F623: AD 4A 01
	asl a		; $88F626: 0A
	tay		; $88F627: A8
	lda.b [a0],y		; $88F628: B7 33
	adc.b a0		; $88F62A: 65 33
	sta.b a0		; $88F62C: 85 33
	lda.b [a0]		; $88F62E: A7 33
	inc.b a0		; $88F630: E6 33
	and.w #$00FF		; $88F632: 29 FF 00
	sta.b d4		; $88F635: 85 63
.team:		;DrawTeamBlocks: team block of tree slot d4 at x, y
	lda.b [a0]		; $88F637: A7 33
	inc.b a0		; $88F639: E6 33
	and.w #$00FF		; $88F63B: 29 FF 00
	sta.w printx		; $88F63E: 8D 7B 04
	stz.w printa		; $88F641: 9C 77 04
	lda.b [a0]		; $88F644: A7 33
	inc.b a0		; $88F646: E6 33
	and.w #$00FF		; $88F648: 29 FF 00
	sta.w printy		; $88F64B: 8D 7D 04
	lda.b [a1]		; $88F64E: A7 37  team of the slot
	inc.b a1		; $88F650: E6 37
	and.w #$00FF		; $88F652: 29 FF 00
	sta.b mula		; $88F655: 85 7D
	ldy.w potreeteam		; $88F657: AC 73 04  the user's team: palette 7
	eor.w potree,y		; $88F65A: 59 53 04
	and.w #$00FF		; $88F65D: 29 FF 00
	bne .other		; $88F660: D0 06
	lda.w #$1C00		; $88F662: A9 00 1C
	sta.w printa		; $88F665: 8D 77 04
.other:
	lda.w #36		; $88F668: A9 24 00  36 bytes per TeamBlocksMap entry
	sta.b mulb		; $88F66B: 85 83
	jsl.l $8D871C		; $88F66D: 22 1C 87 8D  bank $8D: 16-bit multiply
	tay		; $88F671: A8
	lda.w #TeamBlocksMap		; $88F672: A9 BA CA
	sta.b a2		; $88F675: 85 3B
	lda.w #TeamBlocksMap>>16		; $88F677: A9 87 00
	sta.b a2+2		; $88F67A: 85 3D
	lda.w printy		; $88F67C: AD 7D 04  textmap offset (y * 128 + x) * 2
	asl a		; $88F67F: 0A
	asl a		; $88F680: 0A
	asl a		; $88F681: 0A
	asl a		; $88F682: 0A
	asl a		; $88F683: 0A
	asl a		; $88F684: 0A
	asl a		; $88F685: 0A
	adc.w printx		; $88F686: 6D 7B 04
	asl a		; $88F689: 0A
	tax		; $88F68A: AA
	lda.w #9		; $88F68B: A9 09 00
	sta.b tmp0		; $88F68E: 85 73
	sta.b tmp1		; $88F690: 85 75
.row1:
	lda.b [a2],y		; $88F692: B7 3B
	clc		; $88F694: 18
	adc.w scorechars		; $88F695: 6D E5 1B
	adc.w charofs		; $88F698: 6D CD 1B
	ora.w printa		; $88F69B: 0D 77 04
	sta.l textmap,x		; $88F69E: 9F 74 6E 7E
	iny		; $88F6A2: C8
	iny		; $88F6A3: C8
	inx		; $88F6A4: E8
	inx		; $88F6A5: E8
	dec.b tmp0		; $88F6A6: C6 73
	bne .row1		; $88F6A8: D0 E8
.row2:
	lda.b [a2],y		; $88F6AA: B7 3B
	clc		; $88F6AC: 18
	adc.w scorechars		; $88F6AD: 6D E5 1B
	adc.w charofs		; $88F6B0: 6D CD 1B
	ora.w printa		; $88F6B3: 0D 77 04
	sta.l textmap+$EE,x		; $88F6B6: 9F 62 6F 7E
	iny		; $88F6BA: C8
	iny		; $88F6BB: C8
	inx		; $88F6BC: E8
	inx		; $88F6BD: E8
	dec.b tmp1		; $88F6BE: C6 75
	bne .row2		; $88F6C0: D0 E8
	dec.b d4		; $88F6C2: C6 63
	beq .arrow		; $88F6C4: F0 03
	jmp.w .team		; $88F6C6: 4C 37 F6
.arrow:		;DrawPlayoffBracket: arrow column (23 rows of PlayoffBracketMap) at x; $FF ends
	lda.b [a0]		; $88F6C9: A7 33
	inc.b a0		; $88F6CB: E6 33
	and.w #$00FF		; $88F6CD: 29 FF 00
	cmp.w #$00FF		; $88F6D0: C9 FF 00
	beq .scores		; $88F6D3: F0 30
	asl a		; $88F6D5: 0A  column n of PlayoffBracketMap (23 rows of 12 words)
	adc.w #PlayoffBracketMap		; $88F6D6: 69 80 F8
	sta.b tmp0		; $88F6D9: 85 73
	lda.w #PlayoffBracketMap>>16		; $88F6DB: A9 8A 00
	sta.b tmp1		; $88F6DE: 85 75
	lda.b [a0]		; $88F6E0: A7 33
	inc.b a0		; $88F6E2: E6 33
	and.w #$00FF		; $88F6E4: 29 FF 00
	asl a		; $88F6E7: 0A
	tax		; $88F6E8: AA
	ldy.w #23		; $88F6E9: A0 17 00
.al:
	lda.b [tmp0]		; $88F6EC: A7 73
	sta.l textmap+$200,x		; $88F6EE: 9F 74 70 7E
	lda.b tmp0		; $88F6F2: A5 73
	clc		; $88F6F4: 18
	adc.w #24		; $88F6F5: 69 18 00
	sta.b tmp0		; $88F6F8: 85 73
	txa		; $88F6FA: 8A
	adc.w #$0100		; $88F6FB: 69 00 01
	tax		; $88F6FE: AA
	dey		; $88F6FF: 88
	bne .al		; $88F700: D0 EA
	bra .arrow		; $88F702: 80 C5
.rtl:
	rtl		; $88F704: 6B
.scores:		;scroll limits, then the series scores (not for single games)
	lda.b [a0]		; $88F705: A7 33  Hscroll limits (x8)
	inc.b a0		; $88F707: E6 33
	and.w #$00FF		; $88F709: 29 FF 00
	asl a		; $88F70C: 0A
	asl a		; $88F70D: 0A
	asl a		; $88F70E: 0A
	sta.b d2+2		; $88F70F: 85 5D
	lda.b [a0]		; $88F711: A7 33
	inc.b a0		; $88F713: E6 33
	and.w #$00FF		; $88F715: 29 FF 00
	asl a		; $88F718: 0A
	asl a		; $88F719: 0A
	asl a		; $88F71A: 0A
	sta.b d0+2		; $88F71B: 85 55
	stz.b d3+2		; $88F71D: 64 61
	jsl.l printz		; $88F71F: 22 0C B9 80
	dw $0005		; $88F723  printz inline string: length (counts itself), then control bytes / text
	db $EF,$00,$00
	lda.b bosgames		; $88F728: A5 D6  single games: no scores
	cmp.w #7		; $88F72A: C9 07 00
	beq .logo		; $88F72D: F0 59
	lda.b [a0]		; $88F72F: A7 33
	inc.b a0		; $88F731: E6 33
	and.w #$00FF		; $88F733: 29 FF 00
	sta.b d4		; $88F736: 85 63
	beq .logo		; $88F738: F0 4E
	stz.b a2		; $88F73A: 64 3B
.sc:
	lda.b [a0]		; $88F73C: A7 33
	inc.b a0		; $88F73E: E6 33
	and.w #$00FF		; $88F740: 29 FF 00
	sta.w printx		; $88F743: 8D 7B 04
	lda.b [a0]		; $88F746: A7 33
	inc.b a0		; $88F748: E6 33
	and.w #$00FF		; $88F74A: 29 FF 00
	asl a		; $88F74D: 0A
	asl a		; $88F74E: 0A
	sta.w printy		; $88F74F: 8D 7D 04
	lda.w #$0191		; $88F752: A9 91 01
	sta.b a1		; $88F755: 85 37
	lda.w #$0000		; $88F757: A9 00 00
	sta.b a1+2		; $88F75A: 85 39
	lda.w #5		; $88F75C: A9 05 00  mesarea "<home wins>-<away wins>"
	sta.w mesarea		; $88F75F: 8D 91 01
	ldx.b a2		; $88F762: A6 3B
	lda.w gspotwins,x		; $88F764: BD 9F 15
	adc.w #'0'		; $88F767: 69 30 00
	sta.w mesarea+2		; $88F76A: 8D 93 01
	lda.w #'-'		; $88F76D: A9 2D 00
	sta.w mesarea+3		; $88F770: 8D 94 01
	lda.w gspobwins,x		; $88F773: BD AF 15
	adc.w #'0'		; $88F776: 69 30 00
	sta.w mesarea+4		; $88F779: 8D 95 01
	jsl.l print		; $88F77C: 22 2D B9 80
	inc.b a2		; $88F780: E6 3B
	inc.b a2		; $88F782: E6 3B
	dec.b d4		; $88F784: C6 63
	bne .sc		; $88F786: D0 B4
.logo:		;the NHLPA logo ($8C8000): palette row 2, tiles at logochars, map at x 60, y 2
	lda.w #NHLPALogo		; $88F788: A9 00 80
	sta.b tmp0		; $88F78B: 85 73
	lda.w #NHLPALogo>>16		; $88F78D: A9 8C 00
	sta.b tmp1		; $88F790: 85 75
	jsl.l DecompressGraphics		; $88F792: 22 3E FA 86
	ldx.w #$001E		; $88F796: A2 1E 00  logo palette to palette row 2
.lp:
	lda.l TestList+$A0,x		; $88F799: BF A0 00 7F
	sta.l palbuffer+$C0,x		; $88F79D: 9F 34 6D 7E
	dex		; $88F7A1: CA
	dex		; $88F7A2: CA
	bpl .lp		; $88F7A3: 10 F4
	lda.w logochars		; $88F7A5: AD DD 1B  logo tiles to vram logochars
	asl a		; $88F7A8: 0A
	asl a		; $88F7A9: 0A
	asl a		; $88F7AA: 0A
	asl a		; $88F7AB: 0A
	adc.w #$1000		; $88F7AC: 69 00 10
	sta.w VMADDL		; $88F7AF: 8D 16 21
	ldx.w #$0000		; $88F7B2: A2 00 00
.lt:
	lda.l TestList+$1A0,x		; $88F7B5: BF A0 01 7F
	sta.w VMDATAL		; $88F7B9: 8D 18 21
	inx		; $88F7BC: E8
	inx		; $88F7BD: E8
	cpx.w #$06A0		; $88F7BE: E0 A0 06
	bne .lt		; $88F7C1: D0 F2
	stz.b tmp1		; $88F7C3: 64 75
.lr:
	stz.b tmp0		; $88F7C5: 64 73
.lc:
	lda.b tmp1		; $88F7C7: A5 75
	sta.b mula		; $88F7C9: 85 7D
	lda.w #8		; $88F7CB: A9 08 00
	sta.b mulb		; $88F7CE: 85 83
	jsl.l $8D871C		; $88F7D0: 22 1C 87 8D  bank $8D: 16-bit multiply
	adc.b tmp0		; $88F7D4: 65 73
	asl a		; $88F7D6: 0A
	tax		; $88F7D7: AA
	lda.l TestList,x		; $88F7D8: BF 00 00 7F
	adc.w logochars		; $88F7DC: 6D DD 1B
	ora.w #$1800		; $88F7DF: 09 00 18  palette 6, priority
	pha		; $88F7E2: 48
	lda.b tmp1		; $88F7E3: A5 75
	asl a		; $88F7E5: 0A
	asl a		; $88F7E6: 0A
	asl a		; $88F7E7: 0A
	asl a		; $88F7E8: 0A
	asl a		; $88F7E9: 0A
	asl a		; $88F7EA: 0A
	asl a		; $88F7EB: 0A
	adc.b tmp0		; $88F7EC: 65 73
	asl a		; $88F7EE: 0A
	tax		; $88F7EF: AA
	pla		; $88F7F0: 68
	sta.l textmap+$A78,x		; $88F7F1: 9F EC 78 7E
	inc.b tmp0		; $88F7F5: E6 73
	lda.b tmp0		; $88F7F7: A5 73
	cmp.w #8		; $88F7F9: C9 08 00
	bne .lc		; $88F7FC: D0 C9
	inc.b tmp1		; $88F7FE: E6 75
	lda.b tmp1		; $88F800: A5 75
	cmp.w #10		; $88F802: C9 0A 00
	bne .lr		; $88F805: D0 BE
	jsl.l $8FE04C		; $88F807: 22 4C E0 8F  bank $8F: clear the sprite table
	jsl.l printz		; $88F80B: 22 0C B9 80
	dw $0005		; $88F80F  printz inline string: length (counts itself), then control bytes / text
	db $EF,"8d"
	jsl.l PWprint		; $88F814: 22 F7 85 88
	lda.w #$0180		; $88F818: A9 80 01  start in the middle
	sta.w Hscroll		; $88F81B: 8D 56 01
	stz.w printx		; $88F81E: 9C 7B 04
	stz.w printy		; $88F821: 9C 7D 04
	lda.w #32		; $88F824: A9 20 00
	sta.b d0		; $88F827: 85 53
	lda.w #4		; $88F829: A9 04 00
	sta.b d1		; $88F82C: 85 57
	lda.w BigFontChars		; $88F82E: AD D1 1B  blank the top and bottom rows with big font tile 0
	ora.w #$1000		; $88F831: 09 00 10
	sta.b d2		; $88F834: 85 5B
	jsl.l $8D847C		; $88F836: 22 7C 84 8D  bank $8D: 93G eraser (d0 x d1, tile d2)
	stz.w printx		; $88F83A: 9C 7B 04
	lda.w #104		; $88F83D: A9 68 00
	sta.w printy		; $88F840: 8D 7D 04
	lda.w #32		; $88F843: A9 20 00
	sta.b d0		; $88F846: 85 53
	lda.w #24		; $88F848: A9 18 00
	sta.b d1		; $88F84B: 85 57
	lda.w BigFontChars		; $88F84D: AD D1 1B
	ora.w #$1000		; $88F850: 09 00 10
	sta.b d2		; $88F853: 85 5B
	jsl.l $8D847C		; $88F855: 22 7C 84 8D  bank $8D: 93G eraser (d0 x d1, tile d2)
	jsl.l StartSong9		; $88F859: 22 8F FB 89  keep the music going
.scroll:		;clamp Hscroll, queue the 128-column map window, wait a frame
	lda.w Hscroll		; $88F85D: AD 56 01
	cmp.b d2+2		; $88F860: C5 5D
	bcs .min		; $88F862: B0 02
	lda.b d2+2		; $88F864: A5 5D
.min:
	cmp.b d0+2		; $88F866: C5 55
	bcc .max		; $88F868: 90 02
	lda.b d0+2		; $88F86A: A5 55
.max:
	sta.w Hscroll		; $88F86C: 8D 56 01
	lsr a		; $88F86F: 4A
	lsr a		; $88F870: 4A
	lsr a		; $88F871: 4A
	asl a		; $88F872: 0A
	adc.w #textmap		; $88F873: 69 74 6E  source column in textmap
	sta.b tmp0		; $88F876: 85 73
	stz.b tmp1		; $88F878: 64 75
	ldy.w #$0000		; $88F87A: A0 00 00
.dma:
	lda.b tmp1		; $88F87D: A5 75
	sta.w DMAList+dmavram,y		; $88F87F: 99 58 16
	clc		; $88F882: 18
	adc.w #$0020		; $88F883: 69 20 00
	sta.b tmp1		; $88F886: 85 75
	adc.w #$03E0		; $88F888: 69 E0 03
	sta.w DMAList+dmasize+dmavram,y		; $88F88B: 99 5F 16
	lda.b tmp0		; $88F88E: A5 73
	sta.w DMAList,y		; $88F890: 99 53 16
	adc.w #$0040		; $88F893: 69 40 00
	sta.w DMAList+dmasize+dmasrc,y		; $88F896: 99 5A 16
	adc.w #$00C0		; $88F899: 69 C0 00
	sta.b tmp0		; $88F89C: 85 73
	lda.w #textmap>>16		; $88F89E: A9 7E 00
	sta.w DMAList+dmabank,y		; $88F8A1: 99 55 16
	sta.w DMAList+dmasize+dmabank,y		; $88F8A4: 99 5C 16
	lda.w #$0040		; $88F8A7: A9 40 00
	sta.w DMAList+dmalen,y		; $88F8AA: 99 56 16
	lda.w #$000A		; $88F8AD: A9 0A 00
	sta.w DMAList+dmasize+dmalen,y		; $88F8B0: 99 5D 16
	tya		; $88F8B3: 98
	adc.w #2*dmasize		; $88F8B4: 69 0E 00
	tay		; $88F8B7: A8
	cpy.w #32*2*dmasize		; $88F8B8: C0 C0 01  32 rows: 2 dma entries each
	bne .dma		; $88F8BB: D0 C0
	sty.b DMAListend		; $88F8BD: 84 A3
	lda.w #$82E0		; $88F8BF: A9 E0 82  playoff vblank handler $82E0
	sta.b vbint		; $88F8C2: 85 14
.wait:
	cmp.b vbint		; $88F8C4: C5 14
	beq .wait		; $88F8C6: F0 FC
.pad:
	jsl.l ReadPads		; $88F8C8: 22 E8 F3 80
	lda.w padnew1		; $88F8CC: AD 6E 01
	ora.w padnew1+2		; $88F8CF: 0D 70 01
	cmp.w #JOYSTART		; $88F8D2: C9 00 10
	bne .frame		; $88F8D5: D0 03
	jmp.w .rtl		; $88F8D7: 4C 04 F7
.frame:		;colour 1 of palette 7 blends between the .blink colours (30 frame cycle)
	lda.b vcount		; $88F8DA: A5 00
	cmp.b d7		; $88F8DC: C5 6F
	beq .pad		; $88F8DE: F0 E8
	sta.b d7		; $88F8E0: 85 6F
	sta.b mulb		; $88F8E2: 85 83  vcount mod 30, then the half
	lda.w #30		; $88F8E4: A9 1E 00
	sta.b mula		; $88F8E7: 85 7D
	jsl.l divu16		; $88F8E9: 22 D8 B8 80
	lda.b mulres+2		; $88F8ED: A5 95
	sta.b tmp0		; $88F8EF: 85 73
	lda.w #2		; $88F8F1: A9 02 00
	sta.b mula		; $88F8F4: 85 7D
	jsl.l divu16		; $88F8F6: 22 D8 B8 80
	lda.b mulres+2		; $88F8FA: A5 95
	asl a		; $88F8FC: 0A
	tax		; $88F8FD: AA
	lda.l .blink,x		; $88F8FE: BF E5 F9 88
	xba		; $88F902: EB
	and.w #$00FF		; $88F903: 29 FF 00
	lsr a		; $88F906: 4A
	lsr a		; $88F907: 4A
	sta.b tmp1		; $88F908: 85 75
	lda.l .blink+2,x		; $88F90A: BF E7 F9 88
	xba		; $88F90E: EB
	and.w #$00FF		; $88F90F: 29 FF 00
	lsr a		; $88F912: 4A
	lsr a		; $88F913: 4A
	sec		; $88F914: 38
	sbc.b tmp1		; $88F915: E5 75
	sta.b mula		; $88F917: 85 7D
	lda.b tmp0		; $88F919: A5 73
	sta.b mulb		; $88F91B: 85 83
	jsl.l muls32		; $88F91D: 22 DB FC 82
	lda.w #30		; $88F921: A9 1E 00
	sta.b mula		; $88F924: 85 7D
	jsl.l divs		; $88F926: 22 6C 99 80
	adc.b tmp1		; $88F92A: 65 75
	and.w #$001F		; $88F92C: 29 1F 00
	xba		; $88F92F: EB
	and.w #$FF00		; $88F930: 29 00 FF
	asl a		; $88F933: 0A
	asl a		; $88F934: 0A
	sta.b tmp2		; $88F935: 85 77
	lda.l .blink,x		; $88F937: BF E5 F9 88
	lsr a		; $88F93B: 4A
	lsr a		; $88F93C: 4A
	lsr a		; $88F93D: 4A
	lsr a		; $88F93E: 4A
	lsr a		; $88F93F: 4A
	and.w #$001F		; $88F940: 29 1F 00
	sta.b tmp1		; $88F943: 85 75
	lda.l .blink+2,x		; $88F945: BF E7 F9 88
	lsr a		; $88F949: 4A
	lsr a		; $88F94A: 4A
	lsr a		; $88F94B: 4A
	lsr a		; $88F94C: 4A
	lsr a		; $88F94D: 4A
	and.w #$001F		; $88F94E: 29 1F 00
	sec		; $88F951: 38
	sbc.b tmp1		; $88F952: E5 75
	sta.b mula		; $88F954: 85 7D
	lda.b tmp0		; $88F956: A5 73
	sta.b mulb		; $88F958: 85 83
	jsl.l muls32		; $88F95A: 22 DB FC 82
	lda.w #30		; $88F95E: A9 1E 00
	sta.b mula		; $88F961: 85 7D
	jsl.l divs		; $88F963: 22 6C 99 80
	adc.b tmp1		; $88F967: 65 75
	and.w #$001F		; $88F969: 29 1F 00
	asl a		; $88F96C: 0A
	asl a		; $88F96D: 0A
	asl a		; $88F96E: 0A
	asl a		; $88F96F: 0A
	asl a		; $88F970: 0A
	tsb.b tmp2		; $88F971: 04 77
	lda.l .blink,x		; $88F973: BF E5 F9 88
	and.w #$001F		; $88F977: 29 1F 00
	sta.b tmp1		; $88F97A: 85 75
	lda.l .blink+2,x		; $88F97C: BF E7 F9 88
	and.w #$001F		; $88F980: 29 1F 00
	sec		; $88F983: 38
	sbc.b tmp1		; $88F984: E5 75
	sta.b mula		; $88F986: 85 7D
	lda.b tmp0		; $88F988: A5 73
	sta.b mulb		; $88F98A: 85 83
	jsl.l muls32		; $88F98C: 22 DB FC 82
	lda.w #30		; $88F990: A9 1E 00
	sta.b mula		; $88F993: 85 7D
	jsl.l divs		; $88F995: 22 6C 99 80
	adc.b tmp1		; $88F999: 65 75
	and.w #$001F		; $88F99B: 29 1F 00
	ora.b tmp2		; $88F99E: 05 77
	sta.l palbuffer+$E2		; $88F9A0: 8F 56 6D 7E
	lda.w joypad1		; $88F9A4: AD 5E 01  held: left/right scroll
	ora.w joypad2		; $88F9A7: 0D 60 01
	cmp.w #JOYLEFT		; $88F9AA: C9 00 02
	beq .left		; $88F9AD: F0 3C
	cmp.w #JOYRIGHT		; $88F9AF: C9 00 01
	beq .right		; $88F9B2: F0 3F
.move:
	lda.w Hscroll		; $88F9B4: AD 56 01
	clc		; $88F9B7: 18
	adc.b d3+2		; $88F9B8: 65 61
	sta.w Hscroll		; $88F9BA: 8D 56 01
	cmp.w #$0058		; $88F9BD: C9 58 00
	beq .stop		; $88F9C0: F0 1E
	cmp.w #$00B0		; $88F9C2: C9 B0 00
	beq .stop		; $88F9C5: F0 19
	cmp.w #$0108		; $88F9C7: C9 08 01
	beq .stop		; $88F9CA: F0 14
	cmp.w #$0180		; $88F9CC: C9 80 01
	beq .stop		; $88F9CF: F0 0F
	cmp.w #$01F8		; $88F9D1: C9 F8 01
	beq .stop		; $88F9D4: F0 0A
	cmp.w #$0250		; $88F9D6: C9 50 02
	beq .stop		; $88F9D9: F0 05
	cmp.w #$02A8		; $88F9DB: C9 A8 02
	bne .loop		; $88F9DE: D0 02
.stop:		;stop at the round columns
	stz.b d3+2		; $88F9E0: 64 61
.loop:
	jmp.w .scroll		; $88F9E2: 4C 5D F8
.blink:		;BGR555 colours the user's team block blinks between (white, blue, white)
	dw $7FFF,$7E10,$7FFF		; $88F9E5
.left:
	lda.w #$FFFF		; $88F9EB: A9 FF FF
	sta.b d3+2		; $88F9EE: 85 61
	jmp.w .move		; $88F9F0: 4C B4 F9
.right:
	lda.w #$0001		; $88F9F3: A9 01 00
	sta.b d3+2		; $88F9F6: 85 61
	jmp.w .move		; $88F9F8: 4C B4 F9
PlayoffTreeSetup:		;93G PlayoffTreeSetup: playoff tree layout by gamelevel (offsets, then per level: slots, arrows, scroll limits, scores)
	dw .l0-PlayoffTreeSetup,.l1-PlayoffTreeSetup,.l2-PlayoffTreeSetup,.l3-PlayoffTreeSetup,.l4-PlayoffTreeSetup		; $88F9FB
.l0:		;gamelevel 0: 16 team slots (x, y)
	db 16		; $88FA05
	db 49,2,49,5,49,8,49,11,49,14,49,17,49,20,49,23		; $88FA06
	db 70,2,70,5,70,8,70,11,70,14,70,17,70,20,70,23		; $88FA16
	db 0,58,1,59,10,68,11,69,$FF		; $88FA26 arrows (graphics, x), $FF
	db 48,48		; $88FA2F Hscroll min, max (x8)
	db 8,52,4,52,10,52,16,52,22,73,4,73,10,73,16,73,22		; $88FA31 series scores (x, y)
.l1:		;gamelevel 1: 24 team slots (x, y)
	db 24		; $88FA42
	db 38,2,38,5,38,8,38,11,38,14,38,17,38,20,38,23		; $88FA43
	db 81,2,81,5,81,8,81,11,81,14,81,17,81,20,81,23		; $88FA53
	db 49,4,49,10,49,15,49,21,70,4,70,10,70,15,70,21		; $88FA63
	db 0,47,1,48,2,58,3,59,8,68,9,69,10,79,11,80,$FF		; $88FA73 arrows (graphics, x), $FF
	db 33,63		; $88FA84 Hscroll min, max (x8)
	db 4,52,8,52,18,73,8,73,18		; $88FA86 series scores (x, y)
.l2:		;gamelevel 2: 28 team slots (x, y)
	db 28		; $88FA8F
	db 27,2,27,5,27,8,27,11,27,14,27,17,27,20,27,23		; $88FA90
	db 92,2,92,5,92,8,92,11,92,14,92,17,92,20,92,23		; $88FAA0
	db 38,4,38,10,38,15,38,21,81,4,81,10,81,15,81,21		; $88FAB0
	db 49,7,49,18,70,7,70,18		; $88FAC0
	db 0,36,1,37,2,47,3,48,4,58,5,59,6,68,7,69,8,79,9,80,10,90,11,91,$FF		; $88FAC8 arrows (graphics, x), $FF
	db 22,74		; $88FAE1 Hscroll min, max (x8)
	db 2,52,13,73,13		; $88FAE3 series scores (x, y)
.l3:		;gamelevel 3: 30 team slots (x, y)
	db 30		; $88FAE8
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23		; $88FAE9
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23		; $88FAF9
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21		; $88FB09
	db 38,7,38,18,81,7,81,18,49,12,70,12		; $88FB19
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; $88FB25 arrows (graphics, x), $FF
	db 11,85		; $88FB42 Hscroll min, max (x8)
	db 1,62,23		; $88FB44 series scores (x, y)
.l4:		;gamelevel 4: 31 team slots (x, y)
	db 31		; $88FB47
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23		; $88FB48
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23		; $88FB58
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21		; $88FB68
	db 38,7,38,18,81,7,81,18,49,12,70,12,59,23		; $88FB78
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; $88FB86 arrows (graphics, x), $FF
	db 11,85		; $88FBA3 Hscroll min, max (x8)
	db 0		; $88FBA5 series scores (x, y)
assdefd:		;auto: CODE_88FBA6 (asstab 2). 93G assdefd (logic93_2): defenceman on defence: stay between the furthest-up attacker and the goal, join the attack (adefo) when the puck is past the line
	lda.w pfalock,x		; $88FBA6: BD 7F 11
	beq .go		; $88FBA9: F0 03
	jmp.w .rtl		; $88FBAB: 4C 1C FD
.go:
	lda.w gmclock		; $88FBAE: AD 8A 12
	beq .gm		; $88FBB1: F0 04
	jml.l $8FD75A		; $88FBB3: 5C 5A D7 8F  bank $8F: assnothing
.gm:
	jsl.l check4bench		; $88FBB7: 22 27 85 80
	lda.w pflags,x		; $88FBBB: BD DF 0E
	bit.w #pfjoycon		; $88FBBE: 89 08 00
	beq .chk		; $88FBC1: F0 03
	jmp.w .rtl		; $88FBC3: 4C 1C FD
.chk:
	bit.w #pfna		; $88FBC6: 89 02 00
	beq .nna		; $88FBC9: F0 12
	and.w #~pfna&$FFFF		; $88FBCB: 29 FD FF
	sta.w pflags,x		; $88FBCE: 9D DF 0E
	stz.w temp1,x		; $88FBD1: 9E 5F 0C
	stz.w temp2,x		; $88FBD4: 9E 7F 0C
	lda.w #8		; $88FBD7: A9 08 00
	sta.w temp2b,x		; $88FBDA: 9D FF 0C
.nna:
	lda.w temp1,x		; $88FBDD: BD 5F 0C
	sec		; $88FBE0: 38
	sbc.b d7		; $88FBE1: E5 6F
	sta.w temp1,x		; $88FBE3: 9D 5F 0C
	bmi .new		; $88FBE6: 30 03
	jmp.w .de3		; $88FBE8: 4C 96 FD
.new:
	clc		; $88FBEB: 18
	adc.w aidef,x		; $88FBEC: 7D BF 0F
	bpl .t1		; $88FBEF: 10 03
	lda.w #$0000		; $88FBF1: A9 00 00
.t1:
	sta.w temp1,x		; $88FBF4: 9D 5F 0C
	lda.w pucky		; $88FBF7: AD 7B 09
	sta.b d1		; $88FBFA: 85 57
	lda.w puckvy		; $88FBFC: AD 1B 0B
	lsr a		; $88FBFF: 4A
	lsr a		; $88FC00: 4A
	lsr a		; $88FC01: 4A
	lsr a		; $88FC02: 4A
	lsr a		; $88FC03: 4A
	lsr a		; $88FC04: 4A
	bit.w #$0200		; $88FC05: 89 00 02
	beq .sx		; $88FC08: F0 03
	ora.w #$FC00		; $88FC0A: 09 00 FC
.sx:
	sta.b d3		; $88FC0D: 85 5F
	lda.w pfgoal,x		; $88FC0F: BD 3F 11
	bne .de00		; $88FC12: D0 10
	lda.b d1		; $88FC14: A5 57
	eor.w #$FFFF		; $88FC16: 49 FF FF
	inc a		; $88FC19: 1A
	sta.b d1		; $88FC1A: 85 57
	lda.b d3		; $88FC1C: A5 5F
	eor.w #$FFFF		; $88FC1E: 49 FF FF
	inc a		; $88FC21: 1A
	sta.b d3		; $88FC22: 85 5F
.de00:		;only lead when moving up ice
	lda.b d3		; $88FC24: A5 5F
	bpl .v		; $88FC26: 10 02
	stz.b d3		; $88FC28: 64 5F
.v:
	lda.b d3		; $88FC2A: A5 5F
	clc		; $88FC2C: 18
	adc.b d1		; $88FC2D: 65 57
	sta.b d3		; $88FC2F: 85 5F
	sec		; $88FC31: 38
	sbc.w #$58		; $88FC32: E9 58 00
	bmi .lt		; $88FC35: 30 04
	bvc .ge		; $88FC37: 50 04
	bra .de0		; $88FC39: 80 38
.lt:
	bvc .de0		; $88FC3B: 50 36
.ge:
	ldy.b a2		; $88FC3D: A4 3B
	lda.w tmflags,y		; $88FC3F: B9 0A 14
	bit.w #tmfoffside		; $88FC42: 89 10 00
	bne .de0		; $88FC45: D0 2C
	lda.w puckc		; $88FC47: AD BB 0E
	sta.b d1		; $88FC4A: 85 57
	bmi .de0		; $88FC4C: 30 25
	jsl.l chkpk		; $88FC4E: 22 95 8D 80
	beq .de0		; $88FC52: F0 1F
	lda.w #1		; $88FC54: A9 01 00
	sta.b d0		; $88FC57: 85 53
	lda.b d1		; $88FC59: A5 57
	sec		; $88FC5B: 38
	sbc.w #6		; $88FC5C: E9 06 00
	sta.b d1		; $88FC5F: 85 57
	txa		; $88FC61: 8A
	lsr a		; $88FC62: 4A
	sec		; $88FC63: 38
	sbc.w #6		; $88FC64: E9 06 00
	sta.b d2		; $88FC67: 85 5B
	eor.b d1		; $88FC69: 45 57
	sta.b d1		; $88FC6B: 85 57
	bmi .de0		; $88FC6D: 30 04
	jml.l assreplace		; $88FC6F: 5C A7 B4 80
.de0:
	lda.w #65		; $88FC73: A9 41 00
	sta.w temp3,x		; $88FC76: 9D 9F 0C
	lda.w position,x		; $88FC79: BD 9F 0B
	cmp.w #$0002		; $88FC7C: C9 02 00
	beq .de1		; $88FC7F: F0 06
	lda.w #-65		; $88FC81: A9 BF FF
	sta.w temp3,x		; $88FC84: 9D 9F 0C
.de1:
	stz.b a0		; $88FC87: 64 33
	cpx.w #12		; $88FC89: E0 0C 00
	bcs .de2		; $88FC8C: B0 05
	lda.w #12		; $88FC8E: A9 0C 00
	sta.b a0		; $88FC91: 85 33
.de2:		;find the furthest-up attacker
	lda.w #5		; $88FC93: A9 05 00
	sta.b d2		; $88FC96: 85 5B
	lda.w #-1000		; $88FC98: A9 18 FC
	sta.b d0		; $88FC9B: 85 53
	lda.w pfgoal,x		; $88FC9D: BD 3F 11
	beq .gdwn		; $88FCA0: F0 7B
	lda.w #1000		; $88FCA2: A9 E8 03
	sta.b d0		; $88FCA5: 85 53
.gup:
	ldy.b a0		; $88FCA7: A4 33
	lda.w pflags,y		; $88FCA9: B9 DF 0E
	bit.w #$1000		; $88FCAC: 89 00 10
	bne .gu0		; $88FCAF: D0 30
	lda.w position,y		; $88FCB1: B9 9F 0B
	bmi .gu0		; $88FCB4: 30 2B
	lda.w Yvel,y		; $88FCB6: B9 FF 0A
	bmi .gu2		; $88FCB9: 30 03
	lda.w #$0000		; $88FCBB: A9 00 00
.gu2:
	lsr a		; $88FCBE: 4A
	lsr a		; $88FCBF: 4A
	lsr a		; $88FCC0: 4A
	lsr a		; $88FCC1: 4A
	bit.w #$0800		; $88FCC2: 89 00 08
	beq .gu2s		; $88FCC5: F0 03
	ora.w #$F000		; $88FCC7: 09 00 F0
.gu2s:
	clc		; $88FCCA: 18
	adc.w Ypos,y		; $88FCCB: 79 5F 09
	sta.b d1		; $88FCCE: 85 57
	sec		; $88FCD0: 38
	sbc.b d0		; $88FCD1: E5 53
	beq .gu3		; $88FCD3: F0 08
	bmi .gt		; $88FCD5: 30 04
	bvs .gu3		; $88FCD7: 70 04
	bra .gu0		; $88FCD9: 80 06
.gt:
	bvs .gu0		; $88FCDB: 70 04
.gu3:
	lda.b d1		; $88FCDD: A5 57
	sta.b d0		; $88FCDF: 85 53
.gu0:
	inc.b a0		; $88FCE1: E6 33
	inc.b a0		; $88FCE3: E6 33
	dec.b d2		; $88FCE5: C6 5B
	bpl .gup		; $88FCE7: 10 BE
	lda.b d0		; $88FCE9: A5 53
	sec		; $88FCEB: 38
	sbc.w #50		; $88FCEC: E9 32 00
	sta.b d0		; $88FCEF: 85 53
	sec		; $88FCF1: 38
	sbc.w #-190		; $88FCF2: E9 42 FF
	beq .cl1		; $88FCF5: F0 08
	bmi .gt1		; $88FCF7: 30 04
	bvs .cl1		; $88FCF9: 70 04
	bra .gu1		; $88FCFB: 80 07
.gt1:
	bvs .gu1		; $88FCFD: 70 05
.cl1:
	lda.w #-220		; $88FCFF: A9 24 FF
	sta.b d0		; $88FD02: 85 53
.gu1:
	lda.b d0		; $88FD04: A5 53
	sta.w temp4,x		; $88FD06: 9D BF 0C
	lda.w puckx		; $88FD09: AD 1B 09
	sta.b d0		; $88FD0C: 85 53
	lda.w temp3,x		; $88FD0E: BD 9F 0C
	eor.b d0		; $88FD11: 45 53
	sta.b d1		; $88FD13: 85 57
	bpl .de3		; $88FD15: 10 7F
	stz.w temp3,x		; $88FD17: 9E 9F 0C
	bra .de3		; $88FD1A: 80 7A
.rtl:
	rtl		; $88FD1C: 6B
.gdwn:
	ldy.b a0		; $88FD1D: A4 33
	lda.w pflags,y		; $88FD1F: B9 DF 0E
	bit.w #$1000		; $88FD22: 89 00 10
	bne .gd0		; $88FD25: D0 2E
	lda.w position,y		; $88FD27: B9 9F 0B
	bmi .gd0		; $88FD2A: 30 29
	lda.w Yvel,y		; $88FD2C: B9 FF 0A
	bpl .gd2		; $88FD2F: 10 03
	lda.w #$0000		; $88FD31: A9 00 00
.gd2:
	lsr a		; $88FD34: 4A
	lsr a		; $88FD35: 4A
	lsr a		; $88FD36: 4A
	lsr a		; $88FD37: 4A
	bit.w #$0800		; $88FD38: 89 00 08
	beq .gd2s		; $88FD3B: F0 03
	ora.w #$F000		; $88FD3D: 09 00 F0
.gd2s:
	clc		; $88FD40: 18
	adc.w Ypos,y		; $88FD41: 79 5F 09
	sta.b d1		; $88FD44: 85 57
	sec		; $88FD46: 38
	sbc.b d0		; $88FD47: E5 53
	bmi .lt2		; $88FD49: 30 04
	bvc .gd3		; $88FD4B: 50 04
	bra .gd0		; $88FD4D: 80 06
.lt2:
	bvc .gd0		; $88FD4F: 50 04
.gd3:
	lda.b d1		; $88FD51: A5 57
	sta.b d0		; $88FD53: 85 53
.gd0:
	inc.b a0		; $88FD55: E6 33
	inc.b a0		; $88FD57: E6 33
	dec.b d2		; $88FD59: C6 5B
	bpl .gdwn		; $88FD5B: 10 C0
	lda.b d0		; $88FD5D: A5 53
	clc		; $88FD5F: 18
	adc.w #50		; $88FD60: 69 32 00
	sta.b d0		; $88FD63: 85 53
	sec		; $88FD65: 38
	sbc.w #190		; $88FD66: E9 BE 00
	bmi .lt3		; $88FD69: 30 04
	bvc .cl2		; $88FD6B: 50 04
	bra .gd1		; $88FD6D: 80 07
.lt3:
	bvc .gd1		; $88FD6F: 50 05
.cl2:
	lda.w #220		; $88FD71: A9 DC 00
	sta.b d0		; $88FD74: 85 53
.gd1:
	lda.b d0		; $88FD76: A5 53
	sta.w temp4,x		; $88FD78: 9D BF 0C
	lda.w temp3,x		; $88FD7B: BD 9F 0C
	eor.w #$FFFF		; $88FD7E: 49 FF FF
	inc a		; $88FD81: 1A
	sta.w temp3,x		; $88FD82: 9D 9F 0C
	lda.w puckx		; $88FD85: AD 1B 09
	sta.b d0		; $88FD88: 85 53
	lda.w temp3,x		; $88FD8A: BD 9F 0C
	eor.b d0		; $88FD8D: 45 53
	sta.b d1		; $88FD8F: 85 57
	bpl .de3		; $88FD91: 10 03
	stz.w temp3,x		; $88FD93: 9E 9F 0C
.de3:
	lda.w temp3,x		; $88FD96: BD 9F 0C
	sta.b d0		; $88FD99: 85 53
	lda.w temp4,x		; $88FD9B: BD BF 0C
	sta.b d1		; $88FD9E: 85 57
	lda.w #EvadePC		; $88FDA0: A9 6A FD
	sta.b a0		; $88FDA3: 85 33
	lda.w #EvadePC>>16		; $88FDA5: A9 89 00
	sta.b a0+2		; $88FDA8: 85 35
	jsl.l skateto		; $88FDAA: 22 D0 FD 88
	jml.l check4check		; $88FDAE: 5C 15 8B 80
SuperAdd:		;auto: CODE_88FDB2. 92G SuperAdd: passbits (8 words) += d0
	phx		; $88FDB2: DA
	lda.w passbits		; $88FDB3: AD 24 16
	clc		; $88FDB6: 18
	adc.b d0		; $88FDB7: 65 53
	sta.w passbits		; $88FDB9: 8D 24 16
	bcc .ex		; $88FDBC: 90 0F
	ldx.w #$0002		; $88FDBE: A2 02 00
.carry:
	inc.w passbits,x		; $88FDC1: FE 24 16
	bne .ex		; $88FDC4: D0 07
	inx		; $88FDC6: E8
	inx		; $88FDC7: E8
	cpx.w #16		; $88FDC8: E0 10 00
	bne .carry		; $88FDCB: D0 F4
.ex:
	plx		; $88FDCD: FA
	clc		; $88FDCE: 18
	rtl		; $88FDCF: 6B
skateto:		;auto: CODE_88FDD0. 93G skateto (logic93_5): a0 = collision avoidance routine, d0/d1 = x/y to skate to, d7 = frames. SNES: a skater near the target (sum of distances < 55) slows to 7/8
	lda.w position,x		; $88FDD0: BD 9F 0B
	beq .t2		; $88FDD3: F0 77
	lda.w pflags,x		; $88FDD5: BD DF 0E
	and.w #$8000		; $88FDD8: 29 00 80
	ora.w sfhormode		; $88FDDB: 0D 8E 12
	bne .t2		; $88FDDE: D0 6C
	lda.b d0		; $88FDE0: A5 53
	bit.w #$8000		; $88FDE2: 89 00 80
	beq .ax		; $88FDE5: F0 04
	eor.w #$FFFF		; $88FDE7: 49 FF FF
	inc a		; $88FDEA: 1A
.ax:
	cmp.w #$0088		; $88FDEB: C9 88 00
	bcs .t2		; $88FDEE: B0 5C
	lda.w Xpos,x		; $88FDF0: BD FF 08
	sec		; $88FDF3: 38
	sbc.b d0		; $88FDF4: E5 53
	bit.w #$8000		; $88FDF6: 89 00 80
	beq .dx		; $88FDF9: F0 04
	eor.w #$FFFF		; $88FDFB: 49 FF FF
	inc a		; $88FDFE: 1A
.dx:
	sta.b tmp0		; $88FDFF: 85 73
	lda.w Ypos,x		; $88FE01: BD 5F 09
	sec		; $88FE04: 38
	sbc.b d1		; $88FE05: E5 57
	bit.w #$8000		; $88FE07: 89 00 80
	beq .dy		; $88FE0A: F0 04
	eor.w #$FFFF		; $88FE0C: 49 FF FF
	inc a		; $88FE0F: 1A
.dy:
	clc		; $88FE10: 18
	adc.b tmp0		; $88FE11: 65 73
	cmp.w #55		; $88FE13: C9 37 00
	bcs .t2		; $88FE16: B0 34
	lda.w Xvel,x		; $88FE18: BD DF 0A
	sta.b mula		; $88FE1B: 85 7D
	lda.w #7		; $88FE1D: A9 07 00
	sta.b mulb		; $88FE20: 85 83
	jsl.l muls32		; $88FE22: 22 DB FC 82
	lsr.b mulres+2		; $88FE26: 46 95
	ror a		; $88FE28: 6A
	lsr.b mulres+2		; $88FE29: 46 95
	ror a		; $88FE2B: 6A
	lsr.b mulres+2		; $88FE2C: 46 95
	ror a		; $88FE2E: 6A
	sta.w Xvel,x		; $88FE2F: 9D DF 0A
	lda.w Yvel,x		; $88FE32: BD FF 0A
	sta.b mula		; $88FE35: 85 7D
	lda.w #7		; $88FE37: A9 07 00
	sta.b mulb		; $88FE3A: 85 83
	jsl.l muls32		; $88FE3C: 22 DB FC 82
	lsr.b mulres+2		; $88FE40: 46 95
	ror a		; $88FE42: 6A
	lsr.b mulres+2		; $88FE43: 46 95
	ror a		; $88FE45: 6A
	lsr.b mulres+2		; $88FE46: 46 95
	ror a		; $88FE48: 6A
	sta.w Yvel,x		; $88FE49: 9D FF 0A
.t2:		;every 12/60 second
	lda.w temp2,x		; $88FE4C: BD 7F 0C
	sec		; $88FE4F: 38
	sbc.b d7		; $88FE50: E5 6F
	sta.w temp2,x		; $88FE52: 9D 7F 0C
	bmi .go		; $88FE55: 30 03
	jmp.w .ex		; $88FE57: 4C 5D FF
.go:
	adc.w #11		; $88FE5A: 69 0B 00
	sta.w temp2,x		; $88FE5D: 9D 7F 0C
	jsl.l $8DFE36		; $88FE60: 22 36 FE 8D  bank $8D: avdgoal
	lda.w #13		; $88FE64: A9 0D 00
	sta.b d0+2		; $88FE67: 85 55
	lda.b d0		; $88FE69: A5 53
	bit.w #$8000		; $88FE6B: 89 00 80
	beq .near		; $88FE6E: F0 04
	eor.w #$FFFF		; $88FE70: 49 FF FF
	inc a		; $88FE73: 1A
.near:
	cmp.w #$0088		; $88FE74: C9 88 00
	bcs .av		; $88FE77: B0 05
	lda.w #18		; $88FE79: A9 12 00
	sta.b d0+2		; $88FE7C: 85 55
.av:
	lda.b deltax		; $88FE7E: A5 EA
	ora.b deltay		; $88FE80: 05 EC
	beq .lead		; $88FE82: F0 12
	lda.b d0		; $88FE84: A5 53
	sec		; $88FE86: 38
	sbc.w Xpos,x		; $88FE87: FD FF 08
	sta.b d0		; $88FE8A: 85 53
	lda.b d1		; $88FE8C: A5 57
	sec		; $88FE8E: 38
	sbc.w Ypos,x		; $88FE8F: FD 5F 09
	sta.b d1		; $88FE92: 85 57
	bra .vt		; $88FE94: 80 5D
.lead:		;aim ahead of the velocity
	lda.w Xvel,x		; $88FE96: BD DF 0A
	xba		; $88FE99: EB
	and.w #$00FF		; $88FE9A: 29 FF 00
	bit.w #$0080		; $88FE9D: 89 80 00
	beq .lx		; $88FEA0: F0 03
	ora.w #$FF00		; $88FEA2: 09 00 FF
.lx:
	eor.w #$FFFF		; $88FEA5: 49 FF FF
	inc a		; $88FEA8: 1A
	clc		; $88FEA9: 18
	adc.b d0		; $88FEAA: 65 53
	sec		; $88FEAC: 38
	sbc.w Xpos,x		; $88FEAD: FD FF 08
	sta.b d0		; $88FEB0: 85 53
	lda.w Yvel,x		; $88FEB2: BD FF 0A
	xba		; $88FEB5: EB
	and.w #$00FF		; $88FEB6: 29 FF 00
	bit.w #$0080		; $88FEB9: 89 80 00
	beq .ly		; $88FEBC: F0 03
	ora.w #$FF00		; $88FEBE: 09 00 FF
.ly:
	eor.w #$FFFF		; $88FEC1: 49 FF FF
	inc a		; $88FEC4: 1A
	clc		; $88FEC5: 18
	adc.b d1		; $88FEC6: 65 57
	sec		; $88FEC8: 38
	sbc.w Ypos,x		; $88FEC9: FD 5F 09
	sta.b d1		; $88FECC: 85 57
	lda.b d0		; $88FECE: A5 53
	bit.w #$8000		; $88FED0: 89 00 80
	beq .cx		; $88FED3: F0 04
	eor.w #$FFFF		; $88FED5: 49 FF FF
	inc a		; $88FED8: 1A
.cx:
	cmp.b d0+2		; $88FED9: C5 55
	bcs .vt		; $88FEDB: B0 16
	lda.b d1		; $88FEDD: A5 57
	bit.w #$8000		; $88FEDF: 89 00 80
	beq .cy		; $88FEE2: F0 04
	eor.w #$FFFF		; $88FEE4: 49 FF FF
	inc a		; $88FEE7: 1A
.cy:
	cmp.b d0+2		; $88FEE8: C5 55
	bcs .vt		; $88FEEA: B0 07
	lda.w #9		; $88FEEC: A9 09 00
	sta.b d0		; $88FEEF: 85 53
	bra .nvt		; $88FEF1: 80 04
.vt:
	jsl.l vtoa		; $88FEF3: 22 A8 AF 80
.nvt:		;jsr (a0) through jmlvector
	lda.b a0		; $88FEF7: A5 33
	sta.w jmlvector+1		; $88FEF9: 8D 79 01
	lda.b a0+1		; $88FEFC: A5 34
	sta.w jmlvector+2		; $88FEFE: 8D 7A 01
	jsl.l jmlvector		; $88FF01: 22 78 01 00
	lda.b d0		; $88FF05: A5 53
	sta.w temp2b,x		; $88FF07: 9D FF 0C
	cmp.w #8		; $88FF0A: C9 08 00
	bcc .ex		; $88FF0D: 90 4E
	lda.w Xvel,x		; $88FF0F: BD DF 0A
	ora.w Yvel,x		; $88FF12: 1D FF 0A
	bne .ex		; $88FF15: D0 46
	lda.w puckx		; $88FF17: AD 1B 09
	sta.b d0		; $88FF1A: 85 53
	lda.w pucky		; $88FF1C: AD 7B 09
	sta.b d1		; $88FF1F: 85 57
	lda.w pf2fight+puckobj		; $88FF21: AD 7B 11
	beq .nf		; $88FF24: F0 0A
	lda.w xc1		; $88FF26: AD F5 08
	sta.b d0		; $88FF29: 85 53
	lda.w yc1		; $88FF2B: AD F7 08
	sta.b d1		; $88FF2E: 85 57
.nf:
	lda.b d0		; $88FF30: A5 53
	sec		; $88FF32: 38
	sbc.w Xpos,x		; $88FF33: FD FF 08
	sta.b d0		; $88FF36: 85 53
	lda.b d1		; $88FF38: A5 57
	sec		; $88FF3A: 38
	sbc.w Ypos,x		; $88FF3B: FD 5F 09
	sta.b d1		; $88FF3E: 85 57
	jsl.l vtoa		; $88FF40: 22 A8 AF 80
	sec		; $88FF44: 38
	sbc.w facedir,x		; $88FF45: FD BF 0D
	beq .ex		; $88FF48: F0 13
	eor.w #$FFFF		; $88FF4A: 49 FF FF
	inc a		; $88FF4D: 1A
	and.w #$0004		; $88FF4E: 29 04 00
	lsr a		; $88FF51: 4A
	dec a		; $88FF52: 3A
	clc		; $88FF53: 18
	adc.w facedir,x		; $88FF54: 7D BF 0D
	and.w #$0007		; $88FF57: 29 07 00
	sta.w facedir,x		; $88FF5A: 9D BF 0D
.ex:
	lda.w temp2b,x		; $88FF5D: BD FF 0C
	sta.b d0		; $88FF60: 85 53
	jml.l $8FFBDC		; $88FF62: 5C DC FB 8F  bank $8F: doplayeracc
unusedFF88:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FF66
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FF76
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FF86
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FF96
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FFA6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FFB6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FFC6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FFD6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FFE6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $88FFF6
