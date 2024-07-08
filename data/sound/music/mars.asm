			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0f
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $37, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0b, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $29
			.byte cDelay($0b), $2e
			.byte cDelay($0a), $30
			.byte cDelay($03), $35, $30
			.byte cDelay($0d), $00
			.byte cDelay($05), $2e
			.byte cDelay($03), $30, $31
			.byte cDelay($08), $00
			.byte cDelay($05), $30
			.byte cDelay($03), $2e, $30
			.byte cDelay($08), $2c, $29
			.byte cDelay($0e), $29
			.byte cDelay($0b), $2e
			.byte cDelay($0a), $30
			.byte cDelay($03), $31, $35
			.byte cDelay($0e), $33
			.byte cDelay($08), $00
			.byte cDelay($05), $31
			.byte cDelay($03), $30, $2e
			.byte cDelay($08), $2c, $2e
			.byte cDelay($0e)
			CSF_Loop _pulse1_loop1
			.byte $00
			.byte cDelay($08), $2e
			.byte cDelay($03), $31, $2e, $31
			.byte $2e
			.byte cDelay($0a), $35
			.byte cDelay($05), $33
			.byte cDelay($0a), $30
			.byte cDelay($05), $2c
			.byte cDelay($0b), $2a
			.byte cDelay($0a), $29
			.byte cDelay($05), $27
			.byte cDelay($08), $25, $29
			.byte cDelay($0e), $00
			.byte cDelay($08), $2e
			.byte cDelay($03), $31, $2e, $31
			.byte $2e
			.byte cDelay($0a), $35
			.byte cDelay($05), $33
			.byte cDelay($0a), $35
			.byte cDelay($05), $36
			.byte cDelay($0b), $36
			.byte cDelay($08), $34, $39, $37
			.byte $36
			.byte cDelay($0b), $34
			.byte $89 ; Unknown command
			.byte $01
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $89 ; Unknown command
			.byte cDelay($1f)
			CSF_Jump _pulse1_loop3
_pulse2_loop3:
_pulse2:
			CSF_SetLoopCount $01
_pulse2_loop2:
			.byte $2e
			.byte cDelay($03), $30, $35, $30
			.byte $35
			.byte cDelay($0d), $2e
			.byte cDelay($03), $30, $35, $30
			.byte $35
			.byte cDelay($0d), $2a
			.byte cDelay($03), $2c, $31, $2c
			.byte $31
			.byte cDelay($08), $29
			.byte cDelay($03), $2e, $30, $2e
			.byte $35
			.byte cDelay($08), $29
			.byte cDelay($03), $2e, $30, $29
			.byte $2e, $30, $35, $30
			.byte $30, $35, $3a, $35
			.byte $3a, $3c, $35, $30
			.byte $2e, $30, $35, $30
			.byte $35
			.byte cDelay($0d), $2a
			.byte cDelay($03), $2c, $31, $2c
			.byte $31
			.byte cDelay($0d), $29
			.byte cDelay($03), $2e, $30, $29
			.byte $2e, $30, $35, $30
			.byte $30, $35, $3a, $35
			.byte $3a, $3c, $35, $30
			.byte $2e, $30, $35, $30
			.byte $35, $30, $2e, $30
			.byte $31, $35, $30, $35
			.byte $2e, $31, $29, $31
			CSF_Loop _pulse2_loop1
			.byte $2a, $31, $30, $2e
			.byte $2a, $31, $30, $2e
			.byte $2a, $31, $30, $2e
			.byte $2a, $31, $30, $2e
			.byte $29, $30, $2e, $2c
			.byte $29, $30, $2e, $2c
			.byte $29, $30, $2e, $2c
			.byte $29, $30, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $2e, $29, $30, $29
			.byte $35, $30, $3a, $35
			.byte $35, $30, $35, $2e
			.byte $30, $29, $2e, $29
			.byte $2a, $31, $30, $2e
			.byte $2a, $31, $30, $2e
			.byte $2a, $31, $30, $2e
			.byte $2a, $31, $30, $2e
			.byte $27, $2f, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $27, $2f, $2e, $2c
			.byte $26, $2d, $2b, $2a
			.byte $26, $2d, $2b, $2a
			.byte $26, $2d, $2b, $2a
			.byte $26, $2d, $2b, $2a
			.byte $31, $2a, $2c, $2a
			.byte $25, $2c, $2a, $2c
			.byte $31, $36, $2c, $36
			.byte $31, $2c, $2e, $2a
			.byte $89 ; Unknown command
			.byte $01
			CSF_Jump _pulse2_loop2
_pulse2_loop1:
			.byte $89 ; Unknown command
			.byte cDelay($1f)
			CSF_Jump _pulse2_loop3
_triangle:
_triangle_loop3:
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte $22
			.byte cDelay($05), $22, $22, $1d
			.byte $22, $22, $22, $1d
			.byte $22, $22, $22, $1d
			.byte $22, $22, $22, $20
			.byte $1e, $1e, $1e, $19
			.byte $1d, $1d, $1d, $18
			.byte $22, $22, $22, $1d
			.byte $22, $22, $22, $1d
			.byte $22, $22, $22, $1d
			.byte $22, $22, $22, $20
			.byte $1e, $1e, $1e, $19
			.byte $1e, $1e, $1e, $19
			.byte $1d, $1d, $1d, $18
			.byte $1e, $1e, $1e, $19
			.byte $22, $22, $22, $1d
			.byte $22, $22, $22, $20
			CSF_Loop _triangle_loop1
			.byte $1e
			.byte cDelay($08), $19, $1e, $19
			.byte $1d, $18, $1d, $18
			.byte $17, $1e, $17, $1e
			.byte $1d, $18, $1d, $18
			.byte $1e, $19, $1e, $19
			.byte $17, $1e, $17, $1e
			.byte $1a, $15, $1a, $15
			.byte $1e, $19, $1e, $19
			.byte $89 ; Unknown command
			.byte $01
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte $89 ; Unknown command
			.byte cDelay($1f)
			CSF_Jump _triangle_loop3
_noise_loop5:
_noise:
			CSF_SetLoopCount $08
_noise_loop1:
			.byte $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Loop _noise_loop1
			CSF_SetLoopCount $03
_noise_loop2:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c1
			CSF_Loop _noise_loop2
			.byte $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c1
			CSF_Loop _noise_loop3
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($08), $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $08
_noise_loop4:
			.byte $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Loop _noise_loop4
			CSF_Jump _noise_loop5