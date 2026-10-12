SPAbglass_table:		;SPAbglass frames by direction
	dw .d0-SPAbglass_table		; direction 0
	dw .d0-SPAbglass_table		; direction 1
	dw .d0-SPAbglass_table		; direction 2
	dw .d0-SPAbglass_table		; direction 3
	dw .d0-SPAbglass_table		; direction 4
	dw .d0-SPAbglass_table		; direction 5
	dw .d0-SPAbglass_table		; direction 6
	dw .d0-SPAbglass_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFbglass,8,SPFbglass+1,8,SPFbglass+2,8,SPFbglass+3,8,SPFbglass+4,-1000
	assert SPAbglass_table-SPAList == SPAbglass

