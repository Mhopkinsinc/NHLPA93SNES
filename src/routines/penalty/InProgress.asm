InProgress:		;ref in progress-- update graphics and stats and penalty information. Takes the last PenBuf entry: the first pass logs a penalty with minutes and sends the player to the box
		;   later passes wait until he is off the ice and drop the entry. When PenBuf is empty, recount players and go to the face off. Entered from chkprogress
		;   SNES: Takes the last PenBuf entry: the first pass logs a penalty with minutes and sends the player to the box, later passes
		;   clear it; at the end coinsearch and the face off
	lda.w RefCnt		; animation in progress: exit
	bmi .step
	jmp.w .rtl
.step:
	lda.w RefStep
	bmi .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
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
.top:
	lda.w #$0000
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne .0
	jmp.w .exit
.0:		;find the end of the list
	lda.b [a0]
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne .0
	dec.b a0
	dec.b a0
	dec.b a0
	dec.b a0
	lda.b [a0]		; clear bit 15 of the entry (first pass)
	pha
	and.w #$7FFF
	sta.b [a0]
	pla
	bmi .Sa
	lda.b [a0]		; later pass: clear it when the player left the ice
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tay
	lda.w position,y
	bmi .clr
	jmp.w .ex
.clr:
	lda.w #$0000
	sta.b [a0]
	jmp.w .ex
.Sa:
	lda.b [a0]		; d2 = penalty minutes; none: no player involved
	and.w #$00FF
	sta.b d0
	tay
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b d2
	bne .min
	jmp.w .sa2
.min:
	stx.b xsave
	ldx.w #$0000
.save2:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea2:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea2
	ldx.b xsave
	jsl.l GetPeriodTimeRemaining
	lda.b [a0]
	xba
	and.w #$00FF
	asl a
	sta.b d1
	tax
	stx.b a3
	stz.b d0
	stz.b a2		; a2 = penalized team, a1 = other; d0 = $8000 for the visitors
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .sa1
	lda.w #$8000
	sta.b d0
	stz.b a1
	lda.w #$0002
	sta.b a2
.sa1:
	ldy.b a2		; tmPenalties +1, tmPenmin += minutes
	lda.w tmPenalties,y
	inc a
	sta.w tmPenalties,y
	lda.w tmPenmin,y
	clc
	adc.b d2
	sta.w tmPenmin,y
	lda.w pnum,x		; TempPlOffset = pnum | visitors
	and.w #$00FF
	ora.b d0
	sta.w TempPlOffset
	and.w #$00FF
	bit.w #$0080
	beq .pn
	ora.w #$FF00
.pn:
	asl a
	sta.b d0
	lda.w #$003C		; d2 = minutes*60 | $2000
	sta.b mula
	lda.b d2
	and.w #$00FF
	sta.b mulb
	jsl.l mulu16		; mulu, A = mula*mulb
	ora.w #$2000
	sta.b d2
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y		; keep TMPDINJ of an old penalty time
	bmi .st
	and.w #TMPDINJ
	tsb.b d2
.st:
	lda.b d2
	sta.w tmpdst,y
	lda.w #TMPDINJ
	trb.b d2
	lda.w #$0034
	sta.b d1
.ctop:		;same time on the other team: coincidental
	dec.b d1
	dec.b d1
	bmi .nocoin
	lda.b a1
	beq .ct
	lda.w #$0034
.ct:
	clc
	adc.b d1
	tay
	lda.w tmpdst,y
	and.w #~TMPDINJ&$FFFF
	sta.b d3
	cmp.b d2
	bne .ctop
	lda.w tmpdst,y		; coincidental: $4000 on both
	ora.w #$4000
	sta.w tmpdst,y
	lda.b a2
	beq .cg
	lda.w #$0034
.cg:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	ora.w #$4000
	sta.w tmpdst,y
.nocoin:		;add the player to the penalty box list
	lda.b a0+2
	pha
	lda.b a0
	pha
	lda.b a2
	beq .bl
	lda.w #$001A
.bl:
	sta.b a0
	lda.w #$0018
	sta.b d1
.pl:
	ldy.b a0
	inc.b a0
	lda.w tmboxlist,y
	bit.w #$0080
	bne .put
	dec.b d1
	bpl .pl
.put:
	lda.b d0
	ora.w #$FF00
	sta.w tmboxlist,y
	pla
	sta.b a0
	pla
	sta.b a0+2
	lda.w #apenalty
	sta.b d0
	jsl.l assreplace
	stx.b xsave
	ldx.w #$000E
.resta2:
	pla
	sta.b a1,x
	dex
	dex
	bpl .resta2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore2:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore2
	ldx.b xsave
	ldx.b a3		; SetPA, USBoard
	jsl.l SetPA
	jsl.l USBoard
	bra .ex
.sa2:
	lda.w #$0000		; no minutes: clear it, SetPA
	sta.b [a0]
	lda.w sfhormode
	beq .sa3
	jmp.w .top
.sa3:
	jsl.l SetPA
	bra .ex
.exit:
	stz.b a2		; coinsearch for both teams, clear gmpen, the puck: pfaceoff
	jsl.l coinsearch
	lda.w #$0002
	sta.b a2
	jsl.l coinsearch
	lda.w #gmpen
	trb.w gmode
	ldx.w #puckobj
	stx.b a3
	lda.w #pfaceoff
	sta.b d0
	jsl.l assreplace
.ex:
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
	ldx.w #$0002
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
