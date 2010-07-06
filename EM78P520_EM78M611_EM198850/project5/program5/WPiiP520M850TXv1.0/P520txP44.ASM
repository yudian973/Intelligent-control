/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.1
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/4
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity
*****************************************************************/
;-----------------------------------------------------------------
include "D:\include\EM78xx\EM78P520.H"
include "D:\include\EM78xx\EM78Math.H"
include "D:\include\EM78xx\EM78CtrlIns.H"
include "config.h"
include "P520txP44.H"
include "EM198850_For_EM78P520.ASM"
include "P520SkipFreqFunc.ASM"
include "XX93C46_For_EM78P520.ASM"
;include "CmosSensorDev.ASM"
;include "FccTest.asm"

;-----------------------------------------------------------------



;--------------------------MAIN PROGRAM---------------------------
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
	JBC                 SearchStatusFlag/16,SearchStatusFlag%16
	JMP                 Search_Status_Mode
	JBC                 LoseFrameStatusFlag/16,LoseFrameStatusFlag%16
	JMP                 LoseFrame_Status_Mode
	JBC                 NormalStatusFlag/16,NormalStatusFlag%16
	JMP                 Normal_Status_Mode
	JMP                 TCC_INT_END
;---------------------------------------------------------------------------
	Normal_Status_Mode:
		;MOV             A,@0x07                ; N=31,P=256,f=8MHz ==> T=1ms
		;MOV             TWTCR,A
		MOV             A,@(256-31)           ; load initial value
		MOV             TCC,A
		JMP             TCC_INT_END
;-------------------------------------------------------------------
	Search_Status_Mode:
		;MOV             A,@0X07                ; N=250,P=256,f=8MHz ==> T=8ms
		;MOV             TWTCR,A
		MOV             A,@(256-250)           ; load initial value
		MOV             TCC,A
		BANK            2
		INC             KeySystemTimeCNT
		INC             LEDSystemTimeCNT
/*
		MOV             A,KeySystemTimeCNT
		SUB             A,@1                   ; Control key scan clock
		JBC             STATUS,C
		JMP             TCC_INT_END
		BS              System16msFlag/16,System16msFlag%16
		CLR             KeySystemTimeCNT
		;BANK            0
		;MOV             A,@0B00100000          ; (test)P85 exchange when intrrupt
		;XOR             PORT8,A
*/
		JMP             TCC_INT_END
;-------------------------------------------------------------------
	LoseFrame_Status_Mode:
		;MOV             A,@0x07                ; N=31,P=256,f=8MHz ==> T=1ms
		;MOV             TWTCR,A
		MOV             A,@(256-31)           ; load initial value
		MOV             TCC,A
		JMP             TCC_INT_END
TCC_INT_END:
	BANK                0
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
	INC                 ComuClock
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
	;MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	;XOR                 PORT8,A
	BANK                2
	MOV                 A,@255                ; N=256, Auto reload
	MOV                 T1PD,A
	INC                 SleepCNT               ; 2s  at a time
	MOV                 A,SleepCNT
	SUB                 A,@SetSleepTime        ;
	JBC                 STATUS,C
	JMP                 TIMER1_INT_END
	BS                  IntoSleepFlag/16,IntoSleepFlag%16
	;BANK                0
	;MOV                 A,@0B00001000          ; (test)P83 exchange when intrrupt
	;XOR                 PORT8,A
	CLR                 SleepCNT
  TIMER1_INT_END:
	NOP
	POP A_Temp,STATUS_Temp,RSR_Temp,@4,A1_Temp,STATUS1_Temp,RSR1_Temp
	RETI

TIMER2_INT:
	PUSH A_Temp,STATUS_Temp,RSR_Temp,@4,A2_Temp,STATUS2_Temp,RSR2_Temp
	BANK                2
	BC                  T2CR,T2IF              ; clear Timer2 interrupt flag
	INC                 IOcheckTimeCNT
	;BANK                0
	;MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	;XOR                 PORT8,A
	POP A_Temp,STATUS_Temp,RSR_Temp,@4,A2_Temp,STATUS2_Temp,RSR2_Temp
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
	CALL                IO_INITIAL
	NOP
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16      ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16              ; Disable EM198810
	LCALL               EM198850_RESET
	NOP
	NOP

