addframe_end:		;End of addframe: clear the flip and sprite flags
	stz.b sprhflip
	stz.b sprvflip
	stz.b sprflag
	rtl
