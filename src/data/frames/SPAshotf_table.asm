SPAshotf_table:		;SPAshotf frames by direction
	dw .d0-SPAshotf_table		; direction 0
	dw .d1-SPAshotf_table		; direction 1
	dw .d2-SPAshotf_table		; direction 2
	dw .d3-SPAshotf_table		; direction 3
	dw .d4-SPAshotf_table		; direction 4
	dw .d5-SPAshotf_table		; direction 5
	dw .d6-SPAshotf_table		; direction 6
	dw .d7-SPAshotf_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,4,SPFswing,4,SPFswing+2,0,SPFswing+3,0,SPFswing+4,0,SPFswing+5,-20
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,4,SPFswing+6,4,SPFswing+8,0,SPFswing+9,0,SPFswing+10,0,SPFswing+11,-20
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,4,SPFswing+12,4,SPFswing+14,0,SPFswing+15,0,SPFswing+16,0,SPFswing+17,-20
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,4,SPFswing+18,4,SPFswing+20,0,SPFswing+21,0,SPFswing+22,0,SPFswing+23,-20
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,4,SPFswing+24,4,SPFswing+26,0,SPFswing+27,0,SPFswing+28,0,SPFswing+29,-20
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,4,SPFswing+30,4,SPFswing+32,0,SPFswing+33,0,SPFswing+34,0,SPFswing+35,-20
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,4,SPFswing+36,4,SPFswing+38,0,SPFswing+39,0,SPFswing+40,0,SPFswing+41,-20
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,4,SPFswing+42,4,SPFswing+44,0,SPFswing+45,0,SPFswing+46,0,SPFswing+47,-20
	assert SPAshotf_table-SPAList == SPAshotf

