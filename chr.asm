;-------------------------------------------------------------------------------
;   Needed macros
;-------------------------------------------------------------------------------

;   A function that loads the art and returns it's chr bank id and offset in bank
ChrArt	.function file
	_ChrFile:	.binary file
	.endf {.bank: _ChrFile/CHRBankSize, .tile = (_ChrFile % CHRBankSize)/$10}

ChrBankStart .segment id=-1
	.cwarn (\id != -1) && (*/CHRBankSize)!=\id, "Bank IDs do not match (expected id - " .. repr(floor(\id)) .. ", actual id - " .. repr(*/CHRBankSize) .. ")"
	CHR_CurrentBankStart .var *
	.endsegment \id

ChrBankEnd .function
	BankID = */CHRBankSize

	.cwarn Debug && (* % CHRBankSize)!=0, "CHR Bank " .. repr(bytes(BankID)) .. " is not full"
	.cerror * > (CHR_CurrentBankStart+CHRBankSize), "CHR Bank " .. repr(bytes(BankID)) .. " is too big (actual size is " .. repr(*-CHR_CurrentBankStart) .. ", expected size is " .. repr(CHRBankSize) .. ")"

	.align CHRBankSize
	.endf

; TODO: add where needed
CHR_EmptyAndFilledTiles .macro
    .fill 16, 0
	.fill 16, $FF
	.endm

CHR_FillUntil .macro addr
	.fill \addr-(*%CHRBankSize)
	.endm

;-------------------------------------------------------------------------------
	; TODO: properly name all .chr files and add stuff to levels/ and characters/ folders
		.cpu "65816"    ; So we can use 3-byte addresses
		.logical 0      ; Reset current address to 0

; Bank 0 - Texts
	ChrBankStart 0
		ChrArt "data/art/bank00.chr"
	ChrBankEnd

CHR_BoardPieces_Static:	ChrBankStart 1
		ChrArt "data/art/bank01.chr"
	ChrBankEnd

CHR_BoardPieces_Sprites:ChrBankStart 2
		ChrArt "data/art/bank02.chr"
	ChrBankEnd

	ChrBankStart 3
		ChrArt "data/art/bank03.chr"
	ChrBankEnd

	ChrBankStart 4
		ChrArt "data/art/bank04.chr"
	ChrBankEnd

	ChrBankStart 5
		ChrArt "data/art/bank05.chr"
	ChrBankEnd

	ChrBankStart 6
		ChrArt "data/art/bank06.chr"
	ChrBankEnd

	ChrBankStart 7
		ChrArt "data/art/bank07.chr"
	ChrBankEnd

	ChrBankStart 8
		ChrArt "data/art/bank08.chr"
	ChrBankEnd

	ChrBankStart 9
		ChrArt "data/art/bank09.chr"
	ChrBankEnd

	ChrBankStart $A
		ChrArt "data/art/bank0A.chr"
	ChrBankEnd

	ChrBankStart $B
		ChrArt "data/art/bank0B.chr"
	ChrBankEnd

	ChrBankStart $C
		ChrArt "data/art/bank0C.chr"
	ChrBankEnd

	ChrBankStart $D
		ChrArt "data/art/bank0D.chr"
	ChrBankEnd

CHR_IntroCutscene:	ChrBankStart $E
		ChrArt "data/art/bank0E.chr"
    ChrBankEnd

	ChrBankStart $F
		ChrArt "data/art/bank0F.chr"
	ChrBankEnd

	ChrBankStart $10
					CHR_EmptyAndFilledTiles
Art_MechaGodzilla:	ChrArt "data/art/bosses/MechaGodzilla.chr"
	ChrBankEnd

	ChrBankStart $11
				CHR_EmptyAndFilledTiles
Art_Hedorah:	ChrArt "data/art/bosses/Hedorah.chr"
				CHR_FillUntil $F30
				ChrArt "data/art/bosses/HedorahParticles.chr"
	ChrBankEnd

	ChrBankStart $12
				CHR_EmptyAndFilledTiles
Art_Ghidora:	ChrArt "data/art/bosses/Ghidora.chr"
	ChrBankEnd

	ChrBankStart $13
				CHR_EmptyAndFilledTiles
Art_Gezora:		ChrArt "data/art/bosses/Gezora.chr"
Art_Moguera:	ChrArt "data/art/bosses/Moguera.chr"
				CHR_FillUntil $F00
				ChrArt "data/art/bosses/GezoraTentacle.chr"
	ChrBankEnd

	ChrBankStart $14
			CHR_EmptyAndFilledTiles
Art_Varan:	ChrArt "data/art/bosses/Varan.chr"
	ChrBankEnd

	ChrBankStart $15
				CHR_EmptyAndFilledTiles
Art_Baragon:	ChrArt "data/art/bosses/Baragon.chr"
	ChrBankEnd

	ChrBankStart $16
			CHR_EmptyAndFilledTiles
Art_Gigan:	ChrArt "data/art/bosses/Gigan.chr"
	ChrBankEnd

	ChrBankStart $17
		ChrArt "data/art/bank17.chr"
	ChrBankEnd

	ChrBankStart $18
		ChrArt "data/art/bank18.chr"
	ChrBankEnd

	ChrBankStart $19
                    CHR_EmptyAndFilledTiles
Art_BoldFont:		ChrArt "data/art/BoldFont.chr"
Art_HUD = Art_BoldFont
Art_UranusSky:		ChrArt "data/art/skies/UranusSky.chr"
Art_PlanetXSky:		ChrArt "data/art/skies/PlanetXSky.chr"
Art_NeptuneSky:		ChrArt "data/art/skies/NeptuneSky.chr"
					ChrArt "data/art/bank19.chr"
	ChrBankEnd

	ChrBankStart $1A
                    CHR_EmptyAndFilledTiles
					ChrArt "data/art/BoldFont.chr"
Art_TheEarthSky:	ChrArt "data/art/skies/TheEarthSky.chr"
Art_SaturnSky:		ChrArt "data/art/skies/SaturnSky.chr"
					ChrArt "data/art/bank1A.chr"
	ChrBankEnd

	ChrBankStart $1B
                    CHR_EmptyAndFilledTiles
					ChrArt "data/art/BoldFont.chr"
Art_PlutoSky:		ChrArt "data/art/skies/PlutoSky.chr"
Art_MarsSky:		ChrArt "data/art/skies/MarsSky.chr"
Art_JupiterSky:		ChrArt "data/art/skies/JupiterSky.chr"
					ChrArt "data/art/bank1B.chr"
	ChrBankEnd

CHR_TitleScreen_Part1:	ChrBankStart $1C
		ChrArt "data/art/bank1C.chr"
	ChrBankEnd

CHR_TitleScreen_Part2:	ChrBankStart $1d
		ChrArt "data/art/bank1D.chr"
	ChrBankEnd

CHR_TitleScreen_Part3:	ChrBankStart $1E
		ChrArt "data/art/bank1E.chr"
	ChrBankEnd

CHR_Gohten:	ChrBankStart $1F
			ChrArt "data/art/bank1F.chr"
	ChrBankEnd

		.cwarn (*/CHRBankSize) > CHRBankCount, "The actual number of CHR rom banks is greater than 'CHRBankCount' constant, change the constant and the iNES mapper if needed"

		.endlogical