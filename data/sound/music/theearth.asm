			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $69
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $69
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $18
			CSF_HeaderTempo $69
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $69
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1_loop3:
_pulse1:
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte $2c
			.byte cDelay($03), $00, $25, $2a
			.byte $00, $2c, $25, $00
			.byte $2a, $00, $2c, $00
			.byte $2f, $00, $2f, $2e
			.byte $00, $2e, $00
			CSF_Loop _pulse1_loop1
			.byte $2a
			.byte cDelay($0b), $28, $27
			.byte cDelay($0e), $25
			.byte cDelay($03), $00, $23, $25
			.byte $00, $23, $25, $00
			.byte $25, $00, $23, $25
			.byte $00, $23, $25, $00
			.byte $2a, $00, $28, $2a
			.byte $00, $28, $2a, $00
			.byte $2a, $00, $28, $2a
			.byte $00, $28, $2a, $00
			CSF_SetLoopCount $02
_pulse1_loop2:
			.byte $2f
			.byte cDelay($03), $2e, $2a, $2f
			.byte $2e, $2a, $2f, $2e
			CSF_Loop _pulse1_loop2
			.byte $33, $31, $2c, $33
			.byte $31, $2c, $33, $31
			.byte $36, $35, $31, $36
			.byte $35, $31, $36, $35
			.byte $31
			.byte cDelay($0b), $33, $2f, $31
			.byte $2e
			.byte cDelay($0e), $2e
			.byte cDelay($03), $2e, $00, $2e
			.byte $00, $2e, $2e, $00
			.byte cDelay($0a)
			CSF_Command $96, $59
			.byte $00
			.byte cDelay($07), $27, $28, $23
			.byte cDelay($03), $00, $2f, $00
			.byte $2e
			.byte cDelay($00), $12, $2c
			.byte cDelay($03), $00, $2a, $00
			.byte $27
			.byte cDelay($07), $28, $23
			.byte cDelay($03), $00, $1e
			.byte cDelay($0b), $20
			.byte cDelay($07), $21, $1e
			.byte cDelay($03), $00, $28, $00
			.byte $27
			.byte cDelay($00), $12, $25
			.byte cDelay($03), $00, $23, $00
			.byte $25
			.byte cDelay($0b), $27
			.byte cDelay($08), $00, $28
			.byte cDelay($07), $2a, $27
			.byte cDelay($03), $00, $34, $00
			.byte $33
			.byte cDelay($00), $12, $31
			.byte cDelay($03), $00, $2f, $00
			.byte $2c
			.byte cDelay($07), $2d, $28
			.byte cDelay($03), $00, $25
			.byte cDelay($0b), $2d
			.byte cDelay($07), $2c, $2a
			.byte cDelay($03), $00, $28
			.byte cDelay($00), $15, $00
			.byte cDelay($03), $27, $00, $23
			.byte $00, $25
			.byte cDelay($0b), $2c
			.byte cDelay($08)
			CSF_Command $96, $69
			.byte $00
			CSF_Jump _pulse1_loop3
_pulse2_loop3:
_pulse2:
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $28
			.byte cDelay($03), $00, $00, $27
			.byte $00, $28, $00, $00
			.byte $27, $00, $28, $00
			.byte $2c, $00, $2c, $2a
			.byte $00, $2a, $00
			CSF_Loop _pulse2_loop1
			.byte $26
			.byte cDelay($0b), $21, $20
			.byte cDelay($0e), $00
			CSF_SetLoopCount $03
