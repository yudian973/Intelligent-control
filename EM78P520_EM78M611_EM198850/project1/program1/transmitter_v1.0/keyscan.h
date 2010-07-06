keyscan.h           EQU        keyscan.h

KeystokePort        EQU        00100000B

;========================= key define ============================
X_KeyLine           EQU        PORT7
X_LINE1             EQU        X_KeyLine*16+4		;R74
X_LINE2             EQU        X_KeyLine*16+5		;R73
X_LINE3             EQU        X_KeyLine*16+6		;R72
X_LINE4             EQU        X_KeyLine*16+7		;R71

X_Keyrow            EQU        PORT9
X_ROW1              EQU        X_Keyrow*16+7		;R97
X_ROW2              EQU        X_Keyrow*16+6		;R96
X_ROW3              EQU        X_Keyrow*16+5		;R95
X_ROW4              EQU        X_Keyrow*16+4		;R94

;LED_VR_STATUS       ==         PORT8*16+1

