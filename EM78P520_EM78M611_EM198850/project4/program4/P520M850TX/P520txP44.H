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

A_TEMP                          EQU     TEMP4  ;used for PUSH1 and POP1
RSR_TEMP                        EQU     TEMP5
STATUS_TEMP                     EQU     TEMP6

;------------------------------------------------------------------
FccFreqIndex                    EQU     ComuEndNum    ;FCC TEST


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


;======================= BANK 0 (Data Buffer)============================
; bank0 20-3f used for data exchange section
; such as read or write EEPROM and RF,it used for data buffer

;------------------------- header code --------------------------------
PID_DATA_Buffer                 EQU     0X20 ; PID DATA, not used
RX_IDH_Buffer                   EQU     0X21 ; Master IDH
RX_IDL_Buffer                   EQU     0X22 ; Master IDL
CHN_FLAG_Buffer                 EQU     0X23 ; Channel flag, gamepad status
GamePadsSum_Buffer              EQU     0X24 ; Communication trsmitter direction
CommuStatusFlag_Buffer          EQU     0X25
CH_NO_Buffer                    EQU     0X26 ; N_CHN= ((TotalGamepads<<4) & 0xF0)|(CH_NO & 0x0F)

;----------------------- search and connect ---------------------------
TX1_ID_Buffer                   EQU     0X27 ;
TX2_ID_Buffer                   EQU     0X28 ;
TX3_ID_Buffer                   EQU     0X29 ;
TX4_ID_Buffer                   EQU     0X2A ;
TX5_ID_Buffer                   EQU     0X2B ;
TX6_ID_Buffer                   EQU     0X2C ;
;------------------------ Transmitter data ----------------------------
TX_ID_Buffer                    EQU     0X27 ; repeat package data
DataA_Buffer                    EQU     0X28 ;rocker, left-x(left-right) data
DataB_Buffer                    EQU     0X29 ;rocker, left-y(up-down) data
DataC_Buffer                    EQU     0X2A ;rocker, right-x(left-right) data
DataD_Buffer                    EQU     0X2B ;rocker, right-y(up-down) data
DataE_Buffer                    EQU     0X2C ;A,B,C,D,L1,R1,L2,R2
DataF_Buffer                    EQU     0X2D ;Select,start,LSW,RSW,MODE,MACRO,TEST1,TEST2
DataG_Buffer                    EQU     0X2E ;000:00¡¯001:45¡¯010:90¡¯011:135¡¯100:180¡¯101:225¡¯110:270¡¯111:315¡¯

CMOS_xAxisL_Buffer              EQU     0X2F
CMOS_yAxisL_Buffer              EQU     0X30
CMOS_yxsAxisH_Buffer            EQU     0X31

GS_xAxisL_Buffer                EQU     0X32
GS_yAxisL_Buffer                EQU     0X33
GS_zAxisL_Buffer                EQU     0X34
GS_xyzAxisH_Buffer              EQU     0X35
;------------------------- receive data --------------------------------
MOTOR_ID_Buffer                 EQU     0X27
	Motor6CtrlFlag              ==      MOTOR_ID_Buffer*8+5
	Motor5CtrlFlag              ==      MOTOR_ID_Buffer*8+4
	Motor4CtrlFlag              ==      MOTOR_ID_Buffer*8+3
	Motor3CtrlFlag              ==      MOTOR_ID_Buffer*8+2
	Motor2CtrlFlag              ==      MOTOR_ID_Buffer*8+1
	Motor1CtrlFlag              ==      MOTOR_ID_Buffer*8+0
