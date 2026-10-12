PenaltyManager:		;Run the penalty work once a frame: penalty times, new calls, the referee's progress and his animation
	jsl.l updatepentime
	jsl.l checkfornewpen
	jsl.l chkprogress
	jmp.w UpdatePA
