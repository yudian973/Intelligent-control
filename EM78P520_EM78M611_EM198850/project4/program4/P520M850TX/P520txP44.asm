/*****************************************************************
* Filename     :  EM78P520_32PIN44PIN_TX.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  4.0
* CRYSTAL      :  8MHZ
* Creat date   :  2009/11/4
* tool Ver.    :  WicePlus 2.7/eUIDE
* Description  :  modify for code conformity,multi-1v2 CMOS project
*****************************************************************/
;-----------------------------------------------------------------
include "D:\include\EM78xx\inc\EM78P520.H"
include "D:\include\EM78xx\inc\EM78Math.H"
include "D:\include\EM78xx\inc\EM78CtrlIns.H"
;include "D:\include\EM78xx\inc\delayfunc.asm"
include "config.h"
include "P520txP44.H"
include "EM198850_For_EM78P520.ASM"
include "P520SkipFreqFunc.ASM"
include "XX93C46_For_EM78P520.ASM"

ifndef CmosSensorDev.ASM
include "CmosSensorDev.ASM"
endif



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
	JBC                 SearchStatusFlag/8,SearchStatusFlag%8
	JMP                 Search_Status_Mode
	JBC                 LoseFrameStatusFlag/8,LoseFrameStatusFlag%8
	JMP                 LoseFrame_Status_Mode
	JBC                 NormalStatusFlag/8,NormalStatusFlag%8
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
		;MOV             A,@0X07                ; N=256,P=256,f=8MHz ==> T=8.192ms
		;MOV             TWTCR,A
		MOV             A,@(256-256)           ; load initial value
		MOV             TCC,A
		BANK            2
		INC             KeySystemTimeCNT
		INC             LEDSystemTimeCNT
		BS              System8msFlag/8,System8msFlag%8
/*
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
  if TCC_T_DEBUG & DebugDisplay == 1
	BANK                0
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
  endif
	INC                 ComuClock
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
  if TIME1_T_DEBUG & DebugDisplay == 1
	MOV                 A,@0B00100000          ; (test)P85 exchange when intrrupt
	XOR                 PORT8,A
  endif
	BANK                2
	MOV                 A,@255                 ; N=256, Auto reload
	MOV                 T1PD,A
	INC                 SleepCNT               ; 2s
	RETI

TIMER2_INT:
	BANK                2
	INC                 IOcheckTimeCNT
  if TIME2_T_DEBUG & DebugDisplay == 1
	BANK                0
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
	NOP
	ClrCommRamBank
	NOP
	ClrRamBank
	NOP
	CALL                IO_INITIAL
	NOP

	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	BS                  LED2_STATUS/8,LED2_STATUS%8
	LCALL               EM198850_RESET
	NOP
	JBC                 CmosInitFinishFlag/8,CmosInitFinishFlag%8
	JMP                 Commu_Status_Inital
	BS                  CMOS_PARAMETER,0
	LCALL               CMOSSensor_Function
	BS                  CmosInitFinishFlag/8,CmosInitFinishFlag%8
	NOP

;==============================================================================
  Commu_Status_Inital:
	LCALL               IO_93C46_INITIAL    ; Set I/O
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS

	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X60
	MOV                 DataAddressInMCU,A
	mREAD               DataAddressInEEPROM,@0,DataAddressInMCU,@16
	mEWDS
	LCALL               IO_93C46_QUIT       ; Set I/O
	BANK                0
	BC                  AT93C46_CS/8,AT93C46_CS%8     ; Disable 93C46
	BS                  SPI_SS/8,SPI_SS%8             ; Disable EM198810
	BS                  CMOS_SS/8,CMOS_SS%8           ; Disable CMOS

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
	NOP
	LCALL               Enter_StandbyII_Mode
	LCALL               CHANGE_ADDRESS_VALUE
	CLR                 CH_NO
	LCALL               RF_FREQ_SET
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
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
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
/*
	LCALL               Search_Equipment
	BANK                0
	BC                  LED1_STATUS/8,LED1_STATUS%8
	LCALL               Normal_Communicate
*/

	LCALL               Cmos_UartDebug_Function

/*
	MOV                 A,@200
	LCALL               DELAY_X100US
	BANK                5
	MOV                 A,@0B00000100
	MOV                 CMOS_PARAMETER,A

	LCALL               CMOSSensor_Function
	;LCALL               ConnectKey_Scan
*/

