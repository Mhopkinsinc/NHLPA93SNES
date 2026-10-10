; $82CDA0-$82DFFF  ROM $14DA0-$15FFF: IceRinkTiles, the rink background tiles packed for the decompressor at $86FA3E (stream format in the
; PackedScreenData comment, bank80_F000). setupice unpacks them to $7F0000 and sends $40E0 bytes to vram $1000 (93G IceRink.map.jim tiles).
; data/IceRinkTiles.pak is the packed stream ($2B9C bytes, $82CDA0-$82F93B); this file holds the first part, bank82_E000 the rest.
; Starts at the packed rink tiles (boundary moved from $82D000).
org $82CDA0
IceRinkTiles:		;packed rink tiles (93G IceRinkMap tiles)
	incbin "../data/IceRinkTiles.pak":0..$1260		; $82CDA0-$82DFFF
