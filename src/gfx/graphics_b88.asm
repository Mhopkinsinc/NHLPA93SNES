; gfx/ packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $88. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $888000
GameSetupMap:		;SNES: the game setup screen backdrop (two team boxes, options box), packed: 32 x 32 map, 128 colours at $800, 18 tiles at $900
	incbin "../../data/GameSetup.map.pak"
GameSetupMapEnd:
	assert GameSetupMapEnd-GameSetupMap == $22F
SmallFontMap:		;print character (0-127) -> small font tile (+ flip bits), added to smallfontchars by print
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; chars $00-$07
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000		; chars $08-$0F
	dw $0000,$0000,$0001,$0002,$0003,$0000,$0004,$0005		; chars $10-$17
	dw $0006,$0007,$0000,$0000,$0000,$0060,$0061,$0062		; chars $18-$1F
	dw $0000,$0008,$0009,$000A,$000B,$000C,$0000,$000D		; chars $20-$27
	dw $000E,$000F,$0010,$0011,$0012,$0013,$0014,$0015		; chars $28-$2F
	dw $0016,$0017,$0018,$0019,$001A,$001B,$001C,$001D		; chars $30-$37
	dw $001E,$001F,$0020,$0021,$0022,$0023,$0024,$0025		; chars $38-$3F
	dw $0026,$0027,$0028,$0029,$002A,$002B,$002C,$002D		; chars $40-$47
	dw $002E,$002F,$0030,$0031,$0032,$0033,$0034,$0016		; chars $48-$4F
	dw $0035,$0036,$0037,$0038,$0039,$003A,$003B,$003C		; chars $50-$57
	dw $003D,$003E,$003F,$0040,$0041,$4040,$0042,$0043		; chars $58-$5F
	dw $0044,$0045,$0046,$0047,$0048,$0049,$004A,$004B		; chars $60-$67
	dw $004C,$004D,$004E,$004F,$0050,$0051,$0052,$0053		; chars $68-$6F
	dw $0054,$0055,$0056,$0057,$0058,$0059,$005A,$005B		; chars $70-$77
	dw $005C,$005D,$005E,$0063,$005F,$8063,$0000,$0000		; chars $78-$7F

org $88871C
FramerMap:		;Framer.map.jim: the 3 x 3 box pieces (corner, edge, side, centre) from the 4 FramerTiles with flips (Framer_piece)
	dw $0000,$0001,$4000
	dw $0002,$0003,$4002
	dw $8000,$8001,$C000
FramerTiles:		;the 4 Framer box tiles (4bpp, data/Framer.chr): vram by ScoutingReport_loop7; setupice remaps them with PixelRemap87
	incbin "../../data/Framer.chr"

org $889B73
TeamBlocksTiles:		;TeamBlocks.map.jim tiles: 405 team name banner tiles, packed ($32A0 bytes unpacked); sent to vram by PlayoffScreen, the scouting report and setoptions
	incbin "../../data/TeamBlocks.chr.pak"
TeamBlocksTilesEnd:
	assert TeamBlocksTilesEnd-TeamBlocksTiles == $20E3
