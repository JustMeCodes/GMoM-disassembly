			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $01
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0c
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $01
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $15
			CSF_HeaderTempo $01
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $00
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			CSF_Command $96, $99
			CSF_Command $9d, $03
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $25
			.byte cDelay($05), $24, $22, $25
			.byte $24, $22, $25, $24
			.byte $22, $25, $24, $22
			.byte $25, $24, $22, $27
			.byte $25, $24, $27, $25
			.byte $24, $27, $25, $24
			.byte $27, $25, $24, $27
			.byte $25, $24, $27, $25
			.byte $24, $22, $25, $24
			.byte $22, $25, $24, $22
			.byte $25, $24, $22, $25
			.byte $24, $22, $25
			CSF_SetVoice $0d
			CSF_Command $9d, $0c
			.byte $27
			.byte cDelay($00), $2a
			CSF_Loop _pulse1_loop1
			.byte $00
			.byte cDelay($0a)
			CSF_Command $8a, $fe
			CSF_Command $9d, $03
			.byte $31
			.byte cDelay($05), $00, $33
			.byte cDelay($0b), $00
			.byte cDelay($05)
			CSF_Command $8a, $02
			CSF_SetVoice $04
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $00
			.byte cDelay($05)
			CSF_Command $9d, $0c
			.byte $29
			.byte cDelay($00), $36
			CSF_Command $8a, $fd
			CSF_SetVoice $02
			CSF_Command $9d, $03
			.byte $3a
			.byte cDelay($05), $3a, $3d, $3a
			.byte $3f, $3a, $41, $3a
			.byte $42, $3a, $41, $3a
			.byte $3f, $37, $38, $39
			.byte $3a, $3a, $3d, $3a
			.byte $3f, $3a, $41, $3a
			.byte $42, $3a, $41, $3a
			.byte $3f, $37, $38, $39
			CSF_SetVoice $0d
			CSF_Command $8a, $03
			.byte $31
			.byte cDelay($0e), $33
			.byte cDelay($0b), $35
			CSF_Command $9d, $0c
			.byte $30
			.byte cDelay($00), $54
			CSF_Command $9d, $03
			.byte $30
			.byte cDelay($04), $31, $33
			CSF_Command $9d, $0c
			.byte $2e
			.byte cDelay($0e)
			CSF_Command $9d, $03
			.byte $30
			.byte cDelay($0b), $31
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c
			.byte $38
			.byte cDelay($00), $36
			CSF_Command $9d, $03
			.byte $36
			.byte cDelay($0a), $35, $33
			.byte cDelay($05)
			CSF_Command $9d, $0c
			.byte $31
			.byte cDelay($00), $36
			CSF_Command $9d, $03
			.byte $33
			.byte cDelay($0b), $35
			CSF_Command $9d, $0c
			.byte $30
			.byte cDelay($00), $54
			CSF_Command $9d, $03
			.byte $30
			.byte cDelay($04), $31, $33
			CSF_Command $9d, $0c
			.byte $2e
			.byte cDelay($0e)
			CSF_Command $9d, $03
			.byte $30
			.byte cDelay($0b), $31
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c
			.byte $38
			.byte cDelay($00), $36
			CSF_Command $9d, $03
			.byte $25
			.byte cDelay($05), $24, $22, $25
			.byte $24, $22, $25, $24
			.byte $00, $33, $31, $00
			.byte $33, $00, $00, $31
			.byte $00, $00, $33, $33
			.byte $00, $35, $33, $00
			.byte $35, $00, $00, $33
			.byte $00, $00, $35, $35
			.byte $00, $36, $35, $00
			.byte $36, $00, $00, $35
			.byte $00, $00, $36, $36
			.byte $00, $38, $36, $00
			.byte $38, $00, $00, $36
			.byte $00, $00, $38, $38
			.byte $20
			.byte cDelay($0b), $21
			CSF_Jump _pulse1_loop3
_pulse2:
			CSF_Command $96, $99
			CSF_Command $9d, $03
