SPAflip_table:		;SPAflip frames by direction
	dw .d0-SPAflip_table		; direction 0
	dw .d1-SPAflip_table		; direction 1
	dw .d2-SPAflip_table		; direction 2
	dw .d3-SPAflip_table		; direction 3
	dw .d4-SPAflip_table		; direction 4
	dw .d5-SPAflip_table		; direction 5
	dw .d6-SPAflip_table		; direction 6
	dw .d7-SPAflip_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8
.d1:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8
.d2:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8
.d3:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8
.d4:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8
.d5:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8
.d6:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8
.d7:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8
	assert SPAflip_table-SPAList == SPAflip