MOTOR1_VibrInten_Buffer         EQU     0X28    ; Motor1 vibration Intensity byte
MOTOR2_VibrInten_Buffer         EQU     0X29    ; Motor2 vibration Intensity byte
MOTOR3_VibrInten_Buffer         EQU     0X2A    ; Motor3 vibration Intensity byte
MOTOR4_VibrInten_Buffer         EQU     0X2B    ; Motor4 vibration Intensity byte
MOTOR5_VibrInten_Buffer         EQU     0X2C    ; Motor5 vibration Intensity byte
MOTOR6_VibrInten_Buffer         EQU     0X2D    ; Motor6 vibration Intensity byte
;--------------------------- CMOS data --------------------------------
CMOS1_xAxisL_Buffer             EQU     0X20    ; Point1 x axis[7..0]
CMOS1_yAxisL_Buffer             EQU     0X21    ; Point1 y axis[7..0]
CMOS1_yxsAxisH_Buffer           EQU     0X22    ; Point1 yAxis[9..8],xAxis[9..8],size[3..0]
CMOS2_xAxisL_Buffer             EQU     0X23    ; Point2 x axis[7..0]
CMOS2_yAxisL_Buffer             EQU     0X24    ; Point2 y axis[7..0]
CMOS2_yxsAxisH_Buffer           EQU     0X25    ; Point2 yAxis[9..8],xAxis[9..8],size[3..0]
CMOS3_xAxisL_Buffer             EQU     0X26    ; Point3 x axis[7..0]
CMOS3_yAxisL_Buffer             EQU     0X27    ; Point3 y axis[7..0]
CMOS3_yxsAxisH_Buffer           EQU     0X28    ; Point3 yAxis[9..8],xAxis[9..8],size[3..0]
CMOS4_xAxisL_Buffer             EQU     0X29    ; Point4 x axis[7..0]
CMOS4_yAxisL_Buffer             EQU     0X2A    ; Point4 y axis[7..0]
CMOS4_yxsAxisH_Buffer           EQU     0X2B    ; Point4 yAxis[9..8],xAxis[9..8],size[3..0]
;--------------------------- GS data ----------------------------------
GS1_xAxisL_Buffer               EQU     0X20    ; x axis low byte
GS1_yAxisL_Buffer               EQU     0X21    ; y axis low byte
GS1_zAxisL_Buffer               EQU     0X22    ; z axis low byte
GS1_xyzAxisH_Buffer             EQU     0X23    ; xAxis[9..8],yAxis[9..8],zAxis[3..0]

;---------------------------- checksum --------------------------------
ChecksumH                       EQU     0X3E
ChecksumL                       EQU     0X3F


;======================= BANK 1 (RF variable)============================
PID_DATA                EQU     0X20
RX_IDH                  EQU     0X21    ; master ID
RX_IDL                  EQU     0X22
CHN_FLAG                EQU     0X23    ; Channel flag, gamepad status
GamepadsSum             EQU     0X24    ; gamepads sum
CH_NO                   EQU     0X25    ; Current frequency table index
TX_ID                   EQU     0X26    ;

;-----------------------------------------------------------------------
ADDR                    EQU     0X30 ;in/out Data Address
VALUE                   EQU     0X31 ;in/out Data
LossframeCNT            EQU     0X32
TABLE_INDEX             EQU     0x33  ;descriptor table's start position
RF_RSSI                 EQU     0X34


;======================= BANK 2 (key data)==============================
DataA                   EQU     0X20 ;rocker left-x(left-right)  RF transmitter data
DataB                   EQU     0X21 ;rocker left-y(up-down)     RF transmitter data
DataC                   EQU     0X22 ;rocker right-x(left-right) RF transmitter data
DataD                   EQU     0X23 ;rocker right-y(up-down)    RF transmitter data
DataE                   EQU     0x24 ;DataA(s10-s5):
                        ;bit7  bit6  Bit5  Bit4  Bit3  bit2  bit1  bit0
                        ;A_1   B_2   C_3   D_4   L1_5  R1_6  L2_7  R2_8
DataF                   EQU     0x25 ;DataB(s4-s1):
                        ;bit7      bit6      Bit5      Bit4   Bit3  bit2    bit1    bit0
                        ;SELECT_9  START_10  TEST2_14  MACRO  MODE  RSW_12  LSW_11  TEST1_13
                        ;MODE: 1:DealWithDigital  0:DealWithAnalog (default:1)
DataG                   EQU     0X26 ;bit[7..4]Hat Switch, bit[3..0]reserve.
                        ;000:00¡¯001:45¡¯010:90¡¯011:135¡¯100:180¡¯101:225¡¯110:270¡¯111:315¡¯

