SPAturnr_table:		;SPAturnr frames by direction
	dw .d0-SPAturnr_table		; direction 0
	dw .d1-SPAturnr_table		; direction 1
	dw .d2-SPAturnr_table		; direction 2
	dw .d3-SPAturnr_table		; direction 3
	dw .d4-SPAturnr_table		; direction 4
	dw .d5-SPAturnr_table		; direction 5
	dw .d6-SPAturnr_table		; direction 6
	dw .d7-SPAturnr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFturnr,-18
.d1:	dw SPFturnr+1,-18
.d2:	dw SPFturnr+2,-18
.d3:	dw SPFturnr+3,-18
.d4:	dw SPFturnr+4,-18
.d5:	dw SPFturnr+5,-18
.d6:	dw SPFturnr+6,-18
.d7:	dw SPFturnr+7,-18
	assert SPAturnr_table-SPAList == SPAturnr

