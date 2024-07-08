			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0e
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $15
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0e, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1_loop1:
_pulse1:
			.byte $2c
			.byte cDelay($04), $2e, $2f, $31
			.byte cDelay($00), $48, $2c
			.byte cDelay($04), $2e, $2f, $31
			.byte cDelay($08), $2f
			.byte cDelay($00), $48, $31
			.byte cDelay($04), $33, $34, $36
			.byte cDelay($00), $48, $31
			.byte cDelay($04), $33, $34, $36
			.byte cDelay($08), $34
			.byte cDelay($00), $60, $2e
			.byte cDelay($08), $2a
			.byte cDelay($0b), $25
			.byte cDelay($08), $22, $25
			.byte cDelay($05), $2e
			.byte cDelay($08), $2c
			.byte cDelay($05), $2a
			.byte cDelay($08), $2d, $28
			.byte cDelay($0b), $25
			.byte cDelay($08), $21, $25
			.byte cDelay($05), $2d
			.byte cDelay($08), $2c
			.byte cDelay($05), $28
			.byte cDelay($08), $2a, $27
			.byte cDelay($0d), $2f
			.byte cDelay($08), $2a
			.byte cDelay($0a), $2a
			.byte cDelay($05), $2c, $2d, $2c
			.byte cDelay($08), $2e, $2f, $33
			.byte cDelay($04), $31, $33, $31
			.byte cDelay($0e), $2e
			.byte cDelay($0d), $2f
			.byte cDelay($05), $2c, $2e
			.byte cDelay($0b), $2a
			.byte cDelay($08), $25, $28
			.byte cDelay($0b), $2d
			.byte cDelay($0a), $34
			.byte cDelay($05), $31
			.byte cDelay($0e), $31
			.byte cDelay($08), $2f
			.byte cDelay($0b), $2a
			.byte cDelay($04), $27, $2a, $2a
			.byte cDelay($0e), $2c
			.byte cDelay($08), $30, $33, $36
			.byte cDelay($04), $33, $36, $3a
			.byte cDelay($0e)
			CSF_Command $8a, $ff
			.byte $00
			CSF_SetVoice $09
			.byte $31
			.byte cDelay($05), $31
			.byte cDelay($0a), $00
			.byte cDelay($0b), $00
			.byte cDelay($0e), $31
			.byte cDelay($05), $31
			.byte cDelay($0a)
			CSF_Command $8a, $01
			.byte $00
			.byte cDelay($0b)
			CSF_SetVoice $06
			CSF_Jump _pulse1_loop1
_pulse2_loop1:
_pulse2:
			.byte $25
			.byte cDelay($04), $27, $28, $2a
			.byte cDelay($00), $48, $25
			.byte cDelay($04), $27, $28, $2a
			.byte cDelay($08), $28
			.byte cDelay($00), $48, $2c
			.byte cDelay($04), $2e, $2f, $31
			.byte cDelay($00), $48, $2c
			.byte cDelay($04), $2e, $2f, $31
			.byte cDelay($08), $2f
			.byte cDelay($00), $60
			CSF_Command $8a, $fc
			.byte $a0 ; Unknown command
			.byte $b0, $00
			.byte cDelay($07), $2e
			.byte cDelay($08), $2a
			.byte cDelay($0b), $25
			.byte cDelay($08), $22, $25
			.byte cDelay($05), $2e
			.byte cDelay($08), $2c
			.byte cDelay($05), $2a
			.byte cDelay($08), $2d, $28
			.byte cDelay($0b), $25
			.byte cDelay($08), $21, $25
			.byte cDelay($05), $2d
			.byte cDelay($08), $2c
			.byte cDelay($05), $28
			.byte cDelay($08), $2a, $27
			.byte cDelay($0d), $2f
			.byte cDelay($08), $2a
			.byte cDelay($0a), $2a
			.byte cDelay($05), $2c, $2d, $2c
			.byte cDelay($08), $2e, $2f, $33
			.byte cDelay($04), $31, $33, $31
			.byte cDelay($0d), $00
			.byte cDelay($03)
			CSF_SetVoice $04
			.byte $83 ; Unknown command
			.byte $00
			CSF_Command $8a, $04
			.byte $a0 ; Unknown command
			.byte $30, $25
			.byte cDelay($05), $2a, $2e, $36
			.byte $25, $2a, $2e, $36
			.byte $25, $2a, $2e, $2a
			.byte $36, $2a, $31, $2e
			.byte $2d, $31, $34, $39
			.byte $2d, $31, $34, $39
			.byte $2d, $31, $34, $31
			.byte $39, $34, $31, $2d
			.byte $2f, $33, $36, $3b
			.byte $2f, $33, $36, $3b
			.byte $2f, $33, $36, $3b
			.byte $3f, $3b, $36, $2a
			.byte $2c, $30, $33, $38
			.byte $3c, $38, $33, $30
			.byte $2c, $30, $33, $38
			.byte $3f, $3c, $38, $33
			CSF_Command $8a, $fc
			.byte $00
			.byte cDelay($0e)
			CSF_SetVoice $09
			.byte $2c
			.byte cDelay($05), $2c
			.byte cDelay($0a), $00
			.byte cDelay($0b), $00
			.byte cDelay($0e), $2c
			.byte cDelay($05), $2c
			.byte cDelay($0a)
			CSF_Command $8a, $04
			.byte $00
			.byte cDelay($0b)
			CSF_SetVoice $06
			.byte $83 ; Unknown command
			.byte $41
			.byte $a0 ; Unknown command
			.byte $70
			CSF_Jump _pulse2_loop1
_triangle:
_triangle_loop4:
			CSF_SetLoopCount $08
_triangle_loop1:
			.byte $19
			.byte cDelay($05), $14, $16, $17
			.byte $19, $14, $16, $17
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $10
_triangle_loop2:
			.byte $12
			.byte cDelay($05), $12, $12, $12
			.byte $12, $12, $12, $12
			.byte $9c ; Unknown command
			.byte $10, $7f, $a2
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $04
_triangle_loop3:
			.byte $19
			.byte cDelay($05), $16, $17, $18
			.byte $19, $16, $17, $18
			CSF_Loop _triangle_loop3
			CSF_Jump _triangle_loop4
_noise:
_noise_loop4:
			CSF_SetLoopCount $07
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1, $c0
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05)
			CSF_Loop _noise_loop1
			.byte $c1, $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c0, $00, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_SetLoopCount $0f
_noise_loop2:
			.byte $c1
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1, $c0
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05)
			CSF_Loop _noise_loop2
			.byte $c1, $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop3
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Jump _noise_loop4
			.byte $00, $03, $00, $02
			.byte $00, $02, $00
			.byte cDelay($19), $00, $03, $00
			.byte $02, $00
			.byte cDelay($1d), $00
			.byte cDelay($1e)