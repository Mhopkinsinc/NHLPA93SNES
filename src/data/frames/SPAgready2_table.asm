SPAgready2_table:		;SPAgready2 frames by direction
	dw .d0-SPAgready2_table		; direction 0
	dw .d1-SPAgready2_table		; direction 1
	dw .d2-SPAgready2_table		; direction 2
	dw .d3-SPAgready2_table		; direction 3
	dw .d4-SPAgready2_table		; direction 4
	dw .d5-SPAgready2_table		; direction 5
	dw .d6-SPAgready2_table		; direction 6
	dw .d7-SPAgready2_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie,-30
.d1:	dw SPFGoalie+3,-30
.d2:	dw SPFGoalie+6,-30
.d3:	dw SPFGoalie+9,-30
.d4:	dw SPFGoalie+12,-30
.d5:	dw SPFGoalie+15,-30
.d6:	dw SPFGoalie+18,-30
.d7:	dw SPFGoalie+21,-30
	assert SPAgready2_table-SPAList == SPAgready2

