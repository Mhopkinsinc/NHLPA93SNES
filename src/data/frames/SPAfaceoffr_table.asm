SPAfaceoffr_table:		;SPAfaceoffr frames by direction
	dw .d0-SPAfaceoffr_table		; direction 0
	dw .d1-SPAfaceoffr_table		; direction 1
	dw .d1-SPAfaceoffr_table		; direction 2
	dw .d1-SPAfaceoffr_table		; direction 3
	dw .d1-SPAfaceoffr_table		; direction 4
	dw .d1-SPAfaceoffr_table		; direction 5
	dw .d1-SPAfaceoffr_table		; direction 6
	dw .d1-SPAfaceoffr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp,-5
.d1:	dw SPFskatewp+20,-5
	assert SPAfaceoffr_table-SPAList == SPAfaceoffr

