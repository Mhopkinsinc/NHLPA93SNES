SPAgglover_table:		;SPAgglover frames by direction
	dw .d0-SPAgglover_table		; direction 0
	dw .d1-SPAgglover_table		; direction 1
	dw .d2-SPAgglover_table		; direction 2
	dw .d3-SPAgglover_table		; direction 3
	dw .d4-SPAgglover_table		; direction 4
	dw .d5-SPAgglover_table		; direction 5
	dw .d6-SPAgglover_table		; direction 6
	dw .d7-SPAgglover_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+1,-32
.d1:	dw SPFGoalie+4,-32
.d2:	dw SPFGoalie+7,-32
.d3:	dw SPFGoalie+10,-32
.d4:	dw SPFGoalie+13,-32
.d5:	dw SPFGoalie+16,-32
.d6:	dw SPFGoalie+19,-32
.d7:	dw SPFGoalie+22,-32
	assert SPAgglover_table-SPAList == SPAgglover

