;=============================================================================
;=============================================================================
; Filename      : uartcomu.h
; Author        : yu.wei
; Company       : ELAN
; VERSION       : 1.2
; CRYSTAL       : 8MHZ
; Creat date    : 2009/12/3
; tool ver.     : WicePlus 2.7/eUIDE v1.01.01
; descripition  : For EM78P520,used for airui
;=============================================================================
;=============================================================================
uartcomu.h     EQU     uartcomu.h



;-----------------------------------------------------------------------
COM_DEBUG               EQU     1      ; 1:uart delay debug,enable, 0:disable
COM_T_DEBUG             EQU     1      ; 1:Time Test port enable, 0: disable
KeyScanTimeCtrl         EQU     0      ; T=(KeyScanTimeCtrl+1)*8ms             KeyScanTimeCtrl¡Ý0
UartTimeCtrl            EQU     0      ; T=(ComTimeCtrl+1)*8ms, (default:180,Value=0 do the fastest)  
