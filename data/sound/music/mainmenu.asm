			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fb
			CSF_HeaderTempo $77
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $06
			CSF_HeaderPitch $18
			CSF_HeaderTempo $77
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			.byte $2c
			.byte cDelay($03), $2e, $2f, $31
			.byte cDelay($00), $63
			.byte $8b ; Unknown command
			.byte $2f
			.byte cDelay($00), $0c
			CSF_Stop 
_pulse2:
			.byte $89 ; Unknown command
			.byte $05, $2c
			.byte cDelay($03), $2e, $2f, $2c
			.byte cDelay($00), $0c, $2e
			.byte cDelay($07), $2f, $36
			.byte cDelay($00), $51
			CSF_Stop 
_triangle:
			.byte $14
			.byte cDelay($03), $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $14, $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $14, $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $14, $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $91 ; Unknown command
			.byte $01
			CSF_Stop 
_noise:
			.byte $8c ; Unknown command
			.byte $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $8c ; Unknown command
			.byte $c0
			.byte $8c ; Unknown command
			.byte $00, $c0, $c0, $c0
			.byte $00, $c0, $c0
			.byte $8c ; Unknown command
			.byte $c0
			.byte $8c ; Unknown command
			.byte $00, $c0, $c0, $c0
			.byte $00, $c0, $c0
			.byte $8c ; Unknown command
			.byte $c0
			.byte $8c ; Unknown command
			.byte $00, $c0, $c0, $c0
			.byte $00, $c0, $c0
			.byte $8c ; Unknown command
			.byte $c0, $00
			.byte $8c ; Unknown command
			.byte $c0, $c0, $00
			.byte cDelay($0e)
			CSF_Stop