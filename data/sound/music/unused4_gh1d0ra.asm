_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0f
			CSF_HeaderTempo $aa
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $03
			CSF_HeaderTempo $aa
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $0f
			CSF_HeaderTempo $aa
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $00
			CSF_HeaderTempo $aa
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop3:
_pulse1:
			CSF_SetLoopCount $03
_pulse1_loop1:
			.byte NA2
			.byte cDelay($07), NC3
			.byte cDelay($03), $00, NA2, $00
			.byte cDelay($07), NA2, NC3
			.byte cDelay($03), $00, NA2, $00
			.byte cDelay($07), NA2, NC3
			.byte cDelay($03), $00, NA2
			CSF_Cmd9C _pulse1_cmd9c_1, $03
			CSF_Loop _pulse1_loop1

			CSF_SetLoopCount $02
_pulse1_loop2:
			.byte NC4S
			.byte cDelay($04), NC4, NB3, NA3S
			.byte NA3, NG3S, NG3, NF3S
			.byte NF3, NE3, ND3S, ND3
			.byte NC3S, NC3, NB2, NA2S
			.byte NA2, NG2S
			CSF_Cmd9C _pulse1_cmd9c_2, $02
			CSF_Loop _pulse1_loop2

			.byte NC3S
			.byte cDelay($00), NG5S
			CSF_Jump _pulse1_loop3

_pulse2_loop3:
_pulse2:
			CSF_SetLoopCount $03
_pulse2_loop1:
			.byte NA2
			.byte cDelay($07), NC3
			.byte cDelay($03), $00, NA2, $00
			.byte cDelay($07), NA2, NC3
			.byte cDelay($03), $00, NA2, $00
			.byte cDelay($07), NA2, NC3
			.byte cDelay($03), $00, NA2
			CSF_Cmd9C _pulse2_cmd9c_1, $03
			CSF_Loop _pulse2_loop1

			.byte $00
			.byte cDelay($00), NG2S
			CSF_SetLoopCount $02
_pulse2_loop2:
			.byte NC4S
			.byte cDelay($04), NC4, NB3, NA3S
			.byte NA3, NG3S, NG3, NF3S
			.byte NF3, NE3, ND3S, ND3
			.byte NC3S, NC3, NB2, NA2S
			.byte NA2, NG2S
			CSF_Cmd9C _pulse2_cmd9c_2, $02
			CSF_Loop _pulse2_loop2

			.byte NF2
			.byte cDelay($04), NE2, ND2S, ND2
			.byte NC2S, NC2, NB1, NB1
			.byte NA1S
			CSF_Jump _pulse2_loop3

_triangle_loop2:
_triangle:
			.byte NA1
			.byte cDelay($04), NA1, NC2, NA1
			.byte ND2S, NA1, NA1, NA1
			.byte NC2, NA1, ND2S, NA1
			.byte NA1, NA1, NC2, NA1
			.byte ND2S, NA1, NC2, NC2
			.byte ND2S, NC2, NF2, NC2
			.byte NC2, NC2, ND2S, NC2
			.byte NF2, NC2, NC2, NC2
			.byte ND2S, NC2, NF2, NC2
			.byte ND2, ND2, NF2, ND2
			.byte NG2S, ND2, ND2, ND2
			.byte NF2, ND2, NG2S, ND2
			.byte ND2, ND2, NF2, ND2
			.byte NG2S, ND2
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte NE2
			.byte cDelay($04), NF2, NF2S, NG2
			.byte NG2S, NA2, NA2S, NB2
			.byte NC3, NC3S, ND3, ND3S
			.byte NE3, NF3, NF3S, NG3
			.byte NG3S, NA3
			CSF_Cmd9C _triangle_cmd9c_1, $02
			CSF_Loop _triangle_loop1

			.byte ND3, NC3S, NC3, NB2
			.byte NA2S, NA2, NG2S, NG2
			.byte NF2S, NF2, NE2, ND2S
			.byte ND2, NC2S, NC2, NB1
			.byte NA1S, NA1
			CSF_Jump _triangle_loop2

_noise:
_noise_loop4:
			CSF_SetLoopCount $0c
_noise_loop1:
			.byte $c0
			.byte cDelay($07), $c1
			.byte cDelay($03), $c1, $c1
			CSF_Loop _noise_loop1

			CSF_SetLoopCount $05
_noise_loop2:
			.byte $c0
			.byte cDelay($04), $c0, $c1
			CSF_Loop _noise_loop2

			.byte $c0, $c0, $c0
			CSF_SetLoopCount $05
_noise_loop3:
			.byte $c0
			.byte cDelay($04), $c0, $c1
			CSF_Loop _noise_loop3

			.byte $c0, $c0, $c0, $c0
			.byte cDelay($07), $c1, $c0, $c1
			.byte $c0, $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0
			.byte cDelay($05)
			CSF_Jump _noise_loop4
_pulse1_cmd9c_1:
			.byte $03, $02
			.byte cDelay($1b)
_pulse1_cmd9c_2:
			.byte cDelay($1c), $04
_pulse2_cmd9c_1:
			.byte $03, $02
			.byte cDelay($1b)
_pulse2_cmd9c_2:
			.byte cDelay($1c), $04
_triangle_cmd9c_1:
			.byte $04
			.byte cDelay($1c)