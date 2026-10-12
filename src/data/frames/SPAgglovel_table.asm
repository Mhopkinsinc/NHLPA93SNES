SPAgglovel_table:		;SPAgglovel frames by direction
	dw .d0-SPAgglovel_table		; direction 0
	dw .d1-SPAgglovel_table		; direction 1
	dw .d2-SPAgglovel_table		; direction 2
	dw .d3-SPAgglovel_table		; direction 3
	dw .d4-SPAgglovel_table		; direction 4
	dw .d5-SPAgglovel_table		; direction 5
	dw .d6-SPAgglovel_table		; direction 6
	dw .d7-SPAgglovel_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+2,-32
.d1:	dw SPFGoalie+5,-32
.d2:	dw SPFGoalie+8,-32
.d3:	dw SPFGoalie+11,-32
.d4:	dw SPFGoalie+14,-32
.d5:	dw SPFGoalie+17,-32
.d6:	dw SPFGoalie+20,-32
.d7:	dw SPFGoalie+23,-32
	assert SPAgglovel_table-SPAList == SPAgglovel

