SPAhipchkl_table:		;SPAhipchkl frames by direction
	dw .d0-SPAhipchkl_table		; direction 0
	dw .d1-SPAhipchkl_table		; direction 1
	dw .d2-SPAhipchkl_table		; direction 2
	dw .d3-SPAhipchkl_table		; direction 3
	dw .d4-SPAhipchkl_table		; direction 4
	dw .d5-SPAhipchkl_table		; direction 5
	dw .d6-SPAhipchkl_table		; direction 6
	dw .d7-SPAhipchkl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhipl,-24
.d1:	dw SPFhipl+1,-24
.d2:	dw SPFhipl+2,-24
.d3:	dw SPFhipl+3,-24
.d4:	dw SPFhipl+4,-24
.d5:	dw SPFhipl+5,-24
.d6:	dw SPFhipl+6,-24
.d7:	dw SPFhipl+7,-24
	assert SPAhipchkl_table-SPAList == SPAhipchkl

