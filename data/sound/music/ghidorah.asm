			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $f3
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0d
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $ff
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $17
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop3:
			.byte $2c
			.byte cDelay($00), $2a, $2e
			.byte cDelay($05), $2f
			.byte cDelay($0b), $36
			.byte cDelay($08), $35, $34
			.byte cDelay($0e), $3b
			.byte cDelay($0d), $00
			.byte cDelay($08), $2b
			.byte cDelay($00), $2a, $2d
			.byte cDelay($05), $2e
			.byte cDelay($0b), $35
			.byte cDelay($08), $34, $33
			.byte cDelay($0e), $2e
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte $2f
			.byte cDelay($05), $2e, $2c
			.byte cDelay($08), $2f
			.byte cDelay($05), $2e, $2c
			.byte cDelay($08), $2f
			.byte cDelay($05), $2e, $2f, $31
			.byte cDelay($08), $2f
			.byte cDelay($05), $2e, $2c
			CSF_Loop _pulse1_loop1
			.byte $31, $2f, $2e
			.byte cDelay($08), $31
			.byte cDelay($05), $2f, $2e
			.byte cDelay($08), $31
			.byte cDelay($05), $2f, $31, $33
			.byte cDelay($08), $31
			.byte cDelay($05), $2f, $2e
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $2e, $2f, $31, $33
			.byte $34, $36, $38, $3a
			.byte $3b
			.byte cDelay($0b), $3a
			CSF_Jump _pulse1_loop3
_pulse2:
_pulse2_loop3:
			CSF_SetLoopCount $08
_pulse2_loop1:
			.byte $20
			.byte cDelay($03), $20, $2c, $20
			.byte $20, $2c, $20, $20
			.byte $2c, $20, $20, $2c
			.byte $20, $2c, $20, $20
			.byte $9c ; Unknown command
			.byte $08, $24, $af
			CSF_Loop _pulse2_loop1
			CSF_SetLoopCount $08
_pulse2_loop2:
			.byte $20
			.byte cDelay($03), $2c, $20, $2c
			.byte $20, $2c, $20, $2c
			.byte $20, $2c, $20, $2c
			.byte $20, $2c, $20, $2c
			.byte $9c ; Unknown command
			.byte $08, $2c, $af
			CSF_Loop _pulse2_loop2
			CSF_Jump _pulse2_loop3
_triangle:
_triangle_loop5:
			CSF_SetLoopCount $04
_triangle_loop1:
			.byte $17
			.byte cDelay($05), $16, $14, $14
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $04
_triangle_loop2:
			.byte $14
			.byte cDelay($05), $12, $10, $10
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $08
_triangle_loop3:
			.byte $16
			.byte cDelay($05), $15, $13, $13
			.byte $9c ; Unknown command
			.byte $08, $34, $af
			CSF_Loop _triangle_loop3
			CSF_SetLoopCount $08
_triangle_loop4:
			.byte $14
			.byte cDelay($05), $14, $14, $14
			.byte $14, $14, $14, $14
			.byte $9c ; Unknown command
			.byte $08, $3c, $af
			CSF_Loop _triangle_loop4
			CSF_Jump _triangle_loop5
_noise:
_noise_loop1:
			CSF_Command $8a, $fb
			.byte $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Command $8a, $05
			.byte $c0
			.byte cDelay($03)
			CSF_Command $8a, $fb
			.byte $c0, $c0
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Command $8a, $05
			.byte $c0
			.byte cDelay($03)
			CSF_Command $8a, $fb
			.byte $c0, $c0
			.byte cDelay($05)
			CSF_Command $8a, $05
			CSF_Jump _noise_loop1
			.byte $00
			.byte cDelay($1c), $00, $03, $00
			.byte cDelay($1c), $00, $05, $00
			.byte $02, $00
			.byte cDelay($1e), $00, $02, $00
			.byte cDelay($1e), $00, $00, $00
			.byte cDelay($1c), $00, $00, $00
			.byte $04, $00, $02, $00
			.byte cDelay($1e), $00, $02, $00
			.byte cDelay($1e)