; $83E000-$83F72A  ROM $1E000-$1F72A: IceRinkMap continued (vertical rink tile map, see bank83_D000), then HorRinkMap: the horizontal
; rink tile map, 48 x 28 words (data/IceRinkHor.snesmap). SetHor ($8FF5C3/$8FF5EA) sends 32 columns of each row from $83ECAB, or from
; $83ECBB (8 columns in) for the other end. Ends before the rink palette (boundary moved from $83EFFF).
org $83E000
	incbin "../data/IceRink.snesmap":$1335..$1FE0		; $83E000-$83ECAA
IceRinkMapEnd:
	assert IceRinkMapEnd-IceRinkMap == 48*85*2
HorRinkMap:		;horizontal rink tile map, 48 x 28 words (93G SetHor draws IceRinkMap sideways instead)
	incbin "../data/IceRinkHor.snesmap"		; $83ECAB-$83F72A
HorRinkMapEnd:
	assert HorRinkMapEnd-HorRinkMap == 48*28*2
