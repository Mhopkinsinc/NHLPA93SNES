SPAcelebrate_table:		;SPAcelebrate frames by direction
	dw .d0-SPAcelebrate_table		; direction 0
	dw .d1-SPAcelebrate_table		; direction 1
	dw .d2-SPAcelebrate_table		; direction 2
	dw .d3-SPAcelebrate_table		; direction 3
	dw .d4-SPAcelebrate_table		; direction 4
	dw .d5-SPAcelebrate_table		; direction 5
	dw .d6-SPAcelebrate_table		; direction 6
	dw .d7-SPAcelebrate_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFcelebrate,12,SPFcelebrate+1,40,SPFcelebrate,-5
.d1:	dw SPFcelebrate+2,12,SPFcelebrate+3,40,SPFcelebrate+2,-5
.d2:	dw SPFcelebrate+4,12,SPFcelebrate+5,40,SPFcelebrate+4,-5
.d3:	dw SPFcelebrate+6,12,SPFcelebrate+7,40,SPFcelebrate+6,-5
.d4:	dw SPFcelebrate+8,12,SPFcelebrate+9,40,SPFcelebrate+8,-5
.d5:	dw SPFcelebrate+10,12,SPFcelebrate+11,40,SPFcelebrate+10,-5
.d6:	dw SPFcelebrate+12,12,SPFcelebrate+13,40,SPFcelebrate+12,-5
.d7:	dw SPFcelebrate+14,12,SPFcelebrate+15,40,SPFcelebrate+14,-5
	assert SPAcelebrate_table-SPAList == SPAcelebrate

