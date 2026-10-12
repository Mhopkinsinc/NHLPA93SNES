PasswordText:		;"Password" at 2, 14, "Press Start" at 10, 24, then print at 21, 14; then an empty string ends it
	dw 30
	db $FF,2,14,"Password",$FF,10,24,"Press Start",$FF,21,14
	dw 3
	db 0
