SPAfaceoff_table:		;SPAfaceoff frames by direction
	dw .d0-SPAfaceoff_table		; direction 0
	dw .d1-SPAfaceoff_table		; direction 1
	dw .d1-SPAfaceoff_table		; direction 2
	dw .d1-SPAfaceoff_table		; direction 3
	dw .d1-SPAfaceoff_table		; direction 4
	dw .d1-SPAfaceoff_table		; direction 5
	dw .d1-SPAfaceoff_table		; direction 6
	dw .d1-SPAfaceoff_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp,2,SPFsweep+1,10,SPFsweep,-6
.d1:	dw SPFskatewp+20,2,SPFsweep+9,10,SPFsweep+8,-6
	assert SPAfaceoff_table-SPAList == SPAfaceoff

