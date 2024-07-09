_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0d
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $66
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop3:
_pulse1:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NA3
			.byte cDelay($03), NG3S, NF3S
			.byte cDelay($08), NA3
			.byte cDelay($03), NG3S, NF3S
			.byte cDelay($05), NA3
			.byte cDelay($03), NG3S, NF3S, NG3S
			.byte NA3, NB3, NG3S
			.byte cDelay($0a), NC4S
			.byte cDelay($00), ND2, NA3
			.byte cDelay($03), NG3S, NF3S
			.byte cDelay($08), NA3
			.byte cDelay($03), NG3S, NF3S
			.byte cDelay($05), NA3
			.byte cDelay($03), NG3S, NF3S, NG3S
			.byte NA3, NB3, NG3S
			.byte cDelay($0a), NC3S
			.byte cDelay($00), ND2
			CSF_Loop _pulse1_loop1

			.byte NC4S
			.byte cDelay($08), ND4
			.byte cDelay($05), NB3
			.byte cDelay($08), NC4S
			.byte cDelay($0a), NB3
			.byte cDelay($08), NC4S
			.byte cDelay($05), NB3
			.byte cDelay($08), NE3
			.byte cDelay($0a), NC4S
			.byte cDelay($08), NB3
			.byte cDelay($05), NE4
			.byte cDelay($08), ND4, NC4S
			.byte cDelay($00), ND4
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte NE3
			.byte cDelay($08), ND3
			.byte cDelay($05), NC3
			.byte cDelay($08), NG3
			.byte cDelay($0a), NF3S
			.byte cDelay($08), NE3
			.byte cDelay($05), ND3
			.byte cDelay($08), NA3
			.byte cDelay($0a), NB3
			.byte cDelay($03), NC4S, NB3, NC4S
			.byte NB3
			.byte cDelay($0d)
			CSF_Jump _pulse1_loop3

_pulse2:
_pulse2_loop3:
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $00
			.byte cDelay($0e), $00
			.byte cDelay($08), NE3
			.byte cDelay($05), NF3S, NG3S, NA3
			.byte NG3S
			.byte cDelay($04), NF3S, NE3
			CSF_Loop _pulse2_loop1

			.byte NA3
			.byte cDelay($0a), NF3S
			.byte cDelay($00), ND2, NG3S
			.byte cDelay($0a), NC3S
			.byte cDelay($00), ND2, ND3
			.byte cDelay($05), NF3S, NA3, NC4S
			.byte ND3, NF3S, NA3, NF3S
			.byte NB3
			.byte cDelay($03), NC4S, ND4, NB3
			.byte NG3S, NA3, NB3, NG3S
			.byte NF3, NF3S, NG3S, NE3
			.byte NC3S, ND3S, NE3, NC3S
			CSF_SetLoopCount $02
_pulse2_loop2:
			.byte $00
			.byte cDelay($0e), $00
			.byte cDelay($08), NE3
			.byte cDelay($05), NF3S, NG3S, NA3
			.byte NG3S
			.byte cDelay($04), NF3S, NE3
			CSF_Loop _pulse2_loop2

			.byte NG2
			.byte cDelay($0a), NE2
			.byte cDelay($00), ND2, NA2
			.byte cDelay($0a), NF2S
			.byte cDelay($00), ND2, NE3
			.byte cDelay($0b), NG2S
			.byte cDelay($05), NB2, NE3, NG3S
			CSF_Jump _pulse2_loop3

_triangle_loop4:
_triangle:
			CSF_SetLoopCount $04
_triangle_loop1:
			.byte NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2, NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2, NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2, NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2
			CSF_Cmd9C _triangle_cmd9c_1, $04
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $03
_triangle_loop2:
			.byte ND2
			.byte cDelay($05), ND2, ND2, NA2
			.byte cDelay($08), ND2
			.byte cDelay($05), ND2, ND2
			CSF_Cmd9C _triangle_cmd9c_2, $03
			CSF_Loop _triangle_loop2

			.byte NC2S, NC2S, NC2S, NG2S
			.byte NC2S, NC2S, NC2S, NG2S
			CSF_SetLoopCount $04
_triangle_loop3:
			.byte NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2, NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2, NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2, NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($03), NE2
			CSF_Cmd9C _triangle_cmd9c_3, $04
			CSF_Loop _triangle_loop3

			.byte NC2
			.byte cDelay($05), NC2S, NC2S, NG1
			.byte NC2S, NC2S, NC2S, NG1S
			.byte ND2, ND2, ND2, NA1
			.byte ND2, ND2, ND2, NA1
			.byte NE2
			.byte cDelay($0b), NE2
			.byte cDelay($03), NE2, NE2
			.byte cDelay($05), NE2
			.byte cDelay($03), NE2, NE2
			.byte cDelay($05)
			CSF_Jump _triangle_loop4

_noise:
_noise_loop8:
			CSF_SetLoopCount $10
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			CSF_Loop _noise_loop1

			CSF_SetLoopCount $02
_noise_loop2:
			.byte $c0
			.byte cDelay($0a), $c0
			.byte cDelay($05), $c0
			.byte cDelay($0b)
			CSF_Loop _noise_loop2

			CSF_SetLoopCount $02, $77
_noise_loop4:
			CSF_SetLoopCount $04
_noise_loop3:
			.byte $c0
			.byte cDelay($03), $c0, $c1
			CSF_Loop _noise_loop3

			.byte $c0, $c0, $c0, $c0
			CSF_Loop _noise_loop4, $77

			CSF_SetLoopCount $10
_noise_loop5:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			CSF_Loop _noise_loop5

			CSF_SetLoopCount $02
_noise_loop6:
			.byte $c0
			.byte cDelay($0a), $c0
			.byte cDelay($05), $c0
			.byte cDelay($0b)
			CSF_Loop _noise_loop6

			CSF_SetLoopCount $04
_noise_loop7:
			.byte $c0
			.byte cDelay($05), $c1
			.byte cDelay($03)
			CSF_Loop _noise_loop7

			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop8
_triangle_cmd9c_1:
			.byte cDelay($1e), $02
			.byte cDelay($1e), $02
_triangle_cmd9c_2:
			.byte cDelay($1f), $01, $00
_triangle_cmd9c_3:
			.byte cDelay($1e), $02
			.byte cDelay($1e), $02