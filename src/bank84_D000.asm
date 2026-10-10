; $84D000-$84E948  ROM $25000-$26948: the last SpriteSet9 tiles, then ScoutingReportText: the scouting report paragraphs (93G
; ScoutingReportText, sound93.asm incbin Text/ScoutingReportText.bin; the SNES text is 4889 bytes, 93G 4915). One paragraph per team
; ending with a carriage return, then the intro lines (~ [ ] { } are filled in by the printer). Ends at the end of the text
; (boundary moved from $84DFFF).
org $84D000
	incbin "../data/Sprites/set09.chr":$49D0..$5000		; $84D000-$84D62F
SpriteSet9End:
	assert SpriteSet9End-SpriteSet9 == $630+640*32
ScoutingReportText:		;93G ScoutingReportText (read from $84F54D)
	incbin "../data/Text/ScoutingReportText.bin"		; $84D630-$84E948
ScoutingReportTextEnd:
