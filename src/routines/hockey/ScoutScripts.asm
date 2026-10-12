ScoutScripts:		;The scouting report animation scripts: animation and facing steps
	dw .s0-ScoutScripts,.s1-ScoutScripts,.s2-ScoutScripts,.s3-ScoutScripts,.s4-ScoutScripts,.s5-ScoutScripts,.s6-ScoutScripts,.s7-ScoutScripts
.s0:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglover,4,SPAgready2,4,SPAgglovel,4,SPAgready2,4,0
.s5:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglovel,4,SPAgready2,4,SPAgready2,4,0
.s1:	dw SPAskate,3,SPAskate,4,SPAcelebrate,-5,SPAcelebrate,4,SPAglide,4,SPAglide,4,0
.s2:	dw SPAskatewp,4,SPAskatewp,4,SPAskatewp,-4,SPAglide,4,SPAglide,4,0
.s3:	dw SPAskatewp,5,SPAskatewp,5,SPAshotf,-5,SPAglide,5,SPAglide,5,0
.s4:	dw SPAskatewp,3,SPAskatewp,3,SPAstumble,-3,SPAshotf,3,SPAglide,3,SPAglide,3,0
.s6:	dw SPAskate,4,SPAskate,5,SPAsweepchk,-5,SPAsweepchk,5,SPAskate,5,SPAsweepchk,5,SPAglide,5,SPAglide,5,0
.s7:	dw SPAskate,3,SPAskate,2,SPAfight,-2,SPAfhigh,2,SPAflow,2,SPAfhigh,2,SPAflow,2,0
