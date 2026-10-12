RefsMapHor:		;ref window frames for the horizontal rink, 17 frames of 8 x 7 words (data/RefsHor.snesmap); PushRef uses it when sfhormode
	incbin "../../../data/RefsHor.snesmap"
RefsMapHorEnd:
	assert RefsMapHorEnd-RefsMapHor == 17*$70
