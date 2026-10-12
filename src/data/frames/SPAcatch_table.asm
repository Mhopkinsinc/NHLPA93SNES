SPAcatch_table:		;SPAcatch frames by direction
	dw .d0-SPAcatch_table		; direction 0
	dw .d1-SPAcatch_table		; direction 1
	dw .d2-SPAcatch_table		; direction 2
	dw .d3-SPAcatch_table		; direction 3
	dw .d4-SPAcatch_table		; direction 4
	dw .d5-SPAcatch_table		; direction 5
	dw .d6-SPAcatch_table		; direction 6
	dw .d7-SPAcatch_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFcatch,6,SPFcatch+1,-6
.d1:	dw SPFcatch+2,6,SPFcatch+3,-6
.d2:	dw SPFcatch+4,6,SPFcatch+5,-6
.d3:	dw SPFcatch+6,6,SPFcatch+7,-6
.d4:	dw SPFcatch+8,6,SPFcatch+9,-6
.d5:	dw SPFcatch+10,6,SPFcatch+11,-6
.d6:	dw SPFcatch+12,6,SPFcatch+13,-6
.d7:	dw SPFcatch+14,6,SPFcatch+15,-6
	assert SPAcatch_table-SPAList == SPAcatch

