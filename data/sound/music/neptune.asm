			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $02
			CSF_HeaderPitch $03
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $03
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $41
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0f
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop1:
			.byte $2e
			.byte cDelay($08), $31, $30
			.byte cDelay($00), $48, $31
			.byte cDelay($08), $33, $2c, $2e
			.byte cDelay($00), $48, $2e
			.byte cDelay($08), $31, $30
			.byte cDelay($00), $48, $31
			.byte cDelay($08), $33, $36, $34
			.byte cDelay($00), $60, $2e
			.byte cDelay($00), $48, $31
			.byte cDelay($08), $33, $30
			.byte cDelay($0e), $2c, $2e
			.byte cDelay($00), $48, $31
			.byte cDelay($08), $33, $30
			.byte cDelay($00), $48, $00
			.byte cDelay($08), $2c
			.byte cDelay($05), $2e, $2f
			.byte cDelay($08), $2e, $2c, $2a
			.byte cDelay($05), $34
			.byte cDelay($00), $0c, $33, $31
			.byte cDelay($0a), $2f
			.byte cDelay($08), $2e
			.byte cDelay($0e), $27
			CSF_Jump _pulse1_loop1
_pulse2:
_pulse2_loop4:
			.byte $2b
			.byte cDelay($08), $2e, $2d
			.byte cDelay($00), $48, $2e
			.byte cDelay($08), $30, $29, $2b
			.byte cDelay($00), $48, $2b
			.byte cDelay($08), $2e, $2d
			.byte cDelay($00), $48, $2e
			.byte cDelay($08), $30, $31, $2d
			.byte cDelay($00), $60, $2a
			.byte cDelay($00), $48, $2e
			.byte cDelay($08), $30, $2c
			.byte cDelay($0e), $27, $2a
			.byte cDelay($00), $48, $2e
			.byte cDelay($08), $30, $2c
			.byte cDelay($00), $48, $00
			.byte cDelay($0b)
			CSF_Command $8a, $ff
			CSF_SetVoice $02
			CSF_SetLoopCount $08
_pulse2_loop1:
			.byte $36
			.byte cDelay($03), $2a, $2f, $2a
			CSF_Loop _pulse2_loop1
			CSF_SetLoopCount $08
_pulse2_loop2:
			.byte $27
			.byte cDelay($03), $27
			CSF_Loop _pulse2_loop2
			CSF_SetLoopCount $08
_pulse2_loop3:
			.byte $33
			.byte cDelay($03), $33
			CSF_Loop _pulse2_loop3
			CSF_Command $8a, $01
			CSF_SetVoice $01
			CSF_Jump _pulse2_loop4
_triangle:
_triangle_loop4:
			CSF_SetVoice $01
			CSF_Command $8a, $ff
			CSF_Command $9d, $02
			.byte $1b
			.byte cDelay($00), $60, $1b
			.byte cDelay($0b), $1b
			.byte cDelay($08), $1b
			.byte cDelay($00), $48, $1b
			.byte cDelay($00), $60, $1b
			.byte cDelay($0b), $1b
			.byte cDelay($08), $1b
			.byte cDelay($0b), $1b
			.byte cDelay($0a)
			CSF_Command $9d, $04
			.byte $1b
			.byte cDelay($05), $1b
			.byte cDelay($08), $1b, $00
			.byte cDelay($05), $1b, $1b, $1b
			CSF_SetVoice $02
			CSF_Command $8a, $01
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte $1b
			.byte cDelay($05), $1b, $1b, $1b
			.byte $1b, $1b, $1b, $1b
			.byte $1b, $1b, $1b, $1b
			.byte $1b, $1b, $1b, $1b
			.byte $20, $20, $20, $20
			.byte $20, $20, $20, $20
			.byte $20, $20, $20, $20
			.byte $20, $20, $1b, $1e
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte $1e
			.byte cDelay($05), $2a, $1e, $2a
			.byte $1e, $2a, $1e, $2a
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte $1b
			.byte cDelay($05), $27, $1b, $27
			.byte $1b, $27, $1b, $27
			CSF_Loop _triangle_loop3
			CSF_Jump _triangle_loop4
_noise:
_noise_loop4:
			CSF_SetLoopCount $01
_noise_loop2:
			.byte $c0
			.byte cDelay($05)
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0, $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Loop _noise_loop1
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0, $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			CSF_Jump _noise_loop2
_noise_loop1:
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0, $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0, $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $00
			CSF_Command $8a, $04
			.byte $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $0b
_noise_loop3:
			CSF_Command $8a, $fc
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			CSF_Loop _noise_loop3
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04
			.byte $c0
			CSF_Command $8a, $fc
			.byte $c0
			CSF_Command $8a, $04
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop4