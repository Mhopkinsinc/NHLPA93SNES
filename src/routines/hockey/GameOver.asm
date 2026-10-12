GameOver:		;After a game: the password and the playoff screen; on to the user's next playoff game, or back to the start
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
