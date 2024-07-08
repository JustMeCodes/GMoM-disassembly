			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0c
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $15
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1_loop1:
_pulse1:
			.byte $2c
			.byte cDelay($05), $28, $25, $28
			.byte $2c, $25, $2b, $27
			.byte $25, $27, $2b, $25
			.byte $2a, $26, $25, $26
			.byte $2a, $25, $27, $24
			.byte $20, $24, $27, $24
			.byte $28, $25, $20, $25
			.byte $28, $25, $2a, $27
			.byte $20, $27, $2a, $27
			.byte $28, $25, $20, $25
			.byte $28, $25
			CSF_Jump _pulse1_loop1
_pulse2:
			.byte $00
			.byte cDelay($07)
_pulse2_loop1:
			.byte $2c
			.byte cDelay($05), $28, $25, $28
			.byte $2c, $25, $2b, $27
			.byte $25, $27, $2b, $25
			.byte $2a, $26, $25, $26
			.byte $2a, $25, $27, $24
			.byte $20, $24, $27, $24
			.byte $28, $25, $20, $25
			.byte $28, $25, $2a, $27
			.byte $20, $27, $2a, $27
			.byte $28, $25, $20, $25
			.byte $28, $25
			CSF_Jump _pulse2_loop1
_triangle_loop2:
_triangle:
			CSF_SetLoopCount $07
_triangle_loop1:
			.byte $19
			.byte cDelay($05), $19, $19, $19
			.byte $19, $19
			.byte $9c ; Unknown command
			.byte $07, $7e, $ba
			CSF_Loop _triangle_loop1
			CSF_Jump _triangle_loop2
_noise:
_noise_loop1:
			CSF_Command $8a, $fb
			.byte $c0
			.byte cDelay($03), $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			CSF_Jump _noise_loop1