			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $02
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $02
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $1a
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

_pulse1:
_pulse1_loop1:
			.byte $25
			.byte cDelay($0b), $00
			.byte cDelay($05), $25, $22, $23
			.byte $24
			.byte cDelay($0e), $23
			.byte cDelay($0b), $00
			.byte cDelay($05), $23, $20, $21
			.byte $22
			.byte cDelay($0b), $00
			.byte cDelay($05), $22, $23, $24
			.byte $25
			.byte cDelay($0b), $00
			.byte cDelay($05), $25, $22, $23
			.byte $24
			.byte cDelay($0b), $2a, $23, $00
			.byte cDelay($05), $23, $20, $21
			.byte $22
			.byte cDelay($0e), $00
			.byte cDelay($05), $22, $25, $29
			.byte $2c
			.byte cDelay($08), $2b, $2a
			.byte cDelay($03), $00, $26
			.byte cDelay($08), $23, $25
			.byte cDelay($03), $00, $26
			.byte cDelay($08), $00
			.byte cDelay($05), $22, $25, $29
			.byte $2c
			.byte cDelay($08), $2b, $2a
			.byte cDelay($0b), $26, $24
			.byte cDelay($08), $27, $2b, $2e
			.byte $2d
			.byte cDelay($0b), $2a, $27
			.byte cDelay($00), $48, $00
			.byte cDelay($0b)
			CSF_Jump _pulse1_loop1
_pulse2:
			.byte $00
			.byte cDelay($07)
_pulse2_loop1:
			.byte $25
			.byte cDelay($0b), $00
			.byte cDelay($05), $25, $22, $23
			.byte $24
			.byte cDelay($0e), $23
			.byte cDelay($0b), $00
			.byte cDelay($05), $23, $20, $21
			.byte $22
			.byte cDelay($0b), $00
			.byte cDelay($05), $22, $23, $24
			.byte $25
			.byte cDelay($0b), $00
			.byte cDelay($05), $25, $22, $23
			.byte $24
			.byte cDelay($0b), $2a, $23, $00
			.byte cDelay($05), $23, $20, $21
			.byte $22
			.byte cDelay($0e), $00
			.byte cDelay($05), $22, $25, $29
			.byte $2c
			.byte cDelay($08), $2b, $2a
			.byte cDelay($03), $00, $26
			.byte cDelay($08), $23, $25
			.byte cDelay($03), $00, $26
			.byte cDelay($08), $00
			.byte cDelay($05), $22, $25, $29
			.byte $2c
			.byte cDelay($08), $2b, $2a
			.byte cDelay($0b), $26, $24
			.byte cDelay($08), $27, $2b, $2e
			.byte $2d
			.byte cDelay($0b), $2a, $27
			.byte cDelay($00), $48, $00
			.byte cDelay($0b)
			CSF_Jump _pulse2_loop1
_triangle:
_triangle_loop1:
			.byte $19
			.byte cDelay($05), $19, $19, $19
			.byte $19, $19, $19, $19
			.byte $18, $18, $18, $18
			.byte $18, $18, $18, $18
			.byte $17, $17, $17, $17
			.byte $17, $17, $17, $17
			.byte $16, $16, $16, $16
			.byte $16, $16, $17, $18
			.byte $19, $19, $19, $19
			.byte $19, $19, $19, $19
			.byte $18, $18, $18, $18
			.byte $18, $18, $18, $18
			.byte $17, $17, $17, $17
			.byte $17, $17, $17, $17
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $17, $17, $17, $17
			.byte $17, $17, $17, $17
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $17, $17, $17, $17
			.byte $17, $17, $17, $17
			.byte $18, $18, $18, $18
			.byte $18, $18, $18, $18
			.byte $12, $12, $12, $12
			.byte $12, $12, $12, $12
			.byte $14, $14, $14, $14
			.byte $14, $14, $14, $14
			.byte $14, $14, $14, $14
			.byte $14, $14, $14, $14
			CSF_Jump _triangle_loop1
_noise:
			CSF_Command $8a, $fb
_noise_loop4:
			CSF_SetLoopCount $03
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop1
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_SetLoopCount $03
_noise_loop2:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop2
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $fb
			CSF_SetLoopCount $07
_noise_loop3:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop3
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Command $8a, $05
			.byte $c0
			CSF_Command $8a, $fb
			.byte $c0
			CSF_Jump _noise_loop4