SPAfallfwd_table:		;SPAfallfwd frames by direction
	dw .d0-SPAfallfwd_table		; direction 0
	dw .d1-SPAfallfwd_table		; direction 1
	dw .d2-SPAfallfwd_table		; direction 2
	dw .d3-SPAfallfwd_table		; direction 3
	dw .d4-SPAfallfwd_table		; direction 4
	dw .d5-SPAfallfwd_table		; direction 5
	dw .d6-SPAfallfwd_table		; direction 6
	dw .d7-SPAfallfwd_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfallfwd,6,SPFfallfwd+1,6,SPFfallfwd+2,100,SPFfallfwd+3,8,SPFduck,-8
.d1:	dw SPFfallfwd+4,6,SPFfallfwd+5,6,SPFfallfwd+6,100,SPFfallfwd+7,8,SPFduck+1,-8
.d2:	dw SPFfallfwd+8,6,SPFfallfwd+9,6,SPFfallfwd+10,100,SPFfallfwd+11,8,SPFduck+2,-8
.d3:	dw SPFfallfwd+12,6,SPFfallfwd+13,6,SPFfallfwd+14,100,SPFfallfwd+15,8,SPFduck+3,-8
.d4:	dw SPFfallfwd+16,6,SPFfallfwd+17,6,SPFfallfwd+18,100,SPFfallfwd+19,8,SPFduck+4,-8
.d5:	dw SPFfallfwd+20,6,SPFfallfwd+21,6,SPFfallfwd+22,100,SPFfallfwd+23,8,SPFduck+5,-8
.d6:	dw SPFfallfwd+24,6,SPFfallfwd+25,6,SPFfallfwd+26,100,SPFfallfwd+27,8,SPFduck+6,-8
.d7:	dw SPFfallfwd+28,6,SPFfallfwd+29,6,SPFfallfwd+30,100,SPFfallfwd+31,8,SPFduck+7,-8
	assert SPAfallfwd_table-SPAList == SPAfallfwd

