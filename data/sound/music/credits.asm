			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3e, $40
			CSF_HeaderInitVoice $01
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $77
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop1:
			.byte $3a
			.byte cDelay($05), $00, $38, $00
			.byte $3a, $00, $38, $3a
			.byte $00, $38, $3a, $00
			.byte $3d, $00, $3c, $00
			.byte $3a, $00, $38, $00
			.byte $3a, $00, $38, $33
			.byte $00, $33
			.byte cDelay($0d), $00
			.byte cDelay($05), $3a, $00, $38
			.byte $00, $3a, $00, $38
			.byte $3a, $00, $38, $3a
			.byte $00, $3d, $00, $3c
			.byte $00, $3a, $00, $38
			.byte $00, $3a, $00, $3f
			.byte $3f, $00, $3f
			.byte cDelay($0b), $3c
			.byte cDelay($05), $3d, $00, $3f
			.byte $00, $41
			.byte cDelay($0e), $41
			.byte cDelay($08), $3f, $3d, $3c
			.byte $3f
			.byte cDelay($0d), $3d
			.byte cDelay($05), $3c, $3d
			.byte cDelay($0e), $3f, $3f
			.byte cDelay($08), $3d, $3c
			.byte cDelay($05), $3a
			.byte cDelay($0a), $38
			.byte cDelay($00), $60, $3a
			.byte cDelay($05), $38, $3a, $3d
			.byte $00, $41, $46, $00
			.byte $46
			.byte cDelay($0e), $38
			.byte cDelay($05), $36, $38, $3c
			.byte $00, $3f, $44, $00
			.byte $44
			.byte cDelay($0e), $3a
			.byte cDelay($05), $38, $3a, $3d
			.byte $00, $41, $46, $00
			.byte $46
			.byte cDelay($0b), $49
			.byte cDelay($08), $48, $46
			.byte cDelay($0d), $48
			.byte cDelay($08), $3f
			.byte cDelay($0e), $42
			.byte cDelay($0d), $44
			.byte cDelay($05), $42, $42
			.byte cDelay($08), $41, $3f, $3d
			.byte $41
			.byte cDelay($0d), $3d
			.byte cDelay($08), $38
			.byte cDelay($0e), $3f
			.byte cDelay($0d), $41
			.byte cDelay($05), $3f, $3f
			.byte cDelay($08), $41, $42, $44
			.byte $3d
			.byte cDelay($0e), $44
			CSF_Jump _pulse1_loop1
_pulse2:
_pulse2_loop2:
			.byte $29
			.byte cDelay($00), $60, $27
			.byte cDelay($0e), $00
			.byte cDelay($05), $27
			.byte cDelay($00), $2a, $29
			.byte cDelay($00), $60, $27
			.byte cDelay($00), $6c, $29
			.byte cDelay($00), $60, $2a, $2a
			.byte $27
			CSF_SetVoice $04
			.byte $83 ; Unknown command
			.byte $00
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $35
			.byte cDelay($05), $31, $2e, $2a
			.byte $35, $31, $2e, $2a
			.byte $35, $31, $2e, $2a
			.byte $35, $31, $35, $3a
			.byte $33, $30, $2c, $29
			.byte $33, $30, $2c, $29
			.byte $33, $30, $2c, $29
			.byte $33, $30, $2c, $29
			CSF_Loop _pulse2_loop1
			CSF_SetVoice $01
			.byte $83 ; Unknown command
			.byte $41, $2a
			.byte cDelay($00), $60, $29
			.byte cDelay($0e), $29
			.byte cDelay($08), $2c, $31, $35
			.byte $27
			.byte cDelay($00), $60, $25
			.byte cDelay($0e), $19
			.byte cDelay($0a), $1d
			.byte cDelay($05), $20, $25, $29
			.byte $2c
			CSF_Jump _pulse2_loop2
_triangle_loop1:
_triangle:
			.byte $25
			.byte cDelay($00), $60, $24
			.byte cDelay($0e), $00
			.byte cDelay($05), $24
			.byte cDelay($00), $2a, $25
			.byte cDelay($00), $60, $24
			.byte cDelay($00), $6c, $21
			.byte cDelay($08), $1d, $24, $21
			.byte $27, $25, $24, $21
			.byte $25
			.byte cDelay($0e), $22, $1e
			.byte cDelay($08), $1b, $22, $1e
			.byte $27, $25, $24, $22
			.byte $20
			.byte cDelay($0e), $24, $25
			.byte cDelay($00), $60, $24, $25
			.byte $24, $27, $25, $23
			.byte $20
			CSF_Jump _triangle_loop1
_noise_loop6:
_noise:
			CSF_Command $8a, $fb
			CSF_SetLoopCount $03
_noise_loop1:
			.byte $c0
			.byte cDelay($08), $c0
			CSF_Command $8a, $05
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb
			.byte $c0, $00, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			.byte cDelay($08)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Loop _noise_loop1
			.byte $c0, $c0
			CSF_Command $8a, $05
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb
			.byte $c0, $00, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			.byte cDelay($08)
			CSF_Command $8a, $05
			.byte $c0
			.byte cDelay($05)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0, $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_SetLoopCount $07
_noise_loop2:
			.byte $c0
			.byte cDelay($08), $c0
			CSF_Command $8a, $05
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Loop _noise_loop2
			.byte $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c0
			.byte cDelay($05)
			CSF_Command $8a, $fb
			.byte $c0, $c0
			CSF_Command $8a, $05
			.byte $c0, $00, $c0, $c0
			.byte $00, $c0
			.byte cDelay($08)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			CSF_Loop _noise_loop3
			CSF_SetLoopCount $02
_noise_loop4:
			.byte $c0
			.byte cDelay($08)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			CSF_Loop _noise_loop4
			CSF_Command $8a, $fb
			CSF_SetLoopCount $07
_noise_loop5:
			.byte $c0
			.byte cDelay($08), $c0
			CSF_Command $8a, $05
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Loop _noise_loop5
			.byte $c0, $c0
			CSF_Command $8a, $05
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Jump _noise_loop6