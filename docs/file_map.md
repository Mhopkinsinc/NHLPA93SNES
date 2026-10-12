# Source file map

`src/nhlpa93snes.asm` includes one file per 93G module per bank, named after the NHLPA 93 Genesis source files
(`hockey93_01..11` -> `hockey`, `logic93_1..5` -> `logic`, `middle93_1/2` -> `middle`, `penalty93_1/2` -> `penalty`,
`video93_1/2` -> `video`, `stats93`, `sound93`, `frames93`, `teamdata93`, `main93`; `graphics93` and the sprite frame sets are in `src/gfx/`).
A file is `<module>_b<bank>.asm`, or `<module>.asm` when the module sits in one bank only. The SNES code of a module is spread
over the ROM between other modules, so each file holds one or more blocks, each starting with `org` at its ROM address.
Routines with no Genesis counterpart go with the module of their caller/neighbour; SNES hardware code (vblank/IRQ handlers,
PPU/DMA, sprite emitters) is in `video`, the SPC700 sound code and data in `sound`, math helpers in `middle`.

Regenerate the routine lists from the source if they drift; the old ~4 KB slice notes are in `docs/segment_notes.md`.

## src/main.asm

- `$808000`: Start

## src/video_b80.asm

- `$8080B2`: BRKHalt, VBjsr, vb2_blank, vb2, vb2_main, VBlank_long, VBlank, VBlank_SprPal, VBlank_List, VBlank_VScroll, VBlank_Cram, VBlank_CramOnly, HBjsr, HBdefault
- `$80E35E`: setvideo, show_rink, checkfo, setsortcords, projxy, setffo, ButtonLabelCharTable, uppads

## src/logic_b80.asm

- `$8083AB`: goalieacc, dostop, StopNA
- `$8084E7`: MaxSpeed, check4bench, checkob, chk4lc, chk4shot, CompShoot, assnearest, check4check, burst, skatetopuck, Sweepcheck, chkpk, chkpk2, assshoot, SetShotMode, ShotMode, doshot, shotsets, asspassrec, assfight, chkhit, CwdFight, FightFall, assfwatch, assfaceoff, assexit, assfaceoffpl
- `$8097AC`: pucknorm, findpc, findpc_calc
- `$8099C7`: a2touchpuck, a2offsides, GetHot, puckIChk, ChkOffsides, ClearOffsidesIfAllPlayers
- `$80A148`: setc1player, setc2player, restorepl
- `$80A52A`: pucknothing, puckfaceoff, SetLCmode, SetLCmode2
- `$80A87C`: puckfaceoff2, updatefaceoff, Endfaceoff, dirtab
- `$80AE9D`: changeplayer, vtoa, SetSPA
- `$80B49D`: assinsert, assreplace
- `$80BAF2`: ChkGoalies, ChkGoalies_CPG
- `$80BE47`: ReturnGoalies, ReturnGoalies_r, CPgoalie
- `$80CEC9`: puckflip
- `$80DF3F`: doinput, faceoffinput, holdplayer, setpads
- `$80F391`: setlccords
- `$80F45B`: asspuckc
- `$80F6AD`: assgoalie, ClampYPosition, AdjustFacingDirection, GoalieSaveList, shotdiradj, CalcAngleOffset

## src/middle_b80.asm

- `$808496`: muls16
- `$8097A3`: randomd0
- `$80996C`: divs
- `$80AE56`: random, randoma
- `$80B8D8`: divu16, printz, print
- `$80C28B`: sfx
- `$80C40B`: Readjoy1, Readjoy2, ReadJoy, jdtab
- `$80CBB1`: sroot, divu
- `$80F3E8`: ReadPads
- `$80F6A1`: randomd0s

## src/hockey_b80.asm

