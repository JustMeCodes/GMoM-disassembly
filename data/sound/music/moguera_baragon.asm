			CSF_HeaderStart _HeaderEnd

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

_HeaderEnd

_pulse1_loop1:
_pulse1:
			.byte $10
			.byte cDelay($05), $28, $2f, $34
			.byte $10, $28, $2f, $32
			.byte $10, $28, $2d, $30
			.byte $10, $28, $2b, $2f
			.byte $10, $28, $2a, $2d
			.byte $2b, $2a, $28, $27
			.byte $28, $27, $28, $2a
			.byte $2b, $2a, $2b, $2d
			CSF_Jump _pulse1_loop1
_pulse2:
_pulse2_loop1:
			CSF_SetVoice $04
			CSF_Command $8a, $fe
			.byte $83 ; Unknown command
			.byte $01, $00
			.byte cDelay($07), $10
			.byte cDelay($05), $28, $2f, $34
			.byte $10, $28, $2f, $32
			.byte $10, $28, $2d, $30
			.byte $10, $28, $2b, $2f
			.byte $10, $28, $2a, $2d
			.byte $2b, $2a, $28, $27
			.byte $28, $27, $28, $2a
			.byte $2b, $2a, $2b
			.byte cDelay($03)
			CSF_SetVoice $01
			.byte $83 ; Unknown command
			.byte $01
			.byte $8c ; Unknown command
			CSF_Command $8a, $02
			.byte $2a
			.byte cDelay($0b), $2b, $27, $28
			.byte $22
			.byte cDelay($0e), $23, $2a
			.byte cDelay($08), $2b, $27, $28
			.byte $22
			.byte cDelay($05), $23, $1e, $21
			.byte $1b, $1e, $21, $24
			.byte $27, $2a, $2d, $30
			.byte $2f
			.byte cDelay($0e), $00
			.byte cDelay($0b)
			CSF_Jump _pulse2_loop1
_triangle:
_triangle_loop1:
			.byte $10
			.byte cDelay($05), $1c, $10, $1c
			.byte $10, $1c, $10, $1c
			CSF_Jump _triangle_loop1
_noise_loop1:
_noise:
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