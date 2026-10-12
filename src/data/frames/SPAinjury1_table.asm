SPAinjury1_table:		;SPAinjury1 frames by direction
	dw .d0-SPAinjury1_table		; direction 0
	dw .d0-SPAinjury1_table		; direction 1
	dw .d0-SPAinjury1_table		; direction 2
	dw .d3-SPAinjury1_table		; direction 3
	dw .d3-SPAinjury1_table		; direction 4
	dw .d3-SPAinjury1_table		; direction 5
	dw .d3-SPAinjury1_table		; direction 6
	dw .d0-SPAinjury1_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfallback,20,SPFfallback+1,20,SPFfallback+2,1000,SPFfallback+2,-1000
.d3:	dw SPFfallback+16,20,SPFfallback+17,20,SPFfallback+18,1000,SPFfallback+18,-1000
	assert SPAinjury1_table-SPAList == SPAinjury1
SPAListEnd:		;end of the SPA tables
