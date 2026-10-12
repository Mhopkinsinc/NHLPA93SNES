GameSetupMap:		;SNES: the game setup screen backdrop (two team boxes, options box), packed: 32 x 32 map, 128 colours at $800, 18 tiles at $900
	incbin "../../../data/GameSetup.map.pak"
GameSetupMapEnd:
	assert GameSetupMapEnd-GameSetupMap == $22F