- `$8084C4`: getpde, rtss
- `$809D17`: checkpuckcoll, checkpuckcoll_ccx, puckstick, puckglue, deflect
- `$80A1B4`: makepde, puckbody, puckgoalie
- `$80B01A`: ResetBench, forcepldata, Setplass, setplayer, ClampNibble, resetplstuff
- `$80B4C1`: setupice, setplayercolors, SetTeamColors, SetTeamColors_team, nullrtl, SprSort, DoGameFrame, periodicevents
- `$80BB5A`: setpersonel, SetPlList, TryAddPlayerToList
- `$80BED1`: updatecrowdf, PenaltyList
- `$80C278`: freezewindow
- `$80C2B4`: updatereplay, demoread
- `$80C46D`: updateplayers, checkcoll, checkwallcoll
- `$80CC1E`: wallcollb, wallcoll
- `$80CEE7`: checkgoal
- `$80D182`: Goal
- `$80D3D3`: checkgoalp, CheckBump, checkplcoll, checkcx, newcheck, checkint, FallDown, checkcheck, checkfight, SetInst
- `$80E13E`: updateanim, checkwindow
- `$80F36E`: adda43
- `$80F3E1`: startpause
- `$80F5EA`: DecodePW, PlayoffScreenOpening4, SuperDiv

## src/penalty_b80.asm

- `$80A828`: ClrHor
- `$80B84C`: AvgCline
- `$80B9F4`: updatepwrplay, updatepwrplay_clr, printteamname
- `$80C18F`: AddPenalty, AddPenalty2
- `$80D12E`: ChkShotStat, addteamstat
- `$80D329`: PenGoalStuff
- `$80E6C7`: PenaltyManager, chkatop, checkfornewpen, Stop4Pen, limitfo, chkprogress, InProgress, coinsearch, UpdatePA, SetPA
- `$80FED1`: reenergizeteam, unusedFF

## src/gfx/graphics_b80.asm

- `$80ED38`: RonBarrMap

## src/sound_b81.asm

- `$818000`: GameSoundUpload, GameSampleDir, GameSamples

## src/sound_b82.asm

- `$82B86C`: SPAList
- `$82FA1A`: sndqreset, SPCBootUpload, SPCGameUpload, SPCUpload, QueueSound

## src/frames.asm

- `$82B86E`: SPAgready_table, SPAgready2_table, SPAgglover_table, SPAgglovel_table, SPAgstickr_table, SPAgstickl_table, SPAgstackr_table, SPAgstackl_table, SPAgswing_table, SPAgskate_table, SPApflip_table, SPAglide_table, SPAskatewp_table, SPAskate_table, SPAturnl_table, SPAturnr_table, SPAstop_table, SPApassf_table, SPApassb_table, SPAshotf_table, SPAshotb_table, SPAglideback_table, SPAskateback_table, SPAsweepchk_table, SPAshoulderchkl_table, SPAshoulderchkr_table, SPAhipchkl_table, SPAhipchkr_table, SPAburst_table, SPAHold_table, SPAHold2_table, SPAflail_table, SPAfallfwd_table, SPAfallback_table, SPAcelebrate_table, SPApump_table, SPAfight_table, SPAfgrab_table, SPAfheld_table, SPAfhigh_table, SPAflow_table, SPAfhith_table, SPAfhitl_table, SPAffall_table, SPAwallright_table, SPAwallleft_table, SPAfaceoff_table, SPAfaceoffr_table, SPAsiren_table, SPAstanley_table, SPAfinjury_table, SPAflip_table, SPAstumble_table, SPAhook_table, SPAhook2_table, SPAcatch_table, SPAbglass_table, SPAgdive_table, SPAinjury1_table

## src/gfx/graphics_b82.asm

- `$82CDA0`: IceRinkTiles
- `$82FCBD`: PixelRemap8D
- `$82FCD4`: PixelRemap83

## src/penalty_b82.asm

- `$82F93C`: SetPA2, UpdateScores
- `$82FD95`: ClearPenaltyMessage

## src/hockey_b82.asm

- `$82FA01`: BitstoPW
- `$82FBA6`: PasstoText, PWtoBits, ClrPassBits, PushBits, BitMaskTable, ContinuePlayoffs, SaveRegsStartHL2
- `$82FDB5`: startpause2

## src/video_b82.asm

- `$82FCCD`: marktextlo
- `$82FD17`: addframe_hi, revplayeracc, marktexthi, ClearTeamStats

## src/middle_b82.asm

- `$82FCDB`: muls32
- `$82FDBF`: printbigz, appendz

## src/logic_b82.asm

- `$82FDE7`: asscentero, unusedFF82

## src/teamdata_b83.asm

