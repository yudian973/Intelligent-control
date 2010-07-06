;==================================================================
; Filename     :  EM78M611
; Author       :  yu.wei
; Company      :  ELAN
; VERSION      :  4.0
; CRYSTAL      :  6MHZ
; Creat date   :  2009/11/4
; tool ver.    :  eUIDE
; Description  :  modify for code conformity,multi-1v2 CMOS project
;=========================================================================
M611rxP40.H.ASM    EQU    M611rxP40.H.ASM

include "D:\include\EM78xx\inc\EM78M611E.H"
include "D:\include\EM78xx\inc\EM78Math.H"
include "D:\include\EM78xx\inc\EM78CtrlIns.H"
include "config.h"
include "M611rxP40.H"
include "EM198850_For_EM78M611.ASM"
include "M611SkipFreqFunc.ASM"
include "M611USBDriver.ASM"
;include "XX24C04.ASM"
;include "FccTest.ASM"

ifndef XX93C46_For_EM78M611.ASM
include "XX93C46_For_EM78M611.ASM"
endif


;=======================================================================
;-------------------------- Program start ---------------------------
;=======================================================================
	ORG                 0X0000
	JMP                 MCU_RESET
	ORG                 0X0001        ; TCC interrupt vector
	PUSH                              ; save ACC,R3,R4
	CLR                 RSR
	JMP                 TCC_INT_STATE

;=========================================================================
; Program code
;=========================================================================
	ORG                 0X0050
TCC_INT_STATE:
	NOP
	JBC                 ISR,EP0IF
	JMP                 USB_EP0_INT
	JBC                 ISR,USBRIF
	JMP                 USB_RESET_INT
	JBC                 ISR,TCCIF
	JMP                 RF_CYCLE_INT
	JBC                 ISR,USBSIF
	JMP                 USB_SUSPEND_INT
RF_CYCLE_INT:
	MOV                 A,@(256-47)  ; N=47,P=64,f=6MHz ==> T=1ms
	MOV                 TCC,A
	BC                  ISR,TCCIF
	INC                 ComuClock    ; 1ms intrrupt and the master timing
	INC                 SystemTimeCNT
  if TCC_T_DEBUG & DebugDisplay == 1
	MOV                 A,@0X80      ; (test)P57 exchange when intrrupt
	XOR                 PORT5,A
  endif
	CALL                PAGE0BANK1
	INC                 RX_ComuLoseCNT
	INC                 KeySystemTimeCNT
	JMP                 INT_RET
USB_EP0_INT:
	PAGE                4
	JMP                 READ_COMMAND ; EP0 Intrrupt flag,wating for Host'CMD
USB_SUSPEND_INT:                     ; USB bus terminated intrrupt
	BC                  ISR,USBSIF
	JMP                 INT_RET
USB_RESET_INT:
	MOV                 A,@0X01
	MOV                 PROTOCOL_TEMP,A
	BC                  ISR,USBRIF
	JMP                 INT_RET
INT_RET:
	POP                              ; restore ACC,R3,R4
	RETI

;========================= START =======================================
MCU_RESET:
	DISI
	MOV                 A,@200          ; delay 20ms
	PAGE                5
	CALL                DELAY_X100US
	PAGE                0
	NOP
	ClrRamBank
;============================ I/O CONFIG ==========================
	MOV                 A,@00110000B    ;set P50 D+/CLOCK, P51 D-/DATA pins input
	IOW                 IOC7
	NOP
	MOV                 A,@00000100B
	IOW                 IOC9
	NOP
	MOV                 A,@00000000B
	IOW                 IOC8
	NOP
	MOV                 A,@00100000B    ;SET P55 INPUT
	IOW                 IOC5
	NOP
	MOV                 A,@01100001B	;SPI_MISO/PKT_FLAG/FIFO_FLAG -> input port
	IOW                 IOC6
	NOP
	MOV                 A,@11110011B	;PULL HIGH PORT92,PORT93
	IOW                 IOCD
	NOP
	MOV                 A,@11010000B	;Disable WDT,PORT (PULL HIGH)
	IOW                 IOCE
	NOP
	MOV                 A,@00000001B	;USB Mode
	IOW                 IOCA
	NOP

