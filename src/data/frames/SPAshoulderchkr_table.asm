SPAshoulderchkr_table:		;SPAshoulderchkr frames by direction
	dw .d0-SPAshoulderchkr_table		; direction 0
	dw .d1-SPAshoulderchkr_table		; direction 1
	dw .d2-SPAshoulderchkr_table		; direction 2
	dw .d3-SPAshoulderchkr_table		; direction 3
	dw .d4-SPAshoulderchkr_table		; direction 4
	dw .d5-SPAshoulderchkr_table		; direction 5
	dw .d6-SPAshoulderchkr_table		; direction 6
	dw .d7-SPAshoulderchkr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFshoulderr,-24
.d1:	dw SPFshoulderr+1,-24
.d2:	dw SPFshoulderr+2,-24
.d3:	dw SPFshoulderr+3,-24
.d4:	dw SPFshoulderr+4,-24
.d5:	dw SPFshoulderr+5,-24
.d6:	dw SPFshoulderr+6,-24
.d7:	dw SPFshoulderr+7,-24
	assert SPAshoulderchkr_table-SPAList == SPAshoulderchkr

