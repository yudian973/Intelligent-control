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
;  Description: PAGE0(0X0000-0X03FF): MCU initial
;               PAGE1(0X0400-0X07FF): searchmode
;               PAGE2(0X0800-0X0BFF): normalmode
;               PAGE3(0X0C00-0X0FFF): RF driver
;               PAGE4(0X1000-0X13FF): key scan driver
;               PAGE5(0X1400-0X17FF): CMOS driver
;               PAGE6(0X1800-0X1BFF): CMOS/GS driver
;               PAGE7(0X1C00-0X1FFF): Kalman Filter arithmetic

;========================================================================
P520txP32P44V11.H                EQU     P520txP32P44V11.H



;========================================================================
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
DataShiftCounter                EQU     0X1B  ;data counter
SleepCNT                        EQU     0X1C  ;data conunter

GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*16+7 ;
	RFInitialOKFlag             ==      GeneralStatusFlag1*16+6
	RFTestFailFlag              ==      GeneralStatusFlag1*16+5
	IntoSleepFlag               ==      GeneralStatusFlag1*16+1
	ToWakeupFlag                ==      GeneralStatusFlag1*16+0

GeneralStatusFlag2              EQU     0X1E
	System16msFlag              ==      GeneralStatusFlag2*16+7
	;System8msFlag               ==      GeneralStatusFlag2*16+6
	KeyScanFinishFlag           ==      GeneralStatusFlag2*16+5
	KeyStatusFlag               ==      GeneralStatusFlag2*16+4
	KeyScanStatusFlag           ==      GeneralStatusFlag2*16+3
	ReadLengthError             ==      GeneralStatusFlag2*16+2

CommuStatusFlag                 EQU     0X1F
	DescriptorFinishFlag        ==      CommuStatusFlag*16+7   ; DESCRIPTOR FINISH(1) OR NOT(USB)
	FccTestModeFlag             ==      CommuStatusFlag*16+6
	ForceLinkModeFlag           ==      CommuStatusFlag*16+5   ; force link flag
	LinkModeFlag                ==      CommuStatusFlag*16+4   ; link flag
	EEpromWRStatusFlag          ==      CommuStatusFlag*16+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*16+2   ; lose frequency and search mode flag
	NormalStatusFlag            ==      CommuStatusFlag*16+1   ; Normal mode Flag
	SearchStatusFlag            ==      CommuStatusFlag*16+0   ; Search mode flag

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
SPI_SS                      ==      PortA*16+7 ;PA7    EM198810/EM198850 enable select
SPI_CLK                     ==      PortA*16+6 ;PA6
SPI_MOSI                    ==      PortA*16+5 ;PA5
SPI_MISO                    ==      PortA*16+4 ;PA4
RESET_N                     ==      PortA*16+3 ;PA3
FIFO_FLAG                   ==      PortA*16+2 ;PB1
PKT_FLAG                    ==      PortB*16+0 ;PB0

CMOS_RST                    ==      PortA*16+1 ;PA1
CMOS_SS                     ==      PortA*16+0 ;PA0

AT93C46_CS                  ==      Port7*16+3 ;4  93c46 enable select

LED1_STATUS                 ==      PORT8*16+1 ;LED
LED2_STATUS                 ==      PORT8*16+2 ;LED

Reference                   ==      7          ;port87
Leakresis                   ==      6          ;port86
LeftYAxis                   ==      0          ;port90  LY
LeftXAxis                   ==      1          ;port91  LX
RightYAxis                  ==      2          ;port92  RY
RightXAxis                  ==      3          ;port93  RX




;======================= BANK 0 (data buffer)============================
; bank0 20-3f used for data exchange section
; such as read or write EEPROM and RF,it used for data buffer

;------------------------------------------------------------------
PID_DATA_Buffer         EQU     0X20    ; PID DATA
RX_IDH_Buffer           EQU     0X21    ; master ID
RX_IDL_Buffer           EQU     0X22
CHN_FLAG_Buffer         EQU     0X23    ; Channel flag, gamepad status
CommuStatusFlag_Buffer  EQU     0X24
DirectionCtrl_Buffer    EQU     0X25    ; Communication trsmitter direction
N_CHN_Buffer            EQU     0X26    ; N_CHN= ((TotalGamepads<<4) & 0xF0)|(CH_NO & 0x0F)
TX_ID_Buffer            EQU     0X26    ; repeat package data

TX1_ID_Buffer           EQU     0X27     ;
TX2_ID_Buffer           EQU     0X28     ;
TX3_ID_Buffer           EQU     0X29     ;
TX4_ID_Buffer           EQU     0X2A     ;
TX5_ID_Buffer           EQU     0X2B     ;
TX6_ID_Buffer           EQU     0X2C     ;
;-----------------------------------------------------------------
DataA_Buffer            EQU     0X27 ;rocker, left-x(left-right) data
DataB_Buffer            EQU     0X28 ;rocker, left-y(up-down) data
DataC_Buffer            EQU     0X29 ;rocker, right-x(left-right) data
DataD_Buffer            EQU     0X2A ;rocker, right-y(up-down) data
DataE_Buffer            EQU     0X2B ;A,B,C,D,L1,R1,L2,R2
DataF_Buffer            EQU     0X2C ;Select,start,LSW,RSW,MODE,MACRO,TEST1,TEST2
DataG_Buffer            EQU     0X2D ;000:00¡¯001:45¡¯010:90¡¯011:135¡¯100:180¡¯101:225¡¯110:270¡¯111:315¡¯

