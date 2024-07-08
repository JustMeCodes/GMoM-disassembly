			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $04
			CSF_HeaderTempo $73
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $07
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $04
			CSF_HeaderTempo $73
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $10
			CSF_HeaderTempo $73
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $73
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
_pulse1_loop1:
			.byte $2c
			.byte cDelay($0a), $34, $33
			.byte cDelay($08), $32
			.byte cDelay($0a), $33, $2f
			.byte cDelay($08), $2a
			.byte cDelay($0a), $2d
			.byte cDelay($00), $1e, $31
			.byte cDelay($0a), $2d, $34
			.byte cDelay($08), $33
			.byte cDelay($0a), $32, $2f
			.byte cDelay($08), $2c
			.byte cDelay($0a), $28, $27
			.byte cDelay($08), $2e
			.byte cDelay($0a), $31
			.byte cDelay($00), $1e, $34
			.byte cDelay($0a), $33
			.byte cDelay($00), $1e, $2c
			.byte cDelay($00), $c0
			CSF_Jump _pulse1_loop1
_pulse2:
			.byte $00
			.byte cDelay($04)
_pulse2_loop1:
			.byte $2c
			.byte cDelay($0a), $34, $33
			.byte cDelay($08), $32
			.byte cDelay($0a), $33, $2f
			.byte cDelay($08), $2a
			.byte cDelay($0a), $2d
			.byte cDelay($00), $1e, $31
			.byte cDelay($0a), $2d, $34
			.byte cDelay($08), $33
			.byte cDelay($0a), $32, $2f
			.byte cDelay($08), $2c
			.byte cDelay($0a), $28, $27
			.byte cDelay($08), $2e
			.byte cDelay($0a), $31
			.byte cDelay($00), $1e, $34
			.byte cDelay($0a), $33
			.byte cDelay($00), $1e, $00
			.byte cDelay($0e), $00, $00, $00
			CSF_Jump _pulse2_loop1
_triangle:
_triangle_loop6:
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte $20
			.byte cDelay($03), $20, $23, $20
			.byte $27, $20, $20, $20
			.byte $23, $20, $27, $20
			.byte $20, $20, $23, $20
			CSF_Loop _triangle_loop1
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte $1e
			.byte cDelay($03), $1e, $21, $1e
			.byte $25, $1e, $1e, $1e
			.byte $21, $1e, $25, $1e
			.byte $1e, $1e, $21, $1e
			CSF_Loop _triangle_loop2
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte $20
			.byte cDelay($03), $20, $23, $20
			.byte $27, $20, $20, $20
			.byte $23, $20, $27, $20
			.byte $20, $20, $23, $20
			CSF_Loop _triangle_loop3
			CSF_SetLoopCount $02
_triangle_loop4:
			.byte $22
			.byte cDelay($03), $22, $25, $22
			.byte $27, $22, $22, $22
			.byte $25, $22, $27, $22
			.byte $22, $22, $25, $22
			CSF_Loop _triangle_loop4
			CSF_SetLoopCount $04
_triangle_loop5:
			.byte $20
			.byte cDelay($03), $20, $23, $20
			.byte $25, $20, $20, $20
			.byte $23, $20, $25, $20
			.byte $20, $20, $23, $20
			CSF_Loop _triangle_loop5
			CSF_Jump _triangle_loop6
_noise_loop3:
_noise:
			CSF_SetLoopCount $07
_noise_loop1:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c1, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Loop _noise_loop1
			.byte $c0, $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c1
			.byte $c0, $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop2:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Loop _noise_loop2
			.byte $c0, $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c1
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop3