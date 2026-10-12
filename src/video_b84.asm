; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84F816
InitSortObjects:		;SNES: clear the sort objects, then set the 4 sso arrows, the 5 ffo objects and the 16 sort objects from SsoInitTable, FfoInitTable and SortObjInitTable; then
		;   SprSort
	ldx.w #$0000		; SortCords (all fields of the 16 objects)
.clr:
	stz.w Xpos,x
	inx
	inx
	cpx.w #$0840
	bne .clr
	ldx.w #$0000
	ldy.w #$0000
	lda.w #$0003
	sta.b d0
.sso:
	lda.w #$FFFF
	sta.w ssoz,y
	lda.l SsoInitTable,x
	sta.w ssox,y
	lda.l SsoInitTable+2,x
	sta.w ssoy,y
	lda.l SsoInitTable+4,x
	sta.w ssoframe,y
	lda.l SsoInitTable+6,x
	sta.w ssoattr,y
	txa
	clc
	adc.w #$0008
	tax
	iny
	iny
	dec.b d0
	bpl .sso
	ldx.w #$0000
	ldy.w #$0000
	lda.w #$0004
	sta.b d0
.ffo:
	lda.w #$FFFF
	sta.w ffoxofs,y
	lda.l FfoInitTable,x
	sta.w ffox,y
	lda.l FfoInitTable+2,x
	sta.w ffoy,y
	lda.l FfoInitTable+4,x
	sta.w ffoz,y
	lda.l FfoInitTable+6,x
	sta.w ffoframe,y
	lda.l FfoInitTable+8,x
	sta.w ffoattr,y
	txa
	clc
	adc.w #$000A
	tax
	iny
	iny
	dec.b d0
	bpl .ffo
	stz.b d6
	stz.b a1
	stz.b a2
	stz.b a3
	stz.b a4
.obj:
	ldx.b a2
	ldy.b a3
	lda.b d6
	sta.w SCnum,y
	lda.w #$FFFF
	sta.w oldframe,y
	sta.w pnum,y
	lda.l SortObjInitTable,x
	sta.w Xpos,y
	lda.l SortObjInitTable+2,x
	sta.w Ypos,y
	lda.l SortObjInitTable+4,x
	sta.w Zpos,y
	lda.l SortObjInitTable+6,x
	sta.w frame,y
	lda.l SortObjInitTable+8,x
	sta.w attribute,y
	lda.l SortObjInitTable+10,x
	sta.w radiusx,y
	lda.l SortObjInitTable+12,x
	sta.w radiusy,y
	lda.b d6
	asl a
	asl a
	asl a
	tay
	lda.l SortObjInitTable+14,x
	sta.w asslist,y
	ldy.b a3
	lda.l SortObjInitTable+16,x
	sta.w pflags,y
	lda.w #$0000
	sta.w pfnc,y
	cpy.w #$001E		; object $1E (puck shadow): pfnc
	bne .goal
	lda.w #$0001
	sta.w pfnc,y
.goal:
	cpx.w #$006C		; pfgoal for objects 6-11 and 12-15, pfteam $34 for 6-11
	rol a
	inc a
	and.w #$0001
	sta.w pfgoal,y
	cpx.w #$006C
	bcc .next
	cpx.w #$00D8
	bcs .next
	lda.w #$0034
	sta.w pfteam,y
.next:
	inc.b a3
	inc.b a3
	sep #$20
	lda.b d6
	asl a
	ldy.b a1
	sta.w OOlist,y
	inc.b a1
	rep #$30
	lda.b d6
	ldy.b a4
	sta.w OOlistpos,y
	inc.b a4
	inc.b a4
	inc.b d6
	lda.b a2
	clc
	adc.w #$0012
	sta.b a2
	lda.b d6
	cmp.w #$0010
	beq .sort
	jmp.w .obj
.sort:
	jml.l SprSort
SsoInitTable:		;SNES: 4 x (ssox, ssoy, ssoframe, ssoattr)
	dw $0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000
	dw $0040,$FFA4,$0000,$8000
	dw $FFC0,$FFA4,$0000,$8000
FfoInitTable:		;SNES: 5 x (ffox, ffoy, ffoz, ffoframe, ffoattr)
	dw $0000,$0000,$FFFF,$0188,$0000
	dw $0000,$0000,$FFFF,$0186,$0000
	dw $0000,$0000,$FFFF,$0187,$0000
	dw $0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$FFFF,$0161,$0000
SortObjInitTable:		;SNES: 16 x (Xpos, Ypos, Zpos, frame, attribute, radiusx, radiusy, assignment, pflags); objects 6-11 are team 2
	dw $0160,$00C0,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FF9C,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFB0,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFC4,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFD8,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFEC,$0000,$0001,$0000,$0008,$0004,$0000,$0000
	dw $00C0,$00C0,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0028,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$003C,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0050,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0064,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0078,$0000,$0001,$0001,$0008,$0004,$0000,$0000
	dw $0000,$010C,$0000,$0194,$0000,$0014,$0006,$0000,$0000
	dw $0000,$FEF4,$0000,$0195,$0000,$0014,$0006,$0000,$0000
	dw $0000,$0000,$0000,$018A,$0000,$0005,$0005,$0018,$0001
	dw $0000,$0000,$0000,$0189,$0000,$0003,$0003,$0019,$0000
