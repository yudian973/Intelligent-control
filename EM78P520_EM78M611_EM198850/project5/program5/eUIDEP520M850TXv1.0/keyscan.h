;=============================================================================
;=============================================================================
; Filename      : KEYSCAN.ASM
; Author        : yu.wei
; Company       : ELAN
; VERSION       : 1.1
; CRYSTAL       : 8MHZ
; Creat date    : 2009/11/4
; tool ver.     : eUIDE
; descripition  : FOR_EM78P520,
;=============================================================================


keyscan.h           EQU        keyscan.h

;KeystokePort        EQU        0b00100000
LeakresisTimeCNT    EQU        50

;======================= key scan port define =========================
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

;------------------------ Define form SCH ----------------------------
_UP                 EQU        5    ;Port85
_RIGHT              EQU        4    ;Port84
_DOWN               EQU        2    ;Port82
_LEFT               EQU        1    ;Port81

_A                  EQU        7    ;Port97
_B                  EQU        6    ;Port96
_C                  EQU        5    ;Port95
_D                  EQU        4    ;Port94

_L1                 EQU        7    ;Port97
_R1                 EQU        6    ;Port96
_L2                 EQU        5    ;Port95
_R2                 EQU        4    ;Port94

_SELECT             EQU        7    ;Port97
_START              EQU        6    ;Port96
_LSW                EQU        7    ;Port97
_RSW                EQU        4    ;Port94

_MODE               EQU        5    ;Port95
_MACRO              EQU        4    ;Port94
_TEST1              EQU        6    ;Port96
_TEST2              EQU        5    ;Port95

;---------------------------------------------------------

A_1                 EQU        0    ;DataE
B_2                 EQU        1
C_3                 EQU        2
D_4                 EQU        3
L1_5                EQU        4
R1_6                EQU        5
L2_7                EQU        6
R2_8                EQU        7

SELECT_9            EQU        0    ;DataF
START_10            EQU        1
LSW_11              EQU        2
RSW_12              EQU        3
MODE_13             EQU        4
MACRO_14            EQU        5
TEST1_15            EQU        6
TEST2_16            EQU        7


;=============== Connect key scan ======================
KeyPressTime                EQU    180
KeyScanTime                 EQU    60
CrossingTime                EQU    30
KeyScanTimeCNT_default      EQU    2     




