SPAskatewp_table:		;SPAskatewp frames by direction
	dw .d0-SPAskatewp_table		; direction 0
	dw .d1-SPAskatewp_table		; direction 1
	dw .d2-SPAskatewp_table		; direction 2
	dw .d3-SPAskatewp_table		; direction 3
	dw .d4-SPAskatewp_table		; direction 4
	dw .d5-SPAskatewp_table		; direction 5
	dw .d6-SPAskatewp_table		; direction 6
	dw .d7-SPAskatewp_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp+1,10,SPFskatewp+2,10,SPFskatewp+3,10,SPFskatewp+4,10,SPFskatewp,-15
.d1:	dw SPFskatewp+6,10,SPFskatewp+7,10,SPFskatewp+8,10,SPFskatewp+9,10,SPFskatewp+5,-15
.d2:	dw SPFskatewp+11,10,SPFskatewp+12,10,SPFskatewp+13,10,SPFskatewp+14,10,SPFskatewp+10,-15
.d3:	dw SPFskatewp+16,10,SPFskatewp+17,10,SPFskatewp+18,10,SPFskatewp+19,10,SPFskatewp+15,-15
.d4:	dw SPFskatewp+21,10,SPFskatewp+22,10,SPFskatewp+23,10,SPFskatewp+24,10,SPFskatewp+20,-15
.d5:	dw SPFskatewp+26,10,SPFskatewp+27,10,SPFskatewp+28,10,SPFskatewp+29,10,SPFskatewp+25,-15
.d6:	dw SPFskatewp+31,10,SPFskatewp+32,10,SPFskatewp+33,10,SPFskatewp+34,10,SPFskatewp+30,-15
.d7:	dw SPFskatewp+36,10,SPFskatewp+37,10,SPFskatewp+38,10,SPFskatewp+39,10,SPFskatewp+35,-15
	assert SPAskatewp_table-SPAList == SPAskatewp

