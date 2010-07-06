/*****************************************************************
* Filename     :  BMA020drvOnEM78P520.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.0
* CRYSTAL      :  12MHZ
* Creat date   :  2009/8/20
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/
;------------------------------------------------------------
UARTTest.ASM    EQU    UARTTest.ASM

include "UARTTest.H"
;include "MODULE.ASM"


;-------------------------------------------------------------------

	ORG                 0X1E00
;====================== Initial GS CMOS =========================
UART_Transmit_TEST:
	BANK                6
	JBC                 InitGSCMOSFlag/16,InitGSCMOSFlag%16
	JMP                 CMOS_FUNCTION_UART
	BS                  InitGSCMOSFlag/16,InitGSCMOSFlag%16
	
GS_Initial:
	BANK                6
	MOV                 A,@0B00000001
	MOV                 GS_PARAMETER,A
	CALL                GS_FUNCTION
	NOP		
CMOS_Initial:
	MOV                 A,@0B00000001
	MOV                 CMOS_PARAMETER,A
	LCALL               CMOS_FUNCTION
	NOP
	
;===================== CMOS MODULE UART ==========================
CMOS_FUNCTION_UART:
	BANK                6
	MOV                 A,@0B00000100
	MOV                 CMOS_PARAMETER,A
	LCALL               CMOS_FUNCTION
	NOP
	
;====================== GS MODULE UART ===========================
GS_FUNCTION_UART:
	BANK                6
	MOV                 A,@0B00000100
	MOV                 GS_PARAMETER,A
	CALL                GS_FUNCTION
	NOP

	BANK                6
	MOV                 A,@0XF0
	MOV                 CMOS_Preamble,A
	MOV                 A,@0X80
	MOV                 CMOS_Command,A
	MOV                 A,@0X03
	MOV                 CMOS_Length,A
	
	MOV                 A,@0XF0
	MOV                 GS_Preamble,A
	MOV                 A,@0X00
	MOV                 GS_Command,A
	MOV                 A,@0X06
	MOV                 GS_Length,A	

	NOP
	MOV                 A,@0XE4
	MOV                 R4,A
	
	
	
UART_Transmit_LOOP:
	BANK                6
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
	XOR                 A,@0XF1        ; UART Bufer 0X24-0X30
	JBS                 STATUS,Z
	JMP                 UART_Transmit_LOOP
	RET