; $82B000-$82B86B  ROM $13000-$1386B: the end of the in-game SPC upload stream (see bank81_8000): the last BRR samples and the end block.
; Ends before SPAList (boundary moved from $82BFFF).
org $82B000
	incbin "../data/gamesamples.brr":$AFAC..$B814		; $82B000-$82B867
GameSamplesEnd:
	dw $0000, SPCRESUME		; end block: length 0, start the driver at $0800
