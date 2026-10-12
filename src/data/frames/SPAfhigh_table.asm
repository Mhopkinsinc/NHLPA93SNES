SPAfhigh_table:		;SPAfhigh frames by direction
	dw .d0-SPAfhigh_table		; direction 0
	dw .d0-SPAfhigh_table		; direction 1
	dw .d0-SPAfhigh_table		; direction 2
	dw .d3-SPAfhigh_table		; direction 3
	dw .d3-SPAfhigh_table		; direction 4
	dw .d3-SPAfhigh_table		; direction 5
	dw .d3-SPAfhigh_table		; direction 6
	dw .d3-SPAfhigh_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+5,6,SPFfight+6,16,SPFfight+5,4,SPFfight+3,-16
.d3:	dw SPFfight+10,6,SPFfight+11,16,SPFfight+10,4,SPFfight+8,-16
	assert SPAfhigh_table-SPAList == SPAfhigh