;==============================================================================
	LCALL               IO_93C46_INITIAL    ; Set I/O
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16     ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16             ; Disable EM198810
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
	mREAD               DataAddressInEEPROM,@0,DataAddressInMCU,@16
	mEWDS
	LCALL               IO_93C46_QUIT       ; Set I/O
	BC                  AT93C46_CS/16,AT93C46_CS%16     ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16             ; Disable EM198810

	BANK                0
	MOV                 A,RX_IDH_Buffer     ; Read ID
	BANK                1
	MOV                 RX_IDH,A
	BANK                0
	MOV                 A,RX_IDL_Buffer
	BANK                1
	MOV                 RX_IDL,A
	BANK                0
	MOV                 A,TX_ID_Buffer
	BANK                1
	MOV                 TX_ID,A
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16        ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16                ; Disable EM198810


	BANK                1
	MOV                 A,@0XFF             ; judge RX_ID,TX_ID
	XOR                 A,RX_IDH
	JBC                 STATUS,Z
	JMP                 Used_Default_Sync
	MOV                 A,@0XFF
	XOR                 A,RX_IDL
	JBC                 STATUS,Z
	JMP                 Used_Default_Sync
	JMP                 Start_Up
Used_Default_Sync:
	MOV                 A,@RX_IDH_DEFAULT             ; SYNC ,used default 0X0DB3
	MOV                 RX_IDH,A
	MOV                 A,@RX_IDL_DEFAULT
	MOV                 RX_IDL,A

;==============================================================================
Start_Up:
	LCALL               Enter_StandbyII_Mode
	LCALL               CHANGE_ADDRESS_VALUE
	CLR                 CH_NO
	LCALL               RF_FREQ_SET
	LCALL               SUB_RINIT
	LCALL               SUB_ADJ
	NOP

	ENI
	BANK                0
	CLR                 ComuClock
	CLR                 ComuCycleNum
	CLR                 ComuEndNum
	BS                  LED1_STATUS/16,LED1_STATUS%16		     ; PORT81,LED
	BC                  AT93C46_CS/16,AT93C46_CS%16              ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16                      ; Disable EM198810

	CLR                 SleepCNT
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag1
	CLR                 GeneralStatusFlag2
	CLR                 CHN_FLAG

	BANK                2
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
;-----------------------------------------------------------------
	;CALL                SearchLinkMode_Set
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
;-----------------------------------------------------------------
	NOP


;=============================================================================
MAIN:


	LCALL               Search_Equipment
	BANK                0
	BC                  LED1_STATUS/16,LED1_STATUS%16
	LCALL               Normal_Communicate



	;LCALL               ConnectKey_Scan

/*
	BC                  SearchStatusFlag/16,SearchStatusFlag%16
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16
	BC                  NormalStatusFlag/16,NormalStatusFlag%16
*/

/*
	BANK                5
	MOV                 A,@0B00000100
	MOV                 GS_PARAMETER,A
	LCALL               CmosSensor_Function
*/
	;LCALL               Key_Scan
	;LCALL               IO_Rocker_KeyScan
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
	MOV                 A,@0X07         ; N=250,P=256,f=8MHz ==> T=8ms
	MOV                 TWTCR,A
	MOV                 A,@(256-250)    ; load initial value
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
	MOV                 A,@0B00010100    ; 8 bit counter ,f=32.768KHz
	MOV                 TSR,A
	BS                  T1CR,T1EN

;============================ Timer 2 config ===================================
	BANK                0
	BS                  T2CR,T2IE        ; Enable Timier2
	BC                  T2CR,T2IF        ; Clear timer1 intrrupt flag
	BANK                2
	MOV                 A,@0B01000000    ; N=25, P=2, T=50us
	OR                  T2CR,A
	MOV                 A,@50            ; N=25, Auto reload
	MOV                 T2PD,A
	BC                  TSR,T2CSS       ; Set Timer2 Clock Source(Fm)
	BC                  TSR,T1MOD       ; Set 8 Bit Timer
	BC                  T2CR,T2EN       ; Disable

;==============================PORT A/B======================================
	BANK                4		        ; Power On Disable PA PB Pull High
	MOV                 A,@00010000B	; Set PA4 (MISO) as input pin
	MOV                 PAIOCR,A        ; SO,SCK output pin
	MOV                 A,@00110111B	; PB0 PB1 PB2 PB4 PB5 PB1AS INPUT
	MOV                 PBIOCR,A       	; PKT FIFO Output Pin
	BANK                5
	MOV                 A,@00010000B    ; PA4 PULL HIGH
	MOV                 PAPHCR,A
	MOV                 A,@00110111B
	MOV                 PBPHCR,A	    ; PB0 PB2 Enable Pull High
	BANK                0
	CLR                 PORTA           ; PortA output logic "0"
	;CLR                 PORTB          ; PortB output logic "0"
