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
uartcomu.asm     EQU     uartcomu.asm

include "uartcomu.h"
include "keyscan.asm"

;-----------------------------------------------------------------------


	ORG                 0x0400    ;PAGE 1
	MESSAGE "define 'uartcomu.asm' ROM address"
Uart_Commucation:
	NOP
	BANK                2
	JBS                 System8msFlag/16,System8msFlag%16
	JMP                 Uart_Transmit
	BC                  System8msFlag/16,System8msFlag%16
	INC                 KeySystemTimeCNT
	INC                 ComSystemTimeCNT
	MOV                 A,KeySystemTimeCNT
	SUB                 A,@KeyScanTimeCtrl
	JBC                 STATUS,C
	JMP                 Uart_Transmit
	CLR                 KeySystemTimeCNT
	LCALL               Key_Scan

  if COM_T_DEBUG == 1
	BANK                0
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
  endif

;----------------------------------------------------------------------
  Uart_Transmit:
  if COM_DEBUG == 1
	MOV                 A,ComSystemTimeCNT
	SUB                 A,@UartTimeCtrl
	JBC                 STATUS,C
	RET
	CLR                 ComSystemTimeCNT
  endif

  if COM_T_DEBUG == 1
	BANK                0
	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	XOR                 PORT8,A
  endif

	MOV                 A,@0XE0
	MOV                 R4,A
  Uart_Transmit_Loop:
	BANK                2
	MOV                 A,R0
	BANK                3
	BS                  URC,TXE        ; Enable transmission
	NOP
	NOP
	NOP
	MOV                 URTD,A
	NOP
	INC                 R4
	JBS                 URC,UTBE
	JMP                 $-1
	MOV                 A,R4
	XOR                 A,@0XE7        ; Uart Data, bank2: 0X20-0X26
	JBS                 STATUS,Z
	JMP                 Uart_Transmit_Loop
	NOP

	RET






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