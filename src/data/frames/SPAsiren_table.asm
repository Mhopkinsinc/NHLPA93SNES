SPAsiren_table:		;SPAsiren frames by direction
	dw .d0-SPAsiren_table		; direction 0
	dw .d0-SPAsiren_table		; direction 1
	dw .d0-SPAsiren_table		; direction 2
	dw .d0-SPAsiren_table		; direction 3
	dw .d0-SPAsiren_table		; direction 4
	dw .d0-SPAsiren_table		; direction 5
	dw .d0-SPAsiren_table		; direction 6
	dw .d0-SPAsiren_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFSiren,3,SPFSiren+1,3,SPFSiren+2,3,SPFSiren+3,3,SPFSiren+4,3,SPFSiren+5,3,SPFSiren+6,3,SPFSiren+7,3
	dw SPFSiren+8,3,SPFSiren+9,3,SPFSiren+10,3,SPFSiren+11,3,SPFSiren+12,3,SPFSiren+13,-3
	assert SPAsiren_table-SPAList == SPAsiren

