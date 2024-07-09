_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $18
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0e, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop1:
_pulse1:
			.byte NC1
			.byte cDelay($05), NC3, NG3, NC4
			.byte NC1, NC3, NG3, NA3S
			.byte NC1, NC3, NF3, NG3S
			.byte NC1, NC3, ND3S, NG3
			.byte NC1, NC3, ND3, NF3
			.byte ND3S, ND3, NC3, NB2
			.byte NC3, NB2, NC3, ND3
			.byte ND3S, ND3, ND3S, NF3
			CSF_Jump _pulse1_loop1

_pulse2_loop1:
_pulse2:
			CSF_SetVoice $04
			CSF_Command $8a, $fe ; Undocumented command
			CSF_Command $83, $01 ; Undocumented command
			.byte $00
			.byte cDelay($07), NC1
			.byte cDelay($05), NC3, NG3, NC4
			.byte NC1, NC3, NG3, NA3S
			.byte NC1, NC3, NF3, NG3S
			.byte NC1, NC3, ND3S, NG3
			.byte NC1, NC3, ND3, NF3
			.byte ND3S, ND3, NC3, NB2
			.byte NC3, NB2, NC3, ND3
			.byte ND3S, ND3, ND3S
			.byte cDelay($03)
			CSF_SetVoice $01
			CSF_Command $83, $01 ; Undocumented command
			CSF_Nop
			CSF_Command $8a, $02 ; Undocumented command
			.byte ND3
			.byte cDelay($0b), ND3S, NB2, NC3
			.byte NF2S
			.byte cDelay($0e), NG2, ND3
			.byte cDelay($08), ND3S, NB2, NC3
			.byte NF2S
			.byte cDelay($05), NG2, ND2, NF2
			.byte NB1, ND2, NF2, NG2S
			.byte NB2, ND3, NF3, NG3S
			.byte NG3
			.byte cDelay($0e), $00
			.byte cDelay($0b)
			CSF_Jump _pulse2_loop1

_triangle_loop1:
_triangle:
			.byte NC1
			.byte cDelay($05), NC2, NC1, NC2
			.byte NC1, NC2, NC1, NC2
			CSF_Jump _triangle_loop1

_noise:
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1
			CSF_Jump _noise_loop1