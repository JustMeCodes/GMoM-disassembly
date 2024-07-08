			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0e, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			.byte $29
			.byte cDelay($08), $00
			.byte cDelay($04), $00, $2e, $33
			.byte $2e, $33, $35, $33
			.byte $35, $2e, $2e, $2e
			.byte $27, $27, $27, $29
			.byte $29, $29, $2e, $2e
			.byte $2e, $33
			.byte cDelay($05), $2c, $2e, $33
			.byte $2c, $2e, $33, $2c
			.byte $29
			.byte cDelay($04), $2e, $30
			.byte cDelay($00), $28
			CSF_Stop 
_triangle:
			.byte $00
			.byte cDelay($0e), $29
			.byte cDelay($08), $00
			.byte cDelay($04), $00, $2e, $33
			.byte $2e, $33, $35, $33
			.byte $35, $2e
			.byte cDelay($05), $27, $29, $2e
			.byte $27, $29, $2e, $27
			.byte $2e
			.byte cDelay($04), $30, $35
			.byte cDelay($00), $28
			.byte $91 ; Unknown command
			.byte $01
			CSF_Stop 
_pulse2:
			.byte $00
			.byte cDelay($05), $29
			.byte cDelay($08), $00
			.byte cDelay($04), $00, $2e, $33
			.byte $2e, $33, $35, $33
			.byte $35, $2e
			.byte cDelay($08), $27, $29, $2e
			.byte cDelay($05)
			CSF_Command $8a, $00
			.byte $29
			.byte cDelay($08), $00
			.byte cDelay($04), $00, $2e, $33
			.byte $2e, $33, $35, $33
			.byte $35, $3a, $3c, $41
			.byte cDelay($00), $28
			CSF_Stop 
_noise:
			.byte $00
			.byte cDelay($04), $00, $00, $00
			.byte $00, $00, $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0
			CSF_SetLoopCount $02
_noise_loop1:
			.byte $c0
			.byte cDelay($04), $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0
			CSF_Loop _noise_loop1
			CSF_Command $8a, $05
			.byte $c0
			.byte cDelay($02), $c0, $c0
			.byte cDelay($04), $c0
			CSF_Stop