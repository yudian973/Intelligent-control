;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        EM198810_FOR_EM78M611.ASM
;  Description: The Definition of EM78M198810 for EM78612 Registers ;
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7
;=========================================================================
include "Keyscan.H"

ifndef EM78CtrlIns.H
include "EM78CtrlIns.H"
endif
;=========================================================================


	ORG                 0X1100 ;page 4
;**********************************************************************************
;*********************************************************************************
; Connect Key Scan
; Input:
; output: KEY_NUM
;         KeyScanStatusFlag
;*********************************************************************************
ConnectKey_Scan:
	CALL                PAGE4BANK1
	NOP
	MOV                 A,Port9                   ; Port9_2
	AND                 A,@00000100B
	MOV                 TEMP,A
	MOV                 A,@00000100B              ; Bit2
	AND                 KeystokeFlag_Befor,A

Falling_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor      ; bit 3, Check edge
	JBC                 STATUS,Z
	JMP                 Rising_Edge_Judge         ; no edge occur
	MOV                 A,TEMP                    ; Falling edge will change
	XOR                 A,@00000000B
	JBS                 STATUS,Z
	JMP                 Rising_Edge_Judge         ; no falling edge
	JBS                 KeyScanStatusFlag/16,KeyScanStatusFlag%16        ; scan the first falling edge
	BS                  KEY_NUM,0                            ; Will into key scan, Set leader bit
	CLR                 KeystokeTimeCNT                      ; press times ,recalculate
	BC                  KeyStatusFlag/16,KeyStatusFlag%16    ; key status, press(0) or release(1)
	BS                  KeyScanStatusFlag/16,KeyScanStatusFlag%16	     ; into scan key status
	JMP                 Edge_Judge_End

;--------------------------------------------------------------------
Rising_Edge_Judge:
	MOV                 A,TEMP
	XOR                 A,KeystokeFlag_Befor      ; bit 3, Check edge
	JBC                 STATUS,Z
	JMP                 Edge_Judge_End
	MOV                 A,TEMP                    ; rising edge will change
	XOR                 A,@00000100B
	JBS                 STATUS,Z
	JMP                 Edge_Judge_End
	NOP
	CALL                KeyStatus_Low_Scan        ; rising edge ,check low level time
	CLR                 KeystokeTimeCNT           ; press times ,recalculate
	BS                  KeyStatusFlag/16,KeyStatusFlag%16
Edge_Judge_End:
	MOV                 A,TEMP                    ; save currently press key status used for next judge
	MOV                 KeystokeFlag_Befor,A

;------------------------------------------------------------------------------
KeystokeScan_End:                                                   ; a cycle scan end
	JBC                 KEY_NUM,7                                   ; Count overflow
	CLR                 KEY_NUM

	MOV                 A,KeystokeTimeCNT
	SUB                 A,@70                                       ; 70*56ms=3920ms(ComuTime=56ms)
	JBC                 STATUS,C
	INC                 KeystokeTimeCNT                             ; press times ,recalculate

	MOV                 A,KeystokeTimeCNT
	XOR                 A,@17                                       ; 17*56ms=960ms(ComuTime=56ms)
	JBS                 STATUS,Z                                    ;
	RET
	BC                  KeyScanStatusFlag/16,KeyScanStatusFlag%16	            ; more than 800ms ,EXIT scan status
	BS                  KeyScanFinishFlag/16,KeyScanFinishFlag%16
	RET


;=========================================================================
KeyStatus_Low_Scan:     ; rising edge ,check low level time
	MOV                 A,KeystokeTimeCNT
	SUB                 A,@6                       ;6*56ms=320ms(ComuTime=56ms)
	JBC                 STATUS,C                   ;
	JMP                 KeyScan_Short_Press	       ;less than 510ms
	JMP                 KeyScan_Lasting_Press      ;more than 510ms
KeyScan_Short_Press:
	BC                  STATUS,C
	RLC                 KEY_NUM
	RET
KeyScan_Lasting_Press:
	BS                  STATUS,C
	RLC                 KEY_NUM
	RET


