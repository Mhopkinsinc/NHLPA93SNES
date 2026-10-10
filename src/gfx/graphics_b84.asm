; gfx/graphics_b84: 93G graphics93: packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84E949
FaceOffMap:		;93G FaceOffMap (92G FaceOffMap): the 12 x 10 faceoff box map (tiles from FaceOffTiles, attribute $20), copied into textmap by puckfaceoff2 ($80A3F4)
	dw $2000,$2001,$2002,$2003,$2004,$2005,$2006,$2007,$2008,$2009,$200A,$200B
	dw $200C,$200D,$200E,$200F,$2010,$2011,$2012,$2013,$2014,$2015,$2016,$2017
	dw $2018,$2019,$201A,$2019,$2019,$2019,$201B,$201C,$2019,$2019,$2019,$201D
	dw $201E,$201F,$2020,$201F,$201F,$201F,$2021,$2022,$601F,$601F,$601F,$2023
	dw $2024,$2025,$2026,$2025,$2025,$2025,$2027,$2028,$2025,$2025,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$202A,$202B,$202C,$2025,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$202D,$202E,$202F,$2025,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$2030,$2031,$2032,$2033,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2029
	dw $2034,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2036

org $84EF3C
HotList:		;93G HotList: hot spot (stick blade) x, y bytes for every sprite frame (549 pairs), read by GetHot
	incbin "../../data/HotList.bin":0..$44A		; $84EF3C-$84F385
RinkLogoTiles:		;SNES: packed rink logo tiles (14 tiles, $1C0 bytes unpacked), sent to vram after FaceOffTiles by setupice. Kept in data/HotList.bin after the hot spots
	incbin "../../data/HotList.bin":$44A..$5F6		; $84F386-$84F531
RinkLogoTilesEnd:

org $84F79D
PlayoffTiles:		;packed playoff screen palette and tiles (decompressor $86FA3E): 128 colours, then 6 tiles; PlayoffScreen sends them to vram $1000
	incbin "../../data/PlayoffTiles.chr.pak"		; $84F79D-$84F815