;============================ Intrrupt Config ==========================
	MOV                 A,@01101000B		; Disable WDT, TCC clock source is Main CLK   1:64
	CONTW				                    ; TCC 1MS overflow
	CLR                 TCC                 ; Clear TCC
	CLR                 ISR                 ; interrupt flag
	MOV                 A,@00000011B
	IOW                 IMR                 ; enable EP0 interrupt / enable TCC interrupt
	NOP

;=============================== Initial Equipment ==========================
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46
	PAGE                5
	CALL                EM198850_RESET          ;initial RF
	PAGE                0
;-------------------------------------------------------------------------
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46	MOV                 A,@0X00
	MOV                 A,@0X00
	MOV                 DataAddressInEEPROM,A
	MOV                 A,@0X20
	MOV                 DataAddressInMCU,A
	mREAD               DataAddressInEEPROM,@1,DataAddressInMCU,@16
	BS                  SPI_SS/8,SPI_SS%8           ; Disable EM198810
	BC                  AT93C46_CS/8,AT93C46_CS%8   ; Disable 93C46

	CALL                PAGE0BANK0                             ; Save ID
	MOV                 A,RX_IDH_Buffer
	CALL                PAGE0BANK1
	MOV                 RX_IDH,A
	CALL                PAGE0BANK0
	MOV                 A,RX_IDL_Buffer
	CALL                PAGE0BANK1
	MOV                 RX_IDL,A

	CALL                PAGE0BANK0
	MOV                 A,TX1_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX1_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX2_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX2_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX3_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX3_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX4_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX4_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX5_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX5_ID,A
	CALL                PAGE0BANK0
	MOV                 A,TX6_ID_Buffer
	CALL                PAGE0BANK1
	MOV                 TX6_ID,A

;===========================================================================
	CALL                PAGE0BANK1
	MOV                 A,RX_IDH
	XOR                 A,RX_IDL
	JBS                 STATUS,Z
	JMP                 Run_Start  ;if RX_IDH!=RX_IDL will jump
	MOV                 A,RX_IDL
	XOR                 A,@0XFF
	JBC                 STATUS,Z   ;if RX_IDH==RX==0xff set EEpromWRStatusFlag
	BS                  EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
Run_Start:
	JBC                 EEpromWRStatusFlag/8,EEpromWRStatusFlag%8
	CALL                Rand_ID_Function
	PAGE                5
	CALL                Enter_StandbyII_Mode
	CALL                CHANGE_ADDRESS_VALUE
	PAGE                0
	CALL                PAGE0BANK0
	NOP

	ENI
	CLR                 ComuClock
	CLR                 CommuStatusFlag
	CLR                 GeneralStatusFlag2
	CLR                 CHN_FLAG
	CLR                 TEMP
	CALL                PAGE0BANK1

	BS                  KeyStatusFlag/8,KeyStatusFlag%8
	MOV                 A,@0XFF
	MOV                 KeystokeFlag_Befor,A
	MOV                 KeystokeTimeCNT,A
	BC                  LED1_STATUS/8,LED1_STATUS%8
	CALL                SearchLinkMode_Set
	BC                  PORT8,0

 	MOV                 A,@(256-47)  ; N=94,P=64,f=6MHz ==> T=1ms
	MOV                 TCC,A        ; TCC reload by PKT pull high
	CLR                 ComuClock
  if DebugDisplay == 1
	MOV                 A,@0X80      ; (test)P57 exchange when intrrupt
	XOR                 PORT5,A
  endif
 	NOP

;=====================================================================
;======================== MAIN =======================================
;=====================================================================
MAIN:

	PAGE                4
	CALL                USB_MAIN
 	PAGE                0

 /*
	JBS                 USBReportFinishFlag/8,USBReportFinishFlag%8
	JMP                 MAIN
	PAGE                4
	CALL                EP1_Report_Default
	PAGE                0
*/

	CALL                SYNC_COM_TX
	PAGE                1
 	CALL                RX1_FUNCTION
 	CALL                RX2_FUNCTION
	PAGE                0


/*
	PAGE                5
	CALL                RSSI_TEST_FUNCTION
	PAGE                0
*/

	NOP
	JMP                 MAIN


