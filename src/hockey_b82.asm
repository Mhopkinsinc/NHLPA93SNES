; The game, screens, menus, password, playoffs.
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82FA01
BitstoPW:		;convert passbits into password text
		;   SNES: convert passbits into the 16 password characters (SuperDiv by PWrange)
	ldx.w #$000F
.char:
	lda.w #PWrange		; PassWord[x] = passbits mod PWrange
	sta.b d0
	jsl.l SuperDiv
	sep #$20
	lda.b d0
	sta.w PassWord,x
	rep #$30
	dex
	bpl .char
	rtl

org $82FBA6
PasstoText:		;characters used in the password text (PWrange = 30, the 31st is the blank)
	db "BCDFGHJKLMNPRSTVWXYZ0123456789-"
PWtoBits:		;convert password text into passbits
		;   SNES: convert the password text into passbits (ClrPassBits, then SuperMult by PWrange and SuperAdd per character)
	jsl.l ClrPassBits
	ldx.w #$0000
.char:
	lda.w #PWrange		; passbits = passbits * PWrange + PassWord[x]
	sta.b d0
	jsl.l SuperMult		; passbits *= d0
	lda.w PassWord,x
	and.w #$00FF
	sta.b d0
	stz.b d0+2
	jsl.l SuperAdd		; passbits += d0
	inx
	cpx.w #pwlength
	bne .char
	rtl
ClrPassBits:		;clr the 5 words of bits at a3
		;   SNES: clear passbits
	stz.w passbits
	stz.w passbits+2
	stz.w passbits+4
	stz.w passbits+6
	stz.w passbits+8
	stz.w passbits+10
	stz.w passbits+12
	stz.w passbits+14
	rtl
PushBits:		;bits = bits * d1 + d0.
		;   SNES: passbits = passbits * d1 + d0
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.b d0		; d0 <-> d1
	ldx.b d1
	sta.b d1
	stx.b d0
	jsl.l SuperMult		; passbits *= d0
	stz.b d0+2
	lda.b d1
	sta.b d0
	jsl.l SuperAdd		; passbits += d0
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
BitMaskTable:		;SNES: the 16 bit masks 1 << n (read by the playoff bit code in bank $8B)
	dw $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
	dw $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000
GameOver:		;SNES: after a game: EncodePW and PlayoffScreen; when the playoffs go on with a user game (OptPlayMode 1, gamenum set) DecodePW the new password and maketree
		;   (sf3alttree picks the path); else back to Restart
	jsl.l EncodePW
	jsl.l PlayoffScreen		; font tile bases, the playoff tree
	lda.w OptPlayMode		; not continuing playoffs, or no user game: Restart
	cmp.w #$0001
	beq .po
	jml.l Restart
.po:
	lda.w gamenum
	bpl .pw
	jml.l Restart
.pw:
	lda.w PassWord		; clear bit 7 (hidden) of the first two characters
	and.w #$7F7F
	sta.w PassWord
	jsl.l DecodePW
	jsl.l maketree
	lda.w #sf3alttree		; sf3alttree: Opening4 after the font bases
	trb.w sflags3
	beq .tree
	jml.l PlayoffScreenOpening4
.tree:
	jml.l Opening4
SaveRegsStartHL2:		;SNES: save d0-d7 and a0-a6 on the stack and go on to StartHL2 (it pulls them back)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .savea
	ldx.b xsave
	jml.l StartHL2		; pulls the saved registers

org $82FDB5
startpause2:		;pause intiated by cont 2
		;   SNES: pause started by controller 2 (sflags bit 1), then startpause
	lda.w #sfpj
	tsb.w sflags
	jml.l startpause
