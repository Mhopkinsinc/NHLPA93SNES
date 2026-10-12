SPAskateback_table:		;SPAskateback frames by direction
	dw .d0-SPAskateback_table		; direction 0
	dw .d1-SPAskateback_table		; direction 1
	dw .d2-SPAskateback_table		; direction 2
	dw .d3-SPAskateback_table		; direction 3
	dw .d4-SPAskateback_table		; direction 4
	dw .d5-SPAskateback_table		; direction 5
	dw .d6-SPAskateback_table		; direction 6
	dw .d7-SPAskateback_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskateb,10,SPFskateb+1,10,SPFskateb,10,SPFskateb+2,-10
.d1:	dw SPFskateb+3,10,SPFskateb+4,10,SPFskateb+3,10,SPFskateb+5,-10
.d2:	dw SPFskateb+6,10,SPFskateb+7,10,SPFskateb+6,10,SPFskateb+8,-10
.d3:	dw SPFskateb+9,10,SPFskateb+10,10,SPFskateb+9,10,SPFskateb+11,-10
.d4:	dw SPFskateb+12,10,SPFskateb+13,10,SPFskateb+12,10,SPFskateb+14,-10
.d5:	dw SPFskateb+15,10,SPFskateb+16,10,SPFskateb+15,10,SPFskateb+17,-10
.d6:	dw SPFskateb+18,10,SPFskateb+19,10,SPFskateb+18,10,SPFskateb+20,-10
.d7:	dw SPFskateb+21,10,SPFskateb+22,10,SPFskateb+21,10,SPFskateb+23,-10
	assert SPAskateback_table-SPAList == SPAskateback

