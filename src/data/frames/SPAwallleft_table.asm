SPAwallleft_table:		;SPAwallleft frames by direction
	dw .d0-SPAwallleft_table		; direction 0
	dw .d1-SPAwallleft_table		; direction 1
	dw .d1-SPAwallleft_table		; direction 2
	dw .d3-SPAwallleft_table		; direction 3
	dw .d3-SPAwallleft_table		; direction 4
	dw .d3-SPAwallleft_table		; direction 5
	dw .d3-SPAwallleft_table		; direction 6
	dw SPAfaceoff_table-SPAwallleft_table		; direction 7: points at the next table header
	dw 0		; attributes
.d0:	dw SPFPen+6,8,SPFPen+5,8,SPFPen+4,-8
.d1:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8
.d3:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8
	assert SPAwallleft_table-SPAList == SPAwallleft

