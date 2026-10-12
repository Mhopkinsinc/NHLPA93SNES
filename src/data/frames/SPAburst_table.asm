SPAburst_table:		;SPAburst frames by direction
	dw .d0-SPAburst_table		; direction 0
	dw .d1-SPAburst_table		; direction 1
	dw .d2-SPAburst_table		; direction 2
	dw .d3-SPAburst_table		; direction 3
	dw .d4-SPAburst_table		; direction 4
	dw .d5-SPAburst_table		; direction 5
	dw .d6-SPAburst_table		; direction 6
	dw .d7-SPAburst_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskate,-24
.d1:	dw SPFskate+5,-24
.d2:	dw SPFskate+10,-24
.d3:	dw SPFskate+15,-24
.d4:	dw SPFskate+20,-24
.d5:	dw SPFskate+25,-24
.d6:	dw SPFskate+30,-24
.d7:	dw SPFskate+35,-24
	assert SPAburst_table-SPAList == SPAburst

