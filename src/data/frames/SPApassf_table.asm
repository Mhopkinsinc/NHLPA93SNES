SPApassf_table:		;SPApassf frames by direction
	dw .d0-SPApassf_table		; direction 0
	dw .d1-SPApassf_table		; direction 1
	dw .d2-SPApassf_table		; direction 2
	dw .d3-SPApassf_table		; direction 3
	dw .d4-SPApassf_table		; direction 4
	dw .d5-SPApassf_table		; direction 5
	dw .d6-SPApassf_table		; direction 6
	dw .d7-SPApassf_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,-20
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,-20
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,-20
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,-20
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,-20
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,-20
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,-20
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,-20
	assert SPApassf_table-SPAList == SPApassf

