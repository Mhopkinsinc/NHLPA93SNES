SPAHold2_table:		;SPAHold2 frames by direction
	dw .d0-SPAHold2_table		; direction 0
	dw .d1-SPAHold2_table		; direction 1
	dw .d2-SPAHold2_table		; direction 2
	dw .d3-SPAHold2_table		; direction 3
	dw .d4-SPAHold2_table		; direction 4
	dw .d5-SPAHold2_table		; direction 5
	dw .d6-SPAHold2_table		; direction 6
	dw .d7-SPAHold2_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhold,-30
.d1:	dw SPFhold+1,-30
.d2:	dw SPFhold+2,-30
.d3:	dw SPFhold+3,-30
.d4:	dw SPFhold+4,-30
.d5:	dw SPFhold+5,-30
.d6:	dw SPFhold+6,-30
.d7:	dw SPFhold+7,-30
	assert SPAHold2_table-SPAList == SPAHold2

