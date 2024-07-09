_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $00
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $18
			CSF_HeaderTempo $01
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0c, $00
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			CSF_Command $8a, $00 ; Undocumented command
			CSF_Command $96, $7b ; Undocumented command
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NC3S
			.byte cDelay($05), NC3S, NC3S, NA2
			.byte cDelay($03), NB2, NC3S
			.byte cDelay($0a), NA2
			.byte cDelay($05), NC3S, NA2
			.byte cDelay($03), NB2, NA2
			.byte cDelay($05), NB2
			.byte cDelay($03), NB2
			CSF_Loop _pulse1_loop1

			.byte NC3S
			.byte cDelay($05), NC3S, NC3S, NA2
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte NA2
			.byte cDelay($08), NG2S
_pulse1_loop9:
			CSF_SetLoopCount $02
_pulse1_loop3:
			.byte NA2
			.byte cDelay($05), NB2, NC3S, ND3
			.byte NC3S
			.byte cDelay($08), NE3, NB2, NE3
			.byte NA2
			.byte cDelay($05), NB2, NC3S, ND3
			.byte NC3S
			.byte cDelay($08), NC3S
			.byte cDelay($05), NB2, NA2, NC3S
			.byte NG2S, NC3S, NF2S
			.byte cDelay($08), NF2S
			.byte cDelay($05), NF2, NF2S
			.byte cDelay($08), NG2S, NA2
			.byte cDelay($05), NB2, NC3S, NG2S
			.byte NA2
			.byte cDelay($08), NG2S, NF2S, NF2S
			.byte cDelay($05), NF2, NF2S
			.byte cDelay($08), NG2S, NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08)
			CSF_Loop _pulse1_loop3

			CSF_SetLoopCount $01
_pulse1_loop5:
			.byte NC3S
			.byte cDelay($05), NC3S, NC3S, NA2
			.byte cDelay($03), NB2, NC3S
			.byte cDelay($0a), NA2
			.byte cDelay($05), NC3S, NA2
			.byte cDelay($03), NB2, NA2
			.byte cDelay($05), NA2
			.byte cDelay($03), NB2, NC3S
			.byte cDelay($05), NC3S, NC3S, NA2
			.byte ND3, ND3, ND3, NB2
			.byte cDelay($03), NC3S, ND3
			.byte cDelay($0a), NB2
			.byte cDelay($05), ND3, NB2
			.byte cDelay($03), NC3S, NB2
			.byte cDelay($05), NB2
			.byte cDelay($03), NC3S
			CSF_Loop _pulse1_loop4

			.byte ND3
			.byte cDelay($05), NB2, NC3S, ND3
			CSF_Jump _pulse1_loop5
_pulse1_loop4:
			.byte ND3
			.byte cDelay($08), ND3
			.byte cDelay($05), $00
			CSF_SetLoopCount $02
_pulse1_loop6:
			.byte NC3S
			.byte cDelay($00), ND2, NA2
			.byte cDelay($05), NB2, NC3S, NC3S
			.byte cDelay($00), ND2, NA2
			.byte cDelay($05), NB2, NC3S, ND3
			.byte cDelay($03), NE3, ND3, NC3S
			.byte NB2
			.byte cDelay($08), ND3
			.byte cDelay($03), NE3, ND3, NC3S
			.byte NB2
			.byte cDelay($08), ND3
			.byte cDelay($03), NE3, ND3, NC3S
			.byte NB2
			.byte cDelay($08), $00
			.byte cDelay($05), NC3S, ND3, NB2
			CSF_Loop _pulse1_loop6

			CSF_SetLoopCount $01
_pulse1_loop8:
			.byte NC3S
			.byte cDelay($05), NF3S, NC3S
			.byte cDelay($08), NC3S
			.byte cDelay($05), NF3S, NC3S
			.byte cDelay($08), ND3
			.byte cDelay($05), NC3S, NB2, NA2
			CSF_Loop _pulse1_loop7

			.byte NB2
			.byte cDelay($08), NC3S
			CSF_Jump _pulse1_loop8
_pulse1_loop7:
			.byte ND3
			.byte cDelay($05), ND3, NC3S
			.byte cDelay($08)
			CSF_Jump _pulse1_loop9
			CSF_Stop

_pulse2:
			CSF_Command $96, $7b ; Undocumented command
			CSF_Command $8a, $ff ; Undocumented command
			CSF_SetVoice $04
			CSF_Command $83, $41 ; Undocumented command
			CSF_SetLoopCount $01
