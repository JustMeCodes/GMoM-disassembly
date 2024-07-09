_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $02
			CSF_HeaderPitch $03
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $03
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $41
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0f
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop1:
_pulse1:
			.byte NF3S
			.byte cDelay($08), NA3, NG3S
			.byte cDelay($00), NG5S, NA3
			.byte cDelay($08), NB3, NE3, NF3S
			.byte cDelay($00), NG5S, NF3S
			.byte cDelay($08), NA3, NG3S
			.byte cDelay($00), NG5S, NA3
			.byte cDelay($08), NB3, ND4, NC4
			.byte cDelay($00), $60, NF3S
			.byte cDelay($00), NG5S, NA3
			.byte cDelay($08), NB3, NG3S
			.byte cDelay($0e), NE3, NF3S
			.byte cDelay($00), NG5S, NA3
			.byte cDelay($08), NB3, NG3S
			.byte cDelay($00), NG5S, $00
			.byte cDelay($08), NE3
			.byte cDelay($05), NF3S, NG3
			.byte cDelay($08), NF3S, NE3, ND3
			.byte cDelay($05), NC4
			.byte cDelay($00), $0c, NB3, NA3
			.byte cDelay($0a), NG3
			.byte cDelay($08), NF3S
			.byte cDelay($0e), NB2
			CSF_Jump _pulse1_loop1

_pulse2:
_pulse2_loop4:
			.byte ND3S
			.byte cDelay($08), NF3S, NF3
			.byte cDelay($00), NG5S, NF3S
			.byte cDelay($08), NG3S, NC3S, ND3S
			.byte cDelay($00), NG5S, ND3S
			.byte cDelay($08), NF3S, NF3
			.byte cDelay($00), NG5S, NF3S
			.byte cDelay($08), NG3S, NA3, NF3
			.byte cDelay($00), $60, ND3
			.byte cDelay($00), NG5S, NF3S
			.byte cDelay($08), NG3S, NE3
			.byte cDelay($0e), NB2, ND3
			.byte cDelay($00), NG5S, NF3S
			.byte cDelay($08), NG3S, NE3
			.byte cDelay($00), NG5S, $00
			.byte cDelay($0b)
			CSF_Command $8a, $ff ; Undocumented command
			CSF_SetVoice $02
			CSF_SetLoopCount $08
_pulse2_loop1:
			.byte ND4
			.byte cDelay($03), ND3, NG3, ND3
			CSF_Loop _pulse2_loop1

			CSF_SetLoopCount $08
_pulse2_loop2:
			.byte NB2
			.byte cDelay($03), NB2
			CSF_Loop _pulse2_loop2

			CSF_SetLoopCount $08
_pulse2_loop3:
			.byte NB3
			.byte cDelay($03), NB3
			CSF_Loop _pulse2_loop3

			CSF_Command $8a, $01 ; Undocumented command
			CSF_SetVoice $01
			CSF_Jump _pulse2_loop4

_triangle:
_triangle_loop4:
			CSF_SetVoice $01
			CSF_Command $8a, $ff ; Undocumented command
			CSF_Command $9d, $02 ; Undocumented command
			.byte NB1
			.byte cDelay($00), $60, NB1
			.byte cDelay($0b), NB1
			.byte cDelay($08), NB1
			.byte cDelay($00), NG5S, NB1
			.byte cDelay($00), $60, NB1
			.byte cDelay($0b), NB1
			.byte cDelay($08), NB1
			.byte cDelay($0b), NB1
			.byte cDelay($0a)
			CSF_Command $9d, $04 ; Undocumented command
			.byte NB1
			.byte cDelay($05), NB1
			.byte cDelay($08), NB1, $00
			.byte cDelay($05), NB1, NB1, NB1
			CSF_SetVoice $02
			CSF_Command $8a, $01 ; Undocumented command
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte NB1
			.byte cDelay($05), NB1, NB1, NB1
			.byte NB1, NB1, NB1, NB1
			.byte NB1, NB1, NB1, NB1
			.byte NB1, NB1, NB1, NB1
			.byte NE2, NE2, NE2, NE2
			.byte NE2, NE2, NE2, NE2
			.byte NE2, NE2, NE2, NE2
			.byte NE2, NE2, NB1, ND2
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $02
_triangle_loop2:
			.byte ND2
			.byte cDelay($05), ND3, ND2, ND3
			.byte ND2, ND3, ND2, ND3
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $02
_triangle_loop3:
			.byte NB1
			.byte cDelay($05), NB2, NB1, NB2
			.byte NB1, NB2, NB1, NB2
			CSF_Loop _triangle_loop3

			CSF_Jump _triangle_loop4

_noise_loop4:
_noise:
			CSF_SetLoopCount $01
_noise_loop2:
			.byte $c0
			.byte cDelay($05)
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Loop _noise_loop1

			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			CSF_Jump _noise_loop2
_noise_loop1:
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $00
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $0b
_noise_loop3:
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			CSF_Loop _noise_loop3

			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fc ; Undocumented command
			.byte $c0
			CSF_Command $8a, $04 ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop4