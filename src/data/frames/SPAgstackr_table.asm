SPAgstackr_table:		;SPAgstackr frames by direction
	dw .d0-SPAgstackr_table		; direction 0
	dw .d1-SPAgstackr_table		; direction 1
	dw .d2-SPAgstackr_table		; direction 2
	dw .d3-SPAgstackr_table		; direction 3
	dw .d4-SPAgstackr_table		; direction 4
	dw .d5-SPAgstackr_table		; direction 5
	dw .d6-SPAgstackr_table		; direction 6
	dw .d7-SPAgstackr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+40,8,SPFGoalie+41,-20
.d1:	dw SPFGoalie+42,8,SPFGoalie+43,-20
.d2:	dw SPFGoalie+42,8,SPFGoalie+43,-20
.d3:	dw SPFGoalie+44,8,SPFGoalie+45,-20
.d4:	dw SPFGoalie+46,8,SPFGoalie+47,-20
.d5:	dw SPFGoalie+48,8,SPFGoalie+49,-20
.d6:	dw SPFGoalie+48,8,SPFGoalie+49,-20
.d7:	dw SPFGoalie+50,8,SPFGoalie+51,-20
	assert SPAgstackr_table-SPAList == SPAgstackr

