AttribHanded:		;Roster column: handedness. Bit 0 of the sum
	lda.b d0
	and.w #$0001
	sta.b d0
	lda.w #HandedTextTbl>>16
	sta.b a1+2
	lda.w #HandedTextTbl
	sta.b a1
	jml.l PrintStringFromList		; d0 = index, [a1] = list
