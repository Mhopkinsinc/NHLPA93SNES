SPAgdive_table:		;SPAgdive frames by direction
	dw .d0-SPAgdive_table		; direction 0
	dw .d1-SPAgdive_table		; direction 1
	dw .d2-SPAgdive_table		; direction 2
	dw .d3-SPAgdive_table		; direction 3
	dw .d4-SPAgdive_table		; direction 4
	dw .d5-SPAgdive_table		; direction 5
	dw .d6-SPAgdive_table		; direction 6
	dw .d7-SPAgdive_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFgdive,8,SPFgdive+1,48,SPFgdive,-8
.d1:	dw SPFgdive+2,8,SPFgdive+3,48,SPFgdive+2,-8
.d2:	dw SPFgdive+4,8,SPFgdive+5,48,SPFgdive+4,-8
.d3:	dw SPFgdive+6,8,SPFgdive+7,48,SPFgdive+6,-8
.d4:	dw SPFgdive+8,8,SPFgdive+9,48,SPFgdive+8,-8
.d5:	dw SPFgdive+10,8,SPFgdive+11,48,SPFgdive+10,-8
.d6:	dw SPFgdive+12,8,SPFgdive+13,48,SPFgdive+12,-8
.d7:	dw SPFgdive+14,8,SPFgdive+15,48,SPFgdive+14,-8
	assert SPAgdive_table-SPAList == SPAgdive

