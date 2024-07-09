_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $08
			CSF_HeaderTempo $66
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0d
			CSF_HeaderInitVoice $03
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $08
			CSF_HeaderTempo $66
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $08
			CSF_HeaderTempo $66
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop1:
_pulse1:
			.byte NB3
			.byte cDelay($0a), NC4
			.byte cDelay($05), NA3S, $00, NB3
			.byte cDelay($0a), ND4
			.byte cDelay($05), NC4, $00, NB3
			.byte cDelay($0a), NA3S
			.byte cDelay($05), NG3, $00, NE3
			.byte cDelay($0d), NE4
			.byte cDelay($0a), ND4S
			.byte cDelay($05), NC4, $00, NB3
			.byte cDelay($0d), NB3
			.byte cDelay($0a), NG3
			.byte cDelay($05), NA3S, $00, NB3
			.byte cDelay($0d), NE3
			.byte cDelay($0a), NG3
			.byte cDelay($05), NE3, $00, NA3S
			.byte cDelay($0b), NG3
			.byte cDelay($08), NE3, NG3, NA3S
			.byte NB3
			.byte cDelay($0d)
			CSF_Jump _pulse1_loop1

_pulse2:
_pulse2_loop11:
			CSF_SetLoopCount $09
_pulse2_loop1:
			.byte NE4
			.byte cDelay($03), NG4, NA4, NG4
			CSF_Loop _pulse2_loop1

			CSF_SetLoopCount $03
_pulse2_loop2:
			.byte NB3
			.byte cDelay($03), ND4S, NF4S, ND4S
			CSF_Loop _pulse2_loop2

			CSF_SetLoopCount $03
_pulse2_loop3:
			.byte NE4
			.byte cDelay($03), NG4, NA4, NG4
			CSF_Loop _pulse2_loop3

			CSF_SetLoopCount $03
_pulse2_loop4:
			.byte NG4
			.byte cDelay($03), NB4, NC5, NB4
			CSF_Loop _pulse2_loop4

			CSF_SetLoopCount $03
_pulse2_loop5:
			.byte NE4
			.byte cDelay($03), NG4, NA4, NG4
			CSF_Loop _pulse2_loop5

			CSF_SetLoopCount $03
_pulse2_loop6:
			.byte NB3
			.byte cDelay($03), ND4S, NF4S, ND4S
			CSF_Loop _pulse2_loop6

			CSF_SetLoopCount $03
_pulse2_loop7:
			.byte NA3
			.byte cDelay($03), NC4, NE4, NC4
			CSF_Loop _pulse2_loop7

			CSF_SetLoopCount $03
_pulse2_loop8:
			.byte NC4
			.byte cDelay($03), NE4, NG4, NE4
			CSF_Loop _pulse2_loop8

			CSF_SetLoopCount $03
_pulse2_loop9:
			.byte NE4
			.byte cDelay($03), NG4, NA4S, NG4
			CSF_Loop _pulse2_loop9

			CSF_SetLoopCount $03
_pulse2_loop10:
			.byte NG4
			.byte cDelay($03), NA4, NB4, NA4
			CSF_Loop _pulse2_loop10

			CSF_Jump _pulse2_loop11

_triangle:
_triangle_loop5:
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte NE2
			.byte cDelay($03), $00, $00, NA2
			.byte NA2, $00, NE2, $00
			.byte $00, NA2, $00, $00
			CSF_Loop _triangle_loop1

			.byte NG2, $00, $00, NC3
			.byte NC3, $00, NG2, $00
			.byte $00, NC3, $00, $00
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte NB1, $00, $00, NF2S
			.byte NF2S, $00, NB1, $00
			.byte $00, NF2S, $00, $00
			CSF_SetLoopCount $01
_triangle_loop4:
			.byte NE2
			.byte cDelay($03), $00, $00, NA2
			.byte NA2, $00, NE2, $00
			.byte $00, NA2, $00, $00
			CSF_Loop _triangle_loop3

			.byte NG2, $00, $00, NC3
			.byte NC3, $00, NG2, $00
			.byte $00, NC3, $00, $00
			CSF_Jump _triangle_loop4
_triangle_loop3:
			.byte NB1, $00, $00, NF2S
			.byte NF2S, $00, NB1, $00
			.byte $00, NF2S, $00, $00
			.byte NA1, $00, $00, NE2
			.byte NE2, $00, NA1, $00
			.byte $00, NE2, $00, $00
			.byte NC2, $00, $00, NG2
			.byte NG2, $00, NC2, $00
			.byte $00, NG2, $00, $00
			.byte NE2, $00, $00, NA2S
			.byte NA2S, $00, NE2, $00
			.byte $00, NA2S, $00, $00
			.byte NG2, $00, $00, NB2
			.byte NB2, $00, NG2, $00
			.byte $00, NB2, $00, $00
			CSF_Jump _triangle_loop5

_noise:
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c0, $c1, $c0, $c1
			.byte $c1, $c0, $c1, $c1
			CSF_Jump _noise_loop1