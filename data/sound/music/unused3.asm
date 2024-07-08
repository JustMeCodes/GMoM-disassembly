			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $08
			CSF_HeaderTempo $66
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0d
			CSF_HeaderInitVoice $03
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $08
			CSF_HeaderTempo $66
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $08
			CSF_HeaderTempo $66
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $00
			CSF_HeaderTempo $66
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1_loop1:
_pulse1:
			.byte $33
			.byte cDelay($0a), $34
			.byte cDelay($05), $32, $00, $33
			.byte cDelay($0a), $36
			.byte cDelay($05), $34, $00, $33
			.byte cDelay($0a), $32
			.byte cDelay($05), $2f, $00, $2c
			.byte cDelay($0d), $38
			.byte cDelay($0a), $37
			.byte cDelay($05), $34, $00, $33
			.byte cDelay($0d), $33
			.byte cDelay($0a), $2f
			.byte cDelay($05), $32, $00, $33
			.byte cDelay($0d), $2c
			.byte cDelay($0a), $2f
			.byte cDelay($05), $2c, $00, $32
			.byte cDelay($0b), $2f
			.byte cDelay($08), $2c, $2f, $32
			.byte $33
			.byte cDelay($0d)
			CSF_Jump _pulse1_loop1
_pulse2:
_pulse2_loop11:
			CSF_SetLoopCount $09
_pulse2_loop1:
			.byte $38
			.byte cDelay($03), $3b, $3d, $3b
			CSF_Loop _pulse2_loop1
			CSF_SetLoopCount $03
_pulse2_loop2:
			.byte $33
			.byte cDelay($03), $37, $3a, $37
			CSF_Loop _pulse2_loop2
			CSF_SetLoopCount $03
_pulse2_loop3:
			.byte $38
			.byte cDelay($03), $3b, $3d, $3b
			CSF_Loop _pulse2_loop3
			CSF_SetLoopCount $03
_pulse2_loop4:
			.byte $3b
			.byte cDelay($03), $3f, $40, $3f
			CSF_Loop _pulse2_loop4
			CSF_SetLoopCount $03
_pulse2_loop5:
			.byte $38
			.byte cDelay($03), $3b, $3d, $3b
			CSF_Loop _pulse2_loop5
			CSF_SetLoopCount $03
_pulse2_loop6:
			.byte $33
			.byte cDelay($03), $37, $3a, $37
			CSF_Loop _pulse2_loop6
			CSF_SetLoopCount $03
_pulse2_loop7:
			.byte $31
			.byte cDelay($03), $34, $38, $34
			CSF_Loop _pulse2_loop7
			CSF_SetLoopCount $03
_pulse2_loop8:
			.byte $34
			.byte cDelay($03), $38, $3b, $38
			CSF_Loop _pulse2_loop8
			CSF_SetLoopCount $03
_pulse2_loop9:
			.byte $38
			.byte cDelay($03), $3b, $3e, $3b
			CSF_Loop _pulse2_loop9
			CSF_SetLoopCount $03
_pulse2_loop10:
			.byte $3b
			.byte cDelay($03), $3d, $3f, $3d
			CSF_Loop _pulse2_loop10
			CSF_Jump _pulse2_loop11
_triangle_loop5:
_triangle:
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte $20
			.byte cDelay($03), $00, $00, $25
			.byte $25, $00, $20, $00
			.byte $00, $25, $00, $00
			CSF_Loop _triangle_loop1
			.byte $23, $00, $00, $28
			.byte $28, $00, $23, $00
			.byte $00, $28, $00, $00
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte $1b, $00, $00, $22
			.byte $22, $00, $1b, $00
			.byte $00, $22, $00, $00
			CSF_SetLoopCount $01
_triangle_loop4:
			.byte $20
			.byte cDelay($03), $00, $00, $25
			.byte $25, $00, $20, $00
			.byte $00, $25, $00, $00
			CSF_Loop _triangle_loop3
			.byte $23, $00, $00, $28
			.byte $28, $00, $23, $00
			.byte $00, $28, $00, $00
			CSF_Jump _triangle_loop4
_triangle_loop3:
			.byte $1b, $00, $00, $22
			.byte $22, $00, $1b, $00
			.byte $00, $22, $00, $00
			.byte $19, $00, $00, $20
			.byte $20, $00, $19, $00
			.byte $00, $20, $00, $00
			.byte $1c, $00, $00, $23
			.byte $23, $00, $1c, $00
			.byte $00, $23, $00, $00
			.byte $20, $00, $00, $26
			.byte $26, $00, $20, $00
			.byte $00, $26, $00, $00
			.byte $23, $00, $00, $27
			.byte $27, $00, $23, $00
			.byte $00, $27, $00, $00
			CSF_Jump _triangle_loop5
_noise_loop1:
_noise:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c0, $c1, $c0, $c1
			.byte $c1, $c0, $c1, $c1
			CSF_Jump _noise_loop1