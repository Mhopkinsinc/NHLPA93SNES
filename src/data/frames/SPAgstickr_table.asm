SPAgstickr_table:		;SPAgstickr frames by direction
	dw .d0-SPAgstickr_table		; direction 0
	dw .d1-SPAgstickr_table		; direction 1
	dw .d2-SPAgstickr_table		; direction 2
	dw .d3-SPAgstickr_table		; direction 3
	dw .d4-SPAgstickr_table		; direction 4
	dw .d5-SPAgstickr_table		; direction 5
	dw .d6-SPAgstickr_table		; direction 6
	dw .d7-SPAgstickr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+64,-32
.d1:	dw SPFGoalie+66,-32
.d2:	dw SPFGoalie+68,-32
.d3:	dw SPFGoalie+70,-32
.d4:	dw SPFGoalie+72,-32
.d5:	dw SPFGoalie+74,-32
.d6:	dw SPFGoalie+76,-32
.d7:	dw SPFGoalie+78,-32
	assert SPAgstickr_table-SPAList == SPAgstickr