_pulse2_loop2:
			.byte $25
			.byte cDelay($03), $00, $25, $25
			.byte $00, $25, $25, $00
			.byte $25, $00, $25, $25
			.byte $00, $25, $25, $00
			CSF_Loop _pulse2_loop2
			.byte $2d
			.byte cDelay($0b), $2f, $2c, $2a
			.byte $2a
			.byte cDelay($0e), $25
			.byte cDelay($03), $25, $00, $25
			.byte $00, $25, $25, $00
			.byte cDelay($0a)
			CSF_Command $96, $59
			.byte $00
			.byte cDelay($07), $00
			.byte cDelay($03), $00
			CSF_Command $8a, $fb
			.byte $27
			.byte cDelay($07), $28, $23
			.byte cDelay($03), $00, $2f, $00
			.byte $2e
			.byte cDelay($00), $12, $2c
			.byte cDelay($03), $00, $2a, $00
			.byte $27
			.byte cDelay($07), $28, $23
			.byte cDelay($03), $00, $1e
			.byte cDelay($0b), $20
			.byte cDelay($07), $21, $1e
			.byte cDelay($03), $00, $28, $00
			.byte $27
			.byte cDelay($00), $12, $25
			.byte cDelay($03), $00, $23, $00
			.byte $25
			.byte cDelay($0b), $27
			.byte cDelay($08)
			CSF_Command $8a, $02
			.byte $00, $28
			.byte cDelay($07), $2a, $27
			.byte cDelay($03), $00, $34, $00
			.byte $33
			.byte cDelay($00), $12, $31
			.byte cDelay($03), $00, $2f, $00
			.byte $2c
			.byte cDelay($07), $2d, $28
			.byte cDelay($03), $00, $25
			.byte cDelay($0a)
			CSF_Command $8a, $03
			.byte $2a
			.byte cDelay($07), $28, $27
			.byte cDelay($03), $00, $25
			.byte cDelay($00), $15, $00
			.byte cDelay($03), $23, $00, $20
			.byte $00, $22
			.byte cDelay($0b), $24
			.byte cDelay($08)
			CSF_Command $96, $69
			.byte $00
			CSF_Jump _pulse2_loop3
_triangle_loop7:
_triangle:
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte $19
			.byte cDelay($03), $00, $19, $19
			.byte $00, $19, $19, $00
			.byte $19, $00, $19, $00
			.byte $19, $00, $19, $19
			.byte $00, $19, $00
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte $15
			.byte cDelay($03), $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $9c ; Unknown command
			.byte $02, $67
			.byte $91 ; Unknown command
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $04
_triangle_loop3:
			.byte $19
			.byte cDelay($03), $00, $17, $19
			.byte $00, $17, $19, $00
			.byte $19, $00, $17, $19
			.byte $00, $17, $19, $00
			CSF_Loop _triangle_loop3
			CSF_SetLoopCount $03
_triangle_loop4:
			.byte $15
			.byte cDelay($03), $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $9c ; Unknown command
			.byte $03, $69
			.byte $91 ; Unknown command
			CSF_Loop _triangle_loop4
			.byte $12, $12, $00, $12
			.byte $00, $12, $12, $00
			.byte cDelay($0a)
			CSF_Command $96, $59
			.byte $12
			.byte cDelay($03), $12, $12
			CSF_SetLoopCount $01
_triangle_loop6:
			.byte $19
			.byte cDelay($03), $00, $19, $19
			.byte $00, $19, $19, $00
			.byte $19, $00, $19, $00
			.byte $19, $19, $00, $19
			.byte $19, $00, $19, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $12, $00, $12, $12
			.byte $00, $12, $12, $00
			.byte $12, $00, $12, $00
			.byte $12, $12, $00, $12
			.byte $12, $00, $12, $00
			CSF_Loop _triangle_loop5
			.byte $14, $00, $14, $14
			.byte $00, $14, $14, $00
			.byte $14, $00, $14, $14
			.byte $00, $14, $14, $00
			CSF_Jump _triangle_loop6
_triangle_loop5:
			.byte $14, $00, $14, $14
			.byte $00, $14, $14, $00
			.byte $14, $00, $14, $14
			CSF_Command $96, $69
			.byte $00
			.byte cDelay($08)
			CSF_Jump _triangle_loop7
_noise:
_noise_loop6:
			CSF_SetLoopCount $02
_noise_loop1:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c0, $c1
			CSF_Loop _noise_loop1
			CSF_SetLoopCount $02
_noise_loop2:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop2
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop3
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop4:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop4
			.byte $c0, $c0, $00, $c0
			.byte $00, $c0, $c0, $00
			.byte $00, $00, $00, $00
			.byte $00
			CSF_Command $96, $59
			.byte $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop5:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop5
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $00, $00, $00
			CSF_Command $96, $69
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop6
			CSF_Stop 
			.byte cDelay($1f), $01
			.byte cDelay($1f)
			.byte cDelay($1e), $03