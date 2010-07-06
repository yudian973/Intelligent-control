/*****************************************************************
; Filename     :  EM78M611rxP40M1v6V10 config
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  1.1
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity
*****************************************************************/
;-------------------------------------------------------------------------
config.h    EQU    config.h

;-------------------------------------------------------------------------

USED_PID_FUNCTION               EQU     0     ; 1:used this function; 0:not used
TotalGamePads                   EQU     1
DataBufferBase                  EQU     0x20  ; Address:0x20 ,bit6:select all bank
ComuSyncTime                    EQU     4     ; 4ms sync header time
ComuTime                        EQU     4     ; 4ms Communicte System
RetryCNT                        EQU     0     ; transmit 0 Times Retry
RX_IDH_DEFAULT                  EQU     0XD6  ; 0X9D  
RX_IDL_DEFAULT                  EQU     0XAC  ; 0XCB  ; Adress_default = [RX_IDH_DEFAULT,RX_IDL_DEFAULT&0x0f]
RX_ComuLoseCNT_Default          EQU     200   ; T=ComuTime+ComuSyncTime*RX_ComuLoseCNT_Default



RX1_LossframeSum                EQU     5
RX2_LossframeSum                EQU     1
RX3_LossframeSum                EQU     1
RX4_LossframeSum                EQU     1
RX5_LossframeSum                EQU     1
RX6_LossframeSum                EQU     1