- `$838000`: TeamList, AllStarsEast, AllStarsWest, Boston, Buffalo, Calgary, Chicago, Detroit, Edmonton, Hartford, LosAngeles, LongIsland, Minnesota, Montreal, NewJersey, NewYork, Ottawa, Philadelphia, Pittsburgh, Quebec, SanJose, StLouis, TampaBay, Toronto, Vancouver, Winnipeg, Washington, playoffseats

## src/gfx/graphics_b83.asm

- `$83C6D8`: SmallFontTiles
- `$83CCCB`: IceRinkMap, HorRinkMap, RinkPalette
- `$83FAEC`: RefsMap

## src/hockey_b83.asm

- `$83CC0C`: PlayerNumName
- `$83F82B`: Pausemode, PauseMenu, PauseReadJoy, PauseResume, PauseLeave, Restart

## src/logic_b83.asm

- `$83FDFC`: assgoalietopuck, unusedFF83

## src/gfx/sprites_b84.asm

- `$848000`: SpriteSet9

## src/sound_b84.asm

- `$84D630`: ScoutingReportText

## src/gfx/graphics_b84.asm

- `$84E949`: FaceOffMap
- `$84EF3C`: HotList, RinkLogoTiles
- `$84F79D`: PlayoffTiles

## src/middle_b84.asm

- `$84EA39`: PutDigits2
- `$84FAD2`: Readjoy12

## src/hockey_b84.asm

- `$84EA66`: ScoutPlayersRun, ScoutTeamStep, ScoutPlayerExit, ScoutNextPlayer, ScoutPickScript, GetRosterEntry, ScoutScriptPick, ScoutScriptPickG, ScoutScripts, ScoutLineOrder, DrawScoutPlayers, DrawScoutPlayer
- `$84F532`: UpdateScoutingDisplay, ScrollDisplayUp

## src/video_b84.asm

- `$84F816`: InitSortObjects, SsoInitTable, FfoInitTable, SortObjInitTable

## src/penalty_b84.asm

- `$84FAE3`: DisplayStats, DisplayStats_sslist

## src/stats_b84.asm

- `$84FC44`: GetNameandAttrib, attribjmp, AttribStatus, StatusTextTbl, AttribEnergy, AttribFighting, AttribRating, AttribPrintPct, AttribHanded, HandedTextTbl, AttribWeight, unusedFF84

## src/gfx/sprites_b85.asm

- `$858000`: SpriteSet4

## src/hockey_b85.asm

- `$85D5A4`: GetShifter
- `$85FF0E`: getpzjoy, PrintTeamNames, nullrtl85, ResetClock, unusedFF85

## src/gfx/graphics_b85.asm

- `$85D5C0`: Title1Map

## src/video_b85.asm

- `$85FBB9`: DrawFrameHi

## src/sound_b86.asm

- `$868000`: BootSoundUpload, SPCDriver, BootInstruments, BootSampleDir, BootSamples
- `$86FBE1`: StartSong6, StartSong7

## src/middle_b86.asm

- `$86FA3E`: DecompressBytecode
- `$86FC53`: ProcessInputWithRepeat

## src/hockey_b86.asm

- `$86FB96`: RestoreBenchEnergy
- `$86FC29`: setteams
- `$86FC76`: ScoutNamePos, GetPeriodTimeRemaining, GetPeriodTime, GetPeriodTime_timetab
- `$86FCE3`: PickStartingGoalie

## src/logic_b86.asm

- `$86FCB7`: lcfound2
- `$86FD86`: assscore, unusedFF86

## src/gfx/sprites_b87.asm

- `$878000`: SpriteSet2
- `$87D205`: SpriteSet6

## src/gfx/graphics_b87.asm

- `$87C3A0`: EASNMap, FaceOffTiles, TeamBlocksMap
- `$87F55A`: PixelRemap87, RefTiles

## src/video_b87.asm

- `$87CE62`: DrawFrame, addframe_end

## src/hockey_b87.asm

- `$87F3E9`: RestoreReplayFrame

## src/logic_b87.asm

- `$87FF78`: assepen, unusedFF87

## src/gfx/graphics_b88.asm

- `$888000`: GameSetupMap, SmallFontMap
- `$88871C`: FramerMap, FramerTiles
- `$889B73`: TeamBlocksTiles

## src/middle_b88.asm

- `$88832F`: mulu32
- `$888942`: mulu