IOcheckRefValue         EQU     0X2A    ; used for Store refrence value
KeyCheckBakup           EQU     0X2B
ComSystemTimeCNT        EQU     0X2C
IOcheckTimeCNT          EQU     0X2D    ; used for count check time
KeySystemTimeCNT        EQU     0x2E    ; key scan time
LEDSystemTimeCNT        EQU     0X2F

KEY_LEFT_X              EQU     0X30 ;rocker,AD convert result left-x(left-right) data
KEY_LEFT_Y              EQU     0X31 ;rocker,AD convert result left-y(up-down) data
KEY_RIGHT_X             EQU     0X32 ;rocker,AD convert result right-x(left-right) data
KEY_RIGHT_Y             EQU     0X33 ;rocker,AD convert result right-y(up-down) data


;       Click                     Dblclick                    Lasting_Press
;________    _______.__________    ______    _______.___________         ____________
;        |__|                  |__|      |__|                   |_______|
;___________                       _________                             ____________
;           |_______._____________|         |________.__________________|

KeystokeFlag_Befor      EQU     0X36
KeystokeTimeCNT         EQU     0X37
KEY_NUM                 EQU     0X38
;F_MODE                  EQU     0X32 ;Analog jugde falg
;F_MODE_BEFOR            EQU     0X33 ;Store keyboard select
KeyTempFlag             EQU     0X39 ;Store LINE4_KEY_INPUT TEMP
	ModeSelFlag         ==      KeyTempFlag*8+4 ;1:analog  0:digital(default 0)
	MacroFlag           ==      KeyTempFlag*8+5
	Test1Flag           ==      KeyTempFlag*8+6
	Test2Flag           ==      KeyTempFlag*8+7

KeyTempBakupFlag        EQU     0X3A
	ModeSelBakupFlag    ==      KeyTempBakupFlag*8+4 ;1:analog  0:digital(default 0)
	MacroBakupFlag      ==      KeyTempBakupFlag*8+5
	Test1BakupFlag      ==      KeyTempBakupFlag*8+6
	Test2BakupFlag      ==      KeyTempBakupFlag*8+7

LINE1_KEY_INPUT_CACHE   EQU     0X3B ;line 1,direction data
LINE2_KEY_INPUT_CACHE   EQU     0X3C ;line 2,X_LINE2 output
LINE3_KEY_INPUT_CACHE   EQU     0X3D ;line 3,X_LINE3 output
LINE4_KEY_INPUT_CACHE   EQU     0X3E ;line 4,X_LINE4 output
LINE5_KEY_INPUT_CACHE   EQU     0X3F ;line 5,X_LINE5 output

;======================= BANK 3 (motor)===============================
MotorVibrInten          EQU     0X20    ; vibration Intensity byte
;MotorVibrDura           EQU     0X21    ; vibration duration byte


;======================= BANK 4 (Push data)=============================
ATcc_TEMP               EQU     0X20  ;used for TCC and POP3
RSRTcc_TEMP             EQU     0X21
StatusTcc_TEMP          EQU     0X22

AExt_TEMP               EQU     0X23  ;used for External and POP3
RSRExt_TEMP             EQU     0X24
StatusExt_TEMP          EQU     0X25

A1_TEMP                 EQU     0X26  ;used for time1 and POP1
RSR1_TEMP               EQU     0X27
STATUS1_TEMP            EQU     0X28

A2_TEMP                 EQU     0X29  ;used for time2 and POP2
RSR2_TEMP               EQU     0X2A
STATUS2_TEMP            EQU     0X2B

;-----------------------------------------------------------
SPIS_TEMP               EQU     0X30
SPIC_TEMP               EQU     0X31

;======================= BANK 5 (CMOS status reg)============================
CMOS_PARAMETER          EQU     0X20
CMOS_STATUS             EQU     0X21
	CMOSInitFlag        ==      CMOS_STATUS*8+0
	CMOSSleepFlag       ==      CMOS_STATUS*8+1
	CMOSGetDataFlag     ==      CMOS_STATUS*8+2

