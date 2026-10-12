; NHLPA Hockey '93 (SNES) - top level: hardware registers, macros, RAM names, then the module files (docs/file_map.md).
; LoROM + FastROM (map mode $30), 4 Mbit, 16 banks mapped at $80-$8F.
asar 1.91
lorom
check bankcross off
incsrc "inc/snes_regs.asm"
incsrc "macros/snes93.mac"
incsrc "ram93snes.asm"
incsrc "banks/b81_sfx.asm"
incsrc "banks/b82_sfx_rink.asm"
incsrc "banks/b83_teams.asm"
incsrc "banks/b84_scouting.asm"
incsrc "banks/b85_title_gfx.asm"
incsrc "banks/b86_sound_driver.asm"
incsrc "banks/b87_player_sprites.asm"
incsrc "banks/b88_title_playoffs.asm"
incsrc "banks/b89_replay_music.asm"
incsrc "banks/b8A_playoffbracket_credits.asm"
incsrc "banks/b8B_opening.asm"
incsrc "banks/b8C_skate_sprites.asm"
incsrc "banks/b8D_fonts.asm"
incsrc "banks/b8E_gameloop.asm"
incsrc "banks/b8F_frontend.asm"
; Module files (source file names, one per module per bank). Every block has its own org, so this order
; does not move any byte; it follows the ROM address of each file's first block.
incsrc "main.asm"
incsrc "video_b80.asm"
incsrc "logic_b80.asm"
incsrc "middle_b80.asm"
incsrc "hockey_b80.asm"
incsrc "penalty_b80.asm"
incsrc "gfx/graphics_b80.asm"
