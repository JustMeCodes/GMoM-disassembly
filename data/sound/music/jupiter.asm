_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0e
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $15
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0e, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop1:
_pulse1:
			.byte NE3
			.byte cDelay($04), NF3S, NG3, NA3
			.byte cDelay($00), NG5S, NE3
			.byte cDelay($04), NF3S, NG3, NA3
			.byte cDelay($08), NG3
			.byte cDelay($00), NG5S, NA3
			.byte cDelay($04), NB3, NC4, ND4
			.byte cDelay($00), NG5S, NA3
			.byte cDelay($04), NB3, NC4, ND4
			.byte cDelay($08), NC4
			.byte cDelay($00), $60, NF3S
			.byte cDelay($08), ND3
			.byte cDelay($0b), NA2
			.byte cDelay($08), NF2S, NA2
			.byte cDelay($05), NF3S
			.byte cDelay($08), NE3
			.byte cDelay($05), ND3
			.byte cDelay($08), NF3, NC3
			.byte cDelay($0b), NA2
			.byte cDelay($08), NF2, NA2
			.byte cDelay($05), NF3
			.byte cDelay($08), NE3
			.byte cDelay($05), NC3
			.byte cDelay($08), ND3, NB2
			.byte cDelay($0d), NG3
			.byte cDelay($08), ND3
			.byte cDelay($0a), ND3
			.byte cDelay($05), NE3, NF3, NE3
			.byte cDelay($08), NF3S, NG3, NB3
			.byte cDelay($04), NA3, NB3, NA3
			.byte cDelay($0e), NF3S
			.byte cDelay($0d), NG3
			.byte cDelay($05), NE3, NF3S
			.byte cDelay($0b), ND3
			.byte cDelay($08), NA2, NC3
			.byte cDelay($0b), NF3
			.byte cDelay($0a), NC4
			.byte cDelay($05), NA3
			.byte cDelay($0e), NA3
			.byte cDelay($08), NG3
			.byte cDelay($0b), ND3
			.byte cDelay($04), NB2, ND3, ND3
			.byte cDelay($0e), NE3
			.byte cDelay($08), NG3S, NB3, ND4
			.byte cDelay($04), NB3, ND4, NF4S
			.byte cDelay($0e)
			CSF_Command $8a, $ff ; Undocumented command
			.byte $00
			CSF_SetVoice $09
			.byte NA3
			.byte cDelay($05), NA3
			.byte cDelay($0a), $00
			.byte cDelay($0b), $00
			.byte cDelay($0e), NA3
			.byte cDelay($05), NA3
			.byte cDelay($0a)
			CSF_Command $8a, $01 ; Undocumented command
			.byte $00
			.byte cDelay($0b)
			CSF_SetVoice $06
			CSF_Jump _pulse1_loop1

