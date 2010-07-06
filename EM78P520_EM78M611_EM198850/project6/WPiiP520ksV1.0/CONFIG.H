/*****************************************************************
* Filename     :  CONFIG.ASM
* Author       :  yu.wei
; Company       : ELAN
; VERSION       : 1.1
; CRYSTAL       : 8MHZ
; Creat date    : 2009/12/3
; tool ver.     : WicePlus 2.7/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
;-------------------------------------------------------------------------
config.h     EQU     config.h

;-------------------------------------------------------------------------
SetSleepTime            EQU     250   ; Into sleep Time=(SetSleepTime+1)*2s. default:250
ADC_FUNCTION            EQU     1    ; 0 -> IO_FUNCTION(default:0)
                                     ; 1 -> ADC_FUNCTION
