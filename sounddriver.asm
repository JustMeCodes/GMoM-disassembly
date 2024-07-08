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

CSF_SetLoopCount .function count, unk=$70
			.byte $8d, unk, count
		.endf

CSF_Loop .function address, unk=$70
			.byte $81, unk
			.addr address
		.endf

CSF_Stop .macro
			.byte $82
		.endm

CSF_SetVoice .function id
			.byte $88, id
		.endf
		
CSF_Cmd9C .function address, y
			.byte $9с, y
			.addr address
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

			; Push Sound_ReadTrack to the stack
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
					; the command then returns to Sound_ReadTrack

;-------------------------------------------------------------------------------
			TableStart
			TableInsert Sound_CmdJump	; $80
			TableInsert Sound_CmdLoop	; $81
			TableInsert Sound_CmdStop	; $82
			TableInsert Sound_82d7	; $83
			TableInsert Sound_8321	; $84
			TableInsert Sound_82d0	; $85
			TableInsert Sound_82c5	; $86
			TableInsert Sound_830b	; $87
			TableInsert Sound_CmdSetVoice	; $88
			TableInsert Sound_82df	; $89
			TableInsert Sound_82ed ; $8A
			TableInsert Sound_PlaySound ; $8B
			TableInsert Sound_8415 ; $8C
			TableInsert Sound_CmdSetLoopCount ; $8D 
			TableInsert Sound_83bd ; $8E
			TableInsert Sound_83c1 ; $8F
			TableInsert Sound_82e9 ; $90
			TableInsert Sound_8340 ; $91
			TableInsert Sound_83a0 ; $92 has more arguments
			TableInsert Sound_8347 ; $93 has more arguments
			TableInsert Sound_83e6 ; $94
			TableInsert Sound_8374 ; $95 has more arguments
			TableInsert Sound_83b9 ; $96
			TableInsert Sound_841f ; $97
			TableInsert Sound_8417 ; $98
			TableInsert Sound_840d ; $99
			TableInsert Sound_8423 ; $9A
			TableInsert Sound_8423 ; $9B
			TableInsert Sound_838b ; $9C has more arguments
			TableInsert Sound_841b ; $9D
			TableInsert Sound_8382 ; $9E
			TableInsert Sound_841f ; $9F
			TableInsert Sound_8318 ; $A0

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
Sound_CmdSetLoopCount:
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
MusID_TheEarth:		TableInsert Music_TheEarth
MusID_MainMenu:		TableInsert Music_MainMenu
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
			.include "data/sound/music/japantitle.asm"
Music_TheEarth:
			.include "data/sound/music/theearth.asm"
Music_MainMenu:
			.include "data/sound/music/mainmenu.asm"
Music_GameOver:
			.include "data/sound/music/gameover.asm"
Music_Death:
			.include "data/sound/music/death.asm"
Music_Unused1:
			.include "data/sound/music/unused1.asm"
Music_Unused2:
			.include "data/sound/music/unused2.asm"
Music_InternTitle: ; Needs checking for more commands with address arguments
			.include "data/sound/music/interntitle_planetx.asm"
Music_Mars:
			.include "data/sound/music/mars.asm"
Music_Neptune:
			.include "data/sound/music/neptune.asm"
Music_Saturn:
			.include "data/sound/music/saturn.asm"
Music_Jupiter:
			.include "data/sound/music/jupiter.asm"
Music_Pluto:
			.include "data/sound/music/pluto.asm"
Music_Uranus:
			.include "data/sound/music/uranus.asm"
Music_Moguera:
			.include "data/sound/music/moguera_baragon.asm"
Music_Hedorah:
			.include "data/sound/music/hedorah.asm"
Music_Gigan:
			.include "data/sound/music/gigan.asm"
Music_MechaGodzilla:
			.include "data/sound/music/mechagodzilla.asm"
Music_Gezora:
			.include "data/sound/music/gezora.asm"
Music_Ghidorah:
			.include "data/sound/music/ghidorah.asm"
Music_BossDefeat:
			.include "data/sound/music/bossdefeat.asm"
Music_Unused3:
			.include "data/sound/music/unused3.asm"
Music_Credits:
			.include "data/sound/music/credits.asm"
Music_Unused4:
			.include "data/sound/music/unused4_gh1d0ra.asm"
Music_PasswordGame:
			.include "data/sound/music/password.asm"
Music_JapanSolar:
			.include "data/sound/music/japansolar.asm"
Music_Varan:
			.include "data/sound/music/varan.asm"

			.byte $00, $00	; $ba7e: 00 00	 Data
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