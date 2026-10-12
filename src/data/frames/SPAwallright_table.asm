SPAwallright_table:		;SPAwallright frames by direction
	dw .d0-SPAwallright_table		; direction 0
	dw .d1-SPAwallright_table		; direction 1
	dw .d1-SPAwallright_table		; direction 2
	dw .d3-SPAwallright_table		; direction 3
	dw .d3-SPAwallright_table		; direction 4
	dw .d3-SPAwallright_table		; direction 5
	dw .d3-SPAwallright_table		; direction 6
	dw SPAwallleft_table-SPAwallright_table		; direction 7: points at the next table header
	dw 0		; attributes
.d0:	dw SPFPen+4,8,SPFPen+5,8,SPFPen+6,-8
.d1:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8
.d3:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8
	assert SPAwallright_table-SPAList == SPAwallright

