SPAglideback_table:		;SPAglideback frames by direction
	dw .d0-SPAglideback_table		; direction 0
	dw .d1-SPAglideback_table		; direction 1
	dw .d2-SPAglideback_table		; direction 2
	dw .d3-SPAglideback_table		; direction 3
	dw .d4-SPAglideback_table		; direction 4
	dw .d5-SPAglideback_table		; direction 5
	dw .d6-SPAglideback_table		; direction 6
	dw .d7-SPAglideback_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskateb,-8
.d1:	dw SPFskateb+3,-8
.d2:	dw SPFskateb+6,-8
.d3:	dw SPFskateb+9,-8
.d4:	dw SPFskateb+12,-8
.d5:	dw SPFskateb+15,-8
.d6:	dw SPFskateb+18,-8
.d7:	dw SPFskateb+21,-8
	assert SPAglideback_table-SPAList == SPAglideback

