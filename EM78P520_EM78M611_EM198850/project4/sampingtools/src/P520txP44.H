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
;  Description: PAGE0(0X0000-0X03FF): MCU initial
;               PAGE1(0X0400-0X07FF): searchmode
;               PAGE2(0X0800-0X0BFF): normalmode
;               PAGE3(0X0C00-0X0FFF): RF driver
;               PAGE4(0X1000-0X13FF): key scan driver
;               PAGE5(0X1400-0X17FF): CMOS driver
;               PAGE6(0X1800-0X1BFF): CMOS/GS driver
;               PAGE7(0X1C00-0X1FFF): Kalman Filter arithmetic

;========================================================================
P520txP44.H                     EQU     P520txP44.H


;--------------------------- function config ----------------------------
TCC_T_DEBUG                     EQU     1
TIME1_T_DEBUG                   EQU     0
TIME2_T_DEBUG                   EQU     0

UART_FUNCTION                   EQU     1 ; disable uart function
SPI_FUNCTION                    EQU     1 ; enable spi function

;===========================================================================
;============================ register config ==============================
;===========================================================================
TEMP                            EQU     0X10
TEMP1                           EQU     0X11
TEMP2                           EQU     0X12
TEMP3                           EQU     0X13
TEMP4                           EQU     0X14
TEMP5                           EQU     0X15
TEMP6                           EQU     0X16

ComuClock                       EQU     0X17  ;communicateion clock
ComuCycleNum                    EQU     0X18  ;communicateion time
ComuEndNum                      EQU     0X19  ;communicateion end time
Databytelength                  EQU     0X1A  ;FIFO READ/WRITE DATA LENGTH
DataShiftCNT                    EQU     0X1B  ;data counter
SleepCNT                        EQU     0X1C  ;data conunter

GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*8+7 ;
	RFInitialOKFlag             ==      GeneralStatusFlag1*8+6
	RFTestFailFlag              ==      GeneralStatusFlag1*8+5
	ReadLengthError             ==      GeneralStatusFlag1*8+4
	CmosInitFinishFlag          ==      GeneralStatusFlag1*8+3   ; DESCRIPTOR FINISH(1) OR NOT(USB)
	IOtoADCcheckFlag            ==      GeneralStatusFlag1*8+2
	IntoSleepFlag               ==      GeneralStatusFlag1*8+1
	ToWakeupFlag                ==      GeneralStatusFlag1*8+0

GeneralStatusFlag2              EQU     0X1E
	;System2sFlag                ==      GeneralStatusFlag2*8+7
	System16msFlag              ==      GeneralStatusFlag2*8+6
	System8msFlag               ==      GeneralStatusFlag2*8+5
	KeyScanFinishFlag           ==      GeneralStatusFlag2*8+3
	KeyStatusFlag               ==      GeneralStatusFlag2*8+2
	KeyScanStatusFlag           ==      GeneralStatusFlag2*8+1
	KeyScanInitFlag             ==      GeneralStatusFlag2*8+0

CommuStatusFlag                 EQU     0X1F
	MotorStatusFlag             ==      CommuStatusFlag*8+7
	FccTestModeFlag             ==      CommuStatusFlag*8+6
	ForceLinkModeFlag           ==      CommuStatusFlag*8+5   ; force link flag
	LinkModeFlag                ==      CommuStatusFlag*8+4   ; link flag
	EEpromWRStatusFlag          ==      CommuStatusFlag*8+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*8+2   ; lose frequency and search mode flag
	NormalStatusFlag            ==      CommuStatusFlag*8+1   ; Normal mode Flag
	SearchStatusFlag            ==      CommuStatusFlag*8+0   ; Search mode flag

;------------------------------------------------------------------
r_acc1                          EQU     TEMP1
r_acc2                          EQU     TEMP2
r_acc3                          EQU     TEMP3
DataAddressInMCU                EQU     TEMP4         ;93C46
DataAddressInEEPROM             EQU     TEMP5



;========================= I/O Port Define ==============================
SPI_SS                          ==      PortA*8+7 ;PA7    EM198810/EM198850 enable select
SPI_CLK                         ==      PortA*8+6 ;PA6
SPI_MOSI                        ==      PortA*8+5 ;PA5
SPI_MISO                        ==      PortA*8+4 ;PA4
RESET_N                         ==      PortA*8+3 ;PA3
FIFO_FLAG                       ==      PortA*8+2 ;PB1
PKT_FLAG                        ==      PortB*8+0 ;PB0

CMOS_RST                        ==      PortA*8+1 ;PA1
CMOS_SS                         ==      PortA*8+0 ;PA0

AT93C46_CS                      ==      Port7*8+3 ;4  93c46 enable select

MOTOR_STATUS                    ==      PORT8*8+4 ;MOTOR CONTROL
LED2_STATUS                     ==      PORT8*8+2 ;LED initial status view
LED1_STATUS                     ==      PORT8*8+1 ;LED running Status view


;======================= BANK 0-6 (Data Buffer)============================

;======================= BANK 7 (setting config)============================

