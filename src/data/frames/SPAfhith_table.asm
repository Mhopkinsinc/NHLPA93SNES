SPAfhith_table:		;SPAfhith frames by direction
	dw .d0-SPAfhith_table		; direction 0
	dw .d0-SPAfhith_table		; direction 1
	dw .d0-SPAfhith_table		; direction 2
	dw .d3-SPAfhith_table		; direction 3
	dw .d3-SPAfhith_table		; direction 4
	dw .d3-SPAfhith_table		; direction 5
	dw .d3-SPAfhith_table		; direction 6
	dw .d3-SPAfhith_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+14,16,SPFfight+3,-8
.d3:	dw SPFfight+14,16,SPFfight+8,-8
	assert SPAfhith_table-SPAList == SPAfhith

