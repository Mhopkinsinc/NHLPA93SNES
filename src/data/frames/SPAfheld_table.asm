SPAfheld_table:		;SPAfheld frames by direction
	dw .d0-SPAfheld_table		; direction 0
	dw .d0-SPAfheld_table		; direction 1
	dw .d0-SPAfheld_table		; direction 2
	dw .d3-SPAfheld_table		; direction 3
	dw .d3-SPAfheld_table		; direction 4
	dw .d3-SPAfheld_table		; direction 5
	dw .d3-SPAfheld_table		; direction 6
	dw .d3-SPAfheld_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+4,30,SPFfight+3,-4
.d3:	dw SPFfight+9,30,SPFfight+8,-4
	assert SPAfheld_table-SPAList == SPAfheld

