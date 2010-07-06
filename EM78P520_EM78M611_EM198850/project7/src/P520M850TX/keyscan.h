/*********************************************************************
* Filename     :  EM78P520P44TX.ASM
* Author       :  yu.wei
* Company      :  KEN YEAR
* VERSION      :  4.0
* CRYSTAL      :  8MHZ
* Creat date   :  2010.06.25
* tool Ver.    :  eUIDE 1.02.11
* Description  :  modify for 2.4G remote control in Intelligen Home 
**********************************************************************/

;======================================================================
keyscan.h           EQU        keyscan.h


;----------------------------------------------------------------
ADC_FUNCTION        EQU        1                  ; 0 -> IO_FUNCTION(default:0)
                                                  ; 1 -> ADC_FUNCTION
IOtoADC_T_DEBUG     EQU        0                                                  
Kr                  EQU        5                  ; ¦¸Kr=5k/10k
LeakresisTimeCNT    EQU        10                 ; Leakresis time(default:4).T = LeakresisTimeCNT*[interrupt Time]
IOCheckRate         EQU        3                  ; timer2 counter. Check IO when Time arrive (default:3)
reg_acc             EQU        DataShiftCNT





;======================= key scan port define =========================
X_KeyLine           EQU        PORT7
X_LINE1             ==         X_KeyLine*16+4		;R74
X_LINE2             ==         X_KeyLine*16+5		;R73
X_LINE3             ==         X_KeyLine*16+6		;R72
X_LINE4             ==         X_KeyLine*16+7		;R71

X_Keyrow            EQU        PORT9
X_ROW1              ==         X_Keyrow*16+7		;R97
X_ROW2              ==         X_Keyrow*16+6		;R96
X_ROW3              ==         X_Keyrow*16+5		;R95
X_ROW4              ==         X_Keyrow*16+4		;R94

;
Reference           ==         7          ;port87
Leakresis           ==         6          ;port86
LeftYAxis           ==         0          ;port90  LY
LeftXAxis           ==         1          ;port91  LX
RightYAxis          ==         2          ;port92  RY
RightXAxis          ==         3          ;port93  RX

;------------------------ Define form SCH ----------------------------
_DireInput          EQU        0B00110111 ;PB5/PB4/PB2/P81/PB0 as input

_UP                 ==         5    ;PortB5
_RIGHT              ==         4    ;PortB4
_DOWN               ==         2    ;PortB2
_LEFT               ==         1    ;PortB1


;--------------------------------------------------
_A                  ==         7    ;Port97
_B                  ==         6    ;Port96
_C                  ==         5    ;Port95
_D                  ==         4    ;Port94

_L1                 ==         7    ;Port97
_R1                 ==         6    ;Port96
_L2                 ==         5    ;Port95
_R2                 ==         4    ;Port94

_SELECT             ==         7    ;Port97
_START              ==         6    ;Port96
_LSW                ==         7    ;Port97
_RSW                ==         4    ;Port94

_MODE               ==         5    ;Port95
_MACRO              ==         4    ;Port94
_TEST1              ==         6    ;Port96
_TEST2              ==         5    ;Port95

;----------------- Define by data -------------------
A_1                 ==         0    ;DataE
B_2                 ==         1
C_3                 ==         2
D_4                 ==         3
L1_5                ==         4
R1_6                ==         5
L2_7                ==         6
R2_8                ==         7

SELECT_9            ==         0    ;DataF
START_10            ==         1
LSW_11              ==         2
RSW_12              ==         3
MODE_13             ==         4
MACRO_14            ==         5
TEST1_15            ==         6
TEST2_16            ==         7


;=============== Connect key scan ======================
KeyPressTime                EQU    180
KeyScanTime                 EQU    60
CrossingTime                EQU    30
KeyScanTimeCNT_default      EQU    2     




