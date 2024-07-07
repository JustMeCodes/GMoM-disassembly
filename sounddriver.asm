;-------------------------------------------------------------------------------
;	Sound driver (Bank 0)
;	Sound driver code - Takayuki Hirono
;-------------------------------------------------------------------------------

			.logical $8000
			BankHeader

Sound_Bank	=	LastBank

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

CSF_SetLoopCount .function count
			.byte $8d, $70, count
		.endf

CSF_Loop .function address
			.byte $81, $70
			.addr address
		.endf

CSF_Stop .macro
			.byte $82
		.endm

CSF_SetVoice .function id
			.byte $88, id
		.endf

CSF_Command .function id, value
			.byte id, value
		.endf

CSF_CommandFiller .function id, value
			.byte id, $70, value
		.endf

;-------------------------------------------------------------------------------
;	Cross bank jump labels
;-------------------------------------------------------------------------------

Sound_Goto_SetupAPU2:
			jmp Sound_SetupAPU2			; $8004: 4c e8 86

;-------------------------------------------------------------------------------
Sound_Goto_SetupAPU:
			jmp Sound_SetupAPU			; $8007: 4c ef 86

;-------------------------------------------------------------------------------
Sound_Goto_PlaySound:
			jmp Sound_PlaySound			; $800a: 4c 2d 87

;-------------------------------------------------------------------------------
Sound_Goto_Update:
			jmp Sound_Update			; $800d: 4c 19 80

;-------------------------------------------------------------------------------
Sound_Goto_8900:
			jmp Sound_8900			; $8010: 4c 00 89

;-------------------------------------------------------------------------------
Sound_Goto_8905:
			jmp Sound_8905			; $8013: 4c 05 89

;-------------------------------------------------------------------------------
Sound_Goto_MusicFadeOut:
			jmp Sound_Sub_MusicFadeOut			; $8016: 4c 64 8b

;-------------------------------------------------------------------------------

Sound_Update:
			lda $030f			; $8019: ad 0f 03
			beq Sound_801f			; $801c: f0 01
			rts				; $801e: 60

;-------------------------------------------------------------------------------
Sound_801f:
			lda $d6			; $801f: a5 d6
			and #$fe				; $8021: 29 fe
			cmp $d6			; $8023: c5 d6
			sta $d6			; $8025: 85 d6
			beq Sound_803d			; $8027: f0 14
			lda #$00				; $8029: a9 00
			jsr Sound_SetupPitchVolume			; $802b: 20 45 87
			ldx #$00				; $802e: a2 00

-			lda $0370,x		; $8030: bd 70 03
			ora #$40				; $8033: 09 40
			sta $0370,x		; $8035: 9d 70 03
			inx				; $8038: e8
			cpx #$07				; $8039: e0 07
			bne -			; $803b: d0 f3

Sound_803d:
			jsr Sound_8665			; $803d: 20 65 86
			ldy #$00				; $8040: a0 00
			lda $d6			; $8042: a5 d6
			and #$02				; $8044: 29 02
			ora $0322			; $8046: 0d 22 03
			beq +			; $8049: f0 02
			ldy #$06				; $804b: a0 06

+			sty $030b			; $804d: 8c 0b 03
Sound_8050:
			ldx $030b			; $8050: ae 0b 03
			lda $031c,x		; $8053: bd 1c 03
			bne Sound_805b			; $8056: d0 03
			jmp Sound_8103			; $8058: 4c 03 81

;-------------------------------------------------------------------------------
Sound_805b:
			tay				; $805b: a8
			lda $0370,x		; $805c: bd 70 03
			and #$7f				; $805f: 29 7f
			sta $0370,x		; $8061: 9d 70 03
			lda $033f,x		; $8064: bd 3f 03
			beq +			; $8067: f0 09
			clc				; $8069: 18
			adc $0385,x		; $806a: 7d 85 03
			sta $0385,x		; $806d: 9d 85 03
			bcc Sound_80ac			; $8070: 90 3a

+			lda $0369,x		; $8072: bd 69 03
			and #$04				; $8075: 29 04
			beq Sound_809e			; $8077: f0 25
			lda $03af,x		; $8079: bd af 03
			beq Sound_809e			; $807c: f0 20
			bmi +			; $807e: 30 0d
			clc				; $8080: 18
			adc $0377,x		; $8081: 7d 77 03
			bcs Sound_8096			; $8084: b0 10
			cmp $037e,x		; $8086: dd 7e 03
			bcc Sound_809e			; $8089: 90 13
			bcs Sound_8096			; $808b: b0 09

+			and #$7f				; $808d: 29 7f
			cmp $0377,x		; $808f: dd 77 03
			beq Sound_8096			; $8092: f0 02
			bcs Sound_809e			; $8094: b0 08
Sound_8096:
			lda #$fb				; $8096: a9 fb
			and $0369,x		; $8098: 3d 69 03
			sta $0369,x		; $809b: 9d 69 03
Sound_809e:
			inc $0377,x		; $809e: fe 77 03
			lda $0377,x		; $80a1: bd 77 03
			cmp $037e,x		; $80a4: dd 7e 03
			bne Sound_80ac			; $80a7: d0 03
			jsr Sound_8228			; $80a9: 20 28 82
Sound_80ac:
			jsr Sound_LoadVoice			; $80ac: 20 6d 85
			jsr Sound_85ed			; $80af: 20 ed 85
			jsr Sound_864a			; $80b2: 20 4a 86
			lda $0369,x		; $80b5: bd 69 03
			bpl +			; $80b8: 10 03
			jsr Sound_818e			; $80ba: 20 8e 81

+			jsr Sound_867c			; $80bd: 20 7c 86
			lda $d6			; $80c0: a5 d6
			and #$3f				; $80c2: 29 3f
			sta $d6			; $80c4: 85 d6
			lda $0369,x		; $80c6: bd 69 03
			and #$20				; $80c9: 29 20
			beq Sound_8103			; $80cb: f0 36
			lda $03c4,x		; $80cd: bd c4 03
			clc				; $80d0: 18
			adc $03cb,x		; $80d1: 7d cb 03
			sta $03cb,x		; $80d4: 9d cb 03
			bcc Sound_8103			; $80d7: 90 2a
			lda $0323,x		; $80d9: bd 23 03
			and #$0f				; $80dc: 29 0f
			cmp $03d2,x		; $80de: dd d2 03
			bne +			; $80e1: d0 0a
			lda $0369,x		; $80e3: bd 69 03
			ora #$02				; $80e6: 09 02
			sta $0369,x		; $80e8: 9d 69 03
			bne Sound_8103			; $80eb: d0 16

+			ldy $0323,x		; $80ed: bc 23 03
			lda $0369,x		; $80f0: bd 69 03
			and #$fd				; $80f3: 29 fd
			sta $0369,x		; $80f5: 9d 69 03
			dey				; $80f8: 88
			and #$10				; $80f9: 29 10
			bne +			; $80fb: d0 02
			iny				; $80fd: c8
			iny				; $80fe: c8

+			tya				; $80ff: 98
			sta $0323,x		; $8100: 9d 23 03
Sound_8103:
			inx				; $8103: e8
			stx $030b			; $8104: 8e 0b 03
			cpx #$06				; $8107: e0 06
			bcs Sound_810e			; $8109: b0 03
			jmp Sound_8050			; $810b: 4c 50 80

;-------------------------------------------------------------------------------
Sound_810e:
			lda $030a			; $810e: ad 0a 03
			cmp #$30				; $8111: c9 30
			bne +			; $8113: d0 04
			lda #$80				; $8115: a9 80
			bne ++			; $8117: d0 02

+			and #$cf				; $8119: 29 cf
+			sta $030a			; $811b: 8d 0a 03
			ldy #$03				; $811e: a0 03
			ldx #$0f				; $8120: a2 0f
Sound_8122:
			lda $02ff,x		; $8122: bd ff 02
			sta $3ffd,x		; $8125: 9d fd 3f

			cpx #$08 ; is it noise channel?
			bcc Sound_8132 ; if not, branch

			; Update noise channel
			lda $0302,x
			jmp Sound_8168

;-------------------------------------------------------------------------------
Sound_8132:
			lda $0300,x		; $8132: bd 00 03
			bmi +			; $8135: 30 02
			lda #$08				; $8137: a9 08

+			sta $3ffe,x		; $8139: 9d fe 3f
			cmp $0314,y		; $813c: d9 14 03
			beq Sound_AudioOut			; $813f: f0 09

			sta $0314,y		; $8141: 99 14 03
			lda $0302,x		; $8144: bd 02 03
			jmp Sound_815f			; $8147: 4c 5f 81

;-------------------------------------------------------------------------------
; Sound_814a:
Sound_AudioOut:
			and #$ff				; $814a: 29 ff
			bpl _8155			; $814c: 10 07
			lda $0302,x		; $814e: bd 02 03
			bpl _8158			; $8151: 10 05
			bmi Sound_815f			; $8153: 30 0a
_8155:
			lda $0302,x		; $8155: bd 02 03
_8158:
			and #$07				; $8158: 29 07
			cmp $0312,y		; $815a: d9 12 03
			beq Sound_8176			; $815d: f0 17

Sound_815f:
			sec				; $815f: 38
			and #$07				; $8160: 29 07
			sta $0312,y		; $8162: 99 12 03
			sta $0302,x		; $8165: 9d 02 03
Sound_8168:
			ora #$f8				; $8168: 09 f8
			sta $4000,x		; $816a: 9d 00 40
Sound_816d:
			lda $0301,x		; $816d: bd 01 03
			sta $3fff,x		; $8170: 9d ff 3f
			jmp Sound_8186			; $8173: 4c 86 81

;-------------------------------------------------------------------------------
Sound_8176:
			lda $0300,x		; $8176: bd 00 03
			bmi Sound_8186			; $8179: 30 0b
			and #$20				; $817b: 29 20
			beq Sound_816d			; $817d: f0 ee
			lda $0302,x		; $817f: bd 02 03
			bpl Sound_816d			; $8182: 10 e9
			bmi Sound_815f			; $8184: 30 d9
Sound_8186:
			txa				; $8186: 8a
			sbc #$04				; $8187: e9 04
			tax				; $8189: aa
			dey				; $818a: 88
			bpl Sound_8122			; $818b: 10 95
			rts				; $818d: 60

;-------------------------------------------------------------------------------
Sound_818e:
			lda $035b,x		; $818e: bd 5b 03
			cmp #$40				; $8191: c9 40
			bcc Sound_81dd			; $8193: 90 48
			and #$3f				; $8195: 29 3f
			sta $d2			; $8197: 85 d2
			bit $d6			; $8199: 24 d6
			bpl Sound_81aa			; $819b: 10 0d
			lda $03a1,x		; $819d: bd a1 03
			beq +			; $81a0: f0 04
			clc				; $81a2: 18
			adc $0338,x		; $81a3: 7d 38 03
+			sta $03d9,x		; $81a6: 9d d9 03
Sound_81a9:
			rts				; $81a9: 60

;-------------------------------------------------------------------------------
Sound_81aa:
			lda $0369,x		; $81aa: bd 69 03
			and #$40				; $81ad: 29 40
			cmp #$40				; $81af: c9 40
			lda $03d9,x		; $81b1: bd d9 03
			beq Sound_81a9			; $81b4: f0 f3
			bcs Sound_81be			; $81b6: b0 06
			sec				; $81b8: 38
			sbc $d2			; $81b9: e5 d2
			jmp Sound_81c1			; $81bb: 4c c1 81

;-------------------------------------------------------------------------------
Sound_81be:
			clc				; $81be: 18
			adc $d2			; $81bf: 65 d2
Sound_81c1:
			beq Sound_81d3			; $81c1: f0 10
			cmp #$0d				; $81c3: c9 0d
			bcc Sound_81d1			; $81c5: 90 0a
			cmp #$79				; $81c7: c9 79
			bcs Sound_81d1			; $81c9: b0 06
			sta $03d9,x		; $81cb: 9d d9 03
			jmp Sound_854f			; $81ce: 4c 4f 85

;-------------------------------------------------------------------------------
Sound_81d1:
			lda #$00				; $81d1: a9 00
Sound_81d3:
			sta $03d9,x		; $81d3: 9d d9 03
			sta $03b6,x		; $81d6: 9d b6 03
			sta $03bd,x		; $81d9: 9d bd 03
			rts				; $81dc: 60

;-------------------------------------------------------------------------------
Sound_81dd:
			tay				; $81dd: a8
			lda $03b6,x		; $81de: bd b6 03
			sta $d2			; $81e1: 85 d2
			lda $03bd,x		; $81e3: bd bd 03

-			lsr				; $81e6: 4a
			ror $d2			; $81e7: 66 d2
			dey				; $81e9: 88
			bne -			; $81ea: d0 fa

			sta $d3			; $81ec: 85 d3
			lda $0369,x		; $81ee: bd 69 03
			and #$40				; $81f1: 29 40
			bne Sound_820b			; $81f3: d0 16
			lda $03b6,x		; $81f5: bd b6 03
			clc				; $81f8: 18
			adc $d2			; $81f9: 65 d2
			sta $03b6,x		; $81fb: 9d b6 03
			lda $03bd,x		; $81fe: bd bd 03
			adc $d3			; $8201: 65 d3
			sta $03bd,x		; $8203: 9d bd 03
			cmp #$08				; $8206: c9 08
			bcs Sound_821f			; $8208: b0 15
			rts				; $820a: 60

;-------------------------------------------------------------------------------
Sound_820b:
			lda $03b6,x		; $820b: bd b6 03
			sec				; $820e: 38
			sbc $d2			; $820f: e5 d2
			sta $03b6,x		; $8211: 9d b6 03
			lda $03bd,x		; $8214: bd bd 03
			sbc $d3			; $8217: e5 d3
			sta $03bd,x		; $8219: 9d bd 03
			bcc Sound_821f			; $821c: 90 01
			rts				; $821e: 60

;-------------------------------------------------------------------------------
Sound_821f:
			lda #$00				; $821f: a9 00
			sta $03b6,x		; $8221: 9d b6 03
			sta $03bd,x		; $8224: 9d bd 03
			rts				; $8227: 60

;-------------------------------------------------------------------------------
Sound_8228:
			lda $034d,x		; $8228: bd 4d 03
			sta $d0			; $822b: 85 d0
			lda $0354,x		; $822d: bd 54 03
			sta $d1			; $8230: 85 d1
			ldy #$ff				; $8232: a0 ff
Sound_ReadTrack:
			iny				; $8234: c8
			ldx $030b			; $8235: ae 0b 03
			lda ($d0),y		; Load data from the track
			bmi Sound_ReadCommands	; If it's a command, branch
			jmp Sound_8486			; $823c: 4c 86 84

;-------------------------------------------------------------------------------
Sound_ReadCommands:
			cmp #$b0				; $823f: c9 b0
			bcc Sound_ReadCommand			; $8241: 90 03
			jmp Sound_8423			; $8243: 4c 23 84

;-------------------------------------------------------------------------------
Sound_ReadCommand:
			asl				; $8246: 0a
			tax				; $8247: aa

			; Push Sound_8234 to the stack
			lda #>(Sound_ReadTrack-1)				; $8248: a9 82
			pha				; $824a: 48
			lda #<(Sound_ReadTrack-1)				; $824b: a9 33
			pha				; $824d: 48
			; Push command to the stack
			lda Sound_CmdTable+1,x			; $824e: bd 5e 82
			pha				; $8251: 48
			lda Sound_CmdTable,x			; $8252: bd 5d 82
			pha				; $8255: 48
			; Load next value from the track
			ldx $030b			; $8256: ae 0b 03
			iny				; $8259: c8
			lda ($d0),y		; $825a: b1 d0
			rts		; rts jumps to the command,
					; the command then returns to Sound_8234

;-------------------------------------------------------------------------------
			TableStart
			TableInsert Sound_CmdJump	; $80
			TableInsert Sound_CmdLoop	; $81
			TableInsert Sound_CmdStop
			TableInsert Sound_82d7
			TableInsert Sound_8321
			TableInsert Sound_82d0
			TableInsert Sound_82c5
			TableInsert Sound_830b
			TableInsert Sound_CmdSetVoice
			TableInsert Sound_82df
			TableInsert Sound_82ed ; $8A
			TableInsert Sound_PlaySound
			TableInsert Sound_8415
			TableInsert Sound_Cmd8D
			TableInsert Sound_83bd
			TableInsert Sound_83c1
			TableInsert Sound_82e9
			TableInsert Sound_8340
			TableInsert Sound_83a0
			TableInsert Sound_8347
			TableInsert Sound_83e6
			TableInsert Sound_8374
			TableInsert Sound_83b9
			TableInsert Sound_841f
			TableInsert Sound_8417
			TableInsert Sound_840d
			TableInsert Sound_8423
			TableInsert Sound_8423
			TableInsert Sound_838b
			TableInsert Sound_841b
			TableInsert Sound_8382
			TableInsert Sound_841f
			TableInsert Sound_8318

Sound_CmdTable:	.addr CurrentTable-1

;-------------------------------------------------------------------------------
Sound_CmdJump:
			tax				; $829f: aa
			iny				; $82a0: c8
			lda ($d0),y		; $82a1: b1 d0
			sta $d1			; $82a3: 85 d1
			stx $d0			; $82a5: 86 d0
			ldy #$ff				; $82a7: a0 ff
			rts				; $82a9: 60

;-------------------------------------------------------------------------------
Sound_CmdLoop:
			clc				; $82aa: 18
			adc $030b			; $82ab: 6d 0b 03
			tax				; $82ae: aa
			iny				; $82af: c8
			lda ($d0),y		; $82b0: b1 d0
			dec $031c,x		; $82b2: de 1c 03
			bne Sound_CmdJump			; $82b5: d0 e8
			iny				; $82b7: c8
			rts				; $82b8: 60

;-------------------------------------------------------------------------------
Sound_Cmd8D:
			clc				; $82b9: 18
			adc $030b			; $82ba: 6d 0b 03
			tax				; $82bd: aa
			iny				; $82be: c8
			lda ($d0),y		; $82bf: b1 d0
			sta $031c,x		; $82c1: 9d 1c 03
			rts				; $82c4: 60

;-------------------------------------------------------------------------------
Sound_82c5:
			lda $03a8,x		; $82c5: bd a8 03
			sta $0300			; $82c8: 8d 00 03
Sound_CmdStop:
			lda #$00				; $82cb: a9 00
			sta $031c,x		; $82cd: 9d 1c 03
Sound_82d0:
			pla				; $82d0: 68
			pla				; $82d1: 68
			pla				; $82d2: 68
			pla				; $82d3: 68
			jmp Sound_8103			; $82d4: 4c 03 81

;-------------------------------------------------------------------------------
Sound_82d7:
			sta $0331,x		; $82d7: 9d 31 03
			rts				; $82da: 60

;-------------------------------------------------------------------------------
Sound_CmdSetVoice:
			sta $032a,x		; $82db: 9d 2a 03
			rts				; $82de: 60

;-------------------------------------------------------------------------------
Sound_82df:
			beq +			; $82df: f0 04
			clc				; $82e1: 18
			adc $0338,x		; $82e2: 7d 38 03

+			sta $0338,x		; $82e5: 9d 38 03
			rts				; $82e8: 60

;-------------------------------------------------------------------------------
Sound_82e9:
			sta $031c,x		; $82e9: 9d 1c 03
			rts				; $82ec: 60

;-------------------------------------------------------------------------------
Sound_82ed:
			sta $d3			; $82ed: 85 d3
			lda $0323,x		; $82ef: bd 23 03
			and #$0f				; $82f2: 29 0f
			sta $d2			; $82f4: 85 d2
			clc				; $82f6: 18
			lda $d3			; $82f7: a5 d3
			bpl +			; $82f9: 10 08
			adc $d2			; $82fb: 65 d2
			bcs Sound_830b			; $82fd: b0 0c
			lda #$00				; $82ff: a9 00
			beq Sound_830b			; $8301: f0 08

+			adc $d2			; $8303: 65 d2
			cmp #$10				; $8305: c9 10
			bcc Sound_830b			; $8307: 90 02
			lda #$0f				; $8309: a9 0f
Sound_830b:
			sta $d2			; $830b: 85 d2
			lda $0323,x		; $830d: bd 23 03
			and #$f0				; $8310: 29 f0
Sound_8312:
			ora $d2			; $8312: 05 d2
			sta $0323,x		; $8314: 9d 23 03
			rts				; $8317: 60

;-------------------------------------------------------------------------------
Sound_8318:
			sta $d2			; $8318: 85 d2
			lda $0323,x		; $831a: bd 23 03
			and #$0f				; $831d: 29 0f
			bpl Sound_8312			; $831f: 10 f1
Sound_8321:
			beq Sound_8337			; $8321: f0 14
			sta $035b,x		; $8323: 9d 5b 03
			lda #$ff				; $8326: a9 ff
			sta $03b6,x		; $8328: 9d b6 03
			sta $03bd,x		; $832b: 9d bd 03
			lda $0370,x		; $832e: bd 70 03
			ora #$01				; $8331: 09 01
			sta $0370,x		; $8333: 9d 70 03
			rts				; $8336: 60

;-------------------------------------------------------------------------------
Sound_8337:
			lda $0370,x		; $8337: bd 70 03
			and #$fe				; $833a: 29 fe
			sta $0370,x		; $833c: 9d 70 03
			rts				; $833f: 60

;-------------------------------------------------------------------------------
Sound_8340:
			ora $0300			; $8340: 0d 00 03
			sta $0300			; $8343: 8d 00 03
			rts				; $8346: 60

;-------------------------------------------------------------------------------
Sound_8347:
			sta $d2			; $8347: 85 d2
			and #$3f				; $8349: 29 3f
			sta $03d2,x		; $834b: 9d d2 03
			lda $0369,x		; $834e: bd 69 03
			and #$cd				; $8351: 29 cd
			ora #$20				; $8353: 09 20
			bit $d2			; $8355: 24 d2
			bpl +			; $8357: 10 02
			ora #$10				; $8359: 09 10

+			sta $0369,x		; $835b: 9d 69 03
			lda #$00				; $835e: a9 00
			sta $03cb,x		; $8360: 9d cb 03
			iny				; $8363: c8
			lda ($d0),y		; $8364: b1 d0
			sta $03c4,x		; $8366: 9d c4 03
			bne +			; $8369: d0 08
			lda $0369,x		; $836b: bd 69 03
			and #$df				; $836e: 29 df
			sta $0369,x		; $8370: 9d 69 03

+			rts				; $8373: 60

;-------------------------------------------------------------------------------
Sound_8374:
			lda $0369,x		; $8374: bd 69 03
			and #$02				; $8377: 29 02
			bne Sound_8380			; $8379: d0 05
Sound_837b:
			lda ($d0),y		; $837b: b1 d0
			jmp Sound_CmdJump			; $837d: 4c 9f 82

;-------------------------------------------------------------------------------
Sound_8380:
			iny				; $8380: c8
			rts				; $8381: 60

;-------------------------------------------------------------------------------
Sound_8382:
			lda $0370,x		; $8382: bd 70 03
			and #$04				; $8385: 29 04
			bne Sound_837b			; $8387: d0 f2
			iny				; $8389: c8
			rts				; $838a: 60

;-------------------------------------------------------------------------------
Sound_838b:
			sbc $038c,x		; $838b: fd 8c 03
			pha				; $838e: 48
			iny				; $838f: c8
			lda ($d0),y		; $8390: b1 d0
			sta $d2			; $8392: 85 d2
			iny				; $8394: c8
			lda ($d0),y		; $8395: b1 d0
			sta $d3			; $8397: 85 d3
			sty $d7			; $8399: 84 d7
			pla				; $839b: 68
			tay				; $839c: a8
			jmp Sound_83ad			; $839d: 4c ad 83

;-------------------------------------------------------------------------------
Sound_83a0:
			sta $d2			; $83a0: 85 d2
			iny				; $83a2: c8
			lda ($d0),y		; $83a3: b1 d0
			sta $d3			; $83a5: 85 d3
			sty $d7			; $83a7: 84 d7
			ldy $038c,x		; $83a9: bc 8c 03
			dey				; $83ac: 88
Sound_83ad:
			lda ($d2),y		; $83ad: b1 d2
			ldy $d7			; $83af: a4 d7
			clc				; $83b1: 18
			adc $0338,x		; $83b2: 7d 38 03
			sta $0338,x		; $83b5: 9d 38 03
			rts				; $83b8: 60

;-------------------------------------------------------------------------------
Sound_83b9:
			sta $033f,x		; $83b9: 9d 3f 03
			rts				; $83bc: 60

;-------------------------------------------------------------------------------
Sound_83bd:
			sta $03e0,x		; $83bd: 9d e0 03
			rts				; $83c0: 60

;-------------------------------------------------------------------------------
Sound_83c1:
			sta $d2			; $83c1: 85 d2
			asl				; $83c3: 0a
			beq Sound_83dc			; $83c4: f0 16
			lda $03e7,x		; $83c6: bd e7 03
			php				; $83c9: 08
			clc				; $83ca: 18
			adc $d2			; $83cb: 65 d2
			and #$0f				; $83cd: 29 0f
			plp				; $83cf: 28
			bpl +			; $83d0: 10 02
			ora #$80				; $83d2: 09 80
+			bcc +			; $83d4: 90 02
			eor #$80				; $83d6: 49 80
+			sta $03e7,x		; $83d8: 9d e7 03
			rts				; $83db: 60

;-------------------------------------------------------------------------------
Sound_83dc:
			lsr				; $83dc: 4a
			beq +			; $83dd: f0 03
			eor $03e7,x		; $83df: 5d e7 03
+			sta $03e7,x		; $83e2: 9d e7 03
			rts				; $83e5: 60

;-------------------------------------------------------------------------------
Sound_83e6:
			bmi +			; $83e6: 30 0e
			beq Sound_8404			; $83e8: f0 1a
			sta $035b,x		; $83ea: 9d 5b 03
			lda $0369,x		; $83ed: bd 69 03
			and #$bf				; $83f0: 29 bf
			ora #$80				; $83f2: 09 80
			bmi ++			; $83f4: 30 0a

+			and #$7f				; $83f6: 29 7f
			sta $035b,x		; $83f8: 9d 5b 03
			lda $0369,x		; $83fb: bd 69 03
			ora #$c0				; $83fe: 09 c0

+			sta $0369,x		; $8400: 9d 69 03
			rts				; $8403: 60

;-------------------------------------------------------------------------------
Sound_8404:
			lda $0369,x		; $8404: bd 69 03
			and #$7f				; $8407: 29 7f
			sta $0369,x		; $8409: 9d 69 03
			rts				; $840c: 60

;-------------------------------------------------------------------------------
Sound_840d:
			lda $031c,x		; $840d: bd 1c 03
			eor #$10				; $8410: 49 10
			sta $031c,x		; $8412: 9d 1c 03
Sound_8415:
			dey				; $8415: 88
			rts				; $8416: 60

;-------------------------------------------------------------------------------
Sound_8417:
			sta $0346,x		; $8417: 9d 46 03
			rts				; $841a: 60

;-------------------------------------------------------------------------------
Sound_841b:
			sta $03af,x		; $841b: 9d af 03
			rts				; $841e: 60

;-------------------------------------------------------------------------------
Sound_841f:
			sta $0362,x		; $841f: 9d 62 03
			rts				; $8422: 60

;-------------------------------------------------------------------------------
Sound_8423:
			cmp #$e0				; $8423: c9 e0
			bcs Sound_847f			; $8425: b0 58
			sbc #$bf				; $8427: e9 bf
			bcc Sound_847f			; $8429: 90 54
			asl				; $842b: 0a
			asl				; $842c: 0a
			sty $d7			; $842d: 84 d7
			tay				; $842f: a8
			lda Sound_8917,y			; $8430: b9 17 89
			sta $032a,x		; $8433: 9d 2a 03
			lda Sound_8919,y			; $8436: b9 19 89
			and #$1f				; $8439: 29 1f
			cmp #$10				; $843b: c9 10
			bcc +			; $843d: 90 02
			adc #$6f				; $843f: 69 6f

+			sta $03e7,x		; $8441: 9d e7 03
			lda Sound_8919,y			; $8444: b9 19 89
			php				; $8447: 08
			and #$60				; $8448: 29 60
			rol				; $844a: 2a
			rol				; $844b: 2a
			rol				; $844c: 2a
			rol				; $844d: 2a
			sta $d2			; $844e: 85 d2
			lda $031c,x		; $8450: bd 1c 03
			and #$fc				; $8453: 29 fc
			ora $d2			; $8455: 05 d2
			sta $031c,x		; $8457: 9d 1c 03
			lda Sound_8918,y			; $845a: b9 18 89
			plp				; $845d: 28
			bmi Sound_846d			; $845e: 30 0d
			pha				; $8460: 48
			lda $0369,x		; $8461: bd 69 03
			and #$7f				; $8464: 29 7f
			sta $0369,x		; $8466: 9d 69 03
			pla				; $8469: 68
			jmp Sound_8474			; $846a: 4c 74 84

;-------------------------------------------------------------------------------
Sound_846d:
			and #$ff				; $846d: 29 ff
			jsr Sound_83e6			; $846f: 20 e6 83
			lda #$00				; $8472: a9 00
Sound_8474:
			sta $0331,x		; $8474: 9d 31 03
			lda Sound_891a,y			; $8477: b9 1a 89
			ldy $d7			; $847a: a4 d7
			jmp Sound_8486			; $847c: 4c 86 84

;-------------------------------------------------------------------------------
Sound_847f:
			lda $03a1,x		; $847f: bd a1 03
			php				; $8482: 08
			jmp Sound_8492			; $8483: 4c 92 84

;-------------------------------------------------------------------------------
Sound_8486:
			iny				; $8486: c8
			sta $d2			; $8487: 85 d2
			lda $03a1,x		; $8489: bd a1 03
			php				; $848c: 08
			lda $d2			; $848d: a5 d2
			sta $03a1,x		; $848f: 9d a1 03
Sound_8492:
			jsr Sound_851c			; $8492: 20 1c 85
			lda ($d0),y		; $8495: b1 d0
			cmp #$e0				; $8497: c9 e0
			bcs Sound_84a1			; $8499: b0 06
			lda $039a,x		; $849b: bd 9a 03
			jmp Sound_84b5			; $849e: 4c b5 84

;-------------------------------------------------------------------------------
Sound_84a1:
			sec				; $84a1: 38
			sbc #$e0				; $84a2: e9 e0
			bne Sound_84ac			; $84a4: d0 06
			iny				; $84a6: c8
			lda ($d0),y		; $84a7: b1 d0
			jmp Sound_84b4			; $84a9: 4c b4 84

;-------------------------------------------------------------------------------
Sound_84ac:
			sty $d2			; $84ac: 84 d2
			tay				; $84ae: a8
			lda Sound_8909-1,y			; $84af: b9 08 89
			ldy $d2			; $84b2: a4 d2
Sound_84b4:
			iny				; $84b4: c8
Sound_84b5:
			sta $037e,x		; $84b5: 9d 7e 03
			sta $039a,x		; $84b8: 9d 9a 03
			lda #$00				; $84bb: a9 00
			sta $0377,x		; $84bd: 9d 77 03
			sta $03f5,x		; $84c0: 9d f5 03
			plp				; $84c3: 28
			beq +			; $84c4: f0 07
			lda $031c,x		; $84c6: bd 1c 03
			and #$10				; $84c9: 29 10
			bne Sound_84d8			; $84cb: d0 0b

+			sta $03ee,x		; $84cd: 9d ee 03
			lda $0369,x		; $84d0: bd 69 03
			ora #$04				; $84d3: 09 04
			sta $0369,x		; $84d5: 9d 69 03
Sound_84d8:
			lda $0370,x		; $84d8: bd 70 03
			and #$fd				; $84db: 29 fd
			sta $0370,x		; $84dd: 9d 70 03
			lda $d6			; $84e0: a5 d6
			ora #$80				; $84e2: 09 80
			sta $d6			; $84e4: 85 d6
			lda ($d0),y		; $84e6: b1 d0
			cmp #$c0				; $84e8: c9 c0
			bcs +			; $84ea: b0 21
			cmp #$b0				; $84ec: c9 b0
			bcc +			; $84ee: 90 1d
			iny				; $84f0: c8
			ldy $0338,x		; $84f1: bc 38 03
			sty $0316			; $84f4: 8c 16 03
			tax				; $84f7: aa
			tya				; $84f8: 98
			pha				; $84f9: 48
			lda Sound_8867,x			; $84fa: bd 67 88
			jsr Sound_LoadSoundAddress			; $84fd: 20 4f 87
			pla				; $8500: 68
			tay				; $8501: a8
			ldx $030b			; $8502: ae 0b 03
			lda $0370,x		; $8505: bd 70 03
			ora #$02				; $8508: 09 02
			sta $0370,x		; $850a: 9d 70 03

+			tya				; $850d: 98
			clc				; $850e: 18
			adc $d0			; $850f: 65 d0
			sta $034d,x		; $8511: 9d 4d 03
			lda $d1			; $8514: a5 d1
			adc #$00				; $8516: 69 00
			sta $0354,x		; $8518: 9d 54 03
			rts				; $851b: 60

;-------------------------------------------------------------------------------
Sound_851c:
			sta $03b6,x		; $851c: 9d b6 03
			and #$ff				; $851f: 29 ff
			bne Sound_8527			; $8521: d0 04
			sta $03bd,x		; $8523: 9d bd 03
			rts				; $8526: 60

;-------------------------------------------------------------------------------
Sound_8527:
			lda $031c,x		; $8527: bd 1c 03
			and #$08				; $852a: 29 08
			beq Sound_8546			; $852c: f0 18
			lda #$01				; $852e: a9 01
			sta $03bd,x		; $8530: 9d bd 03
			lda $03b6,x		; $8533: bd b6 03
			cmp #$11				; $8536: c9 11
			bcc +			; $8538: 90 02
			adc #$6f				; $853a: 69 6f

+			sbc $0338,x		; $853c: fd 38 03
			sta $03b6,x		; $853f: 9d b6 03
			sta $03e7,x		; $8542: 9d e7 03
			rts				; $8545: 60

;-------------------------------------------------------------------------------
Sound_8546:
			lda $03b6,x		; $8546: bd b6 03
			clc				; $8549: 18
			adc $0338,x		; $854a: 7d 38 03
			sty $d7			; $854d: 84 d7
Sound_854f:
			asl				; $854f: 0a
			tay				; $8550: a8
			clc				; $8551: 18
			lda $0362,x		; $8552: bd 62 03
			clc				; $8555: 18
			php				; $8556: 08
			adc Sound_880f-1,y			; $8557: 79 0e 88
			sta $03b6,x		; $855a: 9d b6 03
			lda Sound_880f,y			; $855d: b9 0f 88
			adc #$00				; $8560: 69 00
			plp				; $8562: 28
			bpl +			; $8563: 10 02
			sbc #$00				; $8565: e9 00

+			sta $03bd,x		; $8567: 9d bd 03
			ldy $d7			; $856a: a4 d7
			rts				; $856c: 60

;-------------------------------------------------------------------------------
Sound_LoadVoice:
			lda $032a,x		; $856d: bd 2a 03
			beq Sound_85a4			; $8570: f0 32
			asl				; $8572: 0a
			tay				; $8573: a8
			lda Sound_VoiceBank,y			; $8574: b9 6e 89
			sta $d2			; $8577: 85 d2
			lda Sound_VoiceBank+1,y			; $8579: b9 6f 89
			sta $d3			; $857c: 85 d3
			ldy $03ee,x		; $857e: bc ee 03
			jsr Sound_85ab			; $8581: 20 ab 85
			iny				; $8584: c8
			sta $d2			; $8585: 85 d2
			lda $0323,x		; $8587: bd 23 03
			and #$0f				; $858a: 29 0f
			clc				; $858c: 18
			adc $d2			; $858d: 65 d2
			sbc #$0e				; $858f: e9 0e
			sta $d5			; $8591: 85 d5
			tya				; $8593: 98
			sta $03ee,x		; $8594: 9d ee 03
			lda $0323,x		; $8597: bd 23 03
			and #$f0				; $859a: 29 f0
			bcc +			; $859c: 90 02
			ora $d5			; $859e: 05 d5

+			sta $0317			; $85a0: 8d 17 03
			rts				; $85a3: 60

;-------------------------------------------------------------------------------
Sound_85a4:
			lda $0323,x		; $85a4: bd 23 03
			sta $0317			; $85a7: 8d 17 03
			rts				; $85aa: 60

;-------------------------------------------------------------------------------
Sound_85ab:
			lda ($d2),y		; $85ab: b1 d2
			bmi Sound_85b0			; $85ad: 30 01
			rts				; $85af: 60

;-------------------------------------------------------------------------------
Sound_85b0:
			cmp #$80				; $85b0: c9 80
			bne Sound_85b8			; $85b2: d0 04
Sound_85b4:
			dey				; $85b4: 88
			lda ($d2),y		; $85b5: b1 d2
			rts				; $85b7: 60

;-------------------------------------------------------------------------------
Sound_85b8:
			cmp #$81				; $85b8: c9 81
			bne Sound_85c5			; $85ba: d0 09
Sound_85bc:
			tya				; $85bc: 98
			iny				; $85bd: c8
			sec				; $85be: 38
			sbc ($d2),y		; $85bf: f1 d2
			tay				; $85c1: a8
			lda ($d2),y		; $85c2: b1 d2
			rts				; $85c4: 60

;-------------------------------------------------------------------------------
Sound_85c5:
			cmp #$82				; $85c5: c9 82
			bne Sound_85ce			; $85c7: d0 05
			ldy #$00				; $85c9: a0 00
			lda ($d2),y		; $85cb: b1 d2
			rts				; $85cd: 60

;-------------------------------------------------------------------------------
Sound_85ce:
			cmp #$83				; $85ce: c9 83
			bne Sound_85dd			; $85d0: d0 0b
			lda $0369,x		; $85d2: bd 69 03
			and #$04				; $85d5: 29 04
			bne Sound_85b4			; $85d7: d0 db
			iny				; $85d9: c8
			lda ($d2),y		; $85da: b1 d2
Sound_85dc:
			rts				; $85dc: 60

;-------------------------------------------------------------------------------
Sound_85dd:
			cmp #$84				; $85dd: c9 84
			bne Sound_85dc			; $85df: d0 fb
			lda $0369,x		; $85e1: bd 69 03
			and #$04				; $85e4: 29 04
			bne Sound_85bc			; $85e6: d0 d4
			iny				; $85e8: c8
			iny				; $85e9: c8
			lda ($d2),y		; $85ea: b1 d2
			rts				; $85ec: 60

;-------------------------------------------------------------------------------
Sound_85ed:
			lda $03b6,x		; $85ed: bd b6 03
			ora $03bd,x		; $85f0: 1d bd 03
			beq Sound_8649			; $85f3: f0 54
			lda $0331,x		; $85f5: bd 31 03
			bmi Sound_8649			; $85f8: 30 4f
			and #$1f				; $85fa: 29 1f
			asl				; $85fc: 0a
			beq Sound_8649			; $85fd: f0 4a
			tay				; $85ff: a8
			lda Sound_891d,y			; $8600: b9 1d 89
			sta $d2			; $8603: 85 d2
			lda Sound_891d+1,y			; $8605: b9 1e 89
			sta $d3			; $8608: 85 d3
			ldy $03f5,x		; $860a: bc f5 03
			jsr Sound_85ab			; $860d: 20 ab 85
			iny				; $8610: c8
			sta $d5			; $8611: 85 d5
			tya				; $8613: 98
			sta $03f5,x		; $8614: 9d f5 03
			clc				; $8617: 18
			lda $d5			; $8618: a5 d5
			beq Sound_8649			; $861a: f0 2d
			bpl Sound_8627			; $861c: 10 09
			adc $03b6,x		; $861e: 7d b6 03
			bcs Sound_8638			; $8621: b0 15
			ldy #$00				; $8623: a0 00
			beq Sound_862e			; $8625: f0 07
Sound_8627:
			adc $03b6,x		; $8627: 7d b6 03
			bcc Sound_8638			; $862a: 90 0c
			ldy #$ff				; $862c: a0 ff
Sound_862e:
			pha				; $862e: 48
			lda $0331,x		; $862f: bd 31 03
			and #$40				; $8632: 29 40
			beq Sound_863c			; $8634: f0 06
			pla				; $8636: 68
			tya				; $8637: 98
Sound_8638:
			sta $03b6,x		; $8638: 9d b6 03
			rts				; $863b: 60

;-------------------------------------------------------------------------------
Sound_863c:
			pla				; $863c: 68
			sta $03b6,x		; $863d: 9d b6 03
			tya				; $8640: 98
			eor #$ff				; $8641: 49 ff
			adc $03bd,x		; $8643: 7d bd 03
			sta $03bd,x		; $8646: 9d bd 03
Sound_8649:
			rts				; $8649: 60

;-------------------------------------------------------------------------------
Sound_864a:
			lda $031c,x		; $864a: bd 1c 03
			and #$02				; $864d: 29 02
			beq +			; $864f: f0 13
			lda $03e0,x		; $8651: bd e0 03
			beq +			; $8654: f0 0e
			asl $03e7,x		; $8656: 1e e7 03
			php				; $8659: 08
			asl				; $865a: 0a
			clc				; $865b: 18
			adc $03e7,x		; $865c: 7d e7 03
			plp				; $865f: 28
			ror				; $8660: 6a
			sta $03e7,x		; $8661: 9d e7 03

+			rts				; $8664: 60

;-------------------------------------------------------------------------------
Sound_8665:
			ldy #$30				; $8665: a0 30
			sty $0302			; $8667: 8c 02 03
			sty $0306			; $866a: 8c 06 03
			sty $030a			; $866d: 8c 0a 03
			sty $030e			; $8670: 8c 0e 03
			ldy #$00				; $8673: a0 00
			sty $0303			; $8675: 8c 03 03
			sty $0307			; $8678: 8c 07 03
Sound_867b:
			rts				; $867b: 60

;-------------------------------------------------------------------------------
Sound_867c:
			lda $031c,x		; $867c: bd 1c 03
			and #$20				; $867f: 29 20
			beq +			; $8681: f0 03
			jsr Sound_8665			; $8683: 20 65 86

+			lda $0370,x		; $8686: bd 70 03
			and #$02				; $8689: 29 02
			bne Sound_867b			; $868b: d0 ee
			lda $0346,x		; $868d: bd 46 03
			asl				; $8690: 0a
			asl				; $8691: 0a
			tay				; $8692: a8
			lda $03b6,x		; $8693: bd b6 03
			ora $03bd,x		; $8696: 1d bd 03
			bne Sound_86a1			; $8699: d0 06
			lda #$30				; $869b: a9 30
			sta $0302,y		; $869d: 99 02 03
			rts				; $86a0: 60

;-------------------------------------------------------------------------------
Sound_86a1:
			lda $031c,x		; $86a1: bd 1c 03
			and #$0a				; $86a4: 29 0a
			beq Sound_86b8			; $86a6: f0 10
			cmp #$02				; $86a8: c9 02
			bne Sound_86c9			; $86aa: d0 1d
			lda $0317			; $86ac: ad 17 03
			sta $030e			; $86af: 8d 0e 03
			lda $03e7,x		; $86b2: bd e7 03
			sta $0310			; $86b5: 8d 10 03
Sound_86b8:
			lda $031c,x		; $86b8: bd 1c 03
			and #$01				; $86bb: 29 01
			beq Sound_86df			; $86bd: f0 20
			cpy #$08				; $86bf: c0 08
			bcs Sound_86c9			; $86c1: b0 06
			lda $0331,x		; $86c3: bd 31 03
			sta $0303,y		; $86c6: 99 03 03
Sound_86c9:
			lda $0317			; $86c9: ad 17 03
			sta $0302,y		; $86cc: 99 02 03
			lda $03b6,x		; $86cf: bd b6 03
			sta $0304,y		; $86d2: 99 04 03
			lda $d6			; $86d5: a5 d6
			and #$80				; $86d7: 29 80
			ora $03bd,x		; $86d9: 1d bd 03
			sta $0305,y		; $86dc: 99 05 03
Sound_86df:
			rts				; $86df: 60

;-------------------------------------------------------------------------------
			.byte $01, $02 ; $86e0
			.byte $04, $08 ; $86e2
			.byte $fe, $fd, $fb ; $86e4
			.byte $f7 ; $86e7

Sound_SetupAPU2:
			lda #$00				; $86e8: a9 00
			sta $d6			; $86ea: 85 d6
			sta $030f			; $86ec: 8d 0f 03

Sound_SetupAPU:
			txa				; $86ef: 8a
			pha				; $86f0: 48
			ldx #$07				; $86f1: a2 07

-			lda #$00				; $86f3: a9 00
			sta $031b,x		; $86f5: 9d 1b 03
			dex				; $86f8: ca
			bne -			; $86f9: d0 f8
			pla				; $86fb: 68
			tax				; $86fc: aa
			lda $d6			; $86fd: a5 d6
			and #$df				; $86ff: 29 df
			sta $d6			; $8701: 85 d6
			lda #$0f				; $8703: a9 0f
			sta $031a			; $8705: 8d 1a 03

			; Enable loop envelope and
			; disable length counter
			lda #$30
			sta $4000	; for pulse 1 channel
			sta $4004	; for pulse 2 channel
			sta $400c	; and for noise

			lda #$80	; linear counter control
			sta $4008	; for triangle channel
			sta $0312
			sta $0313

			; Disable sweep unit for pulse 1 and 2
			lda #$00
			sta $4001
			sta $4005
			sta $0314
			sta $0315
			rts

;-------------------------------------------------------------------------------
; Sound_872d:
Sound_PlaySound:
			inc $030f			; $872d: ee 0f 03
			sta $d2			; $8730: 85 d2

			txa				; $8732: 8a
			pha		; Push X register to the stack
			tya				; $8734: 98
			pha		; Push Y register to the stack

			lda $d2			; $8736: a5 d2
			jsr Sound_SetupPitchVolume			; $8738: 20 45 87
			lda #$00				; $873b: a9 00
			sta $030f			; $873d: 8d 0f 03

			pla		; Pull Y register from the stack
			tay				; $8741: a8
			pla		; Pull X register from the stack
			tax				; $8743: aa
			rts				; $8744: 60

;-------------------------------------------------------------------------------
Sound_SetupPitchVolume:
			ldx #$00				; $8745: a2 00
			stx $0316			; $8747: 8e 16 03
			ldx #$0f		; Set volume?
			stx $0317			; $874c: 8e 17 03
; Sound_874f:
Sound_LoadSoundAddress:
			sta $d4			; $874f: 85 d4
			asl				; $8751: 0a
			tax				; $8752: aa
			lda Sound_SoundTable,x			; $8753: bd 87 8b
			sta $d2			; $8756: 85 d2
			lda Sound_SoundTable+1,x			; $8758: bd 88 8b
			sta $d3			; $875b: 85 d3
			ldy #$00				; $875d: a0 00
			lda ($d2),y		; $875f: b1 d2
			bne Sound_8793			; $8761: d0 30
			lda $d3			; $8763: a5 d3
			pha				; $8765: 48
			lda $d2			; $8766: a5 d2
			pha				; $8768: 48
Sound_8769:
			rts				; $8769: 60

;-------------------------------------------------------------------------------
Sound_876a:
			sta $031c,x		; $876a: 9d 1c 03
			iny				; $876d: c8
			jmp Sound_8820			; $876e: 4c 20 88

;-------------------------------------------------------------------------------
			ldy #$04				; $8771: a0 04
			lda ($d2),y		; $8773: b1 d2
			tax				; $8775: aa
			lda $0393,x		; $8776: bd 93 03
			cmp #$ff				; $8779: c9 ff
			bne +			; $877b: d0 11
			lda $03a8,x		; $877d: bd a8 03
			cmp $d4			; $8780: c5 d4
			bne +			; $8782: d0 0a
			lda $031c,x		; $8784: bd 1c 03
			beq +			; $8787: f0 05
			lda #$01				; $8789: a9 01
			sta $031c,x		; $878b: 9d 1c 03
+			pla				; $878e: 68
			pla				; $878f: 68
			iny				; $8790: c8
			lda ($d2),y		; $8791: b1 d2
Sound_8793:
			iny				; $8793: c8
			sta $d5			; $8794: 85 d5
Sound_8796:
			lda ($d2),y		; Load the channel id
			iny				; Increase Y
			tax				; X = Channel ID + 1
			lda ($d2),y		; $879a: b1 d2
			beq Sound_876a			; $879c: f0 cc
			lda $031c,x		; $879e: bd 1c 03
			and #$40				; $87a1: 29 40
			bne Sound_8769			; $87a3: d0 c4
			sta $0377,x		; $87a5: 9d 77 03
			sta $03af,x		; $87a8: 9d af 03
			sta $0362,x		; $87ab: 9d 62 03
			sta $03a1,x		; $87ae: 9d a1 03
			sta $03e0,x		; $87b1: 9d e0 03
			sta $03e7,x		; $87b4: 9d e7 03
			sta $0369,x		; $87b7: 9d 69 03
			sta $0370,x		; $87ba: 9d 70 03
			lda $d4			; $87bd: a5 d4
			cmp $03a8,x		; $87bf: dd a8 03
			bne Sound_87d0			; $87c2: d0 0c
			lda $031c,x		; $87c4: bd 1c 03
			beq Sound_87d3			; $87c7: f0 0a
			lda #$04				; $87c9: a9 04
			sta $0370,x		; $87cb: 9d 70 03
			bne Sound_87d3			; $87ce: d0 03
Sound_87d0:
			sta $03a8,x		; $87d0: 9d a8 03
Sound_87d3:
			txa				; A = Channel ID + 1
			pha				; $87d4: 48
			lda #$09		; Load the rest of the channel header data
			sta $d4			; $87d7: 85 d4

-			lda ($d2),y		; $87d9: b1 d2
			iny				; $87db: c8
			sta $031c,x		; $87dc: 9d 1c 03
			txa				; A = Channel ID + 1
			clc				; $87e0: 18
			adc #$07		; A = Channel ID + 8
			tax				; X = A
			dec $d4			; $87e4: c6 d4
			bne -			; $87e6: d0 f1

			pla				; $87e8: 68
			tax				; $87e9: aa
			lda $0323,x		; $87ea: bd 23 03
			and #$0f				; $87ed: 29 0f
			clc				; $87ef: 18
			adc $0317			; $87f0: 6d 17 03
			sbc #$0e				; $87f3: e9 0e
			bcs +			; $87f5: b0 02
			lda #$00				; $87f7: a9 00

+			sta $d7			; $87f9: 85 d7
			lda $0323,x		; $87fb: bd 23 03
			and #$f0				; $87fe: 29 f0
			ora $d7			; $8800: 05 d7
			sta $0323,x		; $8802: 9d 23 03
			lda $0316			; $8805: ad 16 03
			clc				; $8808: 18
			adc $0338,x		; $8809: 7d 38 03
			sta $0338,x
Sound_880f:
			lda $03a8,x		; $880f: bd a8 03
			sta $d4			; $8812: 85 d4
			lda #$01				; $8814: a9 01
			sta $037e,x		; $8816: 9d 7e 03
			clc				; $8819: 18
			sbc $033f,x		; $881a: fd 3f 03
			sta $0385,x		; $881d: 9d 85 03
Sound_8820:
			dec $d5			; $8820: c6 d5
			beq Sound_8827			; $8822: f0 03
			jmp Sound_8796			; $8824: 4c 96 87

;-------------------------------------------------------------------------------
Sound_8827:
			rts				; $8827: 60

;-------------------------------------------------------------------------------
			.byte $fe, $07, $8e, $07	; $8828: fe 07 8e 07	 Data
			.byte $20, $07, $ba, $06	; $882c: 20 07 ba 06	 Data
			.byte $5a, $06, $fe, $05	; $8830: 5a 06 fe 05	 Data
			.byte $a8, $05, $56, $05	; $8834: a8 05 56 05	 Data
			.byte $0a, $05, $c2, $04	; $8838: 0a 05 c2 04	 Data
			.byte $7e, $04, $3c, $04	; $883c: 7e 04 3c 04	 Data
			.byte $ff, $03, $c7, $03	; $8840: ff 03 c7 03	 Data
			.byte $90, $03, $5d, $03	; $8844: 90 03 5d 03	 Data
			.byte $2d, $03, $ff, $02	; $8848: 2d 03 ff 02	 Data
			.byte $d4, $02, $ab, $02	; $884c: d4 02 ab 02	 Data
			.byte $85, $02, $61, $02	; $8850: 85 02 61 02	 Data
			.byte $3f, $02, $1e, $02	; $8854: 3f 02 1e 02	 Data
			.byte $ff, $01, $e3, $01	; $8858: ff 01 e3 01	 Data
			.byte $c8, $01, $ae, $01	; $885c: c8 01 ae 01	 Data
			.byte $96, $01, $7f, $01	; $8860: 96 01 7f 01	 Data
			.byte $6a, $01, $55	; $8864: 6a 01 55		Data
Sound_8867:
			.byte $01, $42, $01, $30	; $8867: 01 42 01 30	 Data
			.byte $01, $1f, $01, $0f	; $886b: 01 1f 01 0f	 Data
			.byte $01, $ff, $00, $f1	; $886f: 01 ff 00 f1	 Data
			.byte $00, $e4, $00, $d7	; $8873: 00 e4 00 d7	 Data
			.byte $00, $cb, $00, $bf	; $8877: 00 cb 00 bf	 Data
			.byte $00, $b5, $00, $aa	; $887b: 00 b5 00 aa	 Data
			.byte $00, $a1, $00, $98	; $887f: 00 a1 00 98	 Data
			.byte $00, $8f, $00, $87	; $8883: 00 8f 00 87	 Data
			.byte $00, $7f, $00, $78	; $8887: 00 7f 00 78	 Data
			.byte $00, $72, $00, $6b	; $888b: 00 72 00 6b	 Data
			.byte $00, $65, $00, $5f	; $888f: 00 65 00 5f	 Data
			.byte $00, $5a, $00, $55	; $8893: 00 5a 00 55	 Data
			.byte $00, $50, $00, $4c	; $8897: 00 50 00 4c	 Data
			.byte $00, $47, $00, $43	; $889b: 00 47 00 43	 Data
			.byte $00, $3f, $00, $3c	; $889f: 00 3f 00 3c	 Data
			.byte $00, $39, $00, $35	; $88a3: 00 39 00 35	 Data
			.byte $00, $32, $00, $2f	; $88a7: 00 32 00 2f	 Data
			.byte $00, $2d, $00, $2a	; $88ab: 00 2d 00 2a	 Data
			.byte $00, $28, $00, $26	; $88af: 00 28 00 26	 Data
			.byte $00, $23, $00, $21	; $88b3: 00 23 00 21	 Data
			.byte $00, $1f, $00, $1e	; $88b7: 00 1f 00 1e	 Data
			.byte $00, $1c, $00, $1a	; $88bb: 00 1c 00 1a	 Data
			.byte $00, $19, $00, $17	; $88bf: 00 19 00 17	 Data
			.byte $00, $16, $00, $15	; $88c3: 00 16 00 15	 Data
			.byte $00, $14, $00, $13	; $88c7: 00 14 00 13	 Data
			.byte $00, $11, $00, $10	; $88cb: 00 11 00 10	 Data
			.byte $00, $0f, $00, $0f	; $88cf: 00 0f 00 0f	 Data
			.byte $00, $0e, $00, $0d	; $88d3: 00 0e 00 0d	 Data
			.byte $00, $0c, $00, $0b	; $88d7: 00 0c 00 0b	 Data
			.byte $00, $0b, $00, $0a	; $88db: 00 0b 00 0a	 Data
			.byte $00, $0a, $00, $09	; $88df: 00 0a 00 09	 Data
			.byte $00, $08, $00, $08	; $88e3: 00 08 00 08	 Data
			.byte $00, $07, $00, $07	; $88e7: 00 07 00 07	 Data
			.byte $00, $07, $00, $06	; $88eb: 00 07 00 06	 Data
			.byte $00, $06, $00, $05	; $88ef: 00 06 00 05	 Data
			.byte $00, $05, $00, $05	; $88f3: 00 05 00 05	 Data
			.byte $00, $05, $00, $04	; $88f7: 00 05 00 04	 Data
			.byte $00, $04, $00, $04	; $88fb: 00 04 00 04	 Data
			.byte $00	; $88ff: 00			Data

;-------------------------------------------------------------------------------
Sound_8900:
			lda #$03				; $8900: a9 03
Sound_8902:
			sta $d6			; $8902: 85 d6
			rts				; $8904: 60

;-------------------------------------------------------------------------------
Sound_8905:
			lda #$01				; $8905: a9 01
			bne Sound_8902
Sound_8909:
			.byte $01, $02

;-------------------------------------------------------------------------------
			.byte $03, $04, $06, $08	; $890b: 03 04 06 08	 Data
			.byte $09, $0c, $10, $12	; $890f: 09 0c 10 12	 Data
			.byte $18, $20, $24, $30	; $8913: 18 20 24 30	 Data
Sound_8917:	.byte $03	; $8917: 03			Data
Sound_8918:	.byte $00	; $8918: 00			Data
Sound_8919:	.byte $49	; $8919: 49			Data
Sound_891a:	.byte $19, $0e, $00	; $891a: 19 0e 00		Data

Sound_891d:
			.addr $1947
			.addr Sound_8927
			.addr Sound_8930
			.addr Sound_8952
			.addr Sound_895f

Sound_8927:
			.byte $02, $01, $00	; $8926: 89 02 01 00	 Data
			.byte $ff, $fe, $ff, $00	; $892a: ff fe ff 00	 Data
			.byte $01, $82
Sound_8930:
			.byte $00, $00
			.byte $00, $00, $00, $00	; $8932: 00 00 00 00	 Data
			.byte $00, $00, $00, $00	; $8936: 00 00 00 00	 Data
			.byte $00, $00, $00, $00	; $893a: 00 00 00 00	 Data
			.byte $00, $00, $00, $00	; $893e: 00 00 00 00	 Data
			.byte $00, $00, $00, $00	; $8942: 00 00 00 00	 Data
			.byte $00, $00, $00, $01	; $8946: 00 00 00 01	 Data
			.byte $00, $00, $fe, $00	; $894a: 00 00 fe 00	 Data
			.byte $00, $01, $81, $08	; $894e: 00 01 81 08	 Data
Sound_8952:
			.byte $00, $00, $00, $01	; $8952: 00 00 00 01	 Data
			.byte $00, $00, $00, $00	; $8956: 00 00 00 00	 Data
			.byte $00, $ff, $00, $00	; $895a: 00 ff 00 00	 Data
			.byte $82
Sound_895f:
			.byte $0c, $f4, $00
			.byte $08, $fc, $0a, $f5	; $8962: 08 fc 0a f5	 Data
			.byte $00, $07, $f7, $0c	; $8966: 00 07 f7 0c	 Data
			.byte $fb, $00, $08, $f4	; $896a: fb 00 08 f4	 Data

;-------------------------------------------------------------------------------
;	Voice Bank
;	A voice is basically how volume of a note is changed when it's played
;	Voice 0 doesn't change the volume, it remains constant
;-------------------------------------------------------------------------------

Sound_VoiceBank:
			.addr $8200
			.addr Sound_Voice01
			.addr Sound_Voice02
			.addr Sound_Voice03
			.addr Sound_Voice04
			.addr Sound_Voice05
			.addr Sound_Voice06
			.addr Sound_Voice07
			.addr Sound_Voice08
			.addr Sound_Voice09
			.addr Sound_Voice0A
			.addr Sound_Voice0B
			.addr Sound_Voice0C
			.addr Sound_Voice0D
			.addr Sound_Voice0E
			.addr Sound_Voice0F
			.addr Sound_Voice10

Voice_End = $80

Sound_Voice01:
			.byte $00, $0f, $83	; $898f: 8b 00 0f 83	 Data
			.byte $0e, $0d, $0b, $0b	; $8993: 0e 0d 0b 0b	 Data
			.byte $0a, $0a, $09, $09	; $8997: 0a 0a 09 09	 Data
			.byte $09, $08, $08, $08	; $899b: 09 08 08 08	 Data
			.byte $08, $07, $07, $07	; $899f: 08 07 07 07	 Data
			.byte $07, $06, $06, $06	; $89a3: 07 06 06 06	 Data
			.byte $06, $05, $04, $03	; $89a7: 06 05 04 03	 Data
			.byte $00, Voice_End

Sound_Voice02:
			.byte $0f, $0d	; $89ab: 00 80 0f 0d	 Data
			.byte $0b, $0a, $09, $08	; $89af: 0b 0a 09 08	 Data
			.byte $07, $06, $04, $00	; $89b3: 07 06 04 00	 Data
			.byte Voice_End

Sound_Voice03:
			.byte $0f, $0b, $09	; $89b7: 80 0f 0b 09	 Data
			.byte $08, $07, $06, $04	; $89bb: 08 07 06 04	 Data
			.byte $00, Voice_End

Sound_Voice04:
			.byte $0f, $0f	; $89bf: 00 80 0f 0f	 Data
			.byte $0e, $0d, $0c, $0b	; $89c3: 0e 0d 0c 0b	 Data
			.byte $0a, $0a, $0a, $09	; $89c7: 0a 0a 0a 09	 Data
			.byte $09, $09, $09, $09	; $89cb: 09 09 09 09	 Data
			.byte $09, $09, $09, $08	; $89cf: 09 09 09 08	 Data
			.byte $08, $08, $83, $07	; $89d3: 08 08 83 07	 Data
			.byte $07, $07, $06, $06	; $89d7: 07 07 06 06	 Data
			.byte $06, $06, $05, $05	; $89db: 06 06 05 05	 Data
			.byte $05, $04, $04, $04	; $89df: 05 04 04 04	 Data
			.byte $03, $03, $03, $02	; $89e3: 03 03 03 02	 Data
			.byte $02, $00, Voice_End

Sound_Voice05:
			.byte $0b	; $89e7: 02 00 80 0b	 Data
			.byte $0d, $0f, $0f, $0e	; $89eb: 0d 0f 0f 0e	 Data
			.byte $0d, $0c, $0b, $0a	; $89ef: 0d 0c 0b 0a	 Data
			.byte $0a, $09, $09, $08	; $89f3: 0a 09 09 08	 Data
			.byte $07, Voice_End

Sound_Voice06:
			.byte $00, $0f	; $89f7: 07 80 00 0f	 Data
			.byte $83, $0d, $0d, $0d	; $89fb: 83 0d 0d 0d	 Data
			.byte $0d, $0d, $0c, $0c	; $89ff: 0d 0d 0c 0c	 Data
			.byte $0c, $0c, $0c, $0b	; $8a03: 0c 0c 0c 0b	 Data
			.byte $0b, $0b, $0b, $0a	; $8a07: 0b 0b 0b 0a	 Data
			.byte $09, $08, $07, $06	; $8a0b: 09 08 07 06	 Data
			.byte $05, $04, $03, $02	; $8a0f: 05 04 03 02	 Data
			.byte $01, $00, Voice_End

Sound_Voice07:
			.byte $06	; $8a13: 01 00 80 06	 Data
			.byte $0a, $0e, $0f, $0f	; $8a17: 0a 0e 0f 0f	 Data
			.byte $0f, $0f, $0f, $0f	; $8a1b: 0f 0f 0f 0f	 Data
			.byte $0f, $0f, $0f, $0f	; $8a1f: 0f 0f 0f 0f	 Data
			.byte $0f, $0f, $0f, $0f	; $8a23: 0f 0f 0f 0f	 Data
			.byte $0e, $0d, $0c, $0b	; $8a27: 0e 0d 0c 0b	 Data
			.byte $0b, $0b, $0a, $0a	; $8a2b: 0b 0b 0a 0a	 Data
			.byte $0a, $09, $09, $08	; $8a2f: 0a 09 09 08	 Data
			.byte Voice_End

Sound_Voice08:
			.byte $06, $09, $0b	; $8a33: 80 06 09 0b	 Data
			.byte $0c, $0e, $0f, $0f	; $8a37: 0c 0e 0f 0f	 Data
			.byte $0e, $0c, $0a, $09	; $8a3b: 0e 0c 0a 09	 Data
			.byte $08, Voice_End

Sound_Voice0B:
			.byte $00
			; Fall through to voice 09
Sound_Voice09:
			.byte $0f	; $8a3f: 08 80 00 0f	 Data
			.byte $0f, $0e, $0d, $0c	; $8a43: 0f 0e 0d 0c	 Data
			.byte $0b, $0a, $0a, $09	; $8a47: 0b 0a 0a 09	 Data
			.byte $09, $09, $09, $09	; $8a4b: 09 09 09 09	 Data
			.byte $09, $09, $09, $09	; $8a4f: 09 09 09 09	 Data
			.byte $09, $09, $09, $09	; $8a53: 09 09 09 09	 Data
			.byte $09, $09, $08, $08	; $8a57: 09 09 08 08	 Data
			.byte $08, $08, $07, $07	; $8a5b: 08 08 07 07	 Data
			.byte $07, $07, $06, $06	; $8a5f: 07 07 06 06	 Data
			.byte $06, $06, $06, $05	; $8a63: 06 06 06 05	 Data
			.byte $05, $05, $05, $05	; $8a67: 05 05 05 05	 Data
			.byte $04, $04, $04, $04	; $8a6b: 04 04 04 04	 Data
			.byte $03, $03, $03, $03	; $8a6f: 03 03 03 03	 Data
			.byte $03, $03, $02, $02	; $8a73: 03 03 02 02	 Data
			.byte $02, $02, $02, $01	; $8a77: 02 02 02 01	 Data
			.byte Voice_End

Sound_Voice0A:
			.byte $08, $0a, $0c	; $8a7b: 80 08 0a 0c	 Data
			.byte $0e, $0f, $0f, $0e	; $8a7f: 0e 0f 0f 0e	 Data
			.byte $0d, $0c, $0b, $0b	; $8a83: 0d 0c 0b 0b	 Data
			.byte $0a, Voice_End

Sound_Voice0C:
			.byte $00, $0f	; $8a87: 0a 80 00 0f	 Data
			.byte $0f, $0d, $0b, $0a	; $8a8b: 0f 0d 0b 0a	 Data
			.byte $0a, $09, $09, $09	; $8a8f: 0a 09 09 09	 Data
			.byte $09, $08, $08, $07	; $8a93: 09 08 08 07	 Data
			.byte $07, $06, $06, $06	; $8a97: 07 06 06 06	 Data
			.byte $05, $05, $04, $03	; $8a9b: 05 05 04 03	 Data
			.byte $02, $00, Voice_End

Sound_Voice0D:
			.byte $0f	; $8a9f: 02 00 80 0f	 Data
			.byte $0f, $0f, $0e, $0e	; $8aa3: 0f 0f 0e 0e	 Data
			.byte $0d, $0d, $0c, $0c	; $8aa7: 0d 0d 0c 0c	 Data
			.byte $0c, $0c, $0c, $0c	; $8aab: 0c 0c 0c 0c	 Data
			.byte $0c, $0c, $0c, $83	; $8aaf: 0c 0c 0c 83	 Data
			.byte $0b, $0b, $0b, $0b	; $8ab3: 0b 0b 0b 0b	 Data
			.byte $0a, $0a, $09, $09	; $8ab7: 0a 0a 09 09	 Data
			.byte $09, $08, $08, $08	; $8abb: 09 08 08 08	 Data
			.byte $07, $07, $07, $06	; $8abf: 07 07 07 06	 Data
			.byte $06, $06, $05, $04	; $8ac3: 06 06 05 04	 Data
			.byte $03, $02, $01, $00	; $8ac7: 03 02 01 00	 Data
			.byte Voice_End

Sound_Voice0E:
			.byte $07, $07, $05	; $8acb: 80 07 07 05	 Data
			.byte $04, $00, Voice_End

Sound_Voice0F:
			.byte $0f	; $8acf: 04 00 80 0f	 Data
			.byte $0f, $0d, $0c, $0a	; $8ad3: 0f 0d 0c 0a	 Data
			.byte $08, $0d, $0e, $08	; $8ad7: 08 0d 0e 08	 Data
			.byte $08, $0a, $06, $0e	; $8adb: 08 0a 06 0e	 Data
			.byte $0f, $0b, $0f, $0e	; $8adf: 0f 0b 0f 0e	 Data
			.byte $0c, $0f, $08, $09	; $8ae3: 0c 0f 08 09	 Data
			.byte $0a, $0a, $0a, $0b	; $8ae7: 0a 0a 0a 0b	 Data
			.byte $0e, $0f, $0c, $0b	; $8aeb: 0e 0f 0c 0b	 Data
			.byte $0a, $09, $08, $0f	; $8aef: 0a 09 08 0f	 Data
			.byte $0e, $0e, $0e, $0d	; $8af3: 0e 0e 0e 0d	 Data
			.byte $0c, $0b, $08, $06	; $8af7: 0c 0b 08 06	 Data
			.byte $09, $07, $09, $07	; $8afb: 09 07 09 07	 Data
			.byte $09, $09, $07, $07	; $8aff: 09 09 07 07	 Data
			.byte $07, $09, $09, $09	; $8b03: 07 09 09 09	 Data
			.byte $09, $07, $07, $0f	; $8b07: 09 07 07 0f	 Data
			.byte $0a, $0e, $0b, $08	; $8b0b: 0a 0e 0b 08	 Data
			.byte $09, $08, $09, $08	; $8b0f: 09 08 09 08	 Data
			.byte $0a, $0d, $0b, $0a	; $8b13: 0a 0d 0b 0a	 Data
			.byte $0e, $06, $06, $08	; $8b17: 0e 06 06 08	 Data
			.byte $09, $08, $0a, $0a	; $8b1b: 09 08 0a 0a	 Data
			.byte $0f, $0f, $0e, $0e	; $8b1f: 0f 0f 0e 0e	 Data
			.byte $0f, $0b, $0a, $0a	; $8b23: 0f 0b 0a 0a	 Data
			.byte $08, $09, $03, $00	; $8b27: 08 09 03 00	 Data
			.byte Voice_End

Sound_Voice10:
			.byte $0f, $0e, $0c	; $8b2b: 80 0f 0e 0c	 Data
			.byte $0a, $08, $06, $05	; $8b2f: 0a 08 06 05	 Data
			.byte $0e, $0c, $0a, $08	; $8b33: 0e 0c 0a 08	 Data
			.byte $0a, $06, $05, $0f	; $8b37: 0a 06 05 0f	 Data
			.byte $0e, $0c, $0f, $0e	; $8b3b: 0e 0c 0f 0e	 Data
			.byte $0d, $0c, $0b, $08	; $8b3f: 0d 0c 0b 08	 Data
			.byte $06, $09, $07, $09	; $8b43: 06 09 07 09	 Data
			.byte $07, $0f, $0a, $0e	; $8b47: 07 0f 0a 0e	 Data
			.byte $08, $06, $09, $0f	; $8b4b: 08 06 09 0f	 Data
			.byte $0a, $00, Voice_End

;-------------------------------------------------------------------------------

; Supposedly an empty music track
Music_Empty:
			CSF_HeaderStart _HeaderEnd
			.byte $06, $01, $3f, $00
			.byte $00, $00, $7f, $00	; $8b57: 00 00 7f 00	 Data
			.addr +
_HeaderEnd

+			.byte $25, $e2
			.byte $27, $29, $2c, $31	; $8b5f: 27 29 2c 31	 Data
			CSF_Stop

;-------------------------------------------------------------------------------
Sound_Sub_MusicFadeOut:
			lda #$01				; $8b64: a9 01
			sta $030f			; $8b66: 8d 0f 03
			ldx #$03				; $8b69: a2 03

-			lda $0369,x		; $8b6b: bd 69 03
			ora #$30				; $8b6e: 09 30
			sta $0369,x		; $8b70: 9d 69 03
			lda #$ff				; $8b73: a9 ff
			sta $03c4,x		; $8b75: 9d c4 03
			lda #$00				; $8b78: a9 00
			sta $03cb,x		; $8b7a: 9d cb 03
			sta $03d2,x		; $8b7d: 9d d2 03
			dex				; $8b80: ca
			bpl -			; $8b81: 10 e8

			sta $030f			; $8b83: 8d 0f 03
			rts				; $8b86: 60

;-------------------------------------------------------------------------------
;	A table of sound/music addresses
;-------------------------------------------------------------------------------

;	TODO: make those as labels
					TableStart
					TableInsert Music_Empty
MusID_JapanTitle:	TableInsert Music_JapanTitle	; (unused in international ROM)
MusID_TheEarth:		TableInsert $8dfb
MusID_MainMenu:		TableInsert $916c
MusID_GameOver:		TableInsert $9202
MusID_Death:		TableInsert $932b
MusID_Unused1:		TableInsert $93eb	; (unused)
MusId_Unused2:		TableInsert $948a	; (unused)
MusID_InternTitle:	TableInsert $9510
MusID_PlanetX	=	MusID_InternTitle
MusID_Mars:			TableInsert $999d
MusID_Neptune:		TableInsert $9c16
MusID_Saturn:		TableInsert $9e2a
MusID_Jupiter:		TableInsert $a05a
MusID_Pluto:		TableInsert $a28f
MusID_Uranus:		TableInsert $a458
MusID_Moguera:		TableInsert $a62b
MusID_Baragon	=	MusID_Moguera
MusID_Hedorah:		TableInsert $a6ec
MusID_Gigan:		TableInsert $a906
MusID_MechaGodzilla:	TableInsert $ab76
MusID_Gezora:		TableInsert $acab
MusID_Ghidorah:		TableInsert $ae02
MusID_BossDefeat:	TableInsert $af44
MusID_Unused3:		TableInsert $b015	; (unused)
MusID_Credits:		TableInsert $b190
MusID_Unused4:		TableInsert $b3a7	; Gh1d0ra (unused)
MusID_PasswordGame:	TableInsert $b510
MusID_JapanSolar:	TableInsert $b5ac	; Japan Solar System (unused in international ROM)
MusID_Varan:		TableInsert $b9c6

	; TODO: document sounds
SFXID_Start:		TableInsert $ba85
			.rept 19
					TableInsert $ba85
			.endrept
					TableInsert $bb23
					TableInsert $bb51
					TableInsert $bb7f
					TableInsert $bb91
SFXID_MothraStep:	TableInsert $bbac
SFXID_GodzillaStep:	TableInsert $bbc7
					TableInsert $bbe1
					TableInsert $bbf3
					TableInsert $bc11
					TableInsert $bc2f
					TableInsert $bc4c
SFXID_GodzillaRoar:	TableInsert $bc65
SFXID_RodanRoar:	TableInsert $bc88
SFXID_MothraRoar:	TableInsert $bcb9
					TableInsert $bd02
SFXID_AnguirusRoar:	TableInsert $bd10
					TableInsert $bd3f
					TableInsert $bd6d
					TableInsert $bdbb
					TableInsert $bdfe
					TableInsert $be27
					TableInsert $be4c

Sound_SoundTable:	.addr CurrentTable

Music_JapanTitle:
			CSF_HeaderStart _HeaderEnd

			; Pulse 1
			CSF_HeaderChID 0
			CSF_HeaderInitLoop 1
			CSF_HeaderPulseSetup 2, 1, 1, 15
			CSF_HeaderInitVoice 4
			CSF_HeaderPulseSweep 0, 0, 0, 0
			CSF_HeaderPitch $f7
			CSF_HeaderTempo $78
			CSF_HeaderPulse 1, _pulse1

			; Triangle
			CSF_HeaderChID 1
			CSF_HeaderInitLoop 1
			CSF_HeaderTriSetup 0, $7f, $41
			CSF_HeaderInitVoice 4
			CSF_HeaderPitch $03
			CSF_HeaderTempo $78
			CSF_HeaderTriangle _triangle

			; Pulse 2
			CSF_HeaderChID 2
			CSF_HeaderInitLoop 1
			CSF_HeaderPulseSetup 1, 1, 1, 15
			CSF_HeaderInitVoice 2
			CSF_HeaderPulseSweep 0, 0, 0, 0
			CSF_HeaderPitch 3
			CSF_HeaderTempo $78
			CSF_HeaderPulse 2, _pulse2

			; Noise
			CSF_HeaderChID 3
			CSF_HeaderInitLoop 2
			CSF_HeaderNoiseSetup 1, 1, $B, 0
			CSF_HeaderInitVoice 4
			CSF_HeaderPitch 0
			CSF_HeaderTempo $78
			CSF_HeaderNoise _noise

_HeaderEnd

_pulse1:
			CSF_SetVoice $04
			.byte $23, cDelay(1), $24, cDelay(0)
			.byte $0b
			CSF_Command $8a, $ff
			.byte $18, cDelay(8)
			.byte $18, $18, $18
			.byte $18, $18, $18
_pulse1_loop:
			CSF_SetVoice $07
			CSF_Command $8a, $01
			CSF_SetLoopCount 2
-
			.byte $25, $e5, $24, $22	; $8c54: 25 e5 24 22	 Data
			.byte $e8, $25, $e5, $24	; $8c58: e8 25 e5 24	 Data
			.byte $22, $e8, $25, $e5	; $8c5c: 22 e8 25 e5	 Data
			.byte $24, $22, $20, $22	; $8c60: 24 22 20 22	 Data
			.byte $24, $25, $24, $22	; $8c64: 24 25 24 22	 Data
			.byte $e8, $25, $e5, $24	; $8c68: e8 25 e5 24	 Data
			.byte $22, $e8, $25, $e5	; $8c6c: 22 e8 25 e5	 Data
			.byte $24, $22, $e8, $25	; $8c70: 24 22 e8 25	 Data
			.byte $e5, $24, $22, $20	; $8c74: e5 24 22 20	 Data
			.byte $22, $24, $25, $24	; $8c78: 22 24 25 24	 Data
			.byte $22, $e8, $27, $e5	; $8c7c: 22 e8 27 e5	 Data
			.byte $25, $24, $e8, $27	; $8c80: 25 24 e8 27	 Data
			.byte $e5, $25, $24, $e8	; $8c84: e5 25 24 e8	 Data
			.byte $27, $e5, $25, $24	; $8c88: 27 e5 25 24	 Data
			.byte $22, $24, $25, $27	; $8c8c: 22 24 25 27	 Data
			.byte $25, $24, $e8, $27	; $8c90: 25 24 e8 27	 Data
			.byte $e5, $25, $24, $e8	; $8c94: e5 25 24 e8	 Data
			.byte $27, $e5, $25, $24	; $8c98: 27 e5 25 24	 Data
			.byte $e8, $27, $e5, $25	; $8c9c: e8 27 e5 25	 Data
			.byte $24, $22, $24, $25	; $8ca0: 24 22 24 25	 Data
			.byte $27, $25, $24, $27	; $8ca4: 27 25 24 27	 Data
			.byte $27, $25, $25, $24	; $8ca8: 27 25 25 24	 Data
			.byte $24, $22

			CSF_Loop -

			CSF_SetVoice $04	; $8cb0: 54 8c 88 04	 Data
			.byte $28, $e1, $29, $e0	; $8cb4: 28 e1 29 e0	 Data
			.byte $0b
			.byte $8a, $ff
			.byte $18	; $8cb8: 0b 8a ff 18	 Data
			.byte $e8, $18, $18, $18	; $8cbc: e8 18 18 18	 Data
			.byte $18
			.byte $8a, $01
			.byte $23	; $8cc0: 18 8a 01 23	 Data
			.byte $e1, $24, $e0, $0b	; $8cc4: e1 24 e0 0b	 Data
			.byte $8a, $ff, $18, $e8	; $8cc8: 8a ff 18 e8	 Data
			.byte $8a, $01, $23, $e1	; $8ccc: 8a 01 23 e1	 Data
			.byte $24, $e0, $0b, $8a	; $8cd0: 24 e0 0b 8a	 Data
			.byte $ff, $18, $e8, $18	; $8cd4: ff 18 e8 18	 Data
			.byte $18, $8a, $01, $23	; $8cd8: 18 8a 01 23	 Data
			.byte $e1, $24, $e0, $0b	; $8cdc: e1 24 e0 0b	 Data
			.byte $8a, $ff, $18, $e8	; $8ce0: 8a ff 18 e8	 Data
			.byte $18, $18, $18, $18	; $8ce4: 18 18 18 18	 Data
			.byte $18, $18, $8a, $01	; $8ce8: 18 18 8a 01	 Data
			CSF_Jump _pulse1_loop
			CSF_Stop

_triangle:
			CSF_SetVoice $04
			.byte $1d, $e8	; $8cf0: 88 04 1d e8	 Data
			.byte $00, $ed, $00, $ee	; $8cf4: 00 ed 00 ee	 Data
_triangle_loop:
			CSF_SetVoice $07
			CSF_SetLoopCount 3
-
			.byte $00, $ee, $00	; $8cfc: 03 00 ee 00	 Data
			.byte $00, $e8
			CSF_Loop -

			.byte $00, $ee	; $8d04: fd 8c 00 ee	 Data
			.byte $00, $00, $83, $43	; $8d08: 00 00 83 43	 Data
			CSF_SetLoopCount 2
-
			.byte $31
			.byte $e5, $30, $2e, $e8	; $8d10: e5 30 2e e8	 Data
			.byte $31, $e5, $30, $2e	; $8d14: 31 e5 30 2e	 Data
			.byte $e8, $31, $e5, $30	; $8d18: e8 31 e5 30	 Data
			.byte $2e, $2c, $2e, $30	; $8d1c: 2e 2c 2e 30	 Data
			.byte $31, $30, $2e, $e8	; $8d20: 31 30 2e e8	 Data
			CSF_Loop -
			CSF_SetLoopCount 1
-
			.byte $33
			.byte $e5, $31, $30, $e8	; $8d2c: e5 31 30 e8	 Data
			.byte $33, $e5, $31, $30	; $8d30: 33 e5 31 30	 Data
			.byte $e8, $33, $e5, $31	; $8d34: e8 33 e5 31	 Data
			.byte $30, $2e, $30, $31	; $8d38: 30 2e 30 31	 Data
			.byte $33, $31
			CSF_Loop +
			.byte $30, $e8	; $8d40: 47 8d 30 e8	 Data
			CSF_Jump -
+
			.byte $30	; $8d44: 80 2b 8d 30	 Data
			.byte $e5, $33, $33, $31	; $8d48: e5 33 33 31	 Data
			.byte $31, $30, $30, $2e	; $8d4c: 31 30 30 2e	 Data
			.byte $83, $40
			CSF_SetVoice $04	; $8d50: 83 40 88 04	 Data
			.byte $30, $e8, $00, $ed	; $8d54: 30 e8 00 ed	 Data
			.byte $00, $eb, $29, $e8	; $8d58: 00 eb 29 e8	 Data
			.byte $00, $29, $00, $ed	; $8d5c: 00 29 00 ed	 Data
			.byte $29, $e8, $00, $ed	; $8d60: 29 e8 00 ed	 Data
			.byte $00, $ee
			CSF_Jump _triangle_loop
			CSF_Stop

_pulse2:
			.byte $00, $ee
			.byte $00
_pulse2_loop:
			CSF_SetLoopCount 2
-
			.byte $16, $e8, $16, $16	; $8d70: 16 e8 16 16	 Data
			.byte $16, $16, $16, $e5	; $8d74: 16 16 16 e5	 Data
			.byte $14, $16, $00, $16	; $8d78: 14 16 00 16	 Data
			.byte $00, $16, $16
			CSF_Loop -

			.byte $18	; $8d80: 70 70 8d 18	 Data
			.byte $e8, $18, $18, $18	; $8d84: e8 18 18 18	 Data
			.byte $18, $18, $e5, $16	; $8d88: 18 18 e5 16	 Data
			.byte $18, $00, $18, $00	; $8d8c: 18 00 18 00	 Data
			.byte $18, $18, $18, $e8	; $8d90: 18 18 18 e8	 Data
			.byte $18, $18, $18, $18	; $8d94: 18 18 18 18	 Data
			.byte $18, $18, $18, $e5	; $8d98: 18 18 18 e5	 Data
			.byte $18, $18, $1b, $e8	; $8d9c: 18 18 1b e8	 Data
			.byte $19, $18, $16, $e5	; $8da0: 19 18 16 e5	 Data

			CSF_SetLoopCount 2
-
			.byte $16	; $8da4: 8d 70 02 16	 Data
			.byte $e8, $16, $16, $16	; $8da8: e8 16 16 16	 Data
			.byte $16, $16, $16, $16	; $8dac: 16 16 16 16	 Data
			.byte $16
			CSF_Loop -

			.byte $18, $18, $18	; $8db4: 8d 18 18 18	 Data
			.byte $18, $18, $18, $18	; $8db8: 18 18 18 18	 Data
			.byte $18, $18, $18, $18	; $8dbc: 18 18 18 18	 Data
			.byte $18, $18, $18, $18	; $8dc0: 18 18 18 18	 Data
			.byte $18, $18, $18, $e5	; $8dc4: 18 18 18 e5	 Data
			.byte $1b, $e8, $19, $18	; $8dc8: 1b e8 19 18	 Data
			.byte $16, $e5, $18, $e8	; $8dcc: 16 e5 18 e8	 Data
			.byte $00, $ed, $00, $ee	; $8dd0: 00 ed 00 ee	 Data
			.byte $00, $00, $00
			CSF_Jump _pulse2_loop
			CSF_Stop

_noise:
			.byte $00	; $8dd8: 6d 8d 82 00	 Data
			.byte $ee, $00, $ed, $00	; $8ddc: ee 00 ed 00	 Data
			.byte $e5, $c0, $e3, $c0	; $8de0: e5 c0 e3 c0	 Data
			.byte $8a, $fb
_noise_loop:
			.byte $c0, $e5	; $8de4: 8a fb c0 e5	 Data
			.byte $c0, $8a, $05, $c0	; $8de8: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $c0	; $8dec: 8a fb c0 c0	 Data
			.byte $c0, $8a, $05, $c0	; $8df0: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0
			CSF_Jump _noise_loop

			CSF_Stop


			.byte $04	; $8df8: e6 8d 82 04	 Data
			.byte $00, $01, $7f, $06	; $8dfc: 00 01 7f 06	 Data
			.byte $40, $00, $69, $00	; $8e00: 40 00 69 00	 Data
			.byte $24, $8e, $01, $01	; $8e04: 24 8e 01 01	 Data
			.byte $7f, $06, $41, $00	; $8e08: 7f 06 41 00	 Data
			.byte $69, $01, $f7, $8e	; $8e0c: 69 01 f7 8e	 Data
			.byte $02, $01, $bf, $03	; $8e10: 02 01 bf 03	 Data
			.byte $40, $18, $69, $02	; $8e14: 40 18 69 02	 Data
			.byte $ac, $8f, $03, $02	; $8e18: ac 8f 03 02	 Data
			.byte $3f, $02, $40, $00	; $8e1c: 3f 02 40 00	 Data
			.byte $69, $03, $8c, $90	; $8e20: 69 03 8c 90	 Data
			.byte $8d, $70, $02, $2c	; $8e24: 8d 70 02 2c	 Data
			.byte $e3, $00, $25, $2a	; $8e28: e3 00 25 2a	 Data
			.byte $00, $2c, $25, $00	; $8e2c: 00 2c 25 00	 Data
			.byte $2a, $00, $2c, $00	; $8e30: 2a 00 2c 00	 Data
			.byte $2f, $00, $2f, $2e	; $8e34: 2f 00 2f 2e	 Data
			.byte $00, $2e, $00, $81	; $8e38: 00 2e 00 81	 Data
			.byte $70, $27, $8e, $2a	; $8e3c: 70 27 8e 2a	 Data
			.byte $eb, $28, $27, $ee	; $8e40: eb 28 27 ee	 Data
			.byte $25, $e3, $00, $23	; $8e44: 25 e3 00 23	 Data
			.byte $25, $00, $23, $25	; $8e48: 25 00 23 25	 Data
			.byte $00, $25, $00, $23	; $8e4c: 00 25 00 23	 Data
			.byte $25, $00, $23, $25	; $8e50: 25 00 23 25	 Data
			.byte $00, $2a, $00, $28	; $8e54: 00 2a 00 28	 Data
			.byte $2a, $00, $28, $2a	; $8e58: 2a 00 28 2a	 Data
			.byte $00, $2a, $00, $28	; $8e5c: 00 2a 00 28	 Data
			.byte $2a, $00, $28, $2a	; $8e60: 2a 00 28 2a	 Data
			.byte $00, $8d, $70, $02	; $8e64: 00 8d 70 02	 Data
			.byte $2f, $e3, $2e, $2a	; $8e68: 2f e3 2e 2a	 Data
			.byte $2f, $2e, $2a, $2f	; $8e6c: 2f 2e 2a 2f	 Data
			.byte $2e, $81, $70, $68	; $8e70: 2e 81 70 68	 Data
			.byte $8e, $33, $31, $2c	; $8e74: 8e 33 31 2c	 Data
			.byte $33, $31, $2c, $33	; $8e78: 33 31 2c 33	 Data
			.byte $31, $36, $35, $31	; $8e7c: 31 36 35 31	 Data
			.byte $36, $35, $31, $36	; $8e80: 36 35 31 36	 Data
			.byte $35, $31, $eb, $33	; $8e84: 35 31 eb 33	 Data
			.byte $2f, $31, $2e, $ee	; $8e88: 2f 31 2e ee	 Data
			.byte $2e, $e3, $2e, $00	; $8e8c: 2e e3 2e 00	 Data
			.byte $2e, $00, $2e, $2e	; $8e90: 2e 00 2e 2e	 Data
			.byte $00, $ea, $96, $59	; $8e94: 00 ea 96 59	 Data
			.byte $00, $e7, $27, $28	; $8e98: 00 e7 27 28	 Data
			.byte $23, $e3, $00, $2f	; $8e9c: 23 e3 00 2f	 Data
			.byte $00, $2e, $e0, $12	; $8ea0: 00 2e e0 12	 Data
			.byte $2c, $e3, $00, $2a	; $8ea4: 2c e3 00 2a	 Data
			.byte $00, $27, $e7, $28	; $8ea8: 00 27 e7 28	 Data
			.byte $23, $e3, $00, $1e	; $8eac: 23 e3 00 1e	 Data
			.byte $eb, $20, $e7, $21	; $8eb0: eb 20 e7 21	 Data
			.byte $1e, $e3, $00, $28	; $8eb4: 1e e3 00 28	 Data
			.byte $00, $27, $e0, $12	; $8eb8: 00 27 e0 12	 Data
			.byte $25, $e3, $00, $23	; $8ebc: 25 e3 00 23	 Data
			.byte $00, $25, $eb, $27	; $8ec0: 00 25 eb 27	 Data
			.byte $e8, $00, $28, $e7	; $8ec4: e8 00 28 e7	 Data
			.byte $2a, $27, $e3, $00	; $8ec8: 2a 27 e3 00	 Data
			.byte $34, $00, $33, $e0	; $8ecc: 34 00 33 e0	 Data
			.byte $12, $31, $e3, $00	; $8ed0: 12 31 e3 00	 Data
			.byte $2f, $00, $2c, $e7	; $8ed4: 2f 00 2c e7	 Data
			.byte $2d, $28, $e3, $00	; $8ed8: 2d 28 e3 00	 Data
			.byte $25, $eb, $2d, $e7	; $8edc: 25 eb 2d e7	 Data
			.byte $2c, $2a, $e3, $00	; $8ee0: 2c 2a e3 00	 Data
			.byte $28, $e0, $15, $00	; $8ee4: 28 e0 15 00	 Data
			.byte $e3, $27, $00, $23	; $8ee8: e3 27 00 23	 Data
			.byte $00, $25, $eb, $2c	; $8eec: 00 25 eb 2c	 Data
			.byte $e8, $96, $69, $00	; $8ef0: e8 96 69 00	 Data
			.byte $80, $24, $8e, $8d	; $8ef4: 80 24 8e 8d	 Data
			.byte $70, $02, $28, $e3	; $8ef8: 70 02 28 e3	 Data
			.byte $00, $00, $27, $00	; $8efc: 00 00 27 00	 Data
			.byte $28, $00, $00, $27	; $8f00: 28 00 00 27	 Data
			.byte $00, $28, $00, $2c	; $8f04: 00 28 00 2c	 Data
			.byte $00, $2c, $2a, $00	; $8f08: 00 2c 2a 00	 Data
			.byte $2a, $00, $81, $70	; $8f0c: 2a 00 81 70	 Data
			.byte $fa, $8e, $26, $eb	; $8f10: fa 8e 26 eb	 Data
			.byte $21, $20, $ee, $00	; $8f14: 21 20 ee 00	 Data
			.byte $8d, $70, $03, $25	; $8f18: 8d 70 03 25	 Data
			.byte $e3, $00, $25, $25	; $8f1c: e3 00 25 25	 Data
			.byte $00, $25, $25, $00	; $8f20: 00 25 25 00	 Data
			.byte $25, $00, $25, $25	; $8f24: 25 00 25 25	 Data
			.byte $00, $25, $25, $00	; $8f28: 00 25 25 00	 Data
			.byte $81, $70, $1b, $8f	; $8f2c: 81 70 1b 8f	 Data
			.byte $2d, $eb, $2f, $2c	; $8f30: 2d eb 2f 2c	 Data
			.byte $2a, $2a, $ee, $25	; $8f34: 2a 2a ee 25	 Data
			.byte $e3, $25, $00, $25	; $8f38: e3 25 00 25	 Data
			.byte $00, $25, $25, $00	; $8f3c: 00 25 25 00	 Data
			.byte $ea, $96, $59, $00	; $8f40: ea 96 59 00	 Data
			.byte $e7, $00, $e3, $00	; $8f44: e7 00 e3 00	 Data
			.byte $8a, $fb, $27, $e7	; $8f48: 8a fb 27 e7	 Data
			.byte $28, $23, $e3, $00	; $8f4c: 28 23 e3 00	 Data
			.byte $2f, $00, $2e, $e0	; $8f50: 2f 00 2e e0	 Data
			.byte $12, $2c, $e3, $00	; $8f54: 12 2c e3 00	 Data
			.byte $2a, $00, $27, $e7	; $8f58: 2a 00 27 e7	 Data
			.byte $28, $23, $e3, $00	; $8f5c: 28 23 e3 00	 Data
			.byte $1e, $eb, $20, $e7	; $8f60: 1e eb 20 e7	 Data
			.byte $21, $1e, $e3, $00	; $8f64: 21 1e e3 00	 Data
			.byte $28, $00, $27, $e0	; $8f68: 28 00 27 e0	 Data
			.byte $12, $25, $e3, $00	; $8f6c: 12 25 e3 00	 Data
			.byte $23, $00, $25, $eb	; $8f70: 23 00 25 eb	 Data
			.byte $27, $e8, $8a, $02	; $8f74: 27 e8 8a 02	 Data
			.byte $00, $28, $e7, $2a	; $8f78: 00 28 e7 2a	 Data
			.byte $27, $e3, $00, $34	; $8f7c: 27 e3 00 34	 Data
			.byte $00, $33, $e0, $12	; $8f80: 00 33 e0 12	 Data
			.byte $31, $e3, $00, $2f	; $8f84: 31 e3 00 2f	 Data
			.byte $00, $2c, $e7, $2d	; $8f88: 00 2c e7 2d	 Data
			.byte $28, $e3, $00, $25	; $8f8c: 28 e3 00 25	 Data
			.byte $ea, $8a, $03, $2a	; $8f90: ea 8a 03 2a	 Data
			.byte $e7, $28, $27, $e3	; $8f94: e7 28 27 e3	 Data
			.byte $00, $25, $e0, $15	; $8f98: 00 25 e0 15	 Data
			.byte $00, $e3, $23, $00	; $8f9c: 00 e3 23 00	 Data
			.byte $20, $00, $22, $eb	; $8fa0: 20 00 22 eb	 Data
			.byte $24, $e8, $96, $69	; $8fa4: 24 e8 96 69	 Data
			.byte $00, $80, $f7, $8e	; $8fa8: 00 80 f7 8e	 Data
			.byte $8d, $70, $02, $19	; $8fac: 8d 70 02 19	 Data
			.byte $e3, $00, $19, $19	; $8fb0: e3 00 19 19	 Data
			.byte $00, $19, $19, $00	; $8fb4: 00 19 19 00	 Data
			.byte $19, $00, $19, $00	; $8fb8: 19 00 19 00	 Data
			.byte $19, $00, $19, $19	; $8fbc: 19 00 19 19	 Data
			.byte $00, $19, $00, $81	; $8fc0: 00 19 00 81	 Data
			.byte $70, $af, $8f, $8d	; $8fc4: 70 af 8f 8d	 Data
			.byte $70, $02, $15, $e3	; $8fc8: 70 02 15 e3	 Data
			.byte $00, $15, $15, $00	; $8fcc: 00 15 15 00	 Data
			.byte $15, $15, $00, $15	; $8fd0: 15 15 00 15	 Data
			.byte $00, $15, $15, $00	; $8fd4: 00 15 15 00	 Data
			.byte $15, $15, $00, $9c	; $8fd8: 15 15 00 9c	 Data
			.byte $02, $67, $91, $81	; $8fdc: 02 67 91 81	 Data
			.byte $70, $ca, $8f, $8d	; $8fe0: 70 ca 8f 8d	 Data
			.byte $70, $04, $19, $e3	; $8fe4: 70 04 19 e3	 Data
			.byte $00, $17, $19, $00	; $8fe8: 00 17 19 00	 Data
			.byte $17, $19, $00, $19	; $8fec: 17 19 00 19	 Data
			.byte $00, $17, $19, $00	; $8ff0: 00 17 19 00	 Data
			.byte $17, $19, $00, $81	; $8ff4: 17 19 00 81	 Data
			.byte $70, $e6, $8f, $8d	; $8ff8: 70 e6 8f 8d	 Data
			.byte $70, $03, $15, $e3	; $8ffc: 70 03 15 e3	 Data
			.byte $00, $15, $15, $00	; $9000: 00 15 15 00	 Data
			.byte $15, $15, $00, $15	; $9004: 15 15 00 15	 Data
			.byte $00, $15, $15, $00	; $9008: 00 15 15 00	 Data
			.byte $15, $15, $00, $9c	; $900c: 15 15 00 9c	 Data
			.byte $03, $69, $91, $81	; $9010: 03 69 91 81	 Data
			.byte $70, $fe, $8f, $12	; $9014: 70 fe 8f 12	 Data
			.byte $12, $00, $12, $00	; $9018: 12 00 12 00	 Data
			.byte $12, $12, $00, $ea	; $901c: 12 12 00 ea	 Data
			.byte $96, $59, $12, $e3	; $9020: 96 59 12 e3	 Data
			.byte $12, $12, $8d, $70	; $9024: 12 12 8d 70	 Data
			.byte $01, $19, $e3, $00	; $9028: 01 19 e3 00	 Data
			.byte $19, $19, $00, $19	; $902c: 19 19 00 19	 Data
			.byte $19, $00, $19, $00	; $9030: 19 00 19 00	 Data
			.byte $19, $00, $19, $19	; $9034: 19 00 19 19	 Data
			.byte $00, $19, $19, $00	; $9038: 00 19 19 00	 Data
			.byte $19, $00, $15, $00	; $903c: 19 00 15 00	 Data
			.byte $15, $15, $00, $15	; $9040: 15 15 00 15	 Data
			.byte $15, $00, $15, $00	; $9044: 15 00 15 00	 Data
			.byte $15, $15, $00, $15	; $9048: 15 15 00 15	 Data
			.byte $15, $00, $12, $00	; $904c: 15 00 12 00	 Data
			.byte $12, $12, $00, $12	; $9050: 12 12 00 12	 Data
			.byte $12, $00, $12, $00	; $9054: 12 00 12 00	 Data
			.byte $12, $00, $12, $12	; $9058: 12 00 12 12	 Data
			.byte $00, $12, $12, $00	; $905c: 00 12 12 00	 Data
			.byte $12, $00, $81, $70	; $9060: 12 00 81 70	 Data
			.byte $79, $90, $14, $00	; $9064: 79 90 14 00	 Data
			.byte $14, $14, $00, $14	; $9068: 14 14 00 14	 Data
			.byte $14, $00, $14, $00	; $906c: 14 00 14 00	 Data
			.byte $14, $14, $00, $14	; $9070: 14 14 00 14	 Data
			.byte $14, $00, $80, $29	; $9074: 14 00 80 29	 Data
			.byte $90, $14, $00, $14	; $9078: 90 14 00 14	 Data
			.byte $14, $00, $14, $14	; $907c: 14 00 14 14	 Data
			.byte $00, $14, $00, $14	; $9080: 00 14 00 14	 Data
			.byte $14, $96, $69, $00	; $9084: 14 96 69 00	 Data
			.byte $e8, $80, $ac, $8f	; $9088: e8 80 ac 8f	 Data
			.byte $8d, $70, $02, $c1	; $908c: 8d 70 02 c1	 Data
			.byte $e3, $c1, $c1, $c0	; $9090: e3 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $9094: c1 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c1	; $9098: c0 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $909c: c0 c1 c1 c0	 Data
			.byte $c1, $c0, $c1, $81	; $90a0: c1 c0 c1 81	 Data
			.byte $70, $8f, $90, $8d	; $90a4: 70 8f 90 8d	 Data
			.byte $70, $02, $c1, $e3	; $90a8: 70 02 c1 e3	 Data
			.byte $c1, $c1, $c0, $c1	; $90ac: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $c1	; $90b0: c1 c0 c1 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $90b4: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $81	; $90b8: c1 c0 c1 81	 Data
			.byte $70, $aa, $90, $8d	; $90bc: 70 aa 90 8d	 Data
			.byte $70, $03, $c0, $e3	; $90c0: 70 03 c0 e3	 Data
			.byte $c1, $c1, $c0, $c1	; $90c4: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $c0	; $90c8: c1 c0 c1 c0	 Data
			.byte $c1, $c1, $c0, $c1	; $90cc: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $81	; $90d0: c1 c0 c1 81	 Data
			.byte $70, $c2, $90, $c0	; $90d4: 70 c2 90 c0	 Data
			.byte $c1, $c1, $c0, $c1	; $90d8: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $c0	; $90dc: c1 c0 c1 c0	 Data
			.byte $c1, $c0, $c0, $c0	; $90e0: c1 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8d	; $90e4: c0 c0 c0 8d	 Data
			.byte $70, $03, $c1, $e3	; $90e8: 70 03 c1 e3	 Data
			.byte $c1, $c1, $c0, $c1	; $90ec: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $c1	; $90f0: c1 c0 c1 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $90f4: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c1, $81	; $90f8: c1 c0 c1 81	 Data
			.byte $70, $ea, $90, $c0	; $90fc: 70 ea 90 c0	 Data
			.byte $c0, $00, $c0, $00	; $9100: c0 00 c0 00	 Data
			.byte $c0, $c0, $00, $00	; $9104: c0 c0 00 00	 Data
			.byte $00, $00, $00, $00	; $9108: 00 00 00 00	 Data
			.byte $96, $59, $c0, $c0	; $910c: 96 59 c0 c0	 Data
			.byte $c0, $8d, $70, $03	; $9110: c0 8d 70 03	 Data
			.byte $c1, $e3, $c1, $c1	; $9114: c1 e3 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $9118: c0 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $911c: c1 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $9120: c0 c1 c1 c0	 Data
			.byte $c1, $c0, $c1, $c0	; $9124: c1 c0 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $9128: c1 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $912c: c0 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $9130: c1 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $9134: c0 c1 c1 c0	 Data
			.byte $c1, $81, $70, $14	; $9138: c1 81 70 14	 Data
			.byte $91, $c1, $c1, $c1	; $913c: 91 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $9140: c0 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $9144: c1 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $9148: c0 c1 c1 c0	 Data
			.byte $c1, $c0, $c1, $c0	; $914c: c1 c0 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $9150: c1 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $9154: c0 c1 c1 c0	 Data
			.byte $c1, $c1, $00, $00	; $9158: c1 c1 00 00	 Data
			.byte $00, $96, $69, $c0	; $915c: 00 96 69 c0	 Data
			.byte $c0, $c0, $c0, $80	; $9160: c0 c0 c0 80	 Data
			.byte $8c, $90, $82, $ff	; $9164: 8c 90 82 ff	 Data
			.byte $01, $ff, $fe, $03	; $9168: 01 ff fe 03	 Data
			.byte $04, $00, $01, $bf	; $916c: 04 00 01 bf	 Data
			.byte $01, $40, $00, $77	; $9170: 01 40 00 77	 Data
			.byte $00, $95, $91, $01	; $9174: 00 95 91 01	 Data
			.byte $01, $7e, $01, $41	; $9178: 01 7e 01 41	 Data
			.byte $fb, $77, $01, $a1	; $917c: fb 77 01 a1	 Data
			.byte $91, $02, $01, $bf	; $9180: 91 02 01 bf	 Data
			.byte $06, $40, $18, $77	; $9184: 06 40 18 77	 Data
			.byte $02, $b1, $91, $03	; $9188: 02 b1 91 03	 Data
			.byte $02, $3f, $04, $40	; $918c: 02 3f 04 40	 Data
			.byte $00, $77, $03, $d5	; $9190: 00 77 03 d5	 Data
			.byte $91, $2c, $e3, $2e	; $9194: 91 2c e3 2e	 Data
			.byte $2f, $31, $e0, $63	; $9198: 2f 31 e0 63	 Data
			.byte $8b, $2f, $e0, $0c	; $919c: 8b 2f e0 0c	 Data
			.byte $82, $89, $05, $2c	; $91a0: 82 89 05 2c	 Data
			.byte $e3, $2e, $2f, $2c	; $91a4: e3 2e 2f 2c	 Data
			.byte $e0, $0c, $2e, $e7	; $91a8: e0 0c 2e e7	 Data
			.byte $2f, $36, $e0, $51	; $91ac: 2f 36 e0 51	 Data
			.byte $82, $14, $e3, $00	; $91b0: 82 14 e3 00	 Data
			.byte $14, $14, $00, $14	; $91b4: 14 14 00 14	 Data
			.byte $00, $14, $14, $00	; $91b8: 00 14 14 00	 Data
			.byte $14, $14, $00, $14	; $91bc: 14 14 00 14	 Data
			.byte $00, $14, $14, $00	; $91c0: 00 14 14 00	 Data
			.byte $14, $14, $00, $14	; $91c4: 14 14 00 14	 Data
			.byte $00, $14, $14, $00	; $91c8: 00 14 14 00	 Data
			.byte $14, $14, $00, $14	; $91cc: 14 14 00 14	 Data
			.byte $00, $14, $91, $01	; $91d0: 00 14 91 01	 Data
			.byte $82, $8c, $c0, $e3	; $91d4: 82 8c c0 e3	 Data
			.byte $00, $c0, $c0, $8c	; $91d8: 00 c0 c0 8c	 Data
			.byte $c0, $8c, $00, $c0	; $91dc: c0 8c 00 c0	 Data
			.byte $c0, $c0, $00, $c0	; $91e0: c0 c0 00 c0	 Data
			.byte $c0, $8c, $c0, $8c	; $91e4: c0 8c c0 8c	 Data
			.byte $00, $c0, $c0, $c0	; $91e8: 00 c0 c0 c0	 Data
			.byte $00, $c0, $c0, $8c	; $91ec: 00 c0 c0 8c	 Data
			.byte $c0, $8c, $00, $c0	; $91f0: c0 8c 00 c0	 Data
			.byte $c0, $c0, $00, $c0	; $91f4: c0 c0 00 c0	 Data
			.byte $c0, $8c, $c0, $00	; $91f8: c0 8c c0 00	 Data
			.byte $8c, $c0, $c0, $00	; $91fc: 8c c0 c0 00	 Data
			.byte $ee, $82, $04, $00	; $9200: ee 82 04 00	 Data
			.byte $01, $7f, $04, $40	; $9204: 01 7f 04 40	 Data
			.byte $00, $80, $00, $2b	; $9208: 00 80 00 2b	 Data
			.byte $92, $01, $01, $7a	; $920c: 92 01 01 7a	 Data
			.byte $04, $41, $00, $80	; $9210: 04 41 00 80	 Data
			.byte $01, $6f, $92, $02	; $9214: 01 6f 92 02	 Data
			.byte $01, $bf, $09, $40	; $9218: 01 bf 09 40	 Data
			.byte $0c, $80, $02, $b3	; $921c: 0c 80 02 b3	 Data
			.byte $92, $03, $02, $3f	; $9220: 92 03 02 3f	 Data
			.byte $04, $40, $00, $80	; $9224: 04 40 00 80	 Data
			.byte $03, $e5, $92, $35	; $9228: 03 e5 92 35	 Data
			.byte $e8, $2e, $31, $e5	; $922c: e8 2e 31 e5	 Data
			.byte $35, $e8, $3a, $e5	; $9230: 35 e8 3a e5	 Data
			.byte $3d, $eb, $3c, $38	; $9234: 3d eb 3c 38	 Data
			.byte $e8, $35, $31, $e5	; $9238: e8 35 31 e5	 Data
			.byte $35, $e8, $38, $e5	; $923c: 35 e8 38 e5	 Data
			.byte $33, $eb, $2e, $e8	; $9240: 33 eb 2e e8	 Data
			.byte $2e, $e5, $30, $31	; $9244: 2e e5 30 31	 Data
			.byte $eb, $00, $e5, $31	; $9248: eb 00 e5 31	 Data
			.byte $33, $31, $35, $ea	; $924c: 33 31 35 ea	 Data
			.byte $30, $e5, $30, $e8	; $9250: 30 e5 30 e8	 Data
			.byte $30, $96, $7b, $2e	; $9254: 30 96 7b 2e	 Data
			.byte $eb, $31, $e8, $33	; $9258: eb 31 e8 33	 Data
			.byte $96, $77, $30, $eb	; $925c: 96 77 30 eb	 Data
			.byte $96, $6e, $2c, $96	; $9260: 96 6e 2c 96	 Data
			.byte $66, $2e, $e8, $29	; $9264: 66 2e e8 29	 Data
			.byte $27, $29, $25, $ee	; $9268: 27 29 25 ee	 Data
			.byte $91, $01, $82, $00	; $926c: 91 01 82 00	 Data
			.byte $e7, $35, $e8, $2e	; $9270: e7 35 e8 2e	 Data
			.byte $31, $e5, $35, $e8	; $9274: 31 e5 35 e8	 Data
			.byte $3a, $e5, $3d, $eb	; $9278: 3a e5 3d eb	 Data
			.byte $3c, $38, $e8, $35	; $927c: 3c 38 e8 35	 Data
			.byte $31, $e5, $35, $e8	; $9280: 31 e5 35 e8	 Data
			.byte $38, $e5, $33, $eb	; $9284: 38 e5 33 eb	 Data
			.byte $2e, $e8, $2e, $e5	; $9288: 2e e8 2e e5	 Data
			.byte $30, $31, $eb, $00	; $928c: 30 31 eb 00	 Data
			.byte $e5, $31, $33, $31	; $9290: e5 31 33 31	 Data
			.byte $35, $ea, $30, $e5	; $9294: 35 ea 30 e5	 Data
			.byte $30, $e8, $30, $96	; $9298: 30 e8 30 96	 Data
			.byte $7b, $2e, $eb, $31	; $929c: 7b 2e eb 31	 Data
			.byte $e8, $33, $96, $77	; $92a0: e8 33 96 77	 Data
			.byte $30, $eb, $96, $6e	; $92a4: 30 eb 96 6e	 Data
			.byte $2c, $96, $66, $2e	; $92a8: 2c 96 66 2e	 Data
			.byte $e8, $29, $27, $29	; $92ac: e8 29 27 29	 Data
			.byte $25, $ee, $82, $22	; $92b0: 25 ee 82 22	 Data
			.byte $ea, $22, $e5, $22	; $92b4: ea 22 e5 22	 Data
			.byte $ea, $22, $e5, $21	; $92b8: ea 22 e5 21	 Data
			.byte $eb, $21, $20, $20	; $92bc: eb 21 20 20	 Data
			.byte $1f, $1f, $ea, $1f	; $92c0: 1f 1f ea 1f	 Data
			.byte $e5, $1e, $ea, $1e	; $92c4: e5 1e ea 1e	 Data
			.byte $e5, $1e, $eb, $1d	; $92c8: e5 1e eb 1d	 Data
			.byte $1d, $e8, $1d, $96	; $92cc: 1d e8 1d 96	 Data
			.byte $7b, $1b, $ea, $1b	; $92d0: 7b 1b ea 1b	 Data
			.byte $e5, $1b, $eb, $96	; $92d4: e5 1b eb 96	 Data
			.byte $77, $1d, $96, $6e	; $92d8: 77 1d 96 6e	 Data
			.byte $1d, $96, $66, $88	; $92dc: 1d 96 66 88	 Data
			.byte $09, $16, $e0, $60	; $92e0: 09 16 e0 60	 Data
			.byte $82, $8a, $fa, $8d	; $92e4: 82 8a fa 8d	 Data
			.byte $70, $06, $c0, $e8	; $92e8: 70 06 c0 e8	 Data
			.byte $c0, $e5, $c0, $8a	; $92ec: c0 e5 c0 8a	 Data
			.byte $06, $c0, $8a, $fa	; $92f0: 06 c0 8a fa	 Data
			.byte $c0, $c0, $c0, $81	; $92f4: c0 c0 c0 81	 Data
			.byte $70, $ea, $92, $96	; $92f8: 70 ea 92 96	 Data
			.byte $7b, $c0, $e8, $c0	; $92fc: 7b c0 e8 c0	 Data
			.byte $e5, $c0, $8a, $06	; $9300: e5 c0 8a 06	 Data
			.byte $c0, $8a, $fa, $c0	; $9304: c0 8a fa c0	 Data
			.byte $c0, $c0, $96, $77	; $9308: c0 c0 96 77	 Data
			.byte $c0, $e8, $c0, $e5	; $930c: c0 e8 c0 e5	 Data
			.byte $c0, $96, $6e, $8a	; $9310: c0 96 6e 8a	 Data
			.byte $06, $c0, $8a, $fa	; $9314: 06 c0 8a fa	 Data
			.byte $c0, $c0, $c0, $96	; $9318: c0 c0 c0 96	 Data
			.byte $66, $c0, $e8, $c0	; $931c: 66 c0 e8 c0	 Data
			.byte $e5, $c0, $8a, $06	; $9320: e5 c0 8a 06	 Data
			.byte $c0, $8a, $fa, $c0	; $9324: c0 8a fa c0	 Data
			.byte $c0, $c0, $82, $04	; $9328: c0 c0 82 04	 Data
			.byte $00, $01, $7f, $01	; $932c: 00 01 7f 01	 Data
			.byte $41, $00, $88, $00	; $9330: 41 00 88 00	 Data
			.byte $54, $93, $01, $01	; $9334: 54 93 01 01	 Data
			.byte $39, $02, $40, $00	; $9338: 39 02 40 00	 Data
			.byte $88, $01, $73, $93	; $933c: 88 01 73 93	 Data
			.byte $02, $01, $bf, $02	; $9340: 02 01 bf 02	 Data
			.byte $40, $18, $88, $02	; $9344: 40 18 88 02	 Data
			.byte $9f, $93, $03, $02	; $9348: 9f 93 03 02	 Data
			.byte $3e, $04, $40, $00	; $934c: 3e 04 40 00	 Data
			.byte $88, $03, $bd, $93	; $9350: 88 03 bd 93	 Data
			.byte $22, $e8, $21, $e5	; $9354: 22 e8 21 e5	 Data
			.byte $22, $24, $e8, $22	; $9358: 22 24 e8 22	 Data
			.byte $e5, $24, $96, $80	; $935c: e5 24 96 80	 Data
			.byte $25, $e8, $24, $e5	; $9360: 25 e8 24 e5	 Data
			.byte $25, $96, $77, $27	; $9364: 25 96 77 27	 Data
			.byte $e8, $25, $e5, $27	; $9368: e8 25 e5 27	 Data
			.byte $96, $6e, $29, $00	; $936c: 96 6e 29 00	 Data
			.byte $29, $ee, $82, $3a	; $9370: 29 ee 82 3a	 Data
			.byte $e3, $39, $38, $37	; $9374: e3 39 38 37	 Data
			.byte $36, $35, $34, $33	; $9378: 36 35 34 33	 Data
			.byte $38, $37, $36, $35	; $937c: 38 37 36 35	 Data
			.byte $34, $33, $32, $31	; $9380: 34 33 32 31	 Data
			.byte $96, $80, $88, $01	; $9384: 96 80 88 01	 Data
			.byte $83, $01, $8a, $04	; $9388: 83 01 8a 04	 Data
			.byte $2e, $e8, $2d, $e5	; $938c: 2e e8 2d e5	 Data
			.byte $2e, $96, $77, $30	; $9390: 2e 96 77 30	 Data
			.byte $e8, $2e, $e5, $30	; $9394: e8 2e e5 30	 Data
			.byte $96, $6e, $2d, $2b	; $9398: 96 6e 2d 2b	 Data
			.byte $2d, $ee, $82, $16	; $939c: 2d ee 82 16	 Data
			.byte $e5, $16, $16, $16	; $93a0: e5 16 16 16	 Data
			.byte $18, $18, $18, $18	; $93a4: 18 18 18 18	 Data
			.byte $96, $80, $19, $19	; $93a8: 96 80 19 19	 Data
			.byte $19, $19, $96, $77	; $93ac: 19 19 96 77	 Data
			.byte $1b, $1b, $1b, $1b	; $93b0: 1b 1b 1b 1b	 Data
			.byte $96, $6e, $88, $01	; $93b4: 96 6e 88 01	 Data
			.byte $1d, $00, $11, $ee	; $93b8: 1d 00 11 ee	 Data
			.byte $82, $c0, $e3, $c0	; $93bc: 82 c0 e3 c0	 Data
			.byte $c1, $c1, $c0, $c1	; $93c0: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $93c4: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $c1, $c1	; $93c8: c1 c1 c1 c1	 Data
			.byte $c1, $c1, $96, $80	; $93cc: c1 c1 96 80	 Data
			.byte $c0, $c1, $c1, $c1	; $93d0: c0 c1 c1 c1	 Data
			.byte $c0, $c1, $c1, $c1	; $93d4: c0 c1 c1 c1	 Data
			.byte $96, $77, $c0, $c1	; $93d8: 96 77 c0 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $93dc: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $96, $6e	; $93e0: c1 c1 96 6e	 Data
			.byte $c0, $c0, $c0, $c0	; $93e4: c0 c0 c0 c0	 Data
			.byte $c0, $ee, $82, $04	; $93e8: c0 ee 82 04	 Data
			.byte $02, $01, $bf, $01	; $93ec: 02 01 bf 01	 Data
			.byte $40, $18, $8c, $02	; $93f0: 40 18 8c 02	 Data
			.byte $14, $94, $01, $01	; $93f4: 14 94 01 01	 Data
			.byte $bc, $06, $41, $0c	; $93f8: bc 06 41 0c	 Data
			.byte $8c, $01, $2b, $94	; $93fc: 8c 01 2b 94	 Data
			.byte $00, $01, $bf, $04	; $9400: 00 01 bf 04	 Data
			.byte $40, $0c, $8c, $00	; $9404: 40 0c 8c 00	 Data
			.byte $44, $94, $03, $02	; $9408: 44 94 03 02	 Data
			.byte $3f, $04, $40, $00	; $940c: 3f 04 40 00	 Data
			.byte $8c, $03, $6e, $94	; $9410: 8c 03 6e 94	 Data
			.byte $25, $e5, $24, $22	; $9414: 25 e5 24 22	 Data
			.byte $e8, $25, $e5, $24	; $9418: e8 25 e5 24	 Data
			.byte $22, $e8, $25, $e5	; $941c: 22 e8 25 e5	 Data
			.byte $24, $22, $20, $22	; $9420: 24 22 20 22	 Data
			.byte $24, $25, $27, $29	; $9424: 24 25 27 29	 Data
			.byte $e0, $20, $82, $00	; $9428: e0 20 82 00	 Data
			.byte $e3, $25, $e5, $24	; $942c: e3 25 e5 24	 Data
			.byte $22, $e8, $25, $e5	; $9430: 22 e8 25 e5	 Data
			.byte $24, $22, $e8, $25	; $9434: 24 22 e8 25	 Data
			.byte $e5, $24, $22, $20	; $9438: e5 24 22 20	 Data
			.byte $22, $24, $25, $27	; $943c: 22 24 25 27	 Data
			.byte $29, $e0, $20, $82	; $9440: 29 e0 20 82	 Data
			.byte $8d, $70, $02, $19	; $9444: 8d 70 02 19	 Data
			.byte $e3, $25, $18, $24	; $9448: e3 25 18 24	 Data
			.byte $16, $22, $8a, $fe	; $944c: 16 22 8a fe	 Data
			.byte $16, $22, $8a, $02	; $9450: 16 22 8a 02	 Data
			.byte $81, $70, $47, $94	; $9454: 81 70 47 94	 Data
			.byte $8a, $fe, $19, $25	; $9458: 8a fe 19 25	 Data
			.byte $18, $24, $16, $22	; $945c: 18 24 16 22	 Data
			.byte $14, $20, $16, $22	; $9460: 14 20 16 22	 Data
			.byte $18, $24, $19, $25	; $9464: 18 24 19 25	 Data
			.byte $1b, $27, $29, $e0	; $9468: 1b 27 29 e0	 Data
			.byte $20, $82, $8d, $70	; $946c: 20 82 8d 70	 Data
			.byte $04, $c0, $e3, $c1	; $9470: 04 c0 e3 c1	 Data
			.byte $c1, $c1, $81, $70	; $9474: c1 c1 81 70	 Data
			.byte $71, $94, $8d, $70	; $9478: 71 94 8d 70	 Data
			.byte $04, $c0, $e3, $c0	; $947c: 04 c0 e3 c0	 Data
			.byte $c1, $81, $70, $7d	; $9480: c1 81 70 7d	 Data
			.byte $94, $c0, $c0, $c0	; $9484: 94 c0 c0 c0	 Data
			.byte $c0, $82, $04, $00	; $9488: c0 82 04 00	 Data
			.byte $01, $bf, $04, $40	; $948c: 01 bf 04 40	 Data
			.byte $00, $80, $00, $b3	; $9490: 00 80 00 b3	 Data
			.byte $94, $01, $01, $be	; $9494: 94 01 01 be	 Data
			.byte $02, $40, $00, $80	; $9498: 02 40 00 80	 Data
			.byte $01, $c2, $94, $02	; $949c: 01 c2 94 02	 Data
			.byte $01, $bf, $04, $40	; $94a0: 01 bf 04 40	 Data
			.byte $0c, $80, $02, $df	; $94a4: 0c 80 02 df	 Data
			.byte $94, $03, $02, $3f	; $94a8: 94 03 02 3f	 Data
			.byte $02, $40, $00, $80	; $94ac: 02 40 00 80	 Data
			.byte $03, $ef, $94, $00	; $94b0: 03 ef 94 00	 Data
			.byte $e8, $29, $e5, $2a	; $94b4: e8 29 e5 2a	 Data
			.byte $29, $eb, $2e, $e5	; $94b8: 29 eb 2e e5	 Data
			.byte $00, $41, $42, $41	; $94bc: 00 41 42 41	 Data
			.byte $ed, $82, $00, $e8	; $94c0: ed 82 00 e8	 Data
			.byte $35, $e3, $29, $2e	; $94c4: 35 e3 29 2e	 Data
			.byte $29, $35, $29, $2e	; $94c8: 29 35 29 2e	 Data
			.byte $3a, $35, $29, $2e	; $94cc: 3a 35 29 2e	 Data
			.byte $29, $8a, $00, $3a	; $94d0: 29 8a 00 3a	 Data
			.byte $3b, $3c, $3d, $3e	; $94d4: 3b 3c 3d 3e	 Data
			.byte $3f, $40, $88, $04	; $94d8: 3f 40 88 04	 Data
			.byte $41, $ed, $82, $00	; $94dc: 41 ed 82 00	 Data
			.byte $e8, $16, $e5, $1d	; $94e0: e8 16 e5 1d	 Data
			.byte $16, $1d, $16, $1d	; $94e4: 16 1d 16 1d	 Data
			.byte $16, $1d, $16, $1d	; $94e8: 16 1d 16 1d	 Data
			.byte $22, $ed, $82, $c0	; $94ec: 22 ed 82 c0	 Data
			.byte $e3, $c0, $c0, $c0	; $94f0: e3 c0 c0 c0	 Data
			.byte $8a, $fd, $c0, $e5	; $94f4: 8a fd c0 e5	 Data
			.byte $c0, $8a, $03, $c0	; $94f8: c0 8a 03 c0	 Data
			.byte $8a, $fd, $c0, $c0	; $94fc: 8a fd c0 c0	 Data
			.byte $c0, $8a, $03, $c0	; $9500: c0 8a 03 c0	 Data
			.byte $8a, $fd, $c0, $8a	; $9504: 8a fd c0 8a	 Data
			.byte $03, $c0, $e3, $c0	; $9508: 03 c0 e3 c0	 Data
			.byte $c0, $c0, $c0, $82	; $950c: c0 c0 c0 82	 Data
			.byte $04, $00, $01, $7f	; $9510: 04 00 01 7f	 Data
			.byte $04, $40, $fd, $01	; $9514: 04 40 fd 01	 Data
			.byte $00, $39, $95, $01	; $9518: 00 39 95 01	 Data
			.byte $01, $7c, $04, $41	; $951c: 01 7c 04 41	 Data
			.byte $fd, $01, $01, $50	; $9520: fd 01 01 50	 Data
			.byte $96, $02, $01, $bf	; $9524: 96 02 01 bf	 Data
			.byte $04, $40, $15, $01	; $9528: 04 40 15 01	 Data
			.byte $02, $7c, $97, $03	; $952c: 02 7c 97 03	 Data
			.byte $02, $3f, $02, $00	; $9530: 02 3f 02 00	 Data
			.byte $00, $01, $03, $fc	; $9534: 00 01 03 fc	 Data
			.byte $98, $96, $99, $9d	; $9538: 98 96 99 9d	 Data
			.byte $03, $8d, $70, $01	; $953c: 03 8d 70 01	 Data
			.byte $25, $e5, $24, $22	; $9540: 25 e5 24 22	 Data
			.byte $25, $24, $22, $25	; $9544: 25 24 22 25	 Data
			.byte $24, $22, $25, $24	; $9548: 24 22 25 24	 Data
			.byte $22, $25, $24, $22	; $954c: 22 25 24 22	 Data
			.byte $27, $25, $24, $27	; $9550: 27 25 24 27	 Data
			.byte $25, $24, $27, $25	; $9554: 25 24 27 25	 Data
			.byte $24, $27, $25, $24	; $9558: 24 27 25 24	 Data
			.byte $27, $25, $24, $27	; $955c: 27 25 24 27	 Data
			.byte $25, $24, $22, $25	; $9560: 25 24 22 25	 Data
			.byte $24, $22, $25, $24	; $9564: 24 22 25 24	 Data
			.byte $22, $25, $24, $22	; $9568: 22 25 24 22	 Data
			.byte $25, $24, $22, $25	; $956c: 25 24 22 25	 Data
			.byte $88, $0d, $9d, $0c	; $9570: 88 0d 9d 0c	 Data
			.byte $27, $e0, $2a, $81	; $9574: 27 e0 2a 81	 Data
			.byte $70, $8f, $95, $00	; $9578: 70 8f 95 00	 Data
			.byte $ea, $8a, $fe, $9d	; $957c: ea 8a fe 9d	 Data
			.byte $03, $31, $e5, $00	; $9580: 03 31 e5 00	 Data
			.byte $33, $eb, $00, $e5	; $9584: 33 eb 00 e5	 Data
			.byte $8a, $02, $88, $04	; $9588: 8a 02 88 04	 Data
			.byte $80, $40, $95, $00	; $958c: 80 40 95 00	 Data
			.byte $e5, $9d, $0c, $29	; $9590: e5 9d 0c 29	 Data
			.byte $e0, $36, $8a, $fd	; $9594: e0 36 8a fd	 Data
			.byte $88, $02, $9d, $03	; $9598: 88 02 9d 03	 Data
			.byte $3a, $e5, $3a, $3d	; $959c: 3a e5 3a 3d	 Data
			.byte $3a, $3f, $3a, $41	; $95a0: 3a 3f 3a 41	 Data
			.byte $3a, $42, $3a, $41	; $95a4: 3a 42 3a 41	 Data
			.byte $3a, $3f, $37, $38	; $95a8: 3a 3f 37 38	 Data
			.byte $39, $3a, $3a, $3d	; $95ac: 39 3a 3a 3d	 Data
			.byte $3a, $3f, $3a, $41	; $95b0: 3a 3f 3a 41	 Data
			.byte $3a, $42, $3a, $41	; $95b4: 3a 42 3a 41	 Data
			.byte $3a, $3f, $37, $38	; $95b8: 3a 3f 37 38	 Data
			.byte $39, $88, $0d, $8a	; $95bc: 39 88 0d 8a	 Data
			.byte $03, $31, $ee, $33	; $95c0: 03 31 ee 33	 Data
			.byte $eb, $35, $9d, $0c	; $95c4: eb 35 9d 0c	 Data
			.byte $30, $e0, $54, $9d	; $95c8: 30 e0 54 9d	 Data
			.byte $03, $30, $e4, $31	; $95cc: 03 30 e4 31	 Data
			.byte $33, $9d, $0c, $2e	; $95d0: 33 9d 0c 2e	 Data
			.byte $ee, $9d, $03, $30	; $95d4: ee 9d 03 30	 Data
			.byte $eb, $31, $e8, $00	; $95d8: eb 31 e8 00	 Data
			.byte $e5, $9d, $0c, $38	; $95dc: e5 9d 0c 38	 Data
			.byte $e0, $36, $9d, $03	; $95e0: e0 36 9d 03	 Data
			.byte $36, $ea, $35, $33	; $95e4: 36 ea 35 33	 Data
			.byte $e5, $9d, $0c, $31	; $95e8: e5 9d 0c 31	 Data
			.byte $e0, $36, $9d, $03	; $95ec: e0 36 9d 03	 Data
			.byte $33, $eb, $35, $9d	; $95f0: 33 eb 35 9d	 Data
			.byte $0c, $30, $e0, $54	; $95f4: 0c 30 e0 54	 Data
			.byte $9d, $03, $30, $e4	; $95f8: 9d 03 30 e4	 Data
			.byte $31, $33, $9d, $0c	; $95fc: 31 33 9d 0c	 Data
			.byte $2e, $ee, $9d, $03	; $9600: 2e ee 9d 03	 Data
			.byte $30, $eb, $31, $e8	; $9604: 30 eb 31 e8	 Data
			.byte $00, $e5, $9d, $0c	; $9608: 00 e5 9d 0c	 Data
			.byte $38, $e0, $36, $9d	; $960c: 38 e0 36 9d	 Data
			.byte $03, $25, $e5, $24	; $9610: 03 25 e5 24	 Data
			.byte $22, $25, $24, $22	; $9614: 22 25 24 22	 Data
			.byte $25, $24, $00, $33	; $9618: 25 24 00 33	 Data
			.byte $31, $00, $33, $00	; $961c: 31 00 33 00	 Data
			.byte $00, $31, $00, $00	; $9620: 00 31 00 00	 Data
			.byte $33, $33, $00, $35	; $9624: 33 33 00 35	 Data
			.byte $33, $00, $35, $00	; $9628: 33 00 35 00	 Data
			.byte $00, $33, $00, $00	; $962c: 00 33 00 00	 Data
			.byte $35, $35, $00, $36	; $9630: 35 35 00 36	 Data
			.byte $35, $00, $36, $00	; $9634: 35 00 36 00	 Data
			.byte $00, $35, $00, $00	; $9638: 00 35 00 00	 Data
			.byte $36, $36, $00, $38	; $963c: 36 36 00 38	 Data
			.byte $36, $00, $38, $00	; $9640: 36 00 38 00	 Data
			.byte $00, $36, $00, $00	; $9644: 00 36 00 00	 Data
			.byte $38, $38, $20, $eb	; $9648: 38 38 20 eb	 Data
			.byte $21, $80, $3d, $95	; $964c: 21 80 3d 95	 Data
			.byte $96, $99, $9d, $03	; $9650: 96 99 9d 03	 Data
			.byte $88, $04, $00, $e4	; $9654: 88 04 00 e4	 Data
			.byte $25, $e5, $24, $22	; $9658: 25 e5 24 22	 Data
			.byte $25, $24, $22, $25	; $965c: 25 24 22 25	 Data
			.byte $24, $22, $25, $24	; $9660: 24 22 25 24	 Data
			.byte $22, $25, $24, $22	; $9664: 22 25 24 22	 Data
			.byte $27, $25, $24, $27	; $9668: 27 25 24 27	 Data
			.byte $25, $24, $27, $25	; $966c: 25 24 27 25	 Data
			.byte $24, $27, $25, $24	; $9670: 24 27 25 24	 Data
			.byte $27, $25, $24, $27	; $9674: 27 25 24 27	 Data
			.byte $25, $24, $22, $25	; $9678: 25 24 22 25	 Data
			.byte $24, $22, $25, $24	; $967c: 24 22 25 24	 Data
			.byte $22, $25, $24, $22	; $9680: 22 25 24 22	 Data
			.byte $25, $24, $22, $25	; $9684: 25 24 22 25	 Data
			.byte $88, $0d, $9d, $12	; $9688: 88 0d 9d 12	 Data
			.byte $27, $e0, $30, $00	; $968c: 27 e0 30 00	 Data
			.byte $e4, $00, $9d, $03	; $9690: e4 00 9d 03	 Data
			.byte $2a, $e5, $00, $2c	; $9694: 2a e5 00 2c	 Data
			.byte $eb, $00, $e5, $88	; $9698: eb 00 e5 88	 Data
			.byte $04, $8a, $01, $29	; $969c: 04 8a 01 29	 Data
			.byte $27, $25, $29, $27	; $96a0: 27 25 29 27	 Data
			.byte $25, $29, $27, $25	; $96a4: 25 29 27 25	 Data
			.byte $29, $27, $25, $29	; $96a8: 29 27 25 29	 Data
			.byte $27, $25, $2a, $29	; $96ac: 27 25 2a 29	 Data
			.byte $27, $2a, $29, $27	; $96b0: 27 2a 29 27	 Data
			.byte $2a, $29, $27, $2a	; $96b4: 2a 29 27 2a	 Data
			.byte $29, $27, $2a, $29	; $96b8: 29 27 2a 29	 Data
			.byte $27, $2a, $29, $27	; $96bc: 27 2a 29 27	 Data
			.byte $25, $29, $27, $25	; $96c0: 25 29 27 25	 Data
			.byte $29, $27, $25, $29	; $96c4: 29 27 25 29	 Data
			.byte $27, $25, $29, $27	; $96c8: 27 25 29 27	 Data
			.byte $25, $29, $9d, $0c	; $96cc: 25 29 9d 0c	 Data
			.byte $88, $0d, $22, $e0	; $96d0: 88 0d 22 e0	 Data
			.byte $2a, $00, $e5, $24	; $96d4: 2a 00 e5 24	 Data
			.byte $e0, $36, $9d, $03	; $96d8: e0 36 9d 03	 Data
			.byte $00, $e7, $88, $02	; $96dc: 00 e7 88 02	 Data
			.byte $8a, $fa, $3a, $e5	; $96e0: 8a fa 3a e5	 Data
			.byte $3a, $3d, $3a, $3f	; $96e4: 3a 3d 3a 3f	 Data
			.byte $3a, $41, $3a, $42	; $96e8: 3a 41 3a 42	 Data
			.byte $3a, $41, $3a, $3f	; $96ec: 3a 41 3a 3f	 Data
			.byte $37, $38, $39, $3a	; $96f0: 37 38 39 3a	 Data
			.byte $3a, $3d, $3a, $3f	; $96f4: 3a 3d 3a 3f	 Data
			.byte $3a, $41, $3a, $42	; $96f8: 3a 41 3a 42	 Data
			.byte $3a, $41, $3a, $3f	; $96fc: 3a 41 3a 3f	 Data
			.byte $37, $38, $39, $88	; $9700: 37 38 39 88	 Data
			.byte $0d, $8a, $05, $9d	; $9704: 0d 8a 05 9d	 Data
			.byte $0c, $31, $ee, $9d	; $9708: 0c 31 ee 9d	 Data
			.byte $03, $33, $eb, $35	; $970c: 03 33 eb 35	 Data
			.byte $9d, $0c, $30, $e0	; $9710: 9d 0c 30 e0	 Data
			.byte $54, $9d, $03, $30	; $9714: 54 9d 03 30	 Data
			.byte $e4, $31, $33, $9d	; $9718: e4 31 33 9d	 Data
			.byte $0c, $2e, $ee, $9d	; $971c: 0c 2e ee 9d	 Data
			.byte $03, $30, $eb, $31	; $9720: 03 30 eb 31	 Data
			.byte $e8, $00, $e5, $9d	; $9724: e8 00 e5 9d	 Data
			.byte $0c, $38, $e0, $2d	; $9728: 0c 38 e0 2d	 Data
			.byte $9d, $03, $8a, $01	; $972c: 9d 03 8a 01	 Data
			.byte $25, $e5, $24, $22	; $9730: 25 e5 24 22	 Data
			.byte $25, $24, $22, $25	; $9734: 25 24 22 25	 Data
			.byte $9d, $0c, $35, $e0	; $9738: 9d 0c 35 e0	 Data
			.byte $36, $9d, $03, $36	; $973c: 36 9d 03 36	 Data
			.byte $eb, $38, $9d, $0c	; $9740: eb 38 9d 0c	 Data
			.byte $35, $e0, $60, $33	; $9744: 35 e0 60 33	 Data
			.byte $ee, $9d, $03, $35	; $9748: ee 9d 03 35	 Data
			.byte $eb, $36, $e8, $00	; $974c: eb 36 e8 00	 Data
			.byte $e5, $9d, $0c, $3c	; $9750: e5 9d 0c 3c	 Data
			.byte $e0, $36, $9d, $03	; $9754: e0 36 9d 03	 Data
			.byte $2c, $e5, $2a, $29	; $9758: 2c e5 2a 29	 Data
			.byte $2c, $2a, $29, $2c	; $975c: 2c 2a 29 2c	 Data
			.byte $2a, $8a, $ff, $8d	; $9760: 2a 8a ff 8d	 Data
			.byte $70, $04, $00, $2e	; $9764: 70 04 00 2e	 Data
			.byte $2e, $00, $2e, $00	; $9768: 2e 00 2e 00	 Data
			.byte $00, $2e, $00, $00	; $976c: 00 2e 00 00	 Data
			.byte $2e, $2e, $81, $70	; $9770: 2e 2e 81 70	 Data
			.byte $66, $97, $27, $eb	; $9774: 66 97 27 eb	 Data
			.byte $28, $80, $54, $96	; $9778: 28 80 54 96	 Data
			.byte $96, $99, $8d, $70	; $977c: 96 99 8d 70	 Data
			.byte $01, $16, $e3, $00	; $9780: 01 16 e3 00	 Data
			.byte $16, $00, $16, $00	; $9784: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $9788: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $978c: 16 00 16 00	 Data
			.byte $16, $e7, $00, $e3	; $9790: 16 e7 00 e3	 Data
			.byte $16, $00, $16, $00	; $9794: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $9798: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $979c: 16 00 16 00	 Data
			.byte $16, $00, $14, $e3	; $97a0: 16 00 14 e3	 Data
			.byte $00, $14, $00, $14	; $97a4: 00 14 00 14	 Data
			.byte $00, $14, $00, $14	; $97a8: 00 14 00 14	 Data
			.byte $00, $14, $00, $14	; $97ac: 00 14 00 14	 Data
			.byte $00, $14, $e7, $00	; $97b0: 00 14 e7 00	 Data
			.byte $e3, $14, $00, $14	; $97b4: e3 14 00 14	 Data
			.byte $00, $14, $00, $14	; $97b8: 00 14 00 14	 Data
			.byte $00, $14, $00, $14	; $97bc: 00 14 00 14	 Data
			.byte $00, $14, $00, $12	; $97c0: 00 14 00 12	 Data
			.byte $e3, $00, $12, $00	; $97c4: e3 00 12 00	 Data
			.byte $12, $00, $12, $00	; $97c8: 12 00 12 00	 Data
			.byte $12, $00, $12, $00	; $97cc: 12 00 12 00	 Data
			.byte $12, $00, $12, $e7	; $97d0: 12 00 12 e7	 Data
			.byte $00, $e3, $12, $00	; $97d4: 00 e3 12 00	 Data
			.byte $12, $00, $12, $00	; $97d8: 12 00 12 00	 Data
			.byte $12, $00, $12, $00	; $97dc: 12 00 12 00	 Data
			.byte $12, $00, $12, $00	; $97e0: 12 00 12 00	 Data
			.byte $81, $70, $09, $98	; $97e4: 81 70 09 98	 Data
			.byte $0f, $00, $0f, $00	; $97e8: 0f 00 0f 00	 Data
			.byte $0f, $00, $0f, $00	; $97ec: 0f 00 0f 00	 Data
			.byte $0f, $00, $0f, $00	; $97f0: 0f 00 0f 00	 Data
			.byte $0f, $00, $0f, $00	; $97f4: 0f 00 0f 00	 Data
			.byte $00, $00, $12, $00	; $97f8: 00 00 12 00	 Data
			.byte $e7, $14, $00, $e3	; $97fc: e7 14 00 e3	 Data
			.byte $14, $00, $14, $00	; $9800: 14 00 14 00	 Data
			.byte $14, $00, $80, $81	; $9804: 14 00 80 81	 Data
			.byte $97, $0f, $00, $0f	; $9808: 97 0f 00 0f	 Data
			.byte $00, $0f, $00, $0f	; $980c: 00 0f 00 0f	 Data
			.byte $00, $0f, $00, $0f	; $9810: 00 0f 00 0f	 Data
			.byte $00, $0f, $00, $11	; $9814: 00 0f 00 11	 Data
			.byte $e7, $00, $e3, $11	; $9818: e7 00 e3 11	 Data
			.byte $00, $11, $00, $11	; $981c: 00 11 00 11	 Data
			.byte $00, $11, $00, $11	; $9820: 00 11 00 11	 Data
			.byte $00, $12, $00, $14	; $9824: 00 12 00 14	 Data
			.byte $00, $8d, $70, $02	; $9828: 00 8d 70 02	 Data
			.byte $16, $00, $16, $00	; $982c: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $9830: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $9834: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $9838: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $983c: 16 00 16 00	 Data
			.byte $16, $00, $16, $00	; $9840: 16 00 16 00	 Data
			.byte $16, $00, $13, $00	; $9844: 16 00 13 00	 Data
			.byte $14, $00, $15, $00	; $9848: 14 00 15 00	 Data
			.byte $81, $70, $2c, $98	; $984c: 81 70 2c 98	 Data
			.byte $8d, $70, $02, $16	; $9850: 8d 70 02 16	 Data
			.byte $00, $16, $00, $19	; $9854: 00 16 00 19	 Data
			.byte $00, $16, $00, $1b	; $9858: 00 16 00 1b	 Data
			.byte $00, $16, $00, $1d	; $985c: 00 16 00 1d	 Data
			.byte $00, $16, $00, $16	; $9860: 00 16 00 16	 Data
			.byte $00, $1b, $00, $1b	; $9864: 00 1b 00 1b	 Data
			.byte $00, $16, $00, $19	; $9868: 00 16 00 19	 Data
			.byte $00, $19, $00, $11	; $986c: 00 19 00 11	 Data
			.byte $00, $13, $00, $14	; $9870: 00 13 00 14	 Data
			.byte $00, $14, $00, $18	; $9874: 00 14 00 18	 Data
			.byte $00, $14, $00, $19	; $9878: 00 14 00 19	 Data
			.byte $00, $14, $00, $1b	; $987c: 00 14 00 1b	 Data
			.byte $00, $14, $00, $14	; $9880: 00 14 00 14	 Data
			.byte $00, $19, $00, $19	; $9884: 00 19 00 19	 Data
			.byte $00, $14, $00, $18	; $9888: 00 14 00 18	 Data
			.byte $00, $18, $00, $14	; $988c: 00 18 00 14	 Data
			.byte $00, $12, $e7, $00	; $9890: 00 12 e7 00	 Data
			.byte $e3, $12, $00, $12	; $9894: e3 12 00 12	 Data
			.byte $00, $12, $00, $12	; $9898: 00 12 00 12	 Data
			.byte $00, $12, $00, $12	; $989c: 00 12 00 12	 Data
			.byte $00, $12, $e7, $00	; $98a0: 00 12 e7 00	 Data
			.byte $e3, $12, $00, $12	; $98a4: e3 12 00 12	 Data
			.byte $00, $12, $00, $12	; $98a8: 00 12 00 12	 Data
			.byte $00, $12, $00, $12	; $98ac: 00 12 00 12	 Data
			.byte $00, $11, $e7, $00	; $98b0: 00 11 e7 00	 Data
			.byte $e3, $11, $00, $11	; $98b4: e3 11 00 11	 Data
			.byte $00, $11, $00, $11	; $98b8: 00 11 00 11	 Data
			.byte $00, $11, $00, $11	; $98bc: 00 11 00 11	 Data
			.byte $00, $11, $00, $19	; $98c0: 00 11 00 19	 Data
			.byte $00, $18, $00, $16	; $98c4: 00 18 00 16	 Data
			.byte $00, $19, $00, $18	; $98c8: 00 19 00 18	 Data
			.byte $00, $16, $00, $19	; $98cc: 00 16 00 19	 Data
			.byte $00, $18, $00, $81	; $98d0: 00 18 00 81	 Data
			.byte $70, $53, $98, $8d	; $98d4: 70 53 98 8d	 Data
			.byte $70, $04, $16, $00	; $98d8: 70 04 16 00	 Data
			.byte $1d, $00, $1d, $00	; $98dc: 1d 00 1d 00	 Data
			.byte $16, $00, $1b, $00	; $98e0: 16 00 1b 00	 Data
			.byte $16, $00, $16, $00	; $98e4: 16 00 16 00	 Data
			.byte $19, $00, $16, $00	; $98e8: 19 00 16 00	 Data
			.byte $16, $00, $18, $00	; $98ec: 16 00 18 00	 Data
			.byte $16, $00, $81, $70	; $98f0: 16 00 81 70	 Data
			.byte $da, $98, $14, $eb	; $98f4: da 98 14 eb	 Data
			.byte $15, $80, $7e, $97	; $98f8: 15 80 7e 97	 Data
			.byte $96, $99, $8d, $70	; $98fc: 96 99 8d 70	 Data
			.byte $01, $8d, $77, $0e	; $9900: 01 8d 77 0e	 Data
			.byte $c1, $e5, $c1, $c0	; $9904: c1 e5 c1 c0	 Data
			.byte $c1, $81, $77, $04	; $9908: c1 81 77 04	 Data
			.byte $99, $81, $70, $20	; $990c: 99 81 70 20	 Data
			.byte $99, $c1, $c0, $c1	; $9910: 99 c1 c0 c1	 Data
			.byte $c0, $c1, $c0, $e3	; $9914: c0 c1 c0 e3	 Data
			.byte $c0, $c0, $c0, $c0	; $9918: c0 c0 c0 c0	 Data
			.byte $c0, $80, $01, $99	; $991c: c0 80 01 99	 Data
			.byte $c1, $c1, $c0, $c1	; $9920: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $c0, $e3	; $9924: c1 c1 c0 e3	 Data
			.byte $c0, $c0, $c0, $8d	; $9928: c0 c0 c0 8d	 Data
			.byte $77, $03, $c1, $e5	; $992c: 77 03 c1 e5	 Data
			.byte $c1, $c0, $c1, $c1	; $9930: c1 c0 c1 c1	 Data
			.byte $c1, $c0, $c0, $81	; $9934: c1 c0 c0 81	 Data
			.byte $77, $2e, $99, $c0	; $9938: 77 2e 99 c0	 Data
			.byte $e3, $c0, $c0, $00	; $993c: e3 c0 c0 00	 Data
			.byte $c0, $00, $c0, $c0	; $9940: c0 00 c0 c0	 Data
			.byte $c0, $00, $c0, $00	; $9944: c0 00 c0 00	 Data
			.byte $c0, $c0, $c0, $c0	; $9948: c0 c0 c0 c0	 Data
			.byte $8d, $77, $0f, $c1	; $994c: 8d 77 0f c1	 Data
			.byte $e5, $c1, $c0, $c1	; $9950: e5 c1 c0 c1	 Data
			.byte $81, $77, $4f, $99	; $9954: 81 77 4f 99	 Data
			.byte $c0, $00, $e3, $c0	; $9958: c0 00 e3 c0	 Data
			.byte $c0, $00, $c0, $00	; $995c: c0 00 c0 00	 Data
			.byte $8d, $77, $0e, $c1	; $9960: 8d 77 0e c1	 Data
			.byte $e5, $c1, $c0, $c1	; $9964: e5 c1 c0 c1	 Data
			.byte $81, $77, $63, $99	; $9968: 81 77 63 99	 Data
			.byte $c0, $c0, $c0, $c0	; $996c: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $e3	; $9970: c0 c0 c0 e3	 Data
			.byte $c0, $c0, $c0, $8d	; $9974: c0 c0 c0 8d	 Data
			.byte $77, $04, $c1, $e5	; $9978: 77 04 c1 e5	 Data
			.byte $c0, $c0, $c1, $c0	; $997c: c0 c0 c1 c0	 Data
			.byte $c1, $c1, $c0, $c1	; $9980: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $c0, $81	; $9984: c1 c0 c0 81	 Data
			.byte $77, $7a, $99, $c0	; $9988: 77 7a 99 c0	 Data
			.byte $e8, $00, $c0, $e3	; $998c: e8 00 c0 e3	 Data
			.byte $00, $c0, $c0, $c0	; $9990: 00 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $80	; $9994: c0 c0 c0 80	 Data
			.byte $fe, $98, $04, $fe	; $9998: fe 98 04 fe	 Data
			.byte $fe, $04, $00, $01	; $999c: fe 04 00 01	 Data
			.byte $be, $01, $42, $00	; $99a0: be 01 42 00	 Data
			.byte $80, $00, $c6, $99	; $99a4: 80 00 c6 99	 Data
			.byte $01, $01, $3f, $02	; $99a8: 01 01 3f 02	 Data
			.byte $40, $00, $80, $01	; $99ac: 40 00 80 01	 Data
			.byte $39, $9a, $02, $01	; $99b0: 39 9a 02 01	 Data
			.byte $b7, $04, $40, $0c	; $99b4: b7 04 40 0c	 Data
			.byte $80, $02, $25, $9b	; $99b8: 80 02 25 9b	 Data
			.byte $03, $02, $3b, $04	; $99bc: 03 02 3b 04	 Data
			.byte $40, $00, $80, $03	; $99c0: 40 00 80 03	 Data
			.byte $98, $9b, $8d, $70	; $99c4: 98 9b 8d 70	 Data
			.byte $01, $29, $eb, $2e	; $99c8: 01 29 eb 2e	 Data
			.byte $ea, $30, $e3, $35	; $99cc: ea 30 e3 35	 Data
			.byte $30, $ed, $00, $e5	; $99d0: 30 ed 00 e5	 Data
			.byte $2e, $e3, $30, $31	; $99d4: 2e e3 30 31	 Data
			.byte $e8, $00, $e5, $30	; $99d8: e8 00 e5 30	 Data
			.byte $e3, $2e, $30, $e8	; $99dc: e3 2e 30 e8	 Data
			.byte $2c, $29, $ee, $29	; $99e0: 2c 29 ee 29	 Data
			.byte $eb, $2e, $ea, $30	; $99e4: eb 2e ea 30	 Data
			.byte $e3, $31, $35, $ee	; $99e8: e3 31 35 ee	 Data
			.byte $33, $e8, $00, $e5	; $99ec: 33 e8 00 e5	 Data
			.byte $31, $e3, $30, $2e	; $99f0: 31 e3 30 2e	 Data
			.byte $e8, $2c, $2e, $ee	; $99f4: e8 2c 2e ee	 Data
			.byte $81, $70, $34, $9a	; $99f8: 81 70 34 9a	 Data
			.byte $00, $e8, $2e, $e3	; $99fc: 00 e8 2e e3	 Data
			.byte $31, $2e, $31, $2e	; $9a00: 31 2e 31 2e	 Data
			.byte $ea, $35, $e5, $33	; $9a04: ea 35 e5 33	 Data
			.byte $ea, $30, $e5, $2c	; $9a08: ea 30 e5 2c	 Data
			.byte $eb, $2a, $ea, $29	; $9a0c: eb 2a ea 29	 Data
			.byte $e5, $27, $e8, $25	; $9a10: e5 27 e8 25	 Data
			.byte $29, $ee, $00, $e8	; $9a14: 29 ee 00 e8	 Data
			.byte $2e, $e3, $31, $2e	; $9a18: 2e e3 31 2e	 Data
			.byte $31, $2e, $ea, $35	; $9a1c: 31 2e ea 35	 Data
			.byte $e5, $33, $ea, $35	; $9a20: e5 33 ea 35	 Data
			.byte $e5, $36, $eb, $36	; $9a24: e5 36 eb 36	 Data
			.byte $e8, $34, $39, $37	; $9a28: e8 34 39 37	 Data
			.byte $36, $eb, $34, $89	; $9a2c: 36 eb 34 89	 Data
			.byte $01, $80, $c9, $99	; $9a30: 01 80 c9 99	 Data
			.byte $89, $ff, $80, $c6	; $9a34: 89 ff 80 c6	 Data
			.byte $99, $8d, $70, $01	; $9a38: 99 8d 70 01	 Data
			.byte $2e, $e3, $30, $35	; $9a3c: 2e e3 30 35	 Data
			.byte $30, $35, $ed, $2e	; $9a40: 30 35 ed 2e	 Data
			.byte $e3, $30, $35, $30	; $9a44: e3 30 35 30	 Data
			.byte $35, $ed, $2a, $e3	; $9a48: 35 ed 2a e3	 Data
			.byte $2c, $31, $2c, $31	; $9a4c: 2c 31 2c 31	 Data
			.byte $e8, $29, $e3, $2e	; $9a50: e8 29 e3 2e	 Data
			.byte $30, $2e, $35, $e8	; $9a54: 30 2e 35 e8	 Data
			.byte $29, $e3, $2e, $30	; $9a58: 29 e3 2e 30	 Data
			.byte $29, $2e, $30, $35	; $9a5c: 29 2e 30 35	 Data
			.byte $30, $30, $35, $3a	; $9a60: 30 30 35 3a	 Data
			.byte $35, $3a, $3c, $35	; $9a64: 35 3a 3c 35	 Data
			.byte $30, $2e, $30, $35	; $9a68: 30 2e 30 35	 Data
			.byte $30, $35, $ed, $2a	; $9a6c: 30 35 ed 2a	 Data
			.byte $e3, $2c, $31, $2c	; $9a70: e3 2c 31 2c	 Data
			.byte $31, $ed, $29, $e3	; $9a74: 31 ed 29 e3	 Data
			.byte $2e, $30, $29, $2e	; $9a78: 2e 30 29 2e	 Data
			.byte $30, $35, $30, $30	; $9a7c: 30 35 30 30	 Data
			.byte $35, $3a, $35, $3a	; $9a80: 35 3a 35 3a	 Data
			.byte $3c, $35, $30, $2e	; $9a84: 3c 35 30 2e	 Data
			.byte $30, $35, $30, $35	; $9a88: 30 35 30 35	 Data
			.byte $30, $2e, $30, $31	; $9a8c: 30 2e 30 31	 Data
			.byte $35, $30, $35, $2e	; $9a90: 35 30 35 2e	 Data
			.byte $31, $29, $31, $81	; $9a94: 31 29 31 81	 Data
			.byte $70, $20, $9b, $2a	; $9a98: 70 20 9b 2a	 Data
			.byte $31, $30, $2e, $2a	; $9a9c: 31 30 2e 2a	 Data
			.byte $31, $30, $2e, $2a	; $9aa0: 31 30 2e 2a	 Data
			.byte $31, $30, $2e, $2a	; $9aa4: 31 30 2e 2a	 Data
			.byte $31, $30, $2e, $29	; $9aa8: 31 30 2e 29	 Data
			.byte $30, $2e, $2c, $29	; $9aac: 30 2e 2c 29	 Data
			.byte $30, $2e, $2c, $29	; $9ab0: 30 2e 2c 29	 Data
			.byte $30, $2e, $2c, $29	; $9ab4: 30 2e 2c 29	 Data
			.byte $30, $2e, $2c, $27	; $9ab8: 30 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $27	; $9abc: 2f 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $27	; $9ac0: 2f 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $27	; $9ac4: 2f 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $2e	; $9ac8: 2f 2e 2c 2e	 Data
			.byte $29, $30, $29, $35	; $9acc: 29 30 29 35	 Data
			.byte $30, $3a, $35, $35	; $9ad0: 30 3a 35 35	 Data
			.byte $30, $35, $2e, $30	; $9ad4: 30 35 2e 30	 Data
			.byte $29, $2e, $29, $2a	; $9ad8: 29 2e 29 2a	 Data
			.byte $31, $30, $2e, $2a	; $9adc: 31 30 2e 2a	 Data
			.byte $31, $30, $2e, $2a	; $9ae0: 31 30 2e 2a	 Data
			.byte $31, $30, $2e, $2a	; $9ae4: 31 30 2e 2a	 Data
			.byte $31, $30, $2e, $27	; $9ae8: 31 30 2e 27	 Data
			.byte $2f, $2e, $2c, $27	; $9aec: 2f 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $27	; $9af0: 2f 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $27	; $9af4: 2f 2e 2c 27	 Data
			.byte $2f, $2e, $2c, $26	; $9af8: 2f 2e 2c 26	 Data
			.byte $2d, $2b, $2a, $26	; $9afc: 2d 2b 2a 26	 Data
			.byte $2d, $2b, $2a, $26	; $9b00: 2d 2b 2a 26	 Data
			.byte $2d, $2b, $2a, $26	; $9b04: 2d 2b 2a 26	 Data
			.byte $2d, $2b, $2a, $31	; $9b08: 2d 2b 2a 31	 Data
			.byte $2a, $2c, $2a, $25	; $9b0c: 2a 2c 2a 25	 Data
			.byte $2c, $2a, $2c, $31	; $9b10: 2c 2a 2c 31	 Data
			.byte $36, $2c, $36, $31	; $9b14: 36 2c 36 31	 Data
			.byte $2c, $2e, $2a, $89	; $9b18: 2c 2e 2a 89	 Data
			.byte $01, $80, $3c, $9a	; $9b1c: 01 80 3c 9a	 Data
			.byte $89, $ff, $80, $39	; $9b20: 89 ff 80 39	 Data
			.byte $9a, $8d, $70, $01	; $9b24: 9a 8d 70 01	 Data
			.byte $22, $e5, $22, $22	; $9b28: 22 e5 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b2c: 1d 22 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b30: 1d 22 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b34: 1d 22 22 22	 Data
			.byte $20, $1e, $1e, $1e	; $9b38: 20 1e 1e 1e	 Data
			.byte $19, $1d, $1d, $1d	; $9b3c: 19 1d 1d 1d	 Data
			.byte $18, $22, $22, $22	; $9b40: 18 22 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b44: 1d 22 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b48: 1d 22 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b4c: 1d 22 22 22	 Data
			.byte $20, $1e, $1e, $1e	; $9b50: 20 1e 1e 1e	 Data
			.byte $19, $1e, $1e, $1e	; $9b54: 19 1e 1e 1e	 Data
			.byte $19, $1d, $1d, $1d	; $9b58: 19 1d 1d 1d	 Data
			.byte $18, $1e, $1e, $1e	; $9b5c: 18 1e 1e 1e	 Data
			.byte $19, $22, $22, $22	; $9b60: 19 22 22 22	 Data
			.byte $1d, $22, $22, $22	; $9b64: 1d 22 22 22	 Data
			.byte $20, $81, $70, $93	; $9b68: 20 81 70 93	 Data
			.byte $9b, $1e, $e8, $19	; $9b6c: 9b 1e e8 19	 Data
			.byte $1e, $19, $1d, $18	; $9b70: 1e 19 1d 18	 Data
			.byte $1d, $18, $17, $1e	; $9b74: 1d 18 17 1e	 Data
			.byte $17, $1e, $1d, $18	; $9b78: 17 1e 1d 18	 Data
			.byte $1d, $18, $1e, $19	; $9b7c: 1d 18 1e 19	 Data
			.byte $1e, $19, $17, $1e	; $9b80: 1e 19 17 1e	 Data
			.byte $17, $1e, $1a, $15	; $9b84: 17 1e 1a 15	 Data
			.byte $1a, $15, $1e, $19	; $9b88: 1a 15 1e 19	 Data
			.byte $1e, $19, $89, $01	; $9b8c: 1e 19 89 01	 Data
			.byte $80, $28, $9b, $89	; $9b90: 80 28 9b 89	 Data
			.byte $ff, $80, $25, $9b	; $9b94: ff 80 25 9b	 Data
			.byte $8d, $70, $08, $c0	; $9b98: 8d 70 08 c0	 Data
			.byte $e5, $c0, $e3, $c0	; $9b9c: e5 c0 e3 c0	 Data
			.byte $c0, $e5, $c0, $e3	; $9ba0: c0 e5 c0 e3	 Data
			.byte $c0, $c0, $e5, $c0	; $9ba4: c0 c0 e5 c0	 Data
			.byte $e3, $c0, $c0, $e5	; $9ba8: e3 c0 c0 e5	 Data
			.byte $c0, $e3, $c0, $81	; $9bac: c0 e3 c0 81	 Data
			.byte $70, $9b, $9b, $8d	; $9bb0: 70 9b 9b 8d	 Data
			.byte $70, $03, $c1, $e5	; $9bb4: 70 03 c1 e5	 Data
			.byte $c1, $c0, $c1, $c1	; $9bb8: c1 c0 c1 c1	 Data
			.byte $c1, $c1, $c1, $81	; $9bbc: c1 c1 c1 81	 Data
			.byte $70, $b6, $9b, $c0	; $9bc0: 70 b6 9b c0	 Data
			.byte $e3, $c0, $c0, $e5	; $9bc4: e3 c0 c0 e5	 Data
			.byte $c0, $e3, $c0, $c0	; $9bc8: c0 e3 c0 c0	 Data
			.byte $e5, $c0, $e3, $c0	; $9bcc: e5 c0 e3 c0	 Data
			.byte $c0, $e5, $c0, $e3	; $9bd0: c0 e5 c0 e3	 Data
			.byte $c0, $c0, $e5, $8d	; $9bd4: c0 c0 e5 8d	 Data
			.byte $70, $03, $c1, $e5	; $9bd8: 70 03 c1 e5	 Data
			.byte $c1, $c0, $c1, $c1	; $9bdc: c1 c0 c1 c1	 Data
			.byte $c1, $c1, $c1, $81	; $9be0: c1 c1 c1 81	 Data
			.byte $70, $da, $9b, $00	; $9be4: 70 da 9b 00	 Data
			.byte $e5, $c0, $e3, $c0	; $9be8: e5 c0 e3 c0	 Data
			.byte $c0, $e8, $00, $e5	; $9bec: c0 e8 00 e5	 Data
			.byte $c0, $e3, $c0, $00	; $9bf0: c0 e3 c0 00	 Data
			.byte $e5, $c0, $e3, $c0	; $9bf4: e5 c0 e3 c0	 Data
			.byte $8d, $70, $08, $c0	; $9bf8: 8d 70 08 c0	 Data
			.byte $e5, $c0, $e3, $c0	; $9bfc: e5 c0 e3 c0	 Data
			.byte $c0, $e5, $c0, $e3	; $9c00: c0 e5 c0 e3	 Data
			.byte $c0, $c0, $e5, $c0	; $9c04: c0 c0 e5 c0	 Data
			.byte $e3, $c0, $c0, $e5	; $9c08: e3 c0 c0 e5	 Data
			.byte $c0, $e3, $c0, $81	; $9c0c: c0 e3 c0 81	 Data
			.byte $70, $fb, $9b, $80	; $9c10: 70 fb 9b 80	 Data
			.byte $98, $9b, $04, $00	; $9c14: 98 9b 04 00	 Data
			.byte $01, $7f, $01, $42	; $9c18: 01 7f 01 42	 Data
			.byte $03, $80, $00, $3f	; $9c1c: 03 80 00 3f	 Data
			.byte $9c, $01, $01, $bf	; $9c20: 9c 01 01 bf	 Data
			.byte $01, $40, $03, $80	; $9c24: 01 40 03 80	 Data
			.byte $01, $84, $9c, $02	; $9c28: 01 84 9c 02	 Data
			.byte $01, $bf, $02, $41	; $9c2c: 01 bf 02 41	 Data
			.byte $0f, $80, $02, $dd	; $9c30: 0f 80 02 dd	 Data
			.byte $9c, $03, $02, $3d	; $9c34: 9c 03 02 3d	 Data
			.byte $02, $40, $00, $80	; $9c38: 02 40 00 80	 Data
			.byte $03, $53, $9d, $2e	; $9c3c: 03 53 9d 2e	 Data
			.byte $e8, $31, $30, $e0	; $9c40: e8 31 30 e0	 Data
			.byte $48, $31, $e8, $33	; $9c44: 48 31 e8 33	 Data
			.byte $2c, $2e, $e0, $48	; $9c48: 2c 2e e0 48	 Data
			.byte $2e, $e8, $31, $30	; $9c4c: 2e e8 31 30	 Data
			.byte $e0, $48, $31, $e8	; $9c50: e0 48 31 e8	 Data
			.byte $33, $36, $34, $e0	; $9c54: 33 36 34 e0	 Data
			.byte $60, $2e, $e0, $48	; $9c58: 60 2e e0 48	 Data
			.byte $31, $e8, $33, $30	; $9c5c: 31 e8 33 30	 Data
			.byte $ee, $2c, $2e, $e0	; $9c60: ee 2c 2e e0	 Data
			.byte $48, $31, $e8, $33	; $9c64: 48 31 e8 33	 Data
			.byte $30, $e0, $48, $00	; $9c68: 30 e0 48 00	 Data
			.byte $e8, $2c, $e5, $2e	; $9c6c: e8 2c e5 2e	 Data
			.byte $2f, $e8, $2e, $2c	; $9c70: 2f e8 2e 2c	 Data
			.byte $2a, $e5, $34, $e0	; $9c74: 2a e5 34 e0	 Data
			.byte $0c, $33, $31, $ea	; $9c78: 0c 33 31 ea	 Data
			.byte $2f, $e8, $2e, $ee	; $9c7c: 2f e8 2e ee	 Data
			.byte $27, $80, $3f, $9c	; $9c80: 27 80 3f 9c	 Data
			.byte $2b, $e8, $2e, $2d	; $9c84: 2b e8 2e 2d	 Data
			.byte $e0, $48, $2e, $e8	; $9c88: e0 48 2e e8	 Data
			.byte $30, $29, $2b, $e0	; $9c8c: 30 29 2b e0	 Data
			.byte $48, $2b, $e8, $2e	; $9c90: 48 2b e8 2e	 Data
			.byte $2d, $e0, $48, $2e	; $9c94: 2d e0 48 2e	 Data
			.byte $e8, $30, $31, $2d	; $9c98: e8 30 31 2d	 Data
			.byte $e0, $60, $2a, $e0	; $9c9c: e0 60 2a e0	 Data
			.byte $48, $2e, $e8, $30	; $9ca0: 48 2e e8 30	 Data
			.byte $2c, $ee, $27, $2a	; $9ca4: 2c ee 27 2a	 Data
			.byte $e0, $48, $2e, $e8	; $9ca8: e0 48 2e e8	 Data
			.byte $30, $2c, $e0, $48	; $9cac: 30 2c e0 48	 Data
			.byte $00, $eb, $8a, $ff	; $9cb0: 00 eb 8a ff	 Data
			.byte $88, $02, $8d, $70	; $9cb4: 88 02 8d 70	 Data
			.byte $08, $36, $e3, $2a	; $9cb8: 08 36 e3 2a	 Data
			.byte $2f, $2a, $81, $70	; $9cbc: 2f 2a 81 70	 Data
			.byte $b9, $9c, $8d, $70	; $9cc0: b9 9c 8d 70	 Data
			.byte $08, $27, $e3, $27	; $9cc4: 08 27 e3 27	 Data
			.byte $81, $70, $c5, $9c	; $9cc8: 81 70 c5 9c	 Data
			.byte $8d, $70, $08, $33	; $9ccc: 8d 70 08 33	 Data
			.byte $e3, $33, $81, $70	; $9cd0: e3 33 81 70	 Data
			.byte $cf, $9c, $8a, $01	; $9cd4: cf 9c 8a 01	 Data
			.byte $88, $01, $80, $84	; $9cd8: 88 01 80 84	 Data
			.byte $9c, $88, $01, $8a	; $9cdc: 9c 88 01 8a	 Data
			.byte $ff, $9d, $02, $1b	; $9ce0: ff 9d 02 1b	 Data
			.byte $e0, $60, $1b, $eb	; $9ce4: e0 60 1b eb	 Data
			.byte $1b, $e8, $1b, $e0	; $9ce8: 1b e8 1b e0	 Data
			.byte $48, $1b, $e0, $60	; $9cec: 48 1b e0 60	 Data
			.byte $1b, $eb, $1b, $e8	; $9cf0: 1b eb 1b e8	 Data
			.byte $1b, $eb, $1b, $ea	; $9cf4: 1b eb 1b ea	 Data
			.byte $9d, $04, $1b, $e5	; $9cf8: 9d 04 1b e5	 Data
			.byte $1b, $e8, $1b, $00	; $9cfc: 1b e8 1b 00	 Data
			.byte $e5, $1b, $1b, $1b	; $9d00: e5 1b 1b 1b	 Data
			.byte $88, $02, $8a, $01	; $9d04: 88 02 8a 01	 Data
			.byte $8d, $70, $02, $1b	; $9d08: 8d 70 02 1b	 Data
			.byte $e5, $1b, $1b, $1b	; $9d0c: e5 1b 1b 1b	 Data
			.byte $1b, $1b, $1b, $1b	; $9d10: 1b 1b 1b 1b	 Data
			.byte $1b, $1b, $1b, $1b	; $9d14: 1b 1b 1b 1b	 Data
			.byte $1b, $1b, $1b, $1b	; $9d18: 1b 1b 1b 1b	 Data
			.byte $20, $20, $20, $20	; $9d1c: 20 20 20 20	 Data
			.byte $20, $20, $20, $20	; $9d20: 20 20 20 20	 Data
			.byte $20, $20, $20, $20	; $9d24: 20 20 20 20	 Data
			.byte $20, $20, $1b, $1e	; $9d28: 20 20 1b 1e	 Data
			.byte $81, $70, $0b, $9d	; $9d2c: 81 70 0b 9d	 Data
			.byte $8d, $70, $02, $1e	; $9d30: 8d 70 02 1e	 Data
			.byte $e5, $2a, $1e, $2a	; $9d34: e5 2a 1e 2a	 Data
			.byte $1e, $2a, $1e, $2a	; $9d38: 1e 2a 1e 2a	 Data
			.byte $81, $70, $33, $9d	; $9d3c: 81 70 33 9d	 Data
			.byte $8d, $70, $02, $1b	; $9d40: 8d 70 02 1b	 Data
			.byte $e5, $27, $1b, $27	; $9d44: e5 27 1b 27	 Data
			.byte $1b, $27, $1b, $27	; $9d48: 1b 27 1b 27	 Data
			.byte $81, $70, $43, $9d	; $9d4c: 81 70 43 9d	 Data
			.byte $80, $dd, $9c, $8d	; $9d50: 80 dd 9c 8d	 Data
			.byte $70, $01, $c0, $e5	; $9d54: 70 01 c0 e5	 Data
			.byte $8a, $fc, $c0, $8a	; $9d58: 8a fc c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9d5c: 04 c0 8a fc	 Data
			.byte $c0, $8a, $04, $c0	; $9d60: c0 8a 04 c0	 Data
			.byte $8a, $fc, $c0, $c0	; $9d64: 8a fc c0 c0	 Data
			.byte $c0, $8a, $04, $c0	; $9d68: c0 8a 04 c0	 Data
			.byte $8a, $fc, $c0, $c0	; $9d6c: 8a fc c0 c0	 Data
			.byte $8a, $04, $c0, $c0	; $9d70: 8a 04 c0 c0	 Data
			.byte $8a, $fc, $c0, $8a	; $9d74: 8a fc c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9d78: 04 c0 8a fc	 Data
			.byte $c0, $81, $70, $b0	; $9d7c: c0 81 70 b0	 Data
			.byte $9d, $8a, $04, $c0	; $9d80: 9d 8a 04 c0	 Data
			.byte $8a, $fc, $c0, $c0	; $9d84: 8a fc c0 c0	 Data
			.byte $8a, $04, $c0, $8a	; $9d88: 8a 04 c0 8a	 Data
			.byte $fc, $c0, $c0, $8a	; $9d8c: fc c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9d90: 04 c0 8a fc	 Data
			.byte $c0, $c0, $c0, $8a	; $9d94: c0 c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9d98: 04 c0 8a fc	 Data
			.byte $c0, $c0, $8a, $04	; $9d9c: c0 c0 8a 04	 Data
			.byte $c0, $c0, $8a, $fc	; $9da0: c0 c0 8a fc	 Data
			.byte $c0, $8a, $04, $c0	; $9da4: c0 8a 04 c0	 Data
			.byte $8a, $fc, $c0, $8a	; $9da8: 8a fc c0 8a	 Data
			.byte $04, $80, $56, $9d	; $9dac: 04 80 56 9d	 Data
			.byte $8a, $04, $c0, $8a	; $9db0: 8a 04 c0 8a	 Data
			.byte $fc, $c0, $c0, $8a	; $9db4: fc c0 c0 8a	 Data
			.byte $04, $c0, $c0, $8a	; $9db8: 04 c0 c0 8a	 Data
			.byte $fc, $c0, $8a, $04	; $9dbc: fc c0 8a 04	 Data
			.byte $c0, $8a, $fc, $c0	; $9dc0: c0 8a fc c0	 Data
			.byte $c0, $c0, $8a, $04	; $9dc4: c0 c0 8a 04	 Data
			.byte $c0, $8a, $fc, $c0	; $9dc8: c0 8a fc c0	 Data
			.byte $c0, $8a, $04, $c0	; $9dcc: c0 8a 04 c0	 Data
			.byte $c0, $8a, $fc, $c0	; $9dd0: c0 8a fc c0	 Data
			.byte $8a, $04, $c0, $8a	; $9dd4: 8a 04 c0 8a	 Data
			.byte $fc, $c0, $00, $8a	; $9dd8: fc c0 00 8a	 Data
			.byte $04, $c0, $c0, $e3	; $9ddc: 04 c0 c0 e3	 Data
			.byte $c0, $c0, $c0, $8d	; $9de0: c0 c0 c0 8d	 Data
			.byte $70, $0b, $8a, $fc	; $9de4: 70 0b 8a fc	 Data
			.byte $c0, $e3, $c0, $c0	; $9de8: c0 e3 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $9dec: c0 c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9df0: 04 c0 8a fc	 Data
			.byte $c0, $c0, $c0, $8a	; $9df4: c0 c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9df8: 04 c0 8a fc	 Data
			.byte $c0, $c0, $c0, $8a	; $9dfc: c0 c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9e00: 04 c0 8a fc	 Data
			.byte $c0, $8a, $04, $81	; $9e04: c0 8a 04 81	 Data
			.byte $70, $e6, $9d, $8a	; $9e08: 70 e6 9d 8a	 Data
			.byte $fc, $c0, $c0, $c0	; $9e0c: fc c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $9e10: c0 c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9e14: 04 c0 8a fc	 Data
			.byte $c0, $c0, $c0, $8a	; $9e18: c0 c0 c0 8a	 Data
			.byte $04, $c0, $8a, $fc	; $9e1c: 04 c0 8a fc	 Data
			.byte $c0, $8a, $04, $c0	; $9e20: c0 8a 04 c0	 Data
			.byte $c0, $c0, $c0, $80	; $9e24: c0 c0 c0 80	 Data
			.byte $53, $9d, $04, $00	; $9e28: 53 9d 04 00	 Data
			.byte $01, $7f, $09, $41	; $9e2c: 01 7f 09 41	 Data
			.byte $00, $84, $00, $53	; $9e30: 00 84 00 53	 Data
			.byte $9e, $01, $01, $7d	; $9e34: 9e 01 01 7d	 Data
			.byte $03, $40, $00, $84	; $9e38: 03 40 00 84	 Data
			.byte $01, $9e, $9e, $02	; $9e3c: 01 9e 9e 02	 Data
			.byte $01, $bf, $02, $40	; $9e40: 01 bf 02 40	 Data
			.byte $0c, $84, $02, $63	; $9e44: 0c 84 02 63	 Data
			.byte $9f, $03, $02, $3d	; $9e48: 9f 03 02 3d	 Data
			.byte $04, $40, $00, $84	; $9e4c: 04 40 00 84	 Data
			.byte $03, $bb, $9f, $8d	; $9e50: 03 bb 9f 8d	 Data
			.byte $70, $01, $35, $e0	; $9e54: 70 01 35 e0	 Data
			.byte $2a, $37, $e0, $36	; $9e58: 2a 37 e0 36	 Data
			.byte $38, $e0, $2a, $37	; $9e5c: 38 e0 2a 37	 Data
			.byte $81, $70, $6d, $9e	; $9e60: 81 70 6d 9e	 Data
			.byte $35, $e5, $33, $35	; $9e64: 35 e5 33 35	 Data
			.byte $e0, $60, $80, $56	; $9e68: e0 60 80 56	 Data
			.byte $9e, $38, $e5, $3a	; $9e6c: 9e 38 e5 3a	 Data
			.byte $3c, $e0, $54, $38	; $9e70: 3c e0 54 38	 Data
			.byte $e5, $3a, $3c, $e0	; $9e74: e5 3a 3c e0	 Data
			.byte $60, $3c, $e0, $1e	; $9e78: 60 3c e0 1e	 Data
			.byte $3a, $e5, $38, $3a	; $9e7c: 3a e5 38 3a	 Data
			.byte $e0, $36, $3a, $e0	; $9e80: e0 36 3a e0	 Data
			.byte $1e, $38, $e5, $37	; $9e84: 1e 38 e5 37	 Data
			.byte $38, $e0, $36, $36	; $9e88: 38 e0 36 36	 Data
			.byte $e6, $31, $2e, $31	; $9e8c: e6 31 2e 31	 Data
			.byte $36, $38, $3a, $36	; $9e90: 36 38 3a 36	 Data
			.byte $31, $36, $3a, $3d	; $9e94: 31 36 3a 3d	 Data
			.byte $3c, $e0, $60, $80	; $9e98: 3c e0 60 80	 Data
			.byte $53, $9e, $2e, $e5	; $9e9c: 53 9e 2e e5	 Data
			.byte $31, $2e, $31, $2e	; $9ea0: 31 2e 31 2e	 Data
			.byte $31, $2e, $31, $30	; $9ea4: 31 2e 31 30	 Data
			.byte $33, $30, $33, $30	; $9ea8: 33 30 33 30	 Data
			.byte $33, $30, $33, $31	; $9eac: 33 30 33 31	 Data
			.byte $35, $31, $35, $31	; $9eb0: 35 31 35 31	 Data
			.byte $35, $31, $33, $30	; $9eb4: 35 31 33 30	 Data
			.byte $33, $30, $33, $30	; $9eb8: 33 30 33 30	 Data
			.byte $33, $31, $30, $8d	; $9ebc: 33 31 30 8d	 Data
			.byte $70, $02, $31, $e3	; $9ec0: 70 02 31 e3	 Data
			.byte $35, $33, $37, $35	; $9ec4: 35 33 37 35	 Data
			.byte $38, $37, $3a, $35	; $9ec8: 38 37 3a 35	 Data
			.byte $38, $33, $37, $31	; $9ecc: 38 33 37 31	 Data
			.byte $35, $30, $35, $81	; $9ed0: 35 30 35 81	 Data
			.byte $70, $c2, $9e, $2e	; $9ed4: 70 c2 9e 2e	 Data
			.byte $e5, $31, $2e, $31	; $9ed8: e5 31 2e 31	 Data
			.byte $2e, $31, $2e, $31	; $9edc: 2e 31 2e 31	 Data
			.byte $30, $33, $30, $33	; $9ee0: 30 33 30 33	 Data
			.byte $30, $33, $30, $33	; $9ee4: 30 33 30 33	 Data
			.byte $31, $35, $31, $35	; $9ee8: 31 35 31 35	 Data
			.byte $31, $35, $31, $35	; $9eec: 31 35 31 35	 Data
			.byte $30, $33, $30, $33	; $9ef0: 30 33 30 33	 Data
			.byte $30, $33, $35, $37	; $9ef4: 30 33 35 37	 Data
			.byte $8d, $70, $04, $31	; $9ef8: 8d 70 04 31	 Data
			.byte $e3, $35, $33, $37	; $9efc: e3 35 33 37	 Data
			.byte $35, $38, $37, $3a	; $9f00: 35 38 37 3a	 Data
			.byte $35, $38, $33, $37	; $9f04: 35 38 33 37	 Data
			.byte $31, $35, $30, $33	; $9f08: 31 35 30 33	 Data
			.byte $81, $70, $fb, $9e	; $9f0c: 81 70 fb 9e	 Data
			.byte $35, $e5, $38, $35	; $9f10: 35 e5 38 35	 Data
			.byte $38, $35, $37, $35	; $9f14: 38 35 37 35	 Data
			.byte $37, $33, $37, $33	; $9f18: 37 33 37 33	 Data
			.byte $37, $33, $37, $33	; $9f1c: 37 33 37 33	 Data
			.byte $37, $33, $37, $33	; $9f20: 37 33 37 33	 Data
			.byte $37, $33, $35, $33	; $9f24: 37 33 35 33	 Data
			.byte $35, $30, $35, $31	; $9f28: 35 30 35 31	 Data
			.byte $35, $30, $35, $31	; $9f2c: 35 30 35 31	 Data
			.byte $35, $8d, $70, $02	; $9f30: 35 8d 70 02	 Data
			.byte $2a, $e5, $31, $2e	; $9f34: 2a e5 31 2e	 Data
			.byte $36, $31, $2a, $2e	; $9f38: 36 31 2a 2e	 Data
			.byte $25, $81, $70, $34	; $9f3c: 25 81 70 34	 Data
			.byte $9f, $2e, $e3, $30	; $9f40: 9f 2e e3 30	 Data
			.byte $35, $e8, $2e, $e3	; $9f44: 35 e8 2e e3	 Data
			.byte $30, $29, $2e, $30	; $9f48: 30 29 2e 30	 Data
			.byte $e8, $29, $e3, $2e	; $9f4c: e8 29 e3 2e	 Data
			.byte $30, $29, $2e, $30	; $9f50: 30 29 2e 30	 Data
			.byte $29, $2e, $30, $35	; $9f54: 29 2e 30 35	 Data
			.byte $2e, $30, $35, $3a	; $9f58: 2e 30 35 3a	 Data
			.byte $30, $35, $3a, $3c	; $9f5c: 30 35 3a 3c	 Data
			.byte $80, $9e, $9e, $8d	; $9f60: 80 9e 9e 8d	 Data
			.byte $70, $0e, $22, $e5	; $9f64: 70 0e 22 e5	 Data
			.byte $22, $1d, $20, $22	; $9f68: 22 1d 20 22	 Data
			.byte $1d, $1f, $20, $81	; $9f6c: 1d 1f 20 81	 Data
			.byte $70, $66, $9f, $25	; $9f70: 70 66 9f 25	 Data
			.byte $25, $20, $25, $25	; $9f74: 25 20 25 25	 Data
			.byte $25, $20, $25, $27	; $9f78: 25 20 25 27	 Data
			.byte $27, $22, $27, $27	; $9f7c: 27 22 27 27	 Data
			.byte $22, $27, $24, $24	; $9f80: 22 27 24 24	 Data
			.byte $24, $1f, $24, $24	; $9f84: 24 1f 24 24	 Data
			.byte $1f, $24, $1d, $1d	; $9f88: 1f 24 1d 1d	 Data
			.byte $1d, $18, $1d, $1d	; $9f8c: 1d 18 1d 1d	 Data
			.byte $1d, $18, $1d, $8d	; $9f90: 1d 18 1d 8d	 Data
			.byte $70, $02, $1e, $e5	; $9f94: 70 02 1e e5	 Data
			.byte $1e, $19, $1e, $1e	; $9f98: 1e 19 1e 1e	 Data
			.byte $1e, $19, $1e, $81	; $9f9c: 1e 19 1e 81	 Data
			.byte $70, $96, $9f, $8d	; $9fa0: 70 96 9f 8d	 Data
			.byte $70, $02, $29, $e3	; $9fa4: 70 02 29 e3	 Data
			.byte $29, $24, $29, $00	; $9fa8: 29 24 29 00	 Data
			.byte $e8, $1d, $e3, $1d	; $9fac: e8 1d e3 1d	 Data
			.byte $18, $1d, $00, $e8	; $9fb0: 18 1d 00 e8	 Data
			.byte $81, $70, $a6, $9f	; $9fb4: 81 70 a6 9f	 Data
			.byte $80, $63, $9f, $8d	; $9fb8: 80 63 9f 8d	 Data
			.byte $70, $02, $00, $e8	; $9fbc: 70 02 00 e8	 Data
			.byte $c0, $00, $c0, $00	; $9fc0: c0 00 c0 00	 Data
			.byte $c0, $00, $c0, $00	; $9fc4: c0 00 c0 00	 Data
			.byte $c0, $00, $c0, $00	; $9fc8: c0 00 c0 00	 Data
			.byte $c0, $00, $c0, $00	; $9fcc: c0 00 c0 00	 Data
			.byte $e5, $c0, $e3, $c0	; $9fd0: e5 c0 e3 c0	 Data
			.byte $00, $e5, $c0, $e3	; $9fd4: 00 e5 c0 e3	 Data
			.byte $c0, $00, $c0, $c0	; $9fd8: c0 00 c0 c0	 Data
			.byte $c0, $00, $c0, $c0	; $9fdc: c0 00 c0 c0	 Data
			.byte $c0, $c0, $c0, $00	; $9fe0: c0 c0 c0 00	 Data
			.byte $e5, $c0, $e3, $c0	; $9fe4: e5 c0 e3 c0	 Data
			.byte $00, $e5, $c0, $c0	; $9fe8: 00 e5 c0 c0	 Data
			.byte $e3, $c0, $c0, $e5	; $9fec: e3 c0 c0 e5	 Data
			.byte $c0, $e3, $c0, $81	; $9ff0: c0 e3 c0 81	 Data
			.byte $70, $be, $9f, $00	; $9ff4: 70 be 9f 00	 Data
			.byte $e5, $c0, $e3, $c0	; $9ff8: e5 c0 e3 c0	 Data
			.byte $00, $e5, $c0, $e3	; $9ffc: 00 e5 c0 e3	 Data
			.byte $c0, $00, $c0, $c0	; $a000: c0 00 c0 c0	 Data
			.byte $c0, $00, $c0, $c0	; $a004: c0 00 c0 c0	 Data
			.byte $c0, $c0, $c0, $00	; $a008: c0 c0 c0 00	 Data
			.byte $e5, $c0, $e3, $c0	; $a00c: e5 c0 e3 c0	 Data
			.byte $00, $e5, $c0, $c0	; $a010: 00 e5 c0 c0	 Data
			.byte $e3, $c0, $c0, $e5	; $a014: e3 c0 c0 e5	 Data
			.byte $c0, $e3, $c0, $8d	; $a018: c0 e3 c0 8d	 Data
			.byte $70, $08, $00, $e8	; $a01c: 70 08 00 e8	 Data
			.byte $c0, $81, $70, $1e	; $a020: c0 81 70 1e	 Data
			.byte $a0, $00, $e5, $c0	; $a024: a0 00 e5 c0	 Data
			.byte $e3, $c0, $00, $e5	; $a028: e3 c0 00 e5	 Data
			.byte $c0, $e3, $c0, $00	; $a02c: c0 e3 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $a030: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $c0	; $a034: c0 c0 c0 c0	 Data
			.byte $c0, $00, $e5, $c0	; $a038: c0 00 e5 c0	 Data
			.byte $e3, $c0, $00, $e5	; $a03c: e3 c0 00 e5	 Data
			.byte $c0, $c0, $e3, $c0	; $a040: c0 c0 e3 c0	 Data
			.byte $c0, $e5, $c0, $e3	; $a044: c0 e5 c0 e3	 Data
			.byte $c0, $8d, $70, $04	; $a048: c0 8d 70 04	 Data
			.byte $00, $e8, $c0, $e3	; $a04c: 00 e8 c0 e3	 Data
			.byte $c0, $c0, $c0, $81	; $a050: c0 c0 c0 81	 Data
			.byte $70, $4c, $a0, $80	; $a054: 70 4c a0 80	 Data
			.byte $bb, $9f, $04, $00	; $a058: bb 9f 04 00	 Data
			.byte $01, $bf, $06, $40	; $a05c: 01 bf 06 40	 Data
			.byte $fd, $80, $00, $83	; $a060: fd 80 00 83	 Data
			.byte $a0, $01, $01, $7e	; $a064: a0 01 01 7e	 Data
			.byte $06, $41, $fd, $80	; $a068: 06 41 fd 80	 Data
			.byte $01, $15, $a1, $02	; $a06c: 01 15 a1 02	 Data
			.byte $01, $bf, $02, $40	; $a070: 01 bf 02 40	 Data
			.byte $15, $80, $02, $d7	; $a074: 15 80 02 d7	 Data
			.byte $a1, $03, $02, $3e	; $a078: a1 03 02 3e	 Data
			.byte $04, $40, $00, $80	; $a07c: 04 40 00 80	 Data
			.byte $03, $0e, $a2, $2c	; $a080: 03 0e a2 2c	 Data
			.byte $e4, $2e, $2f, $31	; $a084: e4 2e 2f 31	 Data
			.byte $e0, $48, $2c, $e4	; $a088: e0 48 2c e4	 Data
			.byte $2e, $2f, $31, $e8	; $a08c: 2e 2f 31 e8	 Data
			.byte $2f, $e0, $48, $31	; $a090: 2f e0 48 31	 Data
			.byte $e4, $33, $34, $36	; $a094: e4 33 34 36	 Data
			.byte $e0, $48, $31, $e4	; $a098: e0 48 31 e4	 Data
			.byte $33, $34, $36, $e8	; $a09c: 33 34 36 e8	 Data
			.byte $34, $e0, $60, $2e	; $a0a0: 34 e0 60 2e	 Data
			.byte $e8, $2a, $eb, $25	; $a0a4: e8 2a eb 25	 Data
			.byte $e8, $22, $25, $e5	; $a0a8: e8 22 25 e5	 Data
			.byte $2e, $e8, $2c, $e5	; $a0ac: 2e e8 2c e5	 Data
			.byte $2a, $e8, $2d, $28	; $a0b0: 2a e8 2d 28	 Data
			.byte $eb, $25, $e8, $21	; $a0b4: eb 25 e8 21	 Data
			.byte $25, $e5, $2d, $e8	; $a0b8: 25 e5 2d e8	 Data
			.byte $2c, $e5, $28, $e8	; $a0bc: 2c e5 28 e8	 Data
			.byte $2a, $27, $ed, $2f	; $a0c0: 2a 27 ed 2f	 Data
			.byte $e8, $2a, $ea, $2a	; $a0c4: e8 2a ea 2a	 Data
			.byte $e5, $2c, $2d, $2c	; $a0c8: e5 2c 2d 2c	 Data
			.byte $e8, $2e, $2f, $33	; $a0cc: e8 2e 2f 33	 Data
			.byte $e4, $31, $33, $31	; $a0d0: e4 31 33 31	 Data
			.byte $ee, $2e, $ed, $2f	; $a0d4: ee 2e ed 2f	 Data
			.byte $e5, $2c, $2e, $eb	; $a0d8: e5 2c 2e eb	 Data
			.byte $2a, $e8, $25, $28	; $a0dc: 2a e8 25 28	 Data
			.byte $eb, $2d, $ea, $34	; $a0e0: eb 2d ea 34	 Data
			.byte $e5, $31, $ee, $31	; $a0e4: e5 31 ee 31	 Data
			.byte $e8, $2f, $eb, $2a	; $a0e8: e8 2f eb 2a	 Data
			.byte $e4, $27, $2a, $2a	; $a0ec: e4 27 2a 2a	 Data
			.byte $ee, $2c, $e8, $30	; $a0f0: ee 2c e8 30	 Data
			.byte $33, $36, $e4, $33	; $a0f4: 33 36 e4 33	 Data
			.byte $36, $3a, $ee, $8a	; $a0f8: 36 3a ee 8a	 Data
			.byte $ff, $00, $88, $09	; $a0fc: ff 00 88 09	 Data
			.byte $31, $e5, $31, $ea	; $a100: 31 e5 31 ea	 Data
			.byte $00, $eb, $00, $ee	; $a104: 00 eb 00 ee	 Data
			.byte $31, $e5, $31, $ea	; $a108: 31 e5 31 ea	 Data
			.byte $8a, $01, $00, $eb	; $a10c: 8a 01 00 eb	 Data
			.byte $88, $06, $80, $83	; $a110: 88 06 80 83	 Data
			.byte $a0, $25, $e4, $27	; $a114: a0 25 e4 27	 Data
			.byte $28, $2a, $e0, $48	; $a118: 28 2a e0 48	 Data
			.byte $25, $e4, $27, $28	; $a11c: 25 e4 27 28	 Data
			.byte $2a, $e8, $28, $e0	; $a120: 2a e8 28 e0	 Data
			.byte $48, $2c, $e4, $2e	; $a124: 48 2c e4 2e	 Data
			.byte $2f, $31, $e0, $48	; $a128: 2f 31 e0 48	 Data
			.byte $2c, $e4, $2e, $2f	; $a12c: 2c e4 2e 2f	 Data
			.byte $31, $e8, $2f, $e0	; $a130: 31 e8 2f e0	 Data
			.byte $60, $8a, $fc, $a0	; $a134: 60 8a fc a0	 Data
			.byte $b0, $00, $e7, $2e	; $a138: b0 00 e7 2e	 Data
			.byte $e8, $2a, $eb, $25	; $a13c: e8 2a eb 25	 Data
			.byte $e8, $22, $25, $e5	; $a140: e8 22 25 e5	 Data
			.byte $2e, $e8, $2c, $e5	; $a144: 2e e8 2c e5	 Data
			.byte $2a, $e8, $2d, $28	; $a148: 2a e8 2d 28	 Data
			.byte $eb, $25, $e8, $21	; $a14c: eb 25 e8 21	 Data
			.byte $25, $e5, $2d, $e8	; $a150: 25 e5 2d e8	 Data
			.byte $2c, $e5, $28, $e8	; $a154: 2c e5 28 e8	 Data
			.byte $2a, $27, $ed, $2f	; $a158: 2a 27 ed 2f	 Data
			.byte $e8, $2a, $ea, $2a	; $a15c: e8 2a ea 2a	 Data
			.byte $e5, $2c, $2d, $2c	; $a160: e5 2c 2d 2c	 Data
			.byte $e8, $2e, $2f, $33	; $a164: e8 2e 2f 33	 Data
			.byte $e4, $31, $33, $31	; $a168: e4 31 33 31	 Data
			.byte $ed, $00, $e3, $88	; $a16c: ed 00 e3 88	 Data
			.byte $04, $83, $00, $8a	; $a170: 04 83 00 8a	 Data
			.byte $04, $a0, $30, $25	; $a174: 04 a0 30 25	 Data
			.byte $e5, $2a, $2e, $36	; $a178: e5 2a 2e 36	 Data
			.byte $25, $2a, $2e, $36	; $a17c: 25 2a 2e 36	 Data
			.byte $25, $2a, $2e, $2a	; $a180: 25 2a 2e 2a	 Data
			.byte $36, $2a, $31, $2e	; $a184: 36 2a 31 2e	 Data
			.byte $2d, $31, $34, $39	; $a188: 2d 31 34 39	 Data
			.byte $2d, $31, $34, $39	; $a18c: 2d 31 34 39	 Data
			.byte $2d, $31, $34, $31	; $a190: 2d 31 34 31	 Data
			.byte $39, $34, $31, $2d	; $a194: 39 34 31 2d	 Data
			.byte $2f, $33, $36, $3b	; $a198: 2f 33 36 3b	 Data
			.byte $2f, $33, $36, $3b	; $a19c: 2f 33 36 3b	 Data
			.byte $2f, $33, $36, $3b	; $a1a0: 2f 33 36 3b	 Data
			.byte $3f, $3b, $36, $2a	; $a1a4: 3f 3b 36 2a	 Data
			.byte $2c, $30, $33, $38	; $a1a8: 2c 30 33 38	 Data
			.byte $3c, $38, $33, $30	; $a1ac: 3c 38 33 30	 Data
			.byte $2c, $30, $33, $38	; $a1b0: 2c 30 33 38	 Data
			.byte $3f, $3c, $38, $33	; $a1b4: 3f 3c 38 33	 Data
			.byte $8a, $fc, $00, $ee	; $a1b8: 8a fc 00 ee	 Data
			.byte $88, $09, $2c, $e5	; $a1bc: 88 09 2c e5	 Data
			.byte $2c, $ea, $00, $eb	; $a1c0: 2c ea 00 eb	 Data
			.byte $00, $ee, $2c, $e5	; $a1c4: 00 ee 2c e5	 Data
			.byte $2c, $ea, $8a, $04	; $a1c8: 2c ea 8a 04	 Data
			.byte $00, $eb, $88, $06	; $a1cc: 00 eb 88 06	 Data
			.byte $83, $41, $a0, $70	; $a1d0: 83 41 a0 70	 Data
			.byte $80, $15, $a1, $8d	; $a1d4: 80 15 a1 8d	 Data
			.byte $70, $08, $19, $e5	; $a1d8: 70 08 19 e5	 Data
			.byte $14, $16, $17, $19	; $a1dc: 14 16 17 19	 Data
			.byte $14, $16, $17, $81	; $a1e0: 14 16 17 81	 Data
			.byte $70, $da, $a1, $8d	; $a1e4: 70 da a1 8d	 Data
			.byte $70, $10, $12, $e5	; $a1e8: 70 10 12 e5	 Data
			.byte $12, $12, $12, $12	; $a1ec: 12 12 12 12	 Data
			.byte $12, $12, $12, $9c	; $a1f0: 12 12 12 9c	 Data
			.byte $10, $7f, $a2, $81	; $a1f4: 10 7f a2 81	 Data
			.byte $70, $ea, $a1, $8d	; $a1f8: 70 ea a1 8d	 Data
			.byte $70, $04, $19, $e5	; $a1fc: 70 04 19 e5	 Data
			.byte $16, $17, $18, $19	; $a200: 16 17 18 19	 Data
			.byte $16, $17, $18, $81	; $a204: 16 17 18 81	 Data
			.byte $70, $fe, $a1, $80	; $a208: 70 fe a1 80	 Data
			.byte $d7, $a1, $8d, $70	; $a20c: d7 a1 8d 70	 Data
			.byte $07, $c1, $e5, $c1	; $a210: 07 c1 e5 c1	 Data
			.byte $e3, $c1, $c0, $e5	; $a214: e3 c1 c0 e5	 Data
			.byte $c1, $e3, $c1, $c1	; $a218: c1 e3 c1 c1	 Data
			.byte $e5, $c1, $c0, $e3	; $a21c: e5 c1 c0 e3	 Data
			.byte $c1, $c1, $e5, $81	; $a220: c1 c1 e5 81	 Data
			.byte $70, $11, $a2, $c1	; $a224: 70 11 a2 c1	 Data
			.byte $c1, $e3, $c1, $c0	; $a228: c1 e3 c1 c0	 Data
			.byte $e5, $c0, $00, $c0	; $a22c: e5 c0 00 c0	 Data
			.byte $e3, $c0, $c0, $c0	; $a230: e3 c0 c0 c0	 Data
			.byte $c0, $c0, $8d, $70	; $a234: c0 c0 8d 70	 Data
			.byte $0f, $c1, $e5, $c1	; $a238: 0f c1 e5 c1	 Data
			.byte $e3, $c1, $c0, $e5	; $a23c: e3 c1 c0 e5	 Data
			.byte $c1, $e3, $c1, $c1	; $a240: c1 e3 c1 c1	 Data
			.byte $e5, $c1, $c0, $e3	; $a244: e5 c1 c0 e3	 Data
			.byte $c1, $c1, $e5, $81	; $a248: c1 c1 e5 81	 Data
			.byte $70, $39, $a2, $c1	; $a24c: 70 39 a2 c1	 Data
			.byte $c1, $e3, $c1, $c0	; $a250: c1 e3 c1 c0	 Data
			.byte $e5, $c1, $e3, $c1	; $a254: e5 c1 e3 c1	 Data
			.byte $c1, $e5, $c1, $c0	; $a258: c1 e5 c1 c0	 Data
			.byte $e3, $c0, $c0, $c0	; $a25c: e3 c0 c0 c0	 Data
			.byte $8d, $70, $03, $c1	; $a260: 8d 70 03 c1	 Data
			.byte $e5, $c1, $c0, $c1	; $a264: e5 c1 c0 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $a268: c1 c1 c0 c1	 Data
			.byte $81, $70, $63, $a2	; $a26c: 81 70 63 a2	 Data
			.byte $c1, $c1, $c0, $c1	; $a270: c1 c1 c0 c1	 Data
			.byte $c1, $c0, $e3, $c0	; $a274: c1 c0 e3 c0	 Data
			.byte $c0, $c0, $c0, $c0	; $a278: c0 c0 c0 c0	 Data
			.byte $80, $0e, $a2, $00	; $a27c: 80 0e a2 00	 Data
			.byte $03, $00, $02, $00	; $a280: 03 00 02 00	 Data
			.byte $02, $00, $f9, $00	; $a284: 02 00 f9 00	 Data
			.byte $03, $00, $02, $00	; $a288: 03 00 02 00	 Data
			.byte $fd, $00, $fe, $04	; $a28c: fd 00 fe 04	 Data
			.byte $00, $01, $bf, $01	; $a290: 00 01 bf 01	 Data
			.byte $40, $05, $99, $00	; $a294: 40 05 99 00	 Data
			.byte $b8, $a2, $01, $01	; $a298: b8 a2 01 01	 Data
			.byte $7c, $06, $41, $f9	; $a29c: 7c 06 41 f9	 Data
			.byte $99, $01, $2f, $a3	; $a2a0: 99 01 2f a3	 Data
			.byte $02, $01, $bf, $02	; $a2a4: 02 01 bf 02	 Data
			.byte $40, $18, $99, $02	; $a2a8: 40 18 99 02	 Data
			.byte $a6, $a3, $03, $02	; $a2ac: a6 a3 03 02	 Data
			.byte $3f, $02, $40, $00	; $a2b0: 3f 02 40 00	 Data
			.byte $99, $03, $e1, $a3	; $a2b4: 99 03 e1 a3	 Data
			.byte $35, $ea, $33, $38	; $a2b8: 35 ea 33 38	 Data
			.byte $e8, $36, $ea, $35	; $a2bc: e8 36 ea 35	 Data
			.byte $33, $e8, $33, $ea	; $a2c0: 33 e8 33 ea	 Data
			.byte $35, $e0, $42, $2e	; $a2c4: 35 e0 42 2e	 Data
			.byte $e5, $30, $31, $ee	; $a2c8: e5 30 31 ee	 Data
			.byte $35, $ea, $33, $30	; $a2cc: 35 ea 33 30	 Data
			.byte $e8, $31, $ea, $30	; $a2d0: e8 31 ea 30	 Data
			.byte $2e, $e8, $30, $ea	; $a2d4: 2e e8 30 ea	 Data
			.byte $2c, $29, $e8, $8d	; $a2d8: 2c 29 e8 8d	 Data
			.byte $70, $01, $2c, $e5	; $a2dc: 70 01 2c e5	 Data
			.byte $2e, $e8, $30, $31	; $a2e0: 2e e8 30 31	 Data
			.byte $ea, $33, $e8, $35	; $a2e4: ea 33 e8 35	 Data
			.byte $36, $38, $36, $ea	; $a2e8: 36 38 36 ea	 Data
			.byte $35, $e0, $4e, $33	; $a2ec: 35 e0 4e 33	 Data
			.byte $e5, $31, $33, $30	; $a2f0: e5 31 33 30	 Data
			.byte $e0, $4e, $81, $70	; $a2f4: e0 4e 81 70	 Data
			.byte $04, $a3, $33, $e5	; $a2f8: 04 a3 33 e5	 Data
			.byte $31, $33, $35, $e0	; $a2fc: 31 33 35 e0	 Data
			.byte $4e, $80, $de, $a2	; $a300: 4e 80 de a2	 Data
			.byte $3a, $e5, $38, $3a	; $a304: 3a e5 38 3a	 Data
			.byte $3c, $e0, $4e, $35	; $a308: 3c e0 4e 35	 Data
			.byte $e8, $33, $e5, $35	; $a30c: e8 33 e5 35	 Data
			.byte $e8, $33, $e5, $36	; $a310: e8 33 e5 36	 Data
			.byte $35, $38, $e8, $36	; $a314: 35 38 e8 36	 Data
			.byte $e5, $38, $e8, $36	; $a318: e5 38 e8 36	 Data
			.byte $e5, $3a, $38, $3b	; $a31c: e5 3a 38 3b	 Data
			.byte $e8, $3a, $e5, $3b	; $a320: e8 3a e5 3b	 Data
			.byte $e8, $3a, $e5, $3d	; $a324: e8 3a e5 3d	 Data
			.byte $3b, $3a, $ee, $35	; $a328: 3b 3a ee 35	 Data
			.byte $80, $bd, $a2, $35	; $a32c: 80 bd a2 35	 Data
			.byte $ea, $33, $38, $e8	; $a330: ea 33 38 e8	 Data
			.byte $36, $ea, $35, $33	; $a334: 36 ea 35 33	 Data
			.byte $e8, $33, $ea, $35	; $a338: e8 33 ea 35	 Data
			.byte $e0, $42, $2e, $e5	; $a33c: e0 42 2e e5	 Data
			.byte $30, $31, $ee, $35	; $a340: 30 31 ee 35	 Data
			.byte $ea, $33, $30, $e8	; $a344: ea 33 30 e8	 Data
			.byte $31, $ea, $30, $2e	; $a348: 31 ea 30 2e	 Data
			.byte $e8, $30, $ea, $2c	; $a34c: e8 30 ea 2c	 Data
			.byte $29, $e8, $8d, $70	; $a350: 29 e8 8d 70	 Data
			.byte $02, $89, $00, $2c	; $a354: 02 89 00 2c	 Data
			.byte $e5, $2e, $e8, $30	; $a358: e5 2e e8 30	 Data
			.byte $31, $ea, $33, $e8	; $a35c: 31 ea 33 e8	 Data
			.byte $35, $36, $38, $8a	; $a360: 35 36 38 8a	 Data
			.byte $ff, $89, $f4, $3d	; $a364: ff 89 f4 3d	 Data
			.byte $ea, $3b, $3a, $e8	; $a368: ea 3b 3a e8	 Data
			.byte $38, $ea, $36, $35	; $a36c: 38 ea 36 35	 Data
			.byte $e8, $33, $ee, $38	; $a370: e8 33 ee 38	 Data
			.byte $ea, $36, $35, $e8	; $a374: ea 36 35 e8	 Data
			.byte $31, $ee, $36, $ea	; $a378: 31 ee 36 ea	 Data
			.byte $35, $31, $e8, $8a	; $a37c: 35 31 e8 8a	 Data
			.byte $01, $81, $70, $55	; $a380: 01 81 70 55	 Data
			.byte $a3, $8a, $ff, $2e	; $a384: a3 8a ff 2e	 Data
			.byte $ee, $8a, $01, $89	; $a388: ee 8a 01 89	 Data
			.byte $05, $38, $e8, $36	; $a38c: 05 38 e8 36	 Data
			.byte $e5, $38, $e8, $36	; $a390: e5 38 e8 36	 Data
			.byte $e5, $3a, $38, $3b	; $a394: e5 3a 38 3b	 Data
			.byte $e8, $3a, $e5, $3b	; $a398: e8 3a e5 3b	 Data
			.byte $e8, $3a, $e5, $3d	; $a39c: e8 3a e5 3d	 Data
			.byte $3b, $3a, $ee, $80	; $a3a0: 3b 3a ee 80	 Data
			.byte $2f, $a3, $8d, $70	; $a3a4: 2f a3 8d 70	 Data
			.byte $18, $22, $e5, $16	; $a3a8: 18 22 e5 16	 Data
			.byte $22, $16, $22, $22	; $a3ac: 22 16 22 22	 Data
			.byte $16, $22, $9c, $18	; $a3b0: 16 22 9c 18	 Data
			.byte $40, $a4, $81, $70	; $a3b4: 40 a4 81 70	 Data
			.byte $a9, $a3, $88, $04	; $a3b8: a9 a3 88 04	 Data
			.byte $16, $00, $14, $16	; $a3bc: 16 00 14 16	 Data
			.byte $00, $14, $17, $16	; $a3c0: 00 14 17 16	 Data
			.byte $19, $00, $17, $19	; $a3c4: 19 00 17 19	 Data
			.byte $00, $17, $1b, $19	; $a3c8: 00 17 1b 19	 Data
			.byte $1c, $00, $1b, $1c	; $a3cc: 1c 00 1b 1c	 Data
			.byte $00, $1b, $1e, $1c	; $a3d0: 00 1b 1e 1c	 Data
			.byte $88, $02, $20, $14	; $a3d4: 88 02 20 14	 Data
			.byte $20, $14, $20, $20	; $a3d8: 20 14 20 20	 Data
			.byte $14, $20, $80, $a6	; $a3dc: 14 20 80 a6	 Data
			.byte $a3, $8d, $77, $03	; $a3e0: a3 8d 77 03	 Data
			.byte $8d, $70, $07, $8a	; $a3e4: 8d 70 07 8a	 Data
			.byte $fb, $c0, $e3, $00	; $a3e8: fb c0 e3 00	 Data
			.byte $c0, $00, $8a, $05	; $a3ec: c0 00 8a 05	 Data
			.byte $c0, $00, $8a, $fb	; $a3f0: c0 00 8a fb	 Data
			.byte $c0, $00, $c0, $00	; $a3f4: c0 00 c0 00	 Data
			.byte $c0, $00, $8a, $05	; $a3f8: c0 00 8a 05	 Data
			.byte $c0, $00, $8a, $fb	; $a3fc: c0 00 8a fb	 Data
			.byte $c0, $00, $8a, $05	; $a400: c0 00 8a 05	 Data
			.byte $81, $70, $e7, $a3	; $a404: 81 70 e7 a3	 Data
			.byte $8a, $fb, $c0, $00	; $a408: 8a fb c0 00	 Data
			.byte $c0, $00, $8a, $05	; $a40c: c0 00 8a 05	 Data
			.byte $c0, $00, $8a, $fb	; $a410: c0 00 8a fb	 Data
			.byte $c0, $00, $8a, $05	; $a414: c0 00 8a 05	 Data
			.byte $c0, $00, $8a, $fb	; $a418: c0 00 8a fb	 Data
			.byte $c0, $00, $8a, $05	; $a41c: c0 00 8a 05	 Data
			.byte $c0, $c0, $c0, $c0	; $a420: c0 c0 c0 c0	 Data
			.byte $81, $77, $e4, $a3	; $a424: 81 77 e4 a3	 Data
			.byte $00, $ee, $00, $00	; $a428: 00 ee 00 00	 Data
			.byte $c0, $e3, $00, $c0	; $a42c: c0 e3 00 c0	 Data
			.byte $00, $00, $00, $c0	; $a430: 00 00 00 c0	 Data
			.byte $00, $c0, $00, $c0	; $a434: 00 c0 00 c0	 Data
			.byte $c0, $c0, $c0, $c0	; $a438: c0 c0 c0 c0	 Data
			.byte $c0, $80, $e1, $a3	; $a43c: c0 80 e1 a3	 Data
			.byte $fe, $fe, $ff, $05	; $a440: fe fe ff 05	 Data
			.byte $fe, $fe, $ff, $fe	; $a444: fe fe ff fe	 Data
			.byte $00, $02, $00, $03	; $a448: 00 02 00 03	 Data
			.byte $00, $fd, $00, $fe	; $a44c: 00 fd 00 fe	 Data
			.byte $00, $02, $00, $03	; $a450: 00 02 00 03	 Data
			.byte $00, $fd, $00, $05	; $a454: 00 fd 00 05	 Data
			.byte $04, $00, $01, $7f	; $a458: 04 00 01 7f	 Data
			.byte $01, $40, $00, $66	; $a45c: 01 40 00 66	 Data
			.byte $00, $81, $a4, $01	; $a460: 00 81 a4 01	 Data
			.byte $01, $7d, $04, $41	; $a464: 01 7d 04 41	 Data
			.byte $00, $66, $01, $eb	; $a468: 00 66 01 eb	 Data
			.byte $a4, $02, $01, $3f	; $a46c: a4 02 01 3f	 Data
			.byte $02, $40, $0c, $66	; $a470: 02 40 0c 66	 Data
			.byte $02, $4b, $a5, $03	; $a474: 02 4b a5 03	 Data
			.byte $02, $3f, $03, $40	; $a478: 02 3f 03 40	 Data
			.byte $00, $66, $03, $c6	; $a47c: 00 66 03 c6	 Data
			.byte $a5, $8d, $70, $01	; $a480: a5 8d 70 01	 Data
			.byte $31, $e3, $30, $2e	; $a484: 31 e3 30 2e	 Data
			.byte $e8, $31, $e3, $30	; $a488: e8 31 e3 30	 Data
			.byte $2e, $e5, $31, $e3	; $a48c: 2e e5 31 e3	 Data
			.byte $30, $2e, $30, $31	; $a490: 30 2e 30 31	 Data
			.byte $33, $30, $ea, $35	; $a494: 33 30 ea 35	 Data
			.byte $e0, $1e, $31, $e3	; $a498: e0 1e 31 e3	 Data
			.byte $30, $2e, $e8, $31	; $a49c: 30 2e e8 31	 Data
			.byte $e3, $30, $2e, $e5	; $a4a0: e3 30 2e e5	 Data
			.byte $31, $e3, $30, $2e	; $a4a4: 31 e3 30 2e	 Data
			.byte $30, $31, $33, $30	; $a4a8: 30 31 33 30	 Data
			.byte $ea, $29, $e0, $1e	; $a4ac: ea 29 e0 1e	 Data
			.byte $81, $70, $d1, $a4	; $a4b0: 81 70 d1 a4	 Data
			.byte $35, $e8, $36, $e5	; $a4b4: 35 e8 36 e5	 Data
			.byte $33, $e8, $35, $ea	; $a4b8: 33 e8 35 ea	 Data
			.byte $33, $e8, $35, $e5	; $a4bc: 33 e8 35 e5	 Data
			.byte $33, $e8, $2c, $ea	; $a4c0: 33 e8 2c ea	 Data
			.byte $35, $e8, $33, $e5	; $a4c4: 35 e8 33 e5	 Data
			.byte $38, $e8, $36, $35	; $a4c8: 38 e8 36 35	 Data
			.byte $e0, $36, $80, $84	; $a4cc: e0 36 80 84	 Data
			.byte $a4, $2c, $e8, $2a	; $a4d0: a4 2c e8 2a	 Data
			.byte $e5, $28, $e8, $2f	; $a4d4: e5 28 e8 2f	 Data
			.byte $ea, $2e, $e8, $2c	; $a4d8: ea 2e e8 2c	 Data
			.byte $e5, $2a, $e8, $31	; $a4dc: e5 2a e8 31	 Data
			.byte $ea, $33, $e3, $35	; $a4e0: ea 33 e3 35	 Data
			.byte $33, $35, $33, $ed	; $a4e4: 33 35 33 ed	 Data
			.byte $80, $81, $a4, $8d	; $a4e8: 80 81 a4 8d	 Data
			.byte $70, $02, $00, $ee	; $a4ec: 70 02 00 ee	 Data
			.byte $00, $e8, $2c, $e5	; $a4f0: 00 e8 2c e5	 Data
			.byte $2e, $30, $31, $30	; $a4f4: 2e 30 31 30	 Data
			.byte $e4, $2e, $2c, $81	; $a4f8: e4 2e 2c 81	 Data
			.byte $70, $ee, $a4, $31	; $a4fc: 70 ee a4 31	 Data
			.byte $ea, $2e, $e0, $1e	; $a500: ea 2e e0 1e	 Data
			.byte $30, $ea, $29, $e0	; $a504: 30 ea 29 e0	 Data
			.byte $1e, $2a, $e5, $2e	; $a508: 1e 2a e5 2e	 Data
			.byte $31, $35, $2a, $2e	; $a50c: 31 35 2a 2e	 Data
			.byte $31, $2e, $33, $e3	; $a510: 31 2e 33 e3	 Data
			.byte $35, $36, $33, $30	; $a514: 35 36 33 30	 Data
			.byte $31, $33, $30, $2d	; $a518: 31 33 30 2d	 Data
			.byte $2e, $30, $2c, $29	; $a51c: 2e 30 2c 29	 Data
			.byte $2b, $2c, $29, $8d	; $a520: 2b 2c 29 8d	 Data
			.byte $70, $02, $00, $ee	; $a524: 70 02 00 ee	 Data
			.byte $00, $e8, $2c, $e5	; $a528: 00 e8 2c e5	 Data
			.byte $2e, $30, $31, $30	; $a52c: 2e 30 31 30	 Data
			.byte $e4, $2e, $2c, $81	; $a530: e4 2e 2c 81	 Data
			.byte $70, $26, $a5, $23	; $a534: 70 26 a5 23	 Data
			.byte $ea, $20, $e0, $1e	; $a538: ea 20 e0 1e	 Data
			.byte $25, $ea, $22, $e0	; $a53c: 25 ea 22 e0	 Data
			.byte $1e, $2c, $eb, $24	; $a540: 1e 2c eb 24	 Data
			.byte $e5, $27, $2c, $30	; $a544: e5 27 2c 30	 Data
			.byte $80, $eb, $a4, $8d	; $a548: 80 eb a4 8d	 Data
			.byte $70, $04, $22, $e5	; $a54c: 70 04 22 e5	 Data
			.byte $22, $e3, $20, $22	; $a550: 22 e3 20 22	 Data
			.byte $e5, $22, $e3, $20	; $a554: e5 22 e3 20	 Data
			.byte $22, $e5, $22, $e3	; $a558: 22 e5 22 e3	 Data
			.byte $20, $22, $e5, $22	; $a55c: 20 22 e5 22	 Data
			.byte $e3, $20, $9c, $04	; $a560: e3 20 9c 04	 Data
			.byte $20, $a6, $81, $70	; $a564: 20 a6 81 70	 Data
			.byte $4e, $a5, $8d, $70	; $a568: 4e a5 8d 70	 Data
			.byte $03, $1e, $e5, $1e	; $a56c: 03 1e e5 1e	 Data
			.byte $1e, $25, $e8, $1e	; $a570: 1e 25 e8 1e	 Data
			.byte $e5, $1e, $1e, $9c	; $a574: e5 1e 1e 9c	 Data
			.byte $03, $24, $a6, $81	; $a578: 03 24 a6 81	 Data
			.byte $70, $6d, $a5, $1d	; $a57c: 70 6d a5 1d	 Data
			.byte $1d, $1d, $24, $1d	; $a580: 1d 1d 24 1d	 Data
			.byte $1d, $1d, $24, $8d	; $a584: 1d 1d 24 8d	 Data
			.byte $70, $04, $22, $e5	; $a588: 70 04 22 e5	 Data
			.byte $22, $e3, $20, $22	; $a58c: 22 e3 20 22	 Data
			.byte $e5, $22, $e3, $20	; $a590: e5 22 e3 20	 Data
			.byte $22, $e5, $22, $e3	; $a594: 22 e5 22 e3	 Data
			.byte $20, $22, $e5, $22	; $a598: 20 22 e5 22	 Data
			.byte $e3, $20, $9c, $04	; $a59c: e3 20 9c 04	 Data
			.byte $27, $a6, $81, $70	; $a5a0: 27 a6 81 70	 Data
			.byte $8a, $a5, $1c, $e5	; $a5a4: 8a a5 1c e5	 Data
			.byte $1d, $1d, $17, $1d	; $a5a8: 1d 1d 17 1d	 Data
			.byte $1d, $1d, $18, $1e	; $a5ac: 1d 1d 18 1e	 Data
			.byte $1e, $1e, $19, $1e	; $a5b0: 1e 1e 19 1e	 Data
			.byte $1e, $1e, $19, $20	; $a5b4: 1e 1e 19 20	 Data
			.byte $eb, $20, $e3, $20	; $a5b8: eb 20 e3 20	 Data
			.byte $20, $e5, $20, $e3	; $a5bc: 20 e5 20 e3	 Data
			.byte $20, $20, $e5, $80	; $a5c0: 20 20 e5 80	 Data
			.byte $4b, $a5, $8d, $70	; $a5c4: 4b a5 8d 70	 Data
			.byte $10, $c0, $e3, $c1	; $a5c8: 10 c0 e3 c1	 Data
			.byte $c1, $c1, $81, $70	; $a5cc: c1 c1 81 70	 Data
			.byte $c9, $a5, $8d, $70	; $a5d0: c9 a5 8d 70	 Data
			.byte $02, $c0, $ea, $c0	; $a5d4: 02 c0 ea c0	 Data
			.byte $e5, $c0, $eb, $81	; $a5d8: e5 c0 eb 81	 Data
			.byte $70, $d5, $a5, $8d	; $a5dc: 70 d5 a5 8d	 Data
			.byte $77, $02, $8d, $70	; $a5e0: 77 02 8d 70	 Data
			.byte $04, $c0, $e3, $c0	; $a5e4: 04 c0 e3 c0	 Data
			.byte $c1, $81, $70, $e5	; $a5e8: c1 81 70 e5	 Data
			.byte $a5, $c0, $c0, $c0	; $a5ec: a5 c0 c0 c0	 Data
			.byte $c0, $81, $77, $e2	; $a5f0: c0 81 77 e2	 Data
			.byte $a5, $8d, $70, $10	; $a5f4: a5 8d 70 10	 Data
			.byte $c0, $e3, $c1, $c1	; $a5f8: c0 e3 c1 c1	 Data
			.byte $c1, $81, $70, $f8	; $a5fc: c1 81 70 f8	 Data
			.byte $a5, $8d, $70, $02	; $a600: a5 8d 70 02	 Data
			.byte $c0, $ea, $c0, $e5	; $a604: c0 ea c0 e5	 Data
			.byte $c0, $eb, $81, $70	; $a608: c0 eb 81 70	 Data
			.byte $04, $a6, $8d, $70	; $a60c: 04 a6 8d 70	 Data
			.byte $04, $c0, $e5, $c1	; $a610: 04 c0 e5 c1	 Data
			.byte $e3, $81, $70, $11	; $a614: e3 81 70 11	 Data
			.byte $a6, $c0, $c0, $c0	; $a618: a6 c0 c0 c0	 Data
			.byte $c0, $80, $c6, $a5	; $a61c: c0 80 c6 a5	 Data
			.byte $fe, $02, $fe, $02	; $a620: fe 02 fe 02	 Data
			.byte $ff, $01, $00, $fe	; $a624: ff 01 00 fe	 Data
			.byte $02, $fe, $02, $04	; $a628: 02 fe 02 04	 Data
			.byte $00, $01, $be, $04	; $a62c: 00 01 be 04	 Data
			.byte $40, $00, $80, $00	; $a630: 40 00 80 00	 Data
			.byte $54, $a6, $01, $01	; $a634: 54 a6 01 01	 Data
			.byte $be, $04, $40, $00	; $a638: be 04 40 00	 Data
			.byte $80, $01, $78, $a6	; $a63c: 80 01 78 a6	 Data
			.byte $02, $01, $bf, $04	; $a640: 02 01 bf 04	 Data
			.byte $40, $18, $80, $02	; $a644: 40 18 80 02	 Data
			.byte $c9, $a6, $03, $02	; $a648: c9 a6 03 02	 Data
			.byte $3e, $04, $40, $00	; $a64c: 3e 04 40 00	 Data
			.byte $80, $03, $d5, $a6	; $a650: 80 03 d5 a6	 Data
			.byte $10, $e5, $28, $2f	; $a654: 10 e5 28 2f	 Data
			.byte $34, $10, $28, $2f	; $a658: 34 10 28 2f	 Data
			.byte $32, $10, $28, $2d	; $a65c: 32 10 28 2d	 Data
			.byte $30, $10, $28, $2b	; $a660: 30 10 28 2b	 Data
			.byte $2f, $10, $28, $2a	; $a664: 2f 10 28 2a	 Data
			.byte $2d, $2b, $2a, $28	; $a668: 2d 2b 2a 28	 Data
			.byte $27, $28, $27, $28	; $a66c: 27 28 27 28	 Data
			.byte $2a, $2b, $2a, $2b	; $a670: 2a 2b 2a 2b	 Data
			.byte $2d, $80, $54, $a6	; $a674: 2d 80 54 a6	 Data
			.byte $88, $04, $8a, $fe	; $a678: 88 04 8a fe	 Data
			.byte $83, $01, $00, $e7	; $a67c: 83 01 00 e7	 Data
			.byte $10, $e5, $28, $2f	; $a680: 10 e5 28 2f	 Data
			.byte $34, $10, $28, $2f	; $a684: 34 10 28 2f	 Data
			.byte $32, $10, $28, $2d	; $a688: 32 10 28 2d	 Data
			.byte $30, $10, $28, $2b	; $a68c: 30 10 28 2b	 Data
			.byte $2f, $10, $28, $2a	; $a690: 2f 10 28 2a	 Data
			.byte $2d, $2b, $2a, $28	; $a694: 2d 2b 2a 28	 Data
			.byte $27, $28, $27, $28	; $a698: 27 28 27 28	 Data
			.byte $2a, $2b, $2a, $2b	; $a69c: 2a 2b 2a 2b	 Data
			.byte $e3, $88, $01, $83	; $a6a0: e3 88 01 83	 Data
			.byte $01, $8c, $8a, $02	; $a6a4: 01 8c 8a 02	 Data
			.byte $2a, $eb, $2b, $27	; $a6a8: 2a eb 2b 27	 Data
			.byte $28, $22, $ee, $23	; $a6ac: 28 22 ee 23	 Data
			.byte $2a, $e8, $2b, $27	; $a6b0: 2a e8 2b 27	 Data
			.byte $28, $22, $e5, $23	; $a6b4: 28 22 e5 23	 Data
			.byte $1e, $21, $1b, $1e	; $a6b8: 1e 21 1b 1e	 Data
			.byte $21, $24, $27, $2a	; $a6bc: 21 24 27 2a	 Data
			.byte $2d, $30, $2f, $ee	; $a6c0: 2d 30 2f ee	 Data
			.byte $00, $eb, $80, $78	; $a6c4: 00 eb 80 78	 Data
			.byte $a6, $10, $e5, $1c	; $a6c8: a6 10 e5 1c	 Data
			.byte $10, $1c, $10, $1c	; $a6cc: 10 1c 10 1c	 Data
			.byte $10, $1c, $80, $c9	; $a6d0: 10 1c 80 c9	 Data
			.byte $a6, $c1, $e5, $c1	; $a6d4: a6 c1 e5 c1	 Data
			.byte $e3, $c1, $c0, $e5	; $a6d8: e3 c1 c0 e5	 Data
			.byte $c1, $e3, $c1, $c1	; $a6dc: c1 e3 c1 c1	 Data
			.byte $e5, $c1, $e3, $c1	; $a6e0: e5 c1 e3 c1	 Data
			.byte $c0, $e5, $c1, $e3	; $a6e4: c0 e5 c1 e3	 Data
			.byte $c1, $80, $d5, $a6	; $a6e8: c1 80 d5 a6	 Data
			.byte $04, $00, $01, $bf	; $a6ec: 04 00 01 bf	 Data
			.byte $01, $40, $02, $80	; $a6f0: 01 40 02 80	 Data
			.byte $00, $15, $a7, $01	; $a6f4: 00 15 a7 01	 Data
			.byte $01, $be, $01, $41	; $a6f8: 01 be 01 41	 Data
			.byte $02, $80, $01, $6c	; $a6fc: 02 80 01 6c	 Data
			.byte $a7, $02, $01, $bf	; $a700: a7 02 01 bf	 Data
			.byte $03, $40, $1a, $80	; $a704: 03 40 1a 80	 Data
			.byte $02, $c5, $a7, $03	; $a708: 02 c5 a7 03	 Data
			.byte $02, $3e, $04, $40	; $a70c: 02 3e 04 40	 Data
			.byte $00, $80, $03, $49	; $a710: 00 80 03 49	 Data
			.byte $a8, $25, $eb, $00	; $a714: a8 25 eb 00	 Data
			.byte $e5, $25, $22, $23	; $a718: e5 25 22 23	 Data
			.byte $24, $ee, $23, $eb	; $a71c: 24 ee 23 eb	 Data
			.byte $00, $e5, $23, $20	; $a720: 00 e5 23 20	 Data
			.byte $21, $22, $eb, $00	; $a724: 21 22 eb 00	 Data
			.byte $e5, $22, $23, $24	; $a728: e5 22 23 24	 Data
			.byte $25, $eb, $00, $e5	; $a72c: 25 eb 00 e5	 Data
			.byte $25, $22, $23, $24	; $a730: 25 22 23 24	 Data
			.byte $eb, $2a, $23, $00	; $a734: eb 2a 23 00	 Data
			.byte $e5, $23, $20, $21	; $a738: e5 23 20 21	 Data
			.byte $22, $ee, $00, $e5	; $a73c: 22 ee 00 e5	 Data
			.byte $22, $25, $29, $2c	; $a740: 22 25 29 2c	 Data
			.byte $e8, $2b, $2a, $e3	; $a744: e8 2b 2a e3	 Data
			.byte $00, $26, $e8, $23	; $a748: 00 26 e8 23	 Data
			.byte $25, $e3, $00, $26	; $a74c: 25 e3 00 26	 Data
			.byte $e8, $00, $e5, $22	; $a750: e8 00 e5 22	 Data
			.byte $25, $29, $2c, $e8	; $a754: 25 29 2c e8	 Data
			.byte $2b, $2a, $eb, $26	; $a758: 2b 2a eb 26	 Data
			.byte $24, $e8, $27, $2b	; $a75c: 24 e8 27 2b	 Data
			.byte $2e, $2d, $eb, $2a	; $a760: 2e 2d eb 2a	 Data
			.byte $27, $e0, $48, $00	; $a764: 27 e0 48 00	 Data
			.byte $eb, $80, $15, $a7	; $a768: eb 80 15 a7	 Data
			.byte $00, $e7, $25, $eb	; $a76c: 00 e7 25 eb	 Data
			.byte $00, $e5, $25, $22	; $a770: 00 e5 25 22	 Data
			.byte $23, $24, $ee, $23	; $a774: 23 24 ee 23	 Data
			.byte $eb, $00, $e5, $23	; $a778: eb 00 e5 23	 Data
			.byte $20, $21, $22, $eb	; $a77c: 20 21 22 eb	 Data
			.byte $00, $e5, $22, $23	; $a780: 00 e5 22 23	 Data
			.byte $24, $25, $eb, $00	; $a784: 24 25 eb 00	 Data
			.byte $e5, $25, $22, $23	; $a788: e5 25 22 23	 Data
			.byte $24, $eb, $2a, $23	; $a78c: 24 eb 2a 23	 Data
			.byte $00, $e5, $23, $20	; $a790: 00 e5 23 20	 Data
			.byte $21, $22, $ee, $00	; $a794: 21 22 ee 00	 Data
			.byte $e5, $22, $25, $29	; $a798: e5 22 25 29	 Data
			.byte $2c, $e8, $2b, $2a	; $a79c: 2c e8 2b 2a	 Data
			.byte $e3, $00, $26, $e8	; $a7a0: e3 00 26 e8	 Data
			.byte $23, $25, $e3, $00	; $a7a4: 23 25 e3 00	 Data
			.byte $26, $e8, $00, $e5	; $a7a8: 26 e8 00 e5	 Data
			.byte $22, $25, $29, $2c	; $a7ac: 22 25 29 2c	 Data
			.byte $e8, $2b, $2a, $eb	; $a7b0: e8 2b 2a eb	 Data
			.byte $26, $24, $e8, $27	; $a7b4: 26 24 e8 27	 Data
			.byte $2b, $2e, $2d, $eb	; $a7b8: 2b 2e 2d eb	 Data
			.byte $2a, $27, $e0, $48	; $a7bc: 2a 27 e0 48	 Data
			.byte $00, $eb, $80, $6e	; $a7c0: 00 eb 80 6e	 Data
			.byte $a7, $19, $e5, $19	; $a7c4: a7 19 e5 19	 Data
			.byte $19, $19, $19, $19	; $a7c8: 19 19 19 19	 Data
			.byte $19, $19, $18, $18	; $a7cc: 19 19 18 18	 Data
			.byte $18, $18, $18, $18	; $a7d0: 18 18 18 18	 Data
			.byte $18, $18, $17, $17	; $a7d4: 18 18 17 17	 Data
			.byte $17, $17, $17, $17	; $a7d8: 17 17 17 17	 Data
			.byte $17, $17, $16, $16	; $a7dc: 17 17 16 16	 Data
			.byte $16, $16, $16, $16	; $a7e0: 16 16 16 16	 Data
			.byte $17, $18, $19, $19	; $a7e4: 17 18 19 19	 Data
			.byte $19, $19, $19, $19	; $a7e8: 19 19 19 19	 Data
			.byte $19, $19, $18, $18	; $a7ec: 19 19 18 18	 Data
			.byte $18, $18, $18, $18	; $a7f0: 18 18 18 18	 Data
			.byte $18, $18, $17, $17	; $a7f4: 18 18 17 17	 Data
			.byte $17, $17, $17, $17	; $a7f8: 17 17 17 17	 Data
			.byte $17, $17, $16, $16	; $a7fc: 17 17 16 16	 Data
			.byte $16, $16, $16, $16	; $a800: 16 16 16 16	 Data
			.byte $16, $16, $16, $16	; $a804: 16 16 16 16	 Data
			.byte $16, $16, $16, $16	; $a808: 16 16 16 16	 Data
			.byte $16, $16, $17, $17	; $a80c: 16 16 17 17	 Data
			.byte $17, $17, $17, $17	; $a810: 17 17 17 17	 Data
			.byte $17, $17, $16, $16	; $a814: 17 17 16 16	 Data
			.byte $16, $16, $16, $16	; $a818: 16 16 16 16	 Data
			.byte $16, $16, $17, $17	; $a81c: 16 16 17 17	 Data
			.byte $17, $17, $17, $17	; $a820: 17 17 17 17	 Data
			.byte $17, $17, $18, $18	; $a824: 17 17 18 18	 Data
			.byte $18, $18, $18, $18	; $a828: 18 18 18 18	 Data
			.byte $18, $18, $12, $12	; $a82c: 18 18 12 12	 Data
			.byte $12, $12, $12, $12	; $a830: 12 12 12 12	 Data
			.byte $12, $12, $14, $14	; $a834: 12 12 14 14	 Data
			.byte $14, $14, $14, $14	; $a838: 14 14 14 14	 Data
			.byte $14, $14, $14, $14	; $a83c: 14 14 14 14	 Data
			.byte $14, $14, $14, $14	; $a840: 14 14 14 14	 Data
			.byte $14, $14, $80, $c5	; $a844: 14 14 80 c5	 Data
			.byte $a7, $8a, $fb, $8d	; $a848: a7 8a fb 8d	 Data
			.byte $70, $03, $c0, $e3	; $a84c: 70 03 c0 e3	 Data
			.byte $c0, $c0, $c0, $8a	; $a850: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a854: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $c0	; $a858: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a85c: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a860: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $81	; $a864: c0 c0 c0 81	 Data
			.byte $70, $4e, $a8, $c0	; $a868: 70 4e a8 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a86c: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a870: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $c0	; $a874: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a878: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a87c: 05 c0 8a fb	 Data
			.byte $c0, $8a, $05, $c0	; $a880: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $8d	; $a884: 8a fb c0 8d	 Data
			.byte $70, $03, $c0, $e3	; $a888: 70 03 c0 e3	 Data
			.byte $c0, $c0, $c0, $8a	; $a88c: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a890: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $c0	; $a894: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a898: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a89c: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $81	; $a8a0: c0 c0 c0 81	 Data
			.byte $70, $8a, $a8, $c0	; $a8a4: 70 8a a8 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a8a8: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a8ac: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $c0	; $a8b0: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a8b4: c0 c0 c0 8a	 Data
			.byte $05, $c0, $c0, $c0	; $a8b8: 05 c0 c0 c0	 Data
			.byte $c0, $8a, $fb, $8d	; $a8bc: c0 8a fb 8d	 Data
			.byte $70, $07, $c0, $e3	; $a8c0: 70 07 c0 e3	 Data
			.byte $c0, $c0, $c0, $8a	; $a8c4: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a8c8: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $c0	; $a8cc: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a8d0: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a8d4: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $81	; $a8d8: c0 c0 c0 81	 Data
			.byte $70, $c2, $a8, $c0	; $a8dc: 70 c2 a8 c0	 Data
			.byte $c0, $c0, $c0, $8a	; $a8e0: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a8e4: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $8a	; $a8e8: c0 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a8ec: 05 c0 8a fb	 Data
			.byte $c0, $8a, $05, $c0	; $a8f0: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $8a	; $a8f4: 8a fb c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $a8f8: 05 c0 8a fb	 Data
			.byte $c0, $8a, $05, $c0	; $a8fc: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $80	; $a900: 8a fb c0 80	 Data
			.byte $4b, $a8, $04, $00	; $a904: 4b a8 04 00	 Data
			.byte $01, $7f, $01, $40	; $a908: 01 7f 01 40	 Data
			.byte $fe, $9e, $00, $2f	; $a90c: fe 9e 00 2f	 Data
			.byte $a9, $01, $01, $7d	; $a910: a9 01 01 7d	 Data
			.byte $06, $41, $f9, $9e	; $a914: 06 41 f9 9e	 Data
			.byte $01, $91, $a9, $02	; $a918: 01 91 a9 02	 Data
			.byte $01, $3f, $04, $40	; $a91c: 01 3f 04 40	 Data
			.byte $16, $9e, $02, $1f	; $a920: 16 9e 02 1f	 Data
			.byte $aa, $03, $02, $3f	; $a924: aa 03 02 3f	 Data
			.byte $04, $40, $00, $9e	; $a928: 04 40 00 9e	 Data
			.byte $03, $fa, $aa, $31	; $a92c: 03 fa aa 31	 Data
			.byte $ee, $34, $eb, $33	; $a930: ee 34 eb 33	 Data
			.byte $e8, $37, $38, $e0	; $a934: e8 37 38 e0	 Data
			.byte $60, $3b, $ee, $38	; $a938: 60 3b ee 38	 Data
			.byte $ea, $36, $34, $e8	; $a93c: ea 36 34 e8	 Data
			.byte $38, $e0, $60, $31	; $a940: 38 e0 60 31	 Data
			.byte $ee, $34, $eb, $33	; $a944: ee 34 eb 33	 Data
			.byte $e8, $37, $38, $e0	; $a948: e8 37 38 e0	 Data
			.byte $60, $8d, $70, $02	; $a94c: 60 8d 70 02	 Data
			.byte $34, $ea, $33, $31	; $a950: 34 ea 33 31	 Data
			.byte $2f, $e8, $2c, $81	; $a954: 2f e8 2c 81	 Data
			.byte $70, $50, $a9, $38	; $a958: 70 50 a9 38	 Data
			.byte $ea, $36, $34, $33	; $a95c: ea 36 34 33	 Data
			.byte $e8, $2f, $31, $e0	; $a960: e8 2f 31 e0	 Data
			.byte $48, $00, $e0, $18	; $a964: 48 00 e0 18	 Data
			.byte $31, $ee, $38, $ea	; $a968: 31 ee 38 ea	 Data
			.byte $36, $34, $e8, $33	; $a96c: 36 34 e8 33	 Data
			.byte $ee, $2f, $2d, $31	; $a970: ee 2f 2d 31	 Data
			.byte $ea, $2f, $2d, $e8	; $a974: ea 2f 2d e8	 Data
			.byte $2c, $ee, $2f, $31	; $a978: 2c ee 2f 31	 Data
			.byte $38, $ea, $36, $34	; $a97c: 38 ea 36 34	 Data
			.byte $e8, $3b, $ee, $38	; $a980: e8 3b ee 38	 Data
			.byte $3d, $e6, $3b, $39	; $a984: 3d e6 3b 39	 Data
			.byte $38, $36, $34, $38	; $a988: 38 36 34 38	 Data
			.byte $ee, $33, $80, $2f	; $a98c: ee 33 80 2f	 Data
			.byte $a9, $31, $ee, $34	; $a990: a9 31 ee 34	 Data
			.byte $ea, $33, $2f, $e8	; $a994: ea 33 2f e8	 Data
			.byte $2c, $ee, $2a, $ea	; $a998: 2c ee 2a ea	 Data
			.byte $2f, $2c, $e8, $31	; $a99c: 2f 2c e8 31	 Data
			.byte $ee, $34, $ea, $33	; $a9a0: ee 34 ea 33	 Data
			.byte $2c, $e8, $88, $04	; $a9a4: 2c e8 88 04	 Data
			.byte $8a, $01, $25, $ea	; $a9a8: 8a 01 25 ea	 Data
			.byte $26, $27, $e8, $28	; $a9ac: 26 27 e8 28	 Data
			.byte $29, $2a, $2c, $88	; $a9b0: 29 2a 2c 88	 Data
			.byte $09, $8a, $ff, $31	; $a9b4: 09 8a ff 31	 Data
			.byte $ee, $34, $ea, $33	; $a9b8: ee 34 ea 33	 Data
			.byte $2f, $e8, $2c, $ea	; $a9bc: 2f e8 2c ea	 Data
			.byte $2d, $2a, $e8, $2c	; $a9c0: 2d 2a e8 2c	 Data
			.byte $ea, $28, $25, $e8	; $a9c4: ea 28 25 e8	 Data
			.byte $8a, $01, $89, $0c	; $a9c8: 8a 01 89 0c	 Data
			.byte $8d, $70, $02, $00	; $a9cc: 8d 70 02 00	 Data
			.byte $e5, $1c, $28, $00	; $a9d0: e5 1c 28 00	 Data
			.byte $1b, $27, $00, $19	; $a9d4: 1b 27 00 19	 Data
			.byte $25, $17, $e8, $20	; $a9d8: 25 17 e8 20	 Data
			.byte $81, $70, $cf, $a9	; $a9dc: 81 70 cf a9	 Data
			.byte $00, $e5, $20, $2c	; $a9e0: 00 e5 20 2c	 Data
			.byte $00, $1e, $2a, $00	; $a9e4: 00 1e 2a 00	 Data
			.byte $1c, $28, $1b, $e8	; $a9e8: 1c 28 1b e8	 Data
			.byte $23, $89, $f4, $31	; $a9ec: 23 89 f4 31	 Data
			.byte $e0, $60, $88, $07	; $a9f0: e0 60 88 07	 Data
			.byte $8a, $fe, $31, $ee	; $a9f4: 8a fe 31 ee	 Data
			.byte $38, $ea, $36, $34	; $a9f8: 38 ea 36 34	 Data
			.byte $e8, $33, $ee, $2f	; $a9fc: e8 33 ee 2f	 Data
			.byte $2d, $31, $ea, $2f	; $aa00: 2d 31 ea 2f	 Data
			.byte $2d, $e8, $2c, $ee	; $aa04: 2d e8 2c ee	 Data
			.byte $2f, $31, $38, $ea	; $aa08: 2f 31 38 ea	 Data
			.byte $36, $34, $e8, $3b	; $aa0c: 36 34 e8 3b	 Data
			.byte $ee, $38, $3d, $e6	; $aa10: ee 38 3d e6	 Data
			.byte $3b, $39, $38, $36	; $aa14: 3b 39 38 36	 Data
			.byte $34, $38, $ee, $33	; $aa18: 34 38 ee 33	 Data
			.byte $80, $91, $a9, $8d	; $aa1c: 80 91 a9 8d	 Data
			.byte $70, $10, $19, $e3	; $aa20: 70 10 19 e3	 Data
			.byte $00, $81, $70, $22	; $aa24: 00 81 70 22	 Data
			.byte $aa, $8d, $70, $10	; $aa28: aa 8d 70 10	 Data
			.byte $14, $e3, $00, $81	; $aa2c: 14 e3 00 81	 Data
			.byte $70, $2c, $aa, $8d	; $aa30: 70 2c aa 8d	 Data
			.byte $70, $10, $17, $e3	; $aa34: 70 10 17 e3	 Data
			.byte $00, $81, $70, $36	; $aa38: 00 81 70 36	 Data
			.byte $aa, $8d, $70, $10	; $aa3c: aa 8d 70 10	 Data
			.byte $14, $e3, $00, $81	; $aa40: 14 e3 00 81	 Data
			.byte $70, $40, $aa, $8d	; $aa44: 70 40 aa 8d	 Data
			.byte $70, $10, $19, $e3	; $aa48: 70 10 19 e3	 Data
			.byte $00, $81, $70, $4a	; $aa4c: 00 81 70 4a	 Data
			.byte $aa, $8d, $70, $10	; $aa50: aa 8d 70 10	 Data
			.byte $14, $e3, $00, $81	; $aa54: 14 e3 00 81	 Data
			.byte $70, $54, $aa, $8d	; $aa58: 70 54 aa 8d	 Data
			.byte $70, $02, $1c, $e3	; $aa5c: 70 02 1c e3	 Data
			.byte $00, $1c, $e5, $00	; $aa60: 00 1c e5 00	 Data
			.byte $1b, $e3, $00, $1b	; $aa64: 1b e3 00 1b	 Data
			.byte $e5, $00, $19, $e3	; $aa68: e5 00 19 e3	 Data
			.byte $00, $19, $e5, $00	; $aa6c: 00 19 e5 00	 Data
			.byte $17, $00, $14, $00	; $aa70: 17 00 14 00	 Data
			.byte $81, $70, $5e, $aa	; $aa74: 81 70 5e aa	 Data
			.byte $14, $e3, $00, $14	; $aa78: 14 e3 00 14	 Data
			.byte $e5, $00, $19, $e3	; $aa7c: e5 00 19 e3	 Data
			.byte $00, $19, $e5, $00	; $aa80: 00 19 e5 00	 Data
			.byte $1c, $e3, $00, $1c	; $aa84: 1c e3 00 1c	 Data
			.byte $e5, $00, $1b, $00	; $aa88: e5 00 1b 00	 Data
			.byte $17, $00, $8d, $70	; $aa8c: 17 00 8d 70	 Data
			.byte $08, $19, $e3, $00	; $aa90: 08 19 e3 00	 Data
			.byte $81, $70, $91, $aa	; $aa94: 81 70 91 aa	 Data
			.byte $00, $ee, $8d, $70	; $aa98: 00 ee 8d 70	 Data
			.byte $10, $19, $e3, $00	; $aa9c: 10 19 e3 00	 Data
			.byte $81, $70, $9d, $aa	; $aaa0: 81 70 9d aa	 Data
			.byte $8d, $70, $10, $1b	; $aaa4: 8d 70 10 1b	 Data
			.byte $e3, $00, $81, $70	; $aaa8: e3 00 81 70	 Data
			.byte $a7, $aa, $8d, $70	; $aaac: a7 aa 8d 70	 Data
			.byte $10, $1c, $e3, $00	; $aab0: 10 1c e3 00	 Data
			.byte $81, $70, $b1, $aa	; $aab4: 81 70 b1 aa	 Data
			.byte $8d, $70, $10, $1b	; $aab8: 8d 70 10 1b	 Data
			.byte $e3, $00, $81, $70	; $aabc: e3 00 81 70	 Data
			.byte $bb, $aa, $8d, $70	; $aac0: bb aa 8d 70	 Data
			.byte $10, $1c, $e3, $00	; $aac4: 10 1c e3 00	 Data
			.byte $81, $70, $c5, $aa	; $aac8: 81 70 c5 aa	 Data
			.byte $8d, $70, $10, $17	; $aacc: 8d 70 10 17	 Data
			.byte $e3, $00, $81, $70	; $aad0: e3 00 81 70	 Data
			.byte $cf, $aa, $17, $e4	; $aad4: cf aa 17 e4	 Data
			.byte $00, $21, $00, $14	; $aad8: 00 21 00 14	 Data
			.byte $00, $19, $00, $1c	; $aadc: 00 19 00 1c	 Data
			.byte $00, $1b, $00, $8d	; $aae0: 00 1b 00 8d	 Data
			.byte $70, $08, $14, $e3	; $aae4: 70 08 14 e3	 Data
			.byte $00, $81, $70, $e6	; $aae8: 00 81 70 e6	 Data
			.byte $aa, $8d, $70, $08	; $aaec: aa 8d 70 08	 Data
			.byte $1b, $e3, $00, $81	; $aaf0: 1b e3 00 81	 Data
			.byte $70, $f0, $aa, $80	; $aaf4: 70 f0 aa 80	 Data
			.byte $1f, $aa, $8d, $70	; $aaf8: 1f aa 8d 70	 Data
			.byte $0c, $c1, $e5, $c1	; $aafc: 0c c1 e5 c1	 Data
			.byte $c0, $c1, $c1, $c1	; $ab00: c0 c1 c1 c1	 Data
			.byte $c0, $c1, $81, $70	; $ab04: c0 c1 81 70	 Data
			.byte $fd, $aa, $8d, $70	; $ab08: fd aa 8d 70	 Data
			.byte $02, $c0, $e5, $c0	; $ab0c: 02 c0 e5 c0	 Data
			.byte $c1, $c0, $c0, $c1	; $ab10: c1 c0 c0 c1	 Data
			.byte $c0, $c0, $c1, $c0	; $ab14: c0 c0 c1 c0	 Data
			.byte $c0, $c0, $c0, $81	; $ab18: c0 c0 c0 81	 Data
			.byte $70, $0d, $ab, $c0	; $ab1c: 70 0d ab c0	 Data
			.byte $c0, $c1, $c0, $c0	; $ab20: c0 c1 c0 c0	 Data
			.byte $c1, $c0, $c0, $c1	; $ab24: c1 c0 c0 c1	 Data
			.byte $c0, $c0, $c0, $c0	; $ab28: c0 c0 c0 c0	 Data
			.byte $c0, $ea, $c0, $c0	; $ab2c: c0 ea c0 c0	 Data
			.byte $e5, $c0, $00, $eb	; $ab30: e5 c0 00 eb	 Data
			.byte $c0, $e3, $c0, $c0	; $ab34: c0 e3 c0 c0	 Data
			.byte $c0, $c0, $c0, $c0	; $ab38: c0 c0 c0 c0	 Data
			.byte $e5, $8d, $70, $0c	; $ab3c: e5 8d 70 0c	 Data
			.byte $c1, $e5, $c1, $c0	; $ab40: c1 e5 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ab44: c1 c1 c1 c0	 Data
			.byte $c1, $81, $70, $40	; $ab48: c1 81 70 40	 Data
			.byte $ab, $c0, $c1, $e3	; $ab4c: ab c0 c1 e3	 Data
			.byte $c0, $e5, $c1, $e3	; $ab50: c0 e5 c1 e3	 Data
			.byte $c0, $e5, $c1, $e3	; $ab54: c0 e5 c1 e3	 Data
			.byte $c0, $e5, $c1, $e3	; $ab58: c0 e5 c1 e3	 Data
			.byte $c0, $c0, $c0, $e5	; $ab5c: c0 c0 c0 e5	 Data
			.byte $c1, $c1, $c0, $c1	; $ab60: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $ab64: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $ab68: c1 c1 c0 c1	 Data
			.byte $c0, $c1, $c0, $e3	; $ab6c: c0 c1 c0 e3	 Data
			.byte $c0, $c0, $e5, $80	; $ab70: c0 c0 e5 80	 Data
			.byte $fa, $aa, $04, $00	; $ab74: fa aa 04 00	 Data
			.byte $01, $bf, $09, $40	; $ab78: 01 bf 09 40	 Data
			.byte $0c, $9e, $00, $9f	; $ab7c: 0c 9e 00 9f	 Data
			.byte $ab, $01, $01, $bf	; $ab80: ab 01 01 bf	 Data
			.byte $04, $40, $0c, $9e	; $ab84: 04 40 0c 9e	 Data
			.byte $01, $e5, $ab, $02	; $ab88: 01 e5 ab 02	 Data
			.byte $01, $bf, $02, $40	; $ab8c: 01 bf 02 40	 Data
			.byte $18, $9e, $02, $1e	; $ab90: 18 9e 02 1e	 Data
			.byte $ac, $03, $02, $3f	; $ab94: ac 03 02 3f	 Data
			.byte $04, $40, $00, $9e	; $ab98: 04 40 00 9e	 Data
			.byte $03, $56, $ac, $8d	; $ab9c: 03 56 ac 8d	 Data
			.byte $70, $03, $25, $e5	; $aba0: 70 03 25 e5	 Data
			.byte $00, $2c, $00, $25	; $aba4: 00 2c 00 25	 Data
			.byte $2d, $00, $25, $00	; $aba8: 2d 00 25 00	 Data
			.byte $2f, $00, $25, $00	; $abac: 2f 00 25 00	 Data
			.byte $31, $00, $9c, $03	; $abb0: 31 00 9c 03	 Data
			.byte $a2, $ac, $81, $70	; $abb4: a2 ac 81 70	 Data
			.byte $a2, $ab, $20, $ea	; $abb8: a2 ab 20 ea	 Data
			.byte $23, $25, $e8, $28	; $abbc: 23 25 e8 28	 Data
			.byte $2c, $2f, $33, $00	; $abc0: 2c 2f 33 00	 Data
			.byte $eb, $00, $ea, $00	; $abc4: eb 00 ea 00	 Data
			.byte $ee, $8d, $70, $01	; $abc8: ee 8d 70 01	 Data
			.byte $31, $e5, $34, $33	; $abcc: 31 e5 34 33	 Data
			.byte $36, $e8, $34, $81	; $abd0: 36 e8 34 81	 Data
			.byte $70, $de, $ab, $33	; $abd4: 70 de ab 33	 Data
			.byte $31, $2f, $2c, $80	; $abd8: 31 2f 2c 80	 Data
			.byte $cc, $ab, $38, $36	; $abdc: cc ab 38 36	 Data
			.byte $39, $38, $80, $9f	; $abe0: 39 38 80 9f	 Data
			.byte $ab, $8d, $70, $03	; $abe4: ab 8d 70 03	 Data
			.byte $31, $e5, $2c, $38	; $abe8: 31 e5 2c 38	 Data
			.byte $2c, $31, $38, $2c	; $abec: 2c 31 38 2c	 Data
			.byte $31, $2f, $39, $2f	; $abf0: 31 2f 39 2f	 Data
			.byte $31, $31, $25, $31	; $abf4: 31 31 25 31	 Data
			.byte $9c, $03, $a5, $ac	; $abf8: 9c 03 a5 ac	 Data
			.byte $81, $70, $e8, $ab	; $abfc: 81 70 e8 ab	 Data
			.byte $33, $ea, $2f, $2c	; $ac00: 33 ea 2f 2c	 Data
			.byte $e8, $28, $25, $23	; $ac04: e8 28 25 23	 Data
			.byte $20, $8d, $70, $03	; $ac08: 20 8d 70 03	 Data
			.byte $25, $e8, $28, $27	; $ac0c: 25 e8 28 27	 Data
			.byte $e5, $28, $e8, $2a	; $ac10: e5 28 e8 2a	 Data
			.byte $28, $27, $23, $81	; $ac14: 28 27 23 81	 Data
			.byte $70, $0c, $ac, $80	; $ac18: 70 0c ac 80	 Data
			.byte $e5, $ab, $8d, $70	; $ac1c: e5 ab 8d 70	 Data
			.byte $03, $19, $e8, $20	; $ac20: 03 19 e8 20	 Data
			.byte $19, $e5, $21, $e8	; $ac24: 19 e5 21 e8	 Data
			.byte $19, $23, $19, $25	; $ac28: 19 23 19 25	 Data
			.byte $9c, $03, $a8, $ac	; $ac2c: 9c 03 a8 ac	 Data
			.byte $81, $70, $21, $ac	; $ac30: 81 70 21 ac	 Data
			.byte $14, $14, $e5, $17	; $ac34: 14 14 e5 17	 Data
			.byte $e8, $17, $e5, $19	; $ac38: e8 17 e5 19	 Data
			.byte $e8, $1c, $20, $17	; $ac3c: e8 1c 20 17	 Data
			.byte $1b, $8d, $70, $03	; $ac40: 1b 8d 70 03	 Data
			.byte $19, $e8, $1c, $1b	; $ac44: 19 e8 1c 1b	 Data
			.byte $e5, $1c, $e8, $1e	; $ac48: e5 1c e8 1e	 Data
			.byte $1c, $1b, $17, $81	; $ac4c: 1c 1b 17 81	 Data
			.byte $70, $44, $ac, $80	; $ac50: 70 44 ac 80	 Data
			.byte $1e, $ac, $8d, $70	; $ac54: 1e ac 8d 70	 Data
			.byte $03, $c1, $e5, $c1	; $ac58: 03 c1 e5 c1	 Data
			.byte $c0, $c1, $c1, $c0	; $ac5c: c0 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ac60: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ac64: c1 c1 c1 c0	 Data
			.byte $c1, $81, $70, $59	; $ac68: c1 81 70 59	 Data
			.byte $ac, $c1, $c1, $c0	; $ac6c: ac c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ac70: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ac74: c1 c1 c1 c0	 Data
			.byte $c1, $c0, $c1, $c0	; $ac78: c1 c0 c1 c0	 Data
			.byte $e3, $c0, $c0, $e5	; $ac7c: e3 c0 c0 e5	 Data
			.byte $00, $eb, $00, $ea	; $ac80: 00 eb 00 ea	 Data
			.byte $00, $ee, $00, $eb	; $ac84: 00 ee 00 eb	 Data
			.byte $00, $ea, $00, $ee	; $ac88: 00 ea 00 ee	 Data
			.byte $c1, $e5, $c1, $c0	; $ac8c: c1 e5 c1 c0	 Data
			.byte $c1, $c1, $c0, $c1	; $ac90: c1 c1 c0 c1	 Data
			.byte $c1, $c1, $c0, $c1	; $ac94: c1 c1 c0 c1	 Data
			.byte $c0, $c1, $c0, $e3	; $ac98: c0 c1 c0 e3	 Data
			.byte $c0, $c0, $e5, $80	; $ac9c: c0 c0 e5 80	 Data
			.byte $56, $ac, $fb, $fe	; $aca0: 56 ac fb fe	 Data
			.byte $07, $fb, $fe, $07	; $aca4: 07 fb fe 07	 Data
			.byte $fb, $fe, $07, $04	; $aca8: fb fe 07 04	 Data
			.byte $00, $01, $7f, $09	; $acac: 00 01 7f 09	 Data
			.byte $40, $04, $73, $00	; $acb0: 40 04 73 00	 Data
			.byte $d4, $ac, $01, $01	; $acb4: d4 ac 01 01	 Data
			.byte $7f, $07, $41, $04	; $acb8: 7f 07 41 04	 Data
			.byte $73, $01, $02, $ad	; $acbc: 73 01 02 ad	 Data
			.byte $02, $01, $3f, $03	; $acc0: 02 01 3f 03	 Data
			.byte $40, $10, $73, $02	; $acc4: 40 10 73 02	 Data
			.byte $34, $ad, $03, $02	; $acc8: 34 ad 03 02	 Data
			.byte $3f, $04, $40, $00	; $accc: 3f 04 40 00	 Data
			.byte $73, $03, $af, $ad	; $acd0: 73 03 af ad	 Data
			.byte $2c, $ea, $34, $33	; $acd4: 2c ea 34 33	 Data
			.byte $e8, $32, $ea, $33	; $acd8: e8 32 ea 33	 Data
			.byte $2f, $e8, $2a, $ea	; $acdc: 2f e8 2a ea	 Data
			.byte $2d, $e0, $1e, $31	; $ace0: 2d e0 1e 31	 Data
			.byte $ea, $2d, $34, $e8	; $ace4: ea 2d 34 e8	 Data
			.byte $33, $ea, $32, $2f	; $ace8: 33 ea 32 2f	 Data
			.byte $e8, $2c, $ea, $28	; $acec: e8 2c ea 28	 Data
			.byte $27, $e8, $2e, $ea	; $acf0: 27 e8 2e ea	 Data
			.byte $31, $e0, $1e, $34	; $acf4: 31 e0 1e 34	 Data
			.byte $ea, $33, $e0, $1e	; $acf8: ea 33 e0 1e	 Data
			.byte $2c, $e0, $c0, $80	; $acfc: 2c e0 c0 80	 Data
			.byte $d4, $ac, $00, $e4	; $ad00: d4 ac 00 e4	 Data
			.byte $2c, $ea, $34, $33	; $ad04: 2c ea 34 33	 Data
			.byte $e8, $32, $ea, $33	; $ad08: e8 32 ea 33	 Data
			.byte $2f, $e8, $2a, $ea	; $ad0c: 2f e8 2a ea	 Data
			.byte $2d, $e0, $1e, $31	; $ad10: 2d e0 1e 31	 Data
			.byte $ea, $2d, $34, $e8	; $ad14: ea 2d 34 e8	 Data
			.byte $33, $ea, $32, $2f	; $ad18: 33 ea 32 2f	 Data
			.byte $e8, $2c, $ea, $28	; $ad1c: e8 2c ea 28	 Data
			.byte $27, $e8, $2e, $ea	; $ad20: 27 e8 2e ea	 Data
			.byte $31, $e0, $1e, $34	; $ad24: 31 e0 1e 34	 Data
			.byte $ea, $33, $e0, $1e	; $ad28: ea 33 e0 1e	 Data
			.byte $00, $ee, $00, $00	; $ad2c: 00 ee 00 00	 Data
			.byte $00, $80, $04, $ad	; $ad30: 00 80 04 ad	 Data
			.byte $8d, $70, $02, $20	; $ad34: 8d 70 02 20	 Data
			.byte $e3, $20, $23, $20	; $ad38: e3 20 23 20	 Data
			.byte $27, $20, $20, $20	; $ad3c: 27 20 20 20	 Data
			.byte $23, $20, $27, $20	; $ad40: 23 20 27 20	 Data
			.byte $20, $20, $23, $20	; $ad44: 20 20 23 20	 Data
			.byte $81, $70, $37, $ad	; $ad48: 81 70 37 ad	 Data
			.byte $8d, $70, $02, $1e	; $ad4c: 8d 70 02 1e	 Data
			.byte $e3, $1e, $21, $1e	; $ad50: e3 1e 21 1e	 Data
			.byte $25, $1e, $1e, $1e	; $ad54: 25 1e 1e 1e	 Data
			.byte $21, $1e, $25, $1e	; $ad58: 21 1e 25 1e	 Data
			.byte $1e, $1e, $21, $1e	; $ad5c: 1e 1e 21 1e	 Data
			.byte $81, $70, $4f, $ad	; $ad60: 81 70 4f ad	 Data
			.byte $8d, $70, $02, $20	; $ad64: 8d 70 02 20	 Data
			.byte $e3, $20, $23, $20	; $ad68: e3 20 23 20	 Data
			.byte $27, $20, $20, $20	; $ad6c: 27 20 20 20	 Data
			.byte $23, $20, $27, $20	; $ad70: 23 20 27 20	 Data
			.byte $20, $20, $23, $20	; $ad74: 20 20 23 20	 Data
			.byte $81, $70, $67, $ad	; $ad78: 81 70 67 ad	 Data
			.byte $8d, $70, $02, $22	; $ad7c: 8d 70 02 22	 Data
			.byte $e3, $22, $25, $22	; $ad80: e3 22 25 22	 Data
			.byte $27, $22, $22, $22	; $ad84: 27 22 22 22	 Data
			.byte $25, $22, $27, $22	; $ad88: 25 22 27 22	 Data
			.byte $22, $22, $25, $22	; $ad8c: 22 22 25 22	 Data
			.byte $81, $70, $7f, $ad	; $ad90: 81 70 7f ad	 Data
			.byte $8d, $70, $04, $20	; $ad94: 8d 70 04 20	 Data
			.byte $e3, $20, $23, $20	; $ad98: e3 20 23 20	 Data
			.byte $25, $20, $20, $20	; $ad9c: 25 20 20 20	 Data
			.byte $23, $20, $25, $20	; $ada0: 23 20 25 20	 Data
			.byte $20, $20, $23, $20	; $ada4: 20 20 23 20	 Data
			.byte $81, $70, $97, $ad	; $ada8: 81 70 97 ad	 Data
			.byte $80, $34, $ad, $8d	; $adac: 80 34 ad 8d	 Data
			.byte $70, $07, $c1, $e3	; $adb0: 70 07 c1 e3	 Data
			.byte $c1, $c1, $c1, $c0	; $adb4: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c1	; $adb8: c1 c1 c1 c1	 Data
			.byte $c1, $c1, $c1, $c0	; $adbc: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $81	; $adc0: c1 c1 c1 81	 Data
			.byte $70, $b2, $ad, $c0	; $adc4: 70 b2 ad c0	 Data
			.byte $c0, $c1, $c0, $c0	; $adc8: c0 c1 c0 c0	 Data
			.byte $c1, $c0, $c0, $c1	; $adcc: c1 c0 c0 c1	 Data
			.byte $c0, $c0, $c1, $c0	; $add0: c0 c0 c1 c0	 Data
			.byte $c0, $c0, $c0, $8d	; $add4: c0 c0 c0 8d	 Data
			.byte $70, $03, $c0, $e3	; $add8: 70 03 c0 e3	 Data
			.byte $c1, $c1, $c1, $c0	; $addc: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ade0: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $c0	; $ade4: c1 c1 c1 c0	 Data
			.byte $c1, $c1, $c1, $81	; $ade8: c1 c1 c1 81	 Data
			.byte $70, $da, $ad, $c0	; $adec: 70 da ad c0	 Data
			.byte $c0, $c1, $c0, $c0	; $adf0: c0 c1 c0 c0	 Data
			.byte $c1, $c0, $c0, $c1	; $adf4: c1 c0 c0 c1	 Data
			.byte $c0, $c0, $c1, $c0	; $adf8: c0 c0 c1 c0	 Data
			.byte $c0, $c0, $c0, $80	; $adfc: c0 c0 c0 80	 Data
			.byte $af, $ad, $04, $00	; $ae00: af ad 04 00	 Data
			.byte $01, $7f, $01, $41	; $ae04: 01 7f 01 41	 Data
			.byte $f3, $80, $00, $2b	; $ae08: f3 80 00 2b	 Data
			.byte $ae, $01, $01, $3d	; $ae0c: ae 01 01 3d	 Data
			.byte $02, $40, $ff, $80	; $ae10: 02 40 ff 80	 Data
			.byte $01, $87, $ae, $02	; $ae14: 01 87 ae 02	 Data
			.byte $01, $bf, $02, $40	; $ae18: 01 bf 02 40	 Data
			.byte $17, $80, $02, $c2	; $ae1c: 17 80 02 c2	 Data
			.byte $ae, $03, $02, $3f	; $ae20: ae 03 02 3f	 Data
			.byte $04, $40, $00, $80	; $ae24: 04 40 00 80	 Data
			.byte $03, $01, $af, $2c	; $ae28: 03 01 af 2c	 Data
			.byte $e0, $2a, $2e, $e5	; $ae2c: e0 2a 2e e5	 Data
			.byte $2f, $eb, $36, $e8	; $ae30: 2f eb 36 e8	 Data
			.byte $35, $34, $ee, $3b	; $ae34: 35 34 ee 3b	 Data
			.byte $ed, $00, $e8, $2b	; $ae38: ed 00 e8 2b	 Data
			.byte $e0, $2a, $2d, $e5	; $ae3c: e0 2a 2d e5	 Data
			.byte $2e, $eb, $35, $e8	; $ae40: 2e eb 35 e8	 Data
			.byte $34, $33, $ee, $2e	; $ae44: 34 33 ee 2e	 Data
			.byte $8d, $70, $01, $2f	; $ae48: 8d 70 01 2f	 Data
			.byte $e5, $2e, $2c, $e8	; $ae4c: e5 2e 2c e8	 Data
			.byte $2f, $e5, $2e, $2c	; $ae50: 2f e5 2e 2c	 Data
			.byte $e8, $2f, $e5, $2e	; $ae54: e8 2f e5 2e	 Data
			.byte $2f, $31, $e8, $2f	; $ae58: 2f 31 e8 2f	 Data
			.byte $e5, $2e, $2c, $81	; $ae5c: e5 2e 2c 81	 Data
			.byte $70, $79, $ae, $31	; $ae60: 70 79 ae 31	 Data
			.byte $2f, $2e, $e8, $31	; $ae64: 2f 2e e8 31	 Data
			.byte $e5, $2f, $2e, $e8	; $ae68: e5 2f 2e e8	 Data
			.byte $31, $e5, $2f, $31	; $ae6c: 31 e5 2f 31	 Data
			.byte $33, $e8, $31, $e5	; $ae70: 33 e8 31 e5	 Data
			.byte $2f, $2e, $80, $4b	; $ae74: 2f 2e 80 4b	 Data
			.byte $ae, $2e, $2f, $31	; $ae78: ae 2e 2f 31	 Data
			.byte $33, $34, $36, $38	; $ae7c: 33 34 36 38	 Data
			.byte $3a, $3b, $eb, $3a	; $ae80: 3a 3b eb 3a	 Data
			.byte $80, $2b, $ae, $8d	; $ae84: 80 2b ae 8d	 Data
			.byte $70, $08, $20, $e3	; $ae88: 70 08 20 e3	 Data
			.byte $20, $2c, $20, $20	; $ae8c: 20 2c 20 20	 Data
			.byte $2c, $20, $20, $2c	; $ae90: 2c 20 20 2c	 Data
			.byte $20, $20, $2c, $20	; $ae94: 20 20 2c 20	 Data
			.byte $2c, $20, $20, $9c	; $ae98: 2c 20 20 9c	 Data
			.byte $08, $24, $af, $81	; $ae9c: 08 24 af 81	 Data
			.byte $70, $8a, $ae, $8d	; $aea0: 70 8a ae 8d	 Data
			.byte $70, $08, $20, $e3	; $aea4: 70 08 20 e3	 Data
			.byte $2c, $20, $2c, $20	; $aea8: 2c 20 2c 20	 Data
			.byte $2c, $20, $2c, $20	; $aeac: 2c 20 2c 20	 Data
			.byte $2c, $20, $2c, $20	; $aeb0: 2c 20 2c 20	 Data
			.byte $2c, $20, $2c, $9c	; $aeb4: 2c 20 2c 9c	 Data
			.byte $08, $2c, $af, $81	; $aeb8: 08 2c af 81	 Data
			.byte $70, $a6, $ae, $80	; $aebc: 70 a6 ae 80	 Data
			.byte $87, $ae, $8d, $70	; $aec0: 87 ae 8d 70	 Data
			.byte $04, $17, $e5, $16	; $aec4: 04 17 e5 16	 Data
			.byte $14, $14, $81, $70	; $aec8: 14 14 81 70	 Data
			.byte $c5, $ae, $8d, $70	; $aecc: c5 ae 8d 70	 Data
			.byte $04, $14, $e5, $12	; $aed0: 04 14 e5 12	 Data
			.byte $10, $10, $81, $70	; $aed4: 10 10 81 70	 Data
			.byte $d1, $ae, $8d, $70	; $aed8: d1 ae 8d 70	 Data
			.byte $08, $16, $e5, $15	; $aedc: 08 16 e5 15	 Data
			.byte $13, $13, $9c, $08	; $aee0: 13 13 9c 08	 Data
			.byte $34, $af, $81, $70	; $aee4: 34 af 81 70	 Data
			.byte $dd, $ae, $8d, $70	; $aee8: dd ae 8d 70	 Data
			.byte $08, $14, $e5, $14	; $aeec: 08 14 e5 14	 Data
			.byte $14, $14, $14, $14	; $aef0: 14 14 14 14	 Data
			.byte $14, $14, $9c, $08	; $aef4: 14 14 9c 08	 Data
			.byte $3c, $af, $81, $70	; $aef8: 3c af 81 70	 Data
			.byte $ed, $ae, $80, $c2	; $aefc: ed ae 80 c2	 Data
			.byte $ae, $8a, $fb, $c0	; $af00: ae 8a fb c0	 Data
			.byte $e3, $c0, $c0, $e5	; $af04: e3 c0 c0 e5	 Data
			.byte $8a, $05, $c0, $e3	; $af08: 8a 05 c0 e3	 Data
			.byte $8a, $fb, $c0, $c0	; $af0c: 8a fb c0 c0	 Data
			.byte $e5, $c0, $e3, $c0	; $af10: e5 c0 e3 c0	 Data
			.byte $c0, $e5, $8a, $05	; $af14: c0 e5 8a 05	 Data
			.byte $c0, $e3, $8a, $fb	; $af18: c0 e3 8a fb	 Data
			.byte $c0, $c0, $e5, $8a	; $af1c: c0 c0 e5 8a	 Data
			.byte $05, $80, $01, $af	; $af20: 05 80 01 af	 Data
			.byte $00, $fc, $00, $03	; $af24: 00 fc 00 03	 Data
			.byte $00, $fc, $00, $05	; $af28: 00 fc 00 05	 Data
			.byte $00, $02, $00, $fe	; $af2c: 00 02 00 fe	 Data
			.byte $00, $02, $00, $fe	; $af30: 00 02 00 fe	 Data
			.byte $00, $00, $00, $fc	; $af34: 00 00 00 fc	 Data
			.byte $00, $00, $00, $04	; $af38: 00 00 00 04	 Data
			.byte $00, $02, $00, $fe	; $af3c: 00 02 00 fe	 Data
			.byte $00, $02, $00, $fe	; $af40: 00 02 00 fe	 Data
			.byte $04, $00, $01, $bf	; $af44: 04 00 01 bf	 Data
			.byte $01, $41, $00, $80	; $af48: 01 41 00 80	 Data
			.byte $00, $6d, $af, $02	; $af4c: 00 6d af 02	 Data
			.byte $01, $bf, $02, $40	; $af50: 01 bf 02 40	 Data
			.byte $0c, $80, $02, $95	; $af54: 0c 80 02 95	 Data
			.byte $af, $01, $01, $be	; $af58: af 01 01 be	 Data
			.byte $01, $40, $00, $80	; $af5c: 01 40 00 80	 Data
			.byte $01, $b5, $af, $03	; $af60: 01 b5 af 03	 Data
			.byte $02, $3e, $04, $40	; $af64: 02 3e 04 40	 Data
			.byte $00, $80, $03, $dd	; $af68: 00 80 03 dd	 Data
			.byte $af, $29, $e8, $00	; $af6c: af 29 e8 00	 Data
			.byte $e4, $00, $2e, $33	; $af70: e4 00 2e 33	 Data
			.byte $2e, $33, $35, $33	; $af74: 2e 33 35 33	 Data
			.byte $35, $2e, $2e, $2e	; $af78: 35 2e 2e 2e	 Data
			.byte $27, $27, $27, $29	; $af7c: 27 27 27 29	 Data
			.byte $29, $29, $2e, $2e	; $af80: 29 29 2e 2e	 Data
			.byte $2e, $33, $e5, $2c	; $af84: 2e 33 e5 2c	 Data
			.byte $2e, $33, $2c, $2e	; $af88: 2e 33 2c 2e	 Data
			.byte $33, $2c, $29, $e4	; $af8c: 33 2c 29 e4	 Data
			.byte $2e, $30, $e0, $28	; $af90: 2e 30 e0 28	 Data
			.byte $82, $00, $ee, $29	; $af94: 82 00 ee 29	 Data
			.byte $e8, $00, $e4, $00	; $af98: e8 00 e4 00	 Data
			.byte $2e, $33, $2e, $33	; $af9c: 2e 33 2e 33	 Data
			.byte $35, $33, $35, $2e	; $afa0: 35 33 35 2e	 Data
			.byte $e5, $27, $29, $2e	; $afa4: e5 27 29 2e	 Data
			.byte $27, $29, $2e, $27	; $afa8: 27 29 2e 27	 Data
			.byte $2e, $e4, $30, $35	; $afac: 2e e4 30 35	 Data
			.byte $e0, $28, $91, $01	; $afb0: e0 28 91 01	 Data
			.byte $82, $00, $e5, $29	; $afb4: 82 00 e5 29	 Data
			.byte $e8, $00, $e4, $00	; $afb8: e8 00 e4 00	 Data
			.byte $2e, $33, $2e, $33	; $afbc: 2e 33 2e 33	 Data
			.byte $35, $33, $35, $2e	; $afc0: 35 33 35 2e	 Data
			.byte $e8, $27, $29, $2e	; $afc4: e8 27 29 2e	 Data
			.byte $e5, $8a, $00, $29	; $afc8: e5 8a 00 29	 Data
			.byte $e8, $00, $e4, $00	; $afcc: e8 00 e4 00	 Data
			.byte $2e, $33, $2e, $33	; $afd0: 2e 33 2e 33	 Data
			.byte $35, $33, $35, $3a	; $afd4: 35 33 35 3a	 Data
			.byte $3c, $41, $e0, $28	; $afd8: 3c 41 e0 28	 Data
			.byte $82, $00, $e4, $00	; $afdc: 82 00 e4 00	 Data
			.byte $00, $00, $00, $00	; $afe0: 00 00 00 00	 Data
			.byte $c0, $8a, $fb, $c0	; $afe4: c0 8a fb c0	 Data
			.byte $c0, $8a, $05, $c0	; $afe8: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $c0	; $afec: 8a fb c0 c0	 Data
			.byte $8d, $70, $02, $c0	; $aff0: 8d 70 02 c0	 Data
			.byte $e4, $c0, $c0, $8a	; $aff4: e4 c0 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $aff8: 05 c0 8a fb	 Data
			.byte $c0, $c0, $c0, $c0	; $affc: c0 c0 c0 c0	 Data
			.byte $c0, $8a, $05, $c0	; $b000: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $c0	; $b004: 8a fb c0 c0	 Data
			.byte $81, $70, $f3, $af	; $b008: 81 70 f3 af	 Data
			.byte $8a, $05, $c0, $e2	; $b00c: 8a 05 c0 e2	 Data
			.byte $c0, $c0, $e4, $c0	; $b010: c0 c0 e4 c0	 Data
			.byte $82, $04, $00, $01	; $b014: 82 04 00 01	 Data
			.byte $7f, $01, $40, $08	; $b018: 7f 01 40 08	 Data
			.byte $66, $00, $3e, $b0	; $b01c: 66 00 3e b0	 Data
			.byte $01, $01, $bd, $03	; $b020: 01 01 bd 03	 Data
			.byte $40, $08, $66, $01	; $b024: 40 08 66 01	 Data
			.byte $74, $b0, $02, $01	; $b028: 74 b0 02 01	 Data
			.byte $bf, $03, $40, $08	; $b02c: bf 03 40 08	 Data
			.byte $66, $02, $ef, $b0	; $b030: 66 02 ef b0	 Data
			.byte $03, $02, $3d, $03	; $b034: 03 02 3d 03	 Data
			.byte $40, $00, $66, $03	; $b038: 40 00 66 03	 Data
			.byte $80, $b1, $33, $ea	; $b03c: 80 b1 33 ea	 Data
			.byte $34, $e5, $32, $00	; $b040: 34 e5 32 00	 Data
			.byte $33, $ea, $36, $e5	; $b044: 33 ea 36 e5	 Data
			.byte $34, $00, $33, $ea	; $b048: 34 00 33 ea	 Data
			.byte $32, $e5, $2f, $00	; $b04c: 32 e5 2f 00	 Data
			.byte $2c, $ed, $38, $ea	; $b050: 2c ed 38 ea	 Data
			.byte $37, $e5, $34, $00	; $b054: 37 e5 34 00	 Data
			.byte $33, $ed, $33, $ea	; $b058: 33 ed 33 ea	 Data
			.byte $2f, $e5, $32, $00	; $b05c: 2f e5 32 00	 Data
			.byte $33, $ed, $2c, $ea	; $b060: 33 ed 2c ea	 Data
			.byte $2f, $e5, $2c, $00	; $b064: 2f e5 2c 00	 Data
			.byte $32, $eb, $2f, $e8	; $b068: 32 eb 2f e8	 Data
			.byte $2c, $2f, $32, $33	; $b06c: 2c 2f 32 33	 Data
			.byte $ed, $80, $3e, $b0	; $b070: ed 80 3e b0	 Data
			.byte $8d, $70, $09, $38	; $b074: 8d 70 09 38	 Data
			.byte $e3, $3b, $3d, $3b	; $b078: e3 3b 3d 3b	 Data
			.byte $81, $70, $77, $b0	; $b07c: 81 70 77 b0	 Data
			.byte $8d, $70, $03, $33	; $b080: 8d 70 03 33	 Data
			.byte $e3, $37, $3a, $37	; $b084: e3 37 3a 37	 Data
			.byte $81, $70, $83, $b0	; $b088: 81 70 83 b0	 Data
			.byte $8d, $70, $03, $38	; $b08c: 8d 70 03 38	 Data
			.byte $e3, $3b, $3d, $3b	; $b090: e3 3b 3d 3b	 Data
			.byte $81, $70, $8f, $b0	; $b094: 81 70 8f b0	 Data
			.byte $8d, $70, $03, $3b	; $b098: 8d 70 03 3b	 Data
			.byte $e3, $3f, $40, $3f	; $b09c: e3 3f 40 3f	 Data
			.byte $81, $70, $9b, $b0	; $b0a0: 81 70 9b b0	 Data
			.byte $8d, $70, $03, $38	; $b0a4: 8d 70 03 38	 Data
			.byte $e3, $3b, $3d, $3b	; $b0a8: e3 3b 3d 3b	 Data
			.byte $81, $70, $a7, $b0	; $b0ac: 81 70 a7 b0	 Data
			.byte $8d, $70, $03, $33	; $b0b0: 8d 70 03 33	 Data
			.byte $e3, $37, $3a, $37	; $b0b4: e3 37 3a 37	 Data
			.byte $81, $70, $b3, $b0	; $b0b8: 81 70 b3 b0	 Data
			.byte $8d, $70, $03, $31	; $b0bc: 8d 70 03 31	 Data
			.byte $e3, $34, $38, $34	; $b0c0: e3 34 38 34	 Data
			.byte $81, $70, $bf, $b0	; $b0c4: 81 70 bf b0	 Data
			.byte $8d, $70, $03, $34	; $b0c8: 8d 70 03 34	 Data
			.byte $e3, $38, $3b, $38	; $b0cc: e3 38 3b 38	 Data
			.byte $81, $70, $cb, $b0	; $b0d0: 81 70 cb b0	 Data
			.byte $8d, $70, $03, $38	; $b0d4: 8d 70 03 38	 Data
			.byte $e3, $3b, $3e, $3b	; $b0d8: e3 3b 3e 3b	 Data
			.byte $81, $70, $d7, $b0	; $b0dc: 81 70 d7 b0	 Data
			.byte $8d, $70, $03, $3b	; $b0e0: 8d 70 03 3b	 Data
			.byte $e3, $3d, $3f, $3d	; $b0e4: e3 3d 3f 3d	 Data
			.byte $81, $70, $e3, $b0	; $b0e8: 81 70 e3 b0	 Data
			.byte $80, $74, $b0, $8d	; $b0ec: 80 74 b0 8d	 Data
			.byte $70, $01, $20, $e3	; $b0f0: 70 01 20 e3	 Data
			.byte $00, $00, $25, $25	; $b0f4: 00 00 25 25	 Data
			.byte $00, $20, $00, $00	; $b0f8: 00 20 00 00	 Data
			.byte $25, $00, $00, $81	; $b0fc: 25 00 00 81	 Data
			.byte $70, $12, $b1, $23	; $b100: 70 12 b1 23	 Data
			.byte $00, $00, $28, $28	; $b104: 00 00 28 28	 Data
			.byte $00, $23, $00, $00	; $b108: 00 23 00 00	 Data
			.byte $28, $00, $00, $80	; $b10c: 28 00 00 80	 Data
			.byte $f2, $b0, $1b, $00	; $b110: f2 b0 1b 00	 Data
			.byte $00, $22, $22, $00	; $b114: 00 22 22 00	 Data
			.byte $1b, $00, $00, $22	; $b118: 1b 00 00 22	 Data
			.byte $00, $00, $8d, $70	; $b11c: 00 00 8d 70	 Data
			.byte $01, $20, $e3, $00	; $b120: 01 20 e3 00	 Data
			.byte $00, $25, $25, $00	; $b124: 00 25 25 00	 Data
			.byte $20, $00, $00, $25	; $b128: 20 00 00 25	 Data
			.byte $00, $00, $81, $70	; $b12c: 00 00 81 70	 Data
			.byte $41, $b1, $23, $00	; $b130: 41 b1 23 00	 Data
			.byte $00, $28, $28, $00	; $b134: 00 28 28 00	 Data
			.byte $23, $00, $00, $28	; $b138: 23 00 00 28	 Data
			.byte $00, $00, $80, $21	; $b13c: 00 00 80 21	 Data
			.byte $b1, $1b, $00, $00	; $b140: b1 1b 00 00	 Data
			.byte $22, $22, $00, $1b	; $b144: 22 22 00 1b	 Data
			.byte $00, $00, $22, $00	; $b148: 00 00 22 00	 Data
			.byte $00, $19, $00, $00	; $b14c: 00 19 00 00	 Data
			.byte $20, $20, $00, $19	; $b150: 20 20 00 19	 Data
			.byte $00, $00, $20, $00	; $b154: 00 00 20 00	 Data
			.byte $00, $1c, $00, $00	; $b158: 00 1c 00 00	 Data
			.byte $23, $23, $00, $1c	; $b15c: 23 23 00 1c	 Data
			.byte $00, $00, $23, $00	; $b160: 00 00 23 00	 Data
			.byte $00, $20, $00, $00	; $b164: 00 20 00 00	 Data
			.byte $26, $26, $00, $20	; $b168: 26 26 00 20	 Data
			.byte $00, $00, $26, $00	; $b16c: 00 00 26 00	 Data
			.byte $00, $23, $00, $00	; $b170: 00 23 00 00	 Data
			.byte $27, $27, $00, $23	; $b174: 27 27 00 23	 Data
			.byte $00, $00, $27, $00	; $b178: 00 00 27 00	 Data
			.byte $00, $80, $ef, $b0	; $b17c: 00 80 ef b0	 Data
			.byte $c0, $e3, $c1, $c1	; $b180: c0 e3 c1 c1	 Data
			.byte $c0, $c0, $c1, $c0	; $b184: c0 c0 c1 c0	 Data
			.byte $c1, $c1, $c0, $c1	; $b188: c1 c1 c0 c1	 Data
			.byte $c1, $80, $80, $b1	; $b18c: c1 80 80 b1	 Data
			.byte $04, $00, $01, $bf	; $b190: 04 00 01 bf	 Data
			.byte $09, $40, $00, $77	; $b194: 09 40 00 77	 Data
			.byte $00, $b9, $b1, $01	; $b198: 00 b9 b1 01	 Data
			.byte $01, $7e, $01, $41	; $b19c: 01 7e 01 41	 Data
			.byte $00, $77, $01, $5b	; $b1a0: 00 77 01 5b	 Data
			.byte $b2, $02, $01, $be	; $b1a4: b2 02 01 be	 Data
			.byte $01, $40, $0c, $77	; $b1a8: 01 40 0c 77	 Data
			.byte $02, $bb, $b2, $03	; $b1ac: 02 bb b2 03	 Data
			.byte $02, $3f, $04, $40	; $b1b0: 02 3f 04 40	 Data
			.byte $00, $77, $03, $f0	; $b1b4: 00 77 03 f0	 Data
			.byte $b2, $3a, $e5, $00	; $b1b8: b2 3a e5 00	 Data
			.byte $38, $00, $3a, $00	; $b1bc: 38 00 3a 00	 Data
			.byte $38, $3a, $00, $38	; $b1c0: 38 3a 00 38	 Data
			.byte $3a, $00, $3d, $00	; $b1c4: 3a 00 3d 00	 Data
			.byte $3c, $00, $3a, $00	; $b1c8: 3c 00 3a 00	 Data
			.byte $38, $00, $3a, $00	; $b1cc: 38 00 3a 00	 Data
			.byte $38, $33, $00, $33	; $b1d0: 38 33 00 33	 Data
			.byte $ed, $00, $e5, $3a	; $b1d4: ed 00 e5 3a	 Data
			.byte $00, $38, $00, $3a	; $b1d8: 00 38 00 3a	 Data
			.byte $00, $38, $3a, $00	; $b1dc: 00 38 3a 00	 Data
			.byte $38, $3a, $00, $3d	; $b1e0: 38 3a 00 3d	 Data
			.byte $00, $3c, $00, $3a	; $b1e4: 00 3c 00 3a	 Data
			.byte $00, $38, $00, $3a	; $b1e8: 00 38 00 3a	 Data
			.byte $00, $3f, $3f, $00	; $b1ec: 00 3f 3f 00	 Data
			.byte $3f, $eb, $3c, $e5	; $b1f0: 3f eb 3c e5	 Data
			.byte $3d, $00, $3f, $00	; $b1f4: 3d 00 3f 00	 Data
			.byte $41, $ee, $41, $e8	; $b1f8: 41 ee 41 e8	 Data
			.byte $3f, $3d, $3c, $3f	; $b1fc: 3f 3d 3c 3f	 Data
			.byte $ed, $3d, $e5, $3c	; $b200: ed 3d e5 3c	 Data
			.byte $3d, $ee, $3f, $3f	; $b204: 3d ee 3f 3f	 Data
			.byte $e8, $3d, $3c, $e5	; $b208: e8 3d 3c e5	 Data
			.byte $3a, $ea, $38, $e0	; $b20c: 3a ea 38 e0	 Data
			.byte $60, $3a, $e5, $38	; $b210: 60 3a e5 38	 Data
			.byte $3a, $3d, $00, $41	; $b214: 3a 3d 00 41	 Data
			.byte $46, $00, $46, $ee	; $b218: 46 00 46 ee	 Data
			.byte $38, $e5, $36, $38	; $b21c: 38 e5 36 38	 Data
			.byte $3c, $00, $3f, $44	; $b220: 3c 00 3f 44	 Data
			.byte $00, $44, $ee, $3a	; $b224: 00 44 ee 3a	 Data
			.byte $e5, $38, $3a, $3d	; $b228: e5 38 3a 3d	 Data
			.byte $00, $41, $46, $00	; $b22c: 00 41 46 00	 Data
			.byte $46, $eb, $49, $e8	; $b230: 46 eb 49 e8	 Data
			.byte $48, $46, $ed, $48	; $b234: 48 46 ed 48	 Data
			.byte $e8, $3f, $ee, $42	; $b238: e8 3f ee 42	 Data
			.byte $ed, $44, $e5, $42	; $b23c: ed 44 e5 42	 Data
			.byte $42, $e8, $41, $3f	; $b240: 42 e8 41 3f	 Data
			.byte $3d, $41, $ed, $3d	; $b244: 3d 41 ed 3d	 Data
			.byte $e8, $38, $ee, $3f	; $b248: e8 38 ee 3f	 Data
			.byte $ed, $41, $e5, $3f	; $b24c: ed 41 e5 3f	 Data
			.byte $3f, $e8, $41, $42	; $b250: 3f e8 41 42	 Data
			.byte $44, $3d, $ee, $44	; $b254: 44 3d ee 44	 Data
			.byte $80, $b9, $b1, $29	; $b258: 80 b9 b1 29	 Data
			.byte $e0, $60, $27, $ee	; $b25c: e0 60 27 ee	 Data
			.byte $00, $e5, $27, $e0	; $b260: 00 e5 27 e0	 Data
			.byte $2a, $29, $e0, $60	; $b264: 2a 29 e0 60	 Data
			.byte $27, $e0, $6c, $29	; $b268: 27 e0 6c 29	 Data
			.byte $e0, $60, $2a, $2a	; $b26c: e0 60 2a 2a	 Data
			.byte $27, $88, $04, $83	; $b270: 27 88 04 83	 Data
			.byte $00, $8d, $70, $02	; $b274: 00 8d 70 02	 Data
			.byte $35, $e5, $31, $2e	; $b278: 35 e5 31 2e	 Data
			.byte $2a, $35, $31, $2e	; $b27c: 2a 35 31 2e	 Data
			.byte $2a, $35, $31, $2e	; $b280: 2a 35 31 2e	 Data
			.byte $2a, $35, $31, $35	; $b284: 2a 35 31 35	 Data
			.byte $3a, $33, $30, $2c	; $b288: 3a 33 30 2c	 Data
			.byte $29, $33, $30, $2c	; $b28c: 29 33 30 2c	 Data
			.byte $29, $33, $30, $2c	; $b290: 29 33 30 2c	 Data
			.byte $29, $33, $30, $2c	; $b294: 29 33 30 2c	 Data
			.byte $29, $81, $70, $78	; $b298: 29 81 70 78	 Data
			.byte $b2, $88, $01, $83	; $b29c: b2 88 01 83	 Data
			.byte $41, $2a, $e0, $60	; $b2a0: 41 2a e0 60	 Data
			.byte $29, $ee, $29, $e8	; $b2a4: 29 ee 29 e8	 Data
			.byte $2c, $31, $35, $27	; $b2a8: 2c 31 35 27	 Data
			.byte $e0, $60, $25, $ee	; $b2ac: e0 60 25 ee	 Data
			.byte $19, $ea, $1d, $e5	; $b2b0: 19 ea 1d e5	 Data
			.byte $20, $25, $29, $2c	; $b2b4: 20 25 29 2c	 Data
			.byte $80, $5b, $b2, $25	; $b2b8: 80 5b b2 25	 Data
			.byte $e0, $60, $24, $ee	; $b2bc: e0 60 24 ee	 Data
			.byte $00, $e5, $24, $e0	; $b2c0: 00 e5 24 e0	 Data
			.byte $2a, $25, $e0, $60	; $b2c4: 2a 25 e0 60	 Data
			.byte $24, $e0, $6c, $21	; $b2c8: 24 e0 6c 21	 Data
			.byte $e8, $1d, $24, $21	; $b2cc: e8 1d 24 21	 Data
			.byte $27, $25, $24, $21	; $b2d0: 27 25 24 21	 Data
			.byte $25, $ee, $22, $1e	; $b2d4: 25 ee 22 1e	 Data
			.byte $e8, $1b, $22, $1e	; $b2d8: e8 1b 22 1e	 Data
			.byte $27, $25, $24, $22	; $b2dc: 27 25 24 22	 Data
			.byte $20, $ee, $24, $25	; $b2e0: 20 ee 24 25	 Data
			.byte $e0, $60, $24, $25	; $b2e4: e0 60 24 25	 Data
			.byte $24, $27, $25, $23	; $b2e8: 24 27 25 23	 Data
			.byte $20, $80, $bb, $b2	; $b2ec: 20 80 bb b2	 Data
			.byte $8a, $fb, $8d, $70	; $b2f0: 8a fb 8d 70	 Data
			.byte $03, $c0, $e8, $c0	; $b2f4: 03 c0 e8 c0	 Data
			.byte $8a, $05, $c0, $00	; $b2f8: 8a 05 c0 00	 Data
			.byte $e5, $8a, $fb, $c0	; $b2fc: e5 8a fb c0	 Data
			.byte $00, $c0, $8a, $05	; $b300: 00 c0 8a 05	 Data
			.byte $c0, $8a, $fb, $c0	; $b304: c0 8a fb c0	 Data
			.byte $8a, $05, $c0, $e8	; $b308: 8a 05 c0 e8	 Data
			.byte $8a, $fb, $c0, $81	; $b30c: 8a fb c0 81	 Data
			.byte $70, $f5, $b2, $c0	; $b310: 70 f5 b2 c0	 Data
			.byte $c0, $8a, $05, $c0	; $b314: c0 8a 05 c0	 Data
			.byte $00, $e5, $8a, $fb	; $b318: 00 e5 8a fb	 Data
			.byte $c0, $00, $c0, $8a	; $b31c: c0 00 c0 8a	 Data
			.byte $05, $c0, $8a, $fb	; $b320: 05 c0 8a fb	 Data
			.byte $c0, $e8, $8a, $05	; $b324: c0 e8 8a 05	 Data
			.byte $c0, $e5, $8a, $fb	; $b328: c0 e5 8a fb	 Data
			.byte $c0, $8a, $05, $c0	; $b32c: c0 8a 05 c0	 Data
			.byte $c0, $8a, $fb, $c0	; $b330: c0 8a fb c0	 Data
			.byte $8d, $70, $07, $c0	; $b334: 8d 70 07 c0	 Data
			.byte $e8, $c0, $8a, $05	; $b338: e8 c0 8a 05	 Data
			.byte $c0, $00, $e5, $8a	; $b33c: c0 00 e5 8a	 Data
			.byte $fb, $c0, $81, $70	; $b340: fb c0 81 70	 Data
			.byte $37, $b3, $c0, $c0	; $b344: 37 b3 c0 c0	 Data
			.byte $8a, $05, $c0, $e8	; $b348: 8a 05 c0 e8	 Data
			.byte $c0, $e5, $c0, $c0	; $b34c: c0 e5 c0 c0	 Data
			.byte $c0, $8d, $70, $03	; $b350: c0 8d 70 03	 Data
			.byte $c0, $e5, $8a, $fb	; $b354: c0 e5 8a fb	 Data
			.byte $c0, $c0, $8a, $05	; $b358: c0 c0 8a 05	 Data
			.byte $c0, $00, $c0, $c0	; $b35c: c0 00 c0 c0	 Data
			.byte $00, $c0, $e8, $8a	; $b360: 00 c0 e8 8a	 Data
			.byte $fb, $c0, $8a, $05	; $b364: fb c0 8a 05	 Data
			.byte $c0, $8a, $fb, $c0	; $b368: c0 8a fb c0	 Data
			.byte $8a, $05, $81, $70	; $b36c: 8a 05 81 70	 Data
			.byte $54, $b3, $8d, $70	; $b370: 54 b3 8d 70	 Data
			.byte $02, $c0, $e8, $8a	; $b374: 02 c0 e8 8a	 Data
			.byte $fb, $c0, $8a, $05	; $b378: fb c0 8a 05	 Data
			.byte $c0, $8a, $fb, $c0	; $b37c: c0 8a fb c0	 Data
			.byte $8a, $05, $81, $70	; $b380: 8a 05 81 70	 Data
			.byte $75, $b3, $8a, $fb	; $b384: 75 b3 8a fb	 Data
			.byte $8d, $70, $07, $c0	; $b388: 8d 70 07 c0	 Data
			.byte $e8, $c0, $8a, $05	; $b38c: e8 c0 8a 05	 Data
			.byte $c0, $00, $e5, $8a	; $b390: c0 00 e5 8a	 Data
			.byte $fb, $c0, $81, $70	; $b394: fb c0 81 70	 Data
			.byte $8b, $b3, $c0, $c0	; $b398: 8b b3 c0 c0	 Data
			.byte $8a, $05, $c0, $c0	; $b39c: 8a 05 c0 c0	 Data
			.byte $c0, $c0, $c0, $c0	; $b3a0: c0 c0 c0 c0	 Data
			.byte $80, $f0, $b2, $04	; $b3a4: 80 f0 b2 04	 Data
			.byte $00, $01, $be, $09	; $b3a8: 00 01 be 09	 Data
			.byte $40, $0f, $aa, $00	; $b3ac: 40 0f aa 00	 Data
			.byte $d0, $b3, $01, $01	; $b3b0: d0 b3 01 01	 Data
			.byte $7f, $06, $41, $03	; $b3b4: 7f 06 41 03	 Data
			.byte $aa, $01, $13, $b4	; $b3b8: aa 01 13 b4	 Data
			.byte $02, $01, $3f, $03	; $b3bc: 02 01 3f 03	 Data
			.byte $40, $0f, $aa, $02	; $b3c0: 40 0f aa 02	 Data
			.byte $60, $b4, $03, $02	; $b3c4: 60 b4 03 02	 Data
			.byte $3f, $03, $40, $00	; $b3c8: 3f 03 40 00	 Data
			.byte $aa, $03, $ca, $b4	; $b3cc: aa 03 ca b4	 Data
			.byte $8d, $70, $03, $25	; $b3d0: 8d 70 03 25	 Data
			.byte $e7, $28, $e3, $00	; $b3d4: e7 28 e3 00	 Data
			.byte $25, $00, $e7, $25	; $b3d8: 25 00 e7 25	 Data
			.byte $28, $e3, $00, $25	; $b3dc: 28 e3 00 25	 Data
			.byte $00, $e7, $25, $28	; $b3e0: 00 e7 25 28	 Data
			.byte $e3, $00, $25, $9c	; $b3e4: e3 00 25 9c	 Data
			.byte $03, $04, $b5, $81	; $b3e8: 03 04 b5 81	 Data
			.byte $70, $d3, $b3, $8d	; $b3ec: 70 d3 b3 8d	 Data
			.byte $70, $02, $35, $e4	; $b3f0: 70 02 35 e4	 Data
			.byte $34, $33, $32, $31	; $b3f4: 34 33 32 31	 Data
			.byte $30, $2f, $2e, $2d	; $b3f8: 30 2f 2e 2d	 Data
			.byte $2c, $2b, $2a, $29	; $b3fc: 2c 2b 2a 29	 Data
			.byte $28, $27, $26, $25	; $b400: 28 27 26 25	 Data
			.byte $24, $9c, $02, $07	; $b404: 24 9c 02 07	 Data
			.byte $b5, $81, $70, $f2	; $b408: b5 81 70 f2	 Data
			.byte $b3, $29, $e0, $48	; $b40c: b3 29 e0 48	 Data
			.byte $80, $d0, $b3, $8d	; $b410: 80 d0 b3 8d	 Data
			.byte $70, $03, $25, $e7	; $b414: 70 03 25 e7	 Data
			.byte $28, $e3, $00, $25	; $b418: 28 e3 00 25	 Data
			.byte $00, $e7, $25, $28	; $b41c: 00 e7 25 28	 Data
			.byte $e3, $00, $25, $00	; $b420: e3 00 25 00	 Data
			.byte $e7, $25, $28, $e3	; $b424: e7 25 28 e3	 Data
			.byte $00, $25, $9c, $03	; $b428: 00 25 9c 03	 Data
			.byte $09, $b5, $81, $70	; $b42c: 09 b5 81 70	 Data
			.byte $16, $b4, $00, $e0	; $b430: 16 b4 00 e0	 Data
			.byte $24, $8d, $70, $02	; $b434: 24 8d 70 02	 Data
			.byte $35, $e4, $34, $33	; $b438: 35 e4 34 33	 Data
			.byte $32, $31, $30, $2f	; $b43c: 32 31 30 2f	 Data
			.byte $2e, $2d, $2c, $2b	; $b440: 2e 2d 2c 2b	 Data
			.byte $2a, $29, $28, $27	; $b444: 2a 29 28 27	 Data
			.byte $26, $25, $24, $9c	; $b448: 26 25 24 9c	 Data
			.byte $02, $0c, $b5, $81	; $b44c: 02 0c b5 81	 Data
			.byte $70, $38, $b4, $21	; $b450: 70 38 b4 21	 Data
			.byte $e4, $20, $1f, $1e	; $b454: e4 20 1f 1e	 Data
			.byte $1d, $1c, $1b, $1b	; $b458: 1d 1c 1b 1b	 Data
			.byte $1a, $80, $13, $b4	; $b45c: 1a 80 13 b4	 Data
			.byte $19, $e4, $19, $1c	; $b460: 19 e4 19 1c	 Data
			.byte $19, $1f, $19, $19	; $b464: 19 1f 19 19	 Data
			.byte $19, $1c, $19, $1f	; $b468: 19 1c 19 1f	 Data
			.byte $19, $19, $19, $1c	; $b46c: 19 19 19 1c	 Data
			.byte $19, $1f, $19, $1c	; $b470: 19 1f 19 1c	 Data
			.byte $1c, $1f, $1c, $21	; $b474: 1c 1f 1c 21	 Data
			.byte $1c, $1c, $1c, $1f	; $b478: 1c 1c 1c 1f	 Data
			.byte $1c, $21, $1c, $1c	; $b47c: 1c 21 1c 1c	 Data
			.byte $1c, $1f, $1c, $21	; $b480: 1c 1f 1c 21	 Data
			.byte $1c, $1e, $1e, $21	; $b484: 1c 1e 1e 21	 Data
			.byte $1e, $24, $1e, $1e	; $b488: 1e 24 1e 1e	 Data
			.byte $1e, $21, $1e, $24	; $b48c: 1e 21 1e 24	 Data
			.byte $1e, $1e, $1e, $21	; $b490: 1e 1e 1e 21	 Data
			.byte $1e, $24, $1e, $8d	; $b494: 1e 24 1e 8d	 Data
			.byte $70, $02, $20, $e4	; $b498: 70 02 20 e4	 Data
			.byte $21, $22, $23, $24	; $b49c: 21 22 23 24	 Data
			.byte $25, $26, $27, $28	; $b4a0: 25 26 27 28	 Data
			.byte $29, $2a, $2b, $2c	; $b4a4: 29 2a 2b 2c	 Data
			.byte $2d, $2e, $2f, $30	; $b4a8: 2d 2e 2f 30	 Data
			.byte $31, $9c, $02, $0e	; $b4ac: 31 9c 02 0e	 Data
			.byte $b5, $81, $70, $9a	; $b4b0: b5 81 70 9a	 Data
			.byte $b4, $2a, $29, $28	; $b4b4: b4 2a 29 28	 Data
			.byte $27, $26, $25, $24	; $b4b8: 27 26 25 24	 Data
			.byte $23, $22, $21, $20	; $b4bc: 23 22 21 20	 Data
			.byte $1f, $1e, $1d, $1c	; $b4c0: 1f 1e 1d 1c	 Data
			.byte $1b, $1a, $19, $80	; $b4c4: 1b 1a 19 80	 Data
			.byte $60, $b4, $8d, $70	; $b4c8: 60 b4 8d 70	 Data
			.byte $0c, $c0, $e7, $c1	; $b4cc: 0c c0 e7 c1	 Data
			.byte $e3, $c1, $c1, $81	; $b4d0: e3 c1 c1 81	 Data
			.byte $70, $cd, $b4, $8d	; $b4d4: 70 cd b4 8d	 Data
			.byte $70, $05, $c0, $e4	; $b4d8: 70 05 c0 e4	 Data
			.byte $c0, $c1, $81, $70	; $b4dc: c0 c1 81 70	 Data
			.byte $da, $b4, $c0, $c0	; $b4e0: da b4 c0 c0	 Data
			.byte $c0, $8d, $70, $05	; $b4e4: c0 8d 70 05	 Data
			.byte $c0, $e4, $c0, $c1	; $b4e8: c0 e4 c0 c1	 Data
			.byte $81, $70, $e8, $b4	; $b4ec: 81 70 e8 b4	 Data
			.byte $c0, $c0, $c0, $c0	; $b4f0: c0 c0 c0 c0	 Data
			.byte $e7, $c1, $c0, $c1	; $b4f4: e7 c1 c0 c1	 Data
			.byte $c0, $c1, $c0, $e3	; $b4f8: c0 c1 c0 e3	 Data
			.byte $c0, $c0, $c0, $c0	; $b4fc: c0 c0 c0 c0	 Data
			.byte $e5, $80, $ca, $b4	; $b500: e5 80 ca b4	 Data
			.byte $03, $02, $fb, $fc	; $b504: 03 02 fb fc	 Data
			.byte $04, $03, $02, $fb	; $b508: 04 03 02 fb	 Data
			.byte $fc, $04, $04, $fc	; $b50c: fc 04 04 fc	 Data
			.byte $04, $02, $01, $bd	; $b510: 04 02 01 bd	 Data
			.byte $01, $42, $1b, $5d	; $b514: 01 42 1b 5d	 Data
			.byte $02, $39, $b5, $00	; $b518: 02 39 b5 00	 Data
			.byte $01, $7f, $04, $40	; $b51c: 01 7f 04 40	 Data
			.byte $03, $5d, $00, $4a	; $b520: 03 5d 00 4a	 Data
			.byte $b5, $01, $01, $7c	; $b524: b5 01 01 7c	 Data
			.byte $04, $41, $03, $5d	; $b528: 04 41 03 5d	 Data
			.byte $01, $6e, $b5, $03	; $b52c: 01 6e b5 03	 Data
			.byte $02, $3c, $04, $40	; $b530: 02 3c 04 40	 Data
			.byte $00, $5d, $03, $94	; $b534: 00 5d 03 94	 Data
			.byte $b5, $19, $ee, $18	; $b538: b5 19 ee 18	 Data
			.byte $19, $1c, $19, $eb	; $b53c: 19 1c 19 eb	 Data
			.byte $20, $1d, $24, $25	; $b540: 20 1d 24 25	 Data
			.byte $20, $21, $1c, $80	; $b544: 20 21 1c 80	 Data
			.byte $39, $b5, $19, $e5	; $b548: 39 b5 19 e5	 Data
			.byte $1c, $20, $25, $28	; $b54c: 1c 20 25 28	 Data
			.byte $25, $20, $1c, $1d	; $b550: 25 20 1c 1d	 Data
			.byte $20, $24, $29, $2c	; $b554: 20 24 29 2c	 Data
			.byte $29, $24, $20, $19	; $b558: 29 24 20 19	 Data
			.byte $1c, $20, $25, $28	; $b55c: 1c 20 25 28	 Data
			.byte $25, $20, $1c, $15	; $b560: 25 20 1c 15	 Data
			.byte $18, $1c, $21, $24	; $b564: 18 1c 21 24	 Data
			.byte $21, $1c, $18, $80	; $b568: 21 1c 18 80	 Data
			.byte $4a, $b5, $00, $e7	; $b56c: 4a b5 00 e7	 Data
			.byte $19, $e5, $1c, $20	; $b570: 19 e5 1c 20	 Data
			.byte $25, $28, $25, $20	; $b574: 25 28 25 20	 Data
			.byte $1c, $1d, $20, $24	; $b578: 1c 1d 20 24	 Data
			.byte $29, $2c, $29, $24	; $b57c: 29 2c 29 24	 Data
			.byte $20, $19, $1c, $20	; $b580: 20 19 1c 20	 Data
			.byte $25, $28, $25, $20	; $b584: 25 28 25 20	 Data
			.byte $1c, $15, $18, $1c	; $b588: 1c 15 18 1c	 Data
			.byte $21, $24, $21, $1c	; $b58c: 21 24 21 1c	 Data
			.byte $18, $80, $70, $b5	; $b590: 18 80 70 b5	 Data
			.byte $c0, $e4, $8a, $fb	; $b594: c0 e4 8a fb	 Data
			.byte $c0, $c0, $8a, $05	; $b598: c0 c0 8a 05	 Data
			.byte $c0, $00, $c0, $c0	; $b59c: c0 00 c0 c0	 Data
			.byte $e8, $c0, $e4, $8a	; $b5a0: e8 c0 e4 8a	 Data
			.byte $fb, $c0, $8a, $05	; $b5a4: fb c0 8a 05	 Data
			.byte $c0, $80, $94, $b5	; $b5a8: c0 80 94 b5	 Data
			.byte $04, $00, $01, $bf	; $b5ac: 04 00 01 bf	 Data
			.byte $04, $00, $00, $01	; $b5b0: 04 00 00 01	 Data
			.byte $00, $d5, $b5, $01	; $b5b4: 00 d5 b5 01	 Data
			.byte $01, $7f, $04, $00	; $b5b8: 01 7f 04 00	 Data
			.byte $00, $01, $01, $ce	; $b5bc: 00 01 01 ce	 Data
			.byte $b6, $02, $01, $bf	; $b5c0: b6 02 01 bf	 Data
			.byte $04, $00, $18, $01	; $b5c4: 04 00 18 01	 Data
			.byte $02, $d8, $b7, $03	; $b5c8: 02 d8 b7 03	 Data
			.byte $02, $3c, $02, $00	; $b5cc: 02 3c 02 00	 Data
			.byte $00, $01, $03, $ea	; $b5d0: 00 01 03 ea	 Data
			.byte $b8, $8a, $00, $96	; $b5d4: b8 8a 00 96	 Data
			.byte $7b, $8d, $70, $01	; $b5d8: 7b 8d 70 01	 Data
			.byte $29, $e5, $29, $29	; $b5dc: 29 e5 29 29	 Data
			.byte $25, $e3, $27, $29	; $b5e0: 25 e3 27 29	 Data
			.byte $ea, $25, $e5, $29	; $b5e4: ea 25 e5 29	 Data
			.byte $25, $e3, $27, $25	; $b5e8: 25 e3 27 25	 Data
			.byte $e5, $27, $e3, $27	; $b5ec: e5 27 e3 27	 Data
			.byte $81, $70, $fc, $b5	; $b5f0: 81 70 fc b5	 Data
			.byte $29, $e5, $29, $29	; $b5f4: 29 e5 29 29	 Data
			.byte $25, $80, $dc, $b5	; $b5f8: 25 80 dc b5	 Data
			.byte $25, $e8, $24, $8d	; $b5fc: 25 e8 24 8d	 Data
			.byte $70, $02, $25, $e5	; $b600: 70 02 25 e5	 Data
			.byte $27, $29, $2a, $29	; $b604: 27 29 2a 29	 Data
			.byte $e8, $2c, $27, $2c	; $b608: e8 2c 27 2c	 Data
			.byte $25, $e5, $27, $29	; $b60c: 25 e5 27 29	 Data
			.byte $2a, $29, $e8, $29	; $b610: 2a 29 e8 29	 Data
			.byte $e5, $27, $25, $29	; $b614: e5 27 25 29	 Data
			.byte $24, $29, $22, $e8	; $b618: 24 29 22 e8	 Data
			.byte $22, $e5, $21, $22	; $b61c: 22 e5 21 22	 Data
			.byte $e8, $24, $25, $e5	; $b620: e8 24 25 e5	 Data
			.byte $27, $29, $24, $25	; $b624: 27 29 24 25	 Data
			.byte $e8, $24, $22, $22	; $b628: e8 24 22 22	 Data
			.byte $e5, $21, $22, $e8	; $b62c: e5 21 22 e8	 Data
			.byte $24, $25, $e5, $24	; $b630: 24 25 e5 24	 Data
			.byte $22, $e8, $81, $70	; $b634: 22 e8 81 70	 Data
			.byte $02, $b6, $8d, $70	; $b638: 02 b6 8d 70	 Data
			.byte $01, $29, $e5, $29	; $b63c: 01 29 e5 29	 Data
			.byte $29, $25, $e3, $27	; $b640: 29 25 e3 27	 Data
			.byte $29, $ea, $25, $e5	; $b644: 29 ea 25 e5	 Data
			.byte $29, $25, $e3, $27	; $b648: 29 25 e3 27	 Data
			.byte $25, $e5, $25, $e3	; $b64c: 25 e5 25 e3	 Data
			.byte $27, $29, $e5, $29	; $b650: 27 29 e5 29	 Data
			.byte $29, $25, $2a, $2a	; $b654: 29 25 2a 2a	 Data
			.byte $2a, $27, $e3, $29	; $b658: 2a 27 e3 29	 Data
			.byte $2a, $ea, $27, $e5	; $b65c: 2a ea 27 e5	 Data
			.byte $2a, $27, $e3, $29	; $b660: 2a 27 e3 29	 Data
			.byte $27, $e5, $27, $e3	; $b664: 27 e5 27 e3	 Data
			.byte $29, $81, $70, $75	; $b668: 29 81 70 75	 Data
			.byte $b6, $2a, $e5, $27	; $b66c: b6 2a e5 27	 Data
			.byte $29, $2a, $80, $3d	; $b670: 29 2a 80 3d	 Data
			.byte $b6, $2a, $e8, $2a	; $b674: b6 2a e8 2a	 Data
			.byte $e5, $00, $8d, $70	; $b678: e5 00 8d 70	 Data
			.byte $02, $29, $e0, $1e	; $b67c: 02 29 e0 1e	 Data
			.byte $25, $e5, $27, $29	; $b680: 25 e5 27 29	 Data
			.byte $29, $e0, $1e, $25	; $b684: 29 e0 1e 25	 Data
			.byte $e5, $27, $29, $2a	; $b688: e5 27 29 2a	 Data
			.byte $e3, $2c, $2a, $29	; $b68c: e3 2c 2a 29	 Data
			.byte $27, $e8, $2a, $e3	; $b690: 27 e8 2a e3	 Data
			.byte $2c, $2a, $29, $27	; $b694: 2c 2a 29 27	 Data
			.byte $e8, $2a, $e3, $2c	; $b698: e8 2a e3 2c	 Data
			.byte $2a, $29, $27, $e8	; $b69c: 2a 29 27 e8	 Data
			.byte $00, $e5, $29, $2a	; $b6a0: 00 e5 29 2a	 Data
			.byte $27, $81, $70, $7d	; $b6a4: 27 81 70 7d	 Data
			.byte $b6, $8d, $70, $01	; $b6a8: b6 8d 70 01	 Data
			.byte $29, $e5, $2e, $29	; $b6ac: 29 e5 2e 29	 Data
			.byte $e8, $29, $e5, $2e	; $b6b0: e8 29 e5 2e	 Data
			.byte $29, $e8, $2a, $e5	; $b6b4: 29 e8 2a e5	 Data
			.byte $29, $27, $25, $81	; $b6b8: 29 27 25 81	 Data
			.byte $70, $c5, $b6, $27	; $b6bc: 70 c5 b6 27	 Data
			.byte $e8, $29, $80, $ac	; $b6c0: e8 29 80 ac	 Data
			.byte $b6, $2a, $e5, $2a	; $b6c4: b6 2a e5 2a	 Data
			.byte $29, $e8, $80, $ff	; $b6c8: 29 e8 80 ff	 Data
			.byte $b5, $82, $96, $7b	; $b6cc: b5 82 96 7b	 Data
			.byte $8a, $ff, $88, $04	; $b6d0: 8a ff 88 04	 Data
			.byte $83, $41, $8d, $70	; $b6d4: 83 41 8d 70	 Data
			.byte $01, $1d, $e5, $1d	; $b6d8: 01 1d e5 1d	 Data
			.byte $1d, $19, $e3, $1b	; $b6dc: 1d 19 e3 1b	 Data
			.byte $1d, $ea, $19, $e5	; $b6e0: 1d ea 19 e5	 Data
			.byte $1d, $19, $e3, $1b	; $b6e4: 1d 19 e3 1b	 Data
			.byte $19, $e5, $1b, $e3	; $b6e8: 19 e5 1b e3	 Data
			.byte $1b, $81, $70, $f9	; $b6ec: 1b 81 70 f9	 Data
			.byte $b6, $1d, $e5, $1d	; $b6f0: b6 1d e5 1d	 Data
			.byte $1d, $19, $80, $d9	; $b6f4: 1d 19 80 d9	 Data
			.byte $b6, $19, $e8, $18	; $b6f8: b6 19 e8 18	 Data
			.byte $83, $40, $8a, $01	; $b6fc: 83 40 8a 01	 Data
			.byte $8d, $70, $02, $00	; $b700: 8d 70 02 00	 Data
			.byte $eb, $25, $e5, $25	; $b704: eb 25 e5 25	 Data
			.byte $20, $20, $25, $25	; $b708: 20 20 25 25	 Data
			.byte $20, $20, $25, $25	; $b70c: 20 20 25 25	 Data
			.byte $20, $20, $25, $25	; $b710: 20 20 25 25	 Data
			.byte $20, $20, $00, $2e	; $b714: 20 20 00 2e	 Data
			.byte $00, $30, $00, $31	; $b718: 00 30 00 31	 Data
			.byte $00, $e8, $00, $e5	; $b71c: 00 e8 00 e5	 Data
			.byte $2e, $00, $30, $00	; $b720: 2e 00 30 00	 Data
			.byte $31, $00, $e8, $00	; $b724: 31 00 e8 00	 Data
			.byte $e5, $2a, $00, $2c	; $b728: e5 2a 00 2c	 Data
			.byte $00, $2e, $00, $00	; $b72c: 00 2e 00 00	 Data
			.byte $00, $2a, $00, $2c	; $b730: 00 2a 00 2c	 Data
			.byte $00, $2e, $00, $00	; $b734: 00 2e 00 00	 Data
			.byte $81, $70, $03, $b7	; $b738: 81 70 03 b7	 Data
			.byte $83, $41, $8d, $70	; $b73c: 83 41 8d 70	 Data
			.byte $01, $1d, $1d, $1d	; $b740: 01 1d 1d 1d	 Data
			.byte $19, $e3, $1b, $1d	; $b744: 19 e3 1b 1d	 Data
			.byte $ea, $19, $e5, $1d	; $b748: ea 19 e5 1d	 Data
			.byte $19, $e3, $1b, $19	; $b74c: 19 e3 1b 19	 Data
			.byte $e5, $19, $e3, $1b	; $b750: e5 19 e3 1b	 Data
			.byte $1d, $e5, $1d, $1d	; $b754: 1d e5 1d 1d	 Data
			.byte $19, $1e, $1e, $1e	; $b758: 19 1e 1e 1e	 Data
			.byte $1b, $e3, $1d, $1e	; $b75c: 1b e3 1d 1e	 Data
			.byte $ea, $1b, $e5, $1e	; $b760: ea 1b e5 1e	 Data
			.byte $1b, $e3, $1d, $1b	; $b764: 1b e3 1d 1b	 Data
			.byte $e5, $1b, $e3, $1d	; $b768: e5 1b e3 1d	 Data
			.byte $81, $70, $78, $b7	; $b76c: 81 70 78 b7	 Data
			.byte $1e, $e5, $1b, $1d	; $b770: 1e e5 1b 1d	 Data
			.byte $1e, $80, $41, $b7	; $b774: 1e 80 41 b7	 Data
			.byte $1e, $e8, $1e, $e5	; $b778: 1e e8 1e e5	 Data
			.byte $00, $8d, $70, $02	; $b77c: 00 8d 70 02	 Data
			.byte $00, $ee, $88, $04	; $b780: 00 ee 88 04	 Data
			.byte $83, $41, $00, $e5	; $b784: 83 41 00 e5	 Data
			.byte $35, $36, $35, $e0	; $b788: 35 36 35 e0	 Data
			.byte $1e, $2a, $e3, $2c	; $b78c: 1e 2a e3 2c	 Data
			.byte $2a, $29, $27, $e8	; $b790: 2a 29 27 e8	 Data
			.byte $2a, $e3, $2c, $2a	; $b794: 2a e3 2c 2a	 Data
			.byte $29, $27, $e8, $2a	; $b798: 29 27 e8 2a	 Data
			.byte $e3, $2c, $2a, $29	; $b79c: e3 2c 2a 29	 Data
			.byte $27, $e8, $00, $e5	; $b7a0: 27 e8 00 e5	 Data
			.byte $29, $2a, $27, $81	; $b7a4: 29 2a 27 81	 Data
			.byte $70, $80, $b7, $83	; $b7a8: 70 80 b7 83	 Data
			.byte $40, $8a, $fb, $8d	; $b7ac: 40 8a fb 8d	 Data
			.byte $70, $01, $4d, $e5	; $b7b0: 70 01 4d e5	 Data
			.byte $52, $4d, $e8, $4d	; $b7b4: 52 4d e8 4d	 Data
			.byte $e5, $52, $4d, $e8	; $b7b8: e5 52 4d e8	 Data
			.byte $4e, $e5, $4d, $4b	; $b7bc: 4e e5 4d 4b	 Data
			.byte $49, $81, $70, $cb	; $b7c0: 49 81 70 cb	 Data
			.byte $b7, $4b, $e8, $4d	; $b7c4: b7 4b e8 4d	 Data
			.byte $80, $b2, $b7, $4e	; $b7c8: 80 b2 b7 4e	 Data
			.byte $e5, $4e, $4d, $e8	; $b7cc: e5 4e 4d e8	 Data
			.byte $88, $04, $8a, $05	; $b7d0: 88 04 8a 05	 Data
			.byte $80, $fc, $b6, $82	; $b7d4: 80 fc b6 82	 Data
			.byte $96, $7b, $88, $02	; $b7d8: 96 7b 88 02	 Data
			.byte $8d, $70, $01, $16	; $b7dc: 8d 70 01 16	 Data
			.byte $e5, $16, $22, $16	; $b7e0: e5 16 22 16	 Data
			.byte $16, $16, $22, $16	; $b7e4: 16 16 22 16	 Data
			.byte $16, $16, $22, $16	; $b7e8: 16 16 22 16	 Data
			.byte $1d, $16, $81, $70	; $b7ec: 1d 16 81 70	 Data
			.byte $f7, $b7, $19, $1d	; $b7f0: f7 b7 19 1d	 Data
			.byte $80, $df, $b7, $1d	; $b7f4: 80 df b7 1d	 Data
			.byte $22, $8d, $70, $02	; $b7f8: 22 8d 70 02	 Data
			.byte $19, $eb, $19, $e5	; $b7fc: 19 eb 19 e5	 Data
			.byte $14, $19, $14, $19	; $b800: 14 19 14 19	 Data
			.byte $14, $19, $14, $19	; $b804: 14 19 14 19	 Data
			.byte $14, $19, $14, $19	; $b808: 14 19 14 19	 Data
			.byte $14, $25, $20, $0a	; $b80c: 14 25 20 0a	 Data
			.byte $16, $e3, $11, $0c	; $b810: 16 e3 11 0c	 Data
			.byte $e5, $18, $e3, $13	; $b814: e5 18 e3 13	 Data
			.byte $0d, $e5, $19, $e3	; $b818: 0d e5 19 e3	 Data
			.byte $14, $0a, $e5, $05	; $b81c: 14 0a e5 05	 Data
			.byte $0a, $16, $e3, $11	; $b820: 0a 16 e3 11	 Data
			.byte $0c, $e5, $18, $e3	; $b824: 0c e5 18 e3	 Data
			.byte $13, $0d, $e5, $19	; $b828: 13 0d e5 19	 Data
			.byte $e3, $14, $0a, $e5	; $b82c: e3 14 0a e5	 Data
			.byte $05, $06, $12, $e3	; $b830: 05 06 12 e3	 Data
			.byte $0d, $0c, $e5, $18	; $b834: 0d 0c e5 18	 Data
			.byte $e3, $13, $0d, $e5	; $b838: e3 13 0d e5	 Data
			.byte $0c, $0a, $16, $e3	; $b83c: 0c 0a 16 e3	 Data
			.byte $0a, $06, $e5, $12	; $b840: 0a 06 e5 12	 Data
			.byte $e3, $0d, $0c, $e5	; $b844: e3 0d 0c e5	 Data
			.byte $18, $e3, $13, $0d	; $b848: 18 e3 13 0d	 Data
			.byte $e5, $0c, $0a, $16	; $b84c: e5 0c 0a 16	 Data
			.byte $e3, $0a, $81, $70	; $b850: e3 0a 81 70	 Data
			.byte $fc, $b7, $16, $e8	; $b854: fc b7 16 e8	 Data
			.byte $19, $16, $19, $16	; $b858: 19 16 19 16	 Data
			.byte $19, $16, $eb, $0f	; $b85c: 19 16 eb 0f	 Data
			.byte $e8, $12, $0f, $12	; $b860: e8 12 0f 12	 Data
			.byte $0f, $12, $0f, $eb	; $b864: 0f 12 0f eb	 Data
			.byte $16, $e5, $16, $22	; $b868: 16 e5 16 22	 Data
			.byte $1d, $16, $16, $22	; $b86c: 1d 16 16 22	 Data
			.byte $1d, $16, $16, $22	; $b870: 1d 16 16 22	 Data
			.byte $1d, $19, $16, $19	; $b874: 1d 19 16 19	 Data
			.byte $22, $0f, $0f, $1b	; $b878: 22 0f 0f 1b	 Data
			.byte $16, $0f, $0f, $1b	; $b87c: 16 0f 0f 1b	 Data
			.byte $16, $0f, $0f, $1b	; $b880: 16 0f 0f 1b	 Data
			.byte $16, $12, $0f, $12	; $b884: 16 12 0f 12	 Data
			.byte $16, $8d, $70, $02	; $b888: 16 8d 70 02	 Data
			.byte $11, $e5, $11, $11	; $b88c: 11 e5 11 11	 Data
			.byte $11, $11, $11, $11	; $b890: 11 11 11 11	 Data
			.byte $11, $11, $11, $11	; $b894: 11 11 11 11	 Data
			.byte $11, $11, $11, $11	; $b898: 11 11 11 11	 Data
			.byte $11, $12, $e8, $0f	; $b89c: 11 12 e8 0f	 Data
			.byte $12, $0f, $12, $0f	; $b8a0: 12 0f 12 0f	 Data
			.byte $12, $12, $81, $70	; $b8a4: 12 12 81 70	 Data
			.byte $8c, $b8, $88, $04	; $b8a8: 8c b8 88 04	 Data
			.byte $9d, $02, $8d, $70	; $b8ac: 9d 02 8d 70	 Data
			.byte $01, $0a, $e5, $16	; $b8b0: 01 0a e5 16	 Data
			.byte $05, $11, $0a, $16	; $b8b4: 05 11 0a 16	 Data
			.byte $05, $11, $81, $70	; $b8b8: 05 11 81 70	 Data
			.byte $ce, $b8, $06, $e3	; $b8bc: ce b8 06 e3	 Data
			.byte $00, $06, $00, $06	; $b8c0: 00 06 00 06	 Data
			.byte $00, $06, $e5, $03	; $b8c4: 00 06 e5 03	 Data
			.byte $0f, $05, $11, $80	; $b8c8: 0f 05 11 80	 Data
			.byte $b1, $b8, $9d, $08	; $b8cc: b1 b8 9d 08	 Data
			.byte $06, $e8, $00, $9d	; $b8d0: 06 e8 00 9d	 Data
			.byte $02, $06, $e3, $00	; $b8d4: 02 06 e3 00	 Data
			.byte $06, $00, $05, $00	; $b8d8: 06 00 05 00	 Data
			.byte $05, $e1, $00, $e2	; $b8dc: 05 e1 00 e2	 Data
			.byte $05, $e3, $9d, $01	; $b8e0: 05 e3 9d 01	 Data
			.byte $88, $02, $80, $f9	; $b8e4: 88 02 80 f9	 Data
			.byte $b7, $82, $96, $7b	; $b8e8: b7 82 96 7b	 Data
			.byte $8a, $fe, $8d, $70	; $b8ec: 8a fe 8d 70	 Data
			.byte $08, $00, $e8, $c0	; $b8f0: 08 00 e8 c0	 Data
			.byte $81, $70, $f1, $b8	; $b8f4: 81 70 f1 b8	 Data
			.byte $8d, $70, $02, $00	; $b8f8: 8d 70 02 00	 Data
			.byte $eb, $c0, $e3, $00	; $b8fc: eb c0 e3 00	 Data
			.byte $c0, $c0, $c0, $00	; $b900: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $b904: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $b908: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $b90c: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $b910: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $b914: c0 c0 c0 00	 Data
			.byte $c0, $c0, $c0, $00	; $b918: c0 c0 c0 00	 Data
			.byte $c0, $c0, $00, $e5	; $b91c: c0 c0 00 e5	 Data
			.byte $c0, $00, $c0, $00	; $b920: c0 00 c0 00	 Data
			.byte $c0, $c0, $e3, $c0	; $b924: c0 c0 e3 c0	 Data
			.byte $c0, $c0, $00, $e5	; $b928: c0 c0 00 e5	 Data
			.byte $c0, $00, $c0, $00	; $b92c: c0 00 c0 00	 Data
			.byte $c0, $c0, $e3, $c0	; $b930: c0 c0 e3 c0	 Data
			.byte $c0, $c0, $00, $e5	; $b934: c0 c0 00 e5	 Data
			.byte $c0, $00, $c0, $00	; $b938: c0 00 c0 00	 Data
			.byte $c0, $c0, $e3, $c0	; $b93c: c0 c0 e3 c0	 Data
			.byte $c0, $c0, $00, $e5	; $b940: c0 c0 00 e5	 Data
			.byte $c0, $00, $c0, $00	; $b944: c0 00 c0 00	 Data
			.byte $c0, $c0, $e3, $c0	; $b948: c0 c0 e3 c0	 Data
			.byte $c0, $c0, $81, $70	; $b94c: c0 c0 81 70	 Data
			.byte $fb, $b8, $8d, $70	; $b950: fb b8 8d 70	 Data
			.byte $07, $00, $e8, $c0	; $b954: 07 00 e8 c0	 Data
			.byte $81, $70, $55, $b9	; $b958: 81 70 55 b9	 Data
			.byte $00, $c0, $e5, $c0	; $b95c: 00 c0 e5 c0	 Data
			.byte $8d, $70, $04, $c0	; $b960: 8d 70 04 c0	 Data
			.byte $e3, $00, $c0, $c0	; $b964: e3 00 c0 c0	 Data
			.byte $81, $70, $63, $b9	; $b968: 81 70 63 b9	 Data
			.byte $00, $e8, $c0, $00	; $b96c: 00 e8 c0 00	 Data
			.byte $c0, $e2, $c0, $00	; $b970: c0 e2 c0 00	 Data
			.byte $e1, $00, $c0, $e3	; $b974: e1 00 c0 e3	 Data
			.byte $c0, $8d, $70, $08	; $b978: c0 8d 70 08	 Data
			.byte $c0, $00, $c0, $c0	; $b97c: c0 00 c0 c0	 Data
			.byte $81, $70, $7c, $b9	; $b980: 81 70 7c b9	 Data
			.byte $8d, $70, $02, $00	; $b984: 8d 70 02 00	 Data
			.byte $e8, $c0, $00, $c0	; $b988: e8 c0 00 c0	 Data
			.byte $00, $c0, $00, $c0	; $b98c: 00 c0 00 c0	 Data
			.byte $00, $c0, $00, $c0	; $b990: 00 c0 00 c0	 Data
			.byte $00, $c0, $00, $e5	; $b994: 00 c0 00 e5	 Data
			.byte $c0, $c0, $c0, $81	; $b998: c0 c0 c0 81	 Data
			.byte $70, $87, $b9, $8d	; $b99c: 70 87 b9 8d	 Data
			.byte $70, $02, $c0, $e3	; $b9a0: 70 02 c0 e3	 Data
			.byte $00, $c0, $c0, $c0	; $b9a4: 00 c0 c0 c0	 Data
			.byte $00, $c0, $c0, $c0	; $b9a8: 00 c0 c0 c0	 Data
			.byte $00, $c0, $c0, $c0	; $b9ac: 00 c0 c0 c0	 Data
			.byte $00, $c0, $c0, $c0	; $b9b0: 00 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $c0	; $b9b4: c0 c0 c0 c0	 Data
			.byte $c0, $c0, $c0, $00	; $b9b8: c0 c0 c0 00	 Data
			.byte $e8, $c0, $81, $70	; $b9bc: e8 c0 81 70	 Data
			.byte $a2, $b9, $80, $f8	; $b9c0: a2 b9 80 f8	 Data
			.byte $b8, $82, $04, $00	; $b9c4: b8 82 04 00	 Data
			.byte $01, $3f, $04, $40	; $b9c8: 01 3f 04 40	 Data
			.byte $fd, $80, $00, $ef	; $b9cc: fd 80 00 ef	 Data
			.byte $b9, $01, $01, $3c	; $b9d0: b9 01 01 3c	 Data
			.byte $04, $41, $fd, $80	; $b9d4: 04 41 fd 80	 Data
			.byte $01, $1d, $ba, $02	; $b9d8: 01 1d ba 02	 Data
			.byte $01, $bf, $03, $40	; $b9dc: 01 bf 03 40	 Data
			.byte $15, $80, $02, $4d	; $b9e0: 15 80 02 4d	 Data
			.byte $ba, $03, $02, $3d	; $b9e4: ba 03 02 3d	 Data
			.byte $04, $40, $00, $80	; $b9e8: 04 40 00 80	 Data
			.byte $03, $62, $ba, $2c	; $b9ec: 03 62 ba 2c	 Data
			.byte $e5, $28, $25, $28	; $b9f0: e5 28 25 28	 Data
			.byte $2c, $25, $2b, $27	; $b9f4: 2c 25 2b 27	 Data
			.byte $25, $27, $2b, $25	; $b9f8: 25 27 2b 25	 Data
			.byte $2a, $26, $25, $26	; $b9fc: 2a 26 25 26	 Data
			.byte $2a, $25, $27, $24	; $ba00: 2a 25 27 24	 Data
			.byte $20, $24, $27, $24	; $ba04: 20 24 27 24	 Data
			.byte $28, $25, $20, $25	; $ba08: 28 25 20 25	 Data
			.byte $28, $25, $2a, $27	; $ba0c: 28 25 2a 27	 Data
			.byte $20, $27, $2a, $27	; $ba10: 20 27 2a 27	 Data
			.byte $28, $25, $20, $25	; $ba14: 28 25 20 25	 Data
			.byte $28, $25, $80, $ef	; $ba18: 28 25 80 ef	 Data
			.byte $b9, $00, $e7, $2c	; $ba1c: b9 00 e7 2c	 Data
			.byte $e5, $28, $25, $28	; $ba20: e5 28 25 28	 Data
			.byte $2c, $25, $2b, $27	; $ba24: 2c 25 2b 27	 Data
			.byte $25, $27, $2b, $25	; $ba28: 25 27 2b 25	 Data
			.byte $2a, $26, $25, $26	; $ba2c: 2a 26 25 26	 Data
			.byte $2a, $25, $27, $24	; $ba30: 2a 25 27 24	 Data
			.byte $20, $24, $27, $24	; $ba34: 20 24 27 24	 Data
			.byte $28, $25, $20, $25	; $ba38: 28 25 20 25	 Data
			.byte $28, $25, $2a, $27	; $ba3c: 28 25 2a 27	 Data
			.byte $20, $27, $2a, $27	; $ba40: 20 27 2a 27	 Data
			.byte $28, $25, $20, $25	; $ba44: 28 25 20 25	 Data
			.byte $28, $25, $80, $1f	; $ba48: 28 25 80 1f	 Data
			.byte $ba, $8d, $70, $07	; $ba4c: ba 8d 70 07	 Data
			.byte $19, $e5, $19, $19	; $ba50: 19 e5 19 19	 Data
			.byte $19, $19, $19, $9c	; $ba54: 19 19 19 9c	 Data
			.byte $07, $7e, $ba, $81	; $ba58: 07 7e ba 81	 Data
			.byte $70, $50, $ba, $80	; $ba5c: 70 50 ba 80	 Data
			.byte $4d, $ba, $8a, $fb	; $ba60: 4d ba 8a fb	 Data
			.byte $c0, $e3, $c0, $c0	; $ba64: c0 e3 c0 c0	 Data
			.byte $8a, $05, $c0, $8a	; $ba68: 8a 05 c0 8a	 Data
			.byte $fb, $c0, $c0, $c0	; $ba6c: fb c0 c0 c0	 Data
			.byte $c0, $8a, $05, $c0	; $ba70: c0 8a 05 c0	 Data
			.byte $8a, $fb, $c0, $c0	; $ba74: 8a fb c0 c0	 Data
			.byte $c0, $8a, $05, $80	; $ba78: c0 8a 05 80	 Data
			.byte $62, $ba, $00, $00	; $ba7c: 62 ba 00 00	 Data
			.byte $fb, $00, $00, $00	; $ba80: fb 00 00 00	 Data
			.byte $05, $04, $05, $01	; $ba84: 05 04 05 01	 Data
			.byte $3b, $10, $44, $f4	; $ba88: 3b 10 44 f4	 Data
			.byte $aa, $01, $c6, $ba	; $ba8c: aa 01 c6 ba	 Data
			.byte $04, $01, $37, $10	; $ba90: 04 01 37 10	 Data
			.byte $44, $f4, $aa, $00	; $ba94: 44 f4 aa 00	 Data
			.byte $f4, $ba, $02, $61	; $ba98: f4 ba 02 61	 Data
			.byte $b0, $10, $44, $18	; $ba9c: b0 10 44 18	 Data
			.byte $aa, $02, $0e, $bb	; $baa0: aa 02 0e bb	 Data
			.byte $03, $02, $7f, $05	; $baa4: 03 02 7f 05	 Data
			.byte $42, $00, $a5, $03	; $baa8: 42 00 a5 03	 Data
			.byte $ae, $ba, $8f, $05	; $baac: ae ba 8f 05	 Data
			.byte $8d, $70, $04, $20	; $bab0: 8d 70 04 20	 Data
			.byte $e3, $8f, $02, $81	; $bab4: e3 8f 02 81	 Data
			.byte $70, $b3, $ba, $96	; $bab8: 70 b3 ba 96	 Data
			.byte $00, $93, $82, $40	; $babc: 00 93 82 40	 Data
			.byte $20, $e3, $95, $c0	; $bac0: 20 e3 95 c0	 Data
			.byte $ba, $82, $8f, $03	; $bac4: ba 82 8f 03	 Data
			.byte $8d, $70, $03, $3d	; $bac8: 8d 70 03 3d	 Data
			.byte $e3, $89, $03, $8f	; $bacc: e3 89 03 8f	 Data
			.byte $01, $81, $70, $cb	; $bad0: 01 81 70 cb	 Data
			.byte $ba, $93, $84, $28	; $bad4: ba 93 84 28	 Data
			.byte $8d, $70, $03, $3d	; $bad8: 8d 70 03 3d	 Data
			.byte $e3, $81, $70, $db	; $badc: e3 81 70 db	 Data
			.byte $ba, $8f, $03, $87	; $bae0: ba 8f 03 87	 Data
			.byte $36, $93, $84, $40	; $bae4: 36 93 84 40	 Data
			.byte $8d, $70, $0d, $20	; $bae8: 8d 70 0d 20	 Data
			.byte $e2, $89, $01, $81	; $baec: e2 89 01 81	 Data
			.byte $70, $eb, $ba, $82	; $baf0: 70 eb ba 82	 Data
			.byte $00, $e2, $8d, $70	; $baf4: 00 e2 8d 70	 Data
			.byte $05, $44, $e2, $89	; $baf8: 05 44 e2 89	 Data
			.byte $01, $81, $70, $f9	; $bafc: 01 81 70 f9	 Data
			.byte $ba, $93, $82, $28	; $bb00: ba 93 82 28	 Data
			.byte $8d, $70, $0a, $44	; $bb04: 8d 70 0a 44	 Data
			.byte $e2, $81, $70, $07	; $bb08: e2 81 70 07	 Data
			.byte $bb, $82, $8d, $70	; $bb0c: bb 82 8d 70	 Data
			.byte $03, $3d, $e3, $89	; $bb10: 03 3d e3 89	 Data
			.byte $03, $81, $70, $11	; $bb14: 03 81 70 11	 Data
			.byte $bb, $8d, $70, $04	; $bb18: bb 8d 70 04	 Data
			.byte $3d, $e3, $81, $70	; $bb1c: 3d e3 81 70	 Data
			.byte $1c, $bb, $82, $02	; $bb20: 1c bb 82 02	 Data
			.byte $05, $02, $bf, $04	; $bb24: 05 02 bf 04	 Data
			.byte $00, $00, $00, $03	; $bb28: 00 00 00 03	 Data
			.byte $38, $bb, $04, $41	; $bb2c: 38 bb 04 41	 Data
			.byte $bf, $04, $00, $00	; $bb30: bf 04 00 00	 Data
			.byte $00, $01, $45, $bb	; $bb34: 00 01 45 bb	 Data
			.byte $8f, $0e, $93, $80	; $bb38: 8f 0e 93 80	 Data
			.byte $30, $0d, $e1, $14	; $bb3c: 30 0d e1 14	 Data
			.byte $1d, $95, $3d, $bb	; $bb40: 1d 95 3d bb	 Data
			.byte $82, $8d, $70, $02	; $bb44: 82 8d 70 02	 Data
			.byte $0d, $e1, $1d, $25	; $bb48: 0d e1 1d 25	 Data
			.byte $81, $70, $48, $bb	; $bb4c: 81 70 48 bb	 Data
			.byte $82, $02, $05, $02	; $bb50: 82 02 05 02	 Data
			.byte $bf, $04, $00, $06	; $bb54: bf 04 00 06	 Data
			.byte $00, $03, $66, $bb	; $bb58: 00 03 66 bb	 Data
			.byte $04, $01, $bf, $04	; $bb5c: 04 01 bf 04	 Data
			.byte $00, $06, $00, $01	; $bb60: 00 06 00 01	 Data
			.byte $73, $bb, $8f, $0a	; $bb64: 73 bb 8f 0a	 Data
			.byte $93, $80, $80, $11	; $bb68: 93 80 80 11	 Data
			.byte $e1, $19, $29, $95	; $bb6c: e1 19 29 95	 Data
			.byte $6b, $bb, $82, $8d	; $bb70: 6b bb 82 8d	 Data
			.byte $70, $02, $19, $e1	; $bb74: 70 02 19 e1	 Data
			.byte $20, $19, $81, $70	; $bb78: 20 19 81 70	 Data
			.byte $76, $bb, $82, $01	; $bb7c: 76 bb 82 01	 Data
			.byte $04, $43, $be, $02	; $bb80: 04 43 be 02	 Data
			.byte $00, $08, $00, $01	; $bb84: 00 08 00 01	 Data
			.byte $8a, $bb, $8f, $0a	; $bb88: 8a bb 8f 0a	 Data
			.byte $94, $02, $31, $e6	; $bb8c: 94 02 31 e6	 Data
			.byte $82, $01, $04, $01	; $bb90: 82 01 04 01	 Data
			.byte $be, $00, $00, $0a	; $bb94: be 00 00 0a	 Data
			.byte $00, $01, $9c, $bb	; $bb98: 00 01 9c bb	 Data
			.byte $8d, $70, $03, $94	; $bb9c: 8d 70 03 94	 Data
			.byte $82, $35, $e1, $3d	; $bba0: 82 35 e1 3d	 Data
			.byte $50, $89, $02, $81	; $bba4: 50 89 02 81	 Data
			.byte $70, $9f, $bb, $82	; $bba8: 70 9f bb 82	 Data
			.byte $01, $04, $43, $ba	; $bbac: 01 04 43 ba	 Data
			.byte $04, $00, $00, $00	; $bbb0: 04 00 00 00	 Data
			.byte $01, $b7, $bb, $8f	; $bbb4: 01 b7 bb 8f	 Data
			.byte $0a, $8d, $70, $0a	; $bbb8: 0a 8d 70 0a	 Data
			.byte $0d, $e1, $89, $01	; $bbbc: 0d e1 89 01	 Data
			.byte $8f, $1f, $81, $70	; $bbc0: 8f 1f 81 70	 Data
			.byte $bc, $bb, $82, $01	; $bbc4: bc bb 82 01	 Data
			.byte $04, $43, $bf, $04	; $bbc8: 04 43 bf 04	 Data
			.byte $00, $05, $00, $01	; $bbcc: 00 05 00 01	 Data
			.byte $d2, $bb, $8f, $0f	; $bbd0: d2 bb 8f 0f	 Data
			.byte $93, $82, $80, $94	; $bbd4: 93 82 80 94	 Data
			.byte $04, $0d, $e3, $89	; $bbd8: 04 0d e3 89	 Data
			.byte $01, $95, $d9, $bb	; $bbdc: 01 95 d9 bb	 Data
			.byte $82, $01, $04, $43	; $bbe0: 82 01 04 43	 Data
			.byte $be, $04, $00, $08	; $bbe4: be 04 00 08	 Data
			.byte $00, $01, $ec, $bb	; $bbe8: 00 01 ec bb	 Data
			.byte $8f, $0f, $94, $02	; $bbec: 8f 0f 94 02	 Data
			.byte $31, $e8, $82, $01	; $bbf0: 31 e8 82 01	 Data
			.byte $04, $01, $7f, $03	; $bbf4: 04 01 7f 03	 Data
			.byte $00, $0c, $00, $01	; $bbf8: 00 0c 00 01	 Data
			.byte $fe, $bb, $93, $88	; $bbfc: fe bb 93 88	 Data
			.byte $a0, $25, $e1, $44	; $bc00: a0 25 e1 44	 Data
			.byte $e3, $89, $03, $25	; $bc04: e3 89 03 25	 Data
			.byte $e1, $44, $e3, $89	; $bc08: e1 44 e3 89	 Data
			.byte $fe, $95, $01, $bc	; $bc0c: fe 95 01 bc	 Data
			.byte $82, $01, $05, $01	; $bc10: 82 01 05 01	 Data
			.byte $be, $00, $00, $00	; $bc14: be 00 00 00	 Data
			.byte $00, $01, $1c, $bc	; $bc18: 00 01 1c bc	 Data
			.byte $87, $01, $94, $03	; $bc1c: 87 01 94 03	 Data
			.byte $8d, $70, $0e, $41	; $bc20: 8d 70 0e 41	 Data
			.byte $e5, $49, $89, $01	; $bc24: e5 49 89 01	 Data
			.byte $8a, $01, $81, $70	; $bc28: 8a 01 81 70	 Data
			.byte $23, $bc, $82, $01	; $bc2c: 23 bc 82 01	 Data
			.byte $05, $01, $be, $00	; $bc30: 05 01 be 00	 Data
			.byte $00, $00, $00, $01	; $bc34: 00 00 00 01	 Data
			.byte $3a, $bc, $94, $04	; $bc38: 3a bc 94 04	 Data
			.byte $8d, $70, $14, $3d	; $bc3c: 8d 70 14 3d	 Data
			.byte $ea, $8a, $fb, $41	; $bc40: ea 8a fb 41	 Data
			.byte $ea, $8a, $05, $81	; $bc44: ea 8a 05 81	 Data
			.byte $70, $3f, $bc, $82	; $bc48: 70 3f bc 82	 Data
			.byte $01, $05, $01, $be	; $bc4c: 01 05 01 be	 Data
			.byte $00, $00, $00, $00	; $bc50: 00 00 00 00	 Data
			.byte $01, $57, $bc, $94	; $bc54: 01 57 bc 94	 Data
			.byte $03, $93, $82, $20	; $bc58: 03 93 82 20	 Data
			.byte $41, $e6, $49, $89	; $bc5c: 41 e6 49 89	 Data
			.byte $01, $95, $5c, $bc	; $bc60: 01 95 5c bc	 Data
			.byte $82, $01, $05, $02	; $bc64: 82 01 05 02	 Data
			.byte $7f, $05, $42, $00	; $bc68: 7f 05 42 00	 Data
			.byte $a5, $01, $70, $bc	; $bc6c: a5 01 70 bc	 Data
			.byte $8f, $05, $8d, $70	; $bc70: 8f 05 8d 70	 Data
			.byte $04, $20, $e3, $8f	; $bc74: 04 20 e3 8f	 Data
			.byte $02, $81, $70, $75	; $bc78: 02 81 70 75	 Data
			.byte $bc, $96, $00, $93	; $bc7c: bc 96 00 93	 Data
			.byte $82, $40, $20, $e3	; $bc80: 82 40 20 e3	 Data
			.byte $95, $82, $bc, $82	; $bc84: 95 82 bc 82	 Data
			.byte $02, $05, $03, $3f	; $bc88: 02 05 03 3f	 Data
			.byte $04, $43, $00, $00	; $bc8c: 04 43 00 00	 Data
			.byte $01, $9d, $bc, $04	; $bc90: 01 9d bc 04	 Data
			.byte $01, $7f, $04, $42	; $bc94: 01 7f 04 42	 Data
			.byte $00, $00, $00, $ad	; $bc98: 00 00 00 ad	 Data
			.byte $bc, $8f, $01, $8d	; $bc9c: bc 8f 01 8d	 Data
			.byte $70, $10, $44, $e1	; $bca0: 70 10 44 e1	 Data
			.byte $89, $01, $8f, $01	; $bca4: 89 01 8f 01	 Data
			.byte $81, $70, $a2, $bc	; $bca8: 81 70 a2 bc	 Data
			.byte $82, $8d, $77, $10	; $bcac: 82 8d 77 10	 Data
			.byte $49, $e1, $89, $01	; $bcb0: 49 e1 89 01	 Data
			.byte $81, $77, $b0, $bc	; $bcb4: 81 77 b0 bc	 Data
			.byte $82, $02, $04, $01	; $bcb8: 82 02 04 01	 Data
			.byte $3f, $10, $44, $00	; $bcbc: 3f 10 44 00	 Data
			.byte $00, $00, $eb, $bc	; $bcc0: 00 00 eb bc	 Data
			.byte $05, $03, $7f, $10	; $bcc4: 05 03 7f 10	 Data
			.byte $44, $00, $00, $01	; $bcc8: 44 00 00 01	 Data
			.byte $ce, $bc, $8f, $05	; $bccc: ce bc 8f 05	 Data
			.byte $8d, $70, $0a, $29	; $bcd0: 8d 70 0a 29	 Data
			.byte $e2, $89, $03, $8f	; $bcd4: e2 89 03 8f	 Data
			.byte $01, $81, $70, $d3	; $bcd8: 01 81 70 d3	 Data
			.byte $bc, $8d, $70, $0a	; $bcdc: bc 8d 70 0a	 Data
			.byte $29, $e1, $89, $ff	; $bce0: 29 e1 89 ff	 Data
			.byte $8f, $ff, $81, $70	; $bce4: 8f ff 81 70	 Data
			.byte $e0, $bc, $82, $8d	; $bce8: e0 bc 82 8d	 Data
			.byte $77, $0a, $31, $e2	; $bcec: 77 0a 31 e2	 Data
			.byte $89, $03, $81, $77	; $bcf0: 89 03 81 77	 Data
			.byte $ee, $bc, $8d, $77	; $bcf4: ee bc 8d 77	 Data
			.byte $0a, $31, $e1, $89	; $bcf8: 0a 31 e1 89	 Data
			.byte $ff, $81, $77, $f9	; $bcfc: ff 81 77 f9	 Data
			.byte $bc, $82, $01, $05	; $bd00: bc 82 01 05	 Data
			.byte $01, $bf, $00, $41	; $bd04: 01 bf 00 41	 Data
			.byte $12, $00, $01, $0d	; $bd08: 12 00 01 0d	 Data
			.byte $bd, $38, $eb, $82	; $bd0c: bd 38 eb 82	 Data
			.byte $00, $20, $71, $87	; $bd10: 00 20 71 87	 Data
			.byte $05, $01, $05, $42	; $bd14: 05 01 05 42	 Data
			.byte $be, $00, $00, $00	; $bd18: be 00 00 00	 Data
			.byte $00, $01, $20, $bd	; $bd1c: 00 01 20 bd	 Data
			.byte $8d, $77, $01, $9e	; $bd20: 8d 77 01 9e	 Data
			.byte $33, $bd, $8f, $01	; $bd24: 33 bd 8f 01	 Data
			.byte $8d, $70, $0d, $5c	; $bd28: 8d 70 0d 5c	 Data
			.byte $e3, $8f, $01, $81	; $bd2c: e3 8f 01 81	 Data
			.byte $70, $2b, $bd, $8f	; $bd30: 70 2b bd 8f	 Data
			.byte $00, $8f, $0e, $5c	; $bd34: 00 8f 0e 5c	 Data
			.byte $e5, $8d, $77, $ff	; $bd38: e5 8d 77 ff	 Data
			.byte $5c, $e8, $82, $01	; $bd3c: 5c e8 82 01	 Data
			.byte $04, $03, $3f, $0f	; $bd40: 04 03 3f 0f	 Data
			.byte $42, $00, $00, $01	; $bd44: 42 00 00 01	 Data
			.byte $4a, $bd, $99, $8f	; $bd48: 4a bd 99 8f	 Data
			.byte $1f, $93, $88, $20	; $bd4c: 1f 93 88 20	 Data
			.byte $0d, $e1, $8f, $00	; $bd50: 0d e1 8f 00	 Data
			.byte $8f, $19, $14, $e1	; $bd54: 8f 19 14 e1	 Data
			.byte $8f, $00, $8f, $1d	; $bd58: 8f 00 8f 1d	 Data
			.byte $11, $e1, $8f, $00	; $bd5c: 11 e1 8f 00	 Data
			.byte $8f, $1b, $18, $e1	; $bd60: 8f 1b 18 e1	 Data
			.byte $8f, $00, $8f, $1f	; $bd64: 8f 00 8f 1f	 Data
			.byte $95, $50, $bd, $99	; $bd68: 95 50 bd 99	 Data
			.byte $82, $02, $04, $01	; $bd6c: 82 02 04 01	 Data
			.byte $3f, $10, $44, $0c	; $bd70: 3f 10 44 0c	 Data
			.byte $00, $00, $96, $bd	; $bd74: 00 00 96 bd	 Data
			.byte $05, $03, $3f, $10	; $bd78: 05 03 3f 10	 Data
			.byte $44, $f4, $00, $01	; $bd7c: 44 f4 00 01	 Data
			.byte $82, $bd, $8f, $05	; $bd80: 82 bd 8f 05	 Data
			.byte $87, $37, $8d, $70	; $bd84: 87 37 8d 70	 Data
			.byte $0c, $29, $e2, $89	; $bd88: 0c 29 e2 89	 Data
			.byte $03, $8a, $01, $8f	; $bd8c: 03 8a 01 8f	 Data
			.byte $01, $81, $70, $89	; $bd90: 01 81 70 89	 Data
			.byte $bd, $82, $87, $79	; $bd94: bd 82 87 79	 Data
			.byte $8d, $77, $01, $31	; $bd98: 8d 77 01 31	 Data
			.byte $e2, $89, $03, $8a	; $bd9c: e2 89 03 8a	 Data
			.byte $01, $81, $77, $9b	; $bda0: 01 81 77 9b	 Data
			.byte $bd, $90, $02, $8f	; $bda4: bd 90 02 8f	 Data
			.byte $01, $8d, $70, $01	; $bda8: 01 8d 70 01	 Data
			.byte $5c, $e3, $8f, $01	; $bdac: 5c e3 8f 01	 Data
			.byte $81, $70, $ac, $bd	; $bdb0: 81 70 ac bd	 Data
			.byte $8f, $00, $8f, $0e	; $bdb4: 8f 00 8f 0e	 Data
			.byte $5c, $ea, $82, $02	; $bdb8: 5c ea 82 02	 Data
			.byte $05, $02, $3e, $10	; $bdbc: 05 02 3e 10	 Data
			.byte $44, $00, $00, $03	; $bdc0: 44 00 00 03	 Data
			.byte $d0, $bd, $04, $01	; $bdc4: d0 bd 04 01	 Data
			.byte $3e, $10, $44, $00	; $bdc8: 3e 10 44 00	 Data
			.byte $00, $01, $e8, $bd	; $bdcc: 00 01 e8 bd	 Data
			.byte $8f, $0c, $87, $04	; $bdd0: 8f 0c 87 04	 Data
			.byte $8d, $70, $0c, $50	; $bdd4: 8d 70 0c 50	 Data
			.byte $e1, $8a, $01, $81	; $bdd8: e1 8a 01 81	 Data
			.byte $70, $d7, $bd, $93	; $bddc: 70 d7 bd 93	 Data
			.byte $82, $40, $20, $e3	; $bde0: 82 40 20 e3	 Data
			.byte $95, $e2, $bd, $82	; $bde4: 95 e2 bd 82	 Data
			.byte $87, $00, $8d, $70	; $bde8: 87 00 8d 70	 Data
			.byte $0c, $44, $e1, $8a	; $bdec: 0c 44 e1 8a	 Data
			.byte $01, $81, $70, $ed	; $bdf0: 01 81 70 ed	 Data
			.byte $bd, $93, $82, $40	; $bdf4: bd 93 82 40	 Data
			.byte $19, $e3, $95, $f8	; $bdf8: 19 e3 95 f8	 Data
			.byte $bd, $82, $01, $05	; $bdfc: bd 82 01 05	 Data
			.byte $02, $35, $00, $00	; $be00: 02 35 00 00	 Data
			.byte $00, $00, $01, $09	; $be04: 00 00 01 09	 Data
			.byte $be, $8f, $01, $8e	; $be08: be 8f 01 8e	 Data
			.byte $1e, $8d, $70, $06	; $be0c: 1e 8d 70 06	 Data
			.byte $19, $e2, $8a, $01	; $be10: 19 e2 8a 01	 Data
			.byte $81, $70, $10, $be	; $be14: 81 70 10 be	 Data
			.byte $8e, $00, $8f, $01	; $be18: 8e 00 8f 01	 Data
			.byte $93, $88, $b0, $52	; $be1c: 93 88 b0 52	 Data
			.byte $e2, $8f, $1f, $95	; $be20: e2 8f 1f 95	 Data
			.byte $1f, $be, $82, $01	; $be24: 1f be 82 01	 Data
			.byte $05, $02, $7e, $10	; $be28: 05 02 7e 10	 Data
			.byte $44, $0c, $00, $01	; $be2c: 44 0c 00 01	 Data
			.byte $32, $be, $8f, $05	; $be30: 32 be 8f 05	 Data
			.byte $87, $74, $8d, $70	; $be34: 87 74 8d 70	 Data
			.byte $0a, $20, $e3, $8f	; $be38: 0a 20 e3 8f	 Data
			.byte $01, $8a, $01, $81	; $be3c: 01 8a 01 81	 Data
			.byte $70, $39, $be, $93	; $be40: 70 39 be 93	 Data
			.byte $82, $40, $20, $e3	; $be44: 82 40 20 e3	 Data
			.byte $95, $46, $be, $82	; $be48: 95 46 be 82	 Data
			.byte $02, $05, $03, $3f	; $be4c: 02 05 03 3f	 Data
			.byte $10, $44, $fc, $00	; $be50: 10 44 fc 00	 Data
			.byte $01, $61, $be, $04	; $be54: 01 61 be 04	 Data
			.byte $01, $7f, $10, $44	; $be58: 01 7f 10 44	 Data
			.byte $fc, $00, $00, $87	; $be5c: fc 00 00 87	 Data
			.byte $be, $87, $35, $8f	; $be60: be 87 35 8f	 Data
			.byte $05, $8d, $70, $08	; $be64: 05 8d 70 08	 Data
			.byte $29, $e2, $89, $07	; $be68: 29 e2 89 07	 Data
			.byte $8f, $01, $8a, $01	; $be6c: 8f 01 8a 01	 Data
			.byte $81, $70, $68, $be	; $be70: 81 70 68 be	 Data
			.byte $87, $3f, $8f, $00	; $be74: 87 3f 8f 00	 Data
			.byte $8f, $0c, $89, $0c	; $be78: 8f 0c 89 0c	 Data
			.byte $90, $02, $93, $82	; $be7c: 90 02 93 82	 Data
			.byte $40, $20, $e3, $95	; $be80: 40 20 e3 95	 Data
			.byte $81, $be, $82, $87	; $be84: 81 be 82 87	 Data
			.byte $33, $8d, $77, $0a	; $be88: 33 8d 77 0a	 Data
			.byte $31, $e2, $89, $03	; $be8c: 31 e2 89 03	 Data
			.byte $8a, $01, $81, $77	; $be90: 8a 01 81 77	 Data
			.byte $8c, $be, $8d, $77	; $be94: 8c be 8d 77	 Data
			.byte $0a, $31, $e1, $89	; $be98: 0a 31 e1 89	 Data
			.byte $ff, $81, $77, $99	; $be9c: ff 81 77 99	 Data
			.byte $be, $82, $98, $30	; $bea0: be 82 98 30	 Data
			.byte $16, $ad, $c0, $04	; $bea4: 16 ad c0 04	 Data
			.byte $09, $80, $8d, $c0	; $bea8: 09 80 8d c0	 Data
			.byte $04, $a9, $ff, $8d	; $beac: 04 a9 ff 8d	 Data
			.byte $c3, $04, $bd, $a7	; $beb0: c3 04 bd a7	 Data
			.byte $bf, $8d, $c1, $04	; $beb4: bf 8d c1 04	 Data
			.byte $8d, $c2, $04, $a5	; $beb8: 8d c2 04 a5	 Data
			.byte $00, $29, $0f, $f0	; $bebc: 00 29 0f f0	 Data
			.byte $11, $ad, $c0, $04	; $bec0: 11 ad c0 04	 Data
			.byte $29, $7f, $c9, $02	; $bec4: 29 7f c9 02	 Data
			.byte $b0, $08, $a9, $01	; $bec8: b0 08 a9 01	 Data
			.byte $8d, $c0, $04, $4c	; $becc: 8d c0 04 4c	 Data
			.byte $f5, $be, $ce, $c2	; $bed0: f5 be ce c2	 Data
			.byte $04, $d0, $1d, $bd	; $bed4: 04 d0 1d bd	 Data
			.byte $ac, $bf, $bc, $b0	; $bed8: ac bf bc b0	 Data
			.byte $bf, $85, $a5, $84	; $bedc: bf 85 a5 84	 Data
			.byte $a6, $ad, $c1, $04	; $bee0: a6 ad c1 04	 Data
			.byte $8d, $c2, $04, $ee	; $bee4: 8d c2 04 ee	 Data
			.byte $c3, $04, $ac, $c3	; $bee8: c3 04 ac c3	 Data
			.byte $04, $b1, $a5, $f0	; $beec: 04 b1 a5 f0	 Data
			.byte $04, $20, $d2, $c0	; $bef0: 04 20 d2 c0	 Data
			.byte $60, $ad, $c0, $04	; $bef4: 60 ad c0 04	 Data
			.byte $29, $7f, $8d, $c0	; $bef8: 29 7f 8d c0	 Data
			.byte $04, $ee, $c0, $04	; $befc: 04 ee c0 04	 Data
			.byte $ad, $c0, $04, $c9	; $bf00: ad c0 04 c9	 Data
			.byte $03, $d0, $03, $20	; $bf04: 03 d0 03 20	 Data
			.byte $18, $bf, $ae, $c0	; $bf08: 18 bf ae c0	 Data
			.byte $04, $bd, $a7, $bf	; $bf0c: 04 bd a7 bf	 Data
			.byte $d0, $05, $a9, $ff	; $bf10: d0 05 a9 ff	 Data
			.byte $8d, $c0, $04, $60	; $bf14: 8d c0 04 60	 Data
			.byte $a9, $1e, $85, $e9	; $bf18: a9 1e 85 e9	 Data
			.byte $a9, $1c, $85, $eb	; $bf1c: a9 1c 85 eb	 Data
			.byte $a0, $78, $a2, $00	; $bf20: a0 78 a2 00	 Data
			.byte $bd, $2f, $bf, $9d	; $bf24: bd 2f bf 9d	 Data
			.byte $04, $02, $e8, $88	; $bf28: 04 02 e8 88	 Data
			.byte $d0, $f6, $60, $51	; $bf2c: d0 f6 60 51	 Data
			.byte $c2, $02, $90, $51	; $bf30: c2 02 90 51	 Data
			.byte $c4, $02, $98, $61	; $bf34: c4 02 98 61	 Data
			.byte $c6, $02, $90, $61	; $bf38: c6 02 90 61	 Data
			.byte $c8, $02, $98, $71	; $bf3c: c8 02 98 71	 Data
			.byte $ca, $02, $80, $71	; $bf40: ca 02 80 71	 Data
			.byte $cc, $02, $88, $71	; $bf44: cc 02 88 71	 Data
			.byte $ce, $02, $90, $71	; $bf48: ce 02 90 71	 Data
			.byte $d0, $02, $98, $81	; $bf4c: d0 02 98 81	 Data
			.byte $d2, $02, $80, $81	; $bf50: d2 02 80 81	 Data
			.byte $d4, $02, $88, $81	; $bf54: d4 02 88 81	 Data
			.byte $d6, $02, $90, $81	; $bf58: d6 02 90 81	 Data
			.byte $d8, $02, $98, $41	; $bf5c: d8 02 98 41	 Data
			.byte $e8, $01, $c8, $41	; $bf60: e8 01 c8 41	 Data
			.byte $ea, $01, $d0, $51	; $bf64: ea 01 d0 51	 Data
			.byte $ec, $01, $c8, $51	; $bf68: ec 01 c8 51	 Data
			.byte $ee, $01, $d0, $51	; $bf6c: ee 01 d0 51	 Data
			.byte $f0, $01, $d8, $61	; $bf70: f0 01 d8 61	 Data
			.byte $e2, $01, $a0, $61	; $bf74: e2 01 a0 61	 Data
			.byte $e4, $01, $a8, $61	; $bf78: e4 01 a8 61	 Data
			.byte $f2, $01, $d0, $61	; $bf7c: f2 01 d0 61	 Data
			.byte $f4, $01, $d8, $61	; $bf80: f4 01 d8 61	 Data
			.byte $f6, $01, $e0, $71	; $bf84: f6 01 e0 71	 Data
			.byte $e6, $01, $a0, $71	; $bf88: e6 01 a0 71	 Data
			.byte $f8, $01, $d0, $71	; $bf8c: f8 01 d0 71	 Data
			.byte $fa, $01, $d8, $71	; $bf90: fa 01 d8 71	 Data
			.byte $fc, $01, $e0, $81	; $bf94: fc 01 e0 81	 Data
			.byte $de, $00, $90, $81	; $bf98: de 00 90 81	 Data
			.byte $e0, $00, $98, $91	; $bf9c: e0 00 98 91	 Data
			.byte $da, $00, $40, $91	; $bfa0: da 00 40 91	 Data
			.byte $dc, $00, $48, $08	; $bfa4: dc 00 48 08	 Data
			.byte $88, $04, $04, $00	; $bfa8: 88 04 04 00	 Data
			.byte $b4, $b6, $b8, $bd	; $bfac: b4 b6 b8 bd	 Data
			.byte $bf, $bf, $bf, $bf	; $bfb0: bf bf bf bf	 Data
			.byte $3e, $00, $3e, $00	; $bfb4: 3e 00 3e 00	 Data
			.byte $3e, $3f, $40, $41	; $bfb8: 3e 3f 40 41	 Data
			.byte $00, $41, $42, $43	; $bfbc: 00 41 42 43	 Data
			.byte $44, $00, $bd, $e0	; $bfc0: 44 00 bd e0	 Data
			.byte $32, $30, $2a, $09	; $bfc4: 32 30 2a 09	 Data
			.byte $ac, $9d, $e0, $32	; $bfc8: ac 9d e0 32	 Data
			.byte $9e, $b0, $32, $9e	; $bfcc: 9e b0 32 9e	 Data
			.byte $50, $35, $20, $a5	; $bfd0: 50 35 20 a5	 Data
			.byte $be, $9e, $70, $33	; $bfd4: be 9e 70 33	 Data
			.byte $78, $d8, $ee, $df	; $bfd8: 78 d8 ee df	 Data
			.byte $ff, $4c, $00, $c0	; $bfdc: ff 4c 00 c0	 Data

			BankEnd
			.endlogical