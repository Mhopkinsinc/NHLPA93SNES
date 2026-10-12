SPAshotb_table:		;SPAshotb frames by direction
	dw .d0-SPAshotb_table		; direction 0
	dw .d1-SPAshotb_table		; direction 1
	dw .d2-SPAshotb_table		; direction 2
	dw .d3-SPAshotb_table		; direction 3
	dw .d4-SPAshotb_table		; direction 4
	dw .d5-SPAshotb_table		; direction 5
	dw .d6-SPAshotb_table		; direction 6
	dw .d7-SPAshotb_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,4,SPFswing+5,4,SPFswing+4,0,SPFswing+3,0,SPFswing+2,0,SPFswing+1,-20
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,4,SPFswing+11,4,SPFswing+10,0,SPFswing+9,0,SPFswing+8,0,SPFswing+7,-20
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,4,SPFswing+17,4,SPFswing+16,0,SPFswing+15,0,SPFswing+14,0,SPFswing+13,-20
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,4,SPFswing+23,4,SPFswing+22,0,SPFswing+21,0,SPFswing+20,0,SPFswing+19,-20
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,4,SPFswing+29,4,SPFswing+28,0,SPFswing+27,0,SPFswing+26,0,SPFswing+25,-20
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,4,SPFswing+35,4,SPFswing+34,0,SPFswing+33,0,SPFswing+32,0,SPFswing+31,-20
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,4,SPFswing+41,4,SPFswing+40,0,SPFswing+39,0,SPFswing+38,0,SPFswing+37,-20
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,4,SPFswing+47,4,SPFswing+46,0,SPFswing+45,0,SPFswing+44,0,SPFswing+43,-20
	assert SPAshotb_table-SPAList == SPAshotb