## src/penalty_b88.asm

- `$888405`: getlinee

## src/hockey_b88.asm

- `$8884A9`: WritePassBits
- `$8885F7`: PWprint, EncodePW
- `$888853`: SuperMult, DrawGameSetupBack
- `$88EF9C`: GetPassWord, PasswordText, TitleScreen, CreditsBlank, PlayoffScreen, PlayoffTreeSetup
- `$88FDB2`: SuperAdd

## src/logic_b88.asm

- `$888548`: noturn0
- `$88FBA6`: assdefd
- `$88FDD0`: skateto, unusedFF88

## src/video_b88.asm

- `$8887AE`: showcrowd

## src/gfx/sprites_b88.asm

- `$888A0F`: SpriteSet8
- `$88BC56`: SpriteSet7

## src/gfx/sprites_b89.asm

- `$898000`: SpriteSet11
- `$899383`: SpriteSet13

## src/hockey_b89.asm

- `$8990F0`: ReplayMode
- `$89FCC1`: EraseScoutName, GetPlayerRecord, MesAreaDone, StartGame, restoreteams

## src/penalty_b89.asm

- `$89E95D`: printscores1, PrintPerLabel, PrintTeamNameAndScore, nullrtl89

## src/sound_b89.asm

- `$89EB15`: p_music_vblank
- `$89FB6B`: StartSong8, StartSong9, StartSong1, StartSong2, StartSong3, StartSong4, StartSong5

## src/gfx/graphics_b89.asm

- `$89EB45`: RefTilesHor, RefsMapHor

## src/middle_b89.asm

- `$89FC8F`: CopyWords

## src/logic_b89.asm

- `$89FD6A`: EvadePC, asswingd, unusedFF89

## src/gfx/sprites_b8A.asm

- `$8A8000`: SpriteSet12

## src/gfx/graphics_b8A.asm

- `$8AF880`: PlayoffBracketMap

## src/teamdata_b8A.asm

- `$8AFAA8`: Credits

## src/logic_b8A.asm

- `$8AFD0C`: lineinput, getlchoice

## src/penalty_b8A.asm

- `$8AFE21`: SetScore, unusedFF8A

## src/hockey_b8B.asm

- `$8B8000`: NewPO, FigureJoy, Opening, Opening4, ReadPassBits, ResolveGames

## src/gfx/sprites_b8B.asm

- `$8B83EE`: SpriteSet5

## src/middle_b8B.asm

- `$8BFCCE`: printbig

## src/logic_b8B.asm

- `$8BFE47`: asswingo
- `$8BFFD3`: skatetopuckinit

## src/video_b8B.asm

- `$8BFFCC`: showref

## src/gfx/graphics_b8C.asm

- `$8C8000`: NHLPALogo

## src/gfx/sprites_b8C.asm

- `$8C845A`: SpriteSet0

## src/video_b8C.asm

- `$8CFC1A`: checksso

## src/logic_b8C.asm

- `$8CFD83`: chk4pass, unusedFF8C

## src/hockey_b8D.asm

- `$8D8000`: maketree
- `$8D8217`: StartPer
- `$8D8389`: Bcheck, NewPO93
- `$8D84E2`: DrawTeamBlocks
- `$8D85A9`: PeriodOver, GetPlayerName
- `$8D86A8`: asstab
- `$8D87FB`: setd0player

## src/video_b8D.asm

- `$8D8120`: InitPPU

## src/penalty_b8D.asm

- `$8D82F0`: GetLowestPen
- `$8D8549`: EASNLogo
- `$8DF888`: StartHL2

## src/middle_b8D.asm

- `$8D847C`: eraser
- `$8D871C`: mulu16

## src/sound_b8D.asm

- `$8D865A`: updatesound

## src/logic_b8D.asm

- `$8D87B0`: puckshadow
- `$8DFCC7`: asspenalty, clrplayer, avdgoal, unused008D

## src/gfx/sprites_b8D.asm

- `$8D883C`: SpriteSet10

## src/gfx/graphics_b8D.asm

- `$8DEEC8`: BigFontTiles

## src/hockey_b8E.asm

- `$8E8000`: Gameloop, PlayerShortName

## src/logic_b8E.asm

- `$8E826B`: assbench
- `$8EFE73`: assdefo, unused008E

