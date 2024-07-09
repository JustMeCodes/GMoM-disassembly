_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $02
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $02
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $1a
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

_pulse1:
_pulse1_loop1:
			.byte NA2
			.byte cDelay($0b), $00
			.byte cDelay($05), NA2, NF2S, NG2
			.byte NG2S
			.byte cDelay($0e), NG2
			.byte cDelay($0b), $00
			.byte cDelay($05), NG2, NE2, NF2
			.byte NF2S
			.byte cDelay($0b), $00
			.byte cDelay($05), NF2S, NG2, NG2S
			.byte NA2
			.byte cDelay($0b), $00
			.byte cDelay($05), NA2, NF2S, NG2
			.byte NG2S
			.byte cDelay($0b), ND3, NG2, $00
			.byte cDelay($05), NG2, NE2, NF2
			.byte NF2S
			.byte cDelay($0e), $00
			.byte cDelay($05), NF2S, NA2, NC3S
			.byte NE3
			.byte cDelay($08), ND3S, ND3
			.byte cDelay($03), $00, NA2S
			.byte cDelay($08), NG2, NA2
			.byte cDelay($03), $00, NA2S
			.byte cDelay($08), $00
			.byte cDelay($05), NF2S, NA2, NC3S
			.byte NE3
			.byte cDelay($08), ND3S, ND3
			.byte cDelay($0b), NA2S, NG2S
			.byte cDelay($08), NB2, ND3S, NF3S
			.byte NF3
			.byte cDelay($0b), ND3, NB2
			.byte cDelay($00), NG5S, $00
			.byte cDelay($0b)
			CSF_Jump _pulse1_loop1

_pulse2:
			.byte $00
			.byte cDelay($07)
_pulse2_loop1:
			.byte NA2
			.byte cDelay($0b), $00
			.byte cDelay($05), NA2, NF2S, NG2
			.byte NG2S
			.byte cDelay($0e), NG2
			.byte cDelay($0b), $00
			.byte cDelay($05), NG2, NE2, NF2
			.byte NF2S
			.byte cDelay($0b), $00
			.byte cDelay($05), NF2S, NG2, NG2S
			.byte NA2
			.byte cDelay($0b), $00
			.byte cDelay($05), NA2, NF2S, NG2
			.byte NG2S
			.byte cDelay($0b), ND3, NG2, $00
			.byte cDelay($05), NG2, NE2, NF2
			.byte NF2S
			.byte cDelay($0e), $00
			.byte cDelay($05), NF2S, NA2, NC3S
			.byte NE3
			.byte cDelay($08), ND3S, ND3
			.byte cDelay($03), $00, NA2S
			.byte cDelay($08), NG2, NA2
			.byte cDelay($03), $00, NA2S
			.byte cDelay($08), $00
			.byte cDelay($05), NF2S, NA2, NC3S
			.byte NE3
			.byte cDelay($08), ND3S, ND3
			.byte cDelay($0b), NA2S, NG2S
			.byte cDelay($08), NB2, ND3S, NF3S
			.byte NF3
			.byte cDelay($0b), ND3, NB2
			.byte cDelay($00), NG5S, $00
			.byte cDelay($0b)
			CSF_Jump _pulse2_loop1

_triangle:
_triangle_loop1:
			.byte NA1
			.byte cDelay($05), NA1, NA1, NA1
			.byte NA1, NA1, NA1, NA1
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1, NG1, NG1, NG1
			.byte NG1, NG1, NG1, NG1
			.byte $16, $16, $16, $16
			.byte $16, $16, NG1, NG1S
			.byte NA1, NA1, NA1, NA1
			.byte NA1, NA1, NA1, NA1
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1, NG1, NG1, NG1
			.byte NG1, NG1, NG1, NG1
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte NG1, NG1, NG1, NG1
			.byte NG1, NG1, NG1, NG1
			.byte $16, $16, $16, $16
			.byte $16, $16, $16, $16
			.byte NG1, NG1, NG1, NG1
			.byte NG1, NG1, NG1, NG1
			.byte NG1S, NG1S, NG1S, NG1S
			.byte NG1S, NG1S, NG1S, NG1S
			.byte $12, $12, $12, $12
			.byte $12, $12, $12, $12
			.byte $14, $14, $14, $14
			.byte $14, $14, $14, $14
			.byte $14, $14, $14, $14
			.byte $14, $14, $14, $14
			CSF_Jump _triangle_loop1

_noise:
			CSF_Command $8a, $fb ; Undocumented command
_noise_loop4:
			CSF_SetLoopCount $03
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop1

			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_SetLoopCount $03
_noise_loop2:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop2

			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $fb ; Undocumented command
			CSF_SetLoopCount $07
_noise_loop3:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Loop _noise_loop3

			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Jump _noise_loop4