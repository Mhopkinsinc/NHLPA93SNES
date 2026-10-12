ClearPenaltyMessage:		;blank the horizontal mode penalty message line (22 spaces at x 5, y $B)
	jsl.l printz
	dw $001B		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0B,"                      "
	rtl