_pulse2_loop2:
			CSF_SetVoice $04
			.byte $00
			.byte cDelay($04), $25
			.byte cDelay($05), $24, $22, $25
			.byte $24, $22, $25, $24
			.byte $22, $25, $24, $22
			.byte $25, $24, $22, $27
			.byte $25, $24, $27, $25
			.byte $24, $27, $25, $24
			.byte $27, $25, $24, $27
			.byte $25, $24, $27, $25
			.byte $24, $22, $25, $24
			.byte $22, $25, $24, $22
			.byte $25, $24, $22, $25
			.byte $24, $22, $25
			CSF_SetVoice $0d
			CSF_Command $9d, $12
			.byte $27
			.byte cDelay($00), $30, $00
			.byte cDelay($04), $00
			CSF_Command $9d, $03
			.byte $2a
			.byte cDelay($05), $00, $2c
			.byte cDelay($0b), $00
			.byte cDelay($05)
			CSF_SetVoice $04
			CSF_Command $8a, $01
			.byte $29, $27, $25, $29
			.byte $27, $25, $29, $27
			.byte $25, $29, $27, $25
			.byte $29, $27, $25, $2a
			.byte $29, $27, $2a, $29
			.byte $27, $2a, $29, $27
			.byte $2a, $29, $27, $2a
			.byte $29, $27, $2a, $29
			.byte $27, $25, $29, $27
			.byte $25, $29, $27, $25
			.byte $29, $27, $25, $29
			.byte $27, $25, $29
			CSF_Command $9d, $0c
			CSF_SetVoice $0d
			.byte $22
			.byte cDelay($00), $2a, $00
			.byte cDelay($05), $24
			.byte cDelay($00), $36
			CSF_Command $9d, $03
			.byte $00
			.byte cDelay($07)
			CSF_SetVoice $02
			CSF_Command $8a, $fa
			.byte $3a
			.byte cDelay($05), $3a, $3d, $3a
			.byte $3f, $3a, $41, $3a
			.byte $42, $3a, $41, $3a
			.byte $3f, $37, $38, $39
			.byte $3a, $3a, $3d, $3a
			.byte $3f, $3a, $41, $3a
			.byte $42, $3a, $41, $3a
			.byte $3f, $37, $38, $39
			CSF_SetVoice $0d
			CSF_Command $8a, $05
			CSF_Command $9d, $0c
			.byte $31
			.byte cDelay($0e)
			CSF_Command $9d, $03
			.byte $33
			.byte cDelay($0b), $35
			CSF_Command $9d, $0c
			.byte $30
			.byte cDelay($00), $54
			CSF_Command $9d, $03
			.byte $30
			.byte cDelay($04), $31, $33
			CSF_Command $9d, $0c
			.byte $2e
			.byte cDelay($0e)
			CSF_Command $9d, $03
			.byte $30
			.byte cDelay($0b), $31
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c
			.byte $38
			.byte cDelay($00), $2d
			CSF_Command $9d, $03
			CSF_Command $8a, $01
			.byte $25
			.byte cDelay($05), $24, $22, $25
			.byte $24, $22, $25
			CSF_Command $9d, $0c
			.byte $35
			.byte cDelay($00), $36
			CSF_Command $9d, $03
			.byte $36
			.byte cDelay($0b), $38
			CSF_Command $9d, $0c
			.byte $35
			.byte cDelay($00), $60, $33
			.byte cDelay($0e)
			CSF_Command $9d, $03
			.byte $35
			.byte cDelay($0b), $36
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c
			.byte $3c
			.byte cDelay($00), $36
			CSF_Command $9d, $03
			.byte $2c
			.byte cDelay($05), $2a, $29, $2c
			.byte $2a, $29, $2c, $2a
			CSF_Command $8a, $ff
			CSF_SetLoopCount $04
_pulse2_loop1:
			.byte $00, $2e, $2e, $00
			.byte $2e, $00, $00, $2e
			.byte $00, $00, $2e, $2e
			CSF_Loop _pulse2_loop1
			.byte $27
			.byte cDelay($0b), $28
			CSF_Jump _pulse2_loop2
_triangle:
			CSF_Command $96, $99
