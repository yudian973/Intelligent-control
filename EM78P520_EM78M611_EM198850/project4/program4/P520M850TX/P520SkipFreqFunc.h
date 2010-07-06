 /*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.1
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/4
* tool Ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
;------------------------------------------------------------
P520SkipFreqFunc.h      EQU     P520SkipFreqFunc.h

;------------------------------------------------------------
COMMU_DEBUG             EQU     1     ; enable Communication debug
COMMU_T_DEBUG           EQU     1

SLEEP_DEBUG             EQU     0     ; sleep function debug
SLEEP_T_DEBUG           EQU     0     ; slepp time test debug

EEPROM_DEBUG            EQU     0     ; enable eeprom debug
WEEPROM_T_DEBUG         EQU     0     ; Dispaley write eeprom debug
REEPROM_T_DEBUG         EQU     0     ; Dispaley read eeprom debug

LossframeSum            EQU     3
RetryCNT                EQU     0     ; transmit 0 Times
DelayTime               EQU     2     ; Delay Time

