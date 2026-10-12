SPAhook_table:		;SPAhook frames by direction
	dw .d0-SPAhook_table		; direction 0
	dw .d1-SPAhook_table		; direction 1
	dw .d2-SPAhook_table		; direction 2
	dw .d3-SPAhook_table		; direction 3
	dw .d4-SPAhook_table		; direction 4
	dw .d5-SPAhook_table		; direction 5
	dw .d6-SPAhook_table		; direction 6
	dw .d7-SPAhook_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhook,-30
.d1:	dw SPFhook+2,-30
.d2:	dw SPFhook+4,-30
.d3:	dw SPFhook+6,-30
.d4:	dw SPFhook+8,-30
.d5:	dw SPFhook+10,-30
.d6:	dw SPFhook+12,-30
.d7:	dw SPFhook+14,-30
	assert SPAhook_table-SPAList == SPAhook

