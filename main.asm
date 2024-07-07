;-------------------------------------------------------------------------------
;	Godzilla: Monster of Monsters (USA, NES) disassembly
;	made by JustMe using DISASM6, FCEUX and Mesen
;
;	Godzilla (C) Toho
;	G:MoM (C) Compile
;	Nintendo Entertainment System (NES) (C) Nintendo
;-------------------------------------------------------------------------------

Debug 	= 1

; Useful macros and constants
			.include "macros.asm"
			.include "constants.asm"

; Variables
			.include "variables.asm"

; Text encodings
			.include "encodings.asm"

; 	TODO: fix all Goto_CrossBankJump and CrossBankJump using CBJR, same for Main_SwitchBank
;	TODO: document palettes and make the use of their ids in the code

CBJR .macro
	.for arg in \@
bank .var arg&7
lbl .var bits($8000+((arg>>2)*1.5)+3)
	.warn "Cross bank jump reverse: bank-",repr(bank)," label-",repr(lbl)
	.endfor
	.endm

;		TODO: Fix all DrawTexts tables
aa .function a
y = (a-$2020)/$20
x = (a-$2020)-(y*$20)
	.warn bytes(x)
	.warn bytes(y)
	.endf

; iNES Header
			.text "NES"
			.byte $1A				; Header
			.byte PRGBankCount		; 16k PRG banks
			.byte CHRBankCount/2	; 8k CHR banks
			.byte %00010000			; Mirroring: Horizontal
									; SRAM: Not used
									; 512k Trainer: Not used
									; 4 Screen VRAM: Not used
									; Mapper: 1
			.byte %00000000			; RomType: NES
			.byte $00, $00, $00, $00	; iNES Tail
			.byte $00, $00, $00, $00

		; TODO: Bank constants
;-------------------------------------------------------------------------------
; PRG
;-------------------------------------------------------------------------------

			.include "sounddriver.asm"
			.include "bank1.asm"
			.include "bank2.asm"
			.include "bank3.asm"
			.include "bank4.asm"
			.include "bank5.asm"
			.include "bank6.asm"

	; Main bank has to be last
	.fill (PRGBankCount-LastBank-1)*PRGBankSize

			.include "mainbank.asm"

;-------------------------------------------------------------------------------
; CHR
;-------------------------------------------------------------------------------

			.include "chr.asm"

			.end
; End of ROM