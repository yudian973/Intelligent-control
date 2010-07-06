/*****************************************************************
; Filename     :  EM78M611rxP40M1v6V10 config
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  4.0
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity,multi-1v2 CMOS project
*****************************************************************/
;-------------------------------------------------------------------------
config.h    EQU    config.h

;-------------------------------------------------------------------------
DebugDisplay                    EQU     1     ; debug switch
MassageDisplay                  EQU     0     ; massage display switch
USED_PID_FUNCTION               EQU     0     ; 1:used this function; 0:not used
GamePadsSum_Default             EQU     2
DataBufferBase                  EQU     0x20  ; Address:0x20 ,bit6:select all bank
SetComuSyncTime                 EQU     4     ; 4ms sync header time
SetComuTime                     EQU     4     ; 4ms Communicte System
RetryCNT                        EQU     0     ; transmit 0 Times Retry
RX_IDH_DEFAULT                  EQU     0XD6  ; 0X9D
RX_IDL_DEFAULT                  EQU     0XAC  ; 0XCB  ; Adress_default = [RX_IDH_DEFAULT,RX_IDL_DEFAULT&0x0f]
RX_ComuLoseCNT_Default          EQU     200   ; T=ComuTime+ComuSyncTime*RX_ComuLoseCNT_Default
SetChecksumH                    EQU     0XCD  ; host computer cheaksum high byte
SetChecksumL                    EQU     0XEF  ; host computer cheaksum low byte