/*
	BC                  SearchStatusFlag/8,SearchStatusFlag%8
	BS                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8
	BC                  NormalStatusFlag/8,NormalStatusFlag%8
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
  if SPI_FUNCTION == 1
	BANK                2
	MOV                 A,@00000000B   ; Shift left, SDO delay time: 16clk,
	MOV                 SPIS, A        ; disable open-drain
	MOV                 A,@11001001B   ; Data shift out rising edge, is on hold during low
	MOV                 SPIC,A         ; Enable SPI mode, after data output SDO remain low
  endif                                ; SPI Baud Rate: 001->Fosc/4
;--------------------------------------------------------------------
  if UART_FUNCTION == 1
	BANK                4
	BS                  PBIOCR,4       	; PB4(RX) as Input
	BC                  PBIOCR,5        ; PB5(TX) as output
	BANK                5
	BS                  PBPHCR,4        ; PA4(MISO) PULL HIGH

	BANK                3
	MOV                 A,@0B00100000   ; 8-Bit Mode,Fc=8MHz,Baud=38400
	MOV                 URC,A           ; Disable TXE
	MOV                 A,@0B00000000
	MOV                 URS,A           ; disable parity, Odd parity
	BANK                5
	MOV                 A,@0B00100000   ; Enable uart function
	MOV                 UARC2,A
  endif

;============================ TCC config ====================================
	BANK                0
	MOV                 A,@0B00000111
	MOV                 TWTCR,A         ; N=250,P=256,f=8MHz ==> T=8ms
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
	MOV                 A,@0B00000111
	MOV                 T1CR,A           ; N=255, P=128, T=1s
	MOV                 A,@255
	MOV                 T1PD,A           ; N=255, Auto reload
	MOV                 A,@0B00010100
	MOV                 TSR,A            ; 8 bit counter ,f=32.768KHz
	BS                  T1CR,T1EN

;============================ Timer 2 config ===================================
	BANK                0
	BS                  T2CR,T2IE        ; Enable Timier2
	BC                  T2CR,T2IF        ; Clear timer1 intrrupt flag
	BANK                2
	MOV                 A,@0B01000011
	OR                  T2CR,A           ; N=2, P=16, T=4us
	MOV                 A,@IOCheckRate   ; N=, Auto reload
	MOV                 T2PD,A
	BC                  TSR,T2CSS        ; Set Timer2 Clock Source f=8MHz
	BC                  TSR,T1MOD        ; Set 8 Bit Timer
	BC                  T2CR,T2EN        ; Disable
	RET


;*****************************************************************
;Function:    MCU SLEEP SET
;Input:       None
;Output:      None
;*****************************************************************
MCU_EnterSleep_Set:
;========================== Set Timers ==================================
	BANK                0
	BC                  TWTCR,TCCS
	CLR                 IMR             ; Disable Timier1/TCC
	CLR                 T2CR            ; Disable Timeer2
	CLR                 ISR
	BC                  TWTCR,WDTE      ; Disable WDT function
	WDTC
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

;======================== Set Port A/B ===================================
	BANK                4               ;
	MOV                 A,@0B11111111   ; PA As Input
	MOV                 PAIOCR,A        ;
	MOV                 A,@0B11111111   ; PB As Input
	MOV                 PBIOCR,A       	;

	MOV                 A,@0B00000000   ; PA As output
	MOV                 PAIOCR,A        ;
	MOV                 A,@0B00110111   ; PB5 PB4 PB2 PB1 As Input
	MOV                 PBIOCR,A       	;
	BANK                5
	MOV                 A,@0B00000000   ; Disable PA Pull High
	MOV                 PAPHCR,A        ;
	MOV                 A,@0B00110111   ; PB5 PB4 PB2 PB1 Enable Pull High
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
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
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
	BANK                0
	MOV                 A,@0B10000001
	MOV                 IMR,A             ; Enable Timier1/TCC
	CLR                 ISR
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	RET


;*****************************************************************
;Function:    sleep function
;Input:       None
;Output:      None
;*****************************************************************
Enter_Sleep_Status:
	JBS                 IntoSleepFlag/8,IntoSleepFlag%8
	JMP                 SearchSleep_Status_Judge_End
  Sleep_Status_Judeg:
	DISI
	LCALL               RF_SLEEP
	CALL                MCU_EnterSleep_Set
	BANK                0
	BC                  LED1_STATUS/8,LED1_STATUS%8
	ENI
	NOP
	SLEP                                               ; enter Sleep mode
	NOP
	CALL                MCU_WakeUp_Set
;------------------------ initial -------------------------------------
	BANK                0
	BC                  AT93C46_CS/8,AT93C46_CS%8      ; Disable 93C46
	BS                  SPI_SS/8,SPI_SS%8              ; Disable EM198810
	BS                  CMOS_SS/8,CMOS_SS%8            ; Disable CMOS
;-------------------------------------------------------------
	;CALL                SearchLinkMode_Set
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
;-------------------------------------------------------------
	LCALL               EM198850_RESET
	LCALL               RESET_RF_FIFO
	LCALL               Enter_StandbyII_Mode
	LCALL               CHANGE_ADDRESS_VALUE
	LCALL               ENTER_RX_BUFFER_NACK
	CLR                 SleepCNT
SearchSleep_Status_Judge_End:
	BC                  IntoSleepFlag/8,IntoSleepFlag%8
	RET

Disable_ALLdevice:
	BANK                0
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	BS                  CMOS_SS/8,CMOS_SS%8         ; Disable CMOS
	RET


;*****************************************************************
;Function:    mode select
;Input:
;Output:      None
;desciption:  set timing and select mode
;*****************************************************************
SearchLinkMode_Set:         ;0X11
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET

SearchForceLinkMode_Set:    ;0X24
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BS                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BC                  LinkModeFlag/8,LinkModeFlag%8
	BS                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET

NormalLinkMode_Set:         ;0X12
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;Clear search status
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;set normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET

LoseFrameLinkMode_Set:      ;0X16
	BC                  SearchStatusFlag/8,SearchStatusFlag%8            ;Clear search status
	BS                  NormalStatusFlag/8,NormalStatusFlag%8            ;set normal mode
	BS                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BS                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET

LoseFrameForceLinkMode_Set: ;0X25
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;Clear search status
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;set normal mode
	BS                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BC                  LinkModeFlag/8,LinkModeFlag%8
	BS                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BC                  FccTestModeFlag/8,FccTestModeFlag%8
	RET

FccSearchLinkMode_Set:      ;0X41
	BS                  SearchStatusFlag/8,SearchStatusFlag%8            ;set search mode
	BC                  NormalStatusFlag/8,NormalStatusFlag%8            ;Clear normal mode
	BC                  LoseFrameStatusFlag/8,LoseFrameStatusFlag%8      ;Clear LoseFreq mode
	BC                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	BC                  LinkModeFlag/8,LinkModeFlag%8
	BC                  ForceLinkModeFlag/8,ForceLinkModeFlag%8
	BS                  FccTestModeFlag/8,FccTestModeFlag%8
	RET


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