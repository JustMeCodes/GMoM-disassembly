_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $02
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1:
			.byte $00
			.byte cDelay($08), NC3S
			.byte cDelay($05), ND3, NC3S
			.byte cDelay($0b), NF3S
			.byte cDelay($05), $00, NC5S, ND5
			.byte NC5S
			.byte cDelay($0d)
			CSF_Stop

_pulse2:
			.byte $00
			.byte cDelay($08), NC4S
			.byte cDelay($03), NC3S, NF3S, NC3S
			.byte NC4S, NC3S, NF3S, NF4S
			.byte NC4S, NC3S, NF3S, NC3S
			CSF_Command $8a, $00 ; Undocumented command
			.byte NF4S, NG4, NG4S, NA4
			.byte NA4S, NB4, NC5
			CSF_SetVoice $04
			.byte NC5S
			.byte cDelay($0d)
			CSF_Stop

_triangle:
			.byte $00
			.byte cDelay($08), $16
			.byte cDelay($05), NC2S, $16, NC2S
			.byte $16, NC2S, $16, NC2S
			.byte $16, NC2S, NF2S
			.byte cDelay($0d)
			CSF_Stop

_noise:
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			CSF_Command $8a, $fd ; Undocumented command
			.byte $c0
			.byte cDelay($05), $c0
			CSF_Command $8a, $03 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fd ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $03 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fd ; Undocumented command
			.byte $c0
			CSF_Command $8a, $03 ; Undocumented command
			.byte $c0
			.byte cDelay($03), $c0, $c0, $c0
			.byte $c0
			CSF_Stop