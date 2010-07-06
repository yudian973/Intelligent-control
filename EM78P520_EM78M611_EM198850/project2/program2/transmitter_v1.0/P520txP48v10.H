;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        RF_EM78M612_RECEIVE.H
;  Description: The Definition of EM78M198810 for EM78612 Registers ;
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7
;  Crystal:     12MHZ
;  Description: PAGE0: MCU initial
;               PAGE1: searchmode
;               PAGE2: normalmode
;               PAGE3: RF driver
;               PAGE4: key scan driver

;==========================================================================================
P510PIN32TXv14.H                EQU     P510PIN32TXv14.H

;==========================================================================================
DataBufferBase                  EQU     0x20  ;address:0x20 ,bit6:select all bank


;============================================================================================
TEMP                            EQU     0X10
TEMP1                           EQU     0X11
TEMP2                           EQU     0X12
TEMP3                           EQU     0X13
TEMP4                           EQU     0X14
TEMP5                           EQU     0X15

ComuClock                       EQU     0X16  ;communicateion clock
ComuCycleNum                    EQU     0X17  ;communicateion time
ComuEndNum                      EQU     0X18  ;communicateion end time
Databytelength                  EQU     0X19  ;FIFO READ/WRITE DATA LENGTH
DataShiftCounter                EQU     0X1A  ;data counter
A_TEMP                          EQU     0X1B    ;TEMP1 - TEMP3 used for PUSH and POP
RSR_TEMP                        EQU     0X1C
STATUS_TEMP                     EQU     0X1D

CommuStatusFlag                 EQU     0X1E
GeneralStatusFlag               EQU     0X1F

;------------------------------------------------------------------
;r_acc1                          EQU     TEMP1
;r_acc2                          EQU     TEMP2
;r_acc3                          EQU     TEMP3
DataAddressInMCU                EQU     TEMP4         ;93C46
DataAddressInEEPROM             EQU     TEMP5

;------------------------------------------------------------------
FccFreqIndex                    EQU     ComuEndNum    ;FCC TEST


;============================ BANK 0 (data buffer)============================


;============================ BANK 1 (RF variable)============================


;============================ BANK 2 (key data)============================



