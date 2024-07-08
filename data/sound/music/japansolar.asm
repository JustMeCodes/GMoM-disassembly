			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $00
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $18
			CSF_HeaderTempo $01
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0c, $00
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			CSF_Command $8a, $00
			CSF_Command $96, $7b
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $29
			.byte cDelay($05), $29, $29, $25
			.byte cDelay($03), $27, $29
			.byte cDelay($0a), $25
			.byte cDelay($05), $29, $25
			.byte cDelay($03), $27, $25
			.byte cDelay($05), $27
			.byte cDelay($03), $27
			CSF_Loop _pulse1_loop1
			.byte $29
			.byte cDelay($05), $29, $29, $25
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $25
			.byte cDelay($08), $24
_pulse1_loop9:
			CSF_SetLoopCount $02
_pulse1_loop3:
			.byte $25
			.byte cDelay($05), $27, $29, $2a
			.byte $29
			.byte cDelay($08), $2c, $27, $2c
			.byte $25
			.byte cDelay($05), $27, $29, $2a
			.byte $29
			.byte cDelay($08), $29
			.byte cDelay($05), $27, $25, $29
			.byte $24, $29, $22
			.byte cDelay($08), $22
			.byte cDelay($05), $21, $22
			.byte cDelay($08), $24, $25
			.byte cDelay($05), $27, $29, $24
			.byte $25
			.byte cDelay($08), $24, $22, $22
			.byte cDelay($05), $21, $22
			.byte cDelay($08), $24, $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08)
			CSF_Loop _pulse1_loop3
			CSF_SetLoopCount $01
_pulse1_loop5:
			.byte $29
			.byte cDelay($05), $29, $29, $25
			.byte cDelay($03), $27, $29
			.byte cDelay($0a), $25
			.byte cDelay($05), $29, $25
			.byte cDelay($03), $27, $25
			.byte cDelay($05), $25
			.byte cDelay($03), $27, $29
			.byte cDelay($05), $29, $29, $25
			.byte $2a, $2a, $2a, $27
			.byte cDelay($03), $29, $2a
			.byte cDelay($0a), $27
			.byte cDelay($05), $2a, $27
			.byte cDelay($03), $29, $27
			.byte cDelay($05), $27
			.byte cDelay($03), $29
			CSF_Loop _pulse1_loop4
			.byte $2a
			.byte cDelay($05), $27, $29, $2a
			CSF_Jump _pulse1_loop5
_pulse1_loop4:
			.byte $2a
			.byte cDelay($08), $2a
			.byte cDelay($05), $00
			CSF_SetLoopCount $02
_pulse1_loop6:
			.byte $29
			.byte cDelay($00), $1e, $25
			.byte cDelay($05), $27, $29, $29
			.byte cDelay($00), $1e, $25
			.byte cDelay($05), $27, $29, $2a
			.byte cDelay($03), $2c, $2a, $29
			.byte $27
			.byte cDelay($08), $2a
			.byte cDelay($03), $2c, $2a, $29
			.byte $27
			.byte cDelay($08), $2a
			.byte cDelay($03), $2c, $2a, $29
			.byte $27
			.byte cDelay($08), $00
			.byte cDelay($05), $29, $2a, $27
			CSF_Loop _pulse1_loop6
			CSF_SetLoopCount $01
_pulse1_loop8:
			.byte $29
			.byte cDelay($05), $2e, $29
			.byte cDelay($08), $29
			.byte cDelay($05), $2e, $29
			.byte cDelay($08), $2a
			.byte cDelay($05), $29, $27, $25
			CSF_Loop _pulse1_loop7
			.byte $27
			.byte cDelay($08), $29
			CSF_Jump _pulse1_loop8
_pulse1_loop7:
			.byte $2a
			.byte cDelay($05), $2a, $29
			.byte cDelay($08)
			CSF_Jump _pulse1_loop9
			CSF_Stop 
_pulse2:
			CSF_Command $96, $7b
			CSF_Command $8a, $ff
			CSF_SetVoice $04
			.byte $83 ; Unknown command
			.byte $41
			CSF_SetLoopCount $01
