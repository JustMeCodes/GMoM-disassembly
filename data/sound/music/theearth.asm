_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $69
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $69
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $18
			CSF_HeaderTempo $69
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $69
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
_pulse1_loop3:
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte NE3
			.byte cDelay($03), $00, NA2, ND3
			.byte $00, NE3, NA2, $00
			.byte ND3, $00, NE3, $00
			.byte NG3, $00, NG3, NF3S
			.byte $00, NF3S, $00
			CSF_Loop _pulse1_loop1

			.byte ND3
			.byte cDelay($0b), NC3, NB2
			.byte cDelay($0e), NA2
			.byte cDelay($03), $00, NG2, NA2
			.byte $00, NG2, NA2, $00
			.byte NA2, $00, NG2, NA2
			.byte $00, NG2, NA2, $00
			.byte ND3, $00, NC3, ND3
			.byte $00, NC3, ND3, $00
			.byte ND3, $00, NC3, ND3
			.byte $00, NC3, ND3, $00
			CSF_SetLoopCount $02
_pulse1_loop2:
			.byte NG3
			.byte cDelay($03), NF3S, ND3, NG3
			.byte NF3S, ND3, NG3, NF3S
			CSF_Loop _pulse1_loop2

			.byte NB3, NA3, NE3, NB3
			.byte NA3, NE3, NB3, NA3
			.byte ND4, NC4S, NA3, ND4
			.byte NC4S, NA3, ND4, NC4S
			.byte NA3
			.byte cDelay($0b), NB3, NG3, NA3
			.byte NF3S
			.byte cDelay($0e), NF3S
			.byte cDelay($03), NF3S, $00, NF3S
			.byte $00, NF3S, NF3S, $00
			.byte cDelay($0a)
			CSF_Command $96, $59 ; Undocumented command
			.byte $00
			.byte cDelay($07), NB2, NC3, NG2
			.byte cDelay($03), $00, NG3, $00
			.byte NF3S
			.byte cDelay($00), $12, NE3
			.byte cDelay($03), $00, ND3, $00
			.byte NB2
			.byte cDelay($07), NC3, NG2
			.byte cDelay($03), $00, ND2
			.byte cDelay($0b), NE2
			.byte cDelay($07), NF2, ND2
			.byte cDelay($03), $00, NC3, $00
			.byte NB2
			.byte cDelay($00), $12, NA2
			.byte cDelay($03), $00, NG2, $00
			.byte NA2
			.byte cDelay($0b), NB2
			.byte cDelay($08), $00, NC3
			.byte cDelay($07), ND3, NB2
			.byte cDelay($03), $00, NC4, $00
			.byte NB3
			.byte cDelay($00), $12, NA3
			.byte cDelay($03), $00, NG3, $00
			.byte NE3
			.byte cDelay($07), NF3, NC3
			.byte cDelay($03), $00, NA2
			.byte cDelay($0b), NF3
			.byte cDelay($07), NE3, ND3
			.byte cDelay($03), $00, NC3
			.byte cDelay($00), $15, $00
			.byte cDelay($03), NB2, $00, NG2
			.byte $00, NA2
			.byte cDelay($0b), NE3
			.byte cDelay($08)
			CSF_Command $96, $69 ; Undocumented command
			.byte $00
			CSF_Jump _pulse1_loop3

_pulse2:
_pulse2_loop3:
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte NC3
			.byte cDelay($03), $00, $00, NB2
			.byte $00, NC3, $00, $00
			.byte NB2, $00, NC3, $00
			.byte NE3, $00, NE3, ND3
			.byte $00, ND3, $00
			CSF_Loop _pulse2_loop1

			.byte NA2S
			.byte cDelay($0b), NF2, NE2
			.byte cDelay($0e), $00
			CSF_SetLoopCount $03
