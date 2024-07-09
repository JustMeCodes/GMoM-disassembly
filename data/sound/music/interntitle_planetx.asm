_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $01
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0c
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $01
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $15
			CSF_HeaderTempo $01
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $00
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $01
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			CSF_Command $96, $99 ; Undocumented command
			CSF_Command $9d, $03 ; Undocumented command
_pulse1_loop3:
			CSF_SetLoopCount $01
_pulse1_loop2:
			.byte NA2
			.byte cDelay($05), NG2S, NF2S, NA2
			.byte NG2S, NF2S, NA2, NG2S
			.byte NF2S, NA2, NG2S, NF2S
			.byte NA2, NG2S, NF2S, NB2
			.byte NA2, NG2S, NB2, NA2
			.byte NG2S, NB2, NA2, NG2S
			.byte NB2, NA2, NG2S, NB2
			.byte NA2, NG2S, NB2, NA2
			.byte NG2S, NF2S, NA2, NG2S
			.byte NF2S, NA2, NG2S, NF2S
			.byte NA2, NG2S, NF2S, NA2
			.byte NG2S, NF2S, NA2
			CSF_SetVoice $0d
			CSF_Command $9d, $0c ; Undocumented command
			.byte NB2
			.byte cDelay($00), ND3
			CSF_Loop _pulse1_loop1

			.byte $00
			.byte cDelay($0a)
			CSF_Command $8a, $fe ; Undocumented command
			CSF_Command $9d, $03 ; Undocumented command
			.byte NA3
			.byte cDelay($05), $00, NB3
			.byte cDelay($0b), $00
			.byte cDelay($05)
			CSF_Command $8a, $02 ; Undocumented command
			CSF_SetVoice $04
			CSF_Jump _pulse1_loop2
_pulse1_loop1:
			.byte $00
			.byte cDelay($05)
			CSF_Command $9d, $0c ; Undocumented command
			.byte NC3S
			.byte cDelay($00), ND4
			CSF_Command $8a, $fd ; Undocumented command
			CSF_SetVoice $02
			CSF_Command $9d, $03 ; Undocumented command
			.byte NF4S
			.byte cDelay($05), NF4S, NA4, NF4S
			.byte NB4, NF4S, NC5S, NF4S
			.byte ND5, NF4S, NC5S, NF4S
			.byte NB4, ND4S, NE4, NF4
			.byte NF4S, NF4S, NA4, NF4S
			.byte NB4, NF4S, NC5S, NF4S
			.byte ND5, NF4S, NC5S, NF4S
			.byte NB4, ND4S, NE4, NF4
			CSF_SetVoice $0d
			CSF_Command $8a, $03 ; Undocumented command
			.byte NA3
			.byte cDelay($0e), NB3
			.byte cDelay($0b), NC4S
			CSF_Command $9d, $0c ; Undocumented command
			.byte NG3S
			.byte cDelay($00), $54
			CSF_Command $9d, $03 ; Undocumented command
			.byte NG3S
			.byte cDelay($04), NA3, NB3
			CSF_Command $9d, $0c ; Undocumented command
			.byte NF3S
			.byte cDelay($0e)
			CSF_Command $9d, $03 ; Undocumented command
			.byte NG3S
			.byte cDelay($0b), NA3
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c ; Undocumented command
			.byte NE4
			.byte cDelay($00), ND4
			CSF_Command $9d, $03 ; Undocumented command
			.byte ND4
			.byte cDelay($0a), NC4S, NB3
			.byte cDelay($05)
			CSF_Command $9d, $0c ; Undocumented command
			.byte NA3
			.byte cDelay($00), ND4
			CSF_Command $9d, $03 ; Undocumented command
			.byte NB3
			.byte cDelay($0b), NC4S
			CSF_Command $9d, $0c ; Undocumented command
			.byte NG3S
			.byte cDelay($00), $54
			CSF_Command $9d, $03 ; Undocumented command
			.byte NG3S
			.byte cDelay($04), NA3, NB3
			CSF_Command $9d, $0c ; Undocumented command
			.byte NF3S
			.byte cDelay($0e)
			CSF_Command $9d, $03 ; Undocumented command
			.byte NG3S
			.byte cDelay($0b), NA3
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c ; Undocumented command
			.byte NE4
			.byte cDelay($00), ND4
			CSF_Command $9d, $03 ; Undocumented command
			.byte NA2
			.byte cDelay($05), NG2S, NF2S, NA2
			.byte NG2S, NF2S, NA2, NG2S
			.byte $00, NB3, NA3, $00
			.byte NB3, $00, $00, NA3
			.byte $00, $00, NB3, NB3
			.byte $00, NC4S, NB3, $00
			.byte NC4S, $00, $00, NB3
			.byte $00, $00, NC4S, NC4S
			.byte $00, ND4, NC4S, $00
			.byte ND4, $00, $00, NC4S
			.byte $00, $00, ND4, ND4
			.byte $00, NE4, ND4, $00
			.byte NE4, $00, $00, ND4
			.byte $00, $00, NE4, NE4
			.byte NE2
			.byte cDelay($0b), NF2
			CSF_Jump _pulse1_loop3

