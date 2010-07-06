;***********************************************************
;File Name: Main
;BODY: 		EM78P520N
;Data:		2009/08/18
;Version: 	1.0
;Author: 	zhaolin
;Company: 	ELAN
;***********************************************************
INCLUDE			"Module_Reg.h"
INCLUDE			"EM78P520.h"
INCLUDE			"Module.asm"
;-----------------------------------------------------------
	ORG			0X00
	JMP			INITIAL
	ORG			0X03
	JMP			TCC_INT
	ORG			0X06
	JMP			EXTERNAL_INT
	ORG			0X09
	JMP			WDT_INT
	ORG			0X0C
	JMP			TIMER1_INT
	ORG			0X0F
	JMP			TIMER2_INT
	ORG			0X12
	JMP			AD_INT
	ORG			0X15
	JMP			UART_INT
	ORG			0X18
	JMP			SPI_INT
	ORG			0X1B
	JMP			LVD_INT

	ORG			0X100
;========================= TCC Interrupt Service ==================================
TCC_INT:
	RETI

EXTERNAL_INT:
WDT_INT:
AD_INT:
TIMER1_INT:
	RETI
TIMER2_INT:
UART_INT:
SPI_INT:
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
	NOP
	CALL        IO_INITIAL
	NOP
	;CALL		ClrRamBank
	NOP
MAIN:
	BANK		6
	;LCALL		GS_Init
	BS			GS_PARAMETER,2
	LCALL		GS_FUNCTION
	JMP			MAIN			
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
	MOV                 A,@0X00
	MOV                 IMR, A        	;set   TCIE=1  tcc enable interrupt
	CLR                 ISR             ;clear interrupt flag
	CLR                 PORTA           ;Porta output logic "0"
	MOV                 A,@0x01
	BANK                1
	CLR                 EISR            	;CLEAR EXTERNAL INTERRUPT STATUS REGISTER
	CLR                 EIMR            	;CLEAR EXTERNAL INTERRUPT MASK  REGISTER

;==================================PORT A/B======================================
	BANK                4		        ; POWER ON DISABLE PA PB PULL HIGH
	MOV                 A,@00010000B	; Set PA4 (SI) as input pin
	MOV                 PAIOCR, A       	; SO,SCK output pin
	MOV                 A,@00000000B	; PB0 PB1 PB2 PB4 PB5 PB1AS INPUT
	MOV                 PBIOCR,A       	; PKT FIFO OUTPUT PIN
	BANK                5
	MOV                 A,@00010000B
	MOV                 PAPHCR,A	    	;PA4 ENABLE PULL HIGH
	BANK                0
	MOV					A,@00001111B
	MOV                 PORTA,A          
	CLR                 PORTB           ; PortB output logic "0"
	BANK                2
	MOV                 A,@00000000B   ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS, A         ; disable open-drain
	MOV                 A,@01001001B   ; Data shift out rising edge, is on hold during low
	MOV                 SPIC, A         ; Enable SPI mode, after data output sdo remain low

;======================PORT 7/8/9 INITIAL==================================
 	BANK                4
 	MOV                 A,@11111111B
 	MOV                 IOC9,A          ;Set Input
 	MOV                 A,@00000000B
 	MOV                 IOC7,A          ;Set Output
 	MOV                 A,@00000000B
 	MOV                 IOC8,A          ;Set Output
 	BANK                5
 	MOV                 A,@11110000B
 	MOV                 P9PHCR,A		;SET PULL UP
 	BANK                6
 	CLR                 PBODCR
 	BANK                1
 	MOV                 A,@00000000B	;Disable LCD common dirver pin
 	AND                 LCDSCR0, A
 	AND                 LCDSCR1, A
 	AND                 LCDSCR2, A
	BANK                0
	CLR                 PORT7           ; Port7 output logic "0"	
	CLR                 PORT8           ; Port8 output logic "0"	
	CLR                 PORT9           ; Port9 output logic "0"	
	RET
	
ClrRamBank:	
	MOV     A, @0XE0        ; 清RAM 初始地址
	MOV     R4, A           ;
	CLR     BSR
	;WDTC
LOOP:
	CLR     R0
	INC     R4
	MOV     A, R4
	AND     A, @0X3F
	JBS     R3, Z
	JMP     LOOP            ; CLEAR_RAM_LOOP_P510
	INC     BSR
	MOV     A, BSR         ; 选择BANK0 (BSR == 0X05)
	AND     A, @0X07
	BS      R4, 5
	BS      R4, 6
	JBS     R3, 2
	JMP     LOOP           ; CLEAR_RAM_LOOP_P510
	CLR     R4
	BS      R4,6
	RET