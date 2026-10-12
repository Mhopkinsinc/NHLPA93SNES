SPAgstackl_table:		;SPAgstackl frames by direction
	dw .d0-SPAgstackl_table		; direction 0
	dw .d1-SPAgstackl_table		; direction 1
	dw .d2-SPAgstackl_table		; direction 2
	dw .d3-SPAgstackl_table		; direction 3
	dw .d4-SPAgstackl_table		; direction 4
	dw .d5-SPAgstackl_table		; direction 5
	dw .d6-SPAgstackl_table		; direction 6
	dw .d7-SPAgstackl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+52,8,SPFGoalie+53,-20
.d1:	dw SPFGoalie+54,8,SPFGoalie+55,-20
.d2:	dw SPFGoalie+54,8,SPFGoalie+55,-20
.d3:	dw SPFGoalie+56,8,SPFGoalie+57,-20
.d4:	dw SPFGoalie+58,8,SPFGoalie+59,-20
.d5:	dw SPFGoalie+60,8,SPFGoalie+61,-20
.d6:	dw SPFGoalie+60,8,SPFGoalie+61,-20
.d7:	dw SPFGoalie+62,8,SPFGoalie+63,-20
	assert SPAgstackl_table-SPAList == SPAgstackl

