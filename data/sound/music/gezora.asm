_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $04
			CSF_HeaderTempo $73
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $07
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $04
			CSF_HeaderTempo $73
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $10
			CSF_HeaderTempo $73
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $73
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
_pulse1_loop1:
			.byte NE3
			.byte cDelay($0a), NC4, NB3
			.byte cDelay($08), NA3S
			.byte cDelay($0a), NB3, NG3
			.byte cDelay($08), ND3
			.byte cDelay($0a), NF3
			.byte cDelay($00), ND2, NA3
			.byte cDelay($0a), NF3, NC4
			.byte cDelay($08), NB3
			.byte cDelay($0a), NA3S, NG3
			.byte cDelay($08), NE3
			.byte cDelay($0a), NC3, NB2
			.byte cDelay($08), NF3S
			.byte cDelay($0a), NA3
			.byte cDelay($00), ND2, NC4
			.byte cDelay($0a), NB3
			.byte cDelay($00), ND2, NE3
			.byte cDelay($00), $c0
			CSF_Jump _pulse1_loop1

_pulse2:
			.byte $00
			.byte cDelay($04)
_pulse2_loop1:
			.byte NE3
			.byte cDelay($0a), NC4, NB3
			.byte cDelay($08), NA3S
			.byte cDelay($0a), NB3, NG3
			.byte cDelay($08), ND3
			.byte cDelay($0a), NF3
			.byte cDelay($00), ND2, NA3
			.byte cDelay($0a), NF3, NC4
			.byte cDelay($08), NB3
			.byte cDelay($0a), NA3S, NG3
			.byte cDelay($08), NE3
			.byte cDelay($0a), NC3, NB2
			.byte cDelay($08), NF3S
			.byte cDelay($0a), NA3
			.byte cDelay($00), ND2, NC4
			.byte cDelay($0a), NB3
			.byte cDelay($00), ND2, $00
			.byte cDelay($0e), $00, $00, $00
			CSF_Jump _pulse2_loop1

_triangle_loop6:
_triangle:
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte NE2
			.byte cDelay($03), NE2, NG2, NE2
			.byte NB2, NE2, NE2, NE2
			.byte NG2, NE2, NB2, NE2
			.byte NE2, NE2, NG2, NE2
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $02
_triangle_loop2:
			.byte ND2
			.byte cDelay($03), ND2, NF2, ND2
			.byte NA2, ND2, ND2, ND2
			.byte NF2, ND2, NA2, ND2
			.byte ND2, ND2, NF2, ND2
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $02
_triangle_loop3:
			.byte NE2
			.byte cDelay($03), NE2, NG2, NE2
			.byte NB2, NE2, NE2, NE2
			.byte NG2, NE2, NB2, NE2
			.byte NE2, NE2, NG2, NE2
			CSF_Loop _triangle_loop3

			CSF_SetLoopCount $02
_triangle_loop4:
			.byte NF2S
			.byte cDelay($03), NF2S, NA2, NF2S
			.byte NB2, NF2S, NF2S, NF2S
			.byte NA2, NF2S, NB2, NF2S
			.byte NF2S, NF2S, NA2, NF2S
			CSF_Loop _triangle_loop4

			CSF_SetLoopCount $04
_triangle_loop5:
			.byte NE2
			.byte cDelay($03), NE2, NG2, NE2
			.byte NA2, NE2, NE2, NE2
			.byte NG2, NE2, NA2, NE2
			.byte NE2, NE2, NG2, NE2
			CSF_Loop _triangle_loop5

			CSF_Jump _triangle_loop6

_noise:
_noise_loop3:
			CSF_SetLoopCount $07
_noise_loop1:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c1, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Loop _noise_loop1

			.byte $c0, $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c1
			.byte $c0, $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop2:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Loop _noise_loop2

			.byte $c0, $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c1
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop3