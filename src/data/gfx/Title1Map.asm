Title1Map:		;the title screen backdrop, packed (map, palette, tiles)
	incbin "../../../data/Title1.map.pak"
Title1MapEnd:
	assert Title1MapEnd-Title1Map == $25F9
