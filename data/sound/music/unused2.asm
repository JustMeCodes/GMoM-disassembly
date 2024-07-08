			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			.byte $00
			.byte cDelay($08), $29
			.byte cDelay($05), $2a, $29
			.byte cDelay($0b), $2e
			.byte cDelay($05), $00, $41, $42
			.byte $41
			.byte cDelay($0d)
			CSF_Stop 
_pulse2:
			.byte $00
			.byte cDelay($08), $35
			.byte cDelay($03), $29, $2e, $29
			.byte $35, $29, $2e, $3a
			.byte $35, $29, $2e, $29
			CSF_Command $8a, $00
			.byte $3a, $3b, $3c, $3d
			.byte $3e, $3f, $40
			CSF_SetVoice $04
			.byte $41
			.byte cDelay($0d)
			CSF_Stop 
_triangle:
			.byte $00
			.byte cDelay($08), $16
			.byte cDelay($05), $1d, $16, $1d
			.byte $16, $1d, $16, $1d
			.byte $16, $1d, $22
			.byte cDelay($0d)
			CSF_Stop 
_noise:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $fd
			.byte $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $03
			.byte $c0
			CSF_Command $8a, $fd
			.byte $c0, $c0, $c0
			CSF_Command $8a, $03
			.byte $c0
			CSF_Command $8a, $fd
			.byte $c0
			CSF_Command $8a, $03
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0
			CSF_Stop