_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $02
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0e
			CSF_HeaderInitVoice $01
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

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
			.byte NC3S
			.byte cDelay($08), $00
			.byte cDelay($04), $00, NF3S, NB3
			.byte NF3S, NB3, NC4S, NB3
			.byte NC4S, NF3S, NF3S, NF3S
			.byte NB2, NB2, NB2, NC3S
			.byte NC3S, NC3S, NF3S, NF3S
			.byte NF3S, NB3
			.byte cDelay($05), NE3, NF3S, NB3
			.byte NE3, NF3S, NB3, NE3
			.byte NC3S
			.byte cDelay($04), NF3S, NG3S
			.byte cDelay($00), NC3
			CSF_Stop

_triangle:
			.byte $00
			.byte cDelay($0e), NC3S
			.byte cDelay($08), $00
			.byte cDelay($04), $00, NF3S, NB3
			.byte NF3S, NB3, NC4S, NB3
			.byte NC4S, NF3S
			.byte cDelay($05), NB2, NC3S, NF3S
			.byte NB2, NC3S, NF3S, NB2
			.byte NF3S
			.byte cDelay($04), NG3S, NC4S
			.byte cDelay($00), NC3
			CSF_Command $91, $01 ; Undocumented command
			CSF_Stop

_pulse2:
			.byte $00
			.byte cDelay($05), NC3S
			.byte cDelay($08), $00
			.byte cDelay($04), $00, NF3S, NB3
			.byte NF3S, NB3, NC4S, NB3
			.byte NC4S, NF3S
			.byte cDelay($08), NB2, NC3S, NF3S
			.byte cDelay($05)
			CSF_Command $8a, $00 ; Undocumented command
			.byte NC3S
			.byte cDelay($08), $00
			.byte cDelay($04), $00, NF3S, NB3
			.byte NF3S, NB3, NC4S, NB3
			.byte NC4S, NF4S, NG4S, NC5S
			.byte cDelay($00), NC3
			CSF_Stop

_noise:
			.byte $00
			.byte cDelay($04), $00, $00, $00
			.byte $00, $00, $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			CSF_SetLoopCount $02
_noise_loop1:
			.byte $c0
			.byte cDelay($04), $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			CSF_Loop _noise_loop1

			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			.byte cDelay($02), $c0, $c0
			.byte cDelay($04), $c0
			CSF_Stop