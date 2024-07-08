			CSF_HeaderStart _HeaderEnd

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $01
			CSF_HeaderPitch $18
			CSF_HeaderTempo $8c
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0c
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $8c
			CSF_HeaderPulse 2, _pulse2

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $8c
			CSF_HeaderPulse 1, _pulse1

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $8c
			CSF_HeaderNoise _noise

_HeaderEnd

_triangle:
			.byte $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22, $20
			.byte $22, $24, $25, $27
			.byte $29
			.byte cDelay($00), $20
			CSF_Stop 
_pulse2:
			.byte $00
			.byte cDelay($03), $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22, $20
			.byte $22, $24, $25, $27
			.byte $29
			.byte cDelay($00), $20
			CSF_Stop 
_pulse1:
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte $19
			.byte cDelay($03), $25, $18, $24
			.byte $16, $22
			CSF_Command $8a, $fe
			.byte $16, $22
			CSF_Command $8a, $02
			CSF_Loop _pulse1_loop1
			CSF_Command $8a, $fe
			.byte $19, $25, $18, $24
			.byte $16, $22, $14, $20
			.byte $16, $22, $18, $24
			.byte $19, $25, $1b, $27
			.byte $29
			.byte cDelay($00), $20
			CSF_Stop 
_noise:
			CSF_SetLoopCount $04
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			CSF_Loop _noise_loop1
			CSF_SetLoopCount $04
_noise_loop2:
			.byte $c0
			.byte cDelay($03), $c0, $c1
			CSF_Loop _noise_loop2
			.byte $c0, $c0, $c0, $c0
			CSF_Stop