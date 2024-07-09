_header_start:
			CSF_HeaderStart _header_end

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $01
			CSF_HeaderPitch $18
			CSF_HeaderTempo $8c
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0c
			CSF_HeaderInitVoice $06
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $8c
			CSF_HeaderPulse 2, _pulse2

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $0c
			CSF_HeaderTempo $8c
			CSF_HeaderPulse 1, _pulse1

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0f, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $8c
			CSF_HeaderNoise _noise

_header_end:

_triangle:
			.byte NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S, NE2
			.byte NF2S, NG2S, NA2, NB2
			.byte NC3S
			.byte cDelay($00), NE2
			CSF_Stop

_pulse2:
			.byte $00
			.byte cDelay($03), NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S
			.byte cDelay($08), NA2
			.byte cDelay($05), NG2S, NF2S, NE2
			.byte NF2S, NG2S, NA2, NB2
			.byte NC3S
			.byte cDelay($00), NE2
			CSF_Stop

_pulse1:
			CSF_SetLoopCount $02
_pulse1_loop1:
			.byte NA1
			.byte cDelay($03), NA2, NG1S, NG2S
			.byte $16, NF2S
			CSF_Command $8a, $fe ; Undocumented command
			.byte $16, NF2S
			CSF_Command $8a, $02 ; Undocumented command
			CSF_Loop _pulse1_loop1

			CSF_Command $8a, $fe ; Undocumented command
			.byte NA1, NA2, NG1S, NG2S
			.byte $16, NF2S, $14, NE2
			.byte $16, NF2S, NG1S, NG2S
			.byte NA1, NA2, NB1, NB2
			.byte NC3S
			.byte cDelay($00), NE2
			CSF_Stop

_noise:
			CSF_SetLoopCount $04
_noise_loop1:
			.byte $c0
			.byte cDelay($03), $c1, $c1, $c1
			CSF_Loop _noise_loop1

			CSF_SetLoopCount $04
_noise_loop2:
			.byte $c0
			.byte cDelay($03), $c0, $c1
			CSF_Loop _noise_loop2

			.byte $c0, $c0, $c0, $c0
			CSF_Stop