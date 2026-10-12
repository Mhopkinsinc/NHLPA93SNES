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
