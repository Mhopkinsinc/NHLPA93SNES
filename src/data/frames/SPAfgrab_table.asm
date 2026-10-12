SPAfgrab_table:		;SPAfgrab frames by direction
	dw .d0-SPAfgrab_table		; direction 0
	dw .d0-SPAfgrab_table		; direction 1
	dw .d0-SPAfgrab_table		; direction 2
	dw .d3-SPAfgrab_table		; direction 3
	dw .d3-SPAfgrab_table		; direction 4
	dw .d3-SPAfgrab_table		; direction 5
	dw .d3-SPAfgrab_table		; direction 6
	dw .d3-SPAfgrab_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+4,28,SPFfight+3,-4
.d3:	dw SPFfight+9,28,SPFfight+8,-4
	assert SPAfgrab_table-SPAList == SPAfgrab

