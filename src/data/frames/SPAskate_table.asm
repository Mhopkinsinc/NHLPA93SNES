SPAskate_table:		;SPAskate frames by direction
	dw .d0-SPAskate_table		; direction 0
	dw .d1-SPAskate_table		; direction 1
	dw .d2-SPAskate_table		; direction 2
	dw .d3-SPAskate_table		; direction 3
	dw .d4-SPAskate_table		; direction 4
	dw .d5-SPAskate_table		; direction 5
	dw .d6-SPAskate_table		; direction 6
	dw .d7-SPAskate_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskate+1,10,SPFskate+2,10,SPFskate+3,10,SPFskate+4,10,SPFskate,-15
.d1:	dw SPFskate+6,10,SPFskate+7,10,SPFskate+8,10,SPFskate+9,10,SPFskate+5,-15
.d2:	dw SPFskate+11,10,SPFskate+12,10,SPFskate+13,10,SPFskate+14,10,SPFskate+10,-15
.d3:	dw SPFskate+16,10,SPFskate+17,10,SPFskate+18,10,SPFskate+19,10,SPFskate+15,-15
.d4:	dw SPFskate+21,10,SPFskate+22,10,SPFskate+23,10,SPFskate+24,10,SPFskate+20,-15
.d5:	dw SPFskate+26,10,SPFskate+27,10,SPFskate+28,10,SPFskate+29,10,SPFskate+25,-15
.d6:	dw SPFskate+31,10,SPFskate+32,10,SPFskate+33,10,SPFskate+34,10,SPFskate+30,-15
.d7:	dw SPFskate+36,10,SPFskate+37,10,SPFskate+38,10,SPFskate+39,10,SPFskate+35,-15
	assert SPAskate_table-SPAList == SPAskate

