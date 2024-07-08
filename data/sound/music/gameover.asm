			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0a
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $09
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			.byte $35
			.byte cDelay($08), $2e, $31
			.byte cDelay($05), $35
			.byte cDelay($08), $3a
			.byte cDelay($05), $3d
			.byte cDelay($0b), $3c, $38
			.byte cDelay($08), $35, $31
			.byte cDelay($05), $35
			.byte cDelay($08), $38
			.byte cDelay($05), $33
			.byte cDelay($0b), $2e
			.byte cDelay($08), $2e
			.byte cDelay($05), $30, $31
			.byte cDelay($0b), $00
			.byte cDelay($05), $31, $33, $31
			.byte $35
			.byte cDelay($0a), $30
			.byte cDelay($05), $30
			.byte cDelay($08), $30
			CSF_Command $96, $7b
			.byte $2e
			.byte cDelay($0b), $31
			.byte cDelay($08), $33
			CSF_Command $96, $77
			.byte $30
			.byte cDelay($0b)
			CSF_Command $96, $6e
			.byte $2c
			CSF_Command $96, $66
			.byte $2e
			.byte cDelay($08), $29, $27, $29
			.byte $25
			.byte cDelay($0e)
			.byte $91 ; Unknown command
			.byte $01
			CSF_Stop 
_pulse2:
			.byte $00
			.byte cDelay($07), $35
			.byte cDelay($08), $2e, $31
			.byte cDelay($05), $35
			.byte cDelay($08), $3a
			.byte cDelay($05), $3d
			.byte cDelay($0b), $3c, $38
			.byte cDelay($08), $35, $31
			.byte cDelay($05), $35
			.byte cDelay($08), $38
			.byte cDelay($05), $33
			.byte cDelay($0b), $2e
			.byte cDelay($08), $2e
			.byte cDelay($05), $30, $31
			.byte cDelay($0b), $00
			.byte cDelay($05), $31, $33, $31
			.byte $35
			.byte cDelay($0a), $30
			.byte cDelay($05), $30
			.byte cDelay($08), $30
			CSF_Command $96, $7b
			.byte $2e
			.byte cDelay($0b), $31
			.byte cDelay($08), $33
			CSF_Command $96, $77
			.byte $30
			.byte cDelay($0b)
			CSF_Command $96, $6e
			.byte $2c
			CSF_Command $96, $66
			.byte $2e
			.byte cDelay($08), $29, $27, $29
			.byte $25
			.byte cDelay($0e)
			CSF_Stop 
_triangle:
			.byte $22
			.byte cDelay($0a), $22
			.byte cDelay($05), $22
			.byte cDelay($0a), $22
			.byte cDelay($05), $21
			.byte cDelay($0b), $21, $20, $20
			.byte $1f, $1f
			.byte cDelay($0a), $1f
			.byte cDelay($05), $1e
			.byte cDelay($0a), $1e
			.byte cDelay($05), $1e
			.byte cDelay($0b), $1d, $1d
			.byte cDelay($08), $1d
			CSF_Command $96, $7b
			.byte $1b
			.byte cDelay($0a), $1b
			.byte cDelay($05), $1b
			.byte cDelay($0b)
			CSF_Command $96, $77
			.byte $1d
			CSF_Command $96, $6e
			.byte $1d
			CSF_Command $96, $66
			CSF_SetVoice $09
			.byte $16
			.byte cDelay($00), $60
			CSF_Stop 
_noise:
			CSF_Command $8a, $fa
			CSF_SetLoopCount $06
_noise_loop1:
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $06
			.byte $c0
			CSF_Command $8a, $fa
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop1
			CSF_Command $96, $7b
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $06
			.byte $c0
			CSF_Command $8a, $fa
			.byte $c0, $c0, $c0
			CSF_Command $96, $77
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $96, $6e
			CSF_Command $8a, $06
			.byte $c0
			CSF_Command $8a, $fa
			.byte $c0, $c0, $c0
			CSF_Command $96, $66
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $06
			.byte $c0
			CSF_Command $8a, $fa
			.byte $c0, $c0, $c0
			CSF_Stop