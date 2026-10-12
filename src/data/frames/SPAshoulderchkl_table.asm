SPAshoulderchkl_table:		;SPAshoulderchkl frames by direction
	dw .d0-SPAshoulderchkl_table		; direction 0
	dw .d1-SPAshoulderchkl_table		; direction 1
	dw .d2-SPAshoulderchkl_table		; direction 2
	dw .d3-SPAshoulderchkl_table		; direction 3
	dw .d4-SPAshoulderchkl_table		; direction 4
	dw .d5-SPAshoulderchkl_table		; direction 5
	dw .d6-SPAshoulderchkl_table		; direction 6
	dw .d7-SPAshoulderchkl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFshoulderl,-24
.d1:	dw SPFshoulderl+1,-24
.d2:	dw SPFshoulderl+2,-24
.d3:	dw SPFshoulderl+3,-24
.d4:	dw SPFshoulderl+4,-24
.d5:	dw SPFshoulderl+5,-24
.d6:	dw SPFshoulderl+6,-24
.d7:	dw SPFshoulderl+7,-24
	assert SPAshoulderchkl_table-SPAList == SPAshoulderchkl