;---------------------------------------------------------
	BANK                2
	MOV                 A,@00000000B   ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS, A        ; disable open-drain
	MOV                 A,@11001001B   ; Data shift out rising edge, is on hold during low
	MOV                 SPIC,A         ; Enable SPI mode, after data output SDO remain low
                                       ; SPI Baud Rate: 001->Fosc/4
;==========================PORT 7/8/9 INITIAL===============================
 	BANK                4
 	MOV                 A,@11110000B
 	MOV                 IOC9,A          ;P97-P94:Input; P93-P90:Ouput
 	MOV                 A,@00000000B
 	MOV                 IOC7,A          ;Set Output
 	MOV                 A,@00000000B
 	MOV                 IOC8,A          ;Set Output
 	BANK                5
 	MOV                 A,@11110000B
 	MOV                 P9PHCR,A		;SET PULL UP
 	BANK                6
 	CLR                 P7ODCR          ;Disable Open Drain
 	CLR                 P8ODCR
 	CLR                 P9ODCR
 	BANK                1
 	MOV                 A,@00000000B	;Disable LCD common dirver pin
 	AND                 LCDSCR0,A
 	AND                 LCDSCR1,A
 	AND                 LCDSCR2,A
	BANK                0
	CLR                 PORT7           ; Port7 output logic "0"
	CLR                 PORT8           ; Port8 output logic "0"
	;CLR                 PORT9           ; Port9 output logic "0"
	BC                  AT93C46_CS/16,AT93C46_CS%16   ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16           ; disable EM198810
	RET


;*****************************************************************
;Function:    MCU SLEEP SET
;Input:       None
;Output:      None
;*****************************************************************
MCU_EnterSleep_Set:
	BANK                0
	CLR                 IMR               ;Disable Timier1/TCC
	CLR                 ISR
	BANK                3
	CLR                 EIESH             ;SET Falling Edge
	BC                  ADCR,ADP
	BANK                1
	MOV                 A,@0B01100000     ;Enable EX6(PB2)/EX5(PB1) Interrupt
	MOV                 EIMR,A
	CLR                 EISR
	BANK                4
	MOV                 A,@0B01100000
	MOV                 WKCR,A            ;enable EX6(PB2)/EX5(PB1) wake up
	BC                  SCCR,IDLE         ;Set IDLE=0(SLEEP MODE)
	BANK                0
	BC                  AT93C46_CS/16,AT93C46_CS%16   ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16           ; disable EM198810
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
	MOV                 A,@0B00000000     ; Disable EX6(PB2)/EX5(PB1) Interrupt
	MOV                 EIMR,A
	CLR                 EISR
	BANK                4
	MOV                 A,@0B00000000
	MOV                 WKCR,A            ; Disable EX6(PB2)/EX5(PB1) wake up
	NOP
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	CLR                 ISR
	BC                  AT93C46_CS/16,AT93C46_CS%16   ; Disable 93C46
	BS                  SPI_SS/16,SPI_SS%16           ; disable EM198810
	RET

;*****************************************************************
;Function:    mode select
;Input:
;Output:      None
;desciption:  set timing and select mode
;*****************************************************************
SearchLinkMode_Set:         ;0X11
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

SearchForceLinkMode_Set:    ;0X24
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

NormalLinkMode_Set:         ;0X12
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

LoseFrameLinkMode_Set:      ;0X16
	BC                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BS                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BS                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

LoseFrameForceLinkMode_Set: ;0X25
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;Clear search status
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;set normal mode
	BS                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BS                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BC                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

FccSearchLinkMode_Set:      ;0X41
	BS                  SearchStatusFlag/16,SearchStatusFlag%16            ;set search mode
	BC                  NormalStatusFlag/16,NormalStatusFlag%16            ;Clear normal mode
	BC                  LoseFrameStatusFlag/16,LoseFrameStatusFlag%16      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/16,EEpromWRStatusFlag%16
	BC                  LinkModeFlag/16,LinkModeFlag%16
	BC                  ForceLinkModeFlag/16,ForceLinkModeFlag%16
	BS                  FccTestModeFlag/16,FccTestModeFlag%16
	RET