_pulse2:
			CSF_Command $96, $99 ; Undocumented command
			CSF_Command $9d, $03 ; Undocumented command
_pulse2_loop2:
			CSF_SetVoice $04
			.byte $00
			.byte cDelay($04), NA2
			.byte cDelay($05), NG2S, NF2S, NA2
			.byte NG2S, NF2S, NA2, NG2S
			.byte NF2S, NA2, NG2S, NF2S
			.byte NA2, NG2S, NF2S, NB2
			.byte NA2, NG2S, NB2, NA2
			.byte NG2S, NB2, NA2, NG2S
			.byte NB2, NA2, NG2S, NB2
			.byte NA2, NG2S, NB2, NA2
			.byte NG2S, NF2S, NA2, NG2S
			.byte NF2S, NA2, NG2S, NF2S
			.byte NA2, NG2S, NF2S, NA2
			.byte NG2S, NF2S, NA2
			CSF_SetVoice $0d
			CSF_Command $9d, $12 ; Undocumented command
			.byte NB2
			.byte cDelay($00), NG3S, $00
			.byte cDelay($04), $00
			CSF_Command $9d, $03 ; Undocumented command
			.byte ND3
			.byte cDelay($05), $00, NE3
			.byte cDelay($0b), $00
			.byte cDelay($05)
			CSF_SetVoice $04
			CSF_Command $8a, $01 ; Undocumented command
			.byte NC3S, NB2, NA2, NC3S
			.byte NB2, NA2, NC3S, NB2
			.byte NA2, NC3S, NB2, NA2
			.byte NC3S, NB2, NA2, ND3
			.byte NC3S, NB2, ND3, NC3S
			.byte NB2, ND3, NC3S, NB2
			.byte ND3, NC3S, NB2, ND3
			.byte NC3S, NB2, ND3, NC3S
			.byte NB2, NA2, NC3S, NB2
			.byte NA2, NC3S, NB2, NA2
			.byte NC3S, NB2, NA2, NC3S
			.byte NB2, NA2, NC3S
			CSF_Command $9d, $0c ; Undocumented command
			CSF_SetVoice $0d
			.byte NF2S
			.byte cDelay($00), ND3, $00
			.byte cDelay($05), NG2S
			.byte cDelay($00), ND4
			CSF_Command $9d, $03 ; Undocumented command
			.byte $00
			.byte cDelay($07)
			CSF_SetVoice $02
			CSF_Command $8a, $fa ; Undocumented command
			.byte NF4S
			.byte cDelay($05), NF4S, NA4, NF4S
			.byte NB4, NF4S, NC5S, NF4S
			.byte ND5, NF4S, NC5S, NF4S
			.byte NB4, ND4S, NE4, NF4
			.byte NF4S, NF4S, NA4, NF4S
			.byte NB4, NF4S, NC5S, NF4S
			.byte ND5, NF4S, NC5S, NF4S
			.byte NB4, ND4S, NE4, NF4
			CSF_SetVoice $0d
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Command $9d, $0c ; Undocumented command
			.byte NA3
			.byte cDelay($0e)
			CSF_Command $9d, $03 ; Undocumented command
			.byte NB3
			.byte cDelay($0b), NC4S
			CSF_Command $9d, $0c ; Undocumented command
			.byte NG3S
			.byte cDelay($00), $54
			CSF_Command $9d, $03 ; Undocumented command
			.byte NG3S
			.byte cDelay($04), NA3, NB3
			CSF_Command $9d, $0c ; Undocumented command
			.byte NF3S
			.byte cDelay($0e)
			CSF_Command $9d, $03 ; Undocumented command
			.byte NG3S
			.byte cDelay($0b), NA3
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c ; Undocumented command
			.byte NE4
			.byte cDelay($00), NF3
			CSF_Command $9d, $03 ; Undocumented command
			CSF_Command $8a, $01 ; Undocumented command
			.byte NA2
			.byte cDelay($05), NG2S, NF2S, NA2
			.byte NG2S, NF2S, NA2
			CSF_Command $9d, $0c ; Undocumented command
			.byte NC4S
			.byte cDelay($00), ND4
			CSF_Command $9d, $03 ; Undocumented command
			.byte ND4
			.byte cDelay($0b), NE4
			CSF_Command $9d, $0c ; Undocumented command
			.byte NC4S
			.byte cDelay($00), $60, NB3
			.byte cDelay($0e)
			CSF_Command $9d, $03 ; Undocumented command
			.byte NC4S
			.byte cDelay($0b), ND4
			.byte cDelay($08), $00
			.byte cDelay($05)
			CSF_Command $9d, $0c ; Undocumented command
			.byte NG4S
			.byte cDelay($00), ND4
			CSF_Command $9d, $03 ; Undocumented command
			.byte NE3
			.byte cDelay($05), ND3, NC3S, NE3
			.byte ND3, NC3S, NE3, ND3
			CSF_Command $8a, $ff ; Undocumented command
			CSF_SetLoopCount $04
