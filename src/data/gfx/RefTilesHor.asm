RefTilesHor:		;packed ref window tiles for the horizontal rink (104 tiles, data/RefHor.chr.pak): setupice sends them to refcharshor
	incbin "../../../data/RefHor.chr.pak"
RefTilesHorEnd:
	assert RefTilesHorEnd-RefTilesHor == $8B6
