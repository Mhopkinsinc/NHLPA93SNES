SPAturnl_table:		;SPAturnl frames by direction
	dw .d0-SPAturnl_table		; direction 0
	dw .d1-SPAturnl_table		; direction 1
	dw .d2-SPAturnl_table		; direction 2
	dw .d3-SPAturnl_table		; direction 3
	dw .d4-SPAturnl_table		; direction 4
	dw .d5-SPAturnl_table		; direction 5
	dw .d6-SPAturnl_table		; direction 6
	dw .d7-SPAturnl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFturnl,-18
.d1:	dw SPFturnl+1,-18
.d2:	dw SPFturnl+2,-18
.d3:	dw SPFturnl+3,-18
.d4:	dw SPFturnl+4,-18
.d5:	dw SPFturnl+5,-18
.d6:	dw SPFturnl+6,-18
.d7:	dw SPFturnl+7,-18
	assert SPAturnl_table-SPAList == SPAturnl

