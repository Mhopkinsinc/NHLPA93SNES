PlayoffTreeSetup:		;The playoff tree layout for each round
	dw .lvl0-PlayoffTreeSetup,.lvl1-PlayoffTreeSetup,.lvl2-PlayoffTreeSetup,.lvl3-PlayoffTreeSetup,.lvl4-PlayoffTreeSetup
.lvl0:		;gamelevel 0: 16 team slots (x, y)
	db 16
	db 49,2,49,5,49,8,49,11,49,14,49,17,49,20,49,23
	db 70,2,70,5,70,8,70,11,70,14,70,17,70,20,70,23
	db 0,58,1,59,10,68,11,69,$FF		; arrows (graphics, x), $FF
	db 48,48		; Hscroll min, max (x8)
	db 8,52,4,52,10,52,16,52,22,73,4,73,10,73,16,73,22		; series scores (x, y)
.lvl1:		;gamelevel 1: 24 team slots (x, y)
	db 24
	db 38,2,38,5,38,8,38,11,38,14,38,17,38,20,38,23
	db 81,2,81,5,81,8,81,11,81,14,81,17,81,20,81,23
	db 49,4,49,10,49,15,49,21,70,4,70,10,70,15,70,21
	db 0,47,1,48,2,58,3,59,8,68,9,69,10,79,11,80,$FF		; arrows (graphics, x), $FF
	db 33,63		; Hscroll min, max (x8)
	db 4,52,8,52,18,73,8,73,18		; series scores (x, y)
.lvl2:		;gamelevel 2: 28 team slots (x, y)
	db 28
	db 27,2,27,5,27,8,27,11,27,14,27,17,27,20,27,23
	db 92,2,92,5,92,8,92,11,92,14,92,17,92,20,92,23
	db 38,4,38,10,38,15,38,21,81,4,81,10,81,15,81,21
	db 49,7,49,18,70,7,70,18
	db 0,36,1,37,2,47,3,48,4,58,5,59,6,68,7,69,8,79,9,80,10,90,11,91,$FF		; arrows (graphics, x), $FF
	db 22,74		; Hscroll min, max (x8)
	db 2,52,13,73,13		; series scores (x, y)
.lvl3:		;gamelevel 3: 30 team slots (x, y)
	db 30
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21
	db 38,7,38,18,81,7,81,18,49,12,70,12
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; arrows (graphics, x), $FF
	db 11,85		; Hscroll min, max (x8)
	db 1,62,23		; series scores (x, y)
.lvl4:		;gamelevel 4: 31 team slots (x, y)
	db 31
	db 16,2,16,5,16,8,16,11,16,14,16,17,16,20,16,23
	db 103,2,103,5,103,8,103,11,103,14,103,17,103,20,103,23
	db 27,4,27,10,27,15,27,21,92,4,92,10,92,15,92,21
	db 38,7,38,18,81,7,81,18,49,12,70,12,59,23
	db 0,25,1,26,2,36,3,37,4,47,5,48,5,58,6,69,6,79,7,80,8,90,9,91,10,101,11,102,$FF		; arrows (graphics, x), $FF
	db 11,85		; Hscroll min, max (x8)
	db 0		; series scores (x, y)
