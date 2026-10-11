; SPC700 uploads, the sound queue, music cues (keeps ScoutingReportText here too).
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84D630
ScoutingReportText:		;ScoutingReportText (read from UpdateScoutingDisplay_go)
	incbin "../data/Text/ScoutingReportText.bin"
ScoutingReportTextEnd:
