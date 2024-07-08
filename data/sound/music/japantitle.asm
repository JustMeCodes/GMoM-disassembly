			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $f7
			CSF_HeaderTempo $78
			CSF_HeaderPulse 1, _pulse1

			; Triangle
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $7f, $41
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $03
			CSF_HeaderTempo $78
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $03
			CSF_HeaderTempo $78
			CSF_HeaderPulse 2, _pulse2

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0b, $00
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $78
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			CSF_SetVoice $04
			.byte $23
			.byte cDelay($01), $24
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff
			.byte $18
			.byte cDelay($08), $18, $18, $18
			.byte $18, $18, $18
_pulse1_loop2:
			CSF_SetVoice $07
			CSF_Command $8a, $01
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22, $20
			.byte $22, $24, $25, $24
			.byte $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22
			.byte cDelay($08), $25
			.byte cDelay($05), $24, $22, $20
			.byte $22, $24, $25, $24
			.byte $22
			.byte cDelay($08), $27
			.byte cDelay($05), $25, $24
			.byte cDelay($08), $27
			.byte cDelay($05), $25, $24
			.byte cDelay($08), $27
			.byte cDelay($05), $25, $24, $22
			.byte $24, $25, $27, $25
			.byte $24
			.byte cDelay($08), $27
			.byte cDelay($05), $25, $24
			.byte cDelay($08), $27
			.byte cDelay($05), $25, $24
			.byte cDelay($08), $27
			.byte cDelay($05), $25, $24, $22
			.byte $24, $25, $27, $25
			.byte $24, $27, $27, $25
			.byte $25, $24, $24, $22
			CSF_Loop _pulse1_loop1
			CSF_SetVoice $04
			.byte $28
			.byte cDelay($01), $29
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff
			.byte $18
			.byte cDelay($08), $18, $18, $18
			.byte $18
			CSF_Command $8a, $01
			.byte $23
			.byte cDelay($01), $24
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff
			.byte $18
			.byte cDelay($08)
			CSF_Command $8a, $01
			.byte $23
			.byte cDelay($01), $24
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff
			.byte $18
			.byte cDelay($08), $18, $18
			CSF_Command $8a, $01
			.byte $23
			.byte cDelay($01), $24
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff
			.byte $18
			.byte cDelay($08), $18, $18, $18
			.byte $18, $18, $18
			CSF_Command $8a, $01
			CSF_Jump _pulse1_loop2
			CSF_Stop 
_triangle:
			CSF_SetVoice $04
			.byte $1d
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0e)
_triangle_loop5:
			CSF_SetVoice $07
			CSF_SetLoopCount $03
_triangle_loop1:
			.byte $00
			.byte cDelay($0e), $00, $00
			.byte cDelay($08)
			CSF_Loop _triangle_loop1
			.byte $00
			.byte cDelay($0e), $00, $00
			.byte $83 ; Unknown command
			.byte $43
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte $31
			.byte cDelay($05), $30, $2e
			.byte cDelay($08), $31
			.byte cDelay($05), $30, $2e
			.byte cDelay($08), $31
			.byte cDelay($05), $30, $2e, $2c
			.byte $2e, $30, $31, $30
			.byte $2e
			.byte cDelay($08)
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $01
_triangle_loop4:
			.byte $33
			.byte cDelay($05), $31, $30
			.byte cDelay($08), $33
			.byte cDelay($05), $31, $30
			.byte cDelay($08), $33
			.byte cDelay($05), $31, $30, $2e
			.byte $30, $31, $33, $31
			CSF_Loop _triangle_loop3
			.byte $30
			.byte cDelay($08)
			CSF_Jump _triangle_loop4
_triangle_loop3:
			.byte $30
			.byte cDelay($05), $33, $33, $31
			.byte $31, $30, $30, $2e
			.byte $83 ; Unknown command
			.byte $40
			CSF_SetVoice $04
			.byte $30
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0b), $29
			.byte cDelay($08), $00, $29, $00
			.byte cDelay($0d), $29
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0e)
			CSF_Jump _triangle_loop5
			CSF_Stop 
_pulse2:
			.byte $00
			.byte cDelay($0e), $00
_pulse2_loop3:
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $16
			.byte cDelay($08), $16, $16, $16
			.byte $16, $16
			.byte cDelay($05), $14, $16, $00
			.byte $16, $00, $16, $16
			CSF_Loop _pulse2_loop1
			.byte $18
			.byte cDelay($08), $18, $18, $18
			.byte $18, $18
			.byte cDelay($05), $16, $18, $00
			.byte $18, $00, $18, $18
			.byte $18
			.byte cDelay($08), $18, $18, $18
			.byte $18, $18, $18, $18
			.byte cDelay($05), $18, $18, $1b
			.byte cDelay($08), $19, $18, $16
			.byte cDelay($05)
			CSF_SetLoopCount $02
_pulse2_loop2:
			.byte $16
			.byte cDelay($08), $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $16
			CSF_Loop _pulse2_loop2
			.byte $18, $18, $18, $18
			.byte $18, $18, $18, $18
			.byte $18, $18, $18, $18
			.byte $18, $18, $18, $18
			.byte $18, $18
			.byte cDelay($05), $1b
			.byte cDelay($08), $19, $18, $16
			.byte cDelay($05), $18
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0e), $00, $00, $00
			CSF_Jump _pulse2_loop3
			CSF_Stop 
_noise:
			.byte $00
			.byte cDelay($0e), $00
			.byte cDelay($0d), $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Command $8a, $fb
_noise_loop1:
			.byte $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Jump _noise_loop1
			CSF_Stop