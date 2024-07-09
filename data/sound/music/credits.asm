_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $09
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3e, $40
			CSF_HeaderInitVoice $01
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $77
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $77
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop1:
_pulse1:
			.byte NF4S
			.byte cDelay($05), $00, NE4, $00
			.byte NF4S, $00, NE4, NF4S
			.byte $00, NE4, NF4S, $00
			.byte NA4, $00, NG4S, $00
			.byte NF4S, $00, NE4, $00
			.byte NF4S, $00, NE4, NB3
			.byte $00, NB3
			.byte cDelay($0d), $00
			.byte cDelay($05), NF4S, $00, NE4
			.byte $00, NF4S, $00, NE4
			.byte NF4S, $00, NE4, NF4S
			.byte $00, NA4, $00, NG4S
			.byte $00, NF4S, $00, NE4
			.byte $00, NF4S, $00, NB4
			.byte NB4, $00, NB4
			.byte cDelay($0b), NG4S
			.byte cDelay($05), NA4, $00, NB4
			.byte $00, NC5S
			.byte cDelay($0e), NC5S
			.byte cDelay($08), NB4, NA4, NG4S
			.byte NB4
			.byte cDelay($0d), NA4
			.byte cDelay($05), NG4S, NA4
			.byte cDelay($0e), NB4, NB4
			.byte cDelay($08), NA4, NG4S
			.byte cDelay($05), NF4S
			.byte cDelay($0a), NE4
			.byte cDelay($00), $60, NF4S
			.byte cDelay($05), NE4, NF4S, NA4
			.byte $00, NC5S, NF5S, $00
			.byte NF5S
			.byte cDelay($0e), NE4
			.byte cDelay($05), ND4, NE4, NG4S
			.byte $00, NB4, NE5, $00
			.byte NE5
			.byte cDelay($0e), NF4S
			.byte cDelay($05), NE4, NF4S, NA4
			.byte $00, NC5S, NF5S, $00
			.byte NF5S
			.byte cDelay($0b), NA5
			.byte cDelay($08), NG5S, NF5S
			.byte cDelay($0d), NG5S
			.byte cDelay($08), NB4
			.byte cDelay($0e), ND5
			.byte cDelay($0d), NE5
			.byte cDelay($05), ND5, ND5
			.byte cDelay($08), NC5S, NB4, NA4
			.byte NC5S
			.byte cDelay($0d), NA4
			.byte cDelay($08), NE4
			.byte cDelay($0e), NB4
			.byte cDelay($0d), NC5S
			.byte cDelay($05), NB4, NB4
			.byte cDelay($08), NC5S, ND5, NE5
			.byte NA4
			.byte cDelay($0e), NE5
			CSF_Jump _pulse1_loop1

_pulse2:
_pulse2_loop2:
			.byte NC3S
			.byte cDelay($00), $60, NB2
			.byte cDelay($0e), $00
			.byte cDelay($05), NB2
			.byte cDelay($00), ND3, NC3S
			.byte cDelay($00), $60, NB2
			.byte cDelay($00), $6c, NC3S
			.byte cDelay($00), $60, ND3, ND3
			.byte NB2
			CSF_SetVoice $04
			CSF_Command $83, $00 ; Undocumented command
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte NC4S
			.byte cDelay($05), NA3, NF3S, ND3
			.byte NC4S, NA3, NF3S, ND3
			.byte NC4S, NA3, NF3S, ND3
			.byte NC4S, NA3, NC4S, NF4S
			.byte NB3, NG3S, NE3, NC3S
			.byte NB3, NG3S, NE3, NC3S
			.byte NB3, NG3S, NE3, NC3S
			.byte NB3, NG3S, NE3, NC3S
			CSF_Loop _pulse2_loop1

			CSF_SetVoice $01
			CSF_Command $83, $41 ; Undocumented command
			.byte ND3
			.byte cDelay($00), $60, NC3S
			.byte cDelay($0e), NC3S
			.byte cDelay($08), NE3, NA3, NC4S
			.byte NB2
			.byte cDelay($00), $60, NA2
			.byte cDelay($0e), NA1
			.byte cDelay($0a), NC2S
			.byte cDelay($05), NE2, NA2, NC3S
			.byte NE3
			CSF_Jump _pulse2_loop2

_triangle:
_triangle_loop1:
			.byte NA2
			.byte cDelay($00), $60, NG2S
			.byte cDelay($0e), $00
			.byte cDelay($05), NG2S
			.byte cDelay($00), ND3, NA2
			.byte cDelay($00), $60, NG2S
			.byte cDelay($00), $6c, NF2
			.byte cDelay($08), NC2S, NG2S, NF2
			.byte NB2, NA2, NG2S, NF2
			.byte NA2
			.byte cDelay($0e), NF2S, ND2
			.byte cDelay($08), NB1, NF2S, ND2
			.byte NB2, NA2, NG2S, NF2S
			.byte NE2
			.byte cDelay($0e), NG2S, NA2
			.byte cDelay($00), $60, NG2S, NA2
			.byte NG2S, NB2, NA2, NG2
			.byte NE2
			CSF_Jump _triangle_loop1

_noise:
_noise_loop6:
			CSF_Command $8a, $fb ; Undocumented command
			CSF_SetLoopCount $03
_noise_loop1:
			.byte $c0
			.byte cDelay($08), $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			.byte cDelay($08)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Loop _noise_loop1

			.byte $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $00, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			.byte cDelay($08)
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			.byte cDelay($05)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_SetLoopCount $07
_noise_loop2:
			.byte $c0
			.byte cDelay($08), $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Loop _noise_loop2

			.byte $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			.byte cDelay($08), $c0
			.byte cDelay($05), $c0, $c0, $c0
			CSF_SetLoopCount $03
_noise_loop3:
			.byte $c0
			.byte cDelay($05)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00, $c0, $c0
			.byte $00, $c0
			.byte cDelay($08)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Loop _noise_loop3

			CSF_SetLoopCount $02
_noise_loop4:
			.byte $c0
			.byte cDelay($08)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Loop _noise_loop4

			CSF_Command $8a, $fb ; Undocumented command
			CSF_SetLoopCount $07
_noise_loop5:
			.byte $c0
			.byte cDelay($08), $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00
			.byte cDelay($05)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Loop _noise_loop5

			.byte $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0
			CSF_Jump _noise_loop6