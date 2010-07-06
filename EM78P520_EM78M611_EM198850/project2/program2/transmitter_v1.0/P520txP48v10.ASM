/*****************************************************************
* Filename     :  EM78P510_32PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.4
* CRYSTAL	   :  12MHZ
* Creat date   :  2009/4/13
* tool ver.    :  WicePlus 2.7
* Description  :  modify for code conformity
*****************************************************************/
;-----------------------------------------------------------------
include "EM78P520.H"
include "EM78CtrlIns.H"
include "P520txP48v10.H"
include "UARTTest.ASM"
include "MM0200DAdrvOnEM78P520.ASM"
include "BMA020drvOnEM78P520.ASM"


;-----------------------------------------------------------------


;==================================================================
;--------------------------MAIN PROGRAM---------------------------
	ORG                 0X00
	JMP                 INITIAL
	ORG                 0X03
	JMP                 TCC_INT
	ORG                 0X06
	JMP                 EXTERNAL_INT
	ORG                 0X09
	JMP                 WDT_INT
	ORG                 0X0C
	JMP                 TIMER1_INT
	ORG                 0X0F
	JMP                 TIMER2_INT
	ORG                 0X12
	JMP                 AD_INT
	ORG                 0X15
	JMP                 UART_INT
	ORG                 0X18
	JMP                 SPI_INT
	ORG                 0X1B
	JMP                 LVD_INT


	ORG                 0X100
;========================= TCC Interrupt Service ==================================
TCC_INT:
	PUSH
	BANK                0
	BC                  ISR, TCIF				;clear TCC interrupt flag
	MOV                 A,@0B00001110           ; N=25,P=16  Fs=32768  T=12MS
	MOV                 TWTCR,A
	MOV                 A,@(255-50)           ;load initial value
	MOV                 TCC,A
	MOV                 A,@0X80      ; (test)P87 exchange when intrrupt
	XOR                 PORT8,A
	BANK                6
	BS                  TimeDelay12ms/16,TimeDelay12ms%16
	POP
	RETI

EXTERNAL_INT:
	RETI
WDT_INT:
	RETI
AD_INT:
	RETI
TIMER1_INT:
	RETI
TIMER2_INT:
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
	DISI
	NOP
	ClrRamBank
	NOP
	LCALL               IO_INITIAL
	NOP
	ENI
;-------------------------------------------------------------
	BANK                6
	BC                  TimeDelay12ms/16,TimeDelay12ms%16


;=============================================================================
MAIN:
;==================================================================	
	LCALL               UART_Transmit_TEST
	NOP
;-------------------- time delay 12ms ------------------------
Time_Delay_12ms:
	BANK                6
	JBS                 TimeDelay12ms/16,TimeDelay12ms%16	
	JMP                 $-1
	NOP	
	NOP
	BC                  TimeDelay12ms/16,TimeDelay12ms%16
	JMP                 MAIN


;*****************************************************************
;Function:   IO INITIAL SET
;Input:	   None
;Output:	   None
;*****************************************************************
IO_INITIAL:
;================================ TCC config =====================================
	BANK                0
	MOV                 A,@0X07      	;Set  TCCS=0,tcc source=fM,TPSR2~TPSR0=000(1:1)
	MOV                 TWTCR, A
	MOV                 A,@(255-250)
	MOV                 TCC,A			;TCC INITIAL VALUE
	MOV                 A,@0X01
	MOV                 IMR, A        	;set   TCIE=1  tcc enable interrupt
	CLR                 ISR             ;clear interrupt flag
	CLR                 PORTA           ;Porta output logic "0"
	MOV                 A,@0x01
	BANK                1
	CLR                 EISR            	;CLEAR EXTERNAL INTERRUPT STATUS REGISTER
	CLR                 EIMR            	;CLEAR EXTERNAL INTERRUPT MASK  REGISTER

;==================================PORT A/B======================================
	BANK                4		        ; POWER ON DISABLE PA PB PULL HIGH
	MOV                 A,@0B00010000   ; Set PA4(SI) as input pin
	MOV                 PAIOCR,A        ; SO/SCK/RF_SS/GS_SS/CMOS_SS  as output pin

	BANK                2
	MOV                 A,@0B00000000   ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS,A          ; disable open-drain
	MOV                 A,@0B11001001   ; Data shift out falling edge, is on hold during high
	MOV                 SPIC,A          ; Enable SPI mode, after data output sdo remain low

	BANK                3
	MOV                 A,@0B00100000   ; 8-Bit Mode,Fc=12MHz,Baud=57600
	MOV                 URC,A           ; Disable TXE
	MOV                 A,@0B00000000
	MOV                 URS,A           ; disable parity, Odd parity
	BANK                5
	MOV                 A,@0B00100000   ; Enable uart function
	MOV                 UARC2,A
;======================PORT 7/8/9 INITIAL==================================
 	MOV                 A,@0B00000000
 	MOV                 IOC8,A          ;P87(TEST)Output
 	BANK                1
 	MOV                 A,@0B00000000	;Disable LCD common dirver pin
 	AND                 LCDSCR0,A
 	AND                 LCDSCR1,A
 	AND                 LCDSCR2,A
	RET