;CMOS1_Covariance        EQU     0X30
;CMOS2_Covariance        EQU     0X31
;CMOS3_Covariance        EQU     0X32
;CMOS4_Covariance        EQU     0X33

CMOS_xAxisH             EQU     0X2D    ; x axis[9..8] high byte,[1..0]
CMOS_yAxisH             EQU     0X2E    ; y axis[9..8] high byte,[1..0]
CMOS_yxsAxisH           EQU     0X2F    ; yAxis[9..8],xAxis[9..8],size[3..0]
CMOS_xAxisL             EQU     0X3D    ; x axis[7..0]
CMOS_yAxisL             EQU     0X3E    ; y axis[7..0]
CMOS_Size               EQU     0X3F    ; size[3..0] high byte,[3..0]

;======================= BANK 6 (CMOS Data)============================
CMOS1_xAxisH            EQU     0X20    ; x axis[9..8] high byte,[1..0]
CMOS1_yAxisH            EQU     0X21    ; y axis[9..8] high byte,[1..0]
CMOS1_yxsAxisH          EQU     0X22    ; yAxis[9..8],xAxis[9..8],size[3..0]
CMOS1_xAxisL            EQU     0X30    ; x axis[7..0]
CMOS1_yAxisL            EQU     0X31    ; y axis[7..0]
CMOS1_Size              EQU     0X32    ; size[3..0] high byte,[3..0]

CMOS2_xAxisH            EQU     0X23    ; x axis[9..8] high byte,[1..0]
CMOS2_yAxisH            EQU     0X24    ; y axis[9..8] high byte,[1..0]
CMOS2_yxsAxisH          EQU     0X25    ; yAxis[9..8],xAxis[9..8],size[3..0]
CMOS2_xAxisL            EQU     0X33    ; x axis[7..0]
CMOS2_yAxisL            EQU     0X34    ; y axis[7..0]
CMOS2_Size              EQU     0X35    ; size[3..0] high byte,[3..0]

CMOS3_xAxisH            EQU     0X26    ; x axis[9..8] high byte,[1..0]
CMOS3_yAxisH            EQU     0X27    ; y axis[9..8] high byte,[1..0]
CMOS3_yxsAxisH          EQU     0X28    ; yAxis[9..8],xAxis[9..8],size[3..0]
CMOS3_xAxisL            EQU     0X36    ; x axis[7..0]
CMOS3_yAxisL            EQU     0X37    ; y axis[7..0]
CMOS3_Size              EQU     0X38    ; size[3..0] high byte,[3..0]

CMOS4_xAxisH            EQU     0X29    ; x axis[9..8] high byte,[1..0]
CMOS4_yAxisH            EQU     0X2A    ; y axis[9..8] high byte,[1..0]
CMOS4_yxsAxisH          EQU     0X2B    ; yAxis[9..8],xAxis[9..8],size[3..0]
CMOS4_xAxisL            EQU     0X39    ; x axis[7..0]
CMOS4_yAxisL            EQU     0X3A    ; y axis[7..0]
CMOS4_Size              EQU     0X3B    ; size[3..0] high byte,[3..0]

;======================= BANK 7 (GS Data)============================
GS_PARAMETER            EQU     0X20
GS_STATUS               EQU     0X21
	GSInitFlag          ==      GS_STATUS*8+0
	GSSleepFlag         ==      GS_STATUS*8+1
	GSGetDataFlag       ==      GS_STATUS*8+2


GS_xAxisL               EQU     0X30    ; x axis low byte
GS_yAxisL               EQU     0X31    ; y axis low byte
GS_zAxisL               EQU     0X32    ; z axis low byte
GS_xyzAxisH             EQU     0X33    ; xAxis[9..8],yAxis[9..8],zAxis[3..0]

GS_xAxisH               EQU     0X34    ; x axis[9..8] high byte,[1..0]
GS_yAxisH               EQU     0X35    ; y axis[9..8] high byte,[1..0]
GS_zAxisH               EQU     0X36    ; z axis[9..8] high byte,[1..0]

