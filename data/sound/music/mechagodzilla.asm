_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $18
			CSF_HeaderTempo $9e
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $9e
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop4:
_pulse1:
			CSF_SetLoopCount $03
_pulse1_loop1:
			.byte NA2
			.byte cDelay($05), $00, NE3, $00
			.byte NA2, NF3, $00, NA2
			.byte $00, NG3, $00, NA2
			.byte $00, NA3, $00
			CSF_Cmd9C _pulse1_cmd9c_1, $03
			CSF_Loop _pulse1_loop1

			.byte NE2
			.byte cDelay($0a), NG2, NA2
			.byte cDelay($08), NC3, NE3, NG3
			.byte NB3, $00
			.byte cDelay($0b), $00
			.byte cDelay($0a), $00
			.byte cDelay($0e)
			CSF_SetLoopCount $01
_pulse1_loop3:
			.byte NA3
			.byte cDelay($05), NC4, NB3, ND4
			.byte cDelay($08), NC4
			CSF_Loop _pulse1_loop2

			.byte NB3, NA3, NG3, NE3
			CSF_Jump _pulse1_loop3
_pulse1_loop2:
			.byte NE4, ND4, NF4, NE4
			CSF_Jump _pulse1_loop4

_pulse2_loop3:
_pulse2:
			CSF_SetLoopCount $03
_pulse2_loop1:
			.byte NA3
			.byte cDelay($05), NE3, NE4, NE3
			.byte NA3, NE4, NE3, NA3
			.byte NG3, NF4, NG3, NA3
			.byte NA3, NA2, NA3
			CSF_Cmd9C _pulse2_cmd9c_1, $03
			CSF_Loop _pulse2_loop1

			.byte NB3
			.byte cDelay($0a), NG3, NE3
			.byte cDelay($08), NC3, NA2, NG2
			.byte NE2
			CSF_SetLoopCount $03
_pulse2_loop2:
			.byte NA2
			.byte cDelay($08), NC3, NB2
			.byte cDelay($05), NC3
			.byte cDelay($08), ND3, NC3, NB2
			.byte NG2
			CSF_Loop _pulse2_loop2

			CSF_Jump _pulse2_loop3

_triangle:
_triangle_loop3:
			CSF_SetLoopCount $03
_triangle_loop1:
			.byte NA1
			.byte cDelay($08), NE2, NA1
			.byte cDelay($05), NF2
			.byte cDelay($08), NA1, NG2, NA1
			.byte NA2
			CSF_Cmd9C _triangle_cmd9c_1, $03
			CSF_Loop _triangle_loop1

			.byte $14, $14
			.byte cDelay($05), NG1
			.byte cDelay($08), NG1
			.byte cDelay($05), NA1
			.byte cDelay($08), NC2, NE2, NG1
			.byte NB1
			CSF_SetLoopCount $03
_triangle_loop2:
			.byte NA1
			.byte cDelay($08), NC2, NB1
			.byte cDelay($05), NC2
			.byte cDelay($08), ND2, NC2, NB1
			.byte NG1
			CSF_Loop _triangle_loop2

			CSF_Jump _triangle_loop3

_noise:
_noise_loop2:
			CSF_SetLoopCount $03
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c0, $c1, $c1
			.byte $c1, $c0, $c1, $c1
			.byte $c1, $c0, $c1
			CSF_Loop _noise_loop1

			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $00
			.byte cDelay($0b), $00
			.byte cDelay($0a), $00
			.byte cDelay($0e), $00
			.byte cDelay($0b), $00
			.byte cDelay($0a), $00
			.byte cDelay($0e), $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c0, $c1, $c1
			.byte $c1, $c0, $c1, $c0
			.byte $c1, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Jump _noise_loop2
_pulse1_cmd9c_1:
			.byte cDelay($1b)
			.byte cDelay($1e), $07
_pulse2_cmd9c_1:
			.byte cDelay($1b)
			.byte cDelay($1e), $07
_triangle_cmd9c_1:
			.byte cDelay($1b)
			.byte cDelay($1e), $07