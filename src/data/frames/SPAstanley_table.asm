SPAstanley_table:		;SPAstanley frames by direction
	dw .d0-SPAstanley_table		; direction 0
	dw .d1-SPAstanley_table		; direction 1
	dw .d2-SPAstanley_table		; direction 2
	dw .d3-SPAstanley_table		; direction 3
	dw .d4-SPAstanley_table		; direction 4
	dw .d5-SPAstanley_table		; direction 5
	dw .d6-SPAstanley_table		; direction 6
	dw .d7-SPAstanley_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFcup,-30
.d1:	dw SPFcup+1,-30
.d2:	dw SPFcup+2,-30
.d3:	dw SPFcup+3,-30
.d4:	dw SPFcup+4,-30
.d5:	dw SPFcup+5,-30
.d6:	dw SPFcup+6,-30
.d7:	dw SPFcup+7,-30
	assert SPAstanley_table-SPAList == SPAstanley