;======================================================================
;Function:     COMMAND TX setting
;Input:        None
;Output:       None
;======================================================================
;========================================================================
; Rand RX_ID and synthesize TX1_ID,TX2_ID...TXx_ID
;========================================================================
Rand_ID_Function:
	MOV                 A,@2
	MOV                 TEMP1,A
	MOV                 A,@0X61
	MOV                 TEMP2,A
	CALL                RAND_FUCTION  ; Creat RX_IDH,RX_IDL

	CALL                PAGE0BANK1
	MOV                 A,RX_IDH
	XOR                 A,@RX_IDH_DEFAULT
	JBS                 STATUS,Z
	JMP                 Creat_TX_ID
	MOV                 A,RX_IDL
	XOR                 A,@RX_IDL_DEFAULT
	JBS                 STATUS,Z
	JMP                 Creat_TX_ID
	JMP                 Rand_ID_Function
  Creat_TX_ID:
	MOV                 A,@0XF0       ; synthesize TX_IDx
	AND                 A,RX_IDL
	MOV                 TX1_ID,A
	MOV                 TX2_ID,A
	MOV                 TX3_ID,A
	MOV                 TX4_ID,A
	MOV                 TX5_ID,A
	MOV                 TX6_ID,A
	MOV                 A,@0X01
	ADD                 TX1_ID,A
	MOV                 A,@0X02
	ADD                 TX2_ID,A
	MOV                 A,@0X03
	ADD                 TX3_ID,A
	MOV                 A,@0X04
	ADD                 TX4_ID,A
	MOV                 A,@0X05
	ADD                 TX5_ID,A
	MOV                 A,@0X06
	ADD                 TX6_ID,A

	CALL                PAGE0BANK1   ; write ID to buffer
	MOV                 A,RX_IDH
	CALL                PAGE0BANK0
	MOV                 RX_IDH_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,RX_IDL
	CALL                PAGE0BANK0
	MOV                 RX_IDL_Buffer,A

	CALL                PAGE0BANK1
	MOV                 A,TX1_ID
	CALL                PAGE0BANK0
	MOV                 TX1_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX2_ID
	CALL                PAGE0BANK0
	MOV                 TX2_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX3_ID
	CALL                PAGE0BANK0
	MOV                 TX3_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX4_ID
	CALL                PAGE0BANK0
	MOV                 TX4_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX5_ID
	CALL                PAGE0BANK0
	MOV                 TX5_ID_Buffer,A
	CALL                PAGE0BANK1
	MOV                 A,TX6_ID
	CALL                PAGE0BANK0
	MOV                 TX6_ID_Buffer,A
	RET

;===================================================================
; Rand Fuction
; Input:       Temp1(Length)
;              Temp2(Base address)  ;
; output:      rang data from temp2 address base
; description: Temp (seed [operand])

;===================================================================
RAND_FUCTION:
	MOV                 TEMP,A
	MOV                 A,TEMP2
	ADD                 TEMP,A        ; save latest data as current seed

	CLR                 RSR
  RAND_SEED_LOOP1:
	MOV                 A,R0
	ADD                 TEMP,A          ; seed
	CALL                ArithmeticIns
	INC                 RSR
	MOV                 A,RSR
	AND                 A,@0X40         ; adding form 0x00 to bank 0
	XOR                 A,@0X40
	JBS                 STATUS,Z
	JMP                 RAND_SEED_LOOP1
	MOV                 A,R0
	ADD                 TEMP,A          ; next seed
  if MassageDisplay == 1
	MESSAGE             "adding form 0x00 to bank 0"
  endif

  RAND_DATA_LOOP1:
	MOV                 A,TEMP2
	MOV                 RSR,A
	MOV                 A,TEMP
	MOV                 R0,A
	CALL                ArithmeticIns
	INC                 TEMP2
	DJZ                 TEMP1
	JMP                 RAND_DATA_LOOP1:
	NOP
	RET

  ArithmeticIns:
	RLC         TEMP          ; X*Y+1 MOD Z
	RLC         TEMP
	RLC         TEMP
	INC         TEMP
	RRC         TEMP
	RRC         TEMP
	RRC         TEMP
	JBS         STATUS,C
	BC          TEMP,0
	JBC         STATUS,C
	BS          TEMP,0
	RET

;=====================================================================
; BANK exchange function
;=====================================================================
	PAGE0BANK0:
		BC              0X04,7
		BC              0X04,6
	RET
	PAGE0BANK1:
		BC              0X04,7
		BS              0X04,6
	RET
	PAGE0BANK2:
		BS              0X04,7
		BC              0X04,6
	RET
	PAGE0BANK3:
		BS              0X04,7
		BS              0X04,6
	RET