/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
; Company       : ELAN
; VERSION       : 4.0
; CRYSTAL       : 8MHZ
; Creat date    : 2009/11/4
; tool Ver.     : WicePlus 2.7/eUIDE
* Description  :  modify for code conformity,multi-1v2 CMOS project
*****************************************************************/
;-------------------------------------------------------------------------
config.h   EQU    config.h

;-------------------------------------------------------------------------
DebugDisplay                    EQU     1     ; debug switch
MassageDisplay                  EQU     0     ; massage display switch
DataBufferBase                  EQU     0x20  ; address:0x20 ,bit6:select all bank
SetComuSyncTime                 EQU     4     ; 2ms sync header time
SetComuTime                     EQU     4     ; 4ms Communicte System
SetSleepTime                    EQU     250   ; Into sleep Time=(SetSleepTime+1)*2s, default=250
RX_IDH_DEFAULT                  EQU     0X9D  ; 0XD6  ; 0X9D
RX_IDL_DEFAULT                  EQU     0XCB  ; 0XAC  ; 0XCB  ; Adress_default = [RX_IDH_DEFAULT,RX_IDL_DEFAULT&0x0f]
LEDTwinklingFreq                EQU     50    ; T=LEDTwinklingFreq*(ComuSyncTime+n*SetComuTime), default=50(400ms)
SetChecksumH                    EQU     0X12  ; transmitter cheaksum high byte
SetChecksumL                    EQU     0X34  ; transmitter cheaksum low byte