_pulse2_loop2:
			.byte $1d
			.byte cDelay($05), $1d, $1d, $19
			.byte cDelay($03), $1b, $1d
			.byte cDelay($0a), $19
			.byte cDelay($05), $1d, $19
			.byte cDelay($03), $1b, $19
			.byte cDelay($05), $1b
			.byte cDelay($03), $1b
			CSF_Loop _pulse2_loop1
			.byte $1d
			.byte cDelay($05), $1d, $1d, $19
			CSF_Jump _pulse2_loop2
_pulse2_loop1:
			.byte $19
			.byte cDelay($08), $18
_pulse2_loop9:
			.byte $83 ; Unknown command
			.byte $40
			CSF_Command $8a, $01
			CSF_SetLoopCount $02
_pulse2_loop3:
			.byte $00
			.byte cDelay($0b), $25
			.byte cDelay($05), $25, $20, $20
			.byte $25, $25, $20, $20
			.byte $25, $25, $20, $20
			.byte $25, $25, $20, $20
			.byte $00, $2e, $00, $30
			.byte $00, $31, $00
			.byte cDelay($08), $00
			.byte cDelay($05), $2e, $00, $30
			.byte $00, $31, $00
			.byte cDelay($08), $00
			.byte cDelay($05), $2a, $00, $2c
			.byte $00, $2e, $00, $00
			.byte $00, $2a, $00, $2c
			.byte $00, $2e, $00, $00
			CSF_Loop _pulse2_loop3
			.byte $83 ; Unknown command
			.byte $41
			CSF_SetLoopCount $01
_pulse2_loop5:
			.byte $1d, $1d, $1d, $19
			.byte cDelay($03), $1b, $1d
			.byte cDelay($0a), $19
			.byte cDelay($05), $1d, $19
			.byte cDelay($03), $1b, $19
			.byte cDelay($05), $19
			.byte cDelay($03), $1b, $1d
			.byte cDelay($05), $1d, $1d, $19
			.byte $1e, $1e, $1e, $1b
			.byte cDelay($03), $1d, $1e
			.byte cDelay($0a), $1b
			.byte cDelay($05), $1e, $1b
			.byte cDelay($03), $1d, $1b
			.byte cDelay($05), $1b
			.byte cDelay($03), $1d
			CSF_Loop _pulse2_loop4
			.byte $1e
			.byte cDelay($05), $1b, $1d, $1e
			CSF_Jump _pulse2_loop5
_pulse2_loop4:
			.byte $1e
			.byte cDelay($08), $1e
			.byte cDelay($05), $00
			CSF_SetLoopCount $02
_pulse2_loop6:
			.byte $00
			.byte cDelay($0e)
			CSF_SetVoice $04
			.byte $83 ; Unknown command
			.byte $41, $00
			.byte cDelay($05), $35, $36, $35
			.byte cDelay($00), $1e, $2a
			.byte cDelay($03), $2c, $2a, $29
			.byte $27
			.byte cDelay($08), $2a
			.byte cDelay($03), $2c, $2a, $29
			.byte $27
			.byte cDelay($08), $2a
			.byte cDelay($03), $2c, $2a, $29
			.byte $27
			.byte cDelay($08), $00
			.byte cDelay($05), $29, $2a, $27
			CSF_Loop _pulse2_loop6
			.byte $83 ; Unknown command
			.byte $40
			CSF_Command $8a, $fb
			CSF_SetLoopCount $01
_pulse2_loop8:
			.byte $4d
			.byte cDelay($05), $52, $4d
			.byte cDelay($08), $4d
			.byte cDelay($05), $52, $4d
			.byte cDelay($08), $4e
			.byte cDelay($05), $4d, $4b, $49
			CSF_Loop _pulse2_loop7
			.byte $4b
			.byte cDelay($08), $4d
			CSF_Jump _pulse2_loop8
_pulse2_loop7:
			.byte $4e
			.byte cDelay($05), $4e, $4d
			.byte cDelay($08)
			CSF_SetVoice $04
			CSF_Command $8a, $05
			CSF_Jump _pulse2_loop9
			CSF_Stop 
