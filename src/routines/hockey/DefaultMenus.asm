DefaultMenus:		;set default menu choices for beginning of game. Called once from Begin.
		;   SNES: the 7 options at $1600 from .tab; notdemo set
	lda.w #$FFFF
	sta.w notdemo
	lda.w #OptPlayMode
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #.tab
	sta.b a1
	lda.w #.tab>>16
	sta.b a1+2
	lda.w #$0006
	sta.b d0
.copy:
	lda.b [a1]
	inc.b a1
	inc.b a1
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .copy
	rtl
.tab:		;OptPlayMode, OptPlayers, OptTeam1, OptTeam2, OptPerlen, OptPen, OptLine
	dw $0000,$0001,$000F,$0003,$0001,$0000,$0001
