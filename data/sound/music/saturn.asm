			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $84
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0d
			CSF_HeaderInitVoice $03
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $84
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $84
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $84
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $35
			.byte cDelay($00), $2a, $37
			.byte cDelay($00), $36, $38
			.byte cDelay($00), $2a, $37
			CSF_Loop _pulse1_loop1
			.byte $35
			.byte cDelay($05), $33, $35
			.byte cDelay($00), $60
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $38
			.byte cDelay($05), $3a, $3c
			.byte cDelay($00), $54, $38
			.byte cDelay($05), $3a, $3c
			.byte cDelay($00), $60, $3c
			.byte cDelay($00), $1e, $3a
			.byte cDelay($05), $38, $3a
			.byte cDelay($00), $36, $3a
			.byte cDelay($00), $1e, $38
			.byte cDelay($05), $37, $38
			.byte cDelay($00), $36, $36
			.byte cDelay($06), $31, $2e, $31
			.byte $36, $38, $3a, $36
			.byte $31, $36, $3a, $3d
			.byte $3c
			.byte cDelay($00), $60
			CSF_Jump _pulse1_loop3
_pulse2:
_pulse2_loop4:
			.byte $2e
			.byte cDelay($05), $31, $2e, $31
			.byte $2e, $31, $2e, $31
			.byte $30, $33, $30, $33
			.byte $30, $33, $30, $33
			.byte $31, $35, $31, $35
			.byte $31, $35, $31, $33
			.byte $30, $33, $30, $33
			.byte $30, $33, $31, $30
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $31
			.byte cDelay($03), $35, $33, $37
			.byte $35, $38, $37, $3a
			.byte $35, $38, $33, $37
			.byte $31, $35, $30, $35
			CSF_Loop _pulse2_loop1
			.byte $2e
			.byte cDelay($05), $31, $2e, $31
			.byte $2e, $31, $2e, $31
			.byte $30, $33, $30, $33
			.byte $30, $33, $30, $33
			.byte $31, $35, $31, $35
			.byte $31, $35, $31, $35
			.byte $30, $33, $30, $33
			.byte $30, $33, $35, $37
			CSF_SetLoopCount $04
_pulse2_loop2:
			.byte $31
			.byte cDelay($03), $35, $33, $37
			.byte $35, $38, $37, $3a
			.byte $35, $38, $33, $37
			.byte $31, $35, $30, $33
			CSF_Loop _pulse2_loop2
			.byte $35
			.byte cDelay($05), $38, $35, $38
			.byte $35, $37, $35, $37
			.byte $33, $37, $33, $37
			.byte $33, $37, $33, $37
			.byte $33, $37, $33, $37
			.byte $33, $35, $33, $35
			.byte $30, $35, $31, $35
			.byte $30, $35, $31, $35
			CSF_SetLoopCount $02
_pulse2_loop3:
			.byte $2a
			.byte cDelay($05), $31, $2e, $36
			.byte $31, $2a, $2e, $25
			CSF_Loop _pulse2_loop3
			.byte $2e
			.byte cDelay($03), $30, $35
			.byte cDelay($08), $2e
			.byte cDelay($03), $30, $29, $2e
			.byte $30
			.byte cDelay($08), $29
			.byte cDelay($03), $2e, $30, $29
			.byte $2e, $30, $29, $2e
			.byte $30, $35, $2e, $30
			.byte $35, $3a, $30, $35
			.byte $3a, $3c
			CSF_Jump _pulse2_loop4
_triangle_loop4:
_triangle:
			CSF_SetLoopCount $0e
_triangle_loop1:
			.byte $22
			.byte cDelay($05), $22, $1d, $20
			.byte $22, $1d, $1f, $20
			CSF_Loop _triangle_loop1
			.byte $25, $25, $20, $25
			.byte $25, $25, $20, $25
			.byte $27, $27, $22, $27
			.byte $27, $22, $27, $24
			.byte $24, $24, $1f, $24
			.byte $24, $1f, $24, $1d
			.byte $1d, $1d, $18, $1d
			.byte $1d, $1d, $18, $1d
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte $1e
			.byte cDelay($05), $1e, $19, $1e
			.byte $1e, $1e, $19, $1e
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte $29
			.byte cDelay($03), $29, $24, $29
			.byte $00
			.byte cDelay($08), $1d
			.byte cDelay($03), $1d, $18, $1d
			.byte $00
			.byte cDelay($08)
			CSF_Loop _triangle_loop3
			CSF_Jump _triangle_loop4
_noise:
_noise_loop4:
			CSF_SetLoopCount $02
_noise_loop1:
			.byte $00
			.byte cDelay($08), $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00, $c0
			.byte $c0, $c0, $00, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Loop _noise_loop1
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00, $c0
			.byte $c0, $c0, $00, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $08
_noise_loop2:
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop2
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00, $c0
			.byte $c0, $c0, $00, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $00
			.byte cDelay($05), $c0, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $04
_noise_loop3:
			.byte $00
			.byte cDelay($08), $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Loop _noise_loop3
			CSF_Jump _noise_loop4