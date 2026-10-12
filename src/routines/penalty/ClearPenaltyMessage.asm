ClearPenaltyMessage:		;Blank the penalty message line on the horizontal rink
	jsl.l printz
	dw $001B		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0B,"                      "
	rtl