_pulse2_loop2:
			.byte NA2
			.byte cDelay($03), $00, NA2, NA2
			.byte $00, NA2, NA2, $00
			.byte NA2, $00, NA2, NA2
			.byte $00, NA2, NA2, $00
			CSF_Loop _pulse2_loop2

			.byte NF3
			.byte cDelay($0b), NG3, NE3, ND3
			.byte ND3
			.byte cDelay($0e), NA2
			.byte cDelay($03), NA2, $00, NA2
			.byte $00, NA2, NA2, $00
			.byte cDelay($0a)
			CSF_Command $96, $59 ; Undocumented command
			.byte $00
			.byte cDelay($07), $00
			.byte cDelay($03), $00
			CSF_Command $8a, $fb ; Undocumented command
			.byte NB2
			.byte cDelay($07), NC3, NG2
			.byte cDelay($03), $00, NG3, $00
			.byte NF3S
			.byte cDelay($00), $12, NE3
			.byte cDelay($03), $00, ND3, $00
			.byte NB2
			.byte cDelay($07), NC3, NG2
			.byte cDelay($03), $00, ND2
			.byte cDelay($0b), NE2
			.byte cDelay($07), NF2, ND2
			.byte cDelay($03), $00, NC3, $00
			.byte NB2
			.byte cDelay($00), $12, NA2
			.byte cDelay($03), $00, NG2, $00
			.byte NA2
			.byte cDelay($0b), NB2
			.byte cDelay($08)
			CSF_Command $8a, $02 ; Undocumented command
			.byte $00, NC3
			.byte cDelay($07), ND3, NB2
			.byte cDelay($03), $00, NC4, $00
			.byte NB3
			.byte cDelay($00), $12, NA3
			.byte cDelay($03), $00, NG3, $00
			.byte NE3
			.byte cDelay($07), NF3, NC3
			.byte cDelay($03), $00, NA2
			.byte cDelay($0a)
			CSF_Command $8a, $03 ; Undocumented command
			.byte ND3
			.byte cDelay($07), NC3, NB2
			.byte cDelay($03), $00, NA2
			.byte cDelay($00), $15, $00
			.byte cDelay($03), NG2, $00, NE2
			.byte $00, NF2S
			.byte cDelay($0b), NG2S
			.byte cDelay($08)
			CSF_Command $96, $69 ; Undocumented command
			.byte $00
			CSF_Jump _pulse2_loop3

_triangle:
_triangle_loop7:
			CSF_SetLoopCount $02
_triangle_loop1:
			.byte NA1
			.byte cDelay($03), $00, NA1, NA1
			.byte $00, NA1, NA1, $00
			.byte NA1, $00, NA1, $00
			.byte NA1, $00, NA1, NA1
			.byte $00, NA1, $00
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $02
_triangle_loop2:
			.byte $15
			.byte cDelay($03), $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			CSF_Cmd9C _triangle_cmd9c_1, $02
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $04
_triangle_loop3:
			.byte NA1
			.byte cDelay($03), $00, NG1, NA1
			.byte $00, NG1, NA1, $00
			.byte NA1, $00, NG1, NA1
			.byte $00, NG1, NA1, $00
			CSF_Loop _triangle_loop3

			CSF_SetLoopCount $03
_triangle_loop4:
			.byte $15
			.byte cDelay($03), $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			CSF_Cmd9C _triangle_cmd9c_2, $03
			CSF_Loop _triangle_loop4

			.byte $12, $12, $00, $12
			.byte $00, $12, $12, $00
			.byte cDelay($0a)
			CSF_Command $96, $59 ; Undocumented command
			.byte $12
			.byte cDelay($03), $12, $12
			CSF_SetLoopCount $01
_triangle_loop6:
			.byte NA1
			.byte cDelay($03), $00, NA1, NA1
			.byte $00, NA1, NA1, $00
			.byte NA1, $00, NA1, $00
			.byte NA1, NA1, $00, NA1
			.byte NA1, $00, NA1, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $15, $00, $15, $15
			.byte $00, $15, $15, $00
			.byte $12, $00, $12, $12
			.byte $00, $12, $12, $00
			.byte $12, $00, $12, $00
			.byte $12, $12, $00, $12
			.byte $12, $00, $12, $00
			CSF_Loop _triangle_loop5

			.byte $14, $00, $14, $14
			.byte $00, $14, $14, $00
			.byte $14, $00, $14, $14
			.byte $00, $14, $14, $00
			CSF_Jump _triangle_loop6
_triangle_loop5:
			.byte $14, $00, $14, $14
			.byte $00, $14, $14, $00
			.byte $14, $00, $14, $14
			CSF_Command $96, $69 ; Undocumented command
			.byte $00
			.byte cDelay($08)
			CSF_Jump _triangle_loop7

_noise:
_noise_loop6:
			CSF_SetLoopCount $02
_noise_loop1:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c0, $c1
			CSF_Loop _noise_loop1

			CSF_SetLoopCount $02
_noise_loop2:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop2

			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop3

			.byte $c0, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0, $c0
			.byte $c0, $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop4:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop4

			.byte $c0, $c0, $00, $c0
			.byte $00, $c0, $c0, $00
			.byte $00, $00, $00, $00
			.byte $00
			CSF_Command $96, $59 ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop5:
			.byte $c1
			.byte cDelay($03), $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop5

			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c0, $c1, $c0, $c1
			.byte $c1, $c1, $c1, $c0
			.byte $c1, $c1, $c0, $c1
			.byte $c1, $00, $00, $00
			CSF_Command $96, $69 ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			CSF_Jump _noise_loop6
			CSF_Stop
_triangle_cmd9c_1:
			.byte cDelay($1f), $01
_triangle_cmd9c_2:
			.byte cDelay($1f)
			.byte cDelay($1e), $03