_triangle:
			CSF_Command $96, $7b
			CSF_SetVoice $02
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte $16
			.byte cDelay($05), $16, $22, $16
			.byte $16, $16, $22, $16
			.byte $16, $16, $22, $16
			.byte $1d, $16
			CSF_Loop _triangle_loop1
			.byte $19, $1d
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte $1d, $22
_triangle_loop7:
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte $19
			.byte cDelay($0b), $19
			.byte cDelay($05), $14, $19, $14
			.byte $19, $14, $19, $14
			.byte $19, $14, $19, $14
			.byte $19, $14, $25, $20
			.byte $0a, $16
			.byte cDelay($03), $11, $0c
			.byte cDelay($05), $18
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), $19
			.byte cDelay($03), $14, $0a
			.byte cDelay($05), $05, $0a, $16
			.byte cDelay($03), $11, $0c
			.byte cDelay($05), $18
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), $19
			.byte cDelay($03), $14, $0a
			.byte cDelay($05), $05, $06, $12
			.byte cDelay($03), $0d, $0c
			.byte cDelay($05), $18
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), $0c, $0a, $16
			.byte cDelay($03), $0a, $06
			.byte cDelay($05), $12
			.byte cDelay($03), $0d, $0c
			.byte cDelay($05), $18
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), $0c, $0a, $16
			.byte cDelay($03), $0a
			CSF_Loop _triangle_loop3
			.byte $16
			.byte cDelay($08), $19, $16, $19
			.byte $16, $19, $16
			.byte cDelay($0b), $0f
			.byte cDelay($08), $12, $0f, $12
			.byte $0f, $12, $0f
			.byte cDelay($0b), $16
			.byte cDelay($05), $16, $22, $1d
			.byte $16, $16, $22, $1d
			.byte $16, $16, $22, $1d
			.byte $19, $16, $19, $22
			.byte $0f, $0f, $1b, $16
			.byte $0f, $0f, $1b, $16
			.byte $0f, $0f, $1b, $16
			.byte $12, $0f, $12, $16
			CSF_SetLoopCount $02
_triangle_loop4:
			.byte $11
			.byte cDelay($05), $11, $11, $11
			.byte $11, $11, $11, $11
			.byte $11, $11, $11, $11
			.byte $11, $11, $11, $11
			.byte $12
			.byte cDelay($08), $0f, $12, $0f
			.byte $12, $0f, $12, $12
			CSF_Loop _triangle_loop4
			CSF_SetVoice $04
			CSF_Command $9d, $02
			CSF_SetLoopCount $01
_triangle_loop6:
			.byte $0a
			.byte cDelay($05), $16, $05, $11
			.byte $0a, $16, $05, $11
			CSF_Loop _triangle_loop5
			.byte $06
			.byte cDelay($03), $00, $06, $00
			.byte $06, $00, $06
			.byte cDelay($05), $03, $0f, $05
			.byte $11
			CSF_Jump _triangle_loop6
_triangle_loop5:
			CSF_Command $9d, $08
			.byte $06
			.byte cDelay($08), $00
			CSF_Command $9d, $02
			.byte $06
			.byte cDelay($03), $00, $06, $00
			.byte $05, $00, $05
			.byte cDelay($01), $00
			.byte cDelay($02), $05
			.byte cDelay($03)
			CSF_Command $9d, $01
			CSF_SetVoice $02
			CSF_Jump _triangle_loop7
			CSF_Stop 
_noise:
			CSF_Command $96, $7b
			CSF_Command $8a, $fe
			CSF_SetLoopCount $08
_noise_loop1:
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop1
_noise_loop8:
			CSF_SetLoopCount $02
_noise_loop2:
			.byte $00
			.byte cDelay($0b), $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Loop _noise_loop2
			CSF_SetLoopCount $07
_noise_loop3:
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop3
			.byte $00, $c0
			.byte cDelay($05), $c0
			CSF_SetLoopCount $04
_noise_loop4:
			.byte $c0
			.byte cDelay($03), $00, $c0, $c0
			CSF_Loop _noise_loop4
			.byte $00
			.byte cDelay($08), $c0, $00, $c0
			.byte cDelay($02), $c0, $00
			.byte cDelay($01), $00, $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $08
_noise_loop5:
			.byte $c0, $00, $c0, $c0
			CSF_Loop _noise_loop5
			CSF_SetLoopCount $02
_noise_loop6:
			.byte $00
			.byte cDelay($08), $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00
			.byte cDelay($05), $c0, $c0, $c0
			CSF_Loop _noise_loop6
			CSF_SetLoopCount $02
_noise_loop7:
			.byte $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop7
			CSF_Jump _noise_loop8
			CSF_Stop