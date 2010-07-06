/*********************************************************************
* Filename     :  EM78P520P44TX.ASM
* Author       :  yu.wei
* Company      :  KEN YEAR
* VERSION      :  4.0
* CRYSTAL      :  8MHZ
* Creat date   :  2010.06.25
* tool Ver.    :  eUIDE 1.02.11
* Description  :  modify for 2.4G remote control in Intelligen Home
**********************************************************************/
;-----------------------------------------------------------------
include "EM78P520.H"
include "config.h"
include "P520txP44.H"




;=======================================================================
;-------------------------- Program start ---------------------------
;=======================================================================
	ORG                 0X0000
	LJMP                INITIAL
	ORG                 0X0003
	LJMP                TCC_INT
	ORG                 0X0006
	LJMP                EXTERNAL_INT
	ORG                 0X0009
	LJMP                WDT_INT
	ORG                 0X000C
	LJMP                TIMER1_INT
	ORG                 0X000F
	LJMP                TIMER2_INT
	ORG                 0X0012
	LJMP                AD_INT
	ORG                 0X0015
	LJMP                UART_INT
	ORG                 0X0018
	LJMP                SPI_INT
	ORG                 0X001B
	LJMP                LVD_INT


;=========================================================================
; Program code
;=========================================================================
	ORG                 0X100
;========================= TCC Interrupt Service =========================
TCC_INT:
	BANK                0
	BC                  ISR,TCIF               ;clear TCC interrupt flag

	MOV                 A,@0B00000111
	MOV                 TWTCR,A         ; N=128,P=256,f=8MHz ==> T=4ms
	MOV                 A,@(256-128)    ; load initial value
	MOV                 TCC,A

	BANK                0
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A

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
	BC                  ISR,T1IF
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
	RETI

TIMER2_INT:
	RETI
UART_INT:
	RETI
SPI_INT:
	RETI
LVD_INT:
	RETI

;==========================================================================
;=========================================================================
INITIAL:
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
	NOP
	WDTC
	
	MOV                 A,@0XD0
	MOV                 RSR,A
  ;$_CLRLOOP:  
	CLR                 R0
	INC                 RSR
	MOV                 A,RSR
	AND                 A,@0X3F
	JBS                 STATUS,Z
	JMP                 $-5             ;$_CLRLOOP
	INC                 BSR
	BS                  RSR,5
	MOV                 A,@0X07
	AND                 BSR,A
	BS                  RSR,6
	JBS                 STATUS,Z
	JMP                 $-12            ;$_CLRLOOP

	NOP
	NOP
	CALL                IO_INITIAL
	NOP

;==============================================================================
Start_Up:
	NOP
	NOP

	BANK                0
	CLR                 ISR              ; clear interrupt flag
	BC                  T2CR,T2IF        ; Clear timer2 intrrupt flag
	ENI
	BANK                0
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	BC                  AT93C46_CS/8,AT93C46_CS%8              ; Disable 93C46
	BS                  SPI_SS/8,SPI_SS%8                      ; Disable EM198810

	CLR                 SleepCNT
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	CLR                 GeneralStatusFlag2
	CLR                 CHN_FLAG
	BS                  LED1_STATUS/8,LED1_STATUS%8		       ; PORT81,LED
	BC                  LED2_STATUS/8,LED2_STATUS%8

	BANK                2
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
;-----------------------------------------------------------------
	;CALL                SearchLinkMode_Set
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
;-----------------------------------------------------------------
	NOP
	NOP

;=============================================================================
MAIN:
	NOP
	NOP
	MOV                 A,@5
	CALL                DELAY_8MHz_X20MS
	NOP

	CALL                Enter_Sleep_Status

	NOP
	NOP
	JMP                 MAIN


;*****************************************************************
;Function:    IO INITIAL SET
;Input:       None
;Output:      None
;*****************************************************************
IO_INITIAL:
;==========================PORT 7/8/9 INITIAL===============================
	BANK                6
	CLR                 P7ODCR          ;Disable Open Drain
	CLR                 P8ODCR
	CLR                 P9ODCR
	BANK                4
	MOV                 A,@0B11111111
	MOV                 IOC7,A          ;Set Input
	MOV                 A,@0B11111111
	MOV                 IOC8,A          ;Set Input
	MOV                 A,@0B11111111
	MOV                 IOC9,A          ;P97-P94:Input; P93-P90:Input
	BANK                5
	MOV                 A,@0B00000000
	MOV                 P7PHCR,A		;Disable PULL UP
	MOV                 A,@0B00000000
	MOV                 P8PHCR,A		;Disable PULL UP
	MOV                 A,@0B11110000
	MOV                 P9PHCR,A		;SET PULL UP

	BANK                4
	MOV                 A,@0B00000000
	MOV                 IOC7,A          ;Set Output
	MOV                 A,@0B00000000
	MOV                 IOC8,A          ;Set Output
	MOV                 A,@0B11110000
	MOV                 IOC9,A          ;P97-P94:Input; P93-P90:Output
	BANK                1
	MOV                 A,@0B00000000	;Disable LCD common dirver pin
	MOV                 LCDSCR0,A
	MOV                 LCDSCR1,A
	MOV                 LCDSCR2,A
	BANK                0
	CLR                 PORT7           ; Port7 output logic "0"
	CLR                 PORT8           ; Port8 output logic "0"
	CLR                 PORT9

