_header_start:
			CSF_HeaderStart _header_end

			; Triangle
			CSF_HeaderChID $02
			CSF_HeaderInitLoop $01
			CSF_HeaderTriSetup $01, $3d, $42
			CSF_HeaderInitVoice $01
			CSF_HeaderPitch $1b
			CSF_HeaderTempo $5d
			CSF_HeaderTriangle _triangle

			; Pulse 1
			CSF_HeaderChID $00
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0f
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $00
			CSF_HeaderPitch $03
			CSF_HeaderTempo $5d
			CSF_HeaderPulse 1, _pulse1

			; Pulse 2
			CSF_HeaderChID $01
			CSF_HeaderInitLoop $01
			CSF_HeaderPulseSetup $01, $01, $01, $0c
			CSF_HeaderInitVoice $04
			CSF_HeaderPulseSweep $00, $04, $00, $01
			CSF_HeaderPitch $03
			CSF_HeaderTempo $5d
			CSF_HeaderPulse 2, _pulse2

			; Noise
			CSF_HeaderChID $03
			CSF_HeaderInitLoop $02
			CSF_HeaderNoiseSetup $01, $01, $0c, $40
			CSF_HeaderInitVoice $04
			CSF_HeaderPitch $00
			CSF_HeaderTempo $5d
			CSF_HeaderNoise _noise

_header_end:

_triangle:
_triangle_loop1:
			.byte NA1
			.byte cDelay($0e), NG1S, NA1, NC2
			.byte NA1
			.byte cDelay($0b), NE2, NC2S, NG2S
			.byte NA2, NE2, NF2, NC2
			CSF_Jump _triangle_loop1

_pulse1:
_pulse1_loop1:
			.byte NA1
			.byte cDelay($05), NC2, NE2, NA2
			.byte NC3, NA2, NE2, NC2
			.byte NC2S, NE2, NG2S, NC3S
			.byte NE3, NC3S, NG2S, NE2
			.byte NA1, NC2, NE2, NA2
			.byte NC3, NA2, NE2, NC2
			.byte $15, NG1S, NC2, NF2
			.byte NG2S, NF2, NC2, NG1S
			CSF_Jump _pulse1_loop1

_pulse2:
			.byte $00
			.byte cDelay($07)
_pulse2_loop1:
			.byte NA1
			.byte cDelay($05), NC2, NE2, NA2
			.byte NC3, NA2, NE2, NC2
			.byte NC2S, NE2, NG2S, NC3S
			.byte NE3, NC3S, NG2S, NE2
			.byte NA1, NC2, NE2, NA2
			.byte NC3, NA2, NE2, NC2
			.byte $15, NG1S, NC2, NF2
			.byte NG2S, NF2, NC2, NG1S
			CSF_Jump _pulse2_loop1

_noise:
_noise_loop1:
			.byte $c0
			.byte cDelay($04)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0, $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0, $00, $c0, $c0
			.byte cDelay($08), $c0
			.byte cDelay($04)
			CSF_Command $8a, $fb ; Undocumented command
			.byte $c0
			CSF_Command $8a, $05 ; Undocumented command
			.byte $c0
			CSF_Jump _noise_loop1