_pulse2_loop1:
			.byte $00, NF3S, NF3S, $00
			.byte NF3S, $00, $00, NF3S
			.byte $00, $00, NF3S, NF3S
			CSF_Loop _pulse2_loop1

			.byte NB2
			.byte cDelay($0b), NC3
			CSF_Jump _pulse2_loop2

_triangle:
			CSF_Command $96, $99 ; Undocumented command
_triangle_loop6:
			CSF_SetLoopCount $01
_triangle_loop2:
			.byte $16
			.byte cDelay($03), $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16
			.byte cDelay($07), $00
			.byte cDelay($03), $16, $00, $16
			.byte $00, $16, $00, $16
			.byte $00, $16, $00, $16
			.byte $00, $16, $00, $14
			.byte cDelay($03), $00, $14, $00
			.byte $14, $00, $14, $00
			.byte $14, $00, $14, $00
			.byte $14, $00, $14
			.byte cDelay($07), $00
			.byte cDelay($03), $14, $00, $14
			.byte $00, $14, $00, $14
			.byte $00, $14, $00, $14
			.byte $00, $14, $00, $12
			.byte cDelay($03), $00, $12, $00
			.byte $12, $00, $12, $00
			.byte $12, $00, $12, $00
			.byte $12, $00, $12
			.byte cDelay($07), $00
			.byte cDelay($03), $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00
			CSF_Loop _triangle_loop1

			.byte NB0, $00, NB0, $00
			.byte NB0, $00, NB0, $00
			.byte NB0, $00, NB0, $00
			.byte NB0, $00, NB0, $00
			.byte $00, $00, $12, $00
			.byte cDelay($07), $14, $00
			.byte cDelay($03), $14, $00, $14
			.byte $00, $14, $00
			CSF_Jump _triangle_loop2
