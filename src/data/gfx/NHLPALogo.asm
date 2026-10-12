NHLPALogo:		;SNES: the NHLPA logo, packed (data/NHLPALogo.map.pak): 8 x 10 map, 128 colours at $A0, 53 tiles at $1A0; game setup and playoff screens
	incbin "../../../data/NHLPALogo.map.pak"
NHLPALogoEnd:
	assert NHLPALogoEnd-NHLPALogo == $45A