## src/gfx/sprites_b8E.asm

- `$8E83EB`: SpriteSet3, SpriteSet14

## src/gfx/graphics_b8F.asm

- `$8F8000`: BigFontMap, unusedEnergyBar
- `$8F824D`: EASNLogoMap, BigFontIndex
- `$8FE154`: PixelRemap8F
- `$8FE67D`: FrameSetTable
- `$8FF4B8`: PixelRemapFramer, PixelRemapFont

## src/hockey_b8F.asm

- `$8F8213`: linelist, PerLabels
- `$8F8B11`: clockcont, clockcont_0
- `$8F8E03`: startpause1, PauseExit, suba4, adda4
- `$8F9073`: ResetPassWord
- `$8FD5BF`: holdcheck
- `$8FDA75`: InitScoutDisplay
- `$8FDBDB`: box, UpdateCwdExcite
- `$8FDC0D`: ScoutingReport, ScoutCompare, ScoutLabels, PuckcSpots
- `$8FE32B`: DefaultMenus, checkagr
- `$8FE825`: TeamRoster, RosterGoalies, RosterG, RosterLineNames
- `$8FECAB`: Pmenu, GetPadTeam, setpde, setoptions
- `$8FF741`: CheckInjury, setInjuryType, sublist, priolist, ShowInjuryBox
- `$8FFB2B`: GetPlayerNumInitial
- `$8FFDFB`: cd0
- `$8FFEB4`: ShowGoalBox, GoalBoxText, unusedFF8F

## src/video_b8F.asm

- `$8F82A4`: showclock
- `$8F87C0`: KillCrowd
- `$8F8ABC`: showzam
- `$8F8EF7`: QueueTextDMA, QueueBackmapDMA, ShowRinkRows
- `$8FDAF3`: addframe_full
- `$8FE04C`: ClearSprites, RemapTiles
- `$8FEC68`: addframe

## src/logic_b8F.asm

- `$8F833F`: asseben
- `$8F8C4B`: assdopen
- `$8F8DC7`: lcfound
- `$8FD4F9`: fightinput
- `$8FD75A`: assnothing, GoalieCount
- `$8FDA8F`: assstanley
- `$8FDB1B`: asscenterd
- `$8FE164`: playeracc, dirtab8F
- `$8FE3B0`: WeightedRandomSelect
- `$8FE43C`: passmode, dopass
- `$8FE6BD`: CompLine
- `$8FF4D8`: UnpackNibbles
- `$8FF603`: Findhittype
- `$8FF8C4`: passtoa0
- `$8FFB5B`: Acheck
- `$8FFBDC`: doplayeracc, ResetAndSelectPlayers

## src/penalty_b8F.asm

- `$8F83A7`: PushRef, SetHor, USBoard, pplpen
- `$8F86B6`: Intermission, InitTicker, StatsScreen, IntermissionTick, TickerNext
- `$8F8858`: NewTicker, NewTicker2, NewTicker3, TickerTeam, GameLabels
- `$8F8C1B`: DoHiLights
- `$8F8C72`: updatepentime, linebar
- `$8F902A`: InitScores
- `$8FD68C`: PrintStringFromList
- `$8FD793`: AdvanceStringPtr, AttribMenuSkater, AttribMenuGoalie, PositionNames, releasepl
- `$8FDAFC`: RemovePlayerFromList
- `$8FDBF9`: loadTeamStruct
- `$8FE00A`: SetupTeamForIntermission
- `$8FE2F9`: ClearPenaltyBuffer
- `$8FF58D`: StatsReport
- `$8FF63D`: prefmes

## src/middle_b8F.asm

- `$8F8682`: pushnumber
- `$8F87C9`: appstring, PushTime
- `$8F8AE9`: waitxsr
- `$8F901A`: jdtab8F
- `$8FD69F`: Framer
- `$8FE316`: randomd0sd0
- `$8FE404`: forceblack
- `$8FF54E`: PushNumberWidth
- `$8FFB8B`: divs16

## src/gfx/sprites_b8F.asm

- `$8F9085`: SpriteSet1

## src/stats_b8F.asm

- `$8FFAF3`: GetPlayerCount

## src/sound_b8F.asm

- `$8FFE7B`: MusicCue, sfx8F