;======================= BANK 1 (RF variable)============================
PID_DATA                EQU     0X20
RX_IDH                  EQU     0X21    ; master ID
RX_IDL                  EQU     0X22
CHN_FLAG                EQU     0X23    ; Channel flag, gamepad status
;CommuStatusFlag
DirectionCtrl           EQU     0X25    ; Communication trsmitter direction
N_CHN                   EQU     0X26    ; N_CHN= ((TotalGamepads<<4) & 0xF0)|(CH_NO & 0x0F)
TX_ID                   EQU     0X26     ;
TX1_ID                  EQU     0X27     ;
TX2_ID                  EQU     0X28     ;
TX3_ID                  EQU     0X29     ;
TX4_ID                  EQU     0X2A     ;
TX5_ID                  EQU     0X2B     ;
TX6_ID                  EQU     0X2C     ;

;-----------------------------------------------------------------
ADDR                    EQU     0X30 ;in/out Data Address
VALUE                   EQU     0X31 ;in/out Data
CH_NO                   EQU     0X32
LossframeCNT            EQU     0X33
TABLE_INDEX             EQU     0x34  ;descriptor table's start position
RF_RSSI                 EQU     0X35


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



KEY_LEFT_X              EQU     0X30 ;rocker,AD convert result left-x(left-right) data
KEY_LEFT_Y              EQU     0X31 ;rocker,AD convert result left-y(up-down) data
KEY_RIGHT_X             EQU     0X32 ;rocker,AD convert result right-x(left-right) data
KEY_RIGHT_Y             EQU     0X33 ;rocker,AD convert result right-y(up-down) data

IOcheckTimeCNT          EQU     0X34 ;used for count check time
KeySystemTimeCNT        EQU     0x35    ;key scan time
KeystokeFlag_Befor      EQU     0X36
KeystokeTimeCNT         EQU     0X37        ;       Click                     Dblclick                    Lasting_Press
                                            ;________    _______.__________    ______    ________.___________         ____________
                                            ;        |__|                  |__|      |__|                    |_______|
KEY_NUM                 EQU     0X38
                                            ;___________                       _________                              ____________
                                            ;           |_______._____________|         |________.___________________|

;F_MODE                  EQU     0X32 ;Analog jugde falg
;F_MODE_BEFOR            EQU     0X33 ;Store keyboard select
KeyTempFlag             EQU     0X39 ;Store LINE4_KEY_INPUT TEMP
	ModeSelFlag         ==      KeyTempFlag*16+4 ;1:analog  0:digital(default 0)
	MacroFlag           ==      KeyTempFlag*16+5
	Test1Flag           ==      KeyTempFlag*16+6
	Test2Flag           ==      KeyTempFlag*16+7

KeyTempBakupFlag        EQU     0X3A
	ModeSelBakupFlag    ==      KeyTempBakupFlag*16+4 ;1:analog  0:digital(default 0)
	MacroBakupFlag      ==      KeyTempBakupFlag*16+5
	Test1BakupFlag      ==      KeyTempBakupFlag*16+6
	Test2BakupFlag      ==      KeyTempBakupFlag*16+7

LINE1_KEY_INPUT_CACHE   EQU     0X3B ;line 1,direction data
LINE2_KEY_INPUT_CACHE   EQU     0X3C ;line 2,X_LINE2 output
LINE3_KEY_INPUT_CACHE   EQU     0X3D ;line 3,X_LINE3 output
LINE4_KEY_INPUT_CACHE   EQU     0X3E ;line 4,X_LINE4 output
LINE5_KEY_INPUT_CACHE   EQU     0X3F ;line 5,X_LINE5 output

;======================= BANK 3 (reserve)===============================



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

;======================= BANK 5 (CMOS Data)============================
CMOS_PARAMETER          EQU     0X20
CMOS_STATUS             EQU     0X21
	CMOSInitFlag        ==      CMOS_STATUS*16+0
	CMOSSleepFlag       ==      CMOS_STATUS*16+1
	CMOSGetDataFlag     ==      CMOS_STATUS*16+2		

CMOS_XPOINT_LOW         EQU     0X22
CMOS_YPOINT_LOW         EQU     0X23
CMOS_POINT_HIGH         EQU     0X24




;======================= BANK 6 (CMOS Data)============================
CMOS_X1_H               EQU     0X20    ; X1[9..8]
CMOS_X1_L               EQU     0X21    ; X1[7..0]
CMOS_Y1_H               EQU     0X22    ; Y1[9..8]
CMOS_Y1_L               EQU     0X23    ; Y1[7..0]
CMOS_Size1              EQU     0X24    ; Size1[3..0]

CMOS_X2_H               EQU     0X20    ; X1[9..8]
CMOS_X2_L               EQU     0X21    ; X1[7..0]
CMOS_Y2_H               EQU     0X22    ; Y1[9..8]
CMOS_Y2_L               EQU     0X23    ; Y1[7..0]
CMOS_Size2              EQU     0X24    ; Size1[3..0]

CMOSDataCNT
;======================= BANK 7 (GS Data)============================
GS_PARAMETER            EQU     0X20
GS_STATUS               EQU     0X21
	GSInitFlag          ==      GS_STATUS*16+0
	GSSleepFlag         ==      GS_STATUS*16+1
	GSGetDataFlag       ==      GS_STATUS*16+2

GS_XPOINT_LOW           EQU     0X22
GS_YPOINT_LOW           EQU     0X23
GS_ZPOINT_LOW           EQU     0X24
GS_POINT_HIGH           EQU     0X35