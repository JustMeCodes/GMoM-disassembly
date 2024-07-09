_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $88
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $09
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $88
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $18
			CSF_HeaderTempo $88
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0e, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $88
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			.byte NF2S
			.byte cDelay($08), NF2
			.byte cDelay($05), NF2S, NG2S
			.byte cDelay($08), NF2S
			.byte cDelay($05), NG2S
			CSF_Command $96, $80 ; Undocumented command
			.byte NA2
			.byte cDelay($08), NG2S
			.byte cDelay($05), NA2
			CSF_Command $96, $77 ; Undocumented command
			.byte NB2
			.byte cDelay($08), NA2
			.byte cDelay($05), NB2
			CSF_Command $96, $6e ; Undocumented command
			.byte NC3S, $00, NC3S
			.byte cDelay($0e)
			CSF_Stop

_pulse2:
			.byte NF4S
			.byte cDelay($03), NF4, NE4, ND4S
			.byte ND4, NC4S, NC4, NB3
			.byte NE4, ND4S, ND4, NC4S
			.byte NC4, NB3, NA3S, NA3
			CSF_Command $96, $80 ; Undocumented command
			CSF_SetVoice $01
			CSF_Command $83, $01 ; Undocumented command
			CSF_Command $8a, $04 ; Undocumented command
			.byte NF3S
			.byte cDelay($08), NF3
			.byte cDelay($05), NF3S
			CSF_Command $96, $77 ; Undocumented command
			.byte NG3S
			.byte cDelay($08), NF3S
			.byte cDelay($05), NG3S
			CSF_Command $96, $6e ; Undocumented command
			.byte NF3, ND3S, NF3
			.byte cDelay($0e)
			CSF_Stop

_triangle:
			.byte $16
			.byte cDelay($05), $16, $16, $16
			.byte NG1S, NG1S, NG1S, NG1S
			CSF_Command $96, $80 ; Undocumented command
			.byte NA1, NA1, NA1, NA1
			CSF_Command $96, $77 ; Undocumented command
			.byte NB1, NB1, NB1, NB1
			CSF_Command $96, $6e ; Undocumented command
			CSF_SetVoice $01
			.byte NC2S, $00, $11
			.byte cDelay($0e)
			CSF_Stop

_noise:
			.byte $c0
			.byte cDelay($03), $c0, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			.byte $c1, $c1, $c1, $c1
			CSF_Command $96, $80 ; Undocumented command
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Command $96, $77 ; Undocumented command
			.byte $c0, $c1, $c1, $c1
			.byte $c0, $c1, $c1, $c1
			CSF_Command $96, $6e ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0
			.byte cDelay($0e)
			CSF_Stop