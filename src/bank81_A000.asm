; $81A000-$81AFFF  ROM $0A000-$0AFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $81A000
	incbin "../data/gamesamples.brr":$1FAC..$2FAC		; $81A000-$81AFFF
