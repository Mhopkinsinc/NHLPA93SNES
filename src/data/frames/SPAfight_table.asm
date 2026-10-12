SPAfight_table:		;SPAfight frames by direction
	dw .d0-SPAfight_table		; direction 0
	dw .d0-SPAfight_table		; direction 1
	dw .d0-SPAfight_table		; direction 2
	dw .d3-SPAfight_table		; direction 3
	dw .d3-SPAfight_table		; direction 4
	dw .d3-SPAfight_table		; direction 5
	dw .d3-SPAfight_table		; direction 6
	dw .d3-SPAfight_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight,8,SPFfight+1,8,SPFfight+2,8,SPFfight+3,-6
.d3:	dw SPFfight,8,SPFfight+1,8,SPFfight+2,8,SPFfight+8,-6
	assert SPAfight_table-SPAList == SPAfight

