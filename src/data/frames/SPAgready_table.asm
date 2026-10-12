SPAgready_table:		;SPAgready frames by direction
	dw .d0-SPAgready_table		; direction 0
	dw .d1-SPAgready_table		; direction 1
	dw .d2-SPAgready_table		; direction 2
	dw .d3-SPAgready_table		; direction 3
	dw .d4-SPAgready_table		; direction 4
	dw .d5-SPAgready_table		; direction 5
	dw .d6-SPAgready_table		; direction 6
	dw .d7-SPAgready_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFGoalie,180,SPFgready,10,SPFgready+1,10,SPFgready,10,SPFgready+1,10,SPFGoalie,240,SPFgready,10,SPFgready+1,10
	dw SPFgready,-10
.d1:	dw SPFGoalie+3,130,SPFgready+2,10,SPFgready+3,10,SPFgready+2,10,SPFgready+3,10,SPFGoalie+3,300,SPFgready+2,10,SPFgready+3,10
	dw SPFgready+2,-10
.d2:	dw SPFGoalie+6,210,SPFgready+4,10,SPFgready+5,10,SPFgready+4,10,SPFgready+5,10,SPFGoalie+6,120,SPFgready+4,10,SPFgready+5,10
	dw SPFgready+4,-10
.d3:	dw SPFGoalie+9,100,SPFgready+6,10,SPFgready+7,10,SPFgready+6,10,SPFgready+7,10,SPFGoalie+9,200,SPFgready+6,10,SPFgready+7,10
	dw SPFgready+6,-10
.d4:	dw SPFGoalie+12,240,SPFgready+8,10,SPFgready+9,10,SPFgready+8,10,SPFgready+9,10,SPFGoalie+12,60,SPFgready+8,10,SPFgready+9,10
	dw SPFgready+8,-10
.d5:	dw SPFGoalie+15,180,SPFgready+10,10,SPFgready+11,10,SPFgready+10,10,SPFgready+11,10,SPFGoalie+15,240,SPFgready+10,10,SPFgready+11,10
	dw SPFgready+10,-10
.d6:	dw SPFGoalie+18,120,SPFgready+12,10,SPFgready+13,10,SPFgready+12,10,SPFgready+13,10,SPFGoalie+18,120,SPFgready+12,10,SPFgready+13,10
	dw SPFgready+12,-10
.d7:	dw SPFGoalie+21,180,SPFgready+14,10,SPFgready+15,10,SPFgready+14,10,SPFgready+15,10,SPFGoalie+21,180,SPFgready+14,10,SPFgready+15,10
	dw SPFgready+14,-10
	assert SPAgready_table-SPAList == SPAgready