_pulse2_loop2:
			.byte NC2S
			.byte cDelay($05), NC2S, NC2S, NA1
			.byte cDelay($03), NB1, NC2S
			.byte cDelay($0a), NA1
			.byte cDelay($05), NC2S, NA1
			.byte cDelay($03), NB1, NA1
			.byte cDelay($05), NB1
			.byte cDelay($03), NB1
			CSF_Loop _pulse2_loop1

			.byte NC2S
			.byte cDelay($05), NC2S, NC2S, NA1
			CSF_Jump _pulse2_loop2
_pulse2_loop1:
			.byte NA1
			.byte cDelay($08), NG1S
_pulse2_loop9:
			CSF_Command $83, $40 ; Undocumented command
			CSF_Command $8a, $01 ; Undocumented command
			CSF_SetLoopCount $02
_pulse2_loop3:
			.byte $00
			.byte cDelay($0b), NA2
			.byte cDelay($05), NA2, NE2, NE2
			.byte NA2, NA2, NE2, NE2
			.byte NA2, NA2, NE2, NE2
			.byte NA2, NA2, NE2, NE2
			.byte $00, NF3S, $00, NG3S
			.byte $00, NA3, $00
			.byte cDelay($08), $00
			.byte cDelay($05), NF3S, $00, NG3S
			.byte $00, NA3, $00
			.byte cDelay($08), $00
			.byte cDelay($05), ND3, $00, NE3
			.byte $00, NF3S, $00, $00
			.byte $00, ND3, $00, NE3
			.byte $00, NF3S, $00, $00
			CSF_Loop _pulse2_loop3

			CSF_Command $83, $41 ; Undocumented command
			CSF_SetLoopCount $01
_pulse2_loop5:
			.byte NC2S, NC2S, NC2S, NA1
			.byte cDelay($03), NB1, NC2S
			.byte cDelay($0a), NA1
			.byte cDelay($05), NC2S, NA1
			.byte cDelay($03), NB1, NA1
			.byte cDelay($05), NA1
			.byte cDelay($03), NB1, NC2S
			.byte cDelay($05), NC2S, NC2S, NA1
			.byte ND2, ND2, ND2, NB1
			.byte cDelay($03), NC2S, ND2
			.byte cDelay($0a), NB1
			.byte cDelay($05), ND2, NB1
			.byte cDelay($03), NC2S, NB1
			.byte cDelay($05), NB1
			.byte cDelay($03), NC2S
			CSF_Loop _pulse2_loop4

			.byte ND2
			.byte cDelay($05), NB1, NC2S, ND2
			CSF_Jump _pulse2_loop5
_pulse2_loop4:
			.byte ND2
			.byte cDelay($08), ND2
			.byte cDelay($05), $00
			CSF_SetLoopCount $02
_pulse2_loop6:
			.byte $00
			.byte cDelay($0e)
			CSF_SetVoice $04
			CSF_Command $83, $41 ; Undocumented command
			.byte $00
			.byte cDelay($05), NC4S, ND4, NC4S
			.byte cDelay($00), ND2, ND3
			.byte cDelay($03), NE3, ND3, NC3S
			.byte NB2
			.byte cDelay($08), ND3
			.byte cDelay($03), NE3, ND3, NC3S
			.byte NB2
			.byte cDelay($08), ND3
			.byte cDelay($03), NE3, ND3, NC3S
			.byte NB2
			.byte cDelay($08), $00
			.byte cDelay($05), NC3S, ND3, NB2
			CSF_Loop _pulse2_loop6

			CSF_Command $83, $40 ; Undocumented command
			CSF_Command $8a, $fb ; Undocumented command
			CSF_SetLoopCount $01
_pulse2_loop8:
			.byte NC6S
			.byte cDelay($05), NF6, NC6S
			.byte cDelay($08), NC6S
			.byte cDelay($05), NF6, NC6S
			.byte cDelay($08), ND6
			.byte cDelay($05), NC6S, NB5, NA5
			CSF_Loop _pulse2_loop7

			.byte NB5
			.byte cDelay($08), NC6S
			CSF_Jump _pulse2_loop8
_pulse2_loop7:
			.byte ND6
			.byte cDelay($05), ND6, NC6S
			.byte cDelay($08)
			CSF_SetVoice $04
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Jump _pulse2_loop9
			CSF_Stop

