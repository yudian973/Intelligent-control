/*****************************************************************
* Filename     :  P520KSP44.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.1
*              :  v1.2 modify for totuch roker 2010-5-12 15:38:51
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/4
* tool ver.    :  WicePlus 2.7/eUIDE v1.01.01
* Description  :  modify for code conformity
*****************************************************************/
;-----------------------------------------------------------------
include "D:\include\EM78xx\inc\EM78P520.H"
include "D:\include\EM78xx\inc\EM78Math.H"
include "D:\include\EM78xx\inc\EM78CtrlIns.H"
include "config.h"
include "P520ksP44.H"
include "uartcomu.asm"

;-----------------------------------------------------------------



;=================== MAIN PROGRAM =================================
	ORG                 0X00
	LJMP                INITIAL
	ORG                 0X03
	LJMP                TCC_INT
	ORG                 0X06
	LJMP                EXTERNAL_INT
	ORG                 0X09
	LJMP                WDT_INT
	ORG                 0X0C
	LJMP                TIMER1_INT
	ORG                 0X0F
	LJMP                TIMER2_INT
	ORG                 0X12
	LJMP                AD_INT
	ORG                 0X15
	LJMP                UART_INT
	ORG                 0X18
	LJMP                SPI_INT
	ORG                 0X1B
	LJMP                LVD_INT


	ORG                 0X100
;========================= TCC Interrupt Service ==================================
TCC_INT:
	BANK                0
	BC                  ISR,TCIF               ;clear TCC interrupt flag
	;MOV                 A,@0B00001101        ; N=4,P=64,f=32.768K ==> T=8ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-4)           ; reload initial value
	MOV                 TCC,A
	BS                  System8msFlag/8,System8msFlag%8
	;BANK                0
	;MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	;XOR                 PORT8,A
	RETI

EXTERNAL_INT:
	BANK                1
	CLR                 EISR               ;clear the external interrupt flag
	RETI

WDT_INT:
	RETI

AD_INT:
	RETI

TIMER1_INT:
	BANK                0
	BC                  ISR,T1IF               ; clear Timer1 interrupt flag
	RETI

TIMER2_INT:
	BANK                2
	BC                  T2CR,T2IF              ; clear Timer2 interrupt flag
	INC                 IOcheckTimeCNT
	BANK                0
  if TIMER2_T_DEBUG == 1
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
  endif
	RETI
UART_INT:
	RETI
SPI_INT:
	RETI
LVD_INT:
	RETI


;=======================================================================
;============================ Begin Program ============================
INITIAL:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DISI
	NOP
	NOP
	NOP
	DISI
	NOP
	NOP
	NOP
	DISI
	NOP
	WDTC
	ClrCommRamBank
	ClrRamBank
	CALL                IO_INITIAL	
	BANK                0
	MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	XOR                 PORT8,A	
	LCALL               Key_Scan     ;initial keyscan
	NOP
	NOP
	
	BANK                0
	CLR                 ISR
	BC                  T2CR,T2IF        ; Clear timer1 intrrupt flag
	ENI
	NOP

	BANK                0
	BS                  LED1_STATUS/8,LED1_STATUS%8		     ; PORT81,LED
	CLR                 SleepCNT
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	;CLR                 GeneralStatusFlag2

	BANK                2
	CLR                 KeySystemTimeCNT
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
	NOP

;=============================================================================
MAIN:
	;LCALL  Key_Scan
	;NOP
	;JMP    MAIN
;-----------------------------------------------------------------
	LCALL               Uart_Commucation


;-------------------- test ----------------------
	;BANK                0
	;MOV                 A,@0B00000000
	;MOV                 IMR,A             ; Disable Timier1/TCC
	;BANK                2
	;BS                  T2CR,T2EN          ; START

	;LCALL               IO_Rocker_KeyScan
;-----------------------------------------------------

	NOP
	NOP
	NOP
	JMP                 MAIN


