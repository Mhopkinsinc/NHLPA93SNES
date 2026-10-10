; sound_b84: 93G sound93: SPC700 uploads, the sound queue, music cues (93G keeps ScoutingReportText here too).
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84D630
ScoutingReportText:		;93G ScoutingReportText (read from $84F54D)
	incbin "../data/Text/ScoutingReportText.bin"		; $84D630-$84E948
ScoutingReportTextEnd:
