			CSF_HeaderStart _HeaderEnd

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3d, $42
			CSF_HeaderInitVoice $01
			CSF_HeaderPitch $1b
			CSF_HeaderTempo $5d
			CSF_HeaderTriangle _triangle

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $03
			CSF_HeaderTempo $5d
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0c
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $03
			CSF_HeaderTempo $5d
			CSF_HeaderPulse 2, _pulse2

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0c, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $5d
			CSF_HeaderNoise _noise

_HeaderEnd

_triangle_loop1:
_triangle:
			.byte $19
			.byte cDelay($0e), $18, $19, $1c
			.byte $19
			.byte cDelay($0b), $20, $1d, $24
			.byte $25, $20, $21, $1c
			CSF_Jump _triangle_loop1
_pulse1_loop1:
_pulse1:
			.byte $19
			.byte cDelay($05), $1c, $20, $25
			.byte $28, $25, $20, $1c
			.byte $1d, $20, $24, $29
			.byte $2c, $29, $24, $20
			.byte $19, $1c, $20, $25
			.byte $28, $25, $20, $1c
			.byte $15, $18, $1c, $21
			.byte $24, $21, $1c, $18
			CSF_Jump _pulse1_loop1
_pulse2:
			.byte $00
			.byte cDelay($07)
_pulse2_loop1:
			.byte $19
			.byte cDelay($05), $1c, $20, $25
			.byte $28, $25, $20, $1c
			.byte $1d, $20, $24, $29
			.byte $2c, $29, $24, $20
			.byte $19, $1c, $20, $25
			.byte $28, $25, $20, $1c
			.byte $15, $18, $1c, $21
			.byte $24, $21, $1c, $18
			CSF_Jump _pulse2_loop1
_noise_loop1:
_noise:
			.byte $c0
			.byte cDelay($04)
			CSF_Command $8a, $fb
			.byte $c0, $c0
			CSF_Command $8a, $05
			.byte $c0, $00, $c0, $c0
			.byte cDelay($08), $c0
			.byte cDelay($04)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Jump _noise_loop1