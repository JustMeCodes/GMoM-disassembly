			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $05
			CSF_HeaderTempo $99
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0c
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $f9
			CSF_HeaderTempo $99
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $18
			CSF_HeaderTempo $99
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $99
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			.byte $35
			.byte cDelay($0a), $33, $38
			.byte cDelay($08)
_pulse1_loop3:
			.byte $36
			.byte cDelay($0a), $35, $33
			.byte cDelay($08), $33
			.byte cDelay($0a), $35
			.byte cDelay($00), $42, $2e
			.byte cDelay($05), $30, $31
			.byte cDelay($0e), $35
			.byte cDelay($0a), $33, $30
			.byte cDelay($08), $31
			.byte cDelay($0a), $30, $2e
			.byte cDelay($08), $30
			.byte cDelay($0a), $2c, $29
			.byte cDelay($08)
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $2c
			.byte cDelay($05), $2e
			.byte cDelay($08), $30, $31
			.byte cDelay($0a), $33
			.byte cDelay($08), $35, $36, $38
			.byte $36
			.byte cDelay($0a), $35
			.byte cDelay($00), $4e, $33
			.byte cDelay($05), $31, $33, $30
			.byte cDelay($00), $4e
			CSF_Loop _pulse1_loop1
			.byte $33
			.byte cDelay($05), $31, $33, $35
			.byte cDelay($00), $4e
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $3a
			.byte cDelay($05), $38, $3a, $3c
			.byte cDelay($00), $4e, $35
			.byte cDelay($08), $33
			.byte cDelay($05), $35
			.byte cDelay($08), $33
			.byte cDelay($05), $36, $35, $38
			.byte cDelay($08), $36
			.byte cDelay($05), $38
			.byte cDelay($08), $36
			.byte cDelay($05), $3a, $38, $3b
			.byte cDelay($08), $3a
			.byte cDelay($05), $3b
			.byte cDelay($08), $3a
			.byte cDelay($05), $3d, $3b, $3a
			.byte cDelay($0e), $35
			CSF_Jump _pulse1_loop3
_pulse2:
_pulse2_loop2:
			.byte $35
			.byte cDelay($0a), $33, $38
			.byte cDelay($08), $36
			.byte cDelay($0a), $35, $33
			.byte cDelay($08), $33
			.byte cDelay($0a), $35
			.byte cDelay($00), $42, $2e
			.byte cDelay($05), $30, $31
			.byte cDelay($0e), $35
			.byte cDelay($0a), $33, $30
			.byte cDelay($08), $31
			.byte cDelay($0a), $30, $2e
			.byte cDelay($08), $30
			.byte cDelay($0a), $2c, $29
			.byte cDelay($08)
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $89 ; Unknown command
			.byte $00, $2c
			.byte cDelay($05), $2e
			.byte cDelay($08), $30, $31
			.byte cDelay($0a), $33
			.byte cDelay($08), $35, $36, $38
			CSF_Command $8a, $ff
			.byte $89 ; Unknown command
			.byte cDelay($14), $3d
			.byte cDelay($0a), $3b, $3a
			.byte cDelay($08), $38
			.byte cDelay($0a), $36, $35
			.byte cDelay($08), $33
			.byte cDelay($0e), $38
			.byte cDelay($0a), $36, $35
			.byte cDelay($08), $31
			.byte cDelay($0e), $36
			.byte cDelay($0a), $35, $31
			.byte cDelay($08)
			CSF_Command $8a, $01
			CSF_Loop _pulse2_loop1
			CSF_Command $8a, $ff
			.byte $2e
			.byte cDelay($0e)
			CSF_Command $8a, $01
			.byte $89 ; Unknown command
			.byte $05, $38
			.byte cDelay($08), $36
			.byte cDelay($05), $38
			.byte cDelay($08), $36
			.byte cDelay($05), $3a, $38, $3b
			.byte cDelay($08), $3a
			.byte cDelay($05), $3b
			.byte cDelay($08), $3a
			.byte cDelay($05), $3d, $3b, $3a
			.byte cDelay($0e)
			CSF_Jump _pulse2_loop2
_triangle:
_triangle_loop2:
			CSF_SetLoopCount $18
_triangle_loop1:
			.byte $22
			.byte cDelay($05), $16, $22, $16
			.byte $22, $22, $16, $22
			.byte $9c ; Unknown command
			.byte $18, $40, $a4
			CSF_Loop _triangle_loop1
			CSF_SetVoice $04
			.byte $16, $00, $14, $16
			.byte $00, $14, $17, $16
			.byte $19, $00, $17, $19
			.byte $00, $17, $1b, $19
			.byte $1c, $00, $1b, $1c
			.byte $00, $1b, $1e, $1c
			CSF_SetVoice $02
			.byte $20, $14, $20, $14
			.byte $20, $20, $14, $20
			CSF_Jump _triangle_loop2
_noise:
_noise_loop3:
			CSF_SetLoopCount $03, $77
_noise_loop2:
			CSF_SetLoopCount $07
_noise_loop1:
			CSF_Command $8a, $fb
			.byte $c0
			.byte cDelay($03), $00, $c0, $00
			CSF_Command $8a, $05
			.byte $c0, $00
			CSF_Command $8a, $fb
			.byte $c0, $00, $c0, $00
			.byte $c0, $00
			CSF_Command $8a, $05
			.byte $c0, $00
			CSF_Command $8a, $fb
			.byte $c0, $00
			CSF_Command $8a, $05
			CSF_Loop _noise_loop1
			CSF_Command $8a, $fb
			.byte $c0, $00, $c0, $00
			CSF_Command $8a, $05
			.byte $c0, $00
			CSF_Command $8a, $fb
			.byte $c0, $00
			CSF_Command $8a, $05
			.byte $c0, $00
			CSF_Command $8a, $fb
			.byte $c0, $00
			CSF_Command $8a, $05
			.byte $c0, $c0, $c0, $c0
			CSF_Loop _noise_loop2, $77
			.byte $00
			.byte cDelay($0e), $00, $00, $c0
			.byte cDelay($03), $00, $c0, $00
			.byte $00, $00, $c0, $00
			.byte $c0, $00, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop3
			.byte cDelay($1e)
			.byte cDelay($1e)
			.byte cDelay($1f), $05
			.byte cDelay($1e)
			.byte cDelay($1e)
			.byte cDelay($1f)
			.byte cDelay($1e), $00, $02, $00
			.byte $03, $00
			.byte cDelay($1d), $00
			.byte cDelay($1e), $00, $02, $00
			.byte $03, $00
			.byte cDelay($1d), $00, $05