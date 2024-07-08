			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fe
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0d
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $f9
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $16
			CSF_HeaderTempo $9e
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $9e
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop2:
			.byte $31
			.byte cDelay($0e), $34
			.byte cDelay($0b), $33
			.byte cDelay($08), $37, $38
			.byte cDelay($00), $60, $3b
			.byte cDelay($0e), $38
			.byte cDelay($0a), $36, $34
			.byte cDelay($08), $38
			.byte cDelay($00), $60, $31
			.byte cDelay($0e), $34
			.byte cDelay($0b), $33
			.byte cDelay($08), $37, $38
			.byte cDelay($00), $60
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte $34
			.byte cDelay($0a), $33, $31, $2f
			.byte cDelay($08), $2c
			CSF_Loop _pulse1_loop1
			.byte $38
			.byte cDelay($0a), $36, $34, $33
			.byte cDelay($08), $2f, $31
			.byte cDelay($00), $48, $00
			.byte cDelay($00), $18, $31
			.byte cDelay($0e), $38
			.byte cDelay($0a), $36, $34
			.byte cDelay($08), $33
			.byte cDelay($0e), $2f, $2d, $31
			.byte cDelay($0a), $2f, $2d
			.byte cDelay($08), $2c
			.byte cDelay($0e), $2f, $31, $38
			.byte cDelay($0a), $36, $34
			.byte cDelay($08), $3b
			.byte cDelay($0e), $38, $3d
			.byte cDelay($06), $3b, $39, $38
			.byte $36, $34, $38
			.byte cDelay($0e), $33
			CSF_Jump _pulse1_loop2
_pulse2_loop2:
_pulse2:
			.byte $31
			.byte cDelay($0e), $34
			.byte cDelay($0a), $33, $2f
			.byte cDelay($08), $2c
			.byte cDelay($0e), $2a
			.byte cDelay($0a), $2f, $2c
			.byte cDelay($08), $31
			.byte cDelay($0e), $34
			.byte cDelay($0a), $33, $2c
			.byte cDelay($08)
			CSF_SetVoice $04
			CSF_Command $8a, $01
			.byte $25
			.byte cDelay($0a), $26, $27
			.byte cDelay($08), $28, $29, $2a
			.byte $2c
			CSF_SetVoice $09
			CSF_Command $8a, $ff
			.byte $31
			.byte cDelay($0e), $34
			.byte cDelay($0a), $33, $2f
			.byte cDelay($08), $2c
			.byte cDelay($0a), $2d, $2a
			.byte cDelay($08), $2c
			.byte cDelay($0a), $28, $25
			.byte cDelay($08)
			CSF_Command $8a, $01
			.byte $89 ; Unknown command
			.byte $0c
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $00
			.byte cDelay($05), $1c, $28, $00
			.byte $1b, $27, $00, $19
			.byte $25, $17
			.byte cDelay($08), $20
			CSF_Loop _pulse2_loop1
			.byte $00
			.byte cDelay($05), $20, $2c, $00
			.byte $1e, $2a, $00, $1c
			.byte $28, $1b
			.byte cDelay($08), $23
			.byte $89 ; Unknown command
			.byte cDelay($14), $31
			.byte cDelay($00), $60
			CSF_SetVoice $07
			CSF_Command $8a, $fe
			.byte $31
			.byte cDelay($0e), $38
			.byte cDelay($0a), $36, $34
			.byte cDelay($08), $33
			.byte cDelay($0e), $2f, $2d, $31
			.byte cDelay($0a), $2f, $2d
			.byte cDelay($08), $2c
			.byte cDelay($0e), $2f, $31, $38
			.byte cDelay($0a), $36, $34
			.byte cDelay($08), $3b
			.byte cDelay($0e), $38, $3d
			.byte cDelay($06), $3b, $39, $38
			.byte $36, $34, $38
			.byte cDelay($0e), $33
			CSF_Jump _pulse2_loop2
_triangle_loop17:
_triangle:
			CSF_SetLoopCount $10
_triangle_loop1:
			.byte $19
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $10
_triangle_loop2:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $10
_triangle_loop3:
			.byte $17
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop3
			CSF_SetLoopCount $10
_triangle_loop4:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop4
			CSF_SetLoopCount $10
_triangle_loop5:
			.byte $19
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop5
			CSF_SetLoopCount $10
_triangle_loop6:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop6
			CSF_SetLoopCount $02
_triangle_loop7:
			.byte $1c
			.byte cDelay($03), $00, $1c
			.byte cDelay($05), $00, $1b
			.byte cDelay($03), $00, $1b
			.byte cDelay($05), $00, $19
			.byte cDelay($03), $00, $19
			.byte cDelay($05), $00, $17, $00
			.byte $14, $00
			CSF_Loop _triangle_loop7
			.byte $14
			.byte cDelay($03), $00, $14
			.byte cDelay($05), $00, $19
			.byte cDelay($03), $00, $19
			.byte cDelay($05), $00, $1c
			.byte cDelay($03), $00, $1c
			.byte cDelay($05), $00, $1b, $00
			.byte $17, $00
			CSF_SetLoopCount $08
_triangle_loop8:
			.byte $19
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop8
			.byte $00
			.byte cDelay($0e)
			CSF_SetLoopCount $10
_triangle_loop9:
			.byte $19
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop9
			CSF_SetLoopCount $10
_triangle_loop10:
			.byte $1b
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop10
			CSF_SetLoopCount $10
_triangle_loop11:
			.byte $1c
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop11
			CSF_SetLoopCount $10
_triangle_loop12:
			.byte $1b
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop12
			CSF_SetLoopCount $10
_triangle_loop13:
			.byte $1c
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop13
			CSF_SetLoopCount $10
_triangle_loop14:
			.byte $17
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop14
			.byte $17
			.byte cDelay($04), $00, $21, $00
			.byte $14, $00, $19, $00
			.byte $1c, $00, $1b, $00
			CSF_SetLoopCount $08
_triangle_loop15:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop15
			CSF_SetLoopCount $08
_triangle_loop16:
			.byte $1b
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop16
			CSF_Jump _triangle_loop17
_noise:
_noise_loop4:
			CSF_SetLoopCount $0c
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop1
			CSF_SetLoopCount $02
_noise_loop2:
			.byte $c0
			.byte cDelay($05), $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c0
			.byte $c0
			CSF_Loop _noise_loop2
			.byte $c0, $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c0
			.byte $c0, $c0
			.byte cDelay($0a), $c0, $c0
			.byte cDelay($05), $c0, $00
			.byte cDelay($0b), $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0, $c0
			.byte cDelay($05)
			CSF_SetLoopCount $0c
_noise_loop3:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop3
			.byte $c0, $c1
			.byte cDelay($03), $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c0, $c0, $c0
			.byte cDelay($05), $c1, $c1, $c0
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c0, $c1, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Jump _noise_loop4