;*****************************************************************
;Function:    IO INITIAL SET
;Input:       None
;Output:      None
;*****************************************************************
IO_INITIAL:
;============================ TCC config ====================================
	BANK                0
	MOV                 A,@0B00001101        ; N=4,P=64,f=32.768K ==> T=8ms
	MOV                 TWTCR,A
	MOV                 A,@(256-4)    ; load initial value
	MOV                 TCC,A
	BS                  IMR,TCIE        ; set   TCIE=1  tcc enable interrupt
	CLR                 ISR             ; clear interrupt flag
	BANK                1
	CLR                 EISR            ; Clear External Interrupt Status Register
	CLR                 EIMR            ; Clear External Interrupt Mask  Register

;============================ Timer 1 config ===================================
	BANK                0
	BC                  IMR,T1IE         ; Disable Timier1
	BC                  ISR,T1IF         ; Clear timer1 intrrupt flag
	BANK                2
	MOV                 A,@0B00000111    ; N=255, P=128, T=1s
	MOV                 T1CR,A
	MOV                 A,@255           ; N=255, Auto reload
	MOV                 T1PD,A
	MOV                 A,@0B00010100    ; 8 bit counter, f=32.768KHz
	MOV                 TSR,A
	BC                  T1CR,T1EN       ; Disable

;============================ Timer 2 config ===================================
	BANK                0
	BS                  T2CR,T2IE        ; Enable Timier2
	BC                  T2CR,T2IF        ; Clear timer1 intrrupt flag
	BANK                2
	MOV                 A,@0B01000011    ; N=2, P=16, T=4us
	OR                  T2CR,A
	MOV                 A,@IOCheckRate   ; N=, Auto reload
	MOV                 T2PD,A
	BC                  TSR,T2CSS       ; Set Timer2 Clock Source f=8MHz
	BC                  TSR,T1MOD       ; Set 8 Bit Timer
	BC                  T2CR,T2EN       ; Disable

;==========================PORT 7/8/9 INITIAL===============================
	BANK                1
	MOV                 A,@0B00000000	;Disable LCD common dirver pin
	MOV                 LCDSCR0,A
	MOV                 LCDSCR1,A
	MOV                 LCDSCR2,A
	BANK                6
	CLR                 P7ODCR          ;Disable Open Drain
	CLR                 P8ODCR
	CLR                 P9ODCR
	BANK                0
	CLR                 PORT7           ; Port7 output logic "0"
	CLR                 PORT8           ; Port8 output logic "0"
	CLR                 PORT9
	BANK                4
	MOV                 A,@0B00000000
	MOV                 IOC7,A          ;Set Output
	MOV                 A,@0B00000000
	MOV                 IOC8,A          ;Set Output
	MOV                 A,@0B11110000
	MOV                 IOC9,A          ;P97-P94:Input; P93-P90:Output
	BANK                5
	MOV                 A,@0B00000000
	MOV                 P7PHCR,A		;Disable PULL UP
	MOV                 A,@0B00000000
	MOV                 P8PHCR,A		;Disable PULL UP
	MOV                 A,@0B11110000
	MOV                 P9PHCR,A		;SET PULL UP

;==============================PORT A/B======================================
	BANK                0
	MOV                 A,@01000000B
	MOV                 PORTA,A         ; PortA output logic "0",SCK output high
	MOV                 A,@00110000B
	MOV                 PORTB,A         ; PortB output logic "0"
	BANK                4
	MOV                 A,@00010100B    ; PA As output
	MOV                 PAIOCR,A        ;
	MOV                 A,@00001111B    ; PB0 PB1 PB2 PB3 As Input
	MOV                 PBIOCR,A       	;
	BANK                5
	MOV                 A,@00010100B    ; Disable PA Pull High
	MOV                 PAPHCR,A        ;
	MOV                 A,@00001111B    ; PB0 PB1 PB2 PB3 Enable Pull High
	MOV                 PBPHCR,A        ;


;------------------------------------------------------------------
	BANK                3
	MOV                 A,@0B00100000   ; 8-Bit Mode,Fc=8MHz,Baud=38400
	MOV                 URC,A           ; Disable TXE
	MOV                 A,@0B00000000
	MOV                 URS,A           ; disable parity, Odd parity
	BANK                5
	MOV                 A,@0B00100000   ; Enable uart function
	MOV                 UARC2,A
	NOP
	RET
