noturn0:		;doplayeracc when the wanted direction needs no turn
	lda.w #$0002		; d4 = 2, 6 skating backwards
	sta.b d4
	lda.w pfrev,x
	beq .0
	lda.w #$0006
	sta.b d4
	lda.b d0
	eor.w #$0008
	sta.b d0
.0:
	lda.b d0
	beq .nochg
	lda.w Xvel,x		; moving: stop if the direction is more than 90 degrees off
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa
	bit.w #$0008
	bne .nostop
	sec
	sbc.w facedir,x
	clc
	adc.b d4
	and.w #$0007
	sta.b d0
	cmp.w #$0004
	bcs .nostop
	jml.l dostop
.nostop:
	inc.w facedir,x		; turn one step
	lda.w attribute,x
	bit.w #$0800
	beq .nos0
	dec.w facedir,x
	dec.w facedir,x
.nos0:
	lda.w facedir,x
	and.w #$0007
	sta.w facedir,x
	lda.w #SPAglide
	sta.b d1
	lda.w pfrev,x
	bne .gback
	jml.l SetSPA
.gback:
	lda.w #SPAglideback
	sta.b d1
	jml.l SetSPA
.nochg:
	lda.w #SPAskateback		; no change: skate
	sta.b d1
	lda.w pfrev,x
	bne .ns
	lda.w #SPAskate
	sta.b d1
	lda.w pflags,x		; pflags $0004 (pflags2 bit 6): stumble
	bit.w #$0004
	beq .nb6
	lda.w #SPAstumble
	sta.b d1
.nb6:
	lda.w puckc		; carrier: skate with the puck
	sta.b d4
	cmp.w SCnum,x
	bne .ns
	lda.w #SPAskatewp
	sta.b d1
.ns:
	lda.w pf2aip,x
	beq .set
	jml.l revplayeracc
.set:
	jsl.l SetSPA
	jml.l revplayeracc
