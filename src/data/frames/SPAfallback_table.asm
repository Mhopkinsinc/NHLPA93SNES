SPAfallback_table:		;SPAfallback frames by direction
	dw .d0-SPAfallback_table		; direction 0
	dw .d1-SPAfallback_table		; direction 1
	dw .d2-SPAfallback_table		; direction 2
	dw .d3-SPAfallback_table		; direction 3
	dw .d4-SPAfallback_table		; direction 4
	dw .d5-SPAfallback_table		; direction 5
	dw .d6-SPAfallback_table		; direction 6
	dw .d7-SPAfallback_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfallback,6,SPFfallback+1,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8
.d1:	dw SPFfallback+4,6,SPFfallback+5,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8
.d2:	dw SPFfallback+8,6,SPFfallback+9,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8
.d3:	dw SPFfallback+12,6,SPFfallback+13,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8
.d4:	dw SPFfallback+16,6,SPFfallback+17,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8
.d5:	dw SPFfallback+20,6,SPFfallback+21,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8
.d6:	dw SPFfallback+24,6,SPFfallback+25,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8
.d7:	dw SPFfallback+28,6,SPFfallback+29,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8
	assert SPAfallback_table-SPAList == SPAfallback

