_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $f3
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0d
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $ff
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $17
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
_pulse1_loop3:
			.byte NE3
			.byte cDelay($00), ND3, NF3S
			.byte cDelay($05), NG3
			.byte cDelay($0b), ND4
			.byte cDelay($08), NC4S, NC4
			.byte cDelay($0e), NG4
			.byte cDelay($0d), $00
			.byte cDelay($08), ND3S
			.byte cDelay($00), ND3, NF3
			.byte cDelay($05), NF3S
			.byte cDelay($0b), NC4S
			.byte cDelay($08), NC4, NB3
			.byte cDelay($0e), NF3S
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NG3
			.byte cDelay($05), NF3S, NE3
			.byte cDelay($08), NG3
			.byte cDelay($05), NF3S, NE3
			.byte cDelay($08), NG3
			.byte cDelay($05), NF3S, NG3, NA3
			.byte cDelay($08), NG3
			.byte cDelay($05), NF3S, NE3
			CSF_Loop _pulse1_loop1

			.byte NA3, NG3, NF3S
			.byte cDelay($08), NA3
			.byte cDelay($05), NG3, NF3S
			.byte cDelay($08), NA3
			.byte cDelay($05), NG3, NA3, NB3
			.byte cDelay($08), NA3
			.byte cDelay($05), NG3, NF3S
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte NF3S, NG3, NA3, NB3
			.byte NC4, ND4, NE4, NF4S
			.byte NG4
			.byte cDelay($0b), NF4S
			CSF_Jump _pulse1_loop3

_pulse2_loop3:
_pulse2:
			CSF_SetLoopCount $08
_pulse2_loop1:
			.byte NE2
			.byte cDelay($03), NE2, NE3, NE2
			.byte NE2, NE3, NE2, NE2
			.byte NE3, NE2, NE2, NE3
			.byte NE2, NE3, NE2, NE2
			CSF_Cmd9C _pulse2_cmd9c_1, $08
			CSF_Loop _pulse2_loop1

			CSF_SetLoopCount $08
_pulse2_loop2:
			.byte NE2
			.byte cDelay($03), NE3, NE2, NE3
			.byte NE2, NE3, NE2, NE3
			.byte NE2, NE3, NE2, NE3
			.byte NE2, NE3, NE2, NE3
			CSF_Cmd9C _pulse2_cmd9c_2, $08
			CSF_Loop _pulse2_loop2

			CSF_Jump _pulse2_loop3

_triangle:
_triangle_loop5:
			CSF_SetLoopCount $04
_triangle_loop1:
			.byte NG1
			.byte cDelay($05), $16, $14, $14
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $04
_triangle_loop2:
			.byte $14
			.byte cDelay($05), $12, NC1, NC1
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $08
_triangle_loop3:
			.byte $16
			.byte cDelay($05), $15, $13, $13
			CSF_Cmd9C _triangle_cmd9c_1, $08
			CSF_Loop _triangle_loop3

			CSF_SetLoopCount $08
_triangle_loop4:
			.byte $14
			.byte cDelay($05), $14, $14, $14
			.byte $14, $14, $14, $14
			CSF_Cmd9C _triangle_cmd9c_2, $08
			CSF_Loop _triangle_loop4

			CSF_Jump _triangle_loop5

_noise:
_noise_loop1:
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			.byte cDelay($03)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			.byte cDelay($03)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			.byte cDelay($05)
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Jump _noise_loop1
_pulse2_cmd9c_1:
			.byte $00
			.byte cDelay($1c), $00, $03, $00
			.byte cDelay($1c), $00, $05
_pulse2_cmd9c_2:
			.byte $00, $02, $00
			.byte cDelay($1e), $00, $02, $00
			.byte cDelay($1e)
_triangle_cmd9c_1:
			.byte $00, $00, $00
			.byte cDelay($1c), $00, $00, $00
			.byte $04
_triangle_cmd9c_2:
			.byte $00, $02, $00
			.byte cDelay($1e), $00, $02, $00
			.byte cDelay($1e)