SPAgskate_table:		;SPAgskate frames by direction
	dw .d0-SPAgskate_table		; direction 0
	dw .d1-SPAgskate_table		; direction 1
	dw .d2-SPAgskate_table		; direction 2
	dw .d3-SPAgskate_table		; direction 3
	dw .d4-SPAgskate_table		; direction 4
	dw .d5-SPAgskate_table		; direction 5
	dw .d6-SPAgskate_table		; direction 6
	dw .d7-SPAgskate_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFGoalie+80,10,SPFGoalie+81,10,SPFGoalie+82,10,SPFGoalie+83,-15
.d1:	dw SPFGoalie+84,10,SPFGoalie+85,10,SPFGoalie+86,10,SPFGoalie+87,-15
.d2:	dw SPFGoalie+88,10,SPFGoalie+89,10,SPFGoalie+90,10,SPFGoalie+91,-15
.d3:	dw SPFGoalie+92,10,SPFGoalie+93,10,SPFGoalie+94,10,SPFGoalie+95,-15
.d4:	dw SPFGoalie+96,10,SPFGoalie+97,10,SPFGoalie+98,10,SPFGoalie+99,-15
.d5:	dw SPFGoalie+100,10,SPFGoalie+101,10,SPFGoalie+102,10,SPFGoalie+103,-15
.d6:	dw SPFGoalie+104,10,SPFGoalie+105,10,SPFGoalie+106,10,SPFGoalie+107,-15
.d7:	dw SPFGoalie+108,10,SPFGoalie+109,10,SPFGoalie+110,10,SPFGoalie+111,-15
	assert SPAgskate_table-SPAList == SPAgskate

