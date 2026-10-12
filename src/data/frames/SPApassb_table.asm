SPApassb_table:		;SPApassb frames by direction
	dw .d0-SPApassb_table		; direction 0
	dw .d1-SPApassb_table		; direction 1
	dw .d2-SPApassb_table		; direction 2
	dw .d3-SPApassb_table		; direction 3
	dw .d4-SPApassb_table		; direction 4
	dw .d5-SPApassb_table		; direction 5
	dw .d6-SPApassb_table		; direction 6
	dw .d7-SPApassb_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,-20
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,-20
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,-20
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,-20
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,-20
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,-20
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,-20
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,-20
	assert SPApassb_table-SPAList == SPApassb

