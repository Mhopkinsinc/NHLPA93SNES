SPAhook2_table:		;SPAhook2 frames by direction
	dw .d0-SPAhook2_table		; direction 0
	dw .d1-SPAhook2_table		; direction 1
	dw .d2-SPAhook2_table		; direction 2
	dw .d3-SPAhook2_table		; direction 3
	dw .d4-SPAhook2_table		; direction 4
	dw .d5-SPAhook2_table		; direction 5
	dw .d6-SPAhook2_table		; direction 6
	dw .d7-SPAhook2_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhook,9,SPFhook+1,9,SPFhook,9,SPFhook+1,-9
.d1:	dw SPFhook+2,9,SPFhook+3,9,SPFhook+2,9,SPFhook+3,-9
.d2:	dw SPFhook+4,9,SPFhook+5,9,SPFhook+4,9,SPFhook+5,-9
.d3:	dw SPFhook+6,9,SPFhook+7,9,SPFhook+6,9,SPFhook+7,-9
.d4:	dw SPFhook+8,9,SPFhook+9,9,SPFhook+8,9,SPFhook+9,-9
.d5:	dw SPFhook+10,9,SPFhook+11,9,SPFhook+10,9,SPFhook+11,-9
.d6:	dw SPFhook+12,9,SPFhook+13,9,SPFhook+12,9,SPFhook+13,-9
.d7:	dw SPFhook+14,9,SPFhook+15,9,SPFhook+14,9,SPFhook+15,-9
	assert SPAhook2_table-SPAList == SPAhook2

