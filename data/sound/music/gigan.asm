_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fe
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0d
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $f9
			CSF_HeaderTempo $9e
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $16
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

_header_end:

_pulse1_loop2:
_pulse1:
			.byte NA3
			.byte cDelay($0e), NC4
			.byte cDelay($0b), NB3
			.byte cDelay($08), ND4S, NE4
			.byte cDelay($00), $60, NG4
			.byte cDelay($0e), NE4
			.byte cDelay($0a), ND4, NC4
			.byte cDelay($08), NE4
			.byte cDelay($00), $60, NA3
			.byte cDelay($0e), NC4
			.byte cDelay($0b), NB3
			.byte cDelay($08), ND4S, NE4
			.byte cDelay($00), $60
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte NC4
			.byte cDelay($0a), NB3, NA3, NG3
			.byte cDelay($08), NE3
			CSF_Loop _pulse1_loop1

			.byte NE4
			.byte cDelay($0a), ND4, NC4, NB3
			.byte cDelay($08), NG3, NA3
			.byte cDelay($00), NG5S, $00
			.byte cDelay($00), NG1S, NA3
			.byte cDelay($0e), NE4
			.byte cDelay($0a), ND4, NC4
			.byte cDelay($08), NB3
			.byte cDelay($0e), NG3, NF3, NA3
			.byte cDelay($0a), NG3, NF3
			.byte cDelay($08), NE3
			.byte cDelay($0e), NG3, NA3, NE4
			.byte cDelay($0a), ND4, NC4
			.byte cDelay($08), NG4
			.byte cDelay($0e), NE4, NA4
			.byte cDelay($06), NG4, NF4, NE4
			.byte ND4, NC4, NE4
			.byte cDelay($0e), NB3
			CSF_Jump _pulse1_loop2

_pulse2:
_pulse2_loop2:
			.byte NA3
			.byte cDelay($0e), NC4
			.byte cDelay($0a), NB3, NG3
			.byte cDelay($08), NE3
			.byte cDelay($0e), ND3
			.byte cDelay($0a), NG3, NE3
			.byte cDelay($08), NA3
			.byte cDelay($0e), NC4
			.byte cDelay($0a), NB3, NE3
			.byte cDelay($08)
			CSF_SetVoice $04
			CSF_Command $8a, $01 ; Undocumented command
			.byte NA2
			.byte cDelay($0a), NA2S, NB2
			.byte cDelay($08), NC3, NC3S, ND3
			.byte NE3
			CSF_SetVoice $09
			CSF_Command $8a, $ff ; Undocumented command
			.byte NA3
			.byte cDelay($0e), NC4
			.byte cDelay($0a), NB3, NG3
			.byte cDelay($08), NE3
			.byte cDelay($0a), NF3, ND3
			.byte cDelay($08), NE3
			.byte cDelay($0a), NC3, NA2
			.byte cDelay($08)
			CSF_Command $8a, $01 ; Undocumented command
			CSF_Command $89, $0c ; Undocumented command
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $00
			.byte cDelay($05), NC2, NC3, $00
			.byte NB1, NB2, $00, NA1
			.byte NA2, NG1
			.byte cDelay($08), NE2
			CSF_Loop _pulse2_loop1

			.byte $00
			.byte cDelay($05), NE2, NE3, $00
			.byte ND2, ND3, $00, NC2
			.byte NC3, NB1
			.byte cDelay($08), NG2
			CSF_Command $89, $f4 ; Undocumented command
			.byte NA3
			.byte cDelay($00), $60
			CSF_SetVoice $07
			CSF_Command $8a, $fe ; Undocumented command
			.byte NA3
			.byte cDelay($0e), NE4
			.byte cDelay($0a), ND4, NC4
			.byte cDelay($08), NB3
			.byte cDelay($0e), NG3, NF3, NA3
			.byte cDelay($0a), NG3, NF3
			.byte cDelay($08), NE3
			.byte cDelay($0e), NG3, NA3, NE4
			.byte cDelay($0a), ND4, NC4
			.byte cDelay($08), NG4
			.byte cDelay($0e), NE4, NA4
			.byte cDelay($06), NG4, NF4, NE4
			.byte ND4, NC4, NE4
			.byte cDelay($0e), NB3
			CSF_Jump _pulse2_loop2

_triangle:
_triangle_loop17:
			CSF_SetLoopCount $10
_triangle_loop1:
			.byte NA1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $10
_triangle_loop2:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $10
_triangle_loop3:
			.byte NG1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop3

			CSF_SetLoopCount $10
_triangle_loop4:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop4

			CSF_SetLoopCount $10
_triangle_loop5:
			.byte NA1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop5

			CSF_SetLoopCount $10
_triangle_loop6:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop6

			CSF_SetLoopCount $02
_triangle_loop7:
			.byte NC2
			.byte cDelay($03), $00, NC2
			.byte cDelay($05), $00, NB1
			.byte cDelay($03), $00, NB1
			.byte cDelay($05), $00, NA1
			.byte cDelay($03), $00, NA1
			.byte cDelay($05), $00, NG1, $00
			.byte $14, $00
			CSF_Loop _triangle_loop7

			.byte $14
			.byte cDelay($03), $00, $14
			.byte cDelay($05), $00, NA1
			.byte cDelay($03), $00, NA1
			.byte cDelay($05), $00, NC2
			.byte cDelay($03), $00, NC2
			.byte cDelay($05), $00, NB1, $00
			.byte NG1, $00
			CSF_SetLoopCount $08
_triangle_loop8:
			.byte NA1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop8

			.byte $00
			.byte cDelay($0e)
			CSF_SetLoopCount $10
_triangle_loop9:
			.byte NA1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop9

			CSF_SetLoopCount $10
_triangle_loop10:
			.byte NB1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop10

			CSF_SetLoopCount $10
_triangle_loop11:
			.byte NC2
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop11

			CSF_SetLoopCount $10
_triangle_loop12:
			.byte NB1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop12

			CSF_SetLoopCount $10
_triangle_loop13:
			.byte NC2
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop13

			CSF_SetLoopCount $10
_triangle_loop14:
			.byte NG1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop14

			.byte NG1
			.byte cDelay($04), $00, NF2, $00
			.byte $14, $00, NA1, $00
			.byte NC2, $00, NB1, $00
			CSF_SetLoopCount $08
_triangle_loop15:
			.byte $14
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop15

			CSF_SetLoopCount $08
_triangle_loop16:
			.byte NB1
			.byte cDelay($03), $00
			CSF_Loop _triangle_loop16

			CSF_Jump _triangle_loop17

_noise:
_noise_loop4:
			CSF_SetLoopCount $0c
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop1

			CSF_SetLoopCount $02
_noise_loop2:
			.byte $c0
			.byte cDelay($05), $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c0
			.byte $c0
			CSF_Loop _noise_loop2

			.byte $c0, $c0, $c1, $c0
			.byte $c0, $c1, $c0, $c0
			.byte $c1, $c0, $c0, $c0
			.byte $c0, $c0
			.byte cDelay($0a), $c0, $c0
			.byte cDelay($05), $c0, $00
			.byte cDelay($0b), $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0, $c0
			.byte cDelay($05)
			CSF_SetLoopCount $0c
_noise_loop3:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop3

			.byte $c0, $c1
			.byte cDelay($03), $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c0, $c0, $c0
			.byte cDelay($05), $c1, $c1, $c0
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c0, $c1, $c0
			.byte cDelay($03), $c0, $c0
			.byte cDelay($05)
			CSF_Jump _noise_loop4