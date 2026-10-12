SPAsweepchk_table:		;SPAsweepchk frames by direction
	dw .d0-SPAsweepchk_table		; direction 0
	dw .d1-SPAsweepchk_table		; direction 1
	dw .d2-SPAsweepchk_table		; direction 2
	dw .d3-SPAsweepchk_table		; direction 3
	dw .d4-SPAsweepchk_table		; direction 4
	dw .d5-SPAsweepchk_table		; direction 5
	dw .d6-SPAsweepchk_table		; direction 6
	dw .d7-SPAsweepchk_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFsweep,4,SPFsweep+1,8,SPFsweep,-4
.d1:	dw SPFsweep+2,4,SPFsweep+3,8,SPFsweep+2,-4
.d2:	dw SPFsweep+4,4,SPFsweep+5,8,SPFsweep+4,-4
.d3:	dw SPFsweep+6,4,SPFsweep+7,8,SPFsweep+6,-4
.d4:	dw SPFsweep+8,4,SPFsweep+9,8,SPFsweep+8,-4
.d5:	dw SPFsweep+10,4,SPFsweep+11,8,SPFsweep+10,-4
.d6:	dw SPFsweep+12,4,SPFsweep+13,8,SPFsweep+12,-4
.d7:	dw SPFsweep+14,4,SPFsweep+15,8,SPFsweep+14,-4
	assert SPAsweepchk_table-SPAList == SPAsweepchk

