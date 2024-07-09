_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $f7
			CSF_HeaderTempo $78
			CSF_HeaderPulse 1, _pulse1

			; Triangle
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $00, $7f, $41
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $03
			CSF_HeaderTempo $78
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $00, $00, $00
			CSF_HeaderPitch $03
			CSF_HeaderTempo $78
			CSF_HeaderPulse 2, _pulse2

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0b, $00
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $78
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			CSF_SetVoice $04
			.byte NG2
			.byte cDelay($01), NG2S
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff ; Undocumented command
			.byte NG1S
			.byte cDelay($08), NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S
_pulse1_loop2:
			CSF_SetVoice $07
			CSF_Command $8a, $01 ; Undocumented command
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S, NE2
			.byte NF2S, NG2S, NA2, NG2S
			.byte NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S, NE2
			.byte NF2S, NG2S, NA2, NG2S
			.byte NF2S
			.byte cDelay($08), NB2
			.byte cDelay($05), NA2, NG2S
			.byte cDelay($08), NB2
			.byte cDelay($05), NA2, NG2S
			.byte cDelay($08), NB2
			.byte cDelay($05), NA2, NG2S, NF2S
			.byte NG2S, NA2, NB2, NA2
			.byte NG2S
			.byte cDelay($08), NB2
			.byte cDelay($05), NA2, NG2S
			.byte cDelay($08), NB2
			.byte cDelay($05), NA2, NG2S
			.byte cDelay($08), NB2
			.byte cDelay($05), NA2, NG2S, NF2S
			.byte NG2S, NA2, NB2, NA2
			.byte NG2S, NB2, NB2, NA2
			.byte NA2, NG2S, NG2S, NF2S
			CSF_Loop _pulse1_loop1

			CSF_SetVoice $04
			.byte NC3
			.byte cDelay($01), NC3S
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff ; Undocumented command
			.byte NG1S
			.byte cDelay($08), NG1S, NG1S, NG1S
			.byte NG1S
			CSF_Command $8a, $01 ; Undocumented command
			.byte NG2
			.byte cDelay($01), NG2S
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff ; Undocumented command
			.byte NG1S
			.byte cDelay($08)
			CSF_Command $8a, $01 ; Undocumented command
			.byte NG2
			.byte cDelay($01), NG2S
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff ; Undocumented command
			.byte NG1S
			.byte cDelay($08), NG1S, NG1S
			CSF_Command $8a, $01 ; Undocumented command
			.byte NG2
			.byte cDelay($01), NG2S
			.byte cDelay($00), $0b
			CSF_Command $8a, $ff ; Undocumented command
			.byte NG1S
			.byte cDelay($08), NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S
			CSF_Command $8a, $01 ; Undocumented command
			CSF_Jump _pulse1_loop2
			CSF_Stop

_triangle:
			CSF_SetVoice $04
			.byte NC2S
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0e)
_triangle_loop5:
			CSF_SetVoice $07
			CSF_SetLoopCount $03
_triangle_loop1:
			.byte $00
			.byte cDelay($0e), $00, $00
			.byte cDelay($08)
			CSF_Loop _triangle_loop1

			.byte $00
			.byte cDelay($0e), $00, $00
			CSF_Command $83, $43 ; Undocumented command
			CSF_SetLoopCount $02
_triangle_loop2:
			.byte NA3
			.byte cDelay($05), NG3S, NF3S
			.byte cDelay($08), NA3
			.byte cDelay($05), NG3S, NF3S
			.byte cDelay($08), NA3
			.byte cDelay($05), NG3S, NF3S, NE3
			.byte NF3S, NG3S, NA3, NG3S
			.byte NF3S
			.byte cDelay($08)
			CSF_Loop _triangle_loop2

			CSF_SetLoopCount $01
_triangle_loop4:
			.byte NB3
			.byte cDelay($05), NA3, NG3S
			.byte cDelay($08), NB3
			.byte cDelay($05), NA3, NG3S
			.byte cDelay($08), NB3
			.byte cDelay($05), NA3, NG3S, NF3S
			.byte NG3S, NA3, NB3, NA3
			CSF_Loop _triangle_loop3

			.byte NG3S
			.byte cDelay($08)
			CSF_Jump _triangle_loop4
_triangle_loop3:
			.byte NG3S
			.byte cDelay($05), NB3, NB3, NA3
			.byte NA3, NG3S, NG3S, NF3S
			CSF_Command $83, $40 ; Undocumented command
			CSF_SetVoice $04
			.byte NG3S
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0b), NC3S
			.byte cDelay($08), $00, NC3S, $00
			.byte cDelay($0d), NC3S
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0e)
			CSF_Jump _triangle_loop5
			CSF_Stop

_pulse2:
			.byte $00
			.byte cDelay($0e), $00
_pulse2_loop3:
			CSF_SetLoopCount $02
_pulse2_loop1:
			.byte $16
			.byte cDelay($08), $16, $16, $16
			.byte $16, $16
			.byte cDelay($05), $14, $16, $00
			.byte $16, $00, $16, $16
			CSF_Loop _pulse2_loop1

			.byte NG1S
			.byte cDelay($08), NG1S, NG1S, NG1S
			.byte NG1S, NG1S
			.byte cDelay($05), $16, NG1S, $00
			.byte NG1S, $00, NG1S, NG1S
			.byte NG1S
			.byte cDelay($08), NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte cDelay($05), NG1S, NG1S, NB1
			.byte cDelay($08), NA1, NG1S, $16
			.byte cDelay($05)
			CSF_SetLoopCount $02
_pulse2_loop2:
			.byte $16
			.byte cDelay($08), $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $16
			CSF_Loop _pulse2_loop2

			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S
			.byte cDelay($05), NB1
			.byte cDelay($08), NA1, NG1S, $16
			.byte cDelay($05), NG1S
			.byte cDelay($08), $00
			.byte cDelay($0d), $00
			.byte cDelay($0e), $00, $00, $00
			CSF_Jump _pulse2_loop3
			CSF_Stop

_noise:
			.byte $00
			.byte cDelay($0e), $00
			.byte cDelay($0d), $00
			.byte cDelay($05), $c0
			.byte cDelay($03), $c0
			CSF_Command $8a, $fb ; Undocumented command
_noise_loop1:
			.byte $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Jump _noise_loop1
			CSF_Stop