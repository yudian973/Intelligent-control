/*****************************************************************
* Filename     :  P520ksP44.ASM
* Author       :  yu.wei
* Company      :  ELAN
* VERSION      :  1.1
* CRYSTAL      :  8MHZ
* Creat date   :  2009/13/3
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
P520ksP44.H             EQU     P520ksP44.H
TIMER1_T_DEBUG          EQU     0
TIMER2_T_DEBUG          EQU     0


;========================================================================
TEMP                            EQU     0X10
TEMP1                           EQU     0X11
TEMP2                           EQU     0X12
TEMP3                           EQU     0X13
TEMP4                           EQU     0X14
TEMP5                           EQU     0X15

TPDataLossCNT                   EQU     0X16
ComuClock                       EQU     0X17  ;communicateion clock
ComuCycleNum                    EQU     0X18  ;communicateion time
ComuEndNum                      EQU     0X19  ;communicateion end time
Databytelength                  EQU     0X1A  ;FIFO READ/WRITE DATA LENGTH
DataShiftCounter                EQU     0X1B  ;data counter
SleepCNT                        EQU     0X1C  ;data conunter

GeneralStatusFlag1              EQU     0X1D
	RFInitialFailFlag           ==      GeneralStatusFlag1*8+7 ;
	RFInitialOKFlag             ==      GeneralStatusFlag1*8+6
	RFTestFailFlag              ==      GeneralStatusFlag1*8+5
	ReadLengthError             ==      GeneralStatusFlag1*8+2
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
	DescriptorFinishFlag        ==      CommuStatusFlag*8+7   ; DESCRIPTOR FINISH(1) OR NOT(USB)
	FccTestModeFlag             ==      CommuStatusFlag*8+6
	ForceLinkModeFlag           ==      CommuStatusFlag*8+5   ; force link flag
	LinkModeFlag                ==      CommuStatusFlag*8+4   ; link flag
	EEpromWRStatusFlag          ==      CommuStatusFlag*8+3
	LoseFrameStatusFlag         ==      CommuStatusFlag*8+2   ; lose frequency and search mode flag
	NormalStatusFlag            ==      CommuStatusFlag*8+1   ; Normal mode Flag
	SearchStatusFlag            ==      CommuStatusFlag*8+0   ; Search mode flag

;------------------------------------------------------------------


;========================= I/O Port Define ==============================
LED1_STATUS                 ==      PORT8*8+1 ;LED
LED2_STATUS                 ==      PORT8*8+2 ;LED

TP_SPI_SS                   ==      PORTA*8+7
TP_SPI_SCK                  ==      PORTA*8+6
TP_SPI_MOSI                 ==      PORTA*8+5 ;SDI
TP_SPI_MISO                 ==      PORTA*8+4 ;SDO
TP_SPI_TPREQB               ==      PORTA*8+2


;======================= BANK 0 (data buffer)============================
; bank0 20-3f used for data exchange section
; such as read or write EEPROM and RF,it used for data buffer

;-----------------------------------------------------------------
TPPacket1Byte1          EQU     0X20
TPPacket1Byte2          EQU     0X21  
  P2FS                  ==      TPPacket1Byte2*8+4
  P1FS                  ==      TPPacket1Byte2*8+0  
TPPacket1Byte3          EQU     0X22
TPPacket1Byte4          EQU     0X23

TPPacket2Byte1          EQU     0X24
TPPacket2Byte2          EQU     0X25
TPPacket2Byte3          EQU     0X26
TPPacket2Byte4          EQU     0X27

TPPacket3Byte1          EQU     0X28
TPPacket3Byte2          EQU     0X29
TPPacket3Byte3          EQU     0X2A
TPPacket3Byte4          EQU     0X2B



;======================= BANK 1 (RF variable)============================
ADDR                    EQU     0X30 ;in/out Data Address
VALUE                   EQU     0X31 ;in/out Data


;======================= BANK 2 (key data)==============================
HeaderFrameData         EQU     0X20 ; UART Header Frame Data for Airui Corp.
DataA                   EQU     0X21 ;rocker left-x(left-right)  RF transmitter data
DataB                   EQU     0X22 ;rocker left-y(up-down)     RF transmitter data
DataC                   EQU     0X23 ;rocker right-x(left-right) RF transmitter data
DataD                   EQU     0X24 ;rocker right-y(up-down)    RF transmitter data
DataE                   EQU     0x25 ;DataA(s10-s5):
                        ;bit7  bit6  Bit5  Bit4  Bit3  bit2  bit1  bit0
                        ;A_1   B_2   C_3   D_4   L1_5  R1_6  L2_7  R2_8
DataF                   EQU     0x26 ;DataB(s4-s1):
                        ;bit7      bit6      Bit5      Bit4   Bit3  bit2    bit1    bit0
                        ;SELECT_9  START_10  TEST2_14  MACRO  MODE  RSW_12  LSW_11  TEST1_13
                        ;MODE: 1:DealWithDigital  0:DealWithAnalog (default:1)
DataG                   EQU     0X27 ;bit[7..4]Hat Switch, bit[3..0]reserve.
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



;======================= BANK 6 (CMOS Data)============================



;======================= BANK 7 (GS Data)============================
