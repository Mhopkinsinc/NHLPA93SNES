SPAgstickl_table:		;SPAgstickl frames by direction
	dw .d0-SPAgstickl_table		; direction 0
	dw .d1-SPAgstickl_table		; direction 1
	dw .d2-SPAgstickl_table		; direction 2
	dw .d3-SPAgstickl_table		; direction 3
	dw .d4-SPAgstickl_table		; direction 4
	dw .d5-SPAgstickl_table		; direction 5
	dw .d6-SPAgstickl_table		; direction 6
	dw .d7-SPAgstickl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+65,-32
.d1:	dw SPFGoalie+67,-32
.d2:	dw SPFGoalie+69,-32
.d3:	dw SPFGoalie+71,-32
.d4:	dw SPFGoalie+73,-32
.d5:	dw SPFGoalie+75,-32
.d6:	dw SPFGoalie+77,-32
.d7:	dw SPFGoalie+79,-32
	assert SPAgstickl_table-SPAList == SPAgstickl

