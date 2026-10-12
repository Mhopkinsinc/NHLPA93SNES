; gfx/ packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $89. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $89EB45
RefTilesHor:		;packed ref window tiles for the horizontal rink (104 tiles, data/RefHor.chr.pak): setupice sends them to refcharshor
	incbin "../../data/RefHor.chr.pak"
RefTilesHorEnd:
	assert RefTilesHorEnd-RefTilesHor == $8B6
RefsMapHor:		;ref window frames for the horizontal rink, 17 frames of 8 x 7 words (data/RefsHor.snesmap); PushRef uses it when sfhormode
	incbin "../../data/RefsHor.snesmap"
RefsMapHorEnd:
	assert RefsMapHorEnd-RefsMapHor == 17*$70
