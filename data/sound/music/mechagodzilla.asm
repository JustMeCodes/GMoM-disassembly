			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $18
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
_pulse1_loop4:
			CSF_SetLoopCount $03
_pulse1_loop1:
			.byte $25
			.byte cDelay($05), $00, $2c, $00
			.byte $25, $2d, $00, $25
			.byte $00, $2f, $00, $25
			.byte $00, $31, $00
			.byte $9c ; Unknown command
			.byte $03, $a2, $ac
			CSF_Loop _pulse1_loop1
			.byte $20
			.byte cDelay($0a), $23, $25
			.byte cDelay($08), $28, $2c, $2f
			.byte $33, $00
			.byte cDelay($0b), $00
			.byte cDelay($0a), $00
			.byte cDelay($0e)
			CSF_SetLoopCount $01
_pulse1_loop3:
			.byte $31
			.byte cDelay($05), $34, $33, $36
			.byte cDelay($08), $34
			CSF_Loop _pulse1_loop2
			.byte $33, $31, $2f, $2c
			CSF_Jump _pulse1_loop3
_pulse1_loop2:
			.byte $38, $36, $39, $38
			CSF_Jump _pulse1_loop4
_pulse2:
_pulse2_loop3:
			CSF_SetLoopCount $03
_pulse2_loop1:
			.byte $31
			.byte cDelay($05), $2c, $38, $2c
			.byte $31, $38, $2c, $31
			.byte $2f, $39, $2f, $31
			.byte $31, $25, $31
			.byte $9c ; Unknown command
			.byte $03, $a5, $ac
			CSF_Loop _pulse2_loop1
			.byte $33
			.byte cDelay($0a), $2f, $2c
			.byte cDelay($08), $28, $25, $23
			.byte $20
			CSF_SetLoopCount $03
_pulse2_loop2:
			.byte $25
			.byte cDelay($08), $28, $27
			.byte cDelay($05), $28
			.byte cDelay($08), $2a, $28, $27
			.byte $23
			CSF_Loop _pulse2_loop2
			CSF_Jump _pulse2_loop3
_triangle:
_triangle_loop3:
			CSF_SetLoopCount $03
_triangle_loop1:
			.byte $19
			.byte cDelay($08), $20, $19
			.byte cDelay($05), $21
			.byte cDelay($08), $19, $23, $19
			.byte $25
			.byte $9c ; Unknown command
			.byte $03, $a8, $ac
			CSF_Loop _triangle_loop1
			.byte $14, $14
			.byte cDelay($05), $17
			.byte cDelay($08), $17
			.byte cDelay($05), $19
			.byte cDelay($08), $1c, $20, $17
			.byte $1b
			CSF_SetLoopCount $03
_triangle_loop2:
			.byte $19
			.byte cDelay($08), $1c, $1b
			.byte cDelay($05), $1c
			.byte cDelay($08), $1e, $1c, $1b
			.byte $17
			CSF_Loop _triangle_loop2
			CSF_Jump _triangle_loop3
_noise_loop2:
_noise:
			CSF_SetLoopCount $03
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c0, $c1, $c1
			.byte $c1, $c0, $c1, $c1
			.byte $c1, $c0, $c1
			CSF_Loop _noise_loop1
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05), $00
			.byte cDelay($0b), $00
			.byte cDelay($0a), $00
			.byte cDelay($0e), $00
			.byte cDelay($0b), $00
			.byte cDelay($0a), $00
			.byte cDelay($0e), $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c0, $c1, $c1
			.byte $c1, $c0, $c1, $c0
			.byte $c1, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Jump _noise_loop2
			.byte cDelay($1b)
			.byte cDelay($1e), $07
			.byte cDelay($1b)
			.byte cDelay($1e), $07
			.byte cDelay($1b)
			.byte cDelay($1e), $07