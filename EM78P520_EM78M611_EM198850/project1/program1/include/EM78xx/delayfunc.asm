/*****************************************************************
* Filename     :  EM198850 Driver.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL	   :  4MHZ
* Creat date   :  2009/12/17
* tool Ver.    :  WicePlus 2.7/eUIDE v1.01.01
* Description  :  modify for code conformity
*****************************************************************/
delayfunc.asm     EQU     delayfunc.asm

;--------------------------------------------------------------
ifdef EM78P520.H
	ORG                 0x0F90    ;PAGE 4
	MESSAGE "used EM78P520. Define 'delayfunc.asm' ROM address"
elseifdef EM78P468.H
	ORG                 0x0F90    ;PAGE 4
	MESSAGE "used EM78P468. Define 'delayfunc.asm' ROM address"
	
else
	MESSAGE "warning. Undefine 'delayfunc.asm' ROM address by manual"	
endif


;--------------------------------------------------------------

;===============================================
; Function: Delay 20us
; Input:    None
; Output:   None
;===============================================
DELAY_X10US:
	MOV                 TEMP1,A
  Delay_Loop_X10US:
	MOV                 A,@8      ;
	MOV                 TEMP2,A
  Waiting_X10US:
	DJZ                 TEMP2
	JMP                 Waiting_X10US
	DJZ                 TEMP1
	JMP                 Delay_Loop_X10US
	RET
	NOP

;===============================================
; Function: Delay 100us
; Input:    None
; Output:   None
;===============================================
DELAY_X100US:
	MOV                 TEMP1,A
  Delay_Loop:
	MOV                 A,@0X50      ;
	MOV                 TEMP2,A
  Waiting:
	NOP
	DJZ                 TEMP2
	JMP                 Waiting
	DJZ                 TEMP1
	JMP                 Delay_Loop
	RET
	NOP