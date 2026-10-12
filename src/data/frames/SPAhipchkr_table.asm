SPAhipchkr_table:		;SPAhipchkr frames by direction
	dw .d0-SPAhipchkr_table		; direction 0
	dw .d1-SPAhipchkr_table		; direction 1
	dw .d2-SPAhipchkr_table		; direction 2
	dw .d3-SPAhipchkr_table		; direction 3
	dw .d4-SPAhipchkr_table		; direction 4
	dw .d5-SPAhipchkr_table		; direction 5
	dw .d6-SPAhipchkr_table		; direction 6
	dw .d7-SPAhipchkr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhipr,-24
.d1:	dw SPFhipr+1,-24
.d2:	dw SPFhipr+2,-24
.d3:	dw SPFhipr+3,-24
.d4:	dw SPFhipr+4,-24
.d5:	dw SPFhipr+5,-24
.d6:	dw SPFhipr+6,-24
.d7:	dw SPFhipr+7,-24
	assert SPAhipchkr_table-SPAList == SPAhipchkr

