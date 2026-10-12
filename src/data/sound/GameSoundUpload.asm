GameSoundUpload:		;in-game sample set for the SPC700 sound driver (the boot stream at BootSoundUpload carries the driver itself)
	dw GameSampleDirEnd-GameSampleDir, SPCSAMPLEDIR		; block 1: 76 bytes to APU $2C00
