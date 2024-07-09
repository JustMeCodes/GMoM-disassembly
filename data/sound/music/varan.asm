_header_start:
			CSF_HeaderStart _header_end

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $00, $01, $01, $0c
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $fd
			CSF_HeaderTempo $80
			CSF_HeaderPulse 2, _pulse2

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3f, $40
			CSF_HeaderInitVoice $03
			CSF_HeaderPitch $15
			CSF_HeaderTempo $80
			CSF_HeaderTriangle _triangle

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0d, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $80
			CSF_HeaderNoise _noise

_header_end:

_pulse1_loop1:
_pulse1:
			.byte NE3
			.byte cDelay($05), NC3, NA2, NC3
			.byte NE3, NA2, ND3S, NB2
			.byte NA2, NB2, ND3S, NA2
			.byte ND3, NA2S, NA2, NA2S
			.byte ND3, NA2, NB2, NG2S
			.byte NE2, NG2S, NB2, NG2S
			.byte NC3, NA2, NE2, NA2
			.byte NC3, NA2, ND3, NB2
			.byte NE2, NB2, ND3, NB2
			.byte NC3, NA2, NE2, NA2
			.byte NC3, NA2
			CSF_Jump _pulse1_loop1

_pulse2:
			.byte $00
			.byte cDelay($07)
_pulse2_loop1:
			.byte NE3
			.byte cDelay($05), NC3, NA2, NC3
			.byte NE3, NA2, ND3S, NB2
			.byte NA2, NB2, ND3S, NA2
			.byte ND3, NA2S, NA2, NA2S
			.byte ND3, NA2, NB2, NG2S
			.byte NE2, NG2S, NB2, NG2S
			.byte NC3, NA2, NE2, NA2
			.byte NC3, NA2, ND3, NB2
			.byte NE2, NB2, ND3, NB2
			.byte NC3, NA2, NE2, NA2
			.byte NC3, NA2
			CSF_Jump _pulse2_loop1

_triangle_loop2:
_triangle:
			CSF_SetLoopCount $07
_triangle_loop1:
			.byte NA1
			.byte cDelay($05), NA1, NA1, NA1
			.byte NA1, NA1
			CSF_Cmd9C _triangle_cmd9c_1, $07
			CSF_Loop _triangle_loop1

			CSF_Jump _triangle_loop2

_noise:
_noise_loop1:
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			.byte cDelay($03), $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			CSF_Jump _noise_loop1
_triangle_cmd9c_1:
			.byte $00, $00
			.byte cDelay($1b), $00, $00, $00
			.byte $05