			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0d
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $66
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $31
			.byte cDelay($03), $30, $2e
			.byte cDelay($08), $31
			.byte cDelay($03), $30, $2e
			.byte cDelay($05), $31
			.byte cDelay($03), $30, $2e, $30
			.byte $31, $33, $30
			.byte cDelay($0a), $35
			.byte cDelay($00), $1e, $31
			.byte cDelay($03), $30, $2e
			.byte cDelay($08), $31
			.byte cDelay($03), $30, $2e
			.byte cDelay($05), $31
			.byte cDelay($03), $30, $2e, $30
			.byte $31, $33, $30
			.byte cDelay($0a), $29
			.byte cDelay($00), $1e
			CSF_Loop _pulse1_loop1
			.byte $35
			.byte cDelay($08), $36
			.byte cDelay($05), $33
			.byte cDelay($08), $35
			.byte cDelay($0a), $33
			.byte cDelay($08), $35
			.byte cDelay($05), $33
			.byte cDelay($08), $2c
			.byte cDelay($0a), $35
			.byte cDelay($08), $33
			.byte cDelay($05), $38
			.byte cDelay($08), $36, $35
			.byte cDelay($00), $36
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $2c
			.byte cDelay($08), $2a
			.byte cDelay($05), $28
			.byte cDelay($08), $2f
			.byte cDelay($0a), $2e
			.byte cDelay($08), $2c
			.byte cDelay($05), $2a
			.byte cDelay($08), $31
			.byte cDelay($0a), $33
			.byte cDelay($03), $35, $33, $35
			.byte $33
			.byte cDelay($0d)
			CSF_Jump _pulse1_loop3
_pulse2:
_pulse2_loop3:
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $00
			.byte cDelay($0e), $00
			.byte cDelay($08), $2c
			.byte cDelay($05), $2e, $30, $31
			.byte $30
			.byte cDelay($04), $2e, $2c
			CSF_Loop _pulse2_loop1
			.byte $31
			.byte cDelay($0a), $2e
			.byte cDelay($00), $1e, $30
			.byte cDelay($0a), $29
			.byte cDelay($00), $1e, $2a
			.byte cDelay($05), $2e, $31, $35
			.byte $2a, $2e, $31, $2e
			.byte $33
			.byte cDelay($03), $35, $36, $33
			.byte $30, $31, $33, $30
			.byte $2d, $2e, $30, $2c
			.byte $29, $2b, $2c, $29
			CSF_SetLoopCount $02
_pulse2_loop2:
			.byte $00
			.byte cDelay($0e), $00
			.byte cDelay($08), $2c
			.byte cDelay($05), $2e, $30, $31
			.byte $30
			.byte cDelay($04), $2e, $2c
			CSF_Loop _pulse2_loop2
			.byte $23
			.byte cDelay($0a), $20
			.byte cDelay($00), $1e, $25
			.byte cDelay($0a), $22
			.byte cDelay($00), $1e, $2c
			.byte cDelay($0b), $24
			.byte cDelay($05), $27, $2c, $30
			CSF_Jump _pulse2_loop3
_triangle:
_triangle_loop4:
			CSF_SetLoopCount $04
_triangle_loop1:
			.byte $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20, $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20, $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20, $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20
			.byte $9c ; Unknown command
			.byte $04, $20, $a6
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $03
_triangle_loop2:
			.byte $1e
			.byte cDelay($05), $1e, $1e, $25
			.byte cDelay($08), $1e
			.byte cDelay($05), $1e, $1e
			.byte $9c ; Unknown command
			.byte $03, $24, $a6
			CSF_Loop _triangle_loop2
			.byte $1d, $1d, $1d, $24
			.byte $1d, $1d, $1d, $24
			CSF_SetLoopCount $04
_triangle_loop3:
			.byte $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20, $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20, $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20, $22
			.byte cDelay($05), $22
			.byte cDelay($03), $20
			.byte $9c ; Unknown command
			.byte $04, $27, $a6
			CSF_Loop _triangle_loop3
			.byte $1c
			.byte cDelay($05), $1d, $1d, $17
			.byte $1d, $1d, $1d, $18
			.byte $1e, $1e, $1e, $19
			.byte $1e, $1e, $1e, $19
			.byte $20
			.byte cDelay($0b), $20
			.byte cDelay($03), $20, $20
			.byte cDelay($05), $20
			.byte cDelay($03), $20, $20
			.byte cDelay($05)
			CSF_Jump _triangle_loop4
_noise:
_noise_loop8:
			CSF_SetLoopCount $10
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			CSF_Loop _noise_loop1
			CSF_SetLoopCount $02
_noise_loop2:
			.byte $c0
			.byte cDelay($0a), $c0
			.byte cDelay($05), $c0
			.byte cDelay($0b)
			CSF_Loop _noise_loop2
			CSF_SetLoopCount $02, $77
_noise_loop4:
			CSF_SetLoopCount $04
_noise_loop3:
			.byte $c0
			.byte cDelay($03), $c0, $c1
			CSF_Loop _noise_loop3
			.byte $c0, $c0, $c0, $c0
			CSF_Loop _noise_loop4, $77
			CSF_SetLoopCount $10
_noise_loop5:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			CSF_Loop _noise_loop5
			CSF_SetLoopCount $02
_noise_loop6:
			.byte $c0
			.byte cDelay($0a), $c0
			.byte cDelay($05), $c0
			.byte cDelay($0b)
			CSF_Loop _noise_loop6
			CSF_SetLoopCount $04
_noise_loop7:
			.byte $c0
			.byte cDelay($05), $c1
			.byte cDelay($03)
			CSF_Loop _noise_loop7
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop8
			.byte cDelay($1e), $02
			.byte cDelay($1e), $02
			.byte cDelay($1f), $01, $00
			.byte cDelay($1e), $02
			.byte cDelay($1e), $02