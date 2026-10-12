resetplstuff:		;Reset the team variables and the players on both teams
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	stz.b a2
	jsl.l .top
	lda.w #$0002
	sta.b a2
	jsl.l .top
	stx.b xsave
	ldx.w #$000E
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
.top:		;team a2
	ldy.b a2
	lda.w tmflags,y
	and.w #~tmfoffside&$FFFF		; clear tmfoffside
	sta.w tmflags,y
	lda.w #$0005
	sta.b d2
	ldx.w tmsort,y
	stx.b a3
.loop:
	stz.w pf2fight,x		; pf2fight = pf2aip = 0, pflags2 bits cleared
	stz.w pf2aip,x
	lda.w pflags,x
	and.w #~(pf2unav|pf2lcm|pf2pen|pf2npc)&$FFFF
	sta.w pflags,x
	lda.w position,x
	bmi .next
	lda.w #SPAglide
	sta.b d1
	jsl.l SetSPA
	stz.w impact,x		; impact = 0, nopuck = 0
	stz.w nopuck,x
	lda.w pflags,x
	and.w #~(pfdoff|pfjoycon)&$FFFF		; keep pfteam/pfgoal/pfna: clear pfdoff, pfjoycon
	sta.w pflags,x
	stz.w pfnc,x
	stz.w pfrev,x
	stz.w pfalock,x
.next:
	inc.b a3
	inc.b a3
	ldx.b a3
	dec.b d2
	bpl .loop
	rtl
