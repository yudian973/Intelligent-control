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
;------------------------------------------------------------
P520SkipFreqFunc.h      EQU     P520SkipFreqFunc.h

;------------------------------------------------------------
COMMU_DEBUG             EQU     1     ; enable Communication debug
COMMU_T_DEBUG           EQU     1

SLEEP_DEBUG             EQU     0     ; sleep function debug
SLEEP_T_DEBUG           EQU     0     ; slepp time test debug

EEPROM_DEBUG            EQU     0     ; enable eeprom debug
EEPROM_T_DEBUG          EQU     0     ; Dispaley write eeprom debug
REEPROM_T_DEBUG         EQU     0     ; Dispaley read eeprom debug

LossframeSum            EQU     3
RetryCNT                EQU     0     ; transmit 0 Times
DelayTime               EQU     2     ; Delay Time
