;-------------------------------------------------------------------------------
;	CSF - Compile Sound Format
;-------------------------------------------------------------------------------

;	Track header

CSF_HeaderStart .function end_label
			.byte (end_label-*-1)/10
		.endf

CSF_HeaderChID .segment id
HCSF_CHANNEL_ID .var \id
		.endsegment

CSF_HeaderInitLoop .segment loop_count
HCSF_CHANNEL_LOOP .var \loop_count
		.endsegment

CSF_HeaderInitVoice .segment voice
HCSF_INIT_VOICE .var \voice
		.endsegment

CSF_HeaderPitch .segment pitch
HCSF_PITCH .var \pitch
		.endsegment

CSF_HeaderTempo .segment tempo
HCSF_TEMPO .var \tempo
		.endsegment

CSF_HeaderPulseSetup .segment duty, env_loop, cvolume, volume
			.cerror \duty > 3 || \env_loop > 1 || \cvolume > 1 || \volume > 15, "Invalid value"
HCSF_PULSE_SETUP .var \duty << 6 | \env_loop << 5 | \cvolume << 4 | \volume
		.endsegment

CSF_HeaderPulseSweep .segment enable, period, negate, shift_count
			.cerror \enable > 1 || \period > 7 || \negate > 1 || \shift_count > 7, "Invalid value"
HCSF_PULSE_SWEEP .var \enable << 7 | \period << 4 | \negate << 3 | \shift_count
		.endsegment

CSF_HeaderPulse .segment id, address
			.cerror \id < 1 || \id > 2, "Invalid pulse channel"
			.byte HCSF_CHANNEL_ID, HCSF_CHANNEL_LOOP
			.byte HCSF_PULSE_SETUP, HCSF_INIT_VOICE
			.byte HCSF_PULSE_SWEEP
			.byte HCSF_PITCH, HCSF_TEMPO, \id-1
			.addr \address
		.endsegment

CSF_HeaderTriSetup .segment c_flag, linear_load, unk
			.cerror \c_flag > 1 || \linear_load > $7f, "Invalid value"
HCSF_TRI_SETUP .var \c_flag << 7 | \linear_load
HCSF_TRI_UNK .var \unk
		.endsegment

CSF_HeaderTriangle .segment address
			.byte HCSF_CHANNEL_ID, HCSF_CHANNEL_LOOP
			.byte HCSF_TRI_SETUP, HCSF_INIT_VOICE
			.byte HCSF_TRI_UNK
			.byte HCSF_PITCH, HCSF_TEMPO, $02
			.addr \address
		.endsegment

CSF_HeaderNoiseSetup .segment env_loop, cvolume, volume, unk
			.cerror \env_loop > 1 || \cvolume > 1 || \volume > $f, "Invalid value"
HCSF_NOISE_SETUP .var \env_loop << 5 | \cvolume << 4 | \volume
HCSF_NOISE_UNK .var \unk
		.endsegment

CSF_HeaderNoise .segment address
			.byte HCSF_CHANNEL_ID, HCSF_CHANNEL_LOOP
			.byte HCSF_NOISE_SETUP, HCSF_INIT_VOICE
			.byte HCSF_NOISE_UNK
			.byte HCSF_PITCH, HCSF_TEMPO, $03
			.addr \address
		.endsegment

;	Track commands

cDelay	.sfunction d, $e0 | d

CSF_Jump .function address
			.byte $80
			.addr address
		.endf

CSF_SetLoopCount .function count, unk=$70
			.byte $8d, unk, count
		.endf

CSF_Loop .function address, unk=$70
			.byte $81, unk
			.addr address
		.endf

CSF_Stop .function
			.byte $82
		.endf

CSF_SetVoice .function id
			.byte $88, id
		.endf
		
CSF_PlaySound .function id
			.byte $8b, id
		.endf
		
CSF_Nop .function
			.byte $8c
		.endf

; Undocumented track commands
		
CSF_Cmd9C .function address, y
			.byte $9c, y
			.addr address
		.endf

CSF_Command .function id, value
			.byte id, value
		.endf

CSF_CommandFiller .function id, value
			.byte id, $70, value
		.endf

; Notes

NB0     = $0f
NC1     = $10

NG1   = $17
NG1S   = $18
NA1     = $19
NA1S    = $1a
NB1     = $1b
NC2     = $1c
NC2S     = $1d
ND2     = $1e
ND2S     = $1f
NE2     = $20
NF2     = $21
NF2S     = $22
NG2     = $23
NG2S     = $24
NA2     = $25
NA2S     = $26
NB2     = $27
NC3     = $28
NC3S     = $29
ND3     = $2a
ND3S     = $2b
NE3     = $2c
NF3     = $2d
NF3S     = $2e
NG3     = $2f
NG3S     = $30
NA3     = $31
NA3S     = $32
NB3     = $33
NC4     = $34
NC4S     = $35
ND4     = $36
ND4S     = $37
NE4     = $38
NF4     = $39
NF4S     = $3A
NG4     = $3B
NG4S     = $3C
NA4     = $3D
NA4S     = $3E
NB4     = $3F
NC5     = $40
NC5S     = $41
ND5     = $42
ND5S     = $43
NE5     = $44
NF5     = $45
NF5S     = $46
NG5     = $47
NG5S     = $48
NA5     = $49

NB5     = $4b
NC6S     = $4d
ND6     = $4e
NF6     = $52
NA6     = $55
NC7     = $58
ND7     = $5b
NF7     = $5e