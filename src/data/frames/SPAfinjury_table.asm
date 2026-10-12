SPAfinjury_table:		;SPAfinjury frames by direction
	dw .d0-SPAfinjury_table		; direction 0
	dw .d0-SPAfinjury_table		; direction 1
	dw .d0-SPAfinjury_table		; direction 2
	dw .d0-SPAfinjury_table		; direction 3
	dw .d0-SPAfinjury_table		; direction 4
	dw .d0-SPAfinjury_table		; direction 5
	dw .d0-SPAfinjury_table		; direction 6
	dw .d0-SPAfinjury_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+14,8,SPFfight+15,8,SPFfight+16,20,SPFfinjury,8,SPFfinjury+1,8,SPFfinjury+2,8,SPFfinjury+3,10,SPFfinjury+4,10
	dw SPFfinjury+5,10,SPFfinjury+3,10,SPFfinjury+4,10,SPFfinjury+5,10,SPFfinjury+3,10,SPFfinjury+4,10,SPFfinjury+5,10,SPFfinjury+3,10
	dw SPFfinjury+4,10,SPFfinjury+5,-400
	assert SPAfinjury_table-SPAList == SPAfinjury