;==============================PORT A/B======================================
	BANK                4
	MOV                 A,@0B11111111
	MOV                 PAIOCR,A        ; PA As Input
	MOV                 A,@0B11111111
	MOV                 PBIOCR,A       	; PB As Input
	BANK                5
	MOV                 A,@0B00000000
	MOV                 PAPHCR,A        ; PA4(MISO) PULL HIGH
	MOV                 A,@0B00110111
	MOV                 PBPHCR,A	    ; PB0 PB1 PB2 PB4 PB5 Enable Pull High
	BANK                4
	MOV                 A,@0B00010000	; Set PA4 (MISO) as input pin
	MOV                 PAIOCR,A        ; SO,SCK output pin
	MOV                 A,@0B00110111	; PB0 PB1 PB2 PB4 PB5 PB1AS INPUT
	MOV                 PBIOCR,A       	; PKT FIFO input Pin
	BANK                0
	CLR                 PORTA           ; PortA output logic "0"
	CLR                 PORTB           ; PortB output logic "0"
;------------------------------------------------------------------

	BANK                2
	MOV                 A,@00000000B   ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS, A        ; disable open-drain
	MOV                 A,@11001001B   ; Data shift out rising edge, is on hold during low
	MOV                 SPIC,A         ; Enable SPI mode, after data output SDO remain low
                                       ; SPI Baud Rate: 001->Fosc/4

;============================ TCC config ====================================
	BANK                0
	MOV                 A,@0B00000111
	MOV                 TWTCR,A         ; N=125,P=256,f=8MHz ==> T=4ms
	MOV                 A,@(256-125)    ; load initial value
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
	MOV                 A,@0B00000111
	MOV                 T1CR,A           ; N=128, P=256, T=1s
	MOV                 A,@128
	MOV                 T1PD,A           ; N=128, Auto reload
	MOV                 A,@0B00010000
	MOV                 TSR,A            ; 8 bit counter ,f=32.768KHz
	BC                  TSR,T1EN         ; Start/stop timer1

	RET

;*****************************************************************
;Function:    MCU SLEEP SET
;Input:       None
;Output:      None
;*****************************************************************
MCU_EnterIdle_Set:
;======================== Save power ==============================
	BANK                3
	BC                  ADCR,ADP                    ; Disable ADC Function
	BANK                1
	BS                  SCCR,IDLE                   ; Set IDLE=1(IDLE MODE)
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	
;========================== Set Timers ==================================
	WDTC
	MOV                 A,@0B00001111               ; Disable WDTC /Set Prescale max.
	MOV                 TWTCR,A                     ; N=128,P=256,f=32768Hz ==> T=1s
	MOV                 A,@(256-128)                ; load initial value
	MOV                 TCC,A
	BS                  IMR,TCIE                    ; set   TCIE=1  tcc enable interrupt	
	CLR                 ISR
	RET

;*****************************************************************
;Function:    MCU wakeup SET
;Input:       None
;Output:      None
;*****************************************************************
MCU_WakeUp_Set:
	BANK                0
	CLR                 ISR
	WDTC
	BC                  TWTCR,TCCS	
	MOV                 A,@0B00000111               ; Disable WDTC /Set Prescale max.
	MOV                 TWTCR,A                     ; N=256,P=256,f=8MHz ==> T=4ms
	MOV                 A,@(256-125)                ; load initial value
	MOV                 TCC,A

	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	RET


;*****************************************************************
;Function:    sleep function
;Input:       None
;Output:      None
;description: all device into save power status
;*****************************************************************
Enter_Sleep_Status:

	CALL                MCU_EnterIdle_Set
	NOP
	NOP
	NOP
	SLEP                                               ; Enter Sleep mode
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CALL                MCU_WakeUp_Set
	NOP
	NOP
	RET
	NOP


;===============================================
; Function: Delay 100us
; Input:    None
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_8MHz_X100US:
	MOV                 TEMP1,A
  Delay_Loop_X100US:
	MOV                 A,@196     ;
	MOV                 TEMP2,A
  Waiting_X100US:
	DJZ                 TEMP2
	JMP                 Waiting_X100US
	DJZ                 TEMP1
	JMP                 Delay_Loop_X100US
	RET


;===============================================
; Function: Delay 20ms
; Input:    ACC
; Output:   None
; Crystal:  8MHz
;===============================================
DELAY_8MHz_X20MS:
	MOV                 TEMP2, A
  Delay_Loop_X20MS:
	MOV                 A,@200
	MOV                 TEMP1, A
  Waiting_X20MS:
	MOV                 A,@198
	MOV                 TEMP,A
	DJZ                 TEMP
	JMP                 $-1
	DJZ                 TEMP1
	JMP                 Waiting_X20MS
	DJZ                 TEMP2
	JMP                 Delay_Loop_X20MS
	RET
	
	
	org  0x400
testt:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	END	
	
	