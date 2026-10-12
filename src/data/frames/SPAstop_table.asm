SPAstop_table:		;SPAstop frames by direction
	dw .d0-SPAstop_table		; direction 0
	dw .d1-SPAstop_table		; direction 1
	dw .d2-SPAstop_table		; direction 2
	dw .d3-SPAstop_table		; direction 3
	dw .d4-SPAstop_table		; direction 4
	dw .d5-SPAstop_table		; direction 5
	dw .d6-SPAstop_table		; direction 6
	dw .d7-SPAstop_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFstop,4,SPFstop+1,-4
.d1:	dw SPFstop+2,4,SPFstop+3,-4
.d2:	dw SPFstop+4,4,SPFstop+5,-4
.d3:	dw SPFstop+6,4,SPFstop+7,-4
.d4:	dw SPFstop+8,4,SPFstop+9,-4
.d5:	dw SPFstop+10,4,SPFstop+11,-4
.d6:	dw SPFstop+12,4,SPFstop+13,-4
.d7:	dw SPFstop+14,4,SPFstop+15,-4
	assert SPAstop_table-SPAList == SPAstop

