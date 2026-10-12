RefsMap:		;the ref window frames, 7 frames of 8 x 7 words (data/Refs.snesmap); PushRef copies frame d0 (+$70 each)
	incbin "../../../data/Refs.snesmap"
RefsMapEnd:
	assert RefsMapEnd-RefsMap == 7*$70
