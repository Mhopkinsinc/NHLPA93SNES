SPAflail_table:		;SPAflail frames by direction
	dw .d0-SPAflail_table		; direction 0
	dw .d1-SPAflail_table		; direction 1
	dw .d2-SPAflail_table		; direction 2
	dw .d3-SPAflail_table		; direction 3
	dw .d4-SPAflail_table		; direction 4
	dw .d5-SPAflail_table		; direction 5
	dw .d6-SPAflail_table		; direction 6
	dw .d7-SPAflail_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskate,-30
.d1:	dw SPFskate+5,-30
.d2:	dw SPFskate+10,-30
.d3:	dw SPFskate+15,-30
.d4:	dw SPFskate+20,-30
.d5:	dw SPFskate+25,-30
.d6:	dw SPFskate+30,-30
.d7:	dw SPFskate+35,-30
	assert SPAflail_table-SPAList == SPAflail