_triangle_loop6:
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte $16
			.byte cDelay($03), $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16
			.byte cDelay($07), $00
			.byte cDelay($03), $16, $00, $16
			.byte $00, $16, $00, $16
			.byte $00, $16, $00, $16
			.byte $00, $16, $00, $14
			.byte cDelay($03), $00, $14, $00
			.byte $14, $00, $14, $00
			.byte $14, $00, $14, $00
			.byte $14, $00, $14
			.byte cDelay($07), $00
			.byte cDelay($03), $14, $00, $14
			.byte $00, $14, $00, $14
			.byte $00, $14, $00, $14
			.byte $00, $14, $00, $12
			.byte cDelay($03), $00, $12, $00
			.byte $12, $00, $12, $00
			.byte $12, $00, $12, $00
			.byte $12, $00, $12
			.byte cDelay($07), $00
			.byte cDelay($03), $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00
			CSF_Loop _triangle_loop1
			.byte $0f, $00, $0f, $00
			.byte $0f, $00, $0f, $00
			.byte $0f, $00, $0f, $00
			.byte $0f, $00, $0f, $00
			.byte $00, $00, $12, $00
			.byte cDelay($07), $14, $00
			.byte cDelay($03), $14, $00, $14
			.byte $00, $14, $00
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte $0f, $00, $0f, $00
			.byte $0f, $00, $0f, $00
			.byte $0f, $00, $0f, $00
			.byte $0f, $00, $11
			.byte cDelay($07), $00
			.byte cDelay($03), $11, $00, $11
			.byte $00, $11, $00, $11
			.byte $00, $11, $00, $12
			.byte $00, $14, $00
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $13, $00
			.byte $14, $00, $15, $00
			CSF_Loop _triangle_loop3
			CSF_SetLoopCount $02
_triangle_loop4:
			.byte $16, $00, $16, $00
			.byte $19, $00, $16, $00
			.byte $1b, $00, $16, $00
			.byte $1d, $00, $16, $00
			.byte $16, $00, $1b, $00
			.byte $1b, $00, $16, $00
			.byte $19, $00, $19, $00
			.byte $11, $00, $13, $00
			.byte $14, $00, $14, $00
			.byte $18, $00, $14, $00
			.byte $19, $00, $14, $00
			.byte $1b, $00, $14, $00
			.byte $14, $00, $19, $00
			.byte $19, $00, $14, $00
			.byte $18, $00, $18, $00
			.byte $14, $00, $12
			.byte cDelay($07), $00
			.byte cDelay($03), $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12
			.byte cDelay($07), $00
			.byte cDelay($03), $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $11
			.byte cDelay($07), $00
			.byte cDelay($03), $11, $00, $11
			.byte $00, $11, $00, $11
			.byte $00, $11, $00, $11
			.byte $00, $11, $00, $19
			.byte $00, $18, $00, $16
			.byte $00, $19, $00, $18
			.byte $00, $16, $00, $19
			.byte $00, $18, $00
			CSF_Loop _triangle_loop4
			CSF_SetLoopCount $04
_triangle_loop5:
			.byte $16, $00, $1d, $00
			.byte $1d, $00, $16, $00
			.byte $1b, $00, $16, $00
			.byte $16, $00, $19, $00
			.byte $16, $00, $16, $00
			.byte $18, $00, $16, $00
			CSF_Loop _triangle_loop5
			.byte $14
			.byte cDelay($0b), $15
			CSF_Jump _triangle_loop6
_noise:
			CSF_Command $96, $99
_noise_loop8:
			CSF_SetLoopCount $01
_noise_loop3:
			CSF_SetLoopCount $0e, $77
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			CSF_Loop _noise_loop1, $77
			CSF_Loop _noise_loop2
			.byte $c1, $c0, $c1, $c0
			.byte $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Jump _noise_loop3
_noise_loop2:
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $03, $77
_noise_loop4:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c0
			CSF_Loop _noise_loop4, $77
			.byte $c0
			.byte cDelay($03), $c0, $c0, $00
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $00
			.byte $c0, $c0, $c0, $c0
			CSF_SetLoopCount $0f, $77
_noise_loop5:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			CSF_Loop _noise_loop5, $77
			.byte $c0, $00
			.byte cDelay($03), $c0, $c0, $00
			.byte $c0, $00
			CSF_SetLoopCount $0e, $77
_noise_loop6:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			CSF_Loop _noise_loop6, $77
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $04, $77
_noise_loop7:
			.byte $c1
			.byte cDelay($05), $c0, $c0, $c1
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c0
			CSF_Loop _noise_loop7, $77
			.byte $c0
			.byte cDelay($08), $00, $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop8
			.byte $04
			.byte cDelay($1e)
			.byte cDelay($1e)