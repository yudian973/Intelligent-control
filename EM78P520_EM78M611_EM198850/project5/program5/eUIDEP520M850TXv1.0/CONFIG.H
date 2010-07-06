/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
; Company       : ELAN
; VERSION       : 1.1
; CRYSTAL       : 8MHZ
; Creat date    : 2009/11/4
; tool ver.     : WicePlus 2.7/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
;-------------------------------------------------------------------------
config.h   EQU    config.h

;-------------------------------------------------------------------------

USED_PID_FUNCTION               EQU     0     ; 1:used this function; 0:not used
DataBufferBase                  EQU     0x20  ; address:0x20 ,bit6:select all bank
DelayTime                       EQU     2     ; Delay Time
ComuSyncTime                    EQU     4     ; 4ms sync header time
ComuTime                        EQU     4     ; 4ms Communicte System
RetryCNT                        EQU     0     ; transmit 2 Times
SetSleepTime                    EQU     250   ; Into sleep Time=(SetSleepTime+1)*2s
RX_IDH_DEFAULT                  EQU     0X9D  
RX_IDL_DEFAULT                  EQU     0XBC  ; Adress_default =  [RX_IDH_DEFAULT,RX_IDL_DEFAULT&0x0f]
LossframeSum                    EQU     3
LEDTwinklingFreq                EQU     50    ; T=LEDTwinklingFreq*(ComuSyncTime+n*ComuTime), default=400ms


