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
	JBS                 System8msFlag/8,System8msFlag%8
	JMP                 Uart_Transmit
	BC                  System8msFlag/8,System8msFlag%8
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

	BANK                2
	MOV                 A,@0XA1
	MOV                 HeaderFrameData,A      ; airui UART data header frame
	BANK                0
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
	SUB                 A,@0XE7        ; Uart Data, bank2: 0X20-0X27
	JBC                 STATUS,C
	JMP                 Uart_Transmit_Loop

	;MOV                 A,@2
	;CALL                DELAY_X20MS   ; delay(debug com)
	
	NOP
	NOP
	RET


;===============================================
; Function: Delay 20us
; Input:    None
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_X10US:
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
	NOP

;===============================================
; Function: Delay 100us
; Input:    None
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_X100US:
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
	NOP

;===============================================
; Function: Delay
; Input:    ACC
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_X20MS:
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