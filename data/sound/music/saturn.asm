_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $84
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0d
			CSF_HeaderInitVoice $03
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $84
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $84
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $84
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NC4S
			.byte cDelay($00), ND3, ND4S
			.byte cDelay($00), ND4, NE4
			.byte cDelay($00), ND3, ND4S
			CSF_Loop _pulse1_loop1

			.byte NC4S
			.byte cDelay($05), NB3, NC4S
			.byte cDelay($00), $60
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte NE4
			.byte cDelay($05), NF4S, NG4S
			.byte cDelay($00), $54, NE4
			.byte cDelay($05), NF4S, NG4S
			.byte cDelay($00), $60, NG4S
			.byte cDelay($00), ND2, NF4S
			.byte cDelay($05), NE4, NF4S
			.byte cDelay($00), ND4, NF4S
			.byte cDelay($00), ND2, NE4
			.byte cDelay($05), ND4S, NE4
			.byte cDelay($00), ND4, ND4
			.byte cDelay($06), NA3, NF3S, NA3
			.byte ND4, NE4, NF4S, ND4
			.byte NA3, ND4, NF4S, NA4
			.byte NG4S
			.byte cDelay($00), $60
			CSF_Jump _pulse1_loop3

_pulse2:
_pulse2_loop4:
			.byte NF3S
			.byte cDelay($05), NA3, NF3S, NA3
			.byte NF3S, NA3, NF3S, NA3
			.byte NG3S, NB3, NG3S, NB3
			.byte NG3S, NB3, NG3S, NB3
			.byte NA3, NC4S, NA3, NC4S
			.byte NA3, NC4S, NA3, NB3
			.byte NG3S, NB3, NG3S, NB3
			.byte NG3S, NB3, NA3, NG3S
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte NA3
			.byte cDelay($03), NC4S, NB3, ND4S
			.byte NC4S, NE4, ND4S, NF4S
			.byte NC4S, NE4, NB3, ND4S
			.byte NA3, NC4S, NG3S, NC4S
			CSF_Loop _pulse2_loop1

			.byte NF3S
			.byte cDelay($05), NA3, NF3S, NA3
			.byte NF3S, NA3, NF3S, NA3
			.byte NG3S, NB3, NG3S, NB3
			.byte NG3S, NB3, NG3S, NB3
			.byte NA3, NC4S, NA3, NC4S
			.byte NA3, NC4S, NA3, NC4S
			.byte NG3S, NB3, NG3S, NB3
			.byte NG3S, NB3, NC4S, ND4S
			CSF_SetLoopCount $04
_pulse2_loop2:
			.byte NA3
			.byte cDelay($03), NC4S, NB3, ND4S
			.byte NC4S, NE4, ND4S, NF4S
			.byte NC4S, NE4, NB3, ND4S
			.byte NA3, NC4S, NG3S, NB3
			CSF_Loop _pulse2_loop2

			.byte NC4S
			.byte cDelay($05), NE4, NC4S, NE4
			.byte NC4S, ND4S, NC4S, ND4S
			.byte NB3, ND4S, NB3, ND4S
			.byte NB3, ND4S, NB3, ND4S
			.byte NB3, ND4S, NB3, ND4S
			.byte NB3, NC4S, NB3, NC4S
			.byte NG3S, NC4S, NA3, NC4S
			.byte NG3S, NC4S, NA3, NC4S
			CSF_SetLoopCount $02
_pulse2_loop3:
			.byte ND3
			.byte cDelay($05), NA3, NF3S, ND4
			.byte NA3, ND3, NF3S, NA2
			CSF_Loop _pulse2_loop3

			.byte NF3S
			.byte cDelay($03), NG3S, NC4S
			.byte cDelay($08), NF3S
			.byte cDelay($03), NG3S, NC3S, NF3S
			.byte NG3S
			.byte cDelay($08), NC3S
			.byte cDelay($03), NF3S, NG3S, NC3S
			.byte NF3S, NG3S, NC3S, NF3S
			.byte NG3S, NC4S, NF3S, NG3S
			.byte NC4S, NF4S, NG3S, NC4S
			.byte NF4S, NG4S
			CSF_Jump _pulse2_loop4

_triangle:
_triangle_loop4:
			CSF_SetLoopCount $0e
_triangle_loop1:
			.byte NF2S
			.byte cDelay($05), NF2S, NC2S, NE2
			.byte NF2S, NC2S, ND2S, NE2
			CSF_Loop _triangle_loop1

			.byte NA2, NA2, NE2, NA2
			.byte NA2, NA2, NE2, NA2
			.byte NB2, NB2, NF2S, NB2
			.byte NB2, NF2S, NB2, NG2S
			.byte NG2S, NG2S, ND2S, NG2S
			.byte NG2S, ND2S, NG2S, NC2S
			.byte NC2S, NC2S, NG1S, NC2S
			.byte NC2S, NC2S, NG1S, NC2S
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte ND2
			.byte cDelay($05), ND2, NA1, ND2
			.byte ND2, ND2, NA1, ND2
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $02
_triangle_loop3:
			.byte NC3S
			.byte cDelay($03), NC3S, NG2S, NC3S
			.byte $00
			.byte cDelay($08), NC2S
			.byte cDelay($03), NC2S, NG1S, NC2S
			.byte $00
			.byte cDelay($08)
			CSF_Loop _triangle_loop3

			CSF_Jump _triangle_loop4

_noise:
_noise_loop4:
			CSF_SetLoopCount $02
_noise_loop1:
			.byte $00
			.byte cDelay($08), $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00, $c0
			.byte $c0, $c0, $00, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Loop _noise_loop1

			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00, $c0
			.byte $c0, $c0, $00, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $08
_noise_loop2:
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop2

			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00, $c0
			.byte $c0, $c0, $00, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $04
_noise_loop3:
			.byte $00
			.byte cDelay($08), $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Loop _noise_loop3

			CSF_Jump _noise_loop4