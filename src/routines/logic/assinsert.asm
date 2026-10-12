assinsert:		;insert new assignment on player a3. d0 = assignment. Falls into assreplace
		;   SNES: insert assignment d0 on player X. Falls into assreplace
	lda.w assnum,x		; assnum - 1
	dec a
	and.w #$0007
	sta.w assnum,x
assreplace:		;replace current assignment on player a3. d0 = assignment
		;   SNES: replace the current assignment of player X with d0
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	txa		; asslist+X*4+assnum = d0 (byte)
	asl a
	asl a
	adc.w assnum,x
	tay
	sep #$20
	lda.b d0
	sta.w asslist,y
	rep #$30
	rtl
