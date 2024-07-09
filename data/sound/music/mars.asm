_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0f
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $37, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0b, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NC3S
			.byte cDelay($0b), NF3S
			.byte cDelay($0a), NG3S
			.byte cDelay($03), NC4S, NG3S
			.byte cDelay($0d), $00
			.byte cDelay($05), NF3S
			.byte cDelay($03), NG3S, NA3
			.byte cDelay($08), $00
			.byte cDelay($05), NG3S
			.byte cDelay($03), NF3S, NG3S
			.byte cDelay($08), NE3, NC3S
			.byte cDelay($0e), NC3S
			.byte cDelay($0b), NF3S
			.byte cDelay($0a), NG3S
			.byte cDelay($03), NA3, NC4S
			.byte cDelay($0e), NB3
			.byte cDelay($08), $00
			.byte cDelay($05), NA3
			.byte cDelay($03), NG3S, NF3S
			.byte cDelay($08), NE3, NF3S
			.byte cDelay($0e)
			CSF_Loop _pulse1_loop1

			.byte $00
			.byte cDelay($08), NF3S
			.byte cDelay($03), NA3, NF3S, NA3
			.byte NF3S
			.byte cDelay($0a), NC4S
			.byte cDelay($05), NB3
			.byte cDelay($0a), NG3S
			.byte cDelay($05), NE3
			.byte cDelay($0b), ND3
			.byte cDelay($0a), NC3S
			.byte cDelay($05), NB2
			.byte cDelay($08), NA2, NC3S
			.byte cDelay($0e), $00
			.byte cDelay($08), NF3S
			.byte cDelay($03), NA3, NF3S, NA3
			.byte NF3S
			.byte cDelay($0a), NC4S
			.byte cDelay($05), NB3
			.byte cDelay($0a), NC4S
			.byte cDelay($05), ND4
			.byte cDelay($0b), ND4
			.byte cDelay($08), NC4, NF4, ND4S
			.byte ND4
			.byte cDelay($0b), NC4
			CSF_Command $89, $01 ; Undocumented command
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			CSF_Command $89, $ff ; Undocumented command
			CSF_Jump _pulse1_loop3

_pulse2_loop3:
_pulse2:
			CSF_SetLoopCount $01
_pulse2_loop2:
			.byte NF3S
			.byte cDelay($03), NG3S, NC4S, NG3S
			.byte NC4S
			.byte cDelay($0d), NF3S
			.byte cDelay($03), NG3S, NC4S, NG3S
			.byte NC4S
			.byte cDelay($0d), ND3
			.byte cDelay($03), NE3, NA3, NE3
			.byte NA3
			.byte cDelay($08), NC3S
			.byte cDelay($03), NF3S, NG3S, NF3S
			.byte NC4S
			.byte cDelay($08), NC3S
			.byte cDelay($03), NF3S, NG3S, NC3S
			.byte NF3S, NG3S, NC4S, NG3S
			.byte NG3S, NC4S, NF4S, NC4S
			.byte NF4S, NG4S, NC4S, NG3S
			.byte NF3S, NG3S, NC4S, NG3S
			.byte NC4S
			.byte cDelay($0d), ND3
			.byte cDelay($03), NE3, NA3, NE3
			.byte NA3
			.byte cDelay($0d), NC3S
			.byte cDelay($03), NF3S, NG3S, NC3S
			.byte NF3S, NG3S, NC4S, NG3S
			.byte NG3S, NC4S, NF4S, NC4S
			.byte NF4S, NG4S, NC4S, NG3S
			.byte NF3S, NG3S, NC4S, NG3S
			.byte NC4S, NG3S, NF3S, NG3S
			.byte NA3, NC4S, NG3S, NC4S
			.byte NF3S, NA3, NC3S, NA3
			CSF_Loop _pulse2_loop1

			.byte ND3, NA3, NG3S, NF3S
			.byte ND3, NA3, NG3S, NF3S
			.byte ND3, NA3, NG3S, NF3S
			.byte ND3, NA3, NG3S, NF3S
			.byte NC3S, NG3S, NF3S, NE3
			.byte NC3S, NG3S, NF3S, NE3
			.byte NC3S, NG3S, NF3S, NE3
			.byte NC3S, NG3S, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NF3S, NC3S, NG3S, NC3S
			.byte NC4S, NG3S, NF4S, NC4S
			.byte NC4S, NG3S, NC4S, NF3S
			.byte NG3S, NC3S, NF3S, NC3S
			.byte ND3, NA3, NG3S, NF3S
			.byte ND3, NA3, NG3S, NF3S
			.byte ND3, NA3, NG3S, NF3S
			.byte ND3, NA3, NG3S, NF3S
			.byte NB2, NG3, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NB2, NG3, NF3S, NE3
			.byte NA2S, NF3, ND3S, ND3
			.byte NA2S, NF3, ND3S, ND3
			.byte NA2S, NF3, ND3S, ND3
			.byte NA2S, NF3, ND3S, ND3
			.byte NA3, ND3, NE3, ND3
			.byte NA2, NE3, ND3, NE3
			.byte NA3, ND4, NE3, ND4
			.byte NA3, NE3, NF3S, ND3
			CSF_Command $89, $01 ; Undocumented command
			CSF_Jump _pulse2_loop2
_pulse2_loop1:
			CSF_Command $89, $ff ; Undocumented command
			CSF_Jump _pulse2_loop3

_triangle_loop3:
_triangle:
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte NF2S
			.byte cDelay($05), NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NE2
			.byte ND2, ND2, ND2, NA1
			.byte NC2S, NC2S, NC2S, NG1S
			.byte NF2S, NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NE2
			.byte ND2, ND2, ND2, NA1
			.byte ND2, ND2, ND2, NA1
			.byte NC2S, NC2S, NC2S, NG1S
			.byte ND2, ND2, ND2, NA1
			.byte NF2S, NF2S, NF2S, NC2S
			.byte NF2S, NF2S, NF2S, NE2
			CSF_Loop _triangle_loop1

			.byte ND2
			.byte cDelay($08), NA1, ND2, NA1
			.byte NC2S, NG1S, NC2S, NG1S
			.byte NG1, ND2, NG1, ND2
			.byte NC2S, NG1S, NC2S, NG1S
			.byte ND2, NA1, ND2, NA1
			.byte NG1, ND2, NG1, ND2
			.byte NA1S, $15, NA1S, $15
			.byte ND2, NA1, ND2, NA1
			CSF_Command $89, $01 ; Undocumented command
			CSF_Jump _triangle_loop2
_triangle_loop1:
			CSF_Command $89, $ff ; Undocumented command
			CSF_Jump _triangle_loop3

_noise:
_noise_loop5:
			CSF_SetLoopCount $08
_noise_loop1:
			.byte $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Loop _noise_loop1

			CSF_SetLoopCount $03
_noise_loop2:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c1
			CSF_Loop _noise_loop2

			.byte $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c1
			CSF_Loop _noise_loop3

			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($08), $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $08
_noise_loop4:
			.byte $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Loop _noise_loop4

			CSF_Jump _noise_loop5