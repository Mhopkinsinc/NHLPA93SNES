SPAglide_table:		;SPAglide frames by direction
	dw .d0-SPAglide_table		; direction 0
	dw .d1-SPAglide_table		; direction 1
	dw .d2-SPAglide_table		; direction 2
	dw .d3-SPAglide_table		; direction 3
	dw .d4-SPAglide_table		; direction 4
	dw .d5-SPAglide_table		; direction 5
	dw .d6-SPAglide_table		; direction 6
	dw .d7-SPAglide_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp,-8
.d1:	dw SPFskatewp+5,-8
.d2:	dw SPFskatewp+10,-8
.d3:	dw SPFskatewp+15,-8
.d4:	dw SPFskatewp+20,-8
.d5:	dw SPFskatewp+25,-8
.d6:	dw SPFskatewp+30,-8
.d7:	dw SPFskatewp+35,-8
	assert SPAglide_table-SPAList == SPAglide

