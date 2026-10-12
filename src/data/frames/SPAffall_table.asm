SPAffall_table:		;SPAffall frames by direction
	dw .d0-SPAffall_table		; direction 0
	dw .d0-SPAffall_table		; direction 1
	dw .d0-SPAffall_table		; direction 2
	dw .d0-SPAffall_table		; direction 3
	dw .d0-SPAffall_table		; direction 4
	dw .d0-SPAffall_table		; direction 5
	dw .d0-SPAffall_table		; direction 6
	dw .d0-SPAffall_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+14,8,SPFfight+15,8,SPFfight+16,200,SPFfight+16,-2
	assert SPAffall_table-SPAList == SPAffall

