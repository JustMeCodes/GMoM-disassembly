_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0a
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $09
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			.byte NC4S
			.byte cDelay($08), NF3S, NA3
			.byte cDelay($05), NC4S
			.byte cDelay($08), NF4S
			.byte cDelay($05), NA4
			.byte cDelay($0b), NG4S, NE4
			.byte cDelay($08), NC4S, NA3
			.byte cDelay($05), NC4S
			.byte cDelay($08), NE4
			.byte cDelay($05), NB3
			.byte cDelay($0b), NF3S
			.byte cDelay($08), NF3S
			.byte cDelay($05), NG3S, NA3
			.byte cDelay($0b), $00
			.byte cDelay($05), NA3, NB3, NA3
			.byte NC4S
			.byte cDelay($0a), NG3S
			.byte cDelay($05), NG3S
			.byte cDelay($08), NG3S
			CSF_Command $96, $7b ; Undocumented command
			.byte NF3S
			.byte cDelay($0b), NA3
			.byte cDelay($08), NB3
			CSF_Command $96, $77 ; Undocumented command
			.byte NG3S
			.byte cDelay($0b)
			CSF_Command $96, $6e ; Undocumented command
			.byte NE3
			CSF_Command $96, $66 ; Undocumented command
			.byte NF3S
			.byte cDelay($08), NC3S, NB2, NC3S
			.byte NA2
			.byte cDelay($0e)
			CSF_Command $91, $01 ; Undocumented command
			CSF_Stop

_pulse2:
			.byte $00
			.byte cDelay($07), NC4S
			.byte cDelay($08), NF3S, NA3
			.byte cDelay($05), NC4S
			.byte cDelay($08), NF4S
			.byte cDelay($05), NA4
			.byte cDelay($0b), NG4S, NE4
			.byte cDelay($08), NC4S, NA3
			.byte cDelay($05), NC4S
			.byte cDelay($08), NE4
			.byte cDelay($05), NB3
			.byte cDelay($0b), NF3S
			.byte cDelay($08), NF3S
			.byte cDelay($05), NG3S, NA3
			.byte cDelay($0b), $00
			.byte cDelay($05), NA3, NB3, NA3
			.byte NC4S
			.byte cDelay($0a), NG3S
			.byte cDelay($05), NG3S
			.byte cDelay($08), NG3S
			CSF_Command $96, $7b ; Undocumented command
			.byte NF3S
			.byte cDelay($0b), NA3
			.byte cDelay($08), NB3
			CSF_Command $96, $77 ; Undocumented command
			.byte NG3S
			.byte cDelay($0b)
			CSF_Command $96, $6e ; Undocumented command
			.byte NE3
			CSF_Command $96, $66 ; Undocumented command
			.byte NF3S
			.byte cDelay($08), NC3S, NB2, NC3S
			.byte NA2
			.byte cDelay($0e)
			CSF_Stop

_triangle:
			.byte NF2S
			.byte cDelay($0a), NF2S
			.byte cDelay($05), NF2S
			.byte cDelay($0a), NF2S
			.byte cDelay($05), NF2
			.byte cDelay($0b), NF2, NE2, NE2
			.byte ND2S, ND2S
			.byte cDelay($0a), ND2S
			.byte cDelay($05), ND2
			.byte cDelay($0a), ND2
			.byte cDelay($05), ND2
			.byte cDelay($0b), NC2S, NC2S
			.byte cDelay($08), NC2S
			CSF_Command $96, $7b ; Undocumented command
			.byte NB1
			.byte cDelay($0a), NB1
			.byte cDelay($05), NB1
			.byte cDelay($0b)
			CSF_Command $96, $77 ; Undocumented command
			.byte NC2S
			CSF_Command $96, $6e ; Undocumented command
			.byte NC2S
			CSF_Command $96, $66 ; Undocumented command
			CSF_SetVoice $09
			.byte $16
			.byte cDelay($00), $60
			CSF_Stop

_noise:
			CSF_Command $8a, $fa ; Undocumented command
			CSF_SetLoopCount $06
_noise_loop1:
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $06 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fa ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop1

			CSF_Command $96, $7b ; Undocumented command
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $06 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fa ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $96, $77 ; Undocumented command
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $96, $6e ; Undocumented command
			CSF_Command $8a, $06 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fa ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $96, $66 ; Undocumented command
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $06 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fa ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Stop