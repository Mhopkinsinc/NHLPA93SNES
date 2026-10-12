SPAstumble_table:		;SPAstumble frames by direction
	dw .d0-SPAstumble_table		; direction 0
	dw .d1-SPAstumble_table		; direction 1
	dw .d2-SPAstumble_table		; direction 2
	dw .d3-SPAstumble_table		; direction 3
	dw .d4-SPAstumble_table		; direction 4
	dw .d5-SPAstumble_table		; direction 5
	dw .d6-SPAstumble_table		; direction 6
	dw .d7-SPAstumble_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFstumble,6,SPFstumble+1,6,SPFstumble+2,8,SPFstumble+1,6,SPFstumble,-6
.d1:	dw SPFstumble+3,6,SPFstumble+4,6,SPFstumble+5,8,SPFstumble+4,6,SPFstumble+3,-6
.d2:	dw SPFstumble+6,6,SPFstumble+7,6,SPFstumble+8,8,SPFstumble+7,6,SPFstumble+6,-6
.d3:	dw SPFstumble+9,6,SPFstumble+10,6,SPFstumble+11,8,SPFstumble+10,6,SPFstumble+9,-6
.d4:	dw SPFstumble+12,6,SPFstumble+13,6,SPFstumble+14,8,SPFstumble+13,6,SPFstumble+12,-6
.d5:	dw SPFstumble+15,6,SPFstumble+16,6,SPFstumble+17,8,SPFstumble+16,6,SPFstumble+15,-6
.d6:	dw SPFstumble+18,6,SPFstumble+19,6,SPFstumble+20,8,SPFstumble+19,6,SPFstumble+18,-6
.d7:	dw SPFstumble+21,6,SPFstumble+22,6,SPFstumble+23,8,SPFstumble+22,6,SPFstumble+21,-6
	assert SPAstumble_table-SPAList == SPAstumble

