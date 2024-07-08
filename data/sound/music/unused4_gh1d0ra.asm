			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0f
			CSF_HeaderTempo $aa
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $03
			CSF_HeaderTempo $aa
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $0f
			CSF_HeaderTempo $aa
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $00
			CSF_HeaderTempo $aa
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $03
_pulse1_loop1:
			.byte $25
			.byte cDelay($07), $28
			.byte cDelay($03), $00, $25, $00
			.byte cDelay($07), $25, $28
			.byte cDelay($03), $00, $25, $00
			.byte cDelay($07), $25, $28
			.byte cDelay($03), $00, $25
			.byte $9c ; Unknown command
			.byte $03, $04, $b5
			CSF_Loop _pulse1_loop1
			CSF_SetLoopCount $02
_pulse1_loop2:
			.byte $35
			.byte cDelay($04), $34, $33, $32
			.byte $31, $30, $2f, $2e
			.byte $2d, $2c, $2b, $2a
			.byte $29, $28, $27, $26
			.byte $25, $24
			.byte $9c ; Unknown command
			.byte $02, $07, $b5
			CSF_Loop _pulse1_loop2
			.byte $29
			.byte cDelay($00), $48
			CSF_Jump _pulse1_loop3
_pulse2:
_pulse2_loop3:
			CSF_SetLoopCount $03
_pulse2_loop1:
			.byte $25
			.byte cDelay($07), $28
			.byte cDelay($03), $00, $25, $00
			.byte cDelay($07), $25, $28
			.byte cDelay($03), $00, $25, $00
			.byte cDelay($07), $25, $28
			.byte cDelay($03), $00, $25
			.byte $9c ; Unknown command
			.byte $03, $09, $b5
			CSF_Loop _pulse2_loop1
			.byte $00
			.byte cDelay($00), $24
			CSF_SetLoopCount $02
_pulse2_loop2:
			.byte $35
			.byte cDelay($04), $34, $33, $32
			.byte $31, $30, $2f, $2e
			.byte $2d, $2c, $2b, $2a
			.byte $29, $28, $27, $26
			.byte $25, $24
			.byte $9c ; Unknown command
			.byte $02, $0c, $b5
			CSF_Loop _pulse2_loop2
			.byte $21
			.byte cDelay($04), $20, $1f, $1e
			.byte $1d, $1c, $1b, $1b
			.byte $1a
			CSF_Jump _pulse2_loop3
_triangle:
_triangle_loop2:
			.byte $19
			.byte cDelay($04), $19, $1c, $19
			.byte $1f, $19, $19, $19
			.byte $1c, $19, $1f, $19
			.byte $19, $19, $1c, $19
			.byte $1f, $19, $1c, $1c
			.byte $1f, $1c, $21, $1c
			.byte $1c, $1c, $1f, $1c
			.byte $21, $1c, $1c, $1c
			.byte $1f, $1c, $21, $1c
			.byte $1e, $1e, $21, $1e
			.byte $24, $1e, $1e, $1e
			.byte $21, $1e, $24, $1e
			.byte $1e, $1e, $21, $1e
			.byte $24, $1e
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte $20
			.byte cDelay($04), $21, $22, $23
			.byte $24, $25, $26, $27
			.byte $28, $29, $2a, $2b
			.byte $2c, $2d, $2e, $2f
			.byte $30, $31
			.byte $9c ; Unknown command
			.byte $02, $0e, $b5
			CSF_Loop _triangle_loop1
			.byte $2a, $29, $28, $27
			.byte $26, $25, $24, $23
			.byte $22, $21, $20, $1f
			.byte $1e, $1d, $1c, $1b
			.byte $1a, $19
			CSF_Jump _triangle_loop2
_noise:
_noise_loop4:
			CSF_SetLoopCount $0c
_noise_loop1:
			.byte $c0
			.byte cDelay($07), $c1
			.byte cDelay($03), $c1, $c1
			CSF_Loop _noise_loop1
			CSF_SetLoopCount $05
_noise_loop2:
			.byte $c0
			.byte cDelay($04), $c0, $c1
			CSF_Loop _noise_loop2
			.byte $c0, $c0, $c0
			CSF_SetLoopCount $05
_noise_loop3:
			.byte $c0
			.byte cDelay($04), $c0, $c1
			CSF_Loop _noise_loop3
			.byte $c0, $c0, $c0, $c0
			.byte cDelay($07), $c1, $c0, $c1
			.byte $c0, $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0
			.byte cDelay($05)
			CSF_Jump _noise_loop4
			.byte $03, $02
			.byte cDelay($1b)
			.byte cDelay($1c), $04, $03, $02
			.byte cDelay($1b)
			.byte cDelay($1c), $04, $04
			.byte cDelay($1c)