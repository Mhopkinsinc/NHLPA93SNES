SPApflip_table:		;SPApflip frames by direction
	dw .d0-SPApflip_table		; direction 0
	dw .d1-SPApflip_table		; direction 1
	dw .d2-SPApflip_table		; direction 2
	dw .d3-SPApflip_table		; direction 3
	dw .d4-SPApflip_table		; direction 4
	dw .d5-SPApflip_table		; direction 5
	dw .d6-SPApflip_table		; direction 6
	dw .d7-SPApflip_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFpuck+2,4,SPFpuck+3,4,SPFpuck+4,4,SPFpuck+5,4,SPFpuck+6,4,SPFpuck+3,4,SPFpuck+7,4,SPFpuck+1,-4
.d1:	dw SPFpuck+9,2,SPFpuck+1,2,SPFpuck+8,2,SPFpuck+5,2,SPFpuck+10,2,SPFpuck+5,2,SPFpuck+8,2,SPFpuck+1,-2
.d2:	dw SPFpuck+4,2,SPFpuck+3,2,SPFpuck+2,2,SPFpuck+1,2,SPFpuck+7,2,SPFpuck+3,2,SPFpuck+6,2,SPFpuck+5,-2
.d3:	dw SPFpuck+8,4,SPFpuck+1,4,SPFpuck+9,4,SPFpuck+1,4,SPFpuck+8,4,SPFpuck+5,4,SPFpuck+10,4,SPFpuck+5,-4
.d4:	dw SPFpuck+1,-4096
.d5:	dw SPFpuck+1,-4096
.d6:	dw SPFpuck+5,-4096
.d7:	dw SPFpuck+5,-4096
	assert SPApflip_table-SPAList == SPApflip

