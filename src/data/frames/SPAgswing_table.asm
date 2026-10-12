SPAgswing_table:		;SPAgswing frames by direction
	dw .d0-SPAgswing_table		; direction 0
	dw .d1-SPAgswing_table		; direction 1
	dw .d2-SPAgswing_table		; direction 2
	dw .d3-SPAgswing_table		; direction 3
	dw .d4-SPAgswing_table		; direction 4
	dw .d5-SPAgswing_table		; direction 5
	dw .d6-SPAgswing_table		; direction 6
	dw .d7-SPAgswing_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+24,5,SPFGoalie+25,8,SPFGoalie+24,-16
.d1:	dw SPFGoalie+26,5,SPFGoalie+27,8,SPFGoalie+26,-16
.d2:	dw SPFGoalie+28,5,SPFGoalie+29,8,SPFGoalie+28,-16
.d3:	dw SPFGoalie+30,5,SPFGoalie+31,8,SPFGoalie+30,-16
.d4:	dw SPFGoalie+32,5,SPFGoalie+33,8,SPFGoalie+32,-16
.d5:	dw SPFGoalie+34,5,SPFGoalie+35,8,SPFGoalie+34,-16
.d6:	dw SPFGoalie+36,5,SPFGoalie+37,8,SPFGoalie+36,-16
.d7:	dw SPFGoalie+38,5,SPFGoalie+39,8,SPFGoalie+38,-16
	assert SPAgswing_table-SPAList == SPAgswing

