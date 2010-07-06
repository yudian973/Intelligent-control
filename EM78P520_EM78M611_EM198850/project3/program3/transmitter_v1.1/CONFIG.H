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
ComuTime                        EQU     8     ; 8ms
RetryCNT                        EQU     0     ; transmit 2 Times
SetSleepTime                    EQU     200   ; T=(SetSleepTime+1)*2s
RX_IDH_DEFAULT                  EQU     0X97  
RX_IDL_DEFAULT                  EQU     0X3A  ; Adress_default =  (RX_IDL_DEFAULT&0x0f)|0x01
