			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $88
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $09
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $88
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $18
			CSF_HeaderTempo $88
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0e, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $88
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			.byte $22
			.byte cDelay($08), $21
			.byte cDelay($05), $22, $24
			.byte cDelay($08), $22
			.byte cDelay($05), $24
			CSF_Command $96, $80
			.byte $25
			.byte cDelay($08), $24
			.byte cDelay($05), $25
			CSF_Command $96, $77
			.byte $27
			.byte cDelay($08), $25
			.byte cDelay($05), $27
			CSF_Command $96, $6e
			.byte $29, $00, $29
			.byte cDelay($0e)
			CSF_Stop 
_pulse2:
			.byte $3a
			.byte cDelay($03), $39, $38, $37
			.byte $36, $35, $34, $33
			.byte $38, $37, $36, $35
			.byte $34, $33, $32, $31
			CSF_Command $96, $80
			CSF_SetVoice $01
			.byte $83 ; Unknown command
			.byte $01
			CSF_Command $8a, $04
			.byte $2e
			.byte cDelay($08), $2d
			.byte cDelay($05), $2e
			CSF_Command $96, $77
			.byte $30
			.byte cDelay($08), $2e
			.byte cDelay($05), $30
			CSF_Command $96, $6e
			.byte $2d, $2b, $2d
			.byte cDelay($0e)
			CSF_Stop 
_triangle:
			.byte $16
			.byte cDelay($05), $16, $16, $16
			.byte $18, $18, $18, $18
			CSF_Command $96, $80
			.byte $19, $19, $19, $19
			CSF_Command $96, $77
			.byte $1b, $1b, $1b, $1b
			CSF_Command $96, $6e
			CSF_SetVoice $01
			.byte $1d, $00, $11
			.byte cDelay($0e)
			CSF_Stop 
_noise:
			.byte $c0
			.byte cDelay($03), $c0, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c1, $c1, $c1, $c1
			CSF_Command $96, $80
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Command $96, $77
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Command $96, $6e
			.byte $c0, $c0, $c0, $c0
			.byte $c0
			.byte cDelay($0e)
			CSF_Stop