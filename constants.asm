;-------------------------------------------------------------------------------
;	Constants
;-------------------------------------------------------------------------------
    
PlanetCount		= 8		; Number of playable planets
CharacterCount	= 12	; Number of characters

PRGBankSize = $4000
PRGBankCount = 8
	CheckPowerOfTwo PRGBankCount
    
CHRBankSize = $1000
CHRBankCount = 32
	CheckPowerOfTwo CHRBankCount

;	Input
Input_RAM =		$00
Btn_A = 		$01
Btn_B = 		$02
Btn_Select =	$04
Btn_Start =		$08
Btn_Up =		$10
Btn_Down =		$20
Btn_Left =		$40
Btn_Right =		$80

WriteToCHR1_RAM = $E8
WriteToCHR2_RAM = $E9

WriteToCHR1_RAM_Alt = $EB

Planet_TheEarth = 0
Planet_Mars = 1
Planet_Jupiter = 2
Planet_Saturn = 3
Planet_Uranus = 4
Planet_Pluto = 5
Planet_Neptune = 6
Planet_PlanetX = 7
