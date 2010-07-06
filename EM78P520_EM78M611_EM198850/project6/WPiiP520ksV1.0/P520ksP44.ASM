/*****************************************************************
* Filename     :  P520KSP44.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.1
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
	PUSH A_Temp,STATUS_Temp,RSR_Temp,@4,ATcc_Temp,StatusTCC_Temp,RSRTcc_TEMP
	BANK                0
	BC                  ISR,TCIF               ;clear TCC interrupt flag
	;MOV                 A,@0B00001101        ; N=4,P=64,f=32.768K ==> T=8ms
	;MOV                 TWTCR,A
	MOV                 A,@(256-4)           ; reload initial value
	MOV                 TCC,A
	BS                  System8msFlag/16,System8msFlag%16
	;BANK                0
	;MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	;XOR                 PORT8,A
	POP A_Temp,STATUS_Temp,RSR_Temp,@4,ATcc_Temp,StatusTcc_Temp,RSRTcc_TEMP
	RETI

EXTERNAL_INT:
	PUSH A_Temp,STATUS_Temp,RSR_Temp,@4,AExt_Temp,STATUSExt_Temp,RSRExt_Temp
	BANK                1
	CLR                 EISR               ;clear the external interrupt flag
	POP A_Temp,STATUS_Temp,RSR_Temp,@4,AExt_Temp,StatusExt_Temp,RSRExt_Temp
	RETI

WDT_INT:
	RETI

AD_INT:
	RETI

TIMER1_INT:
	PUSH A_Temp,STATUS_Temp,RSR_Temp,@4,A1_Temp,Status1_Temp,RSR1_Temp
	BANK                0
	BC                  ISR,T1IF               ; clear Timer1 interrupt flag
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
	BANK                2
	MOV                 A,@255                ; N=256, Auto reload
	MOV                 T1PD,A
	INC                 SleepCNT               ; 2s  at a time

  TIMER1_INT_END:
	POP A_Temp,STATUS_Temp,RSR_Temp,@4,A1_Temp,STATUS1_Temp,RSR1_Temp
	RETI

TIMER2_INT:
	;PUSH A_Temp,STATUS_Temp,RSR_Temp,@4,A2_Temp,STATUS2_Temp,RSR2_Temp
	PUSH
	BANK                2
	BC                  T2CR,T2IF              ; clear Timer2 interrupt flag
	INC                 IOcheckTimeCNT
	BANK                0
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
	;POP A_Temp,STATUS_Temp,RSR_Temp,@4,A2_Temp,STATUS2_Temp,RSR2_Temp
	POP
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
	NOP
	ClrRamBank
	NOP
	NOP
	CALL                IO_INITIAL
	NOP
	ENI
	NOP

	BANK                0
	BS                  LED1_STATUS/16,LED1_STATUS%16		     ; PORT81,LED
	CLR                 SleepCNT
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	CLR                 GeneralStatusFlag2

	BANK                2
	CLR                 KeySystemTimeCNT
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
	NOP

;=============================================================================
MAIN:

;---------------------------------------------------------------
Key_Status_Judge:
	BANK                2
	MOV                 A,DataA
	XOR                 A,DataB
	XOR                 A,DataC
	XOR                 A,DataD
	XOR                 A,DataE
	XOR                 A,DataF
	XOR                 A,DataG
	MOV                 TEMP,A
	XOR                 A,KeyCheckBakup
	JBS                 STATUS,Z
	JMP                 Sleep_Status_Judge_End1

	MOV                 A,SleepCNT
	SUB                 A,@SetSleepTime        ;
	JBC                 STATUS,C
	JMP                 Sleep_Status_Judge_End2
	BS                  IntoSleepFlag/16,IntoSleepFlag%16

  Sleep_Status_Judge_End1:
	CLR                 SleepCNT
  Sleep_Status_Judge_End2:
	MOV                 A,TEMP
	MOV                 KeyCheckBakup,A

;-----------------------------------------------------------------
	JBS                 IntoSleepFlag/16,IntoSleepFlag%16
	JMP                 Sleep_Status_Judge_End
	NOP
Sleep_Status_Judeg:
	DISI
	CALL                MCU_EnterSleep_Set
	BANK                0
	BC                  LED1_STATUS/16,LED1_STATUS%16
	ENI
	NOP
	SLEP                                                 ; enter Sleep mode
	NOP
	CALL                MCU_WakeUp_Set
	CALL                IO_INITIAL
	NOP
  Sleep_Status_Judge_End:
	BC                  IntoSleepFlag/16,IntoSleepFlag%16
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
	BS                  IMR,T1IE         ; Enable Timier1
	BC                  ISR,T1IF         ; Clear timer1 intrrupt flag
	BANK                2
	MOV                 A,@0B00000111    ; N=255, P=128, T=1s
	MOV                 T1CR,A
	MOV                 A,@255           ; N=255, Auto reload
	MOV                 T1PD,A
	MOV                 A,@0B00010100    ; 8 bit counter, f=32.768KHz
	MOV                 TSR,A
	BS                  T1CR,T1EN

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
	BANK                4               ;
	MOV                 A,@0B11111111   ; PA As Input
	MOV                 PAIOCR,A        ;
	MOV                 A,@0B11111111   ; PB As Input
	MOV                 PBIOCR,A       	;

	MOV                 A,@00000000B    ; PA As output
	MOV                 PAIOCR,A        ;
	MOV                 A,@00001111B    ; PB0 PB1 PB2 PB3 As Input
	MOV                 PBIOCR,A       	;
	BANK                5
	MOV                 A,@00000000B    ; Disable PA Pull High
	MOV                 PAPHCR,A        ;
	MOV                 A,@00001111B    ; PB0 PB1 PB2 PB3 Enable Pull High
	MOV                 PBPHCR,A        ;
	BANK                0
	CLR                 PORTA           ; PortA output logic "0"
	CLR                 PORTB           ; PortB output logic "0"
;------------------------------------------------------------------
	BANK                3
	MOV                 A,@0B00100000   ; 8-Bit Mode,Fc=8MHz,Baud=38400
	MOV                 URC,A           ; Disable TXE
	MOV                 A,@0B00000000
	MOV                 URS,A           ; disable parity, Odd parity
	BANK                5
	MOV                 A,@0B00100000   ; Enable uart function
	MOV                 UARC2,A
	RET


;*****************************************************************
;Function:    MCU SLEEP SET
;Input:       None
;Output:      None
;*****************************************************************
MCU_EnterSleep_Set:
;========================== Set Timers ==================================
	BANK                0
	CLR                 IMR             ; Disable Timier1/TCC
	CLR                 T2CR            ; Disable Timeer2
	CLR                 ISR
	WDTC
	BC                  TWTCR,WDTE      ; Disable WDT function
	MOV                 A,@0B01110111   ;
	OR                  TWTCR,A         ; Set Max Prescale

;======================== Set Port 7/8/9 ===============================
	BANK                6
	CLR                 P7ODCR          ;Disable Open Drain
	CLR                 P8ODCR
	CLR                 P9ODCR
	BANK                4
	MOV                 A,@0B11111111
	MOV                 IOC7,A          ;Set Input
	MOV                 A,@0B00001111
	MOV                 IOC8,A          ;Set Input
	MOV                 A,@0B11111111
	MOV                 IOC9,A          ;P97-P94:Input; P93-P90:Input
	BANK                5
	MOV                 A,@0B11110000
	MOV                 P7PHCR,A		;Disable P77/P76/P75/P74 pull high
	MOV                 A,@0B00000000
	MOV                 P8PHCR,A		;Disable P8 pull high
	MOV                 A,@0B00000000
	MOV                 P9PHCR,A		;Disable P9 pull high
	BANK                4
	MOV                 A,@0B11110000
	MOV                 IOC7,A          ;Set P77/P76/P75/P74 Output
	MOV                 A,@0B00000000
	MOV                 IOC8,A          ;Set Output
	MOV                 A,@0B00000000
	MOV                 IOC9,A          ;P97-P94:Ouput; P93-P90:Ouput
	BANK                0
	CLR                 PORT7
	CLR                 PORT8
	CLR                 PORT9

;======================== Set Port A/B===================================
	BANK                4               ;
	MOV                 A,@0B11111111   ; PA As Input
	MOV                 PAIOCR,A        ;
	MOV                 A,@0B11111111   ; PB As Input
	MOV                 PBIOCR,A       	;

	MOV                 A,@0B00000000   ; PA As output
	MOV                 PAIOCR,A        ;
	MOV                 A,@0B00001111   ; PB0 PB1 PB2 PB3 As Input
	MOV                 PBIOCR,A       	;
	BANK                5
	MOV                 A,@0B00000000   ; Disable PA Pull High
	MOV                 PAPHCR,A        ;
	MOV                 A,@0B00001111   ; PB0 PB1 PB2 PB3 Enable Pull High
	MOV                 PBPHCR,A
	BANK                0
	CLR                 PORTA           ; PortA output logic "0"
	CLR                 PORTB           ; PortB output logic "0"


;======================== set Sleep Mode ==============================
	BANK                3
	BC                  ADCR,ADP          ; Disable ADC
	CLR                 EIESH             ; Set Falling Edge
	BANK                1
	MOV                 A,@0B11111111     ; Enable EX7(PB3)/EX6(PB2)/EX5(PB1)/EX4(PB0) Interrupt
	MOV                 EIMR,A            ; Enable EX3(P77)/EX2(P76)/EX1(P75)/EX0(P74) Interrupt
	CLR                 EISR
	BANK                4
	MOV                 A,@0B11111111
	MOV                 WKCR,A            ; Enable EX7/EX6/EX5/EX4/EX3/EX2/EX1/EX0 wake up
	BC                  SCCR,IDLE         ; Set IDLE=0(SLEEP MODE)
	NOP
	RET

;*****************************************************************
;Function:    MCU wakeup SET
;Input:       None
;Output:      None
;*****************************************************************
MCU_WakeUp_Set:
	BANK                3
	CLR                 EIESH             ; SET Falling Edge
	BANK                1
	MOV                 A,@0B00000000     ; Disable EX7(PB3)/EX6(PB2)/EX5(PB1)/EX4(PB0) Interrupt
	MOV                 EIMR,A            ; Disable EX3(P77)/EX2(P76)/EX1(P75)/EX0(P74) Interrupt
	CLR                 EISR
	BANK                4
	MOV                 A,@0B00000000
	MOV                 WKCR,A            ; Disable EX6(PB2)/EX5(PB1) wake up
	NOP
	RET




