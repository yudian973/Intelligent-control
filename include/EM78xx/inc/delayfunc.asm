/*****************************************************************
* Filename     :  delay file
* Author       :  yu.wei
* Creat date   :  2009/12/17
* tool Ver.    :  eUIDE v1.02.08/WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/
delayfunc.asm     EQU     delayfunc.asm

;--------------------------------------------------------------

;===============================================
; Function: Delay 20us
; Input:    None
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_8MHz_X10US:
	MOV                 TEMP1,A
  Delay_Loop_X10US:
	MOV                 A,@18      ;
	MOV                 TEMP2,A
  Waiting_X10US:
	DJZ                 TEMP2
	JMP                 Waiting_X10US
	DJZ                 TEMP1
	JMP                 Delay_Loop_X10US
	RET

;===============================================
; Function: Delay 100us
; Input:    None
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_8MHz_X100US:
	MOV                 TEMP1,A
  Delay_Loop:
	MOV                 A,@196     ;
	MOV                 TEMP2,A
  Waiting:
	DJZ                 TEMP2
	JMP                 Waiting
	DJZ                 TEMP1
	JMP                 Delay_Loop
	RET

;===============================================
; Function: Delay 20ms
; Input:    ACC
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_8MHz_X20MS:
	MOV                 TEMP2, A
  Delay1:
	MOV                 A,@200
	MOV                 TEMP1, A
  Delay2:
	MOV                 A,@198
	MOV                 TEMP,A
	DJZ                 TEMP
	JMP                 $-1
	DJZ                 TEMP1
	JMP                 Delay2
	DJZ                 TEMP2
	JMP                 Delay1
	RET

;===============================================
; Function: Delay 20ms
; Input:    ACC
; Output:   None
; crystal:  3.58MHz
;===============================================
DELAY_358MHz_20MS:						;Delay time 20ms
	MOV                 TEMP2, A
  Delay1:
	MOV                 A, @70
	MOV                 TEMP1, A
  Delay2:
	MOV                 A, @85
	MOV                 TEMP0, A
	DJZ                 TEMP0
	JMP                 $-1
	DJZ                 TEMP1
	JMP                 Delay2
	DJZ                 TEMP2
	JMP                 Delay1
	RET