_triangle:
			CSF_Command $96, $7b ; Undocumented command
			CSF_SetVoice $02
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte $16
			.byte cDelay($05), $16, NF2S, $16
			.byte $16, $16, NF2S, $16
			.byte $16, $16, NF2S, $16
			.byte NC2S, $16
			CSF_Loop _triangle_loop1

			.byte NA1, NC2S
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte NC2S, NF2S
_triangle_loop7:
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte NA1
			.byte cDelay($0b), NA1
			.byte cDelay($05), $14, NA1, $14
			.byte NA1, $14, NA1, $14
			.byte NA1, $14, NA1, $14
			.byte NA1, $14, NA2, NE2
			.byte $0a, $16
			.byte cDelay($03), $11, $0c
			.byte cDelay($05), NG1S
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), NA1
			.byte cDelay($03), $14, $0a
			.byte cDelay($05), $05, $0a, $16
			.byte cDelay($03), $11, $0c
			.byte cDelay($05), NG1S
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), NA1
			.byte cDelay($03), $14, $0a
			.byte cDelay($05), $05, $06, $12
			.byte cDelay($03), $0d, $0c
			.byte cDelay($05), NG1S
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), $0c, $0a, $16
			.byte cDelay($03), $0a, $06
			.byte cDelay($05), $12
			.byte cDelay($03), $0d, $0c
			.byte cDelay($05), NG1S
			.byte cDelay($03), $13, $0d
			.byte cDelay($05), $0c, $0a, $16
			.byte cDelay($03), $0a
			CSF_Loop _triangle_loop3

			.byte $16
			.byte cDelay($08), NA1, $16, NA1
			.byte $16, NA1, $16
			.byte cDelay($0b), NB0
			.byte cDelay($08), $12, NB0, $12
			.byte NB0, $12, NB0
			.byte cDelay($0b), $16
			.byte cDelay($05), $16, NF2S, NC2S
			.byte $16, $16, NF2S, NC2S
			.byte $16, $16, NF2S, NC2S
			.byte NA1, $16, NA1, NF2S
			.byte NB0, NB0, NB1, $16
			.byte NB0, NB0, NB1, $16
			.byte NB0, NB0, NB1, $16
			.byte $12, NB0, $12, $16
			CSF_SetLoopCount $02
_triangle_loop4:
			.byte $11
			.byte cDelay($05), $11, $11, $11
			.byte $11, $11, $11, $11
			.byte $11, $11, $11, $11
			.byte $11, $11, $11, $11
			.byte $12
			.byte cDelay($08), NB0, $12, NB0
			.byte $12, NB0, $12, $12
			CSF_Loop _triangle_loop4

			CSF_SetVoice $04
			CSF_Command $9d, $02 ; Undocumented command
			CSF_SetLoopCount $01
_triangle_loop6:
			.byte $0a
			.byte cDelay($05), $16, $05, $11
			.byte $0a, $16, $05, $11
			CSF_Loop _triangle_loop5

			.byte $06
			.byte cDelay($03), $00, $06, $00
			.byte $06, $00, $06
			.byte cDelay($05), $03, NB0, $05
			.byte $11
			CSF_Jump _triangle_loop6
_triangle_loop5:
			CSF_Command $9d, $08 ; Undocumented command
			.byte $06
			.byte cDelay($08), $00
			CSF_Command $9d, $02 ; Undocumented command
			.byte $06
			.byte cDelay($03), $00, $06, $00
			.byte $05, $00, $05
			.byte cDelay($01), $00
			.byte cDelay($02), $05
			.byte cDelay($03)
			CSF_Command $9d, $01 ; Undocumented command
			CSF_SetVoice $02
			CSF_Jump _triangle_loop7
			CSF_Stop

_noise:
			CSF_Command $96, $7b ; Undocumented command
			CSF_Command $8a, $fe ; Undocumented command
			CSF_SetLoopCount $08
_noise_loop1:
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop1

_noise_loop8:
			CSF_SetLoopCount $02
_noise_loop2:
			.byte $00
			.byte cDelay($0b), $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $00
			.byte cDelay($05), $c0, $00, $c0
			.byte $00, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Loop _noise_loop2

			CSF_SetLoopCount $07
_noise_loop3:
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop3

			.byte $00, $c0
			.byte cDelay($05), $c0
			CSF_SetLoopCount $04
_noise_loop4:
			.byte $c0
			.byte cDelay($03), $00, $c0, $c0
			CSF_Loop _noise_loop4

			.byte $00
			.byte cDelay($08), $c0, $00, $c0
			.byte cDelay($02), $c0, $00
			.byte cDelay($01), $00, $c0
			.byte cDelay($03), $c0
			CSF_SetLoopCount $08
_noise_loop5:
			.byte $c0, $00, $c0, $c0
			CSF_Loop _noise_loop5

			CSF_SetLoopCount $02
_noise_loop6:
			.byte $00
			.byte cDelay($08), $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00, $c0
			.byte $00, $c0, $00
			.byte cDelay($05), $c0, $c0, $c0
			CSF_Loop _noise_loop6

			CSF_SetLoopCount $02
_noise_loop7:
			.byte $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			.byte $00
			.byte cDelay($08), $c0
			CSF_Loop _noise_loop7

			CSF_Jump _noise_loop8
			CSF_Stop