ResetBench:		;remove all players from penalty box/ put all players on their own bench
		;   SNES: empty the penalty boxes / put all players on their own bench. PBnum = players left in the box, home*16 + visitors
	stz.w PBnum
	lda.w #$0010		; home: +$10 per player
	sta.b d1
	stz.b a0
	jsl.l .rb
	lda.w #$0001
	sta.b d1
	lda.w #$0002
	sta.b a0
.rb:		;team a0 (0/2), d1 = PBnum step
	lda.w #$0032		; (MaxRos-1)*2
	sta.b d0
.rb1:
	lda.w PBnum
	clc
	adc.b d1
	sta.w PBnum
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nopen		; on the ice or bench
	beq .nopen
	bit.w #TMPDINJ		; TMPDINJ: stays in the box
	beq .next
	and.w #$07FF		; no time left: not counted
	sta.b d2
	bne .next
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	bra .next
.nopen:
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT stays out
	beq .next
	lda.w #TMPDBENCH		; TMPDBENCH
	sta.w tmpdst,y
.next:
	dec.b d0
	dec.b d0
	bpl .rb1
	rtl
