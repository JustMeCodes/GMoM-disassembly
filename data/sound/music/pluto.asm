_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $05
			CSF_HeaderTempo $99
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0c
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $f9
			CSF_HeaderTempo $99
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $18
			CSF_HeaderTempo $99
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $99
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			.byte NC4S
			.byte cDelay($0a), NB3, NE4
			.byte cDelay($08)
_pulse1_loop3:
			.byte ND4
			.byte cDelay($0a), NC4S, NB3
			.byte cDelay($08), NB3
			.byte cDelay($0a), NC4S
			.byte cDelay($00), ND5, NF3S
			.byte cDelay($05), NG3S, NA3
			.byte cDelay($0e), NC4S
			.byte cDelay($0a), NB3, NG3S
			.byte cDelay($08), NA3
			.byte cDelay($0a), NG3S, NF3S
			.byte cDelay($08), NG3S
			.byte cDelay($0a), NE3, NC3S
			.byte cDelay($08)
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NE3
			.byte cDelay($05), NF3S
			.byte cDelay($08), NG3S, NA3
			.byte cDelay($0a), NB3
			.byte cDelay($08), NC4S, ND4, NE4
			.byte ND4
			.byte cDelay($0a), NC4S
			.byte cDelay($00), ND6, NB3
			.byte cDelay($05), NA3, NB3, NG3S
			.byte cDelay($00), ND6
			CSF_Loop _pulse1_loop1

			.byte NB3
			.byte cDelay($05), NA3, NB3, NC4S
			.byte cDelay($00), ND6
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte NF4S
			.byte cDelay($05), NE4, NF4S, NG4S
			.byte cDelay($00), ND6, NC4S
			.byte cDelay($08), NB3
			.byte cDelay($05), NC4S
			.byte cDelay($08), NB3
			.byte cDelay($05), ND4, NC4S, NE4
			.byte cDelay($08), ND4
			.byte cDelay($05), NE4
			.byte cDelay($08), ND4
			.byte cDelay($05), NF4S, NE4, NG4
			.byte cDelay($08), NF4S
			.byte cDelay($05), NG4
			.byte cDelay($08), NF4S
			.byte cDelay($05), NA4, NG4, NF4S
			.byte cDelay($0e), NC4S
			CSF_Jump _pulse1_loop3

_pulse2:
_pulse2_loop2:
			.byte NC4S
			.byte cDelay($0a), NB3, NE4
			.byte cDelay($08), ND4
			.byte cDelay($0a), NC4S, NB3
			.byte cDelay($08), NB3
			.byte cDelay($0a), NC4S
			.byte cDelay($00), ND5, NF3S
			.byte cDelay($05), NG3S, NA3
			.byte cDelay($0e), NC4S
			.byte cDelay($0a), NB3, NG3S
			.byte cDelay($08), NA3
			.byte cDelay($0a), NG3S, NF3S
			.byte cDelay($08), NG3S
			.byte cDelay($0a), NE3, NC3S
			.byte cDelay($08)
			CSF_SetLoopCount $02
_pulse2_loop1:
			CSF_Command $89, $00 ; Undocumented command
			.byte NE3
			.byte cDelay($05), NF3S
			.byte cDelay($08), NG3S, NA3
			.byte cDelay($0a), NB3
			.byte cDelay($08), NC4S, ND4, NE4
			CSF_Command $8a, $ff ; Undocumented command
			CSF_Command $89, $f4 ; Undocumented command
			.byte NA4
			.byte cDelay($0a), NG4, NF4S
			.byte cDelay($08), NE4
			.byte cDelay($0a), ND4, NC4S
			.byte cDelay($08), NB3
			.byte cDelay($0e), NE4
			.byte cDelay($0a), ND4, NC4S
			.byte cDelay($08), NA3
			.byte cDelay($0e), ND4
			.byte cDelay($0a), NC4S, NA3
			.byte cDelay($08)
			CSF_Command $8a, $01 ; Undocumented command
			CSF_Loop _pulse2_loop1

			CSF_Command $8a, $ff ; Undocumented command
			.byte NF3S
			.byte cDelay($0e)
			CSF_Command $8a, $01 ; Undocumented command
			CSF_Command $89, $05 ; Undocumented command
			.byte NE4
			.byte cDelay($08), ND4
			.byte cDelay($05), NE4
			.byte cDelay($08), ND4
			.byte cDelay($05), NF4S, NE4, NG4
			.byte cDelay($08), NF4S
			.byte cDelay($05), NG4
			.byte cDelay($08), NF4S
			.byte cDelay($05), NA4, NG4, NF4S
			.byte cDelay($0e)
			CSF_Jump _pulse2_loop2

_triangle_loop2:
_triangle:
			CSF_SetLoopCount $18
_triangle_loop1:
			.byte NF2S
			.byte cDelay($05), $16, NF2S, $16
			.byte NF2S, NF2S, $16, NF2S
			CSF_Cmd9C _triangle_cmd9c_1, $18
			CSF_Loop _triangle_loop1

			CSF_SetVoice $04
			.byte $16, $00, $14, $16
			.byte $00, $14, NG1, $16
			.byte NA1, $00, NG1, NA1
			.byte $00, NG1, NB1, NA1
			.byte NC2, $00, NB1, NC2
			.byte $00, NB1, ND2, NC2
			CSF_SetVoice $02
			.byte NE2, $14, NE2, $14
			.byte NE2, NE2, $14, NE2
			CSF_Jump _triangle_loop2

_noise:
_noise_loop3:
			CSF_SetLoopCount $03, $77
_noise_loop2:
			CSF_SetLoopCount $07
_noise_loop1:
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			.byte cDelay($03), $00, $c0, $00
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00, $c0, $00
			.byte $c0, $00
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Loop _noise_loop1

			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00, $c0, $00
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			CSF_Loop _noise_loop2, $77

			.byte $00
			.byte cDelay($0e), $00, $00, $c0
			.byte cDelay($03), $00, $c0, $00
			.byte $00, $00, $c0, $00
			.byte $c0, $00, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop3
_triangle_cmd9c_1:
			.byte cDelay($1e)
			.byte cDelay($1e)
			.byte cDelay($1f), $05
			.byte cDelay($1e)
			.byte cDelay($1e)
			.byte cDelay($1f)
			.byte cDelay($1e), $00, $02, $00
			.byte $03, $00
			.byte cDelay($1d), $00
			.byte cDelay($1e), $00, $02, $00
			.byte $03, $00
			.byte cDelay($1d), $00, $05