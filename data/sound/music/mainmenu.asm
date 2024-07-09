_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $02, $01, $01, $0f
			CSF_HeaderInitVoice $01
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
			CSF_HeaderPitch $fb
			CSF_HeaderTempo $77
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $06
			CSF_HeaderPitch $18
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

_pulse1:
			.byte NE3
			.byte cDelay($03), NF3S, NG3, NA3
			.byte cDelay($00), $63
			CSF_PlaySound $2f ; TODO: that's a sound id, turn it into a label later
			.byte cDelay($00), $0c
			CSF_Stop

_pulse2:
			CSF_Command $89, $05 ; Undocumented command
			.byte NE3
			.byte cDelay($03), NF3S, NG3, NE3
			.byte cDelay($00), $0c, NF3S
			.byte cDelay($07), NG3, ND4
			.byte cDelay($00), $51
			CSF_Stop

_triangle:
			.byte $14
			.byte cDelay($03), $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $14, $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $14, $00, $14, $14
			.byte $00, $14, $00, $14
			.byte $14, $00, $14, $14
			.byte $00, $14, $00, $14
			CSF_Command $91, $01 ; Undocumented command
			CSF_Stop

_noise:
			CSF_Nop
			.byte $c0
			.byte cDelay($03), $00, $c0, $c0
			CSF_Nop
			.byte $c0
			CSF_Nop
			.byte $00, $c0, $c0, $c0
			.byte $00, $c0, $c0
			CSF_Nop
			.byte $c0
			CSF_Nop
			.byte $00, $c0, $c0, $c0
			.byte $00, $c0, $c0
			CSF_Nop
			.byte $c0
			CSF_Nop
			.byte $00, $c0, $c0, $c0
			.byte $00, $c0, $c0
			CSF_Nop
			.byte $c0, $00
			CSF_Nop
			.byte $c0, $c0, $00
			.byte cDelay($0e)
			CSF_Stop