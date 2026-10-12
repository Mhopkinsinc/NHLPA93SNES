SPApump_table:		;SPApump frames by direction
	dw .d0-SPApump_table		; direction 0
	dw .d1-SPApump_table		; direction 1
	dw .d2-SPApump_table		; direction 2
	dw .d3-SPApump_table		; direction 3
	dw .d4-SPApump_table		; direction 4
	dw .d5-SPApump_table		; direction 5
	dw .d6-SPApump_table		; direction 6
	dw .d7-SPApump_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFpump,8,SPFpump+1,8,SPFpump,-8
.d1:	dw SPFpump+2,8,SPFpump+3,8,SPFpump+2,-8
.d2:	dw SPFpump+4,8,SPFpump+5,8,SPFpump+4,-8
.d3:	dw SPFpump+6,8,SPFpump+7,8,SPFpump+6,-8
.d4:	dw SPFpump+8,8,SPFpump+9,8,SPFpump+8,-8
.d5:	dw SPFpump+10,8,SPFpump+11,8,SPFpump+10,-8
.d6:	dw SPFpump+12,8,SPFpump+13,8,SPFpump+12,-8
.d7:	dw SPFpump+14,8,SPFpump+15,8,SPFpump+14,-8
	assert SPApump_table-SPAList == SPApump