_pulse2:
_pulse2_loop1:
			.byte NA2
			.byte cDelay($04), NB2, NC3, ND3
			.byte cDelay($00), NG5S, NA2
			.byte cDelay($04), NB2, NC3, ND3
			.byte cDelay($08), NC3
			.byte cDelay($00), NG5S, NE3
			.byte cDelay($04), NF3S, NG3, NA3
			.byte cDelay($00), NG5S, NE3
			.byte cDelay($04), NF3S, NG3, NA3
			.byte cDelay($08), NG3
			.byte cDelay($00), $60
			CSF_Command $8a, $fc ; Undocumented command
			CSF_Command $a0, $b0 ; Undocumented command
			.byte $00
			.byte cDelay($07), NF3S
			.byte cDelay($08), ND3
			.byte cDelay($0b), NA2
			.byte cDelay($08), NF2S, NA2
			.byte cDelay($05), NF3S
			.byte cDelay($08), NE3
			.byte cDelay($05), ND3
			.byte cDelay($08), NF3, NC3
			.byte cDelay($0b), NA2
			.byte cDelay($08), NF2, NA2
			.byte cDelay($05), NF3
			.byte cDelay($08), NE3
			.byte cDelay($05), NC3
			.byte cDelay($08), ND3, NB2
			.byte cDelay($0d), NG3
			.byte cDelay($08), ND3
			.byte cDelay($0a), ND3
			.byte cDelay($05), NE3, NF3, NE3
			.byte cDelay($08), NF3S, NG3, NB3
			.byte cDelay($04), NA3, NB3, NA3
			.byte cDelay($0d), $00
			.byte cDelay($03)
			CSF_SetVoice $04
			CSF_Command $83, $00 ; Undocumented command
			CSF_Command $8a, $04 ; Undocumented command
			CSF_Command $a0, $30 ; Undocumented command
			.byte NA2
			.byte cDelay($05), ND3, NF3S, ND4
			.byte NA2, ND3, NF3S, ND4
			.byte NA2, ND3, NF3S, ND3
			.byte ND4, ND3, NA3, NF3S
			.byte NF3, NA3, NC4, NF4
			.byte NF3, NA3, NC4, NF4
			.byte NF3, NA3, NC4, NA3
			.byte NF4, NC4, NA3, NF3
			.byte NG3, NB3, ND4, NG4
			.byte NG3, NB3, ND4, NG4
			.byte NG3, NB3, ND4, NG4
			.byte NB4, NG4, ND4, ND3
			.byte NE3, NG3S, NB3, NE4
			.byte NG4S, NE4, NB3, NG3S
			.byte NE3, NG3S, NB3, NE4
			.byte NB4, NG4S, NE4, NB3
			CSF_Command $8a, $fc ; Undocumented command
			.byte $00
			.byte cDelay($0e)
			CSF_SetVoice $09
			.byte NE3
			.byte cDelay($05), NE3
			.byte cDelay($0a), $00
			.byte cDelay($0b), $00
			.byte cDelay($0e), NE3
			.byte cDelay($05), NE3
			.byte cDelay($0a)
			CSF_Command $8a, $04 ; Undocumented command
			.byte $00
			.byte cDelay($0b)
			CSF_SetVoice $06
			CSF_Command $83, $41 ; Undocumented command
			CSF_Command $a0, $70 ; Undocumented command
			CSF_Jump _pulse2_loop1

_triangle_loop4:
_triangle:
			CSF_SetLoopCount $08
_triangle_loop1:
			.byte NA1
			.byte cDelay($05), $14, $16, NG1
			.byte NA1, $14, $16, NG1
			CSF_Loop _triangle_loop1

			CSF_SetLoopCount $10
_triangle_loop2:
			.byte $12
			.byte cDelay($05), $12, $12, $12
			.byte $12, $12, $12, $12
			CSF_Cmd9C _triangle_cmd9c_1, $10
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $04
_triangle_loop3:
			.byte NA1
			.byte cDelay($05), $16, NG1, NG1S
			.byte NA1, $16, NG1, NG1S
			CSF_Loop _triangle_loop3

			CSF_Jump _triangle_loop4

_noise_loop4:
_noise:
			CSF_SetLoopCount $07
_noise_loop1:
			.byte $c1
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1, $c0
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05)
			CSF_Loop _noise_loop1

			.byte $c1, $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c0, $00, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_SetLoopCount $0f
_noise_loop2:
			.byte $c1
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1, $c0
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05)
			CSF_Loop _noise_loop2

			.byte $c1, $c1
			.byte cDelay($03), $c1, $c0
			.byte cDelay($05), $c1
			.byte cDelay($03), $c1, $c1
			.byte cDelay($05), $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c1
			.byte cDelay($05), $c1, $c0, $c1
			.byte $c1, $c1, $c0, $c1
			CSF_Loop _noise_loop3

			.byte $c1, $c1, $c0, $c1
			.byte $c1, $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Jump _noise_loop4
_triangle_cmd9c_1:
			.byte $00, $03, $00, $02
			.byte $00, $02, $00
			.byte cDelay($19), $00, $03, $00
			.byte $02, $00
			.byte cDelay($1d), $00
			.byte cDelay($1e)