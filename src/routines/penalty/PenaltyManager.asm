PenaltyManager:		;called periodically. d7 = elapsed time since last call
		;   SNES: updatepentime, checkfornewpen, chkprogress, UpdatePA
	jsl.l updatepentime
	jsl.l checkfornewpen
	jsl.l chkprogress
	jmp.w UpdatePA