_triangle_loop1:
			.byte NB0, $00, NB0, $00
			.byte NB0, $00, NB0, $00
			.byte NB0, $00, NB0, $00
			.byte NB0, $00, $11
			.byte cDelay($07), $00
			.byte cDelay($03), $11, $00, $11
			.byte $00, $11, $00, $11
			.byte $00, $11, $00, $12
			.byte $00, $14, $00
			CSF_SetLoopCount $02
_triangle_loop3:
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $16, $00
			.byte $16, $00, $13, $00
			.byte $14, $00, $15, $00
			CSF_Loop _triangle_loop3

			CSF_SetLoopCount $02
_triangle_loop4:
			.byte $16, $00, $16, $00
			.byte NA1, $00, $16, $00
			.byte NB1, $00, $16, $00
			.byte NC2S, $00, $16, $00
			.byte $16, $00, NB1, $00
			.byte NB1, $00, $16, $00
			.byte NA1, $00, NA1, $00
			.byte $11, $00, $13, $00
			.byte $14, $00, $14, $00
			.byte NG1S, $00, $14, $00
			.byte NA1, $00, $14, $00
			.byte NB1, $00, $14, $00
			.byte $14, $00, NA1, $00
			.byte NA1, $00, $14, $00
			.byte NG1S, $00, NG1S, $00
			.byte $14, $00, $12
			.byte cDelay($07), $00
			.byte cDelay($03), $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12
			.byte cDelay($07), $00
			.byte cDelay($03), $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $12, $00, $12
			.byte $00, $11
			.byte cDelay($07), $00
			.byte cDelay($03), $11, $00, $11
			.byte $00, $11, $00, $11
			.byte $00, $11, $00, $11
			.byte $00, $11, $00, NA1
			.byte $00, NG1S, $00, $16
			.byte $00, NA1, $00, NG1S
			.byte $00, $16, $00, NA1
			.byte $00, NG1S, $00
			CSF_Loop _triangle_loop4

			CSF_SetLoopCount $04
_triangle_loop5:
			.byte $16, $00, NC2S, $00
			.byte NC2S, $00, $16, $00
			.byte NB1, $00, $16, $00
			.byte $16, $00, NA1, $00
			.byte $16, $00, $16, $00
			.byte NG1S, $00, $16, $00
			CSF_Loop _triangle_loop5

			.byte $14
			.byte cDelay($0b), $15
			CSF_Jump _triangle_loop6

_noise:
			CSF_Command $96, $99 ; Undocumented command
_noise_loop8:
			CSF_SetLoopCount $01
_noise_loop3:
			CSF_SetLoopCount $0e, $77
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			CSF_Loop _noise_loop1, $77

			CSF_Loop _noise_loop2

			.byte $c1, $c0, $c1, $c0
			.byte $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Jump _noise_loop3
_noise_loop2:
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $03, $77
_noise_loop4:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c0
			CSF_Loop _noise_loop4, $77

			.byte $c0
			.byte cDelay($03), $c0, $c0, $00
			.byte $c0, $00, $c0, $c0
			.byte $c0, $00, $c0, $00
			.byte $c0, $c0, $c0, $c0
			CSF_SetLoopCount $0f, $77
_noise_loop5:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			CSF_Loop _noise_loop5, $77

			.byte $c0, $00
			.byte cDelay($03), $c0, $c0, $00
			.byte $c0, $00
			CSF_SetLoopCount $0e, $77
_noise_loop6:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			CSF_Loop _noise_loop6, $77

			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $04, $77
_noise_loop7:
			.byte $c1
			.byte cDelay($05), $c0, $c0, $c1
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c0
			CSF_Loop _noise_loop7, $77

			.byte $c0
			.byte cDelay($08), $00, $c0
			.byte cDelay($03), $00, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop8
			.byte $04
			.byte cDelay($1e)
			.byte cDelay($1e)